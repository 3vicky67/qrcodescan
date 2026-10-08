@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Active Status'
@ObjectModel.resultSet.sizeCategory: #XS 
@Metadata.ignorePropagatedAnnotations: true // <-- Added this annotation to fix the error
define view entity ZI_STAT_VH 
  as select from I_Language 
{
      @UI.hidden: true
  key cast( 'Y' as abap.char(1) ) as StatusCode,
      cast( 'Yes' as abap.char(10) ) as StatusText
} where Language = 'E' 

union all

select from I_Language 
{
  key cast( 'N' as abap.char(1) ) as StatusCode,
      cast( 'No' as abap.char(10) ) as StatusText
} where Language = 'E'
