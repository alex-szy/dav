`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.02.2024 15:05:50
// Design Name: 
// Module Name: dav
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


module dav(
    input clk,
    input rst,
    input sw,
    
    // I2S2 Clocks
    output [2:0] tx_clk,
    output [2:0] rx_clk,
    
    // I2S2 Data
    output i2s_tx,
    input i2s_rx,
    
    // VGA Display
    output wire vsync,
    output wire hsync,
    output wire [11:0] rgb
    );
    
`include "dav_params.v"
    
    // audio passthrough
    assign i2s_tx = i2s_rx;
    
    // clocks
    wire mclk;
    wire sclk;
    wire lrck;
    
    // i2s2 clocks
    assign tx_clk = { sclk, lrck, mclk };
    assign rx_clk = { sclk, lrck, mclk };
    
    
    // i2s to multibit
    wire [adc_bit_width-1:0] l_ch;
    wire [adc_bit_width-1:0] r_ch;
    wire [adc_bit_width-1:0] mono = l_ch + r_ch;
    
    // vga
    wire [16*fft_bit_width-1:0] bins_flat;
    wire [16*10-1:0] f_flat;
    wire data_loaded;
    wire video_on;
    wire pixel_tick;
    wire [9:0] x, y;
    reg [11:0] rgb_reg, rgb_next;
    wire [11:0] display_rgb;
    
    clock_divider clks(
        .clk(clk),
        .rst(rst),
        .mclk(mclk),
        .sclk(sclk),
        .lrck(lrck)
    );
        
    i2s_multibit i2s(
        .i2s_data(i2s_rx),
        .lrck(lrck),
        .sclk(sclk),
        .l_ch(l_ch),
        .r_ch(r_ch)
    );
    
    loudness_meter meter (
        .clk(lrck),
        .rst(rst),
        .input_data(mono),
        .bins_flat(bins_flat)
    );
        
    bars_scaler scaler (
        .clk(clk),
        .in(bins_flat),
        .out(f_flat),
        .sw(sw)
    );
        
    display_bars bars ( // inputs: bar data 0-480
        .clk(clk),
        .horizontal_count(x),
        .vertical_count(y),
        .f_flat(f_flat),
        .rgb_out(display_rgb)
    );
        
    vga_sync vsync_unit (
        .clk(clk),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .p_tick(pixel_tick),
        .x(x),
        .y(y)
    );
    
   always @* begin
       if (~video_on)
           rgb_next = 12'b0; // black
       else
           rgb_next = display_rgb;
   end
       
   // rgb buffer register
   always @(posedge clk)
       if (pixel_tick)
           rgb_reg <= rgb_next;
           
   // output rgb data to VGA DAC
   assign rgb = rgb_reg;
endmodule
