`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2023 01:01:16 AM
// Design Name: 
// Module Name: FullDatapath
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


module FullDatapath;

    logic clk = 1, rstPC = 0, rstReg = 1, rstMem = 1;
    logic zero, BrEq, BrLT;
    logic [15:0] controllerOut;
    logic [31:0] address, instruction, readData1, readData2, ALUinB, writeData, ALUout, immediate, dataOut; 

    // Instantiate the PC module
    PC pc_inst (
        .clk(clk),
        .reset(rstPC),
        .branch(controllerOut[10:9]),
        .offset(ALUout),
        .PCout(address)
    );

    // Instantiate the InstructionMemory module
    InstructionMemory inst_mem (
        .address(address),
        .instruction(instruction)
    );

    RegFile reg_file (
        .clk(clk),
        .reset(rstReg),
        .readReg1(instruction[19:15]),
        .readReg2(instruction[24:20]),
        .writeReg(instruction[11:7]),
        .writeEn(controllerOut[15]),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2)
    );

    ALU alu (
        .inA(readData1),
        .inB(ALUinB),
        .ALUop(controllerOut[3:0]),
        .ALUout(ALUout),
        .zero(zero)
    );

    ControllerROM controller (
        .branchEq(BrEq),
        .branchLT(BrLT),
        .instruction(instruction),
        .controlSignal(controllerOut)
    );

    ImmGen immgen (
        .instruction(instruction),
        .immediate(immediate)
    );

    Mux2 bmux (
        .data0(readData2),
        .data1(immediate),
        .select(controllerOut[14]),
        .dataout(ALUinB)
    );

    DataMemory dataMem(
        .address(ALUout),
        .writeData(readData2),
        .memRead(controllerOut[13]),
        .memWrite(controllerOut[12]),
        .readData(dataOut),
        .clk(clk),
        .reset(rstMem),
        .dataSel(controllerOut[6:4])
    );

    Mux4 wmux (
        .data0(dataOut),
        .data1(ALUout),
        .data2(address),
        .select(controllerOut[8:7]),
        .dataout(writeData)
    );

    BranchComparator branComp (
        .inA(readData1),
        .inB(readData2),
        .unsignedComp(controllerOut[11]),
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
        rstPC = 1;
        #7
        rstPC = 0;
        #3

        #80
        // Finish the simulation
        $finish;
    end

endmodule