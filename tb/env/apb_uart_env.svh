class apb_uart_env extends uvm_env;
  `uvm_component_utils(apb_uart_env);

  function new(string name = "apb_uart_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  apb_agent m_apb_agent;
  // reset_agent m_rst_agent;
  vtr_sequencer m_vseqr;
  reg_env m_reg_env;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_apb_agent = apb_agent::type_id::create("m_apb_agent", this);
    // m_rst_agent = reset_agent::type_id::create("m_rst_agent", this);
    m_vseqr = vtr_sequencer::type_id::create("m_vseqr", this);
    m_reg_env = reg_env::type_id::create("m_reg_env", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // m_apb_agent.m_monitor.mon_ap.connect(m_reg_env.m_apb_predictor.bus_in);
    m_reg_env.m_regmodel.default_map.set_sequencer(m_apb_agent.m_seqr, m_reg_env.m_apb_adapter);
    m_vseqr.m_apb_seqr = m_apb_agent.m_seqr;
    // m_vseqr.m_rst_seqr = m_rst_agent.m_seqr;
  endfunction : connect_phase

endclass
