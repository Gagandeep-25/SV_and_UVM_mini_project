////////////////////////////////////////////////////////////////////////////////////////////////// DUT + INTERFACE ///////////////////////////////////////////////////////////////////////////////////////////////////

module alu(input [3:0] A,B,
           input [1:0] opcode,
           output reg [4:0] result);
  always @(*) begin
    case(opcode)
      2'b00 : result = A + B;
      2'b01 : result = A - B;
      2'b10 : result = A & B;
      2'b11 : result = A | B;
      default : result = 5'b00000;
    endcase
  end
endmodule

interface alu_if;
  
  logic [3:0] A,B;
  logic [1:0] opcode;
  logic [4:0] result;
  
endinterface 

///////////////////////////////////////////////////////////////////////////////////////////////// TESTBENCH /////////////////////////////////////////////////////////////////////////////////////////////////////////

`include "uvm_macros.svh"
import uvm_pkg::*;

class trans extends uvm_sequence_item;
  
  rand bit [3:0] A,B;
  rand bit [1:0] opcode;
  bit [4:0] result;
  
  `uvm_object_utils_begin(trans)
  `uvm_field_int(A, UVM_ALL_ON)
  `uvm_field_int(B, UVM_ALL_ON)
  `uvm_field_int(opcode, UVM_ALL_ON)
  `uvm_field_int(result, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "trans");
    super.new(name);
  endfunction
  
  constraint A_B_range { A inside {[1:15]};
                         B inside {[0:14]};
                         A>B;}
  
  //constraint opcode_range { opcode inside {[0:1]};}
  
endclass

class my_seq extends uvm_sequence#(trans);
  `uvm_object_utils(my_seq)
  
  function new(string name = "my_seq");
    super.new(name);
  endfunction
  
  task body();
    trans t;
    repeat(10) begin
      t = trans::type_id::create("t");
      start_item(t);
      assert(t.randomize());
      finish_item(t);
    end
  endtask
  
endclass

class my_seqr extends uvm_sequencer #(trans);
  `uvm_component_utils(my_seqr)
  
  function new(string name = "my_seqr", uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass

class driver extends uvm_driver #(trans);
  `uvm_component_utils(driver)
  
  virtual alu_if vif;
  trans t;
  
  function new(string name = "driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = trans::type_id::create("t");
    if(!uvm_config_db#(virtual alu_if)::get(this,"","vif",vif))
      `uvm_error("driver","unable to access interface");
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(t);
      
      vif.A <= t.A;
      vif.B <= t.B;
      vif.opcode <= t.opcode;
      #5;
     
      seq_item_port.item_done();
    end
  endtask
  
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  uvm_analysis_port#(trans) send;
  trans t;
  virtual alu_if vif;
  
  function new(string name = "monitor", uvm_component parent);
    super.new(name,parent);
    send = new("send",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = trans::type_id::create("t");
     if(!uvm_config_db#(virtual alu_if)::get(this,"","vif",vif))
       `uvm_error("monitor","unable to access interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      #5;
      t.A = vif.A;
      t.B = vif.B;
      t.opcode = vif.opcode;
      t.result = vif.result;
      
      send.write(t);
    end
  endtask
  
endclass

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp#(trans,scoreboard) recv;
  
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction
  
  virtual function void write(trans t);
    bit [5:0] expected;
    case (t.opcode)
     2'b00: expected = t.A + t.B;
     2'b01: expected = t.A - t.B;
     2'b10: expected = t.A & t.B;
     2'b11: expected = t.A | t.B;
   endcase
   if (expected !== t.result)
     `uvm_error("SCOREBOARD",
   $sformatf("Mismatch: A=%0d B=%0d opcode=%0b expected=%0d got=%0d",
 t.A, t.B, t.opcode, expected, t.result))
   else
     `uvm_info("SCOREBOARD", "Match!", UVM_LOW);
  endfunction
  
endclass

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

class env extends uvm_env;
  `uvm_component_utils(env)
  
  agent a;
  scoreboard s;
  
  function new(string path = "env",uvm_component parent);
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
