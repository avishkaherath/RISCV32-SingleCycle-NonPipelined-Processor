`timescale 1ns / 1ps

module ControllerROM(
    input logic branchEq, branchLT,
    input logic [31:0] instruction,
    output logic [15:0] controlSignal
);

    logic [6:0] opcode; assign opcode = instruction[6:0];
    logic [2:0] funct3; assign funct3 = instruction[14:12];
    logic [6:0] funct7; assign funct7 = instruction[31:25];

    // Instruction opcodes
    parameter R_TYPE_OPCODE = 7'b0110011;
    parameter I_TYPE_OPCODE = 7'b0010011;
    parameter LOAD_OPCODE = 7'b0000011;
    parameter STORE_OPCODE = 7'b0100011;
    parameter B_TYPE_OPCODE = 7'b1100011;
    parameter JALR_OPCODE = 7'b1100111;

    always_comb begin
        case (opcode)
            R_TYPE_OPCODE: controlSignal = {12'b10_00_0_00_01_010, funct7[5], funct3};
            I_TYPE_OPCODE: case (funct3)
                3'b101: controlSignal = {12'b11_00_0_00_01_010, funct7[5], funct3}; 
                default: controlSignal = {12'b11_00_0_00_01_010, 1'b0, funct3};
            endcase
            LOAD_OPCODE: controlSignal = {12'b11_10_0_00_00, funct3, 4'b0000};
            STORE_OPCODE: controlSignal = {12'b01_01_0_00_ZZ, funct3, 4'b0000};
            B_TYPE_OPCODE: case ({funct3[2], funct3[0]})
                2'b00: controlSignal = {4'b01_00, funct3[1], 1'b0, branchEq, 9'bZZ_ZZZ_1111};   // BEQ
                2'b01: controlSignal = {4'b01_00, funct3[1], 1'b0, ~branchEq, 9'bZZ_ZZZ_1111};  // BNE
                2'b10: controlSignal = {4'b01_00, funct3[1], 1'b0, branchLT, 9'bZZ_ZZZ_1111};   // BLT, BLTU
                2'b11: controlSignal = {4'b01_00, funct3[1], 1'b0, ~branchLT, 9'bZZ_ZZZ_1111};  // BGE, BGEU
                default: controlSignal = {4'b01_00, funct3[1], 2'b00, 9'bZZ_ZZZ_1111};  // Default - no branch
            endcase
            JALR_OPCODE: controlSignal = {16'b11_00_Z_10_10_ZZZ_0000};

            default: controlSignal = {16'b1_0_0_0_0_00_01_000_0000};    // regWrite, branchSel, memRead, memWrite, unsignedComp, branch, writeSel, dataSel, ALUop
        endcase
    end

endmodule