module IF_ID_reg (
  input clk,
	input rst,
	input freeze,
	input flush,
  input [31:0] PC_in,
	input [31:0] instruction_in,
	input mem_freeze,
	
  output reg [31:0] PC,
	output reg [31:0] instruction
);
  always @(posedge clk, posedge rst) begin
		if(rst)
			PC <= 32'd0;
		else if(mem_freeze)
			PC <= PC;
    else if(flush)
    	PC <= 32'd0;
		else if(~freeze)
			PC <= PC_in;
	end
  always @(posedge clk, posedge rst) begin
		if (rst)
			instruction <= 32'hE0000000;
		else if (mem_freeze)
			instruction <= instruction;
    else if(flush)
    	instruction <= 32'hE0000000;
		else if(~freeze)
			instruction <= instruction_in;
	end
endmodule