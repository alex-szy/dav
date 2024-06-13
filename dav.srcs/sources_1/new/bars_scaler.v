`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2024 01:39:04
// Design Name: 
// Module Name: bars_scaler
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


module bars_scaler(
    clk, in, out, sw
    );
    input clk; // Clock synchronized to meet timing constraints
    input [24*16-1:0] in; // 24 bit x 16 bars
    output [10*16-1:0] out; // 10 bit x 16 bars
    input sw;
    
    wire [63:0] extended [15:0]; // bit extension so we don't lose any information
    reg [9:0] out_reg [15:0];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            // perform scaling from 2^24 to 480 for each bar
            assign extended[i] = (in[(i+1)*24-1:i*24] * 480) >> (24 + sw);
            // assign output register to flattened output
            assign out[(i+1)*10-1:i*10] = out_reg[i];
        end
    endgenerate
    
    integer j;
    always @ (posedge clk) begin
        // assign result of scaling to output register
        for (j = 0; j < 16; j = j + 1)
            out_reg[j] <= 480 < extended[j][9:0] ? 0 : 480 - extended[j];
    end
endmodule
