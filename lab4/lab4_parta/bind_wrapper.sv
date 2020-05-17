//EE382M-Verification of Digital Systems
//Lab 4 - Formal Property Verification
//
//
//Modules - apb_props and Wrapper
//SystemVerilog Properties for the module - arbiter_top

module apb_props(
// APB interface
input        PCLK,
input        PRESETn,
input        PWRITE,
input        PSEL,
input        PENABLE,
input  [7:0] PADDR,
input  [7:0] PWDATA,

input  [7:0] PRDATA,
input        PREADY,
// APB registers
input        APB_BYPASS,
input  [3:0] APB_REQ,
input  [2:0] APB_ARB_TYPE,
// Arbiter ports
input  [3:0] REQ,
input  [3:0] GNT
);


//Write APB interface properties here - assertions, cover properties and assume properties

/*phase transfer assumption*/
a1:assume property (@(posedge PCLK)  disable iff(!PRESETn) (~PSEL)&&(~PENABLE) |=> PSEL&&(~PENABLE));
a2:assume property (@(posedge PCLK)  disable iff(!PRESETn) PSEL&&(!PENABLE) |=> PSEL&&PENABLE);
a3:assume property (@(posedge PCLK)  disable iff(!PRESETn) PSEL&&PENABLE |=> (!PSEL)&&(!PENABLE)); 	

/*PADDR,PWDATA,PWRITE stable and defined*/
a4:assume property (@(posedge PCLK) disable iff(!PRESETn) PSEL |-> ($stable(PADDR))&&($stable(PWDATA))&&($stable(PWRITE))&&(~$isunknown(PADDR))&&(~$isunknown(PWDATA))&&(~$isunknown(PWRITE)));

/*PADDR legal*/
a5:assume property (@(posedge PCLK) disable iff(!PRESETn) PSEL |-> (PADDR == 8'h10) || (PADDR == 8'h14) || (PADDR == 8'h1C));

/*Given PADDR, PWDATA legal*/
a6:assume property (@(posedge PCLK) disable iff(!PRESETn) PSEL&&(PADDR == 8'h10)|-> ((PWDATA ==8'h00)||(PWDATA == 8'h01)));
a7:assume property (@(posedge PCLK) disable iff(!PRESETn) PSEL&&(PADDR == 8'h14)|-> (PWDATA <= 8'h0F)&&(PWDATA >= 8'h00));
a8:assume property (@(posedge PCLK) disable iff(!PRESETn) PSEL&&(PADDR == 8'h1C)|-> (PWDATA <= 8'h07)&&(PWDATA >= 8'h00));

/*APB write operation*/
a9:assert property  (@(posedge PCLK) disable iff(!PRESETn) (($past(PWRITE,1) == 1)&&(PREADY == 0)&&($past(PREADY,1)==1)&&($past(PADDR,1) == 8'h10)) |-> APB_BYPASS == $past(PWDATA,1));
a10:assert property (@(posedge PCLK) disable iff(!PRESETn) (($past(PWRITE,1) == 1)&&(PREADY == 0)&&($past(PREADY,1)==1)&&($past(PADDR,1) == 8'h14)) |-> APB_REQ == $past(PWDATA,1));
a11:assert property (@(posedge PCLK) disable iff(!PRESETn) (($past(PWRITE,1) == 1)&&(PREADY == 0)&&($past(PREADY,1)==1)&&($past(PADDR,1) == 8'h1C)) |-> APB_ARB_TYPE == $past(PWDATA,1));

/*APB read operation*/
a12:assert property (@(posedge PCLK) disable iff(!PRESETn) (PWRITE == 0)&&(PREADY == 1)&&(PADDR == 8'h10) |-> PRDATA == APB_BYPASS);
a13:assert property (@(posedge PCLK) disable iff(!PRESETn) (PWRITE == 0)&&(PREADY == 1)&&(PADDR == 8'h14) |-> PRDATA == APB_REQ);
a14:assert property (@(posedge PCLK) disable iff(!PRESETn) (PWRITE == 0)&&(PREADY == 1)&&(PADDR == 8'h1C) |-> PRDATA == APB_ARB_TYPE);

/*RESET VALUE*/
a15:assert property (@(posedge PCLK) $rose(PRESETn) |-> (APB_BYPASS == 1'b0)&&(APB_REQ == 4'b0000)&&(APB_ARB_TYPE == 3'b100));

/*WRITE AND READ HAPPENS AT LEAST ONCE*/
a16:cover property (@(posedge PCLK) PENABLE&&(!PWRITE));
a17:cover property (@(posedge PCLK) PENABLE&&(PWRITE));

endmodule

module arb_props (
  clk,
  rst_n,
  req,
  arb_type,
  gnt
  );

input        clk;
input        rst_n;
input  [3:0] req;
input  [2:0] arb_type;

input  [3:0] gnt;

//Write arbiter properties here - assertions, cover properties and assume properties
a18:assume property (@(posedge clk) disable iff (!rst_n) $fell(req[0]) |-> $rose(gnt[0]));
a19:assume property (@(posedge clk) disable iff (!rst_n) $fell(req[1]) |-> $rose(gnt[1]));
a20:assume property (@(posedge clk) disable iff (!rst_n) $fell(req[2]) |-> $rose(gnt[2]));
a21:assume property (@(posedge clk) disable iff (!rst_n) $fell(req[3]) |-> $rose(gnt[3]));

/*mutally exclusive*/
a22:assert property (@(posedge clk) disable iff (!rst_n) gnt[0]|->gnt == 1);
a23:assert property (@(posedge clk) disable iff (!rst_n) gnt[1]|->gnt == 2);
a24:assert property (@(posedge clk) disable iff (!rst_n) gnt[2]|->gnt == 4);
a25:assert property (@(posedge clk) disable iff (!rst_n) gnt[3]|->gnt == 8);

/*grant not issued unless request is asserted*/
a26:assert property (@(posedge clk) disable iff (!rst_n) !req[0] |=> !gnt[0]);
a27:assert property (@(posedge clk) disable iff (!rst_n) (!req[1]) |-> ##1 (!gnt[1]));
a28:assert property (@(posedge clk) disable iff (!rst_n) !req[2] |=> !gnt[2]);
a29:assert property (@(posedge clk) disable iff (!rst_n) !req[3] |=> !gnt[3]);


/*priority order check P0*/
a30:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b000) && req[0] |=> gnt[0]);
a31:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b000) && req[1] && !req[0] |=> gnt[1]);
a32:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b000) && req[2] && !req[1] && !req[0]|=> gnt[2]);
a33:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b000) && req[3] && !req[1] && !req[0] && !req[2]|=> gnt[3]); 
/*priority order check P1*/
a34:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b001) && req[1] |=> gnt[1]);
a35:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b001) && req[0] && !req[1] |=> gnt[0]);
a36:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b001) && req[2] && !req[1] && !req[0]|=> gnt[2]);
a37:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b001) && req[3] && !req[1] && !req[0] && !req[2]|=> gnt[3]); 
/*priority order check P2*/
a38:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b010) && req[2] |=> gnt[2]);
a39:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b010) && req[0] && !req[2] |=> gnt[0]);
a40:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b010) && req[1] && !req[2] && !req[0]|=> gnt[1]);
a41:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b010) && req[3] && !req[1] && !req[0] && !req[2]|=> gnt[3]); 
/*priority order check P3*/
a42:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b011) && req[3] |=> gnt[3]);
a43:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b011) && req[0] && !req[3] |=> gnt[0]);
a44:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b011) && req[1] && !req[3] && !req[0]|=> gnt[1]);
a45:assert property (@(posedge clk) disable iff (!rst_n) (arb_type == 3'b011) && req[2] && !req[1] && !req[0] && !req[3]|=> gnt[2]); 

/*priority order check Prr*/
a46:assert property (@(posedge clk) disable iff (!rst_n | arb_type != 3'b100) (arb_type == 3'b100) && req[0] |-> ##[1:4] gnt[0]);
a47:assert property (@(posedge clk) disable iff (!rst_n | arb_type != 3'b100) (arb_type == 3'b100) && req[1] |-> ##[1:4] gnt[1]);
a48:assert property (@(posedge clk) disable iff (!rst_n | arb_type != 3'b100) (arb_type == 3'b100) && req[2] |-> ##[1:4] gnt[2]);
a61:assert property (@(posedge clk) disable iff (!rst_n | arb_type != 3'b100) (arb_type == 3'b100) && req[3] |-> ##[1:4] gnt[3]);

/*priority order check Prand*/
a49:assert property (@(posedge clk) disable iff (!rst_n | arb_type != 3'b101) (arb_type == 3'b101) && req[0] |-> ##[1:7] gnt[0]);
a50:assert property (@(posedge clk) disable iff (!rst_n | arb_type != 3'b101) (arb_type == 3'b101) && req[1] |-> ##[1:4] gnt[1]);
a51:assert property (@(posedge clk) disable iff (!rst_n | arb_type != 3'b101) (arb_type == 3'b101) && req[2] |-> ##[1:6] gnt[2]);
a52:assert property (@(posedge clk) disable iff (!rst_n | arb_type != 3'b101) (arb_type == 3'b101) && req[3] |-> ##[1:7] gnt[3]);



/*cover property each request go high at least once*/
a53:cover property (@(posedge clk) disable iff (!rst_n) req[0]);
a54:cover property (@(posedge clk) disable iff (!rst_n) req[1]);
a55:cover property (@(posedge clk) disable iff (!rst_n) req[2]);
a56:cover property (@(posedge clk) disable iff (!rst_n) req[3]);
a57:cover property (@(posedge clk) disable iff (!rst_n) gnt[0]);
a58:cover property (@(posedge clk) disable iff (!rst_n) gnt[1]);
a59:cover property (@(posedge clk) disable iff (!rst_n) gnt[2]);
a60:cover property (@(posedge clk) disable iff (!rst_n) gnt[3]);






endmodule

module Wrapper;

//Bind the 'apb_props' module with the 'arbiter_top' module to instantiate the properties
bind arbiter_top apb_props 
apb_props_inst(
          .PCLK(PCLK),
		  .PRESETn(PRESETn),
		  .PWRITE(PWRITE),
		  .PSEL(PSEL),
		  .PENABLE(PENABLE),
		  .PADDR(PADDR),
		  .PWDATA(PWDATA),
		  .PRDATA(PRDATA),
		  .PREADY(PREADY),
		  .APB_BYPASS(APB_BYPASS),
		  .APB_REQ(APB_REQ),
		  .APB_ARB_TYPE(APB_ARB_TYPE),
		  .REQ(REQ),
		  .GNT(GNT)
	);
		
		  
//Bind the 'arb_props' module with the 'arbiter' module to instantiate the properties
bind arbiter arb_props 
arb_props_inst(
           .clk(clk),
           .rst_n(rst_n),
           .req(req),
           .arb_type(arb_type),
           .gnt(gnt)
	);
endmodule

