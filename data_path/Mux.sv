/*
	TCES330 Spring 2025
	File Name: Mux.sv
	Project, Simple Processor
	Author: Abduallah Almaroof and Olega Obini 
	Description:
        This module implements a 2-to-1 multiplexer (Mux) for a simple processor.
        It selects between two 16-bit inputs based on a single select signal.
        The output is the selected input based on the value of the select signal.
*/

`timescale 1ns/1ps
module Mux (X, Y, S, M); // A Mux 2 to 1 module
    // Port Declarations
    input S;
    input [15:0] X, Y; // 3 single-bit inputs
    output [15:0] M; // 1 single-bit output
    
    assign M = ({16{~S}} & X) | ({16{S}} & Y);

endmodule


module Mux_tb();
    logic [15:0] X, Y; 
    logic S; // 3 single-bit inputs
    logic [15:0] M; // 1 single-bit output

    // Instantiate the Device Under Test (DUT)
    Mux DUT(.X(X), .Y(Y), .S(S), .M(M));

    initial begin
        for (int i = 0; i < 8; i = i + 1) begin
            // Generate all combinations of inputs
            {S, X, Y} = i;
            #10; // Wait for 10 time units to observe the output
        end
        for( int j =0; j < 9; j++) begin    
            // Generate all combinations of inputs
            {S, X, Y} = $random;
            #10; // Wait for 10 time units to observe the output
        end
    end
endmodule