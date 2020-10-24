`timescale 1ns/1ps
/******************************************************************************
* (C) Copyright 2013 <Company Name> All Rights Reserved
*
* MODULE:    name
* DEVICE:
* PROJECT:
* AUTHOR:    jkoczwara
* DATE:      2020 12:00:58 PM
*
* ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
*
*******************************************************************************/

module clk(
	output reg clk
	);
	
	always
	begin
		clk=1'b0;
		#5;
		clk=1'b1;
		#5;

	end
	
	
	
endmodule
