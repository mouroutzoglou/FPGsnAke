`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:46:35 11/05/2017 
// Design Name: 
// Module Name:    six_bit_register 
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
module six_bit_register(
    input [5:0] in,
    output reg [5:0] out,
    input clk,
    input reset
    );
	 
	parameter [5:0] init = 6'b0;
	initial out <= init;
	 
	always @ (posedge clk)
	begin
		if(reset == 1'b1) out <= init;
		else out <= in;
	end


endmodule
