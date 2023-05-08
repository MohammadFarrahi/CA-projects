module WB_stage (
	input clk,
	input rst,

	input wb_en_input,
	input mem_r_en_input,
	input [3:0] dest_input,
	input [31:0] alu_res_input,
	input [31:0] data_mem_i,

	output wb_en_output,
	output [3:0] wb_dest_o,
	output [31:0] wb_val_o
);
  // mux
  assign wb_val_o = mem_r_en_input ? data_mem_i : alu_res_input;

	assign wb_dest_o = dest_input;
	assign wb_en_output = wb_en_input;

endmodule