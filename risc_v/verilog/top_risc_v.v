module top_risc_v (
    input wire clk,
    input wire reset
);

    wire [31:0] next_pc;
    wire [31:0] pc;
    wire [31:0] instr;
    wire [4:0] rs1, rs2, rd;
    wire [6:0] opcode, funct7;
    wire [2:0] funct3;  
    wire [31:0] imm;
    wire funct3_valid, funct7_valid, rs1_valid, rs2_valid, rd_valid, imm_valid;
    wire [31:0] src1_value, src2_value;
    wire [10:0] dec_bits;
    wire [31:0] result;
    wire is_jal, is_jalr, is_beq, is_bne, is_blt, is_bge, is_bltu, is_bgeu;
    wire taken_br;
    wire is_load, is_s_instr;  
    wire [31:0] ld_data;
    wire [31:0] br_tgt_pc, jalr_tgt_pc;
    

    // Instantiate the program counter
    program_counter pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Logic to determine the next program counter value
    // For simplicity, let's just increment the PC by 4 for each clock cycle
    assign br_tgt_pc[31:0] = imm + pc;
    assign jalr_tgt_pc[31:0] = src1_value + imm;
    assign next_pc = taken_br ? br_tgt_pc[31:0]   : 
                     is_jalr  ? jalr_tgt_pc[31:0] :
                     pc + 32'd4;

    wire [40*8-1:0] instr_name; // Array to hold instruction strings for simulation
    readonly_mem #(.WIDTH(32), .DEPTH(256)) rom_inst (
        .clk(clk),
        .addr(pc),
        .data_out(instr),
        .instr_name(instr_name)
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
    
    register_file #(.WIDTH(32), .DEPTH(32)) reg_file_inst (
        .clk(clk),
        .reset(reset),
        .wr_en(rd_valid), 
        .wr_index(rd),
        .wr_data(is_s_instr ? ld_data : result), // Write result to rd or src2_value for store instructions
        .rd_index1(rs1),
        .rd_en1(rs1_valid),
        .rd_index2(rs2),
        .rd_en2(rs2_valid),
        .rd_data1(src1_value), 
        .rd_data2(src2_value)  
    );

    assign dec_bits = {instr[30], funct3, opcode};
    alu alu_inst (
        .dec_bits(dec_bits),
        .src1_value(src1_value),
        .src2_value(src2_value),
        .imm(imm),
        .result(result)
    );

    assign is_jal  = dec_bits ==? 11'bx_xxx_1101111;
    assign is_jalr = dec_bits ==? 11'bx_000_1100111;
   
    assign is_beq  = dec_bits ==? 11'bx_000_1100011;
    assign is_bne  = dec_bits ==? 11'bx_001_1100011;
    assign is_blt  = dec_bits ==? 11'bx_100_1100011;
    assign is_bge  = dec_bits ==? 11'bx_101_1100011;
    assign is_bltu = dec_bits ==? 11'bx_110_1100011;
    assign is_bgeu = dec_bits ==? 11'bx_111_1100011;

    assign is_load = dec_bits ==? 11'bx_xxx_0000011;
    assign is_s_instr = dec_bits ==? 11'bx_xxx_0100011;

    assign taken_br = 
            is_beq ? src1_value == src2_value :
            is_bne ? src1_value != src2_value :
            is_blt ? (src1_value < src2_value) ^ (src1_value[31] != src2_value[31]) :
            is_bge ? (src1_value >= src2_value) ^ (src1_value[31] != src2_value[31]):
            is_bltu ? src1_value < src2_value:
            is_bgeu ? src1_value >= src2_value:
            is_jal ? 1'b1 :
            1'b0;


    data_memory #(.WIDTH(32), .DEPTH(32)) data_mem_inst (
        .clk(clk),
        .reset(reset),
        .wr_en(is_s_instr), 
        .addr(result[6:2]), // Use the result from ALU as the address for store
        .wr_data(src2_value), // Store the value from rs2
        .rd_en(is_load), 
        .rd_data(ld_data) // Load data into ld_data
    );
   endmodule