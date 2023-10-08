`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2023 01:42:03 PM
// Design Name: 
// Module Name: InstructionMemory_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory_tb;

    // Declare signals for the testbench
    logic [31:0] address;
    logic [31:0] instruction;
    reg clk = 0;

    // Instantiate the InstructionMemory module
    InstructionMemory inst_mem (
        .address(address),
        .instruction(instruction)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Testbench behavior
    initial begin
        
        address = 0;
        // Read the first 5 instructions
        for (int i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            address = address + 1;
        end

        // Read an out-of-range address
        address = 100;

        // Read the last instruction
        address = 9;

        // Finish the simulation
        $finish;
    end

endmodule