class vtr_sequencer extends uvm_sequence;
  `uvm_object_utils(vtr_sequencer);

  function new(string name = "vtr_sequencer");
    super.new(name);
  endfunction

  // uvm_sequencer #(reset_item) m_rst_seqr;
  uvm_sequencer #(apb_item) m_apb_seqr;

endclass
