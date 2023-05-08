`timescale 1ns/1ns
module ShiftRegister_6bit(clk,rst,ld_en,sh_en, Sin,PL, Sout,Q);
    input clk,rst,ld_en,sh_en;
    input Sin;
    input [5:0] PL;
    output Sout;
    output reg [5:0] Q;
    
    always @(posedge clk, posedge rst) begin
        if(rst) Q <= 6'd0;
        else if(ld_en) Q <= PL;
        else Q <= (sh_en) ? {Q[4:0], Sin} : Q;
    end
    assign Sout = Q[5];
endmodule
