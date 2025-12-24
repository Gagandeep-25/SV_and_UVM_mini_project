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

class sc
