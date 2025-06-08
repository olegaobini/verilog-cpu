/*
   TCES330 Spring 2025
   Datapath.sv - Datapath File
   Authors : Abdullah Almaroof & Olega Obini
   Description: 
    This module implements the datapath of a simple processor.
    It includes a Register File, ALU, Mux, and Data Memory.
*/
   
`timescale 1ns/1ps
module Datapath(D_Addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, Alu_s0, clk, Ra_data, Rb_data, Alu_out);
    input           clk;

    // Data Memory IO
    input           D_wr;
    input [7:0]     D_Addr;

    // Mux IO
    input           RF_s;

    // Register File IO
    input           RF_W_en;
    input [3:0]     RF_W_addr;
    input [3:0]     RF_Ra_addr;
    input [3:0]     RF_Rb_addr;

    // ALU IO
    input [2:0]     Alu_s0;
    output [15:0]   Alu_out;            // Output from ALU
    output [15:0]   Ra_data, Rb_data;   // Data from Register File

    // Wires
    logic [15:0]    Dmem_out;           // Data from Data Memory
    logic [15:0]    Mux16_out;          // Output from Mux

    DataMemory DM(
	.clock(clk),
	.address(D_Addr),
	.data(Ra_data),
	.wren(D_wr),
	.q(Dmem_out)
    );
    
    Mux Mux(
    .X(Alu_out),    //  if S=0, Mux selects data from ALU
    .Y(Dmem_out),   //  if S=1, Mux selects data from Data Memory
    .S(RF_s),       // Select signal for Mux
    .M(Mux16_out)   // Output of Mux
    );

    RegisterFile RF (
        .clk(clk),                  // Clock signal for register file
        .RF_W_en(RF_W_en),            // Write enable signal for register file
        .WriteAddress(RF_W_addr),   // Address to write to in register file
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
        .clk(clk),
        .Ra_data(Ra_data),
        .Rb_data(Rb_data),
        .Alu_out(Alu_out)
    );

    // Clock generation
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    initial begin
        // Initialize
        D_Addr = 8'h00;
        D_wr = 0;
        RF_s = 0;
        RF_W_addr = 4'b0000;
        RF_W_en = 0;
        RF_Ra_addr = 4'b0000;
        RF_Rb_addr = 4'b0000;
        Alu_s0 = 3'b000;
        #10;

        // write a value to register 1 and A via Dmem address 1
        D_Addr = 8'h01;
        D_wr = 0;
        RF_s = 1;
        RF_W_addr = 4'b0001;
        RF_W_en = 0;
        RF_Ra_addr = 4'b0001;
        RF_Rb_addr = 4'b0000;
        Alu_s0 = 3'b000; 
        #10; 
        RF_W_en = 1;
        #10;
        RF_W_en = 0;

        // write a value to register 2 and B via Dmem address 2
        D_Addr = 8'd2;
        D_wr = 0;
        RF_s = 1;
        RF_W_addr = 4'd2;
        RF_W_en = 0;
        RF_Ra_addr = 4'd1;
        RF_Rb_addr = 4'd2;
        Alu_s0 = 3'b000; 
        #10; 
        RF_W_en = 1;
        #10;
        RF_W_en = 0;

        // write a value to register 3 via ALU (A + B)
        D_wr = 0;
        RF_s = 0;
        RF_W_addr = 4'd3;
        RF_W_en = 1;
        RF_Ra_addr = 4'd1;
        RF_Rb_addr = 4'd2;
        Alu_s0 = 3'b001;
        #10;
        RF_W_en = 1;
        #10;
        RF_W_en = 0;
        #10;
        #10;
        RF_Ra_addr = 4'd3; // Read back register 3

        $display("Register 3 (should be A + B): %h", Ra_data);


        $display("Datapath testbench complete.");
        $finish;
    end

    // initial begin
    //     integer i;

    //     // 1. Initialize
    //     D_Addr = 8'h00;
    //     D_wr = 0;
    //     RF_s = 0;
    //     RF_W_addr = 4'b0000;
    //     RF_W_en = 0;
    //     RF_Ra_addr = 4'b0000;
    //     RF_Rb_addr = 4'b0000;
    //     Alu_s0 = 3'b000;
    //     #10;

    //     // 2. Write a value to register 1 via ALU 
    //     // Set up operands in registers 0 and 0 (both 0), ALU add (0+0=0)
    //     RF_W_addr = 4'b0001;
    //     RF_W_en = 1;
    //     RF_Ra_addr = 4'b0000;
    //     RF_Rb_addr = 4'b0000;
    //     Alu_s0 = 3'b001; // ALU add
    //     RF_s = 0;        // Select ALU output
    //     #10;
    //     RF_W_en = 0;

    //     // 3. Write a value to register 2 via DataMemory (address 27, value 8634)
    //     D_Addr = 8'd27;
    //     RF_s = 1;         // Select DataMemory output
    //     RF_W_addr = 4'b0010;
    //     RF_W_en = 0;
    //     #10;              // Wait for Dmem_out to update
    //     RF_W_en = 1;
    //     #10;
    //     RF_W_en = 0;

    //     // 4. Read back from register 1 and 2
    //     RF_Ra_addr = 4'b0001;
    //     RF_Rb_addr = 4'b0010;
    //     #10;
    //     $display("Register 1 (ALU result): %h", Ra_data);
    //     $display("Register 2 (from Dmem[27]): %h", Rb_data);

    //     // 5. Write register 2's value to DataMemory address 42
    //     D_Addr = 8'd42;
    //     D_wr = 1;
    //     RF_Ra_addr = 4'b0010; // Ra_data will be written to memory
    //     #10;
    //     D_wr = 0;

    //     // 6. Read from DataMemory address 42 into register 3
    //     D_Addr = 8'd42;
    //     RF_s = 1;
    //     RF_W_addr = 4'b0011;
    //     #10;
    //     RF_W_en = 1;
    //     #10;
    //     RF_W_en = 0;

    //     // 7. Read back from register 3
    //     RF_Ra_addr = 4'b0011;
    //     #10;
    //     $display("Register 3 (should match register 2): %h", Ra_data);

    //     // 8. Test ALU operations (add, sub, xor, etc.) between reg2 and reg3
    //     RF_Ra_addr = 4'b0010;
    //     RF_Rb_addr = 4'b0011;
    //     for (i = 0; i < 8; i = i + 1) begin
    //         Alu_s0 = i[2:0];
    //         #10;
    //         $display("ALU sel=%0d, A=%h, B=%h, Out=%h", Alu_s0, Ra_data, Rb_data, Alu_out);
    //     end

    //     $display("Datapath testbench complete.");
    //     $finish;
    // end
endmodule

/*
CONTENT BEGIN
	[0..26]  :   0;
	27   :   8634;
	[28..41]  :   0;
	42   :   41038;
	[43..59]  :   0;
	60   :   29100;
	[61..125]  :   0;
	126  :   45439;
	[127..255]  :   0;
END;
*/