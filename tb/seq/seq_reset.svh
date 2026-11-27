// REG-01: 리셋 직후 레지스터 리셋값 확인 (RAL 사용 예시)
// 가정: RAL 블록 이름 uart_reg_block, 레지스터 인스턴스 이름 lcr / scr / lsr
// 기대값(스펙 v1.1): LCR=0x03, LSR=0x60, SCR=0x00

class seq_reset extends uvm_reg_sequence;
  `uvm_object_utils(seq_reset)

  uart_reg_block regmodel;  // test가 build 후 대입

  function new(string name = "seq_reset");
    super.new(name);
  endfunction

  task body();
    uvm_status_e   status;
    uvm_reg_data_t rdata;
    int            err = 0;

    // 0) mirror(RAL 내부 기대값)를 reset 값으로 맞춘다
    regmodel.reset();

    // 1) LCR: mirror 비교. DUT에서 읽은 값과 mirror가 다르면 자동으로 UVM_ERROR
    regmodel.m_reg_lcr.mirror(status, UVM_CHECK, UVM_FRONTDOOR, .parent(this));
    if (status != UVM_IS_OK) err++;

    // 2) SCR: 같은 방식
    regmodel.m_reg_scr.mirror(status, UVM_CHECK, UVM_FRONTDOOR, .parent(this));
    if (status != UVM_IS_OK) err++;

    // 3) LSR: volatile이라 mirror 대신 읽은 값을 직접 비교
    regmodel.m_reg_lsr.read(status, rdata, UVM_FRONTDOOR, .parent(this));
    if (rdata[7:0] !== 8'h60) begin
      `uvm_error("REG-01", $sformatf("LSR reset: exp=0x60 got=0x%02h", rdata[7:0]))
      err++;
    end else `uvm_info("REG-01", "LSR reset 0x60 OK", UVM_LOW)

    // RBR는 읽지 않는다 (읽기 = RX FIFO pop 부작용)

    if (err == 0) `uvm_info("REG-01", "PASS", UVM_LOW)
    else `uvm_error("REG-01", $sformatf("FAIL (%0d)", err))
  endtask
endclass
