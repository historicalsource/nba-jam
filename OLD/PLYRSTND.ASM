**************************************************************
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		10/8/92
*
* Modified:		Shawn Liptak, 10/8/92	-Split from BB.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/18/92 1:40
**************************************************************
	.file	"plyrstnd.asm"
	.title	"basketball plyr sequence code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"game.equ"
	.include	"shawn.hdr"
	.asg		0,SEQT
	.include	"plyr.equ"
	.include	"stand.tbl"



;sounds external

;symbols externally defined

;symbols defined in this file

;uninitialized ram definitions

;equates for this file

M_YF	.equ	>8000	;Y free (OFLAGS)

	.text

********************************


	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF


stnd_t	.word	EASYSTAG_M
	.long	0
	.long	#stnd1_l,#stnd2_l,#stnd3_l,#stnd4_l
	.long	#stnd5_l,#stnd4_l,#stnd3_l,#stnd2_l

stndwb2_t
	.word	EASYSTAG_M|NOMV_M
	.long	0
	.long	#stnd1_l,#stnd2_l,#stnd3_l,#stnd4_l
	.long	#stnd5_l,#stnd4_l,#stnd3_l,#stnd2_l

	.asg	4,N		;5
#stnd1_l
	WLW	N,W1ST1,F
	WLW	N,W1ST2,F
	WLW	N,W1ST3,F
	WLW	N,W1ST4,F
	WLW	N,W1ST5,F
	WLW	N,W1ST4,F
	WLW	N,W1ST3,F
	WLW	N,W1ST2,F
	W0
#stnd2_l
	WLW	N,W2ST1,F
	WLW	N,W2ST2,F
	WLW	N,W2ST3,F
	WLW	N,W2ST4,F
	WLW	N,W2ST5,F
	WLW	N,W2ST4,F
	WLW	N,W2ST3,F
	WLW	N,W2ST2,F
	W0
#stnd3_l
	WLW	N,W3ST1,F
	WLW	N,W3ST2,F
	WLW	N,W3ST3,F
	WLW	N,W3ST4,F
	WLW	N,W3ST5,F
	WLW	N,W3ST4,F
	WLW	N,W3ST3,F
	WLW	N,W3ST2,F
	W0
#stnd4_l
	WLW	N,W4ST1,F
	WLW	N,W4ST2,F
	WLW	N,W4ST3,F
	WLW	N,W4ST4,F
	WLW	N,W4ST5,F
	WLW	N,W4ST4,F
	WLW	N,W4ST3,F
	WLW	N,W4ST2,F
	W0
#stnd5_l
	WLW	N,W5ST1,F
	WLW	N,W5ST2,F
	WLW	N,W5ST3,F
	WLW	N,W5ST4,F
	WLW	N,W5ST5,F
	WLW	N,W5ST4,F
	WLW	N,W5ST3,F
	WLW	N,W5ST2,F
	W0


	.end

