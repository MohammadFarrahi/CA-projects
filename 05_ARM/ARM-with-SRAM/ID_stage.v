module ID_stage (
  input clk, rst,
  input [31:0] pc_in,

  input [31:0] instruction,

  input [31:0] result_wb,
  input wb_en_in,
  input [3:0] dest_wb,

  input hazard,

  input [3:0] sr,

	output wb_en_out,
	output mem_write_en_out,
	output mem_read_en_out,
	output s_out,
	output b_out,
	output [3:0] exe_cmd_out,
	output [31:0] val_rn_out, val_rm_out,
	output imm_out,
	output [23:0] signed_imm_24_out,
	output [11:0] shift_operand_out,
  output [3:0] dst_out,

  output [3:0]	src1, src2,
	output two_src,

  output c_out,
  output [31:0] pc_out
);

	wire sel_mux;
	wire wb_en_temp;
	wire cond_check;
	wire s;
	wire b;
	wire mem_write_en;
	wire mem_read_en;
	wire[3:0] cmd_exe;
	wire[3:0] src2_regfile_addr;
	wire[31:0] val_rn;
	wire[31:0] val_rm;
	
	assign src2_regfile_addr = (mem_write_en == 1'b0) ? instruction[3:0] : instruction[15:12];
	assign two_src = (mem_write_en | (~instruction[25]));
	
  RegisterFile register_file (
		.reg1(val_rn), 
		.reg2(val_rm),
		.src1(instruction[19:16]), 
		.src2(src2_regfile_addr),
		.result_wb(result_wb), 
		.dest_wb(dest_wb),
		.write_back_en(wb_en_in), 
		.clk(clk), 
		.rst(rst) 
	);
	ConditionCheck condition_check (
		.cond_check(cond_check),
		.sr(sr),
		.condition(instruction[31:28]) 
	);
	ControlUnit contorl_unit (
		.sel_mux(sel_mux),
		.mode(instruction[27:26]),
		.opcode(instruction[24:21]),
		.s_in(instruction[20]),
		.cmd_exe(cmd_exe),
		.memory_r_en(mem_read_en),
		.memory_w_en(mem_write_en),
		.wb_en(wb_en_temp),
		.b_out(b),
		.s_out(s)
	);

	assign sel_mux = cond_check | hazard;
	assign imm_out = instruction[25];
	assign  c_out = sr[1]; 
	assign src1 = instruction[19:16];
	assign src2 = src2_regfile_addr;
	assign pc_out = pc_in;
	assign val_rn_out = val_rn ;
	assign val_rm_out = val_rm ;
	assign signed_imm_24_out = instruction[23:0];
	assign shift_operand_out = instruction[11:0];
	assign exe_cmd_out = cmd_exe;
	assign dst_out = instruction[15:12]; 
	assign wb_en_out = wb_en_temp;
	assign mem_write_en_out = mem_write_en;
	assign mem_read_en_out = mem_read_en;
	assign s_out = s;
	assign b_out = b;

endmodule