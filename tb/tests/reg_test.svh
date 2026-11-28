class reg_test extends base_test;
  `uvm_component_utils(reg_test);

  function new(string name = "reg_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  seq_reg_base m_reg_seq;

  virtual virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    m_reg_seq = seq_reg_base::type_id::create("m_reg_seq");
    m_reg_seq.regmodel = m_env.m_reg_env.m_regmodel;
    m_reg_seq.start(m_env.m_apb_agent.m_seqr);
    phase.drop_objection(this);
  endtask : run_phase


endclass
