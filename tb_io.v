`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2021 12:05:13
// Design Name: 
// Module Name: tb_io
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

module tb_io();
  
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
  
  
  reg [NB_IN - 1 : 0] r_dato1;
  reg [NB_IN - 1 : 0] r_dato2;
  reg [NB_IN - 1 : 0] r_switch; 
  reg [NB_CODE - 1 : 0] r_code; 
  reg b_dato1;
  reg b_dato2;
  reg b_code;
  wire [NB_OUT - 1 : 0] salida;
  reg clk;
  
  input_output#
  (.NB_IN(NB_IN), .NB_OUT(NB_OUT), .NB_CODE(NB_CODE))
  u_input_output
  (.switch(r_switch), .b_dato1(b_dato1), .b_dato2(b_dato2), .b_code(b_code), .clk(clk), .w_salida(salida));
  
  initial begin
    //Condiciones iniciales de los registro
    r_code = 6'b0;
    r_switch = 8'b0;
    r_dato1 = 8'b0;
    r_dato2 = 8'b0;
    b_dato1 = 1'b0;
    b_dato2 = 1'b0;
    b_code = 1'b0; 
    clk = 1'b0;
  
    //Envío de datos a r_dato1 y r_dato2
    #40
    //r_dato1 = $urandom();
    r_dato1 = 8'b0000100; //(4)
    //r_dato1 = 8'b11111100; //(FC = -4)
    r_switch = r_dato1;
    #20
    b_dato1 = 8'b1;
    #20
    b_dato1 = 8'b0;
    #20
    //r_dato2 = $urandom();
    r_dato2 = 8'b00000110;//(6)
    //r_dato2 = 8'b111111010; //(FA = -6)
    //r_dato2 = 8'b11111111; //(FF = -1)
    //r_dato2 = 8'b00000010; //(2)
    r_switch = r_dato2;
    #20
    b_dato2 = 8'b1;
    #20
    b_dato2 = 8'b0;
    
    //Envío del OpCode 
    #20
    r_code = ADD;
    r_switch = r_code;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_code = SUB;
    r_switch = r_code;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_code = AND;
    r_switch = r_code;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_code = OR;
    r_switch = r_code;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_code = XOR;
    r_switch = r_code;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_code = SRA;
    r_switch = r_code;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;
    
    #40
    r_code = SRL;
    r_switch = r_code;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_code = NOR;
    r_switch = r_code;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;
  end
  
  always #10 clk = ~clk;
  
  //always@(posedge clk) begin
  always@(negedge b_code) begin
    //if(~b_code) begin
        case(r_code)              ///Cambiar despues
          ADD:
            if(salida == r_dato1 + r_dato2)
              $display(" ADD CORRECTO ");
            else 
              $display(" ADD INCORRECTO ");
          SUB:
            if(salida == r_dato1 - r_dato2)
              $display(" SUB CORRECTO ");
            else 
              $display(" SUB INCORRECTO ");
          AND:
            if(salida == (r_dato1 & r_dato2))
              $display(" AND CORRECTO ");
            else 
              $display(" AND INCORRECTO ");
          OR:
            if(salida == r_dato1 | r_dato2)
              $display(" OR CORRECTO ");
            else 
              $display(" OR INCORRECTO ");
          XOR:
            if(salida == r_dato1 ^ r_dato2)
              $display(" XOR CORRECTO ");
            else 
              $display(" XOR INCORRECTO ");
          SRA:
            if(salida == r_dato1 >>> r_dato2)
              $display(" SRA CORRECTO ");
            else 
              $display(" SRA INCORRECTO ");
          SRL:
            if(salida == r_dato1 >> r_dato2)
              $display(" SRL CORRECTO ");
            else 
              $display(" SRL INCORRECTO ");
          NOR:
            if(salida == ~(r_dato1 | r_dato2))
              $display(" NOR CORRECTO ");
            else 
              $display(" NOR INCORRECTO ");
        endcase
    //end
  end
endmodule
