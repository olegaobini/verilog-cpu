/*
   TCES330 Spring 2025
   File Name: Controller.sv
   Project, Simple Processor
   Author: Abduallah Almaroof and Olega Obini 
   Description:
     This module implements the controller for a simple processor.
	 It manages the program counter, instruction memory, instruction register, and finite state machine.
	 The controller coordinates the flow of data and control signals within the processor.
*/

`timescale 1ps/1ps
module Controller(Clock, ResetN, D_addr, D_wr,RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, PC_out, IROut, CurrentStateOut, NextStateOut);
	//inputs
	input logic Clock;
	input logic ResetN;

	//outputs
	output logic [2:0] ALU_s0;
	output logic [3:0] CurrentStateOut;
	output logic [7:0] D_addr; 
	output logic D_wr;
	output logic [3:0] NextStateOut;
	output logic [3:0] RF_Ra_addr;
	output logic [3:0] RF_Rb_addr;
	output logic RF_s;
	output logic [3:0] RF_W_addr;
	output logic RF_W_en;
	output logic [15:0] IROut;
	output logic [6:0] PC_out;  

	//logic	
	logic PC_Up;
	logic PC_Clr; // INCLUDE IN FSM
	logic [15:0] InstMemoryOut;
	logic IR_ld; // INCLUDE IN FSM

	
	PC PC(
		.Clock(Clock),
		.Clr(PC_Clr),
		.Up(PC_Up),
		.address(PC_out)
	);
	
	InstMemory instMemory(
		.address(PC_out),
		.clock(Clock),
		.q(InstMemoryOut)
	);
	
	IR IR(
		.Clock(Clock),
		.ld(IR_ld),
		.data(InstMemoryOut),
		.instruction(IROut)
	);
	
	FSM FSM(
		.IR(IROut), 
		.Clock(Clock), 
		.ResetN(ResetN), 
		.PC_clr(PC_Clr), 
		.IR_Id(IR_ld), 
		.PC_up(PC_Up), 
		.D_addr(D_addr), 
		.D_wr(D_wr),
		.RF_s(RF_s),
		.RF_Ra_addr(RF_Ra_addr), 
		.RF_Rb_addr(RF_Rb_addr), 
		.RF_W_en(RF_W_en), 
		.RF_W_addr(RF_W_addr), 
		.ALU_s0(ALU_s0), 
		.CurrentState(CurrentStateOut), 
		.NextState(NextStateOut)
	);

endmodule

module Controller_tb;
	// Inputs
	logic Clock;
	logic ResetN;

	// Outputs
	logic [6:0] PC_out;  
	logic [15:0] IROut;
	logic [7:0] D_addr; 
	logic D_wr;
	logic RF_s;
	logic RF_W_en;
	logic [3:0] RF_Ra_addr;
	logic [3:0] RF_Rb_addr;
	logic [3:0] RF_W_addr;
	logic [2:0] ALU_s0;
	logic [3:0] CurrentStateOut;
	logic [3:0] NextStateOut;

	Controller DUT (.*);

	always begin
		Clock = 0; #10;
		Clock = 1; #10;
	end

	initial begin
		ResetN = 0;
		#40;
		ResetN = 1;
		#40;
		
		#1000;
		
		ResetN = 0; #100;

		$stop;
	end

endmodule
		
