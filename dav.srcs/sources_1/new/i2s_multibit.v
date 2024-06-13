`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2024 21:24:43
// Design Name: 
// Module Name: i2s_multibit
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


module i2s_multibit(
    i2s_data, lrck, sclk, l_ch, r_ch
    );
`include "dav_params.v"

    input i2s_data;
    input lrck; // word select
    input sclk; // serial clock
    output reg [adc_bit_width-1:0] l_ch = 0;
    output reg [adc_bit_width-1:0] r_ch = 0;
    
    reg [4:0] bit_mux = 0;
    reg lrck_reg = 0;
        
    reg [adc_bit_width-1:0] l_temp = 0;
    reg [adc_bit_width-1:0] r_temp = 0;
    
    // lrck is synchronized with the negative edge of sclk
    always @ (negedge sclk) lrck_reg <= lrck;
    
    // left channel is received when lrck is low, right when high
    // msb is received 1 clock after lrck changes
    always @ (negedge sclk) begin
        // lrck just changed, next bit is msb
        // since the data is 24 bit but lrck toggles every 32 sclk clock cycles data transmission would have finished by now, no need to receive the last bit from the previous channel
        if (lrck != lrck_reg) begin
            bit_mux <= 24; // setup the mux
            if (lrck) begin // initialize the right register
                r_temp <= 0;
            end else begin // flush output and initialize left data reg
                l_ch <= l_temp;
                r_ch <= r_temp;
                l_temp <= 0;
            end
        // receiving data
        end else begin
            if (bit_mux != 0) begin
                if (lrck_reg) // set the muxed bit for the correct channel
                    r_temp[bit_mux-1] <= i2s_data;
                else
                    l_temp[bit_mux-1] <= i2s_data;
                bit_mux <= bit_mux - 1; // decrement the mux
            end
        end
    end
endmodule
