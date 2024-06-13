`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2024 14:46:55
// Design Name: 
// Module Name: tb_clock_divider
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

// clock divider testbench
module tb_clock_divider;
    reg clk;
    reg rst;
    wire mclk;
    wire lrck;
    wire sclk;    

    always #10 clk <= ~clk;

    clock_divider uut (
        .clk(clk),
        .rst(rst),
        .mclk(mclk),
        .lrck(lrck),
        .sclk(sclk)
    );
        
    initial begin
        clk = 0;
        rst = 0;
        #100000
        rst = 1;
        #100000
        rst = 0;
        #100000
        $finish;
    end
endmodule
