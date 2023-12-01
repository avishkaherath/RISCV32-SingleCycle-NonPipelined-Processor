`timescale 1ns / 1ps

module InstructionMemory (
    input clk, input reset,
    input logic [31:0] address,
    output logic [31:0] instruction
);

    parameter MEM_SIZE = 64;    // No. of memory blocks

    logic [31:0] memory [0:MEM_SIZE-1]; // Memory as an array of n(MEM_SIZE) 32-bit instructions

    always @(posedge clk) begin
        if (reset) begin
        // // R-type instructions
        // memory[0] = 32'h007302B3; // ADD
        // // memory[1] = 32'h407302B3; // SUB
        // // memory[2] = 32'h007372B3; // AND
        // // memory[3] = 32'h007362B3; // OR
        // // memory[4] = 32'h007342B3; // XOR
        // // memory[5] = 32'h007312B3; // SLL
        // // memory[6] = 32'h007352B3; // SRL
        // // memory[7] = 32'h407352B3; // SRA
        // // memory[8] = 32'h007322B3; // SLT
        // // memory[9] = 32'h007332B3; // SLTU
        // // memory[1] = 32'hFF930293; // ADDI
        // // memory[5] = 32'h00534293; // XORI
        // // memory[6] = 32'h00537293; // ANDI
        // // memory[7] = 32'h00536293; // ORI
        // // memory[2] = 32'h00932283; // LW
        // // memory[3] = 32'h01432283; // LW 2
        // // memory[3] = 32'h00931283; // LH
        // // memory[4] = 32'h00930283; // LB
        // // memory[1] = 32'h00731463; // BNE
        // // memory[1] = 32'h008302e7; // JALR
        // memory[1] = 32'h407312b3; // MUL
        // memory[2] = 32'h008324a3; // SW
        // memory[3] = 32'h008314a3; // SH
        // memory[4] = 32'h008304a3; // SB
        // memory[5] = 32'h00934283; // LBU
        // memory[6] = 32'h00935283; // LHU
        // memory[7] = 32'h00536293; // ORI

        memory[0] = 32'h00700413; // addi x8, x0, 7
        memory[1] = 32'h00300293; // addi x5, x0, 3
        memory[2] = 32'h008281b3; // add x3, x5, x8
        memory[3] = 32'h00302223; // sw x3, 4(x0)
        memory[4] = 32'h405403b3; // sub x7, x8, x5
        memory[5] = 32'h0072a323; // sw x7, 6(x5) 
        memory[6] = 32'h0012a103; // lw x2, 1(x5)
        memory[7] = 32'h00242503; // lw x10, 2(x8)
        memory[8] = 32'h00a14233; // xor x4, x2, x10
        memory[9] = 32'h004026a3; // sw x4, 13(x0)

    end
    end

    assign instruction = (address < MEM_SIZE) ? memory[address[31:2]] : 32'h00000000; // Default to NOP if address is out of range
    
endmodule