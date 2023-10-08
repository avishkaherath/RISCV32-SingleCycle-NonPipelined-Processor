`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2023 09:50:05 AM
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


module PC_InstructionMemory

    // Inputs and outputs for the PC module
    input logic clk;
    input logic reset;
    input logic branch;
    input logic [31:0] branch_offset;
    logic [31:0] pc_out;

    // Inputs and outputs for the Instruction Memory module
    logic [31:0] address;
    output logic [31:0] instruction;

    // Instantiate the PC module
    PC pc (
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .branch_offset(branch_offset),
        .pc_out(pc_out)
    );

    // Instantiate the Instruction Memory module
    InstructionMemory im (
        .address(address),
        .instruction(instruction)
    );

    // Connect the PC output to the Instruction Memory address input
    assign address = pc_out;

    // Your code here - You can add additional logic for instruction execution, etc.

    // Example: Print the fetched instruction to the console
    always_ff @(posedge clk) begin
        $display("Fetched Instruction: 0x%h", instruction);
    end

    // Your code here - You can add more functionality as needed

endmodule