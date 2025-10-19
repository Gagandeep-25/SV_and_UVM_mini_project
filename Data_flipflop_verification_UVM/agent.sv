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
