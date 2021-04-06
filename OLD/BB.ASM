**************************************************************
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		7/17/90
*
* Modified:		Shawn Liptak, 1/27/92	-Started basketball
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/24/93 14:35
**************************************************************
	.file	"bb.asm"
	.title	"NBA JAM Basketball game program"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"imgtbl.glo"
	.include	"imgtblp.glo"
;	.include	"imgcrwd.glo"
	.include	"imgtbl2.glo"
	.include	"imgpalp.asm"
	.include	"imgpal2.asm"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"shawn.hdr"		;Macros
	.include	"court.tbl"
	.include	"crowd.tbl"
	.asg		0,SEQT
	.include	"plyr.equ"


;sounds external

	.ref	snd_update
	.ref	SOUNDSUP
	.ref	QSNDRST

tip_snd		.word	>f9fe,175,>818d,0	;Here's the tip
;tuneq1_snd	.word	>f3ff,>8,>8008,0	;Quarter 1 tune
tuneq1_snd	.word	>f3ff,>8,>8002,0	;Quarter 1 tune
eat_snd		.word	>f31f,>10,>80a7,0	;Suck up credit snd
organ1_snd	.word	>f3ff,>8,>80ae,0
organ2_snd	.word	>f3ff,>8,>80af,0


;symbols externally defined

	.ref	RA_H
	.ref	original_names
	.ref	fire_flags
	.ref	pal_set
	.ref	pal_find
	.ref	RNDPER
	.ref	TWOPLAYERS

	.ref	team1_control
	.ref	team2_control
	.ref	BTIME
	.ref	plyrnumonfire
	.ref	next_call			;# baskets before next score call
	.ref	last_name_time
	.ref	player_names
	.ref	CYCLE_TABLE
	.ref	pleasewt
	.ref	prt_credits
	.ref	clock_speed
	.ref	_4plyrsingame
	.ref	snd_play1ovr
	.ref	winningteam
	.ref	winner_stays_on

	.ref	plyrbighead
	.ref	idiot_bits
	.ref	cntl_team,cntl_team_last,idiot_box
	.ref	bracket_drw
	.ref	sc_proc
	.ref	ballpnumlast
	.ref	ballprcv_p
	.ref	inbound
	.ref	ballsclastp
	.ref	LED_00,LED_MAX
	.ref	process_dispatch,cntrs_delay
	.ref	gmqrtr,refill_turbo
	.ref	plyr_lost
	.ref	tm1set,tm2set

	.ref	CCOIN,RCOIN,SERVICE,SLAM_SW,XCOIN,LCOIN,DIAG

	.ref	CR_STRTP,CR_CONTP,P_START,P_CONT,GET_ADJ
	.ref	dpageflip
	.ref	conttimers
	.ref	WIPEOUT,cr_cntrs_update
	.ref	ENTERON

	.ref	LOWZ,BAKBITS
	.ref	FONT7A,PALFRAM
	.ref	UNIT_CLR
	.ref	initials_entry
	.ref	ISHSTD,INITIALS
	.ref	hisclong

	.ref	gndstat,gndpos_t
	.ref	STRCNRM
	.ref	WDOGRAM
	.ref	BAKMODS
	.ref	STRLNRMO,HEXTOASC,WRLD,STRCNRMO,RD15FONT
	.ref	FLASHME,RD7FONT
	.ref	RNDRNG0
	.ref	INIT_TAB
	.ref	IRQSKYE
	.ref	init_all,GET_AUD
	.ref	READ_DIP
	.ref	POWERTST
	.ref	FRANIM,FRANIMQ
	.ref	OBJOFF,OBJON,pal_getf
	.ref	GETCPNT,BGND_UD1
	.ref	AUD,AUD1,aud_addnumplyrs
	.ref	prt_cr_timers
;	.ref	_3d_test

	.ref	PSTATUS
	.ref	P1DATA,P2DATA,P3DATA,P4DATA
	.ref	plyrobj_t,plyrproc_t

	.ref	scores,game_time,prt_top_scores
	.ref	shot_clock,clock_strt,score_add,score_showtvpanel
	.ref	update_scorebrd
	.ref	clear_player_stats,inc_player_stat
	.ref	winner_stays_box

	.ref	plyr_start
	.ref	joy_read
	.ref	ball_main
;	.ref	gnd_aligndots
	.ref	gndx
	.ref	team1,team2
	.ref	oteam1
	.ref	game_purchased
	.ref	security_chk
	.ref	assist_delay,assist_plyr

	.ref	CKDIAG,POWERCMOS,amode_start
	.ref	dirqtimer

;	.ref	clipsrunning
;	.ref	plyr_eoq_lockcont,cliplockretp
	.ref	system_restoregame,io_init


;symbols defined in this file

;	.def	qrtr1,qrtr2,qrtr3,qrtr4
;	.def	wbmcolor_t
	.def	init_t1a,init_t2a,init_t3a,init_t4a
	.def	timertcnt,PSTATUS2,COLRPRC
	.def	OWINDOW,CWINDOW
	.def	mainlp, swstacktop, swstack_p, PCMOSRET


;uninitialized ram definitions

	.if	DEBUG
	BSSX	SLDEBUG		,16	;Shawn's debug
	BSSX	slowmotion	,16	;!0=Frames of delay for slow motion
	.endif

	BSSX	PCNT		,16	;Main loop cnt

	BSSX	swstack_p	,32	;*Stack position
	BSSX	swstackbot	,16*64	;Bottom of stack
	.bss	swstacktop	,0	;Top of stack

	BSSX	COLRTEMP	,16*16	;RAM COPY OF CYCLING COLORS

	BSSX	GAMSTATE	,16	;Game state: See game.equ

	BSSX	HALT		,16	;FREEZE ALL OBJECTS (NO VEL UPDATE)
	BSSX	NO_START	,16	;FLAG 0=OKAY, 1=NOT RIGHT NOW.

	BSSX	PSTATUS2	,16	;Player has started game bits (0-3)
					;used to decide if this player must
					;pay 2 credits or just 1 credit to
					;start!

	BSSX	WSPEED		,16
	BSSX	WFLG		,16	;0=NOT ON, 1=YES IT IS ON
	.bss	WNDWFLG		,16	;0=WINDOW SHOULD CLOSE, 1=NO WINDOW
	BSSX	OBJPTR		,32	;PNTR FOR WINDOW OBJECT


	.bss	PALTMP		,13*16*2 ;ALLOCATE 2 X COLOR AREA IN RAM

	.bss	bigcrwd1_ptr,32	;Big background crowd lft side
	.bss	bigcrwd2_ptr,32	;Big background crowd middle
	.bss	bigcrwd3_ptr,32	;Big background crowd rgt side
	.bss	rimlf,32	;rim/net left front img pntr for animation
	.bss	rimlb,32	;rim/net left back
	.bss	rimrf,32	;rim/net rgt front
	.bss	rimrb,32	;rim/net rgt back
	.bss	crwd1_ptr,32	;lower left crowd ptr at top of court
	.bss	crwd2_ptr,32	;lower row rgt side
	.bss	crwd3_ptr,32	;2nd row, left side
	.bss	crwd4_ptr,32	;2nd row, rgt side
	.bss	crwd5_ptr,32	;3nd row, left side
	.bss	crwd6_ptr,32	;3nd row, rgt side
	.bss	sl1_ptr,32	;side left botm
	.bss	sl2_ptr,32	;side left
	.bss	sl3_ptr,32	;side left
	.bss	sl4_ptr,32	;side left
	.bss	sl5_ptr,32	;side left
	.bss	sl6_ptr,32	;side left
	.bss	sl7_ptr,32	;side left
	.bss	sl8_ptr,32	;side left top

;Rgt side crowd
	.bss	sr1_ptr,32	;side rgt botm
	.bss	sr2_ptr,32	;side rgt
	.bss	sr3_ptr,32	;side rgt
	.bss	sr4_ptr,32	;side rgt
	.bss	sr5_ptr,32	;side rgt
	.bss	sr6_ptr,32	;side rgt
	.bss	sr7_ptr,32	;side rgt
	.bss	sr8_ptr,32	;side rgt top


	.bss	ad1_ptr,32   
	.bss	ad1ref_ptr,32
	.bss	ad2_ptr,32   
	.bss	ad2ref_ptr,32

	.bss	cheer1_ptr,32
	.bss	cheer2_ptr,32
;	.bss	cheer3_ptr,32

	
	BSSX	crplate_ptr	,32	;credit plate ptr
	BSSX	msg_ram		,32*4	;temp ram for flopping message/meters
	BSSX	name_cnt	,16	;Cntr for flopping to player names
	BSSX	name_flop	,16	;Flop name/buyin message 0 or 1
	BSSX	names		,32*4	;pntrs to player imgs

	BSSX	crt_colors	,32	;Random pal for court - NDSP1.ASM
	BSSX	steals_off	,16	;!0=ticks until steals can happen
	BSSX	pushing_delay 	,16	;!0=keep ball if pushed
	BSSX	pass_off	,16	;!0=Don't allow passing
	BSSX	rebound_delay	,16	;!0=Give rebound stat
	BSSX	crowd_animate	,16	;!0=Allow crowd animations

; Timer variables. Must stay in order!!

	BSSX	timertcnt	,16	;Tick count

	BSSX	qtr_purchased	,16*4	;# game qtrs credit each player has

	BSSX	newptr		,32
	BSSX	newplyrs	,32*5

;	.bss	played3d	,16


;equates for this file

GND_Y		.equ	116-40	;Master in NDSP1


	.text


****************************************************************
* Reset entry point

 SUBR	init_prog

	dint
	setf	16,1,0			;Field0 = Word sign extend
	setf	32,0,1			;Field1 = Long word
	movi	STCKST,sp		;Top of stack

	.if	DEBUG
	move	a0,@>1e00000		;Clr FPGA rom protect
	.endif

					;>Manual sound board reset
	movi	0fe00h,a0  		;Hit reset bit
	move	a0,@SOUND
      	movi	100,a0			;Wait for it to catch
	dsj	a0,$
	movi	0ff00h,a0		;Let it go
	move	a0,@SOUND

	move	@WDOGRAM,a0,L
	cmpi	WDOGNUM,a0
	jrne	initp50			;Powerup?



	move	@dirqtimer,a0
	cmpi	400,a0
	jrhs	#lockup			;Main loop died?


	.if	TUNIT
	move	@TALKPORT,a0		;Check if watchdog was real
	btst	B_WDOG,a0		;Bit should be low if dog fired
	jrnz	#cont			;No watchdog?
	.endif

	movk	AUDLOCK,a0		;Watchdog
	jruc	#aud

#lockup

	movi	AUD_LOCKUP,a0		;Main loop lockup
#aud	calla	AUD1

#cont

;MJT
;	move	@clipsrunning,a0,L	;>Restore game if clips crashed
;	cmpi	>12345678,a0
;	jrne	#notclip		;Not a clip reset?
;
;	calla	io_init			;Initialize the I/O regs
;	movi	DIE+X2E,a0
;	move	a0,@INTENB		;Display int on, DMA int off
;
;	movi	AUD_CLIPLOCK,a0
;	calla	AUD1
;	movi	ACTIVE,a13
;	clr	a1
;	move	a1,@clipsrunning,L
;	calla	KILALL
;
;	CREATE0	#proc
;
;	eint
;	jruc	mainlp
;
;#proc	calla	display_blank
;	calla	system_restoregame	;Restore the saved game
;	movi	cliplockretp,a0		;Return addr for eoq
;	PUSHP	a0
;	jauc	plyr_eoq_lockcont
;
;#notclip

	movk	AUDSTAT,a0
	calla	GET_AUD			;0=AMode, 1=Game
	move	a1,a1
	jrz	WARMSET			;Attract mode glitch?

initp50
	calla	READ_DIP		;skip if UJ2 bit 6 set
	btst	6,a0
	jrnz	#nopt
	jauc	POWERTST		;board test etc...
#nopt


 SUBR	WARMSET

	dint
	setf	16,1,0			;Field0 = Word sign extend
	setf	32,0,1			;Field1 = Long word
	movi	STCKST,sp		;Top of stack

	jauc	POWERCMOS
PCMOSRET

	calla	init_all		;Initialize hardware
	calla	INIT_TAB		;Reset todays high score table

;	movk	1,a0
;	move	a0,@>fff80000,L

	.if	DEBUG
	callr	testcode
	.endif


	calla	CKDIAG
	jrz	main_go			;No diag switches closed?

	CREATE	DIAG_PID,DIAG		;Fire off the diag process
	jruc	mainlp
main_go
	CREATE0	amode_start		;Fire up the attract mode


********************************
* Main loop

mainlp
	calla	process_dispatch

	move	a13,a13
	jrz	mainpok
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	10,0
	.endif
mainpok

	move	@RAND,a1,L		;>Randomize
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	calla	cr_cntrs_update		;And blink the top messages
	callr	switch_unstack
	calla	snd_update		;Update the sound calls
	calla	joy_read


	move	@steals_off,a0
	jrle	#ok
	subk	1,a0
	move	a0,@steals_off
#ok
	move	@pushing_delay,a0
	jrle	#ok2
	subk	1,a0
	move	a0,@pushing_delay
#ok2
	move	@pass_off,a0
	jrle	#ok3
	subk	1,a0
	move	a0,@pass_off
#ok3

	move	@assist_delay,a0
	jrle	#ok4
	subk	1,a0
	move	a0,@assist_delay
	jrnz	#ok4
	clr	a1
	move	a1,@assist_plyr
#ok4
	move	@rebound_delay,a0
	jrle	#ok5
	subk	1,a0
	move	a0,@rebound_delay
	jrnz	#ok5
	clr	a1
	move	a1,@rebound_delay
#ok5



	.if	DEBUG
	callr	cputime_calcfree
	.endif

	move	@HALT,a0
	jrnz	#skipit
	move	@last_name_time,a0
	inc	a0
	move	a0,@last_name_time	;# ticks since player name called
#skipit

	move	@PCNT,a0
	addk	1,a0
	move	a0,@PCNT

	movb	@DIPSWITCH-7,a0
	jrn	mainlp

	movi	ACTIVE,a13		;*Proc list
	CREATE	DIAG_PID,DIAG
	jruc	mainlp



#***************************************************************
* Unstack switch queue


 SUBRP	switch_unstack

	.if	0			;DEBUG!!

	clr	a4

#lp	move	@swstack_p,a3,L
	cmpi	swstacktop,a3		;Stack at start?
	jreq	#x			;Empty?
	move	@FREE,a0,L
	jrz	#x			;No processes left?

	move	*a3+,a0			;Get entry
	move	a3,@swstack_p,L		;Update stack
	sll	32-5,a0			;Max switch # 31
	srl	32-5-4,a0		;*16
	move	a0,a2
	add	a0,a2
	add	a0,a2			;*3
	addi	switch_t,a2
	move	*a2+,a1
	jrz	#lp			;No PID?
	move	*a2+,a7,L		;*Code
	movi	ACTIVE,a13		;*Proc list
	calla	GETPRC
	addk	1,a4
	jruc	#lp

#x
	subk	1,a4
	jrle	#xx
	LOCKUP

#xx	rets

	.else


#lp	move	@swstack_p,a3,L
	cmpi	swstacktop,a3		;Stack at start?
	jreq	#x			;Empty?
	move	@FREE,a0,L
	jrz	#x			;No processes left?

	move	*a3+,a0			;Get entry
	move	a3,@swstack_p,L		;Update stack
	sll	32-5,a0			;Max switch # 31
	srl	32-5-4,a0		;*16
	move	a0,a2
	add	a0,a2
	add	a0,a2			;*3
	addi	switch_t,a2
	move	*a2+,a1
	jrz	#lp			;No PID?
	move	*a2+,a7,L		;*Code
	movi	ACTIVE,a13		;*Proc list
	calla	GETPRC
	jruc	#lp

#x	rets

	.endif

switch_t	;(Process ID or 0, *Routine)	;Put in audit??


	.if	TUNIT
	WL	0,0			;S0
	WL	0,0			;S1
	WL	0,0			;S2
	WL	0,0			;S3
	WL	0,0			;S4
	WL	0,0			;S5
	WL	0,0			;S6
	WL	0,0			;S7
	WL	0,0			;S8
	WL	0,0			;S9
	WL	0,0			;S10
	WL	0,0			;S11
	WL	0,0			;S12
	WL	0,0			;S13
	WL	0,0			;S14
	WL	0,0			;S15

	WL	LC_PID,LCOIN		;S16 - LEFT COIN (1)
	WL	RC_PID,RCOIN		;S17 - RIGHT COIN (2)
	WL	PSWPID,plyr_strtb1	;S18 - START 1
	WL	SLAM_PID,SLAM_SW	;S19 - SLAM TILT
	WL	DIAG_PID,DIAG		;S20 - TEST
	WL	PSWPID,plyr_strtb2	;S21 - START 2
	WL	DIAG_PID,SERVICE	;S22 - SERVICE CREDIT
	WL	CC_PID,CCOIN		;S23 - CENTER COIN (3)
	WL	CC_PID,XCOIN		;S24 - COIN 4
	WL	PSWPID,plyr_strtb3	;S25 - START 3
	WL	PSWPID,plyr_strtb4	;S26 - START 4
	WL	0,0			;S27
	WL	0,0			;S28
	WL	0,0			;S29
	WL	0,0			;S30
	WL	0,0			;S31

	.else

;These are Jamie home Y-unit equates

;	WL	0,0			;S0
;	WL	0,0			;S1
;	WL	0,0			;S2
;	WL	0,0			;S3
;	WL	0,0			;S4
;	WL	0,0			;S5
;	WL	0,0			;S6
;	WL	0,0			;S7
;	WL	0,0			;S8
;	WL	0,0			;S9
;	WL	0,0			;S10
;	WL	0,0			;S11
;	WL	0,0			;S12
;	WL	0,0			;S13
;	WL	0,0			;S14
;	WL	0,0			;S15
;
;	WL	LC_PID,LCOIN		;S16 - LEFT COIN (1)
;	WL	RC_PID,RCOIN		;S17 - RIGHT COIN (2)
;	WL	PSWPID,plyr_strtb1	;S18 - START 1
;	WL	SLAM_PID,SLAM_SW	;S19 - SLAM TILT
;	WL	DIAG_PID,DIAG		;S20 - TEST
;	WL	PSWPID,plyr_strtb2	;S21 - START 2
;	WL	DIAG_PID,SERVICE	;S22 - SERVICE CREDIT
;	WL	PSWPID,plyr_strtb3	;S23 - START 3
;	WL	0,0			;S24
;	WL	0,0			;S25
;	WL	0,0			;S26
;	WL	0,0			;S27
;	WL	0,0			;S28
;	WL	0,0			;S29
;	WL	0,0			;S30 - Snd IRQ
;	WL	0,0			;S31
;	.endif

	WL	PSWPID,plyr_strtb4	;S7 IO20 - START 4
	WL	0,0			;S1
	WL	0,0			;S2
	WL	0,0			;S3
	WL	0,0			;S4
	WL	0,0			;S5
	WL	0,0			;S6
	WL	PSWPID,plyr_strtb3	;S7 - START 3
	WL	0,0			;S8
	WL	0,0			;S9
	WL	0,0			;S10
	WL	0,0			;S11
	WL	0,0			;S12
	WL	0,0			;S13
	WL	0,0			;S14
	WL	CC_PID,XCOIN		;S15 - COIN 4

	WL	LC_PID,LCOIN		;S16 - LEFT COIN (1)
	WL	RC_PID,RCOIN		;S17 - RIGHT COIN (2)
	WL	PSWPID,plyr_strtb1	;S18 - START 1
	WL	SLAM_PID,SLAM_SW	;S19 - SLAM TILT
	WL	DIAG_PID,DIAG		;S20 - TEST
	WL	PSWPID,plyr_strtb2	;S21 - START 2
	WL	DIAG_PID,SERVICE	;S22 - SERVICE CREDIT
	WL	CC_PID,CCOIN		;S23 - CENTER COIN (3)
	WL	0,0			;S24
	WL	0,0			;S25
	WL	0,0			;S26
	WL	0,0			;S27
	WL	0,0			;S28
	WL	0,0			;S29
	WL	0,0			;S30 - Snd IRQ
	WL	0,0			;S31
	.endif


****************************************************************
* plyr_strtbx - Process player start button (Process)

 SUBR	plyr_strtb1

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#strtb2

	clr	a8			;A8=Player #
	movi	P1DATA,a11		;A11=*plyr data
	jruc	plyr_strtbut

 SUBR	plyr_strtb2

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#strtb3
#strtb2
	movk	1,a8
	movi	P2DATA,a11
	jruc	plyr_strtbut

 SUBR	plyr_strtb3

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	psbx
#strtb3
	movk	2,a8
	movi	P3DATA,a11
	jruc	plyr_strtbut

 SUBR	plyr_strtb4

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	psbx
	movk	3,a8
	movi	P4DATA,a11


plyr_strtbut

	movk	1,a0
	move	a0,@BTIME

	move	@GAMSTATE,a0

	cmpi	INPLYRINFO,a0
	jreq	psbx

	move	@WFLG,a0
	jrnz	psbx			;Window growing?
	move	@ENTERON,a0
	jrnz	psbx			;Initials being entered?


	move	@pleasewt,a0		;Plyr start bits 0-3
	btst	a8,a0
	jrnz	psbx

	move	@PSTATUS,a0		;Plyr start bits 0-3
	btst	a8,a0
	jrz	#startplyr		;Player not started?

;This player wants to suck up more credits!
;	move	*a11(ply_time),a0
;	cmpi	550,a0				;1000
;	jrgt	#showmax

#ok
	move	@game_purchased,a0
	btst	a8,a0
	jrz	no_drw_max

#showmax
;Make sure we display MAX for this plyr who just hit his button!
;	callr	plyr_setmsgsingame
#die	DIE

no_drw_max
;	move	@team1,a0
;	move	@team2,a1
;	or	a0,a1
;	jrz	psbx			;Winner stays on box on scrn?


	move	@GAMSTATE,a1
	cmpi	INGAME,a1
	jrz	psbx

	calla	CR_CONTP		;Credits to continue
	jrlo	conttimers_cnt		;No?
	calla	P_CONT			;Take credits
	SOUND1	eat_snd

	movk	AUD1CONT,a0		;Continue
	calla	AUD1

	movi	100,a0			;units to add
	callr	add_plyr_time		;add time to this players play time

;	move	@GAMSTATE,a0
;	subk	ININTRO,a0		;If in intro, the regular start up
;	jrne	#not_pd

;2/10/93
;	movk	2,a0

	movk	ADJCCONT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2


	callr	paidcreds_add
	calla	update_scorebrd
	jruc	psbx


#not_pd
	sll	4,a8
	addi	sticklst,a8
	move	*a8,a0
	calla	KIL1C			;kill stick on me procs for this plyr
	move	*a8,a0
	calla	obj_del1c

;a buyin message may be on instead of his meters, better turn 'em on!

	callr	plyr_setmsgsingame
	DIE


#startplyr
	move	@GAMSTATE,a1
	jrn	psbx			;Diagnostics?
	cmpi	INGAMEOV,a1
	jreq	psbx			;Game over?

	cmpi	INAMODE,a1
	jreq	game_start		;New start from amode?

	cmpi	INFREEPRICE,a1
	jreq	game_start2		;New start from winners half price scr?
	cmpi	ININTRO,a1
	jrz	#skiptmck

	move	@game_time,a14,L
	jrz	#skiptmck
	cmpi	[202h,0],a14
	jrge	#skiptmck


*********************************************************

	MOVK	ADJFREPL,A0		;ARE WE IN FREE PLAY?
	CALLA	GET_ADJ
	JRNZ	#skiptmck

	move	@PSTATUS2,a0		;Plyr already started bits 0-3
	btst	a8,a0
	jrz	#psb101			;Player never started?

	calla	CR_CONTP		;Credits to continue
	jalo	SUCIDE			;No?
	jruc	#psb300


#psb101	calla	CR_STRTP		;Credits to start
	jalo	SUCIDE			;No?

#psb300
	movk	1,a0
	sll	a8,a0

	move	@pleasewt,a1
	or	a0,a1
	move	a1,@pleasewt

	callr	plyr_setmsgsingame
	DIE

*********************************************************

#skiptmck

	move	a8,a14
	srl	1,a14
	move	@winningteam,a0
	cmp	a14,a0
	jrz	#skp1

	move	@PSTATUS2,a0		;Plyr already started bits 0-3
	btst	a8,a0
	jrz	psb101			;Player never started?

	calla	CR_CONTP		;Credits to continue
	jrlo	conttimers_cnt		;No?
 	calla	P_CONT			;Take credits
	SOUND1	eat_snd

#skp1
	movi	100,a0			;units to add
	callr	add_plyr_time		;add time to this players play time

	movk	AUD1CONT,a0		;Continue
	calla	AUD1
	jruc	psb300


psb101	calla	CR_STRTP		;Credits to start
	jrlo	conttimers_cnt		;No?
	calla	P_START			;Take credits

	SOUND1	eat_snd

	movi	100,a7
	movk	ADJCSTRT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2
	subk	1,a0
	jrz	#ag
;2 credits to start pricing, give more unit time to start!
;	movi	150,a7		     	;units to add
#ag	move	a7,a0
	callr	add_plyr_time		;add time to this players play time

	move	@GAMSTATE,a0
	subk	ININTRO,a0		;If in intro, the regular start up
	jreq	psb300

	movk	AUD1STRT,a0		;Mid game start
	calla	AUD1

psb300
	movk	1,a0
	sll	a8,a0

	PUSH	A0
	MOVK	ADJFREPL,A0		;ARE WE IN FREE PLAY?
	CALLA	GET_ADJ
	move	a0,a14
	PULL	A0
	move	a14,a14
	JRNZ	#fre

	move	@GAMSTATE,a14
	subk	ININTRO,a14		;If in intro, the regular start up
	jrne	#not

#not1


;new 2/10/93

	PUSH	a0
	move	@PSTATUS2,a1
	btst	a0,a1
	jrz	#frmstrt
	
	movk	ADJCCONT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2
	jruc	#fix1
#frmstrt
	movk	ADJCSTRT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2
#fix1

;	movk	2,a0

	callr	paidcreds_add

	PULL	a0




	move	@PSTATUS,a1
	or	a0,a1			;Set bit
	move	a1,@PSTATUS

	move	@PSTATUS2,a1
	or	a0,a1			;Set bit saying this guy has started
	move	a1,@PSTATUS2		;and 50 cent buyin has happened!

;2/10/93
;	movk	2,a0
;	callr	paidcreds_add

	move	@gmqrtr,a0
	jrz	#inintro

	move	@newptr,a0,L
	move	a11,*a0+,L
	move	a8,*a0+
	clr	a1
	move	a1,*a0,L
	move	a0,@newptr,L

	jruc	#inintro

#fre
	move	@GAMSTATE,a14
	subk	ININTRO,a14		;If in intro, the regular start up
	jrz	#not1

#freeply



;2/10/93
	PUSH	a0
	move	@PSTATUS2,a1
	btst	a0,a1
	jrz	#frmstrt2
	
	movk	ADJCCONT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2
	jruc	#fix12
#frmstrt2
	movk	ADJCSTRT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2
#fix12

;	movk	2,a0

	callr	paidcreds_add

	PULL	a0





	move	@PSTATUS,a1
	or	a0,a1			;Set bit
	move	a1,@PSTATUS

	move	@PSTATUS2,a1
	or	a0,a1			;Set bit saying this guy has started
	move	a1,@PSTATUS2		;and 50 cent buyin has happened!


;2/10/93
;	movk	2,a0
;	callr	paidcreds_add


	jruc	#frepl

#not
	move	@game_time,a14,L
	cmpi	[202h,0],a14
	jrgt	#freeply


;2/10/93
;	PUSH	a0
	move	@PSTATUS2,a1
	btst	a8,a1
	jrz	#frmstrt3
	
	movk	ADJCCONT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2
	jruc	#fix13
#frmstrt3
	movk	ADJCSTRT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2
#fix13

;	movk	2,a0

	callr	paidcreds_add

;	PULL	a0

;2/10/93
;	movk	2,a0
;	callr	paidcreds_add


#not_inintro
	movk	1,a0
	sll	a8,a0

	move	@pleasewt,a1
	or	a0,a1
	move	a1,@pleasewt

	callr	plyr_setmsgsingame
	DIE

#frepl
	movk	1,a0
	move	a0,@name_cnt
	clr	a0
	move	a0,@name_flop
 
	move	@GAMSTATE,a14
	subk	ININTRO,a14		;If in intro, the regular start up
	jrz	#skp1a

;	calla	update_scorebrd
 
	movi	CLSDEAD|creditid,a0
	calla	obj_del1c		;kill credit/qrtr imgs
	calla	prt_credits

#skp1a
	move	*a11(ply_messages),a0,L
	jrz	#imgson
	calla	DELOBJ
	clr	a0
	move	a0,*a11(ply_messages),L

;Turn on all the credit box, cntr imgs for this plyr

	PUSH	a6,a8,a11

	move	a11,a9
	addi	ply_meter_imgs,a9	;where to stuff img pntrs

	move	*a9+,a0,L
	calla	DELOBJ
	move	*a9+,a0,L
	jrz	#cv
	calla	DELOBJ
#cv	move	*a9,a0,L
	calla	DELOBJ
	subi	64,a9

	move	a8,a0
	sll	5,a0
	
	addi	cr_box,a0

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrs
	addi	8*32,a0
#4_plyrs
	



	move	a0,a11
	addi	4*32,a11
	move	*a11,a11,L
	PUSHP	A11

	move	*a0,a11,L
	callr	prt_status


	PULLP	A11
	calla	refill_turbo

	PULL	a6,a8,a11

	movi	scorep,a0
	calla	pal_getf
	move	a0,a5

	move	a8,a0
	sll	5,a0
	addi	names,a0
	move	*a0,a0,L
	move	*a11(ply_meter_imgs),a8,L	;change box to name
	move	a5,*a8(OPAL)
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff


;	PUSH	a6,a8,a11
;
;	calla	prt_cr_timers
;
;	PULL	a6,a8,a11

#imgson
;	callr	plyr_setmsgsingame


#inintro
;Use player name as a sound call

psbx	DIE

cr_box	.long	init_t1,init_t2,init_t3,init_t4
	.long	P1DATA,P2DATA,P3DATA,P4DATA

;cr_boxkit - keep lined up
	.long	init_t1,init_t2kit,init_t3kit,init_t4
	.long	P1DATA,P2DATA,P3DATA,P4DATA

sticklst
	.word	p1stickid,p2stickid,p3stickid,p4stickid


 SUBR	start_msgs

	movi	newplyrs,a10
	move	a10,@newptr,L
	move	a10,a2

	movk	5,a9
start1
	dec	a9
	jrz	#done
	move	*a10+,a11,L
	jrz	#done
	move	*a10+,a8
	CREATE0	#frepl
	jruc	start1
#done
	clr	a0
	movk	5,a14
#clp	move	a0,*a2+,L
	dsj	a14,#clp

	DIE

********************************
* A0=Units to add
* A8=Pnum (0-3)

paidcreds_add

	PUSH	a2

	move	a8,a1
	sll	5,a1
	addi	paid_t,a1
	move	*a1,a1,L

	move	a8,a14
	srl	1,a14
	move	@winningteam,a2
	cmp	a14,a2
	jrnz	#nothalf
	sll	3,a0			;Double paid credits

#nothalf
	move	*a1,a2
	add	a0,a2
	move	a2,*a1

	move	a8,a1
	sll	4,a1			;x 16 bits
	addi	qtr_purchased,a1
	move	*a1,a14
	inc	a14
	move	a14,*a1

	move	@gmqrtr,a1
	cmpi	3,a1
	jrge	#full
	movk	4,a2
	sub	a1,a2
	cmp	a2,a14
	jrlt	#no


;2/10/93
;	cmpi	4,a14
;	jrz	#full


;	move	@gmqrtr,a0
;	sll	4,a0
;	addi	needed,a0
;	move	*a0,a0
;	cmp	a2,a0
;	jrgt	#no

	move	@GAMSTATE,a0
	cmpi	INAMODE,a0
	jreq	#no
	move	@gmqrtr,a14
	jrnz	#full
;If matchup scrn is on, still do this!
	.ref	inmatchup
	move	@inmatchup,a0
	jrz	#no

#full
	move	@game_purchased,a0	;set purchased bit
	move	a8,a14
	sll	4,a14
	addi	or_t,a14
	move	*a14,a14
	or	a14,a0			;for player
	move	a0,@game_purchased

#no
	PULL	a2
	rets

;needed	.word	6,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2

********************************
* Set the messages to the in game state
* A11=*PxDATA

LEDOCTRL	.equ	DMAWNZ|>3000	;3 bits per pixel (In BB.asm)
MSGOCTRL	.equ	DMAWNZ|>6000

 SUBRP	plyr_setmsgsingame

	PUSH	a8

	move	*a11(ply_messages),a8,L
	movi	please,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	calla	update_scorebrd

	move	*a11(ply_meter_imgs),a0,L
	calla	OBJOFF
	move	*a11(ply_meter_imgs+20h),a0,L
	calla	OBJOFF
	move	*a11(ply_meter_imgs+40h),a0,L
	calla	OBJOFF

	PULL	a8
	rets




#********************************
* A0=units to add

add_plyr_time


	move	a8,a14
	srl	1,a14
	move	@winningteam,a1
	cmp	a14,a1
	jrnz	#nothalf

	sll	3,a0			;Double credit time

#nothalf
	
	movi	3500,a1
	move	a1,*a11(ply_time)


	movi	110,a0			;Shorter time for player names message
	move	a0,@name_cnt


	move	@GAMSTATE,a0
	subk	ININTRO,a0
	jreq	rx
	move	*a11(ply_meter_imgs),a0,L
	jrz	#nxt

	move	*a11(ply_meter_imgs+>20),a0,L
	move	*a0(OIMG),a1,L
	cmpi	start,a1
	jrnz	#nxt
	movk	9,a1
	move	a1,*a0(OYPOS)

#nxt	jauc	prt_cr_timers

rx	rets

or_t	.word	1,2,4,8


********************************
* Add count to continue timers (Process)

 SUBRP	conttimers_cnt

	DIE


game_start2
	move	a8,a14
	srl	1,a14
	move	@winningteam,a0
	cmp	a14,a0
	jrz	gs2

#***************************************************************
* Start game from amode (Process)
* A8=Plyr # (0-3)
* A11=*PxDATA

 SUBRP	game_start

	calla	CR_STRTP
	jalo	SUCIDE			;Not enough credits?
	calla	P_START			;Take credits

	calla	QSNDRST
	

gs2
	movi	100,a7
	movk	ADJCSTRT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2
	subk	1,a0
	jrz	#tag

;2 credits to start pricing, give more unit time to start!

	movi	100,a7		     	;units to add ;150
#tag

;Zero PxDATA areas

	clr	a0
	movi	P1DATA,a1
	movi	PDSIZE*4/16,A2
#zlp	move	a0,*a1+
	dsj	a2,#zlp

	clr	a0
	move	a0,@gmqrtr
	move	a0,@qtr_purchased,L	;clr 4x16
	move	a0,@qtr_purchased+20h,L
	move	a0,@plyrbighead
	move	a0,@inmatchup

	move	a7,a0
	callr	add_plyr_time		;add time to this players play time


	movi	AUDBONE,a0		;+1 games started from amode
	calla	AUD1

	movi	AUD_TOTPLYS,a0
	calla	AUD1

	movk	1,a0
	sll	a8,a0
	move	a0,@PSTATUS
	move	a0,@PSTATUS2		;Player has started bit flags


	movk	ADJCSTRT,a0		;credits required to start
	calla	GET_ADJ			;returns 1,2

	callr	paidcreds_add


	movi	INTRO_PID,a0		;>Intro state
	move	a0,*a13(PROCID)
	movk	ININTRO,a0
	move	a0,@GAMSTATE

	calla	display_blank
	calla	WIPEOUT


;-------------------------------

	movi	10*60,a0
	move	a0,@cntrs_delay

	SLEEPK	1

	clr	a0
	move	a0,@team1
	move	a0,@team2
	move	a0,@SOUNDSUP
	.ref	special_heads

	movi	-1,a0
	move	a0,@special_heads,L
	move	a0,@special_heads+20h,L

	.ref	dtype

	clr	a0
	move	a0,@dtype

	.ref	monitor_fullgame
	CREATE0	monitor_fullgame

	move	@winningteam,a1
	jrnn	#skip

	movk	1,a0
	move	a0,@HALT
	
;	JSRP	winner_stays_box

	clr	a0
	move	a0,@HALT
	move	a0,@gmqrtr

	movk	1,a0
	move	a0,@team1
	movk	2,a0
	move	a0,@team2

#skip
	JSRP	initials_entry

	move	@team1,a0
	move	@team2,a1
	and	a0,a1
	move	a1,a1
	jrnn	#bomb_out		;restart attract mode etc...

	jauc	amode_start		;Start attract mode

paid_t	.long	P1DATA+crds_paid,P2DATA+crds_paid,P3DATA+crds_paid
	.long	P4DATA+crds_paid

#bomb_out

;-------------------------------

;	clr	a0
;	move	a0,@played3d

; SUBR	from_3d

	clr	a0
	move	a0,@cntrs_delay
	movi	tuneq1_snd,a0
	calla	snd_play1

	JSRP	scrn_scaleout

;	movi	zoom_snd,a0
;	calla	snd_play1

	JSRP	scrn_scaleininit

	calla	WIPEOUT			;CLEAN SYSTEM OUT



 SUBR	demogame_start			;Demo mode entry

;	movi	zoom_snd,a0
;	calla	snd_play1

	JSRP	scrn_scaleininit	;Hide display

	movi	security_chk->1df60,a8

	movk	1,a0
	move	a0,@dpageflip		;ON
	move	a0,@dtype		;3D

	calla	COLRPRC			;Init fixed pal 0



	movi	[WRLDMID-200,0],a0
	move	a0,@WORLDTLX,L
	clr	a0
	move	a0,@WORLDTLY,L

	SLEEPK	2


	movk	1,a0			;delay start of a second plyr flag
	move	a0,@NO_START

	movi	QRTRTIME,a0		;3 minutes, 0 secs, 0 tenths
;
;	movi	10,a0	
;
	move	a0,@game_time,L
	clr	a0
	move	a0,@clock_speed
		 

;-----------
;This is checksummed!
seccall1
	move	a8,a1			;>Check security
	addi	>1df60,a1
	getpc	a7
	addi	>40,a7
	move	a7,-*sp,L
	jump	a1			;Rets: A0=0 if OK!
seccall1end

;-----------

	move	a0,@BTIME
	move	a0,@idiot_bits
	move	a0,@HALT
	move	a0,@_4plyrsingame
	movi	scores,a1
	move	a0,*a1+,L		;Team 1
	move	a0,*a1+,L		;Team 2
	move	a0,@timertcnt
	move	a0,@sc_proc,L
;	move	a0,@already_on,L   	;arw on hd 0=no or proc pntr
;	move	a0,@already_on+32,L
;	move	a0,@already_on+64,L
;	move	a0,@already_on+96,L
	move	a0,@steals_off
;	move	a0,@intercept_delay
	move	a0,@pass_off
	move	a0,@ballprcv_p,L
	move	a0,@crowd_animate
	move	a0,@name_flop
	move	a0,@gmqrtr
	move	a0,@fire_flags


	movi	1 ,a0
	move	a0,@name_cnt

;	move	a0,@gmqrtr


	movi	-1,a0
	move	a0,@winningteam
	move	a0,@ballpnumlast	;last player who had ball
	move	a0,@inbound
	move	a0,@cntl_team
	move	a0,@cntl_team_last
	move	a0,@plyrnumonfire


	movk	8,a0
	move	a0,@ballsclastp

	movk	6,a0
	move	a0,@next_call

;	.ref	sounds_list		;16 * 16 bits
;	movi	0ffffh,a0
;
;	movi	32,a2
;	movi	sounds_list,a1
;#slp
;	move	a0,*a1+
;	dsj	a2,#slp


	move	@team1,a0
	sll	5,a0
	addi	crt_pals,a0
#nx	move	*a0,a0,L
	move	a0,@crt_colors,L

;Team 1
;	.ref	player_toggle1		;0 = no toggle
;	.ref	player_toggle2		;0 = no toggle

	.ref	special_heads
	.ref	our_names


	callr	set_names

	move	@names,a0,L
	move	a0,@original_names,L
	move	@names+32,a0,L
	move	a0,@original_names+32,L
	move	@names+64,a0,L
	move	a0,@original_names+64,L
	move	@names+96,a0,L
	move	a0,@original_names+96,L



	.ref	setup_speech
	calla	setup_speech

	movk	1,a0
	move	a0,@gndstat		;On


;	jruc	#skip3d
;	CREATE0	_3d_test
;#skip3d


	move	@GAMSTATE,a0
	subk	INAMODE,a0
	jreq	#demo

	movk	INGAME,a0
	move	a0,@GAMSTATE

#demo
	clr	a0
	move	a0,@NO_START
	move	a0,@inmatchup


	CREATE	STAT_PID,status_display


	.if	IMGVIEW
	.ref	anipts_debug
	clr	a8
	CREATE0 anipts_debug
	movk	3,a8
	CREATE0 anipts_debug
	.endif

	callr	game_initobjs

;	CREATE0	gnd_aligndots

	CREATE0	ball_main
	CREATE	gclockid,clock_strt	;start clock
	CREATE0	bracket_drw

;	.ref	plyr_camflash
;	CREATE0	plyr_camflash1

	CREATE0	close

	calla	clear_player_stats

;RJR start *******************************************************************

	.ref	sound_watchdog
	CREATE0	sound_watchdog

;RJR end *********************************************************************

	.ref	name_call
	CREATE0	name_call

	CREATE0	scream_snd
	CREATE0	check_idiot

	.ref	doflshs
	CREATE0	doflshs

	MOVI	[62,1],A8		;START AT COLOR 60, CYCLE 1 COLOR
	MOVI	scorep,A9		;PAL NAME
	MOVI	COLTAB_RNBW,A10		;TABLE TO CYCLE WITH
	MOVK	3,A11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	callr	start_arws

;	move	@SWITCH,a0
;	andi	>7072,a0
;	jrnz	#no3d
;
;	move	@GAMSTATE,a0
;	subk	INAMODE,a0
;	jreq	#no3d
;
;	move	@played3d,a0
;	jrnz	#no3d
;
;	movk	1,a0
;	move	a0,@played3d
;	jauc	_3d_test
;#no3d


;SL - temp for clip debug
;	movk	1,a0
;	move	a0,@gmqrtr
;	move	a0,@game_time,L

	jauc	plyr_start

 SUBR	join_cyc
	MOVI	[29,1],A8		;START AT COLOR 60, CYCLE 1 COLOR
	MOVI	timers_b,A9		;PAL NAME
	MOVI	COLTAB_RNBW,A10		;TABLE TO CYCLE WITH
	MOVK	3,A11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	MOVI	[29,1],A8		;START AT COLOR 60, CYCLE 1 COLOR
	MOVI	timers_r,A9		;PAL NAME
	MOVI	COLTAB_RNBW,A10		;TABLE TO CYCLE WITH
	MOVK	3,A11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE
	rets


	.DEF	COLTAB_RNBW

COLTAB_RNBW
	.WORD	0380H,1380H,2380H,3380H,4380H,5380H,6380H,7380H,7300H
	.WORD	7280H,7200H,7180H,7080H,7008H,7008H,7010H,7010H,701CH
	.WORD	701CH,601CH,501CH,409CH,309CH,209CH,219CH,029CH,039CH
	.WORD	139CH,239CH,339CH,539CH,739CH,7390H,7380H,6380H,4380H
;NEED A DUPLICATE SET
	.WORD	0380H,1380H,2380H,3380H,4380H,5380H,6380H,7380H,7300H
	.WORD	7280H,7200H,7180H,7080H,7008H,7008H,7010H,7010H,701CH
	.WORD	701CH,601CH,501CH,409CH,309CH,209CH,219CH,029CH,039CH
	.WORD	139CH,239CH,339CH,539CH,739CH,7390H,7380H,6380H,4380H
	.word	-1

;_ATL	equ 0
;_BOS	equ 1
;_CHA	equ 2
;_CHI	equ 3
;_CLE	equ 4
;_DAL	equ 5
;_DEN	equ 6
;_DET	equ 7
;_GOL	equ 8
;_HOU	equ 9
;_IND	equ 10
;_LAC	equ 11
;_LAL	equ 12
;_MI	equ 13
;_MIL	equ 14
;_MIN	equ 15
;_NJ	equ 16
;_NY	equ 17
;_ORL	equ 18
;_PHI	equ 19
;_PHX	equ 20
;_POR	equ 21
;_SAC	equ 22
;_SAN	equ 23
;_SEA	equ 24
;_UTA	equ 25
;_WAS	equ 26

crt_pals
	.long	CRT_ATL_P,CRT_BOS_P,CRT_CHA_P,CRT_CHI2P
	.long	CRT_CLE_P,CRT_MIN_P,CRT_DEN_P,CRT_DET_P,crtblupur,CRT_HOU_P
	.long	CRT_IND_P,CRT_CLP_P,CRT_LAK_P,CRT_MIA_P,CRT_MIL_P,CRT_ORL2P
	.long	CRT_NEJ_P,CRT_NEY_P,CRT_ORL_P
	.long	CRT_PHI_P,CRT_PHO_P,CRT_POR_P,CRT_SAC_P
	.long	CRT_SAN_P,crtgrnyel,CRT_UTA_P
	.long	CRT_WAS_P,crtblupur

crt_pals_z
	.long	CRD_ATL_P+32,CRD_BOS_P+32,CRD_CHA_P+32,CRD_CHI2P+32
	.long	CRD_CLE_P+32,CRD_MIN_P+32,CRD_DEN_P+32,CRD_DET_P+32,CRD_DET_P+32,CRD_HOU_P+32
	.long	CRD_IND_P+32,CRD_CLP_P+32,CRD_LAK_P+32,CRD_MIA_P+32,CRD_MIL_P+32,CRD_ORL2P+32
	.long	CRD_NEJ_P+32,CRD_NEY_P+32,CRD_ORL_P+32
	.long	CRD_DET_P+32,CRD_PHO_P+32,CRD_POR_P+32,CRD_SAC_P+32
	.long	CRD_SAN_P+32,CRD_SEA_P+32,CRD_UTA_P+32
	.long	CRD_WAS_P+32,CRD_DET_P+32

;crt_pals2
;	.long	UPCOURT_P,crtblupur
;	.long	crtpuryel,crtblkred
;	.long	crtgrnyel
;crt_pals2_z
;	.long	UPCOURT_P,crtblupur
;	.long	crtpuryel,crtblkred
;	.long	crtgrnyel


 SUBR	start_arws

;	movi	ARWPID,a0
;	calla	KIL1C
;	movi	arwid,a0
;	calla	obj_del1c
;	movi	ARWPID,a0
;	calla	obj_del1c

	movk	3,a8			;>Do init stuff for humans
#psilp
	movi	PDSIZE,a11
	mpyu	a8,a11
	addi	P1DATA,a11
	CREATE	ARWPID,plyr_lost		;Pass A8 (0-3)
;	CREATE0	plyr_lost		;Pass A8 (0-3)
#noplyr	subk	1,a8
	jrge	#psilp

	.ref	stick_numbers
	movi	P1DATA,a10
	CREATE	ARWPID,stick_numbers
	movi	P2DATA,a10
	CREATE	ARWPID,stick_numbers
	movi	P3DATA,a10
	CREATE	ARWPID,stick_numbers
	movi	P4DATA,a10
	CREATE	ARWPID,stick_numbers

	.ref	stick_cpu
	clr	a11
	movi	P1DATA,a10
	CREATE	ARWPID,stick_cpu
	movk	1,a11
	movi	P2DATA,a10
	CREATE	ARWPID,stick_cpu
	movk	2,a11
	movi	P3DATA,a10
	CREATE	ARWPID,stick_cpu
	movk	3,a11
	movi	P4DATA,a10
	CREATE	ARWPID,stick_cpu


	CREATE0	delay_sparks

	rets


delay_sparks
	.ref	stick_spark
	.ref	stick_spark2
	SLEEPK	10
	move	@plyrproc_t,a0,L
	move	*a0(plyr_attrib_p),a0,L
	move	*a0(PAT_HEADT_p),a0,L
	cmpi	RA_H,a0
	jrnz	#ck2

;	move	@special_heads,a0
;	cmpi	32,a0
;	jrnz	#ck2

	clr	a11
	movi	P1DATA,a10
	CREATE	ARWPID,stick_spark
	clr	a11
	movi	P1DATA,a10
	CREATE	ARWPID,stick_spark2
#ck2
	move	@plyrproc_t+32,a0,L
	move	*a0(plyr_attrib_p),a0,L
	move	*a0(PAT_HEADT_p),a0,L
	cmpi	RA_H,a0
	jrnz	#ck3

;	move	@special_heads+10h,a0
;	cmpi	32,a0
;	jrnz	#ck3

	movk	1,a11
	movi	P2DATA,a10
	CREATE	ARWPID,stick_spark
	movk	1,a11
	movi	P2DATA,a10
	CREATE	ARWPID,stick_spark2
#ck3
	move	@plyrproc_t+64,a0,L
	move	*a0(plyr_attrib_p),a0,L
	move	*a0(PAT_HEADT_p),a0,L
	cmpi	RA_H,a0
	jrnz	#ck4

;	move	@special_heads+20h,a0
;	cmpi	32,a0
;	jrnz	#ck4

	movk	2,a11
	movi	P3DATA,a10
	CREATE	ARWPID,stick_spark
	movk	2,a11
	movi	P3DATA,a10
	CREATE	ARWPID,stick_spark2
#ck4
	move	@plyrproc_t+96,a0,L
	move	*a0(plyr_attrib_p),a0,L
	move	*a0(PAT_HEADT_p),a0,L
	cmpi	RA_H,a0
	jrnz	#ck5

;	move	@special_heads+30h,a0
;	cmpi	32,a0
;	jrnz	#ck5

	movk	3,a11
	movi	P4DATA,a10
	CREATE	ARWPID,stick_spark
	movk	3,a11
	movi	P4DATA,a10
	CREATE	ARWPID,stick_spark2
#ck5
	DIE

#*******************************
* Tell idiots to use turbo for running if they aren't (Process)

check_idiot

	movi	60,a10

#c1	SLEEP	TSEC
	move	@HALT,a0
	 jrnz	#c1

	dsj	a10,#c1

	movi	30,a2

	move	@P1DATA+ply_idiot_use,a0
	cmp	a2,a0
	jrgt	#ck2
    	clr	a1
	callr	try_ib
#ck2
	move	@P2DATA+ply_idiot_use,a0
	cmp	a2,a0
	jrgt	#ck3
    	movk	1,a1
	callr	try_ib
#ck3
	move	@P3DATA+ply_idiot_use,a0
	cmp	a2,a0
	jrgt	#ck4
    	movk	2,a1
	callr	try_ib
#ck4
	move	@P4DATA+ply_idiot_use,a0
	cmp	a2,a0
	jrgt	#ckx
    	movk	3,a1
	callr	try_ib

#ckx	SLEEP	6*60

	movi	organ1_snd,a0
	move	@HCOUNT,a1
	btst	1,a1
	jrnz	#ckk
	movi	organ2_snd,a0
#ckk
	calla	snd_play1ovr

	DIE
	

try_ib
	movk	7,a0			;Use turbo to run
	jauc	idiot_box


********************************

close	
	SLEEPK	5

;	SOUND1	tune2_snd

;	movi	zoom_snd,a0
;	calla	snd_play1

	JSRP	scrn_scalein

;MJT
;	movi	2<<10+4<<5+9,a0

	clr	a0
	move	a0,@IRQSKYE


	movk	1,a0
	move	a0,@HALT


	.ref	instructions
	JSRP	instructions

	clr	a0
	move	a0,@HALT
	move	a0,@cntrs_delay

	movi	tip_snd,a0
	calla	snd_play1ovr

;	SLEEP	120

;	.ref	winning_msg
;	CREATE0	winning_msg

	DIE

********************************

scream_snd
	movi	scrm1_snd,a0
	calla	snd_play1
	SLEEP	85
	movi	scrm2_snd,a0
	calla	snd_play1
	SLEEP	85
	movi	scrm3_snd,a0
	calla	snd_play1
	SLEEP	85
	movi	scrm4_snd,a0
	calla	snd_play1
	SLEEP	85
	jruc	scream_snd

	.def	scrm1_snd,scrm2_snd,scrm3_snd,scrm4_snd

scrm1_snd	.word	>f540,10,>813d,0
scrm2_snd	.word	>f040,10,>814b,0
scrm3_snd	.word	>f440,10,>815e,0
scrm4_snd	.word	>f540,10,>815f,0	;<--- check channel on this

#*******************************
* Initialize the game objs
* Trashes scratch, A2-A11

 SUBRP	game_initobjs


	movi	#init_t,a11		;>Setup crowd, hoops, side crowd
	jruc	#next
#lp
	cmpi	4001,a0			;>Start process
	jrne	#svptr
	clr	a1
	move	*a11+,a7,L		;*Code
	calla	GETPRC			;Pass last obj in A8
	jruc	#next

#svptr	cmpi	4002,a0			;>Save variable
	jrne	#obj
	move	*a11+,a1,L		;*Var
	move	a8,*a1,L
	jruc	#next

#obj	move	*a11+,a1		;Y
	sll	16,a0
	sll	16,a1
	move	*a11+,a3		;Z
	move	*a11+,a9		;Z offset
	move	*a11+,a4
	ori	DMAWNZ|M_NOCOLL,a4
	move	*a11+,a2,L
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

	move	a9,*a8(OMISC)
	move	*a2,a0			;Width
	sll	15,a0
	move	a0,*a8(OXANI),L		;Save anipt


	btst	B_3DQ,a4
	jrz	#next
					;>Convert 3D to 3DQ
	add	a9,a3
	subi	GZBASE,a3
	move	a3,a6
	sll	8,a3			;*256
	movi	725,a1
	divu	a1,a3
	sll	4,a3			;*16
	addi	gndpos_t,a3
	move	a3,*a8(ODATA_p),L

	move	a6,a3
	sra	1,a6			;Z/2
	sra	3,a3			;Z/8
	sub	a3,a6			;=Z/2.667

	addi	GND_Y,a6
	move	*a8(OYPOS),a0
	add	a6,a0
	move	a0,*a8(OYPOS)


	move	*a8(OXVAL),a7,L		;X
	subi	[>2000,0],a7
	move	*a8(OXANI),a5,L
	add	a5,a7
	sra	16-5,a7			;/2048 (leave 5 bits frac)

	move	*a8(OZPOS),a2		;894 to 1379 (Z range 486)
	move	*a8(OMISC),a3		;Z offset
	add	a3,a2
	move	a2,a6

	addi	(819-GZBASE),a2		;768 to ?
	mpys	a2,a7
	move	a7,a3
	sra	2,a3			;/4
	sub	a3,a7
	sra	1,a3			;/2
	sub	a3,a7
	sra	14,a7			;/16k
	addi	200,a7
	sra	16,a5
	sub	a5,a7			;-X anipt

	move	a7,*a8(OXPOS)


#next	move	*a11+,a0		;X
	cmpi	4000,a0
	jrne	#lp			;!End?

	move	@team1,a0
	move	a0,@oteam1
	callr	random_ads
	rets



	.asg	M_3DQ|M_NOSCALE,F
	.asg	M_3DQ|M_NOSCALE|M_FLIPH,FF

	.asg	8,Y
	.asg	CZMID,Z

#init_t
	.word	>ff4a+3,>ff49+Y-5,Z-18,18,F
	.long	hooptop
	.word	>ff58+3,>ff46-7+Y,Z+1,0,F
	.long	hoopbot
	.word	>ff27+3,>ff4b+2+Y,Z-17,17,F
	.long	back2
	WL	4001,backboard_ani
	.word	>ff75+3,>ff7a+2+Y-1,Z,0,F
	.long	rimbase
	.word	>ff78+3,>ff7d+2+Y,Z-10,0,F
	.long	rim1b
	WL	4002,rimlb
	.word	>ff7a+3,>ff7a+2+Y,Z+10,0,F
	.long	rim1f
	WL	4002,rimlf

	.asg	2,X

	.word	X+>241,>ff49+Y-5,Z-18,18,FF
	.long	hooptop
	.word	X+>234,>ff46-7+Y,Z,0,FF
	.long	hoopbot
	.word	X+>267,>ff4b+2+Y,Z-17,17,FF
	.long	back2
	WL	4001,backboard_svrptr
	.word	X+>215+2,>ff7a+2+Y-1,Z,0,FF
	.long	rimbase
	.word	X+>212,>ff7d+2+Y,Z-10,0,FF
	.long	rim1b
	WL	4002,rimrb
	.word	X+>210,>ff7a+2+Y,Z+10,0,FF
	.long	rim1f
	WL	4002,rimrf

	.word	200-310,1,599,500,F
	.long	reflc2
	WL	4001,get_proper_pal
	.word	200-302,3,720,500,F
	.long	reflc1
	WL	4001,get_proper_pal
	.word	200-156,0,590,500,F
	.long	reflc3
	WL	4001,get_proper_pal
	.word	200-146,0,718,500,F
	.long	reflc4

;	WL	4001,get_proper_pal
;	.word	200-20,0,590,500,F
;	.long	reflc5

	WL	4001,get_proper_pal
	.word	200+140,0,590,500,F
	.long	reflc3
	WL	4001,get_proper_pal
	.word	200+132,0,718,500,F
	.long	reflc4
	WL	4001,get_proper_pal
	.word	200+312,1,599,500,FF
	.long	reflc2
	WL	4001,get_proper_pal
	.word	200+302,3,720,500,FF
	.long	reflc1
	WL	4001,get_proper_pal

	.asg	100,X
	.asg	-12,Y

	.word	>fec8,Y-95,200,0,0
	.long	topcrwd
	.word	>fec8,Y,200,0,0
	.long	crowd40
	WL	4002,bigcrwd1_ptr
	.word	>54,Y-95,200,0,0
	.long	topcrwd
	.word	>54,Y,200,0,0
	.long	crowd40
	WL	4002,bigcrwd2_ptr
	.word	>36a,Y-95,200,0,M_FLIPH
	.long	topcrwd
	.word	>36a,Y,200,0,M_FLIPH
	.long	crowd40
	WL	4002,bigcrwd3_ptr


	.asg	200-56,X
	.asg	-43,Y
	.asg	919,Z
	.word	X-245,Y,Z,0,F
	.long	crowd3
	WL	4002,crwd5_ptr
	.word	>2a,Y,Z,0,F
	.long	newtbl3
	.word	>1ef,Y,Z,0,FF
	.long	crowd3
	WL	4002,crwd6_ptr

	.asg	200-63,X
	.asg	-48,Y
	.asg	947,Z
	.word	>fed9,>ffcc,Z+8,0,F
	.long	usher
	.word	>ffa4+12-20,>ffc0,Z,0,F
	.long	usher
	.word	>35,>ffc6,Z,0,FF
	.long	usher
	.word	>16a,>ffd6-12,Z,0,FF
	.long	usher
	.word	>1ef,>ffc0-0,Z,0,FF
	.long	usher
	.word	>2b4,>ffcf,Z+5,0,FF
	.long	usher
	.word	X-256-177+1,Y+2,Z,0,F
	.long	crowd2b

	.word	>ff85,>ffd0,Z,0,F
	.long	crowd2a
	WL	4002,crwd3_ptr

	.word	>ff83,>ffcf,Z,0,F
	.long	newtbl2

	.word	>7f,>ffcf,Z,0,F
	.long	table2
	.word	>203,>ffd0,Z,0,FF
	.long	crowd2a
	WL	4002,crwd4_ptr

	.word	X+87+257+216-6,Y+2,Z,0,FF
	.long	crowd2b

	.asg	200-53,X
	.asg	-40,Y
	.asg	985,Z
	.word	X-438,Y-3,Z,0,F
	.long	crowd1b
	.word	>ffb0,>ffd9,Z,0,F
	.long	crowd1a
	WL	4002,crwd1_ptr
	.word	>ff98,>ffd9,Z,0,F
	.long	newtbl1



************************************************************************

;Advertisement on left side of scrn
	.word	>ffa5,>ffd9,Z,0,F
	.long	ad1				;ad at left
	WL	4002,ad1_ptr

;Advertisement on rgt side of scrn
	.word	>dd,>ffd3,Z,0,F
	.long	ad2				;ad at left
	WL	4002,ad2_ptr

;Advertisement reflections
	.word	200-144+2-1,6,Z-50,50,F
	.long	ad1ref				;left reflection
	WL	4002,ad1ref_ptr
	.word	200+41+0,6,Z-50,50,F
	.long	ad2ref				;rgt reflection
	WL	4002,ad2ref_ptr

************************************************************************



	.word	>1db,>ffd9,Z,0,FF		;for animating top crowd
	.long	crowd1a
	WL	4002,crwd2_ptr

	.word	X+68+241+230,Y-3,Z,0,FF
	.long	crowd1b

	.word	200-200,7,Z-50,50,F
	.long	cdre0


	.word	>18b,7,Z-50,50,FF	;flipped camera guy reflections
	.long	cdre0


	.asg	200-450,X
	.asg	985,Z

;Fill in crowd 8 - Duplicate!
;	.word	>FEc0,>FFDE,Z,0,F
;	.long	sdcrwd8


	.word	>Ff00,>FFDE,Z,0,F
	.long	sdcrwd8
	WL	4002,sl8_ptr
	.word	>FEFa,>FFDB,Z+28,0,F
	.long	sdcrwd7
	WL	4002,sl7_ptr
	.word	>FEF8,>FFD4,Z+70,0,F
	.long	sdcrwd6
	WL	4002,sl6_ptr
	.word	>FEED,>FFCE,Z+98,0,F
	.long	sdcrwd5
	WL	4002,sl5_ptr

;Fill in crowd 4 - Duplicate!
;	.word	>FEB5,>FFBC,Z+152,0,F
;	.long	sdcrwd4




	.word	>Ff54,>FFe9,>3ef,42h,F
	.long	cheer1
	WL	4002,cheer1_ptr
	.word	>Ff5b,>FFe7,>3e0,39h,F
	.long	cary1
	WL	4002,cheer2_ptr
;	.word	>ffff,>FFe7,>3e0,39h,F
;	.long	cheer1
;	WL	4002,cheer3_ptr





	.word	>FEEC-1,>FFB0,Z+152,0,F
	.long	sdcrwd4
	WL	4002,sl4_ptr
	.word	>FF00,>FFB7,Z+240,0,F
	.long	sdcrwd3
	WL	4002,sl3_ptr
	.word	>FF06,>FFC3,Z+284,0,F
	.long	sdcrwd2
	WL	4002,sl2_ptr
	.word	>FF00-8,>FFB0,Z+379,0,F
	.long	sdcrwd1
	WL	4002,sl1_ptr

	.asg	200+450,X

	.word	>292,>ffdb,Z,0,FF
	.long	sdcrwd8
	WL	4002,sr8_ptr
	.word	>297+6,>ffd8,Z+28,0,FF
	.long	sdcrwd7
	WL	4002,sr7_ptr
	.word	>299,>ffd1,Z+70,0,FF
	.long	sdcrwd6
	WL	4002,sr6_ptr
	.word	>2a6,>ffcc,Z+98,0,FF
	.long	sdcrwd5
	WL	4002,sr5_ptr
	.word	>244,>ffaa,Z+152,0,F
	.long	nsdcrwd4a
	WL	4002,sr4_ptr
	.word	>240,>ffb3,Z+240,0,F
	.long	nsdcrwd3a
	WL	4002,sr3_ptr
	.word	>242,>ffb2,Z+284,0,F
	.long	nsdcrwd2a
	WL	4002,sr2_ptr
	.word	>23d+5,>ffa7+2,Z+379,0,F
	.long	nsdcrwd1a
	WL	4002,sr1_ptr

	.word	4000		;End


********************************

 SUBRP	get_proper_pal

	SLEEPK	3
	move	@crt_colors,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)
	DIE


#********************************
* Animate backboard to proper angle (Process)
* A8=*Object (left)

	.ref	bbshatter

	.bss	bbrgt_p	,32	;*Rgt bboard

 SUBRP	backboard_ani

	SLEEPK	30

	move	@bbrgt_p,a9,L
	movi	bbshatter,a10
	movi	gndx+16,a11
#lp
	move	a8,a6
	move	*a11,a0
	jrn	#lft
	move	a9,a6
#lft
	abs	a0
	subi	190,a0
	jrn	#fixbb

	srl	4,a0			;/16
	sll	5,a0			;*32
	addi	#ani_t,a0
	move	*a10,a14
	jrz	#bok
	addi	#sani_t-#ani_t,a0,W
#bok
	move	*a0,a1,L
	move	a1,*a6(OIMG),L
	move	*a1,a2,L
	move	a2,*a6(OSIZE),L
	move	*a1(ISAG),*a6(OSAG),L

#slp	SLEEPK	1
	jruc	#lp

#fixbb	clr	a0
	move	a0,*a10			;Fix board
	jruc	#slp


#ani_t	.long	back2,back3,back4,back5,back6,back6,back6,back6,back6
#sani_t	.long	bturn_5,bturn_4,bturn_3,bturn_2,bturn_1,bbord_10
	.long	bbord_10,bbord_10,bbord_10,bbord_10


********************************
* Save the right backboard object ptr (Process)

 SUBRP	backboard_svrptr

	move	a8,@bbrgt_p,L
	DIE



#********************************
* Animate crowd at left edge of scrn
*

 SUBRP	lftcrowd_ani

;Top scrn crwd

	move	@bigcrwd1_ptr,a8,L
	movi	bigcrwd_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@bigcrwd2_ptr,a8,L
	movi	bigcrwd_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@crwd1_ptr,a8,L
	movi	crwd1_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@crwd3_ptr,a8,L
	movi	crwd3_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@crwd5_ptr,a8,L
	movi	crwd5_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

;Left side crwd

	move	@sl1_ptr,a8,L
	movi	s1_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sl2_ptr,a8,L
	movi	s2_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sl3_ptr,a8,L
	movi	s3_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sl4_ptr,a8,L
	movi	s4_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sl5_ptr,a8,L
	movi	s5_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sl6_ptr,a8,L
	movi	s6_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sl7_ptr,a8,L
	movi	s7_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sl8_ptr,a8,L
	movi	s8_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L






	move	@cheer1_ptr,a8,L
	movi	cheer1_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@cheer2_ptr,a8,L
	movi	cheer2_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

;	move	@cheer3_ptr,a8,L
;	movi	cheer1_lst,a10
;	CREATE0	crwd_ani
;	move	a8,*a0(PDATA),L
;	move	a10,*a0(PDATA+32),L



;rgtcrwd
	move	@bigcrwd3_ptr,a8,L
	movi	bigcrwd_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@bigcrwd2_ptr,a8,L
	movi	bigcrwd_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@crwd2_ptr,a8,L
	movi	crwd1_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@crwd4_ptr,a8,L
	movi	crwd3_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@crwd6_ptr,a8,L
	movi	crwd5_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

;rgt side crwd

	move	@sr1_ptr,a8,L
	movi	sr1_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sr2_ptr,a8,L
	movi	sr2_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sr3_ptr,a8,L
	movi	sr3_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sr4_ptr,a8,L
	movi	sr4_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sr5_ptr,a8,L
	movi	s5_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sr6_ptr,a8,L
	movi	s6_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sr7_ptr,a8,L
	movi	s72_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L

	move	@sr8_ptr,a8,L
	movi	s8_lst,a10
	CREATE0	crwd_ani
	move	a8,*a0(PDATA),L
	move	a10,*a0(PDATA+32),L


	rets


********************************

 SUBR	start_animate

	movk	1,a0
	move	a0,@crowd_animate
	SLEEP	4*60
	clr	a0
	move	a0,@crowd_animate
	DIE

crwd_ani
	SLEEPK	10
	move	@crowd_animate,a0
	jrz	crwd_ani


	move	*a13(PDATA),a8,L
	move	*a13(PDATA+32),a10,L
#lp
	move	*a10+,a1,L
	jrnz	#crwd
	jrz	crwd_ani


#crwd
	move	*a8(OIMG),a3,L		;>Set new img

	move	a1,*a8(OIMG),L
	move	*a1,a2,L
	move	a2,*a8(OSIZE),L
	move	*a1(ISAG),*a8(OSAG),L

	move	*a3(IANIOFFY),a14
	move	*a1(IANIOFFY),a0
	sub	a14,a0			;Newaniy-Oldaniy
	move	*a8(OYPOS),a14
	sub	a0,a14
	move	a14,*a8(OYPOS)

	move	*a3(IANIOFFX),a14
	move	*a1(IANIOFFX),a0
	sub	a14,a0			;Newanix-Oldanix
	move	*a8(OXPOS),a14
	sub	a0,a14
	move	a14,*a8(OXPOS)

	move	*a10+,a0
	calla	PRCSLP
	jruc	#lp


bigcrwd_lst
	LW	crowd401,5
	LW	crowd402,30
	LW	crowd401,5
	LWL0	crowd40,40

crwd1_lst
	LW	crowd1a2,4
	LW	crowd1a3,4
	LW	crowd1a4,4
	LW	crowd1a5,55
	LW	crowd1a4,4
	LW	crowd1a3,4
	LW	crowd1a2,4
	LWL0	crowd1a,60

crwd3_lst
	LW	crowd2a,10
	LW	crowd2a2,5
	LW	crowd2a3,5
	LW	crowd2a4,55
	LW	crowd2a3,5
	LW	crowd2a2,5
	LWL0	crowd2a,60

crwd5_lst
	LW	crowd3a2,6
	LW	crowd3a3,6
	LW	crowd3a4,16
	LW	crowd3a3,8
	LW	crowd3a2,8
	LWL0	crowd3,18

s1_lst
	LW	sdcrwd1b,6
	LW	sdcrwd1c,6
	LW	sdcrwd1b,6
	LWL0	sdcrwd1,6

s2_lst
	LW	sdcrwd2b,6
	LW	sdcrwd2c,6
	LW	sdcrwd2b,6
	LWL0	sdcrwd2,6

s3_lst
	LW	sdcrwd3b,6
	LW	sdcrwd3c,6
	LW	sdcrwd3b,6
	LWL0	sdcrwd3,6

s4_lst
	LW	sdcrwd4b,6
	LW	sdcrwd4c,6
	LW	sdcrwd4b,6
	LWL0	sdcrwd4,6

s5_lst
	LW	sdcrwd5b,6
	LW	sdcrwd5c,6
	LW	sdcrwd5b,6
	LWL0	sdcrwd5,6

s6_lst
	LW	sdcrwd6b,6
	LW	sdcrwd6c,6
	LW	sdcrwd6b,6
	LWL0	sdcrwd6,6

s7_lst
	LW	sdcrwd7b,6
	LW	sdcrwd7c,6
	LW	sdcrwd7b,6
	LWL0	sdcrwd7,60

s72_lst
	LW	sdcrwd7b,6
	LW	sdcrwd7c,6
	LWL0	sdcrwd7b,60

s8_lst
	LW	sdcrwd8b,6
	LW	sdcrwd8c,6
	LW	sdcrwd8b,6
	LWL0	sdcrwd8,6

sr1_lst
	LW	nsdcrwd1b,6
	LW	nsdcrwd1c,50
	LW	nsdcrwd1b,6
	LWL0	nsdcrwd1a,6

sr2_lst
	LW	nsdcrwd2b,40
	LW	nsdcrwd2c,80
	LW	nsdcrwd2b,10
	LWL0	nsdcrwd2a,30

sr3_lst
	LW	nsdcrwd3b,5
	LW	nsdcrwd3c,5
	LW	nsdcrwd3b,5
	LWL0	nsdcrwd3a,5

sr4_lst
	LW	nsdcrwd4b,6
	LW	nsdcrwd4c,6
	LW	nsdcrwd4b,6
	LWL0	nsdcrwd4a,6

cheer1_lst
	LW	cheer1,6
	LW	cheer2,6
	LW	cheer3,6
	LW	cheer4,6
	LW	cheer5,6
	LW	cheer6,6
	LW	cheer7,6
	LW	cheer6,6
	LW	cheer5,6
	LW	cheer6,6
	LW	cheer7,6
	LW	cheer6,6
	LW	cheer5,6
	LW	cheer6,6
	LW	cheer7,6
	LW	cheer3,6
	LW	cheer2a,6
	LWL0	cheer2,4*60

cheer2_lst
	LW	cary1,20
	LW	cary2,6
	LW	cary3,6
	LW	cary4,6
	LW	cary5,6
	LW	cary6,6
	LW	cary5,6
	LW	cary6,30
	LW	cary5,6
	LW	cary4,6
	LW	cary3,6
	LW	cary2,6
	LWL0	cary1,4*60

#*

	.def	random_ads

random_ads
	movi	adpid,a0
	calla	KIL1C

;Turn on random advertisement

;left side ad
	movk	01,a0			;10
	calla	RNDRNG0
	sll	5,a0

	movi	ad1_t,a1
	add	a0,a1
	move	*a1,a1,L

;reflection
	addi	ad1ref_t,a0
	move	*a0,a3,L

	move	@ad1_ptr,a8,L
	move	a1,*a8(OIMG),L
	move	*a1,a2,L
	move	a2,*a8(OSIZE),L
	move	*a1(ISAG),*a8(OSAG),L


;reflection
	move	@ad1ref_ptr,a8,L
	move	a3,*a8(OIMG),L
	move	*a3,a2,L
	move	a2,*a8(OSIZE),L
	move	*a3(ISAG),*a8(OSAG),L

	move	*a8(OIMG),a0,L
	cmpi	RF_KOM1_L,a0
	jrnz	#noani0
;Start an animation for this ad
	CREATE	adpid,MK3_ad
	jruc	#noani
#noani0
	cmpi	RF_CHAL_L,a0
	jrnz	#noani
;Start an animation for this ad
	CREATE	adpid,wwf_ad
#noani

;right side ad
	movk	3,a0
	calla	RNDRNG0
	sll	5,a0

	movi	ad2_t,a1
	add	a0,a1
	move	*a1,a1,L

;reflection
	addi	ad2ref_t,a0
	move	*a0,a3,L

	move	@ad2_ptr,a8,L
	move	a1,*a8(OIMG),L
	move	*a1,a2,L
	move	a2,*a8(OSIZE),L
	move	*a1(ISAG),*a8(OSAG),L


;reflection
	move	@ad2ref_ptr,a8,L
	move	a3,*a8(OIMG),L
	move	*a3,a2,L
	move	a2,*a8(OSIZE),L
	move	*a3(ISAG),*a8(OSAG),L



 SUBR	fix_floorclr
;Fix crowd_p pal for floor reflections!

	move	@oteam1,a2

;	btst	0,a0
;	jrz	#nrm2
;	move	@team2,a1
;#nrm2	move	a1,a2

	sll	5,a2
	addi	crt_pals_z,a2
#nx	move	*a2,a11,L

	movi	CROWD_p,a0
	calla	pal_find		;Put in PDATA??!!!!

	andi	0ff00h,a0

	move	a0,a1			;dest pal
	ori	236,a1
	move	a11,a0

	movk	9,a2			;9 colors
	calla	pal_set
	rets


ad1_t	.long	adjet
	.long	adhot
ad1ref_t
	.long	jetref
	.long	hotref

ad2_t	.long	adnba2,adjam2
	.long	admid2,adblue2
ad2ref_t
	.long	nbaref,jamref
	.long	midref,blueref



;ad1_t	.long	ad1,adjet
;	.long	adhot,AD_CHAL_L,AD_KOM1_L,AD_PEK_L
;	.long	AD_III_L,AD_KANO_L,AD_KOM1_L,AD_KOM1_L,AD_CHAL_L
;ad1ref_t
;	.long	ad1ref,jetref
;	.long	hotref,RF_CHAL_L,RF_KOM1_L,RF_PEK_L
;	.long	RF_III_L,RF_KANO_L,RF_KOM1_L,RF_KOM1_L,RF_CHAL_L
;
;ad2_t	.long	ad2,adnba2,adjam2
;	.long	adrecy2,admid2,adblue2,AD_REV_R,AD_SMO_R,AD_MUS_R
;ad2ref_t
;	.long	ad2ref,nbaref,jamref
;	.long	recycref,midref,blueref,RF_REV_R,RF_SMO_R,RF_MUS_R



wwf_t	.long	AD_CHAL_L,RF_CHAL_L
	.long	AD_WWF_L,RF_WWF_L
	.long	0

MK3_t	.long	AD_KOM1_L,5*60
	.long	AD_KOM2_L,4
	.long	AD_KOM1_L,4
	.long	AD_KOM2_L,4
	.long	AD_KOM1_L,30
	.long	AD_KOM2_L,5
	.long	AD_KOM1_L,5
	.long	AD_KOM2_L,5
	.long	AD_KOM1_L,5
	.long	AD_KOM2_L,5
	.long	0

wwf_ad	movi	wwf_t,a9
wwf_lp
	move	*a9+,a0,L
	jrz	wwf_ad
	move	*a9+,a1,L

	move	@ad1_ptr,a8,L
	move	a0,*a8(OIMG),L
	move	*a0,a2,L
	move	a2,*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

;reflection
	move	@ad1ref_ptr,a8,L
	move	a1,*a8(OIMG),L
	move	*a1,a2,L
	move	a2,*a8(OSIZE),L
	move	*a1(ISAG),*a8(OSAG),L

	SLEEP	120
	jruc	wwf_lp

MK3_ad	movi	MK3_t,a9
mk3_lp
	move	*a9+,a0,L
	jrz	MK3_ad
;	move	*a9+,a1,L

	move	@ad1_ptr,a8,L
	move	a0,*a8(OIMG),L
	move	*a0,a2,L
	move	a2,*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L


;reflection
;	move	@ad1ref_ptr,a8,L
;	move	a1,*a8(OIMG),L
;	move	*a1,a2,L
;	move	a2,*a8(OSIZE),L
;	move	*a1(ISAG),*a8(OSAG),L

	move	*a9+,a0,L
	calla	PRCSLP
	jruc	mk3_lp

#********************************
* Animate net/rim after made or missed shot
* A0=0 if left hoop, !0 if rgt hoop
* A1=Ani type (0-6)
* Trashes scratch

 SUBR	net_ani

	PUSH	a7,a8,a9,a10

	move	a0,a0
	jrz	#lft
	move	@rimrf,a8,L		;*Right hoop objs
	move	@rimrb,a9,L
    	jruc	#tag

#lft
	move	@rimlf,a8,L		;Left ^
	move	@rimlb,a9,L
#tag
	sll	5,a1			;*32
	addi	#net_t,a1
	move	*a1,a10,L
	CREATE	HOOP_PID,do_net_ani
	PULL	a7,a8,a9,a10
	rets


#net_t	.long	net0_l	;Shot swish/bank in
	.long	net1_l	;Dunk/bend rim
	.long	net2_l	;Soft ball roll in
	.long	net3_l	;Long shot swish
	.long	net4_l	;Missed shot bend rim
	.long	net5_l	;Shatter backboard
	.long	net6_l	;Burn net


********************************

do_net_ani

#lp	move	*a10+,a0,L
	jaz	SUCIDE

;	setf	3,0,0
;	move	*a0(ICTRL+12),a14
;	move	a14,*a8(OCTRL+12)	;Write bits per pixel
;	move	a14,*a9(OCTRL+12)
;	setf	16,1,0

	move	*a8(OFLAGS),a1
	calla	obj_aniq

	move	*a10+,a0,L
	move	a8,a2
	move	a9,a8
	move	*a8(OFLAGS),a1
	calla	obj_aniq
	move	a2,a8

	SLEEPK	4
	jruc	#lp


net0_l
	.long	swish1f,swish1b
	.long	swish2f,swish2b
	.long	swish3f,swish3b
	.long	swish4f,swish4b
	.long	swish5f,swish5b
	.long	swish3f,swish3b
	.long	swish2f,swish2b
	.long	swish1f,swish1b
	.long	rim1f,rim1b,0
net1_l
	.long	rim2f,rim2b
	.long	rim3f,rim3b
	.long	rim4f,rim4b
	.long	swish4f,swish4b
	.long	swish5f,swish5b
	.long	swish3f,swish3b
	.long	swish2f,swish2b
	.long	swish1f,swish1b
	.long	rim1f,rim1b,0
net2_l
	.long	swish1f,swish1b
	.long	swish2f,swish2b
	.long	swish1f,swish1b
	.long	rim1f,rim1b,0
net3_l
	.long	farshot1f,farshot1b
	.long	farshot2f,farshot2b
	.long	farshot3f,farshot3b
	.long	farshot4f,farshot4b
	.long	farshot3f,farshot3b
	.long	farshot2f,farshot2b
	.long	farshot1f,farshot1b
	.long	rim1f,rim1b,0
net4_l
	.long	rim3f,rim3b
	.long	rim1f,rim1b,0
net5_l
	.long	rimbndF_1,rimbndB_1
	.long	rimbndF_2,rimbndB_2
	.long	rimbndF_3,rimbndB_3
	.long	rimbndF_4,rimbndB_4
	.long	rimbndF_5,rimbndB_5
	.long	rimbndF_6,rimbndB_6
	.long	rimbndF_7,rimbndB_7
	.long	rimbndF_8,rimbndB_8
	.long	rimbndF_9,rimbndB_9
	.long	rimbndF_10,rimbndB_10
	.long	rimbndF_11,rimbndB_11
	.long	rimbndF_12,rimbndB_12
	.long	rimbndF_13,rimbndB_13
	.long	rimbndF_14,rimbndB_14
	.long	rimbndF_15,rimbndB_15
	.long	rimbndF_16,rimbndB_16
	.long	rimbndF_17,rimbndB_17
	.long	rim1f,rim1b,0
net6_l
	.long	firimF_1,firimB_1
	.long	firimF_2,firimB_2
	.long	firimF_3,firimB_3
	.long	firimF_4,firimB_4
	.long	firimF_5,firimB_5
	.long	firimF_6,firimB_6
	.long	firimF_7,firimB_7
	.long	firimF_8,firimB_8
	.long	firimF_9,firimB_9
	.long	firimF_10,firimB_10
	.long	firimF_12,firimB_11
	.long	firimF_13,firimB_11
	.long	firimF_14,firimB_11
	.long	firimF_15,firimB_11
	.long	firimF_16,firimB_11
	.long	firimF_17,firimB_11
	.long	firimF_11,firimB_11,0



#*******************************
* Display player and game status info (Process)

 SUBRP	status_display

	clr	a0
	move	a0,@P1DATA+ply_messages,L	;zero player message img pntr
	move	a0,@P2DATA+ply_messages,L
	move	a0,@P3DATA+ply_messages,L
	move	a0,@P4DATA+ply_messages,L

	move	a0,@P1DATA+ply_idiot_use
	move	a0,@P2DATA+ply_idiot_use
	move	a0,@P3DATA+ply_idiot_use
	move	a0,@P4DATA+ply_idiot_use

	movi	#init_t,a11		;>Setup status images
	movi	msg_ram,a9		;keep crplate pntr for % printout
	callr	prt_status

	move	@msg_ram,a0,L
	move	a0,@crplate_ptr,L

	move	@PSTATUS,a0
	btst	0,a0
	jrz	#tag

	movi	init_t1,a11
	movi	P1DATA+ply_meter_imgs,a9
	callr	prt_status

;	movi	P1DATA,a11		;A11=*plyr data
;	calla	refill_turbo

	jruc	#tag1

#tag
	movi	init_t1a,a11
	movi	P1DATA+ply_messages,a9
	callr	prt_status
;
;	movi	init_t1b,a11
;	movi	P1DATA+ply_meter_imgs+20h,a9
	movi	init_t1,a11
	movi	P1DATA+ply_meter_imgs,a9

	callr	prt_status

	move	@P1DATA+ply_meter_imgs,a0,L
	calla	OBJOFF

	move	@P1DATA+ply_meter_imgs+20h,a0,L
	calla	OBJOFF
	move	@P1DATA+ply_meter_imgs+40h,a0,L
	calla	OBJOFF

#tag1
	movi	P1DATA,a11		;A11=*plyr data
	calla	refill_turbo

	move	@PSTATUS,a0
	btst	1,a0
	jrz	#tag2

	movi	init_t2kit,a11

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrs

	movi	init_t2,a11
#2_plyrs


	movi	P2DATA+ply_meter_imgs,a9
	callr	prt_status

;	movi	P2DATA,a11		;A11=*plyr data
;	calla	refill_turbo

	jruc	#tag3
#tag2
	movi	init_t2a,a11
	movi	P2DATA+ply_messages,a9
	callr	prt_status


	movi	init_t2kit,a11

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrsa

	movi	init_t2,a11
#2_plyrsa

	movi	P2DATA+ply_meter_imgs,a9

	callr	prt_status


;	movi	init_t2b,a11
;	movi	P2DATA+ply_meter_imgs+20h,a9

	move	@P2DATA+ply_meter_imgs,a0,L
	calla	OBJOFF

	move	@P2DATA+ply_meter_imgs+20h,a0,L
	calla	OBJOFF
	move	@P2DATA+ply_meter_imgs+40h,a0,L
	calla	OBJOFF

#tag3
	movi	P2DATA,a11		;A11=*plyr data
	calla	refill_turbo

	move	@PSTATUS,a0
	btst	2,a0
	jrz	#tag4

	movi	init_t3kit,a11

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrsb

	movi	init_t3,a11
#2_plyrsb


	movi	P3DATA+ply_meter_imgs,a9
	callr	prt_status

;	movi	P3DATA,a11		;A11=*plyr data
;	calla	refill_turbo

	jruc	#tag5
#tag4
	movi	init_t3a,a11
	movi	P3DATA+ply_messages,a9
	callr	prt_status

;	movi	init_t3b,a11


	movi	init_t3kit,a11

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrsc

	movi	init_t3,a11
#2_plyrsc





;	movi	P3DATA+ply_meter_imgs+20h,a9
	movi	P3DATA+ply_meter_imgs,a9
	callr	prt_status
	move	@P3DATA+ply_meter_imgs,a0,L
	calla	OBJOFF
	move	@P3DATA+ply_meter_imgs+20h,a0,L
	calla	OBJOFF
	move	@P3DATA+ply_meter_imgs+40h,a0,L
	calla	OBJOFF

#tag5
	movi	P3DATA,a11		;A11=*plyr data
	calla	refill_turbo

	move	@PSTATUS,a0
	btst	3,a0
	jrz	#tag6

	movi	init_t4,a11
	movi	P4DATA+ply_meter_imgs,a9
	callr	prt_status

;	movi	P4DATA,a11		;A11=*plyr data
;	calla	refill_turbo

	jruc	#tag7
#tag6
	movi	init_t4a,a11
	movi	P4DATA+ply_messages,a9
	callr	prt_status
;	movi	init_t4b,a11
	movi	init_t4,a11
;	movi	P4DATA+ply_meter_imgs+20h,a9
	movi	P4DATA+ply_meter_imgs,a9
	callr	prt_status
	move	@P4DATA+ply_meter_imgs,a0,L
	calla	OBJOFF
	move	@P4DATA+ply_meter_imgs+20h,a0,L
	calla	OBJOFF
	move	@P4DATA+ply_meter_imgs+40h,a0,L
	calla	OBJOFF
#tag7
	movi	P4DATA,a11		;A11=*plyr data
	calla	refill_turbo

	calla	prt_top_scores		;Update scores at scrn top
	calla	prt_cr_timers



	movi	seccall1+>3df2,a0	;>Chksum security call code
	movk	(seccall1end-seccall1)/16,b0
	movi	->259e0d-2,a8		;1st value
#csumlp	move	*a0(->3df2),a1
	add	a1,a8
	addk	16,a0
	dsj	b0,#csumlp
					;>Chksum security_chk code
	movi	security_chk+>4bbb,a0
	movi	68+128*2,b0		;#Words
#csmlp	move	*a0(->4bbb),a1
	add	a1,a8
	addk	16,a0
	dsj	b0,#csmlp



	SLEEPK	5
	calla	update_scorebrd

	clr	a0
	movk	4,a1
	callr	net_ani			;Ani both nets to fix alignment
	movk	1,a0
	movk	4,a1
	callr	net_ani

	CREATE0	security_trashstuff	;Pass A8

	callr	lftcrowd_ani
	DIE

#lp
	move	*a11+,a1		;Y
	sll	16,a0
	sll	16,a1
	move	*a11+,a3		;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	move	*a11+,a2,L
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a9+,L		;keep led img pntr

 SUBR	prt_status

	move	*a11+,a0		;X
	cmpi	4000,a0
	jrne	#lp			;!End?
	rets

#x	.equ	15+4
#x2	.equ	236+10
#y	.equ	2
#z	.equ	300

#init_t
	.word	>af,#y-2,948
	.long	crplate			;top credit plate

	.word	4000

init_t1
	.word	#x+27,#y-2+8,#z
	.long	LED_00			;timebox
init_t1b
	.word	#x+28,#y-2+12,#z
;	.long	METERr
	.long	METERb
	.word	#x-2,#y-2,#z+1
;	.long	LITUPr
	.long	LITUPb

	.word	4000

init_t1a				;not in game, insert coin
	.word	#x+30,#y-2+8,#z
	.long	insert

	.word	4000

init_t2
	.word	#x+90-10+27,#y-2+8,#z
	.long	LED_00			;timebox
init_t2b
	.word	#x+90-10+28,#y-2+12,#z
;	.long	METERy
	.long	METERg
	.word	#x+90-10-2,#y-2,#z+1
;	.long	LITUPy
	.long	LITUPg

	.word	4000
init_t2kit
	.word	#x+90-10+27,#y-2+8,#z
	.long	LED_00			;timebox
init_t2bkit
	.word	#x+90-10+28,#y-2+12,#z
;	.long	METERy
	.long	METERb
	.word	#x+90-10-2,#y-2,#z+1
;	.long	LITUPy
	.long	LITUPb

	.word	4000

init_t2a				;not in game, insert coin
	.word	#x+90-10+30,#y-2+8,#z
	.long	insert

	.word	4000

init_t3
	.word	#x2+27,#y-2+8,#z
	.long	LED_00			;timebox
init_t3b
	.word	#x2+28,#y-2+12,#z
;	.long	METERg
	.long	METERy
	.word	#x2-2,#y-2,#z+1
;	.long	LITUPg
	.long	LITUPy

	.word	4000
init_t3kit
	.word	#x2+27,#y-2+8,#z
	.long	LED_00			;timebox
init_t3bkit
	.word	#x2+28,#y-2+12,#z
;	.long	METERg
	.long	METERr
	.word	#x2-2,#y-2,#z+1
;	.long	LITUPg
	.long	LITUPr

	.word	4000

init_t3a				;not in game, insert coin
	.word	#x2+30,#y-2+8,#z
	.long	insert

	.word	4000

init_t4
	.word	#x2+87-10+27,#y-2+8,#z
	.long	LED_00			;timebox
init_t4b
	.word	#x2+87-10+28,#y-2+12,#z
;	.long	METERb
	.long	METERr
	.word	#x2+87-10-2,#y-2,#z+1
;	.long	LITUPb
	.long	LITUPr

	.word	4000

init_t4a				;not in game, insert coin
	.word	#x2+87-10+30,#y-2+8,#z
	.long	insert

	.word	4000


********************************

COLRPRC
	movi	COLRPID,a0
	calla	KIL1C		;KILL ALL COLOR UPDATE PROCESSES
	clr	a0
	move	a0,@PALFRAM,L
	movi	scorep,a0	;Score area palette
	jauc	pal_getf




#*******************************
* Trash free object list because security failed (Process)
* A8=Security status (-2=OK!)

 SUBRP	security_trashstuff

	addk	2,a8
	jrz	#x		;OK?
	movi	TSEC*60*5+1,a0
	calla	RNDRNG0
	addi	TSEC*60*4-3,a0
	calla	PRCSLP		;Sleep 5-9 minutes
	movi	OFREE,a1
	movk	10,a2
#lp	move	*a1,a1,L
	dsj	a2,#lp
	move	a0,*a1,L	;Trash 10th free objs *next (-1)

#x	DIE



*******************************


;wbmcolor_t
;	.word	0380h,1380h,2380h,3380h,4380h,5380h,6380h,7380h,7300h
;	.word	7280h,7200h,7180h,7080h,7008h,7008h,7010h,7010h,701ch
;	.word	701ch,601ch,501ch,409ch,309ch,209ch,219ch,029ch,039ch
;	.word	139ch,239ch,339ch,539ch,739ch,7390h,7380h,6380h,4380h
;;need a duplicate set
;	.word	0380h,1380h,2380h,3380h,4380h,5380h,6380h,7380h,7300h
;	.word	7280h,7200h,7180h,7080h,7008h,7008h,7010h,7010h,701ch
;	.word	701ch,601ch,501ch,409ch,309ch,209ch,219ch,029ch,039ch
;	.word	139ch,239ch,339ch,539ch,739ch,7390h,7380h,6380h,4380h
;	.word	-1


********************************

;aud_plyrbeg
;
;	movk	AUDBEGIN,a0
;	calla	AUD1
;	move	@PSTATUS,a0
;	subk	3,a0
;;	jrne	apbx
;
;	MOVE	@GAMSTATE,A0
;	subk	ININTRO,A0		;IF IN INTRO, THE REGULAR START UP
;;	JRZ	apbx
;
;	movk	AUD1STRT,a0		;Mid game start
;	movi	-1,a1
;	jauc	AUD


********************************

 SUBR	WNDWON

	PUSHP	a8
	movk	1,a8
	MOVE	A8,@WFLG
	MOVI	[254,400],A8
	MOVI	SCRNMID,A10
	JSRP	OWINDOW
	MOVE	A8,@OBJPTR,L
	PULLP	a8
	RETP


 SUBR	WNDWOFF

	PUSHP	a8
	MOVE	@OBJPTR,A8,L
	JSRP	CWINDOW
	CLR	A0
	MOVE	A0,@WFLG
	PULLP	a8
	RETP



********************************
* Open a text window on the object list (JSRP)
* A8 =Window size
* A10=Center point of window (screen relative)
*
* >A8 = *Window object or 0 (Z)
* Trashes A9-A11

OWINDOW
	move	a8,a11

	move	a10,a0
	sll	16,a0
	clr	a1
	movy	a10,a1
	movi	FONT7A,a2
	movi	20001,a3		;Z
	movi	DMACAL,a4
	movi	CLSNEUT|TYPTEXT|SUBWNDW,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

	move	*a8(OXPOS),a10
	move	*a8(OYVAL),a0,L
	movy	a0,a10			;Get new world coords
	move	a10,a0

	srl	1,a11			;XY/2
	andi	>7fff7fff,a11

	subxy	a11,a10
	addxy	a0,a11

	move	@WSPEED,a0		;Window speed
	JSRP	OBJEXP32

	movi	OWSPD,a0
	move	a0,@WSPEED

	RETP


********************************
* CWINDOW - CLOSE A TEXT WINDOW, ON THE OBJECT LIST.
* A8 = PTR TO WINDOW OBJECT
* RETURNS:
*	WITH WINDOW OBJECT DELETED
* NOTE: CALL WITH JSRP
*	TRASHES A9,A10 & A11

CWINDOW
	MOVE	*A8(OXPOS),A10
	MOVE	*A8(OYVAL),A11,L
	MOVY	A11,A10
	MOVE	*A8(OSIZE),A11,L
	MOVY	A11,A1
	SRL	17,A1
	SLL	16,A1
	SLL	16,A11
	SRL	17,A11
	MOVY	A1,A11
	ADDXY	A11,A10
	MOVE	A10,A11			;CALCULATED CENTER OF OBJECT
	MOVI	CWSPD,A0			;WINDOW SPEED
	JSRP	OBJEXP32
	CALLA	DELOBJA8
	RETP

DELWNDW
	MOVE	@OBJPTR,A0,L
	MOVE	A0,A8
	jauc	DELOBJ


********************************
* SHRINK OR EXPAND AN OBJECT FROM THE CURRENT SIZE
*	      TO THE GIVEN SIZE IN A GIVEN AMOUNT OF TICKS.
* A0 =# OF TICKS
* A8 =*Obj
* A10=NEW OBJTL
* A11=NEW OBJLR
* Trashes A9

OBJEXP32
	sll	32-8,a0			;0-255
	srl	32-8,a0
	ori	1,a0

	MOVE	*A8(OXPOS),A1
	MOVE	*A8(OYVAL),A14,L
	MOVX	A1,A14			;A14 = OBJECT UL

	SLL	16,A1
	CLR	A2
	MOVY	A14,A2
	SUBXY	A10,A14
	MOVX	A14,A5
	SLL	16,A5
	DIVS	A0,A5
	NEG	A5
	MOVE	A5,A6
	CLR	A5
	MOVY	A14,A5
	DIVS	A0,A5
	NEG	A5
	MOVE	A5,A7

	MOVE	*A8(OXPOS),A3
	MOVE	*A8(OYVAL),A14,L
	MOVX	A3,A14
	MOVE	*A8(OSIZE),A3,L
	ADDXY	A3,A14			;A14 = OBJECT LR

	PUSH	A8
	MOVX	A14,A3
	SLL	16,A3
	CLR	A4
	MOVY	A14,A4
	SUBXY	A11,A14
	MOVX	A14,A5
	SLL	16,A5
	DIVS	A0,A5
	NEG	A5
	MOVE	A5,A8
	CLR	A5
	MOVY	A14,A5
	DIVS	A0,A5
	NEG	A5
	MOVE	A5,A9
	MOVE	A0,A5
	PULL	A14
OBJTIMLP
	ADD	A6,A1			;ADD THE TLX INCREMENT
	ADD	A7,A2			;ADD THE TLY INCREMENT
	ADD	A8,A3			;ADD THE LRX INCREMENT
	ADD	A9,A4			;ADD THE LRY INCREMENT
	MMTM	A12,A1,A2,A3,A4,A5,A6,A7,A14
	MOVE	A1,*A14(OXVAL),L
	MOVE	A2,*A14(OYVAL),L
	SUB	A1,A3
	SUB	A2,A4			;GET A SIZE FOR THE WINDOW
	SRL	16,A3
	MOVY	A4,A3
	callr	fixa3xy
	MOVE	A3,*A14(OSIZE),L
	SLEEPK	1
	MMFM	A12,A1,A2,A3,A4,A5,A6,A7,A14
	DSJS	A5,OBJTIMLP

	MOVE	A10,*A14(OXPOS)
	MOVY	A10,A1
	SRL	16,A1
	MOVE	A1,*A14(OYPOS)
	MOVE	A11,A9
	SUBXY	A10,A11
	MOVE	A11,A3
	callr	fixa3xy
	MOVE	A3,*A14(OSIZE),L	;MATCH WHAT THE CALLER WANTED
	MOVE	A9,A11			;PRESERVE FOR YUKS
	MOVE	A14,A8
	RETP


********************************
* Keep window XY size valid
* A3=Y:X

fixa3xy
	move	a3,a3
	jrgt	#yok
	movk	1,a0
	sll	16,a0
	movy	a0,a3
#yok
	movx	a3,a0
	sext	a0
	jrgt	#xok
	movk	1,a0
	movx	a0,a3
#xok
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



****************************************************************
* Temp routines

	.if	DEBUG

	.ref	dirqtimer

	BSSX	CPUAVG		,16
	BSSX	CPULEFT		,16


 SUBRP	cputime_calcfree

	move	@dirqtimer,a0
	subk	1,a0
	jrle	nobog
	clr	a0
	jruc	gottime
nobog
	move	@vcount,a0
	subi	EOSINT,a0
	jrnn	skinccnt
	addi	256,a0
skinccnt
	sll	2,a0
	neg	a0
	addi	1024,a0
gottime
	move	a0,@CPULEFT

	srl	4,a0
	move	@CPUAVG,a1
	move	a1,a2
	srl	4,a2			;/16
	sub	a2,a1
	add	a0,a1
	move	a1,@CPUAVG

	rets


	.endif


********************************

 SUBRP	testcode


#*******************************
* DMA window test (DEBUG)


	NOTINUSE

	dint

	clr	a0
	move	a0,@DMACTRL
	move	a0,@DMACTRL

	clr	a1			;>Clr screen mem
	movi	>200000/32,b0
#clrscr	move	a0,*a1+,L
	dsj	b0,#clrscr

	clr	a0
	move	a0,@DMATEST

	movi	0,a0
	move	a0,@DMAOFFST

	movk	>10,a1
	move	a1,@DMACONF
	movi	[350+56,50+56],a1	;L/R
	move	a1,@DMAWINDOW,L

	movi	>30,a1
	move	a1,@DMACONF		;Top/Bottom
	movi	[200,50],a1
	move	a1,@DMAWINDOW,L


	movi	[>100,>100],a3		;Y:X scale
	clr	a4
	movi	[100,100+56],a8		;Y:X
	movi	[100,200],a7		;V:H size
	movi	>2000000,a10		;SAG
	movi	>900c0000,a11		;CTRL:OFSET

	movi	20000,b2
#lp	rl	16,a4

	movi	DMAREGS,a14

#dwt	move	@DMACTRL,a0
	jrn	#dwt

	mmtm	a14,a3,a4,a7,a8,a10,a11

	rl	16,a4

#xok	addk	1,a4			;Color+1
	andi	>ff,a4
	move	a4,a0
	sll	8,a0
	or	a0,a4

	dsj	b2,#lp

	eint

	.endif




#*******************************
* DMA 1x1 test (DEBUG)


	NOTINUSE

	dint

	clr	a0
	move	a0,@DMACTRL
	move	a0,@DMACTRL

	clr	a1			;>Clr screen mem
	movi	>200000/32,b0
#clrscr	move	a0,*a1+,L
	dsj	b0,#clrscr

	clr	a0
	move	a0,@DMATEST

	movi	0,a0
	move	a0,@DMAOFFST

	movk	>10,a1
	move	a1,@DMACONF
	movi	[350,50],a1		;L/R
	movi	[399,0],a1		;L/R
	move	a1,@DMAWINDOW,L

	movi	>30,a1
	move	a1,@DMACONF		;Top/Bottom
	movi	[200,50],a1
	movi	[253,0],a1
	move	a1,@DMAWINDOW,L


	movi	[>100,>100],a3		;Y:X scale
	clr	a4
	clr	a8			;Y:X
	movi	>10001,a7		;V:H size
	movi	>2000000,a10		;SAG
	movi	>900c0000,a11		;CTRL:OFSET

#lp	rl	16,a4

	movi	DMAREGS,a14

#dwt	move	@DMACTRL,a0
	jrn	#dwt

	mmtm	a14,a3,a4,a7,a8,a10,a11

	rl	16,a4

	addk	1,a8
	btst	9,a8
	jrz	#xok
	addi	>10000,a8		;+1 Y
	btst	8+16,a8
	jrz	#yok
	addk	4,a4
#yok	andi	>ff01ff,a8

#xok	addk	1,a4
	andi	>ff,a4
	move	a4,a0
	sll	8,a0
	or	a0,a4

	addk	1,a10			;SAG+1

	jruc	#lp

	eint

	.endif



#*******************************
* Instruction speed test (DEBUG)

	NOTINUSE
;	.if	1

	dint
	movi	>2c,a0			;Enable cache
	movi	>802c,a0		;Disable cache
	move	a0,@CONTROL
	movi	>f010,a0
	move	a0,@DPYCTL
	move	@HSTCTLH,a0
	andi	>bfff,a0
	move	a0,@HSTCTLH


;	setf	32,1,1			;Field1 = Long word sign (slow!)
	movi	CPULEFT,a1

;	movi	50000000/(37+6),a0
;#lpsf	move	*a1,a14,L		;5,8
;	move	*a1,a14,L		;5,8
;	move	*a1,a14,L		;5,8
;	move	*a1,a14,L		;5,8
;	move	@CPUAVG,a14,L		;7,16
;	move	@CPUAVG,a14,L		;7,16
;	dsj	a0,#lpsf		;3,9


#nxt
	movi	VCOUNT,a7
	clr	a6
	movi	SCRATCH,a2

#lp	move	*a7,a0
	jrnz	#lp
#lp2	move	*a7,a0
	jrz	#lp2

#lp3
;	calla	#1
;	nop
;	nop
;	nop
;	nop
;#1	PULL	a0
;	movi	#2,a0
;	jauc	#2
;	nop
;	nop
;	nop
;	nop
;#2
;	movi	100,a0
;	nop
;	movi	>11111111,a0
;	move	@SCRATCH,a0
;	move	*a2(0),*a2(0)
;	move	*a2,a0
;	move	a0,*a2(0)
;	movi	SCRATCH,a1
;	move	*a1,a0,L
;	move	*a1,a0,L
;	move	a0,*a1,L
;	move	a0,*a1,L
;	move	a0,@SCRATCH,L
;	move	a0,@SCRATCH,L
;	move	@SCRATCH,a0,L
;	move	@SCRATCH,a0,L
	movi	SCRATCH+>1000,a0
	movi	SCRATCH+>1000,a1
;	move	-*a0,-*a1,L
;	move	-*a0,-*a1,L
;	move	-*a0,-*a1,L
;	move	-*a0,-*a1,L
;	move	-*a0,-*a1,L
;	move	-*a0,-*a1,L
	mmfm	a0,a1,a2,a3,a4,a5,a14
	mmtm	a0,a1,a2,a3,a4,a5,a14

	addk	1,a6			;1,4
	move	*a7,a0			;3,6
	jrnz	#lp3			;2,5

	movi	16*50000000/8/62,a1
	divu	a6,a1
	addk	18,a1			;+Fudge
	subi	15*16,a1		;-Overhead cycles
	move	a1,a0			;Round off
	addk	8,a0
	srl	4,a0

	trap	29
	jruc	#nxt


	movi	COLRAM,a8
#lp5	move	*a7,a0
#lp6	move	*a7,a1
	cmp	a1,a0
	jreq	#lp6

	movi	90,a2
	movk	5,a0
#lp8	move	a0,*a8		;1+(1),5
	addk	2,a0		;1,4
	dsj	a2,#lp8		;2,5
	jruc	#lp5

	eint

	.endif


	rets

 SUBR	set_names

	movi	player_names,a10
	move	@team1,a2

;	cmpi	27,a2
;	jrnz	#lp
;	movi	WILKINS,a1
;	movi	BROWN,a2
;	jruc	#dog


#lp	cmpi	0,a2
	jrz	#out
	addi	20*64,a10
	dec	a2
	jruc	#lp	
#out
	move	@team1,a0
	sll	4,a0
	addi	tm1set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10

	move	*a10,a1,L		;image addr
	move	*a10(20h),a2,L		;image addr

;#dog


	move	@special_heads,a14
	jrn	#not_spec1
	sll	5,a14				;x 32 bits
	addi	our_names,a14
	move	*a14,a1,L
#not_spec1
	move	a1,@names,L


	move	@special_heads+10h,a14
	jrn	#not_spec2
	sll	5,a14				;x 32 bits
	addi	our_names,a14
	move	*a14,a2,L
#not_spec2
	move	a2,@names+32,L


;Team 2
	movi	player_names,a10
	move	@team2,a2
#lp2	cmpi	0,a2
	jrz	#out2
	addi	20*64,a10
	dec	a2
	jruc	#lp2
#out2
	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10

	move	*a10,a1,L		;image addr
	move	*a10(20h),a2,L		;image addr

	move	@special_heads+20h,a14
	jrn	#not_spec3
	sll	5,a14				;x 32 bits
	addi	our_names,a14
	move	*a14,a1,L
#not_spec3
	move	a1,@names+64,L


	move	@special_heads+30h,a14
	jrn	#not_spec4
	sll	5,a14				;x 32 bits
	addi	our_names,a14
	move	*a14,a2,L
#not_spec4
	move	a2,@names+96,L

	rets

	.end
