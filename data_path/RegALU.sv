/*
*/

`timescale 1ps/1ps  
module RegALU(clk, RF_W_en, RF_W_addr, RF_Ra_addr, RF_Rb_addr, ALU_s0, Q);
    input logic clk;
    
    // for register file
    input RF_W_en;
    input [4:0] RF_W_addr;
    input [4:0] RF_Ra_addr;
    input [4:0] RF_Rb_addr;

    // for ALU
    input ALU_s0;

    //output
    output logic [15:0] Q; 

    //wires
    wire logic [15:0] A, B; 

    RegisterFile mem (
        .clk(clk), 
        .write(RF_W_en), 
        .WriteAddress(RF_W_addr), 
        .WriteData(Q), 
        .ReadAddrA(RF_Ra_addr), 
        .ReadAddrB(RF_Rb_addr), 
        .DataOutputA(A), 
        .DataOutputB(B));
    
    ALU alu ( 
        .A(A), 
        .B(B), 
        .Sel(ALU_s0), 
        .Q(Q)
        );

endmodule

module RegALU_tb();
    logic clk;
    logic RF_W_en;
    logic [4:0] RF_W_addr;
    logic [4:0] RF_Ra_addr;
    logic [4:0] RF_Rb_addr;
    logic ALU_s0;
    logic [15:0] Q;
    // logic [15:0] A, B;

    RegALU DUT (
        .clk(clk), 
        .RF_W_en(RF_W_en), 
        .RF_W_addr(RF_W_addr), 
        .RF_Ra_addr(RF_Ra_addr), 
        .RF_Rb_addr(RF_Rb_addr), 
        .ALU_s0(ALU_s0), 
        .Q(Q)
    );

    always begin      
        clk = 0; #5;
        clk = 1; #5; // Toggle clock every 5 time units
    end

    initial begin
        // Initialize signals
        RF_W_en = 0;         // Disable register file write
        RF_W_addr = 5'h00;   // Set write address to 0
        RF_Ra_addr = 5'h01;  // Set read address A
        RF_Rb_addr = 5'h02;  // Set read address B
        ALU_s0 = 3'b000;     // Set ALU operation to 0 (e.g., no operation)
        Q = 16'h0000;        // Initialize output to 0

        // Test sequence
        #10; // Wait for some time
        RF_W_en = 1;         // Enable register file write
        RF_W_addr = 5'h01;   // Set register write address
        ALU_s0 = 3'b001;     // Set ALU operation to addition
        RF_Ra_addr = 5'h01;  // Set read address A to the same as write address
        RF_Rb_addr = 5'h02;  // Set read address B to another register


        #10; // Wait for some time
        RF_W_en = 0;         // Disable register file write
        RF_Ra_addr = 5'h01;  // Read from register 1
        RF_Rb_addr = 5'h02;  // Read from register 2


        #10; // Wait for some time
        $finish; // End simulation
    end
endmodule