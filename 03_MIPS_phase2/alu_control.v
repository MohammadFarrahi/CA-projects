module alu_control(alu_op, function_bits, alu_operation, is_jr);
    input [1:0]alu_op;
    input [5:0]function_bits;
    output reg [2:0]alu_operation;
    output reg is_jr;

    always@(alu_op, function_bits) begin
        alu_operation = 3'd0;
        if(alu_op == 2'b00) begin                    //for lw, sw , addi
            alu_operation = 3'b010;
        end

        else if (alu_op == 2'b01) begin              //for j, jal , beq, bne
            alu_operation = 3'b110;
        end

        else if (alu_op == 2'b11) begin               //for slti
            alu_operation = 3'b111;
        end
        else begin
            case(function_bits)
            6'b100000: alu_operation = 3'b010;      //for add
            6'b100010: alu_operation = 3'b110;      //for sub
            6'b101010: alu_operation = 3'b111;      //for slt
            6'b001000: alu_operation = 3'b111;      //for jr
            endcase
        end
    end
    always@(alu_op, function_bits) begin
        is_jr = 1'b0;
        if(alu_op == 2'b10 && function_bits == 6'b001000) begin
            is_jr = 1'b1;
        end
    end
endmodule