module alu (
    input wire [10:0] dec_bits,
    input wire [31:0] pc,            
    input wire [31:0] src1_value, 
    input wire [31:0] src2_value,
    input wire [31:0] imm, 
    output wire [31:0] result
);

    wire is_lui, is_auipc, is_jal, is_jalr;
    wire is_load, is_s_instr;       
    wire is_addi, is_slti, is_sltiu, is_xori, is_ori, is_andi, is_slli, is_srli, is_srai;
    wire is_add, is_sub, is_sll, is_slt, is_sltu, is_xor, is_srl, is_sra, is_or, is_and;
    wire [31:0] sltu_rslt, sltiu_rslt;
    wire [63:0] sext_src1, sra_rslt, srai_rslt;

    // Decoding logic using wildcard matches
    assign is_lui     = dec_bits ==? 11'bx_xxx_0110111;
    assign is_auipc   = dec_bits ==? 11'bx_xxx_0010111;
    assign is_jal     = dec_bits ==? 11'bx_xxx_1101111;
    assign is_jalr    = dec_bits ==? 11'bx_000_1100111;
  
    assign is_load    = dec_bits ==? 11'bx_xxx_0000011;
    assign is_s_instr = dec_bits ==? 11'bx_xxx_0100011;
   
    assign is_addi    = dec_bits ==? 11'bx_000_0010011;
    assign is_slti    = dec_bits ==? 11'bx_010_0010011;
    assign is_sltiu   = dec_bits ==? 11'bx_011_0010011;
    assign is_xori    = dec_bits ==? 11'bx_100_0010011;
    assign is_ori     = dec_bits ==? 11'bx_110_0010011;
    assign is_andi    = dec_bits ==? 11'bx_111_0010011;
    assign is_slli    = dec_bits ==? 11'b0_001_0010011;
    assign is_srli    = dec_bits ==? 11'b0_101_0010011;
    assign is_srai    = dec_bits ==? 11'b1_101_0010011;
   
    assign is_add     = dec_bits ==? 11'b0_000_0110011;
    assign is_sub     = dec_bits ==? 11'b1_000_0110011;
    assign is_sll     = dec_bits ==? 11'b0_001_0110011;
    assign is_slt     = dec_bits ==? 11'b0_010_0110011;
    assign is_sltu    = dec_bits ==? 11'bx_011_0110011;
    assign is_xor     = dec_bits ==? 11'bx_100_0110011;
    assign is_srl     = dec_bits ==? 11'b0_101_0110011;
    assign is_sra     = dec_bits ==? 11'b1_101_0110011;
    assign is_or      = dec_bits ==? 11'b0_110_0110011;
    assign is_and     = dec_bits ==? 11'b0_111_0110011;

    // Math operations
    assign sltu_rslt  = {31'b0, src1_value < src2_value};
    assign sltiu_rslt = {31'b0, src1_value < imm};
   
    // Arithmetic Shift Right Extensions
    assign sext_src1  = {{32{src1_value[31]}}, src1_value};
    assign sra_rslt   = sext_src1 >> src2_value[4:0];
    assign srai_rslt  = sext_src1 >> imm[4:0];
   
    // Muxing result output
    assign result = 
             is_andi   ? src1_value & imm :
             is_ori    ? src1_value | imm :
             is_xori   ? src1_value ^ imm :
             is_addi   ? src1_value + imm :
             is_slli   ? src1_value << imm[4:0] : 
             is_srli   ? src1_value >> imm[4:0] : 
             
             is_and    ? src1_value & src2_value :
             is_or     ? src1_value | src2_value :
             is_xor    ? src1_value ^ src2_value :
             is_add    ? src1_value + src2_value :
             is_sub    ? src1_value - src2_value :
             is_sll    ? src1_value << src2_value[4:0] :
             is_srl    ? src1_value >> src2_value[4:0] :
             is_sltu   ? sltu_rslt :
             is_sltiu  ? sltiu_rslt :
             is_lui    ? {imm[31:12], 12'b0} :
             is_auipc  ? pc + imm :
             is_jal    ? pc + 32'd4 :
             is_jalr   ? pc + 32'd4 :
             is_slt    ? ((src1_value[31] == src2_value[31]) ? sltu_rslt : {31'b0, src1_value[31]}) :
             is_slti   ? ((src1_value[31] == imm[31]) ? sltiu_rslt : {31'b0, src1_value[31]}) :
             is_sra    ? sra_rslt[31:0] :
             is_srai   ? srai_rslt[31:0] :
             is_s_instr? src1_value + imm :
             is_load   ? src1_value + imm :
             32'b0;
endmodule
