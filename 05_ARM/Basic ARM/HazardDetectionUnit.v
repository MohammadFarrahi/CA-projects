
module HazardDetectionUnit(
	input[3:0] rn_ID, 
  input[3:0] src2_ID,
  input[3:0] dst_exe, 
  input[3:0] dst_memmory,
	input two_src_ID,
	input memory_read_en_exe,
	input wb_en_memory,
	input wb_en_exe,
	input forwarding_en,

	output reg freeze
);
	always @(*) begin
		freeze = 1'b0;
		if (memory_read_en_exe == 1'b1)begin
			if (dst_exe == rn_ID)
				freeze = 1'b1;
			
			else if (two_src_ID == 1'b1 && dst_exe==src2_ID) begin
				freeze = 1'b1;
			end
		end
		else if(forwarding_en == 1'b0) begin
			if(wb_en_exe == 1'b1) begin
				if(rn_ID == dst_exe)
					freeze = 1'b1;
			end
			if(wb_en_memory == 1'b1) begin
				if(rn_ID == dst_memmory)
					freeze = 1'b1;
			end
			if(two_src_ID == 1'b1) begin
				if(wb_en_exe == 1'b1) begin
					if(src2_ID == dst_exe)
						freeze = 1'b1;
				end
			end
			if(wb_en_memory == 1'b1) begin
					if(src2_ID == dst_memmory)
						freeze = 1'b1;
			end
	    end
	end
endmodule
