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
    logic [31:0] memory [0:63] = '{default: 32'h0}; // 64 32-bit instructions

    // R-type instructions
    initial begin
        memory[0] = 32'h007302B3; // ADD
        // memory[1] = 32'h407302B3; // SUB
        // memory[2] = 32'h007372B3; // AND
        // memory[3] = 32'h007362B3; // OR
        // memory[4] = 32'h007342B3; // XOR
        // memory[5] = 32'h007312B3; // SLL
        // memory[6] = 32'h007352B3; // SRL
        // memory[7] = 32'h407352B3; // SRA
        // memory[8] = 32'h007322B3; // SLT
        // memory[9] = 32'h007332B3; // SLTU
        // memory[1] = 32'hFF930293; // ADDI
        // memory[5] = 32'h00534293; // XORI
        // memory[6] = 32'h00537293; // ANDI
        // memory[7] = 32'h00536293; // ORI
        // memory[2] = 32'h00932283; // LW
        // memory[3] = 32'h01432283; // LW 2
        // memory[3] = 32'h00931283; // LH
        // memory[4] = 32'h00930283; // LB
        memory[1] = 32'h00731463; // BNE
        memory[2] = 32'h008324a3; // SW
        memory[3] = 32'h008314a3; // SH
        memory[4] = 32'h008304a3; // SB
        memory[5] = 32'h00934283; // LBU
        memory[6] = 32'h00935283; // LHU
        memory[7] = 32'h00536293; // ORI
    end

    assign instruction = (address < 64) ? memory[address[31:2]] : 32'h00000000; // Default to NOP if address is out of range
    
endmodule