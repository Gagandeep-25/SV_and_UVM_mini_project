////////////////////////////////////////////////////////////////////////////////////////////////// DUT + INTERFACE ///////////////////////////////////////////////////////////////////////////////////////////////


module dff(
    input clk,
    input rst,
    input din,
    output reg dout
    );
    
    always @(posedge clk) begin
        if(rst)
            dout <= 1'b0;
        else 
            dout <= din;
    end
    
endmodule

interface dff_if;

    logic clk;
    logic rst;
    logic din;
    logic dout;
    
endinterface

///////////////////////////////////////////////////////////////////////////////////////////////////// TEST BENCH ///////////////////////////////////////////////////////////////////////////////////////////////

`include "uvm_macros.svh"
import uvm_pkg::*;


class config_dff extends uvm_object;
`uvm_object_utils(config_dff)

  uvm_active_passive_enum agent_type = UVM_ACTIVE;
  /*
    uvm_active_passive_enum ,a variable declaration used to store the type of agent
    there are maily two type of agent
    1. ACTIVE AGENT = DRIVER + MONITOR + SEQUENCER (trigger DUT and collet responce)
    2. PASSIVE AGENT = MONITOR (only used to collet responce)
  */  

  function new(input string path = "config_dff");
    super.new(path);
  endfunction
  
endclass

class transaction extends uvm_sequence_item;
`uvm_object_utils(transaction)

  rand bit rst;
  rand bit din;
  bit dout;
  
  function new(input string path = "transaction");
    super.new(path);
  endfunction
  
  constraint rst_din_range{
    rst inside {[0:1]};
    din inside {[0:1]};
  }
endclass

/*
in the verification of a D flipflop, we consider 3 scenario sequences
1 . when reset is 0 (low) ,> valid din
2. when reset is 1 (high)
3. when reset is random (rand)
*/

class valid_din extends uvm_sequence#(transaction);  //rst = 0
`uvm_object_utils(valid_din)

  transaction tr;
  
  function new(input string path = "valid_din");
    super.new(path);
  endfunction
  
  virtual task body();
  repeat(15)
    begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.rst = 1'b0;
      `uvm_info("SEQ1",$sformatf("rst : %0b , din : %0b , dout = %0b",tr.rst,tr.din,tr.dout),UVM_NONE);
      finish_item(tr);
    end
  endtask

endclass

class rst_dff extends uvm_sequence#(transaction); //rst is active
`uvm_object_utils(rst_dff)
  
  transaction tr;
  
  function new(input string path = "rst_dff");
    super.new(path);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.rst = 1'b1;
        `uvm_info("SEQ2",$sformatf("rst : %0b , din : %0b , dout = %0b",tr.rst,tr.din,tr.dout),UVM_NONE);
        finish_item(tr);
      end
  endtask
  
endclass

class rand_din_rst extends uvm_sequence#(transaction); //random vlaues of both din and rst
`uvm_object_utils(rand_din_rst)

  transaction tr;
  
  function new(input string path = "rand_din_rst");
    super.new(path);
  endfunction
  
  virtual task body();
  repeat(15)
    begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      `uvm_info("SEQ3",$sformatf("rst : %0b , din : %0b , dout = %0b",tr.rst,tr.din,tr.dout),UVM_NONE);
      finish_item(tr);
    end
  endtask
  
endclass

class drv extends uvm_driver#(transaction);
`uvm_component_utils(drv)
  transaction tr; 
  virtual dff_if dif;
  
  function new(input string path = "drv", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dff_if)::get(this,"","dif",dif))
      `uvm_error("drv","unable to access !");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    tr = transaction::type_id::create("tr");
    forever begin
      seq_item_port.get_next_item(tr);
      
      dif.rst <= tr.rst;
      dif.din <= tr.din;
      `uvm_info("drv",$sformatf("rst : %0b , din : %0b , dout : %0b",tr.rst,tr.din,tr.dout),UVM_NONE);
      
      seq_item_port.item_done();
      repeat(2) @(posedge dif.clk); // delay of 2 clock edges , could also be added before item_done() 
    end
  endtask
  
endclass

class mon extends uvm_monitor;
`uvm_component_utils(mon)

  transaction tr;
  virtual dff_if dif;
  uvm_analysis_port#(transaction) send;
  
  function new(input string path = "mon", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    send = new("send",this);
    if(!uvm_config_db#(virtual dff_if)::get(this,"","dif",dif))
      `uvm_error("mon","unable to access !");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
    
      repeat(2) @(posedge dif.clk);
      tr.rst = dif.rst;
      tr.din = dif.din;
      tr.dout = dif.dout;
      `uvm_info("mon",$sformatf("rst : %0b , din : %0b , dout : %0b",tr.rst,tr.din,tr.dout),UVM_NONE);
      send.write(tr); // to the analysis imp
      
    end
  endtask
  
endclass

class sco extends uvm_scoreboard;
`uvm_component_utils(sco)

  uvm_analysis_imp#(transaction,sco) recv;
  
  function new(input string path = "sco", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv",this);
  endfunction
  
  virtual function void write(transaction tr);
    `uvm_info("sco",$sformatf("rst : %0b , din : %0b , dout : %0b",tr.rst,tr.din,tr.dout),UVM_NONE);
    
    if(tr.rst == 1'b1)
      `uvm_info("sco","DFF Reset",UVM_NONE)
    else if(tr.rst == 1'b0 && (tr.din == tr.dout))
      `uvm_info("sco","TEST PASSED",UVM_NONE)
    else
      `uvm_info("sco","TEST FAILED",UVM_NONE);
      
    $display("------------------------------------------------------------------------------------------------");
        
  endfunction
  
endclass

class agent extends uvm_agent;
`uvm_component_utils(agent)

  function new(input string path = "agent", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  drv d;
  mon m;
  uvm_sequencer#(transaction) seqr;
  
  config_dff cfg; // configuration class
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m = mon::type_id::create("m",this);
    cfg = config_dff::type_id::create("cfg");
    
    if(!uvm_config_db#(config_dff)::get(this,"","cfg",cfg)) //agent gets access to the variable in config class
      `uvm_error("AGENT","unable to access config !");
      
      if(cfg.agent_type == UVM_ACTIVE)
        begin
        d = drv::type_id::create("d",this);
        seqr = uvm_sequencer#(transaction)::type_id::create("seqr",this);
        end
        
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass

class env extends uvm_env;
`uvm_component_utils(env)

  function new(input string path = "env", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  agent a;
  sco s;
  config_dff cfg;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("a",this);
    s = sco::type_id::create("s",this);
    cfg = config_dff::type_id::create("cfg");
    
    uvm_config_db#(config_dff)::set(this,"a","cfg",cfg);
    
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
  valid_din vdin;
  rst_dff rff;
  rand_din_rst rdin;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e",this);
    vdin = valid_din::type_id::create("vdin");
    rff = rst_dff::type_id::create("rff");
    rdin = rand_din_rst::type_id::create("rdin");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    rff.start(e.a.seqr);
    #40;
    vdin.start(e.a.seqr);
    #40;
    rdin.start(e.a.seqr);
    #40;
    
    phase.drop_objection(this);
  endtask
  
endclass


module tb;
 
  dff_if dif();
  
  dff dut (.clk(dif.clk), .rst(dif.rst), .din(dif.din), .dout(dif.dout));
 
  initial 
  begin
    uvm_config_db #(virtual dff_if)::set(null, "*", "dif", dif);
    run_test("test"); 
  end
  
  initial begin
    dif.clk = 0;
  end
  
  always #10 dif.clk = ~dif.clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
