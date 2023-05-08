module ForwardingUnit (
	input[3:0] dst_memmory, 
	input[3:0] dst_wb,
	input[3:0] src1,
	input[3:0] src2,
	input wb_en_memory, 
	input wb_en_wback, 
  
	output reg[1:0] select_src_1 = 2'd0,
	output reg[1:0] select_src_2 = 2'd0
);

	always @(*) begin
		select_src_1 = 2'd0;
		select_src_2 = 2'd0;
		case({wb_en_memory, wb_en_wback})
			2'b00 : begin
				select_src_1 = 2'd0;
				select_src_2 = 2'd0;
			end
			2'b01 : begin
				if(dst_wb == src1)
					select_src_1 = 2'd2;
				if(dst_wb == src2)
					select_src_2 = 2'd2;
			end
			2'b10 : begin
				if(dst_memmory == src1)
					select_src_1 = 2'd1;
				if(dst_memmory == src2)
					select_src_2 = 2'd1;
			end
			2'b11 : begin
				if(dst_memmory == src1)
					select_src_1 = 2'd1;
				else if(dst_wb == src1)
					select_src_1 = 2'd2;

				if(dst_memmory == src2)
					select_src_2 = 2'd1;
				else if(dst_wb == src2)
					select_src_2 = 2'd2;
			end
			default : begin
				select_src_1 = 2'd0;
				select_src_2 = 2'd0;
			end
		endcase

	end
endmodule
