module half_adder (
  input  logic a, b,
  output logic sum, carry
);
  assign sum   = a ^ b;
  assign carry = a & b;
endmodule


// TESTBENCH.SV


module tb_half_adder;

  logic a, b, sum, carry;
  logic exp_sum, exp_carry;


  half_adder dut (
    .a(a),
    .b(b),
    .sum(sum),
    .carry(carry)
  );

  initial begin
    $display("Starting half adder verification...");

    for (int i = 0; i < 4; i++) begin
      {a, b} = i;
      #1;

      exp_sum   = a ^ b;
      exp_carry = a & b;

      if (sum !== exp_sum || carry !== exp_carry) begin
        $error("Test FAILED for a=%0b b=%0b | Got sum=%0b carry=%0b | Expected sum=%0b carry=%0b",
               a, b, sum, carry, exp_sum, exp_carry);
      end
      else begin
        $display("Test PASSED for a=%0b b=%0b", a, b);
      end
    end

    $display("Verification completed!");
    $finish;
  end
endmodule
