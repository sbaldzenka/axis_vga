// project : axis_vtpg ip-core
// date    : 08.02.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

// 0x1 - color one test rgb

`timescale 1ns/100ps

module control_engine
(
    // system signals
    input  wire       i_clk,
    input  wire       i_resetn,
    // control input signals
    input  wire       i_enable,
    input  wire [3:0] i_pattern,
    // control output signals
    output reg        o_color_one_test_rgb_en
);

    localparam [3:0] COLOR_ONE_RGB = 1;

    always@(posedge i_clk) begin
        if (!i_resetn) begin
            o_color_one_test_rgb_en <= 1'b0;
        end else if (i_enable) begin
            case (i_pattern)
                COLOR_ONE_RGB: o_color_one_test_rgb_en <= 1'b1;
            endcase
        end else begin
            o_color_one_test_rgb_en <= 1'b0;
        end
    end

endmodule