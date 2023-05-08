module SramController (
  input clk,
  input rst,
  
  input wr_en,
  input rd_en,
  input[31:0] address,
  input[31:0] write_data,
  output[63:0] read_data,
  output ready,
  
  inout [15:0] SRAM_DQ,
  output [17:0] SRAM_ADDR,
  output SRAM_UB_N,
  output SRAM_LB_N,
  output SRAM_WE_N,
  output SRAM_CE_N,
  output SRAM_OE_N
);
  wire [15:0] Al_data, Ah_data, Bl_data, Bh_data;
  wire [31:0] temp_adr;
  reg data_sel; 
  reg [1:0] adr_bit;
  reg[3:0] pstate, nstate;
  reg ldAL, ldAH, ldBL ,ldBH;
  reg SRAM_WE;
  wire [15:0] data;
  
  assign temp_adr = address - 32'd1024;
  assign data = data_sel ? write_data[31:16] : write_data[15:0];
    

  Register16 regAL(
    .clk(clk),
    .rst(rst),
    .data_in(SRAM_DQ),
    .ld(ldAL),
    .data_out(Al_data)
  );
  Register16 regAH(
    .clk(clk),
    .rst(rst),
    .data_in(SRAM_DQ),
    .ld(ldAH),
    .data_out(Ah_data)
  );
  Register16 regBL(
    .clk(clk),
    .rst(rst),
    .data_in(SRAM_DQ),
    .ld(ldBL),
    .data_out(Bl_data)
  );
  Register16 regBH(
    .clk(clk),
    .rst(rst),
    .data_in(SRAM_DQ),
    .ld(ldBH),
    .data_out(Bh_data)
  );
  
  always@(posedge clk,posedge rst)begin
    if(rst)
      pstate <= 4'b0000;
    else
      pstate <= nstate;
  end

  
  always@(wr_en, rd_en, address, write_data, pstate) begin
    case(pstate)
      4'b0000:begin
        if(wr_en)begin
          nstate = 4'b0101;
          ldAL=1'b0; 
          adr_bit=2'b00;
          ldAH=1'b0;
          data_sel= 1'b0;
          SRAM_WE = 1'b1;
          ldBL = 1'b0;
          ldBH =1'b0;
        end
        else if(rd_en)begin
          nstate = 4'b0001;
          ldAL=1'b0;
          adr_bit=2'b00;
          ldAH=1'b0;
          data_sel= 1'b0;
          SRAM_WE = 1'b1;
          ldBL = 1'b0;
          ldBH =1'b0;
        end
        else begin
          nstate = 4'b0000;
          ldAL=1'b0; 
          adr_bit=2'b00;
          ldAH=1'b0;
          data_sel= 1'b0;
          SRAM_WE = 1'b1;
          ldBL = 1'b0;
          ldBH =1'b0;
        end
      end
      // reading
      4'b0001:begin
        nstate = 4'b0010;
        adr_bit=2'b00;
        ldAL=1'b1; 
        ldAH=1'b0;
        data_sel= 1'b0;
        SRAM_WE = 1'b1;
        ldBL=1'b0; 
        ldBH=1'b0;
      end      
      4'b0010:begin
        nstate = 4'b0011;
        adr_bit=2'b01;
        ldAL=1'b0; 
        ldAH=1'b1;
        data_sel= 1'b0;
        SRAM_WE = 1'b1;
        ldBL=1'b0; 
        ldBH=1'b0;
      end
      4'b0011:begin
        nstate = 4'b0100;
        adr_bit=2'b10;
        ldAL=1'b0;
        ldAH=1'b0;
        ldBL=1'b1; 
        ldBH=1'b0;
        data_sel= 1'b0;
        SRAM_WE = 1'b1;
      end
      4'b0100:begin
        nstate = 4'b1001;
        adr_bit=2'b11;
        ldAL=1'b0; 
        ldAH=1'b0;
        ldBL=1'b0; 
        ldBH=1'b1;
        data_sel= 1'b0;
        SRAM_WE = 1'b1;
      end
      //writing
      4'b0101:begin
        nstate = 4'b0110;
        data_sel= 1'b0;
        SRAM_WE = 1'b0;
        adr_bit=2'b00;
        ldAL=1'b0; 
        ldAH=1'b0;   
        ldBL=1'b0; 
        ldBH=1'b0;       
      end
      4'b0110:begin
        nstate = 4'b0111;
        data_sel = 1'b1; 
        SRAM_WE = 1'b0;
        adr_bit=2'b01;    
        ldAL=1'b0; 
        ldAH=1'b0;
        ldBL=1'b0; 
        ldBH=1'b0;
      end
      4'b0111:begin
        nstate = 4'b1000;
        ldAL=1'b0; 
        adr_bit=2'b00;
        ldAH=1'b0;
        data_sel= 1'b0;
        SRAM_WE = 1'b1; 
        ldBL=1'b0; 
        ldBH=1'b0;   
      end
      4'b1000:begin
        nstate = 4'b1001;
        ldAL=1'b0; 
        adr_bit=2'b00;
        ldAH=1'b0;
        data_sel= 1'b0;
        SRAM_WE = 1'b1; 
        ldBL=1'b0; 
        ldBH=1'b0;
      end
      // sixth clk
      4'b1001:begin
        nstate = 4'b0000;
        ldAL=1'b0; 
        adr_bit=2'b00;
        ldAH=1'b0;
        data_sel= 1'b0;
        SRAM_WE = 1'b1;  
        ldBL=1'b0; 
        ldBH=1'b0;             
      end 
      default: begin
        nstate = 4'b0000;
        ldAL=1'b0; 
        adr_bit=2'b00;
        ldAH=1'b0;
        data_sel= 1'b0;
        SRAM_WE = 1'b1;
        ldBL = 1'b0;
        ldBH =1'b0;
      end
  endcase
end
  assign read_data = {Bh_data,Bl_data,Ah_data,Al_data};
  assign ready = (pstate == 4'b1001);
  assign SRAM_DQ = rd_en ? 16'bz : data;
  assign SRAM_ADDR = rd_en ? {temp_adr[18:3],adr_bit} : {temp_adr[18:2],adr_bit[0]};
  assign SRAM_UB_N = 1'b0;
  assign SRAM_LB_N = 1'b0;
  assign SRAM_CE_N = 1'b0;
  assign SRAM_OE_N = 1'b0;
  assign SRAM_WE_N = SRAM_WE;
endmodule