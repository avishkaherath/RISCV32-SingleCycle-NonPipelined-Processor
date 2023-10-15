`timescale 1ns / 1ps

module ALU (
    input logic [3:0] ALUop,
    input logic [31:0] inA, inB,
    output logic zero,
    output logic [31:0] ALUout    
);

    always_comb begin
        ALUout = 1'd0;  zero = 1'b0;        

        case (ALUop)
                // ADD operation
            4'b0000: ALUout = inA + inB;
                // SUB operation
            4'b0001: ALUout = $signed(inA) - $signed(inB);
                // SLL operation
            4'b0010: ALUout = inA << inB;
                // SLT operation
            4'b0011: ALUout = $signed(inA) < $signed(inB);
                // SLTU operation
            4'b0100: ALUout = inA < inB;
                // XOR operation
            4'b0101: ALUout = inA ^ inB;
                // SRL operation
            4'b0110: ALUout = inA >> inB;
                // SRA operation
            4'b0111: ALUout = $signed(inA) >>> inB;
                // OR operation
            4'b1000: ALUout = inA | inB;
                // AND operation
            4'b1001: ALUout = inA & inB;
                // Default case (Pass InB to ALUout)
            default: ALUout = inB;
        endcase

        zero = (ALUout == 0);
    end

endmodule