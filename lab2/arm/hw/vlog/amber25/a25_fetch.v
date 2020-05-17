//////////////////////////////////////////////////////////////////
//                                                              //
//  Fetch - Instantiates the fetch stage sub-modules of         //
//  the Amber 25 Core                                           //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Instantiates the Cache and Wishbone I/F                     //
//  Also contains a little bit of logic to decode memory        //
//  accesses to decide if they are cached or not                //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//                                                              //
//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (C) 2011 Authors and OPENCORES.ORG                 //
//                                                              //
// This source file may be used and distributed without         //
// restriction provided that this copyright statement is not    //
// removed from the file and that any derivative work contains  //
// the original copyright notice and the associated disclaimer. //
//                                                              //
// This source file is free software; you can redistribute it   //
// and/or modify it under the terms of the GNU Lesser General   //
// Public License as published by the Free Software Foundation; //
// either version 2.1 of the License, or (at your option) any   //
// later version.                                               //
//                                                              //
// This source is distributed in the hope that it will be       //
// useful, but WITHOUT ANY WARRANTY; without even the implied   //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      //
// PURPOSE.  See the GNU Lesser General Public License for more //
// details.                                                     //
//                                                              //
// You should have received a copy of the GNU Lesser General    //
// Public License along with this source; if not, download it   //
// from http://www.opencores.org/lgpl.shtml                     //
//                                                              //
//////////////////////////////////////////////////////////////////


module a25_fetch
(
input                       quick_n_reset,
input                       i_clk,
input                       i_mem_stall,
input                       i_conflict,         // Decode stage stall pipeline because of an instruction conflict
output                      o_fetch_stall,      // when this is asserted all registers 
                                                // in decode and exec stages are frozen
input                       i_system_rdy,       // External system can stall core with this signal

input       [31:0]          i_iaddress,
input                       i_iaddress_valid,
input       [31:0]          i_iaddress_nxt,     // un-registered version of address to the cache rams
output      [31:0]          o_fetch_instruction,

input                       i_cache_enable,     // cache enable
input                       i_cache_flush,      // cache flush
input       [31:0]          i_cacheable_area,   // each bit corresponds to 2MB address space

output                      o_wb_req,
output                      o_wb_qword,         // High for a quad-word fetch request
output      [31:0]          o_wb_address,
input       [31:0]          i_wb_read_data,
input                       i_wb_ready

);

`include "memory_configuration.v"

wire                        core_stall;
wire                        cache_stall;
wire    [31:0]              cache_read_data;
wire                        sel_cache;
wire                        uncached_instruction_read;
wire                        address_cachable;
wire                        icache_wb_req;
wire                        wait_wb;
reg                         wb_req_r;

// ======================================
// Memory Decode
// ======================================
assign address_cachable  = in_cachable_mem( i_iaddress ) && i_cacheable_area[i_iaddress[25:21]];

assign sel_cache         = address_cachable && i_iaddress_valid && i_cache_enable;

// Don't start wishbone transfers when the cache is stalling the core
// The cache stalls the core during its initialization sequence
assign uncached_instruction_read = !sel_cache && i_iaddress_valid && !(cache_stall);

// Return read data either from the wishbone bus or the cache
assign o_fetch_instruction = sel_cache                  ? cache_read_data : 
                             uncached_instruction_read  ? i_wb_read_data  :
                                                          32'hffeeddcc    ;

// Stall the instruction decode and execute stages of the core
// when the fetch stage needs more than 1 cycle to return the requested
// read data
assign o_fetch_stall    = !i_system_rdy || wait_wb || cache_stall;

assign o_wb_address     = i_iaddress;
assign o_wb_req         = icache_wb_req || uncached_instruction_read;
assign o_wb_qword       = icache_wb_req;

assign wait_wb          = (o_wb_req || wb_req_r) && !i_wb_ready;

always @(posedge i_clk or negedge quick_n_reset)
    if (!quick_n_reset)
	begin
		wb_req_r <= 'd0;
	end
    else
    wb_req_r <= o_wb_req && !i_wb_ready;

assign core_stall = o_fetch_stall || i_mem_stall || i_conflict;

// ======================================
// L1 Instruction Cache
// ======================================
a25_icache u_cache (
    .i_clk                      ( i_clk                 ),
    .i_core_stall               ( core_stall            ),
    .o_stall                    ( cache_stall           ),
    
    .i_select                   ( sel_cache             ),
    .i_address                  ( i_iaddress            ),
    .i_address_nxt              ( i_iaddress_nxt        ),
    .i_cache_enable             ( i_cache_enable        ),
    .i_cache_flush              ( i_cache_flush         ),
    .o_read_data                ( cache_read_data       ),
    
    .o_wb_req                   ( icache_wb_req         ),
    .i_wb_read_data             ( i_wb_read_data        ),
    .i_wb_ready                 ( i_wb_ready            )
);


endmodule

