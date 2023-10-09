`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2023 07:34:38 AM
// Design Name: 
// Module Name: RegFile_tb
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


module RegFile_tb;

    // Declare signals for RegFile module
    logic clk;
    logic rst_n;
    logic [4:0] read_register_1, read_register_2, write_register;
    logic write_enable;
    logic [31:0] write_data;
    logic [31:0] read_data_1, read_data_2;

    // Instantiate the RegFile module
    RegFile regfile (
        .clk(clk),
        .rst_n(rst_n),
        .read_register_1(read_register_1),
        .read_register_2(read_register_2),
        .write_register(write_register),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    // Clock signal
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    // Test stimulus
    initial begin
        // rst_n = 0; // Reset
        #10 rst_n = 1; // Normal operation

        #10;
        read_register_1 = 1;
        #10;
        read_register_1 = 2;
        #10

        // // Perform a write operation to register 3
        // #20;
        // write_register = 3;
        // write_enable = 1;
        // write_data = 32'hABCDEF01;
        // #10 write_enable = 0;

        // // Perform read operations from registers 1 and 2
        // #10;
        // read_register_1 = 1;
        // read_register_2 = 3;
        // #10;

        // rst_n = 0;
        // #10;
        // read_register_2 = 3;
        // #10;

        // End simulation
        $finish;
    end

endmodule
