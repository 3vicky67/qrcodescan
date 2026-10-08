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
      
      @ObjectModel.text.element: ['ActiveStatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_STAT_VH', element: 'StatusCode' } }]
      active_status as ActiveStatus,
      
      // --- NEW: Calculate text and color/icon (Criticality) ---
      case active_status
        when 'Y' then 'Yes'
        when 'N' then 'No'
        else 'Unknown'
      end as ActiveStatusText,
      
      case active_status
        when 'Y' then 3 // 3 = Positive (Green)
        when 'N' then 1 // 1 = Negative (Red)
        else 0          // 0 = Neutral (Grey)
      end as StatusCriticality,
      
      last_changed_at as LastChangedAt,

      _Header // Expose parent association
}
