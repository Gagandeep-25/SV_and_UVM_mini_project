class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  driver d;
  monitor m;
  my_seqr seqr;
  
  function new(string path = "agent", uvm_component parent);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    d = driver::type_id::create("d",this);
    seqr = my_seqr::type_id::create("seqr",this);
    m = monitor::type_id::create("m",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass
