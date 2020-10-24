/******************************************************************************
* (C) Copyright 2013 <Company Name> All Rights Reserved
*
* MODULE:    name
* DEVICE:
* PROJECT:
* AUTHOR:    jkoczwara
* DATE:      2020 9:10:01 PM
*
* ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
*
*******************************************************************************/

module top(
	input  wire VDD,
	input  wire VSS,
	input wire hit,
	input wire [2:0] mode,
	input wire read,
	input wire clk
	);
	

wire hit_latched;
wire read_done;
wire write_done;
wire data_src;
wire cntr_src;
wire mem_src;
wire reg_src;
wire mem_read;
wire mem_write;
wire hit_reset;
	
parameter ADDR_BITS=6;
parameter DATA_BITS=12;
parameter MEM_SIZE=64;

wire [11:0] q_addr;
wire [ADDR_BITS-1:0] addr;
wire [DATA_BITS-1:0] din;
wire [DATA_BITS-1:0] dout;

assign addr=q_addr[5:0];

controller u_controller (
	.clk        (clk),
	.addr       (addr),
	.cntr_src   (cntr_src),
	.hit_latched(hit_latched),
	.hit_reset  (hit_reset),
	.mem_read   (mem_read),
	.mem_src    (mem_src),
	.mem_write  (mem_write),
	.mode       (mode),
	.read       (read),
	.read_done  (read_done),
	.reg_src    (reg_src),
	.write_done (write_done)
	);
	

register_rst u_register_rst (
	.clk(hit),
	.d  (1'b1),
	.q  (hit_latched),
	.rst(hit_reset)
);
	
sram_64x12f #(
	.ADDR_BITS(ADDR_BITS),
	.DATA_BITS(DATA_BITS),
	.MEM_SIZE (MEM_SIZE)
)
u_sram_64x12f (
	.VDD       (VDD),
	.VSS       (VSS),
	.addr      (addr),
	.din       (din),
	.dout      (dout),
	.read      (mem_read), //active high
	.read_done (read_done),
	.write     (mem_write), //active high
	.write_done(write_done)
);



wire [11:0] dout_latched;

register_neg u_register_dout (
	.clk(mem_read),
	.d  (dout),
	.q  (dout_latched)
);
	


wire [11:0] c_cntr;


mux u_mux_cntr (
	.a  (dout_latched), 
	.b  (q_addr),
	.c  (c_cntr),
	.sel(cntr_src)
	);
	

wire [11:0] q_inc;

increment u_increment (
	.d(c_cntr),
	.q(q_inc)
);



mux u_mux_mem (
	.a  (12'b0),
	.b  (q_inc),
	.c  (din),
	.sel(mem_src)
);

wire [11:0] c_reg;

mux u_mux_reg (
	.a  (din), 
	.b  (q_addr),
	.c  (c_reg),
	.sel(reg_src)
);



register u_register_addr (
	.clk(clk),
	.d  (c_reg),
	.q  (q_addr)
);


endmodule
