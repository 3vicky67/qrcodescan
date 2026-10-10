@EndUserText.label: 'Celebrity Extra Activity Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_CELEB_ACT
  as projection on ZI_CELEB_ACT
{
  key ActivityId,
  key CelebId,
      WorkedMovie,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_WORK_TYPE_VH', element: 'WorkType' } }]
      WorkType,
      
      ReleaseDate,
      
      HideSong, // Expose flag for UI control
      
      @UI.hidden: #(HideSong)
      MusicComposer, // <-- ADD THIS (Dynamically hidden based on the flag)

      @UI.hidden: #(HideSong)
      SongFile,
      
      @UI.hidden: #(HideSong)
      SongMimetype,
      
      @UI.hidden: #(HideSong)
      SongFilename,
      
      LocalLastChangedAt,
      _Header : redirected to parent ZC_CELEB_HDR
}
