`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 05:05:07 PM
// Design Name: 
// Module Name: DataMemory_tb
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


module DataMemory_tb;

    reg [31:0] address;
    reg [31:0] write_data;
    reg memRead, memWrite;
    wire [31:0] read_data;
    reg clk;
    reg reset;

    // Instantiate the DataMemory module
    DataMemory dut (
        .address(address),
        .write_data(write_data),
        .memRead(memRead),
        .memWrite(memWrite),
        .read_data(read_data),
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Initialize signals
    initial begin
        clk = 0;
        reset = 1;
        address = 0;
        write_data = 0;
        memRead = 0;
        memWrite = 0;

        // Test case 1: Write to memory
        #10 address = 16;
        write_data = 29;
        memWrite = 1;

        // Test case 2: Read from memory
        #10 address = 7;
        memWrite = 0;
        memRead = 1;

        #10 memRead = 0;
        // Finish simulation
        $finish;
    end

endmodule