module alu ();


    wire [10:0] dec_bits;
    assign dec_bits[10:0] = {instr[30], funct3, opcode};
   
    is_lui  = dec_bits ==? 11'bx_xxx_0110111;
    is_auipc = dec_bits ==? 11'bx_xxx_0010111;
    is_jal  = dec_bits ==? 11'bx_xxx_1101111;
    is_jalr = dec_bits ==? 11'bx_000_1100111;
   
    is_beq  = dec_bits ==? 11'bx_000_1100011;
    is_bne  = dec_bits ==? 11'bx_001_1100011;
    is_blt  = dec_bits ==? 11'bx_100_1100011;
    is_bge  = dec_bits ==? 11'bx_101_1100011;
    is_bltu = dec_bits ==? 11'bx_110_1100011;
    is_bgeu = dec_bits ==? 11'bx_111_1100011;
   
    //$is_lb   = $dec_bits ==? 11'bx_000_0000011;
    //$is_lh   = $dec_bits ==? 11'bx_001_0000011;
    //$is_lw   = $dec_bits ==? 11'bx_010_0000011;
    //$is_lbu  = $dec_bits ==? 11'bx_100_0000011;
    //$is_lhu  = $dec_bits ==? 11'bx_101_0000011;
    is_load = dec_bits ==? 11'bx_xxx_0000011;
    is_s_instr = dec_bits ==? 11'bx_xxx_0100011;
    //$is_sb   = $dec_bits ==? 11'bx_000_0100011;
    //$is_sh   = $dec_bits ==? 11'bx_001_0100011;
    //$is_sw   = $dec_bits ==? 11'bx_010_0100011;
   
    is_addi   = dec_bits ==? 11'bx_000_0010011;
    is_slti   = dec_bits ==? 11'bx_010_0010011;
    is_sltiu  = dec_bits ==? 11'bx_011_0010011;
    is_xori   = dec_bits ==? 11'bx_100_0010011;
    is_ori    = dec_bits ==? 11'bx_110_0010011;
    is_andi   = dec_bits ==? 11'bx_111_0010011;
    is_slli   = dec_bits ==? 11'b0_001_0010011;
    is_srli   = dec_bits ==? 11'b0_101_0010011;
    is_srai   = dec_bits ==? 11'b1_101_0010011;
   
    is_add  = dec_bits ==? 11'b0_000_0110011;
    is_sub  = dec_bits ==? 11'b1_000_0110011;
    is_sll  = dec_bits ==? 11'b0_001_0110011;
    is_slt  = dec_bits ==? 11'b0_010_0110011;
    is_sltu = dec_bits ==? 11'bx_011_0110011;
    is_xor  = dec_bits ==? 11'bx_100_0110011;
    is_srl  = dec_bits ==? 11'b0_101_0110011;
    is_sra  = dec_bits ==? 11'b1_101_0110011;
    is_or   = dec_bits ==? 11'b0_110_0110011;
    is_and  = dec_bits ==? 11'b0_111_0110011;