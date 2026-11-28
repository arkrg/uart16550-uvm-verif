class uart_base_seq extends uvm_sequence #(apb_item);
  `uvm_object_utils(uart_base_seq)

  uart_reg_block regmodel;

  function new(string name = "uart_base_seq");
    super.new(name);
  endfunction

  // raw APB 접근
  task apb_write(bit [31:0] addr, bit [31:0] data);
    apb_item req = apb_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with {
          paddr == local:: addr;
          pwrite == 1;
          pwdata == data;
        })
      `uvm_fatal("RAND", "randomize failed")
    finish_item(req);
  endtask

  task apb_read(bit [31:0] addr, output bit [31:0] data, output bit slverr);
    apb_item req = apb_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with {
          addr == local:: addr;
          write == 0;
        })
      `uvm_fatal("RAND", "randomize failed")
    finish_item(req);
    data   = req.rdata;
    slverr = req.slverr;
  endtask
endclass
