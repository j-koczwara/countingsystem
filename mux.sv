`timescale 1ns/1ps
/******************************************************************************
* (C) Copyright 2013 <Company Name> All Rights Reserved
*
* MODULE:    name
* DEVICE:
* PROJECT:
* AUTHOR:    jkoczwara
* DATE:      2020 9:51:39 PM
*
* ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
*
*******************************************************************************/

module mux (
	input wire [11:0] a,
	input wire [11:0] b,
	input wire sel,
	
	output reg [11:0]  c
	
	);
	
	always @ (a or b or sel) begin
		case(sel)
			1'b0 : c = a;
			1'b1 : c = b;
		endcase
	end
		
endmodule
