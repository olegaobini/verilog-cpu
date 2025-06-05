/*
*/

`timescale 1ps/1ps  // Add this at the top of the file
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

    DataMemory Dmem (
        .clock(clk),
        .address(D_addr),
        .data(A),           //
        .wren(Rmem_write),
        .q(DmemReg_data) //16 bit data from data mem to register file
        );

    RegisterFile mem (
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
        RF_W_addr = 5'h00;
        RF_Ra_addr = 5'h01;
        RF_Rb_addr = 5'h02;

        // Test sequence
        #10; // Wait for some time
        D_W_en = 1;         // Enable data memory write
        D_addr = 8'h00;         // Set address to write to
        RF_W_addr = 5'h01;     // Set register write address
        RF_W_en = 1;          // Enable register write

        #10; // Wait for some time
        D_W_en = 0; // Disable data memory write

        #10; // Wait for some time
        $finish; // End simulation
    end
endmodule