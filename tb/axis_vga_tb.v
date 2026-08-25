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
date        : 07.02.2026
author      : siarhei baldzenka
e-mail      : sbaldzenka@proton.me
description : https://github.com/sbaldzenka/axis_vga

              Pixel clock = 25 MHz:
              //----------------------------- 640x480@60Hz
              // Horizontal parameters
              parameter H_ACTIVE  = 640,
              parameter H_F_PORCH = 16,
              parameter H_SYNC_P  = 96,
              parameter H_B_PORCH = 48,
              // Vertical parameters
              parameter V_ACTIVE  = 480,
              parameter V_F_PORCH = 11,
              parameter V_SYNC_P  = 2,
              parameter V_B_PORCH = 31
              // ----------------------------- 800x600@60Hz
              // Horizontal parameters
              parameter H_ACTIVE  = 800,
              parameter H_F_PORCH = 40,
              parameter H_SYNC_P  = 128,
              parameter H_B_PORCH = 88,
              // Vertical parameters
              parameter V_ACTIVE  = 600,
              parameter V_F_PORCH = 1,
              parameter V_SYNC_P  = 4,
              parameter V_B_PORCH = 23
              // ----------------------------- 800x600@72Hz
              // Horizontal parameters
              parameter H_ACTIVE  = 800,
              parameter H_F_PORCH = 56,
              parameter H_SYNC_P  = 120,
              parameter H_B_PORCH = 64,
              // Vertical parameters
              parameter V_ACTIVE  = 600,
              parameter V_F_PORCH = 37,
              parameter V_SYNC_P  = 6,
              parameter V_B_PORCH = 23
              // ----------------------------- 800x600@76Hz
              // Horizontal parameters
              parameter H_ACTIVE  = 800,
              parameter H_F_PORCH = 16,
              parameter H_SYNC_P  = 80,
              parameter H_B_PORCH = 160,
              // Vertical parameters
              parameter V_ACTIVE  = 600,
              parameter V_F_PORCH = 1,
              parameter V_SYNC_P  = 2,
              parameter V_B_PORCH = 21
              // ----------------------------- 1024x768@70Hz
              // Horizontal parameters
              parameter H_ACTIVE  = 800,
              parameter H_F_PORCH = 40,
              parameter H_SYNC_P  = 128,
              parameter H_B_PORCH = 88,
              // Vertical parameters
              parameter V_ACTIVE  = 600,
              parameter V_F_PORCH = 1,
              parameter V_SYNC_P  = 4,
              parameter V_B_PORCH = 23

---------------------------------------------------------------------------------------
*/

`timescale 1ns/100ps

module axis_vga_tb
#(
    // sim parameters
    parameter PIXEL_CLOCK_PERIOD = 40, // 25 MHz
    // dut parameters
    parameter AXIS_DATA_WIDTH    = 24,
    parameter COLOR_WIDTH        = 8,
    // Horizontal parameters
    parameter H_ACTIVE           = 640,
    parameter H_F_PORCH          = 16,
    parameter H_SYNC_P           = 96,
    parameter H_B_PORCH          = 48,
    // Vertical parameters
    parameter V_ACTIVE           = 480,
    parameter V_F_PORCH          = 11,
    parameter V_SYNC_P           = 2,
    parameter V_B_PORCH          = 31
);

    reg                        clk;
    reg                        resetn;

    reg                        test_en;

    wire                       m_axis_valid;
    wire [AXIS_DATA_WIDTH-1:0] m_axis_data;
    wire [                0:0] m_axis_user;
    wire                       m_axis_last;
    wire                       m_axis_ready;

    wire                       vga_vsync;
    wire                       vga_hsync;
    wire [    COLOR_WIDTH-1:0] vga_r;
    wire [    COLOR_WIDTH-1:0] vga_g;
    wire [    COLOR_WIDTH-1:0] vga_b;

    initial begin
        clk = 1'b0;
    end

    always #(PIXEL_CLOCK_PERIOD/2) clk = ~clk;

    initial begin
             resetn = 1'b1;
        #100 resetn = 1'b0;
        #40  resetn = 1'b1;
    end

    initial begin
             test_en = 1'b0;
        #500 test_en = 1'b1;
    end

    defparam DUT_inst.AXIS_DATA_WIDTH = AXIS_DATA_WIDTH;
    defparam DUT_inst.COLOR_WIDTH     = COLOR_WIDTH;
    defparam DUT_inst.H_ACTIVE        = H_ACTIVE;
    defparam DUT_inst.H_F_PORCH       = H_F_PORCH;
    defparam DUT_inst.H_SYNC_P        = H_SYNC_P;
    defparam DUT_inst.H_B_PORCH       = H_B_PORCH;
    defparam DUT_inst.V_ACTIVE        = V_ACTIVE;
    defparam DUT_inst.V_F_PORCH       = V_F_PORCH;
    defparam DUT_inst.V_SYNC_P        = V_SYNC_P;
    defparam DUT_inst.V_B_PORCH       = V_B_PORCH;

    axis_vga DUT_inst
    (
        .s_axis_clk    ( clk          ),
        .s_axis_resetn ( resetn       ),
        .i_test_en     ( test_en      ),
        .s_axis_valid  ( m_axis_valid ),
        .s_axis_data   ( m_axis_data  ),
        .s_axis_user   ( m_axis_user  ),
        .s_axis_last   ( m_axis_last  ),
        .s_axis_ready  ( m_axis_ready ),
        .o_vga_hs      ( vga_hsync    ),
        .o_vga_vs      ( vga_vsync    ),
        .o_vga_r       ( vga_r        ),
        .o_vga_g       ( vga_g        ),
        .o_vga_b       ( vga_b        )
    );

endmodule