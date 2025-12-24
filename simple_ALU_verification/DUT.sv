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
