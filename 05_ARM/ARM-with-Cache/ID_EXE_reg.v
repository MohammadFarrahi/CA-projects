module ID_EXE_reg (
  input clk, rst, flush,
  input wb_en, memory_r_en, memory_w_en,
  input b, s,
  input [3:0] cmd_exe,
  input [31:0] PC_in,
  input [31:0] val_rn, val_rm,
  input imm,
  input [11:0] shift_operand,
  input [23:0] signed_imm_24,
  input [3:0] dest,
  input c_in,
  input[3:0] src_1_i,
  input[3:0] src_2_i,
  input freeze_in,

  output reg[3:0] src_1_o,
  output reg[3:0] src_2_o,
  output reg c_out,
  output reg wb_en_out,
  output reg mem_r_en_out,
  output reg mem_w_en_out,
  output reg b_out,
  output reg s_out,
  output reg [3:0] exe_cmd_out,
  output reg [31:0] PC,
  output reg [31:0] val_rn_out,
  output reg [31:0] val_rm_out,
  output reg imm_out,
  output reg [11:0] shift_operand_out,
  output reg [23:0] signed_imm_24_out,
  output reg [3:0] dest_out
);
always @(posedge clk) begin
  if(rst) begin
    exe_cmd_out <= 0;
    b_out <= 0;
    s_out <= 0;
    PC <= 0;
    val_rn_out <= 0;
    val_rm_out <= 0;
    shift_operand_out <= 0;
    imm_out <= 0;
    signed_imm_24_out <= 0;
    dest_out <= 0;
    c_out <= 0;
    src_1_o <= 0;
    src_2_o <= 0;
    wb_en_out<=0;
    mem_r_en_out <= 0;
    mem_w_en_out <= 0;
  end
  else if(flush & ~freeze_in) begin
    exe_cmd_out <= 0;
    b_out <= 0;
    s_out <= 0;
    PC <= 0;
    val_rn_out <= 0;
    val_rm_out <= 0;
    shift_operand_out <= 0;
    imm_out <= 0;
    signed_imm_24_out <= 0;
    dest_out <= 0;
    c_out <= 0;
    src_1_o <= 0;
    src_2_o <= 0;
    wb_en_out<=0;
    mem_r_en_out <= 0;
    mem_w_en_out <= 0;
  end
  else if(~freeze_in) begin
    src_2_o <= src_2_i;
    src_1_o <= src_1_i;
    wb_en_out<= wb_en;
    mem_r_en_out <= memory_r_en;
    mem_w_en_out <= memory_w_en;
    exe_cmd_out <= cmd_exe;
    b_out <= b;
    s_out <= s;
    PC <= PC_in;
    val_rn_out <= val_rn;
    val_rm_out <= val_rm;
    shift_operand_out <= shift_operand;
    imm_out <= imm;
    signed_imm_24_out <= signed_imm_24;
    dest_out <= dest;
    c_out <= c_in;
  end
end
endmodule
