module ID_EX(input clk, 
             input rst,
             input [31:0] data_1_pl,
             input [31:0] data_2_pl,
             input [31:0] extended_pl,
             input [31:0] pc_after_add_pl, //
             input [4:0] rt_pl,
             input [4:0] rd_pl,
             input [4:0] rs_pl,
             
             input [2:0]we_pl, [1:0]m_pl, [5:0]ex_pl,

             output [31:0] data_1_out,
             output [31:0] data_2_out,
             output [31:0] extended_out,
             output [31:0] pc_after_add_out, //

             output [4:0] rt_out,
             output [4:0] rd_out,
             output [4:0] rs_out, 
             output [2:0] we_out, [1:0]m_out, [5:0]ex_out);

    Register #(32) read_data_1 (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(data_1_pl), .Q(data_1_out));
    Register #(32) read_data_2 (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(data_2_pl), .Q(data_2_out));
    Register #(32) extended (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(extended_pl), .Q(extended_out));
    Register #(32) pc_after_addition (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(pc_after_add_pl), .Q(pc_after_add_out));//

    Register #(5) Rt (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(rt_pl), .Q(rt_out));
    Register #(5) Rd (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(rd_pl), .Q(rd_out));
    Register #(5) Rs (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(rs_pl), .Q(rs_out));

    Register #(3) WE (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(we_pl), .Q(we_out));  //not changeed declaration
    Register #(2) M (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(m_pl), .Q(m_out));  //not changed declaration
    Register #(6) EX (.clk(clk), .rst(rst), .ld_en(1'b1), .flush(1'b0), .PL(ex_pl), .Q(ex_out)); //not changed declaration
endmodule