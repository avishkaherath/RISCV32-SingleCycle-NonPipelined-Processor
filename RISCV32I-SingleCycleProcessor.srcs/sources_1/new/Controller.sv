`timescale 1ns / 1ps

module Controller (
    input logic branchEq, branchLT,
    input logic [31:0] instruction,
    output logic regWrite, branchSel, unsignedComp, memRead, memWrite,
    output logic [1:0] writeSel, branch,
    output logic [2:0] dataSel,
    output logic [3:0] ALUop
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

    // Set default control signals
    assign regWrite = 1'b1; // 1
    assign branchSel = 1'b0;    // 2
    assign ALUop = 4'b0000; // 9
    assign memRead = 1'b0;  // 3
    assign memWrite = 1'b0; // 4
    assign writeSel = 2'b01;    // 7
    assign dataSel = 3'b0;  // 8
    assign unsignedComp = 1'b0; // 5
    assign branch = 2'b00;  // 6

    // Check if the instruction is an R-type instruction
    always_comb begin
        if (opcode == R_TYPE_OPCODE) begin  // Set control signals for R-type instructions
            regWrite = 1'b1; // Write enabled    
            branchSel = 1'b0; // readData2
            memWrite = 1'b0; // DataMemory write disable
            memRead = 1'b0; // DataMemory read disable
            writeSel = 2'b01; // ALUout
            dataSel = 3'b010; // Word
            unsignedComp = 1'b0; // Signed
            branch = 2'b00; // PC + 4

            case (funct3)   // Define cases for different ALU operations
                3'b000: // ADD/SUB
                    begin
                        if (funct7 == 7'b0000000) begin
                            ALUop = 4'b0000; // ADD                        
                        end
                        else begin
                            ALUop = 4'b0001; // SUB
                        end                        
                    end
                3'b001: // SLL
                    begin
                        ALUop = 4'b0010;                        
                    end
                3'b010: // SLT
                    begin
                        ALUop = 4'b0011;                                               
                    end
                3'b011: // SLTU
                    begin
                        ALUop = 4'b0100;                                               
                    end
                3'b100: // XOR
                    begin
                        ALUop = 4'b0101;                                               
                    end
                3'b101: // SRL/SRA
                    begin
                        if (funct7 == 7'b0000000) begin
                            ALUop = 4'b0110; // SRL                       
                        end
                        else begin
                            ALUop = 4'b0111; // SRA
                        end                        
                    end
                3'b110: // OR
                    begin
                        ALUop = 4'b1000;                                               
                    end
                3'b111: // AND
                    begin
                        ALUop = 4'b1001;                                               
                    end
                default: // Default case
                    begin
                        ALUop = 4'b0000;
                    end
            endcase
        end

        if (opcode == I_TYPE_OPCODE) begin  // Set control signals for I-type instructions
            regWrite = 1'b1;
            branchSel = 1'b1; // ImmGen
            memWrite = 1'b0;
            memRead = 1'b0;
            writeSel = 2'b01;
            dataSel = 3'b010;
            unsignedComp = 1'b0;
            branch = 2'b00;

            case (funct3)   // Define cases for different ALU operations
                3'b000: // ADDI
                    begin
                        ALUop = 4'b0000;                        
                    end
                3'b001: // SLLI
                    begin
                        ALUop = 4'b0010;                        
                    end
                3'b010: // SLTI
                    begin
                        ALUop = 4'b0011;                                               
                    end
                3'b011: // SLTIU
                    begin
                        ALUop = 4'b0100;                                               
                    end
                3'b100: // XORI
                    begin
                        ALUop = 4'b0101;                                               
                    end
                3'b101: // SRLI/SRAI
                    begin
                        if (funct7 == 7'b0000000) begin
                            ALUop = 4'b0110; // SRLI                       
                        end
                        else begin
                            ALUop = 4'b0111; // SRAI
                        end                        
                    end
                3'b110: // ORI
                    begin
                        ALUop = 4'b1000;                                               
                    end
                3'b111: // ANDI
                    begin
                        ALUop = 4'b1001;                                               
                    end
                default: // Default case
                    begin
                        ALUop = 4'b0000;
                    end
            endcase
        end

        if (opcode == LOAD_OPCODE) begin    // Set control signals for Load instructions
            regWrite = 1'b1;
            branchSel = 1'b1; // ImmGen
            memWrite = 1'b0;
            memRead = 1'b1; // DataMemory read enabled
            writeSel = 2'b00; // DataMemory
            ALUop = 4'b0000; // ADD
            branch = 2'b00;
            unsignedComp = 1'b0;
            dataSel = funct3; // Word, Half word, Byte
        end

        if (opcode == STORE_OPCODE) begin   // Set control signals for Store instructions
            regWrite = 1'b0; // Write disabled
            branchSel = 1'b1; // ImmGen
            memWrite = 1'b1; // DataMemory write enabled
            memRead = 1'b0;
            writeSel = 2'bZ; // Write output disabled
            ALUop = 4'b0000;    // ADD
            branch = 2'b00;
            unsignedComp = 1'b0;
            dataSel = funct3; // Word, Half word, Byte
        end

        if (opcode == B_TYPE_OPCODE) begin  // Set control signals for B-type instructions
            regWrite = 1'b0; // Write disabled
            branchSel = 1'b1; // ImmGen
            memWrite = 1'b0; 
            memRead = 1'b0;
            writeSel = 2'bZ; // Write output disabled
            ALUop = 4'b1111; // Pass immediate to ALUout
            dataSel = 3'bZ; // No DataMemory access

            case (funct3)
                3'b000: // BEQ
                    begin
                        unsignedComp = 1'b0;
                        if (branchEq == 1'b1) begin
                            branch = 2'b01;                     
                        end                        
                    end
                3'b001: // BNE
                    begin
                        unsignedComp = 1'b0;
                        if (branchEq != 1'b1) begin
                            branch = 2'b01;                     
                        end                        
                    end
                3'b100: // BLT
                    begin
                        unsignedComp = 1'b0;
                        if (branchLT == 1'b1) begin
                            branch = 2'b01;                     
                        end                                               
                    end
                3'b101: // BGE
                    begin
                        unsignedComp = 1'b0;
                        if (branchEq == 1'b1 || branchLT != 1'b1) begin
                            branch = 2'b01;                     
                        end                                               
                    end
                3'b110: // BLTU
                    begin
                        unsignedComp = 1'b1;
                        if (branchLT == 1'b1) begin
                            branch = 2'b01;                     
                        end                                               
                    end
                3'b111: // BGEU
                    begin
                        unsignedComp = 1'b1;
                        if (branchEq == 1'b1 || branchLT != 1'b1) begin
                            branch = 2'b01;                     
                        end                        
                    end            
                default: // Default case
                    begin
                        unsignedComp = 1'b0;
                        branch = 2'b00;
                    end
            endcase
        end

        if (opcode == JALR_OPCODE) begin    // Set control signals for B-type instructions
            regWrite = 1'b1;
            branchSel = 1'b1; // ImmGen
            memWrite = 1'b0;
            memRead = 1'b0;
            writeSel = 2'b10; // PC + 4
            ALUop = 4'b0000; // ADD
            dataSel = 3'bZ; // No DataMemory access
            unsignedComp = 1'bZ;
            branch = 2'b10; // Jump

        end
    end

endmodule