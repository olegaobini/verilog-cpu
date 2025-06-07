// Abdullah Almaroof and Olega Obiniw
// June 3rd 2025
// FSM for CPUS

module FSM(IR, Clock, ResetN, PC_clr, IR_Id, PC_up, D_addr, D_wr,RF_s,RF_Ra_addr, RF_Rb_addr, RF_W_en, RF_W_addr, ALU_s0);
	
	input [15:0] IR;				// 16 bits input from IR
	input Clock;					// Clock signal
	input ResetN;					// reset signal
	
	output logic PC_clr;			// PC Clear Command
	output logic IR_Id;				// Instruction load command
	output logic PC_up;				// PC increment command
	output logic [7:0] D_addr;		// Data memory address
	output logic D_wr;				// Data memeory enable
	output logic RF_s;				// Mux select 
	output logic [3:0] RF_Ra_addr;	// Register file A side read address
	output logic [3:0] RF_Rb_addr;	// Register file B side read address
	output logic RF_W_en;			// Register file enable
	output logic [3:0] RF_W_addr;	// Register file write address
	output logic [2:0] ALU_s0;		// ALU function select
	
	
	//output logic [3:0] CurrentState, NextState;

	logic [3:0] State,Next,CurrentState,NextState;

	assign CurrentState = State;
	assign NextState = Next;

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
          State <= Init;
        else
          State <= Next;   // go to the state we described above
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
			Next = Fetch;
		end
		
		Fetch: begin
			IR_Id = 1;
			PC_up = 1;
			Next = Decode;
		end
		
		Decode: begin
				case (IR[15:12])
                    4'b0000: Next = Fetch;  //NOOP
                    4'b0001: Next = Store;
                    4'b0010: Next = LoadA;
                    4'b0011: Next = Add;
                    4'b0100: Next = Sub;
                    4'b0101: Next = Halt;
                    default: Next = Fetch;
                endcase
		end

		LoadA: begin
			D_addr = IR[11:4];
			RF_s = 1; 
			RF_W_addr = IR[3:0];
			Next = LoadB;
		end
		
		LoadB: begin
			D_addr = IR[11:4];
			RF_s = 1;
			RF_W_addr = IR[3:0];
			RF_W_en = 1;
			Next = Fetch;
		end
		
		Store: begin
			D_addr = IR[7:0];
			D_wr = 1;
			RF_Ra_addr = IR[11:8];
			Next = Fetch;
		end

		Add: begin
			RF_W_addr = IR[3:0];
			RF_W_en = 1;
			RF_Ra_addr=IR[11:8];
			RF_Rb_addr = IR[7:4];
			ALU_s0 = 1;
			RF_s = 0;
			Next = Fetch;
		end

		Sub: begin
			RF_W_addr = IR[3:0];
			RF_W_en = 1;
			RF_Ra_addr=IR[11:8];
			RF_Rb_addr = IR[7:4];
			ALU_s0 = 2;
			RF_s = 0;
			Next = Fetch;
		end
		
		Halt: begin
			Next = Halt;
		end
	
	endcase
end
	
endmodule
		

module FSM_tb;

	
	logic [15:0] IR;				// 16 bits input from IR
	logic Clock;					// Clock signal
	logic ResetN;					// reset signal
	
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
	logic [3:0] NextState;		// ALU function select
	logic [3:0] CurrentState;		// ALU function select

	FSM DUT (.*);

	always begin 
		Clock = 0; #10;
		Clock = 1; #10;
	end

	initial begin

		ResetN = 0;
        IR = 16'd0;
        #15; // hold reset low for a few cycles

        ResetN = 1;
        #10;

        // 1. Test LOAD instruction
        IR = 16'b0010_0001_0101_0011; // Example LOAD
        #100;

        // 2. Test STORE instruction
        IR = 16'b0001_0001_0011_0101; // Example STORE
        #80;

        // 3. Test ADD instruction
        IR = 16'b0011_0010_0011_0100; // Example ADD
        #100;

        // 4. Test SUB instruction
        IR = 16'b0100_0101_0110_0111; // Example SUB
        #100;

        // 5. Test HALT instruction
        IR = 16'b0101_0000_0000_0000; // HALT
        #100;

        $stop;

        
		
	end

endmodule







	

	 