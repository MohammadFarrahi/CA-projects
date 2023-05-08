
module MEM_stage (
	input clk,
	input rst,
	input mem_w_en_input,
	input mem_r_en_input,
	input wb_en_input,
	input [31:0] val_rm_i,
	input [3:0] dest_input,
	input [31:0] alu_res_input,

	output wb_en_output,
	output mem_r_en_output,
	output [3:0] dest_output,
	output [31:0] alu_res_output,
	output [31:0] data_mem_output,
	output mem_freeze,

	inout [15:0] SRAM_DQ,
	output[17:0] SRAM_ADDR,
 	output SRAM_UB_N,
 	output SRAM_LB_N,
 	output SRAM_WE_N,
	output SRAM_CE_N,
 	output SRAM_OE_N
);

	wire [31:0] data_mem_w_in;
	wire ready;
	// RAM #(.word_wIDth(32), .address_wIDth(32), .depth(40))
  //   data_memory (
	// 	.w_en(mem_w_en_input),
	// 	.r_en(mem_r_en_input),
	// 	.address(alu_res_input),
	// 	.d_in(val_rm_i),
	// 	.d_out(data_mem_w_in),
	// 	.clk(clk),
	// 	.rst(rst)
	// );

	Sram_Controller RAM_controller(
  .clk(clk),
  .rst(rst),
  
  .wr_en(mem_w_en_input),
  .rd_en(mem_r_en_input),
  .address(alu_res_input),
  .write_data(val_rm_i),

  .read_data(data_mem_w_in),
  .ready(ready),
  
  .SRAM_DQ(SRAM_DQ),
  .SRAM_ADDR(SRAM_ADDR),
  .SRAM_UB_N(SRAM_UB_N),
  .SRAM_LB_N(SRAM_LB_N),
  .SRAM_WE_N(SRAM_WE_N),
  .SRAM_CE_N(SRAM_CE_N),
  .SRAM_OE_N(SRAM_OE_N)
);

	assign wb_en_output = mem_freeze ? 1'b0 : wb_en_input;
	assign mem_r_en_output = mem_r_en_input;
	assign dest_output = dest_input;
	assign alu_res_output = alu_res_input;
	assign data_mem_output = data_mem_w_in;
	assign mem_freeze = ~ready;
endmodule 
