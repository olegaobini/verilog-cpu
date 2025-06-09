onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RegisterFile_tb/clk;
add wave -noupdate /RegisterFile_tb/RF_W_en;
add wave -noupdate /RegisterFile_tb/WriteAddress;
add wave -noupdate /RegisterFile_tb/WriteData;
add wave -noupdate /RegisterFile_tb/ReadAddrA;
add wave -noupdate /RegisterFile_tb/ReadAddrB;
add wave -noupdate /RegisterFile_tb/DataOutputA;
add wave -noupdate /RegisterFile_tb/DataOutputB;
    
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