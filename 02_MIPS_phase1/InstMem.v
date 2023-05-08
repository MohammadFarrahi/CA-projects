module InstMem #(parameter MEM_INIT_FILE = "Instructions.txt") (Addr, Instruction);
    input [31:0] Addr;
    output [31:0] Instruction;

    reg [31:0] Mem [0 : 2**15-1];
    initial $readmemb(MEM_INIT_FILE, Mem);

    assign Instruction = Mem[Addr[31:2]];
endmodule
