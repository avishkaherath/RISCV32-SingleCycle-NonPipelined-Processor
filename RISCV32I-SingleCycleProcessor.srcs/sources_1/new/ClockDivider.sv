`timescale 1ns / 1ps

module ClockDivider #(parameter FREQ = 62500000) // 62.5MHz Clock;
(
    input logic onboard_clk, // input clock
    output logic clk // output clock
);

    // Divider ratio
    localparam COUNT_MAX =  125000000 / (FREQ * 2) - 1; // 125MHz Board Clock

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
