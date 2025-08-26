`timescale 1ns / 1ps

module tb_10000_counter();
    reg clk;
    reg reset;
    wire [7:0] fnd_data;
    wire [3:0] fnd_com;

    top_10000_counter dut (
        .clk(clk),
        .reset(reset),
        .fnd_data(fnd_data),
        .fnd_com(fnd_com)
    );

    always #5 clk = ~clk;  

    initial begin
        clk   = 0;
        reset = 1;
        #20;
        reset = 0;  // reset 해제 → 여기서부터 count 시작
        #600_000;
        $finish;
    end

endmodule