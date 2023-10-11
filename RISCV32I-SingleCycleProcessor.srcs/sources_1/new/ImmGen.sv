`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 06:04:26 PM
// Design Name: 
// Module Name: ImmGen
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

module ImmGen(
  input logic [31:0] instruction,
  output logic [31:0] immediate
);

  logic [6:0] opcode = instruction[6:0];
  logic [5:0] funct3 = instruction[14:12];
  logic [11:0] imm1 = instruction[31:20];
  logic [4:0] imm2 = instruction[11:7];

  always_comb begin
    case (opcode)
        7'b1100111, 7'b0000011: immediate[11:0] = imm1;   // JALR, LB, LH, etc ...
        7'b0010011: begin
            if (funct3 == 3'b001 || funct3 == 3'b101) begin
                immediate[11:0] = {imm1[4]? 7'b1: 7'b0 , imm1[4:0]};   // SLLI, SRLI, SRAI            
            end
            else begin
                immediate[11:0] = imm1;   // ADDI, SLTI, SLTIU, etc ...
            end                        
        end
        
        7'b1100011: immediate[11:0] = {imm1[11], imm2[0], imm1[10:0], imm2[4:1]};   // BEQ, BNE BLT, etc ...

        default: immediate[11:0] = 12'b0;   // Default case
    endcase

    // Sign-extend the immediate
    if (immediate[11]) begin
        immediate[31:12] = {20'b1};
    end
    else begin
        immediate[31:12] = {20'b0};
    end
  end

endmodule