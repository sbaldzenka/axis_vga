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

---------------------------------------------------------------------------------------
*/

`timescale 1ns/100ps

module vga
#(
    parameter COLOR_WIDTH = 8,
    // Horizontal parameters
    parameter H_ACTIVE    = 640,
    parameter H_F_PORCH   = 16,
    parameter H_SYNC_P    = 96,
    parameter H_B_PORCH   = 48,
    // Vertical parameters
    parameter V_ACTIVE    = 480,
    parameter V_F_PORCH   = 11,
    parameter V_SYNC_P    = 2,
    parameter V_B_PORCH   = 31
)
(
    // system signals
    input  wire                   i_clk,
    input  wire                   i_reset_n,
    // control and status signals
    input  wire                   i_test_en,
    // data stream bus
    input  wire                   i_valid,
    input  wire                   i_sof,
    input  wire                   i_eol,
    input  wire [COLOR_WIDTH-1:0] i_data_r,
    input  wire [COLOR_WIDTH-1:0] i_data_g,
    input  wire [COLOR_WIDTH-1:0] i_data_b,
    output reg                    o_ready,
    // vga interface
    output reg                    o_vsync,
    output reg                    o_hsync,
    output reg  [COLOR_WIDTH-1:0] o_r,
    output reg  [COLOR_WIDTH-1:0] o_g,
    output reg  [COLOR_WIDTH-1:0] o_b
);

    localparam [3:0] S_H_IDLE          = 0,
                     S_H_ACTIVE_DATA   = 1,
                     S_H_FRONT_PORCH   = 2,
                     S_H_SYNC          = 3,
                     S_H_BACK_PORCH    = 4,
                     S_H_CONTROL_CHECK = 5;

    localparam [3:0] S_V_IDLE          = 0,
                     S_V_ACTIVE_DATA   = 1,
                     S_V_FRONT_PORCH   = 2,
                     S_V_SYNC          = 3,
                     S_V_BACK_PORCH    = 4,
                     S_V_CONTROL_CHECK = 5;

    reg [15:0] h_value;
    reg [15:0] v_value;

    reg [15:0] pixel_counter;
    reg [15:0] line_counter;

    reg        sof;
    reg        sof_ff;
    reg [ 7:0] frame_counter;

    reg [ 3:0] h_state;
    reg [ 3:0] v_state;

    always @(posedge i_clk) begin
        if (!i_reset_n) begin
            h_value <= 'b0;
            v_value <= 'b0;
        end else begin
            h_value <= H_ACTIVE + H_F_PORCH + H_SYNC_P + H_B_PORCH;
            v_value <= V_ACTIVE + V_F_PORCH + V_SYNC_P + V_B_PORCH;
        end
    end

    always @(posedge i_clk) begin
        if (line_counter == 'b0) begin
            sof <= 1'b1;
        end else begin
            sof <= 1'b0;
        end

        sof_ff <= sof;
    end

    always @(posedge i_clk) begin
        if (v_state == S_V_IDLE) begin
            frame_counter <= 'b0;
        end else begin
            if (sof && !sof_ff) begin
                frame_counter <= frame_counter + 1'b1;
            end
        end
    end

    always @(posedge i_clk) begin
        if (!i_reset_n) begin
            h_state <= S_H_IDLE;
        end else begin
            case (h_state)
                S_H_IDLE: begin
                    if (i_test_en || (i_valid && i_sof)) begin
                        h_state <= S_H_ACTIVE_DATA;
                    end
                end

                S_H_ACTIVE_DATA: begin
                    if (pixel_counter == H_ACTIVE - 1) begin
                        h_state <= S_H_FRONT_PORCH;
                    end
                end

                S_H_FRONT_PORCH: begin
                    if (pixel_counter == H_ACTIVE + H_F_PORCH - 1) begin
                        h_state <= S_H_SYNC;
                    end
                end

                S_H_SYNC: begin
                    if (pixel_counter == H_ACTIVE + H_F_PORCH + H_SYNC_P - 1) begin
                        h_state <= S_H_BACK_PORCH;
                    end
                end

                S_H_BACK_PORCH: begin
                    if (pixel_counter == H_ACTIVE + H_F_PORCH + H_SYNC_P + H_B_PORCH - 2) begin
                        h_state <= S_H_CONTROL_CHECK;
                    end
                end

                S_H_CONTROL_CHECK: begin
                    if (line_counter == v_value - 1) begin
                        h_state <= S_H_IDLE;
                    end else begin
                        h_state <= S_H_ACTIVE_DATA;
                    end
                end
            endcase
        end
    end

    always @(posedge i_clk) begin
        if (!i_reset_n) begin
            v_state <= S_V_IDLE;
        end else begin
            case (v_state)
                S_V_IDLE: begin
                    if (i_test_en || (i_valid && i_sof)) begin
                        v_state <= S_V_ACTIVE_DATA;
                    end
                end

                S_V_ACTIVE_DATA: begin
                    if (line_counter == V_ACTIVE) begin
                        v_state <= S_V_FRONT_PORCH;
                    end
                end

                S_V_FRONT_PORCH: begin
                    if (line_counter == V_ACTIVE + V_F_PORCH) begin
                        v_state <= S_V_SYNC;
                    end
                end

                S_V_SYNC: begin
                    if (line_counter == V_ACTIVE + V_F_PORCH + V_SYNC_P) begin
                        v_state <= S_V_BACK_PORCH;
                    end
                end

                S_V_BACK_PORCH: begin
                    if (line_counter == V_ACTIVE + V_F_PORCH + V_SYNC_P + V_B_PORCH) begin
                        v_state <= S_V_CONTROL_CHECK;
                    end
                end

                S_V_CONTROL_CHECK: begin
                    if (i_test_en || i_valid) begin
                        v_state <= S_V_ACTIVE_DATA;
                    end else begin
                        v_state <= S_V_IDLE;
                    end
                end

            endcase
        end
    end

    always @(posedge i_clk) begin
        if (h_state == S_H_IDLE) begin
            pixel_counter <= 'b0;
        end else begin
            pixel_counter <= pixel_counter + 1'b1;

            if (pixel_counter == h_value - 1) begin
                pixel_counter <= 'b0;
            end
        end
    end

    always @(posedge i_clk) begin
        if (v_state == S_V_IDLE) begin
            line_counter <= 'b0;
        end else begin
            if (h_state == S_H_CONTROL_CHECK) begin
                line_counter <= line_counter + 1'b1;
            end else if (line_counter == v_value) begin
                line_counter <= 'b0;
            end
        end
    end

    always @(posedge i_clk) begin
        if ((h_state == S_H_IDLE || h_state == S_H_ACTIVE_DATA)
            && (v_state == S_V_ACTIVE_DATA || v_state == S_V_CONTROL_CHECK)) begin
            if (line_counter < V_ACTIVE) begin
                o_ready <= 1'b1;
            end else begin
                o_ready <= 1'b0;
            end
        end else begin
            o_ready <= 1'b0;
        end
    end

    always @(posedge i_clk) begin
        if (v_state == S_H_ACTIVE_DATA && h_state == S_H_ACTIVE_DATA) begin
            if (i_test_en) begin
                o_r <= o_r + 1'b1;
                o_g <= o_g + 1'b1;
                o_b <= o_b + 1'b1;
            end else begin
                o_r <= i_data_r;
                o_g <= i_data_g;
                o_b <= i_data_b;
            end
        end else begin
            o_r <= 'b0;
            o_g <= 'b0;
            o_b <= 'b0;
        end
    end

    always @(posedge i_clk) begin
        if (v_state == S_V_SYNC) begin
            o_vsync <= 1'b0;
        end else begin
            o_vsync <= 1'b1;
        end
    end

    always @(posedge i_clk) begin
        if (h_state == S_H_SYNC) begin
            o_hsync <= 1'b0;
        end else begin
            o_hsync <= 1'b1;
        end
    end

endmodule