CLASS lhc_ZDEF_API_PIBOTE_ROOT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zdef_api_pibote_root RESULT result.

    METHODS action_1 FOR MODIFY
      IMPORTING keys FOR ACTION zdef_api_pibote_root~action_1 RESULT result.

ENDCLASS.

CLASS lhc_ZDEF_API_PIBOTE_ROOT IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD action_1.

    CONSTANTS lc_cid_ref TYPE string VALUE 'API_Z'.

    DATA:
      lt_keys                        TYPE TABLE FOR CREATE A_FunctionalLocation,
      lt_keys_update                 TYPE TABLE FOR UPDATE A_FunctionalLocation,
      lt_key_FuncnlLocClfnCharValue  TYPE TABLE FOR CREATE A_FuncnlLocClfnCharValue,
      lt_keys_SetFuncnlLocationToIna TYPE TABLE FOR ACTION IMPORT A_FunctionalLocation~SetFuncnlLocationToInactive,
      lt_keys_InstallFunLocation     TYPE TABLE FOR ACTION IMPORT A_FunctionalLocation~InstallFunctionalLocation.

    ASSIGN keys[ 1 ] TO FIELD-SYMBOL(<fs_key>).

*----------------POST/FunctionalLocation
    lt_keys = VALUE #( ( %cid = lc_cid_ref
                         FunctionalLocation = <fs_key>-%param-functional_location
                         FuncLocationStructure = <fs_key>-%param-funclocationstructure
                         FunctionalLocationCategory = <fs_key>-%param-functionallocationcategory
                         %control = VALUE #( FunctionalLocation         = if_abap_behv=>mk-on
                                             FuncLocationStructure      = if_abap_behv=>mk-on
                                             FunctionalLocationCategory = if_abap_behv=>mk-on )
                        )
                       ).

    MODIFY ENTITY A_FunctionalLocation
    CREATE FROM lt_keys
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported)
    MAPPED DATA(lt_mapped).
    IF lt_failed IS INITIAL.

*----------------PATCH/FunctionalLocation
      lt_keys_update = VALUE #( ( %tky-%key-FunctionalLocation = <fs_key>-%param-functional_location
                                   GrossWeight = '100'
                                   GrossWeightUnit  = 'KG'
                                   %control = VALUE #( GrossWeight     = if_abap_behv=>mk-on
                                                       GrossWeightUnit = if_abap_behv=>mk-on
                                                      )
                                    )
                                   ).

      MODIFY ENTITY A_FunctionalLocation
      UPDATE FROM lt_keys_update
      FAILED lt_failed
      REPORTED lt_reported
      MAPPED lt_mapped.
      IF lt_failed IS INITIAL.
        APPEND VALUE #(
                  %tky = <fs_key>-%tky
                  %msg = new_message(
                    id       = 'ZAPI_INPUT_FIELDS'
                    number   = '001'
                    severity = if_abap_behv_message=>severity-error
*                          v1       = 'Error en API externa'
                  )
        ) TO reported-zdef_api_pibote_root.

        APPEND VALUE #( %tky =  <fs_key>-%tky ) TO failed-zdef_api_pibote_root.
        RETURN.
      ENDIF.

*----------------POST/Characteristic
      lt_key_funcnllocclfncharvalue = VALUE #( ( %cid = lc_cid_ref
                                                 FunctionalLocation = <fs_key>-%param-functional_location
                                                 ClassInternalID = ''
                                                 CharcInternalID = ''
                                                 ClassType = ''
                                                 CharcValuePositionNumber = ''
                                                 Characteristic = ''
                                                 CharcDataType = ''
                                                 %control = VALUE #( FunctionalLocation = if_abap_behv=>mk-on
                                                                     ClassInternalID    = if_abap_behv=>mk-on
                                                                     CharcInternalID    = if_abap_behv=>mk-on
                                                                     ClassType          = if_abap_behv=>mk-on
                                                                     CharcValuePositionNumber = if_abap_behv=>mk-on
                                                                     Characteristic = if_abap_behv=>mk-on
                                                                     CharcDataType  = if_abap_behv=>mk-on
                                                                    )
                                                  ) ).

      MODIFY ENTITY A_FuncnlLocClfnCharValue
      CREATE FROM lt_key_FuncnlLocClfnCharValue
      FAILED lt_failed
      REPORTED lt_reported
      MAPPED lt_mapped.
      IF lt_failed IS NOT INITIAL.
        APPEND VALUE #(
                  %tky = <fs_key>-%tky
                  %msg = new_message(
                    id       = 'ZAPI_INPUT_FIELDS'
                    number   = '001'
                    severity = if_abap_behv_message=>severity-error
*                          v1       = 'Error en API externa'
                  )
        ) TO reported-zdef_api_pibote_root.

        APPEND VALUE #( %tky =  <fs_key>-%tky ) TO failed-zdef_api_pibote_root.
        RETURN.
      ENDIF.

*----------------POST/SetFuncnLocationToInactive
      lt_keys_setfuncnllocationtoina = VALUE #( ( "%cid_ref = lc_cid_ref
                                                  FunctionalLocation = <fs_key>-%param-functional_location ) ).

      MODIFY ENTITY A_FunctionalLocation
      EXECUTE SetFuncnlLocationToInactive
      FROM lt_keys_setfuncnllocationtoina
      FAILED lt_failed
      REPORTED lt_reported.
      IF lt_failed IS NOT INITIAL.
        APPEND VALUE #(
                  %tky = <fs_key>-%tky
                  %msg = new_message(
                    id       = 'ZAPI_INPUT_FIELDS'
                    number   = '001'
                    severity = if_abap_behv_message=>severity-error
*                          v1       = 'Error en API externa'
                  )
        ) TO reported-zdef_api_pibote_root.

        APPEND VALUE #( %tky =  <fs_key>-%tky ) TO failed-zdef_api_pibote_root.
        RETURN.
      ENDIF.

      lt_keys_installfunlocation = VALUE #( ( "%cid_ref = lc_cid_ref
                                              FunctionalLocation = <fs_key>-%param-functional_location
                                              %param = VALUE #(  SuperiorFunctionalLocation = ''
                                                                 FuncLocInstallationPosNmbr = ''
                                                                 FuncLocInstallationDate = cl_abap_context_info=>get_system_date( )
                                                                 FuncLocInstallationTime = cl_abap_context_info=>get_system_time( )
                                                                 )
                                               ) ).
*----------------POST/InstallFunctionalLocation
      MODIFY ENTITY A_FunctionalLocation
      EXECUTE InstallFunctionalLocation
      FROM lt_keys_InstallFunLocation
      FAILED lt_failed
      REPORTED lt_reported.
      IF lt_failed IS NOT INITIAL.
        APPEND VALUE #(
                  %tky = <fs_key>-%tky
                  %msg = new_message(
                    id       = 'ZAPI_INPUT_FIELDS'
                    number   = '001'
                    severity = if_abap_behv_message=>severity-error
*                          v1       = 'Error en API externa'
                  )
        ) TO reported-zdef_api_pibote_root.

        APPEND VALUE #( %tky =  <fs_key>-%tky ) TO failed-zdef_api_pibote_root.
        RETURN.
      ENDIF.

    ELSE.

      APPEND VALUE #(
        %tky = <fs_key>-%tky
        %msg = new_message(
          id       = 'ZAPI_INPUT_FIELDS'
          number   = '001'
          severity = if_abap_behv_message=>severity-error
*          v1       = 'Error en API externa'
        )
      ) TO reported-zdef_api_pibote_root.

      APPEND VALUE #( %tky =  <fs_key>-%tky ) TO failed-zdef_api_pibote_root.
      RETURN.
    ENDIF.

    IF lt_failed IS INITIAL.
      APPEND VALUE #( %key = <fs_key>-%key
                      %param = VALUE #( tipo    = 'S'
                                        clase   = 'SUC'
                                        mensaje = 'Prueba existosa'
                        ) ) TO result.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
