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
