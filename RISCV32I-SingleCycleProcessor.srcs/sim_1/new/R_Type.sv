`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2023 11:18:27 AM
// Design Name: 
// Module Name: R_Type
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


module R_Type;

    logic clk = 0;
    logic reset = 0;
    logic branch = 0;
    logic [31:0] branch_offset = 0;
    logic [31:0] address;
    logic [31:0] instruction;
    logic rst_reg = 1;
    logic write_enable;
    logic [31:0] read_data_1, read_data_2;
    logic [31:0] ALU_out;
    logic zero;
    logic BSel = 0;
    logic [3:0] ALUOp;

    PC pc_inst (
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .offset(branch_offset),
        .PCout(address)
    );

    InstructionMemory inst_mem (
        .clk(clk),
        .reset(reset),
        .address(address),
        .instruction(instruction)
    );

    RegFile reg_file (
        .clk(clk),
        .reset(rst_reg),
        .readReg1(instruction[19:15]),
        .readReg2(instruction[24:20]),
        .writeReg(instruction[11:7]),
        .writeEn(write_enable),
        .writeData(ALU_out),
        .readData1(read_data_1),
        .readData2(read_data_2)
    );

    ALU alu (
        .inA(read_data_1),
        .inB(read_data_2),
        .ALUop(ALUOp),
        .ALUout(ALU_out),
        .zero(zero)
    );

    Controller controller (
        .instruction(instruction),
        .RegWrite(write_enable),
        .BSel(BSel),
        .ALUOp(ALUOp)
    );

    // Clock generation
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    // Start simulation
    initial begin
        reset = 1;
        #7
        reset = 0;
        #3

        #95
        // Finish the simulation
        $finish;
    end

endmodule