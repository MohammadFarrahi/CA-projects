module Mem (clk, rst, memread, memwrite, Address, WriteData, ReadData);
    input clk, rst, memread, memwrite;
    input [15:0] Address;
    input [7:0] WriteData;
    output [7:0] ReadData;

    reg [7:0] mem [0 : 2**16-1];

    assign ReadData = (memread & ~rst) ? mem[Address] : 8'd0;

    always @(posedge clk) begin
        if(memwrite & ~rst) mem[Address] <= WriteData;
    end
endmodule
