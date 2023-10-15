`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 06:48:03 PM
// Design Name: 
// Module Name: JALR
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


module JALR;

    logic clk = 1;
    logic rst_pc = 0;
    logic [1:0] branch = 2'b00;
    logic [31:0] address;
    logic [31:0] instruction;
    logic rst_reg = 1;
    logic rst_mem = 1;
    logic write_enable = 1;
    logic [31:0] read_data_1, read_data_2, alu_B, write_data;
    logic [31:0] ALU_out;
    logic zero, memRead, memWrite;
    logic BSel, BrUn, BrEq, BrLT;
    logic [1:0] WSel;
    logic [3:0] ALUOp;
    logic [2:0] readSel;
    logic [31:0] immediate, data_out;

    // Instantiate the PC module
    PC pc_inst (
        .clk(clk),
        .reset(rst_pc),
        .branch(branch),
        .offset(ALU_out),
        .PCout(address)
    );

    // Instantiate the InstructionMemory module
    InstructionMemory inst_mem (
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
        .writeData(write_data),
        .readData1(read_data_1),
        .readData2(read_data_2)
    );

    ALU alu (
        .inA(read_data_1),
        .inB(alu_B),
        .ALUop(ALUOp),
        .ALUout(ALU_out),
        .zero(zero)
    );

    Controller controller (
        .instruction(instruction),
        .RegWrite(write_enable),
        .BSel(BSel),
        .WSel(WSel),
        .ALUOp(ALUOp),
        .dataSel(readSel),
        .memRead(memRead),
        .memWrite(memWrite),
        .branch(branch),
        .BrUn(BrUn),
        .BrEq(BrEq),
        .BrLT(BrLT)
    );

    ImmGen immgen (
        .instruction(instruction),
        .immediate(immediate)
    );

    Mux2 bmux (
        .data0(read_data_2),
        .data1(immediate),
        .select(BSel),
        .dataout(alu_B)
    );

    DataMemory dataMem(
        .address(ALU_out),
        .writeData(read_data_2),
        .memRead(memRead),
        .memWrite(memWrite),
        .readData(data_out),
        .clk(clk),
        .reset(rst_mem),
        .dataSel(readSel)
    );

    Mux4 wmux (
        .data0(data_out),
        .data1(ALU_out),
        .data2(address),
        .select(WSel),
        .dataout(write_data)
    );

    BranchComparator branComp (
        .inA(read_data_1),
        .inB(read_data_2),
        .unsignedComp(BrUn),
        .equal(BrEq),
        .lessThan(BrLT)
    );

    // Clock generation
    always begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

    // Testbench behavior (for simulation)
    initial begin
        rst_pc = 1;
        #7
        rst_pc = 0;
        #3

        #80
        // Finish the simulation
        $finish;
    end

endmodule
