/*
	TCES330 Spring 2025
	File Name: ALU.sv
	Project, Simple Processor
	Author: Abduallah Almaroof and Olega Obini 
	Description:
		This module implements the Arithmetic Logic Unit (ALU) for a simple processor.
		It performs various arithmetic and logical operations based on the selected function.
		The ALU can add, subtract, perform bitwise operations, and increment the input A.
*/

`timescale 1 ns / 1 ps
module ALU( A, B, Sel, Q );
	input [2:0] Sel; // function select
	input [15:0] A, B; // input data
	output logic [15:0] Q; // ALU output (result)

	always_comb begin
		case(Sel) 
		0: Q = 0;
		1: Q = A + B;
		2: Q = A - B;
		3: Q = A;
		4: Q = A ^ B; 
		5: Q = A | B;
		6: Q = A & B;
		7: Q = A + 1;
		default: 
		begin
			Q = 16'hxxxx; // default case
			$display("Error");
		end

		endcase
	end
endmodule

module ALU_tb;
	logic [2:0] Sel; // function select
	logic [15:0] A, B; // input data
	logic [15:0] Q; // ALU output (result)

	ALU DUT (.Sel(Sel), .A(A), .B(B), . Q(Q));

	initial begin
		for(int i =0; i < 8; i++) begin
			Sel = i;
			for( int k=0; k<2; k++) begin
				A = k;
				B = k;
			end
			$display("A = %d ,B = %d, Sel = %d, Q = %d", A, B, Sel, Q); #10;
		end

		for(int i =0; i < 8; i++) begin
			Sel = i;
			for( int k=0; k<10; k++) begin
				{A,B} = $random;
			end
			$display("A = %d ,B = %d, Sel = %d, Q = %d", A, B, Sel, Q); #10;
		end
	end
endmodule