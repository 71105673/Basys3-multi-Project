`timescale 1ns / 1ps
module dht_11_top_fnd (
    input clk,
    input rst,
    input btn_start,
    output [2:0] state_led,
    //output dht11_done,
    //output dht11_valid,
    output [7:0] fnd_data,
    output [3:0] fnd_com,
    inout dht11_io
);

    wire w_btn_start;

    wire [7:0] w_t_data, w_rh_data;

    btn_debounce U_BTN_Dboun (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btn_start),
        .o_btn(w_btn_start)
    );

    fnd_controller U_FND_CNTL (
        .clk(clk),
        .reset(rst),
        .rh_data(w_rh_data),
        .t_data(w_t_data),
        .fnd_data(fnd_data),
        .fnd_com(fnd_com)
    );

    dht11_controller U_DHT11_CNTL (
        .clk(clk),
        .rst(rst),
        .start(w_btn_start),
        .state_led(state_led),
        .rh_data(w_rh_data),
        .t_data(w_t_data),
        .dht11_done(),
        .dht11_valid(),
        .dht11_io(dht11_io)
    );

endmodule
