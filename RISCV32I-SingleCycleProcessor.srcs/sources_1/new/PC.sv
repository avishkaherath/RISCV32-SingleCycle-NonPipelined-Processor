`timescale 1ns / 1ps

module PC (
    input logic clk, reset,
    input logic [1:0] branch, // branch = 1 | jump = 2
    input logic [31:0] offset,
    output logic [31:0] PCout
);
    
    logic [31:0] PCreg; // Register to hold the program counter

    always_ff @(posedge clk) begin
            // Reset the PC to 0 if reset = 1
        if (reset) PCreg <= 32'h00000000;
            // select = 1   
        else if (branch == 2'b01) PCreg <= PCreg + offset; // Add offset to PC
            // select = 2
        else if (branch == 2'b10) PCreg <= {offset[30:0], 1'b0}; // Jump PC
        else PCreg <= PCreg + 4; // Increment PC by 4 for the next instruction
    end

    assign PCout = PCreg;

endmodule