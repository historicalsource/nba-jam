**************************************************************
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		9/17/92
*
* Modified:		Mark Turmell, 1/6/93	-Split from PLYR.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/23/93 15:13
**************************************************************
	.file	"plyr3.asm"
	.title	"basketball player code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"audit.equ"
	.include	"mac2.asm"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"bgndtbl.glo"
	.include	"game.equ"
	.include	"shawn.hdr"		;Macros
	.asg		0,SEQT
	.include	"plyr.equ"
;	.include	"frame.tbl"
;	.include	"card.tbl"
	.include	"plyrhd2.tbl"
	.include	"imgtblm.glo"
	.include	"imgtbl3.glo"
	.include	"plyrhd3.tbl"
	.include	"dipequ.asm"

;sounds external

tunehalf_snd	.word	>f3ff,>8,>8004,0	;Half time tune
report_snd	.word	>f981,1*60,>8171,1	;Halftime report
altitude_snd	.word	>f981,30,>81cc,0	;Altitude
cheer1_snd	.word	>fd84,100,>8111,0	;Long cheer
cheer2_snd	.word	>f894,100,>8144,0	;Long cheer

;symbols externally defined

	.ref	BAKMODS,BGND_UD1
	.ref	snd_play1ovr
	.ref	IRQSKYE
	.ref	dpageflip
	.ref	GAMSTATE
	.ref	COLCYC
	.ref	system_savegame,system_restoregame
	.ref	tvpanelon
	.ref	RNDRNG0
	.ref	READ_DIP

	.ref	scale63_t

	.ref	pal_getf


;symbols defined in this file
;	.def	card_v

;uninitialized ram definitions

;	.bss	cycram		,9*16
;	.bss	clipbits	,32	;Bit set for each clip # shown
;
;	BSSX	clipsrunning	,32

;equates for this file


	.text

#*******************************
* Show halftime intro and clips (JSRP)


CLIPTEST	.equ	0

 SUBR	halftime_showclips


	movi	4*60,a10

#stop	SLEEPK	1
	subk	1,a10
	jrle	#tvout
	move	@tvpanelon,a0,L
	jrnz	#stop
#tvout

	RETP

;
	.if	0

	jruc	#x			;Skip clips for ROMKIT

	calla	READ_DIP
	btst	DPNOVIDCLIPS_B,a0
	jrnz	#x			;Clips off?


	calla	system_savegame

	movi	>12345678,a0
	move	a0,@clipsrunning,L


	movk	INPLYRINFO,a0
	move	a0,@GAMSTATE

	clr	a0
	move	a0,@dtype		;2D

	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	JSRP	scrn_scaleininit

	movi	half_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1
	SLEEPK	2

	JSRP	scrn_scalein

	movi	4<<10+4<<5+4,a0
	move	a0,@IRQSKYE		;background color


	CREATE0	plyr_jscrowdsnda

	SLEEPK	10

	SOUND1	report_snd

	movi	-1,a0
	move	a0,@dpageflip		;No erasure

#test
	movk	2,a5			;# clips to show
	clr	a6
#lp
	move	a6,a0
	addk	1,a6
	sll	5,a0
	addi	#xy_t,a0
	move	*a0+,a10,L		;XY

	move	@clipbits,a2,L
	cmpi	>3ffff,a2		;18 bits
	jrlo	#ok
	clr	a2
#ok
#crlp	movk	18-1,a0			;Total # clips
	calla	RNDRNG0
	btst	a0,a2
	jrnz	#crlp			;Have already shown?

	movk	1,a14			;Set bit
	sll	a0,a14
	or	a14,a2
	move	a2,@clipbits,L

	.if	CLIPTEST
	clr	a0
	.endif

	sll	5,a0
	addi	#mv_t,a0
	move	*a0,a8,L

	clr	a9
	PUSHP	a5,a6
	PUSHP	a8

	move	a10,a0
	sll	32-12,a0
	srl	7,a0			;X
	move	a10,a1
	srl	12,a1
	sll	16,a1			;Y
	movi	scobars,a2
	movi	500,a3			;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	SLEEPK	30
	calla	DELOBJA8

	PULLP	a8
	PUSHP	a10

	.ref	movie_run

	JSRP	movie_run
	PULLP	a10

	PULLP	a5,a6

	dsj	a5,#lp

	.if	CLIPTEST
	jruc	#test			;Infinite loop
	.endif

	movi	TSEC*1+30,a10
#butlp
	SLEEPK	1
	.ref	get_all_buttons_cur
	calla	get_all_buttons_cur
	move	a0,a0
	jrnz	#exit1
	dsj	a10,#butlp
#exit1

	calla	display_blank

	clr	a0
	move	a0,@clipsrunning,L

	calla	system_restoregame

#x	RETP


plyr_jscrowdsnda
	CREATE0	scrms
	SLEEP	40
	movi	cheer1_snd,a0
	calla	snd_play1
	movi	cheer2_snd,a0
	calla	snd_play1
	SLEEP	35
	movi	cheer1_snd,a0
	calla	snd_play1ovr
	movi	cheer2_snd,a0
	calla	snd_play1ovr
	SLEEP	24
	movi	cheer1_snd,a0
	calla	snd_play1ovr
	movi	cheer2_snd,a0
	calla	snd_play1ovr
;	SLEEP	12
;	movi	cheer1_snd,a0
;	calla	snd_play1ovr
;	movi	cheer2_snd,a0
;	calla	snd_play1ovr
	DIE

scrms	movi	scrm1_snd,a0
	calla	snd_play1ovr
	SLEEP	15
	movi	scrm2_snd,a0
	calla	snd_play1ovr
	SLEEP	15
	movi	scrm3_snd,a0
	calla	snd_play1ovr
	SLEEP	15
	movi	scrm4_snd,a0
	calla	snd_play1ovr
	SLEEP	15
	DIE

	.ref	scrm1_snd,scrm2_snd,scrm3_snd,scrm4_snd


half_mod
	.long	htclipsBMOD
	.word	0,0
	.long	0

#xy_t	.long	(88+52*512)*8
;	.long	(212+52*512)*8
;	.long	(88+140*512)*8
	.long	(212+140*512)*8
#mv_t
	.long	V4C_F
	.long	V5C_F
	.long	V6C_F
	.long	V8C_F
	.long	V10C_F
	.long	V11C_F
	.long	V13C_F
	.long	V14C_F
	.long	V15C_F
	.long	V17C_F
	.long	V18C_F
	.long	V19C_F
	.long	V20C_F
	.long	V22C_F
	.long	V23C_F
	.long	VNEW2_F
	.long	V1C_F
	.long	V3C_F

;	.long	V7C_F
;	.long	VNEW1_F


	.endif


#*******************************
* Smoke trail (Process)
* A8=*Src obj
* A10=*Plyr process

 SUBR	plyr_smoketrail

	movk	15,a11
#lp	CREATE0	plyr_smokepuff
	SLEEPK	4
	dsj	a11,#lp

	DIE

#*******************************
* Smoke trail (Process)
* A8=*Src obj
* A10=*Plyr process

 SUBR	plyr_smoketrail2

	movk	20,a11
#lp	CREATE0	plyr_smokepuff
	SLEEPK	1
	dsj	a11,#lp

	DIE


#*******************************
* Smoke trail puff (Process)
* A8=*Src obj
* A10=*Plyr process

 SUBRP	plyr_smokepuff

	move	*a10(plyr_dir),a10
	srl	2,a10

	move	*a8(OZPOS),a3
	movk	3,a0
	callr	rnd
	subk	2,a0
	add	a0,a3			;-2 to 1

	movk	3,a0
	callr	rnd
	sll	5,a0			;*32
	addi	smoke_t,a0
	move	*a0,a9,L

	move	*a8(OXVEL),a6,L
	move	*a8(OYVEL),a7,L
	sra	2,a6			;/4
	sra	2,a7

	move	*a8(OXPOS),a0
	move	*a8(OSIZEX),a2
	srl	1,a2			;/2
	add	a2,a0
	move	*a8(OYPOS),a1
	move	*a8(OSIZEY),a2
	srl	1,a2			;/2
	add	a2,a1
	sll	4,a10			;*16
	addi	mslstxy_t,a10
	move	*a10(8*16),a2
	add	a2,a0			;+X offset
	move	*a10,a2
	add	a2,a1			;+YO
	sll	16,a0			;X
	sll	16,a1			;Y
	movi	CLDB1ORNG,a2
	movi	DMAWNZ|M_3D|M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5
	calla	BEGINOBJ2
	movi	scale50_t,a0
	move	a0,*a8(ODATA_p),L
	SLEEPK	3
	jauc	FRQDELDIE

mslstxy_t
	.word	12,12,11,10,8,6,3,1		;Y
	.word	0,-1,-3,-6,-8,-10,-11,-12	;X
	.word	-12,-12,-11,-10,-8,-6,-3,-1
	.word	0,1,3,6,8,10,11,12
	.word	12,12,11,10,8,6,3,1


#*******************************
* Smoke trail (Process)
* A8=*Src obj
;* A10=*Plyr process

; SUBR	ball_smoketrail
;
;	movi	8000,a11
;#lp	CREATE0	ball_smokepuff
;	SLEEPK	2
;	dsj	a11,#lp
;	DIE


#*******************************
* Start sparks in AMODE

 SUBR	do_ball_spark

	movi	45,a11
#lp	CREATE0	ball_spark
	SLEEPK	4
	dsj	a11,#lp
	DIE


#*******************************
* Smoke trail puff (Process)
* A8=*Src obj
* A10=*Plyr process

 SUBR	ball_smokepuff

	move	a8,a11

;	move	@HCOUNT,a0
;;	sll	32-1,a0
;	ANDK	1,a0
;	jrnz	#nosprk
;	CREATE0	ball_spark
;#nosprk
	move	*a8(OZPOS),a3
	movk	3,a0
	callr	rnd
	subk	2,a0
	add	a0,a3			;-2 to 1

	movk	3,a0
	callr	rnd
	sll	5,a0			;*32
	addi	smoke_t,a0
	move	*a0,a9,L

	move	*a8(OXVEL),a6,L
	move	*a8(OYVEL),a7,L
	sra	2,a6			;/4
	sra	2,a7

	move	*a8(OXPOS),a0
	move	*a8(OSIZEX),a2
	srl	1,a2			;/2
	add	a2,a0
	move	*a8(OXANI+16),a2
	add	a2,a0
	move	*a8(OYPOS),a1
	move	*a8(OSIZEY),a2
	srl	1,a2			;/2
	add	a2,a1
	addk	15,a1
;	sll	4,a10			;*16
;	addi	mslstxy_t,a10
;	move	*a10(8*16),a2
;	add	a2,a0			;+X offset
;	move	*a10,a2
;	add	a2,a1			;+YO
	sll	16,a0			;X
	sll	16,a1			;Y
	movi	CLDB1YELL,a2
	movi	DMAWNZ|M_3D|M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5
	calla	BEGINOBJ2

	movi	scale50_t,a0
	move	a0,*a8(ODATA_p),L
	move	*a11(OZVEL),a0,L
	sra	2,a0			;/4
	move	a0,*a8(OZVEL),L


	move	*a8(OZPOS),a14		;894 to 1379 (Z range 486)
	subi	GZBASE,a14		;-Base
	jrge	#zok
	clr	a14
#zok	srl	4,a14			;/16
	sll	6,a14			;*64
	move	*a8(ODATA_p),a0,L
	addk	32,a0
	add	a14,a0

	move	*a0+,a14
	sll	4,a14			;*16
	move	*a8(OIMG),a2,L

	move	*a2(IANIOFFX),a1
	mpys	a14,a1
	move	a1,*a8(OXANI),L
	move	*a0,a14
	sll	4,a14			;*16
	move	a1,a0

	move	*a2(IANIOFFY),a1
	mpys	a14,a1

	sra	16,a0
	sra	16,a1
	neg	a0
	neg	a1

	move	*a11(OXPOS),a14
	add	a14,a0
	move	*a11(OSIZEX),a2
	srl	1,a2			;/2
	add	a2,a0
;	move	*a11(OXANI+16),a2
;	add	a2,a0
	move	*a11(OYPOS),a14
	add	a14,a1
	move	*a11(OSIZEY),a2
	srl	1,a2			;/2
	add	a2,a1
	move	a0,*a8(OXPOS)
	move	a1,*a8(OYPOS)


;	SLEEPK	2
;	jauc	FRQDELDIE



	move	*a9+,a0,L
#alp	move	*a8(OCTRL),a1
	calla	obj_aniq_scld
	move	*a9+,a0
	cmpi	>100,a0
	jrlo	#slp			;No flags?
	move	a0,a2
	move	*a9+,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)
	move	a2,a0
	sll	32-8,a0
	srl	32-8,a0
#slp
	calla	PRCSLP
	move	*a9+,a0,L
	jrnz	#alp
	jauc	DELOBJDIE


smoke_t
	.long	cldbw_l,cldblg_l,cldbgry_l,cldblg2_l

cldbw_l
	LW	CLDB2,3
	LWL	CLDB3,NEWPALET|3,ORNGPAL
	LW	CLDB4,2
	LWL	CLD5,NEWPALET|2,WHTPAL
	LW	CLD6,2
	LW	CLD7,2
	LW	CLD8,2
	LW	CLD9,2
	LW	CLD10,2
	LWL0	CLD11,2
cldblg_l
	LW	CLDB2,2
	LWL	CLDB3,NEWPALET|3,ORNGPAL
	LW	CLDB4,2
	LWL	CLD5,NEWPALET|2,LGRYPAL
	LW	CLD6,2
	LW	CLD7,2
	LW	CLD8,2
	LW	CLD9,2
	LW	CLD10,2
	LWL0	CLD11,1
cldbgry_l
	LW	CLDB2,3
	LWL	CLDB3,NEWPALET|2,ORNGPAL
	LW	CLDB4,2
	LWL	CLD5,NEWPALET|2,GREYPAL
	LW	CLD6,2
	LW	CLD7,2
	LW	CLD8,2
	LW	CLD9,1
	LW	CLD10,1
	LWL0	CLD11,1
cldblg2_l
	LW	CLDB2,2
	LWL	CLDB3,NEWPALET|2,ORNGPAL
	LWL	CLDB4,NEWPALET|2,LGRYPAL
	LW	CLD5,2
	LW	CLD6,2
	LW	CLD7,2
	LW	CLD8,2
	LW	CLD9,2
	LW	CLD10,2
	LWL0	CLD11,2



SCLT	.macro	sx,sy,sxa,sya
	.eval	:sx:*1048,X	;Convert (has slight error)
	.eval	:sy:*1048,Y
	.eval	:sxa:*1048,XA
	.eval	:sya:*1048,YA
	.loop	10
	.word	>10000000/X,>10000000/Y
	.word	>100000/(>10000000/X),>100000/(>10000000/Y)
	.eval	X+XA*1/4,X
	.eval	Y+YA*1/4,Y
	.endloop
	.loop	10
	.word	>10000000/X,>10000000/Y
	.word	>100000/(>10000000/X),>100000/(>10000000/Y)
	.eval	X+XA*2/4,X
	.eval	Y+YA*2/4,Y
	.endloop
	.loop	10
	.word	>10000000/X,>10000000/Y
	.word	>100000/(>10000000/X),>100000/(>10000000/Y)
	.eval	X+XA*3/4,X
	.eval	Y+YA*3/4,Y
	.endloop
	.loop	10
	.word	>10000000/X,>10000000/Y
	.word	>100000/(>10000000/X),>100000/(>10000000/Y)
	.eval	X+XA,X
	.eval	Y+YA,Y
	.endloop
	.endm

				;>Generate scale tables
scale30_t
	SCLT	300,300,19,19
scale50_t
	SCLT	500,500,31,31


********************************
* Spark from flaming ball (Process)
* A8/A11=*Ball obj

 SUBR	ball_spark

	movi	spark_l,a9

	move	*a11(OXVEL),a6,L
	sra	2,a6
	movk	>a,a0
	callr	rnd
	subk	5,a0
	sll	14,a0			;XVel
	add	a0,a6

;	movk	3,a0
;	callr	rnd
;	jrnz	#xnorm
;	sll	2,a6			;*4
#xnorm

	move	*a11(OYVEL),a7,L
	movk	>3,a0
	callr	rnd
	sll	16,a0			;YVel
	neg	a0
	add	a0,a7


;	move	*a11(OYVEL),a7,L
;	sra	2,a7
;	movk	>a,a0
;	callr	rnd
;	subk	5,a0
;	sll	15,a0			;YVel
;	add	a0,a7
;	neg	a7




;	movk	3,a0
;	callr	rnd
;	jrnz	#ynorm
;	sll	2,a7			;*4
#ynorm
	move	*a8(OZPOS),a3
	movk	3,a0
	callr	rnd
	subk	2,a0
	add	a0,a3			;-2 to 1

	move	*a8(OXPOS),a0
;	move	*a8(OSIZEX),a2
;	srl	1,a2			;/2
;	add	a2,a0
	move	*a8(OXANI+16),a2
	add	a2,a0
	move	*a8(OYPOS),a1
	move	*a8(OSIZEY),a2
	srl	1,a2			;/2
	add	a2,a1

	sll	16,a0
	sll	16,a1
	movi	spark1,a2
	movi	DMAWNZ|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	calla	BEGINOBJ2

	move	*a11(OZVEL),a2,L
	sra	2,a2			;/4
	movk	>f,a0
	callr	rnd
	subk	7,a0
	sll	14,a0
	add	a0,a2
	move	a2,*a8(OZVEL),L


	movk	3,a11
;	callr	rnd
;	addk	1,a0
;	move	a0,a11
	jruc	#strt

#lp	dsj	a10,#noani
#strt
	move	a11,a10
	move	*a9,a0,L
	jrz	#die			;noani
	addk	32,a9

	move	*a8(OCTRL),a1
	calla	obj_aniq
#noani
	SLEEPK	3
	move	*a8(OYVEL),a2,L
	addi	GRAV*2,a2
	move	a2,*a8(OYVEL),L
	jrn	#lp			;Going up?
	move	*a8(OYVAL),a1,L
	jrlt	#lp			;Above gnd?
	clr	a1
	move	a1,*a8(OYVAL),L

;	move	@HCOUNT,a14
;	sll	32-2,a14
;	jrz	#die
;	neg	a2
;	sra	3,a2
;	move	a2,*a8(OYVEL),L
;	cmpi	-(GRAV*2),a2
;	jrlt	#lp
;

#die
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OZVEL),L
;	SLEEPK	4

	jauc	DELOBJDIE


spark_l
	.long	spark1
	.long	spark2
	.long	spark3
	.long	spark4
	.long	spark5
	.long	spark1
	.long	spark2
	.long	spark3
	.long	spark4
	.long	spark5
	.long	spark1
	.long	spark2
	.long	spark3
	.long	spark4
	.long	spark5,0

;	.endif

;	movi	STATIC_p,a8
;	movi	cycram,a9
;	movi	[1,62],a10		;1st,last color
;	movk	5,a11			;Rate
;	CREATE	CYCPID,COLCYC


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

#*******************************

 SUBR	getdunkseq


	move	*a13(plyr_num),a0	;If on fire, don't use turbo on run
	.ref	plyrnumonfire
	move	@plyrnumonfire,a1
	cmp	a0,a1
	jrz	set5

	move	*a13(plyr_attrib_p),a0,L
	move	*a0(PAT_DUNKSKILL),a0


;TEST
;MJT - Take out
;	movk 	9,a0

	sll	5,a0
	addi	jmp_t,a0
	move	*a0,a0,L
	jump	a0


jmp_t	.long	set1,set1,set1,set2
	.long	set2,set3,set4,set4,set5,set5,set5

set5
	addi	d5u_t,a3

	cmpi	60,a4
	jrle	#shortd			;Under hoop?
	addi	d5s_t-d5u_t,a3

	cmpi	80,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d5m_t-d5s_t,a3,W

	cmpi	120,a4			;Med range
	jrle	#shortd
	addi	d5l_t-d5m_t,a3,W
	jruc	#shortd

;
set4
	addi	d4u_t,a3

	cmpi	60,a4
	jrle	#shortd			;Under hoop?
	addi	d4s_t-d4u_t,a3

	cmpi	80,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d4m_t-d4s_t,a3,W

	cmpi	120,a4			;Med range
	jrle	#shortd
	addi	d4l_t-d4m_t,a3,W
	jruc	#shortd

;
set3
	addi	d3u_t,a3

	cmpi	60,a4
	jrle	#shortd			;Under hoop?
	addi	d3s_t-d3u_t,a3

	cmpi	80,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d3m_t-d3s_t,a3,W

	cmpi	120,a4			;Med range
	jrle	#shortd
	addi	d3l_t-d3m_t,a3,W
	jruc	#shortd

;
set2
	addi	d3u_t,a3

	cmpi	60,a4
	jrle	#shortd			;Under hoop?
	addi	d2s_t-d2u_t,a3

	cmpi	80,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d2m_t-d2s_t,a3,W

	cmpi	120,a4			;Med range
	jrle	#shortd
	addi	d2l_t-d2m_t,a3,W
	jruc	#shortd

;
set1
	addi	d1u_t,a3

	cmpi	60,a4
	jrle	#shortd			;Under hoop?
	addi	d1s_t-d1u_t,a3

	cmpi	80,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d1m_t-d1s_t,a3,W

	cmpi	110,a4			;Med range
	jrle	#shortd

	addi	d1l_t-d1m_t,a3,W


#shortd	clr	a0
	rets
#sj	movk	1,a0
	rets

#****************************************************************************


;Set of dunks for #5 skill players

d5u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d5s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d5m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d5l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t

;Dunks from under hoop
#d1u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d2u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d3u_t	.word	4-1,DUNKB2_SEQ,DUNKZ7_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d4u_t	.word	2-1,DUNKG2_SEQ,DUNKZ7_SEQ
#d5u_t	.word	1-1,DUNKN2_SEQ

;List of dunks that can happen in these dirs if plyr is near hoop
#d1s_t	.word	13-1,DUNKB_SEQ,DUNKJ_SEQ,DUNKJ2_SEQ,DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKT_SEQ
	.word	DUNKV_SEQ
	.word	DUNKV2_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d2s_t	.word	19-1,DUNKB_SEQ,DUNKF_SEQ,DUNKT_SEQ,DUNKO_SEQ
	.word	DUNKJ2_SEQ,DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKS_SEQ
	.word	DUNKS2_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKW2_SEQ
	.word	DUNKW_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d3s_t	.word	12-1,DUNKP_SEQ,DUNKB_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKT_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKU_SEQ
	.word	DUNKLAY7_SEQ

#d4s_t	.word	8-1,DUNKP_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ,DUNKT_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ

#d5s_t	.word	4-1,DUNKN_SEQ,DUNKN_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ

;List of dunks that can happen in these dirs if plyr is med dist from hoop
#d1m_t	.word	14-1,DUNKA_SEQ,DUNKB_SEQ,DUNKJ_SEQ,DUNKJ2_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKV_SEQ
	.word	DUNKV2_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d2m_t	.word	44-1,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ,DUNKO_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKK_SEQ,DUNKK2_SEQ,DUNKJ2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKT4_SEQ
	.word	DUNKT5_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ
	.word	DUNKJ2_SEQ,DUNKO2_SEQ,DUNKK_SEQ,DUNKK2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKW2_SEQ
	.word	DUNKW_SEQ
	.word	DUNKY_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKZ3_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY7_SEQ

#d3m_t	.word	60-1,DUNKB_SEQ,DUNKC_SEQ,DUNKE_SEQ,DUNKE2_SEQ
	.word	DUNKZ8_SEQ
	.word	DUNKZ8_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKL_SEQ,DUNKL4_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKT4_SEQ
	.word	DUNKT5_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKP_SEQ,DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKT_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKL_SEQ,DUNKL2_SEQ,DUNKL3_SEQ,DUNKL4_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKP3_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKU_SEQ
	.word	DUNKU2_SEQ
	.word	DUNKU3_SEQ
	.word	DUNKU4_SEQ
	.word	DUNKU5_SEQ
	.word	DUNKU6_SEQ
	.word	DUNKX_SEQ
	.word	DUNKX2_SEQ
	.word	DUNKX3_SEQ
	.word	DUNKY_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKZ3_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY7_SEQ

#d4m_t	.word	24-1,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKZ8_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKP2_SEQ,DUNKP_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKT4_SEQ
	.word	DUNKT5_SEQ
	.word	DUNKD_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKD2_SEQ
	.word	DUNKP_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKY_SEQ
	.word	DUNKY2_SEQ

#d5m_t	.word	4-1,DUNKN_SEQ,DUNKN_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ

;List of dunks that can happen in these dirs if plyr is far away from hoop
#d1l_t	.word	3-1
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKZ4_SEQ

#d2l_t
	.word	29-1
	.word	DUNKZ9_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ
	.word	DUNKJ2_SEQ,DUNKO2_SEQ,DUNKK_SEQ,DUNKK2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT5_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKW2_SEQ
	.word	DUNKW_SEQ
	.word	DUNKY_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKZ3_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d3l_t	.word	46-1
	.word	DUNKZ8_SEQ
	.word	DUNKZ9_SEQ
	.word	DUNKZ9_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ11_SEQ
	.word	DUNKZ11_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKP_SEQ,DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKL_SEQ,DUNKL2_SEQ,DUNKL3_SEQ,DUNKL4_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKP3_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT5_SEQ
	.word	DUNKU2_SEQ
	.word	DUNKU3_SEQ
	.word	DUNKU4_SEQ
	.word	DUNKU5_SEQ
	.word	DUNKU6_SEQ
	.word	DUNKX_SEQ
	.word	DUNKX2_SEQ
	.word	DUNKX3_SEQ
	.word	DUNKY_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKZ3_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY7_SEQ

#d4l_t	.word	15-1
	.word	DUNKZ8_SEQ
	.word	DUNKZ9_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKD_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKD2_SEQ
	.word	DUNKP_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT5_SEQ
	.word	DUNKY_SEQ
	.word	DUNKY2_SEQ

#d5l_t	.word	1-1
	.word	DUNKLAY_SEQ


#****************************************************************************
;Set of dunks for #4 skill players

d4u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d4s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d4m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d4l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t

;Dunks from under hoop
#d1u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d2u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d3u_t	.word	4-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKZ7_SEQ,DUNKB3_SEQ
#d4u_t	.word	2-1,DUNKG2_SEQ,DUNKZ7_SEQ
#d5u_t	.word	1-1,DUNKN2_SEQ

;List of dunks that can happen in these dirs if plyr is near hoop
#d1s_t	.word	13-1,DUNKB_SEQ,DUNKJ_SEQ,DUNKJ2_SEQ,DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKT_SEQ
	.word	DUNKV_SEQ
	.word	DUNKV2_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d2s_t	.word	20-1,DUNKB_SEQ,DUNKF_SEQ,DUNKT_SEQ,DUNKO_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKJ2_SEQ,DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKS_SEQ
	.word	DUNKS2_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKW2_SEQ
	.word	DUNKW_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d3s_t	.word	17-1,DUNKP_SEQ,DUNKB_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKT_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKU_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKLAY7_SEQ

#d4s_t	.word	9-1,DUNKP_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ,DUNKT_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKLAY_SEQ

#d5s_t	.word	3-1,DUNKN_SEQ,DUNKN_SEQ
	.word	DUNKLAY_SEQ

;List of dunks that can happen in these dirs if plyr is med dist from hoop
#d1m_t	.word	16-1,DUNKA_SEQ,DUNKB_SEQ,DUNKJ_SEQ,DUNKJ2_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKV_SEQ
	.word	DUNKV2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d2m_t	.word	40-1,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ,DUNKO_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKK_SEQ,DUNKK2_SEQ,DUNKJ2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ
	.word	DUNKJ2_SEQ,DUNKO2_SEQ,DUNKK_SEQ,DUNKK2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKW2_SEQ
	.word	DUNKW_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKZ3_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d3m_t	.word	53-1,DUNKB_SEQ,DUNKC_SEQ,DUNKE_SEQ,DUNKE2_SEQ
	.word	DUNKZ8_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKL_SEQ,DUNKL4_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKP_SEQ,DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKT_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKL_SEQ,DUNKL2_SEQ,DUNKL3_SEQ,DUNKL4_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKP3_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKU_SEQ
	.word	DUNKU2_SEQ
	.word	DUNKU3_SEQ
	.word	DUNKU4_SEQ
	.word	DUNKU5_SEQ
	.word	DUNKU6_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKZ3_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY7_SEQ

#d4m_t	.word	22-1,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKZ8_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKP2_SEQ,DUNKP_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKD_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKD2_SEQ
	.word	DUNKP_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKLAY_SEQ

#d5m_t	.word	3-1,DUNKN_SEQ,DUNKN_SEQ
	.word	DUNKLAY_SEQ

;List of dunks that can happen in these dirs if plyr is far away from hoop
#d1l_t	.word	5-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d2l_t
	.word	29-1
	.word	DUNKZ9_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ
	.word	DUNKJ2_SEQ,DUNKO2_SEQ,DUNKK_SEQ,DUNKK2_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKW2_SEQ
	.word	DUNKW_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKZ3_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d3l_t	.word	43-1
	.word	DUNKZ8_SEQ
	.word	DUNKZ9_SEQ
	.word	DUNKZ9_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ11_SEQ
	.word	DUNKZ11_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKP_SEQ,DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKE_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKL_SEQ,DUNKL2_SEQ,DUNKL3_SEQ,DUNKL4_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKP3_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKU2_SEQ
	.word	DUNKU3_SEQ
	.word	DUNKU4_SEQ
	.word	DUNKU5_SEQ
	.word	DUNKU6_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKZ3_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY7_SEQ

#d4l_t	.word	14-1
	.word	DUNKZ8_SEQ
	.word	DUNKZ9_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKD_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKD2_SEQ
	.word	DUNKP_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKY2_SEQ
	.word	DUNKLAY_SEQ

#d5l_t	.word	1-1
	.word	DUNKLAY_SEQ


#****************************************************************************
;Set of dunks for #3 skill players

d3u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d3s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d3m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d3l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t


;Dunks from under hoop
#d1u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d2u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d3u_t	.word	4-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKZ7_SEQ,DUNKB3_SEQ
#d4u_t	.word	2-1,DUNKG2_SEQ,DUNKZ7_SEQ
#d5u_t	.word	1-1,DUNKN2_SEQ

;List of dunks that can happen in these dirs if plyr is near hoop
#d1s_t	.word	16-1,DUNKB_SEQ,DUNKJ_SEQ,DUNKJ2_SEQ,DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKT_SEQ
	.word	DUNKV_SEQ
	.word	DUNKV2_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d2s_t	.word	18-1,DUNKB_SEQ,DUNKF_SEQ,DUNKT_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKJ2_SEQ,DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKS_SEQ
	.word	DUNKS2_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY6_SEQ

#d3s_t	.word	13-1,DUNKB_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKT_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKU_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKLAY3_SEQ

#d4s_t	.word	6-1,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ,DUNKT_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKLAY_SEQ

#d5s_t	.word	3-1,DUNKN_SEQ,DUNKN_SEQ
	.word	DUNKLAY_SEQ

;List of dunks that can happen in these dirs if plyr is med dist from hoop
#d1m_t	.word	17-1,DUNKA_SEQ,DUNKB_SEQ,DUNKJ_SEQ,DUNKJ2_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKV_SEQ
	.word	DUNKV2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ

#d2m_t	.word	36-1,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKK_SEQ,DUNKK2_SEQ,DUNKJ2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ
	.word	DUNKJ2_SEQ,DUNKK_SEQ,DUNKK2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ

#d3m_t	.word	42-1,DUNKB_SEQ,DUNKC_SEQ,DUNKE_SEQ,DUNKE2_SEQ
	.word	DUNKZ8_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKL_SEQ,DUNKL4_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKT_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKL_SEQ,DUNKL2_SEQ,DUNKL3_SEQ,DUNKL4_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKU_SEQ
	.word	DUNKU6_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY3_SEQ

#d4m_t	.word	16-1,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKZ8_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKD_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKD2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKLAY_SEQ

#d5m_t	.word	3-1,DUNKN_SEQ,DUNKN_SEQ
	.word	DUNKLAY_SEQ

;List of dunks that can happen in these dirs if plyr is far away from hoop
#d1l_t	.word	5-1
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKZ4_SEQ

#d2l_t
	.word	24-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ
	.word	DUNKJ2_SEQ,DUNKK_SEQ,DUNKK2_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKJ_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ

#d3l_t	.word	31-1
	.word	DUNKZ8_SEQ
	.word	DUNKZ10_SEQ
	.word	DUNKZ11_SEQ
	.word	DUNKZ11_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKL_SEQ,DUNKL2_SEQ,DUNKL3_SEQ,DUNKL4_SEQ
	.word	DUNKP3_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKU6_SEQ
	.word	DUNKZ_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ

#d4l_t	.word	10-1
	.word	DUNKZ8_SEQ
	.word	DUNKZ6_SEQ
	.word	DUNKD_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKD2_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKLAY_SEQ

#d5l_t	.word	1-1
	.word	DUNKLAY_SEQ

#****************************************************************************
;Set of dunks for #2 skill players

d2u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d2s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d2m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d2l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t


;Dunks from under hoop
#d1u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d2u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d3u_t	.word	4-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKZ7_SEQ,DUNKB3_SEQ
#d4u_t	.word	2-1,DUNKG2_SEQ,DUNKZ7_SEQ
#d5u_t	.word	1-1,DUNKN2_SEQ

;List of dunks that can happen in these dirs if plyr is near hoop
#d1s_t	.word	11-1,DUNKB_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKT_SEQ
	.word	DUNKV_SEQ
	.word	DUNKV2_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ

#d2s_t	.word	13-1,DUNKB_SEQ,DUNKF_SEQ,DUNKT_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKS_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ

#d3s_t	.word	11-1,DUNKB_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKT_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ

#d4s_t	.word	6-1,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ,DUNKT_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKLAY_SEQ

#d5s_t	.word	3-1,DUNKN_SEQ,DUNKN_SEQ
	.word	DUNKLAY_SEQ

;List of dunks that can happen in these dirs if plyr is med dist from hoop
#d1m_t	.word	12-1,DUNKA_SEQ,DUNKB_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKV_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKV2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ

#d2m_t	.word	24-1,DUNKB_SEQ,DUNKF_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKK_SEQ,DUNKK2_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ
	.word	DUNKK_SEQ,DUNKK2_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY6_SEQ

#d3m_t	.word	26-1,DUNKB_SEQ,DUNKC_SEQ,DUNKE_SEQ,DUNKE2_SEQ
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKT_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY3_SEQ

#d4m_t	.word	10-1,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKD_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKD2_SEQ
	.word	DUNKLAY_SEQ

#d5m_t	.word	3-1,DUNKN_SEQ,DUNKN_SEQ
	.word	DUNKLAY_SEQ

;List of dunks that can happen in these dirs if plyr is far away from hoop
#d1l_t	.word	5-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY7_SEQ

#d2l_t
	.word	14-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ
	.word	DUNKK_SEQ,DUNKK2_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKLAY6_SEQ

#d3l_t	.word	18-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKA2_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKK_SEQ
	.word	DUNKK2_SEQ
	.word	DUNKZ2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ

#d4l_t	.word	7-1
	.word	DUNKD_SEQ,DUNKE_SEQ,DUNKE2_SEQ,DUNKG_SEQ
	.word	DUNKD2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ

#d5l_t	.word	1-1
	.word	DUNKLAY_SEQ



#****************************************************************************
;Set of dunks for #1 skill players

d1u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d1s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d1m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d1l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t

;Dunks from under hoop
#d1u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d2u_t	.word	3-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKB3_SEQ
#d3u_t	.word	4-1,DUNKB2_SEQ,DUNKZ5_SEQ,DUNKZ7_SEQ,DUNKB3_SEQ
#d4u_t	.word	2-1,DUNKG2_SEQ,DUNKZ7_SEQ
#d5u_t	.word	1-1,DUNKN2_SEQ

;List of dunks that can happen in these dirs if plyr is near hoop
#d1s_t	.word	6-1
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY6_SEQ

#d2s_t	.word	8-1,DUNKF_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY6_SEQ

#d3s_t	.word	6-1
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY5_SEQ
	.word	DUNKB2_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ

#d4s_t	.word	5-1,DUNKG_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ

#d5s_t	.word	2-1
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ

;List of dunks that can happen in these dirs if plyr is med dist from hoop
#d1m_t	.word	6-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY2_SEQ

#d2m_t	.word	7-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY4_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY6_SEQ

#d3m_t	.word	6-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY5_SEQ

#d4m_t	.word	5-1,DUNKG_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ

#d5m_t	.word	1-1
	.word	DUNKLAY_SEQ


;List of dunks that can happen in these dirs if plyr is far away from hoop
#d1l_t	.word	4-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY6_SEQ

#d2l_t
	.word	7-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY6_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY2_SEQ
	.word	DUNKLAY4_SEQ

#d3l_t	.word	6-1
	.word	DUNKZ4_SEQ
	.word	DUNKLAY7_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY3A_SEQ
	.word	DUNKLAY3_SEQ
	.word	DUNKLAY5_SEQ

#d4l_t	.word	3-1
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ
	.word	DUNKLAY_SEQ

#d5l_t	.word	1-1
	.word	DUNKLAY_SEQ


;Small heads!

;	.def	Kemp_h,Pippen_h,Gill_h,Daughert_h,Mullin_h,Wilkins_h

	.def	Lohaus_h,Gug_h,Edwrd_h
	.def	McDan_h,Brown_h,KAnderson_h
	.def	Willis_h,Gamble_h,Mourn_h,Armstrng_h,Kukoc_h,Nance_h,Jack_h
	.def	Dumars_h,Rodman_h,Hunter_h,Webber_h,Maxwell_h,Horry_h,Smits_h
	.def	Roberts_h,Peeler_h,Campbell_h,Miner_h,Baker_h,Day_h
	.def	Mason_h,Starks_h,AHard_h,NAnders_h,Weath_h,Brad_h,KJohn_h
	.def	Hurley_h,Rich_h,DEllis_h,Payton_h,Mckey_h,Benoit_h,Ellison_h
	.def	Mash_h,Rogers_h,Cheaney_h,CRobin_h,Simmons_h,Rider_h,Morris_h
	.def	Sealy_h

Lohaus_h
	.long	Lohaus1
	.long	Lohaus1
	.long	Lohaus2,Lohaus3,Lohaus4,Lohaus5,Lohaus6,Lohaus7,Lohaus8,Lohaus9
	.long	Lohaus10,Lohaus11,Lohaus12,Lohaus13,Lohaus14,Lohaus15,Lohaus16
Gug_h
	.long	gug1
	.long	gug1,gug2,gug3,gug4,gug5,gug6,gug7,gug8
	.long	gug9,gug10,gug11,gug12,gug13,gug14,gug15
	.long	gug16
Edwrd_h
	.long	edwrd1
	.long	edwrd1,edwrd2,edwrd3,edwrd4,edwrd5,edwrd6,edwrd7,edwrd8,edwrd9,edwrd10
	.long	edwrd11,edwrd12,edwrd13,edwrd14,edwrd15,edwrd16
McDan_h
	.long	MCDAN1
	.long	MCDAN1,MCDAN2,MCDAN3,MCDAN4,MCDAN5,MCDAN6,MCDAN7,MCDAN8,MCDAN9,MCDAN10
	.long	MCDAN11,MCDAN12,MCDAN13,MCDAN14,MCDAN15,MCDAN16
Brown_h
	.long	BROWN1
	.long	BROWN1,BROWN2,BROWN3,BROWN4,BROWN5,BROWN6,BROWN7,BROWN8,BROWN9,BROWN10
	.long	BROWN11,BROWN12,BROWN13,BROWN14,BROWN15,BROWN16
KAnderson_h
	.long	K_AND1
	.long	K_AND1,K_AND2,K_AND3,K_AND4,K_AND5,K_AND6,K_AND7,K_AND8,K_AND9,K_AND10
	.long	K_AND11,K_AND12,K_AND13,K_AND14,K_AND15,K_AND16
Willis_h
	.long	WILLIS1
	.long	WILLIS1
	.long	WILLIS2,WILLIS3,WILLIS4,WILLIS5,WILLIS6,WILLIS7,WILLIS8
	.long	WILLIS9,WILLIS10,WILLIS11,WILLIS12,WILLIS13,WILLIS14,WILLIS15,WILLIS16
Gamble_h
	.long	GAMBLE1
	.long	GAMBLE1
	.long	GAMBLE2,GAMBLE3,GAMBLE4
	.long	GAMBLE5,GAMBLE6,GAMBLE7,GAMBLE8,GAMBLE9,GAMBLE10,GAMBLE11,GAMBLE12
	.long	GAMBLE13,GAMBLE14,GAMBLE15,GAMBLE16
Mourn_h
	.long	MOURN1
	.long	MOURN1
	.long	MOURN2,MOURN3,MOURN4,MOURN5
	.long	MOURN6,MOURN7,MOURN8,MOURN9,MOURN10,MOURN11,MOURN12,MOURN13,MOURN14
	.long	MOURN15,MOURN16
Armstrng_h
	.long	ARMST1
	.long	ARMST1
	.long	ARMST2,ARMST3,ARMST4,ARMST5,ARMST6,ARMST7
	.long	ARMST8,ARMST9,ARMST10,ARMST11,ARMST12,ARMST13,ARMST14,ARMST15,ARMST16
Kukoc_h
	.long	KUKOC1
	.long	KUKOC1
	.long	KUKOC2,KUKOC3,KUKOC4,KUKOC5,KUKOC6,KUKOC7,KUKOC8,KUKOC9,KUKOC10
	.long	KUKOC11,KUKOC12,KUKOC13,KUKOC14,KUKOC15,KUKOC16
Nance_h
	.long	NANCE1
	.long	NANCE1
	.long	NANCE2,NANCE3
	.long	NANCE4,NANCE5,NANCE6,NANCE7,NANCE8,NANCE9,NANCE10,NANCE11,NANCE12
	.long	NANCE13,NANCE14,NANCE15,NANCE16
Jack_h
	.long	JACK1
	.long	JACK1
	.long	JACK2,JACK3,JACK4,JACK5,JACK6
	.long	JACK7,JACK8,JACK9,JACK10,JACK11,JACK12,JACK13,JACK14,JACK15,JACK16
Mash_h
	.long	MASH1
	.long	MASH1
	.long	MASH2,MASH3,MASH4,MASH5,MASH6,MASH7,MASH8,MASH9,MASH10,MASH11
	.long	MASH12,MASH13,MASH14,MASH15,MASH16
Rogers_h
	.long	ROGERS1
	.long	ROGERS1
	.long	ROGERS2,ROGERS3,ROGERS4
	.long	ROGERS5,ROGERS6,ROGERS7,ROGERS8,ROGERS9,ROGERS10,ROGERS11,ROGERS12
	.long	ROGERS13,ROGERS14,ROGERS15,ROGERS16
Dumars_h
	.long	DUMARS1
	.long	DUMARS1
	.long	DUMARS2,DUMARS3,DUMARS4,DUMARS5,DUMARS6,DUMARS7,DUMARS8
	.long	DUMARS9,DUMARS10,DUMARS11,DUMARS12,DUMARS13,DUMARS14,DUMARS15,DUMARS16
Rodman_h
	.long	RODMAN1
	.long	RODMAN1
	.long	RODMAN2,RODMAN3,RODMAN4,RODMAN5,RODMAN6,RODMAN7,RODMAN8
	.long	RODMAN9,RODMAN10,RODMAN11,RODMAN12,RODMAN13,RODMAN14,RODMAN15,RODMAN16
Hunter_h
	.long	HUNTER1
	.long	HUNTER1
	.long	HUNTER2,HUNTER3,HUNTER4,HUNTER5,HUNTER6,HUNTER7,HUNTER8
	.long	HUNTER9,HUNTER10,HUNTER11,HUNTER12,HUNTER13,HUNTER14,HUNTER15,HUNTER16
Webber_h
	.long	WEBBER1
	.long	WEBBER1
	.long	WEBBER2,WEBBER3,WEBBER4,WEBBER5,WEBBER6,WEBBER7,WEBBER8
	.long	WEBBER9,WEBBER10,WEBBER11,WEBBER12,WEBBER13,WEBBER14,WEBBER15,WEBBER16
Maxwell_h
	.long	MAX1
	.long	MAX1
	.long	MAX2,MAX3,MAX4,MAX5,MAX6,MAX7,MAX8,MAX9,MAX10,MAX11,MAX12,MAX13
	.long	MAX14,MAX15,MAX16
Horry_h
	.long	HORRY1
	.long	HORRY1
	.long	HORRY2,HORRY3,HORRY4,HORRY5,HORRY6,HORRY7
	.long	HORRY8,HORRY9,HORRY10,HORRY11,HORRY12,HORRY13,HORRY14,HORRY15,HORRY16
Smits_h
	.long	SMITS1
	.long	SMITS1
	.long	SMITS2,SMITS3,SMITS4,SMITS5,SMITS6,SMITS7,SMITS8,SMITS9,SMITS10
	.long	SMITS11,SMITS12,SMITS13,SMITS14,SMITS15,SMITS16
Sealy_h
	.long	SELAY1
	.long	SELAY1
	.long	SELAY2,SELAY3
	.long	SELAY4,SELAY5,SELAY6,SELAY7,SELAY8,SELAY9,SELAY10,SELAY11,SELAY12
	.long	SELAY13,SELAY14,SELAY15,SELAY16
Roberts_h
	.long	ROBERTS1
	.long	ROBERTS1
	.long	ROBERTS2,ROBERTS3,ROBERTS4
	.long	ROBERTS5,ROBERTS6,ROBERTS7,ROBERTS8,ROBERTS9,ROBERTS10,ROBERTS11
	.long	ROBERTS12,ROBERTS13,ROBERTS14,ROBERTS15,ROBERTS16
Peeler_h
	.long	PEELER1
	.long	PEELER1
	.long	PEELER2,PEELER3,PEELER4,PEELER5,PEELER6,PEELER7,PEELER8
	.long	PEELER9,PEELER10,PEELER11,PEELER12,PEELER13,PEELER14,PEELER15,PEELER16
Campbell_h
	.long	CAMP1
	.long	CAMP1
	.long	CAMP2,CAMP3,CAMP4,CAMP5,CAMP6,CAMP7,CAMP8,CAMP9,CAMP10,CAMP11
	.long	CAMP12,CAMP13,CAMP14,CAMP15,CAMP16
Miner_h
	.long	MINER1
	.long	MINER1
	.long	MINER2,MINER3,MINER4,MINER5,MINER6,MINER7
	.long	MINER8,MINER9,MINER10,MINER11,MINER12,MINER13,MINER14,MINER15,MINER16
Baker_h
	.long	BAKER1
	.long	BAKER1
	.long	BAKER2,BAKER3,BAKER4,BAKER5,BAKER6,BAKER7,BAKER8,BAKER9,BAKER10
	.long	BAKER11,BAKER12,BAKER13,BAKER14,BAKER15,BAKER16
Day_h
	.long	DAY1
	.long	DAY1
	.long	DAY2,DAY3,DAY4
	.long	DAY5,DAY6,DAY7,DAY8,DAY9,DAY10,DAY11,DAY12,DAY13,DAY14,DAY15,DAY16
Rider_h
	.long	RIDER1
	.long	RIDER1
	.long	RIDER2,RIDER3,RIDER4,RIDER5,RIDER6,RIDER7,RIDER8,RIDER9,RIDER10
	.long	RIDER11,RIDER12,RIDER13,RIDER14,RIDER15,RIDER16
Morris_h
	.long	MORRIS1
	.long	MORRIS1
	.long	MORRIS2,MORRIS3,MORRIS4
	.long	MORRIS5,MORRIS6,MORRIS7,MORRIS8,MORRIS9,MORRIS10,MORRIS11,MORRIS12
	.long	MORRIS13,MORRIS14,MORRIS15,MORRIS16
Mason_h
	.long	MASON1
	.long	MASON1
	.long	MASON2,MASON3,MASON4,MASON5
	.long	MASON6,MASON7,MASON8,MASON9,MASON10,MASON11,MASON12,MASON13,MASON14
	.long	MASON15,MASON16
Starks_h
	.long	STARKS1
	.long	STARKS1
	.long	STARKS2
	.long	STARKS3,STARKS4,STARKS5,STARKS6
	.long	STARKS7,STARKS8,STARKS9,STARKS10,STARKS11,STARKS12,STARKS13,STARKS14
	.long	STARKS15,STARKS16
AHard_h
	.long	A_HARD1
	.long	A_HARD1,A_HARD2,A_HARD3,A_HARD4,A_HARD5,A_HARD6,A_HARD7,A_HARD8
	.long	A_HARD9,A_HARD10,A_HARD11,A_HARD12,A_HARD13,A_HARD14,A_HARD15,A_HARD16
NAnders_h
	.long	N_AND1
	.long	N_AND1
	.long	N_AND2,N_AND3,N_AND4,N_AND5,N_AND6,N_AND7,N_AND8,N_AND9,N_AND10
	.long	N_AND11,N_AND12,N_AND13,N_AND14,N_AND15,N_AND16
Weath_h
	.long	WEATH1
	.long	WEATH1
	.long	WEATH2,WEATH3
	.long	WEATH4,WEATH5,WEATH6,WEATH7,WEATH8,WEATH9,WEATH10,WEATH11,WEATH12
	.long	WEATH13,WEATH14,WEATH15,WEATH16
Brad_h
	.long	BRAD1
	.long	BRAD1
	.long	BRAD2,BRAD3,BRAD4,BRAD5,BRAD6
	.long	BRAD7,BRAD8,BRAD9,BRAD10,BRAD11,BRAD12,BRAD13,BRAD14,BRAD15,BRAD16
KJohn_h
	.long	K_JOHN1
	.long	K_JOHN1
	.long	K_JOHN2,K_JOHN3,K_JOHN4,K_JOHN5,K_JOHN6,K_JOHN7,K_JOHN8
	.long	K_JOHN9,K_JOHN10,K_JOHN11,K_JOHN12,K_JOHN13,K_JOHN14,K_JOHN15,K_JOHN16
CRobin_h
	.long	C_ROB1
	.long	C_ROB1
	.long	C_ROB2,C_ROB3,C_ROB4,C_ROB5,C_ROB6,C_ROB7,C_ROB8,C_ROB9,C_ROB10
	.long	C_ROB11,C_ROB12,C_ROB13,C_ROB14,C_ROB15,C_ROB16
Simmons_h
	.long	SIMM1
	.long	SIMM1
	.long	SIMM2,SIMM3
	.long	SIMM4,SIMM5,SIMM6,SIMM7,SIMM8,SIMM9,SIMM10,SIMM11,SIMM12,SIMM13,SIMM14
	.long	SIMM15,SIMM16
Hurley_h
	.long	HURL1
	.long	HURL1
	.long	HURL2,HURL3,HURL4,HURL5,HURL6,HURL7,HURL8,HURL9
	.long	HURL10,HURL11,HURL12,HURL13,HURL14,HURL15,HURL16
Rich_h
	.long	RICH1
	.long	RICH1
	.long	RICH2,RICH3
	.long	RICH4,RICH5,RICH6,RICH7,RICH8,RICH9,RICH10,RICH11,RICH12,RICH13,RICH14
	.long	RICH15,RICH16
DEllis_h
	.long	D_ELL1
	.long	D_ELL1
	.long	D_ELL2,D_ELL3,D_ELL4,D_ELL5,D_ELL6,D_ELL7,D_ELL8
	.long	D_ELL9,D_ELL10,D_ELL11,D_ELL12,D_ELL13,D_ELL14,D_ELL15,D_ELL16
Payton_h
	.long	PAYTON1
	.long	PAYTON1
	.long	PAYTON2,PAYTON3,PAYTON4,PAYTON5,PAYTON6,PAYTON7,PAYTON8
	.long	PAYTON9,PAYTON10,PAYTON11,PAYTON12,PAYTON13,PAYTON14,PAYTON15,PAYTON16
Mckey_h
	.long	MCKEY1
	.long	MCKEY1
	.long	MCKEY2,MCKEY3,MCKEY4,MCKEY5,MCKEY6,MCKEY7,MCKEY8,MCKEY9,MCKEY10
	.long	MCKEY11,MCKEY12,MCKEY13,MCKEY14,MCKEY15,MCKEY16
Benoit_h
	.long	BENOIT1
	.long	BENOIT1
	.long	BENOIT2
	.long	BENOIT3,BENOIT4,BENOIT5,BENOIT6,BENOIT7,BENOIT8,BENOIT9,BENOIT10
	.long	BENOIT11,BENOIT12,BENOIT13,BENOIT14,BENOIT15,BENOIT16
Ellison_h
	.long	ELLISN1
	.long	ELLISN1
	.long	ELLISN2
	.long	ELLISN3,ELLISN4,ELLISN5,ELLISN6,ELLISN7,ELLISN8,ELLISN9,ELLISN10
	.long	ELLISN11,ELLISN12,ELLISN13,ELLISN14,ELLISN15,ELLISN16
Cheaney_h
	.long	CHEAN1
	.long	CHEAN1
	.long	CHEAN2
	.long	CHEAN3,CHEAN4,CHEAN5,CHEAN6,CHEAN7,CHEAN8,CHEAN9,CHEAN10,CHEAN11
	.long	CHEAN12,CHEAN13,CHEAN14,CHEAN15,CHEAN16


