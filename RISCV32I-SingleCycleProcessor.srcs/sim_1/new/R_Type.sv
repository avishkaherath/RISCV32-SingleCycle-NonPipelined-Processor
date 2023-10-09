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
    logic [3:0] ALU_op;
    logic [31:0] ALU_out;
    logic zero;
    logic RegWrite;
    logic MemtoReg, RegtoMem;
    logic [3:0] ALUOp;
    logic ALUSrc;
    logic MemWrite;
    logic Branch;
    logic MemRead;


    // Instantiate the PC module
    PC pc_inst (
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .branch_offset(branch_offset),
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
        .write_data(ALU_out),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    ALU alu (
        .A(read_data_1),
        .B(read_data_2),
        .ALU_op(ALUOp),
        .ALU_out(ALU_out),
        .zero(zero)
    );

    Controller controller (
        .instruction(instruction),
        .RegWrite(write_enable),
        .MemtoReg(MemtoReg),
        .RegtoMem(RegtoMem),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .MemRead(MemRead)
    );

    // Clock generation
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    // Testbench behavior (for simulation)
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
