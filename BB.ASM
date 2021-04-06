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
	.include	"world.equ"		;Court-world defs
	.include	"game.equ"
	.include	"audit.equ"
	.include	"macros.hdr"		;Macros

	.include	"credturb.tbl"
	.include	"credturb.glo"

	.include	"hoop.tbl"
	.include	"hoop.glo"

	.include	"outdoor.glo"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"imgtblp.glo"

	.asg		0,SEQT
	.include	"plyr.equ"

	.ref	initcrowd_ani
	.ref	game_initobjs

;sounds external

	.ref	snd_update
	.ref	SOUNDSUP
	.ref	QSNDRST

	.ref	heres_tip_sp,eat_snd
	.ref	start_crowd_noise



;symbols externally defined

	.ref	pup_court,pup_aba

	.ref	DBV
	.ref	VOLBTN_PRESS
	.ref	pup_tournament
;	.ref	RA_H
;	.ref	EB_H,JTO_H			;RA_H
	.ref	original_names
;	.ref	fire_flags

;	.ref	pal_find
	.ref	RNDPER
	.ref	TWOPLAYERS
	.ref	player1_data
	.ref	player2_data
	.ref	player3_data
	.ref	player4_data
	.if DRONES_2MORE
	.ref	player5_data
	.ref	player6_data
	.endif

	.ref	team1_control
	.ref	team2_control
	.ref	BTIME
	.ref	plyr_onfire

	.ref	last_name_time
	.ref	player_names
	.ref	CYCLE_TABLE
	.ref	pleasewt
	.ref	prt_credits
	.ref	clock_speed
	.ref	_4plyrsingame
	.ref	snd_play1ovr
	.ref	winningteam

	.ref	idiot_bits
	.ref	cntl_team,cntl_team_last,idiot_box
	.ref	bracket_drw
	.ref	sc_proc
	.ref	ballpnumlast
	.ref	ballprcv_p
	.ref	inbound
	.ref	ballsclastp
	.ref	ballshotinair		;Shooter # if shot in air, else -1

;	.ref	LED_00,LED_MAX

	.ref	QUARTR01
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
	.ref	ISHSTD
	.ref	hisclong

	.ref	gndstat
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
;	.ref	_3d_test

	.ref	PSTATUS
	.ref	P1DATA,P2DATA,P3DATA,P4DATA
	.if DRONES_2MORE
	.ref	P5DATA,P6DATA
	.endif
	.ref	plyrobj_t,plyrproc_t

	.ref	scores,game_time,prt_top_scores
	.ref	clock_strt
	.ref	update_scorebrd
	.ref	clear_player_stats,inc_player_stat
;	.ref	winner_stays_box

	.ref	plyr_start
	.ref	joy_read
	.ref	ball_main
;	.ref	gndx
	.ref	team1,team2
;	.ref	oteam1
	.ref	game_purchased
	.ref	security_chk
	.ref	assist_delay,assist_plyr

	.ref	CKDIAG,POWERCMOS,amode_start
	.ref	dirqtimer

;	.ref	clipsrunning
;	.ref	plyr_eoq_lockcont,cliplockretp
	.ref	system_restoregame,io_init
	.ref	slide_info_box_on_off
	.ref	p1_slide_box_flag,p2_slide_box_flag
	.ref	p3_slide_box_flag,p4_slide_box_flag
        .ref    creditscreen
	.ref	dronesmrt

	.if CRTALGN
	.ref	P1CTRL
	.ref	P2CTRL
	.ref	P3CTRL
	.ref	P4CTRL
	.endif

;symbols defined in this file

;	.def	qrtr1,qrtr2,qrtr3,qrtr4
;	.def	wbmcolor_t
	.def	init_t1a,init_t2a,init_t3a,init_t4a
	.def	timertcnt,PSTATUS2,COLRPRC
	.def	OWINDOW,CWINDOW
	.def	swstacktop, swstack_p


;uninitialized ram definitions

	.if	DEBUG
	BSSX	SLDEBUG		,16	;Shawn's debug
	BSSX	slowmotion	,16	;!0=Frames of delay for slow motion
	.endif

	;I changed PCNT to a 32-bit value instead of 16 'cuz I'm tired of
	; coding checks for the wraparound case, which happens every ten
	; minutes or so.  Since it's always treated as an unsigned value
	; anyway, it's perfectly safe to continue using it as a word. - JS
	.even
	BSSX	PCNT		,32	;Main loop cnt
;;;;	BSSX	PCNT		,16	;Main loop cnt

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

	
	BSSX	crplate_ptr	,32	;credit plate ptr
	BSSX	tm1_turbo	,32	;team turbo *objs
	BSSX	tm2_turbo	,32
	BSSX	msg_ram		,32*NUMPLYRS	;temp ram for flopping message/meters
	BSSX	name_cnt	,16	;Cntr for flopping to player names
	BSSX	name_flop	,16	;Flop name/buyin message 0 or 1
	BSSX	names		,32*NUMPLYRS	;pntrs to player imgs

	BSSX	crt_colors	,32	;Random pal for court - NDSP1.ASM
	BSSX	bkcrt_colors	,32
;;	BSSX	refcrt_colors	,32
	BSSX	steals_off	,16	;!0=ticks until steals can happen
	BSSX	pushing_delay 	,16	;!0=keep ball if pushed
	BSSX	pass_off	,16	;!0=Don't allow passing
	BSSX	rebound_delay	,16	;!0=Give rebound stat
;;	BSSX	crowd_aniflag	,16	;!0=Allow crowd animations
;;	BSSX	bench_aniflag	,16	;!0=Allow bench animations

; Timer variables. Must stay in order!!

	BSSX	timertcnt	,16	;Tick count

	BSSX	qtr_purchased	,16*4	;# game qtrs credit each player has

	BSSX	newptr		,32
	BSSX	newplyrs	,(32+16)*5

;	.bss	played3d	,16


	.ref	_serial_number
	.ref	_man_date
	.ref	InitPIC
	.ref	RemapIO
	.ref	SecFuncCheck

	BSSX	_coin_addr,32
	BSSX	_switch_addr,32
	BSSX	_switch2_addr,32
	BSSX	_watchdog_addr,32
	BSSX	_dipswitch_addr,32
	BSSX	_sound_addr,32
	BSSX	_soundirq_addr,32
	BSSX	_coin_counter_addr,32

;;	BSSX	tm1_meter_cnt,	16
;;	BSSX	tm1_meter_obj,	32
;;	BSSX	tm2_meter_cnt,	16
;;	BSSX	tm2_meter_obj,	32

;equates for this file


	.text


****************************************************************
* Reset entry point

 SUBR	init_prog

	.if 0

==========================
=;;; Old startup code ;;;=

	dint
	setf	16,1,0			;Field0 = Word sign extend
	setf	32,0,1			;Field1 = Long word
	movi	STCKST,sp		;Top of stack

	calla	InitPIC

;	.if	DEBUG
;	move	a0,@>1e00000		;Clr FPGA rom protect
;	.endif

; Moved to PU DIAGS
;	movi	0fe00h,a0  		;Hit reset bit
;	move	a0,@SOUND
;      	movi	100,a0			;Wait for it to catch
;	dsj	a0,$
;	movi	0ff00h,a0		;Let it go
;	move	a0,@SOUND

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

=;;; End of old startup code ;;;=
=================================

	.else

	dint				;Interrupts OFF
	setf	16,1,0			;Word sign extend
	setf	32,1,1			;Long word sign extend
	movi	STCKST,sp		;Setup the stack pointer

	clr 	a0			;Initial mode for VMUX chip
	move	a0,@VMUX_CONTROL,W

	movi	00030h,a0		;Hit sound reset bit
	move	a0,@COIN_COUNTERS	;This is where reset bit is
	movi	100,a0			;Wait for it to catch
	dsjs	a0,$	
	movi	00020h,a0		;Let it go
	move	a0,@COIN_COUNTERS


	move	@SOUNDIRQ,a0		;Read watchdog status
	btst	8,a0			;Is this reset from a watchdog?
	jrnz	initp50			; br=no

	movi	AUD_LOCKUP,a0		;Watchdog audit
	calla	AUD1

;04/01/95 - NOTE:  It may look a little dumb to have two calls to InitPIC
;here instead of one above before the read for the watchdog status and it may
;be tempting to move the InitPIC call to before the watchdog status read BUT
;don't do it!!!  The watchdog status MUST be read BEFORE the PIC is initialized
;or the status of the watchdog will be reset.

initp50
	calla	InitPIC			;Init PIC and I/O system

	move	a0,@WATCHDOG		;Kill the dog fer yucks
	calla	READ_DIP		;Read the dipswitches
	btst	6,a0			;Is power-up test bypass switch on?
	jaz	POWERTST		; br=do power-up tests; go to WARMSET

	calla	InitPIC			;Reinit PIC and I/O system

	.endif


#********************************
*

 SUBR	WARMSET

	dint
	setf	16,1,0			;Field0 = Word sign extend
	setf	32,0,1			;Field1 = Long zero extend
	movi	STCKST,sp		;Top of stack

	calla	InitPIC			;Reinit PIC and I/O system
;
; Enabled 3/19/96 ;MJL

;FIX!!!!  Keep in for ship....
	jauc	POWERCMOS		;Do CMOS power-up chk; go to PCMOSRET


 SUBR	PCMOSRET

	calla	init_all		;Init hardware

	move	b5,@_serial_number,L
	move	b6,@_man_date,L
	calla	SecFuncCheck		;Make sure security functions haven't
					; been mucked with
	calla	INIT_TAB		;Reset todays high score table

;	movk	1,a0
;	move	a0,@>fff80000,L

	.if	DEBUG
	callr	testcode
	.endif

;;;;	CREATE	SNDMON_PID,dcs_watchdog

	calla	CKDIAG
	jrz	#main_go		;No diag switches closed?

	CREATE	DIAG_PID,DIAG		;Fire off the diag process
	jruc	mainlp

#main_go
	.if	HEADCK
	.ref	debug_plyr_num
	clr	a0
	move	a0,@debug_plyr_num
	.endif

	CREATE0	amode_start		;Fire up the attract mode


#*******************************
* Main loop

 SUBR	mainlp

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
;Why...
;	jrnz	#ok5
;	clr	a1
;	move	a1,@rebound_delay

#ok5
;Used for disallowing swats off of rim...
	.ref	in_cylinder
	move	@in_cylinder,a0
	jrle	#ok6
	subk	1,a0
	move	a0,@in_cylinder
#ok6
;Used for converting rejection art into rebound art if ball just hit rim
	.ref	must_rebound
	move	@must_rebound,a0
	jrle	#ok7
	subk	1,a0
	move	a0,@must_rebound
#ok7



	.if	DEBUG
;	.bss	last_snd_st,16
;	move	@_soundirq_addr,a0
;	move	*a0,a0
;	andi	>400,a0
;	move	@last_snd_st,a14
;	cmp	a0,a14
;	jrz	wsr_1
;	LOCKUP
;wsr_1
;	move	a0,@last_snd_st
	callr	cputime_calcfree
	.endif

	move	@HALT,a0
	jrnz	#skipit
	move	@last_name_time,a0
	inc	a0
	move	a0,@last_name_time	;# ticks since player name called
#skipit

	;update all 32 bits of PCNT
	move	@PCNT,a0,L
	addk	1,a0
	move	a0,@PCNT,L

;	move	@PCNT,a0
;	addk	1,a0
;	move	a0,@PCNT

	movb	@DIPSWITCH-7,a0
	jrn	mainlp

	movi	ACTIVE,a13		;*Proc list
	CREATE	DIAG_PID,DIAG
	jruc	mainlp



#***************************************************************
* Unstack switch queue


 SUBRP	switch_unstack

;	clr	a4
;
;#lp	move	@swstack_p,a3,L
;	cmpi	swstacktop,a3		;Stack at start?
;	jreq	#x			;Empty?
;	move	@FREE,a0,L
;	jrz	#x			;No processes left?
;
;	move	*a3+,a0			;Get entry
;	move	a3,@swstack_p,L		;Update stack
;	sll	32-5,a0			;Max switch # 31
;	srl	32-5-4,a0		;*16
;	move	a0,a2
;	add	a0,a2
;	add	a0,a2			;*3
;	addi	switch_t,a2
;	move	*a2+,a1
;	jrz	#lp			;No PID?
;	move	*a2+,a7,L		;*Code
;	movi	ACTIVE,a13		;*Proc list
;	calla	GETPRC
;	addk	1,a4
;	jruc	#lp
;#x	subk	1,a4
;	jrle	#xx
;	LOCKUP
;#xx	rets

#lp	move	@swstack_p,a3,L
	cmpi	swstacktop,a3		;Stack at start? Yes if =
	jreq	#x
	move	@FREE,a0,L		;Any procs left? No if 0
	jrz	#x

	move	*a3+,a0			;Get entry
	move	a3,@swstack_p,L		;Update stack ptr
	sll	32-4,a0			;Clr bits above max (15) value
	srl	32-4-4,a0		;*16 for look-up calc
	move	a0,a2
	add	a0,a2
	add	a0,a2			;*3 for tbl offset from
	addi	switch_t,a2		; table start
	move	*a2+,a1			;Get switch PID; none if 0
	jrz	#lp
	move	*a2+,a7,L		;*Switch code
	movi	ACTIVE,a13		;*Proc list
	calla	GETPRC
	jruc	#lp

#x	rets

switch_t	;(Process ID or 0, *Routine)	;Put in audit??

	WL	LC_PID,    LCOIN	;S0  - LEFT COIN (1)
	WL	RC_PID,    RCOIN	;S1  - RIGHT COIN (2)
	WL	PSWPID,    plyr_strtb1	;S2  - START 1
	WL	SLAM_PID,  SLAM_SW	;S3  - SLAM TILT
	WL	DIAG_PID,  DIAG		;S4  - TEST
	WL	PSWPID,    plyr_strtb2	;S5  - START 2
	WL	DIAG_PID,  SERVICE	;S6  - SERVICE CREDIT
	WL	CC_PID,    CCOIN	;S7  - CENTER COIN (3)
	WL	CC_PID,    XCOIN	;S8  - COIN 4
	WL	PSWPID,    plyr_strtb3	;S9  - START 3
	WL	PSWPID,    plyr_strtb4	;S10 - START 4
	WL	VOLBTN_PID,VOLBTN_PRESS	;S11 - VOLUME DOWN
	WL	VOLBTN_PID,VOLBTN_PRESS	;S12 - VOLUME UP
	WL	0,0			;S13
	WL	0,0			;S14
	WL	CC_PID,    DBV		;S15 - DOLLAR BILL VALIDATOR

;old 32bit switch stack procs
;	WL	PSWPID,plyr_strtb4	;S7 IO20 - START 4
;	WL	0,0			;S1
;	WL	0,0			;S2
;	WL	0,0			;S3
;	WL	0,0			;S4
;	WL	0,0			;S5
;	WL	0,0			;S6
;	WL	PSWPID,plyr_strtb3	;S7 - START 3
;	WL	0,0			;S8
;	WL	0,0			;S9
;	WL	0,0			;S10
;	WL	0,0			;S11
;	WL	0,0			;S12
;	WL	0,0			;S13
;	WL	0,0			;S14
;	WL	CC_PID,XCOIN		;S15 - COIN 4
;	WL	LC_PID,LCOIN		;S16 - LEFT COIN (1)
;	WL	RC_PID,RCOIN		;S17 - RIGHT COIN (2)
;	WL	PSWPID,plyr_strtb1	;S18 - START 1
;	WL	SLAM_PID,SLAM_SW	;S19 - SLAM TILT
;	WL	DIAG_PID,DIAG		;S20 - TEST
;	WL	PSWPID,plyr_strtb2	;S21 - START 2
;	WL	DIAG_PID,SERVICE	;S22 - SERVICE CREDIT
;	WL	CC_PID,CCOIN		;S23 - CENTER COIN (3)
;	WL	0,0			;S24
;	WL	0,0			;S25
;	WL	0,0			;S26
;	WL	0,0			;S27
;	WL	0,0			;S28
;	WL	0,0			;S29
;	WL	0,0			;S30 - Snd IRQ
;	WL	0,0			;S31


****************************************************************
* plyr_strtbx - Process player start button (Process)

 SUBR	plyr_strtb1

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#strtb2

	clr	a8			;A8=Player #
	movi	P1DATA,a11		;A11=*plyr data

	move	@GAMSTATE,a0
	cmpi	IN_PRE_PLYR_DESIGN,a0
	jreq	#psb_x			;br=dont take credits (entering CREATE PLAYER)
	cmpi	INPLYRDESIGN,a0		;player designing character ?
	jrne	plyr_strtbut		;br=no

	move	@p1_slide_box_flag,a0
	jrnz	#psb_x			;br=process EXISTS...dont allow
	CREATE	P1_BOX_SLIDE_PID,slide_info_box_on_off	;br=tell player -CREDIT NOT TAKEN
	jruc	#psb_x			;dont process further


;-------------------
;-------------------
 SUBR	plyr_strtb2

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#strtb3
#strtb2
	movk	1,a8
	movi	P2DATA,a11

	move	@GAMSTATE,a0
	cmpi	IN_PRE_PLYR_DESIGN,a0
	jreq	#psb_x			;br=dont take credits (entering CREATE PLAYER)
	cmpi	INPLYRDESIGN,a0		;player designing character ?
	jrne	plyr_strtbut		;br=no

	move	@p2_slide_box_flag,a0
	jrnz	#psb_x			;br=process EXISTS...dont allow
	CREATE	P2_BOX_SLIDE_PID,slide_info_box_on_off	;br=tell player -CREDIT NOT TAKEN
	jruc	#psb_x			;dont process further


;-------------------
;-------------------
 SUBR	plyr_strtb3

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#psb_x
#strtb3
	movk	2,a8
	movi	P3DATA,a11

	move	@GAMSTATE,a0
	cmpi	IN_PRE_PLYR_DESIGN,a0
	jreq	#psb_x			;br=dont take credits (entering CREATE PLAYER)
	cmpi	INPLYRDESIGN,a0		;player designing character ?
	jrne	plyr_strtbut		;br=no

	move	@p3_slide_box_flag,a0
	jrnz	#psb_x			;br=process EXISTS...dont allow
	CREATE	P3_BOX_SLIDE_PID,slide_info_box_on_off	;br=tell player -CREDIT NOT TAKEN
	jruc	#psb_x			;dont process further


;-------------------
;-------------------
 SUBR	plyr_strtb4

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#psb_x

	movk	3,a8
	movi	P4DATA,a11

	move	@GAMSTATE,a0
	cmpi	IN_PRE_PLYR_DESIGN,a0
	jreq	#psb_x			;br=dont take credits (entering CREATE PLAYER)
	cmpi	INPLYRDESIGN,a0		;player designing character ?
	jrne	plyr_strtbut		;br=no

	move	@p4_slide_box_flag,a0
	jrnz	#psb_x			;br=process EXISTS...dont allow
	CREATE	P4_BOX_SLIDE_PID,slide_info_box_on_off	;br=tell player -CREDIT NOT TAKEN
	jruc	#psb_x			;dont process further


;--------------------
; Common start button process

plyr_strtbut
	movk	1,a0
	move	a0,@BTIME

	move	@GAMSTATE,a1
	cmpi	INAMODE,a1		;In attract? No if !=
	jrne	#chkstrt
	calla	CR_STRTP		;Yes. Have credits to start? Yes if >=
	jrhs	#chkstrt

	MOVI	CP_PID1,A0
	MOVI	0FFFFH,A1		;CHECK TO SEE IF CREDIT PAGE IS UP
	CALLA	EXISTP
	jrnz	SUCIDE			;br=yes, go die

	JSRP	creditscreen		;No. Show credits screen & restart
;	calla	display_blank		; attract
;	calla	WIPEOUT			;CLEAN SYSTEM OUT
;	SLEEPK	1
	jauc	amode_start

#chkstrt
	cmpi	INPLYRINFO,a1		;No start if on plyr info scrn
	jreq	#psb_x

	move	@WFLG,a0		;No start if window is growing
	jrnz	#psb_x
	move	@ENTERON,a0		;No start if initials being entered
	jrnz	#psb_x

	move	@pleasewt,a0		;No start if plyr should be waiting
	btst	a8,a0			;(bit #=plyr #)
	jrnz	#psb_x

	move	@PSTATUS,a0		;Chk plyr status. Already in game?
	btst	a8,a0			;(bit #=plyr #)
	jrz	#startplyr		;No if 0

	move	@game_purchased,a0	;Yes. Already bought whole game?
	btst	a8,a0			;(bit #=plyr #)
	jrz	#chkaddmore
;Yes. Show max'd message here & die
	DIE

#chkaddmore
	cmpi	INGAME,a1		;Don't add more during game play
	jrz	#psb_x

	calla	CR_CONTP		;Have credits to continue?
	jrlo	conttimers_cnt		;No if < (do continue timers & die)
	calla	P_CONT			;Yes. Take credits to continue

	SOUND1	eat_snd

	movk	AUD1CONT,a0		;Audit a continue
	calla	AUD1

	callr	add_plyr_time		;Add more to this players play time

	movk	ADJCCONT,a0		;Get # credits req'd to continue
	calla	GET_ADJ

	callr	paidcreds_add		;Update everything & die
	calla	update_scorebrd
	jruc	#psb_x


;--------------------
; Start new player

#startplyr
	move	@GAMSTATE,a1
	jrn	#psb_x			;In diagnostics? Yes if - (go die)
	cmpi	INGAMEOV,a1		;In game over? Yes if = (go die)
	jreq	#psb_x

	cmpi	INAMODE,a1		;New start from attract? Yes if =
	jreq	game_start
	cmpi	INFREEPRICE,a1		;New start on winners scrn?
	jreq	game_start2

	cmpi	ININTRO,a1		;New start on stats scrn? Yes if =
	jreq	#psbstart

	move	@game_time,a14,L	;Chk game clk. Do start if 0
	jrnz	#notz
	cmpi	INGAME,a1
	jrnz	#psbstart
	.if	DEBUG
	LOCKUP
	.endif
	DIE
#notz
	cmpi	2020000h,a14		;!!!Do start if >= 2:20.0 remain
	jrge	#psbstart

	movk	ADJFREPL,a0		;Well into qrtr but do start if in
	calla	GET_ADJ			; free play (is !0)
	jrnz	#psbstart

	move	@PSTATUS2,a0		;Not free. Chk for previous start
	btst	a8,a0			;(bit #=plyr #)
	jrz	#isnew			;Player never started? Never if 0

	calla	CR_CONTP		;Has. Have credits to continue?
	jalo	SUCIDE			;No if < (go die)
	jruc	#dowaitmes
#isnew
	calla	CR_STRTP		;Hasn't. Have credits to start?
	jalo	SUCIDE			;No if < (go die)
#dowaitmes
	movk	1,a0
	sll	a8,a0
	move	@pleasewt,a14		;Wants to start but can't. Set
	or	a0,a14			; is-waiting bit.
	move	a14,@pleasewt

	callr	plyr_ingame_wait	;Show "please wait" & die
	DIE

;--------------------
#psbstart
	move	a8,a14			;Make team # (0 or 1) from plyr #
	srl	1,a14
	move	@winningteam,a0
	cmp	a14,a0			;Was plyr on winning team?
	jreq	#psbfree		;Yes if = (start is free)

	move	@PSTATUS2,a0		;No. Chk for previous start
	btst	a8,a0			;(bit #=plyr #)
	jrz	#psbcred		;Player never started? Never if 0

	calla	CR_CONTP		;Has. Have credits to continue?
	jrlo	conttimers_cnt		;No if < (do continue timers & die)
	calla	P_CONT			;Yes. Take credits to continue

	SOUND1	eat_snd

#psbfree
	callr	add_plyr_time		;Add more to this players play time

	movk	AUD1CONT,a0		;Audit a continue
	calla	AUD1
	jruc	#dostart

#psbcred
	calla	CR_STRTP		;Hasn't. Have credits to start?
	jrlo	conttimers_cnt		;No if < (do continue timers & die)
	calla	P_START			;Yes. Take credits to start

	SOUND1	eat_snd

	callr	add_plyr_time		;Add more to this players play time

	move	@GAMSTATE,a1
	subk	ININTRO,a1		;Don't audit a start if in intro?!!!
	jreq	#dostart

	movk	AUD1STRT,a0		;Audit a start
	calla	AUD1

;--------------------
#dostart
	move	@GAMSTATE,a1		;Set common Ks
	movk	1,a7
	sll	a8,a7

	cmpi	ININTRO,a1		;If in intro, do regular start
	jreq	#do_psb_intro

	movk	ADJFREPL,a0		;If in free play, do free play start
	calla	GET_ADJ
	jrnz	#do_psb_free

	move	@game_time,a14,L	;In-game start. Chk game clk
	cmpi	2020000h,a14		;!!!Do start if >= 2:20.0 remain
	jrgt	#do_psb_free

	movk	ADJCSTRT,a0		;Get # credits req'd to start
	move	@PSTATUS2,a14		;Want start or continue credits?
	btst	a8,a14			;(bit #=plyr #)
	jrz	#psb1			;New start if 0
	movk	ADJCCONT,a0		;Get # credits req'd to continue
#psb1
	calla	GET_ADJ
	callr	paidcreds_add

	move	@pleasewt,a14		;Wants to start but can't. Set
	or	a7,a14			; is-waiting bit.
	move	a14,@pleasewt

	callr	plyr_ingame_wait	;Show "please wait" & die
	DIE

#do_psb_intro
	movk	ADJCSTRT,a0		;Get # credits req'd to start
	move	@PSTATUS2,a14		;Want start or continue credits?
	btst	a8,a14			;(bit #=plyr #)
	jrz	#psb2			;New start if 0
	movk	ADJCCONT,a0		;Get # credits req'd to continue
#psb2
	calla	GET_ADJ
	callr	paidcreds_add

	move	@PSTATUS,a14		;Set plyr in-game bit
	or	a7,a14
	move	a14,@PSTATUS

	move	@PSTATUS2,a14		;Set plyr has-started bit
	or	a7,a14
	move	a14,@PSTATUS2

	move	@gmqrtr,a0
	jrz	#inintro_x

	move	@newptr,a0,L
	move	a11,*a0+,L		;Save PnDATA ptr
	move	a8,*a0+			;Save plyr # (0,1,2,3)
	clr	a1			;Clr next long
	move	a1,*a0,L
	move	a0,@newptr,L

	jruc	#inintro_x

#do_psb_free
	movk	ADJCSTRT,a0		;Get # credits req'd to start
	move	@PSTATUS2,a14		;Want start or continue credits?
	btst	a8,a14			;(bit #=plyr #)
	jrz	#psb3			;New start if 0
	movk	ADJCCONT,a0		;Get # credits req'd to continue
#psb3
	calla	GET_ADJ
	callr	paidcreds_add

	move	@PSTATUS,a14		;Set plyr in-game bit
	or	a7,a14
	move	a14,@PSTATUS

	move	@PSTATUS2,a14		;Set plyr has-started bit
	or	a7,a14
	move	a14,@PSTATUS2


;--------------------
; Plyr name & turbo init; also created in <start_msgs> below
; A8=plyr # (0,1,2,3)
; A11=PnDATA ptr

#frepl
	movk	1,a0			;Init flop cntr & state flag
	move	a0,@name_cnt
	clr	a0
	move	a0,@name_flop
 
	move	@GAMSTATE,a14
	subk	ININTRO,a14		;In intro? No credit imgs to update
	jrz	#frp_1			; if so (if 0)
 
	movi	CLSDEAD|creditid,a0
	calla	obj_del1c		;Kill credit imgs
	calla	prt_credits		;Do updated credit imgs
#frp_1
	move	*a11(ply_messages),a0,L	;Any insert|press|please msg?
	jrz	#imgson_x		;Done with setup if not (if 0)

	calla	DELOBJ			;Kill the msg obj
	clr	a0
	move	a0,*a11(ply_messages),L

	PUSH	a8,a11

	move	a11,a9
	addi	ply_meter_imgs,a9

	move	a8,a0
	sll	5,a0
	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrs
	addi	4*32,a0
#4_plyrs
	addi	#cr_box,a0
	move	*a0,a11,L

	move	*a11(16),a14
	move	*a9+,a0,L
	move	a14,*a0(OYPOS)
	addi	16+16+16+32,a11

	move	*a9,a0,L
	jrz	#cv
	calla	DELOBJ
#cv
	callr	prt_status

	PULL	a8,a11

	calla	refill_turbo

;	movi	scorep,a0
;	calla	pal_getf
;	move	a0,a5
;
;	move	a8,a0
;	sll	5,a0
;;	move	a0,a9				;Put away for next segment
;	addi	names,a0
;	move	*a0,a0,L
;	move	*a11(ply_meter_imgs),a8,L	;change box to name
;	move	a5,*a8(OPAL)
;	movi	MSGOCTRL,a1
;	calla	obj_aniq_cnoff
;
;	addi	plyr_data_tbl,a9		;>Setup for created plyr name
;	move	*a9,a0,L
;	move	*a0(PR_CREATED_PLYR),a14
;	jrz	#inintro			;!!!Wanna go here?
;	addi	PR_NAME1,a0
;	movi	[END_CHAR,END_CHAR],a14
;	move	*a0,a1,L
;	cmpxy	a14,a1
;	jrxz	#inintro
;	jrxgt	#inintro
;	jrygt	#inintro
;	move	*a0(PR_NAME3),a1,L
;	cmpxy	a14,a1
;	jrxgt	#inintro
;	jrygt	#inintro
;	move	*a0(PR_NAME5),a1,L
;	cmpxy	a14,a1
;	jrxgt	#inintro
;	jrygt	#inintro
;	move	a0,*a8(ODATA_p),L
;	clr	a14
;	move	a14,*a8(OMISC)
;	move	*a8(OFLAGS),a14
;	addi	M_CHARGEN,a14,W
;	move	a14,*a8(OFLAGS)


;	PUSH	a6,a8,a11
;;;;;;;	calla	prt_cr_timers	<- Did nothing!
;	PULL	a6,a8,a11

#imgson_x
;	callr	plyr_ingame_wait

#inintro_x
;Use player name as a sound call

#psb_x
	DIE


#cr_box	.long	init_t1,init_t2,init_t3,init_t4
	.long	init_t1,init_t2kit,init_t3kit,init_t4

sticklst
	.word	p1stickid,p2stickid,p3stickid,p4stickid


;----------
;

 SUBR	start_msgs

	movi	newplyrs,a10
	move	a10,@newptr,L
	move	a10,a2

	movk	4,a9
start1
	move	*a10+,a11,L
	jrz	#done
	move	*a10+,a8
	CREATE0	#frepl
	dsj	a9,start1
#done
	clr	a0
	movk	5,a14
#clp
	move	a0,*a2+,L
	move	a0,*a2+,W
	dsjs	a14,#clp

	DIE


********************************
* A0=Units to add
* A8=Pnum (0-3)
* Trashes A0

paidcreds_add

	PUSH	a1,a2

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
	PULL	a1,a2
	rets

;needed	.word	6,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2

********************************
* Set "please wait" message
* A11=*PxDATA

 SUBRP	plyr_ingame_wait

	PUSH	a8

	move	*a11(ply_messages),a8,L
	movi	please,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	calla	update_scorebrd

	move	*a11(ply_meter_imgs),a0,L
	calla	OBJOFF
	move	*a11(ply_meter_imgs+32),a0,L
	calla	OBJOFF

	PULL	a8
	rets


#********************************
* A0=units to add

add_plyr_time
	
	movi	3500,a1
	move	a1,*a11(ply_time)

	movi	110,a0			;Shorter time for player names message
	move	a0,@name_cnt

	move	@GAMSTATE,a0
	subk	ININTRO,a0
	jreq	#x
	move	*a11(ply_meter_imgs),a0,L
	jrz	#nxt

	move	*a11(ply_meter_imgs+32),a0,L
	move	*a0(OIMG),a1,L
	cmpi	start,a1
	jrnz	#nxt
	movk	9,a1
	move	a1,*a0(OYPOS)
#nxt
;;;;;;;	jauc	prt_cr_timers	<- Did nothing!
#x
	rets


or_t	.word	1,2,4,8


********************************
* Add count to continue timers (Process)

 SUBRP	conttimers_cnt

	DIE


#***************************************************************
* Start game from INFREEPRICE mode (Process)
* A8=Plyr # (0-3)
* A11=*PxDATA

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

 SUBR	game_start

	calla	CR_STRTP
	jalo	SUCIDE			;Not enough credits?
	calla	P_START			;Take credits

	.ref	set_game_snd
	calla	set_game_snd
;;;;;;;	JSRP	QSNDRST	;Kill sleeps which made credit-eater bug!

gs2

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
	move	a0,@inmatchup
	move	a0,@pup_tournament
	move	a0,@pup_court			;default=INDOOR court
	move	a0,@pup_aba			;default=regular ball
	move	a0,@dronesmrt

	.ref	clear_secret_powerup_ram
	calla	clear_secret_powerup_ram

;	.ref	gme_strt_snd
;	SOUND1	gme_strt_snd

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

;For debugging certain teams, change these:

;	 0 ATLANTA
;	 1 BOSTON
;	 2 CHARLOTTE
;	 3 CHICAGO
;	 4 CLEVELAND
;	 5 DALLAS
;	 6 DENVER
;	 7 DETROIT
;	 8 GOLDEN STATE
;	 9 HOUSTON
;	10 INDIANA
;	11 LOS ANGELES (CLIPPERS)
;	12 LOS ANGELES (LAKERS)
;	13 MIAMI
;	14 MILWAUKEE
;	15 MINNESOTA
;	16 NEW JERSEY
;	17 NEW YORK
;	18 ORLANDO
;	19 PHILADELPHIA
;	20 PHOENIX
;	21 PORTLAND
;	22 SACRAMENTO
;	23 SAN ANTONIO
;	24 SEATTLE
;	25 TORONTO
;	26 UTAH
;	27 VANCOUVER
;	28 WASHINGTON


	clr	a0		;team #
	move	a0,@team1
	movk	3,a0		;Team #
	move	a0,@team2

#skip

;;FIXX!!! begin
;	.ref	TRIVIA_TEST
;	clr	a1
;	move	a1,@TRIVIA_TEST
;	move	a8,a0
;	.ref	get_stick_val_cur
;	calla	get_stick_val_cur
;	subk	1,a0
;	jrnz	#noqktriv
;	move	a8,a0
;	.ref	get_but_val_cur
;	calla	get_but_val_cur
;	subk	7,a0
;	jrnz	#noqktriv
;	movk	1,a0
;	move	a0,@TRIVIA_TEST
;	jruc	#redo
;#noqktriv
;;FIXX!!! end

	.if	DEBUG
	.ref	RIM_STEP
	.ref	CLOCK_OFF
	.ref	QUICK_TIP
	.ref	pup_showshotper
	.ref	get_all_sticks_cur2
	.ref	get_all_buttons_cur2
 	calla	get_all_sticks_cur2
	move	a0,a2
 	calla	get_all_buttons_cur2
;If stick held up at start, show outdoor court
	btst	0,a2
	jrz	#nooutdoor
	move	a2,@pup_court
#nooutdoor
;If pass button is pressed at start, allow rim-detect single-stepping
	clr	a1
	move	a1,@RIM_STEP
	btst	1,a0
	jrz	#norimstep
	move	a0,@RIM_STEP
#norimstep
;If turbo button is pressed at start, turn off clock
	clr	a1
	move	a1,@CLOCK_OFF
	btst	2,a0
	jrz	#noclkoff
	move	a0,@CLOCK_OFF
#noclkoff
;If shoot button is pressed at start, skip initials & go to game
	clr	a1
	move	a1,@QUICK_TIP
	btst	0,a0
	jrz	#normal
	move	a0,@QUICK_TIP
	move	a0,@pup_showshotper

	move	a8,a8
	jrz	#p1bp
	CREATE0	plyr_strtb1
#p1bp
	cmpi	1,a8
	jrz	#p2bp
	CREATE0	plyr_strtb2
#p2bp
	cmpi	2,a8
	jrz	#p3bp
	CREATE0	plyr_strtb3
#p3bp
	cmpi	3,a8
	jrz	#p4bp
	CREATE0	plyr_strtb4
#p4bp

	SLEEPK	1

	movk	>f,a0
	move	a0,@PSTATUS
	move	a0,@PSTATUS2		;Player has started bit flags
	
	jruc	#skip_entry				;Button pressed?

#normal
	.endif

#redo
	JSRP	initials_entry
	move	a0,a0			;is plyr coming from CREATE PLAYER ?
	jrz	#ok			;br=no
	jauc	amode_start		;Start attract mode
;;;;	jrne	#redo

	.if	DEBUG
#skip_entry
	.endif
#ok
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

	.ref	start_qrtr_tune
	calla	start_qrtr_tune


;;;;	JSRP	scrn_scaleout
;	movi	zoom_snd,a0
;	calla	snd_play1
;;;;	JSRP	scrn_scaleininit

	calla	WIPEOUT			;CLEAN SYSTEM OUT


 SUBR	demogame_start			;Demo mode entry

;	movi	zoom_snd,a0
;	calla	snd_play1

	JSRP	scrn_scaleininit	;Hide display

; ** JBJ commented out on 4-13-95
;;;;	movi	security_chk->1df60,a8

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

;	.ref	drone_alley_cnt
;	move	a0,@drone_alley_cnt	;3 successful drone alley oops/period

; ** JBJ commented out on 4-13-95
;-----------
;This is checksummed!
;seccall1
;	move	a8,a1			;>Check security
;	addi	>1df60,a1
;	getpc	a7
;	addi	>40,a7
;	move	a7,-*sp,L
;	jump	a1			;Rets: A0=0 if OK!
;seccall1end
;
;-----------
; ** JBJ commented out on 4-13-95

	clr	a0
	move	a0,@BTIME
	move	a0,@idiot_bits
	move	a0,@HALT
	move	a0,@_4plyrsingame

	.ref	_2plyr_competitive
	move	a0,@_2plyr_competitive

	movi	scores,a1
	move	a0,*a1+,L		;Team 1
	move	a0,*a1+,L		;Team 2
	move	a0,@timertcnt
	move	a0,@sc_proc,L
;	move	a0,@already_on,L   	;arw on hd 0=no or proc pntr
;	move	a0,@already_on+32,L
;	move	a0,@already_on+64,L
;	move	a0,@already_on+96,L
;	move	a0,@intercept_delay
;	move	a0,@fire_flags
	move	a0,@steals_off
	move	a0,@pass_off
	move	a0,@ballprcv_p,L
;;	move	a0,@crowd_aniflag
;;	move	a0,@bench_aniflag
	move	a0,@name_flop
	move	a0,@gmqrtr
	move	a0,@plyr_onfire
	.ref	SHK_ON
	move	a0,@SHK_ON

;;	move	a0,@tm1_meter_cnt
;;	move	a0,@tm2_meter_cnt

	movi	1 ,a0
	move	a0,@name_cnt

;	move	a0,@gmqrtr


	movi	-1,a0
	move	a0,@winningteam
	move	a0,@ballpnumlast	;last player who had ball
	move	a0,@inbound
	move	a0,@cntl_team
	move	a0,@cntl_team_last
	move	a0,@ballsclastp
	move	a0,@ballshotinair	;Shooter # if shot in air, else -1

;	movk	6,a0
;	move	a0,@next_call

;	.ref	sounds_list		;16 * 16 bits
;	movi	0ffffh,a0
;
;	movi	32,a2
;	movi	sounds_list,a1
;#slp
;	move	a0,*a1+
;	dsj	a2,#slp


	move	@pup_court,a14		;Outdoor court?
	jrz	#nootd			; br=no
	movk	OTD_CNT-1,a0
	calla	RNDRNG0
	sll	5,a0
	addi	otd_pal_objs,a0
	move	*a0,a2,L
	move	*a2(ICMAP),a0,L
	move	a0,@crt_colors,L
	clr	a0
	clr	a1
	clr	a3
	movi	>8000,a4
	clr	a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	jruc	#crtpset
#nootd
	move	@team1,a0
	sll	6,a0
;;	sll	5,a0
;;	move	a0,a14
;;	add	a0,a0
;;	add	a14,a0
	addi	crt_pals,a0
	move	*a0+,a14,L
	move	a14,@crt_colors,L
;;	move	*a0+,a14,L
	move	*a0,a14,L
	move	a14,@bkcrt_colors,L
;;	move	*a0,a14,L
;;	move	a14,@refcrt_colors,L

#crtpset

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

;	CREATE0	team_meters
	CREATE	STAT_PID,status_display
	SLEEPK	1


	.if	IMGVIEW
	.ref	anipts_debug
	clr	a8
	CREATE0 anipts_debug
	movk	3,a8
	CREATE0 anipts_debug
	.endif

	calla	game_initobjs

	.if CRTALGN
	.ref	gnd_aligndots
	CREATE0	gnd_aligndots
	.endif

	CREATE0	ball_main
	CREATE	gclockid,clock_strt	;start clock
	CREATE0	bracket_drw

;	.ref	plyr_camflash
;	CREATE0	plyr_camflash1

	CREATE0	close

	calla	clear_player_stats

;TEMP!!!
	.if	DEBUG
	.ref	sound_watchdog
	CREATE0	sound_watchdog
	.endif

	.ref	name_call
	CREATE0	name_call

	calla	start_crowd_noise
;	CREATE0	scream_snd
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


;	movk	1,a0
;	move	a0,@gmqrtr
;	move	a0,@game_time,L

	jauc	plyr_start

 SUBR	join_cyc
	.ref	COLTAB
	movi	[1,1],A8		;START AT COLOR 1, CYCLE 1 COLOR
	movi	JOININ_P,A9
	movi	COLTAB,A10		;TABLE TO CYCLE WITH
	movk	3,A11			;RATE OF CYCLE IN TICKS
	CREATE	JOIN_CYCLE_PID,CYCLE_TABLE	;START PROCESS TO DO CYCLE
	rets

;--------------------

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

;--------------------
; Team court palettes

otd_pal_objs
	.long	outdr1,outdr2,outdr3,outdr4,outdr5,outdr6
	.long	outdr7,outdr8,outdr9,outdr10,outdr11,outdr12
OTD_CNT	.equ	($-otd_pal_objs)/32

crt_pals
	.long	CRT_ATL_p,BK_ATL_P,CRT_BOS_p,BK_BOS_P
	.long	CRT_CHA_p,BK_CHA_P,CRT_CHI_p,BK_CHI_P
	.long	CRT_CLE_p,BK_CLE_P,CRT_DAL_p,BK_DAL_P
	.long	CRT_DEN_p,BK_DEN_P,CRT_DET_p,BK_DET_P
	.long	CRT_GLD_p,BK_GLD_P,CRT_HOU_p,BK_HOU_P
	.long	CRT_IND_p,BK_IND_P,CRT_LAC_p,BK_LAC_P
	.long	CRT_LAL_p,BK_LAL_P,CRT_MIA_p,BK_MIA_P
	.long	CRT_MIL_p,BK_MIL_P,CRT_MIN_p,BK_MIN_P
	.long	CRT_NEJ_p,BK_NEJ_P,CRT_NEY_p,BK_NEY_P
	.long	CRT_ORL_p,BK_ORL_P,CRT_PHI_p,BK_PHI_P
	.long	CRT_PHO_p,BK_PHO_P,CRT_POR_p,BK_POR_P
	.long	CRT_SAC_p,BK_SAC_P,CRT_SAN_p,BK_SAN_P
	.long	CRT_SEA_p,BK_SEA_P,CRT_TOR_p,BK_TOR_P
	.long	CRT_UTA_p,BK_UTA_P,CRT_VAN_p,BK_VAN_P
	.long	CRT_WAS_p,BK_WAS_P

;crt_pals
;	.long	CRT_ATL_P,BK_ATL_P,REF_DET_P,CRT_BOS_P,BK_BOS_P,REF_DET_P
;	.long	CRT_CHA_P,BK_CHA_P,REF_DET_P,CRT_CHI_P,BK_CHI_P,REF_DET_P
;	.long	CRT_CLE_P,BK_CLE_P,REF_DET_P,CRT_DAL_P,BK_DAL_P,REF_DET_P
;	.long	CRT_DEN_P,BK_DEN_P,REF_DET_P,CRT_DET_P,BK_DET_P,REF_DET_P
;	.long	CRT_GLD_P,BK_GLD_P,REF_DET_P,CRT_HOU_P,BK_HOU_P,REF_DET_P
;	.long	CRT_IND_P,BK_IND_P,REF_DET_P,CRT_LAC_P,BK_LAC_P,REF_DET_P
;	.long	CRT_LAL_P,BK_LAL_P,REF_LAL_P,CRT_MIA_P,BK_MIA_P,REF_DET_P
;	.long	CRT_MIL_P,BK_MIL_P,REF_DET_P,CRT_MIN_P,BK_MIN_P,REF_DET_P
;	.long	CRT_NEJ_P,BK_NEJ_P,REF_DET_P,CRT_NEY_P,BK_NEY_P,REF_DET_P
;	.long	CRT_ORL_P,BK_ORL_P,REF_DET_P,CRT_PHI_P,BK_PHI_P,REF_DET_P
;	.long	CRT_PHO_P,BK_PHO_P,REF_DET_P,CRT_POR_P,BK_POR_P,REF_DET_P
;	.long	CRT_SAC_P,BK_SAC_P,REF_DET_P,CRT_SAN_P,BK_SAN_P,REF_DET_P
;	.long	CRT_SEA_P,BK_SEA_P,REF_DET_P,CRT_TOR_P,BK_TOR_P,REF_DET_P
;	.long	CRT_UTA_P,BK_UTA_P,REF_DET_P,CRT_VAN_P,BK_VAN_P,REF_DET_P
;	.long	CRT_WAS_P,BK_WAS_P,REF_DET_P

	.def	crt_pals_z
crt_pals_z
	.long	CRT_ATL_p+32,CRT_BOS_p+32,CRT_CHA_p+32,CRT_CHI_p+32
	.long	CRT_CLE_p+32,CRT_DAL_p+32,CRT_DEN_p+32,CRT_DET_p+32
	.long	CRT_GLD_p+32,CRT_HOU_p+32,CRT_IND_p+32,CRT_LAC_p+32
	.long	CRT_LAL_p+32,CRT_MIA_p+32,CRT_MIL_p+32,CRT_MIN_p+32
	.long	CRT_NEJ_p+32,CRT_NEY_p+32,CRT_ORL_p+32,CRT_PHI_p+32
	.long	CRT_PHO_p+32,CRT_POR_p+32,CRT_SAC_p+32,CRT_SAN_p+32
	.long	CRT_SEA_p+32,CRT_TOR_p+32,CRT_UTA_p+32,CRT_VAN_p+32
	.long	CRT_WAS_p+32


;--------------------
;

 SUBR	start_arws

;	movi	ARWPID,a0
;	calla	KIL1C
;	movi	arwid,a0
;	calla	obj_del1c
;	movi	ARWPID,a0
;	calla	obj_del1c

	movi	ARWPID,a1			;>Do init stuff for humans
	movi	plyr_lost,a7,L

	movk	3,a10				;Pass plyr #
	calla	GETPRC
	movk	2,a10
	calla	GETPRC
	movk	1,a10
	calla	GETPRC
	clr	a10
	calla	GETPRC

	.ref	stick_numbers
	movi	stick_numbers,a7,L

	clr	a11
	movi	P1DATA,a10			;Pass *PnDATA
	calla	GETPRC
	movk	1,a11
	movi	P2DATA,a10
	calla	GETPRC
	movk	2,a11
	movi	P3DATA,a10
	calla	GETPRC
	movk	3,a11
	movi	P4DATA,a10
	calla	GETPRC

	.ref	stick_cpu
	movi	stick_cpu,a7,L

	clr	a11
	movi	P1DATA,a10
	calla	GETPRC
	movk	1,a11
	movi	P2DATA,a10
	calla	GETPRC
	movk	2,a11
	movi	P3DATA,a10
	calla	GETPRC
	movk	3,a11
	movi	P4DATA,a10
	calla	GETPRC

	.if DRONES_2MORE
	movk	4,a11
	movi	P5DATA,a10
	calla	GETPRC
	movk	5,a11
	movi	P6DATA,a10
	calla	GETPRC
	.endif

;	CREATE0	delay_sparks
	rets


;delay_sparks
;	.ref	stick_spark
;	.ref	stick_spark2
;	SLEEPK	10
;	move	@plyrproc_t,a0,L
;	move	*a0(plyr_attrib_p),a0,L
;	move	*a0(PAT_HEADT_p),a0,L
;	cmpi	RA_H,a0
;	jrnz	#ck2
;;	cmpi	EB_H,a0
;;	jrz	#doit1
;;	cmpi	JTO_H,a0
;;	jrnz	#ck2
;
;;	move	@special_heads,a0
;;	cmpi	32,a0
;;	jrnz	#ck2
;
;#doit1	clr	a11
;	movi	P1DATA,a10
;	CREATE	ARWPID,stick_spark
;	clr	a11
;	movi	P1DATA,a10
;	CREATE	ARWPID,stick_spark2
;#ck2
;	move	@plyrproc_t+32,a0,L
;	move	*a0(plyr_attrib_p),a0,L
;	move	*a0(PAT_HEADT_p),a0,L
;	cmpi	RA_H,a0
;	jrnz	#ck3
;;	cmpi	EB_H,a0
;;	jrz	#doit2
;;	cmpi	JTO_H,a0
;;	jrnz	#ck3
;
;;	move	@special_heads+10h,a0
;;	cmpi	32,a0
;;	jrnz	#ck3
;
;#doit2	movk	1,a11
;	movi	P2DATA,a10
;	CREATE	ARWPID,stick_spark
;	movk	1,a11
;	movi	P2DATA,a10
;	CREATE	ARWPID,stick_spark2
;#ck3
;	move	@plyrproc_t+64,a0,L
;	move	*a0(plyr_attrib_p),a0,L
;	move	*a0(PAT_HEADT_p),a0,L
;	cmpi	RA_H,a0
;	jrnz	#ck4
;;	cmpi	EB_H,a0
;;	jrz	#doit3
;;	cmpi	JTO_H,a0
;;	jrnz	#ck4
;
;;	move	@special_heads+20h,a0
;;	cmpi	32,a0
;;	jrnz	#ck4
;
;#doit3	movk	2,a11
;	movi	P3DATA,a10
;	CREATE	ARWPID,stick_spark
;	movk	2,a11
;	movi	P3DATA,a10
;	CREATE	ARWPID,stick_spark2
;#ck4
;	move	@plyrproc_t+96,a0,L
;	move	*a0(plyr_attrib_p),a0,L
;	move	*a0(PAT_HEADT_p),a0,L
;	cmpi	RA_H,a0
;	jrnz	#ck5
;;	cmpi	EB_H,a0
;;	jrz	#doit4
;;	cmpi	JTO_H,a0
;;	jrnz	#ck5
;
;;	move	@special_heads+30h,a0
;;	cmpi	32,a0
;;	jrnz	#ck5
;
;#doit4	movk	3,a11
;	movi	P4DATA,a10
;	CREATE	ARWPID,stick_spark
;	movk	3,a11
;	movi	P4DATA,a10
;	CREATE	ARWPID,stick_spark2
;#ck5
;	DIE

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

;	movi	organ1_snd,a0
;	move	@HCOUNT,a1
;	btst	1,a1
;	jrnz	#ckk
;	movi	organ2_snd,a0
;#ckk
;	calla	snd_play1

	DIE
	

try_ib
	movk	7,a0			;Use turbo to run
	jauc	idiot_box


********************************

close	
	SLEEPK	8
;	.ref	tune2_snd
;	SOUND1	tune2_snd

;	movi	zoom_snd,a0
;	calla	snd_play1

;;;;	JSRP	scrn_scalein

	movk	1,a0
	move	a0,@DISPLAYON
	calla	display_unblank

;	movi	2<<10+4<<5+9,a0

	clr	a0
	move	a0,@IRQSKYE


	movk	1,a0
	move	a0,@HALT	   ;stop movement until instructions are done


	.if	DEBUG
	move	@CLOCK_OFF,a0
	jrnz	#skip_inst
	move	@QUICK_TIP,a14
	jrnz	#skip_inst
	.endif
	.ref	instructions
	JSRP	instructions		;TAKE OUT to skip instructions!
#skip_inst

	clr	a0
	move	a0,@HALT	   ;start movement
	move	a0,@cntrs_delay

	SLEEP	35
	SOUND1	heres_tip_sp

;	SLEEP	120

;	.ref	winning_msg
;	CREATE0	winning_msg

	DIE


;#**********************************
;* Create and init team meters objs.
;
; SUBRP	team_meters
;
;	movi	#tm_mtr_init_tbl,a9,L
;
;;team 1 team meter
;	move	*a9+,a0			;X
;	move	*a9+,a1			;Y
;	sll	16,a0
;	sll	16,a1
;	move	*a9+,a3			;Z
;	move	*a9+,a2,L		;image			;Y
;	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
;	movi	CLSDEAD,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;	move	a8,@tm1_meter_obj,L	;keep *obj
;
;;team 2 team meter
;	move	*a9+,a0			;X
;	move	*a9+,a1			;Y
;	sll	16,a0
;	sll	16,a1
;	move	*a9+,a3			;Z
;	move	*a9,a2,L		;image			;Y
;	calla	BEGINOBJ2
;	move	a8,@tm2_meter_obj,L	;keep *obj
; 	DIE
;
;
;	.asg	25,TM_METR_Y
;;	.asg	27,TM_METR_Y
;	.asg	300,TM_METR_Z
;
;#tm_mtr_init_tbl
;	.word	54,TM_METR_Y,TM_METR_Z			;x,y
;	.long	TEAMZN_01b
;	.word	280,TM_METR_Y,TM_METR_Z			;x,y
;	.long	TEAMZN_01r
;
;
;#***************************************
;* Update count and image for team
;*
;* INPUT:  a1 - player number
;* 	 a14 - amount to add to meter
;*
; SUBR	update_team_meter
;
;	PUSH	a1
;
;	srl	1,a1
;	jrnz	#tm2
;
;	move	@tm1_meter_cnt,a1
;	add	a14,a1
;	cmpi	NUM_MTR_IMGS,a1			;value in range ?
;	jrlo	#ok1				;br=yes
;	movi	NUM_MTR_IMGS-1,a1		;set to max
;#ok1	move	a1,@tm1_meter_cnt
;	sll	5,a1
;	addi	tm_meter_img_tbl,a1
;	move	*a1,a14,L			;get NEW img ptr
;	move	@tm1_meter_obj,a1,L		;get CURRENT img ptr
;	jruc	#chng
;#tm2
;	move	@tm2_meter_cnt,a1
;	add	a14,a1
;	cmpi	NUM_MTR_IMGS,a1			;value in range ?
;	jrlo	#ok2				;br=yes
;	movi	NUM_MTR_IMGS-1,a1		;set to max
;#ok2	move	a1,@tm2_meter_cnt
;	sll	5,a1
;	addi	tm_meter_img_tbl,a1
;	move	*a1,a14,L			;get NEW img ptr.
;	move	@tm2_meter_obj,a1,L		;get CURRENT img ptr.
;#chng
;;	move	a14,*a1(OIMG),L			;update image
;;	move	*a14(0),*a1(OSIZE),L
;	move	*a14(0),*a1(OSAG),L
;
;	PULL	a1
; 	rets
; 
;
;tm_meter_img_tbl
;	.long	TEAMZN01
;	.long	TEAMZN02
;	.long	TEAMZN03
;	.long	TEAMZN04
;	.long	TEAMZN05
;	.long	TEAMZN06
;	.long	TEAMZN07
;	.long	TEAMZN08
;	.long	TEAMZN09
;	.long	TEAMZN10
;	.long	TEAMZN11
;	.long	TEAMZN12
;	.long	TEAMZN13
;	.long	TEAMZN14
;	.long	TEAMZN15
;	.long	TEAMZN16
;	.long	TEAMZN17
;	.long	TEAMZN18
;	.long	TEAMZN19
;	.long	TEAMZN20
;	.long	TEAMZN21
;	.long	TEAMZN22
;	.long	TEAMZN23
;	.long	TEAMZN24
;	.long	TEAMZN25
;	.long	TEAMZN26
;	.long	TEAMZN27
;	.long	TEAMZN28
;	.long	TEAMZN29
;	.long	TEAMZN30
;tm_meter_img_tbl_end
;
;NUM_MTR_IMGS	equ	(tm_meter_img_tbl_end-tm_meter_img_tbl)/32


#*******************************
* Display player and game status info (Process)

 SUBRP	status_display

	clr	a0
	move	a0,@P1DATA+ply_messages,L	;Zero plyr message img ptr
	move	a0,@P2DATA+ply_messages,L
	move	a0,@P3DATA+ply_messages,L
	move	a0,@P4DATA+ply_messages,L
	move	a0,@P1DATA+ply_idiot_use
	move	a0,@P2DATA+ply_idiot_use
	move	a0,@P3DATA+ply_idiot_use
	move	a0,@P4DATA+ply_idiot_use

	movi	#init_t,a11			;>Setup status images
	movi	crplate_ptr,a9,L
	callr	prt_status

;	movi	msg_ram,a9
;	move	@msg_ram,a0,L
;	callr	prt_status
;	move	a0,@crplate_ptr,L

;--------------------
; Setup plyr 1 name/turbo/coin objs

	movi	init_t1,a11
	movi	P1DATA+ply_meter_imgs,a9
	callr	prt_status
	move	@PSTATUS,a0
	btst	0,a0				;Is plyr 1 in? Yes if !0
	jrnz	#tag1
	movi	init_t1a,a11			;No. Setup "insert coin"
	movi	P1DATA+ply_messages,a9
	callr	prt_status
	move	@P1DATA+ply_meter_imgs,a0,L	;Turn off time/turbo objs
	calla	OBJOFF
	move	@P1DATA+ply_meter_imgs+32,a0,L
	calla	OBJOFF
#tag1
	movi	P1DATA,a11
	calla	refill_turbo

	movi	player1_data,a0,L
	move	*a0(PR_CREATED_PLYR),a14	;Is this a created plyr?
	subk	1,a14
	jrnz	#tag1a
	addi	PR_NAME1,a0			;Yes. Chk validity of name
	move	*a0,a1
	jrle	#tag1a				;Assume no name if first=0
	movk	NAME_LETTERS,a14
#tag1lp
	move	*a0+,a1
	cmpi	END_CHAR,a1,W			;In range? No if >
	jrhi	#tag1a
	dsj	a14,#tag1lp

	subi	NAME_LETTERS*16,a0		;Reset ptr
	move	@P1DATA+ply_meter_imgs,a1,L	;Put created *name in ODATA_p
	move	a0,*a1(ODATA_p),L		; of plyr name obj
	clr	a14
	move	a14,*a1(OMISC)			;Clr so char_gen calcs new X
	move	*a1(OFLAGS),a14			;Set obj type
	addi	M_CHARGEN,a14,W
	move	a14,*a1(OFLAGS)
#tag1a

;--------------------
; Setup plyr 2 name/turbo/coin objs

	movi	init_t2,a11
	move	@TWOPLAYERS,a14			;Two plyr kit? No if 0
	jrz	#2kit2
	movi	init_t2kit,a11
#2kit2	movi	P2DATA+ply_meter_imgs,a9
	callr	prt_status
	move	@PSTATUS,a0
	btst	1,a0				;Is plyr 2 in? Yes if !0
	jrnz	#tag2
	movi	init_t2a,a11			;No. Setup "insert coin"
	movi	P2DATA+ply_messages,a9
	callr	prt_status
	move	@P2DATA+ply_meter_imgs,a0,L	;Turn off time/turbo objs
	calla	OBJOFF
	move	@P2DATA+ply_meter_imgs+32,a0,L
	calla	OBJOFF
#tag2
	movi	P2DATA,a11
	calla	refill_turbo

	movi	player2_data,a0,L
	move	*a0(PR_CREATED_PLYR),a14	;Is this a created plyr?
	subk	1,a14
	jrnz	#tag2a
	addi	PR_NAME1,a0			;Yes. Chk validity of name
	move	*a0,a1
	jrle	#tag2a				;Assume no name if first=0
	movk	NAME_LETTERS,a14
#tag2lp
	move	*a0+,a1
	cmpi	END_CHAR,a1,W			;In range? No if >
	jrhi	#tag2a
	dsj	a14,#tag2lp

	subi	NAME_LETTERS*16,a0		;Reset ptr
	move	@P2DATA+ply_meter_imgs,a1,L	;Put created *name in ODATA_p
	move	a0,*a1(ODATA_p),L		; of plyr name obj
	clr	a14
	move	a14,*a1(OMISC)			;Clr so char_gen calcs new X
	move	*a1(OFLAGS),a14			;Set obj type
	addi	M_CHARGEN,a14,W
	move	a14,*a1(OFLAGS)
#tag2a

;--------------------
; Setup plyr 3 name/turbo/coin objs

	movi	init_t3,a11
	move	@TWOPLAYERS,a14			;Two plyr kit? No if 0
	jrz	#2kit3
	movi	init_t3kit,a11
#2kit3	movi	P3DATA+ply_meter_imgs,a9
	callr	prt_status
	move	@PSTATUS,a0
	btst	2,a0				;Is plyr 3 in? Yes if !0
	jrnz	#tag3
	movi	init_t3a,a11			;No. Setup "insert coin"
	movi	P3DATA+ply_messages,a9
	callr	prt_status
	move	@P3DATA+ply_meter_imgs,a0,L	;Turn off time/turbo objs
	calla	OBJOFF
	move	@P3DATA+ply_meter_imgs+32,a0,L
	calla	OBJOFF
#tag3
	movi	P3DATA,a11
	calla	refill_turbo

	movi	player3_data,a0,L
	move	*a0(PR_CREATED_PLYR),a14	;Is this a created plyr?
	subk	1,a14
	jrnz	#tag3a
	addi	PR_NAME1,a0			;Yes. Chk validity of name
	move	*a0,a1
	jrle	#tag3a				;Assume no name if first=0
	movk	NAME_LETTERS,a14
#tag3lp
	move	*a0+,a1
	cmpi	END_CHAR,a1,W			;In range? No if >
	jrhi	#tag3a
	dsj	a14,#tag3lp

	subi	NAME_LETTERS*16,a0		;Reset ptr
	move	@P3DATA+ply_meter_imgs,a1,L	;Put created *name in ODATA_p
	move	a0,*a1(ODATA_p),L		; of plyr name obj
	clr	a14
	move	a14,*a1(OMISC)			;Clr so char_gen calcs new X
	move	*a1(OFLAGS),a14			;Set obj type
	addi	M_CHARGEN,a14,W
	move	a14,*a1(OFLAGS)
#tag3a

;--------------------
; Setup plyr 4 name/turbo/coin objs

	movi	init_t4,a11
	movi	P4DATA+ply_meter_imgs,a9
	callr	prt_status
	move	@PSTATUS,a0
	btst	3,a0				;Is plyr 4 in? Yes if !0
	jrnz	#tag4
	movi	init_t4a,a11			;No. Setup "insert coin"
	movi	P4DATA+ply_messages,a9
	callr	prt_status
	move	@P4DATA+ply_meter_imgs,a0,L	;Turn off time/turbo objs
	calla	OBJOFF
	move	@P4DATA+ply_meter_imgs+32,a0,L
	calla	OBJOFF
#tag4
	movi	P4DATA,a11
	calla	refill_turbo

	movi	player4_data,a0,L
	move	*a0(PR_CREATED_PLYR),a14	;Is this a created plyr?
	subk	1,a14
	jrnz	#tag4a
	addi	PR_NAME1,a0			;Yes. Chk validity of name
	move	*a0,a1
	jrle	#tag4a				;Assume no name if first=0
	movk	NAME_LETTERS,a14
#tag4lp
	move	*a0+,a1
	cmpi	END_CHAR,a1,W			;In range? No if >
	jrhi	#tag4a
	dsj	a14,#tag4lp

	subi	NAME_LETTERS*16,a0		;Reset ptr
	move	@P4DATA+ply_meter_imgs,a1,L	;Put created *name in ODATA_p
	move	a0,*a1(ODATA_p),L		; of plyr name obj
	clr	a14
	move	a14,*a1(OMISC)			;Clr so char_gen calcs new X
	move	*a1(OFLAGS),a14			;Set obj type
	addi	M_CHARGEN,a14,W
	move	a14,*a1(OFLAGS)
#tag4a

;--------------------
;

	calla	prt_top_scores		;Update scores at scrn top
;;;;;;;	calla	prt_cr_timers	<- Did nothing!

; ** JBJ commented out on 4-13-95
;	movi	seccall1+>3df2,a0	;>Chksum security call code
;	movk	(seccall1end-seccall1)/16,b0
;	movi	->259e0d-2,a8		;1st value
;#csumlp	move	*a0(->3df2),a1
;	add	a1,a8
;	addk	16,a0
;	dsj	b0,#csumlp
;					;>Chksum security_chk code
;	movi	security_chk+>4bbb,a0
;	movi	68+128*2,b0		;#Words
;#csmlp	move	*a0(->4bbb),a1
;	add	a1,a8
;	addk	16,a0
;	dsj	b0,#csmlp
;; ** JBJ commented out on 4-13-95

	SLEEPK	5
	calla	update_scorebrd

; ** DJT - no need to do these net_ani's
;	clr	a0
;	movk	4,a1
;	callr	net_ani			;Ani both nets to fix alignment
;	movk	1,a0
;	movk	4,a1
;	callr	net_ani

; ** JBJ commented out on 4-13-95
;;;;	CREATE0	security_trashstuff	;Pass A8

	calla	initcrowd_ani
	DIE


********************************
* Create game status objs
* A11=obj init table ptr
* A9=ptr to sequentially store created *obj to
* Destroys A0-A8, *A9(-32)=last created *obj

#lp
	move	*a11+,a1		;Y
	sll	16,a0
	sll	16,a1
	move	*a11+,a3		;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	move	*a11+,a2,L		;OIMG
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a9+,L		;keep *obj

 SUBR	prt_status

	move	*a11+,a0		;X
	cmpi	4000,a0
	jrne	#lp			;!End?
	rets


;----------
;

#x1	.equ	14
#x2	.equ	240
#y	.equ	18
#z	.equ	300

#init_t
	.word	SCOREBRD_X,SCOREBRD_Y,SCOREBRD_Z
	.long	QUARTR01
;	.word	#x1+40,#y+9,#z
;	.long	TURBO_01b
;	.word	#x2+40,#y+9,#z
;	.long	TURBO_01r
	.word	4000

init_t1
	.word	#x1+32,#y-10,#z
	.long	insert			;LED_00			;timebox
	.word	#x1,#y,#z
	.long	TURBO_01b
	.word	4000
init_t1a				;not in game, insert coin
	.word	#x1+32,#y-10,#z
	.long	insert
	.word	4000

init_t2
	.word	#x1+80+32,#y-10,#z
	.long	insert			;LED_00			;timebox
	.word	#x1+80,#y,#z
	.long	TURBO_01g
	.word	4000
init_t2kit
	.word	#x1+80+32,#y-10,#z
	.long	insert			;LED_00			;timebox
	.word	#x1+80,#y,#z
	.long	TURBO_01b
	.word	4000
init_t2a				;not in game, insert coin
	.word	#x1+80+32,#y-10,#z
	.long	insert
	.word	4000

init_t3
	.word	#x2+32,#y-10,#z
	.long	insert			;LED_00			;timebox
	.word	#x2,#y,#z
	.long	TURBO_01y
	.word	4000
init_t3kit
	.word	#x2+32,#y-10,#z
	.long	insert			;LED_00			;timebox
	.word	#x2,#y,#z
	.long	TURBO_01r
	.word	4000
init_t3a				;not in game, insert coin
	.word	#x2+32,#y-10,#z
	.long	insert
	.word	4000

init_t4
	.word	#x2+80+32,#y-10,#z
	.long	insert			;LED_00			;timebox
	.word	#x2+80,#y,#z
	.long	TURBO_01r
	.word	4000
init_t4a				;not in game, insert coin
	.word	#x2+80+32,#y-10,#z
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

;	addk	2,a8
;	jrz	#x		;OK?
;	movi	TSEC*60*5+1,a0
;	calla	RNDRNG0
;	addi	TSEC*60*4-3,a0
;	calla	PRCSLP		;Sleep 5-9 minutes
;	movi	OFREE,a1
;	movk	10,a2
;#lp	move	*a1,a1,L
;	dsj	a2,#lp
;	move	a0,*a1,L	;Trash 10th free objs *next (-1)
;
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

********************************
* Set player name text

 SUBR	set_names

	movi	player_names,a10
	move	@team1,a2
#lp	cmpi	0,a2
	jrz	#out
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
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
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
;;	addi	20*64,a10
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


****************************************************************
* Temp routines

	.if	DEBUG

 SUBR	show_plyr_pal
;;Show player #0 pal to verify pal build
;
;	SLEEPK	10
;
;	movi	[200,0],a0
;	movi	[50,0],a1
;	movi	20000,a3
;	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
;	.ref	pal_block
;	movi	pal_block,a2
;	movi	CLSDEAD,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;	move	@plyrobj_t,a0,L
;	move	*a0(OPAL),a0
;	move	a0,*a8(OPAL)
;
	DIE

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


*****************************************************************************
	
	.if DEBUG

 SUBRP	testcode


#*******************************
* DMA window test (DEBUG)

	.if 0			;Totally commented out!

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

	.endif			;End of totally commented out!

#*******************************
* DMA 1x1 test (DEBUG)

	.if 0			;Totally commented out!

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

	.endif			;End of totally commented out!

#*******************************
* Instruction speed test (DEBUG)

	.if 0			;Totally commented out!

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

	.endif			;End of totally commented out!

	rets

	.endif	;DEBUG

*****************************************************************************

	.end
