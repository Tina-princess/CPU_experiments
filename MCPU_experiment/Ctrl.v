//state element
module Ctrl(
  input [5:0] opcode_i,//Instr[31-26]
  input [4:0] rt_i,    //Instr[20-16], to differentiate bltz and bgez
  input [5:0] funct_i, //Instr[5-0]
  input clk,
  input rst,
  
  output       PCWrite_o,
  output       PCWriteCond_o,
  output       IorD_o,
  output       MemWrite_o,
  output [2:0] MemtoReg_o,
  output       IRWrite_o,
  output [1:0] RegDst_o,
  output       RegWrite_o,
  output [1:0] ALUSrcA_o,
  output [2:0] ALUSrcB_o,
  output [2:0] ALUOp_o,
  output [1:0] PCSource_o,
  output [1:0] EXTOp_o,
  output [2:0] Branch_o,
  output [2:0] BEOp_o
  );
  reg       PCWrite, IorD, MemWrite, IRWrite, RegWrite, PCWriteCond;
  reg [1:0] RegDst, ALUSrcA, PCSource, EXTOp;
  reg [2:0] MemtoReg, ALUOp, Branch, BEOp, ALUSrcB;
  
  parameter [7:0] sif = 9'd0, sid = 9'd1, 
    exe1 = 9'd2,//add,addu,sub,subu,sllv,srlv,srav,and,or,xor,nor,slt,sltu
    exe2 = 9'd3,//sra,srl,sll
    exe3 = 9'd4,//j
    exe4 = 9'd5,//jal
    exe5 = 9'd6,//jalr
    exe6 = 9'd7,//jr
    exe7 = 9'd8,//beq
    exe8 = 9'd9,//bne
    exe9 = 9'd10,//bgtz
    exe10 = 9'd11,//bltz
    exe11 = 9'd12,//blez
    exe12 = 9'd13,//bgez
    exe13 = 9'd14,//lb,lh,lw,sb,sh,sw,addi
    exe14 = 9'd15,//lbu,lhu,addiu
    exe15 = 9'd16,//andi
    exe16 = 9'd17,//ori
    exe17 = 9'd18,//xori
    exe18 = 9'd19,//lui
    exe19 = 9'd20,//slti
    exe20 = 9'd21,//sltiu
    mem1 = 9'd22,//sw
    mem2 = 9'd23,//sh
    mem3 = 9'd24,//sb
    mem4 = 9'd25,//lw
    mem5 = 9'd26,//lhu
    mem6 = 9'd27,//lh
    mem7 = 9'd28,//lbu
    mem8 = 9'd29,//lb
    wb1 = 9'd30,//add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,and,or,xor,nor,slt,sltu
    wb2 = 9'd31,//lb,lbu,lh,lhu,lw
    wb3 = 9'd32;//andi,addiu,addi,ori,xori,slti,sltiu
  reg [7:0] state, next_state;
  always@(posedge clk or posedge rst) begin
    if (rst) begin
      state <= sif;
    end else begin
      state <= next_state;
    end
  end
  
  always@(*) begin
    case(state)
      sif: next_state = sid;
      sid: begin
        case (opcode_i)
          6'h0: begin
            case(funct_i)
              6'b001001: next_state = exe5;//jalr
              6'b001000: next_state = exe6;//jr
              6'b000000: next_state = exe2;//sll
              6'b000010: next_state = exe2;//srl
              6'b000011: next_state = exe2;//sra
              default : next_state = exe1;//add,addu,sub,subu,sllv,srlv,srav,and,or,xor,nor,slt,sltu
            endcase
            end
          6'h2: next_state = exe3;//j
          6'h3: next_state = exe4;//jal
          6'h4: next_state = exe7;//beq
          6'h5: next_state = exe8;//bne
          6'h7: next_state = exe9;//bgtz
          6'h6: next_state = exe11;//blez
          6'h1: begin
            if (rt_i == 5'b0) next_state = exe10;//bltz
            else next_state = exe12;//bgez
            end
          6'hc: next_state = exe15;//andi
          6'hd: next_state = exe16;//ori
          6'he: next_state = exe17;//xori
          6'hf: next_state = exe18;//lui
          6'ha: next_state = exe19;//slti
          6'hb: next_state = exe20;//sltiu
          6'h24: next_state = exe14;//lbu
          6'h25: next_state = exe14;//lhu
          6'h9: next_state = exe14;//addiu
          default: next_state = exe13;//lb,lh.lw.sb,sh,sw,addi
          //6'h20: next_state = exe13;//lb
          //6'h21: next_state = exe13;//lh
          //6'h23: next_state = exe13;//lw
          //6'h28: next_state = exe13;//sb
          //6'h29: next_state = exe13;//sh
          //6'h2b: next_state = exe13;//sw
          //6'h8: next_state = exe13;//addi
        endcase
      end
      exe1: next_state = wb1;
      exe2: next_state = wb1;
      exe3: next_state = sif;
      exe4: next_state = sif;
      exe5: next_state = sif;
      exe6: next_state = sif;
      exe7: next_state = sif;
      exe8: next_state = sif;
      exe9: next_state = sif;
      exe10: next_state = sif;
      exe11: next_state = sif;
      exe12: next_state = sif;
      exe13: begin
        case (opcode_i)
          6'h20: next_state = mem8;//lb
          6'h21: next_state = mem6;//lh
          6'h23: next_state = mem4;//lw
          6'h28: next_state = mem3;//sb
          6'h29: next_state = mem2;//sh
          6'h2b: next_state = mem1;//sw
          6'h8: next_state = wb3;//addi
          default: next_state = sif;
        endcase
        end
      exe14: begin
        case (opcode_i)
          6'h24: next_state = mem7;//lbu
          6'h25: next_state = mem5;//lhu
          6'h9: next_state = wb3;//addiu
          default: next_state = sif;
        endcase
        end
      exe15: next_state = wb3;
      exe16: next_state = wb3;
      exe17: next_state = wb3;
      exe18: next_state = sif;
      exe19: next_state = wb3;
      exe20: next_state = wb3;
      mem1: next_state = sif;
      mem2: next_state = sif;
      mem3: next_state = sif;
      mem4: next_state = wb2;
      mem5: next_state = wb2;
      mem6: next_state = wb2;
      mem7: next_state = wb2;
      mem8: next_state = wb2;
      wb1: next_state = sif;
      wb2: next_state = sif;
      wb3: next_state = sif;
      default: next_state = sif;
    endcase
 
    case (state)
      sif: begin
        IorD <= 1'b0; MemWrite <= 1'b0; IRWrite <= 1'b1; PCWrite <= 1'b1;
        RegWrite <= 1'b0; ALUSrcA <= 2'b00; ALUSrcB <= 3'b001; ALUOp <= 3'b000; PCSource <= 2'b00; BEOp <= 3'b000;
        end
      sid: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; EXTOp <= 2'b01;
        ALUSrcA <= 2'b00; ALUSrcB <= 3'b011; ALUOp <= 3'b000; PCWriteCond <= 1'b0;
        end
      exe1: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0;
        ALUSrcA <= 2'b01; ALUSrcB <= 3'b000; ALUOp <= 3'b010; PCWriteCond <= 1'b0;
        end
      exe2: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0;
        ALUSrcA <= 2'b10; ALUSrcB <= 3'b000; ALUOp <= 3'b010; PCWriteCond <= 1'b0;
        end
      exe3: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b1; RegWrite <= 1'b0; PCSource <= 2'b10;
        end
      exe4: begin
        MemWrite <= 1'b0; MemtoReg <= 3'b010; IRWrite <= 1'b0; RegDst <= 2'b10; PCWrite <= 1'b1; RegWrite <= 1'b1; PCSource <= 2'b10;
        end
      exe5: begin
        MemWrite <= 1'b0; MemtoReg <= 3'b010; IRWrite <= 1'b0; RegDst <= 2'b01; PCWrite <= 1'b1; RegWrite <= 1'b1; PCSource <= 2'b11;
        end
      exe6: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b1; RegWrite <= 1'b0; PCSource <= 2'b11;
        end
      exe7: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; ALUSrcA <= 2'b01; ALUSrcB <= 3'b000;  
        ALUOp <= 3'b101; Branch <= 3'b000; PCWriteCond <= 1'b1; PCSource <= 2'b01;
        end
      exe8: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; ALUSrcA <= 2'b01; ALUSrcB <= 3'b000;  
        ALUOp <= 3'b101; Branch <= 3'b001; PCWriteCond <= 1'b1; PCSource <= 2'b01;
        end
      exe9: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; ALUSrcA <= 2'b01; ALUSrcB <= 3'b000;  
        ALUOp <= 3'b101; Branch <= 3'b010; PCWriteCond <= 1'b1; PCSource <= 2'b01;
        end
      exe10: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; ALUSrcA <= 2'b01; ALUSrcB <= 3'b000;  
        ALUOp <= 3'b101; Branch <= 3'b011; PCWriteCond <= 1'b1; PCSource <= 2'b01; 
        end
      exe11: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; ALUSrcA <= 2'b01; ALUSrcB <= 3'b000;  
        ALUOp <= 3'b101; Branch <= 3'b100; PCWriteCond <= 1'b1; PCSource <= 2'b01; 
        end
      exe12: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; ALUSrcA <= 2'b01; ALUSrcB <= 3'b000;  
        ALUOp <= 3'b101; Branch <= 3'b101; PCWriteCond <= 1'b1; PCSource <= 2'b01; 
        end
      exe13: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; EXTOp <= 2'b01; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010;  
        ALUOp <= 3'b000; PCWriteCond <= 1'b0;
        end
      exe14: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; EXTOp <= 2'b00; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010;  
        ALUOp <= 3'b000; PCWriteCond <= 1'b0;  
        end
      exe15: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; EXTOp <= 2'b00; ALUSrcA <=  2'b01; ALUSrcB <= 3'b010; 
        ALUOp <= 3'b001; PCWriteCond <= 1'b0;  
        end
      exe16: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; EXTOp <= 2'b00; ALUSrcA <=  2'b01; ALUSrcB <= 3'b010;   
        ALUOp <= 3'b011; PCWriteCond <= 1'b0;  
        end
      exe17: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; EXTOp <= 2'b00; ALUSrcA <=  2'b01; ALUSrcB <= 3'b010;   
        ALUOp <= 3'b100; PCWriteCond <= 1'b0;  
        end
      exe18: begin
        MemWrite <= 1'b0; MemtoReg <= 3'b100; IRWrite <= 1'b0; RegDst <= 2'b00; PCWrite <= 1'b0; RegWrite <= 1'b1; EXTOp <= 2'b10; PCWriteCond <= 1'b0;  
        end
      exe19: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; EXTOp <= 2'b01; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010;
        ALUOp <= 3'b110; PCWriteCond <= 1'b0;  
        end
      exe20: begin
        MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; EXTOp <= 2'b00; ALUSrcA <= 2'b01; ALUSrcB <= 3'b010;
        ALUOp <= 3'b111; PCWriteCond <= 1'b0;  
        end
      mem1: begin
        IorD <= 1'b1; MemWrite <= 1'b1; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; PCWriteCond <= 1'b0; BEOp <= 3'b000;
        end
      mem2: begin
        IorD <= 1'b1; MemWrite <= 1'b1; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; PCWriteCond <= 1'b0; BEOp <= 3'b001;
        end
      mem3: begin
        IorD <= 1'b1; MemWrite <= 1'b1; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; PCWriteCond <= 1'b0; BEOp <= 3'b010;
        end
      mem4: begin
        IorD <= 1'b1; MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; PCWriteCond <= 1'b0; BEOp <= 3'b011;
        end
      mem5: begin
        IorD <= 1'b1; MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; PCWriteCond <= 1'b0; BEOp <= 3'b100;
        end
      mem6: begin
        IorD <= 1'b1; MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; PCWriteCond <= 1'b0; BEOp <= 3'b101;
        end
      mem7: begin
        IorD <= 1'b1; MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; PCWriteCond <= 1'b0; BEOp <= 3'b110;
        end
      mem8: begin
        IorD <= 1'b1; MemWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; RegWrite <= 1'b0; PCWriteCond <= 1'b0; BEOp <= 3'b111;
        end
      wb1: begin
        MemWrite <= 1'b0; MemtoReg <= 3'b000; IRWrite <= 1'b0; RegDst <= 2'b01; PCWrite <= 1'b0; RegWrite <= 1'b1; PCWriteCond <= 1'b0;
        end
      wb2: begin
        MemWrite <= 1'b0; MemtoReg <= 3'b001; IRWrite <= 1'b0; RegDst <= 2'b00; PCWrite <= 1'b0; RegWrite <= 1'b1; PCWriteCond <= 1'b0;
        end
      wb3: begin
        MemWrite <= 1'b0; MemtoReg <= 3'b000; IRWrite <= 1'b0; RegDst <= 2'b00; PCWrite <= 1'b0; RegWrite <= 1'b1; PCWriteCond <= 1'b0;
        end
      default: begin
        RegWrite <= 1'b0; IRWrite <= 1'b0; PCWrite <= 1'b0; PCWriteCond <= 1'b0; MemWrite <= 1'b0;
        end
    endcase
  end
  
  assign PCWrite_o = PCWrite;
  assign PCWriteCond_o = PCWriteCond;
  assign IorD_o = IorD;
  assign MemWrite_o = MemWrite;
  assign MemtoReg_o = MemtoReg;
  assign IRWrite_o = IRWrite;
  assign RegDst_o = RegDst;
  assign RegWrite_o = RegWrite;
  assign ALUSrcA_o = ALUSrcA;
  assign ALUSrcB_o = ALUSrcB;
  assign ALUOp_o = ALUOp;
  assign PCSource_o = PCSource;
  assign EXTOp_o = EXTOp;
  assign Branch_o = Branch;
  assign BEOp_o = BEOp;
endmodule
  
  
