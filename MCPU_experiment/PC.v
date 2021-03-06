//Program Counter (state element)
module PC(
  input         clk,
  input  [31:0] new_PC,
  input         PC_enable,
  input         rst_n,//
  output [31:0] PC_Addr
  );
	reg [31:0] PC;
	
	always@(posedge clk or posedge rst_n)
	begin
	  if (rst_n)
	    begin
	      PC = 32'h0000_3000;
	    end
	  else
	    if (PC_enable)
	    begin
	      PC = new_PC;
	      //$display("PC = %x", PC);
	    end  
	end
	assign PC_Addr = PC;
endmodule
	
	
