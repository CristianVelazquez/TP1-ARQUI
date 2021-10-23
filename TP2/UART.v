`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2021 13:27:11
// Design Name: 
// Module Name: UART
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


module UART
#( 
    parameter                  NB_DATA     = 9,       //Numero de bits del dato
    parameter                  SB_TICK     = 16,       //Numero de Ticks que dura un bit  
    parameter                  BAUD_RATE   = 9600,
    parameter                  CLK_FREC    = 50000000 // 50 MHz
)
(
    // INPUTS
    input wire                  i_clk,
    input wire                  i_reset,
    
    //Input TX
    input wire                  i_tx_start,           //Habilita el comienzo de transmision
    input wire [NB_DATA-1:0]    i_data_tx,            //Dato en paralelo a transmitir
    //Input RX
    input wire                  i_rx,                 //Cable de recepcion de la informacion serial 


    // OUTPUTS
    //Output TX
    output wire                 o_tx_done_tick,       //Aviso de finalizacion de la transmision
    output wire                 o_tx,                 //Wire de transmisión
    //Output RX
    output wire                 o_rx_done_tick,       //Aviso de finalizacion de recepcion
    output wire [NB_DATA-1:0]   o_data_rx             //Dato recibido, mostrado en paralelo
);




    wire                        tick;               //Ticks de entrada del baudGen
    
    reg [2:0]                   state_reg,      state_next;         //
    reg [3:0]                   tickCounter_reg,tickCounter_next;   // Contador de ticks del baudGen
    reg [3:0]                   bitCounter_reg, bitCounter_next;    // Contador de bits transmitidos
    reg [NB_DATA-1:0]           buffer_reg,     buffer_next;        // Buffer de datos a transmitir
    reg                         tx_reg,         tx_next;            //
    //reg                         o_tx_done_tick_reg, o_tx_done_tick_next;
    
    
    
    baudGen#
    (.BAUD_RATE(BAUD_RATE), .CLK_FREC(CLK_FREC))
    u_baudGen
    (.clk(i_clk),.tick(tick));


    TX#
    (
        .NB_DATA(NB_DATA), 
        .SB_TICK(SB_TICK))
    u_TX
    (
        .i_clk      (i_clk),
        .i_reset    (i_reset),
        .i_tx_start (i_tx_start),
        .i_tick     (tick),
        .i_data     (i_data_tx),
        .o_tx_done_tick(o_tx_done_tick),
        .o_tx       (o_tx));
    
    RX
    #(
        .NB_DATA      (NB_DATA),
        .SB_TICK      (SB_TICK)
    )
    u_RX
    (
        .i_clk        (i_clk),
        .i_reset      (i_reset),
        .i_tick       (tick),
        .i_rx         (i_rx),
        .o_rx_done_tick(o_rx_done_tick),
        .o_data       (o_data_rx)
    );
    
            
endmodule
