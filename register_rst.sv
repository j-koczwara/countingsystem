`timescale 1ns/1ps
/******************************************************************************
* (C) Copyright 2013 <Company Name> All Rights Reserved
*
* MODULE:    name
* DEVICE:
* PROJECT:
* AUTHOR:    jkoczwara
* DATE:      2020 10:55:44 PM
*
* ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
*
*******************************************************************************/

module register_rst(
	
	input wire d,
	input wire rst,
	input wire clk,
	
	output reg q
	
	
	);
	
	always @ (posedge clk or posedge rst) begin
		
		if(rst)
			q<=0;
		else		
			q<=d;
		
	end
	
endmodule
