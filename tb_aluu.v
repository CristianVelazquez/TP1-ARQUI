`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2021 20:37:49
// Design Name: 
// Module Name: tb_alu
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


module tb_alu();

  localparam  NB_IN =8;
  localparam  NB_OUT = 8;
  localparam  NB_CODE =6;
  localparam ADD = 6'b100000;
  localparam SUB = 6'b100010;
  localparam AND = 6'b100100;
  localparam OR = 6'b100101;
  localparam XOR = 6'b100110;
  localparam SRA = 6'b000011;
  localparam SRL = 6'b000010;
  localparam NOR = 6'b100111;
  localparam FINISH = 6'b111111;

  reg [NB_CODE - 1 : 0] r_code;
  reg [NB_IN - 1 : 0] r_dato1;
  reg [NB_IN - 1 : 0] r_dato2; 
  wire [NB_OUT - 1 : 0] r_salida;
  reg clk;

  alu#
  (.NB_IN(NB_IN), .NB_OUT(NB_OUT), .NB_CODE(NB_CODE))
  u_alu
  (.salida(r_salida), .dato1(r_dato1),.dato2(r_dato2), .op_code(r_code));

  initial begin
    //$dumpfile("dump.vcd"); $dumpvars;
    r_code = 6'b0;
    r_dato1 = 8'b0;
    r_dato2 = 8'b0;
    clk = 1'b0;

    #20
    r_dato1= 8'b00000110;
    r_dato2= 8'b00000100;
    r_code= ADD;
    
    #20
    r_code= SUB;
    
    #20
    r_code= FINISH;//Para no imprimir
    //$finish;
  end
  
  always #10 clk = ~clk;
  
  always@(posedge clk) begin
    case(r_code)
      ADD:
        if(r_salida== 8'b00001010)
          $display("############# VALOR CORRECTO ############");
      else 
        $display("############# VALOR INCORRECTO ############");
      SUB:
        if(r_salida== 8'b00000010)
        $display("############# VALOR CORRECTO ############");
      else 
        $display("############# VALOR INCORRECTO ############");
      //default:
       // $display("############# NADA ############");
    endcase
  end
endmodule