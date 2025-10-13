class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(input string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  env e;
  generator gen;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gen = generator::type_id::create("gen");
    e = env::type_id::create("e",this); 
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(e.a.seq);
    phase.drop_objection(this);
  endtask
  
endclass
