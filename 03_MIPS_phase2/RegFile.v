module RegFile #(parameter AddrL = 5, WL = 32) (clk, rst, regwrite, ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2);
    input clk, rst, regwrite;
    input [AddrL - 1:0] ReadReg1, ReadReg2, WriteReg;
    input [WL-1:0] WriteData;
    output [WL-1:0] ReadData1, ReadData2;

    reg [WL-1:0] RF [1:(2**AddrL)-1];

    assign ReadData1 = (ReadReg1 ==  AddrL'('d0) | rst) ? WL'('d0) : RF[ReadReg1];
    assign ReadData2 = (ReadReg2 == AddrL'('d0) | rst) ? WL'('d0) : RF[ReadReg2];

    always @(negedge clk) begin
        if(regwrite & ~rst) RF[WriteReg] <= WriteData;
    end
endmodule
