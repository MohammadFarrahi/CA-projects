module tb;

  wire [31:0] alu_result;
  reg clk, rst;
  // reg forward;
  wire [17:0] addr;
  wire w_en;
  wire [15:0] dq;

  ARM cut(
    .clk(clk),
    .rst(rst),
    .alu_result_EXE_MEM(alu_result),
    .SRAM_DQ(dq),
    .SRAM_ADDR(addr),
    .SRAM_WE_N(w_en)
  );

  RAM sram(
    .clk(clk),
    .rst(rst),
    .w_en(w_en),
    .address(addr),
    .dq(dq)
  );

  always #5 clk = ~clk;
  initial begin
    // forward = 1;
    clk=0;
    rst=0;
    #100
    rst = 1'b1;
    #100
    rst = 1'b0;
    #6000
    $stop;
  end

endmodule