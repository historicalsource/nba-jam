**************************************************************
*
* Software:	Mark Turmell
* Initiated:	7/17/90
*
* Modified:	Shawn Liptak, 11/13/91	-Insert coin fix, clean up
* 		Shawn Liptak, 2/18/92	-Basketball
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/19/93 13:07
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
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"game.equ"
	.include	"shawn.hdr"
	.include	"mac2.asm"
	.include	"audit.equ"
	.include	"leds.tbl"
	.include	"city.tbl"
	.include	"arrow.tbl"
	.asg		0,SEQT
	.include	"plyr.equ"

;sounds
	.ref	cntdown_snd,tune2_snd,snd_play1ovr
	.ref	musicoff_snd
	.ref	horn_snd

showtm		.word	>fca1,73,>812c,0	;showtime
;tuneend_snd	.word	>f3ff,>8,>800a,0	;End quarter 1 tune
tuneq2_snd	.word	>f3ff,>8,>8006,0	;Quarter 2 tune
tuneq3_snd	.word	>f3ff,>8,>8007,0	;Quarter 3 tune
tuneq4_snd	.word	>f3ff,>8,>8008,0	;Quarter 4 tune
tuneot_snd	.word	>f3ff,>8,>800b,0	;Quarter o.t. tune
intoot_snd	.word	>f990,40,>8180,0	;Into o.t.
tick_snd	.word	>f3f7,>18,>8090,0	;Tick snd
tock_snd	.word	>f3f7,>18,>8091,0	;Tock snd

minute_snd
;RJR
	.word	>f97f,1,>81fe,1		;silence
	.word	>f9f0,80,>8193,0	;One minute speech call

alert_snd	.word	>f3f7,>8,>8092,0	;Alert snd
warn_snd	.word	>fbf7,>18,>80a0,0	;Warning on shot clock
infoex_snd	.word	>f3ff,>8,>8097,0	;Info box exit
whstle_snd	.word	>f9f5,>30,>8148,0	;Ref whistle at game start

;symbols externally defined

	.ref	RNDRNG0
	.ref	lighten1
	.ref	lighten2
	.ref	lighten3
	.ref	lighten4
	.ref	lighten5
	.ref	lighten6
	.ref	lighten7

	.ref	strongmen
	.ref	get_but_val_down
	.ref	get_start_cur
	.ref	special_heads
	.ref	plyrnumonfire
	.ref	qtr_purchased,idiot_box
	.ref	update_shoes
	.ref	flash_bigtxt
	.ref	setup_message,print_string_C2,print_string
	.ref	copy_string,print_string_C
	.ref	dec_to_asc
	.ref	osgemd_ascii,sgmd8_ascii,osgmd8_ascii
	.ref	lgmd_ascii,omlgmd_ascii,ogmd10_ascii
	.ref	mess_line_spacing
	.ref	mess_cursy
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
	.ref	pal_find
	.ref	ballobj_p
	.ref	get_all_buttons_down
	.ref	get_all_starts_down
	.ref	AUD1
	.ref	baby_flag

	
;symbols defined in this file

	.def	LED_00,last_score,tvpanelon,LED_MAX
	.def	sclockx
	.def	arrow1t,arrow2t,arrow3t,arrow4t
	.def	arrow1r,arrow2r,arrow3r,arrow4r
	.def	arrow1r2p,arrow2r2p

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
	.bss	clock_imgs,32*4		;images for main clock at top of scrn
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

	BSSX	p1taps,16		;Keep in order
	BSSX	p2taps,16
	BSSX	p3taps,16
	BSSX	p4taps,16
	BSSX	show_shot,16
	BSSX	assistance_off,16	;1=turn help off
	BSSX	plyr_tourn,16*4
	BSSX	plyr_maxpower,16	;Powerup power - can't be pushed down

;equates first originated in this file

BUYTICK	.EQU	110		;60
SCRNTOP .EQU	100
BRGHT	.EQU	>2c2c		;GREEN IN SCOREPAL
COLORS	.EQU	>0909		;WHITE IN SCOREPAL
COLORA	.EQU	>3E3E		;COLOR CYCLE IN SCOREPAL


GND_Y		.equ	116-40
GZBASE		.equ	894

LEDOCTRL	.equ	DMAWNZ|>3000	;3 bits per pixel (In BB.asm)
MSGOCTRL	.equ	DMAWNZ|>6000


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
;MJT 12/16/93
	.asg	5100h,BASETM

	.word	BASETM-BASETM*30/100	;1 (slowest)
	.word	BASETM-BASETM*15/100	;2 (slower)
	.word	BASETM			;3 (default)	;Approx 10 minutes
	.word	BASETM+BASETM*15/100	;4 (faster)
	.word	BASETM+BASETM*30/100	;5 (fastest)


#******************************************************************
* Player is off screen for too long - put up an arrow pointing him out
*
*a8=0-3 for plyr #

 SUBR	plyr_lost

   	move	a8,a9
	clr	a0
	move	a0,*a13(PDATA)			;lost cntr
	move	a0,*a13(PDATA+64),L		;Current red/white shoe pal
	move	a0,*a13(PDATA+96),W		;lft/rgt 0=lft
	move	a0,*a13(PDATA+112),W		;minimum duration
	SLEEP	3*60				;Make sure plyr gets started

	sll	5,a8
	movi	plyrproc_t,a0			;*player process (4)
	add	a8,a0
	move	*a0,a0,L
	move	a0,*a13(PDATA+32),L		;Keep player proc around

	addi	plyrobj_t,a8
	move	*a8,a8,L

	sll	6,a9
	move	a9,a11
	move	a9,*a13(PDATA+128),W		;keep a9 around


#top
	SLEEPK	3				;15
	calla	update_shoes
	SLEEPK	3
	calla	update_shoes

	callr	maybe_replenish

	move	*a8(OXPOS),a0

 	movi	lft_lst,a10			;off lft side

	move	@TWOPLAYERS,a7			;0 = NO, 1 = YES 2 players
	jrz	#not2
 	movi	lft2_lst,a10			;off lft side
#not2

	move	@WORLDTLX+16,a7
	addk	10,a7				;0
	cmp	a0,a7
	jrgt	#offsc

	movi	rgt_lst,a10			;off rgt side

	move	@TWOPLAYERS,a14			;0 = NO, 1 = YES 2 players
	jrz	#not2a
 	movi	rgt2_lst,a10			;off lft side
#not2a


	addi	15eh-10,a7			;164
	cmp	a0,a7
	jrlt	#offsc
	clr	a0
	move	a0,*a13(PDATA)			;zero lost cntr
	jruc	#top

maybe_replenish
	PUSH	A9
	move	*a13(PDATA+128),a9
	move	@PSTATUS,a0
	move	a9,a1
	srl	6,a1
	btst	a1,a0
;	jrz	#no_refill

	move	*a13(PDATA+32),a0,L		;player proc
	move	*a0(plyr_PDATA_p),a0,L
	move	*a0(used_turbo),a2
	jrle	#ok
	subk	1,a2
	move	a2,*a0(used_turbo)
	jruc	#no_refill

#ok	callr	replenish_turbo

#no_refill
	PULL	a9
	rets

#offsc
;Off scrn for x seconds!
;Turn on proper img/ lft or rgt arw!

	add	a9,a10
	move	*a10+,a2,L			;get proper arw dir & # img
	move	*a10,a0,L			;get x

	move	a8,a10

	movi	[100,0],a1
	clr	a3
	movi	DMAWNZ|M_SCRNREL|M_NOCOLL,a4
;9/20/93
	movi	arwid,a5
;	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2


;Give arrow correct player pal!

;	move	*a13(PDATA+32),a0,L
; 	move	*a0(PA8),a0,L
;	move	*a0(OPAL),*a8(OPAL)

	move	a8,a9
	move	a10,a8				;player img to stick to

#metop	inc	a10
	move	a10,a0
	andi	03h,a0		;7		;replenish rate when off scrn
	jrnz	#me1

	callr	maybe_replenish

#me1
	move	*a8(OXPOS),a0

	move	@WORLDTLX+16,a7
	cmp	a0,a7
	jrgt	#offsc2l
	addi	164h,a7
	cmp	a0,a7
	jrlt	#offsc2r
;minimum time
	move	*a13(PDATA+112),a0		;minimum duration
	inc	a0
	move	a0,*a13(PDATA+112)
	cmpi	15,a0
	jrle	#zo
	move	a9,a0
   	calla	DELOBJ
	clr	a0
	move	a0,*a13(PDATA)			;zero lost cntr
	move	a0,*a13(PDATA+112)
	move	a11,a9
;Now turn on a over hd arw for this guy coming back onto the scrn

	move	*a13(PDATA+32),a10,L
	callr	arw_on1plyr

	move	*a13(PDATA+32),a3,L
	clr	a2
	move	a2,*a3(plyr_offtime)

	jruc	#top

#offsc2l
	sub	a0,a7
	sra	3,a7

	movi	40,a0			;move	*a9(OXPOS),a0
	sub	a7,a0

	move	*a13(PDATA+32),a3,L
	move	*a3(plyr_num),a2

	move	@PSTATUS,a14
	btst	a2,a14
	jrz	#nohelp

	move	*a3(plyr_offtime),a2
	inc	a2
	move	a2,*a3(plyr_offtime)
	cmpi	3*50*2+20-20,a2			;*1
	jrlt	#nohelp

	move	@gmqrtr,a2
	jrnz	#nohelp

	move	@inbound,a0
	jrnn	#nohelp0

	clr	a2
	move	a2,*a3(plyr_offtime)

;This plyr is an idiot!  Insult him.
	PUSH	a0,a1
	movk	2,a0
	move	*a3(plyr_num),a1
	calla	idiot_box
	PULL	a0,a1

#nohelp0
	clr	a2
	move	a2,*a3(plyr_offtime)

#nohelp
;If plyr 2 or 3 and other team has ball, spd him up
	
	move	@ballpnum,a3
	jrn	#noow			;No owner?

	move	*a13(PDATA+32),a3,L
	move	*a3(plyr_ownball),a14	;-=Teammate, 0=Neither, +=I have ball
	jrnz	#noow

	move	*a3(plyr_num),a14
	subk	2,a14
	jrlt	#noow
;Does other team own ball?
;Okay, this guy is in trouble, spd him up
	movk	1,a2
	move	a2,*a3(plyr_offscrn)	;Player is offscrn, spd him up

#noow

	move	*a13(PDATA+96),a2
	sub	a0,a2
	abs	a2
	cmpi	2,a2
	jrle	#offo

	move	*a9(OXPOS),a1
	cmp	a0,a1
	jrz	#offo
	jrlt	#off0
	cmpi	0,a1
	jrz	#off1

	subk	1,a1
	jruc	#off1
#off0	addk	1,a1
#off1	move	a1,*a9(OXPOS)
	move	a1,*a13(PDATA+96)
	jruc	#offo

#offsc2r
	sub	a7,a0
	sra	3,a0

	movi	325,a7			;move	*a9(OXPOS),a7
	add	a7,a0


	move	*a13(PDATA+32),a3,L
	move	*a3(plyr_offtime),a2
	inc	a2
	move	a2,*a3(plyr_offtime)


	cmpi	3*50*2+20-20,a2			;*1
	jrlt	#nohelp1

	move	@gmqrtr,a2
	jrnz	#nohelp1

	move	@inbound,a0
	jrnn	#nohelp01


;	cmpi	3*50,a2
;	jrlt	#nohelp1
;
;	move	@gmqrtr,a2
;	jrnz	#nohelp1

	clr	a2
	move	a2,*a3(plyr_offtime)

;This plyr is an idiot!  Insult him.
	PUSH	a0,a1
	movk	2,a0
	move	*a3(plyr_num),a1
	calla	idiot_box
	PULL	a0,a1

#nohelp01
	clr	a2
	move	a2,*a3(plyr_offtime)
#nohelp1


;If plyr 0 or 1 and other team has ball, spd him up
	
	move	@ballpnum,a3
	jrn	#noow1			;No owner?

	move	*a13(PDATA+32),a3,L
	move	*a3(plyr_ownball),a14	;-=Teammate, 0=Neither, +=I have ball
	jrnz	#noow

	move	*a3(plyr_num),a14
	subk	2,a14
	jrge	#noow1
;Does other team own ball?
;Okay, this guy is in trouble, spd him up
	movk	1,a2
	move	a2,*a3(plyr_offscrn)	;Player is offscrn, spd him up

#noow1

	move	*a13(PDATA+96),a2
	sub	a0,a2
	abs	a2
	cmpi	2,a2
	jrle	#offo

	move	*a9(OXPOS),a1
	cmp	a0,a1
	jrz	#offo
	jrlt	#bff0

	subk	1,a1
	jruc	#bff1
#bff0 
	cmpi	365,a1
	jrz	#bff1
	addk	1,a1
#bff1	move	a1,*a9(OXPOS)
	move	a1,*a13(PDATA+96)

#offo
	move	*a13(PDATA+112),a0		;minimum duration
	inc	a0
	move	a0,*a13(PDATA+112)

	move	*a8(OZPOS),a6
;	addk	10,a6
	move	a6,*a9(OZPOS)

	subi	GZBASE,a6		;-Base
	jrge	#zok
	clr	a6
#zok
	move	a6,a3
	sra	1,a6			;Z/2
	sra	3,a3			;Z/8
	sub	a3,a6			;=Z/2.667
	addi	GND_Y,a6
	subi	34h,a6

	move	@WORLDTLY+16,a0
	abs	a0
	add	a0,a6

	move	a6,*a9(OYPOS)

#zo	SLEEPK	1			;2
	move	@HALT,a0
	jrnz	#zo
	jruc	#metop


lft_lst	.long	arrow1l,[40,0]		;4's
	.long	arrow2l,[40,0]
	.long	arrow3l,[40,0]
	.long	arrow4l,[40,0]

rgt_lst	.long	arrow1r,[325,0]		;360's
	.long	arrow2r,[325,0]
	.long	arrow3r,[325,0]
	.long	arrow4r,[325,0]

lft2_lst
	.long	arrow1l2p,[40,0]		;4's
	.long	arrow1l2p,[40,0]
	.long	arrow2l2p,[40,0]
	.long	arrow2l2p,[40,0]

rgt2_lst
	.long	arrow1r2p,[325,0]		;360's
	.long	arrow1r2p,[325,0]
	.long	arrow2r2p,[325,0]
	.long	arrow2r2p,[325,0]

#******************************************************************
*
* Turn on a player arrow/# on top of his head
* Individual #
*
* a10=plyr proc of whom to stick an arrow on

 SUBR	arw_on1plyr

;Stick player number on top of player

	PUSH	a7,a8,a9,a11
	move	@GAMSTATE,a0
	subk	INAMODE,a0
	jrz	#x

	move	*a10(plyr_PDATA_p),a0,L	;*PxDATA
	move	*a0(head_arw_img),a0,L
	move	*a0(OPLINK),a0,L

;9/20/93
	movi	ARWPID,a1
;	clr	a1
	movi	arwon,a7
	move	*a0(PA8),a8,L
	move	*a0(PA9),a9,L
	movi	2*60+15,a11		;1
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
 
;9/20/93
	movi	ARWPID,a1
;	clr	a1
	movi	arwon,a7
	move	*a0(PA8),a8,L
	move	*a0(PA9),a9,L
	movi	4*60,a11
	calla	XFERPROC

#x
	PULL	a7,a8,a9,a11
	rets


#******************************************************************
*
* Turn on a player arrow/# on top of his head
*
* a10=PxDATA ram

 SUBR	stick_numbers

;Stick player number on top of player

	clr	a3
	movi	[-100,0],a1			;95
	movi	plyrobj_t,a11
	movi	arrow1t,a2
	move	@plyrproc_t,a0,L
	move	a0,*a13(PDATA+32),L		;Keep player proc around
	cmpi	P1DATA,a10
	jrz	#yup

	movk	1,a3
	movi	plyrobj_t+32,a11
	movi	arrow2t,a2


	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not2
	movi	arrow1t2p,a2
#not2


	move	@plyrproc_t+32,a0,L
	move	a0,*a13(PDATA+32),L		;Keep player proc around
	cmpi	P2DATA,a10
	jrz	#yup

	movk	2,a3
	movi	plyrobj_t+64,a11
	movi	arrow3t,a2


	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not2a
	movi	arrow2t2p,a2
#not2a



	move	@plyrproc_t+64,a0,L
	move	a0,*a13(PDATA+32),L		;Keep player proc around
	cmpi	P3DATA,a10
	jrz	#yup

	movk	3,a3
	movi	plyrobj_t+96,a11
	movi	arrow4t,a2


	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not2b
	movi	arrow2t2p,a2
#not2b


	move	@plyrproc_t+96,a0,L
	move	a0,*a13(PDATA+32),L		;Keep player proc around
#yup
	move	a3,*a13(PDATA+64)		;Plyr num
;	move	a2,*a13(PDATA+80),L		;arw img
	clr	a3
	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE,a4
	movi	arwid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	move	a8,a0
	calla	OBJOFF

	move	a8,*a10(head_arw_img),L

	move	*a13(PDATA+32),a0,L		;Give arrow correct player pal!

	move	a8,a9
	move	*a11,a8,L			;player img to stick to

	movi	4*60,a11

arwon
;Code to turn off arrows and turn them into CPU letters if he is a drone

	move	@PSTATUS,a0
	move	*a13(PDATA+64),a1
	btst	a1,a0
	jrz	#arwait				;Drone?

	move	a9,a0
	calla	OBJON


#stktop

* Align arw obj with player obj
* A8=*Obj
* a6=Arw Obj
* Trashes scratch, A2-A6

	calla	anipt_getsclxy			;GETANIXY
	srl	16,a0

	move	*a8(OZPOS),A2
	addk	30,a2
	move	a2,*a9(OZPOS)

	move	*a8(OXPOS),a2
	subk	4,a2				;7
	add	a0,a2
	move	a2,*a9(OXPOS)

	move	*a8(OPLINK),a0,L
	move	*a0(plyr_headobj_p),a0,L
	move	*a0(OYPOS),A2
	subi	35,a2
	move	a2,*a9(OYPOS)

#wtlp
	SLEEPK	1
	move	@HALT,a0
	jrnz	#wtlp
	dsj	a11,#stktop

	move	a9,a0
	calla	OBJOFF

#arwait	SLEEP	60				;>7fff
	move	a9,a0
	calla	OBJOFF
	jruc	#arwait

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

	move	*a11,a8,L			;player img to stick to

	movi	60*15,a11
#metop
	calla	anipt_getsclxy			;GETANIXY
	srl	16,a0

	move	*a8(OZPOS),A2
	addk	3,a2
	move	a2,*a9(OZPOS)

	move	*a8(OXPOS),a2
	subk	7,a2				;y
	add	a0,a2
	move	a2,*a9(OXPOS)

	move	*a8(OPLINK),a0,L
	move	*a0(plyr_headobj_p),a0,L
	move	*a0(OYPOS),A2
	addi	20,a2
	move	a2,*a9(OYPOS)

	move	*a13(PDATA),a0,L
	move	*a0(ply_time),a0
	cmpi	25,a0
	jrlt	#mex

	move	a9,a8
	jauc	DELOBJDIE

#mex	SLEEPK	1
	move	@HALT,a0
	jrnz	#mex
	dsj	a11,#metop
	move	a9,a0
	calla	DELOBJ	
	DIE

#******************************************************************
*
* a10=PxDATA ram

 SUBR	stick_spark

	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE,a4
	move	*a13(PROCID),a5			;get pid for stick img oid
	movi	[-65,0],a1
	movi	lighten1,a2
	clr	a3
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	move	a8,a9

	sll	5,a11
	addi	plyrobj_t,a11

	move	*a11,a8,L			;player img to stick to
#metop0
	move	a9,a0
	movi	400h,a14
	move	a14,*a0(OYPOS)
	calla	OBJOFF
	movi	light_t,a10
	movi	4*60,a0			;4*60,a0
	calla	RNDRNG0
	addi	30,a0			;30
	calla	PRCSLP
	move	a9,a0
	calla	OBJON
	movk	1,a0
	move	a0,*a13(PDATA)
#metop

	move	*a13(PDATA),a0
	dec	a0
	move	a0,*a13(PDATA)
	jrnz	#cont
	movk	3,a0
	move	a0,*a13(PDATA)

	move	*a10+,a0,L
	jrz	#metop0
	SWAP	a8,a9
	move	*a8(OFLAGS),a1
	calla	obj_aniq
	SWAP	a8,a9
	move	*a10+,a0
	move	a0,*a13(PDATA+16)
	move	*a10+,a0
	move	a0,*a13(PDATA+32)

#cont

	calla	anipt_getsclxy			;GETANIXY
	srl	16,a0

	move	*a8(OZPOS),a2
	addk	3,a2
	move	a2,*a9(OZPOS)

	move	*a8(OXPOS),a2
	addk	3,a2
	add	a0,a2
	move	*a13(PDATA+16),a0
	sub	a0,a2
	move	a2,*a9(OXPOS)

	move	*a8(OPLINK),a0,L
	move	*a0(plyr_headobj_p),a0,L
	move	*a0(OYPOS),a2
	addi	44h,a2
	move	*a13(PDATA+32),a0
	sub	a0,a2
	move	a2,*a9(OYPOS)


#mex	SLEEPK	1
;	move	@HALT,a0
;	jrnz	#mex
	jruc	#metop


light_t
	LWW	lighten1,1,10
	LWW	lighten2,-2,20
	LWW	lighten3,-5,37
	LWW	lighten4,2,44
	LWW	lighten5,4,56
	LWW	lighten6,4,65
	LWW	lighten7,1,69
	.long	0

#******************************************************************
*
* a10=PxDATA ram

 SUBR	stick_spark2

	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE|M_FLIPH,a4
	move	*a13(PROCID),a5			;get pid for stick img oid
	movi	[-65,0],a1
	movi	lighten1,a2
	clr	a3
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	move	a8,a9

	sll	5,a11
	addi	plyrobj_t,a11

	move	*a11,a8,L			;player img to stick to
#metop0
	move	a9,a0
	movi	400h,a14
	move	a14,*a0(OYPOS)
	calla	OBJOFF
	movi	light_t,a10
	movi	4*60,a0			;4*60,a0
	calla	RNDRNG0
	addi	30,a0			;30
	calla	PRCSLP
	move	a9,a0
	calla	OBJON
	movk	1,a0
	move	a0,*a13(PDATA)
#metop

	move	*a13(PDATA),a0
	dec	a0
	move	a0,*a13(PDATA)
	jrnz	#cont
	movk	3,a0
	move	a0,*a13(PDATA)

	move	*a10+,a0,L
	jrz	#metop0
	SWAP	a8,a9
	move	*a8(OFLAGS),a1
	calla	obj_aniq
	SWAP	a8,a9
	move	*a10+,a0
	move	a0,*a13(PDATA+16)
	move	*a10+,a0
	move	a0,*a13(PDATA+32)

#cont

	calla	anipt_getsclxy			;GETANIXY
	srl	16,a0

	move	*a8(OZPOS),a2
	addk	3,a2
	move	a2,*a9(OZPOS)

	move	*a8(OXPOS),a2
	subk	7,a2
	add	a0,a2
	move	*a13(PDATA+16),a0
	add	a0,a2
	move	a2,*a9(OXPOS)

	move	*a8(OPLINK),a0,L
	move	*a0(plyr_headobj_p),a0,L
	move	*a0(OYPOS),a2
	addi	44h,a2
	move	*a13(PDATA+32),a0
	sub	a0,a2
	addi	10,a2
	move	a2,*a9(OYPOS)


#mex	SLEEPK	1
;	move	@HALT,a0
;	jrnz	#mex
	jruc	#metop

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
	move	*a9(ply_meter_imgs+20h),a0,L
	calla	OBJOFF
	move	*a9(ply_meter_imgs+40h),a0,L
	calla	OBJOFF

#nxt
	jruc	#nxta

#nxta
	addi	PDSIZE,a9
	addk	1,a3
	dsj	a4,#msglp

	jruc	main0

#showpnames
#*
;Try to swap buyin message and turbo meters for player names

	movi	scorep,a0
	calla	pal_getf
	move	a0,a5

	movk	4,a4
	movi	P1DATA,a9
	movi	names,a10
	clr	a3

#pnlp
	move	@pleasewt,a14
	btst	a3,a14      
	jrnz	#nxtpn


	move	*a9(ply_messages),a8,L
	jrz	#noani

	move	a8,a0
	calla	OBJOFF

	move	*a9(ply_meter_imgs),a0,L
	move	*a0(OYPOS),a14
	cmpi	5,a14
	jrnz	#dip
	movi	15,a14
	jruc	#dip2

#dip	movi	18,a14

#dip2	move	a14,*a0(OYPOS)
	calla	OBJON
;	move	*a9(ply_meter_imgs+20h),a0,L
;	calla	OBJON

	move	@TWOPLAYERS,a0
	jrz	#not2p

;Turmell 3/23/93
	cmpi	1,a3
	jrz	#not2p
	cmpi	2,a3
	jrz	#not2p

	move	a8,a0
	calla	OBJOFF
	jruc	#inhr
#not2p
	movi	tocontrol,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	jruc	#inhr


;	jruc	#nxtpn

;	move	*a9(ply_meter_imgs+20h),a0,L
;	calla	OBJON
;	move	*a9(ply_meter_imgs+40h),a0,L
;	calla	OBJON

;	jruc	#ani

#noani

	move	*a9(ply_time),a1
	subk	23,a1
	jrlt	#nxtpn
#inhr
	move	*a9(ply_meter_imgs),a8,L	;change box to name
	move	a5,*a8(OPAL)
#ani
	move	*a10,a0,L
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

#nxtpn	addi	PDSIZE,a9
	addk	1,a3
	addk	32,a10
	dsj	a4,#pnlp

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

	move	*a2(ply_meter_imgs+>20),a8,L
	move	a10,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

	movk	07h,a0 			;5
	move	a0,*a8(OYPOS)
	
	move	*a2(ply_meter_imgs+>40),a0,L
	calla	OBJOFF

	dsj	a3,#lp

	jruc	mlp110


meters_t
;	.long	0,METERr,METERy,METERg,METERb
;MJT
	.long	0,METERb,METERg,METERy,METERr

mlp105
	movi	msg_ram,a9
	movk	4,a3
#lp2	move	*a9+,a2,L
	jrz	mlp110
	move	*a2(ply_meter_imgs),a0,L
	calla	OBJON

	move	*a2(ply_meter_imgs+>20),a8,L
	move	a3,a0
	sll	5,a0
	addi	meters_t,a0
	move	*a0,a0,L

;	movi	METERg,a0			;change back to meter

	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

	movk	17,a0			;11
	move	a0,*a8(OYPOS)

	move	*a2(ply_meter_imgs+>40),a0,L
	calla	OBJON

	dsj	a3,#lp2

mlp110
	calla	prt_cr_timers

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

	SLEEP	40			;TSEC*2

	movi	4*TSEC+10-70,a11

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
	calla	obj_del1c		;kill credit/qrtr imgs

	callr	prt_credits

	calla	CR_STRTP		;Credits to start
	jrlo	#no			;No?
	movi	start,a10
	movi	insert,a3
	jruc	#yes
#no	movi	insert,a10
	movi	start,a3
#yes

	calla	CR_CONTP		;Credits to continue
	jrlo	#no2			;No?
	movi	start,a11
	movi	insert,a3
	jruc	#yes2
#no2	movi	insert,a11
	movi	start,a3
#yes2

***********************************************************

	move	@TWOPLAYERS,a0
	jrnz	#tag0

	move	a10,a0
	move	@PSTATUS2,a4
	btst	0,a4
	jrz	#no3
	move	a11,a0			;A continue
#no3
	move	@P1DATA+ply_messages,a8,L
	jrz	#tag
	move	*a8(OIMG),a2,L
	cmp	a3,a2
	jrnz	#tag
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

	jruc	#tag0

#tag
;now check to see if player is under 10 seconds and message has flopped
;into his meter img
	move	@P1DATA+ply_meter_imgs+>20,a8,L
	jrz	#tag0
	move	*a8(OIMG),a1,L
;	cmpi	METERr,a1
;MJT
	cmpi	METERb,a1

	jrz	#tag0
	cmpi	METERb,a1
	jrz	#tag0
	cmp	a0,a1
	jrz	#tag0			;already correct message
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

**********************************************************

#tag0
	move	a10,a0
	move	@PSTATUS2,a4
	btst	1,a4
	jrz	#no3a
	move	a11,a0
#no3a
	move	@P2DATA+ply_messages,a8,L
	jrz	#tag1
	move	*a8(OIMG),a2,L
	cmp	a3,a2
	jrnz	#tag1
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	jruc	#tag1a
#tag1
	move	@P2DATA+ply_meter_imgs+>20,a8,L
	jrz	#tag1a
	move	*a8(OIMG),a1,L

;	cmpi	METERy,a1
	cmpi	METERg,a1

	jrz	#tag1a
	cmpi	METERb,a1
	jrz	#tag1a
	cmp	a0,a1
	jrz	#tag1a			;already correct message
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

***********************************************************

#tag1a
	move	a10,a0
	move	@PSTATUS2,a4
	btst	2,a4
	jrz	#no3b
	move	a11,a0
#no3b
	move	@P3DATA+ply_messages,a8,L
	jrz	#tag3
	move	*a8(OIMG),a2,L
	cmp	a3,a2
	jrnz	#tag3	      
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	jruc	#tag2a
#tag3
	move	@P3DATA+ply_meter_imgs+>20,a8,L
	jrz	#tag2a
	move	*a8(OIMG),a1,L

;	cmpi	METERg,a1


	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not_2p5
	cmpi	METERr,a1
	jruc	#2pf
#not_2p5


	cmpi	METERy,a1
#2pf

	jrz	#tag2a
	cmpi	METERb,a1
	jrz	#tag2a
	cmp	a0,a1
	jrz	#tag2a			;already correct message
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

***********************************************************

#tag2a
	move	@TWOPLAYERS,a0
	jrnz	xo

	move	a10,a0
	move	@PSTATUS2,a4
	btst	3,a4
	jrz	#no3c
	move	a11,a0
#no3c
	move	@P4DATA+ply_messages,a8,L
	jrz	#tag4
	move	*a8(OIMG),a2,L
	cmp	a3,a2
	jrnz	xo
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
	jruc	xo
#tag4
	move	@P4DATA+ply_meter_imgs+>20,a8,L
	jrz	xo
	move	*a8(OIMG),a1,L

;	cmpi	METERb,a1
	cmpi	METERr,a1

	jrz	xo
	cmp	a0,a1
	jrz	xo
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
xo	PULL	a8,a11
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
	calla	BINBCD
	
	move	a0,a9
	sll	32-4,a0
	srl	32-4-5,a0		;*32
	addi	#numbs,a0
	move	*a0,a2,L
	movi	>d7,a0
	movk	3,a1
	sll	16,a0
	sll	16,a1
	movi	949,a3			;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD|creditid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	
	srl	4,a9
	sll	32-4,a9
	srl	32-4-5,a9		;*32
	addi	#numbs,a9
	move	*a9,a2,L
	movi	>d7-5,a0
	movk	3,a1
	sll	16,a0
	sll	16,a1
	calla	BEGINOBJ2
	
	movi	credit,a2
	jruc	free1

freep
	movi	freeply,a2
free1	movk	3,a1			;Y
	movi	>b3,a0
	sll	16,a0
	sll	16,a1
	movi	949,a3			;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD|creditid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	PULL	a8,a9
	rets

#numbs	.long	font60,font61,font62,font63,font64,font65,font66,font67
	.long	font68,font69


****************************************************************
* Start main game clock

 SUBR	clock_strt


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
	sll	16,a0
	sll	16,a1
	move	*a11+,a3		;Z
	movi	DMAWNZ|M_NOCOLL|M_3DQ,a4
	move	*a11+,a2,L
	movi	CLSDEAD|gclockid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a0,*a10+,L
	movi	gndpos_t+32*16,a1
	move	a1,*a8(ODATA_p),L

#status	move	*a11+,a0		;X
	cmpi	4000,a0
	jrne	#lp			;!End?

	movk	1,a0
	move	a0,@clock_active

#lp1	calla	prt_top_clock
#lp1a	SLEEPK	1
	move	@HALT,a0
	jrnz	#lp1a

;When testing dunks - PUT IN!
;	jruc	#lp1a			;Debug - no time clock on

	.if	IMGVIEW
	jruc	#lp1a			;Debug - no time clock on
	.endif

	move	@clock_active,a0
	jrnz	#lp1a


;Fix
	movi	ADJSPEED,a0		;game timer speed (1-5)
	calla	GET_ADJ
	sll	4,a0			;x 16 bits
	addi	timer_table-10h,a0
	move	*a0,a1
	move	@PSTATUS,a0
	cmpi	>f,a0
	jrnz	#not4
;In a 4 plyr game, make clock go faster!
	addi	200h,a1			;100h
#not4

;	movi	>ffff,a1

	move	@clock_speed,a0
	add	a1,a0
;	zext	a0
	move	a0,@clock_speed
	jrnc	#lp1a

	movi	game_time,a10
	movb	*a10,a0			;grab 10ths of second byte
	jrz	#tag
	dec	a0
	movb	a0,*a10
	movb	@game_time+24,a0
	jrz	#lp1
	jruc	#lp1a
#tag	
	movk	9,a0			;restuff 10ths of second
	movb	a0,*a10
	movb	*a10(8),a0		;grab seconds byte
	jrz	#tag1
	dec	a0
	movb	a0,*a10(8)
	jruc	#lp1
#tag1
	movk	9,a0
	movb	a0,*a10(8)		;restuff single seconds byte
	movb	*a10(16),a0		;grab 10 seconds byte
	jrz	#tag2
	dec	a0
	movb	a0,*a10(16)
	jruc	#lp1
#tag2	


	movb	*a10(24),a0		;Minute byte
	cmpi	3,a0
	jrhs	#nodaj
	.ref	drone_adjskill
	calla	drone_adjskill		;Pass A0
#nodaj


	movk	5,a0
	movb	a0,*a10(16)		;restuff 10 seconds byte
	movb	*a10(24),a0		;grab minute byte
	jrz	#tag3
	dec	a0
	movb	a0,*a10(24)
	jrnz	#lp1

;rearrange top clock to allow tenths of seconds

     	move	@clock_imgs+>20,a0,L
	movi	186,a1
	move	a1,*a0(OXPOS)
	
     	move	@clock_imgs+>40,a0,L
	movi	194,a1
	move	a1,*a0(OXPOS)

     	move	@clock_imgs+>60,a0,L
	movi	>cb,a1
	move	a1,*a0(OXPOS)

     	move	@clock_imgs+>0,a0,L
	movi	>d4,a1
	move	a1,*a0(OXPOS)

;Possibly rearrange bottom clock piece also!
;FIX!!!!
	CREATE0	tick_tock

;RJR
;	movi	minute_snd,a0
;	calla	snd_play1
	CREATE0	one_min_to_go


	move	@bclok_imgs,a0,L
	calla	ISOBJ
	jrnz	#yes

;Turn that clock on!
	CREATE	tvid,scr_clock

	SLEEPK	2


	move	@bclok_imgs,a0,L
;	jruc	#lp1
#yes	move	*a0(OIMG),a1,L
	cmpi	clock,a1
	jrnz	#lp1

;yes rearrange bottom clock because it is on screen!

	move	a0,a8
	movi	clock2,a0
	move	*a8(OCTRL),a1
	calla	obj_aniq
	move	@bclok_imgs+32,a1,L
	movi	>136,a0
	move	a0,*a1(OXPOS)
	move	@bclok_imgs+64,a1,L
	movi	>116,a0
	move	a0,*a1(OXPOS)
	move	@bclok_imgs+96,a1,L
	movi	>120,a0
	move	a0,*a1(OXPOS)
	jruc	#lp1


#tag3
;Rearrange clock imgs so they are correct

     	move	@clock_imgs+>20,a0,L
	movi	>c8,a1
	move	a1,*a0(OXPOS)
	
     	move	@clock_imgs+>40,a0,L
	movi	>d0,a1
	move	a1,*a0(OXPOS)
 
     	move	@clock_imgs+>60,a0,L
	movi	>c4,a1
	move	a1,*a0(OXPOS)

     	move	@clock_imgs+>0,a0,L
	movi	>bb,a1
	move	a1,*a0(OXPOS)

	move	@tvpanelon,a0,L
	jrnz	#tag4x

;clock is out on screen all by itself!

	movi	tvid,a0			;Delete big clock at botm of scrn
	calla	KIL1C
	movi	CLSDEAD|bclockid,a0
	calla	obj_del1c

#tag4x
	movk	1,a0
	move	a0,@clock_active
	clr	a0
	move	a0,@game_time,L

	movi	horn_snd,a0
	calla	snd_play1ovr

	move	@_4plyrsingame,a0
	jrnz	#skip
	move	@PSTATUS,a0
	cmpi	>f,a0
	jrz	#skip
	movk	1,a0
	move	a0,@_4plyrsingame
#skip

;	movi	qtr_purchased,a1	; - 1 quater for each player
;	clr	a2
;#dec_loop
;	move	*a1,a0
;	jrz	#skip2
;	dec	a0
;	move	a0,*a1
;	jrnz	#skip2
;
;;	LOCKUP
;
;	movk	1,a0
;	sla	a2,a0
;	move	@PSTATUS,a3
;	andn	a0,a3
;	move	a3,@PSTATUS
;#skip2
;	addk	16,a1
;	inc	a2
;	cmpi	3,a2
;	jrls	#dec_loop

;	move	@gmqrtr,a0
;	jrz	#tn2
;	cmpi	2,a0
;	jrnz	#ntn2
;#tn2	movi	tuneend_snd,a0
;	calla	snd_play1
;#ntn2

	JSRP	plyr_endofqrtr

 SUBR	cliplockretp			;Restore point for clip lockup code

	movk	1,a0
	move	a0,@clock_active

	movi	QRTRTIME,a0		;4 minutes, 0 secs, 0 tenths
	move	@gmqrtr,a1
	subk	4,a1
	jrlt	#notot

	movi	intoot_snd,a0
	calla	snd_play1

	move	@tvpanelon,a0,L
	jrz	#skp
	calla	process_exist
	jrz	#skp
	movi	tv3a,a7
	calla	XFERPROC

#skp
	
;Overtime clock set
	movi	QRTRTIME,a0		;2 minutes, 0 secs, 0 tenths
	move	a0,@game_time,L
	clr	a0
	move	a0,@clock_speed
	movi	P1DATA,a11		;A11=*plyr data
	callr	refill_turbo
	movi	P2DATA,a11		;A11=*plyr data
	callr	refill_turbo
	movi	P3DATA,a11		;A11=*plyr data
	callr	refill_turbo
	movi	P4DATA,a11		;A11=*plyr data
	callr	refill_turbo
	callr	prt_qrtr

#kp	SLEEPK	1
	move	@tvpanelon,a0,L
	jrnz	#kp
	
	CREATE	tvid,scr_clock

	move	@gmqrtr,a0
	cmpi	2,a0
	jrnz	#cc
	PUSH	a0
	CREATE0	do_show
	PULL	a0
#cc
	sll	5,a0
	addi	#tune_t,a0
	move	*a0,a0,L
	calla	snd_play1ovr
	
	jruc	#lp1


do_show
	SLEEP	120
	movi	showtm,a0
	calla	snd_play1ovr
	DIE

#notot	move	a0,@game_time,L


;Refill everyones turbo meter in between quarters!

	movi	P1DATA,a11		;A11=*plyr data
	callr	refill_turbo
	movi	P2DATA,a11		;A11=*plyr data
	callr	refill_turbo
	movi	P3DATA,a11		;A11=*plyr data
	callr	refill_turbo
	movi	P4DATA,a11		;A11=*plyr data
	callr	refill_turbo
	callr	prt_qrtr


	CREATE	tvid,scr_clock

	move	@gmqrtr,a0
	sll	5,a0
	addi	#tune_t,a0
	move	*a0,a0,L
	calla	snd_play1ovr

	jruc	#lp1

#tune_t	.long	tuneq2_snd,tuneq2_snd,tuneq3_snd,tuneq4_snd,tuneq4_snd
	.long	tuneot_snd,tuneot_snd,tuneot_snd
	.long	tuneot_snd,tuneot_snd,tuneot_snd
	.long	tuneot_snd,tuneot_snd,tuneot_snd
	.long	tuneot_snd,tuneot_snd,tuneot_snd

;RJR
 SUBRP	one_min_to_go

#try_again
	SLEEPK	1
	movi	minute_snd,a0
	calla	snd_play1
	jrc	#try_again

	DIE


tick_tock

;Gets created at 1 minute mark in each quarter!

	SLEEP	10*60
#tick	SLEEP	36
	move	@game_time,a0,L
	jaz	SUCIDE
	move	@game_time+16,a0
	jrnz	#tick
	move	@clock_active,a0
	jrnz	#tick

	movi	tick_snd,a0
	XORK	1,a9
	jrz	#tok
	movi	tock_snd,a0
#tok	calla	snd_play1
	jruc	#tick


qrtrt1	.long	qrtr1,qrtr2,qrtr3,qrtr4,qrtr4,qrtr4,qrtr4
	.long	qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4
	.long	qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4,qrtr4
prt_qrtr
	movi	CLSDEAD|qrtrid,a0
	calla	obj_del1c		;kill credit/qrtr imgs
	movi	[>b9,0],a0
	movi	[>68,0],a1
	movi	987,a3
	movi	DMAWNZ|M_NOCOLL|M_3DQ,a4
	move	@gmqrtr,a2
	sll	5,a2
	addi	qrtrt1,a2
	move	*a2,a2,L
	movi	CLSDEAD|qrtrid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
;	move	a0,*a10+,L
	movi	gndpos_t+32*16,a1
	move	a1,*a8(ODATA_p),L
	rets


	.asg	-3,X
	.asg	94,Y
	.asg	987,Z
#init_t
;minutes, seconds
	.word	X+190+1,Y-1,Z
	.long	S_LED_0r			;red pal
	.word	X+203+1,Y-1,Z
	.long	S_LED_0r
	.word	X+211+1,Y-1,Z
	.long	S_LED_0r
	.word	X+199+1,Y+1-1,Z
	.long	colon
;scores
	.word	X+170,Y+5,Z
	.long	LED_00
	.word	X+240,Y+5,Z
	.long	LED_00

	.word	4000


		
**************************************************************************
* a11=PxDATA
* Completely refill turbo meter

 SUBR	refill_turbo

	clr	a2
	cmpi	P1DATA,a11
	jrz	#1
	movk	1,a2
	cmpi	P2DATA,a11
	jrz	#1
	movk	2,a2
	cmpi	P3DATA,a11
	jrz	#1
	movk	3,a2
#1


;	move	@PSTATUS,a1
;	btst	a2,a1
;	jrz	#notingame

	move	*a11(ply_meter_imgs+40h),a2,L	;LITUP img 
	clr	a1
	move	a1,*a2(OFSET)
	movi	>2f,a2	;2f	 		;OSIZEX of litup meter img
	move	a2,*a11(ply_turbo)		;max out turbo meter
	movk	1,a2
	move	a2,*a11(ply_turbo_dl)		;turbo cnt delay

;#notingame
	rets

 SUBRP	replenish_turbo
	
	move	*a0(ply_meter_imgs+40h),a2,L	;LITUP img 
	move	*a2(OFSET),a1			;Need to shrink LITUP img
	jrz	#x
	subk	1,a1
	move	a1,*a2(OFSET)
	move	*a0(ply_turbo),a1
	addk	1,a1
	move	a1,*a0(ply_turbo)		;Turbo meter size to get smaller
#x	rets



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
	move	@plyrnumonfire,a0
	cmp	a9,a0
	jrnz	#noaud

	move	@GAMSTATE,a0
	cmpi	INAMODE,a0
	jrz	#noaud

	PUSH	a0,a3
	move	@ballptsforshot,a1
	movi	AUD_HOTSTRKPTS,a0
	calla	AUD
	PULL	a0,a3

#noaud


	CREATE0	flsh_bgnd
	CREATE0	start_animate

	move	@assist_plyr,a1
	jrz	#sx
	dec	a1
	movk	PS_ASSISTS,a0
	calla	inc_player_stat
#sx
	PULL	a1,a7,a9

	rets

flsh_bgnd
;a9=0-3
	.ref	ballptsforshot
	move	@ballptsforshot,a0
	cmpi	3,a0
	jrnz	#f0

;Turn on 3 pntr message
	CREATE0	threepnts_drw


#f0
	SLEEPK	20
;	movk	1,a1
;	move	a1,@clock_active
;	move	a9,a0


	move	@game_time,a0,L
	jaz	SUCIDE

	clr	a1
	sll	4,a9
	addi	#x_t,a9
	move	*a9,a0
	sll	16,a0
	movi	bbal_w,a2
	movi	290,a3				;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
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

	DIE

#x_t
;	.word	10,58h,0e8h-2,13ch-3
	.word	7,57h,0e9h,137h


threepnts_drw
	movi	[19,0],a1			;18
	movi	[>c8,0],a0
	movi	threepnts,a2
	movi	>7590,a3
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	CREATE0	blink_plyr
	move	a0,a9
	SLEEP	150
	move	a9,a0
	calla	KILL
	move	a8,a0
	calla	DELOBJ
	DIE

tmodex	.long	[20,0],[6ch,0],[0d7h,0],[12eh,0]

 SUBR	nosecrets_drw

	sll	5,a8
	addi	tmodex,a8
	move	*a8,a0,L

	movi	[202,0],a1			;18
	movi	nosecrets,a2
	movi	>7590,a3
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	.ref	blink_plyr2

	CREATE0	blink_plyr2
	move	a0,a9
	SLEEP	90
	move	a9,a0
	calla	KILL
	move	a8,a0
	calla	DELOBJ
	DIE


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

#x_t2	.word	7,57h,0eah,137h

********************************
	
 SUBRP	prt_top_clock

	PUSH	a2,a3,a4,a5,a6,a7,a8

	movb	@game_time+24,a0		;print minutes
	jrnz	#tag4
	movb	@game_time+0,a0			;print 10ths of sec
#tag4	sll	5,a0
	addi	leds,a0
	move	*a0,a0,L
	move	@clock_imgs+0,a8,L
	move	*a8(OCTRL),a1
	calla	obj_aniq

	movb	@game_time+16,a0		;print 10 secs
	sll	5,a0
	addi	leds,a0
	move	*a0,a0,L
	move	@clock_imgs+>20,a8,L
	move	*a8(OCTRL),a1
	calla	obj_aniq

	movb	@game_time+8,a0			;print secs
	sll	5,a0
	addi	leds,a0
	move	*a0,a0,L
	move	@clock_imgs+>40,a8,L
	move	*a8(OCTRL),a1
	calla	obj_aniq

	PULL	a2,a3,a4,a5,a6,a7,a8
	rets

leds	.long	S_LED_0,S_LED_1,S_LED_2,S_LED_3,S_LED_4,S_LED_5,S_LED_6
	.LONG	S_LED_7,S_LED_8,S_LED_9


********************************************************************
* Print all 4 players credit timers if in game
* Trashes scratch, A9

 SUBR	prt_cr_timers

	PUSH	a8,a11


	movi	P1DATA,a9
	clr	a11
prt05	move	@PSTATUS,a0		;Plyr start bits 0-3
	btst	a11,a0
	jrz	#nxt

;Check to see if player name is in place of credit timer!  If so, don't try
;to print out timers

	move	*a9(ply_meter_imgs),a8,L
	jrz	#nxt

	move	*a8(OIMG),a0,L
	cmpi	LED_00,a0
	jrne	#nxt			;Not counter?

	move	*a9(ply_time),a0
	cmpi	1000,a0
	jrlo	prt07
;	movi	999,a0
	movi	LED_MAX,a0
	jruc	prt09
prt07
	sll	5,a0
	addi	LED_0,a0
prt09	move	*a0,a0,L
	move	a0,*a8(OSAG),L

#nxt	addi	PDSIZE,a9
	inc	a11
	cmpi	4,a11
	jrnz	prt05

	PULL	a8,a11
	rets


#***********************************************************************
* Print small scores at top of screen

 SUBR	prt_top_scores

	PUSH	a2,a3,a4,a5,a6,a7,a8

	move	@score_imgs,a8,L	;Team 1
	move	@scores,a0
	sll	5,a0
	addi	LED_0,a0
	move	*a0,a0,L
	move	a0,*a8(OSAG),L

	move	@score_imgs+32,a8,L	;Team 2
	move	@scores+16,a0
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

	move	a0,a0
	jrnz	tv4x				;br=clock already on scrn
	CREATE	tvid,scr_clock

tv4x	movi	[9,0],a0
	movi	[185,0],a1
	movi	5000,a3
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	metal1,a2
	movi	CLSDEAD|tvid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movi	[9,0],a0
	movi	[185,0],a1
	movi	metal2,a2
	calla	BEGINOBJ2

	movi	[185,0],a1
	move	@gmqrtr,a2
	sll	5,a2


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
#tie	movi	[9,0],a0
	move	*a2,a2,L
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	calla	BEGINOBJ2
	jruc	#skip


#notend
	addi	qrtrt,a2
	movi	[9,0],a0
	move	*a2,a2,L
	calla	BEGINOBJ2

	move	@gmqrtr,a2
	subk	4,a2
	jrge	#skip

	movi	[9,0],a0
	movi	[185,0],a1
	movi	quarter,a2
	calla	BEGINOBJ2

#skip
	movi	[64,0],a0
	movi	[185,0],a1
	move	@team1,a2
	cmpi	27,a2
	jrnz	#reg
	
	movi	[185-3,0],a1
	movi	OSGEMD_J,a2
	movi	GREENPAL,b0
	calla	BEGINOBJP2
	movi	[4ch,0],a0
	movi	[185-3,0],a1
	movi	OSGEMD_A,a2
	movi	GREENPAL,b0
	calla	BEGINOBJP2
	movi	[5bh,0],a0
	movi	[185-3,0],a1
	movi	OSGEMD_M,a2
	movi	GREENPAL,b0
	calla	BEGINOBJP2
	jruc	#nx
#reg	
	sll	5,a2
	addi	team_nms,a2
	move	*a2,a2,L
	calla	BEGINOBJ2

#nx
	movi	[64,0],a0
	movi	[185+19,0],a1
	move	@team2,a2

	cmpi	27,a2
	jrnz	#reg2
	
	movi	[185+18,0],a1
	movi	OSGEMD_J,a2
	movi	GREENPAL,b0
	calla	BEGINOBJP2
	movi	[4ch,0],a0
	movi	[185+18,0],a1
	movi	OSGEMD_A,a2
	movi	GREENPAL,b0
	calla	BEGINOBJP2
	movi	[5bh,0],a0
	movi	[185+18,0],a1
	movi	OSGEMD_M,a2
	movi	GREENPAL,b0
	calla	BEGINOBJP2
	jruc	#nx2
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

	movi	5000,a3
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4

team_nms
	.long	ATL,BOST,CHAR,CHI,CLEV,DAL,DEN,DET,GOLDN,HOU,IND,LA_CLIP
	.long	LA_LAKS,MIAMI,MILW,MINN,NJ,NY,ORL,PHIL,PHX,PORT,SAC,SANANT
	.long	SEA,UTAH,WASH


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
	movi	MD_16r,a0
	calla	pal_getf
	move	*a9,a8,L
	move	a0,*a8(OPAL)
	move	*a9(32),a8,L
	move	a0,*a8(OPAL)
	move	*a9(64),a8,L
	move	a0,*a8(OPAL)
	SLEEPK	5
	movi	MD_16,a0
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

	movi	[309-16,0],a0
	movi	[184+1,0],a1
	calla	BEGINOBJ2
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

	movi	[324-16,0],a0
	movi	[184+1,0],a1
	calla	BEGINOBJ2
	move	a8,*a10,L
#notens
	addk	32,a10

	sll	32-4,a9			;>Ones
	srl	32-4-5,a9		;*32
	addi	#n_t,a9
	move	*a9,a2,L

	movi	[339-16,0],a0
	movi	[184+1,0],a1
	calla	BEGINOBJ2
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

	movi	[309-16,0],a0
	movi	[204,0],a1
	calla	BEGINOBJ2
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

	movi	[324-16,0],a0
	movi	[204,0],a1
	calla	BEGINOBJ2
	move	a8,*a10,L
#notens2
	addk	32,a10

	sll	32-4,a9			;>Ones
	srl	32-4-5,a9		;*32
	addi	#n_t,a9
	move	*a9,a2,L

	movi	[339-16,0],a0
	movi	[204,0],a1
	calla	BEGINOBJ2
	move	a8,*a10+,L

	PULL	a9,a10

	rets


#n_t	.long	SMD16_0,SMD16_1,SMD16_2,SMD16_3,SMD16_4,SMD16_5,SMD16_6
	.long	SMD16_7,SMD16_8,SMD16_9



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
	jrnz	reg
	movi	#init_t2,a11
	jruc	#status
reg	movi	#init_t,a11
	jruc	#status
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
	.word	9,185,5000
	.long	clock
	.word	305-26,230,5000
	.long	font90
	.word	315-21,230,5000
	.long	font90
	.word	325-21,230,5000
	.long	font90

	.word	4000

#init_t2
	.word	9,185,5000
	.long	clock2
	.word	>130,230,5000
	.long	font90
	.word	>116,230,5000
	.long	font90
	.word	>120,230,5000
	.long	font90

	.word	4000

qrtrt	.long	one,two,three,four,overtime,DoubleOT,TripleOT,TripleOT
	.long	TripleOT,final
eqrtrt	.long	endof1,endof1,halftime,endof3,final,final,final,final,final
	.long	final,final,final,final
tie_eqrtrt
	.long	endof1,endof1,halftime,endof3,endof4,overtime,DoubleOT,TripleOT
	.long	TripleOT,TripleOT,TripleOT,TripleOT,TripleOT,TripleOT

#****************************************************************
* Start shot clock timer, when clock gets down to 10 seconds,
* then display the clock in the lower corner furthest away from
* the hoop.
* A0=0 shooting at rgt hoop, 1=left hoop
* Trashes scratch

 SUBR	shot_clock

;When testing dunks - PUT IN!
;	rets

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

;Warn players of shot clock running down
	movi	warn_snd,a0
	calla	snd_play1
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

	movi	horn_snd,a0
	calla	snd_play1ovr

#tag1X
	SLEEPK	1

;Shot clock ran out - turnover!  Unless the ball is in the air toward hoop!
	move	@ballgoaltcnt,a0
	jrgt	markdi

	movk	1,a0
	move	a0,@clock_active

	CREATE0	shot_text

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

numbs	.long	font90,font91,font92,font93,font94,font95,font96,font97
	.long	font98,font99
bnumbs
	.long	BigLED_0,BigLED_1,BigLED_2,BigLED_3,BigLED_4,BigLED_5
	.long	BigLED_6,BigLED_7,BigLED_8,BigLED_9


#init_t
	.word	>13d,>e0,5000
	.long	shotclok
	.word	>13d+9,>d9,5000
	.long	BigLED_0		;font90r
	.word	>13d+>1c,>d9,5000
	.long	BigLED_0		;font90r

	.word	4000

#init_t2
	.word	>1c,>e0,5000
	.long	shotclok
	.word	>24,>d9,5000
	.long	BigLED_0		;font90r
	.word	>37,>d9,5000
	.long	BigLED_0		;font90r

	.word	4000
		


#********************************
* Print shot clock violation text

 SUBRP	shot_text

	movi	#ln0_setup,a2
	calla	setup_message

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	120-8-44,a0
	move	a0,@mess_cursy
	movi	#str_shtclk1,a4
	calla	print_string_C2

	movi	120+8,a0
	move	a0,@mess_cursy
	movi	#str_shtclk2,a4
	calla	print_string_C2

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
	RJR_STR	omlgmd_ascii,12,1,200,6,LGMDRED2,0

#str_shtclk1
	.string	"SHOT  CLOCK",0
#str_shtclk2
	.string	"VIOLATION",0

	.even


#*

 SUBR	show_ot_msg

;Display Double or Triple OT message, keep going...
	SLEEP	60

	movi	#ln0_setup,a2
	calla	setup_message

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	move	@gmqrtr,a0
	subk	4,a0
	sll	5,a0
	movi	oty,a1
	add	a0,a1
	move	*a1,a2
	move	a2,@mess_cursy
	movi	otl1,a1
	add	a0,a1
	move	*a1,a4,L

	PUSH	a0
	calla	print_string_C2
	PULL	a0

	move	@mess_cursy,a1
	addi	70,a1
	move	a1,@mess_cursy

	movi	otl2,a1
	add	a0,a1
	move	*a1,a4,L
	jrz	#sl
	calla	print_string_C2

#sl
	movk	5,a10			;8
	CREATE0	doalert_snd
	CREATE0	flash_bigtxt
	move	a0,a9

	SLEEP	TSEC*3+40-20

	move	a9,a0
	calla	KILL

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

	DIE

 SUBR	doalert_snd
	movi	whstle_snd,a0
	calla	snd_play1ovr
;	DIE

#al	movi	alert_snd,a0
	calla	snd_play1
	SLEEP	20
	dsj	a10,#al
	DIE


oty	.long	120-8-44+30-22,120-8-44-22,120-8-44-22,120-8-44-22,120-8-44-22
otl1	.long	#str_shtclk2,#str_shtclk1a,#str_shtclk1b,#str_shtclk1c
otl2	.long	0,#str_shtclk2,#str_shtclk2,#str_shtclk2

#ln0_setup
	RJR_STR	lgmd_ascii,12,2,200,6,LGMDRED2,0

#str_shtclk1a
	.string	"DOUBLE",0
#str_shtclk1b
	.string	"TRIPLE",0
#str_shtclk1c
	.string	"QUADRUPLE",0
#str_shtclk2
	.string	"OVERTIME",0

	.even

#*
	.def	plyrsdropped
	.bss	plyrsdropped,16

 SUBR	fix_dropout_msgs

	calla	CR_STRTP		;Credits to start
	jrlo	#no			;No?
	movi	start,a10
	jruc	#yes
#no	movi	insert,a10
#yes
	calla	CR_CONTP		;Credits to continue
	jrlo	#no2			;No?
	movi	start,a11
	jruc	#yes2
#no2	movi	insert,a11
#yes2

***********************************************************

	move	a10,a0
	move	@PSTATUS2,a4
	btst	0,a4
	jrz	#no3
	move	a11,a0			;A continue
#no3
	move	@P1DATA+ply_messages,a8,L
	move	*a8(OIMG),a0,L
	cmpi	please,a0
	jrnz	#nx1
	move	a11,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

#nx1
	move	a10,a0
	move	@PSTATUS2,a4
	btst	1,a4
	jrz	#no3a
	move	a11,a0			;A continue
#no3a
	move	@P2DATA+ply_messages,a8,L
	move	*a8(OIMG),a0,L
	cmpi	please,a0
	jrnz	#nx2
	move	a11,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

#nx2
	move	a10,a0
	move	@PSTATUS2,a4
	btst	2,a4
	jrz	#no3b
	move	a11,a0			;A continue
#no3b
	move	@P3DATA+ply_messages,a8,L
	move	*a8(OIMG),a0,L
	cmpi	please,a0
	jrnz	#nx3
	move	a11,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff

#nx3
	move	a10,a0
	move	@PSTATUS2,a4
	btst	3,a4
	jrz	#no3c
	move	a11,a0			;A continue
#no3c
	move	@P4DATA+ply_messages,a8,L
	move	*a8(OIMG),a0,L
	cmpi	please,a0
	jrnz	#nx4
	move	a11,a0
	movi	MSGOCTRL,a1
	calla	obj_aniq_cnoff
#nx4

	move	@PSTATUS,a0
	move	@plyrsdropped,a1
	btst	0,a1
	jrz	#n1
	btst	0,a0
	jrnz	#n1
	movi	P1DATA,a0
	callr	do_drop
#n1
	move	@PSTATUS,a0
	move	@plyrsdropped,a1
	btst	1,a1
	jrz	#n2
	btst	1,a0
	jrnz	#n2
	movi	P2DATA,a0
	callr	do_drop
#n2
	move	@PSTATUS,a0
	move	@plyrsdropped,a1
	btst	2,a1
	jrz	#n3
	btst	2,a0
	jrnz	#n3
	movi	P3DATA,a0
	callr	do_drop
#n3
	move	@PSTATUS,a0
	move	@plyrsdropped,a1
	btst	3,a1
	jrz	#n4
	btst	3,a0
	jrnz	#n4
	movi	P4DATA,a0
	callr	do_drop
#n4    
	callr	update_scorebrd		;make sure we show correct message
	rets

do_drop
;a0=PxDATA of player who dropped out!
	move	a0,a7
	cmpi	P1DATA,a0
	jrnz	#tag01
	movi	init_t1a,a11
	movi	P1DATA+ply_messages,a9
	movk	>0e,a4
	clr	a5
	jruc	#tago

#tag01	cmpi	P2DATA,a0
	jrnz	#tag02
	movi	init_t2a,a11
	movi	P2DATA+ply_messages,a9
	movk	>0d,a4
	movk	1,a5
	jruc	#tago

#tag02	cmpi	P3DATA,a0
	jrnz	#tag03
	movi	init_t3a,a11
	movi	P3DATA+ply_messages,a9
	movk	>0b,a4
	movk	2,a5
	jruc	#tago

#tag03
	movi	init_t4a,a11
	movi	P4DATA+ply_messages,a9
	movk	>07,a4
	movk	3,a5

#tago	move	a7,a3

	move	*a9,a0,L
	jrz	#tr
	calla	DELOBJ
#tr
;now delete this guys meter stuff & credit timer digits
	clr	a2
	move	*a3(ply_meter_imgs),a0,L
;	calla	DELOBJ
	calla	OBJOFF
	move	*a3(ply_meter_imgs+>20),a0,L
	calla	OBJOFF
	move	a2,*a3(ply_meter_imgs+>20),L
;	calla	DELOBJ
	move	*a3(ply_meter_imgs+>40),a0,L
	calla	OBJOFF
;	calla	DELOBJ

	calla	prt_status
	rets


#*
  SUBRP	ck_circle_stik
;For turning on shot % indicator  
	clr	a0
	move	a0,*a13(PDATA)

#lp	SLEEPK	1
	move	@PSTATUS,a0
	btst	a9,a0
	jrz	#lp
	move	a9,a0
	calla	get_stick_val_cur
	.ref	get_stick_val_cur

	move	*a13(PDATA),a1
	or	a0,a1
	move	a1,*a13(PDATA)
	cmpi	>f,a1
	jrnz	#lp
	move	a9,a0
	sll	4,a0
	addi	p1taps,a0
	move	*a0,a0
	cmpi	15,a0
	jrlt	#lp

	movk	1,a0
	move	a0,@show_shot
	DIE

#*
;a8=plyr obj

 SUBR	flash_plyr_wht
	clr	a0
	move	a0,@p1taps
	move	a0,@p2taps
	move	a0,@p3taps
	move	a0,@p4taps
	move	a0,@show_shot
	move	a0,@plyr_tourn
	move	a0,@baby_flag
	move	a0,@plyr_maxpower

	clr	a9
	CREATE0	ck_circle_stik
	CREATE0	ck_baby
	movk	1,a9
	CREATE0	ck_circle_stik
	CREATE0	ck_baby
	movk	2,a9
	CREATE0	ck_circle_stik
	CREATE0	ck_baby
	movk	3,a9
	CREATE0	ck_circle_stik
	CREATE0	ck_baby


;Totalize taps for various powerups!

#lp	SLEEPK	1
	clr	a0
	calla	get_but_val_down
	jrz	#n1
	move	@p1taps,a0
	addk	1,a0
	move	a0,@p1taps
#n1
	movk	1,a0
	calla	get_but_val_down
	jrz	#n2
	move	@p2taps,a0
	addk	1,a0
	move	a0,@p2taps
#n2
	movk	2,a0
	calla	get_but_val_down
	jrz	#n3
	move	@p3taps,a0
	addk	1,a0
	move	a0,@p3taps
#n3
	movk	3,a0
	calla	get_but_val_down
	jrz	#n4
	move	@p4taps,a0
	addk	1,a0
	move	a0,@p4taps
#n4

;Check for max power powerup!

	clr	a0
	calla	get_start_cur
	jrnz	#z1a
	clr	a0
	calla	get_but_val_cur
	cmpi	7,a0
	jrnz	#z1a
	clr	a0
	calla	get_stick_val_cur
	movk	1,a1
	cmpi	2,a0
	jrz	#yesz
#z1a
	movk	1,a0
	calla	get_start_cur
	jrz	#z2a
	movk	1,a0
	calla	get_but_val_cur
	cmpi	7,a0
	jrnz	#z2a
	movk	1,a0
	calla	get_stick_val_cur
	movk	2,a1
	cmpi	2,a0
	jrz	#yesz
#z2a
	movk	2,a0
	calla	get_start_cur
	jrz	#z3a
	movk	2,a0
	calla	get_but_val_cur
	cmpi	7,a0
	jrnz	#z3a
	movk	2,a0
	calla	get_stick_val_cur
	movk	4,a1
	cmpi	2,a0
	jrz	#yesz
#z3a
	movk	3,a0
	calla	get_start_cur
	jrz	#z4a
	movk	3,a0
	calla	get_but_val_cur
	cmpi	7,a0
	jrnz	#z4a
	movk	3,a0
	calla	get_stick_val_cur
	movk	8,a1
	cmpi	2,a0
	jrnz	#z4a
#yesz
	move	@plyr_maxpower,a0
	or	a1,a0
	move	a0,@plyr_maxpower
#z4a


;Check for tournament mode on powerup!
	clr	a0
	calla	get_but_val_cur
	cmpi	7,a0
	jrnz	#n1a
	clr	a0
	calla	get_stick_val_cur
	cmpi	8,a0
	jrz	#yest
#n1a
	movk	1,a0
	calla	get_but_val_cur
	cmpi	7,a0
	jrnz	#n2a
	movk	1,a0
	calla	get_stick_val_cur
	cmpi	8,a0
	jrz	#yest
#n2a
	movk	2,a0
	calla	get_but_val_cur
	cmpi	7,a0
	jrnz	#n3a
	movk	2,a0
	calla	get_stick_val_cur
	cmpi	8,a0
	jrz	#yest
#n3a
	movk	3,a0
	calla	get_but_val_cur
	cmpi	7,a0
	jrnz	#n4a
	movk	3,a0
	calla	get_stick_val_cur
	cmpi	8,a0
	jrnz	#n4a
#yest
	movk	1,a0
	move	a0,@plyr_tourn
	movi	-1,a0
	move	a0,@special_heads,L	;-1 = normal player head
	move	a0,@special_heads+32,L	;-1 = normal player head
#n4a

	.ref	inmatchup
	move	@inmatchup,a0
	jrnz	#lp
	DIE

 SUBR	doflshs

	SLEEP	10

#lpz	SLEEPK	1
	move	@HALT,a0
	jrnz	#lpz

	SLEEP	2*60-50

	CREATE0	secret_perc

	CREATE0	assist_off
	CREATE0	secret_1
	CREATE0	secret_2
	CREATE0	secret_3
	CREATE0	secret_power
	CREATE0	baby_message

	MOVI	[3,9],A8		;START AT COLOR 60, CYCLE 1 COLOR
	MOVI	SGMD8VIO,A9		;PAL NAME
	MOVI	COLTAB_RNBW,A10		;TABLE TO CYCLE WITH
	MOVK	4,A11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE
	clr	a9
	move	a0,a11

	move	@plyrbighead,a0
	btst	0,a0
	jrnz	#t1f
	move	@stlpower,a0
	btst	0,a0
	jrnz	#t1f
	move	@p1taps,a0
	cmpi	24,a0
	jrnz	#t1
#t1f
	move	@plyrobj_t,a8,L
	CREATE0	flshme
	movk	1,a9
#t1
	move	@plyrbighead,a0
	btst	1,a0
	jrnz	#t2f
	move	@stlpower,a0
	btst	1,a0
	jrnz	#t2f
	move	@p2taps,a0
	cmpi	8,a0
	jrnz	#t2
#t2f
	move	@plyrobj_t+32,a8,L
	CREATE0	flshme
	movk	1,a9
#t2
	move	@plyrbighead,a0
	btst	2,a0
	jrnz	#t3f
	move	@stlpower,a0
	btst	2,a0
	jrnz	#t3f
	move	@p3taps,a0
	cmpi	8,a0
	jrnz	#t3
#t3f
	move	@plyrobj_t+64,a8,L
	CREATE0	flshme
	movk	1,a9
#t3
	move	@plyrbighead,a0
	btst	3,a0
	jrnz	#t4f
	move	@stlpower,a0
	btst	3,a0
	jrnz	#t4f
	move	@p4taps,a0
	cmpi	8,a0
	jrnz	#t4
#t4f
	move	@plyrobj_t+96,a8,L
	CREATE0	flshme
	movk	1,a9
#t4
	move	a9,a9
	jrz	#xx

	.ref	snd_play1ovrp
	movi	win_snd,a0
	calla	snd_play1ovrp

#xx
	calla	pal_clean

	SLEEP	TSEC*7

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

	move	a11,a0
	calla	KILL

	calla	pal_clean

	DIE

win_snd		.word	>f3ff,>8,>80a5,0	;Winner snd/Suckup credits

flshme
;flash player white to alert him
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


 SUBR	tournament_on

;Check to see if any of the 4 players has turned on tournament mode!
	move	@plyr_tourn,a0
	jrnz	#se2a

	movk	ADJTOURNEY,a0		;Tournament mode?
	calla	GET_ADJ			;0-1
	jrz	#se2a			;On? Br=yes
	clrc
	rets

#se2a
	clr	a0
	move	a0,@p1taps
	move	a0,@p2taps
	move	a0,@p3taps
	move	a0,@p4taps
	move	a0,@stlpower
	setc				;Yes, tournament mode on!
	rets

#*******************************
* Show computer assistance off message

 SUBRP	assist_off

	clr	a0
	move	a0,@assistance_off

	callr	tournament_on
	jrc	#set2a

	movk	ADJCOMPASS,a0		;Computer assistance
	calla	GET_ADJ			;0-1
	jrnz	#set			;On? Br=yes

	move	@p1taps,a0
	cmpi	10,a0
	jrz	#set
	move	@p1taps+16,a0
	cmpi	10,a0
	jrz	#set
	move	@p1taps+32,a0
	cmpi	10,a0
	jrz	#set
	move	@p1taps+48,a0
	cmpi	10,a0
	jrz	#set

	DIE

#set2a
	movk	1,a0
	move	a0,@assistance_off
	movi	#ln0_setup,a2
	calla	setup_message

	movi	win_snd,a0
	calla	snd_play1ovrp

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	#str_secret2,a4
	calla	print_string_C2

	movi	#ln0_setup0,a2
	calla	setup_message
      
	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	#str_secret3,a4
	jruc	#setin2
#set0
	movk	1,a0
	move	a0,@assistance_off
	jruc	#setin
#set
	movk	1,a0
	move	a0,@assistance_off

;If not a 2 human competitive game, don't print message
	move	@PSTATUS,a0
	ANDK	03,a0
	jrz	#set2
	move	@PSTATUS,a0
	ANDK	0ch,a0
	jrz	#set2
;Yes, a competitive game.

#setin
	movi	#ln0_setup,a2
	calla	setup_message

	movi	win_snd,a0
	calla	snd_play1ovrp

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	#str_secret1,a4
#setin2
	calla	print_string_C2

	SLEEP	TSEC*4

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

#set2
	calla	pal_clean

	DIE


#ln0_setup
	RJR_STR	sgmd8_ascii,3,0,200,39+1+10,SGMD8VIO,0

#str_secret1
	.string	"ALL COMPUTER ASSISTANCE TURNED OFF!",0
	.even

#ln0_setup0
	RJR_STR	sgmd8_ascii,3,0,200,39+1+20,SGMD8VIO,0

#str_secret2
	.string	"TOURNAMENT MODE",0
	.even

#str_secret3
	.string	"NO CPU ASSISTANCE, POWERUPS, OR SECRETS ALLOWED!",0
	.even


#*******************************
* Show secret messages

 SUBRP	secret_perc

	.ref	COLTAB_RNBW,CYCLE_TABLE

	move	@show_shot,a0
	jaz	SUCIDE

	movi	win_snd,a0
	calla	snd_play1ovrp

	
	movi	#ln0_setup,a2
	calla	setup_message

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	#str_secret1,a4
	calla	print_string_C2

	SLEEP	TSEC*6

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

	calla	pal_clean

	DIE


#ln0_setup
	RJR_STR	sgmd8_ascii,3,0,200,39+1,SGMD8VIO,0

#str_secret1
	.string	"SHOT % DISPLAY ACTIVATED",0
	.even

#*******************************
* Show cpu substitution message

 SUBR	cpu_subs
	
	SLEEP	37

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
	RJR_STR	sgmd8_ascii,3,0,100,105,SGMD8WHT,0
#ln0_setupa
	RJR_STR	sgmd8_ascii,3,0,300,105,SGMD8WHT,0

#str_subs
	.string	"CPU SUBSTITUTIONS:",0

	.even

#*******************************
* Show secret messages for skill #3

 SUBRP	secret_1

	callr	tournament_on
	jac	SUCIDE

;	movk	ADJTOURNEY,a0		;Tournament mode?
;	calla	GET_ADJ			;0-1
;	jaz	SUCIDE			;Br=In tournament mode

	clr	a9
#lp
	move	a9,a1
	sll	4,a1
	addi	p1taps,a1
	move	*a1,a0
	cmpi	24,a0
	jrnz	#nxt

	movi	win_snd,a0
	calla	snd_play1ovrp

	move	a9,a0
	sll	5,a0
	addi	#msgs_t,a0
	move	*a0,a2,L

	calla	setup_message

	movi	CLSDEAD|124,a0
	move	a0,@mess_objid

    	movi	#ln1,a4
	calla	print_string_C2

#nxt	SLEEPK	1

	inc	a9
	cmpi	4,a9
	jrnz	#lp

	SLEEP	TSEC*4

	movi	CLSDEAD|124,a0
	calla	obj_del1c		;delete text

	DIE
	
	
#msgs_t	.long	#ln1_setup,#ln2_setup,#ln3_setup,#ln4_setup

#ln1_setup
	RJR_STR	sgmd8_ascii,3,0,50,238,SGMD8WHT,0
#ln2_setup
	RJR_STR	sgmd8_ascii,3,0,150,238,SGMD8WHT,0
#ln3_setup
	RJR_STR	sgmd8_ascii,3,0,250,238,SGMD8WHT,0
#ln4_setup
	RJR_STR	sgmd8_ascii,3,0,350,238,SGMD8WHT,0

#ln1
	.string	"POWERUP G.T.",0		;More goaltends allowed
	.even

#*******************************
* Show secret messages for skill #3

 SUBRP	secret_power

	callr	tournament_on
	jac	SUCIDE

	move	@strongmen,a0
	jrz	#notst
;Grand champ playing - make drones have max power
	movk	3,a3
	cmpi	2,a0
	jrz	#tag1
	movk	>c,a3
#tag1	move	@plyr_maxpower,a0
	or	a3,a0
	move	a0,@plyr_maxpower
#notst
	clr	a9
#lp
	move	@plyr_maxpower,a0
	btst	a9,a0
	jrz	#nxt

	movi	win_snd,a0
	calla	snd_play1ovrp

	move	a9,a0
	sll	5,a0
	addi	#msgs_t,a0
	move	*a0,a2,L

	calla	setup_message

	movi	CLSDEAD|124,a0
	move	a0,@mess_objid

    	movi	#ln1,a4
	calla	print_string_C2

#nxt	SLEEPK	1

	inc	a9
	cmpi	4,a9
	jrnz	#lp

	SLEEP	TSEC*4

	movi	CLSDEAD|124,a0
	calla	obj_del1c		;delete text

	DIE
	
	
#msgs_t	.long	#ln1_setup,#ln2_setup,#ln3_setup,#ln4_setup

#ln1_setup
	RJR_STR	sgmd8_ascii,3,0,50,210,SGMD8WHT,0
#ln2_setup
	RJR_STR	sgmd8_ascii,3,0,150,210,SGMD8WHT,0
#ln3_setup
	RJR_STR	sgmd8_ascii,3,0,250,210,SGMD8WHT,0
#ln4_setup
	RJR_STR	sgmd8_ascii,3,0,350,210,SGMD8WHT,0

#ln1
	.string	"MAX POWER",0		;Can't be knocked down
	.even

#*******************************
* Show secret messages

 SUBRP	secret_2

	clr	a9
#lp
	.ref	plyrbighead

	move	@plyrbighead,a0
	btst	a9,a0
	jrz	#nxt

	movi	win_snd,a0
	calla	snd_play1ovrp

	move	a9,a0
	sll	5,a0
	addi	#msgs_t,a0
	move	*a0,a2,L

	calla	setup_message

	movi	CLSDEAD|125,a0
	move	a0,@mess_objid

    	movi	#ln1,a4






	move	a9,a1
	sll	4,a1
	addi	p1taps,a1
	move	*a1,a0
	cmpi	6,a0
	jrnz	#no
    	movi	#ln1a,a4
#no








	calla	print_string_C2

#nxt	SLEEPK	1

	inc	a9
	cmpi	4,a9
	jrnz	#lp

	SLEEP	TSEC*4

	movi	CLSDEAD|125,a0
	calla	obj_del1c		;delete text

	DIE

#msgs_t	.long	#ln1_setup,#ln2_setup,#ln3_setup,#ln4_setup

#ln1_setup
	RJR_STR	sgmd8_ascii,3,0,50,196,SGMD8WHT,0
#ln2_setup
	RJR_STR	sgmd8_ascii,3,0,150,196,SGMD8WHT,0
#ln3_setup
	RJR_STR	sgmd8_ascii,3,0,250,196,SGMD8WHT,0
#ln4_setup
	RJR_STR	sgmd8_ascii,3,0,350,196,SGMD8WHT,0

#ln1
	.string	"BIG HEAD #1",0
#ln1a
	.string	"HUGE HEAD",0
	.even

#*******************************
* Show secret messages

 SUBRP	secret_3

	callr	tournament_on
	jac	SUCIDE

	move	@strongmen,a0
	jrz	#notst
;Grand champ playing - make drones have max power
	movk	3,a3
	cmpi	2,a0
	jrz	#tag1
	movk	>c,a3
#tag1	move	@stlpower,a0
	or	a3,a0
	move	a0,@stlpower
#notst


	clr	a9
#lp
	.ref	stlpower

	move	@stlpower,a0
	btst	a9,a0
	jrz	#nxt

	movi	win_snd,a0
	calla	snd_play1ovrp

	move	a9,a0
	sll	5,a0
	addi	#msgs_t,a0
	move	*a0,a2,L

	calla	setup_message

	movi	CLSDEAD|125,a0
	move	a0,@mess_objid

    	movi	#ln1,a4
	calla	print_string_C2

#nxt	SLEEPK	1

	inc	a9
	cmpi	4,a9
	jrnz	#lp

	SLEEP	TSEC*4

	movi	CLSDEAD|125,a0
	calla	obj_del1c		;delete text

	DIE
	
#msgs_t	.long	#ln1_setup,#ln2_setup,#ln3_setup,#ln4_setup

#ln1_setup
	RJR_STR	sgmd8_ascii,3,0,50,224,SGMD8WHT,0
#ln2_setup
	RJR_STR	sgmd8_ascii,3,0,150,224,SGMD8WHT,0
#ln3_setup
	RJR_STR	sgmd8_ascii,3,0,250,224,SGMD8WHT,0
#ln4_setup
	RJR_STR	sgmd8_ascii,3,0,350,224,SGMD8WHT,0

#ln1
	.string	"QUICK HANDS",0			;More intercepts
	.even


#*******************************
* Show secret messages for skill #3

 SUBRP	baby_message

	callr	tournament_on
	jac	SUCIDE

	move	@baby_flag,a0
	jaz	SUCIDE

	movi	win_snd,a0
	calla	snd_play1ovrp

	movi	#ln0_setup,a2
	calla	setup_message

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	#str_secret1,a4
	calla	print_string_C2

	SLEEP	TSEC*6

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

	calla	pal_clean
	DIE


#ln0_setup
	RJR_STR	sgmd8_ascii,3,0,200,39+1-10,SGMD8VIO,0

#str_secret1
	.string	"BABY SIZE PLAYERS",0
	.even

#*******************************
* Look at the buttons, read a sequence table,
* and set baby_flag if sequence successful
* a9=0-3

ck_baby

	clr	a10
	movi	butn_lst,a8

#lp	SLEEPK	1
	move	a9,a0
	calla	get_stick_val_cur
	cmpi	>a,a0			;down/right
	jrnz	#lp
	move	a9,a0
	calla	get_but_val_cur
;	move	@SWITCH,a0
;	zext	a0
;	cmpi	>ffff,a0
	jrnz	#tag1
	clr	a11
	jruc	#lp

#tag1	move	a11,a11
	jrnz	#lp

	inc	a11

	move	*a8,a1,W
	zext	a1
	cmp	a0,a1
	jrz	#yes
	movi	butn_lst,a8
	jruc	#lp
#yes	addk	16,a8
	move	*a8,a0
	jrnz	#lp
	movk	1,a0
	move	a0,@baby_flag

	DIE

butn_lst

;Buttons required for 2nd octopus:
;p1turbo,p1turbo,p2shoot,p2shoot,p2shoot,p2pass,p2pass,p1shoot,p1pass,p2turbo
;p2turbo

	.word	4,1,2,4,1,2,4,1,2,0

	.end

