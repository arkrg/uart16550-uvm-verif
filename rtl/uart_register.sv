module uart_register #(
    parameter int WIDTH_REG_ADDR  = 5,
    parameter int WIDTH_REG_DATA  = 32,
    parameter int WIDTH_UART_DATA = 8
) (
    input  logic                       clk,
    input  logic                       rstn,
    // register control
    input  logic [ WIDTH_REG_ADDR-1:0] reg_addr,
    input  logic                       reg_write,
    input  logic                       reg_read,
    input  logic                       reg_enable_access,
    input  logic [ WIDTH_REG_DATA-1:0] reg_data_write,
    output logic [ WIDTH_REG_DATA-1:0] reg_data_read,
    output logic                       rff_cmd_pop,
    input  logic [WIDTH_UART_DATA+1:0] rff_data_pop,
    input  logic                       rff_flag_empty,
    input  logic                       rff_flag_full,
    output logic                       tff_cmd_push,
    output logic [WIDTH_UART_DATA-1:0] tff_data_push,
    input  logic                       tff_flag_empty,
    input  logic                       rx_flag_done,
    // uart-core command, status and data
    // uart configure control
    output logic [               15:0] cfg_divisor,
    output logic                       cfg_en_parity,
    output logic                       cfg_even_parity
);
  localparam bit [1:0] R_WSL_11 = 2'b11;
  logic [WIDTH_REG_DATA-1:0] IER, FCR, LCR, LSR, DLL, DLH, SCR;
  logic RXFIFOE, TEMT, THRE, BIS, FE, PE, OE, DR;
  logic DLAB, SB, SP, EPS, PEN, STB;
  logic [1:0] WLS;
  logic [2:0] sel_reg;
  logic flag_read_lsr;

  assign sel_reg = reg_addr[4:2];
  assign LCR = {DLAB, SB, SP, EPS, PEN, STB, WLS};
  assign LSR = {RXFIFOE, TEMT, THRE, BIS, FE, PE, OE, DR};
  assign THRE = tff_flag_empty;
  assign TEMT = tff_flag_empty;  // & tsr이 empty. ~tff_flag_busy
  assign DR = ~rff_flag_empty;
  assign RXFIFOE = PE | FE;
  assign tff_data_push = reg_data_write;
  assign tff_cmd_push = reg_enable_access & reg_write & (sel_reg == 3'b000) & (DLAB == 0);
  assign cfg_divisor = {DLH[7:0], DLL[7:0]};
  assign cfg_even_parity = EPS;
  assign cfg_en_parity = PEN;


  always_ff @(posedge clk or posedge rstn) begin
    if (!rstn) begin
      // FCR <= 0;
      {DLAB, SB, SP, EPS, PEN, STB} <= 0;
      WLS <= R_WSL_11;
      DLL <= 0;
      DLH <= 0;
      SCR <= 0;
    end else begin
      if (reg_enable_access && reg_write) begin
        case (sel_reg)
          3'b000: if (DLAB == 1) DLL <= reg_data_write;
          3'b001: begin
            if (DLAB == 1) DLH <= reg_data_write;
            // else IER <= reg_data_write;
          end
          // 3'b010: FCR <= reg_data_write;
          3'b011: begin
            PEN  <= reg_data_write[3];
            EPS  <= reg_data_write[4];
            DLAB <= reg_data_write[7];
          end
          3'b111: SCR <= reg_data_write;  // scr regiser added day0
        endcase
      end
    end
  end
  //with uart
  always_ff @(posedge clk or posedge rstn) begin
    if (!rstn) begin
      OE  <= 0;
      BIS <= 0;
    end else begin
      if (rff_flag_full & rx_flag_done) OE <= 1;
      if (flag_read_lsr) OE <= 0;
      if (rff_cmd_pop) {PE, FE} <= rff_data_pop[WIDTH_UART_DATA+:2];
    end
  end

  always_comb begin
    rff_cmd_pop   = 0;
    flag_read_lsr = 0;
    reg_data_read = 'd0;
    if (reg_enable_access & reg_read) begin
      case (sel_reg)
        3'b000: begin
          if (DLAB == 0) begin
            reg_data_read = rff_data_pop;
            rff_cmd_pop   = 1;
          end else reg_data_read = DLL;
        end
        3'b001: begin
          if (DLAB == 1) reg_data_read = DLH;
          else reg_data_read = IER;
        end
        // 3'b010: reg_data_read = IIR;
        3'b011: reg_data_read = LCR;
        // 3'b100: reg_data_read = MCR;
        3'b101: begin
          reg_data_read = LSR;
          flag_read_lsr = 1;
        end
        // 3'b110: reg_data_read = MSR;
        3'b111: reg_data_read = SCR;
      endcase
    end
  end

endmodule
