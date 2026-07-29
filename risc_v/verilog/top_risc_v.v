module top_risc_v (
    input wire clk,
    input wire reset,
    output wire [31:0] pc_out
);

    wire [31:0] next_pc;
    wire [31:0] instr;
    wire [4:0] rs1, rs2, rd;
    wire [6:0] opcode, funct7;
    wire [2:0] funct3;  
    wire [31:0] imm;
    wire funct3_valid, funct7_valid, rs1_valid, rs2_valid, rd_valid, imm_valid;

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

    readonly_mem rom_inst (
        .addr(pc_out),
        .data_out(instr) 
    );

    decoder decoder_inst (
        .instr(instr),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .imm(imm),
        .funct3_valid(funct3_valid),
        .funct7_valid(funct7_valid),
        .rs1_valid(rs1_valid),
        .rs2_valid(rs2_valid),
        .rd_valid(rd_valid),
        .imm_valid(imm_valid)
    ); 
    
    register_file reg_file_inst (
        .reset(reset),
        .wr_en(rd_valid), 
        .wr_index(rd),
        .wr_data(32'b0),
        .rd_index1(rs1),
        .rd_en1(rs1_valid),
        .rd_index2(rs2),
        .rd_en2(rs2_valid),
        .rd_data1(src1_value), 
        .rd_data2(src2_value)  
    );

   