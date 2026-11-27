module tb_top;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import apb_uart_uvm_pkg::*;

  logic pclk = 0;
  wire uart_data_tx, uart_data_rx;
  apb_if aif (.pclk);
  apb_uart dut (
      .aif(aif.completer),
      .uart_data_tx,
      .uart_data_rx
  );
  always #5 pclk = ~pclk;
  initial begin
    aif.presetn <= 0;
    repeat (5) @(aif.cb_drv);
    aif.presetn <= 1;
    repeat (5) @(aif.cb_drv);
  end

  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top*", "vif", aif);
    run_test();
  end

  initial begin
    $dumpfile("waves.vcd");
    $dumpvars();
  end
endmodule
