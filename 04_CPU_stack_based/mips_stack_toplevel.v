module mips_stack #(parameter DATA_MEM_INIT_FILE = "Data.txt") (clk, rst);
input clk, rst;

wire PCsrc, PCWrite, PCWriteCond, ALUsrcB, AdSelect, IRwrite, push, pop, tos, MemRead, MemWrite;
wire [1:0] dinSel, ALUsrcA, ALUcontrol;
wire stack_empty;
wire [2:0] opcode;

mips_stack_dp #(DATA_MEM_INIT_FILE) dp (.clk(clk), .rst(rst), .PCsrc(PCsrc), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .AdSelect(AdSelect), .dinSel(dinSel), .ALUsrcA(ALUsrcA), .ALUsrcB(ALUsrcB), .IRwrite(IRwrite), .push(push), .pop(pop), .tos(tos), .stack_empty(stack_empty), .MemRead(MemRead), .MemWrite(MemWrite), .opcode(opcode), .ALUcontrol(ALUcontrol));
Controller cu(.clk(clk), .rst(rst), .upcode(opcode), .stack_empty(stack_empty), .PCsrc(PCsrc), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .AdSelect(AdSelect), .MemRead(MemRead), .MemWrite(MemWrite), .dinSel(dinSel), .push(push), .pop(pop), .tos(tos), .IRwrite(IRwrite), .ALUsrcA(ALUsrcA), .ALUsrcB(ALUsrcB), .ALUcontrol(ALUcontrol));

endmodule