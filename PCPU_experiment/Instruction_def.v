`define ALUOP_NOP   5'd0  //No Operation

`define ALUOP_ADD   5'd1
`define ALUOP_SUB   5'd2
`define ALUOP_SLT   5'd3  //Set on Less Than
`define ALUOP_SLTU  5'd4  //Set on Less Than Unsigned

`define ALUOP_DIV   5'd5  //
`define ALUOP_DIVU  5'd6  //
`define ALUOP_MULT  5'd7  //
`define ALUOP_MULTU 5'd8  //

`define ALUOP_AND   5'd9
`define ALUOP_NOR   5'd10
`define ALUOP_OR    5'd11
`define ALUOP_XOR   5'd12

`define ALUOP_SLL   5'd13  //Shift Word Left Logical
`define ALUOP_SRL   5'd14  //Shift Word Right Logical
`define ALUOP_SRA   5'd15  //Shift Word Right Arithmetic

`define R_type      6'h0
`define J           6'h2
`define JAL         6'h3
`define LB          6'h20
`define LBU         6'h24
`define LH          6'h21
`define LHU         6'h25
`define LW          6'h23
`define SB          6'h28
`define SH          6'h29
`define SW          6'h2b
`define ADDI        6'h8
`define ADDIU       6'h9
`define ANDI        6'hc
`define ORI         6'hd
`define XORI        6'he
`define LUI         6'hf
`define SLTI        6'ha
`define SLTIU       6'hb
`define BEQ         6'h4
`define BNE         6'h5
`define BLEZ        6'h6
`define BGTZ        6'h7
`define BLTZ_BGEZ   6'h1
