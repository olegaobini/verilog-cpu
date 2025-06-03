/*
*/
`timescale 1ps/1ps  // Add this at the top of the file
module DmemReg(clk, Dmem_write, D_addr, Reg_write, Reg_w_addr, Reg_Ra_addr, Reg_Rb_addr, A, B);
    input logic clk;
    
    // for data memory
    input Dmem_write;          // write enable
    input [7:0] D_addr;       // data address

    // for register file
    input Reg_write;          // write enable for register file
    input [4:0] Reg_w_addr;   // write address for register file
    input [4:0] Reg_Ra_addr;  // read address A
    input [4:0] Reg_Rb_addr;  // read address B

    //output
    output logic [15:0] A, B;       // read data from register file

    //wires
    wire logic [16:0] DmemReg_data; // data output from data memory to register file

    DataMemory Dmem (
        .clock(clk),
        .address(D_addr),
        .data(A),           //
        .wren(Rmem_write),
        .q(DmemReg_data) //16 bit data from data mem to register file
        );

    RegisterFile mem (
        .clk(clk), 
        .write(Reg_write), 
        .WriteAddress(Reg_w_addr), 
        .WriteData(DmemReg_data), 
        .ReadAddrA(Reg_Ra_addr), 
        .ReadAddrB(Reg_Rb_addr), 
        .DataOutputA(A), 
        .DataOutputB(B));

endmodule

module DmemReg_tb();
    logic clk;
    logic Dmem_write;
    logic [7:0] D_addr;
    logic Reg_write;
    logic [4:0] Reg_w_addr;
    logic [4:0] Reg_Ra_addr;
    logic [4:0] Reg_Rb_addr;
    logic [15:0] A, B;

    DmemReg DUT(
        .clk(clk), 
        .Dmem_write(Dmem_write), 
        .D_addr(D_addr), 
        .Reg_write(Reg_write), 
        .Reg_w_addr(Reg_w_addr), 
        .Reg_Ra_addr(Reg_Ra_addr), 
        .Reg_Rb_addr(Reg_Rb_addr), 
        .A(A), 
        .B(B)
    );

    always begin      
        clk = 0; #5;
        clk = 1; #5; // Toggle clock every 5 time units
    end

    initial begin
        // Initialize signals
        Dmem_write = 0;
        D_addr = 8'h00;
        Reg_write = 0;
        Reg_w_addr = 5'h00;
        Reg_Ra_addr = 5'h01;
        Reg_Rb_addr = 5'h02;

        // Test sequence
        #10; // Wait for some time
        Dmem_write = 1; // Enable data memory write
        D_addr = 8'h01; // Set address to write to
        Reg_w_addr = 5'h01; // Set register write address
        Reg_write = 1; // Enable register write

        #10; // Wait for some time
        Dmem_write = 0; // Disable data memory write

        #10; // Wait for some time
        $finish; // End simulation
    end
endmodule