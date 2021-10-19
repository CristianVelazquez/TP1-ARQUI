`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2021 19:41:25
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


module tb_RX();
    
    // LOCAL_PARAMETERS
    // BRG
    localparam  BAUD_RATE = 9600;  //con 195312 debe dar un tick cada 16 clocks    
    localparam  CLK_FREC = 50000000; // 50 MHz
    // RX
    localparam NB_DATA  = 8;
    localparam SB_TICK  = 16;
    localparam RESULT   = 8'b01100101;        //65 en hexa
    
    // TB_SIGNALS
    // BRG
    reg                                 clk;
    reg                                 test_start;
    reg                                 reset;
    wire                                tick;
    // RX
    reg                                 rx;
    wire                                done_tick;
    wire [NB_DATA-1:0]                  data;
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        test_start = 1'b0;
        rx = 1'b1;      
        
        #10
        reset = 1'b0;
        test_start = 1'b1;
        rx = 1'b0;                      // Bit de START
        
        // (1/9600)*10e9
        #104167
        rx = 1'b1;                      // D0 LSB
        
        #104167
        rx = 1'b0;                      // D1
        
        #104167
        rx = 1'b1;                      // D2
        
        #104167
        rx = 1'b0;                      // D3
        
        #104167
        rx = 1'b0;                      // D4
        
        #104167
        rx = 1'b1;                      // D5
        
        #104167
        rx = 1'b1;                      // D6
        
        #104167
        rx = 1'b0;                      // D7 MSB
        
        #104167
        rx = 1'b1;                      // Bit de Stop
                
        #104167        
        
        $display("############# Test OK ############");
        $finish();
    end
    




    // MODULE_INSTANCE
    // BRG
    baudGen#
    (.BAUD_RATE(BAUD_RATE), .CLK_FREC(CLK_FREC))
    u_baudGen
    (.clk(clk),.tick(tick));
    
    // RX
    RX
    #(
        .NB_DATA      (NB_DATA),
        .SB_TICK      (SB_TICK)
    )
    u_RX
    (
        .i_clk        (clk),
        .i_reset      (reset),
        .i_tick       (tick),
        .i_rx         (rx),
        .o_rx_done_tick(done_tick),
        .o_data       (data)
    );
    
    // CLOCK_GENERATION
    always #10 clk = ~clk;
    
    // TEST
    always @(posedge clk) begin
        if ((done_tick) && (RESULT != data)) begin
            $display("############# Test FALLO ############");
            $finish();
        end
    end
  
endmodule