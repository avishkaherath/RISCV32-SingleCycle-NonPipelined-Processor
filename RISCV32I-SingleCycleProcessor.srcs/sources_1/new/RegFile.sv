`timescale 1ns / 1ps

module RegFile (
    input logic clk, reset, writeEn,
    input logic [4:0]  readReg1, readReg2, writeReg, 
    input logic [31:0] writeData,
    output logic [31:0] readData1, readData2 
);

    logic [31:0] registers [31:0] = '{default: 32'h0};  // 32-bit array to store the register values
    integer i;

    // Read data from the registers
    assign readData1 = (readReg1 == 5'b0) ? 32'h0 : registers[readReg1];
    assign readData2 = (readReg2 == 5'b0) ? 32'h0 : registers[readReg2];

    initial begin   // For testing
        registers[6] = 32'd7; // Initialize register x6
        registers[7] = 32'd10; // Initialize register x7
        registers[8] = 32'h01CF5E5B; // Initialize register x8
    end

    // Write data to the registers
    always_ff @(posedge clk) begin
        if (reset == 0) registers = '{default: 32'h0};  // Synchronous active low reset     
        else if (writeEn) begin
            if (writeReg != 5'b0) registers[writeReg] <= writeData;
        end
    end

endmodule