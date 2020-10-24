`timescale 1ns/1ps
/******************************************************************************
* (C) Copyright 2013 <Company Name> All Rights Reserved
*
* MODULE:    name
* DEVICE:
* PROJECT:
* AUTHOR:    jkoczwara
* DATE:      2020 10:22:53 PM
*
* ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
*
*******************************************************************************/

module register(
	
	input wire [11:0] d,
	input wire clk,
	
	output reg [11:0] q
	
	
	);
	
	always @ (posedge clk) begin
		
		q<=d;
		
	end
	
endmodule
