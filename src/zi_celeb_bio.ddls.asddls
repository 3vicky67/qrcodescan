@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Celebrity Bio Item View'
define view entity ZI_CELEB_BIO
  as select from zceleb_bio
  
  // Link back to Parent Header
  association to parent ZI_CELEB_HDR as _Header 
    on $projection.CelebId = _Header.CelebId
{
  key celeb_id      as CelebId,
      full_name     as FullName,
      date_of_birth as DateOfBirth,
      gender        as Gender,
      nationality   as Nationality,
      profession    as Profession,
      known_for     as KnownFor,
      debut_year    as DebutYear,
      birth_place   as BirthPlace,
      height        as Height,
      instagram     as Instagram,
      language      as Language,
      country       as Country,
      active_status as ActiveStatus,
      
      last_changed_at as LastChangedAt,

      _Header // Expose parent association
}
