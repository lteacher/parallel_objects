function z_prc_run_future_task .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CALLABLE) TYPE  ZPRCE_DATA
*"     VALUE(IV_DELAY) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     VALUE(EV_PROCESS) TYPE  ZPRCE_DATA
*"  EXCEPTIONS
*"      NON_SERIALIZABLE_RESULT
*"      NO_RETURN_TYPE_SET
*"      PRC_PROCESS_FAILED
*"----------------------------------------------------------------------
*======================================================================*
* These objects were created by me: Hugo Armstrong, 2012               *
* Don't try to claim credit for my work. Modifying the objects may     *
* cause the entire package to break so that is not exactly recommended *
*                                                                      *
* hugo.armstrong@gmail.com                                             *
*======================================================================*
  data: lr_callable type ref to zif_prc_callable,
        lr_data type ref to data,
        lv_pid type char8,
        lr_exc type ref to cx_root.
  field-symbols: <fs_any> type any.

  "... Deserialize the input object
  call transformation id_indent
     source xml iv_callable
     result obj = lr_callable.

  if iv_delay is not initial.
    wait up to iv_delay seconds.
  endif.

  "... Attach current WP
  zcl_prc_future_executor=>attach_wp( lr_callable->mv_cpid ).

  try.
      "... Consume the callable
      lr_data = lr_callable->call( ).
      assign lr_data->* to <fs_any>.

      "... Set the result
      zcl_prc_future_executor=>set_result( iv_pid = lr_callable->mv_cpid
                                           iv_guid = lr_callable->mv_guid
                                           iv_wpid = lr_callable->mv_wpid
                                           ir_result = <fs_any> ).
    catch zcx_prc_non_serializable.
      zcl_prc_future_executor=>deregister_pid( lr_callable->mv_cpid ).
      raise non_serializable_result.
    catch cx_root into lr_exc. "... Catch all! Just need to make sure the deregister happens fail or not
      "... Raise a final exception so it can be picked up
      zcl_prc_future_executor=>deregister_pid( lr_callable->mv_cpid ).

      "... Re-raise the process failed exception. The original exception cannot
      "... be raised from this RFC enable function but it is stored int the LR_EXC var
      raise prc_process_failed.
  endtry.
endfunction.
