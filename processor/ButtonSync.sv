
module ButtonSync (
    input  logic Clk,          // 50 MHz system clock
    input  logic Bi,        // raw push-button (active-low)
    output logic Bo      // stable, clock-aligned level
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