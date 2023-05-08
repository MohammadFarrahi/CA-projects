`timescale 1ns/1ns
module Divider(clk,rst,start, In_bus,Q_bus,R_bus, done);
    input clk, rst, start;
    input [5:0] In_bus;
    output [5:0] Q_bus, R_bus;
    output done;

    wire Ald, Ash, Qld, Qsh, Divisor_ld, mux_sel, sub_out_sign_bit;

    Divider_DP DP(clk,rst, In_bus, Ald,Ash, Qld,Qsh, Divisor_ld, mux_sel, Q_bus,R_bus, sub_out_sign_bit);
    Divider_CU CU(clk,rst, start, sub_out_sign_bit, mux_sel, Ald,Ash, Qld,Qsh, Divisor_ld, done);

endmodule
