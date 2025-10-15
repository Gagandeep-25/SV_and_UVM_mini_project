class generator extends uvm_sequence#(transaction);
  `uvm_object_utils(generator)

  transaction t;

  function new(string path = "generator");
    super.new(path);
  endfunction

  virtual task body();
    t = transaction::type_id::create("t");
    repeat(10) begin
      start_item(t);
      t.randomize();
      `uvm_info("GEN", $sformatf("Data sent a : %0d, b : %0d, c : %0d, d : %0d, sel : %0d", t.a, t.b, t.c, t.d, t.sel),UVM_NONE);
      finish_item(t);
    end
  endtask

endclass
