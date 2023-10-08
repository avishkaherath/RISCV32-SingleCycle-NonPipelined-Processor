`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2023 03:51:23 PM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb;

    // Inputs
    logic [31:0] A;
    logic [31:0] B;
    logic [3:0] ALU_op;

    // Outputs
    logic [31:0] ALU_out;
    logic zero;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .A(A),
        .B(B),
        .ALU_op(ALU_op),
        .ALU_out(ALU_out),
        .zero(zero)
    );

    initial begin
        // Test ADD operation
        A = 32'h00000001;
        B = 32'h00000002;
        ALU_op = 4'b0000;
        #10;
        if (ALU_out !== 32'h00000003 || zero !== 0) $error("Test failed for ADD operation");

        // Test SUB operation
        A = 32'h00000003;
        B = 32'h00000002;
        ALU_op = 4'b0001;
        #10;
        if (ALU_out !== 32'h00000001 || zero !== 0) $error("Test failed for SUB operation");

        // Test SLL operation
        A = 32'h00000001;
        B = 5;
        ALU_op = 4'b0010;
        #10;
        if (ALU_out !== 32'h00000020 || zero !== 0) $error("Test failed for SLL operation");

        // Test SLT operation
        A = 32'h00000001;
        B = 32'h00000002;
        ALU_op = 4'b0011;
        #10;
        if (ALU_out !== 1 || zero !== 0) $error("Test failed for SLT operation");

        // Test SLTU operation
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        ALU_op = 4'b0100;
        #10;
        if (ALU_out !== 0 || zero !== 0) $error("Test failed for SLTU operation");

        // Test XOR operation
        A = 32'h00000001;
        B = 32'h00000003;
        ALU_op = 4'b0101;
        #10;
        if (ALU_out !== 32'h00000002 || zero !== 0) $error("Test failed for XOR operation");

        // Test SRL operation
        A = 32'h80000000;
        B = 1;
        ALU_op = 4'b0110;
        #10;
        if (ALU_out !== 32'h40000000 || zero !== 0) $error("Test failed for SRL operation");

        // Test SRA operation
        A = 32'h80000000;
        B = 1;
        ALU_op = 4'b0111;
        #10;
        if (ALU_out !== 32'hC0000000 || zero !== 0) $error("Test failed for SRA operation");

        // Test OR operation
        A = 32'h00000001;
        B = 32'h00000002;
        ALU_op = 4'b1000;
        #10;
        if (ALU_out !== 32'h00000003 || zero !== 0) $error("Test failed for OR operation");

        // Test AND operation
        A = 32'h00000001;
        B = 32'h00000003;
        ALU_op = 4'b1001;
        #10;
        if (ALU_out !== 32'h00000001 || zero !== 0) $error("Test failed for AND operation");

        // Test default operation
        A = 32'h00000001;
        B = 32'h00000002;
        ALU_op = 4'b1111;
        #10;
        if (ALU_out !== 32'h00000000 || zero !== 1) $error("Test failed for default operation");

        $display("All tests passed");
        // Finish the simulation
        $finish;
    end

endmodule

