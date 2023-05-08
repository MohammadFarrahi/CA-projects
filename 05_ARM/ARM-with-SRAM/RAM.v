module RAM (
	input clk, rst,
	input w_en,
	input [17:0] address,
	inout [15:0] dq
);
	reg [15:0] mem [0:262143];
	reg [15:0] temp;
	integer i;
	always @(posedge clk) begin 
		if(rst) begin
			for(i = 0; i < 262143; i = i+1)
				mem[i] = 0;
		end
		else if(w_en==0)
		  mem[address] = dq;
		else
		  temp = mem[address];
  end
  assign dq = w_en ? temp : 16'bz;
endmodule