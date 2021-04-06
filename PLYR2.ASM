**************************************************************
*
* Owner:	TURMELL
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
	.include	"world.equ"		;Court-world defs
	.include	"game.equ"
	.include	"macros.hdr"		;Macros

	.include	"ballshad.glo"
	.include	"imgtbl7.glo"
	.include	"imgtbl.glo"
	.include	"credturb.glo"
	.include	"arrow.glo"

	.asg		0,SEQT
	.include	"plyr.equ"


;sounds external

	.ref	FLAME_F_13,FLAME2F_13

	.ref	ohmy,intercept,into_stnd_sp
	.ref	stealsb
	.ref	swish_snd1,swish_snd2,swish_snd3
	.ref	swish_snd4,swish_snd5,swish_snd6
	.ref	miss1_snd,miss2_snd,miss3_snd,miss4_snd
	.ref	dunk_snd1,dunk_snd2,dunk_snd3,dunk_snd4
	.ref	missd1_snd,hitbkbd_snd,swat_snd,boo1_snd
	.ref	hitbkbd2_snd,miss5_snd,dunk_snd5
	.ref	cheer_snd,cheer1_snd,cheer2_snd,cheer3_snd,cheer4_snd
	.ref	steal_snd

	.ref	on_fire_sp,dribble_snd,push1_snd
	.ref	dribble3_snd
	.ref	pup_court,pup_aba


;symbols externally defined

	.ref	pup_maxpower
	.ref	shot_percentage
	.ref	gmqrtr
	.ref	shot_distance

	.ref	AUD1,AUD
	.ref	nogood_speech,GAMSTATE

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
	.ref	PSTATUS

	.ref	game_time
	.ref	scores,prt_top_scores
	.ref	tvpanelon
	.ref	score_add,score_showtvpanel
	.ref	stick_number
	.ref	sclockx,sc_proc
;	.ref	movie_test
	.ref	net_ani,rimlf,rimrf
	.ref	arw_on1plyr

	.ref	pal_getf

	.ref	PCNT
	.ref	HALT
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
	.ref	flsh1_snd,flsh3_snd,flsh4_snd


;symbols defined in this file

	.def	hoopl_t,hoopr_t


;uninitialized ram definitions

	.bss	off_boxy,16

	BSSX	plyr_onfire	,16	;Bit 0-3=plyr 0-3 on-fire; 0 for none
	BSSX	ballobj_p	,32	;* basketball obj
	BSSX	ballpnum	,16	;Plyr # who owns (0-3) or Neg
	BSSX	ballpnumlast	,16	;Last plyr who owned ^ (0-3) or neg if loose
	BSSX	ballpnumshot	,16	;Last plyr who shot (0-3)
	BSSX	ballsclastp	,16	;Last plyr who owned (0-3) for shot clock
	BSSX	ballshotinair	,16	;Shooter # if shot in air, else -1

;Stucture - Keep in order!
	BSSX	ballpnumscored	,16	;Last plyr who scored (0-3) or neg
	BSSX	ballnumscored	,16	;# times last plyr scored
	BSSX	balltmscored	,16	;Last team-shot scored (0=tm2,32=tm1)
	BSSX	balltmshotcnt	,16	;# times last team-shot scored
;End of structure

	BSSX	ballfree	,16	;!0=Ball free to move
	BSSX	ballscorezhit	,16	;!0=Ball hit score zone, +=Top z, -=Scored

	BSSX	ballrimhitcnt	,16	;# times rim hit since last shot
	BSSX	ballbbhitcnt	,16	;# times backboard hit since last shot
	BSSX	in_cylinder	,16	;Cntdwn after first rim hit on shots
	BSSX	must_rebound	,16	;Convert block/rej art into rebound

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
	BSSX	scrl_divs_dest	,16	;Scroller acceleration target divisor

;	.bss	movieshown	,16	;!0=Movie has been played

	BSSX	slamming	,16	;!0=Ball going into rim from dunking

	BSSX	t1dunkcnt	,16	;+=# dunks since start of game (In order)
	.bss	t2dunkcnt	,16	;^ -=# dunks till we can break board

	BSSX	brick_count	,16*NUMPLYRS	;# bricks each player has thrown up
	BSSX	last_power	,16	;Player pushing has this power

	BSSX	original_names	,32*NUMPLYRS	;Names of original players in game
;	BSSX	fire_flags	,16	;1 if this player has been on fire (1,2,4,8)

	BSSX	my_ballpnumlast ,16	;last player to own ball
;equates for this file


	.text


#*******************************
* Play bell, flash ball on ABA ball powerup

church
;Wait for HALT to get set!
	SLEEPK	8

#lpz	SLEEPK	1			;waiting for idiot boxes
	move	@HALT,a0
	jrnz	#lpz
;MJT Start
	.ref	robo_3_snd
	SLEEPK	20
	callr	flash_ball
	SOUND1	robo_3_snd
	SLEEPK	27
	callr	flash_ball
	SOUND1	robo_3_snd
	SLEEPK	27
	callr	flash_ball
	SOUND1	robo_3_snd
;MJT End
	DIE

#*******************************
* Ball main code (Process)

 SUBR	ball_main

	move	a13,a1			;>Clr PDATA & PSDATA areas
	addi	PDATA,a1
	movi	(PRCSIZ-PDATA)/16,a2
	clr	a0
#clrpd	move	a0,*a1+
	dsj	a2,#clrpd

	move	@WORLDTLX+16,a0		;Init ball obj
	addi	200,a0
	sll	16,a0
	movi	[-80,0],a1		;In air
	.ref	NBALL101
	movi	NBALL101,a2
	move	@pup_aba,a14
	jrz	#notd
	.ref	ABALL101
	movi	ABALL101,a2
	PUSH	a0,a1,a2


	CREATE0	church


	PULL	a0,a1,a2
#notd
	movi	CZMID,a3
	movi	DMAWNZ|M_3D|M_NOSCALE,a4
	movi	CLSENMY|TYPBALL,a5
	clr	a6
	movi	->20000,a7
	calla	BEGINOBJ2
	move	a8,@ballobj_p,L
	callr	ball_getshadow		;Init ball shadow

	clr	a0			;Init various ball stats/counts
	move	a0,@ballpnumshot
	move	a0,@ballscorezhit
	move	a0,@ballbbhitcnt
	move	a0,@ballgoaltcnt
	move	a0,@ballflash
	move	a0,@t1dunkcnt
	move	a0,@t2dunkcnt
	move	a0,@off_boxy
	move	a0,@puffcnt

	subk	1,a0
	move	a0,@ballpnum
	move	a0,@ballpnumlast
	move	a0,@ballpnumscored
	move	a0,@balltmscored

	move	a0,@brick_count,L
	move	a0,@brick_count+20h,L

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

	.if	DEBUG
	clr	a0
	move	a0,@#tmp_debounce
	move	a0,@#halt_ball
	.endif

;----------
; main proc loop

#lp
	.if	DEBUG

	.bss	#tmp_debounce,16
	.bss	#halt_ball,16
	.ref	get_but_val_down

;This is for halting the ball in midair - Allows checking blocks, rebound
;targeting, etc.
	.if	HEADCK
	.else
	jruc	#no			;Take this out when testing blocks
	.endif

	clr	a0
	calla	get_but_val_down
	jrz	#no

	move	@#tmp_debounce,a14
	jrnz	#held

	movk	1,a0
	move	a0,@#tmp_debounce

	.if	HEADCK
	.ref	game_start
	clr	a8			;A8=Player #
	movi	P1DATA,a11		;A11=*plyr data
	jauc	game_start
	.endif

	move	@#halt_ball,a0
	xori	1,a0
	move	a0,@#halt_ball
	jrz	#held
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OZVEL),L
	jruc	#held

#no	clr	a0
	move	a0,@#tmp_debounce
#held

	move	@#halt_ball,a0
	jrnz	#halted2
	.endif
	move	@HALT,a0

	.if	DEBUG
	BSSX	RIM_STEP,16
	jrz	#nohalt
	move	@RIM_STEP,a14
	jrz	#nohalt
	.ref	get_all_buttons_cur2
	.ref	get_all_buttons_down2
	calla	get_all_buttons_down2
	jrz	#halted
	clr	a0
#nohalt

	move	a0,a0
	.endif

	jrnz	#halted

	move	@ballgoaltcnt,a0	;Dec goal tend cnt if >0
	jrle	#skipgt
	subk	1,a0
	move	a0,@ballgoaltcnt
#skipgt

;----------
; check if its time for ball on-fire effects

	move	@plyr_onfire,a3		;Get last plyr on-fire bits or 0

	move	@balltmscored,a1	;Chk if a team is on-fire
	jrn	#notmfire		; br=no
	move	@balltmshotcnt,a4	;Maybe. Chk shot cnt
	subk	TMFIRE_MINCNT,a4
	jrn	#notmfire		; br=no

	movk	2+1,a2			;Set team 1 on-fire
	move	a1,a1			;Was it team 1?
	jrnz	#chkownr		; br=yes
	movk	8+4,a2			;Set team 2 on-fire
	jruc	#chkownr

#notmfire
	clr	a2			;Set for no on-fire
	move	@ballpnumscored,a0	;Last plyr who scored (0-3) or neg
	jrn	#chkhot			; br=no plyr on-fire
	move	@ballnumscored,a4	;# times last plyr scored

;	move	@fire_flags,a1
;	btst	a0,a1			;Been on-fire before?
;	jrz	#frstfire
;	subk	ONFIRE_MINCNT+1,a4	;# shots for on-fire if was before
;	jruc	#notff
;#frstfire
	subk	ONFIRE_MINCNT,a4	;# shots for on-fire
;#notff
	jrlt	#chkhot			;Enough for on-fire? br=no

	movk	1,a2			;Set new plyr on-fire
	sll	a0,a2

#chkownr
	.if DUNKTST
	jruc	#chkhot		;When testing dunks - PUT IN!
	.endif

	move	@ballpnum,a1
	jrn	#noownr

	btst	a1,a3			;Ball owner last plyr # on-fire?
	jrz	#chkhot			; br=no
	jruc	#hot			;Do smoke puffs

;	sll	5,a1
;	addi	plyrproc_t,a1
;	move	*a1,a1,L
;	move	*a1(plyr_seqflgs),a1	;Chk owner ani seq
;	btst	DUNK_B,a1		;Dunking?
;	jrnz	#hot			; br=yes, do smoke puffs
;	jruc	#chkhot			;No, holding or dribbling on-fire


#noownr
	move	@ballpnumlast,a1	;Get last owner team #
	srl	1,a1
	move	a3,a14			;Get last plyr # on-fire team #
	sll	3,a14
	.ref	pbit_tval
	addi	pbit_tval,a14,L
	movb	*a14,a14
	cmp	a1,a14			;On the same team?
	jrnz	#chkhot			; br=no, no smoke puffs
	
	move	@ballpnumshot,a1	;Last shooter=last plyr # on-fire?
	btst	a1,a3
	jrnz	#hot			; br=yes, do smoke puffs

	move	@ballprcv_p,a4,L	;Pass in progress?
	jrz	#chkhot			; br=no, no smoke puffs
	move	*a4(plyr_tmproc_p),a4,L	;Get passer *proc
	move	*a4(plyr_num),a4	;Get passer plyr #
	btst	a4,a3			;Passer plyr #=last plyr # on-fire?
	jrz	#chkhot			; br=no, no smoke puffs
#hot
	.bss	puffcnt,16
	move	@puffcnt,a0		;Do smoke puffs
	subk	1,a0
	jrnn	#nopuff

;Reduce bog by not doing puffs when score plate is present...
	move	@tvpanelon,a14,L
	jrnz	#nopuff0
	CREATE0	ball_smokepuff
#nopuff0


	movk	3-1,a0
#nopuff
	move	a0,@puffcnt

;----------
; do current ball on-fire status

#chkhot
	move	a3,a0			;Skip if someone is on-fire
	jrnz	#skip			; br=yes
	move	a2,a2			;Did someone go on-fire?
	jrz	#skip			; br=no

	movi	AUD_TM_FIRE,a0		;>Audit team on-fires
	move	@ballnumscored,a14	;Was it a team on-fire?
	subk	ONFIRE_MINCNT,a14
	jrn	#aud			; br=yes
	movi	AUD_NUMHOTSTRK,a0	;>Audit plyr on-fires
	movk	ONFIRE_MINCNT+1,a14	;Set for # of on-fire shots to allow
	move	a14,@ballnumscored
#aud
	move	@GAMSTATE,a14
	cmpi	INAMODE,a14		;Don't audit if in attract
	jrz	#noaud
	calla	AUD1
#noaud
;	move	@fire_flags,a14		;Set plyr been on-fire bit
;	or	a2,a14
;	move	a14,@fire_flags

	SOUND1	on_fire_sp

	movk	32,a0			;Set bogus plyr # for ball not on-fire
	move	a2,@plyr_onfire		;Save new on-fire plyr bit val or 0

#skip
	clr	a14			;0 for ball not on-fire
;	movi	-1,a4			;Cause ani change

	move	@ballpnum,a1
	jrnn	#ck1
	move	@ballpnumlast,a1
	jrn	#setb
#ck1
	movk	1,a6
	sll	a1,a6
	and	a0,a6
	jrz	#setb
	movk	1,a14			;!0 for ball on-fire
#setb
	move	a14,*a13(ball_onfire)
;	move	a4,*a13(ball_zsznum)	;Cause ani change

;----------
; check ball X coor limits

	move	*a8(OXPOS),a6		;Add ani X to check ball center
	move	*a13(ball_anix),a14
	add	a14,a6

	move	*a8(OXVEL),a1,L		;Chk vel for which limit to chk
	jreq	#xok			; = if held or dribbled
	jrgt	#xvpos

	cmpi	LFTCRT_X,a6		;Neg vel. Chk left X limit
	jrge	#xok
	movi	LFTCRT_X,a6		;Too far. Pull it back & go 0 X vel
	jruc	#xbad

#xvpos	cmpi	RGTCRT_X,a6		;Pos vel. Chk right X limit
	jrlt	#xok
	movi	RGTCRT_X,a6		;Too far. Pull it back & go 0 X vel

#xbad	move	a6,a5			;(OXPOS+anix) wants to remain in A6
	sub	a14,a5			;Adjust for ani X
	move	a5,*a8(OXPOS)
	clr	a1
	move	a1,*a8(OXVEL),L		;Clr X vel
#xok

;----------
; check ball Z coor limits

	move	@ballpnum,a5		;Ball owned? Yes if >=0
	jrge	#zok
	move	*a8(OZPOS),a0		;No
	move	*a8(OZVEL),a1,L		;Chk vel for which limit to chk
	jreq	#zok			;No chk if not moving
	jrgt	#zvpos

	cmpi	CZMIN,a0		;Neg vel. Chk upper Z limit
	jrge	#zok
	movi	CZMIN,a0		;Too far. Pull it back & go 0 Z vel
	jruc	#zbad

#zvpos	cmpi	CZMAX-2,a0		;Pos vel. Chk lower Z limit
	jrlt	#zok
	movi	CZMAX-2,a0		;Too far. Pull it back & go 0 Z vel

#zbad	move	a0,*a8(OZPOS)
	clr	a1
	move	a1,*a8(OZVEL),L		;Clr Z vel
#zok					;(ballpnum) wants to remain in A5

;----------
; check for anim kill & a basket

	move	a5,a5			;Ball owned? No if <0
	jrn	#no_own

	clr	a14			;Yes. Clr pass timer
	move	a14,@ballpasstime
	move	*a13(ball_onfire),a14	;On fire?
	jrnz	#scroll
	movk	2,a10			;No. Keep ball from animating
	jruc	#scroll

#no_own	move	@ballprcv_p,a5,L	;No owner. Passing?
	jrnz	#skpcol
	callr	ball_bbcollision	;No. Chk for a basket
#skpcol
	move	@ballpasstime,a0	;Shot or pass, inc pass timer
	addk	1,a0
	move	a0,@ballpasstime

;----------
; do world-scroll X

#scroll
	move	@inbound,a0		;Doing an inbound?
	jrn	#not_inbounding
#dunking
	jrnz	#ib_rgt
	movi	[WRLDMID-200-MAX_VIEW1,0],a3	;TARGX = lft side limit
	jruc	#do_ib
#ib_rgt
	movi	[WRLDMID-200+MAX_VIEW1,0],a3	;TARGX = rgt side limit
#do_ib
	movi	DIVS_RATE1,a0			;Set new current rate
	move	a0,@scrl_divs_cur
	jruc	#do_scroll

#not_inbounding
	movi	DIVS_RATE2,a0		;Set default target rate
	move	a0,@scrl_divs_dest

	move	@ballpnum,a5		;Ball owned?
	jrnn	#plyr_has_ball
	move	a6,a3			;No. TARGX = ball X
	move	@ballprcv_p,a0,L	;Passing? No if 0
	jrz	#not_passing
	move	@ballpnumlast,a5	;Yes or was. Still is or loose?
	jrn	#not_passing

	movi	DIVS_RATE3,a0		;Pass. Set new target rate
	move	a0,@scrl_divs_dest
	move	@plyrpasstype,a1	;Normal or turbo pass? Normal if 0
	jrz	#plyr_passed
	move	a0,@scrl_divs_cur	;Turbo. Set new current rate
	jruc	#plyr_passed

#not_passing
	move	@ballpnumlast,a5	;Not owned. Is it a shot or loose?
	jrnn	#plyr_shooting
	movi	-1,a0			;Loose. Set for no team in control
	move	a0,@cntl_team
	movi	DIVS_RATE1,a0		;Set new current rate
	move	a0,@scrl_divs_cur
	jruc	#adj_targx

#plyr_has_ball
	move	a5,a0			;Owned (A5 = plyrpnum)
	sll	5,a0
	addi	plyrobj_t,a0		;Get owner's OBJ ptr
	move	*a0,a0,L
	move	*a0(OXPOS),a3
	move	*a0(OXANI+16),a1
	add	a1,a3			;TARGX = owner X + ani X offset
#plyr_passed			;(TARGX = ball X, A5 = plyrpnumlast)
#plyr_shooting			;(TARGX = ball X, A5 = plyrpnumlast)
	move	a5,a0			;Set current team in control (0 or 1)
	srl	1,a0			; by who A5 is (owner or last owner)
	move	a0,@cntl_team
	sll	5,a5
	addi	plyrproc_t,a5		;Get plyr PROC ptr
	move	*a5,a5,L
	move	*a5(plyr_seqflgs),a1
	btst	DUNK_B,a1		;Is it a dunk? No if 0
	jrz	#not_dunking
	subk	1,a0			;Yes. Dec team control for condition



;This causes the scroller to drift a little further than the end of the court.
;But not as far as an inbound pass.
 	jrnz	#ib_rgt0
	movi	[WRLDMID-200-MAX_VIEW1+20,0],a3	;TARGX = lft side limit
	jruc	#do_ib
#ib_rgt0
	movi	[WRLDMID-200+MAX_VIEW1-20,0],a3	;TARGX = rgt side limit
	jruc	#do_ib
;	jruc	#dunking		; to select which side to scroll to



#not_dunking
	movi	DIVS_DELTA,a0		;Pass or jump/layup
	move	@scrl_divs_cur,a1
	move	@scrl_divs_dest,a2
	cmp	a1,a2			;Need to accel cur to dest?
	jreq	#adj_targx
	jrgt	#add
	sub	a0,a1			;Accelerate
	cmp	a1,a2
	jrle	#set_divs
	jruc	#lim
#add
	add	a0,a1			;Decelerate
	cmp	a1,a2
	jrge	#set_divs
#lim
	move	a2,a1
#set_divs
	move	a1,@scrl_divs_cur

#adj_targx
	move	@cntl_team,a0		;Adj TARGX to team in control
	jrn	#noteam			;Team 0 or 1 or no team if -
	jrnz	#adj_t1
	addi	SCRL_EDGE_OFF*2,a3	;2x to fall thru the SUBI
#adj_t1
	subi	SCRL_EDGE_OFF,a3

#noteam
	move	@cntl_team,a0		;Chk for turnover/loss of control
	move	@cntl_team_last,a1
	cmp	a0,a1
	jreq	#chk_targx
	move	a0,@cntl_team_last	;Whoever had it lost it
	movi	DIVS_RATE1,a0		;Set new current rate
	move	a0,@scrl_divs_cur

#chk_targx
	cmpi	WRLDMID-MAX_VIEW2,a3	;Chk TARGX to lft MAX2
	jrge	#trgx_ok1
	movi	WRLDMID-MAX_VIEW2,a3	;Too far. Set lft MAX2
	jruc	#chk_cur
#trgx_ok1
	cmpi	WRLDMID+MAX_VIEW2,a3	;Chk TARGX to rgt MAX2
	jrle	#trgx_ok2
	movi	WRLDMID+MAX_VIEW2,a3	;Too far. Set rgt MAX2
#chk_cur
	move	@scrl_divs_cur,a0
	cmpi	DIVS_RATE2,a0
	jrhs	#trgx_ok2
	movi	DIVS_RATE2,a0
	move	a0,@scrl_divs_cur
	move	a0,@scrl_divs_dest
#trgx_ok2
	subi	200,a3			;Adj TARGX to WORLDTLX
	sll	16,a3

#do_scroll
	move	@scrl_divs_cur,a7	;Do world-scroll X
	move	@WORLDTLX,a1,L
	move	a1,a5
	sub	a3,a5			;DIFFX=WORLDTLX-TARGX
	jreq	#no_scroll
	jrlt	#scr_rgt
#scr_lft
	subi	[SCROLL_BUFFER,0],a5		;No scroll if in "window"
	jrle	#no_scroll
	divu	a7,a5				;DIFFX/scrl_divs_cur
	sll	8,a5				;Move to int portion &
	sub	a5,a1				; step
	cmpi	[WRLDMID-200-MAX_VIEW1,0],a1	;Chk new X to lft MAX1
	jrle	#no_scroll
	jruc	#scr_inb
#scr_rgt
	abs	a5
	subi	[SCROLL_BUFFER,0],a5		;No scroll if in "window"
	jrle	#no_scroll
	divu	a7,a5				;DIFFX/scrl_divs_cur
	sll	8,a5				;Move to int portion &
	add	a5,a1				; step
	cmpi	[WRLDMID-200+MAX_VIEW1,0],a1	;Chk new X to rgt MAX1
	jrge	#no_scroll
#scr_inb
	move	@inbound,a0		;Go scroll if not inbounding (if neg)
	jrn	#scr_set
	move	@WORLDTLX,a0,L		;Inbounding
	sub	a1,a0			;No scroll if the difference between
	abs	a0			; old WORLDTLX & scrolled TLX is
	cmpi	INBND_MINX,a0		; minimal
	jrlt	#no_scroll
#scr_set
	move	a1,@WORLDTLX,L		;Set new TLX
	subi	[WRLDMID-200,0],a1
	move	a1,@gndx,L		;Set new ground-base X

#no_scroll

;----------
; do world-scroll Y

	move	*a8(OZPOS),a14
	cmpi	CZMAX,a14
	jrlt	#zin
	movi	CZMAX-1,a14
#zin
	subi	CZMIN,a14		;Sub min crt Z
	sra	1,a14			;YOFF=Z*3/8
	move	a14,a0
	sra	2,a14
	sub	a14,a0			;TARGY=YOFF
	movi	YBUFF_NORM,a1		;Set default buffer count
	movk	(-YRATE_NORM)&31,a2	;Set default Y rate shift count

	move	@ballpnum,a14		;Ball owned?
	jrn	#no_owner		; br=not owned

	sll	5,a14
	addi	plyrproc_t,a14
	move	*a14,a14,L		;Get owner *PROC
	move	*a14(plyr_seqflgs),a5
	btst	PASS_B,a5		;Is it a pass?
	jrnz	#no_yalt		; br=yes
	btst	DUNK_B,a5		;Is it a dunk?
	jrz	#do_yalt		; br=no

	movi	YBUFF_DUNK1,a1		;Set buffer count
	move	*a14(plyr_seq),a5	;Get dunk ani seq #
	cmpi	DUNKU2_SEQ,a5		;Dunk that needs different buffering?
	jrlt	#do_yalt		; br=no
	movi	YBUFF_DUNK2,a1		;Set buffer count
	movk	(-YRATE_SLOW)&31,a2	;Set Y rate shift count
	jruc	#do_yalt

#no_owner
	move	@ballprcv_p,a14,L	;Passing?
	jrz	#free			; br=no
	move	*a14(plyr_rcvpass),a3	;Is or was. Missed?
	jrle	#free			; br=yes

	move	*a14(plyr_seq),a3	;Pass in progress
	cmpi	ALLEYOOP1_SEQ,a3	;Is it an oop?
	jrlo	#no_oop
    	cmpi	ALLEYOOP14_SEQ,a3	;Is it an oop?
	jrls	#ys_yalt		;br=no
#no_oop
	cmpi	DDUNK_RECV_SEQ,a3
	jrne	#no_yalt		; br=no
#ys_yalt
	movi	YBUFF_ALLEY,a1		;Set buffer count
	movk	(-YRATE_SLOW)&31,a2	;Set Y rate shift count
	jruc	#do_yalt
#free
	.if	DEBUG
	.asg	0,YALTOFF	;Scroller Y offset for debug
	.else
	.asg	0,YALTOFF	;Always 0!
	.endif

	.if	VSCR_CNT
	move	@ballshotinair,a14	;Shooter # if shot in air, else -1
	jrnn	#do_yalt		; br=shot in the air
	cmpi	GNDI_H-VSCR_CNT-YALTOFF,a0
	jrle	#do_yalt
	subi	GNDI_H,a0
	jruc	#chk_trgy		;Go scroll up
	.endif

#do_yalt
	move	*a8(OYPOS),a14
	add	a14,a0			;TARGY+=BallAltitude
#no_yalt
	add	a1,a0			;Add buffer count to TARGY
	cmpi	-VSCR_CNT-CLIP_CNT-YALTOFF,a0
	jrlt	#chk_trgy		;Did it go pos? 0 it if so
	movi	-VSCR_CNT-CLIP_CNT-YALTOFF,a0

#chk_trgy
	move	@WORLDTLY+16,a1		;Int part of WORLDTLY
	sub	a1,a0			;DIFFY=TARGY-WORLDTLY
	jreq	#wy_skip
	sra	a2,a0			;Shift-div DIFFY to calc step
	jrnz	#wy_sok			;Don't allow step of 0
	addk	1,a0
#wy_sok
	add	a0,a1			;Step WORLDTLY
	cmpi	YMIN_VIEW,a1		;In allowed range?
	jrge	#wy_set
	movi	YMIN_VIEW,a1
#wy_set
	move	a1,@WORLDTLY+16		;Set new TLY

	.asg	-80,YBUFF_BOX
	.ref	crbox1_p		;sky box, all

	move	@pup_court,a14		;No skybox to scroll if outside
	jrnz	#wy_skip
	neg	a1
	addi	YBUFF_BOX,a1
	jrgt	#chk_boxy
	move	@off_boxy,a0
	jrz	#wy_skip
	clr	a1
	jruc	#do_boxy
#chk_boxy
	move	a1,a0
	sra	3,a1			;Take frac of Y diff (3/32)
	sra	5,a0
	sub	a0,a1
	move	@off_boxy,a0
#do_boxy
	sub	a1,a0
	jreq	#wy_skip
	move	a1,@off_boxy
	movi	crbox1_p,a3		;sky box, all
	movk	5,a5
#boxy
	move	*a3+,a2,L
	move	*a2(OYPOS),a14
	sub	a0,a14
	move	a14,*a2(OYPOS)
	dsj	a5,#boxy

#wy_skip

;----------

	.ref	do_ball_ani
	calla	do_ball_ani

;----------
; check ball Y coor bounce

	move	*a8(OYVEL),a2,L
	move	*a8(OYPOS),a1
	move	*a13(ball_aniy),a3
	add	a3,a1
;
;	cmpi	HOOPY-10,a1	;TEMP!!! Floats ball
;
	jrlt	#agnd			;Above gnd? br=yes

	movi	-1,a0
	move	a0,@ballshotinair	;Shooter # if shot in air, else -1
	clr	a0
	calla	plyr_setshtdly

	cmpi	>7f00,a2		;>4000
	jrlt	#nosnd

	movi	dribble3_snd,a0,L
	move	@pup_court,a14
	jrnz	#ply1			;br=outdoor court
	movi	dribble_snd,a0,L
#ply1	calla	snd_play1
#nosnd
	neg	a3
;
;	addi	HOOPY-10,A3	;TEMP!!! Floats ball
;
	move	a3,*a8(OYPOS)		;Set on gnd
	neg	a2
	move	a2,a3			;Take 1/4 off YVEL
	sra	2,a3
	sub	a3,a2
;;	move	@ballpnum,a0		;Plyr # who owns (0-3) or Neg
;;	jrnn	#agnd			; br=owned, dribbling
;;	sra	1,a3			;Take another 1/8 off YVEL
;;	sub	a3,a2
#agnd
	addi	GRAVB,a2
	move	a2,*a8(OYVEL),L

	move	*a8(OXVAL),*a9(OXVAL),L	;>Align shadow
	move	*a8(OXANI),*a9(OXANI),L
	move	*a8(OZPOS),a0
	subk	10,a0			;Adjust
	move	a0,*a9(OZPOS)

#halted2
;Did ball just hit the rim?  If yes, skip collisions!
;I hope this variable never gets thrashed!
	move	@in_cylinder,a0
	jrnz	#halted
	callr	ball_chkpcollide

#halted
	SLOOP	1,#lp


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

	move	*a8(OYPOS),a7		;A7=Ball Y
	move	*a8(OSIZEY),a14
	srl	1,a14
	add	a14,a7			;=Ball center Y

	.if DEBUG
	move	@RIM_STEP,a0
	jrz	#ttt2
	clr	a14
	cmpi	HOOPY+20,a7
	jrge	#ttt1
	move	*a8(OZPOS),a0
	movi	CZMID,A1
	sub	a1,a0
	abs	a0
	cmpi	20,a0
	jrge	#ttt1
	movi	HOOPLX,a0
	sub	a6,a0
	abs	a0
	cmpi	24,a0
	jrhi	#ttt0
	movk	4,a14
#ttt0
	movi	HOOPRX,a0
	sub	a6,a0
	abs	a0
	cmpi	24,a0
	jrhi	#ttt1
	movk	4,a14
#ttt1
	.ref	slowmotion
	.ref	pup_notag
	move	a14,@slowmotion
	movk	15,a14
	move	a14,@pup_notag
#ttt2
	.endif

	cmpi	HOOPY+20,a7		;Below all collision pts? Yes if >=
	jrge	#x

	clr	b2			;B2=Rim collision flag

	move	@shot_distance,a14
	cmpi	>150*DIST_ADDITION,a14	;!!!Close or far shot?
	jrlt	#ok

	move	@ballscorezhit,a0	;Far, but have we hit 1st score zone?
	jrp	#ok			; br=yes, continue score detect

	movi	200,a0			;!!!Far. Set long odds
	cmpi	>1c0*DIST_ADDITION,a14	;!!!How far?
	jrlt	#far
	movi	20,a0			;!!!Very far. Set longer odds
#far
	move	@game_time,a1,L
	cmpi	>400,a1			;!!!Improve odds if qrtr almost over
	jrgt	#nohelp
	addi	150,a0			;!!!
#nohelp
	calla	RNDPER			;Scoreable or unscoreable?
	jrhi	#ok
	movi	lhoopl_t,a10		;Set ptr for unscoreable hoop
	movi	HOOPLX,b3		;B3=Hoop X
	cmpi	WRLDMID,a6
	jrlt	#left
	movi	lhoopr_t,a10
	movi	HOOPRX,b3
	jruc	#left
#ok
	movi	hoopl_t,a10		;Set ptr for scoreable hoop
	movi	HOOPLX,b3		;B3=Hoop X
	cmpi	WRLDMID,a6
	jrlt	#left
	movi	hoopr_t,a10
	movi	HOOPRX,b3
#left
	move	*a8(OZPOS),a5		;A5=Ball Z
	move	@ballscorezhit,a0	;Haven't scored? No if >=
	jrge	#chkpts

	move	*a8(OZVEL),a0,L		;Yes. Slow XYZ vels
	sra	1,a0
	move	a0,*a8(OZVEL),L		;=-1/2 ZVEL

	move	*a8(OYVEL),a0,L
	move	a0,a14
	sra	2,a14
	sub	a14,a0
	move	a0,*a8(OYVEL),L		;=-1/4 YVEL

	move	a6,a0			;Pull ball toward hoop center X
	move	b3,a14
	sub	a14,a0			;=BALLX-HOOPX
	sll	16-4,a0			;XVELPULLCTR=(INT:FRC)/16

	move	*a8(OXVEL),a1,L
	sub	a0,a1			;=XVEL-XVELPULLCTR
	move	a1,a14
	sra	2,a14
	sub	a14,a1
	move	a1,*a8(OXVEL),L		;=-1/4 XVEL

	jruc	#chkbb

;----------
; Top of rim pt chk loop

#lp
	move	*a10+,a3		;Rim Y
	move	*a10+,a4		;Rim Z
	move	*a10+,a11		;Rim zone #
	sub	a6,a2
	sub	a7,a3
	sub	a5,a4
	abs	a2
	abs	a3
	abs	a4

	.asg	4,DX_RNG		;!!!
	.asg	4,DY_RNG		;!!!
	.asg	4,DZ_RNG		;!!!
	.asg	5,MAX_RNG		;!!!

	cmpi	DX_RNG,a2
	jrgt	#nxt
	cmpi	DY_RNG,a3
	jrgt	#nxt
	cmpi	DZ_RNG,a4
	jrgt	#nxt

	cmp	a3,a2			;Sort A10,A12,A13 to most,mid,least
	jrge	#20
	SWAP	a2,a3
#20
	cmp	a4,a3
	jrge	#sorted
	SWAP	a3,a4

	cmp	a3,a2
	jrge	#sorted
	SWAP	a2,a3
#sorted
	srl	1,a3			;1/2 of delta mid
	srl	2,a4			;1/4 of delta least
	add	a3,a2			;Sum the deltas
	add	a4,a2
	subk	MAX_RNG,a2		;Too far? Yes if >
	jrgt	#nxt

	move	@sc_proc,a0,L		;No. Any shot clock going?
	jrz	#no24clock
;;	move	*a0(PROCID),a14
;;	cmpi	clockid,a14
;;	jrz	#cont
;;	LOCKUP
;;#cont
	clr	a14			;Yes. Clr so we don't do this again
	move	a14,@sc_proc,L
	PUSH	a7,a10			;Go turn it off
	movi	sclockx,a7
	movi	clockid,a1
	move	*a0(PA10),a10,L
	calla	XFERPROC
	PULL	a7,a10
#no24clock
	clr	a0
	move	a0,@ballgoaltcnt

	movi	3*60+30,a0		;!!!Set Rebound stat time limit
	move	a0,@rebound_delay

	movi	-1,a0			;Tell shot clock ball has no owner
	move	a0,@ballsclastp
	move	a0,@ballshotinair	;Shooter # if shot in air, else -1

	move	a11,a11			;Scoreable? Yes if <=
	jrle	#notrim

	.if DEBUG
	move	@RIM_STEP,a0
	jrz	#nobprs
	calla	get_all_buttons_cur2
	andi	2020202h,a0
	jrz	#nobp
	movk	1,a0
	move	a0,@HALT
	jruc	#x
#nobp
	clr	a0
	move	a0,@HALT
#nobprs
	.endif
 
	move	@ballrimhitcnt,a0	;No. Already hit the rim? Yes if !0
	jrnz	#skipit

	PUSH	a0,a7,a11		;No


;To disallow people from swatting (or rebounding) ball off of rim, we will
;ignore ball collisions for x ticks after the first rim hit....
;Yikes!
	movk	12,a0
	move	a0,@in_cylinder

;Disallow slap rejection of ball within 120 ticks - rejection art will
;glitch into rebound art within this time limit...
	movi	120,a0
	move	a0,@must_rebound



	move	@ballpnumshot,a0	;Set ptr to shooter brick cnt
	sll	4,a0
	addi	brick_count,a0
	move	*a0,a1			;Inc brick cnt (in case it is one?)
	inc	a1
	move	a1,*a0
	move	b3,a11			;A11=Hoop X
	CREATE	NOG_PID,no_good_check	;Let it say "No good" (if it is?)
	PULL	a0,a7,a11
#skipit
	addk	1,a0			;Inc rim hit cnt
	move	a0,@ballrimhitcnt

	move	b2,b2			;Hit already? Yes if !0
	jrnz	#not1st

	addk	1,b2			;No. Set hit flag
	cmpi	2,a11			;Hit in a rim-bend zone? No if <
	jrlt	#nobend
	clr	a0			;Yes. Do rim bend anim
	move	@rimlf,a1,L		;Assume doing lft hoop
	cmpi	WRLDMID,a6		;Bend lft or rgt rim? Lft if <
	jrlt	#netani
	movk	1,a0			;Set for rgt hoop
	move	@rimrf,a1,L
#netani
	move	*a1(OIMG),a1,L		;Deref *obj
	cmpi	FLAME_F_13,a1,L		;Is it burnt hoop img? Yes if =
	jreq	#nobend
	cmpi	FLAME2F_13,a1,L		;Is it burnt hoop img? Yes if =
	jreq	#nobend
	movk	NET_MISS_CLOSE,a1	;No, we can bend it
	move	@shot_distance,a14
	cmpi	300*DIST_ADDITION,a14	;!!!Shot close or far?
	jrlt	#nani
	movk	NET_MISS_FAR,a1
#nani
	calla	net_ani
#nobend
	move	@pup_court,a0
	jrz	#indrct			;br=indoor court!
	SOUND1	miss5_snd
	jruc	#not1st
#indrct
	move	@PCNT,a0		;Do rnd rim-bounce sound
	sll	32-2,a0			; (choose 1 of 4 possible)
	srl	32-2-5,a0
	addi	rim_snds,a0
	move	*a0,a0,L
	calla	snd_play1

#not1st
	PUSH	A5,A6,A7,A11,A12,A13	;Move ball back out of rim detection
	sll	16,a6
	sll	16,a7			;A7=Y:0
	sll	16,a5
	move	a6,a9			;A9=X:0
	move	a5,a11			;A11=Z:0

	movk	OXVEL,a0
	add	a8,a0
	mmfm	a0,a6,a5,a4,a3,a2,a1	;Get VELs & VALs (X,Y,Z,X,Y,Z)
	movx	a3,a9			;Copy VAL fracs to ball detect POSs
	movx	a2,a7
	movx	a1,a11

	.bss	ballrimhit_x,32
	.bss	ballrimhit_y,32
	.bss	ballrimhit_z,32

	move	a9,@ballrimhit_x,L
	move	a7,@ballrimhit_y,L
	move	a11,@ballrimhit_z,L
	cmpi	1,b2			;Hit already? Yes if >
	jrls	#yes1st			; br=no
	PULL	A5,A6,A7,A11,A12,A13
	jruc	#notstk
#yes1st
	sra	4,a6			;!!!Take frac of VELs
	sra	4,a5			;!!!
	sra	4,a4			;!!!

	subi	4*16,a10		;Retrieve coords we detected against
	move	*a10+,a0		; to calc detection deltas
	sll	16,a0
	sub	a0,a9			;=dX
	move	*a10+,a0
	sll	16,a0
	sub	a0,a7			;=dY
	move	*a10+,a0
	sll	16,a0
	sub	a0,a11			;=dZ
	addk	16,a10
#velstep
	sub	a6,a3			;Step back the ball
	sub	a5,a2
	sub	a4,a1
	sub	a6,a9			;Step back the deltas
	sub	a5,a7
	sub	a4,a11
	move	a9,a12			;Get abs of delta integers
	abs	a12
	srl	16,a12
	move	a7,a13
	abs	a13
	srl	16,a13
	move	a11,a14
	abs	a14
	srl	16,a14

	cmpi	DX_RNG,a12
	jrgt	#velset
	cmpi	DY_RNG,a13
	jrgt	#velset
	cmpi	DZ_RNG,a14
	jrgt	#velset

	cmp	a13,a12			;Sort A12,A13,A14 to most,mid,least
	jrge	#30
	SWAP	a12,a13
#30
	cmp	a14,a13
	jrge	#velsort
	SWAP	a13,a14

	cmp	a13,a12
	jrge	#velsort
	SWAP	a12,a13
#velsort
	srl	1,a13			;1/2 of delta mid
	srl	2,a14			;1/4 of delta least
	add	a13,a12			;Sum the deltas
	add	a14,a12
	subk	MAX_RNG,a12		;Too far? No if <=
	jrle	#velstep
#velset
	move	a5,a5			;Keep steping if ball Y has still
	jrnn	#posyv			; stepped over the collision pt Y
	move	a7,a7
	jrn	#velstep
	jruc	#velst
#posyv
	move	a7,a7
	jrnn	#velstep
#velst
	move	a3,*a8(OXVAL),L
	move	a2,*a8(OYVAL),L
	move	a1,*a8(OZVAL),L
	PULL	A5,A6,A7,A11,A12,A13

	move	*a13(ball_collcnt),a1	;Might ball be stuck?
	subk	3,a1			;!!!No if <
	jrlt	#notstk
	callr	ball_stuck		;Go try unstick &
	jruc	#limvels		; exit detect loop

#notstk
	subi	4*16,a10		;Retrieve coords we detected against
	move	*a10+,a2		; for deflection
	move	*a10+,a3
	move	*a10+,a4
	addk	16,a10
	callr	ball_deflect
	jruc	#limvels		; exit detect loop
;	jruc	#nxt			;Go chk next pt

#notrim
	callr	ball_score		;Score if really a basket
	move	@ballscorezhit,a0	;Did it score?
	jrn	#limvels		; br=yes

#chkpts
#nxt
	move	*a10+,a2		;Rim X
	jrnz	#lp			;End of table? No if !0

;----------
; Do velocity limits

#limvels
	move	b2,a1			;Chk consecutive rim collisions
	jrz	#svcol			;Hit rim this time? br=no, reset cnt
	move	*a13(ball_collcnt),a1	;Inc consecutive cnt
	addk	1,a1
#svcol
	move	a1,*a13(ball_collcnt)
	jrz	#chkbb			;No rim collision? br=no

	move	*a8(OXVEL),a2,L		;Yes. Limit max X&Z VEL
	move	*a8(OZVEL),a3,L
	move	*a8(OYVEL),a4,L
	move	a4,a14
	sra	8,a14			;=YVEL/256
	move	a2,a0
	move	a3,a1
	abs	a0			;=abs(XVEL)
	abs	a1			;=abs(ZVEL)
	cmp	a0,a1			;Make A1 whichever is faster, X|Z
	jrge	#sclvlp
	move	a0,a1
#sclvlp
	cmpi	>18000,a1		;>12000;!!!X|Z VEL within max? Yes if <
	jrle	#chkyv
	srl	1,a1			;Shift down X&Z
	sra	1,a2
	sra	1,a3
	add	a14,a4			;Bump Y fractionally
	jruc	#sclvlp
#chkyv
	move	a2,*a8(OXVEL),L		;Store back (new) X&Z vels
	move	a3,*a8(OZVEL),L

	cmpi	->44000,a4		;!!!Limit max up YVEL
	jrge	#yupok
	movi	->44000,a4		;!!!
#yupok
	cmpi	>30000,a4		;!!!Limit max dn YVEL
	jrle	#ydnok
	movi	>30000,a4		;!!!
#ydnok
	move	a4,*a8(OYVEL),L		;Store back (new) Y vel

;----------
; Detect backboard

	.asg	4,BBRD_X_BC		;# frac bits to keep in XVAL detect
	.asg	4,BBRD_X_DEPTH		;# frac bits to keep in XVAL detect

#chkbb
	subi	BBRD_Z,a5		;Chk Z
	move	a5,a2
	abs	a2
	cmpi	BBRD_ZWID/2,a2
	jrgt	#x
	subi	BBRD_Y-BBRD_YWID/2,a7	;Chk Y
	abs	a7
	cmpi	BBRD_YWID/2,a7
	jrgt	#x
	move	*a8(OXVAL),a6,L		;Add ani X to check ball center
	move	*a13(ball_anix),a14
	sll	16,a14
	add	a14,a6
	subi	[WRLDMID,0],a6,L	;Chk X
	move	a6,a2
	abs	a6
	sra	16-BBRD_X_BC,a6
;;	sub	a5,a6			;Fudge with (now 3/32) Z offset from
;;	sra	1,a5			; bbrd ctr to retard/advance X detect
;;	sub	a5,a6
	cmpi	BBRD_X << BBRD_X_BC,a6
	jrlt	#x

	movi	-1,a0			;Detect
	move	a0,@ballshotinair	;Shooter # if shot in air, else -1
	move	*a8(OXVEL),a0,L		;Make sure ball continues
	abs	a0			; towards ctr crt
	move	a0,a1			;Slow down XVEL
	srl	2,a1			;-25%
	sub	a1,a0
	move	a2,a2
	jrn	#lbb			;Lft bbrd? Yes if -
	neg	a0
#lbb
	move	a0,*a8(OXVEL),L
	move	*a8(OXVAL),a1,L		;Give XVAL a quick kick in new dir
	add	a0,a1
	add	a0,a1
	move	a1,*a8(OXVAL),L

	abs	a0			;Should we make a bbrd bounce sound?
	cmpi	>1fff,a0		;!!! Min XVEL to make sound
	jrlt	#softbbhit
	movi	hitbkbd_snd,a0,L
	move	@pup_court,a14
	jrz	#indr			;br=indoor court
	movi	hitbkbd2_snd,a0,L
#indr	calla	snd_play1
#softbbhit
	.ref	backbrd_hit_speech
	CREATE0	backbrd_hit_speech
	move	@ballbbhitcnt,a0
	addk	1,a0
	move	a0,@ballbbhitcnt

	subk	7,a0			;!!! Stuck on bbrd? No if <
	jrlt	#x
	movi	>20000,a0		;!!! ZVEL(!) to kick it from bbrd
	move	*a8(OZPOS),a1
	cmpi	CZMID,a1		;Kick it which way? Out if >
	jrgt	#newzv
	neg	a0			;In
#newzv
	move	a0,*a8(OZVEL),L		;Try to unstick

#x	PULL	a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets


	.asg	HOOPLX,X
	.asg	HOOPY,Y
	.asg	CZMID,Z
hoopl_t
	.word	X+8	,Y	,Z	,4	;Rim
	.word	X+6	,Y	,Z-6	,3
	.word	X+6	,Y	,Z+6	,3
	.word	X+3	,Y	,Z-8	,1
	.word	X+3	,Y	,Z+8	,1
	.word	X	,Y	,Z-9	,2
	.word	X	,Y	,Z+9	,2
	.word	X-3	,Y	,Z-8	,1
	.word	X-3	,Y	,Z+8	,1
	.word	X-6	,Y	,Z-6	,1
	.word	X-6	,Y	,Z+6	,1
	.word	X-8	,Y	,Z	,1

	.word	X	,Y	,Z	,-1	;Score spots
	.word	X	,Y+3	,Z	,-1

	.word	X+1	,Y+6	,Z	,-2
	.word	X	,Y+6	,Z-1	,-2
	.word	X	,Y+6	,Z+1	,-2
	.word	X-1	,Y+6	,Z	,-2

	.word	X+3	,Y+8	,Z	,-2
	.word	X	,Y+8	,Z-3	,-2
	.word	X	,Y+8	,Z+3	,-2
	.word	X-3	,Y+8	,Z	,-2
	.word	0

	.asg	HOOPRX,X
hoopr_t
	.word	X-8	,Y	,Z	,4	;Rim
	.word	X-6	,Y	,Z-6	,3
	.word	X-6	,Y	,Z+6	,3
	.word	X-3	,Y	,Z-8	,1
	.word	X-3	,Y	,Z+8	,1
	.word	X	,Y	,Z-9	,2
	.word	X	,Y	,Z+9	,2
	.word	X+3	,Y	,Z-8	,1
	.word	X+3	,Y	,Z+8	,1
	.word	X+6	,Y	,Z-6	,1
	.word	X+6	,Y	,Z+6	,1
	.word	X+8	,Y	,Z	,1

	.word	X	,Y	,Z	,-1	;Score spots
	.word	X	,Y+3	,Z	,-1

	.word	X-1	,Y+6	,Z	,-2
	.word	X	,Y+6	,Z-1	,-2
	.word	X	,Y+6	,Z+1	,-2
	.word	X+1	,Y+6	,Z	,-2

	.word	X-3	,Y+8	,Z	,-2
	.word	X	,Y+8	,Z-3	,-2
	.word	X	,Y+8	,Z+3	,-2
	.word	X+3	,Y+8	,Z	,-2
	.word	0


;--------------------
; Long range shot tables; no score pts

	.asg	HOOPLX,X
lhoopl_t
	.word	X+8	,Y	,Z	,4	;Rim
	.word	X+6	,Y	,Z-6	,3
	.word	X+6	,Y	,Z+6	,3
	.word	X+3	,Y	,Z-8	,1
	.word	X+3	,Y	,Z+8	,1
	.word	X	,Y	,Z-9	,2
	.word	X	,Y	,Z+9	,2
	.word	X-3	,Y	,Z-8	,1
	.word	X-3	,Y	,Z+8	,1
	.word	X-6	,Y	,Z-6	,1
	.word	X-6	,Y	,Z+6	,1
	.word	X-8	,Y	,Z	,1

	.word	X+4	,Y	,Z	,3	;No-score spots
	.word	X	,Y	,Z-4	,2
	.word	X	,Y	,Z	,2
	.word	X	,Y	,Z+4	,2
	.word	X-4	,Y	,Z	,1

	.word	0

	.asg	HOOPRX,X
lhoopr_t
	.word	X-8	,Y	,Z	,4	;Rim
	.word	X-6	,Y	,Z-6	,3
	.word	X-6	,Y	,Z+6	,3
	.word	X-3	,Y	,Z-8	,1
	.word	X-3	,Y	,Z+8	,1
	.word	X	,Y	,Z-9	,2
	.word	X	,Y	,Z+9	,2
	.word	X+3	,Y	,Z-8	,1
	.word	X+3	,Y	,Z+8	,1
	.word	X+6	,Y	,Z-6	,1
	.word	X+6	,Y	,Z+6	,1
	.word	X+8	,Y	,Z	,1

	.word	X-4	,Y	,Z	,3	;No-score spots
	.word	X	,Y	,Z-4	,2
	.word	X	,Y	,Z	,2
	.word	X	,Y	,Z+4	,2
	.word	X+4	,Y	,Z	,1

	.word	0

rim_snds
	.long	miss1_snd,miss4_snd,miss2_snd,miss3_snd


#*******************************
* Deflect ball from what it hit
* A2=Hit X
* A3=Hit Y
* A4=Hit Z
* ballrimhit_x=ball ctr X @ hit
* ballrimhit_y=ball ctr Y @ hit
* ballrimhit_z=ball ctr Z @ hit
* A8=*Ball obj
* A13=*Ball process
* Trashes scratch, A0-A4

;LOOK!!!
 SUBRP	ball_deflect

	PUSH	a5,a6,a7,a9,a10,a11

	move	@ballrimhit_x,a6,L
	move	@ballrimhit_y,a7,L
	move	@ballrimhit_z,a5,L
	move	*a8(OXVEL),a14,L
	sub	a14,a6
	move	*a8(OYVEL),a14,L
	sub	a14,a7
	move	*a8(OZVEL),a14,L
	sub	a14,a5

;;	move	*a8(OXVAL),a6,L
;;	move	*a8(OYVAL),a7,L
;;	move	*a8(OZVAL),a5,L
;;
;;	move	*a13(ball_anix),a14	;Add ani X to check ball center
;;	sll	16,a14
;;	add	a14,a6
;;
;;	move	*a8(OSIZEY),a14
;;	sll	16-1,a14		;Shf up -1 to divide SIZEY in half
;;	add	a14,a7			;=Ball center Y

	sll	16,a2
	sll	16,a3
	sll	16,a4

;;	sra	12,a5
;;	sra	12,a6
;;	sra	12,a7
;;	sll	4,a2
;;	sll	4,a3
;;	sll	4,a4
;;;	sll	4,a5
;;;	sll	4,a6
;;;	sll	4,a7

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
	sra	1,a3			;Shf to avoid mpy overflows
	sra	1,a9

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

	sla	1,a3
	sla	1,a9
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
	sra	1,a3
	sra	1,a9

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

	sla	1,a3
	sla	1,a9
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

	PUSH	a4,a5,a6,a7

	move	*a8(OIMG),a4,L
	move	*a8(OXANI+16),a5
	move	*a4(IANIOFFX),a0
	move	a0,*a8(OXANI+16)

	move	b3,a6			;>Give vel towards or away from center
	movi	CZMID,a7
	callr	seekdirdist_obxz128

	move	a5,*a8(OXANI+16)

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

	PULL	a4,a5,a6,a7
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

	movk	PS_2PTS_MADE,a0		;>Inc made shot stat
	subk	2,a3
	jrz	#2ptr
	movk	PS_3PTS_MADE,a0
#2ptr
	move	@ballpnumshot,a1
	calla	inc_player_stat

;	calla	scored_speech
	calla	prt_top_scores		;Update scores at scrn top

	CREATE0	score_showtvpanel

	move	a2,a11			;A11=who takes-out ball (0=1, !0=2)

	.if DUNKTST
	.else
	CREATE0	plyr_takeoutball ;When testing dunks - TAKE OUT!
	.endif

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

;----------
; Do plyr on-fire logic

	move	@ballpnumshot,a0	;Get scoring plyr #
	movi	ballpnumscored,a3
	move	*a3+,a1			;Get last scoring plyr #
	move	*a3+,a4			;Get # times last plyr scored
	move	*a3+,a5			;Get last team-shot scored (0=tm2,32=tm1)
	move	*a3,a7			;Get # times last team-shot scored

	move	a0,a14			;Clr scoring plyr brick cnt
	sll	4,a14
	addi	brick_count,a14
	clr	a11
	move	a11,*a14

	move	a0,a10			;Get scoring plyr *proc
	sll	5,a10
	addi	plyrproc_t,a10
	move	*a10,a10,L
	move	*a10(plyr_seq),a6	;Get scoring plyr ani seq #

	movi	AUD_ALLEYOOPS,a14
	cmpi	ALLEYOOP1_SEQ,a6	;Was it an oop?
	jrlo	#notoop
	cmpi	ALLEYOOP14_SEQ,a6
	jrls	#yestmsht
#notoop
	movi	AUD_DBLE_DNKS,a14
	cmpi	DDUNK_RECV_SEQ,a6	;Was it a double dunk?
;	jreq	#yestmsht
	jreq	#yestmsht2
	cmpi	TMFIRE_MINCNT,a7	;Is a team on-fire?
	jrhs	#ply1st			; br=yes
	jruc	#notmsht
#yestmsht
	PUSH	a0

;If I am a drone, and my teammate is a human, we end up allowing only
;3 per period.

;NOTE:  Double dunks do not count toward this maximum.
	move	*a10(plyr_alley_cnt),a0	;3 successful drone alley oops/period
	inc	a0
	move	a0,*a10(plyr_alley_cnt)
	jruc	#cont_oop
#yestmsht2
	PUSH	a0
#cont_oop

	move	@GAMSTATE,a0
	cmpi	INAMODE,a0		;Don't audit if in attract
	jrz	#noaud
	move	a14,a0
	calla	AUD1
#noaud
	PULL	a0
	cmpi	TMFIRE_MINCNT,a7	;Is a team on-fire?
	jrlo	#notmfire		; br=no
	cmp	a5,a2			;Same team as last time?
	jreq	#ply1st			; br=yes
#notmfire
	addk	1,a7			;Assume it is same team
	cmp	a5,a2			;Same team as last time?
	jreq	#sametm			; br=yes
;	move	a2,a5			;Set new last team-shot scored
	movk	1,a7			;Set new team-shot cnt
	jruc	#notm1
#sametm
	cmpi	TMFIRE_MINCNT,a7	;Did a team go on-fire?
	jrlo	#notmsht		; br=no
	PUSH	a0,a1,a7,a9
	move	a5,a9
	.ref	tmfire_timer
	CREATE	tmfireid,tmfire_timer
	PULL	a0,a1,a7,a9
	jruc	#plyfireout

#notmsht
	cmp	a5,a2			;Same team as last time?
	jreq	#sametm1		; br=yes
	clr	a7			;Set new team-shot cnt
#notm1
	move	a2,a5			;Set new last team-shot scored
	cmpi	ONFIRE_MINCNT,a4	;Was a plyr on-fire?
	jrlt	#ply1st			; br=no, set new 1st timer
	jruc	#plyfireout		;Go put out fire
#sametm1
	cmpi	ONFIRE_MINCNT,a4	;Last scoring plyr # on-fire?
	jrge	#sametm2		; br=yes
	cmp	a1,a0			;Same plyr as last time?
	jrne	#ply1st			; br=no
	jruc	#sameplr
#sametm2
	move	@plyr_onfire,a14
	btst	a0,a14			;Is scoring plyr on-fire?
	jrz	#savefire		; br=no, teammate is on-fire
#sameplr
	.if (DUNKTST==0)|(DUNKTST==2)
	addk	1,a4		 ;When testing dunks - TAKE OUT!
	.endif
	cmpi	ONFIRE_MAXCNT,a4	;Time to put out fire?
	jrlt	#savefire		; br=no

#plyfireout
	clr	a1			;Put out plyr on-fire
	move	a1,@plyr_onfire		;Save new on-fire bits
#ply1st
	movk	1,a4			;Set new # times last plyr scored

#savefire
	move	a7,*a3			;Save # times last team-shot scored
	move	a5,-*a3			;Save last team-shot scored (0=tm2,32=tm1)
	move	a4,-*a3			;Save # times last plyr scored
	move	a0,-*a3			;Save last scoring plyr #

;----------
; Do a net animation

	move	*a10(plyr_seqflgs),a6	;Get plyr shot ani seq #

	move	@pup_court,a0
	jrz	#indrct2			;br=indoor court!
	movi	dunk_snd5,a11,L
	jruc	#crt2
#indrct2
	movk	3,a0
	calla	rndrng0
	move	a0,a11
	sll	5,a11
	addi	dnk_snd_tbl,a11
	move	*a11,a11,L
#crt2
	movk	NET_DUNK,a1		;Dunk netani #
	btst	DUNK_B,a6		;Was it a dunk? Yes if !0
	jrnz	#netani

	CREATE0	plyr_jscrowdsnd		;For good jump shot

	movk	3,a0
	calla	rndrng0
	move	@pup_court,a14
	jrz	#indoor			;br=outdoor court
	addk	4,a0
#indoor
	move	a0,a11
	sll	5,a11
	addi	swish_snd_tbl,a11
	move	*a11,a11,L
	movk	NET_MIDZ_FAR,a0		;Mid crt far netani #
	movk	NET_MIDZ_CLOSE,a1	;Mid crt close netani #
	move	*a8(OXVEL),a14,L
	move	*a8(OZVEL),a4,L
	abs	a14
	abs	a4
	cmp	a4,a14
	jrgt	#gotnet
	movk	NET_DEEPZ_FAR,a0	;Deep Z far netani #
	movk	NET_DEEPZ_CLOSE,a1	;Deep Z close netani #
	move	*a8(OZVEL),a4,L
	jrnn	#gotnet
	movk	NET_NEARZ_FAR,a0	;Near Z far netani #
	movk	NET_NEARZ_CLOSE,a1	;Near Z close netani #
#gotnet
	move	@shot_distance,a14
	cmpi	180*DIST_ADDITION,a14	;!!!Shot close or far?
	jrlt	#rndani
	move	a0,a1			;Use far netani #
#rndani
	move	@PCNT,a0		;Choose one of the ani versions
	sll	32-2,a0
	srl	32-31,a0
	add	a0,a1
#netani
	move	*a3(32),a4		;Chk for team on-fire
	cmp	a2,a4
	jrnz	#notmf			; br=not
	move	*a3(48),a4		;Maybe. Chk shot cnt
	subk	TMFIRE_MINCNT,a4
	jrnn	#nethot			; br=yes, team on-fire
#notmf
	move	*a3(16),a4		;Chk for plyr on-fire
;	move	*a3,a14
;	move	@fire_flags,a0
;	btst	a14,a0
;	jrz	#nor2
;	subk	ONFIRE_MINCNT+1,a4	;# shots for on-fire if was before
;	jruc	#nor3
;#nor2
	subk	ONFIRE_MINCNT,a4	;# shots for on-fire
;#nor3
	jrlt	#nothot			;Enough for on-fire? br=no
	move	@plyr_onfire,a0		;Is shooter the one on-fire?
	jrz	#nethot			; br=yes, just went on-fire
	move	*a3,a14			;Maybe. Was he on-fire before?
	btst	a14,a0
	jrz	#nothot
#nethot
	.ref	rim_fire_snd
	movi	rim_fire_snd,a11,L
	movk	NET_ONFIRE,a1		;Burn netani # - all net
;	move	@ballrimhitcnt,a0
;	jrz	#nothot
	move	@HCOUNT,a0
	srl	1,a0
	jrnc	#hotshk
	movk	NET_ROLLINFIRE,a1	;Burn netani # - off rim
#hotshk
	PUSH	a1,a6,a10,a11
	.ref	SHAKER	;2
	movk	24,a10
	calla	SHAKER	;2
	move	*a3(48),a4		;Chk shot cnt
	subk	TMFIRE_MINCNT,a4
	jrn	#nosalt			; br=yes, team on-fire
	.ref	rim_salt
	CREATE0	rim_salt
#nosalt
	PULL	a1,a6,a10,a11
#nothot
	move	a2,a0
	calla	net_ani			;Do net ani

	move	a11,a0
	calla	snd_play1		;Do net sound


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

	movi	>14000,a0		;!!!temp(?)
	move	a0,*a8(OYVEL),L

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
	XORK	1,a2			;Inbounding team (0-1)

	.if DUNKTST
	.else
	move	a2,@inbound	;When testing dunks - TAKE OUT!
	.endif

	movk	20,a10
	calla	SHAKER	;2

;FIXX!!!  TEMP!!!
;	sll	4,a3			;*16
;	addi	t1dunkcnt,a3
;	move	*a3,a0
;	addk	1,a0
;	jrnc	#noshat			;No overflow?
;
;	move	*a10(plyr_seq),a0
;	movi	#dunk_t,a1
;#dlp	move	*a1+,a14
;	jrn	#noshat2		;End of table?
;	cmp	a14,a0
;	jrne	#dlp			;Wimpy dunk?
;
;	move	@PSTATUS,a0		;Plyr start bits 0-3
;	move	@ballpnumshot,a1
;	btst	a1,a0
;	jrz	#noshat2		;Drone?
;
;
;	move	@bbshatter,a0		;Already happened
;	jrnz	#noshat2
;
;;	jruc	#noshat2		;THE NBA SUCKS!
;
;	.ref	gmqrtr
;	move	@gmqrtr,a0
;	cmpi	3,a0
;	jrlt	#noshat2
;
;	move	*a10(plyr_attrib_p),a0,L
;	move	*a0(PAT_DUNKSKILL),a0
;	cmpi	9,a0
;	jrlt	#noshat2
;
;	clr	a0
;	move	a0,*a3			;Reset cnt
;	move	a0,@t1dunkcnt
;	move	a0,@t2dunkcnt
;
;	movk	32,a0
;	cmpi	2,a1
;	jrlt	tm1
;;Knock down team 1
;	move	@plyrproc_t,a1,L
;	move	a0,*a1(plyr_stagcnt)
;	move	@plyrproc_t+32,a1,L
;	move	a0,*a1(plyr_stagcnt)
;	jruc	#doit
;tm1
;	move	@plyrproc_t+64,a1,L
;	move	a0,*a1(plyr_stagcnt)
;	move	@plyrproc_t+96,a1,L
;	move	a0,*a1(plyr_stagcnt)
;#doit
;	CREATE0	board_shatter
;	movi	HOOP_PID,a0
;	calla	KIL1C
;	move	a2,a0
;	movk	5,a1			;Big rim bend
;	calla	net_ani
;	movk	18,a10			;Big shake
;	jruc	#shake
;#noshat
;	move	a0,*a3
;#noshat2
;	movk	24,a10
;#shake	calla	SHAKER	;2

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

dnk_snd_tbl
	.long	dunk_snd2,dunk_snd4,dunk_snd3,dunk_snd1

swish_snd_tbl
	.long	swish_snd2,swish_snd3,swish_snd1,swish_snd2
	.long	swish_snd4,swish_snd5,swish_snd6,swish_snd4,swish_snd5

#dunk_t	.word	DUNKP_SEQ,DUNKA_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKE2_SEQ,DUNKD2_SEQ
	.word	DUNKL_SEQ,DUNKL2_SEQ,DUNKL3_SEQ
	.word	DUNKP2_SEQ
	.word	DUNKP3_SEQ
	.word	DUNKR_SEQ
	.word	DUNKR2_SEQ
	.word	DUNKU2_SEQ
	.word	DUNKU3_SEQ
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

	movk	NUMPLYRS,a7

	move	*a8(OXPOS),a4
	move	*a8(OXANI+16),a14


	move	*a8(OSIZEX),a6
	srl	1,a6
	add	a6,a4
	sra	1,a14
	add	a14,a4			;A4=Center X



	move	*a8(OZPOS),a6		;A6=Z
	movi	plyrobj_t,a5

; Select Z-range for plyr collision per ball altitude/speed
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

	move	a14,a3
	srl	2,a3
	sub	a3,a14

	sub	a14,a1
	cmp	a1,a4
	jrle	#nxt			;Center X <= lft?

	sll	1,a14

;	move	a14,a3
;	srl	2,a3
;	add	a3,a14

	add	a14,a1
	cmp	a1,a4
	jrge	#nxt			;Center X >= rgt?

	move	*a11(OYPOS),a1
	move	*a8(OYPOS),a0
	addk	3,a0
	move	*a13(plyr_seq),a14
	cmpi	RUNDRIBTURB_SEQ,a14
	jrhi	#handhi			;Hand higher than shoulder?

	move	*a11(OPLINK),a14,L
	move	*a14(plyr_attrib_p),a14,L
	move	*a14(PAT_DEFSKILL),a14
	sll	4,a14
	addi	tbl3,a14
	move	*a14,a14
	add	a14,a0


;TBL3 should get larger as def skill improves
;FIX!!
;DEBUG!
;	addk	10,a0		;Take out


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
;	.word	0,0,0,0,0,0,0,0,0,0,0,50/2,100/2,150/2,300/2,400/2
;	.word	500/2,600/2,700/2,800/2,999/2,999/2

;	.word	0,0,0,0,0,0,0,0,0,0,0,100,200,300,600,800
;	.word	999,999,999,999,999,999

	.word	0,0,0,0,0,0,0,100,130,170,200,300,400,600,800,800
	.word	999,999,999,999,999,999

#guydunking
;Guy with ball is dunking!
	PUSH	a0,a1

	move	*a14(plyr_num),a0
	move	@pup_maxpower,a1
	btst	a0,a1
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
	cmpi	4,a14
	jrle	#nxt0z				;3 power can't take ball!

;Cut blocked dunks in half!
	move	@HCOUNT,a1
	btst	0,a1
	jrz	#nxt0z

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

;FIX!!
;TWEAK this z-rng
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


	move	*a3(plyr_num),a0
	move	@plyr_onfire,a1
;;	cmp	a0,a1
;;	jrz	#noow			;If on fire, don't miss as often
	btst	a0,a1
	jrnz	#noow			;If on fire, don't miss as often

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
	move	@plyr_onfire,a1
;;	cmp	a0,a1
;;	jrz	#nogt
	btst	a0,a1			;Blocker on-fire?
	jrnz	#nogt			; br=yes, allow goaltend

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
;	movk	6,a0
;	calla	rnd
;	jrnz	#nxt

	move	*a3(plyr_num),a0
	move	@plyr_onfire,a1
	btst	a0,a1
	jrnz	#do_gt


;This was throwing away most blocks if it were to be a goal tend!
;Took out 4/5/96 - 2 days before shipping...  Genius!
;	movk	6,a0
	movk	5,a0
	calla	rnd
	jrnz	#nxt

#do_gt

	
	move	@plyrairballoff,a0
	jrn	#nogt
	move	@shot_percentage,a0
	jrn	#nogt
	

	move	*a3(plyr_num),a0
	.ref	pup_goaltend
	move	@pup_goaltend,a14
	btst	a0,a14			;Plyr arrow-off bit set?
	jrz	#nosec1			;br=no goaltending allowed
;	sll	4,a0 			;Secret goaltend
;	.ref	p1taps
;	addi	p1taps,a0
;	move	*a0,a0
;	cmpi	24,a0
;	jrnz	#nosec1

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

	SOUND1	steal_snd
	PUSH	a7,a10
	move	a3,a10
	calla	arw_on1plyr		;Guy who picks up ball gets arw
	PULL	a7,a10

#skipgt

	callr	flash_ball
;	SOUND1	cheer_snd
	SOUND1	swat_snd
;	callr	get_swat

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

	SOUND1	stealsb
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
	move	a0,@ballbbhitcnt

	move	@inbound,a0
	jrnn	#skiprbnd

;Player touches ball for a rebound, it attaches to one hand.
;As soon as player touches ball, slam hands together for
;a more dramatic looking rebound
	move	*a3(PA10),a14
	cmpi	100,a14
	jrgt	#landing
	movk	1,a0
	move	a0,*a3(PA10)
#landing


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
;After grabbing rebound, don't allow stolen rebound!
;5% of time, allow stolen rebound after 15 ticks!  (That was old game)
	movk	15,a2
	movi	50,a0
	calla	RNDPER
	jrhi	#reg
	movi	40,a2
#reg	move	a2,a0
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
	cmpi	FASTBLOCKREJ_SEQ,a2
	jreq	#rej
	subk	BLOCKREJ_SEQ,a2
	jreq	#rej

	movk	3,a0			;>Regular block
	callr	rnd

;This is for a block dunk, but if a player jumps in front of a pass
;this code is also executed.  And ball has a chance of bouncing back at
;full speed toward passer!

	jrnz	#glance_off

	SOUND1	steal_snd
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

;	movi	-GRAV*22,a1		;Towards roof
	movi	-GRAV*20,a1		;Towards roof

	move	a1,*a8(OYVEL),L

;New, 1/22/93
	move	@PCNT,a0
	ANDK	7,a0
	jrnz	#x

	movk	25,a0
	move	a0,*a3(plyr_shtdly)
;dunk rejected speech here! (plyr doesn't have ball though)
;(Why is this being called, if plyr doesn't keep ball, its not rejected!!)
;FIX!!!
;	calla	rejected_dnk_speech
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
	move	@must_rebound,a0
	jrz	#cont
	move	*a3(plyr_seq),a0
	cmpi	BLOCK_SEQ,a0
	jrz	#rej1
	cmpi	BLOCKREJ_SEQ,a0
	jrz	#rej1
	cmpi	FASTBLOCKREJ_SEQ,a0
	jrnz	#cont
#rej1
	move	*a3(plyr_ohpdist),a14
	cmpi	55,a14
	jrgt	#cont0

;Still allow slap of ball if it is right on the rim (approx.)
	.if	DEBUG
	LOCKUP
	.endif

	jruc	#cont

#cont0
;Could also check my proximity to floor...
	move	*a3(plyr_jmpcnt),a14
	jrnz	#convert_rej		;Br=I was trying to swat a rebound!
#cont

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

;	cmpi	STEALUP_SEQ,a0
;	jreq	#doit
	subi	STEAL_SEQ,a0
	jrne	#nxt
;#doit


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
	move	@my_ballpnumlast,a1
	jrn	#noown
	movk	PS_TURNOVERS,a0
	calla	inc_player_stat
#noown
	move	*a3(plyr_attrib_p),a0,L
	move	*a0(PAT_STLSKILL),a0
	sll	4,a0
	addi	stl2,a0
	move	*a0,a0
;	movi	180,a0

	calla	RNDPER
	jrhi	#giveballflsh		;20% give him the ball?
;FIXX!!!
;Debug - don't have ball skip away on steal!
;	jruc	#giveballflsh	;temp

;	movk	15,a0			;>Knock it away
	movk	20,a0			;>Knock it away
	move	a0,*a2(plyr_shtdly)
	move	a0,*a3(plyr_shtdly)

	callr	loose_ball
	SOUND1	swat_snd
;	callr	get_swat
	jruc	#nxt

 SUBR	loose_ball

	clr	a0
	move	a0,@ballbbhitcnt
	not	a0			;=-1
	move	a0,@ballpnum
	move	a0,@ballpnumlast
	callr	ball_convfmprel		;was rel2

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

	movi	50,a0
	calla	RNDPER
	jrls	#noy
	movi	40000h,a0
	calla	rndrng0
	move	*a8(OYVEL),a1,L
	sub	a0,a1
	move	a1,*a8(OYVEL),L
#noy

	callr	flash_ball
	.ref	ball_loose_spch
	PUSH	a7	
	CREATE0	ball_loose_spch
	PULL	a7	

	rets


	.asg	75/100,lo_stl		;85,77
;This is for stealing ball
stl1	.word	160*lo_stl,170*lo_stl,180*lo_stl,195*lo_stl,200*lo_stl
	.word	205*lo_stl,215*lo_stl,245*lo_stl,260*lo_stl,285*lo_stl
	.word	300*lo_stl

;stl1	.word	160*lo_stl,165*lo_stl,170*lo_stl,175*lo_stl,180*lo_stl
;	.word	185*lo_stl,190*lo_stl,195*lo_stl,200*lo_stl,202*lo_stl
;	.word	204*lo_stl
;This is for sticking to ball after a successfull steal
;Otherwise, ball will dribble away!

stl2	.word	160,170,180,195,200
	.word	205,215,225,230,235
	.word	250


#giveballflsh

;steals ball speech (ball sticks to player)
	calla	stolen_speech

	callr	flash_ball
	SOUND1	swat_snd
;	callr	get_swat
;	SOUND1	cheer_snd
;FIXX!!!
;Debug - don't have ball skip away on steal!
;	jruc	#nxt	;temp for checking distance for steals

;	movk	30,a0
	movi	40,a0
	move	a0,@steals_off
	movk	25,a0
	move	a0,@pass_off
	movi	80,a0
	move	a0,@pushing_delay


#giveball
;Pick up ball bug....  If @ballprcv_p has a value, intercept style collisions
;occur, so rarely can you pick up the ball....
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

;	movi	150,a14			;Secret steal power!
	movi	50,a14			;Secret steal power!
	move	*a3(plyr_num),a6
	.ref	pup_maxsteal
	move	@pup_maxsteal,a4
	btst	a6,a4
	jrnz	#normint

	sll	4,a1
	addi	#int_t,a1
	move	*a1,a14

#normint

;Let's see if this pass is intended for an alley ooper!
;If so, do more intercepts!
	move	@ballprcv_p,a1,L	;*Plyr proc who gets this pass or 0
	jrz	#nxtck
	move	*a1(plyr_jmpcnt),a4
	jrz	#nxtck
	move	*a1(plyr_seq),a1
	cmpi	ALLEYOOP1_SEQ,a1
	jrlt	#nxtck
	cmpi	ALLEYOOP14_SEQ,a1
	jrgt	#nxtck
;More intercepts if alley oop...
	addi	25,a14			;Alley oop steal power!
#nxtck

	move	@ballpasstime,a1
	subk	3,a1
	abs	a1
	srl	1,a1			;/2
	add	a14,a1
	addk	1,a1			;1% to 100%
	cmp	a1,a0
	jrge	#nxt			;% failed?

;Still too many steals

;Bumped this up because we still had too many intercepted passes...
;	movi	500,a0			;650 ,450
;TRIED new value
;	movi	750,a0
	movi	850,a0
	calla	RNDPER
	jrhi	#nxt			;br=yes skip it

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

;;	clr	a14			;Intercepted
;
; Just set it to 1 so plyr_main, etc., can take care of the rest
	movk	1,a14			;Intercepted
	move	a14,*a2(plyr_rcvpass)
;;	move	*a2(plyr_jmpcnt),a0
;;	jrnz	#inair			;Jumping?
;;	move	a14,*a2(plyr_nojoy)
;;#inair


;Shawn, Sometimes the ball can be intercepted and you do not fall thru
;this ball flash, etc. code (Below).  I moved the flash/snd stuff up
;in front of the code which checks if ball has already been caught, but then
;when an errant pass is picked up, it does the flash stuff.

	callr	def_play_reward		;Good defensive play reward

;	movi	50,a0			;4% of intercepts are just deflects
	movi	40,a0			;4% of intercepts are just deflects
	calla	RNDPER
	jrls	#nope

;Sometimes, just have ball bounce off the defender

	SOUND1	intercept

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
	move	@my_ballpnumlast,a1
	jrn	#x
	movk	PS_TURNOVERS,a0
	calla	inc_player_stat
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
	move	@my_ballpnumlast,a1
	jrn	#noown2
	movk	PS_TURNOVERS,a0
	calla	inc_player_stat
#noown2
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
	move	a0,@ballbbhitcnt
	

;Player is jumping up with standard 1 handed block frms, if he is going to
;attach to ball, then lets jump into spear seq. which looks like a strong
;2 handed grab.  Rebound art basically...

;	.ref	w1blokl3
;	.ref	w1blokl4
;	.ref	w2blokl3
;	.ref	w2blokl4
;	.ref	w3blokl3
;	.ref	w3blokl4
;	.ref	w4blokl3
;	.ref	w4blokl4
;	.ref	w5blokl3
;
;;Player spearing the ball?
;	move	*a11(OIMG),a0,L
;	cmpi	w1blokl3,a0
;	jrz	#convert_rej
;	cmpi	w1blokl4,a0
;	jrz	#convert_rej
;	cmpi	w2blokl3,a0
;	jrz	#convert_rej
;	cmpi	w2blokl4,a0
;	jrz	#convert_rej
;	cmpi	w3blokl3,a0
;	jrz	#convert_rej
;	cmpi	w3blokl4,a0
;	jrz	#convert_rej
;	cmpi	w4blokl3,a0
;	jrz	#convert_rej
;	cmpi	w4blokl4,a0
;	jrz	#convert_rej
;	cmpi	w5blokl3,a0
;	jrz	#convert_rej
;	cmpi	w5blokl4,a0
;	jrz	#convert_rej
	.ref	w1blokl1
	.ref	w5blokl4

;	move	@must_rebound,a0
;	jrnz	#convert_rej0		;Br=I was trying to stab a rebound!

;Player spearing the ball?
	move	*a11(OIMG),a0,L
	cmpi	w1blokl1,a0
	jrlt	#tagx
	cmpi	w5blokl4,a0
	jrgt	#tagx
	jruc	#convert_rej

#tagx
	move	@must_rebound,a0
	jrz	#x

#convert_rej0
	move	*a3(plyr_seq),a0
	cmpi	BLOCK_SEQ,a0
	jrz	#rej1a
	cmpi	BLOCKREJ_SEQ,a0
	jrz	#rej1a
	cmpi	FASTBLOCKREJ_SEQ,a0
	jrnz	#x
#rej1a

;Could also check my proximity to floor...
	move	*a3(plyr_jmpcnt),a14
	jrz	#x

#convert_rej

;	LOCKUP

	movk	NOSPEAR_SEQ,a0
;This sequence is simply a two handed rebound
	move	*a3(plyr_dir),a7
	PUSH	a13
	move	a3,a13
	calla	plyr_setseq
	movk	1,a0
	move	a0,*a13(PA10),L
	PULL	a13

	clr	a0
	move	a0,@ballgoaltcnt

	move	*a3(plyr_num),a14
	move	a14,@ballpnum
	clr	a0
	move	a0,*a3(plyr_dribmode)	;Reset dribble
	move	a0,@ballbbhitcnt
	movi	80,a0
	move	a0,@pushing_delay
	movi	15,a0
	calla	plyr_setshtdly
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

tbl1	.word	16+2,17+2,18+2,18+2,18+2,18+2,18+2,19+2,20+2,21+2,22+2,23+2
;tbl1	.word	18,18,18,18,18,18,18,18,18,18,18,18
tbl2	.word	32,33,34,35,35,35,35,36,37,38,39,40
;tbl2	.word	35,35,35,35,35,35,35,35,35,35,35,35
tbl3	.word	15,15,15,15,15,15,15,15,15,15,15,15

tbl4	.word	11*DIST_ADDITION+2,12*DIST_ADDITION+2,12*DIST_ADDITION+2
	.word	12*DIST_ADDITION+2,12*DIST_ADDITION+2,12*DIST_ADDITION+2
	.word	12*DIST_ADDITION+2,13*DIST_ADDITION+2,14*DIST_ADDITION+2
	.word	15*DIST_ADDITION+2,16*DIST_ADDITION+2,17*DIST_ADDITION+2

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
;Don't have so many interceptions for losing teams
	.word	0,3,5,6,8,9,10,11,12,12
	.word	12,13,14,15,17,19

;	.word	0,4,7,10,12,15,19,20,20,20
;	.word	20,20,22,25,27,30


********************************
* Random swat sound

; SUBR	get_swat
;	SOUND1	swat_snd
;	rets


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

	SOUND1	steal_snd
	SOUND1	swat_snd
;	callr	get_swat

	PUSH	a7,a10
	move	a3,a10
	calla	arw_on1plyr		;Guy who picks up ball gets arw
	PULL	a7,a10

	rets


 SUBR	flash_reward

	callr	flash_ball
;	SOUND1	cheer_snd
	SOUND1	swat_snd
;	callr	get_swat
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

	move	@HCOUNT,a14
	btst	0,a14
	jrz	#die2
	SOUND1	cheer_snd
#die2	
	DIE


#*******************************
* Jump shot crowd sounds (process)

 SUBR	plyr_jscrowdsnd

	SLEEPK	10
	
	movk	10,a0
	calla	rndrng0
	move	a0,a8
	sll	5,a8
	addi	#crwd_noise_sp_tbl,a8
	move	*a8,a0,L
	calla	snd_play1
	DIE


#crwd_noise_sp_tbl
	.long	cheer3_snd
	.long	cheer2_snd
	.long	cheer1_snd
	.long	cheer2_snd
	.long	cheer3_snd
	.long	cheer_snd
	.long	cheer1_snd
	.long	cheer2_snd
	.long	cheer_snd
	.long	cheer2_snd
	.long	cheer2_snd


#*******************************
* Convert ball from player relative
* Trashes scratch

 SUBR	ball_convfmprel

;	move	@ballobj_p,a0,L
;
;	move	*a0(OIMG),a1,L		;Get ball ani X
;	move	*a1(IANIOFFX),a1
;	sll	16,a1
;	move	*a0(OXANI),a14,L	;Get ball/plyr ani X combo &
;	move	a1,*a0(OXANI),L		; make new ani X ball only
;	sub	a14,a1
;
;	move	*a0(OZPOS),a14		;Do Z proj on old/new ani X diff
;	PRJX2Z	a1,a14,16-1		;(16-1)=*64k/2
;
;	move	*a0(OXVAL),a14,L	;Adjust ball X by proj'd amount to
;	sub	a1,a14			; make ball not jerk when released
;	move	a14,*a0(OXVAL),L
;
	move	@ballobj_p,a0,L

 SUBR	convfmprel
	move	*a0(OXANI),a1,L		;Get ball ani X
	move	*a0(OZPOS),a14		;Do Z proj on old ani X
	PRJX2Z	a1,a14,16-2

	move	*a0(OXVAL),a14,L	;Adjust ball X by proj'd amount to
	add	a1,a14			; make ball not jerk when released
	move	a14,*a0(OXVAL),L

	clr	a14
	move	a14,*a0(OXANI),L

	rets


#*******************************
* Set ptsdown for each plyr
* Trashes scratch

	.ref	pup_noassistance

 SUBR	plyr_setptsdown

	PUSH	a2,a3,a4,a5,a6

	movi	scores,a14
	move	*a14+,a0
	move	*a14+,a4
	sub	a0,a4			;+ if losing, - if winning

	move	@PSTATUS,a5

	movi	plyrproc_t,a6
	movk	NUMPLYRS,a3
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

	move	@pup_noassistance,a0
	jrnz	#noset

	movk	ADJCOMPASS,a0		;Computer assistance
	calla	GET_ADJ			;0-1
	jrz	#set			;On?
#noset
	clr	a2
#set
	move	*a6+,a0,L
	move	a2,*a0(plyr_ptsdown)

	.if DRONES_2MORE
	LOCKUP
	.else
	cmpi	NUMPLYRS-1,a3
	jrne	#nxt
	neg	a4
	.endif

#nxt	dsj	a3,#lp

	PULL	a2,a3,a4,a5,a6
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

#*****************************************
*
* A13=*PxCTRL
* RETURNS: carry clear if player under hoop
*
 SUBR	chck_plyr_under_hoop
	
	PUSH	a0,a1
	move	*a13(plyr_seqdir),a1

	move	*a8(OXPOS),a0
	move	*a8(OZPOS),a1

	move	*a13(plyr_num),a14
	srl	1,a14
	jrz	#tm1				;br=team 1, right hoop
	cmpi	HOOPLX-16,a0
	jrhs	#nsq0				;br=player not behind hoop
	cmpi	CZMID-150,a1
	jrlo	#nsq0				;br=player not under hoop
	cmpi	CZMID+125,a1
	jrgt	#nsq0				;br=player not under hoop
	jruc	#nsq1
#tm1
	cmpi	HOOPRX-35,a0
	jrls	#nsq0				;br=player not behind hoop
	cmpi	CZMID-150,a1
	jrlo	#nsq0				;br=player not under hoop
	cmpi	CZMID+125,a1
	jrgt	#nsq0				;br=player not under hoop
	jruc	#nsq1

#nsq0	clrc	
	jruc	#nsq2
#nsq1
	setc

#nsq2
	PULL	a0,a1
	rets

#*****************************************
* Sequence - adjust players X,Y, and/or Z
*
* A8=*plyr obj
* A13=*PxCTRL
* B4=*Next data in seq list

 SUBR	seq_shadow_trail

	PUSH	a10,a11
	move	*b4+,b0,L			;create RATE and delete rate
	move	b0,a10

	move	*a13(plyr_headobj_p),a11,L
	CREATE	TRAIL_HNDLR_PID,plr_trail_proc_disbatcher

	PULL	a10,a11
	rets


#*****************************************************************************
*	This PROCESS handles the disbatching of process for the player trail
*
* INPUT:  reg a8 - * plyr obj
*        reg a10 - rate and delete time
*        reg a11 - * plyr head obj
*
******************************************************************************
 SUBRP	plr_trail_proc_disbatcher
 
ptp_0	movy	a10,a9			;get create RATE
	srl	16,a9
ptp_1	SLEEPK	1
	dsj	a9,ptp_1
	CREATE	PLYR_TRAIL_OBJ_PID,plyr_trail
	jruc	ptp_0

******************************************************************************
*	This PROCESS creates a copy of the image at X rate and delete it
*
* INPUT:  reg a8 - * plyr obj
*        reg a10 - rate and delete time
*        reg a11 - * plyr head obj
******************************************************************************
 SUBRP	plyr_trail
     
;player body	
 	clr	a0
	clr	a1
	move	*a8(OIMG),a2,L
	clr	a3
	move	*a8(OFLAGS),a4
	movi	PLR_TRAIL_ID,a5
	clr	a6			;x vel
	clr	a7			;y vel
	move	a8,a9
	calla	BEGINOBJ
;	calla	BEGINOBJP

	move	*a9(OXVAL),a14,L
	move	a14,*a8(OXVAL),L
	move	*a9(OYVAL),a14,L
	move	a14,*a8(OYVAL),L
	move	*a9(OZVAL),a14,L
	subi	8<<16,a14			;force shadow under plyr
	move	a14,*a8(OZVAL),L

	move	*a9(OXANI),a14,L
	move	a14,*a8(OXANI),L
	move	*a9(OCTRL),a14
	ori	M_NOCOLL,a14
	move	a14,*a8(OCTRL)
	move	*a9(ODATA_p),a14,L
	move	a14,*a8(ODATA_p),L

	move	a8,a9				;save plyr obj ptr

;player head

	move	*a11(OIMG),a2,L
	move	*a11(OFLAGS),a4
	movi	PLR_TRAIL_ID,a5
 	clr	a0			;x
	clr	a1			;y
	clr	a3			;z
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ

	
	move	*a11(OPAL),a14
	move	a14,*a8(OPAL)
	move	*a11(OXVAL),a14,L
	move	a14,*a8(OXVAL),L
	move	*a11(OYVAL),a14,L
	move	a14,*a8(OYVAL),L
	move	*a11(OZVAL),a14,L
	subi	8<<16,a14			;force shadow under plyr
	move	a14,*a8(OZVAL),L

	move	*a11(OXANI),a14,L
	move	a14,*a8(OXANI),L
	move	*a11(OCTRL),a14
	ori	M_NOCOLL,a14
	move	a14,*a8(OCTRL)
	move	*a11(ODATA_p),a14,L
	move	a14,*a8(ODATA_p),L

	clr	a11
	movx	a10,a11
pt_1
	SLEEPK	1
	move	*a9(OZPOS),a14			;player body Z
	dec	a14
	move	a14,*a8(OZPOS)
	move	a14,*a9(OZPOS)
	dsj	a11,pt_1

	calla	DELOBJA8		;delete player body
	move	a9,a8
	calla	DELOBJA8		;delete player head
	DIE

#*****************************************
* Sequence - adjust players X,Y, and/or Z
*
* A13=*PxCTRL
* B4=*Next data in seq list

 SUBR	seq_allow_alleyoop
 	
	clr	a14
	move	a14,*a13(plyr_inair_pass)
 	rets
 	
#*****************************************
* Sequence - adjust players X,Y, and/or Z
*
* A13=*PxCTRL
* B4=*Next data in seq list

  SUBR	seq_disallow_alleyoop
 	
	clr	a14
	not	a14
	move	a14,*a13(plyr_inair_pass)
 	rets

#*****************************************
* Sequence - adjust players X,Y, and/or Z
*
* A11=*PxCTRL
* B4=*Next data in seq list

 SUBR	seq_offset

	move	*b4+,b0				;get X offset
	move	b0,a0
	move	*a8(OXPOS),a14

	move	*a8(OCTRL),a1,W
	btst	B_FLIPH,a1
	jrz	#sx			;No flip?
	neg	a0
#sx	add	a0,a14
	move	a14,*a8(OXPOS)

	move	*b4+,b0				;get Y offset
	move	b0,a0
	move	*a8(OYPOS),a14
	add	a0,a14
	move	a14,*a8(OYPOS)

	move	*b4+,b0				;get Z offset
	move	b0,a0
	movi	CZMID,a14
;	move	*a8(OZPOS),a14
	add	a0,a14
	move	a14,*a8(OZPOS)
	rets

#*****************************************
* Sequence - adjust players X,Y, and/or Z
* Set a flag that says "I have already been offset" for FLYBACKS
*
* A11=*PxCTRL
* B4=*Next data in seq list

 SUBR	seq_offset2

	move	*a13(plyr_offset_flag),a14
	jrz	#cont
	addi	48,b4
	rets
#cont	movk	1,a14
	move	a14,*a13(plyr_offset_flag)
	move	*b4+,b0				;get X offset
	move	b0,a0
	move	*a8(OXPOS),a14

	move	*a8(OCTRL),a1,W
	btst	B_FLIPH,a1
	jrz	#sx			;No flip?
	neg	a0
#sx	add	a0,a14
	move	a14,*a8(OXPOS)

	move	*b4+,b0				;get Y offset
	move	b0,a0
	move	*a8(OYPOS),a14
	add	a0,a14
	move	a14,*a8(OYPOS)

	move	*b4+,b0				;get Z offset
	move	b0,a0
;	movi	CZMID,a14
	move	*a8(OZPOS),a14
	add	a0,a14
	move	a14,*a8(OZPOS)
	rets


********************************
* Sequence - stand
* A11=*PxCTRL
* >B4=*Start of seq list

 SUBR	seq_stand
;trying to stop a player in a DISH_OFF seq. receiving pass, dont allow
;joystick if pass on the way
;
	move	@ballprcv_p,a14,L
	cmp	a14,a13
	jreq  	stnd1
	move	*a13(plyr_nojoy),a14
	jrn	stnd1
	move	*a13(plyr_rcvpass),a14
	jrnz	stnd1
	clr	a0
	move	a0,*a13(plyr_nojoy)
stnd1


;Make this STND_SEQ if in close
	movk	STND2_SEQ,a0		;Set stand sequence

	move	*a13(plyr_o1dist),a14
	cmpi	155*DIST_REDUCTION,a14
	jrlt	#stnd0
	move	*a13(plyr_o2dist),a14
	cmpi	155*DIST_REDUCTION,a14
	jrgt	#stnd1
#stnd0
	movk	STND_SEQ,a0
#stnd1


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
	cmpi	60*DIST_REDUCTION,a0
	jrge	#chko2			;Too far?
	subi	30*DIST_REDUCTION,a0
	jrlt	#doelbo			;In close?
	move	*a4(plyr_seq),a14


;	cmpi	STEALUP_SEQ,a14
;	jreq	#doelbo


	subi	STEAL_SEQ,a14
	jreq	#doelbo
	subk	PUSH_SEQ-STEAL_SEQ,a14
	jreq	#doelbo
#chko2
	move	*a13(plyr_o2dist),a0
	cmpi	60*DIST_REDUCTION,a0
	jrge	#stndwb			;Too far?
	subi	30*DIST_REDUCTION,a0
	jrlt	#doelbo			;In close?
	move	*a5(plyr_seq),a14


;	cmpi	STEALUP_SEQ,a14
;	jreq	#doelbo


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


#stndwb
	movk	STNDWB_SEQ,a0
	move	*a13(plyr_seq),a14
	cmpi	ELBO2_SEQ,a14
	jrne	#set
	movk	STNDWB2_SEQ,a0	        ;stops glitch from elbo swing to stand
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
* Sequence - Check turbo button from mid run
* B4=*Next data in seq list

 SUBR	seq_ck_turbo

	movk	RUN_SEQ,a0		;>Setup run sequence

	move	*a13(plyr_turbon),a14
	jrz	#cont

;Skip next frame of animation + next seq_command
	addi	112,b4
	movk	RUNTURB_SEQ,a0		;>Setup run sequence
#cont
	move	a0,*a13(plyr_seq)
	rets

#*******************************
* Sequence - Check turbo button from mid run
* B4=*Next data in seq list

 SUBR	seq_ck_drib_turbo

	movk	RUNDRIB_SEQ,a0		;>Setup run sequence

	move	*a13(plyr_turbon),a14
	jrz	#cont

;Skip next frame of animation + next seq_command
	addi	112,b4
	movk	RUNDRIBTURB_SEQ,a0		;>Setup run sequence
#cont
	move	a0,*a13(plyr_seq)
	rets



#*******************************
* Sequence - Skip 1 frame of animation
* B4=*Next data in seq list

 SUBR	seq_skip_1frm

	addi	64,b4
	rets



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

; SUBR	seq_strtfire
;
;;WORD	plyr_keeppal	;Keep pal for reuse upon finish of flames
;
;	move	*a13(plyr_keeppal),a0
;	jrnz	#x
;	move	*a8(OPAL),a0
;	move	a0,*a13(plyr_keeppal)
;	movi	FIREFALP,a0
;	calla	pal_getf
;	move	a0,*a8(OPAL)
;;Do head also
;	move	*a13(plyr_headobj_p),a1,L
;	move	*a1(OPAL),a14
;	move	a14,*a13(plyr_hdkeeppal)
;	move	a0,*a1(OPAL)
;#x
;	rets

#*******************************
* Sequence - Change back from fire pal

; SUBR	seq_stopfire
;
;	move	*a13(plyr_keeppal),a0
;	jrz	#x
;	move	a0,*a8(OPAL)
;;Do head also
;	move	*a13(plyr_hdkeeppal),a0
;	move	*a13(plyr_headobj_p),a1,L
;	move	a0,*a1(OPAL)
;	clr	a0
;	move	a0,*a13(plyr_keeppal)
;#x
;	rets

#*******************************
* Sequence - Start smoke

; SUBR	seq_smoke
;
;	.ref	plyr_smoketrail2
;	CREATE0	plyr_smoketrail2
;	move	a13,*a0(PA10),L
;
;	rets


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

;Used to skip 1st frame for sequential #3 run!

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
	.ref	head_fake_speech
	calla	head_fake_speech
	jruc	seq_stand		;Fake?


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
	move	@plyr_onfire,a0
;;	cmp	a0,a14
;;	jrnz	#fire1			;If on fire, don't do turbo jump!
	btst	a14,a0			;If on fire, don't do turbo jump!
	jrz	#fire1			; br=not on-fire
	clr	a5
	jruc	#fire
#fire1

	move	*a13(plyr_PDATA_p),a1,L	;If lotsa turbo, still do tall jump!
	move	*a1(ply_turbo),a1
;	cmpi	TURBO_CNT/2,a1		;!!! Min cnt for tall jump
;Allow more turbo jumps...
	cmpi	TURBO_CNT/4,a1		;!!! Min cnt for tall jump
	jrlt	#fire			;Turbo too low?

	move	*a13(plyr_turbon),a5
	jrnz	#turb			;Br=taller jump!
;#fire
	sra	1,a2
	sra	1,a3
;LOOK!!!
#fire
#turb



;Keep - may need this on some desperation shot!
;	move	*a13(plyr_seq),a0
;	subk	SHOOTDESP3_SEQ,a0
;	jrne	#nodesp
;	movi	>20000,a2		;For this desperation shot, we
;	move	*a13(plyr_num),a0	;need some x velocity
;	subk	2,a0
;	jrlt	#nodesp
;	movi	->20000,a2


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

	move	*a13(plyr_num),a14
	move	@plyr_onfire,a0
;;	cmp	a14,a0
;;	jrnz	#nofire
	btst	a14,a0
	jrz	#nofire

;Try turning on fire circles under player
;If on defense, don't do fire circles.
	move	@ballpnum,a0
	cmp	a14,a0
	jrnz	#nofire

	move	@tvpanelon,a0,L
	jrnz	#nofire

	.ref	fire_circle
	CREATE0	fire_circle
	move	a13,*a0(PA10),L

#nofire

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

#float_at_hp
	move	a0,a6			;>Jump at rim
	move	a1,a7
	movi	-200<<16,a9
	addk	6,a6
	cmpi	WRLDMID,a6
	jrlt	#calcintercept
	subk	6+6,a6
	jruc	#calcintercept

#nodunk
;Check teammate of guy holding ball to see if he is alley oop jumping!
	move	@ballpnum,a14
	xori	1,a14

	sll	5,a14
	addi	plyrproc_t,a14
	move	*a14,a14,L
	move	*a14(plyr_seqflgs),a2
	btst	DUNK_B,a2
	jrz	#nodunk2
;Yes, he is alley oop jumping.
;If near him, jump up and float toward my hoop - just like if I were trying
;to block a dunker with the ball.

;If near guy with the ball, just jump straight up in front of him.
	move	*a13(plyr_balldist),a2
	cmpi	>40,a2			;About 3 feet away from ball

	jrgt	#float_at_hp		;this guy wants to jump up and
					;disrupt the alley oop jumper!
	PULL	a6,a7,a9
	addk	32,b4			;Skip
	jruc	seq_jump2

#nodunk2
	move	*a13(plyr_seq),a14
	subk	BLOCK_SEQ,a14
	jrne	#noblk
	addk	32,b4			;Skip

	PULL	a6,a7,a9

;If not near ball, jump lower and ignore turbo jump!

	move	*a13(plyr_balldist),a0
	cmpi	>e0*DIST_REDUCTION,a0	;About 10 feet away from ball
;	cmpi	>100*DIST_REDUCTION,a0	;About 10 feet away from ball
	jrlt	seq_jump2

;If near my own hoop, I am probably trying to G.T.!  So allow high jump!
	move	@ballshotinair,a0	;Shooter # if shot in air, else -1
	jrn	#cont
	move	*a13(plyr_hpdist),a0
	cmpi	70,a0			;About 3 feet away from my hoop
	jrlt	seq_jump2
#cont
	movk	1,a0			;Start jump
	move	a0,*a13(plyr_jmpcnt)

	clr	a0
	move	a0,*a8(OXVEL),L		;Zero vel
	move	a0,*a8(OZVEL),L

;LOOK!!!
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

;Time till impact?
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

;Very important!  Maximum x/z float for defender blocks/rebounds
;Should be linked to attribute!
	movk	30,a1			;Max delta (Old)
;	movi	40,a1			;Max delta
	move	*a13(plyr_seq),a14
	subk	REBOUND_SEQ,a14
	jrne	#noreb
;Fly further if rebound art sequence
	addk	32,a1
;	addk	20,a1	;TE value
;	addk	10,a1

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
;PUTBACK logic
;	move	*a13(plyr_seq),a1
;	cmpi	PUTBACK_SEQ,a1
;	jrne	#noput
;	clr	a3			;no drift toward ball
;	clr	a5			;no drift toward ball
;	move	a3,*a8(OXVEL),L
;	move	a5,*a8(OZVEL),L
;	movi	->33000,a1
;	move	a1,*a8(OYVEL),L
;	jruc	#x
;#noput

	move	*a13(plyr_num),a14
	.ref	pup_nodrift
	move	@pup_nodrift,a1
	btst	a14,a1
	jrz	#dodrift
	clr	a3
	clr	a5
#dodrift

	move	a3,*a8(OXVEL),L
	move	a5,*a8(OZVEL),L

	movi	-GRAV/2,a1
	mpys	a4,a1
	move	*a8(OYVAL),a3,L		;Adjust for hgt difference
	sub	a9,a3			;- if above
	divs	a4,a3
	sub	a3,a1
;Bug?  Code usually has to use minimum allowed vel.
;Mimimum jumping height!

	move	@ballgoaltcnt,a14	;Not owned. Is it a shot or loose?
	jrnz	#shot
;This is rebound time

	cmpi	->1c000,a1
	jrlt	#minok
	movi	->1c000,a1		;Min
	jruc	#minok
#shot

	move	*a13(plyr_num),a14
	move	@plyr_onfire,a6
	btst	a14,a6
	jrz	#norm
;Guy is on fire, trying to block a shot, make minimum jump go higher!
	cmpi	->4c000,a1
	jrlt	#minok
	movi	->4c000,a1		;Min
	jruc	#minok
#norm


	cmpi	->3c000,a1
	jrlt	#minok
	movi	->3c000,a1		;Min
#minok

	move	*a13(plyr_num),a14
	move	@plyr_onfire,a6
;;	cmp	a14,a6
;;	jrnz	#nofire
	btst	a14,a6
	jrz	#nofire

;This guy on fire, let him jump higher!
;	cmpi	->50200,a1		;T.E.
;	cmpi	->52200,a1		;Old hangtime
;	cmpi	->58200,a1		;Cool value
	cmpi	->54200,a1		;Current value
	jrgt	#maxok
	movi	->54200,a1
	jruc	#maxok

#nofire
;Maximum jumping height!
;FIX!!  Should be linked to attribute!
;	cmpi	->4b200,a1		;4a200
;	jrgt	#maxok
;	movi	->4b200,a1

	move	*a13(plyr_num),a6
;This is tied in with super blocks for create a player or powerup!!
	.ref	blkpower
	move	@blkpower,a14
	btst	a6,a14
	jrz	#norm1
;FIX!!
	jruc	#norm1		;Temp!

;Powerup blocking ability
	cmpi	->50000,a1		;Let him jump higher
	jrgt	#maxok
	movi	->50000,a1
	jruc	#maxok
#norm1
	move	*a13(plyr_ptsdown),a14
	jrgt	#losing			;If losing, jump higher
;	cmpi	->4b200,a1		;Let him jump higher
	cmpi	->4b400,a1		;Let him jump higher
	jrgt	#maxok
	movi	->4b400,a1
	jruc	#maxok
#losing
	cmpi	->4b700,a1		;Let him jump higher
	jrgt	#maxok
	movi	->4b700,a1
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

	move	a4,*a13(plyr_slam_ticks)
	movk	1,a0			;Start jump
	move	a0,*a13(plyr_jmpcnt)


	move	*a13(plyr_ohoopx),a3

	move	*a2(IANIOFFX),a1
	move	*a2(IANI2X),a14
	sub	a14,a1
;	movi	850,a0
	movi	900,a0
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
	movi	10,a0			;2% do bogus snd
	calla	RNDPER
	jrls	#nosnd	
	movk	1,a10
#nosnd	
	move	a7,a2
	CREATE0	plyr_camflash
	move	a2,a7
	PULL	a10

#nofl

	move	*a13(plyr_num),a14
	move	@plyr_onfire,a0
;;	cmp	a14,a0
;;	jrnz	#nofire
	btst	a14,a0
	jrz	#nofire

;Stop fire circles under on fire alley oop jumper!
	move	@ballpnum,a0
	cmp	a14,a0
	jrnz	#nofire

	move	@tvpanelon,a0,L
	jrnz	#nofire
;Try turning on fire circles under player
	.ref	fire_circle
	CREATE0	fire_circle
	move	a13,*a0(PA10),L

#nofire



	rets

;LOOK!!!
#z_t	.word	CZMID+12,CZMID+8,CZMID,CZMID-8
	.word	CZMID-12,CZMID-8,CZMID,CZMID+8
	.word	CZMID+12


#*******************************
* Flash cameras in crowd

	.ref	gndpos_t

 SUBR	plyr_camflash

	move	@pup_court,a14
	jrnz	#die			;br=outdoor court, no camera flashes

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
;	addk	2,a0
	addk	4,a0
	calla	PRCSLP
	dsj	a8,#lp
#die
	DIE

plyr_cflsh_snd
	movk	3,a0
	callr	rndrng0
	sll	5,a0
	addi	flsh_t,a0
;FIX!!!  Ugly camera flash snd
	move	*a0,a0,L
#s1	calla	snd_play1
	DIE

flsh_t	.long	flsh1_snd,flsh3_snd,flsh3_snd,flsh4_snd


plyr_cflsh
;Give flashes a tall y range
	movi	>96,a0
	callr	rndrng0
	subi	>69,a0
	move	a0,a2

	movi	399,a0
	callr	rndrng0
	move	@WORLDTLX+16,a14
	subi	>2000-200,a14
	add	a14,a0
	sll	16,a0			;X

	move	a2,a1
	sll	16,a1			;Y

	movi	nflash1,a2
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


#f_l	LW	nflash2,2
	LW	nflash3,2
	LW	nflash3a,2
	LW	nflash3,2
	LW	nflash2,2
	LWL0	nflash1,2

#f2_l	LW	nflash4,2
	LW	nflash5,1
	LW	nflash6,1
	LW	nflash5,1
	LWL0	nflash4,2


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
; THE BALL WASN'T BEING PLACED IN THE MIDDLE OF THE RIM!!! (WHY?!?!?)
	subk	9,a7
;	subk	6,a7

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
;	addk	1,a7
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

;	move	*a13(plyr_num),a0
;	move	@plyr_onfire,a14
;	btst	a0,a14
;	jrnz	#dunknorm

	move	@plyr_onfire,a14
;;	jrnn	#dunknorm
	jrnz	#dunknorm		;br=someone on-fire

	SOUND1	missd1_snd
;	SOUND1	boo1_snd
;	SOUND1	cheer1_snd

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

;Only flash screen white if on fire...
	move	*a13(plyr_num),a14
	move	@plyr_onfire,a0
	btst	a14,a0
	jrz	#nofire

	.ref	flash_white
	calla	flash_white
#nofire

;Deliver a facial?
	move	*a13(plyr_o1dist),a0
	cmpi	35*DIST_REDUCTION,a0
	jrlt	#dlvr
	move	*a13(plyr_o2dist),a0
	cmpi	35*DIST_REDUCTION,a0
	jrgt	#nodlvr
#dlvr
	move	*a13(plyr_num),a0
	cmpi	2,a0
	jrlt	#cktm2
;check tm1

; Start opponent on fire here!

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
	.ref	call_facial_speech
	calla	call_facial_speech
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
;	move	*a13(plyr_seq),a1
;	cmpi	DUNKX3_SEQ,a1
;	jrnz	#dck1
;;Align dunkkx3
;	move	*a8(OYPOS),a1
;	addk	5,a1
;	move	a1,*a8(OYPOS)
;	move	*a8(OXPOS),a1
;	move	*a8(OXVEL),a2,L
;	jrnn	#fix1
;	subi	>2e,a1			;2c
;#fix1	addi	>16,a1
;	move	a1,*a8(OXPOS)
;	jruc	#fix2
;#dck1
;	cmpi	DUNKX_SEQ,a1
;	jrnz	#dck2
;;Align dunkkx
;	move	*a8(OYPOS),a1
;	addk	9,a1
;	move	a1,*a8(OYPOS)
;	move	*a8(OXPOS),a1
;	move	*a8(OXVEL),a2,L
;	jrnn	#fix1a
;	subi	>2e,a1			;2c
;#fix1a	addi	>18,a1
;	move	a1,*a8(OXPOS)
;	jruc	#fix2
;#dck2
;	cmpi	DUNKX2_SEQ,a1
;	jrnz	#dck3
;;Align dunkkx
;	move	*a8(OYPOS),a1
;	subk	2,a1
;	move	a1,*a8(OYPOS)
;	move	*a8(OXPOS),a1
;	move	*a8(OXVEL),a2,L
;	jrnn	#fix1b
;	subi	>2e,a1			;2c
;#fix1b	addi	>16,a1
;	move	a1,*a8(OXPOS)
;	jruc	#fix2
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

*******************************
#dunk_cheer
	SLEEPK	15

	movk	8,a0
	calla	rndrng0
	move	a0,a8
	sll	6,a8
	addi	#dunk_crwd_sp_tbl,a8

	move	*a8+,a0,L
	calla	snd_play1
	SLEEPK	9
	move	*a8,a0,L
	jrz	#done
	calla	snd_play1
#done
	SLEEP	5*60
	clr	a0
	move	a0,@slamming
	DIE


#dunk_crwd_sp_tbl
	.long	cheer2_snd,0
	.long	cheer1_snd,0
	.long	cheer2_snd,0
	.long	cheer3_snd,0
	.long	cheer1_snd,cheer2_snd
	.long	cheer2_snd,0
	.long	cheer2_snd,cheer3_snd
	.long	cheer4_snd,cheer1_snd
	.long	cheer2_snd,0

;	SOUND1	cheer1_snd
;	SOUND1	cheer2_snd
; 
;	SLEEP	5*60
;
;	clr	a0
;	move	a0,@slamming

	DIE


#*******************************
* Sequence - push opponent in front of me

 SUBR	seq_push

;We have to make the accuracy dependent upon ptsdown!  Except when pushing
;my own teammate, then keep it easy.

	PUSH	a11

	move	*a13(plyr_dir),a3

	move	*a13(plyr_o1dist),a14
	subi	50*DIST_REDUCTION,a14
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
	subi	50*DIST_REDUCTION,a14
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
	subi	50*DIST_REDUCTION,a14
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
;	movi	300,a0
;% of time to ignore push if player is in layup sequence!
	movi	500,a0
	btst	LAYUP_B,a14
	jrnz	#xz2

	move	*a5(plyr_seq),a14
	cmpi	SPIN_MOVE_SEQ,a14
	jrz	#xz			;br=push SPINNING dude 15% of time
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
	move	@pup_maxpower,a0
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
	SOUND1	push1_snd
	PULL	a0,a1
#sh1
	move	a0,a11
	move	a0,*a2(OZVEL),L
	move	a1,*a2(OXVEL),L
	move	*a5(plyr_jmpcnt),a0
	jrnz	#injmp2
	movk	1,a0
	move	a0,*a5(plyr_jmpcnt)
#injmp2
	movi	-GRAVB*11,a0		;Up	;19
;	movi	-GRAVB*18,a0		;Up	;19
	move	@HCOUNT,a14
	andi	07,a14
	jrnz	#notlow
	movi	-GRAVB*9,a0		;Up
;	movi	-GRAVB*14,a0		;Up
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

	movi	-GRAVB*7,a0		;7
;	movi	-GRAVB*8,a0		;7
	move	a0,*a2(OYVEL),L
	movk	16,a0			;16
#notsml

	move	*a5(plyr_num),a14
	move	@pup_maxpower,a1
	btst	a14,a1
	jrz	#nochng1
;This guy has max power!  Don't knock him down!
	movi	-GRAVB*7,a0		;7
;	movi	-GRAVB*8,a0		;7
	move	a0,*a2(OYVEL),L
	move	*a2(OZVEL),a0,L
	sra	2,a0
	move	a0,*a2(OZVEL),L
	move	*a2(OXVEL),a0,L
	sra	2,a0
	move	a0,*a2(OXVEL),L

	SOUND1	push1_snd

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
	move	@my_ballpnumlast,a1
	jrn	#noown3
	movk	PS_TURNOVERS,a0
	calla	inc_player_stat
#noown3

	move	@ballprcv_p,a0,L
	jrz	#ok_ball
;Messing with ball vels but pass has gotten triggered?
;	.if	DEBUG
;	LOCKUP
;	.endif
	clr	a0
	move	a0,@ballprcv_p,L

	callr	flash_ball
	SOUND1	steal_snd
	SOUND1	swat_snd
;	callr	get_swat

;Fall thru...
;	jruc	#nobl
#ok_ball

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

	clr	a0
	move	a0,@ballbbhitcnt
	not	a0			;=-1
	move	a0,@ballpnum
	move	a0,@ballpnumlast

	movi	[2,0],a0
#not_rear
	move	a0,*a4(OZVEL),L

;Make sure owner is losing ball!
;	move	@ballpnum,a0
;	jrn	#nobl
;	movi	-1,a0
;	move	a0,@ballpnum	;a14

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

	move	*a5(plyr_ownball),a0
	jrle	#not_rear2		;br=hey, i dont have ball
	SOUND1	into_stnd_sp

#not_rear2

	move	*a13(plyr_num),a0	;If on fire, don't use turbo on push
	move	@plyr_onfire,a1
;;	cmp	a0,a1
;;	jrz	#x
	btst	a0,a1
	jrnz	#x			;br=plyr on-fire

	move	*a13(plyr_PDATA_p),a2,L
	move	*a2(ply_turbo),a1
	subk	(TURBO_CNT*2)/13,a1	;!!! Min cnt for push
	jrge	#clrbl
	clr	a1
#clrbl
	move	a1,*a2(ply_turbo)
	sll	5,a1
	.ref	TURBO_52
	addi	TURBO_52,a1
	move	*a2(ply_meter_imgs+32),a0,L
	move	*a1(0),*a0(OSAG),L

#x	PULL	a11
	rets

;	subk	7,a1
;	move	a1,*a2(ply_turbo)
;	move	*a2(ply_meter_imgs+40h),a0,L
;	move	*a0(OFSET),a1		;Shrink meter
;	addk	7,a1
;	move	a1,*a0(OFSET)
;
;	jruc	#x
;
;#clrbl
;	move	*a13(plyr_PDATA_p),a2,L
;	move	*a2(ply_turbo),a14
;	clr	a0
;	move	a0,*a2(ply_turbo)
;	move	*a2(ply_meter_imgs+40h),a0,L
;	move	*a0(OFSET),a1		;Shrink meter
;	add	a14,a1
;	move	a1,*a0(OFSET)
;
;
;#x	PULL	a11
;	rets


#*******************************
* Sequence - elbo opponents around me

 SUBR	seq_elbo

	move	*a13(plyr_num),a4
	srl	1,a4
	XORK	1,a4
	sll	6,a4			;*64
	addi	plyrproc_t,a4

	move	*a13(plyr_o1dist),a14
	subi	40*DIST_REDUCTION,a14
	jrge	#o1far			;Too far?

	move	@HCOUNT,a14
	btst	0,a14
	jrz	#o1far			;Skip? (50%)

	move	*a4,a5,L		;A5=*O proc
	move	*a13(plyr_o1dir),a0
	callr	#elbo
#o1far

	move	*a13(plyr_o2dist),a14
	subi	40*DIST_REDUCTION,a14
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
	movi	-GRAVB*9,a0		;Up 15
;	movi	-GRAVB*12,a0		;Up 15
	move	a0,*a2(OYVEL),L

	move	*a5(plyr_num),a14
	move	@pup_maxpower,a1
	btst	a14,a1
	jrz	#injmp
;This guy has max power!  Don't knock him down!
	movi	-GRAVB*7,a0		;7
;	movi	-GRAVB*8,a0		;7
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

	.asg	22,DIAM
	.asg	PDATA,GAME_QTR

 SUBRP	no_good_check

	move	@gmqrtr,a0
	move	a0,*a13(GAME_QTR)

#loop
 	SLEEPK	1

	move	@game_time,a0,L		;If at beginning of qrtr, no speech!
	cmpi	>2050400,a0		;!!!
	jrgt	#snuffit

	move	@gmqrtr,a0
	move	*a13(GAME_QTR),a1
	cmp	a0,a1			;If not in same qrtr, no speech!
	jrne	#snuffit

	move	*a8(OYPOS),a0		;Ball Y in range? No if >
	cmpi	HOOPY+15,a0
	jrgt	#no_good

	move	*a8(OXPOS),a0		;Calc delta X for ball to hoop
	move	*a8(OXANI+10h),a1
	add	a1,a0
	sub	a11,a0
	abs	a0
	subk	DIAM,a0			;Ball X in range? No if >
	jrgt	#no_good

	move	*a8(OZPOS),a0		;Calc delta Z for ball to hoop
	subi	CZMID,a0
	abs	a0
	subk	DIAM,a0			;Ball Z in range? No if >
	jrgt	#no_good

	jruc	#loop

#no_good
	calla	nogood_speech

#snuffit
	DIE

******************************************************************************
	.end


