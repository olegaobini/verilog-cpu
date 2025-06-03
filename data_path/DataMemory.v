module DataMemory(clk, D_wr, D_Addr, W_data, R_data);
   input logic clk; // clock signal
   input Logic D_wr; // write enable signal

   input logic [7:0] D_Addr; // 8 bits to address 256 locations. This is the address input to the memory.
   
   input logic [15:0] W_data; // write data input (data to be written to the memory from the register file)
   output logic [15:0] R_data; // read data output (data read from the memory to the mux/register file)

   // 256 x 16-bit memory
   logic [15:0] mem [0:255];

   always_ff @(posedge clk) begin
      if (D_wr) begin             
         mem[D_Addr] <= W_data; // Write data to memory at the specified address 

      end
   end
  
   // Read operation (combinational)
   assign R_data = mem[D_Addr]; // Read data from memory at the specified address

endmodule