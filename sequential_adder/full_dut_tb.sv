////////////////////////////////////////////////////////////////////////////////////////////// DUT + INTERFACE //////////////////////////////////////////////////////////////////////////////////////////////

module add(
  input rst,clk,
  input [3:0] a,b,
  output reg [4:0] y
);
  
  always @(posedge clk or posedge rst) begin
    if(rst)
      y <= 5'b00000;
    else 
      y <= a + b;
  end
    
endmodule

interface add_if();
  
  logic clk;
  logic rst;
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] y;
  
endinterface 

////////////////////////////////////////////////////////////////////////////////////////////// TESTBENCH ////////////////////////////////////////////////////////////////////////////////////////////////////

`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
  
  rand bit [3:0] a;
  rand bit [3:0] b;
  bit [4:0] y;
  
  function new(input string path = "transaction");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(a,UVM_DEFAULT);
  `uvm_field_int(b,UVM_DEFAULT);
  `uvm_field_int(y,UVM_DEFAULT);
  `uvm_object_utils_end
  
  constraint addder_range{
    soft a inside {[0:15]};
    soft b inside {[1:15]};
  }
  
endclass

class generator extends uvm_sequence#(transaction);
  `uvm_object_utils(generator)
  
  transaction t;
  
  function new(input string path = "generator");
    super.new(path);
  endfunction
  
  virtual task body();
    t = transaction::type_id::create("t");
    repeat(10) begin
      
      start_item(t);
      assert(t.randomize());
      `uvm_info("GEN",$sformatf("Data sent to driver a : %0d and b : %0d",t.a,t.b),UVM_NONE);
      finish_item(t);
      
    end
  endtask
  
endclass

class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)
  
  function new(input string path = "driver", uvm_component parent);
    super.new(path,parent);
  endfunction
  
  transaction data;
  virtual add_if aif;
  
  task reset_dut();
    aif.rst <= 1'b1;
    aif.a <= 0;
    aif.b <= 0;
    
    repeat(5) @(posedge aif.clk);
      aif.rst =  1'b0;
    `uvm_info("DRV","Reset Done",UVM_NONE);
  endtask
    
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    data = transaction::type_id::create("data");
      
    if(!uvm_config_db#(virtual add_if)::get(this,"","aif",aif))
      `uvm_error("DRV","Unable to access");
  endfunction
    
  virtual task run_phase(uvm_phase phase);
    reset_dut();
    forever begin 
      
      seq_item_port.get_next_item(data);
      aif.a <= data.a;
      aif.b <= data.b;
      `uvm_info("DRV",$sformatf("trigger DUT a : %0d and b : %0d",data.a,data.b),UVM_NONE);
      seq_item_port.item_done();
      repeat(2) @(posedge aif.clk); //wait for 2 clk tick unit we send the next transaction to DUT
      
    end
  endtask
  
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  uvm_analysis_port #(transaction) send;
  
  function new(input string path = "monitor", uvm_component parent);
    super.new(path,parent);
    send = new("send",this);
  endfunction
  
  transaction t;
  virtual add_if aif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("t");
    
    if(!uvm_config_db#(virtual add_if)::get(this,"","aif",aif))
      `uvm_error("MON","unable to access!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    @(negedge aif.rst); //wait for reset to complete 
    forever begin
      repeat(2) @(posedge aif.clk); // wait for 2 clock tick with respect to driver
      t.a = aif.a;
      t.b = aif.b;
      t.y = aif.y;
      `uvm_info("MON",$sformatf("Sent to scoreboard a : %0d , b : %0d and y : %0d",t.a,t.b,t.y),UVM_NONE);
      send.write(t);
    end
  endtask
  
endclass

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

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  function new(input string path = "agent", uvm_component parent);
    super.new(path,parent);
  endfunction
  
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

class env extends uvm_env;
  `uvm_component_utils(env)
  
  function new(input string path = "env", uvm_component parent);
    super.new(path,parent);
  endfunction
  
  scoreboard s;
  agent a;
  
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
  
  env e;
  generator gen;
  
  function new(input string path = "test", uvm_component parent);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gen = generator::type_id::create("gen");
    e = env::type_id::create("e",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
    gen.start(e.a.seq);
    #40;
    phase.drop_objection(this);
    
  endtask
  
endclass

module add_tb();
  
  add_if aif();
  
  initial begin
    aif.clk = 0;
    aif.rst = 0;
  end
  
  always #10 aif.clk = ~aif.clk;
  
  add dut (.a(aif.a), .b(aif.b), .y(aif.y), .clk(aif.clk), .rst(aif.rst));
 
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin  
    uvm_config_db #(virtual add_if)::set(null, "*", "aif", aif);
    run_test("test");
  end
  
endmodule
