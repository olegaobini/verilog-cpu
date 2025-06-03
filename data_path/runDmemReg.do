# Create work library
vlib work

# Compile Altera libraries
vmap altera_mf C:/intelFPGA_lite/20.1/modelsim_ase/altera/verilog/altera_mf

vlog C:/intelFPGA_lite/20.1/modelsim_ase/altera/verilog/src/altera_mf.v

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./DmemReg.sv"
vlog "./DataMemory.v"
vlog "./RegisterFile.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work DmemReg_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do DmemRegwave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
