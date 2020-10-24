`timescale 1ns/1ps
/******************************************************************************
 * (C) Copyright 2013 <Company Name> All Rights Reserved
 *
 * MODULE:    name
 * DEVICE:
 * PROJECT:
 * AUTHOR:    jkoczwara
 * DATE:      2020 12:23:28 PM
 *
 * ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
 *
 *******************************************************************************/

module controller(
		input wire clk,
		input wire hit_latched,
		input wire [2:0] mode,
		input wire read,
		input wire read_done,
		input wire write_done,
		input wire [5:0] addr,

		output reg cntr_src,
		output reg mem_src,
		output reg reg_src,
		output reg mem_read,
		output reg mem_write,
		output reg hit_reset

	);

	localparam ID = 5'b00000;

	localparam DT_A = 5'b00001;
	localparam DT_B = 5'b00010;
	localparam DT_C = 5'b00011;
	localparam DT_D = 5'b00100;
	localparam DT_E = 5'b00101;
	localparam DT_F = 5'b00110;
	localparam DT_G = 5'b01111;
	localparam DT_H = 5'b10011;
	

	localparam RE_A = 5'b00111;
	localparam RE_B = 5'b01000;
	localparam RE_C = 5'b01001;
	localparam RE_D = 5'b10001;

	localparam RZ_A = 5'b01010;
	localparam RZ_B = 5'b01011;
	localparam RZ_C = 5'b01100;
	localparam RZ_D = 5'b01101;
	localparam RZ_E = 5'b01110;
	localparam RZ_F = 5'b10000;
	localparam RZ_G = 5'b10010;
	

	reg [4:0] state=ID;
	reg [4:0] next;
	
	initial begin
		mem_read=0;
		mem_write=0;
	end
		


	always@(posedge clk)begin
		state<=next;
		
	end

	always@* begin

		case(state)
			ID: begin
				if(mode==3'b001 && hit_latched)
					next=DT_F;
					
				else if(mode==3'b010 && read)
					next=RE_B;

				else if(mode==3'b100 && read)					
					next=RZ_A;
					
				

				else
					next=ID;

				{cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset}        = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0,1'b0};

			end
			
                                                                                               //cnt_src mm_src rg_src mm_rd  mm_wr  ht_rst
			DT_A:begin
				{cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset} =        {1'b1,  1'b1,  1'b0,  1'b0,  1'b0,  1'b0};
				if(mode == 3'b001)					
					if(hit_latched)
						next=DT_B;
					else if(addr==6'h3E)
						next=DT_H;
					else 
						next=DT_A;
						
				else 
					next=ID;								
				end
			DT_B: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b0,  1'b1,  1'b1,  1'b0,  1'b0,  1'b0,   DT_C};
			DT_C: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b0,  1'b1,  1'b1,  1'b1,  1'b0,  1'b0,   DT_D};
			DT_D: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b0,  1'b1,  1'b1,  1'b0,  1'b0,  1'b0,   DT_E};
			DT_E: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b0,  1'b1,  1'b1,  1'b0,  1'b1,  1'b0,   DT_F};
			DT_F: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b0,  1'b1,  1'b1,  1'b0,  1'b0,  1'b0,   DT_G};
			DT_G: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b1,  1'b0,  1'b0,  1'b0,  1'b0,  1'b1,   DT_A};
			DT_H:begin
				{  cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset} =         {1'b1,  1'b0,  1'b1,  1'b0,  1'b0,  1'b0};
				if(mode == 3'b001)					
					if(hit_latched)
						next=DT_B;
					else 
						next=DT_H;
						
				else 
					next=ID;								
				end
			          
			
			RE_A:begin                                                                         //cnt_src mm_src rg_src mm_rd  mm_wr  ht_rst				
					{cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset}     = {1'b1,  1'b1,  1'b0,  1'b0,  1'b0,  1'b0};
					if(mode==3'b010 && read)						
						next=RE_B;						
					else
						next=ID;				
					end
				
			RE_B: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b1,  1'b1,  1'b1,  1'b0,  1'b0,  1'b0,   RE_C};
			RE_C: begin
				{cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset        } = {1'b1,  1'b1,  1'b1,  1'b1,  1'b0,  1'b0};
				if(addr==6'h3F)
						next=RE_C;
					else
						next=RE_A;
				end
			
			                                                                                   //cnt_src mm_src rg_src mm_rd  mm_wr  ht_rst
			RZ_A: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b1,  1'b0,  1'b1,  1'b1,  1'b0,  1'b0,  RZ_B };
			RZ_B: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b1,  1'b0,  1'b1,  1'b0,  1'b0,  1'b0,  RZ_C };
			RZ_C: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b1,  1'b0,  1'b1,  1'b0,  1'b1,  1'b0,  RZ_D };
			RZ_D:begin
				{cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset}         = {1'b1,  1'b0,  1'b1,  1'b0,  1'b0,  1'b0};
				if(mode==3'b100 && read)	
					if(addr==6'h3F)
						next=RZ_D;
					else
						next=RZ_E;
				else
					next=ID;
			end
			RZ_E: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b1,  1'b1,  1'b0,  1'b0,  1'b0,  1'b0, RZ_F };
			RZ_F: {cntr_src,   mem_src,    reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b1,  1'b1,  1'b1,  1'b0,  1'b0,  1'b0, RZ_A };
			
			default: {cntr_src,   mem_src, reg_src,    mem_read,   mem_write,  hit_reset, next} = {1'b1,  1'b0,  1'b0,  1'b0,  1'b0,  1'b0, ID};			
			
		endcase
		
	end









endmodule
