module ControlUnitCore (
	input [1:0] mode,
	input [3:0] opcode,
	input s_in,

	output reg [3:0] cmd_exe,
	output reg mem_r_en,
	output reg mem_w_en,
	output reg wb_en,
	output reg b_out,
	output reg s_out
);

	always @(*) begin
		{wb_en,b_out,s_out,cmd_exe,mem_r_en,mem_w_en} = 0;
		case (mode)
			2'b00 /*  ari_cmd  */	: begin 
				case (opcode)
					4'b1101	: begin 
						cmd_exe = 1 ;
						s_out = s_in ;
						wb_en = 1;
					end
					4'b0100	: begin 
						cmd_exe = 2 ;
						s_out = s_in ;
						wb_en = 1;
					end
					4'b0101	: begin 
						cmd_exe = 3 ;
						s_out = s_in ;
						wb_en = 1;
					end
					4'b0010	: begin 
						cmd_exe = 4 ;
						s_out = s_in ;
						wb_en = 1;
					end
					4'b1111	: begin 
						cmd_exe = 9 ;
						s_out = s_in ;
						wb_en = 1;
					end
					4'b0110	: begin 
						cmd_exe = 5 ;
						s_out = s_in ;
						wb_en = 1;
					end
					4'b0000	: begin 
						cmd_exe = 6 ;
						s_out = s_in ;
						wb_en = 1;
					end
					4'b1100	: begin 
						cmd_exe = 7 ;
						s_out = s_in ;
						wb_en = 1;
					end
					4'b0001	: begin 
						cmd_exe = 8 ;
						s_out = s_in ;
						wb_en = 1;
					end
					4'b1010	: begin 
						if (s_in) begin 
							cmd_exe = 4 ;
							s_out = 1 ;
							wb_en = 0;
						end
					end
					4'b1000	: begin 
						if (s_in) begin 
							cmd_exe = 6 ;
							s_out = 1 ;
							wb_en = 0;
						end
					end
					default : begin
						cmd_exe = 1 ;
						s_out = 1'bz ;
						wb_en = 0;
					end
				endcase
			end

			2'b01	: begin 
				if (s_in) begin 
					cmd_exe = 2 ;
					s_out = 1'b1 ;
					mem_r_en = 1'b1 ;
					wb_en = 1'b1 ;
				end
				else if(~s_in) begin 
					cmd_exe = 2 ;
					s_out = 0;
					mem_w_en = 1;
				end	
			end

			2'b10	: begin 
				if (opcode[3] == 0) begin 
					//cmd_exe = b_a ; // dont care
					b_out = 1;
				end
			end
		endcase
	end
		
endmodule
