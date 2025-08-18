`timescale 1ns / 1ps

module tb_caculator ();
    reg [7:0] a, b;
    reg clk, reset;
    wire [7:0] fnd_data;
    wire [3:0] fnd_com;

    //dut: design under test
    caculator dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .fnd_data(fnd_data),
        .fnd_com(fnd_com)
    );

    always #5 clk = ~clk;

    integer i, j;

    initial begin
        // 초기 안정화
        #0;
        a = 8'h00;
        b = 8'h00;
        clk = 1'b0;
        reset = 1'b1;

        #20;
        reset = 1'b0;

        for (i = 100; i <= 110; i = i + 1) begin
            for (j = 100; j <= 110; j = j + 1) begin
                a = i;
                b = j;
                #10;
            end
        end

        $finish;
    end

endmodule
