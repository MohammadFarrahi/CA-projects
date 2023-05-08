module EXE_stage (
	input clk, rst,
  input[3:0] exe_cmd_ID_EXE,
	input mem_read_en_ID_EXE,
	input mem_write_en_ID_EXE,
  input[31:0] pc_ID_EXE,
  input[31:0] val_rn_ID_EXE,
	input[31:0] val_rm_ID_EXE,
  input imm_ID_EXE,
	input[11:0] shift_operand_ID_EXE,
	input[23:0] signed_imm_24_ID_EXE,
  input c_in,

	input wb_en_ID_EXE,
	input b_ID_EXE,
	input s_ID_EXE,
	input[31:0] alu_result_mem,
	input[31:0] data_wb_wb,
	input[1:0] select_src_1,
	input[1:0] select_src_2,
	input[3:0] dst_ID_EXE,
	input forwarding_en,

	output wb_en_EXE_MEM,
	output mem_read_en_EXE_MEM,
	output mem_write_en_EXE_MEM,
	output [31:0] alu_result_EXE_MEM,
	output [31:0] EXE_MEM_val_rm,
	output [31:0] EXE_IF_branch_addr,
	output [3:0] EXE_MEM_dst,
	output[3:0] exe_IF_sr
);

	wire or_out;
	wire signed [31:0] val1, val2;
	wire [31:0] imm_signed_extend;
	reg[31:0] src1_mux_out;
	reg[31:0] src2_mux_out;
	wire [32:0] result_alu;
	wire n, z, c, v;



	assign val1 = src1_mux_out;	
	always @(*) begin // src_1_mux
		if(forwarding_en == 0)
			src1_mux_out = val_rn_ID_EXE;
		else begin
			if (select_src_1 == 0)
				src1_mux_out = val_rn_ID_EXE;
			else if (select_src_1 == 1)
				src1_mux_out = alu_result_mem;
			else if (select_src_1 == 2)
				src1_mux_out = data_wb_wb;
			else
				src1_mux_out = val_rn_ID_EXE;
		end
	end

	always @(*) begin // src_2_mux
		if(forwarding_en == 0)
			src2_mux_out = val_rm_ID_EXE;
		else begin
			if (select_src_2 == 0)
				src2_mux_out = val_rm_ID_EXE;
			else if (select_src_2 == 1)
				src2_mux_out = alu_result_mem;
			else if (select_src_2 == 2)
				src2_mux_out = data_wb_wb;
			else
				src2_mux_out = val_rm_ID_EXE;
		end
	end

  assign imm_signed_extend = {{8{signed_imm_24_ID_EXE[23]}}, signed_imm_24_ID_EXE};
	assign EXE_IF_branch_addr = pc_ID_EXE + imm_signed_extend;
	
  assign or_out = mem_read_en_ID_EXE | mem_write_en_ID_EXE;

	Val2Generator val2_generator (
	  .val_rm(src2_mux_out),
    .shift_operand(shift_operand_ID_EXE),
    .imm(imm_ID_EXE),
    .or_out(or_out),
    .val2(val2)
	);

	ALU alu (
		.exe_cmd(exe_cmd_ID_EXE),
    .n(n), .z(z), .c(c), .v(v),
		.val1(val1),
		.val2(val2),
		.result_alu(result_alu),
		.c_in(c_in)
	);

	StatusRegister status_register (
		.sr(exe_IF_sr),
		.wr_en(s_ID_EXE),
		.n(n), 
		.z(z), 
		.c(c), 
		.v(v), 
		.clk(clk), 
		.rst(rst)
	);

  assign wb_en_EXE_MEM = wb_en_ID_EXE;
	assign mem_read_en_EXE_MEM = mem_read_en_ID_EXE;
	assign mem_write_en_EXE_MEM = mem_write_en_ID_EXE;
	assign alu_result_EXE_MEM = result_alu[31:0];
	assign EXE_MEM_val_rm = val_rm_ID_EXE;
	assign EXE_MEM_dst = dst_ID_EXE;

endmodule