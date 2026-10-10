@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Celebrity Root Header View'
define root view entity ZI_CELEB_HDR
  as select from zceleb_hdr
  composition [0..*] of ZI_CELEB_ITM as _Projects
  composition [0..1] of ZI_CELEB_BIO as _Bio
  composition [0..*] of ZI_CELEB_ACT as _Activity // ADDED COMPOSITION DEFINITION HERE
  association [0..1] to I_CountryText as _CountryText 
    on $projection.Country = _CountryText.Country 
    and _CountryText.Language = $session.system_language
{
      key celeb_id        as CelebId,
      image_url           as ImageUrl,       
      
      @Semantics.imageUrl: true
      image_url           as photo,
      name                as Name,
      date_of_birth       as DateOfBirth,

      @ObjectModel.text.element: ['CountryName']
      country             as Country,
      
      cast( _CountryText.CountryName as abap.char(50) ) as CountryName,
      qr_code_url         as QrCodeUrl,
      concat(celeb_id, '.txt') as QrCodeFileName,
      last_changed_at     as LastChangedAt,
      
      _Projects,
      _Bio,
      _Activity
}
