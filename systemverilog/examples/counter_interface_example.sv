`timescale 1ns/1ns

module counter_ud 
  #(parameter WIDTH = 4)
  ( 
  input 					clk,
  input 					rstn,
  input wire [WIDTH-1:0]	load,
  input 					load_en,
  input 					down,
  output 					rollover,
  output reg [WIDTH-1:0]	count 
);
  

  always @ (posedge clk or negedge rstn) begin
    if (!rstn)
   		count <= 0;
    else 
      if (load_en)
        count <= load;
      else begin
      	if (down)
        	count <= count - 1;
      	else
        	count <= count + 1;
      end
  end
  
  assign rollover = &count;
  
endmodule
  
