`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2023 10:50:13 AM
// Design Name: 
// Module Name: Controller
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


module Controller (
    input logic [31:0] instruction,
    output logic RegWrite,
    output logic MemtoReg, RegtoMem,
    output logic [3:0] ALUOp,
    output logic ALUSrc,
    output logic MemWrite,
    output logic Branch,
    output logic MemRead
);

    // Extract sections from instructions
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    // Instruction opcodes
    parameter R_TYPE_OPCODE = 7'b0110011;

    // Set default control signals
    assign RegWrite = 1'b1;
    assign MemtoReg = 1'b0;
    assign RegtoMem = 1'b0;
    assign ALUSrc = 1'b0;
    assign MemWrite = 2'b0; // No memory write
    assign Branch = 1'b0;
    assign MemRead = 1'b0;
    assign ALUOp = 4'b0000; // Default ALU control operation

    // Check if the instruction is an R-type instruction
    always_comb begin
        if (opcode == R_TYPE_OPCODE) begin
            // Set control signals for R-type instructions
            RegWrite = 1'b1;
            MemtoReg = 1'b0;
            RegtoMem = 1'b0;
            ALUSrc = 1'b0;
            MemWrite = 2'b0;
            Branch = 1'b0;
            MemRead = 1'b0;

            // Define cases for different ALU operations
            case (funct3)
                3'b000: // ADD/SUB
                    begin
                        if (funct7 == 7'b0000000) begin
                            ALUOp = 4'b0000; // ADD                        
                        end
                        else begin
                            ALUOp = 4'b0001; // SUB
                        end                        
                    end
                default: // Default case
                    begin
                        ALUOp = 4'b0000;
                    end
            endcase
        end
    end

endmodule