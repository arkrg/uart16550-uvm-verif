module apb_uart (
          apb_if.completer aif,
    input                  uart_data_rx,
    output                 uart_data_tx
);
  logic tx_full;
  logic rx_empty;
  wire  is_setup = ~aif.penable & aif.psel;
  wire  is_access = aif.penable & aif.psel;
  uart_16550 u_uart (
      .clk              (aif.pclk),
      .rstn             (aif.presetn),
      .reg_addr         (aif.paddr),
      .reg_enable_access(is_access),
      .reg_write        (is_access & aif.pwrite),
      .reg_read         (is_access & ~aif.pwrite),
      .reg_data_write   (aif.pwdata),
      .reg_data_read    (aif.prdata),

      .uart_data_rx,
      .uart_data_tx

  );
  always_ff @(posedge aif.pclk or negedge aif.presetn) begin
    if (!aif.presetn) begin
      aif.pready  <= 0;
      aif.pslverr <= 0;
    end else begin
      aif.pready <= 1'b1;
    end
  end

endmodule

