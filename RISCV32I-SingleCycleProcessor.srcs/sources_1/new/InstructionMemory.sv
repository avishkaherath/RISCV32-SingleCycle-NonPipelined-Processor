`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2023 09:07:56 AM
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory (
    input logic [31:0] address,
    output logic [31:0] instruction
);

    // Define the memory contents as an array of 32-bit instructions
    logic [31:0] memory [0:63]; // 64 32-bit instructions

    // Initialize the memory with sample R-type instructions
    initial begin
        memory[0] = 32'h00A30633; // ADD x6, x1, x2
        memory[1] = 32'h00B322B3; // SUB x5, x6, x7
        memory[2] = 32'h00C34333; // AND x6, x7, x8
        memory[3] = 32'h00D3E313; // OR x1, x7, x14
        memory[4] = 32'h00E386B3; // XOR x13, x15, x7
        memory[5] = 32'h00F3C6B3; // SLL x13, x12, x15
        memory[6] = 32'h01336433; // SRL x8, x12, x6
        memory[7] = 32'h01436433; // SRA x8, x12, x6
        memory[8] = 32'h0153C733; // SLT x14, x15, x12
        memory[9] = 32'h0163E733; // SLTU x14, x15, x14
    end

    assign instruction = (address < 64) ? memory[address] : 32'h00000000; // Default to NOP if address is out of range

endmodule


