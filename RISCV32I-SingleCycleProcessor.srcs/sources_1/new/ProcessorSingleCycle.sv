`timescale 1ns / 1ps


module ProcessorSingleCycle(
    input logic onboard_clk, rstPC, rstData,
    input logic [3:0] sw,
    output logic [3:0] LED
    );

    logic clk;

    ClockDivider clock (
        .onboard_clk(onboard_clk),
        .clk(clk)
    );

    RISCV32I riscDatapath (
        .clk(clk),
        .rstPC(rstPC),
        .rstData(rstData),
        .sw(sw),
        .LED(LED)
    );

endmodule
