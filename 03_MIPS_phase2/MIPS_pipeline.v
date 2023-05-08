module MIPS_pipeline  #(parameter INST_MEM_INIT_FILE = "Instructions.txt", DATA_MEM_INIT_FILE = "Data.txt") (input clk, rst);
    wire [5:0] opcode;
    wire [5:0] function_bits;
    wire zero_flag;
    wire [1:0] pc_src;
    wire reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard, IF_flush;
    wire [2:0] alu_operation;


    wire ID_EX_MemRead,ID_EX_RegWtrite;
    wire [4:0] ID_EX_Rd,EX_MEM_Rd,IF_ID_Rs,IF_ID_Rt;
    wire IF_ID_Write,PC_Write,control_src;

    wire [4:0] MEM_WB_Rd, ID_EX_Rs, ID_EX_Rt;
    wire EX_MEM_RegWrite, MEM_WB_RegWrite;
    wire [1:0] forwardA, forwardB;

    wire [10:0] control_signals;

    Controller controller(opcode, function_bits, pc_src, reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, alu_operation, zero_flag, hazard_en, cond_hazard, IF_flush);
    HazardUnit hazard_unit(  
                    hazard_en,cond_hazard,
                    ID_EX_Rd,ID_EX_MemRead,ID_EX_RegWtrite,
                    EX_MEM_Rd,EX_MEM_RegWrite,
                    IF_ID_Rs,IF_ID_Rt,
                    IF_ID_Write,PC_Write,control_src
                );
    ForwardingUnit forwarding_unit(MEM_WB_Rd, EX_MEM_Rd, EX_MEM_RegWrite, MEM_WB_RegWrite, ID_EX_Rs, ID_EX_Rt, forwardA, forwardB);

    Mux_2to1 #(11) control_mux(control_src, 11'd0, {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, alu_operation}, control_signals);

    pipeline_dp #(INST_MEM_INIT_FILE, DATA_MEM_INIT_FILE)  datapath(clk, rst, PC_Write, pc_src, IF_ID_Write, IF_flush, control_signals[10], control_signals[9], forwardA, forwardB, control_signals[7],
                zero_flag, control_signals[2:0], control_signals[8], control_signals[6], control_signals[5], control_signals[4], control_signals[3], ID_EX_Rd,
                 ID_EX_MemRead, ID_EX_RegWtrite, EX_MEM_Rd, EX_MEM_RegWrite, IF_ID_Rs, IF_ID_Rt, opcode, function_bits, MEM_WB_Rd, EX_MEM_Rd, ID_EX_Rs, ID_EX_Rt,
                 EX_MEM_RegWrite, MEM_WB_RegWrite);

endmodule
