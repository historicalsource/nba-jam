**************************************************************
*
* Owner:	TURMELL
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		10/8/92
*
* Modified:		Shawn Liptak, 12/11/92	-Split from plyrseq.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/5/93 18:03
**************************************************************
	.file	"plyrseq2.asm"
	.title	"basketball plyr sequence code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"gsp.equ"		;Gsp asm equates
	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"game.equ"
	.include	"macros.hdr"
	.asg		0,SEQT
	.include	"plyr.equ"
	.include	"plyrseq2.tbl"
	.include	"pass.tbl"
	.include	"flail.tbl"
	.include	"world.equ"


;sounds external

	.ref	flail_snd,elbow1_snd,elbow2_snd
	.ref	land_snd,boo_snd
	.ref	fall1_snd


;symbols externally defined

     	.ref	white_pal

	.ref	seq_offset2
	.ref	PLYRFIX_P

	.ref	seq_injury
 	.ref	seq_stuffzx
	.ref	seq_keepzx
	.ref	seq_stayinair
	.ref	seq_elbo,seq_snd,seq_stand,plyr_pass

	.ref	plyr_shoot
	.ref	seq_newdir
	.ref	seq_noballoff

;symbols defined in this file

;	.def	FIREFALP
;	.def	zwilpal

;	.def	PLYRFIX_P
;	.def	NEWILFIX

	.ref	PLYRFX3_P

;uninitialized ram definitions



;equates for this file

M_YF	.equ	>8000	;Y free (OFLAGS)


	.text

*******************************************


	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF



tip_t
	.word	NOJOY_M|NOCOLLP_M|NOBALL_M|NOJUMP_M
	.long	0
	.long	#1,#2,#3,#4,#5,#4,#3,#2

	.asg	3,N

#1
#2
	WLW	N,w2tipst1,F
	WLW	N,w2tipst2,F
	WLW	N,w2tipst3,F
	WLW	N,w2tipst4,F
	WLW	N,w2tipst5,F
	WLW	N,w2tipst4,F
	WLW	N,w2tipst3,F
	WLW	N,w2tipst2,F
	W0

#3
#4
#5
	WLW	4,w4tipst1,F
	WLW	4,w4tipst2,F
	WLW	4,w4tipst3,F
	WLW	4,w4tipst4,F
	WLW	4,w4tipst5,F
	WLW	4,w4tipst4,F
	WLW	4,w4tipst3,F
	WLW	4,w4tipst2,F
	W0

#*
tipj_t
	.word	NOJOY_M|NOCOLLP_M|NOBALL_M|NOJUMP_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2


#1
#2
	WLW	3,w2tip1,F
	WLW	3,w2tip2,F
	WLW	3,w2tip3,F
	WLW	3,w2tip4,F
	WLW	3,w2tip5,F
	WLW	25,w2tip6,F
	WLW	60,w2tip7,F
	WLW	3,w2tip5,F
	WLW	3,w2tip4,F
	W0
#3
#4
#5
	WLW	3,w4tip1,F
	WLW	3,w4tip2,F
	WLW	3,w4tip3,F
	WLW	3,w4tip4,F
	WLW	3,w4tip5,F
	WLW	25,w4tip6,F
	WLW	60,w4tip7,F
	WLW	3,w4tip5,F
	WLW	3,w4tip4,F
	W0

#*

tipstnd_t
;	.word	NOJOY_M|NOCOLLP_M|NOBALL_M|NOJUMP_M
	.word	NOJOY_M|NOCOLLP_M|NOJUMP_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2


#1
#2
	WLW	3,w2hndne5,F
	WLW	3,w2hndne4,F
	WLW	3,w2hndne3,F
	WLW	3,w2hndne2,F
	WLW	3,w2hndne1,F
	WLW	3,w2hndhp1,F
	WLW	3,w2hndhp2,F
	WLW	3,w2hndhp3,F
	WLW	3,w2hndhp4,F

	WLW	26,w2hndhp5,F
	WLW	17,w2hndhp5,F
	WLW	3,w2hndhp4,F
	WLW	3,w2hndhp3,F
	WLW	3,w2hndhp2,F
	WLW	3,w2hndhp1,F
	WLW	4,w2hndne1,F
	WLW	4,w2hndne2,F
	WLW	4,w2hndne3,F
	WLW	4,w2hndne4,F
	WLW	4,w2hndne5,F
	WLW	4,w2hnesw1,F
	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw4,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw1,F

	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw4,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw1,F
	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw4,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw1,F
	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw4,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw1,F

	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw4,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw1,F

	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw4,F
	WLW	4,w2hnesw3,F
	WLW	4,w2hnesw2,F
	WLW	4,w2hnesw1,F

	WLW	4,w2hndne5,F
	WLW	4,w2hndne4,F
	WLW	4,w2hndne3,F
	WLW	4,w2hndne2,F
	WLW	3,w2hndne1,F

	.ref	w2stand1

	WLW	1,w2stand1,F
	W0

#3
#4
#5
	WLW	24,w4hndhp5,F
	WLW	29,w4hndhp5,F
	WLW	29,w4hndhp5,F
	WLW	29,w4hndhp5,F
	WLW	4,w4hndhp4,F
	WLW	4,w4hndhp3,F
	WLW	4,w4hndhp2,F
	WLW	16,w4hndhp1,F
	WLW	4,w4hndne1,F
	WLW	4,w4hndne2,F
	WLW	4,w4hndne3,F
	WLW	4,w4hndne4,F
	WLW	4,w4hndne5,F
	WLW	4,w4hnesw1,F
	WLW	4,w4hnesw2,F
	WLW	4,w4hnesw3,F
	WLW	4,w4hnesw4,F
	WLW	4,w4hnesw3,F
	WLW	4,w4hnesw2,F
	WLW	4,w4hnesw1,F
	WLW	4,w4hnesw2,F
	WLW	4,w4hnesw3,F
	WLW	4,w4hnesw4,F
	WLW	4,w4hnesw3,F
	WLW	4,w4hnesw2,F
	WLW	4,w4hnesw1,F
	WLW	4,w4hnesw2,F
	WLW	4,w4hnesw3,F
	WLW	4,w4hnesw4,F
	WLW	4,w4hnesw3,F
	WLW	4,w4hnesw2,F
	WLW	4,w4hnesw1,F
	WLW	4,w4hnesw2,F
	WLW	4,w4hnesw3,F
	WLW	4,w4hnesw4,F
	WLW	4,w4hnesw3,F
	WLW	4,w4hnesw2,F
	WLW	4,w4hnesw1,F

	WLW	2,w4hndne5,F
	WLW	2,w4hndne4,F
	WLW	2,w4hndne3,F
	WLW	2,w4hndne2,F
	WLW	2,w4hndne1,F

	W0

#*
alleyoop_pas_t
	.word	PASS_M|NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	
#1
	WLW	3,W1ALPAS1,F
	WLW	3,W1ALPAS2,F
	WLW	3,W1ALPAS3,F
	WL	-1,plyr_pass
	WLW	2,W1ALPAS3,F
	WLW	4,W1ALPAS4,F
	WLW	3,W1ALPAS3,F
	WLW	3,W1ALPAS2,F
	WLW	3,W1ALPAS1,F
	W0

#2
	WLW	3,W2ALPAS1,F
	WLW	3,W2ALPAS2,F
	WLW	3,W2ALPAS3,F
	WL	-1,plyr_pass
	WLW	2,W2ALPAS3,F
	WLW	4,W2ALPAS4,F
	WLW	3,W2ALPAS3,F
	WLW	3,W2ALPAS2,F
	WLW	3,W2ALPAS1,F
	W0

#3
	WLW	3,W3ALPAS1,F
	WLW	3,W3ALPAS2,F
	WLW	3,W3ALPAS3,F
	WL	-1,plyr_pass
	WLW	2,W3ALPAS3,F
	WLW	4,W3ALPAS4,F
	WLW	3,W3ALPAS3,F
	WLW	3,W3ALPAS2,F
	WLW	3,W3ALPAS1,F
	W0

#4
	WLW	3,W4ALPAS1,F
	WLW	3,W4ALPAS2,F
	WLW	3,W4ALPAS3,F
	WL	-1,plyr_pass
	WLW	2,W4ALPAS3,F
	WLW	4,W4ALPAS4,F
	WLW	3,W4ALPAS3,F
	WLW	3,W4ALPAS2,F
	WLW	3,W4ALPAS1,F
	W0
	
#5
	WLW	3,W5ALPAS1,F
	WLW	3,W5ALPAS2,F
	WLW	3,W5ALPAS3,F
	WL	-1,plyr_pass
	WLW	2,W5ALPAS3,F
	WLW	4,W5ALPAS4,F
	WLW	3,W5ALPAS3,F
	WLW	3,W5ALPAS2,F
	WLW	3,W5ALPAS1,F
	W0


#*
;passnl2_t
;passnl3_t
passnl_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#1,#1,#1,#1,#1,#1,#1,#1

	.asg	3,N
#choose
;Need to look at dir I was facing - not where pass code tells me to face.
	move	*a13(plyr_old_seqdir),a0
	sll	5,a0
	addi	#tbl,a0
	move	*a0,a0,L
	move	a0,b4
	rets

#tbl	.long	#1a,#2,#3,#4,#5,#6,#7,#8

#1
	WL	-1,#choose
#1a
	WLW	3,W1NLPR1,F
	WLW	3,W1NLPR2,F
	WL	-1,plyr_pass
	WLW	3,W1NLPR3,F
	WLW	4,W1NLPR4,F
	WLW	3,W1NLPR3,F
	WLW	3,W1NLPR2,F
	WLW	3,W1NLPR1,F
	WLW	-1,seq_newdir,0*16
	W0
#2
#8
	WLW	3,W2NLPR1,F
	WLW	3,W2NLPR2,F
	WLW	3,W2NLPR3,F
	WL	-1,plyr_pass
	WLW	4,W2NLPR4,F
	WLW	3,W2NLPR3,F
	WLW	3,W2NLPR2,F
	WLW	3,W2NLPR1,F
	WLW	-1,seq_newdir,1*16
	W0
#3
#7
	WLW	3,W3NLPR1,F
	WLW	3,W3NLPR2,F
	WLW	3,W3NLPR3,F
	WLW	3,W3NLPR4,F
	WL	-1,plyr_pass
	WLW	1,W3NLPR4,F
	WLW	3,W3NLPR3,F
	WLW	3,W3NLPR2,F
	WLW	3,W3NLPR1,F
	WLW	-1,seq_newdir,2*16
	W0
#4
#6
	WLW	3,W4NLPR1,F
	WLW	3,W4NLPR2,F
	WLW	3,W4NLPR3,F
	WL	-1,plyr_pass
	WLW	4,W4NLPR4,F
	WLW	3,W4NLPR3,F
	WLW	3,W4NLPR2,F
	WLW	3,W4NLPR1,F
	WLW	-1,seq_newdir,3*16
	W0
#5
	WLW	3,W5NLPR1,F
	WLW	3,W5NLPR2,F
	WL	-1,plyr_pass
	WLW	3,W5NLPR3,F
	WLW	4,W5NLPR4,F
	WLW	3,W5NLPR3,F
	WLW	3,W5NLPR2,F
	WLW	3,W5NLPR1,F
	WLW	-1,seq_newdir,4*16
	W0


#*
stagger_t
	.word	NOMV_M|NOBALL_M|NOJUMP_M|NOJOY_M|SAMEDIR_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	5,N				;4
#1
	WLW	N,w1flai1,F
	WLL	-1,seq_snd,boo_snd
	WLW	N,w1flai2,F
	WLW	N,w1flai3,F
	WLW	N,w1flai2,F
	WLW	N,w1flai1,F
	W0

#2
	WLW	N,w2flai1,F
	WLL	-1,seq_snd,boo_snd
	WLW	N,w2flai2,F
	WLW	N,w2flai3,F
	WLW	N,w2flai2,F
	WLW	N,w2flai1,F
	W0
#3
	WLW	N,w3flai1,F
	WLL	-1,seq_snd,boo_snd
	WLW	N,w3flai2,F
	WLW	N,w3flai3,F
	WLW	N,w3flai4,F
	WLW	N,w3flai3,F
	WLW	N,w3flai2,F
	WLW	N,w3flai1,F
	W0
#4
	WLW	N,w4flai1,F
	WLL	-1,seq_snd,boo_snd
	WLW	N,w4flai2,F
	WLW	N,w4flai3,F
	WLW	N,w4flai2,F
	WLW	N,w4flai1,F
	W0

#5
	WLW	N,w5flai2,F
	WLL	-1,seq_snd,boo_snd
	WLW	N,w5flai3,F
	WLW	N,w5flai4,F
	WLW	N,w5flai5,F
	WLW	N,w5flai4,F
	WLW	N,w5flai3,F
	WLW	N,w5flai2,F
	W0

#*
fall_t
	.word	NOMV_M|NOBALL_M|NOJUMP_M|NOJOY_M|SAMEDIR_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	2,N
#1
	WLWWW	-1,seq_offset2,0,-32,0
	WLW	N,w1fall1,F
	WLL	-1,seq_snd,fall1_snd
	WLW	N,w1fall2,F
	WLW	N,w1fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w1fall4,F
	WLW	N,w1fall5,F
	WLW	N,w1fall6,F
	WLW	N,w1fall7,F
	WLW	N,w1fall8,F
	WLW	N,w1fall9,F
	WL	-1,seq_stayinair
	WLW	N,w1fall10,F
	WLL	-1,seq_snd,land_snd
	WLW	N,w1fall11,F
	WLW	N,w1fall12,F
	WLW	N,w1fall13,F
	WLW	10,w1fall14,F
	WLW	N,w1fall15,F
	WLW	N,w1fall16,F
	WLW	N,w1fall17,F
	WLW	N,w1fall18,F
	WLW	N,w1fall19,F
	WLW	N,w1fall20,F
	WLW	N,w1fall21,F
	WLW	N,w1fall22,F
	WLW	N,w1fall23,F
	W0

seq_clr_flag
	clr	a0
	move	a0,*a13(plyr_offset_flag)
	rets
#2
	WLWWW	-1,seq_offset2,0,-30,0
	WLW	N,w2fall1,F
	WLL	-1,seq_snd,fall1_snd
	WLW	N,w2fall2,F
	WLW	N,w2fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w2fall4,F
	WLW	N,w2fall5,F
	WLW	N,w2fall6,F
	WLW	N,w2fall7,F
	WLW	N,w2fall8,F
	WL	-1,seq_stayinair
	WLW	N,w2fall9,F
	WLL	-1,seq_snd,land_snd
	WLW	N,w2fall10,F
	WLW	10,w2fall11,F
	WLW	N,w2fall12,F
	WLW	N,w2fall13,F
	WLW	N,w2fall14,F
	WLW	N,w2fall15,F
	WLW	N,w2fall16,F
	WLW	N,w2fall17,F
	WLW	N,w2fall18,F
	WLW	N,w2fall19,F
	WLW	N,w2fall20,F
	WLW	N,w2fall21,F
	W0
#3
	WLWWW	-1,seq_offset2,0,-37,0
	WLW	N,w3fall1,F
	WLL	-1,seq_snd,fall1_snd
	WLW	N,w3fall2,F
	WLW	N,w3fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w3fall4,F
	WLW	N,w3fall5,F
	WLW	N,w3fall6,F
	WLW	N,w3fall7,F
	WLW	N,w3fall8,F
	WLW	N,w3fall9,F
	WLW	N,w3fall10,F
	WLW	N,w3fall11,F
	WLW	N,w3fall12,F
	WL	-1,seq_stayinair
	WLW	N,w3fall13,F
	WLL	-1,seq_snd,land_snd
	WLW	10,w3fall14,F
	WLW	N,w3fall15,F
	WLW	N,w3fall16,F
	WLW	N,w3fall17,F
	WLW	N,w3fall18,F
	WLW	N,w3fall19,F
	WLW	N,w3fall20,F
	WLW	N,w3fall21,F
	WLW	N,w3fall22,F
	WLW	N,w3fall23,F
	WLW	N,w3fall24,F
	W0
#4
	WLWWW	-1,seq_offset2,0,-37,0
	WLW	N,w4fall1,F
	WLL	-1,seq_snd,fall1_snd
	WLW	N,w4fall2,F
	WLW	N,w4fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w4fall4,F
	WLW	N,w4fall5,F
	WLW	N,w4fall6,F
	WLW	N,w4fall7,F
	WLW	N,w4fall8,F
	WLW	N,w4fall9,F
	WLW	N,w4fall10,F
	WL	-1,seq_stayinair
	WLW	N,w4fall11,F
	WLL	-1,seq_snd,land_snd
	WLW	N,w4fall12,F
	WLW	10,w4fall13,F
	WLW	N,w4fall14,F
	WLW	N,w4fall15,F
	WLW	N,w4fall16,F
	WLW	N,w4fall17,F
	WLW	N,w4fall18,F
	WLW	N,w4fall19,F
	WLW	N,w4fall20,F
	WLW	N,w4fall21,F
	WLW	N,w4fall22,F
	W0

#5
	WLWWW	-1,seq_offset2,0,-42,0
	WLW	N,w5fall1,F
	WLL	-1,seq_snd,fall1_snd
	WLW	N,w5fall2,F
	WLW	N,w5fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w5fall4,F
	WLW	N,w5fall5,F
	WLW	N,w5fall6,F
	WLW	N,w5fall7,F
	WLW	N,w5fall8,F
	WLW	N,w5fall9,F
	WLW	N,w5fall10,F
	WL	-1,seq_stayinair
	WLW	N,w5fall11,F
	WLL	-1,seq_snd,land_snd
	WLW	N,w5fall12,F
	WLW	N,w5fall13,F
	WLW	10,w5fall14,F
	WLW	N,w5fall15,F
	WLW	N,w5fall16,F
	WLW	N,w5fall17,F
	WLW	N,w5fall18,F
	WLW	N,w5fall19,F
	WLW	N,w5fall20,F
	WLW	N,w5fall21,F
	WLW	N,w5fall22,F
	W0

	
#*
flyback_t
	.word	NOMV_M|NOBALL_M|NOJUMP_M|NOJOY_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
flybackwb_t
	.word	NOMV_M|NOJUMP_M|NOJOY_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	2,N
#1
	WLWWW	-1,seq_offset2,0,-32,0
	WLW	N,w1fall1,F
	WLL	-1,seq_snd,fall1_snd
;	WLL	-1,seq_snd,boo_snd
	WLW	N,w1fall2,F
	WLW	N,w1fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w1fall4,F
	WLW	N,w1fall5,F
	WLW	N,w1fall6,F
	WLW	N,w1fall7,F
	WLW	N,w1fall8,F
	WLW	N,w1fall9,F
	WL	-1,seq_stayinair
	WL	-1,seq_injury
	WLW	N,w1fall10,F
	WLL	-1,seq_snd,land_snd
	WLW	N,w1fall11,F
	WLW	N,w1fall12,F
	WLW	N,w1fall13,F
	WLW	10,w1fall14,F
	WL	-1,seq_noballoff
	WLW	N,w1fall15,F
	WLW	N,w1fall16,F
	WLW	N,w1fall17,F
	WLW	N,w1fall18,F
	WLW	N,w1fall19,F
	WLW	N,w1fall20,F
	WLW	N,w1fall21,F
	WLW	N,w1fall22,F
	WLW	N,w1fall23,F
	W0

#2
	WLWWW	-1,seq_offset2,0,-30,0
	WLW	N,w2fall1,F
	WLL	-1,seq_snd,fall1_snd
;	WLL	-1,seq_snd,boo_snd
	WLW	N,w2fall2,F
	WLW	N,w2fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w2fall4,F
	WLW	N,w2fall5,F
	WLW	N,w2fall6,F
	WLW	N,w2fall7,F
	WLW	N,w2fall8,F
	WL	-1,seq_stayinair
	WLW	N,w2fall9,F
	WLL	-1,seq_snd,land_snd
	WL	-1,seq_injury
	WLW	N,w2fall10,F
	WLW	10,w2fall11,F
	WL	-1,seq_noballoff
	WLW	N,w2fall12,F
	WLW	N,w2fall13,F
	WLW	N,w2fall14,F
	WLW	N,w2fall15,F
	WLW	N,w2fall16,F
	WLW	N,w2fall17,F
	WLW	N,w2fall18,F
	WLW	N,w2fall19,F
	WLW	N,w2fall20,F
	WLW	N,w2fall21,F
	W0
#3
	WLWWW	-1,seq_offset2,0,-37,0
	WLW	N,w3fall1,F
	WLL	-1,seq_snd,fall1_snd
;	WLL	-1,seq_snd,boo_snd
	WLW	N,w3fall2,F
	WLW	N,w3fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w3fall4,F
	WLW	N,w3fall5,F
	WLW	N,w3fall6,F
	WLW	N,w3fall7,F
	WLW	N,w3fall8,F
	WLW	N,w3fall9,F
	WLW	N,w3fall10,F
	WLW	N,w3fall11,F
	WLW	N,w3fall12,F
	WL	-1,seq_stayinair
	WLW	N,w3fall13,F
	WL	-1,seq_injury
	WLL	-1,seq_snd,land_snd
	WLW	10,w3fall14,F
	WL	-1,seq_noballoff
	WLW	N,w3fall15,F
	WLW	N,w3fall16,F
	WLW	N,w3fall17,F
	WLW	N,w3fall18,F
	WLW	N,w3fall19,F
	WLW	N,w3fall20,F
	WLW	N,w3fall21,F
	WLW	N,w3fall22,F
	WLW	N,w3fall23,F
	WLW	N,w3fall24,F
	W0
#4
	WLWWW	-1,seq_offset2,0,-37,0
	WLW	N,w4fall1,F
	WLL	-1,seq_snd,fall1_snd
;	WLL	-1,seq_snd,boo_snd
	WLW	N,w4fall2,F
	WLW	N,w4fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w4fall4,F
	WLW	N,w4fall5,F
	WLW	N,w4fall6,F
	WLW	N,w4fall7,F
	WLW	N,w4fall8,F
	WLW	N,w4fall9,F
	WLW	N,w4fall10,F
	WL	-1,seq_stayinair
	WL	-1,seq_injury
	WLW	N,w4fall11,F
	WLL	-1,seq_snd,land_snd
	WLW	N,w4fall12,F
	WLW	10,w4fall13,F
	WL	-1,seq_noballoff
	WLW	N,w4fall14,F
	WLW	N,w4fall15,F
	WLW	N,w4fall16,F
	WLW	N,w4fall17,F
	WLW	N,w4fall18,F
	WLW	N,w4fall19,F
	WLW	N,w4fall20,F
	WLW	N,w4fall21,F
	WLW	N,w4fall22,F
	W0

#5
	WLWWW	-1,seq_offset2,0,-42,0
	WLW	N,w5fall1,F
	WLL	-1,seq_snd,fall1_snd
;	WLL	-1,seq_snd,boo_snd
	WLW	N,w5fall2,F
	WLW	N,w5fall3,F
	WL	-1,seq_clr_flag
	WLW	N,w5fall4,F
	WLW	N,w5fall5,F
	WLW	N,w5fall6,F
	WLW	N,w5fall7,F
	WLW	N,w5fall8,F
	WLW	N,w5fall10,F
	WL	-1,seq_stayinair
	WL	-1,seq_injury
	WLW	N,w5fall11,F
	WLL	-1,seq_snd,land_snd
	WLW	N,w5fall12,F
	WLW	N,w5fall13,F
	WLW	10,w5fall14,F
	WL	-1,seq_noballoff
	WLW	N,w5fall15,F
	WLW	N,w5fall16,F
	WLW	N,w5fall17,F
	WLW	N,w5fall18,F
	WLW	N,w5fall19,F
	WLW	N,w5fall20,F
	WLW	N,w5fall21,F
	WLW	N,w5fall22,F
	W0

#*
flyback2_t	;(push, no fall)
	.word	NOMV_M|NOJOY_M|NOBALL_M|NOJUMP_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
flybackwb2_t
	.word	NOMV_M|NOJOY_M|NOJUMP_M|NOSTEAL_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	3,N
#1
	WLW	N,w1flai1,F
;	WLL	-1,seq_snd,boo_snd
	WLL	-1,seq_snd,flail_snd
	WLW	N,w1flai2,F
	WLW	N,w1flai3,F
	WLW	N,w1flai4,F
	WLW	N,w1flai5,F
	WLW	N,w1flai6,F
	WLW	N,w1flai7,F
	WLW	N,w1flai8,F
	W0

#2
	WLW	N,w2flai1,F
;	WLL	-1,seq_snd,boo_snd
	WLL	-1,seq_snd,flail_snd
	WLW	N,w2flai2,F
	WLW	N,w2flai3,F
	WLW	N,w2flai4,F
	WLW	N,w2flai5,F
	WLW	N,w2flai6,F
	WLW	N,w2flai7,F
	WLW	N,w2flai8,F
	WLW	N,w2flai9,F
	WLW	N,w2flai11,F
	W0
#3
	WLW	N,w3flai1,F
;	WLL	-1,seq_snd,boo_snd
	WLL	-1,seq_snd,flail_snd
	WLW	N,w3flai2,F
	WLW	N,w3flai3,F
	WLW	N,w3flai4,F
	WLW	N,w3flai5,F
	WLW	N,w3flai6,F
	WLW	N,w3flai7,F
	WLW	N,w3flai8,F
	WLW	N,w3flai9,F
	WLW	N,w3flai1,F
	W0
#4
	WLW	N,w4flai1,F
;	WLL	-1,seq_snd,boo_snd
	WLL	-1,seq_snd,flail_snd
	WLW	N,w4flai2,F
	WLW	N,w4flai3,F
	WLW	N,w4flai4,F
	WLW	N,w4flai5,F
	WLW	N,w4flai6,F
	WLW	N,w4flai7,F
	WLW	N,w4flai8,F
	W0

#5
	WLW	N,w5flai2,F
;	WLL	-1,seq_snd,boo_snd
	WLL	-1,seq_snd,flail_snd
	WLW	N,w5flai3,F
	WLW	N,w5flai4,F
	WLW	N,w5flai5,F
	WLW	N,w5flai6,F
	WLW	N,w5flai7,F
	WLW	N,w5flai8,F
	WLW	N,w5flai10,F
	WLW	N,w5flai11,F
	W0


#*
pickup_t
	.word	NOMV_M|NOSTEAL_M|NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	2,N
#1
	WLW	N,w1pikup1,F|M_YF
	WLW	N,w1pikup2,F|M_YF
	WLW	N,w1pikup3,F
	WLW	N,w1pikup4,F
	WLW	N,w1pikup5,F
	WLW	N,w1pikup4,F
	WLW	N,w1pikup3,F
	WLW	N,w1pikup2,F
	WLW	N,w1pikup1,F
	W0
#2
	WLW	N,w2pikup1,F|M_YF
	WLW	N,w2pikup2,F|M_YF
	WLW	N,w2pikup3,F
	WLW	N,w2pikup4,F
	WLW	N,w2pikup5,F
	WLW	N,w2pikup4,F
	WLW	N,w2pikup3,F
	WLW	N,w2pikup2,F
	WLW	N,w2pikup1,F
	W0
#3
	WLW	N,w3pikup1,F|M_YF
	WLW	N,w3pikup2,F|M_YF
	WLW	N,w3pikup3,F
	WLW	N,w3pikup4,F
	WLW	N,w3pikup5,F
	WLW	N,w3pikup4,F
	WLW	N,w3pikup3,F
	WLW	N,w3pikup2,F
	WLW	N,w3pikup1,F
	W0
#4
	WLW	N,w4pikup1,F|M_YF
	WLW	N,w4pikup2,F|M_YF
	WLW	N,w4pikup3,F
	WLW	N,w4pikup4,F
	WLW	N,w4pikup5,F
	WLW	N,w4pikup4,F
	WLW	N,w4pikup3,F
	WLW	N,w4pikup2,F
	WLW	N,w4pikup1,F
	W0
#5
	WLW	N,w5pikup1,F|M_YF
	WLW	N,w5pikup2,F|M_YF
	WLW	N,w5pikup3,F
	WLW	N,w5pikup4,F
	WLW	N,w5pikup5,F
	WLW	N,w5pikup4,F
	WLW	N,w5pikup3,F
	WLW	N,w5pikup2,F
	WLW	N,w5pikup1,F
	W0


#*
elbo_t
	.word	NOMV_M|NOSTEAL_M|NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	5,N

#1
#2
	WLW	N-1,w1elbo5,F
	WLL	-1,seq_snd,elbow1_snd
	WL	-1,seq_elbo
	WLW	N-1,w1elbo4,F
	WLW	N-2,w1elbo3,F
	WLW	N-1,w1elbo1,F
	WLW	N-1,w1elbo3,F
	WLW	N-2,w1elbo4,F
	WLW	N-2,w1elbo5,F
	WLL	-1,seq_snd,elbow2_snd
	WLW	N-2,w1elbo6,F
	WLW	N-2,w1elbo7,F
	WLW	N-1,w1elbo8,F
	WLW	N-1,w1elbo7,F
	WLW	N-2,w1elbo6,F
	WLW	N-2,w1elbo5,F
	W0
#3
#4
#5
	WLW	N-1,w4elbo5,F
	WLL	-1,seq_snd,elbow1_snd
	WL	-1,seq_elbo
	WLW	N-1,w4elbo6,F
	WLW	N-2,w4elbo7,F
	WLW	N-1,w4elbo8,F
	WLW	N-1,w4elbo7,F
	WLW	N-2,w4elbo6,F
	WLW	N-1,w4elbo5,F
	WLL	-1,seq_snd,elbow2_snd
	WLW	N-2,w4elbo4,F
	WLW	N-1,w4elbo3,F
	WLW	N-1,w4elbo4,F
	WLW	N-2,w4elbo5,F
	W0


#*
;Slower elbo swing
elbo2_t
	.word	NOMV_M|NOJOY_M|NOSTEAL_M|NOJUMP_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	4,N
#1
#2
	WLW	N-1,w1elbo5,F
	WLL	-1,seq_snd,elbow1_snd
	WL	-1,seq_elbo
	WLW	N-1,w1elbo4,F
	WLW	N-2,w1elbo3,F
	WLW	N+4,w1elbo1,F
	WLW	N-1,w1elbo3,F
	WLW	N-2,w1elbo4,F
	WLW	N-2,w1elbo5,F
	WLL	-1,seq_snd,elbow2_snd
	WLW	N-2,w1elbo6,F
	WLW	N-2,w1elbo7,F
	WLW	N+6,w1elbo8,F
	WLW	N-1,w1elbo7,F
	WLW	N-2,w1elbo6,F
	WLW	N-2,w1elbo5,F
	W0
#3
#4
#5
	WLW	N-1,w4elbo5,F
	WLL	-1,seq_snd,elbow1_snd
	WL	-1,seq_elbo
	WLW	N-1,w4elbo6,F
	WLW	N-2,w4elbo7,F
	WLW	N+4,w4elbo8,F
	WLW	N-1,w4elbo7,F
	WLW	N-2,w4elbo6,F
	WLW	N-1,w4elbo5,F
	WLL	-1,seq_snd,elbow2_snd
	WLW	N-2,w4elbo4,F
	WLW	N+6,w4elbo3,F
	WLW	N-1,w4elbo4,F
	WLW	N-2,w4elbo5,F
	W0


	.ref	plyr_setseq
#*
spinmove_t
	.word	NOJOY_M|NOSTEAL_M|NOJUMP_M|NOCOLLP_M
	.long	#chnge_seq
	.long	#1,#2,#3,#4,#5,#6,#7,#8

#chnge_seq
	clr	a14
	move	a14,*a13(plyr_dribmode)

	movi	RUNDRIB_SEQ,a0
	calla	plyr_setseq
	rets

#1
	WL	-1,#speech_call
	WLW	2,W3SPMVA5,F
	WL	-1,#set_xzvels_d1
	WLW	2,W3SPMVA6,F
	WL	-1,#set_xzvels_d1
	WLW	2,W3SPMVA7,F
	WLW	2,W3SPMVA8,F
	WL	-1,#set_xzvels_d1
	WLW	2,W3SPMVA9,F
	WLW	2,W3SPMVA10,F
	WL	-1,#set_xzvels_d1
	WL	-1,#lose_ball
	WLW	2,W3SPMVA11,F
	WLW	2,W3SPMVA12,F
	WL	-1,#set_xzvels_d1
	WLW	2,W3SPMVA13,F
	WLW	2,W3SPMVA14,F
	WL	-1,#set_xzvels_d1a
	WLW	2,W3SPMVA15,F
	WLW	2,W3SPMVA16,F
	WL	-1,#set_xzvels_d1a
	WLW	2,W3SPMVA17,F
	WLW	2,W3SPMVA18,F
	WL	-1,#set_xzvels_d1a
	WLW	2,W3SPMVA19,F
	WLW	2,W3SPMVA20,F
	WL	-1,#set_xzvels_d1a
	WLW	2,W3SPMVA1,F
	WLW	2,W3SPMVA2,F
	WL	-1,#set_xzvels_d1a
	WLW	2,W3SPMVA3,F
	WLW	2,W3SPMVA4,F
	W0

#lose_ball

	.ref	plyr_onfire
	.ref	PCNT
	BSSX	last_spin,16

	movk	5,a0

;	move	*a13(plyr_num),a14
;	move	@plyr_onfire,a1
;	btst	a14,a1
;	jrz	#no
;
;;If guy is on fire, don't allow consecutive spins without
;;a great chance of losing the ball!
;	move	@last_spin,a1
;	move	@PCNT,a14
;	move	a14,@last_spin
;	sub	a1,a14
;	abs	a14
;	cmpi	4*60,a14
;	jrgt	#no
;	movi	300,a0
;#no
	.ref	RNDPER
	calla	RNDPER
	jrls	#ex

	move	*a13(plyr_ptsdown),a1	;Is plyr losing?
	jrgt	#ex			; br=yes
	addk	4,a1
	jrnn	#ex


	PUSH	a8
	movk	15,a0
	move	a0,*a13(plyr_shtdly)
	clr	a0
	move	a0,*a13(plyr_ownball)
	.ref	ballobj_p
	move	@ballobj_p,a8,L
	.ref	loose_ball
	calla	loose_ball

	.ref	steal_snd
	SOUND1	steal_snd

	movi	>10000,a2		;>Give rnd velocity
	movi	>8000,a3
	move	a2,a0
	callr	rnd
	add	a3,a0
	btst	0,a0
	jrz	#xpos
	neg	a0
#xpos	move	a0,*a8(OXVEL),L
	move	a2,a0
	callr	rnd
	add	a3,a0
	btst	0,a0
	jrz	#ypos
	neg	a0
#ypos	move	a0,*a8(OZVEL),L




	PULL	a8
#ex
	rets

********************************
* Get random # with mask
* A0=Mask
* >A0=Rnd # (Pass CC)
* Trashes scratch

 SUBRP	rnd

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	and	a1,a0
	rets

#2
	WL	-1,#speech_call
	WLW	2,W3SPMVA1,F
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA2,F
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA3,F
	WLW	2,W3SPMVA4,F
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA5,F
	WLW	1,W3SPMVA6,F
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA7,F
	WLW	1,W3SPMVA8,F
	WL	-1,#lose_ball
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA9,F
	WLW	2,W3SPMVA10,F
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA11,F
	WLW	1,W3SPMVA12,F
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA13,F
	WLW	1,W3SPMVA14,F
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA15,F
	WLW	1,W3SPMVA16,F
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA17,F
	WLW	2,W3SPMVA18,F
	WL	-1,#set_xzvels_d2
	WLW	2,W3SPMVA19,F
	WLW	2,W3SPMVA20,F
;	WL	-1,#reset_dribble
	W0

#3
	WL	-1,#speech_call
	WLW	2,W3SPMVA1,F
	WL	-1,#set_xzvels_d3
	WLW	2,W3SPMVA2,F
	WL	-1,#set_xzvels_d3
	WLW	2,W3SPMVA3,F
	WLW	2,W3SPMVA4,F
	WL	-1,#set_xzvels_d3
	WLW	2,W3SPMVA5,F
	WLW	1,W3SPMVA6,F
	WL	-1,#set_xzvels_d3
	WLW	2,W3SPMVA7,F
	WLW	1,W3SPMVA8,F
	WL	-1,#lose_ball
	WL	-1,#set_xzvels_d3
	WLW	2,W3SPMVA9,F
	WLW	2,W3SPMVA10,F
	WL	-1,#set_xzvels_d3a
	WLW	2,W3SPMVA11,F
	WLW	1,W3SPMVA12,F
	WL	-1,#set_xzvels_d3a
	WLW	2,W3SPMVA13,F
	WLW	1,W3SPMVA14,F
	WL	-1,#set_xzvels_d3a
	WLW	2,W3SPMVA15,F
	WLW	1,W3SPMVA16,F
	WL	-1,#set_xzvels_d3a
	WLW	2,W3SPMVA17,F
	WLW	2,W3SPMVA18,F
	WL	-1,#set_xzvels_d3a
	WLW	2,W3SPMVA19,F
	WLW	2,W3SPMVA20,F
;	WL	-1,#reset_dribble
	W0

#4
	WL	-1,#speech_call
	WLW	2,W3SPMVA1,F
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA2,F
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA3,F
	WLW	2,W3SPMVA4,F
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA5,F
	WLW	1,W3SPMVA6,F
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA7,F
	WLW	1,W3SPMVA8,F
	WL	-1,#lose_ball
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA9,F
	WLW	2,W3SPMVA10,F
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA11,F
	WLW	1,W3SPMVA12,F
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA13,F
	WLW	1,W3SPMVA14,F
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA15,F
	WLW	1,W3SPMVA16,F
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA17,F
	WLW	2,W3SPMVA18,F
	WL	-1,#set_xzvels_d4
	WLW	2,W3SPMVA19,F
	WLW	2,W3SPMVA20,F
;	WL	-1,#reset_dribble
	W0
#5
	
	WL	-1,#speech_call
	WL	-1,#set_xzvels_d5
	WLW	2,W3SPMVA15,FF
	WLW	2,W3SPMVA14,FF
	WL	-1,#set_xzvels_d5
	WLW	2,W3SPMVA13,FF
	WLW	2,W3SPMVA12,FF
	WL	-1,#set_xzvels_d5
	WLW	2,W3SPMVA11,FF
	WLW	2,W3SPMVA10,FF
	WL	-1,#set_xzvels_d5
	WLW	2,W3SPMVA9,FF
	WLW	2,W3SPMVA8,FF
	WL	-1,#lose_ball
	WL	-1,#set_xzvels_d5
	WLW	2,W3SPMVA7,FF
	WLW	2,W3SPMVA6,FF
	WL	-1,#set_xzvels_d5a
	WLW	2,W3SPMVA5,FF
	WLW	2,W3SPMVA4,FF
	WL	-1,#set_xzvels_d5a
	WLW	2,W3SPMVA3,FF
	WLW	2,W3SPMVA2,FF
	WL	-1,#set_xzvels_d5a
	WLW	2,W3SPMVA1,FF
	WLW	2,W3SPMVA20,FF
	WL	-1,#set_xzvels_d5a
	WLW	2,W3SPMVA19,FF
	WLW	2,W3SPMVA18,FF
	WL	-1,#set_xzvels_d5a
	WLW	2,W3SPMVA17,FF
	WLW	2,W3SPMVA16,FF
;	WL	-1,#reset_dribble
	W0

#6
	WL	-1,#speech_call
	WLW	2,W3SPMVA1,F
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA2,F
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA3,F
	WLW	2,W3SPMVA4,F
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA5,F
	WLW	1,W3SPMVA6,F
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA7,F
	WLW	1,W3SPMVA8,F
	WL	-1,#lose_ball
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA9,F
	WLW	2,W3SPMVA10,F
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA11,F
	WLW	1,W3SPMVA12,F
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA13,F
	WLW	1,W3SPMVA14,F
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA15,F
	WLW	1,W3SPMVA16,F
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA17,F
	WLW	2,W3SPMVA18,F
	WL	-1,#set_xzvels_d6
	WLW	2,W3SPMVA19,F
	WLW	2,W3SPMVA20,F
;	WL	-1,#reset_dribble
	W0

#7
	WL	-1,#speech_call
	WLW	2,W3SPMVA1,F
	WL	-1,#set_xzvels_d7
	WLW	2,W3SPMVA2,F
	WL	-1,#set_xzvels_d7
	WLW	2,W3SPMVA3,F
	WLW	2,W3SPMVA4,F
	WL	-1,#set_xzvels_d7
	WLW	2,W3SPMVA5,F
	WLW	1,W3SPMVA6,F
	WL	-1,#set_xzvels_d7
	WLW	2,W3SPMVA7,F
	WLW	1,W3SPMVA8,F
	WL	-1,#lose_ball
	WL	-1,#set_xzvels_d7
	WLW	2,W3SPMVA9,F
	WLW	2,W3SPMVA10,F
	WL	-1,#set_xzvels_d7a
	WLW	2,W3SPMVA11,F
	WLW	1,W3SPMVA12,F
	WL	-1,#set_xzvels_d7a
	WLW	2,W3SPMVA13,F
	WLW	1,W3SPMVA14,F
	WL	-1,#set_xzvels_d7a
	WLW	2,W3SPMVA15,F
	WLW	1,W3SPMVA16,F
	WL	-1,#set_xzvels_d7a
	WLW	2,W3SPMVA17,F
	WLW	2,W3SPMVA18,F
	WL	-1,#set_xzvels_d7a
	WLW	2,W3SPMVA19,F
	WLW	2,W3SPMVA20,F
;	WL	-1,#reset_dribble
	W0

#8
	WL	-1,#speech_call
	WLW	2,W3SPMVA1,F
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA2,F
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA3,F
	WLW	2,W3SPMVA4,F
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA5,F
	WLW	1,W3SPMVA6,F
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA7,F
	WLW	1,W3SPMVA8,F
	WL	-1,#lose_ball
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA9,F
	WLW	2,W3SPMVA10,F
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA11,F
	WLW	1,W3SPMVA12,F
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA13,F
	WLW	1,W3SPMVA14,F
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA15,F
	WLW	1,W3SPMVA16,F
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA17,F
	WLW	2,W3SPMVA18,F
	WL	-1,#set_xzvels_d8
	WLW	2,W3SPMVA19,F
	WLW	2,W3SPMVA20,F
;	WL	-1,#reset_dribble
	W0

	.ref	spin_mv1_sp,spin_mv2_sp,spin_mv3_sp
	.ref	spins_out_sp

#speech_call
	.ref	spn_mv_snd
	SOUND1	spn_mv_snd

	movi	spins_out_sp,a0
	move	@HCOUNT,a14
	btst	3,a14
	jrnz	#x
	btst	0,a14
	jrnz	#x1

	movi	spin_mv1_sp,a0
	move	*a13(plyr_ohpdist),a1
	cmpi	>174*DIST_ADDITION,a1
	jrgt	#x
	movi	spin_mv3_sp,a0
	move	@HCOUNT,a14
	btst	0,a14
	jrnz	#x
	movi	spin_mv2_sp,a0
#x	calla	snd_play1
#x1	rets

#set_xzvels_d1
	callr	check_x_bounds
	jrnc	#sd1
	movi	024000h,a14
	move	*a8(OXPOS),a0
	cmpi	WRLDMID,a0
	jrlt	#sd11
	movi	-024000h,a14
#sd11	move	a14,*a8(OXVEL),L

#sd1	callr	check_z_bounds
	jrnc	#sd1a
	movi	-050000h,a14
	move	a14,*a8(OZVEL),L
#sd1a	rets


#set_xzvels_d1a
	callr	check_x_bounds
	jrnc	#sd1b
	movi	-024000h,a14
	move	*a8(OXPOS),a0
	cmpi	WRLDMID,a0
	jrlt	#sb12
	movi	024000h,a14
#sb12	move	a14,*a8(OXVEL),L

#sd1b	callr	check_z_bounds
	jrnc	#sd1c
	movi	-050000h,a14
	move	a14,*a8(OZVEL),L
#sd1c	rets


#set_xzvels_d2
	callr	check_x_bounds
	jrnc	#sd2a
	movi	040d00h,a14
	move	a14,*a8(OXVEL),L

#sd2a	callr	check_z_bounds
	jrnc	#sd2b
	movi	-043300h,a14
	move	a14,*a8(OZVEL),L
#sd2b	rets


#set_xzvels_d3
	callr	check_x_bounds
	jrnc	#sd3a
	movi	052000h,a14
	move	a14,*a8(OXVEL),L

#sd3a	callr	check_z_bounds
	jrnc	#sd3b
	movi	022000h,a14
	move	a14,*a8(OZVEL),L
#sd3b	rets


#set_xzvels_d3a
	callr	check_x_bounds
	jrnc	#sd3c
	movi	052000h,a14
	move	a14,*a8(OXVEL),L

#sd3c	callr	check_z_bounds
	jrnc	#sd3d
	movi	-022000h,a14
	move	a14,*a8(OZVEL),L
#sd3d	rets


#set_xzvels_d4
	callr	check_x_bounds
	jrnc	#sd4a
	movi	040d00h,a14
	move	a14,*a8(OXVEL),L

#sd4a	callr	check_z_bounds
	jrnc	#sd4b
	movi	043300h,a14
	move	a14,*a8(OZVEL),L
#sd4b	rets


#set_xzvels_d5
	callr	check_x_bounds
	jrnc	#sd5a
	movi	024000h,a14
	move	*a8(OXPOS),a0
	cmpi	WRLDMID,a0
	jrlt	#sd51
	movi	-024000h,a14
#sd51	move	a14,*a8(OXVEL),L

#sd5a	callr	check_z_bounds
	jrnc	#sd5b
	movi	050000h,a14
	move	a14,*a8(OZVEL),L
#sd5b	rets


#set_xzvels_d5a
	callr	check_x_bounds
	jrnc	#sd5c
	movi	-024000h,a14
	move	*a8(OXPOS),a0
	cmpi	WRLDMID,a0
	jrlt	#sb52
	movi	024000h,a14
#sb52	move	a14,*a8(OXVEL),L

#sd5c	callr	check_z_bounds
	jrnc	#sd5d
	movi	050000h,a14
	move	a14,*a8(OZVEL),L
#sd5d	rets


#set_xzvels_d6
	callr	check_x_bounds
	jrnc	#sd6a
	movi	-040d00h,a14
	move	a14,*a8(OXVEL),L

#sd6a	callr	check_z_bounds
	jrnc	#sd6b
	movi	043300h,a14
	move	a14,*a8(OZVEL),L
#sd6b	rets


#set_xzvels_d7
	callr	check_x_bounds
	jrnc	#sd7a
	movi	-052000h,a14
	move	a14,*a8(OXVEL),L

#sd7a	callr	check_z_bounds
	jrnc	#sd7b
	movi	022000h,a14
	move	a14,*a8(OZVEL),L
#sd7b	rets


#set_xzvels_d7a
	callr	check_x_bounds
	jrnc	#sd7c
	movi	-052000h,a14
	move	a14,*a8(OXVEL),L

#sd7c	callr	check_z_bounds
	jrnc	#sd7d
	movi	-022000h,a14
	move	a14,*a8(OZVEL),L
#sd7d	rets


#set_xzvels_d8
	callr	check_x_bounds
	jrnc	#sd8a
	movi	-040d00h,a14
	move	a14,*a8(OXVEL),L

#sd8a	callr	check_z_bounds
	jrnc	#sd8b
	movi	-043300h,a14
	move	a14,*a8(OZVEL),L
#sd8b	rets


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBRP	check_x_bounds

	move	*a8(OXPOS),a0
	move	*a8(OXANI+16),a14
	add	a14,a0
	cmpi	PLYRMINX,a0		;Is X ok? Yes if >
	jrle	#stp			;br=dont allowed furter movement
	cmpi	PLYRMAXX,a0		;Is X ok? Yes if <
	jrge	#stp			;br=dont allowed furter movement
	setc	
	rets
#stp
	clrc	
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBRP	check_z_bounds

	move	*a8(OZPOS),a0
	cmpi	CZMIN+8,a0
	jrle	#czb
	cmpi	CZMAX-6,a0
	jrge	#czb
	setc	
	rets
#czb
	clrc	
	rets


	.end



