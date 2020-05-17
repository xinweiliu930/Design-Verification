`include "constants.v"
`include "rv32_opcodes.v"
`include "alu_ops.v"

//Write your properties in a module here.
module decoder_prop (
input wire clk,
		input wire reset,
	       input wire [31:0] 		  inst,
	       input reg [`IMM_TYPE_WIDTH-1:0]   imm_type,
	       input wire [`REG_SEL-1:0] 	  rs1,
	       input wire [`REG_SEL-1:0] 	  rs2,
	       input wire [`REG_SEL-1:0] 	  rd,
	       input reg [`SRC_A_SEL_WIDTH-1:0]  src_a_sel,
               input reg [`SRC_B_SEL_WIDTH-1:0]  src_b_sel,
	       input reg 			  wr_reg,
	       
	       input reg 			  uses_rs1,
	       input reg 			  uses_rs2,
	       input reg 			  illegal_instruction,
	       input reg [`ALU_OP_WIDTH-1:0] 	  alu_op,
	       input reg [`RS_ENT_SEL-1:0] 	  rs_ent,
//	       input reg 			  dmem_use,
//	       input reg 			  dmem_write,
	       input wire [2:0] 		  dmem_size,
	       input wire [`MEM_TYPE_WIDTH-1:0]  dmem_type, 
	       input reg [`MD_OP_WIDTH-1:0] 	  md_req_op,
	       input reg 			  md_req_in_1_signed,
	       input reg 			  md_req_in_2_signed,
	       input reg [`MD_OUT_SEL_WIDTH-1:0] md_req_out_sel

	       );
	/*CHECK WR_REG*/	   
	a1:assert property (@(posedge clk) disable iff (reset) inst[6:0] == `RV32_LUI |-> wr_reg == 1);
	a2:assert property (@(posedge clk) disable iff (reset) inst[6:0] == `RV32_AUIPC |-> wr_reg == 1);
	a3:assert property (@(posedge clk) disable iff (reset) inst[6:0] == `RV32_LOAD |-> wr_reg == 1);
	a4:assert property (@(posedge clk) disable iff (reset) inst[6:0] == `RV32_OP |-> wr_reg == 1);
	a5:assert property (@(posedge clk) disable iff (reset) inst[6:0] == `RV32_JAL |-> wr_reg == 1);
	a6:assert property (@(posedge clk) disable iff (reset) inst[6:0] == `RV32_JALR |-> wr_reg == 1);
	/*CHECK md_req_out_sel*/
    a7:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_MUL) |-> md_req_out_sel == 0);
	a8:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_MULH)|-> md_req_out_sel == 1);
	a9:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_MULHSU) |-> md_req_out_sel == 1);
	a10:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_MULHU) |-> md_req_out_sel == 1);
	/*check md_req_in_1_signed and md_req_in_2_signed*/
    a11:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_MUL) |-> (md_req_in_1_signed == 1) && (md_req_in_2_signed == 1));
	a12:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_MULH) |-> (md_req_in_1_signed == 1) && (md_req_in_2_signed == 1));
	a13:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_MULHSU) |-> (md_req_in_1_signed == 1) && (md_req_in_2_signed == 0));
	a14:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_MULHU) |-> (md_req_in_1_signed == 0) && (md_req_in_2_signed == 0));
	a15:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_DIV) |-> (md_req_in_1_signed == 1) && (md_req_in_2_signed == 1));
	a16:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_DIVU) |-> (md_req_in_1_signed == 0) && (md_req_in_2_signed == 0));
	a17:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_REM) |-> (md_req_in_1_signed == 1) && (md_req_in_2_signed == 1));
	a18:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[14:12]==`RV32_FUNCT3_REMU) |-> (md_req_in_1_signed == 0) && (md_req_in_2_signed == 0));
    /*check alu_op*/
	a19:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[30]==0)&&(inst[25]==0)&&(inst[14:12]==0) |-> alu_op==0);
	a20:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[30]==1)&&(inst[25]==0)&&(inst[14:12]==0) |-> alu_op==10);
	a21:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)               &&(inst[25]==0)&&(inst[14:12]==1) |-> alu_op==1);
	a22:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)               &&(inst[25]==0)&&(inst[14:12]==2) |-> alu_op==12);
	a23:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)               &&(inst[25]==0)&&(inst[14:12]==3) |-> alu_op==14);
	a24:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)               &&(inst[25]==0)&&(inst[14:12]==4) |-> alu_op==4);
	a25:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[30]==1)&&(inst[25]==0)&&(inst[14:12]==5) |-> alu_op==5);
	a26:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[30]==0)&&(inst[25]==0)&&(inst[14:12]==5) |-> alu_op==11);
	a27:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[30]==0)&&(inst[25]==0)&&(inst[14:12]==6) |-> alu_op==6);
	a28:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[30]==0)&&(inst[25]==0)&&(inst[14:12]==7) |-> alu_op==7);
	/*assumption for 2,3,4,5*/
    a29:assume property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP) |-> (inst[25]==0&&inst[30]==0) || (inst[25]==1&&inst[30]==0) || (inst[25]==0&&inst[30]==1));
	/*check rs_ent*/
	a30:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[25]==0) |-> rs_ent == 1 );
	a31:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_OP)&&(inst[25]==1) |-> rs_ent == 3 );
    a32:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_BRANCH) |-> rs_ent == 2);	
	a33:assert property (@(posedge clk) disable iff (reset) (inst[6:0] == `RV32_LOAD)||(inst[6:0] == `RV32_STORE) |-> rs_ent == 4);
	/*cover all the ISA*/
	a34:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110111);
	a35:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0010111);
	a36:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0000011);
	a37:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0100011);
	a38:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b1101111);
	a39:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b1100111);
	a40:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b1100011&&inst[14:12]==0);
	a60:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b1100011&&inst[14:12]==1);
	a61:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b1100011&&inst[14:12]==4);
	a62:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b1100011&&inst[14:12]==5);
	a63:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b1100011&&inst[14:12]==6);
	a64:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b1100011&&inst[14:12]==7);
	a41:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==0&&inst[25]==0&&inst[30]==1);
	a42:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==0&&inst[25]==0&&inst[30]==0);
	a43:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==1&&inst[25]==0);
	a44:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==2&&inst[25]==0);
	a45:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==3&&inst[25]==0);
	a46:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==4&&inst[25]==0);
	a47:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==5&&inst[25]==0&&inst[30]==1);
	a48:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==5&&inst[25]==0&&inst[30]==0);
	a49:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==6&&inst[25]==0);
	a50:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==7&&inst[25]==0);
	a51:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==0&&inst[25]==1);
	a52:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==1&&inst[25]==1);
	a53:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==2&&inst[25]==1);
	a54:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==3&&inst[25]==1);
	a55:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==4&&inst[25]==1);
	a56:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==5&&inst[25]==1);
	a57:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==6&&inst[25]==1);
	a58:cover property  (@(posedge clk) disable iff (reset) inst[6:0] == 2'b0110011&&inst[14:12]==7&&inst[25]==1);
endmodule

module Wrapper;
bind decoder decoder_prop
de_wp(
        .clk(clk),
		.reset(reset),
		.inst(inst),
		.imm_type(imm_type),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.src_a_sel(src_a_sel),
		.src_b_sel(src_b_sel),
		.wr_reg(wr_reg),
		.uses_rs1(uses_rs1),
		.uses_rs2(uses_rs2),
		.illegal_instruction(illegal_instruction),
		.alu_op(alu_op),
		.rs_ent(rs_ent),
		.dmem_size(dmem_size),
		.dmem_type(dmem_type),
		.md_req_op(md_req_op),
		.md_req_in_1_signed(md_req_in_1_signed),
		.md_req_in_2_signed(md_req_in_2_signed),
		.md_req_out_sel(md_req_out_sel)
	);




                                                           
endmodule                                                    
                                                             
                                                                                                                                        
                                                            
