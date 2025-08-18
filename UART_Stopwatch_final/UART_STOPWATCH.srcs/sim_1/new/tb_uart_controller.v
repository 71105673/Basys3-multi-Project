`timescale 1ns / 1ps

module tb_uart_controller ();

    reg clk;
    reg rst;
    reg btn_start;
    reg rx;
    wire rx_done;
    wire [7:0] rx_data;
    wire tx;


    uart_controller dut (
        .clk(clk),
        .rst(rst),
        .btn_start(btn_start),
        .rx(rx),
        .rx_done(rx_done),
        .rx_data(rx_data),
        .tx(tx)
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
        clk = 0;
        rst = 1;
        rx  = 1;

        // Reset pulse
        #100;
        rst = 0;

        // Reset pulse
        #20;
        rst = 1'b0;

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
