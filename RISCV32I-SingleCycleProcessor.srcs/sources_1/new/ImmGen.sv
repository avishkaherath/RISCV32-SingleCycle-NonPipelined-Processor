`timescale 1ns / 1ps

module ImmGen(
    input logic [31:0] instruction,
    output logic [31:0] immediate
);

    logic [6:0] opcode; assign opcode = instruction[6:0];
    logic [5:0] funct3; assign funct3 = instruction[14:12];
    logic [11:0] imm1; assign imm1 = instruction[31:20];
    logic [4:0] imm2; assign imm2 = instruction[11:7];

    always_comb begin
        case (opcode)
            7'b1100111, 7'b0000011: immediate = {imm1[11]? {20{1'b1}}: {20{1'b0}}, imm1};   // JALR, LB, LH, etc ...

            7'b0010011: begin
                if (funct3 == 3'b001 || funct3 == 3'b101) begin
                    immediate = {27'b0, imm1[4:0]};   // SLLI, SRLI, SRAI
                end
                else begin
                    immediate = {imm1[11]? {20{1'b1}}: {20{1'b0}}, imm1};   // ADDI, SLTI, SLTIU, etc ...
                end                        
            end

            7'b1100011: immediate = {imm1[11]? {19{1'b1}}: {19{1'b0}}, imm1[11], imm2[0], imm1[10:5], imm2[4:1], 1'b0};   // BEQ, BNE BLT, etc ...

            7'b0100011: immediate = {imm1[11]? {20{1'b1}}: {20{1'b0}}, imm1[11:5], imm2};   // SB, SH, SW

            default: immediate = 32'b0;   // Default case
        endcase
    end

endmodule