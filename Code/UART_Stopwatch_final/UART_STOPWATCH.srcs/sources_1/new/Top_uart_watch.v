`timescale 1ns / 1ps

module Top_uart_watch (
    input clk,
    input rst,
    input rx,
    input btn_start,
    output tx,
    input btnL,
    input btnR,
    input btnU,
    input btnD,
    input [1:0] sw,

    input uart_sw,
    output led_uart,

    output [3:0] led,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

    assign led_uart = uart_sw;  // uart_sw가 1이면 LED4 ON

    wire w_rx_done;
    wire [7:0] w_rx_data;

    wire w_o_clear;
    wire w_o_run;
    wire w_o_stop;
    wire w_o_watch_mode;
    wire w_o_mode;
    wire w_o_up;
    wire w_o_down;
    wire w_o_left;
    wire w_o_right;
    wire w_o_esc;

    uart_controller U_UART_CTL (
        .clk(clk),
        .rst(rst),
        .btn_start(),
        .rx(rx),
        .tx(tx),
        .rx_done(w_rx_done),
        .rx_data(w_rx_data)
    );

    command_to_btn COM_BTN (
        .clk(clk),
        .rst(rst),
        .rx_data_command(w_rx_data),
        .rx_done_command(w_rx_done),
        .o_clear(w_o_clear),
        .o_run(w_o_run),
        .o_stop(w_o_stop),
        .o_watch_mode(w_o_watch_mode),
        .o_mode(w_o_mode),
        .o_up(w_o_up),
        .o_down(w_o_down),
        .o_left(w_o_left),
        .o_right(w_o_right),
        .o_esc(w_o_esc)
    );

    // stopwatch STOPWATCH (
    //     .clk(clk),
    //     .rst(rst),
    //     .btnL(btnL | w_o_clear | w_o_left),
    //     .btnR(btnR | w_o_run | w_o_stop | w_o_right),
    //     .btnU(btnU | w_o_up),
    //     .btnD(btnD | w_o_down),
    //     .sw({w_o_watch_mode,w_o_mode} | sw),
    //     .led_out(led),
    //     .fnd_com(fnd_comm),
    //     .fnd_data(fnd_font)
    // );

    stopwatch STOPWATCH (
        .clk (clk),
        .rst (rst),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(btnU),
        .btnD(btnD),
        .sw(sw),

        .uart_sw(uart_sw),

        .watch_o_clear(w_o_clear),
        .watch_o_run(w_o_run),
        .watch_o_stop(w_o_stop),
        .watch_o_watch_mode(w_o_watch_mode),
        .watch_o_mode(w_o_mode),
        .watch_o_up(w_o_up),
        .watch_o_down(w_o_down),
        .watch_o_left(w_o_left),
        .watch_o_right(w_o_right),
        .watch_o_esc(w_o_esc),

        .led_out (led),
        .fnd_com (fnd_com),
        .fnd_data(fnd_data)
    );


endmodule
