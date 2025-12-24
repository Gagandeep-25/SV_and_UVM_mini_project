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

class age
