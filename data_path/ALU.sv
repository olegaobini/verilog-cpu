// Abdullah Almaroof & Olega Obini
// Lab 4 Part 2 - Designing an ALU
// May 7th 2025

module ALU( A, B, Sel, Q );
	input [2:0] Sel; // function select
	input [15:0] A, B; // input data
	output logic [15:0] Q; // ALU output (result)

	always @(Sel) begin
		case(Sel) //  0123456
		0: Q = 0;
		1: Q = A + B;
		2: Q = A - B;
		3: Q = A;
		4: Q = A ^ B; // XOR A to B
		5: Q = A | B;
		6: Q = A & B;
		7: Q = A + 1;
		default: $display("Error");
		endcase
	end
endmodule

module ALU_tb;
	logic [2:0] Sel; // function select
	logic [15:0] A, B; // input data
	logic [15:0] Q; // ALU output (result)

	ALU DUT (.Sel(Sel), .A(A), .B(B), . Q(Q));

	initial begin
		for(int i =0; i < 8; i++) begin
			Sel = i;
			for( int k=0; k<2; k++) begin
				A = k;
				B = k;
			end
			$display("A = %d ,B = %d, Sel = %d, Q = %d", A, B, Sel, Q); #10;
		end

		for(int i =0; i < 8; i++) begin
			Sel = i;
			for( int k=0; k<10; k++) begin
				{A,B} = $random;
			end
			$display("A = %d ,B = %d, Sel = %d, Q = %d", A, B, Sel, Q); #10;
		end
	end
endmodule