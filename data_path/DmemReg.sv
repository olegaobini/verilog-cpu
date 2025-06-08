/*
   tces330 spring 2025
   DmemReg.sv - Data memory and Register file
   authors : abdullah almaroof & olega obini
   description: 
   a module to test the data memory and register file connection
*/

`timescale 1ns/1ps  
module DmemReg(clk, D_W_en, D_addr, RF_W_en, RF_W_addr, RF_Ra_addr, RF_Rb_addr, A, B);
    input logic clk;
    
    // for data memory
    input D_W_en;               // write enable
    input [7:0] D_addr;         // data address

    // for register file
    input RF_W_en;            // write enable for register file
    input [3:0] RF_W_addr;   // write address for register file
    input [3:0] RF_Ra_addr;  // read address A
    input [3:0] RF_Rb_addr;  // read address B

    //output
    output logic [15:0] A, B;       // read data from register file

    //wires
    wire logic [15:0] DmemReg_data; // data output from data memory to register file

    DataMemory Dmem(
        .clock(clk),
        .address(D_addr),
        .data(A),           //
        .wren(D_W_en),
        .q(DmemReg_data) //16 bit data from data mem to register file
        );

    RegisterFile RF(
        .clk(clk), 
        .write(RF_W_en), 
        .WriteAddress(RF_W_addr), 
        .WriteData(DmemReg_data), 
        .ReadAddrA(RF_Ra_addr), 
        .ReadAddrB(RF_Rb_addr), 
        .DataOutputA(A), 
        .DataOutputB(B));
endmodule

module DmemReg_tb();
    logic clk;
    logic D_W_en;
    logic [7:0] D_addr;
    logic RF_W_en;
    logic [3:0] RF_W_addr;
    logic [3:0] RF_Ra_addr;
    logic [3:0] RF_Rb_addr;
    logic [15:0] A, B;

    DmemReg DUT(
        .clk(clk), 
        .D_W_en(D_W_en), 
        .D_addr(D_addr), 
        .RF_W_en(RF_W_en), 
        .RF_W_addr(RF_W_addr), 
        .RF_Ra_addr(RF_Ra_addr), 
        .RF_Rb_addr(RF_Rb_addr), 
        .A(A), 
        .B(B)
    );

    always begin      
        clk = 0; #5;
        clk = 1; #5; // Toggle clock every 5 time units
    end

    initial begin
          // Initialize signals
        D_W_en = 0;
        D_addr = 8'h00;
        RF_W_en = 0;
        RF_W_addr = 4'h0;
        RF_Ra_addr = 4'h0;
        RF_Rb_addr = 4'h0;

        // 1. Write to DataMemory at address 0, then to RegisterFile at reg 1
        #10;
        DUT.A = 16'hAAAA; // Value to write to memory
        D_addr = 8'h00;
        D_W_en = 1;
        #10;
        D_W_en = 0;

        // 2. Write memory output to RegisterFile reg 1
        RF_W_addr = 4'h1;
        RF_W_en = 1;
        #10;
        RF_W_en = 0;

        // 3. Read back from RegisterFile reg 1
        RF_Ra_addr = 4'h1;
        #10;
        $display("Register 1 (should be AAAA): %h", A);

        // 4. Write to DataMemory at address 15, then to RegisterFile at reg 15
        DUT.A = 16'h5555;
        D_addr = 8'h0F;
        D_W_en = 1;
        #10;
        D_W_en = 0;

        RF_W_addr = 4'hF;
        RF_W_en = 1;
        #10;
        RF_W_en = 0;

        // 5. Read back from RegisterFile reg 15
        RF_Ra_addr = 4'hF;
        #10;
        $display("Register 15 (should be 5555): %h", A);

        // 6. Read from RegisterFile reg 0 (should be uninitialized or default)
        RF_Ra_addr = 4'h0;
        #10;
        $display("Register 0 (uninitialized): %h", A);

        // 7. Simultaneous read from two registers
        RF_Ra_addr = 4'h1;
        RF_Rb_addr = 4'hF;
        #10;
        $display("Register 1: %h, Register 15: %h", A, B);

        // 8. Try writing and reading at the same time
        DUT.A = 16'hDEAD;
        D_addr = 8'h02;
        D_W_en = 1;
        RF_W_addr = 4'h2;
        RF_W_en = 1;
        #10;
        D_W_en = 0;
        RF_W_en = 0;
        RF_Ra_addr = 4'h2;
        #10;
        $display("Register 2 (should be DEAD): %h", A);

        $display("Testbench complete.");
        $finish;
    end
endmodule