//testbench of RAM
//Week 8, 2025

`timescale 1 ps / 1 ps
module TestRAM();
  logic [7:0]Addr;
  logic [15:0]Din, Dout;
  logic Clk, Wren;
  logic [15:0]x,y;
 
  myRAM1 dut(
	.address(Addr),
	.clock(Clk),
	.data(Din),
	.wren(Wren),
	.q(Dout));

  always begin
   Clk=1'b0; #10;
   Clk=1'b1; #10;
  end

  initial begin
    Addr=8'd0;
    @(negedge Clk) Addr=8'd5; Wren=1'b1; Din=16'd10;
    @(posedge Clk) #2; $display("the data at location %d", Addr, "is %d", Dout);
    x=Dout;
@(negedge Clk)Addr=8'd41; Din=16'd20;
    @(posedge Clk) #2; $display("the data at location %d", Addr, "is %d", Dout);
    y=Dout;
    Din=x+y;
    @(posedge Clk) #2; $display("the data at location %d", Addr, "is %d", Dout);
@(posedge Clk) #2; $display("the data at location %d", Addr, "is %d", Dout);
$stop;
  end

endmodule