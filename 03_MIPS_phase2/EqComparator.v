module EqComparator(IN_A, IN_B, OUT_Q);
    input [31:0] IN_A, IN_B;
    output OUT_Q;
    assign OUT_Q = (IN_A == IN_B) ? 1'b1 : 1'b0;
endmodule
