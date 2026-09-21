@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Celebrity Biography Projection'
@Metadata.allowExtensions: true
define view entity ZC_CELEB_BIO
  as projection on ZI_CELEB_BIO
{
  key CelebId,
      FullName,
      DateOfBirth,
      Gender,
      Nationality,
      Profession,
      KnownFor,
      DebutYear,
      BirthPlace,
      Height,
      Instagram,
      Language,
      Country,
      ActiveStatus,
      LastChangedAt,
      _Header : redirected to parent ZC_CELEB_HDR
}
