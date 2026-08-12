// project : axis_vtpg ip-core
// date    : 08.02.2026
// author  : siarhei baldzenka
// e-mail  : sbaldzenka@proton.me

`timescale 1ns/100ps

module color_one_test_rgb
#(
    parameter AXIS_DATA_WIDTH = 24
)
(
    // system signals
    input  wire                       m_axis_clk,
    input  wire                       m_axis_resetn,
    // control and status signals
    input  wire [               15:0] i_h_res,
    input  wire [               15:0] i_v_res,
    input  wire                       i_enable,
    // axi stram video bus
    output reg                        m_axis_valid,
    output reg  [AXIS_DATA_WIDTH-1:0] m_axis_data,
    output reg  [                0:0] m_axis_user,
    output reg                        m_axis_last,
    input  wire                       m_axis_ready
);

    reg [15:0] pixels_counter;
    reg [15:0] lines_counter;

    always@(posedge m_axis_clk) begin
        if (!m_axis_resetn) begin
            pixels_counter <= 'b0;
        end else begin
            if (i_enable && m_axis_ready) begin
                pixels_counter <= pixels_counter + 1'b1;

                if (pixels_counter == i_h_res - 1'b1) begin
                    pixels_counter <= 'b0;
                end
            end
        end
    end

    always@(posedge m_axis_clk) begin
        if (!m_axis_resetn) begin
            lines_counter <= 'b0;
        end else begin
            if (pixels_counter == i_h_res - 1'b1) begin
                lines_counter <= lines_counter + 1'b1;
            end

            if (pixels_counter == 'b0 && lines_counter == i_v_res) begin
                lines_counter <= 'b0;
            end
        end
    end

    always@(posedge m_axis_clk) begin
        if (i_enable) begin
            if (pixels_counter == 'b0) begin
                m_axis_valid <= 1'b1;
            end else if (pixels_counter == i_h_res) begin
                m_axis_valid <= 1'b0;
            end
        end else begin
            m_axis_valid <= 1'b0;
        end
    end

    always@(posedge m_axis_clk) begin
        if (!m_axis_resetn) begin
            m_axis_data <= 'b0;
        end else begin
            m_axis_data[7:0] <= 8'hFF;
        end
    end

    always@(posedge m_axis_clk) begin
        if (pixels_counter == 'b0 && lines_counter == 'b0) begin
            m_axis_user[0] <= 1'b1;

            if (m_axis_ready) begin
                m_axis_user[0] <= 1'b0;
            end
        end else begin
            m_axis_user[0] <= 1'b0;
        end
    end

    always@(posedge m_axis_clk) begin
        if (pixels_counter == i_h_res - 2) begin
            m_axis_last <= 1'b1;
        end else begin
            m_axis_last <= 1'b0;
        end
    end

endmodule