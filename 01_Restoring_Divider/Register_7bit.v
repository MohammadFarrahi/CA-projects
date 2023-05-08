`timescale 1ns/1ns
module Register_7bit(clk,rst,ld_en, PL, Q);
    input clk,rst,ld_en;
    input [6:0] PL;
    output reg [6:0] Q;

    always @(posedge clk, posedge rst) begin
        if(rst) Q <= 7'd0;
        else if(ld_en) Q <= PL;
    end
endmodule
