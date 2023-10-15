`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 03:41:04 PM
// Design Name: 
// Module Name: BranchComparator
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


module BranchComparator (
    input logic [31:0] input1,    // First 32-bit input
    input logic [31:0] input2,    // Second 32-bit input
    input logic unsignedComp,    // Unsigned = 1, Signed = 0
    output logic equal,          // Output indicating equality
    output logic less_than      // Output indicating less than
);
    always_comb begin

        if (unsignedComp) begin
            assign equal = ($unsigned(input1) == $unsigned(input2));
            assign less_than = ($unsigned(input1) < $unsigned(input2));
        end
        else begin
            assign equal = ($signed(input1) == $signed(input2));
            assign less_than = ($signed(input1) < $signed(input2));
        end
    end

endmodule
