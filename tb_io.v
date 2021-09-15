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
  reg b_dato1;
  reg b_dato2;
  reg b_code;
  wire [NB_OUT - 1 : 0] salida;
  reg clk;
  
  input_output#
  (.NB_IN(NB_IN), .NB_OUT(NB_OUT), .NB_CODE(NB_CODE))
  u_input_output
  (.switch(r_switch), .b_dato1(b_dato1), .b_dato2(b_dato2), .b_code(b_code), .clk(clk), .salida(salida));
  
  initial begin
    //r_code = 6'b0;
    r_switch = 8'b0;
    r_dato1 = 8'b0;
    r_dato2 = 8'b0;
    b_dato1 = 1'b0;
    b_dato1 = 1'b0;
    b_code = 1'b0; 
    clk = 1'b0;
  
  
    #40
    r_dato1 = 8'b00010000;//$urandom();
    r_switch = r_dato1;
    #20
    b_dato1 = 8'b1;
    #20
    b_dato1 = 8'b0;
    #20
    r_dato2 = 8'b00000111;//$urandom();
    r_switch = r_dato2;
    #20
    b_dato2 = 8'b1;
    #20
    b_dato2 = 8'b0;
    #20
    r_switch = ADD;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_switch = SUB;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_switch = AND;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_switch = OR;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_switch = XOR;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_switch = SRA;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;
    
    #40
    r_switch = SRL;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;

    #40
    r_switch = NOR;
    #20
    b_code = 8'b1;
    #20
    b_code = 8'b0;
  end
  
  always #10 clk = ~clk;
  
  always@(posedge clk) begin
    case(r_switch)              ///Cambiar despues
      ADD:
        if(salida == r_dato1 + r_dato2)
          $display(" ADD CORRECTO ");
      else 
        $display(" VALOR INCORRECTO ");
      SUB:
        if(salida == r_dato1 - r_dato2)
        $display(" SUB CORRECTO ");
      else 
        $display(" VALOR INCORRECTO ");
       AND:
       if(salida == (r_dato1 & r_dato2))
        $display(" AND CORRECTO ");
      else 
        $display(" VALOR INCORRECTO ");
        OR:
        if(salida == r_dato1 | r_dato2)
        $display(" OR CORRECTO ");
      else 
        $display(" VALOR INCORRECTO ");
        XOR:
        if(salida == r_dato1 ^ r_dato2)
        $display(" XOR CORRECTO ");
      else 
        $display(" VALOR INCORRECTO ");
        SRA:
         if(salida == r_dato1 >>> r_dato2)
        $display(" SRA CORRECTO ");
      else 
        $display(" VALOR INCORRECTO ");
        SRL:
         if(salida == r_dato1 >> r_dato2)
        $display(" SRL CORRECTO ");
      else 
        $display(" VALOR INCORRECTO ");
        NOR:
         if(salida == ~(r_dato1 | r_dato2))
        $display(" NOR CORRECTO ");
      else 
        $display(" VALOR INCORRECTO ");
    endcase
  end
endmodule
