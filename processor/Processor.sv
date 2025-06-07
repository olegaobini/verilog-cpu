
module Processor(clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out); 
    input clk;               // processor clock 
    input Reset;             // system reset 
    
    output [15:0] IR_Out;    // Instruction register 
    output [7:0]  PC_Out;    // Program counter 
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
    logic [3:0] RF_Ra_addr;
    logic [3:0] RF_Rb_addr;
    
    //ALU
    logic [2:0] ALU_s0;

    Datapath DP(
        .clk(clk)
        .D_Addr(D_addr), 
        .D_wr(D_wr), 
        .RF_s(RF_s), 
        .RF_W_addr(RF_W_addr), 
        .RF_W_en(RF_W_en), 
        .RF_Ra_addr(RF_Ra_addr), 
        .RF_Rb_addr(RF_Rb_addr), 
        .Alu_s0(ALU_s0), 
        );

    Controller CU(
        .Clock(clk), 
        .ResetN(Reset),
        .D_addr(D_addr),
        .D_wr(D_wr),
        .RF_s(RF_s), 
        .RF_W_addr(RF_W_addr), 
        .RF_W_en(RF_W_en), 
        .RF_Ra_addr(RF_Ra_addr), 
        .RF_Rb_addr(RF_Rb_addr),
        .ALU_s0(ALU_s0));

endmodule

module testProcessor;
    logic Clk;                            // system clock
    logic ResetN;                         // system ResetN

    logic [15:0] IR_Out;                  // instruction register
    logic [6:0] PC_Out;                   // program counter
    logic [3:0] State, NextState;         // state machine state, next state
    logic [15:0] ALU_A, ALU_B, ALU_Out;   // ALU inputs and output 
    
    Processor DUT( Clk, ResetN, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out );

    // generate 50 MHz clock
    always begin
        Clk = 0;
        #10;
        Clk = 1'b1;
        #10;
    end

    initial	// Test stimulus
        begin
            $display( "\nBegin Simulation." );
            ResetN = 0;         // ResetN for one clock
            @ ( posedge Clk ) 
            #30  ResetN = 1; //or #21 ResetN = 1; just wait a little bit time to off the ridge 
            wait( IR_Out == 16'h5000 );  // halt instruction
            $display( "\nEnd of Simulation.\n" );
            $stop;
        end
    
    initial begin
        $monitor( "Time is %0t : ResetN = %b   PC_Out = %h   IR_Out = %h  State = %h  ALU A = %h  ALU B = %h ALU Out = %h  RA Address = %b", $stime, ResetN, PC_Out, IR_Out, State, ALU_A, ALU_B, ALU_Out, DUT.RF_Ra_Addr);
    end


endmodule    
