**************************************************************
*
* Owner:		Shawn
*
* Software:		Shawn Liptak
* Initiated:		9/17/92
*
* Modified:		Shawn Liptak, 3/24/93	-New compatible version
* 			Shawn Liptak, 1/17/94	-Smarter for tournament ed.
* 			Shawn Liptak, 3/20/96	-Smarter for HangTime
*
* COPYRIGHT (C) 1992-1996 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 4/8/96 17:01
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
	.include	"macros.hdr"		;Macros
	.include	"world.equ"		;Court-world defs
	.include	"game.equ"
	.asg		0,SEQT
	.include	"plyr.equ"


;sounds external


;symbols externally defined

	.ref	plyrobj_t,plyrproc_t
	.ref	ballobj_p
	.ref	ballpnum,ballpnumshot
	.ref	ballnumscored,ballpnumscored
	.ref	balltmshotcnt,balltmscored
	.ref	plyr_onfire
	.ref	seekdirdist_obxz128

	.ref	game_time,gmqrtr
	.ref	shotimer

	.ref	team1,team2

	.ref	PCNT
	.ref	RNDPER
	.ref	PSTATUS
	.ref	GET_ADJ


;symbols defined in this file


;uninitialized ram definitions

	.bss	drnzzcnt	,16	;Drone zigzag mode cntdn
	.bss	drnzzmode	,16	;Drone zigzag mode (0-?)
	BSSX	drone2on	,16	;!0=Use drone version2 code

	BSSX	dronesmrt	,16	;Bit 0-3 if 1 = Smarter drone


;equates for this file


BV5	equ	>1040->80+>42*6

NOPUSHSTEAL	equ	0	;!0=No push or stealing
ONLY3		equ	0	;!0=Only shoot 3's

	.text



#***************************************************************
* Main drone logic
* A8 = *Obj
* A9 = *Plyr secondary data
* A11= *Ctrl bits
* A13= *Plyr process
* Trashes scratch, A2-A5

 SUBR	drone_main


;	move	*a13(plyr_d_seekcnt),a0
;	cmpi	TSEC*4/2,a0
;	jrle	#_skok
;	LOCKUP
;#_skok

;	move	@ballnumscored,b0
;	subk	ONFIRE_MINCNT-1,b0
;	jrge	#_warm				;None heating up?
;	movk	2,b0
;	move	b0,@ballnumscored
;#_warm

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	move	@ballpnum,a14
	jrn	drone_chaseball		;No owner?

;ÄÄÄÄÄÄÄ
;DEBUG
;	move	*a13(plyr_ohoopx),a0
;	movi	200,a1
;	cmpi	WRLDMID,a0
;	jrlt	#_1
;	neg	a1
;#_1
;	add	a1,a0
;	move	a0,*a13(plyr_d_seekx)
;	movi	CZMID-100,a0
;	move	a0,*a13(plyr_d_seeky)
;ÄÄÄÄÄÄÄ

	move	*a13(plyr_ownball),a1
	jrz	drone_defense		;We don't have ball?
	jrn	drone_offwoball		;Teammate has ball?


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Offense

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
	movi	BUT1_M<<8|BUT1_M|BUT3_M,a14	;>Make him shoot
;	movk	3,a0
;	move	a0,*a13(plyr_d_seekcnt)
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

	move	*a13(plyr_d_mode),a14
	subk	2,a14
	jrge	#inmd			;Already in mode?

	movk	2,a1			;Offense with ball
	move	a1,*a13(plyr_d_mode)
	movk	1,a1
	jruc	#setskc
#inmd
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Update tob mode

	move	*a13(plyr_d_seekcnt),a1
	jrle	#notob
#setskc
	subk	1,a1
	move	a1,*a13(plyr_d_seekcnt)
	jrgt	#notob

	move	*a13(plyr_ohoopx),*a13(plyr_d_seekx)

	movi	70,a0
	callr	rndrng0
	addi	CZMID-35,a0
	move	a0,*a13(plyr_d_seeky)
#notob
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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

	btst	DUNK_B,a2
	jrnz	#injmp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Breakaway

	move	*a13(plyr_ohpdist),a4	;A4=Hoop distance

	move	*a13(plyr_dribmode),a14
	jrn	#nodrib
#inspin

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

	cmp	a4,a2
	jrlt	#shootrnd		;He's closer?
	cmp	a4,a3
	jrlt	#shootrnd		;He's closer?

	callr	drone_seek


;MJT Start
;Tell drone to always turbo on breakaways...
	move	@PSTATUS,a14		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a14
	jrnz	#ori			;Teammate is a human?
	move	*a13(plyr_d_skill),a14
	addk	8,a14
	jrle	#noturb2
#ori	ori	BUT3_M,a0		;Push turbo
;MJT End



	move	a0,*a11
#noturb2

	move	@game_time,a1,L
	srl	8,a1			;Remove tenths
	subk	2,a1
	jrlt	#shoot3			;Less than 2 secs?
	move	@shotimer+16,a1		;Tens
	jrnz	#scok
	move	@shotimer,a1		;Ones
	subk	2,a1
	jrlt	#shoot3			;Less than 2 secs?
#scok
	callr	drone_chk3ptr
	jrnz	#shoot3			;Need a 3?

	cmpi	50,a4
	jrlt	#shoot2			;Close?

	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrnz	#x			;Teammate is a human?

	cmpi	170,a4
	jrge	#x			;Too far?

	movk	9,a0
	callr	rndrng0
	TEST	a0
	jrnz	#x

	jruc	#shoot2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Can't dribble

#nodrib
	move	*a13(plyr_seq),a0
	cmpi	SPIN_MOVE_SEQ,a0
	jreq	#inspin			;Spinning?

	subi	ELBO_SEQ,a0
	jreq	#x			;Elbows?

	subk	ELBO2_SEQ-ELBO_SEQ,a0
	jreq	#x			;Elbows?

	cmpi	240,a4
	jrlt	#shoot2

	callr	drone_pass
	jrnz	#x			;Pass OK?

	movk	>1f,a0
	callr	rnd
	jrnz	#x			;97%?
	jruc	#shoot2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

#shootrnd
	move	@game_time,a1,L
	srl	8,a1			;Remove tenths
	subk	2,a1
	jrlt	#shoot3			;Less than 2 secs?
	move	@shotimer+16,a1
	jrnz	#scok2
	move	@shotimer,a1
	subk	2,a1
	jrlt	#shoot3			;Less than 2 secs?
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
	cmpi	80,a0
	jrlt	#goa			;Teammate too close?

	callr	drone_pass
	jrnz	#x			;Pass OK?

#goa
	movi	drnzzcnt,a2
	move	*a2,a0
	subk	1,a0
	jrgt	#zzsame

	move	*a13(plyr_dirtime),a0
	subk	8,a0
	jrle	#zz			;Too little time in dir?

	move	*a13(plyr_attrib_p),a0,L
	move	*a0(PAT_BVEL),a0	;Speed
	cmpi	BV5,a0
	jrle	#zz			;Too slow?

;	movk	1,a0			;50% spin move
;	callr	rnd
;	jrnz	#zz

	movk	2,a0
	move	a0,*a13(plyr_tbutn)

	callr	drone_seek
	ori	BUT3_M<<8|BUT3_M,a0	;Turbo
	move	a0,*a11

	jruc	#tryshot

#zz
	movk	5,a0			;New mode
	callr	rndrng0
	ANDK	3,a0
	move	a0,*a2(drnzzmode-drnzzcnt)

	movi	TSEC-10,a0
	callr	rndrng0
	addk	28,a0
#zzsame
	move	a0,*a2

	callr	drone_seek
;	jrz	#shoot2			;In position?
	sll	3,a0			;*8
	addi	#jbits_t,a0

	move	*a2(drnzzmode-drnzzcnt),a14
	sll	4+3,a14			;*16*8
	add	a14,a0
	movb	*a0,a0
	move	a0,*a11

	move	*a8(OZPOS),a1

	btst	JOYU_B,a0
	jrz	#nju
	cmpi	CZMIN+40,a1
	jrle	#xzmd			;Flip to other circle mode?
#nju
	btst	JOYD_B,a0
	jrz	#njd
	cmpi	CZMAX-40,a1
	jrlt	#njd
#xzmd
	move	*a2(drnzzmode-drnzzcnt),a3
	movk	1,a14
	xor	a14,a3
	and	a14,a3
	move	a3,*a2(drnzzmode-drnzzcnt)
#njd

	cmpi	80,a4
	jrlt	#shoot2			;Close enough for jam?

	jruc	#tryshot

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

#runath					;>I have a clr path to hoop!
;	move	*a13(plyr_o1dist),a14
;	cmpi	65,a14
;	jrlt	#goa			;He's too close?
;	move	*a13(plyr_o2dist),a14
;	cmpi	65,a14
;	jrlt	#goa			;He's too close?

	callr	drone_seek
	move	*a13(plyr_d_skill),a14
	addk	7,a14
	jrle	#tryshot		;Dumb?
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

	callr	drone_chk3ptr
	jrnz	#shoot2			;Need a 3?

	cmpi	255,a4
	jrge	#x			;Too far?

	move	*a13(plyr_tmproc_p),a0,L
	move	*a0(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrnz	#pass			;Alleyoop?


	move	@balltmshotcnt,b0
	subk	TMFIRE_MINCNT-1,b0
	jrne	#notmheat		;None heating up?

	move	@balltmscored,a1
	srl	5,a1			;0=Tm2, 1=Tm1
	move	*a13(plyr_num),a0
	srl	1,a0
	cmp	a0,a1
	jreq	#notmheat		;!My tm?

	movi	200,a0
	jruc	#rndsht
#notmheat

	movi	50,a0
	move	*a13(plyr_d_skill),a14
	addk	7,a14
	jrgt	#rndsht			;Smarter?
	movk	30,a0
#rndsht
	callr	rndrng0
	move	a0,a0
	jrnz	#x


#shoot2
	move	*a13(plyr_tmproc_p),a0,L
	move	*a0(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrz	#shoot3			;No alleyoop?
#pass
	move	*a11,a0			;>Pass
	ori	BUT2_M<<8|BUT2_M|BUT3_M,a0
	move	a0,*a11

	jruc	#x

#shoot3
	move	*a11,a0			;>Shoot
	ori	BUT1_M<<8|BUT1_M|BUT3_M,a0
	move	a0,*a11
;	movk	1,a0			;Max fakes
;	move	a0,*a13(plyr_d_seekcnt)

	jruc	#x


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Jumping but still on gnd

#fake
;	move	*a13(plyr_d_seekcnt),a2
;	jrle	#x			;No fakes?

	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrnz	#x			;Teammate is a human?

	move	*a13(plyr_o1dist),a14
	cmpi	80,a14
	jrlt	#fkc			;He's close?

	move	*a13(plyr_o2dist),a14
	cmpi	80,a14
	jrge	#x			;He's far?
#fkc
	movk	>1f,a0
	callr	rnd
	jrnz	#x

	move	*a9(pld_d_lowsecagr),a14
	move	@game_time,a1,L
	srl	8,a1			;Remove tenths
	cmp	a14,a1
	jrlt	#x			;Less than x secs?
	move	@shotimer+16,a1		;Tens
	jrnz	#fk
	move	@shotimer,a1		;Ones
	cmp	a14,a1
	jrlt	#x			;Less than x secs?
#fk
;	subk	1,a2
;	move	a2,*a13(plyr_d_seekcnt)
	jruc	#kilbuts

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

#injmp
	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrz	#tmdrn			;Teammate is a drone?

	move	*a13(plyr_tmproc_p),a0,L
	move	*a0(PA11),a0,L
	move	*a0,a0			;Get teammates ctrl bits
	btst	BUT1_B,a0
	jrnz	#x			;Holding shoot button?
	jruc	#kilbuts
#tmdrn
	move	*a13(plyr_seqflgs),a0
	btst	BLOCKREB_B,a0
	jrnz	#kilbuts		;Got a rebound?

	btst	DUNK_B,a0
	jrz	#nodnk			;Try alleyoop?

	move	@game_time,a1,L
	srl	8,a1			;Remove tenths
	subk	2,a1
	jrlt	#shoot3			;Less than 2 secs?
	move	@shotimer+16,a1		;Tens
	jrnz	#nodnk
	move	@shotimer,a1		;Ones
	subk	2,a1
	jrlt	#shoot3			;Less than 2 secs?
#nodnk

	move	*a13(plyr_tmproc_p),a0,L
	move	*a0(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrnz	#pss			;Try alleyoop?


	move	*a13(plyr_num),a2	;>Chk for close blockers
	srl	1,a2
	XORK	1,a2
	sll	6,a2			;*64
	addi	plyrobj_t,a2

	move	*a2+,a3,L

	move	*a13(plyr_o1dist),a14
	cmpi	70,a14
	jrgt	#o1sdok			;He's too far?

	move	*a3(OYPOS),a0
	addk	20,a0
	move	*a8(OYPOS),a1
	cmp	a0,a1
	jrgt	#rndrel			;I'm lower?
#o1sdok
	move	*a13(plyr_o2dist),a14
	cmpi	70,a14
	jrgt	#kilbuts		;He's too far? Shoot

	move	*a2+,a3,L

	move	*a3(OYPOS),a0
	addk	20,a0
	move	*a8(OYPOS),a1
	cmp	a0,a1
	jrle	#kilbuts		;I'm higher, so shoot?

#rndrel
	movk	30,a0
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
#pss
	callr	drone_pass

	jruc	#x

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


#kilbuts
	clr	a0			;>Let go of shoot button
	move	a0,*a11

#x
	rets


#jbits_t
	.byte	0,JOYL_M,JOYR_M,0			;90~ clockwise
	.byte	JOYD_M,JOYD_M|JOYL_M,JOYD_M|JOYR_M,0
	.byte	JOYU_M,JOYU_M|JOYL_M,JOYU_M|JOYR_M,0
	.byte	0,0,0,0

	.byte	0,JOYR_M,JOYL_M,0			;90~ cntr clkwise
	.byte	JOYU_M,JOYU_M|JOYR_M,JOYU_M|JOYL_M,0
	.byte	JOYD_M,JOYD_M|JOYR_M,JOYD_M|JOYL_M,0
	.byte	0,0,0,0

	.byte	0,JOYD_M|JOYL_M,JOYU_M|JOYR_M,0		;135~ clkwise
	.byte	JOYD_M|JOYR_M,JOYD_M,JOYR_M,0
	.byte	JOYU_M|JOYL_M,JOYL_M,JOYU_M,0
	.byte	0,0,0,0

	.byte	0,JOYD_M|JOYR_M,JOYU_M|JOYL_M,0		;135~ cntr clkwise
	.byte	JOYU_M|JOYR_M,JOYR_M,JOYU_M,0
	.byte	JOYD_M|JOYL_M,JOYD_M,JOYL_M,0
	.byte	0,0,0,0


#*******************************
* Check if this drone needs a 3 ptr
* A4 = Distance from opponents hoop
*>A0 = !0 if needed (CC)
* Trashes scratch

 SUBRP	drone_chk3ptr

	cmpi	290,a4
	jrgt	#x0			;Too far?

	move	*a13(plyr_num),a1
	move	@PSTATUS,a0		;Plyr start bits 0-3
	movk	1,a14
	xor	a14,a1
	btst	a1,a0
	jrnz	#x0			;Teammate is a human?

	xor	a14,a1
	move	@plyr_onfire,a0
	btst	a1,a0
	jrnz	#x1			;I'm on fire?

	cmpi	230,a4
	jrlt	#x0			;Too close?

	XORK	2,a1
	btst	a1,a0
	jrnz	#x0			;Opp 1 on fire?
	XORK	1,a1
	btst	a1,a0
	jrnz	#x0			;Opp 2 on fire?


	movk	6,a1
	move	@game_time,a0,L
	cmpi	>1010000,a0
	jrgt	#hvtime			;Enough time?
	movk	3,a1
#hvtime
	move	*a13(plyr_ptsdown),a14
	cmp	a1,a14
	jrlt	#x0

	cmpi	>40000,a0
	jrlt	#x1			;Less than 40 secs?

	move	*a13(plyr_o1dist),a14
	cmpi	70,a14
	jrlt	#rndsht			;He's close?
	move	*a13(plyr_o2dist),a14
	cmpi	70,a14
	jrge	#x1			;He's far?
#rndsht
	movk	8,a0
	callr	rndrng0
	move	a0,a0
	jrnz	#x0

#x1
	addk	1,a0
	rets
#x0
	clr	a0
	rets


#*******************************
* Drone in offense with out ball
* A8 = *Obj
* A9 = *Plyr secondary data
* A11= *Ctrl bits
* A13= *Plyr process
* Trashes scratch, A2-A5

 SUBRP	drone_offwoball

	clr	a0
	move	a0,*a13(plyr_d_cflgs)

	callr	drone_getcurskillo
	move	a0,a5				;A5=Skill offset


	movk	1,a4				;A4=Fire flag (+=Me, -=Tm)
	move	*a13(plyr_num),a0
	move	@plyr_onfire,a1
	btst	a0,a1
	jrnz	#mefr				;I'm on fire?

	subk	2,a4				;=-1

	XORK	1,a0
	btst	a0,a1
	jrnz	#mefr				;Tm on fire?
	clr	a4
#mefr


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	move	*a13(plyr_d_mode),a14
	subk	1,a14
	jreq	#inmd				;Already in mode?

	movk	1,a0				;Offense wo ball
	move	a0,*a13(plyr_d_mode)

	move	a5,a0
	addi	#mdsk_t,a0
	move	*a0,a0
	callr	rndrng0
	addk	1,a0
	move	a0,*a13(plyr_d_seekcnt)
#inmd
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


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

	move	a5,a14
	addi	#p_t,a14
	move	*a14,a1

	TEST	a4
	jrle	#pshnf				;No fire?
	addk	30,a1				;Push alot more!
#pshnf
	move	@balltmshotcnt,b0
	subk	TMFIRE_MINCNT-1,b0
	jrlt	#noth				;None heating up?
	addk	20,a1				;Push more!
#noth
	cmp	a1,a0
	jrge	#newseek			;Skip push?

	.if	NOPUSHSTEAL
	jruc	#x
	.endif

	move	*a11,a0				;Push
	ori	BUT2_M<<8|BUT2_M|BUT3_M,a0
	move	a0,*a11

	jruc	#x

#nopush
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ				>Try dunk wo ball

	move	*a13(plyr_ohpdist),a3
	cmpi	65,a3
	jrle	#noalyo				;Too close?
	cmpi	180,a3
	jrgt	#noalyo				;Too far?

	TEST	a4
	jrnz	#noalyo				;We on fire?

	move	a5,a14
	addi	#aly_t,a14
	move	*a14,a2

	move	*a13(plyr_tmproc_p),a1,L
	move	*a1(plyr_seqflgs),a14
	btst	DUNK_B,a14
	jrz	#norm				;Tm not dunking?

	move	*a1(plyr_slam_ticks),a14
	move	*a1(plyr_jmpcnt),a1
	sub	a1,a14
	subk	20,a14
	jrle	#noalyo				;Not enough time?

;	clr	a0
#norm
	move	*a13(plyr_d_seeky),a0
	cmpi	CZMID+1,a0
	jrne	#rndaly				;!in allyo seek?

	callr	drone_seek
	ori	BUT1_M<<8|BUT1_M|BUT3_M,a0	;Turbo shoot
	move	a0,*a11

;	move	*a13(plyr_tbutn),a0
;	subk	30,a0
;	jrle	#x

	jruc	#x

#rndaly
	move	@balltmshotcnt,b0
	subk	TMFIRE_MINCNT-1,b0
	jrlt	#notmheat			;None heating up?

;	move	@balltmscored,a1
;	srl	5,a1				;0=Tm2, 1=Tm1
;	move	*a13(plyr_num),a0
;	srl	1,a0
;	cmp	a0,a1
;	jreq	#notmheat			;!My tm?

	sll	2,a2				;% * 2
#notmheat

	movi	99,a0
	callr	rndrng0
	cmp	a2,a0
	jrge	#noalyo

	cmpi	80,a3
	jrle	#noalyo				;Too close?

	move	*a13(plyr_PDATA_p),a1,L
	move	*a1(ply_turbo),a14
	subk	3,a14
	jrle	#noalyo				;No turbo?

	move	*a13(plyr_ohoopx),a0
	movi	CZMID+1,a1
	move	a0,*a13(plyr_d_seekx)
	move	a1,*a13(plyr_d_seeky)

	callr	drone_seekxy

	jruc	#x

#noalyo

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ				>Seek

;	movi	>7f,a0
;	callr	rnd
;	jrz	#newseek

	move	*a13(plyr_d_seeky),a0
	cmpi	CZMID+1,a0
	jreq	#newseek			;Failed allyo?

	move	*a13(plyr_d_seekcnt),a0
	subk	1,a0
	jrgt	#seek

#newseek
;	move	*a13(plyr_newdir),a0
;	jrnn	#contsk				;Turning?

	movk	16-1,a0

	TEST	a4
	jrle	#no3				;I'm not on fire?
	movk	7-1,a0
#no3
	.if	ONLY3
	movk	7-1,a0
	.endif

	callr	rndrng0
	sll	5,a0				;*32
	addi	#seek_t,a0

	move	*a0+,a1

	move	*a13(plyr_ohoopx),a14
	cmpi	WRLDMID,a14
	jrlt	#lft
	neg	a1
#lft
	add	a1,a14
	move	a14,*a13(plyr_d_seekx)

	move	*a0+,a1
	move	a1,*a13(plyr_d_seeky)

	movi	TSEC*3/2,a0
	callr	rndrng0
	addk	TSEC/2,a0

#seek
	move	a0,*a13(plyr_d_seekcnt)
#contsk
	callr	drone_seek
	jrnz	#notthere

	movk	>1f,a0				;3%
	callr	rnd
	jrnz	#x

	clr	a0
	move	a0,*a13(plyr_d_seekcnt)

#notthere
	TEST	a4
	jrle	#notur				;I'm not on fire?

	move	*a11,a0
	ori	BUT3_M,a0			;+turbo
	move	a0,*a11
#notur

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

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

	.asg	10,N
#aly_t					;% to jump at backboard
	.word	1,2,3,4,5
	.word	N+05,N+10,N+15,N+15,N+20
	.word	N+20,N+20,N+20,N+22,N+25
	.word	N+25
	.word	N+25,N+26,N+28,N+30,N+35
	.word	N+40,N+45,N+50,N+55,N+60
	.word	N+65,N+70,N+75,N+90,N+99


	.asg	CZMID,Z
#seek_t
	.word	0,Z-150, 80,Z-150, 200,Z-100	;3ptrs
	.word	255,Z
	.word	200,Z+115, 80,Z+190, 0,Z+190

	.word	0,Z-100, 50,Z-90, 100,Z-80	;2ptrs
	.word	150,Z
	.word	100,Z+100, 50,Z+110, 0,Z+120

	.word	30,Z-40, 30,Z+40


#*******************************
* Drone code - pass if clear
* A8  = *Obj
* A11 = *Ctrl bits
* A13 = *Plyr process
*>A0 = !0 if pass OK (CC)
* Trashes scratch

 SUBRP	drone_pass

	move	@PSTATUS,a0			;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrnz	#x				;Teammate is a human?

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	move	*a13(plyr_tmdist),a0
	addk	30,a0

	move	*a13(plyr_o1dist),a1		;>Chk if o1 in my way
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
#dsml
	subk	16,a1
	jrlt	#inway
#o1ok

	move	*a13(plyr_o2dist),a1		;>Chk if o2 in my way
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
#dsml2
	subk	16,a1
	jrlt	#inway
#o2ok

	move	@ballnumscored,b0
	subk	ONFIRE_MINCNT-1,b0
	jrlt	#noheat				;None heating up?

	move	@ballpnumscored,a1
	move	*a13(plyr_num),a0
	cmp	a0,a1
	jrne	#noheat				;!Me?

	move	*a13(plyr_ohpdist),a0
	cmpi	350,a0
	jrlt	#x				;Too close? Don't pass
#noheat

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
#iwpass
	move	*a13(plyr_tmproc_p),a1,L
#tmclos
	move	*a1(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrnz	#pass				;Tm dunking?

	move	*a1(plyr_seq),a0
	subk	RUNDRIBTURB_SEQ,a0
	jrhi	#x				;Tm is doing something?
#pass
	move	*a11,a0				;>Pass
	ori	BUT2_M<<8|BUT2_M|BUT3_M,a0
	move	a0,*a11

	rets

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

#inway
	move	@ballnumscored,b0
	subk	ONFIRE_MINCNT-1,b0
	jrlt	#noheatiw			;None heating up?

	move	@ballpnumscored,a1
	move	*a13(plyr_num),a0
	XORK	1,a0
	cmp	a0,a1
	jrne	#noheatiw			;!Tm?

	move	*a13(plyr_tmproc_p),a1,L
	move	*a1(plyr_ohpdist),a0
	cmpi	300,a0
	jrlt	#iwpass				;He's Close? Risk pass

#noheatiw
	move	*a13(plyr_ohpdist),a1
	cmpi	250,a1
	jrlt	#x				;I'm close to hoop?

	move	*a13(plyr_tmproc_p),a1,L
	move	*a1(plyr_ohpdist),a0
	cmpi	240,a0
	jrlt	#tmclos				;Teammate is close to hoop?

#x
	clr	a0
	rets



#*******************************
* Drone code - defense
* A8 = *Obj
* A9 = *Plyr secondary data
* A11= *Ctrl bits
* A13= *Plyr process

 SUBRP	drone_defense

	PUSH	a6,a7,a10

	clr	a0
	move	a0,*a13(plyr_d_cflgs)


	move	@ballpnum,a5
	sll	5,a5
	addi	plyrproc_t,a5
	move	*a5,a5,L		;A5=*Proc of opponent with ball


	callr	drone_getcurskillo
	move	a0,a7			;A7=Ptsdn+skill for indexing (*16)


	movk	1,a6			;A6=Fire flag (+=Me, -=Tm)
	move	*a13(plyr_num),a0
	move	@plyr_onfire,a1
	btst	a0,a1
	jrnz	#mefr			;I'm on fire?

	subk	2,a6			;=-1

	XORK	1,a0
	btst	a0,a1
	jrnz	#mefr			;Tm on fire?
	clr	a6
#mefr


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Mode

	move	*a13(plyr_d_mode),a14
	jrn	#inmd			;Already in mode?

	not	a14
	move	a14,*a13(plyr_d_mode)	;Neg

	move	a7,a14
	addi	#mdsk_t,a14
	move	*a14,a0
	move	a0,a2
	srl	2,a2			;/4

	callr	rndrng0
	addk	1,a0
	add	a2,a0
	move	a0,*a13(plyr_d_seekcnt)

	clr	a0
	move	a0,*a9(pld_d_nastycnt)

	movk	30,a0
	callr	rndrng0

	addi	190-20,a0
	move	a0,*a9(pld_d_grddist)
#inmd

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Update nasty mode

	move	*a9(pld_d_lowsecagr),a0

	movk	2,a10
	move	@game_time,a14,L
	srl	8,a14			;Remove tenths
	cmp	a0,a14
	jrlt	#nasty			;Less than x secs?

	move	@gmqrtr,a2
	subk	3,a2
	jrlt	#chkst
	move	*a13(plyr_ptsdown),a1
	addk	3,a1
	jrle	#chkst			;Winning by 3 or more?
	srl	8,a14			;Remove ones
	sll	1,a14			;*2
	cmp	a0,a14
	jrlt	#nasty			;Less than x0 secs?
#chkst
	move	@shotimer+16,a14	;Tens
	jrnz	#scok
	move	@shotimer,a14		;Ones
	srl	1,a0			;/2
	cmp	a0,a14
	jrlt	#nasty			;Less than x secs?
#scok
	move	*a9(pld_d_nastycnt),a10
	jrgt	#naston

	movk	10,a10
	movi	0ffh,a0
	callr	rnd
	jrz	#nasty

	clr	a10

	movi	999,a0
	callr	rndrng0

	move	a7,a14
	addi	#nast_t,a14
	move	*a14,a1
	cmp	a1,a0
	jrge	#nonast			;No nasty?

	movi	TSEC-20,a0
	callr	rndrng0
	addk	20,a0
	move	a0,a10
#naston
	subk	1,a10
#nasty
	move	a10,*a9(pld_d_nastycnt)

	cmpi	10,a10
	jreq	#newsk
#nonast

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	move	*a13(plyr_d_seekcnt),a0
	subk	1,a0
	jrgt	#seek
#newsk
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

;	move	*a5(plyr_seqflgs),a0
;	btst	DUNK_B,a0
;	jrnz	#gbc			;He's dunking?

	move	*a13(plyr_tmproc_p),a3,L
	move	*a3(plyr_seq),a0
	subi	STAGGER_SEQ,a0
	jrls	#tmok
	subk	FLYBACKWB2_SEQ-STAGGER_SEQ,a0
	jrls	#gbc			;Teammate staggered?
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
	jrle	#guard			;TM guarding?

#gbc
	move	a5,a4			;Guard ball carrier
#guard

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Seek

	move	*a4(PA8),a2,L		;*Obj

	move	*a2(OXPOS),a0
	move	*a2(OXANI+16),a14
	add	a14,a0			;X
	move	*a2(OZPOS),a1		;Z

	move	*a2(OXVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a0
	move	*a2(OZVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a1


	TEST	a10
	jrgt	#setseek		;Nasty on?


	move	*a5(plyr_seqflgs),a14
	btst	SHOOT_B,a14
	jrz	#nosh			;!Starting a shot?

	TEST	a6
	jrgt	#nosh			;I'm on fire?

	move	*a13(plyr_balldist),a14
	cmpi	70,a14
	jrle	#setseek		;In his face?

#nosh
	move	*a13(plyr_myhoopx),a2	;Stay near oplyr between my basket
	movi	CZMID,a3

	sub	a2,a0
	sub	a3,a1

	move	*a9(pld_d_grddist),a14

	TEST	a6
	jrle	#nofire			;I'm not on fire?

	movi	77,a14			;30%

	move	a4,b0
	move	*b0(plyr_ohpdist),b0
	cmpi	400,b0
	jrge	#nofire			;Opp far from my hoop?
	movi	154,a14			;60%
#nofire
	mpys	a14,a1
	sra	8,a1			;/256
	add	a1,a3

	move	a0,a1
	mpys	a14,a1
	sra	8,a1			;/256
	add	a1,a2

	move	a2,a0
	move	a3,a1

#setseek
	move	a0,*a13(plyr_d_seekx)
	move	a1,*a13(plyr_d_seeky)

	movk	25,a0
	move	*a4(plyr_ohpdist),a1
	cmpi	320,a1
	jrge	#seek			;Opp far from my hoop?

	move	a7,a14
	addi	#skt_t,a14
	move	*a14,a0
	srl	1,a0			;/2
	move	a0,a2
	callr	rndrng0
	add	a2,a0

#seek
	move	a0,*a13(plyr_d_seekcnt)

	callr	drone_seek
	move	a0,a2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Turbo if opp closer to my basket

	move	*a13(plyr_num),a14	;>Get opponents proc
	addk	2,a14
	sll	32-2,a14
	srl	32-2-5,a14		;*32
	addi	plyrproc_t,a14
	move	*a14,a0,L

	move	*a0(plyr_ohpdist),a0
	subk	10,a0
	cmpi	300,a0
	jrgt	#onclose		;!close?
	subi	60,a0			;Turbo earlier
#onclose
	move	*a13(plyr_hpdist),a1
	cmp	a0,a1
	jrlt	#icloser

	TEST	a2
	jrz	#icloser		;I'm not moving?
	addi	BUT3_M,a2		;Turbo
#icloser

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Push/steal

	move	*a13(plyr_balldist),a1
	cmpi	35,a1
	jrgt	#psrnd			;!In his face?

	move	@PCNT,a0
	sll	32-1,a0
	jrnz	#skipsp			;Skip 50%?

	move	a10,a10
	jrgt	#ps			;Nasty on?

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
	movk	1,a0
	callr	rnd
	jrnz	#push			;50%?


	move	*a5(plyr_jmpcnt),a1
	jrnz	#push			;Plyr with ball is in air?

	sll	32-4,a2
	srl	32-4,a2
	addk	BUT2_M,a2		;Steal
	jruc	#x

#push
	move	*a5(PA8),a0,L
	move	*a0(OYPOS),a1
	move	*a5(plyr_aniy),a14
	add	a14,a1			;His feet Y position
	move	*a8(OYPOS),a0
	sub	a1,a0
	addk	10,a0
	jrgt	#skipsp			;Feet above my shoulders?

	ori	BUT2_M<<8|BUT2_M|BUT3_M,a2
	jruc	#x

#skipsp

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Chk if I can block ball

	move	*a13(plyr_balldist),a14
	cmpi	65,a14
	jrge	#noblk

	move	*a5(plyr_seqflgs),a4


	btst	DUNK_B,a4
	jrz	#nodnk

	cmpi	35,a14
	jrgt	#noblk

	move	*a13(plyr_tmproc_p),a3,L

	move	*a3(plyr_balldist),a14
	cmpi	45,a14
	jrgt	#tryblk			;Teammate far?

	move	*a3(plyr_jmpcnt),a1
	jrz	#tryblk			;Tm on gnd?

	move	@PCNT,a0
	sll	32-3,a0
	jrnz	#noblk			;Skip 88%?

	jruc	#tryblk

#nodnk
	btst	SHOOT_B,a4
	jrz	#noblk			;!Starting a shot?

	move	*a5(plyr_jmpcnt),a1
	jrnz	#tryblk			;Plyr with ball is in air?

	movk	11,a0
	callr	rndrng0
	TEST	a0
	jrnz	#noblk			;92% ignore?
	jruc	#blk

#tryblk
	movi	99,a0
	callr	rndrng0
	move	a7,a14
	addi	#blk_t,a14
	move	*a14,a1

	btst	DUNK_B,a4
	jrz	#nd
	sra	1,a1			;Dunk % /2
#nd
	TEST	a10
	jrle	#nstoff			;Nasty off?
	sll	1,a1			;%*2
#nstoff
	cmp	a1,a0
	jrge	#noblk

#blk
	sll	32-4,a2
	srl	32-4,a2
	addi	BUT1_M<<8|BUT1_M|BUT3_M,a2 ;Block
#noblk

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
#x
	.if	NOPUSHSTEAL
	andi	0dfh,a2
	.endif

	move	a2,*a11


	PULL	a6,a7,a10
	rets


#mdsk_t					;Mode switch max seek time
	.word	50,50,50,50,50		;Up 15-11
	.word	50,50,45,45,40		;10-6
	.word	33,25,22,18,16		;5-1
	.word	14			;Even score
	.word	10,8,6,4,4		;Dn 1-5
	.word	4,3,3,3,2		;6-10
	.word	2,2,2,2,1		;11-15

	.asg	0,N
#nast_t					;% to become nasty
	.word	0,0,0,0,0
	.word	N+1,N+1,N+2,N+2,N+2
	.word	N+3,N+3,N+3,N+4,N+5
	.word	N+5
	.word	N+6,N+7,N+8,N+9,N+10
	.word	N+12,N+13,N+14,N+15,N+16
	.word	N+18,N+20,N+24,N+28,N+30

	.asg	25,N
#skt_t					;Max seek time (75% avrg)
	.word	N+55,N+55,N+55,N+55,N+52
	.word	N+48,N+44,N+40,N+36,N+33
	.word	N+30,N+29,N+28,N+27,N+26
	.word	N+25			;Even score
	.word	N+24,N+23,N+21,N+19,N+17
	.word	N+14,N+11,N+08,N+06,N+03
	.word	N+01,N-01,N-03,N-05,N-10
#dist_t					;Max dist to try push/steal
	.word	110,100,100,100,100
	.word	90,90,80,80,80
	.word	80,70,70,60,60
	.word	60
	.word	50,50,50,50,50
	.word	50,50,50,50,50
	.word	50,50,50,50,50
#ps_t					;% to push/steal
	.word	1,2,2,2,2
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
* Setup drones for ball takeout
* Trashes scratch

 SUBR	drone_setuptob

	PUSH	a2,a3,a4,a13

	movk	4,a4
	movi	plyrproc_t,a3

#lp
	move	*a3+,a13,L
	move	*a13(PA9),a2,L

	movk	1,a0
	move	*a13(plyr_ownball),a14
	jrz	#def			;Defense?
					;>Setup offense
	jrn	#wob
	movk	2,a0
#wob
	move	a0,*a13(plyr_d_mode)

	movi	TSEC-10,a0
	callr	rndrng0
	addk	5,a0
	move	a0,*a13(plyr_d_seekcnt)

	movk	9-1,a0
	callr	rndrng0
	sll	5,a0			;*32
	addi	#seek_t,a0

	move	*a0+,a1
	move	*a13(plyr_num),a14
	subk	2,a14
	jrlt	#lft
	neg	a1
#lft
	addi	WRLDMID,a1
	move	a1,*a13(plyr_d_seekx)

	move	*a0+,a1
	move	a1,*a13(plyr_d_seeky)

	jruc	#nxt


#def					;>Setup defense
	movi	-1,a14
	move	a14,*a13(plyr_d_mode)	;Defense

	clr	a0
	move	a0,*a2(pld_d_nastycnt)

	movi	190,a0
	move	a0,*a2(pld_d_grddist)

	movk	4,a0
	callr	rndrng0
	addk	5,a0
	move	a0,*a2(pld_d_lowsecagr)	;5-9

	callr	drone_getcurskillo

	addi	#mdsk_t,a0
	move	*a0,a0
	callr	rndrng0
	addk	1,a0
	move	a0,*a13(plyr_d_seekcnt)

#nxt
	dsj	a4,#lp

	PULL	a2,a3,a4,a13
	rets


	.asg	CZMID,Z
#seek_t
	.word	-260,Z-160, -200,Z-150,	-100,Z-130, -50,Z-100
	.word	0,Z
	.word	-260,Z+160, -200,Z+150,	-100,Z+130, -50,Z+100


#mdsk_t					;Mode switch max seek time
	.word	30,30,30,25,25		;Up 15-11
	.word	25,25,20,20,20		;10-6
	.word	20,18,16,14,12		;5-1
	.word	10			;Even score
	.word	8,7,6,5,4		;Dn 1-5
	.word	4,3,3,2,2		;6-10
	.word	2,1,1,1,1		;11-15


#*******************************
* Drone code - nobody has ball
* A8 = *Obj
* A11= *Ctrl bits
* A13= *Plyr process

 SUBRP	drone_chaseball

	move	*a13(plyr_rcvpass),a14
	jrgt	drone_offwoball		;I'm rcving ball?

	move	*a13(plyr_tmproc_p),a4,L
	move	*a4(plyr_rcvpass),a14
	jrgt	drone_offwoball		;Teammate rcving ball?


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Mode

	clr	a0
	move	a0,*a13(plyr_d_cflgs)

	move	*a13(plyr_d_mode),a14
	jrz	#inmd			;Already in mode?

	move	a0,*a13(plyr_d_mode)

	callr	drone_getcurskillo
	addi	#mdsk_t,a0
	move	*a0,a0

	callr	rndrng0
	addk	2,a0
	move	a0,*a13(plyr_d_seekcnt)

#inmd
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Seek

	move	*a13(plyr_d_seekcnt),a0
	subk	1,a0
	jrgt	#seek

	move	@ballobj_p,a5,L


	move	*a13(plyr_num),a14	;>Chk for pass
	srl	1,a14
	movk	1,a0
	xor	a0,a14
	sll	6,a14			;*64
	addi	plyrproc_t,a14

	move	*a14+,a1,L
	move	*a1(plyr_rcvpass),a0
	jrgt	#chaseb			;Opp rcving ball?

	move	*a14+,a1,L
	move	*a1(plyr_rcvpass),a0
	jrgt	#chaseb			;Opp rcving ball?


	move	*a4(plyr_seq),a0
	subi	STAGGER_SEQ,a0
	jrls	#tmok
	subk	FLYBACKWB2_SEQ-STAGGER_SEQ,a0
	jrls	#chaseb			;Teammate staggered?
#tmok
	move	*a4(plyr_jmpcnt),a14
	jrnz	#chaseb			;Tm in air?

	movi	CZMID,a1

;FIX! Also if team almost on fire..
	move	*a13(plyr_num),a0
	move	@plyr_onfire,a2
	btst	a0,a2
	jrz	#nof			;I'm not on fire?

	XORK	1,a0
	btst	a0,a2
	jrz	#skf			;Tm not on fire?

	move	*a13(plyr_balldist),a0
	move	*a4(plyr_balldist),a14
	cmp	a14,a0
	jrle	#chaseb			;I'm closer?
#skf
	move	*a13(plyr_myhoopx),a0	;Go in front of my hoop for goaltend
	move	a0,a14
	subi	WRLDMID,a14
	sra	4,a14			;/16
	sub	a14,a0
	jruc	#setxz

#nof
	XORK	1,a0
	btst	a0,a2
	jrnz	#chaseb			;Tm on fire? I get ball

	move	*a13(plyr_balldist),a0
	move	*a4(plyr_balldist),a14
	cmp	a14,a0
	jrle	#chaseb			;I'm closer?

	move	*a5(OYVEL+16),a0
	jrlt	#chaseb			;Going up?

	move	*a13(plyr_ohoopx),a0	;Go for opponents top of 3 pt line
	subi	WRLDMID,a0
	sra	2,a0			;/4
	addi	WRLDMID,a0
	jruc	#setxz

#chaseb
	move	*a5(OXPOS),a0
	move	*a5(OXANI+16),a14
	add	a14,a0
	move	*a5(OXVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a0

	move	*a5(OZPOS),a1
	move	*a5(OZVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a1
#setxz
	move	a0,*a13(plyr_d_seekx)
	move	a1,*a13(plyr_d_seeky)


	callr	drone_getcurskillo
	addi	#skt_t,a0
	move	*a0,a0

	callr	rndrng0
	addk	5,a0

#seek
	move	a0,*a13(plyr_d_seekcnt)

	callr	drone_seek
	jrz	#sk0
	ori	BUT3_M,a0		;Turbo
	move	a0,*a11
#sk0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			>Chk if I can jump at ball or steal


	move	*a13(plyr_balldist),a0
	cmpi	100,a0
	jrgt	#nojmp

	move	@ballobj_p,a5,L


	move	*a5(OXPOS),a0		;>Calc distance (long+short/2.667)
	move	*a5(OXANI+16),a14
	add	a14,a0
	move	*a5(OXVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a0

	move	*a5(OZPOS),a1
	move	*a5(OZVEL),a14,L
	sra	16-4,a14		;16 ticks from now
	add	a14,a1

	move	*a8(OXPOS),a2
	move	*a8(OXANI+16),a14
	add	a14,a2
	move	*a8(OZPOS),a3

	sub	a0,a2
	abs	a2
	sub	a1,a3
	abs	a3

	cmp	a2,a3
	jrge	#a3bg
	SWAP	a2,a3
#a3bg
	srl	1,a2			;Shorter/2
	add	a2,a3
	srl	2,a2			;Shorter/8
	sub	a2,a3			;A3=Dist in 16 ticks


	cmpi	60,a3
	jrgt	#nojmp


	move	@balltmshotcnt,b0
	subk	TMFIRE_MINCNT-1,b0
	jrne	#notmheat		;None heating up?

	move	@gmqrtr,b0
	subk	3,b0
	jrlt	#tmhqok			;Q123?

	move	@game_time,a14,L
	srl	8+8,a14			;Remove one & tenths
	subk	6,a14
	jrlt	#notmheat		;Less than 60 secs?
#tmhqok
	move	@balltmscored,a1
	srl	5,a1			;0=Tm2, 1=Tm1
	move	*a13(plyr_num),a0
	srl	1,a0
	cmp	a0,a1
	jrne	#ifire			;My tm?
#notmheat

	move	*a13(plyr_num),a1
	move	@plyr_onfire,a0
	btst	a1,a0
	jrnz	#ifire			;I'm on fire?

	XORK	1,a1
	btst	a1,a0
	jrz	#nofire			;Tm not on fire?
#ifire
	move	*a13(plyr_hpdist),a14
	cmpi	150,a14
	jrge	#nofire			;Too far for goaltend?

	move	*a8(OYPOS),a0
	move	*a5(OYPOS),a1
	sub	a1,a0
	subk	20,a0
	jrle	#nofire			;Ball too low?

	subi	160-20,a0
	jrgt	#nojmp			;Ball too high?

	move	*a5(OYVEL+16),a0
	jrgt	#j			;Going down? Goaltend!
	jruc	#nojmp

#nofire
	move	*a8(OYPOS),a0
	move	*a5(OYPOS),a1
	sub	a1,a0
	subk	10,a0
	jrgt	#nojmp			;Ball too high?

	addk	32,a1
	jrge	#nojmp			;Ball close to gnd?

	movk	7,a0
	callr	rnd
	jrnz	#nojmp			;87%?

	move	*a11,a2
	sll	32-4,a2
	srl	32-4,a2
	addk	BUT2_M,a2		;Steal
	move	a2,*a11
	jruc	#nojmp

#j
	move	*a11,a0			;Jmp
	ori	BUT1_M<<8|BUT1_M|BUT3_M,a0
	move	a0,*a11
#nojmp
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	rets


#mdsk_t					;Mode switch max seek time
	.word	50,50,50,50,50		;Up 15-11
	.word	50,50,40,40,40		;10-6
	.word	33,25,22,18,16		;5-1
	.word	14			;Even score
	.word	10,8,6,4,4		;Dn 1-5
	.word	4,3,3,3,2		;6-10
	.word	2,2,2,2,1		;11-15

#skt_t					;Max seek time
	.word	50,50,45,45,45
	.word	40,40,30,30,22
	.word	20,17,16,15,15
	.word	15
	.word	15,14,14,13,13
	.word	12,12,12,12,12
	.word	11,11,11,10,10


#*******************************
* Push stick to move drone towards his seek position

 SUBRP	drone_seek

	move	*a13(plyr_d_seekx),a0
	move	*a13(plyr_d_seeky),a1

#*******************************
* Push stick to move drone towards an XZ location
* A0 = X to seek
* A1 = Z
* A8 = *Obj
* A11= *Ctrl bits
*>A0 = Joy bits set or 0 (Pass CC)
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
*>A0 = Offset (0-30) *16
* Trashes scratch

 SUBRP	drone_getcurskillo

	move	*a13(plyr_ptsdown),a0
	move	*a13(plyr_d_skill),a14
	add	a14,a0


	move	*a13(plyr_num),a1
	move	@dronesmrt,a14
	btst	a1,a14
	jrz	#nosmrt			;Normal?
	addk	5,a0
#nosmrt


	move	@ballnumscored,a1
	subk	ONFIRE_MINCNT-1,a1
	jrlt	#noheat			;None heating up?

	addk	2,a0			;Get tougher

	move	@ballpnumscored,a1
	move	*a13(plyr_num),a14
	cmp	a1,a14
	jrne	#noheat			;Not me?

	addk	6,a0			;Get tougher
#noheat

	subk	15,a0
	jrle	#mxdnok
	clr	a0
#mxdnok
	addk	15+15,a0
	jrge	#dnok
	clr	a0
#dnok
	sll	4,a0			;Ptsdn+skill for indexing (*16)

	rets



#*******************************
* Adjust all drone abilities (at every minute dec of game clock)
* A0 = Game clock minute count before dec (0-2)
* Trashes scratch

 SUBR	drone_adjskill

	PUSH	a2,a3,a4,a5,a6

	move	a0,a5
	subk	2,a5
	abs	a5
	move	@gmqrtr,a1
	cmpi	3,a1
	jrls	#qok
	movk	3,a1			;Overtime
#qok
	movk	3,a0
	mpyu	a0,a1
	add	a1,a5			;A5=Quarter+minute index (0-11)


	movk	ADJDIFF,a0		;Get difficulty level
	calla	GET_ADJ			;1-5
	subk	4,a0			;-3 to 1
	move	a0,a6
	sll	1,a0			;*2
	add	a0,a6			;A6=Difficulty adj (-9,-6,-3,0,3)


	movi	plyrproc_t,a4
	movk	4,b0
#lp
	move	*a4+,a3,L

	move	*a3(plyr_d_skill),a2

	move	*a3(plyr_ptsdown),a14
	subk	15,a14
	jrle	#mxdnok
	clr	a14
#mxdnok
	addk	15+15,a14		;0-30
	jrge	#dnok
	clr	a14
#dnok
	sll	4,a14
	addi	#adj_t,a14
	move	*a14,a14
	add	a14,a2			;Modify skill

	move	a5,a14			;>Chk minute minimum
	sll	3,a14
	addi	#min_t,a14
	movb	*a14,a14
	add	a6,a14
	cmp	a14,a2
	jrge	#minok			;Min OK?
	move	a14,a2
#minok

	move	*a3(plyr_num),a1
	XORK	1,a1
	move	@PSTATUS,a14
	btst	a1,a14
	jrnz	#done			;Teammate is human?


	move	@team1,a1		;>Chk team minimum
	cmpi	3,b0
	jrge	#t1
	move	@team2,a1
#t1
	cmpi	29,a1
	jrlo	#tnumok
	movk	1,a1
#tnumok
	movk	12,a0
	mpyu	a0,a1

	add	a5,a1
	sll	3,a1			;*8
	addi	#tdmin_t,a1
	movb	*a1,a14
	add	a6,a14
	cmp	a14,a2
	jrge	#tminok
	move	a14,a2
#tminok
	addk	8,a14			;Max
	cmp	a14,a2
	jrle	#tmaxok
	move	a14,a2
#tmaxok
#done
	move	a2,*a3(plyr_d_skill)

	dsj	b0,#lp


	PULL	a2,a3,a4,a5,a6
	rets


#adj_t	.word	-5,-5,-5,-5,-5
	.word	-5,-5,-5,-4,-3
	.word	-2,-1,-1,0,0
	.word	0
	.word	0,1,1,2,2
	.word	3,3,4,4,5
	.word	5,6,6,6,7

#min_t	.byte	-15,-12,-10, -9,-8,-7, -7,-6,-6, -6,-6,-6

TMDIFF	.macro
	.byte	-10,-9,-8, -8,-7,-7, -6,-6,-5, -5,-5,-5
	.endm
#tdmin_t
	.byte	-6,-5,-5, -4,-3,-3, -2,-2,-2, -1, 0,-1	;ATL (11)
	TMDIFF						;BOS
	.byte	-7,-7,-6, -6,-5,-5, -4,-4,-3, -3,-2,-3	;CHA (14)
	.byte	6,7,7, 8,9,9, 10,10,11, 11,13,12	;CHI (1)
	.byte	-6,-5,-5, -4,-3,-3, -2,-2,-2, -1, 0,-1	;CLE (10)
	TMDIFF						;DAL
	.byte	-9,-8,-8, -7,-7,-6, -6,-5,-4, -4,-3,-4	;DEN (20)
	.byte	-6,-5,-5, -4,-3,-3, -2,-2,-2, -2,-1,-2	;DET (12)
	.byte	-9,-8,-8, -7,-7,-6, -6,-5,-4, -4,-3,-4	;GOL (18)
	.byte	-1,-1,0, 1,1,1, 2,2,2, 3,4,3		;HOU (6)
	.byte	-4,-3,-3, -2,-1,-1, 0,0,0, 1,2,1	;IND (8)
	TMDIFF						;LAC
	.byte	-5,-4,-4, -3,-2,-2, -1,-1,-1, 0,1,0	;LAL (9)
	.byte	-8,-8,-7, -7,-6,-6, -5,-4,-3, -3,-2,-3	;MI  (17)
	TMDIFF						;MIL
	TMDIFF						;MIN
	TMDIFF						;NJ
	.byte	-3,-2,-2, -1,0,0, 1,1,1, 2,3,2		;NY  (7)
	.byte	4,4,4, 4,4,5, 5,5,7, 7,8,7		;ORL (3)
	TMDIFF						;PHI
	.byte	-8,-8,-7, -7,-6,-6, -5,-4,-3, -3,-2,-3	;PHX (16)
	.byte	-7,-7,-6, -6,-5,-5, -4,-4,-3, -3,-2,-3	;POR (15)
	.byte	-6,-5,-5, -4,-3,-3, -3,-2,-2, -2,-1,-2	;SAC (13)
	.byte	1,1,1, 2,2,2, 3,3,3, 4,5,4		;SAN (5)
	.byte	4,4,5, 5,6,6, 7,7,7, 7,9,8		;SEA (2)
	TMDIFF						;TOR
	.byte	2,2,2, 3,3,3, 4,4,4, 5,6,5		;UTA (4)
	TMDIFF						;VAN
	.byte	-9,-8,-8, -7,-7,-6, -6,-5,-4, -4,-3,-4	;WAS (19)
	.even


********************************
* Get random # with mask
* A0 = Mask
*>A0 = Rnd # (Pass CC)
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
* A0 = X
*>A0 = Random # (0 to A0) (No CC)
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



********************************

	.end

