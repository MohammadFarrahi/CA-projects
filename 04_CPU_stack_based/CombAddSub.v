module CombAddSub(add_en, sub_en, dataA, dataB, Q);
    input [15:0] dataA, dataB;
    input add_en, sub_en;
    output [15:0] Q;

    assign Q = (add_en) ? dataA + dataB : (sub_en) ? dataA - dataB : dataA;

endmodule
