module test(input o_wb_stb, o_wb_cyc, o_wb_dat, o_wb_adr,i_wb_ack,i_wb_dat,o_wb_we, i_clk, quick_n_reset);

sequence s1;
o_wb_stb || (~o_wb_stb);
endsequence

sequence s2;
o_wb_cyc || (~o_wb_cyc);
endsequence

sequence pars (a);
a || (~a);
endsequence

property p1;
@(posedge i_clk) disable iff (!quick_n_reset) o_wb_stb |-> (~$isunknown(o_wb_adr));
endproperty

property p2;
@(posedge i_clk) disable iff (!quick_n_reset) o_wb_stb |-> (~$isunknown(o_wb_dat));
endproperty

property p3;
@(posedge i_clk) disable iff (!quick_n_reset) i_wb_ack |-> (~$isunknown(i_wb_dat));
endproperty

property parp (a,b);
@(posedge i_clk) disable iff (!quick_n_reset) a |-> (~$isunknown(b));
endpropery



property pread;
@(posedge i_clk) disable iff (!quick_n_reset) $rose(o_wb_cyc&o_wb_stb&o_wb_we)|=> i_wb_ack;
endproperty

property pwrite;
@(posedge i_clk) disable iff (!quick_n_reset) $rose(o_wb_cyc&o_wb_stb&(~o_wb_we))|=> i_wb_ack;
endproperty

assert property(parp(o_wb_stb,o_wb_adr)); 
assert property(parp(o_wb_stb,o_wb_dat)); 
assert property(parp(i_wb_ack,i_wb_dat)); 
assert property(pread);
assert property(pwrite);
endmodule

