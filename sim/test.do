-- project     : axis_vga
-- version     : 1.0
-- date        : 07.02.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axis_vga

vlib work
vmap work work

vlog ../tb/axis_vga_tb.v

vlog ../src/axis_vga.v
vlog ../src/vga.v

vsim -t 1ps -voptargs=+acc -lib work -L work axis_vga_tb

do wave_test.do
view wave
run 2000 ms