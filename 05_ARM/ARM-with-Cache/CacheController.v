module CacheController (
  input clk,
  input rst,
  
  input wr_en,
  input rd_en,
  input[31:0] address,
  input[31:0] writeData,
  output[31:0] readData,
  output ready,
  
  inout[15:0] SRAM_DQ,
  output[17:0] SRAM_ADDR,
  output SRAM_UB_N,
  output SRAM_LB_N,
  output SRAM_WE_N,
  output SRAM_CE_N,
  output SRAM_OE_N
);
  wire [31:0] temp_adr;
  wire [31:0] dataOut,data1,data0;
  integer i; 
  wire hit, hit0, hit1, cmp1, cmp0;
  reg [0:63] LRU, v0, v1;
  reg [9:0] tag0 [0:63];
  reg [9:0] tag1 [0:63];
  reg [31:0] data0A [0:63];
  reg [31:0] data0B [0:63];
  reg [31:0] data1A [0:63];
  reg [31:0] data1B [0:63];

  wire sram_ready;
  wire [63:0] sram_read_data;
  
  assign temp_adr = address - 32'd1024;

  assign cmp0 = (tag0[temp_adr[8:3]] == temp_adr[18:9]);
  assign hit0 = cmp0 && v0[temp_adr[8:3]];
  assign cmp1 = (tag1[temp_adr[8:3]] == temp_adr[18:9]);
  assign hit1 = cmp1 && v1[temp_adr[8:3]];
  assign hit = hit0 | hit1;
  assign data0 = temp_adr[2] ? data0B[temp_adr[8:3]] : data0A[temp_adr[8:3]];
  assign data1 = temp_adr[2] ? data1B[temp_adr[8:3]] : data1A[temp_adr[8:3]];
  assign dataOut = hit0 ? data0 : data1;

  assign readData = hit ? dataOut : temp_adr[2] ? sram_read_data[63:32] : sram_read_data[31:0];
  assign ready = sram_ready | (hit & ~wr_en) | (wr_en == rd_en);
   
  SramController sram_controller (
    .clk(clk),
    .rst(rst),

    .wr_en(wr_en),
    .rd_en(rd_en & ~hit),
    .address(address),
    .write_data(writeData),
    .read_data(sram_read_data),
    .ready(sram_ready),
    
    .SRAM_DQ(SRAM_DQ),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_UB_N(SRAM_UB_N),
    .SRAM_LB_N(SRAM_LB_N),
    .SRAM_WE_N(SRAM_WE_N),
    .SRAM_CE_N(SRAM_CE_N),
    .SRAM_OE_N(SRAM_OE_N)
  );
    
  always@(posedge clk, posedge rst)begin
    if(rst)begin
      for(i = 0; i < 64; i = i+1)begin
        v0[i]<= 0;
        v1[i]<= 0;
        tag0[i]<= 0;
        tag1[i]<= 0;
        LRU[i] <= 0;
        data0A[i] <= 32'b0;
        data1A[i] <= 32'b0;
        data0B[i] <= 32'b0;
        data1B[i] <= 32'b0;
      end
    end
    else if(wr_en & hit & sram_ready)
      if(hit0)
        v0[temp_adr[8:3]] <= 0;
      else
        v1[temp_adr[8:3]] <= 0;
    else if(~hit & rd_en & sram_ready)begin
      if(v0[temp_adr[8:3]]==1 && v1[temp_adr[8:3]]==1)begin
        if(LRU[temp_adr[8:3]])begin
          LRU[temp_adr[8:3]] <= 1'b0;
          data0A[temp_adr[8:3]] <= sram_read_data[31:0];
          data0B[temp_adr[8:3]] <= sram_read_data[63:32];
          tag0[temp_adr[8:3]] <= temp_adr[18:9];
        end
        else begin
          LRU[temp_adr[8:3]] <= 1'b1;
          data1A[temp_adr[8:3]] <= sram_read_data[31:0];
          data1B[temp_adr[8:3]] <= sram_read_data[63:32];
          tag1[temp_adr[8:3]] <= temp_adr[18:9];
        end
      end
      else if(v0[temp_adr[8:3]]==0 && v1[temp_adr[8:3]]==1)begin
        LRU[temp_adr[8:3]] <= 1'b0;
        data0A[temp_adr[8:3]] <= sram_read_data[31:0];
        data0B[temp_adr[8:3]] <= sram_read_data[63:32];
        tag0[temp_adr[8:3]] <= temp_adr[18:9];
        v0[temp_adr[8:3]]<=1'b1;
      end
      else if(v0[temp_adr[8:3]]==1 && v1[temp_adr[8:3]]==0)begin
        LRU[temp_adr[8:3]] <= 1'b1;
        data1A[temp_adr[8:3]] <= sram_read_data[31:0];
        data1B[temp_adr[8:3]] <= sram_read_data[63:32];
        tag1[temp_adr[8:3]] <= temp_adr[18:9];
        v1[temp_adr[8:3]]<=1'b1;
      end
      else begin
        LRU[temp_adr[8:3]] <= 1'b0;
        data0A[temp_adr[8:3]] <=  sram_read_data[31:0];
        data0B[temp_adr[8:3]] <= sram_read_data[63:32];
        tag0[temp_adr[8:3]] <= temp_adr[18:9];
        v0[temp_adr[8:3]]<= 1'b1;
      end
    end
    else if (hit & rd_en) begin
      LRU[temp_adr[8:3]] <= hit0 ? 1'b0 : 1'b1;
    end
  end

endmodule