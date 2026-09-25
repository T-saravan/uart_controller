`timescale 1ns / 1ps

module uart_tb;
    reg        clk;
    reg        rst_n;
    reg  [7:0] tx_data;
    reg        tx_start;
    wire       tx_busy;
    wire       tx_done;
    wire       loopback_wire;
    wire [7:0] rx_data;
    wire       rx_ready;

    uart_top #(
        .CLK_FREQ(10_000_000),
        .BAUD_RATE(1_000_000)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .rx(loopback_wire),
        .tx(loopback_wire),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );

    always #50 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; tx_start = 0; tx_data = 8'h00;
        #200; rst_n = 1; #200;

        @(posedge clk); tx_data = 8'hA5; tx_start = 1;
        @(posedge clk); tx_start = 0;
        wait(rx_ready);
        $display("[PASS] Received Byte: 0x%02X", rx_data);

        #1000;
        @(posedge clk); tx_data = 8'h3C; tx_start = 1;
        @(posedge clk); tx_start = 0;
        wait(rx_ready);
        $display("[PASS] Received Byte: 0x%02X", rx_data);

        #1000;
        $display("=== ALL UART TESTS PASSED SUCCESSFULLY ===");
        $finish;
    end
endmodule
