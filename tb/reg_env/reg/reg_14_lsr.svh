class reg_14_lsr extends uvm_reg;
  `uvm_object_utils(reg_14_lsr)
  uvm_reg_field DR;  // Data Ready
  uvm_reg_field OE;  // Overrun Error
  uvm_reg_field PE;  // Parity Error
  uvm_reg_field FE;  // Frame Error
  uvm_reg_field BI;  // Break Interrupt
  uvm_reg_field THRE;  // THR Empty
  uvm_reg_field TEMPT;  // Transmitter Empty
  uvm_reg_field RXFIFOE;  // Error in RCVR FIFO
  uvm_reg_field RSVD;


  function new(string name = "reg_14_lsr");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    this.DR    = uvm_reg_field::type_id::create("DR   ");
    this.OE    = uvm_reg_field::type_id::create("OE   ");
    this.PE    = uvm_reg_field::type_id::create("PE   ");
    this.FE    = uvm_reg_field::type_id::create("FE   ");
    this.BI    = uvm_reg_field::type_id::create("BI   ");
    this.THRE  = uvm_reg_field::type_id::create("THRE ");
    this.TEMPT = uvm_reg_field::type_id::create("TEMPT");
    this.RXFIFOE= uvm_reg_field::type_id::create("RXFIFOE");
    this.RSVD = uvm_reg_field::type_id::create("RSVD");

    this.DR.configure(this, 1, 0, "RO", 1, 'h0, 1, 0, 0);
    this.OE.configure(this, 1, 1, "RO", 1, 'h0, 1, 0, 0);
    this.PE.configure(this, 1, 2, "RO", 1, 'h0, 1, 0, 0);
    this.FE.configure(this, 1, 3, "RO", 1, 'h0, 1, 0, 0);
    this.BI.configure(this, 1, 4, "RO", 1, 'h0, 1, 0, 0);
    this.THRE.configure(this, 1, 5, "RO", 1, 'h1, 1, 0, 0);
    this.TEMPT.configure(this, 1, 6, "RO", 1, 'h1, 1, 0, 0);
    this.RXFIFOE.configure(this, 1, 7, "RO", 1, 'h0, 1, 0, 0);
    this.RSVD.configure(this, 24, 8, "RO", 0, 'h0, 1, 0, 0);
    //(parent, size, lsb, access, volatile, reset, has_reset, is_rand, indiv access)
  endfunction

endclass
