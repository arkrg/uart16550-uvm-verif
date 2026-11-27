module apb_uart (
          apb_if.completer aif,
    input                  uart_data_rx,
    output                 uart_data_tx
);
  logic tx_full;
  logic rx_empty;
  wire  state_setup = ~aif.penable & aif.psel;
  wire  state_access = aif.penable & aif.psel;
  uart_16550 u_uart (
      .clk              (aif.pclk),
      .rstn             (aif.presetn),
      .reg_addr         (aif.paddr),
      .reg_enable_access(state_access),
      .reg_write        (state_access & aif.pwrite),
      .reg_read         (state_access & ~aif.pwrite),
      .reg_data_write   (aif.pwdata),
      .reg_data_read    (aif.prdata),

      .uart_data_rx,
      .uart_data_tx

  );
  always_ff @(posedge aif.pclk or negedge aif.presetn) begin
    if (!aif.presetn) aif.pready <= 1'b0;
    else aif.pready <= 1'b1;
  end
endmodule

