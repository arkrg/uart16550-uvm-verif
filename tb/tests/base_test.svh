class base_test extends uvm_test;
  `uvm_component_utils(base_test);

  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  string ov;
  apb_uart_env m_env;
  apb_config m_apb_config;

  virtual function void set_config();
    m_apb_config.has_coverage = 0;
    m_apb_config.addr_mask_width = 5;
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if ($value$plusargs("REGSEQ=%s", ov))
      uvm_factory::get().set_type_override_by_name("seq_reg_base", ov);
    m_apb_config = apb_config::type_id::create("m_apb_config");
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", m_apb_config.vif))
      `uvm_fatal("NOVIF", "Couldn't get virtual interface")
    set_config();
    uvm_config_db#(apb_config)::set(this, "*.m_apb_agent*", "m_config", m_apb_config);
    m_env = apb_uart_env::type_id::create("m_env", this);
  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    uvm_top.set_timeout(1ms);
    uvm_factory::get().print(0);
  endfunction : end_of_elaboration_phase

endclass
