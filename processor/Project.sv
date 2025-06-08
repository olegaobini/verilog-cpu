/*
   TCES330 Spring 2025
   Project.sv - high-level module for the processor project
   Authors : Abdullah Almaroof & Olega Obini
   Description: 
    This module serves as the top-level design for the processor project
    It instantiates the Processor, Mux, and other components as needed
    The module connects inputs and outputs to facilitate communication between components and FPGA
*/

`timescale 1 ns / 1 ps
module Project( CLOCK_50, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out, KEY, SW, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, LEDG);

	input [17:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	
	
	output [3:0] LEDG; // LEDs for output
	output [15:0] IR_Out; // Instruction register
	output [7:0] PC_Out; // Program counter
	output [3:0] State; // FSM current state
	output [3:0] NextState; // FSM next state (or 0 if you don’t use one)
	output [15:0] ALU_A; // ALU A-Side Input
	output [15:0] ALU_B; // ALU B-Side Input
	output [15:0] ALU_Out; // ALU current output
	output [0:6] HEX0;
	output [0:6] HEX1;
	output [0:6] HEX2;
	output [0:6] HEX3;
	output [0:6] HEX4;
	output [0:6] HEX5;
	output [0:6] HEX6;
	output [0:6] HEX7;
	
	logic [15:0] X0,X1,X2,X3,X4,X5,X6,X7;
	logic Clk, Reset;
	
	assign Clk = KEY[2];
	assign LEDG[3:0] = SW[3:0]; 


	Processor unit0 (Clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);
	
	// Mux_16w_8_to_1 unit1 (SW[17:15], X0, X1, X2, X3, X4, X5, X6, X7, M);





	
endmodule