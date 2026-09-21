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
      @UI.textArrangement: #TEXT_ONLY // Shows "India" instead of "IN" or "IN (India)"
      Country,
      
      CountryName, // Ensure the text field is exposed in the projection
      
      @Semantics.imageUrl: true
      QrCodeUrl,
      LastChangedAt,

      _Projects : redirected to composition child ZC_CELEB_ITM,
      _Bio      : redirected to composition child ZC_CELEB_BIO
}

