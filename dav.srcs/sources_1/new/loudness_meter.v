`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2024 01:54:31
// Design Name: 
// Module Name: loudness_meter
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



module loudness_meter(
    clk, rst, input_data, bins_flat
    );
`include "dav_params.v"

    input clk;
    input rst;
    input signed [fft_bit_width-1:0] input_data; // twos complement pcm input data
    output [16*fft_bit_width-1:0] bins_flat; // flattened output
    
    reg [fft_bit_width-1:0] bins_reg [15:0];
    reg signed [fft_bit_width-1:0] avg_max, avg_min;
    
    integer j;
    reg [10:0] counter; // slow down the bars
    
    // output flattening
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign bins_flat[(i+1)*fft_bit_width-1:i*fft_bit_width] = bins_reg[i];
        end
    endgenerate
    
    always @ (posedge clk) begin
        if (rst) begin
            for (j = 0; j < 16; j = j + 1) begin
                bins_reg[j] <= 24'h0;
            end
            counter <= 0;
        end else begin
            // shift the bars right and insert new bar
            if (counter == 0) begin                
                for (j = 1; j < 16; j = j + 1) begin
                    bins_reg[j] <= bins_reg[j-1];
                end
                bins_reg[0] <= avg_max - avg_min;
            end
            counter <= counter + 1;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            avg_max <= 24'h0;
            avg_min <= 24'h0;
        // calculate loudness from running average of max and min sample values
        end else begin
            if (input_data >= 0)
                avg_max <= (avg_max * 15 + input_data) >> 4;
            else
                avg_min <= (avg_min * 15 + input_data) >> 4;
        end
    end
endmodule
