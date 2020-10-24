/******************************************************************************
* (C) Copyright 2013 <Company Name> All Rights Reserved
*
* MODULE:    name
* DEVICE:
* PROJECT:
* AUTHOR:    jkoczwara
* DATE:      2020 11:22:58 PM
*
* ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
*
*******************************************************************************/

module increment(
	
	input wire [11:0] d,
	
	output reg [11:0] q
	
	
	);
	assign q = d + 1;
endmodule
