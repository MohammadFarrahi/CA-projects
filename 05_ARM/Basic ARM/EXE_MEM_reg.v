module EXE_MEM_reg (
	input clk, rst,
	input wb_en_EXE_MEM_input,
	input mem_read_en_EXE_MEM_input,
	input mem_write_en_EXE_MEM_input,
	input[31:0] alu_result_EXE_MEM_input,
	input[31:0] val_rm_EXE_MEM_input,
	input[3:0] dst_EXE_MEM_input,

	output reg wb_en_EXE_MEM_output,
	output reg mem_read_en_EXE_MEM_output,
	output reg mem_write_en_EXE_MEM_output,
	output reg [31:0] alu_result_EXE_MEM_output,
	output reg [31:0] val_rm_EXE_MEM_output,
	output reg [3:0] dst_EXE_MEM_ouput
);
	always @(posedge clk, posedge rst) begin
		if (rst == 1) begin
			wb_en_EXE_MEM_output <= 0;
			mem_write_en_EXE_MEM_output <= 0;
			mem_read_en_EXE_MEM_output <= 0;
		end
		else begin
			{wb_en_EXE_MEM_output,mem_read_en_EXE_MEM_output,mem_write_en_EXE_MEM_output,alu_result_EXE_MEM_output,val_rm_EXE_MEM_output,dst_EXE_MEM_ouput} <= {wb_en_EXE_MEM_input,mem_read_en_EXE_MEM_input,mem_write_en_EXE_MEM_input,alu_result_EXE_MEM_input,val_rm_EXE_MEM_input,dst_EXE_MEM_input};
		end
	end
endmodule
