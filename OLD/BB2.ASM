**************************************************************
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

	.if	IMGVIEW

	.include	"imgtbl.glo"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"shawn.hdr"		;Macros
	.include	"court.tbl"
	.asg		0,SEQT
	.include	"plyr.equ"


*****************************************************************************
;Debug
;Display each frame of our ball player to check 2nd and 3rd ani pnts, etc.
;Re-insert these lines when tweaking ani points


	.include	"plyrseq.tbl"
	.include	"plyrdseq.tbl"

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
	move	*a8,*a9,L
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
	WLW	10,w1stand,F
	W0

debug_t4
	.word	0
       	.long	0
       	.long	debug4,debug4,debug4,debug4
       	.long	debug4,debug4,debug4,debug4
debug4
	WLW	10,w1stand,F
	W0


debug_img_list
	.long	T1SWPE1,T1SWPE2,T1SWPE3,T1SWPE4,T1SWPE5,T1SWPE6,T1SWPE7,T1SWPE8,T1SWPE9
	.long	T2SWPE1,T2SWPE2,T2SWPE3,T2SWPE4,T2SWPE5,T2SWPE6,T2SWPE7
	.long	T3SWPE1,T3SWPE2,T3SWPE3,T3SWPE4,T3SWPE5,T3SWPE6,T3SWPE7
	.long	T4SWPE1,T4SWPE2,T4SWPE3,T4SWPE4,T4SWPE5,T4SWPE6
	.long	T5SWPE1,T5SWPE2,T5SWPE3,T5SWPE4,T5SWPE5,T5SWPE6
	.long	w1cp1,w1cp2,w1cp3,w1cp4,w1drun1,w1drun2,w1drun3,w1drun4,w1drun5,w1drun6
	.long	w1drun7,w1drun8,w1dst1,w1dst2,w1dst3,w1dst4,w1dst5,w1dst6,w1js1,w1js2
	.long	w1run8,w1js3,w1js4,w1js5,w1jupa,w1run1,w1run2,w1run3,w1run4,w1run5,w1run6
	.long	w1run7,w1stand,w2cp1,w2cp2,w2cp3,w2cp4,w2drun1,w2drun2,w2drun3,w2drun4
	.long	w2drun5,w2drun6,w2drun7,w2drun8,w2js1,w2js2,w2js3,w2js4,w2js5,w2jupa
	.long	w2run1,w2run2,w2run3,w2run4,w2run5,w2run6,w2run7,w2run8,w2stand,w3cp1
	.long	w3cp2,w3cp3,w3cp4,w3drun1,w3drun2,w3drun3,w3drun4,w3drun5,w3drun6
	.long	w3drun7,w3drun8,w3dst1,w3dst2,w3dst3,w3dst4,w3dst5,w3dst6,w3js1,w3js2
	.long	w3js3,w3js4,w3js5,w3jupa,w3run1,w3run2,w3run3,w3run4,w3run5,w3run6
	.long	w3run7,w3run8,w3stand,w4cp1,w4cp2,w4cp3,w4cp4,w4drun1,w4drun2,w4drun3
	.long	w4drun4,w4drun5,w4drun6,w4drun7,w4drun8,w4dst1,w4dst2,w4dst3,w4dst4
	.long	w4dst5,w4dst6,w4js1,w4js2,w4js3,w4js4,w4js5,w4jupa,w4run1,w4run2,w4run3
	.long	w4run4,w4run5,w4run6,w4run7,w4run8,w4stand,w5cp1,w5cp2,w5cp3,w5cp4
	.long	w5drun1,w5drun2,w5drun3,w5drun4,w5drun5,w5drun6,w5drun7,w5drun8,w5dst1
	.long	w5dst2,w5dst3,w5dst4,w5dst5,w5dst6,w5js1,w5js2,w5js3,w5js4,w5js5,w5jupa
	.long	w5run1,w5run2,w5run3,w5run4,w5run5,w5run6,w5run7,w5run8,w5stand
	.long	w1ohp1,w1ohp2,w1ohp3,w1ohp4,w1ohp5,w1ohp6
	.long	w2ohp1,w2ohp2,w2ohp3,w2ohp4
	.long	w2ohp5,w5ohp5,w3ohp5
	.long	w4ohp5,w3ohp1,w3ohp2,w3ohp3,w3ohp4,w4ohp1,w4ohp2,w4ohp3,w4ohp4,w5ohp1
	.long	w5ohp2,w5ohp3,w5ohp4
	.long	T1HANG9,T1HANG10,T1HANG1,T1HANG2,T1HANG3,T1HANG4,T1HANG5,T1HANG6,T1HANG7
	.long	T1HANG8
	.long	w2stdu1,w2stdu2,w2stdu3,w2stdu4,w2stdu5,w2stdu6,w2stdu7,w2stdu8,w2stdu9
	.long	w3shdu4,w3shdu5,w3shdu6,w3shdu7,w3shdu8,w3shdu9
	.long	w3shdu10,w3shdu11
	.long	w2jamdu2,w2jamdu3,w2jamdu4,w2jamdu5,w2jamdu6
	.long	w2jamdu7,w2jamdu8,w2jamdu9,w2jamdu10
	.long	w2bhdu3,w2bhdu4,w2bhdu5,w2bhdu6
	.long	w2bhdu7,w2bhdu8,w2bhdu9,w2bhdu10
	.long	w1hks1,w1hks2,w1hks3
	.long	w1hks4,w1hks5,w1hks6,w1spdu1
	.long	w1spdu10,w1spdu11,w1spdu2,w1spdu3,w1spdu4,w1spdu5,w1spdu6,w1spdu7
	.long	w1spdu8,w1spdu9,w1stdu1,w1stdu10,w1stdu2,w1stdu3,w1stdu4,w1stdu5
	.long	w1stdu6,w1stdu7,w1stdu8,w1stdu9
	.long	w2swdu1,w2swdu2,w2swdu3
	.long	w2swdu4,w2swdu5,w2swdu6,w2swdu7,w2swdu8,w2swdu9,w3flydu10,w3flydu2
	.long	w3flydu3,w3flydu4,w3flydu5,w3flydu6,w3flydu7,w3flydu8,w3flydu9,w3hang1
	.long	w3hang2,w3hang3,w3hang4,w3hang5,w3hang6,w3hang7,w3jmdu10,w3jmdu11
	.long	w3jmdu4,w3jmdu5,w3jmdu6,w3jmdu7,w3jmdu8,w3jmdu9
	.long	w3ondu1,w3ondu2,w3ondu3,w3ondu4,w3ondu5,w3ondu6,w3ondu7
	.long	w3ondu8
	.long	w3spdu1,w3spdu10,w3spdu2,w3spdu3,w3spdu4
	.long	w3spdu5,w3spdu6,w3spdu7,w3spdu8,w3spdu9,w3twdu1,w3twdu2,w3twdu3,w3twdu4
	.long	w3twdu5,w3twdu6,w3twdu7,w3twdu8,w4hks1,w4hks2,w4hks3,w4hks4,w4hks5
	.long	w4hks6,w4modu1,w4modu2,w4modu3,w4modu4,w4modu5,w4modu6,w4modu7
	.long	w4stdu3,w4stdu4,w4stdu5,w4stdu6,w4stdu7
	.long	w4stdu8,w5hks1,w5hks2,w5hks3,w5hks4,w5hks5,w5hks6
	.long	w5stdu1,w5stdu10,w5stdu11,w5stdu12,w5stdu13,w5stdu2
	.long	w5stdu3,w5stdu4,w5stdu5,w5stdu6,w5stdu7,w5stdu8,w5stdu9,w2swdu6a
	.long	w3sp2du3,w3sp2du4,w3sp2du5,w3sp2du6,w3sp2du7,w3sp2du8,w3sp2du9,w3sp2du10
	.long	w3sp2du11,w3sp2du12,w3sp2du13,w3sp2du14,w3sp2du15,w3sp2duA,w3sp2duB,w3sp2duC
	.long	w3sp2duD,w3sp2duE
	.long	w3wmdu3,w3wmdu4,w3wmdu5,w3wmdu6,w3wmdu7,w3wmdu8,w3wmdu9
	.long	w3wmdu10,w3wmduA,w3wmduB,w3wmduC,w3wmduD,w3wmduE
	.long	w1dpdu3,w1dpdu4,w1dpdu5,w1dpdu6,w1dpdu7,w1dpdu8,w1dpdu9,w1dpdu10,w1dpdu13
	.long	w2wmdu1,w2wmdu2,w2wmdu3,w2wmdu4,w2wmdu5,w2wmdu6,w2wmdu7,w2wmdu8,w2wmdu9
	.long	CANB1,CANB2,CANB3,CANB4,CANB5,CANB6,CANB7,CANB8,CANB9
	.long	CANB10,CANB11,CANB13,CANB14,CANB15,CANB16,CANB12
	.long	canroll1,canroll2,canroll3,canroll4,canroll5,canroll6,canroll7,canroll8
	.long	thangdu1,thangdu2,thangdu3,thangdu4,thangdu5,thangdu6,thangdu7,thangdu8
	.long	thangdu9,thangdu10,thangdu11
	.long	w3dfcr1,w3dfcr2,w3dfcr3,w3dfcr4,w3dfcr5,w3dfcr6,w3defwd1,w3defwd2
	.long	w3defwd3,w3defwd4,w3defwd5,w3defwd6,w1stel1,w1stel2,w1stel3,w1stel4
	.long	w1stelb1,w1stelb2,w2stel1,w2stel2,w2stel3,w2stel4,w2stelb1,w2stelb2
	.long	w3stel1,w3stel2,w3stel3,w3stel4,w3stelb1,w3stelb2,w4stelb1,w4stelb2
	.long	w5stel1,w5stel2,w5stel3,w5stelb1,w5stelb2,w1blok1,w1blok2,w1blok3
	.long	w2blok1,w2blok2,w2blok3,w4blok1,w4blok2,w4blok3,w1blhd1,w1blhd2,w1blhd3
	.long	w1blhd4,w1blhd5,w1blhd6,w1defwd1,w1defwd2,w1defwd3,w1defwd4,w1defwd5
	.long	w1defwd6,w1dfcr1,w1dfcr2,w1dfcr3,w1dfcr4,w1dfcr5,w1dfcr6,w1drcr1
	.long	w1drcr2,w1drcr3,w1drcr4,w1drcr5,w1drcr6,w2blhd1
	.long	w2blhd2,w2blhd3,w2blhd4,w2blhd5,w2blhd6,w2defwd1,w2defwd2,w2defwd3
	.long	w2defwd4,w2defwd5,w2defwd6,w2dfcr1,w2dfcr2,w2dfcr3,w2dfcr4,w2dfcr5
	.long	w2drcr1,w2drcr2,w2drcr3,w2drcr4,w2drcr5,w2fgrl1,w2fgrl2,w2fgrl3,w2fgrl4
	.long	w3blhd1,w3blhd2
	.long	w3blhd5,w3blhd6,w3blhd4,w3blhd3
	.long	w3blok1,w3blok2,w3blok3
	.long	w3fgrl2,w3fgrl3,w3fgrl4,w3fgrl5
	.long	w3fgrl6,w4blhd1,w4blhd2,w4blhd3
	.long	w4blhd4,w4blhd5,w4blhd6,w4defwd1,w4defwd2,w4defwd3,w4defwd4,w4defwd5
	.long	w4defwd6,w4dfcr1,w4dfcr2,w4dfcr3,w4dfcr4,w4dfcr5,w4dfcr6
	.long	w4fgrl1,w4fgrl2,w4fgrl3,w4stel1,w4stel2
	.long	w4stel3,w4stel4,w5blhd1,w5blhd2,w5blhd3,w5blhd4,w5blhd5,w5blhd6,w5blok1
	.long	w5blok2,w5blok3,w5defwd1,w5defwd2,w5defwd3,w5defwd4,w5defwd5,w5defwd6
	.long	w5dfcr1,w5dfcr2,w5dfcr3,w5dfcr4,w5dfcr5,w5dfcr6,w5drcr1,w5drcr2,w5drcr3
	.long	w5drcr4,w5drcr5,w5drcr6,w5fgrl1,w5fgrl2,w5fgrl3,w5fgrl4
	.long	w3drcr1,w3drcr2,w3drcr3,w3drcr4,w4drcr1,w4drcr2,w4drcr3,w4drcr4
	.long	w4drcr5
	.long	w2push1,w2push2,w2push3,w2push4,w4push1,w4push2,w4push3,w1pikup1
	.long	w1pikup2,w1pikup3,w2pikup1,w2pikup2,w2pikup3,w3pikup1,w3pikup2,w3pikup3
	.long	w1reb2,w1reb1,w1reb3,w1reb4,w1reb5,w1sway1
	.long	w1sway2,w1sway3,w1sway4,w1sway5,w2cow,w2elbo1,w2elbo2,w2elbo3,w2elbo4
	.long	w2elbo5,w2fall1,w2fall10,w2fall11,w2fall12,w2fall13,w2fall14,w2fall15
	.long	w2fall16,w2fall2,w2fall3,w2fall4,w2fall5,w2fall6,w2fall7,w2fall8
	.long	w2fall9
	.long	w2reb1,w2reb2,w2reb3,w2reb4,w2reb5,w2reb6,w2reb7,w2sway1,w2sway2
	.long	w2sway3,w2sway4,w2sway5,w3fall1,w3fall2,w3fall3,w3fall4,w3fall5,w3fall6
	.long	w3fall7,w3fall8
	.long	w3reb1,w3reb2,w3reb3,w3reb4,w3reb5,w3sway1,w3sway2,w3sway3,w3sway4
	.long	w3sway5,w3tip1,w3tip2,w3tip3,w3tip4,w3tip5,w3tip6,w3tip7,w4cel1,w4cel2
	.long	w4cel3,w4cow,w4elbo1,w4elbo2,w4elbo3,w4elbo4,w4elbo5,w4elbo6,w4elbo7
	.long	w4fall1,w4fall10,w4fall11,w4fall12,w4fall13,w4fall14,w4fall15,w4fall16
	.long	w4fall17,w4fall18,w4fall2,w4fall3,w4fall4,w4fall5,w4fall6,w4fall7
	.long	w4fall8,w4fall9,w4pikup1,w4pikup2,w4pikup3
	.long	w4reb1,w4reb2,w4reb3,w4reb4,w4reb5,w4reb6,w4sway1,w4sway2,w4sway3
	.long	w4sway4,w4sway5,w5pikup1,w5pikup2,w5pikup3,w5sway2,w5sway3,w5sway4
	.long	w5sway5
	.long	w2stwbl,w3desp1,w3desp2,w3desp3,w3desp4,w3desp5,w3desp6,w3stwbl,w4stwbl
	.long	w5stwbl,w3rej1,w3rej2,w3rej3
	.long	w3rej4,w3rej5,w3rej6,w3rej7,w3rej8,w3rej9,w2rej1,w2rej2,w2rej3,w2rej4
	.long	w2rej5,w2rej6,w2rej7,w2rej8,w2rej9,w3dish1,w3dish2,w3dish3,w3dish4L
debug_img_end
	.long	w3dish4R

	.endif


	.end

