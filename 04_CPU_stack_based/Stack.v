module Stack(clk, rst, pop, push, tos, d_in, d_out, empty);
    input clk, rst, pop, push, tos;
    input [7:0] d_in;
    output [7:0] d_out;
    output empty;

    wire [15:0] inc_dec_out, top_pointer_out, addr;
    wire [7:0] Mem_out, q_mux_out, to_show_in;
    wire top_max, push_allow, pop_allow, to_show_en, valid_src;

    Register #(16) top_pointer_reg(clk, rst, 1'b1, 1'b0, inc_dec_out, top_pointer_out);
    assign top_max = &top_pointer_out;
    assign empty = ~(|top_pointer_out);

    assign push_allow = ~(top_max | pop) & push;
    assign pop_allow = ~empty & pop;
    CombAddSub inc_dec_circuit(push_allow, pop_allow, top_pointer_out, 16'd1, inc_dec_out);

    Mux_2to1 #(16) addr_mux(push_allow, top_pointer_out, inc_dec_out, addr);

    Mem stack_mem(clk, rst, 1'b1, push_allow, addr, d_in, Mem_out);
    
    Mux_2to1 d_out_mux (push_allow, Mem_out, d_in, q_mux_out);

    assign valid_src = empty & ~push;
    Mux_2to1 valid_out_mux(valid_src, q_mux_out, 8'd0, to_show_in);

    assign to_show_en = pop | push | tos;
    Register to_show_reg(clk, rst, to_show_en, 1'b0, to_show_in, d_out);

endmodule
