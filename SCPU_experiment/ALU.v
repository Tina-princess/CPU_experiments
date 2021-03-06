`include "Instruction_def.v"
//Arithmetic Logic Unit
module ALU(
  input   [4:0] aluop_i,
  input   [31:0]src0_i,//rs or shamt
  input   [31:0]src1_i,//rd or transformed imm
  
  output  [63:0]aluout_o,
  output        zero_o
  );
reg [63:0]aluout;
reg       zero;
reg [31:0]logic_rlt;
reg [31:0]shift_rlt;
reg [31:0]arith_rlt;
wire [63:0]mul_rlt;
wire [63:0]div_rlt;

//logic
always@(*)
begin
  case (aluop_i)
    `ALUOP_AND:
        logic_rlt = src0_i & src1_i;
	  `ALUOP_OR:
		    logic_rlt = src0_i | src1_i;
	  `ALUOP_NOR:
		    logic_rlt = ~(src0_i | src1_i);
	  `ALUOP_LUI:	
		    logic_rlt = {src1_i[15:0], 16'd0};
	  default:
		    logic_rlt = 32'b0;
  endcase
end  

//shift
always@(*)
begin
  case (aluop_i)
    `ALUOP_SLL:
        shift_rlt = src1_i<<src0_i[4:0];
	  `ALUOP_SRL:
		    shift_rlt = src1_i>>src0_i[4:0];
	  `ALUOP_SRA:
		    shift_rlt = src1_i>>src0_i[4:0] | ({32{src1_i[31]}}<<(6'd32-{1'b0,src0_i[4:0]}));
	  default:
		    shift_rlt = 32'b0;
  endcase
end

//arith
reg [31:0]tmp_difference;
always@(*)
begin
  tmp_difference=src0_i-src1_i;
  case (aluop_i)
    `ALUOP_ADD:
        arith_rlt = src0_i+src1_i;
    `ALUOP_SUB:
        arith_rlt = tmp_difference;
    `ALUOP_SLT:
        arith_rlt = (
                        (src0_i[31] && !src1_i[31])
                    ||  (!src0_i[31] && !src1_i[31] && tmp_difference[31])
                    ||  (src0_i[31] && src1_i[31] && tmp_difference[31])
                    )? 32'd1:32'd0;
    `ALUOP_SLTU:
        arith_rlt = {31'd0,src0_i<src1_i};
    default:
        arith_rlt = 32'd0;
  endcase
end

//mul

wire  [31:0]tmp_src0=(aluop_i==`ALUOP_MULT && src0_i[31])? (-src0_i) : src0_i;
wire  [31:0]tmp_src1=(aluop_i==`ALUOP_MULT && src1_i[31])? (-src1_i) : src1_i;
wire  [63:0]tmp_mul_rlt=tmp_src0*tmp_src1;
assign  mul_rlt=(aluop_i==`ALUOP_MULT && (src0_i[31]^src1_i[31]))?-tmp_mul_rlt:tmp_mul_rlt;

//div
wire  [31:0]tmp_op0=(aluop_i==`ALUOP_DIV && src0_i[31])? (-src0_i) : src0_i;
wire  [31:0]tmp_op1=(aluop_i==`ALUOP_DIV && src1_i[31])? (-src1_i) : src1_i;

wire  [32:0]div_temp1 = {32'd0,tmp_op0[31]}-{1'b0,tmp_op1};
wire  [64:0]dividend1 = (div_temp1[32] == 1'b1)? {31'd0,tmp_op0 , 2'd0} :  {div_temp1[31:0] , tmp_op0[30:0] , 2'd1};
wire 	[32:0]div_temp2 = {1'b0,dividend1[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend2 = (div_temp2[32] == 1'b1)?  {dividend1[63:0] , 1'b0}  : {div_temp2[31:0] , dividend1[31:0] , 1'b1};
wire 	[32:0]div_temp3 = {1'b0,dividend2[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend3 = (div_temp3[32] == 1'b1)?  {dividend2[63:0] , 1'b0}  : {div_temp3[31:0] , dividend2[31:0] , 1'b1};
wire 	[32:0]div_temp4 = {1'b0,dividend3[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend4 = (div_temp4[32] == 1'b1)?  {dividend3[63:0] , 1'b0}  : {div_temp4[31:0] , dividend3[31:0] , 1'b1};
wire 	[32:0]div_temp5 = {1'b0,dividend4[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend5 = (div_temp5[32] == 1'b1)?  {dividend4[63:0] , 1'b0}  : {div_temp5[31:0] , dividend4[31:0] , 1'b1};
wire 	[32:0]div_temp6 = {1'b0,dividend5[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend6 = (div_temp6[32] == 1'b1)?  {dividend5[63:0] , 1'b0}  : {div_temp6[31:0] , dividend5[31:0] , 1'b1};
wire 	[32:0]div_temp7 = {1'b0,dividend6[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend7 = (div_temp7[32] == 1'b1)?  {dividend6[63:0] , 1'b0}  : {div_temp7[31:0] , dividend6[31:0] , 1'b1};
wire 	[32:0]div_temp8 = {1'b0,dividend7[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend8 = (div_temp8[32] == 1'b1)?  {dividend7[63:0] , 1'b0}  : {div_temp8[31:0] , dividend7[31:0] , 1'b1};
wire 	[32:0]div_temp9 = {1'b0,dividend8[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend9 = (div_temp9[32] == 1'b1)?  {dividend8[63:0] , 1'b0}  : {div_temp9[31:0] , dividend8[31:0] , 1'b1};
wire 	[32:0]div_temp10 = {1'b0,dividend9[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend10 = (div_temp10[32] == 1'b1)?  {dividend9[63:0] , 1'b0}  : {div_temp10[31:0] , dividend9[31:0] , 1'b1};
wire 	[32:0]div_temp11 = {1'b0,dividend10[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend11 = (div_temp11[32] == 1'b1)?  {dividend10[63:0] , 1'b0}  : {div_temp11[31:0] , dividend10[31:0] , 1'b1};
wire 	[32:0]div_temp12 = {1'b0,dividend11[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend12 = (div_temp12[32] == 1'b1)?  {dividend11[63:0] , 1'b0}  : {div_temp12[31:0] , dividend11[31:0] , 1'b1};
wire 	[32:0]div_temp13 = {1'b0,dividend12[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend13 = (div_temp13[32] == 1'b1)?  {dividend12[63:0] , 1'b0}  : {div_temp13[31:0] , dividend12[31:0] , 1'b1};
wire 	[32:0]div_temp14 = {1'b0,dividend13[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend14 = (div_temp14[32] == 1'b1)?  {dividend13[63:0] , 1'b0}  : {div_temp14[31:0] , dividend13[31:0] , 1'b1};
wire 	[32:0]div_temp15 = {1'b0,dividend14[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend15 = (div_temp15[32] == 1'b1)?  {dividend14[63:0] , 1'b0}  : {div_temp15[31:0] , dividend14[31:0] , 1'b1};
wire 	[32:0]div_temp16 = {1'b0,dividend15[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend16 = (div_temp16[32] == 1'b1)?  {dividend15[63:0] , 1'b0}  : {div_temp16[31:0] , dividend15[31:0] , 1'b1};
wire 	[32:0]div_temp17 = {1'b0,dividend16[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend17 = (div_temp17[32] == 1'b1)?  {dividend16[63:0] , 1'b0}  : {div_temp17[31:0] , dividend16[31:0] , 1'b1};
wire 	[32:0]div_temp18 = {1'b0,dividend17[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend18 = (div_temp18[32] == 1'b1)?  {dividend17[63:0] , 1'b0}  : {div_temp18[31:0] , dividend17[31:0] , 1'b1};
wire 	[32:0]div_temp19 = {1'b0,dividend18[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend19 = (div_temp19[32] == 1'b1)?  {dividend18[63:0] , 1'b0}  : {div_temp19[31:0] , dividend18[31:0] , 1'b1};
wire 	[32:0]div_temp20 = {1'b0,dividend19[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend20 = (div_temp20[32] == 1'b1)?  {dividend19[63:0] , 1'b0}  : {div_temp20[31:0] , dividend19[31:0] , 1'b1};
wire 	[32:0]div_temp21 = {1'b0,dividend20[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend21 = (div_temp21[32] == 1'b1)?  {dividend20[63:0] , 1'b0}  : {div_temp21[31:0] , dividend20[31:0] , 1'b1};
wire 	[32:0]div_temp22 = {1'b0,dividend21[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend22 = (div_temp22[32] == 1'b1)?  {dividend21[63:0] , 1'b0}  : {div_temp22[31:0] , dividend21[31:0] , 1'b1};
wire 	[32:0]div_temp23 = {1'b0,dividend22[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend23 = (div_temp23[32] == 1'b1)?  {dividend22[63:0] , 1'b0}  : {div_temp23[31:0] , dividend22[31:0] , 1'b1};
wire 	[32:0]div_temp24 = {1'b0,dividend23[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend24 = (div_temp24[32] == 1'b1)?  {dividend23[63:0] , 1'b0}  : {div_temp24[31:0] , dividend23[31:0] , 1'b1};
wire 	[32:0]div_temp25 = {1'b0,dividend24[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend25 = (div_temp25[32] == 1'b1)?  {dividend24[63:0] , 1'b0}  : {div_temp25[31:0] , dividend24[31:0] , 1'b1};
wire 	[32:0]div_temp26 = {1'b0,dividend25[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend26 = (div_temp26[32] == 1'b1)?  {dividend25[63:0] , 1'b0}  : {div_temp26[31:0] , dividend25[31:0] , 1'b1};
wire 	[32:0]div_temp27 = {1'b0,dividend26[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend27 = (div_temp27[32] == 1'b1)?  {dividend26[63:0] , 1'b0}  : {div_temp27[31:0] , dividend26[31:0] , 1'b1};
wire 	[32:0]div_temp28 = {1'b0,dividend27[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend28 = (div_temp28[32] == 1'b1)?  {dividend27[63:0] , 1'b0}  : {div_temp28[31:0] , dividend27[31:0] , 1'b1};
wire 	[32:0]div_temp29 = {1'b0,dividend28[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend29 = (div_temp29[32] == 1'b1)?  {dividend28[63:0] , 1'b0}  : {div_temp29[31:0] , dividend28[31:0] , 1'b1};
wire 	[32:0]div_temp30 = {1'b0,dividend29[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend30 = (div_temp30[32] == 1'b1)?  {dividend29[63:0] , 1'b0}  : {div_temp30[31:0] , dividend29[31:0] , 1'b1};
wire 	[32:0]div_temp31 = {1'b0,dividend30[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend31 = (div_temp31[32] == 1'b1)?  {dividend30[63:0] , 1'b0}  : {div_temp31[31:0] , dividend30[31:0] , 1'b1};
wire 	[32:0]div_temp32 = {1'b0,dividend31[63:32]} - {1'b0,tmp_op1};
wire  [64:0]dividend32 = (div_temp32[32] == 1'b1)?  {dividend31[63:0] , 1'b0}  : {div_temp32[31:0] , dividend31[31:0] , 1'b1};

assign div_rlt[63:32]=(aluop_i==`ALUOP_DIV && (src0_i[31]^dividend32[64]))? -dividend32[64:33]  : dividend32[64:33];
assign div_rlt[31:0] =(aluop_i==`ALUOP_DIV && (src0_i[31]^src1_i[31]))? -dividend32[31:0] : dividend32[31:0];

//result sel
always@(*)
begin
  case(aluop_i)
    `ALUOP_NOP:
        aluout = 64'd0;
    `ALUOP_ADD,
    `ALUOP_SUB,
    `ALUOP_SLT,
    `ALUOP_SLTU:
        aluout = {32'd0,arith_rlt};
    `ALUOP_DIV,
    `ALUOP_DIVU:
        aluout = div_rlt;
    `ALUOP_MULT,
    `ALUOP_MULTU:
        aluout = mul_rlt;
    `ALUOP_AND,
    `ALUOP_NOR,
    `ALUOP_OR,
    `ALUOP_LUI:
        aluout = logic_rlt;
    `ALUOP_SLL,
    `ALUOP_SRL,
    `ALUOP_SRA:
        aluout = shift_rlt;
    default:
        aluout = 64'd0;
  endcase
  zero=(aluout_o == 64'd0);
end
assign zero_o = zero;
assign aluout_o = aluout;
endmodule