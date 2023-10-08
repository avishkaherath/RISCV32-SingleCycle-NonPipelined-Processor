`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2023 10:00:47 AM
// Design Name: 
// Module Name: PC_InstructionMemory_tb
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


module PC_InstructionMemory_tb;

    // Define simulation parameters
    logic clk;
    logic reset;
    logic branch;
    logic [31:0] branch_offset;
    logic [31:0] pc_out;
    logic [31:0] address;
    logic [31:0] instruction;

    // Instantiate the module under test (PC_InstructionMemory)
    PC_InstructionMemory dut (
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .branch_offset(branch_offset),
        .instruction(instruction)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Reset and stimulus generation
    initial begin
        clk = 0;
        reset = 1; // Assert reset initially
        branch = 0;
        branch_offset = 32'h00000000;

        // Release reset after some time
        #20 reset = 0;

        // Simulate some instruction fetching
        // You can add more test cases here
        #10 branch = 0; // No branch
        #10 branch = 0;
        #10 branch = 0;
        #10 branch = 0;
        // #10 branch = 1; // Branch instruction
        // branch_offset = 32'hFFFFFFF0; // A negative branch offset
        // #10 branch = 0; // No branch
        
        $finish;
    end

endmodule
