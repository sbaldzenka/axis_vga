// project : vga ip-core
// date    : 07.02.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

/*
    // ----------------------------- 640x480@60Hz
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
*/

`timescale 1ns/100ps

module axis_vga_tb
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
);

    parameter PIXEL_CLOCK_PERIOD = 40; // 25 MHz

    reg                        clk;
    reg                        resetn;

    reg                        en;
    reg [                 3:0] pattern;

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
             en      = 1'b0;
             pattern = 4'h0;

        #500 en      = 1'b1;
             pattern = 4'h1;
    end

    defparam axis_vtpg_inst.H_ACTIVE         = H_ACTIVE;
    defparam axis_vtpg_inst.V_ACTIVE         = V_ACTIVE;
    defparam axis_vtpg_inst.AXIS_DATA_WIDTH  = AXIS_DATA_WIDTH;

    axis_vtpg axis_vtpg_inst
    (
        .m_axis_clk    ( clk          ),
        .m_axis_resetn ( resetn       ),
        .i_enable      ( en           ),
        .i_pattern     ( pattern      ),
        .m_axis_valid  ( m_axis_valid ),
        .m_axis_data   ( m_axis_data  ),
        .m_axis_user   ( m_axis_user  ),
        .m_axis_last   ( m_axis_last  ),
        .m_axis_ready  ( m_axis_ready )
    );

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