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
	
	reg en [0:483] = {1'b1, 483'b0};
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
<<<<<<< HEAD
=======
				if(x_pos[0] + 1 == x_pos_a && y_pos[0] == y_pos_a) begin
					en[score+1] <= 1'b1;
					score <= score + 1;
				end
>>>>>>> parent of 6d2d99c... failures gonna change plans
			end else if(direction == 2'b01) begin
				if(x_pos[5:0] > 0+1) begin
					x_pos[5:0] <= x_pos[5:0] - 1;
					direction <= 2'b01;
				end else begin
					x_pos[5:0] <= x_pos[5:0] + 1;
					direction <= 2'b00;
				end
<<<<<<< HEAD
=======
				if(x_pos[0] - 1 == x_pos_a && y_pos[0] == y_pos_a) begin
					en[score+1] <= 1'b1;
					score <= score + 1;
				end
>>>>>>> parent of 6d2d99c... failures gonna change plans
			end else if(direction == 2'b11) begin
				if(y_pos[5:0] < 22) begin
					y_pos[5:0] <= y_pos[5:0] + 1;
					direction <= 2'b11;
				end else begin
					y_pos[5:0] <= y_pos[5:0] - 1;
					direction <= 2'b10;
				end
<<<<<<< HEAD
=======
				if(x_pos[0] == x_pos_a && y_pos[0] + 1 == y_pos_a) begin
					en[score+1] <= 1'b1;
					score <= score + 1;
				end
>>>>>>> parent of 6d2d99c... failures gonna change plans
			end else if(direction == 2'b10) begin
				if(y_pos[5:0] > 0+1) begin
					y_pos[5:0] <= y_pos[5:0] - 1;
					direction <= 2'b10;
				end else begin
					y_pos[5:0] <= y_pos[5:0] + 1;
					direction <= 2'b11;
				end
<<<<<<< HEAD
=======
				if(x_pos[0] == x_pos_a && y_pos[0] - 1 == y_pos_a) begin
					en[score+1] <= 1'b1;
					score <= score + 1;
				end
>>>>>>> parent of 6d2d99c... failures gonna change plans
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
<<<<<<< HEAD
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
=======
		end else if(x_pos[0] == i_hcnt[10:5] && y_pos[0] == i_vcnt[10:5] && en[0] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1] == i_hcnt[10:5] && y_pos[1] == i_vcnt[10:5] && en[1] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2] == i_hcnt[10:5] && y_pos[2] == i_vcnt[10:5] && en[2] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[3] == i_hcnt[10:5] && y_pos[3] == i_vcnt[10:5] && en[3] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[4] == i_hcnt[10:5] && y_pos[4] == i_vcnt[10:5] && en[4] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[5] == i_hcnt[10:5] && y_pos[5] == i_vcnt[10:5] && en[5] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[6] == i_hcnt[10:5] && y_pos[6] == i_vcnt[10:5] && en[6] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[7] == i_hcnt[10:5] && y_pos[7] == i_vcnt[10:5] && en[7] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[8] == i_hcnt[10:5] && y_pos[8] == i_vcnt[10:5] && en[8] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[9] == i_hcnt[10:5] && y_pos[9] == i_vcnt[10:5] && en[9] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[10] == i_hcnt[10:5] && y_pos[10] == i_vcnt[10:5] && en[10] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[11] == i_hcnt[10:5] && y_pos[11] == i_vcnt[10:5] && en[11] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[12] == i_hcnt[10:5] && y_pos[12] == i_vcnt[10:5] && en[12] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[13] == i_hcnt[10:5] && y_pos[13] == i_vcnt[10:5] && en[13] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[14] == i_hcnt[10:5] && y_pos[14] == i_vcnt[10:5] && en[14] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[15] == i_hcnt[10:5] && y_pos[15] == i_vcnt[10:5] && en[15] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[16] == i_hcnt[10:5] && y_pos[16] == i_vcnt[10:5] && en[16] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[17] == i_hcnt[10:5] && y_pos[17] == i_vcnt[10:5] && en[17] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[18] == i_hcnt[10:5] && y_pos[18] == i_vcnt[10:5] && en[18] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[19] == i_hcnt[10:5] && y_pos[19] == i_vcnt[10:5] && en[19] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[20] == i_hcnt[10:5] && y_pos[20] == i_vcnt[10:5] && en[20] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[21] == i_hcnt[10:5] && y_pos[21] == i_vcnt[10:5] && en[21] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[22] == i_hcnt[10:5] && y_pos[22] == i_vcnt[10:5] && en[22] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[23] == i_hcnt[10:5] && y_pos[23] == i_vcnt[10:5] && en[23] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[24] == i_hcnt[10:5] && y_pos[24] == i_vcnt[10:5] && en[24] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[25] == i_hcnt[10:5] && y_pos[25] == i_vcnt[10:5] && en[25] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[26] == i_hcnt[10:5] && y_pos[26] == i_vcnt[10:5] && en[26] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[27] == i_hcnt[10:5] && y_pos[27] == i_vcnt[10:5] && en[27] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[28] == i_hcnt[10:5] && y_pos[28] == i_vcnt[10:5] && en[28] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[29] == i_hcnt[10:5] && y_pos[29] == i_vcnt[10:5] && en[29] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[30] == i_hcnt[10:5] && y_pos[30] == i_vcnt[10:5] && en[30] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[31] == i_hcnt[10:5] && y_pos[31] == i_vcnt[10:5] && en[31] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[32] == i_hcnt[10:5] && y_pos[32] == i_vcnt[10:5] && en[32] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[33] == i_hcnt[10:5] && y_pos[33] == i_vcnt[10:5] && en[33] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[34] == i_hcnt[10:5] && y_pos[34] == i_vcnt[10:5] && en[34] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[35] == i_hcnt[10:5] && y_pos[35] == i_vcnt[10:5] && en[35] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[36] == i_hcnt[10:5] && y_pos[36] == i_vcnt[10:5] && en[36] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[37] == i_hcnt[10:5] && y_pos[37] == i_vcnt[10:5] && en[37] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[38] == i_hcnt[10:5] && y_pos[38] == i_vcnt[10:5] && en[38] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[39] == i_hcnt[10:5] && y_pos[39] == i_vcnt[10:5] && en[39] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[40] == i_hcnt[10:5] && y_pos[40] == i_vcnt[10:5] && en[40] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[41] == i_hcnt[10:5] && y_pos[41] == i_vcnt[10:5] && en[41] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[42] == i_hcnt[10:5] && y_pos[42] == i_vcnt[10:5] && en[42] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[43] == i_hcnt[10:5] && y_pos[43] == i_vcnt[10:5] && en[43] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[44] == i_hcnt[10:5] && y_pos[44] == i_vcnt[10:5] && en[44] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[45] == i_hcnt[10:5] && y_pos[45] == i_vcnt[10:5] && en[45] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[46] == i_hcnt[10:5] && y_pos[46] == i_vcnt[10:5] && en[46] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[47] == i_hcnt[10:5] && y_pos[47] == i_vcnt[10:5] && en[47] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[48] == i_hcnt[10:5] && y_pos[48] == i_vcnt[10:5] && en[48] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[49] == i_hcnt[10:5] && y_pos[49] == i_vcnt[10:5] && en[49] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[50] == i_hcnt[10:5] && y_pos[50] == i_vcnt[10:5] && en[50] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[51] == i_hcnt[10:5] && y_pos[51] == i_vcnt[10:5] && en[51] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[52] == i_hcnt[10:5] && y_pos[52] == i_vcnt[10:5] && en[52] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[53] == i_hcnt[10:5] && y_pos[53] == i_vcnt[10:5] && en[53] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[54] == i_hcnt[10:5] && y_pos[54] == i_vcnt[10:5] && en[54] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[55] == i_hcnt[10:5] && y_pos[55] == i_vcnt[10:5] && en[55] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[56] == i_hcnt[10:5] && y_pos[56] == i_vcnt[10:5] && en[56] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[57] == i_hcnt[10:5] && y_pos[57] == i_vcnt[10:5] && en[57] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[58] == i_hcnt[10:5] && y_pos[58] == i_vcnt[10:5] && en[58] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[59] == i_hcnt[10:5] && y_pos[59] == i_vcnt[10:5] && en[59] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[60] == i_hcnt[10:5] && y_pos[60] == i_vcnt[10:5] && en[60] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[61] == i_hcnt[10:5] && y_pos[61] == i_vcnt[10:5] && en[61] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[62] == i_hcnt[10:5] && y_pos[62] == i_vcnt[10:5] && en[62] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[63] == i_hcnt[10:5] && y_pos[63] == i_vcnt[10:5] && en[63] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[64] == i_hcnt[10:5] && y_pos[64] == i_vcnt[10:5] && en[64] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[65] == i_hcnt[10:5] && y_pos[65] == i_vcnt[10:5] && en[65] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[66] == i_hcnt[10:5] && y_pos[66] == i_vcnt[10:5] && en[66] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[67] == i_hcnt[10:5] && y_pos[67] == i_vcnt[10:5] && en[67] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[68] == i_hcnt[10:5] && y_pos[68] == i_vcnt[10:5] && en[68] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[69] == i_hcnt[10:5] && y_pos[69] == i_vcnt[10:5] && en[69] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[70] == i_hcnt[10:5] && y_pos[70] == i_vcnt[10:5] && en[70] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[71] == i_hcnt[10:5] && y_pos[71] == i_vcnt[10:5] && en[71] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[72] == i_hcnt[10:5] && y_pos[72] == i_vcnt[10:5] && en[72] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[73] == i_hcnt[10:5] && y_pos[73] == i_vcnt[10:5] && en[73] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[74] == i_hcnt[10:5] && y_pos[74] == i_vcnt[10:5] && en[74] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[75] == i_hcnt[10:5] && y_pos[75] == i_vcnt[10:5] && en[75] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[76] == i_hcnt[10:5] && y_pos[76] == i_vcnt[10:5] && en[76] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[77] == i_hcnt[10:5] && y_pos[77] == i_vcnt[10:5] && en[77] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[78] == i_hcnt[10:5] && y_pos[78] == i_vcnt[10:5] && en[78] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[79] == i_hcnt[10:5] && y_pos[79] == i_vcnt[10:5] && en[79] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[80] == i_hcnt[10:5] && y_pos[80] == i_vcnt[10:5] && en[80] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[81] == i_hcnt[10:5] && y_pos[81] == i_vcnt[10:5] && en[81] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[82] == i_hcnt[10:5] && y_pos[82] == i_vcnt[10:5] && en[82] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[83] == i_hcnt[10:5] && y_pos[83] == i_vcnt[10:5] && en[83] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[84] == i_hcnt[10:5] && y_pos[84] == i_vcnt[10:5] && en[84] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[85] == i_hcnt[10:5] && y_pos[85] == i_vcnt[10:5] && en[85] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[86] == i_hcnt[10:5] && y_pos[86] == i_vcnt[10:5] && en[86] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[87] == i_hcnt[10:5] && y_pos[87] == i_vcnt[10:5] && en[87] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[88] == i_hcnt[10:5] && y_pos[88] == i_vcnt[10:5] && en[88] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[89] == i_hcnt[10:5] && y_pos[89] == i_vcnt[10:5] && en[89] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[90] == i_hcnt[10:5] && y_pos[90] == i_vcnt[10:5] && en[90] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[91] == i_hcnt[10:5] && y_pos[91] == i_vcnt[10:5] && en[91] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[92] == i_hcnt[10:5] && y_pos[92] == i_vcnt[10:5] && en[92] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[93] == i_hcnt[10:5] && y_pos[93] == i_vcnt[10:5] && en[93] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[94] == i_hcnt[10:5] && y_pos[94] == i_vcnt[10:5] && en[94] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[95] == i_hcnt[10:5] && y_pos[95] == i_vcnt[10:5] && en[95] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[96] == i_hcnt[10:5] && y_pos[96] == i_vcnt[10:5] && en[96] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[97] == i_hcnt[10:5] && y_pos[97] == i_vcnt[10:5] && en[97] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[98] == i_hcnt[10:5] && y_pos[98] == i_vcnt[10:5] && en[98] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[99] == i_hcnt[10:5] && y_pos[99] == i_vcnt[10:5] && en[99] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[100] == i_hcnt[10:5] && y_pos[100] == i_vcnt[10:5] && en[100] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[101] == i_hcnt[10:5] && y_pos[101] == i_vcnt[10:5] && en[101] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[102] == i_hcnt[10:5] && y_pos[102] == i_vcnt[10:5] && en[102] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[103] == i_hcnt[10:5] && y_pos[103] == i_vcnt[10:5] && en[103] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[104] == i_hcnt[10:5] && y_pos[104] == i_vcnt[10:5] && en[104] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[105] == i_hcnt[10:5] && y_pos[105] == i_vcnt[10:5] && en[105] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[106] == i_hcnt[10:5] && y_pos[106] == i_vcnt[10:5] && en[106] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[107] == i_hcnt[10:5] && y_pos[107] == i_vcnt[10:5] && en[107] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[108] == i_hcnt[10:5] && y_pos[108] == i_vcnt[10:5] && en[108] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[109] == i_hcnt[10:5] && y_pos[109] == i_vcnt[10:5] && en[109] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[110] == i_hcnt[10:5] && y_pos[110] == i_vcnt[10:5] && en[110] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[111] == i_hcnt[10:5] && y_pos[111] == i_vcnt[10:5] && en[111] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[112] == i_hcnt[10:5] && y_pos[112] == i_vcnt[10:5] && en[112] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[113] == i_hcnt[10:5] && y_pos[113] == i_vcnt[10:5] && en[113] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[114] == i_hcnt[10:5] && y_pos[114] == i_vcnt[10:5] && en[114] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[115] == i_hcnt[10:5] && y_pos[115] == i_vcnt[10:5] && en[115] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[116] == i_hcnt[10:5] && y_pos[116] == i_vcnt[10:5] && en[116] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[117] == i_hcnt[10:5] && y_pos[117] == i_vcnt[10:5] && en[117] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[118] == i_hcnt[10:5] && y_pos[118] == i_vcnt[10:5] && en[118] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[119] == i_hcnt[10:5] && y_pos[119] == i_vcnt[10:5] && en[119] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[120] == i_hcnt[10:5] && y_pos[120] == i_vcnt[10:5] && en[120] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[121] == i_hcnt[10:5] && y_pos[121] == i_vcnt[10:5] && en[121] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[122] == i_hcnt[10:5] && y_pos[122] == i_vcnt[10:5] && en[122] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[123] == i_hcnt[10:5] && y_pos[123] == i_vcnt[10:5] && en[123] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[124] == i_hcnt[10:5] && y_pos[124] == i_vcnt[10:5] && en[124] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[125] == i_hcnt[10:5] && y_pos[125] == i_vcnt[10:5] && en[125] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[126] == i_hcnt[10:5] && y_pos[126] == i_vcnt[10:5] && en[126] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[127] == i_hcnt[10:5] && y_pos[127] == i_vcnt[10:5] && en[127] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[128] == i_hcnt[10:5] && y_pos[128] == i_vcnt[10:5] && en[128] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[129] == i_hcnt[10:5] && y_pos[129] == i_vcnt[10:5] && en[129] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[130] == i_hcnt[10:5] && y_pos[130] == i_vcnt[10:5] && en[130] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[131] == i_hcnt[10:5] && y_pos[131] == i_vcnt[10:5] && en[131] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[132] == i_hcnt[10:5] && y_pos[132] == i_vcnt[10:5] && en[132] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[133] == i_hcnt[10:5] && y_pos[133] == i_vcnt[10:5] && en[133] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[134] == i_hcnt[10:5] && y_pos[134] == i_vcnt[10:5] && en[134] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[135] == i_hcnt[10:5] && y_pos[135] == i_vcnt[10:5] && en[135] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[136] == i_hcnt[10:5] && y_pos[136] == i_vcnt[10:5] && en[136] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[137] == i_hcnt[10:5] && y_pos[137] == i_vcnt[10:5] && en[137] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[138] == i_hcnt[10:5] && y_pos[138] == i_vcnt[10:5] && en[138] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[139] == i_hcnt[10:5] && y_pos[139] == i_vcnt[10:5] && en[139] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[140] == i_hcnt[10:5] && y_pos[140] == i_vcnt[10:5] && en[140] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[141] == i_hcnt[10:5] && y_pos[141] == i_vcnt[10:5] && en[141] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[142] == i_hcnt[10:5] && y_pos[142] == i_vcnt[10:5] && en[142] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[143] == i_hcnt[10:5] && y_pos[143] == i_vcnt[10:5] && en[143] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[144] == i_hcnt[10:5] && y_pos[144] == i_vcnt[10:5] && en[144] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[145] == i_hcnt[10:5] && y_pos[145] == i_vcnt[10:5] && en[145] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[146] == i_hcnt[10:5] && y_pos[146] == i_vcnt[10:5] && en[146] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[147] == i_hcnt[10:5] && y_pos[147] == i_vcnt[10:5] && en[147] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[148] == i_hcnt[10:5] && y_pos[148] == i_vcnt[10:5] && en[148] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[149] == i_hcnt[10:5] && y_pos[149] == i_vcnt[10:5] && en[149] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[150] == i_hcnt[10:5] && y_pos[150] == i_vcnt[10:5] && en[150] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[151] == i_hcnt[10:5] && y_pos[151] == i_vcnt[10:5] && en[151] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[152] == i_hcnt[10:5] && y_pos[152] == i_vcnt[10:5] && en[152] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[153] == i_hcnt[10:5] && y_pos[153] == i_vcnt[10:5] && en[153] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[154] == i_hcnt[10:5] && y_pos[154] == i_vcnt[10:5] && en[154] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[155] == i_hcnt[10:5] && y_pos[155] == i_vcnt[10:5] && en[155] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[156] == i_hcnt[10:5] && y_pos[156] == i_vcnt[10:5] && en[156] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[157] == i_hcnt[10:5] && y_pos[157] == i_vcnt[10:5] && en[157] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[158] == i_hcnt[10:5] && y_pos[158] == i_vcnt[10:5] && en[158] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[159] == i_hcnt[10:5] && y_pos[159] == i_vcnt[10:5] && en[159] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[160] == i_hcnt[10:5] && y_pos[160] == i_vcnt[10:5] && en[160] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[161] == i_hcnt[10:5] && y_pos[161] == i_vcnt[10:5] && en[161] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[162] == i_hcnt[10:5] && y_pos[162] == i_vcnt[10:5] && en[162] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[163] == i_hcnt[10:5] && y_pos[163] == i_vcnt[10:5] && en[163] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[164] == i_hcnt[10:5] && y_pos[164] == i_vcnt[10:5] && en[164] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[165] == i_hcnt[10:5] && y_pos[165] == i_vcnt[10:5] && en[165] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[166] == i_hcnt[10:5] && y_pos[166] == i_vcnt[10:5] && en[166] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[167] == i_hcnt[10:5] && y_pos[167] == i_vcnt[10:5] && en[167] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[168] == i_hcnt[10:5] && y_pos[168] == i_vcnt[10:5] && en[168] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[169] == i_hcnt[10:5] && y_pos[169] == i_vcnt[10:5] && en[169] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[170] == i_hcnt[10:5] && y_pos[170] == i_vcnt[10:5] && en[170] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[171] == i_hcnt[10:5] && y_pos[171] == i_vcnt[10:5] && en[171] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[172] == i_hcnt[10:5] && y_pos[172] == i_vcnt[10:5] && en[172] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[173] == i_hcnt[10:5] && y_pos[173] == i_vcnt[10:5] && en[173] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[174] == i_hcnt[10:5] && y_pos[174] == i_vcnt[10:5] && en[174] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[175] == i_hcnt[10:5] && y_pos[175] == i_vcnt[10:5] && en[175] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[176] == i_hcnt[10:5] && y_pos[176] == i_vcnt[10:5] && en[176] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[177] == i_hcnt[10:5] && y_pos[177] == i_vcnt[10:5] && en[177] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[178] == i_hcnt[10:5] && y_pos[178] == i_vcnt[10:5] && en[178] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[179] == i_hcnt[10:5] && y_pos[179] == i_vcnt[10:5] && en[179] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[180] == i_hcnt[10:5] && y_pos[180] == i_vcnt[10:5] && en[180] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[181] == i_hcnt[10:5] && y_pos[181] == i_vcnt[10:5] && en[181] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[182] == i_hcnt[10:5] && y_pos[182] == i_vcnt[10:5] && en[182] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[183] == i_hcnt[10:5] && y_pos[183] == i_vcnt[10:5] && en[183] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[184] == i_hcnt[10:5] && y_pos[184] == i_vcnt[10:5] && en[184] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[185] == i_hcnt[10:5] && y_pos[185] == i_vcnt[10:5] && en[185] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[186] == i_hcnt[10:5] && y_pos[186] == i_vcnt[10:5] && en[186] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[187] == i_hcnt[10:5] && y_pos[187] == i_vcnt[10:5] && en[187] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[188] == i_hcnt[10:5] && y_pos[188] == i_vcnt[10:5] && en[188] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[189] == i_hcnt[10:5] && y_pos[189] == i_vcnt[10:5] && en[189] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[190] == i_hcnt[10:5] && y_pos[190] == i_vcnt[10:5] && en[190] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[191] == i_hcnt[10:5] && y_pos[191] == i_vcnt[10:5] && en[191] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[192] == i_hcnt[10:5] && y_pos[192] == i_vcnt[10:5] && en[192] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[193] == i_hcnt[10:5] && y_pos[193] == i_vcnt[10:5] && en[193] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[194] == i_hcnt[10:5] && y_pos[194] == i_vcnt[10:5] && en[194] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[195] == i_hcnt[10:5] && y_pos[195] == i_vcnt[10:5] && en[195] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[196] == i_hcnt[10:5] && y_pos[196] == i_vcnt[10:5] && en[196] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[197] == i_hcnt[10:5] && y_pos[197] == i_vcnt[10:5] && en[197] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[198] == i_hcnt[10:5] && y_pos[198] == i_vcnt[10:5] && en[198] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[199] == i_hcnt[10:5] && y_pos[199] == i_vcnt[10:5] && en[199] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[200] == i_hcnt[10:5] && y_pos[200] == i_vcnt[10:5] && en[200] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[201] == i_hcnt[10:5] && y_pos[201] == i_vcnt[10:5] && en[201] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[202] == i_hcnt[10:5] && y_pos[202] == i_vcnt[10:5] && en[202] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[203] == i_hcnt[10:5] && y_pos[203] == i_vcnt[10:5] && en[203] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[204] == i_hcnt[10:5] && y_pos[204] == i_vcnt[10:5] && en[204] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[205] == i_hcnt[10:5] && y_pos[205] == i_vcnt[10:5] && en[205] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[206] == i_hcnt[10:5] && y_pos[206] == i_vcnt[10:5] && en[206] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[207] == i_hcnt[10:5] && y_pos[207] == i_vcnt[10:5] && en[207] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[208] == i_hcnt[10:5] && y_pos[208] == i_vcnt[10:5] && en[208] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[209] == i_hcnt[10:5] && y_pos[209] == i_vcnt[10:5] && en[209] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[210] == i_hcnt[10:5] && y_pos[210] == i_vcnt[10:5] && en[210] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[211] == i_hcnt[10:5] && y_pos[211] == i_vcnt[10:5] && en[211] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[212] == i_hcnt[10:5] && y_pos[212] == i_vcnt[10:5] && en[212] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[213] == i_hcnt[10:5] && y_pos[213] == i_vcnt[10:5] && en[213] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[214] == i_hcnt[10:5] && y_pos[214] == i_vcnt[10:5] && en[214] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[215] == i_hcnt[10:5] && y_pos[215] == i_vcnt[10:5] && en[215] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[216] == i_hcnt[10:5] && y_pos[216] == i_vcnt[10:5] && en[216] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[217] == i_hcnt[10:5] && y_pos[217] == i_vcnt[10:5] && en[217] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[218] == i_hcnt[10:5] && y_pos[218] == i_vcnt[10:5] && en[218] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[219] == i_hcnt[10:5] && y_pos[219] == i_vcnt[10:5] && en[219] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[220] == i_hcnt[10:5] && y_pos[220] == i_vcnt[10:5] && en[220] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[221] == i_hcnt[10:5] && y_pos[221] == i_vcnt[10:5] && en[221] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[222] == i_hcnt[10:5] && y_pos[222] == i_vcnt[10:5] && en[222] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[223] == i_hcnt[10:5] && y_pos[223] == i_vcnt[10:5] && en[223] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[224] == i_hcnt[10:5] && y_pos[224] == i_vcnt[10:5] && en[224] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[225] == i_hcnt[10:5] && y_pos[225] == i_vcnt[10:5] && en[225] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[226] == i_hcnt[10:5] && y_pos[226] == i_vcnt[10:5] && en[226] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[227] == i_hcnt[10:5] && y_pos[227] == i_vcnt[10:5] && en[227] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[228] == i_hcnt[10:5] && y_pos[228] == i_vcnt[10:5] && en[228] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[229] == i_hcnt[10:5] && y_pos[229] == i_vcnt[10:5] && en[229] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[230] == i_hcnt[10:5] && y_pos[230] == i_vcnt[10:5] && en[230] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[231] == i_hcnt[10:5] && y_pos[231] == i_vcnt[10:5] && en[231] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[232] == i_hcnt[10:5] && y_pos[232] == i_vcnt[10:5] && en[232] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[233] == i_hcnt[10:5] && y_pos[233] == i_vcnt[10:5] && en[233] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[234] == i_hcnt[10:5] && y_pos[234] == i_vcnt[10:5] && en[234] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[235] == i_hcnt[10:5] && y_pos[235] == i_vcnt[10:5] && en[235] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[236] == i_hcnt[10:5] && y_pos[236] == i_vcnt[10:5] && en[236] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[237] == i_hcnt[10:5] && y_pos[237] == i_vcnt[10:5] && en[237] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[238] == i_hcnt[10:5] && y_pos[238] == i_vcnt[10:5] && en[238] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[239] == i_hcnt[10:5] && y_pos[239] == i_vcnt[10:5] && en[239] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[240] == i_hcnt[10:5] && y_pos[240] == i_vcnt[10:5] && en[240] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[241] == i_hcnt[10:5] && y_pos[241] == i_vcnt[10:5] && en[241] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[242] == i_hcnt[10:5] && y_pos[242] == i_vcnt[10:5] && en[242] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[243] == i_hcnt[10:5] && y_pos[243] == i_vcnt[10:5] && en[243] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[244] == i_hcnt[10:5] && y_pos[244] == i_vcnt[10:5] && en[244] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[245] == i_hcnt[10:5] && y_pos[245] == i_vcnt[10:5] && en[245] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[246] == i_hcnt[10:5] && y_pos[246] == i_vcnt[10:5] && en[246] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[247] == i_hcnt[10:5] && y_pos[247] == i_vcnt[10:5] && en[247] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[248] == i_hcnt[10:5] && y_pos[248] == i_vcnt[10:5] && en[248] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[249] == i_hcnt[10:5] && y_pos[249] == i_vcnt[10:5] && en[249] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[250] == i_hcnt[10:5] && y_pos[250] == i_vcnt[10:5] && en[250] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[251] == i_hcnt[10:5] && y_pos[251] == i_vcnt[10:5] && en[251] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[252] == i_hcnt[10:5] && y_pos[252] == i_vcnt[10:5] && en[252] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[253] == i_hcnt[10:5] && y_pos[253] == i_vcnt[10:5] && en[253] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[254] == i_hcnt[10:5] && y_pos[254] == i_vcnt[10:5] && en[254] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[255] == i_hcnt[10:5] && y_pos[255] == i_vcnt[10:5] && en[255] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[256] == i_hcnt[10:5] && y_pos[256] == i_vcnt[10:5] && en[256] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[257] == i_hcnt[10:5] && y_pos[257] == i_vcnt[10:5] && en[257] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[258] == i_hcnt[10:5] && y_pos[258] == i_vcnt[10:5] && en[258] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[259] == i_hcnt[10:5] && y_pos[259] == i_vcnt[10:5] && en[259] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[260] == i_hcnt[10:5] && y_pos[260] == i_vcnt[10:5] && en[260] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[261] == i_hcnt[10:5] && y_pos[261] == i_vcnt[10:5] && en[261] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[262] == i_hcnt[10:5] && y_pos[262] == i_vcnt[10:5] && en[262] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[263] == i_hcnt[10:5] && y_pos[263] == i_vcnt[10:5] && en[263] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[264] == i_hcnt[10:5] && y_pos[264] == i_vcnt[10:5] && en[264] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[265] == i_hcnt[10:5] && y_pos[265] == i_vcnt[10:5] && en[265] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[266] == i_hcnt[10:5] && y_pos[266] == i_vcnt[10:5] && en[266] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[267] == i_hcnt[10:5] && y_pos[267] == i_vcnt[10:5] && en[267] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[268] == i_hcnt[10:5] && y_pos[268] == i_vcnt[10:5] && en[268] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[269] == i_hcnt[10:5] && y_pos[269] == i_vcnt[10:5] && en[269] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[270] == i_hcnt[10:5] && y_pos[270] == i_vcnt[10:5] && en[270] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[271] == i_hcnt[10:5] && y_pos[271] == i_vcnt[10:5] && en[271] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[272] == i_hcnt[10:5] && y_pos[272] == i_vcnt[10:5] && en[272] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[273] == i_hcnt[10:5] && y_pos[273] == i_vcnt[10:5] && en[273] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[274] == i_hcnt[10:5] && y_pos[274] == i_vcnt[10:5] && en[274] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[275] == i_hcnt[10:5] && y_pos[275] == i_vcnt[10:5] && en[275] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[276] == i_hcnt[10:5] && y_pos[276] == i_vcnt[10:5] && en[276] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[277] == i_hcnt[10:5] && y_pos[277] == i_vcnt[10:5] && en[277] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[278] == i_hcnt[10:5] && y_pos[278] == i_vcnt[10:5] && en[278] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[279] == i_hcnt[10:5] && y_pos[279] == i_vcnt[10:5] && en[279] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[280] == i_hcnt[10:5] && y_pos[280] == i_vcnt[10:5] && en[280] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[281] == i_hcnt[10:5] && y_pos[281] == i_vcnt[10:5] && en[281] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[282] == i_hcnt[10:5] && y_pos[282] == i_vcnt[10:5] && en[282] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[283] == i_hcnt[10:5] && y_pos[283] == i_vcnt[10:5] && en[283] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[284] == i_hcnt[10:5] && y_pos[284] == i_vcnt[10:5] && en[284] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[285] == i_hcnt[10:5] && y_pos[285] == i_vcnt[10:5] && en[285] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[286] == i_hcnt[10:5] && y_pos[286] == i_vcnt[10:5] && en[286] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[287] == i_hcnt[10:5] && y_pos[287] == i_vcnt[10:5] && en[287] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[288] == i_hcnt[10:5] && y_pos[288] == i_vcnt[10:5] && en[288] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[289] == i_hcnt[10:5] && y_pos[289] == i_vcnt[10:5] && en[289] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[290] == i_hcnt[10:5] && y_pos[290] == i_vcnt[10:5] && en[290] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[291] == i_hcnt[10:5] && y_pos[291] == i_vcnt[10:5] && en[291] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[292] == i_hcnt[10:5] && y_pos[292] == i_vcnt[10:5] && en[292] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[293] == i_hcnt[10:5] && y_pos[293] == i_vcnt[10:5] && en[293] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[294] == i_hcnt[10:5] && y_pos[294] == i_vcnt[10:5] && en[294] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[295] == i_hcnt[10:5] && y_pos[295] == i_vcnt[10:5] && en[295] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[296] == i_hcnt[10:5] && y_pos[296] == i_vcnt[10:5] && en[296] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[297] == i_hcnt[10:5] && y_pos[297] == i_vcnt[10:5] && en[297] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[298] == i_hcnt[10:5] && y_pos[298] == i_vcnt[10:5] && en[298] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[299] == i_hcnt[10:5] && y_pos[299] == i_vcnt[10:5] && en[299] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[300] == i_hcnt[10:5] && y_pos[300] == i_vcnt[10:5] && en[300] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[301] == i_hcnt[10:5] && y_pos[301] == i_vcnt[10:5] && en[301] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[302] == i_hcnt[10:5] && y_pos[302] == i_vcnt[10:5] && en[302] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[303] == i_hcnt[10:5] && y_pos[303] == i_vcnt[10:5] && en[303] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[304] == i_hcnt[10:5] && y_pos[304] == i_vcnt[10:5] && en[304] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[305] == i_hcnt[10:5] && y_pos[305] == i_vcnt[10:5] && en[305] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[306] == i_hcnt[10:5] && y_pos[306] == i_vcnt[10:5] && en[306] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[307] == i_hcnt[10:5] && y_pos[307] == i_vcnt[10:5] && en[307] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[308] == i_hcnt[10:5] && y_pos[308] == i_vcnt[10:5] && en[308] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[309] == i_hcnt[10:5] && y_pos[309] == i_vcnt[10:5] && en[309] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[310] == i_hcnt[10:5] && y_pos[310] == i_vcnt[10:5] && en[310] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[311] == i_hcnt[10:5] && y_pos[311] == i_vcnt[10:5] && en[311] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[312] == i_hcnt[10:5] && y_pos[312] == i_vcnt[10:5] && en[312] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[313] == i_hcnt[10:5] && y_pos[313] == i_vcnt[10:5] && en[313] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[314] == i_hcnt[10:5] && y_pos[314] == i_vcnt[10:5] && en[314] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[315] == i_hcnt[10:5] && y_pos[315] == i_vcnt[10:5] && en[315] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[316] == i_hcnt[10:5] && y_pos[316] == i_vcnt[10:5] && en[316] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[317] == i_hcnt[10:5] && y_pos[317] == i_vcnt[10:5] && en[317] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[318] == i_hcnt[10:5] && y_pos[318] == i_vcnt[10:5] && en[318] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[319] == i_hcnt[10:5] && y_pos[319] == i_vcnt[10:5] && en[319] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[320] == i_hcnt[10:5] && y_pos[320] == i_vcnt[10:5] && en[320] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[321] == i_hcnt[10:5] && y_pos[321] == i_vcnt[10:5] && en[321] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[322] == i_hcnt[10:5] && y_pos[322] == i_vcnt[10:5] && en[322] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[323] == i_hcnt[10:5] && y_pos[323] == i_vcnt[10:5] && en[323] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[324] == i_hcnt[10:5] && y_pos[324] == i_vcnt[10:5] && en[324] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[325] == i_hcnt[10:5] && y_pos[325] == i_vcnt[10:5] && en[325] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[326] == i_hcnt[10:5] && y_pos[326] == i_vcnt[10:5] && en[326] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[327] == i_hcnt[10:5] && y_pos[327] == i_vcnt[10:5] && en[327] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[328] == i_hcnt[10:5] && y_pos[328] == i_vcnt[10:5] && en[328] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[329] == i_hcnt[10:5] && y_pos[329] == i_vcnt[10:5] && en[329] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[330] == i_hcnt[10:5] && y_pos[330] == i_vcnt[10:5] && en[330] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[331] == i_hcnt[10:5] && y_pos[331] == i_vcnt[10:5] && en[331] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[332] == i_hcnt[10:5] && y_pos[332] == i_vcnt[10:5] && en[332] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[333] == i_hcnt[10:5] && y_pos[333] == i_vcnt[10:5] && en[333] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[334] == i_hcnt[10:5] && y_pos[334] == i_vcnt[10:5] && en[334] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[335] == i_hcnt[10:5] && y_pos[335] == i_vcnt[10:5] && en[335] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[336] == i_hcnt[10:5] && y_pos[336] == i_vcnt[10:5] && en[336] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[337] == i_hcnt[10:5] && y_pos[337] == i_vcnt[10:5] && en[337] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[338] == i_hcnt[10:5] && y_pos[338] == i_vcnt[10:5] && en[338] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[339] == i_hcnt[10:5] && y_pos[339] == i_vcnt[10:5] && en[339] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[340] == i_hcnt[10:5] && y_pos[340] == i_vcnt[10:5] && en[340] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[341] == i_hcnt[10:5] && y_pos[341] == i_vcnt[10:5] && en[341] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[342] == i_hcnt[10:5] && y_pos[342] == i_vcnt[10:5] && en[342] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[343] == i_hcnt[10:5] && y_pos[343] == i_vcnt[10:5] && en[343] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[344] == i_hcnt[10:5] && y_pos[344] == i_vcnt[10:5] && en[344] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[345] == i_hcnt[10:5] && y_pos[345] == i_vcnt[10:5] && en[345] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[346] == i_hcnt[10:5] && y_pos[346] == i_vcnt[10:5] && en[346] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[347] == i_hcnt[10:5] && y_pos[347] == i_vcnt[10:5] && en[347] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[348] == i_hcnt[10:5] && y_pos[348] == i_vcnt[10:5] && en[348] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[349] == i_hcnt[10:5] && y_pos[349] == i_vcnt[10:5] && en[349] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[350] == i_hcnt[10:5] && y_pos[350] == i_vcnt[10:5] && en[350] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[351] == i_hcnt[10:5] && y_pos[351] == i_vcnt[10:5] && en[351] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[352] == i_hcnt[10:5] && y_pos[352] == i_vcnt[10:5] && en[352] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[353] == i_hcnt[10:5] && y_pos[353] == i_vcnt[10:5] && en[353] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[354] == i_hcnt[10:5] && y_pos[354] == i_vcnt[10:5] && en[354] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[355] == i_hcnt[10:5] && y_pos[355] == i_vcnt[10:5] && en[355] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[356] == i_hcnt[10:5] && y_pos[356] == i_vcnt[10:5] && en[356] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[357] == i_hcnt[10:5] && y_pos[357] == i_vcnt[10:5] && en[357] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[358] == i_hcnt[10:5] && y_pos[358] == i_vcnt[10:5] && en[358] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[359] == i_hcnt[10:5] && y_pos[359] == i_vcnt[10:5] && en[359] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[360] == i_hcnt[10:5] && y_pos[360] == i_vcnt[10:5] && en[360] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[361] == i_hcnt[10:5] && y_pos[361] == i_vcnt[10:5] && en[361] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[362] == i_hcnt[10:5] && y_pos[362] == i_vcnt[10:5] && en[362] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[363] == i_hcnt[10:5] && y_pos[363] == i_vcnt[10:5] && en[363] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[364] == i_hcnt[10:5] && y_pos[364] == i_vcnt[10:5] && en[364] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[365] == i_hcnt[10:5] && y_pos[365] == i_vcnt[10:5] && en[365] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[366] == i_hcnt[10:5] && y_pos[366] == i_vcnt[10:5] && en[366] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[367] == i_hcnt[10:5] && y_pos[367] == i_vcnt[10:5] && en[367] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[368] == i_hcnt[10:5] && y_pos[368] == i_vcnt[10:5] && en[368] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[369] == i_hcnt[10:5] && y_pos[369] == i_vcnt[10:5] && en[369] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[370] == i_hcnt[10:5] && y_pos[370] == i_vcnt[10:5] && en[370] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[371] == i_hcnt[10:5] && y_pos[371] == i_vcnt[10:5] && en[371] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[372] == i_hcnt[10:5] && y_pos[372] == i_vcnt[10:5] && en[372] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[373] == i_hcnt[10:5] && y_pos[373] == i_vcnt[10:5] && en[373] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[374] == i_hcnt[10:5] && y_pos[374] == i_vcnt[10:5] && en[374] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[375] == i_hcnt[10:5] && y_pos[375] == i_vcnt[10:5] && en[375] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[376] == i_hcnt[10:5] && y_pos[376] == i_vcnt[10:5] && en[376] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[377] == i_hcnt[10:5] && y_pos[377] == i_vcnt[10:5] && en[377] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[378] == i_hcnt[10:5] && y_pos[378] == i_vcnt[10:5] && en[378] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[379] == i_hcnt[10:5] && y_pos[379] == i_vcnt[10:5] && en[379] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[380] == i_hcnt[10:5] && y_pos[380] == i_vcnt[10:5] && en[380] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[381] == i_hcnt[10:5] && y_pos[381] == i_vcnt[10:5] && en[381] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[382] == i_hcnt[10:5] && y_pos[382] == i_vcnt[10:5] && en[382] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[383] == i_hcnt[10:5] && y_pos[383] == i_vcnt[10:5] && en[383] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[384] == i_hcnt[10:5] && y_pos[384] == i_vcnt[10:5] && en[384] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[385] == i_hcnt[10:5] && y_pos[385] == i_vcnt[10:5] && en[385] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[386] == i_hcnt[10:5] && y_pos[386] == i_vcnt[10:5] && en[386] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[387] == i_hcnt[10:5] && y_pos[387] == i_vcnt[10:5] && en[387] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[388] == i_hcnt[10:5] && y_pos[388] == i_vcnt[10:5] && en[388] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[389] == i_hcnt[10:5] && y_pos[389] == i_vcnt[10:5] && en[389] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[390] == i_hcnt[10:5] && y_pos[390] == i_vcnt[10:5] && en[390] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[391] == i_hcnt[10:5] && y_pos[391] == i_vcnt[10:5] && en[391] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[392] == i_hcnt[10:5] && y_pos[392] == i_vcnt[10:5] && en[392] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[393] == i_hcnt[10:5] && y_pos[393] == i_vcnt[10:5] && en[393] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[394] == i_hcnt[10:5] && y_pos[394] == i_vcnt[10:5] && en[394] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[395] == i_hcnt[10:5] && y_pos[395] == i_vcnt[10:5] && en[395] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[396] == i_hcnt[10:5] && y_pos[396] == i_vcnt[10:5] && en[396] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[397] == i_hcnt[10:5] && y_pos[397] == i_vcnt[10:5] && en[397] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[398] == i_hcnt[10:5] && y_pos[398] == i_vcnt[10:5] && en[398] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[399] == i_hcnt[10:5] && y_pos[399] == i_vcnt[10:5] && en[399] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[400] == i_hcnt[10:5] && y_pos[400] == i_vcnt[10:5] && en[400] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[401] == i_hcnt[10:5] && y_pos[401] == i_vcnt[10:5] && en[401] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[402] == i_hcnt[10:5] && y_pos[402] == i_vcnt[10:5] && en[402] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[403] == i_hcnt[10:5] && y_pos[403] == i_vcnt[10:5] && en[403] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[404] == i_hcnt[10:5] && y_pos[404] == i_vcnt[10:5] && en[404] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[405] == i_hcnt[10:5] && y_pos[405] == i_vcnt[10:5] && en[405] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[406] == i_hcnt[10:5] && y_pos[406] == i_vcnt[10:5] && en[406] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[407] == i_hcnt[10:5] && y_pos[407] == i_vcnt[10:5] && en[407] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[408] == i_hcnt[10:5] && y_pos[408] == i_vcnt[10:5] && en[408] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[409] == i_hcnt[10:5] && y_pos[409] == i_vcnt[10:5] && en[409] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[410] == i_hcnt[10:5] && y_pos[410] == i_vcnt[10:5] && en[410] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[411] == i_hcnt[10:5] && y_pos[411] == i_vcnt[10:5] && en[411] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[412] == i_hcnt[10:5] && y_pos[412] == i_vcnt[10:5] && en[412] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[413] == i_hcnt[10:5] && y_pos[413] == i_vcnt[10:5] && en[413] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[414] == i_hcnt[10:5] && y_pos[414] == i_vcnt[10:5] && en[414] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[415] == i_hcnt[10:5] && y_pos[415] == i_vcnt[10:5] && en[415] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[416] == i_hcnt[10:5] && y_pos[416] == i_vcnt[10:5] && en[416] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[417] == i_hcnt[10:5] && y_pos[417] == i_vcnt[10:5] && en[417] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[418] == i_hcnt[10:5] && y_pos[418] == i_vcnt[10:5] && en[418] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[419] == i_hcnt[10:5] && y_pos[419] == i_vcnt[10:5] && en[419] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[420] == i_hcnt[10:5] && y_pos[420] == i_vcnt[10:5] && en[420] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[421] == i_hcnt[10:5] && y_pos[421] == i_vcnt[10:5] && en[421] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[422] == i_hcnt[10:5] && y_pos[422] == i_vcnt[10:5] && en[422] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[423] == i_hcnt[10:5] && y_pos[423] == i_vcnt[10:5] && en[423] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[424] == i_hcnt[10:5] && y_pos[424] == i_vcnt[10:5] && en[424] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[425] == i_hcnt[10:5] && y_pos[425] == i_vcnt[10:5] && en[425] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[426] == i_hcnt[10:5] && y_pos[426] == i_vcnt[10:5] && en[426] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[427] == i_hcnt[10:5] && y_pos[427] == i_vcnt[10:5] && en[427] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[428] == i_hcnt[10:5] && y_pos[428] == i_vcnt[10:5] && en[428] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[429] == i_hcnt[10:5] && y_pos[429] == i_vcnt[10:5] && en[429] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[430] == i_hcnt[10:5] && y_pos[430] == i_vcnt[10:5] && en[430] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[431] == i_hcnt[10:5] && y_pos[431] == i_vcnt[10:5] && en[431] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[432] == i_hcnt[10:5] && y_pos[432] == i_vcnt[10:5] && en[432] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[433] == i_hcnt[10:5] && y_pos[433] == i_vcnt[10:5] && en[433] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[434] == i_hcnt[10:5] && y_pos[434] == i_vcnt[10:5] && en[434] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[435] == i_hcnt[10:5] && y_pos[435] == i_vcnt[10:5] && en[435] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[436] == i_hcnt[10:5] && y_pos[436] == i_vcnt[10:5] && en[436] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[437] == i_hcnt[10:5] && y_pos[437] == i_vcnt[10:5] && en[437] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[438] == i_hcnt[10:5] && y_pos[438] == i_vcnt[10:5] && en[438] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[439] == i_hcnt[10:5] && y_pos[439] == i_vcnt[10:5] && en[439] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[440] == i_hcnt[10:5] && y_pos[440] == i_vcnt[10:5] && en[440] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[441] == i_hcnt[10:5] && y_pos[441] == i_vcnt[10:5] && en[441] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[442] == i_hcnt[10:5] && y_pos[442] == i_vcnt[10:5] && en[442] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[443] == i_hcnt[10:5] && y_pos[443] == i_vcnt[10:5] && en[443] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[444] == i_hcnt[10:5] && y_pos[444] == i_vcnt[10:5] && en[444] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[445] == i_hcnt[10:5] && y_pos[445] == i_vcnt[10:5] && en[445] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[446] == i_hcnt[10:5] && y_pos[446] == i_vcnt[10:5] && en[446] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[447] == i_hcnt[10:5] && y_pos[447] == i_vcnt[10:5] && en[447] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[448] == i_hcnt[10:5] && y_pos[448] == i_vcnt[10:5] && en[448] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[449] == i_hcnt[10:5] && y_pos[449] == i_vcnt[10:5] && en[449] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[450] == i_hcnt[10:5] && y_pos[450] == i_vcnt[10:5] && en[450] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[451] == i_hcnt[10:5] && y_pos[451] == i_vcnt[10:5] && en[451] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[452] == i_hcnt[10:5] && y_pos[452] == i_vcnt[10:5] && en[452] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[453] == i_hcnt[10:5] && y_pos[453] == i_vcnt[10:5] && en[453] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[454] == i_hcnt[10:5] && y_pos[454] == i_vcnt[10:5] && en[454] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[455] == i_hcnt[10:5] && y_pos[455] == i_vcnt[10:5] && en[455] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[456] == i_hcnt[10:5] && y_pos[456] == i_vcnt[10:5] && en[456] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[457] == i_hcnt[10:5] && y_pos[457] == i_vcnt[10:5] && en[457] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[458] == i_hcnt[10:5] && y_pos[458] == i_vcnt[10:5] && en[458] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[459] == i_hcnt[10:5] && y_pos[459] == i_vcnt[10:5] && en[459] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[460] == i_hcnt[10:5] && y_pos[460] == i_vcnt[10:5] && en[460] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[461] == i_hcnt[10:5] && y_pos[461] == i_vcnt[10:5] && en[461] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[462] == i_hcnt[10:5] && y_pos[462] == i_vcnt[10:5] && en[462] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[463] == i_hcnt[10:5] && y_pos[463] == i_vcnt[10:5] && en[463] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[464] == i_hcnt[10:5] && y_pos[464] == i_vcnt[10:5] && en[464] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[465] == i_hcnt[10:5] && y_pos[465] == i_vcnt[10:5] && en[465] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[466] == i_hcnt[10:5] && y_pos[466] == i_vcnt[10:5] && en[466] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[467] == i_hcnt[10:5] && y_pos[467] == i_vcnt[10:5] && en[467] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[468] == i_hcnt[10:5] && y_pos[468] == i_vcnt[10:5] && en[468] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[469] == i_hcnt[10:5] && y_pos[469] == i_vcnt[10:5] && en[469] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[470] == i_hcnt[10:5] && y_pos[470] == i_vcnt[10:5] && en[470] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[471] == i_hcnt[10:5] && y_pos[471] == i_vcnt[10:5] && en[471] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[472] == i_hcnt[10:5] && y_pos[472] == i_vcnt[10:5] && en[472] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[473] == i_hcnt[10:5] && y_pos[473] == i_vcnt[10:5] && en[473] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[474] == i_hcnt[10:5] && y_pos[474] == i_vcnt[10:5] && en[474] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[475] == i_hcnt[10:5] && y_pos[475] == i_vcnt[10:5] && en[475] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[476] == i_hcnt[10:5] && y_pos[476] == i_vcnt[10:5] && en[476] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[477] == i_hcnt[10:5] && y_pos[477] == i_vcnt[10:5] && en[477] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[478] == i_hcnt[10:5] && y_pos[478] == i_vcnt[10:5] && en[478] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[479] == i_hcnt[10:5] && y_pos[479] == i_vcnt[10:5] && en[479] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[480] == i_hcnt[10:5] && y_pos[480] == i_vcnt[10:5] && en[480] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[481] == i_hcnt[10:5] && y_pos[481] == i_vcnt[10:5] && en[481] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[482] == i_hcnt[10:5] && y_pos[482] == i_vcnt[10:5] && en[482] == 1'b1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[483] == i_hcnt[10:5] && y_pos[483] == i_vcnt[10:5] && en[483] == 1'b1) begin
>>>>>>> parent of 6d2d99c... failures gonna change plans
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
