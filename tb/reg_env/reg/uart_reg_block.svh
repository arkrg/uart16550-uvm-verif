class uart_reg_block extends uvm_reg_block;
  `uvm_object_utils(uart_reg_block)
  rand reg_00_rbr m_reg_rbr;
  rand reg_00_thr m_reg_thr;
  rand reg_00_dll m_reg_dll;
  rand reg_04_dlh m_reg_dlh;
  rand reg_0C_lcr m_reg_lcr;
  rand reg_14_lsr m_reg_lsr;
  rand reg_1C_scr m_reg_scr;

  function new(string name = "uart_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();

    // Create an instance for every register
    this.default_map = create_map(
        "default_map", .base_addr(0), .n_bytes(4), .endian(UVM_LITTLE_ENDIAN), .byte_addressing(0));
    this.m_reg_rbr = reg_00_rbr::type_id::create("m_reg_rbr",, get_full_name);
    this.m_reg_thr = reg_00_thr::type_id::create("m_reg_thr",, get_full_name);
    this.m_reg_dll = reg_00_dll::type_id::create("m_reg_dll",, get_full_name);
    this.m_reg_dlh = reg_04_dlh::type_id::create("m_reg_dlh",, get_full_name);
    this.m_reg_lcr = reg_0C_lcr::type_id::create("m_reg_lcr",, get_full_name);
    this.m_reg_lsr = reg_14_lsr::type_id::create("m_reg_lsr",, get_full_name);
    this.m_reg_scr = reg_1C_scr::type_id::create("m_reg_scr",, get_full_name);


    // Configure every register instance
    this.m_reg_rbr.configure(this, null, "");
    this.m_reg_thr.configure(this, null, "");
    this.m_reg_dll.configure(this, null, "");
    this.m_reg_dlh.configure(this, null, "");
    this.m_reg_lcr.configure(this, null, "");
    this.m_reg_lsr.configure(this, null, "");
    this.m_reg_scr.configure(this, null, "");

    // Call the build() function to build all register fields within each register
    this.m_reg_rbr.build();
    this.m_reg_thr.build();
    this.m_reg_dll.build();
    this.m_reg_dlh.build();
    this.m_reg_lcr.build();
    this.m_reg_lsr.build();
    this.m_reg_scr.build();

    // Add these registers to the default map
    this.default_map.add_reg(this.m_reg_rbr, `UVM_REG_ADDR_WIDTH'h00, "RO", 0);
    this.default_map.add_reg(this.m_reg_thr, `UVM_REG_ADDR_WIDTH'h00, "WO", 0);
    this.default_map.add_reg(this.m_reg_dll, `UVM_REG_ADDR_WIDTH'h00, "RW", 0);
    this.default_map.add_reg(this.m_reg_dlh, `UVM_REG_ADDR_WIDTH'h04, "RW", 0);
    this.default_map.add_reg(this.m_reg_lcr, `UVM_REG_ADDR_WIDTH'h0C, "RW", 0);
    this.default_map.add_reg(this.m_reg_lsr, `UVM_REG_ADDR_WIDTH'h14, "RO", 0);
    this.default_map.add_reg(this.m_reg_scr, `UVM_REG_ADDR_WIDTH'h1C, "RW", 0);
    lock_model();
  endfunction
endclass

