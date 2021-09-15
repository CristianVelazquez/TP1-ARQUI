`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2021 19:45:29
// Design Name: 
// Module Name: alu
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

// Code your testbench here
// or browse Examples

module alu
#(
  parameter NB_IN = 8,
  parameter NB_OUT = 8,
  parameter NB_CODE =6 
)
(
  output wire [NB_OUT - 1 : 0] salida,
  input wire [NB_IN - 1 : 0] dato1,
  input wire [NB_IN - 1 : 0] dato2,
  input wire [NB_CODE - 1 : 0] op_code 
);
    
    //PARAMETROS LOCALES
  localparam ADD = 6'b100000;
  localparam SUB = 6'b100010;
  localparam AND = 6'b100100;
  localparam OR = 6'b100101;
  localparam XOR = 6'b100110;
  localparam SRA = 6'b000011;
  localparam SRL = 6'b000010;
  localparam NOR = 6'b100111; 
    
  reg [NB_OUT - 1 : 0] resultado;
    
  assign salida = resultado;
    
  always@(*) begin:r_alu
    case(op_code)
      ADD:
        resultado = dato1 + dato2;
      SUB:
        resultado = dato1 - dato2;
      AND:
        resultado = dato1 & dato2;
      OR:
        resultado = dato1 | dato2;
      XOR:
        resultado = dato1 ^ dato2;
      SRA:
        resultado = dato1 >>> dato2;
      SRL:
        resultado = dato1 >> dato2;
      NOR:
        resultado = ~(dato1 | dato2);
      default:
        resultado = {NB_OUT{1'b0}};
    endcase
    end
endmodule