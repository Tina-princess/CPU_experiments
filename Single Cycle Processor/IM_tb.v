module IM_tb(
  );
  `timescale 1ns/1ps
  reg clk;
  reg [31:0] ImAddr_i;
  wire [31:0] Instr_o;
  initial
  begin
    ImAddr_i = 32'h0000_3000;
    clk = 0;
  end
  
  always
    #10 clk <= ~clk;
  
  IM im(
    .ImAddr_i(ImAddr_i),
    .Instr_o(Instr_o)
    );
  always@(posedge clk)
  begin
    if (ImAddr_i < 32'h0000_3040)
      begin
        $display("%x", im.IMem[ImAddr_i/4]);
        $display("%x", Instr_o);
        ImAddr_i = ImAddr_i +  4;
      end
    else
      $stop;
  end
endmodule