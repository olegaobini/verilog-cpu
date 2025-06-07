/*
   TCES330 Spring 2025
   FSM.sv - Finite State Machine File
   Authors : Abdullah Almaroof & Olega Obini
   Description: 
    This module implements a FSM for a simple processor.
	It controls the flow of operations based on the instruction register (IR) input.
	The FSM defines states for initialization, fetching instructions, decoding,
	loading data, storing data, performing arithmetic operations, and halting.
*/

module FSM(
	input [15:0] IR,				// 16 bits input from IR
	input Clock,					// Clock signal
	input ResetN,					// reset signal
	output logic PC_clr,			// PC Clear Command
	output logic IR_Id,				// Instruction load command
	output logic PC_up,				// PC increment command
	output logic [7:0] D_addr,		// Data memory address
	output logic D_wr,				// Data memeory enable
	output logic RF_s,				// Mux select 
	output logic [3:0] RF_Ra_addr,	// Register file A side read address
	output logic [3:0] RF_Rb_addr,	// Register file B side read address
	output logic RF_W_en,			// Register file enable
	output logic [3:0] RF_W_addr,	// Register file write address
	output logic [2:0] ALU_s0,		// ALU function select
	output logic [3:0] CurrentState,
	output logic [3:0] NextState
);

	localparam
        Init   = 4'd0,
        Fetch  = 4'd1,
        Decode = 4'd2,
        LoadA  = 4'd3,
        LoadB  = 4'd4,
        Store  = 4'd5,
        Add    = 4'd6,
        Sub    = 4'd7,
        Halt   = 4'd8;

	always_ff @(posedge Clock) begin
        if (!ResetN)
          CurrentState <= Init;
        else
          CurrentState <= NextState;   // go to the state we described above
    end	

	always_comb begin
		// default values
		PC_clr = 0;
		IR_Id = 0;
		PC_up = 0;
		D_addr = 8'd0;
		D_wr = 0;
		RF_s = 0;
		RF_Ra_addr = 4'd0;
		RF_Rb_addr = 4'd0;
		RF_W_en = 0;
		RF_W_addr = 4'd0;
		ALU_s0 = 3'd0;

	case(CurrentState)
		Init: begin
			PC_clr = 1;
			NextState = Fetch;
		end
		
		Fetch: begin
			IR_Id = 1;
			PC_up = 1;
			NextState = Decode;
		end
		
		Decode: begin
				case (IR[15:12])
                    4'b0000: NextState = Fetch;  //NOOP
                    4'b0001: NextState = Store;
                    4'b0010: NextState = LoadA;
                    4'b0011: NextState = Add;
                    4'b0100: NextState = Sub;
                    4'b0101: NextState = Halt;
                    default: NextState = Fetch;
                endcase
		end

		LoadA: begin
			D_addr = IR[11:4];
			RF_s = 1; 
			RF_W_addr = IR[3:0];
			NextState = LoadB;
		end
		
		LoadB: begin
			D_addr = IR[11:4];
			RF_s = 1;
			RF_W_addr = IR[3:0];
			RF_W_en = 1;
			NextState = Fetch;
		end
		
		Store: begin
			D_addr = IR[7:0];
			D_wr = 1;
			RF_Ra_addr = IR[11:8];
			NextState = Fetch;
		end

		Add: begin
			RF_W_addr = IR[3:0];
			RF_W_en = 1;
			RF_Ra_addr=IR[11:8];
			RF_Rb_addr = IR[7:4];
			ALU_s0 = 1;
			RF_s = 0;
			NextState = Fetch;
		end

		Sub: begin
			RF_W_addr = IR[3:0];
			RF_W_en = 1;
			RF_Ra_addr=IR[11:8];
			RF_Rb_addr = IR[7:4];
			ALU_s0 = 2;
			RF_s = 0;
			NextState = Fetch;
		end
		
		Halt: begin
			NextState = Halt;
		end
	
	endcase
end
	
endmodule


module FSM_tb;
	//inputs
	logic [15:0] IR;				// 16 bits input from IR
	logic Clock;					// Clock signal
	logic ResetN;					// reset signal

	//outputs
	logic PC_clr;			// PC Clear Command
	logic IR_Id;				// Instruction load command
	logic PC_up;				// PC increment command
	logic [7:0] D_addr;		// Data memory address
	logic D_wr;				// Data memeory enable
	logic RF_s;				// Mux select 
	logic [3:0] RF_Ra_addr;	// Register file A side read address
	logic [3:0] RF_Rb_addr;	// Register file B side read address
	logic RF_W_en;			// Register file enable
	logic [3:0] RF_W_addr;	// Register file write address
	logic [2:0] ALU_s0;		// ALU function select
	logic [3:0] CurrentState;
	logic [3:0] NextState;
	
	FSM DUT (
		.IR(IR), 
		.Clock(Clock),
		.ResetN(ResetN),
		.PC_clr(PC_clr),
		.IR_Id(IR_Id),
		.PC_up(PC_up),
		.D_addr(D_addr),
		.D_wr(D_wr),
		.RF_s(RF_s),
		.RF_Ra_addr(RF_Ra_addr),
		.RF_Rb_addr(RF_Rb_addr),
		.RF_W_en(RF_W_en),
		.RF_W_addr(RF_W_addr),
		.ALU_s0(ALU_s0),
		.CurrentState(CurrentState),
		.NextState(NextState)
	);

	always begin 
		Clock = 0; #5;
		Clock = 1; #5;
	end

	initial begin

		ResetN = 0;
        IR = 16'd0;
        #10; // hold reset low for a few cycles

        ResetN = 1;
        #10;

        // 1. Test LOAD instruction
        IR = 16'b0010_0001_0101_0011; // Example LOAD
        #50;

        // 2. Test STORE instruction
        IR = 16'b0001_0001_0011_0101; // Example STORE
        #40;

        // 3. Test ADD instruction
        IR = 16'b0011_0010_0011_0100; // Example ADD
        #50;

        // 4. Test SUB instruction
        IR = 16'b0100_0101_0110_0111; // Example SUB
        #50;

        // 5. Test HALT instruction
        IR = 16'b0101_0000_0000_0000; // HALT
        #50;

        $stop;

	end
endmodule
