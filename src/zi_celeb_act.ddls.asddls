@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Celebrity Extra Activity View'
define view entity ZI_CELEB_ACT
  as select from zceleb_act
  association to parent ZI_CELEB_HDR as _Header on $projection.CelebId = _Header.CelebId
{
  key activity_id       as ActivityId,
  key celeb_id          as CelebId,
      worked_movie      as WorkedMovie,
      work_type         as WorkType,
      music_composer    as MusicComposer,
      release_date      as ReleaseDate,
      hide_song         as HideSong,

      @Semantics.largeObject: {
          mimeType: 'SongMimetype',
          fileName: 'SongFilename',
          contentDispositionPreference: #INLINE
      }
      song_file         as SongFile,
      @Semantics.mimeType: true
      song_mimetype     as SongMimetype,
      song_filename     as SongFilename,
      
      local_last_changed_at as LocalLastChangedAt,

      _Header
}
