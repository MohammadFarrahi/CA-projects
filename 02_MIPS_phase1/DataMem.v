module DataMem #(parameter MEM_INIT_FILE = "Data.txt") (clk, rst, memread, memwrite, Address, WriteData, ReadData);
    input clk, rst, memread, memwrite;
    input [31:0] Address, WriteData;
    output [31:0] ReadData;

    reg [31:0] Mem [0 : 2**15-1];
    initial $readmemb(MEM_INIT_FILE, Mem);

    reg [31:0] data_to_read;
    always @(Address) begin
        data_to_read = 32'd0;
        case(Address[1:0])
            2'b00: data_to_read = Mem[Address[31:2]];
            2'b01: data_to_read = {Mem[Address[31:2]][31:8], 8'd0};
            2'b10: data_to_read = {Mem[Address[31:2]][31:16], 16'd0};
            2'b11: data_to_read = {Mem[Address[31:2]][31:24], 24'd0};
        endcase
    end

    assign ReadData = (memread & ~rst) ? data_to_read : 32'd0;
    always @(posedge clk) begin
        if(memwrite & ~rst) Mem[Address[31:2]] <= WriteData;
    end
endmodule