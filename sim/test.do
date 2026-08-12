-- project : vga ip-core
-- date    : 07.02.2026
-- author  : siarhei baldzenka
-- e-mail  : sbaldzenka@proton.me

vlib work
vmap work work

vlog ../tb/axis_vga_tb.v
vlog ../tb/axis_vtpg.v
vlog ../tb/control_engine.v
vlog ../tb/color_one_test_rgb.v

vlog ../src/axis_vga.v
vlog ../src/vga_1.v

vsim -t 1ps -voptargs=+acc -lib work -L work axis_vga_tb

do wave_test.do
view wave
run 2000 ms