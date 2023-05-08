module ControlUnit (
	input sel_mux,
	input [1:0] mode,
	input [3:0] opcode,
	input s_in,

	output [3:0] cmd_exe,
	output memory_r_en,
	output memory_w_en,
	output wb_en,
	output b_out,
	output s_out
);
	wire [3:0] exe_cmd_temp ;

	ControlUnitCore Core (
		.mode(mode),
		.opcode(opcode),
		.s_in(s_in),
		.cmd_exe(exe_cmd_temp),
		.mem_r_en(mem_r_en_temp),
		.mem_w_en(mem_w_en_temp),
		.wb_en(wb_en_temp),
		.b_out(b_out_temp),
		.s_out(s_out_temp)
	);

	assign wb_en = sel_mux == 1 ? 0 : wb_en_temp ;
	assign b_out = sel_mux == 1 ? 0 : b_out_temp ;
	assign s_out = sel_mux == 1 ? 0 : s_out_temp ;
	assign cmd_exe = sel_mux == 1 ? 0 : exe_cmd_temp ;
	assign memory_r_en = sel_mux == 1 ? 0 : mem_r_en_temp ;
	assign memory_w_en = sel_mux == 1 ? 0 : mem_w_en_temp ;


endmodule