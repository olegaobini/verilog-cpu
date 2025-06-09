/*
	TCES330 Spring 2025
	File Name: IR.sv
	Project, Simple Processor
	Author: Abduallah Almaroof and Olega Obini 
	Description:
		This module implements the Instruction Register (IR) for a simple processor.
		It captures the instruction data on the rising edge of the clock when the load signal is high.
*/

`timescale 1ps/1ps
module IR (Clock, ld, data, instruction);

	input ld, Clock;
	input [15:0] data;
	output logic [15:0] instruction; 

	always_ff @ (posedge Clock) begin
		if (ld) instruction <= data;
	end
endmodule