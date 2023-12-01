`timescale 1ns / 1ps

module RISCV32I_tb;

    logic clk = 1, rstPC = 0, rstReg = 0;

    RISCV32I processor (
        .clk(clk),
        .rstPC(rstPC),
        .rstData(rstReg),
        .sw(4'b0000)
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

        #100
        // Finish the simulation
        $finish;
    end

endmodule
