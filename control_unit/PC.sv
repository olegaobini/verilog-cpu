/*
	TCES330 Spring 2025
	File Name: PC.sv
	Project, Simple Processor
	Author: Abduallah Almaroof and Olega Obini 
	Description:
        This module implements the Program Counter (PC) for a simple processor.
        It increments the address on each clock cycle when the Up signal is high,
        and resets to zero when the Clr signal is high.
*/

//`timescale 1ps/1ps
module PC(Clock, Clr, Up, address);

	input Clock,Clr,Up;		
	output logic [6:0] address; 	//7 bit output

	always_ff @(posedge Clock) begin
		if(Clr) begin
			address <= 7'd0;
		end
		else if(Up) begin
			address <= address + 1;
		end
	end
endmodule

module PC_tb;

    logic Clock, Clr, Up;
    logic [6:0] address;

    PC DUT (.Clock(Clock), .Clr(Clr), .Up(Up), .address(address));

    always begin
        Clock = 0; #5;
        Clock = 1; #5;
    end

    initial begin
        $monitor("Time=%0t, Clk=%b, Clr=%b, Up=%b, Address=%d", 
                 $time, Clock, Clr, Up, address);

        Clr = 1; Up = 0;
        #10;           // reset active for one clock cycle
        Clr = 0; Up = 1;

        for (int i = 0; i < 130; i++) begin
            @(posedge Clock);  // wait for rising edge
        end

        Clr = 1;          // reset again
        @(posedge Clock);

        $stop;
    end
endmodule
