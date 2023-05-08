module ALU (
	input [3:0] exe_cmd,
	input c_in,
	input signed [31:0] val1 , val2,
	output reg [32:0] result_alu,
  output n, z, c, v
	);
	always @(*) begin
    case (exe_cmd) //synthesis parallel_case
      4'b0001 /*mov_a*/ : result_alu = val2;
      4'b1001 /*mvn_a*/ : result_alu = ~val2;
      4'b0010 /*add_a*/ : result_alu = val1 + val2;
      4'b0101 /*sbc_a*/ : result_alu = val1 - val2 - 1;
      4'b0110 /*and_a*/ : result_alu = val1 & val2;
      4'b0111 /*orr_a*/ : result_alu = val1 | val2;
      4'b0011 /*adc_a*/ : result_alu = val1 + val2 + c_in;
      4'b0100 /*sub_a*/ : result_alu = val1 - val2;
      4'b1000 /*eor_a*/ : result_alu = val1 ^ val2;
      default: 
        result_alu = 33'd0;
    endcase
		end
  assign n = result_alu[31];
	assign z = (result_alu == 33'd0);
	assign c = result_alu[32];
	assign v = result_alu[31] ^ c ;
endmodule