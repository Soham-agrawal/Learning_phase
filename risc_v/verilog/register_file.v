module register_file #(
    parameter WIDTH = 32,  // Default bit-width of each memory word
    parameter DEPTH = 32  // Default number of memory words
)(
    input wire clk,
    input wire reset,
    input wire wr_en,
    input wire [4:0] wr_index,
    input wire [31:0] wr_data,
    input wire [4:0] rd_index1,
    input wire rd_en1,
    input wire [4:0] rd_index2,
    input wire rd_en2,
    output reg [31:0] rd_data1,
    output reg [31:0] rd_data2
);

integer i;
reg [WIDTH-1:0] registers [0:DEPTH-1]; // DEPTH registers of WIDTH bits each
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all registers to 0
        for (i = 0; i < DEPTH; i++) begin
            registers[i] <= i;//{WIDTH{1'b0}};
        end
    end else if (wr_en && wr_index != 5'b0) begin
        // Write data to the specified register if write enable is high and index is not zero
        registers[wr_index] <= wr_data;
    end
    // Read data from the specified registers if read enable is high

end
assign rd_data1 = (rd_en1) ? registers[rd_index1] : {WIDTH{1'b0}};
assign rd_data2 = (rd_en2) ? registers[rd_index2] : {WIDTH{1'b0}};
`ifdef SIMULATION
initial begin
    $monitor("=%0d  instr=%h  (%s)", addr>>2, data_out, instr_strs[addr>>2]);
end
`endif

endmodule
