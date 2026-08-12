-- project : vga ip-core
-- date    : 07.02.2026
-- author  : siarhei baldzenka
-- e-mail  : sbaldzenka@proton.me

add wave -noupdate -divider testbench
add wave -noupdate -format Logic -radix HEXADECIMAL -group {testbench} /axis_vga_tb/*

add wave -noupdate -divider axis_vtpg
add wave -noupdate -format Logic -radix HEXADECIMAL -group {axis_vtpg} /axis_vga_tb/axis_vtpg_inst/*

add wave -noupdate -divider color_one_test_rgb
add wave -noupdate -format Logic -radix HEXADECIMAL -group {color_one_test_rgb} /axis_vga_tb/axis_vtpg_inst/color_one_test_rgb_inst/*

add wave -noupdate -divider DUT
add wave -noupdate -format Logic -radix HEXADECIMAL -group {DUT} /axis_vga_tb/DUT_inst/*

add wave -noupdate -divider vga
add wave -noupdate -format Logic -radix HEXADECIMAL -group {vga} /axis_vga_tb/DUT_inst/vga_inst/*

configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps 