module readonly_mem #(
    parameter WIDTH = 32,  // Default bit-width of each memory word
    parameter DEPTH = 256  // Default number of memory words
)(
    input wire clk,          // Clock signal for synchronous operations
    input wire [31:0] addr,     // 32-bit address input
    output reg [WIDTH-1:0] data_out, // Output matches the configured width
    output reg [(40*8)-1:0] instr_name // Output matches the configured width
);

    // Define the memory array using the compile-time parameters
    reg [WIDTH-1:0] memory [0:DEPTH-1];

    initial begin
        // Initialize memory locations 
    
        memory[0]  = {12'b10101,        5'd0, 3'b000, 5'd1,  7'b0010011}; // ADDI x1,x0,21
        memory[1]  = {12'b111,          5'd0, 3'b000, 5'd2,  7'b0010011}; // ADDI x2,x0,7
        memory[2]  = {12'b111111111100, 5'd0, 3'b000, 5'd3,  7'b0010011}; // ADDI x3,x0,-4
        memory[3]  = {12'b1011100, 5'd1, 3'b111, 5'd5,  7'b0010011}; // ANDI x5,x1,0x5C
        memory[4]  = {12'b10101,   5'd5, 3'b100, 5'd5,  7'b0010011}; // XORI x5,x5,21
        memory[5]  = {12'b1011100, 5'd1, 3'b110, 5'd6,  7'b0010011}; // ORI x6,x1,0x5C
        memory[6]  = {12'b1011100, 5'd6, 3'b100, 5'd6,  7'b0010011}; // XORI x6,x6,0x5C
        memory[7]  = {12'b111,     5'd1, 3'b000, 5'd7,  7'b0010011}; // ADDI x7,x1,7
        memory[8]  = {12'b11101,   5'd7, 3'b100, 5'd7,  7'b0010011}; // XORI x7,x7,29
        memory[9]  = {6'b000000, 6'b110, 5'd1, 3'b001, 5'd8,  7'b0010011}; // SLLI x8,x1,6
        memory[10] = {12'b10101000001, 5'd8, 3'b100, 5'd8,  7'b0010011}; // XORI x8,x8,1345
        memory[11] = {6'b000000, 6'b10,  5'd1, 3'b101, 5'd9,  7'b0010011}; // SRLI x9,x1,2
        memory[12] = {12'b100,   5'd9, 3'b100, 5'd9,  7'b0010011}; // XORI x9,x9,4
        memory[13] = {7'b0000000, 5'd2, 5'd1, 3'b111, 5'd10, 7'b0110011}; // AND x10,x1,x2
        memory[14] = {12'b100,   5'd10, 3'b100, 5'd10, 7'b0010011}; // XORI x10,x10,4
        memory[15] = {7'b0000000, 5'd2, 5'd1, 3'b110, 5'd11, 7'b0110011}; // OR x11,x1,x2
        memory[16] = {12'b10110, 5'd11, 3'b100, 5'd11, 7'b0010011}; // XORI x11,x11,22
        memory[17] = {7'b0000000, 5'd2, 5'd1, 3'b100, 5'd12, 7'b0110011}; // XOR x12,x1,x2
        memory[18] = {12'b10011, 5'd12, 3'b100, 5'd12, 7'b0010011}; // XORI x12,x12,19
        memory[19] = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd13, 7'b0110011}; // ADD x13,x1,x2
        memory[20] = {12'b11101, 5'd13, 3'b100, 5'd13, 7'b0010011}; // XORI x13,x13,29
        memory[21] = {7'b0100000, 5'd2, 5'd1, 3'b000, 5'd14, 7'b0110011}; // SUB x14,x1,x2
        memory[22] = {12'b1111,  5'd14, 3'b100, 5'd14, 7'b0010011}; // XORI x14,x14,15
        memory[23] = {7'b0000000, 5'd2, 5'd2, 3'b001, 5'd15, 7'b0110011}; // SLL x15,x2,x2
        memory[24] = {12'b1110000001, 5'd15, 3'b100, 5'd15, 7'b0010011}; // XORI x15,x15,897
        memory[25] = {7'b0000000, 5'd2, 5'd1, 3'b101, 5'd16, 7'b0110011}; // SRL x16,x1,x2
        memory[26] = {12'b1,     5'd16, 3'b100, 5'd16, 7'b0010011}; // XORI x16,x16,1
        memory[27] = {7'b0000000, 5'd1, 5'd2, 3'b011, 5'd17, 7'b0110011}; // SLTU x17,x2,x1
        memory[28] = {12'b0,     5'd17, 3'b100, 5'd17, 7'b0010011}; // XORI x17,x17,0
        memory[29] = {12'b10101, 5'd2, 3'b011, 5'd18, 7'b0010011}; // SLTIU x18,x2,21
        memory[30] = {12'b0,     5'd18, 3'b100, 5'd18, 7'b0010011}; // XORI x18,x18,0
        memory[31] = {20'b0,     5'd19, 7'b0110111}; // LUI x19,0
        memory[32] = {12'b1,     5'd19, 3'b100, 5'd19, 7'b0010011}; // XORI x19,x19,1
        memory[33] = {6'b010000, 6'b1, 5'd3, 3'b101, 5'd20, 7'b0010011}; // SRAI x20,x3,1
        memory[34] = {12'b111111111111, 5'd20, 3'b100, 5'd20, 7'b0010011}; // XORI x20,x20,-1
        memory[35] = {7'b0000000, 5'd1, 5'd3, 3'b010, 5'd21, 7'b0110011}; // SLT x21,x3,x1
        memory[36] = {12'b0,     5'd21, 3'b100, 5'd21, 7'b0010011}; // XORI x21,x21,0
        memory[37] = {12'b1,     5'd3,  3'b010, 5'd22, 7'b0010011}; // SLTI x22,x3,1
        memory[38] = {12'b0,     5'd22, 3'b100, 5'd22, 7'b0010011}; // XORI x22,x22,0
        memory[39] = {7'b0100000, 5'd2, 5'd1, 3'b101, 5'd23, 7'b0110011}; // SRA x23,x1,x2
        memory[40] = {12'b1,     5'd23, 3'b100, 5'd23, 7'b0010011}; // XORI x23,x23,1
        memory[41] = {20'b100,   5'd4,  7'b0010111}; // AUIPC x4,100
        memory[42] = {6'b000000, 6'b111, 5'd4, 3'b101, 5'd24, 7'b0010011}; // SRLI x24,x4,7
        memory[43] = {12'b10000000, 5'd24, 3'b100, 5'd24, 7'b0010011}; // XORI x24,x24,128
        memory[44] = {1'b0, 10'b0000000010, 1'b0, 8'b0, 5'd25, 7'b1101111}; // JAL x25,10
        memory[45] = {20'b0,     5'd4,  7'b0010111}; // AUIPC x4,0
        memory[46] = {7'b0000000, 5'd4, 5'd25, 3'b100, 5'd25, 7'b0110011}; // XOR x25,x25,x4
        memory[47] = {12'b1,     5'd25, 3'b100, 5'd25, 7'b0010011}; // XORI x25,x25,1
        memory[48] = {12'b10000, 5'd4,  3'b000, 5'd26, 7'b1100111}; // JALR x26,x4,16
        memory[49] = {7'b0100000, 5'd4, 5'd26, 3'b000, 5'd26, 7'b0110011}; // SUB x26,x26,x4
        memory[50] = {12'b111111110001, 5'd26, 3'b000, 5'd26, 7'b0010011}; // ADDI x26,x26,-15
        memory[51] = {7'b0000000, 5'd1, 5'd2, 3'b010, 5'b00001, 7'b0100011}; // SW x2,x1,1
        memory[52] = {12'b1,     5'd2,  3'b010, 5'd27, 7'b0000011}; // LW x27,x2,1
        memory[53] = {12'b10100, 5'd27, 3'b100, 5'd27, 7'b0010011}; // XORI x27,x27,20
        memory[54] = {12'b1,     5'd0,  3'b000, 5'd28, 7'b0010011}; // ADDI x28,x0,1
        memory[55] = {12'b1,     5'd0,  3'b000, 5'd29, 7'b0010011}; // ADDI x29,x0,1
        memory[56] = {12'b1,     5'd0,  3'b000, 5'd30, 7'b0010011}; // ADDI x30,x0,1
        memory[57] = {1'b0, 10'b0, 1'b0, 8'b0, 5'd0, 7'b1101111}; // JAL x0,0 (infinite loop, done)
        // Remaining uninitialized locations default to zero or X depending on the simulator
    end
    //`ifdef SIMULATION
        reg [(40*8)-1:0] instr_strs [0:57];
        initial begin
            instr_strs[0]  = "ADDI x1,x0,21";
            instr_strs[1]  = "ADDI x2,x0,7";
            instr_strs[2]  = "ADDI x3,x0,-4";
            instr_strs[3]  = "ANDI x5,x1,0x5C";
            instr_strs[4]  = "XORI x5,x5,21";
            instr_strs[5]  = "ORI x6,x1,0x5C";
            instr_strs[6]  = "XORI x6,x6,0x5C";
            instr_strs[7]  = "ADDI x7,x1,7";
            instr_strs[8]  = "XORI x7,x7,29";
            instr_strs[9]  = "SLLI x8,x1,6";
            instr_strs[10] = "XORI x8,x8,1345";
            instr_strs[11] = "SRLI x9,x1,2";
            instr_strs[12] = "XORI x9,x9,4";
            instr_strs[13] = "AND x10,x1,x2";
            instr_strs[14] = "XORI x10,x10,4";
            instr_strs[15] = "OR x11,x1,x2";
            instr_strs[16] = "XORI x11,x11,22";
            instr_strs[17] = "XOR x12,x1,x2";
            instr_strs[18] = "XORI x12,x12,19";
            instr_strs[19] = "ADD x13,x1,x2";
            instr_strs[20] = "XORI x13,x13,29";
            instr_strs[21] = "SUB x14,x1,x2";
            instr_strs[22] = "XORI x14,x14,15";
            instr_strs[23] = "SLL x15,x2,x2";
            instr_strs[24] = "XORI x15,x15,897";
            instr_strs[25] = "SRL x16,x1,x2";
            instr_strs[26] = "XORI x16,x16,1";
            instr_strs[27] = "SLTU x17,x2,x1";
            instr_strs[28] = "XORI x17,x17,0";
            instr_strs[29] = "SLTIU x18,x2,21";
            instr_strs[30] = "XORI x18,x18,0";
            instr_strs[31] = "LUI x19,0";
            instr_strs[32] = "XORI x19,x19,1";
            instr_strs[33] = "SRAI x20,x3,1";
            instr_strs[34] = "XORI x20,x20,-1";
            instr_strs[35] = "SLT x21,x3,x1";
            instr_strs[36] = "XORI x21,x21,0";
            instr_strs[37] = "SLTI x22,x3,1";
            instr_strs[38] = "XORI x22,x22,0";
            instr_strs[39] = "SRA x23,x1,x2";
            instr_strs[40] = "XORI x23,x23,1";
            instr_strs[41] = "AUIPC x4,100";
            instr_strs[42] = "SRLI x24,x4,7";
            instr_strs[43] = "XORI x24,x24,128";
            instr_strs[44] = "JAL x25,10";
            instr_strs[45] = "AUIPC x4,0";
            instr_strs[46] = "XOR x25,x25,x4";
            instr_strs[47] = "XORI x25,x25,1";
            instr_strs[48] = "JALR x26,x4,16";
            instr_strs[49] = "SUB x26,x26,x4";
            instr_strs[50] = "ADDI x26,x26,-15";
            instr_strs[51] = "SW x2,x1,1";
            instr_strs[52] = "LW x27,x2,1";
            instr_strs[53] = "XORI x27,x27,20";
            instr_strs[54] = "ADDI x28,x0,1";
            instr_strs[55] = "ADDI x29,x0,1";
            instr_strs[56] = "ADDI x30,x0,1";
            instr_strs[57] = "JAL x0,0 (done)";
        end
    //`endif
    // Pure combinational read logic
    //always @(posedge clk) begin
    // Using $clog2 safely scales the address bits to match the DEPTH parameter
    assign data_out = memory[addr>>2]; 
    assign instr_name = instr_strs[addr>>2]; // Fetch the instruction string based on the address
    //end 
    always @(addr) begin
        `ifdef SIMULATION
            $display("PC=%0d  instr=%h  (%s)", addr>>2, data_out, instr_strs[addr>>2]);
        `endif
    end
endmodule
