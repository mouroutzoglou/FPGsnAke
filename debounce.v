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
    output qp,	 	 //1 for one cycle after d becomes 1 (in terms of stabilization)
    output qr, 	 //1 for one cycle after d becomes 0
    output qs //1 as long as d is 1
    );
	 
	reg rqs = 1;
	assign qs = ~rqs;
	 
	reg d_sync_0; 
	reg d_sync_1;  
	
	always @(posedge clk) 
		d_sync_0 <= ~d;
	
	always @(posedge clk) 
		d_sync_1 <= d_sync_0;
	
	reg [15:0] d_cnt = 0;
	
	wire d_idle = (rqs==d_sync_1);
	wire d_cnt_max = &d_cnt;	
	
	always @(posedge clk)
		if(d_idle)
			 d_cnt <= 0;
		else
		begin
			 d_cnt <= d_cnt + 16'd1;
			 if(d_cnt_max) rqs <= ~rqs;
		end

	assign qr = ~d_idle & d_cnt_max & ~rqs;
	assign qp = ~d_idle & d_cnt_max &  rqs;


endmodule
