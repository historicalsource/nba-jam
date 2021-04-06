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
	.file	"select.asm"
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
;	.include	"mugshot.tbl"

	.include	"imgtbl.glo"
	.include	"imgtblp.glo"
	.include	"imgtbl2.glo"
	.include	"bgndtbl.glo"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"shawn.hdr"


	.def	_DAL	;27
	.def	_MIN	;26
	.def	_MI	;22
	.def	_WAS	;21
	.def	_PHI	;25
	.def	_SAC	;24
	.def	_MIL	;18
	.def	_DEN	;23
	.def	_GOL	;20
	.def	_SAN	;19
	.def	_SEA	;17
	.def	_ATL	;16
	.def	_ORL	;15
	.def	_LAC	;14
	.def	_NJ	;13
	.def	_CHA	;12
	.def	_BOS	;11
	.def	_CLE	;10
	.def	_DET	;9
	.def	_HOU	;8
	.def	_IND	;7
	.def	_LAL	;6
	.def	_UTA	;5
	.def	_NY	;4
	.def	_POR	;3
	.def	_PHX	;2
	.def	_CHI	;1

	.def	logos
	.def	game_purchased

	.def	get_teams_pop

	.global	initials_entry

	.ref	OBJOFF,OBJON
	.ref	WLK_ATL,RAD_MK2,AUG_ATL,HRD_GLD,MUL_GLD
	.ref	our_heads,SCO_MK2,REP_MK2,SUB_MK2
	.ref	speech_playovrp
	.ref	baby_flag
	.ref	challenger2,our_names
	.ref	challenger
	.ref	brown_shadow
 	.ref	blue_shadow
	.ref	attrib_off
	.ref	attrib_on
	.ref	update_attribs

	.ref	check_suckup
	.ref	player_attribs
	.ref	SQTR_R_P
	.ref 	SQTR_B_P
	.ref	set_imgs,SQUD_1,SQUD_2
	.ref	ingame_mess
	.ref	TWOPLAYERS			;0 = NO, 1 = YES 2 players

	.ref	get_all_sticks_cur
	.ref	get_all_sticks_down
	.ref	get_all_buttons_cur
	.ref	get_all_buttons_down
	.ref	get_all_starts_down
	.ref	get_but_val_down
	.ref	get_stick_val_cur
	.ref	get_but_val_down_nt
	.ref	get_but_val_cur
	.ref	get_stick_val_down
	.ref	get_steal_but_cur
	.ref	get_team1_turbo,get_team2_turbo

	.ref	timeout,timeout2,timeout3
	.ref	matchup_screen
	.ref	check_initials


	.ref	COLTAB
	.ref	CYCLE_TABLE

	.ref	snd_play1ovr
	.ref	call_team_name,call_matchup
	.ref	plyrsdropped
	.ref	newplyrs,player_names
	.ref	newptr,player_heads
	.ref	CR_CONTP
	.ref	dropout_stats
	.ref	qtr_purchased,game_over
	.ref	gmqrtr
	.ref	get_initials_string

	.ref	message_buffer
	.ref	dec_to_asc,print_string_C
	.ref	mess_cursx,copy_string
	.ref	mess_line_spacing
	.ref	setup_message,print_string_C2
	.ref	osgemd_ascii
	.ref	arrow1t,arrow2t,arrow3t,arrow4t
	.ref	horn_snd
	.ref	get_all_records
	.ref	sort_wins
	.ref	RNDRNG0
	.ref	P1DATA,P2DATA,P3DATA,P4DATA
	.ref	get_player_record
	.ref	print_player_stats
	.ref	print_teams_defeated
	.ref	GAMSTATE

	.ref	CRED_P
	.ref	PCNT,HALT
	.ref	pal_find
	
	.ref	scores
	.ref	conttimers
	.ref	tvpanelon

;	in MAIN.ASM
	.ref	DELBOBJ

;sounds

	.ref	cntdown_snd
win_snd		.word	>f3ff,>8,>80a5,0	;Winner snd/Suckup credits
tune1end_snd	.word	>f3fe,1,>8004,0		;End team select tune
tune1_snd	.word	>f3fe,10,>8001,0	;team select screen
cursor_snd1	.word	>f3f7,>8,>8080,0	;cursor movement
cursor_snd2	.word	>f3f7,>8,>8081,0	;
cursor_snd3	.word	>f3f7,>8,>8082,0	;
cursor_snd4	.word	>f3f7,>8,>8083,0	;
select_snd1	.word	>f3f7,>8,>8084,0	;select option sound
select_snd2	.word	>f3f7,>8,>8085,0	;
select_snd3	.word	>f3f7,>8,>8086,0	;
select_snd4	.word	>f3f7,>8,>8087,0	;
fullgame_snd1	.word	>f3f7,>8,>8088,0	;fullgame purchase
fullgame_snd2	.word	>f3f7,>8,>8089,0	;
fullgame_snd3	.word	>f3f7,>8,>808a,0	;
fullgame_snd4	.word	>f3f7,>8,>808b,0	;
scroll_snd	.word	>f3ff,>8,>8097,0	;Scroll snd
welcm_snd	.word	>f990,40,>81cb,0	;Welcome
baddec_snd	.word	>f990,72,>81b7,0	;bad decision		<--change!

cursor_sounds
	.long	cursor_snd1,cursor_snd2
	.long	cursor_snd3,cursor_snd4

select_sounds
	.long	select_snd1,select_snd2
	.long	select_snd3,select_snd4

;symbols defined in this file

	.def	name_sort

;symbols defined externally

	.global	player1_data,player2_data,player3_data,player4_data

	.ref	strongmen
	.ref	print_ranking
	.ref	show_hiscore
	.ref	show_player_records
	.ref	GET_AUD,AUD,AUD1
	.ref	COLRTEMP
	.ref	cntrs_delay
	.ref	KILBGND
	.ref	BAKMODS,BGND_UD1,CLR_SCRN
	.ref	pal_clean,pal_getf
	.ref	GET_ADJ
	.ref	pal_set
	.ref	PSTATUS,PSTATUS2
	.ref	dpageflip
	.ref	IRQSKYE
	.ref	WIPEOUT
	.ref	BINBCD

	.def	inmatchup
	.bss	inmatchup,16
	BSSX	kp_ram,		10*32
;ram
	BSSX	credit1_obj,	32	;10's object
	BSSX	credit2_obj,	32	;1's object
	BSSX	credit3_obj,	32	;CREDIT or FREE PLAY object
	.bss	exit_status,	16
				                                                              
	.bss	credtime1_obj,	32*1	;
	.bss	credtime2_obj,	32*1	;
	.bss	credtime3_obj,	32*1	;
	.bss	credtime4_obj,	32*1	;

	BSSX	name1_obj,	32
	BSSX	name2_obj,	32
	BSSX	name3_obj,	32
	BSSX	name4_obj,	32

	BSSX	attrib1_obj,	32*9
	BSSX	attrib2_obj,	32*9
	BSSX	attrib3_obj,	32*9
	BSSX	attrib4_obj,	32*9


	.bss	head1_obj,	32
	.bss	head2_obj,	32
	.bss	head3_obj,	32
	.bss	head4_obj,	32

	BSSX	teamset1_obj,	32
	BSSX	teamset2_obj,	32

	.bss	logo1_obj,	2*32
	.bss	logo2_obj,	2*32

	.bss	message1_obj,	32
	.bss	message2_obj,	32
	.bss	message3_obj,	32
	.bss	message4_obj,	32

	.bss	team1,		16
	.bss	team2,		16
	.bss	team1_control,	16	;player selecting team 1
	.bss	team2_control,	16	;player selecting team 2
	.global	team1,team2
	.global	team1_control,team2_control
	BSSX	oteam1,		16	;Used to keep original court colors

	.bss	enter_initials,	16
	BSSX	can_enter_inits,16
	.bss	game_purchased,	16	;full game purchase
	BSSX	page_scrolling,	16	;0=no, 1=yes

	.bss	plate1_objs,	2*32	;plate behind heads & logo
	.bss	plate2_objs,	2*32	; " " "

	BSSX	force_selection,16
	BSSX	in_team_select,16

	BSSX	special_heads,16*4	;-1 = normal player head

;	BSSX	player_toggle1,	16	;0 = no toggle
;	BSSX	player_toggle2,	16	;must follow player_toggle1!!!

	.bss	bigroster1,	16
	.bss	bigroster2,	16

	.bss	tm1taps,	16	;For powering up big roster
	.bss	tm2taps,	16
	.bss	dbnce1,		16
	.bss	dbnce2,		16
	.bss	tm1swrl,	16
	.bss	tm2swrl,	16

	.bss	toggle1_time,	16
	.bss	toggle2_time,	16
	.bss	switch_1,16
	.bss	switch_2,16
	.bss	team1_switch,16
	.bss	team2_switch,16

NUM_TEAMS	equ	27

	BSSX	tm1set,(NUM_TEAMS+1)*16
	BSSX	tm2set,(NUM_TEAMS+1)*16

	.bss	teams_pop,	NUM_TEAMS*32
	.bss	sorted_teams,	NUM_TEAMS*16

	BSSX	fatality,16		;Fatality 0,1,2, or 3 for both teams
	BSSX	winningteam,16

	.bss	fixbug,16

	.text

TEAMSEL_PAGE	equ	0*256
NAMENT_PAGE	equ	1*256
YESNO_PAGE	equ	2*256

XTRA_CRTIME	equ	>7fff		;20*60
MAX_CRTIME	equ	>7fff		;30*60

_ATL	equ 0
_BOS	equ 1
_CHA	equ 2
_CHI	equ 3
_CLE	equ 4
_DAL	equ 5
_DEN	equ 6
_DET	equ 7
_GOL	equ 8
_HOU	equ 9
_IND	equ 10
_LAC	equ 11
_LAL	equ 12
_MI	equ 13
_MIL	equ 14
_MIN	equ 15
_NJ	equ 16
_NY	equ 17
_ORL	equ 18
_PHI	equ 19
_PHX	equ 20
_POR	equ 21
_SAC	equ 22
_SAN	equ 23
_SEA	equ 24
_UTA	equ 25
_WAS	equ 26
_MK2	equ 27		;Special defeated all 27 teams - MK2

#******************************************************************************

SCROLL_SPEED	equ	8

 SUBRP	initials_entry

 .if 0
	JSRP	show_player_records
 .endif

 .if 0
	clr	a0			;cycle through hiscore stuff
#whopper
	PUSHP	a0
	JSRP	show_hiscore
	PULLP	a0
	inc	a0
	jruc	#whopper
 .endif

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	clr	a0
	move	a0,@HALT
	move	a0,@in_team_select
	move	a0,@toggle1_time
	move	a0,@toggle2_time
	move	a0,@strongmen

	movk	27,a1
	movi	tm1set,a2
	movi	tm2set,a3
#lp	move	a0,*a2+
	move	a0,*a3+
	dsjs	a1,#lp


	movi	-1,a0
	move	a0,@team1		;no teams selected
	move	a0,@team2
	move	a0,@team1_control	;player selecting team 1
	move	a0,@team2_control	;player selecting team 2

	move	a0,@special_heads
	move	a0,@special_heads+10h
	move	a0,@special_heads+20h
	move	a0,@special_heads+30h

	move	a0,@bigroster1
	move	a0,@bigroster2

	clr	a0
	move	a0,@tm1swrl
	move	a0,@tm2swrl
	move	a0,@tm1taps
	move	a0,@tm2taps
	move	a0,@page_scrolling	;not scrolling
	move	a0,@team1_switch
	move	a0,@team2_switch
	move	a0,@baby_flag

	movi	tune1_snd,a0
	calla	snd_play1ovr

	movi	MAX_CRTIME,a0
	move	a0,@cntrs_delay

	movi	-1,a0			;init all 4 players data to -1
	movi	player1_data,a1
	movi	4*PR_SIZE/16,a2		;4 players @ PR_SIZE words each
#init_loop
	move	a0,*a1+
	dsj	a2,#init_loop

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	4<<10+4<<5+7,a0
	move	a0,@IRQSKYE

	SLEEPK	1
;	CALLA	COLRPRC

;	movi	PALFRAM+PALRSIZ,a2	;>Steal pals 1-3
;	movi	junkp,a1
;	movk	3,a3
;#loop	move	a1,*a2+,L
;	dsj	a3,#loop

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	movi	[YESNO_PAGE,0],a0
	move	a0,@WORLDTLY,L

	SLEEPK	2

	CREATE0	strt_snd

	movi	name_entry_mod,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not2

	movi	name_entry_kit_mod,a0
#not2
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	calla	blue_shadow

	calla	create_bits


	CREATE0	monitor_buyins
	CREATE0	team_control


	CREATE0	credits
	CREATE0	credit_messages
	CREATE0	monitor_fullgame


	movk	1,a0
	move	a0,@DISPLAYON
	SLEEPK	2
	calla	display_unblank


	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrs

	.ref	winner_stays_box
	JSRP	winner_stays_box	;skip if 2 player kit
#2_plyrs


	movi	#init_setup,a2
	calla	setup_message

	.global	mess_objid

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid
	movk	22,a0
	move	a0,@mess_line_spacing
	movi	#str_init,a4
	calla	print_string_C2

	calla	scrnrel_off

	calla	create_text

	movi	[200-57,0],a0		;x val
	movi	[62-3,0],a1		;y val
	movi	yesnobak,a2		;* image
	movk	5,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPTEXT,a5		;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ

	SLEEP	TSEC-30

	clr	a9
	clr	a10
	movi	20*TSEC,a7
#input_loop
	PUSHP	a7
	move	a10,a11			;last cursor pos
	calla	get_all_sticks_cur
	btst	1,a0			;down
	jrz	#no_down
	movk	1,a10
#no_down
	btst	0,a0			;up
	jrz	#no_up
	clr	a10
#no_up
	move	a10,a0
	sll	4,a0			;x 16 bits
	addi	#ypos,a0
	move	*a0,a0
	move	*a8(OYPOS),a1
	andni	0ffh,a1			;or in page offset
	or	a1,a0
	move	a0,*a8(OYPOS)		;new cursor Y

	cmp	a10,a11
	jreq	#no_change
	SOUND1	cursor_snd1
	clr	a9
#no_change

	btst	4,a9
	jrz	#ison
	calla	obj_off
	jruc	#skip
#ison
	calla	obj_on
#skip
	inc	a9

	SLEEPK	1

;;	move	@PSTATUS,a0
;;	jrz	#timed_out

	PULLP	a7
	dec	a7
	jrnz	#no_timeout
	movk	1,a10			;no initials
	move	*a8(OYPOS),a1
	andni	0ffh,a1			;or in page offset
	movi	129-3,a0
	or	a0,a1
	move	a1,*a8(OYPOS)
	jruc	#timeout
#no_timeout
	calla	get_all_buttons_down
	jrz	#input_loop
#timeout

	calla	obj_on
	movi	0f0fh,a0
	move	a0,*a8(OCONST)

	SOUND1	select_snd1
	movk	3,a11
#again
	calla	const_on
	SLEEPK	3
	calla	const_off
	SLEEPK	3
	dsj	a11,#again

	SLEEP	20

	xori	1,a10			;1 = yes, 0 = no
	move	a10,@enter_initials
	jrz	#skip_name

	movi	cheer_snd,a0
	calla	snd_play1

	movi	AUD_INITENTRD,a0	;inc initials entered audit
	calla	AUD1

	calla	del_offscreen_bobjs
	JSRP	name_entry

	move	@PSTATUS,a0
	jrz	#timed_out
	jruc	#do_teamsel
#skip_name
	movi	boo1_snd,a0
	calla	snd_play1

	calla	KILBGND			;Kill old background
	calla	pal_clean

	movi	[NAMENT_PAGE,0],a0
	move	a0,@WORLDTLY,L
	movi	[NAMENT_PAGE,0],a0
	move	a0,@WORLDTL,L

	movi	name_entry2_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1




	movi	#init_setup2,a2
	calla	setup_message
	movi	CLSDEAD|123,a0
	move	a0,@mess_objid
	movk	22,a0
	move	a0,@mess_line_spacing
	movi	#str_init,a4
	calla	print_string_C2

	calla	scrnrel_off

	calla	create_text


#do_teamsel

	calla	del_offscreen_bobjs

	JSRP	team_selection

	movk	25,a10
#waitabit
	SLEEPK	1
	move	@team1,a0
	move	@team2,a1
	and	a0,a1
	move	a1,a1
	jrn	#timed_out
	dsj	a10,#waitabit

	.ref	select_teams
	calla	select_teams

	movi	horn_snd,a0
	calla	snd_play1

;	SOUND1	tune1end_snd

	movk	1,a0
	move	a0,@inmatchup

	JSRP	matchup_screen

	clr	a0
	move	a0,@in_team_select
	move	a0,@inmatchup

#timed_out
	RETP

strt_snd	
	SLEEP	>d8
	movi	welcm_snd,a0
	calla	snd_play1
	DIE


 SUBRP	scrnrel_off

	movi	OBJLST,a14
#lp8
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a2
	cmpi	CLSDEAD|123,a2
	jrne	#lp8
	move	*a14(OFLAGS),a0
	andni	M_SCRNREL,a0		;turn off screen relative
	move	a0,*a14(OFLAGS)
	movk	6,a0
	move	a0,*a14(OZPOS)
	jruc	#lp8
#x	rets


#ypos	.word	62-3,129-3


#init_setup
	RJR_STR	osgemd_ascii,10,0,199,12+YESNO_PAGE,WHITEPAL,0
#init_setup2
	RJR_STR	osgemd_ascii,10,0,199,12+NAMENT_PAGE,WHITEPAL,0
#str_init
	.string	"enter initials for",1
	.string	"record keeping?",0


cheer_snd	.word	>f898,10,>8144,0	;Quick cheer
cheer1_snd	.word	>fd84,80,>8111,0	;Long cheer
cheer2_snd	.word	>f894,80,>8144,0	;Long cheer
cheer3_snd	.word	>fc84,120,>814e,0	;Long cheer
boo1_snd	.word	>f884,120,>814a,0	;Boo
	.even


#******************************************************************************

 SUBRP	delete_text

	movi	TYPTEXT,a0			;object ID
	clr	a1				;mask
	calla	obj_delc
	rets

#******************************************************************************

 SUBRP	create_text

	movk	5,a4
	movi	#images,a5
#initext
	movi	LGMDGLD,b0
	move	*a5+,a0				;x val
	sll	16,a0
	move	*a5+,a1				;y val
	sll	16,a1
	move	*a5+,a2,L			;* image
	PUSH	a4,a5
	movk	6,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	movi	TYPTEXT,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP
	PULL	a4,a5
	dsj	a4,#initext

	rets


	.asg	62,Y1
	.asg	129,Y2
	.asg	200-52,X1
	.asg	200-39,X2
#images
	.word	X1,Y1
	.long	lgmd_Y

	.word	X1+38+3,Y1
	.long	lgmd_E

	.word	X1+38+3+30+3,Y1
	.long	lgmd_S

	.word	X2,Y2
	.long	lgmd_N

	.word	X2+38+3,Y2
	.long	lgmd_O


#******************************************************************************

 SUBRP	name_entry

	clr	a0
	move	a0,@force_selection

	movk	1,a0
	move	a0,@can_enter_inits	;can enter initials

	calla	get_all_records
	calla	sort_wins

	movk	1,a10
	CREATE0	player_cursor
	movk	1,a10			;player 2
	CREATE0	challenger
	movk	2,a10
	CREATE0	player_cursor
	movk	2,a10			;player 3
	CREATE0	challenger

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrs

	clr	a10
	CREATE0	player_cursor
	clr	a10			;player 1
	CREATE0	challenger
	movk	3,a10
	CREATE0	player_cursor
	movk	3,a10			;player 4
	CREATE0	challenger

#2_plyrs

	MOVI	[3,9],a8		;START AT COLOR 3, CYCLE 9 COLORS
	MOVI	SGMD8PLV,a9		;PAL NAME
	MOVI	COLTAB,a10		;TABLE TO CYCLE WITH
	MOVK	3,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID2,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	clr	a0
	move	a0,@exit_status

	movi	-SCROLL_SPEED<<16,a10
	JSRP	scroll_page

	calla	delete_text

	calla	brown_shadow

	movi	25*TSEC,a10
	CREATE	CNTDWN_PID,timeout

#wait_exit
	SLEEPK	1
	calla	update_credits

	move	@exit_status,a0
	jrnz	#wait_exit

	clr	a0
	move	a0,@can_enter_inits	;can't enter initials

	movi	CNTDWN_PID,a0
	calla	KIL1C

	movi	CYCPID2,a0		;kill cycler
	calla	KIL1C

	calla	delete_text

	RETP

#******************************************************************************

 SUBR	team_selection

	movk	8,a9				;palette
	movi	[32+TEAMSEL_PAGE,44],a10	;start y,x
	movi	city_table_left+2*16,a8		;* alpha table
	clr	a11				;object ID
	calla	display_alpha_table

	movk	9,a9				;palette
	movi	[32+TEAMSEL_PAGE,44],a10	;start y,x
	movi	city_table_right+2*16,a8	;* alpha table
	clr	a11				;object ID
	calla	display_alpha_table

	clr	a0
	move	a0,@exit_status
	move	a0,@force_selection
	move	a0,@fatality

	clr	a10
	CREATE0	challenger2
	movk	1,a10
	CREATE0	challenger2

	CREATE0	team1_cursor
	CREATE0	team2_cursor

	clr	a0
	calla	create_logos
	clr	a0
	calla	create_player_heads
	clr	a0
	calla	create_team_set
	CREATE0	create_team_set_flsh
	calla	update_team_set

	SLEEP	2

	calla	update_logos
	calla	update_player_heads

	movi	-SCROLL_SPEED<<16,a10
	JSRP	scroll_page
	movk	1,a0
	move	a0,@page_scrolling	;scrolling
                                        
	calla	find_plates		;find bgnd plate objects (for flashing)
	calla	delete_text

	calla	brown_shadow

	movk	1,a0
	move	a0,@in_team_select

	calla	del_offscreen_bobjs
	calla	create_player_names
	calla	update_player_names

;	movi	#press_setup,a2
;	calla	setup_message
;	movi	#str_press,a4
;	calla	print_string_C2

	SLEEPK	15

	clr	a0
	move	a0,@page_scrolling		;not scrolling

	.ref	blink_tmslct
	CREATE0	blink_tmslct

 SUBRP	subs_in

;Temp
;	movi	07ffffffh,a0
;	move	a0,@player3_data+PR_TEAMSDEF,L
;	move	a0,@player2_data+PR_TEAMSDEF,L

	move	@team1_control,a0	;player selecting team 1
	jrn	#not_bigrost
	sll	5,a0
	addi	defeated,a0
	move	*a0,a0,L
	move	*a0,a0,L	
	cmpi	07ffffffh,a0
	jrnz	#not_bigrost
	
	move	@team1_control,a4	;player selecting team 1
	movi	rosterblu,a9
	sll	4,a4			;x 16 bits
	addi	plaque_xs,a4
	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not_2p
	addi	4*16,a4
#not_2p
	move	*a4,a10
	sll	16,a10	
	clr	a0
	move	a0,@HALT
	CREATE0	fullgame_purchased

#not_bigrost

	move	@team2_control,a0	;player selecting team 1
	jrn	#not_bigrost2
	sll	5,a0
	addi	defeated,a0
	move	*a0,a0,L
	move	*a0,a0,L	
	cmpi	07ffffffh,a0
	jrnz	#not_bigrost2
	
	move	@team2_control,a4	;player selecting team 1
	movi	rosterred,a9
	sll	4,a4			;x 16 bits
	addi	plaque_xs,a4
	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not_2p2
	addi	4*16,a4
#not_2p2
	move	*a4,a10
	sll	16,a10	
	clr	a0
	move	a0,@HALT
	CREATE0	fullgame_purchased

#not_bigrost2





#wait_loop0
	movi	30*TSEC,a10
	CREATE	CNTDWN_PID,timeout

#wait_loop
	SLEEPK	1
	calla	update_logos
	calla	update_player_names
	calla	update_team_set
	calla	update_player_heads

	move	@exit_status,a0
	jrnz	#wait_loop

	movi	CNTDWN_PID,a0
	calla	KIL1C
	calla	delete_text

	CREATE0	suckup_credits

#wait_loop2
	SLEEPK	1

	calla	update_logos
	calla	update_player_names
	calla	update_team_set
	calla	update_player_heads

	move	@exit_status,a0
	jrnz	#wait_loop0

	calla	check_suckup		;wait for all credits
	jrz	#wait_loop2		;to be sucked up

	movi	TSEC+30,a10
#wait_loop3
	SLEEPK	1
	PUSH	a10
	calla	update_logos
	calla	update_player_names
	calla	update_team_set
	calla	update_player_heads
	PULL	a10
	dsj	a10,#wait_loop3

	RETP

;#press_setup
;	RJR_STR	osgemd_ascii,8,0,200,10-4,WHITEPAL,0
;#str_press
;	.string	"press button to select",0
	.even

#*****************************************************************************

BOX_IMG_WIDTH	equ	88
BOX_WIDTH	equ	80
BOX_HEIGHT	equ	95
OPEN_SPEED	equ	4
BOX_PSIZE	equ	6			;bits per pixel

 SUBRP	suckup_credits

	calla	check_suckup			;credits unused?
	jrnz	#snuffit

	movi	win_snd,a0
	calla	snd_play1

	movi	[200-4,0],a0			;x val
	movi	[132-20-BOX_HEIGHT/2,0],a1	;y val
	movi	growbox,a2			;* image
	movi	19999,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBMES2,a5	;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+0h),L

	movi	[200,0],a0			;x val
	movi	[132-20-BOX_HEIGHT/2,0],a1	;y val
	movi	growbox,a2			;* image
	movi	19999,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBMES2,a5	;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,*a13(PDATA+20h),L
	move	*a8(OSAG),a0,L
	move	a0,*a13(PDATA+40h),L

	move	*a13(PDATA+20h),a8,L
	movi	200,a0				;x val
	move	a0,*a8(OXPOS)
	move	*a13(PDATA+40h),a0,L		;OSAG
	addi	(BOX_IMG_WIDTH-4)*BOX_PSIZE,a0
	move	a0,*a8(OSAG),L
	movi	BOX_IMG_WIDTH-4,a0
	move	a0,*a8(OFSET)

	move	*a13(PDATA+0h),a8,L
	movi	200-4,a0			;x val
	move	a0,*a8(OXPOS)
	movi	BOX_IMG_WIDTH-4,a0
	move	a0,*a8(OFSET)

#open_box
	SLEEP	1

	move	*a13(PDATA+20h),a8,L
	move	*a8(OSAG),a0,L
	subi	OPEN_SPEED*BOX_PSIZE,a0
	move	a0,*a8(OSAG),L
	move	*a8(OFSET),a0
	subi	OPEN_SPEED,a0
	move	a0,*a8(OFSET)

	move	*a13(PDATA+0h),a8,L
	move	*a8(OFSET),a0
	subi	OPEN_SPEED,a0
	move	a0,*a8(OFSET)
	move	*a8(OXPOS),a0
	subi	OPEN_SPEED,a0
	move	a0,*a8(OXPOS)
	cmpi	200-BOX_WIDTH,a0
	jrhi	#open_box

	movi	[200,0],a0			;x val
	movi	[132-10-BOX_HEIGHT/2,0],a1	;y val
	movi	useupbx,a2			;* image
	movi	20000,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBMES2,a5	;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

#wait
	SLEEPK	1
	move	@exit_status,a0
	jrnz	#close_box0
	calla	check_suckup			;wait for all credits
	jrz	#wait				;to be sucked up

#close_box0
	calla	DELOBJA8
#close_box
	SLEEPK	1

	move	*a13(PDATA+20h),a8,L
	move	*a8(OSAG),a0,L
	addi	OPEN_SPEED*BOX_PSIZE,a0
	move	a0,*a8(OSAG),L
	move	*a8(OFSET),a0
	addi	OPEN_SPEED,a0
	move	a0,*a8(OFSET)

	move	*a13(PDATA+0h),a8,L
	move	*a8(OFSET),a0
	addi	OPEN_SPEED,a0
	move	a0,*a8(OFSET)
	move	*a8(OXPOS),a0
	addi	OPEN_SPEED,a0
	move	a0,*a8(OXPOS)
	cmpi	200-4,a0
	jrlo	#close_box
	SLEEPK	1
	movi	CLSNEUT|TYPTEXT|SUBMES2,A0
	calla	obj_del1c
#snuffit
	DIE



#*****************************************************************************

	.global	sorted_teams
	.global	teams_pop

 SUBRP	get_teams_pop

	clr	a0
	movi	teams_pop,a1		;zero all team selected counts
	movi	NUM_TEAMS,a2
#init_loop
	move	a0,*a1,L
	dsj	a2,#init_loop


	movi	AUD_WAS,a0		;audit number

#next_audit
	PUSH	a0
	calla	GET_AUD			;val in a1

	movi	-1,a10			;position
	movi	teams_pop-32,a4
	movi	sorted_teams-16,a5
#next_team
	addi	32,a4
	addi	16,a5
	inc	a10
	move	*a4,a0,L
	cmp	a0,a1			;a1-a0
	jrhs	#insert
	cmpi	NUM_TEAMS-1,a10
	jrlt	#next_team

#insert
	calla	bump_down
	move	a1,*a4,L
	PULL	a0
	move	a0,a1
	subi	AUD_ATL,a1
	move	a1,*a5
	dec	a0
	cmpi	AUD_ATL,a0
	jrhs	#next_audit

	rets


bump_down
	PUSH	a1
	cmpi	NUM_TEAMS-1,a10
	jreq	#no_bump

	movi	NUM_TEAMS-1,a3
	sub	a10,a3
	PUSH	a3				;num down shits required
	movi	NUM_TEAMS*32,a1
	addi	teams_pop,a1
	move	a1,a2
	subi	32,a2
#bump_loop1
	move	-*a2,-*a1,L
	dsj	a3,#bump_loop1

	PULL	a3
	movi	NUM_TEAMS*16,a1
	addi	sorted_teams,a1
	move	a1,a2
	subi	16,a2
#bump_loop2
	move	-*a2,-*a1
	dsj	a3,#bump_loop2

#no_bump
	PULL	a1
	rets


#*****************************************************************************

 SUBRP	print_initials

	clr	a5
	movk	1,a7				;num objs

	move	*a13(PC_NAM1OBJ),a8,L
	calla	obj_off
	move	*a13(PC_NAM2OBJ),a8,L
	calla	obj_off
	move	*a13(PC_NAM3OBJ),a8,L
	calla	obj_off

	move	*a13(PC_DATADDR),a2,L		;start of player data
	move	*a2+,a0
	move	*a13(PC_NAM1OBJ),a8,L
	move	*a8(OIMG),a0,L
	cmpi	OSGEMD_SPC,a0
	jreq	#is_space1
	calla	obj_on
#is_space1
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

	move	*a2+,a0
	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_NAM2OBJ),a8,L
	move	*a8(OIMG),a0,L
	cmpi	OSGEMD_SPC,a0
	jreq	#is_space2
	calla	obj_on
#is_space2
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

	move	*a2,a0
	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_NAM3OBJ),a8,L
	move	*a8(OIMG),a0,L
	cmpi	OSGEMD_SPC,a0
	jreq	#is_space3
	calla	obj_on
#is_space3
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

#skip
	inc	a5				;+ 1/2
	srl	1,a5				;width / 2
	move	*a13(PC_CENTERX2),a6
	move	@TWOPLAYERS,a0			;0 = NO, 1 = YES 2 players
	jrz	#no_2p
	move	*a13(PC_CENTERXkit),a6
#no_2p
	sub	a5,a6				;center - width/2

	movi	PC_NAM1OBJ,a4
	add	a13,a4
#loop
	move	*a4+,a2,L		;* object
	move	a6,*a2(OXPOS)
	move	*a2(OSIZEX),a0		;width of object
	add	a0,a6
	addk	2,a6			;2 pixel spacing
	dsj	a7,#loop		;another img?
	rets

#*****************************************************************************
;returns a8 = * alpha table

 SUBRP	get_menu_data

	clr	a0
	move	a0,*a13(PC_CURSPOS)	;position
	move	*a13(PC_OBJID),a11	;OBJ ID
	move	*a13(PC_MENUBASE),a1,L
	move	*a13(PC_MENULEVEL),a8
	sll	5,a8			;x 32 bits
	add	a1,a8
	move	*a8,a8,L		;get start addr
	move	*a8+,a9			;palette number
	move	*a8+,a10
	move	a10,*a13(PC_STARTX)	;menu start x
	move	*a8+,a0
	move	a0,*a13(PC_STARTY)	;menu start y
	sll	16,a0			;top word
	movy	a0,a10			;[yy,xx] format
	move	*a8,a8,L		;table addr
	move	*a8+,a1
	move	a1,*a13(PC_TABWIDTH)	;table width
	move	*a8+,a1
	move	a1,*a13(PC_TABSIZE)	;table size
	move	a8,*a13(PC_TABLE),L
	rets

#*****************************************************************************

 SUBRP	create_menu

	calla	get_menu_data
	calla	display_alpha_table	;create table of objects
	rets

#*****************************************************************************
;switch vals in a0 (starting at bit0)

 SUBRP	move_team_cursor

	andi	01111b,a0
	sll	5,a0			;x 32 bits
	addi	joy_moves,a0
	move	*a0,a0,L
	call	a0

	rets

#*****************************************************************************
;switch vals in a0 (starting at bit0)

 SUBRP	move_cursor

	andi	01111b,a0
	sll	5,a0			;x 32 bits
	addi	joy_moves,a0
	move	*a0,a0,L
	call	a0
	rets


#*****************************************************************************

 SUBRP	update_statbox_images

	move	*a13(PC_CHARPOS),a0
	sll	5,a0			;x 32 bits
	addi	#curspos_actions,a0
	move	*a0,a0,L
	jump	a0
	rets

*****************************
#curspos_actions
	.long	#name0,#name1,#name2,#month,#day

*****************************
#name0
#name1
#name2
	move	*a13(PC_CHARPOS),a0	;0 - 2
	sll	5,a0			;x 32 bits
	addi	PC_NAM1OBJ,a0
	add	a13,a0
	move	*a0,a8,L		;* object
	calla	update_image

	calla	print_initials


	rets


*****************************
#month
#day

	movi	PC_MONTHOBJ,a0
	add	a13,a0
	move	*a0,a8,L		;* object
	calla	update_image

	move	*a13(PC_MONTHOBJ),a4,L
	move	*a4(OSIZEX),a3			;width of object
	inc	a3				;+ 1/2
	srl	1,a3				;width / 2
	move	*a13(PC_CENTERX),a2
	move	@TWOPLAYERS,a0			;0 = NO, 1 = YES 2 players
	jrz	#no_2p
	move	*a13(PC_CENTERXkit),a2
#no_2p
	sub	a3,a2				;center - width/2
	move	a2,*a4(OXPOS)

	rets

#*****************************************************************************
* A8=*Obj

 SUBRP	update_image

	move	*a8(OYPOS),a0
	andni	400h,a0			;onscreen Y
	move	a0,*a8(OYPOS)
	calla	get_table_address	;returns * entry in a1
	move	*a1+,a1			;char under cursor
	sll	5,a1			;x 32 bits
	addi	alpha_table,a1
	move	*a1,a0,L		;image addr
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	rets

#*****************************************************************************

	.asg	57,X1
	.asg	146,X2
	.asg	251,X3
	.asg	340,X4
	.asg	214+TEAMSEL_PAGE-12-2,PNAMES_Y

 SUBRP	create_player_names		;and attributes


	movi	[X1,0],a0			;x val
	movi	[PNAMES_Y,0],a1			;y val
	movi	WILKINS,a2			;* image
	move	@special_heads,b0
	jrn	#not_spec1
	sll	5,b0				;x 32 bits
	addi	our_names,b0
	move	*b0,b0,L
	move	b0,a2
#not_spec1
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	move	a8,@name1_obj,L

	movi	[X2,0],a0			;x val
	movi	[PNAMES_Y,0],a1			;y val
	movi	AUGMON,a2			;* image
	move	@special_heads+10h,b0
	jrn	#not_spec2
	sll	5,b0				;x 32 bits
	addi	our_names,b0
	move	*b0,b0,L
	move	b0,a2
#not_spec2
	calla	BEGINOBJ
	move	a8,@name2_obj,L

	movi	[X3,0],a0			;x val
	movi	[PNAMES_Y,0],a1			;y val
	movi	WILKINS,a2			;* image
	move	@special_heads+20h,b0
	jrn	#not_spec3
	sll	5,b0				;x 32 bits
	addi	our_names,b0
	move	*b0,b0,L
	move	b0,a2
#not_spec3
	calla	BEGINOBJ
	move	a8,@name3_obj,L

	movi	[X4,0],a0			;x val
	movi	[PNAMES_Y,0],a1			;y val
	movi	AUGMON,a2			;* image
	move	@special_heads+30h,b0
	jrn	#not_spec4
	sll	5,b0				;x 32 bits
	addi	our_names,b0
	move	*b0,b0,L
	move	b0,a2
#not_spec4
	calla	BEGINOBJ
	move	a8,@name4_obj,L


	movi	[X1-40,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	ATT_BLU,a2	;attribs,a2			;* image
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	move	a8,@attrib1_obj,L

	movi	[X2-40,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	ATT_BLU,a2	;attribs,a2			;* image
	calla	BEGINOBJ
	move	a8,@attrib2_obj,L

	movi	[X3-40,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	ATT_BLU,a2	;attribs,a2			;* image
	calla	BEGINOBJ
	move	a8,@attrib3_obj,L

	movi	[X4-40,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	ATT_BLU,a2	;attribs,a2			;* image
	calla	BEGINOBJ
	move	a8,@attrib4_obj,L

	movi	[X1-8,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	attrib1_obj+20h,a10
	calla	#create_attrib

	movi	[X2-8,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	attrib2_obj+20h,a10
	calla	#create_attrib

	movi	[X3-8,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	attrib3_obj+20h,a10
	calla	#create_attrib

	movi	[X4-8,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	attrib4_obj+20h,a10
	calla	#create_attrib

	rets

;a0  = x
;a1  = y
;a10 = * attrib obj
#create_attrib
	movk	8,a2				;# of attributes
	PUSH	a0,a1
#atloop
	PUSH	a0,a1,a2,a10
	movi	font60w,a2			;* image
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ
	PULL	a0,a1,a2,a10
	move	a8,*a10+,L
	addi	[6,0],a1
	cmpi	5,a2
	jrnz	#noadj

	PULL	a0,a1
	addi	[41,0],a0			;adjust x
#noadj
	dsj	a2,#atloop
	rets

#*****************************************************************************
*
* a0 = table offset to use for coordinates
*

 SUBR	create_player_heads

	PUSH	a10,a11

	sll	5,a0				;x 32 bits
	addi	#xy_starts,a0
	move	*a0,a10,L
	move	*a10+,a11
	sll	16,a11				;y pos


;	movi	HRD_GLD,a2			;* image
	movi	RAD_MK2,a2			;* image
	move	@special_heads,b0
	jrn	#nrmhd1
	sll	5,b0				;x 32 bits
	addi	our_heads,b0
	move	*b0,b0,L
	move	b0,a2
#nrmhd1
	move	*a10+,a0			;x val
	sll	16,a0
	move	a11,a1				;y pos
	movi	121,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@head1_obj,L



;	movi	MUL_GLD,a2			;* image
	movi	RAD_MK2,a2			;* image

	move	@special_heads+10h,b0
	jrn	#nrmhd2
	sll	5,b0				;x 32 bits
	addi	our_heads,b0
	move	*b0,b0,L
	move	b0,a2
#nrmhd2
	move	*a10+,a0			;x val
	sll	16,a0
	move	a11,a1				;y pos
	movi	DMAWNZ|M_FLIPH,a4		;DMA flags
	calla	BEGINOBJ2
	move	a8,@head2_obj,L

;	movi	WLK_ATL,a2			;* image
	movi	RAD_MK2,a2			;* image

	move	@special_heads+20h,b0
	jrn	#nrmhd3
	sll	5,b0				;x 32 bits
	addi	our_heads,b0
	move	*b0,b0,L
	move	b0,a2
#nrmhd3
	move	*a10+,a0			;x val
	sll	16,a0
	move	a11,a1				;y pos
	movi	DMAWNZ,a4			;DMA flags
	calla	BEGINOBJ2
	move	a8,@head3_obj,L

;	movi	AUG_ATL,a2			;* image
	movi	RAD_MK2,a2			;* image

	move	@special_heads+30h,b0
	jrn	#nrmhd4
	sll	5,b0				;x 32 bits
	addi	our_heads,b0
	move	*b0,b0,L
	move	b0,a2
#nrmhd4
	move	*a10,a0				;x val
	sll	16,a0
	move	a11,a1				;y pos
	movi	DMAWNZ|M_FLIPH,a4		;DMA flags
	calla	BEGINOBJ2
	move	a8,@head4_obj,L


	PULL	a10,a11

	rets

 SUBR	create_team_set_flsh

	SLEEP	3Ah

	move	@teamset1_obj,a8,L
	move	@teamset2_obj,a9,L

	movk	11,a10
#again
	movi	1717h,a2
	move	a2,*a8(OCONST)
	move	a2,*a9(OCONST)
	setf	4,0,0
	movk	M_CONNON,a0		;Replace non-zero data with constant
	move	a0,*a8(OCTRL)		;Write 4 low bits
	move	a0,*a9(OCTRL)		;Write 4 low bits
	setf	16,1,0

	SLEEPK	4

	setf	4,0,0
	movk	M_WRNONZ,a0
	move	a0,*a8(OCTRL)		;Write 4 low bits
	move	a0,*a9(OCTRL)		;Write 4 low bits
	setf	16,1,0

	SLEEPK	3

	dsj	a10,#again

	DIE


*****************************************************************************
*
* a0 = table offset to use for coordinates
*

 SUBR	create_team_set

	PUSH	a10,a11


	sll	5,a0				;x 32 bits
	addi	#xy_starts2,a0
	move	*a0,a10,L
	move	*a10+,a11
	sll	16,a11				;y pos


	movi	SQUD_1,a2			;* image
	move	*a10+,a0			;x val
	sll	16,a0
	move	a11,a1				;y pos
;	movi	221,a3				;z pos
	movi	30001,a3			;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@teamset1_obj,L



	movi	SQUD_2,a2			;* image
	move	*a10+,a0			;x val
	sll	16,a0
	move	a11,a1				;y pos
	movi	DMAWNZ,a4			;DMA flags
	calla	BEGINOBJ2
	move	a8,@teamset2_obj,L


	PULL	a10,a11

	rets

#xy_starts2
	.long	#stxy1a,#stxy2a

#stxy1a	.word	207-14-2			;Y
	.word	94+6,288+7

#stxy2a	.word	207-14-2+256			;Y
	.word	94+6,288+7

#xy_starts
	.long	#stxy1,#stxy2,#stxy3

#stxy1	.word	207-14			;Y
	.word	15,187-1,209,381-1

#stxy2	.word	186			;Y
	.word	24,154-1,242,371-1

#stxy3	.word	>1c1
	.word	>13-4,>bd-4,>d6-4,>180-4


;RAD_MK2:
;SCO_MK2:
;REP_MK2:
;SUB_MK2:


#*****************************************************************************

 SUBR	update_player_heads

	PUSH	a10

	move	@team1,a0
	cmpi	27,a0
	jrnz	#cont1a
	move	@gmqrtr,a14
	cmpi	2,a14
	jrnz	#cont1a
	move	@fixbug,a14
	jrz	#do_team2
#cont1a

	move	@team1,a0
	jrnn	#valid_team1
	move	@head1_obj,a8,L
	calla	obj_off
	move	@head2_obj,a8,L
	calla	obj_off
	jruc	#do_team2

#valid_team1
	movi	player_heads,a10
	move	@team1,a2
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

	move	@head1_obj,a8,L
	calla	obj_on
	move	*a10,a2,L		;* image
	move	@special_heads,b0
	jrnn	#spec_head1
	move	*a2(ICMAP),a0,L		;Get *palette
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant
	move	a2,a0			;* image
	move	*a8(OCTRL),a1		;DMA flags

	move	a2,a14

	cmpi	RAD_MK2,a14
	jrz	#mk2c
	cmpi	SUB_MK2,a14
	jrz	#mk2c
	cmpi	REP_MK2,a14
	jrz	#mk2c
	cmpi	SCO_MK2,a14
	jrz	#mk2c
	jrnz	#notmkc
#mk2c
	move	*a8(OFLAGS),A1
	btst	14,a1
	jrnz	#on
	move	@gmqrtr,a14
	cmpi	2,a14
	jrnz	#cont1
	move	@fixbug,a14
	jrnz	#on
#cont1
	move	a0,a14
	move	a8,a0
	calla	OBJOFF
	calla	obj_off
	move	a14,a0

	move	*a8(OFLAGS),A1
	ori	>7000,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	ori	>7000,a1		;DMA flags
	move	a1,*a8(OCTRL)
	jruc	#notmkcx
#on	
	move	a0,a14
	calla	obj_on
	move	a8,a0
	calla	OBJON
	move	a14,a0
	jruc	#notmkcx
#notmkc
	move	*a8(OFLAGS),A1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OCTRL)
	
#notmkcx
	calla	obj_aniq		;change object image
#spec_head1

	move	@head2_obj,a8,L
	calla	obj_on
	move	*a10(20h),a2,L		;* image
	move	@special_heads+10h,b0
	jrnn	#spec_head2
	move	*a2(ICMAP),a0,L		;Get *palette
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant
	move	a2,a0			;* image
	move	*a8(OCTRL),a1		;DMA flags

	move	a2,a14

	cmpi	RAD_MK2,a14
	jrz	#mk2b
	cmpi	SUB_MK2,a14
	jrz	#mk2b
	cmpi	REP_MK2,a14
	jrz	#mk2b
	cmpi	SCO_MK2,a14
	jrz	#mk2b
	jrnz	#notmkb
#mk2b
	move	*a8(OFLAGS),A1
	btst	14,a1
	jrnz	#onxb
	move	@gmqrtr,a14
	cmpi	2,a14
	jrnz	#cont2
	move	@fixbug,a14
	jrnz	#onxb
#cont2
	move	a0,a14
	move	a8,a0
	calla	OBJOFF
	calla	obj_off
	move	a14,a0

	move	*a8(OFLAGS),A1
	ori	>7010,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	ori	>7010,a1		;DMA flags
	move	a1,*a8(OCTRL)
	jruc	#notmkxb
#onxb
	move	a0,a14
	calla	obj_on
	move	a8,a0
	calla	OBJON
	move	a14,a0
	jruc	#notmkxb
#notmkb
	move	*a8(OFLAGS),A1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OCTRL)
	
#notmkxb
	calla	obj_aniq		;change object image
#spec_head2


#do_team2
	move	@team2,a0
	cmpi	27,a0
	jrnz	#cont3a
	move	@gmqrtr,a14
	cmpi	2,a14
	jrnz	#cont3a
	move	@fixbug,a14
	jrz	#x
#cont3a

	move	@team2,a0
	jrnn	#valid_team2
	move	@head3_obj,a8,L
	calla	obj_off
	move	@head4_obj,a8,L
	calla	obj_off
	jruc	#x

#valid_team2
	movi	player_heads,a10
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

	move	@head3_obj,a8,L
	calla	obj_on
	move	*a10,a2,L		;* image
	move	@special_heads+20h,b0
	jrnn	#spec_head3
	move	*a2(ICMAP),a0,L		;Get *palette
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant
	move	a2,a0			;* image
	move	*a8(OCTRL),a1		;DMA flags

	move	a2,a14

	cmpi	RAD_MK2,a14
	jrz	#mk2a
	cmpi	SUB_MK2,a14
	jrz	#mk2a
	cmpi	REP_MK2,a14
	jrz	#mk2a
	cmpi	SCO_MK2,a14
	jrz	#mk2a
	jrnz	#notmka
#mk2a
	move	*a8(OFLAGS),A1
	btst	14,a1
	jrnz	#onx2
	move	@gmqrtr,a14
	cmpi	2,a14
	jrnz	#cont3
	move	@fixbug,a14
	jrnz	#onx2
#cont3
	move	a0,a14
	move	a8,a0
	calla	OBJOFF
	calla	obj_off
	move	a14,a0

	move	*a8(OFLAGS),A1
	ori	>7000,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	ori	>7000,a1		;DMA flags
	move	a1,*a8(OCTRL)
	jruc	#notmkx2
#onx2
	move	a0,a14
	calla	obj_on
	move	a8,a0
	calla	OBJON
	move	a14,a0
	jruc	#notmkx2
#notmka
	move	*a8(OFLAGS),A1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OCTRL)
	
#notmkx2
	calla	obj_aniq		;change object image
#spec_head3

	move	@head4_obj,a8,L
	calla	obj_on
	move	*a10(20h),a2,L		;* image
	move	@special_heads+30h,b0
	jrnn	#spec_head4
	move	*a2(ICMAP),a0,L		;Get *palette
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant
	move	a2,a0			;* image
	move	*a8(OCTRL),a1		;DMA flags

	move	a2,a14

	cmpi	RAD_MK2,a14
	jrz	#mk2
	cmpi	SUB_MK2,a14
	jrz	#mk2
	cmpi	REP_MK2,a14
	jrz	#mk2
	cmpi	SCO_MK2,a14
	jrz	#mk2
	jrnz	#notmk
#mk2
	move	*a8(OFLAGS),a1
	btst	14,a1
	jrnz	#onx
	move	@gmqrtr,a14
	cmpi	2,a14
	jrnz	#cont4
	move	@fixbug,a14
	jrnz	#onx
#cont4
	move	a0,a14
	move	a8,a0
	calla	OBJOFF
	calla	obj_off
	move	a14,a0

	move	*a8(OFLAGS),a1
	ori	>7010,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	ori	>7010,a1		;DMA flags
	move	a1,*a8(OCTRL)
	jruc	#notmkx
#onx
	move	a0,a14
	calla	obj_on
	move	a8,a0
	calla	OBJON
	move	a14,a0
	jruc	#notmkx
#notmk
	move	*a8(OFLAGS),A1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OCTRL)
	
#notmkx
	calla	obj_aniq		;change object image
#spec_head4


#x
	PULL	a10

	clr a0
	move	a0,@fixbug

	rets


#*****************************************************************************

 SUBRP	update_player_names

	move	@team1,a0
	jrnn	#valid_team1
	move	@name1_obj,a8,L
	calla	obj_off
	movi	attrib1_obj,a2
	calla	attrib_off

	move	@name2_obj,a8,L
	calla	obj_off
	movi	attrib2_obj,a2
	calla	attrib_off
	jruc	#do_team2

#valid_team1
	movi	player_names,a10
	move	@team1,a2
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

	move	@name1_obj,a8,L
	calla	obj_on
	clr	a1			;bit 0
	movi	attrib1_obj,a11
	calla	flash_player_name

	move	*a10,a0,L		;image addr
	move	@special_heads,b0
	jrnn	#spec1
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
#spec1

	move	@name2_obj,a8,L
	movk	1,a1			;bit 1
	movi	attrib2_obj,a11
	calla	flash_player_name
	move	*a10(20h),a0,L		;image addr
	move	@special_heads+10h,b0
	jrnn	#spec2
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
#spec2

	movi	attrib1_obj+20h,a11
	movi	player_names,a10
	move	@team1,a2
#lp3	cmpi	0,a2
	jrz	#out3
	addi	20*64,a10
	dec	a2
	jruc	#lp3
#out3
	move	@team1,a0
	sll	4,a0
	addi	tm1set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10
	move	*a10,a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp4
	inc	a10
	move	*a14+,a1,L
	cmp	a1,a0
	jrnz	#lp4

	sll	7,a10
	addi	player_attribs,a10

	PUSH	a10
	move	@special_heads,a6
	calla	update_attribs
	PULL	a10

	movi	attrib2_obj+20h,a11

	movi	player_names,a10

	move	@team1,a2
#lp3x	cmpi	0,a2
	jrz	#out3x
	addi	20*64,a10
	dec	a2
	jruc	#lp3x
#out3x


	move	@team1,a0
	sll	4,a0
	addi	tm1set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10
	addk	32,a10
	move	*a10,a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp4x
	inc	a10
	move	*a14+,a1,L
	cmp	a1,a0
	jrnz	#lp4x

	sll	7,a10
	addi	player_attribs,a10



	move	@special_heads+10h,a6
	calla	update_attribs


#do_team2
	move	@team2,a0
	jrnn	#valid_team2
	move	@name3_obj,a8,L
	calla	obj_off
	movi	attrib3_obj,a2
	calla	attrib_off

	move	@name4_obj,a8,L
	calla	obj_off
	movi	attrib4_obj,a2
	calla	attrib_off
	rets

#valid_team2
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

;	move	@team2,a10		;cursor position
;	sll	6,a10			;x 2 x 32 bits
;	addi	player_names,a10	;start of logos

	move	@name3_obj,a8,L
	calla	obj_on
	movk	2,a1			;bit 2
	movi	attrib3_obj,a11
	calla	flash_player_name

	move	*a10,a0,L		;image addr
;	move	@player_toggle2,b0	;no toggle
;	jrz	#not3
;	move	*a10(20h),a0,L		;image addr
;#not3
	move	@special_heads+20h,b0
	jrnn	#spec3
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
#spec3

	move	@name4_obj,a8,L
	calla	obj_on
	movk	3,a1			;bit 3
	movi	attrib4_obj,a11
	calla	flash_player_name

	move	*a10(20h),a0,L		;image addr
;	move	@player_toggle2,b0	;no toggle
;	jrz	#not4
;	move	*a10,a0,L		;image addr
;#not4
	move	@special_heads+30h,b0
	jrnn	#spec4
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
#spec4
	movi	attrib3_obj+20h,a11
;	move	@player_toggle2,a0	;no toggle
;	jrz	#not3a
;	movi	attrib4_obj+20h,a11
;#not3a


	movi	player_names,a10
	move	@team2,a2
#lp6	cmpi	0,a2
	jrz	#out6
	addi	20*64,a10
	dec	a2
	jruc	#lp6
#out6
	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10
	move	*a10,a0,L
;	move	*a0(OIMG),a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp5
	inc	a10
	move	*a14+,a1,L
;	jrz	$
	cmp	a1,a0
	jrnz	#lp5

	sll	7,a10
	addi	player_attribs,a10



;	move	@team2,a10		;cursor position
;	sll	8,a10			;x16x8x2=128
;	addi	player_attribs,a10


	PUSH	a10
	move	@special_heads+20h,a6
	calla	update_attribs
	PULL	a10
	movi	attrib4_obj+20h,a11
;	move	@player_toggle2,a0	;no toggle
;	jrz	#not4a
;	movi	attrib3_obj+20h,a11
;#not4a
;	addi	16*8,a10		;*4

	movi	player_names,a10
	move	@team2,a2
#lp6x	cmpi	0,a2
	jrz	#out6x
	addi	20*64,a10
	dec	a2
	jruc	#lp6x
#out6x

	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10
	addk	32,a10
	move	*a10,a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp4y
	inc	a10
	move	*a14+,a1,L
;	jrz	$
	cmp	a1,a0
	jrnz	#lp4y

	sll	7,a10
	addi	player_attribs,a10


	move	@special_heads+30h,a6
	calla	update_attribs

	rets


flash_player_name
	move	@PSTATUS,a0
	btst	a1,a0

;	jruc	#player_active


;	movk	ADJFREPL,a0		;in free play?
;	calla	GET_ADJ
;	jrnz	#in_free
;	move	@PCNT,a0		;frame count
;	btst	5,a0
;	jrnz	#objon
;#in_free				;so no name displayed
;	calla	obj_off
;	move	a11,a2
;	calla	#attrib_off
;	rets
;#objon

#player_active
	calla	obj_on
	move	a11,a2
	calla	attrib_on
	rets




#*****************************************************************************
*
* a0 = table offset to use for coordinates
*


 SUBR	create_logos


	sll	5,a0				;x 32 bits
	addi	#startxys,a0
	move	*a0,a2,L

	move	*a2+,a1,L
	move	*a2,a0				;x val
	sll	16,a0
	PUSH	a1,a2
	movi	T_SUNS,a2			;* image
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@logo1_obj,L

	PULL	a1,a2
	move	*a2+,a0				;x val
	PUSH	a1,a2
	addi	[2,0],a1			;down 2
	addk	2,a0				;right 2
	sll	16,a0
	movi	T_SUNS,a2			;* image
	movi	119,a3				;z pos
	movi	DMACNZ,a4			;DMA flags
	movi	SGMD8YEL,b0			;palette to use
	calla	BEGINOBJP2
	move	a8,@logo1_obj+20h,L
	movi	0202h,a0			;black shadow
	move	a0,*a8(OCONST)


	PULL	a1,a2				;y val
	move	*a2,a0				;x val
	PUSH	a1,a2
	sll	16,a0
	movi	T_KNIKS,a2			;* image
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@logo2_obj,L

	PULL	a1,a2
	move	*a2+,a0				;x val
	addi	[2,0],a1			;down 2
	addk	2,a0				;right 2
	sll	16,a0
	movi	T_KNIKS,a2			;* image
	movi	119,a3				;z pos
	movi	DMACNZ,a4			;DMA flags
	movi	SGMD8YEL,b0			;palette to use
	calla	BEGINOBJP2
	move	a8,@logo2_obj+20h,L
	movi	0202h,a0			;black shadow
	move	a0,*a8(OCONST)
	rets

#startxys	.long	#stxy1,#stxy2,#stxy3
	
#stxy1	.long	(172+TEAMSEL_PAGE-14)<<16	;Y
	.word	101,295

#stxy2	.long	80<<16			;Y
	.word	80,200+80

#stxy3	.long	>1a0<<16
	.word	>68-4,>12d-4

#*****************************************************************************

 SUBR	update_team_set
;Updated by toggle routine
	move	@teamset1_obj,a8,L
	move	@team1,a0
	jrnn	#ok
	calla	obj_off
	jruc	#ok1
#ok
	calla	obj_on

	move	@team1,a0
	sll	4,a0
	addi	tm1set,a0
	move	*a0,a0

	sll	5,a0			;x 32 bits
	addi	set_imgs,a0
	move	*a0,a2,L		;image addr
;	move	*a2(ICMAP),a0,L		;Get *palette
	movi 	SQTR_B_P,a0
	calla	pal_getf
	ori	17170000h,a0
	move	@teamset1_obj,a8,L
	move	a0,*a8(OPAL),L		;Set pallette & constant
	move	a2,a0			;* image
	move	*a8(OCTRL),a1
;	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image

#ok1
	move	@teamset2_obj,a8,L
	move	@team2,a0
	jrnn	#ok2
	calla	obj_off
	rets
#ok2
	calla	obj_on

	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a0

	sll	5,a0			;x 32 bits
	addi	set_imgs,a0
	move	*a0,a2,L		;image addr
	
	movi 	SQTR_R_P,a0
;	move	*a2(ICMAP),a0,L		;Get *palette
	calla	pal_getf
	ori	17170000h,a0
	move	@teamset2_obj,a8,L
	move	a0,*a8(OPAL),L		;Set pallette & constant
	move	a2,a0			;* image
	move	*a8(OCTRL),a1
;	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image

#notvalid
	rets


 SUBR	update_logos

	move	@logo1_obj,a8,L
	calla	obj_on
	move	@logo1_obj+20h,a8,L
	calla	obj_on
	move	@team1,a0
	jrnn	#valid_team1
	move	@logo1_obj,a8,L
	calla	obj_off
	move	@logo1_obj+20h,a8,L
	calla	obj_off
	jruc	#team2

#valid_team1
	sll	5,a0			;x 32 bits
	addi	logos,a0
	move	*a0,a2,L		;image addr
	move	*a2(ICMAP),a0,L		;Get *palette
	calla	pal_getf
	move	@logo1_obj,a8,L
	move	a0,*a8(OPAL),L		;Set pallette & constant
	move	a2,a0			;* image
	PUSH	a0
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	PULL	a0
	move	@logo1_obj+20h,a8,L
	movi	DMACNZ,a1		;DMA flags
	calla	obj_aniq		;change object image

#team2
	move	@logo2_obj,a8,L
	calla	obj_on
	move	@logo2_obj+20h,a8,L
	calla	obj_on
	move	@team2,a0
	jrnn	#valid_team2
	move	@logo2_obj,a8,L
	calla	obj_off
	move	@logo2_obj+20h,a8,L
	calla	obj_off
	rets

#valid_team2
	sll	5,a0			;x 32 bits
	addi	logos,a0
	move	*a0,a2,L		;image addr
	move	*a2(ICMAP),a0,L		;Get *palette
	calla	pal_getf
	move	@logo2_obj,a8,L
	move	a0,*a8(OPAL),L		;Set pallette & constant
	move	a2,a0			;* image
	PUSH	a0
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	PULL	a0
	move	@logo2_obj+20h,a8,L
	movi	DMACNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	rets


#*****************************************************************************
;returns a pointer into the menu table at
;the current cursor position
;a1 = * current entry

 SUBRP	get_table_address

	move	*a13(PC_CURSPOS),a0	;cursor position
	movi	3*16,a1			;3 x 16 bits
	mpyu	a0,a1
	move	*a13(PC_TABLE),a0,L	;table address
	add	a0,a1
	rets

#*****************************************************************************

update_team_cursor1

	move	@gmqrtr,a0
	jrnz	up_out
	calla	update_arrow1
	calla	update_cursor
;;	calla	obj_on			;don't flash
up_out
	rets

#*****************************************************************************

update_team_cursor2

	move	@gmqrtr,a0
	jrnz	up_out
	calla	update_arrow2
	calla	update_cursor
;;	calla	obj_on			;don't flash
	rets

#*****************************************************************************

update_arrow1

	move	*a13(PC_ARROWOBJ),a8,L
	move	@team1_control,a0
	jrn	#off

	calla	get_table_address
	move	*a1+,a3		;char under cursor
	move	*a13(PC_STARTX),a2
	move	*a1+,a0		;x offset
	add	a2,a0
	move	a0,*a8(OXPOS)

	move	*a13(PC_STARTY),a2
	move	*a1+,a0		;y offset
	add	a2,a0
	move	a0,*a8(OYPOS)
	PUSH	a0

	move	@team1_control,a0

	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not_2
	dec	a0			;1-2
#not_2
	sll	5,a0			;x 32 bits
	addi	arrow_imgs,a0
	move	*a0,a0,L		;* image
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image

	PULL	a0
	subi	28,a0
	move	a0,*a8(OYPOS)

	rets
#off
	calla	obj_off
	rets

arrow_imgs
	.long	arrow1t,arrow2t,arrow3t,arrow4t

#*****************************************************************************

update_arrow2

	move	*a13(PC_ARROWOBJ),a8,L
	move	@team2_control,a0
	jrn	#off

	calla	get_table_address
	move	*a1+,a3		;char under cursor
	move	*a13(PC_STARTX),a2
	move	*a1+,a0		;x offset
	add	a2,a0
	addk	15,a0
	move	a0,*a8(OXPOS)

	move	*a13(PC_STARTY),a2
	move	*a1+,a0		;y offset
	add	a2,a0
	move	a0,*a8(OYPOS)
	PUSH	a0

	move	@team2_control,a0

	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not_2
	dec	a0			;1-2
#not_2
	sll	5,a0			;x 32 bits
	addi	arrow_imgs,a0
	move	*a0,a0,L		;* image
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image

	PULL	a0
	subi	28,a0
	move	a0,*a8(OYPOS)

	rets
#off
	calla	obj_off
	rets


#*****************************************************************************
;update cursor position & size for a player
;base on the image it's over

update_cursor

	calla	get_table_address
	move	*a1+,a3		;char under cursor
	sll	5,a3		;x 32 bits
	addi	alpha_table,a3
	move	*a3,a3,L	;image addr
	move	*a3+,a0		;image width
	addi	4,a0
	move	*a13(PC_CURSOBJ),a8,L
	move	a0,*a8(OSIZEX)
	move	*a3,a0		;image height
	addi	2,a0
	move	a0,*a8(OSIZEY)

	move	*a1+,a0		;x offset
	move	*a13(PC_STARTX),a2
	add	a2,a0
	subi	2,a0
	move	a0,*a8(OXPOS)
	move	*a1+,a0		;y offset
	move	*a13(PC_STARTY),a2
	add	a2,a0
	subi	1,a0
	move	a0,*a8(OYPOS)


	move	*a13(PC_FLASHCOUNT),a0		;cursor flash count
	btst	3,a0
	jrnz	#off
	calla	obj_on
	rets
#off
	calla	obj_off
	rets

#*****************************************************************************

 SUBRP	create_heading

	move	*a13(PC_MENULEVEL),a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#not_2pa
	addk	4,a0
#not_2pa
	sll	5,a0				;x 32 bits
	addi	#heading_imgs,a0
	move	*a0,a2,L			;* image

	move	*a13(PC_CENTERX),a0		;x val

	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#not_2pb

	move	*a13(PC_CENTERXkit),a0		;x val
#not_2pb
	sll	16,a0				;shift up past fractional
	movi	[6+NAMENT_PAGE-2,0],a1		;y val
	movk	1,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	move	*a13(PC_OBJID),a5		;OBJ ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

	rets


#heading_imgs
	.long	INITIALS,BirthM,BirthD,Stats
	.long	INITIALS_B,BirthM_B,BirthD_B,Stats_B

#plaque_imgs
;	.long	InitBACK,MnthBACK,DayBACK


#*****************************************************************************
;a5 = object ID

 SUBRP	create_name_objs

	movk	4,a2				;3 x name objs + 1 month/day obj
	move	a13,a1
	addi	PC_NAM1OBJ,a1
#obj_loop
	PUSH	a0,a1,a2,a5
	clr	a0				;x val
	movi	[400h | (213-7),0],a1		;y val
	movi	OSGEMD_F,a2			;* image
	movi	100,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
;	movi	TYPTEXT|SUBPL1,a5		;object	ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	PULL	a0,a1,a2,a5
	move	a8,*a1+,L			;save * object
	addi	[21,0],a0
	dsj	a2,#obj_loop

	clr	a0
	move	a0,*a13(PC_CHARPOS)
	rets

#*****************************************************************************

 SUBRP	next_menu

	move	*a13(PC_OBJID),a0		;OBJ ID's created by this PROC
	calla	obj_del1c			;delete all objs with this ID

	move	*a13(PC_MENULEVEL),a0
	inc	a0
	cmpi	3,a0
	jrlt	#ok
	clr	a0
#ok
	move	a0,*a13(PC_MENULEVEL)
	calla	create_menu
	calla	update_cursor
	rets

#*****************************************************************************
; saves the selected menu item into playerX_data

 SUBRP	save_selection

	move	*a13(PC_DATADDR),a0,L		;start of player data
	move	*a13(PC_CHARPOS),a1
	sll	4,a1				;x 16 bits
	add	a0,a1
	move	*a13(PC_CURSPOS),a0
	move	a0,*a1				;save char selected
	rets

#*****************************************************************************

 SUBRP	check_delete

	move	*a13(PC_CURSPOS),a0
	cmpi	27,a0				;delete icon?
	jrne	#no_delete

	move	*a13(PC_CHARPOS),a0		;no delete, but can't select
	jrz	#zippo				;delete icon either

	move	*a13(PC_DATADDR),a0,L		;start of player data
	move	*a13(PC_CHARPOS),a1
	sll	4,a1				;x 16 bits
	add	a0,a1
	movi	-1,a0
	move	a0,*a1				;delete char

	move	*a13(PC_CHARPOS),a0
	dec	a0
	move	a0,*a13(PC_CHARPOS)

#zippo
	setc
	rets

#no_delete
	clrc
	rets



#*****************************************************************************

 SUBRP	inc_charpos

	move	*a13(PC_CHARPOS),a0
	inc	a0
	move	a0,*a13(PC_CHARPOS)
	rets

#*****************************************************************************

 SUBRP	button_actions

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
	addi	select_sounds,a0
	move	*a0,a0,L
	calla	snd_play1

	move	*a13(PC_CURSOBJ),a8,L
	calla	obj_on
;	movi	0202h,a9		;const flash colour (black)
	movi	0d0dh,a9		;const flash colour (white)
	movi	0101h,a10		;const colour
	JSRP	flash_cursor

	move	*a13(PC_CHARPOS),a0
	sll	5,a0			;x 32 bits
	addi	#actions,a0
	move	*a0,a0,L
	call	a0
	RETP

#actions
	.long	#name0,#name1,#name2,#month,#day

#name0
	calla	check_delete
	jrc	#x1
	calla	inc_charpos
#x1
	rets
#name1
	calla	check_delete
	jrc	#x2
	calla	inc_charpos
#x2
	rets
#name2
	calla	check_delete
	jrc	#x3
	calla	inc_charpos
	calla	next_menu
	calla	hide_name_objs
	clr	a0
	calla	move_cursor
	calla	create_heading
#x3
	rets
#month
	calla	inc_charpos
	calla	next_menu
	calla	hide_name_objs
	clr	a0
	calla	move_cursor
	calla	create_heading
	rets
#day
	move	*a13(PC_OBJID),a0		;OBJ ID's created by this PROC
	calla	obj_del1c			;delete all objs with this ID

	move	*a13(PC_MENULEVEL),a0
	inc	a0
	move	a0,*a13(PC_MENULEVEL)
	calla	hide_name_objs

;	calla	inc_charpos
;	calla	next_menu
	calla	create_heading
	rets

#*****************************************************************************
* hide all name images off bottom of screen

 SUBRP	hide_name_objs

	movi	PC_NAM1OBJ,a3
	add	a13,a3
	movk	4,a2			;3 name objs to hide + month/day obj
#hide_loop
	move	*a3+,a1,L		;* object
	move	*a1(OYPOS),a0
	ori	400h,a0			;offscreen Y
	move	a0,*a1(OYPOS)
	dsj	a2,#hide_loop
	rets

#*****************************************************************************

PSEL_START_DELAY	equ	22	;# frames before repeating
PSEL_REPEAT_DELAY	equ	15 ;10	;# frames delay til next repeat

JOY_UP		equ	1
JOY_DOWN	equ	2
JOY_LEFT	equ	4
JOY_RIGHT	equ	8

 SUBRP	team1_cursor

	clr	a0
	move	a0,*a13(PC_PLAYNUM)

#wait_for_players
	SLEEPK	1
	move	@PSTATUS,a0
	andi	011b,a0
	jrz	#wait_for_players

;player 1 and/or 2 active

	move	@exit_status,a0
	ori	1<<0,a0
	move	a0,@exit_status			;exit

	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)

	movi	player1_data+PR_PTEAM,a0
	move	a0,*a13(PC_DATADDR),L		;start of player data
	movi	TYPTEXT|SUBPL1,a0
	move	a0,*a13(PC_OBJID)		;OBJ ID's created by this PROC

	movi	arw4p,b0			;palette to use
;	movi	arwbp,b0			;palette to use

	movi	arrow1t,a2

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#okz


	move	@team1_control,a0
	jrz	#okz
	movi	arrow2t,a2
#okz
	movi	[62h,0],a0			;x val
	movi	[176h,0],a1			;y val
	move	@gmqrtr,a3
	jrnz	#oka

	movi	[80,0],a1			;y val
	movk	20,a0				;Phoenix
	move	a0,@team1
#oka
	movi	20001,a3			;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP2
	move	a8,*a13(PC_ARROWOBJ),L

	movi	SGMD8YEL,b0			;palette to use
	movi	[250,0],a0			;x val
	move	@gmqrtr,a1
	jrz	#okb
	movi	[1250,0],a0			;x val
#okb
	movi	[80,0],a1			;y val
	movi	OSGEMD_A,a2			;* image
	movk	1,a3				;z pos
	movi	DMACAL,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP2
	movi	0f0fh,a0
	move	a0,*a8(OCONST)
	move	a8,*a13(PC_CURSOBJ),L

	movi	team_menus,a0		;menu start
	move	a0,*a13(PC_MENUBASE),L
	clr	a0			;menu number
	move	a0,*a13(PC_MENULEVEL)
;	calla	create_menu
	calla	get_menu_data
#restart_cursor
	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)

	movk	12,a0
	move	@team2,a1
	cmpi	20,a1			;is other cursor on portland?
	jrne	#nope
	clr	a0			;yes, so put cursor on Golden State
#nope
	move	a0,*a13(PC_CURSPOS)	;position
	calla	update_team_cursor1
	clr	a0
	calla	try_move_cursor1

#loop
	calla	update_team_cursor1
	SLEEPK	7
	movi	PSEL_START_DELAY,a10	;initial repeat delay
	jruc	#skippy
#repeat_delay
	calla	update_team_cursor1
	SLEEPK	1
#skippy

	move	@team1_control,a0	;player selecting team 1
	jrn	#no_team1

	move	@page_scrolling,a0
	jrnz	#loop			;scrolling on, so no input

	move	*a13(PC_FLASHCOUNT),a0	;cursor flash count
	inc	a0
	move	a0,*a13(PC_FLASHCOUNT)

	calla	#toggle1

;Check for team switch powerup on team #1

	move	@team1_switch,a0
	jrnz	#switch
	move	@gmqrtr,a0
	jrz	#noswitch


	calla	tournament_on
	jrc	#noswitch


;Possibly switch teams at the half!
	move	@team1_control,a0	;player selecting team 1
	calla	get_steal_but_cur
	jrz	#tapz
	move	@team1_control,a0	;player selecting team 1
	calla	get_stick_val_cur
	cmpi	8,a0
	jrnz	#tapz
;Yes, trying to powerup team switch!
	move	@switch_1,a0
	inc	a0
	move	a0,@switch_1
	cmpi	120,a0
	jrlt	#noswitch
	move	a0,@team1_switch

	move	@team1_control,a4	;player selecting team 1
	movi	swapblu,a9
	jruc	#yesf0a
;	jruc	#noswitch
#tapz
	clr	a0
	move	a0,@switch_1
	jruc	#noswitch

#switch
	move	@team1_control,a0	;player selecting team 1
	calla	get_steal_but_cur
	jrz	#nodbc
	move	@dbnce1,a0
	jrnz	#noswitch
	movk	1,a0
	move	a0,@dbnce1
	SOUND1	bounce_snd
	move	@team1,a0
	inc	a0
	move	a0,@team1
	cmpi	27,a0
	jrlt	#noswitch
	clr	a0
	move	a0,@team1
	jruc	#noswitch
#nodbc
	clr	a0
	move	a0,@dbnce1


#noswitch

;Check for roster powerup taps
	calla	tournament_on
	jrc	#notap

	move	@bigroster1,a0
	jrnn	#notap

	move	@team1_control,a0	;player selecting team 1
	calla	get_steal_but_cur
	jrnz	#tap
	clr	a0
	move	a0,@dbnce1
	jruc	#notap
#tap

;Check swirl on stick
	move	@team1_control,a0	;player selecting team 1
	calla	get_stick_val_cur

	move	@tm1swrl,a1
	or	a0,a1
	move	a1,@tm1swrl

	move	@dbnce1,a0
	jrnz	#notap
	movk	1,a0
	move	a0,@dbnce1
	move	@tm1taps,a0
	inc	a0
	move	a0,@tm1taps
	cmpi	4,a0
	jrlo	#notap

	cmpi	20,a0
	jrlo	#notfat
	cmpi	1,a1
	jrnz	#notfat


	jruc	#notfat


	move	@fatality,a0
	btst	0,a0
	jrnz	#notfat
	movi	fatalblu,a9
	move	@team1_control,a4	;player selecting team 1
       	jruc	#yesf

#notfat
	cmpi	>f,a1
	jrnz	#notap
;Yes!  Powerup this particular roster
	move	@team1,a0
	move	a0,@bigroster1

	move	@team1_control,a4	;player selecting team 1

;If no additional players are available, fatalitites enabled box appears

	sll	4,a0
	addi	fatal_tbl,a0
	move	*a0,a0
	jrz	#reg

;Do bad decision speech call!
	movi	baddec_snd,a0
	calla	speech_playovrp

#reg
	movi	rosterblu,a9
	jruc	#yesf0a
#yesf
	move	@fatality,a0
	ori	1,a0
	move	a0,@fatality
#yesf0a
	sll	4,a4			;x 16 bits
	addi	plaque_xs,a4
	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not_2p
	addi	4*16,a4
#not_2p
	move	*a4,a10
	sll	16,a10			;x pos
	clr	a0
	move	a0,@HALT
	CREATE0	fullgame_purchased

#notap
	move	@team1_control,a0	;player selecting team 1
	calla	get_but_val_down_nt
	jrnz	#team_selected
	move	@force_selection,a0
	jrnz	#team_selected

	move	@team1_control,a0	;player selecting team 1
	calla	get_steal_but_cur
	jrnz	#nomov
	move	@team1_control,a0
	calla	get_stick_val_down
	jrnz	#movit
	dsj	a10,#repeat_delay

	move	@team1_control,a0	;player selecting team 1
	calla	get_steal_but_cur
	jrnz	#nomov
	move	@team1_control,a0	;player selecting team 1
	calla	get_stick_val_cur
	calla	try_move_cursor1
#nomov
	movi	PSEL_REPEAT_DELAY,a10	;repeat delay
	jruc	#repeat_delay

#movit
	move	@gmqrtr,a14
	jrnz	#nomov

	calla	try_move_cursor1
	jruc	#loop

plaque_xs
	.word	15,104,209,298
	.word	0,101-42,296-42,0

#team_selected
	move	@gmqrtr,a0
	jrnz	#skp

	move	@team1,a0
	addi	AUD_ATL,a0
	calla	AUD1			;inc audit

	move	@team1,a0
	calla	call_team_name
#skp

	SOUND1	select_snd1
	move	*a13(PC_CURSOBJ),a8,L
	calla	obj_on
	move	*a13(PC_ARROWOBJ),a8,L
	calla	obj_off

	movi	0d0dh,a9		;const flash colour
	movi	0f0fh,a10		;const colour
	movi	plate1_objs,a11
	JSRP	flash_cursorNplate
	move	@exit_status,a0
	andni	1<<0,a0
	move	a0,@exit_status		;exit

#wait_loop2
	SLEEPK	1
	move	@PSTATUS,a0
	andi	011b,a0
	jrnz	#wait_loop2

#no_team1
	move	@exit_status,a0
	andni	1<<0,a0
	move	a0,@exit_status		;exit

	move	*a13(PC_CURSOBJ),a8,L
	calla	obj_off
	move	*a13(PC_ARROWOBJ),a8,L
	calla	obj_off

	move	@gmqrtr,a14
	cmpi	2,a14
	jaz	SUCIDE

#wait_loop
	SLEEPK	1

	move	@PSTATUS,a0
	andi	011b,a0
	jrz	#wait_loop

	move	@exit_status,a0
	ori	1<<0,a0
	move	a0,@exit_status		;exit

	jruc	#restart_cursor


#toggle1
	move	@toggle1_time,a0
	jrz	#can
	dec	a0
	move	a0,@toggle1_time
	jrnz	#no_toggle

#can
	calla	get_team1_turbo		;check if players want to toggle heads
	jrz	#no_toggle

	SOUND1	bounce_snd
;	move	@player_toggle1,a0
;	xori	1,a0
;	move	a0,@player_toggle1
	movk	6,a0			;20
	move	a0,@toggle1_time

	move	@team1,a0
	sll	4,a0
	addi	tm1set,a0
	move	*a0,a14


	cmpi	5,a14
	jrlo	#ok


;MJT
;Bigroster if defeated all the teams
	move	@team1_control,a1
	sll	5,a1
	addi	defeated,a1
	move	*a1,a1,L
	move	*a1,a1,L
	cmpi	07ffffffh,a1
	jrz	#bonus
	

	move	@bigroster1,a1
	jrn	#cont
	move	@team1,a2
	cmp	a1,a2
	jrnz	#cont

#bonus
;Player has powered up his roster, and is sitting on the powered up team.
	cmpi	19,a14
	jrz	#cont

#ok
	inc	a14
	move	a14,*a0

	movi	player_heads,a1
	move	@team1,a14
#lp	cmpi	0,a14
	jrz	#out
	addi	20*64,a1
	dec	a14
	jruc	#lp	
#out
	move	*a0,a14
	sll	6,a14
	add	a14,a1
	move	*a1,a1
	jrnz	#no_toggle
#cont	clr	a1
	move	a1,*a0
	
#no_toggle
	rets

#*****************************************************************************
*
* INPUT:	a0 = switch bits 0-3
*
*-----------------------------------------------------------------------------

 SUBRP	try_move_cursor1

	move	*a13(PC_CURSPOS),a1	;save curs position
	move	a1,b1
	move	a0,b0			;save joy switch vals
	calla	move_team_cursor	;move cursor
	calla	get_team_number
	move	@team2,a1		;on cursor 2 ?
	cmp	a0,a1

;	jrne	#not_same
	jruc	#not_same

	move	b0,a0			;restor joy switch vals
	calla	move_team_cursor	;move it again
	calla	get_team_number
	move	@team2,a1		;on cursor 2 ?
	cmp	a0,a1
	jrne	#not_same

	move	b1,a0
	move	a0,*a13(PC_CURSPOS)	;restore position
	rets

#not_same
	move	@gmqrtr,a14
	jrnz	#out
	move	@team1,a14
	cmp	a0,a14
	jrz	#out
	move	a0,@team1
	move	@bigroster1,a14
	jrnn	#out
	clr	a14
	move	a14,@tm1taps
	move	a14,@tm1swrl
#out

	rets

#*****************************************************************************

 SUBRP	team2_cursor

	movk	1,a0
	move	a0,*a13(PC_PLAYNUM)

#wait_for_players
	SLEEPK	1
	move	@PSTATUS,a0
	andi	01100b,a0
	jrz	#wait_for_players

;player 3 and/or 4 active

	move	@exit_status,a0
	ori	1<<1,a0
	move	a0,@exit_status		;exit

	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)

	movi	player2_data+PR_PTEAM,a0
	move	a0,*a13(PC_DATADDR),L	;start of player data
	movi	TYPTEXT|SUBPL2,a0
	move	a0,*a13(PC_OBJID)	;OBJ ID's created by this PROC

	movi	arw1p,b0		;palette to use
;	movi	arw3p,b0		;palette to use


	movi	arrow2t,a2
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrnz	#okz


	movi	arrow3t,a2
	move	@team2_control,a0
	cmpi	2,a0
	jrz	#okz
	movi	arrow4t,a2
#okz
	movi	[390-62h,0],a0			;x val
	movi	[176h,0],a1			;y val
	move	@gmqrtr,a3
	jrnz	#oka

	movi	[80,0],a1		;y val
	movk	17,a0			;New York
	move	a0,@team2
#oka
	movi	20001,a3		;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJP2
	move	a8,*a13(PC_ARROWOBJ),L

	movi	SGMD8YEL,b0		;palette to use
	movi	[250,0],a0			;x val
	move	@gmqrtr,a1
	jrz	#okb
	movi	[1250,0],a0			;x val
#okb
	movi	[80,0],a1		;y val
	movi	OSGEMD_A,a2		;* image
	movk	1,a3			;z pos
	movi	DMACAL,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJP2
	movi	0c0ch,a0
	move	a0,*a8(OCONST)
	move	a8,*a13(PC_CURSOBJ),L

	movi	team_menus,a0		;menu start
	move	a0,*a13(PC_MENUBASE),L
	clr	a0			;menu number
	move	a0,*a13(PC_MENULEVEL)
;	calla	create_menu
	calla	get_menu_data
#restart_cursor
	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)

	movk	15,a0
	move	@team1,a1
	cmpi	17,a1			;is other cursor on New York?
	jrne	#nope
	movk	3,a0			;yes, so put cursor on Boston
#nope
	move	a0,*a13(PC_CURSPOS)	;position
	calla	update_team_cursor2
	clr	a0
	calla	try_move_cursor2

#loop
	calla	update_team_cursor2
	SLEEP	7
	movi	PSEL_START_DELAY,a10	;initial repeat delay
	jruc	#skippy
#repeat_delay
	calla	update_team_cursor2
	SLEEPK	1
#skippy

	move	@team2_control,a0	;player selecting team 2
	jrn	#no_team2

	move	@page_scrolling,a0
	jrnz	#loop			;scrolling on, so no input

	move	*a13(PC_FLASHCOUNT),a0	;cursor flash count
	inc	a0
	move	a0,*a13(PC_FLASHCOUNT)

	calla	#toggle2
;Check for team switch powerup on team #2

	move	@team2_switch,a0
	jrnz	#switch
	move	@gmqrtr,a0
	jrz	#noswitch


	.ref	tournament_on
	calla	tournament_on
	jrc	#noswitch


;Possibly switch teams at the half!
	move	@team2_control,a0	;player selecting team 1
	calla	get_steal_but_cur
	jrz	#tapz
	move	@team2_control,a0	;player selecting team 1
	calla	get_stick_val_cur
	cmpi	8,a0
	jrnz	#tapz
;Yes, trying to powerup team switch!
	move	@switch_2,a0
	inc	a0
	move	a0,@switch_2
	cmpi	120,a0
	jrlt	#noswitch
	move	a0,@team2_switch
	move	@team2_control,a4	;player selecting team 1
	movi	swapred,a9
	jruc	#yesf1a
;	jruc	#noswitch
#tapz
	clr	a0
	move	a0,@switch_2
	jruc	#noswitch

#switch
	move	@team2_control,a0	;player selecting team 1
	calla	get_steal_but_cur
	jrz	#nodbc
	move	@dbnce2,a0
	jrnz	#noswitch
	movk	1,a0
	move	a0,@dbnce2
	SOUND1	bounce_snd
	move	@team2,a0
	inc	a0
	move	a0,@team2
	cmpi	27,a0
	jrlt	#noswitch
	clr	a0
	move	a0,@team2
	jruc	#noswitch
#nodbc
	clr	a0
	move	a0,@dbnce2

#noswitch

;Check for roster powerup taps
	calla	tournament_on
	jrc	#notap

	move	@bigroster2,a0
	jrnn	#notap

	move	@team2_control,a0	;player selecting team 1
	calla	get_steal_but_cur
	jrnz	#tap
	clr	a0
	move	a0,@dbnce2
	jruc	#notap
#tap

;Check swirl on stick
	move	@team2_control,a0	;player selecting team 1
	calla	get_stick_val_cur

	move	@tm2swrl,a1
	or	a0,a1
	move	a1,@tm2swrl

	move	@dbnce2,a0
	jrnz	#notap
	movk	1,a0
	move	a0,@dbnce2
	move	@tm2taps,a0
	inc	a0
	move	a0,@tm2taps
	cmpi	4,a0
	jrlo	#notap

	cmpi	20,a0
	jrlo	#notfat
	cmpi	1,a1
	jrnz	#notfat

	move	@fatality,a0
	btst	1,a0
	jrnz	#notfat
	movi	fatalred,a9
	move	@team2_control,a4	;player selecting team 1
       	jruc	#yesf1

#notfat
	cmpi	>f,a1
	jrnz	#notap
;Yes!  Powerup this particular roster
	move	@team2,a0
	move	a0,@bigroster2

	move	@team2_control,a4	;player selecting team 1

;If no additional players are available, fatalitites enabled box appears

	sll	4,a0
	addi	fatal_tbl,a0
	move	*a0,a0
	jrz	#reg			;Br=yes fatality

;Do bad decision speech call!
	movi	baddec_snd,a0
	calla	speech_playovrp

#reg
	movi	rosterred,a9
	jruc	#yesf1a
#yesf1
	move	@fatality,a0
	ori	2,a0
	move	a0,@fatality
#yesf1a
	sll	4,a4			;x 16 bits
	addi	plaque_xs,a4
	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not_2p
	addi	4*16,a4
#not_2p
	move	*a4,a10
	sll	16,a10	
;MJT		;x pos
	clr	a0
	move	a0,@HALT
	CREATE0	fullgame_purchased

#notap
	move	@team2_control,a0	;player selecting team 2
	calla	get_but_val_down_nt
	jrnz	#team_selected
	move	@force_selection,a0
	jrnz	#team_selected

	move	@team2_control,a0	;player selecting team 2
	calla	get_steal_but_cur
	jrnz	#nomov
	move	@team2_control,a0
	calla	get_stick_val_down
	jrnz	#movit
	dsj	a10,#repeat_delay

	move	@team2_control,a0	;player selecting team 1
	calla	get_steal_but_cur
	jrnz	#nomov
	move	@team2_control,a0	;player selecting team 2
	calla	get_stick_val_cur
	calla	try_move_cursor2
#nomov

	movi	PSEL_REPEAT_DELAY,a10	;repeat delay
	jruc	#repeat_delay
#movit
	move	@gmqrtr,a14
	jrnz	#nomov

	calla	try_move_cursor2
	jruc	#loop

#team_selected
	move	@gmqrtr,a0
	jrnz	#skp
 
	move	@team2,a0
	addi	AUD_ATL,a0
	calla	AUD1			;inc audit

	move	@team2,a0
	calla	call_team_name
#skp

	SOUND1	select_snd2
	move	*a13(PC_CURSOBJ),a8,L
	calla	obj_on
	move	*a13(PC_ARROWOBJ),a8,L
	calla	obj_off

	movi	0d0dh,a9		;const flash colour
	movi	0c0ch,a10		;const colour
	movi	plate2_objs,a11
	JSRP	flash_cursorNplate
	move	@exit_status,a0
	andni	1<<1,a0
	move	a0,@exit_status		;exit

#wait_loop2
	SLEEPK	1
	move	@PSTATUS,a0
	andi	01100b,a0
	jrnz	#wait_loop2

#no_team2
	move	@exit_status,a0
	andni	1<<1,a0
	move	a0,@exit_status		;exit

	move	*a13(PC_CURSOBJ),a8,L
	calla	obj_off
	move	*a13(PC_ARROWOBJ),a8,L
	calla	obj_off

	move	@gmqrtr,a14
	cmpi	2,a14
	jaz	SUCIDE

#wait_loop
	SLEEPK	1

	move	@PSTATUS,a0
	andi	01100b,a0
	jrz	#wait_loop

	move	@exit_status,a0
	ori	1<<1,a0
	move	a0,@exit_status		;exit

	jruc	#restart_cursor


#toggle2
	move	@toggle2_time,a0
	jrz	#can
	dec	a0
	move	a0,@toggle2_time
	jrnz	#no_toggle

#can
	calla	get_team2_turbo		;check if players want to toggle heads
	jrz	#no_toggle

	SOUND1	bounce_snd
;	move	@player_toggle2,a0
;	xori	1,a0
;	move	a0,@player_toggle2
	movi	6,a0
	move	a0,@toggle2_time

	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a14

	cmpi	5,a14
	jrlo	#ok



;MJT
;Bigroster if defeated all the teams
	move	@team2_control,a1
	sll	5,a1
	addi	defeated,a1
	move	*a1,a1,L
	move	*a1,a1,L
	cmpi	07ffffffh,a1
	jrz	#bonus2
	



	move	@bigroster2,a1
	jrn	#cont
	move	@team2,a2
	cmp	a1,a2
	jrnz	#cont
#bonus2
;Player has powered up his roster, and is sitting on the powered up team.
	cmpi	19,a14
	jrz	#cont

#ok
	inc	a14
	move	a14,*a0

	movi	player_heads,a1
	move	@team2,a14
#lp	cmpi	0,a14
	jrz	#out
	addi	20*64,a1
	dec	a14
	jruc	#lp
#out
	move	*a0,a14
	sll	6,a14
	add	a14,a1
	move	*a1,a1
	jrnz	#no_toggle
#cont	clr	a1
	move	a1,*a0

#no_toggle
	rets

#*****************************************************************************
*
* INPUT:	a0 = switch bits 0-3
*
*-----------------------------------------------------------------------------

 SUBRP	try_move_cursor2

	move	*a13(PC_CURSPOS),a1	;save curs position
	move	a1,b1
	move	a0,b0			;save joy switch vals
	calla	move_team_cursor	;move cursor
	calla	get_team_number
	move	@team1,a1		;on cursor 1 ?
	cmp	a0,a1

;	jrne	#not_same
;	jruc	#not_same

;	move	b0,a0			;restor joy switch vals
;	calla	move_team_cursor	;move it again
;	calla	get_team_number
;	move	@team1,a1		;on cursor 1 ?
;	cmp	a0,a1
;	jrne	#not_same
;
;	move	b1,a0
;	move	a0,*a13(PC_CURSPOS)	;restore position
;	rets
;
;#not_same
	move	@gmqrtr,a14
	jrnz	#out
	move	@team2,a14
	cmp	a0,a14
	jrz	#out
	move	a0,@team2
	move	@bigroster2,a14
	jrnn	#out
	clr	a14
	move	a14,@tm2taps
	move	a14,@tm2swrl
#out
	rets

#*****************************************************************************
*
* INPUT:	a9  = const colour for flash
*		a10 = const colour to revert to
*
*-----------------------------------------------------------------------------

 SUBRP	flash_cursor

	movk	2,a11
#again
	move	a9,*a8(OCONST)
	SLEEPK	3
	move	a10,*a8(OCONST)
	SLEEPK	3
	dsj	a11,#again

	RETP

#*****************************************************************************
*
* INPUT:	a9  = const colour for flash
*		a10 = const colour to revert to
*		a11 = * plate objs
*
*-----------------------------------------------------------------------------

 SUBRP	flash_cursorNplate

	movk	6,a0
#again
	PUSHP	a0
	move	*a11,a8,L
;	movi	2f2fh,a2
	movi	1919h,a2
	move	a2,*a8(OCONST)
	calla	const_on
	move	*a11(20h),a8,L
;	movi	2f2fh,a2
	movi	1919h,a2
	move	a2,*a8(OCONST)
	calla	const_on

	move	*a13(PC_CURSOBJ),a8,L
	move	a9,*a8(OCONST)

	SLEEPK	3

	move	*a11,a8,L
	calla	const_off
	move	*a11(20h),a8,L
	calla	const_off
	move	*a13(PC_CURSOBJ),a8,L
	move	a10,*a8(OCONST)

	SLEEPK	3
	PULLP	a0
	dsj	a0,#again

	RETP

#*****************************************************************************
*
* convert team cursor position into actual team number
*
*-----------------------------------------------------------------------------
 SUBRP	get_team_number

	move	*a13(PC_CURSPOS),a0	;position
	sll	4,a0			;x16 bits
	addi	team_convert,a0
	move	*a0,a0
	rets

#*****************************************************************************
*
* process that displays PRESS START & INSERT COIN in player stat boxes
*
*-----------------------------------------------------------------------------

 SUBR	credit_messages

MESSAGE_Y	equ	216<<16

	movk	4,a4
	movi	message1_obj,a5
	movi	#msg_x,a6
	move	@TWOPLAYERS,a0			;0 = NO, 1 = YES 2 players
	jrz	#not_kit
	movi	#msg_x2,a6
#not_kit
#init_loop
	move	*a6+,a0				;x val
	sll	16,a0
	PUSH	a4,a5,a6

	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#skip_chk
	cmpi	1,a4				;no player 1
	jreq	#skip
	cmpi	4,a4				;no player 4
	jreq	#skip
#skip_chk

	movi	MESSAGE_Y,a1			;y val
	movi	start3,a2			;* image
	movi	127,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
#skip
	PULL	a4,a5,a6
	move	a8,*a5+,L
	dsj	a4,#init_loop

#msg_loop
	movk	1,a1				;player 2
	move	@message2_obj,a8,L
	calla	update_credit_message

	movk	2,a1				;player 3
	move	@message3_obj,a8,L
	calla	update_credit_message

	move	@TWOPLAYERS,a0			;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrs

	clr	a1				;player 1
	move	@message1_obj,a8,L
	calla	update_credit_message

	movk	3,a1				;player 4
	move	@message4_obj,a8,L
	calla	update_credit_message

#2_plyrs
	SLEEPK	1
	jruc	#msg_loop


#msg_x	.word	56,145,250,339			;x val

#msg_x2	.word	0,101,295,0			;x val


#*****************************************************************************
*
* INPUT:	a8 = * message obj
*		a1 = player bit number (0-3)
*-----------------------------------------------------------------------------

;prints either Insert Coin or Press Start based on # credits

 SUBRP	update_credit_message

	move	a1,a9

	move	@PSTATUS,a0
	btst	a1,a0
	jrnz	#player_active

	move	@in_team_select,a14
	jrz	#no
;Check to see if teammate is in game, if so, don't blink messages over
;attributes
	XORK	1,a1
	btst	a1,a0
	jrnz	#player_active
#no

	move	@PCNT,a0		;frame count
	btst	5,a0
	jrnz	#objoff

	movk	ADJFREPL,a0		;in free play?
	calla	GET_ADJ
	jrnz	#in_free

;Check to see if in INFREEPRICE GAMSTATE
	move	@winningteam,a0		;0 or 1
	jrnn	#tmfree

	move	@GAMSTATE,a0
	cmpi	INFREEPRICE,a0
	jrnz	#no1
#tmfree
	move	@scores,a0
	move	@scores+16,a1
	cmp	a0,a1
	jrlt	#tm1
;Team 2 has won!  Print PRESS START for these guys
	cmpi	2,a9
	jrge	#in_free
	jruc	#no1
#tm1	cmpi	2,a9
	jrlt	#in_free

#no1
	movi	insert3,a10		;Insert Coin message

	movk	ADJCSTRT,a0		;get # credits to start
	calla	GET_ADJ
	move	a0,a9
	calla	CRED_P			;# credits returned in A0
	cmp	a0,a9
	jrgt	#no_credits

#in_free
	movi	start3,a10		;Press Start message
#no_credits
	calla	obj_on
	move	a10,a0			;* image
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image
	rets

#objoff
	movk	ADJFREPL,a0		;in free play?
	calla	GET_ADJ
	jrz	#not_free

	calla	obj_on
	movi	freplay3,a0		;* image
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image
	rets

#not_free
#player_active
	calla	obj_off
	rets

#*****************************************************************************

MESSAGE_Y	equ	216<<16

 SUBRP	player_cursor


	move	a10,*a13(PC_PLAYNUM)
#resart_cursor
	movk	1,a0
	move	*a13(PC_PLAYNUM),a1
	sll	a1,a0
	move	@exit_status,a1
	andn	a0,a1
	move	a1,@exit_status		;exit


	move	*a13(PC_PLAYNUM),a10

	move	a10,a0
	sll	5,a0				;x 32 bits
	addi	#player_data,a0
	move	*a0,a1,L			;start address of player data
	movi	PR_INIT1,a2
	add	a1,a2
	move	a2,*a13(PC_DATADDR),L		;start of player data

	movi	-1,a0				;init player data to -1
	move	a0,*a1(PR_COUNT)
	move	a0,*a1(PR_INIT1)
	move	a0,*a1(PR_INIT2)
	move	a0,*a1(PR_INIT3)

	move	a10,a0
	sll	6,a0				;x 64
	addi	#center_xs,a0
	move	*a0+,a1
	move	a1,*a13(PC_CENTERX)		;name center X
	move	*a0+,a1
	move	a1,*a13(PC_CENTERX2)		;stats box center X
	move	*a0,a1
	move	a1,*a13(PC_CENTERXkit)		;name center X (kit)

	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)

	move	a10,a0
	sll	4,a0				;x 16 bits
	addi	#obj_ids,a0
	move	*a0,a0
	move	a0,*a13(PC_OBJID)		;OBJ ID's created by this PROC
	movk	10h,a1				;mask (bits to remove)
	calla	obj_delc

#wait_for_player
	SLEEPK	1
	move	*a13(PC_PLAYNUM),a1
	move	@PSTATUS,a0
	btst	a1,a0
	jrz	#wait_for_player
	move	@force_selection,a0
	jrnz	#youre_out

;player 1 active

	move	@can_enter_inits,a0	;can player enter initials?
	jrnz	#enter_ok
	DIE

#enter_ok

	movk	ADJTOURNEY,a0		;Tournament mode?
	calla	GET_ADJ			;0-1
	jrnz	#skip			;Br=Not in tournament mode
;Turn on tournament mode - no secrets message
	move	*a13(PC_PLAYNUM),a8

	.ref	nosecrets_drw
	CREATE0	nosecrets_drw
	movk	1,a0
	move	*a13(PC_PLAYNUM),a1
	sll	a1,a0
	move	@exit_status,a1
	or	a0,a1
	move	a1,@exit_status		;no exit
	SLEEP	90
#skip
	movk	1,a0
	move	*a13(PC_PLAYNUM),a1
	sll	a1,a0
	move	@exit_status,a1
	or	a0,a1
	move	a1,@exit_status		;no exit

	movi	[250,0],a0		;x val
	movi	[80,0],a1		;y val
	movi	SGMD8_A,a2		;* image
	movk	1,a3			;z pos
	movi	DMACAL,a4		;DMA flags
	move	*a13(PC_OBJID),a5
	ori	10h,a5			;object	ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	movi	0101h,a0
	move	a0,*a8(OCONST)
	move	a8,*a13(PC_CURSOBJ),L

	move	*a13(PC_OBJID),a5
	ori	10h,a5			;ID
	calla	create_name_objs

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0			;x 32 bits
	addi	#player_menus,a0
	move	@TWOPLAYERS,a1
	jrz	#not_2p
	addi	4*32,a0
#not_2p
	move	*a0,a0,L		;menu start
	move	a0,*a13(PC_MENUBASE),L
	clr	a0			;menu number
	move	a0,*a13(PC_MENULEVEL)
	calla	create_menu
	calla	create_heading
	calla	update_cursor

;	calla	update_statbox_images

	SLEEPK	1

#loop
	movi	PSEL_START_DELAY,a10	;initial repeat delay
#repeat_delay
	SLEEPK	1

	move	*a13(PC_PLAYNUM),a1
	move	@PSTATUS,a0
	btst	a1,a0
	jrz	#resart_cursor

	move	@force_selection,a0
	jrnz	#resart_cursor

	move	@page_scrolling,a0
	jrnz	#loop			;scrolling on, so no input

	move	*a13(PC_FLASHCOUNT),a0	;cursor flash count
	inc	a0
	move	a0,*a13(PC_FLASHCOUNT)

	calla	save_selection
	calla	update_statbox_images

	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down
	jrz	#no_action

	JSRP	button_actions
	move	*a13(PC_MENULEVEL),a0
	cmpi	3,a0
	jreq	#done
#no_action
	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_down
	jrnz	#movit
	calla	update_cursor
	dsj	a10,#repeat_delay
	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_cur
	calla	move_cursor
	calla	update_cursor
	movi	PSEL_REPEAT_DELAY,a10	;repeat delay
	jruc	#repeat_delay
#movit
	calla	move_cursor
	calla	update_cursor
	jruc	#loop

#done
	move	*a13(PC_CURSOBJ),a0,L	;delete cursor
	calla	DELOBJ

	SLEEPK	1

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0			;x 32 bits
	addi	#player_data,a0
	move	*a0,a0,L		;start address of player data
	move	a0,*a13(PC_DATADDR),L	;start of player data
	calla	get_player_record

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_RANK),a0
	cmpi	10,a0
	jrgt	#not_topten

	move	*a13(PC_PLAYNUM),a10
	move	a10,a0
	sll	5,a0			;x 32 bits
	addi	topten_imgs,a0

	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#not_2pxz
	addi	4*32,a0
#not_2pxz


	move	*a0,a9,L
	CREATE0	topten_player

#not_topten

	move	*a13(PC_DATADDR),a3,L	;start of player data
	move	*a13(PC_PLAYNUM),a10
	calla	check_initials

	calla	print_player_stats

	move	*a13(PC_DATADDR),a3,L	;start of player data
	move	*a3(PR_INIT1),a0
	jrnz	#not_AAA_JAN_1
	move	*a3(PR_INIT2),a0
	jrnz	#not_AAA_JAN_1
	move	*a3(PR_INIT3),a0
	jrnz	#not_AAA_JAN_1
	move	*a3(PR_MONTH),a0
	jrnz	#not_AAA_JAN_1
	move	*a3(PR_DAY),a0
	jrnz	#not_AAA_JAN_1

;is AAA JAN 1				;so erase his ass

	movi	-1,a0
	move	a0,*a3(PR_INIT1)
	move	a0,*a3(PR_INIT2)
	move	a0,*a3(PR_INIT3)
	clr	a0
	move	a0,*a3(PR_COUNT)

#not_AAA_JAN_1

	movk	30,a10
#dly1
	SLEEPK	1
	move	*a13(PC_PLAYNUM),a1
	move	@PSTATUS,a0
	btst	a1,a0
	jrz	#resart_cursor
	move	@force_selection,a0
	jrnz	#youre_out
	dsj	a10,#dly1


	movi	7*60,a10
#wait	SLEEPK	1
	move	*a13(PC_PLAYNUM),a1
	move	@PSTATUS,a0
	btst	a1,a0
	jrz	#resart_cursor
	move	@force_selection,a0
	jrnz	#youre_out
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_cur
	jrnz	#exit1
	dec	a10
	jrnz	#wait
	jruc	#ex2

bounce_snd	.word	>fc80,10,>8129,0	;Ball bounce

#exit1
;Do a snd when whacking through
	SOUND1	bounce_snd
#ex2

	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	calla	obj_del1c		;delete all objs with this ID

	move	*a13(PC_DATADDR),a1,L	;start of player data

	move	*a1(PR_NUMDEF),a0	;number teams defeated
	jrz	#no_wins
	cmpi	27,a0
	jreq	#defeated_all

;;;	calla	create_heading
	calla	print_teams_defeated

	movk	30,a10
#dly2
	SLEEPK	1
	move	*a13(PC_PLAYNUM),a1
	move	@PSTATUS,a0
	btst	a1,a0
	jrz	#resart_cursor
	move	@force_selection,a0
	jrnz	#youre_out
	dsj	a10,#dly2

	movi	7*60,a10
#wait2	SLEEPK	1
	move	*a13(PC_PLAYNUM),a1
	move	@PSTATUS,a0
	btst	a1,a0
	jrz	#resart_cursor
	move	@force_selection,a0
	jrnz	#youre_out
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_cur
	jrnz	#exit2a
	dec	a10
	jrnz	#wait2
	jruc	#exit2
#exit2a

	SOUND1	bounce_snd

#exit2
	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	calla	obj_del1c		;delete all objs with this ID

#defeated_all
#no_wins
	movk	10,a10
#dly3
	SLEEPK	1
	move	*a13(PC_PLAYNUM),a1
	move	@PSTATUS,a0
	btst	a1,a0
	jrz	#resart_cursor
	move	@force_selection,a0
	jrnz	#youre_out
	dsj	a10,#dly3
#youre_out
	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	calla	obj_del1c		;delete all objs with this ID

	movk	1,a0
	move	*a13(PC_PLAYNUM),a1
	sll	a1,a0
	move	@exit_status,a1
	andn	a0,a1
	move	a1,@exit_status		;exit

	DIE


topten_imgs
	.long	TopTenorg
	.long	TopTengrn
	.long	TopTengld
	.long	TopTenred

;For kit
	.long	TopTengrn
	.long	TopTenorg
	.long	TopTenred
	.long	TopTengld

#obj_ids
	.word	TYPTEXT|SUBPL1
	.word	TYPTEXT|SUBPL2
	.word	TYPTEXT|SUBPL3
	.word	TYPTEXT|SUBPL4

#center_xs
	.word	52,56,	0,0		;player 1
	.word	149,145,101,0		;player 2
	.word	246,250,295,0		;player 3
	.word	343,339,0,0		;player 4

;	.word	52,57	;player 1
;	.word	148,145	;player 2
;	.word	245,251	;player 3
;	.word	342,339	;player 4

#player_data
	.long	player1_data,player2_data
	.long	player3_data,player4_data

#player_menus
	.long	player1_menus,player2_menus
	.long	player3_menus,player4_menus

	.long	player1k_menus,player1k_menus
	.long	player2k_menus,player2k_menus


#*****************************************************************************
joy_moves
	.long	#zip		;0
	.long	#up		;1
	.long	#down		;2
	.long	#zip		;3
	.long	#left		;4
	.long	#up_left	;5
	.long	#down_left	;6
	.long	#zip		;7
	.long	#right		;8
	.long	#up_right	;9
	.long	#down_right	;10
	.long	#zip		;11
	.long	#zip		;12
	.long	#zip		;13
	.long	#zip		;14
	.long	#zip		;15

*******************
#zip		;0
	rets
defeated
	.long	player1_data+PR_TEAMSDEF
	.long	player2_data+PR_TEAMSDEF
	.long	player3_data+PR_TEAMSDEF
	.long	player4_data+PR_TEAMSDEF

*******************
#up		;1

	move	*a13(PC_TABWIDTH),a1	;table width
	move	*a13(PC_CURSPOS),a0
	sub	a1,a0
	jrlt	#no_up
	move	a0,*a13(PC_CURSPOS)
	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)		;cursor flash count

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
	addi	cursor_sounds,a0
	move	*a0,a0,L
	calla	snd_play1
#no_up
	rets

*******************
#down		;2

	move	*a13(PC_TABWIDTH),a1	;table width
	move	*a13(PC_CURSPOS),a10
	add	a1,a10
	move	*a13(PC_TABSIZE),a1	;table size
	cmp	a10,a1
	jrle	#no_down

	move	a10,*a13(PC_CURSPOS)
	calla	get_table_address
	move	*a1+,a0			;char under cursor
	cmpi	123,a0
	jrnz	#not_blankd
;
;	jrnn	#not_blankd

;MJT
	move	@team1_control,a0
	move	*a13(PC_PLAYNUM),a1
	jrz	#lft
	move	@team2_control,a0
#lft
	sll	5,a0
	addi	defeated,a0
	move	*a0,a0,L
	move	*a0,a0,L
	cmpi	07ffffffh,a0
	jrz	#not_blankd


	move	*a13(PC_TABWIDTH),a1	;table width
	sub	a1,a10			;can't move down
#not_blankd
	move	a10,*a13(PC_CURSPOS)
	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)		;cursor flash count
	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
	addi	cursor_sounds,a0
	move	*a0,a0,L
	calla	snd_play1
#no_down
	rets

*******************
#left		;4

	move	*a13(PC_CURSPOS),a10
	jrz	#no_left
	dec	a10
	move	a10,*a13(PC_CURSPOS)
	calla	get_table_address
	move	*a1+,a0			;char under cursor
	cmpi	123,a0
	jrnz	#not_blankl

;	jrnn	#not_blankl
    
;MJT
	move	@team1_control,a0
	move	*a13(PC_PLAYNUM),a1
	jrz	#lft1
	move	@team2_control,a0
#lft1
	sll	5,a0
	addi	defeated,a0
	move	*a0,a0,L
	move	*a0,a0,L	
	cmpi	07ffffffh,a0
	jrz	#not_blankl



	dec	a10			;skip to left of blank position
#not_blankl
	move	a10,*a13(PC_CURSPOS)
	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)		;cursor flash count

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
	addi	cursor_sounds,a0
	move	*a0,a0,L
	calla	snd_play1
#no_left
	rets

*******************
#up_left	;5
	calla	#up
	calla	#left
	rets

*******************
#down_left	;6
	calla	#down
	calla	#left
	rets

*******************
#right		;8

	move	*a13(PC_CURSPOS),a10
	inc	a10
	move	*a13(PC_TABSIZE),a1	;table size
	cmp	a10,a1
	jrle	#no_right
	move	a10,*a13(PC_CURSPOS)
	calla	get_table_address
	move	*a1+,a0			;char under cursor
	cmpi	123,a0
	jrnz	#not_blankr

;	jrnn	#not_blankr

    
;MJT
	move	@team1_control,a0
	move	*a13(PC_PLAYNUM),a1
	jrz	#lft2
	move	@team2_control,a0
#lft2
	sll	5,a0
	addi	defeated,a0
	move	*a0,a0,L
	move	*a0,a0,L	
	cmpi	07ffffffh,a0
	jrz	#not_blankr



	inc	a10			;skip to right of blank position
#not_blankr
	move	a10,*a13(PC_CURSPOS)
	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)		;cursor flash count

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
	addi	cursor_sounds,a0
	move	*a0,a0,L
	calla	snd_play1
#no_right
	rets

*******************
#up_right	;9
	calla	#up
	calla	#right
	rets

*******************
#down_right	;10
	calla	#down
	calla	#right
	rets

#*****************************************************************************
; a8 = * alpha table
; a9 = palette number (indexed into #palettes table)
;a10 = [y,x] start pos
;a11 = OBJECT ID

 SUBRP	display_alpha_table

	PUSH	a6,a7

	sll	5,a9				;x 32 bits
	addi	#palettes,a9
	move	*a9,a0,L
	calla	pal_getf
	move	a0,a9

#next_alpha
	move	*a8+,a0
	jrn	#finished
	sll	5,a0				;x 32 bits
	addi	alpha_table,a0
	move	*a0,a2,L			;* image
	cmpi	C_SAN,a2
	jrnz	#no
	LOCKUP
#no
	move	*a8+,a0
	movx	a10,a1				;x start pos
	add	a1,a0
	sll	16,a0				;x val	[int,frac]
	move	*a8+,a1
	sll	16,a1				;y val	[ing,frac]
	add	a10,a1				;y start pos
	andi	[0ffffh,0],a1			;clear fractional
	movk	8,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	move	a11,a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel

	PUSH	a8,a11
	calla	BEGINOBJ2
	move	a9,*a8(OPAL),L			;Set palette & constant
	PULL	a8,a11
	jruc	#next_alpha
#finished
	PULL	a6,a7
	rets

#palettes
;	.long	ORANGPAL,GREENPAL,GOLD,REDPAL
	.long	BLUE,BLUE,REDPAL,REDPAL
	.long	0,0,0,0
	.long	SGMD8YEL,SGMD8VIO		;left & right city columns

#*****************************************************************************

 SUBR	credits
 	
	move	@gmqrtr,a0
	cmpi	2,a0
	jrz	#skp
	clr	a0				;y offset
	calla	create_credits
#skp
	calla	create_credit_timers

#credit_loop
	calla	update_credits
	calla	update_credit_timers
	SLEEPK	1
	jruc	#credit_loop

#*****************************************************************************

 SUBR	credits2

	movi	[7,0],a0			;y offset
	calla	create_credits

#credit_loop
	calla	update_credits
	SLEEPK	1
	jruc	#credit_loop

#*****************************************************************************

 SUBR	credits3

	clr	a0				;y offset
	calla	create_credits

#credit_loop
	calla	update_credits
	SLEEPK	1
	jruc	#credit_loop

#*****************************************************************************

	.asg	240<<16,CREDIT_Y
	.asg	209<<16,CREDIT_X

 SUBR	create_credits

	PUSH	a0
	movi	CREDIT_Y-1,a1			;y val
	add	a0,a1
	movi	CREDIT_X,a0			;x val
	movi	font60,a2			;* image
	movi	20000-1,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object	ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@credit1_obj,L

	PULL	a0
	PUSH	a0
	movi	CREDIT_Y-1,a1			;y val
	add	a0,a1
	movi	CREDIT_X+(6<<16),a0		;x val
	movi	font60,a2			;* image
	movi	20000-1,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object	ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@credit2_obj,L


	movi	credit,a2			;* image
	movk	ADJFREPL,a0
	calla	GET_ADJ
	jrz	#not_free

	move	@credit1_obj,a8,L
	calla	obj_off
	move	@credit2_obj,a8,L
	calla	obj_off

	movi	freeply,a2			;* image

#not_free
	PULL	a0
	movi	CREDIT_Y-1,a1			;y val
	add	a0,a1
	movi	CREDIT_X-(31<<16),a0		;x val
	movi	20000-1,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object	ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@credit3_obj,L

	rets


#*****************************************************************************

 SUBRP	update_credits

	movk	ADJFREPL,a0
	calla	GET_ADJ
	jrz	#not_free

;in free play
	move	@credit1_obj,a8,L
	calla	obj_off
	move	@credit2_obj,a8,L
	calla	obj_off

	move	@credit3_obj,a8,L
	movi	freeply,a0		;* image
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image
	rets

#not_free
	move	@credit3_obj,a8,L
	movi	credit,a0		;* image
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image

	calla	CRED_P			;# credits returned in A0
	calla	BINBCD
	PUSH	a0
	andi	0f0h,a0
	jrnz	#ok
	move	@credit1_obj,a8,L
	calla	obj_off
	jruc	#cont
#ok
;;;	srl	4,a0			;/16
;;;	sll	5,a0			;*32 bits
	sll	1,a0			;*32/16 = *2
	addi	#numbers,a0
	move	*a0,a1,L		;* image
	move	@credit1_obj,a8,L
	calla	obj_on
	move	a1,a0
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image
#cont

	PULL	a0
	andi	0fh,a0
	sll	5,a0			;*32 bits
	addi	#numbers,a0
	move	*a0,a1,L		;* image
	move	@credit2_obj,a8,L
	calla	obj_on
	move	a1,a0
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image

	rets

#numbers
	.long	font60,font61,font62,font63,font64
	.long	font65,font66,font67,font68,font69


#*****************************************************************************
*
* create the 4 credits timers displayed in the player stats box
*
*-----------------------------------------------------------------------------

 SUBRP	create_credit_timers

	movk	1,a5			;player number 2
	calla	create_cr_timer
	movi	credtime2_obj,a0	;* obj
	move	a8,*a0,L

	movk	2,a5			;player number 3
	calla	create_cr_timer
	movi	credtime3_obj,a0	;* obj
	move	a8,*a0,L


	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrs

	clr	a5			;player number 1
	calla	create_cr_timer
	movi	credtime1_obj,a0	;* obj
	move	a8,*a0,L

	movk	3,a5			;player number 4
	calla	create_cr_timer
	movi	credtime4_obj,a0	;* obj
	move	a8,*a0,L

#2_plyrs

	.ref	join_cyc
	calla	join_cyc
	rets


#*****************************************************************************
*
* INPUT:	a5 = player number (0-3)
*-----------------------------------------------------------------------------

	.asg	235<<16,CREDIT_Y

create_cr_timer

	sll	5,a5				;x 32 bits
	movi	#credit_balls,a2
	movi	#credit_positions,a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#not_2p
	movi	#credit_positions2,a0
#not_2p
	add	a5,a2
	move	*a2,a2,L
	add	a0,a5
	move	*a5,a5,L			;get start x pos

	move	a5,a0				;x val
	movi	CREDIT_Y,a1			;y val
;	move	@gmqrtr,a3
;	cmpi	2,a3
;	jrnz	#skp
;	movi	CREDIT_Y+256*2,a1			;y val
;#skp
	movi	127,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object	ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

	rets

#credit_balls
	.long	t0000		;player 1
	.long	t0000		;player 2
	.long	tx000		;player 3
	.long	tx000		;player 4

#credit_positions
	.long	56<<16		;player 1
	.long	145<<16		;player 2
	.long	251<<16		;player 3
	.long	339<<16		;player 4

#credit_positions2
	.long	0		;player 1
	.long	101<<16		;player 2
	.long	296<<16		;player 3
	.long	0		;player 4

#*****************************************************************************
*
* update the 4 credits timers displayed in the player stats box
*
*-----------------------------------------------------------------------------

 SUBRP	update_credit_timers

	movk	1,a10			;player 2
	movi	credtime2_obj,a6	;* start of obj vars
	move	@qtr_purchased+10h,a7
	calla	update_cr_timer

	movk	2,a10			;player 3
	movi	credtime3_obj,a6	;* start of obj vars
	move	@qtr_purchased+20h,a7
	calla	update_cr_timer

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#2_plyrs

	clr	a10			;player 1
	movi	credtime1_obj,a6	;* start of obj vars
	move	@qtr_purchased,a7
	calla	update_cr_timer

	movk	3,a10			;player 4
	movi	credtime4_obj,a6	;* start of obj vars
	move	@qtr_purchased+30h,a7
	calla	update_cr_timer

#2_plyrs
	rets


#*****************************************************************************
*
* INPUT:	a10 = player number (0-3)
*		a6 = * start of obj vars
*		a7 = # quarters credit
*-----------------------------------------------------------------------------

 SUBRP	update_cr_timer

	move	a7,a7
	jrnz	#not_zip

	movi	txxxx,a0
	jruc	#setit

#not_zip
	move	@gmqrtr,a1
	cmpi	4,a1
	jrlt	#ok
	movi	txxx1,a0
	jruc	#setit

#ok
	sll	2,a1			;x 4
	add	a7,a1
	andi	15,a1
	sll	5,a1			;x 32 bits
	addi	tballs,a1
	move	*a1,a0,L		;* image
#setit
	move	*a6,a8,L		;image *
	move	*a8(OCTRL),a1
	calla	obj_aniq
	rets

tballs
	.long	0
	.long	t1000,t1100,t1110,t1111
	.long	tx100,tx110,tx111,txxxx
	.long	txx10,txx11,txxxx,txxxx
	.long	txxx1,txxxx,txxxx,txxxx

	.long	tx000,txx00,txxx0
	.long	tx100,tx110,tx111
	.long	txx10,txx11,txxx1
	.long	t0000


leds	.long	S_LED_0,S_LED_1,S_LED_2,S_LED_3,S_LED_4
	.long	S_LED_5,S_LED_6,S_LED_7,S_LED_8,S_LED_9	


#*****************************************************************************
*
* INPUT:	a8 = * object
*-----------------------------------------------------------------------------

 SUBR	obj_on
 	move	*a8(OYPOS),a0
	andni	400h,a0
	move	a0,*a8(OYPOS)
 	rets


#*****************************************************************************
*
* INPUT:	a8 = * object
*-----------------------------------------------------------------------------

 SUBR	obj_off
 	move	*a8(OYPOS),a0
	ori	400h,a0
	move	a0,*a8(OYPOS)
 	rets


******************************************************************************
*
* INPUT:	a10 = scroll increment << 16
*-----------------------------------------------------------------------------
*
* scrolls screen up or down 1 page (256 pixels)
*
*-----------------------------------------------------------------------------

 SUBR	scroll_page

;	clr	a0
;	clr	a1
;	movi	200,a2
;	calla	KOP_ALL

	calla	pal_clean
 
	movk	1,a0
	move	a0,@page_scrolling	;scrolling

	movi	scroll_snd,a0
	calla	snd_play1

	movi	256/SCROLL_SPEED,a9

#scroll_loop
	SLEEPK	1

	move	@WORLDTLY,a0,L
	add	a10,a0			;+/- SCROLL_SPEED
	move	a0,@WORLDTLY,L

	calla	BGND_UD1

	dsj	a9,#scroll_loop

	SLEEPK	2
	clr	a0
	move	a0,@page_scrolling	;not scrolling
	RETP

#*****************************************************************************
*
* deletes background objects off bottom of screen
*
*-----------------------------------------------------------------------------

 SUBRP	del_offscreen_bobjs

	move	@WORLDTLY,a8,L		;TOP LEFT Y SCREEN COORD (WORLD)
	srl	16,a8
;	addi	100,a8	;254,a8
	addi	254,a8

	movi	BAKLST,a10
	jruc	#start
#next_bobj
	move	*a10(OYPOS),a0
	cmp	a8,a0			;a0-a8
	jrlt	#not_off
	move	a10,a0
	calla	DELBOBJ
	move	a9,a10			;back to prev obj
#not_off
#start
	move	a10,a9			;prev obj
	move	*a10,a10,L
	jrnz	#next_bobj
	rets


#*****************************************************************************


 SUBR	monitor_fullgame

	clr	a0
	move	a0,@game_purchased		;

#loopit
	clr	a4
#next
	move	@PSTATUS,a0
	btst	a4,a0
	jrz	#no_player

	move	@game_purchased,a0
	btst	a4,a0
	jrnz	#purchased



;2/10/93
	move	a4,a1			;plyr number
	sll	4,a1			;x 16 bits
	addi	qtr_purchased,a1
	move	*a1,a0
	cmpi	4,a0
	jrz	#fullgm





	movi	ADJFULLG,a0
	calla	GET_ADJ
	move	a0,a1


	move	a4,a0
	sll	5,a0			;x 32 bits
	addi	#times,a0
	move	*a0,a0,L		;* player timer
	move	*a0,a0			;player credits purchased
	cmp	a1,a0
	jrlt	#no_purchase

#fullgm
	move	a4,a0
	movk	1,a1
	sll	a0,a1
	move	@game_purchased,a0	;set purchased bit
	or	a1,a0			;for player
	move	a0,@game_purchased

	move	a4,a1			;plyr number
	sll	4,a1			;x 16 bits
	addi	qtr_purchased,a1
	movk	4,a0
	move	a0,*a1			;4 quarters purchased

	move	a4,a0
	sll	5,a0
	addi	#pdta_t,a0
	move	*a0,a0,L
	movi	3500,a1
	move	a1,*a0			;Stuff 2500 into plyrs ply_time


	move	a4,a0
	sll	5,a0			;x 32 bits
	addi	#images,a0



	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#not_2p1
	addi	4*32,a0
#not_2p1


	move	*a0,a9,L		;* image
	PUSH	a4
	sll	4,a4			;x 16 bits
	addi	#plaque_xs,a4
	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not_2p
	addi	4*16,a4
#not_2p
	move	*a4,a10
	sll	16,a10			;x pos
	CREATE0	fullgame_purchased

	movi	AUD_PURCHASED,a0	;inc full games
	calla	AUD1			;purchased audit

	PULL	a4
#no_player
#purchased
#no_purchase
	inc	a4
	cmpi	4,a4
	jrlt	#next

	SLEEPK	2
	jruc	#loopit

#images
	.long	FulGameorg,FulGamegrn
	.long	FulGamegld,FulGamered

	.long	FulGameorg,FulGameorg
	.long	FulGamered,FulGamered

#plaque_xs
	.word	15,104,209,298
	.word	0,101-42,296-42,0

#times
	.long	P1DATA+crds_paid
	.long	P2DATA+crds_paid
	.long	P3DATA+crds_paid
	.long	P4DATA+crds_paid
#pdta_t
	.long	P1DATA+ply_time
	.long	P2DATA+ply_time
	.long	P3DATA+ply_time
	.long	P4DATA+ply_time

#*****************************************************************************
	.asg	212-14+1,FULLGAME_Y
 SUBRP	fullgame_purchased
	SLEEPK	1
	move	@HALT,a0
	jrnz	fullgame_purchased

	move	a10,a0				;x val
	movi	[FULLGAME_Y-(16*16),0],a1	;y val
	move	a9,a2				;* image
	movi	30000,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	movi	[16,0],a7			;y vel
	calla	BEGINOBJ2

	movi	0808h,a0
	move	a0,*a8(OCONST)

#waitf
	SLEEP	1
	move	*a8(OYPOS),a0
	cmpi	FULLGAME_Y,a0
	jrlt	#waitf

	movi	FULLGAME_Y,a0
	move	a0,*a8(OYPOS)

	clr	a0
	move	a0,*a8(OYVEL),L

	SOUND1	fullgame_snd1
	movk	3,a10
#again
	calla	const_on
	SLEEPK	3
	calla	const_off
	SLEEPK	3
	dsj	a10,#again

	SLEEP	2*60

	SOUND1	select_snd1
	movk	3,a10
#again2
	calla	const_on
	SLEEPK	3
	calla	const_off
	SLEEPK	3
	dsj	a10,#again2

	calla	DELOBJA8

	DIE


const_on
	move	*a8(OCTRL),a0
	andni	01111b,a0
	ori	M_CONST,a0		;Replace all with constant
	move	a0,*a8(OCTRL)
	rets

const_off
	move	*a8(OCTRL),a0
	andni	01111b,a0
	ori	M_WRNONZ,a0
	move	a0,*a8(OCTRL)
	rets

#*****************************************************************************
;a9 = * image
;a10 = player number (0-3)

	.asg	212-14+1,TOPTEN_Y

 SUBRP	topten_player

	SLEEPK	1
	move	@HALT,a0
;	jrnz	fullgame_purchased
	jrnz	topten_player

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#not_2p
	addk	4,a10
#not_2p
	sll	4,a10				;x 16
	addi	#topten_xs,a10
	move	*a10,a0				;x val
	sll	16,a0
	movi	[TOPTEN_Y,0],a1			;y val
	move	a9,a2				;* image
	movi	30000-1,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

	movi	0808h,a0
	move	a0,*a8(OCONST)

	SLEEPK	1

	SOUND1	select_snd1
	movk	3,a10
#again
	calla	const_on
	SLEEPK	3
	calla	const_off
	SLEEPK	3
	dsj	a10,#again

	SLEEP	1*60

	SOUND1	select_snd1
	movk	3,a10
#again2
	calla	const_on
	SLEEPK	3
	calla	const_off
	SLEEPK	3
	dsj	a10,#again2

	calla	DELOBJA8

	DIE

#topten_xs
	.word	15,104,209,298
	.word	0,101-42,296-42,0


#*****************************************************************************

 SUBR	monitor_buyins

	move	@PSTATUS,a10
#again
	SLEEPK	1
	move	a10,a1
	move	@PSTATUS,a10
	move	a10,a0
	xor	a0,a1			;bits changed
	and	a0,a1			;down transitions only
	jrz	#again
	jruc	#again

#*****************************************************************************
*
* sets which player is controlling each team
*
*-----------------------------------------------------------------------------

 SUBR	team_control

#again
	move	@team1_control,a0
	jrn	#no_control1
	move	@PSTATUS,a1
	btst	a0,a1
	jrnz	#team1_ok
#no_control1
	move	@PSTATUS,a0
	btst	0,a0
	jrz	#no_player1
	clr	a0
	move	a0,@team1_control
	jruc	#team1_ok
#no_player1
	move	@PSTATUS,a0
	btst	1,a0
	jrz	#no_player2
	movk	1,a0
	move	a0,@team1_control
	jruc	#team1_ok
#no_player2
	movi	-1,a0
	move	a0,@team1_control
	move	a0,@team1
#team1_ok


	move	@team2_control,a0
	jrn	#no_control2
	move	@PSTATUS,a1
	btst	a0,a1
	jrnz	#team2_ok
#no_control2
	move	@PSTATUS,a0
	btst	2,a0
	jrz	#no_player3
	movk	2,a0
	move	a0,@team2_control
	jruc	#team2_ok
#no_player3
	move	@PSTATUS,a0
	btst	3,a0
	jrz	#no_player4
	movk	3,a0
	move	a0,@team2_control
	jruc	#team2_ok
#no_player4
	movi	-1,a0
	move	a0,@team2_control
	move	a0,@team2
#team2_ok
	SLEEP	1
	jruc	#again


#*****************************************************************************
*
* find plate objects on team select screen for flashing
*
*-----------------------------------------------------------------------------

	.asg	67,PLATE1Z
	.asg	68,PLATE2Z

 SUBRP	find_plates

	movi	plate1_objs,a4		;plate behind heads & logo
	movi	plate2_objs,a5		;

	movi	BAKLST,a10
	jruc	#start
#next_bobj
	move	*a10(OZPOS),a0
	cmpi	PLATE1Z,a0
	jreq	#is_plate1
	cmpi	PLATE2Z,a0
	jreq	#is_plate2
#start
	move	*a10,a10,L
	jrnz	#next_bobj

	rets

#is_plate1
	move	a10,*a4+,L
	jruc	#start

#is_plate2
	move	a10,*a5+,L
	jruc	#start




******************************************************************************
	.asg	000,O1
	.asg	084,O2
	.asg	162,O3
	.asg	233,O4
	.asg	12,Y
	.asg	96,C
	.asg	151,C2
city_table_left
	.word	2,2		;width, size
	;img, xoff, yoff
	.word	C2+0,O1,Y*0,C2+1,O2,Y*0	;0-3
	.word	-1

;	.word	2,2*7		;width, size
;	;img, xoff, yoff
;	.word	C+14,O1,Y*0,C+21,O2,Y*0
;	.word	C+15,O1,Y*1,C+22,O2,Y*1
;	.word	C+16,O1,Y*2,C+23,O2,Y*2
;	.word	C+17,O1,Y*3,C+24,O2,Y*3
;	.word	C+18,O1,Y*4,C+25,O2,Y*4
;	.word	C+19,O1,Y*5,C+26,O2,Y*5
;	.word	C+20,O1,Y*6,-1,0,0
;	.word	-1
city_table_right
	.word	2,2		;width, size
;	;img, xoff, yoff
	.word	C2+2,O3,000,C2+03,O4,000
	.word	-1

;	.word	2,2*7		;width, size
;	;img, xoff, yoff
;	.word	C+0,O3,000,C+07,O4,000
;	.word	C+1,O3,Y*1,C+08,O4,Y*1
;	.word	C+2,O3,Y*2,C+09,O4,Y*2
;	.word	C+3,O3,Y*3,C+10,O4,Y*3
;	.word	C+4,O3,Y*4,C+11,O4,Y*4
;	.word	C+5,O3,Y*5,C+12,O4,Y*5
;	.word	C+6,O3,Y*6,C+13,O4,Y*6
;	.word	-1
city_table
	.word	4,4*7		;width, size
	.word	C+14,O1,Y*0,C+21,O2,Y*0,C+0,O3,000,C+07,O4,000	;0-3
	.word	C+15,O1,Y*1,C+22,O2,Y*1,C+1,O3,Y*1,C+08,O4,Y*1	;4-7
	.word	C+16,O1,Y*2,C+23,O2,Y*2,C+2,O3,Y*2,C+09,O4,Y*2	;8-11
	.word	C+17,O1,Y*3,C+24,O2,Y*3,C+3,O3,Y*3,C+10,O4,Y*3	;12-15
	.word	C+18,O1,Y*4,C+25,O2,Y*4,C+4,O3,Y*4,C+11,O4,Y*4	;16-19
	.word	C+19,O1,Y*5,C+26,O2,Y*5,C+5,O3,Y*5,C+12,O4,Y*5	;20-23
	.word	C+20,O1,Y*6,C+27,O2,Y*6,C+6,O3,Y*6,C+13,O4,Y*6	;24-26

;	.word	C+20,O1,Y*6,-1,0,0,	C+6,O3,Y*6,C+13,O4,Y*6	;24-26

	.word	-1


******************************************************************************
	.asg	21,X
	.asg	23,Y	;22
name_table
	.word	4,4*7		;width, size
	;img, xoff, yoff
	.word	00,0,000,	01,X*1,000,	02,X*2,000,	03,X*3,000	;abcd
	.word	04,0,Y*1,	05,X*1,Y*1,	06,X*2,Y*1,	07,X*3,Y*1	;efgh
	.word	08,0+3,Y*2,	09,X*1,Y*2,	10,X*2,Y*2,	11,X*3,Y*2	;ijkl
	.word	12,0-2,Y*3,	13,X*1,Y*3,	14,X*2,Y*3,	15,X*3,Y*3	;mnop
	.word	16,0,Y*4,	17,X*1,Y*4,	18,X*2,Y*4,	19,X*3,Y*4	;qrst
	.word	20,0,Y*5,	21,X*1,Y*5,	22,X*2-3,Y*5,	23,X*3,Y*5	;uvwx
	.word	24,0,Y*6,	25,X*1,Y*6,	28,X*2-2,Y*6,	27,X*3,Y*6	;yz <
	.word	-1

******************************************************************************
	.asg	30,X
	.asg	23,Y	;22
name_table2
	.word	4,4*7		;width, size
	;img, xoff, yoff
	.word	00,0,000,	01,X*1,000,	02,X*2,000,	03,X*3,000	;abcd
	.word	04,0,Y*1,	05,X*1,Y*1,	06,X*2,Y*1,	07,X*3,Y*1	;efgh
	.word	08,0+3,Y*2,	09,X*1,Y*2,	10,X*2,Y*2,	11,X*3,Y*2	;ijkl
	.word	12,0-2,Y*3,	13,X*1,Y*3,	14,X*2,Y*3,	15,X*3,Y*3	;mnop
	.word	16,0,Y*4,	17,X*1,Y*4,	18,X*2,Y*4,	19,X*3,Y*4	;qrst
	.word	20,0,Y*5,	21,X*1,Y*5,	22,X*2-3,Y*5,	23,X*3,Y*5	;uvwx
	.word	24,0,Y*6,	25,X*1,Y*6,	28,X*2-2,Y*6,	27,X*3,Y*6	;yz <
	.word	-1

*****************************
	.asg	49,X
	.asg	27,Y		;23,Y
month_table
	.word	2,2*6			;width, size
	;img, xoff, yoff
	.word	48,0+4,0*Y,	49,X+2,0*Y	;jan,feb
	.word	50,0,1*Y,	51,X,1*Y	;mar,apr
	.word	52,0,2*Y,	53,X+2,2*Y	;may,jun
	.word	54,0+6,3*Y,	55,X,3*Y	;jul,aug
	.word	56,0+5,4*Y,	57,X+1,4*Y	;sep,oct
	.word	58,0+3,5*Y,	59,X+1,5*Y	;nov,dec
	.word	-1

*****************************
;	.asg	49+24,X
	.asg	73,X
	.asg	27,Y		;23,Y
month_table2
	.word	2,2*6			;width, size
	;img, xoff, yoff
	.word	48,0+4,0*Y,	49,X+2,0*Y	;jan,feb
	.word	50,0,1*Y,	51,X,1*Y	;mar,apr
	.word	52,0,2*Y,	53,X+2,2*Y	;may,jun
	.word	54,0+6,3*Y,	55,X,3*Y	;jul,aug
	.word	56,0+5,4*Y,	57,X+1,4*Y	;sep,oct
	.word	58,0+3,5*Y,	59,X+1,5*Y	;nov,dec
	.word	-1

*****************************
	.asg	22,X
	.asg	22,Y
day_table
	.word	4,4*7+3			;width, size
	;img, xoff, yoff
	.word	64,0*X+4,0*Y,	65,1*X+3,0*Y,	66,2*X+3,0*Y,	67,3*X+2,0*Y	;1,2,3,4
	.word	68,0*X+3,1*Y,	69,1*X+3,1*Y,	70,2*X+3,1*Y,	71,3*X+3,1*Y	;5,6,7,8
	.word	72,0*X+3,2*Y,	73,1*X,2*Y,	74,2*X,2*Y,	75,3*X,2*Y	;9,10,11,12
	.word	76,0*X,3*Y,	77,1*X,3*Y,	78,2*X,3*Y,	79,3*X,3*Y	;13,14,15,16
	.word	80,0*X,4*Y,	81,1*X,4*Y,	82,2*X,4*Y,	83,3*X,4*Y	;17,18,19,20
	.word	84,0*X,5*Y,	85,1*X,5*Y,	86,2*X,5*Y,	87,3*X,5*Y	;21,22,23,24
	.word	88,0*X,6*Y,	89,1*X,6*Y,	90,2*X,6*Y,	91,3*X,6*Y	;25,26,27,28
	.word	92,0*X,7*Y,	93,1*X,7*Y,	94,2*X,7*Y			;29,30,31
	.word	-1

*****************************
	.asg	30,X
	.asg	22,Y
day_table2
	.word	4,4*7+3			;width, size
	;img, xoff, yoff
	.word	64,0*X+4,0*Y,	65,1*X+3,0*Y,	66,2*X+3,0*Y,	67,3*X+2,0*Y	;1,2,3,4
	.word	68,0*X+3,1*Y,	69,1*X+3,1*Y,	70,2*X+3,1*Y,	71,3*X+3,1*Y	;5,6,7,8
	.word	72,0*X+3,2*Y,	73,1*X,2*Y,	74,2*X,2*Y,	75,3*X,2*Y	;9,10,11,12
	.word	76,0*X,3*Y,	77,1*X,3*Y,	78,2*X,3*Y,	79,3*X,3*Y	;13,14,15,16
	.word	80,0*X,4*Y,	81,1*X,4*Y,	82,2*X,4*Y,	83,3*X,4*Y	;17,18,19,20
	.word	84,0*X,5*Y,	85,1*X,5*Y,	86,2*X,5*Y,	87,3*X,5*Y	;21,22,23,24
	.word	88,0*X,6*Y,	89,1*X,6*Y,	90,2*X,6*Y,	91,3*X,6*Y	;25,26,27,28
	.word	92,0*X,7*Y,	93,1*X,7*Y,	94,2*X,7*Y			;29,30,31
	.word	-1

*****************************
alpha_table
	.long	OSGEMD_A,OSGEMD_B,OSGEMD_C,OSGEMD_D,OSGEMD_E,OSGEMD_F,OSGEMD_G,OSGEMD_H		;0-7
	.long	OSGEMD_I,OSGEMD_J,OSGEMD_K,OSGEMD_L,OSGEMD_M,OSGEMD_N,OSGEMD_O,OSGEMD_P		;8-15
	.long	OSGEMD_Q,OSGEMD_R,OSGEMD_S,OSGEMD_T,OSGEMD_U,OSGEMD_V,OSGEMD_W,OSGEMD_X		;16-23
	.long	OSGEMD_Y,OSGEMD_Z,OSGEMD_EXP,OSGEMD_BAK,OSGEMD_SPC,OSGEMD_DEL,0,0		;24-31
	.long	OSGEMD_END,OSGEMD_0,OSGEMD_1,OSGEMD_2,OSGEMD_3,OSGEMD_4,OSGEMD_5,OSGEMD_6	;32-39
	.long	OSGEMD_7,OSGEMD_8,OSGEMD_9,0,0,0,0,0						;40-47
	.long	MD_JAN,MD_FEB,MD_MAR,MD_APR,MD_MAY,MD_JUN,MD_JUL,MD_AUG				;48-55
	.long	MD_SEP,MD_OCT,MD_NOV,MD_DEC,0,0,0,0						;56-63

	.long	OSGENM_1,OSGENM_2,OSGENM_3,OSGENM_4,OSGENM_5,OSGENM_6,OSGENM_7,OSGENM_8		;64,71
	.long	OSGENM_9,OSGENM_10,OSGENM_11,OSGENM_12,OSGENM_13,OSGENM_14,OSGENM_15,OSGENM_16	;72,79
	.long	OSGENM_17,OSGENM_18,OSGENM_19,OSGENM_20,OSGENM_21,OSGENM_22,OSGENM_23,OSGENM_24	;80,87
	.long	OSGENM_25,OSGENM_26,OSGENM_27,OSGENM_28,OSGENM_29,OSGENM_30,OSGENM_31,0		;88,95

	.long	C_ATL		;ATLANTA	(96)
	.long	C_CHAR		;CHARLOTTE
	.long	C_CHIC		;CHICAGO
	.long	C_CLEV		;CLEVELAND
	.long	C_DET		;DETROIT
	.long	C_IND		;INDIANA
	.long	C_MILW		;MILWAUKEE

	.long	C_BOST		;BOSTON		(103)
	.long	C_MIAMI		;MIAMI
	.long	C_NJ		;NEW JERSEY
	.long	C_NY		;NEW YORK
	.long	C_ORL		;ORLANDO
	.long	C_PHIL		;PHILADELPHIA
	.long	C_WASH		;WASHINGTON

	.long	C_GOLD		;GOLDEN STATE	(110)
	.long	C_LAClips	;LOS ANGELES (CLIPPERS)
	.long	C_LALaks	;LOS ANGELES (LAKERS)
	.long	C_PHX		;PHOENIX
	.long	C_PORT		;PORTLAND
	.long	C_SEA		;SEATTLE
	.long	C_SAC		;SACRAMENTO

	.long	C_DAL		;DALLAS		(117)
	.long	C_DEN		;DENVER
	.long	C_HOU		;HOUSTON
	.long	C_MINN		;MINNESOTA
	.long	C_SAN		;SAN ANTONIO
	.long	C_UTAH		;UTAH		(122)
;Use MINN for size?
	.long	C_MINN		;MINNESOTA
;	.long	0		;123


;logos
	.long	T_HAWKS		; 0 ATLANTA	(124)
	.long	T_CELTS		; 1 BOSTON
	.long	T_HORS		; 2 CHARLOTTE
	.long	T_BULLS		; 3 CHICAGO
	.long	T_CAVS		; 4 CLEVELAND
	.long	T_MAVS		; 5 DALLAS
	.long	T_NUGS		; 6 DENVER
	.long	T_PISS		; 7 DETROIT
	.long	T_WARS		; 8 GOLDEN STATE
	.long	T_ROCKS		; 9 HOUSTON
	.long	T_PACER		;10 INDIANA
	.long	T_CLIPS		;11 LOS ANGELES (CLIPPERS)
	.long	T_LAKS		;12 LOS ANGELES (LAKERS)
	.long	T_HEAT		;13 MIAMI
	.long	T_BUCKS		;14 MILWAUKEE
	.long	T_TWOLV		;15 MINNESOTA
	.long	T_NETS		;16 NEW JERSEY
	.long	T_KNIKS		;17 NEW YORK
	.long	T_MAGIC		;18 ORLANDO
	.long	T_76RS		;19 PHILADELPHIA
	.long	T_SUNS		;20 PHOENIX
	.long	T_BLAZ		;21 PORTLAND
	.long	T_KINGS		;22 SACRAMENTO
	.long	T_SPURS		;23 SAN ANTONIO
	.long	T_SONICS	;24 SEATTLE
	.long	T_JAZZ		;25 UTAH
	.long	T_BULTS		;26 WASHINGTON	(150)

	.long	cities1		;1st city column (151)
	.long	cities2
	.long	cities3
	.long	cities4


city_tbl
	.def	city_tbl

	.long	C_ATL		;ATLANTA	(96)
	.long	C_BOST		;BOSTON		(103)
	.long	C_CHAR		;CHARLOTTE
	.long	C_CHIC		;CHICAGO
	.long	C_CLEV		;CLEVELAND
	.long	C_DAL		;DALLAS		(117)
	.long	C_DEN		;DENVER
	.long	C_DET		;DETROIT
	.long	C_GOLD		;GOLDEN STATE	(110)
	.long	C_HOU		;HOUSTON
	.long	C_IND		;INDIANA
	.long	C_LAClips	;LOS ANGELES (CLIPPERS)
	.long	C_LALaks	;LOS ANGELES (LAKERS)
	.long	C_MIAMI		;MIAMI
	.long	C_MILW		;MILWAUKEE
	.long	C_MINN		;MINNESOTA
	.long	C_NJ		;NEW JERSEY
	.long	C_NY		;NEW YORK
	.long	C_ORL		;ORLANDO
	.long	C_PHIL		;PHILADELPHIA
	.long	C_PHX		;PHOENIX
	.long	C_PORT		;PORTLAND
	.long	C_SAC		;SACRAMENTO
	.long	C_SAN		;SAN ANTONIO
	.long	C_SEA		;SEATTLE
	.long	C_UTAH		;UTAH		(122)
	.long	C_WASH		;WASHINGTON
	.long	C_DET		;DETROIT

fatal_tbl
	.word	1		;ATLANTA	(96)
	.word	1		;BOSTON		(103)
	.word	1		;CHARLOTTE
	.word	0		;CHICAGO
	.word	1		;CLEVELAND
	.word	1		;DALLAS		(117)
	.word	1		;DENVER
	.word	0		;DETROIT
	.word	1		;GOLDEN STATE	(110)
	.word	0		;HOUSTON
	.word	1		;INDIANA
	.word	1		;LOS ANGELES (CLIPPERS)
	.word	0		;LOS ANGELES (LAKERS)
	.word	1		;MIAMI
	.word	0		;MILWAUKEE
	.word	1		;MINNESOTA
	.word	0		;NEW JERSEY
	.word	0		;NEW YORK
	.word	0		;ORLANDO
	.word	1		;PHILADELPHIA
	.word	1		;PHOENIX
	.word	0		;PORTLAND
	.word	0		;SACRAMENTO
	.word	1		;SAN ANTONIO
	.word	0		;SEATTLE
	.word	0		;UTAH		(122)
	.word	1		;WASHINGTON

logos
	.long	T_HAWKS		; 0 ATLANTA	(124)
	.long	T_CELTS		; 1 BOSTON
	.long	T_HORS		; 2 CHARLOTTE
	.long	T_BULLS		; 3 CHICAGO
	.long	T_CAVS		; 4 CLEVELAND
	.long	T_MAVS		; 5 DALLAS
	.long	T_NUGS		; 6 DENVER
	.long	T_PISS		; 7 DETROIT
	.long	T_WARS		; 8 GOLDEN STATE
	.long	T_ROCKS		; 9 HOUSTON
	.long	T_PACER		;10 INDIANA
	.long	T_CLIPS		;11 LOS ANGELES (CLIPPERS)
	.long	T_LAKS		;12 LOS ANGELES (LAKERS)
	.long	T_HEAT		;13 MIAMI
	.long	T_BUCKS		;14 MILWAUKEE
	.long	T_TWOLV		;15 MINNESOTA
	.long	T_NETS		;16 NEW JERSEY
	.long	T_KNIKS		;17 NEW YORK
	.long	T_MAGIC		;18 ORLANDO
	.long	T_76RS		;19 PHILADELPHIA
	.long	T_SUNS		;20 PHOENIX
	.long	T_BLAZ		;21 PORTLAND
	.long	T_KINGS		;22 SACRAMENTO
	.long	T_SPURS		;23 SAN ANTONIO
	.long	T_SONICS	;24 SEATTLE
	.long	T_JAZZ		;25 UTAH
	.long	T_BULTS		;26 WASHINGTON	(150)
	.long	TSMLOGO2	;27 NBA JAM LOGO
	
******************************************************************************

name_sort
	.long	MANNING,AUGMON,WILLIS,BROWN,MCDAN,GAMBLE,JOHNSN_L,HAWKINS
	.long	MOURN,PIPPEN,ARMSTR,KUKOC,GRANT_HC,PRICE,DAUGHRTY
	.long	NANCE,JACK,MASH,MUTUMBO,LELLIS
	.long	ROGERS,THOMAS,DUMARS,ELLIOT,HUNTER,THARDAWAY
	.long	MULLIN,WEBBER,OLAJUWON,MAXWELL,HORRY,SMITH
	.long	MILLER,SEALY,SMITS,WILKINS,HARPER_R,ROBERTS
	.long	PEELER,DIVAC,CAMPBELL,WORTHY,RICE,SEIKALY,MINER
	.long	BAKER,EDWARDS,DAY,LOHAUS,LAETNER,PERSON,RIDER,COLEMAN,KANDERSON
	.long	CMORRIS,BENJAMIN,EWING,MASON,STARKS,OAKLEY,HARPER_D
	.long	AHARDAWAY,NANDERSON,SKILES,WEATH,BRAD
	.long	BARKLEY,MAJERLE,KJOHNSON,DREXLER,PORTER,CROBINSON
	.long	GRANT_HV,SIMM,HURL,RICH,TISDALE,WEBB,DROBINSON
	.long	RODMAN,DELLIS,KEMP,PAYTON,GILL,SCHREMPF,MALONE_K,STOCKTON,BENOIT
	.long	HORNACEK
	.long	GUGLI,ELLISON,CHEANEY

	.long	MALONE_K,KEMP,DROBINSON,BARKLEY,DREXLER,AHARDAWAY,EWING
	.long	KANDERSON,COLEMAN,NANDERSON,STOCKTON,KJOHNSON,GILL
	.long	RICH,BRAD,WEBB,DUMARS,STARKS,MUTUMBO,WILKINS
	.long	HARPER_R,RIDER,MILLER,JOHNSN_L,OLAJUWON,BAKER,ARMSTR,MAXWELL
	.long	MOURN,RICE,THARDAWAY,JACK,PIPPEN,MINER,THOMAS,WEBBER
	.long	MASH,WORTHY,MULLIN,MANNING

;	.long	SCORP,RAIDEN,REPT,SUBZ,HOSK
;	.long	OLIV,TURMELL,0


team_convert
	.word	_GOL,_DAL,_ATL,_BOS
	.word	_LAC,_DEN,_CHA,_MI
	.word	_LAL,_HOU,_CHI,_NJ
	.word	_PHX,_MIN,_CLE,_NY
	.word	_POR,_SAN,_DET,_ORL
	.word	_SEA,_UTA,_IND,_PHI
	.word	_SAC,_MK2,_MIL,_WAS



#*****************************************************************************
team_menus
	.long	#tm1
#tm1
	.word	1			;palette
	.word	44,32+TEAMSEL_PAGE	;x,y start
	.long	city_table		;table

#*****************************************************************************
player1_menus
	.long	#p1m1
	.long	#p1m2
	.long	#p1m3
#p1m1
	.word	0			;palette
	.word	0+16,30+NAMENT_PAGE-4	;x,y start
	.long	name_table		;table
#p1m2
	.word	0			;palette
	.word	0+9,24+NAMENT_PAGE	;x,y start
	.long	month_table
#p1m3
	.word	0			;palette
	.word	0+10,30-12+NAMENT_PAGE	;x,y start
	.long	day_table

#************
player1k_menus
	.long	#p1m1k
	.long	#p1m2k
	.long	#p1m3k
#p1m1k
	.word	0				;palette
	.word	0+16+36,30+NAMENT_PAGE-4	;x,y start
	.long	name_table2			;table
#p1m2k
	.word	0				;palette
	.word	0+9+38,24+NAMENT_PAGE		;x,y start
	.long	month_table2
#p1m3k
	.word	0				;palette
	.word	0+10+35,30-12+NAMENT_PAGE	;x,y start
	.long	day_table2

#************
player2_menus
	.long	#p2m1
	.long	#p2m2
	.long	#p2m3
#p2m1
	.word	1			;palette
	.word	100+13,30+NAMENT_PAGE-4	;x,y start
	.long	name_table		;table
#p2m2
	.word	1			;palette
	.word	100+7,24+NAMENT_PAGE	;x,y start
	.long	month_table
#p2m3
	.word	1			;palette
	.word	100+7,30-12+NAMENT_PAGE	;x,y start
	.long	day_table

*************
player3_menus
	.long	#p3m1
	.long	#p3m2
	.long	#p3m3
#p3m1
	.word	2			;palette
	.word	200+10,30+NAMENT_PAGE-4	;x,y start
	.long	name_table
#p3m2
	.word	2			;palette
	.word	200+4,24+NAMENT_PAGE	;x,y start
	.long	month_table
#p3m3
	.word	2			;palette
	.word	200+4,30-12+NAMENT_PAGE	;x,y start
	.long	day_table

*************
player2k_menus
	.long	#p2m1k
	.long	#p2m2k
	.long	#p2m3k
#p2m1k
	.word	2				;palette
	.word	200+10+32,30+NAMENT_PAGE-4	;x,y start
	.long	name_table2
#p2m2k
	.word	2				;palette
	.word	200+4+36,24+NAMENT_PAGE		;x,y start
	.long	month_table2
#p2m3k
	.word	2				;palette
	.word	200+4+34,30-12+NAMENT_PAGE	;x,y start
	.long	day_table2

*************
player4_menus
	.long	#p4m1
	.long	#p4m2
	.long	#p4m3
#p4m1
	.word	3			;palette
	.word	300+6,30+NAMENT_PAGE-4	;x,y start
	.long	name_table
#p4m2
	.word	3			;palette
	.word	300+1,24+NAMENT_PAGE	;x,y start
	.long	month_table
#p4m3
	.word	3			;palette
	.word	300+1,30-12+NAMENT_PAGE	;x,y start
	.long	day_table


name_entry_mod
	.long	teamselBMOD		;team selection map
	.word	-4,TEAMSEL_PAGE
	.long	selbackBMOD		;name entry map
	.word	0,NAMENT_PAGE
	.long	namebox2BMOD		;stats box map
	.word	9,207+YESNO_PAGE-14
	.long	yesnoBMOD		;yes/no select map
	.word	0,YESNO_PAGE
	.long	0

name_entry_kit_mod
	.long	teamselBMOD		;team selection map
	.word	-4,TEAMSEL_PAGE
	.long	selbackkBMOD		;name entry map
	.word	0,NAMENT_PAGE
	.long	nameboxkBMOD		;stats box map
	.word	9,207+YESNO_PAGE-14
	.long	yesnoBMOD		;yes/no select map
	.word	0,YESNO_PAGE
	.long	0



name_entry2_mod
	.long	teamselBMOD		;team selection map
	.word	-4,TEAMSEL_PAGE
	.long	yesnoBMOD		;yes/no select map
	.word	0,NAMENT_PAGE
	.long	0

******************************************************************************


#*****************************************************************************
* covers up vertical piece in namebox on selection screens etc...
*

 SUBR	create_bits

	move	@TWOPLAYERS,a0			;0 = NO, 1 = YES 2 players
	jrz	#not2

	PUSH	a8,a10

	movi	[98,0],a0			;x val
	movi	[197,0],a1			;y val
	movi	OSGEMD_A,a2			;* image
	movi	150,a3				;z pos
	movi	DMACAL|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	movi	#nampal,b0
	calla	BEGINOBJP2
	movi	4,a0
	move	a0,*a8(OSIZEX)
	movk	2,a0
	move	a0,*a8(OSIZEY)
	movi	0101h,a0
	move	a0,*a8(OCONST)


	movi	[292,0],a0			;x val
	movi	[197,0],a1			;y val
	movi	OSGEMD_A,a2			;* image
	movi	150,a3				;z pos
	movi	DMACAL|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	movi	#nampal,b0
	calla	BEGINOBJP2
	movi	4,a0
	move	a0,*a8(OSIZEX)
	movk	2,a0
	move	a0,*a8(OSIZEY)
	movi	0202h,a0
	move	a0,*a8(OCONST)

	PULL	a8,a10
		       

#not2
	rets


 SUBR	create_bits2

	callr	create_bits

	move	@TWOPLAYERS,a0			;0 = NO, 1 = YES 2 players
	jrz	#not2b

	PUSH	a8,a10

	movi	[99,0],a0			;x val
	movi	[235,0],a1			;y val
	movi	OSGEMD_A,a2			;* image
	movi	150,a3				;z pos
	movi	DMACAL|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	movi	#nampal,b0
	calla	BEGINOBJP2
	movi	5,a0
	move	a0,*a8(OSIZEX)
	movk	2,a0
	move	a0,*a8(OSIZEY)
	movi	0202h,a0
	move	a0,*a8(OCONST)


	movi	[293,0],a0			;x val
	movi	[235,0],a1			;y val
	movi	OSGEMD_A,a2			;* image
	movi	150,a3				;z pos
	movi	DMACAL|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	movi	#nampal,b0
	calla	BEGINOBJP2
	movi	5,a0
	move	a0,*a8(OSIZEX)
	movk	2,a0
	move	a0,*a8(OSIZEY)
	movi	0202h,a0
	move	a0,*a8(OCONST)



	movi	[98,0],a0			;x val
	movi	[243,0],a1			;y val
	movi	OSGEMD_A,a2			;* image
	movi	150,a3				;z pos
	movi	DMACAL|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	movi	#nampal,b0
	calla	BEGINOBJP2
	movi	4,a0
	move	a0,*a8(OSIZEX)
	movk	3,a0
	move	a0,*a8(OSIZEY)
	movi	0303h,a0
	move	a0,*a8(OCONST)


	movi	[293,0],a0			;x val
	movi	[243,0],a1			;y val
	movi	OSGEMD_A,a2			;* image
	movi	150,a3				;z pos
	movi	DMACAL|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	movi	#nampal,b0
	calla	BEGINOBJP2
	movi	4,a0
	move	a0,*a8(OSIZEX)
	movk	3,a0
	move	a0,*a8(OSIZEY)
	movi	0303h,a0
	move	a0,*a8(OCONST)



	PULL	a8,a10

#not2b
	rets




RGB	.macro	R,G,B
	.word	(:R:<<10) | (:G:<<5) | :B:
	.endm

#nampal
	.word	4		;4 colours

	RGB	0,0,0		;background

	RGB	2,3,12		;dark
	RGB	12,0,0		;light
	RGB	0,0,0		;black

 SUBR	start_teams

	clr	a0
	move	a0,@exit_status
	move	a0,@force_selection

;Temp init
;	movk	1,a0
;	move	a0,@team1
;	movk	2,a0
;	move	a0,@team2
;	clr	a0
;	move	a0,@tm1set
;	movk	1,a0
;	move	a0,@tm2set
;	movi	-1,a0
;	move	a0,@special_heads
;	move	a0,@special_heads+10h
;	move	a0,@special_heads+20h
;	move	a0,@special_heads+30h
;	movk	1,a0
;	move	a0,@team1_control	;player selecting team 1
;	movk	2,a0
;	move	a0,@gmqrtr
;	movk	2,a0
;	move	a0,@team2_control	;player selecting team 2
;	movk	15,a0
;	move	a0,@PSTATUS
;!

;Just in case someone bought in during game play, and teamx_control had not
;been set!

	move	@team1_control,a1
	jrnn	#ok
	move	@PSTATUS,a0
	clr	a2
	btst	0,a0
	jrnz	#set
	movk	1,a2
	btst	1,a0
	jrz	#ok
#set	move	a2,@team1_control
#ok
	move	@team2_control,a1
	jrnn	#ok2
	move	@PSTATUS,a0
	movk	2,a2
	btst	2,a0
	jrnz	#set2
	movk	3,a2
	btst	3,a0
	jrz	#ok2
#set2	move	a2,@team2_control
#ok2

	move	@team1_control,a0
	jrnn	#noscrambl
	movk	5,a0
	calla	RNDRNG0
	move	@team1,a14
	cmpi	_DAL,a14
	jrz	#bigd
	sll	4,a14
	addi	tm1set,a14
	move	a0,*a14

#bigd
	clr	a8

	.ref	cpu_subs

	CREATE0	cpu_subs

#noscrambl
	move	@team2_control,a0
	jrnn	#noscrambl2
	movk	5,a0
	calla	RNDRNG0
	move	@team2,a14

	cmpi	_DAL,a14
	jrz	#bigd1

	sll	4,a14
	addi	tm2set,a14
	move	a0,*a14

#bigd1
	movk	1,a8

	CREATE0	cpu_subs

#noscrambl2


	movk	2,a0
	calla	create_logos
	movk	2,a0
	calla	create_player_heads
	movk	1,a0
	calla	create_team_set
	CREATE0	create_team_set_flsh
	calla	update_team_set
	CREATE0	team1_cursor
	CREATE0	team2_cursor

	SLEEPK	2

	calla	update_logos
	movk	1,a0
	move	a0,@fixbug
	calla	update_player_heads

	movi	SCROLL_SPEED<<16,a10
	JSRP	scroll_page

	clr	a0
	move	a0,@page_scrolling	;scrolling
                                        
	calla	find_plates		;find bgnd plate objects (for flashing)
	calla	delete_text

	movk	1,a0
	move	a0,@in_team_select

	calla	del_offscreen_bobjs
	calla	create_player_names
	calla	update_player_names

	movi	[256,0],a0
	calla	create_credits
	calla	update_credits

	movi	DMAWNZ,a0
	movi	OBJLST,a1
	jruc	so20
so10	move	a0,*a1(OFLAGS)
so20	move	*a1,a1,L
	jrnz	so10

	movi	CYCPID,a0
	calla	KIL1C

;MJT
	calla	create_bits

	JSRP	subs_in

	.ref	setup_speech
	calla	setup_speech

	.ref	set_names
	calla	set_names

	RETP

	.end
