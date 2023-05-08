module Register #(parameter N = 8) (clk, rst, ld_en, flush, PL, Q);
    input clk, rst, ld_en, flush;
    input [N-1:0] PL;
    output reg [N-1:0] Q;

    always @(posedge clk, posedge rst) begin
        if(rst) Q <= N'('d0);
        else if(ld_en) begin
            if(flush)  Q <= N'('d0);
            else Q <= PL;
        end
    end
endmodule