// project : axis_vga ip-core
// date    : 08.02.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

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

    wire test_en;

    assign test_en = 1'b0;

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
        .i_test_en ( test_en                                           ),
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