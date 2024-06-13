`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2024 01:46:36
// Design Name: 
// Module Name: display_bars
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


module display_bars(
    clk, horizontal_count, vertical_count, f_flat, rgb_out
    );
`include "dav_params.v"
    parameter bar_rgb = 12'hFFF;

    input clk; // 100MHz
    input [9:0] horizontal_count, vertical_count; // the pixel requested by the vga controller
    
    input [16*10-1:0] f_flat; // flattened input
	
    output reg [11:0] rgb_out; // outputs the colour of a single pixel requested by display controller
   
	// unflatten the input
	wire [9:0] f [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign f[i] = f_flat[(i+1)*10-1:i*10];
        end
    endgenerate
    
    // check coordinates of each bar
	always @ (posedge clk) begin
		//Column 0
		if (horizontal_count < 40) begin
            rgb_out <= (vertical_count > f[0]) ? bar_rgb : 0;
		end
		//Column 1
		else if (horizontal_count > 40 && horizontal_count < 80) begin
            rgb_out <= (vertical_count > f[1]) ? bar_rgb : 0;
		end
		//Column 2
		else if (horizontal_count > 80 && horizontal_count < 120) begin
            rgb_out <= (vertical_count > f[2]) ? bar_rgb : 0;
		end
		//Column 3
		else if (horizontal_count > 120 && horizontal_count < 160) begin
            rgb_out <= (vertical_count > f[3]) ? bar_rgb : 0;
		end
		//Column 4
		else if (horizontal_count > 160 && horizontal_count < 200) begin
            rgb_out <= (vertical_count > f[4]) ? bar_rgb : 0;
		end
		//Column 5
		else if (horizontal_count > 200 && horizontal_count < 240) begin
            rgb_out <= (vertical_count > f[5]) ? bar_rgb : 0;
        end
		//Column 6
		else if (horizontal_count > 240 && horizontal_count < 280) begin
            rgb_out <= (vertical_count > f[6]) ? bar_rgb : 0;
		end
		//Column 7
		else if (horizontal_count > 280 && horizontal_count < 320) begin
            rgb_out <= (vertical_count > f[7]) ? bar_rgb : 0;
		end
		//Column 8
		else if (horizontal_count > 320 && horizontal_count < 360) begin
            rgb_out <= (vertical_count > f[8]) ? bar_rgb : 0;
		end
		//Column 9
		else if (horizontal_count > 360 && horizontal_count < 400) begin
            rgb_out <= (vertical_count > f[9]) ? bar_rgb : 0;
		end
		//Column 10
		else if (horizontal_count > 400 && horizontal_count < 440) begin
            rgb_out <= (vertical_count > f[10]) ? bar_rgb : 0;
		end
		//Column 11
		else if (horizontal_count > 440 && horizontal_count < 480) begin
            rgb_out <= (vertical_count > f[11]) ? bar_rgb : 0;
		end
		//Column 12
		else if (horizontal_count > 480 && horizontal_count < 520) begin
            rgb_out <= (vertical_count > f[12]) ? bar_rgb : 0;
		end
		//Column 13
		else if (horizontal_count > 520 && horizontal_count < 560) begin
            rgb_out <= (vertical_count > f[13]) ? bar_rgb : 0;
		end
		//Column 14
		else if (horizontal_count > 560 && horizontal_count < 600) begin
            rgb_out <= (vertical_count > f[14]) ? bar_rgb : 0;
		end
		//Column 15
		else if (horizontal_count > 600 && horizontal_count < 640) begin
            rgb_out <= (vertical_count > f[15]) ? bar_rgb : 0;
		end
		// Separating line
		else
            rgb_out <= 12'b010101011000;
	end
endmodule
