`timescale 1ns / 1ps

module microwave_CU (
    input clk,
    input btn_C,
    input btn_D,
    input finish,
    output reg o_set,
    output reg o_run
);
    parameter IDLE = 2'b00, SET = 2'b01, RUN = 2'b10;
    reg [1:0] c_state = IDLE, n_state;

    always @(posedge clk)
        c_state <= n_state;

    always @(*) begin
        case (c_state)
            IDLE: n_state = (btn_C) ? SET : IDLE;
            SET:  n_state = (btn_D) ? RUN : (btn_C ? IDLE : SET);
            RUN:  n_state = (finish) ? IDLE : (btn_D ? SET : RUN);
            default: n_state = IDLE;
        endcase
    end

    always @(*) begin
        o_set = (c_state == SET);
        o_run = (c_state == RUN);
    end
endmodule