module register_file (
    input reg width = 32,
    input reg depth = 32,
    input wire reset,
    input wire wr_en,
    input wire [4:0] addr,
    input wire [31:0] wr_data,
    input wire rd_en,
    output reg [31:0] rd_data
);

reg [width-1:0] registers [0:depth-1]; // depth registers of width bits each
always @(*) begin
    if (reset) begin
        // Reset all registers to 0
        for (int i = 0; i < depth; i++) begin
            registers[i] <= {width{1'b0}};
        end
    end else if (wr_en) begin
        // Write data to the specified register if write enable is high and index is not zero
        registers[addr] <= wr_data;
    end
    // Read data from the specified registers if read enable is high
    rd_data <= (rd_en) ? registers[addr] : {width{1'b0}};
end
endmodule
