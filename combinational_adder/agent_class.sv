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
  
  virtual function void write(input transaction t);
    tr = t;
    `uvm_info("SCO",$sformatf("recieved from monitor a : %0d , b : %0d and y : %0d",tr.a,tr.b,tr.y),UVM_NONE);
    
    //algorithm 
    if(tr.y == tr.a + tr.b)
      `uvm_info("SCO","test passed",UVM_NONE);
    else
      `uvm_info("SCO","Test Failed",UVM_NONE);
    
  endfunction
  
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  monitor m;
  driver d;
  uvm_sequencer #(transaction) seq;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m = monitor::type_id::create("m",this);
    d = driver::type_id::create("d",this);
    seq = uvm_sequencer#(transaction)::type_id::create("seq",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seq.seq_item_export);
  endfunction
  
endclass
