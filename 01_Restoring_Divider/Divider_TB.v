`timescale 1ns/1ns
module Divider_TB;
reg clk = 1'b0;
reg rst = 1'b0;
reg start= 1'b0;
reg [5:0]In_bus = 6'b000000;
wire [5:0]Q_bus;
wire [5:0]R_bus;
wire done;

Divider DUT(.clk(clk), .rst(rst), .start(start), .In_bus(In_bus), .Q_bus(Q_bus), .R_bus(R_bus), .done(done));
always #10 clk = ~clk;
initial begin
#1;
rst = 1'b1;
#5;
rst = 1'b0;
start = 1'b1;
#20;
start = 1'b0;

					//Test1
// dividend1 = 678
In_bus = 6'b001010;
#20;
In_bus = 6'b100110;
#20;
// divisor1 = 20
In_bus = 6'b010100;
#480;
//Q = 33 , A = 18


					//Test2
start = 1'b1;
#20;
start = 1'b0;
// dividend2 = 593
In_bus = 6'b001001;
#20;
In_bus = 6'b010001;
#20;
// divisor2 = 31
In_bus = 6'b011111;
#480;
//Q = 19 , A = 4


					//Test3
start = 1'b1;
#20;
start = 1'b0;
// dividend3 = 822
In_bus = 6'b001100;
#20;
In_bus = 6'b110110;
#20;
// divisor3 = 15
In_bus = 6'b001111;
#480;
//Q = 54 , A = 12


					//Test4
start = 1'b1;
#20;
start = 1'b0;
// dividend4 = 1357
In_bus = 6'b010101;
#20;
In_bus = 6'b001101;
#20;
// divisor4 = 22
In_bus = 6'b010110;
#480;
//Q = 61 , A = 15


					//Test5
start = 1'b1;
#20;
start = 1'b0;
// dividend5 = 976
In_bus = 6'b001111;
#20;
In_bus = 6'b010000;
#20;
// divisor5 = 26
In_bus = 6'b011010;
#480;
//Q = 37 , A  = 14
$finish;
end
endmodule
