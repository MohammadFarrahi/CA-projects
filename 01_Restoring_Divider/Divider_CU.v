`timescale 1ns/1ns
module  Divider_CU(clk, rst, start, sub_out_sign_bit, mux_sel, Ald, Ash, Qld, Qsh, Divisor_ld, done);
    input clk;
    input rst;
    input start;
    input sub_out_sign_bit;
    
    output mux_sel;
    output Ald;
    output Ash;
    output Qld;
    output Qsh;
    output Divisor_ld;
    output done;
    reg  mux_sel, Ald, Ash, Qld, Qsh, Divisor_ld, done;

    //for counter
    reg count_ld,count_en;
    reg count_co;
    reg [2:0] Q;


    reg[3:0] ps, ns;
    parameter[3:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3 , S4 = 4, S5 = 5, S6 = 6 , S7 = 7, S8 = 8;
    
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            ps <= S0;
        else
            ps <= ns;
    end
    
    always@(ps or start or sub_out_sign_bit or count_co)
    begin
        case(ps)
            S0: ns = start ? S1 : S0;
            S1: ns = S2;
            S2: ns = S3;
            S3: ns = S4;
            S4: ns = sub_out_sign_bit ? S7 : S5;
            S5: ns = count_co ? S8 : S6;
            S6: ns = S4;
            S7: ns = count_co ? S8 : S6;
            S8: ns = start;
            default: ns = S0;
        endcase
    end
    
    always@(ps)
    begin
    {mux_sel, Ald, Ash, Qld, Qsh, Divisor_ld, done, count_ld, count_en} = 9'd0;
        case(ps)
            S1: {mux_sel, Ald, count_ld} = 3'b111;
            S2: Qld = 1'b1;
            S3: {Divisor_ld, Ash} = 2'b11;
            S4:;
            S5: {mux_sel, Ald, Qsh} = 3'b011;
            S6: {count_en, Ash} = 2'b11;
            S7: Qsh = 1'b1;
            S8: done = 1'b1;
        endcase
    end

//counter
    always @(posedge clk, posedge rst) begin
        if(rst) Q <= 3'd0;
        else begin
            Q <= count_ld ? 3'b010 :
                count_en ? Q + 1'b1 : Q;
        end
    end
    assign count_co = &Q;

endmodule
