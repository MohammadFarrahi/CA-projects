
module New_PC(input clk, rst, ld_en, input [31:0]PL, output [31:0] Q);
Register #(32) pc (clk, rst, ld_en, 1'b0, PL, Q);
endmodule