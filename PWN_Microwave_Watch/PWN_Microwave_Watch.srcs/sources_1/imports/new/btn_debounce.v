`timescale 1ns / 1ps

module btn_debounce (
    input clk,
    input btn,
    output reg o_btn
);
    reg [19:0] cnt = 0;

    always @(posedge clk) begin
        if (btn) begin
            if (cnt < 1_000_000)
                cnt <= cnt + 1;
        end else begin
            cnt <= 0;
        end

        o_btn <= (cnt == 1_000_000);
    end
endmodule