`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2021 16:16:22
// Design Name: 
// Module Name: tb_UART
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


module tb_UART();

localparam                  NB_DATA     = 9;        //Numero de bits del dato
localparam                  SB_TICK     = 16;       //Numero de Ticks que dura un bit  
localparam                  BAUD_RATE   = 9600;
localparam                  CLK_FREC    = 50000000; // 50 MHz
localparam                  RESULTADO   = 9'b001101111;
localparam                  RESULTADO2  = 9'b111111111;

// INPUTS
reg     i_clk;
reg     i_reset;
//Input TX
reg     i_tx_start;       
reg [NB_DATA-1:0]   i_data_tx;
//Input RX
wire    cable_tx1_to_rx2; 
wire    cable_tx2_to_rx1; 

// OUTPUTS
//Output TX
wire    o_tx_done_tick1;
wire    o_tx_done_tick2;
wire    o_tx;          
//Output RX
wire    o_rx_done_tick1;
wire    o_rx_done_tick2;
wire [NB_DATA-1:0]   o_data_rx1;
wire [NB_DATA-1:0]   o_data_rx2;


initial begin
    //$dumpfile("dump.vcd"); $dumpvars;
    i_clk       = 1'b0;
    i_reset     = 1'b1;
    i_tx_start  = 1'b0;
    //o_rx_done_tick1 = 1'b0;
    //o_rx_done_tick2 = 1'b0;
    //o_tx_done_tick1 = 1'b0;
    //o_tx_done_tick2 = 1'b0;
    i_data_tx   = RESULTADO;  //data de transmision = 6F
    
    #20
    i_reset     = 1'b0;
    
    
    #40
    i_tx_start  = 1'b1;
    
    
    #1101870
    i_data_tx = RESULTADO2;
    
    #1147520 //#60000000
    i_clk     = 1'b0;


    
    $finish;
end

UART
#( 
    .NB_DATA(NB_DATA),       //Numero de bits del dato
    .SB_TICK(SB_TICK),       //Numero de Ticks que dura un bit  
    .BAUD_RATE(BAUD_RATE),
    .CLK_FREC(CLK_FREC)      // 50 MHz
)
u_UART1
(
    // INPUTS
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_tx_start(i_tx_start),
    .i_data_tx(i_data_tx),
    .i_rx(cable_tx2_to_rx1),
    
    // OUTPUTS
    .o_tx_done_tick(o_tx_done_tick1),
    .o_tx(cable_tx1_to_rx2),
    .o_rx_done_tick(o_rx_done_tick1),
    .o_data_rx(o_data_rx1)
);


UART
#( 
    .NB_DATA(NB_DATA),       //Numero de bits del dato
    .SB_TICK(SB_TICK),       //Numero de Ticks que dura un bit  
    .BAUD_RATE(BAUD_RATE),
    .CLK_FREC(CLK_FREC)      // 50 MHz
)
u_UART2
(
    // INPUTS
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_tx_start(i_tx_start),
    .i_data_tx(i_data_tx),
    .i_rx(cable_tx1_to_rx2),
    
    // OUTPUTS
    .o_tx_done_tick(o_tx_done_tick2),
    .o_tx(cable_tx2_to_rx1),
    .o_rx_done_tick(o_rx_done_tick2),
    .o_data_rx(o_data_rx2)
);



   

always #10 i_clk = ~i_clk;

always  @(posedge o_rx_done_tick2, posedge o_rx_done_tick1) begin
    if(RESULTADO == o_data_rx1 || RESULTADO2 == o_data_rx1)
        $display("############# Test RX1 OK ############");
    if(RESULTADO == o_data_rx2 || RESULTADO2 == o_data_rx2)
        $display("############# Test RX2 OK ############");
    else 
        $display("############# Test Fail ############");
        
        
    //$finish();
 end


endmodule