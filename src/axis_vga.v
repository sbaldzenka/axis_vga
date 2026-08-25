/*
---------------------------------------------------------------------------------------

MIT License

Copyright (c) 2026 Siarhei Baldzenka

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---------------------------------------------------------------------------------------

project     : axis_vga
version     : 1.0
date        : 08.02.2026
author      : siarhei baldzenka
e-mail      : sbaldzenka@proton.me
description : https://github.com/sbaldzenka/axis_vga

---------------------------------------------------------------------------------------
*/

`timescale 1ns/100ps

module axis_vga
#(
    parameter AXIS_DATA_WIDTH = 24,
    parameter COLOR_WIDTH     = 8,
    // Horizontal parameters
    parameter H_ACTIVE        = 640,
    parameter H_F_PORCH       = 16,
    parameter H_SYNC_P        = 96,
    parameter H_B_PORCH       = 48,
    // Vertical parameters
    parameter V_ACTIVE        = 480,
    parameter V_F_PORCH       = 11,
    parameter V_SYNC_P        = 2,
    parameter V_B_PORCH       = 31
)
(
    // system signals
    input  wire                       s_axis_clk,
    input  wire                       s_axis_resetn,
    // control
    input  wire                       i_test_en,
    // axi stram video bus
    input  wire                       s_axis_valid,
    input  wire [AXIS_DATA_WIDTH-1:0] s_axis_data,
    input  wire [                0:0] s_axis_user,
    input  wire                       s_axis_last,
    output wire                       s_axis_ready,
    // vga interface
    output wire                       o_vga_hs,
    output wire                       o_vga_vs,
    output wire [    COLOR_WIDTH-1:0] o_vga_r,
    output wire [    COLOR_WIDTH-1:0] o_vga_g,
    output wire [    COLOR_WIDTH-1:0] o_vga_b
);

    defparam vga_inst.COLOR_WIDTH = COLOR_WIDTH;
    defparam vga_inst.H_ACTIVE    = H_ACTIVE;
    defparam vga_inst.H_F_PORCH   = H_F_PORCH;
    defparam vga_inst.H_SYNC_P    = H_SYNC_P;
    defparam vga_inst.H_B_PORCH   = H_B_PORCH;
    defparam vga_inst.V_ACTIVE    = V_ACTIVE;
    defparam vga_inst.V_F_PORCH   = V_F_PORCH;
    defparam vga_inst.V_SYNC_P    = V_SYNC_P;
    defparam vga_inst.V_B_PORCH   = V_B_PORCH;

    vga vga_inst
    (
        .i_clk     ( s_axis_clk                                        ),
        .i_reset_n ( s_axis_resetn                                     ),
        .i_test_en ( i_test_en                                         ),
        .i_valid   ( s_axis_valid                                      ),
        .i_sof     ( s_axis_user[0]                                    ),
        .i_eol     ( s_axis_last                                       ),
        .i_data_r  ( s_axis_data[AXIS_DATA_WIDTH-1:AXIS_DATA_WIDTH-8]  ),
        .i_data_g  ( s_axis_data[AXIS_DATA_WIDTH-9:AXIS_DATA_WIDTH-16] ),
        .i_data_b  ( s_axis_data[AXIS_DATA_WIDTH-15:0]                 ),
        .o_ready   ( s_axis_ready                                      ),
        .o_vsync   ( o_vga_vs                                          ),
        .o_hsync   ( o_vga_hs                                          ),
        .o_r       ( o_vga_r                                           ),
        .o_g       ( o_vga_g                                           ),
        .o_b       ( o_vga_b                                           )
    );

endmodule