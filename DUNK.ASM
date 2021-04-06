**************************************************************
*
* Owner:	TURMELL
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
	.file	"plyrdseq.asm"
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
	.include	"plyrdseq.tbl"
;	.include	"dunks.tbl"

;	.include	"imgpal5.asm"

	.def	zwilpal,PLYRFX2_P,XEWILPAL
	.def	PLYRFIX_P
	.def	PLYRRCH_P
	.def	NEWILFIX
	.def	NEWILPAL


;sounds external

;heli_snd	.word	>fdf4,>18,>8154,0	;helicopter
	.ref	heli_snd,yell,tarzan,mnstjam,ohmy,fancy,lookout

;symbols externally defined

	.ref	plyr_shoot
;	.ref	FIREFALP
;	.ref	zwilpal
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

;FIX!!!!  We can get rid of the pal data for these pals in imgpal3 before
;game ships!  Check zwilpal, etc.  All unused pals!
;	.ref	PLYRFX2_P


JAM_NONE	equ	0
JAM_EASY	equ	1
JAM_MED		equ	2
JAM_GOOD	equ	3
JAM_GREAT	equ	4

;symbols defined in this file


;uninitialized ram definitions



;equates for this file

M_YF	.equ	>8000	;Y free (OFLAGS)


	.text

;ohmy	.word	>f981,98,>81ea,0	;OH....MY!!!
;fancy	.word	>f981,76,>812f,0	;fancy move
;airb	.word	>f981,89,>81a4,0	;goes airborne!
;torim	.word	>f981,50,>81a6,0	;to the rim
;hangt	.word	>f981,59,>81a7,0	;hangtime
;lookout	.word	>f981,57,>81b0,0	;lookout!
;showt	.word	>f981,70,>81b7,0	;showtime!
;thawk	.word	>f981,30,>81c0,0	;tomahawks one home!
;facial	.word	>f981,93,>81ee,0	;delivers the facial!
;spectd	.word	>f981,94,>81f5,0	;spectacular dunk
;inface	.word	>f981,81,>81ab,0	;in your face
;mnstjam	.word	>f981,90,>81b2,0	;monster jam

;jet	.word	>fd81,110,>8158,0	;jet sound
;yell	.word	>fde1,88,>8167,0	;aaaaaaaaaaaaaaaahhhhhhhhhhh
;tarzan	.word	>fd91,158,>8177,0	;tarzan yell!

********************************
* Dunk sequences

	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF
	.asg	DUNK_M|NOJUMP_M|NOJOY_M|NOCOLLP_M,DFLGS


;EXAMPLE:

;New dunk art

;Sequence header table
dunka_t
;Art will work from 1 and 2 directions & 3 directio with an extra frame
;added at start of that sequence!

	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#d1_l,#d2_l,#d3_l,#no		;Dirs 1-8
	.long	#no,#no,#d3_l,#d2_l

	.asg	15,N				;ticks per frame

;Sequence list for animations
#d1_l
	WLW	4,M1SPDU1,F
;Create a goto instruction
	WLLW	-1,seq_strtdunk,M1SPDU9,N*4+2	;Next frame begins elevation
						;Last frame before releasing
						;ball, the last frame with
						;Last # is total ticks until
						;player is at rim
	WLW	-1,seq_jam_speech,JAM_EASY	;Anncr excitement level
	WL	-1,seq_call_name		;Anncr says player name
	WLW	3,M1SPDU2,F
	WLW	3,M1SPDU3,F
	WLW	48,M1SPDU4,F
	WLW	4,M1SPDU5,F
	WLW	4,M1SPDU6,F
	WLW	1,M1SPDU7,F
	WLW	-1,seq_slamball,3		;Ball centers in hoop at
						;display of next frame
						;Last cnt is total hang cnt
	WLW	5,M1SPDU7,F
	WLW	260,M1SPDU8,F			;Wait till I land
	WLW	4,M1SPDU9,F
	WLW	4,M1SPDU10,F
	WLW	4,M1SPDU11,F			;Lands on ground
	WLW	-1,seq_newdir,0*16		;dir on 1-8 chart!
	W0

#d3_l
;Use a #3 dunk frame that works with this dunk
	WLW	4,W3SWDU1,F			;Flags
;Just fall into 2 direction dunk!

#d2_l
	WLW	4,M1SPDU1,F
	WLLW	-1,seq_strtdunk,M1SPDU8,N*4+2	;Next frame begins elevation
						;Last frame before releasing
						;ball, the last frame with
						;Last # is total ticks until
						;player is at rim
	WLW	-1,seq_jam_speech,JAM_EASY	;Anncr excitement level
	WL	-1,seq_call_name		;Anncr says player name
	WLW	4,M1SPDU2,F
	WLW	4,M1SPDU3,F
	WLW	4,M1SPDU4,F
	WLW	46,M1SPDU5,F
	WLW	4,M1SPDU6,F
	WLW	1,M1SPDU7,F
	WLW	-1,seq_slamball,3		;Ball centers in hoop at
						;display of next frame
						;Last cnt is total hang cnt
	WLW	5,M1SPDU7,F
	WLW	260,M1SPDU8,F
	WLW	4,M1SPDU9,F
	WLW	4,M1SPDU10,F
	WLW	4,M1SPDU11,F			;Lands on ground
	WLW	-1,seq_newdir,0*16		;dir on 1-8 chart!
#no	W0

#*

;Use dunka again because we can do a different looking dunk using the same
;art.  We just hold on a different frame, jump a little higher or lower, etc.
;Just call it dunka2

dunka2_t
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#d1_l,#d2_l,#d3_l,#no		;Dirs 1-8
	.long	#no,#no,#d3_l,#d2_l

;Sequence list for animations
#d1_l
	WLW	4,M1SPDU1,F
;Create a goto instruction
	WLLW	-1,seq_strtdunk,M1SPDU9,67	;Next frame begins elevation
						;Last frame before releasing
						;ball, the last frame with
						;Last # is total ticks until
						;player is at rim
	WLW	-1,seq_jam_speech,JAM_EASY	;Anncr excitement level
	WL	-1,seq_call_name		;Anncr says player name
	WLW	55,M1SPDU2,F
	WLW	3,M1SPDU3,F
	WLW	3,M1SPDU4,F
	WLW	3,M1SPDU5,F
	WLW	3,M1SPDU6,F
	WLW	1,M1SPDU7,F
	WLW	-1,seq_slamball,8		;Ball centers in hoop at
						;display of next frame
						;Last cnt is total hang cnt
	WLW	5,M1SPDU7,F
	WLW	60,M1SPDU8,F
	WLW	4,M1SPDU9,F
	WLW	4,M1SPDU10,F
	WLW	4,M1SPDU11,F			;Lands on ground
	WLW	-1,seq_newdir,0*16		;dir on 1-8 chart!
	W0

#d3_l
;Use a #3 dunk frame that works with this dunk
	WLW	4,W3SWDU1,F			;Flags
;Just fall into 2 direction dunk!

#d2_l
	WLW	4,M1SPDU1,F
	WLLW	-1,seq_strtdunk,M1SPDU8,67	;Next frame begins elevation
						;Last frame before releasing
						;ball, the last frame with
						;Last # is total ticks until
						;player is at rim
	WLW	-1,seq_jam_speech,JAM_EASY	;Anncr excitement level
	WL	-1,seq_call_name		;Anncr says player name
	WLW	55,M1SPDU2,F
	WLW	3,M1SPDU3,F
	WLW	3,M1SPDU4,F
	WLW	3,M1SPDU5,F
	WLW	3,M1SPDU6,F
	WLW	1,M1SPDU7,F
	WLW	-1,seq_slamball,8		;Ball centers in hoop at
						;display of next frame
						;Last cnt is total hang cnt
	WLW	5,M1SPDU7,F
	WLW	60,M1SPDU8,F
	WLW	4,M1SPDU9,F
	WLW	4,M1SPDU10,F
	WLW	4,M1SPDU11,F			;Lands on ground
	WLW	-1,seq_newdir,0*16		;dir on 1-8 chart!
#no	W0



#********************************

dunkb_t
	.word	DFLGS
	.long	seq_stand
	.long	#db2_l,#db2_l,#db3_l,#DD
	.long	#db5_l,#db2_l,#db3_l,#db2_l


#db2_l
	WLW	2,M3TUKDU2,F
	WLLW	-1,seq_strtdunk,M3TUKDU6,60	;0
	WLW	-1,seq_jam_speech,JAM_EASY
	WL	-1,seq_call_name
	WLW	2,M3TUKDU2,F
	WLW	4,M3TUKDU3,F
	WLW	4,M3TUKDU4,F
	WLW	43,M3TUKDU5,F
	WLW	3,M3TUKDU6,F
	WLW	1,M3TUKDU7,F
	WLW	-1,seq_slamball,5
	WLW	4,M3TUKDU8,F
	WLW	10,M3TUKDU9,F
	WLW	60,M3TUKDU10,F
	WLW	2,M3TUKDU11,F
	WLW	-1,seq_newdir,5*16	;6 dir on 1-8 chart!
	W0

#db3_l
	WLW	2,M3TUKDU2,F
	WLLW	-1,seq_strtdunk,M3TUKDU6,73
	WLW	-1,seq_jam_speech,JAM_EASY
	WL	-1,seq_call_name
	WLW	2,M3TUKDU2,F
	WLW	4,M3TUKDU3,F
	WLW	4,M3TUKDU4,F
	WLW	56,M3TUKDU5,F
	WLW	3,M3TUKDU6,F
	WLW	1,M3TUKDU7,F
	WLW	-1,seq_slamball,5
	WLW	4,M3TUKDU8,F
	WLW	10,M3TUKDU9,F
	WLW	60,M3TUKDU10,F
	WLW	2,M3TUKDU11,F
	WLW	-1,seq_newdir,0*16
	W0

#db5_l
	WLW	2,M3TUKDU2,F
	WLLW	-1,seq_strtdunk,M3TUKDU8,43
	WLW	-1,seq_jam_speech,JAM_EASY
	WL	-1,seq_call_name
	WLW	2,M3TUKDU2,F
	WLW	4,M3TUKDU3,F
	WLW	4,M3TUKDU4,F
	WLW	24,M3TUKDU5,F
	WLW	3,M3TUKDU6,F
	WLW	1,M3TUKDU7,F
	WLW	-1,seq_slamball,9
	WLW	4,M3TUKDU8,F
	WLW	4,M3TUKDU9,F
	WLW	60,M3TUKDU10,F
	WLW	2,M3TUKDU11,F
	WLW	-1,seq_newdir,0*16
#DD	W0

dunkb2_t
	.word	DFLGS
	.long	seq_stand
	.long	#db22_l,#db22_l,#db23_l,#DD
	.long	#DD,#DD,#db23_l,#db22_l


#db22_l
	.asg	14,N
	WLW	4,w1stdu1,F
	WLLW	-1,seq_strtdunk,w1stdu7,N*4+1+10-30
	WLW	-1,seq_jam_speech,JAM_EASY
	WL	-1,seq_call_name
	WLW	N-7,w1stdu2,F
	WLW	N+6+7+7+3+2+4+2-30,w1stdu3,F
	WLW	N-8,w1stdu4,F
	WLW	N-8,w1stdu5,F
	WLW	1,w1stdu6,F

	.asg	10,N			;6
	WLW	-1,seq_slamball,3
	WLW	8,w1stdu6,F
	WLW	N,w1stdu7,F
	WLW	N,w1stdu8,F
	WLW	30,w1stdu9,F
	WLW	6,w1stdu10,F
	WLW	-1,seq_newdir,5*16	;6 dir on 1-8 chart!
	W0


#db23_l
	WLW	2,M3TUKDU2,F
	WLLW	-1,seq_strtdunk,M3TUKDU6,93
	WLW	-1,seq_jam_speech,JAM_EASY
	WL	-1,seq_call_name
	WLW	2,M3TUKDU2,F
	WLW	76,M3TUKDU3,F
	WLW	4,M3TUKDU4,F
	WLW	4,M3TUKDU5,F
	WLW	3,M3TUKDU6,F
	WLW	1,M3TUKDU7,F
	WLW	-1,seq_slamball,5
	WLW	4,M3TUKDU8,F
	WLW	10,M3TUKDU9,F
	WLW	60,M3TUKDU10,F
	WLW	2,M3TUKDU11,F
	WLW	-1,seq_newdir,0*16
	W0

********************************

;Quick version
dunkb3_t
	.word	DFLGS
	.long	seq_stand
	.long	#adb22_l,#adb22_l,#adb23_l,#DD
	.long	#DD,#DD,#adb23_l,#adb22_l


#adb22_l
	WLW	3,w1stdu1,F
	WLLW	-1,seq_strtdunk,w1stdu7,>20
	WLW	-1,seq_jam_speech,JAM_EASY
	WL	-1,seq_call_name
	WLW	4,w1stdu2,F
	WLW	10,w1stdu3,F
	WLW	3,w1stdu4,F
	WLW	3,w1stdu5,F
	WLW	1,w1stdu6,F

	WLW	-1,seq_slamball,3
	WLW	3,w1stdu6,F
	WLW	10,w1stdu7,F
	WLW	10,w1stdu8,F
	WLW	30,w1stdu9,F
	WLW	4,w1stdu10,F
	WLW	-1,seq_newdir,5*16	;6 dir on 1-8 chart!
	W0


#adb23_l
	WLW	3,w3spdu1,F
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,w1stdu6,>20
	WLW	-1,seq_jam_speech,JAM_EASY
	WL	-1,seq_call_name
	WLW	4,w1stdu2,F
	WLW	3,w1stdu3,F
	WLW	15h,w1stdu4,F
	WLW	3,w1stdu5,F
	WLW	1,w1stdu6,F

	WLW	-1,seq_slamball,3
	WLW	3,w1stdu6,F
	WLW	10,w1stdu7,F
	WLW	10,w1stdu8,F
	WLW	30,w1stdu9,F
	WLW	4,w1stdu10,F
	WLW	-1,seq_newdir,5*16
	W0

********************************


dunkc_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dc3_l,#DD
	.long	#DD,#DD,#dc3_l,#DD


#dc3_l
	.asg	15,N
	WLW	4,w4modu1,F
	WLW	4,w4modu2,F
	WLLW	-1,seq_strtdunk,w4modu5,N*4+10
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_call_name
	WLW	5,w4modu3,F
	WLW	N+N+15+5+13,w4modu4,F
	WLW	1,w4modu5,F

	.asg	5,N
	WLW	-1,seq_slamball,7
	WLW	4,w4modu5,F
	WLW	30,w4modu6,F
	WLW	6,w4modu7,F
	WLW	-1,seq_newdir,2*16
	W0


********************************


dunkd_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dd3_l,#dd3_l
	.long	#DD,#dd3_l,#dd3_l,#DD


#dd3_l
	.asg	15,N
	WLW	4,w3ondu1,F
	WLLW	-1,seq_strtdunk,w3ondu7,>38+16
	WLW	6,w3ondu2,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	6,w3ondu3,F
	WLW	35+16,w3ondu4,F
	WLW	5,w3ondu5,F
	WLW	5,w3ondu6,F
	WLW	1,w3ondu7,F

	WLW	-1,seq_slamball,8
	WLW	30-5,w3ondu7,F
	WLW	30-5,w3ondu8,F
	WLW	4,w3ondu8,F
	WLW	-1,seq_newdir,3*16
	W0

dunkd2_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dd2_l,#dd2_l
	.long	#DD,#dd2_l,#dd2_l,#DD


#dd2_l
	.asg	15,N
	WLW	4,w3ondu1,F
	WLLW	-1,seq_strtdunk,w3ondu7,>38+16
	WLW	6,w3ondu2,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	36+16,w3ondu3,F
	WLW	5,w3ondu4,F
	WLW	5,w3ondu5,F
	WLW	5,w3ondu6,F
	WLW	1,w3ondu7,F

	.asg	6,N
	WLW	-1,seq_slamball,8
	WLW	25,w3ondu7,F
	WLW	25,w3ondu8,F
	WLW	4,w3ondu8,F
	WLW	-1,seq_newdir,3*16
	W0


********************************


dunke_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#de3_l,#de3_l
	.long	#DD,#de3_l,#de3_l,#DD


#de3_l
	.asg	15,N
	WLW	4,w3twdu1,F
	WLW	4,w3twdu2,F
	WLLW	-1,seq_strtdunk,w3twdu8,N*4+1
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_call_name
	WLW	N-5,w3twdu3,F
	WLW	N+23,w3twdu4,F
	WLW	6,w3twdu5,F
	WLW	6,w3twdu6,F
	WLW	1,w3twdu7,F

	WLW	-1,seq_slamball,8
	WLW	7,w3twdu7,F
	WLW	>2e,w3twdu8,F
;	WLW	6,w3hang7,F
	WLW	-1,seq_newdir,3*16
	W0

dunke2_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#de4_l,#de4_l
	.long	#DD,#de4_l,#de4_l,#DD


#de4_l
	.asg	15,N
	WLW	4,w3twdu1,F
	WLW	4,w3twdu2,F
	WLLW	-1,seq_strtdunk,w3twdu8,N*4+1
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_call_name
	WLW	6,w3twdu3,F
	WLW	6,w3twdu4,F
	WLW	42,w3twdu5,F
	WLW	6,w3twdu6,F
	WLW	1,w3twdu7,F

	WLW	-1,seq_slamball,8
	WLW	7,w3twdu7,F
	WLW	>2e,w3twdu8,F
;	WLW	6,w3hang7,F
	WLW	-1,seq_newdir,3*16
	W0


********************************


dunkf_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#df2_l,#DD,#DD
	.long	#DD,#DD,#DD,#df2_l


#df2_l
	WLW	4,w1spdu1,F
	WLW	3,w1spdu2,F
	WLW	3,w1spdu3,F
	WLLW	-1,seq_strtdunk,w1spdu10,63
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	4,w1spdu4,F
	WLW	36,w1spdu5,F
	WLW	4,w1spdu6,F
	WLW	4,w1spdu7,F
	WLW	4,w1spdu8,F
	WLW	1,w1spdu9,F

	WLW	-1,seq_slamball,3
	WLW	12,w1spdu9,F
	WLW	40,w1spdu10,F
	WLW	6,w1spdu11,F
	WLW	-1,seq_newdir,0
	W0

;dunkf2_t
;	.word	DFLGS
;	.long	seq_stand
;;	.long	#DD,#df22_l,#DD,#DD
;;	.long	#DD,#DD,#DD,#df22_l
;	.long	#df22_l,#df22_l,#df22_l,#df22_l
;	.long	#df22_l,#df22_l,#df22_l,#df22_l
;
;
;#df22_l
;	WLW	4,w1spdu1,F
;	WLW	3,w1spdu2,F
;	WLW	3,w1spdu3,F
;	WLLW	-1,seq_strtdunk,w1spdu10,63-30+5
;	WLW	4,w1spdu4,F
;	WLW	36-30+5,w1spdu5,F
;	WLW	4,w1spdu6,F
;	WLW	4,w1spdu7,F
;	WLW	4,w1spdu8,F
;	WLW	1,w1spdu9,F
;
;	WLW	-1,seq_slamball,3
;	WLW	12,w1spdu9,F
;	WLW	40,w1spdu10,F
;	WLW	6,w1spdu11,F
;	WLW	-1,seq_newdir,0
;	W0


********************************


dunkg_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#DD,#dg4_l
	.long	#DD,#dg4_l,#DD,#DD


#dg4_l
	.asg	15,N
	WLW	3,w4modu1,F
	WLW	3,w4modu2,F
	WLW	3,w4stdu3,F
	WLLW	-1,seq_strtdunk,w4stdu8,N*4+6-2
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_call_name
;	WLW	6,w4stdu3,F
	WLW	4,w4stdu4,F
	WLW	4,w4stdu5,F
	WLW	N+25,w4stdu6,F
	WLW	6,w4stdu7,F
	WLW	1,w4stdu8,F

	WLW	-1,seq_slamball,10
	WLW	25,w4stdu8,F
	WLW	6,w4stdu3,F
	WLW	-1,seq_newdir,3*16
	W0

dunkg2_t
	.word	DFLGS
	.long	seq_stand
;	.long	#DD,#DD,#DD,#dg24_l
;	.long	#DD,#dg24_l,#DD,#DD
	.long	#dg24_l,#dg24_l,#dg24_l,#dg24_l
	.long	#dg24_l,#dg24_l,#dg24_l,#dg24_l


#dg24_l
	.asg	15,N
	WLW	3,w4modu1,F
	WLW	3,w4modu2,F
	WLW	3,w4stdu3,F
	WLLW	-1,seq_strtdunk,w4stdu8,N*4+6-2-30+26
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_call_name
	WLW	4,w4stdu4,F
	WLW	4,w4stdu5,F
	WLW	N+25-30+26,w4stdu6,F
	WLW	6,w4stdu7,F
	WLW	1,w4stdu8,F

	WLW	-1,seq_slamball,10
	WLW	25,w4stdu8,F
	WLW	6,w4stdu3,F
	WLW	-1,seq_newdir,3*16
	W0

********************************


********************************

dunkj_t
	.word	DFLGS
	.long	seq_stand
	.long	#dj1_l,#dj1_l,#DD,#DD
	.long	#DD,#DD,#DD,#dj1_l


#dj1_l
	.asg	15,N
	WLW	1,w2swdu1,F
	WLLW	-1,seq_strtdunk,w2swdu7,>3e+4+2
	WLW	-1,seq_jam_speech,JAM_MED
	WLL	-1,seq_snd,yell
	WLW	N-4+28+2,w2swdu1,F
	WLW	N-10,w2swdu2,F
	WLW	N-10,w2swdu3,F
	WLW	N-10,w2swdu4,F
	WLW	N-10,w2swdu5,F
	WLW	1,w2swdu6,F

	.asg	10,N
	WLW	-1,seq_slamball,5
	WLW	N,w2swdu6,F
	WLW	N,w2swdu7,F
	WLW	30,w2swdu8,F
	WLW	6,w2swdu9,F
	WLW	-1,seq_newdir,0
	W0

dunkj4_t
	.word	DFLGS
	.long	seq_stand
	.long	#dj1c_l,#dj1c_l,#DD,#DD
	.long	#DD,#DD,#DD,#dj1c_l


#dj1c_l
	.asg	15,N
	WLW	1,w2swdu1,F
	WLLW	-1,seq_strtdunk,w2swdu7,>3e+4+2+10

	WLW	8,w2swdu1,F
	WLW	-1,seq_jam_speech,JAM_MED
	WLL	-1,seq_snd,yell
	WLW	N+28+4,w2swdu1,F

	WLW	N-11,w2swdu2,F
	WLW	N-11,w2swdu3,F
	WLW	N-11,w2swdu4,F
	WLW	N-11,w2swdu5,F
	WLW	1,w2swdu6,F

	.asg	10,N
	WLW	-1,seq_slamball,5
	WLW	N,w2swdu6,F
	WLW	N,w2swdu7,F
	WLW	30,w2swdu8,F
	WLW	6,w2swdu9,F
	WLW	-1,seq_newdir,0
	W0


dunkj2_t
	.word	DFLGS
	.long	seq_stand
	.long	#dj2_l,#dj2_l,#DD,#DD
	.long	#DD,#DD,#DD,#dj2_l


#dj2_l
;	.asg	11,N
	WLW	1,w2swdu1,F
	WLLW	-1,seq_strtdunk,w2swdu8,>3e+8	;N*5-11
	WLW	-1,seq_jam_speech,JAM_MED
	WLL	-1,seq_snd,yell
	WLW	4,w2swdu1,F
	WLW	39+8,w2swdu2,F
	WLW	4,w2swdu3,F
	WLW	4,w2swdu4,F
	WLW	4,w2swdu5,F
	WLW	1,w2swdu6,F

	.asg	10,N
	WLW	-1,seq_slamball,5
	WLW	N,w2swdu6,F
	WLW	N,w2swdu7,F
	WLW	30,w2swdu8,F
	WLW	6,w2swdu9,F
	WLW	-1,seq_newdir,0
	W0

dunkj3_t
	.word	DFLGS
	.long	seq_stand
	.long	#dj2b_l,#dj2a_l,#DD,#DD
	.long	#DD,#DD,#DD,#dj2a_l


#dj2a_l
;	.asg	11,N
	WLW	1,w2swdu1,F
	WLLW	-1,seq_strtdunk,w2swdu8,>3e+8	;N*5-11
	WLW	-1,seq_jam_speech,JAM_MED
	WLL	-1,seq_snd,yell
	WLW	47,w2swdu1,F
	WLW	4,w2swdu2,F
	WLW	4,w2swdu3,F
	WLW	4,w2swdu4,F
	WLW	4,w2swdu5,F
	WLW	1,w2swdu6,F

	.asg	10,N
	WLW	-1,seq_slamball,5
	WLW	N,w2swdu6,F
	WLW	N,w2swdu7,F
	WLW	30,w2swdu8,F
	WLW	6,w2swdu9,F
	WLW	-1,seq_newdir,0
	W0

#dj2b_l
;	.asg	11,N
	WLW	1,w2swdu1,F
	WLLW	-1,seq_strtdunk,w2swdu8,>3e+8	;N*5-11
	WLW	-1,seq_jam_speech,JAM_MED
	WLL	-1,seq_snd,yell
	WLW	4,w2swdu1,F
	WLW	4,w2swdu2,F
	WLW	47,w2swdu3,F
	WLW	4,w2swdu4,F
	WLW	4,w2swdu5,F
	WLW	1,w2swdu6,F

	.asg	10,N
	WLW	-1,seq_slamball,5
	WLW	N,w2swdu6,F
	WLW	N,w2swdu7,F
	WLW	30,w2swdu8,F
	WLW	6,w2swdu9,F
	WLW	-1,seq_newdir,0
	W0


********************************

dunkk_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dk3_l,#dk3_l,#DD
	.long	#DD,#DD,#dk3_l,#dk3_l


#dk3_l
	WLW	3,w1stdu1,F
	WLLW	-1,seq_strtdunk,w2jamdu8,>46
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	5,w2jamdu2,F
	WLW	5,w2jamdu3,F
	WLW	5,w2jamdu4,F
	WLW	>30,w2jamdu5,F
	WLW	4,w2jamdu6,F
	WLW	4,w2jamdu7,F
	WLW	1,w2jamdu8,F

	WLW	-1,seq_slamball,9
	WLW	5,w2jamdu8,F
	WLW	30,w2jamdu9,F
	WLW	6,w2jamdu10,F
	WLW	-1,seq_newdir,1*16
	W0

dunkk2_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dk4_l,#dk4_l,#DD
	.long	#DD,#DD,#dk4_l,#dk4_l


#dk4_l
	WLW	3,w1stdu1,F
	WLLW	-1,seq_strtdunk,w2jamdu8,>46
	WLW	-1,seq_jam_speech,JAM_MED
	WLL	-1,seq_snd,yell
	WLW	4,w2jamdu2,F
	WLW	>31,w2jamdu3,F
	WLW	4,w2jamdu4,F
	WLW	4,w2jamdu5,F
	WLW	4,w2jamdu6,F
	WLW	4,w2jamdu7,F
	WLW	1,w2jamdu8,F

	.asg	5,N
	WLW	-1,seq_slamball,9
	WLW	6,w2jamdu8,F
	WLW	30,w2jamdu9,F
	WLW	6,w2jamdu10,F
	WLW	-1,seq_newdir,1*16
	W0


********************************


dunkl_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dl3_l,#DD
	.long	#DD,#DD,#dl3_l,#DD


#dl3_l
	WLW	3,w3desp1,F
	WLLW	-1,seq_strtdunk,w3flydu8,>54-10	;N*5+1+5
	WLW	4,w3flydu2,F
	WLW	4,w3flydu3,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	4,w3flydu4,F
	WLW	61-12+16-10,w3flydu5,F
	WLW	4,w3flydu6,F
	WLW	4,w3flydu7,F
	WLW	1,w3flydu8,F

	.asg	5,N
	WLW	-1,seq_slamball,6
	WLW	4,w3flydu8,F
	WLW	30,w3flydu9,F
	WLW	6,w3flydu9,F
	WLW	-1,seq_newdir,2*16
	W0

dunkl2_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dl4_l,#DD
	.long	#DD,#DD,#dl4_l,#DD


#dl4_l
	.asg	13,N
	WLW	3,w3desp1,F
	WLLW	-1,seq_strtdunk,w3flydu8,>4b+8-5	;N*5+1+5
	WLW	4,w3flydu2,F

	WLW	4,w3flydu3,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	56+8-9,w3flydu3,F

	WLW	4,w3flydu4,F
	WLW	4,w3flydu5,F
	WLW	4,w3flydu6,F
	WLW	4,w3flydu7,F
	WLW	1,w3flydu8,F

	.asg	5,N
	WLW	-1,seq_slamball,6
	WLW	4,w3flydu8,F
	WLW	30,w3flydu9,F
	WLW	6,w3flydu9,F
	WLW	-1,seq_newdir,2*16
	W0

dunkl3_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dl5_l,#DD
	.long	#DD,#DD,#dl5_l,#DD


#dl5_l
	.asg	13,N
	WLW	3,w3desp1,F
	WLLW	-1,seq_strtdunk,w3flydu8,>4A+5+8-10
	WLW	4,w3flydu2,F
	WLW	4,w3flydu3,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	4,w3flydu4,F
	WLW	>36+5+8-10,w3flydu5,F
	WLW	4,w3flydu6,F
	WLW	4,w3flydu7,F
	WLW	1,w3flydu8,F

	.asg	5,N
	WLW	-1,seq_slamball,6
	WLW	4,w3flydu8,F
	WLW	30,w3flydu9,F
	WLW	6,w3flydu9,F
	WLW	-1,seq_newdir,2*16
	W0

dunkl4_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dl6_l,#DD
	.long	#DD,#DD,#dl6_l,#DD


#dl6_l
	WLW	3,w3desp1,F
	WLLW	-1,seq_strtdunk,w3flydu8,>3f+8
	WLW	4,w3flydu2,F
	WLW	4,w3flydu3,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	4,w3flydu4,F
	WLW	4,w3flydu5,F
	WLW	45+8,w3flydu6,F
	WLW	4,w3flydu7,F
	WLW	1,w3flydu8,F

	.asg	5,N
	WLW	-1,seq_slamball,6
	WLW	4,w3flydu8,F
	WLW	30,w3flydu9,F
	WLW	6,w3flydu9,F
	WLW	-1,seq_newdir,2*16
	W0


********************************

;dunkm_t
;Unused
;	.word	DFLGS
;	.long	seq_stand
;	.long	#DD,#dm3_l,#dm3_l,#dm3_l
;	.long	#DD,#DD,#dm3_l,#dm3_l
;
;
;#dm3_l
;	.asg	11,N
;	WLW	6,w3spdu1,F
;	WLW	6,w3spdu2,F
;	WLLW	-1,seq_strtdunk,w3sp2du11,N*7+1-10
;	WLW	6,w3sp2du3,F
;	WLW	6,w3sp2du4,F
;	WLW	6,w3sp2du5,F
;	WLW	6,w3sp2du6,F
;	WLW	6,w3sp2du7,F
;	WLW	6,w3sp2du8,F
;	WLW	6,w3sp2du7,FF
;	WLW	6,w3sp2du6,FF
;	WLW	6,w3sp2du5,F
;	WLW	6,w3sp2du6,F
;	WLW	6,w3sp2du7,F
;	WLW	6,w3sp2du8,F
;	WLW	1,w3sp2du9,F
;
;	.asg	4,N
;	WLW	-1,seq_slamball,0
;	WLW	N,w3sp2du9,F
;	WLW	30,w3sp2du10,F
;	WLW	6,w3sp2du11,F
;	WLW	-1,seq_newdir,2*16
;	W0


********************************

dunkn_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#DD,#dn5_l
	.long	#dn5_l,#dn5_l,#DD,#DD


#dn5_l
	WLW	3,w5stdu1,F
	WLW	3,w5stdu2,F
	WLW	3,w5stdu3,F
	WLLW	-1,seq_strtdunk,w5stdu5,>3a
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_call_name
	WLW	>3a,w5stdu4,F
	WLW	1,w5stdu5,F

	.asg	7,N
	WLW	-1,seq_slamball,8h
	WLW	N,w5stdu5,F
	WLW	N,w5stdu6,F
;	WLW	N,w5stdu7,F
;	WLW	N,w5stdu8,F
;	WLW	6,w5stdu9,F
;	WLW	16,w5stdu10,F
	WLW	32,w5stdu11,F
	WLW	6,w5stdu12,F
	WLW	6,w5stdu13,F
	WLW	-1,seq_newdir,4*16
	W0

dunkn2_t
	.word	DFLGS
	.long	seq_stand
;	.long	#DD,#DD,#DD,#dn25_l
;	.long	#dn25_l,#dn25_l,#DD,#DD
	.long	#dn25_l,#dn25_l,#dn25_l,#dn25_l
	.long	#dn25_l,#dn25_l,#dn25_l,#dn25_l


#dn25_l
	WLW	3,w5stdu1,F
	WLW	3,w5stdu2,F
	WLW	3,w5stdu3,F
	WLLW	-1,seq_strtdunk,w5stdu5,>3a-15
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_call_name
	WLW	>3a-15,w5stdu4,F
	WLW	1,w5stdu5,F

	.asg	7,N
	WLW	-1,seq_slamball,8h
	WLW	N,w5stdu5,F
	WLW	N,w5stdu6,F
	WLW	32,w5stdu11,F
	WLW	6,w5stdu12,F
	WLW	6,w5stdu13,F
	WLW	-1,seq_newdir,4*16
	W0

********************************

dunko_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#do2_l,#DD,#DD
	.long	#DD,#DD,#DD,#do2_l


#do2_l
	WLW	3,w1spdu1,F
	WLW	2,w1spdu2,F
	WLW	2,w1spdu3,F
	WLLW	-1,seq_strtdunk,w1spdu9,>45
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,heli_snd
	.asg	3,N
	WLW	N,w1spdu4,F
	WLW	N,w1spdu5,F
	WLW	N,w1spdu6,F
	WLW	N,w1spdu7,F
	WLW	N,w1spdu8,F
	WLW	N,w1spdu8,FF
	WLW	N,w1spdu7,FF
	WLW	N,w1spdu6,FF
	WLW	N,w1spdu6,F

	WLW	N,w1spdu7,F
	WLW	N,w1spdu8,F
	WLW	3,w1spdu8,FF
	WLW	3,w1spdu7,FF
	WLW	3,w1spdu6,FF
	WLW	3,w1spdu6,F

	.asg	5,N
	WLW	3,w1spdu7,F
	WLW	N+6,w1spdu8,F
	WLW	1,w1spdu9,F

	.asg	6,N
	WLW	-1,seq_slamball,4
	WLW	7,w1spdu9,F
	WLW	30,w1spdu10,F
	WLW	N,w1spdu11,F
	WLW	-1,seq_newdir,0
	W0


dunko2_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#do3_l,#DD,#DD
	.long	#DD,#DD,#DD,#do3_l


#do3_l
	WLW	3,w1spdu1,F
	WLW	2,w1spdu2,F
	WLW	2,w1spdu3,F
	WLLW	-1,seq_strtdunk,w1spdu10,>48
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,heli_snd
	.asg	4,N
	WLW	N,w1spdu4,F
	WLW	N,w1spdu5,F
	WLW	N,w1spdu6,F
	WLW	N,w1spdu7,F
	WLW	6,w1spdu8,F
	WLW	6,w1spdu8,FF

	WLW	6,w1spdu7,FF
	WLW	6,w1spdu6,FF
	WLW	6,w1spdu6,F
	WLW	8,w1spdu7,F
	WLW	8,w1spdu8,F
	WLW	1,w1spdu9,F

	.asg	6,N
	WLW	-1,seq_slamball,9
	WLW	7,w1spdu9,F
	WLW	30,w1spdu10,F
	WLW	N+4,w1spdu11,F
	WLW	-1,seq_newdir,0
	W0


********************************

dunkp_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dp3_l,#dp3_l
	.long	#dp3_l,#dp3_l,#DD,#DD


#dp3_l
	WLW	3,w3twdu1,F
	WLW	3,w3twdu2,F
	WLLW	-1,seq_strtdunk,w3jmdu10,>42
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	4,w3twdu3,F

	WLW	4,w3jmdu4,F
	WLW	4,w3jmdu5,F
	WLW	>2b,w3jmdu6,F
	WLW	4,w3jmdu7,F
	WLW	4,w3jmdu8,F
	WLW	4,w3jmdu9,F
	WLW	1,w3jmdu10,F

	WLW	-1,seq_slamball,>4
	WLW	4,w3jmdu10,F
	WLW	30,w3jmdu11,F
	WLW	6,w3jmdu11,F
	WLW	-1,seq_newdir,3*16
	W0

dunkp2_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dp4_l,#dp4_l
	.long	#dp4_l,#dp4_l,#DD,#DD


#dp4_l
	WLW	3,w3twdu1,F
	WLW	3,w3twdu2,F
	WLLW	-1,seq_strtdunk,w3jmdu10,>48
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	4,w3twdu3,F

	WLW	4,w3jmdu4,F
	WLW	4,w3jmdu5,F
	WLW	>4,w3jmdu6,F
	WLW	>30,w3jmdu7,F
	WLW	4,w3jmdu8,F
	WLW	4,w3jmdu9,F
	WLW	1,w3jmdu10,F

	.asg	6,N
	WLW	-1,seq_slamball,4
	WLW	7,w3jmdu10,F
	WLW	30,w3jmdu11,F
	WLW	6,w3jmdu11,F
	WLW	-1,seq_newdir,3*16
	W0


dunkp3_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dp5_l,#DD
	.long	#DD,#DD,#dp5_l,#DD


#dp5_l
	WLW	3,w3twdu1,F
	WLW	3,w3twdu2,F
	WLLW	-1,seq_strtdunk,w3jmdu10,>4B	;3b
	WLW	4,w3twdu3,F

	WLW	4,w3jmdu4,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	4,w3jmdu5,F
	WLW	>30,w3jmdu6,F			;>1e+3
	WLW	5,w3jmdu7,F
	WLW	5,w3jmdu8,F
	WLW	5,w3jmdu9,F
	WLW	1,w3jmdu10,F

	WLW	-1,seq_slamball,>14	;4
	WLW	4,w3jmdu10,F

	.asg	5,N
	WLW	N,w3hang1,F
	WLW	N,w3hang2,F
	WLW	N,w3hang3,F
	WLW	N,w3hang4,F
	WLW	N,w3hang5,F
	WLW	14,w3hang6,F
	WLW	6,w3hang7,F
	WLW	-1,seq_newdir,3*16
	W0

********************************


dunkq_t		;1 and 2 directions
	.word	DFLGS
	.long	seq_stand
	.long	#dq1_l,#dq1_l,#DD,#DD
	.long	#DD,#DD,#DD,#dq1_l

#dq1_l
	WLW	3,w1spdu1,F
	WLW	3,w1spdu2,F
	WLLW	-1,seq_strtdunk,w2bhdu8,>4a
	WLW	5,w2bhdu3,F
	WLW	5,w2bhdu4,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	>3a,w2bhdu5,F
	WLW	4,w2bhdu6,F
	WLW	4,w2bhdu7,F
	WLW	1,w2bhdu8,F

	WLW	-1,seq_slamball,>5
	WLW	1ch,w2bhdu8,F
	WLW	8,w2bhdu9,F
	WLW	7,w2bhdu10,F
	WLW	-1,seq_newdir,4*16
	W0


dunkq3_t	;1 and 2 directions
	.word	DFLGS
	.long	seq_stand
	.long	#dq2_l,#dq2_l,#DD,#DD
	.long	#DD,#DD,#DD,#dq2_l


#dq2_l
	WLW	3,w1spdu1,F
	WLW	3,w1spdu2,F
	WLLW	-1,seq_strtdunk,w2bhdu8,>40
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	5,w2bhdu3,F
	WLW	>37,w2bhdu4,F
;	WLW	>32,w2bhdu5,F
	WLW	4,w2bhdu6,F
	WLW	4,w2bhdu7,F
	WLW	1,w2bhdu8,F

	WLW	-1,seq_slamball,>5
	WLW	1ch,w2bhdu8,F
	WLW	8,w2bhdu9,F
	WLW	7,w2bhdu10,F
	WLW	-1,seq_newdir,4*16
	W0


dunkq2_t	;3 direction
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dq3_l,#dq3_l
	.long	#DD,#dq3_l,#dq3_l,#DD


#dq3_l
	WLW	3,w1spdu1,F
	WLW	3,w1spdu2,F
	WLLW	-1,seq_strtdunk,w2bhdu8,>40
	WLW	5,w2bhdu3,F
	WLW	5,w2bhdu4,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	>32,w2bhdu5,F
	WLW	4,w2bhdu6,F
	WLW	4,w2bhdu7,F
	WLW	1,w2bhdu8,F

	WLW	-1,seq_slamball,>5
	WLW	1ch,w2bhdu8,F
	WLW	8,w2bhdu9,F
	WLW	7,w2bhdu10,F
	WLW	-1,seq_newdir,4*16
	W0

dunkq4_t	;3 direction
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dq4_l,#DD
	.long	#DD,#dq4_l,#dq4_l,#DD


#dq4_l
	WLW	3,w3spdu1,F
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,w2bhdu8,>40
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	5,w2bhdu3,F
	WLW	37h,w2bhdu4,F
;	WLW	5,w2bhdu5,F
	WLW	4,w2bhdu6,F
	WLW	4,w2bhdu7,F
	WLW	1,w2bhdu8,F

	WLW	-1,seq_slamball,>5
	WLW	1ch,w2bhdu8,F
	WLW	8,w2bhdu9,F
	WLW	7,w2bhdu10,F
	WLW	-1,seq_newdir,4*16
	W0

********************************

dunkr_t		;2 and 3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dr1_l,#dr1_l,#dr1_l
	.long	#DD,#dr1_l,#dr1_l,#dr1_l

#dr1_l
	WLW	1,w3shdu4,F
	WLLW	-1,seq_strtdunk,w3shdu9,>53-8
	WLW	5,w3shdu4,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	5,w3shdu5,F
	WLW	>3a-8,w3shdu6,F
	WLW	5,w3shdu7,F
	WLW	5,w3shdu8,F
	WLW	1,w3shdu9,F

	WLW	-1,seq_slamball,>6
	WLW	10,w3shdu9,F
	WLW	8,w3shdu10,F
	WLW	20,w3shdu11,F
	WLW	1,w3shdu11,F
	WLW	-1,seq_newdir,4*16
	W0


dunkr2_t	;2 and 3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dr2_l,#dr2_l,#dr2_l
	.long	#DD,#dr2_l,#dr2_l,#dr2_l

#dr2_l
	WLW	1,w3shdu4,F
	WLLW	-1,seq_strtdunk,w3shdu9,>53
	WLW	5,w3shdu4,F

	WLW	5,w3shdu5,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	>3a-4,w3shdu5,F

	WLW	5,w3shdu6,F
	WLW	5,w3shdu7,F
	WLW	5,w3shdu8,F
	WLW	1,w3shdu9,F

	WLW	-1,seq_slamball,>6
	WLW	10,w3shdu9,F
	WLW	8,w3shdu10,F
	WLW	20,w3shdu11,F
	WLW	1,w3shdu11,F
	WLW	-1,seq_newdir,4*16
	W0

********************************

dunks_t		;2 direction
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#ds1_l,#DD,#DD
	.long	#DD,#DD,#DD,#ds1_l

#ds1_l
	WLW	3,w2stdu1,F
	WLW	3,w2stdu2,F
	WLLW	-1,seq_strtdunk,w2stdu9,>3a
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	4,w2stdu3,F
	WLW	4,w2stdu4,F
	WLW	>1b,w2stdu5,F
	WLW	3,w2stdu6,F
	WLW	3,w2stdu7,F
	WLW	3,w2stdu8,F
	WLW	1,w2stdu9,F

	WLW	-1,seq_slamball,>f
	WLW	1fh,w2stdu9,F
	WLW	11,w2stdu8,F
	WLW	4,w2stdu2,F
	WLW	-1,seq_newdir,1*16
	W0


dunks2_t	;2 direction
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#ds2_l,#DD,#DD
	.long	#DD,#DD,#DD,#ds2_l

#ds2_l
	WLW	3,w2stdu1,F
	WLW	3,w2stdu2,F
	WLLW	-1,seq_strtdunk,w2stdu9,>4a
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	4,w2stdu3,F
	WLW	4,w2stdu4,F
	WLW	4,w2stdu5,F
	WLW	4,w2stdu6,F
	WLW	>2a,w2stdu7,F
	WLW	4,w2stdu8,F
	WLW	1,w2stdu9,F

	WLW	-1,seq_slamball,>f
	WLW	26h,w2stdu9,F
	WLW	11,w2stdu8,F
	WLW	4,w2stdu2,F
	WLW	-1,seq_newdir,1*16
	W0


********************************

dunkt_t		;2,3,4 directions

	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dt2_l,#dt1_l,#dt1_l
	.long	#DD,#dt1_l,#dt1_l,#dt2_l

#dt1_l
	WLW	3,w3spdu1,F
#dt2_l
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,w3sp2du15,>28
	WL	-1,seq_call_name
	WLW	4,w3sp2du3,F
	WLW	4,w3sp2du4,F
	WLW	-1,seq_jam_speech,JAM_EASY
	WLW	4,w3sp2du5,F
	WLW	4,w3sp2du6,F
	WLW	4,w3sp2du7,F
	WLW	4,w3sp2du8,F
	WLW	4,w3sp2du9,F
	WLW	4,w3sp2du10,F
	WLW	4,w3sp2du11,F
	WLW	4,w3sp2du12,F
	WLW	4,w3sp2du13,F
	WLW	4,w3sp2du14,F

	WLW	-1,seq_slamball,>3
	WLW	24,w3sp2du14,F
	WLW	30,w3sp2du15,F
	WLW	4,w3sp2du15,F
	WLW	-1,seq_newdir,2*16
	W0

dunkt2_t	;2,3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dt2a_l,#dt1a_l,#dt1a_l
	.long	#DD,#dt1a_l,#dt1a_l,#dt2a_l

#dt1a_l
	WLW	3,w3spdu1,F
#dt2a_l
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,w3sp2du14,>4a
	WLW	3,w3sp2du3,F
	WLW	3,w3sp2du4,F
	WLW	3,w3sp2du5,F
	WLL	-1,seq_snd,yell
	WLW	3,w3sp2du6,F
	WLW	3,w3sp2du7,F
	WLW	3,w3sp2du8,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	3,w3sp2du9,F
	WLW	3,w3sp2du10,F

	WLW	3,w3sp2duA,F
	WLW	3,w3sp2duB,F
	WLW	3,w3sp2duC,F
	WLW	3,w3sp2duD,F
	WLW	3,w3sp2duE,F
	WLW	3,w3sp2du4,F
	WLW	3,w3sp2du5,F
	WLW	3,w3sp2du6,F
	WLW	3,w3sp2du7,F
	WLW	3,w3sp2du8,F
	WLW	3,w3sp2du9,F
	WLW	3,w3sp2du10,F

	WLW	3,w3sp2du11,F
	WLW	3,w3sp2du12,F
	WLW	6,w3sp2du13,F
	WLW	5,w3sp2du14,F

	WLW	-1,seq_slamball,>f
	WLW	>20,w3sp2du14,F
	WLW	>1e,w3sp2du15,F
	WLW	4,w3sp2du15,F
	WLW	-1,seq_newdir,2*16
	W0

dunkt3_t	;2,3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dt2b_l,#dt1b_l,#dt1b_l
	.long	#DD,#dt1b_l,#dt1b_l,#dt2b_l

#dt1b_l
	WLW	3,w3spdu1,F
#dt2b_l
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,w3sp2du15,>30
	WLW	2,w3sp2du3,F
	WLW	2,w3sp2du4,F
	WLW	2,w3sp2du5,F
	WLW	2,w3sp2du6,F
	WLL	-1,seq_snd,lookout
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	2,w3sp2du7,F
	WLW	2,w3sp2du8,F
	WLW	2,w3sp2du9,F
	WLW	2,w3sp2du10,F

	WLW	2,w3sp2duA,F
	WLW	2,w3sp2duB,F
	WLW	2,w3sp2duC,F
	WLW	2,w3sp2duD,F
	WLW	2,w3sp2duE,F
	WLW	2,w3sp2du4,F
	WLW	2,w3sp2du5,F
	WLW	2,w3sp2du6,F
	WLW	2,w3sp2du7,F
	WLW	2,w3sp2du8,F
	WLW	2,w3sp2du9,F
	WLW	2,w3sp2du10,F

	WLW	2,w3sp2du11,F
	WLW	2,w3sp2du12,F
	WLW	6,w3sp2du13,F
	WLW	5,w3sp2du14,F

	WLW	-1,seq_slamball,>8
	WLW	>1c,w3sp2du14,F
	WLW	>1e,w3sp2du15,F
	WLW	4,w3sp2du15,F
	WLW	-1,seq_newdir,2*16
	W0


dunkt4_t	;2,3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dt2c_l,#dt1c_l,#dt1c_l
	.long	#DD,#dt1c_l,#dt1c_l,#dt2c_l

#dt1c_l
	WLW	3,w3spdu1,F
#dt2c_l
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,w3sp2du14,>58
	WLL	-1,seq_snd,heli_snd
	.asg	2,N
	WLW	N,w3sp2du3,F
	WLW	N,w3sp2du4,F
	WLW	N,w3sp2du5,F
	WLW	N,w3sp2du6,F
	WLW	N,w3sp2du7,F
	WLW	N,w3sp2du8,F
	WLW	N,w3sp2du9,F
	WLW	N,w3sp2du10,F

	WLW	N,w3sp2duA,F
	WLW	N,w3sp2duB,F
	WLW	N,w3sp2duC,F
	WLW	N,w3sp2duD,F
	WLW	N,w3sp2duE,F
	WLW	N,w3sp2du4,F
	WLW	N,w3sp2du5,F
	WLW	N,w3sp2du6,F
	WLW	N,w3sp2du7,F
	WLW	N,w3sp2du8,F
	WLW	N,w3sp2du9,F
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,heli_snd
	WLW	N,w3sp2du10,F

	.asg	3,N		;3
	WLW	N,w3sp2duA,F
	WLW	N,w3sp2duB,F
	WLW	N,w3sp2duC,F
	WLW	N,w3sp2duD,F
	WLW	N,w3sp2duE,F
	WLW	N,w3sp2du4,F
	WLW	N,w3sp2du5,F
	WLW	N,w3sp2du6,F
	WLW	N,w3sp2du7,F
	WLW	N,w3sp2du8,F
	WLW	N,w3sp2du9,F
	WLW	N,w3sp2du10,F

	WLW	5,w3sp2du11,F
	WLW	4,w3sp2du12,F
	WLW	4,w3sp2du13,F
	WLW	2,w3sp2du14,F

	WLW	-1,seq_slamball,>f
	WLW	>1c,w3sp2du14,F
	WLW	>1e,w3sp2du15,F
	WLW	4,w3sp2du15,F
	WLW	-1,seq_newdir,2*16
	W0

dunkt5_t	;2,3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dt2d_l,#dt1d_l,#dt1d_l
	.long	#DD,#dt1d_l,#dt1d_l,#dt2d_l

#dt1d_l
	WLW	3,w3spdu1,F
#dt2d_l
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,w3sp2du14,>50
	.asg	1,N	;2
	WLW	N,w3sp2du3,F
	WLW	N,w3sp2du4,F
	WLW	N,w3sp2du5,F
	WLW	N,w3sp2du6,F
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,ohmy
	WLW	N,w3sp2du7,F
	WLW	N,w3sp2du8,F
	WLW	N,w3sp2du9,F
	WLW	N,w3sp2du10,F

	WLW	N,w3sp2duA,F
	WLW	N,w3sp2duB,F
	WLW	N,w3sp2duC,F
	WLW	N,w3sp2duD,F
	WLW	N,w3sp2duE,F
	WLW	N,w3sp2du4,F
	WLW	N,w3sp2du5,F
	WLW	N,w3sp2du6,F
	WLW	N,w3sp2du7,F
	WLW	N,w3sp2du8,F
	WLW	N,w3sp2du9,F
	WLW	N,w3sp2du10,F

	.asg	4,N		;3
	WLW	N,w3sp2duA,F
	WLW	N,w3sp2duB,F
	WLW	N,w3sp2duC,F
	WLW	N,w3sp2duD,F
	WLW	N,w3sp2duE,F
	WLW	N,w3sp2du4,F
	WLW	N,w3sp2du5,F
	WLW	N,w3sp2du6,F
	WLW	N,w3sp2du7,F
	WLW	N,w3sp2du8,F
	WLW	N,w3sp2du9,F
	WLW	N,w3sp2du10,F

	WLW	5,w3sp2du11,F
	WLW	4,w3sp2du12,F
	WLW	4,w3sp2du13,F
	WLW	2,w3sp2du14,F

	WLW	-1,seq_slamball,>f
	WLW	>1c,w3sp2du14,F
	WLW	>1e,w3sp2du15,F
	WLW	4,w3sp2du15,F
	WLW	-1,seq_newdir,2*16
	W0

;dunkt6_t	;2,3,4 directions
;
;	.word	DFLGS
;	.long	seq_stand
;;	.long	#DD,#dt62_l,#dt61_l,#dt61_l
;;	.long	#DD,#dt61_l,#dt61_l,#dt62_l
;	.long	#dt62_l,#dt62_l,#dt61_l,#dt61_l
;	.long	#dt62_l,#dt61_l,#dt61_l,#dt62_l
;
;#dt61_l
;	WLW	4,w3spdu1,F
;#dt62_l
;	WLW	4,w3spdu2,F
;	WLLW	-1,seq_strtdunk,w3sp2du15,>28-15-3
;	WLW	3,w3sp2du3,F
;	WLW	3,w3sp2du4,F
;	WLW	3,w3sp2du5,F
;	WLW	3,w3sp2du6,F
;	WLW	3,w3sp2du7,F
;	WLW	3,w3sp2du8,F
;	WLW	3,w3sp2du9,F
;	WLW	3,w3sp2du10,F
;	WLW	3,w3sp2du11,F
;	WLW	3,w3sp2du12,F
;	WLW	2,w3sp2du13,F
;	WLW	2,w3sp2du14,F
;
;	WLW	-1,seq_slamball,>0
;	WLW	21,w3sp2du14,F
;	WLW	30,w3sp2du15,F
;	WLW	4,w3sp2du15,F
;	WLW	-1,seq_newdir,2*16
;	W0


********************************

dunku_t		;3 direction in close

	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#du1_l,#DD
	.long	#DD,#DD,#du1_l,#DD

#du1_l
	WLW	3,w3flydu2,F
	WLLW	-1,seq_strtdunk,w3wmdu8,>42

	WLW	4,w3wmdu3,F
	WLL	-1,seq_snd,yell
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	>2e-4,w3wmdu3,F

	WLW	4,w3wmdu4,F
	WLW	4,w3wmdu5,F
	WLW	4,w3wmdu6,F
	WLW	4,w3wmdu7,F
	WLW	1,w3wmdu8,F

	WLW	-1,seq_slamball,>3
	WLW	4,w3wmdu8,F
	WLW	30,w3wmdu9,F
	WLW	4,w3wmdu10,F
	WLW	-1,seq_newdir,2*16
	W0

dunku2_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#du2_l,#DD
	.long	#DD,#DD,#du2_l,#DD

#du2_l
	WLW	3,w3flydu2,F
	WLLW	-1,seq_strtdunk,w3wmdu8,>4b
	WLW	4,w3wmdu3,F

	WLL	-1,seq_snd,yell
	WLW	>14,w3wmdu4,F
	WLL	-1,seq_snd,mnstjam
	WLW	-1,seq_jam_speech,JAM_NONE
	WLW	24h,w3wmdu4,F


	WLW	4,w3wmdu5,F
	WLW	4,w3wmdu6,F
	WLW	4,w3wmdu7,F
	WLW	1,w3wmdu8,F

	WLW	-1,seq_slamball,>3
	WLW	4,w3wmdu8,F
	WLW	30,w3wmdu9,F
	WLW	4,w3wmdu10,F
	WLW	-1,seq_newdir,2*16
	W0

dunku3_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#du3_l,#DD
	.long	#DD,#DD,#du3_l,#DD

#du3_l
	WLW	3,w3flydu2,F
	WLLW	-1,seq_strtdunk,w3wmdu8,>4b

	WLW	4,w3wmdu3,F
	WLL	-1,seq_snd,yell
	WLW	>21-4,w3wmdu3,F

	WLL	-1,seq_snd,lookout
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	4,w3wmdu4,F
	WLW	4,w3wmduA,F
	WLW	4,w3wmduB,F
	WLW	4,w3wmduC,F
	WLW	4,w3wmduD,F
	WLW	4,w3wmduE,F
	WLW	4,w3wmdu4,F

	WLW	4,w3wmdu5,F
	WLW	4,w3wmdu6,F
	WLW	4,w3wmdu7,F
	WLW	1,w3wmdu8,F

	WLW	-1,seq_slamball,>3
	WLW	4,w3wmdu8,F
	WLW	30,w3wmdu9,F
	WLW	4,w3wmdu10,F
	WLW	-1,seq_newdir,2*16
	W0

dunku4_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#du4_l,#DD
	.long	#DD,#DD,#du4_l,#DD

#du4_l
	WLW	3,w3flydu2,F
	WLLW	-1,seq_strtdunk,w3wmdu8,>4b

	WLW	4,w3wmdu3,F
	WLL	-1,seq_snd,yell
	WLW	>21-4,w3wmdu3,F

	WLL	-1,seq_snd,lookout
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	2,w3wmdu4,F
	WLW	2,w3wmduA,F
	WLW	2,w3wmduB,F
	WLW	2,w3wmduC,F
	WLW	2,w3wmduD,F
	WLW	2,w3wmduE,F
	WLW	2,w3wmdu4,F




	WLW	2,w3wmdu4,F
	WLW	2,w3wmduA,F
	WLW	2,w3wmduB,F
	WLW	2,w3wmduC,F
	WLW	2,w3wmduD,F
	WLW	2,w3wmduE,F
	WLW	2,w3wmdu4,F



	WLW	4,w3wmdu5,F
	WLW	4,w3wmdu6,F
	WLW	4,w3wmdu7,F
	WLW	1,w3wmdu8,F

	WLW	-1,seq_slamball,>6
	WLW	4,w3wmdu8,F
	WLW	30,w3wmdu9,F
	WLW	4,w3wmdu10,F
	WLW	-1,seq_newdir,2*16
	W0

dunku5_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#du5_l,#DD
	.long	#DD,#DD,#du5_l,#DD

#du5_l
	WLW	3,w3flydu2,F
	WLLW	-1,seq_strtdunk,w3wmdu8,>48
	WLW	4,w3wmdu3,F

	WLL	-1,seq_snd,yell
	WLW	>1c,w3wmdu4,F
	WLW	-1,seq_jam_speech,JAM_NONE


	WLW	4,w3wmduA,F
	WLW	4,w3wmduB,F
	WLL	-1,seq_snd,mnstjam
	WLW	4,w3wmduC,F
	WLW	4,w3wmduD,F
	WLW	4,w3wmduE,F
	WLW	4,w3wmdu4,F

	WLW	4,w3wmdu5,F
	WLW	4,w3wmdu6,F
	WLW	4,w3wmdu7,F
	WLW	1,w3wmdu8,F

	WLW	-1,seq_slamball,>6
	WLW	4,w3wmdu8,F
	WLW	30,w3wmdu9,F
	WLW	4,w3wmdu10,F
	WLW	-1,seq_newdir,2*16
	W0

dunku6_t
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#du6_l,#DD
	.long	#DD,#DD,#du6_l,#DD

#du6_l
	WLW	3,w3flydu2,F
	WLLW	-1,seq_strtdunk,w3wmdu8,>48
	WLW	6,w3wmdu3,F
	WLL	-1,seq_snd,yell
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	6,w3wmdu4,F
	WLW	>31,w3wmdu5,F

	WLW	4,w3wmdu6,F
	WLW	4,w3wmdu7,F
	WLW	1,w3wmdu8,F

	WLW	-1,seq_slamball,>6
	WLW	4,w3wmdu8,F
	WLW	30,w3wmdu9,F
	WLW	4,w3wmdu10,F
	WLW	-1,seq_newdir,2*16
	W0



********************************

dunkv_t		;3 direction in close

	.word	DFLGS
	.long	seq_stand
	.long	#dv1_l,#DD,#DD,#DD
	.long	#DD,#DD,#DD,#DD

#dv1_l
	WLW	3,w1stdu1,FF
	WLLW	-1,seq_strtdunk,w1dpdu13,>4f
	WLW	5,w1dpdu3,F
	WLW	5,w1dpdu4,F

	WLW	4,w1dpdu5,F
	WLW	-1,seq_jam_speech,JAM_MED
	WLL	-1,seq_snd,yell
	WLW	>35-4,w1dpdu5,F

	WLW	4,w1dpdu6,F
	WLW	4,w1dpdu7,F
	WLW	4,w1dpdu8,F
	WLW	4,w1dpdu9,F
	WLW	1,w1dpdu10,F

	WLW	-1,seq_slamball,>3
	WLW	16,w1dpdu10,F
	WLW	6,w1spdu10,F
	WLW	6,w1spdu11,F
	WLW	4,w1dpdu13,F
	WLW	-1,seq_newdir,0
	W0

dunkv2_t

	.word	DFLGS
	.long	seq_stand
	.long	#dv2_l,#DD,#DD,#DD
	.long	#DD,#DD,#DD,#DD

#dv2_l
	WLW	3,w1stdu1,FF
	WLLW	-1,seq_strtdunk,w1dpdu13,>4f
	WLW	5,w1dpdu3,F
	WLW	5,w1dpdu4,F
	WLW	4,w1dpdu5,F
	WLW	4,w1dpdu6,F
	WLW	-1,seq_jam_speech,JAM_MED
	WLL	-1,seq_snd,yell
	WLW	>35,w1dpdu7,F
	WLW	4,w1dpdu8,F
	WLW	4,w1dpdu9,F
	WLW	1,w1dpdu10,F

	WLW	-1,seq_slamball,>3
	WLW	16,w1dpdu10,F
	WLW	6,w1spdu10,F
	WLW	6,w1spdu11,F
	WLW	4,w1dpdu13,F
	WLW	-1,seq_newdir,0
	W0

********************************

dunkw_t		;2 direction

	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dw1_l,#DD,#DD
	.long	#DD,#DD,#DD,#dw1_l

#dw1_l
	WLW	3,w2wmdu1,FF
	WLLW	-1,seq_strtdunk,w2wmdu8,>4f

	WLW	7,w2wmdu2,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLL	-1,seq_snd,yell
	WLW	>3a-10,w2wmdu2,F

	WLW	5,w2wmdu3,F
	WLW	5,w2wmdu4,F
	WLW	5,w2wmdu5,F
	WLW	5,w2wmdu6,F
	WLW	4,w2wmdu7,F

	WLW	-1,seq_slamball,>3
	WLW	3,w2wmdu7,F
	WLW	32,w2wmdu8,F
	WLW	4,w2wmdu9,F
	WLW	-1,seq_newdir,0
	W0

dunkw2_t

	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dw2_l,#DD,#DD
	.long	#DD,#DD,#DD,#dw2_l

#dw2_l
	WLW	3,w2wmdu1,FF
	WLLW	-1,seq_strtdunk,w2wmdu8,>4f
;	WLW	6,w2wmdu2,F

	WLW	4,w2wmdu3,F
	WLL	-1,seq_snd,yell
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	>3f-7,w2wmdu3,F

	WLW	5,w2wmdu4,F
	WLW	5,w2wmdu5,F
	WLW	5,w2wmdu6,F
	WLW	4,w2wmdu7,F

	WLW	-1,seq_slamball,>3
	WLW	3,w2wmdu7,F
	WLW	32,w2wmdu8,F
	WLW	4,w2wmdu9,F
	WLW	-1,seq_newdir,0
	W0

dunkw3_t		;2 direction

	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dw3_l,#DD,#DD
	.long	#DD,#DD,#DD,#dw3_l

#dw3_l
	WLW	3,w2wmdu1,FF
	WLLW	-1,seq_strtdunk,w2wmdu8,>3d
	WLL	-1,seq_snd,yell
	WLW	5,w2wmdu2,F
	WLL	-1,seq_snd,fancy
	WLW	5,w2wmdu3,F
	WLW	5,w2wmdu4,F
	WLW	5,w2wmdu5,F
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	>2a-3,w2wmdu6,F
	WLW	4,w2wmdu7,F			;1

	WLW	-1,seq_slamball,>3
	WLW	3,w2wmdu7,F
	WLW	32,w2wmdu8,F
	WLW	4,w2wmdu9,F
	WLW	-1,seq_newdir,0
	W0


********************************

dunky_t		;2,3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dy2a_l,#dy1a_l,#dy1a_l
	.long	#DD,#dy1a_l,#dy1a_l,#dy2a_l

#dy1a_l
	WLW	3,w3spdu1,F
#dy2a_l
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,thangdu6,>50	;48
	WLW	3,w3sp2du3,F
	WLW	3,w3sp2du4,F
	WLW	3,w3sp2du5,F
	WLW	3,w3sp2du6,F
	WLW	3,w3sp2du7,F
	WLL	-1,seq_snd,yell
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLW	3,w3sp2du8,F
	WLW	3,w3sp2du9,F
	WLW	3,w3sp2du10,F

	WLW	3,w3sp2duA,F
	WLW	3,w3sp2duB,F
	WLW	3,w3sp2duC,F
	WLW	3,w3sp2duD,F
	WLW	3,w3sp2duE,F
	WLW	3,w3sp2du4,F
	WLW	3,w3sp2du5,F
	WLW	3,w3sp2du6,F
	WLW	3,w3sp2du7,F
	WLW	3,w3sp2du8,F
	WLW	3,w3sp2du9,F
	WLW	3,w3sp2du10,F

	WLW	3,thangdu1,F
	WLW	3,thangdu2,F
	WLW	13,thangdu3,F
	WLW	3,thangdu4,F
	WLW	1,thangdu5,F

	WLW	-1,seq_slamball,25

	WLW	2,thangdu5,F
	WLW	4,thangdu6,F
	WLW	4,thangdu7,F
	WLW	15,thangdu8,F
	WLW	15,thangdu9,F
	WLW	15,thangdu10,F
	WLW	8,thangdu11,F

	WLW	-1,seq_newdir,4*16
	W0

dunky2_t		;2,3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dy4a_l,#dy3a_l,#dy3a_l
	.long	#DD,#dy3a_l,#dy3a_l,#dy4a_l

#dy3a_l
	WLW	3,w3spdu1,F
#dy4a_l
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,thangdu6,>50	;48
	WLW	4,w3sp2du3,F
	WLW	4,w3sp2du4,F
	WLW	4,w3sp2du5,F
	WLW	4,w3sp2du6,F
	WLL	-1,seq_snd,yell
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLW	4,w3sp2du7,F
	WLW	4,w3sp2du8,F
	WLW	4,w3sp2du9,F
	WLW	4,w3sp2du10,F

	WLW	4,thangdu1,F
	WLW	4,thangdu2,F
	WLW	13+11*3-8,thangdu3,F
	WLW	4,thangdu4,F
	WLW	1,thangdu5,F

	WLW	-1,seq_slamball,25

	WLW	2,thangdu5,F
	WLW	4,thangdu6,F
	WLW	4,thangdu7,F
	WLW	15,thangdu8,F
	WLW	15,thangdu9,F
	WLW	15,thangdu10,F
	WLW	8,thangdu11,F

	WLW	-1,seq_newdir,4*16
	W0

********************************


dunkz3_t		;2,3 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#d1y4a_l,#d1y3a_l,#DD
	.long	#DD,#DD,#d1y3a_l,#d1y4a_l

#d1y3a_l
	WLW	3,w3spdu1,F
#d1y4a_l
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,T2DUNK6,>58
	WLW	3,w3sp2du3,F
	WLL	-1,seq_snd,tarzan
	WLW	3,w3sp2du4,F
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLW	3,w3sp2du5,F
	WLW	3,w3sp2du6,F
	WLW	3,w3sp2du7,F
	WLW	3,w3sp2du8,F
	WLW	3,w3sp2du9,F
	WLW	3,w3sp2du10,F
	WLW	3,w3sp2duA,F
	WLW	3,w3sp2duB,F
	WLW	3,w3sp2duC,F
	WLW	3,w3sp2duD,F


	.ref	T2DUNK3,T2DUNK4,T2DUNK5
	.ref	T2DUNK6,T2DUNK7,T2DUNK8,T2DUNK9
	.ref	T2DUNK10


	WLW	4,T2DUNK3,F
	WLW	4,T2DUNK4,F
	WLW	>44-22,T2DUNK5,F
	WLW	1,T2DUNK6,F

	WLW	-1,seq_slamball,6
	WLW	4,T2DUNK6,F
	WLW	4,T2DUNK7,F
	WLW	15,T2DUNK8,F
	WLW	10,T2DUNK9,F
	WLW	6,T2DUNK10,F


	WLW	-1,seq_newdir,4*16
	W0

********************************

dunkz4_t		;1,2,3 directions
dunkz5_t		;1,2,3 directions
dunkz6_t		;1,2,3 directions
dunkz7_t		;1,2,3 directions
dunkz8_t		;1,2,3 directions
dunkz9_t		;1,2,3 directions
dunkz10_t		;1,2,3 directions
dunkz11_t		;1,2,3 directions

	.IF	0

	.word	DFLGS
	.long	seq_stand
	.long	#dzaa_l,#dzaa_l,#dzaa_l,#DD
	.long	#DD,#DD,#dzaa_l,#dzaa_l

;	.word	DFLGS
;	.long	seq_stand
;	.long	#dj1_l,#dj1_l,#DD,#DD
;	.long	#DD,#DD,#DD,#dj1_l

#dzaa_l
	WLW	3,w2nda01,F
	WLLW	-1,seq_strtdunk,w2nda10,>48	;48
	WLW	4,w2nda02,F
	WLW	4,w2nda03,F
	WLL	-1,seq_snd,yell
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLW	>32,w2nda04,F
	WLW	4,w2nda05,F
	WLW	4,w2nda06,F
	WLW	4,w2nda07,F
	WLW	4,w2nda08,F

	WLW	-1,seq_slamball,4

	WLW	>36,w2nda09,F
	WLW	4,w2nda10,F
	WLW	4,w2nda11,F
	WLW	4,w2nda12,F

	WLW	-1,seq_newdir,1*16
	W0

********************************
#*

dunkz5_t		;1,2,3 directions
	.word	DFLGS
	.long	seq_stand
	.long	#dzaa_l,#dzaa_l,#dzaa_l,#DD
	.long	#DD,#DD,#dzaa_l,#dzaa_l

#dzaa_l
	WLW	2,w2nda01,F
	WLLW	-1,seq_strtdunk,w2nda10,>20	;48
	WLW	3,w2nda02,F
	WLW	-1,seq_jam_speech,JAM_EASY
	WLW	>22,w2nda07,F
	WLW	4,w2nda08,F

	WLW	-1,seq_slamball,4

	WLW	>36,w2nda09,F
	WLW	4,w2nda10,F
	WLW	4,w2nda11,F
	WLW	4,w2nda12,F

	WLW	-1,seq_newdir,1*16
#DD	W0

********************************
#*

dunkz6_t		;1,2,3 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dzaa_l,#dzaa_l
	.long	#DD,#dzaa_l,#dzaa_l,#DD

#dzaa_l
	WLW	2,w3ndb01,F
	WLLW	-1,seq_strtdunk,w3ndb09,>48
	WLW	3,w3ndb02,F
	WLL	-1,seq_snd,yell
	WLW	3,w3ndb03,F
	WLW	>36,w3ndb04,F
	WLW	3,w3ndb05,F
	WLW	3,w3ndb06,F
	WLW	3,w3ndb07,F
	WLW	3,w3ndb08,F

	WLW	-1,seq_slamball,4

	WLW	13,w3ndb08,F
	WLW	>30,w3ndb09,F
	WLW	3,w3ndb10,F
	WLW	3,w3ndb11,F

	WLW	-1,seq_newdir,3*16
#DD	W0

********************************
#*

dunkz7_t		;1,2,3 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dzaa_l,#dzaa_l
	.long	#DD,#dzaa_l,#dzaa_l,#DD

#dzaa_l
	WLW	2,w3ndb01,F
	WLLW	-1,seq_strtdunk,w3ndb10,>20
;	WLL	-1,seq_snd,yell
	WLW	>8,w3ndb02,F
	WLW	1,w3ndb03,F
	WLW	1,w3ndb04,F
	WLW	1,w3ndb05,F
	WLW	1,w3ndb06,F
	WLW	1,w3ndb07,F
	WLW	1,w3ndb08,F

	WLW	-1,seq_slamball,4

	WLW	13,w3ndb08,F
	WLW	>30,w3ndb09,F
	WLW	3,w3ndb10,F
	WLW	3,w3ndb11,F

	WLW	-1,seq_newdir,3*16
#DD	W0


********************************
#*

dunkz8_t		;1,2,3 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dzaa_l,#dzaa_l
	.long	#DD,#dzaa_l,#dzaa_l,#DD

#dzaa_l
	WLW	2,w3ndc01,F
	WLLW	-1,seq_strtdunk,w3ndc10,>50
	WLL	-1,seq_snd,yell
	WLW	3,w3ndc02,F
	WLW	3,w3ndc03,F
	WLW	3,w3ndc04,F
	WLW	3,w3ndc05,F
	WLW	>40,w3ndc06,F
	WLW	3,w3ndc07,F
	WLW	3,w3ndc08,F
	WLW	1,w3ndc09,F

	WLW	-1,seq_slamball,14h

	WLW	13,w3ndc09,F
	WLW	>40,w3ndc10,F
	WLW	3,w3ndc11,F

	WLW	-1,seq_newdir,3*16
#DD	W0

********************************
#*

dunkz9_t		;2,3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#dy4a_l,#dy3a_l,#dy3a_l
	.long	#DD,#dy3a_l,#dy3a_l,#dy4a_l

#dy3a_l
	WLW	3,w3spdu1,F
#dy4a_l
	WLW	3,w3spdu2,F
	WLLW	-1,seq_strtdunk,thangdu6,>58	;48
	WLW	4,w3sp2du3,F
	WLW	4,w3sp2du4,F
	WLW	4,w3sp2du5,F
	WLW	4,w3sp2du6,F
	WLL	-1,seq_snd,yell
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLW	4,w3sp2du7,F
	WLW	4,w3sp2du8,F
	WLW	4,w3sp2du9,F
	WLW	4,w3sp2du10,F

	WLW	4,w3ndc03,F
	WLW	4,w3ndc04,F
	WLW	4,w3ndc05,F
	WLW	>28,w3ndc06,F			;40h
	WLW	3,w3ndc07,F
	WLW	3,w3ndc08,F
	WLW	1,w3ndc09,F

	WLW	-1,seq_slamball,14h

	WLW	13,w3ndc09,F
	WLW	>40,w3ndc10,F
	WLW	3,w3ndc11,F

	WLW	-1,seq_newdir,3*16
#DD	W0

********************************
#*

dunkz10_t		;2,3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dy3a_l,#DD
	.long	#DD,#DD,#dy3a_l,#DD

#dy3a_l
	WLW	3,w3ndd01,F
	WLLW	-1,seq_strtdunk,w3ndd15,>48
	WLL	-1,seq_snd,yell
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLW	2,w3ndd02,F
	WLW	2,w3ndd03,F
	WLW	2,w3ndd04,F
	WLW	2,w3ndd05,F
	WLW	2,w3ndd06,F
	WLW	2,w3ndd07,F
	WLW	2,w3ndd08,F
	WLW	2,w3ndd09,F
	WLW	2,w3ndd10,F
	WLW	2,w3ndd11,F
	WLW	2,w3ndd12,F
	WLW	2,w3ndd13,F
	WLW	2,w3ndd14,F
	WLW	>30,w3ndd04,F
	WLW	1,w3ndd15,F

	WLW	-1,seq_slamball,5

	WLW	5,w3ndd15,F
	WLW	>30,w3ndd16,F
	WLW	>5,w3ndd17,F

	WLW	-1,seq_newdir,3*16
#DD	W0

********************************
#*

dunkz11_t		;2,3,4 directions
	.word	DFLGS
	.long	seq_stand
	.long	#DD,#DD,#dy3a_l,#DD
	.long	#DD,#DD,#dy3a_l,#DD

#dy3a_l
	WLW	4,w3ndd01,F
	WLW	4,w3ndd02,F
	WLLW	-1,seq_strtdunk,w3ndd15,>58
	WLL	-1,seq_snd,yell
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLW	4,w3ndd03,F
	WLW	>3d,w3ndd04,F
	WLW	2,w3ndd05,F
	WLW	2,w3ndd06,F
	WLW	2,w3ndd07,F
	WLW	2,w3ndd08,F
	WLW	2,w3ndd09,F
	WLW	2,w3ndd10,F
	WLW	2,w3ndd11,F
	WLW	2,w3ndd12,F
	WLW	2,w3ndd13,F
	WLW	2,w3ndd14,F
	WLW	1,w3ndd15,F

	WLW	-1,seq_slamball,5

	WLW	5,w3ndd15,F
	WLW	>30,w3ndd16,F
	WLW	>5,w3ndd17,F

	WLW	-1,seq_newdir,3*16
#DD	W0

********************************


	.ENDIF


#*
hook_t
hook2_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2

	.asg	4,N
#1
	WLW	N,w1hks1,F
	WL	-1,seq_jump
	WLW	N,w1hks2,F
	WLW	1,w1hks3,F
	WL	-1,plyr_shoot
	WLW	N-1,w1hks3,F
	WLW	50,w1hks4,F
	WLW	4,w1hks5,F
	WLW	N,w1hks6,F
	WLW	-1,seq_newdir,2*16
	W0
#2
#3
#4
#5
	WLW	N,w5hks1,F
	WL	-1,seq_jump
	WLW	N,w4hks1,F
	WLW	N,w4hks2,F
	WLW	N,w4hks3,F
	WL	-1,plyr_shoot
	WLW	50,w4hks4,F
	WLW	N,w4hks5,F
	WLW	N,w4hks6,F
	WLW	-1,seq_newdir,2*16
	W0

#*
********************************

dunklay7_t		;1,2,3 directions
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#dzaa_l,#dzaa_l,#dzaa_l,#DD
	.long	#DD,#DD,#dzaa_l,#dzaa_l

#dzaa_l


	.IF	0


	WLW	3,w2nda01,F
	WLLW	-1,seq_strtdunk,w2nda11,>40 		;48
	WLW	3,w2nda02,F
	WLW	>13,w2nda03,F
	WL	-1,seq_lay_up_start
	WLW	>20,w2nda03,F
	WLW	4,w2nda07,F
	WL	-1,plyr_shoot
	WLW	>34,w2nda08,F
	WLW	4,w2nda10,F
	WLW	4,w2nda11,F
	WLW	4,w2nda12,F

	.ENDIF


	WLW	-1,seq_newdir,1*16
#DD	W0

********************************
#*
dunklay2_t		;2,3,4,5 directions
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#dj1_l,#dj1_l,#DD,#DD
	.long	#DD,#DD,#DD,#dj1_l

#dj1_l
	WLW	1,w2swdu4,F
	WLLW	-1,seq_strtdunk,w2swdu1,>3a
	WLW	22,w2swdu4,F
	WL	-1,seq_lay_up_start
	WLW	4,w2swdu3,F
	WLW	4,w2swdu2,F
	WLW	1,w2swdu1,F
	WL	-1,plyr_shoot
	WLW	50,w2swdu1,F
	WLW	5,w2swdu2,F
	WLW	-1,seq_newdir,1*16
#DD	W0

#*
dunklay3_t
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#DD,#DD,#dl3_l,#DD
	.long	#DD,#DD,#dl3_l,#DD


#dl3_l
	WLW	4,w3desp1,F
	WLLW	-1,seq_strtdunk,w3flydu8,>3a
	WLW	4,w3flydu2,F
	WLW	4,w3flydu3,F
	WLW	4,w3flydu4,F
	WLW	30,w3flydu5,F
	WL	-1,seq_lay_up_start
	WLW	4,w3flydu6,F
	WLW	4,w3flydu7,F

	.ref	w2fgrl3,w2fgrl2,w2fgrl1

	WLW	1,w2fgrl3,F
	WL	-1,plyr_shoot
	WLW	5,w2fgrl3,F
	WLW	6,w2fgrl2,F
	WLW	50,w2fgrl1,F
	WLW	-1,seq_newdir,1*16
	W0
#DD	W0

#*
dunklay3a_t
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#DD,#DD,#dl3_l,#DD
	.long	#DD,#DD,#dl3_l,#DD


#dl3_l
	WLW	4,w3desp1,F
	WLLW	-1,seq_strtdunk,w3flydu8,>3a
	WLW	4,w3flydu2,F
	WLW	4,w3flydu3,F
	WLW	4,w3flydu4,F
	WLW	30,w3flydu5,F
	WL	-1,seq_lay_up_start
	WLW	4,w3flydu6,F
	WL	-1,seq_lay_up_start
	WLW	2,w3flydu7,F
	WL	-1,plyr_shoot
	WLW	2,w3flydu7,F
	WLW	50,w3flydu9,F
	WLW	-1,seq_newdir,1*16
	W0
#DD	W0


#*
dunklay4_t
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#DD,#dw1_l,#DD,#DD
	.long	#DD,#DD,#DD,#dw1_l

#dw1_l
	WLW	4,w2wmdu1,F
	WLLW	-1,seq_strtdunk,w2wmdu8,>35
	WLW	22,w2wmdu2,F
	WL	-1,seq_lay_up_start
	WLW	5,w2wmdu3,F
	WLW	5,w2wmdu4,F
	WLW	5,w2wmdu5,F
	WLW	1,w2wmdu6,F
	WL	-1,plyr_shoot
	WLW	50,w2wmdu6,F
	WLW	-1,seq_newdir,0
#DD	W0

#*
dunklay5_t
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#DD,#DD,#du1_l,#DD
	.long	#DD,#DD,#du1_l,#DD

#du1_l
	WLW	1,w3wmdu5,F
	WLLW	-1,seq_strtdunk,w3wmdu8,>35
	WLW	22,w3wmdu5,F
	WL	-1,seq_lay_up_start
	WLW	5,w3wmdu4,F
	WLW	1,w3wmdu3,F
	WL	-1,plyr_shoot
	WLW	50,w3wmdu3,F
	WLW	-1,seq_newdir,2*16
#DD	W0

NEWILPAL:
PLYRFX2_P:
XEWILPAL:
zwilpal:
PLYRFIX_P
NEWILFIX
PLYRRCH_P
	.word	0
	.end


