module MIPS_tb(
  );
  `timescale 1ns/1ps
  reg clk, rst_n;
  wire [31:0] PC_Addr, Instr, wa_i;
  wire [63:0] ALU_result;
  reg  [31:0] i;
  MIPS mips(clk, rst_n, PC_Addr, Instr, ALU_result, wa_i);
  initial
    begin
      clk = 0;
      rst_n = 1;
      i = 0;
      #5 rst_n = 0;
      #1 rst_n = 1;
    end
    
  always
    #10 clk <= !clk;
  always@(posedge clk or negedge rst_n)
  begin
    if (PC_Addr >= 32'h0000_3044)
      $stop;
    else
      begin
        $display("------testcase%d------", i);
        i <= i+1;
        $display("PC = 0x%x", PC_Addr);
        $display("Instr = 0x%x", Instr);
        $display("ALU_result = 0x%x", ALU_result);
        $display("Regfile[%d] = 0x%x\t", wa_i, mips.my_RF.Regfile[wa_i]);
        //$display("DMem[%d] = 0x%x", wdAddr, DataIn_i);
      end
  end    
endmodule