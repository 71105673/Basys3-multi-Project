`timescale 1ns / 1ps

module tb_uart_controller ();

    reg clk, rst, rx, start;
    wire tx;

    reg [7:0] tx_data, send_data, rx_send_data;

    wire [7:0] rx_data;
    wire tx_done, rx_done, tx_busy;


    integer i;
    integer j;
    reg [7:0] rand_data;

    uart_controller U_UART (
        .clk(clk),
        .rst(rst),
        .btn_start(start),
        .rx(rx),
        .tx_din(),
        .tx_done(tx_done),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .tx_busy(tx_busy),
        .tx(tx)
    );

    always #5 clk = ~clk;


    initial begin
        #0;
        clk = 0;
        rst = 1;
        start = 0;
        rx = 1;
        #20;
        rst = 0;

        #100;
        start = 1'b1;
        #10000;
        start = 1'b0;
        #2000000;

        rx = 0;  // start
        #(10416 * 10);  // 1 % 9600
        rx = 1;  //d0
        #(10416 * 10);  // 1 % 9600
        rx = 0;
        #(10416 * 10);  // 1 % 9600
        rx = 0;
        #(10416 * 10);  // 1 % 9600
        rx = 0;
        #(10416 * 10);  // 1 % 9600
        rx = 1;
        #(10416 * 10);  // 1 % 9600
        rx = 1;
        #(10416 * 10);  // 1 % 9600
        rx = 0;
        #(10416 * 10);  // 1 % 9600
        rx = 0;  // d7
        #(10416 * 10);  // 1 % 9600
        rx = 1;  // stop

        wait (tx_done);  // wait signal
        #100;

        // 검증 test.
        rx_send_data = 8'h30;

        for (j = 0; j < 8; j = j + 1) begin
            rand_data = $random % (255);
            rx_send_data = rand_data;
            send_data_to_rx(rx_send_data);
            wait_for_rx();
        end

        $stop;

    end

    // 전송기(to)
    task send_data_to_rx(input [7:0] send_data);
        begin
            // uart rx start condition
            rx = 0;
            #(10416 * 10);
            // rx data를 보내야함 LSB 부터!! transfer
            for (i = 0; i < 8; i = i + 1) begin
                rx = send_data[i];
                #(10416 * 10);
            end
            // stop condition
            rx = 1;
            #(10416 * 3);
            $display("send_data = %h", send_data);
        end
    endtask

    //rx가 들어왔을 때, 수신 완료 검사기
    task wait_for_rx();
        begin
            wait (tx_done);
            if (rx_data == rand_data) begin
                //pass   
                $display("PASS!!!, rx_data = %h", rx_data);
            end else begin
                // fail
                $display("FAIL~~~, rx_data = %h", rx_data);
            end
        end
    endtask

endmodule
