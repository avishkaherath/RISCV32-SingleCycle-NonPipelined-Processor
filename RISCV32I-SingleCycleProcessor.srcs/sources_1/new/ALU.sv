`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2023 11:31:51 PM
// Design Name: 
// Module Name: ALU
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


module ALU (
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [3:0] ALU_op,
    output logic [31:0] ALU_out,
    output logic zero
    );

    always_comb 
    begin
        ALU_out = 'd0;
        zero = 'b0;

        case (ALU_op)
        4'b0000: // ADD operation
            begin
            ALU_out = A + B;
            zero = (ALU_out == 0);
            end
        4'b0001: // SUB operation
            begin
            ALU_out = $signed(A) - $signed(B);
            zero = (ALU_out == 0);
            end
        4'b0010: // SLL operation
            begin
            ALU_out = A << B;
            zero = (ALU_out == 0);
            end
        4'b0011: // SLT operation
            begin
            ALU_out = $signed(A) < $signed(B);
            end
        4'b0100: // SLTU operation
            begin
            ALU_out = A < B;
            end
        4'b0101: // XOR operation
            begin
            ALU_out = A ^ B;
            zero = (ALU_out == 0);
            end
        4'b0110: // SRL operation
            begin
            ALU_out = A >> B;
            zero = (ALU_out == 0);
            end
        4'b0111: // SRA operation
            begin
            ALU_out = $signed(A) >> B;
            zero = (ALU_out == 0);
            end
        4'b1000: // OR operation
            begin
            ALU_out = A | B;
            zero = (ALU_out == 0);
            end
        4'b1001: // AND operation
            begin
            ALU_out = A & B;
            zero = (ALU_out == 0);
            end
        default: // Default case
            begin
            ALU_out = 32'h0;
            zero = 1'b0;
            end
        endcase
    end

endmodule

