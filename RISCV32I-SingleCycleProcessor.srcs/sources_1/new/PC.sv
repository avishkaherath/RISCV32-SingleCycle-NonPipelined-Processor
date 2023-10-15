`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 10:55:02 PM
// Design Name: 
// Module Name: PC
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


module PC (
    input logic clk,
    input logic reset,
    input logic [1:0] branch,
    input logic [31:0] branch_offset,
    output logic [31:0] pc_out
);

    // Register to hold the program counter
    logic [31:0] pc_reg;

    always_ff @(posedge clk) begin

        if (reset)
            pc_reg <= 32'h00000000;  // Reset the PC to 0
        else if (branch == 2'b01) begin
            // branch_offset_temp = $signed(branch_offset); // Convert to signed value
            // branch_offset_temp = {{31{branch_offset_temp[31]}}, branch_offset_temp}; // Sign-extend to 32 bits
            // branch_offset_temp = branch_offset << 2; // Word Addressing (maintain boundary) // change branch_offset to branch_offset_temp

            if ($signed(pc_reg + branch_offset) >= 0)
                pc_reg <= pc_reg + branch_offset; // Update PC if result is non-negative
            else
                pc_reg <= 32'h00000000; // Reset PC to 0 if result is negative
        end
        else if (branch == 2'b10) begin
            if ($signed(branch_offset) >= 0) begin
                pc_reg <= {branch_offset[30:0], 1'b0}; // Update PC if result is non-negative
            end
        end
        else
            pc_reg <= pc_reg + 4;   // Increment PC by 4 for the next instruction
    end

    assign pc_out = pc_reg;

endmodule

