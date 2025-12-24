class my_seq extends uvm_sequence#(trans);
  `uvm_object_utils(my_seq)
  
  function new(string name = "my_seq");
    super.new(name);
  endfunction
  
  task body();
    trans t;
    repeat(10) begin
      t = trans::type_id::create("t");
      start_item(t);
      assert(t.randomize());
      finish_item(t);
    end
  endtask
  
endclass

class my_seqr extends uvm_sequencer #(trans);
  `uvm_component_utils(my_seqr)
  
  function new(string name = "my_seqr", uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
