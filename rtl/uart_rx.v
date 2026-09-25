module uart_rx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tick_16x,
    input  wire       rx,
    output reg  [7:0] rx_data,
    output reg        rx_ready
);
    localparam [1:0] IDLE  = 2'b00,
                     START = 2'b01,
                     DATA  = 2'b10,
                     STOP  = 2'b11;

    reg [1:0] state;
    reg [3:0] tick_count;
    reg [2:0] bit_idx;
    reg [7:0] rx_shift;

    reg rx_sync1, rx_sync2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_sync1 <= 1'b1;
            rx_sync2 <= 1'b1;
        end else begin
            rx_sync1 <= rx;
            rx_sync2 <= rx_sync1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            rx_ready   <= 1'b0;
            rx_data    <= 8'd0;
            tick_count <= 4'd0;
            bit_idx    <= 3'd0;
            rx_shift   <= 8'd0;
        end else begin
            rx_ready <= 1'b0;

            case (state)
                IDLE: begin
                    if (!rx_sync2) begin
                        state      <= START;
                        tick_count <= 4'd0;
                    end
                end

                START: begin
                    if (tick_16x) begin
                        if (tick_count == 4'd7) begin
                            if (!rx_sync2) begin
                                tick_count <= 4'd0;
                                bit_idx    <= 3'd0;
                                state      <= DATA;
                            end else begin
                                state <= IDLE;
                            end
                        end else begin
                            tick_count <= tick_count + 1'b1;
                        end
                    end
                end

                DATA: begin
                    if (tick_16x) begin
                        if (tick_count == 4'd15) begin
                            tick_count        <= 4'd0;
                            rx_shift[bit_idx] <= rx_sync2;
                            if (bit_idx == 3'd7) begin
                                state <= STOP;
                            end else begin
                                bit_idx <= bit_idx + 1'b1;
                            end
                        end else begin
                            tick_count <= tick_count + 1'b1;
                        end
                    end
                end

                STOP: begin
                    if (tick_16x) begin
                        if (tick_count == 4'd15) begin
                            state    <= IDLE;
                            rx_data  <= rx_shift;
                            rx_ready <= 1'b1;
                        end else begin
                            tick_count <= tick_count + 1'b1;
                        end
                    end
                end
            endcase
        end
    end
endmodule
