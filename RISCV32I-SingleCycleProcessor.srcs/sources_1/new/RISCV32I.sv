`timescale 1ns / 1ps

module RISCV32I(
    input logic clk, rstPC, rstReg, rstMem
);

    logic zero, BrEq, BrLT;
    logic [15:0] controllerOut;
    logic [31:0] address, instruction, readData1, readData2, ALUinB, writeData, ALUout, immediate, dataOut; 

    PC pc (
        .clk(clk),
        .reset(rstPC),
        .branch(controllerOut[10:9]),
        .offset(ALUout),
        .PCout(address)
    );

    InstructionMemory instMem (
        .address(address),
        .instruction(instruction)
    );

    RegFile regFile (
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

    ImmGen immGen (
        .instruction(instruction),
        .immediate(immediate)
    );

    Mux2 bMux (
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

    Mux4 wMux (
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

endmodule
