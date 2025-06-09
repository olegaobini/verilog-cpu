/*
	TCES330 Spring 2025
	File Name: KeyFilter.sv
	Project, Simple Processor
	Author: Dr. Jenny Sheng
	Description:
		The Key Filter follows a button synchronizer
		allows at most 10 output signals per second 
		with a 50MHz clock

*/
module KeyFilter (Clk, In, Out);
	input Clk, In;			//Clock and input signal of the system
	output logic Out; 	//Output of the filter

	localparam DUR = 5_000_000 - 1;
	logic [32:0] Countdown = 0;

	always @(posedge Clk) begin

		Out <= 0;			//initial output value
		if(Countdown == 0) begin
			if(In) begin
				Out <= 1;
				Countdown <= DUR;
			end
		end
		else begin
			Countdown <= Countdown - 1;
		end
	end
endmodule 
