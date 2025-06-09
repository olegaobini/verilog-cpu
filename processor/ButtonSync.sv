/*
	TCES330 Spring 2025
	File Name: ButtonSync.sv
	Project, Simple Processor
	Author: Abduallah Almaroof and Olega Obini 
	Description:
        This module synchronizes a raw push-button input to the system clock.
        It uses a two-flip-flop synchronizer to ensure that the button state is stable
        and aligned with the clock, preventing metastability issues.
*/

module ButtonSync (
    input  logic Clk,           // 50 MHz system clock
    input  logic Bi,            // raw push-button (active-low)
    output logic Bo             // stable, clock-aligned level
);

    // Polarity: 1 = pressed
    logic key_async;
    assign key_async = ~Bi;

    //  Two-FF synchroniser
    logic sync_ff1, sync_ff2;
    always_ff @(posedge Clk) begin
        sync_ff1 <= key_async;   // may metastabilise
        sync_ff2 <= sync_ff1;    // settled by next edge
    end
    
    assign Bo = sync_ff2;  

endmodule