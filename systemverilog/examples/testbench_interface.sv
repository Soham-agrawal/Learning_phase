interface counter_interface #(parameter WIDTH = 4) (input bit clk);
  logic 			rstn;
  logic 			load_en;
  logic [WIDTH-1:0] load;
  logic [WIDTH-1:0] count;
  logic 			down;
  logic 			rollover;
endinterface

module tb;
  reg clk;
  
  // TB Clock Generator used to provide the design
  // with a clock -> here half_period = 10ns => 50 MHz
  always #10 clk = ~clk;
  
  counter_interface 	  counter_interface0 (clk);
  counter_dut  c0 ( 	.clk 		(cnt_if0.clk),
                  	.rstn 		(cnt_if0.rstn),
                  	.load 		(cnt_if0.load),
                  	.load_en 	(cnt_if0.load_en),
                  	.down 		(cnt_if0.down),
                  	.rollover 	(cnt_if0.rollover),
                  	.count 		(cnt_if0.count));
  
  initial begin
    bit load_en, down;
    bit [3:0] load;
    
    $monitor("[%0t] down=%0b load_en=%0b load=0x%0h count=0x%0h rollover=%0b", $time, counter_interface0.down, counter_interface0.load_en, counter_interface0.load, counter_interface0.count, counter_interface0.rollover);
    
    // Initialize testbench variables
    clk <= 0;
    counter_interface0.rstn <= 0;
    counter_interface0.load_en <= 0;
    counter_interface0.load <= 0;
    counter_interface0.down <= 0;
    
    // Drive design out of reset after 5 clocks
    repeat (5) @(posedge clk);
    counter_interface0.rstn <= 1;
    
    // Drive stimulus -> repeat 5 times
    for (int i = 0; i < 5; i++) begin
      
      // Drive inputs after some random delay 
      int delay = $urandom_range (1,30);
      #(delay);
      
      // Randomize input values to be driven
      std::randomize(load, load_en, down);
     
      // Assign tb values to interface signals
      counter_interface0.load <= load;
      counter_interface0.load_en <= load_en;
      counter_interface0.down <= down;
    end
    
    // Wait for 5 clocks and finish simulation
    repeat(5) @ (posedge clk);
    $finish;
  end
   
  initial begin
    $dumpvars;
    $dumpfile("sth.vcd");
  end
endmodule

/* 
Simulation Log:
---------------
ncsim> run
[0] down=0 load_en=0 load=0x0 count=0x0 rollover=0
[96] down=1 load_en=1 load=0x1 count=0x0 rollover=0
[102] down=0 load_en=0 load=0x9 count=0x0 rollover=0
[108] down=1 load_en=1 load=0x1 count=0x0 rollover=0
[110] down=1 load_en=1 load=0x1 count=0x1 rollover=0
[114] down=1 load_en=0 load=0xc count=0x1 rollover=0
[120] down=1 load_en=0 load=0x7 count=0x1 rollover=0
[130] down=1 load_en=0 load=0x7 count=0x0 rollover=0
[150] down=1 load_en=0 load=0x7 count=0xf rollover=1
[170] down=1 load_en=0 load=0x7 count=0xe rollover=0
[190] down=1 load_en=0 load=0x7 count=0xd rollover=0
Simulation complete via $finish(1) at time 210 NS + 0
./testbench.sv:66     $finish;
ncsim> exit
*/
