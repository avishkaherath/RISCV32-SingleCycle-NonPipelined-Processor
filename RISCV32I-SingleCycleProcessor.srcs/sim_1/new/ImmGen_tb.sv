`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 08:37:42 PM
// Design Name: 
// Module Name: ImmGen_tb
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


module ImmGen_tb;
    logic [31:0] instruction;
    logic [31:0] immediate;

  // Instantiate the ImmGen module
    ImmGen immgen (
        .instruction(instruction),
        .immediate(immediate)
    );

  // Stimulus generation
  initial begin
    // Test case 1: I-Format ADDI instruction with a positive immediate value
    instruction = 32'h00f30713;
    #10;
    if (immediate !== 32'd15) $display("Test Case 1 failed");
    
    // Test case 2: I-Format SRAI instruction with a negative immediate value
    instruction = 32'h41435713;
    #10;
    if (immediate !== 32'd20) $display("Test Case 2 failed");

    // Test case 3: B-Format BEQ instruction with a positive immediate value
    instruction = 32'h00670563;
    #10;
    if (immediate !== 32'd10) $display("Test Case 3 failed");

    // Test case 4: B-Format BNE instruction with a negative immediate value
    instruction = 32'hfe671be3;
    #10;
    if (immediate !== 32'hfffffff6) $display("Test Case 4 failed");
    
    // End simulation
    $finish;
  end

endmodule