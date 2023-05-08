module inst_data_mem #(parameter MEM_INIT_FILE = "Data.txt") (clk, rst, memread, memwrite, Address, WriteData, ReadData);
    input clk, rst, memread, memwrite;
    input [4:0] Address;
    input [7:0] WriteData;
    output [7:0] ReadData;

    reg [7:0] mem [0 : 31];
    initial $readmemb(MEM_INIT_FILE, mem);
    assign ReadData = (memread & ~rst) ? mem[Address] : 8'd0;

    always @(posedge clk) begin
        if(memwrite & ~rst) mem[Address] <= WriteData;
    end
endmodule
