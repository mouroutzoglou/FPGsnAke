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
	input            i_clk_74M, //65 MHZ pixel clock
	input [11:0]     i_vcnt, //vertical counter from video timing generator
	input [11:0]     i_hcnt, //horizontal counter from video timing generator

	output reg[7:0]  o_r,
	output reg[7:0]  o_g,
	output reg[7:0]  o_b
);		
	wire [5:0] x_dim = 6'd32;
	wire [5:0] y_dim = 6'd32;	
	
	
	reg [1:0] direction = 2'b00; //00 right
										  //01 left
										  //10 up
										  //11 down
	
	wire [7:0] r_0;
	wire [7:0] g_0;
	wire [7:0] b_0;
	
	reg [11:0] x_pos_0 = 12'd128;
	reg [11:0] y_pos_0 = 12'd256;
	
	reg [11:0] x_pos_1 = 12'd0;
	reg [11:0] y_pos_1 = 12'd0;
	reg en_1 = 1'b0;
	
	reg [11:0] x_pos_2 = 12'd0;
	reg [11:0] y_pos_2 = 12'd0;
	reg en_2 = 1'b0;
	
	wire [11:0] x_0 = i_hcnt - x_pos_0;
	wire [11:0] y_0 = i_vcnt - y_pos_0;
	wire [11:0] x_1 = i_hcnt - x_pos_1;
	wire [11:0] y_1 = i_vcnt - y_pos_1;
	wire [11:0] x_2 = i_hcnt - x_pos_2;
	wire [11:0] y_2 = i_vcnt - y_pos_2;
	
	image_rom_0 rom_0 (i_clk_74M, x_0[4:0], y_0[4:0], {r_0, g_0, b_0});	


	wire [7:0] r_b;
	wire [7:0] g_b;
	wire [7:0] b_b;
	
	reg [11:0] x_pos_b = 12'd0;
	reg [11:0] y_pos_b = 12'd0;
	
	wire [11:0] x_b = i_hcnt - x_pos_b;
	wire [11:0] y_b = i_vcnt - y_pos_b;
	
	image_rom_1 rom_1 (i_clk_74M, x_b[4:0], y_b[4:0], {r_b, g_b, b_b});	
	
		
	wire [7:0] r_a;
	wire [7:0] g_a;
	wire [7:0] b_a;
	
	reg [11:0] x_pos_a = 12'd512;
	reg [11:0] y_pos_a = 12'd512;
	
	wire [11:0] x_a = i_hcnt - x_pos_a;
	wire [11:0] y_a = i_vcnt - y_pos_a;

	image_rom_2 rom_2 (i_clk_74M, x_a[4:0], y_a[4:0], {r_a, g_a, b_a});	
	
	
	reg [26:0] cnt = 27'b0;
	
	always @ (posedge i_clk_74M) begin
		if(cnt == 27'd65000000) begin
			cnt <= 0;
			if(direction == 2'b00) begin
				if(x_pos_0 < 768-64) begin
					x_pos_0 <= x_pos_0 + 32;
				end else begin
					x_pos_0 <= 0+32;
				end
				direction <= 2'b11;
			end else if(direction == 2'b01) begin
				if(x_pos_0 > 0+32) begin
					x_pos_0 <= x_pos_0 - 12'd32;
				end else begin
					x_pos_0 <= 768-64;
				end
				direction <= 2'b10;
			end else if(direction == 2'b11) begin
				if(y_pos_0 < 768-64) begin
					y_pos_0 <= y_pos_0 + 32;
				end else begin
					y_pos_0 <= 0+32;
				end
				direction <= 2'b01;
			end else if(direction == 2'b10) begin
				if(y_pos_0 > 0+32) begin
					y_pos_0 <= y_pos_0 - 12'd32;
				end else begin
					y_pos_0 <= 768-64;
				end
				direction <= 2'b00;
			end
			x_pos_1 <= x_pos_0;
			x_pos_2 <= x_pos_1;
			y_pos_1 <= y_pos_0;
			y_pos_2 <= y_pos_1;
		end else begin
			cnt <= cnt + 1;
			x_pos_0 <= x_pos_0;
			y_pos_0 <= y_pos_0;
			x_pos_1 <= x_pos_1;
			y_pos_1 <= y_pos_1;
			x_pos_2 <= x_pos_2;
			y_pos_2 <= y_pos_2;
		end
	end
	
	always @ (posedge i_clk_74M) begin
		//if(x_1 >= 0 && x_1 < x_dim && y_1 >= 0 && y_1 < y_dim ) begin
		if(x_b >= 0 && x_b < 768 && y_b >= 0 && y_b < y_dim ) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(x_b >= 0 && x_b < 768 && y_b >= 764-32 && y_b < 768 ) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(y_b >= 0 && y_b < 768 && x_b >= 0 && x_b < 32 ) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(y_b >= 0 && y_b < 768 && x_b >= 768-32 && x_b < 768 ) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(x_0 >= 0 && x_0 < x_dim && y_0 >= 0 && y_0 < y_dim ) begin
			o_r <= r_0;
			o_g <= g_0;
			o_b <= b_0;
		end else if(x_1 >= 0 && x_1 < x_dim && y_1 >= 0 && y_1 < y_dim && en_1 == 1'b1) begin
			o_r <= r_0;
			o_g <= g_0;
			o_b <= b_0;
		end else if(x_2 >= 0 && x_2 < x_dim && y_2 >= 0 && y_2 < y_dim && en_2 == 1'b1 ) begin
			o_r <= r_0;
			o_g <= g_0;
			o_b <= b_0;
		end else if(x_a >= 0 && x_a < x_dim && y_a >= 0 && y_a < y_dim) begin
			o_r <= r_a;
			o_g <= g_a;
			o_b <= b_a;
		end
		else begin
			o_r <= 8'b0;
			o_g <= 8'b0;
			o_b <= 8'b0;		
		end
	end


endmodule
