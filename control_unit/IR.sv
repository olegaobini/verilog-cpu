// Abdullah Almaroof
// June 2nd 2025
// IR File

module IR (Clock,ld,data,address);

	input ld, Clock;
	input [15:0] data;
	output logic [15:0] address;

	always_ff @ (posedge Clock) begin
		if (ld) address <= data;
		else address <= 16'd0;
	end
endmodule