**************************************************************
*
* Software:		Shawn Liptak
* Initiated:		9/17/92
*
* Modified:		Shawn Liptak, 12/29/92	-Split from plyr.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/25/93 20:25
**************************************************************
	.file	"drone.asm"
	.title	"basketball drone code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"audit.equ"
	.include	"shawn.hdr"		;Macros
	.asg		0,SEQT
	.include	"plyr.equ"


;sounds external


;symbols externally defined

	.ref	plyrobj_t,plyrproc_t
	.ref	ballobj_p
	.ref	ballpnum
	.ref	seekdirdist_obxz128

	.ref	drone2on
	.ref	drone2_main,drone2_adjskill,drone2_setuptob

	.ref	game_time,gmqrtr
	.ref	shotimer

	.ref	team1,team2

	.ref	RNDPER
	.ref	PSTATUS
	.ref	GET_ADJ


;symbols defined in this file


;uninitialized ram definitions

	.bss	drnzzcnt	,16	;Drone zigzag mode cntdn
	.bss	drnzzmode	,16	;Drone zigzag mode (0-?)


;equates for this file



	.text



#***************************************************************
* Main drone logic
* A8=*Obj
* A11=*Ctrl bits
* A13=*Plyr process
* Trashes scratch, A2-A5

 SUBR	drone_main

	move	@drone2on,b0
	jrnz	drone2_main


	move	@ballpnum,a14
	jrn	drone_chaseball		;No owner?

	move	*a13(plyr_ownball),a1
	jrz	drone_defence		;We don't have ball?
	jrn	drone_offwoball		;Teammate has ball?


;-------				;>Offense

	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrz	#tmdrone		;Teammate is a drone?

	move	*a13(plyr_d_cflgs),a2
	btst	DRN_PASS_B,a2
	jrz	#nopass

	movi	BUT2_M<<8+BUT2_M,a14	;>Make him pass
	jruc	#docmd

#nopass
	btst	DRN_SHOOT_B,a2
	jrz	#noshoot
	movi	BUT1_M|BUT3_M,a14	;>Make him shoot
	movk	3,a0
	move	a0,*a13(plyr_d_seekcnt)
#docmd
	move	*a11,a0
	sll	32-4,a0
	srl	32-4,a0
;	move	a2,a2
;	jrnn	#noturb
	ori	BUT3_M,a0		;+turbo
#noturb
	or	a14,a0
	move	a0,*a11
	clr	a0
	move	a0,*a13(plyr_d_cflgs)
	jruc	#x

#noshoot
#tmdrone

	movk	1,a0
	move	a0,*a13(plyr_d_mode)


	move	*a13(plyr_seqflgs),a2
	btst	PASS_B,a2
	jrnz	#kilbuts

	move	*a13(plyr_jmpcnt),a14
	jrnz	#injmp

	move	*a11,a0
	btst	BUT1_B,a0
	jrnz	#fake			;Shoot button down?


	btst	SHOOT_B,a2
	jrnz	#injmp


	move	*a13(plyr_dribmode),a14
	jrn	#nodrib

	move	*a13(plyr_num),a14	;>Chk for breakaway
	srl	1,a14
	movk	1,a0
	xor	a0,a14
	sll	6,a14			;*64
	addi	plyrproc_t,a14
	move	*a14+,a2,L
	move	*a14+,a3,L

	move	*a2(plyr_hpdist),a2
	move	*a3(plyr_hpdist),a3
	move	*a13(plyr_ohpdist),a4

	cmp	a4,a2
	jrlt	#shootrnd		;He's closer?
	cmp	a4,a3
	jrlt	#shootrnd		;He's closer?

	move	*a13(plyr_ohoopx),a0
	movi	CZMID,a1
	callr	drone_seekxy
	move	*a13(plyr_d_skill),a14
	cmpi	-11-3,a14
	jrle	#noturb2
	ori	BUT3_M,a0		;Push turbo
	move	a0,*a11
#noturb2

	move	@game_time,a1,L
	cmpi	>200,a1
	jrlt	#shoot2			;Less than 2 secs?
	move	@shotimer+16,a1		;Tens
	jrnz	#scok
	move	@shotimer,a1		;Ones
	subk	2,a1
	jrlt	#shoot2			;Less than 2 secs?
#scok
	move	*a13(plyr_ohpdist),a14
	cmpi	170,a14
	jrge	#x			;Too far?
	cmpi	50,a14
	jrlt	#shoot2			;Close?
	movk	>1f,a0
	callr	rnd
	jrnz	#x
	jruc	#shoot2


#nodrib					;>Can't dribble
	move	*a13(plyr_ohpdist),a0
	cmpi	230,a0
	jrlt	#shoot2
	callr	drone_pass
	jrnz	#x			;Pass OK?
	movk	>1f,a0
	callr	rnd
	jrnz	#x			;97%?
	jruc	#shoot2


#shootrnd
	move	@game_time,a1,L
	cmpi	>200,a1
	jrlt	#shoot2			;Less than 2 secs?
	move	@shotimer+16,a1
	jrnz	#scok2
	move	@shotimer,a1
	subk	2,a1
	jrlt	#shoot2			;Less than 2 secs?
#scok2
	PUSH	a6,a7
	move	*a13(plyr_ohoopx),a6
	movi	CZMID,a7
	calla	seekdirdist_obxz128
	PULL	a6,a7

	move	*a13(plyr_o1dist),a14
	cmpi	80,a14
	jrgt	#o1dok			;He's too far?
	cmp	a14,a1
	jrlt	#o1dok			;I'm closer?
	move	*a13(plyr_o1dir),a2
	sub	a0,a2
	abs	a2
	cmpi	>40,a2
	jrle	#o1dsml
	subi	>80,a2
	abs	a2
#o1dsml	subk	32,a2
	jrlt	#goaround		;In front of me?
#o1dok
	move	*a13(plyr_o2dist),a14
	cmpi	80,a14
	jrgt	#o2dok			;He's too far?
	cmp	a14,a1
	jrlt	#o2dok			;I'm closer?
	move	*a13(plyr_o2dir),a2
	sub	a0,a2
	abs	a2
	cmpi	>40,a2
	jrle	#o2dsml
	subi	>80,a2
	abs	a2
#o2dsml	subk	32,a2
	jrlt	#goaround		;In front of me?
#o2dok
	jruc	#runath

#goaround				;>Opponent in my way
	move	*a13(plyr_tmdist),a0
	cmpi	70,a0
	jrlt	#goa			;Teammate too close?

	callr	drone_pass
	jrnz	#x			;Pass OK?

#goa
	movi	drnzzcnt,a2
	move	*a2,a0
	subk	1,a0
	jrgt	#zzsame

	movk	1,a0			;New mode
	callr	rnd
	move	a0,*a2(drnzzmode-drnzzcnt)
	movi	TSEC-10,a0
	callr	rndrng0
	addk	10,a0
#zzsame
	move	a0,*a2

	move	*a13(plyr_ohoopx),a0
	movi	CZMID,a1
	callr	drone_seekxy
	jrz	#shoot2			;In position?
	sll	3,a0			;*8
	addi	#jbits_t,a0

	move	*a2(drnzzmode-drnzzcnt),a14
	jrz	#md1
	addi	16*8,a0
#md1	movb	*a0,a0
	move	a0,*a11

	cmpi	80,a4
	jrlt	#shoot2			;Close enough for jam?

	jruc	#tryshot


#runath					;>I have a clr path to hoop!
	move	*a13(plyr_o1dist),a14
	cmpi	65,a14
	jrlt	#goa			;He's too close?
	move	*a13(plyr_o2dist),a14
	cmpi	65,a14
	jrlt	#goa			;He's too close?

	move	*a13(plyr_ohoopx),a0
	movi	CZMID,a1
	callr	drone_seekxy
	move	*a13(plyr_d_skill),a14
	cmpi	-11-3,a14
	jrle	#tryshot
	ori	BUT3_M,a0		;Turbo
	move	a0,*a11


#tryshot
	cmpi	50,a4
	jrlt	#shoot2			;Close enough for jam?

	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrnz	#x			;Teammate is a human?

	cmpi	230,a4			;>Chk if we need 3ptrs
	jrlt	#no3
	cmpi	290,a4
	jrgt	#no3

	movk	6,a1
	move	@game_time,a2,L
	cmpi	>1010000,a2
	jrgt	#hvtime			;Enough time?
	movk	3,a1
#hvtime
	move	*a13(plyr_ptsdown),a14
	cmp	a1,a14
	jrlt	#no3

	cmpi	>40000,a2
	jrlt	#shoot2			;Less than 40 secs?

	movk	8,a0
	move	*a13(plyr_o1dist),a14
	cmpi	70,a14
	jrlt	#rndsht			;He's close?
	move	*a13(plyr_o2dist),a14
	cmpi	70,a14
	jrlt	#rndsht			;He's close?
	jruc	#shoot2

#no3
	movi	50,a0
	move	*a13(plyr_d_skill),a14
	cmpi	-8,a14
	jrgt	#rndsht
	movk	30,a0
#rndsht	callr	rndrng0
	move	a0,a0
	jrnz	#x

#shoot
	move	*a13(plyr_ohpdist),a14
	cmpi	240,a14
	jrge	#x			;Too far?

#shoot2	move	*a11,a0			;>Shoot
	ori	BUT1_M|BUT3_M,a0
	move	a0,*a11
	movk	1,a0			;Max fakes
	move	a0,*a13(plyr_d_seekcnt)
	jruc	#x



#fake					;>Jumping but still on gnd
	move	*a13(plyr_d_seekcnt),a2
	jrle	#x			;No fakes?
	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrnz	#x			;Teammate is a human?
	movk	>1f,a0
	callr	rnd
	jrnz	#x

	move	@game_time,a1,L
	cmpi	>200,a1
	jrlt	#x			;Less than 2 secs?
	move	@shotimer+16,a1		;Tens
	jrnz	#fk
	move	@shotimer,a1		;Ones
	subk	2,a1
	jrlt	#x			;Less than 2 secs?
#fk
	subk	1,a2
	move	a2,*a13(plyr_d_seekcnt)
	jruc	#kilbuts


#injmp
	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrz	#tmdrn			;Teammate is a drone?

;FIX! give pass ability
	move	*a13(plyr_tmproc_p),a0,L
	move	*a0(PA11),a0,L
	move	*a0,a0			;Get teammates ctrl bits
	btst	BUT1_B,a0
	jrnz	#x			;Holding shoot button?
	jruc	#kilbuts
#tmdrn
	move	*a3(plyr_seqflgs),a0
	btst	BLOCKREB_B,a0
	jrnz	#kilbuts		;Got a rebound?

	movk	15,a0
	callr	rndrng0
	move	a0,a0
	jrz	#kilbuts		;Cause shoot?

	movk	7,a0
	callr	rnd
	jrnz	#x			;88%?

	move	*a13(plyr_ptsdown),a14
	addk	5,a14
	jrlt	#pss			;Winning by >5?
	move	*a13(plyr_seqflgs),a14
	btst	DUNK_B,a14
	jrnz	#x			;In a dunk?
	move	@game_time,a1,L
	cmpi	>200,a1
	jrlt	#x			;Less than 2 secs?

#pss	callr	drone_pass

	jruc	#x



#kilbuts
	clr	a0			;>Let go of shoot button
	move	a0,*a11


#x	rets


#jbits_t
	.byte	0,JOYL_M,JOYR_M,0
	.byte	JOYD_M,JOYD_M|JOYL_M,JOYD_M|JOYR_M,0
	.byte	JOYU_M,JOYU_M|JOYL_M,JOYU_M|JOYR_M,0
	.byte	0,0,0,0

	.byte	0,JOYR_M,JOYL_M,0
	.byte	JOYU_M,JOYU_M|JOYR_M,JOYU_M|JOYL_M,0
	.byte	JOYD_M,JOYD_M|JOYR_M,JOYD_M|JOYL_M,0
	.byte	0,0,0,0



#*******************************
* Drone in offense with out ball

 SUBRP	drone_offwoball

	clr	a0
	move	a0,*a13(plyr_d_cflgs)


	move	*a13(plyr_d_mode),a14
	jrgt	#inmd			;Already in mode?

	movk	1,a0
	move	a0,*a13(plyr_d_mode)

	callr	drone_getcurskillo
	addi	#mdsk_t,a0
	move	*a0,a0
	callr	rndrng0
	addk	1,a0
	move	a0,*a13(plyr_d_seekcnt)
#inmd


	move	*a13(plyr_dir),a3

	move	*a13(plyr_o1dist),a14
	subi	50,a14
	jrgt	#o1far				;Too far?
	move	*a13(plyr_o1dir),a2
	sub	a3,a2
	abs	a2
	cmpi	>40,a2
	jrle	#o1dsml
	subi	>80,a2
	abs	a2
#o1dsml	subk	16,a2
	jrlt	#pusho				;In front of me?
#o1far
	move	*a13(plyr_o2dist),a14
	subi	50,a14
	jrgt	#nopush				;Too far?
	move	*a13(plyr_o2dir),a2
	sub	a3,a2
	abs	a2
	cmpi	>40,a2
	jrle	#o2dsml
	subi	>80,a2
	abs	a2
#o2dsml	subk	16,a2
	jrge	#nopush				;!In front?
#pusho
	movi	99,a0
	callr	rndrng0

	move	*a13(plyr_ptsdown),a14
	move	*a13(plyr_d_skill),a1
	add	a1,a14
	cmpi	15,a14
	jrle	#mxdnok
	movk	15,a14
#mxdnok	addk	15,a14
	jrge	#dnok
	clr	a14
#dnok	sll	4,a14
	addi	#p_t,a14
	move	*a14,a1

	cmp	a1,a0
	jrge	#newseek			;Skip push?

	move	*a11,a0				;Push
	ori	BUT2_M<<8|BUT2_M|BUT3_M,a0
	move	a0,*a11
	jruc	#x
#nopush


	movi	>7f,a0
	callr	rnd
	jrz	#newseek

	move	*a13(plyr_d_seekcnt),a0
	subk	1,a0
	jrgt	#seek

#newseek
	move	*a13(plyr_newdir),a0
	jrnn	#contsk				;Turning?

	movk	16,a0
	callr	rndrng0
	sll	5,a0				;*32
	addi	#seek_t,a0

	move	*a0+,a1
	move	*a13(plyr_num),a14
	subk	2,a14
	jrge	#lft
	neg	a1
#lft	addi	WRLDMID,a1
	move	a1,*a13(plyr_d_seekx)

	move	*a0+,a1
	move	a1,*a13(plyr_d_seeky)

	movi	TSEC*3,a0
	callr	rndrng0
	addk	TSEC/2,a0

#seek	move	a0,*a13(plyr_d_seekcnt)
#contsk
	move	*a13(plyr_d_seekx),a0
	move	*a13(plyr_d_seeky),a1
	callr	drone_seekxy
	jrnz	#notthere

	movk	>1f,a0				;3%
	callr	rnd
	jrnz	#x
	clr	a0
	move	a0,*a13(plyr_d_seekcnt)

#notthere


#x
	rets


#mdsk_t					;Mode switch max seek time
	.word	50,50,50,50,50		;Up 15-11
	.word	40,40,40,35,30		;10-6
	.word	25,22,20,18,16		;5-1
	.word	14			;Even score
	.word	10,8,6,4,4		;Dn 1-5
	.word	4,3,3,3,2		;6-10
	.word	2,2,2,2,1		;11-15

#p_t					;% to push
	.word	1,1,1,1,1
	.word	2,2,2,2,3
	.word	3,3,4,4,5
	.word	5
	.word	5,6,8,10,13
	.word	15,17,18,20,20
	.word	25,30,35,40,50


	.asg	CZMID,Z
#seek_t
	.word	-320,Z-160, -250,Z-160, -120,Z-100	;3ptrs
	.word	-120,Z
	.word	-120,Z+100, -250,Z+160, -320,Z+160

	.word	-320,Z-100, -250,Z-80, -200,Z-50	;2ptrs
	.word	-180,Z
	.word	-200,Z+50, -250,Z+80, -320,Z+100

	.word	-310,Z-10, -305,Z, -310,Z+10


#*******************************
* Drone code - pass if clear
* A8=*Obj
* A11=*Ctrl bits
* A13=*Plyr process
* >A0=!0 if pass OK (CC)
* Trashes scratch

 SUBRP	drone_pass

	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrnz	#x			;Teammate is a human?

	move	*a13(plyr_tmdist),a0
	addk	10,a0
	move	*a13(plyr_o1dist),a1
	cmp	a1,a0
	jrlt	#o1ok

	move	*a13(plyr_tmdir),a14
	move	*a13(plyr_o1dir),a1
	sub	a14,a1
	abs	a1
	cmpi	64,a1
	jrle	#dsml
	subi	128,a1
	abs	a1
#dsml	subk	16,a1
	jrlt	#x

#o1ok
	move	*a13(plyr_o2dist),a1
	cmp	a1,a0
	jrlt	#o2ok

	move	*a13(plyr_tmdir),a14
	move	*a13(plyr_o2dir),a1
	sub	a14,a1
	abs	a1
	cmpi	64,a1
	jrle	#dsml2
	subi	128,a1
	abs	a1
#dsml2	subk	16,a1
	jrlt	#x

#o2ok
	move	*a13(plyr_tmproc_p),a1,L
	move	*a1(plyr_seq),a0
	subk	RUNDRIBTURB_SEQ,a0
	jrhi	#x

	move	*a11,a0			;>Pass
	ori	BUT2_M<<8|BUT2_M|BUT3_M,a0
	move	a0,*a11

	rets

#x	clr	a0
	rets


#*******************************
* Drone code - defence
* A8=*Obj
* A11=*Ctrl bits
* A13=*Plyr process

 SUBRP	drone_defence

	PUSH	a7


	move	@ballpnum,a5
	sll	5,a5
	addi	plyrproc_t,a5
	move	*a5,a5,L		;A5=*Proc of opponent with ball


	callr	drone_getcurskillo
	move	a0,a7			;A7=Ptsdn+skill for indexing (*16)


	clr	a0
	move	a0,*a13(plyr_d_cflgs)

	move	*a13(plyr_d_mode),a14
	jrn	#inmd			;Already in mode?

	subk	1,a0			;-1
	move	a0,*a13(plyr_d_mode)

	move	a7,a14
	addi	#mdsk_t,a14
	move	*a14,a0
	move	a0,a2
	srl	2,a2			;/4

	callr	rndrng0
	addk	1,a0
	add	a2,a0
	move	a0,*a13(plyr_d_seekcnt)
	
#inmd



	move	*a13(plyr_d_seekcnt),a0
	subk	1,a0
	jrgt	#seek

	move	*a13(plyr_num),a2
	XORK	2,a2
	move	a2,a4
	sll	5,a4			;*32
	addi	plyrproc_t,a4
	move	*a4,a4,L
	cmp	a5,a4
	jreq	#guard			;I'm on guy with ball?

	move	*a5(plyr_ohpdist),a0
	cmpi	300,a0
	jrgt	#guard			;Too far to worry about?

	move	*a5(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrnz	#gbc			;He's dunking?

	move	*a13(plyr_tmproc_p),a3,L
	move	*a3(plyr_seq),a0
	subi	STAGGER_SEQ,a0
	jrls	#tmok
	subk	FLYBACKWB2_SEQ-STAGGER_SEQ,a0
	jrls	#gbc			;Teammates staggered?
#tmok
	move	*a3(plyr_o1dist),a14
	move	*a3(plyr_o1dir),a1
	btst	0,a2
	jrnz	#p1
	move	*a3(plyr_o2dist),a14
	move	*a3(plyr_o2dir),a1
#p1
	move	*a3(plyr_hpdir),a0	;Find dir difference
	sub	a1,a0
	abs	a0
	cmpi	>40,a0
	jrle	#dsml
	subi	>80,a0
	abs	a0
#dsml	subk	28,a0
	jrle	#gbc			;TM not between op and hoop?

	cmpi	160,a14
	jrgt	#gbc			;TM not guarding?
;FIX
	jruc	#guard

#gbc	move	a5,a4			;Guard ball carrier
#guard
	move	*a4(PA8),a2,L		;*Obj

	move	*a2(OXPOS),a0
	move	*a2(OXANI+16),a14
	add	a14,a0			;X
	move	*a2(OZPOS),a1		;Z

	move	@game_time,a14,L
	cmpi	>800,a14
	jrlt	#setseek		;Less than 8 secs?
	move	@shotimer+16,a14	;Tens
	jrnz	#scok
	move	@shotimer,a14		;Ones
	subk	5,a14
	jrlt	#setseek		;Less than 5 secs?
#scok
	move	*a5(plyr_seqflgs),a14
	btst	SHOOT_B,a14
	jrnz	#setseek		;Starting a shot?

	move	*a2(OXVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a0
	move	*a2(OZVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a1

	move	*a13(plyr_myhoopx),a2	;>Stay near oplyr between my basket
	movi	CZMID,a3

	add	a0,a2
	sll	1,a0
	add	a2,a0
	sra	2,a0			;/4

	add	a1,a3
	sll	1,a1
	add	a3,a1
	sra	2,a1			;/4
#setseek
	move	a0,*a13(plyr_d_seekx)
	move	a1,*a13(plyr_d_seeky)

	movk	25,a0
	move	*a5(plyr_hpdist),a1
	cmpi	310,a1
	jrge	#seek			;Far from my hoop?


	move	a7,a14
	addi	#skt_t,a14
	move	*a14,a0
	move	a0,a2
	srl	2,a2			;/4
	callr	rndrng0
	add	a2,a0

#seek	move	a0,*a13(plyr_d_seekcnt)

	move	*a13(plyr_d_seekx),a0
	move	*a13(plyr_d_seeky),a1
	callr	drone_seekxy
	move	a0,a2



	move	*a13(plyr_num),a14	;>Get opponents proc
	addk	2,a14
	sll	32-2,a14
	srl	32-2-5,a14		;*32
	addi	plyrproc_t,a14
	move	*a14,a0,L
	move	*a0(plyr_ohpdist),a0
	subk	10,a0
	cmpi	300,a0
	jrlt	#long
	subi	80,a0			;Turbo earlier
#long
	move	*a13(plyr_hpdist),a1
	cmp	a0,a1
	jrlt	#icloser
	addi	BUT3_M,a2		;Turbo
#icloser


	move	*a13(plyr_balldist),a1
	cmpi	30,a1
	jrgt	#psrnd			;!In his face?

	move	@game_time,a14,L
	cmpi	>800,a14
	jrlt	#ps			;Less than 8 secs?
	move	@shotimer+16,a14	;Tens
	jrnz	#psrnd
	move	@shotimer,a14		;Ones
	subk	5,a14
	jrlt	#ps			;Less than 5 secs?
#psrnd
	move	a7,a14
	addi	#dist_t,a14
	move	*a14,a0
	cmp	a0,a1
	jrgt	#skipsp			;Ball too far?

	movi	999,a0
	callr	rndrng0

	move	a7,a14
	addi	#ps_t,a14
	move	*a14,a1
	cmp	a1,a0
	jrge	#skipsp			;Skip push?
#ps
	sll	32-4,a2
	srl	32-4,a2
	addk	BUT2_M,a2		;Steal

	movk	1,a0
	callr	rnd
	jrnz	#skipsp			;50%?

	addi	BUT2_M<<8|BUT3_M,a2	;Push
#skipsp


	move	*a13(plyr_balldist),a14	;>Chk if I can block ball
	cmpi	65,a14
	jrge	#noblk

	move	*a5(plyr_jmpcnt),a0
	jrnz	#tryblk			;Plyr with ball is in air?

	move	*a5(plyr_seqflgs),a0
	btst	SHOOT_B,a0
	jrz	#noblk			;!Starting a shot?
	movk	11,a0
	callr	rndrng0
	move	a0,a0
	jrnz	#noblk			;94% ignore?
	jruc	#blk

#tryblk
	movi	99,a0
	callr	rndrng0
	move	a7,a14
	addi	#blk_t,a14
	move	*a14,a1
	cmp	a1,a0
	jrge	#noblk

#blk	ORK	BUT1_M,a2		;Block
#noblk
	move	a2,*a11

	PULL	a7
	rets


#mdsk_t					;Mode switch max seek time
	.word	50,50,50,50,50		;Up 15-11
	.word	50,50,45,45,40		;10-6
	.word	33,25,22,18,16		;5-1
	.word	14			;Even score
	.word	10,8,6,4,4		;Dn 1-5
	.word	4,3,3,3,2		;6-10
	.word	2,2,2,2,1		;11-15

#skt_t					;Max seek time
	.word	60,60,58,55,52
	.word	48,44,40,36,32
	.word	28,24,22,18,16
	.word	14			;Even score
	.word	10,8,6,4,4
	.word	4,3,3,3,2
	.word	2,2,2,2,1

#dist_t					;Max dist to try push/steal
	.word	110,100,100,100,100
	.word	90,90,80,80,80,80
	.word	70,70,60,60,60
	.word	50
	.word	50,50,50,50,50
	.word	50,50,50,50,50
	.word	50,50,50,50,50
#ps_t					;% to push/steal
	.word	2,2,2,2,2
	.word	3,3,3,3,3
	.word	4,4,4,5,5
	.word	6
	.word	6,6,8,10,13
	.word	15,17,18,20,30
	.word	40,60,80,150,250
#blk_t					;% to block
	.word	1,1,2,3,3
	.word	3,3,4,4,5
	.word	6,7,8,10,12
	.word	14
	.word	16,18,20,25,30
	.word	35,40,45,50,50
	.word	50,50,50,50,50


#*******************************
* Setup defensive drones for ball takeout
* Trashes scratch

 SUBR	drone_setuptob

	move	@drone2on,b0
	jrnz	drone2_setuptob

	PUSH	a2,a3,a4,a13

	movk	4,a4
	movi	plyrproc_t,a3

#lp	move	*a3+,a13,L
	move	*a13(plyr_ownball),a14
	jrnz	#nxt			;Offense?

	movi	-1,a14
	move	a14,*a13(plyr_d_mode)	;Defense

	callr	drone_getcurskillo

	addi	#mdsk_t,a0
	move	*a0,a0
	move	a0,a2
	srl	2,a2			;/4

	callr	rndrng0
	addk	1,a0
	add	a0,a2

	movk	1,a0
	callr	rnd
	jrnz	#sk
	srl	1,a2
#sk
	move	a2,*a13(plyr_d_seekcnt)

#nxt
	dsj	a4,#lp

	PULL	a2,a3,a4,a13
	rets

#mdsk_t					;Mode switch max seek time
	.word	50,50,50,50,50		;Up 15-11
	.word	50,50,45,45,40		;10-6
	.word	33,25,22,18,16		;5-1
	.word	14			;Even score
	.word	10,8,6,4,4		;Dn 1-5
	.word	4,3,3,3,2		;6-10
	.word	2,2,2,2,1		;11-15


#*******************************
* Drone code - nobody has ball
* A8=*Obj
* A11=*Ctrl bits
* A13=*Plyr process

 SUBRP	drone_chaseball

	move	*a13(plyr_rcvpass),a14
	jrgt	drone_offwoball		;I'm rcving ball?

	move	*a13(plyr_tmproc_p),a2,L
	move	*a2(plyr_rcvpass),a14
	jrgt	drone_offwoball		;Teammate rcving ball?


	clr	a0
	move	a0,*a13(plyr_d_cflgs)

	move	*a13(plyr_d_mode),a14
	jrz	#inmd			;Already in mode?

	move	a0,*a13(plyr_d_mode)

	move	*a13(plyr_ptsdown),a14
	move	*a13(plyr_d_skill),a0
	add	a0,a14
	cmpi	15,a14
	jrle	#mxdnok
	movk	15,a14
#mxdnok	addk	15,a14
	jrge	#dnok
	clr	a14
#dnok	sll	4,a14
	addi	#mdsk_t,a14
	move	*a14,a0
	callr	rndrng0
	addk	2,a0
	move	a0,*a13(plyr_d_seekcnt)

#inmd

	move	*a13(plyr_d_seekcnt),a0
	subk	1,a0
	jrgt	#seek

	move	*a2(plyr_seq),a0
	subi	STAGGER_SEQ,a0
	jrls	#tmok
	subk	FLYBACKWB2_SEQ-STAGGER_SEQ,a0
	jrls	#chaseb			;Teammates staggered?
#tmok
	move	*a13(plyr_balldist),a0
	move	*a2(plyr_balldist),a14
	cmp	a14,a0
	jrlt	#chaseb			;I'm closer?

	movi	WRLDMID,a0
	movi	CZMID,a1
	jruc	#setxz

#chaseb
	move	@ballobj_p,a5,L

	move	*a5(OXPOS),a0
	move	*a5(OXANI+16),a14
	add	a14,a0
	move	*a5(OXVEL),a14,L
	sra	16-3,a14		;8 ticks from now
	add	a14,a0

	move	*a5(OZPOS),a1
	move	*a5(OZVEL),a14,L
	sra	16-3,a14		;8 ticks from now
	add	a14,a1
#setxz
	move	a0,*a13(plyr_d_seekx)
	move	a1,*a13(plyr_d_seeky)


	move	*a13(plyr_ptsdown),a14
	move	*a13(plyr_d_skill),a0
	add	a0,a14
	cmpi	15,a14
	jrle	#mxdnok2
	movk	15,a14
#mxdnok2
	addk	15,a14
	jrge	#dnok2
	clr	a14
#dnok2	sll	4,a14
	addi	#skt_t,a14
	move	*a14,a0

	callr	rndrng0
	addk	5,a0
#seek	move	a0,*a13(plyr_d_seekcnt)

	move	*a13(plyr_d_seekx),a0
	move	*a13(plyr_d_seeky),a1
	callr	drone_seekxy


	move	*a13(plyr_balldist),a2	;>Chk if I can jump at ball
	subk	30,a2
	jrge	#nojmp

	move	*a5(OYPOS),a0
	addk	25,a0
	move	*a8(OYPOS),a1
	cmp	a1,a0
	jrlt	#nojmp

	movk	7,a0
	callr	rnd
	jrnz	#nojmp			;87%?

	move	*a11,a0			;Jmp
	ORK	BUT1_M,a14
	move	a0,*a11
#nojmp

	rets

#mdsk_t					;Mode switch max seek time
	.word	90,90,90,90,80		;Up 15-11
	.word	80,70,60,55,50		;10-6
	.word	33,25,22,18,16		;5-1
	.word	14			;Even score
	.word	10,8,6,4,4		;Dn 1-5
	.word	4,3,3,3,2		;6-10
	.word	2,2,2,2,1		;11-15

#skt_t					;Max seek time
	.word	50,50,45,45,45
	.word	40,40,30,30,20
	.word	20,16,14,13,12
	.word	12
	.word	12,11,10,10,9
	.word	8,5,4,3,2
	.word	1,1,1,1,1


#*******************************
* Drone - push stick to move drone towards an XZ location
* A0=X to seek
* A1=Z
* A8=*Obj
* A11=*Ctrl bits
* >A0=Joy bits set or 0 (Pass CC)
* Trashes scratch

 SUBRP	drone_seekxy

	move	a2,b0

	move	*a8(OXPOS),a2
	move	*a8(OXANI+16),a14
	add	a14,a2
	sub	a0,a2

	clr	a0

	move	a2,a14
	abs	a2
	subk	10,a2
	jrle	#onx
	move	a14,a14
	jrlt	#nolft
	subk	4,a0			;Left

#nolft	addk	8,a0			;Rgt
#onx
	move	*a8(OZPOS),a2

	sub	a1,a2
	move	a2,a14
	abs	a2
	subk	10,a2
	jrle	#onz
	move	a14,a14
	jrlt	#noup
	subk	1,a0			;Up

#noup	addk	2,a0			;Dn
#onz
	move	a0,*a11

	move	b0,a2
	move	a0,a0
	rets


#*******************************
* Get the current skill offset
* >A0=Offset (0-30) *16
* Trashes scratch

 SUBRP	drone_getcurskillo

	move	*a13(plyr_ptsdown),a0
	move	*a13(plyr_d_skill),a14
	add	a14,a0
	cmpi	15,a0
	jrle	#mxdnok
	movk	15,a0
#mxdnok	addk	15,a0
	jrge	#dnok
	clr	a0
#dnok	sll	4,a0			;A7=Ptsdn+skill for indexing (*16)

	rets



#*******************************
* Adjust all drone abilities (at end of quarter)
* A0=Minute of qrtr (0-2)
* Trashes scratch

 SUBR	drone_adjskill

	move	@drone2on,b0
	jrnz	drone2_adjskill


	PUSH	a2,a3,a4

	move	a0,a0
	jrnz	#x

	movi	plyrproc_t,a4
	movk	4,b0
#lp
	move	*a4+,a3,L

	move	*a3(plyr_d_skill),a2

	move	*a3(plyr_ptsdown),a14
	cmpi	15,a14
	jrle	#mxdnok
	movk	15,a14
#mxdnok	addk	15,a14
	jrge	#dnok
	clr	a14
#dnok	sll	4,a14
	addi	#adj_t,a14
	move	*a14,a14
	add	a14,a2

	movk	ADJDIFF,a0		;Get difficulty level
	calla	GET_ADJ
	subk	3,a0			;-2 to 2
	sll	1,a0			;*2

	move	@gmqrtr,a14		;>Chk quarter minimum
	cmpi	2,a14
	jrle	#qok
	movk	2,a14
#qok	sll	4,a14
	addi	#min_t,a14
	move	*a14,a14
	add	a0,a14
	cmp	a14,a2
	jrge	#minok
	move	a14,a2
#minok
	move	*a3(plyr_num),a1
	XORK	1,a1
	move	@PSTATUS,a14
	btst	a1,a14
	jrnz	#tminok			;Teammate is human?

	move	@team1,a14		;>Chk team minimum
	cmpi	3,b0
	jrge	#t1
	move	@team2,a14
#t1	sll	3+2,a14

	move	@gmqrtr,a1
	cmpi	3,a1
	jrle	#qok2
	movk	3,a1
#qok2	sll	3,a1
	add	a1,a14

	addi	#tdmin_t-8,a14
	movb	*a14,a14
	add	a0,a14
	cmp	a14,a2
	jrge	#tminok
	move	a14,a2
#tminok
	move	a2,*a3(plyr_d_skill)

	dsj	b0,#lp

#x	PULL	a2,a3,a4
	rets

#adj_t	.word	-5,-5,-5,-5,-5
	.word	-5,-5,-5,-4,-3
	.word	-2,-1,0,0,0
	.word	0
	.word	1,1,2,2,3
	.word	3,4,4,5,5
	.word	5,6,6,6,7

#min_t	.word	-8,-6,-4

#tdmin_t
	.byte	-8,-6,-4,0	;ATL
	.byte	-8,-6,-4,0	;BOST
	.byte	-8,-6,-4,0	;CHAR
	.byte	6,9,12,14	;CHI (1)
	.byte	-8,-6,-4,0	;CLEV
	.byte	-8,-6,-4,0	;DAL
	.byte	-8,-6,-4,0	;DEN
	.byte	-8,-6,-4,0	;DET
	.byte	-8,-6,-4,0	;GOLD
	.byte	-8,-6,-4,0	;HOU
	.byte	-8,-6,-4,0	;IND
	.byte	-8,-6,-4,0	;LAC
	.byte	-8,-6,-4,0	;LAL
	.byte	-8,-6,-4,0	;MIAMI
	.byte	-8,-6,-4,0	;MILW
	.byte	-8,-6,-4,0	;MINN
	.byte	-8,-6,-4,0	;NJ
	.byte	1,3,4,5		;NY (4)
	.byte	-8,-6,-4,0	;ORL
	.byte	-8,-6,-4,0	;PHIL
	.byte	4,6,7,8		;PHX (2)
	.byte	2,4,5,6		;PORT (3)
	.byte	-8,-6,-4,0	;SAC
	.byte	-8,-6,-4,0	;SANANT
	.byte	-8,-6,-4,0	;SEA
	.byte	0,2,3,4		;UTAH (5)
	.byte	-8,-6,-4,0	;WASH
	.even


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


********************************
* Quickly produce a random # in range 0-X
* A0=X
* >A0=Random # (0 to A0) (No CC)
* Trashes scratch

 SUBRP	rndrng0

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	addk	1,a0
	mpyu	a1,a0		;Condition codes not valid!

	rets




	.end
