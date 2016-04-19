FUNCTION Z_PRC_RUN_MANAGED_TASK .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_PROCESS) TYPE  ZPRCE_DATA
*"     VALUE(IV_DELAY) TYPE  STRING
*"  EXPORTING
*"     VALUE(EV_PROCESS) TYPE  ZPRCE_DATA
*"  EXCEPTIONS
*"      PRC_PROCESS_FAILED
*"----------------------------------------------------------------------
*======================================================================*
* These objects were created by me: Hugo Armstrong, 2012               *
* Don't try to claim credit for my work. Modifying the objects may     *
* cause the entire package to break so that is not exactly recommended *
*                                                                      *
* hugo.armstrong@gmail.com                                             *
*======================================================================*
  data: lr_process type ref to zcl_prc_managed_task,
        lv_pid type char8,
        lr_exc type ref to cx_root.

  "... Deserialize the input object
  call transformation id_indent
     source xml iv_process
     result obj = lr_process.

  if iv_delay is not initial.
    wait up to iv_delay seconds.
  endif.

  "... Get the process id
  lv_pid = lr_process->get_pid( ).

  "... Attach current WP
  zcl_prc_monitor=>attach_wp( lv_pid ).

  try.
      lr_process->mr_runnable->run( ).
    catch cx_root into lr_exc. "... Catch all! Just need to make sure the deregister happens fail or not
      zcl_prc_monitor=>deregister_pid( lv_pid ).

      "... Re-raise the process failed exception. The original exception cannot
      "... be raised from this RFC enable function but it is stored int the LR_EXC var
      raise prc_process_failed.
  endtry.

  zcl_prc_monitor=>deregister_pid( lv_pid ).
endfunction.
