`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2023 12:17:33 AM
// Design Name: 
// Module Name: PC_tb
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

module PC_tb;

    // Inputs
    logic clk;
    logic reset;
    logic branch;
    logic [31:0] branch_offset;

    // Outputs
    logic [31:0] pc_out;

    // Instantiate the ProgramCounter module
    PC uut (
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .branch_offset(branch_offset),
        .pc_out(pc_out)
    );

    // Clock generation
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        reset = 1;
        branch = 0;
        branch_offset = 0;

        // Wait for a few clock cycles
        #10;
        reset = 0;

        // Test case 1: Normal PC increment
        #10;
        assert(pc_out == 32'h00000004) else $display("Test case 1 failed");

        // Test case 2: Branch with positive offset
        branch = 1;
        branch_offset = 4;
        #10;
        assert(pc_out == 32'h00000014) else $display("Test case 2 failed");

        // Test case 3: Branch with negative offset
        branch = 1;
        branch_offset = -8;
        #10;
        assert(pc_out == 32'h00000000) else $display("Test case 3 failed");
        
        branch = 0;
        #10;
        
        // Finish the simulation
        $finish;
    end

endmodule