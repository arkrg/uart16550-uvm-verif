class reg_env extends uvm_env;
  `uvm_component_utils(reg_env);

  function new(string name = "reg_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  uart_reg_block m_regmodel;
  apb_adapter m_apb_adapter;
  uvm_reg_predictor #(apb_item) m_apb_predictor;
  // ral은 object 이기 때문에 component를 사용하여 원하는 phase에 메소드를 호출) 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_regmodel = uart_reg_block::type_id::create("m_regmodel", this);
    m_apb_adapter = apb_adapter::type_id::create("m_apb_adapter", this);
    m_apb_predictor = uvm_reg_predictor#(apb_item)::type_id::create("m_apb_predictor", this);

    m_regmodel.build();
    m_regmodel.lock_model();
    m_regmodel.reset();  // 1027
    // backdoor access 추가 
    // m_regmodel.default_map.set_hdl_path_root("tb.dut");  // 5. backdoor HDL root
    uvm_config_db#(uart_reg_block)::set(null, "uvm_test_top.*", "m_regmodel", m_regmodel);


  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_apb_predictor.map = m_regmodel.default_map;
    m_apb_predictor.adapter = m_apb_adapter;
    // m_agent.ap.connect(m_apb_predictor.bus_in);
  endfunction : connect_phase


endclass
