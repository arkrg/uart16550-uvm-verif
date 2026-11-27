class reg_1C_scr extends uvm_reg;
  `uvm_object_utils(reg_1C_scr)
  uvm_reg_field DATA;
  uvm_reg_field RSVD;

  function new(string name = "reg_1C_scr");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    this.DATA = uvm_reg_field::type_id::create("DATA");
    this.RSVD = uvm_reg_field::type_id::create("RSVD");
    this.DATA.configure(this, 8, 0, "RW", 0, 'h0, 1, 0, 0);
    this.RSVD.configure(this, 24, 8, "RO", 0, 'h0, 1, 0, 0);
    //(parent, size, lsb, access, volatile, reset, has_reset, is_rand, indiv access)
  endfunction

endclass
