module RAM #(parameter word_wIDth = 32, parameter address_wIDth = 5, parameter depth = 8) (
	input clk, rst,
	input w_en,
	input r_en,
	input [address_wIDth-1:0] address,
	input [word_wIDth-1:0] d_in,

	output [word_wIDth-1:0] d_out
);
	reg [word_wIDth-1:0] mem [0:depth-1];
	integer i;
	always @(posedge clk) begin 
		if(rst) begin
			for(i = 0; i < depth; i = i+1)
				mem[i] = 0;
		end
		if(w_en)
			mem[address - 1024] = d_in;
	end
	assign d_out = mem[address - 1024];
endmodule