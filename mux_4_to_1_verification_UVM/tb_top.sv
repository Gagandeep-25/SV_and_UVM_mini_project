module tb;

  mux_if mif();
  mux dut(.a(mif.a), .b(mif.b), .c(mif.c), .d(mif.d), .sel(mif.sel), .y(mif.y));

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial begin
    uvm_config_db#(virtual mux_if)::set(null, "uvm_test_top.e.a*", "mif", mif);
    run_test("test");
  end

endmodule
