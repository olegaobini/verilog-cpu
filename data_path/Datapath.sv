// Abdullah Almaroof and Olega Obini
// Datapath module for the CPU connecting ALU, registers, and memory
// May 24, 2025

module Datapath(D_Addr, D_wr, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, Alu_s0, clk);

    input [7:0]     D_Addr;
    input           D_wr;
    input           RF_s;
    input [3:0]     RF_W_addr;
    input           RF_W_en;
    input [3:0]     RF_Ra_addr;
    input [3:0]     RF_Rb_addr;
    input [3:0]     Alu_s0;
    input           clk;

    logic [15:0]    Ra_data, Rb_data;   // Data from Register File
    logic [15:0]    R_data;             // Data from Data Memory
    logic [15:0]    Mux16_out;          // Output from Mux
    logic [15:0]    Alu_out;            // Output from ALU

    Register RF (
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
    .Y(R_data),     //  if S=1, Mux selects data from Data Memory
    .S(RF_s),       // Select signal for Mux
    .M(Mux16_out)   // Output of Mux
    );

    DataMemory DM(
        .clk(clk),          // Clock signal for data memory
        .D_wr(D_wr),        // Write enable signal for data memory
        .D_Addr(D_Addr),    // Address for data memory
        .W_data(rRa_dat),   // Data to write to data memory
        .R_data(da)         // Data read from data memory
        );
endmodule

module Datapath_tb;

logic [7:0]     D_Addr;
logic           D_wr;
logic           RF_s;
logic [3:0]     RF_W_addr;
logic           RF_W_en;
logic [3:0]     RF_Ra_addr;
logic [3:0]     RF_Rb_addr;
logic [3:0]     Alu_s0;
logic           clk;

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

    // Test writing to register file and ALU operations
    #10; // Wait for some time
    RF_W_en = 1; // Enable write to register file
    RF_W_addr = 4'b0001; // Write to register 1
    D_Addr = 8'h01; // Address in data memory
    D_wr = 1; // Enable write to data memory

    // Simulate clock cycles
    always begin
        clk = 0; #5; // Wait for 10 time units
        clk = 1; #5; // Toggle clock every 5 time units
    end

    for(int i = 0; i < 9; i++) begin
        {D_Addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, Alu_s0} = $random #10; // Randomize inputs
    end
end

endmodule