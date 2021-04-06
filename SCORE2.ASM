**************************************************************
*
* Owner:	JOHNSON
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
	.include	"world.equ"		;Court-world defs
	.include	"game.equ"
	.include	"macros.hdr"
	.include	"audit.equ"
	.asg		0,SEQT
	.include	"plyr.equ"

	.include	"arrow.glo"


;symbols externally defined

	.ref	IRQSKYE
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
	.ref	AUD,AUD1,scores,PSTATUS2
	.ref	UNIT_CLR,get_all_buttons_down
	.ref	player1_data,player2_data,inbound
	.ref	player3_data,player4_data
	.if DRONES_2MORE
	.ref	player5_data,player6_data
	.endif
	.ref	pup_trbstealth
	.ref	un_wipe_horizontal,wipe_stack_vert_up
	.ref	wipe_horz_stag_dwn
	.ref	do_scrn_transition
	.ref	CREATE_NO_DEL_OBJS,NO_CREATE_DEL_OBJS
	.ref	brush20_ascii,brush50_ascii
	.ref	infoex_snd,bounce_snd
	.ref	mess_cursy,mess_objid
	.ref	setup_message,print_string_C2
	.ref	fade_down
	.ref	HANGF_R_P,HANGF_W_P
	.ref	BAKMODS,BGND_UD1
	.ref	BKGDBMOD
	.ref	gndstat,dtype,dpageflip
	.ref	tuneend_snd,tune_gmovr
	.ref	kp_qscrs,kp_qscrs2,kp_team1,kp_team2,kp_scores
	.ref	kp_p1_crtplr,kp_p2_crtplr,kp_p3_crtplr,kp_p4_crtplr
;MJT Start
	.ref	kp_p1_name1,kp_p1_name2,kp_p1_name3,kp_p1_name4
	.ref	kp_p1_name5,kp_p1_name6,kp_p1_hdnbr
	.ref	kp_p2_name1,kp_p2_name2,kp_p2_name3,kp_p2_name4
	.ref	kp_p2_name5,kp_p2_name6,kp_p2_hdnbr
	.ref	kp_p3_name1,kp_p3_name2,kp_p3_name3,kp_p3_name4
	.ref	kp_p3_name5,kp_p3_name6,kp_p3_hdnbr
	.ref	kp_p4_name1,kp_p4_name2,kp_p4_name3,kp_p4_name4
	.ref	kp_p4_name5,kp_p4_name6,kp_p4_hdnbr
;MJT End

;symbols defined in this file

	.def	player_data

;uninitialized ram definitions

	BSSX	idiot_bits,16
	BSSX	fontram,30*32		;font imgs for red/white flashing

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

;;	CREATE0	do_warns

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
	addi	[61h+2,0],a1
	movi	#boxx_t,a0
	add	a11,a0
	move	*a0,a0,L
	addi	[4ch+2,0],a0
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

	SOUND1	infoex_snd

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

	SOUND1	infoex_snd

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

	SOUND1	infoex_snd

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

	SOUND1	infoex_snd

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
	.long	arrown1r,arrown2r,arrown3r,arrown4r
arws2_t
	.long	arrown1r2p,arrown1r2p,arrown2r2p,arrown2r2p

#boxy_t	.long	[48-8,0],[48+70+8,0],[48-8,0],[48+70+8,0]
#boxx_t	.long	[7,0],[64h,0],[0c3h,0],[120h,0]
ply_t	.long	plyr1,plyr2,plyr3,plyr4
ply2_t	.long	plyr1,plyr1,plyr2,plyr2
pal_t
	.long	HINT_B_P,HINT_B_P,HINT_B_P,HINT_B_P	;normal 4 plyr
	.long	HINT_B_P,HINT_B_P,HINT_B_P,HINT_B_P	;KIT 
;	.long	GROWBOXb,GROWBOXb,GROWBOXr,GROWBOXr	;
;	.long	GROWBOXb,GROWBOXb,GROWBOXr,GROWBOXr	;kit



#***************************************************************
* Shake screen as if an earthquake is in effect
* A10 = # ticks to shake and power of shake
* Note: time to shake must be more than 6 ticks

	BSSX	#SHK_ON,16		;is a shake in progress?
	BSSX	#Y_ADJ,32		;current deviation from rest
	BSSX	shakers_started,16
	BSSX	shakers_finished,16
	BSSX	shakers_killed,16

 SUBR	SHAKER2

	;check for a valid a10
	move	a10,a10
	jrn	#done
	jrz	#done

	move	@#SHK_ON,a0
	jrz	#no_shake

	;abort shake currently in progress
	movi	SHAKE_PID,a0
	calla	KIL1C
	move	@#Y_ADJ,a14,L
	move	@WORLDTLY,a0,L
	sub	a14,a0
	move	a0,@WORLDTLY,L

	move	@shakers_killed,a14
	inc	a14
	move	a14,@shakers_killed

#no_shake
	;set the 'in progress' flag
	movk	1,a14
	move	a14,@#SHK_ON

	;create the shaker process
	CREATE	SHAKE_PID,#shaker

#done
	rets

#shaker
	;a9  = index into sine table
	;a10 = time left
	;a11 = original time left

	;initialize
	movi	#last_entry,a9
	move	a10,a11

	move	@shakers_started,a14
	inc	a14
	move	a14,@shakers_started

#loop
	;calculate the new offset

	;get the cosine
	move	a9,a14
	sll	4,a14
	addi	#sine_table,a14
	move	*a14,a0,W

	;get the exp (index is 64 - (64 * a10 / a11)
	move	a10,a1
	sll	6,a1
	divu	a11,a1
	neg	a1
	addi	64,a1
	sll	4,a1
	addi	#exp_table,a1
	move	*a1,a1,W

	;multiply
	mpys	a0,a1

	;scale
	sra	5,a1
	mpyu	a11,a1

	move	a1,@#Y_ADJ,L

	;update the table pointer
	dec	a9
	jrnn	#table_ok
;;;;	dsj	a9,#table_ok
;;;;	movi	#last_entry,a9
#table_ok

	;apply it
	move	@WORLDTLY,a14,L
	add	a14,a1
	move	a1,@WORLDTLY,L

	;nap
	SLEEPK	1

	;undo it
	move	@#Y_ADJ,a14,L
	move	@WORLDTLY,a1,L
	sub	a14,a1
	move	a1,@WORLDTLY,L

	;loop
	dsj	a10,#loop

	;all done
	clr	a14
	move	a14,@#SHK_ON
	move	a14,@#Y_ADJ,L

	move	@shakers_finished,a14
	inc	a14
	move	a14,@shakers_finished

	DIE


	;36-degree increments
#cosine_table			;deg
	.word	828		;324
	.word	316		;288
	.word	-315		;252
	.word	-827		;216
	.word	-102		;180
	.word	-827		;144
	.word	-315		;108
	.word	316		;72
	.word	828		;36
	.word	1024		;0
	
#sine_table			;deg
	.word	-601		;324
	.word	-973		;288
	.word	-973		;252
	.word	-601		;216
	.word	0		;180
	.word	602		;144
	.word	974		;108
	.word	974		;72
	.word	602		;36
	.word	0		;0
#last_entry	equ	9

	;values of e^(-x) for values from 0 to 7, in 64 divisions
	; e.g. e^-1.5 is the 32nd entry
	; all values are multiplied by 1024

#exp_table		;damps at speed 5
	.word 1024,945,873,807,745,688,636,587
	.word 542,501,463,427,395,364,337,311
	.word 287,265,245,226,209,193,178,165
	.word 152,140,130,120,110,102,94,87
	.word 80,74,68,63,58,54,50,46
	.word 42,39,36,33,31,28,26,24
	.word 22,20,19,17,16,15,14,13
	.word 12,11,10,9,8,8,7,6




#***************************************************************
* Shake screen as as if an earthquake is in effect
* A10 = # ticks to shake and power of shake
* Note: time to shake must be more than 6 ticks

	.BSS	AMP,16
	.BSS	AMPCNT,16
	.BSS	XSET,16
	.BSS	YSET,16
	BSSX	SHK_ON,16

	.ref	RNDRNG0

 SUBR	SHAKER

	move	@SHK_ON,a0
	jrnz	#x
	move	a10,a11
	movk	8,a0
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


;; SUBR	do_warns
;;	DIE
;;	SOUND1	warn2_snd
;;	SLEEPK	20
;;	SOUND1	warn2_snd
;;	SLEEPK	20
;;	SOUND1	warn2_snd
;;	SLEEPK	20
;;	SOUND1	warn2_snd
;;	SLEEPK	20
;;	SOUND1	warn2_snd
;;	SLEEPK	20
;;	SOUND1	warn2_snd
;;	SLEEPK	20
;;	SOUND1	warn2_snd
;;	DIE

#************************************
* Create idiot box process to give the player a message
* A0=Message #
* A1=Plyr # (0-3)

 SUBR	idiot_box

	.if DUNKTST | DEBUG
	rets			;When testing dunks - PUT IN!
	.endif

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
	.if DRONES_2MORE
	.long	player5_data,player6_data
	.endif

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

	SOUND1	infoex_snd

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

;White color in instruction plate pal
	movi	>0101,a2
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
 SUBR	flash_bigtxt
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
	movi	HANGF_W_P,a0
	calla	pal_getf
	movi	fontram,a3
	
#lp2
	move	*a3+,a1,L
	jrz	#xx
	move	a0,*a1(OPAL)
	jruc	#lp2

#xx	SLEEPK	3

	movi	HANGF_R_P,a0
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
 SUBR	flash_blu_txt
  
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
	movi	BRSHGWKP,a0
	calla	pal_getf
	movi	fontram,a3
	
#lp2
	move	*a3+,a1,L
	jrz	#xx
	move	a0,*a1(OPAL)
	jruc	#lp2

#xx	SLEEPK	3

	movi	BRSH_B_P,a0
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
	move	a0,@PSTATUS
	move	a0,@PSTATUS2

;MJT Start
	move	@player1_data+PR_CREATED_PLYR,a14
	move	a14,@kp_p1_crtplr
	move	@player1_data+PR_NAME1,a14
	move	a14,@kp_p1_name1
	move	@player1_data+PR_NAME2,a14
	move	a14,@kp_p1_name2
	move	@player1_data+PR_NAME3,a14
	move	a14,@kp_p1_name3
	move	@player1_data+PR_NAME4,a14
	move	a14,@kp_p1_name4
	move	@player1_data+PR_NAME5,a14
	move	a14,@kp_p1_name5
	move	@player1_data+PR_NAME6,a14
	move	a14,@kp_p1_name6
	move	@player1_data+PR_HEAD_NBR,a14
	move	a14,@kp_p1_hdnbr

	move	@player2_data+PR_CREATED_PLYR,a14
	move	a14,@kp_p2_crtplr
	move	@player2_data+PR_NAME1,a14
	move	a14,@kp_p2_name1
	move	@player2_data+PR_NAME2,a14
	move	a14,@kp_p2_name2
	move	@player2_data+PR_NAME3,a14
	move	a14,@kp_p2_name3
	move	@player2_data+PR_NAME4,a14
	move	a14,@kp_p2_name4
	move	@player2_data+PR_NAME5,a14
	move	a14,@kp_p2_name5
	move	@player2_data+PR_NAME6,a14
	move	a14,@kp_p2_name6
	move	@player2_data+PR_HEAD_NBR,a14
	move	a14,@kp_p2_hdnbr

	move	@player3_data+PR_CREATED_PLYR,a14
	move	a14,@kp_p3_crtplr
	move	@player3_data+PR_NAME1,a14
	move	a14,@kp_p3_name1
	move	@player3_data+PR_NAME2,a14
	move	a14,@kp_p3_name2
	move	@player3_data+PR_NAME3,a14
	move	a14,@kp_p3_name3
	move	@player3_data+PR_NAME4,a14
	move	a14,@kp_p3_name4
	move	@player3_data+PR_NAME5,a14
	move	a14,@kp_p3_name5
	move	@player3_data+PR_NAME6,a14
	move	a14,@kp_p3_name6
	move	@player3_data+PR_HEAD_NBR,a14
	move	a14,@kp_p3_hdnbr

	move	@player4_data+PR_CREATED_PLYR,a14
	move	a14,@kp_p4_crtplr
	move	@player4_data+PR_NAME1,a14
	move	a14,@kp_p4_name1
	move	@player4_data+PR_NAME2,a14
	move	a14,@kp_p4_name2
	move	@player4_data+PR_NAME3,a14
	move	a14,@kp_p4_name3
	move	@player4_data+PR_NAME4,a14
	move	a14,@kp_p4_name4
	move	@player4_data+PR_NAME5,a14
	move	a14,@kp_p4_name5
	move	@player4_data+PR_NAME6,a14
	move	a14,@kp_p4_name6
	move	@player4_data+PR_HEAD_NBR,a14
	move	a14,@kp_p4_hdnbr
;MJT End

	clr	a1
	move	a1,@player1_data+PR_CREATED_PLYR	;stop plyr from being
	move	a1,@player2_data+PR_CREATED_PLYR	;seen in amode
	move	a1,@player3_data+PR_CREATED_PLYR
	move	a1,@player4_data+PR_CREATED_PLYR

	.ref	clear_secret_powerup_ram
	calla	clear_secret_powerup_ram

	clr	a0				;Fixed (?) game over stuff
	move	a0,@DISPLAYON			;Fixed (?) game over stuff
	calla	WIPEOUT				;Fixed (?) game over stuff
	clr	a0				;Fixed (?) game over stuff
	move	a0,@dtype		;2D	;Fixed (?) game over stuff

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

 	movi	JOIN_CYCLE_PID,a0
	calla	KIL1C
	movi	CYCPID2,a0
	calla	KIL1C
 	movi	CYCPID,a0
	calla	KIL1C

	SLEEPK	3

	movk	1,a0				;Fixed (?) game over stuff
	move	a0,@DISPLAYON			;Fixed (?) game over stuff

	movi	#pal_t,a10
	movi	64,a11
	CREATE0	fade_down

	SLEEP	2*TSEC

	clr	a0
	move	a0,@DISPLAYON		;Turn the display off

	.ref	result_screen
	JSRP	result_screen

	SOUND1	tuneend_snd
	SOUND1	tune_gmovr


	calla	UNIT_CLR		;CLEAR THE FACTIONS OF FRACTIONS
	calla	WIPEOUT

	SLEEPK	1

	movk	1,a0
	move	a0,@DISPLAYON		;Turn the display back on
	clr	a0
	move	a0,@WFLG

	jauc	amode_start		;Start attract mode


#pal_t	.long	BRSH50R_P,0

LN1b_setup
	PRINT_STR	brush50_ascii,6,0,200,57,BRSH50R_P,0
LN2b_setup
	PRINT_STR	brush50_ascii,6,0,200,128,BRSH50R_P,0
#str_game
	.byte	"GAME",0
#str_over
	.byte	"OVER",0
	.even

game_ovr_mod
	.long	BKGDBMOD
	.word	0,0
	.long	0
	


#*************************************************************************
* Game over processing - called at end of 'CREATE-A-PLAYER'
*
 SUBR	game_over_processing

	movi	AUDBONE,a0		;DEC CMOS CNT OF GAMES STARTED
	movi	-1,a1
	calla	AUD

	clr	a0
	move	a0,@PSTATUS
	move	a0,@PSTATUS2

;	movk	1,a0
;	move	a0,@HALT

	clr	a1				;kill all processes
	calla	KILALL

	clr	a1
	move	a1,@player1_data+PR_CREATED_PLYR	;stop plyr from being
	move	a1,@player2_data+PR_CREATED_PLYR	;seen in amode
	move	a1,@player3_data+PR_CREATED_PLYR
	move	a1,@player4_data+PR_CREATED_PLYR

	calla	pal_clean
;	clr	a0
;	move	a0,@DISPLAYON		;Turn the display off

	calla	UNIT_CLR		;CLEAR THE FACTIONS OF FRACTIONS

;	calla	WIPEOUT
;	movk	1,a0
;	move	a0,@DISPLAYON		;Turn the display back on
	clr	a0
	move	a0,@WFLG
	rets


#******************************************************************
* Note: Scratch = A0-A2,A14,B0-B1
* A9=plyr *obj
* A10=plyr *proc
* A11=plyr #
* A13=plyr_lost *proc

 SUBR	update_shoes

;	.if	IMGVIEW
;	rets
;	.endif

	move	a11,a0
	sll	5,a0
	addi	player_data,a0,L
	move	*a0,a0,L
	move	*a0(PR_PRIVILEGES),a0
	jrle	#ushs				;br=not a created player
	btst	1,a0				;STEALTH TURBO privilege ?
	jrnz	#x				;br=yes
#ushs
	move	@pup_trbstealth,a14		
	btst	a11,a14				;Plyr have stealth turbo?
	jrnz	#x				;br=yes

;	move	*a10(plyr_keeppal),a14
;	jrnz	#x				;Br=flames on body mode

	movi	wht_shoes,a0			;*pal data
;	btst	0,a11
;	jrz	#noblk
;	movi	blk_shoes,a0			;*pal data
;#noblk
	move	*a10(PA11),a14,L
	move	*a14,a14			;A14=Ctrl bits
	btst	6,a14				;Turbo but down?
	jrz	#noturb				;br=no
	move	*a10(plyr_PDATA_p),a14,L	;Deref plyr *proc for *data
	move	*a14(ply_turbo),a14		;No turbo left?
	jrz	#noturb				;br=none left

	move	@PSTATUS,a14
	btst	a11,a14				;Plyr human or drone?
	jrz	#noturb				;br=drone

	movi	shoec_t,a0
	move	@TWOPLAYERS,a14			;0 = NO, 1 = YES 2 players
	jrz	#not_2p
	movi	shoec_t_kit,a0
#not_2p
	move	a11,a14
	sll	5,a14
	add	a14,a0
	move	*a0,a0,L			;*pal data
;	btst	0,a11
;	jrz	#nogrn
;	movi	grn_shoes,a0			;*pal data
;#nogrn

#noturb
	move	@GAMSTATE,a14			;No pal change in attract
	cmpi	INAMODE,a14
	jrz	#x
	move	*a13(PDATA),a14,L		;Nothing to do if already set
	cmp	a0,a14
	jrz	#x
  	move	a0,*a13(PDATA),L		;Save *pal data
	
	move	*a9(OPAL),a1
	andi	0ff00h,a1
	addi	93,a1				;!!!Starting color #
;	movk	16,a2				;!!!Color cnt
	movk	13,a2				;!!!Color cnt
	calla	pal_set
#x
	rets


shoec_t
	.long	#blu,#grn,#yel,#red
shoec_t_kit
	.long	#blu,#blu,#red,#red

#red
;	COLORW	31,0,0
;	COLORW	26,0,0
;	COLORW	20,0,0
;	COLORW	15,0,0
;	COLORW	10,0,0
;SHOER_P:
	.word   07c00h,07000h,06800h,05c00h,05000h,04800h,03c00h
	.word   03000h,02800h,01c00h,01000h,00800h,00000h

;	.word   07d06h,07cc4h,07482h
;	.word	06c40h,06400h,05800h
;	.word	05000h,04800h,03800h
;	.word	03000h,02800h,02000h
;	.word	01800h,00c00h,00400h
;	.word   00000h
#grn
;	COLORW	0,(31-7),0
;	COLORW	0,(27-7),0
;	COLORW	0,(22-7),0
;	COLORW	0,(18-7),0
;	COLORW	0,(14-7),0
;SHOEG_P:
	.word   003e0h,00380h,00340h,002e0h,00280h,00240h,001e0h
	.word   00180h,00140h,000e0h,00080h,00040h,00000h

;	.word   00b66h,00324h,002e2h
;	.word	002a0h,00260h,00200h
;	.word	001c0h,001a0h,00160h
;	.word	00120h,000e0h,000a0h
;	.word	00060h,00000h,00000h
;	.word   00000h
#blu
;	COLORW	0,10,31
;	COLORW	0,8,27
;	COLORW	0,6,22
;	COLORW	0,4,18
;	COLORW	0,0,14
;SHOEB_P:
	.word	001ffh,001dch,0019ah,00177h,00154h,00112h,000efh
	.word   000cch,0008ah,00067h,00044h,00002h,00000h

;	.word	02ddfh,0259fh,01d5fh
;	.word	0151fh,00cdeh,0007bh
;	.word	00039h,00017h,00015h
;	.word	00013h,00011h,0000fh
;	.word	0000dh,0000ah,00008h
;	.word   00007h
#yel
;	COLORW	31,31,0
;	COLORW	27,27,0
;	COLORW	22,22,0
;	COLORW	18,18,0
;	COLORW	14,14,0
;SHOEY_P:
	.word   07fe0h,07380h,06b40h,05ee0h,05280h,04a40h,03de0h
	.word   03180h,02940h,01ce0h,01080h,00840h,00000h


;	.word   07fe6h,07bc4h,07382h
;	.word	06b40h,06300h,056a0h
;	.word	04e60h,04620h,035a0h
;	.word	02d60h,02520h,01ce0h
;	.word	014a0h,00840h,00000h
;	.word	00000h
wht_shoes
;	COLORW	31,31,31
;	COLORW	27,27,27
;	COLORW	22,22,22
;	COLORW	18,18,18
;	COLORW	14,14,14
;
;SHOEW_P:
	.word   077bdh,06f7bh,06318h,05ad6h,04e73h,04631h,039ceh
	.word   0318ch,02529h,01ce7h,01084h,00842h,00000h


;	.word   07fffh,077bdh,06f7bh
;	.word	06739h,05ef7h,05294h
;	.word	04a52h,04210h,039ceh
;	.word	0318ch,0294ah,02108h
;	.word	018c6h,00c63h,00421h
;	.word	00000h

;--------------------

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
;	.long	#str_7,#str_7a,#str_8

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
	PRINT_STR	brush20_ascii,12,1,200,6,BRSH_W_P,0

#ln0_setup1
	PRINT_STR	brush20_ascii,12,1,200,6,BRSHGYOP,0

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
	.endif

	.end


