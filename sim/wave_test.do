-- project     : axis_vga
-- version     : 1.0
-- date        : 07.02.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axis_vga

-- waves:
add wave -noupdate -divider testbench
add wave -noupdate -format Logic -radix HEXADECIMAL -group {testbench} /axis_vga_tb/*

add wave -noupdate -divider DUT
add wave -noupdate -format Logic -radix HEXADECIMAL -group {DUT} /axis_vga_tb/DUT_inst/*
add wave -noupdate -format Logic -radix HEXADECIMAL -group {vga} /axis_vga_tb/DUT_inst/vga_inst/*

-- toggle leaf names command:
config wave -signalnamewidth 1