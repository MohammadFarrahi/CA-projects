module mips_stack_dp #(parameter DATA_MEM_INIT_FILE = "Data.txt") (clk, rst, PCsrc, PCWrite, PCWriteCond, AdSelect, dinSel, ALUsrcA, ALUsrcB, IRwrite, push, pop, tos, stack_empty, MemRead, MemWrite, opcode, ALUcontrol);

input clk, rst, PCWrite, PCWriteCond, ALUsrcB, PCsrc, AdSelect, IRwrite, push, pop, tos;
input MemRead, MemWrite;
input [1:0] dinSel, ALUsrcA, ALUcontrol;
output stack_empty;
output [2:0] opcode;

wire [4:0] pc_out, ad_sel_mux_out, pc_mux_out; 
wire [7:0] alu_b_mux_out, alu_a_mux_out, din_sel_mux_out, stack_out, popped_data_out, memory_out;
wire [7:0] ir_out, mdr_out, alu_reg_out, alu_result;
wire alu_zero, pc_en;

assign opcode = ir_out[7:5];

assign pc_en = PCWrite | (alu_zero & PCWriteCond);
Register #(5) PC(.clk(clk), .rst(rst), .ld_en(pc_en), .flush(1'b0), .PL(pc_mux_out), .Q(pc_out));

Mux_2to1 #(5) ad_select_mux (.s(AdSelect), .J0(pc_out), .J1(ir_out[4:0]),  .W(ad_sel_mux_out));
Mux_2to1 #(5) pc_src_mux (.s(PCsrc), .J0(alu_result[4:0]), .J1(ir_out[4:0]),  .W(pc_mux_out));
Mux_2to1 #(8) alu_src_b_mux (.s(ALUsrcB), .J0({3'b000, pc_out}), .J1(popped_data_out),  .W(alu_b_mux_out));

Mux_3to1 #(8) alu_src_a_mux (.s(ALUsrcA), .J0(stack_out), .J1(8'd0), .J2(8'd1), .W(alu_a_mux_out));
Mux_3to1 #(8) din_sel_mux (.s(dinSel), .J0(mdr_out), .J1(alu_reg_out), .J2(popped_data_out), .W(din_sel_mux_out));

Register #(8) IR (.clk(clk), .rst(rst), .ld_en(IRwrite), .flush(1'b0), .PL(memory_out), .Q(ir_out));
Register #(8) MDR (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(memory_out), .Q(mdr_out));

Stack stack(.clk(clk), .rst(rst), .pop(pop), .push(push), .tos(tos), .d_in(din_sel_mux_out), .d_out(stack_out), .empty(stack_empty));

Register #(8) popped_data (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(stack_out), .Q(popped_data_out));
Register #(8) alu_reg (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(alu_result), .Q(alu_reg_out));

inst_data_mem #(DATA_MEM_INIT_FILE) mem (.clk(clk), .rst(rst), .memread(MemRead), .memwrite(MemWrite), .Address(ad_sel_mux_out), .WriteData(popped_data_out), .ReadData(memory_out));

ALU alu(.operation(ALUcontrol), .A(alu_a_mux_out), .B(alu_b_mux_out), .result(alu_result), .zero(alu_zero));

endmodule