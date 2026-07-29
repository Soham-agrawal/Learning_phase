module readonly_mem (
    input wire [31:0] addr,
    output reg [31:0] data_out
);

    // Define a simple read-only memory with 256 words (32-bit each)
    reg [31:0] memory [0:255];

    initial begin
        // Initialize the memory with some values (for example, instructions)
        memory[0] = 32'h00000000; // NOP
        memory[1] = 32'h00000001; // Some instruction
        memory[2] = 32'h00000002; // Some instruction
        // ... Initialize other memory locations as needed
    end

    always @(*) begin
        data_out = memory[addr[7:0]]; // Read from the memory using the lower 8 bits of the address
    end 
    endmodule