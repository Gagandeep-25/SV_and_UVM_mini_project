//////////////////////////////////////////////////////////////////////// DUT + INTERFACE ////////////////////////////////////////////////////////////////////////

module add(
  input [3:0] a,b,
  output [4:0] y
);
  
  assign y = a + b;
  
endmodule


interface add_if();
  
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] y;
  
endinterface

//////////////////////////////////////////////////////////////////////// TESTBENCH ///////////////////////////////////////////////////////////////////////////////

`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
  
  rand bit [3:0] a;
  rand bit [3:0] b;
  bit [4:0] y;
  
  function new(string path = "transaction");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(a,UVM_DEFAULT);
  `uvm_field_int(b,UVM_DEFAULT);
  `uvm_field_int(y,UVM_DEFAULT);
  `uvm_object_utils_end
  
endclass

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

class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)
  
  transaction tc;
  virtual add_if aif;
  
  function new(input string path = "driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tc = transaction::type_id::create("tc");
    
    if(!uvm_config_db #(virtual add_if)::get(this,"","aif",aif))
      `uvm_error("DRV","unable to access");
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin      
      seq_item_port.get_next_item(tc);
      
      aif.a <= tc.a;
      aif.b <= tc.b;
      `uvm_info("DRV",$sformatf("triggrt DUT a : %0d and b : %0d",tc.a,tc.b),UVM_NONE);
      
      seq_item_port.item_done();
      #10;
    end
  endtask
  
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  uvm_analysis_port #(transaction) send;
  
  function new(input string path = "monitor", uvm_component parent = null);
    super.new(path,parent);
    send = new("send",this);
  endfunction
  
  transaction t;
  virtual add_if aif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("t");
    
    if(!uvm_config_db#(virtual add_if)::get(this,"","aif",aif))
      `uvm_error("MON","unable to access");
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      
      #10;
      t.a = aif.a;
      t.b = aif.b;
      t.y = aif.y;
      
      `uvm_info("MON",$sformatf("sent to scoreboard a : %0d, b : %0d and y : %0d",t.a,t.b,t.y),UVM_NONE);
      send.write(t);
    end
  endtask
  
endclass

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

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  monitor m;
  driver d;
  uvm_sequencer #(transaction) seq;
  
  function new(input string path = "agent", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
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

class env extends uvm_env;
  `uvm_component_utils(env)
  
  scoreboard s;
  agent a;
  
  function new(input string path = "env", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s = scoreboard::type_id::create("s",this);
    a = agent::type_id::create("a",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.m.send.connect(s.recv);
  endfunction
  
endclass

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

module add_tb();
  
  add_if aif();
  
  add dut (.a(aif.a),.b(aif.b),.y(aif.y));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    uvm_config_db#(virtual add_if)::set(null,"uvm_test_top.e.a*","aif",aif);
    run_test("test");
  end
  
endmodule
