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


module tb_TX();

//Parametros del TX
localparam  NB_DATA     = 8;    //Cantidad de bits
localparam  SB_TICK     = 16;   //Numero de Ticks que dura un bit 
//Parametros del baudGen
//localparam  BAUD_RATE = 80600;   //con 80600 debe dar un tick cada 38 clocks
localparam  BAUD_RATE = 195312;  //con 195312 debe dar un tick cada 16 clocks    
localparam  CLK_FREC = 50000000; // 50 MHz

reg i_clk;
reg i_reset;
reg i_tx_start;
reg [NB_DATA-1:0] i_data;
reg [NB_DATA-1:0] salida_aux;

wire i_tick;
wire o_tx_done_tick;
wire o_tx;

//reg i_tick_sixteen_reg;
//wire i_tick_sixteen;
reg [3:0] counterTicks;
reg [3:0] counterBits;


baudGen#
(.BAUD_RATE(BAUD_RATE), .CLK_FREC(CLK_FREC))
u_baudGen
(.clk(i_clk),.tick(i_tick));


TX#
(.NB_DATA(NB_DATA), .SB_TICK(SB_TICK))
u_TX
(.i_clk(i_clk),.i_reset(i_reset),.i_tx_start(i_tx_start),.i_tick(i_tick),.i_data(i_data),.o_tx_done_tick(o_tx_done_tick),.o_tx(o_tx));

initial begin
    //$dumpfile("dump.vcd"); $dumpvars;
    i_clk       = 1'b0;
    i_reset     = 1'b1;
    i_data      = 8'b10111010;  //data = 3A
    i_tx_start  = 1'b0;
    salida_aux  = 8'b00000000;
    counterTicks= 4'b0000;
    counterBits= 4'b0000;
//    i_tick_sixteen_reg = 1'b0;

    #20
    i_reset     = 1'b0;
    
    
    #40
    i_tx_start  = 1'b1;
    
    
    #60000
    i_clk       = 1'b0;


    
    $finish;
end
   

always #10 i_clk = ~i_clk;


always @(posedge i_clk) begin
    if(i_tick) begin
        counterTicks = counterTicks + 1;
    end
    
    if (counterTicks == 0 && i_tick) begin
        salida_aux = salida_aux << 1;
        salida_aux[0] = o_tx;
//        counterBits = counterBits +1;
    end
    
//    if (counterBits == 11 && i_tick) begin
//        $finish();
//    end
end

always  @(posedge o_tx_done_tick) begin
    if (salida_aux == i_data) begin
        $display("**********Test Aceptado");
       // $finish();
    end
    else begin
        $display("**********Test Fallo");
        //$finish();
    end
end


//always @(posedge i_clk) begin 
//    if(counter != 16) begin
//        counter = counter + 1;
//        i_tick_sixteen_reg = 0;
//    end
//    else begin
//        counter = 0;
//        i_tick_sixteen_reg = 1;
//    end
//end 

//assign i_tick_sixteen = i_tick_sixteen_reg;


endmodule