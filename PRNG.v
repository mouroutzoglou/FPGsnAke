`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:08:02 11/27/2017 
// Design Name: 
// Module Name:    ten_bit_PRNG 
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
module PRNG(
    input clk,
    output reg [15:0] out
    );

	initial out = 16'b0;

	always @ (posedge clk) begin
		out[0] <= ~(out[15] ^ out[14] ^ out[12] ^ out[3]);
		out[1] <= out[0];
		out[2] <= out[1];
		out[3] <= out[2];
		out[4] <= out[3];
		out[5] <= out[4];
		out[6] <= out[5];
		out[7] <= out[6];
		out[8] <= out[7];
		out[9] <= out[8];
		out[10] <= out[9];
		out[11] <= out[10];
		out[12] <= out[11];
		out[13] <= out[12];
		out[14] <= out[13];
		out[15] <= out[14];
	end

endmodule
