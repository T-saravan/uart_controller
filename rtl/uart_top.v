module uart_top #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx,
    output wire       tx,
    input  wire [7:0] tx_data,
    input  wire       tx_start,
    output wire       tx_busy,
    output wire       tx_done,
    output wire [7:0] rx_data,
    output wire       rx_ready
);

    wire tick_16x;

    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_baud_gen (
        .clk(clk),
        .rst_n(rst_n),
        .tick_16x(tick_16x)
    );

    uart_tx u_uart_tx (
        .clk(clk),
        .rst_n(rst_n),
        .tick_16x(tick_16x),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    uart_rx u_uart_rx (
        .clk(clk),
        .rst_n(rst_n),
        .tick_16x(tick_16x),
        .rx(rx),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );

endmodule
