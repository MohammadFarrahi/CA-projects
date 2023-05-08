`timescale 1ns/1ns
module Mux_2to1(s, J0, J1,  W);
    input s;
    input [6:0] J0;
    input [6:0] J1;
    output [6:0] W;
	assign W = s ? J1 : J0;
endmodule
