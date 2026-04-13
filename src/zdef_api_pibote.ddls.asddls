@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view pibote para API'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZDEF_API_PIBOTE
  as select from ztabla_gen
{
  key user_name
}
