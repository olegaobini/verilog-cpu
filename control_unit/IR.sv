// Abdullah Almaroof
// June 2nd 2025
// IR File

`timescale 1ps/1ps
module IR (Clock,ld,data,instruction);

	input ld, Clock;
	input [15:0] data;
	output logic [15:0] instruction; 

	always_ff @ (posedge Clock) begin
		if (ld) instruction <= data;
	end
endmodule