@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Celebrity Header Projection'
@Metadata.allowExtensions: true
define root view entity ZC_CELEB_HDR
  provider contract transactional_query
  as projection on ZI_CELEB_HDR
{
  key CelebId,
      ImageUrl,           
      @Semantics.imageUrl: true
      photo,    
      Name,
      DateOfBirth,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Country', element: 'Country' } }]
      @ObjectModel.text.element: ['CountryName']
      @UI.textArrangement: #TEXT_ONLY 
      Country,
      
      CountryName, 
      QrCodeUrl,
      QrCodeFileName,
      LastChangedAt,

      _Projects : redirected to composition child ZC_CELEB_ITM,
      _Bio      : redirected to composition child ZC_CELEB_BIO,
      _Activity : redirected to composition child ZC_CELEB_ACT
}
