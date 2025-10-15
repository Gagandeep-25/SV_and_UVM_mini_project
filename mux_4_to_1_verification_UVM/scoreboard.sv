class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_analysis_imp#(transaction, scoreboard) recv;
  transaction t;

  function new(string path = "scoreboard", uvm_component parent);
    super.new(path, parent);
    recv = new("recv", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("t");
  endfunction

  virtual function void write(input transaction tr);
    t = tr;

    `uvm_info("SCO", $sformatf("Data received a : %0d, b : %0d, c : %0d, d : %0d, sel : %0d, y : %0d", t.a, t.b, t.c, t.d, t.sel, t.y),UVM_NONE);

    if((t.sel == 0 && t.y == t.a) || (t.sel == 1 && t.y == t.b) || (t.sel == 2 && t.y == t.c) || (t.sel == 3 && t.y == t.d))
      `uvm_info("SCO", "TEST_PASSED",UVM_NONE)

    else
      `uvm_info("SCO", "TEST_FAILED",UVM_NONE);

  endfunction
endclass

