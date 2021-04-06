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
*.Last mod - 3/19/93 13:10
**************************************************************
	.file	"score2.asm"
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
	.asg		0,SEQT
	.include	"plyr.equ"


;sounds

infoex_snd	.word	>f3ff,>8,>8097,0	;Info box exit
warn2_snd	.word	>fbf7,19,>80a3,0	;Warning for info box

;symbols externally defined

	.ref	IRQSKYE
	.ref	guyhds
	.ref	SOUNDSUP
	.ref	get_all_buttons_cur2
	.ref	TWOPLAYERS
;	.ref	player_toggle1		;0 = no toggle
;	.ref	player_toggle2		;0 = no toggle
	.ref	pal_set,amode_start,GAMSTATE,P1DATA
	.ref	KILBGND
	.ref	pal_clean
	.ref	WIPEOUT
	.ref	WNDWON
	.ref	WFLG
 	.ref	get_but_val_cur,PSTATUS,cntrs_delay,HALT,GET_ADJ
	.ref	names,pal_getf,team1,team2
	.ref	arrow1r,arrow2r,arrow3r,arrow4r
	.ref	arrow1r2p,arrow2r2p
	.ref	AUD,AUD1,scores,PSTATUS2
	.ref	UNIT_CLR,get_all_buttons_down
	.ref	player1_data,player2_data,inbound
	.ref	player3_data,player4_data

;symbols defined in this file

	.def	player_data

;uninitialized ram definitions

	BSSX	idiot_bits,16
	.bss	fontram,30*32		;font imgs for red/white flashing

;equates first originated in this file
CONT_MAX	equ	10

	.text

#*****************************************************************************
*
* Increment dropout count & add in score differential

 SUBR	dropout_stats

	movi	AUD_NUMDROPOUT,a0
	calla	AUD1

	move	@scores,a1
	move	@scores+10h,a0
	sub	a0,a1
	abs	a1
	movi	AUD_DROPDIFF,a0
	calla	AUD

	move	@PSTATUS2,a0
	andi	011b,a0
	jrz	#t1_cpu
	move	@PSTATUS2,a0
	andi	01100b,a0
	jrz	#t2_cpu

	movi	AUD_DROPVSHUM,a0
	calla	AUD1
	rets

#t1_cpu
#t2_cpu
	movi	AUD_DROPVSCPU,a0
	calla	AUD1
	rets

#************************************
* Instructions
* 

 SUBR	instructions
	clr	a11
	move	@PSTATUS,a0
	btst	0,a0
	jrz	#nx1
	CREATE	1123,print_inst
#nx1
	movk	1,a11
  
	move	@PSTATUS,a0
	btst	1,a0
	jrz	#nx2
	CREATE	1123,print_inst
#nx2
	movk	2,a11
	move	@PSTATUS,a0
	btst	2,a0
	jrz	#nx3
	CREATE	1123,print_inst
#nx3
	movk	3,a11
	move	@PSTATUS,a0
	btst	3,a0
	jrz	#nx4
	CREATE	1123,print_inst
#nx4	SLEEPK	1
	movi	1123,a0
	clr	a1
	not	a1
	calla	EXISTP
	jrnz	#nx4
	RETP


* A11=Plyr # (0-3)

 SUBR	print_inst

	SLEEPK	1

;Check player experience first!

	move	a11,a14
	sll	5,a14
	addi	player_data,a14
	move	*a14,a14,L
	move	*a14(PR_COUNT),a7
	jrn	#no_inits
	subk	5,a7
	jage	SUCIDE

#no_inits

	move	a11,*a13(PDATA+288)

	CREATE0	do_warns

	move	a11,a0
	movi	35*60,a0
	move	a0,@cntrs_delay

	sll	5,a11
	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	firstwin,a2
	movi	19990,a3			;z pos
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA),L

	movi	pal_t,a0

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not2x
	addi	4*32,a0
#not2x


	add	a11,a0
	move	*a0,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)

	CREATE0	flsh_box

;Blink this img red/wht

	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	ply_t,a2
  



	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not2
	movi	ply2_t,a2
#not2




	add	a11,a2
	move	*a2,a2,L			;Player #x
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+32),L

	CREATE0	blink_plyr
	move	a0,*a13(PDATA+192),L

;Turn on msgs
	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[2,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	joycontrol,a2
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+64),L

;Turn on msgs
	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[1,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	colormessage,a2
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+96),L

;Turn on msgs
	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[1,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	colors_t,a2

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not2x2
	addi	4*32,a2
#not2x2



	add	a11,a2
	move	*a2,a2,L
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+128),L

;Turn on arws
	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[4fh,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	addi	[0ch,0],a0
	movi	arws_t,a2




	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not2c
	movi	arws2_t,a2
#not2c






	add	a11,a2
	move	*a2,a2,L
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+160),L

;Turn on head
	.ref	getwindowhead

;	movi	team1,a1
	cmpi	64,a11
	jrlt	#tag0
	movk	2,a8
	calla	getwindowhead
	PUSHP	a0
;	movi	team2,a1
	movk	3,a8
	calla	getwindowhead
	move	a0,a1
	PULLP	a0
	jruc	#tagout
#tag0
; 	calla	getwindowhead
	clr	a8
	calla	getwindowhead
	PUSHP	a0
	movk	1,a8
	calla	getwindowhead
	move	a0,a1
	PULLP	a0
#tagout

;a0=plyr 1 head img
;a1=plyr 2 head img

	move	a0,a2
	cmpi	0,a11
	jrz	#tag1
	cmpi	64,a11
	jrz	#tag1
	move	a1,a2

#tag1
	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[61h,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	addi	[4ch,0],a0
	movi	19990,a3			;z pos
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+224),L

	movi	names,a0
	add	a11,a0
	move	*a0,a2,L

	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[23h,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	addi	[32h,0],a0
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+256),L


	SLEEPK	12

;Make sure the proper player presses his button

	movi	10*60,a8
#whopper_with_cheese
	SLEEPK	1

	move	*a13(PDATA+288),a0
	calla	get_but_val_cur

	move	a0,a0
	jrnz	#exit
	dsj	a8,#whopper_with_cheese

#exit	move	*a13(PDATA+192),a0,L
	calla	KILL

	movi	infoex_snd,a0
	calla	snd_play1

	move	*a13(PDATA+32),a0,L
	calla	DELOBJ
	move	*a13(PDATA+64),a0,L
	calla	DELOBJ
	move	*a13(PDATA+96),a0,L
	calla	DELOBJ
	move	*a13(PDATA+128),a0,L
	calla	DELOBJ
	move	*a13(PDATA+160),a0,L
	calla	DELOBJ
	move	*a13(PDATA+224),a0,L
	calla	DELOBJ
	move	*a13(PDATA+256),a0,L
	calla	DELOBJ

;Show second page of instructions

	move	@PSTATUS,a0
	move	*a13(PDATA+288),a1
	XORK	1,a1
	btst	a1,a0
	jrnz	#no_drone


	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[4,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	dronetxt,a2
	movi	19990,a3			;z pos
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+32),L

	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	ply_t,a2






	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not2a
	movi	ply2_t,a2
#not2a




	add	a11,a2
	move	*a2,a2,L			;Player #x
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+64),L

	CREATE0	blink_plyr
	move	a0,*a13(PDATA+192),L

	SLEEP	12

;Make sure the proper player presses his button

	movi	11*60,a9
#whopper_with_cheese1
	SLEEPK	1
	move	*a13(PDATA+288),a0
	calla	get_but_val_cur
	move	a0,a0
	jrnz	#exit1
	dsj	a9,#whopper_with_cheese1

#exit1
	move	*a13(PDATA+192),a0,L
	calla	KILL

	movi	infoex_snd,a0
	calla	snd_play1

	move	*a13(PDATA+32),a0,L
	calla	DELOBJ
	move	*a13(PDATA+64),a0,L
	calla	DELOBJ

#no_drone

;3rd page of instructions
	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[1,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	message4,a2
	movi	19990,a3			;z pos
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+32),L

	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[1,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	message7,a2
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+64),L


	SLEEP	12

;Make sure the proper player presses his button

	movi	11*60,a9
#whopper_with_cheese2
	SLEEPK	1
	move	*a13(PDATA+288),a0
	calla	get_but_val_cur
	move	a0,a0
	jrnz	#exit2
	dsj	a9,#whopper_with_cheese2
#exit2

	movi	infoex_snd,a0
	calla	snd_play1

	move	*a13(PDATA+32),a0,L
	calla	DELOBJ
	move	*a13(PDATA+64),a0,L
	calla	DELOBJ


;4th page of instructions
	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[2,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	message9,a2
	movi	19990,a3			;z pos
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+32),L

	movi	#boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	addi	[2,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	message2,a2
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+64),L


	SLEEP	12

;Make sure the proper player presses his button

	movi	10*60,a9
#whopper_with_cheese3
	SLEEPK	1
	move	*a13(PDATA+288),a0
	calla	get_but_val_cur
	move	a0,a0
	jrnz	#exit3
	dsj	a9,#whopper_with_cheese3

#exit3

	movi	infoex_snd,a0
	calla	snd_play1

	movi	30,a9
	movk	8,a10

#lft	SLEEPK	1
;Send box off to lft
	move	*a13(PDATA),a0,L
	move	*a0(OYPOS),a1
	add	a10,a1
	move	a1,*a0(OYPOS)
	move	*a13(PDATA+32),a0,L
	move	*a0(OYPOS),a1
	add	a10,a1
	move	a1,*a0(OYPOS)
	move	*a13(PDATA+64),a0,L
	move	*a0(OYPOS),a1
	add	a10,a1
	move	a1,*a0(OYPOS)

	dsj	a9,#lft


	move	*a13(PDATA),a0,L
	calla	DELOBJ
	move	*a13(PDATA+32),a0,L
	calla	DELOBJ
	move	*a13(PDATA+64),a0,L
	calla	DELOBJ


;	clr	a0
;	move	a0,@HALT
;	move	a0,@cntrs_delay

	DIE


colors_t
;	.long	red,yellow,green,blue
	.long	blue,green,yellow,red
;For kit
	.long	blue,blue,red,red
arws_t
	.long	arrow1r,arrow2r,arrow3r,arrow4r
arws2_t
	.long	arrow1r2p,arrow1r2p,arrow2r2p,arrow2r2p

#boxy_t	.long	[48-8,0],[48+70+8,0],[48-8,0],[48+70+8,0]
#boxx_t	.long	[7,0],[64h,0],[0c3h,0],[120h,0]
ply_t	.long	plyr1,plyr2,plyr3,plyr4
ply2_t	.long	plyr1,plyr1,plyr2,plyr2
;pal_t	.long	GROWBOXr,GROWBOXy,GROWBOXg,GROWBOXb

pal_t	.long	GROWBOXb,GROWBOXg,GROWBOXy,GROWBOXr
;For kit
	.long	GROWBOXb,GROWBOXb,GROWBOXr,GROWBOXr

#***************************************************************
* Shake screen as as if an earthquake is in effect
* A10 = # ticks to shake and power of shake
* Note: time to shake must be more than 6 ticks

	.BSS	AMP,16
	.BSS	AMPCNT,16
	.BSS	XSET,16
	.BSS	YSET,16
	.BSS	SHK_ON,16

	.ref	RNDRNG0

 SUBR	SHAKER

	move	@SHK_ON,a0
	jrnz	#x
	move	a10,a11
	movk	6,a0
	move	a0,@SHK_ON
	divs	a0,a11
	move	a0,@AMP
	move	a11,@AMPCNT
	
	CREATE0	shakelp
#x	RETS
	
shakelp
	move	@AMP,a0
	calla	RNDRNG0
	move	a0,@XSET
	move	@AMP,a0
	calla	RNDRNG0
	move	a0,@YSET
	move	@HCOUNT,a14
	btst	0,a14
	jrz	#shakey

	move	@XSET,a1
	move	@WORLDTLX,a0,L
	sll	16,a1
	add	a1,a0
	move	a0,@WORLDTLX,L
	SLEEPK	1
	move	@XSET,a1
	move	@WORLDTLX,a0,L
	sll	16,a1
	sub	a1,a0
	move	a0,@WORLDTLX,L
	jruc	shakelp

#shakey
	move	@YSET,a1
	move	@WORLDTLY,a0,L
	sll	16,a1
	add	a1,a0
	move	a0,@WORLDTLY,L
	SLEEPK	1
	move	@YSET,a1
	move	@WORLDTLY,a0,L
	sll	16,a1
	sub	a1,a0
	move	a0,@WORLDTLY,L
	move	@AMPCNT,a2
	dec	a2
	move	a2,@AMPCNT
	jrnz	#ampok
	move	a11,@AMPCNT
	move	@AMP,a0
	cmpi	1,a0
	jrz	#ampok
	dec	a0
	move	a0,@AMP
#ampok
	dsj	a10,shakelp
	move	a10,@SHK_ON

	DIE

 SUBR	do_warns
	movi	warn2_snd,a0
	calla	snd_play1
	SLEEPK	20
	movi	warn2_snd,a0
	calla	snd_play1
	SLEEPK	20
	movi	warn2_snd,a0
	calla	snd_play1
	SLEEPK	20
	movi	warn2_snd,a0
	calla	snd_play1
	SLEEPK	20
	movi	warn2_snd,a0
	calla	snd_play1
	SLEEPK	20
	movi	warn2_snd,a0
	calla	snd_play1
	SLEEPK	20
	movi	warn2_snd,a0
	calla	snd_play1
	DIE

#************************************
* Create idiot box process to give the player a message
* A0=Message #
* A1=Plyr # (0-3)

 SUBR	idiot_box

;When testing dunks - PUT IN!
;	rets

	PUSH	a7,a10,a11

	.ref	game_time
	move	@game_time,a14,L
	cmpi	>900,a14
	jrlt	#x

	move	a1,a14
	sll	5,a14
	addi	player_data,a14
	move	*a14,a14,L
	move	*a14(PR_COUNT),a7
	jrn	#no_inits
	move	a0,a0
	jrz	#no_inits
	subk	5,a7
	jrge	#x

#no_inits
	move	@PSTATUS,a14
	btst	a1,a14

	jrnz	#notdrn			;Drone?
	move	a0,a0
	jrnz	#x			;Out of credit message?

#notdrn
	move	a0,a10
	move	a1,a11
	CREATE0	idiot_box2

#x	PULL	a7,a10,a11
	rets

player_data
	.long	player1_data,player2_data
	.long	player3_data,player4_data

#************************************
* Idiot box (process)
* A10=Message #
* A11=Plyr # (0-3)

 SUBRP	idiot_box2

;Check player experience first!

#slp	SLEEPK	1

	move	@idiot_bits,a0
	btst	a11,a0
	jrnz	#slp
	move	@inbound,a0
	jann	SUCIDE			;#slp

	move	a11,a0
	sll	4,a0
	addi	bit_t,a0
	move	*a0,a0
	move	@idiot_bits,a1
	or	a0,a1
	move	a0,@idiot_bits

	movi	5*60,a0
	move	a0,@HALT
	move	a0,@cntrs_delay

	sll	5,a11
	movi	boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	movi	boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	infobox,a2
	movi	19990,a3			;z pos
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA),L

	movi	pal_t,a0

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not2xx
	addi	4*32,a0
#not2xx

	add	a11,a0
	move	*a0,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)


	CREATE0	flsh_box

;Blink this img red/wht

	movi	boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	movi	boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	movi	ply_t,a2





	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not2b
	movi	ply2_t,a2
#not2b




	add	a11,a2
	move	*a2,a2,L			;Player #x
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+32),L

	CREATE0	blink_plyr

	movi	msg_t,a2
	sll	5,a10
	add	a10,a2
	move	*a2,a2,L

	move	a0,a10				;Keep blink proc

	movi	boxy_t,a0
	add	a11,a0
	move	*a0,a1,L
	movi	boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+64),L

	SLEEP	TSEC*1

	movi	4*60,a8
#whopper_with_cheese
	SLEEPK	1
	calla	get_all_buttons_down
	move	a0,a0
	jrnz	#exit
	dsj	a8,#whopper_with_cheese

#exit	move	a10,a0
	calla	KILL

	movi	infoex_snd,a0
	calla	snd_play1

	movi	30,a9
	movi	-8,a10
	cmpi	64,a11
	jrlt	#lft
;Send box off to right	
	movk	8,a10
#lft	SLEEPK	1
;Send box off to lft
	move	*a13(PDATA),a0,L
	move	*a0(OXPOS),a1
	add	a10,a1
	move	a1,*a0(OXPOS)
	move	*a13(PDATA+32),a0,L
	move	*a0(OXPOS),a1
	add	a10,a1
	move	a1,*a0(OXPOS)
	move	*a13(PDATA+64),a0,L
	move	*a0(OXPOS),a1
	add	a10,a1
	move	a1,*a0(OXPOS)
	dsj	a9,#lft

	move	*a13(PDATA),a0,L
	calla	DELOBJ
	move	*a13(PDATA+32),a0,L
	calla	DELOBJ
	move	*a13(PDATA+64),a0,L
	calla	DELOBJ


	addi	bit_and,a11
	move	*a11,a0,L
	move	@idiot_bits,a1
	and	a0,a1
	move	a1,@idiot_bits

	move	a1,a1
	janz	SUCIDE

	move	@PSTATUS,a0
	jaz	SUCIDE

	clr	a0
	move	a0,@HALT
	move	a0,@cntrs_delay

	DIE


 SUBR	blink_plyr	
	SLEEPK	15
 SUBR	blink_plyr2
	SLEEPK	5

blink_plyr1
	movi	SGMD8RED,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
	SLEEPK	4
	movi	SGMD8WHT,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
	SLEEPK	7
	jruc	blink_plyr1


 SUBR 	flsh_box

	SLEEPK	2

	movi	>1616,a2
	move	a2,*a8(OCONST)

	movk	3,a10
#again
	callr	const_on

	SLEEPK	3

	callr	const_off

	SLEEPK	3

	dsj	a10,#again
	DIE


bit_t	.word	1,2,4,8
bit_and	.long	>e,>d,>b,>7
boxy_t	.long	[48,0],[48+70,0],[48,0],[48+70,0]
boxx_t	.long	[7,0],[47h+6,0],[0dah+6,0],[127h-23,0]
msg_t	.long	message1,message2,message3,message4,message5,message6
	.long	message7,message2a
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

#*****************************************************************************

	.ref	CR_CONTP
	.ref	BTIME
	.ref	setup_message,print_string_C2
	.ref	copy_string,print_string_C
	.ref	dec_to_asc
	.ref	osgemd_ascii,sgmd8_ascii,osgmd8_ascii
	.ref	lgmd_ascii,omlgmd_ascii,ogmd10_ascii
	.ref	mess_cursy
	.ref	mess_objid

 SUBR	update_cont_message

	movi	CLSNEUT|TYPTEXT|SUBMES1,A0
	calla	obj_del1c

	movi	LN0_setup,a2
	calla	setup_message

	calla	CR_CONTP		;ENOUGH TO CONTINUE?
	jrlo	#need_credits		;BR = NO
	movi	#str_press,a8
	jruc	#cont
#need_credits
	MOVI	#str_insert,A8
#cont
	MOVI	CLSNEUT|TYPTEXT|SUBMES1,A0
	move	a0,@mess_objid		;OBJ ID's for text
	move	a8,a4
	calla	print_string_C2

	movi	LN1_setup,a2
	calla	setup_message
	MOVI	CLSNEUT|TYPTEXT|SUBMES1,A0
	move	a0,@mess_objid		;OBJ ID's for text
	movi	#str_tocont,a4
	calla	print_string_C2

	movi	LN2_setup,a2
	calla	setup_message
	MOVI	CLSNEUT|TYPTEXT|SUBMES1,A0
	move	a0,@mess_objid		;OBJ ID's for text
	move	@BTIME,a0
	movi	CONT_MAX,a1		;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_C

	rets

LN0_setup
	RJR_STR	osgemd_ascii,6,0,200,132-20-12-26,GOLD,0
LN1_setup
	RJR_STR	osgemd_ascii,6,0,200,132-20-12,GOLD,0
LN2_setup
	RJR_STR	osgemd_ascii,6,0,200,132-20-12+26,GREENPAL,0
#str_insert
	.string	"INSERT COINS",0
#str_press		     
	.string	"PRESS START",0
#str_tocont
	.string	"TO CONTINUE",0
	.even


 SUBR	flash_bigtxt
  
	movi	OBJLST,a14
	movi	fontram,a3
	clr	a4
	move	a4,*a3,L
	
#lp
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a2
	cmpi	CLSDEAD|123,a2
	jrne	#lp
	move	a14,*a3+,L
	move	a4,*a3,L
	jruc	#lp
	
#x	
	movi	LGMDWHT,a0		;slv
	calla	pal_getf
	movi	fontram,a3
	
#lp2
	move	*a3+,a1,L
	jrz	#xx
	move	a0,*a1(OPAL)
	jruc	#lp2

#xx	SLEEPK	3

	movi	LGMDRED2,a0
	calla	pal_getf
	movi	fontram,a3
	
#lp3
	move	*a3+,a1,L
	jrz	#xxx
	move	a0,*a1(OPAL)
	jruc	#lp3

#xxx	SLEEPK	5
	jruc	#x
#*
 SUBR	flash_bigtxt2
  
	movi	OBJLST,a14
	movi	fontram,a3
	clr	a4
	move	a4,*a3,L
	
#lp
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a2
	cmpi	CLSDEAD|123,a2
	jrne	#lp
	move	a14,*a3+,L
	move	a4,*a3,L
	jruc	#lp
	
#x	
;	movi	WHITE2PAL,a0		;slv
	movi	LGMDWHT,a0		;slv
	calla	pal_getf
	movi	fontram,a3
	
#lp2
	move	*a3+,a1,L
	jrz	#xx
	move	a0,*a1(OPAL)
	jruc	#lp2

#xx	SLEEPK	3

;	movi	PURPLE,a0
	movi	LGMDPURP,a0
	calla	pal_getf
	movi	fontram,a3
	
#lp3
	move	*a3+,a1,L
	jrz	#xxx
	move	a0,*a1(OPAL)
	jruc	#lp3

#xxx	SLEEPK	5
	jruc	#x



#*************************************************************************
* Game over process

 SUBR	game_over

	movi	AUDBONE,a0		;DEC CMOS CNT OF GAMES STARTED
	movi	-1,a1
	calla	AUD
	

	movk	INGAMEOV,a0
	move	a0,@GAMSTATE
	clr	a0
	movi	P1DATA,a14

	move	a0,@PSTATUS
	move	a0,@PSTATUS2


	movi	LN1b_setup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	move	a0,@mess_objid		;OBJ ID's for text
	movi	#str_game,a4
	calla	print_string_C2

	movi	LN2b_setup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	move	a0,@mess_objid		;OBJ ID's for text
	movi	#str_over,a4
	calla	print_string_C2


	movi	OBJLST,a10
	jruc	#start
#next_obj
	move	*a10(OID),a0
	cmpi	CLSNEUT|TYPTEXT|SUBMES1,a0
	jrne	#not_gover
	movi	30002,a0
	move	a0,*a10(OZPOS)		;higher priority than black window
#not_gover
#start
	move	*a10,a10,L
	jrnz	#next_obj

	movk	1,a0
	move	a0,@HALT

;	SLEEP	40

 	movi	CYCPID2,a0
	calla	KIL1C
 	movi	CYCPID,a0
	calla	KIL1C

	SLEEP	3			;3

	movi	#pal_t,a10
	movi	32,a11
	CREATE0	fade_down

;	JSRP	WNDWON

	SLEEP	TSEC*3

	clr	a0
	move	a0,@DISPLAYON		;Turn the display off

	calla	UNIT_CLR		;CLEAR THE FACTIONS OF FRACTIONS


;	movi	40,a10
;#lp	SLEEPK	1
;	move	@WORLDTLY+16,a0
;	addk	5,a0
;	move	a0,@WORLDTLY+16
;	dsjs	a10,#lp

;	clr	a10
;	movk	16,a11
	.ref	fade_down
;	CREATE0	fade_down
;
;	SLEEP	40

	calla	WIPEOUT

	SLEEPK	1

	movk	1,a0
	move	a0,@DISPLAYON		;Turn the display back on
	clr	a0
	move	a0,@WFLG

	jauc	amode_start		;Start attract mode


#pal_t	.long	LGMDBLU,0

LN1b_setup
;	RJR_STR	omlgmd_ascii,6,0,200,128-10-61,LGMDBLU,0
	RJR_STR	lgmd_ascii,6,0,200,128-10-61,LGMDBLU,0
LN2b_setup
	RJR_STR	lgmd_ascii,6,0,200,128,LGMDBLU,0
;	RJR_STR	omlgmd_ascii,12,2,200,120-44/2,LGMDRED2,0
#str_game
	.byte	"GAME",0
#str_over
	.byte	"OVER",0
	.even

#******************************************************************
* Note: Scratch = A0-A1,A14,B0-B1

 SUBR	update_shoes

	.if	IMGVIEW
	rets				;Debug - no credit cntdwn
	.endif

	PUSH	a11

	move	*a13(PDATA+32),a0,L

	move	*a0(plyr_keeppal),a14
	jrnz	#x			;Br=flames on body mode

	move	*a0(PA11),a11,L
	move	*a11,a6			;A6=Ctrl bits

	movi	wht_shoes,a11		;pal data
;	move	*a0(plyr_num),a1
;	btst	0,a1
;	jrz	#noblk
;	movi	blk_shoes,a11		;pal data
;#noblk

	btst	6,a6			;Turbo but
	jrz	#noturb
	move	*a0(plyr_PDATA_p),a1,L
	move	*a1(ply_turbo),a1
	jrz	#noturb			;No turbo left?

	move	*a13(PDATA+128),a14
	srl	6,a14
	move	@PSTATUS,a6
	btst	a14,a6
	jrz	#noturb

;	movi	red_shoes,a11		;pal data
	move	*a0(plyr_num),a1
	sll	5,a1
	addi	shoec_t,a1


	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not_2p1
	addi	4*32,a1
#not_2p1



	move	*a1,a11,L

;	move	*a0(plyr_num),a1
;	btst	0,a1
;	jrz	#noblk2
;	movi	grn_shoes,a11		;pal data
;#noblk2

#noturb
	move	@GAMSTATE,a6
	cmpi	INAMODE,a6
	jrz	#x
	move	*a13(PDATA+64),A6,L
	cmp	a11,a6
	jrz	#x
  	move	a11,*a13(PDATA+64),L
	

	move	*a0(PA8),a0,L
	move	*a0(OPAL),a0,W




;	move	*a0(plyr_attrib_p),a7,L
;	move	*a7(PAT_PALT_p),a0,L
;;FIX!!!
;	calla	pal_find		;Put in PDATA??!!!!


	andi	0ff00h,a0

	move	a0,a1			;dest pal
	ori	249,a1
	move	a11,a0



	movk	5,a2			;5 colors
	calla	pal_set
#x	PULL	a11
	rets

;shoec_t	.long	#red,#yel,#grn,#blu
;MJT

shoec_t	.long	#blu,#grn,#yel,#red
;For kit
	.long	#blu,#blu,#red,#red

#red
	COLORW	31,0,0
	COLORW	26,0,0
	COLORW	20,0,0
	COLORW	15,0,0
	COLORW	10,0,0
#grn
	COLORW	0,(31-7),0
	COLORW	0,(27-7),0
	COLORW	0,(22-7),0
	COLORW	0,(18-7),0
	COLORW	0,(14-7),0
#blu
	COLORW	0,10,31
	COLORW	0,8,27
	COLORW	0,6,22
	COLORW	0,4,18
	COLORW	0,0,14
#yel
	COLORW	31,31,0
	COLORW	27,27,0
	COLORW	22,22,0
	COLORW	18,18,0
	COLORW	14,14,0

wht_shoes
	COLORW	31,31,31
	COLORW	27,27,27
	COLORW	22,22,22
	COLORW	18,18,18
	COLORW	14,14,14

;	.endif

	.if 0

 SUBR	drwnbalogo

	SLEEP	3*60
	movi	[3,0],a10
	movi	[-300,0],a11
#drw
	movi	nbalogo,a9
	CREATE0	logo_drift
	SLEEP	120
	movi	stay,a9
	CREATE0	logo_drift
	SLEEP	120
	movi	nbalogo,a9
	CREATE0	logo_drift
	SLEEP	14*60
	movi	[-3,0],a10
	movi	[520,0],a11
	jruc	#drw


logo_drift

	move	a11,a0
	movi	[40,0],a1
	movi	>7591,a3				;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	move	a9,a2
	movi	CLSDEAD,a5
	move	a10,a6
	clr	a7
	calla	BEGINOBJ2

	SLEEP	700/3+120

	jauc	DELOBJDIE

 SUBR	drw_cards
;Turn on backboard and hoop base
	movi	[200,0],a0
	movi	[20,0],a1
	movi	bkbd1,a2
	movi	>7591,a3				;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
;
	movi	[200,0],a0
	movi	[20,0],a1
	movi	bkbd2,a2
	movi	>7591,a3				;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
;
	movi	[200,0],a0
	movi	[20,0],a1
	movi	bkbd3,a2
	movi	>7591,a3				;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

;Turn on a top card
	movi	player_t,a10
	
	movk	26,a9
	movi	[-100,0],a0
	movi	[20,0],a1
	movi	card_g,a2
	movi	>7591,a3				;Z
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	movi	[1,0],a6
	clr	a7
	calla	BEGINOBJ2

	SLEEP	700/3+120

	jauc	DELOBJDIE

px	.equ	-100
py	.equ	20
boxx	.equ	-100
boxy	.equ	20

player_t
	.long	card_g
	.word	boxx,boxy
	.long	r_hbar
	.word	boxx,boxy
	.long	r_vbar
	.word	boxx,boxy
	.long	AUG_ATL
	.word	px,py	
	.long	augmon_90
	.word	boxx+80,boxy+30

	.long	0

;---> card_g,card_v,l_hbar,l_vbar,r_hbar,r_vbar,lohaus_90,iuzzo_90,mchale_90
;---> laim_90,edwards_90,gugli_90,augmon_90,barkley_90,benj_90,coleman_90
;---> daug_90,day_90,divac_90,drexler_90,elliot_90,ellis_90,smith_90
;---> stockton_90,thomas_90,tisdale_90,ellison_90,ewing_90,gill_90,grant_90
;---> hardaway_90,harper_90,hawkins_90,horna_90,jackson_90,johnson_90,kemp_90
;---> laetner_90,lewis_90,majerle_90,malone_90,manning_90,miller_90,mullin_90
;---> mutumbo_90,mcdan_90,oakley_90,olaj_90,oneal_90,person_90,petro_90
;---> pippen_90,porter_90,price_90,rice_90,robinson_90,rodman_90,schrempf_90
;---> seik_90,skiles_90,webb_90,wilkins_90,worthy_90

	.endif

#********************************
* Print starring NBA players list

 SUBR	starring

	clr	a0
	move	a0,@HALT
	move	a0,@IRQSKYE		;background color

	CREATE0	starring_nms

	movi	46,a10
	movi	guyhds,a9

	SLEEPK	20
#lp
;Do left side
	movi	[-90,0],a0
	movi	[92,0],a1
	movi	t_plateV,a2
	movi	1,a3				;Z
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	movi	[4,8000h],a6
	clr	a7
	calla	BEGINOBJ

	CREATE0	del_me

	movi	[-90+4,0],a0
	movi	[92+67,0],a1
	move	*a9+,a2,L
	movi	1,a3				;Z
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	movi	[4,8000h],a6
	clr	a7
	calla	BEGINOBJ

	CREATE0	del_me

;	SLEEPK	10

;Do right side
	movi	[400+4,0],a0
	movi	[15+67,0],a1
	move	*a9+,a2,L
	movi	1,a3				;Z
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	movi	[-5,8000h],a6
	clr	a7
	calla	BEGINOBJ

	CREATE0	del_me

	movi	[400,0],a0
	movi	[15,0],a1
	movi	t_plateV,a2
	movi	1,a3				;Z
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	movi	[-5,8000h],a6
	clr	a7
	calla	BEGINOBJ

	CREATE0	del_me

	movi	22,a11
#lplp	SLEEPK	1

	calla	get_all_buttons_cur2
	jrz	#nob

      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#x
#nob 	dsj	a11,#lplp
	dsj	a10,#lp

	SLEEP	2ah
	
#x	calla	pal_clean

	RETP

del_me	SLEEP	74h
	calla	DELOBJA8
	DIE

bounce_snd	.word	>fc80,10,>8129,0	;Ball bounce


#********************************
* Print starring NBA players list

 SUBRP	starring_nms

	movi	#ln0_setup,a2
	calla	setup_message

	movi	CLSDEAD|124,a0
	move	a0,@mess_objid

	movi	195,a0
	move	a0,@mess_cursy
	movi	#str_1,a4
	calla	print_string_C2

	movi	#ln0_setup1,a2
	calla	setup_message

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	movi	219,a0
	move	a0,@mess_cursy

	movi	#guys,a10

	SLEEP	40

;	clr	a9

#lp	move	*a10+,a4,L
	jrz	#x
	calla	print_string_C2

	SLEEPK	11

	movi	219,a0

;	XORK	1,a9
;	jrz	#tag1
;	movi	224,a0
;#tag1
	move	a0,@mess_cursy

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

	jruc	#lp
#x
	movi	CLSDEAD|124,a0
	calla	obj_del1c		;delete text

	calla	pal_clean

	DIE


#guys	.long	#str_2,#str_3,#str_3a,#str_3b,#str_4,#str_5,#str_5a,#str_5b
	.long	#str_6,#str_7,#str_7a,#str_8
	.long	#str_9,#str_9a,#str_10,#str_11,#str_11a,#str_12,#str_13
	.long	#str_13a,#str_13b,#str_14
	.long	#str_15,#str_15a,#str_15b,#str_15c,#str_16,#str_17,#str_17a
	.long	#str_18,#str_19,#str_19a,#str_20
	.long	#str_21,#str_21a,#str_43,#str_22,#str_23a,#str_24
	.long	#str_24a,#str_25
	.long	#str_25b
	.long	#str_26
	.long	#str_27,#str_27a,#str_28,#str_29,#str_29a,#str_29b
	.long	#str_30,#str_31a
;	.long	#str_30,#str_31,#str_31a
	.long	#str_31b,#str_31c,#str_32
	.long	#str_33,#str_33a,#str_34,#str_34a,#str_35,#str_36,#str_37
	.long	#str_37a,#str_37b,#str_38
;	.long	#str_39,#str_39a,#str_40,#str_41,#str_42,#str_43,#str_43a
	.long	#str_39,#str_39a,#str_40,#str_41,#str_42,#str_43a
	.long	#str_43b,#str_44
	.long	#str_45,#str_46,#str_47,#str_47a,#str_47b,#str_23,#str_48,#str_49
	.long	#str_49a,#str_50
	.long	#str_51,#str_51a,#str_52,#str_52a,#str_53,#str_54
	.long	#str_55,#str_55a
	.long	0

#ln0_setup
	RJR_STR	osgemd_ascii,12,1,200,6,WHITEPAL,0

#ln0_setup1
	RJR_STR	osgemd_ascii,12,1,200,6,GOLD,0

#str_1
	.string	"STARRING:",0
#str_2
	.string	"Clyde Drexler",0
#str_3
	.string	"Terry Porter",0
#str_3a
	.string	"Cliff Robinson",0
#str_3b
	.string	"Harvey Grant",0
#str_4
	.string	"James Worthy",0
#str_5
	.string	"Vlade Divac",0
#str_5a
	.string	"Anthony Peeler",0
#str_5b
	.string	"Elden Campbell",0
#str_6
	.string	"Charles Barkley",0
#str_7
	.string	"Dan Majerle",0
#str_7a
	.string	"Kevin Johnson",0
#str_8
	.string	"Dominique Wilkins",0
;	.string	"Danny Manning",0
#str_9
	.string	"Ron Harper",0
#str_9a
	.string	"Stanley Roberts",0
#str_10
	.string	"Tim Hardaway",0
#str_11
	.string	"Chris Mullin",0
#str_11a
	.string	"Chris Webber",0
#str_12
	.string	"Shawn Kemp",0
#str_13
	.string	"Gary Payton",0
#str_13a
	.string	"Kendall Gill",0
#str_13b
	.string	"Detlef Schrempf",0
#str_14
	.string	"Wayman Tisdale",0
#str_15
	.string	"Spud Webb",0
#str_15a
	.string	"Lionel Simmons",0
#str_15b
	.string	"Bobby Hurley",0
#str_15c
	.string	"Mitch Richmond",0
#str_16
	.string	"Hakeem Olajuwon",0
#str_17
	.string	"Kenny Smith",0
#str_17a
	.string	"Sean Elliot",0
#str_18
	.string	"David Robinson",0
#str_19
	.string	"Dale Ellis",0
#str_19a
	.string	"Dennis Rodman",0
#str_20
	.string	"Karl Malone",0
#str_21
	.string	"David Benoit",0
#str_21a
	.string	"John Stockton",0
;#str_21b
;	.string	"Stephen Howard",0
#str_22
	.string	"Jamal Mashburn",0
#str_23
	.string	"Derek Harper",0
#str_23a
	.string	"Jimmy Jackson",0
#str_24
	.string	"Christian Laettner",0
#str_24a
	.string	"Isaiah Rider",0
#str_25
	.string	"Chuck Person",0
;#str_25a
;	.string	"Tony Scott",0
#str_25b
	.string	"Willie Morris Jr.",0
#str_26
	.string	"Dikembe Mutombo",0
#str_27
	.string	"Laphonso Ellis",0
#str_27a
	.string	"Rodney Rogers",0
#str_28
	.string	"Scottie Pippen",0
#str_29
	.string	"Horace Grant",0
#str_29a
	.string	"B.J. Armstrong",0
#str_29b
	.string	"Toni Kukoc",0
#str_30
	.string	"Isiah Thomas",0
;#str_31
;	.string	"Bill Laimbeer",0
#str_31a
	.string	"Joe Dumars",0
#str_31b
	.string	"Lindsey Hunter",0
#str_31c
	.string	"Robert Horry",0
#str_32
	.string	"Reggie Miller",0
#str_33
	.string	"Rik Smits",0
#str_33a
	.string	"Malik Sealy",0
#str_34
	.string	"Mark Price",0
#str_34a
	.string	"Larry Nance",0
#str_35
	.string	"Brad Daughrty",0
#str_36
	.string	"Brad Lohaus",0
#str_37
	.string	"Blue Edwards",0
#str_37a
	.string	"Vin Baker",0
#str_37b
	.string	"Todd Day",0
#str_38
	.string	"Danny Manning",0
;	.string	"Dominique Wilkins",0
#str_39
	.string	"Stacey Augmon",0
#str_39a
	.string	"Kevin Willis",0
#str_40
	.string	"Larry Johnson",0
#str_41
	.string	"Alonzo Mourning",0
#str_42
	.string	"Hersey Hawkins",0
#str_43
	.string	"Jeff Hornacek",0
#str_43a
	.string	"Shawn Bradley ",0
#str_43b
	.string	"Clarence Weatherspoon",0
#str_44
	.string	"Xavier McDaniel",0
#str_45
	.string	"Dee Brown",0
#str_45a
	.string	"Kevin Gamble",0
#str_46
	.string	"Patrick Ewing",0
#str_47
	.string	"Charles Oakley",0
#str_47a
	.string	"Anthony Mason",0
#str_47b
	.string	"John Starks",0
#str_48
	.string	"Derrick Coleman",0
#str_49
	.string	"Kenny Anderson",0
#str_49a
	.string	"Benoit Benjamin",0
#str_50
	.string	"Tom Gugliotta",0
#str_51
	.string	"Pervis Ellison",0
#str_51a
	.string	"Calbert Cheaney",0
#str_52
	.string	"Nick Anderson",0
#str_52a
	.string	"Scott Skiles",0
#str_53
	.string	"Anfernee Hardaway",0
;#str_53a
;	.string	"Mike Iuzzolino",0
#str_54
	.string	"Glen Rice",0
#str_55
	.string	"Rony Seikaly",0
#str_55a
	.string	"Harold Miner",0


	
	.even

	.def	player_names

player_names

;00 ATLANTA
	.long	MANNING,AUGMON		
	.long	AUGMON,MANNING
	.long	MANNING,WILLIS
	.long	WILLIS,MANNING
	.long	AUGMON,WILLIS
	.long	WILLIS,AUGMON

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;01 BOSTON
	.long	MCDAN,BROWN
	.long	BROWN,MCDAN
	.long	MCDAN,GAMBLE
	.long	GAMBLE,MCDAN
	.long	BROWN,GAMBLE
	.long	GAMBLE,BROWN

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;02 CHARLOTTE
	.long	JOHNSN_L,HAWKINS
	.long	HAWKINS,JOHNSN_L
	.long	JOHNSN_L,MOURN
	.long	MOURN,JOHNSN_L
	.long	HAWKINS,MOURN
	.long	MOURN,HAWKINS

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;03 CHICAGO
	.long	PIPPEN,ARMSTR
	.long	ARMSTR,PIPPEN
	.long	PIPPEN,KUKOC
	.long	KUKOC,PIPPEN
	.long	ARMSTR,KUKOC
	.long	KUKOC,ARMSTR

	.long	ARMSTR,GRANT_HC		
	.long	GRANT_HC,ARMSTR
	.long	KUKOC,GRANT_HC		
	.long	GRANT_HC,KUKOC
	.long	PIPPEN,GRANT_HC		
	.long	GRANT_HC,PIPPEN

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;04 CLEVELAND
	.long	PRICE,DAUGHRTY			
	.long	DAUGHRTY,PRICE			
	.long	PRICE,NANCE			
	.long	NANCE,PRICE			
	.long	DAUGHRTY,NANCE			
	.long	NANCE,DAUGHRTY			

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;05 DALLAS
;	.long	HARPER_D,JACK
;	.long	JACK,HARPER_D
;	.long	HARPER_D,MASH
;	.long	MASH,HARPER_D
;	.long	JACK,MASH
;	.long	MASH,JACK

	.long	JACK,MASH
	.long	MASH,JACK
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;06 DENVER
	.long	MUTUMBO,LELLIS
	.long	LELLIS,MUTUMBO			
	.long	MUTUMBO,ROGERS
	.long	ROGERS,MUTUMBO
	.long	LELLIS,ROGERS
	.long	ROGERS,LELLIS

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;07 DETROIT
	.long	THOMAS,DUMARS
	.long	DUMARS,THOMAS
	.long	THOMAS,HORRY
	.long	HORRY,THOMAS
	.long	DUMARS,HORRY
	.long	HORRY,DUMARS

;	.long	DUMARS,LAIMBEER
;	.long	LAIMBEER,DUMARS

	.long	DUMARS,HUNTER
	.long	HUNTER,DUMARS
	.long	THOMAS,HUNTER
	.long	HUNTER,THOMAS
	.long	HORRY,HUNTER
	.long	HUNTER,HORRY

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;	.long	LAIMBEER,HUNTER
;	.long	HUNTER,LAIMBEER
;	.long	LAIMBEER,THOMAS
;	.long	THOMAS,LAIMBEER
;	.long	LAIMBEER,ELLIOT
;	.long	ELLIOT,LAIMBEER


;08 GOLDEN STATE
	.long	THARDAWAY,MULLIN
	.long	MULLIN,THARDAWAY			
	.long	THARDAWAY,WEBBER
	.long	WEBBER,THARDAWAY			
	.long	MULLIN,WEBBER			
	.long	WEBBER,MULLIN			

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;09 HOUSTON
	.long	OLAJUWON,MAXWELL
	.long	MAXWELL,OLAJUWON
	.long	OLAJUWON,ELLIOT
	.long	ELLIOT,OLAJUWON
	.long	MAXWELL,ELLIOT
	.long	ELLIOT,MAXWELL

	.long	MAXWELL,SMITH		
	.long	SMITH,MAXWELL
	.long	OLAJUWON,SMITH		
	.long	SMITH,OLAJUWON
	.long	ELLIOT,SMITH		
	.long	SMITH,ELLIOT

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;10 INDIANA
	.long	MILLER,SEALY
	.long	SEALY,MILLER
	.long	MILLER,SMITS
	.long	SMITS,MILLER
	.long	SEALY,SMITS
	.long	SMITS,SEALY

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;	.long	SMITS,SEALY
;	.long	SEALY,SMITS		
;	.long	SMITS,SCHREMPF
;	.long	SCHREMPF,SMITS		
;	.long	SMITS,MILLER
;	.long	MILLER,SMITS		

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;11 L.A. CLIPPERS
	.long	WILKINS,HARPER_R
	.long	HARPER_R,WILKINS
	.long	WILKINS,ROBERTS
	.long	ROBERTS,WILKINS
	.long	HARPER_R,ROBERTS
	.long	ROBERTS,HARPER_R

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;12 L.A. LAKERS
	.long	PEELER,DIVAC
	.long	DIVAC,PEELER
	.long	PEELER,CAMPBELL
	.long	CAMPBELL,PEELER
	.long	DIVAC,CAMPBELL
	.long	CAMPBELL,DIVAC

	.long	DIVAC,WORTHY
	.long	WORTHY,DIVAC
	.long	PEELER,WORTHY
	.long	WORTHY,PEELER
	.long	CAMPBELL,WORTHY
	.long	WORTHY,CAMPBELL

;	.long	MAGIC,WORTHY
;	.long	WORTHY,MAGIC
;	.long	MAGIC,CAMPBELL
;	.long	CAMPBELL,MAGIC
;	.long	MAGIC,DIVAC
;	.long	DIVAC,MAGIC
;	.long	MAGIC,PEELER
;	.long	PEELER,MAGIC

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0



;13 MIAMI
	.long	RICE,SEIKALY
	.long	SEIKALY,RICE
	.long	RICE,MINER
	.long	MINER,RICE
	.long	SEIKALY,MINER
	.long	MINER,SEIKALY

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;14 MILWAUKEE
	.long	BAKER,EDWARDS
	.long	EDWARDS,BAKER
	.long	BAKER,DAY
	.long	DAY,BAKER
	.long	EDWARDS,DAY
	.long	DAY,EDWARDS
	
	.long	EDWARDS,LOHAUS
	.long	LOHAUS,EDWARDS
	.long	DAY,LOHAUS
	.long	LOHAUS,DAY
	.long	BAKER,LOHAUS
	.long	LOHAUS,BAKER

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;15 MINNESOTTA
	.long	LAETNER,PERSON
	.long	PERSON,LAETNER
	.long	LAETNER,RIDER
	.long	RIDER,LAETNER
	.long	PERSON,RIDER
	.long	RIDER,PERSON

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;16 NEW JERSEY
	.long	COLEMAN,KANDERSON
	.long	KANDERSON,COLEMAN
	.long	COLEMAN,CMORRIS
	.long	CMORRIS,COLEMAN
	.long	KANDERSON,CMORRIS
	.long	CMORRIS,KANDERSON

	.long	KANDERSON,BENJAMIN
	.long	BENJAMIN,KANDERSON
	.long	CMORRIS,BENJAMIN
	.long	BENJAMIN,CMORRIS
	.long	COLEMAN,BENJAMIN
	.long	BENJAMIN,COLEMAN

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;17 NEW YORK
;	.long	HARPER_D,JACK
;	.long	JACK,HARPER_D
;	.long	HARPER_D,MASH
;	.long	MASH,HARPER_D
;	.long	JACK,MASH
;	.long	MASH,JACK

	.long	EWING,MASON
	.long	MASON,EWING
	.long	EWING,STARKS
	.long	STARKS,EWING
	.long	MASON,STARKS
	.long	STARKS,MASON

	.long	MASON,OAKLEY
	.long	OAKLEY,MASON
	.long	EWING,OAKLEY
	.long	OAKLEY,EWING
	.long	STARKS,OAKLEY
	.long	OAKLEY,STARKS

	.long	HARPER_D,OAKLEY
	.long	OAKLEY,HARPER_D
	.long	HARPER_D,MASON
	.long	MASON,HARPER_D
	.long	HARPER_D,STARKS
	.long	STARKS,HARPER_D
	.long	HARPER_D,EWING
	.long	EWING,HARPER_D


;18 ORLANDO
	.long	AHARDAWAY,NANDERSON
	.long	NANDERSON,AHARDAWAY
	.long	AHARDAWAY,SKILES
	.long	SKILES,AHARDAWAY
	.long	NANDERSON,SKILES
	.long	SKILES,NANDERSON

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;	.long	IUZZ,SKILES
;	.long	SKILES,IUZZ
;	.long	IUZZ,NANDERSON
;	.long	NANDERSON,IUZZ
;	.long	IUZZ,AHARDAWAY
;	.long	AHARDAWAY,IUZZ

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;19 PHILADELPHIA
	.long	WEATH,BRAD
	.long	BRAD,WEATH		
;	.long	WEATH,HORNACEK		
;	.long	HORNACEK,WEATH		
;	.long	BRAD,HORNACEK		
;	.long	HORNACEK,BRAD		

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;20 PHOENIX
	.long	BARKLEY,MAJERLE
	.long	MAJERLE,BARKLEY			
	.long	BARKLEY,KJOHNSON			
	.long	KJOHNSON,BARKLEY			
	.long	MAJERLE,KJOHNSON			
	.long	KJOHNSON,MAJERLE			

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;21 PORTLAND
	.long	DREXLER,PORTER
	.long	PORTER,DREXLER		
	.long	DREXLER,CROBINSON
	.long	CROBINSON,DREXLER
	.long	PORTER,CROBINSON		
	.long	CROBINSON,PORTER

	.long	GRANT_HV,CROBINSON		
	.long	CROBINSON,GRANT_HV		
	.long	GRANT_HV,PORTER		
	.long	PORTER,GRANT_HV		
	.long	GRANT_HV,DREXLER		
	.long	DREXLER,GRANT_HV		

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;22 SACRAMENTO
	.long	SIMM,HURL
	.long	HURL,SIMM
	.long	SIMM,RICH
	.long	RICH,SIMM
	.long	HURL,RICH
	.long	RICH,HURL

	.long	HURL,WEBB
	.long	WEBB,HURL
	.long	HURL,TISDALE
	.long	TISDALE,HURL

	.long	SIMM,TISDALE
	.long	TISDALE,SIMM
	.long	RICH,TISDALE
	.long	TISDALE,RICH
	.long	WEBB,TISDALE
	.long	TISDALE,WEBB
	.long	WEBB,RICH
	.long	RICH,WEBB
	.long	WEBB,SIMM
	.long	SIMM,WEBB


;23 SAN ANTONIO
	.long	DROBINSON,RODMAN
	.long	RODMAN,DROBINSON
	.long	DROBINSON,DELLIS
	.long	DELLIS,DROBINSON
	.long	RODMAN,DELLIS
	.long	DELLIS,RODMAN

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;24 SEATTLE
	.long	KEMP,PAYTON
	.long	PAYTON,KEMP			
	.long	KEMP,GILL
	.long	GILL,KEMP			
	.long	PAYTON,GILL
	.long	GILL,PAYTON			

	.long	SCHREMPF,GILL
	.long	GILL,SCHREMPF
	.long	SCHREMPF,PAYTON
	.long	PAYTON,SCHREMPF
	.long	SCHREMPF,KEMP
	.long	KEMP,SCHREMPF

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;25 UTAH
	.long	MALONE_K,STOCKTON
	.long	STOCKTON,MALONE_K
	.long	MALONE_K,BENOIT
	.long	BENOIT,MALONE_K
	.long	STOCKTON,BENOIT
	.long	BENOIT,STOCKTON

	.long	HORNACEK,BENOIT
	.long	BENOIT,HORNACEK
	.long	HORNACEK,STOCKTON
	.long	STOCKTON,HORNACEK
	.long	HORNACEK,MALONE_K
	.long	MALONE_K,HORNACEK

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;26 WASHINGTON
	.long	GUGLI,ELLISON
	.long	ELLISON,GUGLI
	.long	GUGLI,CHEANEY
	.long	CHEANEY,GUGLI
	.long	ELLISON,CHEANEY
	.long	CHEANEY,ELLISON

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;27 MORTAL KOMBAT

	.long	MALONE_K,KEMP
	.long	DROBINSON,BARKLEY
	.long	DREXLER,AHARDAWAY
	.long	EWING,KANDERSON
	.long	COLEMAN,NANDERSON
	.long	STOCKTON,KJOHNSON

	.long	GILL,RICH
	.long	BRAD,WEBB
	.long	DUMARS,STARKS
	.long	MUTUMBO,WILKINS
	.long	HARPER_R,RIDER
	.long	MILLER,JOHNSN_L

	.long	OLAJUWON,BAKER
	.long	ARMSTR,MAXWELL
	.long	MOURN,RICE
	.long	THARDAWAY,JACK
	.long	PIPPEN,MINER
	.long	THOMAS,WEBBER
	.long	MASH,WORTHY
	.long	MULLIN,MANNING


;	.long	SCORP,RAIDEN
;	.long	RAIDEN,SCORP
;	.long	SCORP,REPT
;	.long	REPT,SCORP
;	.long	RAIDEN,REPT
;	.long	REPT,RAIDEN
;
;	.long	SUBZ,REPT
;	.long	REPT,SUBZ
;	.long	SUBZ,RAIDEN
;	.long	RAIDEN,SUBZ
;	.long	SUBZ,SCORP
;	.long	SCORP,SUBZ
;
;	.long	SUBZ,HOSK
;	.long	HOSK,RAIDEN
;	.long	OLIV,HOSK
;	.long	RAIDEN,OLIV
;	.long	OLIV,SUBZ
;	.long	REPT,HOSK
;	.long	HOSK,TURMELL
;	.long	TURMELL,OLIV

	.def	our_names
our_names
	.long	GOSKIE		;0
	.long	RIVETT		;1
	.long	CARLTON		;2
	.long	DIVITA		;3
	.long	LIPTAK		;4
	.long	TURMELL		;5
	.long	HEY		;6
	.long	PETRO		;7
	.long	NEWCOMER	;8
	.long	OURSLER		;9
	.long	LASKO		;10		;HOWARD
	.long	MORRIS		;11
	.long	MEDNICK		;12		
	.long	FORD		;13		
	.long	KINKEAD		;14		
	.long	JARVIS		;15		
	.long	SUBZ		;16		
	.long	HAEGER		;17		
	.long	SIMPSON		;18		
	.long	GREEN		;19		
	.long	GENTILE		;20		
	.long	DILLON		;21		
	.long	LOWES		;22		
	.long	VOGEL		;23		
	.long	TSUI		;24		
	.long	KAM		;25		
	.long	DEAL		;26		
	.long	BOOTY		;27		
	.long	LOFFRE		;28		
	.long	PENACHO		;29		
	.long	BARKER		;30		
	.long	COX		;31		
	.long	RAIDEN		;32		
	.long	REAPER		;33		
	.long	MACIKA		;34		
	.long	SHARPE		;35		
	.long	BERAN		;36		
	.long	COMAN		;37		
	.long	KONGO		;38		
	.long	PONTAREL	;39		
	.long	ELVIS		;40		
	.long	DAVIS		;41		
	.long	BOON		;42		
	.long	TOBIAS		;43		
	.long	HEITSCH		;44		
	.long	DABEL		;45		
	.long	MARTINEZ	;46		
	.long	DAVIES		;47		
	.long	HOSK		;48		
	.long	OLIV		;49		
	.long	SCORP		;50		
	.long	REPT		;51		
	.long	GRANN		;52		
	.long	GAY		;53
	.long	JSKILES		;54
	.long	LINHOFF		;55

	.long	WILKINS  	;56
	.long	BROWN	  	;57
	.long	MOURN	  	;58
	.long	PIPPEN    	;59
	.long	THOMAS	 	;60
	.long	WEBBER	  	;61
	.long	OLAJUWON  	;62
	.long	COLEMAN	  	;63
	.long	EWING	  	;64
	.long	BARKLEY	  	;65
	.long	DROBINSON  	;66
	.long	KEMP	  	;67
	.long	MALONE_K  	;68







	.end

