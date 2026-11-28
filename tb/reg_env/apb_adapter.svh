class apb_adapter extends uvm_reg_adapter;
  `uvm_object_utils(apb_adapter)

  function new(string name = "apb_adapter");
    super.new(name);
    supports_byte_enable = 0;
    provides_responses   = 0;
  endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_item pkt = apb_item::type_id::create("pkt");
    if (rw.kind == UVM_WRITE) begin
      pkt.pwrite = 1;
      pkt.pwdata = rw.data;
    end else begin
      pkt.pwrite = 0;
      pkt.prdata = rw.data;
    end
    pkt.paddr = rw.addr;

    `uvm_info("adapter", $sformatf(
              "reg2bus addr=0x%0h data=0x%0h kind=%s", rw.addr, rw.data, rw.kind.name), UVM_DEBUG)
    return pkt;
  endfunction

  virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_item pkt;
    // bus_item is a base class handle of type "uvm_sequence_item" and hence does not
    // contain addr, data properties in it. Hence bus_item has to be cast into bus_pkt
    if (!$cast(pkt, bus_item)) begin
      `uvm_fatal("reg2apb_adapter", "Failed to cast bus_item to pkt")
    end
    rw.kind   = pkt.pwrite ? UVM_WRITE : UVM_READ;
    rw.addr   = pkt.paddr;
    rw.data   = pkt.pwrite ? pkt.pwdata : pkt.prdata;
    rw.status = UVM_IS_OK;  // uart 16650 does not support slave response
    `uvm_info("adapter", $sformatf(
              "bus2reg : addr=0x%0h data=0x%0h kind=%s status=%s",
              rw.addr,
              rw.data,
              rw.kind.name(),
              rw.status.name()
              ), UVM_DEBUG)
  endfunction
endclass
