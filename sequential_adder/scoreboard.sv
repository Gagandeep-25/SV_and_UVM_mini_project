class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp #(transaction,scoreboard) recv;
  
  transaction data;
  
  function new(input string path = "scoreboard", uvm_component parent);
    super.new(path,parent);
    recv = new("recv",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    data = transaction::type_id::create("data");
  endfunction
  
  virtual function void write(transaction t);
    data = t;
    
    `uvm_info("SCO",$sformatf("data recvd from monitor a : %0d , b ; %0d , y = %0d",t.a,t.b,t.y),UVM_NONE);
    
    if(data.y == (data.a + data.b))
      `uvm_info("SCO","test passed",UVM_NONE)
    else 
      `uvm_info("SCO","test failed",UVM_NONE);
  endfunction
  
endclass
