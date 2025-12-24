class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e;
  my_seq seq;
  
  function new(string path = "test", uvm_component parent);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e",this);
    seq = my_seq::type_id::create("seq");
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(e.a.seqr);
    #50;
    phase.drop_objection(this);
  endtask
  
endclass

module top;
 alu_if alu_vif();
 alu dut (.A(alu_vif.A), .B(alu_vif.B), .opcode(alu_vif.opcode), .result(alu_vif.result));
 initial begin
 uvm_config_db#(virtual alu_if)::set(null, "*", "vif", alu_vif);
 run_test("test");
 end
  
   initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
