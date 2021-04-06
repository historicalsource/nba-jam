;-----------------------------------------------------------------------------
;
* Owner:	JOHNSON
*
; Software:	Jeff Johnson
; Initiated:	5-5-95
;
; Modified:
;
; COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
;
;.Last mod - 1/15/93 15:29
;.Last mod - 5/21/95 
;-----------------------------------------------------------------------------
	.file	"select.asm"
	.title	"name & team selection"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
;	.include	"gsp.equ"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"macros.hdr"

	.include	"credturb.glo"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"bgndtbl.glo"
;	.include	"mugshot.glo"
	.ref	RAD_MK2
	
	.include	"imgtblp.glo"
	.include	"imgpalm.asm"
	.include	"imgtblm.glo"

	.def	RODMANBP
	.def	RODMANKP
	.def	RODMANOP
	.def	RODMANPP
	.def	RODMANRP
	.def	RODMANWP
	.def	RODMANYP
	.def	RODMANGP

	.ref	censor_players_name
	.ref	player_heads,player_names			;table addr.
	.ref	our_names,our_heads
	.ref	player_attribs			;table addr.
	.ref	print_players_name
	.ref	mess_objid
	.ref	options_screen
	.ref	del_option_screen_stuff
	.ref	do_scrn_transition
	.ref	un_wipe_vertical
	.ref	wipe_stack_vert_up
	.ref	wipe_horz_stag_dwn,un_wipe_horz_stag_dwn
	.ref	wipe_horizontal,un_wipe_horizontal
	.ref	NO_CREATE_DEL_OBJS,CREATE_NO_DEL_OBJS
	.ref	transition_flag
	.ref	create_player_head_backdrops
	.ref	print_name
	.ref	delete_team_city_names
	.ref	create_name_backplate
	.ref	create_plr_mugshots_tbl

	.ref	buyin_screen
	.ref	bast8_ascii,bast8t_ascii
	.ref	kill_countdown_timer
	.ref	create_name_objs
	.ref	blink_tmslct
	.ref	del_name_backplates
	.ref	print_subsitution_title
	.ref	flash_backdrop,print_subsitution_directions
	.ref	del_winner_stay_free_msg
	.ref	team_sqaud_cnts
	.ref	create_team_squad_nbr
	.ref	update_team_squad_nbr
	.ref	update_player_head_backdrop
	.ref	cpu_subs
	.ref	setup_speech
	.ref	set_names
	.ref	print_team_stats
	.ref	del_team_stats
	.ref	plyr_plaques
	.ref	script_play1
	.ref	ask_yes_no,show_trivia_stuff
	.ref	del_yes_no_buttons
	.ref	qualify_plaque
	.ref	create_title_bar
	.ref	wipe_center_up_dwn
	.ref	tm_sel_cur1,tm_sel_cur2
	.ref	tm_sel_hd_l1,tm_sel_hd_l2
	.ref	tm_sel_hd_r1,tm_sel_hd_r2
	.ref	tm_sel_sel1,tm_sel_sel2
	.ref	tm_sel_ran1,tm_sel_ran2
	.ref	tm_sel_stats
	.ref	tuneend_snd
	.ref	hide_plyr_attribs
	.ref	sel_rndmend1,sel_rndmend2
	.ref	T_HAWKS
	.ref	BALLBAK1

	.def	plate1_objs,plate2_objs
	.def	tm1_cur_pos,tm2_cur_pos
	.def	update_statbox_images
	.def	create_menu,create_pin_nbr_objs
	.def	pin_nbr_table,name_table
	.def	save_selection
	.def	move_cursor,update_cursor
	.def	button_actions
	.def	scrnrel_off
	.def	tm1_random_cycle_cnt,tm2_random_cycle_cnt
	.def	tm1_random_team_nbr,tm2_random_team_nbr
	.def	create_plyr
	.def	p1_pin_nbr,p2_pin_nbr,p3_pin_nbr,p4_pin_nbr
	.def	create_and_watch_credits
	.def	create_credit_plate
	.def	cur_pos			;cursor pos. 0,1 or 2 on OPTIONS scrn
	.def	TM_NAMES_ON_SCRN,MIDDLE_TEAM_NAME

	.bss	p1_pin_nbr,16*4		;4 digit pin number
	.bss	p2_pin_nbr,16*4		;4 digit pin number
	.bss	p3_pin_nbr,16*4		;4 digit pin number
	.bss	p4_pin_nbr,16*4		;4 digit pin number

	.bss	create_plyr,16	    ;-1=can't create plyr, 0=could, 1=creating

	.bss	lastjoy1,16
	.bss	lastjoy2,16
	.bss	joyholdcnt1,16
	.bss	joyholdcnt2,16
	.bss	tm1_random_sel,16	;flag=1 if random selecting
	.bss	tm2_random_sel,16	;flag=1 if random selecting
	.bss	tm1_random_team_nbr,16	;team nbr. to goto if random select
	.bss	tm2_random_team_nbr,16	;team nbr. to goto if random select
	.bss	tm1_random_cycle_cnt,16	  ;moves before goto random team
	.bss	tm2_random_cycle_cnt,16	  ;moves before goto random team
	.bss	cur_pos,16		;cursor pos. 0,1 or 2 on OPTIONS scrn

	.bss	tm1_show_tm_stats,16		;0=dont show, else show stats
	.bss	tm2_show_tm_stats,16		;0=dont show, else show stats

	.def	delete_text
	.def	obj_on,obj_off

	.def	_TOR
	.def	_VAN
	.def	_DAL
	.def	_MIN
	.def	_MI 
	.def	_WAS
	.def	_PHI
	.def	_SAC
	.def	_MIL
	.def	_DEN
	.def	_GOL
	.def	_SAN
	.def	_SEA
	.def	_ATL
	.def	_ORL
	.def	_LAC
	.def	_NJ 
	.def	_CHA
	.def	_BOS
	.def	_CLE
	.def	_DET
	.def	_HOU
	.def	_IND
	.def	_LAL
	.def	_UTA
	.def	_NY 
	.def	_POR
	.def	_PHX
	.def	_CHI

	.ref	design_player
	.ref	logos
	.ref	city_table_start
	.ref	city_table_end
	.ref	TUBE_G_P,TUBE_O_P,TUBE_Y_P,TUBE_R_P

	.def	get_teams_pop
	.def	game_purchased
	.def	initials_entry

	.ref	create_team_sel_header
	.ref	OBJOFF,OBJON
	.ref	challenger2
	.ref	challenger
	.ref	attrib_off
	.ref	attrib_on
	.ref	update_attribs
	.ref	check_suckup
	.ref	ingame_mess
	.ref	TWOPLAYERS			;0 = NO, 1 = YES 2 players
	.ref	get_all_sticks_cur
	.ref	get_all_sticks_down
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
	.ref	check_special_initials

	.ref	call_team_name
	.ref	CR_CONTP
	.ref	qtr_purchased
	.ref	gmqrtr
	.ref	fullgame_purchased

	.ref	message_buffer
	.ref	print_string_C
	.ref	mess_cursx,copy_string
	.ref	mess_line_spacing
	.ref	setup_message,print_string_C2
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
	.ref	scores

	.ref	DELBOBJ
	.ref	cursor_snd1,cursor_snd2
	.ref	cursor_snd3,cursor_snd4
	.ref	select_snd1,select_snd2
	.ref	select_snd3,select_snd4
	.ref	welcome_sc,adv_stats
	.ref	print_trivia_info
;;	.ref	winner_stays_msg
	.ref	show_create_plyr_info
	.ref	creditscreen

;
; Sounds
;

cursor_sounds
	.long	cursor_snd1,cursor_snd2
	.long	cursor_snd3,cursor_snd4

select_sounds
	.long	select_snd1,select_snd2
	.long	select_snd3,select_snd4


;symbols defined in this file

	.ref	name_sort

;symbols defined externally

	.global	player1_data,player2_data,player3_data,player4_data

	.ref	pup_strongmen
	.ref	show_hiscore
	.ref	show_player_records
	.ref	GET_AUD,AUD1
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
	.ref	create_team_city_names

	.def	inmatchup
	.bss	inmatchup,16
	BSSX	kp_ram,		10*32
;ram
	BSSX	credit1_obj,	32	;10's object
	BSSX	credit2_obj,	32	;1's object
	BSSX	credit3_obj,	32	;CREDIT or FREE PLAY object
	BSSX	exit_status,	16
				                                                              
	.bss	credtime1_obj,	32*1	;
	.bss	credtime2_obj,	32*1	;
	.bss	credtime3_obj,	32*1	;
	.bss	credtime4_obj,	32*1	;

	BSSX	name1_obj,	32
	BSSX	name2_obj,	32
	BSSX	name3_obj,	32
	BSSX	name4_obj,	32

	BSSX	attrib1_obj,	32*9	;name...then stats (ie. speed..)
	BSSX	attrib2_obj,	32*9
	BSSX	attrib3_obj,	32*9
	BSSX	attrib4_obj,	32*9


	BSSX	head1_obj,	32
	BSSX	head2_obj,	32
	BSSX	head3_obj,	32
	BSSX	head4_obj,	32
	BSSX	head5_obj,	32
	BSSX	head6_obj,	32

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

;;	.bss	enter_initials,	16
	BSSX	can_enter_inits,16
	.bss	game_purchased,	16	;full game purchase
;	BSSX	page_scrolling,	16	;0=no, 1=yes

	.bss	plate1_objs,32		;plate behind team1 heads
	.bss	plate2_objs,32		;plate behind team2 heads

	BSSX	force_selection,16
	BSSX	in_team_select,16
	BSSX	in_team_subs,16

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

	.bss	tm1_cur_pos,16
	.bss	tm2_cur_pos,16

	BSSX	tm1set,(NUM_TEAMS+1)*16      ;array holds head combo. 4 team1
	BSSX	tm2set,(NUM_TEAMS+1)*16      ;array holds head combo. 4 team2

	.bss	teams_pop,	NUM_TEAMS*32
	.bss	sorted_teams,	NUM_TEAMS*16

;	BSSX	fatality,16		;Fatality 0,1,2, or 3 for both teams
	BSSX	winningteam,16

	.bss	p1_hide_atts,16
	.bss	p2_hide_atts,16
	.bss	p3_hide_atts,16
	.bss	p4_hide_atts,16

	.bss	fixbug,16

	.text

NORM_LINEUP_COMBOS	equ	5		;0-5
EXPND_LINEUP_COMBOS	equ	25		;0-25

SCROLL_SPEED	equ	8

XTRA_CRTIME	equ	>7fff		;20*60
MAX_CRTIME	equ	>7fff		;30*60

PSEL_START_DELAY	equ	22	;# frames before repeating
PSEL_REPEAT_DELAY	equ	15 ;10	;# frames delay til next repeat

MENU_LEVELS	equ	2		;for enter initials


;equates for team select
TM_NAMES_ON_SCRN	equ	7
MIDDLE_TEAM_NAME	equ	4

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
_TOR	equ 25	;toronto
_UTA	equ 26
_VAN	equ 27	;vancouver
_WAS	equ 28

_MK2	equ 27		;Special defeated all 27 teams - MK2



;Destination Y coor. for 'TOP TEN PLAYER' plaques..etc
	.asg	183,PLAQUE_Y

#*****************************************************************************
;                     New team selection screen
;-----------------------------------------------------------------------------
 SUBR	new_team_select_screen


;wipe obj. over screen
	movi	wipe_horz_stag_dwn,a0,L
	movi	CREATE_NO_DEL_OBJS,a14		;dont delete objs. when done
	JSRP	do_scrn_transition

	SLEEPK	1

	calla	del_winner_stay_free_msg
	calla	KILBGND			;Kill all old background objs
	calla	pal_clean

	calla	del_option_screen_stuff

	movi	team_select_mod_kit,a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrnz	ntss_1
	movi	team_select_mod,a0
ntss_1	move	a0,@BAKMODS,L
	calla	BGND_UD1

	clr	a0
	.ref	rodman_colors
	move	a0,@rodman_colors,L
	move	a0,@exit_status
	move	a0,@force_selection
	movi	-1,a0
	move	a0,@p1_hide_atts
	move	a0,@p2_hide_atts
	move	a0,@p3_hide_atts
	move	a0,@p4_hide_atts


	clr	a10
	CREATE0	challenger2
	movk	1,a10
	CREATE0	challenger2

	calla	create_team_sel_header
	clr	a0
	calla	create_player_head_backdrops

	clr	a0			;atlanta first (init. hi-lighted name)
	calla	create_logos
	clr	a0
	calla	create_player_heads
	calla	create_player_names

	callr	setup_random_team_select_ram

	CREATE	TEAM1_SEL_PID,team1_team_select
	CREATE	TEAM2_SEL_PID,team2_team_select

	movk	1,a0
	move	a0,@in_team_select
	calla	delete_text
	calla	del_offscreen_bobjs

	CREATE0	blink_tmslct

	SLEEPK	3

	calla	update_logos
	calla	update_player_heads
	calla	update_player_names

;wipe objs off screen -- reveal new screen
	movi	un_wipe_horz_stag_dwn,a0,L
	movi	NO_CREATE_DEL_OBJS,a14
	JSRP	do_scrn_transition
	SLEEPK	1

	.ref	best_player_plaques
	CREATE0	best_player_plaques
		
 SUBRP	subs_in

;I took this out, cause we no longer have EXPANED rosters
;
;	move	@team1_control,a0	;player selecting team 1
;	jrn	#not_bigrost
;	sll	5,a0
;	addi	defeated,a0
;	move	*a0,a0,L
;	move	*a0,a0,L	
;	cmpi	ALL_TMS_DEFEATD,a0
;	jrnz	#not_bigrost
;	
;	move	@team1_control,a4	;player selecting team 1
;	movi	rosterblu,a9
;	sll	4,a4			;x 16 bits
;	addi	plaque_xs,a4
;	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
;	jrz	#not_2p
;	addi	4*16,a4
;#not_2p
;	move	*a4,a10
;	sll	16,a10	
;	clr	a0
;	move	a0,@HALT
;	CREATE0	fullgame_purchased
;
;#not_bigrost
;
;	move	@team2_control,a0	;player selecting team 1
;	jrn	#not_bigrost2
;	sll	5,a0
;	addi	defeated,a0
;	move	*a0,a0,L
;	move	*a0,a0,L	
;	cmpi	ALL_TMS_DEFEATD,a0
;	jrnz	#not_bigrost2
;	
;	move	@team2_control,a4	;player selecting team 1
;	movi	rosterred,a9
;	sll	4,a4			;x 16 bits
;	addi	plaque_xs,a4
;	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
;	jrz	#not_2p2
;	addi	4*16,a4
;#not_2p2
;	move	*a4,a10
;	sll	16,a10	
;	clr	a0
;	move	a0,@HALT
;	CREATE0	fullgame_purchased
;#not_bigrost2


#wait_loop0
	movi	28*TSEC,a10
	CREATE	CNTDWN_PID,timeout

#wait_loop
	SLEEPK	1
	calla	update_logos
	calla	update_player_names
	calla	update_player_heads

	move	@exit_status,a0
	jrnz	#wait_loop

	calla	kill_countdown_timer
;	movi	CNTDWN_PID,a0
;	calla	KIL1C
;	calla	delete_text

	CREATE0	suckup_credits

#wait_loop2
	SLEEPK	1
	calla	update_logos
	calla	update_player_names
	calla	update_player_heads
	move	@exit_status,a0
	jrnz	#wait_loop0
	calla	check_suckup		;wait for all credits
	jrz	#wait_loop2		;to be sucked up
;	movi	TSEC+30,a10
	movi	40,a10
#wait_loop3
	SLEEPK	1
	PUSH	a10
	calla	update_logos
	calla	update_player_names
	calla	update_player_heads
	PULL	a10
	dsj	a10,#wait_loop3
	RETP


	.asg	32,TEAM_NBR
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	set_team1_team_nbr

	move	@tm1_cur_pos,a14
	addi	MIDDLE_TEAM_NAME-1,a14		;wasn't zero relative
	move	a14,a0
	sll	4,a14
	sll	5,a0
	add	a0,a14
	addi	city_table_start,a14
	move	*a14(TEAM_NBR),a14
	move	a14,@team1
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	set_team2_team_nbr

	move	@tm2_cur_pos,a14
	addi	MIDDLE_TEAM_NAME-1,a14		;wasn't zero relative
	move	a14,a0
	sll	4,a14
	sll	5,a0
	add	a0,a14
	addi	city_table_start,a14
	move	*a14(TEAM_NBR),a14
	move	a14,@team2
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_team2_city_names

	move	@tm2_cur_pos,a14
	movi	[TM2_X+7,0],a0,L
	movi	TM2_NAME_OBJS,a5
	calla	create_team_city_names
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_team1_city_names

	move	@tm1_cur_pos,a14
	movi	[TM1_X-84,0],a0,L
	movi	TM1_NAME_OBJS,a5
	calla	create_team_city_names
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	setup_random_team_select_ram

	clr	a0
	move	a0,@tm1_random_sel			;not in random select mode
	move	a0,@tm2_random_sel			;not in random select mode
	movi	NUM_TEAMS-1,a0			;0-29
	calla	RNDRNG0				;random team
	move	a0,@tm1_random_team_nbr
	movi	NUM_TEAMS-1,a0			;0-29
	calla	RNDRNG0				;random team
	move	a0,@tm2_random_team_nbr
	movk	15,a0
	move	a0,@tm1_random_cycle_cnt
	move	a0,@tm2_random_cycle_cnt
	rets

;-----------------------------------------------------------------------------
;  This (PROCESS) watches joystick (UP and DOWN) and plots 
;     the city names based on joystick movement
;-----------------------------------------------------------------------------
 SUBRP	team1_team_select

#wait_for_players
	SLEEPK	2
	move	@PSTATUS,a0
	andi	011b,a0				;did player 1 or 2 buyin ?
	jrz	#wait_for_players		;br=nope...not yet
;
; player 1 and/or 2 active
;
	move	@exit_status,a0
	ori	1<<0,a0
	move	a0,@exit_status			;exit

	clr	a0
	calla	update_player_head_backdrop
	clr	a0
	calla	create_team_squad_nbr
	move	a8,@teamset1_obj,L

	CREATE0	team1_swap_heads		;watch buttons

;if were in halftime, dont allow player to change CITY, just swap heads
	move	@in_team_subs,a0
	jrnz	#rj1_die			;br=in halftime substitution

	CREATE0	team1_random_select
	clr	a9
	calla	create_name_backplate
	clr	a0
	move	a0,@tm1_cur_pos
	addi	MIDDLE_TEAM_NAME-1,a0
	move	a0,@team1
	calla	create_team1_city_names

	clr	a0
	move	a0,@lastjoy1			;no joystick data..yet
	move	a0,@joyholdcnt1
#rj_1
	SLEEPK	2
	move	@in_team_subs,a0
	jrnz	#rj1_die			;br=in halftime substitutions

	callr	update_tm1_rnd_select_ram
	move	@tm1_random_sel,a0
	jrn	#rj_1				;br=done picking random team
	jrgt	#ju1				;br=still picking random team

	move	@team1_control,a0		;player selecting team 1
	calla	get_stick_val_cur		;ret. a0=joy switch value

	move	@lastjoy1,a1			;get last JOYSTICK position
	cmp	a0,a1
	jreq	#rj_1a
	move	a0,@lastjoy1			;save new position
	movi	DELAY_B4_SCROLL+6,a14		;held for 40 ticks before fast
	move	a14,@joyholdcnt1
	jruc	#rj_1b
#rj_1a
	move	@joyholdcnt1,a14
	jrz	#rj_1b				;br=scroll fast
	dec	a14
	move	a14,@joyholdcnt1
	move	a14,a14
	jrnz	#rj_1				;br=hasn't held long enough
#rj_1b		
	cmpi	JOY_DOWN,a0
	jreq	#jd1
	cmpi	JOY_DOWN_RIGHT,a0
	jreq	#jd1
	cmpi	JOY_DOWN_LEFT,a0
	jreq	#jd1
	cmpi	JOY_UP,a0
	jreq	#ju1
	cmpi	JOY_UP_RIGHT,a0
	jreq	#ju1
	cmpi	JOY_UP_LEFT,a0
	jrne	#rj_1
;upward
#ju1
	SOUND1	tm_sel_cur1

	move	@tm1_cur_pos,a0
	dec	a0
	jrnn	#jup1a
	movi	NUM_TEAMS-1,a0
#jup1a	move	a0,@tm1_cur_pos

	callr	set_team1_team_nbr
	movi	TM1_NAME_OBJS,a0
	calla	delete_team_city_names
	calla	create_team1_city_names

	move	@team1,a0
	sll	4,a0				;offset into TEAM LINEUP array
	move	a0,a1
	addi	tm1set,a0			;point to team
	move	*a0,a14				;get current squad nbr
	move	@teamset1_obj,a8,L
	calla	update_team_squad_nbr

	move	@tm1_show_tm_stats,a14
	jreq	#rj_1				;br=stats aren't activated
	move	@team1,a0
	clr	a1
	calla	print_team_stats
	jruc	#rj_1

;downward
#jd1
	SOUND1	tm_sel_cur1

	move	@tm1_cur_pos,a0
	inc	a0
	cmpi	NUM_TEAMS,a0
	jrlo	#jd1a
	clr	a0
#jd1a	move	a0,@tm1_cur_pos

	callr	set_team1_team_nbr
	movi	TM1_NAME_OBJS,a0
	calla	delete_team_city_names
	callr	create_team1_city_names

	move	@team1,a0
	sll	4,a0				;offset into TEAM LINEUP array
	move	a0,a1
	addi	tm1set,a0			;point to team
	move	*a0,a14				;get current squad nbr
	move	@teamset1_obj,a8,L
	calla	update_team_squad_nbr

	move	@tm1_show_tm_stats,a14
	jreq	#rj_1				;br=stats aren't activated
	move	@team1,a0
	clr	a1
	calla	print_team_stats
	SOUND1	tm_sel_cur1
	jruc	#rj_1
#rj1_die
	DIE

;-----------------------------------------------------------------------------
;  	This (PROCESS) watches for UP-TURBO for random team select
;-----------------------------------------------------------------------------
 SUBRP	team1_random_select

t1rs_1
	SLEEPK	2
	move	@exit_status,a14
	btst	0,a14
	jrz	t1rs_2

	move	@team1_control,a0		;player selecting team 1
	calla	get_stick_val_cur		;ret. a0=joy switch value
	cmpi	JOY_UP,a0
	jrne	t1rs_1
	move	@team1_control,a0		;player selecting team 1
	calla	get_but_val_cur
	cmpi	TURBO_BUTTON,a0
	jrne	t1rs_1

;random team select, activated
	movk	1,a0
	move	a0,@tm1_random_sel		;in random select mode
	SOUND1	tm_sel_ran1
t1rs_2
	DIE

;-----------------------------------------------------------------------------
;	This routine handles the updating of the teams' random team select
; ram and the selecting of the random team
;
;  INPUT: nothing
; OUTPUT: nothing
;-----------------------------------------------------------------------------
 SUBR	update_tm1_rnd_select_ram

	move	@tm1_random_sel,a0		;in random select mode ?
	jrle	#ut1_1				;br=nope
	move	@tm1_random_cycle_cnt,a0
	dec	a0
	move	a0,@tm1_random_cycle_cnt
	move	a0,a0
	jrge	#ut1_1				;br=not done cycling yet
;
; Done cycling...now move cursor until get to random team
;
#ut1_0
	move	@tm1_random_team_nbr,a0
	move	@team1,a1
	cmp	a0,a1		       		;at random team ?
	jrne	#ut1_1				;br=nope
	movi	-1,a0
	move	a0,@tm1_random_sel     ;can't change team but can change heads
	SOUND1	sel_rndmend1
#ut1_1	rets

;-----------------------------------------------------------------------------
;    This process watches TEAM1 buttons...during the select team screen
;-----------------------------------------------------------------------------
 SUBRP	team1_swap_heads

;
; Watch for button presses and JOYSTICK
;
#t1sh
	SLEEPK	1
	move	@exit_status,a14
	btst	0,a14
	jrz	#selct1

	move	@force_selection,a0
	jrnz	#selct1
	move	@tm1_random_sel,a0		;in random select mode ?
	cmpi	1,a0		       ;anything but 1, says allow head change
	jreq	#t1sh				;br=yep...wait

	move	@team1_control,a0		;player selecting team 1
	calla	get_but_val_cur
	cmpi	PASS_BUTTON,a0
	jrne	#t1sh1

	move	@in_team_subs,a14
	jrnz	#t1sh3				;br=dont allow during team subs
	move	@tm1_show_tm_stats,a14
	jrne	#t1sh2				;br=team stats visible

	movk	1,a0
	move	a0,@tm1_show_tm_stats		;turn on team stats
	move	@team1,a0
	clr	a1
	calla	print_team_stats
	SOUND1	tm_sel_stats
	jruc	#t1sh3
#t1sh1
;	move	@tm1_show_tm_stats,a14
;	jrz	#t1sh2
	clr	a14
	move	a14,@tm1_show_tm_stats		;turn off team stats
	movi	TM1_STAT_OBJS,a5 		;object ID
	calla	del_team_stats
	
#t1sh2
	move	@team1_control,a0		;player selecting team 1
	calla	get_but_val_down
	cmpi	TURBO_BUTTON,a0
	jreq	#turbo1
	cmpi	SHOOT_BUTTON,a0
	jreq	#selct1

;read teammates turbo button
	clr	a0				;plyr 1 is teammate
	move	@team1_control,a14		;player selecting team 1
	jrnz	#t1sh2a
	movk	1,a0				;plyr 2 is teammate
#t1sh2a
	move	@PSTATUS,a14
	btst	a0,a14
	jrz	#t1sh3
	calla	get_but_val_down
	cmpi	TURBO_BUTTON,a0
	jreq	#turbo1

#t1sh3
	move	@team1_control,a0		;player selecting team 1
	calla	get_stick_val_down		;ret. a0=joy switch value
	cmpi	JOY_LEFT,a0
	jreq	#pass1
	cmpi	JOY_RIGHT,a0
	jrne	#t1sh
;
; Goto next lineup
;
#turbo1
	SOUND1	tm_sel_hd_r1

	move	@team1,a0
	sll	4,a0				;offset into TEAM LINEUP array
	move	a0,a1		
	addi	tm1set,a0			;point to team
	move	*a0,a14				;get current squad nbr
	inc	a14				;next squad

	addi	team_sqaud_cnts,a1
	move	*a1,a1				;get MAX squads count
	cmp	a1,a14				;valid ?
	jrlo	#valok				;br=yes
	clr	a14
#valok
	move	a14,*a0				;save new sqaud count (nbr.)
	move	@teamset1_obj,a8,L
	calla	update_team_squad_nbr
	jruc	#t1sh
;
; Goto previous lineup
;
#pass1
	SOUND1	tm_sel_hd_l1

	move	@team1,a0
	sll	4,a0			;offset into TEAM LINEUP array
	move	a0,a1		
	addi	tm1set,a0		;point to team
	move	*a0,a14			;get lineup number for team

	addi	team_sqaud_cnts,a1
	move	*a1,a1			;get MAX squads count

	dec	a14			;prev. player head combination
	jrnn	#valok1a		;br=not negative
	dec	a1			;make zero relative
	move	a1,a14
;	movi	NORM_LINEUP_COMBOS,a14	;reset value to last combination
#valok1a
	move	a14,*a0			;save new lineup nbr.
	move	@teamset1_obj,a8,L
	calla	update_team_squad_nbr
	jruc	#t1sh
;
; Select this lineup!!
;
#selct1
	SOUND1	tm_sel_sel1

	movi	TEAM1_SEL_PID,a0
	calla	KIL1C			;dont allow plyr to change city name

	clr	a10
	move	@plate1_objs,a11,L		;plate behind heads
	CREATE0	flash_backdrop

	move	@gmqrtr,a0
	jrnz	#skp
	move	@team1,a0
	addi	AUD_ATL,a0
	calla	AUD1			;inc audit
	move	@team1,a8
	CREATE0	call_team_name
#skp
	SOUND1	select_snd1
	move	@exit_status,a0
	andni	1<<0,a0
	move	a0,@exit_status		;exit
#wait1
	SLEEPK	1
	move	@PSTATUS,a0
	andi	011b,a0
	jrnz	#wait1
	DIE



;-----------------------------------------------------------------------------
;  This (PROCESS) watches joystick (UP,DOWN, LEFT or RIGHT) and plots 
;     the city names, logos and heads based on joystick movement and table
;-----------------------------------------------------------------------------
 SUBRP	team2_team_select

#wait_for_players2
	SLEEPK	2
	move	@PSTATUS,a0
	andi	01100b,a0			;did player 3 or 4 buyin ?
	jrz	#wait_for_players2		;br=nope...not yet
;
; player 3 and/or 4 active
;
	move	@exit_status,a0
	ori	1<<1,a0
	move	a0,@exit_status			;exit

	movk	1,a0
	calla	update_player_head_backdrop
	movk	1,a0
	calla	create_team_squad_nbr
	move	a8,@teamset2_obj,L

	CREATE0	team2_swap_heads		;watch buttons

;if were in halftime, dont allow player to change CITY, just swap heads
	move	@in_team_subs,a0
	jrnz	#rj2_die			;br=in halftime substitution

	CREATE0	team2_random_select
	movk	1,a9
	calla	create_name_backplate
	clr	a0
	move	a0,@tm2_cur_pos
	addi	MIDDLE_TEAM_NAME-1,a0		;wasn't zero relative
	move	a0,@team2
	calla	create_team2_city_names

	clr	a0
	move	a0,@lastjoy2			;no joystick data..yet
	move	a0,@joyholdcnt2
#rj_2
	SLEEPK	2
	move	@in_team_subs,a0
	jrnz	#rj2_die			;br=in halftime substitutions

	callr	update_tm2_rnd_select_ram
	move	@tm2_random_sel,a0		;get status
	jrn	#rj_2				;br=still picking random team
	jrgt	#ju2				;br=done picking random team

	move	@team2_control,a0		;player selecting team 1
	calla	get_stick_val_cur		;ret. a0=joy switch value

	move	@lastjoy2,a1			;get last JOYSTICK position
	cmp	a0,a1
	jreq	#rj_2a
	move	a0,@lastjoy2			;save new position
	movi	DELAY_B4_SCROLL+6,a14		;held for 40 ticks before fast
	move	a14,@joyholdcnt2
	jruc	#rj_2b
#rj_2a
	move	@joyholdcnt2,a14
	jrz	#rj_2b				;br=scroll fast
	dec	a14
	move	a14,@joyholdcnt2
	move	a14,a14
	jrnz	#rj_2				;br=hasn't held long enough
#rj_2b		
	cmpi	JOY_DOWN,a0
	jreq	#jd2
	cmpi	JOY_DOWN_RIGHT,a0
	jreq	#jd2
	cmpi	JOY_DOWN_LEFT,a0
	jreq	#jd2
	cmpi	JOY_UP,a0
	jreq	#ju2
	cmpi	JOY_UP_RIGHT,a0
	jreq	#ju2
	cmpi	JOY_UP_LEFT,a0
	jrne	#rj_2
;upward
#ju2
	SOUND1	tm_sel_cur2

	move	@tm2_cur_pos,a0
	dec	a0
	jrnn	#jup2a
	movi	NUM_TEAMS-1,a0
#jup2a	move	a0,@tm2_cur_pos

	callr	set_team2_team_nbr
	movi	TM2_NAME_OBJS,a0
	calla	delete_team_city_names
	calla	create_team2_city_names

	move	@team2,a0
	sll	4,a0				;offset into TEAM LINEUP array
	move	a0,a1
	addi	tm2set,a0			;point to team
	move	*a0,a14				;get current squad nbr
	move	@teamset2_obj,a8,L
	calla	update_team_squad_nbr

	move	@tm2_show_tm_stats,a14
	jreq	#rj_2				;br=stats aren't activated
	move	@team2,a0
	movk	1,a1
	calla	print_team_stats
	jruc	#rj_2

;downward
#jdr2
#jd2
	SOUND1	tm_sel_cur2

	move	@tm2_cur_pos,a0
	inc	a0
	cmpi	NUM_TEAMS,a0
	jrlo	#jd2a
	clr	a0
#jd2a	move	a0,@tm2_cur_pos

	callr	set_team2_team_nbr
	movi	TM2_NAME_OBJS,a0
	calla	delete_team_city_names
	calla	create_team2_city_names

	move	@team2,a0
	sll	4,a0				;offset into TEAM LINEUP array
	move	a0,a1
	addi	tm2set,a0			;point to team
	move	*a0,a14				;get current squad nbr
	move	@teamset2_obj,a8,L
	calla	update_team_squad_nbr

	move	@tm2_show_tm_stats,a14
	jreq	#rj_2				;br=stats aren't activated
	move	@team2,a0
	movk	1,a1
	calla	print_team_stats
	jruc	#rj_2
#rj2_die
	DIE

;-----------------------------------------------------------------------------
;  	This (PROCESS) watches for UP-TURBO for random team select
;-----------------------------------------------------------------------------
 SUBRP	team2_random_select

t2rs_1
	SLEEPK	2
	move	@exit_status,a14
	btst	1,a14
	jrz	t2rs_2

	move	@team2_control,a0		;player selecting team 1
	calla	get_stick_val_cur		;ret. a0=joy switch value
	cmpi	JOY_UP,a0
	jrne	t2rs_1
	move	@team2_control,a0		;player selecting team 1
	calla	get_but_val_cur
	cmpi	TURBO_BUTTON,a0
	jrne	t2rs_1

;random team select, activated
	movk	1,a0
	move	a0,@tm2_random_sel		;in random select mode
	SOUND1	tm_sel_ran2
t2rs_2
	DIE

;-----------------------------------------------------------------------------
;	This routine handles the updating of the teams' random team select
; ram and the selecting of the random team
;
;  INPUT: nothing
; OUTPUT: nothing
;-----------------------------------------------------------------------------
 SUBR	update_tm2_rnd_select_ram

	move	@tm2_random_sel,a0		;in random select mode or done?
	jrle	#ut2_1				;br=nope
	move	@tm2_random_cycle_cnt,a0
	dec	a0
	move	a0,@tm2_random_cycle_cnt
	move	a0,a0
	jrge	#ut2_1				;br=not done cycling yet
;
; Done cycling...now move cursor until get to random team
;
#ut2_0
	move	@tm2_random_team_nbr,a0
	move	@team2,a1
	cmp	a0,a1		       		;at random team ?
	jrne	#ut2_1				;br=nope
	movi	-1,a0
	move	a0,@tm2_random_sel     ;can't change team but can change heads
	SOUND1	sel_rndmend2
#ut2_1	rets

;-----------------------------------------------------------------------------
;  This process watches TEAM2 buttons...during the select team screen
;-----------------------------------------------------------------------------
 SUBRP	team2_swap_heads

;
; Watch for button presses and JOYSTICK
;
#t2sh
	SLEEPK	1
	move	@exit_status,a14
	btst	1,a14
	jrz	#selct2

	move	@force_selection,a0
	jrnz	#selct2
	move	@tm2_random_sel,a0		;in random select mode ?
	cmpi	1,a0		       ;anything but 1, says allow head change
	jreq	#t2sh				;br=yep...wait

	move	@team2_control,a0		;player selecting team 1
	calla	get_but_val_cur
	cmpi	PASS_BUTTON,a0
	jrne	#t2sh1

	move	@in_team_subs,a14
	jrnz	#t2sh3				;br=dont allow during team subs
	move	@tm2_show_tm_stats,a14
	jrne	#t2sh2				;br=team stats visible

	movk	1,a0
	move	a0,@tm2_show_tm_stats		;turn on team stats
	move	@team2,a0
	movk	1,a1
	calla	print_team_stats
	SOUND1	tm_sel_stats
	jruc	#t2sh3
#t2sh1
;	move	@tm2_show_tm_stats,a14
;	jrz	#t2sh2
	clr	a14
	move	a14,@tm2_show_tm_stats		;turn off team stats
	movi	TM2_STAT_OBJS,a5 		;object ID
	calla	del_team_stats

#t2sh2
	move	@team2_control,a0		;player selecting team 1
	calla	get_but_val_down
	cmpi	TURBO_BUTTON,a0
	jreq	#turbo2
	cmpi	SHOOT_BUTTON,a0
	jreq	#selct2

;read teammates turbo button
	movk	2,a0				;plyr 3 is teammate
	move	@team2_control,a14		;player selecting team 2
	cmp	a0,a14				;player 3 ?
	jrne	#t2sh2a				;br=yes
	movk	3,a0				;plyr 4 is teammate
#t2sh2a
	move	@PSTATUS,a14
	btst	a0,a14
	jrz	#t2sh3
	calla	get_but_val_down
	cmpi	TURBO_BUTTON,a0
	jreq	#turbo2

#t2sh3
	move	@team2_control,a0		;player selecting team 1
	calla	get_stick_val_down		;ret. a0=joy switch value
	cmpi	JOY_LEFT,a0
	jreq	#pass2
	cmpi	JOY_RIGHT,a0
	jrne	#t2sh

;
; Goto next lineup
;
#turbo2
	SOUND1	tm_sel_hd_r2

	move	@team2,a0
	sll	4,a0				;offset into TEAM LINEUP array
	move	a0,a1
	addi	tm2set,a0			;point to team
	move	*a0,a14				;get current squad nbr
	inc	a14				;next squad

	addi	team_sqaud_cnts,a1
	move	*a1,a1				;get MAX squads count
	cmp	a1,a14				;valid ?
	jrlo	#valok2				;br=yes
	clr	a14
#valok2
	move	a14,*a0				;save new squad nbr
	move	@teamset2_obj,a8,L
	calla	update_team_squad_nbr
	jruc	#t2sh
;
; Goto previous lineup
;
#pass2 
	SOUND1	tm_sel_hd_l2

	move	@team2,a0
	sll	4,a0			;offset into TEAM LINEUP array
	move	a0,a1		
	addi	tm2set,a0		;point to team
	move	*a0,a14			;get lineup number for team

	addi	team_sqaud_cnts,a1
	move	*a1,a1			;get MAX squads count

	dec	a14			;prev. player head combination
	jrnn	#valok2a		;br=not negative
	dec	a1			;make zero relative
	move	a1,a14
#valok2a
	move	a14,*a0			;save new lineup nbr.
	move	@teamset2_obj,a8,L
	calla	update_team_squad_nbr
	jruc	#t2sh
;
; Select this lineup!!
;
#selct2
	SOUND1	tm_sel_sel2

	movi	TEAM2_SEL_PID,a0
	calla	KIL1C				;dont allow plyr to change city name

	movk	1,a10
	move	@plate2_objs,a11,L		;plate behind heads
	CREATE0	flash_backdrop

	move	@gmqrtr,a0
	jrnz	#skp2
	move	@team2,a0
	addi	AUD_ATL,a0
	calla	AUD1			;inc audit
	move	@team2,a8
	CREATE0	call_team_name
#skp2
	SOUND1	select_snd1
	move	@exit_status,a0
	andni	1<<1,a0
	move	a0,@exit_status		;exit
#wait2
	SLEEPK	1
	move	@PSTATUS,a0
	andi	01100b,a0
	jrnz	#wait2
	DIE


#******************************************************************************
******************************************************************************
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

;;;;	JSRP	show_player_records

	clr	a0
	move	a0,@HALT
	move	a0,@in_team_select
	move	a0,@toggle1_time
	move	a0,@toggle2_time
	move	a0,@pup_strongmen

	movi	NUM_TEAMS,a1
;;	movk	27,a1
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
	move	a0,@team1_switch
	move	a0,@team2_switch

;;;;	SOUND1	tune1_snd

	movi	MAX_CRTIME,a0
	move	a0,@cntrs_delay

	movi	-1,a0			;init all 4 players data to -1
	movi	player1_data,a1
	movi	4*PR_SIZE/16,a2		;4 players @ PR_SIZE words each
#init_loop
	move	a0,*a1+
	dsj	a2,#init_loop

	clr	a0
	movi	player1_data+PR_NAME1,a1
	movi	NAME_LETTERS,a2
#p1_il	move	a0,*a1+
	dsj	a2,#p1_il

	movi	player2_data+PR_NAME1,a1
	movi	NAME_LETTERS,a2
#p2_il	move	a0,*a1+
	dsj	a2,#p2_il

	movi	player3_data+PR_NAME1,a1
	movi	NAME_LETTERS,a2
#p3_il	move	a0,*a1+
	dsj	a2,#p3_il

	movi	player4_data+PR_NAME1,a1
	movi	NAME_LETTERS,a2
#p4_il	move	a0,*a1+
	dsj	a2,#p4_il

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

;	movi	4<<10+4<<5+7,a0
	clr	a0
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
	move	a0,@WORLDTLY,L

	SLEEPK	2


;;FIXX!!! begin
;	.ref	TRIVIA_TEST
;	.ref	tune_cap_snd
;	.ref	trivia_game
;	.ref	game_over
;
;	move	@TRIVIA_TEST,a0
;	jrz	#notriva
;
;	movk	1,a0
;	move	a0,@DISPLAYON
;	calla	display_unblank
;
;	movi	player1_data,a1
;	movk	13,a0			;'MIDWAY'
;	move	a0,*a1(PR_NAME1)
;	movk	9,a0
;	move	a0,*a1(PR_NAME2)
;	movk	4,a0
;	move	a0,*a1(PR_NAME3)
;	movk	23,a0
;	move	a0,*a1(PR_NAME4)
;	movk	1,a0
;	move	a0,*a1(PR_NAME5)
;	movk	25,a0
;	move	a0,*a1(PR_NAME6)
;	movi	99,a14
;	move	a14,*a1(PR_TRIVIA_PTS)
;
;	movi	player2_data,a1
;	movk	20,a0
;	move	a0,*a1(PR_NAME1)
;	movk	21,a0
;	move	a0,*a1(PR_NAME2)
;	movk	18,a0
;	move	a0,*a1(PR_NAME3)
;	movk	13,a0
;	move	a0,*a1(PR_NAME4)
;	movk	5,a0
;	move	a0,*a1(PR_NAME5)
;	movk	12,a0
;	move	a0,*a1(PR_NAME6)
;	movi	10,a14
;	move	a14,*a1(PR_TRIVIA_PTS)
;
;	movi	player3_data,a1
;	movk	8,a0
;	move	a0,*a1(PR_NAME1)
;	movk	15,a0
;	move	a0,*a1(PR_NAME2)
;	movk	20,a0
;	move	a0,*a1(PR_NAME3)
;	movk	15,a0
;	move	a0,*a1(PR_NAME4)
;	movk	14,a0
;	move	a0,*a1(PR_NAME5)
;	movk	5,a0
;	move	a0,*a1(PR_NAME6)
;	movi	1,a14
;	move	a14,*a1(PR_TRIVIA_PTS)
;
;	movi	player4_data,a1
;	movk	2,a0
;	move	a0,*a1(PR_NAME1)
;	movk	1,a0
;	move	a0,*a1(PR_NAME2)
;	movk	4,a0
;	move	a0,*a1(PR_NAME3)
;	movk	2,a0
;	move	a0,*a1(PR_NAME4)
;	movk	15,a0
;	move	a0,*a1(PR_NAME5)
;	movk	25,a0
;	move	a0,*a1(PR_NAME6)
;	clr	a14
;	move	a14,*a1(PR_TRIVIA_PTS)
;
;	SOUND1	tune_cap_snd
;	JSRP	trivia_game
;	SOUND1	tuneend_snd
;	jauc	game_over
;#notriva
;;FIXX!!! end

	movi	option_screen_mod,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not2
	movi	option_screen_mod_kit,a0
#not2	move	a0,@BAKMODS,L
	calla	BGND_UD1

	CREATE0	strt_snd

	CREATE0	monitor_buyins
	CREATE0	team_control		;determine which plyr control joystick
	CREATE0	credits
	CREATE0	credit_messages
	CREATE0	monitor_fullgame

	movk	1,a0
	move	a0,@DISPLAYON
	SLEEPK	2
	calla	display_unblank

;;;;	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
;;;;	jrnz	#2_plyrs
;;;;	JSRP	winner_stays_msg	;skip if 2 player kit
;;;;#2_plyrs

	JSRP	options_screen
	cmpi	0,a0			;create player ?
	jrne	#entr_init		;br=nope
	JSRP	design_player

	.ref	game_over_processing
	calla	game_over_processing

	JSRP	show_create_plyr_info
	JSRP	creditscreen
	movk	1,a0
	jruc	#timed_out

#entr_init
	dec	a0			;0=enter initials, 1=just select team
	jrnz	#skip_name		;br=SELECT TEAM, no initials

;;;;	movi	cheer_snd,a0
;;;;	calla	snd_play1

	movi	AUD_INITENTRD,a0	;inc initials entered audit
	calla	AUD1

	calla	del_offscreen_bobjs
	JSRP	name_entry

	move	@PSTATUS,a0
	jrz	#timed_out
	jruc	#do_teamsel
#skip_name
;;;;	movi	boo1_snd,a0
;;;;	calla	snd_play1

;	movi	#init_setup2,a2
;	calla	setup_message
;	movi	CLSDEAD|123,a0
;	move	a0,@mess_objid
;	movk	22,a0
;	move	a0,@mess_line_spacing
;	movi	#str_init,a4
;	calla	print_string_C2
;	calla	scrnrel_off
;	calla	create_text
#do_teamsel
	calla	del_offscreen_bobjs
	JSRP	new_team_select_screen
	movk	3,a10
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

;	SOUND1	tuneend_snd

;	movk	1,a0
;	move	a0,@inmatchup

	JSRP	matchup_screen

	clr	a0
	move	a0,@in_team_select
	move	a0,@inmatchup

#timed_out
	RETP



;-----------------------------------------------------------------------------
; GAME_START sound making PROCESS
;-----------------------------------------------------------------------------
strt_snd	
	SLEEP	65
	SCRIPT1	welcome_sc
	DIE

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
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



#******************************************************************************
*******************************************************************************
 SUBRP	delete_text

	movi	TYPTEXT,a0			;object ID
	clr	a1				;mask
	calla	obj_delc
	rets


#******************************************************************************
* Get initials, and pin number
******************************************************************************
 SUBRP	name_entry

;wipe obj. over screen
;;	movi	wipe_stack_vert_up,a0,L
	movi	wipe_center_up_dwn,a0,L
	movi	CREATE_NO_DEL_OBJS,a14		;dont delete objs. when done
	JSRP	do_scrn_transition

	SLEEPK	1

;build new bkgnd

	calla	del_winner_stay_free_msg
	calla	KILBGND				;Kill all old background objs
	calla	pal_clean
	calla	del_option_screen_stuff

	clr	a0
	move	a0,@WORLDTLY,L
	move	a0,@WORLDTL,L

	movi	name_entry_mod_kit,a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrnz	nmety_1
	movi	name_entry_mod,a0
nmety_1	move	a0,@BAKMODS,L
	calla	BGND_UD1

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
	clr	a0
	move	a0,@exit_status

;wipe objs off screen -- reveal new screen
	movi	un_wipe_vertical,a0,L
	movi	NO_CREATE_DEL_OBJS,a14
	JSRP	do_scrn_transition
	
	calla	delete_text

	movi	25*TSEC,a10
	CREATE	CNTDWN_PID,timeout

#wait_exit
	SLEEPK	1
	calla	update_credits

	move	@exit_status,a0
	jrnz	#wait_exit

	clr	a0
	move	a0,@can_enter_inits	;can't enter initials

	movi	CYCPID2,a0		;kill cycler
	calla	KIL1C

	calla	kill_countdown_timer
	RETP

#*****************************************************************************
******************************************************************************

BOX_IMG_WIDTH	equ	100
BOX_WIDTH	equ	94
BOX_HEIGHT	equ	105
OPEN_SPEED	equ	4
BOX_PSIZE	equ	6			;bits per pixel

BOX_Y		equ	70
BOX_X		equ	200


 SUBRP	suckup_credits

	calla	check_suckup			;credits unused?
	jrnz	#snuffit

	SOUND1	win_snd

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CLSNEUT|TYPTEXT|SUBMES2,a5	;object ID
	clr	a6				;x vel
	clr	a7				;y vel

;left side of big box
	movi	[BOX_X-BOX_IMG_WIDTH+4,0],a0			;x val
	movi	[BOX_Y,0],a1			;y val
	movi	firstwin,a2			;* image
	movi	19999,a3			;z pos
	calla	BEGINOBJ2
	move	a8,a10
;	move	a8,*a13(PDATA+0h),L

;middle of big box
	movi	[BOX_X-1,0],a0			;x val
	movi	[BOX_Y,0],a1	;y val
	movi	WINPIECE,a2			;* image
	movi	20500,a3			;z pos
	calla	BEGINOBJ2
	move	a8,a9

;right side of big box
	movi	[BOX_X-4,0],a0			;x val
	movi	[BOX_Y,0],a1	;y val
	movi	firstwin,a2			;* image
	movi	19999,a3			;z pos
	calla	BEGINOBJ2

;create 'use up remaining credits' msg
	movi	[BOX_X-BOX_IMG_WIDTH+2,0],a0			;x val
	movi	[BOX_Y,0],a1			;y val
	movi	useupbx,a2			;* image
	movi	20600,a3			;z pos
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
	move	a0,*a1+,L
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
******************************************************************************
 SUBRP	print_initials

;	clr	a5
;	movk	1,a7				;num objs
;
;	move	*a13(PC_NAM1OBJ),a8,L
;	calla	obj_off
;	move	*a13(PC_NAM2OBJ),a8,L
;	calla	obj_off
;	move	*a13(PC_NAM3OBJ),a8,L
;	calla	obj_off
;
;	move	*a13(PC_DATADDR),a2,L		;start of player data
;	move	*a2+,a0
;	move	*a13(PC_NAM1OBJ),a8,L
;	move	*a8(OIMG),a0,L
;	cmpi	INIT18SPC,a0
;	jreq	#is_space1
;	calla	obj_on
;#is_space1
;	move	*a8(OSIZEX),a0			;width of object
;	add	a0,a5
;
;	move	*a2+,a0
;	jrn	#skip
;	inc	a7
;	addk	2,a5				;+ 2 pixel space
;	move	*a13(PC_NAM2OBJ),a8,L
;	move	*a8(OIMG),a0,L
;	cmpi	INIT18SPC,a0
;	jreq	#is_space2
;	calla	obj_on
;#is_space2
;	move	*a8(OSIZEX),a0			;width of object
;	add	a0,a5
;
;	move	*a2,a0
;	jrn	#skip
;	inc	a7
;	addk	2,a5				;+ 2 pixel space
;	move	*a13(PC_NAM3OBJ),a8,L
;	move	*a8(OIMG),a0,L
;	cmpi	INIT18SPC,a0
;	jreq	#is_space3
;	calla	obj_on
;#is_space3
;	move	*a8(OSIZEX),a0			;width of object
;	add	a0,a5
;
;#skip
;	inc	a5				;+ 1/2
;	srl	1,a5				;width / 2
;	move	*a13(PC_CENTERX2),a6
;	move	@TWOPLAYERS,a0			;0 = NO, 1 = YES 2 players
;	jrz	#no_2p
;	move	*a13(PC_CENTERXkit),a6
;#no_2p
;	sub	a5,a6				;center - width/2
;
;	movi	PC_NAM1OBJ,a4
;	add	a13,a4
;#loop
;	move	*a4+,a2,L		;* object
;	move	a6,*a2(OXPOS)
;	move	*a2(OSIZEX),a0		;width of object
;	add	a0,a6
;	addk	2,a6			;2 pixel spacing
;	dsj	a7,#loop		;another img?
	rets


#*****************************************************************************
******************************************************************************
 SUBRP	print_pin_number

	PUSH	a1
	clr	a5
	movk	1,a7				;num objs
	move	*a13(PC_PIN_NBR1),a8,L
	calla	obj_off
	move	*a13(PC_PIN_NBR2),a8,L
	calla	obj_off
	move	*a13(PC_PIN_NBR3),a8,L
	calla	obj_off
	move	*a13(PC_PIN_NBR4),a8,L
	calla	obj_off

	move	*a13(PC_DATADDR),a2,L		;start of player data
	move	*a2+,a0				
	move	*a13(PC_PIN_NBR1),a8,L		;a8=* pin_number img
	move	*a8(OIMG),a0,L

;show '*' or '-' for pin number
	movi	INGA16SUB,a0,L			;assume 1st pin nbr. not entered
	move	*a13(PC_CHARPOS),a14
	subi	NAME_LETTERS-1,a14
	cmp	a7,a14		  		;has player enter 1st nbr. ?
	jrls	#noast1				;br=nope
	movi	INGA16AST,a0,L			;show '*' for entered nbr.
#noast1
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	calla	obj_aniq
	calla	obj_on

;	move	*a8(OIMG),a0,L
;#noast1
;	cmpi	INGA16SPC,a0
;	jreq	#is_space1
;	calla	obj_on
;#is_space1
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5
	move	*a2+,a0
;	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_PIN_NBR2),a8,L
	move	*a8(OIMG),a0,L

;show '*' or '-' for pin number
	movi	INGA16SUB,a0,L			;assume 2nd pin nbr. not entered
	move	*a13(PC_CHARPOS),a14
	subi	NAME_LETTERS-1,a14
	cmp	a7,a14		  		;has player enter 2nd nbr. ?
	jrls	#noast2				;br=nope
	movi	INGA16AST,a0,L			;show '*' for entered nbr.
#noast2
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	calla	obj_aniq
	calla	obj_on

;	move	*a8(OIMG),a0,L
;#noast2
;	cmpi	INGA16SPC,a0
;	jreq	#is_space2
;	calla	obj_on
;#is_space2
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

	move	*a2+,a0
;	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_PIN_NBR3),a8,L
	move	*a8(OIMG),a0,L

;show '*' or '-' for pin number
	movi	INGA16SUB,a0,L			;assume 3rd pin nbr. not entered
	move	*a13(PC_CHARPOS),a14
	subi	NAME_LETTERS-1,a14
	cmp	a7,a14				;has player entered 3rd nbr ?
	jrls	#noast3				;br=nope
	movi	INGA16AST,a0,L			;show '*' for entered nbr.
#noast3
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	calla	obj_aniq
	calla	obj_on

;	move	*a8(OIMG),a0,L
;#noast3
;	cmpi	INGA16SPC,a0
;	jreq	#is_space3
;	calla	obj_on
;#is_space3
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5
	move	*a2,a0
;	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_PIN_NBR4),a8,L
	move	*a8(OIMG),a0,L

;show '*' or '-' for pin number
	movi	INGA16SUB,a0,L			;assume 4th pin nbr. not entered
	move	*a13(PC_CHARPOS),a14
	subi	NAME_LETTERS-1,a14
	cmp	a7,a14				;has player entered 4th nbr ?
	jrls	#noast4				;br=nope
	movi	INGA16AST,a0,L			;show '*' for entered nbr.
#noast4
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	calla	obj_aniq
	calla	obj_on

;	move	*a8(OIMG),a0,L
;#noast4
;	cmpi	INGA16SPC,a0
;;	cmpi	OSGEMD_SPC,a0
;	jreq	#is_space4
;	calla	obj_on
;#is_space4
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
	movi	PC_PIN_NBR1,a4
	add	a13,a4
#loop
	move	*a4+,a2,L		;* object
	move	a6,*a2(OXPOS)
	move	*a2(OSIZEX),a0		;width of object
	add	a0,a6
	addk	1,a6			;1 pixel spacing
	dsj	a7,#loop		;another img?
	PULL	a1
	rets

#*****************************************************************************
*   returns a8 = * alpha table
******************************************************************************
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
******************************************************************************
 SUBRP	create_menu

	calla	get_menu_data
	calla	display_alpha_table	;create table of objects
	rets


#*****************************************************************************
* switch vals in a0 (starting at bit0)
******************************************************************************
; SUBRP	move_team_cursor
;
;	andi	01111b,a0
;	sll	5,a0			;x 32 bits
;	addi	joy_moves,a0
;	move	*a0,a0,L
;	call	a0
;	rets

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
******************************************************************************
 SUBRP	update_statbox_images

	move	*a13(PC_CHARPOS),a0
	sll	5,a0			;x 32 bits
	addi	#curspos_actions,a0
	move	*a0,a0,L
	jump	a0
	rets


*****************************
#curspos_actions			;6 letters in name,pin number
	.long	#name0,#name1,#name2,#name3,#name4,#name5
	.long	#pin1,#pin2,#pin3,#pin4
;;;	.long	#pltr1,#pltr2,#pltr3,#pltr4,#pltr5,#pltr6
;;;;	.long	#name0,#name1,#name2,#month,#day

*****************************
#name0
#name1
#name2
#name3
#name4
#name5
	move	*a13(PC_CHARPOS),a0	;0 - 2
	sll	5,a0			;x 32 bits
	addi	PC_NAM1OBJ,a0
	add	a13,a0
	move	*a0,a8,L		;* object
	calla	update_image
	calla	print_players_name
;	calla	print_initials
	rets

#pin1
#pin2
#pin3
#pin4
	move	*a13(PC_CHARPOS),a0	;3-6
	subi	NAME_LETTERS,a0			;just to make shifting easier
	sll	5,a0			;x 32 bits
	addi	PC_PIN_NBR1,a0
	add	a13,a0
	move	*a0,a8,L		;* object
	calla	update_image
     	calla	print_pin_number
	rets

;player game name logic (only during CREATE PLAYER)

#*****************************************************************************
* A8=*Obj

 SUBRP	update_image

	move	*a8(OYPOS),a0
	andni	400h,a0			;onscreen Y
	move	a0,*a8(OYPOS)
	calla	get_table_address	;returns * entry in a1
	move	*a1+,a1			;char under cursor
	sll	5,a1			;x 32 bits

;	move	*a13(PC_MENULEVEL),a0
;	cmpi	0,a0			;entering name ?
;	jrne	ui_1			;br=yep, USE smaller font
	addi	alpha_table2,a1
;	jruc	ui_2

;ui_1	addi	alpha_table,a1
ui_2	move	*a1,a0,L		;image addr
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
	rets

#*****************************************************************************
******************************************************************************
	.asg	57,X1
	.asg	148,X2
	.asg	251,X3
	.asg	342,X4
	.asg	200+TEAMSEL_PAGE-16,PNAMES_Y

 SUBR	create_player_names		;and attributes

;
; Name 1 (team 1)
;
	movi	player1_data,a4
	move	*a4(PR_CREATED_PLYR),a1		;is player created ?
	jrle	#nocr1				;br=nope
	movi	X1,a0
	movi	PNAMES_Y,a1
	calla	print_name
	jruc	#nam2

#nocr1	movi	[X1,0],a0			;x val
	movi	[PNAMES_Y,0],a1			;y val
	movi	AUGMON,a2			;* image
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
	calla	BEGINOBJ2
	move	a8,@name1_obj,L
;
; Name 2 (team 1)
; 
#nam2
	movi	player2_data,a4
	move	*a4(PR_CREATED_PLYR),a1		;is player created ?
	jrle	#nocr2				;br=nope
	movi	X2,a0
	movi	PNAMES_Y,a1
	calla	print_name
	jruc	#nam3
	
#nocr2	movi	[X2,0],a0			;x val
	movi	[PNAMES_Y,0],a1			;y val
	movi	AUGMON,a2			;* image
	move	@special_heads+10h,b0
	jrn	#not_spec2
	sll	5,b0				;x 32 bits
	addi	our_names,b0
	move	*b0,b0,L
	move	b0,a2
#not_spec2
	movi	DMAWNZ,a4			;DMA flags
	calla	BEGINOBJ2
	move	a8,@name2_obj,L
;
;  Name 3 (team 2)
;
#nam3	movi	player3_data,a4
	move	*a4(PR_CREATED_PLYR),a1		;is player created ?
	jrle	#nocr3				;br=nope
	movi	X3,a0
	movi	PNAMES_Y,a1
	calla	print_name
	jruc	#nam4

#nocr3	movi	[X3,0],a0			;x val
	movi	[PNAMES_Y,0],a1			;y val
	movi	AUGMON,a2			;* image
	move	@special_heads+20h,b0
	jrn	#not_spec3
	sll	5,b0				;x 32 bits
	addi	our_names,b0
	move	*b0,b0,L
	move	b0,a2
#not_spec3
	movi	DMAWNZ,a4			;DMA flags
	calla	BEGINOBJ2
	move	a8,@name3_obj,L
;
; Name 4 (team 2)
;
#nam4	movi	player4_data,a4
	move	*a4(PR_CREATED_PLYR),a1		;is player created ?
	jrle	#nocr4				;br=nope
	movi	X4,a0
	movi	PNAMES_Y,a1
	calla	print_name
	jruc	#nam5

#nocr4	movi	[X4,0],a0			;x val
	movi	[PNAMES_Y,0],a1			;y val
	movi	AUGMON,a2			;* image
	move	@special_heads+30h,b0
	jrn	#not_spec4
	sll	5,b0				;x 32 bits
	addi	our_names,b0
	move	*b0,b0,L
	move	b0,a2
#not_spec4
	movi	DMAWNZ,a4			;DMA flags
	calla	BEGINOBJ2
	move	a8,@name4_obj,L
;
; Attributes image for NAME 1 (team 1)
;
#nam5	movi	[X1-40,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	ATTRIBS,a2	;attribs,a2			;* image
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@attrib1_obj,L
;
; Attribute image for NAME 2 (team 1)
;
	movi	[X2-40,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	ATTRIBS,a2	;attribs,a2			;* image
	calla	BEGINOBJ2
	move	a8,@attrib2_obj,L
;
; Attribute image for NAME 3 (team 2)
;
	movi	[X3-40,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	ATTRIBS,a2	;attribs,a2			;* image
	calla	BEGINOBJ2
	move	a8,@attrib3_obj,L
;
; Attribute image for NAME 4 (team 2)
;
	movi	[X4-40,0],a0			;x val
	movi	[PNAMES_Y+10,0],a1		;y val
	movi	ATTRIBS,a2	;attribs,a2			;* image
	calla	BEGINOBJ2
	move	a8,@attrib4_obj,L
;
; Now fill in the values for each name (with 'bars')
;
	movi	[X1-3,0],a0			;x val
	movi	[PNAMES_Y+11,0],a1		;y val
	movi	attrib1_obj+20h,a10		;point past player name
	calla	#create_attrib

	movi	[X2-3,0],a0			;x val
	movi	[PNAMES_Y+11,0],a1		;y val
	movi	attrib2_obj+20h,a10		;point past player name
	calla	#create_attrib

	movi	[X3-3,0],a0			;x val
	movi	[PNAMES_Y+11,0],a1		;y val
	movi	attrib3_obj+20h,a10		;point past player name
	calla	#create_attrib

	movi	[X4-3,0],a0			;x val
	movi	[PNAMES_Y+11,0],a1		;y val
	movi	attrib4_obj+20h,a10		;point past player name
	calla	#create_attrib
	rets


ATTRIBSYP:
   .word   3  
   .word   00180h,00000h,07fe0h


******************************************************************************
* a0  = x
* a1  = y
* a10 = * attrib obj
*
* Changed to plot 'bar' rather than numbers
*
******************************************************************************
#create_attrib
	movk	6,a2				;# of attributes
#atloop
	PUSH	a0,a1,a2,a10
	movi	ATTBAR00,a2			;* image
	movi	1200,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	PULL	a0,a1,a2,a10
	move	a8,*a10+,L
	addi	[6,0],a1			;y spacing
#noadj	dsj	a2,#atloop
	rets


;#create_attrib
;	movk	8,a2				;# of attributes
;	PUSH	a0,a1
;#atloop
;	PUSH	a0,a1,a2,a10
;	movi	font60w,a2			;* image
;	movi	120,a3				;z pos
;	movi	DMAWNZ,a4			;DMA flags
;	clr	a5				;object ID
;	clr	a6				;x vel
;	clr	a7				;y vel
;	calla	BEGINOBJ
;	PULL	a0,a1,a2,a10
;	move	a8,*a10+,L
;	addi	[6,0],a1
;	cmpi	5,a2
;	jrnz	#noadj
;	PULL	a0,a1
;	addi	[41,0],a0			;adjust x
;#noadj	dsj	a2,#atloop
;	rets

#*****************************************************************************
* a0 = table offset to use for coordinates
******************************************************************************
 SUBR	create_player_heads

	PUSH	a10,a11
	sll	5,a0				;x 32 bits
	addi	#xy_starts,a0
	move	*a0,a10,L	       ;a10 = tbl addr. of X,Y coor. for heads
	move	*a10+,a11
	sll	16,a11			;y pos (contsant, except middle head)
;
; Head 1 (team 1)
;
	movi	player1_data,a14
	move	*a14(PR_CREATED_PLYR),a2	;is player created ?
	jrle	#ntcr1				;br=nope
	move	*a14(PR_HEAD_NBR),a2		;get head number
	sll	5,a2
	addi	create_plr_mugshots_tbl,a2
	move	*a2,a2,L			;get mugshot img
	jruc	#nrmhd1
#ntcr1
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
;
; Head 2 (team 1)
;
;;	movi	RAD_MK2,a2			;* image
;;	move	@special_heads+10h,b0
;;	jrn	#nrmhd2
;;	sll	5,b0				;x 32 bits
;;	addi	our_heads,b0
;;	move	*b0,b0,L
;;	move	b0,a2
;;#nrmhd2
;;	move	*a10+,a0			;x val
;;	sll	16,a0
;;	move	a11,a1				;y pos
;;	movi	DMAWNZ|M_FLIPH,a4		;DMA flags
;;	calla	BEGINOBJ2
;;	move	a8,@head2_obj,L
;;
; Head 2 (team 1)
;
	movi	player2_data,a14
	move	*a14(PR_CREATED_PLYR),a2	;is player created ?
	jrle	#ntcr2				;br=nope
	move	*a14(PR_HEAD_NBR),a2		;get head number
	sll	5,a2
	addi	create_plr_mugshots_tbl,a2
	move	*a2,a2,L			;get mugshot img
	jruc	#nrmhd2a
#ntcr2
	movi	RAD_MK2,a2			;* image
	move	@special_heads+10h,b0
	jrn	#nrmhd2a
	sll	5,b0				;x 32 bits
	addi	our_heads,b0
	move	*b0,b0,L
	move	b0,a2
#nrmhd2a
	move	*a10+,a0			;x val
	sll	16,a0
	move	a11,a1				;y pos
	movi	DMAWNZ|M_FLIPH,a4		;DMA flags
	calla	BEGINOBJ2
	move	a8,@head2_obj,L
;
; Head 1 (team 2)
;
	movi	player3_data,a14
	move	*a14(PR_CREATED_PLYR),a2	;is player created ?
	jrle	#ntcr3				;br=nope
	move	*a14(PR_HEAD_NBR),a2		;get head number
	sll	5,a2
	addi	create_plr_mugshots_tbl,a2
	move	*a2,a2,L			;get mugshot img
	jruc	#nrmhd3
#ntcr3
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

;
; Head 2 (team 2)
;
;;	movi	RAD_MK2,a2			;* image
;;	move	@special_heads+30h,b0
;;	jrn	#nrmhd4
;;	sll	5,b0				;x 32 bits
;;	addi	our_heads,b0
;;	move	*b0,b0,L
;;	move	b0,a2
;;#nrmhd4
;;	move	*a10+,a0			;x val
;;	sll	16,a0
;;	move	a11,a1				;y pos
;;	movi	DMAWNZ|M_FLIPH,a4		;DMA flags
;;	calla	BEGINOBJ2
;;	move	a8,@head5_obj,L
;
; Head 2 (team 2)
;
	movi	player4_data,a14
	move	*a14(PR_CREATED_PLYR),a2	;is player created ?
	jrle	#ntcr4				;br=nope
	move	*a14(PR_HEAD_NBR),a2		;get head number
	sll	5,a2
	addi	create_plr_mugshots_tbl,a2
	move	*a2,a2,L			;get mugshot img
	jruc	#nrmhd4a
#ntcr4
	movi	RAD_MK2,a2			;* image
	move	@special_heads+30h,b0
	jrn	#nrmhd4a
	sll	5,b0				;x 32 bits
	addi	our_heads,b0
	move	*b0,b0,L
	move	b0,a2
#nrmhd4a
	move	*a10,a0				;x val
	sll	16,a0
	move	a11,a1				;y pos
	movi	DMAWNZ|M_FLIPH,a4		;DMA flags
	calla	BEGINOBJ2
	move	a8,@head4_obj,L
	PULL	a10,a11
	rets


#xy_starts
	.long	#stxy1,#stxy2,#stxy3,#stxy4,#stxy5

;team select screen head positions
#stxy1	.word	174			;Y
	.word	13,192 ,207,386		;head 1 X, head 2 X...etc

;match-up screen head positions
#stxy2	.word	186			;Y
	.word	24,153,242,370

;team subsitution head positions
#stxy3	.word	174
	.word	13,192 ,207,386		;head 1 X, head 2 X...etc

;final results page
#stxy4	.word	168
	.word	29,177,223,373		;head 1 X, head 2 X...etc

;halftime stats page
#stxy5	.word	103			;Y value
	.word	28,177,223,372		;head 1 X, head 2 X...etc


#*****************************************************************************
*****************************************************************************
 SUBR	update_player_heads

	PUSH	a10
;
; Update Team 1 heads, first
;
	move	@team1,a0
	cmpi	NUM_TEAMS,a0
	jrnz	#cont1a
	move	@gmqrtr,a14
	cmpi	2,a14				;half time ?
	jrnz	#cont1a
	move	@fixbug,a14
	jrz	#do_team2
#cont1a
	move	@team1,a0
	jrnn	#valid_team1
	move	@head1_obj,a8,L			;turn off 3 heads on TEAM 1
	calla	obj_off
	move	@head2_obj,a8,L
	calla	obj_off
	jruc	#do_team2

#valid_team1
	movi	player_heads,a10
	move	@team1,a2
#lp	cmpi	0,a2
	jrz	#out
	addi	NEXT_TEAM,a10		;7 combinations * 3 heads
;;;;	addi	20*64,a10
	dec	a2
	jruc	#lp			;point to first LINEUP of team1
#out
	move	@team1,a0
	sll	4,a0			;mult. by 16 (for offset into array)
	addi	tm1set,a0		;add to begining of array
	move	*a0,a14			;get head combination number
	sll	6,a14
	add	a14,a10

;	clr	a0			;start with no offset
;;
;; Compute offset into head_table based on current team LINEUP (0-5)
;;
;#out1a
;	dec	a14
;	jrn	#out1b			;br=offset computed
;	addi	2*32,a0			;add in one LINE length
;	jruc	#out1a
;#out1b
;	add	a0,a10			;a10 = ptr. to heads

; 
; Head 1 (team 1)
;
	move	@head1_obj,a8,L
	calla	obj_on
	move	*a10,a2,L		;* HEAD image

	movi	player1_data,a14
	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
	jrle	#ducp1				;br=nope
	move	*a14(PR_HEAD_NBR),a2		;get head number
	sll	5,a2
	addi	create_plr_mugshots_tbl,a2
	move	*a2,a2,L			;get mugshot img
#ducp1
	move	@special_heads,b0
	jrnn	#spec_head1		;br=not -1
	move	*a2(ICMAP),a0,L		;Get *palette
	clr	a14
	.ref	check_rodman
	calla	check_rodman
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant
	move	a2,a0			;* NEW image
	move	*a8(OFLAGS),a1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OCTRL)
	calla	obj_aniq		;change object image
#spec_head1
; 
; Head 2 (team 1)
;
	move	@head2_obj,a8,L
	calla	obj_on
	move	*a10(20h),a2,L		;* image (2nd head)

	movi	player2_data,a14
	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
	jrle	#ducp2				;br=nope
	move	*a14(PR_HEAD_NBR),a2		;get head number
	sll	5,a2
	addi	create_plr_mugshots_tbl,a2
	move	*a2,a2,L			;get mugshot img
#ducp2
	move	@special_heads+10h,b0
	jrnn	#spec_head2
	move	*a2(ICMAP),a0,L		;Get *palette
	clr	a14
	calla	check_rodman
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant
	move	a2,a0			;* image
	move	*a8(OFLAGS),A1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OCTRL)
	calla	obj_aniq		;change object image
#spec_head2
;
; Update Team 2 heads
;
#do_team2
	move	@team2,a0
	cmpi	NUM_TEAMS,a0
	jrnz	#cont3a
	move	@gmqrtr,a14
	cmpi	2,a14				;halftime ?
	jrnz	#cont3a
	move	@fixbug,a14
	jrz	#x
#cont3a
	move	@team2,a0
	jrnn	#valid_team2
	move	@head3_obj,a8,L			;turn off 3 heads for TEAM 2
	calla	obj_off
	move	@head4_obj,a8,L
	calla	obj_off
	jruc	#x

#valid_team2
	movi	player_heads,a10
	move	@team2,a2
#lp2	cmpi	0,a2
	jrz	#out2
	addi	NEXT_TEAM,a10			;compute offset into HEAD tbl
	dec	a2
	jruc	#lp2			;point to first LINEUP of team2
#out2
	move	@team2,a0
	sll	4,a0			;mult. by 16 (for offset into array)
	addi	tm2set,a0		;add to begining of array
	move	*a0,a14			;get head combination number
	sll	6,a14
	add	a14,a10

;	clr	a0			;start with no offset
;;
;; Compute offset into head_table based on current team LINEUP (0-5)
;;
;#out2a
;	dec	a14
;	jrn	#out2b			;br=offset computed
;	addi	2*32,a0			;add in one LINE length
;	jruc	#out2a
;#out2b
;	add	a0,a10			;a10 = ptr. to heads

; 
; Head 1 (team 2)
;
	move	@head3_obj,a8,L
	calla	obj_on
	move	*a10,a2,L		;* image

	movi	player3_data,a14
	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
	jrle	#ducp3				;br=nope
	move	*a14(PR_HEAD_NBR),a2		;get head number
	sll	5,a2
	addi	create_plr_mugshots_tbl,a2
	move	*a2,a2,L			;get mugshot img
#ducp3
	move	@special_heads+20h,b0
	jrnn	#spec_head3
	move	*a2(ICMAP),a0,L		;Get *palette
	movk	1,a14
	calla	check_rodman
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant
	move	a2,a0			;* image
	move	*a8(OFLAGS),A1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OCTRL)
	calla	obj_aniq		;change object image
#spec_head3
;
; Head 2 (team 2)
;
	move	@head4_obj,a8,L
	calla	obj_on
	move	*a10(20h),a2,L		;* image (2nd head, team 2)

	movi	player4_data,a14
	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
	jrle	#ducp4				;br=nope
	move	*a14(PR_HEAD_NBR),a2		;get head number
	sll	5,a2
	addi	create_plr_mugshots_tbl,a2
	move	*a2,a2,L			;get mugshot img
#ducp4
	move	@special_heads+30h,b0
	jrnn	#spec_head4
	move	*a2(ICMAP),a0,L		;Get *palette
	movk	1,a14
	calla	check_rodman
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant
	move	a2,a0			;* image
	move	*a8(OFLAGS),A1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OFLAGS)
	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	a1,*a8(OCTRL)
	calla	obj_aniq		;change object image
#spec_head4
;
; Head 3 (team 2)
;
;;	move	@head6_obj,a8,L
;;	calla	obj_on
;;	move	*a10(40h),a2,L		;* image (3rd head, team 2)
;;	move	@special_heads+30h,b0
;;	jrnn	#spec_head5
;;	move	*a2(ICMAP),a0,L		;Get *palette
;;	calla	pal_getf
;;	move	a0,*a8(OPAL),L		;Set palette & constant
;;	move	a2,a0			;* image
;;;;;;	move	*a8(OCTRL),a1		;DMA flags
;;;;;;	move	a2,a14
;;	move	*a8(OFLAGS),A1
;;	andi	>80ff,a1		;DMA flags
;;	move	a1,*a8(OFLAGS)
;;	move	*a8(OCTRL),a1
;;	andi	>80ff,a1		;DMA flags
;;	move	a1,*a8(OCTRL)
;;	calla	obj_aniq		;change object image
;;#spec_head5
#x
	PULL	a10
	clr a0
	move	a0,@fixbug
	rets


#*****************************************************************************
*	This PROCESS flashes the players MUGSHOT
*
* INPUT: a8 - player number
*
 SUBR	flash_plyrs_mugshot
 
	sll	5,a8
	addi	hd_obj_ptrs_tbl,a8
	move	*a8,a8,L			;get player mugshot ptr.
	move	*a8,a8,L			;get player mugshot IMG ptr.
	
	move	*a8(OPAL),a0
	move	a0,*a13(PDATA)

	movi	MUG_WHT_P,a0
	calla	pal_getf
	move	a0,*a13(PDATA+16)

	.ref	win_snd
	SOUND1	win_snd

	movk	6,a10
#again
	move	*a13(PDATA+16),a0
	move	a0,*a8(OPAL)

	SLEEPK	3

	move	*a13(PDATA),a0
	move	a0,*a8(OPAL)

	SLEEPK	3

	dsj	a10,#again
#die
	DIE


hd_obj_ptrs_tbl
	.long	head1_obj
	.long	head2_obj
	.long	head3_obj
	.long	head4_obj


MUG_WHT_P:
   .word   254
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh



#*****************************************************************************
* Modified to account for new table structure and LESS attributes
*	and CREATED PLAYER logic
*
 SUBR	update_player_names

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
	movi	player_names,a10		;table in score2.asm
	move	@team1,a2
#lp	cmpi	0,a2
	jrz	#out
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
;;;;	addi	20*64,a10
	dec	a2
	jruc	#lp	
#out
;
; Compute offset into player_names table
;
	move	@team1,a0
	sll	4,a0				;mult. by 16
	addi	tm1set,a0
	move	*a0,a14
	sll	6,a14				;mult by 64
	add	a14,a10

	movi	player1_data,a1
	move	*a1(PR_CREATED_PLYR),a1		;is player created ?
	jrp	#spec1				;br=yes

	move	@name1_obj,a8,L
	calla	obj_on
	clr	a1			;bit 0
	movi	attrib1_obj,a11
	calla	flash_player_name

	move	*a10,a0,L		;image addr (for player name)
	move	@special_heads,b0
	jrnn	#spec1
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
#spec1
	movi	player2_data,a1
	move	*a1(PR_CREATED_PLYR),a1		;is player created ?
	jrp	#spec2				;br=yes

	move	@name2_obj,a8,L
	calla	obj_on
	movk	1,a1			;bit 1
	movi	attrib2_obj,a11
	calla	flash_player_name

	move	*a10(20h),a0,L		;image addr (2nd name, team 1)
	move	@special_heads+10h,b0
	jrnn	#spec2
	movi	DMAWNZ,a1		;DMA flags
	calla	obj_aniq		;change object image
#spec2

;if player 1 is a CREATED player, special logic
	movi	player1_data,a10,L
	move	*a10(PR_CREATED_PLYR),a11
	jrle	#p1ntc				;br=nope, plyr not created
	move	*a10(PR_PRIVILEGES),a11
	btst	3,a11
	jrz	#ncp1

	move	@p1_hide_atts,a14
	jrnn	#plyr2
	clr	a10				;plyr 3
	move	a10,@p1_hide_atts
	CREATE0	hide_plyr_attribs
	jruc	#plyr2
#ncp1
	movi	attrib1_obj+20h,a11
	addi	PR_SPEED_PTS,a10,L		;pt. at 1st attrib. in record
	clr	a6
	not	a6
	calla	update_attribs
	jruc	#plyr2
#p1ntc
	movi	attrib1_obj+20h,a11
	movi	player_names,a10
	move	@team1,a2
#lp3	cmpi	0,a2
	jrz	#out3
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
;;;;	addi	20*64,a10
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

	sll	7,a10				;mult. by 128 (8 attribs)
	addi	player_attribs,a10		;a10=points to player attribs.

	PUSH	a10
	move	@special_heads,a6
	calla	update_attribs
	PULL	a10

;if player 2 is a CREATED player, special logic
#plyr2
	movi	player2_data,a10,L
	move	*a10(PR_CREATED_PLYR),a11
	jrle	#p2ntc				;br=nope, plyr not created
	move	*a10(PR_PRIVILEGES),a11
	btst	3,a11
	jrz	#ncp2

	move	@p2_hide_atts,a14
	jrnn	#do_team2
	movk	1,a10				;plyr 3
	move	a10,@p2_hide_atts
	CREATE0	hide_plyr_attribs
	jruc	#do_team2
#ncp2
	movi	attrib2_obj+20h,a11
	addi	PR_SPEED_PTS,a10,L		;pt. at 1st attrib. in record
	clr	a6
	not	a6
	calla	update_attribs
	jruc	#do_team2

#p2ntc	movi	attrib2_obj+20h,a11
	movi	player_names,a10
	move	@team1,a2
#lp3x	cmpi	0,a2
	jrz	#out3x
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
;;;;	addi	20*64,a10
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
	sll	7,a10				;mult by 128 (8 attribs)
	addi	player_attribs,a10		;10=pt to plyr attrib
	move	@special_heads+10h,a6
	calla	update_attribs
;
; Now do TEAM 2
;
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
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
;;;;	addi	20*64,a10
	dec	a2
	jruc	#lp2
#out2
;
; Compute offset into player_names table
;
	move	@team2,a0
	sll	4,a0				;mult. by 16
	addi	tm2set,a0
	move	*a0,a14
	sll	6,a14				;mult by 64
	add	a14,a10

	movi	player3_data,a1
	move	*a1(PR_CREATED_PLYR),a1		;is player created ?
	jrp	#spec3				;br=yes

	move	@name3_obj,a8,L
	calla	obj_on
	movk	2,a1				;bit 2
	movi	attrib3_obj,a11
	calla	flash_player_name

	move	*a10,a0,L			;image addr
	move	@special_heads+20h,b0
	jrnn	#spec3
	movi	DMAWNZ,a1			;DMA flags
	calla	obj_aniq			;change object image
#spec3
	movi	player4_data,a1
	move	*a1(PR_CREATED_PLYR),a1		;is player created ?
	jrp	#spec4				;br=yes

	move	@name4_obj,a8,L
	calla	obj_on
	movk	3,a1				;bit 3
	movi	attrib4_obj,a11
	calla	flash_player_name

	move	*a10(20h),a0,L			;image addr
	move	@special_heads+30h,b0
	jrnn	#spec4
	movi	DMAWNZ,a1			;DMA flags
	calla	obj_aniq			;change object image
#spec4

;if player 3 is a CREATED player, special logic
	movi	player3_data,a10,L
	move	*a10(PR_CREATED_PLYR),a11
	jrle	#p3ntc				;br=nope, plyr not created
	move	*a10(PR_PRIVILEGES),a11
	btst	3,a11
	jrz	#ncp3				;br=plyr doesn't have privilege

	move	@p3_hide_atts,a14
	jrnn	#plyr_4
	movk	2,a10				;plyr 3
	move	a10,@p3_hide_atts
	CREATE0	hide_plyr_attribs
	jruc	#plyr_4
#ncp3
	movi	attrib3_obj+20h,a11
	addi	PR_SPEED_PTS,a10,L		;pt. at 1st attrib. in record
	clr	a6
	not	a6
	calla	update_attribs
	jruc	#plyr_4

#p3ntc	movi	attrib3_obj+20h,a11
	movi	player_names,a10
	move	@team2,a2
#lp6	cmpi	0,a2
	jrz	#out6
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
;;;;	addi	20*64,a10
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
	cmp	a1,a0
	jrnz	#lp5

	sll	7,a10
	addi	player_attribs,a10

	PUSH	a10
	move	@special_heads+20h,a6
	calla	update_attribs
	PULL	a10

;if player 4 is a CREATED player, special logic
#plyr_4
	movi	player4_data,a10,L
	move	*a10(PR_CREATED_PLYR),a11
	jrle	#p4ntc				;br=nope, plyr not created
	move	*a10(PR_PRIVILEGES),a11
	btst	3,a11
	jrz	#ncp4

	move	@p4_hide_atts,a14
	jrnn	#done
	movk	3,a10				;plyr 3
	move	a10,@p4_hide_atts
	CREATE0	hide_plyr_attribs
	jruc	#done
#ncp4
	movi	attrib4_obj+20h,a11
	addi	PR_SPEED_PTS,a10,L		;pt. at 1st attrib. in record
	clr	a6
	not	a6
	calla	update_attribs
	jruc	#done

#p4ntc	movi	attrib4_obj+20h,a11
	movi	player_names,a10
	move	@team2,a2
#lp6x	cmpi	0,a2
	jrz	#out6x
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
;;;;	addi	20*64,a10
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
	cmp	a1,a0
	jrnz	#lp4y
	sll	7,a10
	addi	player_attribs,a10
	move	@special_heads+30h,a6
	calla	update_attribs
#done	rets


******************************************************************************
******************************************************************************
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
* a0 = table offset to use for coordinates
*
******************************************************************************
 SUBR	create_logos
;
; Team 1 (logo)
; 
	sll	5,a0				;x 32 bits
	addi	#startxys,a0
	move	*a0,a2,L			;a2=addr. of xy table to use
	move	*a2+,a1,L
	move	*a2,a0				;x val
	sll	16,a0
	PUSH	a1,a2
	movi	T_HAWKS,a2			;* image (atlanta hawks)
	movi	2000,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@logo1_obj,L
;
; Team 1 (logo shadow)
;
	PULL	a1,a2
	move	*a2+,a0				;x val
	PUSH	a1,a2
	sll	16,a0
	movi	BALLBAK1,a2
	movi	1900,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	calla	BEGINOBJ2
	move	a8,@logo1_obj+20h,L
;
; Team 2 (logo)
;
	PULL	a1,a2				;y val
	move	*a2,a0				;x val
	PUSH	a1,a2
	sll	16,a0
	movi	T_HAWKS,a2			;* image (atlanta hawks)
	movi	2000,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@logo2_obj,L
;
; Team 2 (logo shadow)
;
	PULL	a1,a2
	move	*a2+,a0				;x val
	sll	16,a0
	movi	BALLBAK1,a2
	movi	1900,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	calla	BEGINOBJ2
	move	a8,@logo2_obj+20h,L
	rets


#startxys	.long	#stxy1,#stxy2,#stxy3,#stxy4

;team select logo positions      
#stxy1	.long	(TM1_Y-35-5)<<16	;Y
	.word	TM1_X+50,TM2_X-50     ;1st logo X, 2nd logo X
	

;match-up screen logo positions
#stxy2	.long	140<<16			;Y
	.word	80,311


;halftime subsitution logo positions
#stxy3	.long	65<<16
	.word	75,325

;final result page
#stxy4	.long	61<<16
	.word	101,297


******************************************************************************
******************************************************************************
 SUBR	update_logos


	move	@tm1_show_tm_stats,a14
	jrne	#tm1off				;br=team stats visible

	move	@logo1_obj,a8,L
	calla	obj_on
	move	@logo1_obj+20h,a8,L
	calla	obj_on
	move	@team1,a0
	jrnn	#valid_team1
#tm1off
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
	calla	obj_aniq		;change object image (logo)
	PULL	a0
;	move	@logo1_obj+20h,a8,L
;	movi	DMACNZ,a1		;DMA flags
;	calla	obj_aniq		;change object image (shadow)

#team2
	move	@tm2_show_tm_stats,a14
	jrne	#tm2off				;br=team stats visible

	move	@logo2_obj,a8,L
	calla	obj_on
	move	@logo2_obj+20h,a8,L
	calla	obj_on
	move	@team2,a0
	jrnn	#valid_team2
#tm2off
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
;	move	@logo2_obj+20h,a8,L
;	movi	DMACNZ,a1		;DMA flags
;	calla	obj_aniq		;change object image
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


;#*****************************************************************************
;*   Update cursor position & size for a player
;*  base on the image it's over
;******************************************************************************
update_cursor

	calla	get_table_address
	move	*a1+,a3			;char under cursor
	sll	5,a3			;x 32 bits
	addi	alpha_table,a3
	move	*a3,a3,L		;image addr
	move	*a3+,a0			;image width
	addi	4,a0
	move	*a13(PC_CURSOBJ),a8,L
	move	a0,*a8(OSIZEX)
	move	*a3,a0			;image height
	addi	2,a0
	move	a0,*a8(OSIZEY)
	move	*a1+,a0			;x offset
	move	*a13(PC_STARTX),a2
	add	a2,a0
	subi	2,a0
	move	a0,*a8(OXPOS)
	move	*a1+,a0			;y offset
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
*
* INPUT: reg a0 = which/where to put heading image and text
******************************************************************************
 SUBR	create_heading

	move	@GAMSTATE,a1
	cmpi	INPLYRDESIGN,a1
	jreq	#not_2pc		      ;no heading during CREATE PLAYER
 	
	move	*a13(PC_PLAYNUM),a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#not_2pa
	addk	4,a0				;adjust for KIT setup
#not_2pa
	sll	5,a0				;x 32 bits
	move	a0,b0
	addi	#heading_imgs,a0
	addi	#heading_pals,b0

	move	*a0,a2,L			;* image
	move	*a13(PC_CENTERX),a0		;x val

	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#not_2pb
	move	*a13(PC_CENTERXkit),a0		;x val
#not_2pb
	sll	16,a0				;shift up past fractional
;;;;	subi	00280000h,a0,L			;adjust for anim. point

;create title bar (part 1)
	movi	[NAMENT_PAGE+9,0],a1		;y val
	movk	4,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	move	*a13(PC_OBJID),a5		;OBJ ID
	clr	a6				;x vel
	clr	a7				;y vel
	move	*b0,b0,L			;get palette
	calla	BEGINOBJP2

;now print TITLE on bar
	
	move	*a13(PC_PLAYNUM),a0
	sll	5,a0

	move	@TWOPLAYERS,a14			;0 = NO, 1 = YES 2 players
	jrz	#nkit				;br=not KIT
	addi	#heading_setup_tbl_kit,a0,L
	jruc	#kit2
#nkit 	addi	#heading_setup_tbl,a0,L

#kit2	move	*a0,a2,L			;get setup str. table ptr.
	calla	setup_message
	move	*a13(PC_OBJID),a0		;OBJ ID
	move	a0,@mess_objid
	movk	10,a0
	move	a0,@mess_line_spacing

;compute which string to use
	move	*a13(PC_MENULEVEL),a0
	sll	5,a0				;mult. by 32
	addi	#title_str_table,a0
	move	*a0,a4,L
	calla	print_string_C2
#not_2pc
	rets


******************************************************************************
*
* INPUT: reg a10 = player number
******************************************************************************
 SUBR	create_heading2

	move	a10,a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#not2
	addk	4,a0				;adjust for KIT setup
#not2
	sll	5,a0				;x 32 bits
	move	a0,b0
	addi	#heading_imgs,a0
	addi	#heading_pals,b0
	move	*a0,a2,L			;* image

	move	a10,a0
	sll	6,a0			;x16x4
	addi	#center_xs,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not2a
	addi	20h,a0
#not2a
	move	*a0,a0
	sll	16,a0				;shift up past fractional

;create title bar
	movi	[NAMENT_PAGE+9,0],a1		;y val
	movk	4,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5			;OBJ ID
	clr	a6				;x vel
	clr	a7				;y vel
	move	*b0,b0,L			;get palette
	calla	BEGINOBJP2

;now print TITLE on bar
	
	move	a10,a0
	sll	5,a0

	move	@TWOPLAYERS,a14			;0 = NO, 1 = YES 2 players
	jrz	#nokit				;br=not KIT
	addi	#heading_setup_tbl_kit,a0,L
	jruc	#kit
#nokit 	addi	#heading_setup_tbl,a0,L

#kit	move	*a0,a2,L			;get setup str. table ptr.
	calla	setup_message

;compute which string to use
	movi	stats_str,a4,L
	calla	print_string_C2
	rets



#heading_imgs
	.long	TEAMBR2,TEAMBR2,TEAMBR2,TEAMBR2		;normal 
	.long	TEAMBR2,TEAMBR2,TEAMBR2,TEAMBR2		;kit

#heading_pals
	.long	TUBE_B_P,TUBE_G_P,TUBE_Y_P,TUBE_R_P	;normal
	.long	TUBE_B_P,TUBE_G_P,TUBE_Y_P,TUBE_R_P	;kit


#heading_setup_tbl
	.long	p1_heading_str_setup
	.long	p2_heading_str_setup
	.long	p3_heading_str_setup
	.long	p4_heading_str_setup

#heading_setup_tbl_kit
	.long	p1_heading_str_setup_kit
	.long	p2_heading_str_setup_kit
	.long	p3_heading_str_setup_kit
	.long	p4_heading_str_setup_kit


p1_heading_str_setup
	PRINT_STR	bast8_ascii,4,0,56,11,BAST_W_P,0
p2_heading_str_setup
	PRINT_STR	bast8_ascii,4,0,151,11,BAST_W_P,0
p3_heading_str_setup
	PRINT_STR	bast8_ascii,4,0,248,11,BAST_W_P,0
p4_heading_str_setup
	PRINT_STR	bast8_ascii,4,0,344,11,BAST_W_P,0

p1_heading_str_setup_kit
	PRINT_STR	bast8_ascii,4,0,53,11,BAST_W_P,0
p2_heading_str_setup_kit
	PRINT_STR	bast8_ascii,4,0,103,11,BAST_W_P,0
p3_heading_str_setup_kit
	PRINT_STR	bast8_ascii,4,0,297,11,BAST_W_P,0
p4_heading_str_setup_kit
	PRINT_STR	bast8_ascii,4,0,346,11,BAST_W_P,0

#center_xs	;for menu data (letters and pin number objs)
	.word	54,60,	0,0		;player 1
	.word	150,151,101,0		;player 2
	.word	248,254,295,0		;player 3
	.word	344,345,0,0		;player 4

#title_str_table
	.long	initials_str
	.long	pin_nbr_str
	.long	stats_str


initials_str
	.string	"NAME",0
	.even
pin_nbr_str
	.string	"PIN NUMBER",0
	.even
stats_str
	.string	"STATS",0
	.even


#*****************************************************************************
*  a5 = object ID	(pin number objects)
******************************************************************************
 SUBRP	create_pin_nbr_objs

	movk	4,a2		;4 digits in pin_number
#obj_loop1
	PUSH	a0,a1,a2,a5

	movi	[400h | (213-7),0],a1		;assume not in CREATE PLyr (y val)

	move	@GAMSTATE,a0
	cmpi	INPLYRDESIGN,a0
	jrne	#gyval1		      		;not in CREATE PLAYER

	movi	[217|400h,0],a1			;y val
#gyval1
	clr	a0				;x val
	movi	INGA16SUB,a2			;* image
	movi	100,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	PULL	a0,a1,a2,a5
	move	a8,*a1+,L			;save * object
	addi	[21,0],a0
	dsj	a2,#obj_loop1
	rets

#*****************************************************************************
******************************************************************************
 SUBRP	next_menu

	move	*a13(PC_OBJID),a0		;OBJ ID's created by this PROC
	calla	obj_del1c			;delete all objs with this ID

	move	*a13(PC_MENULEVEL),a0
	inc	a0
	cmpi	MENU_LEVELS,a0
;	cmpi	3,a0
	jrlt	#ok
	clr	a0
#ok
	move	a0,*a13(PC_MENULEVEL)
	calla	create_menu
	calla	update_cursor
	rets

#*****************************************************************************
*    Saves the selected menu item into playerX_data
******************************************************************************
 SUBRP	save_selection

	move	*a13(PC_DATADDR),a0,L		;start of player data
	move	*a13(PC_CHARPOS),a1
	sll	4,a1				;x 16 bits
	add	a0,a1
	move	*a13(PC_CURSPOS),a0
	sll	4,a0
	addi	save_data_tbl,a0		;get actual value to store!!
	move	*a0,a0				;get char. value
	move	a0,*a1				;save char selected
	rets


save_data_tbl
	.word	1	;a or 1 (pin)
	.word	2	;b or 2
	.word	3	;c or 3
	.word	4	;d or 4
	.word	5	;e or 5
	.word	6	;f or 6
	.word	7	;g or 7
	.word	8	;h or 8
	.word	9	;i ot 9
	.word	10	;j
	.word	11	;k
	.word	12	;l
	.word	13	;m
	.word	14	;n
	.word	15	;o
	.word	16	;p
	.word	17	;q
	.word	18	;r
	.word	19	;s
	.word	20	;t
	.word	21	;u
	.word	22	;v
	.word	23	;w
	.word	24	;x
	.word	25	;y
	.word	26	;z
	.word	27	;!
	.word	28	;del
	.word	29	;spc
	.word	0	;end


#*****************************************************************************
******************************************************************************
 SUBRP	check_delete

	move	*a13(PC_CURSPOS),a0
	cmpi	DEL_CHAR,a0				;delete icon?
	jrne	#no_delete

	move	*a13(PC_CHARPOS),a0		;no delete, but can't select
	jrz	#zippo				;delete icon either

	move	*a13(PC_DATADDR),a0,L		;start of player data
	move	*a13(PC_CHARPOS),a1
	sll	4,a1				;x 16 bits
	add	a0,a1

;	movi	END_CHAR,a0
;	movi	-1,a0
	clr	a0
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
******************************************************************************
 SUBRP	check_end

	move	*a13(PC_CURSPOS),a0
	cmpi	END_CHAR,a0				;delete icon?
	jrne	#no_end
#chkend
	setc
	rets
#no_end
	clrc
	rets


#*****************************************************************************
******************************************************************************
 SUBRP	inc_charpos

	move	*a13(PC_CHARPOS),a0
	inc	a0
	move	a0,*a13(PC_CHARPOS)
	rets


#*****************************************************************************
******************************************************************************
 SUBRP	button_actions

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
	addi	select_sounds,a0
;	move	*a0,a3,L
;	calla	SNDSND
	move	*a0,a0,L
	calla	snd_play1

	move	*a13(PC_CURSOBJ),a8,L
	calla	obj_on
;
; Don't flash cursor if entering PIN NUMBER
;
	move	*a13(PC_CHARPOS),a0
;;	cmpi	7,a0
;;	jrhs	#flsh			;br=blink if entering game name
	cmpi	NAME_LETTERS,a0
	jrhs	#noflsh			;br=entering pin number
;	movi	0202h,a9		;const flash colour (black)
#flsh	movi	0101h,a9		;const flash colour (white)

	movi	0202h,a10		;const colour
	JSRP	flash_cursor
#noflsh
	move	*a13(PC_CHARPOS),a0
	sll	5,a0			;x 32 bits
	addi	#actions,a0
	move	*a0,a0,L
	call	a0
	RETP


#actions
	.long	#name0,#name1,#name2,#name3,#name4,#name5
	.long	#pin1,#pin2,#pin3,#pin4
;;;;	.long	#pltr1,#pltr2,#pltr3,#pltr4,#pltr5,#pltr6
;;;;	.long	#name0,#name1,#name2,#mont,,#day

#name0
#name1
#name2
#name3
#name4
	calla	check_end
	jrnc	#x11				;br=plyr didn't select END
	move	*a13(PC_PLAYNUM),a0
	move	@GAMSTATE,a14
	cmpi	INPLYRDESIGN,a14
	jrne	#x111
	clr	a0			;used 'player1_data' in CREATE PLAYER
#x111	calla	censor_players_name
	jrnc	#x1				;br=NAUGHTY word found...
	movi	NAME_LETTERS,a0			;set so that PIN nbr is next
	move	a0,*a13(PC_CHARPOS)		
	jrc	#x2

#x11	calla	check_delete
	jrc	#x1
	calla	inc_charpos
#x1	rets

#name5
	calla	check_delete
	jrc	#x3
	move	*a13(PC_PLAYNUM),a0
	move	@GAMSTATE,a14
	cmpi	INPLYRDESIGN,a14
	jrne	#x211
	clr	a0			;used 'player1_data' in CREATE PLAYER
#x211	calla	censor_players_name
	jrnc	#x3				;br=NAUGHTY word found...
	calla	inc_charpos
#x2	calla	next_menu
	calla	hide_name_objs
	clr	a0
	calla	move_cursor
	calla	create_heading
#x3	rets



#pin1
#pin2
#pin3
	calla	check_delete_pin_nbr
	jrc	#pinx1
	calla	inc_charpos
#pinx1	rets

#pin4
	calla	check_delete_pin_nbr
	jrc	#pinx2
	move	*a13(PC_OBJID),a0		;OBJ ID's created by this PROC
	calla	obj_del1c			;delete all objs with this ID
	move	*a13(PC_MENULEVEL),a0
	inc	a0
	move	a0,*a13(PC_MENULEVEL)
	calla	hide_name_objs
	calla	create_heading			;show stats, if any
#pinx2	rets


#*****************************************************************************
******************************************************************************
 SUBRP	check_delete_pin_nbr

	move	*a13(PC_CURSPOS),a0
	cmpi	11,a0				;delete icon?
	jrne	#no_delete

	move	*a13(PC_CHARPOS),a0		;no delete, but can't select
	cmpi	NAME_LETTERS,a0
	jreq	#zippo				;delete icon either

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
* hide all name images off bottom of screen
******************************************************************************
 SUBRP	hide_name_objs

	movi	PC_NAM1OBJ,a3
	add	a13,a3
	movk	10,a2			;6 name objs to hide + pin number (4)
#hide_loop
	move	*a3+,a1,L		;* object
	move	*a1(OYPOS),a0
	ori	400h,a0			;offscreen Y
	move	a0,*a1(OYPOS)
	dsj	a2,#hide_loop
	rets

#*****************************************************************************
* INPUT:	a9  = const colour for flash
*		a10 = const colour to revert to
*-----------------------------------------------------------------------------
 SUBR	flash_cursor

	movk	2,a11
#again
	move	a9,*a8(OCONST)
	SLEEPK	2
	move	a10,*a8(OCONST)
	SLEEPK	2
	dsj	a11,#again
	RETP


#*****************************************************************************
* INPUT:	a9  = const colour for flash
*		a10 = const colour to revert to
*		a11 = * plate objs
*-----------------------------------------------------------------------------
; SUBRP	flash_cursorNplate
;
;	movk	6,a0
;#again
;	PUSHP	a0
;	move	*a11,a8,L
;	movi	1919h,a2
;	move	a2,*a8(OCONST)
;	calla	const_on
;	move	*a11(20h),a8,L
;	movi	1919h,a2
;	move	a2,*a8(OCONST)
;	calla	const_on
;
;	move	*a13(PC_CURSOBJ),a8,L
;	move	a9,*a8(OCONST)
;
;	SLEEPK	3
;
;	move	*a11,a8,L
;	calla	const_off
;	move	*a11(20h),a8,L
;	calla	const_off
;	move	*a13(PC_CURSOBJ),a8,L
;	move	a10,*a8(OCONST)
;	SLEEPK	3
;	PULLP	a0
;	dsj	a0,#again
;	RETP

#*****************************************************************************
* convert team cursor position into actual team number
*-----------------------------------------------------------------------------
 SUBRP	get_team_number

;	move	*a13(PC_CURSPOS),a0	;position
;	sll	4,a0			;x16 bits
;	addi	team_convert,a0
;	move	*a0,a0
	rets

#*****************************************************************************
* process that displays PRESS START & INSERT COIN in player stat boxes
*-----------------------------------------------------------------------------
 SUBR	credit_messages

;MESSAGE_Y	equ	216<<16
MESSAGE_Y	equ	208<<16

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


#msg_x	.word	58,149,251,343			;x val (normal 4-player game)

#msg_x2	.word	0,101,295,0			;x val (KIT)


#*****************************************************************************
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
******************************************************************************
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
	movi	PR_NAME1,a2
	add	a1,a2
	move	a2,*a13(PC_DATADDR),L		;start of player data

	movi	-1,a0				;init player data to -1
	move	a0,*a1(PR_COUNT)
;	movi	END_CHAR,a0
	clr	a0
	move	a0,*a1(PR_NAME1)
	move	a0,*a1(PR_NAME2)
	move	a0,*a1(PR_NAME3)
	move	a0,*a1(PR_NAME4)
	move	a0,*a1(PR_NAME5)
	move	a0,*a1(PR_NAME6)
	move	a0,*a1(PR_PIN_NBR1)
	move	a0,*a1(PR_PIN_NBR2)
	move	a0,*a1(PR_PIN_NBR3)
	move	a0,*a1(PR_PIN_NBR4)

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
	movi	INGA16_A,a2		;* image
	movk	1,a3			;z pos
	movi	DMACAL,a4		;DMA flags
	move	*a13(PC_OBJID),a5
	ori	10h,a5			;object	ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2

	movi	0202h,a0
	move	a0,*a8(OCONST)
	move	a8,*a13(PC_CURSOBJ),L

	move	*a13(PC_OBJID),a5
	ori	10h,a5			;ID
	calla	create_name_objs
	calla	create_pin_nbr_objs

	clr	a0
	move	a0,*a13(PC_CHARPOS)

;;;;	calla	create_initials_pin_nbr_objs

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

	move	@transition_flag,a0
	jrnz	#loop			;br -> 1=doin screen transition

;	move	@page_scrolling,a0
;	jrnz	#loop			;scrolling on, so no input
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
	cmpi	MENU_LEVELS,a0
;;	cmpi	3,a0
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
	move	*a13(PC_OBJID),a0
	ori	10h,a0
	calla	obj_del1c

	SLEEPK	1

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0			;x 32 bits
	addi	#player_data,a0
	move	*a0,a0,L		;start address of player data
	move	a0,*a13(PC_DATADDR),L	;start of player data
	calla	get_player_record

	move	*a13(PC_DATADDR),a14,L		;start of player data
	move	*a14(PR_TRIVIA_PTS),a14
	cmpi	TRIVIA_PTS_NEEDED,a14
	jrlo	ano_1
	move	*a13(PC_PLAYNUM),a10
	CREATE0	qualify_plaque
	calla	print_trivia_info

	JSRP	ask_yes_no

	move	*a13(PC_PLAYNUM),a10
	calla	del_yes_no_buttons	;and instructions

	move	a11,a11
	jrnz	ano_1				;br='NO' selected
	JSRP	show_trivia_stuff

ano_1	move	a13,a11
	CREATE0	plyr_plaques

	move	*a13(PC_DATADDR),a3,L		;start of player data
	move	*a13(PC_PLAYNUM),a10
	calla	check_special_initials		;look for designer heads...etc

	JSRP	print_player_stats

	move	*a13(PC_DATADDR),a3,L		;start of player data
	move	*a3(PR_NAME1),a0
	jrgt	#valid
;	move	*a3(PR_PIN_NBR1),a0
;	jrle	#invalid

;	jrnn	#valid
;;	cmpi	END_CHAR,a0
;;	jrlo	#valid				;br=name is fine!
;
;is ENDXXXXX,0000				;so erase his ass
;
#invalid
;	movi	-1,a0
;	movi	END_CHAR,a0
	clr	a0
	move	a0,*a3(PR_NAME1)
	move	a0,*a3(PR_NAME2)
	move	a0,*a3(PR_NAME3)
	move	a0,*a3(PR_NAME4)
	move	a0,*a3(PR_NAME5)
	move	a0,*a3(PR_NAME6)
	move	a0,*a3(PR_PIN_NBR1)
	move	a0,*a3(PR_PIN_NBR2)
	move	a0,*a3(PR_PIN_NBR3)
	move	a0,*a3(PR_PIN_NBR4)
;	clr	a0
	move	a0,*a3(PR_COUNT)
#valid

;	movk	30,a10
;#dly1
;	SLEEPK	1
;	move	*a13(PC_PLAYNUM),a1
;	move	@PSTATUS,a0
;	btst	a1,a0
;	jrz	#resart_cursor
;	move	@force_selection,a0
;	jrnz	#youre_out
;	dsj	a10,#dly1

;	movi	7*60,a10
;#wait	SLEEPK	1
;	move	*a13(PC_PLAYNUM),a1
;	move	@PSTATUS,a0
;	btst	a1,a0
;	jrz	#resart_cursor
;	move	@force_selection,a0
;	jrnz	#youre_out
;	move	*a13(PC_PLAYNUM),a0
;	calla	get_but_val_cur
;	jrnz	#exit1
;	dec	a10
;	jrnz	#wait
;	jruc	#ex2
;
;
;#exit1
;;Do a snd when whacking through
;	SOUND1	bounce_snd
;#ex2
;
	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	calla	obj_del1c		;delete all objs with this ID

	move	*a13(PC_DATADDR),a1,L	;start of player data
	move	*a1(PR_NUMDEF),a0	;number teams defeated
	jrz	#no_wins
	cmpi	NUM_TEAMS,a0
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
	SOUND1	adv_stats
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



#obj_ids
	.word	TYPTEXT|SUBPL1
	.word	TYPTEXT|SUBPL2
	.word	TYPTEXT|SUBPL3
	.word	TYPTEXT|SUBPL4

#center_xs	;for menu data (letters and pin number objs)
	.word	54,60,	0,0		;player 1
	.word	150,151,101,0		;player 2
	.word	248,254,295,0		;player 3
	.word	344,345,0,0		;player 4

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

	move	@team1_control,a0
	move	*a13(PC_PLAYNUM),a1
	jrz	#lft
	move	@team2_control,a0
#lft
	sll	5,a0
	addi	defeated,a0
	move	*a0,a0,L
	move	*a0,a0,L
	cmpi	ALL_TMS_DEFEATD,a0
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
;	move	*a0,a3,L
;	calla	SNDSND
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
    
	move	@team1_control,a0
	move	*a13(PC_PLAYNUM),a1
	jrz	#lft1
	move	@team2_control,a0
#lft1
	sll	5,a0
	addi	defeated,a0
	move	*a0,a0,L
	move	*a0,a0,L	
	cmpi	ALL_TMS_DEFEATD,a0
	jrz	#not_blankl

	dec	a10			;skip to left of blank position
#not_blankl
	move	a10,*a13(PC_CURSPOS)
	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)		;cursor flash count

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
	addi	cursor_sounds,a0
;	move	*a0,a3,L
;	calla	SNDSND
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

    
	move	@team1_control,a0
	move	*a13(PC_PLAYNUM),a1
	jrz	#lft2
	move	@team2_control,a0
#lft2
	sll	5,a0
	addi	defeated,a0
	move	*a0,a0,L
	move	*a0,a0,L	
	cmpi	ALL_TMS_DEFEATD,a0
	jrz	#not_blankr

	inc	a10			;skip to right of blank position
#not_blankr
	move	a10,*a13(PC_CURSPOS)
	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)		;cursor flash count

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
	addi	cursor_sounds,a0
;	move	*a0,a3,L
;	calla	SNDSND
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
*   a8 = * alpha table
*   a9 = palette number (indexed into #palettes table)
*  a10 = [y,x] start pos
*  a11 = OBJECT ID
******************************************************************************
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
;	cmpi	C_SAN,a2
;	jrnz	#no
;	LOCKUP
#no
	move	*a8+,a0
	movx	a10,a1				;x start pos
	add	a1,a0
	sll	16,a0				;x val	[int,frac]
	move	*a8+,a1
	sll	16,a1				;y val	[ing,frac]
	add	a10,a1				;y start pos
	andi	[0ffffh,0],a1			;clear fractional

	movi	DMAWNZ,a4			;DMA flags

;	move	@GAMSTATE,a3
;	cmpi	INPLYRDESIGN,a3
;	jrne	#cp_1		      		;not in CREATE PLAYER
;
;	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
;#cp_1
	movk	8,a3				;z pos
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
;	.long	BLUE,BLUE,REDPAL,REDPAL,WGSF_B_P
	.long	INGA_Y_P,INGA_Y_P,INGA_WDP,INGA_WDP,INGA_Y_P
	.long	0,0,0,0
	.long	SGMD8WHT,SGMD8WHT		;left & right city columns


#*****************************************************************************
******************************************************************************
 SUBR	credits
 
	clr	a0				;y offset
	move	@TWOPLAYERS,a14		;0 = NO, 1 = YES 2 players
	jrz	#nt2p
	movi	[1,0],a0
#nt2p	calla	create_credits
	calla	create_credit_timers

#credit_loop
	calla	update_credits
	calla	update_credit_timers
	SLEEPK	1
	jruc	#credit_loop

#*****************************************************************************
******************************************************************************
 SUBR	credits2

	movi	[7,0],a0			;y offset
	calla	create_credits

#credit_loop
	calla	update_credits
	SLEEPK	1
	jruc	#credit_loop

#*****************************************************************************
******************************************************************************
 SUBR	credits3

	clr	a0				;y offset
	calla	create_credits

#credit_loop
	calla	update_credits
	SLEEPK	1
	jruc	#credit_loop

#*****************************************************************************
;  This process creates/updates the CREDITS value during CREATE PLAYER mode
******************************************************************************
 SUBR	create_and_watch_credits

	movi	[2,0],a0			;y offset
	calla	create_credits

	move	@credit1_obj,a8,L
	move	*a8(OXVAL),a0,L
	subi	00100000h,a0
	move	a0,*a8(OXVAL),L			;move all CREDIT obj. left

	move	@credit2_obj,a8,L
	move	*a8(OXVAL),a0,L
	subi	00100000h,a0
	move	a0,*a8(OXVAL),L			;move all CREDIT obj. left

	move	@credit3_obj,a8,L
	move	*a8(OXVAL),a0,L
	subi	00100000h,a0
	move	a0,*a8(OXVAL),L			;move all CREDIT obj. left

#credit_loop
	calla	update_credits
	SLEEPK	1
	jruc	#credit_loop



	.asg	240<<16,CREDIT_Y
	.asg	211<<16,CREDIT_X

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_credit_plate

	movi	CREDIT_X-03300000,a0			;X coor.
	movi	CREDIT_Y-00000000,a1			;Y coor.
	movi	CREDTOOB,a2,L
	movi	70,a3				;Z
	movi	DMAWNZ|M_SCRNREL,a4
	clr	a5
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
 	rets

#*****************************************************************************
******************************************************************************
 SUBR	create_credits

	PUSH	a0
	movi	CREDIT_Y-1,a1			;y val
	add	a0,a1
	movi	CREDIT_X,a0			;x val
	movi	font60,a2			;* image
	movi	18000-1,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object	ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@credit1_obj,L		;"CREDIT"

	PULL	a0
	PUSH	a0
	movi	CREDIT_Y-1,a1			;y val
	add	a0,a1
	movi	CREDIT_X+(6<<16),a0		;x val
	movi	font60,a2			;* image
	movi	18000-1,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object	ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@credit2_obj,L		;1st credit digit


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
	movi	18000-1,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object	ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	move	a8,@credit3_obj,L		;3rd credit digit or FREEPLAY

	rets


#*****************************************************************************
******************************************************************************
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
*   create the 4 credits timers displayed in the player stats box
******************************************************************************
 SUBRP	create_credit_timers

	movk	1,a5			;player number 2
	calla	create_cr_timer
	movi	credtime2_obj,a0	;* obj
	move	a8,*a0,L

	movk	2,a5			;player number 3
	calla	create_cr_timer
	movi	credtime3_obj,a0	;* obj
	move	a8,*a0,L


	move	@TWOPLAYERS,a5		;0 = NO, 1 = YES 2 players
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
* INPUT:	a5 = player number (0-3)
******************************************************************************

	.asg	237<<16,CREDIT_Y

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
	movi	DMAWNZ,a4		;DMA flags
;;	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object	ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	rets



#credit_balls
	.long	t0000		;player 1
	.long	t0000		;player 2
	.long	tX000		;player 3
	.long	tX000		;player 4

;Positions for 4-player version
#credit_positions
	.long	34<<16		;player 1
	.long	126<<16		;player 2
	.long	228<<16		;player 3
	.long	321<<16		;player 4

;Positions for KIT
#credit_positions2
	.long	0		;player 1
	.long	80<<16		;player 2
	.long	274<<16		;player 3
	.long	0		;player 4

#*****************************************************************************
*   update the 4 credits timers displayed in the player stats box
******************************************************************************
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
	jrz	#4_plyrs

	move	@PSTATUS,a0
	subk	6,a0
	jrnz	#2_plyrs
	jruc	#cyc_kil

#4_plyrs
	clr	a10			;player 1
	movi	credtime1_obj,a6	;* start of obj vars
	move	@qtr_purchased,a7
	calla	update_cr_timer

	movk	3,a10			;player 4
	movi	credtime4_obj,a6	;* start of obj vars
	move	@qtr_purchased+30h,a7
	calla	update_cr_timer

	move	@PSTATUS,a0
	subk	15,a0
	jrnz	#2_plyrs
#cyc_kil
	movi	JOIN_CYCLE_PID,a0
	calla	KIL1C
#2_plyrs
	rets


#*****************************************************************************
* INPUT:	a10 = player number (0-3)
*		a6 = * start of obj vars
*		a7 = # quarters credit
*-----------------------------------------------------------------------------
 SUBRP	update_cr_timer

	move	a7,a7
	jrnz	#not_zip

	movi	tXXXX,a0			;'join in' img
	jruc	#setit

#not_zip
	move	@gmqrtr,a1
	cmpi	4,a1
	jrlt	#ok
	movi	tXXX1,a0
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

;update palette and bits per pixel
	PUSH	a0
	move	*a0(ICMAP),a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)
	PULL	a0

	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	*a0(ICTRL),a14
	andni	>80ff,a14		;DMA flags
	or	a14,a1
	move	a1,*a8(OCTRL)
;	move	*a8(OCTRL),a1
	calla	obj_aniq
	rets

tballs
	.long	0
	.long	t1000,t1100,t1110,t1111
	.long	tX100,tX110,tX111,tXXXX
	.long	tXX10,tXX11,tXXXX,tXXXX
	.long	tXXX1,tXXXX,tXXXX,tXXXX

	.long	tX000,tXX00,tXXX0
	.long	tX100,tX110,tX111
	.long	tXX10,tXX11,tXXX1
	.long	t0000


leds	.long	S_LED_0,S_LED_1,S_LED_2,S_LED_3,S_LED_4
	.long	S_LED_5,S_LED_6,S_LED_7,S_LED_8,S_LED_9	


#*****************************************************************************
* INPUT:	a8 = * object
*-----------------------------------------------------------------------------
 SUBR	obj_on
 	move	*a8(OYPOS),a0
	andni	400h,a0
	move	a0,*a8(OYPOS)
 	rets

#*****************************************************************************
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
;
;	calla	pal_clean
; 
;	movk	1,a0
;	move	a0,@page_scrolling	;scrolling
;
;	movi	scroll_snd,a0
;	calla	snd_play1
;
;	movi	256/SCROLL_SPEED,a9
;
;#scroll_loop
;	SLEEPK	1
;
;	move	@WORLDTLY,a0,L
;	add	a10,a0			;+/- SCROLL_SPEED
;	move	a0,@WORLDTLY,L
;
;	calla	BGND_UD1
;
;	dsj	a9,#scroll_loop
;
;	SLEEPK	2
;	clr	a0
;	move	a0,@page_scrolling	;not scrolling
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
;me	PUSH	a4
	move	a4,a11
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

;me	PULL	a4
	move	a11,a4

#no_player
#purchased
#no_purchase
	inc	a4
	cmpi	4,a4
	jrlt	#next

	SLEEPK	2
	jruc	#loopit

#images
	.long	FulGameblu,FulGamegrn
	.long	FulGameyel,FulGamered
	.long	FulGameblu,FulGameblu
	.long	FulGamered,FulGamered

#plaque_xs
	.word	13,105,207,299
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



;const_on
;	move	*a8(OCTRL),a0
;	andni	01111b,a0
;	ori	M_CONST,a0		;Replace all with constant
;	move	a0,*a8(OCTRL)
;	rets
;
;const_off
;	move	*a8(OCTRL),a0
;	andni	01111b,a0
;	ori	M_WRNONZ,a0
;	move	a0,*a8(OCTRL)
;	rets
;

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
* sets which player is controlling each team
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


RGB	.macro	R,G,B
	.word	(:R:<<10) | (:G:<<5) | :B:
	.endm

#nampal
	.word	4		;4 colours

	RGB	0,0,0		;background
	RGB	2,3,12		;dark
	RGB	12,0,0		;light
	RGB	0,0,0		;black


****************************************************************
****************************************************************
 SUBR	start_teams

	clr	a0
	move	a0,@IRQSKYE		;background color

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

;build new background

	movi	wipe_horz_stag_dwn,a0,L
	movi	CREATE_NO_DEL_OBJS,a14		;dont delete objs. when done
	JSRP	do_scrn_transition

	SLEEPK	1

	calla	KILBGND			;Kill all old background objs
	clr	a0
	movi	-1,a1
	calla	obj_delc
	calla	pal_clean

	movi	CYCPID,a0
	calla	KIL1C

	movi	subsitution_mod,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#sub2
	movi	subsitution_kit_mod,a0
#sub2	move	a0,@BAKMODS,L
	calla	BGND_UD1

	SLEEPK	1


;;Just in case someone bought in during game play, and teamx_control had not
;;been set!
;
;	move	@team1_control,a0
;	jrn	#no1
;	move	@PSTATUS,a1
;	btst	a0,a1
;	jrnz	#tm1ok
;#no1
;	move	@PSTATUS,a0
;	btst	0,a0
;	jrz	#nop1
;	clr	a0
;	move	a0,@team1_control
;	jruc	#tm1ok
;#nop1
;	move	@PSTATUS,a0
;	btst	1,a0
;	jrz	#nop2
;	movk	1,a0
;	move	a0,@team1_control
;	jruc	#tm1ok
;#nop2
;	movi	-1,a0
;	move	a0,@team1_control
;#tm1ok
;	move	@team2_control,a0
;	jrn	#no2
;	move	@PSTATUS,a1
;	btst	a0,a1
;	jrnz	#team2_ok
;#no2
;	move	@PSTATUS,a0
;	btst	2,a0
;	jrz	#nop3
;	movk	2,a0
;	move	a0,@team2_control
;	jruc	#tm2ok
;#nop3
;	move	@PSTATUS,a0
;	btst	3,a0
;	jrz	#nop4
;	movk	3,a0
;	move	a0,@team2_control
;	jruc	#team2_ok
;#nop4
;	movi	-1,a0
;	move	a0,@team2_control
;#tm2ok

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
	movk	19,a0
	calla	RNDRNG0

	move	@team1,a14
;This is the check for those teams who didn't have 5 players per team
;	cmpi	_DAL,a14
;	jrz	#bigd
;	cmpi	_PHI,a14
;	jrz	#bigd

	sll	4,a14
	addi	tm1set,a14
	move	a0,*a14
#bigd
	clr	a8
	CREATE0	cpu_subs

#noscrambl
	move	@team2_control,a0
	jrnn	#noscrambl2
	movk	19,a0
	calla	RNDRNG0
	move	@team2,a14

;This is the check for those teams who didn't have 5 players per team
;	cmpi	_DAL,a14
;	jrz	#bigd1
;	cmpi	_PHI,a14
;	jrz	#bigd1

	sll	4,a14
	addi	tm2set,a14
	move	a0,*a14
#bigd1
	movk	1,a8
	CREATE0	cpu_subs

#noscrambl2
	CREATE0	credits3

	movi	[175,0],a0		;x val
	movi	[238,0],a1		;y val
	movi	CREDTOOB,a2
	movi	2700,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2

	movk	2,a0
	calla	create_title_bar
	calla	print_subsitution_title
	calla	print_subsitution_directions
	
	clr	a0
	calla	create_player_head_backdrops
	movk	2,a0
	calla	create_logos
	movk	2,a0
	calla	create_player_heads
	calla	create_player_names

	calla	update_logos
	calla	update_player_heads
	calla	update_player_names

;	callr	hide_ball_under_logo

	movk	1,a0
	move	a0,@in_team_select
	move	a0,@fixbug
	move	a0,@in_team_subs

	movi	-1,a0
	move	a0,@p1_hide_atts
	move	a0,@p2_hide_atts
	move	a0,@p3_hide_atts
	move	a0,@p4_hide_atts

	clr	a0
	move	a0,@exit_status
	move	a0,@force_selection

;;	CREATE0	team_control		;determine which plyr control joystick
	CREATE0	team1_team_select
	CREATE0	team2_team_select

	SLEEPK	6

	movi	un_wipe_horizontal,a0,L
	movi	NO_CREATE_DEL_OBJS,a14
	JSRP	do_scrn_transition

	SLEEPK	1

;what the hell !!!
	movi	DMAWNZ,a0
	movi	OBJLST,a1
	jruc	so20
so10	move	a0,*a1(OFLAGS)
so20	move	*a1,a1,L
	jrnz	so10

	JSRP	subs_in

	clr	a0
	move	a0,@in_team_subs

	.ref	kill_flsh_txt_proc
	calla	kill_flsh_txt_proc

;	movi	HIT_PTS_FRACTION,a0,L
;	calla	obj_del1c			;delete instructions

	calla	setup_speech
	calla	set_names
	RETP

****************************************************************
*
* this is a cheat, cause I dont want to change a bunch of code
* so i just put the logo backdrops offscreen!!
*
****************************************************************
 SUBR	hide_ball_under_logo

	move	@logo1_obj+20h,a0,L
	move	*a0(OXPOS),a14
	addi	400,a14
	move	a14,*a0(OXPOS)
 	
	move	@logo2_obj+20h,a0,L
	move	*a0(OXPOS),a14
	addi	400,a14
	move	a14,*a0(OXPOS)
	rets


;----------- TABLES ------------
;----------- TABLES ------------
;----------- TABLES ------------
;----------- TABLES ------------


******************************************************************************
	.asg	16,X		;distance in X
	.asg	24,Y	;22	;distance in Y (from UPPER LFT CRNR of IMG)

name_table
   .word  5,5*6		;width, width * height in letters
   	;img, xoff, yoff
   .word  01,2,000, 02,X*1,000, 03,X*2,000,   04,X*3,000,   05,X*4,000	 ;abcde
   .word  06,2,Y*1, 07,X*1,Y*1, 08,X*2+1,Y*1, 09,X*3+4,Y*1, 10,X*4+1,Y*1 ;fghij
   .word  11,2,Y*2, 12,X*1+2,Y*2, 13,X*2-3,Y*2, 14,X*3,Y*2, 15,X*4,Y*2   ;klmno
   .word  16,2,Y*3, 17,X*1+1,Y*3, 18,X*2+1,Y*3, 19,X*3+1,Y*3,20,X*4,Y*3	 ;pqrst
   .word  21,2,Y*4, 22,X*1-1,Y*4, 23,X*2-2,Y*4, 24,X*3+2,Y*4,25,X*4+1,Y*4	;uvwxy
   .word  26,2,Y*5, 27,X*1+3,Y*5, 28,X*2,Y*5,   29,X*3,Y*5,  30,X*4-1,Y*5	;z! <END
   .word  -1

;   .word  00,2,000,  01,X*1,000, 02,X*2,000,   03,X*3,000,   04,X*4,000	;abcde
;   .word  05,2,Y*1,  06,X*1,Y*1, 07,X*2+1,Y*1,   08,X*3+4,Y*1, 09,X*4+1,Y*1	;fghij
;   .word  10,2,Y*2,  11,X*1+2,Y*2, 12,X*2-3,Y*2, 13,X*3,Y*2,   14,X*4,Y*2  ;klmno
;   .word  15,2,Y*3,  16,X*1+1,Y*3, 17,X*2+1,Y*3,   18,X*3+1,Y*3,   19,X*4,Y*3	;pqrst
;   .word  20,2,Y*4,  21,X*1-1,Y*4, 22,X*2-2,Y*4,   23,X*3+2,Y*4,   24,X*4+1,Y*4	;uvwxy
;   .word  25,2,Y*5,  26,X*1+3,Y*5, 27,X*2,Y*5,   28,X*3,Y*5,   29,X*4-1,Y*5	;z! <END


******************************************************************************
	.asg	25,X
	.asg	23,Y	;22

name_table2			;2 PLAYER KIT
   .word  5,5*6		;width, size
      ;img, xoff, yoff							 
   .word  01,2,000, 02,X*1,000,  03,X*2,000,   04,X*3,000,   05,X*4,000	   ;abcde
   .word  06,2,Y*1, 07,X*1,Y*1,  08,X*2+1,Y*1, 09,X*3+4,Y*1, 10,X*4+1,Y*1  ;fghij
   .word  11,2,Y*2, 12,X*1+2,Y*2,13,X*2-3,Y*2, 14,X*3,Y*2,   15,X*4,Y*2    ;klmno
   .word  16,2,Y*3, 17,X*1+1,Y*3,18,X*2+1,Y*3, 19,X*3+1,Y*3, 20,X*4,Y*3	   ;pqrst
   .word  21,2,Y*4, 22,X*1-1,Y*4,23,X*2-2,Y*4, 24,X*3+2,Y*4, 25,X*4+1,Y*4  ;uvwxy
   .word  26,2,Y*5, 27,X*1+3,Y*5,28,X*2,Y*5,   29,X*3+1,Y*5, 30,X*4,Y*5	   ;z! <END
   .word  -1

;
; Change to account for PIN NUMBER logic
;
	.asg	7,X
	.asg	22,Y
pin_nbr_table
	.word	3,3*4			;width, size (rows*columns)
	;img (offset into alpha_table), xoff, yoff
	.word	34,1*X+8,0*Y,	35,2*X+24,0*Y,	36,3*X+40,0*Y	;0,1,3
	.word	37,1*X+10,1*Y,	38,2*X+24,1*Y,	39,3*X+40,1*Y	;3,4,5
	.word	40,1*X+10,2*Y,	41,2*X+24,2*Y,	42,3*X+40,2*Y  	;6,7,8
	.word	43,1*X+9,3*Y,   29,2*X+22,3*Y,  28,3*X+39,3*Y 	;9,SPC,BCK
	.word	-1

	.asg	15,X
	.asg	22,Y
pin_nbr_table2			;KIT version
	.word	3,3*4			;width, size (rows*columns)
	;img (offset into alpha_table), xoff, yoff
	.word	34,1*X+8,0*Y,	35,2*X+24,0*Y,	36,3*X+40,0*Y	;0,1,3
	.word	37,1*X+10,1*Y,	38,2*X+24,1*Y,	39,3*X+40,1*Y	;3,4,5
	.word	40,1*X+10,2*Y,	41,2*X+24,2*Y,	42,3*X+40,2*Y  	;6,7,8
	.word	43,1*X+9,3*Y,   29,2*X+21,3*Y,  28,3*X+39,3*Y 	;9,SPC,BCK
	.word	-1


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;fonts for menu setup only (not echoed input)
alpha_table
	.long	0
	.long	INGA16_A,INGA16_B,INGA16_C,INGA16_D,INGA16_E,INGA16_F,INGA16_G,INGA16_H		;1-8
	.long	INGA16_I,INGA16_J,INGA16_K,INGA16_L,INGA16_M,INGA16_N,INGA16_O,INGA16_P		;9-16
	.long	INGA16_Q,INGA16_R,INGA16_S,INGA16_T,INGA16_U,INGA16_V,INGA16_W,INGA16_X		;17-24
	.long	INGA16_Y,INGA16_Z,INGA16EXC,INGA16DEL,INGA16SPC,INGA16END,0,0			;25-32
	.long	INGA16DEL,INGA16_0,INGA16_1,INGA16_2,INGA16_3,INGA16_4,INGA16_5,INGA16_6	;33-40
	.long	INGA16_7,INGA16_8,INGA16_9,0,0,0,0,0						;41-48

;smaller font for echoed input (when entering name and pin number)
alpha_table2
	.long	0
	.long	BAST10_A,BAST10_B,BAST10_C,BAST10_D,BAST10_E,BAST10_F,BAST10_G,BAST10_H		;1-8
	.long	BAST10_I,BAST10_J,BAST10_K,BAST10_L,BAST10_M,BAST10_N,BAST10_O,BAST10_P		;9-16
	.long	BAST10_Q,BAST10_R,BAST10_S,BAST10_T,BAST10_U,BAST10_V,BAST10_W,BAST10_X		;17-24
	.long	BAST10_Y,BAST10_Z,BAST10EXC,BAST10DSH,BAST10SPC,BAST10DSH,0,0			;25-32
	.long	0,INGA16SUB,INGA16SUB,INGA16SUB,INGA16SUB,INGA16SUB,INGA16SUB,INGA16SUB		;33-40
	.long	INGA16SUB,INGA16SUB,INGA16SUB,INGA16SUB,INGA16SUB,0,0,0				;41-48


;fatal_tbl
;	.word	1		;ATLANTA	(96)
;	.word	1		;BOSTON		(103)
;	.word	1		;CHARLOTTE
;	.word	0		;CHICAGO
;	.word	1		;CLEVELAND
;	.word	1		;DALLAS		(117)
;	.word	1		;DENVER
;	.word	0		;DETROIT
;	.word	1		;GOLDEN STATE	(110)
;	.word	0		;HOUSTON
;	.word	1		;INDIANA
;	.word	1		;LOS ANGELES (CLIPPERS)
;	.word	0		;LOS ANGELES (LAKERS)
;	.word	1		;MIAMI
;	.word	0		;MILWAUKEE
;	.word	1		;MINNESOTA
;	.word	0		;NEW JERSEY
;	.word	0		;NEW YORK
;	.word	0		;ORLANDO
;	.word	1		;PHILADELPHIA
;	.word	1		;PHOENIX
;	.word	0		;PORTLAND
;	.word	0		;SACRAMENTO
;	.word	1		;SAN ANTONIO
;	.word	0		;SEATTLE
;	.word	0		;UTAH		(122)
;	.word	1		;WASHINGTON


#*****************************************************************************
player1_menus
	.long	#p1m1
	.long	#p1m2

#p1m1
	.word	0			;palette
	.word	0+17,30+NAMENT_PAGE-4	;x,y start
	.long	name_table		;table
#p1m2
	.word	0			;palette
	.word	0+9,54+NAMENT_PAGE	;x,y start
	.long	pin_nbr_table

#************
player1k_menus
	.long	#p1m1k
	.long	#p1m2k
#p1m1k
	.word	0				;palette
	.word	0+16+36,30+NAMENT_PAGE-4	;x,y start
	.long	name_table2			;table
#p1m2k
	.word	0				;palette
	.word	0+9+38,54+NAMENT_PAGE		;x,y start
	.long	pin_nbr_table2

#************
player2_menus
	.long	#p2m1
	.long	#p2m2
#p2m1
	.word	1			;palette
	.word	100+13,30+NAMENT_PAGE-4	;x,y start
	.long	name_table		;table
#p2m2
	.word	1			;palette
	.word	100+7,54+NAMENT_PAGE	;x,y start
	.long	pin_nbr_table

*************
player3_menus
	.long	#p3m1
	.long	#p3m2
#p3m1
	.word	2			;palette
	.word	200+11,30+NAMENT_PAGE-4	;x,y start
	.long	name_table
#p3m2
	.word	2			;palette
	.word	200+4,54+NAMENT_PAGE	;x,y start
	.long	pin_nbr_table

*************
player2k_menus
	.long	#p2m1k
	.long	#p2m2k
#p2m1k
	.word	2				;palette
	.word	200+10+32,30+NAMENT_PAGE-4	;x,y start
	.long	name_table2
#p2m2k
	.word	2				;palette
	.word	200+4+36,54+NAMENT_PAGE		;x,y start
	.long	pin_nbr_table2

*************
player4_menus
	.long	#p4m1
	.long	#p4m2
;	.long	#p4m3
#p4m1
	.word	3			;palette
	.word	300+6,30+NAMENT_PAGE-4	;x,y start
	.long	name_table
#p4m2
	.word	3			;palette
	.word	300+1,54+NAMENT_PAGE	;x,y start
	.long	pin_nbr_table
;	.long	month_table
;#p4m3
;	.word	3			;palette
;	.word	300+1,30-12+NAMENT_PAGE	;x,y start
;	.long	day_table

;----------------------------------
;----------------------------------
subsitution_mod
	.long	HTIMEBMOD			;option screen background
	.word	0,0
	.long	ATRBHTBMOD
	.word	0,178		;x,y
	.long	0

subsitution_kit_mod
	.long	HTIMEBMOD			;option screen background
	.word	0,0
	.long	ATRBHTKTBMOD
;;	.long	ATRBKITBMOD			;option screen background
	.word	0,178		;x,y
	.long	0

option_screen_mod
	.long	OPTSCRBMOD			;option screen background
	.word	0,0		;x,y
	.long	ATRIBUTEBMOD			;option screen background
	.word	0,178		;x,y
	.long	0

option_screen_mod_kit
	.long	OPTSCRBMOD			;option screen background
	.word	0,0		;x,y
	.long	ATRBKITBMOD			;option screen background
	.word	0,178		;x,y
	.long	0

team_select_mod
	.long	TEAMSEL4BMOD
	.word	0,0		;x,y
;	.long	ATRIBUTEBMOD			;option screen background
;	.word	0,178		;x,y
	.long	0

team_select_mod_kit
	.long	TEAMSEL4BMOD
	.word	0,0		;x,y
;	.long	ATRBKITBMOD			;option screen background
;	.word	0,178		;x,y
	.long	0

name_entry_mod
	.long	ENTER4BMOD
	.word	0,0		;x,y
;	.long	ATRIBUTEBMOD			;option screen background
;	.word	0,178		;x,y
	.long	0

name_entry_mod_kit
	.long	ENTERKITBMOD
	.word	0,0		;x,y
;	.long	ATRBKITBMOD			;option screen background
;	.word	0,178		;x,y
	.long	0


******************************************************************************
	.end




