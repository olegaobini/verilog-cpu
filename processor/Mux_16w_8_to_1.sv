/*
	TCES330 Spring 2025
	File Name: Mux_16w_8_to_1.sv
	Project, Simple Processor
	Author: Abduallah Almaroof and Olega Obini 
	Description:
		This module implements a 8-to-1 multiplexer for 16-bit wide inputs.
		It selects one of the eight 16-bit inputs based on a 3-bit select signal.
		The output is the selected input based on the value of the select signal.
*/

module Mux_16w_8_to_1 (S, X0, X1, X2, X3, X4, X5, X6, X7, M);
    input [2:0] S;
    input logic [15:0] X0, X1, X2, X3, X4, X5, X6, X7;
    output logic [15:0] M;

	always @* begin
		case(S)
    	3'd0: M = X0;
        3'd1: M = X1;
        3'd2: M = X2; 
		3'd3: M = X3;
		3'd4: M = X4;
		3'd5: M = X5;
		3'd6: M = X6;
		3'd7: M = X7;
		default: M = 3'b111;
		endcase
	end
endmodule

module Mux_3w_8_to_1_tb;

	logic [2:0] S;
    logic [15:0] X0, X1, X2, X3, X4, X5, X6, X7;
    logic [15:0] M;

	Mux_16w_8_to_1 DUT (.M(M),.S(S),.X0(X0),.X1(X1),.X2(X2),.X3(X3),.X4(X4),.X5(X5),.X6(X6),.X7(X7));

	initial begin

		S =3'd0 ; X0 = 3'd0; X1 = 3'd1; X2 = 3'd2; X3 = 3'd3; X4 = 3'd4; X5 = 3'd5; X6 = 3'd6 ; X7 = 3'd7; #10;
		S =3'd1 ; X0 = 3'd0; X1 = 3'd1; X2 = 3'd2; X3 = 3'd3; X4 = 3'd4; X5 = 3'd5; X6 = 3'd6 ; X7 = 3'd7; #10;
		S =3'd2 ; X0 = 3'd0; X1 = 3'd1; X2 = 3'd2; X3 = 3'd3; X4 = 3'd4; X5 = 3'd5; X6 = 3'd6 ; X7 = 3'd7; #10;
		S =3'd3 ; X0 = 3'd0; X1 = 3'd1; X2 = 3'd2; X3 = 3'd3; X4 = 3'd4; X5 = 3'd5; X6 = 3'd6 ; X7 = 3'd7; #10;
		S =3'd4 ; X0 = 3'd0; X1 = 3'd1; X2 = 3'd2; X3 = 3'd3; X4 = 3'd4; X5 = 3'd5; X6 = 3'd6 ; X7 = 3'd7; #10;
		S =3'd5 ; X0 = 3'd0; X1 = 3'd1; X2 = 3'd2; X3 = 3'd3; X4 = 3'd4; X5 = 3'd5; X6 = 3'd6 ; X7 = 3'd7; #10;
		S =3'd6 ; X0 = 3'd0; X1 = 3'd1; X2 = 3'd2; X3 = 3'd3; X4 = 3'd4; X5 = 3'd5; X6 = 3'd6 ; X7 = 3'd7; #10;
		S =3'd7 ; X0 = 3'd0; X1 = 3'd1; X2 = 3'd2; X3 = 3'd3; X4 = 3'd4; X5 = 3'd5; X6 = 3'd6 ; X7 = 3'd7; #10;

		for(int i =0; i <9; i++) begin

			{S,X0,X1, X2, X3, X4, X5, X6, X7} = $random; #10;
		end
	end
endmodule