
module DmemReg(clk, Dmem_write, D_addr, Reg_write, Reg_w_addr, Reg_Ra_addr, Reg_Rb_addr, A, B);
    input logic clk;
    
    // for data memory
    input Dmem_write;          // write enable
    input [7:0] D_addr;       // data address

    // for register file
    input Reg_write;          // write enable for register file
    input [4:0] Reg_w_addr;   // write address for register file
    input [4:0] Reg_Ra_addr;  // read address A
    input [4:0] Reg_Rb_addr;  // read address B

    //output
    output logic [15:0] A, B;       // read data from register file

    //wires
    wire logic [16:0] DmemReg_data; // data output from data memory to register file

    DataMemory Dmem (
        .clock(clk),
        .address(D_addr),
        .data(A),           //
        .wren(Rmem_write),
        .q(DmemReg_data) //16 bit data from data mem to register file
        );

    RegisterFile mem (
        .clk(clk), 
        .write(Reg_write), 
        .WriteAddress(Reg_w_addr), 
        .WriteData(DmemReg_data), 
        .ReadAddrA(Reg_Ra_addr), 
        .ReadAddrB(Reg_Rb_addr), 
        .DataOutputA(A), 
        .DataOutputB(B));

endmodule