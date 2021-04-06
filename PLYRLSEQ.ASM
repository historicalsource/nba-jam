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
	.file	"plyrlseq.asm"
	.title	"basketball plyr sequence code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"		;Gsp asm equates
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"dunks.glo"
	.include	"game.equ"
	.include	"macros.hdr"
	.asg		0,SEQT
	.include	"plyr.equ"
;	.include	"layup.tbl"
;	.include	"plyrd2sq.tbl"
;	.include	"hangs.tbl"


;sounds external

;symbols externally defined

	.ref	XEWILPAL

	.ref	plyr_shoot
	.ref	plyr_pass
	.ref	seq_newdir
	.ref	seq_slamball
	.ref	seq_strtdunk
	.ref	seq_jump
	.ref	seq_resetseq
	.ref	seq_stand
	.ref	seq_snd

;	.ref	seq_lay_up_start
	.ref	seq_jam_speech
	.ref	seq_call_name
	.ref	rndrng0

JAM_NONE	equ	0
JAM_EASY	equ	1
JAM_MED		equ	2
JAM_GOOD	equ	3
JAM_GREAT	equ	4

;symbols defined in this file

;	.def	T2DUNK3,T2DUNK4,T2DUNK5
;	.def	T2DUNK6,T2DUNK7,T2DUNK8,T2DUNK9
;	.def	T2DUNK10

;uninitialized ram definitions



;equates for this file

M_YF	.equ	>8000	;Y free (OFLAGS)


	.text

	.ref	plyr_lob_ball



	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF
	.asg	DUNK_M|NOJUMP_M|NOJOY_M|NOCOLLP_M,DFLGS

;#*
;dnkr_lob_ball_t
;	.word	NOJUMP_M|NOJOY_M
;	.long	seq_stand
;	.long	#1,#2,#3,#4,#5,#4,#3,#2
;	.asg	3,N
;#1
;#2
;	W0
;#3
;	WLW	2,M3SPRLA1,F
;	WLW	3,M3SPRLA2,F
;	WLW	3,M3SPRLA3,F
;	WLW	3,M3SPRLA4,F
;	WLW	3,M3SPRLA5,F
;	WL	-1,plyr_lob_ball
;	WLW	2,M3SPRLA5,F
;	WLW	3,M3SPRLA6,F
;	WLW	3,M3SPRLA7,F
;	WLW	50,M3SPRLA8,F
;	WLW	3,M3SPRLA9,F
;	WLW	3,M3SPRLA10,F
;	WLW	-1,seq_newdir,1*16
;	W0
;#4
;#5
;	W0

#*
quicklay_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	3,N

#1
	WLW	2,S1SETLA1,F
	WL	-1,seq_jump
	WLW	3,S1SETLA2,F
	WLW	3,S1SETLA3,F
	WLW	3,S1SETLA4,F
	WLW	70,S1SETLA5,F
	WLW	2,S1SETLA5,F
	WLW	70,S1SETLA6,F
	WLW	3,S1SETLA7,F
	WLW	3,S1SETLA8,F
	WLW	3,S1SETLA9,F
	WLW	-1,seq_newdir,0*16
	W0

#2
	WL	-1,pick_rand2
	WLW	2,S2HBHLA1,F
	WL	-1,seq_jump
	WLW	3,S2HBHLA2,F
	WLW	3,S2HBHLA3,F
	WLW	3,S2HBHLA4,F
	WLW	3,S2HBHLA5,F
	WLW	70,S2HBHLA6,F
	WLW	1,S2HBHLA6,F
	WLW	3,S2HBHLA7,F
	WLW	3,S2HBHLA8,F
	WLW	70,S2HBHLA9,F
	WLW	-1,seq_newdir,1*16
	W0

#3
	WL	-1,pick_rand3
	WLW	2,M3SPRLA1,F
	WL	-1,seq_jump
	WLW	3,M3SPRLA2,F
	WLW	3,M3SPRLA3,F
	WLW	3,M3SPRLA4,F
	WLW	70,M3SPRLA5,F
	WLW	3,M3SPRLA6,F
	WLW	3,M3SPRLA7,F
	WLW	70,M3SPRLA8,F
	WLW	3,M3SPRLA9,F
	WLW	3,M3SPRLA10,F
	WLW	-1,seq_newdir,1*16
	W0

#3a
	WLW	2,S3HBHLA1,F
	WL	-1,seq_jump
	WLW	3,S3HBHLA2,F
	WLW	70,S3HBHLA3,F
	WLW	3,S3HBHLA3,F
	WLW	70,S3HBHLA4,F
	WLW	3,S3HBHLA6,F
	WLW	3,S3HBHLA7,F
	WLW	3,S3HBHLA8,F
	WLW	3,S3HBHLA9,F
	WLW	-1,seq_newdir,1*16
	W0

#4
	WLW	3,S4SETLA1,F
	WL	-1,seq_jump
	WLW	3,S4SETLA2,F
	WLW	3,S4SETLA3,F
	WLW	3,S4SETLA4,F
	WLW	70,S4SETLA5,F
	WLW	1,S4SETLA5,F
	WLW	70,S4SETLA6,F
	WLW	3,S4SETLA7,F
	WLW	3,S4SETLA8,F
	WLW	3,S4SETLA9,F
	WLW	-1,seq_newdir,3*16
	W0

#5
	WLW	3,S5SETLA1,F
	WL	-1,seq_jump
	WLW	3,S5SETLA2,F
	WLW	3,S5SETLA3,F
	WLW	3,S5SETLA4,F
	WLW	70,S5SETLA5,F
	WLW	2,S5SETLA5,F
	WLW	3,S5SETLA6,F
	WLW	70,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	3,S5SETLA10,F
	WLW	-1,seq_newdir,3*16
	W0

pick_rand2
	movk	6,a0
	calla	rndrng0
	sll	5,a0
	addi	rand2_tbl,a0
	move	*a0,a0,L
	jrz	rs2
	move	a0,b4			;sequence to run
rs2
	rets


rand2_tbl
	.long	#3a,0,0,#3a,0,#3a,0

	

pick_rand3
	movk	6,a0
	calla	rndrng0
	sll	5,a0
	addi	rand3_tbl,a0
	move	*a0,a0,L
	jrz	rs3
	move	a0,b4			;sequence to run
;	move	a0,*a13(plyr_ani1st_p)
rs3	rets


rand3_tbl
	.long	#3a,0,#3a,0,0,#3a,0
;	.long	#3a,#3a,#3a,#3a,#3a,#3a,#3a


#*
layup_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	3,N

#1
	WLW	2,S1SETLA1,F
	WL	-1,seq_jump
	WLW	3,S1SETLA2,F
	WLW	3,S1SETLA3,F
	WLW	3,S1SETLA4,F
;	WLW	40,S1SETLA5,F
	WLW	3,S1SETLA5,F
	WL	-1,plyr_shoot
	WLW	2,S1SETLA5,F
	WLW	50,S1SETLA6,F
	WLW	3,S1SETLA7,F
	WLW	3,S1SETLA8,F
	WLW	3,S1SETLA9,F
	WLW	-1,seq_newdir,0*16
	W0

#2
	WLW	2,S2HBHLA1,F
	WL	-1,seq_jump
	WLW	3,S2HBHLA2,F
	WLW	3,S2HBHLA3,F
	WLW	3,S2HBHLA4,F
	WLW	3,S2HBHLA5,F
;	WLW	40,S2HBHLA6,F
	WLW	3,S2HBHLA6,F
	WL	-1,plyr_shoot
	WLW	1,S2HBHLA6,F
	WLW	3,S2HBHLA7,F
	WLW	3,S2HBHLA8,F
	WLW	50,S2HBHLA9,F
	WLW	-1,seq_newdir,1*16
	W0

#3
	WLW	2,M3SPRLA1,F
	WL	-1,seq_jump
	WLW	3,M3SPRLA2,F
	WLW	3,M3SPRLA3,F
	WLW	3,M3SPRLA4,F
	WLW	3,M3SPRLA5,F
	WL	-1,plyr_shoot
	WLW	2,M3SPRLA5,F
	WLW	3,M3SPRLA6,F
	WLW	3,M3SPRLA7,F
	WLW	50,M3SPRLA8,F
	WLW	3,M3SPRLA9,F
	WLW	3,M3SPRLA10,F
	WLW	-1,seq_newdir,1*16
	W0

#3a
	WLW	1,S3HBHLA1,F
	WL	-1,seq_jump
	WLW	3,S3HBHLA1,F
	WLW	3,S3HBHLA2,F
	WLW	3,S3HBHLA3,F
	WL	-1,plyr_shoot
	WLW	3,S3HBHLA3,F
	WLW	50,S3HBHLA4,F
	WLW	3,S3HBHLA6,F
	WLW	3,S3HBHLA7,F
	WLW	3,S3HBHLA8,F
	WLW	3,S3HBHLA9,F
	WLW	-1,seq_newdir,1*16
	W0

#4
	WLW	2,S4SETLA1,F
	WL	-1,seq_jump
	WLW	3,S4SETLA2,F
	WLW	3,S4SETLA3,F
	WLW	3,S4SETLA4,F
	WLW	3,S4SETLA5,F
	WL	-1,plyr_shoot
	WLW	3,S4SETLA5,F
	WLW	50,S4SETLA6,F
	WLW	3,S4SETLA7,F
	WLW	3,S4SETLA8,F
	WLW	3,S4SETLA9,F
	WLW	-1,seq_newdir,3*16
	W0

#5
	WLW	3,S5SETLA1,F
	WL	-1,seq_jump
	WLW	3,S5SETLA2,F
	WLW	3,S5SETLA3,F
	WLW	3,S5SETLA4,F
	WLW	3,S5SETLA5,F
	WL	-1,plyr_shoot
	WLW	2,S5SETLA5,F
	WLW	3,S5SETLA6,F
	WLW	50,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	3,S5SETLA10,F
	WLW	-1,seq_newdir,3*16
	W0


#*
layupreb_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	3,N

#1
	WLW	2,S1SETLA1,F
	WLW	3,S1SETLA2,F
	WLW	3,S1SETLA3,F
	WLW	3,S1SETLA4,F
	WLW	1,S1SETLA5,F
	WL	-1,plyr_shoot
	WLW	2,S1SETLA5,F
	WLW	50,S1SETLA6,F
	WLW	3,S1SETLA7,F
	WLW	3,S1SETLA8,F
	WLW	3,S1SETLA9,F
	WLW	-1,seq_newdir,0*16
	W0


#2
	WLW	2,S2HBHLA1,F
	WLW	3,S2HBHLA2,F
	WLW	3,S2HBHLA3,F
	WLW	3,S2HBHLA4,F
	WLW	3,S2HBHLA5,F
	WLW	1,S2HBHLA6,F
	WL	-1,plyr_shoot
	WLW	2,S2HBHLA6,F
	WLW	3,S2HBHLA7,F
	WLW	3,S2HBHLA8,F
	WLW	50,S2HBHLA9,F
	WLW	-1,seq_newdir,1*16
	W0

#3
	WLW	2,S3HBHLA1,F
	WLW	3,S3HBHLA2,F
	WLW	1,S3HBHLA3,F
	WL	-1,plyr_shoot
	WLW	3,S3HBHLA3,F
	WLW	50,S3HBHLA4,F
	WLW	3,S3HBHLA6,F
	WLW	3,S3HBHLA7,F
	WLW	3,S3HBHLA8,F
	WLW	3,S3HBHLA9,F
	WLW	-1,seq_newdir,1*16
	W0

#4
	WLW	3,S4SETLA1,F
	WLW	3,S4SETLA2,F
	WLW	3,S4SETLA3,F
	WLW	3,S4SETLA4,F
	WLW	1,S4SETLA5,F
	WL	-1,plyr_shoot
	WLW	1,S4SETLA5,F
	WLW	50,S4SETLA6,F
	WLW	3,S4SETLA7,F
	WLW	3,S4SETLA8,F
	WLW	3,S4SETLA9,F
	WLW	-1,seq_newdir,3*16
	W0
#5
	WLW	3,S5SETLA1,F
	WLW	3,S5SETLA2,F
	WLW	3,S5SETLA3,F
	WLW	3,S5SETLA4,F
	WLW	1,S5SETLA5,F
	WL	-1,plyr_shoot
	WLW	2,S5SETLA5,F
	WLW	3,S5SETLA6,F
	WLW	50,S5SETLA7,F
	WLW	3,S5SETLA8,F
	WLW	3,S5SETLA9,F
	WLW	3,S5SETLA10,F
	WLW	-1,seq_newdir,3*16
	W0


	.end





