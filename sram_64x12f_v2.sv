`timescale 1ns/1ps
/* MODULE: ram
 * Author: Robert Szczygiel
 * Description: This is a simplified model of the ram to be used for a pixel
 * project. Features:
 *   - single ported RAM
 *   - only one action read or write at a time (simultaneous read and write
 *   causes simulation error);
 *   - idle time between actions required (set to 8ns in the model)
 *   - address should not change when read or write is active
 *   - input data should not change when write is active
 *   - fixed read delay (set to 8ns in the model)
 *   - fixed write delay (set to 8ns in the model)
 *
 * PORTS:
 *   read - active high
 *   write - active high
 *   addr[6:0] - address
 *   din[11:0] - input data
 *   dout[11:0] - output data
 *	 write_done - active high
 *   read_done - active high
 *
 * Note: the dout[11:0] is valid only when read==1 and read_done==1
 */

module sram_64x12f
#(parameter
    ADDR_BITS=6,
    DATA_BITS=12,
    MEM_SIZE =64
)
(
    input  wire                 read,  // active high
    input  wire                 write, // active high
    input  wire [ADDR_BITS-1:0] addr,
    input  wire [DATA_BITS-1:0] din,
    input  wire VDD,
	input  wire VSS,
    output wire [DATA_BITS-1:0] dout,
    output wire read_done,
	output wire write_done
);

`ifndef SYNTHESIS

localparam                 PRECHARGE_MIN_WIDTH = 8;
localparam                 READ_MIN_WIDTH      = 8;
localparam                 WRITE_MIN_WIDTH     = 8;
localparam                 READ_DELAY = 2;
localparam                 WRITE_DELAY = 2;

reg        [DATA_BITS-1:0] mem [MEM_SIZE-1:0];
reg        [DATA_BITS-1:0] dout_int;

time                       read_start;
time                       write_start;
time                       rw_end;

initial begin
    read_start  = 0;
    write_start = 0;
    rw_end      = 0;
    dout_int    = $random;
end

assign dout = dout_int;
assign #READ_DELAY read_done = read;
assign #WRITE_DELAY write_done = write;

// functional operation
always @* begin
    if(read && read_done) dout_int      = mem[addr];
    else dout_int=12'hx;
    if(write) #WRITE_DELAY mem[addr] = din;
end


// error checks
// XXX ram error checks are not fatal in simulation ($finish commented)
always @(din)
    if(write || write_done) begin
        $display("%0t ERROR in RAM: data change when write active.",$time);
        //$finish;
    end

always @(addr)
    if(write || write_done) begin
        $display("%0t ERROR in RAM: addr change when write active.",$time);
        //$finish;
    end

always @(addr)
    if(read || read_done) begin
        $display("%0t ERROR in RAM: addr change when read active.",$time);
        //$finish;
    end

always @(read or write) begin
    if(read && write)begin
        $display("%0t ERROR in RAM: read and write active at the same time.",$time);
        //$finish;
    end
end

always @(posedge read)
    if(read===1'b1) begin
        if( ($time - rw_end) < PRECHARGE_MIN_WIDTH ) begin
            $display("%0t ERROR in RAM: to short prechage time before read (%0tps < %0tps).",$time, $time - rw_end,
                PRECHARGE_MIN_WIDTH);
            //$finish;
        end
        read_start = $time;
    end

always @(posedge write)
    if(write===1'b1) begin
        if( $time - rw_end < PRECHARGE_MIN_WIDTH ) begin
            $display("%0t ERROR in RAM: to short prechage time before write (%0tps < %0tps).",$time, $time - rw_end,
                PRECHARGE_MIN_WIDTH);
            //$finish;
        end
        write_start = $time;
    end

always @(negedge read)
	
    if(read===1'b0 && $time > 0) begin
        if( $time - read_start < READ_MIN_WIDTH ) begin
            $display("%0t ERROR in RAM: to short read pulse (%0tps < %0tps).",$time, $time - read_start, READ_MIN_WIDTH);
            //$finish;
        end
        rw_end = $time;
    end

always @(negedge write)
    if(write===1'b0 && $time > 0) begin
        if( $time - write_start < WRITE_MIN_WIDTH ) begin
            $display("%0t ERROR in RAM: to short write pulse (%0tps < %0tps).",$time, $time - write_start, WRITE_MIN_WIDTH);
            //$finish;
        end
        rw_end = $time;
    end

`endif


endmodule
