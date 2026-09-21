" Make sure this matches the alias defined in ZI_CELEB_BIO
CLASS lhc_CelebrityBio DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR CelebrityBio RESULT result.

    METHODS GenerateQRCode FOR MODIFY
      IMPORTING keys FOR ACTION CelebrityBio~GenerateQRCode RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR CelebrityBio RESULT result.
ENDCLASS.

CLASS lhc_CelebrityBio IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " Grant all authorizations for testing purposes
    result = VALUE #( FOR ls_key IN keys
                      ( %tky = ls_key-%tky
                        %update                = if_abap_behv=>auth-allowed
                        %delete                = if_abap_behv=>auth-allowed
                        %action-Edit           = if_abap_behv=>auth-allowed
                        %action-GenerateQRCode = if_abap_behv=>auth-allowed ) ).
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zi_celeb_bio IN LOCAL MODE
      ENTITY CelebrityBio
      FIELDS ( CelebId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_celeb).

    result = VALUE #( FOR ls_celeb IN lt_celeb
                      ( %tky = ls_celeb-%tky
                        %action-GenerateQRCode = if_abap_behv=>fc-o-enabled ) ).
  ENDMETHOD.

  METHOD GenerateQRCode.
    " 1. Read ONLY the requested biography fields (no project/item tables)
    READ ENTITIES OF zi_celeb_bio IN LOCAL MODE
      ENTITY CelebrityBio
        FIELDS ( FullName DateOfBirth Gender Nationality Profession KnownFor
                 DebutYear BirthPlace Height Instagram Language Country ActiveStatus )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_celebrities).

    DATA: lt_update TYPE TABLE FOR UPDATE zi_celeb_bio.

    " 2. Format payload string with exactly the requested fields
    LOOP AT lt_celebrities INTO DATA(ls_celeb).

      DATA(lv_text) = |🌟 Celebrity Biography 🌟%0A| &&
                      |Name: { ls_celeb-FullName }%0A| &&
                      |DOB: { ls_celeb-DateOfBirth DATE = ISO }%0A| &&
                      |Gender: { ls_celeb-Gender }%0A| &&
                      |Nationality: { ls_celeb-Nationality }%0A| &&
                      |Profession: { ls_celeb-Profession }%0A| &&
                      |Known For: { ls_celeb-KnownFor }%0A| &&
                      |Debut Year: { ls_celeb-DebutYear }%0A| &&
                      |Birth Place: { ls_celeb-BirthPlace }%0A| &&
                      |Height: { ls_celeb-Height }%0A| &&
                      |Instagram: { ls_celeb-Instagram }%0A| &&
                      |Language: { ls_celeb-Language }%0A| &&
                      |Country: { ls_celeb-Country }%0A| &&
                      |Active: { ls_celeb-ActiveStatus }|.

      " Encode spaces to ensure the URL remains valid
      REPLACE ALL OCCURRENCES OF ` ` IN lv_text WITH `%20`.

      " Construct API endpoint
      DATA(lv_qr_url) = |https://api.qrserver.com/v1/create-qr-code/?size=300x300&data={ lv_text }|.

      APPEND VALUE #(
        %tky               = ls_celeb-%tky
        QrCodeUrl          = lv_qr_url
        %control-QrCodeUrl = if_abap_behv=>mk-on
      ) TO lt_update.
    ENDLOOP.

    " 3. Update entity with the new URL
    MODIFY ENTITIES OF zi_celeb_bio IN LOCAL MODE
      ENTITY CelebrityBio
      UPDATE FROM lt_update
      FAILED failed
      REPORTED reported.

    " 4. Return updated instance to refresh the Fiori UI
    READ ENTITIES OF zi_celeb_bio IN LOCAL MODE
      ENTITY CelebrityBio
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_res IN lt_result ( %tky = ls_res-%tky %param = ls_res ) ).
  ENDMETHOD.
ENDCLASS.
