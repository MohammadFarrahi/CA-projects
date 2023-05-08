module IF_stage #(parameter INSTRUCTION_MEM_FILE = "instruction_mem.txt") (
  input clk,
  input rst,
  input freeze,
  input branch_taken,
  input [31:0] branch_addr,
  
  output [31:0] PC,
  output [31:0] instruction
);
  // internal wires
  wire [31:0] mux_out;
  reg [31:0] pc_reg_out;

  // mux
  assign mux_out = branch_taken ? branch_addr : PC;
  // pc register
  always @(posedge clk, posedge rst) begin
		if (rst)
			pc_reg_out <= 32'd0;
		else if(~freeze)
			pc_reg_out <= mux_out;
	end
  // adder
  assign PC = pc_reg_out + 32'd1;
  // instruction memory
  reg[31:0] instruction_mem[0:2**10-1];
	initial begin
		$readmemb(INSTRUCTION_MEM_FILE, instruction_mem);
	end
  assign instruction = instruction_mem[pc_reg_out];
endmodule

