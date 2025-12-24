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
