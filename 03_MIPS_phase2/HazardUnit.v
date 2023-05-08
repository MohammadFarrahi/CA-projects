module HazardUnit(  
                    hazard_en,cond_hazard,
                    ID_EX_Rd,ID_EX_MemRead,ID_EX_RegWtrite,
                    EX_MEM_Rd,EX_MEM_RegWrite,
                    IF_ID_Rs,IF_ID_Rt,
                    IF_ID_Write,PC_Write,Inst_src
                );
    input hazard_en,cond_hazard;
    input ID_EX_MemRead,ID_EX_RegWtrite,EX_MEM_RegWrite;
    input [4:0] ID_EX_Rd,EX_MEM_Rd,IF_ID_Rs,IF_ID_Rt;
    output reg IF_ID_Write,PC_Write,Inst_src;

    always @(hazard_en,cond_hazard,
            ID_EX_Rd,ID_EX_MemRead,ID_EX_RegWtrite,
            EX_MEM_Rd,EX_MEM_RegWrite,
            IF_ID_Rs,IF_ID_Rt)
    begin
        {IF_ID_Write, PC_Write, Inst_src} = 3'b111;
        if(hazard_en) begin // if the inst before lw or R_type or immidiate is not : j or jal
            if(cond_hazard) begin //if the inst before them is : jr or beq or bne
                if((ID_EX_MemRead | ID_EX_RegWtrite) & (ID_EX_Rd == IF_ID_Rs | ID_EX_Rd == IF_ID_Rt) & ID_EX_Rd != 5'b0000)
                    {IF_ID_Write, PC_Write, Inst_src} = 3'b000;
                else if(EX_MEM_RegWrite & (EX_MEM_Rd == IF_ID_Rs | EX_MEM_Rd == IF_ID_Rt) & EX_MEM_Rd != 5'b0000)
                    {IF_ID_Write, PC_Write, Inst_src} = 3'b000;
            end
            else begin  //if not
                if(ID_EX_MemRead & (ID_EX_Rd == IF_ID_Rs | ID_EX_Rd == IF_ID_Rt) & ID_EX_Rd != 5'b0000)
                    {IF_ID_Write, PC_Write, Inst_src} = 3'b000;
            end
        end
    end
endmodule
