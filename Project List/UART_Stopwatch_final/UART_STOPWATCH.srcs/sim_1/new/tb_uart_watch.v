`timescale 1ns / 1ps

module tb_uart_watch ();
    // input
    reg clk;
    reg rst;
    reg rx;
    reg btn_start;
    reg [1:0] sw;

    reg btnL;
    reg btnR;
    reg btnU;
    reg btnD;

    // output
    wire tx;
    wire [3:0] led;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;

    Top_uart_watch dut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .btn_start(btn_start),
        .tx(tx),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(btnU),
        .btnD(btnD),
        .sw(sw),
        .led(led),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );

    // clkock generation
    always #5 clk = ~clk;

    // UART send Task
    task uart_send_byte;
        input [7:0] data;
        integer i;
        begin
            // Start bit
            rx = 0;
            #(10416 * 10);

            // Send 8 bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(10416 * 10);
            end

            // Stop bit
            rx = 1;
            #(10416 * 10);
        end
    endtask


    initial begin
        // Initialize Inputs
        clk  = 0;
        rst  = 1;
        rx   = 1;
        btnL = 0;
        btnR = 0;
        btnU = 0;
        btnD = 0;
        sw   = 2'b00;

        // Reset pulse
        #100;
        rst = 0;

        // Wait before sending
        #10000;

        // Send all uppercase command characters
        uart_send_byte("N");  // Watch -> stopwatch mode
        #(200000 * 10);

        uart_send_byte("G");  // Run
        #(200000 * 10);

        uart_send_byte("S");  // stop
        #(200000 * 10);

        uart_send_byte("C");  // clear
        #(200000 * 10);

        uart_send_byte(8'h1B);  // esc -> rst
        #(200000 * 10);

        uart_send_byte("N");  // stopwatch -> Realwatch mode
        #(200000 * 10);

        uart_send_byte("U");  // Up -> sec 올리기
        #(200000 * 10);

        uart_send_byte("M");  // Mode -> hour로 전환
        #(200000 * 10);

        uart_send_byte("L");  // Left
        #(200000 * 10);

        uart_send_byte("U");  // Up -> min 올리기
        #(200000 * 10);

        uart_send_byte("D");  // Down -> min 낮추기기
        #(200000 * 10);

        uart_send_byte("L");  // Left -> hour 선택
        #(200000 * 10);

        uart_send_byte("U");  // Up -> hour 올리기
        #(200000 * 10);

        uart_send_byte("R");  // Right -> min 선택
        #(200000 * 10);

        uart_send_byte("U");  // Up -> min 올리기
        #(200000 * 10);

        uart_send_byte(8'h1B);  // esc -> rst
        #(200000 * 10);

        $finish;
    end

endmodule
