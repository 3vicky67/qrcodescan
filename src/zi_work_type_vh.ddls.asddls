@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Work Type Value Help'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_WORK_TYPE_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZWORK_TYPE' ) 
{
  @ObjectModel.text.element: ['Description']
  key value_low as WorkType,
      text      as Description
}
where language = $session.system_language
