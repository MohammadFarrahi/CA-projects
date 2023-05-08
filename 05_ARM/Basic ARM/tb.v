module tb;

  wire [31:0] alu_result;
  reg clk, rst, forward;


  ARM cut(alu_result, forward, clk, rst);

  always #5 clk = ~clk;
  initial begin
    forward = 1;
    clk=0;
    rst=0;
    #100
    rst = 1'b1;
    #100
    rst = 1'b0;
    #50000
    $stop;
  end

endmodule