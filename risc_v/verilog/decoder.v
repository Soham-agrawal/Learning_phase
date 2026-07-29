module decoder (
    input wire [31:0] instr,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [6:0] opcode,
    output reg [2:0] funct3,
    output reg [6:0] funct7
    output reg [31:0] imm,
    output reg funct3_valid,
    output reg funct7_valid,
    output reg rs1_valid,
    output reg rs2_valid,
    output reg rd_valid,
    output reg imm_valid
);
    wire is_r_instr, is_i_instr, is_s_instr, is_b_instr, is_u_instr, is_j_instr, is_r4_instr;

    always @(*) begin
    // Extract instruction type based on opcode
    is_u_instr  = instr[6:2] ==? 5'b0x101;
    is_r_instr  = instr[6:2] ==  5'b01011 ||
                  instr[6:2] ==  5'b01100 ||
                  instr[6:2] ==  5'b01110 ||
                  instr[6:2] ==  5'b10100;
    is_s_instr  = instr[6:2] ==? 5'b0100x;
    is_i_instr  = instr[6:2] ==  5'b00000 ||
                  instr[6:2] ==  5'b00001 ||
                  instr[6:2] ==  5'b00100 ||
                  instr[6:2] ==  5'b00110 ||
                  instr[6:2] ==  5'b11001;
    is_b_instr  = instr[6:2] ==  5'b11000;
    is_j_instr  = instr[6:2] ==  5'b11011;
    is_r4_instr = instr[6:2] ==? 5'b100xx;
   
    //funct3
    funct3[2:0] = instr[14:12];
    funct3_valid = is_r_instr || is_i_instr || is_s_instr || is_b_instr;

    //funct7
    funct7[6:0] = instr[31:25];
    funct7_valid = is_r_instr;

    //rd
    rd[4:0] = instr[11:7];
    rd_valid = (is_r_instr || is_i_instr || is_u_instr || is_j_instr) && (rd !== 4'b0);

    //rs1
    rs1[4:0] = instr[19:15];
    rs1_valid = is_r_instr || is_i_instr || is_s_instr || is_b_instr;

    //rs2
    rs2[4:0] = instr[24:20];
    rs2_valid = is_r_instr || is_s_instr || is_b_instr;

    //opcode
    opcode[6:0] = instr[6:0];
    //$opcode_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr || $is_u_instr || $is_j_instr;
        
    //IMM
    imm[31:0] = is_i_instr ? { {21{instr[31]}}, instr[30:20]} :
                is_s_instr ? { {21{instr[31]}}, instr[30:25], instr[11:7]} :
                is_b_instr ? { {20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0} :
                is_u_instr ? { instr[31:12], {12{1'b0}}} :
                is_j_instr ? { {12{instr[31]}}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0} :
                              32'b0;
    imm_valid = is_i_instr || is_s_instr || is_b_instr || is_u_instr || is_j_instr;     
    end
    endmodule