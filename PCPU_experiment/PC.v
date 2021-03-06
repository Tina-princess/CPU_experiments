//Program Counter (state element)
module PC(
  input         clk,
  input  [31:0] new_PC,
  input         PC_IFWrite,//1:allow to write, 0:forbit to write
  input         rst,
  output [31:0] PC_Addr
  );
	reg [31:0] PC;
	
	always@(posedge clk or posedge rst)
	begin
	  if (rst)
	    begin
	      PC = 32'h0000_3000;
	    end
	  else
	    if (PC_IFWrite)
	    begin
	      PC = new_PC;
	      //$display("PC = %x", PC);
	    end  
	end
	assign PC_Addr = PC;
endmodule
	
	
