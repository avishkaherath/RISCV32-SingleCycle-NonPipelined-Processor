`timescale 1ns / 1ps

module ClockDivider (
    input logic onboard_clk, // input clock
    output logic clk // output clock
);

    // Divider ratio
    parameter COUNT_MAX = 1250000;

    // Internal counter
    logic [31:0] counter = 32'd0;

    always_ff @(posedge onboard_clk)
        if (counter == COUNT_MAX)
            counter <= 0;
        else
            counter <= counter + 1;

    // Output clock toggle
    always_ff @(posedge onboard_clk)
        if (counter == COUNT_MAX)
            clk <= ~clk;
        else
            clk <= clk;

endmodule
