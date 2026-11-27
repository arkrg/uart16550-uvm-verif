class reg_00_rbr extends uvm_reg;
  `uvm_object_utils(reg_00_rbr)
  rand uvm_reg_field DATA;
  uvm_reg_field RSVD;

  function new(string name = "reg_00_rbr");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    this.DATA = uvm_reg_field::type_id::create("DATA");
    this.RSVD = uvm_reg_field::type_id::create("RSVD");
    this.DATA.configure(this, 8, 0, "RO", 1, 'h0, 1, 0, 0);
    this.RSVD.configure(this, 24, 8, "RO", 0, 'h0, 1, 0, 0);
    //(parent, size, lsb, access, volatile, reset, has_reset,
    //is_rand, indiv access)
  endfunction

endclass
