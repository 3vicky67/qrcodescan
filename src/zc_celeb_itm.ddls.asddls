@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Celebrity Item Projection'
@Metadata.allowExtensions: true
define view entity ZC_CELEB_ITM
  as projection on ZI_CELEB_ITM
{
  key CelebId,
  key ItemNo,
      ProjTitle,
      ProjYear,
      Role,
      BoxOffice,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency' } }]
      CurrencyCode,

      _Celebrity : redirected to parent ZC_CELEB_HDR
}
