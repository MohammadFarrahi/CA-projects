module Controller(opcode, function_bits, pc_src, reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, alu_operation, zero_flag, hazard_en, cond_hazard, IF_flush);
    input [5:0] opcode;
    input [5:0] function_bits;
    input zero_flag;
    output [1:0] pc_src;
    output reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard, IF_flush;
    output [2:0] alu_operation;
    
    wire [1:0]alu_op;
    wire is_jr;

    alu_control ALU_CU(.alu_op(alu_op), .function_bits(function_bits), .alu_operation(alu_operation), .is_jr(is_jr));


    central_control CENTERAL_CU(.opcode(opcode), .is_jr(is_jr), .alu_op(alu_op), .pc_src(pc_src), .reg_dst(reg_dst), .Ch_31(Ch_31),
                    .reg_write(reg_write), .alu_src(alu_src), .mem_read(mem_read), .mem_write(mem_write), .mem_to_reg(mem_to_reg), .pc_to_reg(pc_to_reg), .zero_flag(zero_flag),
                    .hazard_en(hazard_en), .cond_hazard(cond_hazard), .IF_flush(IF_flush));
endmodule