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
	
	reg [2903:0] x_pos = {6'd16, 2898'd0};
	reg [2903:0] y_pos = {6'd22, 2898'd0};
	
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
				if(x_pos[5:0] < 22) begin
					x_pos[5:0] <= x_pos[5:0] + 1;
					direction <= 2'b00;
				end else begin
					x_pos[5:0] <= x_pos[5:0] - 1;
					direction <= 2'b01;
				end
				if(x_pos[5:0] + 1 == x_pos_a && y_pos[5:0] == y_pos_a) begin
					score <= score + 1;
				end
			end else if(direction == 2'b01) begin
				if(x_pos[5:0] > 0+1) begin
					x_pos[5:0] <= x_pos[5:0] - 1;
					direction <= 2'b01;
				end else begin
					x_pos[5:0] <= x_pos[5:0] + 1;
					direction <= 2'b00;
				end
				if(x_pos[5:0] - 1 == x_pos_a && y_pos[5:0] == y_pos_a) begin
					score <= score + 1;
				end
			end else if(direction == 2'b11) begin
				if(x_pos[5:0] < 22) begin
					x_pos[5:0] <= x_pos[5:0] + 1;
					direction <= 2'b11;
				end else begin
					x_pos[5:0] <= x_pos[5:0] - 1;
					direction <= 2'b10;
				end
				if(x_pos[5:0] == x_pos_a && y_pos[5:0] + 1 == y_pos_a) begin
					score <= score + 1;
				end
			end else if(direction == 2'b10) begin
				if(y_pos[5:0] > 0+1) begin
					y_pos[5:0] <= y_pos[5:0] - 1;
					direction <= 2'b10;
				end else begin
					y_pos[5:0] <= y_pos[5:0] + 1;
					direction <= 2'b11;
				end
				if(x_pos[5:0] == x_pos_a && y_pos[5:0] - 1 == y_pos_a) begin
					score <= score + 1;
				end
			end
		end else begin
			cnt <= cnt + 1;
			x_pos[5:0]  <= x_pos[5:0];
		   y_pos[5:0]  <= y_pos[5:0];
		end
		x_pos[2903:6] <= x_pos[2897:0];
		y_pos[2903:6] <= y_pos[2897:0];
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
		end else if(x_pos[5:0] == i_hcnt[10:5] && y_pos[5:0] == i_vcnt[10:5] && score <= 0) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[11:6] == i_hcnt[10:5] && y_pos[11:6] == i_vcnt[10:5] && score <= 1) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[17:12] == i_hcnt[10:5] && y_pos[17:12] == i_vcnt[10:5] && score <= 2) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[23:18] == i_hcnt[10:5] && y_pos[23:18] == i_vcnt[10:5] && score <= 3) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[29:24] == i_hcnt[10:5] && y_pos[29:24] == i_vcnt[10:5] && score <= 4) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[35:30] == i_hcnt[10:5] && y_pos[35:30] == i_vcnt[10:5] && score <= 5) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[41:36] == i_hcnt[10:5] && y_pos[41:36] == i_vcnt[10:5] && score <= 6) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[47:42] == i_hcnt[10:5] && y_pos[47:42] == i_vcnt[10:5] && score <= 7) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[53:48] == i_hcnt[10:5] && y_pos[53:48] == i_vcnt[10:5] && score <= 8) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[59:54] == i_hcnt[10:5] && y_pos[59:54] == i_vcnt[10:5] && score <= 9) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[65:60] == i_hcnt[10:5] && y_pos[65:60] == i_vcnt[10:5] && score <= 10) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[71:66] == i_hcnt[10:5] && y_pos[71:66] == i_vcnt[10:5] && score <= 11) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[77:72] == i_hcnt[10:5] && y_pos[77:72] == i_vcnt[10:5] && score <= 12) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[83:78] == i_hcnt[10:5] && y_pos[83:78] == i_vcnt[10:5] && score <= 13) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[89:84] == i_hcnt[10:5] && y_pos[89:84] == i_vcnt[10:5] && score <= 14) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[95:90] == i_hcnt[10:5] && y_pos[95:90] == i_vcnt[10:5] && score <= 15) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[101:96] == i_hcnt[10:5] && y_pos[101:96] == i_vcnt[10:5] && score <= 16) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[107:102] == i_hcnt[10:5] && y_pos[107:102] == i_vcnt[10:5] && score <= 17) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[113:108] == i_hcnt[10:5] && y_pos[113:108] == i_vcnt[10:5] && score <= 18) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[119:114] == i_hcnt[10:5] && y_pos[119:114] == i_vcnt[10:5] && score <= 19) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[125:120] == i_hcnt[10:5] && y_pos[125:120] == i_vcnt[10:5] && score <= 20) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[131:126] == i_hcnt[10:5] && y_pos[131:126] == i_vcnt[10:5] && score <= 21) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[137:132] == i_hcnt[10:5] && y_pos[137:132] == i_vcnt[10:5] && score <= 22) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[143:138] == i_hcnt[10:5] && y_pos[143:138] == i_vcnt[10:5] && score <= 23) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[149:144] == i_hcnt[10:5] && y_pos[149:144] == i_vcnt[10:5] && score <= 24) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[155:150] == i_hcnt[10:5] && y_pos[155:150] == i_vcnt[10:5] && score <= 25) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[161:156] == i_hcnt[10:5] && y_pos[161:156] == i_vcnt[10:5] && score <= 26) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[167:162] == i_hcnt[10:5] && y_pos[167:162] == i_vcnt[10:5] && score <= 27) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[173:168] == i_hcnt[10:5] && y_pos[173:168] == i_vcnt[10:5] && score <= 28) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[179:174] == i_hcnt[10:5] && y_pos[179:174] == i_vcnt[10:5] && score <= 29) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[185:180] == i_hcnt[10:5] && y_pos[185:180] == i_vcnt[10:5] && score <= 30) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[191:186] == i_hcnt[10:5] && y_pos[191:186] == i_vcnt[10:5] && score <= 31) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[197:192] == i_hcnt[10:5] && y_pos[197:192] == i_vcnt[10:5] && score <= 32) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[203:198] == i_hcnt[10:5] && y_pos[203:198] == i_vcnt[10:5] && score <= 33) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[209:204] == i_hcnt[10:5] && y_pos[209:204] == i_vcnt[10:5] && score <= 34) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[215:210] == i_hcnt[10:5] && y_pos[215:210] == i_vcnt[10:5] && score <= 35) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[221:216] == i_hcnt[10:5] && y_pos[221:216] == i_vcnt[10:5] && score <= 36) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[227:222] == i_hcnt[10:5] && y_pos[227:222] == i_vcnt[10:5] && score <= 37) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[233:228] == i_hcnt[10:5] && y_pos[233:228] == i_vcnt[10:5] && score <= 38) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[239:234] == i_hcnt[10:5] && y_pos[239:234] == i_vcnt[10:5] && score <= 39) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[245:240] == i_hcnt[10:5] && y_pos[245:240] == i_vcnt[10:5] && score <= 40) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[251:246] == i_hcnt[10:5] && y_pos[251:246] == i_vcnt[10:5] && score <= 41) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[257:252] == i_hcnt[10:5] && y_pos[257:252] == i_vcnt[10:5] && score <= 42) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[263:258] == i_hcnt[10:5] && y_pos[263:258] == i_vcnt[10:5] && score <= 43) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[269:264] == i_hcnt[10:5] && y_pos[269:264] == i_vcnt[10:5] && score <= 44) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[275:270] == i_hcnt[10:5] && y_pos[275:270] == i_vcnt[10:5] && score <= 45) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[281:276] == i_hcnt[10:5] && y_pos[281:276] == i_vcnt[10:5] && score <= 46) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[287:282] == i_hcnt[10:5] && y_pos[287:282] == i_vcnt[10:5] && score <= 47) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[293:288] == i_hcnt[10:5] && y_pos[293:288] == i_vcnt[10:5] && score <= 48) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[299:294] == i_hcnt[10:5] && y_pos[299:294] == i_vcnt[10:5] && score <= 49) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[305:300] == i_hcnt[10:5] && y_pos[305:300] == i_vcnt[10:5] && score <= 50) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[311:306] == i_hcnt[10:5] && y_pos[311:306] == i_vcnt[10:5] && score <= 51) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[317:312] == i_hcnt[10:5] && y_pos[317:312] == i_vcnt[10:5] && score <= 52) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[323:318] == i_hcnt[10:5] && y_pos[323:318] == i_vcnt[10:5] && score <= 53) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[329:324] == i_hcnt[10:5] && y_pos[329:324] == i_vcnt[10:5] && score <= 54) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[335:330] == i_hcnt[10:5] && y_pos[335:330] == i_vcnt[10:5] && score <= 55) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[341:336] == i_hcnt[10:5] && y_pos[341:336] == i_vcnt[10:5] && score <= 56) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[347:342] == i_hcnt[10:5] && y_pos[347:342] == i_vcnt[10:5] && score <= 57) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[353:348] == i_hcnt[10:5] && y_pos[353:348] == i_vcnt[10:5] && score <= 58) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[359:354] == i_hcnt[10:5] && y_pos[359:354] == i_vcnt[10:5] && score <= 59) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[365:360] == i_hcnt[10:5] && y_pos[365:360] == i_vcnt[10:5] && score <= 60) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[371:366] == i_hcnt[10:5] && y_pos[371:366] == i_vcnt[10:5] && score <= 61) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[377:372] == i_hcnt[10:5] && y_pos[377:372] == i_vcnt[10:5] && score <= 62) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[383:378] == i_hcnt[10:5] && y_pos[383:378] == i_vcnt[10:5] && score <= 63) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[389:384] == i_hcnt[10:5] && y_pos[389:384] == i_vcnt[10:5] && score <= 64) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[395:390] == i_hcnt[10:5] && y_pos[395:390] == i_vcnt[10:5] && score <= 65) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[401:396] == i_hcnt[10:5] && y_pos[401:396] == i_vcnt[10:5] && score <= 66) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[407:402] == i_hcnt[10:5] && y_pos[407:402] == i_vcnt[10:5] && score <= 67) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[413:408] == i_hcnt[10:5] && y_pos[413:408] == i_vcnt[10:5] && score <= 68) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[419:414] == i_hcnt[10:5] && y_pos[419:414] == i_vcnt[10:5] && score <= 69) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[425:420] == i_hcnt[10:5] && y_pos[425:420] == i_vcnt[10:5] && score <= 70) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[431:426] == i_hcnt[10:5] && y_pos[431:426] == i_vcnt[10:5] && score <= 71) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[437:432] == i_hcnt[10:5] && y_pos[437:432] == i_vcnt[10:5] && score <= 72) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[443:438] == i_hcnt[10:5] && y_pos[443:438] == i_vcnt[10:5] && score <= 73) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[449:444] == i_hcnt[10:5] && y_pos[449:444] == i_vcnt[10:5] && score <= 74) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[455:450] == i_hcnt[10:5] && y_pos[455:450] == i_vcnt[10:5] && score <= 75) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[461:456] == i_hcnt[10:5] && y_pos[461:456] == i_vcnt[10:5] && score <= 76) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[467:462] == i_hcnt[10:5] && y_pos[467:462] == i_vcnt[10:5] && score <= 77) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[473:468] == i_hcnt[10:5] && y_pos[473:468] == i_vcnt[10:5] && score <= 78) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[479:474] == i_hcnt[10:5] && y_pos[479:474] == i_vcnt[10:5] && score <= 79) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[485:480] == i_hcnt[10:5] && y_pos[485:480] == i_vcnt[10:5] && score <= 80) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[491:486] == i_hcnt[10:5] && y_pos[491:486] == i_vcnt[10:5] && score <= 81) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[497:492] == i_hcnt[10:5] && y_pos[497:492] == i_vcnt[10:5] && score <= 82) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[503:498] == i_hcnt[10:5] && y_pos[503:498] == i_vcnt[10:5] && score <= 83) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[509:504] == i_hcnt[10:5] && y_pos[509:504] == i_vcnt[10:5] && score <= 84) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[515:510] == i_hcnt[10:5] && y_pos[515:510] == i_vcnt[10:5] && score <= 85) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[521:516] == i_hcnt[10:5] && y_pos[521:516] == i_vcnt[10:5] && score <= 86) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[527:522] == i_hcnt[10:5] && y_pos[527:522] == i_vcnt[10:5] && score <= 87) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[533:528] == i_hcnt[10:5] && y_pos[533:528] == i_vcnt[10:5] && score <= 88) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[539:534] == i_hcnt[10:5] && y_pos[539:534] == i_vcnt[10:5] && score <= 89) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[545:540] == i_hcnt[10:5] && y_pos[545:540] == i_vcnt[10:5] && score <= 90) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[551:546] == i_hcnt[10:5] && y_pos[551:546] == i_vcnt[10:5] && score <= 91) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[557:552] == i_hcnt[10:5] && y_pos[557:552] == i_vcnt[10:5] && score <= 92) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[563:558] == i_hcnt[10:5] && y_pos[563:558] == i_vcnt[10:5] && score <= 93) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[569:564] == i_hcnt[10:5] && y_pos[569:564] == i_vcnt[10:5] && score <= 94) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[575:570] == i_hcnt[10:5] && y_pos[575:570] == i_vcnt[10:5] && score <= 95) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[581:576] == i_hcnt[10:5] && y_pos[581:576] == i_vcnt[10:5] && score <= 96) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[587:582] == i_hcnt[10:5] && y_pos[587:582] == i_vcnt[10:5] && score <= 97) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[593:588] == i_hcnt[10:5] && y_pos[593:588] == i_vcnt[10:5] && score <= 98) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[599:594] == i_hcnt[10:5] && y_pos[599:594] == i_vcnt[10:5] && score <= 99) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[605:600] == i_hcnt[10:5] && y_pos[605:600] == i_vcnt[10:5] && score <= 100) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[611:606] == i_hcnt[10:5] && y_pos[611:606] == i_vcnt[10:5] && score <= 101) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[617:612] == i_hcnt[10:5] && y_pos[617:612] == i_vcnt[10:5] && score <= 102) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[623:618] == i_hcnt[10:5] && y_pos[623:618] == i_vcnt[10:5] && score <= 103) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[629:624] == i_hcnt[10:5] && y_pos[629:624] == i_vcnt[10:5] && score <= 104) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[635:630] == i_hcnt[10:5] && y_pos[635:630] == i_vcnt[10:5] && score <= 105) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[641:636] == i_hcnt[10:5] && y_pos[641:636] == i_vcnt[10:5] && score <= 106) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[647:642] == i_hcnt[10:5] && y_pos[647:642] == i_vcnt[10:5] && score <= 107) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[653:648] == i_hcnt[10:5] && y_pos[653:648] == i_vcnt[10:5] && score <= 108) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[659:654] == i_hcnt[10:5] && y_pos[659:654] == i_vcnt[10:5] && score <= 109) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[665:660] == i_hcnt[10:5] && y_pos[665:660] == i_vcnt[10:5] && score <= 110) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[671:666] == i_hcnt[10:5] && y_pos[671:666] == i_vcnt[10:5] && score <= 111) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[677:672] == i_hcnt[10:5] && y_pos[677:672] == i_vcnt[10:5] && score <= 112) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[683:678] == i_hcnt[10:5] && y_pos[683:678] == i_vcnt[10:5] && score <= 113) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[689:684] == i_hcnt[10:5] && y_pos[689:684] == i_vcnt[10:5] && score <= 114) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[695:690] == i_hcnt[10:5] && y_pos[695:690] == i_vcnt[10:5] && score <= 115) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[701:696] == i_hcnt[10:5] && y_pos[701:696] == i_vcnt[10:5] && score <= 116) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[707:702] == i_hcnt[10:5] && y_pos[707:702] == i_vcnt[10:5] && score <= 117) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[713:708] == i_hcnt[10:5] && y_pos[713:708] == i_vcnt[10:5] && score <= 118) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[719:714] == i_hcnt[10:5] && y_pos[719:714] == i_vcnt[10:5] && score <= 119) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[725:720] == i_hcnt[10:5] && y_pos[725:720] == i_vcnt[10:5] && score <= 120) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[731:726] == i_hcnt[10:5] && y_pos[731:726] == i_vcnt[10:5] && score <= 121) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[737:732] == i_hcnt[10:5] && y_pos[737:732] == i_vcnt[10:5] && score <= 122) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[743:738] == i_hcnt[10:5] && y_pos[743:738] == i_vcnt[10:5] && score <= 123) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[749:744] == i_hcnt[10:5] && y_pos[749:744] == i_vcnt[10:5] && score <= 124) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[755:750] == i_hcnt[10:5] && y_pos[755:750] == i_vcnt[10:5] && score <= 125) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[761:756] == i_hcnt[10:5] && y_pos[761:756] == i_vcnt[10:5] && score <= 126) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[767:762] == i_hcnt[10:5] && y_pos[767:762] == i_vcnt[10:5] && score <= 127) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[773:768] == i_hcnt[10:5] && y_pos[773:768] == i_vcnt[10:5] && score <= 128) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[779:774] == i_hcnt[10:5] && y_pos[779:774] == i_vcnt[10:5] && score <= 129) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[785:780] == i_hcnt[10:5] && y_pos[785:780] == i_vcnt[10:5] && score <= 130) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[791:786] == i_hcnt[10:5] && y_pos[791:786] == i_vcnt[10:5] && score <= 131) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[797:792] == i_hcnt[10:5] && y_pos[797:792] == i_vcnt[10:5] && score <= 132) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[803:798] == i_hcnt[10:5] && y_pos[803:798] == i_vcnt[10:5] && score <= 133) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[809:804] == i_hcnt[10:5] && y_pos[809:804] == i_vcnt[10:5] && score <= 134) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[815:810] == i_hcnt[10:5] && y_pos[815:810] == i_vcnt[10:5] && score <= 135) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[821:816] == i_hcnt[10:5] && y_pos[821:816] == i_vcnt[10:5] && score <= 136) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[827:822] == i_hcnt[10:5] && y_pos[827:822] == i_vcnt[10:5] && score <= 137) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[833:828] == i_hcnt[10:5] && y_pos[833:828] == i_vcnt[10:5] && score <= 138) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[839:834] == i_hcnt[10:5] && y_pos[839:834] == i_vcnt[10:5] && score <= 139) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[845:840] == i_hcnt[10:5] && y_pos[845:840] == i_vcnt[10:5] && score <= 140) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[851:846] == i_hcnt[10:5] && y_pos[851:846] == i_vcnt[10:5] && score <= 141) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[857:852] == i_hcnt[10:5] && y_pos[857:852] == i_vcnt[10:5] && score <= 142) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[863:858] == i_hcnt[10:5] && y_pos[863:858] == i_vcnt[10:5] && score <= 143) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[869:864] == i_hcnt[10:5] && y_pos[869:864] == i_vcnt[10:5] && score <= 144) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[875:870] == i_hcnt[10:5] && y_pos[875:870] == i_vcnt[10:5] && score <= 145) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[881:876] == i_hcnt[10:5] && y_pos[881:876] == i_vcnt[10:5] && score <= 146) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[887:882] == i_hcnt[10:5] && y_pos[887:882] == i_vcnt[10:5] && score <= 147) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[893:888] == i_hcnt[10:5] && y_pos[893:888] == i_vcnt[10:5] && score <= 148) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[899:894] == i_hcnt[10:5] && y_pos[899:894] == i_vcnt[10:5] && score <= 149) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[905:900] == i_hcnt[10:5] && y_pos[905:900] == i_vcnt[10:5] && score <= 150) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[911:906] == i_hcnt[10:5] && y_pos[911:906] == i_vcnt[10:5] && score <= 151) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[917:912] == i_hcnt[10:5] && y_pos[917:912] == i_vcnt[10:5] && score <= 152) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[923:918] == i_hcnt[10:5] && y_pos[923:918] == i_vcnt[10:5] && score <= 153) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[929:924] == i_hcnt[10:5] && y_pos[929:924] == i_vcnt[10:5] && score <= 154) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[935:930] == i_hcnt[10:5] && y_pos[935:930] == i_vcnt[10:5] && score <= 155) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[941:936] == i_hcnt[10:5] && y_pos[941:936] == i_vcnt[10:5] && score <= 156) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[947:942] == i_hcnt[10:5] && y_pos[947:942] == i_vcnt[10:5] && score <= 157) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[953:948] == i_hcnt[10:5] && y_pos[953:948] == i_vcnt[10:5] && score <= 158) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[959:954] == i_hcnt[10:5] && y_pos[959:954] == i_vcnt[10:5] && score <= 159) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[965:960] == i_hcnt[10:5] && y_pos[965:960] == i_vcnt[10:5] && score <= 160) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[971:966] == i_hcnt[10:5] && y_pos[971:966] == i_vcnt[10:5] && score <= 161) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[977:972] == i_hcnt[10:5] && y_pos[977:972] == i_vcnt[10:5] && score <= 162) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[983:978] == i_hcnt[10:5] && y_pos[983:978] == i_vcnt[10:5] && score <= 163) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[989:984] == i_hcnt[10:5] && y_pos[989:984] == i_vcnt[10:5] && score <= 164) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[995:990] == i_hcnt[10:5] && y_pos[995:990] == i_vcnt[10:5] && score <= 165) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1001:996] == i_hcnt[10:5] && y_pos[1001:996] == i_vcnt[10:5] && score <= 166) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1007:1002] == i_hcnt[10:5] && y_pos[1007:1002] == i_vcnt[10:5] && score <= 167) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1013:1008] == i_hcnt[10:5] && y_pos[1013:1008] == i_vcnt[10:5] && score <= 168) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1019:1014] == i_hcnt[10:5] && y_pos[1019:1014] == i_vcnt[10:5] && score <= 169) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1025:1020] == i_hcnt[10:5] && y_pos[1025:1020] == i_vcnt[10:5] && score <= 170) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1031:1026] == i_hcnt[10:5] && y_pos[1031:1026] == i_vcnt[10:5] && score <= 171) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1037:1032] == i_hcnt[10:5] && y_pos[1037:1032] == i_vcnt[10:5] && score <= 172) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1043:1038] == i_hcnt[10:5] && y_pos[1043:1038] == i_vcnt[10:5] && score <= 173) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1049:1044] == i_hcnt[10:5] && y_pos[1049:1044] == i_vcnt[10:5] && score <= 174) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1055:1050] == i_hcnt[10:5] && y_pos[1055:1050] == i_vcnt[10:5] && score <= 175) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1061:1056] == i_hcnt[10:5] && y_pos[1061:1056] == i_vcnt[10:5] && score <= 176) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1067:1062] == i_hcnt[10:5] && y_pos[1067:1062] == i_vcnt[10:5] && score <= 177) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1073:1068] == i_hcnt[10:5] && y_pos[1073:1068] == i_vcnt[10:5] && score <= 178) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1079:1074] == i_hcnt[10:5] && y_pos[1079:1074] == i_vcnt[10:5] && score <= 179) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1085:1080] == i_hcnt[10:5] && y_pos[1085:1080] == i_vcnt[10:5] && score <= 180) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1091:1086] == i_hcnt[10:5] && y_pos[1091:1086] == i_vcnt[10:5] && score <= 181) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1097:1092] == i_hcnt[10:5] && y_pos[1097:1092] == i_vcnt[10:5] && score <= 182) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1103:1098] == i_hcnt[10:5] && y_pos[1103:1098] == i_vcnt[10:5] && score <= 183) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1109:1104] == i_hcnt[10:5] && y_pos[1109:1104] == i_vcnt[10:5] && score <= 184) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1115:1110] == i_hcnt[10:5] && y_pos[1115:1110] == i_vcnt[10:5] && score <= 185) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1121:1116] == i_hcnt[10:5] && y_pos[1121:1116] == i_vcnt[10:5] && score <= 186) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1127:1122] == i_hcnt[10:5] && y_pos[1127:1122] == i_vcnt[10:5] && score <= 187) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1133:1128] == i_hcnt[10:5] && y_pos[1133:1128] == i_vcnt[10:5] && score <= 188) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1139:1134] == i_hcnt[10:5] && y_pos[1139:1134] == i_vcnt[10:5] && score <= 189) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1145:1140] == i_hcnt[10:5] && y_pos[1145:1140] == i_vcnt[10:5] && score <= 190) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1151:1146] == i_hcnt[10:5] && y_pos[1151:1146] == i_vcnt[10:5] && score <= 191) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1157:1152] == i_hcnt[10:5] && y_pos[1157:1152] == i_vcnt[10:5] && score <= 192) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1163:1158] == i_hcnt[10:5] && y_pos[1163:1158] == i_vcnt[10:5] && score <= 193) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1169:1164] == i_hcnt[10:5] && y_pos[1169:1164] == i_vcnt[10:5] && score <= 194) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1175:1170] == i_hcnt[10:5] && y_pos[1175:1170] == i_vcnt[10:5] && score <= 195) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1181:1176] == i_hcnt[10:5] && y_pos[1181:1176] == i_vcnt[10:5] && score <= 196) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1187:1182] == i_hcnt[10:5] && y_pos[1187:1182] == i_vcnt[10:5] && score <= 197) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1193:1188] == i_hcnt[10:5] && y_pos[1193:1188] == i_vcnt[10:5] && score <= 198) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1199:1194] == i_hcnt[10:5] && y_pos[1199:1194] == i_vcnt[10:5] && score <= 199) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1205:1200] == i_hcnt[10:5] && y_pos[1205:1200] == i_vcnt[10:5] && score <= 200) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1211:1206] == i_hcnt[10:5] && y_pos[1211:1206] == i_vcnt[10:5] && score <= 201) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1217:1212] == i_hcnt[10:5] && y_pos[1217:1212] == i_vcnt[10:5] && score <= 202) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1223:1218] == i_hcnt[10:5] && y_pos[1223:1218] == i_vcnt[10:5] && score <= 203) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1229:1224] == i_hcnt[10:5] && y_pos[1229:1224] == i_vcnt[10:5] && score <= 204) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1235:1230] == i_hcnt[10:5] && y_pos[1235:1230] == i_vcnt[10:5] && score <= 205) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1241:1236] == i_hcnt[10:5] && y_pos[1241:1236] == i_vcnt[10:5] && score <= 206) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1247:1242] == i_hcnt[10:5] && y_pos[1247:1242] == i_vcnt[10:5] && score <= 207) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1253:1248] == i_hcnt[10:5] && y_pos[1253:1248] == i_vcnt[10:5] && score <= 208) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1259:1254] == i_hcnt[10:5] && y_pos[1259:1254] == i_vcnt[10:5] && score <= 209) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1265:1260] == i_hcnt[10:5] && y_pos[1265:1260] == i_vcnt[10:5] && score <= 210) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1271:1266] == i_hcnt[10:5] && y_pos[1271:1266] == i_vcnt[10:5] && score <= 211) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1277:1272] == i_hcnt[10:5] && y_pos[1277:1272] == i_vcnt[10:5] && score <= 212) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1283:1278] == i_hcnt[10:5] && y_pos[1283:1278] == i_vcnt[10:5] && score <= 213) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1289:1284] == i_hcnt[10:5] && y_pos[1289:1284] == i_vcnt[10:5] && score <= 214) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1295:1290] == i_hcnt[10:5] && y_pos[1295:1290] == i_vcnt[10:5] && score <= 215) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1301:1296] == i_hcnt[10:5] && y_pos[1301:1296] == i_vcnt[10:5] && score <= 216) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1307:1302] == i_hcnt[10:5] && y_pos[1307:1302] == i_vcnt[10:5] && score <= 217) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1313:1308] == i_hcnt[10:5] && y_pos[1313:1308] == i_vcnt[10:5] && score <= 218) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1319:1314] == i_hcnt[10:5] && y_pos[1319:1314] == i_vcnt[10:5] && score <= 219) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1325:1320] == i_hcnt[10:5] && y_pos[1325:1320] == i_vcnt[10:5] && score <= 220) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1331:1326] == i_hcnt[10:5] && y_pos[1331:1326] == i_vcnt[10:5] && score <= 221) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1337:1332] == i_hcnt[10:5] && y_pos[1337:1332] == i_vcnt[10:5] && score <= 222) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1343:1338] == i_hcnt[10:5] && y_pos[1343:1338] == i_vcnt[10:5] && score <= 223) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1349:1344] == i_hcnt[10:5] && y_pos[1349:1344] == i_vcnt[10:5] && score <= 224) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1355:1350] == i_hcnt[10:5] && y_pos[1355:1350] == i_vcnt[10:5] && score <= 225) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1361:1356] == i_hcnt[10:5] && y_pos[1361:1356] == i_vcnt[10:5] && score <= 226) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1367:1362] == i_hcnt[10:5] && y_pos[1367:1362] == i_vcnt[10:5] && score <= 227) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1373:1368] == i_hcnt[10:5] && y_pos[1373:1368] == i_vcnt[10:5] && score <= 228) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1379:1374] == i_hcnt[10:5] && y_pos[1379:1374] == i_vcnt[10:5] && score <= 229) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1385:1380] == i_hcnt[10:5] && y_pos[1385:1380] == i_vcnt[10:5] && score <= 230) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1391:1386] == i_hcnt[10:5] && y_pos[1391:1386] == i_vcnt[10:5] && score <= 231) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1397:1392] == i_hcnt[10:5] && y_pos[1397:1392] == i_vcnt[10:5] && score <= 232) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1403:1398] == i_hcnt[10:5] && y_pos[1403:1398] == i_vcnt[10:5] && score <= 233) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1409:1404] == i_hcnt[10:5] && y_pos[1409:1404] == i_vcnt[10:5] && score <= 234) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1415:1410] == i_hcnt[10:5] && y_pos[1415:1410] == i_vcnt[10:5] && score <= 235) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1421:1416] == i_hcnt[10:5] && y_pos[1421:1416] == i_vcnt[10:5] && score <= 236) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1427:1422] == i_hcnt[10:5] && y_pos[1427:1422] == i_vcnt[10:5] && score <= 237) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1433:1428] == i_hcnt[10:5] && y_pos[1433:1428] == i_vcnt[10:5] && score <= 238) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1439:1434] == i_hcnt[10:5] && y_pos[1439:1434] == i_vcnt[10:5] && score <= 239) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1445:1440] == i_hcnt[10:5] && y_pos[1445:1440] == i_vcnt[10:5] && score <= 240) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1451:1446] == i_hcnt[10:5] && y_pos[1451:1446] == i_vcnt[10:5] && score <= 241) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1457:1452] == i_hcnt[10:5] && y_pos[1457:1452] == i_vcnt[10:5] && score <= 242) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1463:1458] == i_hcnt[10:5] && y_pos[1463:1458] == i_vcnt[10:5] && score <= 243) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1469:1464] == i_hcnt[10:5] && y_pos[1469:1464] == i_vcnt[10:5] && score <= 244) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1475:1470] == i_hcnt[10:5] && y_pos[1475:1470] == i_vcnt[10:5] && score <= 245) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1481:1476] == i_hcnt[10:5] && y_pos[1481:1476] == i_vcnt[10:5] && score <= 246) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1487:1482] == i_hcnt[10:5] && y_pos[1487:1482] == i_vcnt[10:5] && score <= 247) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1493:1488] == i_hcnt[10:5] && y_pos[1493:1488] == i_vcnt[10:5] && score <= 248) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1499:1494] == i_hcnt[10:5] && y_pos[1499:1494] == i_vcnt[10:5] && score <= 249) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1505:1500] == i_hcnt[10:5] && y_pos[1505:1500] == i_vcnt[10:5] && score <= 250) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1511:1506] == i_hcnt[10:5] && y_pos[1511:1506] == i_vcnt[10:5] && score <= 251) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1517:1512] == i_hcnt[10:5] && y_pos[1517:1512] == i_vcnt[10:5] && score <= 252) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1523:1518] == i_hcnt[10:5] && y_pos[1523:1518] == i_vcnt[10:5] && score <= 253) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1529:1524] == i_hcnt[10:5] && y_pos[1529:1524] == i_vcnt[10:5] && score <= 254) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1535:1530] == i_hcnt[10:5] && y_pos[1535:1530] == i_vcnt[10:5] && score <= 255) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1541:1536] == i_hcnt[10:5] && y_pos[1541:1536] == i_vcnt[10:5] && score <= 256) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1547:1542] == i_hcnt[10:5] && y_pos[1547:1542] == i_vcnt[10:5] && score <= 257) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1553:1548] == i_hcnt[10:5] && y_pos[1553:1548] == i_vcnt[10:5] && score <= 258) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1559:1554] == i_hcnt[10:5] && y_pos[1559:1554] == i_vcnt[10:5] && score <= 259) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1565:1560] == i_hcnt[10:5] && y_pos[1565:1560] == i_vcnt[10:5] && score <= 260) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1571:1566] == i_hcnt[10:5] && y_pos[1571:1566] == i_vcnt[10:5] && score <= 261) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1577:1572] == i_hcnt[10:5] && y_pos[1577:1572] == i_vcnt[10:5] && score <= 262) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1583:1578] == i_hcnt[10:5] && y_pos[1583:1578] == i_vcnt[10:5] && score <= 263) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1589:1584] == i_hcnt[10:5] && y_pos[1589:1584] == i_vcnt[10:5] && score <= 264) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1595:1590] == i_hcnt[10:5] && y_pos[1595:1590] == i_vcnt[10:5] && score <= 265) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1601:1596] == i_hcnt[10:5] && y_pos[1601:1596] == i_vcnt[10:5] && score <= 266) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1607:1602] == i_hcnt[10:5] && y_pos[1607:1602] == i_vcnt[10:5] && score <= 267) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1613:1608] == i_hcnt[10:5] && y_pos[1613:1608] == i_vcnt[10:5] && score <= 268) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1619:1614] == i_hcnt[10:5] && y_pos[1619:1614] == i_vcnt[10:5] && score <= 269) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1625:1620] == i_hcnt[10:5] && y_pos[1625:1620] == i_vcnt[10:5] && score <= 270) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1631:1626] == i_hcnt[10:5] && y_pos[1631:1626] == i_vcnt[10:5] && score <= 271) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1637:1632] == i_hcnt[10:5] && y_pos[1637:1632] == i_vcnt[10:5] && score <= 272) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1643:1638] == i_hcnt[10:5] && y_pos[1643:1638] == i_vcnt[10:5] && score <= 273) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1649:1644] == i_hcnt[10:5] && y_pos[1649:1644] == i_vcnt[10:5] && score <= 274) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1655:1650] == i_hcnt[10:5] && y_pos[1655:1650] == i_vcnt[10:5] && score <= 275) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1661:1656] == i_hcnt[10:5] && y_pos[1661:1656] == i_vcnt[10:5] && score <= 276) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1667:1662] == i_hcnt[10:5] && y_pos[1667:1662] == i_vcnt[10:5] && score <= 277) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1673:1668] == i_hcnt[10:5] && y_pos[1673:1668] == i_vcnt[10:5] && score <= 278) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1679:1674] == i_hcnt[10:5] && y_pos[1679:1674] == i_vcnt[10:5] && score <= 279) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1685:1680] == i_hcnt[10:5] && y_pos[1685:1680] == i_vcnt[10:5] && score <= 280) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1691:1686] == i_hcnt[10:5] && y_pos[1691:1686] == i_vcnt[10:5] && score <= 281) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1697:1692] == i_hcnt[10:5] && y_pos[1697:1692] == i_vcnt[10:5] && score <= 282) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1703:1698] == i_hcnt[10:5] && y_pos[1703:1698] == i_vcnt[10:5] && score <= 283) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1709:1704] == i_hcnt[10:5] && y_pos[1709:1704] == i_vcnt[10:5] && score <= 284) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1715:1710] == i_hcnt[10:5] && y_pos[1715:1710] == i_vcnt[10:5] && score <= 285) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1721:1716] == i_hcnt[10:5] && y_pos[1721:1716] == i_vcnt[10:5] && score <= 286) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1727:1722] == i_hcnt[10:5] && y_pos[1727:1722] == i_vcnt[10:5] && score <= 287) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1733:1728] == i_hcnt[10:5] && y_pos[1733:1728] == i_vcnt[10:5] && score <= 288) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1739:1734] == i_hcnt[10:5] && y_pos[1739:1734] == i_vcnt[10:5] && score <= 289) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1745:1740] == i_hcnt[10:5] && y_pos[1745:1740] == i_vcnt[10:5] && score <= 290) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1751:1746] == i_hcnt[10:5] && y_pos[1751:1746] == i_vcnt[10:5] && score <= 291) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1757:1752] == i_hcnt[10:5] && y_pos[1757:1752] == i_vcnt[10:5] && score <= 292) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1763:1758] == i_hcnt[10:5] && y_pos[1763:1758] == i_vcnt[10:5] && score <= 293) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1769:1764] == i_hcnt[10:5] && y_pos[1769:1764] == i_vcnt[10:5] && score <= 294) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1775:1770] == i_hcnt[10:5] && y_pos[1775:1770] == i_vcnt[10:5] && score <= 295) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1781:1776] == i_hcnt[10:5] && y_pos[1781:1776] == i_vcnt[10:5] && score <= 296) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1787:1782] == i_hcnt[10:5] && y_pos[1787:1782] == i_vcnt[10:5] && score <= 297) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1793:1788] == i_hcnt[10:5] && y_pos[1793:1788] == i_vcnt[10:5] && score <= 298) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1799:1794] == i_hcnt[10:5] && y_pos[1799:1794] == i_vcnt[10:5] && score <= 299) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1805:1800] == i_hcnt[10:5] && y_pos[1805:1800] == i_vcnt[10:5] && score <= 300) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1811:1806] == i_hcnt[10:5] && y_pos[1811:1806] == i_vcnt[10:5] && score <= 301) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1817:1812] == i_hcnt[10:5] && y_pos[1817:1812] == i_vcnt[10:5] && score <= 302) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1823:1818] == i_hcnt[10:5] && y_pos[1823:1818] == i_vcnt[10:5] && score <= 303) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1829:1824] == i_hcnt[10:5] && y_pos[1829:1824] == i_vcnt[10:5] && score <= 304) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1835:1830] == i_hcnt[10:5] && y_pos[1835:1830] == i_vcnt[10:5] && score <= 305) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1841:1836] == i_hcnt[10:5] && y_pos[1841:1836] == i_vcnt[10:5] && score <= 306) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1847:1842] == i_hcnt[10:5] && y_pos[1847:1842] == i_vcnt[10:5] && score <= 307) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1853:1848] == i_hcnt[10:5] && y_pos[1853:1848] == i_vcnt[10:5] && score <= 308) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1859:1854] == i_hcnt[10:5] && y_pos[1859:1854] == i_vcnt[10:5] && score <= 309) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1865:1860] == i_hcnt[10:5] && y_pos[1865:1860] == i_vcnt[10:5] && score <= 310) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1871:1866] == i_hcnt[10:5] && y_pos[1871:1866] == i_vcnt[10:5] && score <= 311) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1877:1872] == i_hcnt[10:5] && y_pos[1877:1872] == i_vcnt[10:5] && score <= 312) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1883:1878] == i_hcnt[10:5] && y_pos[1883:1878] == i_vcnt[10:5] && score <= 313) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1889:1884] == i_hcnt[10:5] && y_pos[1889:1884] == i_vcnt[10:5] && score <= 314) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1895:1890] == i_hcnt[10:5] && y_pos[1895:1890] == i_vcnt[10:5] && score <= 315) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1901:1896] == i_hcnt[10:5] && y_pos[1901:1896] == i_vcnt[10:5] && score <= 316) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1907:1902] == i_hcnt[10:5] && y_pos[1907:1902] == i_vcnt[10:5] && score <= 317) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1913:1908] == i_hcnt[10:5] && y_pos[1913:1908] == i_vcnt[10:5] && score <= 318) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1919:1914] == i_hcnt[10:5] && y_pos[1919:1914] == i_vcnt[10:5] && score <= 319) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1925:1920] == i_hcnt[10:5] && y_pos[1925:1920] == i_vcnt[10:5] && score <= 320) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1931:1926] == i_hcnt[10:5] && y_pos[1931:1926] == i_vcnt[10:5] && score <= 321) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1937:1932] == i_hcnt[10:5] && y_pos[1937:1932] == i_vcnt[10:5] && score <= 322) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1943:1938] == i_hcnt[10:5] && y_pos[1943:1938] == i_vcnt[10:5] && score <= 323) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1949:1944] == i_hcnt[10:5] && y_pos[1949:1944] == i_vcnt[10:5] && score <= 324) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1955:1950] == i_hcnt[10:5] && y_pos[1955:1950] == i_vcnt[10:5] && score <= 325) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1961:1956] == i_hcnt[10:5] && y_pos[1961:1956] == i_vcnt[10:5] && score <= 326) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1967:1962] == i_hcnt[10:5] && y_pos[1967:1962] == i_vcnt[10:5] && score <= 327) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1973:1968] == i_hcnt[10:5] && y_pos[1973:1968] == i_vcnt[10:5] && score <= 328) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1979:1974] == i_hcnt[10:5] && y_pos[1979:1974] == i_vcnt[10:5] && score <= 329) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1985:1980] == i_hcnt[10:5] && y_pos[1985:1980] == i_vcnt[10:5] && score <= 330) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1991:1986] == i_hcnt[10:5] && y_pos[1991:1986] == i_vcnt[10:5] && score <= 331) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[1997:1992] == i_hcnt[10:5] && y_pos[1997:1992] == i_vcnt[10:5] && score <= 332) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2003:1998] == i_hcnt[10:5] && y_pos[2003:1998] == i_vcnt[10:5] && score <= 333) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2009:2004] == i_hcnt[10:5] && y_pos[2009:2004] == i_vcnt[10:5] && score <= 334) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2015:2010] == i_hcnt[10:5] && y_pos[2015:2010] == i_vcnt[10:5] && score <= 335) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2021:2016] == i_hcnt[10:5] && y_pos[2021:2016] == i_vcnt[10:5] && score <= 336) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2027:2022] == i_hcnt[10:5] && y_pos[2027:2022] == i_vcnt[10:5] && score <= 337) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2033:2028] == i_hcnt[10:5] && y_pos[2033:2028] == i_vcnt[10:5] && score <= 338) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2039:2034] == i_hcnt[10:5] && y_pos[2039:2034] == i_vcnt[10:5] && score <= 339) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2045:2040] == i_hcnt[10:5] && y_pos[2045:2040] == i_vcnt[10:5] && score <= 340) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2051:2046] == i_hcnt[10:5] && y_pos[2051:2046] == i_vcnt[10:5] && score <= 341) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2057:2052] == i_hcnt[10:5] && y_pos[2057:2052] == i_vcnt[10:5] && score <= 342) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2063:2058] == i_hcnt[10:5] && y_pos[2063:2058] == i_vcnt[10:5] && score <= 343) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2069:2064] == i_hcnt[10:5] && y_pos[2069:2064] == i_vcnt[10:5] && score <= 344) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2075:2070] == i_hcnt[10:5] && y_pos[2075:2070] == i_vcnt[10:5] && score <= 345) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2081:2076] == i_hcnt[10:5] && y_pos[2081:2076] == i_vcnt[10:5] && score <= 346) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2087:2082] == i_hcnt[10:5] && y_pos[2087:2082] == i_vcnt[10:5] && score <= 347) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2093:2088] == i_hcnt[10:5] && y_pos[2093:2088] == i_vcnt[10:5] && score <= 348) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2099:2094] == i_hcnt[10:5] && y_pos[2099:2094] == i_vcnt[10:5] && score <= 349) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2105:2100] == i_hcnt[10:5] && y_pos[2105:2100] == i_vcnt[10:5] && score <= 350) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2111:2106] == i_hcnt[10:5] && y_pos[2111:2106] == i_vcnt[10:5] && score <= 351) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2117:2112] == i_hcnt[10:5] && y_pos[2117:2112] == i_vcnt[10:5] && score <= 352) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2123:2118] == i_hcnt[10:5] && y_pos[2123:2118] == i_vcnt[10:5] && score <= 353) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2129:2124] == i_hcnt[10:5] && y_pos[2129:2124] == i_vcnt[10:5] && score <= 354) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2135:2130] == i_hcnt[10:5] && y_pos[2135:2130] == i_vcnt[10:5] && score <= 355) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2141:2136] == i_hcnt[10:5] && y_pos[2141:2136] == i_vcnt[10:5] && score <= 356) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2147:2142] == i_hcnt[10:5] && y_pos[2147:2142] == i_vcnt[10:5] && score <= 357) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2153:2148] == i_hcnt[10:5] && y_pos[2153:2148] == i_vcnt[10:5] && score <= 358) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2159:2154] == i_hcnt[10:5] && y_pos[2159:2154] == i_vcnt[10:5] && score <= 359) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2165:2160] == i_hcnt[10:5] && y_pos[2165:2160] == i_vcnt[10:5] && score <= 360) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2171:2166] == i_hcnt[10:5] && y_pos[2171:2166] == i_vcnt[10:5] && score <= 361) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2177:2172] == i_hcnt[10:5] && y_pos[2177:2172] == i_vcnt[10:5] && score <= 362) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2183:2178] == i_hcnt[10:5] && y_pos[2183:2178] == i_vcnt[10:5] && score <= 363) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2189:2184] == i_hcnt[10:5] && y_pos[2189:2184] == i_vcnt[10:5] && score <= 364) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2195:2190] == i_hcnt[10:5] && y_pos[2195:2190] == i_vcnt[10:5] && score <= 365) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2201:2196] == i_hcnt[10:5] && y_pos[2201:2196] == i_vcnt[10:5] && score <= 366) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2207:2202] == i_hcnt[10:5] && y_pos[2207:2202] == i_vcnt[10:5] && score <= 367) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2213:2208] == i_hcnt[10:5] && y_pos[2213:2208] == i_vcnt[10:5] && score <= 368) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2219:2214] == i_hcnt[10:5] && y_pos[2219:2214] == i_vcnt[10:5] && score <= 369) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2225:2220] == i_hcnt[10:5] && y_pos[2225:2220] == i_vcnt[10:5] && score <= 370) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2231:2226] == i_hcnt[10:5] && y_pos[2231:2226] == i_vcnt[10:5] && score <= 371) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2237:2232] == i_hcnt[10:5] && y_pos[2237:2232] == i_vcnt[10:5] && score <= 372) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2243:2238] == i_hcnt[10:5] && y_pos[2243:2238] == i_vcnt[10:5] && score <= 373) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2249:2244] == i_hcnt[10:5] && y_pos[2249:2244] == i_vcnt[10:5] && score <= 374) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2255:2250] == i_hcnt[10:5] && y_pos[2255:2250] == i_vcnt[10:5] && score <= 375) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2261:2256] == i_hcnt[10:5] && y_pos[2261:2256] == i_vcnt[10:5] && score <= 376) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2267:2262] == i_hcnt[10:5] && y_pos[2267:2262] == i_vcnt[10:5] && score <= 377) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2273:2268] == i_hcnt[10:5] && y_pos[2273:2268] == i_vcnt[10:5] && score <= 378) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2279:2274] == i_hcnt[10:5] && y_pos[2279:2274] == i_vcnt[10:5] && score <= 379) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2285:2280] == i_hcnt[10:5] && y_pos[2285:2280] == i_vcnt[10:5] && score <= 380) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2291:2286] == i_hcnt[10:5] && y_pos[2291:2286] == i_vcnt[10:5] && score <= 381) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2297:2292] == i_hcnt[10:5] && y_pos[2297:2292] == i_vcnt[10:5] && score <= 382) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2303:2298] == i_hcnt[10:5] && y_pos[2303:2298] == i_vcnt[10:5] && score <= 383) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2309:2304] == i_hcnt[10:5] && y_pos[2309:2304] == i_vcnt[10:5] && score <= 384) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2315:2310] == i_hcnt[10:5] && y_pos[2315:2310] == i_vcnt[10:5] && score <= 385) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2321:2316] == i_hcnt[10:5] && y_pos[2321:2316] == i_vcnt[10:5] && score <= 386) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2327:2322] == i_hcnt[10:5] && y_pos[2327:2322] == i_vcnt[10:5] && score <= 387) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2333:2328] == i_hcnt[10:5] && y_pos[2333:2328] == i_vcnt[10:5] && score <= 388) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2339:2334] == i_hcnt[10:5] && y_pos[2339:2334] == i_vcnt[10:5] && score <= 389) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2345:2340] == i_hcnt[10:5] && y_pos[2345:2340] == i_vcnt[10:5] && score <= 390) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2351:2346] == i_hcnt[10:5] && y_pos[2351:2346] == i_vcnt[10:5] && score <= 391) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2357:2352] == i_hcnt[10:5] && y_pos[2357:2352] == i_vcnt[10:5] && score <= 392) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2363:2358] == i_hcnt[10:5] && y_pos[2363:2358] == i_vcnt[10:5] && score <= 393) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2369:2364] == i_hcnt[10:5] && y_pos[2369:2364] == i_vcnt[10:5] && score <= 394) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2375:2370] == i_hcnt[10:5] && y_pos[2375:2370] == i_vcnt[10:5] && score <= 395) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2381:2376] == i_hcnt[10:5] && y_pos[2381:2376] == i_vcnt[10:5] && score <= 396) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2387:2382] == i_hcnt[10:5] && y_pos[2387:2382] == i_vcnt[10:5] && score <= 397) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2393:2388] == i_hcnt[10:5] && y_pos[2393:2388] == i_vcnt[10:5] && score <= 398) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2399:2394] == i_hcnt[10:5] && y_pos[2399:2394] == i_vcnt[10:5] && score <= 399) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2405:2400] == i_hcnt[10:5] && y_pos[2405:2400] == i_vcnt[10:5] && score <= 400) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2411:2406] == i_hcnt[10:5] && y_pos[2411:2406] == i_vcnt[10:5] && score <= 401) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2417:2412] == i_hcnt[10:5] && y_pos[2417:2412] == i_vcnt[10:5] && score <= 402) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2423:2418] == i_hcnt[10:5] && y_pos[2423:2418] == i_vcnt[10:5] && score <= 403) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2429:2424] == i_hcnt[10:5] && y_pos[2429:2424] == i_vcnt[10:5] && score <= 404) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2435:2430] == i_hcnt[10:5] && y_pos[2435:2430] == i_vcnt[10:5] && score <= 405) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2441:2436] == i_hcnt[10:5] && y_pos[2441:2436] == i_vcnt[10:5] && score <= 406) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2447:2442] == i_hcnt[10:5] && y_pos[2447:2442] == i_vcnt[10:5] && score <= 407) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2453:2448] == i_hcnt[10:5] && y_pos[2453:2448] == i_vcnt[10:5] && score <= 408) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2459:2454] == i_hcnt[10:5] && y_pos[2459:2454] == i_vcnt[10:5] && score <= 409) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2465:2460] == i_hcnt[10:5] && y_pos[2465:2460] == i_vcnt[10:5] && score <= 410) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2471:2466] == i_hcnt[10:5] && y_pos[2471:2466] == i_vcnt[10:5] && score <= 411) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2477:2472] == i_hcnt[10:5] && y_pos[2477:2472] == i_vcnt[10:5] && score <= 412) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2483:2478] == i_hcnt[10:5] && y_pos[2483:2478] == i_vcnt[10:5] && score <= 413) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2489:2484] == i_hcnt[10:5] && y_pos[2489:2484] == i_vcnt[10:5] && score <= 414) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2495:2490] == i_hcnt[10:5] && y_pos[2495:2490] == i_vcnt[10:5] && score <= 415) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2501:2496] == i_hcnt[10:5] && y_pos[2501:2496] == i_vcnt[10:5] && score <= 416) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2507:2502] == i_hcnt[10:5] && y_pos[2507:2502] == i_vcnt[10:5] && score <= 417) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2513:2508] == i_hcnt[10:5] && y_pos[2513:2508] == i_vcnt[10:5] && score <= 418) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2519:2514] == i_hcnt[10:5] && y_pos[2519:2514] == i_vcnt[10:5] && score <= 419) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2525:2520] == i_hcnt[10:5] && y_pos[2525:2520] == i_vcnt[10:5] && score <= 420) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2531:2526] == i_hcnt[10:5] && y_pos[2531:2526] == i_vcnt[10:5] && score <= 421) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2537:2532] == i_hcnt[10:5] && y_pos[2537:2532] == i_vcnt[10:5] && score <= 422) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2543:2538] == i_hcnt[10:5] && y_pos[2543:2538] == i_vcnt[10:5] && score <= 423) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2549:2544] == i_hcnt[10:5] && y_pos[2549:2544] == i_vcnt[10:5] && score <= 424) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2555:2550] == i_hcnt[10:5] && y_pos[2555:2550] == i_vcnt[10:5] && score <= 425) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2561:2556] == i_hcnt[10:5] && y_pos[2561:2556] == i_vcnt[10:5] && score <= 426) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2567:2562] == i_hcnt[10:5] && y_pos[2567:2562] == i_vcnt[10:5] && score <= 427) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2573:2568] == i_hcnt[10:5] && y_pos[2573:2568] == i_vcnt[10:5] && score <= 428) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2579:2574] == i_hcnt[10:5] && y_pos[2579:2574] == i_vcnt[10:5] && score <= 429) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2585:2580] == i_hcnt[10:5] && y_pos[2585:2580] == i_vcnt[10:5] && score <= 430) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2591:2586] == i_hcnt[10:5] && y_pos[2591:2586] == i_vcnt[10:5] && score <= 431) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2597:2592] == i_hcnt[10:5] && y_pos[2597:2592] == i_vcnt[10:5] && score <= 432) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2603:2598] == i_hcnt[10:5] && y_pos[2603:2598] == i_vcnt[10:5] && score <= 433) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2609:2604] == i_hcnt[10:5] && y_pos[2609:2604] == i_vcnt[10:5] && score <= 434) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2615:2610] == i_hcnt[10:5] && y_pos[2615:2610] == i_vcnt[10:5] && score <= 435) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2621:2616] == i_hcnt[10:5] && y_pos[2621:2616] == i_vcnt[10:5] && score <= 436) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2627:2622] == i_hcnt[10:5] && y_pos[2627:2622] == i_vcnt[10:5] && score <= 437) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2633:2628] == i_hcnt[10:5] && y_pos[2633:2628] == i_vcnt[10:5] && score <= 438) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2639:2634] == i_hcnt[10:5] && y_pos[2639:2634] == i_vcnt[10:5] && score <= 439) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2645:2640] == i_hcnt[10:5] && y_pos[2645:2640] == i_vcnt[10:5] && score <= 440) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2651:2646] == i_hcnt[10:5] && y_pos[2651:2646] == i_vcnt[10:5] && score <= 441) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2657:2652] == i_hcnt[10:5] && y_pos[2657:2652] == i_vcnt[10:5] && score <= 442) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2663:2658] == i_hcnt[10:5] && y_pos[2663:2658] == i_vcnt[10:5] && score <= 443) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2669:2664] == i_hcnt[10:5] && y_pos[2669:2664] == i_vcnt[10:5] && score <= 444) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2675:2670] == i_hcnt[10:5] && y_pos[2675:2670] == i_vcnt[10:5] && score <= 445) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2681:2676] == i_hcnt[10:5] && y_pos[2681:2676] == i_vcnt[10:5] && score <= 446) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2687:2682] == i_hcnt[10:5] && y_pos[2687:2682] == i_vcnt[10:5] && score <= 447) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2693:2688] == i_hcnt[10:5] && y_pos[2693:2688] == i_vcnt[10:5] && score <= 448) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2699:2694] == i_hcnt[10:5] && y_pos[2699:2694] == i_vcnt[10:5] && score <= 449) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2705:2700] == i_hcnt[10:5] && y_pos[2705:2700] == i_vcnt[10:5] && score <= 450) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2711:2706] == i_hcnt[10:5] && y_pos[2711:2706] == i_vcnt[10:5] && score <= 451) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2717:2712] == i_hcnt[10:5] && y_pos[2717:2712] == i_vcnt[10:5] && score <= 452) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2723:2718] == i_hcnt[10:5] && y_pos[2723:2718] == i_vcnt[10:5] && score <= 453) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2729:2724] == i_hcnt[10:5] && y_pos[2729:2724] == i_vcnt[10:5] && score <= 454) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2735:2730] == i_hcnt[10:5] && y_pos[2735:2730] == i_vcnt[10:5] && score <= 455) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2741:2736] == i_hcnt[10:5] && y_pos[2741:2736] == i_vcnt[10:5] && score <= 456) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2747:2742] == i_hcnt[10:5] && y_pos[2747:2742] == i_vcnt[10:5] && score <= 457) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2753:2748] == i_hcnt[10:5] && y_pos[2753:2748] == i_vcnt[10:5] && score <= 458) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2759:2754] == i_hcnt[10:5] && y_pos[2759:2754] == i_vcnt[10:5] && score <= 459) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2765:2760] == i_hcnt[10:5] && y_pos[2765:2760] == i_vcnt[10:5] && score <= 460) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2771:2766] == i_hcnt[10:5] && y_pos[2771:2766] == i_vcnt[10:5] && score <= 461) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2777:2772] == i_hcnt[10:5] && y_pos[2777:2772] == i_vcnt[10:5] && score <= 462) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2783:2778] == i_hcnt[10:5] && y_pos[2783:2778] == i_vcnt[10:5] && score <= 463) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2789:2784] == i_hcnt[10:5] && y_pos[2789:2784] == i_vcnt[10:5] && score <= 464) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2795:2790] == i_hcnt[10:5] && y_pos[2795:2790] == i_vcnt[10:5] && score <= 465) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2801:2796] == i_hcnt[10:5] && y_pos[2801:2796] == i_vcnt[10:5] && score <= 466) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2807:2802] == i_hcnt[10:5] && y_pos[2807:2802] == i_vcnt[10:5] && score <= 467) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2813:2808] == i_hcnt[10:5] && y_pos[2813:2808] == i_vcnt[10:5] && score <= 468) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2819:2814] == i_hcnt[10:5] && y_pos[2819:2814] == i_vcnt[10:5] && score <= 469) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2825:2820] == i_hcnt[10:5] && y_pos[2825:2820] == i_vcnt[10:5] && score <= 470) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2831:2826] == i_hcnt[10:5] && y_pos[2831:2826] == i_vcnt[10:5] && score <= 471) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2837:2832] == i_hcnt[10:5] && y_pos[2837:2832] == i_vcnt[10:5] && score <= 472) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2843:2838] == i_hcnt[10:5] && y_pos[2843:2838] == i_vcnt[10:5] && score <= 473) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2849:2844] == i_hcnt[10:5] && y_pos[2849:2844] == i_vcnt[10:5] && score <= 474) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2855:2850] == i_hcnt[10:5] && y_pos[2855:2850] == i_vcnt[10:5] && score <= 475) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2861:2856] == i_hcnt[10:5] && y_pos[2861:2856] == i_vcnt[10:5] && score <= 476) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2867:2862] == i_hcnt[10:5] && y_pos[2867:2862] == i_vcnt[10:5] && score <= 477) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2873:2868] == i_hcnt[10:5] && y_pos[2873:2868] == i_vcnt[10:5] && score <= 478) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2879:2874] == i_hcnt[10:5] && y_pos[2879:2874] == i_vcnt[10:5] && score <= 479) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2885:2880] == i_hcnt[10:5] && y_pos[2885:2880] == i_vcnt[10:5] && score <= 480) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2891:2886] == i_hcnt[10:5] && y_pos[2891:2886] == i_vcnt[10:5] && score <= 481) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2897:2892] == i_hcnt[10:5] && y_pos[2897:2892] == i_vcnt[10:5] && score <= 482) begin
			 o_r <= r_0;
			 o_g <= g_0;
			 o_b <= b_0;
		end else if(x_pos[2903:2898] == i_hcnt[10:5] && y_pos[2903:2898] == i_vcnt[10:5] && score <= 483) begin
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
