`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2021 19:11:52
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


module TX
#( 
    parameter                  NB_DATA     = 9,       //Numero de bits del dato
    parameter                  SB_TICK     = 16       //Numero de Ticks que dura un bit  
)
(
    // INPUTS
    input wire                  i_clk,
    input wire                  i_reset,
    input wire                  i_tx_start,           //Habilita el comienzo de transmision
    input wire                  i_tick,               //Ticks de entrada del baudGen
    input wire [NB_DATA-1:0]    i_data,               //Dato en paralelo
    
    // OUTPUTS
    output reg                  o_tx_done_tick,       //Aviso de finalizacion de la transmision
    output wire                 o_tx                  //Wire de transmisión
);

    // LOCAL_PARAMETERS
    localparam                  IDLE        = 2'b00;
    localparam                  START       = 2'b01;
    localparam                  DATA        = 2'b10;
    localparam                  STOP        = 2'b11;
    
    reg [2:0]                   state_reg,      state_next;         //
    reg [3:0]                   tickCounter_reg,tickCounter_next;   // Contador de ticks del baudGen
    reg [3:0]                   bitCounter_reg, bitCounter_next;    // Contador de bits transmitidos
    reg [NB_DATA-1:0]           buffer_reg,     buffer_next;        // Buffer de datos a transmitir
    reg                         tx_reg,         tx_next;            //
    //reg                         o_tx_done_tick_reg, o_tx_done_tick_next;
    
    
    // Memoria
    always @(posedge i_clk, posedge i_reset) begin
        if (i_reset)  begin  
            state_reg       <= IDLE;  
            tickCounter_reg <= 0;  
            bitCounter_reg  <= 0;  
            buffer_reg      <= 0;  
            tx_reg          <= 1;
        end 
        else begin  
            state_reg       <= state_next;    ///Esto no puede traer problemas de concurrencia?
            tickCounter_reg <= tickCounter_next;  
            bitCounter_reg  <= bitCounter_next;  
            buffer_reg      <= buffer_next; 
            tx_reg          <= tx_next;   
        end 
    end



// Estados
always @(*) begin    
        state_next = state_reg;
        o_tx_done_tick = 1'b0;                          // Reseteo el flag DONE (valid).
        tickCounter_next = tickCounter_reg;
        bitCounter_next = bitCounter_reg;
        buffer_next = buffer_reg;
        tx_next = tx_reg;

     
        case(state_reg)
            IDLE: begin                                 // IDLE_STATE:
   //             o_tx_done_tick = 1'b0;                  // Reseteo el flag DONE (valid).
                tx_next = 1'b1;                         // Seteo tx_next=1 ya que no se envia nada
                if(i_tx_start) begin                    // Comienza a transmitir bit a bit cuando la se?al de    ->
                    state_next = START;                 // entrada i_tx_start = 1 y paso al estado START.
                    tickCounter_next = 4'b0000;         // Reinicio TickCounter.
                    buffer_next = i_data;               // Asigno el dato de entrada i_data a transmitir al buff ->
                end                                     // buffer de datos a transmitir
            end
                    
            START: begin                                // START_STATE:
                tx_next = 1'b0;                         // Seteo tx_next=0 para enviar el bit de START.
                if(i_tick)                              // Entro cada vez que llega un tick del BRGenerator.
                    if(tickCounter_reg == (SB_TICK-1)) begin      // Si es igual a 15 la se?al indica que se calibro.
                        tickCounter_next = 4'b0000;               // Reinicio TickCounter.
                        bitCounter_next = 4'b0000;                // Reinicio el contador de bits transmititdos.
                        state_next = DATA;              // Paso al estado DATA para comenzar a enviar bits
                    end
                    else                                // En caso de que TickCounter no haya llegado a '15'      ->
                        tickCounter_next = tickCounter_reg + 1;             // lo incremento. (Para calibrarlo)
            end     
                     
            DATA: begin                                 // DATA_STATE:
                tx_next = buffer_reg[0];                     // Seteo tx_next=LSB para enviar el bit bajo (D0 primero)
                if(i_tick)                              // Entro cada vez que llega un tick del BRGenerator.
                    if(tickCounter_reg == (SB_TICK-1)) begin      // Si es igual a 15 la se?al indica que se calibro.
                        tickCounter_next = 4'b0000;               // Reinicio TickCounter.
                        buffer_next = buffer_reg >> 1;            // Desplazo buffer_reg a la derecha y lo asigno a buffer_next.
                        if(bitCounter_reg == (NB_DATA - 1)) begin           // Si es igual a 8 es porque ya envie todos los bits de ->
                                bitCounter_next = 4'b0000;
                                state_next = STOP;      // datos, por lo que paso al estado de STOP.
                        end
                        else                            // En caso que no haya llegado, incremento el contador de->
                                bitCounter_next = bitCounter_reg + 1;     // bits recibidos.
                                
                    end
                    else                                // En caso de que TickCounter no haya llegado a '15'     ->
                        tickCounter_next = tickCounter_reg + 1;             // lo incremento. (Se deben enviar datos cada 15 ticks).
            end
                            
            STOP: begin                                 // STOP_STATE:
                tx_next = 1'b1;                         // Seteo tx_next=1 para enviar el bit de STOP.
                if(i_tick)                              // Entro cada vez que llega un tick del BRGenerator.
                    if(tickCounter_reg == (SB_TICK-1)) begin      // Si es igual a 15 la se?al indica que se calibro.
                        o_tx_done_tick = 1'b1;          // Pongo el alto el flag DONE.
                        state_next = IDLE;              // Paso al estado de IDLE.
                    end
                    else                                // En caso de que TickCounter no haya llegado a '15'     ->
                        tickCounter_next = tickCounter_reg + 1;             // lo incremento. (Se deben enviar datos cada 15 ticks).
            end
                  
            default : begin                             // DEFAULT: Fault Recovery
                state_next      = IDLE;                      // Vuelvo al estado IDLE.
                tickCounter_next= 1'b0;                      // Reinicio TickCounter.
                bitCounter_next = 4'b0000;                   // Reinicio contador de bits recibidos.
                buffer_next     = 0;                         // Reinicio buffer de datos recibidos.
                tx_next         = 1'b1;                      // Pongo en alto la salida para no enviar bit de START.
            end
                                                    
        endcase
        
    end
    
    
    // Output    
    assign o_tx = tx_reg ;                              // Asigno el bit a transmitir a la salida del transmisor.
    //assign o_tx_done_tick = o_tx_done_tick_reg;
        
endmodule
