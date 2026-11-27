module uart_16550 #(
    parameter int WIDTH_REG_ADDR = 5,
    parameter int WIDTH_REG_DATA = 32
) (
    input                       clk,
    input                       rstn,
    input  [WIDTH_REG_ADDR-1:0] reg_addr,
    input                       reg_write,
    input                       reg_read,
    input                       reg_enable_access,
    input  [WIDTH_REG_DATA-1:0] reg_data_write,
    output [WIDTH_REG_DATA-1:0] reg_data_read,

    input  uart_data_rx,
    output uart_data_tx
);
  wire                       rff_cmd_pop;
  wire [WIDTH_UART_DATA+1:0] rff_data_pop;
  wire                       rff_flag_empty;
  wire                       rff_flag_full;
  wire                       tff_cmd_push;
  wire [WIDTH_UART_DATA-1:0] tff_data_push;
  wire                       tff_flag_empty;
  wire                       rx_flag_done;
  wire [               15:0] cfg_divisor;
  wire                       cfg_en_parity;
  wire                       cfg_even_parity;
  wire                       tff_flag_full;
  uart_int_if uif ();

  assign rx_flag_done = uif.flag_rx_done;

  uart_register #(
      .WIDTH_REG_ADDR(WIDTH_REG_ADDR),
      .WIDTH_REG_DATA(WIDTH_REG_DATA)
  ) u_reg (
      .clk,
      .rstn,
      .reg_addr,
      .reg_write,
      .reg_read,
      .reg_enable_access,
      .reg_data_write,
      .reg_data_read,
      .rff_cmd_pop,
      .rff_data_pop,
      .rff_flag_empty,
      .rff_flag_full,
      .tff_cmd_push,
      .tff_data_push,
      .tff_flag_empty,
      .rx_flag_done,
      .cfg_divisor,
      .cfg_en_parity,
      .cfg_even_parity
  );
  uart_datapath u_dp (
      .clk,
      .rstn,
      .rff_cmd_pop,
      .rff_data_pop,
      .rff_flag_empty,
      .rff_flag_full,
      .tff_cmd_push,
      .tff_data_push,
      .tff_flag_full,
      .tff_flag_empty,
      .uif,
      .uart_data_rx,
      .uart_data_tx
  );
endmodule
