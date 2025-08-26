`timescale 1ns / 1ps

module TOP_microwave (
    input clk,
    input btnC,
    input btnD,
    input btnU,
    output [7:0] fnd_data,
    output [3:0] fnd_com,
    output motor_in1,
    output motor_in2,
    output PWM_OUT
);

     wire btn_c_raw, btn_d_raw, btn_u_raw;
    wire btn_c, btn_d, btn_u;
    wire pwm_out;
    wire o_set, o_run;
    wire [5:0] time_cnt;
    wire finish;

    assign motor_in1 = pwm_out;  // PWM 출력으로 모터 구동
    assign motor_in2 = 0;       // 항상 0 → 정방향 회전
    assign PWM_OUT = pwm_out;

    // 버튼 디바운스 + 원펄스
    btn_debounce dbC (.clk(clk), .btn(btnC), .o_btn(btn_c_raw));
    btn_debounce dbD (.clk(clk), .btn(btnD), .o_btn(btn_d_raw));
    btn_debounce dbU (.clk(clk), .btn(btnU), .o_btn(btn_u_raw));

    one_pulse opC (.clk(clk), .in_signal(btn_c_raw), .out_pulse(btn_c));
    one_pulse opD (.clk(clk), .in_signal(btn_d_raw), .out_pulse(btn_d));
    one_pulse opU (.clk(clk), .in_signal(btn_u_raw), .out_pulse(btn_u));

    // FSM
    microwave_CU cu (
        .clk(clk),
        .btn_C(btn_c),
        .btn_D(btn_d),
        .finish(finish),
        .o_set(o_set),
        .o_run(o_run)
    );

    // 타이머
    time_counter timer (
        .clk(clk),
        .inc(btn_u & o_set),
        .run(o_run),
        .time_cnt(time_cnt),
        .finish(finish)
    );

    // 7세그먼트
    microwave_fnd display (
        .clk(clk),
        .time_cnt({2'b00, time_cnt}), // 8bit 확장
        .fnd_data(fnd_data),
        .fnd_com(fnd_com)
    );



    pwm_generator pwm_inst (
        .clk(clk),
        .enable(o_run),  // RUN 상태일 때만 PWM 동작
        .pwm_out(pwm_out)
    );



endmodule

module one_pulse (
    input clk,
    input in_signal,
    output reg out_pulse
);
    reg delay;

    always @(posedge clk) begin
        delay <= in_signal;
        out_pulse <= in_signal & ~delay;
    end
endmodule


module pwm_generator (
    input clk,
    input enable,
    output pwm_out
);
    reg [15:0] counter = 0;
    reg [15:0] duty = 45000;  // 90%

    always @(posedge clk) begin
        counter <= (counter == 49999) ? 0 : counter + 1;
    end

    assign pwm_out = (enable && counter < duty);
endmodule