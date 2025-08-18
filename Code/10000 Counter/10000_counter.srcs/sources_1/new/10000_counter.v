`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////////
/////////////////***** 10000진 counter_top_Module *****////////////////////
///////////////////////////////////////////////////////////////////////////

module top_10000_counter (
    input clk,
    input reset,
    input [1:0] sw,
    output [7:0] fnd_data,
    output [3:0] fnd_com
);

    wire w_clk_100Hz;
    wire [13:0] w_count_data;

    wire [5:0] w_sec;
    wire [5:0] w_min;

    assign w_count_data = (w_min % 10) * 100 + (w_sec / 10) * 10 + (w_sec % 10);

    wire w_run_stop_clk;
    wire w_clear;
    assign w_run_stop_clk = clk & sw[0];
    assign w_clear = reset | sw[1];

    clk_div_100Hz #(
        .F_COUNT(100_000_000)
    ) U_CLK_DIV_100Hz (
        .clk(w_run_stop_clk),
        .reset(w_clear),
        .o_clk_100hz(w_clk_100Hz)
    );

    counter_60 U_COUNTER_60 (
        .clk  (w_clk_100Hz),
        .reset(w_clear),
        .sec  (w_sec),
        .min  (w_min)
    );

    fnd_controller U_FND_CNTL (
        .clk(clk),
        .reset(reset),
        .count_data(w_count_data),
        .fnd_data(fnd_data),
        .fnd_com(fnd_com)
    );

    // counter_10000 U_COUNTER_10000 (
    //     .clk(clk),
    //     .reset(reset),
    //     .count_data(w_count_data)
    // );

endmodule

//////////////////////////////////////////////////////////////////////////
//************************************************************************
//////////////////////////////////////////////////////////////////////////

/////////////******** Clk divider_100Hz ********///////////// 

module clk_div_100Hz #(
    parameter F_COUNT = 1_000_000
) (
    input  clk,
    input  reset,
    output o_clk_100hz
);
    reg [$clog2(F_COUNT) - 1:0] r_counter;
    reg r_clk;

    assign o_clk_100hz = r_clk;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk     <= 1'b0;
        end else begin
            if (r_counter == F_COUNT - 1) begin
                r_counter <= 0;
                r_clk     <= 1'b1;  // 100Hz 클럭 
            end else if (r_counter >= F_COUNT / 2) begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end else begin  // 모든 경우 처리하려고고
                r_counter <= r_counter + 1;
            end
        end
    end


endmodule

/////////////////////////////////////////////////////////////

////////////////******** 60진 Counter ********/////////////// 

module counter_60 (
    input clk,
    input reset,
    output reg [5:0] sec,  // 0~59
    output reg [5:0] min  // 0~59
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sec <= 0;
            min <= 0;
        end else begin
            if (sec == 6'd59) begin
                sec <= 0;
                if (min == 6'd59) min <= 0;
                else min <= min + 1;
            end else begin
                sec <= sec + 1;
            end
        end
    end
endmodule

/////////////////////////////////////////////////////////////

//////////////******** 10,000진 Counter ********///////////// 

module counter_10000 (
    input             clk,        // 클럭
    input             reset,      // 비동기 리셋 (active-low)
    output reg [13:0] count_data  // 14비트 출력
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_data <= 14'd0;
        end else begin
            if (count_data == 14'd9999) count_data <= 14'd0;
            else count_data <= count_data + 1'b1;
        end
    end

endmodule

/////////////////////////////////////////////////////////////

