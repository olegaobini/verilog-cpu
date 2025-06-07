onerror {resume}
radix define radix_FSMStates {
    "4'd0" "Init",
    "4'd1" "Fetch",
    "4'd2" "Decode",
    "4'd3" "LoadA",
    "4'd4" "LoadB",
    "4'd5" "Store",
    "4'd6" "Add",
    "4'd7" "Sub",
    "4'd8" "Halt",
    -default hexadecimal
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FSM_tb/Clock
add wave -noupdate /FSM_tb/IR
add wave -noupdate /FSM_tb/Clock
add wave -noupdate /FSM_tb/ResetN
add wave -noupdate /FSM_tb/PC_clr
add wave -noupdate /FSM_tb/IR_Id
add wave -noupdate /FSM_tb/PC_up
add wave -noupdate /FSM_tb/D_addr
add wave -noupdate /FSM_tb/D_wr
add wave -noupdate /FSM_tb/RF_s
add wave -noupdate /FSM_tb/RF_Ra_addr
add wave -noupdate /FSM_tb/RF_Rb_addr
add wave -noupdate /FSM_tb/RF_W_en
add wave -noupdate /FSM_tb/RF_W_addr
add wave -noupdate /FSM_tb/ALU_s0
add wave -noupdate /FSM_tb/CurrentState
add wave -noupdate /FSM_tb/NextState

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
