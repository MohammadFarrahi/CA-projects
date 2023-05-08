module ARM #(parameter INSTRUCTION_MEM_FILE = "instruction_mem.txt") (
	// input forwarding_en,
	input clk,
	input rst,
	output[31:0] alu_result_EXE_MEM,

	inout [15:0] SRAM_DQ,
	output [17:0] SRAM_ADDR,
 	output SRAM_UB_N,
 	output SRAM_LB_N,
 	output SRAM_WE_N,
	output SRAM_CE_N,
 	output SRAM_OE_N
);
wire forwarding_en = 1'b1;
wire[31:0] pc_IF_ID;
wire[31:0] instruction_IF_ID;
wire freeze, mem_freeze;

wire final_freeze = freeze | mem_freeze;

wire c_ID_EXE;
wire wb_en_ID_EXE;
wire mem_write_en_ID_EXE;
wire mem_read_en_ID_EXE;
wire s_ID_EXE;
wire b_ID_EXE;
wire imm_ID_EXE;
wire two_src_ID;
wire[3:0] exe_cmd_ID_EXE;
wire[3:0] dst_ID_EXE;
wire[3:0] src2_ID;
wire[11:0] shift_operand_ID_EXE;
wire[23:0] signed_imm_24_ID_EXE;
wire[31:0] pc_ID_EXE;
wire[31:0] val_rn_ID_EXE;
wire[31:0] val_rm_ID_EXE;
wire[1:0] select_src_1;
wire[1:0] select_src_2;
wire[3:0] src_1_ID_forwarding;
wire[3:0] src_2_ID_forwarding;


wire[31:0] EXE_IF_branch_addr;
wire wb_en_EXE_MEM;
wire mem_read_en_EXE_MEM;
wire mem_write_en_EXE_MEM;
wire[3:0] EXE_MEM_dst;
wire[31:0] EXE_MEM_val_rm;

wire wb_en_MEM_WB;
wire mem_read_en_MEM_WB;
wire[3:0] dst_MEM_WB;
wire[31:0] result_MEM_WB;
wire[31:0] data_mem_MEM_WB;


wire wb_en_WB_ID;
wire[3:0] dst_WB_ID;
wire[31:0] result_WB_ID;

wire[3:0] sr_status_ID;

wire[31:0] pc_IF_ID_to_reg;
wire[31:0] instruction_IF_ID_to_reg;


IF_stage IF_stage_instance (
	.clk(clk),
	.rst(rst),
	.freeze(freeze), 
	.branch_taken(b_ID_EXE),
	.branch_addr(EXE_IF_branch_addr),
	.mem_freeze(mem_freeze),

	.PC(pc_IF_ID_to_reg),
	.instruction(instruction_IF_ID_to_reg)
);

IF_ID_reg IF_ID_reg_instance (
	.clk(clk),
	.rst(rst),
	.freeze(freeze),
	.flush(b_ID_EXE),
	.PC_in(pc_IF_ID_to_reg),
	.instruction_in(instruction_IF_ID_to_reg),
	.mem_freeze(mem_freeze),

	.PC(pc_IF_ID),
	.instruction(instruction_IF_ID)
);


wire [31:0] pc_out_to_reg;
wire [31:0] val_rn_out_to_reg;
wire [31:0] val_rm_out_to_reg;

wire[23:0] signed_imm_24_out_to_reg;

wire [11:0] shift_operand_out_to_reg;

wire [3:0] exe_cmd_out_to_reg;
wire [3:0] dst_out_to_reg;
wire [3:0] src_1_to_reg;
wire [3:0] src_2_to_reg;

wire wb_en_out_to_reg;
wire mem_write_en_out_to_reg;
wire mem_read_en_out_to_reg;
wire s_out_to_reg;
wire b_out_to_reg;
wire imm_out_to_reg;
wire two_src_to_reg;
wire c_out_to_reg;


ID_stage ID_stage_instance (
	.clk(clk), 
	.rst(rst),
	.pc_in(pc_IF_ID),
	.instruction(instruction_IF_ID),
	.result_wb(result_WB_ID),
	.wb_en_in(wb_en_WB_ID), 
	.dest_wb(dst_WB_ID),
	.hazard(freeze), 
	.sr(sr_status_ID),
	
	.wb_en_out(wb_en_out_to_reg),
	.mem_write_en_out(mem_write_en_out_to_reg),
	.mem_read_en_out(mem_read_en_out_to_reg),
	.s_out(s_out_to_reg),
	.b_out(b_out_to_reg),
	.exe_cmd_out(exe_cmd_out_to_reg),
	.val_rn_out(val_rn_out_to_reg), 
	.val_rm_out(val_rm_out_to_reg),
	.imm_out(imm_out_to_reg),
	.signed_imm_24_out(signed_imm_24_out_to_reg),
	.shift_operand_out(shift_operand_out_to_reg),
	.dst_out(dst_out_to_reg), 
	.src1(src_1_to_reg),
	.src2(src_2_to_reg),
	.two_src(two_src_ID),
	.c_out(c_out_to_reg),
	.pc_out(pc_out_to_reg)
);

assign src2_ID = src_2_to_reg;

ID_EXE_reg ID_EXE_reg_instance ( 
	.clk(clk),
	.rst(rst),
	.flush(b_ID_EXE),
	.wb_en(wb_en_out_to_reg),
	.memory_r_en(mem_read_en_out_to_reg),
	.memory_w_en(mem_write_en_out_to_reg),
	.b(b_out_to_reg),
	.s(s_out_to_reg),
	.cmd_exe(exe_cmd_out_to_reg),
	.PC_in(pc_out_to_reg),
	.val_rn(val_rn_out_to_reg),
	.val_rm(val_rm_out_to_reg),
	.imm(imm_out_to_reg),
	.shift_operand(shift_operand_out_to_reg),
	.signed_imm_24(signed_imm_24_out_to_reg),
	.dest(dst_out_to_reg),
	.c_in(c_out_to_reg),
	.src_1_i(src_1_to_reg),
	.src_2_i(src_2_to_reg),
	.freeze_in(mem_freeze),

	.src_1_o(src_1_ID_forwarding),
	.src_2_o(src_2_ID_forwarding),
	.c_out(c_ID_EXE),
	.wb_en_out(wb_en_ID_EXE),
	.mem_r_en_out(mem_read_en_ID_EXE),
	.mem_w_en_out(mem_write_en_ID_EXE),
	.b_out(b_ID_EXE),
	.s_out(s_ID_EXE),
	.exe_cmd_out(exe_cmd_ID_EXE),
	.PC(pc_ID_EXE),
	.val_rn_out(val_rn_ID_EXE),
	.val_rm_out(val_rm_ID_EXE),
	.imm_out(imm_ID_EXE),
	.shift_operand_out(shift_operand_ID_EXE),
	.signed_imm_24_out(signed_imm_24_ID_EXE),
	.dest_out(dst_ID_EXE)
);


wire wb_en_EXE_MEM_to_reg;
wire mem_read_en_EXE_MEM_to_reg;
wire mem_write_en_EXE_MEM_to_reg;

wire [31:0] alu_result_EXE_MEM_to_reg;
wire [31:0] val_rm_EXE_MEM_to_reg;
wire [3:0] dst_EXE_MEM_to_reg;

EXE_stage EXE_stage_instance (
	.clk(clk),
	.rst(rst),
	.exe_cmd_ID_EXE(exe_cmd_ID_EXE),
	.mem_read_en_ID_EXE(mem_read_en_ID_EXE),
	.mem_write_en_ID_EXE(mem_write_en_ID_EXE),
	.pc_ID_EXE(pc_ID_EXE),
	.val_rn_ID_EXE(val_rn_ID_EXE),
	.val_rm_ID_EXE(val_rm_ID_EXE),
	.imm_ID_EXE(imm_ID_EXE), 
	.shift_operand_ID_EXE(shift_operand_ID_EXE),
	.signed_imm_24_ID_EXE(signed_imm_24_ID_EXE),
	.c_in(c_ID_EXE),
	.wb_en_ID_EXE(wb_en_ID_EXE),
	.b_ID_EXE(b_ID_EXE),
	.s_ID_EXE(s_ID_EXE),
	.alu_result_mem(alu_result_EXE_MEM),
	.data_wb_wb(result_WB_ID), 
	.select_src_1(select_src_1),
	.select_src_2(select_src_2),
	.dst_ID_EXE(dst_ID_EXE),
	.forwarding_en(forwarding_en),

	.wb_en_EXE_MEM(wb_en_EXE_MEM_to_reg),
	.mem_read_en_EXE_MEM(mem_read_en_EXE_MEM_to_reg),
	.mem_write_en_EXE_MEM(mem_write_en_EXE_MEM_to_reg),
	.alu_result_EXE_MEM(alu_result_EXE_MEM_to_reg),
	.EXE_MEM_val_rm(val_rm_EXE_MEM_to_reg),
	.EXE_IF_branch_addr(EXE_IF_branch_addr),
	.EXE_MEM_dst(dst_EXE_MEM_to_reg),
	.exe_IF_sr(sr_status_ID)
);

EXE_MEM_reg EXE_MEM_reg_instance (
	.clk(clk), 
	.rst(rst),
	.wb_en_EXE_MEM_input(wb_en_EXE_MEM_to_reg),
	.mem_read_en_EXE_MEM_input(mem_read_en_EXE_MEM_to_reg),
	.mem_write_en_EXE_MEM_input(mem_write_en_EXE_MEM_to_reg),
	.alu_result_EXE_MEM_input(alu_result_EXE_MEM_to_reg),
	.val_rm_EXE_MEM_input(val_rm_EXE_MEM_to_reg),
	.dst_EXE_MEM_input(dst_EXE_MEM_to_reg),
	.freeze_in(mem_freeze),

	.wb_en_EXE_MEM_output(wb_en_EXE_MEM),
	.mem_read_en_EXE_MEM_output(mem_read_en_EXE_MEM),
	.mem_write_en_EXE_MEM_output(mem_write_en_EXE_MEM),
	.alu_result_EXE_MEM_output(alu_result_EXE_MEM),
	.val_rm_EXE_MEM_output(EXE_MEM_val_rm),
	.dst_EXE_MEM_ouput(EXE_MEM_dst)
);

wire wb_en_MEM_WB_to_reg;
wire mem_read_en_MEM_WB_to_reg;
wire [31:0] result_MEM_WB_to_reg;
wire [31:0] data_mem_MEM_WB_to_reg;
wire [3:0] dst_MEM_WB_to_reg;

MEM_stage MEM_stage_instance (
	.clk(clk),
	.rst(rst),
	.mem_w_en_input(mem_write_en_EXE_MEM),
	.mem_r_en_input(mem_read_en_EXE_MEM),
	.wb_en_input(wb_en_EXE_MEM),
	.val_rm_i(EXE_MEM_val_rm),
	.dest_input(EXE_MEM_dst),
	.alu_res_input(alu_result_EXE_MEM),

	.wb_en_output(wb_en_MEM_WB_to_reg),
	.mem_r_en_output(mem_read_en_MEM_WB_to_reg),
	.dest_output(dst_MEM_WB_to_reg),
	.alu_res_output(result_MEM_WB_to_reg),
	.data_mem_output(data_mem_MEM_WB_to_reg),
	.mem_freeze(mem_freeze),

	.SRAM_DQ(SRAM_DQ),
	.SRAM_ADDR(SRAM_ADDR),
 	.SRAM_UB_N(SRAM_UB_N),
 	.SRAM_LB_N(SRAM_LB_N),
 	.SRAM_WE_N(SRAM_WE_N),
	.SRAM_CE_N(SRAM_CE_N),
 	.SRAM_OE_N(SRAM_OE_N)
);

 MEM_WB_reg MEM_WB_reg_instance (
	.clk(clk),
	.rst(rst),
	.alu_res_input(result_MEM_WB_to_reg),
	.data_mem_input(data_mem_MEM_WB_to_reg),
	.dst_input(dst_MEM_WB_to_reg),
	.mem_read_en_input(mem_read_en_MEM_WB_to_reg),
	.wb_en_input(wb_en_MEM_WB_to_reg),
	.freeze_in(mem_freeze),

	.wb_en_output(wb_en_MEM_WB),
	.mem_read_en_output(mem_read_en_MEM_WB),
	.alu_res_output(result_MEM_WB),
	.data_mem_output(data_mem_MEM_WB),
	.dst_output(dst_MEM_WB)
);

WB_stage WB_stage_instance (
	.clk(clk),
	.rst(rst),
	.wb_en_input(wb_en_MEM_WB),
	.mem_r_en_input(mem_read_en_MEM_WB),
	.dest_input(dst_MEM_WB),
	.alu_res_input(result_MEM_WB),
	.data_mem_i(data_mem_MEM_WB),

	.wb_en_output(wb_en_WB_ID),
	.wb_dest_o(dst_WB_ID),
	.wb_val_o(result_WB_ID)
);

HazardDetectionUnit HazardDetectionUnit_instance (
	.rn_ID(instruction_IF_ID[19:16]), 
	.src2_ID(src2_ID),
	.dst_exe(dst_ID_EXE), 
	.dst_memmory(EXE_MEM_dst),
	.two_src_ID(two_src_ID), 
	.memory_read_en_exe(mem_read_en_ID_EXE),
	.wb_en_memory(wb_en_EXE_MEM), 
	.wb_en_exe(wb_en_ID_EXE),
	.forwarding_en(forwarding_en),

	.freeze(freeze)
);

ForwardingUnit ForwardingUnit_instance
(
	.dst_memmory(EXE_MEM_dst), 
	.dst_wb(dst_MEM_WB),
	.src1(src_1_ID_forwarding),
	.src2(src_2_ID_forwarding),
	.wb_en_memory(wb_en_EXE_MEM), 
	.wb_en_wback(wb_en_MEM_WB),

	.select_src_1(select_src_1),
	.select_src_2(select_src_2)
);
endmodule
