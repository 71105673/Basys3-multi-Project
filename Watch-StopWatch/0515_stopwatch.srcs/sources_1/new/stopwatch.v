`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////
/******************************** Top Module *******************************/
//////////////////////////////////////////////////////////////////////////////
module stopwatch (
    input        clk,
    input        rst,
    input        btnL,
    input        btnR,
    input        btnU,
    input        btnD,
    input  [1:0] sw,
    output [3:0] led_out,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

    wire w_btnL, w_btnR, w_btnU, w_btnD;
    wire w_runstop, w_clear;

    wire [6:0] watch_msec, stop_msec, out_msec;
    wire [5:0] watch_sec, stop_sec, out_sec;
    wire [5:0] watch_min, stop_min, out_min;
    wire [4:0] watch_hour, stop_hour, out_hour;

    wire o_w_btnL, o_w_btnR, o_w_btnU, o_w_btnD;

    LED U_LED (
        .sw (sw),
        .led(led_out)
    );

    btn_debounce U_btn_left (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnL),
        .o_btn(w_btnL)
    );

    btn_debounce U_btn_right (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnR),
        .o_btn(w_btnR)
    );

    btn_debounce U_btn_up (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnU),
        .o_btn(w_btnU)
    );

    btn_debounce U_btn_down (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnD),
        .o_btn(w_btnD)
    );

    stopwatch_cu U_StopWatch_CU (
        .clk(clk),
        .rst(rst),
        .i_btn_runstop(w_btnR),
        .i_btn_clear(w_btnL),
        .o_runstop(w_runstop),
        .o_clear(w_clear)
    );

    stopwatch_dp U_StopWatch_DP (
        .clk(clk),
        .rst(rst),
        .run_stop(w_runstop),
        .clear(w_clear),
        .msec(stop_msec),
        .sec(stop_sec),
        .min(stop_min),
        .hour(stop_hour)
    );

    realwatch_cu U_RealWatch_CU (
        .clk(clk),
        .rst(rst),
        .i_up(w_btnU),
        .i_down(w_btnD),
        .i_move_left(w_btnL),
        .i_move_right(w_btnR),
        .o_up(o_w_btnU),
        .o_down(o_w_btnD),
        .o_move_right(o_w_btnR),
        .o_move_left(o_w_btnL)
    );


    realwatch_dp U_RealWatch_DP (
        .clk(clk),
        .rst(rst),
        .up(o_w_btnU),
        .down(o_w_btnD),
        .moveL(o_w_btnL),
        .moveR(o_w_btnR),
        .msec(watch_msec),
        .sec(watch_sec),
        .min(watch_min),
        .hour(watch_hour)
    );

    mux_2x1_watch_stopwatch U_mux_2x1_watch_stopwatch (
        .sel(sw[1]),
        .s_msec(stop_msec),
        .s_sec(stop_sec),
        .s_min(stop_min),
        .s_hour(stop_hour),
        .w_msec(watch_msec),
        .w_sec(watch_sec),
        .w_min(watch_min),
        .w_hour(watch_hour),
        .o_msec(out_msec),
        .o_sec(out_sec),
        .o_min(out_min),
        .o_hour(out_hour)
    );

    fnd_controller U_FND_CNTL (
        .clk(clk),
        .reset(rst),
        .sw_mode(sw[0]),
        .msec(out_msec),
        .sec(out_sec),
        .min(out_min),
        .hour(out_hour),
        .fnd_data(fnd_data),
        .fnd_com(fnd_com)
    );


endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////



module mux_2x1_watch_stopwatch (
    input sel,
    input [6:0] s_msec,
    input [5:0] s_sec,
    input [5:0] s_min,
    input [4:0] s_hour,
    input [6:0] w_msec,
    input [5:0] w_sec,
    input [5:0] w_min,
    input [4:0] w_hour,
    output reg [6:0] o_msec,
    output reg [5:0] o_sec,
    output reg [5:0] o_min,
    output reg [4:0] o_hour
);
    always @(*) begin
        case (sel)
            1'b0: begin
                o_msec = w_msec;
                o_sec  = w_sec;
                o_min  = w_min;
                o_hour = w_hour;
            end
            1'b1: begin
                o_msec = s_msec;
                o_sec  = s_sec;
                o_min  = s_min;
                o_hour = s_hour;
            end
        endcase
    end
endmodule

module LED (
    input [1:0] sw,
    output reg [3:0] led
);
    always @(*) begin
        case (sw)
            2'b00:   led = 4'b0001;
            2'b01:   led = 4'b0010;
            2'b10:   led = 4'b0100;
            2'b11:   led = 4'b1000;
            default: led = 0;
        endcase
    end


endmodule
