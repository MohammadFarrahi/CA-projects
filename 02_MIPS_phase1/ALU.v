module ALU (operation, A, B, result, zero);
    input [2:0] operation;
    input [31:0] A;
    input [31:0] B;
    output reg [31:0] result; 
    output zero;

    parameter [2:0] ADD = 3'b010, SUB = 3'b110, SLT = 3'b111;

    always @(A, B, operation) begin
        result = 32'd0;
        case (operation)
            ADD : result = A+B;
            SUB : result = A-B;
            SLT : result = (A<B)? 32'd1 : 32'd0;
            default : result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0) ? 1'b1 : 1'b0;
endmodule