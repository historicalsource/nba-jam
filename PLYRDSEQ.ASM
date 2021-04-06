************************************************************** 
*
* Owner:	JOHNSON
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
	.include	"world.equ"
	.include	"sys.equ"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"macros.hdr"
	.asg		0,SEQT
	.include	"plyr.equ"
	.include	"plyrdseq.tbl"
	.include	"dunks.glo"
	.include	"dunks2.glo"

	.def	zwilpal,PLYRFX2_P,PLYRFX3_P,XEWILPAL
	.def	PLYRFIX_P
	.def	NEWILFIX
	.def	NEWILPAL


;sounds external

	.ref	tarzan,ohmy,jet2_snd

	.ref	plyr_shoot
	.ref	plyr_pass
	.ref	seq_newdir
	.ref	seq_slamball
	.ref	seq_strtdunk
	.ref	seq_jump
	.ref	seq_resetseq
	.ref	seq_stand
	.ref	seq_snd
	.ref	seq_offset

	.ref	seq_high_dnk_spch
	.ref	seq_low_dnk_spch
	.ref	seq_jam_speech
	.ref	seq_shadow_trail
	.ref	seq_alleyoop_speech
	.ref	goes_up_sp
	.ref	tks2_hoop_sp
	.ref	raises_up_sp
	.ref	sumrslts_sp

;FIX!!!!  We can get rid of the pal data for these pals in imgpal3 before
;game ships!  Check zwilpal, etc.  All unused pals!
;	.ref	PLYRFX2_P


JAM_NONE	equ	0
JAM_EASY	equ	1
JAM_MED		equ	2
JAM_GOOD	equ	3
JAM_GREAT	equ	4
JAM_ALLEYOOP	equ	5


M_YF	.equ	>8000	;Y free (OFLAGS)


	.text

#*****************************************
* Sequence - goto new line
*
* A13=*PxCTRL
*
 SUBR	seq_goto_line
 	
	move	*b4+,b4,L			;get line addr
	rets


********************************
* Dunk sequences

	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF
	.asg	DUNK_M|NOJUMP_M|NOJOY_M|NOCOLLP_M,DFLGS

#********************************


#********************************
alley_oop1_t
;(direction 3 only)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
#1
#5
	WLW	2,M1SPDU1,F
	WLLW	-1,seq_strtdunk,M1SPDU17,73	;Next frame begins elevation
	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,M1SPDU2,F
	WLW	3,M1SPDU3,F
	WLW	3,M1SPDU4,F
	WLW	3,M1SPDU5,F
	WLW	3,M1SPDU6,F
	WLW	3,M1SPDU7,F
	WLW	3,M1SPDU8,F
	WLW	3,M1SPDU9,F
	WLW	35,M1SPDU10,F
	WLW	3,M1SPDU11,F
	WLW	3,M1SPDU12,F
	WLW	3,M1SPDU13,F
	WLW	3,M1SPDU14,F
	WLW	3,M1SPDU15,F
	WLW	1,M1SPDU16,F
	WLW	-1,seq_slamball,2		;Ball centers in hoop at
	WLW	2,M1SPDU16,F
	WLW	500,M1SPDU17,F
	WLW	3,M1SPDU18,F			;Lands on ground
	WLW	3,M1SPDU19,F
	WLW	3,M1SPDU20,F
	WLW	-1,seq_newdir,0*16
	W0

#********************************
alley_oop2_t
;(direction 3 only)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
#1
#5
	WLW	2,W3FLDU1,F
	WLLW	-1,seq_strtdunk,W3FLDU12,70
	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,W3FLDU1,F
	WLW	39,W3FLDU2,F
	WLW	3,W3FLDU3,F
	WLW	3,W3FLDU4,F
	WLW	3,W3FLDU5,F
	WLW	3,W3FLDU6,F
	WLW	3,W3FLDU7,F
	WLW	3,W3FLDU8,F
	WLW	3,W3FLDU9,F
	WLW	3,W3FLDU10,F
	WLW	1,W3FLDU11,F
	WLW	-1,seq_slamball,4
	WLW	14,W3FLDU11,F
	WLW	500,W3FLDU12,F
	WLW	3,W3FLDU12,F
	WLW	3,W3FLDU13,F
	WLW	-1,seq_newdir,0*16
	W0


#********************************
alley_oop3_t
;(direction 3 only)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
#1
#5
	WLW	2,W3CRZDU2,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,75
	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,W3CRZDU2,F
	WLW	3,W3CRZDU3,F
	WLW	3,W3CRZDU4,F
	WLW	3,W3CRZDU5,F
	WLW	3,W3CRZDU6,F
	WLW	3,W3CRZDU7,F
	WLW	29,W3CRZDU8,F
	WLW	3,W3CRZDU9,F
	WLW	3,W3CRZDU10,F
	WLW	3,W3CRZDU11,F
	WLW	3,W3CRZDU12,F
	WLW	3,W3CRZDU13,F
	WLW	3,W3CRZDU14,F
	WLW	3,W3CRZDU15,F
	WLW	2,W3CRZDU16,F
	WLW	1,W3CRZDU17,F
	WLW	-1,seq_slamball,4
	WLW	15,W3CRZDU17,F
	WLW	500,W3CRZDU18,F
	WLW	3,W3CRZDU19,F
	WLW	3,W3CRZDU20,F
	WLW	-1,seq_newdir,0*16
	W0


#********************************
alley_oop4_t
;(direction 3 only)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
#1
#5
	WLW	3,S3BKDU1,F
	WLLW	-1,seq_strtdunk,S3BKDU14,70
	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,S3BKDU2,F
	WLW	3,S3BKDU2,F
	WLW	3,S3BKDU3,F
	WLW	3,S3BKDU4,F
	WLW	3,S3BKDU5,F
	WLW	39,S3BKDU6,F
	WLW	3,S3BKDU7,F
	WLW	3,S3BKDU8,F
	WLW	3,S3BKDU9,F
	WLW	3,S3BKDU10,F
	WLW	2,S3BKDU10,F
	WLW	2,S3BKDU11,F
	WLW	1,S3BKDU12,F
	WLW	-1,seq_slamball,3
	WLW	8,S3BKDU12,F
	WLWWW	-1,seq_offset,-8,0,0
	WLW	500,S3BKDU14,F
	WLW	3,S3BKDU15,F
	WLW	3,S3BKDU16,F
	WLW	-1,seq_newdir,2*16
	W0


#********************************
alley_oop5_t
;(direction 4,8 only)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	WLW	3,S8ALY401,F
	WLLW	-1,seq_strtdunk,S8ALY414,70
	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,S8ALY402,F
	WLW	3,S8ALY403,F
	WLW	3,S8ALY404,F
	WLW	3,S8ALY405,F
	WLW	41,S8ALY406,F
	WLW	3,S8ALY407,F
	WLW	3,S8ALY408,F
	WLW	3,S8ALY409,F
	WLW	2,S8ALY410,F
	WLW	2,S8ALY411,F
	WLW	2,S8ALY412,F
	WLW	1,S8ALY413,F
	WLW	-1,seq_slamball,15
	WLW	10,S8ALY413,F
	WLW	500,S8ALY414,F
	WLW	-1,seq_newdir,3*16
	W0

;	WLW	3,M3SPRDU1,F
;	WLLW	-1,seq_strtdunk,M3SPRDU9,70
;	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
;	WLW	3,M3SPRDU2,F
;	WLW	3,M3SPRDU3,F
;	WLW	3,M3SPRDU4,F
;	WLW	50,M3SPRDU5,F
;	WLW	5,M3SPRDU5,F
;	WLW	3,M3SPRDU6,F
;	WLW	2,M3SPRDU7,F
;	WLW	1,M3SPRDU8,F
;	WLW	-1,seq_slamball,3
;	WLW	11,M3SPRDU8,F
;	WLW	500,M3SPRDU9,F
;	WLW	3,M3SPRDU10,F
;	WLW	3,M3SPRDU11,F
;	WLW	-1,seq_newdir,4*16
;	W0


#********************************
alley_oop6_t
;(direction 3 only)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#5
#2
#3
#4
	WLW	3,W3SPNDU1,F
	WLLW	-1,seq_strtdunk,W3SPNDU19,70
	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,W3SPNDU2,F
	WLW	3,W3SPNDU3,F
	WLW	3,W3SPNDU4,F
	WLW	3,W3SPNDU5,F
	WLW	3,W3SPNDU6,F
	WLW	3,W3SPNDU7,F
	WLW	3,W3SPNDU8,F
	WLW	3,W3SPNDU9,F
	WLW	3,W3SPNDU10,F
	WLW	3,W3SPNDU11,F
	WLW	15,W3SPNDU12,F
	WLW	3,W3SPNDU13,F
	WLW	3,W3SPNDU14,F
	WLW	3,W3SPNDU15,F
	WLW	3,W3SPNDU16,F
	WLW	2,W3SPNDU17,F
	WLW	2,W3SPNDU18,F
	WLW	2,W3SPNDU19,F
	WLW	2,W3SPNDU20,F
	WLW	1,W3SPNDU21,F
	WLW	-1,seq_slamball,3
	WLW	11,W3SPNDU21,F
	WLW	500,W3SWDU10,F
	WLW	3,W3SWDU11,F
	WLW	3,W3SWDU12,F
	WLW	-1,seq_newdir,2*16
	W0

#********************************
alley_oop7_t
;(direction 2,6 only)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#5
#2
#3
#4
	WLW	3,S8ALY201,F
	WLLW	-1,seq_strtdunk,S8ALY212,70
	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,S8ALY202,F
	WLW	3,S8ALY203,F
	WLW	3,S8ALY204,F
	WLW	3,S8ALY205,F
	WLW	3,S8ALY206,F
	WLW	3,S8ALY207,F
	WLW	44,S8ALY208,F
	WLW	3,S8ALY209,F
	WLW	2,S8ALY210,F
	WLW	2,S8ALY211,F
	WLW	2,S8ALY212,F
	WLW	1,S8ALY213,F
	WLW	-1,seq_slamball,15
	WLW	10,S8ALY213,F
	WLW	500,S8ALY214,F
	WLW	-1,seq_newdir,0*16
	W0


#********************************
alley_oop8_t
;(direction 1 only)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	WLW	3,M5OHPB1,FF
	WLLW	-1,seq_strtdunk,M2DKDU14,74
	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,M5OHPB2,FF
	WLW	3,W3SDTUK4,FF
	WLW	3,W3SDTUK5,FF
	WLW	36,W3SDTUK6,FF
	WLW	3,W3SDTUK7,FF
	WLW	3,W3SDTUK8,FF
	WLW	3,W3SDTUK9,FF
	WLW	3,W3SDTUK10,FF
	WLW	3,W3SDTUK11,FF
	WLW	3,W3SDTUK12,FF
	WLW	3,W3SDTUK13,FF
	WLW	3,W3SDTUK14,FF
	WLW	3,W3SDTUK15,FF
	WLW	2,M2DKDU12,FF
	WLW	-1,seq_slamball,15
	WLW	15,M2DKDU13,FF
	WLW	500,M2DKDU14,FF
	WLW	3,M2DKDU15,FF
	WLW	3,M2DKDU16,FF
	WLW	-1,seq_newdir,1*16
	W0
	W0

#********************************
alley_oop9_t
;(direction 5 only)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	WLW	4,M5REVDU1,F
	WLLW	-1,seq_strtdunk,M5REVDU14,74
	WLW	-1,seq_jam_speech,JAM_ALLEYOOP
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,M5REVDU2,F
	WLW	3,M5REVDU3,F
	WLW	50,M5REVDU4,F
	WLW	3,M5REVDU5,F
	WLW	2,M5REVDU6,F
	WLW	2,M5REVDU7,F
	WLW	2,M5REVDU8,F
	WLW	2,M5REVDU9,F
	WLW	2,M5REVDU10,F
	WLW	2,M5REVDU11,F
	WLW	1,M5REVDU12,F
	WLW	1,M5REVDU13,F
	WLW	-1,seq_slamball,8
	WLW	8,M5REVDU13,F
	WLW	500,M5REVDU14,F
	WLW	3,M5REVDU15,F
	WLW	3,M5REVDU16,F
	WLW	-1,seq_newdir,6*16
	W0

#********************************
alley_oop10_t
;(direction 1 only)
	.word	DFLGS|LAYUP_M
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	WLW	2,S1SETLA1,F
	WLLW	-1,seq_strtdunk,S1SETLA5,64
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,S1SETLA2,F
	WLW	3,S1SETLA3,F
	WLW	38,S1SETLA4,F
	WLW	1,S1SETLA4,F
	WL	-1,seq_wait_for_pass
	WLW	5,S1SETLA4,F
	WLW	2,S1SETLA5,F
	WLW	1,S1SETLA6,F
	WL	-1,plyr_shoot
	WLW	1,S1SETLA6,F
	WLW	500,S1SETLA7,F
	WLW	3,S1SETLA8,F
	WLW	3,S1SETLA9,F
	WLW	-1,seq_newdir,0*16
	W0

#********************************
alley_oop11_t
;(direction 2 only)
	.word	DFLGS|LAYUP_M
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	WLW	2,S2HBHLA1,F
	WLLW	-1,seq_strtdunk,S2HBHLA6,76
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,S2HBHLA2,F
	WLW	3,S2HBHLA3,F
	WLW	43,S2HBHLA4,F
	WLW	1,S2HBHLA4,F
	WL	-1,seq_wait_for_pass
	WLW	5,S2HBHLA4,F
	WLW	2,S2HBHLA5,F
	WLW	1,S2HBHLA6,F
	WL	-1,plyr_shoot
	WLW	1,S2HBHLA6,F
	WLW	500,S2HBHLA7,F
	WLW	3,S2HBHLA8,F
	WLW	3,S2HBHLA9,F
	WLW	-1,seq_newdir,1*16
	W0

#********************************
alley_oop12_t
;(direction 3 only)
	.word	DFLGS|LAYUP_M
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	WLW	3,S3BEHLA1,F
	WLLW	-1,seq_strtdunk,S3BETLA6,76
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,S3BETLA2,F
	WLW	3,S3BETLA3,F
	WLW	3,S3BETLA4,F
	WLW	42,S3BETLA5,F
	WLW	1,S3BETLA5,F
	WL	-1,seq_wait_for_pass
	WLW	5,S3BETLA5,F
	WLW	2,S3BETLA6,F
	WLW	2,S3BETLA7,F
	WLW	1,S3BETLA8,F
	WL	-1,plyr_shoot
	WLW	2,S3BETLA8,F
	WLW	500,S3BETLA9,F
	WLW	3,S3BETLA10,F
	WLW	-1,seq_newdir,1*16
	W0

#********************************
alley_oop13_t
;(direction 4 only)
	.word	DFLGS|LAYUP_M
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	WLW	3,S4SETLA1,F
	WLLW	-1,seq_strtdunk,S4SETLA5,76
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,S4SETLA2,F
	WLW	43,S4SETLA3,F
	WLW	1,S4SETLA3,F
	WL	-1,seq_wait_for_pass
	WLW	5,S4SETLA3,F
	WLW	3,S4SETLA4,F
	WLW	1,S4SETLA5,F
	WL	-1,plyr_shoot
	WLW	1,S4SETLA5,F
	WLW	500,S4SETLA6,F
	WLW	3,S4SETLA7,F
	WLW	3,S4SETLA8,F
	WLW	3,S4SETLA9,F
	WLW	-1,seq_newdir,3*16
	W0

#********************************
alley_oop14_t
;(direction 5 only)
	.word	DFLGS|LAYUP_M
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	WLW	3,S5SETLA1,F
	WLLW	-1,seq_strtdunk,S5SETLA5,65
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,S5SETLA2,F
	WLW	38,S5SETLA3,F
	WLW	1,S5SETLA3,F
	WL	-1,seq_wait_for_pass
	WLW	5,S5SETLA3,F
	WLW	2,S5SETLA4,F
	WLW	1,S5SETLA5,F
	WL	-1,plyr_shoot
	WLW	1,S5SETLA5,F
	WLW	3,S5SETLA6,F
	WLW	500,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	3,S5SETLA10,F
	WLW	-1,seq_newdir,3*16
	W0


;This hold the player on the hold frame until he receives a pass
;,if one is on the way

seq_wait_for_pass
	move	*a13(plyr_rcvpass),a14
	jrle	hfp_1					;br=player not recieving pass
	subi	48+64,b4
hfp_1	rets
	
	

#********************************
dunka_t 
;(medium range)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2


#1
#2
	WLW	2,M1SPDU1,F
	WLLW	-1,seq_strtdunk,M1SPDU18,73	;Next frame begins elevation
	WLW	-1,seq_jam_speech,JAM_EASY	;Anncr excitement level
	WL	-1,seq_high_dnk_spch
;	WLL	-1,seq_shadow_trail,[7,15]   	;rate,cnt til delete
	WLW	3,M1SPDU2,F
	WLW	3,M1SPDU3,F
	WLW	3,M1SPDU4,F
	WLW	3,M1SPDU5,F
	WLW	3,M1SPDU6,F
	WLW	3,M1SPDU7,F
	WLW	3,M1SPDU8,F
	WLW	3,M1SPDU9,F
	WLW	41,M1SPDU10,F
	WLW	3,M1SPDU11,F
	WLW	2,M1SPDU12,F
	WLW	2,M1SPDU13,F
	WLW	1,M1SPDU14,F
	WLW	1,M1SPDU15,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	1,M1SPDU16,F
	WLW	-1,seq_slamball,16		;Ball centers in hoop at
	WLW	15,M1SPDU16,F
	WLW	500,M1SPDU17,F
	WLW	3,M1SPDU18,F			;Lands on ground
	WLW	3,M1SPDU19,F
	WLW	3,M1SPDU20,F
	WLW	-1,seq_newdir,0*16
#3
#4
#5
	W0

#********************************
dunka2_t
;(medium range)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2

#1
	WLW	2,M1SPDU1,F
	WLLW	-1,seq_strtdunk,M1SPDU18,36	;Next frame begins elevation
	WLL	-1,seq_goto_line,#1a
	W0

#2
	WLW	2,M1SPDU1,F
	WLLW	-1,seq_strtdunk,M1SPDU17,36	;Next frame begins elevation
#1a	WLW	-1,seq_jam_speech,JAM_EASY	;Anncr excitement level
	WL	-1,seq_low_dnk_spch
	WLW	3,M1SPDU2,F
	WLW	3,M1SPDU3,F
	WLW	3,M1SPDU4,F
	WLW	3,M1SPDU5,F
	WLW	3,M1SPDU6,F
	WLW	3,M1SPDU7,F
	WLW	3,M1SPDU8,F
	WLW	3,M1SPDU9,F
	WLW	3,M1SPDU10,F
	WLW	3,M1SPDU11,F
	WLW	2,M1SPDU12,F
	WLW	2,M1SPDU13,F
	WLW	2,M1SPDU14,F
	WLW	2,M1SPDU15,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	1,M1SPDU16,F
	WLW	-1,seq_slamball,17		;Ball centers in hoop at
	WLW	16,M1SPDU16,F
	WLW	500,M1SPDU17,F
	WLW	3,M1SPDU18,F			;Lands on ground
	WLW	3,M1SPDU19,F			;Lands on ground
	WLW	3,M1SPDU20,F			;Lands on ground
	WLW	-1,seq_newdir,0*16
#3
#4
#5
	W0

#********************************
dunka3_t
;(short range)
	.word	DFLGS				;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2

#1
	WLW	2,M1SPDU1,F
	WLLW	-1,seq_strtdunk,M1SPDU18,25	;Next frame begins elevation
	WLL	-1,seq_goto_line,#1a
	W0
#2
	WLW	2,M1SPDU1,F
	WLLW	-1,seq_strtdunk,M1SPDU17,25	;Next frame begins elevation
#1a	WLW	-1,seq_jam_speech,JAM_EASY	;Anncr excitement level
	WL	-1,seq_low_dnk_spch
	WLW	2,M1SPDU2,F
	WLW	1,M1SPDU3,F
	WLW	2,M1SPDU4,F
	WLW	1,M1SPDU5,F
	WLW	2,M1SPDU6,F
	WLW	1,M1SPDU7,F
	WLW	2,M1SPDU8,F
	WLW	1,M1SPDU9,F
	WLW	1,M1SPDU10,F
	WLW	1,M1SPDU11,F
	WLW	1,M1SPDU12,F
	WLW	1,M1SPDU13,F
	WLW	1,M1SPDU14,F
	WLW	1,M1SPDU15,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	1,M1SPDU16,F
	WLW	-1,seq_slamball,8		;Ball centers in hoop at
	WLW	6,M1SPDU16,F
	WLW	500,M1SPDU17,F
	WLW	3,M1SPDU18,F			;Lands on ground
	WLW	3,M1SPDU19,F			;Lands on ground
	WLW	3,M1SPDU20,F			;Lands on ground
	WLW	-1,seq_newdir,0*16
#3
#4
#5
	W0


#********************************
dunkb_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	3,M3TUKDU1,F
	WLLW	-1,seq_strtdunk,M3TUKDU14,70
	WLW	-1,seq_jam_speech,JAM_EASY
	WL	-1,seq_high_dnk_spch
	WLW	3,M3TUKDU2,F
	WLW	3,M3TUKDU3,F
	WLW	3,M3TUKDU4,F
	WLW	3,M3TUKDU5,F
	WLW	3,M3TUKDU6,F
	WLW	3,M3TUKDU7,F
	WLW	3,M3TUKDU8,F
	WLW	45,M3TUKDU9,F
	WLW	3,M3TUKDU10,F
	WLW	2,M3TUKDU11,F
	WLW	1,M3TUKDU12,F
	WLW	1,M3TUKDU13,F
	WLWWW	-1,seq_offset,4,0,0
	WLW	-1,seq_slamball,9
	WLW	2,M3TUKDU13,F
	WLW	7,M3TUKDU14,F
	WLW	500,M3TUKDU15,F
	WLW	3,M3TUKDU16,F
	WLW	3,M3TUKDU17,F
	WLW	-1,seq_newdir,0*16
#1
#4
#5
	W0

#********************************
dunkb2_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	3,M3TUKDU1,F
	WLLW	-1,seq_strtdunk,M3TUKDU14,59
	WLW	-1,seq_jam_speech,JAM_EASY
	WL	-1,seq_low_dnk_spch
	WLW	3,M3TUKDU2,F
	WLW	3,M3TUKDU3,F
	WLW	3,M3TUKDU4,F
	WLW	3,M3TUKDU5,F
	WLW	3,M3TUKDU6,F
	WLW	3,M3TUKDU7,F
	WLW	34,M3TUKDU8,F
	WLW	3,M3TUKDU9,F
	WLW	3,M3TUKDU10,F
	WLW	2,M3TUKDU11,F
	WLW	1,M3TUKDU12,F
	WLW	1,M3TUKDU13,F
	WLWWW	-1,seq_offset,4,0,0
	WLW	-1,seq_slamball,8
	WLW	5,M3TUKDU13,F
	WLW	3,M3TUKDU14,F
	WLW	500,M3TUKDU15,F
	WLW	3,M3TUKDU16,F
	WLW	3,M3TUKDU17,F
	WLW	-1,seq_newdir,0*16
#1
#4
#5
	W0
	
#********************************
dunkb3_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,M2DKDU1,F
	WLLW	-1,seq_strtdunk,M2DKDU7,85
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_high_dnk_spch
	WLW	3,M2DKDU2,F
	WLW	3,M2DKDU3,F
	WLW	3,M2DKDU4,F
	WLW	3,M2DKDU5,F
	WLW	55,M2DKDU6,F
	WLW	3,M2DKDU7,F
	WLW	3,M2DKDU8,F
	WLW	3,M2DKDU9,F
	WLW	2,M2DKDU10,F
	WLW	2,M2DKDU11,F
	WLW	1,M2DKDU12,F
	WLW	1,M2DKDU13,F
	WLW	-1,seq_slamball,15
	WLW	12,M2DKDU13,F
	WLW	500,M2DKDU14,F
	WLW	4,M2DKDU15,F
	WLW	4,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
	W0

#2
	WLW	3,M2DKDU1,F
	WLLW	-1,seq_strtdunk,M2DKDU8,75
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_high_dnk_spch
	WLW	3,M2DKDU2,F
	WLW	3,M2DKDU3,F
	WLW	3,M2DKDU4,F
	WLW	3,M2DKDU5,F
	WLW	3,M2DKDU6,F
	WLW	3,M2DKDU7,F
	WLW	3,M2DKDU8,F
	WLW	3,M2DKDU9,F
	WLW	43,M2DKDU10,F
	WLW	2,M2DKDU11,F
	WLW	1,M2DKDU12,F
	WLW	1,M2DKDU13,F
	WLW	-1,seq_slamball,15
	WLW	12,M2DKDU13,F
	WLW	500,M2DKDU14,F
	WLW	3,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
#3
#4
#5
	W0

#********************************
dunkc_t
;(medium range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,M2DKDU1,F
	WLLW	-1,seq_strtdunk,M2DKDU7,42
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_low_dnk_spch
	WLW	3,M2DKDU2,F
	WLW	3,M2DKDU3,F
	WLW	3,M2DKDU4,F
	WLW	3,M2DKDU5,F
	WLW	4,M2DKDU6,F
	WLW	3,M2DKDU7,F
	WLW	3,M2DKDU8,F
	WLW	4,M2DKDU9,F
	WLW	2,M2DKDU10,F
	WLW	2,M2DKDU11,F
	WLW	2,M2DKDU12,F
	WLW	1,M2DKDU13,F
	WLW	-1,seq_slamball,15
	WLW	9,M2DKDU13,F
	WLW	500,M2DKDU14,F
	WLW	4,M2DKDU15,F
	WLW	4,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
	W0

#2
	WLW	3,M2DKDU1,F
	WLLW	-1,seq_strtdunk,M2DKDU14,75
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_high_dnk_spch
	WLW	3,M2DKDU2,F
	WLW	3,M2DKDU3,F
	WLW	3,M2DKDU4,F
	WLW	3,M2DKDU5,F
	WLW	45,M2DKDU6,F
	WLW	3,M2DKDU7,F
	WLW	3,M2DKDU8,F
	WLW	3,M2DKDU9,F
	WLW	2,M2DKDU10,F
	WLW	2,M2DKDU11,F
	WLW	1,M2DKDU12,F
	WLW	1,M2DKDU13,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	-1,seq_slamball,15
	WLW	12,M2DKDU13,F
	WLW	500,M2DKDU14,F
	WLW	3,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
#3
#4
#5
	W0



#********************************
dunkd_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
#4
	WLW	3,M3SPRDU1,F
	WLLW	-1,seq_strtdunk,M3SPRDU9,74
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,M3SPRDU2,F
	WLW	3,M3SPRDU3,F
	WLW	3,M3SPRDU4,F
	WLW	57,M3SPRDU5,F
	WLW	3,M3SPRDU6,F
	WLW	3,M3SPRDU7,F
	WLW	2,M3SPRDU8,F
	WLW	-1,seq_slamball,15
	WLW	11,M3SPRDU8,F
	WLW	500,M3SPRDU9,F
	WLW	3,M3SPRDU10,F
	WLW	3,M3SPRDU11,F
	WLW	-1,seq_newdir,4*16
#1
#2
#5
	W0


#********************************
dunkd2_t
;(short range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
#4
	WLW	2,M3SPRDU1,F
	WLLW	-1,seq_strtdunk,M3SPRDU9,24
	WLW	-1,seq_jam_speech,JAM_MED
	WLW	2,M3SPRDU1,F
	WLW	2,M3SPRDU2,F
	WLW	2,M3SPRDU3,F
	WLW	2,M3SPRDU4,F
	WLW	2,M3SPRDU5,F
	WLW	2,M3SPRDU6,F
	WLW	1,M3SPRDU7,F
	WLW	1,M3SPRDU8,F
	WLW	-1,seq_slamball,9
	WLW	15,M3SPRDU8,F
	WLW	500,M3SPRDU9,F
	WLW	3,M3SPRDU10,F
	WLW	3,M3SPRDU11,F
	WLW	-1,seq_newdir,4*16
#1
#2
#5
	W0


#********************************
dunke_t
;(short range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#4
#5
	WLW	4,M5REVDU1,F
	WLLW	-1,seq_strtdunk,M5REVDU14,27
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_low_dnk_spch
	WLW	2,M5REVDU2,F
	WLW	2,M5REVDU3,F
	WLW	4,M5REVDU4,F
	WLW	2,M5REVDU5,F
	WLW	2,M5REVDU6,F
	WLW	1,M5REVDU7,F
	WLW	1,M5REVDU8,F
	WLW	1,M5REVDU9,F
	WLW	1,M5REVDU10,F
	WLW	1,M5REVDU11,F
	WLW	1,M5REVDU12,F
	WLW	1,M5REVDU13,F
	WLW	-1,seq_slamball,13
	WLW	10,M5REVDU13,F
	WLW	500,M5REVDU14,F
	WLW	3,M5REVDU15,F
	WLW	3,M5REVDU16,F
	WLW	-1,seq_newdir,6*16
#1
#2
#3
	W0

#********************************
dunke2_t
;(short,medium range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#4
#5
	WLW	4,M5REVDU1,F
	WLLW	-1,seq_strtdunk,M5REVDU14,76
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,M5REVDU2,F
	WLW	3,M5REVDU3,F
	WLW	52,M5REVDU4,F
	WLW	3,M5REVDU5,F
	WLW	2,M5REVDU6,F
	WLW	2,M5REVDU7,F
	WLW	2,M5REVDU8,F
	WLW	2,M5REVDU9,F
	WLW	2,M5REVDU10,F
	WLW	2,M5REVDU11,F
	WLW	1,M5REVDU12,F
	WLW	1,M5REVDU13,F
	WLW	-1,seq_slamball,8
	WLW	8,M5REVDU13,F
	WLW	500,M5REVDU14,F
	WLW	3,M5REVDU15,F
	WLW	3,M5REVDU16,F
	WLW	-1,seq_newdir,6*16
#1
#2
#3
	W0


#********************************
dunkf_t
;(short,medium range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
	WLW	3,S1TUKDU1,F
	WLLW	-1,seq_strtdunk,S1TUKDU8,95
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,S1TUKDU2,F
	WLW	3,S1TUKDU3,F
	WLW	73,S1TUKDU4,F
	WLWWW	-1,seq_offset,0,0,-9
	WLW	12,S1TUKDU4,F
	WLWWW	-1,seq_offset,0,0,-18
	WLW	2,S1TUKDU5,F
	WLWWW	-1,seq_offset,0,0,-10
	WLW	2,S1TUKDU6,F
	WLW	1,S1TUKDU7,F
	WLW	-1,seq_slamball,18
	WLW	15,S1TUKDU7,F
	WLW	500,S1TUKDU8,F
	WLW	3,S1TUKDU9,F
	WLW	3,S1TUKDU10,F
	WLW	3,S1TUKDU11,F
	WLW	-1,seq_newdir,0*16
#3
#4
#5
	W0


#********************************
dunkg_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
	WLW	3,S3BKDU1,F
	WLLW	-1,seq_strtdunk,S3BKDU14,78
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_high_dnk_spch
	WLW	3,S3BKDU2,F
	WLW	3,S3BKDU2,F
	WLW	3,S3BKDU3,F
	WLW	3,S3BKDU4,F
	WLW	3,S3BKDU5,F
	WLW	49,S3BKDU6,F
	WLW	3,S3BKDU7,F
	WLW	3,S3BKDU8,F
	WLW	3,S3BKDU9,F
	WLW	3,S3BKDU10,F
	WLW	2,S3BKDU10,F
	WLW	1,S3BKDU11,F
	WLW	1,S3BKDU12,F
	WLW	-1,seq_slamball,8
	WLW	8,S3BKDU12,F
	WLWWW	-1,seq_offset,-8,0,0
	WLW	500,S3BKDU14,F
	WLW	3,S3BKDU15,F
	WLW	3,S3BKDU16,F
	WLW	-1,seq_newdir,2*16
#1
#5
	W0

#********************************
dunkg2_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
	WLW	3,S3BKDU1,F
	WLLW	-1,seq_strtdunk,S3BKDU14,89
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,S3BKDU2,F
	WLW	3,S3BKDU2,F
	WLW	3,S3BKDU3,F
	WLW	3,S3BKDU4,F
	WLW	3,S3BKDU5,F
	WLW	56,S3BKDU6,F
	WLW	3,S3BKDU7,F
	WLW	3,S3BKDU8,F
	WLW	3,S3BKDU9,F
	WLW	3,S3BKDU10,F
	WLW	3,S3BKDU10,F
	WLW	3,S3BKDU11,F
	WLW	2,S3BKDU12,F
	WLW	-1,seq_slamball,11
	WLW	10,S3BKDU12,F
	WLWWW	-1,seq_offset,-8,0,0
	WLW	500,S3BKDU14,F
	WLW	3,S3BKDU15,F
	WLW	3,S3BKDU16,F
	WLW	-1,seq_newdir,2*16
#1
#5
	W0

#********************************
dunkj_t
;(medium,far range, 8-10 skill)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
#4
	WLW	3,W3SPRDU1,F
	WLLW	-1,seq_strtdunk,W3SPRDU14,87
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPRDU2,F
	WLW	3,W3SPRDU3,F
	WLW	3,W3SPRDU4,F
	WLW	3,W3SPRDU5,F
	WLW	3,W3SPRDU6,F
	WLW	58,W3SPRDU7,F
	WLW	3,W3SPRDU8,F
	WLW	3,W3SPRDU9,F
	WLW	3,W3SPRDU10,F
	WLW	3,W3SPRDU11,F
	WLW	3,W3SPRDU12,F
	WLW	1,W3SPRDU13,F
	WLW	-1,seq_slamball,10
	WLW	9,W3SPRDU13,F
	WLW	500,W3SPRDU14,F
	WLW	4,S3BKDU15,F
	WLW	4,S3BKDU16,F
	WLW	-1,seq_newdir,2*16
#1
#2
#5
	W0

#********************************
dunkj2_t
;(medium range, 5-7 skill)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
	WLW	3,W3SPRDU1,F
	WLLW	-1,seq_strtdunk,W3SPRDU14,67
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_low_dnk_spch
	WLW	3,W3SPRDU2,F
	WLW	3,W3SPRDU3,F
	WLW	3,W3SPRDU4,F
	WLW	3,W3SPRDU5,F
	WLW	3,W3SPRDU6,F
	WLW	3,W3SPRDU7,F
	WLW	3,W3SPRDU8,F
	WLW	38,W3SPRDU9,F
	WLW	3,W3SPRDU10,F
	WLW	3,W3SPRDU11,F
	WLW	3,W3SPRDU12,F
	WLW	1,W3SPRDU13,F
	WLW	-1,seq_slamball,8
	WLW	8,W3SPRDU13,F
	WLW	500,W3SPRDU14,F
	WLW	4,S3BKDU15,F
	WLW	4,S3BKDU16,F
	WLW	-1,seq_newdir,2*16
#1
#5
	W0


#********************************
dunkk_t
;(medium,far range, skill 6-10)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,W3SPNDU1,FF
	WLLW	-1,seq_strtdunk,W3SPNDU14,50
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_low_dnk_spch
	WLL	-1,seq_goto_line,#1a
#2
#3
	WLW	3,W3SPNDU1,F
	WLLW	-1,seq_strtdunk,W3SPNDU19,58
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_low_dnk_spch
	WLW	3,W3SPNDU2,F
	WLW	3,W3SPNDU3,F
	WLW	3,W3SPNDU4,F
#1a	WLW	3,W3SPNDU5,F
	WLW	3,W3SPNDU6,F
	WLW	3,W3SPNDU7,F
	WLW	3,W3SPNDU8,F
	WLW	3,W3SPNDU9,F
	WLW	3,W3SPNDU10,F
	WLW	3,W3SPNDU11,F
	WLW	3,W3SPNDU12,F
	WLW	3,W3SPNDU13,F
	WLW	3,W3SPNDU14,F
	WLW	3,W3SPNDU15,F
	WLW	3,W3SPNDU16,F
	WLW	2,W3SPNDU17,F
	WLW	2,W3SPNDU18,F
	WLW	2,W3SPNDU19,F
	WLW	2,W3SPNDU20,F
	WLW	1,W3SPNDU21,F
	WLW	-1,seq_slamball,15
	WLW	11,W3SPNDU21,F
	WLW	500,W3SWDU10,F
	WLW	3,W3SWDU11,F
	WLW	3,W3SWDU12,F
	WLW	-1,seq_newdir,2*16
#4
#5
	W0


#********************************
dunkk2_t
;(medium,far range, skill 6-10)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,W3SPNDU1,FF
	WLLW	-1,seq_strtdunk,W3SPNDU14,76
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLL	-1,seq_goto_line,#1a

#2
#3
#4
	WLW	3,W3SPNDU1,F
	WLLW	-1,seq_strtdunk,W3SPNDU19,84
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPNDU2,F
	WLW	3,W3SPNDU3,F
	WLW	3,W3SPNDU4,F
#1a	WLW	3,W3SPNDU5,F
	WLW	3,W3SPNDU6,F
	WLW	3,W3SPNDU7,F
	WLW	3,W3SPNDU8,F
	WLW	3,W3SPNDU9,F
	WLW	3,W3SPNDU10,F
	WLW	3,W3SPNDU11,F
	WLW	32,W3SPNDU12,F
	WLW	3,W3SPNDU13,F
	WLW	3,W3SPNDU14,F
	WLW	3,W3SPNDU15,F
	WLW	2,W3SPNDU16,F
	WLW	2,W3SPNDU17,F
	WLW	2,W3SPNDU18,F
	WLW	1,W3SPNDU19,F
	WLW	1,W3SPNDU20,F
	WLW	1,W3SPNDU21,F
	WLW	-1,seq_slamball,13
	WLW	11,W3SPNDU21,F
	WLW	500,W3SWDU10,F
	WLW	3,W3SWDU11,F
	WLW	3,W3SWDU12,F
	WLW	-1,seq_newdir,2*16
#5
	W0


#********************************
dunkl_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
	WLW	3,W3SMDU1,F
	WLLW	-1,seq_strtdunk,W3SMDU9,86
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SMDU2,F
	WLW	3,W3SMDU3,F
	WLW	3,W3SMDU4,F
	WLW	67,W3SMDU5,F
	WLW	3,W3SMDU6,F
	WLW	3,W3SMDU7,F
	WLW	1,W3SMDU8,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	-1,seq_slamball,15
	WLW	15,W3SMDU8,F
	WLW	500,W3SMDU9,F
	WLW	4,W3SWDU11,F
	WLW	4,W3SWDU12,F
	WLW	-1,seq_newdir,2*16
#1
#2
#4
#5
	W0

#********************************
dunkl2_t
;(far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
	WLW	3,W3CRZDU1,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,90
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	2,W3CRZDU2,F
	WLW	2,W3CRZDU3,F
	WLW	2,W3CRZDU4,F
	WLW	2,W3CRZDU5,F
	WLW	2,W3CRZDU6,F
	WLW	2,W3CRZDU7,F
	WLW	2,W3CRZDU8,F
	WLW	2,W3CRZDU9,F

	WLW	2,S8HLSP08,FF
	WLW	2,S8HLSP09,FF
	WLW	2,S8HLSP10,FF
	WLW	2,S8HLSP11,FF
	WLW	2,S8HLSP12,FF
	WLW	2,S8HLSP13,FF
	WLW	2,S8HLSP14,FF
	WLW	2,S8HLSP15,FF
	WLW	2,S8HLSP16,FF
	WLW	2,S8HLSP01,FF
	WLW	2,S8HLSP02,FF
	WLW	2,S8HLSP03,FF
	WLW	2,S8HLSP04,FF
	WLW	2,S8HLSP05,FF
	WLW	2,S8HLSP06,FF
	WLW	2,S8HLSP07,FF
	WLW	2,S8HLSP08,FF
	WLW	1,S8HLSP09,FF

	WLW	2,S8HLSP10,FF
	WLW	1,S8HLSP11,FF
	WLW	2,S8HLSP12,FF
	WLW	1,S8HLSP13,FF
	WLW	2,S8HLSP14,FF
	WLW	1,S8HLSP15,FF
	WLW	2,S8HLSP16,FF
	WLW	1,S8HLSP01,FF
	WLW	2,S8HLSP02,FF
	WLW	1,S8HLSP03,FF
	WLW	2,S8HLSP04,FF
	WLW	1,S8HLSP05,FF
	WLW	2,S8HLSP06,FF
	WLW	1,S8HLSP07,FF
	WLW	2,S8HLSP08,FF

	WLW	2,W3CRZDU10,F
	WLW	2,W3CRZDU11,F
	WLW	1,W3CRZDU12,F
	WLW	2,W3CRZDU13,F
	WLW	1,W3CRZDU14,F
	WLW	2,W3CRZDU15,F
	WLW	1,W3CRZDU16,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	1,W3CRZDU17,F
	WLW	-1,seq_slamball,15
	WLW	15,W3CRZDU17,F
	WLW	500,W3CRZDU18,F
	WLW	3,W3CRZDU19,F
	WLW	3,W3CRZDU20,F
	WLW	-1,seq_newdir,0*16
	W0
#1
#2
#4
#5
	W0
	

#********************************
dunkl3_t
;(short range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
	WLW	3,W3FLDU1,F
	WLLW	-1,seq_strtdunk,W3FLDU12,30
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_low_dnk_spch
	WLW	2,W3FLDU2,F
	WLW	2,W3FLDU3,F
	WLW	2,W3FLDU4,F
	WLW	2,W3FLDU5,F
	WLW	2,W3FLDU6,F
	WLW	2,W3FLDU7,F
	WLW	1,W3FLDU8,F
	WLW	1,W3FLDU9,F
	WLW	1,W3FLDU10,F
	WLW	1,W3FLDU11,F
	WLW	-1,seq_slamball,15
	WLW	12,W3FLDU11,F
	WLW	500,W3FLDU12,F
	WLW	3,W3FLDU13,F
	WLW	-1,seq_newdir,0*16

#1
#5
	W0


#********************************
dunkn_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	2,W3FLDU3,F
	WLLW	-1,seq_strtdunk,W3FLDU12,80
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,W3FLDU3,F
	WLW	3,W3FLDU4,F
	WLW	55,W3FLDU5,F
	WLW	3,W3FLDU6,F
	WLW	3,W3FLDU7,F
	WLW	3,W3FLDU8,F
	WLW	3,W3FLDU9,F
	WLW	3,W3FLDU10,F
	WLW	1,W3FLDU11,F
	WLW	-1,seq_slamball,15
	WLW	13,W3FLDU11,F
	WLW	500,W3FLDU12,F
	WLW	3,W3FLDU12,F
	WLW	3,W3FLDU13,F
	WLW	-1,seq_newdir,0*16
	W0

#2
#3
	WLW	2,W3FLDU1,F
	WLLW	-1,seq_strtdunk,W3FLDU12,90
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,W3FLDU1,F
	WLW	61,W3FLDU2,F
	WLW	3,W3FLDU3,F
	WLW	3,W3FLDU4,F
	WLW	3,W3FLDU5,F
	WLW	3,W3FLDU6,F
	WLW	3,W3FLDU7,F
	WLW	3,W3FLDU8,F
	WLW	2,W3FLDU9,F
	WLW	2,W3FLDU10,F
	WLW	1,W3FLDU11,F
	WLW	-1,seq_slamball,15
	WLW	14,W3FLDU11,F
	WLW	500,W3FLDU12,F
	WLW	3,W3FLDU12,F
	WLW	3,W3FLDU13,F
	WLW	-1,seq_newdir,0*16
#4
#5
	W0


#********************************
dunkn2_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	2,W3FLDU3,F
	WLLW	-1,seq_strtdunk,W3FLDU12,79
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_high_dnk_spch
	WLW	56,W3FLDU3,F
	WLW	3,W3FLDU4,F
	WLW	3,W3FLDU5,F
	WLW	3,W3FLDU6,F
	WLW	3,W3FLDU7,F
	WLW	3,W3FLDU8,F
	WLW	2,W3FLDU9,F
	WLW	2,W3FLDU10,F
	WLW	1,W3FLDU11,F
	WLW	-1,seq_slamball,20
	WLW	15,W3FLDU11,F
	WLW	500,W3FLDU12,F
	WLW	3,W3FLDU13,F
	WLW	-1,seq_newdir,0*16
	W0

#2
#3
	WLW	1,W3FLDU3,F
	WLLW	-1,seq_strtdunk,W3FLDU12,79
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_high_dnk_spch
	WLW	57,W3FLDU3,F
	WLW	3,W3FLDU4,F
	WLW	3,W3FLDU5,F
	WLW	3,W3FLDU6,F
	WLW	3,W3FLDU7,F
	WLW	3,W3FLDU8,F
	WLW	2,W3FLDU9,F
	WLW	2,W3FLDU10,F
	WLW	1,W3FLDU11,F
	WLW	-1,seq_slamball,9
	WLW	9,W3FLDU11,F
	WLW	500,W3FLDU12,F
	WLW	3,W3FLDU13,F
	WLW	-1,seq_newdir,0*16
#4
#5
	W0

#********************************
dunkn3_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	2,W3FLDU3,F
	WLLW	-1,seq_strtdunk,W3FLDU12,89
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_high_dnk_spch
	WLW	68,W3FLDU3,F
	WLW	3,W3FLDU4,F
	WLW	3,W3FLDU5,F
	WLW	3,W3FLDU6,F
	WLW	3,W3FLDU7,F
	WLW	3,W3FLDU8,F
	WLW	2,W3FLDU9,F
	WLW	1,W3FLDU10,F
	WLW	1,W3FLDU11,F
	WLW	-1,seq_slamball,20
	WLW	15,W3FLDU11,F
	WLW	500,W3FLDU12,F
	WLW	3,W3FLDU13,F
	WLW	-1,seq_newdir,0*16
	W0

#2
#3
	WLW	1,W3FLDU3,F
	WLLW	-1,seq_strtdunk,W3FLDU12,95
	WLW	-1,seq_jam_speech,JAM_MED
	WL	-1,seq_high_dnk_spch
	WLW	75,W3FLDU3,F
	WLW	3,W3FLDU4,F
	WLW	3,W3FLDU5,F
	WLW	3,W3FLDU6,F
	WLW	3,W3FLDU7,F
	WLW	3,W3FLDU8,F
	WLW	2,W3FLDU9,F
	WLW	1,W3FLDU10,F
	WLW	1,W3FLDU11,F
	WLW	-1,seq_slamball,9
	WLW	9,W3FLDU11,F
	WLW	500,W3FLDU12,F
	WLW	3,W3FLDU13,F
	WLW	-1,seq_newdir,0*16
#4
#5
	W0


#********************************
dunko_t
;(medium,far range, skill 6-10)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,W3SPNDU1,F
	WLLW	-1,seq_strtdunk,W3SPNDU17,90
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPNDU2,F
	WLW	3,W3SPNDU3,F
	WLW	3,W3SPNDU4,F
	WLW	3,W3SPNDU5,F
	WLW	3,W3SPNDU6,F
	WLW	3,W3SPNDU7,F
	WLW	3,W3SPNDU8,F
	WLW	54,W3SPNDU9,F
	WLW	3,W3SPNDU8,F
	WLW	3,W3SPNDU7,F
	WLW	2,W3SPNDU5,F
	WLW	2,W3SPNDU4,F
	WLW	1,W3SPNDU3,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	1,W3SPNDU2,F
	WLW	-1,seq_slamball,8
	WLW	8,W3SPNDU2,F
	WLW	500,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,0*16
	W0

#2
#3
	WLW	3,W3SPNDU1,F
	WLLW	-1,seq_strtdunk,W3SPNDU17,90
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPNDU2,F
	WLW	3,W3SPNDU3,F
	WLW	3,W3SPNDU4,F
	WLW	3,W3SPNDU5,F
	WLW	3,W3SPNDU6,F
	WLW	3,W3SPNDU7,F
	WLW	3,W3SPNDU8,F
	WLW	54,W3SPNDU9,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	3,W3SPNDU8,F
	WLW	3,W3SPNDU7,F
	WLW	2,W3SPNDU5,F
	WLW	2,W3SPNDU4,F
	WLW	1,W3SPNDU3,F
	WLW	1,W3SPNDU2,F
	WLW	-1,seq_slamball,8
	WLW	8,W3SPNDU2,F
	WLW	500,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,0*16
#4
#5
	W0


#********************************
dunko2_t
;(far range, skill 6-10)

	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#4
#5
	W0

#3
	WLW	3,W3CANN02,F
	WLLW	-1,seq_strtdunk,W3SMDU9,95
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,sumrslts_sp
	WLW	2,W3CANN04,F
	WLW	2,W3CANN06,F
	WLW	2,W3CANN08,F
	WLW	2,W3CANN10,F
	WLW	2,W3CANN12,F
	WLW	2,W3CANN14,F
	WLW	2,W3CANN16,F
	WLW	2,W3CANN18,F
	WLW	2,W3CANN20,F
	WLW	2,W3CANN22,F
	WLW	2,W3CANN24,F
	WLW	2,W3CANN26,F
	WLW	2,W3CANN28,F
	WLW	2,W3CANN30,F
	WLW	2,W3CANN32,F

	WLW	2,W3CANN14,F
	WLW	2,W3CANN16,F
	WLW	2,W3CANN18,F
	WLW	2,W3CANN20,F
	WLW	2,W3CANN22,F
	WLW	2,W3CANN24,F
	WLW	2,W3CANN26,F
	WLW	2,W3CANN28,F
	WLW	2,W3CANN30,F
	WLW	2,W3CANN32,F


	WLW	2,W3CANN14,F
	WLW	2,W3CANN16,F
	WLW	2,W3CANN18,F
	WLW	2,W3CANN20,F
	WLW	2,W3CANN22,F
	WLW	2,W3CANN24,F
	WLW	2,W3CANN26,F
	WLW	2,W3CANN28,F

	WLW	2,W3CANN06,F
	WLW	2,W3CANN04,F

	WLW	2,W3SMDU2,F
	WLW	2,W3SMDU3,F
	WLW	2,W3SMDU4,F
	WLW	14,W3SMDU5,F
	WLW	2,W3SMDU6,F
	WLW	1,W3SMDU7,F
	WLW	1,W3SMDU8,F
	WLW	-1,seq_slamball,15
	WLW	15,W3SMDU8,F
	WLW	500,W3SMDU9,F
	WLW	4,W3SWDU11,F
	WLW	4,W3SWDU12,F
	WLW	-1,seq_newdir,2*16
	W0


#********************************
dunkp_t
;(medium, far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
	WLW	3,W2THPW1,F
	WLLW	-1,seq_strtdunk,W2THPW12,81
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W2THPW2,F
	WLW	3,W2THPW3,F
	WLW	3,W2THPW4,F
	WLW	3,W2THPW5,F
	WLW	50,W2THPW6,F
	WLW	3,W2THPW7,F
	WLW	3,W2THPW8,F
	WLW	3,W2THPW9,F
	WLW	3,W2THPW10,F
	WLWWW	-1,seq_offset,0,0,20		;infront of net
	WLW	1,W2THPW11,F
	WLW	-1,seq_slamball,15
	WLW	15,W2THPW11,F
	WLW	500,W2THPW12,F
	WLW	3,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
#1
#3
	W0

#4
#5
	WLW	3,W4THPW1,F
	WLLW	-1,seq_strtdunk,W4THPW10,76
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W4THPW2,F
	WLW	3,W4THPW3,F
	WLW	3,W4THPW4,F
	WLW	56,W4THPW5,F
	WLW	3,W4THPW6,F
	WLW	3,W4THPW7,F
	WLWWW	-1,seq_offset,0,0,-20		;behind net
	WLW	3,W4THPW8,F
	WLW	2,W4THPW9,F
	WLW	-1,seq_slamball,15
	WLW	5,W4THPW9,F
	WLW	500,W4THPW10,F
	WLW	3,W4THPW11,F
	WLW	3,W4THPW12,F
	WLW	3,W4THPW13,F
	WLW	-1,seq_newdir,3*16
	W0

#********************************
dunkp2_t
;(short range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
	WLW	3,W2THPW1,F
	WLLW	-1,seq_strtdunk,W2THPW12,42
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_low_dnk_spch
	WLW	2,W2THPW2,F
	WLW	2,W2THPW3,F
	WLW	2,W2THPW4,F
	WLW	2,W2THPW5,F
	WLW	10,W2THPW6,F
	WLW	1,W2THPW7,F
	WLW	1,W2THPW8,F
	WLW	1,W2THPW9,F
	WLW	1,W2THPW10,F
	WLWWW	-1,seq_offset,0,0,20		;infront of net
	WLW	1,W2THPW11,F
	WLW	-1,seq_slamball,15
	WLW	15,W2THPW11,F
	WLW	500,W2THPW12,F
	WLW	2,M2DKDU15,F
	WLW	2,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
#1
#3
	W0

#4
#5
	WLW	3,W4THPW1,F
	WLLW	-1,seq_strtdunk,W4THPW10,28
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_low_dnk_spch
	WLW	2,W4THPW2,F
	WLW	2,W4THPW3,F
	WLW	2,W4THPW4,F
	WLW	15,W4THPW5,F
	WLW	1,W4THPW6,F
	WLW	1,W4THPW7,F
	WLWWW	-1,seq_offset,0,0,-20		;behind net
	WLW	1,W4THPW8,F
	WLW	1,W4THPW9,F
	WLW	-1,seq_slamball,15
	WLW	10,W4THPW9,F
	WLW	500,W4THPW10,F
	WLW	2,W4THPW11,F
	WLW	2,W4THPW12,F
	WLW	2,W4THPW13,F
	WLW	-1,seq_newdir,3*16
	W0

#********************************
dunkp3_t
;(medium, far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,W3SPNDU1,FF
	WLLW	-1,seq_strtdunk,M5REVDU11,85
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPNDU2,F
	WLW	3,W3SPNDU3,F
	WLW	3,W3SPNDU4,F
	WLW	3,W3SPNDU5,F
	WLW	3,W3SPNDU6,F
	WLW	3,W3SPNDU7,F
	WLW	3,W3SPNDU8,F
	WLW	3,W3SPNDU9,F
	WLW	3,W3SPNDU10,F
	WLW	31,W3SPNDU11,F
	WLW	3,M5REVDU5,F
	WLW	3,M5REVDU6,F
	WLW	3,M5REVDU7,F
	WLW	3,M5REVDU8,F
	WLW	3,M5REVDU9,F
	WLW	3,M5REVDU10,F
	WLW	3,M5REVDU11,F
	WLW	3,M5REVDU12,F
	WLWWW	-1,seq_offset,3,0,0
	WLW	1,M5REVDU13,F
	WLW	-1,seq_slamball,8
	WLW	8,M5REVDU13,F
	WLW	500,M5REVDU14,F
	WLW	3,M5REVDU15,F
	WLW	3,M5REVDU16,F
	WLW	-1,seq_newdir,6*16
	W0
#2
#3
	WLLW	-1,seq_strtdunk,M5REVDU14,80
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPNDU2,F
	WLW	3,W3SPNDU3,F
	WLW	3,W3SPNDU4,F
	WLW	3,W3SPNDU5,F
	WLW	3,W3SPNDU6,F
	WLW	3,W3SPNDU7,F
	WLW	3,W3SPNDU8,F
	WLW	3,W3SPNDU9,F
	WLW	3,W3SPNDU10,F
	WLW	30,W3SPNDU11,F
	WLW	3,M5REVDU5,F
	WLW	3,M5REVDU6,F
	WLW	3,M5REVDU7,F
	WLW	3,M5REVDU8,F
	WLW	3,M5REVDU9,F
	WLW	3,M5REVDU10,F
	WLW	3,M5REVDU11,F
	WLW	3,M5REVDU12,F
	WLW	1,M5REVDU13,F
	WLW	-1,seq_slamball,8
	WLW	8,M5REVDU13,F
	WLW	500,M5REVDU14,F
	WLW	3,M5REVDU15,F
	WLW	3,M5REVDU16,F
	WLW	-1,seq_newdir,6*16
#4
#5
	W0

#********************************
dunkq_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
#4
	WLW	3,W3SPRDU1,F
	WLLW	-1,seq_strtdunk,W3PLDDU15,76
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPRDU2,F
	WLW	3,W3PLDDU5,F
	WLW	3,W3PLDDU6,F
	WLW	3,W3PLDDU7,F
	WLW	3,W3PLDDU8,F
	WLW	48,W3PLDDU9,F
	WLW	3,W3PLDDU10,F
	WLW	3,W3PLDDU11,F
	WLW	3,W3PLDDU12,F
	WLW	3,W3PLDDU13,F
	WLWWW	-1,seq_offset,0,0,18		;in front of net
	WLW	1,W3PLDDU14,F
	WLW	-1,seq_slamball,16
	WLW	14,W3PLDDU14,F
	WLW	500,W3PLDDU15,F
;	WLW	3,W3PLDDU16,F
	WLW	-1,seq_newdir,3*16
#1
#2
#5
	W0

#********************************
dunkq2_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
#4
	WLW	3,W3SPRDU1,F
	WLLW	-1,seq_strtdunk,W3SPRDU14,85
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPRDU2,F
	WLW	3,W3PLDDU5,F
	WLW	3,W3PLDDU6,F
	WLW	3,W3PLDDU7,F
	WLW	3,W3PLDDU8,F
	WLW	28,W3PLDDU9,F
	WLW	4,W3PLDDU10,F
	WLW	4,W3PLDDU11,F
	WLW	4,W3PLDDU12,F
	WLW	23,W3SPRDU9,F
	WLW	3,W3SPRDU10,F
	WLW	3,W3SPRDU11,F
	WLW	3,W3SPRDU12,F
	WLW	1,W3SPRDU13,F
	WLW	-1,seq_slamball,8
	WLW	8,W3SPRDU13,F
	WLW	500,W3SPRDU14,F
	WLW	4,S3BKDU15,F
	WLW	4,S3BKDU16,F
	WLW	-1,seq_newdir,2*16
#1
#2
#5
	W0


#********************************
dunkr_t
;(short,medium range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#4
	WLW	3,M5REVDU1,F
	WLLW	-1,seq_strtdunk,M5OHPB10,65
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_low_dnk_spch
	WLW	3,M5REVDU2,F
	WLW	3,M5REVDU3,F
	WLW	18,M5REVDU4,F
	WLW	3,W3SPNDU12,F
	WLW	3,W3SPNDU11,F
	WLW	3,W3SPNDU10,F
	WLW	3,W3SPNDU9,F
	WLW	3,W3SPNDU8,F
	WLW	3,W3SPNDU7,F
	WLW	3,W3SPNDU6,F
	WLW	3,M5OHPB4,F
	WLWWW	-1,seq_offset,0,0,20
	WLW	3,M5OHPB5,F
	WLW	3,M5OHPB6,F
	WLW	3,M5OHPB7,F
	WLW	3,M5OHPB8,F
	WLW	3,M5OHPB9,F
	WLWWW	-1,seq_offset,0,0,20
	WLW	-1,seq_slamball,20
	WLW	20,M5OHPB9,F
	WLW	500,M5OHPB10,F
	WLW	3,M5OHPB11,F
	WLW	3,M5OHPB12,F
	WLW	-1,seq_newdir,0*16
#1
#2
#3
#5
	W0


#********************************
dunkr2_t
;(short,medium range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,M5OHPB1,F
	WLLW	-1,seq_strtdunk,M5OHPB10,66
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_low_dnk_spch
	WLW	3,M5OHPB2,F
	WLW	3,M5OHPB3,F
	WLW	3,M5OHPB4,F
	WLW	45,M5OHPB5,F
	WLW	3,M5OHPB6,F
	WLW	3,M5OHPB7,F
	WLW	3,M5OHPB8,F
	WLW	3,M5OHPB9,F
	WLWWW	-1,seq_offset,0,0,20
	WLW	-1,seq_slamball,20
	WLW	20,M5OHPB9,F
	WLW	500,M5OHPB10,F
	WLW	3,M5OHPB11,F
	WLW	3,M5OHPB12,F
	WLW	-1,seq_newdir,0*16
	W0
#2
#3
#4
#5
	W0


	.bss	KP_TMPX	,32		;Keep xvel for hook shot
	.bss	KP_TMPZ	,32		;Keep zvel for hook shot


#********************************

hook_t
hook2_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2

#1
	WLW	3,w3hks1,F
	WLW	3,w3hks2,F
	WL	-1,seq_jump
	WLW	3,w3hks3,F
	WLW	3,w3hks4,F
	WLW	3,w3hks5,F
	WL	-1,plyr_shoot
	WLW	50,w3hks6,F
	WLW	3,w3hks7,F
	WLW	3,w3hks8,F
	WLW	3,w3hks9,F
	WLW	3,w3hks10,F
	WLW	-1,seq_newdir,2*16
	W0
#2
	WL	-1,#store_xvel2
	WLW	3,w4hks1,F
	WLW	3,w4hks2,F
	WL	-1,seq_jump
	WL	-1,#restore_xvel
	WLW	3,w4hks3,F
	WLW	3,w4hks4,F
	WLW	29,w4hks5,F
	WL	-1,plyr_shoot
	WLW	2,w4hks5,F
	WLW	50,w4hks6,F
	WLW	3,w4hks7,F
	WLW	3,w4hks8,F
	WLW	3,w4hks9,F
	WLW	3,w4hks10,F
	WLW	-1,seq_newdir,3*16
	W0

#3
	WL	-1,#top_bot
	WL	-1,#store_xvel
	WLW	3,w1hks1,F
	WLW	3,w1hks2,F
	WL	-1,seq_jump
	WL	-1,#restore_xvel
	WLW	3,w1hks3,F
	WLW	29,w1hks4,F
	WL	-1,plyr_shoot
	WLW	3,w1hks5,F
	WLW	50,w1hks6,F
	WLW	3,w1hks7,F
	WLW	3,w1hks8,F
	WLW	3,w1hks9,F
	WLW	3,w1hks10,F
	WLW	-1,seq_newdir,0*16
	W0

#top_bot
	move	*a8(OZPOS),a0
	cmpi	CZMID,a0
	jrgt	#ret
;Yes, I am above CRTMID
	movi	#3a,b4
#ret	rets

#3a
;Top of screen #3 hook shot
	WL	-1,#store_xvel
	WLW	3,w5hks1,F
	WLW	3,w5hks2,F
	WL	-1,seq_jump
	WL	-1,#restore_xvel
	WLW	3,w5hks3,F
	WLW	3,w5hks4,F
	WLW	29,w5hks5,F
	WL	-1,plyr_shoot
	WLW	2,w5hks6,F
	WLW	50,w5hks7,F
	WLW	3,w5hks8,F
	WLW	3,w5hks9,F
	WLW	3,w5hks10,F
	WLW	-1,seq_newdir,4*16
	W0


#4
#5
	WLW	3,w3fhks1,F
	WLW	3,w3fhks2,F
	WL	-1,seq_jump
	WLW	3,w3fhks3,F
	WLW	3,w3fhks4,F
	WLW	3,w3fhks5,F
	WL	-1,plyr_shoot
	WLW	2,w3fhks5,F
	WLW	50,w3fhks6,F
	WLW	3,w3fhks7,F
	WLW	3,w3fhks8,F
	WLW	3,w3fhks9,F
	WLW	-1,seq_newdir,3*16
	W0

#store_xvel

	move	*a8(OXVEL),a0,L
	sra	2,a0
	move	a0,@KP_TMPX,L
	move	*a8(OZVEL),a0,L
	sra	2,a0
	move	a0,@KP_TMPZ,L
	rets

#store_xvel2

	move	*a8(OXVEL),a0,L
	sra	3,a0
	move	a0,@KP_TMPX,L
	move	*a8(OZVEL),a0,L
	sra	3,a0
	move	a0,@KP_TMPZ,L
	rets
#restore_xvel

	move	@KP_TMPX,a0,L
	move	a0,*a8(OXVEL),L
	move	@KP_TMPZ,a0,L
	move	a0,*a8(OZVEL),L
	rets



#********************************
dunklay_t
;(medium,far range, 7-10)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
	WLW	3,W3SPLY1,F
	WLLW	-1,seq_strtdunk,M3SPRLA7,60
	WLW	3,W3SPLY2,F
	WLW	3,W3SPLY3,F
	WLW	3,W3SPLY4,F
	WLW	3,W3SPLY5,F
	WLW	3,W3SPLY6,F
	WLW	3,W3SPLY7,F
	WL	-1,#zfloat
	WLW	3,W3SPLY8,F
	WLW	3,W3SPLY9,F
	WLW	3,W3SPLY10,F
	WLW	3,W3SPLY11,F
	WLW	3,W3SPLY12,F
	WLW	3,W3SPLY13,F
	WLW	3,W3SPLY14,F
	WLW	3,W3SPLY15,F
	WLW	3,W3SPLY16,F
	WLW	3,S5SETLA4,F
	WLW	1,S5SETLA5,F
	WL	-1,plyr_shoot
	WLW	2,S5SETLA5,F
	WLW	3,S5SETLA6,F
	WLW	500,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	3,S5SETLA10,F
	WLW	-1,seq_newdir,2*16
#4
#5
	W0

#zfloat
	move	*a8(OZVEL),a0,L
	addi	-0a000h,a0
	move	a0,*a8(OZVEL),L
	rets



#********************************
dunklay2_t
;(medium,far range, 7-10 skill)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	3,W3SPLY1,F
	WLLW	-1,seq_strtdunk,W3SPLY12,65
	WLW	3,W3SPLY2,F
	WL	-1,#zfloat
	WLW	3,W3SPLY3,F
	WLW	3,W3SPLY4,F
	WLW	3,W3SPLY5,F
	WLW	3,W3SPLY6,F
	WLW	3,W3SPLY7,F
	WLW	3,W3SPLY8,F
	WLW	3,W3SPLY9,F
	WLW	3,W3SPLY10,F
	WLW	3,W3SPLY11,F
	WLW	3,W3SPLY12,F
	WLW	3,W3SPLY13,F
	WLW	3,W3SPLY14,F
	WLW	3,W3SPLY15,F
	WLW	3,W3SPLY16,F
	WLWWW	-1,seq_offset,0,-19,0
	WLW	3,S5SETLA4,F
	WLW	1,S5SETLA5,F
	WL	-1,plyr_shoot
	WLW	2,S5SETLA5,F
	WLW	3,S5SETLA6,F
	WLW	500,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	3,S5SETLA10,F
	WLW	-1,seq_newdir,2*16
#1
#4
#5
	W0

#zfloat
	move	*a8(OZVEL),a0,L
	addi	-0e000h,a0
	move	a0,*a8(OZVEL),L
	rets


#********************************
dunklay3_t
;(medium,far range, 7-10 skill)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
	WLW	3,W3SPLY1,F
	WLLW	-1,seq_strtdunk,W3SPLY12,55
	WLW	3,W3SPLY2,F
	WL	-1,#zfloat
	WLW	3,W3SPLY3,F
	WLW	3,W3SPLY4,F
	WLW	3,S1SETLA1,F
	WLW	3,S1SETLA2,F
	WLW	3,S1SETLA3,F
	WLW	25,S1SETLA4,F
	WLW	3,S1SETLA5,F
	WL	-1,plyr_shoot
	WLW	2,S1SETLA5,F
	WLW	500,S1SETLA6,F
	WLW	3,S1SETLA7,F
	WLW	3,S1SETLA8,F
	WLW	3,S1SETLA9,F
;	WLW	3,S1SETLA10,F
	WLW	-1,seq_newdir,0*16
#4
#5
	W0
	
#zfloat
	move	*a8(OZVEL),a0,L
	addi	0e000h,a0
	move	a0,*a8(OZVEL),L
	rets

#********************************
dunklay3a_t
;(medium,far range)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	2,W3SPLY1,F
	WLW	2,W3SPLY2,F
	WLLW	-1,seq_strtdunk,M3SPRLA7,60
	WLW	2,W3SPLY3,F
	WLW	2,W3SPLY4,F
	WLW	2,W3SPLY5,F
	WLW	2,W3SPLY6,F
	WLW	2,W3SPLY7,F
	WLW	2,W3SPLY8,F
	WLW	2,W3SPLY9,F
	WLW	2,W3SPLY10,F
	WLW	3,W3SPLY11,F
	WLW	3,W3SPLY12,F
	WLW	3,W3SPLY13,F
	WLW	3,W3SPLY14,F
	WLW	3,W3SPLY15,F
	WLW	3,W3SPLY16,F
	WLW	3,W3SPLY17,F
	WLW	3,W3SPLY18,F
	WLW	3,W3SPLY19,F
	WLW	1,W3SPLY20,F
	WL	-1,plyr_shoot
	WLW	50,W3SPLY20,F
	WLW	-1,seq_newdir,3*16
	W0

#2
#3
	WLW	2,W3SPLY1,F
	WLW	2,W3SPLY2,F
	WLLW	-1,seq_strtdunk,W3SPLY13,60
	WLW	1,W3SPLY3,F
	WLW	2,W3SPLY4,F
	WLW	1,W3SPLY5,F
	WLW	2,W3SPLY6,F
	WLW	1,W3SPLY7,F
	WLW	1,W3SPLY8,F
	WLW	1,W3SPLY9,F
	WLW	1,W3SPLY10,F

	WLW	2,W3SPLY11,F
	WLW	3,W3SPLY12,F
	WLW	2,W3SPLY13,F
	WLW	3,W3SPLY14,F
	WLW	2,W3SPLY15,F

	WLW	3,W3SPLY14,F
	WLW	3,W3SPLY13,F
	WLW	3,W3SPLY12,F
	WLW	3,W3SPLY11,F

	WLW	3,W3SPLY12,F
	WLW	3,W3SPLY13,F
	WLW	3,W3SPLY14,F
	WLW	3,W3SPLY15,F

	WLW	2,W3SPLY16,F
	WLW	2,W3SPLY17,F
	WLW	3,W3SPLY18,F
	WLW	3,W3SPLY19,F
	WLW	1,W3SPLY20,F
	WL	-1,plyr_shoot
	WLW	50,W3SPLY20,F
	WLW	-1,seq_newdir,3*16
#4
#5
	W0


#********************************
dunklay3b_t
;(medium,far range)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	2,W3SPLY1,F
	WLLW	-1,seq_strtdunk,M3SPRLA7,64
	WLW	2,W3SPLY2,F
	WLW	2,W3SPLY3,F
	WLW	2,W3SPLY4,F
	WLW	2,W3SPLY5,F
	WLW	2,W3SPLY6,F
	WLW	2,W3SPLY7,F
	WLW	2,W3SPLY8,F
	WLW	2,W3SPLY9,F
	WLW	3,W3SPLY10,F
	WLW	3,W3SPLY11,F
	WLW	3,W3SPLY12,F
	WLW	3,W3SPLY13,F
	WLW	3,W3SPLY14,F
	WLW	8,W3SPLY15,F
	WLW	3,W3SPLY16,F
	WLW	3,W3SPLY17,F
	WLW	3,W3SPLY18,F
	WLW	3,W3SPLY19,F
	WLW	1,W3SPLY20,F
	WL	-1,plyr_shoot
	WLW	50,W3SPLY20,F
	WLW	-1,seq_newdir,3*16
	W0
#2
#3
	WLW	2,W3SPLY1,F
	WLLW	-1,seq_strtdunk,W3SPLY18,64
	WLW	2,W3SPLY2,F
	WLW	2,W3SPLY3,F
	WLW	2,W3SPLY4,F
	WLW	2,W3SPLY5,F
	WLW	2,W3SPLY6,F
	WLW	2,W3SPLY7,F
	WLW	2,W3SPLY8,F
	WLW	2,W3SPLY9,F
	WLW	3,W3SPLY10,F
	WLW	3,W3SPLY11,F
	WLW	3,W3SPLY12,F
	WLW	3,W3SPLY13,F
	WLW	3,W3SPLY14,F
	WLW	9,W3SPLY15,F
	WLW	3,W3SPLY16,F
	WLW	3,W3SPLY17,F
	WLW	3,W3SPLY18,F
	WLW	3,W3SPLY19,F
	WLW	1,W3SPLY20,F
	WL	-1,plyr_shoot
	WLW	50,W3SPLY20,F
	WLW	-1,seq_newdir,3*16
#4
#5
	W0


#********************************
dunklay3c_t
;(short medium range)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,W3SPLY2,F
	WLLW	-1,seq_strtdunk,W3SPLY18,55
	WLW	2,W3SPLY3,F
	WLW	3,W3SPLY4,F
	WLW	2,W3SPLY5,F
	WLW	3,W3SPLY6,F
	WLW	2,W3SPLY7,F
	WLW	3,W3SPLY8,F
	WLW	2,W3SPLY9,F
	WLW	3,W3SPLY10,F
	WLW	3,W3SPLY11,F
	WLW	3,W3SPLY12,F
	WLW	3,W3SPLY13,F
	WLW	3,W3SPLY14,F
	WLW	2,W3SPLY15,F
	WLW	2,W3SPLY16,F
	WLW	2,W3SPLY17,F
	WLW	1,W3SPLY18,F
	WL	-1,plyr_shoot
	WLW	50,W3SPLY18,F
	WLW	-1,seq_newdir,3*16
	W0

#2
#3
	WLW	2,W3SPLY1,F
	WLLW	-1,seq_strtdunk,W3SPLY18,55
	WLW	2,W3SPLY1,F
	WLW	3,W3SPLY2,F
	WLW	2,W3SPLY3,F
	WLW	3,W3SPLY4,F
	WLW	2,W3SPLY5,F
	WLW	3,W3SPLY6,F
	WLW	2,W3SPLY7,F
	WLW	3,W3SPLY8,F
	WLW	2,W3SPLY9,F
	WLW	3,W3SPLY10,F
	WLW	3,W3SPLY11,F
	WLW	3,W3SPLY12,F
	WLW	3,W3SPLY13,F
	WLW	3,W3SPLY14,F
	WLW	3,W3SPLY15,F
	WLW	3,W3SPLY16,F
	WLW	2,W3SPLY17,F
	WLW	2,W3SPLY18,F
	WLW	2,W3SPLY19,F
	WLW	1,W3SPLY20,F
	WL	-1,plyr_shoot
	WLW	50,W3SPLY20,F
	WLW	-1,seq_newdir,3*16
#4
#5
	W0


#********************************
dunklay4_t
;(short,medium range)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	W0

#zfloat
	move	*a8(OZVEL),a0,L
	addi	0a000h,a0
	move	a0,*a8(OZVEL),L
	rets

#********************************
dunklay5_t
;(medium range)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	1,W3SETLA3,FF
	WLLW	-1,seq_strtdunk,W3PLDDU8,54
	WLW	3,W3SETLA3,FF
	WLW	25,W3SETLA4,FF
	WLW	3,W3SETLA5,FF
	WLW	2,W3SETLA6,FF
	WLW	1,W3SETLA7,FF
	WL	-1,plyr_shoot
	WLW	500,W3SETLA7,FF
	WLW	3,W3SETLA8,FF
	WLW	3,W3SETLA9,FF
	WLW	-1,seq_newdir,0*16
	W0
#2
#3
	WLW	1,W3SETLA1,F
	WLLW	-1,seq_strtdunk,W3PLDDU8,54
	WLW	3,W3SETLA2,F
	WLW	3,W3SETLA3,F
	WL	-1,#zfloat
	WLW	25,W3SETLA4,F
	WLW	3,W3SETLA5,F
	WLW	2,W3SETLA6,F
	WLW	1,W3SETLA7,F
	WL	-1,plyr_shoot
	WLW	500,W3SETLA7,F
	WLW	3,W3SETLA8,F
	WLW	3,W3SETLA9,F
	WLW	-1,seq_newdir,0*16
#4
#5
	W0


#zfloat
	move	*a8(OZVEL),a0,L
	addi	0a000h,a0
	move	a0,*a8(OZVEL),L
	rets


#********************************
dunklay6_t
;(short,medium range)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,S1SETLA1,F
	WLLW	-1,seq_strtdunk,S1SETLA2,52
	WLW	3,S1SETLA2,F
	WLW	3,S1SETLA3,F
	WLW	24,S1SETLA4,F
	WLW	3,S1SETLA5,F
	WL	-1,plyr_shoot
	WLW	2,S1SETLA5,F
	WLW	500,S1SETLA6,F
	WLW	3,S1SETLA7,F
	WLW	3,S1SETLA8,F
	WLW	3,S1SETLA9,F
	WLW	-1,seq_newdir,0*16
	W0
#2
#3
	WLW	2,M3SPRLA1,F
	WLLW	-1,seq_strtdunk,S4SETLA2,52
	WLW	3,M3SPRLA2,F
	WLW	3,M3SPRLA3,F
	WLW	3,M3SPRLA4,F
	WLW	30,M3SPRLA5,F
	WLW	3,M3SPRLA6,F
	WL	-1,plyr_shoot
	WLW	3,M3SPRLA7,F
	WLW	500,M3SPRLA8,F
	WLW	3,M3SPRLA9,F
	WLW	3,M3SPRLA10,F
	WLW	-1,seq_newdir,1*16
	W0
#4
	WLW	3,S4SETLA1,F
	WLLW	-1,seq_strtdunk,S4SETLA2,52
	WLW	3,S4SETLA2,F
	WLW	3,S4SETLA3,F
	WLW	30,S4SETLA4,F
	WL	-1,plyr_shoot
	WLW	3,S4SETLA5,F
	WLW	500,S4SETLA6,F
	WLW	3,S4SETLA7,F
	WLW	3,S4SETLA8,F
	WLW	3,S4SETLA9,F
	WLW	-1,seq_newdir,3*16
	W0

#5
	WLW	3,S5SETLA1,F
	WLLW	-1,seq_strtdunk,S5SETLA2,52
	WLW	3,S5SETLA2,F
	WLW	3,S5SETLA3,F
	WLW	30,S5SETLA4,F
	WLW	3,S5SETLA5,F
	WL	-1,plyr_shoot
	WLW	2,S5SETLA5,F
	WLW	500,S5SETLA6,F
	WLW	3,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	-1,seq_newdir,3*16
	W0


#********************************
dunklay7_t
;(medium range, 7-10 skill)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,S3BEHLA1,FF
	WLLW	-1,seq_strtdunk,M1SPDU10,58
	WLW	3,S3BEHLA2,FF
	WLW	32,S3BEHLA3,FF
	WLW	4,S3BEHLA4,FF
	WLW	4,S3BEHLA5,FF
	WLW	3,S3BEHLA6,FF
	WL	-1,plyr_shoot
	WLW	500,S3BEHLA6,FF
	WLW	3,S3BEHLA7,FF
	WLW	3,S3BEHLA8,FF
	WLW	3,S3BEHLA9,FF
	WLW	-1,seq_newdir,1*16
	W0

#2
#3
	WLW	3,S3BEHLA1,F
	WLLW	-1,seq_strtdunk,S3BEHLA8,58
	WLW	3,S3BEHLA2,F
	WLW	32,S3BEHLA3,F
	WLW	4,S3BEHLA4,F
	WLW	4,S3BEHLA5,F
	WLW	3,S3BEHLA6,F
	WL	-1,plyr_shoot
	WLW	500,S3BEHLA6,F
	WLW	3,S3BEHLA7,F
	WLW	3,S3BEHLA8,F
	WLW	3,S3BEHLA9,F
	WLW	-1,seq_newdir,1*16
#4
#5
	W0

#********************************
dunklay7a_t
;(medium range, 1-6 skill)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	3,S3BEHLA1,F
	WLLW	-1,seq_strtdunk,S3BETLA6,59
	WLW	3,S3BETLA2,F
	WLW	35,S3BETLA3,F
	WLW	4,S3BETLA4,F
	WLW	4,S3BETLA5,F
	WLW	4,S3BETLA6,F
	WLW	4,S3BETLA7,F
	WLW	2,S3BETLA8,F
	WL	-1,plyr_shoot
	WLW	500,S3BETLA8,F
	WLW	3,S3BETLA9,F
	WLW	3,S3BETLA10,F
	WLW	-1,seq_newdir,1*16
#1
#4
#5
	W0

#********************************
dunklay8_t
;(med,far range, 1-5 skill)
	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	2,w4hks1,F
	WLLW	-1,seq_strtdunk,w4hks6,50
	WLW	3,w4hks2,F
	WLW	3,w4hks3,F
	WLW	26,w4hks4,F
	WL	-1,plyr_shoot
	WLW	1,w4hks4,F
	WLW	3,w4hks5,F
	WLW	500,w4hks6,F
	WLW	3,w4hks7,F
	WLW	3,w4hks8,F
	WLW	3,w4hks9,F
	WLW	3,w4hks10,F
	WLW	-1,seq_newdir,3*16
#1
#4
#5
	W0



NEWILPAL:
PLYRFX2_P:
PLYRFX3_P:
XEWILPAL:
zwilpal:
PLYRFIX_P
NEWILFIX
;PLYRRCH_P
	.word	0
	.end
