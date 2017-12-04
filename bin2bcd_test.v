`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:27:31 11/30/2017
// Design Name:   bin2bcd
// Module Name:   C:/Users/Maiko.Our/Documents/GitHub/FPGsnAke/bin2bcd_test.v
// Project Name:  hdmi_demo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bin2bcd
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bin2bcd_test;

	// Inputs
	reg [7:0] A;

	// Outputs
	wire [3:0] ONES;
	wire [3:0] TENS;
	wire [1:0] HUNDRENDS;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	bin2bcd uut (
		.A(A), 
		.ONES(ONES), 
		.TENS(TENS), 
		.HUNDRENDS(HUNDRENDS)
	);

	initial begin
		// Initialize Inputs
		A = 0;

		// Wait 100 ns for global reset to finish
		#10;
		
		for (i=0; i<65536; i=i+1) begin
			A = i[7:0];
			#1;
		end
        
		// Add stimulus here

	end
      
endmodule

