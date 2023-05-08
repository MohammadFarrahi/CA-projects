`timescale 1ns/1ns
module MIPS_TB();
    reg clk = 0, rst = 0;
    always #5 clk = ~clk;

    MIPS_CPU #("Instructions.txt", "Data.txt") CUT(clk, rst);

    initial begin
        #1 rst = 1;
        #5 rst = 0;
        #630 $finish;
    end

endmodule
