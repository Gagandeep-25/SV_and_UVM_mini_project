class config_dff extends uvm_object;
`uvm_object_utils(config_dff)

  uvm_active_passive_enum agent_type = UVM_ACTIVE;
  /*
    uvm_active_passive_enum ,a variable declaration used to store the type of agent
    there are maily two type of agent
    1. ACTIVE AGENT = DRIVER + MONITOR (trigger DUT and collet responce)
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
