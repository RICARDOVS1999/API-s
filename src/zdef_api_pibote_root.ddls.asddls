@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view pibote para api root'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZDEF_API_PIBOTE_ROOT
  as select from ZDEF_API_PIBOTE
{
  key user_name
}
