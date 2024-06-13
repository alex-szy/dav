`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2024 14:35:30
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input clk, // 100 Mhz
    input rst,
    output mclk,
    output reg sclk = 0,
    output reg lrck = 0
    );
    
    wire locked;
    wire oclk;
    
    reg [2:0] sclk_counter = 0;
    reg [5:0] lrck_counter = 0;
    
    assign mclk = locked & oclk;
    
    clk_wiz_0 clkdiv(
        .clk_out1(oclk),
        .reset(rst),
        .clk_in1(clk),
        .locked(locked)
    );
    
    always @ (posedge mclk or posedge rst) begin
        if (rst)
            sclk <= 0;
        else
            sclk <= sclk_counter[2];
    end
    
    always @ (posedge mclk) begin
        if (rst)
            sclk_counter <= 0;
        else
            sclk_counter <= sclk_counter + 1;
    end
    
    // lrck is synced to negative edge of sclk
    always @ (negedge sclk or posedge rst) begin
        if (rst)
            lrck <= 0;
        else
            lrck <= lrck_counter[5];
    end
    
    always @ (negedge sclk) begin
        if (rst)
            lrck_counter <= 0;
        else
            lrck_counter <= lrck_counter + 1;
    end
endmodule
