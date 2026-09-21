@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Celebrity Item View'
define view entity ZI_CELEB_ITM
  as select from zceleb_itm
  association to parent ZI_CELEB_HDR as _Celebrity 
    on $projection.CelebId = _Celebrity.CelebId
{
  key celeb_id      as CelebId,
  key item_no       as ItemNo,
      proj_title    as ProjTitle,
      proj_year     as ProjYear,
      role          as Role,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      box_office    as BoxOffice,
      currency_code as CurrencyCode,

      _Celebrity
}
