class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp #(transaction,scoreboard) recv;
  transaction tr;
  
  function new(input string path = "scoreboard", uvm_component parent = null);
    super.new(path,parent);
    recv = new("recv",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
  endfunction
  
virtual function void write(transaction t);
  tr = t;
  
  `uvm_info("SCO",$sformatf("received from monitor a: %0d, b: %0d, y: %0d", tr.a, tr.b, tr.y),UVM_LOW);

  // Check expected vs actual
  if (tr.y == (tr.a + tr.b)) begin
    `uvm_info("SCO", $sformatf("Test passed and y = %0d",tr.y), UVM_NONE)
  end else begin
    `uvm_error("SCO", $sformatf("Test FAILED : Expected %0d but got %0d",tr.a + tr.b, tr.y));
  end
endfunction

endclass
