`timescale 1ns / 1ps

module Mux4(
    input logic [1:0] select,
    input logic [31:0] data0, data1, data2, data3,    
    output logic [31:0] dataout
);

    always_comb begin
        case (select)
            2'b00: dataout = data0;
            2'b01: dataout = data1;
            2'b10: dataout = data2;
            2'b11: dataout = data3;
            default: dataout = 4'b0;    // Zero output
        endcase
    end

endmodule