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
