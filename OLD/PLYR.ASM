**************************************************************
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		9/17/92
*
* Modified:		Shawn Liptak, 9/17/92	-Split from BB.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/24/93 16:21
**************************************************************

	.file	"plyr.asm"
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
	.include	"game.equ"
	.include	"shawn.hdr"		;Macros
	.asg		0,SEQT
	.include	"plyr.equ"


;sounds external

baddec_snd	.word	>f990,72,>81b7,0	;bad decision		<--change!

win_snd		.word	>f3ff,>8,>80a5,0	;Winner snd
;swipe_snd	.word	>f484,>4,>8119,0	;swipe at ball
swat_snd	.word	>fd94,15,>8157,0	;Swat ball (Steals & blocks)
steal_snd	.word	>fbf7,>8,>8093,0	;Steal
sqk1_snd	.word	>f584,>4,>8114,0	;Sneaker squeek
sqk2_snd	.word	>f584,>4,>8115,0
sqk3_snd	.word	>f584,>4,>8116,0
sqk4_snd	.word	>f584,>4,>8117,0
airball_snd	.word	>f894,>38,>814d,0	;crowd screams "air ball"
pass_snd	.word	>f3a7,>8,>808c,0	;short pass
whstle_snd	.word	>f9f5,>30,>8148,0	;Ref whistle at game start
;whstle2_snd	.word	>f9f5,>30,>8148,0	;Ref whistle for fouls
tuneend_snd	.word	>f3ff,>8,>8003,0	;End game time tune
;tuneend_snd	.word	>f3ff,>8,>8009,0	;End game time tune
tuneend1_snd	.word	>f3ff,>8,>800a,0	;End quarter 1 tune
tunehalf_snd	.word	>f3ff,>8,>8004,0	;Half time tune

anncr1_snd	.word	>f9f6,120,>818e,0	;He shoots from downtown
anncr2_snd	.word	>f9f6,110,>8190,0	;He shoots from the outside
anncr4_snd	.word	>f9f6,80,>8183,0	;At the buzzer
anncr5_snd	.word	>f9f6,70,>818b,0	;From long range
;deflectd	.word	>f991,40,>81a9,0	;deflected
fball_snd	.word	>fcb0,40,>8179,0	;Fire ball launch
overtime_snd	.word	>f9ff,69,>8180,0	;overtime!
rainbow_snd	.word	>f1a0,99,>81f0,0	;Rainbow


;symbols externally defined

	.ref	p1taps
	.ref	fatality
	.ref	seq_stopfire
	.ref	brick_count
	.ref	last_power
	.ref	qtr_purchased
	.ref	call_scores
	.ref	last_name_time

	.ref	plyrnumonfire
	.ref	pushed_speech

	.ref	grand_champs_screen
	.ref	show_hiscore
	.ref	speech_playovrp

	.ref	rebound_delay
	.ref	def_play_reward,flash_reward,sinecos_get,slamming
	.ref	start_animate,pass_off,steals_off,idiot_box

	.ref	GET_ADJ

	.ref	pass_to_speech
	.ref	shoots_speech
	.ref	shot_type,shot_percentage,shot_distance
	.ref	rejected_dnk_speech

	.ref	plyr_getattributes,snd_play1ovr

	.ref	scores,prt_top_scores
	.ref	score_add,score_showtvpanel2
	.ref	score_showtvpanel,tvpanelon
	.ref	gmqrtr
	.ref	clock_active
	.ref	crplate_ptr
	.ref	shot_clock,shotimer
	.ref	arw_on1plyr
	.ref	pushing_delay
	.ref	cntrs_delay
	.ref	game_time
	.ref	sc_proc
	.ref	stick_number
	.ref	doalert_snd
	.ref	flash_bigtxt

	.ref	player_data
	.ref	inc_player_stat
	.ref	stats_page,hint_page
	.ref	stats_page2
	.ref	rank_screen
;	.ref	result_screen
	.ref	save_player_records
	.ref	game_purchased
	.ref	team1,team2
	.ref	show_ot_msg,scr1

	.ref	winner_stays_on
	.ref	print_string_C2
	.ref	mess_objid
	.ref	setup_message
	.ref	omlgmd_ascii

	.ref	pal_clean
	.ref	pal_getf,pal_set
	.ref	fade_down_half,fade_up_half

	.ref	SCRTST
	.ref	IRQSKYE
	.ref	PCNT
	.ref	GAMSTATE,HALT
	.ref	gndx
	.ref	AUD,AUD1,GET_AUD,STORE_AUDIT
	.ref	PSTATUS2
	.ref	RNDPER
	.ref	game_over
	.ref	TWOPLAYERS
	.ref	scale63_t

	.ref	ball_convfmprel
	.ref	ballobj_p
	.ref	ballpnum,ballpnumlast,ballpnumshot,ballfree
	.ref	ballrimhitcnt,ballbbhitcnt
	.ref	ballpasstime
	.ref	ballscorezhit
	.ref	ballptsforshot
	.ref	ballprcv_p
	.ref	ballgoaltcnt
	.ref	ballsclastp
	.ref	inbound
	.ref	ballflash
	.ref	t1dunkcnt
	.ref	plyr_setptsdown

	.ref	halftime_showclips

	.ref	plyr_smoketrail

	.ref	drone_main,drone_adjskill
	.ref	drone2on
	.ref	w3run1

;symbols defined in this file


;uninitialized ram definitions
	.bss	reduce_3ptr,16
	BSSX	kp_scores	,32
	BSSX	kp_team1	,16
	BSSX	kp_team2	,16

	BSSX	pleasewt	,16
	BSSX	PSTATUS		,16	;Player in game bits (0-3)
					;/Must be in order!
	BSSX	P1CTRL		,16	;P1 joy/but bits (0-3=UDLR, 4-6=B1-B3)
	BSSX	P2CTRL		,16	;P2 (^ 8-14 are on for a on transition
	BSSX	P3CTRL		,16	;P3 of 0-6)
	BSSX	P4CTRL		,16	;P4

	BSSX	P1DATA		,PDSIZE	;Player 1 data
	BSSX	P2DATA		,PDSIZE	;P2
	BSSX	P3DATA		,PDSIZE	;P3
	BSSX	P4DATA		,PDSIZE	;P4

	.bss	pld		,PLDSZ*4 ;Player secondary data

	BSSX	plyrobj_t	,32*4	;*player obj (4)
	BSSX	plyrproc_t	,32*4	;*player process (4)

	BSSX	plyrcharge	,16	;!0=Dunker rammed an opponent
	BSSX	plyrpasstype	,16	;!0=Turbo pass
	BSSX	plyrairballoff	,16	;!0=No airball sound
	BSSX	plyrbighead	,16	;Bit 0-3 on = plyr 0-3 has big head
	BSSX	stlpower	,16	;Bit 0-3 on = plyr 0-3 has stl power

	.bss	plyrinautorbnd	,16	;!0=A plyr is in auto rebound
;	.bss	drnzzcnt	,16	;Drone zigzag mode cntdn
;	.bss	drnzzmode	,16	;Drone zigzag mode (0-?)

	BSSX	plyrpals_t 	,256*16*4 ;Assembled palette for each plyr
	BSSX	assist_delay	,16
	BSSX	assist_plyr	,16
	BSSX	kp_qscrs	,128	;Keep scores during game play
	BSSX	kp_qscrs2	,128	;Keep scores for attract mode
	BSSX	baby_flag	,16	;Flag for baby size mode
	BSSX	strongmen	,16	;Grnd champ flag 0,1 or 2 for team #


;equates for this file

PLYRMINX	.equ	WRLDMID-337		;342
PLYRMAXX	.equ	WRLDMID+337-9		;342-9
PLYRMINX2	.equ	WRLDMID-370
PLYRMAXX2	.equ	WRLDMID+370

	STRUCTPD
	WORD	ball_anix	;X anipt offset
	WORD	ball_aniy	;Y ^
	APTR	ball_ani1st_p	;*1st ani_l pos
	APTR	ball_ani_p	;*Current ani_l pos
	WORD	ball_zsznum	;Z size # 0-?
	WORD	ball_collcnt	;# of collisions in a row
;	LONG	ball_oldx	;Last good X before collision
;	LONG	ball_oldy	;^ Y
;	LONG	ball_oldz	;^ Z
	WORD	ball_xscrllmin	;
	WORD	ball_xscrllmax	;
	WORD	ball_onfire	;!0=Flaming
	WORD	ball_numforfire	;# of consecutive pts to be hot

	.text


********************************
* Start player processes

 SUBR	plyr_start

;	movk	1,a0
;	move	a0,@>fff80000,L

	callr	joy_read2

	clr	a0
	move	a0,@plyrinautorbnd
	move	a0,@plyrcharge
	move	a0,@plyrairballoff
	move	a0,@stlpower
	move	a0,@strongmen			;Grand champion playing flag

	movk	1,a2
	.ref	player1_data
	.ref	player2_data
	.ref	player3_data
	.ref	player4_data
	movk	1,a3
	move	@player1_data+PR_TEAMSDEF,a0,L
	cmpi	>7ffffff,a0
	jrz	#easy0
	move	@player2_data+PR_TEAMSDEF,a0,L
	cmpi	>7ffffff,a0
	jrz	#easy0
	movk	2,a3
	move	@player3_data+PR_TEAMSDEF,a0,L
	cmpi	>7ffffff,a0
	jrz	#easy0
	move	@player4_data+PR_TEAMSDEF,a0,L
	cmpi	>7ffffff,a0
	jrnz	#nea


#easy0	move	a3,@strongmen			;Grand champion playing flag
	jruc	#easy

#nea
	clr	a2
	movk	ADJDIFF,a0		;Get difficulty level
	calla	GET_ADJ
	subk	3,a0
	jrle	#regdrn
	movk	1,a2
#regdrn
	move	@PSTATUS,a0
	cmpi	1,a0
	jrz	#hard
	cmpi	2,a0
	jrz	#hard
	cmpi	4,a0
	jrz	#hard
	cmpi	8,a0
	jrnz	#easy
#hard
	movi	200,a0
	calla	RNDPER
	jrhi	#easy
	movk	1,a2			;Give hard drones 70% of time

#easy	move	a2,@drone2on


;	move	@plyrbighead,a0
;	zext	a0
;	cmpi	>eaea,a0
;	jrnz	#no_3d
;	movk	>f,a2
;	move	a2,@stlpower
;	jruc	#adjoff
;#no_3d

	clr	a2
	movk	ADJHEADSZ,a0		;Get head size
	calla	GET_ADJ			;1-2
	subk	1,a0
	jrle	#adjoff			;No big heads?
	movk	>f,a2
#adjoff
	move	a2,@plyrbighead

	CREATE0	plyr_referee

	movi	plyrproc_t+4*32,a2
	movi	plyrobj_t+3*32,a9
	movk	3,a8
#strtp	CREATE0	plyr_main
	move	a0,-*a2,L		;Save *proc
	subk	32,a9
	dsj	a8,#strtp

	move	a13,-*a2,L
;	jruc	plyr_main		;#0



#*******************************
* Main player control code (Process)
* A8=Plyr # (0-3)
* A9=*plyrobj_t for plyr #


 SUBRP	plyr_main


	move	a13,a1			;>Clr PDATA & PSDATA areas
	addi	PDATA,a1
	movi	(PRCSIZ-PDATA)/16,a2
	clr	a0
#clrpd	move	a0,*a1+
	dsj	a2,#clrpd


	move	a8,a0			;>Chk if plyr wants to override headsize
	sll	4,a0			;*16
	addi	P1CTRL,a0
	move	*a0,a0
	sll	32-7,a0
	srl	32-7,a0

;	cmpi	BUT3_M|BUT2_M|BUT1_M|JOYD_M,a0
	cmpi	BUT1_M|JOYD_M,a0	;Shoot down, jostick down
	jrne	#nostl
	move	a8,a0
	sll	4,a0
	addi	p1taps,a0
	move	*a0,a0
	cmpi	5,a0
	jrlt	#nostl
	move	@stlpower,a0		;Powerup intercepts (Quick hands)
	movk	1,a14
	sll	a8,a14
	xor	a14,a0			;Flip bit
	move	a0,@stlpower
#nostl

	cmpi	BUT3_M|BUT2_M|JOYU_M,a0
	jrne	#nohdcng
	move	@plyrbighead,a0
	movk	1,a14
	sll	a8,a14
	xor	a14,a0			;Flip bit
	move	a0,@plyrbighead
#nohdcng

	movi	-1,a1
	move	a1,*a13(plyr_newdir)
	movk	1,a0
	move	a0,*a13(plyr_shtbutn)

	movk	30,a0
	move	a0,*a13(plyr_turndelay)

	move	a8,*a13(plyr_num)
	move	a8,a11

	movk	1,a7
	xor	a8,a7
	sll	5,a7			;*32
	addi	plyrproc_t,a7
	move	*a7,a7,L
	move	a7,*a13(plyr_tmproc_p),L

	movi	P2DATA-P1DATA,a7,W
	mpyu	a8,a7
	addi	P1DATA,a7
	move	a7,*a13(plyr_PDATA_p),L

	calla	plyr_getattributes	;Set attribute_p
					;A10=*Uniform attr (ignores spechds)

	movi	#pd1-#pdat_t,a7,W
	mpyu	a8,a7
	addi	#pdat_t,a7

	move	*a7+,a0
	move	a0,*a13(PROCID)

	move	*a7+,a1			;Dir
	move	a1,*a13(plyr_dir)

	move	*a7+,a0			;X
	move	@WORLDTLX+16,a1
	add	a1,a0

	move	@gmqrtr,a3
	jrz	#not2
	addi	400,a0
#not2

	sll	16,a0
	clr	a1			;Y
	move	*a7+,a3			;Z
	move	*a7,a2,L
	movi	DMAWNZ|M_3D,a4
	movi	CLSPLYR|TYPPLYR,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a9,L		;Save *obj

	movi	scale63_t,a0		;Temp size
	move	a0,*a8(ODATA_p),L

	SLEEPK	2			;Wait for other plyrs init

	move	*a13(plyr_attrib_p),a7,L
	move	a10,a6
	move	*a7,a0,L		;Get *scale_t
	move	a0,*a8(ODATA_p),L
	move	*a7(PAT_BVEL),a0
	move	a0,*a13(plyr_bvel)

;--
	move	*a7(PAT_SKILL),a0

	move	@PSTATUS,a1
	btst	a11,a1
	jrnz	#hmn			;I'm a human?

	movk	1,a14			;Drone
	xor	a11,a14
	btst	a14,a1
	jrz	#tdrn			;Teammate is a drone?
#hmn
;	movk	2,a14			;Human
;	xor	a11,a14
;	sll	5,a14			;*32
;	addi	plyrproc_t,a14
;	move	*a14,a14,L

	clr	a0

	jruc	#setskl
#tdrn
	movk	2,a14			;We are drones
	xor	a11,a14
	btst	a14,a1
	jrnz	#humop			;Human opponent?
	movk	1,a2
	xor	a2,a14
	btst	a14,a1
	jrz	#setskl			;All drones?
#humop
	sll	5,a14
	addi	player_data,a14
	move	*a14,a14,L
	movk	6,a2
	move	*a14(PR_COUNT),a1	;- if no entry
	jrn	#wimp
	move	*a14(PR_NUMDEF),a2	;# teams defeated
	subk	10,a2
	jrlt	#few
	move	a2,@drone2on
#few
	movk	4,a2			;3
	subk	4,a1
	jrle	#wimp			;1st couple of games?
	movk	1,a2
#wimp
	sub	a2,a0
	move	*a14(PR_WINSTREAK),a1
	jrnz	#won			;Won last game?
	subk	4,a0			;4 Decrease skill
#won
#setskl	move	a0,*a13(plyr_d_skill)

;--


	movi	team1,a14		;>Chk for conflicting pals
	move	*a14+,a3
	move	*a14,a4
	btst	1,a11
	jrz	#t1
	SWAP	a3,a4
#t1	sll	3,a3
	sll	3,a4
	addi	#team_t,a3
	addi	#team_t,a4
	movb	*a3,a3
	jrn	#keepc			;I always keep?
	movb	*a4,a4
	move	a4,a14
	sll	32-4,a3
	sll	32-4,a14
	cmp	a3,a14
	jrne	#keepc			;Different colors?
	move	a4,a4
	jrn	#altc			;Other team always keeps?
	btst	1,a11
	jrnz	#keepc			;2nd team?
#altc	addk	32,a6			;*Alternates
#keepc

	move	a11,a2			;>Build plyr palette
	sll	8+4,a2
	addi	plyrpals_t,a2
	PUSH	a2

	movi	255,a0
	move	a0,*a2+			;Set # colors

;Check for special pals
	move	*a7(PAT_SHOTSKILL),a1
;.asg	1201,SHT11		;MK SPECIAL FLAG
	cmpi	1201,a1
	jrnz	#reg
;Stay with defined pals!
	move	a7,a6

#reg
	move	*a6(PAT_PALU_p),a1,L	;Copy uniform
	move	*a1+,a0
#plulp	move	*a1+,*a2+
	dsj	a0,#plulp

	move	*a7(PAT_PALF_p),a1,L	;Copy flesh
	move	*a1+,a0
	addk	16,a1
	subk	1,a0
#plflp	move	*a1+,*a2+
	dsj	a0,#plflp

	move	*a6(PAT_PALT_p),a1,L	;Copy trim
	move	*a1+,a0
	addk	16,a1
	subk	1,a0
#pltlp	move	*a1+,*a2+
	dsj	a0,#pltlp

	movi	31<<10+31<<5+31,a0	;White
	move	a0,*a2+

	movi	ltshoepal_t,a1		;Copy shoes
;	btst	0,a11
;	jrz	#p02
;	movi	dkshoepal_t,a1
;#p02
	movk	5,a0			;5 colors
#plslp	move	*a1+,*a2+
	dsj	a0,#plslp

	clr	a0			;Black
	move	a0,*a2+

	PULL	a0
	calla	pal_getf
	move	a0,*a8(OPAL)


	PUSH	a8

	clr	a0			;>Get head
	clr	a1
	move	*a7(PAT_HEADT_p),a2,L
	move	*a2,a2,L
	movi	CZMID,a3		;Z
	movi	DMAWNZ|M_3D|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(plyr_headobj_p),L
	move	*a13(plyr_attrib_p),a0,L
	move	*a0,a0,L		;Get *scale_t
;MJT
;	addi	SCALETSIZE*2,a0
	addi	SCALETSIZE*2+100h,a0

;Do multiple levels of bighead

	move	*a13(plyr_num),a1
	move	@plyrbighead,a2
	btst	a1,a2
	jrz	#smlhd

	
	sll	4,a1
	addi	p1taps,a1
	move	*a1,a1
	cmpi	6,a1
	jrz	#bighd2


	subi	SCALETSIZE*1+200h,a0
       	jruc	#smlhd


#bighd2	subi	>a80,a0			;Really big head
;	addi	SCALETSIZE,a0
#smlhd
	move	a0,*a8(ODATA_p),L

	clr	a0			;>Get shadow
	clr	a1
	movi	shadow1,a2
	move	*a8(OZPOS),a3
	subi	50,a3
	movi	DMAWNZ|M_3D|M_SHAD|M_NOCOLL,a4
	calla	BEGINOBJ2
	move	a8,*a13(plyr_shadobj_p),L
	movi	50,a0
	move	a0,*a8(OMISC)		;Z offset

	PULL	a8



;	.if	DEBUG
;	callr	plyr_getgndaligndot
;	.endif

	clr	a0

	movi	PLDSZ,a9
	mpyu	a11,a9
	addi	pld,a9			;A9=*Plyr secondary data struc
	move	a9,a1
	movi	PLDSZ/16,b0
#cpldlp	move	a0,*a1+
	dsj	b0,#cpldlp

	sll	4,a11			;*16
	addi	P1CTRL,a11		;A11=*PxCTRL
	move	a0,*a11


	movk	STND_SEQ,a0		;Initial sequence
	move	*a13(plyr_num),a14
	jrz	#pn03
	subk	3,a14
	jrge	#pn03
	move	@gmqrtr,a14
	jrnz	#pn03

	movi	TIP_SEQ,a0
#pn03
	move	*a13(plyr_dir),a7
	callr	plyr_setseq		;Rets: A10=Ani cntdn


	movi	HOOPLX,a0
	movi	HOOPRX,a1
	move	*a13(plyr_num),a14
	subk	2,a14
	jrlt	#_p0or1
	SWAP	a0,a1
#_p0or1	move	a0,*a13(plyr_myhoopx)
	move	a1,*a13(plyr_ohoopx)


;	move	*a13(plyr_num),a0	;DEBUG
;	subk	2,a0
;	jreq	#num2
;	SLEEP	30000
;#num2

	SLEEPK	2			;Wait for others to establish data

;---------------------------

#lp
	move	@HALT,a0
	jrnz	#halted

;MJT
	clr	a9


	.if	IMGVIEW
	move	*a13(plyr_num),a0
	cmpi	0,a0
	jrz	#yes
	cmpi	3,a0
	jrne	#halted
#yes
	movk	1,a2			;+=Me
	jruc	#nobl2
	.endif


;This could be a dipswitch setting for our home games
;FIX
;	move	@DIPSWITCH,a0
;	btst	0,a0			;UJ2 switch 8
;	jrnz	#notfair		;OFF?
;	clr	a0
;	move	a0,*a13(plyr_ptsdown)
;#notfair

	clr	a2			;>Set flag if we have ball
	move	*a13(plyr_num),a0
	move	@ballpnum,a1
	cmp	a1,a0
	jrne	#nobl1			;No ball?
	move	*a13(plyr_seqflgs),a14
	btst	NOBALL_B,a14
	jrnz	#nohold			;Can't hold the ball?

	move	*a13(plyr_ownball),a0
	jrgt	#hadball		;Already had?

	move	@ballobj_p,a1,L
	move	*a1(OYPOS),a0
	cmpi	-28,a0
	jrlt	#yesair
	move	*a1(OYVEL),a0,L
	abs	a0
	cmpi	>c000,a0
	jrlt	#notinair

#yesair
	move	@rebound_delay,a0
	jrz	#inair
	clr	a0
	move	a0,@rebound_delay
	move	@inbound,a0
	jrnn	#inair	
;Ball in air, give player a rebound
	movi	PS_OFF_REB,a0
	move	*a13(plyr_num),a1
	move	@ballpnumlast,a14
	srl	1,a1
	srl	1,a14
	cmp	a1,a14
	jrz	#offrb
	movi	PS_DEF_REB,a0
#offrb
	move	*a13(plyr_num),a1
	calla	inc_player_stat
	jruc	#inair



#notinair
	move	*a13(plyr_jmpcnt),a0
	jrnz	#nohold			;In air?

	calla	seq_stopfire

	movi	PICKUP_SEQ,a0
	move	*a13(plyr_dir),a7
	callr	plyr_setseq
#inair	movk	1,a2			;+=Me
	jruc	#nobl2
#nohold
	subk	1,a2			;-1
	move	a2,@ballpnum
	move	a2,@ballpnumlast
	calla	ball_convfmprel
	clr	a2
	jruc	#nobl2
#nobl1
	XORK	1,a0
	cmp	a1,a0
	jrne	#nobl2			;No ball?
	subk	1,a2			;-=Teammate
#nobl2
	move	a2,*a13(plyr_ownball)

	move	a2,a2
	jrle	#hadball

	PUSH	a10
	move	a13,a10
	calla	arw_on1plyr		;Guy who picks up ball gets arw
	PULL	a10

	move	*a13(plyr_num),a0
	srl	1,a0			;A0=0/1 for left/rgt hoop start clock
	move	@ballsclastp,a1
	srl	1,a1
	cmp	a0,a1
	jreq	#hadball		;Same team?

	calla	shot_clock		;New 24


#hadball

	clr	a0			;>Setup turbo flag
	move	*a13(plyr_nojoy),a6
	jrn	#newjoy			;Override plyr input?
	move	*a11,a6
#newjoy	btst	BUT3_B,a6		;Turbo but
	jrz	#turboff
	move	*a13(plyr_PDATA_p),a1,L
	move	*a1(ply_turbo),a1
	jrz	#turboff		;No turbo left?
	movk	1,a0
#turboff
	move	a0,*a13(plyr_turbon)



	move	*a13(plyr_num),a4	;>Do 1 in 4 ticks
	move	@PCNT,a0
	move	a4,a1
	sll	32-2,a0
	sll	32-2,a1
	cmp	a0,a1
	jrne	#skip

	movk	1,a14			;>Get teammates dir/dist
	xor	a4,a14
	sll	5,a14			;*32
	addi	plyrobj_t,a14
	move	*a14,a0,L
	callr	seekdirdist_obob128
	move	a0,*a13(plyr_tmdir)
	move	a1,*a13(plyr_tmdist)

	srl	1,a4			;>Get opponents dir/dist
	movk	1,a14
	xor	a14,a4
	sll	6,a4			;*64
	addi	plyrobj_t,a4
	move	*a4+,a0,L
	callr	seekdirdist_obob128
	move	a0,*a13(plyr_o1dir)
	move	a1,*a13(plyr_o1dist)

	move	*a4+,a0,L
	callr	seekdirdist_obob128
	move	a0,*a13(plyr_o2dir)
	move	a1,*a13(plyr_o2dist)

	move	@ballobj_p,a0,L
	callr	seekdirdist_obob128
	move	a0,*a13(plyr_balldir)
	move	a1,*a13(plyr_balldist)

	move	*a13(plyr_myhoopx),a6
	movi	CZMID,a7
	callr	seekdirdist_obxz128
	move	a0,*a13(plyr_hpdir)
	move	a1,*a13(plyr_hpdist)

	move	*a13(plyr_ohoopx),a6
	movi	CZMID,a7
	callr	seekdirdist_obxz128
	move	a0,*a13(plyr_ohpdir)
	move	a1,*a13(plyr_ohpdist)


#skip	clr	a14			;>Setup defensive flag
	move	@ballpnum,a0
	jrn	#setdef			;No owner?
	move	*a13(plyr_ownball),a0
	jrnz	#setdef			;My team has?

	move	*a13(plyr_hpdist),a0

	move	*a13(plyr_num),a1
	move	@PSTATUS,a2
	btst	a1,a2
	jrz	#drn
	cmpi	220,a0
    	jruc	#ndrn
#drn
	cmpi	310,a0
#ndrn	jrge	#setdef			;Too far from my hoop?

	move	*a13(plyr_hpdir),a0	;Find dir difference
	move	*a13(plyr_balldir),a1
	sub	a1,a0
	abs	a0
	cmpi	>40,a0
	jrle	#dsml
	subi	>80,a0
	abs	a0
#dsml	subk	24,a0
	jrle	#setdef			;Not between ball and hoop?

	move	*a13(plyr_seq),a2
	cmpi	RUNDRIBTURB_SEQ,a2
	jrhi	#setdef
	move	*a13(plyr_o1dist),a1
	cmpi	90,a1
	jrlt	#defon
	move	*a13(plyr_o2dist),a1
	cmpi	90,a1
	jrge	#setdef
#defon	movk	1,a14
#setdef	move	a14,*a13(plyr_indef)



;-------


	move	*a13(plyr_autoctrl),a0
	jrnz	#tcc			;Temp computer control?


	move	*a13(plyr_seqflgs),a0
	btst	NOCOLLP_B,a0
	jrnz	#nocol			;No collide?
	callr	plyr_chkpcollide
#nocol

					;>Stagger/fall
	move	*a13(plyr_stagcnt),a2
	jrle	#nostag
	subk	1,a2
	move	a2,*a13(plyr_stagcnt)
	subk	15,a2
	jrle	#nostag

	move	*a13(plyr_seq),a14

	subk	30-15,a2
	jrle	#chkstag		;Chk stag?

	move	@plyrnumonfire,a1
	jrn	#noflm1
	move	@fatality,a2
	jrz	#noflm1
	move	*a13(plyr_num),a3
	srl	1,a3
	srl	1,a1
	cmp	a1,a3
	jrz	#noflm1
	btst	a1,a2
	jrz	#noflm1
	movi	500,a0
	calla	RNDPER
	jrls	#noflm1
;Yes, this will be a flaming fall!
	movk	1,a9
#noflm1
	move	*a13(plyr_seq),a14

	movi	FLYBACK_SEQ,a0
	move	a9,a9
	jrz	#noflm2
	movi	FFLYBACK_SEQ,a0
#noflm2
	cmp	a0,a14
	jreq	#cstag

;MJT
;	cmpi	FALL_SEQ,a14
;	jrge	#cstag
;	cmpi	FFLYBACKWB2_SEQ,a14
;	jrgt	#cstag


	cmpi	FLYBACKWB_SEQ,a14
	jreq	#cstag
	cmpi	FLYBACKWB2_SEQ,a14
	jreq	#cstag
	cmpi	FLYBACK2_SEQ,a14
	jreq	#cstag

;MJT
	move	*a13(plyr_ownball),a1
	jrgt	#haveball

	move	*a13(plyr_attrib_p),a1,L
	move	*a1(PAT_POWER),a1
	move	@last_power,a2		;Player pushing has this power
	sub	a1,a2
	abs	a2

	movi	FLYBACK_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm3
	movi	FFLYBACK_SEQ,a0
#noflm3
	cmpi	1,a2
	jrle	#fall
	
	sll	4,a1
;Powerful guys, flail more often
	PUSH	a14
	addi	#noblflail_t,a1
	move	*a1,a0
	calla	RNDPER
	PULL	a14
	movi	FLYBACK_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm4
	movi	FFLYBACK_SEQ,a0
#noflm4

;MJT - Will this work?

	jrls	#fall
	jruc	#flail

#haveball

;If toward rear edge of court and is being pushed back into crowd, always do
;normal flyback and never keep ball!

	movi	FLYBACK_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm5
	movi	FFLYBACK_SEQ,a0
#noflm5

	move	*a8(OZPOS),a1
	cmpi	>410,a1
	jrgt	#not_rear
	move	*a8(OZVEL),a1,L
	jrn	#fall			;Heading over scores table?

#not_rear
	move	@pushing_delay,a1
	jrnz	#keepball
	move	@strongmen,a1
	jrz	#notchamp
	srl	1,a1
;A grand champion is playing!
	move	*a13(plyr_num),a0
	srl	1,a0
	cmp	a0,a1
	jrz	#notchamp		;br=champ getting pushed
	movi	900,a0
	calla	RNDPER
	jrhi	#keepball
		
#notchamp

;MJT
;	move	*a13(plyr_ptsdown),a1
;	jrle	#fall			;I'm winning?

;If player is in elbo mode, have him keep ball more often!

	movi	500,a0			;40% chance of keeping ball if in ELBO
	cmpi	ELBO_SEQ,a14		;Could also do ELBO2_SEQ
	jrz	#fbnorm

;MJT
	move	*a13(plyr_attrib_p),a14,L
	move	*a14(PAT_POWER),a0


	move	@last_power,a2		;Player pushing has this power
	sub	a0,a2
	abs	a2
	cmpi	1,a2
	jrgt	#norm
	movi	200,a0
	jruc	#norm2

#norm

	sll	4,a0
;Powerful guys, keep ball more often
	addi	#kpball_t,a0
	move	*a0,a0
;	movi	200,a0			;15% chance of keeping ball if winning
#norm2
	move	*a13(plyr_ptsdown),a1
	jrle	#fbnorm			;!Losing?
	cmpi	15,a1
	jrle	#fbmok
	movk	15,a1
#fbmok	sll	4,a1
	addi	#flyb_t,a1
	move	*a1,a14
	add	a14,a0
	cmpi	1000,a0
	jrge	#keepball
#fbnorm
	calla	RNDPER
	jrls	#fb

#keepball
;Yes, keep ball even though I've been pushed.

	clr	a0
	move	a0,*a13(plyr_dribmode)	;Allow dribble when he gets up

;Rules for using short flyback/WITH BALL sequence:
;If in dunk, don't do short flybacks
;If in jump shot, 50%
;If losing, 50%
;What else?

	calla	pushed_speech

	movi	FLYBACKWB_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm6
	movi	FFLYBACKWB_SEQ,a0
#noflm6



	move	*a13(plyr_seqflgs),a14
	btst	DUNK_B,a14
	jrnz	#fall			;In dunk?


	move	*a13(plyr_seq),a14
	subk	SHOOT_SEQ,a14		;Am I shooting?
	jrz	#_50_50

;MJT
	movi	50,a0
	move	*a13(plyr_ptsdown),a1
	jrle	#i5050
;	jrle	#fall			;I'm winning?

#_50_50
;I'm losing or shooting, 25% of time don't fly all the way back.

	move	*a13(plyr_attrib_p),a14,L
	move	*a14(PAT_POWER),a0


	move	@last_power,a2		;Player pushing has this power
	sub	a0,a2
	abs	a2
	cmpi	1,a2
	jrgt	#norm3
	movi	250,a0
	jruc	#i5050

#norm3
	sll	4,a0
;Powerful guys, keep ball more often
	addi	#shortfly_t,a0
	move	*a0,a0

;	movi	250,a0
#i5050
	calla	RNDPER
	jrhi	#nofall

	movi	FLYBACKWB_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm7
	movi	FFLYBACKWB_SEQ,a0
#noflm7
	jruc	#fall
#nofall

;	move	@HCOUNT,a1
;	andi	3,a1			;andi 1
;	jrz	#fall

;He lucked out, fly short distance

#flail	move	*a8(OZVEL),a0,L
	sra	2,a0
	move	a0,*a8(OZVEL),L
	move	*a8(OXVEL),a0,L
	sra	2,a0
	move	a0,*a8(OXVEL),L

	movi	FLYBACKWB2_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm8
	movi	FFLYBACKWB2_SEQ,a0
#noflm8
	jruc	#fall

#fb
;Rules for using short flyback/NO BALL sequence:
;If in dunk, don't do short flybacks
;If losing, 35%
;What else?

	movi	FLYBACK_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm9
	movi	FFLYBACK_SEQ,a0
#noflm9

	move	*a13(plyr_seqflgs),a14
	btst	DUNK_B,a14
	jrnz	#fall			;In dunk?

;MJT
;If big guy, do short flyback more often!
	move	*a13(plyr_attrib_p),a14,L
	move	*a14(PAT_POWER),a0


	move	@last_power,a2		;Player pushing has this power
	sub	a0,a2
	abs	a2
	cmpi	1,a2
	jrgt	#norm5

	movi	FLYBACK_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm10
	movi	FFLYBACK_SEQ,a0
#noflm10

	jruc	#fall
#norm5



	sll	4,a0
	move	*a13(plyr_ptsdown),a1
	jrle	#winshortfly			;Br= I'm winning!
;I'm losing
	addi	#shortfly_t,a0
	move	*a0,a0
	jruc	#flyout
#winshortfly			;Br= I'm winning!
	addi	#winshortfly_t,a0
	move	*a0,a0


#flyout
;	move	*a13(plyr_ptsdown),a1
;	jrle	#fall			;Br= I'm winning!

;I'm losing, 35% of time don't fly all the way back.
;	addi	150,a0
;#fbnorm2
	calla	RNDPER
	jrhi	#fly_short

	movi	FLYBACK_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm11
	movi	FFLYBACK_SEQ,a0
#noflm11
	jruc	#fall

#fly_short
;He lucked out, make him fly short distance
	move	*a8(OZVEL),a0,L
	sra	2,a0
	move	a0,*a8(OZVEL),L
	move	*a8(OXVEL),a0,L
	sra	2,a0
	move	a0,*a8(OXVEL),L

	movi	FLYBACK2_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm12
	movi	FFLYBACK2_SEQ,a0
#noflm12

	jruc	#fall

#chkstag
	move	*a13(plyr_jmpcnt),a1
	jrz	#stag			;On gnd?

	movi	FALL_SEQ,a0		;If similar power, always do flyback
	move	a9,a9
	jrz	#noflm13
	movi	FFALL_SEQ,a0
#noflm13

	cmp	a14,a0
	jrne	#fall
	jruc	#cstag

#stag	subi	STAGGER_SEQ,a14
	jreq	#nostag
	subk	FALL_SEQ-STAGGER_SEQ,a14
	jreq	#cstag

	movk	3,a0
	callr	rnd
	jrnz	#nostag
	movi	STAGGER_SEQ,a0

#fall
	move	*a13(plyr_dir),a7
	callr	plyr_setseq
#cstag	clr	a2
	move	a2,*a13(plyr_stagcnt)
#nostag

;-------

	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	btst	a1,a0
	jrnz	#human
	calla	drone_main
#human
#tcc

	move	*a13(plyr_indef),a14
	jrz	#nodef
	move	*a13(plyr_balldir),*a13(plyr_newdir)

#nodef
	move	*a11,a6			;A6=Ctrl bits

;	move	*a13(plyr_jmpcnt),a0
;	jrnz	#clrsb			;In air?

	movb	*a13(plyr_seqflgs+NOJOY_B-7),a0
	jrn	#clrsb			;Joy off?

	move	*a13(plyr_nojoy),a0
	jrz	#joyon			;Joystick on?
	jrgt	#clrsb
	move	a0,a6
	jruc	#joyon
#clrsb
	srl	4,a6			;Clr stick bits
	sll	4,a6
#joyon
	move	*a13(plyr_dir),a7	;A7=Dir

	move	*a13(plyr_newdir),a0
	jrn	#stick			;No forced dir?
	sub	a7,a0
	jrnz	#turn
	movi	-1,a0
	move	a0,*a13(plyr_newdir)

#stick
	move	*a13(plyr_autoctrl),a1
	jrnz	#rok

	move	*a8(OZPOS),a0		;>Clr joy bits that make us go out of bounds
	move	a0,a14
	cmpi	CZMIN+8,a0
	jrgt	#upok			;OK?
	movk	JOYU_M,a0
	andn	a0,a6


	move	*a13(plyr_rcvpass),a1
	jrz	#notwaiting

;Tell player recieving a leading pass to turn and wait for pass
	movk	1,a1
	move	a1,*a13(plyr_nojoy)	;Neg
	move	a1,*a13(plyr_turndelay)
#notwaiting

	cmpi	CZMIN+6,a14		;a0
	jrgt	#upok

	move	*a13(plyr_seq),a14
	cmpi	RUN_SEQ,a14
	jrz	#sldin0
	cmpi	RUNTURB_SEQ,a14
	jrz	#sldin0
	cmpi	RUNDRIB_SEQ,a14
	jrz	#sldin0
	cmpi	RUNDRIBTURB_SEQ,a14
	jrnz	#upok

#sldin0
	move	*a8(OZPOS),a14
	inc	a14
	move	a14,*a8(OZPOS)

#upok
	cmpi	GZMAX-6,a0
	jrlt	#dnok			;OK?
	movk	JOYD_M,a0
	andn	a0,a6

	move	*a13(plyr_rcvpass),a14
	jrz	#notwaiting1

;Tell player recieving a leading pass to turn and wait for pass
	movk	1,a14
	move	a14,*a13(plyr_nojoy)	;Neg
	move	a14,*a13(plyr_turndelay)
#notwaiting1

#dnok
	move	*a8(OXPOS),a0
	move	*a8(OXANI+16),a14
	add	a14,a0
	move	a0,a14
	cmpi	PLYRMINX,a0
	jrgt	#lok			;OK?
	movk	JOYL_M,a0
	andn	a0,a6




	move	*a13(plyr_rcvpass),a1
	jrz	#notwaiting2

;Tell player recieving a leading pass to turn and wait for pass
	movk	1,a1
	move	a1,*a13(plyr_nojoy)	;Neg
	move	a1,*a13(plyr_turndelay)
#notwaiting2





	cmpi	PLYRMINX-2,a14
	jrgt	#lok			;OK?


	move	*a13(plyr_seq),a14
	cmpi	RUN_SEQ,a14
	jrz	#sldin
	cmpi	RUNTURB_SEQ,a14
	jrz	#sldin
	cmpi	RUNDRIB_SEQ,a14
	jrz	#sldin
	cmpi	RUNDRIBTURB_SEQ,a14
	jrnz	#lok
#sldin

	move	*a8(OXPOS),a14
	inc	a14
	move	a14,*a8(OXPOS)

#lok
	move	a0,a14
	cmpi	PLYRMAXX,a0
	jrlt	#rok			;OK?
	
	movk	JOYR_M,a0
	andn	a0,a6


	move	*a13(plyr_rcvpass),a1
	jrz	#notwaiting3

;Tell player recieving a leading pass to turn and wait for pass
	movk	1,a1
	move	a1,*a13(plyr_nojoy)	;Neg
	move	a1,*a13(plyr_turndelay)
#notwaiting3



	cmpi	PLYRMAXX+2,a14
	jrlt	#rok			;OK?

	move	*a13(plyr_seq),a14
	cmpi	RUN_SEQ,a14
	jrz	#sldin2
	cmpi	RUNTURB_SEQ,a14
	jrz	#sldin2
	cmpi	RUNDRIB_SEQ,a14
	jrz	#sldin2
	cmpi	RUNDRIBTURB_SEQ,a14
	jrnz	#rok
#sldin2

	move	*a8(OXPOS),a14
	dec	a14
	move	a14,*a8(OXPOS)

#rok

	move	a6,a0
	sll	32-4,a0
	jrz	#setdt			;No stick?

	srl	32-4-3,a0		;>Convert to dir 0-127
	addi	#dirc_t,a0
	movb	*a0,a0

	sub	a7,a0			;A0=Difference
	jrz	#samedir

#turn	move	a0,a1			;>Turn the shortest way
	abs	a0

	subk	6,a0
	jrge	#340			;Far?
	add	a1,a7			;Make exact
	jruc	#380

#340	cmpi	64-6,a0
	jrle	#350
	neg	a1
#350	move	a1,a1
	jrnn	#360
	subk	12,a7			;-6
#360	addk	6,a7			;+6

#380	sll	32-7,a7			;Make 0-127
	srl	32-7,a7
	move	a7,*a13(plyr_dir)

	movk	>1f,a0
	callr	rnd
	jrnz	#nosq			;No squeak?
	move	@PCNT,a0
	movk	3,a1
	and	a1,a0
	sll	5,a0
	addi	#sqsnds,a0
	move	*a0,a0,L
	calla	snd_play1
#nosq

	move	*a13(plyr_seqflgs),a0
	btst	WALK_B,a0
	jrnz	#nodir
	move	*a13(plyr_seqdir),a0
	move	a7,a1			;Dir
	addk	8,a1
	sll	32-7,a1
	srl	32-7+4,a1		;Kill frac
	cmp	a0,a1
	jreq	#nodir			;Already in this dir?
	move	*a13(plyr_seq),a0
	callr	plyr_setseq
#nodir	clr	a0
	jruc	#setdt

#samedir
	move	*a13(plyr_dirtime),a0
	addk	1,a0
#setdt	move	a0,*a13(plyr_dirtime)



;-------


					;>Movement/boundary check
	move	*a8(OXVEL),a2,L
	move	*a8(OZVEL),a3,L

	move	*a13(plyr_jmpcnt),a0
	jrnz	#drift			;Jumping?

	move	*a13(plyr_seqflgs),a4
	btst	DRIFT_B,a4
	jrz	#nodrift

#drift	move	*a8(OXPOS),a4		;>Put drag on vel if we drift too far
	move	*a8(OXANI+16),a0
	add	a0,a4
	move	*a8(OZPOS),a5

	move	a3,a3
	jrge	#zvpos
	cmpi	CZMIN+8,a5
	jrgt	#chkx			;OK?
	jruc	#ydrag

#zvpos	cmpi	GZMAX-6,a5
	jrlt	#chkx			;OK?
#ydrag	move	a3,a0			;-1/4 from vel
	sra	2,a0
	sub	a0,a3

#chkx
	move	a2,a2
	jrge	#xvpos
	cmpi	PLYRMINX2,a4
	jrgt	#setvel			;OK?
	jruc	#xdrag
#xvpos
	cmpi	PLYRMAXX2,a4
	jrlt	#setvel			;OK?
#xdrag	move	a2,a0			;-1/4 from vel
	sra	2,a0
	sub	a0,a2
	jruc	#setvel


#nodrift
	move	a2,a0			;>-1/4 from XZVEL
	sra	2,a0
	sub	a0,a2
	move	a3,a0
	sra	2,a0
	sub	a0,a3

	btst	NOMV_B,a4
	jrnz	#setvel			;No moving?


	move	*a13(plyr_autoctrl),a1
	jrz	#noautoc
	movi	>1a000,a14
	jruc	#noturb

#noautoc
	move	*a13(plyr_bvel),a14
	sll	4,a14


;Double turbo mode
;	addi	>5800,a14

	move	*a13(plyr_ownball),a1
	jrle	#nobal			;Have ball?

;I own ball, if shot clock down to 10, and am over
;half court, slow down!  I am trying to burn out the clock!

	move	*a13(plyr_ohpdist),a1
	cmpi	>174,a1
	jrlt	#nobal
	move	@shotimer,a1,L
	jrz	#nobal
	cmpi	[1,0],a1
	jrz	#nobal

	move	*a13(plyr_ptsdown),a1
	jrgt	#nobal			;If losing, don't slow down

	subi	>3000,a14		;Slow him down

#nobal
	move	@game_time,a1,L
	cmpi	050000h,a1
	jrge	#noxtraspd

;Under 50 seconds, speed up losing players!

;	move	*a13(plyr_ptsdown),a1	;>Adjust shot %
;	jrle	#noxtraspd

	move	*a13(plyr_num),a1
	cmpi	2,a1
	jrge	#tm2
	move	@scores,a0
	move	@scores+16,a1
	cmp	a0,a1
	jrle	#noxtraspd
	jruc	#yes

#tm2	move	@scores,a0
	move	@scores+16,a1
	cmp	a0,a1
	jrge	#noxtraspd
#yes
	addi	>1c00,a14
#noxtraspd

	move	*a13(plyr_offscrn),a1
	jrz	#onscrn
	addi	>e000,a14		;Speedup when offscrn on defense
	clr	a1
	move	a1,*a13(plyr_offscrn)
#onscrn

	move	*a13(plyr_ownball),a1
	jrz	#chkturb
;MJT	subi	>e00,a14		;Slow offense down
	subi	>e80,a14		;Slow offense down
	move	a1,a1
	jrn	#chkturb		;Buddy has ball?
;MJT	subi	>1000,a14		;Slow him down
	subi	>1100,a14		;Slow him down
#chkturb
	move	*a13(plyr_turbon),a0
	jrz	#noturb
	addi	>3e00,a14
#noturb
	movk	11b,a0
	and	a6,a0
	jrz	#nodiag			;Neither up or dn?
	movk	1100b,a0
	and	a6,a0
	jrz	#nodiag			;Neither lft or rgt?
	move	a14,a0
	sra	3,a0
	sub	a0,a14			;-12%
#nodiag

;	btst	4,a6			;3point DEBUG
;	jrz	#DEBUG
;	movi	>2000,a14
;#DEBUG

	move	*a8(OXPOS),a4
	move	*a8(OXANI+16),a0
	add	a0,a4
	move	*a8(OZPOS),a5

	btst	JOYU_B,a6
	jrz	#noup
	cmpi	CZMIN+8,a5
	jrle	#noup			;Min?
	sub	a14,a3
#noup
	btst	JOYD_B,a6
	jrz	#nodn
	cmpi	GZMAX-6,a5
	jrge	#nodn			;Max?
	add	a14,a3
#nodn
	btst	JOYL_B,a6
	jrz	#chkr
	sub	a14,a2
	cmpi	PLYRMINX,a4
	jrgt	#setvel			;In bounds?
	move	*a13(plyr_autoctrl),a0
	jrnz	#setvel
	add	a14,a2
	jruc	#setvel
#chkr
	btst	JOYR_B,a6
	jrz	#setvel
	add	a14,a2
	cmpi	PLYRMAXX,a4
	jrlt	#setvel			;In bounds?
	move	*a13(plyr_autoctrl),a0
	jrnz	#setvel
	sub	a14,a2

#setvel	move	a2,*a8(OXVEL),L
	move	a3,*a8(OZVEL),L
#nomv


;-------

					;>Do turbo meters
	btst	BUT3_B,a6		;Turbo but
	jrz	#turdone


;Allow guy with ball to throw elbows if turbo button pressed twice quickly
	btst	BUT3_B+8,a6
	jrz	#noelbo

	move	*a13(plyr_tbutn),a14
	clr	a0
	move	a0,*a13(plyr_tbutn)
	subk	1,a14
	jrlt	#noelbo			;Too quick?
	subk	8-1,a14
	jrgt	#noelbo			;Too late?

	move	*a13(plyr_seq),a14
	cmpi	STNDWB_SEQ,a14
	jreq	#ok
	cmpi	STNDWB2_SEQ,a14
	jreq	#ok
	cmpi	STNDDRIB2_SEQ,a14
	jreq	#ok
	cmpi	RUNDRIB_SEQ,a14
	jreq	#ok
;	cmpi	RUNDRIBTURB_SEQ,a14
;	jreq	#ok
	subk	STNDDRIB_SEQ,a14
	jrne	#noelbo
#ok
;	move	*a13(plyr_num),a0
;	move	@PSTATUS,a2
;	btst	a0,a2
;	jrz	#notingame

	move	@gmqrtr,a0
	jrnz	#s1

	move	@game_time,a0,L
	cmpi	>2040906,a0
	jrge	#noelbo

#s1
					;Shrink turbo meter for this plyr
	move	*a13(plyr_PDATA_p),a2,L
	move	*a2(ply_turbo),a1
	cmpi	>5,a1			;>2f is max
	jrlt	#noelbo			;Turbo too low?
	subk	>4,a1			;Use a bunch up!
	move	a1,*a2(ply_turbo)
	move	*a2(ply_meter_imgs+40h),a0,L
	move	*a0(OFSET),a1		;Shrink meter
	addk	>4,a1
	move	a1,*a0(OFSET)

#notingame
	movi	60,a0
	move	a0,@steals_off		;Don't allow steals for 60 ticks

	movi	ELBO2_SEQ,a0
	callr	plyr_setseq
	jruc	#turdone
#noelbo


;	move	*a13(plyr_num),a0	;Don't allow drones to mess with
;	move	@PSTATUS,a2		;img ofsets!
;	btst	a0,a2
;	jrz	#turdone

	move	*a13(plyr_num),a0	;If on fire, don't use turbo on run
	move	@plyrnumonfire,a1
	cmp	a0,a1
	jrz	#turdone


	move	*a13(plyr_PDATA_p),a0,L
	move	*a0(ply_turbo),a1	;Turbo info in PxDATA (0-2f OXSIZE)
	jrz	#turdone		;No turbo left?
	move	*a0(ply_turbo_dl),a2	;Cnt for delaying dec of ply_turbo
	subk	1,a2
	move	a2,*a0(ply_turbo_dl)
	jrnz	#turdone

	movk	8,a2			;Rate of decline adjustment
	move	a2,*a0(ply_turbo_dl)
	subk	1,a1
	move	a1,*a0(ply_turbo)	;Turbo meter size to get smaller

	movk	4,a1
	move	a1,*a0(used_turbo)	;Cntr for replenishing meter after use

	move	*a0(ply_idiot_use),a1
	inc	a1
	move	a1,*a0(ply_idiot_use)

	move	*a0(ply_meter_imgs+40h),a0,L	;LITUP img 
	move	*a0(OFSET),a1		;Need to shrink LITUP img
	addk	1,a1
	move	a1,*a0(OFSET)
#turdone

	move	*a13(plyr_tbutn),a0	;Ticks since turbo button last hit
	addk	1,a0			
	move	a0,*a13(plyr_tbutn)


	move	*a13(plyr_shtdly),a0
	jrle	#nodly			;No delay?
	subk	1,a0
	move	a0,*a13(plyr_shtdly)
#nodly


;-------


	move	*a13(plyr_rcvpass),a0	;>Pass receiving
	jrle	#norcvp			;No pass?
	subk	1,a0
	move	a0,*a13(plyr_rcvpass)
	jrgt	#norcvp			;Not yet?
;	move	*a13(plyr_nojoy),a1
	move	a0,*a13(plyr_nojoy)
;	move	@ballobj_p,a2,L
;	move	*a2(OYVEL+16),a0
;	jrge	#balllow
;	move	*a8(OYPOS),a0
;	subk	10,a0
;	move	*a2(OYPOS),a1
;	cmp	a0,a1
;	jrgt	#balllow
;	subk	REBOUND_SEQ,a1
;	jrne	#noreb
;	movk	REBOUND_SEQ,a0
;	callr	plyr_setseq
;#noreb
#norcvp



	move	*a13(plyr_seq),a2
	cmpi	RUNDRIBTURB_SEQ,a2
	jrhi	#anicnt

	move	a6,a1			;>Change ani if no joy
	sll	32-4,a1
	jrz	#nojoy			;Joy neutral?


	movi	38,a14			;Delay before auto turn toward ball
	move	*a13(plyr_ownball),a0
	jrz	#indef
	movi	60,a14			;^
#indef	move	a14,*a13(plyr_turndelay)


	move	*a13(plyr_indef),a14
	jrz	#nodef2

	move	*a13(plyr_seqflgs),a0
	btst	WALK_B,a0
	jrnz	#anicnt

	srl	32-4-3,a1		;>Convert to dir 0-127
	addi	#dirc_t,a1
	movb	*a1,a1

	sub	a7,a1
	move	a1,a14			;Calc dir dist
	abs	a14
	cmpi	>40,a14
	jrle	#diffsml
	neg	a1
	subi	>80,a14
	abs	a14
#diffsml
	movk	WALKFDEF_SEQ,a0
	cmpi	16,a14
	jrlt	#setseq
	movk	WALKBDEF_SEQ,a0
	cmpi	>30,a14
	jrgt	#setseq
	movk	WALKLDEF_SEQ,a0
	move	a1,a1
	jrn	#setseq
	movk	WALKRDEF_SEQ,a0
	jruc	#setseq

#nodef2

;MJT
	clr	a0
	move	a0,*a13(plyr_keeppal)

	movk	RUN_SEQ,a0		;>Setup run sequence
	move	*a13(plyr_ownball),a14
	jrle	#nobl
	move	*a13(plyr_dribmode),a14
	jrn	#stndwb			;Can't drib?
	movk	RUNDRIB_SEQ,a0
#nobl
	move	a0,a1
	move	*a13(plyr_turbon),a14
	jrz	#slow
	addk	1,a0			;Turbo version
#slow
	addk	1,a1
	sub	a2,a1
	subk	1,a1
	jrhi	#setseq			;Different type?

	move	*a13(plyr_ani_p),a14,L
	move	*a14+,a14
	jrnz	#anicnt			;!At end?
	jruc	#setseq

#nojoy
	move	*a13(plyr_seqflgs),a0
	btst	WALK_B,a0
	jrnz	#anicnt

	movk	STNDDEF_SEQ,a0		;>Setup stand sequence
	movk	STNDDRIBDEF_SEQ,a1
	move	*a13(plyr_indef),a14
	jrnz	#chkb

	movk	STND2_SEQ,a0
	movk	STNDDRIB_SEQ,a1

	move	*a13(plyr_turndelay),a14
	jrz	#turnok1
	subk	1,a14
	move	a14,*a13(plyr_turndelay)
	subk	20,a14
	jrgt	#chkb
#turnok1
	move	*a13(plyr_o1dist),a14
	cmpi	155,a14
	jrlt	#stnd0
	move	*a13(plyr_o2dist),a14
	cmpi	155,a14
	jrgt	#stnd1
#stnd0
	movk	STND_SEQ,a0
	movk	STNDDRIB2_SEQ,a1
#stnd1

	move	*a13(plyr_ownball),a14
	jrle	#chka
	move	*a13(plyr_turndelay),a14
	jrz	#turnok0
	dec 	a14
	move	a14,*a13(plyr_turndelay)
	jruc	#chkb

#turnok0
	move	*a13(plyr_ohpdir),a14
	move	a14,*a13(plyr_newdir)
	jruc	#chkb
#chka
	move	*a13(plyr_turndelay),a14
	jrz	#turnok
	dec 	a14
	move	a14,*a13(plyr_turndelay)
	jruc	#chkb
#turnok	move	*a13(plyr_balldir),a14
	move	a14,*a13(plyr_newdir)



#chkb	move	*a13(plyr_ownball),a14
	jrle	#setseq
	move	a1,a0
	move	*a13(plyr_dribmode),a14
	jrgt	#setseq			;Dribbling?
#stndwb	movk	STNDWB_SEQ,a0
	move	@inbound,a14
	jrnn	#setseq
	move	*a13(plyr_num),a14
	btst	0,a14
	jrnz	#setseq
	movk	STNDWB2_SEQ,a0

#setseq	cmp	a0,a2
	jreq	#anicnt

	.if	IMGVIEW
	movi	debug_SEQ1,a0
	.endif

	callr	plyr_setseq

#anicnt	dsj	a10,#noani

	move	*a13(plyr_ani_p),a14,L		;>Set new ani
#getdel	move	*a14+,a10			;Delay
	jrnn	#nocode				;Not code?

	move	*a14+,a0,L			;*Code
	move	a14,b4
	call	a0				;Can trash scratch, A2-A5
	move	b4,a14
	jruc	#getdel

#nocode	jrnz	#100
	move	*a13(plyr_seqcode_p),a0,L
	jrge	#noendc
	call	a0				;Can trash scratch, A2-A5
#noendc	move	*a13(plyr_ani1st_p),a14,L	;Head of list
	move	*a14+,a10

#100	move	*a14+,a0,L			;*Img
	move	*a14+,a1			;Flags (OCTRL)
	move	*a13(plyr_anirevff),a2		;Get reverse flip flag
	xor	a2,a1
	move	a1,a4

	move	*a0(IANI2Z),*a13(plyr_ballzo)

	move	a14,*a13(plyr_ani_p),L
	callr	plyr_ani

	callr	anipt2_getsclxy
	move	a0,*a13(plyr_ballxo),L
	sra	16,a1
	move	a4,a4
	jrnn	#ynorm				;!YFree flag?
	movi	-200,a1
#ynorm	move	a1,*a13(plyr_ballyo)

	move	*a13(plyr_jmpcnt),a14
	jrnz	#injmp				;Jumping?

	move	*a13(plyr_aniy),a1
	neg	a1
	move	a1,*a8(OYPOS)			;Set on gnd

	cmpi	30,a10
	jrlt	#injmp
	movk	4,a10
#injmp

	move	*a8(OIMG),a2,L			;>Set new head img
	move	*a2(IANI3ID),a1
	sll	5,a1				;*32
	move	*a2(IANI3Z),a14
	neg	a14

	move	*a13(plyr_attrib_p),a0,L
	move	*a0(PAT_HEADT_p),a0,L
	add	a1,a0
	move	*a0,a4,L

	move	*a13(plyr_headobj_p),a3,L
	move	a14,*a3(OMISC)
	move	a4,*a3(OIMG),L			;Set new img
	move	*a4,a14,L
	move	a14,*a3(OSIZE),L
	move	*a4(ISAG),*a3(OSAG),L

	setf	1,0,0
	move	*a8(OCTRL+4),*a3(OCTRL+4)	;Copy HFlip bit
	move	*a2(IFLAGS+FLIPH_IFB),a14	;Chk reverse bit
	jrz	#nohflip
	move	*a3(OCTRL+4),a14		;Reverse hflip
	addk	1,a14
	move	a14,*a3(OCTRL+4)
#nohflip
	setf	16,1,0
#noani

;-------


	move	*a13(plyr_jmpcnt),a0	;>Jumping
	jrz	#noj
	addk	1,a0
	move	a0,*a13(plyr_jmpcnt)

	move	*a13(plyr_hangcnt),a0
	jrle	#nohang			;Not hanging?
	subk	1,a0
	move	a0,*a13(plyr_hangcnt)
	jruc	#pass			;Skip grav
#nohang
	move	*a8(OYVEL),a0,L
	move	*a13(plyr_ownball),a14
	jrgt	#grav			;Have ball?
;	btst	BUT1_B,a6		;Mario like jump
;	jrnz	#grav
;	addi	GRAV/2,a0		;+Grav/2
#grav	addi	GRAV,a0			;+Gravity
	jrn	#200
	move	*a8(OYPOS),a1
	move	*a13(plyr_aniy),a14
	add	a14,a1			;Ani pt position
	jrlt	#200			;Above gnd
	neg	a14
	move	a14,*a8(OYPOS)		;Set on gnd

	.if	DEBUG
;	clr	a0
;	move	a0,@slowmotion
	.endif

	movk	1,a10			;Run landing seq
	clr	a0
	move	a0,*a13(plyr_jmpcnt)
#200	move	a0,*a8(OYVEL),L

	move	*a13(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrnz	#znubb			;In dunk?

	move	*a8(OZPOS),a1		;Get SZ
	subi	CZMID,a1
	abs	a1
	cmpi	40,a1
	jrge	#znubb
	move	*a8(OXPOS),a0		;Get SX
	move	*a8(OXANI+16),a14
	add	a14,a0
	subi	WRLDMID,a0
	abs	a0
	move	a0,a3
	movi	>20000,a14
	cmpi	HOOPRX-WRLDMID+13,a0
	jrge	#undrbb			;Under backboard?

	subk	10,a1
	jrgt	#znubb
	cmpi	HOOPRX-WRLDMID-8,a3
	jrlt	#znubb			;!Under rim?
;	cmpi	HOOPRX-WRLDMID+13,a3
;	jrgt	#znubb			;!Under rim?

	movi	>10000,a14
	move	*a8(OXVAL),a1,L
	cmpi	WRLDMID<<16,a1
	jrlt	#rhoop
	neg	a14
#rhoop	add	a14,a1
	move	a1,*a8(OXVAL),L

	movi	>10000,a14
#undrbb
	move	*a8(OZVAL),a1,L
	cmpi	CZMID<<16,a1
	jrge	#dzpos			;In front of?
	neg	a14
#dzpos	add	a14,a1
	move	a1,*a8(OZVAL),L

#znubb

	move	*a13(plyr_ownball),a1
	jrz	#pass			;No ball?
	jrlt	#sblk			;Teammate has ball?

	move	*a13(plyr_jmpcnt),a0
	subk	12,a0
	jrlt	#pass			;Too soon?

;	move	*a8(OYVEL+16),a0
;	jrn	#chkb1

	move	*a8(OYPOS),a1
	move	*a13(plyr_aniy),a14
	add	a14,a1			;Ani pt position
	addk	15,a1
	jrlt	#chkb1			;High enough?

	move	*a13(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrnz	#slp			;Already started?

;	btst	BUT2_B+8,a6
;	jrnz	#dopass			;Air dish off pass?

	btst	SHOOT_B,a0
	jrz	#slp

	move	@gmqrtr,a0
	jrnz	#shoot2
	
	move	*a13(plyr_seq),a0
	cmpi	QSHOOT_SEQ,a0
	jrz	#shoot2
					;Force him to shoot 
	movk	5,a0
	move	*a13(plyr_num),a1
	calla	idiot_box		;Tell him to release ball at peak of jump

	jruc	#shoot2			;Too low?

#chkb1

	move	*a13(plyr_seq),a0
	subk	REBOUND_SEQ,a0
	jreq	#reb
	subk	REBOUNDA_SEQ-REBOUND_SEQ,a0
	jrne	#noreb
#reb
	btst	BUT1_B+8,a6
	jrz	#noreb			;No press?

	move	*a13(plyr_ohpdist),a14
	cmpi	150,a14
	jrgt	#pass			;Too far?

	move	*a13(plyr_ownball),a0
	jrle	#pass			;Don't have?

	move	*a13(plyr_ohpdir),a0
	move	*a13(plyr_dir),a1
	sub	a1,a0
	abs	a0
	cmpi	>40,a0
	jrle	#rdsml
	subi	>80,a0
	abs	a0
#rdsml	subk	32,a0
	jrgt	#pass			;Not between ball and hoop?

	movk	2,a0
	move	a0,@ballptsforshot

	movk	LAYUPREB_SEQ,a0
	callr	plyr_setseq
	jruc	#pass

#noreb

	btst	BUT1_B,a6
	jrnz	#pass			;Holding shoot button?

	btst	BUT2_B+8,a6
	jrnz	#dopass			;Air dish off pass?

	move	*a13(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrnz	#slp			;Already started?

	btst	SHOOT_B,a0
	jrz	#slp

#shoot2
	callr	plyr_shoot
	movk	1,a10
	jruc	#pass




#noj	move	@ballpnum,a0
	jrge	#sblk			;Somebody has ball?
	move	*a13(plyr_seq),a0
	cmpi	RUNDRIBTURB_SEQ,a0
	jrhi	#sblk			;Doing something?
	move	@ballgoaltcnt,a0
	jrgt	#sblk			;Going towards rim?
	move	*a13(plyr_balldist),a0
	cmpi	100,a0
	jrgt	#sblk			;Too far?
	move	@ballprcv_p,a1,L
	jrnz	#sblk			;Pass in progress?
	move	*a13(plyr_seqflgs),a0
	btst	NOJUMP_B,a0
	jrnz	#sblk			;No jumping?
	move	*a13(plyr_autoctrl),a0
	jrnz	#sblk			;Temp computer control?
	callr	plyr_tryrebound
	move	*a13(plyr_seqflgs),a0
	btst	NOJUMP_B,a0
	jrnz	#slp			;No jumping?



#sblk	btst	BUT1_B,a6		;>Shoot/block (But1)
	jrz	#pass

	move	*a13(plyr_ownball),a1
	jrlt	#drnshoot

;#tshoot

	movk	1,a0
	move	*a13(plyr_shtbutn),a14
	cmpi	2,a14
	jrle	#scont
	cmpi	9,a14
	jrge	#scont
	move	*a13(plyr_seq),a0
	cmpi	QSHOOT_SEQ,a0
	jrz	#dblhit
	cmpi	TIP_SEQ,a0
	jrz	#dblhit
	cmpi	TIPJ_SEQ,a0
	jrz	#dblhit

	clr	a0
;	move	a0,*a13(plyr_shtbutn)
;	callr	plyr_startjmp
;	jruc	#pass

#scont	move	a0,*a13(plyr_shtbutn)


	move	*a13(plyr_seqflgs),a0
	btst	NOJUMP_B,a0
	jrnz	#pass			;No jumping?
	btst	DUNK_B,a0
	jrnz	#pass			;Already in a dunk?

	move	*a13(plyr_rcvpass),a0
	jrgt	#slp			;Waiting on pass?

	move	*a13(plyr_tmproc_p),a0,L
	move	*a0(plyr_rcvpass),a0
	jrgt	#slp			;Teammate waiting on pass?

	callr	plyr_startjmp
	jruc	#pass

#drnshoot				;>Tell drone to shoot
;	btst	BUT3_B,a6
;	jrnz	#tshoot			;Turbo override?

	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	*a13(plyr_num),a1
	XORK	1,a1
	btst	a1,a0
	jrnz	#pass			;Teammate is a human?

	move	*a13(plyr_tmproc_p),a0,L
	movk	DRN_SHOOT_M,a1
	move	a1,*a0(plyr_d_cflgs)

	move	*a0(plyr_ohpdist),a14
	cmpi	350,a14
	jrlt	#pass			;Drone is close enough?

	move	@gmqrtr,a14
	jrnz	#pass

	move	*a0(plyr_jmpcnt),a14
	jrnz	#pass

	move	*a13(plyr_idiotbit),a14
	btst	1,a14
	jrnz	#pass
	addk	2,a14
	move	a14,*a13(plyr_idiotbit)

	movk	4,a0
	move	*a13(plyr_num),a1
	calla	idiot_box		;Tell drone to shoot ball




#pass					;>Pass/steal (But2)
	move	*a13(plyr_shtbutn),a0
	jrz	#dblhit
	inc	a0
	move	a0,*a13(plyr_shtbutn)
#dblhit

	move	*a13(plyr_ownball),a2
	jrz	#steal			;No ball?

	move	*a13(plyr_rcvpass),a0
	jrgt	#slp			;Waiting on pass?

	btst	BUT2_B+8,a6
	jrz	#slp
	move	*a13(plyr_seqflgs),a14
	btst	PASS_B,a14
	jrnz	#slp			;Passing?

	move	@pass_off,a14
	jrnz	#slp			;Lockout passing for now?

	move	a2,a2
	jrlt	#passtome
#dopass

	callr	plyr_startpass
	jruc	#slp

#passtome				;>Tell drone to pass
	btst	BUT3_B,a6
	jrnz	#steal			;Turbo?

	move	*a13(plyr_tmproc_p),a0,L
	movk	DRN_PASS_M,a1
;	btst	6,a6
;	jrz	#regds			;No turbo?
;	ori	>8000,a1
#regds	move	a1,*a0(plyr_d_cflgs)
	jruc	#slp




#steal
	btst	BUT2_B,a6
	jrz	#slp			;No button?
	move	*a13(plyr_jmpcnt),a0
	jrnz	#slp
	move	*a13(plyr_seq),a0
	btst	BUT3_B,a6
	jrnz	#push			;Turbo?

	subi	STEAL_SEQ,a0
	jreq	#slp

	move	*a13(plyr_rcvpass),a0
	jrgt	#slp			;Getting pass?
	move	*a13(plyr_tmproc_p),a1,L
	move	*a1(plyr_rcvpass),a0
	jrgt	#slp			;Getting pass?

	move	*a13(plyr_keeppal),a0	;Getting up while on fire, on butt
	jrz	#noflames
	calla	seq_stopfire
#noflames
	movi	STEAL_SEQ,a0
	callr	plyr_setseq
	move	*a13(plyr_balldir),*a13(plyr_newdir)

	jruc	#slp

#push
	btst	BUT2_B+8,a6
	jrz	#slp			;No button?
	move	*a13(plyr_PDATA_p),a2,L
	move	*a2(ply_turbo),a1
	cmpi	10,a1
	jrlt	#slp			;Turbo too low?
	subi	PUSH_SEQ,a0
	jreq	#slp


	move	*a13(plyr_num),a0	;If on fire, don't use turbo on push
	move	@plyrnumonfire,a14
	cmp	a0,a14
	jrz	#notingame2


	subk	8,a1
	move	a1,*a2(ply_turbo)
	move	*a2(ply_meter_imgs+40h),a0,L
	move	*a0(OFSET),a1		;Shrink meter
	addk	8,a1
	move	a1,*a0(OFSET)

#notingame2
	calla	seq_stopfire
	movi	PUSH_SEQ,a0
	callr	plyr_setseq

#slp
	move	*a13(plyr_ownball),a1
	jrle	#nob
	callr	plyr_setballxyz
#nob

#halted
	callr	plyr_headalign
	callr	plyr_setshadow

;	.if	DEBUG
;	callr	plyr_setgndaligndot
;	.endif

;#halted
	SLOOP	1,#lp


#pdat_t	.word	P1_PID,3<<4,120,CZMID-50
	.long	w3run1
#pd1	.word	P2_PID,2<<4,175,CZMID
	.long	w3run1
	.word	P3_PID,6<<4,215,CZMID
	.long	w3run1
	.word	P4_PID,7<<4,280,CZMID+50
	.long	w3run1

ltshoepal_t
	COLORW	31,31,31, 27,27,27, 22,22,22, 18,18,18
	COLORW	14,14,14
;dkshoepal_t
;	COLORW	8,8,8, 6,6,6, 5,5,5, 4,4,4
;	COLORW	2,2,2


#dirc_t	.byte	0,0,4<<4,0,6<<4,7<<4,5<<4,0,2<<4,1<<4,3<<4,0,0,0,0,0

pdta_l	.long	P1DATA,P2DATA,P3DATA,P4DATA


#sqsnds	.long	sqk1_snd,sqk2_snd,sqk3_snd,sqk4_snd

#kpball_t
;	.word	100,130,160,190,200,220,280,300,450,550,850
	.word	190,200,220,280,300,450,550,600,650,650,650

#noblflail_t
;	.word	50,65,80,80,80,80,100,130,170,250,250
	.word	85,100,105,110,115,120,150,190,250,250,300

#shortfly_t
;	.word	50,100,140,160,180,200,250,300,400,550,650
	.word	140,160,180,200,250,300,400,550,650,650,650

#winshortfly_t
	.word	50/2,100/2,100/2,120/2,150/2,150/2,200/2,300/2,450/2,550/2,550/2

#flyb_t
;Extra % chance of allowing losing team to keep ball after being pushed
;1 pt down up to 15 & over down
;	.word	250,275,300,325,350,375,400,425,450,475,500
;	.word	500,500,500,500,500,500,500,500

	.word	25,50,75,100,125,150,175,200,225,250,275
	.word	275,275,275,275,275,275,275,275,275

RED_C	.equ	0
GRN_C	.equ	1
BLU_C	.equ	3
PUR_C	.equ	4
BLK_C	.equ	3
WHT_C	.equ	6
;YEL_C	.equ	7
	.asg	>80,I	;Always keeps home colors

#team_t	.byte	RED_C,GRN_C,BLU_C,RED_C,BLU_C,BLU_C,BLU_C,BLU_C
	.byte	BLU_C,RED_C,BLU_C,RED_C,PUR_C,BLK_C,GRN_C,BLU_C
	.byte	WHT_C,BLU_C,BLK_C,RED_C,PUR_C,BLK_C,BLU_C,BLK_C
	.byte	GRN_C,PUR_C,RED_C


********************************
* Setup player sequence data
* A0=Sequence #
* A7=Dir 0-127
* A13=*Player process
* >A10=New ani cnt
* Trashes scratch

 SUBR	plyr_setseq


	cmpi	TIP_SEQ,a0
	jrnz	#bugok
	move	@scores,a14,L
	jrz	#bugok			;Game start?
	LOCKUP
	movk	STND_SEQ,a0
	
#bugok

	move	a0,*a13(plyr_seq)

	sll	5,a0			;*32
	addi	pseq_t,a0
	move	*a0,a0,L
	move	*a0+,a1			;Get flags
	move	a1,*a13(plyr_seqflgs)


	btst	DRIBBLE_B,a1		;>Calc new dribble mode
	jrnz	#d

	move	*a13(plyr_dribmode),a14
	jrz	#n
	movi	-1,a1
	jruc	#setd

#d	move	*a13(plyr_dribmode),a14
	jrnz	#n
	movk	1,a1

#setd	move	a1,*a13(plyr_dribmode)
#n

	move	*a0+,a1,L		;Get *code
	move	a1,*a13(plyr_seqcode_p),L
	move	a7,a1			;Dir
	addk	8,a1			;Round off
	sll	32-7,a1
	srl	32-7+4,a1		;Kill frac
	move	a1,*a13(plyr_seqdir)

	clr	a14			;Dir 5-7 have reversed FLIPH
	cmpi	5,a1
	jrlt	#nohf
	movi	M_FLIPH,a14
#nohf	move	a14,*a13(plyr_anirevff)

	sll	32-3,a1			;Clr bits
	srl	32-3-5,a1		;*32
	add	a1,a0
	move	*a0,a0,L
	move	a0,*a13(plyr_ani1st_p),L
	move	a0,*a13(plyr_ani_p),L

	movk	1,a10

	rets


********************************
* Delete a players processes and objects
* A0=Plyr # (0-3)

; SUBRP	plyr_del
;
;	PUSH	a2,a3
;
;	move	a0,a2
;	move	a0,a3
;	sll	5,a3		;*32
;	addi	pdel_t,a3
;
;	move	*a3+,a0
;	calla	KIL1C		;Kill process
;
;	move	*a3+,a0
;	calla	obj_del1c	;Kill plyr images
;
;	clr	a0
;	sll	5,a2		;*32
;	movi	plyrobj_t,a1
;	add	a2,a1
;	move	a0,*a1,L
;
;	addi	plyrproc_t,a2
;	move	a0,*a2,L
;
;	PULL	a2,a3
;	rets
;
;
;pdel_t	.word	P1_PID,CLSPLYR|TYPPLYR|SUBPL1
;	.word	P2_PID,CLSPLYR|TYPPLYR|SUBPL2
;	.word	P3_PID,CLSPLYR|TYPPLYR|SUBPL3
;	.word	P4_PID,CLSPLYR|TYPPLYR|SUBPL4




#*******************************
* Update player controls (called by main loop)

 SUBR	joy_read

	move	@GAMSTATE,a0
	subk	INGAME,a0
	jrne	#x
	move	@HALT,a0
	jrnz	#x
	move	@plyrproc_t,a0,L	;Get 1st plyr proc
	move	*a0(plyr_autoctrl),a0
	jrnz	#x			;Temp computer control?

 SUBRP	joy_read2			;Called by reftip

	move	@PSTATUS,a0		;Plyr start bits 0-3

	.if	TUNIT

	move	@TWOPLAYERS,a14		;!0=2 plyr kit
	jrz	#4p

	movi	P2CTRL,a1		;A1=*PxCTRL

	move	@SWITCH,a2
	not	a2

	srl	2,a0			;P2
	jrnc	#no2p2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	move	a2,a3
	sll	32-8,a3
	srl	32-8,a3
	or	a3,a14
	move	a14,*a1

#no2p2	addk	16,a1			;P3
	srl	1,a0
	jrnc	#x
	zext	a2
	srl	8,a2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	or	a2,a14
	move	a14,*a1

	jruc	#x


#4p					;>4 player version
	movi	P1CTRL,a1		;A1=*PxCTRL

	move	@SWITCH,a2
	not	a2

	srl	1,a0			;P1
	jrnc	#nop1
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	move	a2,a3
	sll	32-8,a3
	srl	32-8,a3
	or	a3,a14
	move	a14,*a1

#nop1	addk	16,a1			;P2
	srl	1,a0
	jrnc	#nop2
	zext	a2
	srl	8,a2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	or	a2,a14
	move	a14,*a1

#nop2
	move	@SWITCH2,a2
	not	a2

	addk	16,a1			;P3
	srl	1,a0
	jrnc	#nop3
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	move	a2,a3
	sll	32-8,a3
	srl	32-8,a3
	or	a3,a14
	move	a14,*a1

#nop3	srl	1,a0			;P4
	jrnc	#x
	addk	16,a1
	zext	a2
	srl	8,a2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	or	a2,a14
	move	a14,*a1

	.else				;>YUNIT

	move	@SWITCH,a2,L
	not	a2

	srl	1,a0			;P1
	jrnc	#nop1
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	move	a2,a3
	sll	32-8,a3
	srl	32-8,a3
	or	a3,a14
	move	a14,*a1

#nop1	addk	16,a1			;P2
	srl	8,a2
	srl	1,a0
	jrnc	#nop2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	move	a2,a3
	sll	32-8,a3
	srl	32-8,a3
	or	a3,a14
	move	a14,*a1

#nop2	addk	16,a1			;P3
	srl	1,a0
	jrnc	#nop3
	srl	16,a2
	move	a2,a14			;>Move bit 7 to 6 (But 3)
	sll	32-6,a2
	srl	7,a14
	or	a14,a2
	rl	6,a2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	or	a2,a14
	move	a14,*a1

#nop3	srl	1,a0			;P4
	jrnc	#x
	move	@SWITCH+>20,a2
	not	a2
	addk	16,a1
	sll	32-8,a2
	srl	32-8,a2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	or	a2,a14
	move	a14,*a1


	.endif

#x
	rets

	.if 0
	move	@GAMSTATE,a0
	subk	INGAME,a0
	jrne	#x
	move	@HALT,a0
	jrnz	#x
	move	@plyrproc_t,a0,L	;Get 1st plyr proc
	move	*a0(plyr_autoctrl),a0
	jrnz	#x			;Temp computer control?

 SUBRP	joy_read2			;Called by reftip

	move	@PSTATUS,a0		;Plyr start bits 0-3
	movi	P1CTRL,a1		;A1=*PxCTRL

	.if	TUNIT

	move	@SWITCH,a2
	not	a2

	srl	1,a0			;P1
	jrnc	#nop1
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	move	a2,a3
	sll	32-8,a3
	srl	32-8,a3
	or	a3,a14
	move	a14,*a1

#nop1	addk	16,a1			;P2
	srl	1,a0
	jrnc	#nop2
	zext	a2
	srl	8,a2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	or	a2,a14
	move	a14,*a1

#nop2
	move	@SWITCH2,a2
	not	a2

	addk	16,a1			;P3
	srl	1,a0
	jrnc	#nop3
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	move	a2,a3
	sll	32-8,a3
	srl	32-8,a3
	or	a3,a14
	move	a14,*a1

#nop3	srl	1,a0			;P4
	jrnc	#x
	addk	16,a1
	zext	a2
	srl	8,a2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	or	a2,a14
	move	a14,*a1

	.else

	move	@SWITCH,a2,L
	not	a2

	srl	1,a0			;P1
	jrnc	#nop1
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	move	a2,a3
	sll	32-8,a3
	srl	32-8,a3
	or	a3,a14
	move	a14,*a1

#nop1	addk	16,a1			;P2
	srl	8,a2
	srl	1,a0
	jrnc	#nop2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	move	a2,a3
	sll	32-8,a3
	srl	32-8,a3
	or	a3,a14
	move	a14,*a1

#nop2	addk	16,a1			;P3
	srl	1,a0
	jrnc	#nop3
	srl	16,a2
	move	a2,a14			;>Move bit 7 to 6 (But 3)
	sll	32-6,a2
	srl	7,a14
	or	a14,a2
	rl	6,a2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	or	a2,a14
	move	a14,*a1

#nop3	srl	1,a0
	jrnc	#x
	move	@SWITCH+>20,a2
	not	a2
	addk	16,a1
	sll	32-8,a2
	srl	32-8,a2
	move	*a1,a14
	xor	a2,a14			;New with old. Changed bits are now on
	and	a2,a14			;Keep down transitions
	sll	8,a14
	or	a2,a14
	move	a14,*a1


	.endif

#x
	rets

	.endif

#*******************************
* Check for collision with opponent players
* A8=*Obj
* A13=*Player process
* Trashes scratch

 SUBRP	plyr_chkpcollide

	PUSH	a2,a3,a4,a5,a6,a7,a9,a10,a11

	movk	2,b1
	move	*a8(OXPOS),a4
	move	*a8(OXANI+16),a14
	add	a14,a4
	move	a4,a5
	move	*a8(OSIZEX),a14

	move	*a8(OIMG),a1,L
	move	*a1(IFLAGS),a1
	jrn	#lscl			;Large art?
	move	a14,a1			;*75%
	srl	2,a1
	sub	a1,a14
	sll	1,a14
#lscl	srl	2,a14			;/4
	sub	a14,a4			;A4=Box left
	add	a14,a5			;A5=Box rgt
	move	*a8(OZPOS),a6		;A6=Z
;	move	*a8(OIMG),a0,L
;	move	*a0(ICBZ),a11		;A11=Z radius (1-?)
;	jrnz	#test
	movk	13,a11
;#test

	movi	plyrobj_t,a7
	move	*a13(plyr_num),a0
	subk	2,a0
	jrge	#lp
	addi	64,a7

#lp	move	*a7+,a9,L
;	cmp	a9,a8
;	jreq	#next

;	move	*a9(OPLINK),a14,L
;	move	*a13(plyr_num),a0
;	move	*a14(plyr_num),a2
;	srl	1,a0
;	srl	1,a2
;	cmp	a0,a2
;	jreq	#next			;Same team?


	move	*a9(OZPOS),a2		;>Chk Z
	sub	a6,a2
	abs	a2
	move	*a9(OIMG),a1,L
	move	*a1(ICBZ),a3		;Get Z radius
	jrnz	#test2
	movk	13,a3
#test2	add	a11,a3
	cmp	a3,a2
	jrge	#next

	move	*a9(OXPOS),a1		;>Chk box X
	move	*a9(OXANI+16),a14
	add	a14,a1
	move	*a9(OSIZEX),a14

	move	*a8(OIMG),a2,L
	move	*a2(IFLAGS),a2
	jrnn	#smlscl2		;Small art?
	move	a14,a2			;*75%
	srl	2,a2
	sub	a2,a14
#smlscl2
	srl	1,a14			;/2
	add	a14,a1
	sub	a4,a1
	jrle	#next			;His rgt <= my lft edge?
	move	a1,a10
	add	a4,a1
	sub	a14,a1
	sub	a14,a1
	sub	a5,a1
	jrge	#next			;His lft >= my rgt edge?

	move	a1,a0			;A10=Closer edge match
	abs	a0
	cmp	a0,a10
	jrle	#smledge
	move	a0,a10
#smledge

	move	*a8(OYPOS),a0
	move	*a9(OYPOS),a1
	addi	75,a1			;Y difference
	cmp	a1,a0
	jrgt	#next			;Opponent much higher?


					;>Outer box collision
	move	*a8(OXVEL),a14,L
	abs	a14
	srl	15,a14
	jrnz	#otrbnc			;Moving?
	move	*a8(OZVEL),a2,L
	abs	a2
	srl	15,a2
;	jrnz	#otrbnc
	jrz	#chkib			;Not moving?

#otrbnc
	PUSH	a6,a7
	clr	a0
	clr	a1
	move	*a8(OXVEL),a6,L
	move	*a8(OZVEL),a7,L
	callr	seekdir_xyxy128		;Customize?
	PULL	a6,a7

	move	*a13(plyr_num),a2
	sll	2,a2			;*4
	move	*a9(OPLINK),a1,L
	move	*a1(plyr_num),a1
	add	a1,a2
	sll	4,a2			;*16
	addi	#c_t,a2
	move	*a2,a2			;Get my dir variable offset
	add	a13,a2
	move	*a2,a2			;Get dir

	sub	a0,a2
	move	a2,a14
	abs	a14
	cmpi	>40,a14
	jrle	#dsml
	neg	a2
#dsml	move	a2,a2
	jrge	#angpos			;Positive angle?
	addi	>28+>28,a0
#angpos	subi	>28,a0

	addk	4,a0
	sll	32-7,a0
	srl	32-7+3,a0		;Leave 4 bits
	sll	4,a0
	addi	#vel_t,a0

	move	*a0,a1
	move	*a0(16*4),a0
	sll	1,a0
	sll	1,a1
	move	*a8(OXVAL),a14,L
	add	a0,a14
	move	a14,*a8(OXVAL),L
	move	*a8(OZVAL),a14,L
	add	a1,a14
	move	a14,*a8(OZVAL),L


#chkib
	subk	6,a10
	jrle	#next			;X edges slightly touching?

	move	*a9(OZPOS),a1
	sub	a6,a1
	abs	a1			;Z distance
	subk	6,a3
	cmp	a3,a1			;Z radius
	jrge	#next

					;>Inner box collision
	move	*a8(OXVEL),a14,L
	move	*a9(OXVEL),a2,L
	move	a2,a3
	xor	a14,a2
	move	a2,a2
	jrn	#xvdif			;XV different dir?
	move	a14,a0
	abs	a3
	abs	a0
	cmp	a3,a0
	jrlt	#skipxv			;My vel smaller?
	xor	a14,a2			;Fix A2
	sub	a2,a14
#xvdif
	move	*a8(OXVAL),a1,L
	sub	a14,a1
	move	a1,*a8(OXVAL),L
#skipxv
	move	*a8(OZVEL),a14,L
	move	*a9(OZVEL),a2,L
	move	a2,a3
	xor	a14,a2
	move	a2,a2
	jrn	#zvdif			;ZV different dir?
	move	a14,a0
	abs	a3
	abs	a0
	cmp	a3,a0
	jrlt	#next			;My vel smaller?
	xor	a14,a2			;Fix A2
	sub	a2,a14
#zvdif
	move	*a8(OZVAL),a1,L
	sub	a14,a1
	move	a1,*a8(OZVAL),L


	move	*a13(plyr_ownball),a0
	jrgt	#next			;I have ball?

	move	*a13(plyr_stagcnt),a10	;>Add some stagger
	move	*a9(OPLINK),a14,L

	move	*a14(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrz	#nodunk			;!Dunking?
	btst	LAYUP_B,a0
	jrnz	#nodunk			;Layup=don't disrupt ball

	addk	1,a10
	move	*a13(plyr_num),a0
	move	*a14(plyr_num),a2
	srl	1,a0
	srl	1,a2
	cmp	a0,a2
	jreq	#nodunk			;Same team?

	move	*a13(plyr_jmpcnt),a0
	jrz	#nopop
	move	*a8(OYPOS),a0
	move	*a9(OYPOS),a1
	addk	9,a1			;15

	cmp	a1,a0
	jrgt	#nopop			;Dunker is higher?


	move	@slamming,a0		;Ball already successfully into hoop
	jrnz	#nopop

	move	@HCOUNT,a0
	sll	32-4,a0
	jrnz	#noflsh

	calla	flash_reward

#noflsh
;Shawn, this % should also key off from ptsdown.  The % should never get
;higher, but maybe get a bit lower for the good team?

	move	*a13(plyr_attrib_p),a14,L
	move	*a14(PAT_DEFSKILL),a0
	sll	4,a0
	addi	tryblk_t,a0
	move	*a0,a0

;	movk	22,a0			;38,25,21,19


	move	*a13(plyr_num),a14

;	move	@plyrnumonfire,a3
;	cmp	a14,a3
;	jrnz	#nofire
;;This guy on fire
;	movi	75,a0
;#nofire

	move	@PSTATUS,a3
	btst	a14,a3
	jrnz	#cont
	movk	18,a0			;Drone is less
#cont

	calla	RNDPER
	jrls	#nopop

;	movk	>1f,a0
;	callr	rnd
;	jrnz	#nopop

	calla	rejected_dnk_speech

	move	a13,a3
	calla	def_play_reward		;Good defensive play reward snds, etc

;If player is still going up, give him ball, otherwise, maybe disrupt dunk

	move	*a13(plyr_seq),a0
	cmpi	BLOCKREJ_SEQ,a0
	jreq	#disrupt
	cmpi	FASTBLOCKREJ_SEQ,a0
	jreq	#disrupt

	movi	200,a0
	calla	RNDPER
	jrhi	#disrupt

	move	*a8(OYVEL),a0,L
	jrn	#gvbl

#disrupt
;If coming down, disrupt ball

;MJT
;	movi	200,a0
;	calla	RNDPER
;	jrhi	#gvbl

;Probably want to give swatter the ball if this is a rebound!
;Check goaltcnt?
	

;	movi	deflectd,a0		;deflected!
;	calla	snd_play1

	move	*a13(plyr_dir),a0
	calla	sinecos_get

	move	@ballobj_p,a2,L

	sll	4,a0
	sll	4,a1
	move	a0,*a2(OZVEL),L
	move	a1,*a2(OXVEL),L
	movi	-GRAV*21,a1		;Towards roof
	move	a1,*a2(OYVEL),L

	movi	-1,a0
	move	a0,@ballpnum
	move	a0,@ballpnumlast

	calla	ball_convfmprel

	move	*a9(OPLINK),a14,L

	clr	a0
	move	a0,*a14(plyr_ownball)

	movk	15,a0
	move	a0,*a13(plyr_shtdly)
	move	a0,*a14(plyr_shtdly)

     	jruc	#nopop

#gvbl
	move	*a13(plyr_num),a0	;Give defender the ball
	move	a0,@ballpnum
	clr	a0
	move	a0,*a13(plyr_dribmode)
;	movi	steal_snd,a0
;	calla	snd_play1



#nopop
;	move	@plyrcharge,a0
;	addk	1,a0
;	move	a0,@plyrcharge

#nodunk	move	*a14(plyr_jmpcnt),a3
	jrz	#ongnd
	addk	1,a10			;Collided with a jumper
#ongnd
	move	*a13(plyr_seqflgs),a2
	btst	EASYSTAG_B,a2
	jrz	#nesy			;!An easy stagger?
	move	*a13(plyr_num),a0
	move	*a14(plyr_num),a2
	srl	1,a0
	srl	1,a2
	cmp	a0,a2
	jreq	#setstg			;Same team?
	addk	1,a10
#nesy
#setstg	move	a10,*a13(plyr_stagcnt)

#next	dsj	b1,#lp


#x	PULL	a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets

tryblk_t
	.word	1,2,3,10,15,18,22,23,24,25,25

#c_t	.word	0,plyr_tmdir,plyr_o1dir,plyr_o2dir
	.word	plyr_tmdir,0,plyr_o1dir,plyr_o2dir
	.word	plyr_o1dir,plyr_o2dir,0,plyr_tmdir
	.word	plyr_o1dir,plyr_o2dir,plyr_tmdir,0

#vel_t
	.word	-16384,-15137,-11585,-6270
	.word	0,6270,11585,15137,16384,15137,11585,6270
	.word	0,-6269,-11585,-15137,-16384,-15137,-11585,-6270



#*******************************
* Change the players image
* A0=*New image
* A1=New OCTRL (low 8 bits)
* A8=*Obj
* A13=*Plyr process
* Trashes scratch, A2,A3

 SUBRP	plyr_ani


	cmpi	ROM,a0
	jrlo	#anierr

	move	a0,a2
	move	a1,a3

	callr	anipt_getsclxy

	movb	a3,*a8(OCTRL)

	move	a2,*a8(OIMG),L
	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L

	move	*a13(plyr_attrib_p),a14,L
	move	*a14,a14,L		;Get *scale_t
	move	*a2(IFLAGS),a2
	jrnn	#small			;Bit15 = Scale

	addi	SCALETSIZE,a14		;>c80

;Shawn, help!
	move	@baby_flag,a2
	jrz	#cont
	addi	SCALETSIZE,a14		;Funny option - small bodies
	jruc	#cont

#small
	move	@baby_flag,a2
	jrz	#cont
	addi	>1a00,a14		;Small bodies for small artwork
#cont
	move	a14,*a8(ODATA_p),L

	move	a0,a2
	move	a1,a3
	callr	anipt_getsclxy

	sub	a0,a2			;Subtract new from old
	sub	a1,a3

	move	a0,*a8(OXANI),L		;Save scaled anipt
	sra	16,a1
	move	a1,*a13(plyr_aniy)

	move	a8,a0			;Get base address
	addi	OXVAL,a0
	move	*a0,a14,L		;New OXVAL
	add	a2,a14
	move	a14,*a0+,L
	move	*a0,a14,L		;New OYVAL
	add	a3,a14
	move	a14,*a0,L

#x	rets


#anierr 
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	2,2
	.endif
	jruc	#x




#*******************************
* Start player jumping (block, shoot, dunk)
* A8=*Plyr obj
* A13=*Plyr process
* Trashes scratch, A2-A5

 SUBRP	plyr_startjmp

	PUSH	a6,a7

;MJT
	move	*a13(plyr_ownball),a5
	jrz	#blk			;We don't have ball?


	move	*a13(plyr_ohoopx),a6
	movi	CZMID,a7
	callr	seekdirdist_obxz128

	move	*a13(plyr_newdir),a4	;Get old
	move	a0,*a13(plyr_newdir)	;Turn toward basket

	move	a5,a5
	jrlt	#blkd			;Teammate has ball?

	clr	a14
	move	a14,@reduce_3ptr

	cmpi	400,a1
	jrge	#desp			;Long shot?

	cmpi	270,a1
	jrge	#3ptr			;3ptr


	cmpi	200,a1
	jrge	#tag1

	move	*a13(plyr_seqdir),a14
	jrz	#ahook
	subk	4,a14
	jrne	#tag1
#ahook
	move	*a13(plyr_ohpdir),a14
	addk	8,a14			;Round off
	sll	32-7,a14
	srl	32-7+4,a14		;Kill frac
	jrz	#tag1
	cmpi	4,a14
	jrz	#tag1



	move	*a13(plyr_num),a2
	srl	1,a2
	jrz	#tg1			;Team1?
	cmpi	5,a14
	jrlt	#tag1			;Team 2 behind hoop
	jruc	#tgx
#tg1	cmpi	4,a14
	jrge	#tag1
#tgx



	move	*a13(plyr_ohpdist),a14
	cmpi	40h,a14			;48h
	jrlt	#tag1			;Too close for hook?
	move	*a8(OZPOS),a14
	cmpi	>430,a14
	jrlt	#tag1
	cmpi	>4fa,a14
	jrgt	#tag1
;Okay to do hook!	

	move	a4,*a13(plyr_newdir)	;Turn toward basket
	jruc	#hs			;Hook shot
#tag1

	move	a0,a3
	move	a1,a4
					;>Skip dunks from behind the hoop
	addk	8,a0			;Round off
	sll	32-7,a0
	srl	32-3,a0			;Kill frac
	move	*a13(plyr_num),a14
	srl	1,a14
	jrnz	#lhoop			;Team2?
	subk	5,a0
	jrlt	#trydunk
	jruc	#sj


;If behind hoop, I will try to do a hook shot...

#lhoop	move	a0,a0
	jrz	#trydunk
	subk	4,a0
	jrlt	#sj


#trydunk				;>Try a dunk
	cmpi	60,a4
	jrle	#velok			;Close to hoop?

	move	*a13(plyr_dir),a14
	sub	a3,a14
	abs	a14
	cmpi	>40,a14
	jrle	#nodov
	subi	>80,a14
	abs	a14
#nodov
	subk	24,a14
	jrgt	#sj			;!Facing basket?

;Shawn, stop dunker if he just made a real quick move.  Should we do this?
;	move	*a13(plyr_dirtime),a14
;	subk	4,a14
;	jrgt	#dnk_ok
;	nop
;	jruc	#sj
;
;#dnk_ok

	cmpi	170,a4			;Max dunk range
	jrge	#sj			;Too far for dunk?

;	cmpi	36,a4			;Short range
;	jrle	#sj			;Too close?

	move	*a8(OXVEL),a14,L	;>Chk velocity
	abs	a14
	srl	16,a14
	jrnz	#velok
	move	*a8(OZVEL),a14,L
	abs	a14
	srl	16,a14
	jrz	#sj
#velok

;Perhaps allow big guys to dunk through anybody!
	move	*a13(plyr_attrib_p),a0,L
	move	*a0(PAT_POWER),a0
	sll	4,a0
	addi	dnkthru_t,a0
	move	*a0,a0
	calla	RNDPER
	jrhi	#dunk			;Yes, jump over anybody!

;	movk	7,a0			;12%
;	callr	rnd
;	jrz	#dunk			;Ignore opponents?


;Get opponents defense of dunks info
	movi	64,a7
	move	*a13(plyr_num),a14
	cmpi	2,a14
	jrlt	#tm1
	clr	a7
#tm1
	movi	plyrproc_t,a14,L
	add	a7,a14
	move	*a14,a14,L




	move	*a14(plyr_num),a7
	move	@plyrnumonfire,a0
	cmp	a0,a7
	jrnz	#nof1
;This defender is on fire!  Make his defense of dunkers the best!
	movk	11,a0
	jruc	#gdd
#nof1
	move	*a14(plyr_attrib_p),a14,L
	move	*a14(PAT_DEFSKILL),a0
#gdd
	sll	4,a0
	movi	#dist_t,a14
	add	a0,a14
	move	*a14,a2			;Distance check
	movi	#width_t,a14
	add	a0,a14
	move	*a14,a0			;Get width of check			;Distance check


	move	*a13(plyr_o1dist),a14
	cmp	a14,a4
	jrlt	#o1dok			;I'm closer?

;	cmpi	50,a14
	cmp	a2,a14

	jrgt	#o1dok			;He's too far?
	move	*a13(plyr_o1dir),a2
	sub	a3,a2
	abs	a2
	cmpi	>40,a2
	jrle	#o1dsml
	subi	>80,a2
	abs	a2
#o1dsml

;	subk	32,a2
	sub	a0,a2

	jrlt	#trylyup		;In front of me?
#o1dok

	movi	64,a7
	move	*a13(plyr_num),a14
	cmpi	2,a14
	jrlt	#tm1a
	clr	a7
#tm1a
	movi	plyrproc_t+32,a14,L
	add	a7,a14
	move	*a14,a14,L

	move	*a14(plyr_num),a7
	move	@plyrnumonfire,a0
	cmp	a0,a7
	jrnz	#nof2
;This defender is on fire!  Make his defense of dunkers the best!
	movk	11,a0
	jruc	#gdd2
#nof2

	move	*a14(plyr_attrib_p),a14,L
	move	*a14(PAT_DEFSKILL),a0
#gdd2
	sll	4,a0
	movi	#dist_t,a14
	add	a0,a14
	move	*a14,a2			;Distance check
	movi	#width_t,a14
	add	a0,a14
	move	*a14,a0			;Get width of check			;Distance check



	move	*a13(plyr_o2dist),a14
	cmp	a14,a4
	jrlt	#o2dok			;I'm closer?
;	cmpi	50,a14
	cmp	a2,a14
	jrgt	#o2dok			;He's too far?
	move	*a13(plyr_o2dir),a2
	sub	a3,a2
	abs	a2
	cmpi	>40,a2
	jrle	#o2dsml
	subi	>80,a2
	abs	a2
#o2dsml
;	subk	32,a2
	sub	a0,a2
	jrlt	#trylyup		;In front of me?
#o2dok

#dunk	move	a3,*a13(plyr_dir)
	movi	-1,a14
	move	a14,*a13(plyr_newdir)	;Cancel turn

	addk	8,a3			;Round off
	srl	4,a3			;Kill frac
	sll	5,a3			;*32

	.ref	getdunkseq
	calla	getdunkseq
	move	a0,a0
	jrnz	#sj

	clr	a0
	move	a0,@shot_distance

	movk	DUNK_SHORT,a0
	cmpi	80,a4
	jrle	#short

	movk	DUNK_MED,a0
	cmpi	120,a4
	jrle	#med

	movk	DUNK_LONG,a0
#short
#med
	move	a0,@shot_type

	move	*a3,a2,L
	move	*a2+,a0			;#Entries-1
	callr	rndrng0

	sll	4,a0			;*16
	add	a2,a0
	move	*a0,a0
	jrz	#sj			;Null entry?

;	movi	DUNKA_SEQ,a0
;	movi	DUNKA2_SEQ,a0
;	movi	DUNKB_SEQ,a0
;	movi	DUNKB2_SEQ,a0
;	movi	DUNKC_SEQ,a0
;	movi	DUNKD_SEQ,a0
;	movi	DUNKD2_SEQ,a0
;	movi	DUNKE_SEQ,a0
;	movi	DUNKE2_SEQ,a0
;	movi	DUNKF_SEQ,a0
;	movi	DUNKG_SEQ,a0
;	movi	DUNKG2_SEQ,a0
;	movi	DUNKJ_SEQ,a0
;	movi	DUNKJ2_SEQ,a0
;	movi	DUNKJ3_SEQ,a0
;	movi	DUNKJ4_SEQ,a0
;	movi	DUNKK_SEQ,a0
;	movi	DUNKK2_SEQ,a0
;	movi	DUNKL_SEQ,a0
;	movi	DUNKL2_SEQ,a0
;	movi	DUNKL3_SEQ,a0
;	movi	DUNKL4_SEQ,a0
;	movi	DUNKN_SEQ,a0
;	movi	DUNKN2_SEQ,a0
;	movi	DUNKO_SEQ,a0
;	movi	DUNKO2_SEQ,a0
;	movi	DUNKP_SEQ,a0
;	movi	DUNKP2_SEQ,a0
;	movi	DUNKP3_SEQ,a0
;	movi	DUNKQ_SEQ,a0
;	movi	DUNKQ2_SEQ,a0
;	movi	DUNKQ3_SEQ,a0
;	movi	DUNKQ4_SEQ,a0
;	movi	DUNKR_SEQ,a0
;	movi	DUNKR2_SEQ,a0
;	movi	DUNKS_SEQ,a0
;	movi	DUNKS2_SEQ,a0
;	movi	DUNKT_SEQ,a0
;	movi	DUNKT2_SEQ,a0
;	movi	DUNKT3_SEQ,a0
;	movi	DUNKT4_SEQ,a0
;	movi	DUNKT5_SEQ,a0
;	movi	DUNKV_SEQ,a0
;	movi	DUNKV2_SEQ,a0
;	movi	DUNKW_SEQ,a0
;	movi	DUNKW2_SEQ,a0
;	movi	DUNKW3_SEQ,a0
;	movi	DUNKY_SEQ,a0
;	movi	DUNKY2_SEQ,a0
;	movi	DUNKZ_SEQ,a0
;	movi	DUNKZ2_SEQ,a0
;	movi	DUNKZ3_SEQ,a0
;	movi	DUNKLAY7_SEQ,a0
;	movi	DUNKZ5_SEQ,a0
;	movi	DUNKZ4_SEQ,a0
;	movi	DUNKZ6_SEQ,a0
;	movi	DUNKZ7_SEQ,a0
;	movi	DUNKZ8_SEQ,a0
;	movi	DUNKZ9_SEQ,a0
;	movi	DUNKZ10_SEQ,a0
;	movi	DUNKZ11_SEQ,a0
;	movi	DUNKB3_SEQ,a0

;Dunks below here require scroller to pan up higher (Already works)
;	movi	DUNKU_SEQ,a0
;	movi	DUNKU2_SEQ,a0
;	movi	DUNKU3_SEQ,a0
;	movi	DUNKU4_SEQ,a0
;	movi	DUNKU5_SEQ,a0
;	movi	DUNKU6_SEQ,a0
;	movi	DUNKX_SEQ,a0
;	movi	DUNKX2_SEQ,a0
;	movi	DUNKX3_SEQ,a0
;	movi	DUNKLAY2_SEQ,a0
;	movi	DUNKLAY3_SEQ,a0
;	movi	DUNKLAY4_SEQ,a0
;	movi	DUNKLAY5_SEQ,a0
;	movi	DUNKLAY3A_SEQ,a0
;	movi	DUNKLAY_SEQ,a0
;	movi	DUNKLAY6_SEQ,a0


	.if	DEBUG
;Shawn, I'm stuffing the dunk into ram so I can pause the game when someone
;has a problem with a dunk and I can jot down the dunk # and fix it.
	.bss	debug_dunk_num,16
	.ref	slowmotion

	move	a0,@debug_dunk_num
	clr	a1
	move	a1,@slowmotion
	.endif

	move	a0,a2
	CREATE0	start_animate
	cmpi	DUNKX_SEQ,a2
	jreq	#smk
	cmpi	DUNKX2_SEQ,a2
	jreq	#smk
	cmpi	DUNKX3_SEQ,a2
	jrne	#nosmk
#smk	CREATE0	plyr_smoketrail
	move	a13,*a0(PA10),L
#nosmk	move	a2,a0


	movk	2,a14
	move	a14,@ballptsforshot

	move	*a13(plyr_dir),a7
	callr	plyr_setseq		;Dunk!

	move	*a13(plyr_num),a14
	srl	1,a14
	jrz	#x			;Team1?
	movi	M_FLIPH,a14
	move	a14,*a13(plyr_anirevff)
	jruc	#x


;strtsnd	SLEEP	40
;	movi	dnk_snd,a0
;	calla	snd_play1
;	SLEEP	180
;	movi	push1_snd,a0
;	calla	snd_play1
;	DIE
;
;push1_snd	.word	>fd85,15,>8160,0	;Push ugh
;dnk_snd		.word	>fda9,120,>8167,0

dnkthru_t
	.word	0,0,0,0,0,0,0,100,150,250,350


#dist_t	.word	40,43,46,49,50,52,54,56,68,70,72,95
#width_t
	.word	27,29,31,33,36,37,38,39,40,43,45,70

#trylyup
	move	@HCOUNT,a14
	btst	0,a14
	jrnz	#sj
	move	*a13(plyr_ohpdist),a14
	cmpi	138,a14
	jrgt	#sj
	cmpi	35,a14
	jrlt	#sj


	move	a3,*a13(plyr_dir)
	movi	-1,a14
	move	a14,*a13(plyr_newdir)	;Cancel turn
	movk	2,a0
	move	a0,@ballptsforshot

	movk	FINGER_ROLL,a0
	move	a0,@shot_type

	movi	LAYUP_SEQ,a0
	jruc	#sseq

#hs
	movk	2,a4
	move	a4,@ballptsforshot

	movk	HOOK_SHOT,a0
	move	a0,@shot_type

	movk	HOOK_SEQ,a0
	move	*a13(plyr_turbon),a4
	jrnz	#hs1
	movk	HOOK2_SEQ,a0		;Not a high arc


#hs1	move	*a13(plyr_dir),a7
	callr	plyr_setseq

	move	*a13(plyr_num),a14
	srl	1,a14
	jrz	#x			;Team1?
	movi	M_FLIPH,a14
	move	a14,*a13(plyr_anirevff)
	jruc	#x


#sj					;>Start a jump shot seq
	movk	2,a4
	move	*a8(OZPOS),a0
	subi	CZMIN+18,a0
	jrlt	#3ptra
	cmpi	CZMID+178-(CZMIN+18),a0
	jrgt	#3ptra
	srl	2,a0			;/4
	sll	4,a0			;*16
	addi	#3pt_t,a0
	move	*a0,a0
	move	*a8(OXPOS),a2
	move	*a8(OXANI+16),a14
	add	a14,a2
	subi	WRLDMID,a2
	abs	a2
	cmp	a0,a2
	jrgt	#2ptr			;Far from center court?

;3ptr from behind arc
	sub	a2,a0
	cmpi	16h,a0
	jrlt	#3ptrx
	movk	1,a0
	move	a0,@reduce_3ptr	
;	LOCKUP
     	jruc	#3ptrx


;	addi	WRLDMID,a0		;3point DEBUG
;	sub	a14,a0
;	move	a0,*a8(OXPOS)
;#3ptr	clr	a0
;	move	a0,*a13(plyr_nojoy)
;	movk	STNDDRIB_SEQ,a0
;	jruc	#sseq

;3ptr from sideline top or bottom
#3ptra
;	LOCKUP
      	jruc	#3ptrx
;3ptr from way downtown
#3ptr	movk	1,a4
	move	a4,@reduce_3ptr
	move	a1,a1
;	LOCKUP
#3ptrx

	movk	3,a4

	move	*a13(plyr_ohpdist),a0
	cmpi	310,a0			;distance from hoop
	jrle	#nrm_3
	movk	LONG_RANGE,a0
	move	a0,@shot_type
	jruc	#contxy
#nrm_3
	movk	_3_POINTS,a0
	move	a0,@shot_type
	jruc	#contxy
#2ptr
	movk	_2_POINTS,a0
	move	a0,@shot_type
#contxy
	move	a4,@ballptsforshot

	movk	SHOOT_SEQ,a0

	move	*a13(plyr_shtbutn),a14
	jrnz	#notq
	movk	1,a14
	move	a14,*a13(plyr_shtbutn)

	movk	QSHOOT_SEQ,a0
#notq
	jruc	#sseq

#desp
	movi	DESPERATION,a0
	move	a0,@shot_type

	movk	3,a14
	move	a14,@ballptsforshot

;This is a heave grenade toss
;only do it if under 5 seconds in quarter
	movk	SHOOTDESP2_SEQ,a0	;Heave
	move	@game_time,a14,L
	cmpi	>500,a14
	jrlt	#heave			;Do it

	move	@PCNT,a0
	ANDK	1,a0
	sll	1,a0
	addk	SHOOTDESP_SEQ,a0

#heave
	move	*a13(plyr_newdir),a14
	move	a14,*a13(plyr_dir)
	movi	-1,a14
	move	a14,*a13(plyr_newdir)
	jruc	#sseq

#blk
	move	*a13(plyr_rcvpass),a0
	jrgt	#x			;Waiting on pass?

	move	@ballpnum,a14
	jrn	#inair

	sll	5,a14			;*32
	addi	plyrproc_t,a14
	move	*a14,a14,L
	move	*a14(plyr_seqflgs),a0
	btst	SHOOT_B,a0
;	jrz	#faceb			;!Shooting?
	jrnz	#inair

;Slow down drift fr this blocker!

	move	*a8(OXVEL),a0,L
	sra	1,a0
	move	a0,*a8(OXVEL),L
	move	*a8(OYVEL),a0,L
	sra	1,a0
	move	a0,*a8(OYVEL),L
	move	*a8(OZVEL),a0,L
	sra	1,a0
	move	a0,*a8(OZVEL),L

	move	@ballobj_p,a5,L
	move	*a5(OXPOS),a6
	addk	6,a6
	move	*a5(OZPOS),a7
	PUSH	A0
	callr	seekdirdist_obxz128
	move	a0,*a13(plyr_newdir)	;Turn toward ball
	PULL	A0
	btst	DUNK_B,a0
	jrz	#blkd
	movk	7,a0
	calla	rndrng0
	sll	5,a0
	addi	blktype_t,a0
	move	*a0,a0,L
	jruc	#sseq

blktype_t
	.long	BLOCK_SEQ,BLOCK_SEQ,BLOCK_SEQ,BLOCK_SEQ
	.long	REBOUND_SEQ,BLOCKREJ_SEQ
	.long	REBOUND_SEQ,FASTBLOCKREJ_SEQ


#inair	move	@ballobj_p,a5,L

	move	*a5(OYPOS),a1
	cmpi	-20,a1
	jrge	#faceb			;Ball close to gnd?

	move	*a5(OXVAL),a6,L
	move	*a5(OXANI),a14,L
	add	a14,a6
	move	*a5(OZVAL),a7,L

	move	@ballpnum,a14
	jrge	#chkdist		;Other team has ball?

	movk	20,a0
	move	*a5(OXVEL),a1,L
	mpys	a0,a1
	add	a1,a6
	move	*a5(OZVEL),a1,L
	mpys	a0,a1
	add	a1,a7

#chkdist
	sra	16,a6
	sra	16,a7
	callr	seekdirdist_obxz128
	move	a0,*a13(plyr_newdir)	;Turn where ball is headed
	cmpi	120,a1
	jrge	#blkd			;Too far to jump?

	movk	1,a0			;50%
	move	@ballpnum,a1
	jrge	#dornd

	move	@ballgoaltcnt,a14
	jrle	#dorb			;Do rebound?

	movk	1,a0			;50%
#dornd	callr	rnd
	jrnz	#dorej

;MJT
;Weak shot blockers will do swat, not grab!
	move	*a13(plyr_attrib_p),a14,L
	move	*a14(PAT_DEFSKILL),a0
	cmpi	5,a0
	jrlt	#dorej

#dorb	movk	REBOUND_SEQ,a0
	jruc	#sseq
#dorej	movk	BLOCKREJ_SEQ,a0
	jruc	#sseq


#faceb	move	@ballobj_p,a5,L
	move	*a5(OXPOS),a6
	addk	6,a6
	move	*a5(OZPOS),a7
	callr	seekdirdist_obxz128
	move	a0,*a13(plyr_newdir)	;Turn toward ball

#blkd	movk	BLOCK_SEQ,a0


#sseq	move	*a13(plyr_dir),a7
	callr	plyr_setseq


#x	PULL	a6,a7
	rets



********************************

#3pt_t
	.word	193
	.word	187,175,166,158,153,144,138,130
	.word	125,120,115,110,106,102,100,98
	.word	96,94,92,89,86,84,82,80
	.word	80,79,79,79,78,78,78,77
	.word	77,77,77,77,77,77,77,78
	.word	78,79,81,82,83,84,85,86
	.word	87,88,89,90,91,92,94,95
	.word	96,98,100,104,108,113,116,120
	.word	124,129,133,138,141,145,148,153
	.word	157,162,166,175,180,186,191,198
	.word	204,214,230,230


#*******************************
* Player takes a shot (also called by seq)
* A8=*Plyr obj
* A13=*Plyr process
* Trashes scratch, A2-A5

 SUBR	plyr_shoot

	PUSH	a6,a7,a9,a10,a11


	move	*a13(plyr_num),a0
	move	@ballpnum,a1
	cmp	a0,a1
	jrne	#x

;	.ref	do_ball_spark
;
;	move	@GAMSTATE,a0
;	cmpi	INAMODE,a0
;	jrnz	#nofake
;	CREATE0	do_ball_spark
;#nofake


	move	@plyrnumonfire,a14
	cmp	a0,a14
	jrne	#cold
	movi	fball_snd,a0
	calla	snd_play1
#cold

	callr	plyr_setballxyz

	move	*a13(plyr_ohoopx),a6
	movi	CZMID,a7
	callr	seekdirdist_obxz128
	move	a0,a10
	move	a1,a11			;A11=Hoop distance

	move	*a13(plyr_attrib_p),a7,L
	move	*a7(PAT_SHOTSKILL),a9

;	movi	1000,a9			;A9=Base %


	move	@ballptsforshot,a0
	cmpi	3,a0
	jrnz	#oui

	cmpi	1025,a9
	jrgt	#oui
;Stat #0-4 reduce 3-ptrs
	subi	200,a9

#oui

	move	@reduce_3ptr,a0
	jrz	#no3
	subi	15,a9			;150?
#no3
	cmpi	70h,a11
	jrgt	#notshort
;	movi	1150,a9			;A9=Base %
	addi	250,a9
#notshort

	cmpi	>130,a11
	jrlt	#notlong
	subi	990,a9			;680 ;790 ;890
;	LOCKUP
;	movi	10,a9			;1%
#notlong

	move	*a13(plyr_num),a4	;>Get opponents dir/dist
	srl	1,a4
	movk	1,a14
	xor	a14,a4
	sll	6,a4			;*64
	addi	plyrobj_t,a4
	move	*a4+,a0,L
	move	*a0(OYPOS),a3
	callr	seekdirdist_obob128

	cmpi	40,a1			;35
	jrgt	#1far2			;Opponent too far?

	subi	240,a9			;-24%	;10%

#1far2	cmpi	75,a1			;70
	jrgt	#1far			;Opponent too far?

	sub	a10,a0
	abs	a0
	cmpi	>40,a0
	jrle	#1dsml
	subi	>80,a0
	abs	a0
#1dsml	subk	20,a0
	jrge	#1far			;Not between me and hoop?

	sll	2,a1			;*4
	subi	390,a1			;-320 to -40	;320

	move	*a8(OYPOS),a2
	sub	a3,a2
	jrle	#1ihi			;Shooter higher?
	addk	8,a2
	mpys	a2,a1
	sra	3,a1			;/8

#1ihi	add	a1,a9			;Decrease accuracy
#1far

	move	*a4+,a0,L
	callr	seekdirdist_obob128

	cmpi	40,a1
	jrgt	#2far2			;Opponent too far?

	subi	240,a9			;-25%

#2far2	cmpi	75,a1
	jrgt	#2far			;Opponent too far?

	sub	a10,a0
	abs	a0
	cmpi	>40,a0
	jrle	#2dsml
	subi	>80,a0
	abs	a0
#2dsml	subk	20,a0
	jrge	#2far			;Not between me and hoop?

	sll	2,a1			;*4
	subi	390,a1			;-320 to -40	  ;320

	move	*a8(OYPOS),a2
	sub	a3,a2
	jrle	#2ihi			;Shooter higher?
	addk	8,a2
	mpys	a2,a1
	sra	3,a1			;/8

#2ihi	add	a1,a9			;Decrease accuracy
#2far

	move	a11,a14
	sll	1,a14			;*2
	sub	a14,a9
	cmpi	50,a9
	jrge	#accok
	movi	50,a9
#accok
;	CREATE	>6000,plyr_showshotpercent




;If player has thrown up 4 bricks, make next shot go in!

	move	*a13(plyr_num),a0
	sll	4,a0			;x 16
	addi	brick_count,a0
	move	*a0,a1			;brick_count++
	cmpi	3,a1
	jrlt	#nohelping
;	LOCKUP
	movi	990,a9
#nohelping


	move	*a13(plyr_ptsdown),a1	;>Adjust shot %
	move	a1,a2
	movk	20,a0			;20
	mpys	a0,a1
	add	a1,a9			;+/-2% per point difference
	cmpi	50,a9
	jrge	#minok
	movi	50,a9
#minok

*If end of qrtr/game, affect shots like this:
*
* 1. If 4th or overtime qrtr has 5 seconds or less remaining and
*
*	a. If score is already tied or I am ahead, do nothing.
*	b. This shot (2 or 3) would tie the score, then make it go in 75% of
*	   the time.  (Regardless of shot distance)
*	c. This shot (2 or 3) would win the game, then make it go in at
*	   least 30% of the time (Close in would be higher, but even bombs
*	   go in 30%)
*	d. If this shot would pull me to within 1/2 points, then make it go
*	   in 90% of the time for max excitement without putting him ahead.
*
* 2. If 1/2/3rd qrtr has 5 seconds or less remaining and
*
*	a. If score is already tied or I am ahead, do nothing.
*	b. This shot (2 or 3) would tie the score, then make it go in 40% of
*	   the time at least.  (Regardless of shot distance)
*	c. If this shot would pull me to within or ahead by 1/2 points, then
*	   make it go in 50% of the time for max excitement)
*	d. If I am losing by a larger margin than 4, then make it go in at
*	   least 60%.  (Regardless of shot distance)


;MJT
	movi	55,a0			;80
	calla	RNDPER
	jrls	nomis
	move	*a13(plyr_ptsdown),a1	;>Adjust shot %
	jrgt	nomis
	movi	150,a9
nomis
	move	@game_time,a1,L
	cmpi	>400,a1
	jrgt	#nohelp

	move	a2,a0
	jrnz	#tryh

;Game tied in 4th quarter
	move	@gmqrtr,a1
	subk	3,a1
	jrlt	#nohelp
	movi	50,a9			;Last second shot of a tie game
					;should not go in at the game buzzer
	jruc	#nohelp			;Not if tied

#tryh	jrgt	#tryhelp
	cmpi	-5,a0
	jrgt	#nohelp			;Winning by less than 5

	move	@gmqrtr,a1
	subk	3,a1
	jrlt	#nohelp

;I'm winning big, if end of game, allow shot to go in.

	move	@game_time,a1,L
	cmpi	>200,a1
	jrgt	#losingbige

	jruc	#willtie

#tryhelp
;	move	@game_time,a1,L
;	cmpi	>200,a1
;	jrgt	#nobuzz
;
;#nobuzz


	move	a2,a0

	move	@ballptsforshot,a14
	move	@gmqrtr,a1
	subk	3,a1
	jrge	#endg			;End game help?

	subk	5,a0
	jrgt	#losingbig

	cmp	a2,a14
	jreq	#willtie		;This shot would tie up score!

	movi	100,a3			;Losing by 1-5
	jruc	#chkper
#losingbig
	movi	120,a3			;Losing by more than 5 points
	jruc	#chkper
#willtie
	movi	120,a3			;This will tie game
	jruc	#chkper

#endg
	subk	4,a0
	jrge	#losingbige

	cmp	a2,a14
	jrz	#willtiee		;This shot would tie up score!

;Drone team trying to win at buzzer?
	move	*a13(plyr_num),a14
	move	@PSTATUS,a0
	btst	a14,a0
	jrnz	#okok
	XORK	1,a14
	btst	a14,a0
	jrnz	#okok
;Drone+Drone trying to win the game!
	movi	100,a3			;This will tie game at end
	jruc	#chkper
#okok


	movi	380,a3			;Losing by 1-5
	jruc	#chkper
#losingbige				;Losing by more than 5 points
	movi	300,a3
	jruc	#chkper
#willtiee
	movi	800,a3			;This will tie game at end

#chkper	cmp	a3,a9
	jrge	#nohelp
	move	a3,a9
#nohelp

	
;	movi	950,a9

	move	@ballobj_p,a7,L		;A7=*Ball obj
	move	*a7(OPLINK),a0,L
	move	*a0(ball_onfire),a14
	jrz	#nofire

	addi	750,a9			;Player is on fire!

	cmpi	>148,a11
	jrlt	#nofire

	movi	100,a9			;Player is on fire!

#nofire

	move	*a7(OIMG),a3,L		;>Convert ball from player relative
	move	*a3(IANIOFFX),a3
	sll	16,a3
	move	*a7(OXANI),a14,L
	move	a3,*a7(OXANI),L
	sub	a14,a3			;Ani difference

	sra	16-5,a3
	move	*a7(OZPOS),a14		;894 to 1379 (Z range 486)
	addi	(819-GZBASE),a14	;768 to ?
	mpys	a14,a3
	move	a3,a14
	sra	2,a14			;/4
	sub	a14,a3
	sra	1,a14			;/2
	sub	a14,a3
	sll	16-(14+1),a3		;*64k /16k /2


	move	*a13(plyr_seq),a0	;>Adjust pos for desp shots
	cmpi	DUNKLAY5_SEQ,a0
	jrnz	#ck2
	movi	[-10,0],a3
	movi	[7,0],a14
	addi	760,a9			;720
	jruc	#fixperc
#ck2
	cmpi	DUNKLAY4_SEQ,a0
	jrnz	#ck3
	movi	[-1,0],a3
	movi	[-1,0],a14
	addi	760,a9
	jruc	#fixperc
#ck3
	cmpi	DUNKLAY3_SEQ,a0
	jrnz	#ck4
	movi	[-10,0],a3
	movi	[10,0],a14
	addi	760,a9
	jruc	#fixperc
#ck4
;	cmpi	DUNKLAY2_SEQ,a0
;	jrnz	#ck5
;	movi	[-10,0],a3
;	movi	[10,0],a14
;	addi	690,a9
;	jruc	#fixperc
;#ck5

	cmpi	DUNKLAY2_SEQ,a0
	jrnz	#ck6
	movi	[10,0],a3
	addi	760,a9

	move	*a13(plyr_num),a14
	cmpi	2,a14
	jrlt	#ok1
	movi	[-8,0],a3
	jruc	#ok1

#ck6
	cmpi	DUNKLAY3A_SEQ,a0
	jrnz	#ck6a
	movi	[-10,0],a3
	movi	[5,0],a14
	addi	760,a9
	jruc	#fixperc
#ck6a
	cmpi	DUNKLAY6_SEQ,a0
	jrnz	#ck7
	movi	[15,0],a3
	addi	760,a9
	move	*a13(plyr_num),a14
	cmpi	2,a14
	jrge	#ok1
	movi	[-15,0],a3
	jruc	#ok1

#fixperc
	move	*a13(plyr_seqdir),a0
	cmpi	5,a0
	jrge	#ok1
	move	a14,a3
#ok1
;MJT
;Block layups more readily
;	movi	690,a0

	movi	750,a0			;700
	calla	RNDPER
	jrhi	#fixde

;Don't allow layup to be blocked!

	movi	TSEC*2-20,a0
	callr	plyr_setshtdly		;Don't block layups!
	jruc	#fixde

#ck7
	cmpi	LAYUPREB_SEQ,a0
	jreq	#ly			;Layup?
	cmpi	DUNKLAY_SEQ,a0
	jreq	#ly			;Layup?
	cmpi	LAYUP_SEQ,a0		;Put back layup
	jrne	#noly0
#ly
	callr	lay_perc

	move	*a13(plyr_seqdir),a0
	sll	5,a0
	addi	adjst_t,a0
	move	*a0,a3,L

;	move	*a7(OYPOS),a5
;	subk	1,a5
;	movi	[-8,0],a3
;	move	a5,*a7(OYPOS)

	jruc	#fixde

adjst_t	.long	0,[7,0],[11,0],[6,0],[0,0],[-8,0],[-8,0],[-8,0]
lay_perc
;	movi	890,a9			;Make those layups go in...
	movi	870,a9			;800

	move	*a13(plyr_ptsdown),a1	;>Adjust shot %
	jrgt	#noms

;fix
;	jruc	#noms

	movi	100,a0
	calla	RNDPER
	jrls	#noms
	movi	450,a9			;250
#noms
;	movi	600,a0			;450
	movi	700,a0			;650
	calla	RNDPER
	jrhi	#xx
	
	movi	TSEC*2,a0
	callr	plyr_setshtdly		;Don't block layups!
#xx	rets

#noly0
	move	*a13(plyr_seqflgs),a14	;>Adjust pos for desp shots
	btst	LAYUP_B,a14
	jrz	#noly
;Funky new layups
	callr	lay_perc
	jruc	#fixde

#noly
	cmpi	HOOK_SEQ,a0
	jreq	#extra
	cmpi	HOOK2_SEQ,a0
	jrne	#noextra
#extra

	movi	600,a9			;750

	PUSH	a0
	movi	120,a0
	calla	RNDPER
	jrls	#noms1
	movi	250,a9
#noms1
	PULL	a0

#noextra

	subk	SHOOTDESP_SEQ,a0
	jrne	#fixd2
	move	*a7(OYPOS),a5
	subk	8,a5
	jruc	#fixdy

#fixd2	subk	1,a0			;SHOOTDESP2_SEQ
	jrne	#fixd3
	clr	a3
	move	*a7(OYPOS),a5
	subk	4,a5
	jruc	#fixdy

#fixd3	subk	1,a0			;SHOOTDESP3_SEQ
	jrne	#fixde
	sra	1,a3
	move	*a7(OYPOS),a5
	subk	2,a5

#fixdy	move	a5,*a7(OYPOS)
#fixde

	move	*a7(OXVAL),a14,L	;Adjust X
	sub	a3,a14
	move	a14,*a7(OXVAL),L

	move	a10,a3
	move	a11,a1
	sll	32-6,a3
	srl	32-6,a3
	subk	>20,a3
	abs	a3			;0-32

	move	*a13(plyr_ohpdist),a14	;distance from hoop
	move	a14,@shot_distance
	movk	1,a14
	move	a14,@shot_percentage	;start at 100%

;Put this on a secret button combo
	move	@show_shot,a14
	.ref	show_shot
	jrz	#nosp
	PUSH	a1,a7
	CREATE	>6000,plyr_showshotpercent
	PULL	a1,a7
#nosp

	movk	1,a10			;A10=At hoop

	PUSH	a1
	movi	16,a0
	calla	RNDPER
	jrls	#noflat0
	clr	a10
#noflat0
	move	*a13(plyr_seqflgs),a14
	btst	LAYUP_B,a14
	jrz	#noflat
;Maybe give ball a flat arc!
	movi	100,a0
	calla	RNDPER
	jrls	#noflat
	clr	a10

#noflat
	PULL	a1


;	jruc	#miss			;DEBUG
;	jruc	#good			;DEBUG

	subk	24,a3
	jrge	#athoop			;At bad backboard angle?

	cmpi	100,a1
	jrgt	#longshot		;Too far for bank?

;	jruc	#offbb			;DEBUG


;	movk	2,a0
;	move	*a13(plyr_seqflgs),a14
;	btst	LAYUP_B,a14
;	jrnz	#fmfront

	move	*a13(plyr_seq),a14
	cmpi	DUNKLAY5_SEQ,a14
	jrz	#offbb



	movk	4,a0			;20%
	addk	24-16,a3
	jrlt	#fmfront
	movk	3,a0			;25%
#fmfront
	callr	rndrng0
	move	a0,a0
	jrnz	#athoop

#offbb					;>Close bank shot

	move	@plyrnumonfire,a0
	jrnn	#athoop			;cont

;;Someone is on fire - do not allow bank shots if it is opposition!
;	move	*a13(plyr_num),a14
;	cmp	a0,a14
;	jrz	#cont
;	XORK	1,a0
;	cmp	a0,a14
;	jrnz	#athoop

#cont

	clr	a10

	move	*a7(OZPOS),a0
	subi	CZMID,a0		;Z delta
	move	a0,a3
	sll	8,a3

	move	*a13(plyr_ohoopx),a1
	move	*a7(OXPOS),a14
	sub	a14,a1
	move	*a7(OXANI+16),a14
	sub	a14,a1			;X delta
	abs	a1
	sll	8+2,a1
	abs	a0
	jrz	#nodiv			;Same Z?
	divu	a0,a1
#nodiv
	addi	512,a1			;2
	divs	a1,a3
	move	a3,a2			;Z

	movi	999,a0
	callr	rndrng0
	cmp	a0,a9
	jrgt	#bgood

;	movk	14,a0			;Miss
;	callr	rndrng0
;	subk	7,a0
;	move	a0,a2			;Z

#bgood
	movi	-10,a0			;X
	movi	-18,a1			;Y
	jruc	#calcshot

#longshot
	movk	3,a0
	callr	rnd
	jrnz	#athoop			;75%?

	movi	999,a0			;>Long bank shot
	callr	rndrng0
	cmp	a0,a9
	jrle	#miss

	movi	-10,a0			;X
	movi	-30,a1			;Y
	clr	a2			;Z
	addk	24-16,a3
	jrlt	#calcshot		;In front of board?
	jruc	#good			;Do good shot at hoop

#athoop
	cmpi	55,a9			;25
	jrge	#notlng
	cmpi	>148,a11
	jrlt	#notlng

	movi	120,a0			;250
	calla	RNDPER
	jrls	#noairb
	jruc	#airok
#notlng
	movk	>1f,a0			;3%
	cmpi	55,a11
	jrge	#chkairb		;Not a close shot?
	movi	>7f,a0			;1.5%
#chkairb
	callr	rnd
	jrnz	#noairb			;No air ball?

	move	*a13(plyr_ptsdown),a0
	subk	2,a0
	jrge	#noairb			;Losing by 2 or more? No airball

	move	@plyrnumonfire,a14
	jrnn	#noairb

;	move	*a13(plyr_num),a0
;	move	@plyrnumonfire,a14
;	cmp	a0,a14
;	jrz	#noairb

	move	*a13(plyr_o1dist),a14	;Totally open shot?
	cmpi	50,a14
	jrlt	#airok
	move	*a13(plyr_o2dist),a14
	cmpi	50,a14
	jrgt	#noairb
#airok

	movi	-1,a0
	move	a0,@plyrairballoff

	move	a7,a2
	CREATE0	plyr_airballsnd
	movi	-1,a0
	move	a0,@shot_percentage	;miss
	move	a2,a7

	movk	20,a2			;>Air ball ;18
	movk	1,a0
	callr	rnd
	jrnz	#airf
	neg	a2			;-Z
#airf

	clr	a0			;X
	clr	a1			;Y

;	movi	-40,a0
;	movi	-30,a1			;Y
	jruc	#calcshot


#noairb
	movi	999,a0			;>Shoot at hoop
	callr	rndrng0
	cmp	a0,a9
	jrgt	#good

#miss
	clr	a0
	move	a0,@shot_percentage	;miss

	movk	>1f,a0			;Miss
	callr	rnd
	sll	4,a0
	addi	#misszx_t,a0
	move	*a0,a5
	move	*a0(8*16),a3

	movk	1,a0			;50%
	callr	rnd
	jrnz	#miss2

	movk	2,a0			;More towards rim edge
	callr	rndrng0
	addk	7,a0
	jruc	#miss3
#miss2
	movk	3,a0			;Regular miss (they go in a fair amount)
	callr	rnd
	addk	6,a0
#miss3
	mpys	a0,a3
	mpys	a0,a5
	move	a3,a0
	move	a5,a2
	sra	12,a0			;X
	sra	12,a2			;Z

	jruc	#cyo


#good	movk	4,a0			;Hit
	callr	rndrng0
	subk	2,a0
	move	a0,a2			;Z

	movk	4,a0
	callr	rndrng0
	subk	2,a0			;X

#cyo
	movi	-3,a1			;Y



#calcshot
	move	*a13(plyr_ohoopx),a3
	cmpi	WRLDMID,a3
	jrlt	#lhoop
	neg	a0
#lhoop	add	a0,a3			;Add X offset
	move	*a7(OXPOS),a14
	sub	a14,a3
	move	*a7(OXANI+16),a14
	sub	a14,a3			;X delta

	movi	CZMID,a5
	add	a2,a5
	move	*a7(OZPOS),a14
	sub	a14,a5			;Z delta

	move	a1,a2

	move	a3,a4			;>Calc distance (long+short/2.667)
	move	a5,a14
	abs	a4
	abs	a14
	cmp	a14,a4
	jrhs	#xbig
	SWAP	a14,a4
#xbig	sra	1,a14			;/2
	add	a14,a4
	sra	2,a14			;/8
	sub	a14,a4

	cmpi	170,a4
	jrls	#distok
	move	a4,a14			;>Reduce excess
	movi	170,a4
	sub	a4,a14
	sra	3,a14			;/8
	add	a14,a4
#distok
	move	a4,a1
	movi	110,a14			;120
	mpys	a14,a1
	move	a1,a4
	sra	8,a4			;/256

	move	a10,a10
	jrnz	#athp			;At hoop?
	move	a4,a1			;Time*.75
	sra	2,a1
	sub	a1,a4
	cmpi	35,a4
	jrge	#divok
	movi	35,a4
	jruc	#divok
#athp
	cmpi	50,a4
	jrge	#divok
	movi	50,a4			;Min
#divok

	move	*a13(plyr_seq),a1
;	move	*a13(plyr_seqflgs),a14
;	btst	LAYUP_B,a14
;	jrz	#hkck
;
;	jruc	#hkck
;
;	addk	2,a4			;8
;	move	@HCOUNT,a14
;	btst	0,a14
;	jrz	#hko
;	subk	10,a4
;	jruc	#hko
;
;#hkck
	cmpi	HOOK_SEQ,a1
	jrnz	#hky
	addk	15,a4			;Make hook shot go a bit higher
	jruc	#hko
#hky
	cmpi	HOOK2_SEQ,a1
	jrnz	#hko
	subk	10,a4
#hko




;MJT 12/15/93
	addk	2,a4
	movi	10,a0
	calla	RNDPER
	jrls	#regshot
;Try a rainbow!
	move	@shot_distance,a0
	cmpi	>104,a0
	jrgt	#regshot
	addk	20,a4

	movi	rainbow_snd,a0
	calla	snd_play1ovr

#regshot


	sll	16,a3
	sll	16,a5
	divs	a4,a3
	divs	a4,a5

;	move	*a8(OXVEL),a1,L
;	sra	3,a1			;/8
;	add	a1,a3



	move	@plyrairballoff,a0
	jrnn	#nobrick
	clr	a0
	move	a0,@plyrairballoff

	clr	a0
	move	a0,@ballgoaltcnt

	move	a3,a0
	sra	2,a0
	sub	a0,a3
;	move	*a13(plyr_num),a14
;	cmpi	2,a14
;	jrge	#nobrick
;	add	a0,a3
;	add	a0,a3
#nobrick

	move	a3,*a7(OXVEL),L




;	move	*a8(OZVEL),a1,L
;	sra	3,a1			;/8
;	add	a1,a5
	move	a5,*a7(OZVEL),L

	movi	-GRAVB/2,a1
	mpys	a4,a1
	move	*a7(OYVAL),a3,L		;Adjust for hgt difference
	addi	HOOPY-8,a2
	sll	16,a2
	sub	a2,a3			;- if above
	divs	a4,a3
	sub	a3,a1

	move	a1,*a7(OYVEL),L

	addk	2,a4
;	subk	1,a4			;Allows goaltend of airballs

	move	a4,@ballgoaltcnt

	move	*a13(plyr_num),a1	;A1=Plyr #
	move	a1,@ballpnumshot
	move	a1,@ballpnumlast
	move	a1,@ballsclastp

	movi	-1,a0
	move	a0,@ballpnum		;No owner
	clr	a0
	move	a0,@ballscorezhit

	move	a0,@ballrimhitcnt
	move	a0,@ballbbhitcnt

	move	a0,*a13(plyr_ownball)
	move	a0,@plyrcharge
	movi	50,a0			;40
	move	a0,*a13(plyr_shtdly)
					;>Inc try shot stat

	move	*a13(plyr_seqflgs),a0
	btst	LAYUP_B,a0
	jrnz	#x

	movi	PS_2PTS_TRY,a0
	move	@ballptsforshot,a14
	subk	2,a14
	jreq	#2ptr
	movk	PS_3PTS_TRY,a0
#2ptr	calla	inc_player_stat

#x
	move	*a13(plyr_num),a0	;Plyr # shooting
	calla	shoots_speech

	PULL	a6,a7,a9,a10,a11
	rets
;
;	movi	PS_2PTS_TRY,a0
;	calla	dec_player_stat

#misszx_t
	.word	-4096,-4017,-3784,-3406,-2896,-2275,-1567,-799
	.word	0,799,1567,2275,2896,3406,3784,4017
	.word	4096,4017,3784,3406,2896,2275,1567,799
	.word	0,-799,-1567,-2275,-2896,-3406,-3784,-4017
	.word	-4096,-4017,-3784,-3406,-2896,-2275,-1567,-799


;	.if	0

#*******************************
* Show shot percentage (process)
* A9=Percent (0-1000)

 SUBRP	plyr_showshotpercent

	move	a11,*a13(PDATA),L

	movk	10,a1
	divu	a1,a9

	cmpi	99,a9
	jrls	#maxok
	movi	99,a9
#maxok
	clr	a8
	divu	a1,a8
	sll	5,a8
	addi	#f_t,a8
	move	*a8,a2,L
	movi	[191,0],a0
	movi	[11,0],a1
	movi	950,a3			;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,a10

	sll	5,a9
	addi	#f_t,a9
	move	*a9,a2,L
	movi	[196,0],a0
	movi	[11,0],a1
	movi	950,a3			;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2


	PUSHP	a8
	movi	crplate2,a0		;>Change credit plate
	move	@crplate_ptr,a8,L
	move	*a8(OCTRL),a1
	calla	obj_aniq

	SLEEP	TSEC*2

	movi	crplate,a0
	move	*a8(OCTRL),a1
	calla	obj_aniq
	PULLP	a8

	.if	DEBUG
	move	*a13(PDATA),a0,L
	cmp	a0,a11
	jrz	#db
	LOCKUP
#db
	.endif

	move	a10,a0
	calla	DELOBJ
	jauc	DELOBJDIE


#f_t
	.long	font60,font61,font62,font63,font64
	.long	font65,font66,font67,font68,font69

;	.endif

#*******************************
* Make sound for airball (process)

 SUBRP	plyr_airballsnd

	SLEEP	65

	move	@plyrairballoff,a0
	jrnz	#x

	movi	airball_snd,a0
	calla	snd_play1
	SLEEP	90
	movi	airball_snd,a0
	calla	snd_play1
#x	DIE




#*******************************
* Start player pass to teammate
* A8=*Plyr obj
* A13=*Plyr process
* Trashes scratch, A2-A5

 SUBRP	plyr_startpass

	PUSH	a6,a7

	move	*a13(plyr_tmproc_p),a4,L
	move	*a4(plyr_jmpcnt),a0
	jrnz	#x			;Teammate in air?

	move	*a13(plyr_keeppal),a0
	jrz	#no
	calla	seq_stopfire
#no

	move	*a13(plyr_num),a1
	inc	a1
	move	a1,@assist_plyr
	movi	3*60+30,a0
	move	a0,@assist_delay

;	move	@PSTATUS,a0		;Plyr start bits 0-3
;	move	*a13(plyr_num),a1
;	btst	a1,a0
;	jrnz	#human
;	XORK	1,a1
;	btst	a1,a0
;	jrz	#human			;Drone passing to a drone?
;
;	move	*a13(plyr_idiotbit),a0
;	btst	0,a0
;	jrnz	#human
;	addk	1,a0
;	move	a0,*a13(plyr_idiotbit)
;
;	move	@inbound,a0		;Inbounding team (0-1) or Neg
;	jrnn	#human
;
;	movk	5,a0
;	calla	idiot_box		;This plyr is telling drone to pass ball
;#human


	move	a10,a2
	move	a4,a10
	calla	arw_on1plyr		;Guy who picks up ball gets arw
	move	a2,a10
	move	a4,@ballprcv_p,L

	move	*a4(PA8),a2,L		;Get teammates obj
	move	*a2(OXPOS),a6
	move	*a2(OXANI+16),a14
	add	a14,a6
	move	*a2(OZPOS),a7


;Try to do a no look pass

;If passer is facing 0,1,2 and teammate is located in the angle 2
;then we can use the T2NLPR pass.
;
; OR
;
;If passer is facing 6,7 and teammate is located in the angle 6
;then we can use the T2NLPR pass.
;
; OR
;
;If passer is facing 0,1,2 and teammate is located in the angle 7
;then we can use the T2NLPL pass.
;
; OR
;
;If passer is facing 6,7 and teammate is located in the angle 0
;then we can use the T2NLPL pass.


	move	@inbound,a0
	jrnn	#notnl4			;Inbounding the ball?

	movk	7,a0			;>Try no look pass
	callr	rnd
	jrnz	#notnl4

	move	*a13(plyr_jmpcnt),a14
	jrnz	#notnl4			;In air?

	move	*a13(plyr_tmdist),a14
	cmpi	70,a14
	jrlt	#notnl4			;Too short?
	subi	320,a14
	jrgt	#notnl4			;Too far?

	callr	seekdirdist_obxz128
	move	a1,a2

	move	a0,a14
	addi	>40,a14
	sll	32-7,a14
	srl	32-7,a14

	addk	8,a0			;Round off
	sll	32-7,a0
	srl	32-7+4,a0		;Kill frac

	move	*a13(plyr_seqdir),a1
	cmpi	3,a1
	jrlt	#dir2n
	cmpi	6,a1
	jrlt	#notnl
	cmpi	6,a0
	jrz	#donl
	cmpi	1,a0
	jrz	#dir3
;	cmpi	7,a0
;	jrz	#dir3
	jruc	#notnl

#dir2n	cmpi	2,a0
	jrz	#donl
	cmpi	7,a0
	jrnz	#notnl
#dir3	movi	PASSNL2_SEQ,a0
	jruc	#don1

#donl
	movi	PASSNL_SEQ,a0
#don1	move	a14,*a4(plyr_newdir)
	move	*a13(plyr_dir),a7
	jruc	#bhpas


#notnl
;If passer is facing 2,3,4 and teammate is located in the angle 5
;then we can use the T4NLPR pass.
;
; OR
;
;If passer is facing 5,6 and teammate is located in the angle 5
;then we can use the T4NLPR pass.
;
; OR
;
;If passer is facing 2,3,4 and teammate is located in the angle 2
;then we can use the T4NLPL pass.
;
; OR
;
;If passer is facing 5,6 and teammate is located in the angle 6
;then we can use the T4NLPL pass.

	cmpi	2,a1
	jrlt	#notnl4
	cmpi	5,a1
	jrlt	#dir2n4

	cmpi	7,a1
	jrz	#notnl4

;	cmpi	3,a0		
;	jrz	#donl4
	cmpi	6,a0
	jrz	#dir34
	jruc	#notnl4

#dir2n4	cmpi	5,a0
	jrz	#donl4a
	cmpi	2,a0
	jrnz	#notnl4
#dir34	movi	PASSNL2_SEQ,a0
	jruc	#don14

#donl4
	movi	PASSNL_SEQ,a0
#don14	move	a14,*a4(plyr_newdir)
	move	*a13(plyr_dir),a7
	jruc	#bhpas
#donl4a
	movi	PASSNL3_SEQ,a0
	jruc	#don14

#notnl4



 	movi	350,a0
	calla	RNDPER
	jrls	#notbh

;	movk	2,a0			;>Try behind the back pass
;	callr	rnd
;	jrnz	#notbh

	move	*a13(plyr_jmpcnt),a14
	jrnz	#notbh			;In air?

	move	*a13(plyr_tmdist),a14
	cmpi	90,a14
	jrlt	#notbh			;Too short?
	subi	360,a14
	jrgt	#notbh			;Too far?

	move	*a13(plyr_attrib_p),a14,L
	move	*a14(PAT_PASS),a14
	cmpi	5,a14
	jrlt	#notbh

	move	*a13(plyr_o1dist),a1
 	cmpi	>78,a1
	jrlt	#notbh
	move	*a13(plyr_o2dist),a1
	cmpi	>78,a1
	jrlt	#notbh
 
;Want to stop ball from being inbounded using the BHPASS

	move	@inbound,a0
	jrn	#bhcont			;Inbounding the ball?

;I'm ahead, maybe still do cocky inbound

	move	*a13(plyr_ptsdown),a1
	jrgt	#notbh			;If losing, don't bhpass
	addk	6,a1
	jrge	#notbh			;If ahead by 7 or more, allow attempt
#bhcont
 
;Check to see is teammate is in an ok position to receive a behind the back
;pass based on what direction pass is facing and teammate is located.
;
;If passer is facing 2,3,4 and teammate is in 1 or 2 then do it, or if passer 
;is facing 5,6 and teammate is located in the angles 6 or 7 then we can also
;use the T4HIND pass.
;
;If passer is facing 0,1 and teammate is in 2 or 3 then do it,
;or if passer is facing 7 and teammate is located in the angles 5 or 6
;then we can also use the T2HIND pass.


	callr	seekdirdist_obxz128
	move	a1,a2

	move	a0,a14
	addi	>40,a14
	sll	32-7,a14
	srl	32-7,a14

	addk	8,a0			;Round off
	sll	32-7,a0
	srl	32-7+4,a0		;Kill frac

	move	*a13(plyr_seqdir),a1
	cmpi	2,a1
	jrlt	#dir2
	cmpi	7,a1
	jrz	#dir2
					;4 direction possibility
	subk	5,a1
	jrge	#flp4
	move	a0,a0			;Unflipped 4
	jrz	#notbh			;Not in 0 direction
	subk	3,a0
	jrge	#notbh
	jruc	#dobh2
#flp4
	subk	6,a0
	jrlt	#notbh
	jruc	#dobh2

#dir2					;2 direction possibility
	subk	7,a1
	jreq	#flp2
	subk	2,a0
	jreq	#dobh2
	subk	3-2,a0
	jrne	#notbh
#dobh2

;RJR
;behind back pass speech here

	movi	PASSBH_SEQ,a0		;Will do a #2 behind the back pass
	move	a14,*a4(plyr_newdir)
	move	*a13(plyr_dir),a7
	jruc	#bhpas

#flp2	subk	5,a0
	jreq	#dobh2
	subk	6-5,a0
	jreq	#dobh2


#notbh


	callr	seekdirdist_obxz128	;>Turn toward teammate
	move	a0,*a13(plyr_dir)

	move	a0,*a13(plyr_newdir)

	move	a0,a7
	move	a0,a3

	addi	>40,a0
	sll	32-7,a0
	srl	32-7,a0
	move	a0,*a4(plyr_newdir)
	move	a1,a2




	movi	PASSDO_SEQ,a0

	move	*a13(plyr_jmpcnt),a14
	jrz	#contpass


;MJT
;Fix dunks attempted stat

	move	*a13(plyr_seqflgs),a14
	btst	DUNK_B,a14
	jrz	#nodnk

	PUSH	a0

	movk	PS_DUNKS_TRY,a0		;>Dec dunk stats
	move	*a13(plyr_num),a1
	.ref	dec_player_stat
	calla	dec_player_stat
	movi	PS_2PTS_TRY,a0
	move	*a13(plyr_num),a1
	calla	dec_player_stat

	PULL	a0

#nodnk


	move	*a13(plyr_tmdist),a14
	cmpi	110,a14
	jrgt	#ss
	movi	PASSDO2_SEQ,a0
	jrnz	#ss			;Air dish off pass?
#contpass

	movk	PASSS_SEQ,a0
	cmpi	170,a2			;50
	jrle	#ss

;If a good passer...

	movi	PASSC_SEQ,a3

;MJT
	move	*a13(plyr_attrib_p),a14,L
	move	*a14(PAT_PASS),a5
	cmpi	6,a5
	jrlt	#normp
	movi	FASTPASSC_SEQ,a3
#normp
	movk	7,a0
	callr	rnd
	jrnz	#normchest		;12% regular chest?
	movi	PASSNEWOH_SEQ,a3
	cmpi	6,a5
	jrlt	#normchest
	movi	FASTPASSNEWOH_SEQ,a3
#normchest
	move	a3,a0

#ss
#bhpas
	move	a0,a3
	callr	plyr_setseq

;	subk	PASSOH_SEQ,a3
;	jreq	#nolead

	cmpi	PASSNL_SEQ,a3
	jrz	#lead_nl
	cmpi	PASSNL2_SEQ,a3
	jrnz	#noleadnl

#lead_nl
;Try a leading pass even on a no look pass
	move	*a4(plyr_dirtime),a1
	jrz	#nolead_nl
	subk	10,a1
	jrlt	#nolead_nl

#noleadnl

;	cmpi	35,a2
;	jrlt	#nolead			;Too close?

	move	*a4(plyr_dirtime),a1
	jrz	#nolead_notm

;Shawn, I increased this because we were getting to many missed leading
;passes.  Because the receiver would bump into a defender and get thrown
;off course. 

	subk	8,a1			;4
	jrgt	#leadingpass

	move	*a4(plyr_o1dist),a0
;MJT
	cmpi	25,a0
;	cmpi	35,a0
	jrlt	#nolead_ocls		;Opponent too close?
	move	*a4(plyr_o2dist),a0
	cmpi	25,a0
;	cmpi	35,a0
	jrge	#leadingpass


;Additional checks are required here to determine if this will cause the
;leading pass to fly off scrn and cause the receiver to become stuck
;against the glass wall.

;MJT
	cmpi	30,a2			;40
	jrlt	#nolead_tm		;Too close?
	move	*a4(plyr_dirtime),a1
	subk	4,a1
	jrgt	#leadingpass


#nolead_notm
;	LOCKUP				;Not running long enough
	move	@PCNT,a0
;MJT
	ANDK	1,a0
;	ANDK	3,a0
	jrnz	#nolead
	jruc	#leadingpass

#nolead_nl
;	LOCKUP				;A no look pass
	jruc	#nolead

#nolead_ocls
;	LOCKUP				;Opponent too close
	jruc	#nolead

#nolead_tm
;	LOCKUP				;Teammate too close


#nolead
	movk	1,a0
	move	a0,*a4(plyr_nojoy)

	jruc	#end


#leadingpass
	move	*a4(plyr_jmpcnt),a1
	jrnz	#nolead			;He's jumping?


;Disallow leading behind the back pass if using #4 or #2 behind back pass art
;and teammate is running toward passer
;At the moment, receiver must be running horizontally away from me!  (2 or 6)

	move	@PCNT,a14
	ANDK	3,a14
;	btst	0,a14
	jrnz	#notst

	cmpi	PASSBH_SEQ,a3
	jrne	#notst
	move	*a13(plyr_seqdir),a1
	move	*a4(plyr_seqdir),a0
	cmpi	5,a1
	jrge	#ck1
	cmpi	2,a0
	jrz	#bhin
	jruc	#nolead
#ck1	cmpi	6,a0
	jrne	#nolead
	jruc	#bhin
#notst		

;Will be a leading pass, rotate passer so that pass will go to where
;receiver will be when he receives the pass


	move	*a13(plyr_tmproc_p),a4,L
	move	*a4(PA8),a2,L		;Get teammates obj
	move	*a2(OXPOS),a6
	move	*a2(OXANI+16),a14
	add	a14,a6
	move	*a2(OZPOS),a7

	move	*a2(OXVEL),a0,L		;Where will teammate be in 32 ticks?
	sra	16-5,a0
	add	a0,a6
	move	*a2(OZVEL),a0,L
	sra	16-5,a0
	add	a0,a7

;FIX!!!
	callr	seekdirdist_obxz128	;>Turn toward where teammate will be
	move	a0,*a13(plyr_dir)
	move	a0,*a13(plyr_newdir)


#bhin
	move	*a4(PA11),a0,L		;>Keep teammate moving in same dir
	move	*a0,a0
	sll	32-4,a0
	srl	32-4,a0
	ori	>8000,a0
	move	a0,*a4(plyr_nojoy)	;Neg
	move	a0,*a4(plyr_newdir)

#end
	movk	30,a0
	move	a0,*a4(plyr_rcvpass)

	move	*a4(plyr_seqflgs),a0
	btst	SAMEDIR_B,a0
	jrz	#x
	movi	-1,a0
	move	a0,*a4(plyr_newdir)	;Kill dir change


#x	PULL	a6,a7
	rets



#*******************************
* Player passes to teammate (called from seq)
* A8=*Plyr obj
* A13=*Plyr process
* Trashes scratch, A2-A5

 SUBR	plyr_pass

	PUSH	a6

	move	@ballpnum,a0
	move	*a13(plyr_num),a1
	cmp	a0,a1
	jrne	#x			;I don't have ball?


	calla	ball_convfmprel

	move	@ballobj_p,a0,L

	move	*a13(plyr_tmproc_p),a6,L
	move	*a6(PA8),a2,L		;Get * teammates obj

	move	*a2(OXPOS),a3
	move	*a2(OXANI+16),a14
	add	a14,a3
	move	*a2(OZPOS),a5

	move	*a0(OXPOS),a1
	move	*a0(OXANI+16),a14
	add	a14,a1
	sub	a1,a3			;X delta
	move	*a0(OZPOS),a1
	sub	a1,a5			;Y delta

	move	a3,a4			;>Calc distance (long+short/2.667)
	move	a5,a14
	abs	a4
	abs	a14
	cmp	a14,a4
	jrhs	#xbig
	SWAP	a14,a4
#xbig	sra	1,a14			;/2
	add	a14,a4
	sra	2,a14			;/8
	sub	a14,a4


	PUSH	a0

	move	@inbound,a0
	jrnn	#no_speech

	cmpi	100,a4			;too close to call
	jrlt	#no_speech

	move	*a13(plyr_num),a1
	calla	pass_to_speech

#no_speech
	PULL	a0

;MJT
	move	*a13(plyr_attrib_p),a14,L
	move	*a14(PAT_PASS),a2
	sll	4,a2
	movi	#longpas_t,a1
	add	a2,a1
	move	*a1,a1	

;	movi	95,a1			;>Calc time

	cmpi	300,a4
	jrgt	#ct

	movi	#shortpas_t,a1
	add	a2,a1
	move	*a1,a1	

;	movi	115,a1


#ct	move	*a13(plyr_turbon),a14
	jrz	#noturb			;No turbo?
	addi	#turbopas_t,a2
	move	*a2,a2
	sub	a2,a1

;	subi	32,a1			;Quicker

#noturb
	move	a14,@plyrpasstype	;0=Normal, !0=Turbo

	mpys	a4,a1
	sra	10,a1			;/1024
	move	a1,a4
	subk	16,a1
	jrge	#nshrt			;!Short?
	movk	16,a4			;Min
#nshrt
	move	*a6(PA8),a2,L		;Get * teammates obj
	move	*a6(plyr_nojoy),a14
	jrnn	#nolead

;	move	*a6(plyr_seqdir),a3
;	cmpi	2,a3
;	jrz	#oldway
;	cmpi	6,a3
;	jrnz	#newway
;#oldway



;	move	*a13(plyr_seqdir),a14
;	cmp	a14,a3
;	jrnz	#newway

;	move	*a2(OXVEL),a3,L
;	mpys	a4,a3
;	move	*a2(OXVAL),a14,L
;	add	a14,a3
;	move	*a2(OXANI),a14,L
;	add	a14,a3
;	move	*a2(OZVEL),a5,L
;	mpys	a4,a5
;	move	*a2(OZVAL),a14,L
;	add	a14,a5

;	sra	16,a3
;	sra	16,a5

;	jruc	#outb1
;#newway

	move	a4,b0			;>Calc where ball should go
	move	*a2(OXVAL),a3,L
	move	*a2(OXANI),a14,L
	add	a14,a3
	move	*a2(OZVAL),a5,L

	move	*a2(OXVEL),a1,L
	move	*a2(OZVEL),a14,L

#bndlp	add	a1,a3			;Walk through movements
	add	a14,a5	
	cmpi	(PLYRMINX)<<16,a3
	jrle	#outb
	cmpi	(PLYRMAXX)<<16,a3
	jrge	#outb
	cmpi	(CZMIN+8)<<16,a5
	jrle	#outb
	cmpi	(GZMAX-6)<<16,a5
	jrge	#outb

	subk	1,b0			;1 step
	jrgt	#bndlp

;	jruc 	#outb1
#outb
;	PUSH	a0,a1
;	movi	whstle2_snd,a0
;	calla	snd_play1ovr
;	PULL	a0,a1
;#outb1
	sra	16,a3
	sra	16,a5

	move	*a0(OXPOS),a1
	move	*a0(OXANI+16),a14
	add	a14,a1
	sub	a1,a3			;X delta
	move	*a0(OZPOS),a1
	sub	a1,a5			;Y delta


#nolead
	sll	16,a3
	sll	16,a5
	divs	a4,a3
	divs	a4,a5

	move	a3,*a0(OXVEL),L
	move	a5,*a0(OZVEL),L

	move	*a0(OYVAL),a3,L		;Adjust for hgt difference
	move	*a2(OYVAL),a14,L
	sub	a14,a3			;- if ball above dest
	move	a14,a1
	sra	2,a1
	add	a1,a3

	move	a4,a5
	move	*a6(plyr_nojoy),a2
	jrn	#nopoh			;Leading pass?

	subk	4,a5

;FIX!!
;	move	*a13(plyr_seq),a2
;	subk	PASSOH_SEQ,a2
;	jrne	#nopoh
;	sub	a1,a3
;	subk	26,a5
;	movk	REBOUND_SEQ,a14
#nopoh
	movi	-GRAVB/2,a1
	move	*a13(plyr_jmpcnt),a2
	jrnz	#level			;In jump?

	move	@PCNT,a14
	andi	0fh,a14
	jrnz	#level
;Shawn, we have to fix this bounce pass

	move	*a13(plyr_seq),a14	;>Chk for overhead pass
	subi	PASSNEWOH_SEQ,a14
	jrz	#level
	move	*a13(plyr_seqdir),a14
	cmpi	0,a14
	jrz	#level
	cmpi	1,a14
	jrz	#level
	cmpi	7,a14
	jrz	#level

	move	*a0(OYVAL),a3,L		;Adjust for hgt difference
	movi	-GRAVB/2,a1
	srl	1,a4
#level
	mpys	a4,a1
	divs	a4,a3
	sub	a3,a1
	move	a1,*a0(OYVEL),L

	move	*a13(plyr_num),a0
	move	a0,@ballpnumshot
	move	a0,@ballpnumlast
	move	a0,@ballsclastp
	movi	-1,a0
	move	a0,@ballpnum		;No owner
	clr	a0
	move	a0,@ballscorezhit
	move	a0,@ballpasstime
	move	a0,*a13(plyr_ownball)
	movk	30,a0
	move	a0,*a13(plyr_shtdly)

	addk	5,a5
	move	a5,*a6(plyr_rcvpass)	;Tell teammate when to expect pass

	movi	pass_snd,a0
	calla	snd_play1


#x	PULL	a6
	rets

#longpas_t
	.word	103,101,99,97,95,93
	.word	91,89,87,85,83
#shortpas_t
	.word	127,124,121,118,115,112
	.word	109,106,103,100,97
#turbopas_t
	.word	28,29,30,31,32,33
	.word	35,38,41,44,44



#*******************************
* Try a rebound if possible
* A8=*Plyr obj
* A13=*Plyr process
* Trashes scratch, A2-A5

RTIME	.equ	25

 SUBRP	plyr_tryrebound

	PUSH	a6,a7

	move	@plyrinautorbnd,a1
	jrnz	#x			;Someone else doing?

	move	@game_time,a14,L
	cmpi	>500,a14
	jrge	#heave			;Do it
	
	move	*a13(plyr_num),a0
	move	@ballpnumshot,a1
	cmp	a0,a1
	jrz	#x
	XORI	1,a1
	cmp	a1,a0
	jrz	#x			;Br=teammate shot

#heave
					;>Chk my start
	move	*a8(OZPOS),a1		;Get SZ
	subi	CZMID,a1
	abs	a1
	cmpi	40,a1
	jrgt	#posok
	move	*a8(OXPOS),a0		;Get SX
	move	*a8(OXANI+16),a14
	add	a14,a0
	subi	WRLDMID,a0
	abs	a0
	cmpi	HOOPRX-WRLDMID+13,a0
	jrge	#x			;Under backboard?

	subk	12,a1
	jrgt	#posok
	cmpi	HOOPRX-WRLDMID-8,a3
	jrge	#x			;Under rim?


#posok
	move	@ballobj_p,a5,L


	movk	RTIME,a0		;>Find new Y pos in x ticks
	move	*a5(OYVAL),a4,L
	move	*a5(OYVEL),a2,L
	movi	GRAVB,a1
#newblp
	add	a2,a4
	add	a1,a2
	dsj	a0,#newblp

	sra	16,a4

	cmpi	-140,a4
	jrlt	#x			;Too hi?

	addk	30,a4
	move	*a8(OYPOS),a0
	cmp	a0,a4
	jrge	#x			;Ball lower than plyr?



	move	*a5(OXVAL),a6,L		;>Find new XZ pos in x ticks
	move	*a5(OXANI),a14,L
	add	a14,a6
	move	*a5(OZVAL),a7,L

	move	a6,a0			;>Chk ball pos
	move	a7,a1
	sra	16,a0
	sra	16,a1

	subi	CZMID,a1
	abs	a1
	subk	12,a1
	jrgt	#bposok
	subi	WRLDMID,a0
	abs	a0
	cmpi	HOOPRX-WRLDMID-10,a3
	jrge	#x			;Under rim or backboard?
#bposok

	movk	RTIME,a0
	move	*a5(OXVEL),a1,L
	mpys	a0,a1
	add	a1,a6
	move	*a5(OZVEL),a1,L
	mpys	a0,a1
	add	a1,a7

	sra	16,a6
	sra	16,a7

	move	a6,a0			;>Chk my destination
	move	a7,a1

	subi	CZMID,a1
	abs	a1
	cmpi	40,a1
	jrgt	#eposok
	subi	WRLDMID,a0
	abs	a0
	cmpi	HOOPRX-WRLDMID+13,a0
	jrge	#x			;Under backboard?
	subk	14,a1
	jrgt	#eposok
	cmpi	HOOPRX-WRLDMID-10,a3
	jrge	#x			;Under rim?
#eposok

	callr	seekdirdist_obxz128
	cmpi	60,a1
	jrge	#x			;Too far to jump?

	move	a0,*a13(plyr_newdir)	;Turn where ball is headed

	movk	REBOUNDA_SEQ,a0
	move	a0,@plyrinautorbnd

	move	*a13(plyr_dir),a7
	callr	plyr_setseq


#x	PULL	a6,a7
	rets


#*******************************
* Clear auto rebound flag - Called when SEQ_REBOUNDA lands

 SUBR	clr_autorbnd

	clr	a0
	move	a0,@plyrinautorbnd
	rets


#*******************************
* Set the ball xyz position from player
* A8=*Plyr obj
* A13=*Plyr process
* Trashes scratch

 SUBRP	plyr_setballxyz

	move	@ballobj_p,a0,L

	move	*a8(OZPOS),a1		;>Set Z
	move	*a13(plyr_ballzo),a14
	add	a14,a1
	move	a1,*a0(OZPOS)

	move	*a8(OXVAL),a1,L		;>Set X
	move	a1,b0
	move	*a13(plyr_ballxo),a14,L
	add	a14,a1
	move	*a0(OIMG),a14,L
	move	*a14(IANIOFFX),a14
	sll	16,a14
	sub	a14,a1
	move	a1,*a0(OXVAL),L

	move	*a8(OXANI),a14,L	;Make 3D ball X+ani = plyr X+ani
	sub	a14,a1
	move	b0,a14
	sub	a1,a14
	move	a14,*a0(OXANI),L

	move	*a13(plyr_ballyo),a1
	cmpi	-200,a1
	jreq	#bfree			;Ball Y free?

	move	*a0(OIMG),a14,L		;>Set Y
	move	*a14(IANIOFFY),a14
	sub	a14,a1
	move	*a8(OYPOS),a14
	add	a14,a1
	move	a1,*a0(OYPOS)
	clr	a1
	move	a1,*a0(OYVEL),L		;Stop grav from accumulating
	move	a1,*a0(OXVEL),L
	move	a1,*a0(OZVEL),L
	move	a1,@ballfree		;!Free

	rets

#bfree
	move	@ballfree,a14
	jrnz	#x			;Already free?
	movk	1,a14
	move	a14,@ballfree		;Free
	move	*a0(OYPOS),a1
	move	*a0(OIMG),a14,L
	move	*a14(IANIOFFY),a14
	add	a14,a1
	movi	->a00,a14		;Push it towards gnd
	mpys	a14,a1
	addi	>16000,a1
	move	a1,*a0(OYVEL),L
#x	rets


#*******************************
* Get a scaled objects anipt XY
* A8=*Obj
* >A0=Scaled Ani X (16:16)
* >A1=Scaled Ani Y
* Trashes scratch

 SUBR	anipt_getsclxy

	move	a2,b0

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
	move	*a0,a14
	sll	4,a14			;*16
	move	a1,a0

	move	*a2(IANIOFFY),a1
	mpys	a14,a1


	move	*a8(OCTRL),a14
	btst	B_FLIPH,a14
	jrz	#x			;No flip?

	move	*a2,a2			;ISIZEX
	subk	1,a2
	sll	16,a2			;*64K
	neg	a0
	add	a2,a0			;+size


#x	move	b0,a2
	rets


#*******************************
* Get a scaled objects 2nd anipt XY
* A8=*Obj
* >A0=Scaled Ani2 X (16:16)
* >A1=Scaled Ani2 Y
* Trashes scratch

 SUBRP	anipt2_getsclxy

	move	a2,b0

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

	move	*a2(IANI2X),a1
	mpys	a14,a1
	move	*a0,a14
	sll	4,a14			;*16
	move	a1,a0

	move	*a2(IANI2Y),a1
	cmpi	-200,a1
	jrne	#ynorm
	sll	16,a1
	jruc	#cflip
#ynorm	mpys	a14,a1


#cflip	move	*a8(OCTRL),a14
	btst	B_FLIPH,a14
	jrz	#x			;No flip?

	move	*a2,a2			;ISIZEX
	subk	1,a2
	sll	16,a2			;*64K
	neg	a0
	add	a2,a0			;+size


#x	move	b0,a2
	rets



#*******************************
* Get a scaled objects 3rd anipt XY
* A8=*Obj
* >A0=Scaled Ani3 X (16:16)
* >A1=Scaled Ani3 Y
* Trashes scratch

 SUBR	anipt3_getsclxy

	move	a2,b0

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

	move	*a2(IANI3X),a1
	mpys	a14,a1
	move	*a0,a14
	sll	4,a14			;*16
	move	a1,a0


	move	*a2(IANI3Y),a1
	mpys	a14,a1


#cflip	move	*a8(OCTRL),a14
	btst	B_FLIPH,a14
	jrz	#x			;No flip?

	move	*a2,a2			;ISIZEX
	subk	1,a2
	sll	16,a2			;*64K
	neg	a0
	add	a2,a0			;+size


#x	move	b0,a2
	rets



#*******************************
* Align shadow obj with player obj and set ani
* A8=*Obj
* A13=*Plyr process
* Trashes scratch, A2-A4

 SUBRP	plyr_setshadow

	move	*a13(plyr_shadobj_p),a4,L

	move	*a8(OZPOS),a0
	move	a0,a1
	subi	50,a1			;Adjust
	move	a1,*a4(OZPOS)

	subi	CZMIN,a0		;-Base
	jrge	#zok
	clr	a0
#zok	srl	5,a0			;/32
	move	*a8(OYPOS),a1
	move	*a13(plyr_aniy),a14
	add	a14,a1			;Ani pt position
	sra	4,a1			;/16 (Neg)
	add	a1,a0
	sll	5,a0			;*32
	addi	#ani_t,a0
	move	*a0,a2,L
	move	a2,*a4(OIMG),L		;Set new img
	move	*a2,a14,L
	move	a14,*a4(OSIZE),L
	move	*a2(ISAG),*a4(OSAG),L

	callr	anipt_getsclxy

	move	*a2(IANIOFFX),a3
	sll	16,a3
	move	a3,*a4(OXANI),L

	move	*a8(OXVAL),a14,L
	add	a0,a14			;Ani X
	sub	a3,a14
	move	a14,*a4(OXVAL),L

	move	*a2(IANIOFFY),a3
	neg	a3
	move	a3,*a4(OYPOS)

	rets


	.long	shadow15,shadow15,shadow15,shadow15
	.long	shadow15,shadow15,shadow15,shadow15
	.long	shadow15,shadow14,shadow13,shadow12
#ani_t	.long	shadow11,shadow10,shadow9,shadow8
	.long	shadow7,shadow6,shadow5,shadow4
	.long	shadow3,shadow2,shadow1,shadow1
	.long	shadow1,shadow1,shadow1



#*******************************
* Align head obj with player obj
* A8=*Obj
* A13=*Plyr process
* Trashes scratch, A2-A6

 SUBRP	plyr_headalign

	move	*a13(plyr_headobj_p),a6,L ;>A6=*Head obj

	move	*a8(OIMG),a0,L		;>Set Z
	move	*a8(OZPOS),a14
	move	*a0(IANI3Z),a1
	add	a1,a14
	move	a14,*a6(OZPOS)
	sub	a1,a14
	neg	a1
	move	a1,*a6(OMISC)		;Z offset

					;>Calc head scale anixy (A3,A5)
	subi	GZBASE,a14		;-Base
	jrge	#zok
	clr	a14
#zok	srl	4,a14			;/16
	sll	6,a14			;*64
	move	*a6(ODATA_p),a0,L
	addk	32,a0
	add	a14,a0

	move	*a0+,a14
	sll	4,a14			;*16
	move	*a6(OIMG),a2,L

	move	*a2(IANIOFFX),a3
	mpys	a14,a3

	move	*a0,a14
	sll	4,a14			;*16

	move	*a2(IANIOFFY),a5
	mpys	a14,a5

	move	*a6(OCTRL),a14
	btst	B_FLIPH,a14
	jrz	#nohf			;No flip?

	move	*a2,a2			;ISIZEX
	subk	1,a2
	sll	16,a2			;*64K
	neg	a3
	add	a2,a3			;+size
#nohf

	callr	anipt3_getsclxy

	move	*a8(OYVAL),a14,L
	add	a1,a14			;Ani3 Y
	sub	a5,a14
	move	a14,*a6(OYVAL),L

	move	*a8(OXVAL),a14,L
	move	a14,a1
	add	a0,a14			;Ani3 X
	sub	a3,a14
	move	a14,*a6(OXVAL),L

	move	*a8(OXANI),a0,L		;Make head X+ani = plyr X+ani
	add	a0,a1
	sub	a14,a1
	move	a1,*a6(OXANI),L

	rets

;#*******************************
;* Align arw obj with player obj
;* A8=*Obj
;* a6=Arw Obj
;* Trashes scratch, A2-A6
;
; SUBR	plyr_arwalign
;
;
;	move	*a8(OIMG),a0,L		;>Set Z
;	move	*a8(OZPOS),a14
;	move	*a0(IANI3Z),a1
;	add	a1,a14
;	move	a14,*a6(OZPOS)
;	sub	a1,a14
;	neg	a1
;	move	a1,*a6(OMISC)		;Z offset
;
;					;>Calc head scale anixy (A3,A5)
;	subi	GZBASE,a14		;-Base
;	jrge	#zok
;	clr	a14
;#zok	srl	4,a14			;/16
;	sll	6,a14			;*64
;	move	*a6(ODATA_p),a0,L
;	addk	32,a0
;	add	a14,a0
;
;	move	*a0+,a14
;	sll	4,a14			;*16
;	move	*a6(OIMG),a2,L
;
;	move	*a2(IANIOFFX),a3
;	mpys	a14,a3
;
;	move	*a0,a14
;	sll	4,a14			;*16
;
;	move	*a2(IANIOFFY),a5
;	mpys	a14,a5
;
;;	move	*a6(OCTRL),a14
;;	btst	B_FLIPH,a14
;;	jrz	#nohf			;No flip?
;;
;;	move	*a2,a2			;ISIZEX
;;	subk	1,a2
;;	sll	16,a2			;*64K
;;	neg	a3
;;	add	a2,a3			;+size
;;#nohf
;
;	callr	anipt3_getsclxy
;
;	move	*a8(OYVAL),a14,L
;	add	a1,a14			;Ani3 Y
;	sub	a5,a14
;	move	a14,*a6(OYVAL),L
;
;	move	*a8(OXVAL),a14,L
;	move	a14,a1
;	add	a0,a14			;Ani3 X
;	sub	a3,a14
;	move	a14,*a6(OXVAL),L
;
;
;	move	*a8(OXANI),a0,L		;Make head X+ani = plyr X+ani
;	add	a0,a1
;	sub	a14,a1
;	move	a1,*a6(OXANI),L
;
;
;	rets
;


#*******************************
* Referee tosses up ball (process)

 SUBRP	plyr_referee

	movk	1,a0
	callr	plyr_setac

	movi	[WRLDMID,0],a0
	clr	a1
	movi	shadow7,a2
	movi	CZMID-30-1,a3
	movi	DMAWNZ|M_3D|M_SHAD|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
;	movi	50,a0
;	move	a0,*a8(OMISC)		;Z offset
	move	a8,a11

	movi	[WRLDMID,0],a0
	clr	a1
	movi	reftip1,a2
	movi	CZMID-30,a3
	movi	DMAWNZ|M_3D|M_NOCOLL,a4
	calla	BEGINOBJ2

	movi	#att_t,a0
	move	a0,*a13(plyr_attrib_p),L

	movi	scale63_t,a0
	move	a0,*a8(ODATA_p),L

	SLEEPK	5

	movk	1,a0
	move	a0,*a13(plyr_ownball)		;!0=Ref has ball
	movk	25,a0
	move	a0,*a13(plyr_ballzo)

	movi	#ani_l,a9
	movk	1,a10
#lp
	dsj	a10,#noani

#getwt	move	*a9+,a10
	jrz	#refdone
	jrnn	#nocode
	
	move	*a9+,a0,L			;Call function
	call	a0
	jruc	#getwt
#nocode
	move	*a9+,a0,L
	movk	M_WRNONZ,a1
	callr	plyr_ani

	callr	anipt2_getsclxy
	move	a0,*a13(plyr_ballxo),L
	sra	16,a1
	move	a1,*a13(plyr_ballyo)

	move	*a13(plyr_aniy),a1
	neg	a1
	move	a1,*a8(OYPOS)			;Set on gnd

#noani
	move	*a13(plyr_ownball),a0
	jrz	#noball				;Tossed up?

	callr	plyr_setballxyz
#noball
	callr	joy_read2			;Scan buttons since ac is on

	clr	a0
	move	a0,@P1CTRL
	move	a0,@P4CTRL

	movi	P1CTRL,a1			;>Kill unwanted bits
	movk	4,b0
#jlp	move	*a1,a0
	andi	BUT1_M<<8+BUT1_M,a0
	move	a0,*a1+
	dsj	b0,#jlp

	SLEEPK	1
	move	@HALT,a0
	jrnz	#noball
	jruc	#lp

#refdone
	SLEEPK	5
	calla	SCRTST
	jrz	#refdone			;Still on screen?
	move	a11,a0
	calla	DELOBJ
	jauc	DELOBJDIE


#att_t	.long	scale63_t,Ref_p


#ani_l	WL	TSEC,reftip1
	WL	10,reftip2
	WL	10,reftip1
	WL	10,reftip3
	WL	10,reftip4
	WL	10,reftip5
	WL	-1,#do_whstle
	WL	10,reftip6
	WL	10,reftip7
	WL	10,reftip8
	WL	8,reftip9
	WL	7,reftip10
	WL	7,reftip11
	WL	7,reftip12
	WL	-1,#tossball
	WL	7,reftip13
	WL	7,reftip14
	WL	6,reftip15
	WL	5,reftip16

	WL	-1,#step_back
	WL	3,refbk1
	WL	3,refbk2
	WL	3,refbk3
	WL	3,refbk4
	WL	3,refbk5
	WL	3,refbk6
	WL	3,refbk7
	WL	3,refbk8
	WL	3,refbk1
	WL	3,refbk2
	WL	3,refbk3
	WL	3,refbk4
	WL	3,refbk5
	WL	3,refbk6
	WL	3,refbk7
	WL	3,refbk8
	WL	3,refbk1
	WL	3,refbk2
	WL	3,refbk3
	WL	3,refbk4
	WL	-1,#ac_off
	WL	3,refbk5
	WL	3,refbk6
	WL	3,refbk7
	WL	3,refbk8
	WL	3,refbk1
	WL	3,refbk2
	WL	3,refbk3
	WL	3,refbk4
	WL	3,refbk5
	WL	3,refbk6
	WL	3,refbk7
	WL	3,refbk8
	WL	3,refbk1
	WL	3,refbk2
	WL	3,refbk3
	WL	3,refbk4
	WL	3,refbk5
	WL	3,refbk6
	WL	3,refbk7
;	WL	3,refbk8
	WL	-1,#stop_back
	WL	5,refsqt5
	W0


#do_whstle
	movi	whstle_snd,a0
	jauc	snd_play1ovr


#tossball
	move	@ballobj_p,a1,L
	movi	-GRAVB*44,a0
	move	a0,*a1(OYVEL),L
	clr	a0
	move	a0,@clock_active		;Turn on clock
	move	a0,*a13(plyr_ownball)		;Let go
	rets


#step_back
	movi	-14000h,a0
	move	a0,*a8(OZVEL),L
	move	a0,*a11(OZVEL),L

	move	a11,a2

	move	@plyrproc_t+32,a11,L
	CREATE	TIPID,plyr_tip

	move	@plyrproc_t+32*2,a11,L
	CREATE	TIPID,plyr_tip

	move	a2,a11

	rets

#ac_off
	clr	a0
	jruc	plyr_setac


#stop_back
	clr	a0
	move	a0,*a8(OZVEL),L
	move	a0,*a11(OZVEL),L
	rets

#*******************************
* Jump at ball for tip (Process)
* A11=*Plyr process

	.bss	t1bcnt	,16	;Team1 (p1) # button hits
	.bss	t2bcnt	,16	;Team2 (p2) ^

 SUBRP	plyr_tip

	move	*a11(PA8),a8,L

	PUSH	a13
	move	a11,a13

	movi	TIPJ_SEQ,a0
	move	*a13(plyr_dir),a7
	callr	plyr_setseq
	move	a10,*a13(PA10),L

	PULL	a13
	SLEEPK	6


	movi	-GRAVB*30,a0
	move	a0,*a8(OYVEL),L
	movk	1,a0			;Start jump
	move	a0,*a11(plyr_jmpcnt)

	movi	t1bcnt,a9		;>Count button1 down presses
	move	*a11(plyr_num),a1
	btst	1,a1
	jrz	#t1
	addk	16,a9
#t1	clr	a0
	move	@PSTATUS,a14
	btst	a1,a14
	jrnz	#human			;Human opponent?
	movk	3,a0			;Drones # presses
#human	move	a0,*a9

	movk	25,a10
#lp
	move	*a11(PA11),a0,L
	move	*a0,a0
	btst	BUT1_B+8,a0
	jrz	#noprs			;No down transition?
	move	*a9,a0			;+1 cnt
	addk	1,a0
	move	a0,*a9
#noprs
	SLEEPK	1
	dsj	a10,#lp

	move	*a11(plyr_num),a5

	movi	t1bcnt,a2
	move	*a2+,a0
	move	*a2+,a1
	btst	1,a5
	jrz	#tm1
	SWAP	a0,a1
#tm1
	cmp	a1,a0
	jrlt	#x			;Less presses than opponent?

	movi	->18000,a0
	movi	->f000,a1
  	movi	-20,a3
	btst	1,a5
	jrz	#tm1a

	neg	a0
	neg	a1
	neg	a3
#tm1a
	move	@ballobj_p,a2,L

	move	*a2(OXPOS),a4
	add	a3,a4
	move	a4,*a2(OXPOS)
	move	a0,*a2(OXVEL),L
	move	a1,*a2(OZVEL),L

	movi	-GRAVB*10,a0
	move	a0,*a2(OYVEL),L

	movi	TIPID,a0
	calla	KIL1C

#x

;RJR
;call ball slap sound
	movi	swat_snd,a0
	calla	snd_play1

	DIE


#*******************************
* End of quarter (JSRP by score)

 SUBR	plyr_endofqrtr

	movi	1000,a0
	move	a0,@cntrs_delay		;Delay credit timers

	move	@gmqrtr,a0		;Next quarter
	addk	1,a0
	move	a0,@gmqrtr
	subk	1,a0
	jrne	#not1st


	movi	AUD_1STQUARTR,a0	;>1st guarter
	calla	AUD1

	JSRP	plyr_endqfinishshot

	clr	a0
	move	a0,@kp_qscrs,L
	move	a0,@kp_qscrs+32,L
	move	a0,@kp_qscrs+64,L
	move	a0,@kp_qscrs+96,L

	move	@scores,a0
	move	a0,@kp_qscrs
	move	@scores+16,a0
	move	a0,@kp_qscrs+16

	movi	tuneend1_snd,a0
	calla	snd_play1ovr

	JSRP	hint_page
	jruc	#tob


#not1st
	subk	1,a0
	jrne	#nothalf

	movi	AUD_HALFTIME,a0		;>2nd quarter
	calla	AUD1

	JSRP	plyr_endqfinishshot

	move	@scores,a0
	move	@kp_qscrs,a14
	sub	a14,a0
	move	a0,@kp_qscrs+32
	move	@scores+16,a0
	move	@kp_qscrs+16,a14
	sub	a14,a0
	move	a0,@kp_qscrs+48

	movi	tunehalf_snd,a0
	calla	snd_play1ovr

	JSRP	halftime_showclips

; SUBR	plyr_eoq_lockcont		;Continuation point after clip lockup

	clr	a0
	JSRP	stats_page2

	movi	t1dunkcnt,a2		;>Setup most dunking team for board shatter
	move	*a2,a1
	cmpi	3,a1
	jrlt	#nobrk			;!Enough dunks?
	subk	2,a1
	neg	a1
	move	a1,*a2			;New cnt
#nobrk
	movi	t1dunkcnt+16,a2		;>Setup most dunking team for board shatter
	move	*a2,a1
	cmpi	3,a1
	jrlt	#nobrk2			;!Enough dunks?
	subk	2,a1
	neg	a1
	move	a1,*a2			;New cnt
#nobrk2

;Restart players here?

	move	@plyrproc_t,a8,L
	move	*a8(plyr_headobj_p),a0,L
	calla	DELOBJ
	move	*a8(plyr_shadobj_p),a0,L
	calla	DELOBJ
	move	a8,a0
	calla	KILL

	move	@plyrproc_t+32,a8,L
	move	*a8(plyr_headobj_p),a0,L
	calla	DELOBJ
	move	*a8(plyr_shadobj_p),a0,L
	calla	DELOBJ
	move	a8,a0
	calla	KILL

	move	@plyrproc_t+64,a8,L
	move	*a8(plyr_headobj_p),a0,L
	calla	DELOBJ
	move	*a8(plyr_shadobj_p),a0,L
	calla	DELOBJ
	move	a8,a0
	calla	KILL

	move	@plyrproc_t+96,a8,L
	move	*a8(plyr_headobj_p),a0,L
	calla	DELOBJ
	move	*a8(plyr_shadobj_p),a0,L
	calla	DELOBJ
	move	a8,a0
	calla	KILL


	move	@plyrobj_t,a0,L
	calla	DELOBJ
	move	@plyrobj_t+32,a0,L
	calla	DELOBJ
	move	@plyrobj_t+64,a0,L
	calla	DELOBJ
	move	@plyrobj_t+96,a0,L
	calla	DELOBJ

	movi	P1_PID,a0
	calla	KIL1C
	movi	P2_PID,a0
	calla	KIL1C
	movi	P3_PID,a0
	calla	KIL1C
	movi	P4_PID,a0
	calla	KIL1C
	movi	P1_PID,a0
	calla	obj_del1c
	movi	P2_PID,a0
	calla	obj_del1c
	movi	P3_PID,a0
	calla	obj_del1c
	movi	P4_PID,a0
	calla	obj_del1c
	CREATE0	doplyrs
 
	movi	ARWPID,a0
	calla	KIL1C
	movi	arwid,a0
	calla	obj_del1c
	movi	ARWPID,a0
	calla	obj_del1c

	CREATE0	delay_arws

 	movk	1,a0
	move	a0,@HALT

;	movi	>1e0c3100,a0
;	move	a0,@WORLDTLX,L
;	clr	a0
;	move	a0,@WORLDTLY,L
;	move	@ballobj_p,a0,L
;	movi	>1e7d6caf,a1
;	move	a1,*a0(OXVAL),L
;	movi	>ffc265df,a1
;	move	a1,*a0(OYVAL),L
;	movi	>0476c52d,a1
;	move	a1,*a0(OZVAL),L
;	movi	>2500,a1
;	move	a1,*a0(OZVEL),L
;	clr	a1
;	move	a1,*a0(OXVEL),L
;	move	a1,*a0(OYVEL),L

	jruc	#tob

delay_arws

;Give players a chance to start

	SLEEPK	10

 	.ref	start_arws
	calla	start_arws

;	SLEEP	1*60
	SLEEPK	8

 	clr	a0
	move	a0,@HALT

	DIE

doplyrs
;	move	@plyrbighead,a0
;	zext	a0
;	cmpi	>eaea,a0
;	jrnz	#no_3d
;	movk	>f,a2
;	move	a2,@stlpower
;	jruc	#adjoff
;#no_3d
;	clr	a2
;	movk	ADJHEADSZ,a0		;Get head size
;	calla	GET_ADJ			;1-2
;	subk	1,a0
;	jrle	#adjoff			;No big heads?
;	movk	>f,a2
;#adjoff
;	move	a2,@plyrbighead

	movi	plyrproc_t+4*32,a2
	movi	plyrobj_t+3*32,a9
	movk	3,a8
#strtp	CREATE	1000h,plyr_main
	move	a0,-*a2,L		;Save *proc
	subk	32,a9
	dsj	a8,#strtp

	move	a13,-*a2,L
	jruc	plyr_main		;#0


#nothalf
	subk	1,a0
	jrne	#not3rd

	movi	AUD_3RDQUARTR,a0	;>3rd quarter
	calla	AUD1
	JSRP	plyr_endqfinishshot

	move	@scores,a0
	move	@kp_qscrs,a14
	move	@kp_qscrs+32,a1
	add	a1,a14
	sub	a14,a0
	move	a0,@kp_qscrs+64
	move	@scores+16,a0
	move	@kp_qscrs+16,a14
	move	@kp_qscrs+48,a1
	add	a1,a14
	sub	a14,a0
	move	a0,@kp_qscrs+80

	movi	tuneend1_snd,a0
	calla	snd_play1ovr

	JSRP	hint_page
	jruc	#tob


#not3rd

;2/9/93
;	clr	a0
;	move	a0,@gmqrtr
;	jruc	mark

	subk	1,a0
	jrne	#not4th

	movi	AUD_4THQUARTR,a0	;>4th quarter
	calla	AUD1

	JSRP	plyr_endqfinishshot


	move	@scores,a0
	move	@kp_qscrs,a14
	move	@kp_qscrs+32,a1
	move	@kp_qscrs+64,a2
	add	a1,a14
	add	a2,a14
	sub	a14,a0
	move	a0,@kp_qscrs+96
	move	@scores+16,a0
	move	@kp_qscrs+16,a14
	move	@kp_qscrs+48,a1
	move	@kp_qscrs+80,a2
	add	a1,a14
	add	a2,a14
	sub	a14,a0
	move	a0,@kp_qscrs+112

 	move	@scores,a0
	move	@scores+16,a1
	cmp	a0,a1
	jreq	#tie


#endofg	callr	endgame_audits		;>End of game

	SLEEP	TSEC*3-30

	.ref	victory_speech
	calla	victory_speech

	SLEEP	TSEC*2+30

;	JSRP	result_screen

	movk	1,a0
	JSRP	stats_page

	clr	a0
	move	a0,@IRQSKYE

	calla	display_blank
	calla	save_player_records
	calla	display_unblank

	JSRP	rank_screen

	JSRP	grand_champs_screen	;if a champ is found then
;	move	a10,a10			;print the hiscore screen next
;	jrz	#no_champ

;	JSRP	show_hiscore

;#no_champ

	clr	a0

	move	a0,@qtr_purchased,L	;clr 4x16
	move	a0,@qtr_purchased+20h,L

	move	@team1,a0
	move	a0,@kp_team1
	move	@team2,a0
	move	a0,@kp_team2
	move	@scores,a0,L
	move	a0,@kp_scores,L

	move	@kp_qscrs,a0,L
	move	a0,@kp_qscrs2,L
	move	@kp_qscrs+32,a0,L
	move	a0,@kp_qscrs2+32,L
	move	@kp_qscrs+64,a0,L
	move	a0,@kp_qscrs2+64,L
	move	@kp_qscrs+96,a0,L
	move	a0,@kp_qscrs2+96,L

	JSRP	winner_stays_on

;	move	@PSTATUS,a0
;	jrz	#x
;	jruc	game_start2
;#x

	jauc	game_over



#not4th
	JSRP	plyr_endqfinishshot	;>Overtime

 	move	@scores,a0
	move	@scores+16,a1
	cmp	a0,a1
	jrne	#endofg

;Display Double or Triple OT message, keep going...


#tie					;>Tie

	movi	AUD_OVERTIME,a0
	calla	AUD1

	movi	tuneend1_snd,a0
	calla	snd_play1ovr

	movk	1,a0
	move	a0,@HALT

	movi	6*TSEC+10-70+60-20,a11
	CREATE0	scr1
	CREATE0	show_ot_msg

	SLEEP	160

	movi	overtime_snd,a0
	calla	snd_play1ovr

	SLEEP	120

	movk	12,a1			;Free time into OT for
	movi	P1DATA,a2

	move	@game_purchased,a0
	movk	4,b0
	clr	a3

#tlp	btst	a3,a0
	jrz	#nx			;No full game?
	move	a1,*a2(ply_time)	;Give xtra time
#nx	addi	PDSIZE,a2
	addk	1,a3
	dsj	b0,#tlp

	move	b0,@game_purchased

	move	@team1,a0
	move	a0,@kp_team1
	move	@team2,a0
	move	a0,@kp_team2
	move	@scores,a0,L
	move	a0,@kp_scores,L

	JSRP	hint_page
	jruc	#tob


;	move	@ballpnum,a11
;	jrnn	#ok1
;	move	@ballpnumshot,a11
;#ok1
;	srl	1,a11
;	subk	1,a11
;	CREATE0	plyr_takeoutball3
;	jruc	#tob2

#tob
	.ref	random_ads
	calla	random_ads

	movi	nofade_t,a10
	CREATE0	fade_up_half

	CREATE0	fix_floor

	move	@gmqrtr,a11
	sll	32-1,a11
	move	@gmqrtr,a0
	cmpi	2,a0
	jrnz	#not2
	CREATE	takepid,plyr_takeoutball
	jruc	#tob2
#not2	CREATE0	plyr_takeoutball2

#tob2
	clr	a0
	move	a0,@cntrs_delay		;Delay credit timers
	move	@gmqrtr,a14
	cmpi	2,a14
	jrz	#skp
	move	a0,@HALT
#skp	movi	2<<10+4<<5+9,a0
	move	a0,@IRQSKYE

	move	@gmqrtr,a14
	cmpi	2,a14
	jrnz	#skpz
	CREATE0	delay_numbs
	RETP
#skpz
;Make sure #'s are on at start of qrtr
	movi	P1DATA,a10
	calla	stick_number
	movi	P2DATA,a10
	calla	stick_number
	movi	P3DATA,a10
	calla	stick_number
	movi	P4DATA,a10
	calla	stick_number

	RETP

delay_numbs
;Make sure #'s are on at start of qrtr
	SLEEPK	20
	movi	P1DATA,a10
	calla	stick_number
	movi	P2DATA,a10
	calla	stick_number
	movi	P3DATA,a10
	calla	stick_number
	movi	P4DATA,a10
	calla	stick_number
	DIE

fix_floor
	SLEEPK	12
	.ref	fix_floorclr
	calla	fix_floorclr
	DIE

#*******************************

 SUBRP	endgame_audits

;	movi	0100b,a0
;	move	a0,@PSTATUS2
;
;	movi	28,a0
;	move	a0,@scores
;	movi	49,a0
;	move	a0,@scores+10h


	movi	AUD_COMPLETED,a0	;>4th quarter
	calla	AUD1

	move	@scores,a0
	move	@scores+10h,a1
	cmp	a1,a0
	jrhi	#t1_wins
#t2_wins
	movi	AUD_LOS_SCORE,a0
	move	@scores,a1
	calla	AUD

	movi	AUD_WIN_SCORE,a0
	move	@scores+10h,a1
	calla	AUD

	jruc	#cont

#t1_wins
	movi	AUD_WIN_SCORE,a0
	move	@scores,a1
	calla	AUD

	movi	AUD_LOS_SCORE,a0
	move	@scores+10h,a1
	calla	AUD
#cont

	move	@PSTATUS2,a0
	andi	011b,a0
	jrnz	#team1_human
;#team1_cpu
	move	@scores,a4		;CPU SCORE
	move	@scores+10h,a5		;HUMAN SCORE

	movi	AUD_CPUGAMES,a0		;a cpu team
	calla	AUD1
	movi	AUD_CPUSCORES,a0
	move	a4,a1			;cpu score
	calla	AUD
	callr	do_cpu_stats
	jruc	#cont2

#team1_human
	movi	AUD_HUMGAMES,a0		;a human team
	calla	AUD1
	movi	AUD_HUMSCORES,a0
	move	@scores,a1		;human score
	calla	AUD


#cont2
	move	@PSTATUS2,a0
	andi	01100b,a0
	jrnz	#team2_human
;#team2_cpu
	move	@scores+10h,a4		;CPU SCORE
	move	@scores,a5		;HUMAN SCORE


	movi	AUD_CPUGAMES,a0		;a cpu team
	calla	AUD1
	movi	AUD_CPUSCORES,a0
	move	a4,a1			;cpu score
	calla	AUD
	callr	do_cpu_stats
	rets

#team2_human
	movi	AUD_HUMGAMES,a0		;a human team
	calla	AUD1
	movi	AUD_HUMSCORES,a0
	move	@scores+10h,a1		;human score
	calla	AUD


;Now total all human vs. human games, and audit left side winners

	move	@PSTATUS2,a0
	andi	011b,a0
	jrz	#novs
	move	@PSTATUS2,a0
	andi	01100b,a0
	jrz	#novs
;Was a human vs. human game.
	movi	AUD_HUMANVSHUMAN,a0
	calla	AUD1
	move	@scores,a0
	move	@scores+10h,a1
	cmp	a1,a0
	jrlo	#tm2_wins
	movi	AUD_WINSONLEFT,a0
	calla	AUD1
#tm2_wins
#novs
	rets


#*******************************
* Update CPU stats
* A4=Cpu score
* A5=Human score

do_cpu_stats

	cmp	a4,a5
	jrhi	#cpu_loses

;cpu_wins
	movi	AUD_CPUWINS,a0		;CPU victories + 1
	calla	AUD1

	movi	AUD_CPUWINMARG,a0
	calla	GET_AUD			;RET in A1

	sub	a5,a4
	cmp	a1,a4
	jrls	#not_higher
	move	a4,a1
	movi	AUD_CPUWINMARG,a0	;new win margin
	calla	STORE_AUDIT
	rets

#cpu_loses
	movi	AUD_CPULOSMARG,a0
	calla	GET_AUD			;RET in A1

	sub	a4,a5			;HUMAN - CPU SCORE
	cmp	a1,a5
	jrls	#not_higher
	move	a5,a1
	movi	AUD_CPULOSMARG,a0	;new loss margin
	calla	STORE_AUDIT
#not_higher
	rets



#*******************************
* Let shot finish at end of quarter (JSRP)

 SUBRP	plyr_endqfinishshot

	movi	TSEC*5/2,a10
#lp
	move	@ballpnum,a0
	jrnn	#stop			;Somebody has ball?
	move	@ballobj_p,a2,L
	move	*a2(OYPOS),a0
	cmpi	-15,a0
	jrgt	#stop			;Ball near gnd?

	SLEEPK	2

#gbcnt	dsj	a10,#lp

#stop
	move	@ballpnum,a0
	jrn	#no_owner
	sll	5,a0			;*32
	addi	plyrproc_t,a0
	move	*a0,a0,L
	move	*a0(plyr_seqflgs),a1
	btst	DUNK_B,a1
	jrz	#no_owner
	move	*a0(plyr_jmpcnt),a1
	cmpi	15,a1
	jrlt	#no_owner

;	jrnz	#was_bad
;	btst	SHOOT_B,a1
;	jrz	#no_owner
;#was_bad
	CREATE0	dobad
#no_owner

	movk	1,a0
	callr	plyr_setac

	clr	a0			;>Clr ctrl bits
	movi	P1CTRL,a1
	movk	2,b0
#stlp	move	a0,*a1+,L
	dsj	b0,#stlp

	movi	clockid,a0
	calla	KIL1C 			;Kill existing shot clock proc
	movi	CLSDEAD|clockid,a0
	calla	obj_del1c		;Delete any 24 second shot clock imgs
	clr	a0
	move	a0,@sc_proc,L
	move	a0,@game_time,L

	movk	1,a0
	move	a0,@HALT

	move	@tvpanelon,a0,L
	jrz	#turnon

	movi	CLSDEAD|tvid,a0
	clr	a1
	calla	EXISTOBJ
	jrz	#turnon

	move	@tvpanelon,a0,L
	movi	6*TSEC,a1
	move	a1,*a0(PTIME)
#turnon

	CREATE0	score_showtvpanel2

	move	@gmqrtr,a0		;Ran out of time
	subk	4,a0
	jrlt	#fade
	move	@scores,a0
	move	@scores+16,a1
	cmp	a0,a1
	jreq	#fade

	SLEEP	90

;	move	@tvpanelon,a0,L
;	jrz	#turnon
;	movi	6*TSEC,a1
;	move	a1,*a0(PTIME)
;#turnon

;Turn on winning team message
;	movi	win_snd,a0
;	calla	snd_play1

	movi	tuneend_snd,a0
	calla	snd_play1ovr

	.ref	winning_msg
	CREATE0	winning_msg
	jruc	#fade

;#otune
;	movi	tuneend1_snd,a0
;	calla	snd_play1



#fade
;MJT 12/7

	calla	pal_clean

	movi	nofade_t,a10
	CREATE0	fade_down_half

#x	RETP

dobad	SLEEP	100
	movi	baddec_snd,a0
	calla	speech_playovrp
	DIE

nofade_t			;Pals not to fade
	.long	scorepr,metprp_p
	.long	scorep
	.long	scorepb
	.long	scorepy
	.long	GROWBOX
	.long   SGMD8RED
	.long   SGMD8WHT
	.long	textp
	.long	ledw
	.long	ledr
	.long	MD_16
	.long	MD_16r
	.long	LED_P
	.long	GROWBOXr,GROWBOXy,GROWBOXg,GROWBOXb
	.long	LGMDRED2,LGMDPURP
	.long	LGMDWHT,WHITE2PAL,PURPLE
	.long	P_NUGS,P_BLAZ,P_76RS,P_HAWKS,P_MAGIC,P_SONICS,P_SPURS,P_SUNS
	.long	P_CAVS,P_BUCKS,P_HEAT,P_CLIPS,P_PACER
	.long	P_BULTS,P_WARS,P_HORS,P_PISS             
	.long	P_LAKS,P_TWOV,P_CELTS,P_JAZZ             
	.long	P_KINGS,P_NETS,P_MAVS,P_ROCKS            
	.long	P_KNIKS,P_BULS,GREENPAL
	.long	0




#*******************************
* Player goaltended (Process)
* A11=*Plyr obj

 SUBR	plyr_goaltending

	move	*a11(OPLINK),a11,L
	move	*a11(plyr_num),a0

	srl	1,a0
	move	a0,a11
	XORK	1,a0
	sll	4,a0			;0 or 16

	addi	scores,a0		;+Base
	move	@ballptsforshot,a1
	move	a1,a3
	calla	score_add

	calla	plyr_setptsdown


	movk	PS_2PTS_MADE,a0		;>Inc try shot stat
	subk	2,a3
	jreq	#2ptr
	movk	PS_3PTS_MADE,a0
#2ptr	move	@ballpnumshot,a1
	calla	inc_player_stat

	calla	prt_top_scores		;Update scores at scrn top

	movi	TSEC*2,a0
	callr	plyr_setshtdly

	CREATE0	goaltend_text

	movi	whstle_snd,a0
	calla	snd_play1

	move	@tvpanelon,a0,L
	jrz	#turnon
	movi	4*TSEC+10-70,a1
	move	a1,*a0(PTIME)
	jruc	#alrdyon
#turnon
	CREATE0	score_showtvpanel
#alrdyon

	movi	P1DATA,a10
	calla	stick_number
	movi	P2DATA,a10
	calla	stick_number
	movi	P3DATA,a10
	calla	stick_number
	movi	P4DATA,a10
	calla	stick_number

	SLEEP	30

	clr	a0
	move	a0,@ballptsforshot

	jruc	plyr_takeoutball3

#*******************************
* Show goaltending message (JSRP)

 SUBRP	goaltend_text


;	move	@ballobj_p,a2,L		;clear out ball vels
;	clr	a0
;	move	a0,*a2(OXVEL),L
;	move	a0,*a2(OYVEL),L
;	move	a0,*a2(OZVEL),L
;
;	movk	4,a3
;	movi	plyrobj_t,a2,L		;clear out player vels
;#velini_lp
;	move	*a2+,a1,L
;	move	a0,*a1(OXVEL),L
;	move	a0,*a1(OYVEL),L
;	move	a0,*a1(OZVEL),L
;	dsj	a3,#velini_lp
;
;	SLEEPK	1
;
;	movk	1,a0
;	move	a0,@HALT

	movk	3,a10
	CREATE0	doalert_snd

	move	@game_time,a0,L
	jaz	SUCIDE

	movi	#ln0_setup,a2
	calla	setup_message

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	#str_goaltend,a4
	calla	print_string_C2


	CREATE0	flash_bigtxt
	move	a0,a9

;	movk	3,a10
;	CREATE0	doalert_snd

	SLEEP	TSEC*2

	move	a9,a0
	calla	KILL

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

;	clr	a0
;	move	a0,@HALT

	DIE


#ln0_setup
	RJR_STR	omlgmd_ascii,12,2,200,120-44/2,LGMDRED2,0

#str_goaltend
	.string	"GOAL TENDING",0
	.even


#*******************************
* Control players for taking the ball out (Process)
* A11=Team who gets ball (0=1, !0=2)

	STRUCTPD
	WORD	ptob_pball	;Plyr # (0-3) who gets ball
	WORD	ptob_pball2	;P# who gets ball passed to him


 SUBR	plyr_takeoutball

;	move	@ballpnumshot,@ballpnum	;DEBUG
;	move	@ballpnumshot,a2
;	sll	5,a2			;*32
;	addi	plyrproc_t,a2
;	move	*a2,a1,L
;	clr	a0
;	move	a0,*a1(plyr_dribmode)	;Reset dribble
;	movi	-1,a0
;	move	a0,@inbound
;	DIE


	movi	TOB_PID,a0		;Kill any other plyr_takeoutball
	move	a0,*a13(PROCID)
	calla	KIL1C

	movk	8,a0
	move	a0,@ballsclastp

	movi	TSEC+20,a0
	callr	plyr_setshtdly
	clr	a0
	move	a0,@P1CTRL,L			;clear p1 & p2
	move	a0,@P3CTRL,L			;p3 & p4

	SLEEPK	1

	movi	-1,a0
	move	a0,@ballpnum
	move	a0,@ballpnumlast


	movk	1,a0
	callr	plyr_setac

	clr	a0			;Clr staggers
	movi	plyr_stagcnt,a1
	callr	plyr_setprocword


	movi	plyrproc_t,a0
	clr	a1
	clr	a2
	move	@PSTATUS,a3
	movk	2,a9
	move	a11,a11
	jrz	#t1
	addi	32*2,a0
	movk	1,a1
	movk	2,a2
	srl	2,a3
	clr	a9
#t1
	move	*a0+,a8,L		;A8=*Proc of plyr who gets ball
	move	*a0+,a7,L
	move	a1,@inbound		;Inbounding team (0-1)

	move	a3,a3			;if human and CPU
	jrz	#no_players		;always make CPU
	cmpi	011b,a3			;pass ball to human
	jreq	#two_players
	andi	1,a3
	jrz	#1st
	jruc	#2nd

#two_players
#no_players
	move	*a8(plyr_balldist),a0
	move	*a7(plyr_balldist),a1

	cmp	a1,a0
	jrle	#1st			;Closer?
#2nd
	move	a7,a8
	addk	1,a2			;2nd in team
#1st
	move	a2,*a13(ptob_pball)
	XORK	1,a2
	move	a2,*a13(ptob_pball2)


	movi	TSEC*3,a10		;>Get ball
#gblp1
	movi	-1,a0
	move	a0,@ballpnum
	move	a0,@ballpnumlast

	SLEEPK	1

	callr	plyrtob_moveo3

	move	@ballobj_p,a3,L
	move	*a3(OXPOS),a0
	addk	6,a0
	move	*a3(OZPOS),a1
	move	*a13(ptob_pball),a2
	callr	plyrtob_seekxy
	jrz	#atball
	dsj	a10,#gblp1
	jruc	#atball2
#atball
	move	*a8(plyr_jmpcnt),a0
	jrnz	#gblp1
#atball2

	clr	a0
	move	a0,*a8(plyr_shtdly)

	movi	TSEC*1,a10		;>Get ball
#gblp2
	movi	-1,a0
	move	a0,@ballpnum
	move	a0,@ballpnumlast
	SLEEPK	1
	move	@ballpnum,a0
	jrn	#gbcnt2
	move	*a13(ptob_pball),a2
	cmp	a0,a2
	jreq	#gotball
#gbcnt2
	callr	plyrtob_moveo3
	move	@ballobj_p,a3,L
	move	*a3(OXPOS),a0
	addk	6,a0
	move	*a3(OZPOS),a1
	move	*a13(ptob_pball),a2
	callr	plyrtob_seekxy
	dsj	a10,#gblp2

#gotball
	move	*a13(ptob_pball),a0
	move	a0,@ballpnum
	clr	a0
	move	a0,*a8(plyr_dribmode)


	movi	TSEC*3,a10		;>Run out of bounds

#outlp
	SLEEPK	1

	callr	plyrtob_moveo3

	movi	-355,a0
	move	a11,a11
	jrz	#outl			;Team2 on def
	neg	a0
#outl	addi	WRLDMID,a0
	move	a0,a3
	movi	CZMID-20,a1
	move	*a13(ptob_pball),a2
	move	a2,@ballpnum
	callr	plyrtob_seekxy
	jrz	#outofb
	dsj	a10,#outlp

#outofb

	movi	-1,a0
	move	a0,*a8(plyr_dribmode)
	calla	call_scores


	movi	TSEC*3,a10		;>Wait for other 3 to get in place

#wtlp	SLEEPK	1
	callr	plyrtob_moveo3
	jrz	#inpos
	dsj	a10,#wtlp
#inpos
	SLEEPK	30

	movk	20,a0
	move	a0,@last_name_time	;don't call pass on inbound

	move	*a13(ptob_pball),a10	;>Pass with turbo
	sll	4,a10			;*16
	addi	P1CTRL,a10
	movi	(BUT2_M|BUT3_M)<<8|BUT2_M|BUT3_M,a0
	move	a0,*a10

	move	*a13(ptob_pball),a0
	move	a0,@ballpnum
	movi	TSEC*2,a2		;>Wait for pass to start
#waitp	PUSHP	a2
	SLEEPK	1
	PULLP	a2
	move	*a8(plyr_seqflgs),a0
	btst	PASS_B,a0
	jrnz	#passing
	dsj	a2,#waitp
#passing

	clr	a0
	move	a0,*a10
	movi	-1,a0
	move	a0,@inbound		;Inbounding off

	SLEEPK	30
#runinlp
	SLEEPK	1
	movi	-345,a0
	move	a11,a11
	jrz	#outl2			;Team2 on def
	neg	a0
#outl2	addi	WRLDMID,a0
	movi	CZMID-20,a1
	move	*a13(ptob_pball),a2
	callr	plyrtob_seekxy
	jrnz	#runinlp


plyr_tobend
	move	a11,a0
	calla	shot_clock		;New 24
	clr	a0
	move	a0,@clock_active	;Start game clock again
	move	a0,@plyrinautorbnd	;In case seq didn't clr
	move	a0,@ballflash
	move	a0,@pass_off
	move	a0,@steals_off
	move	a0,@slamming

	callr	plyr_setac

	clr	a0			;Clr staggers
	movi	plyr_stagcnt,a1
	callr	plyr_setprocword

	clr	a0
	movi	plyr_d_cflgs,a1
	callr	plyr_setprocword

	.ref	drone_setuptob
	calla	drone_setuptob

	DIE


#*****************************************************************************
* Control players for taking the ball out (Process)
* Teleport players to their positions
* A11=Team who gets ball (0=1, !0=2)

	.asg	60h,FACE_LEFT
	.asg	20h,FACE_RIGHT

 SUBR	plyr_takeoutball2

	movi	TOB_PID,a0		;Kill any other plyr_takeoutball
	move	a0,*a13(PROCID)
	calla	KIL1C

	movk	8,a0
	move	a0,@ballsclastp

	movk	1,a0
	callr	plyr_setac

	clr	a0
	move	a0,@P1CTRL,L			;clear p1 & p2
	move	a0,@P3CTRL,L			;p3 & p4

	clr	a0
	move	a0,@WORLDTLY,L
	movi	[WRLDMID-200-MAX_VIEW1,0],a1
	clr	a2				;player 1 has ball
	movi	#t1_setup_table,a10
	move	a11,a11
	jrz	#setib
	movk	1,a0
	movi	[WRLDMID-200+MAX_VIEW1,0],a1
	movk	3,a2				;player 4 has ball
	movi	#t2_setup_table,a10
#setib	move	a0,@inbound			;Inbounding team
	move	a1,@WORLDTLX,L
	subi	[WRLDMID-200,0],a1
	move	a1,@gndx,L
	move	a2,@ballpnum
	movi	-1,a0
	move	a0,@ballpnumlast
	move	a2,*a13(ptob_pball)		;0,3
	move	a2,a0
	XORK	1,a0
	move	a0,*a13(ptob_pball2)		;1,2


	PUSH	a13
	sll	5,a2				;x 32 bits
	movi	plyrobj_t,a8
	add	a2,a8
	move	*a8,a8,L			;*Plyr obj
	addi	plyrproc_t,a2
	move	*a2,a13,L			;*Plyr process
	callr	plyr_setballxyz
	PULL	a13

	movk	4,a14
#init_loop
	PUSH	a14
	move	*a10+,a0			;player (0-3)
	move	*a10+,a4
	sll	16,a4				;player Z VAL
	move	*a10+,a5
	sll	16,a5				;player X VAL
	move	*a10+,a7			;player direction (right)
	callr	plyr_init
	PULL	a14
	dsj	a14,#init_loop

	SLEEP	1*60

	movk	20,a0
	move	a0,@last_name_time	;don't call pass on inbound

	move	*a13(ptob_pball),a10	;>Pass with turbo
	sll	4,a10			;*16
	addi	P1CTRL,a10
	movi	(BUT2_M|BUT3_M)<<8|BUT2_M|BUT3_M,a0
	move	a0,*a10

#waitp	SLEEPK	1
	move	*a8(plyr_seqflgs),a0
	btst	PASS_B,a0
	jrz	#waitp

	clr	a0
	move	a0,*a10
	movi	-1,a0
	move	a0,@inbound		;Inbounding off

	SLEEPK	30
#runinlp
	SLEEPK	1
	movi	-345,a0
	move	a11,a11
	jrz	#outl2			;Team2 on def
	neg	a0
#outl2	addi	WRLDMID,a0
	movi	CZMID-20,a1
	move	*a13(ptob_pball),a2
	callr	plyrtob_seekxy
	jrnz	#runinlp

	jruc	plyr_tobend



#t1_setup_table
;normal setup (left)
	.word	0,CZMID-20,	WRLDMID-365,	20h	;ply,z,x,face
	.word	1,CZMID+15,	WRLDMID-280,	60h	;ply,z,x,face
	.word	2,CZMID-50,	WRLDMID-160,	60h	;ply,z,x,face
	.word	3,CZMID+70,	WRLDMID-160,	60h	;ply,z,x,face

#t2_setup_table
;normal setup	(right)
	.word	3,CZMID-20,	WRLDMID+365,	60h	;ply,z,x,face
	.word	2,CZMID+15,	WRLDMID+280,	20h	;ply,z,x,face
	.word	0,CZMID-50,	WRLDMID+160,	20h	;ply,z,x,face
	.word	1,CZMID+70,	WRLDMID+160,	20h	;ply,z,x,face


#*****************************************************************************
* Clear out plyr variables
*	a0 = player number in (0-3)
*	a4 = player Z VAL
*	a5 = player X VAL
*	a7 = player direction	(00h - 7fh)

 SUBR	plyr_init

	PUSH	a8,a10,a13

	sll	5,a0			;x 32 bits
	movi	plyrproc_t,a13
	add	a0,a13
	move	*a13,a13,L		;*plyr process

	addi	plyrobj_t,a0
	move	*a0,a8,L		;*plyr object

	move	a4,*a8(OZVAL),L
	callr	anipt_getsclxy		;a0 = anix, a1 = aniy
	move	a0,*a8(OXANI),L
	neg	a1
	move	a1,*a8(OYVAL),L
	sub	a0,a5
	move	a5,*a8(OXVAL),L

	movk	STND_SEQ,a0
	callr	plyr_setseq

	clr	a0

	move	a0,*a8(OXVEL),L
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OZVEL),L

	move	a0,*a13(plyr_jmpcnt)
	move	a0,*a13(plyr_dribmode)
	move	a0,*a13(plyr_offscrn)
	move	a0,*a13(plyr_d_cflgs)
	move	a0,*a13(plyr_hangcnt)
	move	a0,*a13(plyr_nojoy)
	move	a0,*a13(plyr_shtdly)
	move	a0,*a13(plyr_passbtime)
	move	a0,*a13(plyr_rcvpass)
	move	a0,*a13(plyr_ownball)
	move	a0,*a13(plyr_stagcnt)

	movi	-1,a0
	move	a0,*a13(plyr_newdir)

	movk	1,a0
	move	a0,*a13(PA10),L		;reset sequence wake count

	PULL	a8,a10,a13
	rets



#*****************************************************************************
* Control players for taking the ball out (Process)
* A11=Team who gets ball (0=1, !0=2)

 SUBR	plyr_takeoutball3

	movi	TOB_PID,a0		;Kill any other plyr_takeoutball
	move	a0,*a13(PROCID)
	calla	KIL1C

	movk	8,a0
	move	a0,@ballsclastp

	movk	25,a0
	callr	plyr_setshtdly

	SLEEPK	1

	movi	-1,a0
	move	a0,@ballpnum
	move	a0,@ballpnumlast


	clr	a0
	move	a11,a11
	jrz	#setib
	movk	1,a0
#setib	move	a0,@inbound		;Inbounding team


	movk	1,a0
	callr	plyr_setac

	clr	a0			;Clr staggers
	movi	plyr_stagcnt,a1
	callr	plyr_setprocword


	clr	a2
	movk	2,a9			;A9=1st p# of team on defense
	movi	plyrproc_t,a0
	move	a11,a11
	jrz	#t1
	movk	2,a2
	clr	a9
	addi	32*2,a0
#t1
	move	*a0+,a8,L		;A8=*Proc of plyr who gets ball
	move	*a0+,a7,L
	move	*a8(plyr_hpdist),a0
	move	*a7(plyr_hpdist),a1
	cmp	a1,a0
	jrle	#1st			;Closer?
	move	a7,a8
	addk	1,a2			;2nd in team
#1st
	move	a2,*a13(ptob_pball)
	move	a2,@ballpnum
	XORK	1,a2
	move	a2,*a13(ptob_pball2)
	movi	-1,a0
	move	a0,@ballpnumlast

#outlp
	SLEEPK	1

	move	*a13(ptob_pball),a0
	move	a0,@ballpnum
	clr	a0
	move	a0,*a8(plyr_dribmode)

	callr	plyrtob_moveo3

	movi	-355,a0
	move	a11,a11
	jrz	#outl			;Team2 on def
	neg	a0
#outl	addi	WRLDMID,a0
	movi	CZMID-20,a1
	move	*a13(ptob_pball),a2
	callr	plyrtob_seekxy
	jrnz	#outlp


	movi	TSEC*3,a10		;>Wait for other 3 to get in place

#wtlp	SLEEPK	1
	callr	plyrtob_moveo3
	jrz	#inpos
	dsj	a10,#wtlp
#inpos

	SLEEP	60

	move	*a13(ptob_pball),a10	;>Pass with turbo
	sll	4,a10			;*16
	addi	P1CTRL,a10
	movi	(BUT2_M|BUT3_M)<<8|BUT2_M|BUT3_M,a0
	move	a0,*a10


#waitp	SLEEPK	1
	move	*a8(plyr_seqflgs),a0
	btst	PASS_B,a0
	jrz	#waitp

	clr	a0
	move	a0,*a10

	movi	-1,a0
	move	a0,@inbound		;Inbounding off

	SLEEPK	30
#runinlp
	SLEEPK	1
	movi	-345,a0
	move	a11,a11
	jrz	#outl2			;Team2 on def
	neg	a0
#outl2	addi	WRLDMID,a0
	movi	CZMID-20,a1
	move	*a13(ptob_pball),a2
	callr	plyrtob_seekxy
	jrnz	#runinlp

	jruc	plyr_tobend



********************************
* Set new autoctrl value
* A0=autoctrl #
* Trashes scratch

 SUBRP	plyr_setac

	movi	plyrproc_t,a14
	movk	4,b0
#aclp	move	*a14+,a1,L
	move	a0,*a1(plyr_autoctrl)
	dsj	b0,#aclp
	rets

#*******************************
* Set new shtdly value
* A0=shtdly #
* Trashes scratch

 SUBR	plyr_setshtdly

	movi	plyrproc_t,a14
	movk	4,b0
#aclp	move	*a14+,a1,L
	move	a0,*a1(plyr_shtdly)
	dsj	b0,#aclp
	rets

#*******************************
* Set word in plyr's proc
* A0=#
* A1=Proc offset
* Trashes scratch

 SUBRP	plyr_setprocword

	move	a2,b1
	movi	plyrproc_t,a14
	movk	4,b0
#aclp	move	*a14+,a2,L
	add	a1,a2
	move	a0,*a2
	dsj	b0,#aclp
	move	b1,a2
	rets



#*******************************
* Move the other 3 guys who aren't getting the ball
* A9=1st pnum of team on defense (0/2)
* A11=Team who gets ball (0=1, !0=2)
* >A0=0 if all players in position (Pass CC)
* Trashes scratch, A2-A4

 SUBRP	plyrtob_moveo3

	movi	-150,a0			;>Send defenders to their spot
	movi	-270,a4
	move	a11,a11
	jrz	#t2			;Team1 gets?
	neg	a0
	neg	a4
#t2	addi	WRLDMID,a0
	move	a0,a3
	movi	CZMID-50,a1
	move	a9,a2
	callr	plyrtob_seekxy
	PUSH	a0

	move	a3,a0
	movi	CZMID+70,a1
	addk	1,a2
	callr	plyrtob_seekxy
	PUSH	a0

	move	a4,a0			;>Send teammate to spot
	addi	WRLDMID,a0
	movi	CZMID+10,a1
	move	*a13(ptob_pball2),a2
	callr	plyrtob_seekxy
	PULL	a1
	or	a1,a0
	PULL	a1
	or	a1,a0

	rets


#*******************************
* Push stick to move plyr towards an XZ location
* A0=X to seek
* A1=Z
* A2=Player # (0-3)
* >A0=Joy bits set or 0 (Pass CC)
* Trashes scratch

 SUBRP	plyrtob_seekxy

	PUSH	a2,a8,a11

	move	a0,b0

	sll	4,a2			;*16
	move	a2,a11
	addi	P1CTRL,a11
	sll	1,a2
	addi	plyrobj_t,a2
	move	*a2,a8,L


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
	move	a0,a0
	jrnz	#x

	move	b0,a14
	move	*a8(OXANI+16),a2
	sub	a2,a14
	move	a14,*a8(OXPOS)

	move	a1,*a8(OZPOS)

	move	*a8(OXVEL),a1,L
	sra	1,a1
	move	a1,*a8(OXVEL),L
	move	*a8(OZVEL),a1,L
	sra	1,a1
	move	a1,*a8(OZVEL),L

#x	PULL	a2,a8,a11
	move	a0,a0
	rets


 .if 0

#*******************************
* Control players for free throws (Process)
* A11=Team who scored (0=2, !0=1)

	STRUCTPD
	WORD	pft_pball	;Plyr # (0-3) who gets ball
	WORD	pft_pball2	;P# who gets ball passed to him
	APTR	pft_bbobj	;*Backboard/crowd object


 SUBR	plyr_freethrow

	jruc	plyr_takeoutball

	movi	TSEC,a10		;>Let shot finish
#lp	movi	-1,a0
	move	a0,@ballpnum
	SLEEPK	1
	dsj	a10,#lp


	movi	[20,0],a0
	movi	[20,0],a1
;	movi	ftbackbd,a2
	movi	[500,0],a3		;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(pft_bbobj),L


	movk	1,a0
	callr	plyr_setac

	clr	a2
	movk	2,a9			;A9=1st p# of team on defense
	movi	plyrproc_t,a0
	move	a11,a11
	jrz	#t1
	movk	2,a2
	clr	a9
	addi	32*2,a0
#t1
	move	*a0+,a8,L		;A8=*Proc of plyr who gets ball
	move	*a0+,a7,L
	move	*a8(plyr_balldist),a0
	move	*a7(plyr_balldist),a1
	cmp	a1,a0
	jrle	#1st			;Closer?
	move	a7,a8
	addk	1,a2			;2nd in team
#1st
	move	a2,*a13(pft_pball)
	XORK	1,a2
	move	a2,*a13(pft_pball2)


	movi	TSEC*4,a10		;>Get ball

#gblp
	movi	-1,a0
	move	a0,@ballpnum
	SLEEPK	1

	callr	plyrtob_moveo3

	move	@ballobj_p,a3,L
	move	*a3(OXPOS),a0
	addk	6,a0
	move	*a3(OZPOS),a1
	move	*a13(pft_pball),a2
	callr	plyrtob_seekxy

	move	@ballpnum,a0
	jrn	#gbcnt
	cmp	a0,a2
	jreq	#gotball

#gbcnt	dsj	a10,#gblp

#gotball
	move	*a13(pft_pball),a0
	move	a0,@ballpnum


	movi	TSEC*3,a10		;>Run out of bounds

#outlp
	SLEEPK	1

	callr	plyrtob_moveo3

	movi	-370,a0
	move	a11,a11
	jrz	#outl			;Team2 on def
	neg	a0
#outl	addi	WRLDMID,a0
	move	a0,a3
	movi	CZMID-20,a1
	move	*a13(pft_pball),a2
	callr	plyrtob_seekxy
	jrz	#outofb

;	move	*a8(PA8),a2,L		;Get * obj
;	move	*a2(OXPOS),a0
;	move	*a2(OXANI+16),a14
;	add	a14,a0
;	abs	a0
;	abs	a3
;	sub	a0,a3
;	subk	20,a3
;	jrlt	#outofb

	dsj	a10,#outlp

#outofb
	movi	TSEC*3,a10		;>Wait for other 3 to get in place

#wtlp	SLEEPK	1
	callr	plyrtob_moveo3
	jrz	#inpos
	dsj	a10,#wtlp
#inpos

	move	*a13(pft_pball),a10	;>Pass with turbo
	sll	4,a10			;*16
	addi	P1CTRL,a10
	movi	>60,a0
	move	a0,*a10

	SLEEPK	10
	clr	a0
	move	a0,*a10

	SLEEP	40

	clr	a0
	callr	plyr_setac

	move	*a13(pft_bbobj),a0,L
	calla	DELOBJ

	DIE

#*******************************
* Create ground alignment dots for debugging (Process)

 SUBR	gnd_aligndots

	.ref	hoopl_t,hoopr_t

	movi	hoopl_t,a11		;>Setup left hoop dots
	jruc	#hlstrt
#hllp
	sll	16,a0
	move	*a11+,a1		;Y
	sll	16,a1
	move	*a11+,a3		;Z
	addi	300,a3
	movi	alignimg_t,a2
	movi	>800c|M_NOCOLL|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	movi	>101,a0
	move	a0,*a8(OCONST)
	movi	-300,a0
	move	a0,*a8(OMISC)		;Z offset
	addk	16,a11
#hlstrt	move	*a11+,a0		;X
	jrnz	#hllp			;!End?


	movi	hoopr_t,a11		;>Setup rgt hoop dots
	jruc	#hrstrt
#hrlp
	sll	16,a0
	move	*a11+,a1		;Y
	sll	16,a1
	move	*a11+,a3		;Z
	addi	300,a3
	movi	alignimg_t,a2
	movi	>800c|M_NOCOLL|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	movi	>101,a0
	move	a0,*a8(OCONST)
	movi	-300,a0
	move	a0,*a8(OMISC)		;Z offset
	addk	16,a11
#hrstrt	move	*a11+,a0		;X
	jrnz	#hrlp			;!End?


	movi	#init_t,a11		;>Setup gnd dot images
	jruc	#5
#lp
	addi	200,a0
	sll	16,a0
	clr	a1			;Y
	move	*a11+,a3		;Z
	movi	alignimg_t,a2
	movi	>800c|M_NOCOLL|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	movi	>101,a0
	move	a0,*a8(OCONST)
#5	move	*a11+,a0		;X
	cmpi	4000,a0
	jrne	#lp			;!End?

	move	*a8(OPAL),a9
	sll	8,a9
	addk	1,a9			;Color 1
	clr	a10
#plp
	move	a10,a0
	addi	#color_t,a0
	move	a9,a1
	movk	1,a2			;#Colors
	calla	pal_set
	SLEEPK	10
	addk	16,a10
	sll	32-6,a10		;0-3 color #
	srl	32-6,a10
	jruc	#plp


#z0	.equ	GZBASE
#z1	.equ	1000
#z2	.equ	1095
#z3	.equ	1190
#z4	.equ	1284
#z5	.equ	GZMAX

#init_t
;	.word	-350,#z0, 0,#z0, 350,#z0
;	.word	-350,#z1, 0,#z1, 350,#z1
;	.word	-350,#z2, 0,#z2, 350,#z2
;	.word	-350,#z3, 0,#z3, 350,#z3
;	.word	-350,#z4, 0,#z4, 350,#z4
;	.word	-350,#z5, 0,#z5, 350,#z5
	.word	4000

#color_t
	COLORW	0,0,0, 0,16,0, 0,31,0, 0,16,0

; .endif


********************************
;	.if	DEBUG

alignimg_t
	.word	1,1,0,0
	.long	0
	.word	>1000
	.long	#test_p


#test_p	.word	1, 0

********************************
* Start an alignment dot for a player
* A13=*Plyr proc
* Trashes scratch

 SUBRP	plyr_getgndaligndot

	PUSH	a2,a3,a4,a5,a6,a7,a8

	clr	a0			;X
	clr	a1			;Y
	movi	CZMIN,a3		;Z
	movi	alignimg_t,a2
	movi	>800c|M_NOCOLL|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	movi	>101,a0
	move	a0,*a8(OCONST)
	movi	-300,a0
	move	a0,*a8(OMISC)		;Z offset

	move	a8,*a13(plyr_aligndot_p),L

	PULL	a2,a3,a4,a5,a6,a7,a8
	rets


********************************
* Set alignment dot to players position
* A8=*Plyr obj
* A13=*Plyr proc
* Trashes scratch

 SUBRP	plyr_setgndaligndot

	PUSH	a2,a3,a4,a5,a6,a7

	callr	anipt_getsclxy
	move	*a8(OXVAL),a14,L
	add	a14,a0
	move	*a13(plyr_aligndot_p),a2,L
	move	a0,*a2(OXVAL),L

	move	*a8(OZPOS),a14
	addi	300,a14
	move	a14,*a2(OZPOS)

	PULL	a2,a3,a4,a5,a6,a7
	rets


;	.endif
 .endif


#*******************************
* Get dir for object to face an XZ
* A6=Dest X
* A7=Dest Z
* A8=*Source obj
* >A0=0-127
* Trashes A0-A2,A14

 SUBRP	seekdir_obxz128

	move	*a8(OXPOS),a0		;Get SX
	move	*a8(OXANI+16),a14
	add	a14,a0
	move	*a8(OZPOS),a1		;Get SZ

********************************
* Get dir for src XY to face an XY
* A0=Src X
* A1=Src Y
* A6=Dest X
* A7=Dest Y
* >A0=0-127
* Trashes A0-A2,A14

 SUBR	seekdir_xyxy128

	clr	a2			;Octant 0-1
	sub	a6,a0			;A0=SrcX-DestX
	jrgt	#100
	abs	a0
	sub	a7,a1			;A1=SrcY-DestY
	jrnn	#oct01
	movk	8,a2			;Oct 2-3
	abs	a1
	jruc	#160

#100	movk	16,a2			;Oct 4-5
	sub	a7,a1			;A1=SrcY-DestX
	abs	a1
	jrnn	#200
	movk	16+8,a2			;Oct 6-7
#160	SWAP	a0,a1

#200	sll	2,a2			;Oct*4
#oct01	clr	a14
	cmp	a1,a0			;>Cmp slope
	jrhs	#300

	srl	2+2,a1			;Bigger/16
	jrnz	#250
	jruc	#x
#lp1	addk	1,a2			;Next 1/16 oct
	add	a1,a14			;+1/16
#250	cmp	a0,a14
	jrlo	#lp1
	jruc	#x

#300	addk	31,a2			;End of next octant
	srl	2+2,a0			;Bigger/16
	jrnz	#350
	jruc	#x
#lp2	subk	1,a2			;Next 1/16 oct
	add	a0,a14			;+1/16
#350	cmp	a1,a14
	jrlo	#lp2


#x	movi	>7f,a0
	and	a2,a0
	rets




#*******************************
* Get dir and distance from object to object
* A0=*Dest obj
* A8=*Source obj
* >A0=0-127
* >A1=Distance
* Trashes scratch, A2,A6,A7

 SUBRP	seekdirdist_obob128

	move	*a0(OXPOS),a6		;Get SX
	move	*a0(OXANI+16),a14
	add	a14,a6
	move	*a0(OZPOS),a7		;Get SZ

#*******************************
* Get dir and distance from object to XZ
* A6=Dest X
* A7=Dest Z
* A8=*Source obj
* >A0=0-127
* >A1=Distance
* Trashes scratch, A2

 SUBR	seekdirdist_obxz128

	move	*a8(OXPOS),a0		;Get SX
	move	*a8(OXANI+16),a14
	add	a14,a0
	move	*a8(OZPOS),a1		;Get SZ


	clr	a2			;Octant 0-1
	sub	a6,a0			;A0=SrcX-DestX
	jrgt	#100
	abs	a0
	sub	a7,a1			;A1=SrcY-DestY
	jrnn	#oct01
	movk	8,a2			;Oct 2-3
	abs	a1
	jruc	#160

#100	movk	16,a2			;Oct 4-5
	sub	a7,a1			;A1=SrcY-DestX
	abs	a1
	jrnn	#200
	movk	16+8,a2			;Oct 6-7
#160	SWAP	a0,a1

#200	sll	2,a2			;Oct*4
#oct01	clr	a14
	cmp	a1,a0			;>Cmp slope
	jrhs	#300

	move	a0,b0			;Save distance
	move	a1,b1

	srl	2+2,a1			;Bigger/16
	jrnz	#250
	jruc	#x
#lp1	addk	1,a2			;Next 1/16 oct
	add	a1,a14			;+1/16
#250	cmp	a0,a14
	jrlo	#lp1
	jruc	#x

#300	move	a0,b1			;Save distance
	move	a1,b0

	addk	31,a2			;End of next octant
	srl	2+2,a0			;Bigger/16
	jrnz	#350
	jruc	#x
#lp2	subk	1,a2			;Next 1/16 oct
	add	a0,a14			;+1/16
#350	cmp	a1,a14
	jrlo	#lp2

#x					;>Calc distance (long+short/2.667)
	srl	1,b0			;Shorter/2
	add	b0,b1
	srl	2,b0			;Shorter/8
	sub	b0,b1
	move	b1,a1

	movi	>7f,a0
	and	a2,a0
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
* Quickly produce a random # in range 0-X
* A0=X
* >A0=Random # (0 to A0) (No CC)
* Trashes scratch

 SUBR	rndrng0

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