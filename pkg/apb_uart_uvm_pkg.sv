package apb_uart_uvm_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import apb_agt_pkg::*;

  // Item

  // Base Sequences
  `include "seq/seq_reset.svh"

  // Virtual Sequencer & Virtual Sequences

  // Ragister Abstract Layer
  `include "reg_env/reg/reg_00_dll.svh"
  `include "reg_env/reg/reg_00_rbr.svh"
  `include "reg_env/reg/reg_00_thr.svh"
  `include "reg_env/reg/reg_04_dhl.svh"
  `include "reg_env/reg/reg_0C_lcr.svh"
  `include "reg_env/reg/reg_14_lsr.svh"
  `include "reg_env/reg/reg_1C_scr.svh"
  `include "reg_env/reg/uart_reg_block.svh"
  `include "reg_env/apb_adapter.svh"
  `include "reg_env/reg_env.svh"

  // Scoreboard & Predictor/Checker


  // Env
  `include "env/vtr_sequencer.svh"
  `include "env/apb_uart_env.svh"

  // Tests
  `include "tests/base_test.svh"
endpackage
