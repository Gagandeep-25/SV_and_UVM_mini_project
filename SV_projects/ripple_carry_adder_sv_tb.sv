//  DESIGN FILE 
module full_adder(
    input  A,
    input  B,
    input  Cin,
    output sum,
    output Cout
);
  assign sum  = A ^ B ^ Cin;
  assign Cout = (A & B) | (Cin & (A ^ B));
endmodule


module fbfa(
    input  A0, A1, A2, A3,
    input  B0, B1, B2, B3,
    input  Cin,
    output S0, S1, S2, S3,
    output C4
);
  wire C1, C2, C3;

  full_adder FA0(.A(A0), .B(B0), .Cin(Cin), .sum(S0), .Cout(C1));
  full_adder FA1(.A(A1), .B(B1), .Cin(C1),  .sum(S1), .Cout(C2));
  full_adder FA2(.A(A2), .B(B2), .Cin(C2),  .sum(S2), .Cout(C3));
  full_adder FA3(.A(A3), .B(B3), .Cin(C3),  .sum(S3), .Cout(C4));
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TEST BENCH 

// TRANSACTION 
class adder_trans;
  rand bit [3:0] A;
  rand bit [3:0] B;
  rand bit       Cin;

  constraint valid_range {
    A inside {[0:15]};
    B inside {[0:15]};
    Cin inside {0,1};
  }

  function void display();
    $display("Generated inputs : A=%0d | B=%0d | Cin=%0d", A, B, Cin);
  endfunction
endclass

//MAIN TESTBENCH 
module tb_fbfa;

  logic A0, A1, A2, A3;
  logic B0, B1, B2, B3;
  logic Cin;
  logic S0, S1, S2, S3, C4;

  fbfa dut(
    .A0(A0), .A1(A1), .A2(A2), .A3(A3),
    .B0(B0), .B1(B1), .B2(B2), .B3(B3),
    .Cin(Cin),
    .S0(S0), .S1(S1), .S2(S2), .S3(S3), .C4(C4)
  );

  logic [4:0] expected_sum;

  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0, tb_fbfa);
  end

  adder_trans trans;

  initial begin
    trans = new();

    $display("Starting 4-bit Ripple Carry Adder Verification with Randomization...");

    repeat (20) begin
      if (!trans.randomize()) begin
        $error("Randomization failed!");
      end

      {A3, A2, A1, A0} = trans.A;
      {B3, B2, B1, B0} = trans.B;
      Cin              = trans.Cin;

      #1; 

      expected_sum = trans.A + trans.B + trans.Cin;

      #1; 

      if ({C4, S3, S2, S1, S0} !== expected_sum) begin
        $error("Mismatch! A=%0d B=%0d Cin=%0b | DUT={C4,S3..S0}=%0d | Expected=%0d",
               trans.A, trans.B, trans.Cin, {C4, S3, S2, S1, S0}, expected_sum);
      end else begin
        $display("PASS: A=%0d B=%0d Cin=%0b | Sum=%0d",
                 trans.A, trans.B, trans.Cin, expected_sum);
      end
    end

    $display("Verification completed!");
    $finish;
  end
endmodule
