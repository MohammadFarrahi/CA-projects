module central_control(opcode, is_jr, alu_op, pc_src, reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, zero_flag, hazard_en, cond_hazard, IF_flush);
    input [5:0]opcode;
    input is_jr;
    output reg [1:0] alu_op;
    output reg [1:0] pc_src;
    output  reg reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard, IF_flush;
    input zero_flag;

    always@(opcode) begin //OUTPUTS TO ALU CONTROL
        alu_op = 2'b00;
        case(opcode)
            6'b000000: alu_op = 2'b10; //for RT -- add, sub, slt, jr --
            6'b100011: alu_op = 2'b00; //for lw
            6'b101011: alu_op = 2'b00; //for sw
            6'b001000: alu_op = 2'b00; //for addi
            6'b001010: alu_op = 2'b11; //for slti
            6'b000010: alu_op = 2'b01; //for j
            6'b000011: alu_op = 2'b01; //for jal
            6'b000100: alu_op = 2'b01; //for beq
            6'b000101: alu_op = 2'b01; //for bne
        endcase
    end

    always@(opcode, is_jr) begin //PRIMARY OUTPUTS
        {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0000000000;
        case(opcode)
            6'b000000: begin
                if(is_jr == 1'b1) begin
                    {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0000000011; //for jr
                end
                else
                    {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b1010000010; //for RT except jr
            end

            6'b100011: {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0011101010; //for lw
            6'b101011: {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0001010010; //for sw
            6'b001000: {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0011000010; //for addi
            6'b001010: {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0011000010; //for slti
            6'b000010: {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0000000000; //for j
            6'b000011: {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0110000100; //for jal
            6'b000100: {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0000000011; //for beq
            6'b000101: {reg_dst, Ch_31, reg_write, alu_src, mem_read, mem_write, mem_to_reg, pc_to_reg, hazard_en, cond_hazard} = 10'b0000000011; //for bne
        endcase
    end

    always@(opcode, is_jr, zero_flag) begin //OUTPUT TO COMPLEX MULTIPLEXRT
        if(is_jr == 1'b1) begin pc_src = 2'b11; IF_flush = 1'b1; end       //jr
        else if(opcode == 6'b000010 || opcode == 6'b000011) begin pc_src = 2'b10; IF_flush = 1'b1; end// j or jal
        else if(opcode == 6'b000100 && zero_flag == 1'b1) begin pc_src = 2'b01; IF_flush = 1'b1; end//beq and zero
        else if(opcode == 6'b000101 && zero_flag == 1'b0) begin pc_src = 2'b01; IF_flush = 1'b1; end//bne and not zero
        else begin pc_src = 2'b00; IF_flush = 1'b0; end                                     //otherwise
    end
endmodule
