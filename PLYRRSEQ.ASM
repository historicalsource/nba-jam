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
	.file	"plyrrseq.asm"
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
	.include	"plyrrseq.tbl"



;sounds external

;swipe_snd	.word	>f584,>4,>8119,0	;swipe at ball

;symbols externally defined

;	.ref	plyr_pass,plyr_shoot
;	.ref	seq_newdir
;	.ref	seq_slamball
;	.ref	seq_strtdunk
;	.ref	seq_jump
;	.ref	seq_jump2
	.ref	seq_resetseq
;	.ref	seq_stand
;	.ref	seq_stealstand
;	.ref	seq_block,seq_push,seq_rebounda
;	.ref	seq_run
;	.ref	seq_snd
;	.ref	clr_autorbnd

;FIX!!!!  We can get rid of the pal data for these pals in imgpal3 before
;game ships!  Check zwilpal, etc.  All unused pals!
	.ref	PLYRFIX_P
	.ref	NEWILFIX

;symbols defined in this file

	.def	w3run1

;uninitialized ram definitions



;equates for this file

M_YF	.equ	>8000	;Y free (OFLAGS)


	.text


********************************


	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF


#*
run_t
runturb_t
	.word	0
	.long	0
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	3,N

;runturb_t
;	.word	0
;	.long	0
;	.long	#1a,#2a,#3a,#4a,#5a,#4a,#3a,#2a
;	.asg	2,N2

;FIX!!!
;Could reduce overhead here!

#1
	.ref	seq_ck_turbo
	.ref	seq_skip_1frm
	.ref	seq_ck_drib_turbo

	WL	-1,seq_ck_turbo
	WLW	1,w1run1,F
	WL	-1,seq_skip_1frm
	WLW	1,w1run1,F
	WL	-1,seq_ck_turbo
	WLW	2,w1run1,F
	WL	-1,seq_skip_1frm
	WLW	1,w1run1,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run2,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run2,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run3,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run3,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run4,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run4,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run5,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run5,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run6,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run6,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run7,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run7,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run8,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run8,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run9,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run9,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run10,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run10,F
	WL	-1,seq_ck_turbo
	WLW	3,w1run11,F
	WL	-1,seq_skip_1frm
	WLW	2,w1run11,F
	W0
#2
	WL	-1,seq_ck_turbo
	WLW	1,w2run1,F
	WL	-1,seq_skip_1frm
	WLW	1,w2run1,F
	WL	-1,seq_ck_turbo
	WLW	2,w2run1,F
	WL	-1,seq_skip_1frm
	WLW	1,w2run1,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run2,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run2,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run3,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run3,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run4,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run4,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run5,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run5,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run6,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run6,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run7,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run7,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run8,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run8,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run9,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run9,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run10,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run10,F
	WL	-1,seq_ck_turbo
	WLW	3,w2run11,F
	WL	-1,seq_skip_1frm
	WLW	2,w2run11,F
	W0
#3
;	WL	-1,seq_run
	WL	-1,seq_ck_turbo
	WLW	3,w3run1,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr1,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run2,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr2,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run3,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr3,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run4,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr4,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run5,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr5,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run6,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr6,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run7,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr7,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run8,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr8,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run9,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr9,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run10,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr10,F
	WL	-1,seq_ck_turbo
	WLW	3,w3run11,F
	WL	-1,seq_skip_1frm
	WLW	2,w3spr11,F
	W0
#4
	WL	-1,seq_ck_turbo
	WLW	3,w4run1,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr1,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run2,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr2,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run3,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr3,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run4,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr4,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run5,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr5,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run6,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr6,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run7,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr7,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run8,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr8,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run9,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr9,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run10,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr10,F
	WL	-1,seq_ck_turbo
	WLW	3,w4run11,F
	WL	-1,seq_skip_1frm
	WLW	2,w4spr11,F
	W0
#5
	WL	-1,seq_ck_turbo
	WLW	3,w5run1,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run1,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run2,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run2,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run3,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run3,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run4,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run4,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run5,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run5,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run6,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run6,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run7,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run7,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run8,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run8,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run9,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run9,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run10,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run10,F
	WL	-1,seq_ck_turbo
	WLW	3,w5run11,F
	WL	-1,seq_skip_1frm
	WLW	2,w5run11,F
	W0

#*
rundrib_t
rundribturb_t
	.word	DRIBBLE_M
	.long	0
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	3,N

;	.word	DRIBBLE_M
;	.long	0
;	.long	#1a,#2a,#3a,#4a,#5a,#4a,#3a,#2a
;	.asg	2,N2



#1
	WL	-1,seq_ck_drib_turbo
	WLW	1,w1drun1,F
	WL	-1,seq_skip_1frm
	WLW	1,w1drun1,F
	WL	-1,seq_ck_drib_turbo
	WLW	2,w1drun1,F|M_YF
	WL	-1,seq_skip_1frm
	WLW	1,w1drun1,F|M_YF
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun2,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun2,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun3,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun3,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun4,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun4,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun5,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun5,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun6,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun6,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun7,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun7,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun8,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun8,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun9,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun9,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun10,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun10,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w1drun11,F
	WL	-1,seq_skip_1frm
	WLW	2,w1drun11,F
	W0
#2
	WL	-1,seq_ck_drib_turbo
	WLW	1,w2drun1,F
	WL	-1,seq_skip_1frm
	WLW	1,w2drun1,F
	WL	-1,seq_ck_drib_turbo
	WLW	2,w2drun1,F|M_YF
	WL	-1,seq_skip_1frm
	WLW	1,w2drun1,F|M_YF
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun2,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun2,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun3,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun3,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun4,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun4,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun5,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun5,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun6,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun6,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun7,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun7,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun8,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun8,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun9,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun9,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun10,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun10,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w2drun11,F
	WL	-1,seq_skip_1frm
	WLW	2,w2drun11,F
	W0
#3
	WL	-1,seq_ck_drib_turbo
	WLW	1,w3drun1,F
	WL	-1,seq_skip_1frm
	WLW	1,w3dspr1,F
	WL	-1,seq_ck_drib_turbo
	WLW	2,w3drun1,F|M_YF
	WL	-1,seq_skip_1frm
	WLW	1,w3dspr1,F|M_YF
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun2,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr2,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun3,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr3,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun4,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr4,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun5,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr5,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun6,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr6,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun7,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr7,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun8,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr8,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun9,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr9,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun10,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr10,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w3drun11,F
	WL	-1,seq_skip_1frm
	WLW	2,w3dspr11,F
	W0
#4
	WL	-1,seq_ck_drib_turbo
	WLW	1,w4drun1,F
	WL	-1,seq_skip_1frm
	WLW	1,w4dspr1,F
	WL	-1,seq_ck_drib_turbo
	WLW	2,w4drun1,F|M_YF
	WL	-1,seq_skip_1frm
	WLW	1,w4dspr1,F|M_YF
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun2,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr2,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun3,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr3,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun4,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr4,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun5,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr5,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun6,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr6,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun7,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr7,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun8,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr8,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun9,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr9,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun10,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr10,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w4drun11,F
	WL	-1,seq_skip_1frm
	WLW	2,w4dspr11,F
	W0
#5
	WL	-1,seq_ck_drib_turbo
	WLW	1,w5drun1,F
	WL	-1,seq_skip_1frm
	WLW	1,w5drun1,F
	WL	-1,seq_ck_drib_turbo
	WLW	2,w5drun1,F|M_YF
	WL	-1,seq_skip_1frm
	WLW	1,w5drun1,F|M_YF
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun2,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun2,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun3,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun3,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun4,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun4,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun5,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun5,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun6,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun6,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun7,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun7,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun8,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun8,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun9,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun9,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun10,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun10,F
	WL	-1,seq_ck_drib_turbo
	WLW	3,w5drun11,F
	WL	-1,seq_skip_1frm
	WLW	2,w5drun11,F
	W0



;#1
;	WLW	1,w1drun1,F
;	WLW	N-1,w1drun1,F|M_YF
;	WLW	N,w1drun2,F
;	WLW	N,w1drun3,F
;	WLW	N,w1drun4,F
;	WLW	N,w1drun5,F
;	WLW	N,w1drun6,F
;	WLW	N,w1drun7,F
;	WLW	N,w1drun8,F
;	WLW	N,w1drun9,F
;	WLW	N,w1drun10,F
;	WLW	N,w1drun11,F
;	W0
;#1a
;	WLW	1,w1dspr1,F
;	WLW	N2-1,w1dspr1,F|M_YF
;	WLW	N2,w1dspr2,F
;	WLW	N2,w1dspr3,F
;	WLW	N2,w1dspr4,F
;	WLW	N2,w1dspr5,F
;	WLW	N2,w1dspr6,F
;	WLW	N2,w1dspr7,F
;	WLW	N2,w1dspr8,F
;	WLW	N2,w1dspr9,F
;	WLW	N2,w1dspr10,F
;	WLW	N2,w1dspr11,F
;	W0
;#2
;	WLW	1,w2drun1,F
;	WLW	N-1,w2drun1,F|M_YF
;	WLW	N,w2drun2,F
;	WLW	N,w2drun3,F
;	WLW	N,w2drun4,F
;	WLW	N,w2drun5,F
;	WLW	N,w2drun6,F
;	WLW	N,w2drun7,F
;	WLW	N,w2drun8,F
;	WLW	N,w2drun9,F
;	WLW	N,w2drun10,F
;	WLW	N,w2drun11,F
;	W0
;#2a
;	WLW	1,w2dspr1,F
;	WLW	N2-1,w2dspr1,F|M_YF
;	WLW	N2,w2dspr2,F
;	WLW	N2,w2dspr3,F
;	WLW	N2,w2dspr4,F
;	WLW	N2,w2dspr5,F
;	WLW	N2,w2dspr6,F
;	WLW	N2,w2dspr7,F
;	WLW	N2,w2dspr8,F
;	WLW	N2,w2dspr9,F
;	WLW	N2,w2dspr10,F
;	WLW	N2,w2dspr11,F
;	W0
;#3
;	WLW	1,w3drun1,F
;	WLW	N-1,w3drun1,F|M_YF
;	WLW	N,w3drun2,F
;	WLW	N,w3drun3,F
;	WLW	N,w3drun4,F
;	WLW	N,w3drun5,F
;	WLW	N,w3drun6,F
;	WLW	N,w3drun7,F
;	WLW	N,w3drun8,F
;	WLW	N,w3drun9,F
;	WLW	N,w3drun10,F
;	WLW	N,w3drun11,F
;	W0
;#3a
;	WLW	1,w3dspr1,F
;	WLW	N2-1,w3dspr1,F|M_YF
;	WLW	N2,w3dspr2,F
;	WLW	N2,w3dspr3,F
;	WLW	N2,w3dspr4,F
;	WLW	N2,w3dspr5,F
;	WLW	N2,w3dspr6,F
;	WLW	N2,w3dspr7,F
;	WLW	N2,w3dspr8,F
;	WLW	N2,w3dspr9,F
;	WLW	N2,w3dspr10,F
;	WLW	N2,w3dspr11,F
;	W0
;#4
;	WLW	1,w4drun1,F
;	WLW	N-1,w4drun1,F|M_YF
;	WLW	N,w4drun2,F
;	WLW	N,w4drun3,F
;	WLW	N,w4drun4,F
;	WLW	N,w4drun5,F
;	WLW	N,w4drun6,F
;	WLW	N,w4drun7,F
;	WLW	N,w4drun8,F
;	WLW	N,w4drun9,F
;	WLW	N,w4drun10,F
;	WLW	N,w4drun11,F
;	W0
;#4a
;	WLW	1,w4dspr1,F
;	WLW	N2-1,w4dspr1,F|M_YF
;	WLW	N2,w4dspr2,F
;	WLW	N2,w4dspr3,F
;	WLW	N2,w4dspr4,F
;	WLW	N2,w4dspr5,F
;	WLW	N2,w4dspr6,F
;	WLW	N2,w4dspr7,F
;	WLW	N2,w4dspr8,F
;	WLW	N2,w4dspr9,F
;	WLW	N2,w4dspr10,F
;	WLW	N2,w4dspr11,F
;	W0
;#5
;	WLW	1,w5drun1,F
;	WLW	N-1,w5drun1,F|M_YF
;	WLW	N,w5drun2,F
;	WLW	N,w5drun3,F
;	WLW	N,w5drun4,F
;	WLW	N,w5drun5,F
;	WLW	N,w5drun6,F
;	WLW	N,w5drun7,F
;	WLW	N,w5drun8,F
;	WLW	N,w5drun9,F
;	WLW	N,w5drun10,F
;	WLW	N,w5drun11,F
;	W0
;#5a
;	WLW	1,w5dspr1,F
;	WLW	N2-1,w5dspr1,F|M_YF
;	WLW	N2,w5dspr2,F
;	WLW	N2,w5dspr3,F
;	WLW	N2,w5dspr4,F
;	WLW	N2,w5dspr5,F
;	WLW	N2,w5dspr6,F
;	WLW	N2,w5dspr7,F
;	WLW	N2,w5dspr8,F
;	WLW	N2,w5dspr9,F
;	WLW	N2,w5dspr10,F
;	WLW	N2,w5dspr11,F
;	W0


;nba_run2.img
;---> !STANCE1,!STANCE2,!STANCE3,!STANCE4,!STANCE5,w1dfcr1,w1dfcr2,w1dfcr3
;---> w1dfcr4,w1dfcr5,w1dfcr6,w1dfcr7,w1dfcr8,w1dfcr9,w1dfcr10,w2dfcr1
;---> w2dfcr2,w2dfcr3,w2dfcr4,w2dfcr5,w2dfcr6,w3dfcr1,w3dfcr2,w3dfcr3,w3dfcr4
;---> w3dfcr5,w3dfcr6,w3dfcr7,w3dfcr8,w3dfcr9,w4dfcr1,w4dfcr2,w4dfcr3,w4dfcr4
;---> w4dfcr5,w4dfcr6,w4dfcr7,w4dfcr8,w4dfcr9,w5dfcr1,w5dfcr2,w5dfcr3,w5dfcr4
;---> w5dfcr5,w5dfcr6,w5dfcr7,w5dfcr8,w5dfcr9

;walkfdef_t
;	.word	WALK_M
;	.long	seq_resetseq
;	.long	#wfdef1_l,#wfdef2_l,#wfdef3_l,#wfdef4_l
;	.long	#wfdef5_l,#wfdef4_l,#wfdef3_l,#wfdef2_l
;
;#wfdef1_l
;	WLW	3,w1defwd1,F
;	WLW	3,w1defwd6,F
;	WLW	3,w1defwd5,F
;	WLW	3,w1defwd4,F
;	WLW	3,w1defwd3,F
;	WLW	3,w1defwd2,F
;	W0
;#wfdef2_l
;	WLW	3,w2defwd1,F
;	WLW	3,w2defwd6,F
;	WLW	3,w2defwd5,F
;	WLW	3,w2defwd4,F
;	WLW	3,w2defwd3,F
;	WLW	3,w2defwd2,F
;	W0
;#wfdef3_l
;	WLW	3,w3defwd1,F
;	WLW	3,w3defwd6,F
;	WLW	3,w3defwd5,F
;	WLW	3,w3defwd4,F
;	WLW	3,w3defwd3,F
;	WLW	3,w3defwd2,F
;	W0
;#wfdef4_l
;	WLW	3,w4defwd1,F
;	WLW	3,w4defwd6,F
;	WLW	3,w4defwd5,F
;	WLW	3,w4defwd4,F
;	WLW	3,w4defwd3,F
;	WLW	3,w4defwd2,F
;	W0
;#wfdef5_l
;	WLW	3,w5defwd1,F
;	WLW	3,w5defwd6,F
;	WLW	3,w5defwd5,F
;	WLW	3,w5defwd4,F
;	WLW	3,w5defwd3,F
;	WLW	3,w5defwd2,F
;	W0
;
;
;walkbdef_t
;	.word	WALK_M
;	.long	seq_resetseq
;	.long	#wbdef1_l,#wbdef2_l,#wbdef3_l,#wbdef4_l
;	.long	#wbdef5_l,#wbdef4_l,#wbdef3_l,#wbdef2_l
;
;#wbdef1_l
;	WLW	3,w1defwd1,F
;	WLW	3,w1defwd2,F
;	WLW	3,w1defwd3,F
;	WLW	3,w1defwd4,F
;	WLW	3,w1defwd5,F
;	WLW	3,w1defwd6,F
;	W0
;#wbdef2_l
;	WLW	3,w2defwd1,F
;	WLW	3,w2defwd2,F
;	WLW	3,w2defwd3,F
;	WLW	3,w2defwd4,F
;	WLW	3,w2defwd5,F
;	WLW	3,w2defwd6,F
;	W0
;#wbdef3_l
;	WLW	3,w3defwd1,F
;	WLW	3,w3defwd2,F
;	WLW	3,w3defwd3,F
;	WLW	3,w3defwd4,F
;	WLW	3,w3defwd5,F
;	WLW	3,w3defwd6,F
;	W0
;#wbdef4_l
;	WLW	3,w4defwd1,F
;	WLW	3,w4defwd2,F
;	WLW	3,w4defwd3,F
;	WLW	3,w4defwd4,F
;	WLW	3,w4defwd5,F
;	WLW	3,w4defwd6,F
;	W0
;#wbdef5_l
;	WLW	3,w5defwd1,F
;	WLW	3,w5defwd2,F
;	WLW	3,w5defwd3,F
;	WLW	3,w5defwd4,F
;	WLW	3,w5defwd5,F
;	WLW	3,w5defwd6,F
;	W0


stnddef_t
	.word	EASYSTAG_M
	.long	0
	.long	#sdef1_l,#sdef2_l,#sdef3_l,#sdef4_l
	.long	#sdef5_l,#sdef4_l,#sdef3_l,#sdef2_l


#sdef1_l
	WLW	5,w1defst1,F
	WLW	5,w1defst2,F
	WLW	5,w1defst3,F
	WLW	5,w1defst4,F
	WLW	5,w1defst3,F
	WLW	5,w1defst2,F
	W0
#sdef2_l
	WLW	5,w2defst1,F
	WLW	5,w2defst2,F
	WLW	5,w2defst3,F
	WLW	5,w2defst4,F
	WLW	5,w2defst3,F
	WLW	5,w2defst2,F
	W0
#sdef3_l
	WLW	5,w3defst1,F
	WLW	5,w3defst2,F
	WLW	5,w3defst3,F
	WLW	5,w3defst4,F
	WLW	5,w3defst3,F
	WLW	5,w3defst2,F
	W0
#sdef4_l
	WLW	5,w4defst1,F
	WLW	5,w4defst2,F
	WLW	5,w4defst3,F
	WLW	5,w4defst4,F
	WLW	5,w4defst3,F
	WLW	5,w4defst2,F
	W0
#sdef5_l
	WLW	5,w5defst1,F
	WLW	5,w5defst2,F
	WLW	5,w5defst3,F
	WLW	5,w5defst4,F
	WLW	5,w5defst3,F
	WLW	5,w5defst2,F
	W0

#*
walkfdef_t
walkbdef_t
walkldef_t
	.word	WALK_M
	.long	seq_resetseq
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2

#1
	WLW	2,w1dfcr1,F
	WLW	2,w1dfcr2,F
	WLW	2,w1dfcr3,F
	WLW	2,w1dfcr4,F
	WLW	2,w1dfcr5,F
	WLW	2,w1dfcr6,F
	W0
#2
	WLW	2,w2dfcr1,F
;	WLW	2,w2dfcr6,F
	WLW	2,w2dfcr5,F
	WLW	2,w2dfcr4,F
	WLW	2,w2dfcr3,F
	WLW	2,w2dfcr2,F
	W0
#3
	WLW	2,w3dfcr1,F
	WLW	2,w3dfcr9,F
	WLW	2,w3dfcr8,F
	WLW	2,w3dfcr7,F
	WLW	2,w3dfcr6,F
	WLW	2,w3dfcr5,F
	WLW	2,w3dfcr4,F
	WLW	2,w3dfcr3,F
	WLW	2,w3dfcr2,F
	W0
#4
	WLW	2,w4dfcr1,F
	WLW	2,w4dfcr9,F
	WLW	2,w4dfcr8,F
	WLW	2,w4dfcr7,F
	WLW	2,w4dfcr6,F
	WLW	2,w4dfcr5,F
	WLW	2,w4dfcr4,F
	WLW	2,w4dfcr3,F
	WLW	2,w4dfcr2,F
	W0
#5
	WLW	2,w5dfcr1,F
	WLW	2,w5dfcr9,F
	WLW	2,w5dfcr8,F
	WLW	2,w5dfcr7,F
	WLW	2,w5dfcr6,F
	WLW	2,w5dfcr5,F
	WLW	2,w5dfcr4,F
	WLW	2,w5dfcr3,F
	WLW	2,w5dfcr2,F
	W0

#*
walkrdef_t
	.word	WALK_M
	.long	seq_resetseq
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2

#1
	WLW	2,w1dfcr1,F
	WLW	2,w1dfcr6,F
	WLW	2,w1dfcr5,F
	WLW	2,w1dfcr4,F
	WLW	2,w1dfcr3,F
	WLW	2,w1dfcr2,F
	W0
#2
	WLW	2,w2dfcr1,F
	WLW	2,w2dfcr2,F
	WLW	2,w2dfcr3,F
	WLW	2,w2dfcr4,F
	WLW	2,w2dfcr5,F
;	WLW	2,w2dfcr6,F
	W0
#3
	WLW	2,w3dfcr1,F
	WLW	2,w3dfcr2,F
	WLW	2,w3dfcr3,F
	WLW	2,w3dfcr4,F
	WLW	2,w3dfcr5,F
	WLW	2,w3dfcr6,F
	WLW	2,w3dfcr7,F
	WLW	2,w3dfcr8,F
	WLW	2,w3dfcr9,F
	W0
#4
	WLW	2,w4dfcr1,F
	WLW	2,w4dfcr2,F
	WLW	2,w4dfcr3,F
	WLW	2,w4dfcr4,F
	WLW	2,w4dfcr5,F
	WLW	2,w4dfcr6,F
	WLW	2,w4dfcr7,F
	WLW	2,w4dfcr8,F
	WLW	2,w4dfcr9,F
	W0
#5
	WLW	2,w5dfcr1,F
	WLW	2,w5dfcr2,F
	WLW	2,w5dfcr3,F
	WLW	2,w5dfcr4,F
	WLW	2,w5dfcr5,F
	WLW	2,w5dfcr6,F
	WLW	2,w5dfcr7,F
	WLW	2,w5dfcr8,F
	WLW	2,w5dfcr9,F
	W0

	.end


