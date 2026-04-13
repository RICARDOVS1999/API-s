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
    ASSIGN keys[ 1 ] TO FIELD-SYMBOL(<fs_key>).

    APPEND VALUE #( %key = <fs_key>-%key
                    %param = VALUE #( tipo    = 'S'
                                      clase   = 'SUC'
                                      mensaje = 'Prueba existosa'
                      ) ) TO result.
  ENDMETHOD.

ENDCLASS.
