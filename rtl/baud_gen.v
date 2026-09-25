module baud_gen #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire rst_n,
    output reg  tick_16x
);
    localparam integer DIVIDER = CLK_FREQ / (BAUD_RATE * 16);
    localparam integer WIDTH   = $clog2(DIVIDER);

    reg [WIDTH-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= 0;
            tick_16x <= 1'b0;
        end else if (count == DIVIDER - 1) begin
            count    <= 0;
            tick_16x <= 1'b1;
        end else begin
            count    <= count + 1'b1;
            tick_16x <= 1'b0;
        end
    end
endmodule
