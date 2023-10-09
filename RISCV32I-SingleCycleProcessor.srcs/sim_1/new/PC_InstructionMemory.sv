`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2023 02:01:09 PM
// Design Name: 
// Module Name: PC_InstructionMemory
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


module PC_InstructionMemory;

    // Declare signals for the top-level module
    logic clk = 0;
    logic reset = 0;
    logic branch = 0;
    logic [31:0] branch_offset = 0;
    logic [31:0] pc_out;
    logic [31:0] instruction;

    // Instantiate the PC module
    PC pc_inst (
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .branch_offset(branch_offset),
        .pc_out(pc_out)
    );

    // Instantiate the InstructionMemory module
    InstructionMemory inst_mem (
        .address(pc_out),
        .instruction(instruction)
    );

    // Clock generation
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    // Testbench behavior (for simulation)
    initial begin

        // Test with a sequence of operations
        reset = 1; // Assert reset
        #10 reset = 0; // De-assert reset

        #10
        
        // Set the branch signal and offset as needed
        // For example:
        branch = 1;
        branch_offset = 2;
        #10;

        // Check negative offset
        branch_offset = -3;
        #10;

        // Finish the simulation
        $finish;
    end

endmodule