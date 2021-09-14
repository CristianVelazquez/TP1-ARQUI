`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2021 11:14:48
// Design Name: 
// Module Name: input_output
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

// Code your design here
module input_output
  #(
  parameter NB_IN = 8,
  parameter NB_OUT = 8,
  parameter NB_CODE =6
    )
  (
    input wire [NB_IN - 1 : 0] switch,
    input wire b_dato1,
    input wire b_dato2,
    input wire b_code,
    input wire clk,
    output wire [NB_OUT - 1 : 0] salida
  );
  
  reg  [NB_IN - 1 : 0]  r_dato1; 
  reg  [NB_IN - 1 : 0]  r_dato2; 
  reg  [NB_CODE - 1 : 0]  r_code; 
  
  always@(posedge clk) begin
    if(b_dato1 && ~b_dato2 && ~b_code) //solo b_dato1=1
      begin
        r_dato1 <= switch;
      end
    else if ( ~b_dato1 && b_dato2 && ~b_code)
      begin
        r_dato2 <=switch;
      end
    else if ( ~b_dato1 && ~b_dato2 && b_code)
      begin
        r_code<=switch;
      end
  end
      alu#(
        .NB_IN(NB_IN), .NB_OUT(NB_OUT), .NB_CODE(NB_CODE)
      )
      u_alu
      (.salida(salida), .dato1(r_dato1),.dato2(r_dato2), .op_code(r_code));
  
endmodule
