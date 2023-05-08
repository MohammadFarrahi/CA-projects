module RegisterFile (
	input clk, rst, 
  input [3:0] src1, src2, dest_wb,
	input[31:0] result_wb,
  input write_back_en,
	output [31:0] reg1, reg2
);
  integer counter = 0;
  reg[31:0] reg_file[0:14];

  assign reg1 = reg_file[src1];
  assign reg2 = reg_file[src2];

  always @(negedge clk, posedge rst) begin
    if (rst) begin
      for(counter=0; counter<15; counter=counter+1)
        reg_file[counter] <= counter;
    end
    else if (write_back_en) reg_file[dest_wb] <= result_wb;
	end

endmodule