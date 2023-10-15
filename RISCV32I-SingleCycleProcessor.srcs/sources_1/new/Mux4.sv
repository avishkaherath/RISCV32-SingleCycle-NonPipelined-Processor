`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 06:44:45 PM
// Design Name: 
// Module Name: Mux4
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


module Mux4(
    input logic [31:0] data0,
    input logic [31:0] data1,
    input logic [31:0] data2,
    input logic [31:0] data3,
    input logic [1:0] Sel,
    output logic [31:0] dataout
);

always_comb begin
    case (Sel)
        2'b00: dataout = data0;
        2'b01: dataout = data1;
        2'b10: dataout = data2;
        2'b11: dataout = data3;
        default: dataout = 4'b0;
    endcase
end

endmodule
