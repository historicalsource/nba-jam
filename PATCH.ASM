**************************************************************
*
* Owner:	none
*
* Software:	? and Shawn Liptak
* Initiated:	?
*
* Modified:	Shawn Liptak, 2/20/92	-Started basketball cleanup
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/10/92 19:07
**************************************************************
	.option	b,d,l,t
	.mnolist

	.include	"gsp.equ"
	.include	"macros.hdr"
	

	.def	TVPATCH,TVPATCHX


	.ref	dirq_wait
	.ref	dmaq_wait
	.ref	DISPLAYON

	.text
	.even
OLDINTEN	.word	0


 SUBR	TVBP

	PUSH	a0,a1
	PUSH	b0,b1

	move	@INTENB,a0		;Disable ROM protect interrupt (ext2)
	move	a0,@OLDINTEN
	andni	X2E,a0
	ori	DIE,a0			;Enable DIRQ
	move	a0,@INTENB

	PULL	b0,b1
	PULL	a0,a1
	rets


 SUBR	TVBPX

	PUSH	a0

	move	@OLDINTEN,a0		;Enable ROM protect interrupt (ext2)
	ori	X2E,a0
	move	a0,@INTENB

	move	@INTPEND,a0		;Clear any pending X2E or DIE
	andni	X2E|DIE,a0
	move	a0,@INTPEND

	move	a0,@>1e00000		;Clr FPGA rom protect

	PULL	a0
	rets


TVPATCH:
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
TVPATCHX:

