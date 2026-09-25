module uart_tx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tick_16x,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_busy,
    output reg        tx_done
);
    localparam [1:0] IDLE  = 2'b00,
                     START = 2'b01,
                     DATA  = 2'b10,
                     STOP  = 2'b11;

    reg [1:0] state;
    reg [3:0] tick_count;
    reg [2:0] bit_idx;
    reg [7:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            tx         <= 1'b1;
            tx_busy    <= 1'b0;
            tx_done    <= 1'b0;
            tick_count <= 4'd0;
            bit_idx    <= 3'd0;
            data_reg   <= 8'd0;
        end else begin
            tx_done <= 1'b0;

            case (state)
                IDLE: begin
                    tx      <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        tx_busy    <= 1'b1;
                        data_reg   <= tx_data;
                        state      <= START;
                        tick_count <= 4'd0;
                    end
                end

                START: begin
                    tx <= 1'b0;
                    if (tick_16x) begin
                        if (tick_count == 4'd15) begin
                            tick_count <= 4'd0;
                            bit_idx    <= 3'd0;
                            state      <= DATA;
                        end else begin
                            tick_count <= tick_count + 1'b1;
                        end
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_idx];
                    if (tick_16x) begin
                        if (tick_count == 4'd15) begin
                            tick_count <= 4'd0;
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
                    tx <= 1'b1;
                    if (tick_16x) begin
                        if (tick_count == 4'd15) begin
                            state   <= IDLE;
                            tx_done <= 1'b1;
                            tx_busy <= 1'b0;
                        end else begin
                            tick_count <= tick_count + 1'b1;
                        end
                    end
                end
            endcase
        end
    end
endmodule
