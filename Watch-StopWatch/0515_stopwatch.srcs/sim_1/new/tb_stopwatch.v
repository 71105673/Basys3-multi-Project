`timescale 1ns / 1ps

module tb_stopwatch ();

    reg clk, rst;
    reg btnL_Clear;
    reg btnR_RunStop;
    reg sw_mode;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;

    stopwatch dut (
        .clk(clk),
        .rst(rst),
        .btnL_Clear(btnL_Clear),
        .sw_mode(sw_mode),
        .btnR_RunStop(btnR_RunStop),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );

    // 100MHz clock
    always #5 clk = ~clk;

    initial begin
        // 초기화
        clk = 0;
        rst = 1;
        btnL_Clear = 0;
        sw_mode = 0;  // MSEC 모드부터 시작

        // 리셋 해제
        #100 rst = 0;

        // 스톱워치 시작
        #200 btnR_RunStop = 1;
        #20 btnR_RunStop = 0;

        // 약 500ms 기다림
        #500_000_000;

        // 모드 전환 (MSEC → MIN)
        sw_mode = 1;

        // 약 500ms 더 기다림
        #500_000_000;

        // 종료
        $finish;
    end

    // always #2 clk = ~clk;

    // initial begin

    // initial begin
    //     // reset
    //     #0;
    //     clk = 0;
    //     rst = 1;
    //     btnL_Clear = 0;
    //     // msec, sec 모드드
    //     sw_mode = 0;

    //     // 시작 모드로 넘어감
    //     #4;
    //     rst = 0;

    //     // run 으로 넘어감
    //     #2;
    //     btnR_RunStop = 1;
    //     #2;
    //     btnR_RunStop = 0;

    //     #10000;
    //     // min hour 모드 전환
    //     sw_mode = 1;

    //     #20000;
    //     // 버튼으로 stop 모드
    //     btnR_RunStop = 1;

    //     // clear 모드드
    //     #4;
    //     btnL_Clear = 1;

    //     #10;
    //     $finish;
    // end


    // // Clock generation: 10ns period (100MHz)
    // always #5 clk = ~clk;

    // initial begin
    //     // Initial values
    //     clk = 0;
    //     rst = 1;
    //     btnL_Clear = 0;
    //     btnR_RunStop = 0;
    //     sw_mode = 0;

    //     // Reset
    //     #20;
    //     rst = 0;

    //     // Start stopwatch (RUN)
    //     #20;
    //     btnR_RunStop = 1;
    //     #10;
    //     btnR_RunStop = 0;

    //     // Let it run for some time
    //     #5000;

    //     // Pause stopwatch (STOP)
    //     btnR_RunStop = 1;
    //     #10;
    //     btnR_RunStop = 0;

    //     // Wait
    //     #10000;

    //     // Resume stopwatch
    //     btnR_RunStop = 1;
    //     #10;
    //     btnR_RunStop = 0;

    //     // Run a bit more
    //     #10000;

    //     btnR_RunStop = 1;
    //     #10;
    //     btnR_RunStop = 0;

    //     #50;
    //     // Clear stopwatch
    //     btnL_Clear = 1;
    //     #10;
    //     btnL_Clear = 0;

    //     // Finish simulation
    //     #10000;
    //     $finish;
    // end

endmodule
