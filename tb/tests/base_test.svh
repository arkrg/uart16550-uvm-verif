class base_test extends uvm_test;
  `uvm_component_utils(base_test);

  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  apb_uart_env m_env;
  apb_config   m_apb_config;
  seq_reset    m_rst_seq;

  virtual function void set_config();
    m_apb_config.has_coverage = 0;
    m_apb_config.addr_mask_width = 5;
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
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
  endfunction : end_of_elaboration_phase

  virtual virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    m_rst_seq = seq_reset::type_id::create("m_rst_seq");
    m_rst_seq.regmodel = m_env.m_reg_env.m_regmodel;
    m_rst_seq.start(m_env.m_apb_agent.m_seqr);
    phase.drop_objection(this);
  endtask : run_phase

endclass
