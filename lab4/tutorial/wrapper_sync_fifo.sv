module fifo_verif 
#(	parameter FIFO_DEPTH = 2, 
	parameter DATA_WIDTH = 8
)
(
    input clock,
    input reset,
    input wr,
    input rd,
    input [DATA_WIDTH-1:0] din,
    input empty,
    input full,
    input [DATA_WIDTH-1:0] dout
);
 
wire db_wr, db_rd;
reg dffw1, dffw2, dffr1, dffr2;

always @ (posedge clock) dffw1 <= wr; 
always @ (posedge clock) dffw2 <= dffw1;
assign db_wr = ~dffw1 & dffw2; 

always @ (posedge clock) dffr1 <= rd;
always @ (posedge clock) dffr2 <= dffr1;
assign db_rd = ~dffr1 & dffr2; 

wire wr_en = db_wr; 
wire rd_en = db_rd; 


//aux code for if all spots in fifo are used
reg [FIFO_DEPTH-1:0] wr_ptr, rd_ptr;
reg [2**FIFO_DEPTH-1: 0] used_tag;
always @ (posedge clock or posedge reset) begin
	if(reset) begin
		rd_ptr <= 0;
		wr_ptr <= 0;
	end
	else begin
		case({rd_en, wr_en})
			2'b00: begin
				rd_ptr <= rd_ptr;
				wr_ptr <= wr_ptr;
			end
			2'b01: begin
				wr_ptr <= wr_ptr + (full ? 1'b0 : 1'b1);
				rd_ptr <= rd_ptr;
			end
			2'b10: begin
				rd_ptr <= rd_ptr + (empty ? 1'b0 : 1'b1);
				wr_ptr <= wr_ptr;
			end
			2'b11: begin
	  	  		wr_ptr <= wr_ptr + 1'b1;
				rd_ptr <= rd_ptr + 1'b1;
			end
		endcase
	end
end

always @ (posedge clock or posedge reset) begin
	if (reset) begin
		used_tag <= 0;
	end
	else begin
		case ({rd_en, wr_en}) 
			2'b00: begin
				used_tag <= used_tag;
			end
			2'b01: begin
				used_tag[wr_ptr] <= (full ? used_tag[wr_ptr] : 1'b1);
			end
			2'b10: begin
				used_tag[rd_ptr] <= (empty ? used_tag[rd_ptr] : 1'b0);
			end
			2'b11: begin
				if(wr_ptr == rd_ptr)
					used_tag <= used_tag;
				else begin
					used_tag[wr_ptr] <= 1'b1;
					used_tag[rd_ptr] <= 1'b0;
				end
			end
		endcase

	end
end

ck_empty_correctness: assert property (@(posedge clock) $countones(used_tag) == 0 |->  empty);
cl_full_correctness: assert property (@(posedge clock) $countones(used_tag) == (2**FIFO_DEPTH) |-> full);

 
ck_empty_to_full: cover property (@(posedge clock) empty ##[1:$] full );
ck_full_to_empty: cover property (@(posedge clock) full  ##[1:$] empty);


genvar i;
for (i=0; i<2**FIFO_DEPTH; i++) begin
	ck_all_used: cover property ( $countones(used_tag) == i);
end

//aux code for how many wr and rd operations
reg [FIFO_DEPTH: 0] pop_cnt, push_cnt;
always @(posedge clock) begin
	if(reset) begin
		pop_cnt <= 0;
		push_cnt <= 0;
	end
	else begin
		if(rd_en) pop_cnt <= pop_cnt + 1'b1;
		if(wr_en) push_cnt <= push_cnt + 1'b1;
	end
end

genvar j;
for (j=0; j< (2**FIFO_DEPTH + 3); j++) begin
	ck_wr_num: cover property ( push_cnt == j);
	ck_rd_num: cover property ( pop_cnt == j);
end

endmodule

module wrapper;
bind sync_fifo fifo_verif
#(
	.FIFO_DEPTH(abits), 
	.DATA_WIDTH(dbits)
)
fifo_verif_inst(
    .clock(clock),
    .reset(reset),
    .wr(wr),
    .rd(rd),
    .din(din),
    .empty(empty),
    .full(full),
    .dout(dout)
);

endmodule

