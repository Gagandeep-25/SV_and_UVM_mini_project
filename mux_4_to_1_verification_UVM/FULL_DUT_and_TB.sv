/////////////////////////////////////////////////////////////////////// DUT /////////////////////////////////////////////////////////////////////////////

module mux(
  input [3:0] a,b,c,d,
  input [1:0] sel,
  output reg [3:0] y
);
  
  always @(*) begin
    case(sel)
      2'b00 : y = a;
      2'b01 : y = b;
      2'b10 : y = c;
      2'b11 : y = d;
      default : y = 4'b0000;
    endcase
  end
  
endmodule

//////////////////////////////////////////////////////////////// INTERFACE /////////////////////////////////////////////////////////////////////////////////

interface mux_if();
  
  logic [3:0] a;
  logic [3:0] b;
  logic [3:0] c;
  logic [3:0] d;
  logic [1:0] sel;
  logic [3:0] y;
  
endinterface 

/////////////////////////////////////////////////////////////////// TESTBENCH ///////////////////////////////////////////////////////////////////////////////

`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
  
  rand bit [3:0] a;
  rand bit [3:0] b;
  rand bit [3:0] c;
  rand bit [3:0] d;
  rand bit [1:0] sel;
  bit [3:0] y;
  
  function new(string path = "transaction");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(a,UVM_DEFAULT);
  `uvm_field_int(b,UVM_DEFAULT);
  `uvm_field_int(c,UVM_DEFAULT);
  `uvm_field_int(d,UVM_DEFAULT);
  `uvm_field_int(sel,UVM_DEFAULT);
  `uvm_field_int(y,UVM_DEFAULT);
  `uvm_object_utils_end
  
  constraint mux_range{
    a inside {[0:15]};
    b inside {[0:15]};
    c inside {[0:15]};
    d inside {[0:15]};
    sel inside {[0:3]};
  }
  
endclass

class generator extends uvm_sequence#(transaction);
  `uvm_object_utils(generator)
  
  transaction t;
  
  function new(string path = "generator");
    super.new(path);
  endfunction
  
  virtual task body();
    t = transaction::type_id::create("t");
    repeat(10) begin
      start_item(t);
      assert(t.randomize());
      `uvm_info("GEN", $sformatf("Data sent a : %0d, b : %0d, c : %0d, d : %0d, sel : %0d", t.a, t.b, t.c, t.d, t.sel),UVM_NONE);
      finish_item(t);
    end
  endtask
  
endclass

class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)
  
  transaction tc;
  virtual mux_if mif;
  
  function new(string path = "driver", uvm_component parent);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tc = transaction::type_id::create("tc");
    
    if(!uvm_config_db#(virtual mux_if)::get(this,"","mif",mif))
      `uvm_error("DRV","unable to access !");
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(tc);
      
      mif.a <= tc.a;
      mif.b <= tc.b;
      mif.c <= tc.c;
      mif.d <= tc.d;
      mif.sel <= tc.sel;
      
      `uvm_info("DRV",$sformatf("Data sent a : %0d, b : %0d, c : %0d, d : %0d, sel : %0d", tc.a, tc.b, tc.c, tc.d, tc.sel),UVM_NONE);
      seq_item_port.item_done();
      #10;
    end
  endtask
  
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  uvm_analysis_port#(transaction) send;
  
  transaction tm;
  virtual mux_if mif;
  
  function new(string path = "monitor", uvm_component parent);
    super.new(path,parent);
    send = new("send",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tm = transaction::type_id::create("tm");
    
    if(!uvm_config_db#(virtual mux_if)::get(this,"","mif",mif))
      `uvm_error("MON","unable to access !");
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin 
      #10;
    
      tm.a = mif.a;
      tm.b = mif.b;
      tm.c = mif.c;
      tm.d = mif.d;
      tm.sel = mif.sel;
      tm.y = mif.y;
    
       `uvm_info("MON", $sformatf("Data received a : %0d, b : %0d, c : %0d, d : %0d, sel : %0d, y : %0d", tm.a, tm.b, tm.c, tm.d, tm.sel, tm.y),UVM_NONE);
      send.write(tm);
    end
  endtask
  
endclass

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp#(transaction,scoreboard) recv;
  transaction t;
  
  function new(string path = "scoreboard", uvm_component parent);
    super.new(path,parent);
    recv = new("recv",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t  = transaction::type_id::create("t");
  endfunction
  
  virtual function void write(transaction tr);
    t = tr;
    
    `uvm_info("SCO", $sformatf("Data received a : %0d, b : %0d, c : %0d, d : %0d, sel : %0d, y : %0d", t.a, t.b, t.c, t.d, t.sel, t.y),UVM_NONE);
    
    if((t.sel == 0 && t.y == t.a)||(t.sel == 1 && t.y == t.b)||(t.sel == 2 && t.y == t.c)||(t.sel == 3 && t.y == t.d))
      `uvm_info("SCO","TEST PASSED",UVM_NONE)
      
    else 
      `uvm_info("SCO","TEST FAILED",UVM_NONE);
    
  endfunction
  
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  driver d;
  monitor m;
  uvm_sequencer#(transaction) seqr;
  
  function new(string path = "agent", uvm_component parent);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    d = driver::type_id::create("d",this);
    m = monitor::type_id::create("m",this);
    seqr = uvm_sequencer#(transaction)::type_id::create("seqr",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  
  agent a;
  scoreboard s;
  
  function new(string path = "env", uvm_component parent);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("a",this);
    s = scoreboard::type_id::create("s",this);
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
  
  function new(string path = "test", uvm_component parent);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e",this);
    gen = generator::type_id::create("gen");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
    gen.start(e.a.seqr);
    #10;
    phase.drop_objection(this);
    
  endtask
  
endclass

module tb;

  mux_if mif();
  mux dut(.a(mif.a), .b(mif.b), .c(mif.c), .d(mif.d), .sel(mif.sel), .y(mif.y));

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial begin
    uvm_config_db#(virtual mux_if)::set(null, "uvm_test_top.e.a*", "mif", mif);
    run_test("test");
  end

endmodule
