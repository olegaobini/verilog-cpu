/*
	TCES330 Spring 2025
	File Name: Project.sv
	Project, Simple Processor
	Author: Abduallah Almaroof and Olega Obini 
	Description:
		This module integrates various components of a simple processor, including the processor, 
		button synchronization, key filtering, and multiplexing for output display.
		It connects the processor's outputs to the HEX displays and LEDs for visualization.
*/


`timescale 1 ns / 1 ps
module Project( CLOCK_50, KEY, SW, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, LEDG, LEDR);

	// Inputs
	input logic [17:0] SW;
	input logic [3:0] KEY;
	input logic CLOCK_50;

	// Outputs
	output logic [3:0] LEDG; 
	output logic [17:0] LEDR;
	output logic [0:6] HEX0;
	output logic [0:6] HEX1;
	output logic [0:6] HEX2;
	output logic [0:6] HEX3;
	output logic [0:6] HEX4;
	output logic [0:6] HEX5;
	output logic [0:6] HEX6;
	output logic [0:6] HEX7;

	// Key Condition Wires
	logic ButtonSync_Out;
	logic KeyFilter_Out;

	// Processor & Mux Wires
	logic [15:0] ALU_A; 
	logic [15:0] ALU_B; 
	logic [15:0] ALU_Out;
	logic [15:0] IR_Out;
	logic [3:0] NextState; 
	logic [3:0] State; 
	logic [7:0] PC_Out; 
	logic [15:0] M; // Mux output
	
	assign LEDG[3:0] = ~KEY[3:0]; 
	assign LEDR[17:0] = SW[17:0];


	ButtonSync BS(
		.Bi(KEY[2]), 
		.Clk(CLOCK_50), 
		.Bo(ButtonSync_Out)
	);

	KeyFilter Filter(
		.Clk(CLOCK_50), 
		.In(ButtonSync_Out), 
		.Out(KeyFilter_Out)
	);

	Processor Proc(
		.Clk(KeyFilter_Out), 
		.ResetN(KEY[0]), 
		.IR_Out(IR_Out), 
		.PC_Out(PC_Out), 
		.State(State), 
		.NextState(NextState), 
		.ALU_A(ALU_A), 
		.ALU_B(ALU_B), 
		.ALU_Out(ALU_Out)
	);
	
	Mux_16w_8_to_1 Mx(
		.S(SW[17:15]), 
		.X0({PC_Out, State, State}), 
		.X1(ALU_A), 
		.X2(ALU_B), 
		.X3(ALU_Out), 
		.X4({12'h0, NextState}), 
		.X5(16'h0), 
		.X6(16'h0), 
		.X7(16'h0), 
		.M(M)
	);

	Decoder H0(.Hex(HEX0), .V(IR_Out[3:0]));
	Decoder H1(.Hex(HEX1), .V(IR_Out[7:4]));
	Decoder H2(.Hex(HEX2), .V(IR_Out[11:8]));
	Decoder H3(.Hex(HEX3), .V(IR_Out[15:12]));

	Decoder H4(.Hex(HEX4), .V(M[3:0]));
	Decoder H5(.Hex(HEX5), .V(M[7:4]));
	Decoder H6(.Hex(HEX6), .V(M[11:8]));
	Decoder H7(.Hex(HEX7), .V(M[15:12]));

endmodule