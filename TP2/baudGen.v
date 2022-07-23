`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date: 15.10.2021 10:21:56
// Design Name: 
// Module Name: uart
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


module baudGen
#(
    parameter BAUD_RATE = 9600,  //300,600,1200,2400,4800,9600,14400,19200,38400,57600
    parameter CLK_FREC = 50000000
)
(
    input wire clk,
    output wire tick
);

localparam RESULTADO = CLK_FREC/(BAUD_RATE*16);     //Para 9600 da 325


reg [15:0] contador=0;
reg salida;

assign tick = salida;



always@(posedge clk) begin: r_baudRate
    
    if(contador == RESULTADO) begin
        contador <= 0;
    end
    else begin
        contador <= contador + 1;
    end
    
    
    salida <= (contador == RESULTADO); //Solo larga el tick por un clock
    
    //Larga el tick como onda cuadrada
    //if (contador == RESULTADO/2) begin
    //    salida = 0;
    //end
    
end


//salida = (contador == RESULTADO); //Solo larga el tick por un clock
//assign o_tick = (contador == RESULTADO); //Solo larga el tick por un clock

endmodule