class reg_0C_lcr extends uvm_reg;
  `uvm_object_utils(reg_0C_lcr)
  rand uvm_reg_field WLS;  // Word Length Select
  rand uvm_reg_field STB;  // Stop bit
  rand uvm_reg_field PEN;  // Parity En
  rand uvm_reg_field EPS;  // Even Parity Select
  rand uvm_reg_field SP;  // Stick Parity
  rand uvm_reg_field SB;  // Set Break
  rand uvm_reg_field DLAB;  // Divisor Latch Access Bit
  uvm_reg_field RSVD;

  function new(string name = "reg_0C_lcr");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    this.WLS  = uvm_reg_field::type_id::create("WLS ");
    this.STB  = uvm_reg_field::type_id::create("STB ");
    this.PEN  = uvm_reg_field::type_id::create("PEN ");
    this.EPS  = uvm_reg_field::type_id::create("EPS ");
    this.SP   = uvm_reg_field::type_id::create("SP  ");
    this.SB   = uvm_reg_field::type_id::create("SB  ");
    this.DLAB = uvm_reg_field::type_id::create("DLAB");
    this.RSVD = uvm_reg_field::type_id::create("RSVD");

    this.WLS.configure(this, 2, 0, "RO", 0, 'h3, 1, 1, 0);
    // this.WLS.configure(this, 2, 0, "RW", 0, 'h3, 1, 1, 0);
    this.STB.configure(this, 1, 2, "RO", 0, 'h0, 1, 1, 0);
    // this.STB.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 0);
    this.PEN.configure(this, 1, 3, "RW", 0, 'h0, 1, 1, 0);
    this.EPS.configure(this, 1, 4, "RW", 0, 'h0, 1, 1, 0);
    this.SP.configure(this, 1, 5, "RO", 0, 'h0, 1, 1, 0);
    // this.SP.configure(this, 1, 5, "RW", 0, 'h0, 1, 1, 0);
    this.SB.configure(this, 1, 6, "RO", 0, 'h0, 1, 1, 0);
    // this.SB.configure(this, 1, 6, "RW", 0, 'h0, 1, 1, 0);
    this.DLAB.configure(this, 1, 7, "RW", 0, 'h0, 1, 1, 0);
    this.RSVD.configure(this, 24, 8, "RO", 0, 'h0, 1, 0, 0);
    //(parent, size, lsb, access, volatile, reset, has_reset, is_rand, indiv access)
  endfunction

endclass
