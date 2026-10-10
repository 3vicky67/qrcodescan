CLASS lhc_Celebrity DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Celebrity RESULT result.

    METHODS GenerateQRCode FOR MODIFY
      IMPORTING keys FOR ACTION Celebrity~GenerateQRCode RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Celebrity RESULT result.

    METHODS AutoCreateBio FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Celebrity~AutoCreateBio.

    METHODS earlynumbering_cba_Projects FOR NUMBERING
      IMPORTING entities FOR CREATE Celebrity\_Projects.
ENDCLASS.

CLASS lhc_Celebrity IMPLEMENTATION.

  METHOD get_instance_authorizations.
    result = VALUE #( FOR ls_key IN keys
                      ( %tky                   = ls_key-%tky
                        %update                = if_abap_behv=>auth-allowed
                        %delete                = if_abap_behv=>auth-allowed
                        %action-Edit           = if_abap_behv=>auth-allowed
                        %action-GenerateQRCode = if_abap_behv=>auth-allowed ) ).
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zi_celeb_hdr IN LOCAL MODE
      ENTITY Celebrity
      FIELDS ( CelebId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_celeb).

    result = VALUE #( FOR ls_celeb IN lt_celeb
                      ( %tky                   = ls_celeb-%tky
                        %action-GenerateQRCode = if_abap_behv=>fc-o-enabled ) ).
  ENDMETHOD.

   METHOD GenerateQRCode.
    READ ENTITIES OF zi_celeb_hdr IN LOCAL MODE
      ENTITY Celebrity BY \_Bio
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bios).

    DATA: lt_update TYPE TABLE FOR UPDATE zi_celeb_hdr.

    LOOP AT keys INTO DATA(ls_key).
      LOOP AT lt_bios INTO DATA(ls_bio)
           WHERE %tky-CelebId   = ls_key-%tky-CelebId
             AND %tky-%is_draft = ls_key-%tky-%is_draft.

        DATA(lv_text) = |🌟 Biography 🌟\n| &&
                        |Name: { ls_bio-FullName }\n| &&
                        |DOB: { ls_bio-DateOfBirth+6(2) }-{ ls_bio-DateOfBirth+4(2) }-{ ls_bio-DateOfBirth(4) }\n| &&
                        |Gender: { ls_bio-Gender }\n| &&
                        |Nationality: { ls_bio-Nationality }\n| &&
                        |Profession: { ls_bio-Profession }\n| &&
                        |Known For: { ls_bio-KnownFor }\n| &&
                        |Debut-year: { ls_bio-DebutYear }\n| &&
                        |Birth Place: { ls_bio-BirthPlace }\n| &&
                        |Language: { ls_bio-Language }\n| &&
                        |Active-Status: { ls_bio-ActiveStatusText }|.

        DATA(lv_encoded) = escape( val = lv_text format = cl_abap_format=>e_url ).
        DATA(lv_qr_url) = |https://quickchart.io/qr?size=300x300&text={ lv_encoded }|.
        DATA lv_safe_url TYPE string.
        lv_safe_url = lv_qr_url.

        APPEND VALUE #(
          %tky               = ls_key-%tky
          QrCodeUrl          = lv_safe_url
          %control-QrCodeUrl = if_abap_behv=>mk-on
        ) TO lt_update.

        EXIT.
      ENDLOOP.
    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zi_celeb_hdr IN LOCAL MODE
        ENTITY Celebrity
        UPDATE FROM lt_update
        FAILED failed
        REPORTED reported.
    ENDIF.

    READ ENTITIES OF zi_celeb_hdr IN LOCAL MODE
      ENTITY Celebrity
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated_headers).

    result = VALUE #( FOR ls_header IN lt_updated_headers
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

 METHOD AutoCreateBio.
    READ ENTITIES OF zi_celeb_hdr IN LOCAL MODE
      ENTITY Celebrity
      FIELDS ( CelebId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    DATA: lt_bio_create TYPE TABLE FOR CREATE zi_celeb_hdr\_Bio.

    LOOP AT lt_headers INTO DATA(ls_header).
      APPEND VALUE #(
        %tky    = ls_header-%tky
        %target = VALUE #( (
          %is_draft = ls_header-%is_draft
          CelebId   = ls_header-CelebId
          %cid      = 'CID_BIO_' && ls_header-CelebId
        ) )
      ) TO lt_bio_create.
    ENDLOOP.

    IF lt_bio_create IS NOT INITIAL.
      MODIFY ENTITIES OF zi_celeb_hdr IN LOCAL MODE
        ENTITY Celebrity
        CREATE BY \_Bio
        FROM lt_bio_create.
    ENDIF.
  ENDMETHOD.

   METHOD earlynumbering_cba_Projects.
    DATA: lv_max_item_no TYPE int4.

    LOOP AT entities INTO DATA(ls_parent).
      SELECT SINGLE FROM zceleb_itm
        FIELDS MAX( item_no )
        WHERE celeb_id = @ls_parent-CelebId
        INTO @DATA(lv_active_max).

      SELECT SINGLE FROM zceleb_itm_d
        FIELDS MAX( itemno )
        WHERE celebid = @ls_parent-CelebId
        INTO @DATA(lv_draft_max).

      lv_max_item_no = nmax( val1 = lv_active_max val2 = lv_draft_max ).

      LOOP AT ls_parent-%target INTO DATA(ls_child).
        lv_max_item_no += 1.

        APPEND VALUE #( %cid      = ls_child-%cid
                        %is_draft = ls_child-%is_draft
                        CelebId   = ls_parent-CelebId
                        ItemNo    = lv_max_item_no
                      ) TO mapped-projects.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

" ====================================================================
" NEW CLASS FOR ACTIVITY DETERMINATION (WorkType Dropdown Logic)
" ====================================================================
CLASS lhc_Activity DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS setSongVisibility FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Activity~setSongVisibility.
ENDCLASS.

CLASS lhc_Activity IMPLEMENTATION.
  METHOD setSongVisibility.
    " 1. Read the selected WorkType from the UI
    READ ENTITIES OF zi_celeb_hdr IN LOCAL MODE
      ENTITY Activity
      FIELDS ( WorkType ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_activities).

    " 2. Update the HideSong flag based on the dropdown selection
    " (Using 'SINGING' based on the fixed values defined in your domain)
    MODIFY ENTITIES OF zi_celeb_hdr IN LOCAL MODE
      ENTITY Activity
      UPDATE FIELDS ( HideSong )
      WITH VALUE #( FOR act IN lt_activities (
                      %tky = act-%tky
                      HideSong = COND #( WHEN act-WorkType = 'SINGING'
                                         THEN abap_false
                                         ELSE abap_true )
                  ) ).
  ENDMETHOD.
ENDCLASS.
