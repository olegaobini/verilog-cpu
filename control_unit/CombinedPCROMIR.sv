// Abdullah Almaroof
// June 3rd 2025
// This combines the IR, PC and IM in the control unit to test them

`timescale 1ps/1ps
module CombinedPCROMIR(
    input logic Clock, clr, up, ld,
    output logic [15:0] IR_out
);

    logic [6:0] PC_out;
    logic [15:0] IM_out;

    PC unit0 (
        .Clr(clr),
        .Up(up),
        .Clock(Clock),
        .address(PC_out)
    );

    InstMemory unit1 (
        .clock(Clock),
        .address(PC_out),
        .q(IM_out)
    );

    IR unit2 (
        .Clock(Clock),
        .ld(ld),
        .data(IM_out),
        .instruction(IR_out)
    );

endmodule


module CombinedPCROMIR_tb;

    logic Clock, clr, up, ld;
    logic [15:0] IR_out;

    CombinedPCROMIR DUT (
        .Clock(Clock),
        .clr(clr),
        .up(up),
        .ld(ld),
        .IR_out(IR_out)
    );

    // Clock generator
    always begin
		
		Clock = 0; #5;	
		Clock = 1; #5;
	end

    initial begin
        // Initialize
        Clock = 0;
        clr = 1;
        up = 0;
        ld = 0;

        $monitor("Time: %0t | clr=%b up=%b ld=%b IR_out=%h", $time, clr, up, ld, IR_out);

        #10 clr = 0;
        #10 up = 1;
        #10 ld = 1;
        #10 ld = 1;

        #50 $finish;
    end

endmodule