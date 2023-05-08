`timescale 1ns/1ns
module Subtractor_7bit(dataa,datab, w);
    input [6:0] dataa, datab;
    output reg [6:0] w;

    assign w = dataa - datab;
endmodule
