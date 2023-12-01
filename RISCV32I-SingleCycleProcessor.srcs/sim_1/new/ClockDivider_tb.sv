`timescale 1ns / 1ps

module ClockDivider_tb;

    logic onboard_clk;
    logic clk;

    // Instantiate the ClockDivider module
    ClockDivider uut (
        .onboard_clk(onboard_clk),
        .clk(clk)
    );

    // Clock generation
    initial begin
        onboard_clk = 0;
        forever #4 onboard_clk = ~onboard_clk;
    end

    // Simulation time
    initial begin
        // Simulate for 1 ms
        #40000000;

        // End simulation
        $finish;
    end

endmodule