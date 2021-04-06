**************************************************************
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


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"game.equ"
	.include	"shawn.hdr"
	.asg		0,SEQT
	.include	"plyr.equ"
	.include	"plyrseq2.tbl"
	.include	"pass.tbl"
	.include	"fireseq.tbl"
	.include	"imgpal3.asm"



;sounds external

push1_snd	.word	>fd85,15,>8160,0	;Push ugh
push2_snd	.word	>fd85,15,>816c,0	;Push ugh
push3_snd	.word	>fd85,15,>816a,0	;Push ugh

**fall3_snd	.word	>fd86,20,>8170,0	;Fall ugh

land_snd	.word	>fd89,40,>811d,0	;Body land on grnd
boo_snd		.word	>f894,180,>8150,0	;Boo



;not prime
;oof_snd		.word	>f985,40,>815b,0	;Oof push
;ungh_snd	.word	>f985,40,>815c,0	;Ungh push

oof_snd		
ungh_snd	.word	>fd85,15,>816c,0	;Push ugh

fall1_snd	.word	>fd88,20,>8164,0	;Fall ugh
fall2_snd	.word	>fd88,20,>8166,0	;Fall ugh

;fall1_snd	.word	>fd85,15,>8160,0	;Push ugh
;fall2_snd	.word	>fd85,15,>816c,0	;Push ugh


;symbols externally defined

	.ref	seq_injury
	.ref	seq_smoke
 	.ref	seq_stuffzx
	.ref	seq_keepzx
	.ref	seq_stayinair
	.ref	seq_elbo,seq_snd,seq_stand,plyr_pass

	.ref	plyr_shoot
	.ref	seq_newdir
	.ref	seq_noballoff
	.ref	seq_stopfire
	.ref	seq_strtfire

;symbols defined in this file

	.def	FIREFALP
	.def	zwilpal

;uninitialized ram definitions



;equates for this file

M_YF	.equ	>8000	;Y free (OFLAGS)


	.text

*******************************************


	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF



;SL
tip_t
	.word	NOJOY_M|NOCOLLP_M|NOBALL_M|NOJUMP_M
	.long	0
	.long	#3,#3,#3,#3,#3,#3,#3,#3

	.asg	12,N

#3	WLW	N,w3tip1,F
	WLW	N,w3tip2,F
	W0

#*
tipj_t
	.word	NOJOY_M|NOCOLLP_M|NOBALL_M|NOJUMP_M
	.long	seq_stand
	.long	#3,#3,#3,#3,#3,#3,#3,#3


#3	WLW	6,w3tip3,F
	WLW	25,w3tip4,F
	WLW	5,w3tip5,F
	WLW	50,w3tip6,F
	WLW	4,w3tip7,F
	W0



#*
passnl_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2

	.asg	3,N

;If passer is facing 0,1,2 and teamate is located in the angle 3
;then we can use the W2NLPR pass.
;
; OR
;
;If passer is facing 6,7 and teamate is located in the angle 5
;then we can use the W2NLPR pass.
;
#1
#2
#3
	WLW	N,W2NLPR1,F
	WLW	N,W2NLPR2,F
	WLW	1,W2NLPR3,F
	WL	-1,plyr_pass
	WLW	6,W2NLPR3,F
	WLW	N,W2NLPR2,F
	WLW	9,W2NLPR1,F
	W0

#4
#5
	WLW	N,W4NLPR1,F
	WLW	N,W4NLPR2,F
	WLW	1,W4NLPR3,F
	WL	-1,plyr_pass
	WLW	6,W4NLPR3,F
	WLW	N,W4NLPR2,F
	WLW	9,W4NLPR1,F
	W0

#*
passnl3_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2

	.asg	3,N

;If passer is facing 0,1,2 and teamate is located in the angle 3
;then we can use the W2NLPR pass.
;
; OR
;
;If passer is facing 6,7 and teamate is located in the angle 5
;then we can use the W2NLPR pass.
;
#1
#3
#2
#4
#5
	WLW	N,W4NLPR1,F
	WLW	N,W4NLPR2,F
	WLW	1,W4NLPR3,F
	WL	-1,plyr_pass
	WLW	6,W4NLPR3,F
	WLW	N,W4NLPR2,F
	WLW	9,W4NLPR1,F
	W0

;If passer is facing 0,1,2 and teamate is located in the angle 7
;then we can use the W2NLPL pass.
;
; OR
;
;If passer is facing 6,7 and teamate is located in the angle 1
;then we can use the W2NLPL pass.
#*

passnl2_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2

	.asg	3,N

#1
#2
#3
	WLW	N,W2NLPL1,F
	WLW	N,W2NLPL2,F
	WLW	1,W2NLPL3,F
	WL	-1,plyr_pass
	WLW	6,W2NLPL3,F
	WLW	N,W2NLPL2,F
	WLW	9,W2NLPL1,F
	W0
#4
#5
	WLW	N,W4NLPL1,F
	WLW	N,W4NLPL2,F
	WLW	1,W4NLPL3,F
	WL	-1,plyr_pass
	WLW	6,W4NLPL3,F
	WLW	N,W4NLPL2,F
	WLW	9,W4NLPL1,F
	W0



stagger_t
	.word	NOMV_M|NOBALL_M|NOJUMP_M|NOJOY_M|SAMEDIR_M
	.long	seq_stand
	.long	#stag2_l,#stag2_l,#stag3_l,#stag4_l
	.long	#stag4_l,#stag4_l,#stag3_l,#stag2_l
	.asg	5,N
#stag2_l
	WLW	N,w2fall1,F
	WLL	-1,seq_snd,push1_snd
	WLW	N,w2fall2,F
	WLW	N,w2fall3,F
	WLW	N,w2fall4,F
	WLW	N,w2fall5,F
	WLW	N,w2fall4,F
	WLW	N,w2fall3,F
	WLW	N,w2fall2,F
	WLW	N,w2fall1,F
	W0
#stag3_l
	WLW	N,w3fall1,F
	WLL	-1,seq_snd,push2_snd
	WLW	N,w3fall2,F
	WLW	N,w3fall3,F
	WLW	N,w3fall4,F
	WLW	N,w3fall5,F
	WLW	N,w3fall6,F
	WLW	N,w3fall7,F
	WLW	N,w3fall8,F
	W0
#stag4_l
	WLW	N,w4fall1,F
	WLL	-1,seq_snd,push3_snd
	WLW	N,w4fall2,F
	WLW	N,w4fall1,F
	W0
#*
fall_t
	.word	NOMV_M|NOBALL_M|NOJUMP_M|NOJOY_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
	.asg	5,N
	.asg	4,N2	;6
#2
	WLW	N,w2fall1,F
	WLL	-1,seq_snd,fall1_snd
	WLW	N,w2fall2,F
	WLW	N,w2fall3,F
	WLW	N,w2fall4,F
	WLW	N,w2fall5,F
	WLW	N,w2fall6,F
	WLW	N,w2fall7,F
	WLW	N,w2fall8,F

	WL	-1,seq_stayinair

	WLW	N,w2fall9,F
	WLL	-1,seq_snd,land_snd
	WLW	N2,w2fall10,F
	WLW	N2,w2fall11,F
	WLW	N2,w2fall12,F
	WLW	N2,w2fall13,F
	WLW	N2,w2fall14,F
	WLW	N2,w2fall15,F
	WLW	N2,w2fall16,F
	W0
#3
	WLW	N,w3fall1,F
	WLL	-1,seq_snd,fall2_snd
	WLW	N,w3fall2,F
	WLW	N,w3fall3,F
	WLW	N,w4fall1,F
	WLW	N,w4fall2,F
	WLW	N,w4fall3,F
	WLW	N,w4fall4,F
	WLW	N,w4fall5,F
	WLW	N,w4fall6,F
	WLW	N,w4fall7,F
	WLW	N,w4fall8,F
	WLW	N,w4fall9,F
	WLW	N,w4fall10,F
;	WLW	1,w4fall10a,F
;	WLW	1,w4fall10b,F
;	WLW	3,w4fall10c,F

	WL	-1,seq_stayinair

	WLW	N,w4fall11,F
	WLL	-1,seq_snd,land_snd
	WLW	N2,w4fall12,F
	WLW	N2,w4fall13,F
	WLW	N2,w4fall14,F
	WLW	N2,w4fall15,F
	WLW	N2,w4fall16,F
	WLW	N2,w4fall17,F
	WLW	N2,w4fall18,F
	W0
#4
	WLW	N,w4fall1,F
	WLL	-1,seq_snd,fall2_snd
	WLW	N,w4fall2,F
	WLW	N,w4fall3,F
	WLW	N,w4fall4,F
	WLW	N,w4fall5,F
	WLW	N,w4fall6,F
	WLW	N,w4fall7,F
	WLW	N,w4fall8,F
	WLW	N,w4fall9,F
	WLW	N,w4fall10,F
;	WLW	1,w4fall10a,F
;	WLW	1,w4fall10b,F
;	WLW	3,w4fall10c,F

	WL	-1,seq_stayinair

	WLW	N,w4fall11,F
	WLW	N2,w4fall12,F
	WLW	N2,w4fall13,F
	WLW	N2,w4fall14,F
	WLW	N2,w4fall15,F
	WLW	N2,w4fall16,F
	WLW	N2,w4fall17,F
	WLW	N2,w4fall18,F
	W0
#*
ffall_t
	.word	NOMV_M|NOBALL_M|NOJUMP_M|NOJOY_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
	.asg	5,N
#2
	WL	-1,seq_strtfire
	WLW	N,F2FALL01,F
	WLL	-1,seq_snd,fall1_snd
	WLW	N,F2FALL02,F
	WLW	N,F2FALL03,F
	WLW	N,F2FALL04,F
	WLW	N,F2FALL05,F
	WLW	N,F2FALL06,F
	WLW	N,F2FALL07,F
	WLW	N,F2FALL08,F

	WL	-1,seq_stayinair

	WLW	N,F2FALL09,F
	WLL	-1,seq_snd,land_snd
	WLW	N2,F2FALL10,F
	WLW	N2,F2FALL11,F
	WLW	N2,F2FALL12,F
	WLW	N2,F2FALL13,F
	WLW	N2,F2FALL14,F
	WLW	N2,F2FALL15,F
	WL	-1,seq_smoke
	WLW	N2,F2FALL16,F
	WLW	N2,F2FALL17,F
	WLW	N2,F2FALL18,F
	WLW	N2,F2FALL19,F
	WLW	N2,F2FALL20,F
	WLW	N2,F2FALL21,F
	WLW	N2,F2FALL22,F
	WLW	N2,F2FALL23,F
	WLW	N2,F2FALL24,F
	WL	-1,seq_stopfire
	W0
#3
#4
	WL	-1,seq_strtfire
	WLW	N,F4FALL01,F
	WLL	-1,seq_snd,fall2_snd
	WLW	N,F4FALL02,F
	WLW	N,F4FALL03,F
	WLW	N,F4FALL04,F
	WLW	N,F4FALL05,F
	WLW	N,F4FALL06,F
	WLW	N,F4FALL07,F
	WLW	N,F4FALL08,F

	WL	-1,seq_stayinair

	WLW	N,F4FALL09,F
	WLL	-1,seq_snd,land_snd
	WLW	N2,F4FALL10,F
	WLW	N2,F4FALL11,F
	WLW	N2,F4FALL12,F
	WLW	N2,F4FALL13,F
	WLW	N2,F4FALL14,F
	WLW	N2,F4FALL15,F
	WL	-1,seq_smoke
	WLW	N2,F4FALL16,F
	WLW	N2,F4FALL17,F
	WLW	N2,F4FALL18,F
	WLW	N2,F4FALL19,F
	WLW	N2,F4FALL20,F
	WLW	N2,F4FALL21,F
	WLW	N2,F4FALL22,F
	WLW	N2,F4FALL23,F
	WLW	N2,F4FALL24,F
	WLW	N2,F4FALL25,F
	WLW	N2,F4FALL26,F
	WL	-1,seq_stopfire
	W0
#*
fflyback_t
	.word	NOMV_M|NOBALL_M|NOJUMP_M|NOJOY_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
fflybackwb_t
	.word	NOMV_M|NOJUMP_M|NOJOY_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
	.asg	3,N
	.asg	3,N2
#2
	WL	-1,seq_strtfire
	WL	-1,seq_keepzx
	WLW	N,F2FALL01,F
	WLL	-1,seq_snd,fall1_snd
	WLW	N,F2FALL02,F
	WLW	N,F2FALL03,F
	WLW	N,F2FALL04,F
	WLW	N,F2FALL05,F
	WLW	N,F2FALL06,F
	WLW	N,F2FALL07,F
	WLW	N,F2FALL08,F

	WL	-1,seq_stayinair
	WL	-1,seq_injury

	WLL	-1,seq_snd,land_snd
	WL	-1,seq_stuffzx
	WLW	1,F2FALL09,F
	WL	-1,seq_stuffzx
	WLW	4,F2FALL09,F			;4
	WLL	-1,seq_snd,boo_snd

	WL	-1,seq_noballoff

	WLW	N2,F2FALL10,F
	WLW	N2,F2FALL11,F
	WLW	N2,F2FALL12,F
	WLW	N2,F2FALL13,F
	WLW	N2,F2FALL14,F
	WLW	N2,F2FALL15,F
	WLW	N2,F2FALL16,F
	WL	-1,seq_smoke
	WLW	N2,F2FALL17,F
	WLW	N2,F2FALL18,F
	WLW	N2,F2FALL19,F
	WLW	N2,F2FALL20,F
	WLW	N2,F2FALL21,F
	WLW	N2,F2FALL22,F
	WLW	N2,F2FALL23,F
	WLW	N2,F2FALL24,F
	WL	-1,seq_stopfire
	W0
#3
	WL	-1,seq_strtfire
	WLL	-1,seq_snd,ungh_snd
	WL	-1,seq_keepzx
	WLW	N,F4FALL01,F
	WLL	-1,seq_snd,fall2_snd
	WLW	N,F4FALL02,F
	WLW	N,F4FALL03,F
	WLW	N,F4FALL04,F
	WLW	N,F4FALL05,F
	WLW	N,F4FALL06,F
	WLW	N,F4FALL07,F
	WLW	N,F4FALL08,F
	WLW	N,F4FALL09,F
	WLW	N,F4FALL10,F

	WL	-1,seq_stayinair
	WL	-1,seq_injury

	WLL	-1,seq_snd,land_snd
	WL	-1,seq_stuffzx
	WLW	1,F4FALL11,F			;30
	WL	-1,seq_stuffzx
	WLW	4,F4FALL11,F			;30
	WLL	-1,seq_snd,boo_snd
	WL	-1,seq_noballoff
	WLW	N2,F4FALL12,F
	WLW	N2,F4FALL13,F
	WLW	N2,F4FALL14,F
	WLW	N2,F4FALL15,F
	WLW	N2,F4FALL16,F
	WL	-1,seq_smoke
	WLW	N2,F4FALL17,F
	WLW	N2,F4FALL18,F
	WLW	N2,F4FALL19,F
	WLW	N2,F4FALL20,F
	WLW	N2,F4FALL21,F
	WLW	N2,F4FALL22,F
	WLW	N2,F4FALL23,F
	WLW	N2,F4FALL24,F
	WLW	N2,F4FALL25,F
	WLW	N2,F4FALL26,F
	WL	-1,seq_stopfire
	W0

#4
	WL	-1,seq_strtfire
	WLL	-1,seq_snd,ungh_snd
;	WL	-1,seq_keepzx
	WLW	N,F4FALL01,F
	WLL	-1,seq_snd,fall2_snd
	WLW	N,F4FALL02,F
	WLW	N,F4FALL03,F
	WLW	N,F4FALL04,F
	WLW	N,F4FALL05,F
	WLW	N,F4FALL06,F
	WLW	N,F4FALL07,F
	WLW	N,F4FALL08,F
	WLW	N,F4FALL09,F
	WLW	N,F4FALL10,F

	WL	-1,seq_stayinair
	WL	-1,seq_injury

	WLL	-1,seq_snd,land_snd
	WLW	3,F4FALL11,F			;30
	WLL	-1,seq_snd,boo_snd
	WL	-1,seq_noballoff
	WLW	N2,F4FALL12,F
	WLW	N2,F4FALL13,F
	WLW	N2,F4FALL14,F
	WLW	N2,F4FALL15,F
	WLW	N2,F4FALL16,F
	WL	-1,seq_smoke
	WLW	N2,F4FALL17,F
	WLW	N2,F4FALL18,F
	WLW	N2,F4FALL19,F
	WLW	N2,F4FALL20,F
	WLW	N2,F4FALL21,F
	WLW	N2,F4FALL22,F
	WLW	N2,F4FALL23,F
	WLW	N2,F4FALL24,F
	WLW	N2,F4FALL25,F
	WLW	N2,F4FALL26,F
	WL	-1,seq_stopfire
	W0
#*
flyback_t
	.word	NOMV_M|NOBALL_M|NOJUMP_M|NOJOY_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
flybackwb_t
	.word	NOMV_M|NOJUMP_M|NOJOY_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
	.asg	3,N
	.asg	4,N2
#2
	WLW	N,w2fall1,F
	WL	-1,seq_keepzx
	WLL	-1,seq_snd,fall1_snd
	WLW	N,w2fall2,F
	WLW	N,w2fall3,F
	WLW	N,w2fall4,F
	WLW	N,w2fall5,F
	WLW	N,w2fall6,F
	WLW	N,w2fall7,F
	WLW	N,w2fall8,F

	WL	-1,seq_stayinair
	WL	-1,seq_injury

	WL	-1,seq_stuffzx
	WLL	-1,seq_snd,land_snd
	WLW	23,w2fall9,F			;29
	WLL	-1,seq_snd,boo_snd

	WL	-1,seq_noballoff

	WLW	N2,w2fall10,F
	WLW	N2,w2fall11,F
	WLW	N2,w2fall12,F
	WLW	N2,w2fall13,F
	WLW	N2,w2fall14,F
	WLW	N2,w2fall15,F
	WLW	N2,w2fall16,F
	W0
#3
	WLL	-1,seq_snd,oof_snd
	WLL	-1,seq_snd,fall2_snd
;	WL	-1,seq_keepzx
	WLW	N,w3fall1,F
	WLW	N,w3fall2,F
	WLW	N,w3fall3,F
	WLW	N,w4fall1,F
	WLW	N,w4fall2,F
	WLW	N,w4fall3,F
	WLW	N,w4fall4,F
	WLW	N,w4fall5,F
	WLW	N,w4fall6,F
	WLW	N,w4fall7,F
	WLW	N,w4fall8,F
	WLW	N,w4fall9,F
	WLW	N,w4fall10,F

	WL	-1,seq_stayinair
	WL	-1,seq_injury

	WLL	-1,seq_snd,land_snd
;	WL	-1,seq_stuffzx
;	WLW	15,w4fall11,F			;2
	WLW	20,w4fall11,F			;28
	WLL	-1,seq_snd,boo_snd
	WL	-1,seq_noballoff
	WLW	N2,w4fall12,F
	WLW	N2,w4fall13,F
	WLW	N2,w4fall14,F
	WLW	N2,w4fall15,F
	WLW	N2,w4fall16,F
	WLW	N2,w4fall17,F
	WLW	N2,w4fall18,F
	W0
#4
	WLL	-1,seq_snd,ungh_snd
;	WL	-1,seq_keepzx
	WLW	N,w4fall1,F
	WLL	-1,seq_snd,fall2_snd
	WLW	N,w4fall2,F
	WLW	N,w4fall3,F
	WLW	N,w4fall4,F
	WLW	N,w4fall5,F
	WLW	N,w4fall6,F
	WLW	N,w4fall7,F
	WLW	N,w4fall8,F
	WLW	N,w4fall9,F
	WLW	N,w4fall10,F

	WL	-1,seq_stayinair
;	WL	-1,seq_stuffzx
	WL	-1,seq_injury

	WLL	-1,seq_snd,land_snd
	WLW	25,w4fall11,F			;30
	WLL	-1,seq_snd,boo_snd
	WL	-1,seq_noballoff
	WLW	N2,w4fall12,F
	WLW	N2,w4fall13,F
	WLW	N2,w4fall14,F
	WLW	N2,w4fall15,F
	WLW	N2,w4fall16,F
	WLW	N2,w4fall17,F
	WLW	N2,w4fall18,F
	W0

#*
flyback2_t
	.word	NOMV_M|NOJOY_M|NOBALL_M|NOJUMP_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
flybackwb2_t
	.word	NOMV_M|NOJOY_M|NOJUMP_M|NOSTEAL_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
	.asg	5,N


#2
	WLW	N,w2fall1,F
	WLL	-1,seq_snd,boo_snd
	WLW	N,w2fall2,F
	WLW	N,w2fall3,F
	WLW	N,w2fall4,F
	WLW	N,w2fall3,F
	WLW	N,w2fall2,F
	WLW	N,w2fall1,F
	W0
#3
	WLW	N,w3fall1,F
	WLL	-1,seq_snd,oof_snd
	WLW	N,w3fall2,F
	WLW	N,w3fall3,F
	WLL	-1,seq_snd,boo_snd
	WLW	N,w3fall4,F
	WLW	N,w3fall5,F
	WLW	N,w3fall6,F
	WLW	N,w3fall7,F
	WLW	N,w3fall8,F
	W0
#4
	WLW	N+1,w4fall1,F
	WLL	-1,seq_snd,ungh_snd
	WLW	N+1,w4fall2,F
	WLW	N+1,w4fall3,F
	WLL	-1,seq_snd,boo_snd
	WLW	N+1,w4fall4,F
	WLW	N+1,w4fall3,F
	WLW	N,w4fall2,F
	WLW	N,w4fall1,F
	W0
#*
fflyback2_t
	.word	NOMV_M|NOJOY_M|NOBALL_M|NOJUMP_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
fflybackwb2_t
	.word	NOMV_M|NOJOY_M|NOJUMP_M|NOSTEAL_M|NOCOLLP_M|SAMEDIR_M
	.long	seq_stand
	.long	#2,#2,#3,#4,#4,#4,#3,#2
	.asg	5,N

#2
	WL	-1,seq_strtfire
	WLW	N,F2FALL01,F
	WLL	-1,seq_snd,oof_snd
	WLW	N,F2FALL02,F
	WLW	N,F2FALL03,F
	WLW	N,F2FALL04,F
	WLW	N,F2FALL03,F
	WLW	N,F2FALL02,F
	WLW	N,F2FALL01,F
	WL	-1,seq_stopfire
	W0
#3
#4
	WL	-1,seq_strtfire
	WLW	N+1,F4FALL01,F
	WLL	-1,seq_snd,ungh_snd
	WLW	N+1,F4FALL02,F
	WLW	N+1,F4FALL03,F
	WLL	-1,seq_snd,boo_snd
	WLW	N+1,F4FALL04,F
	WLW	N+1,F4FALL03,F
	WLW	N,F4FALL02,F
	WLW	N,F4FALL01,F
	WL	-1,seq_stopfire
	W0

#*
pickup_t
	.word	NOMV_M|NOSTEAL_M|NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	3,N
#1
	WLW	N,w1pikup1,F|M_YF
	WLW	N,w1pikup2,F|M_YF
	WLW	N,w1pikup3,F
	WLW	N,w1pikup2,F
	WLW	N,w1pikup1,F
	W0
#2
	WLW	N,w2pikup1,F|M_YF
	WLW	N,w2pikup2,F|M_YF
	WLW	N,w2pikup3,F
	WLW	N,w2pikup2,F
	WLW	N,w2pikup1,F
	W0
#3
	WLW	N,w3pikup1,F|M_YF
	WLW	N,w3pikup2,F|M_YF
	WLW	N,w3pikup3,F
	WLW	N,w3pikup2,F
	WLW	N,w3pikup1,F
	W0
#4
	WLW	N,w4pikup1,F|M_YF
	WLW	N,w4pikup2,F|M_YF
	WLW	N,w4pikup3,F
	WLW	N,w4pikup2,F
	WLW	N,w4pikup1,F
	W0
#5
	WLW	N,w5pikup1,F|M_YF
	WLW	N,w5pikup2,F|M_YF
	WLW	N,w5pikup3,F
	WLW	N,w5pikup2,F
	WLW	N,w5pikup1,F
	W0
#*
elbo_t
	.word	NOMV_M|NOSTEAL_M|NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#2,#2,#2,#4,#4,#4,#2,#2
	.asg	3,N
#2
	WLW	N,w2elbo3,F
	WLL	-1,seq_snd,push1_snd
	WL	-1,seq_elbo
	WLW	N,w2elbo2,F
	WLW	N,w2elbo1,F
	WLW	N,w2elbo2,F
	WLW	N,w2elbo3,F
	WLW	N,w2elbo4,F
	WLL	-1,seq_snd,push2_snd
	WLW	N,w2elbo5,F
	WLW	N,w2elbo4,F
	WLW	N,w2elbo3,F
	W0
#4
	WLW	N,w4elbo4,F
	WLL	-1,seq_snd,push3_snd
	WL	-1,seq_elbo
	WLW	N,w4elbo3,F
	WLW	N,w4elbo2,F
	WLW	N,w4elbo1,F
	WLW	N,w4elbo2,F
	WLW	N,w4elbo3,F
	WLW	N,w4elbo4,F
	WLW	N,w4elbo5,F
	WLL	-1,seq_snd,push1_snd
	WLW	N,w4elbo6,F
	WLW	N,w4elbo7,F
	WLW	N,w4elbo6,F
	WLW	N,w4elbo5,F
	WLW	N,w4elbo4,F
	W0


#*
elbo2_t
	.word	NOMV_M|NOJOY_M|NOSTEAL_M|NOJUMP_M
	.long	seq_stand
	.long	#2,#2,#2,#4,#4,#4,#2,#2
	.asg	3,N
#2
	WLW	N,w2elbo3,F
	WLL	-1,seq_snd,push1_snd
	WL	-1,seq_elbo
	WLW	N,w2elbo2,F
	WLW	N,w2elbo1,F
	WLW	N,w2elbo2,F
	WLW	N,w2elbo3,F
	WLW	N,w2elbo4,F
	WLL	-1,seq_snd,push1_snd
	WLW	10,w2elbo5,F
	WLW	N,w2elbo4,F
	WLW	N,w2elbo3,F
	W0
#4
	WLW	N,w4elbo4,F
	WLL	-1,seq_snd,push3_snd
	WL	-1,seq_elbo
	WLW	N,w4elbo3,F
	WLW	N,w4elbo2,F
	WLW	N,w4elbo1,F
	WLW	N,w4elbo2,F
	WLW	N,w4elbo3,F
	WLW	N,w4elbo4,F
	WLW	N,w4elbo5,F
	WLL	-1,seq_snd,push1_snd
	WLW	N,w4elbo6,F
	WLW	10,w4elbo7,F
	WLW	N,w4elbo6,F
	WLW	N,w4elbo5,F
	WLW	N,w4elbo4,F
	W0

	.end

