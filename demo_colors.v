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
	
	wire [5:0] x_pos [0:484];
	wire [5:0] y_pos [0:484];
	
	reg [5:0] x_in;
	reg [5:0] y_in;
	assign x_pos[0] = x_in;
	assign y_pos[0] = y_in;
	
	genvar j;
	generate
		for (j=1; j<485; j=j+1) begin
			if(j==1) begin
				six_bit_register #(6'd16) Jth_x_reg (x_pos[j-1], x_pos[j], i_clk_74M, 1'b0);
				six_bit_register #(6'd16) Jth_y_reg (y_pos[j-1], y_pos[j], i_clk_74M, 1'b0);
			end else begin
				six_bit_register #(6'd0) Jth_x_reg (x_pos[j-1], x_pos[j], i_clk_74M, 1'b0);
				six_bit_register #(6'd0) Jth_y_reg (y_pos[j-1], y_pos[j], i_clk_74M, 1'b0);
			end
		end
	endgenerate
	
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
			if(direction == 2'b00) begin
				if(x_pos[1] < 22) begin
					x_in <= x_pos[1] + 1;
					direction <= 2'b00;
				end else begin
					x_in <= x_pos[1] - 1;
					direction <= 2'b01;
				end
				if(x_pos[1] + 1 == x_pos_a && y_pos[1] == y_pos_a) begin
					score <= score + 1;
				end
			end else if(direction == 2'b01) begin
				if(x_pos[1] > 0+1) begin
					x_in <= x_pos[1] - 1;
					direction <= 2'b01;
				end else begin
					x_in <= x_pos[1] + 1;
					direction <= 2'b00;
				end
				if(x_pos[1] - 1 == x_pos_a && y_pos[1] == y_pos_a) begin
					score <= score + 1;
				end
			end else if(direction == 2'b11) begin
				if(y_pos[1] < 22) begin
					y_in <= y_pos[1] + 1;
					direction <= 2'b11;
				end else begin
					y_in <= y_pos[1] - 1;
					direction <= 2'b10;
				end
				if(x_pos[1] == x_pos_a && y_pos[1] + 1 == y_pos_a) begin
					score <= score + 1;
				end
			end else if(direction == 2'b10) begin
				if(y_pos[1] > 0+1) begin
					y_in <= y_pos[1] - 1;
					direction <= 2'b10;
				end else begin
					y_in <= y_pos[1] + 1;
					direction <= 2'b11;
				end
				if(x_pos[1] == x_pos_a && y_pos[1] - 1 == y_pos_a) begin
					score <= score + 1;
				end
			end
		end else begin
			cnt <= cnt + 1;
			x_in  <= x_pos[1];
		   y_in  <= y_pos[1];
		end
	end
	
	always @ (posedge i_clk_74M) begin	
		
		if(x_pos_b <= i_hcnt[10:5] && x_pos_b + 6'd24 > i_hcnt[10:5] && y_pos_b == i_vcnt[10:5]) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(x_pos_b <= i_hcnt[10:5] && x_pos_b + 6'd24 > i_hcnt[10:5] && y_pos_b == i_vcnt[10:5] - 6'd23) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(y_pos_b <= i_vcnt[10:5] && y_pos_b + 6'd24 > i_vcnt[10:5] && x_pos_b == i_hcnt[10:5]) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(y_pos_b <= i_vcnt[10:5] && y_pos_b + 6'd24 > i_vcnt[10:5] && x_pos_b == i_hcnt[10:5] - 6'd23) begin
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(x_pos[1] == i_hcnt[10:5] && y_pos[1] == i_vcnt[10:5] && score <= 0) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2] == i_hcnt[10:5] && y_pos[2] == i_vcnt[10:5] && score <= 1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[3] == i_hcnt[10:5] && y_pos[3] == i_vcnt[10:5] && score <= 2) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[4] == i_hcnt[10:5] && y_pos[4] == i_vcnt[10:5] && score <= 3) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[5] == i_hcnt[10:5] && y_pos[5] == i_vcnt[10:5] && score <= 4) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[6] == i_hcnt[10:5] && y_pos[6] == i_vcnt[10:5] && score <= 5) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[7] == i_hcnt[10:5] && y_pos[7] == i_vcnt[10:5] && score <= 6) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[8] == i_hcnt[10:5] && y_pos[8] == i_vcnt[10:5] && score <= 7) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[9] == i_hcnt[10:5] && y_pos[9] == i_vcnt[10:5] && score <= 8) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[10] == i_hcnt[10:5] && y_pos[10] == i_vcnt[10:5] && score <= 9) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[11] == i_hcnt[10:5] && y_pos[11] == i_vcnt[10:5] && score <= 10) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[12] == i_hcnt[10:5] && y_pos[12] == i_vcnt[10:5] && score <= 11) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[13] == i_hcnt[10:5] && y_pos[13] == i_vcnt[10:5] && score <= 12) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[14] == i_hcnt[10:5] && y_pos[14] == i_vcnt[10:5] && score <= 13) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[15] == i_hcnt[10:5] && y_pos[15] == i_vcnt[10:5] && score <= 14) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[16] == i_hcnt[10:5] && y_pos[16] == i_vcnt[10:5] && score <= 15) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[17] == i_hcnt[10:5] && y_pos[17] == i_vcnt[10:5] && score <= 16) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[18] == i_hcnt[10:5] && y_pos[18] == i_vcnt[10:5] && score <= 17) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[19] == i_hcnt[10:5] && y_pos[19] == i_vcnt[10:5] && score <= 18) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[20] == i_hcnt[10:5] && y_pos[20] == i_vcnt[10:5] && score <= 19) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[21] == i_hcnt[10:5] && y_pos[21] == i_vcnt[10:5] && score <= 20) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[22] == i_hcnt[10:5] && y_pos[22] == i_vcnt[10:5] && score <= 21) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[23] == i_hcnt[10:5] && y_pos[23] == i_vcnt[10:5] && score <= 22) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[24] == i_hcnt[10:5] && y_pos[24] == i_vcnt[10:5] && score <= 23) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[25] == i_hcnt[10:5] && y_pos[25] == i_vcnt[10:5] && score <= 24) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[26] == i_hcnt[10:5] && y_pos[26] == i_vcnt[10:5] && score <= 25) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[27] == i_hcnt[10:5] && y_pos[27] == i_vcnt[10:5] && score <= 26) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[28] == i_hcnt[10:5] && y_pos[28] == i_vcnt[10:5] && score <= 27) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[29] == i_hcnt[10:5] && y_pos[29] == i_vcnt[10:5] && score <= 28) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[30] == i_hcnt[10:5] && y_pos[30] == i_vcnt[10:5] && score <= 29) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[31] == i_hcnt[10:5] && y_pos[31] == i_vcnt[10:5] && score <= 30) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[32] == i_hcnt[10:5] && y_pos[32] == i_vcnt[10:5] && score <= 31) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[33] == i_hcnt[10:5] && y_pos[33] == i_vcnt[10:5] && score <= 32) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[34] == i_hcnt[10:5] && y_pos[34] == i_vcnt[10:5] && score <= 33) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[35] == i_hcnt[10:5] && y_pos[35] == i_vcnt[10:5] && score <= 34) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[36] == i_hcnt[10:5] && y_pos[36] == i_vcnt[10:5] && score <= 35) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[37] == i_hcnt[10:5] && y_pos[37] == i_vcnt[10:5] && score <= 36) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[38] == i_hcnt[10:5] && y_pos[38] == i_vcnt[10:5] && score <= 37) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[39] == i_hcnt[10:5] && y_pos[39] == i_vcnt[10:5] && score <= 38) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[40] == i_hcnt[10:5] && y_pos[40] == i_vcnt[10:5] && score <= 39) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[41] == i_hcnt[10:5] && y_pos[41] == i_vcnt[10:5] && score <= 40) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[42] == i_hcnt[10:5] && y_pos[42] == i_vcnt[10:5] && score <= 41) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[43] == i_hcnt[10:5] && y_pos[43] == i_vcnt[10:5] && score <= 42) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[44] == i_hcnt[10:5] && y_pos[44] == i_vcnt[10:5] && score <= 43) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[45] == i_hcnt[10:5] && y_pos[45] == i_vcnt[10:5] && score <= 44) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[46] == i_hcnt[10:5] && y_pos[46] == i_vcnt[10:5] && score <= 45) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[47] == i_hcnt[10:5] && y_pos[47] == i_vcnt[10:5] && score <= 46) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[48] == i_hcnt[10:5] && y_pos[48] == i_vcnt[10:5] && score <= 47) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[49] == i_hcnt[10:5] && y_pos[49] == i_vcnt[10:5] && score <= 48) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[50] == i_hcnt[10:5] && y_pos[50] == i_vcnt[10:5] && score <= 49) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[51] == i_hcnt[10:5] && y_pos[51] == i_vcnt[10:5] && score <= 50) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[52] == i_hcnt[10:5] && y_pos[52] == i_vcnt[10:5] && score <= 51) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[53] == i_hcnt[10:5] && y_pos[53] == i_vcnt[10:5] && score <= 52) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[54] == i_hcnt[10:5] && y_pos[54] == i_vcnt[10:5] && score <= 53) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[55] == i_hcnt[10:5] && y_pos[55] == i_vcnt[10:5] && score <= 54) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[56] == i_hcnt[10:5] && y_pos[56] == i_vcnt[10:5] && score <= 55) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[57] == i_hcnt[10:5] && y_pos[57] == i_vcnt[10:5] && score <= 56) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[58] == i_hcnt[10:5] && y_pos[58] == i_vcnt[10:5] && score <= 57) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[59] == i_hcnt[10:5] && y_pos[59] == i_vcnt[10:5] && score <= 58) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[60] == i_hcnt[10:5] && y_pos[60] == i_vcnt[10:5] && score <= 59) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[61] == i_hcnt[10:5] && y_pos[61] == i_vcnt[10:5] && score <= 60) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[62] == i_hcnt[10:5] && y_pos[62] == i_vcnt[10:5] && score <= 61) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[63] == i_hcnt[10:5] && y_pos[63] == i_vcnt[10:5] && score <= 62) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[64] == i_hcnt[10:5] && y_pos[64] == i_vcnt[10:5] && score <= 63) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[65] == i_hcnt[10:5] && y_pos[65] == i_vcnt[10:5] && score <= 64) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[66] == i_hcnt[10:5] && y_pos[66] == i_vcnt[10:5] && score <= 65) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[67] == i_hcnt[10:5] && y_pos[67] == i_vcnt[10:5] && score <= 66) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[68] == i_hcnt[10:5] && y_pos[68] == i_vcnt[10:5] && score <= 67) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[69] == i_hcnt[10:5] && y_pos[69] == i_vcnt[10:5] && score <= 68) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[70] == i_hcnt[10:5] && y_pos[70] == i_vcnt[10:5] && score <= 69) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[71] == i_hcnt[10:5] && y_pos[71] == i_vcnt[10:5] && score <= 70) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[72] == i_hcnt[10:5] && y_pos[72] == i_vcnt[10:5] && score <= 71) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[73] == i_hcnt[10:5] && y_pos[73] == i_vcnt[10:5] && score <= 72) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[74] == i_hcnt[10:5] && y_pos[74] == i_vcnt[10:5] && score <= 73) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[75] == i_hcnt[10:5] && y_pos[75] == i_vcnt[10:5] && score <= 74) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[76] == i_hcnt[10:5] && y_pos[76] == i_vcnt[10:5] && score <= 75) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[77] == i_hcnt[10:5] && y_pos[77] == i_vcnt[10:5] && score <= 76) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[78] == i_hcnt[10:5] && y_pos[78] == i_vcnt[10:5] && score <= 77) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[79] == i_hcnt[10:5] && y_pos[79] == i_vcnt[10:5] && score <= 78) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[80] == i_hcnt[10:5] && y_pos[80] == i_vcnt[10:5] && score <= 79) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[81] == i_hcnt[10:5] && y_pos[81] == i_vcnt[10:5] && score <= 80) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[82] == i_hcnt[10:5] && y_pos[82] == i_vcnt[10:5] && score <= 81) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[83] == i_hcnt[10:5] && y_pos[83] == i_vcnt[10:5] && score <= 82) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[84] == i_hcnt[10:5] && y_pos[84] == i_vcnt[10:5] && score <= 83) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[85] == i_hcnt[10:5] && y_pos[85] == i_vcnt[10:5] && score <= 84) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[86] == i_hcnt[10:5] && y_pos[86] == i_vcnt[10:5] && score <= 85) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[87] == i_hcnt[10:5] && y_pos[87] == i_vcnt[10:5] && score <= 86) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[88] == i_hcnt[10:5] && y_pos[88] == i_vcnt[10:5] && score <= 87) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[89] == i_hcnt[10:5] && y_pos[89] == i_vcnt[10:5] && score <= 88) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[90] == i_hcnt[10:5] && y_pos[90] == i_vcnt[10:5] && score <= 89) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[91] == i_hcnt[10:5] && y_pos[91] == i_vcnt[10:5] && score <= 90) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[92] == i_hcnt[10:5] && y_pos[92] == i_vcnt[10:5] && score <= 91) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[93] == i_hcnt[10:5] && y_pos[93] == i_vcnt[10:5] && score <= 92) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[94] == i_hcnt[10:5] && y_pos[94] == i_vcnt[10:5] && score <= 93) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[95] == i_hcnt[10:5] && y_pos[95] == i_vcnt[10:5] && score <= 94) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[96] == i_hcnt[10:5] && y_pos[96] == i_vcnt[10:5] && score <= 95) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[97] == i_hcnt[10:5] && y_pos[97] == i_vcnt[10:5] && score <= 96) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[98] == i_hcnt[10:5] && y_pos[98] == i_vcnt[10:5] && score <= 97) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[99] == i_hcnt[10:5] && y_pos[99] == i_vcnt[10:5] && score <= 98) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[100] == i_hcnt[10:5] && y_pos[100] == i_vcnt[10:5] && score <= 99) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[101] == i_hcnt[10:5] && y_pos[101] == i_vcnt[10:5] && score <= 100) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[102] == i_hcnt[10:5] && y_pos[102] == i_vcnt[10:5] && score <= 101) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[103] == i_hcnt[10:5] && y_pos[103] == i_vcnt[10:5] && score <= 102) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[104] == i_hcnt[10:5] && y_pos[104] == i_vcnt[10:5] && score <= 103) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[105] == i_hcnt[10:5] && y_pos[105] == i_vcnt[10:5] && score <= 104) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[106] == i_hcnt[10:5] && y_pos[106] == i_vcnt[10:5] && score <= 105) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[107] == i_hcnt[10:5] && y_pos[107] == i_vcnt[10:5] && score <= 106) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[108] == i_hcnt[10:5] && y_pos[108] == i_vcnt[10:5] && score <= 107) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[109] == i_hcnt[10:5] && y_pos[109] == i_vcnt[10:5] && score <= 108) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[110] == i_hcnt[10:5] && y_pos[110] == i_vcnt[10:5] && score <= 109) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[111] == i_hcnt[10:5] && y_pos[111] == i_vcnt[10:5] && score <= 110) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[112] == i_hcnt[10:5] && y_pos[112] == i_vcnt[10:5] && score <= 111) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[113] == i_hcnt[10:5] && y_pos[113] == i_vcnt[10:5] && score <= 112) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[114] == i_hcnt[10:5] && y_pos[114] == i_vcnt[10:5] && score <= 113) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[115] == i_hcnt[10:5] && y_pos[115] == i_vcnt[10:5] && score <= 114) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[116] == i_hcnt[10:5] && y_pos[116] == i_vcnt[10:5] && score <= 115) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[117] == i_hcnt[10:5] && y_pos[117] == i_vcnt[10:5] && score <= 116) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[118] == i_hcnt[10:5] && y_pos[118] == i_vcnt[10:5] && score <= 117) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[119] == i_hcnt[10:5] && y_pos[119] == i_vcnt[10:5] && score <= 118) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[120] == i_hcnt[10:5] && y_pos[120] == i_vcnt[10:5] && score <= 119) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[121] == i_hcnt[10:5] && y_pos[121] == i_vcnt[10:5] && score <= 120) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[122] == i_hcnt[10:5] && y_pos[122] == i_vcnt[10:5] && score <= 121) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[123] == i_hcnt[10:5] && y_pos[123] == i_vcnt[10:5] && score <= 122) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[124] == i_hcnt[10:5] && y_pos[124] == i_vcnt[10:5] && score <= 123) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[125] == i_hcnt[10:5] && y_pos[125] == i_vcnt[10:5] && score <= 124) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[126] == i_hcnt[10:5] && y_pos[126] == i_vcnt[10:5] && score <= 125) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[127] == i_hcnt[10:5] && y_pos[127] == i_vcnt[10:5] && score <= 126) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[128] == i_hcnt[10:5] && y_pos[128] == i_vcnt[10:5] && score <= 127) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[129] == i_hcnt[10:5] && y_pos[129] == i_vcnt[10:5] && score <= 128) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[130] == i_hcnt[10:5] && y_pos[130] == i_vcnt[10:5] && score <= 129) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[131] == i_hcnt[10:5] && y_pos[131] == i_vcnt[10:5] && score <= 130) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[132] == i_hcnt[10:5] && y_pos[132] == i_vcnt[10:5] && score <= 131) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[133] == i_hcnt[10:5] && y_pos[133] == i_vcnt[10:5] && score <= 132) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[134] == i_hcnt[10:5] && y_pos[134] == i_vcnt[10:5] && score <= 133) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[135] == i_hcnt[10:5] && y_pos[135] == i_vcnt[10:5] && score <= 134) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[136] == i_hcnt[10:5] && y_pos[136] == i_vcnt[10:5] && score <= 135) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[137] == i_hcnt[10:5] && y_pos[137] == i_vcnt[10:5] && score <= 136) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[138] == i_hcnt[10:5] && y_pos[138] == i_vcnt[10:5] && score <= 137) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[139] == i_hcnt[10:5] && y_pos[139] == i_vcnt[10:5] && score <= 138) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[140] == i_hcnt[10:5] && y_pos[140] == i_vcnt[10:5] && score <= 139) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[141] == i_hcnt[10:5] && y_pos[141] == i_vcnt[10:5] && score <= 140) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[142] == i_hcnt[10:5] && y_pos[142] == i_vcnt[10:5] && score <= 141) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[143] == i_hcnt[10:5] && y_pos[143] == i_vcnt[10:5] && score <= 142) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[144] == i_hcnt[10:5] && y_pos[144] == i_vcnt[10:5] && score <= 143) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[145] == i_hcnt[10:5] && y_pos[145] == i_vcnt[10:5] && score <= 144) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[146] == i_hcnt[10:5] && y_pos[146] == i_vcnt[10:5] && score <= 145) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[147] == i_hcnt[10:5] && y_pos[147] == i_vcnt[10:5] && score <= 146) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[148] == i_hcnt[10:5] && y_pos[148] == i_vcnt[10:5] && score <= 147) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[149] == i_hcnt[10:5] && y_pos[149] == i_vcnt[10:5] && score <= 148) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[150] == i_hcnt[10:5] && y_pos[150] == i_vcnt[10:5] && score <= 149) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[151] == i_hcnt[10:5] && y_pos[151] == i_vcnt[10:5] && score <= 150) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[152] == i_hcnt[10:5] && y_pos[152] == i_vcnt[10:5] && score <= 151) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[153] == i_hcnt[10:5] && y_pos[153] == i_vcnt[10:5] && score <= 152) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[154] == i_hcnt[10:5] && y_pos[154] == i_vcnt[10:5] && score <= 153) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[155] == i_hcnt[10:5] && y_pos[155] == i_vcnt[10:5] && score <= 154) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[156] == i_hcnt[10:5] && y_pos[156] == i_vcnt[10:5] && score <= 155) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[157] == i_hcnt[10:5] && y_pos[157] == i_vcnt[10:5] && score <= 156) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[158] == i_hcnt[10:5] && y_pos[158] == i_vcnt[10:5] && score <= 157) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[159] == i_hcnt[10:5] && y_pos[159] == i_vcnt[10:5] && score <= 158) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[160] == i_hcnt[10:5] && y_pos[160] == i_vcnt[10:5] && score <= 159) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[161] == i_hcnt[10:5] && y_pos[161] == i_vcnt[10:5] && score <= 160) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[162] == i_hcnt[10:5] && y_pos[162] == i_vcnt[10:5] && score <= 161) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[163] == i_hcnt[10:5] && y_pos[163] == i_vcnt[10:5] && score <= 162) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[164] == i_hcnt[10:5] && y_pos[164] == i_vcnt[10:5] && score <= 163) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[165] == i_hcnt[10:5] && y_pos[165] == i_vcnt[10:5] && score <= 164) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[166] == i_hcnt[10:5] && y_pos[166] == i_vcnt[10:5] && score <= 165) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[167] == i_hcnt[10:5] && y_pos[167] == i_vcnt[10:5] && score <= 166) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[168] == i_hcnt[10:5] && y_pos[168] == i_vcnt[10:5] && score <= 167) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[169] == i_hcnt[10:5] && y_pos[169] == i_vcnt[10:5] && score <= 168) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[170] == i_hcnt[10:5] && y_pos[170] == i_vcnt[10:5] && score <= 169) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[171] == i_hcnt[10:5] && y_pos[171] == i_vcnt[10:5] && score <= 170) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[172] == i_hcnt[10:5] && y_pos[172] == i_vcnt[10:5] && score <= 171) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[173] == i_hcnt[10:5] && y_pos[173] == i_vcnt[10:5] && score <= 172) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[174] == i_hcnt[10:5] && y_pos[174] == i_vcnt[10:5] && score <= 173) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[175] == i_hcnt[10:5] && y_pos[175] == i_vcnt[10:5] && score <= 174) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[176] == i_hcnt[10:5] && y_pos[176] == i_vcnt[10:5] && score <= 175) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[177] == i_hcnt[10:5] && y_pos[177] == i_vcnt[10:5] && score <= 176) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[178] == i_hcnt[10:5] && y_pos[178] == i_vcnt[10:5] && score <= 177) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[179] == i_hcnt[10:5] && y_pos[179] == i_vcnt[10:5] && score <= 178) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[180] == i_hcnt[10:5] && y_pos[180] == i_vcnt[10:5] && score <= 179) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[181] == i_hcnt[10:5] && y_pos[181] == i_vcnt[10:5] && score <= 180) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[182] == i_hcnt[10:5] && y_pos[182] == i_vcnt[10:5] && score <= 181) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[183] == i_hcnt[10:5] && y_pos[183] == i_vcnt[10:5] && score <= 182) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[184] == i_hcnt[10:5] && y_pos[184] == i_vcnt[10:5] && score <= 183) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[185] == i_hcnt[10:5] && y_pos[185] == i_vcnt[10:5] && score <= 184) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[186] == i_hcnt[10:5] && y_pos[186] == i_vcnt[10:5] && score <= 185) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[187] == i_hcnt[10:5] && y_pos[187] == i_vcnt[10:5] && score <= 186) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[188] == i_hcnt[10:5] && y_pos[188] == i_vcnt[10:5] && score <= 187) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[189] == i_hcnt[10:5] && y_pos[189] == i_vcnt[10:5] && score <= 188) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[190] == i_hcnt[10:5] && y_pos[190] == i_vcnt[10:5] && score <= 189) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[191] == i_hcnt[10:5] && y_pos[191] == i_vcnt[10:5] && score <= 190) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[192] == i_hcnt[10:5] && y_pos[192] == i_vcnt[10:5] && score <= 191) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[193] == i_hcnt[10:5] && y_pos[193] == i_vcnt[10:5] && score <= 192) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[194] == i_hcnt[10:5] && y_pos[194] == i_vcnt[10:5] && score <= 193) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[195] == i_hcnt[10:5] && y_pos[195] == i_vcnt[10:5] && score <= 194) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[196] == i_hcnt[10:5] && y_pos[196] == i_vcnt[10:5] && score <= 195) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[197] == i_hcnt[10:5] && y_pos[197] == i_vcnt[10:5] && score <= 196) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[198] == i_hcnt[10:5] && y_pos[198] == i_vcnt[10:5] && score <= 197) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[199] == i_hcnt[10:5] && y_pos[199] == i_vcnt[10:5] && score <= 198) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[200] == i_hcnt[10:5] && y_pos[200] == i_vcnt[10:5] && score <= 199) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[201] == i_hcnt[10:5] && y_pos[201] == i_vcnt[10:5] && score <= 200) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[202] == i_hcnt[10:5] && y_pos[202] == i_vcnt[10:5] && score <= 201) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[203] == i_hcnt[10:5] && y_pos[203] == i_vcnt[10:5] && score <= 202) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[204] == i_hcnt[10:5] && y_pos[204] == i_vcnt[10:5] && score <= 203) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[205] == i_hcnt[10:5] && y_pos[205] == i_vcnt[10:5] && score <= 204) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[206] == i_hcnt[10:5] && y_pos[206] == i_vcnt[10:5] && score <= 205) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[207] == i_hcnt[10:5] && y_pos[207] == i_vcnt[10:5] && score <= 206) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[208] == i_hcnt[10:5] && y_pos[208] == i_vcnt[10:5] && score <= 207) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[209] == i_hcnt[10:5] && y_pos[209] == i_vcnt[10:5] && score <= 208) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[210] == i_hcnt[10:5] && y_pos[210] == i_vcnt[10:5] && score <= 209) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[211] == i_hcnt[10:5] && y_pos[211] == i_vcnt[10:5] && score <= 210) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[212] == i_hcnt[10:5] && y_pos[212] == i_vcnt[10:5] && score <= 211) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[213] == i_hcnt[10:5] && y_pos[213] == i_vcnt[10:5] && score <= 212) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[214] == i_hcnt[10:5] && y_pos[214] == i_vcnt[10:5] && score <= 213) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[215] == i_hcnt[10:5] && y_pos[215] == i_vcnt[10:5] && score <= 214) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[216] == i_hcnt[10:5] && y_pos[216] == i_vcnt[10:5] && score <= 215) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[217] == i_hcnt[10:5] && y_pos[217] == i_vcnt[10:5] && score <= 216) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[218] == i_hcnt[10:5] && y_pos[218] == i_vcnt[10:5] && score <= 217) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[219] == i_hcnt[10:5] && y_pos[219] == i_vcnt[10:5] && score <= 218) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[220] == i_hcnt[10:5] && y_pos[220] == i_vcnt[10:5] && score <= 219) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[221] == i_hcnt[10:5] && y_pos[221] == i_vcnt[10:5] && score <= 220) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[222] == i_hcnt[10:5] && y_pos[222] == i_vcnt[10:5] && score <= 221) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[223] == i_hcnt[10:5] && y_pos[223] == i_vcnt[10:5] && score <= 222) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[224] == i_hcnt[10:5] && y_pos[224] == i_vcnt[10:5] && score <= 223) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[225] == i_hcnt[10:5] && y_pos[225] == i_vcnt[10:5] && score <= 224) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[226] == i_hcnt[10:5] && y_pos[226] == i_vcnt[10:5] && score <= 225) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[227] == i_hcnt[10:5] && y_pos[227] == i_vcnt[10:5] && score <= 226) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[228] == i_hcnt[10:5] && y_pos[228] == i_vcnt[10:5] && score <= 227) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[229] == i_hcnt[10:5] && y_pos[229] == i_vcnt[10:5] && score <= 228) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[230] == i_hcnt[10:5] && y_pos[230] == i_vcnt[10:5] && score <= 229) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[231] == i_hcnt[10:5] && y_pos[231] == i_vcnt[10:5] && score <= 230) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[232] == i_hcnt[10:5] && y_pos[232] == i_vcnt[10:5] && score <= 231) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[233] == i_hcnt[10:5] && y_pos[233] == i_vcnt[10:5] && score <= 232) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[234] == i_hcnt[10:5] && y_pos[234] == i_vcnt[10:5] && score <= 233) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[235] == i_hcnt[10:5] && y_pos[235] == i_vcnt[10:5] && score <= 234) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[236] == i_hcnt[10:5] && y_pos[236] == i_vcnt[10:5] && score <= 235) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[237] == i_hcnt[10:5] && y_pos[237] == i_vcnt[10:5] && score <= 236) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[238] == i_hcnt[10:5] && y_pos[238] == i_vcnt[10:5] && score <= 237) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[239] == i_hcnt[10:5] && y_pos[239] == i_vcnt[10:5] && score <= 238) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[240] == i_hcnt[10:5] && y_pos[240] == i_vcnt[10:5] && score <= 239) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[241] == i_hcnt[10:5] && y_pos[241] == i_vcnt[10:5] && score <= 240) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[242] == i_hcnt[10:5] && y_pos[242] == i_vcnt[10:5] && score <= 241) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[243] == i_hcnt[10:5] && y_pos[243] == i_vcnt[10:5] && score <= 242) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[244] == i_hcnt[10:5] && y_pos[244] == i_vcnt[10:5] && score <= 243) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[245] == i_hcnt[10:5] && y_pos[245] == i_vcnt[10:5] && score <= 244) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[246] == i_hcnt[10:5] && y_pos[246] == i_vcnt[10:5] && score <= 245) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[247] == i_hcnt[10:5] && y_pos[247] == i_vcnt[10:5] && score <= 246) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[248] == i_hcnt[10:5] && y_pos[248] == i_vcnt[10:5] && score <= 247) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[249] == i_hcnt[10:5] && y_pos[249] == i_vcnt[10:5] && score <= 248) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[250] == i_hcnt[10:5] && y_pos[250] == i_vcnt[10:5] && score <= 249) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[251] == i_hcnt[10:5] && y_pos[251] == i_vcnt[10:5] && score <= 250) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[252] == i_hcnt[10:5] && y_pos[252] == i_vcnt[10:5] && score <= 251) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[253] == i_hcnt[10:5] && y_pos[253] == i_vcnt[10:5] && score <= 252) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[254] == i_hcnt[10:5] && y_pos[254] == i_vcnt[10:5] && score <= 253) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[255] == i_hcnt[10:5] && y_pos[255] == i_vcnt[10:5] && score <= 254) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[256] == i_hcnt[10:5] && y_pos[256] == i_vcnt[10:5] && score <= 255) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[257] == i_hcnt[10:5] && y_pos[257] == i_vcnt[10:5] && score <= 256) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[258] == i_hcnt[10:5] && y_pos[258] == i_vcnt[10:5] && score <= 257) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[259] == i_hcnt[10:5] && y_pos[259] == i_vcnt[10:5] && score <= 258) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[260] == i_hcnt[10:5] && y_pos[260] == i_vcnt[10:5] && score <= 259) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[261] == i_hcnt[10:5] && y_pos[261] == i_vcnt[10:5] && score <= 260) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[262] == i_hcnt[10:5] && y_pos[262] == i_vcnt[10:5] && score <= 261) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[263] == i_hcnt[10:5] && y_pos[263] == i_vcnt[10:5] && score <= 262) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[264] == i_hcnt[10:5] && y_pos[264] == i_vcnt[10:5] && score <= 263) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[265] == i_hcnt[10:5] && y_pos[265] == i_vcnt[10:5] && score <= 264) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[266] == i_hcnt[10:5] && y_pos[266] == i_vcnt[10:5] && score <= 265) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[267] == i_hcnt[10:5] && y_pos[267] == i_vcnt[10:5] && score <= 266) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[268] == i_hcnt[10:5] && y_pos[268] == i_vcnt[10:5] && score <= 267) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[269] == i_hcnt[10:5] && y_pos[269] == i_vcnt[10:5] && score <= 268) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[270] == i_hcnt[10:5] && y_pos[270] == i_vcnt[10:5] && score <= 269) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[271] == i_hcnt[10:5] && y_pos[271] == i_vcnt[10:5] && score <= 270) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[272] == i_hcnt[10:5] && y_pos[272] == i_vcnt[10:5] && score <= 271) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[273] == i_hcnt[10:5] && y_pos[273] == i_vcnt[10:5] && score <= 272) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[274] == i_hcnt[10:5] && y_pos[274] == i_vcnt[10:5] && score <= 273) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[275] == i_hcnt[10:5] && y_pos[275] == i_vcnt[10:5] && score <= 274) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[276] == i_hcnt[10:5] && y_pos[276] == i_vcnt[10:5] && score <= 275) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[277] == i_hcnt[10:5] && y_pos[277] == i_vcnt[10:5] && score <= 276) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[278] == i_hcnt[10:5] && y_pos[278] == i_vcnt[10:5] && score <= 277) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[279] == i_hcnt[10:5] && y_pos[279] == i_vcnt[10:5] && score <= 278) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[280] == i_hcnt[10:5] && y_pos[280] == i_vcnt[10:5] && score <= 279) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[281] == i_hcnt[10:5] && y_pos[281] == i_vcnt[10:5] && score <= 280) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[282] == i_hcnt[10:5] && y_pos[282] == i_vcnt[10:5] && score <= 281) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[283] == i_hcnt[10:5] && y_pos[283] == i_vcnt[10:5] && score <= 282) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[284] == i_hcnt[10:5] && y_pos[284] == i_vcnt[10:5] && score <= 283) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[285] == i_hcnt[10:5] && y_pos[285] == i_vcnt[10:5] && score <= 284) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[286] == i_hcnt[10:5] && y_pos[286] == i_vcnt[10:5] && score <= 285) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[287] == i_hcnt[10:5] && y_pos[287] == i_vcnt[10:5] && score <= 286) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[288] == i_hcnt[10:5] && y_pos[288] == i_vcnt[10:5] && score <= 287) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[289] == i_hcnt[10:5] && y_pos[289] == i_vcnt[10:5] && score <= 288) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[290] == i_hcnt[10:5] && y_pos[290] == i_vcnt[10:5] && score <= 289) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[291] == i_hcnt[10:5] && y_pos[291] == i_vcnt[10:5] && score <= 290) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[292] == i_hcnt[10:5] && y_pos[292] == i_vcnt[10:5] && score <= 291) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[293] == i_hcnt[10:5] && y_pos[293] == i_vcnt[10:5] && score <= 292) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[294] == i_hcnt[10:5] && y_pos[294] == i_vcnt[10:5] && score <= 293) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[295] == i_hcnt[10:5] && y_pos[295] == i_vcnt[10:5] && score <= 294) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[296] == i_hcnt[10:5] && y_pos[296] == i_vcnt[10:5] && score <= 295) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[297] == i_hcnt[10:5] && y_pos[297] == i_vcnt[10:5] && score <= 296) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[298] == i_hcnt[10:5] && y_pos[298] == i_vcnt[10:5] && score <= 297) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[299] == i_hcnt[10:5] && y_pos[299] == i_vcnt[10:5] && score <= 298) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[300] == i_hcnt[10:5] && y_pos[300] == i_vcnt[10:5] && score <= 299) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[301] == i_hcnt[10:5] && y_pos[301] == i_vcnt[10:5] && score <= 300) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[302] == i_hcnt[10:5] && y_pos[302] == i_vcnt[10:5] && score <= 301) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[303] == i_hcnt[10:5] && y_pos[303] == i_vcnt[10:5] && score <= 302) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[304] == i_hcnt[10:5] && y_pos[304] == i_vcnt[10:5] && score <= 303) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[305] == i_hcnt[10:5] && y_pos[305] == i_vcnt[10:5] && score <= 304) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[306] == i_hcnt[10:5] && y_pos[306] == i_vcnt[10:5] && score <= 305) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[307] == i_hcnt[10:5] && y_pos[307] == i_vcnt[10:5] && score <= 306) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[308] == i_hcnt[10:5] && y_pos[308] == i_vcnt[10:5] && score <= 307) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[309] == i_hcnt[10:5] && y_pos[309] == i_vcnt[10:5] && score <= 308) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[310] == i_hcnt[10:5] && y_pos[310] == i_vcnt[10:5] && score <= 309) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[311] == i_hcnt[10:5] && y_pos[311] == i_vcnt[10:5] && score <= 310) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[312] == i_hcnt[10:5] && y_pos[312] == i_vcnt[10:5] && score <= 311) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[313] == i_hcnt[10:5] && y_pos[313] == i_vcnt[10:5] && score <= 312) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[314] == i_hcnt[10:5] && y_pos[314] == i_vcnt[10:5] && score <= 313) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[315] == i_hcnt[10:5] && y_pos[315] == i_vcnt[10:5] && score <= 314) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[316] == i_hcnt[10:5] && y_pos[316] == i_vcnt[10:5] && score <= 315) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[317] == i_hcnt[10:5] && y_pos[317] == i_vcnt[10:5] && score <= 316) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[318] == i_hcnt[10:5] && y_pos[318] == i_vcnt[10:5] && score <= 317) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[319] == i_hcnt[10:5] && y_pos[319] == i_vcnt[10:5] && score <= 318) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[320] == i_hcnt[10:5] && y_pos[320] == i_vcnt[10:5] && score <= 319) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[321] == i_hcnt[10:5] && y_pos[321] == i_vcnt[10:5] && score <= 320) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[322] == i_hcnt[10:5] && y_pos[322] == i_vcnt[10:5] && score <= 321) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[323] == i_hcnt[10:5] && y_pos[323] == i_vcnt[10:5] && score <= 322) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[324] == i_hcnt[10:5] && y_pos[324] == i_vcnt[10:5] && score <= 323) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[325] == i_hcnt[10:5] && y_pos[325] == i_vcnt[10:5] && score <= 324) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[326] == i_hcnt[10:5] && y_pos[326] == i_vcnt[10:5] && score <= 325) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[327] == i_hcnt[10:5] && y_pos[327] == i_vcnt[10:5] && score <= 326) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[328] == i_hcnt[10:5] && y_pos[328] == i_vcnt[10:5] && score <= 327) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[329] == i_hcnt[10:5] && y_pos[329] == i_vcnt[10:5] && score <= 328) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[330] == i_hcnt[10:5] && y_pos[330] == i_vcnt[10:5] && score <= 329) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[331] == i_hcnt[10:5] && y_pos[331] == i_vcnt[10:5] && score <= 330) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[332] == i_hcnt[10:5] && y_pos[332] == i_vcnt[10:5] && score <= 331) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[333] == i_hcnt[10:5] && y_pos[333] == i_vcnt[10:5] && score <= 332) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[334] == i_hcnt[10:5] && y_pos[334] == i_vcnt[10:5] && score <= 333) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[335] == i_hcnt[10:5] && y_pos[335] == i_vcnt[10:5] && score <= 334) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[336] == i_hcnt[10:5] && y_pos[336] == i_vcnt[10:5] && score <= 335) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[337] == i_hcnt[10:5] && y_pos[337] == i_vcnt[10:5] && score <= 336) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[338] == i_hcnt[10:5] && y_pos[338] == i_vcnt[10:5] && score <= 337) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[339] == i_hcnt[10:5] && y_pos[339] == i_vcnt[10:5] && score <= 338) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[340] == i_hcnt[10:5] && y_pos[340] == i_vcnt[10:5] && score <= 339) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[341] == i_hcnt[10:5] && y_pos[341] == i_vcnt[10:5] && score <= 340) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[342] == i_hcnt[10:5] && y_pos[342] == i_vcnt[10:5] && score <= 341) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[343] == i_hcnt[10:5] && y_pos[343] == i_vcnt[10:5] && score <= 342) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[344] == i_hcnt[10:5] && y_pos[344] == i_vcnt[10:5] && score <= 343) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[345] == i_hcnt[10:5] && y_pos[345] == i_vcnt[10:5] && score <= 344) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[346] == i_hcnt[10:5] && y_pos[346] == i_vcnt[10:5] && score <= 345) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[347] == i_hcnt[10:5] && y_pos[347] == i_vcnt[10:5] && score <= 346) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[348] == i_hcnt[10:5] && y_pos[348] == i_vcnt[10:5] && score <= 347) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[349] == i_hcnt[10:5] && y_pos[349] == i_vcnt[10:5] && score <= 348) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[350] == i_hcnt[10:5] && y_pos[350] == i_vcnt[10:5] && score <= 349) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[351] == i_hcnt[10:5] && y_pos[351] == i_vcnt[10:5] && score <= 350) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[352] == i_hcnt[10:5] && y_pos[352] == i_vcnt[10:5] && score <= 351) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[353] == i_hcnt[10:5] && y_pos[353] == i_vcnt[10:5] && score <= 352) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[354] == i_hcnt[10:5] && y_pos[354] == i_vcnt[10:5] && score <= 353) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[355] == i_hcnt[10:5] && y_pos[355] == i_vcnt[10:5] && score <= 354) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[356] == i_hcnt[10:5] && y_pos[356] == i_vcnt[10:5] && score <= 355) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[357] == i_hcnt[10:5] && y_pos[357] == i_vcnt[10:5] && score <= 356) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[358] == i_hcnt[10:5] && y_pos[358] == i_vcnt[10:5] && score <= 357) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[359] == i_hcnt[10:5] && y_pos[359] == i_vcnt[10:5] && score <= 358) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[360] == i_hcnt[10:5] && y_pos[360] == i_vcnt[10:5] && score <= 359) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[361] == i_hcnt[10:5] && y_pos[361] == i_vcnt[10:5] && score <= 360) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[362] == i_hcnt[10:5] && y_pos[362] == i_vcnt[10:5] && score <= 361) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[363] == i_hcnt[10:5] && y_pos[363] == i_vcnt[10:5] && score <= 362) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[364] == i_hcnt[10:5] && y_pos[364] == i_vcnt[10:5] && score <= 363) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[365] == i_hcnt[10:5] && y_pos[365] == i_vcnt[10:5] && score <= 364) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[366] == i_hcnt[10:5] && y_pos[366] == i_vcnt[10:5] && score <= 365) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[367] == i_hcnt[10:5] && y_pos[367] == i_vcnt[10:5] && score <= 366) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[368] == i_hcnt[10:5] && y_pos[368] == i_vcnt[10:5] && score <= 367) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[369] == i_hcnt[10:5] && y_pos[369] == i_vcnt[10:5] && score <= 368) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[370] == i_hcnt[10:5] && y_pos[370] == i_vcnt[10:5] && score <= 369) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[371] == i_hcnt[10:5] && y_pos[371] == i_vcnt[10:5] && score <= 370) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[372] == i_hcnt[10:5] && y_pos[372] == i_vcnt[10:5] && score <= 371) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[373] == i_hcnt[10:5] && y_pos[373] == i_vcnt[10:5] && score <= 372) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[374] == i_hcnt[10:5] && y_pos[374] == i_vcnt[10:5] && score <= 373) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[375] == i_hcnt[10:5] && y_pos[375] == i_vcnt[10:5] && score <= 374) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[376] == i_hcnt[10:5] && y_pos[376] == i_vcnt[10:5] && score <= 375) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[377] == i_hcnt[10:5] && y_pos[377] == i_vcnt[10:5] && score <= 376) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[378] == i_hcnt[10:5] && y_pos[378] == i_vcnt[10:5] && score <= 377) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[379] == i_hcnt[10:5] && y_pos[379] == i_vcnt[10:5] && score <= 378) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[380] == i_hcnt[10:5] && y_pos[380] == i_vcnt[10:5] && score <= 379) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[381] == i_hcnt[10:5] && y_pos[381] == i_vcnt[10:5] && score <= 380) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[382] == i_hcnt[10:5] && y_pos[382] == i_vcnt[10:5] && score <= 381) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[383] == i_hcnt[10:5] && y_pos[383] == i_vcnt[10:5] && score <= 382) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[384] == i_hcnt[10:5] && y_pos[384] == i_vcnt[10:5] && score <= 383) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[385] == i_hcnt[10:5] && y_pos[385] == i_vcnt[10:5] && score <= 384) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[386] == i_hcnt[10:5] && y_pos[386] == i_vcnt[10:5] && score <= 385) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[387] == i_hcnt[10:5] && y_pos[387] == i_vcnt[10:5] && score <= 386) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[388] == i_hcnt[10:5] && y_pos[388] == i_vcnt[10:5] && score <= 387) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[389] == i_hcnt[10:5] && y_pos[389] == i_vcnt[10:5] && score <= 388) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[390] == i_hcnt[10:5] && y_pos[390] == i_vcnt[10:5] && score <= 389) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[391] == i_hcnt[10:5] && y_pos[391] == i_vcnt[10:5] && score <= 390) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[392] == i_hcnt[10:5] && y_pos[392] == i_vcnt[10:5] && score <= 391) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[393] == i_hcnt[10:5] && y_pos[393] == i_vcnt[10:5] && score <= 392) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[394] == i_hcnt[10:5] && y_pos[394] == i_vcnt[10:5] && score <= 393) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[395] == i_hcnt[10:5] && y_pos[395] == i_vcnt[10:5] && score <= 394) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[396] == i_hcnt[10:5] && y_pos[396] == i_vcnt[10:5] && score <= 395) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[397] == i_hcnt[10:5] && y_pos[397] == i_vcnt[10:5] && score <= 396) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[398] == i_hcnt[10:5] && y_pos[398] == i_vcnt[10:5] && score <= 397) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[399] == i_hcnt[10:5] && y_pos[399] == i_vcnt[10:5] && score <= 398) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[400] == i_hcnt[10:5] && y_pos[400] == i_vcnt[10:5] && score <= 399) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[401] == i_hcnt[10:5] && y_pos[401] == i_vcnt[10:5] && score <= 400) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[402] == i_hcnt[10:5] && y_pos[402] == i_vcnt[10:5] && score <= 401) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[403] == i_hcnt[10:5] && y_pos[403] == i_vcnt[10:5] && score <= 402) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[404] == i_hcnt[10:5] && y_pos[404] == i_vcnt[10:5] && score <= 403) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[405] == i_hcnt[10:5] && y_pos[405] == i_vcnt[10:5] && score <= 404) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[406] == i_hcnt[10:5] && y_pos[406] == i_vcnt[10:5] && score <= 405) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[407] == i_hcnt[10:5] && y_pos[407] == i_vcnt[10:5] && score <= 406) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[408] == i_hcnt[10:5] && y_pos[408] == i_vcnt[10:5] && score <= 407) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[409] == i_hcnt[10:5] && y_pos[409] == i_vcnt[10:5] && score <= 408) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[410] == i_hcnt[10:5] && y_pos[410] == i_vcnt[10:5] && score <= 409) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[411] == i_hcnt[10:5] && y_pos[411] == i_vcnt[10:5] && score <= 410) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[412] == i_hcnt[10:5] && y_pos[412] == i_vcnt[10:5] && score <= 411) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[413] == i_hcnt[10:5] && y_pos[413] == i_vcnt[10:5] && score <= 412) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[414] == i_hcnt[10:5] && y_pos[414] == i_vcnt[10:5] && score <= 413) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[415] == i_hcnt[10:5] && y_pos[415] == i_vcnt[10:5] && score <= 414) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[416] == i_hcnt[10:5] && y_pos[416] == i_vcnt[10:5] && score <= 415) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[417] == i_hcnt[10:5] && y_pos[417] == i_vcnt[10:5] && score <= 416) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[418] == i_hcnt[10:5] && y_pos[418] == i_vcnt[10:5] && score <= 417) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[419] == i_hcnt[10:5] && y_pos[419] == i_vcnt[10:5] && score <= 418) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[420] == i_hcnt[10:5] && y_pos[420] == i_vcnt[10:5] && score <= 419) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[421] == i_hcnt[10:5] && y_pos[421] == i_vcnt[10:5] && score <= 420) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[422] == i_hcnt[10:5] && y_pos[422] == i_vcnt[10:5] && score <= 421) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[423] == i_hcnt[10:5] && y_pos[423] == i_vcnt[10:5] && score <= 422) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[424] == i_hcnt[10:5] && y_pos[424] == i_vcnt[10:5] && score <= 423) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[425] == i_hcnt[10:5] && y_pos[425] == i_vcnt[10:5] && score <= 424) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[426] == i_hcnt[10:5] && y_pos[426] == i_vcnt[10:5] && score <= 425) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[427] == i_hcnt[10:5] && y_pos[427] == i_vcnt[10:5] && score <= 426) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[428] == i_hcnt[10:5] && y_pos[428] == i_vcnt[10:5] && score <= 427) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[429] == i_hcnt[10:5] && y_pos[429] == i_vcnt[10:5] && score <= 428) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[430] == i_hcnt[10:5] && y_pos[430] == i_vcnt[10:5] && score <= 429) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[431] == i_hcnt[10:5] && y_pos[431] == i_vcnt[10:5] && score <= 430) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[432] == i_hcnt[10:5] && y_pos[432] == i_vcnt[10:5] && score <= 431) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[433] == i_hcnt[10:5] && y_pos[433] == i_vcnt[10:5] && score <= 432) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[434] == i_hcnt[10:5] && y_pos[434] == i_vcnt[10:5] && score <= 433) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[435] == i_hcnt[10:5] && y_pos[435] == i_vcnt[10:5] && score <= 434) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[436] == i_hcnt[10:5] && y_pos[436] == i_vcnt[10:5] && score <= 435) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[437] == i_hcnt[10:5] && y_pos[437] == i_vcnt[10:5] && score <= 436) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[438] == i_hcnt[10:5] && y_pos[438] == i_vcnt[10:5] && score <= 437) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[439] == i_hcnt[10:5] && y_pos[439] == i_vcnt[10:5] && score <= 438) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[440] == i_hcnt[10:5] && y_pos[440] == i_vcnt[10:5] && score <= 439) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[441] == i_hcnt[10:5] && y_pos[441] == i_vcnt[10:5] && score <= 440) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[442] == i_hcnt[10:5] && y_pos[442] == i_vcnt[10:5] && score <= 441) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[443] == i_hcnt[10:5] && y_pos[443] == i_vcnt[10:5] && score <= 442) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[444] == i_hcnt[10:5] && y_pos[444] == i_vcnt[10:5] && score <= 443) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[445] == i_hcnt[10:5] && y_pos[445] == i_vcnt[10:5] && score <= 444) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[446] == i_hcnt[10:5] && y_pos[446] == i_vcnt[10:5] && score <= 445) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[447] == i_hcnt[10:5] && y_pos[447] == i_vcnt[10:5] && score <= 446) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[448] == i_hcnt[10:5] && y_pos[448] == i_vcnt[10:5] && score <= 447) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[449] == i_hcnt[10:5] && y_pos[449] == i_vcnt[10:5] && score <= 448) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[450] == i_hcnt[10:5] && y_pos[450] == i_vcnt[10:5] && score <= 449) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[451] == i_hcnt[10:5] && y_pos[451] == i_vcnt[10:5] && score <= 450) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[452] == i_hcnt[10:5] && y_pos[452] == i_vcnt[10:5] && score <= 451) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[453] == i_hcnt[10:5] && y_pos[453] == i_vcnt[10:5] && score <= 452) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[454] == i_hcnt[10:5] && y_pos[454] == i_vcnt[10:5] && score <= 453) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[455] == i_hcnt[10:5] && y_pos[455] == i_vcnt[10:5] && score <= 454) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[456] == i_hcnt[10:5] && y_pos[456] == i_vcnt[10:5] && score <= 455) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[457] == i_hcnt[10:5] && y_pos[457] == i_vcnt[10:5] && score <= 456) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[458] == i_hcnt[10:5] && y_pos[458] == i_vcnt[10:5] && score <= 457) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[459] == i_hcnt[10:5] && y_pos[459] == i_vcnt[10:5] && score <= 458) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[460] == i_hcnt[10:5] && y_pos[460] == i_vcnt[10:5] && score <= 459) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[461] == i_hcnt[10:5] && y_pos[461] == i_vcnt[10:5] && score <= 460) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[462] == i_hcnt[10:5] && y_pos[462] == i_vcnt[10:5] && score <= 461) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[463] == i_hcnt[10:5] && y_pos[463] == i_vcnt[10:5] && score <= 462) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[464] == i_hcnt[10:5] && y_pos[464] == i_vcnt[10:5] && score <= 463) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[465] == i_hcnt[10:5] && y_pos[465] == i_vcnt[10:5] && score <= 464) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[466] == i_hcnt[10:5] && y_pos[466] == i_vcnt[10:5] && score <= 465) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[467] == i_hcnt[10:5] && y_pos[467] == i_vcnt[10:5] && score <= 466) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[468] == i_hcnt[10:5] && y_pos[468] == i_vcnt[10:5] && score <= 467) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[469] == i_hcnt[10:5] && y_pos[469] == i_vcnt[10:5] && score <= 468) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[470] == i_hcnt[10:5] && y_pos[470] == i_vcnt[10:5] && score <= 469) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[471] == i_hcnt[10:5] && y_pos[471] == i_vcnt[10:5] && score <= 470) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[472] == i_hcnt[10:5] && y_pos[472] == i_vcnt[10:5] && score <= 471) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[473] == i_hcnt[10:5] && y_pos[473] == i_vcnt[10:5] && score <= 472) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[474] == i_hcnt[10:5] && y_pos[474] == i_vcnt[10:5] && score <= 473) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[475] == i_hcnt[10:5] && y_pos[475] == i_vcnt[10:5] && score <= 474) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[476] == i_hcnt[10:5] && y_pos[476] == i_vcnt[10:5] && score <= 475) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[477] == i_hcnt[10:5] && y_pos[477] == i_vcnt[10:5] && score <= 476) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[478] == i_hcnt[10:5] && y_pos[478] == i_vcnt[10:5] && score <= 477) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[479] == i_hcnt[10:5] && y_pos[479] == i_vcnt[10:5] && score <= 478) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[480] == i_hcnt[10:5] && y_pos[480] == i_vcnt[10:5] && score <= 479) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[481] == i_hcnt[10:5] && y_pos[481] == i_vcnt[10:5] && score <= 480) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[482] == i_hcnt[10:5] && y_pos[482] == i_vcnt[10:5] && score <= 481) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[483] == i_hcnt[10:5] && y_pos[483] == i_vcnt[10:5] && score <= 482) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[484] == i_hcnt[10:5] && y_pos[484] == i_vcnt[10:5] && score <= 483) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos_a == i_hcnt[10:5] && y_pos_a == i_vcnt[10:5]) begin
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
