module ForwardingUnit(MEM_WB_Rd, EX_MEM_Rd, EX_MEM_RegWrite, MEM_WB_RegWrite, ID_EX_Rs, ID_EX_Rt, forwardA, forwardB);
    input [4:0] MEM_WB_Rd, EX_MEM_Rd, ID_EX_Rs, ID_EX_Rt;
    input EX_MEM_RegWrite, MEM_WB_RegWrite;
    output reg [1:0] forwardA, forwardB;

    always @(MEM_WB_Rd, EX_MEM_Rd, EX_MEM_RegWrite, MEM_WB_RegWrite, ID_EX_Rs) begin
        if(EX_MEM_RegWrite & EX_MEM_Rd == ID_EX_Rs & EX_MEM_Rd != 5'b00000) forwardA = 2'b01; //FWD srcA : MEM to EX
        else if (MEM_WB_RegWrite & MEM_WB_Rd == ID_EX_Rs & MEM_WB_Rd != 5'b00000) forwardA = 2'b10; //FWD srcA : WB to EX
        else forwardA = 2'b00;
    end
    always @(MEM_WB_Rd, EX_MEM_Rd, EX_MEM_RegWrite, MEM_WB_RegWrite, ID_EX_Rt) begin
        if(EX_MEM_RegWrite & EX_MEM_Rd == ID_EX_Rt & EX_MEM_Rd != 5'b00000) forwardB = 2'b01; //FWD srcB : MEM to EX
        else if (MEM_WB_RegWrite & MEM_WB_Rd == ID_EX_Rt & MEM_WB_Rd != 5'b00000) forwardB = 2'b10; //FWD srcb : WB to EX
        else forwardB = 2'b00;
    end

endmodule
