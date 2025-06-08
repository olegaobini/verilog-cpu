/*
   TCES330 Spring 2025
   RegisterFile.sv - Register File Module
   Authors : Abdullah Almaroof & Olega Obini
   Description: 
     This module implements a register file with 16 registers, each 16 bits wide.
     It allows writing to a specified register and reading from two specified registers.
     The write operation is triggered by a clock signal and a write enable signal.
     The read operations are combinational, providing the data from the specified registers.
*/

`timescale 1 ns / 1ps
 module RegisterFile (clk, RF_W_en, WriteAddress, WriteData, ReadAddrA, ReadAddrB, DataOutputA, DataOutputB);
   input clk;                    // system clock (positive edge triggered)
   input RF_W_en;                  // write enable (only when it is high, the write operation is performed)

   input [3:0] WriteAddress;     // write address (4-bit address to select the register to write to)
   input [15:0] WriteData;       // write data (data to be written to the register from 2 to 1 mux)

   input [3:0] ReadAddrA;        // A-side read address (4-bit address to select the register to read from)
   input [3:0] ReadAddrB;        // B-side read address (4-bit address to select the register to read from)

   output logic [15:0] DataOutputA;    // A-side read data (data read from the register specified by ReadAddrA)
   output logic [15:0] DataOutputB;    // B-side read data (data read from the register specified by ReadAddrB)

   logic [15:0] regfile [15:0];     // register file (array of 16 registers, each 16 bits wide)

   // read the registers
   assign DataOutputA = regfile[ReadAddrA];
   assign DataOutputB = regfile[ReadAddrB];

   // write the registers
   always_ff @(posedge clk) begin
      if (RF_W_en) begin             
         regfile[WriteAddress] <= WriteData; // write data to the specified register
      end
   end

 endmodule

 module RegisterFile_tb;

   logic clk;
   logic RF_W_en;
   logic [3:0] WriteAddress;
   logic [15:0] WriteData;
   logic [3:0] ReadAddrA;
   logic [3:0] ReadAddrB;
   logic [15:0] DataOutputA;
   logic [15:0] DataOutputB;
   
   RegisterFile DUT(
      .clk(clk), 
      .RF_W_en(RF_W_en), 
      .WriteAddress(WriteAddress), 
      .WriteData(WriteData), 
      .ReadAddrA(ReadAddrA), 
      .ReadAddrB(ReadAddrB), 
      .DataOutputA(DataOutputA), 
      .DataOutputB(DataOutputB)
   );
   
   always begin      
         clk = 0; #5;
         clk = 1; #5; // Toggle clock every 5 time units
      end

   always @* begin 
      // Display the outputs whenever they change
      $display("Time: %0t, ReadAddrA: %0d, DataOutputA: %h, ReadAddrB: %0h, DataOutputB: %h, WriteAddress: %0h, WriteData: %h, Write: %b", 
               $time, ReadAddrA, DataOutputA, ReadAddrB, DataOutputB, WriteAddress, WriteData, RF_W_en);
   end

   initial begin

      // Initialize signals
      clk = 0;
      RF_W_en = 0;
      WriteAddress = 0;
      WriteData = 0;
      ReadAddrA = 0;
      ReadAddrB = 0;

      // Test writing to register 2
      WriteAddress = 4'd5; // Address 2
      WriteData = 16'h2025; // Data to write
      RF_W_en = 1; // Enable write
      #10; // Wait for a clock cycle
      RF_W_en = 0; // Disable write

      // Read from register 0
      ReadAddrA = WriteAddress; // set address A = to write address
      #10; // Wait for a clock cycle
      

      // Test writing to register 1
      WriteAddress = 4'b0001; // Address 1
      WriteData = 16'h5678; // Data to write
      RF_W_en = 1; // Enable write
      #10; // Wait for a clock cycle
      RF_W_en = 0; // Disable write

      // Read from register 1
      ReadAddrB = 4'b0001; // Read from address 1
      #10; // Wait for a clock cycle
   

      for( int i = 0; i < 10; i++ ) begin
         {RF_W_en, WriteAddress, WriteData} = $random;
         ReadAddrA = WriteAddress; #20;
      end

      for( int i = 0; i < 10; i++ ) begin
         {RF_W_en, WriteAddress, WriteData} = $random;
         ReadAddrB = WriteAddress; #20;
      end

      $finish; //End simulation

   end

endmodule