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
    input logic BrEq, BrLT,
    output logic RegWrite,
    output logic BSel, BrUn,
    output logic [1:0] WSel, branch,
    output logic memRead, memWrite,
    output logic [2:0] dataSel,
    output logic [3:0] ALUOp
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
    parameter I_TYPE_OPCODE = 7'b0010011;
    parameter LOAD_OPCODE = 7'b0000011;
    parameter STORE_OPCODE = 7'b0100011;
    parameter B_TYPE_OPCODE = 7'b1100011;
    parameter JALR_OPCODE = 7'b1100111;

    // Set default control signals
    assign RegWrite = 1'b1;
    assign BSel = 1'b0;
    assign ALUOp = 4'b0000; // Default ALU control operation
    assign memRead = 1'b0;
    assign memWrite = 1'b0;
    assign WSel = 2'b01;
    assign dataSel = 3'b0;
    assign BrUn = 1'b0;
    assign branch = 2'b00;

    // Check if the instruction is an R-type instruction
    always_comb begin
        if (opcode == R_TYPE_OPCODE) begin
            // Set control signals for R-type instructions
            RegWrite = 1'b1;
            BSel = 1'b0;
            // MemtoReg = 1'b0;
            // RegtoMem = 1'b0;
            // ALUSrc = 1'b0;
            memWrite = 1'b0;
            // Branch = 1'b0;
            memRead = 1'b0;
            WSel = 2'b01;
            branch = 2'b00;

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
                3'b001: // SLL
                    begin
                        ALUOp = 4'b0010;                        
                    end
                3'b010: // SLT
                    begin
                        ALUOp = 4'b0011;                                               
                    end
                3'b011: // SLTU
                    begin
                        ALUOp = 4'b0100;                                               
                    end
                3'b100: // XOR
                    begin
                        ALUOp = 4'b0101;                                               
                    end
                3'b101: // SRL/SRA
                    begin
                        if (funct7 == 7'b0000000) begin
                            ALUOp = 4'b0110; // SRL                       
                        end
                        else begin
                            ALUOp = 4'b0111; // SRA
                        end                        
                    end
                3'b110: // OR
                    begin
                        ALUOp = 4'b1000;                                               
                    end
                3'b111: // AND
                    begin
                        ALUOp = 4'b1001;                                               
                    end
                default: // Default case
                    begin
                        ALUOp = 4'b0000;
                    end
            endcase
        end

        if (opcode == I_TYPE_OPCODE) begin
            // Set control signals for I-type instructions
            RegWrite = 1'b1;
            BSel = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b0;
            WSel = 2'b01;
            branch = 2'b00;

            // Define cases for different ALU operations
            case (funct3)
                3'b000: // ADDI
                    begin
                        ALUOp = 4'b0000;                        
                    end
                3'b001: // SLLI
                    begin
                        ALUOp = 4'b0010;                        
                    end
                3'b010: // SLTI
                    begin
                        ALUOp = 4'b0011;                                               
                    end
                3'b011: // SLTIU
                    begin
                        ALUOp = 4'b0100;                                               
                    end
                3'b100: // XORI
                    begin
                        ALUOp = 4'b0101;                                               
                    end
                3'b101: // SRLI/SRAI
                    begin
                        if (funct7 == 7'b0000000) begin
                            ALUOp = 4'b0110; // SRLI                       
                        end
                        else begin
                            ALUOp = 4'b0111; // SRAI
                        end                        
                    end
                3'b110: // ORI
                    begin
                        ALUOp = 4'b1000;                                               
                    end
                3'b111: // ANDI
                    begin
                        ALUOp = 4'b1001;                                               
                    end
                default: // Default case
                    begin
                        ALUOp = 4'b0000;
                    end
            endcase
        end

        if (opcode == LOAD_OPCODE) begin
            // Set control signals for Load instructions
            RegWrite = 1'b1;
            BSel = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b1;
            WSel = 2'b00;
            ALUOp = 4'b0000;
            branch = 2'b00;

            dataSel = funct3;
        end

        if (opcode == STORE_OPCODE) begin
            // Set control signals for Store instructions
            RegWrite = 1'b0;
            BSel = 1'b1;
            memWrite = 1'b1;
            memRead = 1'b0;
            WSel = 2'b01;
            ALUOp = 4'b0000;
            branch = 2'b00;

            dataSel = funct3;
        end

        if (opcode == B_TYPE_OPCODE) begin
            // Set control signals for B-type instructions
            RegWrite = 1'b0;
            BSel = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b0;
            WSel = 2'bZZ;
            ALUOp = 4'b1111;
            dataSel = 3'bZ;

            case (funct3)
                3'b000: // BEQ
                    begin
                        BrUn = 1'b0;
                        if (BrEq == 1'b1) begin
                            branch = 2'b01;                     
                        end                        
                    end
                3'b001: // BNE
                    begin
                        BrUn = 1'b0;
                        if (BrEq != 1'b1) begin
                            branch = 2'b01;                     
                        end                        
                    end
                3'b100: // BLT
                    begin
                        BrUn = 1'b0;
                        if (BrLT == 1'b1) begin
                            branch = 2'b01;                     
                        end                                               
                    end
                3'b101: // BGE
                    begin
                        BrUn = 1'b0;
                        if (BrEq == 1'b1 || BrLT != 1'b1) begin
                            branch = 2'b01;                     
                        end                                               
                    end
                3'b110: // BLTU
                    begin
                        BrUn = 1'b1;
                        if (BrLT == 1'b1) begin
                            branch = 2'b01;                     
                        end                                               
                    end
                3'b111: // BGEU
                    begin
                        BrUn = 1'b1;
                        if (BrEq == 1'b1 || BrLT != 1'b1) begin
                            branch = 2'b01;                     
                        end                        
                    end            
                default: // Default case
                    begin
                        branch = 2'b00;
                    end
            endcase
        end

        if (opcode == JALR_OPCODE) begin
            // Set control signals for B-type instructions
            RegWrite = 1'b1;
            BSel = 1'b1;
            memWrite = 1'b0;
            memRead = 1'b0;
            WSel = 2'b10;
            ALUOp = 4'b0000;
            dataSel = 3'bZ;
            BrUn = 1'b0;
            branch = 2'b10;

        end
    end

endmodule