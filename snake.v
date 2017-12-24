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
module snake(
	input            i_clk_74M, //25 MHZ pixel clock
	input [11:0]     i_vcnt, //vertical counter from video timing generator
	input [11:0]     i_hcnt, //horizontal counter from video timing generator
	
	input r_btn, //right input
	input l_btn, //left input
	input d_btn, //down input
	input u_btn, //up input
	input c_btn, //center input

	output reg[7:0]  o_r, //red output
	output reg[7:0]  o_g, //green output
	output reg[7:0]  o_b // blue output
);		
	
	reg [1:0] direction = 2'b00; //the direction of the snake
										  //00 right
										  //01 left
										  //10 up
										  //11 down
										  			  
	always @(posedge i_clk_74M) begin	
		if(r_btn == 1'b1 && direction[1] == 1'b1) begin //if we press right and we are moving up or down
			direction <= 2'b00; //then turn right
		end else if(l_btn == 1'b1 && direction[1] == 1'b1) begin //if we press left and we are moving up or down
			direction <= 2'b01; //then turn left
		end else if(d_btn == 1'b1 && direction[1] == 1'b0) begin //if we press down and we are moving right or left
			direction <= 2'b11; //then turn down
		end else if(u_btn == 1'b1 && direction[1] == 1'b0) begin //if we press up and we are moving right or left
			direction <= 2'b10; //then turn up
		end else if(c_btn == 1'b1) begin //middle button has no usage as of now
			direction <= direction; //keep the direction
		end else begin
			direction <= direction;
		end			
	end
	
	wire [7:0] r_s; //three 8 bit wires (r, g, b) for the data of the first image which is the apple image
	wire [7:0] g_s;
	wire [7:0] b_s;
	
	image_rom_0 rom_0 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_s, g_s, b_s});	//the rom containing the image of the snake body
	
	reg [5:0] x_pos [0:168] = {6'd2, 1008'b0}; //a memory storing all the possible x positions of the snake
	reg [5:0] y_pos [0:168] = {6'd12, 1008'b0}; //a memory storing all the possible y positions of the snake
	
	reg [11:0] score = 12'd0; //a score register, that also enables us to increase the size of our snake
	
	wire [7:0] r_s_h_d;//rgb wires for head looking down
	wire [7:0] g_s_h_d;
	wire [7:0] b_s_h_d;
		
	wire [7:0] r_s_h_l;//rgb wires for head looking left
	wire [7:0] g_s_h_l;
	wire [7:0] b_s_h_l;
		
	wire [7:0] r_s_h_r;//rgb wires for head looking right
	wire [7:0] g_s_h_r;
	wire [7:0] b_s_h_r;
		
	wire [7:0] r_s_h_u;//rgb wires for head looking up
	wire [7:0] g_s_h_u;
	wire [7:0] b_s_h_u;
	
	s_h_d_rom s_h_d (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_s_h_d, g_s_h_d, b_s_h_d});	//the rom containing the image of the snake head looking down
	s_h_l_rom s_h_l (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_s_h_l, g_s_h_l, b_s_h_l});	//the rom containing the image of the snake head looking left
	s_h_r_rom s_h_r (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_s_h_r, g_s_h_r, b_s_h_r});	//the rom containing the image of the snake head looking right
	s_h_u_rom s_h_u (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_s_h_u, g_s_h_u, b_s_h_u});	//the rom containing the image of the snake head looking up
	
	reg [7:0] r_s_h;//rgb reg for head depending on direction
	reg [7:0] g_s_h;
	reg [7:0] b_s_h;
	
	always @ (direction) begin//simple logic to assign the value to the above reg depending on the direction.
		if(direction == 2'b00) begin
			r_s_h <= r_s_h_r;
			g_s_h <= g_s_h_r;
			b_s_h	<= b_s_h_r;
		end else if(direction == 2'b01) begin
			r_s_h <= r_s_h_l;
			g_s_h <= g_s_h_l;
			b_s_h	<= b_s_h_l;
		end else if(direction == 2'b11) begin
			r_s_h <= r_s_h_d;
			g_s_h <= g_s_h_d;
			b_s_h	<= b_s_h_d;
		end else begin
			r_s_h <= r_s_h_u;
			g_s_h <= g_s_h_u;
			b_s_h	<= b_s_h_u;
		end
	end
	

	wire [7:0] r_b; //(r, g, b) wires for the brick wall
	wire [7:0] g_b;
	wire [7:0] b_b;
	
	reg [5:0] x_pos_b = 6'd0; //starting position of the brick wall
	reg [5:0] y_pos_b = 6'd0;
	
	image_rom_1 rom_1 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_b, g_b, b_b});	//image rom for the brick wall
	
		
	wire [7:0] r_a; //(r, g, b) for the apple
	wire [7:0] g_a;
	wire [7:0] b_a;
	
	reg [5:0] x_pos_a = 6'd10; //position of the apple
	reg [5:0] y_pos_a = 6'd10;

	image_rom_2 rom_2 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_a, g_a, b_a});	 //image rom for the apple
	
	reg bitten = 1'b0; //flag to check if bitten
	
	reg [24:0] cnt = 25'd1; //counting cycles to move once per 25million cycles equal to one second.
	reg [9:0] i; //used in the for loops
	
	wire [15:0] rng;
	PRNG prng_gen (i_clk_74M, rng);
	
	reg [5:0] new_x_a = 6'd1;//the new position the apple is gonna appear after it gets eaten
	reg [5:0] new_y_a = 6'd1;
	
	reg [5:0] temp_x_a = 6'd1;//the temp position for searching through the grid for available position
	reg [5:0] temp_y_a = 6'd1;
	
	reg [11:0] c_cnt = 12'd0;//counting cycles for the apple position part
	
	reg available = 1'b1;//flag to check if a position for the apple is available.
	
	reg [8:0] M = 9'd1;//counts how many positions have been approved as available. (plus one)
	
	wire [15:0] threshold;//the threshold that's used to run the random experiment of random sampling
	divisions_lut divider (M, threshold);	//
	
	wire [7:0] r_0; //(r, g, b) for 0
	wire [7:0] g_0;
	wire [7:0] b_0;	
	wire [7:0] r_1; //(r, g, b) for 1
	wire [7:0] g_1;
	wire [7:0] b_1;	
	wire [7:0] r_2; //(r, g, b) for 2
	wire [7:0] g_2;
	wire [7:0] b_2;	
	wire [7:0] r_3; //(r, g, b) for 3
	wire [7:0] g_3;
	wire [7:0] b_3;	
	wire [7:0] r_4; //(r, g, b) for 4
	wire [7:0] g_4;
	wire [7:0] b_4;	
	wire [7:0] r_5; //(r, g, b) for 5
	wire [7:0] g_5;
	wire [7:0] b_5;	
	wire [7:0] r_6; //(r, g, b) for 6
	wire [7:0] g_6;
	wire [7:0] b_6;	
	wire [7:0] r_7; //(r, g, b) for 7
	wire [7:0] g_7;
	wire [7:0] b_7;	
	wire [7:0] r_8; //(r, g, b) for 8
	wire [7:0] g_8;
	wire [7:0] b_8;	
	wire [7:0] r_9; //(r, g, b) for 9
	wire [7:0] g_9;
	wire [7:0] b_9;

	_0_rom _0 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_0, g_0, b_0});	 //image rom for 0
	_1_rom _1 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_1, g_1, b_1});	 //image rom for 1
	_2_rom _2 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_2, g_2, b_2});	 //image rom for 2
	_3_rom _3 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_3, g_3, b_3});	 //image rom for 3
	_4_rom _4 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_4, g_4, b_4});	 //image rom for 4
	_5_rom _5 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_5, g_5, b_5});	 //image rom for 5
	_6_rom _6 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_6, g_6, b_6});	 //image rom for 6
	_7_rom _7 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_7, g_7, b_7});	 //image rom for 7
	_8_rom _8 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_8, g_8, b_8});	 //image rom for 8
	_9_rom _9 (i_clk_74M, i_hcnt[4:0], i_vcnt[4:0], {r_9, g_9, b_9});	 //image rom for 9
	
	always @ (posedge i_clk_74M) begin
		if(((x_pos[c_cnt] == temp_x_a && y_pos[c_cnt] == temp_y_a) || (x_pos_a == temp_x_a && y_pos_a == temp_y_a)) && score >= c_cnt) begin
			available <= 1'b0; //if a part of the snake is on the temp position then check this position as not available
		end
		if(c_cnt == score + 12'd1) begin //if the counter has reached the length of our snake plus one then
			c_cnt <= 12'd0;//reset the counter
			if(available == 1'b1 && rng <= threshold) begin //if at the end of the cycles this position is still available and the random experiment holds true
				new_x_a <= temp_x_a; //assign the temp position as the new position
				new_y_a <= temp_y_a;
				M <= M + 9'd1; //increasing the counter of approved positions
			end
			available <= 1'b1; //in any case reset the available flag
			if(temp_x_a == 6'd13) begin//looping through the positions on the grid.
				temp_x_a <= 6'd1;
				if(temp_y_a == 6'd13) begin
					temp_y_a <= 6'd1;
					M <= 9'd1;//reseting approved positions after a full 13*13 loop
				end else begin
					temp_y_a <= temp_y_a + 6'd1; //increasing temp y
				end
			end else begin
				temp_x_a <= temp_x_a + 6'd1; //increasing temp x
			end			
		end else begin
			c_cnt <= c_cnt + 12'd1; //increasing loop counter
		end		
	end
	
	wire [3:0] ONES;
	wire [3:0] TENS;
	wire [1:0] HUNDRENDS;
	
	bin2bcd bin2bcd_converter (score,ONES,TENS,HUNDRENDS);
	
	reg [7:0] r_c_0; //color for first digit of score
	reg [7:0] g_c_0;
	reg [7:0] b_c_0;
	
	reg [7:0] r_c_1; //second digit
	reg [7:0] g_c_1;
	reg [7:0] b_c_1;
	
	reg [7:0] r_c_2; //third digit
	reg [7:0] g_c_2;
	reg [7:0] b_c_2;
	
	always @ (ONES) begin //assign color depending on the number
		if(ONES == 4'b0000) begin
			r_c_0 <= r_0;
			g_c_0 <= g_0;
			b_c_0 <= b_0;
		end else if(ONES == 4'b0001) begin
			r_c_0 <= r_1;
			g_c_0 <= g_1;
			b_c_0 <= b_1;
		end else if(ONES == 4'b0010) begin
			r_c_0 <= r_2;
			g_c_0 <= g_2;
			b_c_0 <= b_2;
		end else if(ONES == 4'b0011) begin
			r_c_0 <= r_3;
			g_c_0 <= g_3;
			b_c_0 <= b_3;
		end else if(ONES == 4'b0100) begin
			r_c_0 <= r_4;
			g_c_0 <= g_4;
			b_c_0 <= b_4;
		end else if(ONES == 4'b0101) begin
			r_c_0 <= r_5;
			g_c_0 <= g_5;
			b_c_0 <= b_5;
		end else if(ONES == 4'b0110) begin
			r_c_0 <= r_6;
			g_c_0 <= g_6;
			b_c_0 <= b_6;
		end else if(ONES == 4'b0111) begin
			r_c_0 <= r_7;
			g_c_0 <= g_7;
			b_c_0 <= b_7;
		end else if(ONES == 4'b1000) begin
			r_c_0 <= r_8;
			g_c_0 <= g_8;
			b_c_0 <= b_8;
		end else if(ONES == 4'b1001) begin
			r_c_0 <= r_9;
			g_c_0 <= g_9;
			b_c_0 <= b_9;
		end else begin
			r_c_0 <= r_0;
			g_c_0 <= g_0;
			b_c_0 <= b_0;
		end
	end
	
	always @ (TENS) begin//assign color depending on the number
		if(TENS == 4'b0000) begin
			r_c_1 <= r_0;
			g_c_1 <= g_0;
			b_c_1 <= b_0;
		end else if(TENS == 4'b0001) begin
			r_c_1 <= r_1;
			g_c_1 <= g_1;
			b_c_1 <= b_1;
		end else if(TENS == 4'b0010) begin
			r_c_1 <= r_2;
			g_c_1 <= g_2;
			b_c_1 <= b_2;
		end else if(TENS == 4'b0011) begin
			r_c_1 <= r_3;
			g_c_1 <= g_3;
			b_c_1 <= b_3;
		end else if(TENS == 4'b0100) begin
			r_c_1 <= r_4;
			g_c_1 <= g_4;
			b_c_1 <= b_4;
		end else if(TENS == 4'b0101) begin
			r_c_1 <= r_5;
			g_c_1 <= g_5;
			b_c_1 <= b_5;
		end else if(TENS == 4'b0110) begin
			r_c_1 <= r_6;
			g_c_1 <= g_6;
			b_c_1 <= b_6;
		end else if(TENS == 4'b0111) begin
			r_c_1 <= r_7;
			g_c_1 <= g_7;
			b_c_1 <= b_7;
		end else if(TENS == 4'b1000) begin
			r_c_1 <= r_8;
			g_c_1 <= g_8;
			b_c_1 <= b_8;
		end else if(TENS == 4'b1001) begin
			r_c_1 <= r_9;
			g_c_1 <= g_9;
			b_c_1 <= b_9;
		end else begin
			r_c_1 <= r_0;
			g_c_1 <= g_0;
			b_c_1 <= b_0;
		end
	end
	
	always @ (HUNDRENDS) begin//assign color depending on the number
		if(HUNDRENDS == 2'b00) begin
			r_c_2 <= r_0;
			g_c_2 <= g_0;
			b_c_2 <= b_0;
		end else if(HUNDRENDS == 2'b01) begin
			r_c_2 <= r_1;
			g_c_2 <= g_1;
			b_c_2 <= b_1;
		end else if(HUNDRENDS == 2'b10) begin
			r_c_2 <= r_2;
			g_c_2 <= g_2;
			b_c_2 <= b_2;
		end else begin
			r_c_2 <= r_0;
			g_c_2 <= g_0;
			b_c_2 <= b_0;
		end
	end
	
	always @ (posedge i_clk_74M) begin
		if(cnt == 25'd25000000) begin //once every 25million cycles
			cnt <= 1;
			bitten <= 1'b0; //reset bitten flag every time the snake moves. this will get removed later
			if(direction == 2'b00) begin //if we are moving right
				if(x_pos[0] < 13) begin //and we are not going out of bounds
					x_pos[0] <= x_pos[0] + 1; // move to the right
				end else begin
					x_pos[0] <= 1; //else cycle around
				end
				if(x_pos[0] + 1 == x_pos_a && y_pos[0] == y_pos_a) begin //if the position we are going to move to is occupied by an apple increase our score
					score <= score + 1;
					x_pos_a <= new_x_a; //assign new position to apple
					y_pos_a <= new_y_a;
				end
			end else if(direction == 2'b01) begin //same logic as above for left movement
				if(x_pos[0] > 1) begin
					x_pos[0] <= x_pos[0] - 1;
				end else begin
					x_pos[0] <= 13;
				end
				if(x_pos[0] - 1 == x_pos_a && y_pos[0] == y_pos_a) begin
					score <= score + 1;
					x_pos_a <= new_x_a; 
					y_pos_a <= new_y_a;
				end
			end else if(direction == 2'b11) begin //same logic as above for down movement
				if(y_pos[0] < 13) begin
					y_pos[0] <= y_pos[0] + 1;
				end else begin
					y_pos[0] <= 1;
				end
				if(x_pos[0] == x_pos_a && y_pos[0] + 1 == y_pos_a) begin
					score <= score + 1;
					x_pos_a <= new_x_a;
					y_pos_a <= new_y_a;
				end
			end else if(direction == 2'b10) begin //same logic as above for up movement
				if(y_pos[0] > 1) begin
					y_pos[0] <= y_pos[0] - 1;
				end else begin
					y_pos[0] <= 13;
				end
				if(x_pos[0] == x_pos_a && y_pos[0] - 1 == y_pos_a) begin
					score <= score + 1;
					x_pos_a <= new_x_a;
					y_pos_a <= new_y_a;
				end
			end			
			for(i = 1; i <= 168; i = i + 1) begin //pass the movement to the lower parts of the body.
			  x_pos[i] <= x_pos[i-1];
			  y_pos[i] <= y_pos[i-1];
			end
		end else begin
			if(cnt <= 25'd168 && cnt >= 25'd1 && bitten == 1'b0) begin //the first 168 cycles we check if it bit itself
				if(score >= cnt[11:0] && x_pos[0] == x_pos[cnt] && y_pos[0] == y_pos[cnt]) begin //check a different part in each cycle
					bitten <= 1'b1; //it bit itself
				end
			end
			cnt <= cnt + 1; //count cycles
		end
	end
	
	
	
	
	
	
	always @ (posedge i_clk_74M) begin	
		
		if(x_pos_b <= i_hcnt[10:5] && x_pos_b + 6'd15 > i_hcnt[10:5] && y_pos_b == i_vcnt[10:5]) begin //if drawing top border return brick wall image
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(x_pos_b <= i_hcnt[10:5] && x_pos_b + 6'd15 > i_hcnt[10:5] && y_pos_b == i_vcnt[10:5] - 6'd14) begin //if drawing bottom border return brick wall image
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(y_pos_b <= i_vcnt[10:5] && y_pos_b + 6'd15 > i_vcnt[10:5] && x_pos_b == i_hcnt[10:5]) begin //if drawing left border return brick wall image
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(y_pos_b <= i_vcnt[10:5] && y_pos_b + 6'd15 > i_vcnt[10:5] && x_pos_b == i_hcnt[10:5] - 6'd14) begin //if drawing right border return brick wall image
			o_r <= r_b;
			o_g <= g_b;
			o_b <= b_b;
		end else if(x_pos[0] == i_hcnt[10:5] && y_pos[0] == i_vcnt[10:5] && score >= 0) begin //big else if statement to check all the snake parts to draw them. Go to the bottom for the apple.
			if(bitten == 1'b0) begin //swapping the colors if the snake has bit its tail.
				 o_r <= r_s_h;
				 o_g <= g_s_h;
				 o_b <= b_s_h;
			end else begin
				 o_r <= g_s_h;
				 o_g <= b_s_h;
				 o_b <= r_s_h;
			end
		end else if(x_pos[1] == i_hcnt[10:5] && y_pos[1] == i_vcnt[10:5] && score >= 1) begin //we only check the snake parts that have position lower or equal than the score.
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[2] == i_hcnt[10:5] && y_pos[2] == i_vcnt[10:5] && score >= 2) begin //score == size of the snake.
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[3] == i_hcnt[10:5] && y_pos[3] == i_vcnt[10:5] && score >= 3) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[4] == i_hcnt[10:5] && y_pos[4] == i_vcnt[10:5] && score >= 4) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[5] == i_hcnt[10:5] && y_pos[5] == i_vcnt[10:5] && score >= 5) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[6] == i_hcnt[10:5] && y_pos[6] == i_vcnt[10:5] && score >= 6) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[7] == i_hcnt[10:5] && y_pos[7] == i_vcnt[10:5] && score >= 7) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[8] == i_hcnt[10:5] && y_pos[8] == i_vcnt[10:5] && score >= 8) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[9] == i_hcnt[10:5] && y_pos[9] == i_vcnt[10:5] && score >= 9) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[10] == i_hcnt[10:5] && y_pos[10] == i_vcnt[10:5] && score >= 10) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[11] == i_hcnt[10:5] && y_pos[11] == i_vcnt[10:5] && score >= 11) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[12] == i_hcnt[10:5] && y_pos[12] == i_vcnt[10:5] && score >= 12) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[13] == i_hcnt[10:5] && y_pos[13] == i_vcnt[10:5] && score >= 13) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[14] == i_hcnt[10:5] && y_pos[14] == i_vcnt[10:5] && score >= 14) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[15] == i_hcnt[10:5] && y_pos[15] == i_vcnt[10:5] && score >= 15) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[16] == i_hcnt[10:5] && y_pos[16] == i_vcnt[10:5] && score >= 16) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[17] == i_hcnt[10:5] && y_pos[17] == i_vcnt[10:5] && score >= 17) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[18] == i_hcnt[10:5] && y_pos[18] == i_vcnt[10:5] && score >= 18) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[19] == i_hcnt[10:5] && y_pos[19] == i_vcnt[10:5] && score >= 19) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[20] == i_hcnt[10:5] && y_pos[20] == i_vcnt[10:5] && score >= 20) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[21] == i_hcnt[10:5] && y_pos[21] == i_vcnt[10:5] && score >= 21) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[22] == i_hcnt[10:5] && y_pos[22] == i_vcnt[10:5] && score >= 22) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[23] == i_hcnt[10:5] && y_pos[23] == i_vcnt[10:5] && score >= 23) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[24] == i_hcnt[10:5] && y_pos[24] == i_vcnt[10:5] && score >= 24) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[25] == i_hcnt[10:5] && y_pos[25] == i_vcnt[10:5] && score >= 25) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[26] == i_hcnt[10:5] && y_pos[26] == i_vcnt[10:5] && score >= 26) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[27] == i_hcnt[10:5] && y_pos[27] == i_vcnt[10:5] && score >= 27) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[28] == i_hcnt[10:5] && y_pos[28] == i_vcnt[10:5] && score >= 28) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[29] == i_hcnt[10:5] && y_pos[29] == i_vcnt[10:5] && score >= 29) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[30] == i_hcnt[10:5] && y_pos[30] == i_vcnt[10:5] && score >= 30) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[31] == i_hcnt[10:5] && y_pos[31] == i_vcnt[10:5] && score >= 31) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[32] == i_hcnt[10:5] && y_pos[32] == i_vcnt[10:5] && score >= 32) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[33] == i_hcnt[10:5] && y_pos[33] == i_vcnt[10:5] && score >= 33) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[34] == i_hcnt[10:5] && y_pos[34] == i_vcnt[10:5] && score >= 34) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[35] == i_hcnt[10:5] && y_pos[35] == i_vcnt[10:5] && score >= 35) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[36] == i_hcnt[10:5] && y_pos[36] == i_vcnt[10:5] && score >= 36) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[37] == i_hcnt[10:5] && y_pos[37] == i_vcnt[10:5] && score >= 37) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[38] == i_hcnt[10:5] && y_pos[38] == i_vcnt[10:5] && score >= 38) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[39] == i_hcnt[10:5] && y_pos[39] == i_vcnt[10:5] && score >= 39) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[40] == i_hcnt[10:5] && y_pos[40] == i_vcnt[10:5] && score >= 40) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[41] == i_hcnt[10:5] && y_pos[41] == i_vcnt[10:5] && score >= 41) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[42] == i_hcnt[10:5] && y_pos[42] == i_vcnt[10:5] && score >= 42) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[43] == i_hcnt[10:5] && y_pos[43] == i_vcnt[10:5] && score >= 43) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[44] == i_hcnt[10:5] && y_pos[44] == i_vcnt[10:5] && score >= 44) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[45] == i_hcnt[10:5] && y_pos[45] == i_vcnt[10:5] && score >= 45) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[46] == i_hcnt[10:5] && y_pos[46] == i_vcnt[10:5] && score >= 46) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[47] == i_hcnt[10:5] && y_pos[47] == i_vcnt[10:5] && score >= 47) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[48] == i_hcnt[10:5] && y_pos[48] == i_vcnt[10:5] && score >= 48) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[49] == i_hcnt[10:5] && y_pos[49] == i_vcnt[10:5] && score >= 49) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[50] == i_hcnt[10:5] && y_pos[50] == i_vcnt[10:5] && score >= 50) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[51] == i_hcnt[10:5] && y_pos[51] == i_vcnt[10:5] && score >= 51) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[52] == i_hcnt[10:5] && y_pos[52] == i_vcnt[10:5] && score >= 52) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[53] == i_hcnt[10:5] && y_pos[53] == i_vcnt[10:5] && score >= 53) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[54] == i_hcnt[10:5] && y_pos[54] == i_vcnt[10:5] && score >= 54) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[55] == i_hcnt[10:5] && y_pos[55] == i_vcnt[10:5] && score >= 55) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[56] == i_hcnt[10:5] && y_pos[56] == i_vcnt[10:5] && score >= 56) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[57] == i_hcnt[10:5] && y_pos[57] == i_vcnt[10:5] && score >= 57) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[58] == i_hcnt[10:5] && y_pos[58] == i_vcnt[10:5] && score >= 58) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[59] == i_hcnt[10:5] && y_pos[59] == i_vcnt[10:5] && score >= 59) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[60] == i_hcnt[10:5] && y_pos[60] == i_vcnt[10:5] && score >= 60) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[61] == i_hcnt[10:5] && y_pos[61] == i_vcnt[10:5] && score >= 61) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[62] == i_hcnt[10:5] && y_pos[62] == i_vcnt[10:5] && score >= 62) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[63] == i_hcnt[10:5] && y_pos[63] == i_vcnt[10:5] && score >= 63) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[64] == i_hcnt[10:5] && y_pos[64] == i_vcnt[10:5] && score >= 64) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[65] == i_hcnt[10:5] && y_pos[65] == i_vcnt[10:5] && score >= 65) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[66] == i_hcnt[10:5] && y_pos[66] == i_vcnt[10:5] && score >= 66) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[67] == i_hcnt[10:5] && y_pos[67] == i_vcnt[10:5] && score >= 67) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[68] == i_hcnt[10:5] && y_pos[68] == i_vcnt[10:5] && score >= 68) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[69] == i_hcnt[10:5] && y_pos[69] == i_vcnt[10:5] && score >= 69) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[70] == i_hcnt[10:5] && y_pos[70] == i_vcnt[10:5] && score >= 70) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[71] == i_hcnt[10:5] && y_pos[71] == i_vcnt[10:5] && score >= 71) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[72] == i_hcnt[10:5] && y_pos[72] == i_vcnt[10:5] && score >= 72) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[73] == i_hcnt[10:5] && y_pos[73] == i_vcnt[10:5] && score >= 73) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[74] == i_hcnt[10:5] && y_pos[74] == i_vcnt[10:5] && score >= 74) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[75] == i_hcnt[10:5] && y_pos[75] == i_vcnt[10:5] && score >= 75) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[76] == i_hcnt[10:5] && y_pos[76] == i_vcnt[10:5] && score >= 76) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[77] == i_hcnt[10:5] && y_pos[77] == i_vcnt[10:5] && score >= 77) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[78] == i_hcnt[10:5] && y_pos[78] == i_vcnt[10:5] && score >= 78) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[79] == i_hcnt[10:5] && y_pos[79] == i_vcnt[10:5] && score >= 79) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[80] == i_hcnt[10:5] && y_pos[80] == i_vcnt[10:5] && score >= 80) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[81] == i_hcnt[10:5] && y_pos[81] == i_vcnt[10:5] && score >= 81) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[82] == i_hcnt[10:5] && y_pos[82] == i_vcnt[10:5] && score >= 82) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[83] == i_hcnt[10:5] && y_pos[83] == i_vcnt[10:5] && score >= 83) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[84] == i_hcnt[10:5] && y_pos[84] == i_vcnt[10:5] && score >= 84) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[85] == i_hcnt[10:5] && y_pos[85] == i_vcnt[10:5] && score >= 85) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[86] == i_hcnt[10:5] && y_pos[86] == i_vcnt[10:5] && score >= 86) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[87] == i_hcnt[10:5] && y_pos[87] == i_vcnt[10:5] && score >= 87) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[88] == i_hcnt[10:5] && y_pos[88] == i_vcnt[10:5] && score >= 88) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[89] == i_hcnt[10:5] && y_pos[89] == i_vcnt[10:5] && score >= 89) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[90] == i_hcnt[10:5] && y_pos[90] == i_vcnt[10:5] && score >= 90) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[91] == i_hcnt[10:5] && y_pos[91] == i_vcnt[10:5] && score >= 91) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[92] == i_hcnt[10:5] && y_pos[92] == i_vcnt[10:5] && score >= 92) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[93] == i_hcnt[10:5] && y_pos[93] == i_vcnt[10:5] && score >= 93) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[94] == i_hcnt[10:5] && y_pos[94] == i_vcnt[10:5] && score >= 94) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[95] == i_hcnt[10:5] && y_pos[95] == i_vcnt[10:5] && score >= 95) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[96] == i_hcnt[10:5] && y_pos[96] == i_vcnt[10:5] && score >= 96) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[97] == i_hcnt[10:5] && y_pos[97] == i_vcnt[10:5] && score >= 97) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[98] == i_hcnt[10:5] && y_pos[98] == i_vcnt[10:5] && score >= 98) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[99] == i_hcnt[10:5] && y_pos[99] == i_vcnt[10:5] && score >= 99) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[100] == i_hcnt[10:5] && y_pos[100] == i_vcnt[10:5] && score >= 100) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[101] == i_hcnt[10:5] && y_pos[101] == i_vcnt[10:5] && score >= 101) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[102] == i_hcnt[10:5] && y_pos[102] == i_vcnt[10:5] && score >= 102) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[103] == i_hcnt[10:5] && y_pos[103] == i_vcnt[10:5] && score >= 103) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[104] == i_hcnt[10:5] && y_pos[104] == i_vcnt[10:5] && score >= 104) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[105] == i_hcnt[10:5] && y_pos[105] == i_vcnt[10:5] && score >= 105) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[106] == i_hcnt[10:5] && y_pos[106] == i_vcnt[10:5] && score >= 106) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[107] == i_hcnt[10:5] && y_pos[107] == i_vcnt[10:5] && score >= 107) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[108] == i_hcnt[10:5] && y_pos[108] == i_vcnt[10:5] && score >= 108) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[109] == i_hcnt[10:5] && y_pos[109] == i_vcnt[10:5] && score >= 109) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[110] == i_hcnt[10:5] && y_pos[110] == i_vcnt[10:5] && score >= 110) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[111] == i_hcnt[10:5] && y_pos[111] == i_vcnt[10:5] && score >= 111) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[112] == i_hcnt[10:5] && y_pos[112] == i_vcnt[10:5] && score >= 112) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[113] == i_hcnt[10:5] && y_pos[113] == i_vcnt[10:5] && score >= 113) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[114] == i_hcnt[10:5] && y_pos[114] == i_vcnt[10:5] && score >= 114) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[115] == i_hcnt[10:5] && y_pos[115] == i_vcnt[10:5] && score >= 115) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[116] == i_hcnt[10:5] && y_pos[116] == i_vcnt[10:5] && score >= 116) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[117] == i_hcnt[10:5] && y_pos[117] == i_vcnt[10:5] && score >= 117) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[118] == i_hcnt[10:5] && y_pos[118] == i_vcnt[10:5] && score >= 118) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[119] == i_hcnt[10:5] && y_pos[119] == i_vcnt[10:5] && score >= 119) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[120] == i_hcnt[10:5] && y_pos[120] == i_vcnt[10:5] && score >= 120) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[121] == i_hcnt[10:5] && y_pos[121] == i_vcnt[10:5] && score >= 121) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[122] == i_hcnt[10:5] && y_pos[122] == i_vcnt[10:5] && score >= 122) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[123] == i_hcnt[10:5] && y_pos[123] == i_vcnt[10:5] && score >= 123) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[124] == i_hcnt[10:5] && y_pos[124] == i_vcnt[10:5] && score >= 124) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[125] == i_hcnt[10:5] && y_pos[125] == i_vcnt[10:5] && score >= 125) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[126] == i_hcnt[10:5] && y_pos[126] == i_vcnt[10:5] && score >= 126) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[127] == i_hcnt[10:5] && y_pos[127] == i_vcnt[10:5] && score >= 127) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[128] == i_hcnt[10:5] && y_pos[128] == i_vcnt[10:5] && score >= 128) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[129] == i_hcnt[10:5] && y_pos[129] == i_vcnt[10:5] && score >= 129) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[130] == i_hcnt[10:5] && y_pos[130] == i_vcnt[10:5] && score >= 130) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[131] == i_hcnt[10:5] && y_pos[131] == i_vcnt[10:5] && score >= 131) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[132] == i_hcnt[10:5] && y_pos[132] == i_vcnt[10:5] && score >= 132) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[133] == i_hcnt[10:5] && y_pos[133] == i_vcnt[10:5] && score >= 133) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[134] == i_hcnt[10:5] && y_pos[134] == i_vcnt[10:5] && score >= 134) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[135] == i_hcnt[10:5] && y_pos[135] == i_vcnt[10:5] && score >= 135) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[136] == i_hcnt[10:5] && y_pos[136] == i_vcnt[10:5] && score >= 136) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[137] == i_hcnt[10:5] && y_pos[137] == i_vcnt[10:5] && score >= 137) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[138] == i_hcnt[10:5] && y_pos[138] == i_vcnt[10:5] && score >= 138) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[139] == i_hcnt[10:5] && y_pos[139] == i_vcnt[10:5] && score >= 139) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[140] == i_hcnt[10:5] && y_pos[140] == i_vcnt[10:5] && score >= 140) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[141] == i_hcnt[10:5] && y_pos[141] == i_vcnt[10:5] && score >= 141) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[142] == i_hcnt[10:5] && y_pos[142] == i_vcnt[10:5] && score >= 142) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[143] == i_hcnt[10:5] && y_pos[143] == i_vcnt[10:5] && score >= 143) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[144] == i_hcnt[10:5] && y_pos[144] == i_vcnt[10:5] && score >= 144) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[145] == i_hcnt[10:5] && y_pos[145] == i_vcnt[10:5] && score >= 145) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[146] == i_hcnt[10:5] && y_pos[146] == i_vcnt[10:5] && score >= 146) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[147] == i_hcnt[10:5] && y_pos[147] == i_vcnt[10:5] && score >= 147) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[148] == i_hcnt[10:5] && y_pos[148] == i_vcnt[10:5] && score >= 148) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[149] == i_hcnt[10:5] && y_pos[149] == i_vcnt[10:5] && score >= 149) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[150] == i_hcnt[10:5] && y_pos[150] == i_vcnt[10:5] && score >= 150) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[151] == i_hcnt[10:5] && y_pos[151] == i_vcnt[10:5] && score >= 151) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[152] == i_hcnt[10:5] && y_pos[152] == i_vcnt[10:5] && score >= 152) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[153] == i_hcnt[10:5] && y_pos[153] == i_vcnt[10:5] && score >= 153) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[154] == i_hcnt[10:5] && y_pos[154] == i_vcnt[10:5] && score >= 154) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[155] == i_hcnt[10:5] && y_pos[155] == i_vcnt[10:5] && score >= 155) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[156] == i_hcnt[10:5] && y_pos[156] == i_vcnt[10:5] && score >= 156) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[157] == i_hcnt[10:5] && y_pos[157] == i_vcnt[10:5] && score >= 157) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[158] == i_hcnt[10:5] && y_pos[158] == i_vcnt[10:5] && score >= 158) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[159] == i_hcnt[10:5] && y_pos[159] == i_vcnt[10:5] && score >= 159) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[160] == i_hcnt[10:5] && y_pos[160] == i_vcnt[10:5] && score >= 160) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[161] == i_hcnt[10:5] && y_pos[161] == i_vcnt[10:5] && score >= 161) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[162] == i_hcnt[10:5] && y_pos[162] == i_vcnt[10:5] && score >= 162) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[163] == i_hcnt[10:5] && y_pos[163] == i_vcnt[10:5] && score >= 163) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[164] == i_hcnt[10:5] && y_pos[164] == i_vcnt[10:5] && score >= 164) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[165] == i_hcnt[10:5] && y_pos[165] == i_vcnt[10:5] && score >= 165) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[166] == i_hcnt[10:5] && y_pos[166] == i_vcnt[10:5] && score >= 166) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[167] == i_hcnt[10:5] && y_pos[167] == i_vcnt[10:5] && score >= 167) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos[168] == i_hcnt[10:5] && y_pos[168] == i_vcnt[10:5] && score >= 168) begin
			 o_r <= r_s;
			 o_g <= g_s;
			 o_b <= b_s;
		end else if(x_pos_a == i_hcnt[10:5] && y_pos_a == i_vcnt[10:5]) begin //Finally check if its the apple's time to get drawn.
			o_r <= r_a;
			o_g <= g_a;
			o_b <= b_a;
		end else if(i_hcnt[10:5] == 6'd18 && i_vcnt[10:5] == 6'd2) begin
			o_r <= r_c_0;
			o_g <= g_c_0;
			o_b <= b_c_0;
		end else if(i_hcnt[10:5] == 6'd17 && i_vcnt[10:5] == 6'd2) begin
			o_r <= r_c_1;
			o_g <= g_c_1;
			o_b <= b_c_1;
		end else if(i_hcnt[10:5] == 6'd16 && i_vcnt[10:5] == 6'd2) begin
			o_r <= r_c_2;
			o_g <= g_c_2;
			o_b <= b_c_2;
		end else begin // if there is nothing to draw return black color.
			o_r <= 8'b0;
			o_g <= 8'b0;
			o_b <= 8'b0;
		end
	end


endmodule
