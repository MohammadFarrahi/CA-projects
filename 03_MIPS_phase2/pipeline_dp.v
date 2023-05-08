module pipeline_dp #(parameter INST_MEM_INIT_FILE = "Instructions.txt", DATA_MEM_INIT_FILE = "Data.txt") 
(clk, rst, pc_en, pc_src, IF_ID_en, IF_ID_flush, reg_dst, jal_sel, forward_a, forward_b, alu_src,
 comparator_out, alu_opr, reg_write, mem_read, mem_write, mem_to_reg, pc_to_reg, ID_EX_Rd,
  ID_EX_MemRead, ID_EX_RegWtrite, EX_MEM_Rd, EX_MEM_RegWrite, IF_ID_Rs, IF_ID_Rt, opcode, function_bits, MEM_WB_Rd, EX_MEM_Rd, ID_EX_Rs, ID_EX_Rt, EX_MEM_RegWrite, MEM_WB_RegWrite);

input clk, rst, pc_en;
input [1:0] pc_src;
input IF_ID_en, IF_ID_flush;
input mem_read, mem_write;

input reg_dst, jal_sel, alu_src;
input [2:0]alu_opr;
input mem_to_reg, pc_to_reg;
input reg_write;
input [1:0]forward_a, forward_b;
output comparator_out;

wire [2:0]we_after_mem_wb;
wire [1:0]m_after_ex_mem;
wire [27:0] shifter2_out;
wire [31:0] pc_pl, pc_out, pc_plus_four, pc_plus_extended, inst_after_if_id, read_data_1_before_reg, read_data_2_before_reg, inst_mem_out, pc_after_if_id;
wire [31:0] inst_extended, inst_ex_shift, data_1_after_id_ex, data_2_after_id_ex, extended_after_id_ex, alu_result, alu_result_after_ex_mem;
wire [31:0]data_mem_read_data , alu_result_after_mem_wb, mem_data_after_mem_wb, mux2_3_result, mux2_4_result , mux2_5_result, pc_add_after_idex, pc_add_after_exem, pc_add_after_memwb;
wire [31:0]mux3_1_result, mux3_2_result, data_32_after_ex_mem; 
wire [4:0] rt_after_id_ex, rd_after_id_ex, rs_after_id_ex, from_mux2_2, write_address_after_ex_mem, mux2_1_result;
wire [2:0] we_after_id_ex, we_after_ex_mem;
wire [1:0] m_after_id_ex;
wire [2:0] alu_opr;
wire [5:0] ex_after_id_ex;
wire [4:0] write_address_after_mem_wb;
//to hazard unit
output [4:0]ID_EX_Rd, IF_ID_Rs, IF_ID_Rt;
output ID_EX_MemRead, ID_EX_RegWtrite, EX_MEM_RegWrite;
output [5:0]opcode, function_bits;
//to forwarding unit
output [4:0] MEM_WB_Rd, EX_MEM_Rd, ID_EX_Rs, ID_EX_Rt;
output MEM_WB_RegWrite;

//outputs to forwarding unit
assign MEM_WB_Rd = write_address_after_mem_wb;
assign EX_MEM_Rd = write_address_after_ex_mem;
assign ID_EX_Rs = rs_after_id_ex;
assign ID_EX_Rt = rt_after_id_ex;
assign EX_MEM_RegWrite = we_after_ex_mem[2];
assign MEM_WB_RegWrite = we_after_mem_wb[2];

//outputs to controller
assign opcode = inst_after_if_id[31:26];
assign function_bits = inst_after_if_id[5:0];

//outputs to hazard unit
assign ID_EX_Rd = from_mux2_2;
assign ID_EX_MemRead = m_after_id_ex[0];
assign ID_EX_RegWtrite = we_after_id_ex[2];
assign EX_MEM_Rd = write_address_after_ex_mem;
assign EX_MEM_RegWrite = we_after_ex_mem[2];
assign IF_ID_Rs = inst_after_if_id[25:21];
assign IF_ID_Rt = inst_after_if_id[20:16];


//pc
New_PC PC (.clk(clk), .rst(rst), .ld_en(pc_en), .PL(pc_pl), .Q(pc_out));

//in between isters
IF_ID if_id(.clk(clk), .rst(rst),  .IF_ID_en(IF_ID_en), .IF_ID_flush(IF_ID_flush), .inst_pl(inst_mem_out), .inst_q(inst_after_if_id), .pc_pl(pc_plus_four), .pc_q(pc_after_if_id)); 
ID_EX id_ex(.clk(clk), 
            .rst(rst), 
            .data_1_pl(read_data_1_before_reg),
            .data_2_pl(read_data_2_before_reg),
            .extended_pl(inst_extended),
            .pc_after_add_pl(pc_after_if_id),
            .rt_pl(inst_after_if_id[20:16]),
            .rd_pl(inst_after_if_id[15:11]),
            .rs_pl(inst_after_if_id[25:21]),
             
            .we_pl({reg_write, mem_to_reg, pc_to_reg}), .m_pl({mem_write, mem_read}), .ex_pl({alu_opr, alu_src, reg_dst, jal_sel}),

            .data_1_out(data_1_after_id_ex),
            .data_2_out(data_2_after_id_ex),
            .extended_out(extended_after_id_ex),
            .pc_after_add_out(pc_add_after_idex),
            .rt_out(rt_after_id_ex),
            .rd_out(rd_after_id_ex),
            .rs_out(rs_after_id_ex), 
            .we_out(we_after_id_ex),
            .m_out(m_after_id_ex),
            .ex_out(ex_after_id_ex));


EX_MEM ex_mem(.clk(clk), 
              .rst(rst), 
              .alu_result_pl(alu_result),
              .data_from_reg_pl(mux3_2_result),
              .pc_after_add_pl(pc_add_after_idex),
              .write_address_pl(from_mux2_2),
              .we_pl(we_after_id_ex),
              .m_pl(m_after_id_ex),

              .alu_result_out(alu_result_after_ex_mem),
              .data_from_reg_out(data_32_after_ex_mem),
              .pc_after_add_out(pc_add_after_exem),
              .write_address_out(write_address_after_ex_mem),
              .we_out(we_after_ex_mem),
              .m_out(m_after_ex_mem));

MEM_WB mem_wb(.clk(clk), 
              .rst(rst),  
              .alu_result_pl(alu_result_after_ex_mem),
              .data_from_mem_pl(data_mem_read_data),
              .pc_after_add_pl(pc_add_after_exem),
              .write_address_pl(write_address_after_ex_mem),
              .we_pl(we_after_ex_mem),

              .alu_result_out(alu_result_after_mem_wb),
              .data_from_mem_out(mem_data_after_mem_wb),
              .pc_after_add_out(pc_add_after_memwb),
              .write_address_out(write_address_after_mem_wb),
              .we_out(we_after_mem_wb));





//4 to 1 mux
Mux_4to1 #(32) pc_mux (.s(pc_src), .J0(pc_plus_four), .J1(pc_plus_extended), .J2({pc_plus_four[31:28], shifter2_out}), .J3(read_data_1_before_reg), .W(pc_pl));

//adder 32
Adder #(32) pc_four (.a(pc_out), .b(32'd4), .result(pc_plus_four));
Adder #(32) pc_plus_offset (.a(pc_after_if_id), .b(inst_ex_shift), .result(pc_plus_extended));

//left shift 2
Lshifter #(2, 32) left_shifter1(.in(inst_extended), .out(inst_ex_shift));
Lshifter #(2, 28) left_shifter2(.in({2'b00, inst_after_if_id[25:0]}), .out(shifter2_out));

//instruction memory
InstMem #(INST_MEM_INIT_FILE) inst_mem (.Addr(pc_out), .Instruction(inst_mem_out));

//2 to 1 mux
Mux_2to1 #(5) mux2_1 (.s(ex_after_id_ex[1]), .J0(rt_after_id_ex), .J1(rd_after_id_ex),  .W(mux2_1_result));
Mux_2to1 #(5) mux2_2 (.s(ex_after_id_ex[0]), .J0(mux2_1_result), .J1(5'd31), .W(from_mux2_2));
Mux_2to1 #(32) mux2_3 (.s(we_after_mem_wb[1]), .J0(alu_result_after_mem_wb), .J1(mem_data_after_mem_wb),  .W(mux2_3_result));
Mux_2to1 #(32) mux2_4 (.s(we_after_mem_wb[0]), .J0(mux2_3_result), .J1(pc_add_after_memwb),  .W(mux2_4_result));
Mux_2to1 #(32) mux2_5 (.s(ex_after_id_ex[2]), .J0(mux3_2_result), .J1(extended_after_id_ex),  .W(mux2_5_result));

//sext
SignExt sext(.in(inst_after_if_id[15:0]), .out(inst_extended));

//comparator
EqComparator comp(.IN_A(read_data_1_before_reg), .IN_B(read_data_2_before_reg), .OUT_Q(comparator_out));
//alu
ALU alu (.operation(ex_after_id_ex[5:3]), .A(mux3_1_result), .B(mux2_5_result), .result(alu_result), .zero());


//register file
RegFile #(5,32)  reg_file(.clk(clk), .rst(rst), .regwrite(we_after_mem_wb[2]), .ReadReg1(inst_after_if_id[25:21]), .ReadReg2(inst_after_if_id[20:16]), .WriteReg(write_address_after_mem_wb), .WriteData(mux2_4_result), .ReadData1(read_data_1_before_reg), .ReadData2(read_data_2_before_reg));

//3 to 1 mux
Mux_3to1 #(32) mux3_1 (.s(forward_a), .J0(data_1_after_id_ex), .J1(alu_result_after_ex_mem), .J2(mux2_4_result), .W(mux3_1_result));
Mux_3to1 #(32) mux3_2 (.s(forward_b), .J0(data_2_after_id_ex), .J1(alu_result_after_ex_mem), .J2(mux2_4_result), .W(mux3_2_result));


//data memory
DataMem #(DATA_MEM_INIT_FILE) data_mem (.clk(clk), .rst(rst), .memread(m_after_ex_mem[0]), .memwrite(m_after_ex_mem[1]), .Address(alu_result_after_ex_mem), .WriteData(data_32_after_ex_mem), .ReadData(data_mem_read_data));

endmodule
