`timescale 1ns/1ps
/******************************************************************************
 * (C) Copyright 2013 <Company Name> All Rights Reserved
 *
 * MODULE:    name
 * DEVICE:
 * PROJECT:
 * AUTHOR:    jkoczwara
 * DATE:      2020 11:41:46 PM
 *
 * ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
 *
 *******************************************************************************/

module counting_system_tb;

	parameter ADDR_BITS=12;
	parameter DATA_BITS=12;
	parameter MEM_SIZE=64;

	wire VDD;
	wire VSS;
	reg hit;
	reg [2:0] mode;
	reg read;
	wire clk;

	clk u_clk (
		.clk(clk)
	);

	top #(
		.ADDR_BITS(ADDR_BITS),
		.DATA_BITS(DATA_BITS),
		.MEM_SIZE (MEM_SIZE)
	)
	u_top (
		.VDD (VDD),
		.VSS (VSS),
		.hit (hit),
		.mode(mode),
		.read(read),
		.clk(clk)
	);



	initial
	begin
		mode=3'b000;
		hit=1'b0;
		
		//READZ
		#50
		mode=3'b100;
		#15
		read=1'b1;
		#9000;
		mode=3'b000;

		//DATA_TAKING

		mode=3'b001;
		#80
		hit=1'b1;
		#5;
		hit=1'b0;
		#240
		#1040
		hit=1'b1;
		#5;
		hit=1'b0;
		#5;
		#240

		hit=1'b1;
		#5;
		hit=1'b0;
		#800
		mode=3'b000;
		#50


//READ

		mode=3'b010;
		#10;
		read=1'b1;
		#800;
		
		
	end


endmodule
