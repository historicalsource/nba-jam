**************************************************************
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		10/8/92
*
* Modified:		Shawn Liptak, 10/24/92	-Split from plyrseq.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/21/92 15:06
**************************************************************
	.file	"plyrlseq.asm"
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
	.include	"layup.tbl"
	.include	"plyrd2se.tbl"


;sounds external

;symbols externally defined

	.ref	plyr_shoot
	.ref	plyr_pass
	.ref	seq_newdir
	.ref	seq_slamball
	.ref	seq_strtdunk
	.ref	seq_jump
	.ref	seq_resetseq
	.ref	seq_stand
	.ref	seq_snd

	.ref	w3desp1
	.ref	seq_lay_up_start
	.ref	seq_jam_speech
	.ref	seq_call_name


JAM_NONE	equ	0
JAM_EASY	equ	1
JAM_MED		equ	2
JAM_GOOD	equ	3
JAM_GREAT	equ	4

;symbols defined in this file

	.def	w2fgrl3,w2fgrl2,w2fgrl1
	.def	T2DUNK3,T2DUNK4,T2DUNK5
	.def	T2DUNK6,T2DUNK7,T2DUNK8,T2DUNK9
	.def	T2DUNK10

;uninitialized ram definitions



;equates for this file

M_YF	.equ	>8000	;Y free (OFLAGS)


	.text

ohmy	.word	>f981,98,>81ea,0	;OH....MY!!!
fancy	.word	>f981,76,>812f,0	;fancy move
airb	.word	>f981,89,>81a4,0	;goes airborne!
torim	.word	>f981,50,>81a6,0	;to the rim
hangt	.word	>f981,59,>81a7,0	;hangtime
lookout	.word	>f981,57,>81b0,0	;lookout!
showt	.word	>f981,70,>81b7,0	;showtime!
thawk	.word	>f981,30,>81c0,0	;tomahawks one home!
facial	.word	>f981,93,>81ee,0	;delivers the facial!
spectd	.word	>f981,94,>81f5,0	;spectacular dunk
inface	.word	>f981,81,>81ab,0	;in your face
mnstjam	.word	>f981,90,>81b2,0	;monster jam

jet	.word	>fd81,110,>8158,0	;jet sound
yell	.word	>fd91,88,>8167,0	;aaaaaaaaaaaaaaaahhhhhhhhhhh
tarzan	.word	>fd91,158,>8177,0	;tarzan yell!

	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF
	.asg	DUNK_M|NOJUMP_M|NOJOY_M|NOCOLLP_M,DFLGS


layup_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	3,N

#2
	WLW	1,w2fgrl1,F
	WL	-1,seq_jump
	WLW	4,w2fgrl1,F
	WLW	4,w2fgrl2,F
	WLW	1,w2fgrl3,F
	WL	-1,plyr_shoot
	WLW	50,w2fgrl3,F
	WLW	5,w2fgrl4,F
	WLW	-1,seq_newdir,1*16
#1	W0
#3
	WLW	1,w3fgrl2,F
	WL	-1,seq_jump
	WLW	4,w3fgrl2,F
;	WLW	1,w3fgrl3,F
;	WL	-1,plyr_shoot
	WLW	4,w3fgrl3,F
	WLW	1,w3fgrl4,F
	WL	-1,plyr_shoot
	WLW	4,w3fgrl4,F
	WLW	50,w3fgrl5,F
	WLW	4,w3fgrl6,F
	WLW	-1,seq_newdir,2*16
	W0
#4
	WLW	1,w4fgrl1,F
	WL	-1,seq_jump
	WLW	4,w4fgrl1,F
	WLW	4,w4fgrl2,F
	WLW	1,w4fgrl3,F
	WL	-1,plyr_shoot
	WLW	50,w4fgrl3,F
	WLW	-1,seq_newdir,3*16
	W0
#5
	WLW	1,w5fgrl1,F
	WL	-1,seq_jump
	WLW	4,w5fgrl1,F
	WLW	4,w5fgrl2,F
	WLW	1,w5fgrl3,F
	WL	-1,plyr_shoot
	WLW	50,w5fgrl3,F
	WLW	5,w5fgrl4,F
	WLW	-1,seq_newdir,4*16
	W0

#*
layupreb_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#5,#4,#3,#2
	.asg	3,N

#2
	WLW	4,w2fgrl1,F
	WLW	4,w2fgrl2,F
	WLW	1,w2fgrl3,F
	WL	-1,plyr_shoot
	WLW	50,w2fgrl3,F
	WLW	5,w2fgrl4,F
	WLW	-1,seq_newdir,1*16
	W0
#3
	WLW	4,w3fgrl2,F
	WLW	4,w3fgrl3,F
	WLW	1,w3fgrl4,F
	WL	-1,plyr_shoot
	WLW	4,w3fgrl4,F
	WLW	50,w3fgrl5,F
	WLW	4,w3fgrl6,F
	WLW	-1,seq_newdir,2*16
	W0
#4
	WLW	4,w4fgrl1,F
	WLW	4,w4fgrl2,F
	WLW	1,w4fgrl3,F
	WL	-1,plyr_shoot
	WLW	50,w4fgrl3,F
	WLW	-1,seq_newdir,3*16
	W0
#5
	WLW	4,w5fgrl1,F
	WLW	4,w5fgrl2,F
	WLW	1,w5fgrl3,F
	WL	-1,plyr_shoot
	WLW	50,w5fgrl3,F
	WLW	5,w5fgrl4,F
	WLW	-1,seq_newdir,4*16
	W0


#*
dunklay_t		;2,3,4,5 directions
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2

#2
	WLW	1,w2fgrl1,F
	WLLW	-1,seq_strtdunk,w2fgrl3,>3a
	WLW	22,w2fgrl1,F
	WL	-1,seq_lay_up_start			;RJR
	WLW	4,w2fgrl2,F
	WLW	1,w2fgrl3,F
	WL	-1,plyr_shoot
	WLW	50,w2fgrl3,F
	WLW	5,w2fgrl4,F
	WLW	-1,seq_newdir,1*16
#1	W0
#3
	WLW	1,w3fgrl2,F
	WLLW	-1,seq_strtdunk,w3fgrl4,>3a
	WLW	22,w3fgrl2,F
	WL	-1,seq_lay_up_start			;RJR
	WLW	4,w3fgrl3,F
	WLW	1,w3fgrl4,F
	WL	-1,plyr_shoot
	WLW	3,w3fgrl4,F
	WLW	50,w3fgrl5,F
	WLW	4,w3fgrl6,F
	WLW	-1,seq_newdir,2*16
	W0
#4
	WLW	1,w4fgrl1,F
	WLLW	-1,seq_strtdunk,w4fgrl3,>3a
	WLW	22,w4fgrl1,F
	WL	-1,seq_lay_up_start			;RJR
	WLW	4,w4fgrl2,F
	WLW	1,w4fgrl3,F
	WL	-1,plyr_shoot
	WLW	50,w4fgrl3,F
	WLW	-1,seq_newdir,3*16
	W0
#5
	WLW	1,w5fgrl1,F
	WLLW	-1,seq_strtdunk,w5fgrl3,>3a
	WLW	22,w5fgrl1,F
	WL	-1,seq_lay_up_start			;RJR
	WLW	4,w5fgrl2,F
	WLW	1,w5fgrl3,F
	WL	-1,plyr_shoot
	WLW	50,w5fgrl3,F
	WLW	5,w5fgrl4,F
	WLW	-1,seq_newdir,4*16
	W0

#*
dunklay6_t		;1,2 directions
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#3
	.long	#3,#3,#3,#2

#1
	WLW	3,w1splay1,F
	WLW	3,w1splay2,F
	WLW	3,w1splay3,F
	WLLW	-1,seq_strtdunk,w1splay10,>40
	WLW	1,w1splay4,F
	WL	-1,seq_lay_up_start
	WLW	3,w1splay4,F
	WLW	4,w1splay5,F
	WLW	4,w1splay6,F
	WLW	4,w1splay7,F
	WLW	18h,w1splay8,F
	WL	-1,plyr_shoot
	WLW	1ch,w1splay9,F
	WLW	8,w1splay10,F
	WLW	80,w1splay11,F
	WLW	-1,seq_newdir,1*16
	W0
#2
	WLW	3,w1splay1,F
	WLW	3,w1splay2,F
	WLW	3,w1splay3,F
	WLLW	-1,seq_strtdunk,w1splay10,>40
	WLW	3,w1splay4,F
	WL	-1,seq_lay_up_start
	WLW	30,w1splay4,F
	WLW	4,w1splay5,F
	WLW	4,w1splay6,F
	WLW	4,w1splay7,F
	WLW	1,w1splay8,F
	WL	-1,plyr_shoot
	WLW	4,w1splay8,F
	WLW	30,w1splay9,F
	WLW	10,w1splay10,F
	WLW	50,w1splay11,F
	WLW	-1,seq_newdir,1*16
#3
	W0

********************************

dunkx_t		;3 direction

	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dx3_l,#DD
	.long	#DD,#DD,#dx3_l,#DD

#DD	W0

#dx3_l
	WLW	4,CANB1,F
	WLLW	-1,seq_strtdunk,CANB13,>66-16
	WLW	3,CANB2,F
	WLL	-1,seq_snd,jet			;RJR

	WLW	3,canroll2,F
	WLL	-1,seq_snd,ohmy			;RJR
	WLW	3,canroll3,F
	WLW	3,canroll4,F
	WLW	3,canroll5,F
	WLW	-1,seq_jam_speech,JAM_GREAT	;RJR
	WLW	3,canroll6,F
	WLW	3,canroll7,F
	WLW	3,canroll8,F
	WLW	3,canroll1,F

;	WLW	3,canroll2,F
;	WLW	3,canroll3,F
;	WLW	3,canroll4,F
;	WLW	3,canroll5,F
;	WLW	3,canroll6,F
;	WLW	3,canroll7,F
;	WLW	3,canroll8,F
;	WLW	3,canroll1,F
;
;	WLW	3,canroll2,F
;	WLW	3,canroll3,F
;	WLW	3,canroll4,F
;	WLW	3,canroll5,F
;	WLW	3,canroll6,F
;	WLW	3,canroll7,F
;	WLW	3,canroll8,F
;	WLW	3,canroll1,F

	WLW	3,canroll2,F
	WLW	3,canroll3,F
	WLW	3,canroll4,F
	WLW	3,canroll5,F
	WLW	3,canroll6,F
	WLW	3,canroll7,F
	WLW	3,canroll8,F
	WLW	3,canroll1,F



	WLW	3,CANB3,F
	WLW	3,CANB4,F
	WLW	3,CANB5,F
	WLW	3,CANB6,F
	WLW	3,CANB7,F
	WLW	3,CANB8,F
	WLW	3,CANB9,F
	WLW	3,CANB10,F
	WLW	3,CANB11,F
	WLW	3,CANB12,F
	WLW	1,CANB13,F

	WLW	-1,seq_slamball,>20


	WLW	4,T1HANG1,F
	WLW	4,T1HANG2,F
	WLW	4,T1HANG3,F
	WLW	4,T1HANG4,F
	WLW	4,T1HANG5,F
	WLW	8,T1HANG6,F
	WLW	4,T1HANG7,F
	WLW	4,T1HANG8,F
	WLW	10h,T1HANG9,F
	WLW	6,T1HANG10,F



;	WLW	8,CANB13,F
;	WLW	18h,CANB14,F
;	WLW	24h,CANB15,F
;	WLW	8,CANB16,F
	WLW	-1,seq_newdir,2*16
	W0

dunkx2_t		;3 direction

	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dx4_l,#DD
	.long	#DD,#DD,#dx4_l,#DD

#dx4_l
	WLW	4,CANB1,F
	WLLW	-1,seq_strtdunk,CANB13,>66
	WLW	3,CANB2,F
	WLL	-1,seq_snd,jet			;RJR

	WLW	2,canroll2,F
	WLW	2,canroll3,F
	WLW	2,canroll4,F
	WLW	2,canroll5,F
	WLW	2,canroll6,F
	WLW	2,canroll7,F
	WLW	2,canroll8,F
	WLW	2,canroll1,F

	WLL	-1,seq_snd,ohmy			;RJR
	WLW	-1,seq_jam_speech,JAM_GREAT	;RJR
	WLW	2,canroll2,F
	WLW	2,canroll3,F
	WLW	2,canroll4,F
	WLW	2,canroll5,F
	WLW	2,canroll6,F
	WLW	2,canroll7,F
	WLW	2,canroll8,F
	WLW	2,canroll1,F

	WLW	2,canroll2,F
	WLW	2,canroll3,F
	WLW	2,canroll4,F
	WLW	2,canroll5,F
	WLW	2,canroll6,F
	WLW	2,canroll7,F
	WLW	2,canroll8,F
	WLW	2,canroll1,F

	WLW	2,canroll2,F
	WLW	2,canroll3,F
	WLW	2,canroll4,F
	WLW	2,canroll5,F
	WLW	2,canroll6,F
	WLW	2,canroll7,F
	WLW	2,canroll8,F
	WLW	2,canroll1,F

	WLW	2,CANB3,F
	WLW	2,CANB4,F
	WLW	2,CANB5,F
	WLW	3,CANB6,F
	WLW	3,CANB7,F
	WLW	3,CANB8,F
	WLW	3,CANB9,F
	WLW	4,CANB10,F
	WLW	4,CANB11,F
	WLW	4,CANB12,F
	WLW	4,CANB13,F

	WLW	-1,seq_slamball,>20
;	WLW	4,CANB13,F



	WLW	4,T1HANG1,F
	WLW	4,T1HANG2,F
	WLW	4,T1HANG3,F
	WLW	4,T1HANG4,F
	WLW	4,T1HANG5,F
	WLW	8,T1HANG6,F
	WLW	4,T1HANG7,F
	WLW	4,T1HANG8,F
	WLW	10h,T1HANG9,F
	WLW	6,T1HANG10,F


;	WLW	18h,CANB14,F
;	WLW	24h,CANB15,F
;	WLW	8,CANB16,F
	WLW	-1,seq_newdir,2*16
	W0

dunkx3_t		;3 direction

	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dx5_l,#DD
	.long	#DD,#DD,#dx5_l,#DD

#dx5_l
	WLW	4,CANB1,F
	WLLW	-1,seq_strtdunk,CANB13,>5c

	WLW	4,CANB2,F
	WLL	-1,seq_snd,jet			;RJR
	WLW	4,CANB3,F
	WLL	-1,seq_snd,ohmy			;RJR
	WLW	4,CANB4,F
	WLW	4,CANB5,F
	WLW	-1,seq_jam_speech,JAM_GREAT	;RJR
	WLW	4,CANB6,F
	WLW	4,CANB7,F
	WLW	4,CANB8,F
	WLW	4,CANB9,F
	WLW	4,CANB10,F
	WLW	4,CANB11,F
	WLW	30h,CANB12,F
	WLW	1,CANB13,F

	WLW	-1,seq_slamball,>20


	WLW	4,T1HANG1,F
	WLW	4,T1HANG2,F
	WLW	4,T1HANG3,F
	WLW	4,T1HANG4,F
	WLW	4,T1HANG5,F
	WLW	8,T1HANG6,F
	WLW	4,T1HANG7,F
	WLW	4,T1HANG8,F
	WLW	10h,T1HANG9,F
	WLW	6,T1HANG10,F



;	WLW	8,CANB13,F
;	WLW	18h,CANB14,F
;	WLW	24h,CANB15,F
;	WLW	8,CANB16,F
	WLW	-1,seq_newdir,2*16
	W0


dunkz_t		;2,3 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dz2a_l,#dz1a_l,#DD
	.long	#DD,#DD,#dz1a_l,#dz2a_l

#dz1a_l
	WLW	4,T2DUNK1,F
#dz2a_l
	WLW	4,T2DUNK2,F
	
	WLLW	-1,seq_strtdunk,T2DUNK6,>50
	WLW	4,T2DUNK3,F
	WLL	-1,seq_snd,yell			;RJR
	WLW	-1,seq_jam_speech,JAM_GOOD	;RJR
	WLW	>42,T2DUNK4,F
	WLW	4,T2DUNK5,F
	WLW	1,T2DUNK6,F

	WLW	-1,seq_slamball,10

	WLW	4,T2DUNK6,F
	WLW	4,T2DUNK7,F
	WLW	15,T2DUNK8,F
	WLW	10,T2DUNK9,F
	WLW	6,T2DUNK10,F

	WLW	-1,seq_newdir,0
	W0

dunkz2_t		;2,3 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dz12a_l,#dz11a_l,#DD
	.long	#DD,#DD,#dz11a_l,#dz12a_l

#dz11a_l
	WLW	4,T2DUNK1,F
#dz12a_l
	WLW	4,T2DUNK2,F
	WLLW	-1,seq_strtdunk,T2DUNK6,>48

	WLW	4,T2DUNK3,F
	WLL	-1,seq_snd,yell			;RJR
	WLW	-1,seq_jam_speech,JAM_GOOD	;RJR
	WLW	>42-12,T2DUNK3,F

	WLW	4,T2DUNK4,F
	WLW	4,T2DUNK5,F
	WLW	1,T2DUNK6,F

	WLW	-1,seq_slamball,10

	WLW	4,T2DUNK6,F
	WLW	4,T2DUNK7,F
	WLW	15,T2DUNK8,F
	WLW	10,T2DUNK9,F
	WLW	6,T2DUNK10,F

	WLW	-1,seq_newdir,0
	W0


	.end

