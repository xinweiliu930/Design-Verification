/*****************************************************************
//                                                              //
//  Amber 2 Core Instruction Test                               //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Tests add                                                   //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//                                                              //
//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (C) 2010 Authors and OPENCORES.ORG                 //
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
*****************************************************************/

#include "amber_registers.h"

	.section .text
	.globl	main        
main:
	ldr	r13, MaxPos
	ldr	r12, MidPos_L
        ldr	r11, MidPos_L_P1
	ldr	r10, Two_ff
	ldr	r9, A1
	ldr	r8, Zero








/* add, sub */
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1
        		add     r0, r12, #1




/* lsr */
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8
        		mov     r0, r12, lsr #8




/* mul */
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12
			mul	r0, r10, r12




/* ldr, str */
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff
			ldr	r0, Two_ff




/* and */
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12
			and	r0, r10, r12




/* mov */
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9
			mov 	r0, r9




/* cmp */
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9
			cmp	r0, r9




/* b */
			b point_0
point_0:
			b point_1
point_1:
			b point_2
point_2:
			b point_3
point_3:
			b point_4
point_4:
			b point_5
point_5:
			b point_6
point_6:
			b point_7
point_7:
			b point_8
point_8:
			b point_9
point_9:
			b point_10
point_10:
			b point_11
point_11:
			b point_12
point_12:
			b point_13
point_13:
			b point_14
point_14:
		








/* test */
        bne     testfail
        b       testpass
testfail:
        ldr     r11, AdrTestStatus
        str     r10, [r11]
        b       testfail
testpass:             
        ldr     r11, AdrTestStatus
        mov     r10, #17
        str     r10, [r11]
        b       testpass



/* Write 17 to this address to generate a Test Passed message */
AdrTestStatus:  .word  ADR_AMBER_TEST_STATUS
MaxPos:         .word  0x7fffffff
MidPos_L:       .word  0x0000ffff
MidPos_L_P1:    .word  0x00010000
Zero:		.word  0x00000000
Two_ff:		.word  0x000000ff
A1:		.word  0x00feff01
MaxNeg:         .word  0x80000000

/* ========================================================================= */
/* ========================================================================= */
        

