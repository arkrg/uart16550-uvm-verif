// REG-02: LCR, DLL, DLH SCR read write
class seq_reg_nonvol extends seq_reg_base;
  `uvm_object_utils(seq_reg_nonvol)

  localparam bit [7:0] LCR_RW_MASK = 8'b1001_1000;  // bit7(DLAB), bit4(EPS), bit3(PEN)
  localparam bit [7:0] LCR_CONST_1 = 8'b0000_0011;  // bit1:0(WLS)

  function new(string name = "seq_reg_nonvol");
    super.new(name);
  endfunction

  int err;

  local task chk_lcr(bit [7:0] wval);
    uvm_status_e         status;
    uvm_reg_data_t       rdata;
    bit            [7:0] exp;

    regmodel.lcr.write(status, wval);
    regmodel.lcr.read(status, rdata);
    exp = (wval & LCR_RW_MASK) | LCR_CONST_1;
    if (rdata[7:0] !== exp) begin
      err++;
      `uvm_error("REG-02", $sformatf("[FAIL] lcr w=%02h exp=%02h got=%02h", wval, exp, rdata[7:0]))
    end
    regmodel.lcr.mirror(status, UVM_CHECK, UVM_FRONTDOOR, .parent(this));
  endtask

  local task chk_rw(uvm_reg rg, string tag, bit [7:0] wval);
    uvm_status_e   status;
    uvm_reg_data_t rdata;

    rg.write(status, wval);
    rg.read(status, rdata);
    if (rdata[7:0] !== wval) begin
      err++;
      `uvm_error("REG-02", $sformatf("[FAIL] [%s] exp=%02h got=%02h", tag, wval, rdata[7:0]))
    end
  endtask

  task body();
    uvm_status_e status;
    err = 0;

    // LCR 전수
    for (int i = 0; i < 256; i = i + 1) begin
      chk_lcr(i);
    end
    // DLAB = 0
    regmodel.lcr.write(status, 8'h00);
    // SCR 전수
    for (int i = 0; i < 256; i = i + 1) begin
      chk_rw(regmodel.scr, "scr(dlab:0)", i);
    end
    // DLAB = 1
    regmodel.lcr.write(status, 8'h80);
    // DLL, DLH 전수
    for (int i = 0; i < 256; i = i + 1) begin
      chk_rw(regmodel.dll, "dll", i);
      chk_rw(regmodel.dlh, "dlh", i + 1);
    end
    // DLAB =1에서 SCR 전수
    for (int i = 0; i < 256; i = i + 1) begin
      chk_rw(regmodel.scr, "scr(dlab:1)", i);
    end

    // DLAB복귀
    regmodel.lcr.write(status, 8'h00);
    regmodel.dll.write(status, 8'h00);
    regmodel.dlh.write(status, 8'h00);
    regmodel.scr.write(status, 8'h00);

    if (err == 0) `uvm_info("RESULT", "[PASS] REG-02", UVM_LOW)
    else `uvm_error("RESULT", $sformatf("[FAIL] REG-02 (%0d errors)", err))
  endtask
endclass
