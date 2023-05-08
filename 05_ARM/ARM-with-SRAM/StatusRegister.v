module StatusRegister (
	input wr_en ,n, z, c, v, clk, rst,
  output[3:0] sr
);
	reg[31:0] status_reg;

	assign sr = status_reg[31:28];

	always @(negedge clk) begin
		if(rst == 1)
			status_reg <= 0;
		else if(wr_en == 1) begin
			status_reg[31 /*N*/] <= n;
			status_reg[30 /*Z*/] <= z;
			status_reg[29 /*C*/] <= c;
			status_reg[28 /*V*/] <= v;
		end
	end
endmodule