**************************************************************
*
* Owner:	JOHNSON
*
* Software:	Mark Turmell/Jeff Johnson/Dan Thomspon
* Initiated:	7/17/90
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 9/25/95
**************************************************************
	.file	"score.asm"
	.title	"score stuff"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"gsp.equ"
	.include	"sys.equ"
	.include	"world.equ"		;Court-world defs
	.include	"game.equ"
	.include	"macros.hdr"
	.include	"audit.equ"

	.include	"imgtbl.glo"

	.include	"leds.tbl"
	.include	"city.tbl"
	.include	"arrow.tbl"
	.include	"arrow.glo"

	.include	"credturb.glo"
	.include	"credit.tbl"
	.include	"hotspot.glo"

	.include	"powertxt.tbl"
	.include	"powertxt.glo"

	.asg		0,SEQT
	.include	"plyr.equ"


;sounds
	.ref	cntdown_snd,snd_play1
	.ref	horn_snd
	.ref	powrup_awrd1,powrup_awrd2
	.ref	powrup_awrd3,powrup_awrd4
	.ref	alert_snd,whitsle_snd
	.ref	showtm,tick_snd
	.ref	warn_snd,minute_sp,win_snd
	.ref	tuneq1_snd
	.ref	tuneq2_snd,tuneq3_snd,tuneq4_snd,tuneot_snd

;symbols externally defined

	.ref	print_string2b,kern_chars,mess_justify,mess_cursx,mess_cursy
	.ref	mess_cursx2
	.ref	crplate_ptr
	.ref	RNDRNG0
;	.ref	lighten1
;	.ref	lighten2
;	.ref	lighten3
;	.ref	lighten4
;	.ref	lighten5
;	.ref	lighten6
;	.ref	lighten7
	.ref	CYCLE_TABLE,bast18_ascii
	.ref	clear_secret_powerup_tmode
	.ref	HANGF_R_P

	.ref	pup_nodrift
	.ref	pup_hypspeed
	.ref	pup_baby,pup_strongmen,pup_bighead
	.ref	pup_hugehead
	.ref	pup_maxpower,pup_maxsteal
	.ref	pup_fastpass,pup_showhotspots,pup_notag
	.ref	pup_trbstealth
	.ref	pup_goaltend,pup_trbinfinite
	.ref	pup_nopush,pup_maxspeed,pup_showshotper
	.ref	pup_noassistance,pup_tournament,pup_maxpower

	.ref	get_but_val_down
	.ref	get_start_cur
	.ref	special_heads
	.ref	plyr_onfire
	.ref	qtr_purchased,idiot_box
	.ref	update_shoes
	.ref	flash_bigtxt
	.ref	setup_message,print_string_C2,print_string
	.ref	copy_string,print_string_C
	.ref	dec_to_asc

	.ref	bast8_ascii,bast8t_ascii
	.ref	hangfnt38_ascii

	.ref	mess_line_spacing
	.ref	TWOPLAYERS
	.ref	mess_objid

	.ref	inc_player_stat
	.ref	assist_plyr
	.ref	blink_plyr
	.ref	msg_ram
 	.ref	get_but_val_cur
	.ref	start_animate
	.ref	plyr_endofqrtr,WFLG
	.ref	ballgoaltcnt
	.ref	ballflash
	.ref	PALRAM,PCNT,pal_clean
	.ref	CRED_P,BINBCD,GAMSTATE,CR_STRTP,GET_ADJ,PSTATUS
	.ref	P1DATA,P2DATA,P3DATA,P4DATA,OBJON,OBJOFF
	.ref	init_t1a,init_t2a,init_t3a,init_t4a
	.ref	timertcnt,prt_status
	.ref	names,name_flop,name_cnt
	.ref	plyrobj_t,PSTATUS2
	.ref	anipt_getsclxy
	.ref	CR_CONTP,inbound
	.ref	HALT
	.ref	OWINDOW,RD15FONT,AUD,WNDWON
	.ref	CWINDOW,GETCPNT,LOWZ
	.ref	HEXTOASC,WIPEOUT
	.ref	STRCNRMO
	.ref	plyrproc_t,pal_getf
	.ref	team1,team2
	.ref	gndpos_t
	.ref	plyr_takeoutball3
	.ref	ballpnumshot,ballpnum
	.ref	ballobj_p
	.ref	get_all_buttons_down
	.ref	get_all_starts_down
	.ref	AUD1
	.ref	brush20_ascii,brush50_ascii
	.ref	shot_clock_speech
	.ref	sht_ball_sp,ot_alert_snd
	.ref	start_crowd_noise
	.ref	tm_fire_tune
	
;symbols defined in this file

	.def	LED_00,LED_0,last_score,tvpanelon,LED_MAX,QUARTR01,SHOTPER
	.def	sclockx

;uninitialized ram definitions


;	BSSX	already_on,4*32		;arw on hd 0=no or proc pntr
	BSSX	conttimers,16*4		;Continue timer value. 4 players
	.bss	shotram,3*32
	BSSX	shotimer,32
	.bss	temp,16
	BSSX	game_time,32		;mins,secs,10ths of sec each 8 bits
	BSSX	clock_speed,16
	BSSX	gmqrtr,16		;0-5 4=overtime,5=final score
	.bss	bclok_imgs,32*4		;images for big clock at botm of scrn
	.bss	clock_imgs,32*2		;images for main clock at top of scrn
	.bss	score_imgs,32*2		;*Imgs for score table score (Must follow^)
	BSSX	scores,16*2		;scores for both teams
	.bss	tvpanelon,32		;!0=TV panel displayed, or proc pntr

	.bss	msg_flop,16		;Flop message variable 0 or 1
	BSSX	BTIME,16
	BSSX	cntrs_delay,16		;Delay, for Jamies cntdwn
	.bss	flsh_ptrs,6*32		;Bigscr imgs for red flash
	.bss	last_score,32		;#scores for red flash
	BSSX	clock_active,16		;0=clock tick down, 1=hold clock
	BSSX	sc_proc,32		;0if not shot clock on scrn, proc ptr
	BSSX	_4plyrsingame,16	;1=no stay on machine, 0=stay on
	BSSX	_2plyr_competitive,16	;1=no stay on machine, 0=stay on
	.bss	CMOS_clock_speed,16	;Ram copy of CMOS adjustment

;	BSSX	p1taps,16		;Keep in order
;	BSSX	p2taps,16
;	BSSX	p3taps,16
;	BSSX	p4taps,16

	.if DEBUG | DUNKTST
	BSSX	CLOCK_OFF,16		;Debug:  0=On, 1=Off
	.endif

	.text

**************************
;game timer fractions

timer_table
;	.word	0e000h
;	.word	0e000h
;	.word	0e000h
;	.word	0e000h
;	.word	0e000h

;	.asg	4f00h,BASETM
	.asg	5100h,BASETM

	.word	BASETM*70/100		;1 (slowest)
	.word	BASETM*85/100		;2 (slower)
	.word	BASETM			;3 (default)	;Approx 10 minutes
	.word	BASETM*115/100		;4 (faster)
	.word	BASETM*130/100		;5 (fastest)


	.asg	3,FLAME_ANICNT

tfire_timer_tbl
	.word	130*TSEC/FLAME_ANICNT/100
	.word	115*TSEC/FLAME_ANICNT/100
	.word	    TSEC/FLAME_ANICNT
	.word	 85*TSEC/FLAME_ANICNT/100
	.word	 70*TSEC/FLAME_ANICNT/100

;----------

	.asg	151,SCOREMAX		;When to "MAX" score imgs


#******************************************************************
* Player is off screen for too long - put up an arrow pointing him out
*
*a10=0-3 for plyr #

	.asg	  0,SCX_L		;40  ;0
	.asg	398,SCX_R		;358 ;398
	.asg	28,SIDEARW_W

	.asg	SCX_L+4+40,PON_L
	.asg	SCX_R-4-40,PON_R

	.asg	SCX_L-8+40,POF_L
	.asg	SCX_R+8-40,POF_R

	.asg	SCX_L,          ARWLX_L
	.asg	SCX_R-SIDEARW_W,ARWLX_R

	.asg	ARWLX_L+40,ARWIX_L
	.asg	ARWLX_R-40,ARWIX_R
	.asg	52,ARWY_O

	.asg	360,TLX_O

	.asg	2,IDIOT_MSG
	.asg	6*50,IDIOT_CNT


 SUBR	plyr_lost

	SLEEPK	2			;Make sure plyr gets started

	move	a10,a11			;Keep plyr # handy

	sll	5,a10
	move	a10,a9
	addi	plyrproc_t,a10
	move	*a10,a10,L		;Get plyr *proc
	addi	plyrobj_t,a9
	move	*a9,a9,L		;Get plyr *obj
	
	clr	a8			;Clr arw *obj
	move	a8,*a13(PDATA),L	;Clr shoe *pal
	move	a8,*a13(PDATA+32)	;Clr off cnt
	move	a8,*a13(PDATA+48)	;turbo replenish ctr
	move	a8,*a10(plyr_offtime)	;Plyr is on screen!
;Player lost arrow process ptr for arw flash
	move	a13,*a10(plyr_lost_ptr),L

#top
	SLEEPK	3
	calla	update_shoes
	SLEEPK	3
	calla	update_shoes

#do_rep
	move	*a10(plyr_PDATA_p),a0,L	;Deref plyr *proc for *data

	move	*a0(used_turbo),a14
	jrle	#do_rp
	subk	1,a14
	move	a14,*a0(used_turbo)
	jruc	#no_rep
#do_rp
	callr	replenish_turbo
	move	*a13(PDATA+48),a14	;turbo replenish ctr
	addk	1,a14
	cmpi	8,a14			;9 ;Quicken replenish
	jrlt	#no_rrp
	callr	replenish_turbo
	clr	a14
#no_rrp
	move	a14,*a13(PDATA+48)	;turbo replenish ctr

#no_rep
	move	*a9(OSCALE),a1		;Get plyr obj screen lft X
	cmpi	PON_R,a1
	jrge	#noton_r
	move	*a9(OSIZEX),a2		;Add for plyr obj screen rgt X
	add	a1,a2
	cmpi	PON_L,a2
	jrle	#noton_l

	move	a8,a8			;Active off arw?
	jrz	#top			;br=no

	move	a8,a0			;Kill arw *obj
   	calla	DELOBJ

	clr	a8			;Clr arw *obj
	move	a8,*a13(PDATA+32)	;Clr off cnt
	move	a8,*a10(plyr_offtime)	;Plyr is on screen!

	callr	arw_on1plyr		;Turn on overhead arw

	jruc	#top

#noton_l
	cmpi	POF_L,a2		;All the way off?
	jrle	#off_l			;br=yes
	clr	a14
	move	a14,*a10(plyr_offtime)	;Plyr is on screen!
	move	a8,a8			;In neutral zone. Active off arw?
	jrz	#top			;br=no
#off_l
	movk	1,a14
	move	a14,*a10(plyr_offtime)	;Plyr is offscreen!

	move	@ballpnum,a14		;>Chk if other team owns ball
	jrn	#nown_l			;Ball owned? br=no
	move	*a10(plyr_ownball),a14	;-=Teammate, 0=Neither, +=I have ball
	jrnz	#nown_l
	move	a11,a14			;Other team has it
	subk	1,a14			;Is plyr off wrong side?
	jrle	#nown_l			;br=no
	move	a14,*a10(plyr_offscrn)	;Plyr is off, spd him up
#nown_l
	movi	ARWIX_L,a0
	move	@WORLDTLX+16,a14
	move	*a9(OXPOS),a3
	sub	a14,a3
	jrnn	#nn_l
	neg	a3
	sra	3,a3
	jruc	#ps_l
#nn_l
	sra	3,a3
	neg	a3
#ps_l
	move	a8,a8			;Active off arw?
	jrnz	#arw_on			;br=yes

 	movi	lft_lst,a2		;Off lft side
	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#off_sc
	movi	lf2_lst,a2
	jruc	#off_sc

#noton_r
	cmpi	POF_R,a1		;All the way off?
	jrge	#off_r			;br=yes
	clr	a14
	move	a14,*a10(plyr_offtime)	;Plyr is on screen!
	move	a8,a8			;In neutral zone. Active off arw?
	jrz	#top			;br=no
#off_r
	movk	1,a14
	move	a14,*a10(plyr_offtime)	;Plyr is offscreen!

	move	@ballpnum,a14		;>Chk if other team owns ball
	jrn	#nown_r			;Ball owned? br=no
	move	*a10(plyr_ownball),a14	;-=Teammate, 0=Neither, +=I have ball
	jrnz	#nown_r
	move	a11,a14			;Other team has it
	subk	2,a14			;Is plyr off wrong side?
	jrge	#nown_r			;br=no
	move	a14,*a10(plyr_offscrn)	;Plyr is off, spd him up
#nown_r
	movi	ARWIX_R,a0
	move	@WORLDTLX+16,a14
	addi	TLX_O,a14
	move	*a9(OXPOS),a3
	sub	a14,a3
	jrnn	#nn_r
	neg	a3
	sra	3,a3
	jruc	#ps_r
#nn_r
	sra	3,a3
	neg	a3
#ps_r
	move	a8,a8			;Active off arw?
	jrnz	#arw_on			;br=yes

 	movi	rgt_lst,a2		;Off rgt side
	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#off_sc
	movi	rg2_lst,a2

#off_sc
	sub	a3,a0
	clr	a3

	sll	5,a11
	add	a11,a2
	srl	5,a11
	move	*a2,a2,L		;Get arw *img

	PUSH	a0
	sll	16,a0
	clr	a1
	movi	DMAWNZ|M_SCRNREL|M_NOCOLL,a4
	movi	arwid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2			;Get arw *obj

;	move	*a10(plyr_num),a14
;	sll	5,a14
;	.ref	player_data
;	addi	player_data,a14,L
;	move	*a14,a14,L
;	move	*a14(PR_PRIVILEGES),a14
;	jrle	#nxtt
;	btst	0,a14				;NO TAG ARROW privilege ?
;	jrnz	#tag_of				;br=yes
;#nxtt
;	move	@pup_notag,a14		;>POWER-UP LOGIC
;	btst	a11,a14				;Plyr arrow-off bit set?
;	jrz	#tag_on				;br=no, show arrow
;#tag_of
;	move	a8,a0
;	calla	OBJOFF
;#tag_on
	PULL	a0

#arw_on
	sub	a3,a0

	move	*a8(OXPOS),a4
	move	a4,a14
	sub	a0,a14
	abs	a14
	subk	2,a14
	jrle	#arw_yz
	cmp	a0,a4
	jrz	#arw_yz
	jrlt	#arw_xinc

	cmpi	ARWLX_L,a4
	jrz	#arw_yz
	subk	1,a4
	jruc	#arw_x
#arw_xinc
	cmpi	ARWLX_R,a4
	jrz	#arw_yz
	addk	1,a4
#arw_x
	move	a4,*a8(OXPOS)
#arw_yz
	move	*a9(OZPOS),a0
	move	a0,*a8(OZPOS)

	subi	GZBASE,a0		;-Base
	jrge	#zok
	clr	a0
#zok
	move	a0,a14
	sra	1,a0			;Z/2
	sra	3,a14			;Z/8
	sub	a14,a0			;=Z/2.667
	addi	GND_Y-ARWY_O,a0
	move	@WORLDTLY+16,a14
	abs	a14
	add	a14,a0
	move	a0,*a8(OYPOS)

	move	@PSTATUS,a14		;No idiot box if drone
	btst	a11,a14
	jrz	#bot

	move	*a13(PDATA+32),a14	;Not, but is it time yet?
	inc	a14
	move	a14,*a13(PDATA+32)
	cmpi	IDIOT_CNT,a14
	jrlt	#bot

	move	@gmqrtr,a14		;Yes, but no idiot box after 1st qrtr
	jrnz	#zcnt

	move	@inbound,a14		;Not, but no idiot box if inbounding
	jrnn	#zcnt

	movk	IDIOT_MSG,a0		;Tell plyr where he is!
	move	a11,a1
	calla	idiot_box
#zcnt
	clr	a14
	move	a14,*a13(PDATA+32)	;Reset off cnt
	
#bot
	SLEEPK	1
	move	@HALT,a14
	jrnz	#bot
	move	@PCNT,a14		;Bump turbo replenish rate when
	andi	3,a14			; off-screen (every 4th, not 6th)
	jrnz	#no_rep
	jruc	#do_rep


lft_lst	.long	arrown1l,arrown2l,arrown3l,arrown4l
lf2_lst	.long	arrown1l2p,arrown1l2p,arrown2l2p,arrown2l2p

rgt_lst	.long	arrown1r,arrown2r,arrown3r,arrown4r
rg2_lst	.long	arrown1r2p,arrown1r2p,arrown2r2p,arrown2r2p


#******************************************************************
*
* Turn on a player arrow/# on top of his head
* Individual #
*
* a10=plyr proc of whom to stick an arrow on

 SUBR	arw_on1plyr

;Stick player number on top of player

	.if	IMGVIEW
	rets				;Debug - no credit cntdwn
	.endif

	PUSH	a7,a8,a9,a11
	move	@GAMSTATE,a0
	subk	INAMODE,a0
	jrz	#x

	move	*a10(plyr_PDATA_p),a0,L	;*PxDATA
	move	*a0(head_arw_img),a0,L
	move	*a0(OPLINK),a0,L

	movi	ARWPID,a1
	movi	arwon,a7
	move	*a0(PA8),a8,L
	move	*a0(PA9),a9,L
;	movi	2*60+15,a11		;Time for arw to be on
;Carlton hates these arrows...  Shorten lifespan.
	movi	110,a11			;Time for arw to be on
	calla	XFERPROC

#x
	PULL	a7,a8,a9,a11
	rets


#******************************************************************
*
* Turn on a player arrow/# on top of his head
*
* a10=PxDATA ram

 SUBR	stick_number

;Stick player number on top of player

	.if	IMGVIEW
	rets				;Debug - no credit cntdwn
	.endif

	PUSH	a7,a8,a9,a11
	move	@GAMSTATE,a0
	subk	INAMODE,a0
	jrz	#x

	move	*a10(head_arw_img),a9,L
	move	*a9(OPLINK),a0,L

	.if	DEBUG
	calla	process_exist
	jrnz	#ok
	LOCKUP
#ok
	.endif
 
	movi	ARWPID,a1
	movi	arwon,a7
	move	*a0(PA8),a8,L
	move	*a0(PA9),a9,L
;	movi	4*60,a11		;Time for arw to be on
	movi	3*60+15,a11		;Time for arw to be on
	calla	XFERPROC

#x
	PULL	a7,a8,a9,a11
	rets


#******************************************************************
*
* Turn on a player arrow/# on top of his head
*
* a10=PxDATA ram
* a11=plyr # (0-3)

 SUBR	stick_numbers

	movi	plyrproc_t,a0
	movi	#arwt_t,a2
	move	a11,*a13(PDATA+64)	;Save plyr #

	sll	5,a11
	add	a11,a0
	add	a11,a2
	addi	plyrobj_t,a11

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not2
	addi	NUMPLYRS*32,a2
#not2
	move	*a0,a0,L
	move	a0,*a13(PDATA+32),L	;Save plyr *proc

	movi	[-100,0],a1
	move	*a2,a2,L
	clr	a3
	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE,a4
	movi	arwid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	move	a8,a0
	calla	OBJOFF

	move	a8,*a10(head_arw_img),L	;Save arw *obj

	move	a8,a9			;A9=arw *obj
	move	*a11,a8,L		;A8=plyr *obj to stick to

;	movi	4*60,a11		;Time for arw to be on
	movi	3*60,a11		;Time for arw to be on

;--------------------

arwon
	move	@PSTATUS,a0
	move	*a13(PDATA+64),a14
	btst	a14,a0			;No arw if plyr is a drone
	jrz	#arwait			;br=no arw

;don't turn on ARROW if players' powerup is set
	move	a14,a1
	sll	5,a14
	.ref	player_data
	addi	player_data,a14,L
	move	*a14,a14,L
	move	*a14(PR_PRIVILEGES),a14
	jrle	#nxtt
	btst	0,a14				;NO TAG ARROW privilege ?
	jrnz	#arwtop				;br=yes
#nxtt
	move	@pup_notag,a0
	btst	a1,a0			;plyrs bit set ?
	jrnz	#arwtop			;br=yep, dont show arrow

	move	a9,a0
	calla	OBJON

#arwtop
;	calla	anipt_getsclxy		;co'ed 12/21/95 DJT
;	srl	16,a0
	move	*a8(OXANI+16),a0

	move	*a8(OXPOS),a2
	add	a0,a2
	subk	4,a2			;!!!
	move	a2,*a9(OXPOS)

	move	*a8(OZPOS),A2
	addk	30,a2			;!!!
	move	a2,*a9(OZPOS)

	move	*a8(OPLINK),a0,L
	move	*a0(plyr_headobj_p),a0,L
	move	*a0(OYPOS),A2
	subi	35,a2			;!!!
	move	a2,*a9(OYPOS)

#wtlp
	SLEEPK	1
	move	@HALT,a0
	jrnz	#wtlp
	dsj	a11,#arwtop

	move	a9,a0
	calla	OBJOFF

#arwait	SLEEP	60
	move	a9,a0
	calla	OBJOFF
	jruc	#arwait

#arwt_t	.long	arrown1t,arrown2t,arrown3t,arrown4t
	.long	arrown1t,arrown1t2p,arrown2t2p,arrown4t


#******************************************************************
*
* a10=PxDATA ram

 SUBR	stick_cpu

	move	@PSTATUS,a0
	btst	a11,a0
	janz	SUCIDE
	move	@GAMSTATE,a0
	cmpi	INAMODE,a0
	jaz	SUCIDE

	move	a10,*a13(PDATA),L
;	SLEEP	4*60-40

	move	*a13(PROCID),a5			;get pid for stick img oid

	movi	[-65,0],a1
	movi	cpu,a2
	clr	a3
	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE,a4
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	move	a8,a9

	sll	5,a11
	addi	plyrobj_t,a11

	move	*a11,a8,L		;A8=plyr *obj to stick to

	movi	15*60,a11		;Time for cpu to be on
#metop
;	calla	anipt_getsclxy		;co'ed 12/21/95 DJT
;	srl	16,a0
	move	*a8(OXANI+16),a0

	move	*a8(OXPOS),a2
	add	a0,a2
	subk	7,a2			;!!!
	move	a2,*a9(OXPOS)

	move	*a8(OZPOS),A2
	addk	3,a2			;!!!
	move	a2,*a9(OZPOS)

	move	*a8(OPLINK),a0,L
	move	*a0(plyr_headobj_p),a0,L
	move	*a0(OYPOS),A2
	addi	20,a2			;!!!
	move	a2,*a9(OYPOS)

	move	*a13(PDATA),a0,L	;Drone become human?
	move	*a0(ply_time),a0
	cmpi	25,a0
	jrlt	#mex			;br=no

	move	a9,a8
	jauc	DELOBJDIE

#mex	SLEEPK	1
	move	@HALT,a0
	jrnz	#mex
	dsj	a11,#metop
	move	a9,a0
	calla	DELOBJ	
	DIE

;#******************************************************************
;*
;* a10=PxDATA ram
;
; SUBR	stick_spark
;
;	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE,a4
;	move	*a13(PROCID),a5			;get pid for stick img oid
;	movi	[-65,0],a1
;	movi	lighten1,a2
;	clr	a3
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;
;	move	a8,a9
;
;	sll	5,a11
;	addi	plyrobj_t,a11
;
;	move	*a11,a8,L			;player img to stick to
;#metop0
;	move	a9,a0
;	movi	400h,a14
;	move	a14,*a0(OYPOS)
;	calla	OBJOFF
;	movi	light_t,a10
;	movi	4*60,a0			;4*60,a0
;	calla	RNDRNG0
;	addi	30,a0			;30
;	calla	PRCSLP
;	move	a9,a0
;	calla	OBJON
;	movk	1,a0
;	move	a0,*a13(PDATA)
;#metop
;
;	move	*a13(PDATA),a0
;	dec	a0
;	move	a0,*a13(PDATA)
;	jrnz	#cont
;	movk	3,a0
;	move	a0,*a13(PDATA)
;
;	move	*a10+,a0,L
;	jrz	#metop0
;	SWAP	a8,a9
;	move	*a8(OFLAGS),a1
;	calla	obj_aniq
;	SWAP	a8,a9
;	move	*a10+,a0
;	move	a0,*a13(PDATA+16)
;	move	*a10+,a0
;	move	a0,*a13(PDATA+32)
;
;#cont
;
;	calla	anipt_getsclxy			;GETANIXY
;	srl	16,a0
;
;	move	*a8(OZPOS),a2
;	addk	3,a2
;	move	a2,*a9(OZPOS)
;
;	move	*a8(OXPOS),a2
;	addk	3,a2
;	add	a0,a2
;	move	*a13(PDATA+16),a0
;	sub	a0,a2
;	move	a2,*a9(OXPOS)
;
;	move	*a8(OPLINK),a0,L
;	move	*a0(plyr_headobj_p),a0,L
;	move	*a0(OYPOS),a2
;	addi	44h,a2
;	move	*a13(PDATA+32),a0
;	sub	a0,a2
;	move	a2,*a9(OYPOS)
;
;
;#mex	SLEEPK	1
;;	move	@HALT,a0
;;	jrnz	#mex
;	jruc	#metop
;
;
;light_t
;	LWW	lighten1,1,10
;	LWW	lighten2,-2,20
;	LWW	lighten3,-5,37
;	LWW	lighten4,2,44
;	LWW	lighten5,4,56
;	LWW	lighten6,4,65
;	LWW	lighten7,1,69
;	.long	0
;
;#******************************************************************
;*
;* a10=PxDATA ram
;
; SUBR	stick_spark2
;
;	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE|M_FLIPH,a4
;	move	*a13(PROCID),a5			;get pid for stick img oid
;	movi	[-65,0],a1
;	movi	lighten1,a2
;	clr	a3
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;
;	move	a8,a9
;
;	sll	5,a11
;	addi	plyrobj_t,a11
;
;	move	*a11,a8,L			;player img to stick to
;#metop0
;	move	a9,a0
;	movi	400h,a14
;	move	a14,*a0(OYPOS)
;	calla	OBJOFF
;	movi	light_t,a10
;	movi	4*60,a0			;4*60,a0
;	calla	RNDRNG0
;	addi	30,a0			;30
;	calla	PRCSLP
;	move	a9,a0
;	calla	OBJON
;	movk	1,a0
;	move	a0,*a13(PDATA)
;#metop
;
;	move	*a13(PDATA),a0
;	dec	a0
;	move	a0,*a13(PDATA)
;	jrnz	#cont
;	movk	3,a0
;	move	a0,*a13(PDATA)
;
;	move	*a10+,a0,L
;	jrz	#metop0
;	SWAP	a8,a9
;	move	*a8(OFLAGS),a1
;	calla	obj_aniq
;	SWAP	a8,a9
;	move	*a10+,a0
;	move	a0,*a13(PDATA+16)
;	move	*a10+,a0
;	move	a0,*a13(PDATA+32)
;
;#cont
;
;	calla	anipt_getsclxy			;GETANIXY
;	srl	16,a0
;
;	move	*a8(OZPOS),a2
;	addk	3,a2
;	move	a2,*a9(OZPOS)
;
;	move	*a8(OXPOS),a2
;	subk	7,a2
;	add	a0,a2
;	move	*a13(PDATA+16),a0
;	add	a0,a2
;	move	a2,*a9(OXPOS)
;
;	move	*a8(OPLINK),a0,L
;	move	*a0(plyr_headobj_p),a0,L
;	move	*a0(OYPOS),a2
;	addi	44h,a2
;	move	*a13(PDATA+32),a0
;	sub	a0,a2
;	addi	10,a2
;	move	a2,*a9(OYPOS)
;
;
;#mex	SLEEPK	1
;;	move	@HALT,a0
;;	jrnz	#mex
;	jruc	#metop

#*********************************************************************
* Called from main loop to update credit counters, etc.

 SUBR	cr_cntrs_update

	move	@cntrs_delay,a0		;Selection screen delay
	jrle	#cr1
	dec	a0
	move	a0,@cntrs_delay
#x	rets

#cr1
	.if	IMGVIEW
	rets				;Debug - no credit cntdwn
	.endif

	move	@GAMSTATE,a2
	jrn	#x			;In diagnostics?
	cmpi	INAMODE,a2
	jreq	#x
	cmpi	ININTRO,a2
	jreq	#x			;In stats?
	subk	INPLYRINFO,a2
	jreq	#x			;In stats?

	move	@name_cnt,a0
	dec	a0
	move	a0,@name_cnt
	jrnz	main0
	movi	110,a0			;Shorter time for player names message
	move	a0,@name_cnt

	move	@GAMSTATE,a0
	subk	INGAME,a0		;If not ingame, don't change messages
	jrne	main0

	move	@name_flop,a0
	XORK	1,a0
	move	a0,@name_flop
	jrnz	#showpnames

					;replace names with correct buyin message
	movi	210,a0			;Longer time for buyin message / meter
	move	a0,@name_cnt

	movi	insert,a11
	calla	CR_CONTP		;Credits to cont
	jrlo	#no00			;No?
	movi	start,a11
#no00
	movi	insert,a10
	calla	CR_STRTP		;Credits to start
	jrlo	#no1			;No?
	movi	start,a10
#no1

	movi	P1DATA,a9
	clr	a3
	movk	4,a4

	movi	LED_P,a0
	calla	pal_getf
	move	a0,a5

#msglp

	.ref	pleasewt
	move	@pleasewt,a14
	btst	a3,a14
	jrnz	#nxta


	move	@TWOPLAYERS,a7			;0 = NO, 1 = YES 2 players
	jrz	#not2
	cmpi	P1DATA,a9
	jrz	#nxt
	cmpi	P4DATA,a9
	jrz	#nxt
#not2


	move	*a9(ply_messages),a8,L
	jrz	#nxt
	move	a10,a0
	move	@PSTATUS2,a14
	btst	a3,a14
	jrz	#no2			;This player has never been started
	move	a11,a0
#no2

;	jruc	#nxta

	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

	move	*a9(ply_meter_imgs),a0,L
	calla	OBJOFF
	move	*a9(ply_meter_imgs+32),a0,L
	calla	OBJOFF
;	move	*a9(ply_meter_imgs+64),a0,L
;	calla	OBJOFF

#nxt
	jruc	#nxta

#nxta
	addi	PDSIZE,a9
	addk	1,a3
	dsj	a4,#msglp

	jruc	main0


;--------------------

#showpnames

;Try to swap buyin message and turbo meters for player names

	movi	BAST_Y_P,a0			;scorep
	calla	pal_getf
	move	a0,a5

	movk	4,a4
	movi	P1DATA,a9
	movi	names,a10
	clr	a3

; Top of loop

#pnlp
	move	@pleasewt,a14			;Skip if "please"
	btst	a3,a14      
	jrnz	#nxtpn

	move	*a9(ply_messages),a8,L		;Skip & chk if name should be
	jrz	#noani				; shown if no message (if 0)

	move	a8,a0				;Turn off message obj
	calla	OBJOFF

	move	*a9(ply_meter_imgs),a0,L	;Move down name obj Y
	move	*a0(OYPOS),a14
	cmpi	5,a14
	jrnz	#dip
	movi	15,a14
	jruc	#dip2
#dip
	movi	18,a14
#dip2
	move	a14,*a0(OYPOS)			;Turn on name obj
	calla	OBJON

	move	@TWOPLAYERS,a0
	jrz	#not2p

	cmpi	1,a3
	jrz	#not2p
	cmpi	2,a3
	jrz	#not2p

	move	a8,a0				;Definite drone. Make sure(!)
	calla	OBJOFF				; message obj is off & go
	jruc	#inhr				; show drone name
#not2p
	movi	tocontrol,a0			;Turn on "to control" in
	movi	MSGOCTRL,a1			; message obj & go show plyr
	calla	obj_aniq_cnoff			; name
	jruc	#inhr

#noani
	move	*a9(ply_time),a1
	subk	23,a1
	jrlt	#nxtpn
#inhr
	move	*a9(ply_meter_imgs),a8,L	;change box to name
	move	a5,*a8(OPAL)
	move	*a10,a0,L
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

#nxtpn
	addi	PDSIZE,a9
	addk	1,a3
	addk	32,a10
	dsj	a4,#pnlp

;--------------------

main0	move	@timertcnt,a3		;>Update player timers
	subk	1,a3
	jrgt	mlp120

;Could put all this stuff inside the individual players process

	clr	a0
	move	a0,@msg_ram,L
	move	a0,@msg_ram+32,L
	move	a0,@msg_ram+64,L
	move	a0,@msg_ram+96,L

	movi	msg_ram,a9
	movk	4,a3			;# players
	movi	P1DATA,a0
mlp100
	move	*a0(ply_time),a1
	jrz	mlp103
	cmpi	3500,a1
	jrz	mlp103
;	subk	1,a1
	move	a1,*a0(ply_time)
	jrnz	mlp101

;somebody just let their timer expire!

mlp101
mlp103	addi	PDSIZE,a0
	dsj	a3,mlp100


	move	@msg_flop,a0
	XORK	1,a0
	move	a0,@msg_flop
	jrz	mlp105
;hide meter and turn on insert coin message if timer < 10
	movi	insert,a10
	calla	CR_CONTP		;Credits to cont
	jrlo	#no			;No?
	movi	start,a10
#no
	movi	msg_ram,a9
	movk	4,a3
#lp	move	*a9+,a2,L
	jrz	mlp110
	move	*a2(ply_meter_imgs),a0,L
	calla	OBJOFF

	move	*a2(ply_meter_imgs+32),a8,L
	move	a10,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

	movk	07h,a0 			;5
	move	a0,*a8(OYPOS)
	
;	move	*a2(ply_meter_imgs+64),a0,L
;	calla	OBJOFF

	dsj	a3,#lp

	jruc	mlp110


meters_t
	.long	0,TURBO_01b,TURBO_01g,TURBO_01y,TURBO_01r


mlp105
	movi	msg_ram,a9
	movk	4,a3
#lp2	move	*a9+,a2,L
	jrz	mlp110
	move	*a2(ply_meter_imgs),a0,L
	calla	OBJON

	move	*a2(ply_meter_imgs+32),a8,L
	move	a3,a0
	sll	5,a0
	addi	meters_t,a0
	move	*a0,a0,L

;	movi	METERg,a0			;change back to meter

	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

	movk	17,a0			;11
	move	a0,*a8(OYPOS)

;	move	*a2(ply_meter_imgs+64),a0,L
;	calla	OBJON

	dsj	a3,#lp2

mlp110
;;;;;;;	calla	prt_cr_timers	<- Did nothing!

;FIX!!!!
;Grab this rate from CMOS
	movi	80,a3			;Cr-timer rate of decline
mlp120	move	a3,@timertcnt

	rets


#*******************************
* Show tv score/time panel (Process)

 SUBR	score_showtvpanel2

	move	@tvpanelon,a0,L
	jrnz	#die

	move	a13,@tvpanelon,L
	movi	4*TSEC+10,a11		;12*
	move	@game_time,a0,L
	jrnz	scr1


	movi	3*TSEC+10+30,a11

	move	@gmqrtr,a0		;Ran out of time
	subk	4,a0
	jrlt	scr1
	move	@scores,a0
	move	@scores+16,a1
	cmp	a0,a1
	jreq	scr1



	movi	6*TSEC+10+30,a11
	jruc	scr1

 SUBR	score_showtvpanel

	move	@tvpanelon,a0,L
	jrnz	#die

	move	a13,@tvpanelon,L

	SLEEP	35			;TSEC*2

	movi	3*TSEC-40,a11

 SUBR	scr1
;	calla	pal_clean

	move	a13,@tvpanelon,L
	PUSH	A11
	move	@bclok_imgs,a0,L
	calla	ISOBJ
	jrz	tv2
	move	*a0(OIMG),a1,L
	cmpi	clock2,a1
	jrnz	tv2
	movk	1,a0			;=clock already on scrn
	jruc	tv3

tv2
	clr	a0
tv3	callr	tv_score  		;display big tv look score plate
	
	PULL	A0
	move	a11,a0
	calla	PRCSLP
	
	move	@game_time,a0,L		;clock expired while panel was up
	jrz	tv3a

#tv4	SLEEPK	1
	move	@HALT,a0
	jrnz	#tv4

tv3a	movi	CLSDEAD|tvid,a0
	calla	obj_del1c
	movi	CLSDEAD|tvscrid,a0
	calla	obj_del1c

	move	@game_time,a0,L		;clock expired while panel was up
	jrz	tv4

	movb	@game_time+24,a0
	jrz	#x

tv4	movi	tvid,a0			;Delete big clock at botm of scrn
	calla	KIL1C
	movi	CLSDEAD|bclockid,a0
	calla	obj_del1c

#x
	clr	a0
	move	a0,@tvpanelon,L

#die	DIE


#******************************************************************
* Redraw scoreboard credits message after a credit is registered.
* Service credit or other!  Called at other times also!
*
* Trashes scratch


 SUBR	update_scorebrd

;If scoreboard is on screen, not in free play, erase old credits digits
;and display new ones.  Also tell quarter timer balls not to show up
;for awhile.

;must be a better check for score board on screen!

	PUSH	a8,a11

	move	@GAMSTATE,a0
	subk	INGAME,a0
	jrne	xo

;	movi	40,a0
;	move	a0,@cr_delay

	movi	CLSDEAD|creditid,a0
	calla	obj_del1c		;Kill credit imgs
	callr	prt_credits		;Do updated credit imgs

	calla	CR_STRTP		;Have credits to start?
	movi	insert,a10		;Assume no (C unaffected)
	jrlo	#no_s			;No if < (if C set)
	movi	start,a10		;Yes
#no_s
	calla	CR_CONTP		;Have credits to continue?
	movi	insert,a11		;Assume no (C unaffected)
	movi	start,a3
	jrlo	#no_c			;No if < (if C set)
	move	a3,a11			;Yes
	movi	insert,a3
#no_c

***********************************************************

#us_p1
	move	@TWOPLAYERS,a0
	jrnz	#us_p2

	move	a10,a0
	move	@PSTATUS2,a4
	btst	0,a4
	jrz	#no_c1
	move	a11,a0			;A continue
#no_c1
	move	@P1DATA+ply_messages,a8,L
	jrz	#no_m1
	move	*a8(OIMG),a2,L
	cmp	a3,a2
	jrnz	#no_m1
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	jruc	#us_p2
#no_m1
	move	@P1DATA+ply_meter_imgs+32,a8,L
	jrz	#us_p2
	move	*a8(OIMG),a1,L
	cmpi	TURBO_01b,a1
	jrz	#us_p2
	cmp	a0,a1
	jrz	#us_p2			;already correct message
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

**********************************************************

#us_p2
	move	a10,a0
	move	@PSTATUS2,a4
	btst	1,a4
	jrz	#no_c2
	move	a11,a0
#no_c2
	move	@P2DATA+ply_messages,a8,L
	jrz	#no_m2
	move	*a8(OIMG),a2,L
	cmp	a3,a2
	jrnz	#no_m2
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	jruc	#us_p3
#no_m2
	move	@P2DATA+ply_meter_imgs+32,a8,L
	jrz	#us_p3
	move	*a8(OIMG),a1,L
	cmpi	TURBO_01g,a1
	jrz	#us_p3
	cmpi	TURBO_01b,a1
	jrz	#us_p3
	cmp	a0,a1
	jrz	#us_p3			;already correct message
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

***********************************************************

#us_p3
	move	a10,a0
	move	@PSTATUS2,a4
	btst	2,a4
	jrz	#no_c3
	move	a11,a0
#no_c3
	move	@P3DATA+ply_messages,a8,L
	jrz	#no_m3
	move	*a8(OIMG),a2,L
	cmp	a3,a2
	jrnz	#no_m3	      
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	jruc	#us_p4
#no_m3
	move	@P3DATA+ply_meter_imgs+32,a8,L
	jrz	#us_p4
	move	*a8(OIMG),a1,L
	cmpi	TURBO_01y,a1
	jrz	#us_p4
	cmpi	TURBO_01r,a1
	jrz	#us_p4
	cmp	a0,a1
	jrz	#us_p4			;already correct message
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

***********************************************************

#us_p4
	move	@TWOPLAYERS,a0
	jrnz	xo

	move	a10,a0
	move	@PSTATUS2,a4
	btst	3,a4
	jrz	#no_c4
	move	a11,a0
#no_c4
	move	@P4DATA+ply_messages,a8,L
	jrz	#no_m4
	move	*a8(OIMG),a2,L
	cmp	a3,a2
	jrnz	xo
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	jruc	xo
#no_m4
	move	@P4DATA+ply_meter_imgs+32,a8,L
	jrz	xo
	move	*a8(OIMG),a1,L
	cmpi	TURBO_01r,a1
	jrz	xo
	cmp	a0,a1
	jrz	xo
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

xo
	PULL	a8,a11
	rets

#****************************************************************
* Print credits or free play message in top score board
*
* Trashes a0-a7

 SUBR	prt_credits

	PUSH	a8,a9
	MOVK	ADJFREPL,A0
	CALLA	GET_ADJ 	;SEE IF FREEPLAY......(Z BIT CLEAR IF SO!)
	jrnz	freep

	calla	CRED_P
	sll	5,a0
	addi	#creds,a0
	move	*a0,a2,L
	movi	SCOREBRD_X+56,a0
	movk	SCOREBRD_Y+2,a1
	jruc	prt_cr
freep
	movi	FREEPLT,a2
	movi	SCOREBRD_X,a0
	movi	SCOREBRD_Y,a1
prt_cr
	movi	SCOREBRD_Z+1,a3
	sll	16,a0
	sll	16,a1
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD|creditid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	PULL	a8,a9
	rets

#creds	.long	CRED_00,CRED_00+9*16*01,CRED_00+9*16*02,CRED_00+9*16*03,CRED_00+9*16*04
	.long	CRED_00+9*16*05,CRED_00+9*16*06,CRED_00+9*16*07,CRED_00+9*16*08,CRED_00+9*16*09
	.long	CRED_00+9*16*10,CRED_00+9*16*11,CRED_00+9*16*12,CRED_00+9*16*13,CRED_00+9*16*14
	.long	CRED_00+9*16*15,CRED_00+9*16*16,CRED_00+9*16*17,CRED_00+9*16*18,CRED_00+9*16*19
	.long	CRED_00+9*16*20,CRED_00+9*16*21,CRED_00+9*16*22,CRED_00+9*16*23,CRED_00+9*16*24
	.long	CRED_00+9*16*25,CRED_00+9*16*26,CRED_00+9*16*27,CRED_00+9*16*28,CRED_00+9*16*29
	.long	CRED_00+9*16*30,CRED_00+9*16*31,CRED_00+9*16*32,CRED_00+9*16*33,CRED_00+9*16*34
	.long	CRED_00+9*16*35,CRED_00+9*16*36,CRED_00+9*16*37,CRED_00+9*16*38,CRED_00+9*16*39
	.long	CRED_00+9*16*40,CRED_00+9*16*41,CRED_00+9*16*42,CRED_00+9*16*43,CRED_00+9*16*44
	.long	CRED_00+9*16*45,CRED_00+9*16*46,CRED_00+9*16*47,CRED_00+9*16*48,CRED_00+9*16*49
	.long	CRED_00+9*16*50,CRED_00+9*16*51,CRED_00+9*16*52,CRED_00+9*16*53,CRED_00+9*16*54
	.long	CRED_00+9*16*55,CRED_00+9*16*56,CRED_00+9*16*57,CRED_00+9*16*58,CRED_00+9*16*59
	.long	CRED_00+9*16*60,CRED_00+9*16*61,CRED_00+9*16*62,CRED_00+9*16*63,CRED_00+9*16*64
	.long	CRED_00+9*16*65,CRED_00+9*16*66,CRED_00+9*16*67,CRED_00+9*16*68,CRED_00+9*16*69
	.long	CRED_00+9*16*70,CRED_00+9*16*71,CRED_00+9*16*72,CRED_00+9*16*73,CRED_00+9*16*74
	.long	CRED_00+9*16*75,CRED_00+9*16*76,CRED_00+9*16*77,CRED_00+9*16*78,CRED_00+9*16*79
	.long	CRED_00+9*16*80,CRED_00+9*16*81,CRED_00+9*16*82,CRED_00+9*16*83,CRED_00+9*16*84
	.long	CRED_00+9*16*85,CRED_00+9*16*86,CRED_00+9*16*87,CRED_00+9*16*88,CRED_00+9*16*89
	.long	CRED_00+9*16*90,CRED_00+9*16*91,CRED_00+9*16*92,CRED_00+9*16*93,CRED_00+9*16*94
	.long	CRED_00+9*16*95,CRED_00+9*16*96,CRED_00+9*16*97,CRED_00+9*16*98,CRED_00+9*16*99

#numbs	.long	font60,font61,font62,font63,font64
	.long	font65,font66,font67,font68,font69


****************************************************************
* Start main game clock

 SUBR	clock_strt

	movi	ADJSPEED,a0		;Get game clk speed (1-5)
	calla	GET_ADJ
	move	a0,@CMOS_clock_speed

	clr	a0
	move	a0,@tvpanelon,L
	move	a0,@ballflash

	callr	prt_credits
	callr	prt_qrtr

	movi	clock_imgs,a10
	movi	#init_t,a11		;>Setup status images
	jruc	#status
#lp
	move	*a11+,a1		;Y
	move	*a11+,a3		;Z
	move	*a11+,a2,L		;*IMG
	sll	16,a0
	sll	16,a1
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4	;M_3DQ
	movi	CLSDEAD|gclockid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a0,*a10+,L
;	movi	gndpos_t+32*16,a1
;	move	a1,*a8(ODATA_p),L

#status	move	*a11+,a0		;X
	cmpi	4000,a0
	jrne	#lp			;!End?

	movk	1,a0			;Make clk inactive
	move	a0,@clock_active

;----------
; Top of clock loop

#lp1	calla	prt_top_clock		;Update clk
#lp1a	SLEEPK	1
	move	@HALT,a0
	jrnz	#lp1a

	.if DEBUG | DUNKTST
	move	@CLOCK_OFF,a0	;When testing dunks - PUT IN!
	jrnz	#lp1a
	.endif

	.if	IMGVIEW
	jruc	#lp1a			;Debug - no time clk on
	.endif

	move	@clock_active,a0	;Clk stopped (inbounding)? Yes if !0
	jrnz	#lp1a

;We shouldn't do this GET_ADJ during game loop!
;Get at start of game 1 time only!
;	movi	ADJSPEED,a0		;Get game clk speed (1-5)
;	calla	GET_ADJ

	move	@CMOS_clock_speed,a0	;RAM copy of CMOS adjustment

	sll	4,a0
	addi	timer_table-16,a0
	move	*a0,a1
	move	@PSTATUS,a0
	cmpi	>f,a0			;Is it a 4 plyr game? No if !0
	jrnz	#not4
	addi	200h,a1			;100h;Yes. Make clk run faster!
#not4
;	movi	>ffff,a1		;Debug - make clk super fast!

	move	@clock_speed,a0		;Add to clk speed frac
	add	a1,a0
	move	a0,@clock_speed
	jrnc	#lp1a			;Time for a clk tick? No if !C

	movi	game_time,a10

	movb	*a10,a0			;Get 10ths byte
	jrz	#tag			;Full sec? Yes if 0
	dec	a0			;No. Dec 10ths
	movb	a0,*a10
	move	*a10,a0,L		;Chk if qrtr over. Yes if 0
	jrz	#qtrend
	srl	32-8,a0			;Under a min left?
	jrnz	#lp1a			;No if !0 - no clk update
	jruc	#lp1			;Update clk
#tag	
	movk	9,a0			;Reset 10ths
	movb	a0,*a10

	movb	*a10(1*8),a0		;Get secs byte
	jrz	#tag1			;Full ten? Yes if 0
	dec	a0			;No. Dec secs
	movb	a0,*a10(1*8)
	jruc	#lp1			;Update clk
#tag1
	movk	9,a0			;Reset secs
	movb	a0,*a10(1*8)

	movb	*a10(2*8),a0		;Get tens byte
	jrz	#tag2			;Full min? Yes if 0
	dec	a0			;No. Dec tens
	movb	a0,*a10(2*8)
	jruc	#lp1			;Update clk
#tag2	
	movk	5,a0			;Reset tens
	movb	a0,*a10(2*8)

	movb	*a10(3*8),a0		;Get mins byte
	cmpi	3,a0			;Time to adjust drone skills?
	jrhs	#nodaj			;No if >=

;MJT Start
	cmpi	1,a0
	jrnz	#reg
	LOCKUP
;Bong clock on outside court at 1 minute
;	.ref	pup_court
;	move	@pup_court,a14
;	jrz	#reg
 	.ref	chrch_bel_sp
	SOUND1	chrch_bel_sp
#reg
	movb	*a10(3*8),a0		;Get mins byte
;MJT End


	.ref	drone_adjskill
	calla	drone_adjskill		;Yes. Pass A0
#nodaj
	movb	*a10(3*8),a0		;Get mins byte & dec it
	dec	a0
	movb	a0,*a10(24)
	jrnz	#lp1			;Update clk if more than a min left

;Rearrange top clock to allow tenths

	move	@clock_imgs,a0,L
	move	@clock_imgs+32,a1,L
	move	*a0(OXPOS),a14
	move	a14,*a1(OXPOS)
	move	*a1(OSIZEX),a1
	add	a1,a14
	move	a14,*a0(OXPOS)
	calla	prt_top_clock		;Update clk

	CREATE0	tick_tock		;Qrtr almost over sounds
	CREATE0	one_min_to_go

;Possibly rearrange bottom clock

	move	@bclok_imgs,a0,L	;Screen bottom clk on?
	calla	ISOBJ
	jrnz	#bclkon
	CREATE	tvid,scr_clock		;No. Turn on bottom clk

	SLEEPK	2

	move	@bclok_imgs,a0,L
#bclkon
	move	*a0(OIMG),a1,L		;Is bottom clk min:sec or sec:10th?
	cmpi	clock,a1
	jrnz	#lp1			;Assume sec:10th if !0

;Rearrange bottom clock to allow tenths

	move	a0,a8			;Make bottom clk sec:10th
	movi	clock2,a0
	move	*a8(OCTRL),a1
	calla	obj_aniq

	move	@bclok_imgs+32,a1,L
	movi	>136-15,a0
	move	a0,*a1(OXPOS)
	move	@bclok_imgs+64,a1,L
	movi	>116-10,a0
	move	a0,*a1(OXPOS)
	move	@bclok_imgs+96,a1,L
	movi	>120-10,a0
	move	a0,*a1(OXPOS)
	jruc	#lp1			;Update clk

;----------
; Quarter ended.
;
; Rearrange clock imgs back to min:sec

#qtrend
	clr	a0
	calla	drone_adjskill
	move	@clock_imgs,a0,L
	move	@clock_imgs+32,a1,L
	move	*a1(OXPOS),a14
	move	a14,*a0(OXPOS)
	move	*a0(OSIZEX),a0
	add	a0,a14
	move	a14,*a1(OXPOS)

	movk	1,a0			;Make clk inactive
	move	a0,@clock_active
	clr	a0
	move	a0,@clock_speed		;Reset clk speed frac
	move	a0,@game_time,L		;Make clk 0:00.0
	calla	prt_top_clock		;Update clk

	move	@tvpanelon,a0,L		;Is tv panel on? Yes if !0
	jrnz	#tag3
	movi	tvid,a0			;No. Delete bottom clk that is on
	calla	KIL1C			; screen by itself
	movi	CLSDEAD|bclockid,a0
	calla	obj_del1c
#tag3
	SOUND1	horn_snd

	move	@_4plyrsingame,a0
	jrnz	#skip
	move	@PSTATUS,a0
	cmpi	>f,a0			;Is it a 4 plyr game? Yes if 0
	jrz	#skip
	movk	1,a0
	move	a0,@_4plyrsingame
#skip
	move	@_2plyr_competitive,a0
	jrnz	#skip1			;br=not 2 plr competitive
	move	@PSTATUS,a0
	cmpi	1111b,a0
	jreq	#skip1			;br=2 plyr competitive
	cmpi	1010b,a0
	jreq	#skip1			;br=2 plyr competitive
	cmpi	1001b,a0
	jreq	#skip1			;br=2 plyr competitive
	cmpi	0110b,a0
	jreq	#skip1			;br=2 plyr competitive
	cmpi	0101b,a0
	jreq	#skip1			;br=2 plyr competitive
	movk	1,a0
	move	a0,@_2plyr_competitive
#skip1
	JSRP	plyr_endofqrtr

 SUBR	cliplockretp			;Restore point for clip lockup code

	movk	1,a0			;Make clk inactive
	move	a0,@clock_active

	movi	P1DATA,a11		;Refill turbo meters between qrtrs
	callr	refill_turbo
	movi	P2DATA,a11
	callr	refill_turbo
	movi	P3DATA,a11
	callr	refill_turbo
	movi	P4DATA,a11
	callr	refill_turbo

	callr	prt_qrtr		;Update score plate

	movi	QRTRTIME,a0		;>Regular qrtr time
	move	@gmqrtr,a1
	subk	4,a1			;In an OT qrtr? No if <
	jrlt	#regqtr

; Setup for OT quarter

;	SOUND1	intoot_snd

	move	@tvpanelon,a0,L		;Is tv panel on? No if 0
	jrz	#skp
	calla	process_exist		;Yes. Its process better exist!
	jrz	#tvpwt
	movi	tv3a,a7			;Turn off tv panel
	calla	XFERPROC
#tvpwt
	SLEEPK	1
	move	@tvpanelon,a0,L		;Wait for tv panel to turn off
	jrnz	#tvpwt
#skp	
;;;;	movk	1,a0		;>OT qrtr time
	movi	QRTRTIME,a0		;>OT qrtr time

; Common setup for regular & OT quarter

#regqtr
	move	a0,@game_time,L

;Make sure alley oop cnt
	clr	a0			;3 successful drone alley oops/period
	move	@plyrproc_t,a14,L
	move	a0,*a14(plyr_alley_cnt)
	move	@plyrproc_t+32,a14,L
	move	a0,*a14(plyr_alley_cnt)
	move	@plyrproc_t+64,a14,L
	move	a0,*a14(plyr_alley_cnt)
	move	@plyrproc_t+96,a14,L
	move	a0,*a14(plyr_alley_cnt)

	CREATE	tvid,scr_clock

	move	@gmqrtr,a0
	subk	2,a0
	jrnz	#tag4
	CREATE0	do_show
#tag4
	callr	start_qrtr_tune
	SLEEPK	1
	calla	start_crowd_noise

	jruc	#lp1			;Reenter main loop


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	start_qrtr_tune

	.ref	pup_nomusic,tuneend_snd
	move	@pup_nomusic,a14
	jrz	#play
	move	@GAMSTATE,a14
	subk	INAMODE,a14
	jrz	#play
	SOUND1	tuneend_snd
	move	@gmqrtr,a14
	jrnz	#noplay
	.ref	hangtime_snd
	SOUND1	hangtime_snd
#noplay
	rets
#play
	move	@balltmshotcnt,a14	;Is it a team on-fire?
	subk	TMFIRE_MINCNT,a14
	jrlt	#no			; br=no
	SOUND1	tm_fire_tune
	rets
#no
	move	@gmqrtr,a0
	jrnz	#not1
	SOUND1	tuneq1_snd
	rets

#not1	cmpi	tune_tc,a0
	jrle	#tag5
	movk	tune_tc,a0
#tag5
	sll	5,a0
	addi	tune_t-32,a0
	move	*a0,a0,L
	calla	snd_play1
	rets


tune_t	.long	tuneq2_snd,tuneq3_snd,tuneq4_snd,tuneot_snd
tune_tc	.equ	($-tune_t)/32




;----------
;

 SUBRP do_show

	SLEEP	120
	SOUND1	showtm
	DIE


;----------
; Gets created at 1 minute mark in each quarter!

 SUBRP one_min_to_go

	SLEEPK	1
	SOUND1	minute_sp
	jrc	one_min_to_go
	DIE


;----------
; Gets created at 1 minute mark in each quarter!

 SUBRP tick_tock

	SLEEP	10*60			;Wait before able to do sounds
#tick
	SLEEP	36
	move	@game_time,a0,L		;Qrtr over? Yes if 0
	jaz	SUCIDE
	srl	16,a0			;Under 10 secs left? No if !0
	jrnz	#tick
	move	@clock_active,a0	;Yes. Clk active? No if !0
	jrnz	#tick

	movi	tick_snd,a0		;Yes. Do tick or tock sound
;	XORK	1,a9
;	jrz	#tok
;	movi	tock_snd,a0
;#tok
	calla	snd_play1
	jruc	#tick


;----------
; Clock/scores init table

	.asg	SCOREBRD_X,X
	.asg	SCOREBRD_Y,Y
	.asg	SCOREBRD_Z,Z
#init_t
;minutes, seconds
	.word	X+21,Y+23,Z
	.long	MINCOL00
	.word	X+33,Y+23,Z
	.long	LED_00
;scores
	.word	X+5, Y+11,Z
	.long	LED_00
	.word	X+49,Y+11,Z
	.long	LED_00

	.word	4000


#****************************************************************
*

prt_qrtr
	move	@gmqrtr,a2
	cmpi	qrtrt_c,a2
	jrlt	#do_ot
	movk	4,a2			;!!!Default for OT overflow
#do_ot
	sll	5,a2
	addi	qrtrt1,a2
	move	*a2,a2,L
	move	@crplate_ptr,a3,L
	move	a2,*a3(OIMG),L
	move	*a2(ISAG),*a3(OSAG),L

	rets


qrtrt1	.long	QUARTR01,QUARTR02,QUARTR03,QUARTR04
	.long	OT01,OT02,OT03,OT04
qrtrt_c	.equ	($-qrtrt1)/32


;	movi	CLSDEAD|qrtrid,a0
;	calla	obj_del1c		;kill credit/qrtr imgs
;
;	movi	[SCOREBRD_X+24,0],a0
;	movi	[SCOREBRD_Y+25,0],a1
;	movi	SCOREBRD_Z+1,a3
;	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
;
;	move	@gmqrtr,a2
;	cmpi	qrtrt_c,a2
;	jrlt	#do_ot
;	movk	4,a2
;#do_ot
;	sll	5,a2
;	addi	qrtrt1,a2
;	move	*a2,a2,L
;	movi	CLSDEAD|qrtrid,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;
;;;	move	a0,*a10+,L
;;	movi	gndpos_t+32*16,a1
;;	move	a1,*a8(ODATA_p),L
;
;	rets
;
;	.long	qrtr1,qrtr2,qrtr3,qrtr4,qrtr4,qrtr4,qrtr4
;	.long	qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4
;	.long	qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4

		
**************************************************************************
* Completely refill turbo meter
*
* a11=PxDATA

 SUBR	refill_turbo
	movk	1,a1
	move	a1,*a11(ply_turbo_dl)		;Reset turbo cnt delay

	movi	TURBO_CNT-1,a1			;!!! Max turbo meter
	move	a1,*a11(ply_turbo)
	sll	5,a1
	addi	TURBO_52,a1			;TURBO_60
	move	*a11(ply_meter_imgs+32),a2,L
	move	*a1(0),*a2(OSAG),L

	rets

;	clr	a2
;	cmpi	P1DATA,a11
;	jrz	#1
;	movk	1,a2
;	cmpi	P2DATA,a11
;	jrz	#1
;	movk	2,a2
;	cmpi	P3DATA,a11
;	jrz	#1
;	movk	3,a2
;#1
;
;
;;	move	@PSTATUS,a1
;;	btst	a2,a1
;;	jrz	#notingame
;
;	move	*a11(ply_meter_imgs+40h),a2,L	;LITUP img 
;	clr	a1
;	move	a1,*a2(OFSET)
;	movi	>2f,a2	;2f	 		;OSIZEX of litup meter img
;	move	a2,*a11(ply_turbo)		;max out turbo meter
;	movk	1,a2
;	move	a2,*a11(ply_turbo_dl)		;turbo cnt delay
;
;;#notingame
;	rets


**************************************************************************
* Replenish turbo meter
*
* a0=PxDATA
* Destroys A1,A2

 SUBRP	replenish_turbo
	move	*a0(ply_turbo),a1
	cmpi	TURBO_CNT-1,a1			;!!! Max turbo meter
	jrz	#x
	addk	1,a1
	move	a1,*a0(ply_turbo)
	sll	5,a1
	.def	TURBO_52
	addi	TURBO_52,a1			;TURBO_60
	move	*a0(ply_meter_imgs+32),a2,L
	move	*a1(0),*a2(OSAG),L
#x
	rets

;	move	*a0(ply_meter_imgs+32),a2,L	;LITUP img 
;	move	*a2(OFSET),a1			;Need to shrink LITUP img
;	jrz	#x
;	subk	1,a1
;	move	a1,*a2(OFSET)
;	move	*a0(ply_turbo),a1
;	addk	1,a1
;	move	a1,*a0(ply_turbo)
;#x
;	rets


********************************
* A0=*scores
* A1=# to add

 SUBR	score_add

	move	a1,@clock_active
	move	a0,@last_score,L		;Most recent team to score
						;used for red flash
	move	*a0,a14
	add	a1,a14
	move	a14,*a0

	PUSH	a1,a7,a9

	move	@ballpnumshot,a9
	move	@plyr_onfire,a0
	btst	a9,a0
	jrz	#noaud				;br=not on fire

	movi	AUD_HOTSTRKPTS,a0		;Audit plyr on-fire pts
	.ref	ballnumscored
	move	@ballnumscored,a14		;Was it a plyr on-fire?
	subk	ONFIRE_MINCNT,a14
	jrnn	#aud				; br=yes
	movi	AUD_TM_FIRE_PTS,a0		;Audit team on-fire pts
#aud
	move	@GAMSTATE,a14
	cmpi	INAMODE,a14			;Don't audit if in attract
	jrz	#noaud
	calla	AUD
#noaud
	move	a1,a10
     	CREATE	CYCPID,flsh_bgnd
	CREATE0	start_animate

	move	@assist_plyr,a1
	jrz	#sx
	dec	a1

;;TEAM METER logic
;	movk	2,a14
;	.ref	update_team_meter
;	calla	update_team_meter

	movk	PS_ASSISTS,a0
	calla	inc_player_stat
#sx
	PULL	a1,a7,a9

	rets

;--------------------
; a9=plyr # 0-3
; a10=# of pts scored

flsh_bgnd
	SLEEPK	20

	move	@game_time,a0,L
	jaz	SUCIDE

	sll	4,a9				;Get obj XVAL per plyr #
	addi	#x_t,a9
	move	*a9,a0
	sll	16,a0
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4	;Set other obj K's
	movi	CLSDEAD,a5
	clr	a6
	clr	a7

	cmpi	3,a10			;How many pts scored?
	jrnz	#not3

	clr	a1			;Do 3 ptr animation
	movi	THREPNTS,a2
	movi	>7590,a3
	calla	BEGINOBJ2

	SLEEPK	1
;FIX!!!  Get new sound...
;	.ref	win_snd
;	SOUND1	win_snd

	SLEEPK	19
	movk	5,a9
#f30
	movk	10,a10
	movi	THREP1,a11
#f31
	move	@game_time,a0,L
	jrz	#fout
	move	*a11+,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)
	SLEEPK	2
	dsj	a10,#f31
	dsj	a9,#f30

	SLEEPK	20

	jruc	#fout

;	movi	>0101,a2
;	move	a2,*a8(OCONST)
;
;	movk	14,a10
;#f30
;	move	@game_time,a0,L
;	jrz	#fout
;	callr	const_on
;	SLEEPK	4
;	callr	const_off
;	SLEEPK	7
;	dsj	a10,#f30
;
;	jruc	#fout

#not3
	clr	a1			;Do 2 ptr animation
	movi	bbal_w,a2
	movi	290,a3
	calla	BEGINOBJ2
	movk	8,a10
#f1
	move	@game_time,a0,L
	jrz	#fout
	move	a8,a0
	calla	OBJON
	SLEEPK	3
	move	a8,a0
	calla	OBJOFF
	SLEEPK	3
	dsj	a10,#f1

#fout
	move	a8,a0
	calla	DELOBJ
	calla	pal_clean

	DIE

#x_t
	.word	9,59h,0ebh,13bh


;--------------------
;

 SUBR	bracket_drw

	clr	a0
	movi	[1,0],a1
	movi	bbal,a2				;bracket
	movi	290,a3				;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

#set	move	@ballpnum,a0
	jrn	#frbl
	sll	4,a0
	addi	#x_t2,a0
	move	*a0,a0
	move	a0,*a8(OXPOS)
	SLEEPK	3
	jruc	#set
#frbl	move	a8,a0
	calla	OBJOFF

#frlp	SLEEPK	3

	move	@ballpnum,a0
	jrn	#frlp
	move	a8,a0
	calla	OBJON
	jruc	#set

#x_t2
	.word	9,59h,0ebh,13bh


**************************************************************************
*
	
 SUBRP	prt_top_clock

	PUSH	a2,a3,a4,a5,a6,a7,a8

	movi	#mincol,a0
	move	@game_time,a1,L			;print minutes
	jrz	#tag4
	srl	32-8,a1
	jrnz	#tag4
	movi	#tenths,a0
	movb	@game_time+0,a1			;print 10ths of sec
#tag4
	sll	5,a1
	add	a1,a0
	move	*a0,a0,L
	move	@clock_imgs,a8,L
	move	*a8(OCTRL),a1
	calla	obj_aniq

	movb	@game_time+16,a0		;print secs
	move	a0,a1
	sll	3,a0
	sll	1,a1
	add	a1,a0
	movb	@game_time+8,a1
	add	a1,a0
	cmpi	10,a0
	jrhs	#tag5
	addi	SCOREMAX+1,a0
#tag5
	sll	5,a0
	addi	LED_0,a0
	move	*a0,a0,L
	move	@clock_imgs+32,a8,L
	move	a0,*a8(OSAG),L

	PULL	a2,a3,a4,a5,a6,a7,a8
	rets

#mincol	.long	MINCOL00,MINCOL01,MINCOL02,MINCOL03

#tenths	.long	TENTHS00,TENTHS01,TENTHS02,TENTHS03,TENTHS04
	.long	TENTHS05,TENTHS06,TENTHS07,TENTHS08,TENTHS09

;leds	.long	S_LED_0,S_LED_1,S_LED_2,S_LED_3,S_LED_4
;	.long	S_LED_5,S_LED_6,S_LED_7,S_LED_8,S_LED_9


;********************************************************************
;* Print all 4 players credit timers if in game
;* Trashes scratch, A9
;
; SUBR	prt_cr_timers
;
;	rets				;Big NOP - not longer needed!!!
;
;	PUSH	a8,a11
;
;
;	movi	P1DATA,a9
;	clr	a11
;prt05	move	@PSTATUS,a0		;Plyr start bits 0-3
;	btst	a11,a0
;	jrz	#nxt
;
;;Check to see if player name is in place of credit timer!  If so, don't try
;;to print out timers
;
;	move	*a9(ply_meter_imgs),a8,L
;	jrz	#nxt
;
;	move	*a8(OIMG),a0,L
;	cmpi	LED_00,a0
;	jrne	#nxt			;Not counter?
;
;	move	*a9(ply_time),a0
;	cmpi	1000,a0
;	jrlo	prt07
;;	movi	999,a0
;	movi	LED_MAX,a0
;	jruc	prt09
;prt07
;	sll	5,a0
;	addi	LED_0,a0
;prt09	move	*a0,a0,L
;	move	a0,*a8(OSAG),L
;
;#nxt	addi	PDSIZE,a9
;	inc	a11
;	cmpi	4,a11
;	jrnz	prt05
;
;	PULL	a8,a11
;	rets


#***********************************************************************
* Print small scores at top of screen

 SUBR	prt_top_scores

	PUSH	a2,a3,a4,a5,a6,a7,a8
	movi	SCOREMAX,a2

	move	@score_imgs,a8,L	;Team 1
	move	@scores,a0
	cmp	a2,a0
	jrlo	#smax1
	move	a2,a0
#smax1
	sll	5,a0
	addi	LED_0,a0
	move	*a0,a0,L
	move	a0,*a8(OSAG),L

	move	@score_imgs+32,a8,L	;Team 2
	move	@scores+16,a0
	cmp	a2,a0
	jrlo	#smax2
	move	a2,a0
#smax2
	sll	5,a0
	addi	LED_0,a0
	move	*a0,a0,L
	move	a0,*a8(OSAG),L


	move	@tvpanelon,a0,L
	jrz	#x
	movi	3*60,a1			;Add time to score plate proc!
	move	a1,*a0(PTIME)

	callr	prt_bigscr

	CREATE0	flash_red

#x	PULL	a2,a3,a4,a5,a6,a7,a8
	rets


#****************************************************************
* Turn on T.V. look score plate at the bottom of the screen.
* Handle game clock, quarter #, team names, and score.  Then turn
* off everything except maybe the game time.
*

 SUBRP	tv_score

;Jeff, when you turn this pc on, use a BEGINOBJP because it has no pal
;in its header...
;---> TUBEPIEC

;	rets

	move	a0,a0
	jrnz	tv4x				;br=clock already on scrn
	CREATE	tvid,scr_clock
tv4x
;	movi	[9,0],a0
	clr	a0
;	movi	[185,0],a1
	movi	[0e7h,0],a1
	movi	5000,a3
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
;	movi	metal1,a2
	movi	LOGOTUBE,a2
	movi	CLSDEAD|tvid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	clr	a0
	movi	[0e7h,0],a1
;	movi	metal2,a2
	movi	SCORTUBE,a2
	calla	BEGINOBJ2

	movi	[186+45,0],a1
	move	@gmqrtr,a2
	sll	5,a2

	movi	5002,a3

	move	@game_time,a0,L
	jrnz	#notend

	move	@scores,a4
	move	@scores+16,a0
	cmp	a0,a4
	jrnz	#notie
;tie score
	addi	tie_eqrtrt,a2
	jruc	#tie
#notie
	addi	eqrtrt,a2
#tie
;	movi	[9,0],a0
	clr	a0
	move	*a2,a2,L
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	calla	BEGINOBJ2
	jruc	#skip


#notend
	addi	qrtrt,a2
	movi	[-9,0],a0
	move	*a2,a2,L
	calla	BEGINOBJ2
#skip
	movi	[66,0],a0
	movi	[181,0],a1
	move	@team1,a2
;;	cmpi	27,a2
	cmpi	NUM_TEAMS,a2
	jrnz	#reg
;FIX!!!
;Special team named JAM
	movi	NUM_TEAMS,a2

;	movi	[185-3,0],a1
;	movi	OSGEMD_J,a2
;	movi	GREENPAL,b0
;	calla	BEGINOBJP2
;	movi	[4ch,0],a0
;	movi	[185-3,0],a1
;	movi	OSGEMD_A,a2
;	movi	GREENPAL,b0
;	calla	BEGINOBJP2
;	movi	[5bh,0],a0
;	movi	[185-3,0],a1
;	movi	OSGEMD_M,a2
;	movi	GREENPAL,b0
;	calla	BEGINOBJP2
	jruc	#nx
#reg	
	sll	5,a2
	addi	team_nms,a2
	move	*a2,a2,L
	calla	BEGINOBJ2

#nx
	movi	[66,0],a0
	movi	[185+20,0],a1
	move	@team2,a2

	cmpi	NUM_TEAMS,a2
;;	cmpi	27,a2
	jrnz	#reg2

;FIX!!!
;Special team named JAM
	movi	NUM_TEAMS,a2

;	movi	[185+18,0],a1
;	movi	OSGEMD_J,a2
;	movi	GREENPAL,b0
;	calla	BEGINOBJP2
;	movi	[4ch,0],a0
;	movi	[185+18,0],a1
;	movi	OSGEMD_A,a2
;	movi	GREENPAL,b0
;	calla	BEGINOBJP2
;	movi	[5bh,0],a0
;	movi	[185+18,0],a1
;	movi	OSGEMD_M,a2
;	movi	GREENPAL,b0
;	calla	BEGINOBJP2
;	jruc	#nx2
#reg2

	sll	5,a2
	addi	team_nms,a2
	move	*a2,a2,L
	calla	BEGINOBJ2
#nx2
	callr	prt_bigscr			;score routine will update
						;these big digits
	CREATE0	flash_red
	rets


team_nms
	.long	ATL,BOST,CHAR,CHI,CLEV,DAL,DEN,DET,GOLDN,HOU,IND,LA_CLIP
	.long	LA_LAKS,MIAMI,MILW,MINN,NJ,NY,ORL,PHIL,PHX,PORT,SAC,SANANT
	.long	SEA,TORO,UTAH,VANC,WASH,WASH,WASH,WASH


********************************

const_on
	setf	4,0,0
	movk	M_CONNON,a0		;Replace non-zero data with constant
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0
	rets


const_off
	setf	4,0,0
	movk	M_WRNONZ,a0
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0
	rets


********************************

flash_red

	SLEEPK	10
	clr	a9	
	move	@last_score,a0,L
	jaz	SUCIDE
	cmpi	scores,a0
	jrz	#tm1
	movi	96,a9
#tm1	movk	10,a11
	addi	flsh_ptrs,a9
#lp
;	movi	MD_16r,a0
	movi	BST18R_P,a0
	calla	pal_getf
	move	*a9,a8,L
	move	a0,*a8(OPAL)
	move	*a9(32),a8,L
	move	a0,*a8(OPAL)
	move	*a9(64),a8,L
	move	a0,*a8(OPAL)
	SLEEPK	5
	movi	BST18W_P,a0
;	movi	MD_16,a0
	calla	pal_getf
	move	*a9,a8,L
	move	a0,*a8(OPAL)
	move	*a9(32),a8,L
	move	a0,*a8(OPAL)
	move	*a9(64),a8,L
	move	a0,*a8(OPAL)
	SLEEPK	5
	dsj	a11,#lp

	clr	a0
	move	a0,@last_score,L
	DIE
		
	

#************************************************************************
* Print big score digits that are part of the tv score panel
* Trashes scratch, A2-A8

 SUBRP	prt_bigscr

	PUSH	a9,a10

	clr	a0
	movi	flsh_ptrs,a1
	move	a1,a10
	movk	6,b0
#clp	move	a0,*a1+,L
	dsj	b0,#clp


	movi	CLSDEAD|tvscrid,a0
	calla	obj_del1c


	movi	5000,a3
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD|tvscrid,a5
	clr	a6
	clr	a7


	move	@scores,a0		;Team 1
	calla	BINBCD
	move	a0,a9

	srl	8,a0			;>Hundereds
	jrz	#nohun

	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#n_t,a0
	move	*a0,a2,L

	movi	[309-16+3,0],a0
	movi	[184+1-4,0],a1
	movi	BST18W_P,b0
	calla	BEGINOBJP2
	move	a8,*a10,L
#nohun
	addk	32,a10

	move	a9,a0			;>Tens
	srl	4,a0
	jrz	#notens

	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#n_t,a0
	move	*a0,a2,L

	movi	[326-16+3,0],a0
	movi	[184+1-4,0],a1
	movi	BST18W_P,b0
	calla	BEGINOBJP2
	move	a8,*a10,L
#notens
	addk	32,a10

	sll	32-4,a9			;>Ones
	srl	32-4-5,a9		;*32
	addi	#n_t,a9
	move	*a9,a2,L

	movi	[343-16+3,0],a0
	movi	[184+1-4,0],a1
	movi	BST18W_P,b0
	calla	BEGINOBJP2
	move	a8,*a10+,L



	move	@scores+16,a0		;Team 2
	calla	BINBCD
	move	a0,a9

	srl	8,a0			;>Hundereds
	jrz	#nohun2

	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#n_t,a0
	move	*a0,a2,L

	movi	[309-16+3,0],a0
	movi	[204+1,0],a1
	movi	BST18W_P,b0
	calla	BEGINOBJP2
	move	a8,*a10,L
#nohun2
	addk	32,a10

	move	a9,a0			;>Tens
	srl	4,a0
	jrz	#notens2

	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#n_t,a0
	move	*a0,a2,L

	movi	[326-16+3,0],a0
	movi	[204+1,0],a1
	movi	BST18W_P,b0
	calla	BEGINOBJP2
	move	a8,*a10,L
#notens2
	addk	32,a10

	sll	32-4,a9			;>Ones
	srl	32-4-5,a9		;*32
	addi	#n_t,a9
	move	*a9,a2,L

	movi	[343-16+3,0],a0
	movi	[204+1,0],a1
	movi	BST18W_P,b0
	calla	BEGINOBJP2
	move	a8,*a10+,L

	PULL	a9,a10

	rets

#n_t
	.long	SCOR18_0,SCOR18_1a,SCOR18_2,SCOR18_3,SCOR18_4,SCOR18_5,SCOR18_6
	.long	SCOR18_7,SCOR18_8,SCOR18_9


#************************************************************************
* Turn on three images for big clock portion of TV score plate
* Start a process which updates these imgs
* That process must die when other tv score stuff is deleted!
*
 SUBRP	scr_clock

	movi	#init_t,a11
	movi	bclok_imgs,a10			;for holding onto img pointer
	move	@game_time,a5,L
	srl 	24,a5
	jrnz	#status
;	jrnz	reg
	movi	#init_t2,a11
	jruc	#status
;reg	movi	#init_t,a11
;	jruc	#status
#lp
	move	*a11+,a1
	sll	16,a0
	sll	16,a1
	move	*a11+,a3
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	move	*a11+,a2,L
	movi	CLSDEAD|bclockid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a0,*a10+,L			;hold onto img pointer

#status	move	*a11+,a0			;X
	cmpi	4000,a0
	jrne	#lp				;!End?

	callr	prt_tvtime
	movi	gclockid,a0
	clr	a1
	not	a1
	calla	EXISTP
	jrz	#lp1


	move	@game_time,a1,L
	jrz	#lp1


	movk	3,a1
	move	a1,*a0(PTIME)			;get in sync with top clock
	SLEEPK	3
#lp1
	callr	prt_tvtime
	SLEEPK	3

	jruc	#lp1


 SUBRP	prt_tvtime	

	movb	@game_time+24,a0		;print minutes
	jrnz	#tag4
	movb	@game_time+0,a0			;print 10ths of sec
#tag4	sll	5,a0
	addi	numbs,a0
	move	*a0,a0,L
	move	@bclok_imgs+>20,a8,L
	move	*a8(OCTRL),a1
	calla	obj_aniq

	movb	@game_time+16,a0		;print 10 secs
	sll	5,a0
	addi	numbs,a0
	move	*a0,a0,L
	move	@bclok_imgs+>40,a8,L
	move	*a8(OCTRL),a1
	calla	obj_aniq

	movb	@game_time+8,a0			;print secs
	sll	5,a0
	addi	numbs,a0
	move	*a0,a0,L
	move	@bclok_imgs+>60,a8,L
	move	*a8(OCTRL),a1
	calla	obj_aniq
	rets

#init_t
	.word	2-10,185+46,5010
	.long	clock
	.word	305-26-10,230,5020
	.long	BRSH12_0
	.word	315-21-10,230,5020
	.long	BRSH12_0
	.word	325-21-10,230,5020
	.long	BRSH12_0
	.word	4000

#init_t2
	.word	2-10,185+46,5010
	.long	clock2
	.word	>130-10,230,5020
	.long	BRSH12_0
	.word	>116-10,230,5020
	.long	BRSH12_0
	.word	>120-10,230,5020
	.long	BRSH12_0
	.word	4000

qrtrt	.long	one,two,three,four,overtime,DoubleOT,TripleOT,TripleOT
	.long	TripleOT,final
eqrtrt	.long	endof1,endof1,halftime,endof3,final,final,final,final,final
	.long	final,final,final,final
tie_eqrtrt
	.long	endof1,endof1,halftime,endof3,endof4,overtime,DoubleOT,TripleOT
	.long	TripleOT,TripleOT,TripleOT,TripleOT,TripleOT,TripleOT


#****************************************************************
* Team on-fire timer
* A9=team on fire (!0=team 1, 0=team 2)
* Trashes scratch

 SUBR	tmfire_timer

	.ref	tm_onfire_sp
	SOUND1	tm_onfire_sp
	CREATE0	tm_zone_msg
	SLEEPK	3

	move	a9,a11

	move	@pup_nomusic,a14
	jrz	#play
	move	@GAMSTATE,a14
	subk	INAMODE,a14
	jrnz	#noplay
#play
	SOUND1	tm_fire_tune
#noplay

	movi	[68,0],a10
	move	a9,a9
	jrnz	#tm1
	movi	[296,0],a10
#tm1
	move	a10,a0
	movi	[3,0],a1
	movi	5000,a3
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD|tmfireid,a5
	clr	a6
	clr	a7
	movi	FFRAM_B_P,b0
	movi	#frame,a14
	move	*a14+,a2,L
	move	a14,*a13(PDATA),L	;Fire-frame ani *table
	calla	BEGINOBJP2
	move	a0,a9

	move	a10,a0
	addi	[8,0],a0
	movi	[20,0],a1
	movi	LED_00,a2
	subk	1,a3
	calla	BEGINOBJ2

;	movi	LED_35,a14		;!!!Fire time
;MJT Start
	movi	LED_25,a14		;!!!Fire time
;MJT End
	move	*a14,a0,L
	move	a0,*a8(OSAG),L
	move	a14,*a13(PDATA+32),L	;Seconds display/timer

	move	@CMOS_clock_speed,a0	;RAM copy of CMOS adjustment
	sll	4,a0
	addi	tfire_timer_tbl-16,a0
	move	*a0,a0
	move	@PSTATUS,a14
	cmpi	>f,a14			;Is it a 4 plyr game? No if !0
	jrnz	#not4
	subk	1,a0			;Yes. Make clk run faster!
#not4
	move	a0,*a13(PDATA+64)	;Timer count

#lptick
	move	*a13(PDATA+64),a10	;Timer count
#lp
	SLEEPK	FLAME_ANICNT
	move	@HALT,a0
	jrnz	#lp

	move	@balltmshotcnt,a14	;Team stil on-fire?
	subk	TMFIRE_MINCNT,a14
	jrn	#notmfire		; br=no

	move	*a13(PDATA),A14,L	;Fire-frame ani *table
	move	*a14+,a0,L
	jrnz	#ani1
	movi	#frame,a14
	move	*a14+,a0,L
#ani1
	move	a14,*a13(PDATA),L
	SWAP	a8,a9
	move	*a8(OCTRL),a1
	calla	obj_aniq
	SWAP	a8,a9

	move	@clock_active,a0	;Clock active?
	jrnz	#lp

	dsj	a10,#lp

;MJT Start
;KEEP this shit around...

;Only decrement team zone timer when that particular team is in possession
;of the ball.

;cntl_team  = Team in control (0,1,-1)
;a11 	    = team on fire (!0=team 1, 0=team 2)
	
	.ref	cntl_team
	move	@cntl_team,a0
	jrn	#lptick
	jrz	#t1
;Team 2
	move	a11,a11
	jrz	#cont
	jruc	#lptick

#t1
;Team 1
	move	a11,a11
	jrz	#lptick

#cont
;MJT End

	move	*a13(PDATA+32),a14,L
	cmpi	LED_0,a14
	jrz	#clean_up
	move	-*a14,a0,L
	move	a0,*a8(OSAG),L
	move	a14,*a13(PDATA+32),L

	cmpi	LED_5,a14
	jrgt	#lptick

;FIX!!!  Get different snd
	SOUND1	warn_snd	      ;Warn players clock is running down
	jruc	#lptick

#clean_up
	clr	a0
	.ref	balltmshotcnt
	move	a0,@balltmshotcnt
#notmfire
	clr	a0
	move	a0,@plyr_onfire

	move	@pup_nomusic,a14
	jrz	#play1
	move	@GAMSTATE,a14
	subk	INAMODE,a14
	jrnz	#noplay1
#play1
	callr	start_qrtr_tune
#noplay1

	move	a9,a0
	calla	DELOBJ
	jauc	DELOBJDIE

#frame
	.long	FFRAME01,FFRAME02,FFRAME03,FFRAME04
	.long	FFRAME05,FFRAME06,FFRAME07,FFRAME08
	.long	FFRAME09,FFRAME10,FFRAME11,FFRAME12
	.long	FFRAME13,FFRAME14,FFRAME15,FFRAME16
	.long	FFRAME17,FFRAME18,FFRAME19,FFRAME20
	.long	0


#****************************************************************
* Start shot clock timer, when clock gets down to 10 seconds,
* then display the clock in the lower corner furthest away from
* the hoop.
* A0=0 shooting at rgt hoop, 1=left hoop
* Trashes scratch

 SUBR	shot_clock

	.if 	HEADCK
	rets
	.endif

	.if DEBUG | DUNKTST
	move	@CLOCK_OFF,a14
	jrz	#ok
	rets
#ok
	.endif

	PUSH	a7,a8

	move	a0,a8

	movi	clockid,a0
	calla	KIL1C 			;Kill existing shot clock proc
	movi	CLSDEAD|clockid,a0
	calla	obj_del1c		;Delete any 24 second shot clock imgs

	CREATE	clockid,clock24
	move	a0,@sc_proc,L

	movi	[1,0],a0
	move	a0,@shotimer,L

	PULL	a7,a8
     	rets


 SUBRP	clock24 
	clr	a10
	movk	7,a9			;13

	movi	game_time,a1
;check to see if less than 24 seconds remain on clock.  If so, die!
	movb	*a1(8),a0		;restuff single seconds byte
	movb	*a1(16),a2		;grab 10 seconds byte


	movb	*a1(24),a3		;grab minutes byte
	jrnz	#lp
;Possibly less than a minute left

	move	a2,a2
	jrnz	#not

#nosc
	clr	a0
	move	a0,@sc_proc,L
	DIE
#not
	cmpi	1,a2
	jrnz	#lp
	cmpi	5,a0
	jrle	#nosc

#lp
	SLEEP	40
	move	@HALT,a0
	jrnz	#lp

;	jruc	#lp

	dsj	a9,#lp

#lp0	SLEEPK	10

	move	@tvpanelon,a0,L
	jrnz	#lp0
	move	@ballgoaltcnt,a0
	jrgt	#lp0
	move	@ballpnum,a0
	jrn	#skp
	sll	5,a0
	addi	plyrproc_t,a0
	move	*a0,a0,L
	move	*a0(plyr_jmpcnt),a14
	jrnz	#lp0
	move	*a0(plyr_seqflgs),a0
	btst	DUNK_B,a0
	jrnz	#lp0			;!Dunking?
#skp
	SLEEPK	10

;wait 13 seconds before we actually display shot clock in corner
;left side hoop

	movi	#init_t,a11
	movi	shotram,a10		;for holding onto img pointer
	move	a8,a8
	jrnz	hoopl
	movi	#init_t2,a11
hoopl
	jruc	#status

	movi	#init_t,a11
	jruc	#status
#lp2
	move	*a11+,a1		;Y
	sll	16,a0
	sll	16,a1
	move	*a11+,a3		;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	move	*a11+,a2,L
	movi	CLSDEAD|clockid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a0,*a10+,L		;hold onto img pointer

#status	move	*a11+,a0		;X
	cmpi	4000,a0
	jrne	#lp2			;!End?

#lp3
	move	@tvpanelon,a0,L
	jrnz	#x

	move	@shotram+32,a8,L		;first digit
	move	@shotram+64,a9,L		;second digit
	move	@shotimer,a2,L
	clr	a0
	movy	a2,a0
	srl	11,a0
	addi	bnumbs,a0
	move	*a0,a0,L
	move	*a8(OCTRL),a1
	calla	obj_aniq

;Do 2nd digit
	sll	16,a2
	srl	11,a2
	addi	bnumbs,a2
	move	*a2,a0,L
	move	a9,a8
	move	*a8(OCTRL),a1
	calla	obj_aniq

#lp3t	SLEEP	32
	move	@HALT,a0
	jrnz	#lp3t

	move	@shotimer,a0
	jrz	#tag
	dec	a0
	move	a0,@shotimer

	cmpi	4,a0
	jrgt	#nowarn
	jrne	#nospch

	move	@ballpnum,a14
	jrn	#nospch
	SOUND1	sht_ball_sp
#nospch
	SOUND1	warn_snd	      ;Warn players shot clock is running down
#nowarn

	jruc	#lp3
#tag	move	@shotimer+16,a0
	jrz	#tag1
	dec	a0
	move	a0,@shotimer+16
	movk	9,a0
	move	a0,@shotimer
	jruc	#lp3
#tag1
;	SOUND1	error_found

#tag1X
	SLEEPK	1

;Shot clock ran out - turnover!  Unless the ball is in the air toward hoop!
	move	@ballgoaltcnt,a0
	jrgt	markdi

	movk	1,a0
	move	a0,@clock_active

	CREATE0	shot_text
	CREATE0	shot_clock_speech

	move	@ballpnum,a11
	jrnn	#ok1
	move	@ballpnumshot,a11
#ok1
	srl	1,a11
	subk	1,a11
	CREATE0	plyr_takeoutball3


#showstick
	movi	P1DATA,a10
	callr	stick_number
	movi	P2DATA,a10
	callr	stick_number
	movi	P3DATA,a10
	callr	stick_number
	movi	P4DATA,a10
	callr	stick_number

 
	SLEEP	TSEC*3

	clr	a0
	move	a0,@clock_active

sclockx	move	a10,a10
	jrz	#x2
#x	movi	CLSDEAD|clockid,a0
	calla	obj_del1c		;Delete any 24 second shot clock imgs
#x2	clr	a0
	move	a0,@sc_proc,L
#die	DIE

markdi	SLEEP	120
	movi	clockid,a0
	calla	KIL1C 			;Kill existing shot clock proc
	movi	CLSDEAD|clockid,a0
	calla	obj_del1c		;Delete any 24 second shot clock imgs
      	jruc	#x2

numbs
	.ref	BRSH12_0,BRSH12_1,BRSH12_2,BRSH12_3,BRSH12_4,BRSH12_5
	.ref	BRSH12_6,BRSH12_7,BRSH12_8,BRSH12_9
	.long	BRSH12_0,BRSH12_1,BRSH12_2,BRSH12_3,BRSH12_4,BRSH12_5
	.long	BRSH12_6,BRSH12_7,BRSH12_8,BRSH12_9
;	.long	font90,font91,font92,font93,font94,font95,font96,font97
;	.long	font98,font99

bnumbs
	.long	BRSH20_0,BRSH20_1,BRSH20_2,BRSH20_3,BRSH20_4,BRSH20_5
	.long	BRSH20_6,BRSH20_7,BRSH20_8,BRSH20_9


#init_t
	.word	>13d,>e0,5000
	.long	NSHOTCLK
	.word	>143,>d9,5000
	.long	BRSH20_0		;font90r
	.word	>158,>d9,5000
	.long	BRSH20_0		;font90r
	.word	4000

#init_t2
	.word	>1c,>e0,5000
	.long	NSHOTCLK
	.word	>22,>d9,5000
	.long	BRSH20_0		;font90r
	.word	>37,>d9,5000
	.long	BRSH20_0		;font90r
	.word	4000
		

#********************************
* Print in the zone text

 SUBR	tm_zone_msg

	movi	#ln0_setup,a2
	calla	setup_message

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	120-8-44,a0
	move	a0,@mess_cursy
	movi	#str_inzone,a4
	calla	print_string_C2

	.ref	flash_blu_txt
	CREATE0	flash_blu_txt
	move	a0,a9

	movk	5,a10
	CREATE0	#doannc_snd

	SLEEP	TSEC*2

	move	a9,a0
	calla	KILL

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

	DIE

#doannc_snd

	SOUND1	win_snd
	SLEEPK	20
	dsj	a10,#doannc_snd

	DIE


#ln0_setup
	PRINT_STR	brush20_ascii,13,0,200,70,BRSH_B_P,0

#str_inzone
	.string	"TEAM FIRE!",0
	.even


#********************************
* Print shot clock violation text

 SUBRP	shot_text

	movi	#ln0_setup,a2
	calla	setup_message
	move	*a2,a0,L
	move	a0,@mess_justify,L	;justification method
	move	@mess_cursx,a0
	move	a0,@mess_cursx2
	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	#str_shtclk1,a4
	calla	print_string2b

	movi	56,a0
	move	a0,@mess_cursx2
	movi	128,a0
	move	a0,@mess_cursy

	addk	8,a4
	calla	print_string2b

	CREATE0	flash_bigtxt
	move	a0,a9

	movk	5,a10
	CREATE0	doalert_snd

	SLEEP	TSEC*2

	move	a9,a0
	calla	KILL

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

	DIE


#ln0_setup
	PRINT_STR	hangfnt38_ascii,14,0,31,68,HANGF_R_P,kern_chars

#str_shtclk1
	.string	"S",1,-4,"H",1,-3,"O",1,2,"T "
	.string	"C",1,-4,"L",1,2,"OC",1,-3,"K",0
	.string	"V",1,-6,"I",1,-1,"O",1,-3,"L",1,1,"A",1,3
	.string	"T",1,-3,"I",1,-1,"O",1,-3,"N",0
	.even


#*

 SUBR	show_ot_msg

;Display Double or Triple OT message, keep going...
	SLEEP	60

	movi	#ln0_setup,a2
	calla	setup_message
	move	*a2,a0,L
	move	a0,@mess_justify,L	;justification method
	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	76,a0
	move	@gmqrtr,a1
	subk	5,a1
	jrn	#ot1

	sll	5,a1
	addi	#ot_t,a1
	move	*a1(3*32),a0
	move	a0,@mess_cursx2
	movi	50,a0
	move	a0,@mess_cursy

	move	*a1,a4,L
	calla	print_string2b

	move	@mess_cursy,a0
	addi	50,a0
#ot1
	move	a0,@mess_cursy
	movi	61,a0
	move	a0,@mess_cursx2

	movi	#str_shtclk2,a4
	calla	print_string2b

	movk	5,a10			;8
	SOUND1	ot_alert_snd
;	CREATE0	doalert_snd
	CREATE0	flash_bigtxt
	move	a0,a9

	SLEEP	TSEC*3+20

	move	a9,a0
	calla	KILL

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text
	DIE


 SUBR	doalert_snd
 	SOUND1	whitsle_snd
#al
	SOUND1	alert_snd
	SLEEP	20
	dsj	a10,#al
	DIE


#ot_t	.long	#str_shtclk1a,#str_shtclk1b,#str_shtclk1c
	.long	96,107,41

#ln0_setup
	PRINT_STR	hangfnt38_ascii,14,0,200,128,HANGF_R_P,kern_chars

#str_shtclk1a
	.string	"D",1,-1,"O",1,-1,"U",1,-5,"B",1,-4,"L",1,1,"E",0
#str_shtclk1b
	.string	"T",1,-5,"R",1,-1,"I",1,-2,"P",1,-4,"L",1,1,"E",0
#str_shtclk1c
	.string	"QU",1,-7,"A",1,2,"D",1,-2,"R",1,-1
	.string	"U",1,-4,"P",1,-4,"L",1,1,"E",0
#str_shtclk2
	.string	"O",1,2,"V",1,-7,"E",1,-4,"R",1,3,"T",1,-3
	.string	"I",1,-1,"M",1,-5,"E",0
	.even


#********************************
* fix_dropout_msgs
*

	BSSX	plyrsdropped,16

 SUBR	fix_dropout_msgs

;	calla	CR_STRTP		;Have credits to start?
;	movi	insert,a10		;Assume no (C unaffected)
;	jrlo	#no_s			;No if < (if C set)
;	movi	start,a10		;Yes
;#no_s
	calla	CR_CONTP		;Have credits to continue?
	movi	insert,a11		;Assume no (C unaffected)
	jrlo	#no_c			;No if < (if C set)
	movi	start,a11		;Yes
#no_c

#fdm_p1
;	move	a10,a0			;Assume new plyr start
;	move	@PSTATUS2,a4		;Chk has-started bit
;	btst	0,a4			;Is it a continue? No if 0
;	jrz	#new1
;	move	a11,a0			;Continue
;#new1
	move	@P1DATA+ply_messages,a8,L
	move	*a8(OIMG),a0,L
	cmpi	please,a0
	jrnz	#fdm_p2
	move	a11,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

#fdm_p2
;	move	a10,a0
;	move	@PSTATUS2,a4
;	btst	1,a4
;	jrz	#new2
;	move	a11,a0			;Continue
;#new2
	move	@P2DATA+ply_messages,a8,L
	move	*a8(OIMG),a0,L
	cmpi	please,a0
	jrnz	#fdm_p3
	move	a11,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

#fdm_p3
;	move	a10,a0
;	move	@PSTATUS2,a4
;	btst	2,a4
;	jrz	#new3
;	move	a11,a0			;Continue
;#new3
	move	@P3DATA+ply_messages,a8,L
	move	*a8(OIMG),a0,L
	cmpi	please,a0
	jrnz	#fdm_p4
	move	a11,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

#fdm_p4
;	move	a10,a0
;	move	@PSTATUS2,a4
;	btst	3,a4
;	jrz	#new4
;	move	a11,a0			;Continue
;#new4
	move	@P4DATA+ply_messages,a8,L
	move	*a8(OIMG),a0,L
	cmpi	please,a0
	jrnz	#fdm_drop
	move	a11,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

;--------------------

#fdm_drop
	move	@PSTATUS,a0
	move	@plyrsdropped,a1
	btst	0,a1
	jrz	#n1
	btst	0,a0
	jrnz	#n1
	movi	P1DATA,a3
	movi	P1DATA+ply_messages,a9
	movi	init_t1a,a11
	callr	do_drop
#n1
	move	@PSTATUS,a0
	move	@plyrsdropped,a1
	btst	1,a1
	jrz	#n2
	btst	1,a0
	jrnz	#n2
	movi	P2DATA,a3
	movi	P2DATA+ply_messages,a9
	movi	init_t2a,a11
	callr	do_drop
#n2
	move	@PSTATUS,a0
	move	@plyrsdropped,a1
	btst	2,a1
	jrz	#n3
	btst	2,a0
	jrnz	#n3
	movi	P3DATA,a3
	movi	P3DATA+ply_messages,a9
	movi	init_t3a,a11
	callr	do_drop
#n3
	move	@PSTATUS,a0
	move	@plyrsdropped,a1
	btst	3,a1
	jrz	#n4
	btst	3,a0
	jrnz	#n4
	movi	P4DATA,a3
	movi	P4DATA+ply_messages,a9
	movi	init_t4a,a11
	callr	do_drop
#n4    
	callr	update_scorebrd		;make sure we show correct message
	rets

;--------------------
; A3=PnDATA of player who dropped out
; A9=ply_messages of player who dropped out
; A11=init_tNa of player who dropped out

do_drop
	move	*a9,a0,L
	jrz	#ddrp
	calla	DELOBJ
#ddrp
	clr	a2
	move	*a3(ply_meter_imgs),a0,L
	calla	OBJOFF
	move	*a3(ply_meter_imgs+32),a0,L
	calla	DELOBJ				;OBJOFF
	move	a2,*a3(ply_meter_imgs+32),L

	calla	prt_status
	rets


;obj position values
	.asg	 50<<16,P1_X
	.asg	150<<16,P2_X
	.asg	250<<16,P3_X
	.asg	350<<16,P4_X
	.asg	240<<16,PWRUP_Y		;bottom most power-up award
	.asg	  9<<16,IMG_SPC



;-----------------------------------------------------------------------------
; 	This routine plots the POWER-UP award text image.
;
; INPUT: reg. a0 - ptr. to xy position table
; 	 reg. a2 - ptr. to img
;
;RETURNS: reg a8 - ptr. to obj.
;-----------------------------------------------------------------------------
 SUBR	create_powerup_msg

	move	*a0,a0,L			;get X value
	movi	19500,a3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSDEAD|124,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	CREATE0	cntrl_powerup_bar
	rets



	.asg	280<<16,KILL_X

;-----------------------------------------------------------------------------
;	This PROCESS flashes the POWER-UP bar as it appears on the
; screen and after 4 seconds sends it off screen
;
; INPUT: reg a8 - ptr. to power-up bar obj.
;	 reg a10 - player number
;-----------------------------------------------------------------------------
 SUBRP	cntrl_powerup_bar

	move	a10,a0
	sll	5,a0
	addi	powerup_snd_tbl,a0
	move	*a0,a0,L
	calla	snd_play1

	movi	pwrup_pal_tbl,a9,L
fpm_1	move	*a9+,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL),L
	SLEEPK	3
	cmpi	pwrup_pal_tbl_end,a9
	jrlo	fpm_1

	SLEEP	TSEC*4

	movi	[7,0],a1,L
	move	a1,*a8(OYVEL),L			;now, move obj. off screen

fpm_2	SLEEPK	2
	move	*a8(OYVAL),a14,L
	cmpi	KILL_X,a14
	jrlo	fpm_2
	calla	DELOBJA8
 	DIE


powerup_snd_tbl
	.long	powrup_awrd1,powrup_awrd2
	.long	powrup_awrd3,powrup_awrd4


pwrup_pal_tbl
	.long	TUBEB10_P
	.long	TUBEB09_P
	.long	TUBEB08_P
	.long	TUBEB07_P
	.long	TUBEB06_P
	.long	TUBEB05_P
	.long	TUBEB04_P
	.long	TUBEB03_P
	.long	TUBEB02_P
	.long	TUBEB01_P
	.long	TUBEB_Y_P
pwrup_pal_tbl_end


TUBEB01_P:
   .word   63 
   .word   0318ch,04e9fh,03e1fh,031bfh,02d9eh,0257fh,0257eh,0215fh
   .word   01d3dh,018ffh,0213ch,01d1dh,018fch,018f9h,00cbch,010bbh
   .word   018f8h,00cbbh,010bah,00cbah,0089bh,00c9ah,00cb9h,0089ah
   .word   00c99h,00899h,0087ah,00c98h,00879h,00c97h,014d4h,00878h
   .word   00c96h,00877h,00c95h,00876h,00875h,00874h,00c73h,00873h
   .word   00854h,00872h,00852h,00871h,00851h,00870h,00850h,0086fh
   .word   0084fh,0086eh,0084eh,0084dh,0084ch,0084bh,0084ah,00849h
   .word   00848h,00847h,00846h,00845h,00844h,00421h,07fe0h

TUBEB02_P:
   .word   63 
   .word   0318ch,05affh,04a7fh,03e1fh,039ffh,031dfh,031dfh,02dbfh
   .word   0299fh,0255fh,02d9fh,0297fh,0255fh,0255ch,0191fh,01d1eh
   .word   0255bh,0191eh,01d1dh,0191dh,014feh,018fdh,0191ch,014fdh
   .word   018fch,014fch,014ddh,018fbh,014dch,018fah,02137h,014dbh
   .word   018f9h,014dah,018f8h,014d9h,014d8h,014d7h,018d6h,014d6h
   .word   014b7h,014d5h,014b5h,014d4h,014b4h,014d3h,014b3h,014d2h
   .word   014b2h,014d1h,014b1h,014b0h,014afh,014aeh,014adh,014ach
   .word   014abh,014aah,014a9h,014a8h,014a7h,01084h,07fe0h

TUBEB03_P:
   .word   63 
   .word   0318ch,06b7fh,05affh,04e9fh,04a7fh,0425fh,0425fh,03e3fh
   .word   03a1fh,035dfh,03e1fh,039ffh,035dfh,035dfh,0299fh,02d9fh
   .word   035dfh,0299fh,02d9fh,0299fh,0257fh,0297fh,0299fh,0257fh
   .word   0297fh,0257fh,0255fh,0297fh,0255fh,0297eh,031bbh,0255fh
   .word   0297dh,0255eh,0297ch,0255dh,0255ch,0255bh,0295ah,0255ah
   .word   0253bh,02559h,02539h,02558h,02538h,02557h,02537h,02556h
   .word   02536h,02555h,02535h,02534h,02533h,02532h,02531h,02530h
   .word   0252fh,0252eh,0252dh,0252ch,0252bh,02108h,07fe0h

TUBEB04_P:
   .word   63 
   .word   0318ch,07bffh,06b7fh,05f1fh,05affh,052dfh,052dfh,04ebfh
   .word   04a9fh,0465fh,04e9fh,04a7fh,0465fh,0465fh,03a1fh,03e1fh
   .word   0465fh,03a1fh,03e1fh,03a1fh,035ffh,039ffh,03a1fh,035ffh
   .word   039ffh,035ffh,035dfh,039ffh,035dfh,039ffh,0423fh,035dfh
   .word   039ffh,035dfh,039ffh,035dfh,035dfh,035dfh,039deh,035deh
   .word   035bfh,035ddh,035bdh,035dch,035bch,035dbh,035bbh,035dah
   .word   035bah,035d9h,035b9h,035b8h,035b7h,035b6h,035b5h,035b4h
   .word   035b3h,035b2h,035b1h,035b0h,035afh,0318ch,07fe4h


TUBEB05_P:
   .word   63 
   .word   0318ch,07fffh,07bffh,06f9fh,06b7fh,0635fh,0635fh,05f3fh
   .word   05b1fh,056dfh,05f1fh,05affh,056dfh,056dfh,04a9fh,04e9fh
   .word   056dfh,04a9fh,04e9fh,04a9fh,0467fh,04a7fh,04a9fh,0467fh
   .word   04a7fh,0467fh,0465fh,04a7fh,0465fh,04a7fh,052bfh,0465fh
   .word   04a7fh,0465fh,04a7fh,0465fh,0465fh,0465fh,04a5fh,0465fh
   .word   0463fh,0465fh,0463fh,0465fh,0463fh,0465fh,0463fh,0465eh
   .word   0463eh,0465dh,0463dh,0463ch,0463bh,0463ah,04639h,04638h
   .word   04637h,04636h,04635h,04634h,04633h,04210h,07fe8h

TUBEB06_P:
   .word   63 
   .word   0318ch,07fffh,07fffh,07fffh,07bffh,073dfh,073dfh,06fbfh
   .word   06b9fh,0675fh,06f9fh,06b7fh,0675fh,0675fh,05b1fh,05f1fh
   .word   0675fh,05b1fh,05f1fh,05b1fh,056ffh,05affh,05b1fh,056ffh
   .word   05affh,056ffh,056dfh,05affh,056dfh,05affh,0633fh,056dfh
   .word   05affh,056dfh,05affh,056dfh,056dfh,056dfh,05adfh,056dfh
   .word   056bfh,056dfh,056bfh,056dfh,056bfh,056dfh,056bfh,056dfh
   .word   056bfh,056dfh,056bfh,056bfh,056bfh,056beh,056bdh,056bch
   .word   056bbh,056bah,056b9h,056b8h,056b7h,05294h,07fech

TUBEB07_P:
   .word   63 
   .word   0318ch,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07bffh,077dfh,07fffh,07bffh,077dfh,077dfh,06b9fh,06f9fh
   .word   077dfh,06b9fh,06f9fh,06b9fh,0677fh,06b7fh,06b9fh,0677fh
   .word   06b7fh,0677fh,0675fh,06b7fh,0675fh,06b7fh,073bfh,0675fh
   .word   06b7fh,0675fh,06b7fh,0675fh,0675fh,0675fh,06b5fh,0675fh
   .word   0673fh,0675fh,0673fh,0675fh,0673fh,0675fh,0673fh,0675fh
   .word   0673fh,0675fh,0673fh,0673fh,0673fh,0673fh,0673fh,0673fh
   .word   0673fh,0673eh,0673dh,0673ch,0673bh,06318h,07ff0h

TUBEB08_P:
   .word   63 
   .word   0318ch,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07bffh,07fffh
   .word   07fffh,07bffh,07fffh,07bffh,077ffh,07bffh,07bffh,077ffh
   .word   07bffh,077ffh,077dfh,07bffh,077dfh,07bffh,07fffh,077dfh
   .word   07bffh,077dfh,07bffh,077dfh,077dfh,077dfh,07bdfh,077dfh
   .word   077bfh,077dfh,077bfh,077dfh,077bfh,077dfh,077bfh,077dfh
   .word   077bfh,077dfh,077bfh,077bfh,077bfh,077bfh,077bfh,077bfh
   .word   077bfh,077bfh,077bfh,077bfh,077bfh,0739ch,07ff4h

TUBEB09_P:
   .word   63 
   .word   0318ch,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07ff8h

TUBEB10_P:
   .word   63 
   .word   0318ch,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh



;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBRP	nodrift_message

	move	@pup_nodrift,a14
	jrz	#nondm
	SLEEPK	10
	.ref	is_legal_sp
	SOUND1	is_legal_sp
#nondm
	DIE


;-----------------------------------------------------------------------------
; This routine checks if any secret power-ups were awarded, if true then
;  a message is displayed showing the power-up
;-----------------------------------------------------------------------------
 SUBR	doflshs

;Wait for HALT to get set!
	SLEEPK	8

	callr	tournament_on		;Clr powerup bits rigt now!
	jrc	#lpz			; br=in tourney mode
	CREATE0	nodrift_message		;Do speech while instructions are up

#lpz
	SLEEPK	1			;I quess, waiting for idiot boxes
	move	@HALT,a0
	jrnz	#lpz

;	SLEEP	2*60-50

;	CREATE0	shot_percent_msg
	CREATE0	cpu_assist_off
	CREATE0	baby_message

	clr	a10
	CREATE0	check_plr_powerups
	movk	1,a10
	CREATE0	check_plr_powerups
	movk	2,a10
	CREATE0	check_plr_powerups
	movk	3,a10
	CREATE0	check_plr_powerups

	calla	pal_clean

	SLEEP	TSEC*3

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

	calla	pal_clean
	DIE


;-----------------------------------------------------------------------------
; This process flashes player white to alert him that a POWER-UP was awarded
;
;
; INPUT: reg a8 - ptr. to player obj.
;	 reg a10 - player number
;-----------------------------------------------------------------------------
 SUBRP	flash_plyr_white

	move	*a8(OPLINK),a0,L
	move	*a0(plyr_headobj_p),a9,L

	movi	>f8f8,a2
	move	a2,*a8(OCONST)
	movi	>3f3f,a2
	move	a2,*a9(OCONST)

	movk	7,a10
#again
	callr	const_on
	setf	4,0,0
	movk	M_CONNON,a0		;Replace non-zero data with constant
	move	a0,*a9(OCTRL)		;Write 4 low bits
	setf	16,1,0

	SLEEPK	3

	callr	const_off
	setf	4,0,0
	movk	M_WRNONZ,a0
	move	a0,*a9(OCTRL)		;Write 4 low bits
	setf	16,1,0

	SLEEPK	3

	dsj	a10,#again
	DIE


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	tournament_on

;Check to see if any of the 4 players has turned on tournament mode!
	move	@pup_tournament,a0
	jrnz	#se2a			;br=yep

	movk	ADJTOURNEY,a0		;Tournament mode?
	calla	GET_ADJ			;0-1
	jrz	#se2a			;On? Br=yes
	clrc
	rets

#se2a
	calla	clear_secret_powerup_tmode
;	clr	a0
;	move	a0,@p1taps
;	move	a0,@p2taps
;	move	a0,@p3taps
;	move	a0,@p4taps
;	move	a0,@pup_maxsteal
	setc				;Yes, tournament mode on!
	rets

#*************************************
* Show computer assistance off message

 SUBRP	cpu_assist_off

	callr	tournament_on
	jrnc	#set			;br=yep, tournament mode enabled

;tournament mode msg.

	movk	1,a0
	move	a0,@pup_noassistance

	SOUND1	win_snd

	movi	[200,0],a0,L
	movi	[44,0],a1,L
	movi	TOURMODE2,a2,L
	movi	19500,a3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSDEAD|123,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movi	[200,0],a0,L
	movi	[61,0],a1,L
	movi	NOCPU2,a2,L
	calla	BEGINOBJ2

	movi	[200,0],a0,L
	movi	[73,0],a1,L
	movi	SECRETS2,a2,L
	calla	BEGINOBJ2
	jruc	#setin2

;cpu assistance adj. was set
#set
	movk	ADJCOMPASS,a0		;Computer assistance
	calla	GET_ADJ			;0-1
	jrnz	#setca			;On? Br=yes
	move	@pup_noassistance,a0
	jrnz	#setcb			;br=wasn't set by player(s)
	jruc	#set3
#setca
	movk	1,a0
	move	a0,@pup_noassistance
#setcb
	SOUND1	win_snd

	movi	[200,0],a0,L
	movi	[52,0],a1,L
	movi	ASISTOFF2,a2,L
	movi	19500,a3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSDEAD|123,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
#setin2
	SLEEP	TSEC*4
	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text
	calla	pal_clean
#set3	DIE



#*******************************
* Show secret messages

 SUBRP	shot_percent_msg


	.if DUNKTST
	movk	1,a0
	move	a0,@pup_showshotper
	.else
	move	@pup_showshotper,a0
	jaz	SUCIDE ;When testing dunks - TAKE OUT!
	.endif

	SOUND1	win_snd

	movi	[200,0],a0,L
	movi	[40,0],a1,L
	movi	SHOTPERC2,a2,L
	movi	19500,a3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSDEAD|123,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	SLEEP	TSEC*4

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text
	calla	pal_clean
	DIE



#*******************************
* Show cpu substitution message

 SUBR	cpu_subs
	
	SLEEP	5

	movi	#ln0_setup,a2
	move	a8,a8
	jrz	#ok
	movi	#ln0_setupa,a2
#ok
	calla	setup_message

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	#str_subs,a4
	calla	print_string_C2

	DIE


#ln0_setup
	PRINT_STR  bast18_ascii,3,0,101,130,BST18W_P,0
#ln0_setupa
	PRINT_STR  bast18_ascii,3,0,300,130,BST18W_P,0

#str_subs
	.string	"CPU",0

	.even


;-----------------------------------------------------------------------------
;	This PROCESS checks and displays the activated power-ups
;
; INPUT: a10 - player number
;-----------------------------------------------------------------------------
 SUBRP	check_plr_powerups

;	callr	tournament_on
;	jac	cpp_1
	move	@PSTATUS,a0
	btst	a10,a0
	jreq	cpp_1				;br=plyr not in game
	movi	PWRUP_Y,a9			;starting Y position

	move	a9,a1
	callr	big_plyr_head_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp0				;br=nope

	SLEEPK	2

#noslp0	move	a9,a1
	callr	huge_plyr_head_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp1				;br=nope

	SLEEPK	2

#noslp1	move	a9,a1
	callr	shotperc_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp2				;br=nope

	SLEEPK	2

#noslp2	move	a9,a1
	callr	notag_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#nosl2				;br=nope

	SLEEPK	2

#nosl2	move	a9,a1
	callr	showhotspots_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp3				;br=nope

	SLEEPK	2

#noslp3	move	a9,a1
	callr	stealth_turbo_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp4				;br=nope

	SLEEPK	2

#noslp4	move	a9,a1
	callr	infinite_turbo_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp5				;br=nope

	SLEEPK	2

#noslp5	move	a9,a1
	callr	fast_passing_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp6				;br=nope

	SLEEPK	2

#noslp6	move	a9,a1
	callr	steal_power_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp7				;br=nope

	SLEEPK	2

#noslp7	move	a9,a1
	callr	maximum_speed_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp8				;br=nope

	SLEEPK	2

#noslp8	move	a9,a1
	callr	hyper_speed_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslp9				;br=nope

	SLEEPK	2

#noslp9	move	a9,a1
	callr	no_pushing_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslpa				;br=nope

	SLEEPK	2

#noslpa	move	a9,a1
	callr	maximum_power_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslpb				;br=nope

	SLEEPK	2

#noslpb	move	a9,a1
	callr	goal_tending_msg
	sub	a11,a9
	move	a11,a11				;was power-up displayed ?
	jreq	#noslpc				;br=nope

	SLEEPK	2

#noslpc
cpp_1	DIE


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	no_pushing_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_nopush,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_NOPUSH,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	stealth_turbo_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_trbstealth,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_STELTH,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	fast_passing_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_fastpass,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_FSTPAS,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	maximum_speed_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_maxspeed,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_MAXSPD,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	notag_msg

;DEBUG!!!
;Get rid of arrows for testing shit....
;FIXX!!!

;	movk	15,a0
;	move	a0,@pup_notag
;	rets

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_notag,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_NOARRW,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	infinite_turbo_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_trbinfinite,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_UNLIMT,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	showhotspots_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_showhotspots,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_HOTSPT,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	goal_tending_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_goaltend,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_GOALTN,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets

;FIX!!!
       BSSX	blkpower,16
;Need powerup for super blocking ability

#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	maximum_power_msg

	move	@pup_strongmen,a0
	jrz	#notst
;Grand champ playing - make drones have max power
	movk	3,a3
	cmpi	2,a0
	jrz	#tag1
	movk	>c,a3
#tag1	move	@pup_maxpower,a0
	or	a3,a0
	move	a0,@pup_maxpower
#notst
	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_maxpower,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_MAXPOW,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	big_plyr_head_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_bighead,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_BIGHED,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets

#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	huge_plyr_head_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_hugehead,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_BIGHED,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	hyper_speed_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_hypspeed,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_HYPRSP,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	shotperc_msg

	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_showshotper,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_SHTPCT,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;
; INPUT:   a1 - Y value
;         a10 - player number
;
; RETURN:  a11 - next Y position offset
;-----------------------------------------------------------------------------
 SUBRP	steal_power_msg

	move	@pup_strongmen,a0
	jrz	#notst
;Grand champ playing - make drones have max power
	movk	3,a3
	cmpi	2,a0
	jrz	#tag1
	movk	>c,a3
#tag1	move	@pup_maxsteal,a0
	or	a3,a0
	move	a0,@pup_maxsteal
#notst
	clr	a11		    ;assume plyr didn't activate this power-up
	move	@pup_maxsteal,a0
	btst	a10,a0
	jrz	#nxt
	move	a10,a0
	sll	5,a0
	addi	xy_tbl,a0
	movi	M_QIKHND,a2,L
	callr	create_powerup_msg
	movi	IMG_SPC,a11
#nxt	rets


xy_tbl
	.long	P1_X
	.long	P2_X
	.long	P3_X
	.long	P4_X


#*****************************************************************************
;
;	This routine checks if players has activated the 
; power-up
;-----------------------------------------------------------------------------
 SUBRP	baby_message

	callr	tournament_on
	jac	SUCIDE
	move	@pup_baby,a0
	jaz	SUCIDE
	SOUND1	win_snd

	movi	[200,0],a0,L
	movi	[64,0],a1,L
	movi	BABYPLAY2,a2,L
	movi	19500,a3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSDEAD|123,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	SLEEP	TSEC*4
	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text
	calla	pal_clean
	DIE
