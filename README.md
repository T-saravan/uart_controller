# Synthesizable UART Controller in Verilog

A parameterized, synthesizable Universal Asynchronous Receiver/Transmitter (UART) core designed in Verilog HDL.

## Architecture
- **Baud Rate Generator (`rtl/baud_gen.v`)**: Configurable clock divider producing a 16x oversampling clock tick.
- **Transmitter (`rtl/uart_tx.v`)**: FSM serializing 8-bit data with start/stop framing (8-N-1).
- **Receiver (`rtl/uart_rx.v`)**: 16x oversampled receiver with double-flop input synchronizer and mid-bit sampling.
- **Top Module (`rtl/uart_top.v`)**: Integrated top-level design.
- **Testbench (`sim/uart_tb.v`)**: Self-checking loopback testbench.

## Simulation
```bash
iverilog -o sim/uart_tb.vvp rtl/*.v sim/uart_tb.v
vvp sim/uart_tb.vvp
```
