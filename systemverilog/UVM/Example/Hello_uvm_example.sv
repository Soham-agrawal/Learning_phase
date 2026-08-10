import uvm_pkg::*;
`include "uvm_macros.svh"

//env.sv
class my_env extends uvm_env;
  `uvm_component_utils(my_env)
  
  function new (string name, uvm_component parent);
    super.new (name, parent);
  endfunction : new
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase
  
  task run_phase (uvm_phase phase);
    `uvm_info (get_name(), $sformatf ("Hello UVM! simulation started"), UVM_LOW)
  endtask : run_phase
endclass : my_env

//test.sv            
class base_test extends uvm_test;
  
  `uvm_component_utils (base_test)
  
  my_env m_top_env;
  
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase (phase);
    m_top_env = my_env::type_id::create ("m_top_env", this);
  endfunction : build_phase
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
endclass : base_test

//testbench.sv
module tb_top;
//  import uvm_pkg::*;
// `include "uvm_macros.svh"

// `include "env.sv"
// `include "test.sv"
  
  initial begin
    run_test("base_test");
  end
endmodule


               


  
  
  
