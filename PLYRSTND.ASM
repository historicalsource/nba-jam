**************************************************************
*
* Owner:	TURMELL
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
	.include	"macros.hdr"

	.asg		0,SEQT
	.include	"plyr.equ"
	.include	"stand.tbl"
	.include	"plyrhd3.tbl"
	.include	"plyrhd2.glo"


	.ref	RODMANBP
	.ref	RODMANKP
	.ref	RODMANOP
	.ref	RODMANPP
	.ref	RODMANRP
	.ref	RODMANWP
	.ref	RODMANYP
	.ref	RODMANGP


	.ref	w3stwb3fix		;fix for buggy locked img

	.ref	PLYRFIX_P

;sounds external

;symbols externally defined

;symbols defined in this file

;uninitialized ram definitions

;equates for this file

	.if	IMGVIEW
	.else
	.def	W5ST1
	.endif

M_YF	.equ	>8000	;Y free (OFLAGS)

	.text

********************************


	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF


stnd_t	.word	EASYSTAG_M
	.long	0
	.long	#stnd1_l,#stnd2_l,#stnd3_l,#stnd4_l
	.long	#stnd5_l,#stnd4_l,#stnd3_l,#stnd2_l


	.asg	5,N		;5
#stnd1_l
	WLW	N,W1ST1,F
	WLW	N,W1ST2,F
	WLW	N,W1ST3,F
	WLW	N,W1ST4,F
	WLW	N,W1ST5,F
	WLW	N,W1ST6,F
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
	WLW	N,W2ST6,F
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
	WLW	N,W3ST6,F
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
	WLW	N,W4ST6,F
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
	WLW	N,W5ST6,F
	WLW	N,W5ST5,F
	WLW	N,W5ST4,F
	WLW	N,W5ST3,F
	WLW	N,W5ST2,F
	W0

stndwb_t
	.word	EASYSTAG_M|NOMV_M
	.long	0
	.long	#stndwb1_l,#stndwb2_l,#stndwb3_l,#stndwb4_l
	.long	#stndwb5_l,#stndwb4_l,#stndwb3_l,#stndwb2_l

#stndwb1_l
	WL	5,w1stwb1,F
	WL	5,w1stwb2,F
	WL	5,w1stwb3,F
	WL	5,w1stwb4,F
	WL	5,w1stwb3,F
	WL	5,w1stwb2,F
	W0
#stndwb2_l
	WL	5,w2stwb1,F
	WL	5,w2stwb2,F
	WL	5,w2stwb3,F
	WL	5,w2stwb4,F
	WL	5,w2stwb3,F
	WL	5,w2stwb2,F
	W0
#stndwb3_l
	WL	5,w3stwb1,F
	WL	5,w3stwb2,F
;	WL	5,w3stwb3,F
	WL	5,w3stwb3fix,F		;fix for buggy locked img
	WL	5,w3stwb4,F
;	WL	5,w3stwb3,F
	WL	5,w3stwb3fix,F		;fix for buggy locked img
	WL	5,w3stwb2,F
	W0
#stndwb4_l
	WL	5,w4stwb1,F
	WL	5,w4stwb2,F
	WL	5,w4stwb3,F
	WL	5,w4stwb4,F
	WL	5,w4stwb3,F
	WL	5,w4stwb2,F
	W0
#stndwb5_l
	WL	5,w5stwb1,F
	WL	5,w5stwb2,F
	WL	5,w5stwb3,F
	WL	5,w5stwb4,F
	WL	5,w5stwb3,F
	WL	5,w5stwb2,F
	W0

#*
stndwb2_t
	.word	EASYSTAG_M|NOMV_M
	.long	0
	.long	#stndwb1_l,#stndwb2_l,#stndwb3_l,#stndwb4_l
	.long	#stndwb5_l,#stndwb4_l,#stndwb3_l,#stndwb2_l


	.asg	5,N		;5
#stndwb1_l

	WLW	N,w1stwbl1,F
	WLW	N,w1stwbl2,F
	WLW	N,w1stwbl3,F
	WLW	N,w1stwbl4,F
	WLW	N,w1stwbl3,F
	WLW	N,w1stwbl2,F
	W0
#stndwb2_l
	WLW	N,w2stwbl1,F
	WLW	N,w2stwbl2,F
	WLW	N,w2stwbl3,F
	WLW	N,w2stwbl4,F
	WLW	N,w2stwbl3,F
	WLW	N,w2stwbl2,F
	W0
#stndwb3_l
	WLW	N,w3stwbl1,F
	WLW	N,w3stwbl2,F
	WLW	N,w3stwbl3,F
	WLW	N,w3stwbl4,F
	WLW	N,w3stwbl3,F
	WLW	N,w3stwbl2,F
	W0
#stndwb4_l
	WLW	N,w4stwbl1,F
	WLW	N,w4stwbl2,F
	WLW	N,w4stwbl3,F
	WLW	N,w4stwbl4,F
	WLW	N,w4stwbl3,F
	WLW	N,w4stwbl2,F
	W0
#stndwb5_l
	WLW	N,w5stwbl1,F
	WLW	N,w5stwbl2,F
	WLW	N,w5stwbl3,F
	WLW	N,w5stwbl4,F
	WLW	N,w5stwbl3,F
	WLW	N,w5stwbl2,F
	W0

	.end


