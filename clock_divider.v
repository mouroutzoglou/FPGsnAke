`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:54 10/18/2017 
// Design Name: 
// Module Name:    clock_divider 
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
module clock_divider(
    input i_clk_74M,
    output reg o_clk_32hz
    );
	 
	initial o_clk_32hz <= 0;
	 
	reg [20:0] cnt;
	
	always @ (i_clk_74M) begin
		if(cnt == 1160156) cnt <= 0;
		else cnt <= cnt + 1;
	end
	
	always @ (cnt) begin
		if(cnt == 1160156) o_clk_32hz <= ~o_clk_32hz;
		else o_clk_32hz <= o_clk_32hz;
	end
endmodule