`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 02:14:07 AM
// Design Name: 
// Module Name: DataMemory
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


module DataMemory (
    input logic [31:0] address,
    input logic [31:0] write_data,
    input logic memRead, memWrite,
    output logic [31:0] read_data,
    input logic clk,
    input logic reset
);

    logic [31:0] memory [0:63] = '{default: 32'h0};
    assign read_data = 32'b0;

    initial begin
        memory[16] = 32'd26; // Initialize register x16 with 26
        memory[7] = 32'd3; // Initialize register x7 with 3
    end

    always_comb begin
        if (memRead) begin
                // Read from memory when memRead = 1
                read_data <= memory[address];
            end
    end

    always_ff @(posedge clk) begin
        if (reset == 0) begin
            // Reset the memory to all zeros            
            memory = '{default: 32'h0};
        end
        else begin
            if (memWrite) begin
                // Write to memory when memWrite = 1
                memory[address] <= write_data;
            end
        end
    end

endmodule