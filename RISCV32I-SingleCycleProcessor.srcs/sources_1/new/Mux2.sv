`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 10:39:00 PM
// Design Name: 
// Module Name: Mux2
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


module Mux2(
    input logic [31:0] data0,
    input logic [31:0] data1,
    input logic BSel,
    output logic [31:0] dataout
);

    always_comb begin
        if (BSel) begin
            dataout = data1;
        end
        else begin
            dataout = data0;
        end
    end

endmodule