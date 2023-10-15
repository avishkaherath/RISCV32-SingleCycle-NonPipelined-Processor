`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2023 12:18:42 AM
// Design Name: 
// Module Name: RegFile
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


module RegFile
(
    input logic clk,                    // Clock
    input logic [4:0]  read_register_1, // Read Register 1 index
    input logic [4:0]  read_register_2, // Read Register 2 index
    input logic [4:0]  write_register,  // Write Register index
    input logic write_enable,           // Write enable signal
    input logic [31:0] write_data,      // Data to be written
    input logic rst_n,                  // Reset
    output logic [31:0] read_data_1,    // Data read from Register 1
    output logic [31:0] read_data_2     // Data read from Register 2
);

    // Declare an array to store the register values
    logic [31:0] registers [31:0] = '{default: 32'h0};
    integer i;

    // Read data from the registers
    assign read_data_1 = (read_register_1 == 5'b0) ? 32'h0 : registers[read_register_1];
    assign read_data_2 = (read_register_2 == 5'b0) ? 32'h0 : registers[read_register_2];

    initial begin
        registers[6] = 32'd7; // Initialize register x6 with 7 (10)
        registers[7] = 32'd10; // Initialize register x7 with 10
        registers[8] = 32'h01CF5E5B; // Initialize register x8
    end


    // Write data to the registers
    always_ff @(posedge clk) begin
        if (rst_n == 0) begin   // Synchronous active low reset            
            registers = '{default: 32'h0};
        end 
        else if (write_enable) begin
            if (write_register != 5'b0) begin
                registers[write_register] <= write_data;
            end
        end
    end

endmodule