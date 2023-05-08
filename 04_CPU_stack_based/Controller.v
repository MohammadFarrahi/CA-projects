module Controller(clk,rst,upcode,stack_empty, PCsrc,PCWrite,PCWriteCond, AdSelect,MemRead,MemWrite,
                dinSel,push,pop,tos, IRwrite, ALUsrcA,ALUsrcB,ALUcontrol);
    
    input clk, rst, stack_empty; input [2:0] upcode;
    output reg PCsrc,PCWrite,PCWriteCond, AdSelect,MemRead,MemWrite, IRwrite;
    output reg [1:0] dinSel, ALUsrcA,ALUcontrol;
    output reg push,pop,tos, ALUsrcB;

    reg [3:0] ps, ns;
    localparam [3:0] IF = 0, ID = 1, ADD = 2, SUB = 3, AND = 4, NOT = 5,
            ARETH_PUSH = 6, PUSH1 = 7, PUSH2 = 8, POP = 9,
            JMP = 10, JZ = 11;

    always @(posedge clk, posedge rst) begin
        if(rst) ps <= IF;
        else ps <= ns;
    end 
    always @(ps, upcode) begin
        ns = 4'd0;
        case(ps)
            IF: ns = ID;
            ID: begin
                case(upcode)
                    3'b000: ns = ADD;
                    3'b001: ns = SUB;
                    3'b010: ns = AND;
                    3'b011: ns = NOT;
                    3'b100: ns = PUSH1;
                    3'b101: ns = POP;
                    3'b110: ns = JMP;
                    3'b111: ns = JZ;
                endcase
            end
            ADD: ns = ARETH_PUSH;
            SUB: ns = ARETH_PUSH;
            AND: ns = ARETH_PUSH;
            NOT: ns = ARETH_PUSH;
            ARETH_PUSH: ns = IF;
            PUSH1: ns = PUSH2;
            PUSH2: ns = IF;
            POP: ns = IF;
            JMP: ns = IF;
            JZ: ns = IF;
        endcase
    end
    reg e_flag, flag_en;
    always @(ps, upcode) begin
        {PCsrc,PCWrite,PCWriteCond,AdSelect,MemRead,MemWrite,dinSel,ALUsrcA,ALUcontrol,push,pop,tos,ALUsrcB,IRwrite,flag_en} = 18'd0;
        case(ps)
            IF: {pop,ALUsrcB,ALUsrcA,ALUcontrol,PCsrc,PCWrite,AdSelect,MemRead,IRwrite,flag_en} = 12'b10_10_00_010111;
            ID: tos = 1'b1;
            ADD: {pop,ALUsrcB,ALUsrcA,ALUcontrol} = 6'b11_00_00;
            SUB: {pop,ALUsrcB,ALUsrcA,ALUcontrol} = 6'b11_00_01;
            AND: {pop,ALUsrcB,ALUsrcA,ALUcontrol} = 6'b11_00_10;
            NOT: {ALUsrcB,ALUcontrol} = 3'b0_11;
            ARETH_PUSH: {push,dinSel} = 3'b1_01;
            PUSH1: begin {dinSel,AdSelect,MemRead} = 4'b10_11; push = ~e_flag; end
            PUSH2: {push,dinSel} = 3'b1_00;
            POP: {MemWrite,AdSelect} = 2'b11;
            JMP: begin {dinSel,PCsrc,PCWrite} = 4'b10_11; push = ~e_flag; end
            JZ: begin {dinSel,PCWriteCond,ALUsrcB,ALUsrcA,ALUcontrol,PCsrc} = 9'b10_11_01_00_1; push = ~e_flag; end
        endcase
    end
    always @(posedge clk, posedge rst) begin
        if(rst) e_flag <= 1'b0;
        else if(flag_en) e_flag <= stack_empty;        
    end

endmodule