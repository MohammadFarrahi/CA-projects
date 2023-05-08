module MIPS_DP #(parameter INST_MEM_INIT_FILE = "Instructions.txt", DATA_MEM_INIT_FILE = "Data.txt") (clk, rst, PCSrc, RegDst, Ch_31, RegWrite, ALUSrc, ALUOpr, MemRead, MemWrite, MemtoReg, PCtoReg, OpCode, Func, zero_flag);
    input [1:0] PCSrc;
    input [2:0] ALUOpr;
    input clk, rst, RegDst, Ch_31, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, PCtoReg;
    output zero_flag;
    output [5:0] OpCode, Func;


    wire [31:0] pc_load, inst_addr, instruction, rf_write_data, rf_data1, rf_data2, const_32bit;
    wire [31:0] ALU_src2, ALU_result, mem_data, rf_write_src1, PC_plus_4, const_32bit_mult_4, cond_PC;
    wire [4:0] rf_write_addr, rf_write_reg;
    wire [27:0] un_cond_PC;
    

    PC_Register pc(clk, rst, pc_load, inst_addr);
    InstMem #(INST_MEM_INIT_FILE) inst_memory(inst_addr, instruction);
    
    Mux_2to1 #(5) mux1(RegDst, instruction[20:16], instruction[15:11], rf_write_addr);
    Mux_2to1 #(5) mux2(Ch_31, rf_write_addr, 5'b11111, rf_write_reg);
    RegFile register_file(clk, rst, RegWrite, instruction[25:21], instruction[20:16], rf_write_reg, rf_write_data, rf_data1, rf_data2);

    SignExt sign_ext(instruction[15:0], const_32bit);
    Mux_2to1 #(32) mux3(ALUSrc, rf_data2, const_32bit, ALU_src2);
    ALU alu(.operation(ALUOpr), .A(rf_data1), .B(ALU_src2), .result(ALU_result), .zero(zero_flag));

    DataMem #(DATA_MEM_INIT_FILE) data_memory(.clk(clk), .rst(rst), .memread(MemRead), .memwrite(MemWrite), .Address(ALU_result), .WriteData(rf_data2), .ReadData(mem_data));
    Mux_2to1 #(32) mux4(MemtoReg, ALU_result, mem_data, rf_write_src1);
    Mux_2to1 #(32) mux5(PCtoReg, rf_write_src1, PC_plus_4, rf_write_data);

    //normal next address
    Adder adder1(32'd4, inst_addr, PC_plus_4);
    //next address when "beq" or "bne"
    Lshifter #(2, 32) left_shifter1(const_32bit, const_32bit_mult_4);
    Adder adder2(PC_plus_4, const_32bit_mult_4, cond_PC);
    //next address when "j" or "jal"
    Lshifter #(2, 28) left_shifter2({2'b00, instruction[25:0]}, un_cond_PC);
    // one of the cource of PC is rf_data1 because when instruction is "jr", the next address is in register file
    Mux_4to1 #(32) mux6(PCSrc, PC_plus_4, cond_PC, {PC_plus_4[31:28], un_cond_PC}, rf_data1, pc_load);

    assign OpCode = instruction[31:26];
    assign Func = instruction[5:0];
endmodule
