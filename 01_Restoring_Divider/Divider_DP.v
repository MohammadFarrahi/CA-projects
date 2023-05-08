`timescale 1ns/1ns
module Divider_DP(clk, rst, In_bus, Ald, Ash, Qld, Qsh, Divisor_ld, mux_sel,
		   Quotient, Remainder, sub_out_sign_bit);
    input clk;
    input rst;
    input [5:0] In_bus;
    input Ald;
    input Ash;
    input Qld;
    input Qsh;
    input Divisor_ld;
    input mux_sel;
    output [5:0]Quotient;
    output [5:0]Remainder;
    output sub_out_sign_bit;

    wire QtoA;
    wire [6:0] A_data;
    wire Areg_sout;
    wire [6:0] A_out;
    wire [5:0] Q_out;
    wire ser_in_to_Q;
    wire [6:0] Divisor_out;
    wire [6:0] Sub_out;
    assign Quotient = Q_out;
    assign Remainder = A_out[5:0];
    assign ser_in_to_Q = ~Sub_out[6];
    assign sub_out_sign_bit = Sub_out[6];

    ShiftRegister_7bit A_reg(.clk(clk), .rst(rst), .ld_en(Ald), .sh_en(Ash), .Sin(QtoA), .PL(A_data), .Sout(Areg_sout), .Q(A_out));
    ShiftRegister_6bit Q_reg(.clk(clk), .rst(rst), .ld_en(Qld), .sh_en(Qsh), .Sin(ser_in_to_Q), .PL(In_bus), .Sout(QtoA), .Q(Q_out));
    Register_7bit Divisor_reg(.clk(clk), .rst(rst), .ld_en(Divisor_ld), .PL({1'b0, In_bus}), .Q(Divisor_out));
    Subtractor_7bit Subtract(.dataa(A_out), .datab(Divisor_out), .w(Sub_out));
    Mux_2to1 mux(.s(mux_sel), .J0(Sub_out), .J1({1'b0,In_bus}), .W(A_data));

endmodule