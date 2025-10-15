class test extends uvm_test;
  `uvm_component_utils(test);

  env e;
  generator gen;

  function new(string path = "test", uvm_component parent);
    super.new(path, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
    gen = generator::type_id::create("gen");
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(e.a.seqr);
    #10
    phase.drop_objection(this);
  endtask

endclass
