/*
	TCES330 Spring 2025
	File Name: Processor.sv
	Project, Simple Processor
	Author: Abduallah Almaroof and Olega Obini 
	Description:
        This module implements a simple processor that integrates a datapath and a controller.
        The processor fetches instructions
*/


`timescale 1ns / 1ps
module Processor(Clk, ResetN, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out); 
    input Clk;               // processor clock 
    input ResetN;             // system reset 
    
    output [15:0] IR_Out;    // Instruction register 
    output [6:0]  PC_Out;    // Program counter 
    output [3:0]  State;     // FSM current state 
    output [3:0]  NextState; // FSM next state (or 0 if you don’t use one) 
    output [15:0] ALU_A;     // ALU A-Side Input 
    output [15:0] ALU_B;     // ALU B-Side Input 
    output [15:0] ALU_Out;   // ALU current output 

    //datamemory
    logic D_wr;
    logic [7:0] D_addr;
    
    //mux
    logic RF_s;
   
    // register file
    logic RF_W_en;
    logic [3:0] RF_W_addr;
    logic [3:0] RF_Ra_Addr;
    logic [3:0] RF_Rb_Addr;
    
    //ALU
    logic [2:0] ALU_s0;

    Datapath DP(
        .clk(Clk),
        .D_Addr(D_addr), 
        .D_wr(D_wr), 
        .RF_s(RF_s), 
        .RF_W_addr(RF_W_addr), 
        .RF_W_en(RF_W_en), 
        .RF_Ra_addr(RF_Ra_Addr), 
        .RF_Rb_addr(RF_Rb_Addr), 
        .Alu_s0(ALU_s0),
        .Ra_data(ALU_A),
        .Rb_data(ALU_B),
        .Alu_out(ALU_Out)
        );

    Controller CU (
        .Clock(Clk), 
        .ResetN(ResetN),
        .D_addr(D_addr),
        .D_wr(D_wr),
        .RF_s(RF_s), 
        .RF_W_addr(RF_W_addr), 
        .RF_W_en(RF_W_en), 
        .RF_Ra_addr(RF_Ra_Addr), 
        .RF_Rb_addr(RF_Rb_Addr),
        .ALU_s0(ALU_s0),
        .PC_out(PC_Out),
        .IROut(IR_Out),
        .CurrentStateOut(State),
        .NextStateOut(NextState)
        );

endmodule