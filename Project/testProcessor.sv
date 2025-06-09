// TCES 330, Spring 2025
// Testbench  for the programmable processor

`timescale 1 ns / 1 ps
module testProcessor;
 
  logic Clk;             // system clock
  logic ResetN;           // system ResetN
  logic [15:0] IR_Out;   // instruction register
  logic [6:0] PC_Out;    // program counter
  logic [3:0] State, NextState;        // state machine state, next state
  logic [15:0] ALU_A, ALU_B, ALU_Out;  // ALU inputs and output 
 
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



                           