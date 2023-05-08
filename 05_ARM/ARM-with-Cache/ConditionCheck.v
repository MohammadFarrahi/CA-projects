module ConditionCheck (
	input[3:0] sr,
	input[3:0] condition,
	output reg cond_check
);

	//cond_check is active low
	always @(*) begin
		cond_check = 1'b1;
		case(condition) 
			4'd0 /*eq*/ : begin
				if(sr[2/*Z*/] == 1'b1)
					cond_check = 1'b0;
			end
			4'd1 /*ne*/ : begin
				if(sr[2/*Z*/] == 1'b0)
					cond_check = 1'b0;
			end
			4'd2 /*cs_hs*/: begin
				if(sr[1/*C*/] == 1'b1)
					cond_check = 1'b0;
			end
			4'd3 /*cc_lo*/ : begin
				if(sr[1/*C*/] == 1'b0)
					cond_check = 1'b0;
			end
			4'd4 /*mi*/ : begin
				if(sr[3/*N*/] == 1'b1)
					cond_check = 1'b0;
			end
			4'd5 /*pl*/ : begin
				if(sr[3/*N*/] == 1'b0)
					cond_check = 1'b0;
			end
			4'd6 /*vs*/ : begin
				if(sr[0/*V*/] == 1'b1)
					cond_check = 1'b0;
			end
			4'd7 /*vc*/ : begin
				if(sr[0/*V*/] == 1'b0)
					cond_check = 1'b0;
			end
			4'd8 /*hi*/ : begin
				if((sr[1/*C*/] == 1'b1) && (sr[2/*Z*/] == 1'b0))
					cond_check = 1'b0;
			end
			4'd9 /*ls*/ : begin
				if((sr[1/*C*/] == 1'b0) || (sr[2/*Z*/] == 1'b1))
					cond_check = 1'b0;
			end
			4'd10 /*ls*/ : begin
				if(sr[3/*N*/] == sr[0/*V*/])
					cond_check = 1'b0;
			end
			4'd11 /*lt*/ : begin
				if(sr[3/*N*/] != sr[0/*V*/])
					cond_check = 1'b0;
			end
			4'd12 /*gt*/ : begin
				if((sr[2/*Z*/] == 1'b0) && (sr[3/*N*/] == sr[0/*V*/]))
					cond_check = 1'b0;
			end
			4'd13 /*le*/ : begin
				if((sr[2/*Z*/] == 1'b1) || (sr[3/*N*/] != sr[0/*V*/]))
					cond_check = 1'b0;
			end
			4'd14 /*al*/ : begin
				cond_check = 1'b0;
			end
			default : 
				cond_check = 1'b1;

		endcase
	end
endmodule
