`timescale 1ns / 1ps

module microwave_fnd (
    input clk,
    input [7:0] time_cnt,
    output [7:0] fnd_data,
    output [3:0] fnd_com

);
    reg sel = 0;
    reg [15:0] div = 0;
    wire [3:0] digit = (sel == 0) ? (time_cnt % 10) : (time_cnt / 10);
    wire [7:0] seg_out;

    always @(posedge clk) begin
        div <= div + 1;
        if (div == 50000) begin
            div <= 0;
            sel <= ~sel;
        end
    end

    assign fnd_com = (sel == 0) ? 4'b1110 : 4'b1101;

    bcd decoder (
        .bcd(digit),
        .fnd_data(seg_out)
    );

    assign fnd_data = seg_out;
endmodule

module bcd (
    input [3:0] bcd,
    output reg [7:0] fnd_data
);
    always @(*) begin
        case (bcd)
            4'h0: fnd_data = 8'hC0;
            4'h1: fnd_data = 8'hF9;
            4'h2: fnd_data = 8'hA4;
            4'h3: fnd_data = 8'hB0;
            4'h4: fnd_data = 8'h99;
            4'h5: fnd_data = 8'h92;
            4'h6: fnd_data = 8'h82;
            4'h7: fnd_data = 8'hF8;
            4'h8: fnd_data = 8'h80;
            4'h9: fnd_data = 8'h90;
            default: fnd_data = 8'hFF;
        endcase
    end
endmodule