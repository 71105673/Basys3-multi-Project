`timescale 1ns / 1ps

module tb_debounce ();

    reg  clk;
    reg  rst;
    reg  i_btn;
    wire o_btn;

    btn_debounce dut (
        .clk  (clk),
        .rst  (rst),
        .i_btn(i_btn),
        .o_btn(o_btn)
    );

    always #5 clk = ~clk;

    initial begin
        // 초기화
        clk   = 0;
        rst   = 1;
        i_btn = 0;

        // 리셋 해제
        #20 rst = 0;

        // ❗ 버튼 노이즈 시뮬레이션 (빠르게 깜빡임)
        #10 i_btn = 1;
        #10 i_btn = 0;
        #10 i_btn = 1;
        #10 i_btn = 0;
        #10 i_btn = 1;
        #10 i_btn = 0;

        // 1 되는거거
        #10 i_btn = 1;
        #10 i_btn = 1;
        #10 i_btn = 1;
        #10 i_btn = 1;
        #10 i_btn = 1;
        #10 i_btn = 1;
        #10 i_btn = 1;
        #10 i_btn = 1;
        #10 i_btn = 0;
        #10 i_btn = 1;

        #1000 $finish;
    end

endmodule

