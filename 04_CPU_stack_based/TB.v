module TB();
    reg clk = 0, rst = 0;
    
    always #5 clk = ~clk;
    mips_stack #("Data.txt") CUT(clk, rst);

    initial begin
        #1 rst = 1;
        #5 rst = 0;
        #500 $stop;
    end

endmodule