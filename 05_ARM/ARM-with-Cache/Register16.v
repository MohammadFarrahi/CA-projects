module Register16(
  input clk,
  input rst,
  input [15:0] data_in,
  input ld,
  
  output reg [15:0] data_out
);

  always@(posedge clk,posedge rst) begin
    if (rst)
      data_out <= 16'd0;
    else if(ld)
      data_out <= data_in;
  end
  endmodule