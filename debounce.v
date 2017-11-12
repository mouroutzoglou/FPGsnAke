`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:16:59 10/16/2017 
// Design Name: 
// Module Name:    debounce 
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
module debounce(
    input clk,
    input d,
    output qp,	 	 //1 for one cycle after d becomes 1 (stable)
    output qr, 	 //1 for one cycle after d becomes 0 (stable)
    output qs //1 as long as d is 1(stable)
    );
	 
	reg rqs = 1; //inverse of the debounced output
	assign qs = ~rqs; //qs is the debounced output
	 
	reg d_sync_0; 
	reg d_sync_1;  
	
	always @(posedge clk) 
		d_sync_0 <= ~d; //remember the inverse value of the input for the next cycle
	
	always @(posedge clk) 
		d_sync_1 <= d_sync_0; //remember the inverse value of the input for the next 2 cycles
	
	reg [15:0] d_cnt = 0; //counts the number of cycles the input stayed stabilised on one value
	
	wire d_idle = (rqs==d_sync_1); //if the button is not pressed the d_sync_1 which is the inverse of the button is 1 and rqs is 1 as well so we are idle
	wire d_cnt_max = &d_cnt;	//flag that is equal to 1 when all the cnt bits are 1.
	
	always @(posedge clk) 
		if(d_idle) //if we are idle that means that the button is not pressed
			 d_cnt <= 0; //so we reset the counter back to 0
		else
		begin
			 d_cnt <= d_cnt + 16'd1; //else if are not idle increase the counter by one
			 if(d_cnt_max) rqs <= ~rqs; //and if the counter has maxed out then we flip the rqs value so that the system can be idle again.
		end

	assign qr = ~d_idle & d_cnt_max & ~rqs; //if we are not idle and we count to max number of cycles and the debounced output is 0 the we just released the button (active for one cycle)
	assign qp = ~d_idle & d_cnt_max &  rqs; //if we are not idle and we count to max number of cycles and the debounced output is 1 the we just pressed the button (active for one cycle)


endmodule
