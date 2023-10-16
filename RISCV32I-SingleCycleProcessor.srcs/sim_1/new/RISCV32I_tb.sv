`timescale 1ns / 1ps

module RISCV32I_tb;

    logic clk = 1, rstPC = 0, rstReg = 1, rstMem = 1;

    RISCV32I processor (
        .clk(clk),
        .rstPC(rstPC),
        .rstReg(rstReg),
        .rstMem(rstMem)
    );

    // Clock generation
    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    // Testbench behavior (for simulation)
    initial begin
        rstPC = 1;
        #7
        rstPC = 0;
        #3

        #80
        // Finish the simulation
        $finish;
    end

endmodule
