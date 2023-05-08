module ALU (operation, A, B, result, zero);
    input [1:0] operation;
    input [7:0] A;
    input [7:0] B;
    output reg [7:0] result; 
    output zero;

    parameter [1:0] ADD = 2'd0 , SUB = 2'd1 , AND = 2'd2, NOT = 2'd3;

    always @(A, B, operation) begin
        result = 8'd0;
        case (operation)
            ADD : result = A+B;
            SUB : result = A-B;
            AND : result = A & B;
            NOT : result = ~B;
            default : result = 8'd0;
        endcase
    end

    assign zero = (result == 8'd0) ? 1'b1 : 1'b0;
endmodule