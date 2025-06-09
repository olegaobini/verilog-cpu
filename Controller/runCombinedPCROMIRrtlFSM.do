# turn on verbage
transcript on

# Get rid of current work lib
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}

# Create work library and map it to 'work'
vlib rtl_work
vmap work rtl_work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog -work work +acc +cover "./CombinedPCROMIR.sv"
vlog -work work +acc +cover "./IR.sv"
vlog -work work +acc +cover "./PC.sv"
vlog -work work +acc +cover "./InstMemory.v"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc" -fsmdebug  CombinedPCROMIR_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do waveCombinedPCROMIR.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# View the entire wave display
wave zoomfull

# End
