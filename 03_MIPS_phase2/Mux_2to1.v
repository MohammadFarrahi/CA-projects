module Mux_2to1 #(parameter N = 32) (s, J0, J1,  W);
    input s;
    input [N-1:0] J0;
    input [N-1:0] J1;
    output [N-1:0] W;
	assign W = s ? J1 : J0;
endmodule
