`timescale 1ns / 1ps

module BranchComparator (
    input logic unsignedComp, // Unsigned = 1, Signed = 0
    input logic [31:0] inA, inB,
    output logic equal, lessThan          
);

    always_comb begin
        if (unsignedComp) begin
            equal = ($unsigned(inA) == $unsigned(inB));
            lessThan = ($unsigned(inA) < $unsigned(inB));
        end
        else begin
            equal = ($signed(inA) == $signed(inB));
            lessThan = ($signed(inA) < $signed(inB));
        end
    end

endmodule