****************************************************************
*
* Software:	Jamie Rivett
* Initiated:	?
*
* Modified:	?
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/15/93 15:29
****************************************************************
	.file	"select2.asm"
	.title	"name & team selection"
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"mac2.asm"

	.include	"imgtblm.glo"
	.include	"mugshot.tbl"

	.include	"imgtbl.glo"
	.include	"imgtblp.glo"
	.include	"imgtbl2.glo"
	.include	"bgndtbl.glo"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"shawn.hdr"

	.include	"imgpalm.asm"
	.include	"imgtblm.glo"

;sounds

tunegc_snd	.word	>f3fe,1,>800c,0		;Grand champion play tune

;symbols defined in this file

;	.def	plyr_nms
	.def	player_heads

************************************************************************

	.ref	create_bits
	.ref	kp_qscrs2,PCNT
	.ref	HALT
	.ref	city_tbl

	.ref	kp_ram
	.ref	snd_play1
	.ref	tm2set,tm1set

	.ref	credit1_obj
	.ref	credit2_obj
	.ref	credit3_obj
	.ref	name1_obj
	.ref	name2_obj
	.ref	name3_obj
	.ref	name4_obj

	.ref	attrib1_obj
	.ref	attrib2_obj
	.ref	attrib3_obj
	.ref	attrib4_obj
	.ref	CRED_P
	.ref	teamset1_obj
	.ref	teamset2_obj
 	.ref	create_credits
	.ref	TWOPLAYERS			;0 = NO, 1 = YES 2 players
	.ref	concat_string
	.ref	copy_rom_string
	.ref	mess_cursy,mess_objid
	.ref	mess_line_spacing
	.ref	CYCLE_TABLE,COLTAB2
	.ref	pal_getf
	.ref	get_initials_string
	.ref	dropout_stats
	.ref	conttimers
	.ref	PSTATUS2
	.ref	GET_ADJ
	.ref	game_purchased
	.ref	GAMSTATE
	.ref	monitor_fullgame
	.ref	message_buffer
	.ref	pleasewt
	.ref	game_over
	.ref	credits
	.ref	KILBGND
	.ref	print_string_C2
	.ref	cntrs_delay
	.ref	can_enter_inits
	.ref	page_scrolling
	.ref	winningteam
	.ref	newptr
	.ref	CR_CONTP
	.ref	team_control
	.ref	plyrsdropped
	.ref	P1DATA
	.ref	pal_clean
	.ref	qtr_purchased
	.ref	credit_messages
	.ref	newplyrs
	.ref	monitor_buyins
	.ref	COLRTEMP
	.ref	gmqrtr


*************************************************************************

	.ref	fade_up,fade_down

	.ref	calc_num_defeated
	.ref	RNDRNG0
	.ref	team2
	.ref	team1

	.ref	BAKMODS
	.ref	switches_cur
	.ref	inmatchup
	.ref	player1_data
	.ref	dec_to_asc
	.ref	cntdown_snd
	.ref	pal_set
	.ref	player2_data
	.ref	get_teams_pop
	.ref	create_logos
	.ref	call_matchup
	.ref	pal_find
	.ref	special_heads
	.ref	player3_data
	.ref	create_player_heads
	.ref	update_player_heads
	.ref	dpageflip
	.ref	IRQSKYE
	.ref	PSTATUS
	.ref	player4_data
	.ref	switches_down
	.ref	print_string_C
	.ref	BGND_UD1
	.ref	obj_on
	.ref	force_selection
	.ref	obj_off
	.ref	print_ranking
	.ref	scores
	.ref	WIPEOUT
	.ref	mess_cursx
	.ref	update_logos
	.ref	setup_message
	.ref	osgemd_ascii
	.ref	osgmd8_ascii
	.ref	copy_string
	.ref	speech_playovrp

	.ref	_DAL	;27
	.ref	_MIN	;26
	.ref	_MI	;22
	.ref	_WAS	;21
	.ref	_PHI	;25
	.ref	_SAC	;24
	.ref	_MIL	;18
	.ref	_DEN	;23
	.ref	_GOL	;20
	.ref	_SAN	;19
	.ref	_SEA	;17
	.ref	_ATL	;16
	.ref	_ORL	;15
	.ref	_LAC	;14
	.ref	_NJ	;13
	.ref	_CHA	;12
	.ref	_BOS	;11
	.ref	_CLE	;10
	.ref	_DET	;9
	.ref	_HOU	;8
	.ref	_IND	;7
	.ref	_LAL	;6
	.ref	_UTA	;5
	.ref	_NY	;4
	.ref	_POR	;3
	.ref	_PHX	;2
	.ref	_CHI	;1
************************************************************************


	.text



congrats_snd	.word	>f3ff,>8,>8004,0	;



********************************
#*

MAX_CRTIME	equ	>7fff		;30*60
TEAMSEL_PAGE	equ	0*256
NAMENT_PAGE	equ	1*256

	.asg	>5e+5,x1
	.asg	>a1+5,x1a
	.asg	>e4+5,x2a
	.asg	>ad+5,x1b
	.asg	>12f5+2,y1
	.asg	>131f,y1a


	.def	ladder_imgs0
	.def	ladder_imgs1,ladder_imgs2,ladder_imgs3,ladder_imgs4
	.def	ladder_imgs5,ladder_imgs6

ladder_imgs0
;2
	.long	HPR_DAL,x1+400,y1
	.long	JAC_DAL,x1,y1
	.long	MAS_DAL,x2a,y1
	.long	T_MAVS,x1b,y1a

	.long	THM_DET,x1,y1->b3
	.long	DUM_DET,x1a,y1->b3

	.long	ELL_DET,x2a,y1->b3
;	.long	HOR_HOU,x2a,y1->b3
	.long	T_PISS,x1b,y1a->b3

	.long	0

ladder_imgs1
;4
	.long	BAK_MLW,x1,y1->b3*2-2
	.long	EDW_MLW,x1a,y1->b3*2-2
	.long	DAY_MLW,x2a,y1->b3*2-2
	.long	T_BUCKS,x1b,y1a->b3*2-2

	.long	GUG_WAS,x1,y1->b3*3-2
	.long	ELL_WAS,x1a,y1->b3*3-2
	.long	CHE_WAS,x2a,y1->b3*3-2
	.long	T_BULTS,x1b,y1a->b3*3-2

	.long	SIM_SAC,x1,y1->b3*4-4
	.long	HUR_SAC,x1a,y1->b3*4-4
	.long	RIC_SAC,x2a,y1->b3*4-4
	.long	T_KINGS,x1b,y1a->b3*4-4

	.long	LTN_MIN,x1,y1->b3*5-4
	.long	PRS_MIN,x1a,y1->b3*5-4
	.long	RID_MIN,x2a,y1->b3*5-4
	.long	T_TWOLV,x1b,y1a->b3*5-4

	.long	0

ladder_imgs2
;4
	.long	PEE_LAK,x1,y1->b3*6-6
	.long	DIV_LAK,x1a,y1->b3*6-6
	.long	CAM_LAK,x2a,y1->b3*6-6
	.long	T_LAKS,x1b,y1a->b3*6-6

	.long	WLK_ATL,x1,y1->b3*7-6
;	.long	MAN_CLP,x1,y1->b3*7-6
	.long	HRP_CLP,x1a,y1->b3*7-6
	.long	ROB_CLP,x2a,y1->b3*7-6
	.long	T_CLIPS,x1b,y1a->b3*7-6

	.long	MCD_BOS,x1,y1->b3*8-8
	.long	BRO_BOS,x1a,y1->b3*8-8
	.long	GAM_BOS,x2a,y1->b3*8-8
	.long	T_CELTS,x1b,y1a->b3*8-8

	.long	WEA_PHL,x1,y1->b3*9-8
;	.long	BRA_PHL,x1a,y1->b3*9-8
	.long	BRA_PHL,x2a,y1->b3*9-8
	.long	HRN_PHL,x2a+400,y1->b3*9-8
	.long	T_76RS,x1b,y1a->b3*9-8

	.long	0

ladder_imgs3
;4
	.long	MIL_IND,x1,y1->b3*10-10
	.long	SMI_IND,x1a,y1->b3*10-10
	.long	SEL_IND,x2a,y1->b3*10-10
	.long	T_PACER,x1b,y1a->b3*10-10

	.long	COL_NEJ,x1,y1->b3*11-10
	.long	AND_NEJ,x1a,y1->b3*11-10
	.long	MOR_NEJ,x2a,y1->b3*11-10
	.long	T_NETS,x1b,y1a->b3*11-10

	.long	PRC_CLE,x1,y1->b3*12-12
	.long	DAU_CLE,x1a,y1->b3*12-12
	.long	NAN_CLE,x2a,y1->b3*12-12
	.long	T_CAVS,x1b,y1a->b3*12-12

	.long	MUT_DEN,x1,y1->b3*13-12
	.long	ELL_DEN,x1a,y1->b3*13-12
	.long	ROG_DEN,x2a,y1->b3*13-12
	.long	T_NUGS,x1b,y1a->b3*13-12

	.long	0

ladder_imgs4
;4
	.long	HRD_GLD,x1,y1->b3*14-14
	.long	MUL_GLD,x1a,y1->b3*14-14
	.long	WEB_GLD,x2a,y1->b3*14-14
	.long	T_WARS,x1b,y1a->b3*14-14

	.long	DRX_PRT,x1,y1->b3*15-14
	.long	POR_PRT,x1a,y1->b3*15-14
	.long	ROB_PRT,x2a,y1->b3*15-14
	.long	T_BLAZ,x1b,y1a->b3*15-14

	.long	RCE_MIA,x1,y1->b3*16-16
	.long	SKL_MIA,x1a,y1->b3*16-16
	.long	MIN_MIA,x2a,y1->b3*16-16
	.long	T_HEAT,x1b,y1a->b3*16-16

	.long	JON_CHA,x1,y1->b3*17-16
	.long	HWK_CHA,x1a,y1->b3*17-16
	.long	MOU_CHA,x2a,y1->b3*17-16
	.long	T_HORS,x1b,y1a->b3*17-16

	.long	0

ladder_imgs5
;4
	.long	SKL_ORL,x1,y1->b3*18-18
	.long	HAR_ORL,x1a,y1->b3*18-18
	.long	AND_ORL,x2a,y1->b3*18-18
	.long	T_MAGIC,x1b,y1a->b3*18-18

	.long	ROB_SAN,x1,y1->b3*19-18
	.long	ROD_SAN,x1a,y1->b3*19-18
	.long	ELS_SAN,x2a,y1->b3*19-18
	.long	T_SPURS,x1b,y1a->b3*19-18

	.long	MLN_UTA,x1,y1->b3*20-20
	.long	STK_UTA,x1a,y1->b3*20-20
	.long	BEN_UTA,x2a,y1->b3*20-20
	.long	T_JAZZ,x1b,y1a->b3*20-20

	.long	EWG_NEY,x1,y1->b3*21-20
	.long	MAS_NEY,x1a,y1->b3*21-20
	.long	STA_NEY,x2a,y1->b3*21-20
	.long	T_KNIKS,x1b,y1a->b3*21-20

	.long	0

ladder_imgs6
;4
	.long	MAN_CLP,x1,y1->b3*22-22
;	.long	WLK_ATL,x1,y1->b3*22-22
	.long	AUG_ATL,x1a,y1->b3*22-22
	.long	WLS_ATL,x2a,y1->b3*22-22
	.long	T_HAWKS,x1b,y1a->b3*22-22

	.long	BRK_PHX,x1,y1->b3*23-22
	.long	MAJ_PHX,x1a,y1->b3*23-22
	.long	JOH_PHX,x2a,y1->b3*23-22
	.long	T_SUNS,x1b,y1a->b3*23-22

	.long	OLA_HOU,x1,y1->b3*24-24
	.long	MAX_HOU,x1a,y1->b3*24-24
;	.long	ELL_DET,x2a,y1->b3
;	.long	ELL_DET,x2a,y1->b3*24-24
	.long	HOR_HOU,x2a,y1->b3*24-24
	.long	T_ROCKS,x1b,y1a->b3*24-24

	.long	KMP_SEA,x1,y1->b3*25-24
	.long	PAY_SEA,x1a,y1->b3*25-24
	.long	GIL_SEA,x2a,y1->b3*25-24
	.long	T_SONICS,x1b,y1a->b3*25-24


	.long	0


#*****************************************************************************
* a8  = sleep time
* a9  = palette to change
* a10 = * palette list
* a11 = * morf pal ram


START_PAL	equ	PDATA
CUR_PAL		equ	PDATA+20h
PAL_ADDR	equ	PDATA+40h
MORF_PAL	equ	PDATA+60h
SLEEP_TIME	equ	PDATA+80h

 SUBR	morf_pal


	move	a8,*a13(SLEEP_TIME)
	move	a10,*a13(START_PAL),L
	move	a10,*a13(CUR_PAL),L
	move	a11,*a13(MORF_PAL),L

#wait
	SLEEPK	1

	move	a9,a0
	calla	pal_find
	jrz	#wait
	srl	8,a0
	sll	8,a0
	move	a0,*a13(PAL_ADDR),L

	move	*a13(MORF_PAL),a1,L
	move	*a10,a2,L
	move	*a2+,a3		;num colours
#loop
	move	*a2+,*a1+
	dsj	a3,#loop

;	SLEEP	4
	move	*a13(SLEEP_TIME),a10
#dly1
	SLEEPK	1
	dsj	a10,#dly1
#next_pal

	move	*a13(CUR_PAL),a10,L
	addi	20h,a10
	move	*a10,a0,L
	jrn	#ok
	jrz	#not_sleep

	move	a10,*a13(CUR_PAL),L
	move	a0,a10
	jruc	#dly1

#not_sleep
	move	*a13(START_PAL),a10,L
#ok
	move	a10,*a13(CUR_PAL),L

#again
;	SLEEP	2
	move	*a13(SLEEP_TIME),a10
	srl	1,a10
	jrnz	#dly2
	movk	1,a10
#dly2
	SLEEPK	1
	dsj	a10,#dly2


	move	*a13(MORF_PAL),a1,L
	move	*a13(CUR_PAL),a10,L
	move	*a10,a2,L
	move	*a2+,a0			;num colours
	clr	a11
#morfit
	move	*a1,a3			;CURRENT PALETTE
	movi	0111110000000000b,a4	;5 bits of red
	and	a3,a4
	movi	0000001111100000b,a5	;5 bits of green
	and	a3,a5
	movi	0000000000011111b,a6	;5 bits of blue
	and	a3,a6

	move	*a2+,a7			;DEST PALETTE
	movi	0111110000000000b,a8	;5 bits of red
	and	a7,a8
	movi	0000001111100000b,a9	;5 bits of green
	and	a7,a9
	movi	0000000000011111b,a10	;5 bits of blue
	and	a7,a10

	srl	10,a4
	srl	10,a8
	cmp	a4,a8			;a8-a4
	jreq	#redok
	jrlt	#decr
	inc	a11
	inc	a4
	jruc	#redok
#decr
	inc	a11
	dec	a4
#redok
	sll	10,a4

	srl	5,a5
	srl	5,a9
	cmp	a5,a9
	jreq	#greenok
	jrlt	#decg
	inc	a11
	inc	a5
	jruc	#greenok
#decg
	inc	a11
	dec	a5
#greenok
	sll	5,a5

	cmp	a6,a10
	jreq	#blueok
	jrlt	#decb
	inc	a11
	inc	a6
	jruc	#blueok
#decb
	inc	a11
	dec	a6
#blueok

	or	a5,a4
	or	a6,a4
	move	a4,*a1+

	dsj	a0,#morfit

	move	*a13(CUR_PAL),a0,L	;* palette list
	move	*a0,a0,L		;* palette
	move	*a0,a2			;num colours
	move	*a13(MORF_PAL),a0,L	;* palette
	move	*a13(PAL_ADDR),a1,L	;dest palette
	calla	pal_set

	move	a11,a11
	jrnz	#again

	jruc	#next_pal

	DIE


;	movi	GREENPAL,a0	;* palette
;	move	*a0+,a2		;num colours
;	move	a10,a1		;dest palette
;	calla	pal_set

#*****************************************************************************
*
* RETURN:	a0 = start button bits
*-----------------------------------------------------------------------------

 SUBR	get_all_starts_down

	clr	a1

	move	@PSTATUS,a2

	btst	0,a2
	jrz	#no_player1
	clr	a0			;player 1
	calla	get_start_down
	or	a0,a1
#no_player1

	btst	1,a2
	jrz	#no_player2
	movk	1,a0			;player 2
	calla	get_start_down
	or	a0,a1
#no_player2

	btst	2,a2
	jrz	#no_player3
	movk	2,a0			;player 3
	calla	get_start_down
	or	a0,a1
#no_player3

	btst	3,a2
	jrz	#no_player4
	movk	3,a0			;player 4
	calla	get_start_down
	or	a0,a1
#no_player4

	move	a1,a0
	rets

#*****************************************************************************
*
* RETURN:	a0 = start bit
*-----------------------------------------------------------------------------

 SUBR	get_start_down

	sll	4,a0			;x 16 bits
	addi	start_offs,a0
	move	*a0,a0
	addi	switches_down,a0
	move	*a0,a0
	andi	1,a0
	rets


	.if	TUNIT
start_offs	.word	12h,15h,19h,1ah
	.else
start_offs	.word	12h,15h,17h,27h
	.endif

#*****************************************************************************
*
* RETURN:	a0 = start bit
*-----------------------------------------------------------------------------

 SUBR	get_start_cur

	sll	4,a0			;x 16 bits
	addi	start_offs,a0
	move	*a0,a0
	addi	switches_cur,a0
	move	*a0,a0
	andi	1,a0
	rets

#*****************************************************************************

 SUBR	get_team1_turbo

	clr	a1

	move	@PSTATUS,a2

	btst	0,a2
	jrz	#no_player1
	clr	a0			;player 1
	calla	get_turbo_down
	or	a0,a1
#no_player1

	btst	1,a2
	jrz	#no_player2
	movk	1,a0			;player 2
	calla	get_turbo_down
	or	a0,a1
#no_player2
	move	a1,a0

	rets

#*****************************************************************************

 SUBR	get_team2_turbo

	clr	a1

	move	@PSTATUS,a2

	btst	2,a2
	jrz	#no_player1
	movk	2,a0			;player 3
	calla	get_turbo_down
	or	a0,a1
#no_player1

	btst	3,a2
	jrz	#no_player2
	movk	3,a0			;player 4
	calla	get_turbo_down
	or	a0,a1
#no_player2
	move	a1,a0

	rets

#*****************************************************************************
*
* RETURN:	a0 = start bit
*-----------------------------------------------------------------------------

 SUBR	get_turbo_down

	sll	4,a0			;x 16 bits
	addi	turbo_offs,a0
	move	*a0,a0
	addi	switches_down,a0
	move	*a0,a0
	andi	1,a0
	rets


	.if	TUNIT
turbo_offs	.word	06h,0eh,26h,2eh
	.else
turbo_offs	.word	12h,15h,17h,27h
	.endif

#*****************************************************************************
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_all_sticks_cur

	clr	a1

	move	@PSTATUS,a2

	btst	0,a2
	jrz	#no_player1
	clr	a0			;player 1
	calla	get_stick_val_cur
	or	a0,a1
#no_player1

	btst	1,a2
	jrz	#no_player2
	movk	1,a0			;player 2
	calla	get_stick_val_cur
	or	a0,a1
#no_player2

	btst	2,a2
	jrz	#no_player3
	movk	2,a0			;player 3
	calla	get_stick_val_cur
	or	a0,a1
#no_player3

	btst	3,a2
	jrz	#no_player4
	movk	3,a0			;player 4
	calla	get_stick_val_cur
	or	a0,a1
#no_player4

	move	a1,a0
	rets


#*****************************************************************************
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_all_sticks_cur2

	clr	a1

	clr	a0			;player 1
	calla	get_stick_val_cur
	or	a0,a1

	movk	1,a0			;player 2
	calla	get_stick_val_cur
	or	a0,a1

	movk	2,a0			;player 3
	calla	get_stick_val_cur
	or	a0,a1

	movk	3,a0			;player 4
	calla	get_stick_val_cur
	or	a0,a1

	move	a1,a0
	rets


#*****************************************************************************
*
* INPUT:	a0 = player number (0-3)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_stick_val_cur


	sll	4,a0			;x 16 bits
	addi	joy_offs,a0
	move	*a0,a0
	addi	switches_cur,a0
	move	*a0,a0
	andi	01111b,a0
	rets


#*****************************************************************************
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_all_sticks_down

	clr	a1

	move	@PSTATUS,a2

	btst	0,a2
	jrz	#no_player1
	clr	a0			;player 1
	calla	get_stick_val_down
	or	a0,a1
#no_player1

	btst	1,a2
	jrz	#no_player2
	movk	1,a0			;player 2
	calla	get_stick_val_down
	or	a0,a1
#no_player2

	btst	2,a2
	jrz	#no_player3
	movk	2,a0			;player 3
	calla	get_stick_val_down
	or	a0,a1
#no_player3

	btst	3,a2
	jrz	#no_player4
	movk	3,a0			;player 4
	calla	get_stick_val_down
	or	a0,a1
#no_player4

	move	a1,a0
	rets


#*****************************************************************************
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_all_sticks_down2

	clr	a1

	clr	a0			;player 1
	calla	get_stick_val_down
	or	a0,a1

	movk	1,a0
	calla	get_stick_val_down
	or	a0,a1

	movk	2,a0
	calla	get_stick_val_down
	or	a0,a1

	movk	3,a0
	calla	get_stick_val_down
	or	a0,a1
	move	a1,a0

	rets


******************************************************************************
*
* INPUT:	a0 = player number (0-3)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_stick_val_down

	sll	4,a0			;x 16 bits
	addi	joy_offs,a0
	move	*a0,a0
	addi	switches_down,a0
	move	*a0,a0
	andi	01111b,a0
	rets

	.if	TUNIT
joy_offs	.word	00h,08h,20h,28h
	.else
joy_offs	.word	00h,08h,18h,20h
	.endif

#*****************************************************************************
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_all_buttons_cur

	clr	a1

	move	@PSTATUS,a2

	btst	0,a2
	jrz	#no_player1
	clr	a0			;player 1
	calla	get_but_val_cur
	or	a0,a1
#no_player1

	btst	1,a2
	jrz	#no_player2
	movk	1,a0			;player 2
	calla	get_but_val_cur
	or	a0,a1
#no_player2

	btst	2,a2
	jrz	#no_player3
	movk	2,a0			;player 3
	calla	get_but_val_cur
	or	a0,a1
#no_player3

	btst	3,a2
	jrz	#no_player4
	movk	3,a0			;player 4
	calla	get_but_val_cur
	or	a0,a1
#no_player4

	move	a1,a0
	rets


#*****************************************************************************
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

  SUBR	get_all_buttons_cur2

	clr	a1
	clr	a0			;player 1
	calla	get_but_val_cur
	or	a0,a1
	movk	1,a0			;player 2
	calla	get_but_val_cur
	or	a0,a1
	movk	2,a0			;player 3
	calla	get_but_val_cur
	or	a0,a1
	movk	3,a0			;player 4
	calla	get_but_val_cur
	or	a0,a1
	move	a1,a0
	rets


#*****************************************************************************
*
* INPUT:	a0 = player number (0-3)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = button bits
*-----------------------------------------------------------------------------

 SUBR	get_but_val_cur

	sll	4,a0			;x 16 bits
	addi	but_offs,a0
	move	*a0,a0
	addi	switches_cur,a0
	move	*a0,a0
	andi	0111b,a0
	rets

#*****************************************************************************
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

 SUBR	get_all_buttons_down

	clr	a1

	move	@PSTATUS,a2

	btst	0,a2
	jrz	#no_player1
	clr	a0			;player 1
	calla	get_but_val_down
	or	a0,a1
#no_player1

	btst	1,a2
	jrz	#no_player2
	movk	1,a0			;player 2
	calla	get_but_val_down
	or	a0,a1
#no_player2

	btst	2,a2
	jrz	#no_player3
	movk	2,a0			;player 3
	calla	get_but_val_down
	or	a0,a1
#no_player3

	btst	3,a2
	jrz	#no_player4
	movk	3,a0			;player 4
	calla	get_but_val_down
	or	a0,a1
#no_player4

	move	a1,a0
	rets


#*****************************************************************************
*
* RETURN:	a0 = joy switch bits
*-----------------------------------------------------------------------------

 SUBR	get_all_buttons_down2

	clr	a1
	clr	a0			;player 1
	calla	get_but_val_down
	or	a0,a1
	movk	1,a0			;player 2
	calla	get_but_val_down
	or	a0,a1
	movk	2,a0			;player 3
	calla	get_but_val_down
	or	a0,a1
	movk	3,a0			;player 4
	calla	get_but_val_down
	or	a0,a1
	move	a1,a0
	rets


******************************************************************************
*
* INPUT:	a0 = player number (0-3)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = button bits
*-----------------------------------------------------------------------------

 SUBR	get_but_val_down

	sll	4,a0			;x 16 bits
	addi	but_offs,a0
	move	*a0,a0
	addi	switches_down,a0
	move	*a0,a0
	andi	0111b,a0
	rets

	.if	TUNIT
but_offs	.word	04h,0ch,24h,2ch
	.else
but_offs	.word	04h,0ch,1ch,24h
	.endif

******************************************************************************
*
* INPUT:	a0 = player number (0-3)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = button bits
*-----------------------------------------------------------------------------

 SUBR	get_but_val_down_nt		;masks out turbo button

	sll	4,a0			;x 16 bits
	addi	but_offs,a0
	move	*a0,a0
	addi	switches_down,a0
	move	*a0,a0
;	andi	011b,a0			;mask out turbo
	andi	01b,a0			;mask out turbo and pass
	rets

******************************************************************************
*
* INPUT:	a0 = player number (0-3)
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = button bits
*-----------------------------------------------------------------------------

 SUBR	get_steal_but_cur

	sll	4,a0			;x 16 bits
	addi	but_offs,a0
	move	*a0,a0
	addi	switches_cur,a0
	move	*a0,a0
	andi	010b,a0			;mask out turbo & shoot
	rets

#*****************************************************************************

	.asg	330,X1		;89,X1
	.asg	330,X2		;307,X2
	.asg	207,Y
	.asg	217,Y2

 SUBR	result_screen

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	clr	a0
	move	a0,@IRQSKYE		;background color
;	movi	4<<10+4<<5+7,a0
;	move	a0,@IRQSKYE

	SLEEPK	1

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	result_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	clr	a10
	movk	16,a11
	CREATE0	fade_up

	movk	1,a0
	calla	create_player_heads
	calla	update_player_heads
	calla	update_player_heads
	movk	1,a0
	calla	create_logos
	calla	update_logos

	CREATE0	final_scores

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	SLEEP	1*TSEC

	movi	7*TSEC,a10
#lp	SLEEPK	1
	calla	get_all_buttons_cur2
	jrz	#nob
      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	.ref	SOUNDSUP
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#xb
#nob	
	dsj	a10,#lp
#xb
	clr	a10
	movk	16,a11
	CREATE0	fade_down

	SLEEP	18h

	RETP

bounce_snd	.word	>fc80,10,>8129,0	;Ball bounce

#*****************************************************************************

	.if	0

 SUBRP	score_shadow

#SHAD1	equ	PDATA
#SHAD2	equ	#SHAD1+20h

	.asg	40,X1
	.asg	257,X2
	.asg	205,Y

	movi	[X1,0],a0		;x val
	movi	[Y,0],a1		;y val
	movi	scorshad1,a2		;* image
	movi	300,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ
	move	a8,*a13(#SHAD1),L

	movi	[X2,0],a0		;x val
	movi	[Y,0],a1		;y val
	movi	scorshad1,a2		;* image
	movi	300,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ
	move	a8,*a13(#SHAD2),L

	clr	a10
#big_mac
	SLEEPK	1
	xori	1,a10

	move	a10,a0
	sll	5,a0			;x 32 bits
	addi	#shadows,a0
	move	*a0,a11,L		;* image

	move	*a13(#SHAD1),a8,L
	calla	#change_shad
	move	*a13(#SHAD2),a8,L
	calla	#change_shad

	jruc	#big_mac

#change_shad
	move	a11,a0
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image
	rets


#shadows

	.long	scorshad1,scorshad2

	.endif

#*****************************************************************************

 SUBRP	final_scores

	.asg	3ah,X1
	.asg	320,XF
	.asg	>d7,Y1
	.asg	>e6,Y2

;Display cities first

	movi	[X1,0],a0		;x val
	movi	[Y1,0],a1		;y val

	move	@team1,a2
	sll	5,a2
	addi	city_tbl,a2
	move	*a2,a2,L

	movi	300,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ

	movi	SGMD8YEL,a0
	calla	pal_getf
	move	a0,*a8(OPAL)

	movi	[X1,0],a0		;x val
	movi	[Y2,0],a1		;y val

	move	@team2,a2
	sll	5,a2
	addi	city_tbl,a2
	move	*a2,a2,L

	movi	300,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ

	movi	SGMD8YEL,a0
	calla	pal_getf
	move	a0,*a8(OPAL)

;Print final score

	movi	#score_setup,a2
	calla	setup_message
	move	@scores,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_C

	move	@scores+10h,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	Y2-1,a0
	move	a0,@mess_cursy
	calla	print_string_C

;Print 1st quarter

	move	@kp_qscrs2,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	>a0,a0
	move	a0,@mess_cursx
	movi	Y1-1,a0
	move	a0,@mess_cursy
	calla	print_string_C

	move	@kp_qscrs2+16,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	>a0,a0
	move	a0,@mess_cursx
	movi	Y2-1,a0
	move	a0,@mess_cursy
	calla	print_string_C

;Print 2nd quarter

	move	@kp_qscrs2+32,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	>c8,a0
	move	a0,@mess_cursx
	movi	Y1-1,a0
	move	a0,@mess_cursy
	calla	print_string_C

	move	@kp_qscrs2+48,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	>c8,a0
	move	a0,@mess_cursx
	movi	Y2-1,a0
	move	a0,@mess_cursy
	calla	print_string_C

;Print 3rd quarter

	move	@kp_qscrs2+64,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	>f0,a0
	move	a0,@mess_cursx
	movi	Y1-1,a0
	move	a0,@mess_cursy
	calla	print_string_C

	move	@kp_qscrs2+80,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	>f0,a0
	move	a0,@mess_cursx
	movi	Y2-1,a0
	move	a0,@mess_cursy
	calla	print_string_C

;Print 4th quarter

	move	@kp_qscrs2+96,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	>118,a0
	move	a0,@mess_cursx
	movi	Y1-1,a0
	move	a0,@mess_cursy
	calla	print_string_C

	move	@kp_qscrs2+112,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	>118,a0
	move	a0,@mess_cursx
	movi	Y2-1,a0
	move	a0,@mess_cursy
	calla	print_string_C

	DIE

#score_setup
	RJR_STR	osgmd8_ascii,8,0,XF,Y1-1,SGMD8WHT,0


#*****************************************************************************

 SUBR	matchup_screen

	movk	1,a0
	move	a0,@inmatchup

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	clr	a0
	move	a0,@IRQSKYE		;background color
;	movi	4<<10+4<<5+7,a0
;	move	a0,@IRQSKYE

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	matchup_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movk	1,a0
	calla	create_player_heads
	calla	update_player_heads
	calla	update_player_heads
	movk	1,a0
	calla	create_logos
	calla	update_logos

	calla	get_teams_pop
	calla	print_ranking

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	CREATE0	call_matchup
	.ref	flash_plyr_wht
	CREATE0	flash_plyr_wht

	SLEEP	TSEC*3

	movi	3*TSEC,a10
#delay
	SLEEPK	1
	calla	get_all_buttons_cur
	jrnz	#exit
	dsj	a10,#delay
#exit

	RETP

matchup_mod
	.long	matchupBMOD		;matchup screen
	.word	0,0
	.long	0

result_mod
	.long	finalBMOD		;final result screen
	.word	0,0
	.long	0


#******************************************************************************
; a10 = sleep count

	.asg	200-2,X
	.asg	80,Y

#restart
	calla	DELOBJA8

 SUBR	timeout

	clr	a0
	move	a0,@force_selection

	move	a10,a11
#wait
	SLEEPK	1
	dsj	a11,#wait

	movi	LGMDRED2,b0
	movi	[X,0],a0			;x val
	movi	[Y,0],a1			;y val
	movi	lgmd_9,a2			;* image
	movi	30001,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	TYPTEXT,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP2
	calla	#center_image

	move	@PSTATUS,a9

	movi	9,a11
#loop
	SOUND1	cntdown_snd

	SLEEP	TSEC+25

	move	@PSTATUS,a0		;if player buys in
	cmp	a9,a0			;then restart timer
	jrne	#restart

	calla	obj_off

	SOUND1	cntdown_snd

	SLEEP	(1*TSEC)/2

	move	@PSTATUS,a0
	cmp	a9,a0
	jrne	#restart

	calla	obj_on
	move	a11,a0
	sll	5,a0
	addi	#nums-20h,a0
	move	*a0,a0,L		;* image
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	calla	#center_image

	dsj	a11,#loop

	SOUND1	cntdown_snd

	SLEEP	(1*TSEC+25)/2

	movk	1,a0
	move	a0,@force_selection

	calla	DELOBJA8
	DIE


#center_image
	move	*a8(OSIZEX),a0
	srl	1,a0
	movi	X,a1
	sub	a0,a1
	move	a1,*a8(OXPOS)
	rets


#nums	.long	lgmd_0,lgmd_1,lgmd_2
	.long	lgmd_3,lgmd_4,lgmd_5
	.long	lgmd_6,lgmd_7,lgmd_8,lgmd_9

#******************************************************************************
; a10 = sleep count

	.asg	200-2,X
	.asg	80,Y

#restart
	PULLP	a0
	calla	DELOBJA8

 SUBR	timeout2

	clr	a0
	move	a0,@force_selection

	move	a10,a11
#wait
	SLEEPK	1
	dsj	a11,#wait

	movi	LGMDRED2,b0
	movi	[X,0],a0			;x val
	movi	[Y,0],a1			;y val
	movi	lgmd_9,a2			;* image
	movi	30001,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	TYPTEXT,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP2
	calla	#center_image

	move	@PSTATUS,a9

	movi	9,a0
#loop
	PUSHP	a0

	SOUND1	cntdown_snd

	movi	TSEC+25,a11
#loop2
	SLEEPK	1
	calla	get_all_starts_down
	jrnz	#xit1
	dsj	a11,#loop2
#xit1

	SOUND1	cntdown_snd

	move	@PSTATUS,a0		;if player buys in
	cmp	a9,a0			;then restart timer
	jrne	#restart

	calla	obj_off

	movi	(1*TSEC)/2,a11
#loop3
	SLEEPK	1
	calla	get_all_starts_down
	jrnz	#xit2
	dsj	a11,#loop3
#xit2

	move	@PSTATUS,a0
	cmp	a9,a0
	jrne	#restart

	calla	obj_on
	PULLP	a0
	PUSHP	a0
	sll	5,a0
	addi	#nums-20h,a0
	move	*a0,a0,L		;* image
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	calla	#center_image

	PULLP	a0
	dsj	a0,#loop

	SOUND1	cntdown_snd

	movi	(1*TSEC+25)/2,a11
#loop4
	SLEEPK	1
	calla	get_all_starts_down
	jrnz	#xit3
	dsj	a11,#loop4
#xit3
	SOUND1	cntdown_snd

	movk	1,a0
	move	a0,@force_selection

	calla	DELOBJA8
	DIE


#center_image
	move	*a8(OSIZEX),a0
	srl	1,a0
	movi	X,a1
	sub	a0,a1
	move	a1,*a8(OXPOS)
	rets


#nums	.long	lgmd_0,lgmd_1,lgmd_2
	.long	lgmd_3,lgmd_4,lgmd_5
	.long	lgmd_6,lgmd_7,lgmd_8,lgmd_9

#******************************************************************************
; a10 = sleep count

	.asg	200-2,X
	.asg	80,Y

 SUBR	timeout3

	clr	a0
	move	a0,@force_selection

	.ref	BTIME
	move	a0,@BTIME

;	move	a10,a11
;#wait
;	SLEEPK	1
;
;	move	@BTIME,a0
;	jrnz	#reset
;
;	dsj	a11,#wait

	movi	LGMDRED2,b0
	movi	[X,0],a0			;x val
	movi	[Y,0],a1			;y val
	movi	lgmd_9,a2			;* image
	movi	30001,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	TYPTEXT,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP2
	calla	#center_image

	move	@PSTATUS,a9

	movi	9,a0
#loop
	PUSHP	a0

	SOUND1	cntdown_snd

	SLEEPK	3
	movi	TSEC+25-3,a11
#loop2
	SLEEPK	1

	move	@BTIME,a0
	jrnz	#reset

;	calla	get_all_buttons_down2
	calla	get_all_buttons_cur2
	jrnz	#xit1
	dsj	a11,#loop2
#xit1

	SOUND1	cntdown_snd

	calla	obj_off

	SLEEPK	2
	movi	(1*TSEC)/2-3,a11
#loop3
	SLEEPK	1

	move	@BTIME,a0
	jrnz	#reset

;	calla	get_all_buttons_down2
	calla	get_all_buttons_cur2
	jrnz	#xit2
	dsj	a11,#loop3
#xit2

	calla	obj_on
	PULLP	a0
	PUSHP	a0
	sll	5,a0
	addi	#nums-20h,a0
	move	*a0,a0,L		;* image
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	calla	#center_image

	PULLP	a0
	dsj	a0,#loop

	SOUND1	cntdown_snd

	SLEEPK	3
	movi	(1*TSEC+25)/2-3,a11
#loop4
	SLEEPK	1

	move	@BTIME,a0
	jrnz	#reset

;	calla	get_all_buttons_down2
	calla	get_all_buttons_cur2
	jrnz	#xit3
	dsj	a11,#loop4
#xit3

	SOUND1	cntdown_snd

	movk	1,a0
	move	a0,@force_selection

	calla	DELOBJA8
	DIE

#reset
	clr	a0
	move	a0,@BTIME
	movi	TSEC,a10
	CREATE0	timeout3
	calla	DELOBJA8
	SOUND1	cntdown_snd
	DIE


#center_image
	move	*a8(OSIZEX),a0
	srl	1,a0
	movi	X,a1
	sub	a0,a1
	move	a1,*a8(OXPOS)
	rets


#nums	.long	lgmd_0,lgmd_1,lgmd_2
	.long	lgmd_3,lgmd_4,lgmd_5
	.long	lgmd_6,lgmd_7,lgmd_8,lgmd_9

#******************************************************************************
*
* a3  = * player data
* a10 = player number (0-3)
* sets special_heads based on initials entered

 SUBR	check_initials

	sll	4,a10				;x 16
	addi	special_heads,a10

	clr	a5

	movi	#team_inits,a2

#next
	move	*a3(PR_INIT1),a0
	jrn	#no_match
	move	*a2,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a3(PR_INIT2),a0
	move	*a2(10h),a1
	cmp	a0,a1
	jrne	#no_match

	move	*a3(PR_INIT3),a0
	move	*a2(20h),a1
	cmp	a0,a1
	jrne	#no_match

	move	*a3(PR_MONTH),a0
	inc	a0
	move	*a2(30h),a1
	cmp	a0,a1
	jrne	#no_match

	move	*a3(PR_DAY),a0
	inc	a0
	move	*a2(40h),a1
	cmp	a0,a1
	jrne	#no_match

	movk	ADJTOURNEY,a0		;Tournament mode?
	calla	GET_ADJ			;0-1
	jrz	#yes			;On? Br=yes

	move	a5,*a10			;special head number
	move	a5,a0
	sll	6,a0			;x 16 x 4
	addi	#team_snds,a0
	calla	speech_playovrp
#yes
	rets
	

#no_match
	addi	50h,a2
	inc	a5
	cmpi	69,a5
	jrlt	#next

	rets


#team_inits
	.word	'T'-'0','W'-'A','G'-'A'	,12,07	;0  GOSKIE
	.word	'R'-'0','J'-'A','R'-'A'	,01,17	;1  RIVETT
	.word	'J'-'0','M'-'A','C'-'A'	,08,05	;2  CARLTON
	.word	'S'-'0','A'-'A','L'-'A'	,02,01	;3  DIVITA
	.word	'S'-'0','L'-'A',26	,06,24	;4  LIPTAK
	.word	'M'-'0','J'-'A','T'-'A'	,03,22	;5  TURMELL
	.word	'J'-'0','W'-'A','H'-'A'	,09,20	;6  HEY
	.word	'G'-'0','N'-'A','P'-'A'	,10,08	;7  PETRO
	.word	'J'-'0','R'-'A','N'-'A'	,06,18	;8  NEWCOMER
	.word	'S'-'0','N'-'A','O'-'A'	,01,03	;9  OURSLER
	.word	'A'-'0','M'-'A','L'-'A'	,08,31	;10 LASKO
	.word	'W'-'0','I'-'A','L'-'A'	,01,01	;11 MORRIS 
	.word	'C'-'0','M'-'A','M'-'A'	,07,02	;12 MEDNICK
	.word	'D'-'0','W'-'A','F'-'A'	,09,28	;13 FORDEN
	.word	'D'-'0','I'-'A','E'-'A'	,01,01	;14 KINKEAD		*;2/23
	.word	'E'-'0','P'-'A','J'-'A'	,01,27	;15 JARVIS	
	.word	'S'-'0','U'-'A','B'-'A'	,11,05	;16 SUBZ	
	.word	'J'-'0','E'-'A','H'-'A'	,07,13	;17 HAEGER	
	.word	'J'-'0','M'-'A','S'-'A'	,02,22	;18 SIMPSON
	.word	'J'-'0','D'-'A','G'-'A'	,05,31	;19 GREEN	
	.word	'J'-'0','P'-'A','G'-'A'	,01,23	;20 GENTILE
	.word	'J'-'0','P'-'A','D'-'A'	,06,03	;21 DILLON
	.word	'J'-'0','M'-'A','L'-'A'	,11,04	;22 LOWES
	.word	'V'-'0','O'-'A','G'-'A'	,06,27	;23 VOGEL	
	.word	'J'-'0','Y'-'A','T'-'A'	,11,28	;24 TSUI
	.word	'V'-'0','L'-'A','K'-'A'	,11,09	;25 DEMAR/KAMM
	.word	'L'-'0','T'-'A','D'-'A'	,04,30	;26 DEAL
	.word	'M'-'0','V'-'A','B'-'A'	,04,18	;27 BOOTY
	.word	'M'-'0','L'-'A',26	,05,25	;28 LOFFRE
	.word	'M'-'0','D'-'A','P'-'A'	,01,13	;29 PENACHO
	.word	'P'-'0','C'-'A','B'-'A'	,05,09	;30 BARKER
	.word	'P'-'0','G'-'A','C'-'A'	,04,11	;31 COX
	.word	'R'-'0','A'-'A','D'-'A'	,07,09	;32 RAIDEN
	.word	'B'-'0','I'-'A','G'-'A'	,09,31	;33 REAPER			
	.word	'R'-'0','E'-'A','M'-'A'	,03,26	;34 MACIKA
	.word	'R'-'0','O'-'A','G'-'A'	,08,01	;35 SHARPE
	.word	'S'-'0','A'-'A','B'-'A'	,08,29	;36 BERAN		
	.word	'T'-'0','J'-'A','C'-'A'	,10,11	;37 COMAN		
	.word	'K'-'0','N'-'A','G'-'A'	,03,26	;38 KONGO
	.word	'V'-'0','J'-'A','P'-'A'	,04,11	;39 PONTAREL	
	.word	'E'-'0','L'-'A','V'-'A'	,01,08	;40 ELVIS		
	.word	'W'-'0','B'-'A','D'-'A'	,08,17	;41 DAVIS
	.word	'E'-'0','J'-'A','B'-'A'	,02,22	;42 BOON			
	.word	'T'-'0','O'-'A','B'-'A'	,08,24	;43 TOBIAS		
	.word	'W'-'0','M'-'A','N'-'A'	,11,11	;44 HEITSCH
	.word	'D'-'0','O'-'A','Z'-'A'	,12,31	;45 DABEL
	.word	'M'-'0','A'-'A','M'-'A'	,08,07	;46 MARTINEZ
	.word	'R'-'0','J'-'A','D'-'A'	,09,03	;47 DAVIES		
	.word	'K'-'0','E'-'A','R'-'A'	,10,10	;48 HOSK		*
	.word	'L'-'0','O'-'A','R'-'A'	,02,20	;49 OLIV
	.word	'S'-'0','C'-'A','O'-'A'	,07,05	;50 SCORP
	.word	'R'-'0','P'-'A','T'-'A'	,11,10	;51 REPT
	.word	'C'-'0','G'-'A',26	,12,04	;52 GRANNER
	.word	'R'-'0','M'-'A','G'-'A'	,08,11	;53 GAY
	.word	'J'-'0','M'-'A','S'-'A'	,07,29	;54 SKILES
	.word	'J'-'0','F'-'A','L'-'A'	,04,16	;55 LINHOFF

;Superstar special guests

	.word	'D'-'A','O'-'A','M'-'A'	,04,16	;56 WILKINS
	.word	'D'-'A','E'-'A','E'-'A'	,11,29	;57 BROWN
	.word	'Z'-'A','O'-'A',26    	,02,08	;58 MOURNING
	.word	'P'-'A','I'-'A','P'-'A'	,09,25	;59 PIPPEN  
	.word	'Z'-'A','E'-'A','K'-'A'	,04,30	;60 I. THOMAS
	.word	'W'-'A','E'-'A','B'-'A'	,03,01	;61 WEBBER
	.word	'H'-'A','A'-'A','K'-'A'	,01,21	;62 OLAJUWON
	.word	'D'-'A','C'-'A',26	,06,21	;63 COLEMAN
	.word	'P'-'A','A'-'A','T'-'A'	,08,05	;64 EWING
	.word	'B'-'A','R'-'A','K'-'A'	,02,20	;65 BARKLEY
	.word	'R'-'A','O'-'A','B'-'A'	,08,06	;66 ROBINSON
	.word	'K'-'A','M'-'A','P'-'A'	,11,26	;67 KEMP
	.word	'K'-'A','R'-'A','L'-'A'	,07,24	;68 MALONE
	.word	'K'-'A','R'-'A','L'-'A'	,07,24	;68 MALONE

	
#team_snds
	.word	>f9a9,63,>81f6,0	;He scores    0  GOSKIE	
	.word	>f9a9,47,>81c8,0	;Hello!       1  RIVETT		
	.word	>f9a9,70,>819c,0	;boom shaka   2  CARLTON
	.word	>f9a9,67,>8172,0	;It's blowout 3  DIVITA
	.word	>f9a9,46,>81c2,0	;Yes!	      4  LIPTAK
	.word	>f9a1,87,>81ab,0	;whoomp       5  TURMELL
	.word	>f9a9,67,>8172,0	;It's blowout 6  HEY
	.word	>f9a9,67,>8172,0	;It's blowout 7  PETRO
	.word	>f9a9,63,>81f6,0	;He scores    8  NEWCOMER
	.word	>f9a9,100,>81d6,0	;coffin       9  OURSLER
	.word	>f9a9,47,>81c8,0	;Hello!       10 LASCO
	.word	>f9a9,70,>819c,0	;boom shak    11 MORRIS
	.word	>f9a9,47,>81c8,0	;Hello!       12 MEDNICK
	.word	>f9a9,47,>81ad,0	;shoes?       13 FORDEN	
	.word	>f9a9,47,>812b,0	;fantastic    14 KINKEAD
	.word	>f9a9,47,>81c8,0	;Hello!       15 JARVIS	
	.word	>f9a9,47,>8196,0	;	      16 SUBZ	
	.word	>f9a9,47,>81c8,0	;Hello!       17 HAEGER	
	.word	>f9a9,47,>81b7,0	;bad decision 18 SIMPSON
	.word	>f9a9,47,>81c8,0	;Hello!       19 GREEN	
	.word	>f9a9,47,>81c8,0	;Hello!       20 GENTILE
	.word	>f9a9,67,>81e0,0	;its good     21 DILLON	
	.word	>f9a9,47,>81c8,0	;Hello!       22 LOWES	
	.word	>f9a9,47,>8175,0	;bucket       23 VOGEL	
	.word	>f9a9,47,>81f0,0	;rainbow      24 TSUI	
	.word	>f9a9,47,>81c8,0	;Hello!       25 KAM		
	.word	>f9a9,47,>81c8,0	;Hello!       26 DEAL		
	.word	>f9a9,47,>81d7,0	;gotta shoot  27 BOOTY		
	.word	>f9a9,47,>81f6,0	;he scores    28 LOFFRE		
	.word	>f9a9,47,>81e8,0	;swish!       29 PENACHO	
	.word	>f9a9,47,>81e3,0	;range!       30 BARKER		
	.word	>f9a9,47,>81c8,0	;Hello!       31 COX			
	.word	>f9a9,47,>80b0,0	;	      32 RAIDEN
	.word	>f9a9,47,>81f1,0	;no good      33 REAPER		
	.word	>f9a9,47,>81c8,0	;Hello!       34 MACIKA		
	.word	>f9a9,47,>81dd,0	;wide open    35 SHARPE		
	.word	>f9a9,47,>81d9,0	;ugly shot    36 BERAN		
	.word	>f9a9,47,>8198,0	;brick!       37 COMAN		
	.word	>fda9,147,>8177,0	;tarzan       38 KONGO	
	.word	>f9a9,47,>81ce,0	;knocked      39 PONTAREL	
	.word	>f9a9,47,>81c0,0	;excuse       40 ELVIS		
	.word	>f9a9,47,>81b4,0	;no way       41 DAVIS		
	.word	>f9a9,47,>81ae,0	;kaboom       42 BOON		
	.word	>f9a9,47,>81ad,0	;shoes!       43 TOBIAS		
	.word	>f9a9,47,>8198,0	;brick        44 HEITSCH	
	.word	>f9a9,47,>81c8,0	;Hello!       45 DABEL		
	.word	>f9a9,47,>81c8,0	;Hello!       46 MARTINEZ	
	.word	>f9a9,47,>81c8,0	;Hello!       47 DAVIES		
	.word	>f9a9,47,>81ea,0	;oh my        48 HOSK		
	.word	>f9a9,47,>819d,0	;sweet        49 OLIV		
	.word	>f9a9,47,>8197,0	;	      50 SCORP		
	.word	>f9a9,47,>81a5,0	;	      51 REPT		
	.word	>f9a9,47,>81c8,0	;Hello!       52 GRANNER
	.word	>f9a9,47,>81c8,0	;Hello!       53 GAY
	.word	>f9a9,47,>81d6,0	;nail         54 SKILES
	.word	>f9a9,47,>81c8,0	;Hello!       55 LINHOFF

;Superstar special guests
	.word	>f9a9,63,>81f6,0	;He scores    56 WILKINS
	.word	>f9a9,47,>81c8,0	;Hello!       57 BROWN
	.word	>f9a9,70,>819c,0	;boom shaka   58 MOURNING
	.word	>f9a9,67,>8172,0	;It's blowout 59 PIPPEN  
	.word	>f9a9,46,>81c2,0	;Yes!	      60 I. THOMAS
	.word	>f9a1,87,>81ab,0	;whoomp       61 WEBBER
	.word	>f9a9,67,>8172,0	;It's blowout 62 OLAJUWON
	.word	>f9a9,67,>8172,0	;It's blowout 63 COLEMAN
	.word	>f9a9,63,>81f6,0	;He scores    64 EWING
	.word	>f9a9,100,>81d6,0	;coffin       65 BARKLEY
	.word	>f9a9,47,>81c8,0	;Hello!       66 ROBINSON
	.word	>f9a9,70,>819c,0	;boom shak    67 KEMP
	.word	>f9a9,47,>81c8,0	;Hello!       68 MALONE
	.word	>f9a9,47,>81c8,0	;Hello!       68 MALONE


#******************************************************************************

 SUBR	select_teams

	move	@team1,a0
	move	@team2,a1
	or	a0,a1
	move	a1,a1
	jrnn	#teams_ok		;both teams selected?

	move	@team1,a0
	jrnn	#select_team2

#select_team1
	movi	07ffffffh,a1
	move	@PSTATUS,a0
	btst	2,a0
	jrz	#nop3
	move	@player3_data+PR_INIT1,a0
	jrn	#nop3

	move	@player3_data+PR_TEAMSDEF,a0,L
	and	a0,a1
#nop3
	move	@PSTATUS,a0
	btst	3,a0
	jrz	#nop4
	move	@player4_data+PR_INIT1,a0
	jrn	#nop4

	move	@player4_data+PR_TEAMSDEF,a0,L
	and	a0,a1
#nop4

;MJT
;	movk	1,a0
;	move	@team2,a2
;	sll	a2,a0
;	or	a0,a1



	PUSH	a1
	calla	calc_num_defeated
	cmpi	27,a0
	jreq	#choose_random1

	movi	26,a1
	sub	a0,a1
	move	a1,a0
	calla	RNDRNG0
	PULL	a1
	calla	get_opponent_team

;	move	@team2,a0
;	cmp	a0,a2
;	jreq	#select_team1




	cmpi	_DAL,a2
	jrnz	#notd1
	movk	1,a0
	jruc	#yesd1
#notd1
	movk	5,a0
#yesd1




	calla	RNDRNG0
	move	a2,a14
	sll	4,a14
	addi	tm1set,a14
	move	a0,*a14
	move	a2,@team1

	jruc	#teams_ok


#choose_random1
;Opponent has beaten all the teams, give him a superstar matchup
	PULL	a1

;MJT
#choose_random1a
	movk	26,a0			;0-26
	calla	RNDRNG0
	move	a0,@team1



	move	@player3_data+PR_INIT1,a0
	jrnn	#cont1
	move	@player4_data+PR_INIT1,a0
	jrn	#teams_ok
;Someone really has beaten all the teams!
	
#cont1

	sll	4,a0
	addi	#setnum,a0
	move	*a0,a0

	move	@team1,a14
	sll	4,a14
	addi	tm1set,a14
	move	a0,*a14

;NBA Sucks!
	movi	12,a0				;68
	calla	RNDRNG0
	addi	56,a0				;0
	move	a0,@special_heads+10h

	jruc	#teams_ok

#setnum	.word	0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,3,0,0,0,3

#select_team2
	movi	07ffffffh,a1
	move	@PSTATUS,a0
	btst	0,a0
	jrz	#nop1
	move	@player1_data+PR_INIT1,a0
	jrn	#nop1

	move	@player1_data+PR_TEAMSDEF,a0,L
	and	a0,a1
#nop1
	move	@PSTATUS,a0
	btst	1,a0
	jrz	#nop2
	move	@player2_data+PR_INIT1,a0
	jrn	#nop2

	move	@player2_data+PR_TEAMSDEF,a0,L
	and	a0,a1
#nop2


;MJT
;	movk	1,a0
;	move	@team1,a2
;	sll	a2,a0
;	or	a0,a1

	PUSH	a1
	calla	calc_num_defeated
	cmpi	27,a0
	jreq	#choose_random2

	movi	26,a1
	sub	a0,a1
	move	a1,a0
	calla	RNDRNG0
	PULL	a1
	calla	get_opponent_team


;	move	@team1,a0
;	cmp	a0,a2
;	jreq	#select_team2


	cmpi	_DAL,a2
	jrnz	#notd3
	movk	1,a0
	jruc	#yesd3
#notd3
	movk	5,a0
#yesd3



	calla	RNDRNG0
	move	a2,a14
	sll	4,a14
	addi	tm2set,a14
	move	a0,*a14
	move	a2,@team2

	jruc	#teams_ok


#choose_random2
	PULL	a1

#choose_random2a
	movk	26,a0			;0-26
	calla	RNDRNG0
	move	a0,@team2


	move	@player1_data+PR_INIT1,a0
	jrnn	#cont2
	move	@player2_data+PR_INIT1,a0
	jrn	#teams_ok
;Someone really has beaten all the teams!
	
#cont2

	sll	4,a0
	addi	#setnum,a0
	move	*a0,a0

	move	@team2,a14
	sll	4,a14
	addi	tm2set,a14
	move	a0,*a14

	movi	12,a0				;68
	calla	RNDRNG0
	addi	56,a0				;0
	move	a0,@special_heads+30h

#teams_ok
	rets


team_orders
	.word	_DAL	;27
	.word	_DET	;9
	.word	_MIL	;18
	.word	_WAS	;21
	.word	_SAC	;24
	.word	_MIN	;26
	.word	_LAL	;6
	.word	_LAC	;14
	.word	_BOS	;11
	.word	_PHI	;25
	.word	_IND	;7
	.word	_NJ	;13
	.word	_CLE	;10
	.word	_DEN	;23
	.word	_GOL	;20
	.word	_POR	;3
	.word	_MI	;22
	.word	_CHA	;12
	.word	_ORL	;15
	.word	_SAN	;19
	.word	_UTA	;5
	.word	_NY	;4
	.word	_ATL	;16
	.word	_PHX	;2
	.word	_HOU	;8
	.word	_SEA	;17
	.word	_CHI	;1
	.word	-1


#******************************************************************************
*
* INPUT:	a0 = Nth undefeated team
*		a1 = teams defeated bits
* RETURN:	a2 = team number
*
*------------------------------------------------------------------------------

 SUBR	get_opponent_team


	movi	team_orders,a0
#next_team
	move	*a0+,a2			;team number (0-26)
	jrn	#err			;shouldn't happen
	btst	a2,a1			;defeated?
	jrnz	#next_team
	rets
#err
	clr	a2
	rets

 .if 0
	PUSH	a1
	clr	a2
#next_team
	srl	1,a1
	jrc	#def
;	dec	a0			;teams defeated count ++
;	jrn	#done
#def
	inc	a2
	cmpi	26,a2
	jrlo	#next_team
#done
	PULL	a1
	rets
 .endif

#*****************************************************************************

	.asg	70,Y1
	.asg	104,Y2

 SUBR	ingame_mess

#wait
	move	@PSTATUS,a0
	btst	a10,a0
	jrnz	#ingame
	SLEEPK	1
	jruc	#wait
#ingame

	movi	#initials_setup,a2
	calla	setup_message

	move	a10,a0
	sll	4,a0				;x 16 bits
	move	a0,a1
	sll	1,a0				;x 32 bits
	addi	#plyrdata,a0
	move	*a0,a4,L			;* scr initials

	movi	#init_x,a2
	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not2a
	movi	#kit_x,a2			;kit x vals
#not2a
	add	a2,a1

	move	*a1,a1
	move	a1,@mess_cursx
	movi	message_buffer,a3		;* string dest
	calla	get_initials_string
	calla	print_string_C			;centered

	move	@gmqrtr,a0
	cmpi	4,a0
	jrls	#ok
	movk	4,a0
#ok
	sll	5,a0			;x 32 bits
	addi	#qtr_msgs,a0
	move	*a0,a2,L		;* image

	sll	4,a10			;x 16 bits

	movi	#qtr_x,a3
	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not2b
	movi	#kit_x,a3			;kit x vals
#not2b
	add	a3,a10

	move	*a10,a0
	sll	16,a0			;x val
	PUSH	a0
	movi	[Y2,0],a1		;y val
	movi	1000,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPTEXT,a5		;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	movi	SGMD8BLU,b0		;pal
	calla	BEGINOBJP

	PULL	a0
	movi	[Y1,0],a1		;y val
	movi	getready,a2		;* image
	movi	1000,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPTEXT,a5		;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	movi	SGMD8BLU,b0		;pal
	calla	BEGINOBJP

	DIE

#plyrdata
	.long	player1_data+PR_INIT1
	.long	player2_data+PR_INIT1
	.long	player3_data+PR_INIT1
	.long	player4_data+PR_INIT1

#initials_setup
	RJR_STR	osgemd_ascii,8,1,200,208,BLUE,0

#qtr_msgs
	.long	_1quart,_2quart
	.long	_3quart,_4quart
	.long	overtme,overtme
	.long	overtme,overtme

#qtr_x	.word	52,149,246,342	;x val

#init_x	.word	56,145,250,339

#kit_x	.word	0,101,295,0	;kit x vals


#*****************************************************************************

 SUBR	winner_stays_on

	movi	ADJWINMODE,a0
	calla	GET_ADJ
	move	a0,a14
	jrz	#exit			;disabled?


	.ref	_4plyrsingame
	move	@_4plyrsingame,a0
	jrnz	#not_4play
;	move	@PSTATUS2,a0
;	cmpi	01111b,a0
;	jrne	#not_4play

;	movk	INHALFPRICE,a0
;	cmpi	1,a14
;	jrz	#hlf
	movk	INFREEPRICE,a0
;#hlf
	move	a0,@GAMSTATE


;Zero PxDATA areas

	clr	a0
	movi	P1DATA,a1
	movi	PDSIZE*4/16,A2
#zlp	move	a0,*a1+
	dsj	a2,#zlp

	move	a0,@conttimers,L	;4 words
	move	a0,@conttimers+20h,L

;	clr	a0
;	move	a0,@scores
;	move	a0,@scores+10h

	clr	a0
	move	a0,@PSTATUS
	move	a0,@PSTATUS2

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	clr	a0
	move	a0,@page_scrolling	;not scrolling

	movi	MAX_CRTIME,a0
	move	a0,@cntrs_delay

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	clr	a0
	move	a0,@IRQSKYE		;background color
;	movi	4<<10+4<<5+7,a0
;	move	a0,@IRQSKYE

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L




	clr	a10
	move	@scores,a0
	move	@scores+10h,a1
	cmp	a1,a0			;score2 - score1
	jrgt	#t1_wins
	movk	1,a10			;t2_wins
#t1_wins
	move	a10,@winningteam	;0 or 1




	SLEEPK	2

	movi	#winner_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	calla	blue_shadow

	movk	1,a0
	move	a0,@DISPLAYON


	CREATE0	monitor_buyins
	CREATE0	team_control

	CREATE0	credits
	CREATE0	credit_messages
	CREATE0	monitor_fullgame

	.asg	102,X1
	.asg	294,X2

	.asg	21,Y1
	.asg	42,Y2
	.asg	110,Y3

;	clr	a10
;	move	@scores,a0
;	move	@scores+10h,a1
;	cmp	a1,a0			;score2 - score1
;	jrgt	#t1_wins
;	movk	1,a10			;t2_wins
;#t1_wins
;	move	a10,@winningteam	;0 or 1
;

	move	a10,a0
	sll	4,a0
	addi	#xpos,a0
	move	*a0,a11

	move	a11,a0				;x val
	sll	16,a0
	movi	[Y1,0],a1			;y val
	movi	congrats_l,a2			;* image
	movi	19001,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	TYPTEXT,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2


	move	a11,a0				;x val
	sll	16,a0
	movi	[Y3,0],a1			;y val
	movi	winfree,a2			;* image
	movi	19001,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	TYPTEXT,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

	movi	#inits_setup,a2
	calla	setup_message
	movi	#str_pl12,a4
	move	a10,a10
	jrz	#tm1
	movi	#str_pl34,a4		;tm2
#tm1
	move	a11,@mess_cursx
	calla	print_string_C2

	move	a10,a0
	xori	1,a0
	sll	4,a0
	addi	#xpos,a0
	move	*a0,a11
	move	a11,a0				;x val
	sll	16,a0
	movi	[Y3,0],a1			;y val
	movi	chalneed_l,a2			;* image
	movi	19001,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	TYPTEXT,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2


	movi	1*TSEC,a10
	CREATE	CNTDWN_PID,timeout2


	SLEEPK	2
	calla	display_unblank


#slp	SLEEP	20*TSEC				;13
	move	@PSTATUS,a0
	jrnz	#slp


;	movi	13*TSEC,a10
;#whopper_with_cheese
;	SLEEPK	1
;	calla	get_all_buttons_down
;	move	a0,a0
;	jrnz	#exit
;	dsj	a10,#whopper_with_cheese
;#exit
;	SLEEPK	1
;
#not_4play
#exit

	movi	-1,a0
	move	a0,@winningteam		;-1 for no valid half price

	RETP

#inits_setup
	RJR_STR	osgemd_ascii,8,0,X1,Y2,BLUE,0

#str_temp
	.string	"MMM & MMM",0
#str_pl12
	.string	"PLAYERS  1 & 2",0
#str_pl34
	.string	"PLAYERS  3 & 4",0
	.even

#xpos
	.word	X1,X2

#winner_mod
	.long	congratbBMOD
	.word	0,0
	.long	namebox2BMOD
	.word	9,207-14
	.long	0

#*****************************************************************************

 SUBR	buyin_screen

;	calla	WIPEOUT			;CLEAN SYSTEM OUT

	move	@PSTATUS,a0
	move	a0,@plyrsdropped

	clr	a0
	move	a0,@pleasewt
	move	a0,@newplyrs,L

	move	@gmqrtr,a14
	cmpi	4,a14
	jrlt	#tag1
	move	@scores,a14
	move	@scores+16,a1
	cmp	a1,a14
	jrz	#tag1
#exit
	RETP
#tag1
	move	@PSTATUS,a9
	movi	qtr_purchased,a1	; - 1 quarter for each player
	clr	a2
#dec_loop
	move	*a1,a0
	jrz	#skip2
	dec	a0
	move	a0,*a1
	jrnz	#skip2
	movk	1,a0
	sla	a2,a0
	move	@PSTATUS,a3
	andn	a0,a3
	move	a3,@PSTATUS
#skip2
	addk	16,a1
	inc	a2
	cmpi	3,a2
	jrls	#dec_loop
	move	@PSTATUS,a0
#tag2
	cmp	a0,a9
	jrnz	#cont
;But, if someone inserted coins, go to buyin_screen anyway!
	calla	CR_CONTP		;Credits to continue
	jrlo	#bx			;No?
   	move	@game_purchased,a0
	cmpi	>f,a0
	jrnz	#cont
#bx
;2/9/93
	RETP

#cont
	clr	a0
	move	a0,@IRQSKYE		;background color
;	movi	4<<10+4<<5+7,a0
;	move	a0,@IRQSKYE		;background color

	clr	a0
	move	a0,@COLRTEMP,L
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movk	ININTRO,a0
	move	a0,@GAMSTATE

	movi	newplyrs,a0
	move	a0,@newptr,L


	move	@gmqrtr,a0
	cmpi	2,a0
	jrnz	#noth
	.ref	ZERO_BITS
	calla	ZERO_BITS

;	SLEEPK	2

	calla	pal_clean
	movi	#buyin2_mod,a0

	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not_2pa

	movi	#buyin2_kit_mod,a0

#not_2pa


	move	a0,@BAKMODS,L
	calla	BGND_UD1
	SLEEPK	2
	calla	del_box_imgs

SCROLL_SPEED	equ	8

;	SLEEPK	2

	movi	SCROLL_SPEED<<16,a10
	.ref	scroll_page
	JSRP	scroll_page

	clr	a0
	move	a0,@page_scrolling	;scrolling
	jruc	#yesh
#noth


	calla	KILBGND			;Kill old background
	calla	pal_clean
	SLEEPK	1
	movi	-1,a1
	calla	obj_delc		;Kill all objs (Screen mem is clr)

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	movi	[NAMENT_PAGE,0],a0
	move	a0,@WORLDTLY,L
	movi	[NAMENT_PAGE,0],a0
	move	a0,@WORLDTL,L

	SLEEPK	2

	movi	#buyin_mod,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not2
	movi	#buyin_kit_mod,a0
#not2
	move	a0,@BAKMODS,L
	calla	BGND_UD1
#yesh

	calla	create_bits

	movi	TSEC,a10
	CREATE0	timeout3

	CREATE0	credits
	CREATE0	credit_messages

	movk	1,a0
	move	a0,@can_enter_inits	;if 0 deletes challenger messages

	movk	1,a10			;player 2
	CREATE0	ingame_mess
	CREATE0	challenger
	movk	2,a10			;player 3
	CREATE0	ingame_mess
	CREATE0	challenger

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrs

	clr	a10			;player 1
	CREATE0	ingame_mess
	CREATE0	challenger
	movk	3,a10			;player 4
	CREATE0	ingame_mess
	CREATE0	challenger

#2_plyrs

	SLEEP	10

#wait
	SLEEPK	1
	move	@force_selection,a0
	jrz	#wait
	move	@PSTATUS,a0
	jrnz	#ok

;2/9/93
	calla	dropout_stats
	jauc	game_over

#ok	RETP


#buyin2_mod
	.long	selbackBMOD
	.word	0,NAMENT_PAGE+256
	.long	namebox2BMOD
	.word	9,NAMENT_PAGE+207-14
	.long	0
#buyin2_kit_mod
	.long	selbackkBMOD
	.word	0,NAMENT_PAGE+256
	.long	nameboxkBMOD
	.word	9,NAMENT_PAGE+207-14
	.long	0
#buyin_mod
	.long	selbackBMOD
	.word	0,NAMENT_PAGE
	.long	namebox2BMOD
	.word	9,NAMENT_PAGE+207-14
	.long	0

#buyin_kit_mod
	.long	selbackkBMOD
	.word	0,NAMENT_PAGE
	.long	nameboxkBMOD
	.word	9,NAMENT_PAGE+207-14
	.long	0

#*****************************************************************************

 SUBR	blink_tmslct

	movi	[200,0],a0
	movi	[17,0],a1
	movi	PRESSBUTT,a2			;* image
	movi	19001,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	0,a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

#lp
	SLEEP	90

	movi	TURBO_P,a0		;SGMD8RED,a0
	calla	pal_getf
	move	a0,*a8(OPAL)

	movi	PRESSTURB,a0		;* image
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image

	SLEEP	90

	movi	BUTT_P,a0		;SGMD8WHT,a0
	calla	pal_getf
	move	a0,*a8(OPAL)

	movi	PRESSBUTT,a0		;* image
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	jruc	#lp


#*****************************************************************************

	.asg	50,YSPACE

 SUBR	grand_champs_screen


	clr	a10
#chk_nxt
	callr	#check_champ
	jrnc	#found_champ
	inc	a10
	cmpi	4,a10
	jrlt	#chk_nxt

	clr	a10
	RETP


#found_champ

	calla	display_blank
	calla	WIPEOUT

;	SOUND1	tunegc_snd

	clr	a0
	move	a0,@dtype		;2D
	move	a0,@HALT

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	2

	movi	#vmod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movi	#congrats_setup,a2
	calla	setup_message
	movi	YSPACE,a0
	move	a0,@mess_line_spacing
	movi	CLSDEAD|123,a0
	move	a0,@mess_objid
	movi	#congrats_str,a4
	calla	print_string_C2

	movi	#congrats_setup,a2	;print player X on line below
	calla	setup_message
	movi	CLSDEAD|123,a0
	move	a0,@mess_objid
	move	@mess_cursy,a0
	addi	YSPACE,a0
	move	a0,@mess_cursy
	movi	#player_str,a4
	calla	copy_rom_string
	move	a10,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrnz	#iskit
	inc	a0			;1,2,3,4
#iskit					;1,2
	movi	4,a1			;max value
	calla	dec_to_asc
	calla	concat_string
	calla	print_string_C		;centered


	movi	-0c000h,a3		;scroll text up screen
	movi	OBJLST,a14
#lp
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a2
	cmpi	CLSDEAD|123,a2
	jrne	#lp
	move	a3,*a14(OYVEL),L
	jruc	#lp
#x

	movi	[18h,0],a0
	movi	[2eh,0],a1
	movi	TROPHYD1,a2		;* image
	movi	19001,a3		;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2


	movi	[10,7],a8		;START AT COLOR 10, CYCLE 7 COLORS
	movi	BLUE,a9			;PAL NAME
	movi	COLTAB2,a10		;TABLE TO CYCLE WITH
	movk	2,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	8

	SOUND1	tunegc_snd
;	movi	congrats_snd,a0
;	calla	snd_play1

	.ref	plyr_jscrowdsnd
	CREATE0	plyr_jscrowdsnd

	calla	display_unblank

	SLEEP	TSEC*13

	CREATE0	plyr_jscrowdsnd

;	movi	300,a0
;	move	a0,@WORLDTLY+16
;	move	a0,@WORLDTL+16
;	calla	BGND_UD1

	SLEEP	35*TSEC

	movk	1,a10
	RETP


;a10 = player number (0-3)
#check_champ

	move	@PSTATUS,a0
	btst	a10,a0
	jrz	#fail

	move	a10,a0
	sll	5,a0
	addi	#pdata,a0
	move	*a0,a0,L			;* player data

	move	*a0(PR_INIT1),a1
	jrn	#fail
	move	*a0(PR_NUMDEF),a1
	cmpi	27,a1
	jrlt	#fail
	move	*a0(PR_NUMDEFOLD),a1
	cmpi	27,a1
	jrge	#fail

	clrc
	rets

#fail
	setc
	rets


#pdata
	.long	player1_data
	.long	player2_data
	.long	player3_data
	.long	player4_data


#vmod
	.long	blankjamBMOD
	.word	0,1
	.long	0


	.asg	200,X
	.asg	10+300,Y

#congrats_setup
	RJR_STR	osgemd_ascii,10,0,X,Y,BLUE,0


#congrats_str
	.string	"congratulations!",1
	.string	"",1
	.string	"",1
	.string	"",1
	.string	"you have defeated",1
	.string	"all 27 nba teams!",1
	.string	"",1
	.string	"",1
	.string	"",1
	.string	"You are the new NBA jam",1
	.string	"tournament edition",1
	.string	"grand champion!",1
	.string	"",1
	.string	"",1
	.string	"you are an incredible",1
	.string	"player and one of the",1
	.string	"best nba jam stars of",1
	.string	"all time!",1
	.string	"",1
	.string	"",1
	.string	"however, this is a",1
	.string	"midway game!  Which",1
	.string	"means that there is yet",1
	.string	"a greater challenge",1
	.string	"awaiting you . . .",1
	.string	"",1
	.string	"Play on . . .",1
	.string	"",1
	.string	"",1
	.string	"thank you for playing",1
	.string	"nba jam",1
	.string	"tournament edition!",1
	.string	"",0


#player_str
	.string	"PLAYER ",0

	.even


#*****************************************************************************

 SUBR	drw_chicks

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D
	move	a0,@HALT

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	2

	movi	#chick_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1
	
	movi	[10,7],a8		;START AT COLOR 10, CYCLE 7 COLORS
	movi	BLUE,a9			;PAL NAME
	movi	COLTAB2,a10		;TABLE TO CYCLE WITH
	movk	2,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE




;	jruc	#msg1
;
;
;
;
;	movi	1,a0
;	calla	RNDRNG0
;	btst	0,a0
;	jrz	#msg1
;;message #2
;	CREATE0	txt2
;
;	movi	6*TSEC,a10
;	jruc 	#x
;
;txt2	SLEEP	2*60
;	movi	#chicks_setup2,a2
;	calla	setup_message
;	movi	YSPACE,a0
;	move	a0,@mess_line_spacing
;	movi	CLSDEAD|123,a0
;	move	a0,@mess_objid
;	movi	#chicks_str2,a4
;	calla	print_string_C2
;	DIE
;#msg1

	movi	720h+150+180,a10
	movi	#chicks_setup,a2
	calla	setup_message
	movi	YSPACE,a0
	move	a0,@mess_line_spacing
	movi	CLSDEAD|123,a0
	move	a0,@mess_objid
	movi	#chicks_str,a4
	calla	print_string_C2

	movi	-0c000h,a3		;scroll text up screen
	movi	OBJLST,a14
#lp
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a2
	cmpi	CLSDEAD|123,a2
	jrne	#lp
	move	a3,*a14(OYVEL),L
	jruc	#lp
#x

;	movi	[10,7],a8		;START AT COLOR 10, CYCLE 7 COLORS
;	movi	BLUE,a9			;PAL NAME
;	movi	COLTAB2,a10		;TABLE TO CYCLE WITH
;	movk	2,a11			;RATE OF CYCLE IN TICKS
;	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	SLEEP	2*TSEC


;	movi	9*TSEC,a10

#lp2	SLEEPK	1
	calla	get_all_buttons_cur2
	jrz	#nob
      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#xb
#nob	
	dsj	a10,#lp2
#xb

	RETP

#chick_mod
;	.long	chrvic1BMOD
	.long	blankjamBMOD
	.word	0,0
;	.word	0,10
;	.long	chksaBMOD
;	.word	5,0
	.long	0


	.asg	200,X
	.asg	210,Y

;#chicks_setup2
;	RJR_STR	osgemd_ascii,10,0,X,Y,BLUE,0
;
;#chicks_str2
;	.string	"let's play two on two!",1
;	.string	" ",0
;
;	.even

	.asg	200,X
	.asg	10+250,Y

#chicks_setup
	RJR_STR	osgemd_ascii,10,0,X,Y,BLUE,0

;#chicks_str
;	.string	"ATTENTION BALLPLAYERS:",1
;	.string	" ",1
;	.string	" ",1
;	.string	"WE ARE AWAITING YOUR",1
;	.string	"ENTRY INTO THE NBA JAM",1
;	.string	"TOURNAMENT!",1
;	.string	" ",1
;	.string	" ",1
;	.string	"CAN YOU DEFEAT ALL 27",1
;	.string	"NBA TEAMS TO BECOME",1
;	.string	"THE GRAND CHAMPION?",1
;	.string	" ",1
;	.string	" ",1
;	.string	"BECOME THE GRAND CHAMPION",1
;	.string	"AND WE'LL CELEBRATE YOUR",1
;	.string	"VICTORIES TOGETHER!",1
;	.string	" ",1
;	.string	" ",1
;	.string	"ARE YOU UP FOR THE NBA JAM",1
;	.string	"CHALLENGE?",1
;	.string	" ",1
;	.string	" ",1
;	.string	" ",1
;	.string	"GOOD LUCK...",1
;	.string	" ",0
;	.even

#chicks_str
	.string	"ATTENTION BALLPLAYERS:",1
	.string	" ",1
	.string	"DO YOU THINK YOU'VE CONQUERED",1
	.string	"NBA JAM?",1
	.string	" ",1
	.string	"I DON'T THINK SO.",1
	.string	" ",1
	.string	"THIS NEW EDITION WILL PROVE:",1
	.string	" ",1
	.string	"IT WASN'T THE SHOES.",1
	.string	"NOW YOU NEED SKILLS!",1
	.string	" ",1
	.string	"WE WOULD LIKE TO AWARD THE",1
	.string	"NBA JAM TOURNAMENT TROPHY.",1
	.string	" ",1	     
	.string	"FIRST YOU MUST DEFEAT",1
	.string	"ALL 27 NBA TEAMS.",1
	.string	" ",1
	.string	"DEFEATING ALL 27 TEAMS",1
	.string	"WILL ALLOW YOU TO BE",1
	.string	"MATCHED UP AGAINST SUPER",1
	.string	"STAR & SPECIAL TEAMS THAT",1
	.string	"WILL SHOW NO MERCY!",1
	.string	" ",1
	.string	"ARE YOU UP FOR THE NBA JAM",1
	.string	"TOURNAMENT EDITION CHALLENGE?",1
	.string	" ",1
	.string	"STEP UP AND SHOW SOME SKILL.",1
	.string	" ",0
	.even

******************************************************************************
player_heads	   


;00 ATLANTA
	.long	MAN_CLP,AUG_ATL
	.long	AUG_ATL,MAN_CLP
	.long	MAN_CLP,WLS_ATL
	.long	WLS_ATL,MAN_CLP
	.long	AUG_ATL,WLS_ATL
	.long	WLS_ATL,AUG_ATL

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
	.long	MCD_BOS,BRO_BOS
	.long	BRO_BOS,MCD_BOS
	.long	MCD_BOS,GAM_BOS
	.long	GAM_BOS,MCD_BOS
	.long	BRO_BOS,GAM_BOS
	.long	GAM_BOS,BRO_BOS

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
	.long	JON_CHA,HWK_CHA
	.long	HWK_CHA,JON_CHA			
	.long	JON_CHA,MOU_CHA			
	.long	MOU_CHA,JON_CHA
	.long	HWK_CHA,MOU_CHA			
	.long	MOU_CHA,HWK_CHA

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
	.long	PIP_CHI,ARM_CHI
	.long	ARM_CHI,PIP_CHI
	.long	PIP_CHI,KUK_CHI
	.long	KUK_CHI,PIP_CHI
	.long	ARM_CHI,KUK_CHI
	.long	KUK_CHI,ARM_CHI		

	.long	ARM_CHI,GRT_CHI
	.long	GRT_CHI,ARM_CHI
	.long	KUK_CHI,GRT_CHI		
	.long	GRT_CHI,KUK_CHI
	.long	PIP_CHI,GRT_CHI		
	.long	GRT_CHI,PIP_CHI

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;04 CLEVELAND
	.long	PRC_CLE,DAU_CLE			
	.long	DAU_CLE,PRC_CLE			
	.long	PRC_CLE,NAN_CLE			
	.long	NAN_CLE,PRC_CLE			
	.long	DAU_CLE,NAN_CLE			
	.long	NAN_CLE,DAU_CLE			

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
;	.long	HPR_DAL,JAC_DAL
;	.long	JAC_DAL,HPR_DAL
;	.long	HPR_DAL,MAS_DAL
;	.long	MAS_DAL,HPR_DAL
;	.long	JAC_DAL,MAS_DAL
;	.long	MAS_DAL,JAC_DAL
    
	.long	JAC_DAL,MAS_DAL
	.long	MAS_DAL,JAC_DAL
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
	.long	MUT_DEN,ELL_DEN
	.long	ELL_DEN,MUT_DEN			
	.long	MUT_DEN,ROG_DEN
	.long	ROG_DEN,MUT_DEN
	.long	ELL_DEN,ROG_DEN
	.long	ROG_DEN,ELL_DEN

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
	.long	THM_DET,DUM_DET
	.long	DUM_DET,THM_DET
	.long	THM_DET,ELL_DET
	.long	ELL_DET,THM_DET
	.long	DUM_DET,ELL_DET
	.long	ELL_DET,DUM_DET

	.long	DUM_DET,HUN_DET
	.long	HUN_DET,DUM_DET
	.long	THM_DET,HUN_DET
	.long	HUN_DET,THM_DET
	.long	ELL_DET,HUN_DET
	.long	HUN_DET,ELL_DET

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;08 GOLDEN STATE
	.long	HRD_GLD,MUL_GLD
	.long	MUL_GLD,HRD_GLD			
	.long	HRD_GLD,WEB_GLD
	.long	WEB_GLD,HRD_GLD			
	.long	MUL_GLD,WEB_GLD			
	.long	WEB_GLD,MUL_GLD			

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
	.long	OLA_HOU,MAX_HOU
	.long	MAX_HOU,OLA_HOU
	.long	OLA_HOU,HOR_HOU
	.long	HOR_HOU,OLA_HOU
	.long	MAX_HOU,HOR_HOU
	.long	HOR_HOU,MAX_HOU

	.long	MAX_HOU,SMT_HOU		
	.long	SMT_HOU,MAX_HOU
	.long	OLA_HOU,SMT_HOU		
	.long	SMT_HOU,OLA_HOU
	.long	HOR_HOU,SMT_HOU		
	.long	SMT_HOU,HOR_HOU

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;10 INDIANA
	.long	MIL_IND,SEL_IND
	.long	SEL_IND,MIL_IND
	.long	MIL_IND,SMI_IND
	.long	SMI_IND,MIL_IND
	.long	SEL_IND,SMI_IND
	.long	SMI_IND,SEL_IND

;	.long	SMI_IND,SEL_IND
;	.long	SEL_IND,SMI_IND		
;	.long	SMI_IND,SCH_IND
;	.long	SCH_IND,SMI_IND		
;	.long	SMI_IND,MIL_IND
;	.long	MIL_IND,SMI_IND		

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


;11 L.A. CLIPPERS
	.long	WLK_ATL,HRP_CLP
	.long	HRP_CLP,WLK_ATL
	.long	WLK_ATL,ROB_CLP
	.long	ROB_CLP,WLK_ATL
	.long	HRP_CLP,ROB_CLP
	.long	ROB_CLP,HRP_CLP

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
	.long	PEE_LAK,DIV_LAK
	.long	DIV_LAK,PEE_LAK
	.long	PEE_LAK,CAM_LAK
	.long	CAM_LAK,PEE_LAK
	.long	DIV_LAK,CAM_LAK
	.long	CAM_LAK,DIV_LAK

	.long	DIV_LAK,WOR_LAK
	.long	WOR_LAK,DIV_LAK
	.long	PEE_LAK,WOR_LAK
	.long	WOR_LAK,PEE_LAK
	.long	CAM_LAK,WOR_LAK
	.long	WOR_LAK,CAM_LAK

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;	.long	JON_LAK,WOR_LAK
;	.long	WOR_LAK,JON_LAK
;	.long	JON_LAK,CAM_LAK
;	.long	CAM_LAK,JON_LAK
;	.long	JON_LAK,DIV_LAK
;	.long	DIV_LAK,JON_LAK
;	.long	JON_LAK,PEE_LAK
;	.long	PEE_LAK,JON_LAK


;13 MIAMI
	.long	RCE_MIA,SKL_MIA
	.long	SKL_MIA,RCE_MIA
	.long	RCE_MIA,MIN_MIA
	.long	MIN_MIA,RCE_MIA
	.long	SKL_MIA,MIN_MIA
	.long	MIN_MIA,SKL_MIA

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
	.long	BAK_MLW,EDW_MLW
	.long	EDW_MLW,BAK_MLW
	.long	BAK_MLW,DAY_MLW
	.long	DAY_MLW,BAK_MLW
	.long	EDW_MLW,DAY_MLW
	.long	DAY_MLW,EDW_MLW
	
	.long	EDW_MLW,LOH_MLW
	.long	LOH_MLW,EDW_MLW
	.long	DAY_MLW,LOH_MLW
	.long	LOH_MLW,DAY_MLW
	.long	BAK_MLW,LOH_MLW
	.long	LOH_MLW,BAK_MLW

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;15 MINNESOTTA
	.long	LTN_MIN,PRS_MIN
	.long	PRS_MIN,LTN_MIN
	.long	LTN_MIN,RID_MIN
	.long	RID_MIN,LTN_MIN
	.long	PRS_MIN,RID_MIN
	.long	RID_MIN,PRS_MIN

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
	.long	COL_NEJ,AND_NEJ
	.long	AND_NEJ,COL_NEJ
	.long	COL_NEJ,MOR_NEJ
	.long	MOR_NEJ,COL_NEJ
	.long	AND_NEJ,MOR_NEJ
	.long	MOR_NEJ,AND_NEJ

	.long	AND_NEJ,BEN_NEJ
	.long	BEN_NEJ,AND_NEJ
	.long	MOR_NEJ,BEN_NEJ
	.long	BEN_NEJ,MOR_NEJ
	.long	COL_NEJ,BEN_NEJ
	.long	BEN_NEJ,COL_NEJ

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;17 NEW YORK
	.long	EWG_NEY,MAS_NEY
	.long	MAS_NEY,EWG_NEY
	.long	EWG_NEY,STA_NEY
	.long	STA_NEY,EWG_NEY
	.long	MAS_NEY,STA_NEY
	.long	STA_NEY,MAS_NEY

	.long	MAS_NEY,OAK_NEY
	.long	OAK_NEY,MAS_NEY
	.long	EWG_NEY,OAK_NEY
	.long	OAK_NEY,EWG_NEY
	.long	STA_NEY,OAK_NEY
	.long	OAK_NEY,STA_NEY

	.long	HPR_DAL,OAK_NEY
	.long	OAK_NEY,HPR_DAL
	.long	HPR_DAL,MAS_NEY
	.long	MAS_NEY,HPR_DAL
	.long	HPR_DAL,STA_NEY
	.long	STA_NEY,HPR_DAL
	.long	HPR_DAL,EWG_NEY
	.long	EWG_NEY,HPR_DAL


;18 ORLANDO
	.long	HAR_ORL,AND_ORL
	.long	AND_ORL,HAR_ORL
	.long	HAR_ORL,SKL_ORL
	.long	SKL_ORL,HAR_ORL
	.long	AND_ORL,SKL_ORL
	.long	SKL_ORL,AND_ORL

;	.long	IUZ_ORL,SKL_ORL
;	.long	SKL_ORL,IUZ_ORL
;	.long	IUZ_ORL,AND_ORL
;	.long	AND_ORL,IUZ_ORL
;	.long	IUZ_ORL,HAR_ORL
;	.long	HAR_ORL,IUZ_ORL

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


;19 PHILADELPHIA
	.long	WEA_PHL,BRA_PHL
	.long	BRA_PHL,WEA_PHL
;	.long	WEA_PHL,HRN_PHL
;	.long	HRN_PHL,WEA_PHL		
;	.long	BRA_PHL,HRN_PHL
;	.long	HRN_PHL,BRA_PHL		

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
	.long	BRK_PHX,MAJ_PHX
	.long	MAJ_PHX,BRK_PHX			
	.long	BRK_PHX,JOH_PHX			
	.long	JOH_PHX,BRK_PHX			
	.long	MAJ_PHX,JOH_PHX			
	.long	JOH_PHX,MAJ_PHX			

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
	.long	DRX_PRT,POR_PRT
	.long	POR_PRT,DRX_PRT		
	.long	DRX_PRT,ROB_PRT
	.long	ROB_PRT,DRX_PRT
	.long	POR_PRT,ROB_PRT		
	.long	ROB_PRT,POR_PRT

	.long	GRT_PRT,ROB_PRT		
	.long	ROB_PRT,GRT_PRT		
	.long	GRT_PRT,POR_PRT		
	.long	POR_PRT,GRT_PRT		
	.long	GRT_PRT,DRX_PRT		
	.long	DRX_PRT,GRT_PRT		

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;22 SACRAMENTO
	.long	SIM_SAC,HUR_SAC
	.long	HUR_SAC,SIM_SAC
	.long	SIM_SAC,RIC_SAC
	.long	RIC_SAC,SIM_SAC
	.long	HUR_SAC,RIC_SAC
	.long	RIC_SAC,HUR_SAC

	.long	HUR_SAC,WEB_SAC
	.long	WEB_SAC,HUR_SAC

	.long	HUR_SAC,TIS_SAC
	.long	TIS_SAC,HUR_SAC

	.long	SIM_SAC,TIS_SAC
	.long	TIS_SAC,SIM_SAC

	.long	RIC_SAC,TIS_SAC
	.long	TIS_SAC,RIC_SAC

	.long	WEB_SAC,TIS_SAC
	.long	TIS_SAC,WEB_SAC

	.long	WEB_SAC,RIC_SAC
	.long	RIC_SAC,WEB_SAC

	.long	WEB_SAC,SIM_SAC
	.long	SIM_SAC,WEB_SAC


;23 SAN ANTONIO
	.long	ROB_SAN,ROD_SAN
	.long	ROD_SAN,ROB_SAN
	.long	ROB_SAN,ELS_SAN
	.long	ELS_SAN,ROB_SAN
	.long	ROD_SAN,ELS_SAN
	.long	ELS_SAN,ROD_SAN

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
	.long	KMP_SEA,PAY_SEA
	.long	PAY_SEA,KMP_SEA			
	.long	KMP_SEA,GIL_SEA			
	.long	GIL_SEA,KMP_SEA			
	.long	PAY_SEA,GIL_SEA			
	.long	GIL_SEA,PAY_SEA			

	.long	SCH_SEA,GIL_SEA			
	.long	GIL_SEA,SCH_SEA			
	.long	SCH_SEA,PAY_SEA			
	.long	PAY_SEA,SCH_SEA			
	.long	SCH_SEA,KMP_SEA			
	.long	KMP_SEA,SCH_SEA			

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0


;25 UTAH
	.long	MLN_UTA,STK_UTA
	.long	STK_UTA,MLN_UTA
	.long	MLN_UTA,BEN_UTA
	.long	BEN_UTA,MLN_UTA
	.long	STK_UTA,BEN_UTA
	.long	BEN_UTA,STK_UTA

	.long	HRN_PHL,BEN_UTA
	.long	BEN_UTA,HRN_PHL
	.long	HRN_PHL,STK_UTA
	.long	STK_UTA,HRN_PHL
	.long	HRN_PHL,MLN_UTA
	.long	MLN_UTA,HRN_PHL

	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0
	.long	0,0

;26 WASHINGTON
	.long	GUG_WAS,ELL_WAS
	.long	ELL_WAS,GUG_WAS
	.long	GUG_WAS,CHE_WAS
	.long	CHE_WAS,GUG_WAS
	.long	ELL_WAS,CHE_WAS
	.long	CHE_WAS,ELL_WAS

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
	.long	MLN_UTA,KMP_SEA
	.long	ROB_SAN,BRK_PHX
	.long	DRX_PRT,HAR_ORL
	.long	EWG_NEY,AND_NEJ
	.long	COL_NEJ,AND_ORL
	.long	STK_UTA,JOH_PHX

	.long	GIL_SEA,RIC_SAC
	.long	BRA_PHL,WEB_SAC
	.long	DUM_DET,STA_NEY
	.long	MUT_DEN,WLK_ATL
	.long	HRP_CLP,RID_MIN
	.long	MIL_IND,JON_CHA

	.long	OLA_HOU,BAK_MLW
	.long	ARM_CHI,MAX_HOU
	.long	MOU_CHA,RCE_MIA
	.long	HRD_GLD,JAC_DAL
	.long	PIP_CHI,MIN_MIA
	.long	THM_DET,WEB_GLD
	.long	MAS_DAL,WOR_LAK
	.long	MUL_GLD,MAN_CLP

;	.long	SCO_MK2,RAD_MK2
;	.long	RAD_MK2,SCO_MK2
;	.long	SCO_MK2,REP_MK2
;	.long	REP_MK2,SCO_MK2
;	.long	RAD_MK2,REP_MK2
;	.long	REP_MK2,RAD_MK2
;
;	.long	SUB_MK2,REP_MK2
;	.long	REP_MK2,SUB_MK2
;	.long	SUB_MK2,RAD_MK2
;	.long	RAD_MK2,SUB_MK2
;	.long	SUB_MK2,SCO_MK2
;	.long	SCO_MK2,SUB_MK2
;
;	.long	SUB_MK2,KAR_HOS
;	.long	KAR_HOS,RAD_MK2
;	.long	LOR_OLI,KAR_HOS
;	.long	RAD_MK2,LOR_OLI
;	.long	LOR_OLI,SUB_MK2
;	.long	REP_MK2,KAR_HOS
;	.long	KAR_HOS,MRK_TURM
;	.long	MRK_TURM,LOR_OLI

******************************************************************************

	.def	player_attribs

player_attribs
	  
;ROOKIES:
;  Chris Mills ?      Cleveland 6'6"	  Fat
;  Luther Wright ?    Utah      7'2"	  Fat
;  Acie Earl ?	      Boston    6'11"	  Skinny
;  Nick Van Excel ?   Lakers    6'1"	  Skinny
;  Ervin Johnson ?    Seattle   6'11"	  Skinny
;  Rex Walters ?      Nets	6'4"      Skinny	
;  Terry Dehere	?     Clippers	6'4"	  Skinny
;  Eric Riley ?	      Dallas	7'0"	  Skinny
;  Adonis Jordan ?    Seattle	5'11"	  Skinny	
;  Doug Edwards	      Atlanta	6'7"	  Skinny
;  Allan Houston      Detroit	6'6"	  Skinny	
;  George Lynch	      Lakers	6'8"	  Skinny
;
;VETERANS:
;
;  Kevin Duckworth    Washington  7'0"	  Fat  
;  Alaa	 Abdelnaby    Boston	  6'10'   Fat (medium)	
;  Rick  Fox          Boston	  6'7'    Fat (medium)	
;  Jerome Lane	      Cleveland	  6-6	  Fat (medium)
;  Billy Owens	      GS Warriors 6-9	  Skinny (medium)
;  Doug Christie      Lakers	  6-6	  Skinny 
;  Sam Bowie          Lakers	  7-1	  Fat (medium)
;  Anthony Avent      Milwaukee	  6-9	  Skinny
;  Moses Malone	      Phil. (?)	  6-10	  Fat
;  Ken Norman	      Milw.	  6-8	  Fat (medium)
;  Orlando Woolridge  Milw.	  6-9	  Skinny (medium)
; ============================================================
;	

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;00 ATLANTA HAWKS

 .word	07,07,07,02
 .word  06,04,05,07	;DANNY MANNING	   6-10	Fat (medium)

 .word	09,07,02,05
 .word  01,04,02,05	;STACEY AUGMON	       Skinny

 .word	06,04,06,04
 .word  09,00,09,01	;KEVIN WILLIS	       Fat (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;01 BOSTON CELTICS

 .word	08,07,08,06
 .word  01,06,02,05	;DEE BROWN	  6-1     Skinny

 .word	05,05,05,01
 .word  08,03,09,08	;XAVIER McDANIEL  6-7     Skinny

 .word	03,07,02,05
 .word  05,06,04,04	;KEVIN GAMBLE	  6-5     Skinny

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;02 CHARLOTTE HORNETS

 .word	07,07,09,03
 .word  09,03,06,07	;LARRY JOHNSON	  6-7     Fat (medium)

 .word	07,07,00,05
 .word  02,04,03,06	;HERSEY HAWKINS	   6-3 Skinny  

 .word	07,05,08,05
 .word  09,04,09,09	;ALONZO MOURNING  6-10 (6-11)   Skinny

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;03 CHICAGO BULLS

 .word	08,06,10,07
 .word  03,09,05,05	;SCOTTIE PIPPEN	   6-7    Skinny

 .word	08,09,00,05
 .word  00,04,00,09	;BJ ARMSTRONG	   6-2    Skinny

 .word	06,05,02,09
 .word  04,04,07,04	;TONI KUKOC	   6-11    Skinny

 .word	06,01,05,02
 .word  09,02,09,04	;HORACE GRANT	   6-10    Skinny (Medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;04 CLEVELAND CAVALIERS

 .word	08,09,00,08
 .word  02,10,00,09	;MARK PRICE	   6-0    Skinny

 .word	07,03,08,04
 .word  06,03,07,06	;BRAD DAUGHERTY	   7-0    Skinny (medium)

 .word	03,04,07,03
 .word  07,03,09,02	;LARRY NANCE	   6-10    Fat (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;05 DALLAS MAVERICKS

; .word	05,05,02,05
; .word  05,04,03,06	;DEREK HARPER	   6-4    Skinny

 .word	08,06,01,09
 .word  05,05,03,06	;JIM JACKSON	   6-6    Fat (medium)

 .word	08,08,07,04
 .word  08,03,06,06	;JAMAL MASHBURN	   6-8    Skinny (Medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;06 DENVER NUGGETS

 .word	05,01,08,01
 .word  08,02,09,02	;DIKEMBE MUTUMBO   7-2	Skinny (medium)

 .word	06,05,06,03
 .word  05,02,05,03	;LAPHONSO ELLIS	   6-8	Fat (medium)

 .word	07,05,03,04
 .word  07,03,03,01	;RODNEY ROGERS	   6-7   Skinny 

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;07 DETROIT PISTONS

 .word	08,08,00,08
 .word  01,07,00,09	;ISIAH THOMAS	   6-1	Skinny

 .word	08,07,00,05
 .word  03,04,02,08	;JOE DUMARS	   6-3	Skinny (medium)

 .word	07,06,06,05
 .word  04,05,06,05	;SEAN ELLIOT		6-8  Skinny

 .word	09,05,00,06
 .word  02,05,00,02	;LINDSEY HUNTER	   6-2  Skinny

; .word	00,06,00,04
; .word  09,01,05,06	;BILL LAIMBEER	   6-11	Skinny (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;08 GOLDEN STATE WARRIORS

 .word	09,06,00,05
 .word  04,08,00,06	;TIM HARDAWAY  6-0	Skinny

 .word	04,10,03,05
 .word  05,04,04,09	;CHRIS MULLIN  6-7 	Skinny (medium)

 .word	08,04,08,07
 .word  09,03,08,00	;CHRIS WEBBER  6-9	Fat (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;09 HOUSTON ROCKETS

 .word	08,02,09,04
 .word  08,03,09,08	;HAKEEM OLAJUWON   7-0	Fat (medium)

 .word	07,04,01,07
 .word  00,05,03,02	;VERNON MAXWELL	   6-4	Skinny

 .word	07,06,07,05
 .word  06,04,07,04	;ROBERT HORRY	   6-10	Skinny

 .word	07,08,01,07
 .word  02,04,03,04	;KENNY SMITH	   6-3	Skinny

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;10 INDIANA PACERS

 .word	07,09,05,06
 .word  04,05,04,08	;REGGIE MILLER	   6-7	Skinny

 .word	06,04,05,04
 .word  05,01,06,02	;MALIK SEALY	   6-8	Skinny

 .word	02,02,04,03
 .word  07,01,08,06	;RIK SMITS	   7-4	Skinny

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;11 L.A. CLIPPERS

 .word	08,06,10,02
 .word  03,04,08,08	;DOMINIQUE WILKINS     Skinny

 .word	08,07,04,03
 .word  04,08,07,06	;RON HARPER	   6-6	Skinny (medium)

 .word	01,04,03,03
 .word  09,02,08,02	;STANLEY ROBERTS   7-0	Fat (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;12 L.A. LAKERS

 .word	08,07,04,04
 .word  00,04,02,08	;ANTHONY PEELER	   6-4	Skinny

 .word	03,05,07,02
 .word  06,04,07,08	;VLADE DIVAC	   7-1	Skinny (medium)

 .word	07,04,06,02
 .word  08,02,09,06	;ELDON CAMPBELL	   6-11	Skinny

; .word	04,08,02,09
; .word  05,08,05,09	;MAGIC JOHNSON	   6-9	Fat (medium)

 .word	05,07,07,05
 .word  04,05,05,06	;JAMES WORTHY	   6-9	Fat (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;13 MIAMI HEAT

 .word	07,09,05,02
 .word  03,04,04,08	;GLEN RICE	   6-8	Fat (medium)

 .word	03,03,08,04
 .word  06,03,08,03	;RONY SEIKALY	   6-11	Skinny (medium)

 .word	09,05,09,07
 .word  02,07,06,08	;HAROLD MINER	   6-5	Fat (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;14 MILWAUKEE

 .word	07,04,07,01
 .word  02,02,09,02	;VIN BAKER   	6-11    Skinny

 .word	04,04,03,05
 .word  05,04,04,05	;BLUE EDWARDS	6-4	Fat  (medium)

 .word	06,04,05,06
 .word  04,06,05,05	;TODD DAY	6-6	Skinny (medium)

 .word	02,04,02,01
 .word  08,01,08,05	;BRAD LOHAUS	6-11    Skinny  (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;15 MINNESOTA TIMBERWOLVES

 .word	05,06,04,00
 .word  04,03,06,08	;CHRISTIAN LAETNER   6-11  Skinny  (medium)

 .word	05,09,05,00
 .word  07,04,03,09	;CHUCK PERSON	     6-8  Fat	  (medium)

 .word	09,04,09,05
 .word  06,05,05,05	;ISIAH J.R. RIDER    6-5 Skinny  (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;16 NEW JERSEY NETS

 .word	07,07,08,02
 .word  09,02,08,08	;DERRICK COLEMAN      6-10   Fat

 .word	09,07,00,09
 .word  02,07,01,05	;KENNY ANDERSON	      6-1   Skinny

 .word	02,04,04,04
 .word  09,02,08,02	;CHRIS MORRIS	      6-8   Fat

 .word	02,04,04,03
 .word  09,02,06,02	;BENOIT BENJAMIN      7-0   Fat

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;17 NEW YORK

 .word	07,04,09,02
 .word  08,04,09,09	;PATRICK EWING	      7-0    Fat

 .word	04,02,04,06
 .word  09,03,07,03	;ANTHONY MASON	       6-7    Skinny (medium)

 .word	08,06,03,06
 .word  02,06,01,06	;JOHN STARKS	       6-5    Skinny

 .word	03,01,05,04
 .word  09,01,08,01	;CHARLES OAKLEY	       6-9    Fat

 .word	05,05,02,05
 .word  05,04,03,06	;DEREK HARPER	   6-4    Skinny

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;18 ORLANDO MAGIC

; .word	07,00,10,03
; .word  09,04,09,03	;SHAQ (uille) ONEAL	7-1    Fat

 .word	09,08,03,08
 .word  02,07,04,05	;ANFERNEE (Penny) HARDAWAY   6-7 Skinny

 .word	07,09,05,05
 .word  06,08,06,04	;NICK ANDERSON		 6-6   Fat (medium)

 .word	07,09,00,07
 .word  01,08,01,06	;SCOTT SKILES		6-1    Skinny

; .word	03,06,00,04
; .word  04,04,00,02	;MIKE IUZZOLINO	   6-0    Skinny (medium)
			;not on NBA roster

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;19 PHILADELPHIA  76ers

 .word	05,06,06,02
 .word  08,03,08,02	;CLARENCE WEATHERSPOON	 6-7	Fat (mediumn)

 .word	07,03,09,06
 .word  05,07,09,01	;SHAWN BRADLEY	7-6 	Skinny

; .word	06,08,00,07
; .word  03,04,04,06	;JEFF HORNACEK	 6-4	Fat (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;20 PHOENIX SUNS

 .word	07,07,09,05					
 .word  09,05,05,09	;CHARLES BARKLEY      6-6  (6-4) Fat

 .word	05,08,04,04
 .word  05,03,03,09	;DAN MAJERLE	      6-6  Skinny  (medium)

 .word	08,07,00,08
 .word  01,07,00,01	;KEVIN JOHNSON	      6-1  Skinny

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;21 PORTLAND TRAILBLAZERS

 .word	07,06,09,05
 .word  04,05,06,06	;CLYDE DREXLER	     6-7  	Skinny (medium)

 .word	08,08,01,08
 .word  04,08,00,03	;TERRY PORTER	     6-3	Skinny (medium)

 .word	05,03,07,04
 .word  09,03,09,02	;CLIFF ROBINSON	     6-10	Skinny (medium)

 .word	05,04,06,04
 .word  07,03,07,06	;HARVEY GRANT	     6-9	Skinny (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;22 SACRAMENTO KINGS

 .word	05,01,05,06
 .word  03,06,05,04	;LIONEL SIMMONS	       6-7	Skinny	

 .word	09,06,00,08
 .word  02,09,00,08	;BOBBY HURLEY	       6-0 	Skinny

 .word	07,09,03,06
 .word  08,05,02,07	;MITCH RICHMOND	       6-5	Skinny (medium)

 .word	03,03,08,04
 .word  09,02,05,06	;WAYMON TISDALE		6-9     Fat

 .word	09,06,09,03
 .word  00,07,00,04	;SPUDD WEBB		5-7      Skinny

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;23 SAN ANTONIO	SPURS

 .word	07,03,08,05
 .word  07,03,09,07	;DAVID ROBINSON		7-1  Skinny (medium)

 .word	08,02,07,05
 .word  09,07,09,04	;DENNIS RODMAN		6-8  Skinny (medium)

 .word	04,09,02,05
 .word  05,05,05,05	;DALE ELLIS		6-7  Skinny

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;24 SEATTLE SUPERSONICS

 .word	08,05,10,03
 .word  08,03,08,06	;SHAWN KEMP	        6-10 Skinny (medium)

 .word	08,05,01,08
 .word  05,07,01,04	;GARY PAYTON		6-4   Skinny

 .word	07,07,07,06
 .word  06,07,07,06	;KENDALL GILL	  6-5     Skinny

 .word	03,06,04,05
 .word  08,04,06,06	;DETLEF SCHREMPF   6-10	Skinny (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;25 UTAH JAZZ

 .word	07,04,09,05
 .word  09,03,08,08	;KARL MALONE		6-9 Fat (medium)

 .word	08,09,00,09
 .word  00,09,00,06	;JOHN STOCKTON		6-1 Skinny

 .word	05,04,03,03
 .word  04,04,06,03	;DAVID BENOIT		6-8 Skinny

 .word	06,08,00,07
 .word  03,04,04,06	;JEFF HORNACEK	 6-4	Fat (medium)

;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;26 WASHINGTON BULLETS

 .word	07,07,07,05
 .word  08,04,05,04	;TOM GUGLIOTTA	    6-10   Skinny

 .word	05,02,06,03
 .word  08,01,09,05	;PERVIS ELLISON	    6-10   Fat (medium)

 .word	08,08,03,05
 .word  02,07,04,08	;CALBERT CHEANEY    6-7    Skinny (medium)


;Speed, 3 ptrs, Dunks, Passing
;Power, Steals, Block, Clutch

;27 MORTAL KOMBAT

 .word	07,07,09,05
 .word  08,04,05,04	;SCORPION

 .word	08,06,09,03
 .word  08,01,09,05	;RAIDEN

 .word	07,08,09,05
 .word  02,07,04,08	;REPTILE

 .word	08,08,09,05
 .word  05,07,04,02	;SUB ZERO

 .word	08,09,03,05
 .word  02,03,01,08	;HOSKINS

 .word	09,08,09,07
 .word  03,08,02,08	;OLIVIA

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

 .word	09,09,09,09
 .word  09,09,09,09	;TURMELL

******************************************************************************
#*****************************************************************************
;check if all credits have been sucked up (that can be)
;
; 0  = not all credits sucked up
; !0 = all credits sucked up

 SUBR	check_suckup

	move	@gmqrtr,a0
	cmpi	2,a0
	jrz	#not_enough

	movk	ADJFREPL,a0
	calla	GET_ADJ 	;SEE IF FREEPLAY......(Z BIT CLEAR IF SO!)
	jrnz	#free_play

	calla	CRED_P			;get number credits
	move	a0,a3
	movi	ADJCSTRT,a0		;# credits to start
	calla	GET_ADJ
	divu	a0,a3			;credits / credits to continue
	move	a3,a3
	jrz	#not_enough

	clr	a4
#next
	move	@PSTATUS,a0
	btst	a4,a0
	jrz	#no_player

	move	@game_purchased,a0
	btst	a4,a0
	jrz	#not_purchased

#no_player
	inc	a4
	cmpi	4,a4
	jrlt	#next

#not_enough			;to continue
#free_play			;so no suckup required
	movk	1,a0
	move	a0,a0
	rets


#not_purchased
	clr	a0

	rets


	.def	attrib_off
	.def	attrib_on
	.def	update_attribs

attrib_off
	PUSH	a8
	movk	9,a0
#atlp1
	move	*a2+,a8,L
	PUSH	a0,a2
	calla	obj_off
	PULL	a0,a2
	dsj	a0,#atlp1
	PULL	a8
	rets

attrib_on
	PUSH	a8
	movk	9,a0
#atlp2
	move	*a2+,a8,L
	PUSH	a0,a2
	calla	obj_on
	PULL	a0,a2
	dsj	a0,#atlp2
	PULL	a8
	rets

update_attribs
	movk	8,a0
#udlp
	move	*a11+,a8,L
	move	*a10+,a1
	PUSH	a0,a10,a11

;Special head?
	move	a6,a6
	jrn	#norm
;Yes, hide stats!
	movk	11,a1
#norm


	move	a1,a0
	sll	5,a0
	addi	attrib_pals,a0
	move	*a0,a0,L
	PUSH	a1
	calla	pal_getf
	PULL	a1
	move	a0,*a8(OPAL),L		;Set pallette & constant

	sll	5,a1			;x32
	addi	attrib_imgs,a1

	move	*a1,a0,L
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	PULL	a0,a10,a11
	dsj	a0,#udlp
	rets

attrib_pals
	.long	scoreprd,scoreprd
	.long	scoreprd,scorepw
	.long	scorepw,scorepw
	.long	scorepw,scorepw
	.long	scorepg,scorepg
	.long	scorepg,scorepw

attrib_imgs
	.long	font60,font61
	.long	font62,font63
	.long	font64,font65
	.long	font66,font67
	.long	font68,font69
	.long	font69,font6?



 SUBR	del_box_imgs

	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text cpu subs

	move	@teamset1_obj,a0,L
	calla	DELOBJ	
	move	@teamset2_obj,a0,L
	calla	DELOBJ	
	move	@name1_obj,a0,L
	calla	DELOBJ	
	move	@name2_obj,a0,L
	calla	DELOBJ	
	move	@name3_obj,a0,L
	calla	DELOBJ	
	move	@name4_obj,a0,L
	calla	DELOBJ	

	movk	9,a11
	movi	attrib1_obj,a10
	movi	attrib2_obj,a9
	movi	attrib3_obj,a8
	movi	attrib4_obj,a7

#lp	move	*a10+,a0,L
	calla	DELOBJ
	move	*a9+,a0,L
	calla	DELOBJ
	move	*a8+,a0,L
	calla	DELOBJ
	move	*a7+,a0,L
	calla	DELOBJ
	dsjs	a11,#lp

	movi	BAKLST,a14

#lp2	move	a14,a3		;A3=*Prev
	move	*a14,a14,L	;A14=*Next
	jrz	#x
#cmp	move	*a14(OZPOS),a2
	cmpi	60,a2
	jrz	#kil
	cmpi	61,a2
	jrne	#lp2
#kil

	move	*a14,*a3,L	;Unlink from obj list

	move	@OFREE,*a14+,L	;Add to free list
	subk	32,a14
	move	a14,@OFREE,L
	move	*a3,a14,L
	jrnz	#cmp
#x
	move	@credit1_obj,a0,L
	calla	DELOBJ
	move	@credit2_obj,a0,L
	calla	DELOBJ
	move	@credit3_obj,a0,L
	calla	DELOBJ
	
	clr	a0
	callr	create_credits

	rets

#******************************************************************************

 SUBR	brown_shadow

 	rets

	movi	NBAPAL,a0
	calla	pal_find
	andi	0ff00h,a0
	move	a0,a10

;	callr	obj_ckpal
;	rets


	move	a10,a1			;dest pal
	ori	52,a1	;26*16,a1	;26
	movi	#brown_shad,a0		;pal data
	movk	3,a2			;3 colours
	calla	pal_set
	rets

#brown_shad
	.word	11<<10+5<<5+0
	.word	9<<10+3<<5+0
	.word	7<<10+2<<5+0

obj_ckpal
	movi	OBJLST,a14
	movi	kp_ram,a2
	clr	a1
	move	a1,*a2,L

#lp
	move	*a14,a14,L	;A14=*Next
	jrz	#x
	move	*a14(OPAL),a1
	cmp	a0,a1
	jrne	#lp

	move	a14,*a2+,L
	clr	a1
	move	a1,*a2,L
	jruc	#lp

#x
	movi	kp_ram,a2
#lp2
	move	*a2+,a0,L
	jrz	#xx
	calla	DELOBJ
	jruc	#lp2
#xx
	rets


#******************************************************************************

 SUBR	blue_shadow
	rets
	movi	wood64b,a0		;NBAPAL,a0
	calla	pal_find
;	andi	0ff00h,a0
	move	a0,a10


	callr	obj_ckpal

	movi	NBAPAL,a0		;NBAPAL,a0
	calla	pal_find
;	andi	0ff00h,a0
	move	a0,a10


	callr	obj_ckpal
	rets


	move	a10,a1			;dest pal
	ori	52,a1	;26*16,a1	;26
	movi	#blue_shad,a0		;pal data
	movk	3,a2			;3 colours
	calla	pal_set
	rets

#blue_shad
	.word	0<<10+3<<5+6	;2
	.word	0<<10+2<<5+4	;6
	.word	0<<10+0<<5+0	;52


#*****************************************************************************
;challenger needed / teammate needed message
;on name entry screen
;a10 = player (0-3)

	.asg	115-10+NAMENT_PAGE,CHALLY

 SUBR	challenger

	move	a10,a0
	sll	4,a0
	addi	#chall_x,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not_2p
	addi	4*16,a0
#not_2p
	move	*a0,a0
	sll	16,a0			;x val
	movi	[CHALLY,0],a1		;y val
	move	@gmqrtr,a2
	cmpi	2,a2
	jrnz	#skp
	movi	[CHALLY+256,0],a1	;y val
#skp
	movi	CHALENG,a2		;* image
	movi	1000,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2

#isoff
	calla	obj_off
	SLEEPK	1
	move	@PSTATUS,a0
	btst	a10,a0
	jrz	#ison

	move	@PSTATUS,a0
	btst	a10,a0

	jrnz	#isoff
#ison
	move	@PSTATUS2,a0
	btst	a10,a0
	jrz	#ison2

	movi	continue,a0		;* image
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	calla	obj_on

#wait
	move	@can_enter_inits,a0	;finished initials entry?
	jrz	#done
	SLEEPK	1
	move	@PSTATUS,a0
	btst	a10,a0
	jrz	#wait

#ison2

	calla	obj_on
#loop
	SLEEPK	1

	move	@can_enter_inits,a0	;finished initials entry?
	jrz	#done

	move	@PSTATUS,a0
	btst	a10,a0
	jrnz	#isoff

	move	@PCNT,a0		;frame count
	btst	6,a0
	jrnz	#nojoin

	movi	join3,a0		;* image
	jruc	#join

#nojoin

	movi	CHALENG,a0		;* image
	move	a10,a1
	xori	1,a1			;teammate bit
	move	@PSTATUS,a2
	btst	a1,a2
	jrz	#ischall
	movi	TMATE,a0		;* image
#ischall
#join
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image

	jruc	#loop

#done
	calla	DELOBJA8
	DIE

#chall_x	.word	52,149,246,342	;x val
		.word	0,101,295,0	;x val


#*****************************************************************************
;challenger needed message
;on team selection screen
;a10 = team (0-1)

	.asg	172-14+TEAMSEL_PAGE,CHALLY

 SUBR	challenger2

	move	a10,a0
	sll	4,a0
	addi	#chall_x,a0
	move	*a0,a0
	sll	16,a0			;x val
	movi	[CHALLY,0],a1		;y val
	movi	CHALENG,a2		;* image
	movi	1000,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2

	move	a10,a11			;(0-1)
	sll	4,a11			;x 16 bits
	addi	team1,a11		;team1 or team2
#isoff
	calla	obj_off
	SLEEPK	1
	move	*a11,a0
	jrnn	#isoff

	calla	obj_on
#loop
	SLEEPK	1
	move	*a11,a0
	jrnn	#isoff

	movi	CHALENG,a0		;* image
	move	@PCNT,a1		;frame count
	btst	6,a1
	jrnz	#nojoin
	movi	join3,a0		;* image
#nojoin
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image

	jruc	#loop

#chall_x	.word	101,295		;x val

	.def	guyhds
guyhds
	.long	DRX_PRT
	.long	POR_PRT		;21 PORTLAND
	.long	ROB_PRT		;21 PORTLAND
	.long	GRT_PRT		;21 PORTLAND
	.long	WOR_LAK
	.long	DIV_LAK		;12 L.A. LAKERS
	.long	PEE_LAK		;12 L.A. LAKERS
	.long	CAM_LAK		;12 L.A. LAKERS
	.long	BRK_PHX
	.long	MAJ_PHX		;20 PHOENIX
	.long	JOH_PHX		;20 PHOENIX
	.long	WLK_ATL
;	.long	MAN_CLP
	.long	HRP_CLP		;11 L.A. CLIPPERS
	.long	ROB_CLP		;11 L.A. CLIPPERS
	.long	HRD_GLD
	.long	MUL_GLD		;08 GOLDEN STATE
	.long	WEB_GLD		;08 GOLDEN STATE
	.long	KMP_SEA
	.long	PAY_SEA		;24 SEATTLE
	.long	GIL_SEA		;24 SEATTLE
	.long	SCH_SEA		;24 SEATTLE
	.long	TIS_SAC
	.long	WEB_SAC		;22 SACRAMENTO
	.long	SIM_SAC		;22 SACRAMENTO
	.long	HUR_SAC		;22 SACRAMENTO
	.long	RIC_SAC		;22 SACRAMENTO
	.long	OLA_HOU
	.long	SMT_HOU		;09 HOUSTON
	.long	MAX_HOU		;09 HOUSTON
	.long	ELL_DET		;07 DETROIT
;	.long	HOR_HOU		;09 HOUSTON
	.long	ROB_SAN
	.long	ELS_SAN
	.long	ROD_SAN		;23 SAN ANTONIO
	.long	MLN_UTA
	.long	BEN_UTA
	.long	STK_UTA		;25 UTAH
	.long	HRN_PHL		;19 PHILADELPHIA
;	.long	STE_WILM
	.long	MAS_DAL		;05 DALLAS
;	.long	HPR_DAL		;05 DALLAS
	.long	JAC_DAL
	.long	LTN_MIN
	.long	RID_MIN
	.long	PRS_MIN		;15 MINNESOTTA
;	.long	TOS_WILM
	.long	MUT_DEN
	.long	ELL_DEN		;06 DENVER
	.long	ROG_DEN		;06 DENVER
	.long	PIP_CHI
	.long	GRT_CHI		;03 CHICAGO
	.long	ARM_CHI		;03 CHICAGO
	.long	KUK_CHI		;03 CHICAGO
	.long	THM_DET
;	.long	LAM_DET		;07 DETROIT
	.long	DUM_DET		;07 DETROIT
	.long	HUN_DET		;07 DETROIT
;	.long	ELL_DET		;07 DETROIT
	.long	HOR_HOU		;09 HOUSTON
	.long	MIL_IND
	.long	SMI_IND		;10 INDIANA
	.long	SEL_IND		;10 INDIANA
	.long	PRC_CLE
	.long	NAN_CLE
	.long	DAU_CLE		;04 CLEVELAND
	.long	LOH_MLW
	.long	EDW_MLW		;14 MILWAUKEE
	.long	BAK_MLW		;14 MILWAUKEE
	.long	DAY_MLW		;14 MILWAUKEE
	.long	MAN_CLP
;	.long	WLK_ATL
	.long	AUG_ATL		;00 ATLANTA
	.long	WLS_ATL		;00 ATLANTA
	.long	JON_CHA
	.long	MOU_CHA
	.long	HWK_CHA
;	.long	HRN_PHL		;19 PHILADELPHIA
	.long	BRA_PHL		;19 PHILADELPHIA
	.long	WEA_PHL		;19 PHILADELPHIA
	.long	MCD_BOS
	.long	BRO_BOS		;01 BOSTON
	.long	GAM_BOS		;01 BOSTON
	.long	EWG_NEY
	.long	OAK_NEY		;17 NEW YORK
	.long	MAS_NEY		;17 NEW YORK
	.long	STA_NEY		;17 NEW YORK
	.long	HPR_DAL		;05 DALLAS
	.long	COL_NEJ
	.long	AND_NEJ		;16 NEW JERSEY
	.long	MOR_NEJ		;16 NEW JERSEY
	.long	BEN_NEJ		;16 NEW JERSEY
	.long	GUG_WAS
	.long	ELL_WAS		;26 WASHINGTON
	.long	CHE_WAS		;26 WASHINGTON
	.long	AND_ORL
	.long	SKL_ORL		;18 ORLANDO
	.long	HAR_ORL		;18 ORLANDO
;	.long	IUZ_ORL		;18 ORLANDO
	.long	RCE_MIA
	.long	SKL_MIA		;13 MIAMI
	.long	MIN_MIA		;13 MIAMI

	.def	our_heads
	.def	MRK_TURM,SHA_LIPM,TON_GOSM,JON_CARM,SAL_DIVM
	.def	JON_HEYM,JAM_RIVM,SCO_MK2,REP_MK2,SUB_MK2
	.def	WLK_ATL,RAD_MK2,AUG_ATL,HRD_GLD,MUL_GLD
our_heads
	.long	TON_GOSM	;0
	.long	JAM_RIVM	;1
	.long	JON_CARM	;2
	.long	SAL_DIVM	;3
	.long	SHA_LIPM	;4
	.long	MRK_TURM	;5
	.long	JON_HEYM	;6
	.long	GEO_PET		;7
	.long	JON_NEW		;8
	.long	SHE_OUR		;9
	.long	AL_LASC		;10
	.long	WIL_WILM	;11
	.long	CAR_MED		;12
	.long	DAN_FOR		;13
	.long	ERC_KIN		;14
	.long	EUG_JAR		;15
	.long	SUB_MK2		;16
	.long	JAC_HAG		;17
	.long	JAK_SIM		;18
	.long	JIM_GRN		;19
	.long	JIM_GEN		;20
	.long	JOE_DIL		;21
	.long	JON_LOW		;22
	.long	JON_VOG		;23
	.long	JOS_TSU		;24
	.long	LAR_DUM		;25
	.long	LIN_DEL		;26
	.long	MAT_BUT		;27
	.long	MRK_LOF		;28
	.long	MRK_PEN		;29
	.long	PAL_BAR		;30
	.long	PAT_COX		;31
	.long	RAD_MK2		;32
	.long	REA_PER		;33
	.long	RAY_MOS		;34
	.long	ROG_SHR		;35
	.long	STE_BER		;36
	.long	TIM_COM		;37
	.long	VIK_APE		;38
	.long	VNC_PON		;39
	.long	VOG_HED		;40
	.long	WAR_DAV		;41
	.long	ED_BOON		;42
	.long	JON_TOB		;43
	.long	PAL_HEI		;44
	.long	BIL_DAB		;45
	.long	MAR_MAR		;46
	.long	RAC_DAV		;47
	.long	KAR_HOS		;48
	.long	LOR_OLI		;49
	.long	SCO_MK2		;50
	.long	REP_MK2		;51
	.long	CHR_GRA		;52
	.long	RAY_GAY		;53
	.long	JAS_FLA		;54
	.long	JOE_LIN		;55	Linhoff

	.long	WLK_ATL  	;56
	.long	BRO_BOS 	;57
	.long	MOU_CHA 	;58
	.long	PIP_CHI   	;59
	.long	THM_DET 	;60
	.long	WEB_GLD  	;61
	.long	OLA_HOU  	;62
	.long	COL_NEJ	  	;63
	.long	EWG_NEY 	;64
	.long	BRK_PHX	  	;65
	.long	ROB_SAN  	;66
	.long	KMP_SEA		;67
	.long	MLN_UTA  	;68

	.end

