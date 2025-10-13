class generator extends uvm_sequence#(transaction);
  `uvm_object_utils(generator)
  
  transaction t;
  integer i;
  
  function new(input string path = "generator");
    super.new(path);
  endfunction
  
  virtual task body();
    t = transaction::type_id::create("t");
    repeat(10) begin
      
      start_item(t);
      assert(t.randomize());
      `uvm_info("GEN",$sformatf("sent to driver a: %0d and b: %0d",t.a,t.b),UVM_NONE);
      finish_item(t);
      
    end
  endtask
  
endclass
