@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Celebrity Root Header View'
define root view entity ZI_CELEB_HDR
  as select from zceleb_hdr
  composition [0..*] of ZI_CELEB_ITM as _Projects
  composition [0..1] of ZI_CELEB_BIO as _Bio
  association [0..1] to I_CountryText as _CountryText 
    on $projection.Country = _CountryText.Country 
    and _CountryText.Language = $session.system_language
{
      key celeb_id        as CelebId,
      // 1. Keep original name (Used for typing and mapping)
      image_url           as ImageUrl,       
      // 2. Duplicate field purely for projecting the image
      @Semantics.imageUrl: true
      image_url           as photo,
      name            as Name,
      date_of_birth   as DateOfBirth,

      @ObjectModel.text.element: ['CountryName']
      country         as Country,
      
      // Cast the unreleased data element to a standard ABAP type
      cast( _CountryText.CountryName as abap.char(50) ) as CountryName,
      // REMOVED: @Semantics.imageUrl: true
      qr_code_url         as QrCodeUrl,
      
      // ADDED: Dynamically generate the filename (e.g., "01.txt")
      concat(celeb_id, '.txt') as QrCodeFileName,
      
      last_changed_at as LastChangedAt,
      

      _Projects,
      _Bio
}
