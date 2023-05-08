module IF_ID(input clk, rst, IF_ID_en, IF_ID_flush, input[31:0] inst_pl, output [31:0] inst_q,
                input [31:0] pc_pl, output [31:0] pc_q);

    Register #(32) instruction_reg (.clk(clk), .rst(rst), .ld_en(IF_ID_en), .flush(IF_ID_flush), .PL(inst_pl), .Q(inst_q));
    Register #(32) pc_after_addition (.clk(clk), .rst(rst), .ld_en(IF_ID_en), .flush(IF_ID_flush), .PL(pc_pl), .Q(pc_q));

endmodule