class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  uvm_analysis_port#(transaction) send;

  transaction tm;
  virtual mux_if mif;

  function new(string path = "monitor", uvm_component parent);
    super.new(path, parent);
    send = new("send", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tm = transaction::type_id::create("tm");

    if(!uvm_config_db#(virtual mux_if)::get(this, "", "mif", mif))
      `uvm_error("MON", "Unable to access uvm_config_db");

  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      #10;

      tm.a = mif.a;
      tm.b = mif.b;
      tm.c = mif.c;
      tm.d = mif.d;
      tm.y = mif.y;
      tm.sel = mif.sel;

      `uvm_info("MON", $sformatf("Data received a : %0d, b : %0d, c : %0d, d : %0d, sel : %0d, y : %0d", tm.a, tm.b, tm.c, tm.d, tm.sel, tm.y),UVM_NONE);
      send.write(tm);
    end
  endtask     

endclass
