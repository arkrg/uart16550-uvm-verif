class uart_reg_block extends uvm_reg_block;
  `uvm_object_utils(uart_reg_block)
  rand reg_00_rbr rbr;
  rand reg_00_thr thr;
  rand reg_00_dll dll;
  rand reg_04_dlh dlh;
  rand reg_0C_lcr lcr;
  rand reg_14_lsr lsr;
  rand reg_1C_scr scr;

  function new(string name = "uart_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();

    // Create an instance for every register
    this.default_map = create_map(
        "default_map", .base_addr(0), .n_bytes(4), .endian(UVM_LITTLE_ENDIAN), .byte_addressing(0));
    this.rbr = reg_00_rbr::type_id::create("rbr",, get_full_name);
    this.thr = reg_00_thr::type_id::create("thr",, get_full_name);
    this.dll = reg_00_dll::type_id::create("dll",, get_full_name);
    this.dlh = reg_04_dlh::type_id::create("dlh",, get_full_name);
    this.lcr = reg_0C_lcr::type_id::create("lcr",, get_full_name);
    this.lsr = reg_14_lsr::type_id::create("lsr",, get_full_name);
    this.scr = reg_1C_scr::type_id::create("scr",, get_full_name);


    // Configure every register instance
    this.rbr.configure(this, null, "");
    this.thr.configure(this, null, "");
    this.dll.configure(this, null, "");
    this.dlh.configure(this, null, "");
    this.lcr.configure(this, null, "");
    this.lsr.configure(this, null, "");
    this.scr.configure(this, null, "");

    // Call the build() function to build all register fields within each register
    this.rbr.build();
    this.thr.build();
    this.dll.build();
    this.dlh.build();
    this.lcr.build();
    this.lsr.build();
    this.scr.build();

    // Add these registers to the default map
    this.default_map.add_reg(this.rbr, `UVM_REG_ADDR_WIDTH'h00, "RO", 0);
    this.default_map.add_reg(this.thr, `UVM_REG_ADDR_WIDTH'h00, "WO", 0);
    this.default_map.add_reg(this.dll, `UVM_REG_ADDR_WIDTH'h00, "RW", 0);
    this.default_map.add_reg(this.dlh, `UVM_REG_ADDR_WIDTH'h04, "RW", 0);
    this.default_map.add_reg(this.lcr, `UVM_REG_ADDR_WIDTH'h0C, "RW", 0);
    this.default_map.add_reg(this.lsr, `UVM_REG_ADDR_WIDTH'h14, "RO", 0);
    this.default_map.add_reg(this.scr, `UVM_REG_ADDR_WIDTH'h1C, "RW", 0);
    lock_model();
  endfunction
endclass

