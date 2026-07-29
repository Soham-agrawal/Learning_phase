module top_risc_v (
    input wire clk,
    input wire reset,
    output wire [31:0] pc_out
);

    wire [31:0] next_pc;

    // Instantiate the program counter
    program_counter pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc_out)
    );

    // Logic to determine the next program counter value
    // For simplicity, let's just increment the PC by 4 for each clock cycle
    assign next_pc = pc_out + 4;