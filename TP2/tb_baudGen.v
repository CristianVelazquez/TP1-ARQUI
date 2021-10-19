`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2021 10:41:22
// Design Name: 
// Module Name: tb_baudGen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_baudGen();

//localparam  BAUD_RATE = 9600;  //300,600,1200,2400,4800,9600,14400,19200,38400,57600
localparam  BAUD_RATE = 80600;   //con 80600 debe dar un tick cada 38 clocks
localparam  CLK_FREC = 50000000; // 50 MHz
reg clk;
wire tick;


baudGen#
(.BAUD_RATE(BAUD_RATE), .CLK_FREC(CLK_FREC))
u_baudGen
(.clk(clk),.tick(tick));

initial begin
    //$dumpfile("dump.vcd"); $dumpvars;
    
    clk = 1'b1;
    //tick = 1'b0;

    #10000      //Solo dejo pasar el tiempo para el test
	clk = 1'b0;
	
    //$finish;
end
   

always #10 clk = ~clk;



endmodule