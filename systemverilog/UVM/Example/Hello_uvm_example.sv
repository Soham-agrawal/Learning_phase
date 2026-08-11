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

/*
----------------------------------------------------------------
CDNS-UVM-1.2 (25.03-s001)
(C) 2007-2014 Mentor Graphics Corporation
(C) 2007-2014 Cadence Design Systems, Inc.
(C) 2006-2014 Synopsys, Inc.
(C) 2011-2013 Cypress Semiconductor Corp.
(C) 2013-2014 NVIDIA Corporation
----------------------------------------------------------------

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
UVM_INFO @ 0: reporter [UVMTOP] UVM testbench topology:
------------------------------------
Name          Type       Size  Value
------------------------------------
uvm_test_top  base_test  -     @1532
  m_top_env   my_env     -     @1597
------------------------------------

UVM_INFO testbench.sv(19) @ 0: uvm_test_top.m_top_env [m_top_env] Hello UVM! simulation started
UVM_INFO @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    4
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1
[UVMTOP]     1
[m_top_env]     1

Simulation complete via $finish(1) at time 0 FS + 231
*/

               


  
  
  
