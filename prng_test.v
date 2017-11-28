`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:16:24 11/27/2017
// Design Name:   ten_bit_PRNG
// Module Name:   C:/Users/Maiko.Our/Documents/GitHub/FPGsnAke/prng_test.v
// Project Name:  hdmi_demo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ten_bit_PRNG
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module prng_test;

	// Inputs
	reg clk;

	// Outputs
	wire [15:0] out;
	
	integer i;

	// Instantiate the Unit Under Test (UUT)
	PRNG uut (
		.clk(clk), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		for (i=0; i<65536; i=i+1) begin
			clk = 1;
			#1;

			clk = 0;
			#1;
		end
        
		// Add stimulus here

	end
      
endmodule

