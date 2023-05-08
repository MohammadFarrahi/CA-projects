module Val2Generator (
  input [31:0]val_rm,
  input [11:0]shift_operand,
  input imm,
  input or_out,
  output reg[31:0] val2
);


  reg[63:0] temp_data;
  reg[63:0] shift_temp;
  wire[4:0] rotate_imm_mul2;
  assign rotate_imm_mul2 = (shift_operand[11:8] << 1);

  always @(*) begin
    temp_data = 64'd0;
    shift_temp = 64'd0;
    val2 = 32'd0;
    if(or_out == 1) begin
      val2 = {{20{shift_operand[11]}},shift_operand};
    end
    else if(imm == 1) begin
      val2 = {{24{1'b0}},shift_operand[7:0]};
      temp_data[63:32] = val2;
      shift_temp = temp_data >> rotate_imm_mul2;
      val2 = (shift_temp[63:32] | shift_temp[31:0]);
    end
    else if(imm == 0 && shift_operand[4] == 0) begin
      case(shift_operand[6:5])
        2'b00: val2 = val_rm << (shift_operand[11:7]);
        2'b01: val2 = val_rm >> (shift_operand[11:7]);
        2'b10: val2 = val_rm >>> (shift_operand[11:7]);
        2'b11: begin
          temp_data[63:32] = val_rm;
          shift_temp = temp_data >> shift_operand[11:7];
          val2 = (shift_temp[63:32] | shift_temp[31:0]);
        end
      endcase
    end
  end
endmodule 