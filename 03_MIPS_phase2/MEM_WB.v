module MEM_WB(input clk, 
             input rst, 
             input [31:0] alu_result_pl,
             input [31:0] data_from_mem_pl,
             input [31:0] pc_after_add_pl,

             input [4:0] write_address_pl,
             input [2:0]we_pl,

             output  [31:0] alu_result_out,
             output  [31:0] data_from_mem_out,
             output  [31:0] pc_after_add_out,

             output  [4:0] write_address_out,
             output  [2:0]we_out);

    Register #(32) alu_result (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(alu_result_pl), .Q(alu_result_out));
    Register #(32) read_data_from_mem (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(data_from_mem_pl), .Q(data_from_mem_out));
    Register #(32) pc_after_addition (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(pc_after_add_pl), .Q(pc_after_add_out));//

    Register #(5) write_address (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(write_address_pl), .Q(write_address_out));

    Register #(3) WE (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(we_pl), .Q(we_out)); 
endmodule