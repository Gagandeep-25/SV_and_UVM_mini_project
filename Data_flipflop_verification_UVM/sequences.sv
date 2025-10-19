/*
in the verification of a D flipflop, we consider 3 scenario sequences
1 . when reset is 0 (low) ,> valid din
2. when reset is 1 (high)
3. when reset is random (rand)
*/

class valid_din extends uvm_sequence#(transaction);  //rst = 0
`uvm_object_utils(valid_din)

  transaction tr;
  
  function new(input string path = "valid_din");
    super.new(path);
  endfunction
  
  virtual task body();
  repeat(15)
    begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.rst = 1'b0;
      `uvm_info("SEQ1",$sformatf("rst : %0b , din : %0b , dout = %0b",tr.rst,tr.din,tr.dout),UVM_NONE);
      finish_item(tr);
    end
  endtask

endclass

class rst_dff extends uvm_sequence#(transaction); //rst is active
`uvm_object_utils(rst_dff)
  
  transaction tr;
  
  function new(input string path = "rst_dff");
    super.new(path);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.rst = 1'b1;
        `uvm_info("SEQ2",$sformatf("rst : %0b , din : %0b , dout = %0b",tr.rst,tr.din,tr.dout),UVM_NONE);
        finish_item(tr);
      end
  endtask
  
endclass

class rand_din_rst extends uvm_sequence#(transaction); //random vlaues of both din and rst
`uvm_object_utils(rand_din_rst)

  transaction tr;
  
  function new(input string path = "rand_din_rst");
    super.new(path);
  endfunction
  
  virtual task body();
  repeat(15)
    begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      `uvm_info("SEQ3",$sformatf("rst : %0b , din : %0b , dout = %0b",tr.rst,tr.din,tr.dout),UVM_NONE);
      finish_item(tr);
    end
  endtask
  
endclass
