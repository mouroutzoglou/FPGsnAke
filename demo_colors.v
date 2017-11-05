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
	
	
	reg [1:0] direction = 2'b10; //00 right
										  //01 left
										  //10 up
										  //11 down
	
	wire [7:0] r_0;
	wire [7:0] g_0;
	wire [7:0] b_0;
	
	reg [59:0] x_pos;
	reg [59:0] y_pos;
	
	initial x_pos[5:0] <= 6'd16;
	initial y_pos[5:0] <= 6'd22;
	
	reg [11:0] score = 12'd0;
	
	image_rom_0 rom_0 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_0, g_0, b_0});	


	wire [7:0] r_b;
	wire [7:0] g_b;
	wire [7:0] b_b;
	
	reg [5:0] x_pos_b = 6'd0;
	reg [5:0] y_pos_b = 6'd0;
	
	image_rom_1 rom_1 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_b, g_b, b_b});	
	
		
	wire [7:0] r_a;
	wire [7:0] g_a;
	wire [7:0] b_a;
	
	reg [5:0] x_pos_a = 6'd16;
	reg [5:0] y_pos_a = 6'd8;

	image_rom_2 rom_2 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_a, g_a, b_a});	
	
	
	reg [26:0] cnt = 27'd1;
	reg [9:0] i;
	
	always @ (posedge i_clk_74M) begin
		if(cnt == 27'd65000000) begin
		
			cnt <= 1;
			
			x_pos[59:6] <= x_pos[53:0];
			y_pos[59:6] <= y_pos[53:0];
			
			if(x_pos[5:0] == x_pos_a && y_pos[5:0] == y_pos_a) begin
				score <= score + 1;
			end else begin
				score <= score;
			end
			
			if(direction == 2'b00) begin
				if(x_pos[5:0] < 22) begin
					x_pos[5:0] <= x_pos[5:0] + 1;
					direction <= 2'b00;
				end else begin
					x_pos[5:0] <= x_pos[5:0] - 1;
					direction <= 2'b01;
				end
			end else if(direction == 2'b01) begin
				if(x_pos[5:0] > 0+1) begin
					x_pos[5:0] <= x_pos[5:0] - 1;
					direction <= 2'b01;
				end else begin
					x_pos[5:0] <= x_pos[5:0] + 1;
					direction <= 2'b00;
				end
			end else if(direction == 2'b11) begin
				if(y_pos[5:0] < 22) begin
					y_pos[5:0] <= y_pos[5:0] + 1;
					direction <= 2'b11;
				end else begin
					y_pos[5:0] <= y_pos[5:0] - 1;
					direction <= 2'b10;
				end
			end else if(direction == 2'b10) begin
				if(y_pos[5:0] > 0+1) begin
					y_pos[5:0] <= y_pos[5:0] - 1;
					direction <= 2'b10;
				end else begin
					y_pos[5:0] <= y_pos[5:0] + 1;
					direction <= 2'b11;
				end
			end
		end else begin
			cnt <= cnt + 1;
			x_pos[5:0]  <= x_pos[5:0];
		   y_pos[5:0]  <= y_pos[5:0];
		end
	end
	
	always @ (posedge i_clk_74M) begin	
		
		if(x_pos_b <= {1'b0, i_hcnt[9:5]} && x_pos_b + 6'd24 > {1'b0, i_hcnt[9:5]} && y_pos_b == i_vcnt[10:5]) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(x_pos_b <= {1'b0, i_hcnt[9:5]} && x_pos_b + 6'd24 > {1'b0, i_hcnt[9:5]} && y_pos_b == i_vcnt[10:5] - 6'd23) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(y_pos_b <= i_vcnt[10:5] && y_pos_b + 6'd24 > i_vcnt[10:5] && x_pos_b == {1'b0, i_hcnt[9:5]}) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(y_pos_b <= i_vcnt[10:5] && y_pos_b + 6'd24 > i_vcnt[10:5] && x_pos_b == {1'b0, i_hcnt[9:5]} - 6'd23) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(x_pos[5:0] == {1'b0, i_hcnt[9:5]} && y_pos[5:0] == i_vcnt[10:5] && score >= 0) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[11:6] == {1'b0, i_hcnt[9:5]} && y_pos[11:6] == i_vcnt[10:5] && score >= 1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[17:12] == {1'b0, i_hcnt[9:5]} && y_pos[17:12] == i_vcnt[10:5] && score >= 2) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[23:18] == {1'b0, i_hcnt[9:5]} && y_pos[23:18] == i_vcnt[10:5] && score >= 3) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[29:24] == {1'b0, i_hcnt[9:5]} && y_pos[29:24] == i_vcnt[10:5] && score >= 4) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[35:30] == {1'b0, i_hcnt[9:5]} && y_pos[35:30] == i_vcnt[10:5] && score >= 5) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[41:36] == {1'b0, i_hcnt[9:5]} && y_pos[41:36] == i_vcnt[10:5] && score >= 6) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[47:42] == {1'b0, i_hcnt[9:5]} && y_pos[47:42] == i_vcnt[10:5] && score >= 7) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[53:48] == {1'b0, i_hcnt[9:5]} && y_pos[53:48] == i_vcnt[10:5] && score >= 8) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[59:54] == {1'b0, i_hcnt[9:5]} && y_pos[59:54] == i_vcnt[10:5] && score >= 9) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos_a == {1'b0, i_hcnt[9:5]} && y_pos_a == i_vcnt[10:5]) begin
			o_r <= r_a;
			o_g <= g_a;
			o_b <= b_a;
		end else begin
			o_r <= 8'b0;
			o_g <= 8'b0;
			o_b <= 8'b0;
		end
	end


endmodule
