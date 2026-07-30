module readonly_mem #(
    parameter WIDTH = 32,  // Default bit-width of each memory word
    parameter DEPTH = 256  // Default number of memory words
)(
    input wire [31:0] addr,     // 32-bit address input
    output reg [WIDTH-1:0] data_out // Output matches the configured width
);

    // Define the memory array using the compile-time parameters
    reg [WIDTH-1:0] memory [0:DEPTH-1];

    initial begin
        // Initialize memory locations 
        memory[0] = 32'h00000000; // NOP
        memory[1] = 32'h00000001; // Some instruction
        memory[2] = 32'h00000002; // Some instruction
        // Remaining uninitialized locations default to zero or X depending on the simulator
    end

    // Pure combinational read logic
    always @(*) begin
        // Using $clog2 safely scales the address bits to match the DEPTH parameter
        data_out = memory[addr[$clog2(DEPTH)-1:0]]; 
    end 

endmodule
