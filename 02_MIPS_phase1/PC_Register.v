module PC_Register #(parameter N = 32) (clk, rst, PL, Q);
    input clk, rst;
    input [N-1:0] PL;
    output reg [N-1:0] Q;

    always @(posedge clk, posedge rst) begin
        if(rst) Q <= N'('d0);
        else Q <= PL;
    end
endmodule