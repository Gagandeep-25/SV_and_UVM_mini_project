module ALU_4bit(
    input [3:0] A,
    input [3:0] B,
    input [2:0] Op,
    output reg [3:0] Result,
    output reg Zero,
    output reg Carry
    );
    
parameter ADD  = 3'b000;
parameter SUB  = 3'b001;
parameter AND  = 3'b010;
parameter OR   = 3'b011;
parameter XOR  = 3'b100;
parameter NOT  = 3'b101;
parameter NAND = 3'b110
parameter NOR  = 3'b111;

wire [4:0] temp;
assign temp = (Op == ADD) ? (A + B) : 
              (Op == SUB) ? (A - B) : 5'b0;  
              
always @(*) begin 
Carry = 1'b0;
Zero = 1'b0;

case (Op)
            ADD: begin
                Result = temp[3:0];
                Carry = temp[4];
            end
            SUB: begin
                Result = temp[3:0];
                Carry = temp[4];
            end
            AND:  Result = A & B;
            OR:   Result = A | B;
            XOR:  Result = A ^ B;
            NOT:  Result = ~A;
            NAND: Result = ~(A & B);
            NOR:  Result = ~(A | B);
            default: Result = 4'b0000;
        endcase
        Zero = (Result == 4'b0000) ? 1'b1 : 1'b0;
    end              
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            TESTBENCH>sv


`timescale 1ns/1ps

module tb_alu;

  logic [3:0] A, B;
  logic [2:0] Op;
  logic [3:0] Result;
  logic Zero, Carry;

  ALU_4bit dut (
    .A(A), .B(B), .Op(Op),
    .Result(Result),
    .Zero(Zero),
    .Carry(Carry)
  );

  class Stimulus;
    rand logic [3:0] a, b;
    rand logic [2:0] op;
    constraint valid_ops { op inside {
      dut.ADD, dut.SUB, dut.AND, dut.OR,
      dut.XOR, dut.NOT, dut.NAND, dut.NOR
    }; }
  endclass

  Stimulus stim;

  logic clk, reset;
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    reset = 1;
    #10;
    reset = 0;
  end

  property alu_correct;
    @(posedge clk) disable iff(reset)
    case (Op)
      dut.ADD:   {Carry,Result} == A+B;
      dut.SUB:   {Carry,Result} == A-B;
      dut.AND:   Result == (A & B);
      dut.OR:    Result == (A | B);
      dut.XOR:   Result == (A ^ B);
      dut.NOT:   Result == ~A;
      dut.NAND:  Result == ~(A & B);
      dut.NOR:   Result == ~(A | B);
      default: 1'b1;
    endcase
  endproperty

  assert property (alu_correct)
    else $error("ALU mismatch: Op=%0d A=%0d B=%0d Res=%0d", Op, A, B, Result);

  property p_zero_flag;
    @(posedge clk) (Result == 0) |-> Zero;
  endproperty

  assert property(p_zero_flag);

  initial begin
    stim = new();
    repeat (20) begin
      assert(stim.randomize());
      A  = stim.a;
      B  = stim.b;
      Op = stim.op;
      #10;
      $display("Op=%s A=%0d B=%0d => Result=%0d Carry=%b Zero=%b",
               op_to_str(Op), A, B, Result, Carry, Zero);
    end
    $finish;
  end

  function string op_to_str(logic [2:0] op);
    case(op)
      dut.ADD:   return "ADD";
      dut.SUB:   return "SUB";
      dut.AND:   return "AND";
      dut.OR:    return "OR";
      dut.XOR:   return "XOR";
      dut.NOT:   return "NOT";
      dut.NAND:  return "NAND";
      dut.NOR:   return "NOR";
      default:   return "UNK";
    endcase
  endfunction

endmodule
