******************************************************************************
*
* Owner:	JOHNSON
*
* Software:		Jeff Johnson
* Initiated:		2/3/96
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
******************************************************************************
	.file	"plyrdsq2.asm"
	.title	"dunk tables 2"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"world.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"game.equ"
	.include	"macros.hdr"
	.asg		0,SEQT
	.include	"plyr.equ"
	.include	"plyrdsq2.tbl"
	.include	"dunks.glo"
	.include	"dunks2.glo"

;symbols externally defined

     	.ref	tarzan
	.ref	plyr_shoot
	.ref	plyr_pass
	.ref	seq_newdir
	.ref	seq_slamball
	.ref	seq_strtdunk
	.ref	seq_jump
	.ref	seq_stand
	.ref	seq_snd
	.ref	seq_offset
	.ref	seq_high_dnk_spch
	.ref	seq_low_dnk_spch
	.ref	seq_jam_speech
	.ref	seq_goto_line
	.ref	tomahk_hm_sp,tomahk_dk_sp,ooooooh_sp,hiabv_rim_sp
	.ref	plyr_lob_ball
	.ref	goes_up_sp,raises_up_sp
	.ref	cannonbal_sp


JAM_NONE	equ	0
JAM_EASY	equ	1
JAM_MED		equ	2
JAM_GOOD	equ	3
JAM_GREAT	equ	4


M_YF	.equ	>8000	;Y free (OFLAGS)


	.text

********************************
* Dunk sequences

	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF
	.asg	DUNK_M|NOJUMP_M|NOJOY_M|NOCOLLP_M,DFLGS


#********************************
ddunk_recv_t
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLL	-1,seq_randm,#1a
	WLW	2,W3FLDU3,F
	WLLW	-1,seq_strtdunk,W3FLDU12,86
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,goes_up_sp
	WLW	65,W3FLDU3,F
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
#1a
	WLW	3,W3SPNDU1,FF
	WLLW	-1,seq_strtdunk,M5REVDU11,85
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,goes_up_sp
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
	WLL	-1,seq_randm,#2a
	WLW	3,W8OHP201,F
	WLLW	-1,seq_strtdunk,W8OHP215,86
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,W8OHP202,F
	WLW	3,W8OHP203,F
	WLW	3,W8OHP204,F
	WLW	3,W8OHP205,F
	WLW	3,W8OHP206,F
	WLW	54,W8OHP207,F
	WLW	3,W8OHP208,F
	WLW	3,W8OHP209,F
	WLW	2,W8OHP210,F
	WLW	2,W8OHP211,F
	WLW	2,W8OHP212,F
	WLWWW	-1,seq_offset,0,0,18		;infront of net
	WLW	2,W8OHP213,F
	WLW	1,W8OHP214,F
	WLW	-1,seq_slamball,20
	WLW	15,W8OHP214,F
	WLW	500,W8OHP215,F
	WLW	-1,seq_newdir,1*16
	W0

#2a
	WLW	3,W2THPW1,F
	WLLW	-1,seq_strtdunk,W2THPW12,86
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,W2THPW2,F
	WLW	3,W2THPW3,F
	WLW	3,W2THPW4,F
	WLW	3,W2THPW5,F
	WLW	59,W2THPW6,F
	WLW	3,W2THPW7,F
	WLW	2,W2THPW8,F
	WLW	2,W2THPW9,F
	WLW	1,W2THPW10,F
	WLWWW	-1,seq_offset,0,0,20		;infront of net
	WLW	1,W2THPW11,F
	WLW	-1,seq_slamball,15
	WLW	15,W2THPW11,F
	WLW	500,W2THPW12,F
	WLW	3,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
	W0

#3
;	WLL	-1,seq_randm,#3a
;	WLW	3,W3SMDU1,F
;	WLLW	-1,seq_strtdunk,W3SMDU9,86
;	WLW	-1,seq_jam_speech,JAM_GREAT
;	WLW	3,W3SMDU2,F
;	WLW	3,W3SMDU3,F
;	WLW	3,W3SMDU4,F
;	WLW	69,W3SMDU5,F
;	WLW	2,W3SMDU6,F
;	WLW	2,W3SMDU7,F
;	WLW	1,W3SMDU8,F
;	WLW	-1,seq_slamball,15
;	WLW	15,W3SMDU8,F
;	WLW	500,W3SMDU9,F
;	WLW	4,W3SWDU11,F
;	WLW	4,W3SWDU12,F
;	WLW	-1,seq_newdir,2*16
;	W0
;#3a
	WLW	3,W3CANN02,F
	WLLW	-1,seq_strtdunk,W3SMDU9,95
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,tarzan
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
#4
	WLL	-1,seq_randm,#4a
	WLW	3,S8ALY401,F
	WLLW	-1,seq_strtdunk,S8ALY414,86
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,S8ALY402,F
	WLW	3,S8ALY403,F
	WLW	3,S8ALY404,F
	WLW	3,S8ALY405,F
	WLW	57,S8ALY406,F
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
#4a
	WLW	3,W4THPW1,F
	WLLW	-1,seq_strtdunk,W4THPW10,86
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,W4THPW2,F
	WLW	3,W4THPW3,F
	WLW	3,W4THPW4,F
	WLW	69,W4THPW5,F
	WLW	3,W4THPW6,F
	WLW	2,W4THPW7,F
	WLWWW	-1,seq_offset,0,0,-20		;behind net
	WLW	2,W4THPW8,F
	WLW	1,W4THPW9,F
	WLW	-1,seq_slamball,15
	WLW	5,W4THPW9,F
	WLW	500,W4THPW10,F
	WLW	3,W4THPW11,F
	WLW	3,W4THPW12,F
	WLW	3,W4THPW13,F
	WLW	-1,seq_newdir,3*16
	W0
#5
	WLW	3,W8CLSD01,F
	WLLW	-1,seq_strtdunk,W8CLSD12,86
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,W8CLSD02,F
	WLW	3,W8CLSD03,F
	WLW	3,W8CLSD04,F
	WLW	3,W8CLSD05,F
	WLW	66,W8CLSD06,F
	WLW	2,W8CLSD07,F
	WLW	2,W8CLSD08,F
	WLW	2,W8CLSD09,F
	WLW	1,W8CLSD10,F
	WLW	-1,seq_slamball,15
	WLW	10,W8CLSD10,F
	WLW	3,W8CLSD11,F
	WLW	500,W8CLSD12,F
	WLW	-1,seq_newdir,4*16
	W0
#5a

	WLW	3,W4THPW1,F
	WLLW	-1,seq_strtdunk,W4THPW10,86
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,raises_up_sp
	WLW	3,W4THPW2,F
	WLW	3,W4THPW3,F
	WLW	3,W4THPW4,F
	WLW	69,W4THPW5,F
	WLW	3,W4THPW6,F
	WLW	2,W4THPW7,F
	WLW	2,W4THPW8,F
	WLW	1,W4THPW9,F
	WLW	-1,seq_slamball,15
	WLW	5,W4THPW9,F
	WLW	500,W4THPW10,F
	WLW	3,W4THPW11,F
	WLW	3,W4THPW12,F
	WLW	3,W4THPW13,F
	WLW	-1,seq_newdir,3*16
	W0


seq_randm
	move	@HCOUNT,a14
	btst	0,a14
	jrnz	sran_1
	move	*b4,b4,L
	rets
sran_1
	addk	32,b4
	rets
		

#********************************
ddunk_strt2_t


;FIX!!!
;Add these options to double dunks
;quicklay_t
;	.word	NOJUMP_M|SHOOT_M|NOJOY_M
;	.long	seq_stand
;	.long	#1,#2,#3,#4,#5,#4,#3,#2
;	.asg	3,N
;
;#1
;	WLW	2,S1SETLA1,F
;	WL	-1,seq_jump
;	WLW	3,S1SETLA2,F
;	WLW	3,S1SETLA3,F
;	WLW	3,S1SETLA4,F
;	WLW	70,S1SETLA5,F
;	WLW	2,S1SETLA5,F
;	WLW	70,S1SETLA6,F
;	WLW	3,S1SETLA7,F
;	WLW	3,S1SETLA8,F
;	WLW	3,S1SETLA9,F
;	WLW	-1,seq_newdir,0*16
;	W0
;
;#2
;	WL	-1,pick_rand2
;	WLW	2,S2HBHLA1,F
;	WL	-1,seq_jump
;	WLW	3,S2HBHLA2,F
;	WLW	3,S2HBHLA3,F
;	WLW	3,S2HBHLA4,F
;	WLW	3,S2HBHLA5,F
;	WLW	70,S2HBHLA6,F
;	WLW	1,S2HBHLA6,F
;	WLW	3,S2HBHLA7,F
;	WLW	3,S2HBHLA8,F
;	WLW	70,S2HBHLA9,F
;	WLW	-1,seq_newdir,1*16
;	W0
;
;#3
;	WL	-1,pick_rand3
;	WLW	2,M3SPRLA1,F
;	WL	-1,seq_jump
;	WLW	3,M3SPRLA2,F
;	WLW	3,M3SPRLA3,F
;	WLW	3,M3SPRLA4,F
;	WLW	70,M3SPRLA5,F
;	WLW	3,M3SPRLA6,F
;	WLW	3,M3SPRLA7,F
;	WLW	70,M3SPRLA8,F
;	WLW	3,M3SPRLA9,F
;	WLW	3,M3SPRLA10,F
;	WLW	-1,seq_newdir,1*16
;	W0
;
;#3a
;	WLW	2,S3HBHLA1,F
;	WL	-1,seq_jump
;	WLW	3,S3HBHLA2,F
;	WLW	70,S3HBHLA3,F
;	WLW	3,S3HBHLA3,F
;	WLW	70,S3HBHLA4,F
;	WLW	3,S3HBHLA6,F
;	WLW	3,S3HBHLA7,F
;	WLW	3,S3HBHLA8,F
;	WLW	3,S3HBHLA9,F
;	WLW	-1,seq_newdir,1*16
;	W0
;
;#4
;	WLW	3,S4SETLA1,F
;	WL	-1,seq_jump
;	WLW	3,S4SETLA2,F
;	WLW	3,S4SETLA3,F
;	WLW	3,S4SETLA4,F
;	WLW	70,S4SETLA5,F
;	WLW	1,S4SETLA5,F
;	WLW	70,S4SETLA6,F
;	WLW	3,S4SETLA7,F
;	WLW	3,S4SETLA8,F
;	WLW	3,S4SETLA9,F
;	WLW	-1,seq_newdir,3*16
;	W0
;
;#5
;	WLW	3,S5SETLA1,F
;	WL	-1,seq_jump
;	WLW	3,S5SETLA2,F
;	WLW	3,S5SETLA3,F
;	WLW	3,S5SETLA4,F
;	WLW	70,S5SETLA5,F
;	WLW	2,S5SETLA5,F
;	WLW	3,S5SETLA6,F
;	WLW	70,S5SETLA7,F
;	WLW	3,S5SETLA8,F
;	WLW	3,S5SETLA9,F
;	WLW	3,S5SETLA10,F
;	WLW	-1,seq_newdir,3*16
;	W0


	.word	DFLGS|LAYUP_M
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WL	-1,#zfloat
	WLW	3,W3SETLA4,F
	WLW	3,W3SETLA5,F
	WLW	3,W3SETLA6,F
	WLW	1,W3SETLA7,F
	WL	-1,plyr_lob_ball
	WLW	500,W3SETLA7,F
	WLW	3,W3SETLA8,F
	WLW	3,W3SETLA9,F
	WLW	-1,seq_newdir,0*16
	W0
	
#2
	WL	-1,#zfloat
	WLW	3,W3SETLA4,F
	WLW	3,W3SETLA5,F
	WLW	3,W3SETLA6,F
	WLW	1,W3SETLA7,F
	WL	-1,plyr_lob_ball
	WLW	500,W3SETLA7,F
	WLW	3,W3SETLA8,F
	WLW	3,W3SETLA9,F
	WLW	-1,seq_newdir,0*16
	W0
#3
	WL	-1,seq_randm,#3a
	WL	-1,#zfloat
	WLW	3,S5SETLA1,F
	WLW	3,S5SETLA2,F
	WLW	3,S5SETLA3,F
	WLW	3,S5SETLA4,F
	WLW	2,S5SETLA5,F
	WL	-1,plyr_lob_ball
	WLW	3,S5SETLA6,F
	WLW	500,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	3,S5SETLA10,F
	WLW	-1,seq_newdir,3*16
	W0
#3a
	WLW	2,M3SPRLA1,F
	WLW	3,M3SPRLA2,F
	WLW	3,M3SPRLA3,F
	WLW	3,M3SPRLA4,F
	WLW	2,M3SPRLA5,F
	WL	-1,plyr_lob_ball
	WLW	3,M3SPRLA6,F
	WLW	3,M3SPRLA7,F
	WLW	500,M3SPRLA8,F
	WLW	3,M3SPRLA9,F
	WLW	3,M3SPRLA10,F
	WLW	-1,seq_newdir,1*16
	W0

#4
	WL	-1,#zfloat
	WLW	3,S5SETLA2,F
	WLW	3,S5SETLA3,F
	WLW	3,S5SETLA4,F
	WLW	2,S5SETLA5,F
	WL	-1,plyr_lob_ball
	WLW	2,S5SETLA5,F
	WLW	3,S5SETLA6,F
	WLW	500,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	3,S5SETLA10,F
	WLW	-1,seq_newdir,3*16
	W0
#5
	WL	-1,#zfloat
	WLW	3,S5SETLA2,F
	WLW	3,S5SETLA3,F
	WLW	3,S5SETLA4,F
	WLW	2,S5SETLA5,F
	WL	-1,plyr_lob_ball
	WLW	2,S5SETLA5,F
	WLW	3,S5SETLA6,F
	WLW	500,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	3,S5SETLA10,F
	WLW	-1,seq_newdir,3*16
	W0

#zfloat
	clr	a0
	move	*a13(plyr_seqdir),a14
	jrz	#noflt
	subk	1,a14
	jrz	#noflt
	subk	6,a14
	jrz	#noflt
	move	*a8(OZVEL),a0,L
	addi	-0f000h,a0
#noflt	move	a0,*a8(OZVEL),L

	move	*a8(OXVEL),a0,L
	sra	1,a0
	move	a0,*a8(OXVEL),L
	rets



#********************************
dunkq3_t
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
	WLL	-1,maybe_chnge_seq,#3a
	WLW	3,W3SMDU1,F
	WLLW	-1,seq_strtdunk,W3SMDU9,95
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,goes_up_sp
	WLW	3,W3SMDU2,F
	WLW	3,W3SMDU3,F
	WLW	3,W3SMDU4,F
	WLW	13,W3SMDU5,F
	WLW	3,W3SMDU4,F
	WLW	3,W3SMDU3,F
	WLW	3,W3SMDU2,F
	WLW	2,W3CANN04,F
	WLW	2,W3CANN06,F
	WLW	2,W3CANN08,F
	WLL	-1,seq_snd,cannonbal_sp
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

	WLW	2,W3CANN06,F
	WLW	2,W3CANN04,F

	WLW	2,W3SMDU2,F
	WLW	2,W3SMDU3,F
	WLW	2,W3SMDU4,F
	WLW	2,W3SMDU5,F
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
   	
#3a
	WLW	3,W3CRZDU1,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,95
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3CRZDU2,F
	WLW	3,W3CRZDU3,F
	WLW	3,W3CRZDU4,F
	WLW	3,W3CRZDU5,F
	WLW	3,W3CRZDU6,F
	WLW	3,W3CRZDU7,F
	WLW	3,W3CRZDU8,F
	WLW	3,W3CRZDU9,F
	WLW	3,W3CRZDU10,F
	WLW	3,W3CRZDU11,F
	WLW	2,W3CRZDU12,F
	WLW	3,W3CRZDU13,F
	WLW	2,W3CRZDU14,F
	WLW	3,W3CRZDU15,F
	WLW	2,W3CRZDU3,F

	WLW	3,W3SMDU2,F
	WLW	2,W3CANN04,F
	WLW	2,W3CANN06,F
	WLW	2,W3CANN08,F
	WLL	-1,seq_snd,cannonbal_sp
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
	WLW	2,W3CANN06,F
	WLW	2,W3CANN04,F

	WLW	2,W3SMDU2,F
	WLW	2,W3SMDU3,F
	WLW	2,W3SMDU4,F
	WLW	5,W3SMDU5,F
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


maybe_chnge_seq
	move	@HCOUNT,a14
	btst	0,a14
	jrnz	mcs_1
	move	*b4,b4,L
	rets
mcs_1
	addk	32,b4
	rets


#********************************
dunks_t
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	3,S3SORDU1,F
	WLLW	-1,seq_strtdunk,S3SORDU6,80
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,S3SORDU2,F
	WLW	3,S3SORDU3,F
	WLW	3,S3SORDU4,F
	WLW	67,S3SORDU5,F
	WLW	-1,seq_slamball,15
	WLW	15,S3SORDU5,F
	WLW	500,S3SORDU6,F
	WLW	3,S3SORDU7,F
	WLW	3,S3SORDU8,F
	W0
#1
#4
#5
	W0

#********************************
dunks2_t
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,M5OHPB1,F
	WLLW	-1,seq_strtdunk,M5OHPB10,20
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_low_dnk_spch
	WLW	2,M5OHPB2,F
	WLW	2,M5OHPB3,F
	WLW	2,M5OHPB4,F
	WLW	4,M5OHPB5,F
	WLW	2,M5OHPB6,F
	WLW	1,M5OHPB7,F
	WLW	1,M5OHPB8,F
	WLW	1,M5OHPB9,F
	WLWWW	-1,seq_offset,0,0,20
	WLW	-1,seq_slamball,15
	WLW	12,M5OHPB9,F
	WLW	500,M5OHPB10,F
	WLW	3,M5OHPB11,F
	WLW	3,M5OHPB12,F
	WLW	-1,seq_newdir,0*16
#2
#3
#4
#5
	W0


#********************************
dunkt_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	3,W3CRZDU1,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,77
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3CRZDU2,F
	WLW	2,W3CRZDU3,F
	WLW	3,W3CRZDU4,F
	WLW	2,W3CRZDU5,F
	WLW	3,W3CRZDU6,F
	WLW	2,W3CRZDU7,F
	WLW	3,W3CRZDU8,F
	WLW	2,W3CRZDU9,F
	WLW	3,W3CRZDU10,F
	WLW	2,W3CRZDU11,F
	WLW	3,W3CRZDU12,F
	WLW	2,W3CRZDU13,F
	WLW	3,W3CRZDU14,F
	WLW	2,W3CRZDU15,F

	WLW	3,W3CRZDU3,F
	WLW	2,W3CRZDU4,F
	WLW	3,W3CRZDU5,F
	WLW	2,W3CRZDU6,F
	WLW	3,W3CRZDU7,F
	WLW	2,W3CRZDU8,F
	WLW	3,W3CRZDU9,F
	WLW	2,W3CRZDU10,F
	WLW	3,W3CRZDU11,F
	WLW	2,W3CRZDU12,F
	WLW	3,W3CRZDU13,F
	WLW	2,W3CRZDU14,F
	WLW	3,W3CRZDU15,F
	WLW	2,W3CRZDU16,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	2,W3CRZDU17,F
	WLW	-1,seq_slamball,15
	WLW	15,W3CRZDU17,F
	WLW	500,W3CRZDU18,F
	WLW	3,W3CRZDU19,F
	WLW	3,W3CRZDU20,F
	WLW	-1,seq_newdir,0*16
	W0
#1
#4
#5
	W0

#********************************
dunkt2_t
;(medium range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
	WLW	3,W3CRZDU1,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,52
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_low_dnk_spch
	WLW	3,W3CRZDU2,F
	WLW	3,W3CRZDU3,F
	WLW	3,W3CRZDU4,F
	WLW	3,W3CRZDU5,F
	WLW	3,W3CRZDU6,F
	WLW	3,W3CRZDU7,F
	WLW	3,W3CRZDU8,F
	WLW	3,W3CRZDU9,F
	WLW	3,W3CRZDU10,F
	WLW	3,W3CRZDU11,F
	WLW	3,W3CRZDU12,F
	WLW	3,W3CRZDU13,F
	WLW	3,W3CRZDU14,F
	WLW	3,W3CRZDU15,F
	WLW	3,W3CRZDU16,F
	WLW	1,W3CRZDU17,F
	WLWWW	-1,seq_offset,3,0,0
	WLW	-1,seq_slamball,15
	WLW	15,W3CRZDU17,F
	WLW	500,W3CRZDU18,F
	WLW	3,W3CRZDU19,F
	WLW	3,W3CRZDU20,F
	WLW	-1,seq_newdir,0*16
	W0

#1
#5
	W0

#********************************
dunkt3_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
;del	WLW	3,W3CRZDU1,F
	WLW	2,W3CRZDU2,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,84
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,W3CRZDU2,F
	WLW	3,W3CRZDU3,F
	WLW	3,W3CRZDU4,F
	WLW	3,W3CRZDU5,F
	WLW	3,W3CRZDU6,F
	WLW	3,W3CRZDU7,F
	WLW	39,W3CRZDU8,F
	WLW	3,W3CRZDU9,F
	WLW	3,W3CRZDU10,F
	WLW	3,W3CRZDU11,F
	WLW	3,W3CRZDU12,F
	WLW	3,W3CRZDU13,F
	WLW	3,W3CRZDU14,F
	WLW	3,W3CRZDU15,F
	WLW	2,W3CRZDU16,F
;	WLWWW	-1,seq_offset,0,0,19
	WLW	1,W3CRZDU17,F
	WLW	-1,seq_slamball,15
	WLW	15,W3CRZDU17,F
	WLW	500,W3CRZDU18,F
	WLW	3,W3CRZDU19,F
	WLW	3,W3CRZDU20,F
	WLW	-1,seq_newdir,0*16
	W0

#1
#4
#5
	W0

#********************************
dunkt4_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	W0


#********************************
dunkt5_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
	WLW	3,W3CRZDU1,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,77
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3CRZDU2,F
	WLW	2,W3CRZDU3,F
	WLW	3,W3CRZDU4,F
	WLW	2,W3CRZDU5,F
	WLW	3,W3CRZDU6,F
	WLW	2,W3CRZDU7,F
	WLW	3,W3CRZDU8,F
	WLW	2,W3CRZDU9,F
	WLW	3,W3CRZDU10,F
	WLW	2,W3CRZDU11,F
	WLW	3,W3CRZDU12,F
	WLW	2,W3CRZDU13,F
	WLW	3,W3CRZDU14,F
	WLW	2,W3CRZDU15,F

	WLW	3,W3CRZDU3,F
	WLW	2,W3CRZDU4,F
	WLW	3,W3CRZDU5,F
	WLW	2,W3CRZDU6,F
	WLW	3,W3CRZDU7,F
	WLW	2,W3CRZDU8,F
	WLW	3,W3CRZDU9,F
	WLW	2,W3CRZDU10,F
	WLW	3,W3CRZDU11,F
	WLW	2,W3CRZDU12,F
	WLW	3,W3CRZDU13,F
	WLW	2,W3CRZDU14,F
	WLW	3,W3CRZDU15,F
	WLW	2,W3CRZDU16,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	2,W3CRZDU17,F
	WLW	-1,seq_slamball,15
	WLW	15,W3CRZDU17,F
	WLW	500,W3CRZDU18,F
	WLW	3,W3CRZDU19,F
	WLW	3,W3CRZDU20,F
	WLW	-1,seq_newdir,0*16
	W0

#1
#5
	W0

#********************************
dunku_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
#3
#4
#5
	W0

	.ref	ball_convfmprel,plyr_setshtdly
	.ref	ballfree,ballobj_p,ballpnum

;#seq_bounce_ball_off_floor
;
;	calla	ball_convfmprel
;	move	@ballobj_p,a0,L
;
;	clr	a14
;	move	a14,*a0(OZVEL),L
;	move	a14,*a13(plyr_ownball)
;	not	a14
;	move	a14,@ballpnum		;No owner
;	move	a14,@ballfree		;0=ball not free
;
;	movi	97c00h,a14
;	move	a14,*a0(OYVEL),L
;	movi	-200000,a14
;	move	a14,*a0(OXVEL),L
;
;	movi	30,a0
;	calla	plyr_setshtdly
;	rets

#********************************
dunku2_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,M5OHPB1,F
	WLLW	-1,seq_strtdunk,M2DKDU14,79
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,M5OHPB2,F
	WLW	3,W3SDTUK4,F
	WLW	3,W3SDTUK5,F
	WLW	3,W3SDTUK6,F
	WLW	3,W3SDTUK7,F
	WLW	3,W3SDTUK8,F
	WLW	3,W3SDTUK9,F
	WLW	40,W3SDTUK10,F
	WLW	3,W3SDTUK11,F
	WLW	3,W3SDTUK12,F
	WLW	3,W3SDTUK13,F
	WLW	3,W3SDTUK14,F
	WLW	3,W3SDTUK15,F
	WLW	3,M2DKDU12,F
	WLW	1,M2DKDU13,F
	WLW	-1,seq_slamball,15
	WLW	15,M2DKDU13,F
	WLW	500,M2DKDU14,F
	WLW	3,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
	W0
#2
#3
	WLW	3,W3SDTUK1,F
	WLLW	-1,seq_strtdunk,W3SDTUK10,81
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SDTUK2,F
	WLW	3,W3SDTUK3,F
	WLW	3,W3SDTUK4,F
	WLW	3,W3SDTUK5,F
	WLW	3,W3SDTUK6,F
	WLW	3,W3SDTUK7,F
	WLW	3,W3SDTUK8,F
	WLW	3,W3SDTUK9,F
	WLW	37,W3SDTUK10,F
	WLW	3,W3SDTUK11,F
	WLW	3,W3SDTUK12,F
	WLW	3,W3SDTUK13,F
	WLW	3,W3SDTUK14,F
	WLW	3,W3SDTUK15,F
	WLW	3,M2DKDU12,F
	WLWWW	-1,seq_offset,0,0,18			;in front of net
	WLW	1,M2DKDU13,F
	WLW	-1,seq_slamball,15
	WLW	15,M2DKDU13,F
	WLW	500,M2DKDU14,F
	WLW	3,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
#4
#5
	W0

#********************************
dunku3_t
;(short range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	2,M5OHPB1,F
	WLLW	-1,seq_strtdunk,W3SDTUK10,31
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	2,M5OHPB2,F
	WLW	2,W3SDTUK4,F
	WLW	2,W3SDTUK5,F
	WLW	2,W3SDTUK6,F
	WLW	2,W3SDTUK7,F
	WLW	2,W3SDTUK8,F
	WLW	2,W3SDTUK9,F
	WLW	2,W3SDTUK10,F
	WLW	2,W3SDTUK11,F
	WLW	2,W3SDTUK12,F
	WLW	2,W3SDTUK13,F
	WLW	1,W3SDTUK14,F
	WLW	1,W3SDTUK15,F
	WLW	1,M2DKDU12,F
	WLW	1,M2DKDU13,F
	WLW	-1,seq_slamball,15
	WLW	12,M2DKDU13,F
	WLW	500,M2DKDU14,F
	WLW	3,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
	W0
#2
#3
	WLW	3,W3SDTUK1,F
	WLLW	-1,seq_strtdunk,W3SDTUK10,31
	WLW	-1,seq_jam_speech,JAM_GOOD
	WLW	2,W3SDTUK2,F
	WLW	2,W3SDTUK3,F
	WLW	2,W3SDTUK4,F
	WLW	2,W3SDTUK5,F
	WLW	2,W3SDTUK6,F
	WLW	2,W3SDTUK7,F
	WLW	2,W3SDTUK8,F
	WLW	2,W3SDTUK9,F
	WLW	2,W3SDTUK10,F
	WLW	2,W3SDTUK11,F
	WLW	2,W3SDTUK12,F
	WLW	2,W3SDTUK13,F
	WLWWW	-1,seq_offset,0,0,18			;in front of net
	WLW	1,W3SDTUK14,F
	WLW	1,W3SDTUK15,F
	WLW	1,M2DKDU12,F
	WLW	1,M2DKDU13,F
	WLW	-1,seq_slamball,15
	WLW	12,M2DKDU13,F
	WLW	500,M2DKDU14,F
	WLW	3,M2DKDU15,F
	WLW	3,M2DKDU16,F
	WLW	-1,seq_newdir,1*16
#4
#5
	W0


#********************************
dunkv_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	3,W3ARMSP1,F
	WLLW	-1,seq_strtdunk,W3ARMSP17,75
	WL	-1,seq_high_dnk_spch
	WLW	3,W3ARMSP3,F
	WLW	3,W3ARMSP4,F
	WLW	3,W3ARMSP5,F
	WLW	3,W3ARMSP6,F
	WLW	3,W3ARMSP7,F
	WLW	38,W3ARMSP8,F
	WLW	3,W3ARMSP9,F
	WLW	3,W3ARMSP10,F
	WLW	3,W3ARMSP11,F
	WLW	3,W3ARMSP12,F
	WLW	3,W3ARMSP13,F
	WLW	3,W3ARMSP14,F
	WLW	3,W3ARMSP15,F
	WLW	1,W3ARMSP16,F
	WLW	-1,seq_slamball,15
	WLL	-1,seq_snd,tomahk_hm_sp
	WLW	7,W3ARMSP16,F
	WLW	500,W3ARMSP17,F
	WLW	-1,seq_newdir,2*16
#1
#4
#5
	W0

#********************************
dunkv2_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	3,W3ARMSP1,F
	WLLW	-1,seq_strtdunk,W3ARMSP17,81
	WLW	-1,seq_jam_speech,JAM_GREAT
	WLL	-1,seq_snd,ooooooh_sp
	WLW	3,W3ARMSP3,F
	WLW	3,W3ARMSP4,F
	WLW	3,W3ARMSP5,F
	WLW	3,W3ARMSP6,F
	WLW	3,W3ARMSP7,F
	WLW	3,W3ARMSP8,F
	WLW	3,W3ARMSP9,F
	WLW	3,W3ARMSP10,F
	WLW	3,W3ARMSP11,F
	WLW	3,W3ARMSP12,F
	WLW	3,W3ARMSP13,F
	WLW	3,W3ARMSP14,F
	WLW	3,W3ARMSP15,F
	WLW	3,W3ARMSP16,F
	WLW	3,W3ARMSP4,F
	WLW	3,W3ARMSP5,F
	WLW	3,W3ARMSP6,F
	WLW	3,W3ARMSP7,F
	WLW	3,W3ARMSP8,F
	WLW	3,W3ARMSP9,F
	WLW	3,W3ARMSP10,F
	WLW	3,W3ARMSP11,F
	WLW	3,W3ARMSP12,F
	WLW	3,W3ARMSP13,F
	WLW	3,W3ARMSP14,F
	WLW	3,W3ARMSP15,F
	WLW	3,W3ARMSP16,F
	WLW	-1,seq_slamball,15
	WLL	-1,seq_snd,tomahk_hm_sp
	WLW	7,W3ARMSP16,F
	WLW	500,W3ARMSP17,F
	WLW	-1,seq_newdir,2*16

#1
#4
#5
	W0

#********************************
dunkv3_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
	WLW	3,W3ARMSP1,F
	WLLW	-1,seq_strtdunk,W3ARMSP17,110
	WLL	-1,seq_snd,ooooooh_sp
	WLW	3,W3ARMSP3,F
	WLW	3,W3ARMSP4,F
	WLW	3,W3ARMSP5,F
	WLW	3,W3ARMSP6,F
	WLW	3,W3ARMSP7,F
	WLW	3,W3ARMSP8,F
	WLW	3,W3ARMSP9,F
	WLW	3,W3ARMSP10,F
	WLW	3,W3ARMSP11,F
	WLW	3,W3ARMSP12,F
	WLW	3,W3ARMSP13,F
	WLW	3,W3ARMSP14,F
	WLW	3,W3ARMSP15,F
	WLW	3,W3ARMSP16,F
	WLW	3,W3ARMSP4,F
	WLW	3,W3ARMSP5,F
	WLW	3,W3ARMSP6,F
	WLW	3,W3ARMSP7,F
	WLW	3,W3ARMSP8,F
	WLW	3,W3ARMSP9,F
	WLW	3,W3ARMSP10,F
	WLW	3,W3ARMSP11,F
	WLW	3,W3ARMSP12,F
	WLW	3,W3ARMSP13,F
	WLW	2,W3ARMSP14,F
	WLW	3,W3ARMSP15,F
	WLW	2,W3ARMSP16,F

	WLW	3,W3ARMSP4,F
	WLW	2,W3ARMSP5,F
	WLW	3,W3ARMSP6,F
	WLW	2,W3ARMSP7,F
	WLW	3,W3ARMSP8,F
	WLW	2,W3ARMSP9,F
	WLW	3,W3ARMSP10,F
	WLW	2,W3ARMSP11,F
	WLW	3,W3ARMSP12,F
	WLW	2,W3ARMSP13,F
	WLW	3,W3ARMSP14,F
	WLW	2,W3ARMSP15,F
	WLW	1,W3ARMSP16,F
	WLW	-1,seq_slamball,15
	WLL	-1,seq_snd,tomahk_dk_sp
	WLW	7,W3ARMSP16,F
	WLW	500,W3ARMSP17,F
	WLW	-1,seq_newdir,2*16
#1
#4
#5
	W0

#********************************
dunkv4_t
;(short range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
#3
#4
	WLW	3,W3ARMSP1,F
	WLLW	-1,seq_strtdunk,W3ARMSP17,24
;	WLW	1,W3ARMSP3,F
	WLW	1,W3ARMSP4,F
	WLW	1,W3ARMSP5,F
	WLW	1,W3ARMSP6,F
	WLW	1,W3ARMSP7,F
	WLW	1,W3ARMSP8,F
	WLW	1,W3ARMSP9,F
	WLW	1,W3ARMSP10,F
	WLW	1,W3ARMSP11,F
	WLW	1,W3ARMSP12,F
	WLW	1,W3ARMSP13,F
	WLW	1,W3ARMSP14,F
	WLW	1,W3ARMSP15,F
	WLW	1,W3ARMSP16,F
	WLW	-1,seq_slamball,15
	WLL	-1,seq_snd,tomahk_hm_sp
	WLW	7,W3ARMSP16,F
	WLW	500,W3ARMSP17,F
	WLW	-1,seq_newdir,2*16

#1
#5
	W0

#********************************
dunkw_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
#4
#5
	WLW	3,W4SDSLM1,F
	WLLW	-1,seq_strtdunk,W4SDSLM17,84
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,W4SDSLM3,F
	WLW	3,W4SDSLM4,F
	WLW	3,W4SDSLM6,F
	WLW	3,W4SDSLM7,F
	WLW	3,W4SDSLM8,F
	WLW	3,W4SDSLM9,F
	WLW	3,W4SDSLM10,F
	WLW	46,W4SDSLM12,F
	WLW	3,W4SDSLM13,F
	WLW	3,W4SDSLM14,F
	WLW	3,W4SDSLM15,F
	WLW	3,W4SDSLM16,F
	WLW	3,W4SDSLM17,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	1,W4SDSLM18,F
	WLW	-1,seq_slamball,15
	WLW	10,W4SDSLM18,F
	WLW	500,W3PLDDU15,F
	WLW	-1,seq_newdir,3*16
#1
#2
	W0

#********************************
dunkw2_t
;(medium,far range)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
#4
#5
	WLW	3,W4SDSLM1,F
	WLLW	-1,seq_strtdunk,W4SDSLM17,90
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W4SDSLM3,F
	WLW	3,W4SDSLM4,F
	WLW	3,W4SDSLM6,F
	WLW	3,W4SDSLM7,F
	WLW	3,W4SDSLM8,F
	WLW	3,W4SDSLM9,F
	WLW	3,W4SDSLM10,F
	WLW	56,W4SDSLM12,F
	WLW	3,W4SDSLM13,F
	WLW	3,W4SDSLM14,F
	WLW	2,W4SDSLM15,F
	WLW	2,W4SDSLM16,F
	WLW	1,W4SDSLM17,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	1,W4SDSLM18,F
	WLW	-1,seq_slamball,15
	WLW	10,W4SDSLM18,F
	WLW	500,W3PLDDU15,F
	WLW	-1,seq_newdir,3*16
#1
#2
	W0

#********************************
dunkw3_t
;(medium, far)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#5
	WLW	1,W3SPLD02,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,90
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLL	-1,seq_goto_line,#5a
	WLW	3,W3SPLD02,F
#3
#4
	WLW	3,W3SPLD01,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,90
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPLD02,F
#5a	WLW	2,W3SPLD03,F
	WLW	3,W3SPLD04,F
	WLW	2,W3SPLD05,F
	WLW	3,W3SPLD06,F
	WLW	2,W3SPLD07,F
	WLW	3,W3SPLD08,F
	WLW	2,W3SPLD09,F
	WLW	3,W3SPLD10,F
	WLW	2,W3SPLD11,F
	WLW	3,W3SPLD12,F
	WLW	2,W3SPLD13,F
	WLW	44,W3SPLD14,F
	WLW	3,W3SPLD15,F
	WLW	2,W3SPLD16,F
	WLW	3,W3SPLD17,F
	WLW	2,W3SPLD18,F
	WLW	2,W3SPLD19,F
	WLW	2,W3SPLD20,F
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
#1
#2
	W0

#********************************
dunkx_t
;(medium, far)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#5
	WLW	1,W3SPLD02,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,90
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLL	-1,seq_goto_line,#5a
	WLW	3,W3SPLD02,F
#3
#4
	WLW	3,W3SPLD01,F
	WLLW	-1,seq_strtdunk,W3CRZDU18,90
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W3SPLD02,F
#5a	WLW	2,W3SPLD03,F
	WLW	2,W3SPLD04,F
	WLW	2,W3SPLD05,F
	WLW	2,W3SPLD06,F
	WLW	2,W3SPLD07,F
	WLW	2,W3SPLD08,F
	WLW	2,W3SPLD09,F
	WLW	2,W3SPLD10,F
	WLW	2,W3SPLD11,F
	WLW	2,W3SPLD12,F
	WLW	2,W3SPLD13,F
	WLW	17,W3SPLD14,F
	WLW	2,W3SPLD15,F
	WLW	2,W3SPLD16,F
	WLW	2,W3SPLD17,F
	WLW	2,W3SPLD18,F
	WLW	2,W3SPLD19,F

	WLW	2,W3CRZDU11,F
	WLW	2,W3CRZDU12,F
	WLW	2,W3CRZDU13,F
	WLW	2,W3CRZDU14,F
	WLW	2,W3CRZDU15,F

	WLW	2,W3CRZDU3,F
	WLW	2,W3CRZDU4,F
	WLW	2,W3CRZDU5,F
	WLW	2,W3CRZDU6,F
	WLW	2,W3CRZDU7,F
	WLW	2,W3CRZDU8,F
	WLW	3,W3CRZDU9,F
	WLW	2,W3CRZDU10,F
	WLW	3,W3CRZDU11,F
	WLW	2,W3CRZDU12,F
	WLW	2,W3CRZDU13,F
	WLW	2,W3CRZDU14,F
	WLW	2,W3CRZDU15,F
	WLW	1,W3CRZDU16,F
	WLWWW	-1,seq_offset,0,0,18
	WLW	1,W3CRZDU17,F
	WLW	-1,seq_slamball,8
	WLW	6,W3CRZDU17,F
	WLW	500,W3CRZDU18,F
	WLW	3,W3CRZDU19,F
	WLW	3,W3CRZDU20,F
	WLW	-1,seq_newdir,0*16
#1
#2
	W0

#********************************
dunkx2_t
;(medium, far)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
#4
	WLW	3,W8FL2D01,F
	WLLW	-1,seq_strtdunk,W8FL2D17,73
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,W8FL2D02,F
	WLW	3,W8FL2D03,F
	WLW	3,W8FL2D04,F
	WLW	3,W8FL2D05,F
	WLW	3,W8FL2D06,F
	WLW	3,W8FL2D07,F
	WLW	3,W8FL2D08,F
	WLW	3,W8FL2D09,F
	WLW	38,W8FL2D10,F
	WLW	3,W8FL2D11,F
	WLW	2,W8FL2D12,F
	WLW	2,W8FL2D13,F
	WLW	2,W8FL2D14,F
	WLW	2,W8FL2D15,F
	WLW	1,W8FL2D16,F
	WLW	-1,seq_slamball,15
	WLW	10,W8FL2D16,F
	WLW	500,W8FL2D17,F
	WLW	-1,seq_newdir,3*16
	W0
#1
#2
#5
	W0

#********************************
dunkx3_t
;(medium, far)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#3
#4
	WLW	3,W8FL3D01,F
	WLLW	-1,seq_strtdunk,W8FL3D15,73
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,W8FL3D02,F
	WLW	3,W8FL3D03,F
	WLW	3,W8FL3D04,F
	WLW	3,W8FL3D05,F
	WLW	3,W8FL3D06,F
	WLW	3,W8FL3D07,F
	WLW	42,W8FL3D08,F
	WLW	3,W8FL3D09,F
	WLW	3,W8FL3D10,F
	WLW	2,W8FL3D11,F
	WLW	2,W8FL3D12,F
	WLW	2,W8FL3D13,F
	WLWWW	-1,seq_offset,0,0,18		;infront of net
	WLW	1,W8FL3D14,F
	WLW	-1,seq_slamball,8
	WLW	7,W8FL3D14,F
	WLW	500,W8FL3D15,F
	WLW	-1,seq_newdir,4*16
	W0
#1
#2
#5
	W0

#********************************
dunky_t
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,W3OHSD05,F
	WLLW	-1,seq_strtdunk,W3OHSD20,85
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLL	-1,seq_goto_line,#1a

#2
	WLW	3,W3OHSD01,F
	WLLW	-1,seq_strtdunk,W3OHSD20,89
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLL	-1,seq_goto_line,#2a
#3
	WLW	3,W3OHSD01,F
	WLLW	-1,seq_strtdunk,W3OHSD21,89
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
#2a	WLW	3,W3OHSD02,F
	WLW	3,W3OHSD03,F
	WLW	3,W3OHSD04,F
	WLW	3,W3OHSD05,F
#1a	WLW	3,W3OHSD06,F
	WLW	3,W3OHSD07,F
	WLW	3,W3OHSD08,F
	WLW	3,W3OHSD09,F
	WLW	3,W3OHSD10,F
	WLW	3,W3OHSD11,F
	WLW	3,W3OHSD12,F
	WLW	3,W3OHSD13,F
	WLW	40,W3OHSD14,F
	WLW	3,W3OHSD15,F
	WLW	3,W3OHSD16,F
	WLW	3,W3OHSD17,F
	WLW	2,W3OHSD18,F
	WLW	2,W3OHSD19,F
	WLW	2,W3OHSD20,F
	WLW	1,W3OHSD21,F
	WLW	1,W3OHSD22,F
	WLW	-1,seq_slamball,15
	WLW	9,W3OHSD22,F
	WLW	500,W3OHSD23,F
	WLW	3,W3OHSD24,F
	WLW	3,W3OHSD25,F
	WLW	3,W3OHSD26,F
	WLW	-1,seq_newdir,2*16
#4
#5
	W0

#********************************
dunky2_t
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
	WLW	3,W3OHSD05,F
	WLLW	-1,seq_strtdunk,W3OHSD20,73
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLL	-1,seq_goto_line,#1a

#2
	WLW	3,W3OHSD03,F
	WLLW	-1,seq_strtdunk,W3OHSD20,71
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLL	-1,seq_goto_line,#2a

#3
	WLW	3,W3OHSD01,F
	WLLW	-1,seq_strtdunk,W3OHSD21,71
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	2,W3OHSD02,F
#2a	WLW	2,W3OHSD03,F
	WLW	2,W3OHSD04,F
	WLW	2,W3OHSD05,F
#1a	WLW	2,W3OHSD06,F
	WLW	2,W3OHSD07,F
	WLW	2,W3OHSD08,F
	WLW	2,W3OHSD09,F
	WLW	2,W3OHSD10,F
	WLW	2,W3OHSD11,F
	WLW	2,W3OHSD12,F
	WLW	2,W3OHSD13,F
	WLW	2,W3OHSD14,F
	WLW	2,W3OHSD15,F
	WLW	2,W3OHSD16,F
	WLW	2,W3OHSD17,F
	WLW	2,W3OHSD18,F
	WLW	2,W3OHSD19,F
	WLW	2,W3OHSD20,F
	WLW	2,W3OHSD21,F
	WLW	2,W3OHSD22,F
	WLW	2,W3OHSD23,F
	WLW	2,W3OHSD06,F
	WLW	2,W3OHSD07,F
	WLW	2,W3OHSD08,F
	WLW	2,W3OHSD09,F
	WLW	2,W3OHSD10,F
	WLW	2,W3OHSD11,F
	WLW	2,W3OHSD12,F
	WLW	2,W3OHSD13,F
	WLW	2,W3OHSD14,F
	WLW	2,W3OHSD15,F
	WLW	2,W3OHSD16,F
	WLW	2,W3OHSD17,F
	WLW	2,W3OHSD18,F
	WLW	1,W3OHSD19,F
	WLW	1,W3OHSD20,F
	WLW	1,W3OHSD21,F
	WLW	1,W3OHSD22,F
	WLW	-1,seq_slamball,15
	WLW	9,W3OHSD22,F
	WLW	500,W3OHSD23,F
	WLW	3,W3OHSD24,F
	WLW	3,W3OHSD25,F
	WLW	3,W3OHSD26,F
	WLW	-1,seq_newdir,2*16
#4
#5
	W0

#********************************
dunkz_t
;(medium, far)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#5
	WLW	3,W8CLSD01,F
	WLLW	-1,seq_strtdunk,W8CLSD12,65
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_low_dnk_spch
	WLW	3,W8CLSD02,F
	WLW	3,W8CLSD03,F
	WLW	3,W8CLSD04,F
	WLW	3,W8CLSD05,F
	WLW	45,W8CLSD06,F
	WLW	2,W8CLSD07,F
	WLW	2,W8CLSD08,F
	WLW	2,W8CLSD09,F
	WLW	1,W8CLSD10,F
	WLW	-1,seq_slamball,15
	WLW	10,W8CLSD10,F
	WLW	3,W8CLSD11,F
	WLW	500,W8CLSD12,F
	WLW	-1,seq_newdir,4*16
	W0
#1
#2
#3
#4
	W0

#********************************
dunkz2_t
;(medium, far)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#2
	WLW	3,W8OHP201,F
	WLLW	-1,seq_strtdunk,W8OHP215,75
	WLW	-1,seq_jam_speech,JAM_GOOD
	WL	-1,seq_high_dnk_spch
	WLW	3,W8OHP202,F
	WLW	3,W8OHP203,F
	WLW	3,W8OHP204,F
	WLW	3,W8OHP205,F
	WLW	3,W8OHP206,F
	WLW	43,W8OHP207,F
	WLW	3,W8OHP208,F
	WLW	3,W8OHP209,F
	WLW	2,W8OHP210,F
	WLW	2,W8OHP211,F
	WLW	2,W8OHP212,F
	WLWWW	-1,seq_offset,0,0,18		;infront of net
	WLW	2,W8OHP213,F
	WLW	1,W8OHP214,F
	WLW	-1,seq_slamball,20
	WLW	15,W8OHP214,F
	WLW	500,W8OHP215,F
	WLW	-1,seq_newdir,1*16
	W0
#1
#3
#4
#5
	W0

#********************************
dunkz3_t
;(medium, far)
	.word	DFLGS
	.long	seq_stand
	.long	#1,#2,#3,#4
	.long	#5,#4,#3,#2
#1
#2
	WLW	3,W8UND101,F
	WLLW	-1,seq_strtdunk,W8UND119,75
	WLW	-1,seq_jam_speech,JAM_GREAT
	WL	-1,seq_high_dnk_spch
	WLW	3,W8UND102,F
	WLW	3,W8UND103,F
	WLW	3,W8UND104,F
	WLW	3,W8UND105,F
	WLW	3,W8UND106,F
	WLW	3,W8UND107,F
	WLW	3,W8UND108,F
	WLW	3,W8UND109,F
	WLW	3,W8UND110,F
	WLW	33,W8UND111,F
	WLW	3,W8UND112,F
	WLW	3,W8UND113,F
	WLW	2,W8UND114,F
	WLW	2,W8UND115,F
	WLW	2,W8UND116,F
	WLW	2,W8UND117,F
	WLWWW	-1,seq_offset,0,0,18		;infront of net
	WLW	2,W8UND118,F
	WLW	1,W8UND119,F
	WLW	-1,seq_slamball,15
	WLW	10,W8UND119,F
	WLW	500,W8UND120,F
	WLW	-1,seq_newdir,4*16
	W0
#3
#4
#5
	W0



******************************************************************************
	.end
