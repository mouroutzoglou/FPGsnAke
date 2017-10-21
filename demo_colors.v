`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:47:39 10/17/2017 
// Design Name: 
// Module Name:    demo_colors 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module demo_colors(
	input            i_clk_74M, //74.25 MHZ pixel clock
	input [11:0]     i_vcnt, //vertical counter from video timing generator
	input [11:0]     i_hcnt, //horizontal counter from video timing generator

	output reg[7:0]  o_r,
	output reg[7:0]  o_g,
	output reg[7:0]  o_b
);		
	wire [5:0] x_dim = 6'd32;
	wire [5:0] y_dim = 6'd32;
	
	
	wire [7:0] r_0;
	wire [7:0] g_0;
	wire [7:0] b_0;
	
	reg [11:0] x_pos_0 = 12'd100;
	reg [11:0] y_pos_0 = 12'd200;
	
	wire [11:0] x_0 = i_hcnt - x_pos_0;
	wire [11:0] y_0 = i_vcnt - y_pos_0;
	
	image_rom_0 rom_0 (i_clk_74M, x_0[4:0], y_0[4:0], {r_0, g_0, b_0});	

	wire [7:0] r_1;
	wire [7:0] g_1;
	wire [7:0] b_1;
	
	reg [11:0] x_pos_1 = 12'd0;
	reg [11:0] y_pos_1 = 12'd0;
	
	wire [11:0] x_1 = i_hcnt - x_pos_1;
	wire [11:0] y_1 = i_vcnt - y_pos_1;
	
	image_rom_1 rom_1 (i_clk_74M, x_1[4:0], y_1[4:0], {r_1, g_1, b_1});	
	
	reg [19:0] cnt = 20'b0;
	
	always @ (posedge i_clk_74M) begin
		if(cnt == 20'd781250) begin
			cnt <= 0;
			if(x_pos_0 < 640-32) begin
				x_pos_0 <= x_pos_0 + 1;
			end else begin
				x_pos_0 <= 0+32;
			end
			if(y_pos_0 < 640-32) begin
				y_pos_0 <= y_pos_0 + 3;
			end else begin
				y_pos_0 <= 0+32;
			end
		end else begin
			cnt <= cnt + 1;
			x_pos_0 <= x_pos_0;
			y_pos_0 <= y_pos_0;
		end
	end
	
	always @ (posedge i_clk_74M) begin
		//if(x_1 >= 0 && x_1 < x_dim && y_1 >= 0 && y_1 < y_dim ) begin
		if(x_1 >= 0 && x_1 < 640 && y_1 >= 0 && y_1 < y_dim ) begin
			o_r <= r_1;
			o_g <= g_1;
			o_b <= b_1;
		end else if(x_1 >= 0 && x_1 < 640 && y_1 >= 640-32 && y_1 < 640 ) begin
			o_r <= r_1;
			o_g <= g_1;
			o_b <= b_1;
		end else if(y_1 >= 0 && y_1 < 640 && x_1 >= 0 && x_1 < 32 ) begin
			o_r <= r_1;
			o_g <= g_1;
			o_b <= b_1;
		end else if(y_1 >= 0 && y_1 < 640 && x_1 >= 640-32 && x_1 < 640 ) begin
			o_r <= r_1;
			o_g <= g_1;
			o_b <= b_1;
		end else if(x_0 >= 0 && x_0 < x_dim && y_0 >= 0 && y_0 < y_dim ) begin
			o_r <= r_0;
			o_g <= g_0;
			o_b <= b_0;
		end
		else begin
			o_r <= 8'b0;
			o_g <= 8'b0;
			o_b <= 8'b0;		
		end
	end


endmodule
