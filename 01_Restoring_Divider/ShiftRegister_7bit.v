`timescale 1ns/1ns
module ShiftRegister_7bit(clk,rst,ld_en,sh_en, Sin,PL, Sout,Q);
    input clk,rst,ld_en,sh_en;
    input Sin;
    input [6:0] PL;
    output Sout;
    output reg [6:0] Q;
    
    always @(posedge clk, posedge rst) begin
        if(rst) Q <= 7'd0;
        else if(ld_en) Q <= PL;
        else Q <= (sh_en) ? {Q[5:0], Sin} : Q;
    end
    assign Sout = Q[6];
endmodule
