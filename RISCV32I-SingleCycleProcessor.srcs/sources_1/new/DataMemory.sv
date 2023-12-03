`timescale 1ns / 1ps

module DataMemory (
    input logic clk, reset, memRead, memWrite,
    input logic [2:0] dataSel,
    input logic [3:0] dataRead,
    input logic [31:0] address, writeData,
    output logic [3:0] dataLED,
    output logic [31:0] readData
);

    parameter MEM_SIZE = 64;    // No. of memory blocks

    logic [31:0] memory [0:MEM_SIZE-1];

    initial begin   // For testing
        memory[16] = 32'h362CE5B7; // Initialize register x16
        memory[7] = 32'd3; // Initialize register x7
    end

    always_comb begin
        if (memRead) begin    // Read from memory when memRead = 1
            case (dataSel)
                    // LB (Load Byte)
                3'b000: readData = {memory[address][7]? {24{1'b1}}: {24{1'b0}}, memory[address][7:0]};
                    // LH (Load Halfword)
                3'b001: readData = {memory[address][15]? {16{1'b1}}: {16{1'b0}}, memory[address][15:0]};
                    // LW (Load Word)
                3'b010: readData = memory[address];
                    // LBU (Load Byte Unsigned)
                3'b100: readData = {24'b0, memory[address][7:0]};
                    // LHU (Load Halfword Unsigned)
                3'b101: readData = {16'b0, memory[address][15:0]};
                    // LW (Default Load Word)
                default: readData = memory[address];        
            endcase
        end
        else readData = memory[address];
    end

    always_ff @(posedge clk) begin
        if (reset == 1) begin   // Reset the memory to all zeros                        
            memory = '{default: 32'h0};
        end
        else begin
            if (memWrite) begin     // Write to memory when memWrite = 1
                case (dataSel)
                        // SB (Store Byte)
                    3'b000: memory[address] <= {writeData[7]? {24{1'b1}}: {24{1'b0}}, writeData[7:0]};
                        // SH (Store Halfword)
                    3'b001: memory[address] <= {writeData[15]? {16{1'b1}}: {16{1'b0}}, writeData[15:0]};
                        // SW (Store Word)
                    3'b010: memory[address] <= writeData;
                        // SW (Default Store Word)
                    default: memory[address] <= writeData;                        
                endcase
            end
        end
    end

    always @(*) begin
        dataLED <= memory[{{28{1'b0}}, dataRead}][3:0];
    end 

endmodule