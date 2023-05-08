`timescale 1ns/1ns
module MIPS_CPU #(parameter INST_MEM_INIT_FILE = "Instructions.txt", DATA_MEM_INIT_FILE = "Data.txt") (clk , rst);
input clk;
input rst;
wire zero;
wire [5:0] f_bits;
wire [5:0] op;
wire [1:0] pc_source;
wire rgdst;
wire ch_31;
wire reg_write;
wire alu_source;
wire mem_read;
wire mem_write;
wire [2:0]alu_operation;
wire mem_to_reg;
wire pc_to_reg;

MIPS_DP #(INST_MEM_INIT_FILE, DATA_MEM_INIT_FILE) datapath(.clk(clk), .rst(rst), .PCSrc(pc_source), .RegDst(rgdst), .Ch_31(ch_31), .RegWrite(reg_write), .ALUSrc(alu_source), .ALUOpr(alu_operation), .MemRead(mem_read), .MemWrite(mem_write), .MemtoReg(mem_to_reg), .PCtoReg(pc_to_reg), .OpCode(op), .Func(f_bits), .zero_flag(zero));
MIPS_CU contorol_unit(.opcode(op), .function_bits(f_bits), .pc_src(pc_source), .reg_dst(rgdst), .Ch_31(ch_31), .reg_write(reg_write), .alu_src(alu_source), .mem_read(mem_read), .mem_write(mem_write), .mem_to_reg(mem_to_reg), .pc_to_reg(pc_to_reg), .alu_operation(alu_operation), .zero_flag(zero));

endmodule