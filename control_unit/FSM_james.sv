// -------------------------------------------------------------------
// @author jamesgallegos
//-------------------------------------------------------------------
module FSM (clk, ResetN, IR, D_Addr, D_wr, RF_s, RF_W_addr, RF_W_en, RF_Ra_addr, RF_Rb_addr, ALU_s0, IR_Id, PC_Up, PC_Clr, CurrentState, NextState);

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

    // FSM
    input clk, ResetN;
    input [15:0] IR;
    output logic [3:0] CurrentState, NextState;

    logic [3:0] State, Next; // Holding current and fuiture state


    assign CurrentState = State;
    assign NextState = Next;

    // PC
    output logic PC_Clr, PC_Up;

    // IR
    output logic IR_Id;

    // RAM
    output logic [7:0] D_Addr;
    output logic D_wr;

    // MUX
    output logic RF_s;

    // REG
    output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
    output logic RF_W_en;

    // ALU
    output logic ALU_s0;


    always_comb begin

        // default outputs
        PC_Clr = 0;
        PC_Up = 0;
        IR_Id = 0;
        D_wr = 0;
        RF_s = 0;
        RF_W_en = 0;
        D_Addr = 8'd0;
        RF_W_addr = 4'd0;
        RF_Ra_addr = 4'd0;
        RF_Rb_addr = 4'd0;
        ALU_s0 = 3'd0;

        case(State)


            // Init
            Init: begin
                PC_Clr = 1;
                Next = Fetch;
            end

            // Fetch
            Fetch: begin
                PC_Up = 1;
                IR_Id = 1;
                Next = Decode;
            end

            // Decode
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
                D_Addr = IR[11:4];
                RF_s = 1;
                RF_W_addr = IR[3:0];
                Next = LoadB;
            end

            LoadB: begin
                D_Addr = IR[11:4];
                RF_s = 1;
                RF_W_addr = IR[3:0];
                Next = Fetch;
            end

            Store: begin
                D_Addr = IR[7:0];
                D_wr = 1;
                RF_Ra_addr = IR[11:8];
                Next = Fetch;
            end

            Add: begin
                RF_W_addr = IR[3:0];
                RF_W_en = 1;
                RF_Ra_addr = IR[11:8];
                RF_Rb_addr = IR[7:4];
                ALU_s0 = 3'b001;
                RF_s = 0;
                Next = Fetch;
            end

            Sub: begin
                RF_W_addr = IR[3:0];
                RF_W_en = 1;
                RF_Ra_addr = IR[11:8];
                RF_Rb_addr = IR[7:4];
                ALU_s0 = 3'b010;
                RF_s = 0;
                Next = Fetch;
            end

            Halt: begin
                Next = Halt;
            end

        endcase

    end

    always_ff @(posedge clk or negedge ResetN) begin
        if (!ResetN)
          State <= Init;
        else
          State <= Next;   // go to the state we described above
    end

endmodule


module FSM_tb;


    logic clk, ResetN;
    logic [15:0] IR;
    logic [3:0] CurrentState, NextState;
    logic PC_Clr, PC_Up;
    logic IR_Id;
    logic [7:0] D_Addr;
    logic D_wr;
    logic RF_s;
    logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
    logic RF_W_en;
    logic ALU_s0;

    FSM DUT (.*);

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end


initial begin
        ResetN = 0;
        IR = 16'd0;
        #15; // hold reset low for a few cycles

        ResetN = 1;
        #10;

        // 1. Test LOAD instruction
        IR = 16'b0010_0001_0101_0011; // Example LOAD
        #50;

        // 2. Test STORE instruction
        IR = 16'b0001_0001_0011_0101; // Example STORE
        #50;

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