/*
   TCES330 Spring 2025
   Datapath.sv - Datapath File
   Authors : Abdullah Almaroof & Olega Obini
   Description: 
    This module implements the datapath of a simple processor.
    It includes a Register File, ALU, Mux, and Data Memory.
*/
   
`timescale 1ns/1ps
module Datapath(D_Addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, Alu_s0, clk);
    input           clk;

    // Data Memory IO
    input [7:0]     D_Addr;
    input           D_wr;

    // Mux IO
    input           RF_s;

    // Register File IO
    input [3:0]     RF_W_addr;
    input           RF_W_en;
    input [3:0]     RF_Ra_addr;
    input [3:0]     RF_Rb_addr;

    // ALU IO
    input [2:0]     Alu_s0;

    // Wires
    logic [15:0]    Ra_data, Rb_data;   // Data from Register File
    logic [15:0]    Dmem_out;           // Data from Data Memory
    logic [15:0]    Mux16_out;          // Output from Mux
    logic [15:0]    Alu_out;            // Output from ALU

    RegisterFile RF (
        .clk(clk),                  // Clock signal for register file
        .WriteAddress(RF_W_addr),   // Address to write to in register file
        .write(RF_W_en),            // Write enable signal for register file
        .ReadAddrA(RF_Ra_addr),     // Address to read from in register file (Ra)
        .ReadAddrB(RF_Rb_addr),     // Address to read from in register file (Rb)
        .WriteData(Mux16_out),      // Data to write to register file
        .DataOutputA(Ra_data),      // Output data from register file (Ra)
        .DataOutputB(Rb_data)       // Output data from register file (Rb)
    );

    ALU ALU(
        .A(Ra_data),    // First operand for ALU
        .B(Rb_data),    // Second operand for ALU
        .Sel(Alu_s0),   // ALU operation selector
        .Q(Alu_out)     // Output of ALU operation
    );

    //if S=0, M=X; if S=1, M=Y
    Mux Mux(
    .X(Alu_out),    //  if S=0, Mux selects data from ALU
    .Y(Dmem_out),   //  if S=1, Mux selects data from Data Memory
    .S(RF_s),       // Select signal for Mux
    .M(Mux16_out)   // Output of Mux
    );

    DataMemory DM(
	.address(D_Addr),
	.clock(clk),
	.data(Ra_data),
	.wren(D_wr),
	.q(Dmem_out)
    );

endmodule

module Datapath_tb;

    logic           clk;
    logic [7:0]     D_Addr;
    logic           D_wr;
    logic           RF_s;
    logic [3:0]     RF_W_addr;
    logic           RF_W_en;
    logic [3:0]     RF_Ra_addr;
    logic [3:0]     RF_Rb_addr;
    logic [2:0]     Alu_s0;

    logic [15:0]    Ra_data, Rb_data;   // Data from Register File
    logic [15:0]    R_data;             // Data from Data Memory
    logic [15:0]    Mux16_out;          // Output from Mux
    logic [15:0]    Alu_out;            // Output from ALU


    Datapath DUT (
        .D_Addr(D_Addr),
        .D_wr(D_wr),
        .RF_s(RF_s),
        .RF_W_addr(RF_W_addr),
        .RF_W_en(RF_W_en),
        .RF_Ra_addr(RF_Ra_addr),
        .RF_Rb_addr(RF_Rb_addr),
        .Alu_s0(Alu_s0),
        .clk(clk)
    );

    // Simulate clock cycles
    always begin
        clk = 0; #5; // Wait for 10 time units
        clk = 1; #5; // Toggle clock every 5 time units
    end

    initial begin
        // Initialize signals
        clk = 0;
        D_Addr = 8'h00;
        D_wr = 0;
        RF_s = 0;
        RF_W_addr = 4'b0000;
        RF_W_en = 0;
        RF_Ra_addr = 4'b0000;
        RF_Rb_addr = 4'b0001;
        Alu_s0 = 4'b0000;
        #10;

        $finish;
    end
endmodule

