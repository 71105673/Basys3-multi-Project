`timescale 1ns / 1ps
module time_counter (
    input clk,
    input inc,
    input run,
    output reg [5:0] time_cnt = 0,
    output finish
);
    reg [27:0] sec_cnt = 0;
    assign finish = (time_cnt == 0);

    always @(posedge clk) begin
        if (inc) begin
            if (time_cnt < 60)
                time_cnt <= time_cnt + 10;
        end else if (run && time_cnt > 0) begin
            if (sec_cnt == 100_000_000 - 1) begin
                sec_cnt <= 0;
                time_cnt <= time_cnt - 1;
            end else
                sec_cnt <= sec_cnt + 1;
        end else begin
            sec_cnt <= 0;
        end
    end
endmodule