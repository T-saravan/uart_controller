module uart_top #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx,
    output wire       tx,
    input  wire [7:0] tx_data,
    input  wire       tx_start,
    output wire [7:0] rx_data,
    output wire       rx_ready
);

    // Submodule instantiations will go here

endmodule
