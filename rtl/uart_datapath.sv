module uart_datapath (
    input                                    clk,
    input                                    rstn,
    //
    input                                    rff_cmd_pop,
    output             [WIDTH_UART_DATA+1:0] rff_data_pop,
    output                                   rff_flag_empty,
    output                                   rff_flag_full,
    input                                    tff_cmd_push,
    input              [WIDTH_UART_DATA-1:0] tff_data_push,
    output                                   tff_flag_full,
    output                                   tff_flag_empty,
           uart_int_if                       uif,
    input  logic                             uart_data_rx,
    output logic                             uart_data_tx
);
  wire [WIDTH_UART_DATA+1:0] rff_data_push = {
    uif.flag_parity_error, uif.flag_frame_error, uif.data_rx_par
  }, _rff_data_pop, rff_data_pop = (rff_flag_empty) ? 0 : _rff_data_pop;
  wire [WIDTH_UART_DATA-1:0] tff_data_pop;
  wire rff_cmd_push = uif.flag_rx_done & ~rff_flag_full;
  wire tff_cmd_pop = ~uif.flag_tx_busy;

  assign uart_data_tx = uif.data_tx_ser;
  assign uif.data_rx_ser = uart_data_rx;
  assign uif.data_tx_par = tff_data_pop;
  assign uif.cmd_tx_start = ~tff_flag_empty;

  uart_core u_uart_core (
      .clk,
      .rstn,
      .uif
  );
  sync_fifo #(
      .WIDTH_DATA(WIDTH_UART_DATA + 2)
  ) u_rxfifo (
      .clk,
      .rstn,
      .cmd_push  (rff_cmd_push  ),
      .cmd_pop   (rff_cmd_pop   ),
      .data_push (rff_data_push ),
      .data_pop  (_rff_data_pop ),
      .flag_full (rff_flag_full ),
      .flag_empty(rff_flag_empty)
  );
  sync_fifo u_txfifo (
      .clk,
      .rstn,
      .cmd_push  (tff_cmd_push  ),
      .cmd_pop   (tff_cmd_pop   ),
      .data_push (tff_data_push ),
      .data_pop  (tff_data_pop  ),
      .flag_full (tff_flag_full ),
      .flag_empty(tff_flag_empty)
  );
endmodule
module uart_core (
    input clk,
    input rstn,
    uart_int_if uif
);
  uart_bdgen u_bdgen (
      .clk,
      .rstn,
      .uif_b(uif.bg)
  );
  uart_tx u_tx (
      .clk,
      .rstn,
      .uif_t(uif.tx)
  );
  uart_rx u_rx (
      .clk,
      .rstn,
      .uif_r(uif.rx)
  );
endmodule
