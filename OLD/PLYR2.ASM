**************************************************************
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		9/17/92
*
* Modified:		Shawn Liptak, 10/5/92	-Split from plyr.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/17/93 17:54
**************************************************************
	.file	"plyr2.asm"
	.title	"basketball player code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"audit.equ"
	.include	"imgtbl.glo"
	.include	"game.equ"
	.include	"shawn.hdr"		;Macros
	.asg		0,SEQT
	.include	"plyr.equ"
	.include	"ball.tbl"


;sounds external

	.ref	snd_play1ovr
	.ref	snd_play1ovrp


facial_snd	.word	>f990,93,>81ee,0	;Delivers the
ohmy		.word	>f981,98,>81ea,0	;oh my!
stealsb		.word	>f990,80,>81f3,0	;steals the ball
intercept	.word	>f991,59,>81a9,0	;Intercepted
intostands	.word	>f970,74,>81c7,0	;into the stands
bounce_snd	.word	>fc80,10,>8129,0	;Ball bounce
swish_snd	.word	>fca0,30,>8112,0	;Ball swish
dunk_snd	.word	>fca4,30,>8120,0	;Dunk

;fc80 was old priority!
miss_snd	.word	>fc90,10,>813b,0	;Ball hits rim
miss2_snd	.word	>fd90,10,>8139,0	;Ball hits rim
miss3_snd	.word	>fc90,10,>813a,0	;Ball hits rim
missd1_snd	.word	>fc90,>8,>8128,0	;Cartoon part of missed dunk

hitbboard_snd	.word	>fcf5,05,>8138,0	;Hit backboard
swat_snd	.word	>fd94,15,>8157,0	;Swat ball (Steals & blocks)
swat3_snd	.word	>fd94,18,>8155,0
cheer_snd	.word	>f898,40,>8144,0	;Quick cheer
cheer1_snd	.word	>fd84,100,>8111,0	;Long cheer
cheer2_snd	.word	>f894,100,>8144,0	;Long cheer
cheer3_snd	.word	>fc84,130,>814e,0	;Long cheer
boo1_snd	.word	>f884,120,>814a,0	;Boo
steal_snd	.word	>fbf7,>8,>8093,0	;Steal
anncr3_snd	.word	>f1f8,100,>8182,0	;And it's good
explode_snd	.word	>fcf9,250,>8153,0	;Backboard smash
;glass_snd	.word	>fdf9,120,>815d,0	;Backboard glass breakage

;RJR
;heatup_snd	.word	>f998,60,>8168,0	;He's heating up
;onfire_snd	.word	>f998,74,>8169,0	;He's on fire
onfire_snd	.word	>f9fe,74,>8169,0	;He's on fire
nogood		.word	>f981,58,>81f1,0	;NO GOOD!

;symbols externally defined

	.ref	plyr_maxpower
	.ref	shot_percentage
	.ref	gmqrtr,FIREFALP
	.ref	w1blok3,w2blok3,w4blok3,w5blok3
	.ref	w1blok2,w2blok2,w4blok2,w5blok2
	.ref	shot_distance

	.ref	AUD1,AUD
	.ref	nogood_speech,GAMSTATE
	.ref	speech_playovrp

	.ref	pushed_speech
	.ref	rejected_speech
	.ref	rejected_dnk_speech
	.ref	rebound_speech
	.ref	intercepted_speech
	.ref	stolen_speech

	.ref	rebound_delay
	.ref	pushing_delay
	.ref	team1

	.ref	shot_type
	.ref	shoots_speech,scored_speech

	.ref	steals_off
	.ref	pass_off
	.ref	RNDRNGS,PSTATUS

	.ref	game_time
	.ref	scores,prt_top_scores
	.ref	score_add,score_showtvpanel
	.ref	stick_number
	.ref	sclockx,sc_proc
;	.ref	movie_test
	.ref	net_ani
	.ref	arw_on1plyr

	.ref	pal_getf

	.ref	PCNT
	.ref	HALT
	.ref	scale58_t,scale66_t,scale72_t
	.ref	gndx
	.ref	RNDPER
	.ref	SHAKER
	.ref	GET_ADJ

	.ref	plyrobj_t,plyrproc_t
	.ref	P1DATA,P2DATA,P3DATA,P4DATA
	.ref	plyrcharge
	.ref	plyrpasstype
	.ref	plyrairballoff
	.ref	ball_smokepuff

	.ref	seekdir_xyxy128
	.ref	seekdirdist_obxz128
	.ref	plyr_setseq,plyr_takeoutball
;	.ref	plyr_freethrow
	.ref	plyr_goaltending
	.ref	plyr_setshtdly

	.ref	inc_player_stat


;symbols defined in this file

	.def	ball101

	.def	hoopl_t,hoopr_t


;uninitialized ram definitions

	BSSX	plyrnumonfire	,16	;Plyr # on fire (0-3) or Neg
	BSSX	ballobj_p	,32	;* basketball obj
	BSSX	ballpnum	,16	;Plyr # who owns (0-3) or Neg
	BSSX	ballpnumlast	,16	;Last plyr who owned ^ (0-3) or neg if loose
	BSSX	ballpnumshot	,16	;Last plyr who shot (0-3)
	BSSX	ballsclastp	,16	;Last plyr who owned (0-3) for shot clock

					;Keep in order!
	BSSX	ballpnumscored	,16	;Last plyr who scored (0-3) or neg
	BSSX	ballnumscored	,16	;# times last plyr scored

	BSSX	ballfree	,16	;!0=Ball free to move
	BSSX	ballscorezhit	,16	;!0=Ball hit score zone, +=Top z, -=Scored

	BSSX	ballrimhitcnt	,16	;# times rim hit since last shot
	BSSX	ballbbhitcnt	,16	;# times backboard hit since last shot

	BSSX	ballptsforshot	,16	;Point value for current shot (1-3)
	BSSX	ballprcv_p	,32	;*Plyr proc who gets this pass or 0
	BSSX	ballpasstime	,16	;# ticks since passed
	BSSX	ballgoaltcnt	,16	;+=Goaltend cnt down
	BSSX	ballflash	,16	;!0=Ball flashing
	BSSX	inbound		,16	;Inbounding team (0-1) or Neg
	BSSX	bbshatter	,16	;!0=Backboard shattered (+=L, -=R)

	BSSX	cntl_team	,16	;Team in control (0,1,-1)
	BSSX	cntl_team_last	,16	;Team in control (0,1,-1)
	BSSX	scrl_divs_cur	,16	;Scroller current divisor
	BSSX	scrl_divs_dest	,16	;^ destination divisor

;	.bss	movieshown	,16	;!0=Movie has been played

	BSSX	slamming	,16	;!0=Ball going into rim from dunking

	BSSX	t1dunkcnt	,16	;+=# dunks since start of game (In order)
	.bss	t2dunkcnt	,16	;^ -=# dunks till we can break board

	BSSX	brick_count	,4*16	;# bricks each player has thrown up
	BSSX	last_power	,16	;Player pushing has this power

	BSSX	original_names	,4*32	;Names of original players in game
	BSSX	fire_flags	,16	;1 if this player has been on fire (1,2,4,8)

;equates for this file


	.text


#*******************************
* Ball main code (Process)

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

push1_snd	.word	>fd85,15,>8160,0	;Push ugh

 SUBR	ball_main


	move	a13,a1			;>Clr PDATA & PSDATA areas
	addi	PDATA,a1
	movi	(PRCSIZ-PDATA)/16,a2
	clr	a0
#clrpd	move	a0,*a1+
	dsj	a2,#clrpd


	move	@WORLDTLX+16,a0
	addi	200,a0
	sll	16,a0
	movi	[-80,0],a1		;In air
	movi	ball11,a2
	movi	CZMID,a3
	movi	DMAWNZ|M_3D|M_NOSCALE,a4
	movi	CLSENMY|TYPBALL,a5
	clr	a6
	movi	->20000,a7
	calla	BEGINOBJ2
	move	a8,@ballobj_p,L
	callr	ball_getshadow

	clr	a0
	move	a0,@ballpnumshot
	move	a0,@ballscorezhit
	move	a0,@ballgoaltcnt
	move	a0,@ballflash
	move	a0,@t1dunkcnt
	move	a0,@t2dunkcnt
	movi	-1,a0
	move	a0,@ballpnum
	move	a0,@ballpnumlast

;RJR
	move	a0,@brick_count,L
	move	a0,@brick_count+20h,L


	move	a0,@ballpnumscored

	move	a0,*a13(ball_zsznum)
	move	a0,@bbshatter
	movk	1,a0
	move	a0,@ballfree		;Free

;	movk	3,a0
;	move	a0,*a13(ball_numforfire)

	move	*a8(OIMG),a0,L
	move	*a0(IANIOFFX),*a13(ball_anix)

	movk	1,a10			;A10=Anim cntdn

	movi	DIVS_RATE1,a0
	move	a0,@scrl_divs_cur
	movi	DIVS_RATE2,a0
	move	a0,@scrl_divs_dest

	move	@WORLDTLX,a0,L
	subi	[WRLDMID-200,0],a0
	move	a0,@gndx,L

	SLEEPK	4			;Wait for others to establish data

;----------

#lp
	move	@HALT,a0
	jrnz	#halted


	move	@ballgoaltcnt,a0
	jrle	#skipgt
	subk	1,a0
	move	a0,@ballgoaltcnt
#skipgt

	clr	a14			;>Emit smoke if hot
	movi	-1,a2
	move	@ballnumscored,a0

	move	@ballpnumscored,a4
	move	@fire_flags,a3
	btst	a4,a3
	jrz	#normfire
;4 shots to get on fire if already on fire
	subk	4,a0
	jruc	#inhr

#normfire
	subk	3,a0
#inhr
	jrlt	#nothot			;Not enough?




;When testing dunks - PUT IN!
;	jruc	#nothot



	move	@ballpnumscored,a0
	move	a0,a2
	move	@ballpnum,a1
	jrn	#noownr

	move	@plyrnumonfire,a3
	cmp	a1,a3
	jrz	#nxt
	
	clr	a3
	move	a3,*a13(ball_onfire)
	jruc	#nothot
#nxt

	cmp	a0,a1
	jrne	#nothot
	sll	5,a1
	addi	plyrproc_t,a1
	move	*a1,a1,L
	move	*a1(plyr_seqflgs),a1
	btst	DUNK_B,a1
	jrnz	#hot2			;Dunking?
	jruc	#hotf
#noownr
	move	@plyrnumonfire,a3
	move	@ballpnumlast,a1
	srl	1,a1
	srl	1,a3
	cmp	a1,a3
	jrnz	#nothot
	
	move	@plyrnumonfire,a3
	move	@ballpnumshot,a1
	cmp	a1,a3
	jrz	#hot
	cmp	a0,a1
	jrne	#nota
	move	@ballprcv_p,a4,L
	jrz	#ahot
	move	*a4(plyr_num),a4
	cmp	a3,a4
	jrz	#nothot
	jruc	#hot
#nota
	move	@ballprcv_p,a4,L
	jrz	#nothot
	move	*a4(plyr_num),a4
	cmp	a3,a4
	jrnz	#hot
	jruc	#nothot

#ahot	cmp	a1,a3
	jrnz	#nothot
	
#hot
#hot2
	move	@PCNT,a0
	sll	32-1,a0
	jrnz	#hotf
	CREATE0	ball_smokepuff
#hotf	movk	1,a14
#nothot

	move	@plyrnumonfire,a0
	jrnn	#skip
	move	a2,a2
	jrn	#skipsnd

	move	@GAMSTATE,a0
	cmpi	INAMODE,a0
	jrz	#noaud
	movi	AUD_NUMHOTSTRK,a0
	calla	AUD1
#noaud

	move	a2,a0
	sll	3,a0
	addi	#bit_t,a0
	movb	*a0,a0
	move	@fire_flags,a14
	or	a0,a14
;	move	a14,@fire_flags

	movk	4,a0
	move	a0,@ballnumscored

	movi	onfire_snd,a0
	calla	speech_playovrp

#skipsnd
	move	a2,@plyrnumonfire	;Save pnum
#skip
	move	@ballpnum,a1
	jrnn	#ck1
	move	@ballpnumlast,a1
	jrn	#clrball
#ck1
	cmp	a0,a1
	jrz	#fireit
	
#clrball
	clr	a14
	clr	a0
	jruc	#setb

#bit_t	.byte	1,2,4,8

#fireit	movk	1,a14
	movi	-1,a0
#setb
	move	a14,*a13(ball_onfire)
;	move	a0,*a13(ball_zsznum)	;Cause ani change
#fsame

;----------


	move	*a8(OXPOS),a6
	move	*a13(ball_anix),a14
	add	a14,a6

	move	*a8(OXVEL),a1,L
	jreq	#xok
	jrgt	#xvpos

	cmpi	WRLDMID-345,a6
	jrge	#xok
	movi	WRLDMID-345,a6
	sub	a14,a6
	move	a6,*a8(OXPOS)
	jruc	#badx

#xvpos	cmpi	WRLDMID+345,a6
	jrlt	#xok
	movi	WRLDMID+345,a6
	sub	a14,a6
	move	a6,*a8(OXPOS)

#badx	clr	a1
	move	a1,*a8(OXVEL),L
#xok


	move	@ballpnum,a5
	jrn	#free

	clr	a14
	move	a14,@ballpasstime

	jruc	#owned

#free	move	@ballprcv_p,a5,L
	jrnz	#skpcol			;Pass in progress?

	callr	ball_bbcollision
#skpcol

	move	@ballpasstime,a0
	addk	1,a0
	move	a0,@ballpasstime
	jruc	#scroll

#owned
	move	*a13(ball_onfire),a14
	jrnz	#scroll			;On fire?
	movk	2,a10			;Keep ball from animating

#scroll
	move	@inbound,a0
	jrn	#not_inbounding
#dunking
	jrnz	#right_side
;#left_side
	movi	[WRLDMID-200-MAX_VIEW1,0],a3
	movi	DIVS_RATE1,a0
	move	a0,@scrl_divs_cur
	jruc	#do_scroll
#right_side
	movi	[WRLDMID-200+MAX_VIEW1,0],a3
	movi	DIVS_RATE1,a0
	move	a0,@scrl_divs_cur
	jruc	#do_scroll
#not_inbounding


	movi	DIVS_RATE2,a0		;normal scroll divisor
	move	a0,@scrl_divs_dest

	move	@ballpnum,a5
	jrge	#plyr_has_ball
	move	a6,a3

	move	@ballprcv_p,a0,L	;passing?
	jrz	#not_passing

;player passing ball
	move	@ballpnumlast,a0	;player who passed ball
	jrn	#not_passing


	movi	DIVS_RATE3,a0
	move	@plyrpasstype,a1
	jrz	#not_turbo
	move	a0,@scrl_divs_cur
#not_turbo
	move	a0,@scrl_divs_dest

	move	@ballpnumlast,a5	;player who passed ball
	jruc	#plyr_has_ball2

#not_passing
	move	@ballpnumlast,a5
	jrnn	#plyr_shooting

;free ball
	movi	-1,a0
	move	a0,@cntl_team		;team in control (0,1 or -1)
	movi	DIVS_RATE1,a0
	move	a0,@scrl_divs_cur

	jruc	#ball_free1


#plyr_has_ball
	move	a5,a0
	sll	5,a0			;*32
	addi	plyrobj_t,a0
	move	*a0,a0,L
	move	*a0(OXPOS),a3
	move	*a0(OXANI+16),a1
	add	a1,a3
#plyr_has_ball2
#plyr_shooting
	move	a5,a0
	srl	1,a0
	move	a0,@cntl_team		;team in control (0,1 or -1)
	sll	5,a5
	addi	plyrproc_t,a5
	move	*a5,a5,L
	move	*a5(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrz	#not_dunking
	move	@cntl_team,a0		;team in control (0,1 or -1)
	xori	1,a0
	jruc	#dunking
#not_dunking


;	move	*a2(OXVEL+16),a6
;	abs	a6
;	cmpi	MIN_PXRUN_SPEED,a6
;	jrlt	#not_hixvel
#not_hixvel


	move	@scrl_divs_cur,a1	;move cur -> dest
	move	@scrl_divs_dest,a2
	cmp	a1,a2			;dest-cur
	jreq	#at_dest
	jrgt	#add
;#sub
	movi	DIVS_DELTA,a0
	sub	a0,a1
	cmp	a1,a2
	jrle	#set_divs
	move	a2,a1
	jruc	#set_divs
#add
	movi	DIVS_DELTA,a0
	add	a0,a1
	cmp	a1,a2
	jrge	#set_divs
	move	a2,a1
#set_divs
	move	a1,@scrl_divs_cur
#at_dest



#ball_free1
	sll	16,a3			;[int,frac]
	subi	[200,0],a3

	move	@cntl_team,a0		;team in control (0,1 or -1)
	jrn	#ball_free
	jrnz	#team2
#team1
	addi	[SCRL_EDGE_OFF,0],a3
	jruc	#cont1
#team2
	subi	[SCRL_EDGE_OFF,0],a3
#cont1
#ball_free

	move	@cntl_team,a0
	move	@cntl_team_last,a1
	cmp	a0,a1
	jreq	#no_turnover2
	move	a0,@cntl_team_last
	movi	DIVS_RATE1,a0
	move	a0,@scrl_divs_cur
#no_turnover2


	cmpi	[WRLDMID-200-MAX_VIEW2,0],a3
	jrge	#sxok1
	movi	[WRLDMID-200-MAX_VIEW2,0],a3
	move	@scrl_divs_cur,a0
	cmpi	DIVS_RATE2,a0
	jrhs	#sxok1
	movi	DIVS_RATE2,a0
	move	a0,@scrl_divs_cur
	move	a0,@scrl_divs_dest
#sxok1
	cmpi	[WRLDMID-200+MAX_VIEW2,0],a3
	jrle	#sxok2
	movi	[WRLDMID-200+MAX_VIEW2,0],a3
	move	@scrl_divs_cur,a0
	cmpi	DIVS_RATE2,a0
	jrhs	#sxok2
	movi	DIVS_RATE2,a0
	move	a0,@scrl_divs_cur
	move	a0,@scrl_divs_dest
#sxok2



#do_scroll
	move	@scrl_divs_cur,a7
	move	@WORLDTLX,a1,L		;>Scroll world view
	move	a1,a5
	sub	a3,a5
	jreq	#no_scroll
	jrlt	#scroll_right
#scroll_left
	subi	[SCROLL_BUFFER,0],a5
	jrle	#no_scroll
	divu	a7,a5			;/ divs rate x 256
	sll	8,a5			;x 256
	sub	a5,a1
	cmpi	[WRLDMID-200-MAX_VIEW1,0],a1
	jrle	#no_scroll
	jruc	#set_scroll

#scroll_right
	abs	a5
	subi	[SCROLL_BUFFER,0],a5
	jrle	#no_scroll
	divu	a7,a5			;/ divs rate x 256
	sll	8,a5			;x 256
	add	a5,a1
	cmpi	[WRLDMID-200+MAX_VIEW1,0],a1
	jrge	#no_scroll

#set_scroll
;stiffen up scroller
	move	@inbound,a0
	jrn	#noinb
 
	move	@WORLDTLX,a0,L
	sub	a1,a0
	abs	a0
	cmpi	1000h,a0
	jrlt	#no_scroll
#noinb

	move	a1,@WORLDTLX,L
	subi	[WRLDMID-200,0],a1
	move	a1,@gndx,L
#no_scroll

*************************************************************



	move	@ballpnum,a5		;player who has ball (0-3 or -1)
	move	*a8(OZPOS),a14		;>Set world Y
	subi	GZBASE,a14		;-Base
	jrge	#zok2
	clr	a14
#zok2	move	a14,a2
	sra	1,a14			;Z/2
	sra	3,a2			;Z/8
	sub	a2,a14			;=Z/2.667

	move	*a8(OYPOS),a1
	add	a14,a1
	addi	70,a1

	move	a5,a14
	jrn	#bfree			;Free from plyr?
	sll	5,a14			;x 32 bits
	addi	plyrproc_t,a14
	move	*a14,a14,L
	move	*a14(plyr_seqflgs),a2
	btst	DUNK_B,a2
	jrz	#bfree

	move	*a14(plyr_seq),a2	;Current ani sequence #
	cmpi	DUNKU2_SEQ,a2		;These dunks need different buffering
	jrlt	#1stdunks
	addi	25-70,a1
	move	a1,a1
	jrlt	#byvis0
	clr	a1
#byvis0
	move	@WORLDTLY+16,a2
	sub	a2,a1
	jreq	#skipwy
	sra	4,a1
	jruc	#setwy

#1stdunks
	addi	45-70,a1

#bfree
	move	a1,a1
	jrlt	#byvis
	clr	a1
#byvis
	move	@WORLDTLY+16,a2
	sub	a2,a1
	jreq	#skipwy
	sra	2,a1
#setwy	jrnz	#adjok
	addk	1,a1
#adjok	add	a1,a2
	cmpi	-130,a2			;110 ;125,;135
	jrlt	#skipwy			;Don't scroll higher?
	move	a2,@WORLDTLY+16
#skipwy


;----------

					;>Check Z
	move	*a8(OZPOS),a0
	move	a5,a5
	jrge	#zok			;Plyr has ball?
	move	*a8(OZVEL),a1,L
	jrn	#zvneg

	cmpi	GZMAX,a0		;-12
	jrlt	#zok
	movi	GZMAX,a0
	jruc	#zbad

#zvneg	cmpi	CZMIN,a0
	jrge	#zok
	movi	CZMIN,a0

#zbad	move	a0,*a8(OZPOS)
	clr	a1
	move	a1,*a8(OZVEL),L
#zok

	subi	CZMIN,a0		;-Base
	jrge	#zge
	clr	a0
#zge	srl	5,a0			;/32
	move	*a13(ball_zsznum),a1
	cmp	a1,a0
	jreq	#ani			;Same Z range?
	move	a0,*a13(ball_zsznum)
	sll	5,a0			;*32
	move	a0,a1
	addi	#shad_t,a1		;>Set new shadow img
	move	*a1,a2,L
	move	a2,*a9(OIMG),L
	move	*a2,a14,L
	move	a14,*a9(OSIZE),L
	move	*a2(ISAG),*a9(OSAG),L
	move	*a2(IANIOFFY),a1
	neg	a1
	move	a1,*a9(OYPOS)

	move	*a13(ball_onfire),a14
	jrnz	#onfire
	addi	#ani_t,a0
	move	*a0,a0,L
	move	a0,*a13(ball_ani1st_p),L
	jruc	#newz

#onfire
	addi	#anif_t,a0
	move	*a0,a0,L
	move	a0,*a13(ball_ani1st_p),L
	jruc	#newz


#ani
	dsj	a10,#skipa
 
	move	*a13(ball_onfire),a14
	jrnz	#movin			;On fire?

	move	*a8(OXVEL),a0,L
	abs	a0
	srl	2,a0
	jrnz	#movin
	movk	5,a10
	move	*a8(OZVEL),a0,L
	abs	a0
	srl	2,a0
	jrz	#skipa
#movin

	move	*a13(ball_ani_p),a0,L
	move	*a0+,a1,L		;*Next img
	jrnz	#notend

	move	*a13(ball_ani1st_p),a0,L
#newz	move	*a0+,a1,L		;*1st img

#notend	move	*a0+,a10
	move	a0,*a13(ball_ani_p),L

	move	a1,*a8(OIMG),L		;>Set new img
	move	*a1,a2,L
	move	a2,*a8(OSIZE),L
	move	*a1(ISAG),*a8(OSAG),L
	move	*a1(IANIOFFX),a2
	move	*a1(IANIOFFY),*a13(ball_aniy)
	move	*a13(ball_anix),a1
	move	a2,*a13(ball_anix)
	move	*a8(OXPOS),a0
	add	a1,a0			;Old ani X
	sub	a2,a0			;-New ani X
	move	a0,*a8(OXPOS)

#skipa
	move	*a8(OYVEL),a2,L

	move	*a8(OYPOS),a1
	move	*a13(ball_aniy),a3
	add	a3,a1
	jrlt	#agnd			;Above gnd?

;MJT
	clr	a0
	calla	plyr_setshtdly

	cmpi	>4000,a2
	jrlt	#nosnd
	movi	bounce_snd,a0
	calla	snd_play1

#nosnd
	neg	a3
	move	a3,*a8(OYPOS)		;Set on gnd
	neg	a2
	move	a2,a3			;75%
	sra	2,a3			;/4
	sub	a3,a2
#agnd	addi	GRAVB,a2
	move	a2,*a8(OYVEL),L
#nograv
	move	*a8(OXVAL),*a9(OXVAL),L	;>Align shadow
	move	*a8(OXANI),*a9(OXANI),L
	move	*a8(OZPOS),a0
	subk	10,a0			;Adjust
	move	a0,*a9(OZPOS)

	callr	ball_chkpcollide

#halted
	SLOOP	1,#lp


#ani_t
	.long	#b1_l
	.long	#b1_l,#b2_l,#b2_l
	.long	#b3_l,#b3_l,#b4_l,#b4_l
	.long	#b5_l,#b5_l,#b6_l,#b6_l
	.long	#b7_l,#b7_l,#b8_l,#b8_l
	.long	#b9_l,#b9_l, #b9_l,#b9_l
	.long	#b9_l,#b9_l, #b9_l,#b9_l
	.long	#b9_l,#b9_l, #b9_l,#b9_l
	.long	#b9_l,#b9_l, #b9_l,#b9_l
	.long	#b9_l,#b9_l, #b9_l,#b9_l

	.asg	5,D

#b1_l	LW	ball11,D
	LW	ball12,D
	LWL0	ball13,D

#b2_l	LW	ball21,D
	LW	ball22,D
	LWL0	ball23,D

#b3_l	LW	ball31,D
	LW	ball32,D
	LWL0	ball33,D

#b4_l	LW	ball41,D
	LW	ball42,D
	LWL0	ball43,D

#b5_l	LW	ball51,D
	LW	ball52,D
	LWL0	ball53,D

#b6_l	LW	ball61,D
	LW	ball62,D
	LWL0	ball63,D

#b7_l	LW	ball71,D
	LW	ball72,D
	LWL0	ball73,D

#b8_l	LW	ball81,D
	LW	ball82,D
	LWL0	ball83,D

#b9_l	LW	ball91,D
	LW	ball92,D
	LWL0	ball93,D


#anif_t
	.long	#bf1_l
	.long	#bf1_l,#bf2_l,#bf2_l
	.long	#bf3_l,#bf3_l,#bf4_l,#bf4_l
	.long	#bf5_l,#bf5_l,#bf6_l,#bf6_l
	.long	#bf7_l,#bf7_l,#bf8_l,#bf8_l
	.long	#bf9_l,#bf9_l, #bf9_l,#bf9_l
	.long	#bf9_l,#bf9_l, #bf9_l,#bf9_l
	.long	#bf9_l,#bf9_l, #bf9_l,#bf9_l
	.long	#bf9_l,#bf9_l, #bf9_l,#bf9_l
	.long	#bf9_l,#bf9_l, #bf9_l,#bf9_l

	.asg	4,D

#bf1_l	LW	ballf11,D
	LW	ballf12,D
	LW	ballf13,D
	LW	ballf14,D
	LW	ballf15,D
	LWL0	ballf16,D

#bf2_l	LW	ballf21,D
	LW	ballf22,D
	LW	ballf23,D
	LW	ballf24,D
	LW	ballf25,D
	LWL0	ballf26,D

#bf3_l	LW	ballf31,D
	LW	ballf32,D
	LW	ballf33,D
	LW	ballf34,D
	LW	ballf35,D
	LWL0	ballf36,D

#bf4_l	LW	ballf41,D
	LW	ballf42,D
	LW	ballf43,D
	LW	ballf44,D
	LW	ballf45,D
	LWL0	ballf46,D

#bf5_l	LW	ballf51,D
	LW	ballf52,D
	LW	ballf53,D
	LW	ballf54,D
	LW	ballf55,D
	LWL0	ballf56,D

#bf6_l	LW	ballf61,D
	LW	ballf62,D
	LW	ballf63,D
	LW	ballf64,D
	LW	ballf65,D
	LWL0	ballf66,D

#bf7_l	LW	ballf71,D
	LW	ballf72,D
	LW	ballf73,D
	LW	ballf74,D
	LW	ballf75,D
	LWL0	ballf76,D

#bf8_l	LW	ballf81,D
	LW	ballf82,D
	LW	ballf83,D
	LW	ballf84,D
	LW	ballf85,D
	LWL0	ballf86,D

#bf9_l	LW	ballf91,D
	LW	ballf92,D
	LW	ballf93,D
	LW	ballf94,D
	LW	ballf95,D
	LWL0	ballf96,D



#shad_t
;	.long	ballshad12,ballshad12,ballshad11,ballshad11
;	.long	ballshad10,ballshad10,ballshad9,ballshad9
	.long	ballshad8,ballshad8,ballshad7,ballshad7
	.long	ballshad6,ballshad6,ballshad5,ballshad5
	.long	ballshad4,ballshad4,ballshad3,ballshad3
	.long	ballshad2,ballshad2,ballshad1,ballshad1
	.long	ballshad1,ballshad1,ballshad1,ballshad1
	.long	ballshad1,ballshad1,ballshad1,ballshad1
	.long	ballshad1,ballshad1,ballshad1,ballshad1


********************************
* Get shadow obj for ball
* A8=*Obj
* >A9=*Shadow obj
* Trashes scratch, A2-A7

 SUBRP	ball_getshadow

	PUSH	a8

	move	*a8(OXVAL),a0,L
	movi	[-2,0],a1
	movi	ballshad5,a2
	move	*a8(OZPOS),a3
	subk	10,a3			;Z
	move	*a8(OCTRL),a4
	andi	M_FLIPH|M_FLIPV,a4
	ori	DMAWNZ|M_3D|M_SHAD|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,a9
	movk	10,a0
	move	a0,*a8(OMISC)		;Z offset

	PULL	a8
	rets


#*******************************
* Check ball for collisions with backboard/hoop
* A6=Ball ani XPOS
* A8=*Ball obj
* A13=*Ball process
* Trashes scratch, B2-B3

 SUBRP	ball_bbcollision

	PUSH	a2,a3,a4,a5,a6,a7,a9,a10,a11

	clr	b2			;B2=Rim collision flag

	move	@shot_distance,a14
	cmpi	>158,a14
	jrlt	#ok
;A long range shot, don't allow it to go in!
	movi	200,a0

	move	@game_time,a1,L
	cmpi	>400,a1
	jrgt	#nohelp
	movi	350,a0
#nohelp
	calla	RNDPER
	jrhi	#ok
;Point toward hoop with no score points!
	movi	lhoopl_t,a10
	movi	HOOPLX,b3		;B3=Hoop X
	cmpi	WRLDMID,a6
	jrlt	#left
	movi	lhoopr_t,a10
	movi	HOOPRX,b3
	jruc	#left

#ok
	movi	hoopl_t,a10
	movi	HOOPLX,b3		;B3=Hoop X
	cmpi	WRLDMID,a6
	jrlt	#left
	movi	hoopr_t,a10
	movi	HOOPRX,b3
#left
	move	*a8(OYPOS),a7		;A7=Ball Y
	move	*a8(OSIZEY),a14
	srl	1,a14			;/2
	add	a14,a7			;Center Y
	cmpi	HOOPY+20,a7
	jrge	#x			;Under all collision points?


	move	@ballscorezhit,a0
	jrge	#chkpts			;Haven't scored?

	move	*a8(OZVEL),a0,L		;>Slow XZ vel
	sra	1,a0
	move	a0,*a8(OZVEL),L

	move	*a8(OYVEL),a0,L		;-1/4 Y
	move	a0,a14
	sra	2,a14
	sub	a14,a0
	move	a0,*a8(OYVEL),L


	move	a6,a0			;>Pull toward center
	move	b3,a14
	sub	a14,a0
	sll	12,a0			;/16

	move	*a8(OXVEL),a1,L
	sub	a0,a1
	move	a1,a14
	sra	2,a14			;/4
	sub	a14,a1
	move	a1,*a8(OXVEL),L

	jruc	#chkbb


#chkpts
	move	*a8(OZPOS),a5		;A5=Ball Z
	jruc	#nxt


#lp	move	*a10+,a3		;Y
	move	*a10+,a4		;Z
	move	*a10+,a11		;Mode
	sub	a6,a2
	sub	a7,a3
	sub	a5,a4
	abs	a2
	abs	a3
	abs	a4

	cmp	a3,a2			;>Sort A2-A4 large to sml
	jrge	#20
	SWAP	a2,a3

#20	cmp	a4,a3
	jrge	#sorted
	SWAP	a3,a4

	cmp	a3,a2
	jrge	#sorted
	SWAP	a2,a3

#sorted	srl	1,a3			;/2
	srl	2,a4			;/4
	add	a3,a2
	add	a4,a2
	subk	5,a2
	jrgt	#nxt			;Too far?


	move	@sc_proc,a0,L
	jrz	#no24clock
	clr	a14
	move	a4,@sc_proc,L
;	move	*a0(PROCID),a14
;	cmpi	clockid,a14
;	jrz	#cont
;	LOCKUP
;#cont
	PUSH	a7,a10
	movi	sclockx,a7
	movi	clockid,a1
	move	*a0(PA10),a10,L
	calla	XFERPROC
	PULL	a7,a10
#no24clock

	clr	a0
	move	a0,@ballgoaltcnt

	movi	3*60+30,a0		;Rebound stat can happen for next 3
	move	a0,@rebound_delay	;seconds

	movk	8,a0
	move	a0,@ballsclastp		;Nobody


	move	a11,a11
	jrle	#notrim
					;>Rim

	move	@ballscorezhit,a0
	jrn	#nxt			;Already scored?
 
	move	@ballrimhitcnt,a0
;RJR
	jrnz	#skipit

	PUSH	a0,a7,a11

	move	@ballpnumshot,a0
	sll	4,a0			;x 16
	addi	brick_count,a0
	move	*a0,a1			;brick_count++
	inc	a1
	move	a1,*a0

	move	b3,a11			;hoop x
	CREATE	NOG_PID,no_good_check
	PULL	a0,a7,a11
#skipit
	addk	1,a0
	move	a0,@ballrimhitcnt

	move	b2,b2
	jrnz	#nomv			;Hit already?
	addk	1,b2			;Set flag

	cmpi	3,a11
	jrlt	#nobend

	clr	a0			;>Make rim bend a little
	cmpi	WRLDMID,a6
	jrlt	#netani
	movk	1,a0
#netani	movk	4,a1
	calla	net_ani

#nobend
	move	@PCNT,a0
	sll	32-2,a0
	srl	32-2-5,a0
	addi	rim_snds,a0
	move	*a0,a0,L
	calla	snd_play1


	move	a8,a1			;>Move back
	addi	OXVAL,a1
	move	*a8(OXVEL),a0,L
	move	*a1,a2,L
	sub	a0,a2
	move	a2,*a1+,L
	move	*a8(OYVEL),a0,L
	move	*a1,a3,L
	sub	a0,a3
	move	a3,*a1+,L
	move	*a8(OZVEL),a0,L
	move	*a1,a4,L
	sub	a0,a4
	move	a4,*a1+,L

	move	*a13(ball_collcnt),a1
	subk	3,a1
	jrge	#ballstuck

#nomv
	subi	16*4,a10
	move	*a10+,a2
	move	*a10+,a3
	move	*a10+,a4
	addk	16,a10
	callr	ball_deflect

	move	b2,b2
	jrnz	#nxt			;Hit already?

	move	*a13(ball_collcnt),a1
	jrnz	#nxt

	move	a11,a0			;>Absorb some vel
	subk	13,a0			;-12 to -9
	neg	a0
	move	a8,a1
	addk	OXVEL,a1
	move	*a1,a3,L
	mpys	a0,a3
	sra	5,a3			;/32
	move	a3,*a1+,L
	move	*a1,a3,L
	mpys	a0,a3
	sra	5,a3			;/32
	move	a3,*a1+,L
	move	*a1,a3,L
	mpys	a0,a3
	sra	5,a3			;/32
	move	a3,*a1+,L

	jruc	#nxt


#ballstuck
	callr	ball_stuck
	jruc	#skip

#notrim
;	jrn	#score
;					;>Net (slow ball)
;	move	a8,a1
;	addk	OXVEL,a1
;
;	move	*a1,a0,L		;X
;	move	a0,a14
;	sra	3,a14			;/8
;	sub	a14,a0
;	move	a0,*a1+,L
;
;	move	*a1,a0,L		;Y
;	move	a0,a14
;	sra	3,a14			;/8
;	sub	a14,a0
;	move	a0,*a1+,L
;
;	move	*a1,a0,L		;Z
;	move	a0,a14
;	sra	3,a14			;/8
;	sub	a14,a0
;	move	a0,*a1+,L
;
;	jruc	#nxt


#score	callr	ball_score		;>Score if really a basket


#nxt	move	*a10+,a2		;X
	jrnz	#lp


#skip	clr	a1
	move	b2,b2
	jrz	#svcol			;No rim collision?
	move	*a13(ball_collcnt),a1
	addk	1,a1
#svcol	move	a1,*a13(ball_collcnt)

;	move	*a13(ball_collcnt),a1
;	jrnz	#chkbb

	move	b2,b2
	jrz	#chkbb			;No rim collision?

	move	*a8(OXVEL),a2,L		;>Limit max XZvel
	move	*a8(OZVEL),a3,L
	move	*a8(OYVEL),a4,L
	move	a2,a0
	move	a3,a1
	abs	a0
	abs	a1
	cmp	a0,a1
	jrge	#a1big
	move	a0,a1
#a1big
	cmpi	>12000,a1
	jrle	#chkyv			;XZ vel within max?

	move	a4,a14
	sra	8,a14

#scldlp	srl	1,a1			;Scale down
	sra	1,a2
	sra	1,a3
	add	a14,a4			;+1/8
#strtsc	cmpi	>12000,a1
	jrgt	#scldlp

	move	a2,*a8(OXVEL),L
	move	a3,*a8(OZVEL),L

#chkyv	cmpi	->44000,a4
	jrge	#ymaxok
	movi	->44000,a4
#ymaxok	cmpi	>30000,a4
	jrle	#ydnok
	movi	>30000,a4
#ydnok	move	a4,*a8(OYVEL),L






#chkbb
	subi	CZMID,a5		;>Check backboard
	abs	a5
	cmpi	34,a5
	jrge	#x			;Z <> backboard Z?
	subi	HOOPY+5,a7
	jrgt	#x			;Y<bottom?
	cmpi	-56,a7
	jrlt	#x			;Y>top?

	subi	WRLDMID,a6
	move	a6,a2
	abs	a6
	subi	HOOPRX-WRLDMID+12,a6
	jrlt	#x			;In front of backboard?

	move	*a8(OXVEL),a0,L
	abs	a0
	move	a2,a2
	jrn	#lbb			;Left bb?
	neg	a0
#lbb	move	a0,*a8(OXVEL),L
	move	*a8(OXVAL),a1,L
	add	a0,a1
	add	a0,a1
	move	a1,*a8(OXVAL),L

	abs	a0
	cmpi	>1fff,a0
	jrlt	#softbbhit		;Soft?
	movi	hitbboard_snd,a0
	calla	snd_play1
#softbbhit
     
	move	@ballbbhitcnt,a0
	addk	1,a0
	move	a0,@ballbbhitcnt

	subk	7,a0			;8
	jrlt	#x			;!Stuck?
	movi	>20000,a0		;20000
	move	*a8(OZPOS),a1
	cmpi	CZMID,a1
	jrgt	#newzv
	neg	a0
#newzv
	move	a0,*a8(OZVEL),L		;Try to unstick

#x	PULL	a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets


	.asg	HOOPLX,X
	.asg	HOOPY,Y
	.asg	Y+7,NY
	.asg	CZMID,Z
hoopl_t	.word	X-8	,Y	,Z	,1	;Rim
	.word	X-6	,Y	,Z-7	,1
	.word	X	,Y	,Z-9	,2
	.word	X+6	,Y	,Z-7	,3
	.word	X+8	,Y	,Z	,4
	.word	X+6	,Y	,Z+7	,3
	.word	X	,Y	,Z+9	,2
	.word	X-6	,Y	,Z+7	,1
	.word	X	,Y	,Z	,-1	;Score spots
	.word	X	,Y+2	,Z	,-1
	.word	X	,Y+6	,Z	,-2
	.word	X-3	,Y+8	,Z	,-2
	.word	X	,Y+8	,Z-3	,-2
	.word	X+3	,Y+8	,Z	,-2
	.word	X	,Y+8	,Z+3	,-2
	.word	0

	.asg	HOOPRX,X
hoopr_t	.word	X-8	,Y	,Z	,4
	.word	X-6	,Y	,Z-7	,3
	.word	X	,Y	,Z-9	,2
	.word	X+6	,Y	,Z-7	,1
	.word	X+8	,Y	,Z	,1
	.word	X+6	,Y	,Z+7	,1
	.word	X	,Y	,Z+9	,2
	.word	X-6	,Y	,Z+7	,3
	.word	X	,Y	,Z	,-1	;Score spots
	.word	X	,Y+2	,Z	,-1
	.word	X	,Y+6	,Z	,-2
	.word	X-3	,Y+8	,Z	,-2
	.word	X	,Y+8	,Z-3	,-2
	.word	X+3	,Y+8	,Z	,-2
	.word	X	,Y+8	,Z+3	,-2
	.word	0

;Long range shot tables
	.asg	HOOPLX,X
lhoopl_t
	.word	X-8	,Y	,Z	,1	;Rim
	.word	X-6	,Y	,Z-7	,1
	.word	X	,Y	,Z-9	,2
	.word	X+6	,Y	,Z-7	,3
	.word	X+8	,Y	,Z	,4
	.word	X+6	,Y	,Z+7	,3
	.word	X	,Y	,Z+9	,2
	.word	X-6	,Y	,Z+7	,1
	.word	X	,Y	,Z	,1	;Score spots
	.word	X	,Y+2	,Z	,2
	.word	X	,Y+6	,Z	,3
	.word	X-3	,Y+8	,Z	,4
	.word	X	,Y+8	,Z-3	,3
	.word	X+3	,Y+8	,Z	,2
	.word	X	,Y+8	,Z+3	,1
	.word	0

	.asg	HOOPRX,X
lhoopr_t
	.word	X-8	,Y	,Z	,4
	.word	X-6	,Y	,Z-7	,3
	.word	X	,Y	,Z-9	,2
	.word	X+6	,Y	,Z-7	,1
	.word	X+8	,Y	,Z	,1
	.word	X+6	,Y	,Z+7	,1
	.word	X	,Y	,Z+9	,2
	.word	X-6	,Y	,Z+7	,3
	.word	X	,Y	,Z	,1	;Score spots
	.word	X	,Y+2	,Z	,2
	.word	X	,Y+6	,Z	,3
	.word	X-3	,Y+8	,Z	,4
	.word	X	,Y+8	,Z-3	,3
	.word	X+3	,Y+8	,Z	,2
	.word	X	,Y+8	,Z+3	,1
	.word	0

rim_snds
	.long	miss_snd,miss_snd,miss2_snd,miss3_snd


#*******************************
* Deflect ball from what it hit
* A2=Hit X
* A3=Hit Y
* A4=Hit Z
* A5=Ball Z
* A6=Ball X
* A7=Ball Y
* A8=*Ball obj
* Trashes scratch, A2-A4

 SUBRP	ball_deflect

	PUSH	a5,a6,a7,a9,a10,a11

	sll	4,a2
	sll	4,a3
	sll	4,a4
	sll	4,a5
	sll	4,a6
	sll	4,a7

	PUSH	a2,a3,a6,a7

	move	a6,a0			;>Deflect XZ
	move	a5,a1
	move	a2,a6
	move	a4,a7
	callr	seekdir_xyxy128
	move	a0,a14
	neg	a0
	addi	>80,a0
	callr	sinecos_get

	move	*a8(OXVEL),a3,L
	move	*a8(OZVEL),a9,L

	move	a3,a5			;>Rotate to 0
	move	a9,a11
	mpys	a1,a3			;X*COS
	mpys	a0,a11			;Z*SIN
	sub	a11,a3			;X-Z
	mpys	a0,a5			;X*SIN
	mpys	a1,a9			;Z*COS
	add	a5,a9			;X+Z
	sra	12,a3
	sra	12,a9

	neg	a9			;Neg Z

	move	a14,a0
	callr	sinecos_get

	move	a3,a5			;>Rotate back
	move	a9,a11
	mpys	a1,a3			;X*COS
	mpys	a0,a11			;Z*SIN
	sub	a11,a3			;X-Z
	mpys	a0,a5			;X*SIN
	mpys	a1,a9			;Z*COS
	add	a5,a9			;X+Z
	sra	12,a3
	sra	12,a9

	move	a3,*a8(OXVEL),L
	move	a9,*a8(OZVEL),L

	PULL	a2,a3,a6,a7

	move	a6,a0			;>Deflect XY
	move	a7,a1
	move	a2,a6
	move	a3,a7
	callr	seekdir_xyxy128
	move	a0,a14
	neg	a0
	addi	>80,a0
	callr	sinecos_get

	move	*a8(OXVEL),a3,L
	move	*a8(OYVEL),a9,L

	move	a3,a5			;>Rotate to 0
	move	a9,a11
	mpys	a1,a3			;X*COS
	mpys	a0,a11			;Z*SIN
	sub	a11,a3			;X-Z
	mpys	a0,a5			;X*SIN
	mpys	a1,a9			;Z*COS
	add	a5,a9			;X+Z
	sra	12,a3
	sra	12,a9

	neg	a9			;Neg Y

	move	a14,a0
	callr	sinecos_get

	move	a3,a5			;>Rotate back
	move	a9,a11
	mpys	a1,a3			;X*COS
	mpys	a0,a11			;Z*SIN
	sub	a11,a3			;X-Z
	mpys	a0,a5			;X*SIN
	mpys	a1,a9			;Z*COS
	add	a5,a9			;X+Z
	sra	12,a3
	sra	12,a9

	move	a3,*a8(OXVEL),L
	move	a9,*a8(OYVEL),L


	PULL	a5,a6,a7,a9,a10,a11
	rets


#*******************************
* Ball stuck on rim, try to unstick
* A8=*Ball obj
* B3=Hoop X
* Trashes scratch, A2,A3

 SUBRP	ball_stuck

	PUSH	a6,a7

	move	b3,a6			;>Give vel towards or away from center
	movi	CZMID,a7
	callr	seekdirdist_obxz128

	srl	3,a0			;Dir 0-15
	sll	4,a0			;*16
	addi	#dx_t,a0
	move	*a0,a2
	move	*a0(#dz_t-#dx_t),a3
	subk	10,a1
	jrle	#tcent			;Towards center?
	neg	a2
	neg	a3
	sra	1,a2			;/2
	sra	1,a3
#tcent
	sll	3,a2			;*8
	sll	3,a3
	move	a2,*a8(OXVEL),L
	move	a3,*a8(OZVEL),L

	move	*a8(OXVAL),a0,L
	add	a2,a0
	move	a0,*a8(OXVAL),L
	move	*a8(OZVAL),a0,L
	add	a3,a0
	move	a0,*a8(OZVAL),L

	move	@HCOUNT,a14
	btst	0,a14
	jrz	#noyvc			;Skip yvel change?

	movi	-GRAVB*7,a1
	move	*a8(OYPOS),a0
	cmpi	HOOPY+6,a0
	jrlt	#abv			;Ball above rim?
	neg	a1
#abv	move	a1,*a8(OYVEL),L

#noyvc
	clr	a1
	move	a1,*a13(ball_collcnt)

	PULL	a6,a7
	rets


#dz_t
	.word	-16384,-15137,-11585,-6270
#dx_t
	.word	0,6270,11585,15137,16384,15137,11585,6270
	.word	0,-6269,-11585,-15137, -16384,-15137,-11585,-6270


#*******************************
* Ball touching score zone, score if valid
* A8=*Ball obj
* A11=-1/-2 (upper spot / lower spot)
* Trashes scratch

 SUBRP	ball_score

	PUSH	a2,a3,a4,a5,a6,a7,a10,a11


	move	*a8(OYVEL),a0,L
	jrle	#x			;Moving up?

	addk	1,a11
	jrne	#low

	movk	1,a0			;Upper zone hit
	move	a0,@ballscorezhit
	jruc	#x

#low
	move	@ballscorezhit,a0
	jrle	#x			;No top hit?

	movi	-1,a0
	move	a0,@ballscorezhit

;RJR
	movi	NOG_PID,a0		;kill no good process
	calla	KIL1C

	move	@ballptsforshot,a1
	jrz	#x			;Goaltending?


	clr	a10


	movk	16,a0			;Team 2
	clr	a2
	move	*a8(OXPOS),a14
	cmpi	WRLDMID,a14
	jrlt	#left
	clr	a0			;Team 1
	movk	32,a2
#left
	addi	scores,a0		;+Base
	move	@ballptsforshot,a1
	move	a1,a3
	calla	score_add

	clr	a0
	move	a0,@rebound_delay

	callr	plyr_setptsdown

	subk	2,a3
	jrne	#3ptr
	movk	PS_2PTS_MADE,a0		;>Inc made shot stat
	jruc	#2ptr
#3ptr
	movk	PS_3PTS_MADE,a0

#2ptr	move	@ballpnumshot,a1
	calla	inc_player_stat

;	calla	scored_speech
	calla	prt_top_scores		;Update scores at scrn top

	CREATE0	score_showtvpanel

	move	a2,a11


;When testing dunks - TAKE OUT!
	CREATE0	plyr_takeoutball



	movi	TSEC*1,a0
	calla	plyr_setshtdly

	movi	P1DATA,a10
	calla	stick_number
	movi	P2DATA,a10
	calla	stick_number
	movi	P3DATA,a10
	calla	stick_number
	movi	P4DATA,a10
	calla	stick_number

					;>Do a net animation
	move	@ballpnumshot,a0
;RJR
	move	a0,a14
	sll	4,a14			;x 16
	addi	brick_count,a14
	clr	a1
	move	a1,*a14

	movi	ballpnumscored,a3
	move	*a3,a14
	cmp	a0,a14
	jreq	#smpl			;Same guy?

	movk	1,a1			;1st
	move	*a3(16),a4		;# times


	move	@fire_flags,a5
	btst	a14,a5
	jrz	#normfire2
;4 shots to get on fire if already on fire
	cmpi	4,a4
	jruc	#nrmf2	

#normfire2
	cmpi	3,a4
#nrmf2	

	jrlt	#diffpl			;Last guy not hot?

	move	a0,a4
	srl	1,a4
	srl	1,a14
	cmp	a4,a14
	jrz	#nochg			;Different team?
	move	a1,*a3(16)
	movi	-1,a1
	move	a1,@plyrnumonfire
	jruc	#nochg			;Don't messup teammate

#smpl
	move	*a3(16),a1		;# times
	addk	1,a1
	cmpi	8,a1			;7
	jrlt	#diffpl
	movi	-1,a1
	move	a1,@plyrnumonfire	;Cap out on fire capability
	movk	1,a1
#diffpl	move	a1,*a3(16)
#nochg
	move	a0,*a3

	sll	5,a0			;*32
	addi	plyrproc_t,a0
	move	*a0,a10,L
	move	*a10(plyr_seqflgs),a6

	move	a2,a0
	movk	1,a1			;Bend from dunk

	movi	dunk_snd,a11		;Sound for dunk
	btst	DUNK_B,a6
	jrnz	#neta

	CREATE0	plyr_jscrowdsnd		;For good jump shot

	movi	swish_snd,a11		;Sound for swish

	clr	a1			;Normal swish
	move	*a8(OXVEL),a14,L
	sra	15,a14
	move	a2,a0
	jrnz	#rnet
	neg	a14			;Reverse
#rnet	subk	4,a14
	jrlt	#xvsml
	movk	3,a1			;Angled swish
#xvsml
	move	*a8(OYVEL+16),a14
	subk	2,a14
	jrge	#yvlrg
	clr	a1
#yvlrg
#neta
	move	*a3(16),a4		;# times
	move	@ballpnumscored,a14
	move	@fire_flags,a2
	btst	a14,a2
	jrz	#nor2
	cmpi	4,a4
	jruc	#nor3

#nor2
	cmpi	3,a4
#nor3




	jrlt	#nothot
	movk	6,a1			;Burn net
#nothot
	calla	net_ani

	move	a11,a0
	calla	snd_play1		;Net sound


;RJR
; .if 0
;	subk	2,a4
;	jrlt	#cold			;The scorer is cold?
;	movi	heatup_snd,a0
;	subk	3-2,a4
;	jrlt	#hsnd
;	movi	onfire_snd,a0
;#hsnd
;	move	@ballpnumshot,a1
;	move	@ballpnumscored,a14
;	cmp	a1,a14
;	jrne	#cold			;Teammates the hot one?
;	calla	snd_play1
;#cold
; .endif


	move	*a8(OXVEL),a0,L		;>Slow XZ vel
	sra	1,a0
	move	a0,*a8(OXVEL),L
	move	*a8(OZVEL),a0,L
	sra	1,a0
	move	a0,*a8(OZVEL),L


	btst	DUNK_B,a6
	jrz	#noshake		;!dunk?
	btst	LAYUP_B,a6
	jrnz	#noshake		;!dunk?

	movk	PS_DUNKS_MADE,a0
	move	@ballpnumshot,a1
	move	a1,a2
	calla	inc_player_stat
	srl	1,a2			;0-1
	move	a2,a3
	XORK	1,a2
	move	a2,@inbound		;Inbounding team (0-1)

	sll	4,a3			;*16
	addi	t1dunkcnt,a3
	move	*a3,a0
	addk	1,a0
	jrnc	#noshat			;No overflow?

	move	*a10(plyr_seq),a0
	movi	#dunk_t,a1
#dlp	move	*a1+,a14
	jrn	#noshat2		;End of table?
	cmp	a14,a0
	jrne	#dlp			;Wimpy dunk?

	move	@PSTATUS,a0		;Plyr start bits 0-3
	move	@ballpnumshot,a1
	btst	a1,a0
	jrz	#noshat2		;Drone?

;Fix!!!
;	LOCKUP

	move	@bbshatter,a0		;Already happened
	jrnz	#noshat2

	jruc	#noshat2		;THE NBA SUCKS!

	.ref	gmqrtr
	move	@gmqrtr,a0
	cmpi	3,a0
	jrlt	#noshat2

	move	*a10(plyr_attrib_p),a0,L
	move	*a0(PAT_DUNKSKILL),a0
	cmpi	9,a0
	jrlt	#noshat2

	clr	a0
	move	a0,*a3			;Reset cnt
	move	a0,@t1dunkcnt
	move	a0,@t2dunkcnt

	movk	32,a0
	cmpi	2,a1
	jrlt	tm1
;Knock down team 1
	move	@plyrproc_t,a1,L
	move	a0,*a1(plyr_stagcnt)
	move	@plyrproc_t+32,a1,L
	move	a0,*a1(plyr_stagcnt)
	jruc	#doit
tm1
	move	@plyrproc_t+64,a1,L
	move	a0,*a1(plyr_stagcnt)
	move	@plyrproc_t+96,a1,L
	move	a0,*a1(plyr_stagcnt)
#doit
	CREATE0	board_shatter
	movi	HOOP_PID,a0
	calla	KIL1C
	move	a2,a0
	movk	5,a1			;Big rim bend
	calla	net_ani
	movk	18,a10			;Big shake
	jruc	#shake
#noshat
	move	a0,*a3
#noshat2
	movk	15,a10
#shake	calla	SHAKER
#noshake


;	move	@movieshown,a0
;;	jrnz	#x
;	jruc	#x
;
;	movk	7,a0
;	callr	rnd
;	jrnz	#x
;
;	movk	1,a0
;	move	a0,@movieshown
;
;	CREATE0	movie_test

	calla	scored_speech

#x	PULL	a2,a3,a4,a5,a6,a7,a10,a11
	rets

;Turmell
#dunk_t	.word	DUNKP_SEQ,DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKL_SEQ,DUNKL2_SEQ,DUNKL3_SEQ,DUNKL4_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKP3_SEQ
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
	.word	DUNKT2_SEQ
	.word	DUNKT3_SEQ
	.word	DUNKT4_SEQ
	.word	DUNKT_SEQ
	.word	DUNKU_SEQ
	.word	DUNKF_SEQ,DUNKJ_SEQ,DUNKO_SEQ
	.word	DUNKK_SEQ,DUNKK2_SEQ,DUNKJ2_SEQ
	.word	DUNKQ_SEQ
	.word	DUNKQ3_SEQ
	.word	DUNKO2_SEQ
	.word	DUNKW3_SEQ
	.word	DUNKW2_SEQ
	.word	DUNKW_SEQ

	.word	-1


********************************
* Get sine and cosine
* A0=Angle (0-127) (Not neg!)
* >A0=Sine (0-4096)
* >A1=Cos (0-4096)
* Preserves A14

 SUBR	sinecos_get

	sll	32-7,a0
	srl	32-7-4,a0		;*16
	addi	sine_t,a0
	move	*a0(cos_t-sine_t),a1
	move	*a0,a0
	rets

sine_t
	.word	-4096,-4091,-4076,-4052,-4017,-3973,-3920,-3857
	.word	-3784,-3703,-3612,-3513,-3406,-3290,-3166,-3035
	.word	-2896,-2751,-2598,-2440,-2275,-2106,-1931,-1751
	.word	-1567,-1380,-1189,-995,-799,-601,-401,-201
cos_t
	.word	0,201,401,601,799,995,1189,1380
	.word	1567,1751,1931,2106,2275,2440,2598,2751
	.word	2896,3035,3166,3290,3406,3513,3612,3703
	.word	3784,3857,3920,3973,4017,4052,4076,4091

	.word	4096,4091,4076,4052,4017,3973,3920,3857
	.word	3784,3703,3612,3513,3406,3290,3166,3035
	.word	2896,2751,2598,2440,2275,2106,1931,1751
	.word	1567,1380,1189,995,799,601,401,201

	.word	0,-200,-401,-601,-799,-995,-1189,-1380
	.word	-1567,-1751,-1931,-2105,-2275,-2440,-2598,-2750
	.word	-2896,-3035,-3166,-3290,-3406,-3513,-3612,-3703
	.word	-3784,-3857,-3920,-3973,-4017,-4052,-4076,-4091

	.word	-4096,-4091,-4076,-4052,-4017,-3973,-3920,-3857
	.word	-3784,-3703,-3612,-3513,-3406,-3290,-3166,-3035
	.word	-2896,-2751,-2598,-2440,-2275,-2106,-1931,-1751
	.word	-1567,-1380,-1189,-995,-799,-601,-401,-201



#*******************************
* Check for ball collision with a player
* A8=*Ball obj
* Trashes scratch

 SUBR	ball_chkpcollide

	PUSH	a2,a3,a4,a5,a6,a7,a10,a11

	movk	4,a7
	move	*a8(OXPOS),a4
	move	*a8(OXANI+16),a14
	add	a14,a4			;A4=Center X
	move	*a8(OZPOS),a6		;A6=Z
	movi	plyrobj_t,a5

	movk	18,a10			;A10=Z coll radius
	move	*a8(OYPOS),a0
	cmpi	-28,a0
	jrlt	#lp
	move	*a8(OYVEL),a0,L
	abs	a0
	cmpi	>c000,a0
	jrgt	#lp
	movi	35,a10			;Larger radius

#lp	move	*a5+,a11,L

	move	*a11(OPLINK),a2,L
	move	*a2(plyr_attrib_p),a2,L
	move	*a2(PAT_DEFSKILL),a2
	sll	4,a2
	subk	18,a10
	jrz	#tbl1
	addi	tbl2,a2
	jruc	#tbo
#tbl1	
	addi	tbl1,a2
#tbo	move	*a2,a10


	move	*a11(OZPOS),a2		;>Chk Z
	sub	a6,a2
	abs	a2
	sub	a10,a2
	jrge	#nxt

	move	*a11(OXPOS),a1		;>Chk box X
	move	*a11(OXANI+16),a14
	add	a14,a1
	move	*a11(OSIZEX),a14
	srl	1,a14			;/2
	sub	a14,a1
	cmp	a1,a4
	jrle	#nxt			;Center X <= lft?
	sll	1,a14
	add	a14,a1
	cmp	a1,a4
	jrge	#nxt			;Center X >= rgt?

	move	*a11(OYPOS),a1
	move	*a8(OYPOS),a0
	addk	3,a0
	move	*a13(plyr_seq),a14
	cmpi	RUNDRIBTURB_SEQ,a14
	jrhi	#handhi			;Hand higher than shoulder?

;MJT
	move	*a11(OPLINK),a14,L
	move	*a14(plyr_attrib_p),a14,L
	move	*a14(PAT_DEFSKILL),a14
	sll	4,a14
	addi	tbl3,a14
	move	*a14,a14
	add	a14,a0
;	addk	15,a0


#handhi	cmp	a1,a0
	jrlt	#nxt			;Too hi?

	move	*a11(OPLINK),a3,L
	move	*a3(plyr_shtdly),a14
	jrgt	#nxt5			;Can't touch?

	move	@ballpnum,b0	;a14
	jrn	#ok

;Ball is owned by someone

	sll	5,b0		;a14
	addi	plyrproc_t,b0	;a14
	move	*b0,b0,L	;a14,a14,L
	move	b0,a14
	cmp	a14,a3
	jrz	#skpz
	move	*b0(plyr_seqflgs),b0	;a14	a6
	btst	LAYUP_B,b0
	jrnz	#guydunking
	btst	DUNK_B,b0
	jrnz	#guydunking
#skpz
	move	*a14(plyr_seq),a14
	cmpi	SHOOT_SEQ,a14
	jrnz	#ok
	jruc	#nxt5

takedunk_t
	.word	0,0,0,0,0,0,0,0,0,0,0,50,100,150,300,400,500,600,700,800,999,999

#guydunking
;Guy with ball is dunking!
	PUSH	a0,a1

	move	*a14(plyr_num),a0
	move	@plyr_maxpower,a1
	btst	a14,a1
	jrz	#nochng
;This guy has max power!  Can't take ball!
	movk	9,a0
	jruc	#maxp
#nochng
	move	*a14(plyr_attrib_p),a14,L
	move	*a14(PAT_POWER),a0		;Guy trying to dunk ball
#maxp



	move	*a11(OPLINK),a14,L
	move	*a14(plyr_attrib_p),a14,L
	move	*a14(PAT_POWER),a14		;Guy trying to take ball
	cmpi	3,a14
	jrle	#nxt0z				;3 power can't take ball!

	sub	a14,a0				;a0=-10 thru 10
	addk	10,a0
	sll	4,a0
	addi	takedunk_t,a0
	move	*a0,a0
	jrz	#ok0
	calla	RNDPER
	jrls	#ok0
#nxt0z						;3 power can't take ball!
	PULL	a0,a1
	jruc	#nxt				;To big, don't lose ball!
#ok0
	PULL	a0,a1
#ok
	move	*a3(plyr_jmpcnt),a14
	jrle	#ongnd
	move	*a3(plyr_aniy),a14
	add	a14,a1
	sra	2,a14			;/4
	sub	a14,a1			;75% down from top
	cmp	a1,a0
	jrge	#nxt3			;Ball too low?
#ongnd

	move	*a3(plyr_seqflgs),a14
	btst	BLOCKREB_B,a14
	jrz	#nobr			;No?

	addk	18-12,a2
	jrge	#nxt2			;Too far from Z?
					;>Chk box X
	move	*a11(OIMG),a2,L
	move	*a2(IANI2X),a0

	move	*a11(OCTRL),a14
	btst	B_FLIPH,a14
	jrz	#nof			;No flip?

	move	*a2,a2			;ISIZEX
	subk	1,a2
	neg	a0
	add	a2,a0			;+size
#nof
	move	*a11(OXPOS),a14
	add	a14,a0
	sub	a4,a0
	abs	a0

;MJT
	move	*a11(OPLINK),a14,L
	move	*a14(plyr_attrib_p),a14,L
	move	*a14(PAT_DEFSKILL),a14
	sll	4,a14
	addi	tbl4,a14
	move	*a14,a14
	sub	a14,a0
;	subk	12,a0

	jrge	#nxt4			;Too far from X?


	move	@ballpnum,a1
	jrn	#noow			;No owner?
	move	*a3(plyr_num),a14
	cmp	a1,a14
	jreq	#nxt			;I own?

	srl	1,a1
	srl	1,a14
	cmp	a1,a14
	jreq	#nxt			;Teammate owns?


;MJT
	move	*a3(plyr_num),a0
	move	@plyrnumonfire,a1
	cmp	a0,a1
	jrz	#noow			;If on fire, don't miss as often

	move	*a11(OPLINK),a14,L
	move	*a14(plyr_attrib_p),a14,L
	move	*a14(PAT_DEFSKILL),a14
	sll	4,a14
	addi	tbl5,a14
	move	*a14,a0
	calla	RNDPER
	jrhi	#nxt

;	movk	1,a0
;	callr	rnd
;	jrnz	#nxt5			;50% skip?

#noow
	PUSH	a7
	CREATE0	fix_airb
	PULL	a7

;	movk	1,a0
;	move	a0,@plyrairballoff	;Shut off eventual airball snd

	move	@ballprcv_p,a2,L
	cmp	a3,a2
	jreq	#rcvok			;The receiver is touching it?


	move	@ballgoaltcnt,a0	;>Chk goaltending
	jrle	#skipgt
	move	@ballpnumshot,a1
	move	*a3(plyr_num),a14
	srl	1,a1
	srl	1,a14
	cmp	a1,a14
	jreq	#nxt			;Same team?

;Turmell, allow ball to be blocked at peak of arc
	move	*a8(OYVEL),a0,L
	move	a0,a2
	sra	14,a0
	jrle	#nogt
;Turmell

	move	*a3(plyr_num),a0
	move	@plyrnumonfire,a1
	cmp	a0,a1
	jrz	#nogt

;Try #goalt
	move	*a3(plyr_ptsdown),a0

	subk	5,a0
	jrlt	#normgt			;I'm losing by 5?
;	cmpi	[3,8000h],a2
	cmpi	[3,0000h],a2
	jrlt	#nogt
	jruc	#gt
#normgt
;	cmpi	[2,8000h],a2
	cmpi	[2,0000h],a2
	jrlt	#nogt

#gt
	movk	6,a0
	calla	rnd
	jrnz	#nxt
	
	move	@plyrairballoff,a0
	jrn	#nogt
	move	@shot_percentage,a0
	jrn	#nogt
	

	move	*a3(plyr_num),a0
	sll	4,a0 			;Secret goaltend
	.ref	p1taps
	addi	p1taps,a0
	move	*a0,a0
	cmpi	24,a0
	jrnz	#nosec1

	movi	700,a0			;Let this guy get away with GT
	calla	RNDPER
	jrhi	#nogt

;	jruc	#nogt

#nosec1
	move	a7,a2
	CREATE0	plyr_goaltending	;Pass A11
	move	a2,a7
	jruc	#skipgt
#nogt
	movk	PS_BLOCKS,a0		;It's a block
	move	*a3(plyr_num),a1
	calla	inc_player_stat

;call rejected speech here
	calla	rejected_speech

	movi	steal_snd,a0
	calla	snd_play1
	PUSH	a7,a10
	move	a3,a10
	calla	arw_on1plyr		;Guy who picks up ball gets arw
	PULL	a7,a10

#skipgt

	callr	flash_ball
	movi	cheer_snd,a0
	calla	snd_play1
	callr	get_swat

	move	*a3(plyr_seq),a2
	cmpi	REBOUND_SEQ,a2
	jreq	#agiveball
	cmpi	REBOUNDA_SEQ,a2
	jrnz	#fix


#agiveball
	PUSH	a3

;call rebound speech here
	move	@ballpnum,a0
	jrn	#ballfree

	movi	stealsb,a0		;steals the ball
	calla	snd_play1ovrp
;	calla	stolen_speech

	jruc	#skiprbnd
#ballfree
	move	@ballgoaltcnt,a0	;>Chk goaltending
	jrgt	#skiprbnd
	move	@ballprcv_p,a0,L
	jrz	#isreb
	calla	intercepted_speech
	jruc	#skiprbnd
#isreb
	move	*a3(plyr_num),a14
	move	a14,@ballpnum
	clr	a0
	move	a0,*a3(plyr_dribmode)	;Reset dribble

	move	@inbound,a0
	jrnn	#skiprbnd

	move	@gmqrtr,a0
	jrnz	#okr
	move	@game_time,a0,L
	cmpi	>2050400,a0
	jrgt	#nor

#okr
	calla	rebound_speech
#nor
	movi	80,a0
	move	a0,@pushing_delay
	movi	15,a0
	calla	plyr_setshtdly
	PULL	a3

	jruc	#x

fix_airb
	movk	1,a0
	move	a0,@plyrairballoff	;Shut off eventual airball snd
	DIE

#skiprbnd
	movi	80,a0
	move	a0,@pushing_delay
	movi	15,a0
	calla	plyr_setshtdly
	PULL	a3
	jruc	#giveball
#fix
	subk	BLOCKREJ_SEQ,a2
	jreq	#rej

	movk	3,a0			;>Regular block
	callr	rnd

;This is for a block dunk, but if a player jumps in front of a pass
;this code is also executed.  And ball has a chance of bouncing back at
;full speed toward passer!

	jrnz	#glance_off

	movi	steal_snd,a0
	calla	snd_play1
	movi	80,a0
	move	a0,@pushing_delay
	PUSH	a7,a10
	move	a3,a10
	calla	arw_on1plyr
	PULL	a7,a10

;Block dunk stat
	movk	PS_BLOCKS,a0		;It's a block
	move	*a3(plyr_num),a1
	calla	inc_player_stat
 
;dunk rejected speech here!
;FIX, this is where bogus rejected speech calls come from
	calla	rejected_dnk_speech
;	LOCKUP
;Go into rebound sequence to make spear look better
	jruc	#giveball

#glance_off
	PUSH	a3
	movi	15,a0
	calla	plyr_setshtdly
	PULL	a3

	move	@ballgoaltcnt,a0
	jrgt	#ablk

;This is when a pass or sometimes when a dunk gets rejected!
;This also happens when a player jumps on a ball which is sitting on ground!

	move	*a8(OYPOS),a0
	addk	30,a0			;Not if ball near ground
	jrgt	#x

	move	*a3(plyr_dir),a0
	callr	sinecos_get
	sll	5,a0			;*32
	sll	5,a1
	move	a0,*a8(OZVEL),L
	move	a1,*a8(OXVEL),L

	movi	-GRAV*22,a1		;Towards roof

	move	a1,*a8(OYVEL),L

;New, 1/22/93
	move	@PCNT,a0
	ANDK	7,a0
	jrnz	#x

	movk	25,a0
	move	a0,*a3(plyr_shtdly)
;dunk rejected speech here! (plyr doesn't have ball though)
	calla	rejected_dnk_speech

	jruc	#x

#ablk
;2/3/92
	clr	a0
	move	a0,@ballgoaltcnt

;	LOCKUP	

;2/3/92
	movi	-GRAV*15,a1		;Towards roof
	move	a1,*a8(OYVEL),L


	movk	>1f,a0
	callr	rnd
	btst	0,a0
	jrz	#noxf
	move	*a8(OXVEL),a2,L
	neg	a2
	move	a2,*a8(OXVEL),L
#noxf
	btst	1,a0
	jrz	#nxt
	move	*a8(OZVEL),a2,L
	neg	a2
	move	a2,*a8(OZVEL),L

;	clr	a0
;	move	a0,@ballgoaltcnt

	jruc	#nxt

#rej
	movk	PS_BLOCKS,a0		;It's a block
	move	*a3(plyr_num),a1
	calla	inc_player_stat
	move	*a3(plyr_dir),a0
	callr	sinecos_get
	sll	5,a0			;*32
	sll	5,a1
	move	a0,*a8(OZVEL),L
	move	a1,*a8(OXVEL),L
	movi	-GRAV*21,a1		;Towards roof ;18
	move	a1,*a8(OYVEL),L
	movk	15,a0
	move	a0,*a3(plyr_shtdly)

	callr	def_play_reward		;Good defensive play reward

	clr	a0
	move	a0,@ballgoaltcnt
	jruc	#nxt

#nobr
	move	@ballpnum,a2
	jrlt	#giveball		;No owner?
	move	*a3(plyr_num),a14
	cmp	a2,a14
	jreq	#nxt			;I already have it?

	move	*a3(plyr_seq),a0
	subi	STEAL_SEQ,a0
	jrne	#nxt

;Shawn, we should probably adjust this % based upon ptsdown!
;200 is if you are losing, but if you are winning, slowly reduce %

;Turmell
	move	*a3(plyr_attrib_p),a0,L
	move	*a0(PAT_STLSKILL),a0
	sll	4,a0
	addi	stl1,a0
	move	*a0,a0
;	movi	190,a0			;120

	calla	RNDPER
	jrls	#nxt			;No steal?

	sll	5,a2			;*32
	addi	plyrproc_t,a2
	move	*a2,a2,L

	move	*a2(plyr_seqflgs),a0
	btst	NOSTEAL_B,a0
	jrnz	#nxt			;Ball can't be stolen?


	move	@steals_off,a0
	jrnz	#nxt

	movk	PS_STEALS,a0
	move	*a3(plyr_num),a1
	calla	inc_player_stat

	move	*a3(plyr_attrib_p),a0,L
	move	*a0(PAT_STLSKILL),a0
	sll	4,a0
	addi	stl2,a0
	move	*a0,a0
;	movi	180,a0

	calla	RNDPER
	jrhi	#giveballflsh		;20% give him the ball?

	movk	15,a0			;>Knock it away
	move	a0,*a2(plyr_shtdly)
	move	a0,*a3(plyr_shtdly)

	movi	-1,a0
	move	a0,@ballpnum
	move	a0,@ballpnumlast
	callr	ball_convfmprel2

	movi	>1ffff,a2		;>Give rnd velocity
	movi	>10000,a3
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

	callr	flash_ball
	callr	get_swat
	movi	cheer_snd,a0
	calla	snd_play1

	jruc	#nxt

stl1	.word	160,170,180,195,200
	.word	205,215,245,260,285
	.word	300

stl2	.word	160,170,180,195,200
	.word	205,215,225,230,235
	.word	250


#giveballflsh

;steals ball speech (ball sticks to player)
	calla	stolen_speech

	movk	30,a0
	move	a0,@steals_off
	movk	25,a0
	move	a0,@pass_off
	movi	80,a0
	move	a0,@pushing_delay
	callr	flash_ball
	callr	get_swat
	movi	cheer_snd,a0
	calla	snd_play1


#giveball
	move	@ballprcv_p,a2,L
	jrz	#norcvr			;No pass receiver?
	cmp	a3,a2
	jreq	#rcvok			;The receiver has it?

	movi	99,a0
	callr	rndrng0

	clr	a14
	move	*a3(plyr_ptsdown),a1
	jrle	#normint		;!Losing?

	cmpi	15,a1
	jrle	#maxpts2
	movk	15,a1

#maxpts2
	movi	150,a14			;Secret steal power!
	move	*a3(plyr_num),a6
	.ref	stlpower
	move	@stlpower,a4
	btst	a6,a4
	jrnz	#normint

	sll	4,a1
	addi	#int_t,a1
	move	*a1,a14

#normint
	move	@ballpasstime,a1
	subk	3,a1
	abs	a1
	srl	1,a1			;/2
	add	a14,a1
	addk	1,a1			;1% to 100%
	cmp	a1,a0
	jrge	#nxt			;% failed?

;Still too many steals

	movi	400,a0			;650 ,450
	calla	RNDPER
	jrls	#nxt			;br=nope


	PUSH	a2,a8

	move	*a8(OXVAL),a6,L		;Figure out where ball was 4 ticks ago
	move	*a8(OZVAL),a7,L

	move	*a8(OXVEL),a1,L
	sll	2,a1
	sub	a1,a6
	move	*a8(OZVEL),a1,L
	sll	2,a1
	sub	a1,a7

	sra	16,a6
	sra	16,a7

	move	a11,a8

	calla	seekdirdist_obxz128
	move	a0,*a3(plyr_newdir)	;Turn toward ball

	PULL	a2,a8

	move	*a2(plyr_rcvpass),a0
	jrle	#rcvok0			;Already caught?

	clr	a14			;Intercepted
	move	a14,*a2(plyr_rcvpass)
	move	*a2(plyr_jmpcnt),a0
	jrnz	#inair			;Jumping?
	move	a14,*a2(plyr_nojoy)
#inair


;Shawn, Sometimes the ball can be intercepted and you do not fall thru
;this ball flash, etc. code (Below).  I moved the flash/snd stuff up
;in front of the code which checks if ball has already been caught, but then
;when an errant pass is picked up, it does the flash stuff.

	callr	def_play_reward		;Good defensive play reward

	movi	40,a0			;2% of intercepts are just deflects
	calla	RNDPER
	jrls	#nope

;Sometimes, just have ball bounce off the defender

	movi	intercept,a0
	calla	snd_play1ovrp

	move	*a3(plyr_dir),a0
	callr	sinecos_get
	sll	5,a0			;*32
	sll	5,a1
	move	a0,*a8(OZVEL),L
	move	a1,*a8(OXVEL),L
	movi	-GRAV*25,a1		;Towards roof
	move	a1,*a8(OYVEL),L
	movk	PS_STEALS,a0
	move	*a3(plyr_num),a1
	calla	inc_player_stat

;Turmell
;2/4/92
	jruc	#x			;#nxt

#nope

;intercepted speech call here

	move	@ballprcv_p,a0,L	;*Plyr proc who gets this pass or 0
	jrz	#nopass

	move	@ballpasstime,a0	;# ticks since passed
	cmpi	6,a0
	jrle	#cntstl			;#nopass

	calla	intercepted_speech
	jruc	#cntstl

#nopass
	calla	stolen_speech

#cntstl

	movk	PS_STEALS,a0
	move	*a3(plyr_num),a1
	calla	inc_player_stat
	jruc	#rcvok

#rcvok0
	PUSH	a7,a10
	move	a3,a10
	calla	arw_on1plyr		;Guy who picks up ball gets arw
	PULL	a7,a10

#rcvok
	clr	a14
	move	a14,@ballprcv_p,L

#norcvr
	move	*a3(plyr_num),a14
	move	a14,@ballpnum
	clr	a0
	move	a0,*a3(plyr_dribmode)	;Reset dribble
	
	move	*a11(OIMG),a0,L
	cmpi	w1blok3,a0
	jrz	#ahha
	cmpi	w2blok3,a0
	jrz	#ahha
	cmpi	w4blok3,a0
	jrz	#ahha
	cmpi	w5blok3,a0
	jrz	#ahha
	cmpi	w1blok2,a0
	jrz	#ahha
	cmpi	w2blok2,a0
	jrz	#ahha
	cmpi	w4blok2,a0
	jrz	#ahha
	cmpi	w5blok2,a0
	jrnz	#x

#ahha
;	 LOCKUP
;Player is spearing the ball!
	movk	NOSPEAR_SEQ,a0
	move	*a3(plyr_dir),a7
	PUSH	a13
	move	a3,a13
	calla	plyr_setseq
	movk	1,a0
	move	a0,*a13(PA10),L
	PULL	a13

;	movi	swat3_snd,a0
;	calla	snd_play1

	jruc	#x

#nxt5	
;	LOCKUP
	nop
	nop
#nxt2
	nop
	nop
#nxt3
	nop
	nop
#nxt4
	nop
	nop


#nxt	dsj	a7,#lp


#x	PULL	a2,a3,a4,a5,a6,a7,a10,a11
	rets

tbl1	.word	16,17,18,18,18,18,18,19,20,21,22,23
;tbl1	.word	18,18,18,18,18,18,18,18,18,18,18,18
tbl2	.word	32,33,34,35,35,35,35,36,37,38,39,40
;tbl2	.word	35,35,35,35,35,35,35,35,35,35,35,35
tbl3	.word	15,15,15,15,15,15,15,15,15,15,15,15
tbl4	.word	11,12,12,12,12,12,12,13,14,15,16,17
;tbl4	.word	12,12,12,12,12,12,12,12,12,12,12,12
;tbl5	.word	500,500,500,500,500,500,500,500,400,300,200,200
tbl5	.word	500,500,500,500,500,500,500,500,500,500,500,500


#goalt_t
;Extra % chance of allowing losing team to get away with a goaltend
;1 pt down up to 15 & over down
	.word	0,35,45,55,60,65,70,75,75
	.word	75,80,90,90,90,90,90

#int_t
;Bonus % of losing team getting an intercept
;1 pt down up to 15 & over down
;Turmell
	.word	0,4,7,10,12,15,19,20,20,20
	.word	20,20,22,25,27,30


********************************
* Random swat sound

 SUBR	get_swat
	movi	swat_snd,a0
	calla	snd_play1
	rets


;	movk	3,a0
;	callr	rndrng0
;	sll	5,a0
;	addi	#swtsnds,a0
;	move	*a0,a0,L
;	calla	snd_play1
;	rets
;
;#swtsnds
;	.long	swat_snd,swat_snd,swat_snd,swat_snd


********************************
* Good defensive play reward

 SUBR	def_play_reward

	callr	flash_ball

	movi	steal_snd,a0
	calla	snd_play1
	callr	get_swat
	movi	cheer_snd,a0
	calla	snd_play1

	PUSH	a7,a10
	move	a3,a10
	calla	arw_on1plyr		;Guy who picks up ball gets arw
	PULL	a7,a10

	rets


 SUBR	flash_reward

	callr	flash_ball

	movi	cheer_snd,a0
	calla	snd_play1
	callr	get_swat
	rets



#*******************************
* Flash ball

 SUBRP	flash_ball

	move	@inbound,a0
	jrnn	#x
	move	@ballflash,a0
	jrnz	#x
	PUSH	a7
	CREATE0	ball_flash
	PULL	a7
#x	rets	


ball_flash
	movk	1,a0
	move	a0,@ballflash

	move	@ballobj_p,a8,L		;Basketball obj

	movi	1010h,a2
	move	a2,*a8(OCONST)

	movk	4,a10
#again
	setf	4,0,0
	movk	M_CONNON,a0		;Replace non-zero data with constant
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0

	SLEEPK	3

	setf	4,0,0
	movk	M_WRNONZ,a0
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0

	SLEEPK	3

;	move	@inbound,a0
;	jrnn	#die

	dsj	a10,#again

#die	clr	a0
	move	a0,@ballflash

	DIE



#*******************************
* Jump shot crowd sounds (process)

 SUBR	plyr_jscrowdsnd

	SLEEPK	10
	movi	cheer1_snd,a0
	calla	snd_play1
	movi	cheer2_snd,a0
	calla	snd_play1
	SLEEP	76
	movk	9,a0
	callr	rndrng0
	subk	7,a0
	jalt	SUCIDE		;70%

	movi	cheer3_snd,a0
	calla	snd_play1
;	movi	cheer2_snd,a0
;	calla	snd_play1
;	movi	cheer3_snd,a0
;	calla	snd_play1
;	movi	cheer4_snd,a0
;	calla	snd_play1
;	SLEEP	150
;	movi	cheer5_snd,a0
;	calla	snd_play1
;	movi	cheer6_snd,a0
;	calla	snd_play1
	DIE


#*******************************
* Convert ball from player relative
* Trashes scratch

 SUBR	ball_convfmprel

	move	@ballobj_p,a0,L

	move	*a0(OIMG),a1,L		;>Convert ball from player relative
	move	*a1(IANIOFFX),a1
	sll	16,a1
	move	*a0(OXANI),a14,L
	move	a1,*a0(OXANI),L
	sub	a14,a1			;Ani difference

;	sra	16-5,a1
;	move	*a0(OZPOS),a14		;894 to 1379 (Z range 486)
;	addi	(819-GZBASE),a14	;768 to ?
;	mpys	a14,a1
;	move	a1,a14
;	sra	2,a14			;/4
;	sub	a14,a1
;	sra	1,a14			;/2
;	sub	a14,a1
;	sll	16-(14+1),a1		;*64k /16k /2
;
;	move	*a0(OXVAL),a14,L	;Adjust X
;	sub	a1,a14
;	move	a14,*a0(OXVAL),L

	rets

#*******************************
* Convert ball from player relative
* Trashes scratch

 SUBR	ball_convfmprel2

	move	@ballobj_p,a0,L

	move	*a0(OIMG),a1,L		;>Convert ball from player relative
	move	*a1(IANIOFFX),a1
	sll	16,a1
	move	*a0(OXANI),a14,L
	move	a1,*a0(OXANI),L
	sub	a14,a1			;Ani difference

	sra	16-5,a1
	move	*a0(OZPOS),a14		;894 to 1379 (Z range 486)
	addi	(819-GZBASE),a14	;768 to ?
	mpys	a14,a1
	move	a1,a14
	sra	2,a14			;/4
	sub	a14,a1
	sra	1,a14			;/2
	sub	a14,a1
	sll	16-(14+1),a1		;*64k /16k /2

	move	*a0(OXVAL),a14,L	;Adjust X
	sub	a1,a14
	move	a14,*a0(OXVAL),L

	rets


#*******************************
* Set ptsdown for each plyr
* Trashes scratch

	.ref	assistance_off

 SUBR	plyr_setptsdown

	PUSH	a2,a3,a4,a5,a6

	movi	scores,a14
	move	*a14+,a0
	move	*a14+,a4
	sub	a0,a4			;+ if losing, - if winning

	move	@PSTATUS,a5

	movi	plyrproc_t,a6
	movk	4,a3

#lp
	move	a4,a2
	srl	1,a5
	jrnc	#set			;Drone?

	move	@PSTATUS,a0
	move	a0,a1
	sll	32-2,a0
	jrz	#set			;Drone team?
	ANDK	>c,a1
	jrz	#set			;Drone team?

	move	@assistance_off,a0
	jrnz	#noset

	movk	ADJCOMPASS,a0		;Computer assistance
	calla	GET_ADJ			;0-1
	jrz	#set			;On?
#noset
	clr	a2
#set
	move	*a6+,a0,L
	move	a2,*a0(plyr_ptsdown)

	cmpi	3,a3
	jrne	#nxt
	neg	a4

#nxt	dsj	a3,#lp

	PULL	a2,a3,a4,a5,a6
	rets



#*******************************
* Shatter backboard (Process)

 SUBRP	board_shatter

	movi	explode_snd,a0
	calla	snd_play1ovr

	movi	ohmy,a0			;oh my!
	calla	snd_play1ovr

	CREATE0	board_glssnd
	movk	10,a1
	move	a1,*a0(PTIME)

	move	@ballpnumshot,a11
	movk	10,a8
	move	a11,a0
	subk	2,a0
	jrnz	#n0
	addk	1,a0
#n0	move	a0,@bbshatter
#shlp
	movk	13,a2
#shlp2	CREATE0	board_shard
	dsj	a2,#shlp2
	SLEEPK	1
	dsj	a8,#shlp

	DIE

board_glssnd
;Turmell
	SLEEPK	10
	movi	explode_snd,a0
	calla	snd_play1ovr
;	SLEEPK	20
;	movi	glass_snd,a0
;	calla	snd_play1ovr
	DIE

********************************
* Flying shard of glass (Process)
* A11=Plyr # who shot the ball (0-3)

	STRUCTPD
	APTR	shd_ani1st_p	;*1st ani_l pos

 SUBRP	board_shard

	movk	10,a0
	callr	rndrng0
	sll	5,a0			;*32
	addi	#shard_t,a0
	move	*a0,a9,L
	move	*a9+,a0,L
	PUSHP	a0
	move	a9,*a13(shd_ani1st_p),L

	movk	>f,a0
	callr	rnd
	subk	5,a0
	move	a0,a6
	sll	13,a6			;XVel

	movk	3,a0
	callr	rnd
	jrnz	#xnorm
	sll	2,a6			;*4
#xnorm
	movk	>f,a0
	callr	rnd
	subk	6,a0
	move	a0,a7
	sll	14,a7			;YVel

	movk	3,a0
	callr	rnd
	jrnz	#ynorm
	sll	2,a7			;*4
#ynorm

	movi	36,a0
	callr	rndrng0
	move	a0,a1
	neg	a1			;Y offset

	movi	HOOPLX-13,a0
	subk	2,a11
	jrge	#p23
	movi	HOOPRX+13,a0
	neg	a6
#p23
	sll	16,a0
	addi	HOOPY,a1
	sll	16,a1
	movi	shard1_1,a2
	movi	CZMID,a3
	movi	DMAWNZ|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	calla	BEGINOBJ2

	movk	7,a0
	callr	rnd
	subk	4,a0
	sll	16,a0
	move	a0,*a8(OZVEL),L

	movk	1,a0
	callr	rnd
	addk	1,a0
	move	a0,a11
	jruc	#strt

#lp	dsj	a10,#noani
#strt
	move	a11,a10
;	move	*a9+,a10
;	jrz	#x
	move	*a9+,a0,L
	jrnz	#ani
	move	*a13(shd_ani1st_p),a9,L
	move	*a9+,a0,L
#ani
	move	*a8(OCTRL),a1
	calla	obj_aniq
#noani
	SLEEPK	1
	move	*a8(OYVEL),a2,L
	addi	GRAV,a2
	move	a2,*a8(OYVEL),L
	jrn	#lp			;Going up?
	move	*a8(OYVAL),a1,L
	jrlt	#lp			;Above gnd?
	clr	a1
	move	a1,*a8(OYVAL),L
	move	@HCOUNT,a14
	sll	32-2,a14
	jrz	#shatter
	neg	a2
	sra	2,a2
	move	a2,*a8(OYVEL),L
	cmpi	-(GRAV*2),a2
	jrlt	#lp

#shatter
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OZVEL),L

;	movk	3,a0
;	callr	rnd
;	sll	5,a0			;*32
;	addi	#shat_t,a0
;	move	*a0,a9,L
	PULLP	a9
	movk	3,a10
	jruc	#strt2

#lp2
;	dsj	a10,#noani2
;	movk	2,a10
	move	*a8(OCTRL),a1
	calla	obj_aniq
#noani2
	SLEEPK	1
#strt2	move	*a9+,a0,L
	jrnz	#lp2


	jauc	DELOBJDIE


#shard_t
	.long	s1_t,s2_t,s3_t,s4_t,s5_t,s6_t,s7_t,s8_t
	.long	s1_t,s6_t,s8_t

s1_t
	.long	st4_t
	.long	shard1_1
	.long	shard1_2
	.long	shard1_3
	.long	shard1_4
	.long	shard1_5
	.long	shard1_6
	.long	shard1_7
	.long	shard1_8
	.long	0
s2_t
	.long	st3_t
	.long	shard2_1
	.long	shard2_2
	.long	shard2_3
	.long	shard2_4
	.long	shard2_5
	.long	shard2_6
	.long	shard2_7
	.long	shard2_8
	.long	0
s3_t
	.long	st2_t
	.long	shard3_1
	.long	shard3_2
	.long	shard3_3
	.long	shard3_4
	.long	shard3_5
	.long	shard3_6
	.long	shard3_7
	.long	shard3_8
	.long	shard3_9
	.long	shard3_10
	.long	shard3_11
	.long	shard3_12
	.long	0
s4_t
	.long	st1_t
	.long	shard4_1
	.long	shard4_2
	.long	shard4_3
	.long	shard4_4
	.long	shard4_5
	.long	shard4_6
	.long	shard4_7
	.long	shard4_8
	.long	shard4_9
	.long	shard4_10
	.long	0
s5_t
	.long	st2_t
	.long	shard5_1
	.long	shard5_2
	.long	shard5_3
	.long	shard5_4
	.long	shard5_5
	.long	shard5_6
	.long	shard5_7
	.long	shard5_8
	.long	0
s6_t
	.long	st4_t
	.long	shard6_1
	.long	shard6_2
	.long	shard6_3
	.long	shard6_4
	.long	shard6_5
	.long	shard6_6
	.long	shard6_7
	.long	shard6_8
	.long	0
s7_t
	.long	st2_t
	.long	shard7_1
	.long	shard7_2
	.long	shard7_3
	.long	shard7_4
	.long	shard7_5
	.long	shard7_6
	.long	shard7_7
	.long	shard7_8
	.long	shard7_9
	.long	shard7_10
	.long	0
s8_t
	.long	st4_t
	.long	shard8_1
	.long	shard8_2
	.long	shard8_3
	.long	shard8_4
	.long	shard8_5
	.long	shard8_6
	.long	shard8_7
	.long	shard8_8
	.long	shard8_9
	.long	shard8_10
	.long	0

;#shat_t
;	.long	st1_t,st2_t,st3_t,st4_t
st1_t	.long	shat1_1
	.long	shat1_2
	.long	shat1_3
	.long	shat1_4
	.long	shat1_5
	.long	0
st2_t	.long	shat2_1
	.long	shat2_2
	.long	shat2_3
	.long	shat2_4
	.long	shat2_5
	.long	0
st3_t	.long	shat3_1
	.long	shat3_2
	.long	shat3_3
	.long	shat3_4
	.long	shat3_5
	.long	0
st4_t	.long	shat4_1
	.long	shat4_2
	.long	shat4_3
	.long	shat4_4
	.long	shat4_5
	.long	0


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




****************************************************************
* Sequence code may trash scratch, A2-A5

********************************
* Sequence - stand
* A11=*PxCTRL
* >B4=*Start of seq list

 SUBR	seq_stand

	clr	a0
	move	a0,*a13(plyr_nojoy)

	movk	STND_SEQ,a0		;Set stand sequence
	move	*a13(plyr_ownball),a1
	jrle	#set


	move	*a13(plyr_num),a2
	srl	1,a2
	XORK	1,a2
	sll	6,a2			;*64
	addi	plyrproc_t,a2
	move	*a2+,a4,L
	move	*a2+,a5,L
	move	*a13(plyr_o1dist),a0
	cmpi	60,a0
	jrge	#chko2			;Too far?
	subk	30,a0
	jrlt	#doelbo			;In close?
	move	*a4(plyr_seq),a14
	subi	STEAL_SEQ,a14
	jreq	#doelbo
	subk	PUSH_SEQ-STEAL_SEQ,a14
	jreq	#doelbo
#chko2
	move	*a13(plyr_o2dist),a0
	cmpi	60,a0
	jrge	#stndwb			;Too far?
	subk	30,a0
	jrlt	#doelbo			;In close?
	move	*a5(plyr_seq),a14
	subi	STEAL_SEQ,a14
	jreq	#doelbo
	subk	PUSH_SEQ-STEAL_SEQ,a14
	jrne	#stndwb
#doelbo
	move	*a13(plyr_autoctrl),a14
	jrnz	#stndwb

	move	@game_time,a1,L		;If under 2 secs, no elbow
	cmpi	>200,a1
	jrle	#stndwb

	movi	ELBO_SEQ,a0
	move	*a13(plyr_seq),a14
	cmp	a0,a14
	jrne	#setnostl		;!In elbo?
	move	*a11,a1
	sll	32-6,a1
	jrz	#set			;No buttons?


#stndwb	movk	STNDWB_SEQ,a0
#set	calla	plyr_setseq

	move	*a13(plyr_ani1st_p),a0,L
	move	a0,b4
	rets



#setnostl
	calla	plyr_setseq

	move	*a13(plyr_ani1st_p),a0,L
	move	a0,b4

	movi	140,a0
	move	a0,@steals_off		;Don't allow steals for 60 ticks
	movi	80,a0
	move	a0,@pushing_delay
	rets



********************************
* Sequence - See if we should stand from steal
* A6=Button bits

 SUBR	seq_stealstand

;Turmell
	move	*a13(plyr_ownball),a0
	jrp	seq_stand

	btst	5,a6
	jrz	seq_stand
	rets


#*******************************
* Sequence - Set new direction (for dunks)
* B4=*Next data in seq list
* >A7=New dir

 SUBR	seq_newdir

	move	*b4+,b0
	move	b0,a7
	move	*a13(plyr_anirevff),a0
	jrz	#x
	srl	4,a7
	sll	3,a7
	addi	#t,a7
	movb	*a7,a7
#x	move	a7,*a13(plyr_dir)
	rets

#t	.byte	0,7*16,6*16,5*16,4*16,3*16,2*16,1*16


#*******************************
* Sequence - Keep falling player from finishing his get up animation until
* he is on the ground

 SUBR	seq_stayinair

	move	*a13(plyr_jmpcnt),a0
	jrz	#x
	subi	2*32+3*16,b4
#x	rets

#*******************************
* Sequence - Keep zx vel for later skid on butt

 SUBR	seq_keepzx

	move	*a8(OXVEL),a0,L
	sla	1,a0
	move	a0,*a13(plyr_kpxvel),L
	move	*a8(OZVEL),a0,L
	sla	1,a0
	move	a0,*a13(plyr_kpzvel),L
	rets

#*******************************
* Sequence - set injury for this player

 SUBR	seq_injury

	movk	PS_INJURY,a0		;>Inc try shot stat
	move	*a13(plyr_num),a1
	calla	inc_player_stat

	rets

#*******************************
* Sequence - Restore zx vel for skid on butt

 SUBR	seq_stuffzx

	move	*a13(plyr_kpxvel),a0,L
	move	a0,*a8(OXVEL),L
	move	*a13(plyr_kpzvel),a0,L
	move	a0,*a8(OZVEL),L

	rets

#*******************************
* Sequence - Change into fire pal

 SUBR	seq_strtfire

;WORD	plyr_keeppal	;Keep pal for reuse upon finish of flames

	move	*a13(plyr_keeppal),a0
	jrnz	#x
	move	*a8(OPAL),a0
	move	a0,*a13(plyr_keeppal)
	movi	FIREFALP,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
;Do head also
	move	*a13(plyr_headobj_p),a1,L
	move	*a1(OPAL),a14
	move	a14,*a13(plyr_hdkeeppal)
	move	a0,*a1(OPAL)
#x
	rets

#*******************************
* Sequence - Change back from fire pal

 SUBR	seq_stopfire

	move	*a13(plyr_keeppal),a0
	jrz	#x
	move	a0,*a8(OPAL)
;Do head also
	move	*a13(plyr_hdkeeppal),a0
	move	*a13(plyr_headobj_p),a1,L
	move	a0,*a1(OPAL)
	clr	a0
	move	a0,*a13(plyr_keeppal)
#x
	rets

#*******************************
* Sequence - Start smoke

 SUBR	seq_smoke

	.ref	plyr_smoketrail2
	CREATE0	plyr_smoketrail2
	move	a13,*a0(PA10),L

	rets


#*******************************
* Sequence - Call a sound
* B4=*Next data in seq list

 SUBR	seq_snd

	move	*b4+,b0,L
	move	b0,a0
	jauc	snd_play1

#*******************************
* Sequence - Turn off the NOBALL flag

 SUBR	seq_noballoff

	move	*a13(plyr_seqflgs),a0
	andni	NOBALL_M,a0
	move	a0,*a13(plyr_seqflgs)

	rets


#*******************************
* Sequence - reset seq, in case dir changed

 SUBR	seq_resetseq

	clr	a0
	move	a0,*a13(plyr_nojoy)

	move	*a13(plyr_seq),a0
	move	a6,a1
	sll	32-4,a1
	jrnz	#set			;Pushing joy?

	movk	STNDDEF_SEQ,a0		;>Setup stand sequence
	move	*a13(plyr_ownball),a14
	jrle	#set
	movk	STNDDRIBDEF_SEQ,a1

#set	jruc	plyr_setseq


#*******************************
* Sequence - Start of run
* B4=*Next data in seq list

 SUBR	seq_run

	move	b4,a0
	addi	4*16,a0
	move	a0,*a13(plyr_ani1st_p),L
	rets


#*******************************
* Sequence - jump
* A6=Button bits

 SUBR	seq_jump

	move	*a13(plyr_seq),a14
	cmpi	LAYUP_SEQ,a14
	jreq	#jmp
	cmpi	HOOK_SEQ,a14
	jreq	#jmp
	cmpi	HOOK2_SEQ,a14
	jreq	#jmp

;No head fake if under 4 secs

	move	@game_time,a0,L
	cmpi	>400,a0
	jrlt	#jmp

	btst	4,a6			;But1 (Shoot/block)
	jrnz	seq_jump2		;Fake?
	SOUND1	fake_snd
	jruc	seq_stand		;Fake?

fake_snd	.word	>f981,60,>816e,0	;Head fake


 SUBR	seq_jump2

#jmp
	movk	1,a0			;Start jump
	move	a0,*a13(plyr_jmpcnt)

	move	*a8(OXVEL),a2,L		;>Reduce vel
	move	*a8(OZVEL),a3,L
	sra	2,a2
	sra	2,a3

	move	*a13(plyr_seq),a0
	cmpi	LAYUP_SEQ,a0
	jrz	#nodesp

	move	*a13(plyr_turbon),a5

	move	*a13(plyr_num),a14
	move	@plyrnumonfire,a0
	cmp	a0,a14
	jrnz	#fire1			;If on fire, don't do turbo jump!
	clr	a5
	jruc	#fire
#fire1

;MJT
	move	*a13(plyr_PDATA_p),a1,L	;If lotsa turbo, still do tall jump!
	move	*a1(ply_turbo),a1
	cmpi	24,a1
	jrlt	#fire			;Turbo too low?

	move	*a13(plyr_turbon),a5
	jrnz	#turb			;Br=taller jump!
#fire
	sra	1,a2
	sra	1,a3
#turb
	move	*a13(plyr_seq),a0
	subk	SHOOTDESP3_SEQ,a0
	jrne	#nodesp
	movi	>20000,a2		;For this desperation shot, we
	move	*a13(plyr_num),a0	;need some x velocity
	subk	2,a0
	jrlt	#nodesp
	movi	->20000,a2
#nodesp


	move	a2,*a8(OXVEL),L
	move	a3,*a8(OZVEL),L


	move	*a8(OZPOS),a14		;894 to 1379 (Z range 486)
	subi	400,a14
	movi	->70,a1
	mpys	a14,a1
	addi	->24000,a1

	move	a5,a5
	jrz	#notur
	addi	->8000,a1
#notur
	move	*a13(plyr_seq),a0
	cmpi	LAYUP_SEQ,a0
	jreq	#noly2
	addi	->8000,a1
#noly2
	move	*a13(plyr_seqflgs),a0
	btst	SHOOT_B,a0
	jrz	#notsh
	move	a1,a0			;-1/16
	sra	4,a0
	sub	a0,a1

	move	*a13(plyr_seq),a14
	cmpi	QSHOOT_SEQ,a14
	jrnz	#notsh
	sra	1,a1

#notsh
	move	a1,*a8(OYVEL),L

	rets



#*******************************
* Sequence - start block jump
* B4=*Next data in seq list

 SUBR	seq_block

	PUSH	a6,a7,a9

	movk	1,a0			;Start jump
	move	a0,*a13(plyr_jmpcnt)


	move	@ballobj_p,a5,L		;>Calc where ball is headed

	move	@ballpnum,a14
	jrn	#binair			;Ball in air?


	move	*a13(plyr_myhoopx),a0
	movi	CZMID,a1

	sll	5,a14
	addi	plyrproc_t,a14
	move	*a14,a14,L
	move	*a14(plyr_seqflgs),a2
	btst	DUNK_B,a2
	jrz	#nodunk

	move	a0,a6			;>Jump at rim
	move	a1,a7
	movi	-200<<16,a9
	addk	6,a6
	cmpi	WRLDMID,a6
	jrlt	#calcintercept
	subk	6+6,a6
	jruc	#calcintercept


#nodunk
	move	*a13(plyr_seq),a14
	subk	BLOCK_SEQ,a14
	jrne	#noblk
	addk	32,b4			;Skip


	PULL	a6,a7,a9

;If not near ball, jump lower and ignore turbo jump!

	move	*a13(plyr_balldist),a0
	cmpi	>100,a0			;About 10 feet away from ball
	jrlt	seq_jump2

	movk	1,a0			;Start jump
	move	a0,*a13(plyr_jmpcnt)

	clr	a0
	move	a0,*a8(OXVEL),L		;Zero vel
	move	a0,*a8(OZVEL),L

	move	*a8(OZPOS),a14		;894 to 1379 (Z range 486)
	subi	400,a14
	movi	->30,a1			;Smaller vertical jump
	mpys	a14,a1
	addi	->24000,a1

	move	a1,*a8(OYVEL),L

	rets

#noblk
	move	*a5(OXPOS),a6		;>In front of plyr between basket
	move	*a5(OXANI+16),a14
	add	a14,a6
	move	*a5(OZPOS),a7
	movi	-200<<16,a9

	sub	a6,a0
	sub	a7,a1
	move	a0,a2
	move	a1,a3
	abs	a2
	abs	a3
	cmp	a3,a2
	jrge	#scl
	move	a3,a2
	jruc	#scl

#scllp	sra	1,a0			;Scale down
	sra	1,a1
	srl	1,a2
#scl	cmpi	22,a2
	jrgt	#scllp

	add	a0,a6
	add	a1,a7

	jruc	#calcintercept

#binair
	move	*a5(OXVAL),a6,L
	move	*a5(OXANI),a0,L
	add	a0,a6
	move	*a5(OZVAL),a7,L
	move	*a5(OYVAL),a9,L

	move	*a5(OXVEL),a0,L
	move	*a5(OZVEL),a1,L
	move	*a5(OYVEL),a2,L
	movk	30,b0
#newblp
	add	a0,a6
	add	a1,a7
	add	a2,a9
	addi	GRAVB,a2
	dsj	b0,#newblp

	sra	16,a6
	sra	16,a7

#calcintercept

	move	*b4+,b0,L
	move	b0,a2			;*Key img

	movk	30,a4

	clr	a3
	clr	a5
	move	@ballprcv_p,a0,L
	cmp	a13,a0
	jreq	#setvel			;I'm receiving?


	move	*a2(IANIOFFX),a1
	move	*a2(IANI2X),a14
	sub	a14,a1
	movi	850,a0
	mpys	a0,a1
	sra	10,a1			;/1024

	move	*a13(plyr_newdir),a14
	jrge	#ndok
	move	*a13(plyr_dir),a14
#ndok	addk	8,a14
	sll	32-7,a14
	srl	32-7+4,a14
	subk	4,a14
	jrle	#nof			;No flip?
	neg	a1
#nof
	add	a1,a6


	move	a6,a3
	move	a7,a5

	move	*a8(OXPOS),a1
	move	*a8(OXANI+16),a14
	add	a14,a1
	sub	a1,a3			;X delta

;	move	*a13(plyr_dir),a14
;	addk	8,a14			;Round up
;	srl	4,a14			;Lose frac
;	sll	4,a14			;*16
;	addi	#z_t,a14
;	move	*a14,a5

	move	*a8(OZPOS),a1
	sub	a1,a5			;Z delta

	movk	30,a1			;Max delta
	move	*a13(plyr_seq),a14
	subk	REBOUND_SEQ,a14
	jrne	#noreb
	addk	20,a1

#noreb	cmp	a1,a3
	jrlt	#x1ok
	move	a1,a3
#x1ok
	cmp	a1,a5
	jrlt	#z1ok
	move	a1,a5
#z1ok
	neg	a1
	cmp	a1,a3
	jrgt	#x2ok
	move	a1,a3
#x2ok
	cmp	a1,a5
	jrgt	#z2ok
	move	a1,a5
#z2ok

	sll	16,a3
	sll	16,a5
	divs	a4,a3
	divs	a4,a5
#setvel
	move	a3,*a8(OXVEL),L
	move	a5,*a8(OZVEL),L

	movi	-GRAV/2,a1
	mpys	a4,a1
	move	*a8(OYVAL),a3,L		;Adjust for hgt difference
	sub	a9,a3			;- if above
	divs	a4,a3
	sub	a3,a1
	cmpi	->3c000,a1
	jrlt	#minok
	movi	->3c000,a1		;Min
#minok

	move	*a13(plyr_num),a14
	move	@plyrnumonfire,a6
	cmp	a14,a6
	jrnz	#nofire

;This guy on fire, let him jump higher!
	cmpi	->50200,a1		;4a200
	jrgt	#maxok
	movi	->50200,a1
	jruc	#maxok
#nofire
	cmpi	->4b200,a1		;4a200
	jrgt	#maxok
	movi	->4b200,a1
#maxok
	move	a1,*a8(OYVEL),L


#x	PULL	a6,a7,a9
	rets


#z_t	.word	CZMID+12,CZMID+8,CZMID,CZMID-8
	.word	CZMID-12,CZMID-8,CZMID,CZMID+8
	.word	CZMID+12


#*******************************
* Sequence - Auto rebound jump
* B4=*Next data in seq list

 SUBR	seq_rebounda

	move	@ballpnum,a14
	jrge	seq_stand		;Someone grabbed ball?


	PUSH	a6,a7,a9


	movk	1,a0			;Start jump
	move	a0,*a13(plyr_jmpcnt)


	move	@ballobj_p,a5,L		;>Calc where ball is headed

	move	*a5(OXVAL),a6,L
	move	*a5(OXANI),a0,L
	add	a0,a6
	move	*a5(OZVAL),a7,L
	move	*a5(OYVAL),a9,L

	move	*a5(OXVEL),a0,L
	move	*a5(OZVEL),a1,L
	move	*a5(OYVEL),a2,L
	movk	20,b0
	movi	GRAVB,a14
#newblp
	add	a0,a6
	add	a1,a7
	add	a2,a9
	add	a14,a2
	dsj	b0,#newblp

	sra	16,a6
	sra	16,a7


	move	*b4+,b0,L
	move	b0,a2			;*Key img

	movk	20,a4


	move	*a2(IANIOFFX),a1
	move	*a2(IANI2X),a14
	sub	a14,a1
	movi	850,a0
	mpys	a0,a1
	sra	10,a1			;/1024

	move	*a13(plyr_newdir),a14
	jrge	#ndok
	move	*a13(plyr_dir),a14
#ndok	addk	8,a14
	sll	32-7,a14
	srl	32-7+4,a14
	subk	4,a14
	jrle	#nof			;No flip?
	neg	a1
#nof
	add	a1,a6


	move	a6,a3
	move	a7,a5

	move	*a8(OXPOS),a1
	move	*a8(OXANI+16),a14
	add	a14,a1
	sub	a1,a3			;X delta


	move	*a8(OZPOS),a1
	sub	a1,a5			;Z delta

	movi	50,a1			;Max delta (was 30)
	cmp	a1,a3
	jrlt	#x1ok
	move	a1,a3
#x1ok
	cmp	a1,a5
	jrlt	#z1ok
	move	a1,a5
#z1ok
	neg	a1
	cmp	a1,a3
	jrgt	#x2ok
	move	a1,a3
#x2ok
	cmp	a1,a5
	jrgt	#z2ok
	move	a1,a5
#z2ok

	sll	16,a3
	sll	16,a5
	divs	a4,a3
	divs	a4,a5
#setvel
	move	a3,*a8(OXVEL),L
	move	a5,*a8(OZVEL),L

	movi	-GRAV/2,a1
	mpys	a4,a1
	move	*a8(OYVAL),a3,L		;Adjust for hgt difference
	sub	a9,a3			;- if above
	divs	a4,a3
	sub	a3,a1
	cmpi	->1c000,a1
	jrlt	#minok
	movi	->1c000,a1		;Min
#minok
;	cmpi	->4a000,a1
;	jrgt	#maxok

;	LOCKUP
;	PULL	a6,a7,a9
;	jruc	seq_stand

#maxok	move	a1,*a8(OYVEL),L


	PULL	a6,a7,a9
	rets


#*******************************
* Sequence - start dunk jump
* B4=*Next data in seq list

 SUBR	seq_strtdunk

	move	*b4+,b0,L
	move	b0,a2			;*Slam img

	move	*b4+,b0
	move	b0,a4			;#ticks till we reach rim

;	sra	1,a4

	movk	1,a0			;Start jump
	move	a0,*a13(plyr_jmpcnt)


	move	*a13(plyr_ohoopx),a3

	move	*a2(IANIOFFX),a1
	move	*a2(IANI2X),a14
	sub	a14,a1
	movi	850,a0
	mpys	a0,a1
	sra	10,a1			;/1024

;	move	*a13(plyr_dir),a14
;	addk	8,a14
;	sll	32-7,a14
;	srl	32-7+4,a14
;	subk	4,a14
;	jrle	#nof			;No flip?
;	neg	a1
;#nof

	move	*a8(OCTRL),a14
	btst	B_FLIPH,a14
	jrz	#nof
	neg	a1
#nof
	add	a1,a3


	move	*a8(OXPOS),a1
	move	*a8(OXANI+16),a14
	add	a14,a1
	sub	a1,a3			;X delta

	move	*a13(plyr_dir),a14
	addk	8,a14			;Round up
	srl	4,a14			;Lose frac
	sll	4,a14			;*16
	addi	#z_t,a14
	move	*a14,a5
	move	*a8(OZPOS),a1
	sub	a1,a5			;Y delta

	sll	16,a3
	sll	16,a5
	divs	a4,a3
	divs	a4,a5

	move	*a13(plyr_seqflgs),a0
	btst	LAYUP_B,a0
	jrz	#nolay

	movk	LAY_UP,a0
	move	a0,@shot_type

	movk	3,a14
	move	a3,a7
	divs	a14,a7
	sub	a7,a3

	move	a5,a7
	divs	a14,a7
	sub	a7,a5

;	sra	1,a3
;	sra	1,a5
	jruc	#layin
#nolay
	movk	PS_DUNKS_TRY,a0		;>Inc dunk stats
	move	*a13(plyr_num),a1
	calla	inc_player_stat

#layin
	move	a3,*a8(OXVEL),L
	move	a5,*a8(OZVEL),L

	movi	-GRAV/2,a1
	mpys	a4,a1
	move	*a8(OYVAL),a3,L		;Adjust for hgt difference
	subi	(HOOPY+12)<<16,a3	;- if above
	divs	a4,a3
	sub	a3,a1
	move	a1,*a8(OYVEL),L

	clr	a0
	move	a0,@plyrcharge
	move	a0,@slamming

	movi	PS_2PTS_TRY,a0
	move	*a13(plyr_num),a1
	calla	inc_player_stat

	cmpi	62,a4			;60
	jrlt	#nofl

	PUSH	a10
	clr	a10
	cmpi	48h,a4
	jrlt	#nosnd
	movi	20,a0			;2% do bogus snd
	callr	RNDPER
	jrls	#nosnd	
	movk	1,a10
#nosnd	
	move	a7,a2
	CREATE0	plyr_camflash
	move	a2,a7
	PULL	a10

#nofl
	rets


#z_t	.word	CZMID+12,CZMID+8,CZMID,CZMID-8
	.word	CZMID-12,CZMID-8,CZMID,CZMID+8
	.word	CZMID+12


#*******************************
* Flash cameras in crowd

	.ref	gndpos_t

 SUBR	plyr_camflash

	movk	7,a0
	callr	rnd
	addk	17,a0
	move	a0,a8
#lp	CREATE0	plyr_cflsh
	move	a10,a10
	jrz	#nosnd
	CREATE0	plyr_cflsh_snd
#nosnd
	movk	4,a0			;7
	callr	rnd
	addk	2,a0
	calla	PRCSLP
	dsj	a8,#lp
	DIE

plyr_cflsh_snd
	movk	3,a0
	callr	rndrng0
	sll	5,a0
	addi	flsh_t,a0
	move	*a0,a0,L
#s1	calla	snd_play1
	DIE

flsh_t	.long	flsh1_snd,flsh1_snd,flsh2_snd,flsh2_snd

flsh1_snd	.word	>fabe,5,>80a8,0
flsh2_snd	.word	>fbbe,8,>80a9,0

plyr_cflsh
	movi	110,a0
	callr	rndrng0
	subi	50,a0
	move	a0,a2

	movi	399,a0
	callr	rndrng0
	move	@WORLDTLX+16,a14
	subi	>2000-200,a14
	add	a14,a0
	sll	16,a0			;X

	move	a2,a1
	sll	16,a1			;Y

	movi	flash1,a2
	movi	290,a3
	movi	DMAWNZ|M_3DQ|M_NOCOLL|M_NOSCALE,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	movi	gndpos_t,a1
	move	a1,*a8(ODATA_p),L

	movi	#f_l,a9
	movk	1,a0
	callr	rnd
	jrnz	#1
	movi	#f2_l,a9
#1
	SLEEPK	2
	jauc	FRQDELDIE


#f_l	LW	flash2,2
	LW	flash3,2
	LW	flash3a,2
	LW	flash3,2
	LW	flash2,2
	LWL0	flash1,2

#f2_l	LW	flash4,2
	LW	flash5,1
	LW	flash6,1
	LW	flash5,1
	LWL0	flash4,2


#*******************************
* Sequence - slam ball through hoop (dunk)
* B4=*Next data in seq list

 SUBR	seq_slamball


	move	@ballpnum,a0
	move	*a13(plyr_num),a1
	cmp	a0,a1
	jrne	#x			;I don't have it?

	movk	1,a0
	move	a0,@slamming

	move	@ballobj_p,a5,L

	move	*a5(OIMG),a1,L		;>Convert ball from player relative
	move	*a1(IANIOFFX),a1
	sll	16,a1
	move	a1,*a5(OXANI),L


;Shawn, the ball isn't lined up for players scoring on left side of court

	move	*a13(plyr_ohoopx),a7	;>Set ball over rim
	subk	6,a7

;	move	*a13(plyr_seq),a0
;	cmpi	DUNKT6_SEQ,a0
;	jrz	#yes
    
	movi	35,a0
	calla	RNDPER
	jrls	#noadjst

#yes
	move	*a13(plyr_num),a0
	cmpi	2,a0
	jrlt	#nofix
	addk	9,a7
#nofix
	subk	6,a7

#noadjst

	move	a7,*a5(OXPOS)

	movi	HOOPY-8,a14
	move	a14,*a5(OYPOS)
	movi	CZMID,a14
	move	a14,*a5(OZPOS)

;	movk	>1f,a0			;3%
;	callr	rnd
;	jrnz	#dunknorm

	movi	25,a0
	calla	RNDPER
	jrls	#dunknorm
					;>Missed dunk
	move	*a13(plyr_ptsdown),a0
	subk	2,a0
	jrge	#dunknorm		;I'm loosing by 5?

;MJT
;	move	*a13(plyr_num),a0

	move	@plyrnumonfire,a14

;	cmp	a0,a14
;	jrz	#dunknorm

	jrnn	#dunknorm

	movi	missd1_snd,a0
	calla	snd_play1
	movi	boo1_snd,a0
	calla	snd_play1
	movi	cheer1_snd,a0
	calla	snd_play1

	movi	>3ffff,a0
	callr	rnd
	subi	>20000,a0
	move	a0,a2
	movi	>1ffff,a0
	callr	rnd
	addi	>4000,a0
	move	*a13(plyr_num),a1
	subk	2,a1
	jrge	#t2
	neg	a0
#t2	movi	-GRAVB*40,a3		;Up
	jruc	#setxyz

#dunknorm

;Deliver a facial?
	move	*a13(plyr_o1dist),a0
	cmpi	35,a0
	jrlt	#dlvr
	move	*a13(plyr_o2dist),a0
	cmpi	35,a0
	jrgt	#nodlvr
#dlvr
	move	*a13(plyr_num),a0
	cmpi	2,a0
	jrlt	#cktm2
;check tm1

;MJT - Start opponent on fire here!

	move	@plyrproc_t,a0,L
	move	*a0(plyr_stagcnt),a1
	move	@plyrproc_t+32,a2,L
	move	*a2(plyr_stagcnt),a2
	add	a2,a1
	cmpi	13,a1
	jrlt	#nodlvr
	jruc	#dlv
#cktm2
	move	@plyrproc_t+64,a0,L
	move	*a0(plyr_stagcnt),a1
	move	@plyrproc_t+96,a2,L
	move	*a2(plyr_stagcnt),a2
	add	a2,a1
	cmpi	13,a1
	jrlt	#nodlvr
#dlv
	movi	350,a0
	calla	RNDPER
	jrhi	#nodlvr
	movi	facial_snd,a0
	calla	snd_play1ovrp
#nodlvr

	CREATE0	#dunk_cheer
	clr	a0
	clr	a2
	movi	GRAVB*4,a3
#setxyz	move	a0,*a5(OXVEL),L
	move	a2,*a5(OZVEL),L
	move	a3,*a5(OYVEL),L


	move	*a8(OXVEL),a1,L
	move	*a8(OZVEL),a2,L

	move	*b4+,b0			;Get # ticks we hang
	move	b0,a0
	move	a0,*a13(plyr_hangcnt)
	subk	2,a0
	jrlt	#nohang
	move	*a13(plyr_seq),a1
	cmpi	DUNKX3_SEQ,a1
	jrnz	#dck1
;Align dunkkx3
	move	*a8(OYPOS),a1
	addk	5,a1
	move	a1,*a8(OYPOS)
	move	*a8(OXPOS),a1
	move	*a8(OXVEL),a2,L
	jrnn	#fix1
	subi	>2e,a1			;2c
#fix1	addi	>16,a1
	move	a1,*a8(OXPOS)
	jruc	#fix2
#dck1
	cmpi	DUNKX_SEQ,a1
	jrnz	#dck2
;Align dunkkx
	move	*a8(OYPOS),a1
	addk	9,a1
	move	a1,*a8(OYPOS)
	move	*a8(OXPOS),a1
	move	*a8(OXVEL),a2,L
	jrnn	#fix1a
	subi	>2e,a1			;2c
#fix1a	addi	>18,a1
	move	a1,*a8(OXPOS)
	jruc	#fix2
#dck2
	cmpi	DUNKX2_SEQ,a1
	jrnz	#dck3
;Align dunkkx
	move	*a8(OYPOS),a1
	subk	2,a1
	move	a1,*a8(OYPOS)
	move	*a8(OXPOS),a1
	move	*a8(OXVEL),a2,L
	jrnn	#fix1b
	subi	>2e,a1			;2c
#fix1b	addi	>16,a1
	move	a1,*a8(OXPOS)
	jruc	#fix2
#dck3

#fix2
	clr	a1			;0 velocity
	clr	a2
	move	a1,*a8(OYVEL),L
#nohang	sra	1,a1
	sra	1,a2
	move	a1,*a8(OXVEL),L
	move	a2,*a8(OZVEL),L

	move	*a13(plyr_num),a1
	move	a1,@ballpnumshot
	move	a1,@ballpnumlast
	movi	-1,a0
	move	a0,@ballpnum		;No owner
	clr	a0
	move	a0,@ballscorezhit
	move	a0,@ballrimhitcnt
	move	a0,@ballbbhitcnt
	move	a0,*a13(plyr_ownball)
	movi	TSEC+20,a0
	move	a0,*a13(plyr_shtdly)

	rets

#x	addk	16,b4
	rets

#dunk_cheer
	SLEEPK	15
	movi	cheer1_snd,a0
	calla	snd_play1
	movi	cheer2_snd,a0
	calla	snd_play1
 
	SLEEP	5*60

	clr	a0
	move	a0,@slamming

	DIE



#*******************************
* Sequence - push opponent in front of me

 SUBR	seq_push

;We have to make the accuracy dependent upon ptsdown!  Except when pushing
;my own teammate, then keep it easy.

	PUSH	a11

	move	*a13(plyr_dir),a3

	move	*a13(plyr_o1dist),a14
	subi	50,a14
	jrgt	#o1far			;Too far?
	clr	a5			;O1
	move	*a13(plyr_o1dir),a2
	sub	a3,a2
	abs	a2
	cmpi	>40,a2
	jrle	#o1dsml
	subi	>80,a2
	abs	a2
#o1dsml	subk	32,a2			;16
	jrlt	#pusho			;In front of me?

#o1far

	move	*a13(plyr_o2dist),a14
	subi	50,a14
	jrgt	#o2far			;Too far?
	movk	32,a5			;O2
	move	*a13(plyr_o2dir),a2
	sub	a3,a2
	abs	a2
	cmpi	>40,a2
	jrle	#o2dsml
	subi	>80,a2
	abs	a2
#o2dsml	subk	32,a2			;16
	jrlt	#pusho
#o2far

;Checking for teammate also

	move	*a13(plyr_num),a14
	move	@PSTATUS,a0
	btst	a14,a0
	jrz	#x			;I am a stupid drone?  Drones never
					;push human teammate!

	move	*a13(plyr_tmdist),a14
	subi	50,a14
	jrgt	#x			;Too far?
	movi	-1,a5
	move	*a13(plyr_tmdir),a2
	sub	a3,a2
	abs	a2
	cmpi	>40,a2
	jrle	#tmdsml
	subi	>80,a2
	abs	a2
#tmdsml	subk	16,a2
	jrlt	#push
	jruc	#x

;Make it harder to push team who is down by 5 or more pnts
;The CMOS game difficulty setting should also check this.

#pusho

;Fix up, make it harder, not impossible!

;	move	*a13(plyr_num),a0
;	srl	1,a0
;	sll	4,a0
;	move	a0,a1
;	XORK	16,a1
;	addi	scores,a0
;	move	*a0,a0
;	addi	scores,a1
;	move	*a1,a1
;	subk	5,a0
;	cmp	a0,a1
;	jrge	#push
;
;;Maybe ignore this successful push of an opponent (Teammate can always get it!)
;;50% of time
;	movk	1,a0
;	callr	rnd
;	jrz	#x

#push
	move	@inbound,a0
	jrnn	#x

	move	*a13(plyr_num),a0	;>Nail him

	move	a5,a5
	jrnn	#push_op		;Pushing opponent

	XORK	1,a0			;Get teammate
	sll	5,a0
	addi	plyrproc_t,a0
	jruc	#get_prc

#push_op

;	PUSH	a0
;	movi	100,a0
;	calla	RNDPER
;	jrls	#no_facial
;	movi	facial_snd,a0
;	calla	snd_play1
;#no_facial
;	PULL	a0

	srl	1,a0
	XORK	1,a0
	sll	6,a0			;*64
	addi	plyrproc_t,a0
	add	a5,a0

#get_prc
 	move	*a0,a5,L		;A5=*O proc

	move	*a5(plyr_seqflgs),a14
	movi	300,a0
	btst	LAYUP_B,a14
	jrnz	#xz2

	move	*a5(plyr_seq),a14
	cmpi	ELBO_SEQ,a14
	jrz	#xz
	cmpi	ELBO2_SEQ,a14
	jrz	#xz
	cmpi	REBOUND_SEQ,a14
	jrz	#xz
	cmpi	REBOUNDA_SEQ,a14
	jrnz	#skpck

#xz
	movi	150,a0			;200
#xz2					;Layups 30%
	calla	RNDPER
	jrls	#x			;br=nope
#skpck

	move	*a5(PA8),a2,L
	move	*a2(OYPOS),a0
	move	*a8(OYPOS),a1
	sub	a0,a1

	cmpi	>54,a1			;>60,5c,58
	jrgt	#x			;Too far above me?

;player pushed speech here


	move	*a13(plyr_num),a14
	move	@plyr_maxpower,a0
	btst	a14,a0
	jrz	#nochng
;This guy has max power!  Don't knock him down!
	movk	9,a3
	jruc	#maxp
#nochng
	move	*a13(plyr_attrib_p),a0,L
	move	*a0(PAT_POWER),a3
#maxp
	move	a3,@last_power		;For later analysis

	move	*a13(plyr_dir),a0
	move	a0,a1
	addi	>40,a1
	sll	32-7,a1
	srl	32-7,a1
	move	a1,*a5(plyr_newdir)
	callr	sinecos_get

	sll	4,a0			;*128
	sll	4,a1

	move	*a5(plyr_attrib_p),a14,L
	move	*a14(PAT_POWER),a14
	sub	a3,a14
	move	a14,a3
	cmpi	6,a14

;If the pusher is smaller than pushee, fly
;back just a short distance.

	jrge	#shortfal

	sll	2,a0			;*128
	sll	2,a1
	jruc	#sh1
#shortfal
	PUSH	a0,a1
	movi	push1_snd,a0
	calla	snd_play1
	PULL	a0,a1
#sh1
	move	a0,a11
	move	a0,*a2(OZVEL),L
	move	a1,*a2(OXVEL),L
	move	*a5(plyr_jmpcnt),a0
	jrnz	#injmp
	movk	1,a0
	move	a0,*a5(plyr_jmpcnt)
;MJT
	movi	-GRAVB*18,a0		;Up	;19
	move	@HCOUNT,a14
	andi	07,a14
	jrnz	#notlow
	movi	-GRAVB*14,a0		;Up
#notlow
	move	a0,*a2(OYVEL),L
#injmp
	movk	32,a0
	cmpi	7,a3
	jrlt	#notsml

	movi	650,a0
	calla	RNDPER
	jrhi	#notsml

;35% of time, do small push away
;	move	@HCOUNT,a3
;	btst	0,a3
;	jrz	#notsml

	movi	-GRAVB*8,a0		;7
	move	a0,*a2(OYVEL),L
	movk	16,a0			;16
#notsml

	move	*a5(plyr_num),a14
	move	@plyr_maxpower,a1
	btst	a14,a1
	jrz	#nochng1
;This guy has max power!  Don't knock him down!
	movi	-GRAVB*8,a0		;7
	move	a0,*a2(OYVEL),L
	move	*a2(OZVEL),a0,L
	sra	2,a0
	move	a0,*a2(OZVEL),L
	move	*a2(OXVEL),a0,L
	sra	2,a0
	move	a0,*a2(OXVEL),L

	movi	push1_snd,a0
	calla	snd_play1

	movk	16,a0
	move	@HCOUNT,a1
	btst	0,a1
	jrz	#nochng1
	movk	24,a0			;16
#nochng1
	move	a0,*a5(plyr_stagcnt)

	move	@ballpnum,a0
	move	*a5(plyr_num),a1
	cmp	a0,a1
	jrne	#nobl			;Doesn't have ball?

;Sometimes have pushed player keep ball!

	movk	PS_STEALS,a0
	move	*a13(plyr_num),a1
	calla	inc_player_stat

	move	@ballobj_p,a4,L
	movi	>1ffff,a2		;>Give rnd velocity
	movi	>10000,a3
	move	a2,a0
	callr	rnd
	sub	a3,a0
	move	a0,*a4(OXVEL),L
	move	a2,a0
	callr	rnd
	sub	a3,a0

;If pushed over scorers table, have ball drift down screen

	move	*a5(plyr_num),a14
	sll	5,a14
	addi	plyrobj_t,a14
	move	*a14,a14,L
	move	*a14(OZPOS),a1
	cmpi	>410,a1
	jrgt	#not_rear

	movi	40,a0
	move	a0,*a5(plyr_shtdly)	;can't scoop up ball

	movi	-1,a0
	move	a0,@ballpnum
	move	a0,@ballpnumlast

	movi	[2,0],a0
#not_rear
	move	a0,*a4(OZVEL),L
#nobl
	move	*a5(plyr_num),a14
	sll	5,a14
	addi	plyrobj_t,a14
	move	*a14,a14,L
	move	*a14(OZPOS),a1
	cmpi	>410,a1
	jrgt	#not_rear2

	move	a11,a11
	jrnn	#not_rear2

	movi	intostands,a0
	calla	snd_play1

#not_rear2

	move	*a13(plyr_num),a0	;If on fire, don't use turbo on push
	move	@plyrnumonfire,a1
	cmp	a0,a1
	jrz	#x

	move	*a13(plyr_PDATA_p),a2,L
	move	*a2(ply_turbo),a1
	cmpi	10,a1
	jrlt	#clrbl
	subk	7,a1
	move	a1,*a2(ply_turbo)
	move	*a2(ply_meter_imgs+40h),a0,L
	move	*a0(OFSET),a1		;Shrink meter
	addk	7,a1
	move	a1,*a0(OFSET)
	jruc	#x

#clrbl
	move	*a13(plyr_PDATA_p),a2,L
	move	*a2(ply_turbo),a14
	clr	a0
	move	a0,*a2(ply_turbo)
	move	*a2(ply_meter_imgs+40h),a0,L
	move	*a0(OFSET),a1		;Shrink meter
	add	a14,a1
	move	a1,*a0(OFSET)


#x	PULL	a11
	rets


#*******************************
* Sequence - elbo opponents around me

 SUBR	seq_elbo

	move	*a13(plyr_num),a4
	srl	1,a4
	XORK	1,a4
	sll	6,a4			;*64
	addi	plyrproc_t,a4

	move	*a13(plyr_o1dist),a14
	subi	40,a14
	jrge	#o1far			;Too far?

	move	@HCOUNT,a14
	btst	0,a14
	jrz	#o1far			;Skip? (50%)

	move	*a4,a5,L		;A5=*O proc
	move	*a13(plyr_o1dir),a0
	callr	#elbo
#o1far

	move	*a13(plyr_o2dist),a14
	subi	40,a14
	jrge	#x			;Too far?

	move	@HCOUNT,a14
	btst	0,a14
	jrz	#x			;Skip? (50%)

	addk	32,a4
	move	*a4,a5,L		;A5=*O proc
	move	*a13(plyr_o2dir),a0
	callr	#elbo

#x	rets


#elbo
	move	*a5(PA8),a2,L		;>Make opponent fly

	move	a0,a1
	addi	>40,a1
	sll	32-7,a1
	srl	32-7,a1
	move	a1,*a5(plyr_newdir)
	callr	sinecos_get

;Possibly elbos toss should be shorter?
	sll	5,a0			;*32
	sll	5,a1
	move	a0,*a2(OZVEL),L
	move	a1,*a2(OXVEL),L
	move	*a5(plyr_jmpcnt),a0
	jrnz	#injmp
	movk	1,a0
	move	a0,*a5(plyr_jmpcnt)
	movi	-GRAVB*12,a0		;Up 15
	move	a0,*a2(OYVEL),L

	move	*a5(plyr_num),a14
	move	@plyr_maxpower,a1
	btst	a14,a1
	jrz	#injmp
;This guy has max power!  Don't knock him down!
	movi	-GRAVB*8,a0		;7
	move	a0,*a2(OYVEL),L
	movk	24,a0			;16
	move	@HCOUNT,a1
	btst	0,a1
	jrz	#ko
	movk	16,a0			;16
#ko
	move	a0,*a5(plyr_stagcnt)
	rets

#injmp
	movk	32,a0
	move	a0,*a5(plyr_stagcnt)

	rets

#*****************************************************************************
; a8  = * ball object
; a11 = hoop x


GAME_QTR	equ	PDATA

	.asg	22,DIAM

 SUBRP	no_good_check

	move	@gmqrtr,a0
	move	a0,*a13(GAME_QTR)

#loop
 	SLEEPK	1

	move	@game_time,a0,L		;If at beginning of
	cmpi	>2050400,a0		;qrtr, no speech!
	jrgt	#snuffit

	move	@gmqrtr,a0
	move	*a13(GAME_QTR),a1
	cmp	a0,a1
	jrne	#snuffit

	move	*a8(OYPOS),a0
	cmpi	HOOPY+15,a0
	jrgt	#no_good

	move	*a8(OXPOS),a0
	move	*a8(OXANI+10h),a1
	add	a1,a0
	sub	a11,a0
	abs	a0
	subk	DIAM,a0
	jrgt	#no_good


	move	*a8(OZPOS),a0
	subi	CZMID,a0		;>Check backboard
	abs	a0
	subk	DIAM,a0
	jrgt	#no_good

	jruc	#loop


#no_good
	calla	nogood_speech

#snuffit
	DIE

******************************************************************************
	.end
