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
        .branch_offset(ALU_out),
        .pc_out(address)
    );

    // Instantiate the InstructionMemory module
    InstructionMemory inst_mem (
        .address(address),
        .instruction(instruction)
    );

    RegFile reg_file (
        .clk(clk),
        .rst_n(rst_reg),
        .read_register_1(instruction[19:15]),
        .read_register_2(instruction[24:20]),
        .write_register(instruction[11:7]),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    ALU alu (
        .A(read_data_1),
        .B(alu_B),
        .ALU_op(ALUOp),
        .ALU_out(ALU_out),
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
        .BSel(BSel),
        .dataout(alu_B)
    );

    DataMemory data_mem(
        .address(ALU_out),
        .write_data(read_data_2),
        .memRead(memRead),
        .memWrite(memWrite),
        .read_data(data_out),
        .clk(clk),
        .reset(rst_mem),
        .data_sel(readSel)
    );

    Mux4 wmux (
        .data0(data_out),
        .data1(ALU_out),
        .data2(address),
        .Sel(WSel),
        .dataout(write_data)
    );

    BranchComparator branComp (
        .input1(read_data_1),
        .input2(read_data_2),
        .unsignedComp(BrUn),
        .equal(BrEq),
        .less_than(BrLT)
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
