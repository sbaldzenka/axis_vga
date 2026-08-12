// project : axis_vtpg ip-core
// date    : 08.02.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module axis_vtpg
#(
    parameter H_ACTIVE        = 640,
    parameter V_ACTIVE        = 480,
    parameter AXIS_DATA_WIDTH = 24
)
(
    // system signals
    input  wire                       m_axis_clk,
    input  wire                       m_axis_resetn,
    // control and status signals
    input  wire                       i_enable,
    input  wire [                3:0] i_pattern,
    // axi stram video bus
    output wire                       m_axis_valid,
    output wire [AXIS_DATA_WIDTH-1:0] m_axis_data,
    output wire [                0:0] m_axis_user,
    output wire                       m_axis_last,
    input  wire                       m_axis_ready
);

    wire                       color_one_test_rgb_en;
    wire                       color_one_test_rgb_valid;
    wire [AXIS_DATA_WIDTH-1:0] color_one_test_rgb_data;
    wire [                0:0] color_one_test_rgb_user;
    wire                       color_one_test_rgb_last;

    assign m_axis_valid = color_one_test_rgb_valid;
    assign m_axis_data  = color_one_test_rgb_data;
    assign m_axis_user  = color_one_test_rgb_user;
    assign m_axis_last  = color_one_test_rgb_last;

    control_engine control_engine_inst
    (
        .i_clk                   ( m_axis_clk            ),
        .i_resetn                ( m_axis_resetn         ),
        .i_enable                ( i_enable              ),
        .i_pattern               ( i_pattern             ),
        .o_color_one_test_rgb_en ( color_one_test_rgb_en )
    );

    defparam color_one_test_rgb_inst.AXIS_DATA_WIDTH  = AXIS_DATA_WIDTH;

    color_one_test_rgb color_one_test_rgb_inst
    (
        .m_axis_clk    ( m_axis_clk               ),
        .m_axis_resetn ( m_axis_resetn            ),
        .i_h_res       ( H_ACTIVE                 ),
        .i_v_res       ( V_ACTIVE                 ),
        .i_enable      ( color_one_test_rgb_en    ),
        .m_axis_valid  ( color_one_test_rgb_valid ),
        .m_axis_data   ( color_one_test_rgb_data  ),
        .m_axis_user   ( color_one_test_rgb_user  ),
        .m_axis_last   ( color_one_test_rgb_last  ),
        .m_axis_ready  ( m_axis_ready             )
    );

endmodule