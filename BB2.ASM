**************************************************************
*
* Owner:	THOMPSON
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		7/17/90
*
* Modified:		Shawn Liptak, 1/27/92	-Started basketball
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 11/18/92 23:00
**************************************************************
	.file	"bb2.asm"
	.title	"Basketball game program"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include        "plyrhd.glo"
;	.include	"imgtbl1.glo"
;	.include	"imgpal1.asm"
	.include	"plyrseq.tbl"
	.include	"plyrseq.glo"
	.include	"game.equ"
	.include	"macros.hdr"		;Macros
	.asg		0,SEQT
	.include	"plyr.equ"

	.ref	NEWILPAL
;	.ref	PLYRRCH_P

	.if	IMGVIEW

	.include	"imgtbl.glo" 
	.include	"imgtbl2.glo"


	.include	STAND.TBL
	.include	"plyrseq2.tbl"

;	.include	"plyrd2sq.tbl"
;	.include	layup.TBL
;	.include	"fireseq.tbl"
;	.include	"pass.tbl"
;	.include	"plyrdseq.tbl"
;	.include	"plyrrseq.tbl"
;	.include	"imgpal3.asm"


*****************************************************************************
;Debug
;Display each frame of our ball player to check 2nd and 3rd ani pnts, etc.
;Re-insert these lines when tweaking ani points



debug_lst
	.long	debug1+16,debug1+16,debug1+16,debug4+16
butn_minus
	.long	12,12,12,6
butn_plus
	.long	14,14,14,13



;a8=0-3

 SUBR	anipts_debug


	SLEEP	3*60

	sll	5,a8
	movi	debug_lst,a0
	add	a8,a0
	move	*a0,a9,L

	movi	butn_minus,a0
	add	a8,a0
	move	*a0,a10

	movi	butn_plus,a0
	add	a8,a0
	move	*a0,a11

	movi	debug_img_list,a8

	clr	a0
	move	a0,*a13(PDATA)
	movk	3,a1
	move	a1,*a13(PDATA+16)

#swtop	SLEEPK	1
	move	*a8,*a9,L		;Writes to ROM
	move	@SWITCH,a0,L
	cmpi	>ffefffff,a0
	jrnz	#sw1
	clr	a0
	move	a0,*a13(PDATA)
	jruc	#swtop
#sw1	move	*a13(PDATA),a1
	jrz	#sw2			;#swtop
    	move	*a13(PDATA+16),a1
	jrz	#sw2
	dec	a1
	move	a1,*a13(PDATA+16)
	jruc	#swtop

#sw2	btst	a11,a0			;14
	jrz	advance
	btst	a10,a0			;12
	jrnz	#swtop
;go backwards
	cmpi	debug_img_list,a8
	jrz	#swtop
	subk	32,a8
	movk	1,a0
	move	a0,*a13(PDATA)
	movk	3,a1
	move	a1,*a13(PDATA+16)
	jruc	#swtop
advance	cmpi	debug_img_end,a8
	jrz	#swtop
	addk	32,a8
	movk	1,a0
	move	a0,*a13(PDATA)
	movk	3,a1
	move	a1,*a13(PDATA+16)
	jruc	#swtop

	.asg	M_WRNONZ,F


	.def	debug1,debug4
;	.def	debug_t1,debug_t4

debug_t1
	.word	0
       	.long	0
       	.long	debug1,debug1,debug1,debug1
       	.long	debug1,debug1,debug1,debug1
debug1
	WLW	10,w1js1,F
	W0

debug_t4
	.word	0
       	.long	0
       	.long	debug4,debug4,debug4,debug4
       	.long	debug4,debug4,debug4,debug4
debug4
	WLW	10,w1js1,F
	W0


debug_img_list

	.if	0

;Set A
;From BB2.LOD
;PLYRSEQ.TBL & STAND.TBL
;nba_sht1.img
	.long	w1js1,w1js2,w1js3,w1js4
	.long	w1js5,w1js6,w1js7,w1js8,w1js9,w1js10,w2js1,w2js2,w2js3,w2js4,w2js5
	.long	w2js6,w2js7,w2js8,w2js9,w2js10,w3js1,w3js2,w3js3,w3js4,w3js5,w3js6
	.long	w3js7,w3js8,w3js9,w3js10,w4js1,w4js2,w4js3,w4js4,w4js5,w4js6,w4js7
	.long	w4js8,w4js9,w4js10,w5js1,w5js2,w5js3,w5js4,w5js5,w5js6,w5js7,w5js8
	.long	w5js9,w5js10
;willie.img
	.long	w1jupa
	.long	w2jupa
	.long	w3jupa,w4jupa
	.long	w5jupa

;nba_msc3.img
	.long	w1stwb1,w1stwb2,w1stwb3,w1stwb4,w2stwb1
	.long	w2stwb2,w2stwb3,w2stwb4,w3stwb1,w3stwb2,w3stwb3,w3stwb4,w4stwb1,w4stwb2
	.long	w4stwb3,w4stwb4,w5stwb1,w5stwb2,w5stwb3,w5stwb4

;nba_stn1.img
	.long	W1ST1
	.long	W1ST2,W1ST3,W1ST4,W1ST5,W1ST6,W2ST1,W2ST2,W2ST3,W2ST4,W2ST5,W2ST6,W3ST1
	.long	W3ST2,W3ST3,W3ST4,W3ST5,W3ST6,W4ST1,W4ST2,W4ST3,W4ST4,W4ST5,W4ST6,W5ST1
	.long	W5ST2,W5ST3,W5ST4,W5ST5,W5ST6
	.long	w1stwbl1,w1stwbl2,w1stwbl3,w1stwbl4
	.long	w2stwbl1,w2stwbl2,w2stwbl3,w2stwbl4,w3stwbl1,w3stwbl2,w3stwbl3,w3stwbl4
	.long	w4stwbl1,w4stwbl2,w4stwbl3,w4stwbl4,w5stwbl1,w5stwbl2,w5stwbl3,w5stwbl4

;nba_def1.img
	.long	T1SWPE1,T1SWPE2,T1SWPE3
	.long	T1SWPE4,T1SWPE5,T1SWPE6,T1SWPE7,T1SWPE8,T1SWPE9,T2SWPE1,T2SWPE2,T2SWPE3
	.long	T2SWPE4,T2SWPE5,T2SWPE6,T2SWPE7,T2SWPE8,T2SWPE9,T3SWPE1,T3SWPE2,T3SWPE3
	.long	T3SWPE4,T3SWPE5,T3SWPE6,T3SWPE7,T3SWPE8,T3SWPE9,T4SWPE1,T4SWPE2,T4SWPE3
	.long	T4SWPE4,T4SWPE5,T4SWPE6,T4SWPE7,T4SWPE8,T4SWPE9,T5SWPE1,T5SWPE2,T5SWPE3
	.long	T5SWPE4,T5SWPE5,T5SWPE6,T5SWPE7,T5SWPE8,T5SWPE9,T1SWPU1,T1SWPU2,T1SWPU3
	.long	T1SWPU4,T1SWPU5,T1SWPU6,T1SWPU7,T1SWPU8,T1SWPU9,T2SWPU1,T2SWPU2,T2SWPU3
	.long	T2SWPU4,T2SWPU5,T2SWPU6,T2SWPU7,T2SWPU8,T2SWPU9,T3SWPU1,T3SWPU2,T3SWPU3
	.long	T3SWPU4,T3SWPU5,T3SWPU6,T3SWPU7,T3SWPU8,T3SWPU9,T4SWPU1,T4SWPU2,T4SWPU3
	.long	T4SWPU4,T4SWPU5,T4SWPU6,T4SWPU7,T4SWPU8,T4SWPU9,T5SWPU1,T5SWPU2,T5SWPU3
	.long	T5SWPU4,T5SWPU5,T5SWPU6,T5SWPU7,T5SWPU8,T5SWPU9

;nba_pas1.img
	.long	w1cp1,w1cp2,w1cp3,w1cp4
	.long	w1cp5,w1cp6,w2cp1,w2cp2,w2cp3,w2cp4,w2cp5,w2cp6,w3cp1,w3cp2,w3cp3,w3cp4
	.long	w3cp5,w3cp6,w4cp1,w4cp2,w4cp3,w4cp4,w4cp5,w4cp6,w5cp1,w5cp2,w5cp3,w5cp4
	.long	w5cp5,w5cp6,w1ohp1,w1ohp2,w1ohp3,w1ohp4,w1ohp5,w1ohp6,w1ohp7,w1ohp8
	.long	w1ohp9,w1ohp10,w1ohp11,w2ohp1,w2ohp2,w2ohp3,w2ohp4,w2ohp5,w2ohp6,w2ohp7
	.long	w2ohp8,w2ohp9,w2ohp10,w2ohp11,w3ohp1,w3ohp2,w3ohp3,w3ohp4,w3ohp5,w3ohp6
	.long	w3ohp7,w3ohp8,w3ohp9,w3ohp10,w3ohp11,w4ohp1,w4ohp2,w4ohp3,w4ohp4,w4ohp5
	.long	w4ohp6,w4ohp7,w4ohp8,w4ohp9,w4ohp10,w4ohp11,w5ohp1,w5ohp2,w5ohp3,w5ohp4
	.long	w5ohp5,w5ohp6,w5ohp7,w5ohp8,w5ohp9,w5ohp10,w5ohp11

;nba_msc2.img
	.long	w1push1,w1push2,w1push3
	.long	w1push4,w1push5,w1push6,w1push7,w1push8,w1push9,w1push10,w1push11
	.long	w2push1,w2push2,w2push3,w2push4,w2push5,w2push6,w2push7,w2push8,w2push9
	.long	w2push10,w2push11,w3push1,w3push2,w3push3,w3push4,w3push5,w3push6
	.long	w3push7,w3push8,w3push9,w3push10,w3push11,w4push1,w4push2,w4push3
	.long	w4push4,w4push5,w4push6,w4push7,w4push8,w4push9,w4push10,w4push11
	.long	w5push1,w5push2,w5push3,w5push4,w5push5,w5push6,w5push7,w5push8,w5push9
	.long	w5push10,w5push11

;nba_def3.img
	.long	w1reb1,w1reb2,w1reb3,w1reb4,w1reb5,w1reb6,w1reb7,w1reb8,w1reb9,w1reb10
	.long	w2reb1,w2reb2,w2reb3,w2reb4,w2reb5,w2reb6,w2reb7,w2reb8,w2reb9,w2reb10
	.long	w3reb1,w3reb2,w3reb3,w3reb4,w3reb5,w3reb6,w3reb7,w3reb8,w3reb9,w3reb10
	.long	w4reb1,w4reb2,w4reb3,w4reb4,w4reb5,w4reb6,w4reb7,w4reb8,w4reb9,w4reb10
	.long	w5reb1,w5reb2,w5reb3,w5reb4,w5reb5,w5reb6,w5reb7,w5reb8,w5reb9,w5reb10
;	.long	w1blokl1,w1blokl2,w1blokl3,w1blokl4,w1blokl5,w1blokl6,w1blokl7,w1blokl8
;	.long	w2blokl1,w2blokl2,w2blokl3,w2blokl4,w2blokl5,w2blokl6,w2blokl7,w2blokl8
;	.long	w3blokl1,w3blokl2,w3blokl3,w3blokl4,w3blokl5,w3blokl6,w3blokl7,w3blokl8
;	.long	w4blokl1,w4blokl2,w4blokl3,w4blokl4,w4blokl5,w4blokl6,w4blokl7,w4blokl8
;	.long	w5blokl1,w5blokl2,w5blokl3,w5blokl4,w5blokl5,w5blokl6,w5blokl7,w5blokl8

;nba_def4.img
	.long	w1rej1,w1rej2,w1rej3
	.long	w1rej4,w1rej5,w1rej6,w1rej7,w1rej8,w1rej9,w1rej10,w1rej11,w2rej1,w2rej2
	.long	w2rej3,w2rej4,w2rej5,w2rej6,w2rej7,w2rej8,w2rej9,w2rej10,w2rej11,w3rej1
	.long	w3rej2,w3rej3,w3rej4,w3rej5,w3rej6,w3rej7,w3rej8,w3rej9,w3rej10,w3rej11
	.long	w4rej1,w4rej2,w4rej3,w4rej4,w4rej5,w4rej6,w4rej7,w4rej8,w4rej9,w4rej10
	.long	w4rej11
	
	.endif

;Set B
;From BB2.LOD
;PLYRSEQ2.TBL
;nba_msc2.img
	.long	w1elbo1,w1elbo3,w1elbo4,w1elbo5,w1elbo6,w1elbo7,w1elbo8
	.long	w2elbo2,w2elbo3,w2elbo4,w2elbo5,w2elbo6,w2elbo8
	.long	w4elbo3,w4elbo4,w4elbo5,w4elbo6,w4elbo7,w4elbo8
	.long	w5elbo3,w5elbo4,w5elbo5,w5elbo6,w5elbo7
	.long	w4tipst1,w4tipst2,w4tipst3,w4tipst4,w4tipst5,w4tip1
	.long	w4tip2,w4tip3,w4tip4,w4tip5,w4tip6,w4tip7,w2tipst1,w2tipst2,w2tipst3
	.long	w2tipst4,w2tipst5,w2tip1,w2tip2,w2tip3,w2tip4,w2tip5,w2tip6,w2tip7
;nba_msc3.img
	.long	w2hndne1,w2hndne2,w2hndne3,w2hndne4,w2hndne5
	.long	w4hndne1,w4hndne2,w4hndne3,w4hndne4
	.long	w4hndne5
	.long	w2hnesw1,w2hnesw2,w2hnesw3,w2hnesw4
	.long	w4hnesw1,w4hnesw2,w4hnesw3,w4hnesw4
	.long	w2hndhp1
	.long	w2hndhp2,w2hndhp3,w2hndhp4,w2hndhp5
	.long	w4hndhp1,w4hndhp2,w4hndhp3,w4hndhp4,w4hndhp5
	.long	w1pikup1,w1pikup2
	.long	w1pikup3,w1pikup4,w1pikup5,w2pikup1,w2pikup2,w2pikup3,w2pikup4,w2pikup5
	.long	w3pikup1,w3pikup2,w3pikup3,w3pikup4,w3pikup5,w4pikup1,w4pikup2,w4pikup3
	.long	w4pikup4,w4pikup5,w5pikup1,w5pikup2,w5pikup3,w5pikup4,w5pikup5
;nba_msc4.img
	.long	w1fall1,w1fall2,w1fall3,w1fall4,w1fall5
	.long	w1fall6,w1fall7,w1fall8,w1fall9,w1fall10
	.long	w2fall1,w2fall2,w2fall3,w2fall4,w2fall5
	.long	w2fall6,w2fall7,w2fall8,w2fall9,w2fall10,w2fall11
	.long	w3fall1,w3fall2,w3fall3,w3fall4,w3fall5,w3fall6
	.long	w3fall7,w3fall8,w3fall9,w3fall10,w3fall11,w3fall12
	.long	w4fall1,w4fall2,w4fall3,w4fall4,w4fall5,w4fall6
	.long	w4fall7,w4fall8,w4fall9,w4fall10,w4fall11,w4fall12
	.long	w5fall1,w5fall2,w5fall3,w5fall5,w5fall6
	.long	w5fall7,w5fall8,w5fall10,w5fall11,w5fall12
;nbaspnmv.img
	.long	W3SPMVA1,W3SPMVA2,W3SPMVA3,W3SPMVA4,W3SPMVA5,W3SPMVA6,W3SPMVA7,W3SPMVA8
	.long	W3SPMVA9,W3SPMVA10,W3SPMVA11,W3SPMVA12,W3SPMVA13,W3SPMVA14,W3SPMVA15
	.long	W3SPMVA16,W3SPMVA17,W3SPMVA18,W3SPMVA19,W3SPMVA20


debug_img_end
	.long	W3SPMVA20

	.endif


	.end




