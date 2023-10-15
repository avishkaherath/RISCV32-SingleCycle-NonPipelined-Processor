`timescale 1ns / 1ps

module Mux2(
    input logic select,
    input logic [31:0] data0, data1,
    output logic [31:0] dataout
);

    always_comb begin
        if (select) dataout = data1;    // select = 1        
        else dataout = data0;    // select = 0
    end

endmodule