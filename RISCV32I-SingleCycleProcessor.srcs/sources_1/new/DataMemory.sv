`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 02:14:07 AM
// Design Name: 
// Module Name: DataMemory
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


module DataMemory (
    input logic [31:0] address,
    input logic [31:0] write_data,
    input logic memRead, memWrite,
    output logic [31:0] read_data,
    input logic [2:0] data_sel,
    input logic clk,
    input logic reset
);

    logic [31:0] memory [0:63] = '{default: 32'h0};
    assign read_data = 32'b0;

    initial begin
        memory[16] = 32'h362CE5B7; // Initialize register x16 with 26
        memory[7] = 32'd3; // Initialize register x7 with 3
    end

    always_comb begin
        if (memRead) begin      // Read from memory when memRead = 1
            case (data_sel)
                3'b000: // LB (Load Byte)       
                    read_data = {memory[address][7]? {24{1'b1}}: {24{1'b0}}, memory[address][7:0]};

                3'b001: // LH (Load Halfword)
                    read_data = {memory[address][15]? {16{1'b1}}: {16{1'b0}}, memory[address][15:0]};

                3'b010: // LW (Load Word)
                    read_data = memory[address];

                3'b100: // LBU (Load Byte Unsigned)
                    read_data = {24'b0, memory[address][7:0]};

                3'b101: // LHU (Load Halfword Unsigned)
                    read_data = {16'b0, memory[address][15:0]};

                default: // LW (Default Load Word)
                    read_data = memory[address];
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if (reset == 0) begin
            // Reset the memory to all zeros            
            memory = '{default: 32'h0};
        end
        else begin
            if (memWrite) begin     // Write to memory when memWrite = 1
                case (data_sel)
                    3'b000: // SB (Store Byte)       
                        memory[address] <= {write_data[7]? {24{1'b1}}: {24{1'b0}}, write_data[7:0]};

                    3'b001: // SH (Store Halfword)
                        memory[address] <= {write_data[15]? {16{1'b1}}: {16{1'b0}}, write_data[15:0]};

                    3'b010: // SW (Store Word)
                        memory[address] <= write_data;

                    default: // SW (Default Store Word)
                        memory[address] <= write_data;
                endcase
            end
        end
    end

endmodule