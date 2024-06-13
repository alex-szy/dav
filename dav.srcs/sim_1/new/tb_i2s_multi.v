`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2024 02:05:16
// Design Name: 
// Module Name: tb_i2s_multi
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

// i2s serial to parallel testbench
module tb_i2s_multi;
    reg clk = 0;
    reg rst = 0;
    
    wire mclk;
    wire lrck;
    wire sclk;
    
    wire i2s_data;
    
    wire [23:0] ch1;
    wire [23:0] ch2;
    
    reg [2047:0] data [0:0];
    reg [10:0] ptr;
    assign i2s_data = data[0][ptr];
    
    always @ (posedge sclk) ptr <= ptr + 1;

    always #10 clk <= ~clk;

    initial begin
        ptr = 0;
        $readmemb("binary.code", data);
        #1000000
        $finish;
    end
    
    clock_divider clks(
        .clk(clk),
        .rst(rst),
        .mclk(mclk),
        .lrck(lrck),
        .sclk(sclk));
        
    i2s_multibit i2s(
        .i2s_data(i2s_data),
        .lrck(lrck),
        .sclk(sclk),
        .ch1(ch1),
        .ch2(ch2));
endmodule
