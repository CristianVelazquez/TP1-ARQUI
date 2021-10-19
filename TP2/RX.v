`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2021 17:15:42
// Design Name: 
// Module Name: TX
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


module RX
#( 
    parameter                  NB_DATA     = 8,       // Numero de bits del dato
    parameter                  SB_TICK     = 16       // Ticks for stop bits  
)
(
    // INPUTS
    input wire                  i_clk,
    input wire                  i_reset,
    input wire                  i_rx,
    input wire                  i_tick,                // Entrada de BRGenerator
    
    // OUTPUTS
    output reg                  o_rx_done_tick,
    output wire [NB_DATA-1:0]   o_data
);

    // LOCAL_PARAMETERS
    localparam                  IDLE        = 4'b0001;
    localparam                  START       = 4'b0010;
    localparam                  DATA        = 4'b0100;
    localparam                  STOP        = 4'b1000;
    
    // INTERNAL
    reg         [3:0]           state_reg   = IDLE;
    reg         [3:0]           state_next  = START;
    reg         [3:0]           tickCounter_reg, tickCounter_next;         // Contador s: TickCounter (del BRGenerator)
    reg         [2:0]           bitCounter_reg, bitCounter_next;         // Contador n: mantiene la cuenta de los bits recibidos
    reg         [NB_DATA:0]     buffer_reg, buffer_next;

    // MEMORY
    always @(posedge i_clk, posedge i_reset) begin
        if (i_reset)  begin  
            state_reg       <= IDLE;  
            tickCounter_reg <= 0;  
            bitCounter_reg  <= 0;  
            buffer_reg      <= 0;  
        end 
        else begin  
            state_reg       <= state_next;
            tickCounter_reg <= tickCounter_next;  
            bitCounter_reg  <= bitCounter_next;  
            buffer_reg      <= buffer_next;  
        end 
    end

    always @(*) begin    
        state_next = state_reg;
        o_rx_done_tick = 1'b0;                          // Reseteo el flag DONE (valid).
        tickCounter_next = tickCounter_reg;
        bitCounter_next = bitCounter_reg;
        buffer_next = buffer_reg;
    
        case(state_reg)
            IDLE:                                       // IDLE_STATE:
                if(i_rx == 1'b0) begin                  // Verifico si llega el bit de START
                    state_next = START;                 // Paso al siguiente estado
                    tickCounter_next = 4'b0000;                   // Reinicio TickCounter
                end

            START:                                      // START_STATE:
                if(i_tick == 1)                         // Entro cada vez que llega un tick del BRGenerator
                    if(tickCounter_reg == (NB_DATA-1)) begin      // Si es igual a 7, la se?al de entrada esta en el punto ->
                        state_next = DATA;              // medio del bit de START. Paso al sig. estado START.
                        tickCounter_next = 4'b0000;               // Reinicio TickCounter
                        bitCounter_next = 4'b000;                // Reinicio el contador de bits recibidos
                    end    
                    else                                // En caso de que TickCounter no haya llegado a '7'      ->
                        tickCounter_next = tickCounter_reg + 1;             // lo incremento. (Para que se ubique a la mitad del bit)
                        
            DATA:                                       // DATA_STATE:
                if(i_tick == 1)                         // Entro cada vez que llega un tick del BRGenerator
                    if(tickCounter_reg == (SB_TICK-1)) begin      // Si es igual a 15 la se?al de entrada esta en el punto ->
                        tickCounter_next = 4'b0000;               // medio del primer bit de datos. Reinicio TickCounter y ->
                        buffer_next = {i_rx, buffer_reg[NB_DATA-1 : 1]}; // y almaceno el dato de entrada en un shift-reg. 
                        if(bitCounter_reg == (NB_DATA-1))        // Si es igual a 7 es porque ya recibi todos los bits de ->
                            state_next = STOP;          // datos, por lo que paso al estado de STOP.
                        else                            // En caso que no haya llegado, incremento el contador de->
                            bitCounter_next = bitCounter_reg + 1;         // bits recibidos.
                        end
                    else                                // En caso de que TickCounter no haya llegado a '15'     ->
                        tickCounter_next = tickCounter_reg + 1;             // lo incremento. (Para que se ubique a la mitad del bit)

            STOP:                                       // STOP_STATE:
                if(i_tick == 1)                         // Entro cada vez que llega un tick del BRGenerator
                    if(tickCounter_reg == (SB_TICK-1)) begin      // Si es igual a 15 la se?al de entrada esta en el punto ->
                        state_next = IDLE;              // medio del bit de STOP. Paso al estado IDLE.
                        o_rx_done_tick = 1'b1;          // Pongo el alto el flag DONE.
                    end
                    else                                // En caso de que TickCounter no haya llegado a '15'     ->
                        tickCounter_next = tickCounter_reg + 1;             // lo incremento. (Para que se ubique a la mitad del bit)
                        
            default : begin                             // DEFAULT: Fault Recovery
                state_next       = IDLE;                      // Vuelvo al estado IDLE.
                tickCounter_next =0;                               // Reinicio TickCounter.
                bitCounter_next  =0;                               // Reinicio contador de bits recibidos.
                buffer_next      =0;                               // Reinicio buffer de datos recibidos.
            end                 
        endcase
    end
    
    // OUTPUT
    assign o_data = buffer_reg;                              // Asigno el buffer de datos recibidos a la salida

endmodule