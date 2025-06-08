/*
   TCES330 Spring 2025
   File Name: Decoder.sv
   Lab 6, Part1
   Author: Abduallah Almaroof and Olega Obini 
   Description:
    This module implements a 4-bit decoder that converts a 4-bit binary input
	into a 7-segment display output.
*/

module Decoder( Hex, V);
	input [3:0] V; // input lines
	output logic [0:6]Hex; // the seven segments

	always @(V) begin
		case(V) // 0123456
		0: Hex = 7'b0000001;
		1: Hex = 7'b1001111;
		2: Hex = 7'b0010010;
		3: Hex = 7'b0000110;
		4: Hex = 7'b1001100;
		5: Hex = 7'b0100100;
		6: Hex = 7'b0100000;
		7: Hex = 7'b0001111;
		8: Hex = 7'b0000000;
		9: Hex = 7'b0001100;
		10: Hex = 7'b0001000;
		11: Hex = 7'b1100000;
		12: Hex = 7'b0110001;
		13: Hex = 7'b1000010;
		14: Hex = 7'b0110000;
		15: Hex = 7'b0111000;
		endcase
	end

endmodule

module Decoder_tb;

	logic [3:0]V;
	logic [6:0]Hex;


	Decoder DUT(.Hex(Hex), .V(V));

	initial begin
        for (int i = 0; i < 8; i++) begin
            {V} = i; #10;
			$display("%b,%b",Hex,V);
        end
		for (int i=0; i<=10; i++)begin
			{V}= $random; #10;
			$display("%b,%b",Hex,V);
		end
	end

	

endmodule