module data_memory #(
    parameter WIDTH = 32,  // Default bit-width of each memory word
    parameter DEPTH = 256  // Default number of memory words
)(
    input wire reset,
    input wire wr_en,
    input wire [4:0] addr,
    input wire [31:0] wr_data,
    input wire rd_en,
    output reg [31:0] rd_data
);

reg [WIDTH-1:0] registers [0:DEPTH-1]; // DEPTH registers of WIDTH bits each
integer i;
always @(*) begin
    if (reset) begin
        // Reset all registers to 0
        for (i = 0; i < DEPTH; i++) begin
            registers[i] <= {WIDTH{1'b0}};
        end
    end else begin
        if (wr_en) begin
        // Write data to the specified register if write enable is high and index is not zero
        registers[addr] <= wr_data;
        end
        // Read data from the specified registers if read enable is high
        rd_data <= (rd_en) ? registers[addr] : {WIDTH{1'b0}};
    end
end
endmodule
