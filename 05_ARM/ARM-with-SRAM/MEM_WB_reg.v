module MEM_WB_reg(
  input clk,
	input rst,
	input [31:0] alu_res_input,
	input [31:0] data_mem_input,
	input [3:0] dst_input,
	input mem_read_en_input,
	input wb_en_input,
	input freeze_in,

	output reg wb_en_output,
	output reg mem_read_en_output,
	output reg [31:0] alu_res_output,
	output reg [31:0] data_mem_output,
	output reg [3:0] dst_output
);
	always @ (posedge clk, posedge rst)begin
		if (rst)
			{wb_en_output,mem_read_en_output,alu_res_output,data_mem_output,dst_output} = 0;
		else if(~freeze_in)
			{wb_en_output, mem_read_en_output, alu_res_output, data_mem_output, dst_output} = 
        {wb_en_input, mem_read_en_input, alu_res_input, data_mem_input, dst_input};

	end
endmodule