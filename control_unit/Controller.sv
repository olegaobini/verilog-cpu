// Abdullah Almaroof
// June 4th 2025

`timescale 1ps/1ps
module Controller(Clock, ResetN, D_addr, D_wr,RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, PC_out, IRout);
	//inputs
	input Clock;
	logic ResetN;

	//outputs
	output logic [6:0] PC_out;  // this was 8 previously 
	output logic [15:0] IROut;
	//outstate
	//nextstate
	output logic [7:0] D_addr; //this was 7 previously
	output logic D_wr;
	output logic RF_s;
	output logic RF_W_en;
	output logic [3:0] RF_Ra_addr;
	output logic [3:0] RF_Rb_addr;
	output logic [3:0] RF_W_addr;
	output logic [2:0] ALU_s0;

	//logic	
	logic PC_Up
	logic PC_Clr; // INCLUDE IN FSM
	logic [15:0] InstMemoryOut;
	logic IR_ld; // INCLUDE IN FSM

	
	PC unit0 (Clock,PC_Clr,PC_Up,PC_out);
	
	InstMemory unit1 (PC_out,Clock,InstMemoryOut);
	
	IR unit2 (Clock,IR_ld,InstMemoryOut,IROut);
	
	FSM unit3 (IROut, Clock, ResetN, PC_Clr, IR_ld, PC_Up, D_addr, D_wr,RF_s,RF_Ra_addr, RF_Rb_addr, RF_W_en, RF_W_addr, ALU_s0);

endmodule

module Controller_tb;

	logic Clock, ResetN;
	
	 logic [7:0] D_addr;
	 logic D_wr;
	 logic RF_s;
	 logic  [3:0] RF_W_addr;
	 logic RF_W_en;
	 logic [3:0] RF_Ra_addr;
	 logic [3:0] RF_Rb_addr;
	 logic [2:0] ALU_s0;

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
		
