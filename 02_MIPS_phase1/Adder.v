`timescale 1ns/1ns
module Adder #(parameter len = 32)(a, b, result);
input [len -1 : 0] a;
input [len -1 : 0] b;
output  [len -1 : 0] result;
assign result = a + b;
endmodule