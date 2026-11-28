class seq_reg_reset extends seq_reg_base;
  `uvm_object_utils(seq_reg_reset)

  function new(string name = "seq_reg_reset");
    super.new(name);
  endfunction

  task body();
    uvm_status_e   status;
    uvm_reg_data_t rdata;
    int            err = 0;

    regmodel.reset();

    regmodel.lcr.mirror(status, UVM_CHECK, UVM_FRONTDOOR, .parent(this));
    regmodel.scr.mirror(status, UVM_CHECK, UVM_FRONTDOOR, .parent(this));
    regmodel.lsr.read(status, rdata, UVM_FRONTDOOR, .parent(this));
    if (rdata[7:0] !== 8'h60) begin
      `uvm_error("REG-01", $sformatf("[FAIL] REG-01 LSR reset: exp=0x60 got=0x%02h", rdata[7:0]))
      err++;
    end else `uvm_info("REG-01", "[PASS] LSR reset 0x60 OK", UVM_LOW)

    // RBR는 읽지 않음(읽기 = RX FIFO pop 부작용)
    if (err == 0) `uvm_info("REG-01", "[PASS]", UVM_LOW)
    else `uvm_error("REG-01", $sformatf("[FAIL] (%0d)", err))
  endtask

endclass
