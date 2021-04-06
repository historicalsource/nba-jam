;-----------------------------------------------------------------------------
*
* Owner:	JOHNSON
*
; Software:	Jeff Johnson
; Initiated:	5-20-95
;
; COPYRIGHT (C) 1995 WILLIAMS ELECTRONICS GAMES, INC.
;
;.Last mod - 6/30/95 
;-----------------------------------------------------------------------------
	.file	"makeplr.asm"
	.title	"create player logic"
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"game.equ"
	.include	"world.equ"
	.include	"audit.equ"
	.include	"macros.hdr"

	.include	"plyrmake.tbl"

	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"imgtblp.glo"
	.include	"bgndtbl.glo"
	.include	"privlg.tbl"

	.asg		0,SEQT
	.include	"plyr.equ"


	.global	player1_data,player2_data,player3_data,player4_data

	.def	SENDTO,ENTRIES
	.def	OVRTME
	.def	design_player
	.def	speed_points
	.def	power_points
	.def	shoot_points
	.def	dunks_points
	.def	steal_points
	.def	block_points
	.def	height_points
	.def	weight_points
	.def	total_points
	.def	butn_cursor_pos
	.def	dither_objs,dither_objs2
	.def	clock_minutes,clock_seconds
	.def	done_creating			;exit flag for CREATE PLAYER
	.def	fog_obj_ptr
	.def	yes_no_buttons_ptr
	.def	restart_clock_timer,stop_clock_timer
	.def	stop_clock
	.def	p1_slide_box_flag,p2_slide_box_flag
	.def	p3_slide_box_flag,p4_slide_box_flag
	.def	joy_pos
	.def	select_arrow_obj
	.def	HIDEAT
    
	.ref	NBALL601

	.ref	create_plr_mugshots_tbl,create_plr_mugshots_tbl_end
	.ref	create_down_arrow,create_up_arrow
	.ref	create_rght_arrow,create_left_arrow
	.ref	NUM_NICK_NAMES,GAMSTATE
	.ref	NUM_UNIFORM_NAMES
	.ref	flash_pressed_yes_no_button
	.ref	create_plyr	    ;-1=can't create plyr, 0=could, 1=creating
	.ref	scale74f_t,scale59_t,scale61f_t,scale63f_t
	.ref	scale57_t,scale58_t,scale60_t,scale61_t,scale61t_t,scale62_t
	.ref	scale62t_t,scale63_t,scale65_t,scale64t_t,scale64_t,scale67_t
	.ref	scale66_t,scale65t_t,scale67t_t,scale66t_t,scale65f_t
	.ref	scale67f_t,scale66f_t,scale69_t,scale69f_t,scale68f_t
	.ref	scale68t_t,scale68_t,scale611_t,scale610_t,scale611t_t
	.ref	scale610t_t,scale611f_t,scale610f_t,scale70t_t,scale70f_t
	.ref	scale70_t,scale71_t,scale72_t,scale76et_t,scale74_t,scale72f_t
	.ref	scalebighead_t
	.ref	plr_heads_small,plr_heads_small_end
	.ref	create_arrow_and_text_bar

	.ref	HIDER1_P,OVERW_P
	.ref	create_pick_head_objs
	.ref	create_yes_no_buttons
	.ref	create_fog_image
	.ref	turn_off_name_objs
;	.ref	show_players_name
	.ref	create_name_objs
	.ref	create_information_box
	.ref	create_title_bar
	.ref	create_time_box
	.ref	create_dithering_patterns
	.ref	create_stats_area
	.ref	timedown_clock
	.ref	PSTATUS,IRQSKYE
	.ref	create_credit_plate,print_title
	.ref	del_select_arrow,clr_select_arrow_ram
	.ref	DEFAULT_t
	.ref	SM_HEADS_CNT
	.ref	nickname_img_tbl

	.ref	do_scrn_transition
	.ref	CREATE_DEL_OBJS,CREATE_NO_DEL_OBJS
	.ref	NO_CREATE_DEL_OBJS,NO_CREATE_NO_DEL_OBJS

	.ref	KILBGND,WIPEOUT,update_statbox_images
	.ref	pal_clean,amode_start,show_player_records
	.ref	BAKMODS,BGND_UD1
	.ref	scrnrel_off,print_string_C2
	.ref	mess_line_spacing,mess_objid
	.ref	setup_message
	.ref	delete_text
	.ref	dpageflip,dtype
	.ref	get_but_val_cur
	.ref	get_but_val_down
	.ref	get_stick_val_cur
	.ref	get_stick_val_down
	.ref	pal_getf,obj_on,obj_off
	.ref	pal_set
	.ref	button_actions
	.ref	get_player_record,get_free_record,put_plr_record
	.ref	move_cursor,update_cursor
	.ref	save_selection
	.ref	pin_nbr_table,name_table
	.ref	force_selection
	.ref	create_menu
	.ref	update_yes_no_button_pals
	.ref	print_name,delete_name

	.ref	print_goodbye_msg
	.ref	print_player_stats
	.ref	body_scale_table
	.ref	del_butn_info_text,del_butn_box_stuff
	.ref	print_butn_information
	.ref	print_body_dimensions
;	.ref	print_players_name
	.ref	create_a9_butn_instructions
	.ref	create_butn_instructions
	.ref	print_record_availablity_msg
	.ref	create_and_watch_credits
	.ref	bast8t_ascii,bast8tcyc_ascii
	.ref	wipe_horizontal,un_wipe_horizontal
	.ref	wipe_stack_vertical,un_wipe_vertical
	.ref	create_divider_bar
	.ref	create_small_yes_no_butns
	.ref	create_pin_nbr_objs
	.ref	print_privileges_info
	.ref	create_nick_names
	.ref	del_nick_names
	.ref	del_uniform_names,create_uniform_names
	.ref	mess_cursx,mess_cursy,message_ascii,message_palette
	.ref	message_buffer,mess_space_width,mess_objid
	.ref	dec_to_asc,concat_string,concat_rom_string,print_string_C
	.ref	get_all_records,sort_wins

	.ref	ply_city_tbl
	.ref	PLYRAT_TBL_SIZE
	.ref	ltshoepal_t
	.ref	plyrpals_t

	.ref	del_clock_objs
	.ref	scalehead_t
	
	.ref	plyr_headalign2,anipt2_getsclxy
	.ref	anipt_getsclxy
	.ref	yes_no_cur1,yes_no_cur2,yes_no_cur3,yes_no_cur4
	.ref	yes_no_sel1,yes_no_sel2,yes_no_sel3,yes_no_sel4
	.ref	cursor_up,cursor_dwn,cursor_lft,cursor_rgt
	.ref	cursor_up2,cursor_dwn2,cursor_lft2,cursor_rgt2
	.ref	cursor_up3,cursor_dwn3
	.ref	butn_press,butn_press2
	.ref	reset_yes_no_butn_pals

	.ref	atrib_snd1,atrib_snd2,atrib_snd3,atrib_snd4,atrib_snd5
	.ref	atrib_snd6,atrib_snd7,atrib_snd8,atrib_snd9,atrib_snd10
	.ref	dribble2_snd
	.ref	unchkmrk_snd,chkmrk0_snd,bounce_snd
	.ref	print_changed_name_info
	.ref	tuneend_snd,tune_cap_snd
	.ref	AUD1
	.ref	print_ask_chg_nme
	.ref	print_ask_exit
	.ref	plr_flesh_pal_tbl
	.ref	no_sp
	.ref	CYCLE_TABLE,BASTC_W_P
	.ref	diag_cursor
	.ref	nub_img_tbl
	.ref	SENDTO_P


	.bss	plyr_drib_cnt,16
	.bss	bball_plr_obj,32
;dont change order
	.bss	clock_minutes,16
	.bss	clock_seconds,16
;dont change order
	.bss	butn_cursor_pos,16
	.bss	joy_pos,16
	.bss	butn_objs,32*NUM_BUTTONS		;6 butns on screen
	.bss	butn_shadow_objs,(32*NUM_BUTTONS)*2    ;2 pieces for shadow
	.bss	butn_text_objs,32*NUM_BUTTONS
	.bss	butn_press_objs,32*NUM_BUTTONS
	.bss	butn_press_shadow_objs,(32*NUM_BUTTONS)*2  ;2 pieces for shadow
	.bss	butn_press_text_objs,32*NUM_BUTTONS
	.bss	repeat_cnt,16
	.bss	repeat_rate,16


	.bss	speed_points,16			;0-10 attribute amount
	.bss	power_points,16			;0-10 attribute amount
	.bss	shoot_points,16			;0-10 attribute amount
	.bss	dunks_points,16			;0-10 attribute amount
	.bss	steal_points,16			;0-10 attribute amount
	.bss	block_points,16			;0-10 attribute amount
	.bss	height_points,16		;0-10
	.bss	weight_points,16		;0-10
	.bss	total_points,16			;MAXIUM hit points
	.bss	check_marks,16
	BSSX	nick_name_nbr,16
	BSSX	uniform_nbr,16

	.bss	big_attrib_bar_objs,((32*2)*NUM_ATTRIBS) ;left half/right half
	.bss	big_attrib_meter_objs,32*NUM_ATTRIBS
	.bss	plyr_attrib_meter_objs,32*6
	.bss	attrib_cur_pos,16
	.bss	prev_attrib_cur_pos,16
	.bss	processing_butn,16		;1=performing butn action
	.bss	select_arrow_obj,32
	.bss	plyr_head_objs,32*NUM_HEADS	;5 visable heads
	.bss	plyr_big_head_obj,32		;1 big heads
	.bss	plyr_dribble_head_obj,32
	.bss	plyr_ball_obj,32		;ptr. to dribbling basketball
	.bss	player_record_ptr,32
	.bss	done_creating,16		;exit flag
	.bss	changing_name,16
	.bss	prev_butn_cur_pos,16
	.bss	blink_cnt,16
	.bss	dither_objs,32*4
	.bss	dither_objs2,32*4
	.bss	fog_obj_ptr,32
	.bss	yes_no_buttons_ptr,32*2
	.bss	stop_clock,16			;1=yes, 0=no
	.bss	p1_slide_box_flag,16
	.bss	p2_slide_box_flag,16
	.bss	p3_slide_box_flag,16
	.bss	p4_slide_box_flag,16
	.bss	priv_cur_pos,16
	.bss	plyr_head_nbr,16
	.bss	privileges,16			;each bit = privilege
	.bss	home_team,16


REPEAT_RATE	equ	3
NOT_IN_HURRY	equ	1
SCALE_FCTR_NBR	equ	30*64
PLYR_X		equ	330
PLYR_Y		equ	162
GROUND_Y	equ	PLYR_Y+3	;6'8" guy
HAND_Y		equ	PLYR_Y-47	;6'8" guy
FIFTH_HEAD	equ	5*32

	.text


;-----------------------------------------------------------------------------
;    This is the ENTRY POINT for the CREATE PLAYER option (at game start)
;-----------------------------------------------------------------------------
 SUBR	design_player

;;	movi	player1_data,a6,L
;;	JSRP	show_player_records

	movi	INPLYRDESIGN,a0
	move	a0,@GAMSTATE
	movk	1,a0				;set cause must wait for plyr
	move	a0,@done_creating		;exit flag (1=dont exit, 0=exit)

	movi	AUD_CREATED_PLR,a0		;log it
	calla	AUD1

;setup new background
	movi	wipe_stack_vertical,a0,L
	movi	CREATE_NO_DEL_OBJS,a14		;dont delete objs. when done
	JSRP	do_scrn_transition
	SLEEPK	1

	clr	a0
	movi	-1,a1
	calla	obj_delc
	calla	pal_clean
	clr	a0				;kill all processes
	clr	a1				;kill all processes
	calla	KILALL
	calla	KILBGND				;Kill old background

	calla	get_all_records
	calla	sort_wins

	CREATE0	design_player_proc

dp_1	SLEEPK	1
	move	@done_creating,a0		;exit flag (0=exit)
	jrnz	dp_1

;save players editing information in record
	calla	save_ram_to_player_record

	movi	player1_data,a6,L
	move	@player_record_ptr,a10,L
	calla	put_plr_record

;in case timed out!
	callr	del_butn_box_stuff
 	callr	del_butn_info_text
	callr	del_select_arrow
	callr	del_privilege_bars
	callr	del_check_marks
	callr	del_uniform_names
	calla	del_nick_names
	callr	del_hit_points_fraction
;	calla	del_clock_objs
	callr	kill_flsh_txt_proc

	movi	CYCPID,a0
	calla	KIL1C

	movi	TYPTEXT|SUBPL1,a0
	calla	obj_del1c			;delete all objs with this ID
	movi	TYPTEXT|SUBPL1,a0
	ori	10h,a0				;object	ID
	calla	obj_del1c			;delete all objs with this ID

	SLEEPK	1

	JSRP	print_goodbye_msg

	SOUND1	tuneend_snd
	RETP


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	design_player_proc

	move	@PSTATUS,a1
	cmpi	1,a1			;player 1 ?
	jreq	gpn_1			;br=yep
	inc	a0			;assume player 2
	cmpi	2,a1			;player 2 ?
	jreq	gpn_1			;br=yep
	inc	a0			;assume player 3
	cmpi	4,a1			;player 3 ?
	jreq	gpn_1			;br=yep
	inc	a0			;assume player 4
gpn_1	move	a0,*a13(PC_PLAYNUM)

	clr	a0
	move	a0,@IRQSKYE		;BLACK background color

	movi	create_player_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1
	calla	create_credit_plate

	SOUND1	tune_cap_snd

	CREATE0	create_and_watch_credits

	clr	a0
	move	a0,@butn_cursor_pos
	move	a0,@joy_pos
	move	a0,@changing_name

	PUSH	a12
	calla	create_normal_buttons
	calla	update_button_palettes
	calla	update_button_shadow_palettes
	PULL	a12

	clr	a0
	calla	create_title_bar
	calla	print_title

	calla	create_information_box
	calla	create_stats_area
	calla	create_dithering_patterns
	calla	create_fog_image

	CREATE	CLOCK_PID,timedown_clock

	move	*a13(PC_PLAYNUM),a10
	JSRP	enter_game_name

	SLEEPK	1

	movk	10,a9
	callr	create_a9_butn_instructions	;print 'CHOOSE OPTION'
	calla	print_butn_information		;information about butn in box

	calla	update_button_palettes
	calla	update_button_shadow_palettes
;
; Main button cursor control loop
;         Read joystick
;
redj_1
	SLEEPK	1
	move	@done_creating,a0		;exit CREATE PLAYER...yet
	jrz	but_3

	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_cur		;ret. a0=joy switch value
	cmpi	JOY_NONE,a0			;joytick movement ?
	jreq	ckj_1				;br=nope

	move	@joy_pos,a14
	cmp	a14,a0
	jrne	ckj_1

	move	@repeat_cnt,a1
	inc	a1
	move	a1,@repeat_cnt
	cmpi	REPEAT_DELAY/2,a1		;repeat yet ?
	jrls	jndn_1				;br=no

;okay, now we can check the joystick

ckj_1
	move	a0,@joy_pos
	clr	a1
	move	a1,@repeat_cnt		;reset repeat count

	cmpi	JOY_UP,a0			;joystick up ?
	jrne	jnup_1				;br=nope
	move	@butn_cursor_pos,a0
	dec	a0
	jrnn	jr_1
	movk	NUM_BUTTONS-1,a0			;reset cursor position
jr_1	move	a0,@butn_cursor_pos
	SOUND1	cursor_up
	jruc	jbut_1				;now check button states

jnup_1	cmpi	JOY_DOWN,a0			;joystick down ?
	jrne	jndn_1				;br=nope
	move	@butn_cursor_pos,a0
	inc	a0
	cmpi	NUM_BUTTONS,a0			;number of butns
	jrlo	jr_2
	clr	a0				;reset cursor position
jr_2	move	a0,@butn_cursor_pos
	SOUND1	cursor_dwn

jbut_1
	calla	update_button_palettes		;only update when move
	calla	update_button_shadow_palettes
	calla	print_butn_information		;information about butn in box
jndn_1
	calla	maybe_change_button_palette	;blinks the current button
;
; Read buttons
;
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down

	cmpi	TURBO_BUTTON,a0
	jreq	but_1
	cmpi	PASS_BUTTON,a0
	jreq	but_1
	cmpi	SHOOT_BUTTON,a0
	jrne	redj_1				;br=no joystick or buttons
;
; Call action routine for button (based on table)
;
but_1
	SOUND1	butn_press

	CREATE0	fade_button_pals
	callr	del_butn_box_stuff
 	calla	del_butn_info_text
	calla	create_butn_instructions

	move	@butn_cursor_pos,a0		;get hi-lited butn nbr.
	sll	5,a0				;mult. by 32 (index into tbl)
	addi	butn_routine_table,a0		;point at routine
	move	*a0,a0,L			;get routine addr.
	JSRPR	a0

	SOUND1	butn_press2

	move	@done_creating,a0		;exit CREATE PLAYER...
	jrz	but_3				;br=yep

	movk	10,a9
	callr	create_a9_butn_instructions	;print 'CHOOSE OPTION'
	calla	print_butn_information		;information about butn in box
	jruc	redj_1
but_3	
	DIE


;-----------------------------------------------------------------------------
; called when SAVE & EXIT
;-----------------------------------------------------------------------------
 SUBR	save_ram_to_player_record

	movi	player1_data,a6,L
	move	@total_points,a0
	move	a0,*a6(PR_TOTAL_PTS)
	move	@height_points,a0
	move	a0,*a6(PR_HEIGHT_PTS)
	move	@weight_points,a0
	move	a0,*a6(PR_WEIGHT_PTS)
	move	@speed_points,a0
	move	a0,*a6(PR_SPEED_PTS)
	move	@power_points,a0
	move	a0,*a6(PR_POWER_PTS)
	move	@shoot_points,a0
	move	a0,*a6(PR_SHOOT_PTS)
	move	@dunks_points,a0
	move	a0,*a6(PR_DUNKS_PTS)
	move	@steal_points,a0
	move	a0,*a6(PR_STEAL_PTS)
	move	@block_points,a0
	move	a0,*a6(PR_BLOCKS_PTS)

	move	@plyr_head_nbr,a0
	addi	MIDDLE_HEAD,a0
	cmpi	SM_HEADS_CNT,a0
	jrlo	nok_0
	subi	SM_HEADS_CNT,a0
nok_0	move	a0,*a6(PR_HEAD_NBR)

	move	@nick_name_nbr,a0
	addi	MIDDLE_NICK_NAME,a0
	cmpi	NUM_NICK_NAMES,a0			;nbr of attributes to adjust
	jrlo	nok_1
	subi	NUM_NICK_NAMES,a0			;nbr of attributes to adjust
nok_1	move	a0,*a6(PR_NICKNAME_NBR)

	move	@uniform_nbr,a0
	addi	MIDDLE_UNIFORM_NBR,a0
	cmpi	NUM_UNIFORM_NAMES,a0			;nbr of attributes to adjust
	jrlo	nok_2
	subi	NUM_UNIFORM_NAMES,a0
nok_2
	move	@home_team,a14
	jrz	nok_2a				;br=away team
	xori	40h,a0				;set home team bit
nok_2a
	move	a0,*a6(PR_UNIFORM_NBR)

	move	@privileges,a0
	move	a0,*a6(PR_PRIVILEGES)
 	rets

;-----------------------------------------------------------------------------
; called when FOUND record...
;
;
; INPUT: a6 = ptr. to player_data
;-----------------------------------------------------------------------------
 SUBR	init_player_ram_from_record

	move	*a6(PR_CREATED_PLYR),a0		;created this player ?
	jrnz	ipr_0				;br=yep
	movk	1,a0
	move	a0,*a6(PR_CREATED_PLYR)		;creating this player
	calla	init_player_ram			;set ram defaults
	jruc	ipr_1

ipr_0	move	*a6(PR_TOTAL_PTS),a0
	move	a0,@total_points
	move	*a6(PR_HEIGHT_PTS),a0
	move	a0,@height_points
	move	*a6(PR_WEIGHT_PTS),a0
	move	a0,@weight_points		;this one moves by 2's
	move	*a6(PR_SPEED_PTS),a0
	move	a0,@speed_points
	move	*a6(PR_POWER_PTS),a0
	move	a0,@power_points
	move	*a6(PR_SHOOT_PTS),a0
	move	a0,@shoot_points
	move	*a6(PR_DUNKS_PTS),a0
	move	a0,@dunks_points
	move	*a6(PR_STEAL_PTS),a0
	move	a0,@steal_points
	move	*a6(PR_BLOCKS_PTS),a0
	move	a0,@block_points

	move	*a6(PR_HEAD_NBR),a0
	subi	MIDDLE_HEAD,a0
	jrge	ipr_00
	addi	SM_HEADS_CNT,a0
ipr_00	move	a0,@plyr_head_nbr

	move	*a6(PR_NICKNAME_NBR),a0
	subi	MIDDLE_NICK_NAME,a0
	jrge	ipr_0a
	addi	NUM_NICK_NAMES,a0			;nbr of attributes to adjust
ipr_0a	move	a0,@nick_name_nbr

	move	*a6(PR_UNIFORM_NBR),a0
	btst	6,a0					;home team ?
	jrz	ipr_0b
	andni	40h,a0					;clr home team bit
	movk	1,a14
	move	a14,@home_team
ipr_0b
	subi	MIDDLE_UNIFORM_NBR,a0
	jrge	ipr_0c
	addi	NUM_UNIFORM_NAMES,a0			;nbr of attributes to adjust
ipr_0c	move	a0,@uniform_nbr

	move	*a6(PR_PRIVILEGES),a0
	move	a0,@privileges
ipr_1 	rets

;-----------------------------------------------------------------------------
; This routine sets the players record to default values...
; called when record NOT FOUND
;
; INPUT: a6=ptr. to player_data
;-----------------------------------------------------------------------------
 SUBR	init_player_record_and_ram

	move	*a13(PC_DATADDR),a6,L		;start of player data

;set defaults for player RECORD
	movk	1,a0				;no games
	move	a0,*a6(PR_CREATED_PLYR)		;created this player

	clr	a0
	move	a0,*a6(PR_COUNT)		;dont count as a free record yet
	move	a0,*a6(PR_TEAMSDEF)
	move	a0,*a6(PR_PTS_SCORED)
	move	a0,*a6(PR_PTS_ALLOWED)
	move	a0,*a6(PR_WINSTREAK)
	movi	1024,a0
	move	a0,*a6(PR_LASTPLAY)


 SUBR	init_player_ram

;default attribute totals
	movk	4,a0
	move	a0,@speed_points
	move	a0,@power_points
	move	a0,@shoot_points
	move	a0,@dunks_points
	move	a0,@steal_points
	move	a0,@block_points
	movk	6,a0
	move	a0,@height_points
	movk	4,a0
	move	a0,@weight_points		;this one moves by 2's
	movi	DEFAULT_HIT_PTS,a0
	move	a0,@total_points

	clr	a0
	move	a0,@plyr_head_nbr
	move	a0,@nick_name_nbr
	move	a0,@uniform_nbr
	move	a0,@privileges
	move	a0,@home_team
	rets

;-----------------------------------------------------------------------------
;  This routine plots images having to do with the CREATE_PLAYER buttons
;    in their normal state
;-----------------------------------------------------------------------------
 SUBR	create_normal_buttons

	movi	butn_setup_table,a10,L
	movi	butn_objs,a9,L
	movi	butn_shadow_objs,a11,L
	movi	butn_text_objs,a12,L

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	BUTTON_PIECE,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
butns_1
	move	*a10+,a0,L			;X coor.
	move	*a10+,a1,L			;Y coor.

;left half of button shadow
	move	*a10+,a2,L			;ptr. to img
	movi	7,a3				;z pos (sorting)
	PUSH	a0,a1				;get coordinates
	calla	BEGINOBJ2
	PULL	a0,a1				;get coordinates
	move	a8,*a11+,L			;save obj. ptrs for shadows

;right half of button shadow
	move	*a10+,a2,L			;ptr. to img
	PUSH	a0,a1				;get coordinates
	calla	BEGINOBJ2
	PULL	a0,a1				;get coordinates
	move	a8,*a11+,L			;save obj. ptrs for shadows

;button
	move	*a10+,a2,L			;ptr. to img
	movi	10,a3				;z pos (sorting)
	movi	BUTRED_P,b0			;pal. to use for city imgs.
	PUSH	a0,a1				;get coordinates
	calla	BEGINOBJP2
	PULL	a0,a1				;get coordinates
	move	a8,*a9+,L			;save obj. ptrs to butns

;plot button text
	
	move	*a10+,a1,L			;get Y pos
	move	*a10+,a2,L			;ptr. to img
	movi	15,a3				;z pos (sorting)
	calla	BEGINOBJ2
	move	a8,*a12+,L			;save obj. ptrs for text

	cmpi	butn_setup_table_end,a10,L	;at end of table ?
	jrlo	butns_1				;br=more butns to blit
	rets

;-----------------------------------------------------------------------------
;    This routine handles the BLINKING of the currently hi-lited button
;
; called from 'button_cursor_control'
;  called roughly every 2 ticks
;-----------------------------------------------------------------------------
 SUBR	maybe_change_button_palette
 	rets

;-----------------------------------------------------------------------------
;   This PROCESS fades the buttons palettes from bright back to normal color
;-----------------------------------------------------------------------------
 SUBRP	fade_button_pals

	move	@butn_cursor_pos,a0		;get current position
	move	a0,a1
	sll	5,a0				;*32
	sll	6,a1				;*64 (2 pieces for shadow)
	addi	butn_objs,a0,L			;ptr to button objs
	addi	butn_shadow_objs,a1,L		;ptr to button shadow objs
	move	*a0,a8,L			;ptr to hi-lited button
	move	*a1+,a9,L			;ptr to left half hi-lited butn shadow
	move	*a1,a10,L			;ptr to rght half hi-lited butn shadow
	movi	butn_fade_pals,a11,L
cbp_1
	move	*a11+,a0,L
	calla	pal_getf
	move	a0,*a9(OPAL)		;change left half of button shadow pal
	move	a0,*a10(OPAL)		;change right half of button shadow pal
	move	*a11+,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)		;change button palette

	SLEEPK	2

	cmpi	butn_fade_pals_end,a11,L
	jrlo	cbp_1
	DIE

butn_fade_pals
	.long	BSGRNF5_P,BTGRNF5_P	;1st for shadow, then button itself
	.long	BSGRNF5_P,BTGRNF5_P
	.long	BSGRNF4_P,BTGRNF4_P
	.long	BSGRNF3_P,BTGRNF3_P
	.long	BSGRNF2_P,BTGRNF2_P
	.long	BSGRNF1_P,BTGRNF1_P
	.long	BSHDGRN_P,BUTGRN_P
butn_fade_pals_end

;-----------------------------------------------------------------------------
;   This routine updates the BUTTON image palettes based on cursor position
;-----------------------------------------------------------------------------
 SUBR	update_button_palettes

	clr	a3				;count of butns re-adjusted
	movi	butn_objs,a9,L			;pt. at 1st butn in array
aip_1	move	*a9+,a8,L			;ptr. to butn
	movi	BUTRED_P,a0,L
	move	@butn_cursor_pos,a2
	cmp	a3,a2			      ;is this button to-be hi-lited ?
	jrne	aip_2				;br=no, normal palette
	movi	BUTGRN_P,a0,L
aip_2	calla	pal_getf
	move	a0,*a8(OPAL)
	inc	a3
	cmpi	NUM_BUTTONS,a3
	jrlo	aip_1
	rets

;-----------------------------------------------------------------------------
;   This routine updates the buttons' shadow palette based on cursor position
;-----------------------------------------------------------------------------
 SUBR	update_button_shadow_palettes

	clr	a3				;count of buttons re-adjusted
	movi	butn_shadow_objs,a9,L		;pt. at 1st butn in array
aisp_1	move	*a9+,a8,L			;ptr. to left shadow piece
	move	*a9+,a10,L			;ptr. to rght shadow piece
	movi	BSHDRED_P,a0,L
	move	@butn_cursor_pos,a2
	cmp	a3,a2				;is this butn to-be hi-lited ?
	jrne	aisp_2				;br=no, normal palette
	movi	BSHDGRN_P,a0,L
aisp_2	calla	pal_getf
	move	a0,*a8(OPAL)
	move	a0,*a10(OPAL)
	inc	a3
	cmpi	NUM_BUTTONS,a3
	jrlo	aisp_1
	rets

;-----------------------------------------------------------------------------
;   This PROCESS does everything to do with the basketball player dribbling
;-----------------------------------------------------------------------------
 SUBR	plyr_dribbling_ball

;
; This 'CZMAX' is really an index into the current scale table. This 'Z' has
; the bball player closest to the player (Big)
;
	movi	CZMAX,a3
	movi	DMAWNZ|M_3DQ,a4
	movi	PLAYER_PIECE,a5			;object class
	clr	a6				;x vel
	clr	a7				;y vel
;
; Create player dribbling ball frame 1 (at correct SCALE)
;
	movi	[PLYR_X,0],a0			;X coor.
	movi	[PLYR_Y,0],a1			;Y coor.
	movi	W5BGDR1,a2,L
	calla	BEGINOBJ2
	move	a8,@bball_plr_obj,L
;
; Create player's head
;
	move	@plyr_head_nbr,a0
	addi	MIDDLE_HEAD,a0
	sll	5,a0
	addi	plr_heads_small,a0,L
	move	*a0,a2,L			;HEAD table ptr.
	addi	FIFTH_HEAD,a2				;pt to 5th frame
	move	*a2,a2,L				;get frame 5 from table

	movi	[346,0],a0			;x val
	movi	[70,0],a1			;y val
	calla	BEGINOBJ2
	move	a8,@plyr_dribble_head_obj,L

	callr	my_build_plr_pal		;setup default pal.
;
; Create basketball
;
	clr	a7
	movi	NBALL601,a2,L		;ball61
	movi	[300,0],a0			;X coor.
	movi	[116,0],a1			;Y coor.
	movi	CZMAX+5,a3
	calla	BEGINOBJ		;BEGINOBJP2
	move	a8,@plyr_ball_obj,L		;save ptr. to basketball

	callr	update_player_body_size

	move	@bball_plr_obj,a8,L
	move	@plyr_dribble_head_obj,a6,L
	calla	plyr_headalign2

	SLEEPK	1

	move	@bball_plr_obj,a8,L
	move	@plyr_ball_obj,a10,L
abp_0	movi	drib_seq_tbl2,a9,L

;ball setup
	calla	anipt2_getsclxy			;get BALL scaled X,Y ani. pt
	move	*a8(OXVAL),a14,L		;get PLAYER X
	add	a0,a14
	subi	60000h,a14			;move left a tad
	move	a14,*a10(OXVAL),L		;snap ball to position

	move	*a8(OYVAL),a14,L		;get PLAYER Y
	add	a1,a14
	move	a14,*a10(OYVAL),L		;snap ball to position

	callr	get_ball_vel
	move	a1,*a10(OYVEL),L

abp_1
	SLEEPK	1

	move	*a9+,a14,L			;get new frame
	move	*a14(0),*a8(OSIZE),L
	move	*a14(ISAG),*a8(OSAG),L		;next dribble frame

	move	@plyr_dribble_head_obj,a6,L
	calla	plyr_headalign2

	move	@plyr_dribble_head_obj,a6,L
	move	*a6(OXPOS),a0
	move	*a9+,a14,W			;get head offset
	add	a14,a0
	move	a0,*a6(OXPOS)

;	move	*a9+,a11,W			;get sleep time
;abp_1a
;	SLEEPK	1

	move	*a10(OIMG),a2,L
	move	*a2(IANIOFFY),a3
	move	*a10(OYPOS),a1
	move	*a10(OYVEL),a0,L
	add	a3,a1				;Y center of ball
	cmpi	GROUND_Y,a1
	jrlt	abv_grnd

	PUSH	a0
	SOUND1	dribble2_snd
	PULL	a0

	neg	a3
	addi	GROUND_Y,a3
	move	a3,*a10(OYPOS)		;Set on gnd
	neg	a0
	move	a0,a14			;75%
	sra	2,a14			;/4
	sub	a14,a0
abv_grnd
	addi	GRAVB,a0
	move	a0,*a10(OYVEL),L

;	dsj	a11,abp_1a

	move	*a9,a14,L
	jrnz	abp_1
	jruc	abp_0



	.asg	72,Y_VEL_K

;-----------------------------------------------------------------------------
;		This routine calc. the velocity for the basketball
;
; INPUT:
;	a8 - ptr. to player obj
;	a14 - y pos of player hand anim. pt.
;
; RETURN: a1 - ball velocity
;-----------------------------------------------------------------------------
 SUBR	get_ball_vel

	move	*a8(ODATA_p),a0,L

	move	*a8(OZPOS),a14
	subi	GZBASE,a14
	jrge	#zok
	clr	a14
#zok	srl	4,a14			;/16
	sll	6,a14			;*64
	add	a14,a0
	addi	48,a0			;get Y %

	move	*a0,a0
	movi	Y_VEL_K,a1
	mpys	a0,a1
;	move	@plyr_ball_obj,a14,L
;	move	a1,*a10(OYVEL),L
	rets

;
; Table contains:
;	1) player dribble image
;	2) new head offset
;
drib_seq_tbl2
;	LW	W5BGDR2, 0
;	LW	W5BGDR2, 0
;	LW	W5BGDR2, 0
	LW	W5BGDR3, 1
	LW	W5BGDR3, 1
	LW	W5BGDR3, 1
	LW	W5BGDR4, 1
	LW	W5BGDR4, 1
	LW	W5BGDR4, 1
	LW	W5BGDR5, 1
	LW	W5BGDR5, 1
	LW	W5BGDR5, 1
	LW	W5BGDR6, 1
	LW	W5BGDR6, 1
	LW	W5BGDR6, 1
	LW	W5BGDR7, 1
	LW	W5BGDR7, 1
	LW	W5BGDR7, 1
	LW	W5BGDR8, 1
	LW	W5BGDR8, 1
	LW	W5BGDR8, 1
	LW	W5BGDR9, 0
	LW	W5BGDR9, 0
	LW	W5BGDR9, 0
	LW	W5BGDR10,0
	LW	W5BGDR10,0
	LW	W5BGDR10,0
	LW	W5BGDR1, 0
	LW	W5BGDR1, 0
	LW	W5BGDR1, 0
	LW	0,0

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	stats_area_setup

	movi	115,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	PLAYER_PIECE,a5			;object class
	clr	a6				;x vel
	clr	a7				;y vel
;
; Create Stats names (attributes)
;
	movi	[292,0],a0			;x val
	movi	[206,0],a1			;y val
	movi	ATTRIBS,a2,L
	calla	BEGINOBJ2
;
; Create small Attribute meters for player dribbling ball
;
	movi	plyr_attrib_meter_objs,a10,L	;array for BAR objects
	movk	6,a11				;nbr. of bar to blit
	movi	[207,0],a1			;initial y val
bar_1	PUSH	a0,a1
	movi	[330,0],a0			;x val
	movi	ATTBAR00,a2,L
	calla	BEGINOBJ2
	move	a8,*a10+,L			;save img. ptr.
	PULL	a0,a1
	addi	[6,0],a1
	dec	a11
	jrne	bar_1
	callr	print_entered_name
	calla	print_body_dimensions
	calla	update_plyr_attrib_bar_imgs
	rets


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	print_entered_name

	movi	SBOXX+66,a0
	movi	SBOXY+2,a1
	movi	player1_data,a4
	calla	print_name			;in small font
	rets

;-----------------------------------------------------------------------------
; This routine sets the scaling factor for the players BODY and HEAD based
;  on the HEIGHT and WEIGHT attributes
;-----------------------------------------------------------------------------
 SUBRP	update_player_body_size

	PUSH	a0,a1
	move	@height_points,a0		;get current height of player
	sll	5,a0
	addi	body_scale_table,a0,L
	move	*a0,a0,L			;get scale table ptr.

	move	@weight_points,a1		;get current WEIGHT factor
	srl	1,a1				;divide by 2 (0,2,4,6,8 valid)
	sll	5,a1
	add	a1,a0
upis_2
;body
	move	@bball_plr_obj,a8,L
	move	*a0,a1,L			;get scale factor table ptr.
	move	a1,*a8(ODATA_p),L
	addi	SCALE_FCTR_NBR,a1
	move	*a1,a1,L			;get BODY scale factor
	move	a1,*a8(OSCALE),L		;scale BODY


	.ref	anipt_getsclxy
	calla	anipt_getsclxy		;get old XY ani's
	srl	16,a0
	srl	16,a1
	neg	a0
	neg	a1
	addi	PLYR_X,a0
	addi	PLYR_Y,a1
	move	a0,*a8(OXPOS),L		;scale BODY
	move	a1,*a8(OYPOS),L		;scale BODY

;head
	callr	update_player_head_size

	PULL	a0,a1
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBRP	update_player_head_size

	move	@plyr_dribble_head_obj,a0,L	;scale HEAD

	movi	scalehead_t,a1,L
	move	@privileges,a14
	btst	2,a14
	jrz	uphs_1				;br=big head not selected
	movi	scalebighead_t,a1,L

uphs_1	move	a1,*a0(ODATA_p),L
	addi	SCALE_FCTR_NBR,a1
	move	*a1,a1,L			;get HEAD scale factor
	move	a1,*a0(OSCALE),L
	rets


;-----------------------------------------------------------------------------
; action routine for button
;-----------------------------------------------------------------------------
 SUBRP	show_players_stats_cursor_cntrl

	movk	5,a0
	calla	create_divider_bar
	JSRP	print_player_stats
	calla	del_butn_info_text		;delete directions
	calla	del_butn_box_stuff
	RETP


;-----------------------------------------------------------------------------
; action routine for button
; This controls the cursor and picking head and flesh tone for body
;-----------------------------------------------------------------------------
 SUBRP	pick_plyr_head_cntrl

	callr	create_selectable_heads		;create 5 visible heads
	calla	create_pick_head_objs

	clr	a0
	move	a0,@joy_pos
	calla	clr_select_arrow_ram
	movi	REPEAT_RATE,a0				;2 ticks delay
	move	a0,@repeat_rate			;rate of auto-repeat

	callr	create_head_nbr_msg
	callr	create_head_nbr_fraction
	callr	update_selectable_heads
;
; Read joystick
;
pph_1
	SLEEPK	1

	move	@done_creating,a0
	jrz	pph_6

	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_cur		;ret. a0=joy switch value
	cmpi	JOY_NONE,a0			;joytick movement ?
	jreq	pph_1a				;br=nope

	move	@joy_pos,a14
	cmp	a14,a0
	jrne	pph_1a				;br=no auto repeat...

	move	@repeat_cnt,a1
	inc	a1
	move	a1,@repeat_cnt
	cmpi	REPEAT_DELAY,a1			;repeat yet ?
	jrls	pph_5				;br=no

	move	@repeat_rate,a14
	dec	a14
	move	a14,@repeat_rate
	jrgt	pph_5				;br=dont allow movement
	movk	REPEAT_RATE,a14
	move	a14,@repeat_rate
	jruc	pph_1b
pph_1a
	clr	a1
	move	a1,@repeat_cnt			;reset repeat count
pph_1b	move	a0,@joy_pos

;
; Left ?
; 
pph_3	cmpi	JOY_LEFT,a0		;joystick left ?
	jrne	pph_4

	move	@plyr_head_nbr,a0
	dec	a0
	jrnn	pph_3a
	movi	SM_HEADS_CNT-1,a0
pph_3a	move	a0,@plyr_head_nbr

	callr	update_selectable_heads
	callr	update_dribbling_player_head
	calla	create_left_arrow
	callr	del_hit_points_fraction
	callr	create_head_nbr_fraction
	callr	my_build_plr_pal		;setup default pal.
	SOUND1	cursor_lft
	jruc	pph_5
;
; Right ?
;
pph_4	cmpi	JOY_RIGHT,a0			;joystick right ?
	jrne	pph_5a

	move	@plyr_head_nbr,a0
	inc	a0
	cmpi	SM_HEADS_CNT,a0
	jrlo	pph_4a
	clr	a0
pph_4a	move	a0,@plyr_head_nbr

	callr	update_selectable_heads
	callr	update_dribbling_player_head
	calla	create_rght_arrow
	callr	del_hit_points_fraction
	callr	create_head_nbr_fraction
	callr	my_build_plr_pal		;setup default pal.
	SOUND1	cursor_rgt
	jruc	pph_5
pph_5a
	calla	del_select_arrow
;
; Read buttons (for exit)
;
pph_5
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down

	cmpi	TURBO_BUTTON,a0
	jreq	pph_6
	cmpi	PASS_BUTTON,a0
	jreq	pph_6
	cmpi	SHOOT_BUTTON,a0
	jrne	pph_1			;br=no joystick or buttons
;
; Exit this butn action (return to butn control)
;
pph_6
	calla	del_butn_box_stuff
	callr	del_hit_points_fraction
	RETP


;-----------------------------------------------------------------------------
;  Creates the object ptrs. for the 3 heads during 'HEAD' button action
;-----------------------------------------------------------------------------
 SUBR	create_selectable_heads
;
; Create X small heads
; 
	movi	plyr_head_objs,a9,L
	movi	plr_heads_small,a10,L
	movk	NUM_HEADS,a3			;nbr. of heads to create
	movi	[BBOXX+20,0],a0			;x val of first head
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	BUTN_BOX_STUFF,a5		;object class
	clr	a6				;x vel
	clr	a7				;y vel
cpph_1
	PUSH	a0,a3
	movi	[BBOXY+98,0],a1			;y val
	move	*a10+,a2,L			;* head image

	addi	FIFTH_HEAD,a2 			;pt to 5th frame
	move	*a2,a2,L      			;get frame 5 from table

	sll	4,a3
	addi	xpos_head_tbl,a3
	move	*a3,a3,W

	calla	BEGINOBJ2
	move	a8,*a9+,L
	PULL	a0,a3
	addi	001c0000h,a0,L			;add to X position (spacing)
	dsj	a3,cpph_1			;more heads ?

	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
	addi	nub_img_tbl,a0
	move	*a0,a2,L
	movi	[BBOXX+37,0],a0			;x val
	movi	[BBOXY+188,0],a1		;y val
	movi	82,a3				;z pos
	calla	BEGINOBJ2
;
; Create 1 Big head version of the hi-lited small head (mugshot)
;
	movi	80,a3				;z pos
	move	@plyr_head_nbr,a0
	addi	MIDDLE_HEAD,a0
	sll	5,a0				;offset into HEAD table
	addi	create_plr_mugshots_tbl,a0,L
	move	*a0,a2,L			;* BIG head image
	movi	[BBOXX+52,0],a0			;x val
	movi	[BBOXY+188,0],a1		;y val
	calla	BEGINOBJ2
	move	a8,@plyr_big_head_obj,L
	rets


xpos_head_tbl
	.word	80,80,81,85,81,80


;-----------------------------------------------------------------------------
;  called by 'HEAD' button action during CREATE PLAYER, as the player
; moves the joystick the HEADS change
;-----------------------------------------------------------------------------
 SUBR	update_selectable_heads
;
; Update the little heads as the players moves joystick
;
	movi	plyr_head_objs,a9,L
	move	@plyr_head_nbr,a10
	sll	5,a10				;offset into HEAD table
	addi	plr_heads_small,a10,L

	movk	NUM_HEADS,a3			;nbr. of heads to created
upph_1	move	*a9+,a8,L			;ptr. old image
	move	*a10+,a2,L			;ptr. new image

	addi	FIFTH_HEAD,a2				;pt to 5th frame
	move	*a2,a2,L				;get frame 5 from table

	callr	update_head
	dec	a3				;more heads ?
	jrne	upph_1				;br=yes
;
; Update the MUGSHOT head to match the hi-lited (middle) small head
;
	movi	plyr_big_head_obj,a8,L
	move	@plyr_head_nbr,a10
	addi	MIDDLE_HEAD,a10
	sll	5,a10				;offset into HEAD table
	addi	create_plr_mugshots_tbl,a10,L
	move	*a10,a2,L			;ptr. NEW big head image
	move	*a8,a8,L			;ptr. OLD big head image
	callr	update_head
 	rets

;-----------------------------------------------------------------------------
;    This routine changes the head on the player dribbling the ball to the
;       currently hi-lighted head.
;
; INPUT: a2 = ptr. to hi-lighted head
;-----------------------------------------------------------------------------
 SUBR	update_dribbling_player_head

	move	@plyr_head_nbr,a0
	addi	MIDDLE_HEAD,a0
	sll	5,a0
	addi	plr_heads_small,a0,L
	move	*a0,a2,L			;get NEW HEAD img ptr.
	addi	FIFTH_HEAD,a2				;pt to 5th frame
	move	*a2,a2,L				;get frame 5 from table
	move	@plyr_dribble_head_obj,a8,L	;get OLD image ptr.
	callr	update_head
 	rets

;-----------------------------------------------------------------------------
; INPUT: reg a2: new head img ptr
;        reg a8: old head img ptr
;-----------------------------------------------------------------------------
 SUBR	update_head

;update bits per pixel
	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	*a2(ICTRL),a14
	andni	>80ff,a14		;DMA flags
	or	a14,a1
	move	a1,*a8(OCTRL)

	move	*a2(ICMAP),a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)

	move	a2,a0
	move	*a8(OFLAGS),a1
	calla	obj_aniq
	rets


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_head_nbr_msg

	movi	head_nbr_str_setup,a2,L
	calla	setup_message
	movi	BUTN_BOX_STUFF,a0
	move	a0,@mess_objid
	movi	head_nbr_str,a4,L
	calla	print_string_C2
	rets

head_nbr_str_setup
	PRINT_STR	bast8t_ascii,4,0,BBOXX+48,BBOXY+49,BAST_W_P,0

head_nbr_str
	.string	"head number:",0
	.even


;-----------------------------------------------------------------------------
;	  Creates the images for XX/XX during CHOOSE HEAD option
;-----------------------------------------------------------------------------
 SUBR	create_head_nbr_fraction

	movi	BBOXX+118,a0
	move	a0,@mess_cursx			;message cursor pos X
	movi	BBOXY+49,a1
	move	a1,@mess_cursy			;message cursor pos Y

	movi	message_buffer,a3		;* string dest
	clr	a0
	move	a0,*a3,L
	move	a0,*a3(20h),L			;null terminate

	movi	SM_HEADS_CNT,a1			;max value
	move	@plyr_head_nbr,a0
	inc	a0					;non-zero relative
	calla	dec_to_asc
	calla	concat_string

	movi	str_slash,a4
	calla	concat_rom_string

	movi	SM_HEADS_CNT,a1				;max value
	move	a1,a0
	calla	dec_to_asc
	calla	concat_string

	movi	bast8t_ascii,a0
	move	a0,@message_ascii,L		;* ascii lookup table
	movi	BAST_W_P,a0
	move	a0,@message_palette,L
	movk	9,a0
	move	a0,@mess_space_width		;space char width
	movi	HIT_PTS_FRACTION,a0
	move	a0,@mess_objid
	calla	print_string_C
 	rets

;-----------------------------------------------------------------------------
;
;
; RETURNS: a14 - total points used
;-----------------------------------------------------------------------------
 SUBR	compute_hit_points_used
	
	clr	a14
	move	@height_points,a0
	add	a0,a14
	move	@weight_points,a0
	add	a0,a14
	move	@speed_points,a0
	add	a0,a14
	move	@power_points,a0
	add	a0,a14
	move	@shoot_points,a0
	add	a0,a14
	move	@dunks_points,a0
	add	a0,a14
	move	@steal_points,a0
	add	a0,a14
	move	@block_points,a0
	add	a0,a14
	rets	

;-----------------------------------------------------------------------------
; RETURNS: a14 - hit points remaining
;-----------------------------------------------------------------------------
 SUBR	compute_hit_points_left

	callr	compute_hit_points_used
	move	a14,a0
	move	@total_points,a14
	sub	a0,a14
	rets



	.asg	BBOXX+78,ATTRX		;for the attribute bars
	.asg	BBOXY+66,ATTRY		;for the attribute bars
	.asg	8,ATTR_MTR_SPC_Y
	.asg	ATTRX+49,ATTRX2		;for the attribute meters
	.asg	0,ATR_Y			;table positions
	.asg	32,ATR_IMG1
	.asg	64,ATR_IMG2	
	.asg	32*3,ATTR_TBL_LINE_SIZE

;-----------------------------------------------------------------------------
;      This routine changes the palette for both pieces of the current
; attribute bar and the previous (based on cursor position)
;-----------------------------------------------------------------------------
 SUBR	update_attrib_bar_palettes

;update previous attribute bar palette
	move	@prev_attrib_cur_pos,a10
	sll	6,a10				;*64 (each bar 2 pieces)
	addi	big_attrib_bar_objs,a10,L
	move	*a10+,a9,L			;get ptr. to LEFT piece (name)
	move	*a10,a10,L			;get ptr. to RIGHT piece (bar)
	movi	ATTBARW_P,a0,L
	calla	pal_getf
	move	a0,*a9(OPAL)			;change left pieces's pal
	move	a0,*a10(OPAL)			;change right pieces's pal

;update current attribute bar palette
	move	@attrib_cur_pos,a10
	sll	6,a10				;*64 (each bar 2 pieces)
	addi	big_attrib_bar_objs,a10,L
	move	*a10+,a9,L			;get ptr. to LEFT piece (name)
	move	*a10,a10,L			;get ptr. to RIGHT piece (bar)
	movi	ATTBARO_P,a0,L
	calla	pal_getf
	move	a0,*a9(OPAL)			;change left pieces's pal
	move	a0,*a10(OPAL)			;change right pieces's pal
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_big_attrib_bar_meters

	movi	NUM_ATTRIBS,a10
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	BUTN_BOX_STUFF,a5		;object class
	clr	a6				;x vel
	clr	a7				;y vel
	movi	[ATTRY+ATTR_MTR_SPC_Y,0],a1	;1st Y val.
	movi	big_attrib_meter_objs,a9,L	;array for METER objects

;plot attribute bar notches
crabn_1
	move	a1,a11
	movi	[ATTRX-12,0],a0			;x val.
	movi	NOTCH_01,a2,L			;* image
	movk	25,a3				;z pos (under dithering pattern)
	calla	BEGINOBJ2
	move	a8,*a9+,L		     ;save ptr. to BIG ATTRIB. NOTCHES
	move	a11,a1
	addi	[ATTR_MTR_SPC_Y+9,0],a1
	dsj	a10,crabn_1
 	rets

;-----------------------------------------------------------------------------
; plot attribute name, bar outline and bars from table these graphics are
; used when ADJUSTING ATTRIBUTES
;-----------------------------------------------------------------------------
 SUBR	create_big_attrib_bars
	
	movi	NUM_ATTRIBS,a10
	movi	attribute_setup_table,a9,L
	movi	big_attrib_bar_objs,a11,L	;array for attrib. bar pieces

	movk	15,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	BUTN_BOX_STUFF,a5		;object class
	clr	a6				;x vel
	clr	a7				;y vel

nxatt_1
;plot attribute bar names (left half of bar)
	movi	[ATTRX,0],a0,L			;get X val
	move	*a9(ATR_Y),a1,L			;get Y val
	move	*a9(ATR_IMG1),a2,L			;* image
	calla	BEGINOBJ2
	move	a8,*a11+,L

;plot attribute bar ends (right half of bar)
	movi	[ATTRX,0],a0,L			;get X val
	move	*a9(ATR_Y),a1,L			;get Y val
	move	*a9(ATR_IMG2),a2,L			;* image
	calla	BEGINOBJ2
	move	a8,*a11+,L

	addi	ATTR_TBL_LINE_SIZE,a9				;32*3 - # table element in line
	dsj	a10,nxatt_1			;br=more to plot
	rets

;-----------------------------------------------------------------------------
; Updates the attribute bars while player is ADJUSTING them....also updates
;  the bars underneath the player dribbling the ball
;-----------------------------------------------------------------------------
 SUBR	update_attribute_bars

	movi	attrib_ram_value_ptr_table,a2,L	;table of value of bars
	movi	big_attrib_meter_objs,a10,L	;array for BIG bar objects
	clr	a4
uab_1
	move	*a10+,a8,L			;get ptr to next bar obj.

	move	*a2+,a1,L			;a1=addr. of VALUE to upate
	move	*a1,a3,W			;a3=value

	sll	5,a3
	addi	big_attrib_bar_img_tbl,a3,L
	move	*a3,a0,L			;get img. ptr.
	PUSH	a1
	move	*a8(OCTRL),a1
	calla	obj_aniq		;change object image
	PULL	a1

	inc	a4
 	cmpi	NUM_ATTRIBS-1,a4		;more elements to update ?
	jrls	uab_1				;br=yes

	calla	update_plyr_attrib_bar_imgs
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	update_plyr_attrib_bar_imgs

 	clr	a4
	movi	attrib_ram_value_ptr_table2,a2,L
	movi	plyr_attrib_meter_objs,a10,L	;array for BAR objects
updab_1
	move	*a10+,a8,L			;get plyr. dribble attr. bar obj

	move	*a2+,a1,L			;a1=addr. of VALUE to upate
	move	*a1,a3,W			;a3=value

	sll	5,a3
	addi	small_attrib_bar_img_tbl,a3,L
	move	*a3,a0,L			;get img. ptr.
	PUSH	a1
	move	*a8(OCTRL),a1
	calla	obj_aniq		;change object image
	PULL	a1

	inc	a4
	cmpi	5,a4				;more elements to update ?
	jrls	updab_1				;br=nope
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_hit_points_fraction

	movi	CYCPID,a0
	calla	KIL1C

	movi	HIT_PTS_FRACTION,a0,L
	calla	obj_del1c
	rets

;-----------------------------------------------------------------------------
;	  Creates the images for XX/XX during adjust players attribute
;-----------------------------------------------------------------------------
 SUBR	create_hit_points_fraction

	movi	total_points_str_setup,a2,L
	calla	setup_message
	movi	HIT_PTS_FRACTION,a0
	move	a0,@mess_objid
	movi	total_points_str,a4,L
	calla	print_string_C2

	movi	BBOXX+115,a0
	move	a0,@mess_cursx			;message cursor pos X
	movi	BBOXY+56,a1
	move	a1,@mess_cursy			;message cursor pos Y

	movi	message_buffer,a3		;* string dest
	clr	a0
	move	a0,*a3,L
	move	a0,*a3(20h),L			;null terminate

	movi	99,a1				;max value
	callr	compute_hit_points_left
	move	a14,a0
	calla	dec_to_asc
	calla	concat_string

	movi	str_slash,a4
	calla	concat_rom_string

	movi	99,a1				;max value
	move	@total_points,a0
	calla	dec_to_asc
	calla	concat_string

	movi	bast8t_ascii,a0
	move	a0,@message_ascii,L		;* ascii lookup table
	movi	BAST_W_P,a0
	move	a0,@message_palette,L
	movk	9,a0
	move	a0,@mess_space_width		;space char width
	movi	HIT_PTS_FRACTION,a0
	move	a0,@mess_objid
	calla	print_string_C

;	CREATE	FLSH_TXT_PID,change_pal_on_text
 	rets


total_points_str_setup
	PRINT_STR	bast8t_ascii,4,0,BBOXX+48,BBOXY+56,BAST_W_P,0

total_points_str
	.string	"total points:",0
	.even

;BASTCYCWP:
;   .word   07fffh,07bdeh,077bdh,0739ch,0739ch,06f7bh
;   .word   06b5ah,06739h,06318h,05ef7h,05ad6h,05ef7h,06318h,06739h
;   .word   06f7bh,0739ch,077bdh,07bdeh,07bdeh,077bdh,06f7bh,06b5ah
;   .word   06318h,06739h,06f7bh,0739ch,077bdh,07bdeh,0739ch,06f7bh
;   .word   06b5ah,06739h,05ef7h,05ad6h,05ef7h,05ef7h,06318h,06739h
;   .word   06739h,06b5ah,06b5ah,06f7bh,0739ch,0739ch,077bdh,07bdeh
;   .word   07bdeh,07fffh
;
;   .word   07fffh,07bdeh,077bdh,0739ch,0739ch,06f7bh
;   .word   06b5ah,06739h,06318h,05ef7h,05ad6h,05ef7h,06318h,06739h
;   .word   06f7bh,0739ch,077bdh,07bdeh,07bdeh,077bdh,06f7bh,06b5ah
;   .word   06318h,06739h,06f7bh,0739ch,077bdh,07bdeh,0739ch,06f7bh
;   .word   06b5ah,06739h,05ef7h,05ad6h,05ef7h,05ef7h,06318h,06739h
;   .word   06739h,06b5ah,06b5ah,06f7bh,0739ch,0739ch,077bdh,07bdeh
;   .word   07bdeh,07fffh
;   .word   -1
;   .even



;-----------------------------------------------------------------------------
;
;
; INPUT: reg. a10 - ID of obj. to look for
;-----------------------------------------------------------------------------
 SUBR	change_pal_on_text

	movi	BAST_W_P,a0,L
	calla	pal_getf
	move	a0,a8
	movi	BAST_R_P,a0,L
	calla	pal_getf
	move	a0,a9
cpof_0
	SLEEPK	9

;	move	@done_creating,a14		;exit flag (0=exit)
;	jrz	cpof_6

	movi	OBJLST,a1
	move	*a1,a1,L			;get next obj. ptr
	jrz	cpof_5				;br=no obj. list
cpof_1
	move	*a1(OID),a14
	cmp	a10,a14				;is ID > than range start ?
	jrne	cpof_2				;br=nope

	move	*a1(OPAL),a14
	cmp	a8,a14				;white pal ?
	jrne	cpof_1a				;br=no
	move	a9,*a1(OPAL),L
	jruc	cpof_2
cpof_1a
	cmp	a9,a14				;red pal ?
	jrne	cpof_2
	move	a8,*a1(OPAL),L

cpof_2	move	*a1,a1,L
	jrnz	cpof_1
cpof_5
	jruc	cpof_0
	DIE

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	kill_flsh_txt_proc

	movi	FLSH_TXT_PID,a0
	calla	KIL1C				;kill clock timer
	rets

;-----------------------------------------------------------------------------
;     ACTION routine for button
; This controls the cursor and increasing/decreasing of attributes
;-----------------------------------------------------------------------------
 SUBRP	attribute_cursor_cntrl

	clr	a0
	calla	create_divider_bar
;	callr	create_total_points_msg
	callr	create_hit_points_fraction
	callr	create_big_attrib_bars
	callr	create_big_attrib_bar_meters

	clr	a0
	move	a0,@prev_attrib_cur_pos
	move	a0,@attrib_cur_pos
	move	a0,@joy_pos
	move	a0,@repeat_cnt
	callr	update_player_body_size
	callr	update_attribute_bars
	calla	update_attrib_bar_palettes

	movi	HIT_PTS_FRACTION,a10,L
	CREATE	FLSH_TXT_PID,change_pal_on_text
;
; Read joystick
;
acc_1
	SLEEPK	1
	move	@done_creating,a0
	jrz	acc_6

	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_cur		;ret. a0=joy switch value
	cmpi	JOY_NONE,a0			;joytick movement ?
	jreq	acc_1a				;br=nope, check buttons

	move	@joy_pos,a14
	cmp	a14,a0
	jrne	acc_1a				;br=different direction

	move	@repeat_cnt,a1
	inc	a1
	move	a1,@repeat_cnt
	cmpi	REPEAT_DELAY/2,a1		;repeat yet ?
	jrls	acc_5	       			;br=no

acc_1a
	move	a0,@joy_pos
	clr	a1
	move	a1,@repeat_cnt			;reset repeat count
;
; Up ?
;
	cmpi	JOY_UP,a0			;joystick up ?
	jrne	acc_2				;br=nope
	move	@attrib_cur_pos,a0
	move	a0,@prev_attrib_cur_pos		;save before change
	dec	a0
	jrnn	acc_2a
	movi	NUM_ATTRIBS-1,a0		;reset cursor position
acc_2a	move	a0,@attrib_cur_pos
	calla	update_attrib_bar_palettes
	SOUND1	cursor_up2
	jruc	acc_5
;
; Down ?
;
acc_2	cmpi	JOY_DOWN,a0			;joystick down ?
	jrne	acc_3				;br=nope
	move	@attrib_cur_pos,a0
	move	a0,@prev_attrib_cur_pos		;save before change
	inc	a0
	cmpi	NUM_ATTRIBS,a0			;nbr of attributes to adjust
	jrlo	acc_3a
	clr	a0				;reset cursor position
acc_3a	move	a0,@attrib_cur_pos
	calla	update_attrib_bar_palettes
	SOUND1	cursor_dwn2
	jruc	acc_5
;
; Left ?
; 
acc_3	cmpi	JOY_LEFT,a0			;joystick left ?
	jrne	acc_4

	move	@attrib_cur_pos,a0		;use as index into table
	sll	5,a0				;mult. by 32 (1 long)
	addi	attrib_ram_value_ptr_table,a0,L

	move	*a0,a1,L			;a1=addr. of VALUE to upate
	move	*a1,a2,W			;get value

;check bounds
	cmpi	ATTRIB_MIN_VALUE,a2		;at minimum ?
	jrle	acc_5				;br=yes, change nothing...

	dec	a2				;sub. pts. from attrib. value

;make sure attribute value is valid after subtraction
	jrn	acc_5				;br= value negative, ignore
	move	a2,*a1,W			;save new value

	callr	make_adj_atrib_snd

	callr	update_player_body_size
	calla	print_body_dimensions
	callr	update_attribute_bars
	callr	del_hit_points_fraction
	calla	create_hit_points_fraction
	jruc	acc_5
;
; Right ?
;
acc_4	cmpi	JOY_RIGHT,a0			;joystick right ?
	jrne	acc_5

;first check to see if player has points to allocate

	callr	compute_hit_points_left
	move	a14,a14				;does player have points ?
	jrnz	acc_4a				;br=nope
;	jrz	acc_5				;br=nope

	SOUND1	no_sp
	jruc	acc_5
acc_4a

	move	@attrib_cur_pos,a0		;use as index into table
	sll	5,a0				;mult. by 32 (1 long)
	addi	attrib_ram_value_ptr_table,a0,L

	move	*a0,a1,L			;a1=addr. of VALUE to upate
	move	*a1,a2,W			;get value

;check bounds
	cmpi	ATTRIB_MAX_VALUE,a2		;attribute value at max ?
	jrhs	acc_5				;br=yes...change nothing

;make sure points used wont grow beyond TOTAL_POINTS limit

	callr	compute_hit_points_used
	inc	a14
	move	@total_points,a0
	cmp	a0,a14				;at or beyond MAXIMUN ?
	jrhi	acc_5				;br=yep

	inc	a2
	move	a2,*a1,W			;save new attribute value

	callr	make_adj_atrib_snd

	callr	update_player_body_size
	calla	print_body_dimensions
	callr	update_attribute_bars
	callr	del_hit_points_fraction
	calla	create_hit_points_fraction
;
; Read buttons (for exit)
;
acc_5
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down
	cmpi	TURBO_BUTTON,a0
	jreq	acc_6
	cmpi	PASS_BUTTON,a0
	jreq	acc_6
	cmpi	SHOOT_BUTTON,a0
	jrne	acc_1			;br=no joystick or buttons
;
; Exit this butn action (return to butn control)
;
acc_6	
	callr	kill_flsh_txt_proc
	calla	del_butn_box_stuff
	callr	del_hit_points_fraction
	RETP


;-----------------------------------------------------------------------------
; 	  This routine plays a sounds based on the attribute level
;
; INPUT: reg a2 - attrib value
;-----------------------------------------------------------------------------
 SUBR	make_adj_atrib_snd

	sll	5,a2
 	addi	atrib_adj_snd_tbl,a2
	move	*a2,a0,L
	calla	snd_play1
	rets

atrib_adj_snd_tbl
	.long	atrib_snd1	;0
	.long	atrib_snd1	;1
	.long	atrib_snd2	;2
	.long	atrib_snd3	;3
	.long	atrib_snd4	;4
	.long	atrib_snd5	;5
	.long	atrib_snd6	;6
	.long	atrib_snd7	;7
	.long	atrib_snd8	;8
	.long	atrib_snd9	;9
	.long	atrib_snd10	;10


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_privilege_bars

	movi	PRIVILEGE_OBJS,a0,L
	clr	a1
	calla	obj_del1c
 	rets


	.asg	0,XCOOR
	.asg	32,YCOOR
	.asg	64,IMGPTR
	.asg	96,IMGPTR2

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_privilege_bars
 	
	movi	80,a3				;z pos.
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	PRIVILEGE_OBJS,a5		;object class
	clr	a6				;x vel
	clr	a7				;y vel
	clr	a10				;counter

	movi	privilege_setup_tbl,a9,L
cpb_1
	move	*a9(XCOOR),a0,L				;get X coor
	move	*a9(YCOOR),a1,L				;get Y coor
	move	*a9(IMGPTR),a2,L			;get left half of bar

	movi	PRIV_W_P,b0,L
	move	@priv_cur_pos,a14
;	jrnz	cpb_1a				;cant test bit 0 for 1
;	move	a10,a10				
;	jrz	cpb_1b
;
cpb_1a	btst	a10,a14
	jrz	cpb_2
cpb_1b	movi	PRIV_O_P,b0,L			;hilit current privilege
cpb_2
	move	b0,a11
	calla	BEGINOBJP2

	move	*a9(XCOOR),a0,L				;get X coor
	move	*a9(YCOOR),a1,L				;get Y coor
	move	*a9(IMGPTR2),a2,L			;get left half of bar
	move	a11,b0
	calla	BEGINOBJP2

	inc	a10
	addi	LNE_LGTH,a9,L
	cmpi	privilege_setup_tbl_end,a9,L
	jrlo	cpb_1
	rets


	.asg	BBOXX+76,PRIV_BARX
	.asg	BBOXY+78,PRIV_BARY
	.asg	PRIV_BARY-9,CHK_MRK_Y
	.asg	18,PRIV_SPC

privilege_setup_tbl
	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*0,0],PRVLGCK1,TEX_NTA
privilege_setup_tbl2
	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*1,0],PRVLGCK1,TEX_ST
	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*2,0],PRVLGCK1,TEX_BH
	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*3,0],PRVLGCK1,TEX_HA
	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*4,0],PRVLGCK1,TEX_DBH
	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*5,0],PRVLGCK1,TEX_SR
	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*6,0],PRVLGCK1,TEX_SD
privilege_setup_tbl_end

;privilege_setup_tbl
;	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*0,0],PRVLGCK1,TEX_BB
;privilege_setup_tbl2
;	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*1,0],PRVLGCK1,TEX_ST
;	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*2,0],PRVLGCK1,TEX_BH
;	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*3,0],PRVLGCK1,TEX_HA
;	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*4,0],PRVLGCK1,TEX_SD
;	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*5,0],PRVLGCK1,TEX_SR
;	.long	[PRIV_BARX,0],[PRIV_BARY+PRIV_SPC*6,0],PRVLGCK1,TEX_BD
;privilege_setup_tbl_end

LNE_LGTH	equ	(privilege_setup_tbl2-privilege_setup_tbl)
NUM_PRIVILEGES	equ	(privilege_setup_tbl_end-privilege_setup_tbl)/(32*4)


	.asg	2,MAX_CHK_MRKS

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	toggle_check_mark

	move	@privileges,a0
	move	@priv_cur_pos,a10		;use as index into table
	move	a10,a14
tcm_0  
	and	a0,a14
	jrz	tcm_3				;br=not check mark at this pos.

;clear bit (privilege)
tcm_2
	xor	a10,a0

	move	@check_marks,a14
	jrz	tcm_5
	dec	a14
	move	a14,@check_marks
	move	a0,@privileges
	SOUND1	unchkmrk_snd
	jruc	tcm_4


;set bit (privilege)
tcm_3
	or	a10,a0

	move	@check_marks,a14
	cmpi	MAX_CHK_MRKS,a14
	jrhs	tcm_5
	inc	a14
	move	a14,@check_marks
	move	a0,@privileges
	SOUND1	chkmrk0_snd
tcm_4
	callr	del_check_marks
	callr	create_check_marks
tcm_5
	callr	update_player_head_size
	rets


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_check_marks

	PUSH	a12
	movi	90,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CHECK_MRK_OBJS,a5		;object class
	clr	a6				;x vel
	clr	a7				;y vel
	movi	CHECK,a2,L			;'CHECK' mark img.
	movi	NUM_PRIVILEGES,a10
	clr	a11
	clr	a12				;nbr of check marks created
	move	@privileges,a9
cmrks_1
	srl	1,a9				;check mark ?
	jrnc	cmrks_2				;br=nope
	move	a11,a14
	sll	6,a14
	addi	check_mark_xys,a14
	move	*a14+,a0,L			;get X coor.
	move	*a14,a1,L			;get Y coor.
	calla	BEGINOBJ2
cmrks_2
	inc	a11
	dsj	a10,cmrks_1
cmrks_3	PULL	a12
	rets


check_mark_xys
	.long	[BBOXX+16,0],[CHK_MRK_Y,0]
	.long	[BBOXX+16,0],[CHK_MRK_Y+PRIV_SPC*1,0]
	.long	[BBOXX+16,0],[CHK_MRK_Y+PRIV_SPC*2,0]
	.long	[BBOXX+16,0],[CHK_MRK_Y+PRIV_SPC*3,0]
	.long	[BBOXX+16,0],[CHK_MRK_Y+PRIV_SPC*4,0]
	.long	[BBOXX+16,0],[CHK_MRK_Y+PRIV_SPC*5,0]
	.long	[BBOXX+16,0],[CHK_MRK_Y+PRIV_SPC*6,0]

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_check_marks

	movi	CHECK_MRK_OBJS,a0,L
	clr	a1
	calla	obj_del1c
	rets

;-----------------------------------------------------------------------------
;      ACTION routine for button
; This controls the cursor and increasing/decreasing of attributes
;-----------------------------------------------------------------------------
 SUBRP	plyr_privileges_cursor_cntrl

	movk	3,a0
	calla	create_divider_bar

	movi	NUM_PRIVILEGES,a14		;nbr of privilegs
	move	@privileges,a0
	clr	a1
ppcc_0
	srl	1,a0
	jrnc	ppc_0a
	inc	a1
ppc_0a	dsj	a14,ppcc_0
	move	a1,@check_marks

	movk	1,a0
	move	a0,@priv_cur_pos
	clr	a0
	move	a0,@joy_pos
	move	a0,@repeat_cnt
	callr	create_privilege_bars
	calla	print_privileges_info
	callr	create_check_marks

	movi	BUTN_PRIV_INST,a10
	CREATE	FLSH_TXT_PID,change_pal_on_text
;
; Read joystick
;
ppcc_1
	SLEEPK	1
	move	@done_creating,a0
	jrz	ppcc_6

	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_cur		;ret. a0=joy switch value
	cmpi	JOY_NONE,a0			;joytick movement ?
	jreq	ppcc_1a				;br=nope, check buttons

	move	@joy_pos,a14
	cmp	a14,a0
	jrne	ppcc_1a				;br=different direction

	move	@repeat_cnt,a1
	inc	a1
	move	a1,@repeat_cnt
	cmpi	REPEAT_DELAY/2,a1		;repeat yet ?
	jrls	ppcc_5	       			;br=no

ppcc_1a
	move	a0,@joy_pos
	clr	a1
	move	a1,@repeat_cnt			;reset repeat count
;
; Up ?
;
	cmpi	JOY_UP,a0			;joystick up ?
	jrne	ppcc_2				;br=nope
	move	@priv_cur_pos,a0
	cmpi	1,a0
	jreq	ppcc_5				;br=dont go any higher
	srl	1,a0
ppcc_2a	move	a0,@priv_cur_pos
	callr	del_privilege_bars
	callr	create_privilege_bars
	SOUND1	cursor_up2
	jruc	ppcc_5
;
; Down ?
;
ppcc_2	cmpi	JOY_DOWN,a0			;joystick down ?
	jrne	ppcc_3				;br=nope
	movi	NUM_PRIVILEGES-1,a14		;nbr of attributes to adjust
	move	@priv_cur_pos,a0
	btst	a14,a0				;at end ?
	jrnz	ppcc_5				;br=dont go beyond bottom
	sll	1,a0
	move	a0,@priv_cur_pos
	callr	del_privilege_bars
	callr	create_privilege_bars
	SOUND1	cursor_dwn2
	jruc	ppcc_5
;
; Left ?
; 
ppcc_3	cmpi	JOY_LEFT,a0			;joystick left ?
	jrne	ppcc_4
	callr	toggle_check_mark
	jruc	ppcc_5
;
; Right ?
;
ppcc_4	cmpi	JOY_RIGHT,a0			;joystick right ?
	jrne	ppcc_5
	callr	toggle_check_mark
;
; Read buttons (for exit)
;
ppcc_5
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down

	cmpi	TURBO_BUTTON,a0
	jreq	ppcc_6
	cmpi	PASS_BUTTON,a0
	jreq	ppcc_6
	cmpi	SHOOT_BUTTON,a0
	jrne	ppcc_1			;br=no joystick or buttons
;
; Exit this butn action (return to butn control)
;
ppcc_6	
	calla	del_butn_box_stuff
	callr	kill_flsh_txt_proc
	callr	del_privilege_bars
	callr	del_check_marks
	RETP

;-----------------------------------------------------------------------------
;		This routine build the player palette
;
; INPUT :  reg a7 - ptr. to uniform pals (attribute table)
;          reg a8 - plyr obj. ptr
;
;-----------------------------------------------------------------------------
 SUBR	my_build_plr_pal
 	
 	PUSH	a1,a2,a3,a7,a8
	move	@home_team,a3

	move	@uniform_nbr,a7
;	andni	01000000b,a7			;clr HOME team bit
	addi	MIDDLE_UNIFORM_NBR,a7
	sll	5,a7
	addi	ply_city_tbl,a7,L
	move	*a7,a7,L

	move	@bball_plr_obj,a8,L		;save ptr. to basketball
	clr	a0
	move	a0,*a8(OPAL)
	calla	pal_clean		;get rid of old pal.

	movi	plyrpals_t,a2,L

	movi	128,a0
	move	a0,*a2+			;Set # colors

	move	@plyr_head_nbr,a14
	addi	MIDDLE_HEAD,a14
	sll	5,a14
	addi	plr_flesh_pal_tbl,a14,L
	move	*a14,a1,L

	move	*a1+,a0
#plflp	move	*a1+,*a2+
	dsjs	a0,#plflp

	move	*a7(PAT_PALT_p),a1,L	;Copy trim
	btst	0,a3
	jrz	#awytm1
	move	*a7(PAT_PALT2_p),a1,L	;Copy trim
#awytm1
	move	*a1+,a0
	addk	16,a1
	subk	1,a0 
#pltlp	move	*a1+,*a2+
	dsjs	a0,#pltlp

	move	*a7(PAT_PALU_p),a1,L	;Copy uniform
	btst	0,a3
	jrz	#awytm2
	move	*a7(PAT_PALU2_p),a1,L	;Copy uniform
#awytm2
	move	*a1+,a0
	addk	16,a1
#plulp	move	*a1+,*a2+
	dsjs	a0,#plulp
	subk	16,a2

	movi	ltshoepal_t,a1		;Copy shoes
	movk	13,a0			;# In shoe pal
#plslp	move	*a1+,*a2+
	dsjs	a0,#plslp

	move	*a7(PAT_PALSW_p),a1,L	;Copy trim
	btst	0,a3
	jrz	#awytm3
	move	*a7(PAT_PALSW2_p),a1,L	;Copy trim
#awytm3
	move	*a1+,a0
	addk	16,a1
	subk	1,a0
#pltlpa	move	*a1+,*a2+
	dsjs	a0,#pltlpa

	move	*a7(PAT_PALVP_p),a1,L	;Copy trim
	btst	0,a3
	jrz	#awytm4
	move	*a7(PAT_PALVP2_p),a1,L	;Copy trim
#awytm4
	move	*a1+,a0
	addk	16,a1
	subk	1,a0
#pltlpb	move	*a1+,*a2+
	dsjs	a0,#pltlpb

	movi	plyrpals_t,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)

	PULL	a1,a2,a3,a7,a8
 	rets

;-----------------------------------------------------------------------------
; action routine for button
;-----------------------------------------------------------------------------
 SUBR	choose_uniform_color_cntrl
	
	movk	4,a0
	calla	create_divider_bar
	calla	create_arrow_and_text_bar

	clr	a0
	move	a0,@joy_pos
	move	a0,@repeat_cnt			;delay before auto-repeat
	calla	clr_select_arrow_ram
	callr	create_uniform_names
	movi	REPEAT_RATE,a0				;2 ticks delay
	move	a0,@repeat_rate			;rate of auto-repeat
;
; Read joystick
;
cuc_1
	SLEEPK	1

	move	@done_creating,a0
	jrz	cuc_6

	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_cur		;ret. a0=joy switch value
	cmpi	JOY_NONE,a0			;joytick movement ?
	jreq	cuc_1a				;br=nope

	move	@joy_pos,a14
	cmp	a14,a0
	jrne	cuc_1a

	move	@repeat_cnt,a1
	inc	a1
	move	a1,@repeat_cnt
	cmpi	REPEAT_DELAY,a1			;repeat yet ?
	jrls	cuc_5				;br=no

	move	@repeat_rate,a14
	dec	a14
	move	a14,@repeat_rate
	jrgt	cuc_5				;br=dont allow movement
	movk	REPEAT_RATE,a14
	move	a14,@repeat_rate
	jruc	cuc_10
cuc_1a
	clr	a1
	move	a1,@repeat_cnt		;reset repeat count
cuc_10	move	a0,@joy_pos			;save current joy. pos
	calla	del_select_arrow
;
; Up ?
;
cuc_1b	cmpi	JOY_UP,a0			;joystick up ?
	jrne	cuc_2				;br=nope
	calla	create_up_arrow

	move	@uniform_nbr,a0
	dec	a0
	jrnn	cuc_1c
	movi	NUM_UNIFORM_NAMES-1,a0		;reset cursor position
cuc_1c	move	a0,@uniform_nbr		;used for table indexing

	callr	del_uniform_names
	callr	create_uniform_names
	callr	my_build_plr_pal
	SOUND1	cursor_up3
	jruc	cuc_5
;
; Down ?
;
cuc_2	cmpi	JOY_DOWN,a0			;joystick down ?
	jrne	cuc_3				;br=nope
	calla	create_down_arrow

	move	@uniform_nbr,a0
	inc	a0
	cmpi	NUM_UNIFORM_NAMES,a0			;nbr of attributes to adjust
	jrlo	cuc_2a
	clr	a0				;reset cursor position
cuc_2a	move	a0,@uniform_nbr

	callr	del_uniform_names
	callr	create_uniform_names
	callr	my_build_plr_pal
	SOUND1	cursor_dwn3
	jruc	cuc_5

;
; Right
;
cuc_3	cmpi	JOY_RIGHT,a0			;joystick down ?
	jreq	cuc_4				;br=yes
	cmpi	JOY_LEFT,a0			;joystick down ?
	jrne	cuc_5				;br=nope
cuc_4
	move	@home_team,a14
	xori	1,a14			;toggle bit 7 (home team pal.)
	move	a14,@home_team
	callr	my_build_plr_pal
	SOUND1	diag_cursor

;
; Read buttons (for exit)
;
cuc_5
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down

	cmpi	TURBO_BUTTON,a0
	jreq	cuc_6
	cmpi	PASS_BUTTON,a0
	jreq	cuc_6
	cmpi	SHOOT_BUTTON,a0
	jrne	cuc_1			;br=no joystick or buttons
;
; Exit this butn action (return to butn control)
;
cuc_6
	calla	del_butn_box_stuff
	callr	del_uniform_names
	RETP

;-----------------------------------------------------------------------------
; action routine for button
;-----------------------------------------------------------------------------
 SUBR	choose_nick_name_cntrl

	movk	4,a0
	calla	create_divider_bar
	calla	create_arrow_and_text_bar
	
	clr	a0
	move	a0,@joy_pos
	move	a0,@repeat_cnt			;delay before auto-repeat
	calla	clr_select_arrow_ram
	calla	create_nick_names
	movi	REPEAT_RATE,a0				;2 ticks delay
	move	a0,@repeat_rate			;rate of auto-repeat
;
; Read joystick
;
pnn_1
	SLEEPK	1

	move	@done_creating,a0
	jrz	pnn_6

	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_cur		;ret. a0=joy switch value
	cmpi	JOY_NONE,a0			;joytick movement ?
	jreq	pnn_1a				;br=nope

	move	@joy_pos,a14
	cmp	a14,a0
	jrne	pnn_1a

	move	@repeat_cnt,a1
	inc	a1
	move	a1,@repeat_cnt
	cmpi	REPEAT_DELAY,a1			;repeat yet ?
	jrls	pnn_5				;br=no

	move	@repeat_rate,a14
	dec	a14
	move	a14,@repeat_rate
	jrgt	pnn_5				;br=dont allow movement
	movk	REPEAT_RATE,a14
	move	a14,@repeat_rate
	jruc	pnn_10
pnn_1a
	clr	a1
	move	a1,@repeat_cnt		;reset repeat count
pnn_10	move	a0,@joy_pos
	calla	del_select_arrow
;
; Up ?
;
pnn_1b	cmpi	JOY_UP,a0			;joystick up ?
	jrne	pnn_2				;br=nope
	calla	create_up_arrow

	move	@nick_name_nbr,a0
	dec	a0
	jrnn	pnn_2a
	movi	NUM_NICK_NAMES-1,a0		;reset cursor position
pnn_2a	move	a0,@nick_name_nbr

	calla	del_nick_names
	calla	create_nick_names
	SOUND1	cursor_up3
	jruc	pnn_5
;
; Down ?
;
pnn_2	cmpi	JOY_DOWN,a0			;joystick down ?
	jrne	pnn_4				;br=nope
	calla	create_down_arrow

	move	@nick_name_nbr,a0
	inc	a0
	cmpi	NUM_NICK_NAMES,a0			;nbr of attributes to adjust
	jrlo	pnn_3a
	clr	a0				;reset cursor position
pnn_3a	move	a0,@nick_name_nbr

	calla	del_nick_names
	calla	create_nick_names
	SOUND1	cursor_dwn3
	jruc	pnn_5
;
; Left or Right ?
;
pnn_4	cmpi	JOY_LEFT,a0			;joystick left ?
	jreq	pnn_4a				;br=nope
	cmpi	JOY_RIGHT,a0			;joystick right ?
	jrne	pnn_5				;br=nope
pnn_4a
	callr	say_nickname

;
; Read buttons (for exit)
;
pnn_5
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down

	cmpi	TURBO_BUTTON,a0
	jreq	pnn_6
	cmpi	PASS_BUTTON,a0
	jreq	pnn_6
	cmpi	SHOOT_BUTTON,a0
	jrne	pnn_1			;br=no joystick or buttons
;
; Exit this butn action (return to butn control)
;
pnn_6	
	callr	say_nickname

	calla	del_butn_box_stuff
	calla	del_nick_names
	RETP

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBRP	say_nickname

	move	@nick_name_nbr,a0
	addi	MIDDLE_NICK_NAME,a0
	sll	6,a0
	addi	nickname_img_tbl,a0
	move	*a0(32),a0,L			;get sound ptr
	calla	snd_play1
	rets

;-----------------------------------------------------------------------------
; action routine for button
;-----------------------------------------------------------------------------
 SUBR	change_players_game_name

	movk	1,a0
	move	a0,@changing_name
	move	*a13(PC_PLAYNUM),a10
	JSRP	enter_game_name

	movi	player1_data,a0,L
	move	a0,*a13(PC_DATADDR),L		;start of player data
	RETP

;-----------------------------------------------------------------------------
;   This process controls the players entering his GAME NAME up to 6 chars.
;-----------------------------------------------------------------------------
 SUBRP	enter_game_name

	move	@changing_name,a0		;changing name ?
	jrz	egn_0				;br=yep
	calla	print_ask_chg_nme
	movk	4,a10				;BIG BUTTONS
	JSRP	ask_yes_no
	move	a11,a11				;change name and pin number ?
	jrne	done3				;br=player said NO!!
	calla	create_butn_instructions	;reprint title, yes/no deleted it

	movi	player1_data,a1,L
	addi	PR_NAME1,a1
	move	a1,*a13(PC_DATADDR),L		;start of player data
	subi	PR_NAME1,a1
	jruc	egn_1b

egn_0
	movk	8,a9
	calla	create_a9_butn_instructions

	movi	player1_data,a1,L
	addi	PR_NAME1,a1
	move	a1,*a13(PC_DATADDR),L		;start of player data
	subi	PR_NAME1,a1

;clear out letters
egn_1a	movi	-1,a0				;init player data to -1
	move	a0,*a1(PR_COUNT)
egn_1b	clr	a0
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

;egn_1b
	movi	BBOXX+78,a1
	move	a1,*a13(PC_CENTERX)		;name center X
	move	a1,*a13(PC_CENTERX2)		;stats box center X
	move	a1,*a13(PC_CENTERXkit)		;name center X (kit)

	movk	1,a0
	calla	create_divider_bar

	move	*a13(PC_PLAYNUM),a10

	clr	a0
	move	a0,*a13(PC_FLASHCOUNT)

	movi	TYPTEXT|SUBPL1,a0
	move	a0,*a13(PC_OBJID)		;OBJ ID's created by this PROC
;
; Create cursor (behind letter)
;
	movi	[250,0],a0		;x val
	movi	[80,0],a1		;y val
	movi	INGA16_A,a2		;* image
	movk	7,a3			;z pos
	movi	DMACAL|M_SCRNREL,a4	;DMA flags
	move	*a13(PC_OBJID),a5
	ori	10h,a5			;object	ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2

	movi	0202h,a0
	move	a0,*a8(OCONST)
	move	a8,*a13(PC_CURSOBJ),L
;
; Create the LETTERS (echoing input)
;
	move	*a13(PC_OBJID),a5
	ori	10h,a5			;ID

;	move	@changing_pinnbr,a0		;changing pin number ?
;	jrz	pin_2		   		;br=nope
;	movk	6,a0				;fake having entered name
;	move	a0,*a13(PC_CHARPOS)
;	calla	create_pin_nbr_objs
;	jruc	pin_3

pin_2	calla	create_name_objs
	calla	create_pin_nbr_objs
	clr	a0
	move	a0,*a13(PC_CHARPOS)
;
; Put up the menu (alphabet)
;
pin_3	movi	enter_name_menu,a0,L
	move	a0,*a13(PC_MENUBASE),L

;if changing pin number, start on second menu
;	movk	1,a0	      			;2nd menu (pin nbr)
;	move	@changing_pinnbr,a1		;changing pin number ?
;	jrnz	pin_1		   		;br=yep
	clr	a0		   		;first menu (name)
pin_1	move	a0,*a13(PC_MENULEVEL)
	calla	create_menu
	calla	update_cursor

	move	@changing_name,a0		;changing name ?
	jrnz	loop0				;br=yep
	movi	un_wipe_horizontal,a0,L
	movi	NO_CREATE_DEL_OBJS,a14
	JSRP	do_scrn_transition
loop0
	SLEEPK	1
loop1
	movi	22,a10				;initial repeat delay
delay_1
	SLEEPK	1

	move	@done_creating,a14
	jrz	done3

	move	*a13(PC_PLAYNUM),a1
	move	*a13(PC_FLASHCOUNT),a0	;cursor flash count
	inc	a0
	move	a0,*a13(PC_FLASHCOUNT)
		 
	calla	save_selection
	calla	update_statbox_images
;upn_1
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down
	jrz	noact_1

	JSRP	button_actions

	move	*a13(PC_MENULEVEL),a0
;	cmpi	1,a0				;finished entering name ?
;	jrne	noact_0				;br=nope
;	move	@changing_name,a1		;changing name ?
;	jrnz	done1				;br=yep, dont goto pin number
noact_0
	cmpi	2,a0				;finished entering pin nbr ?
	jreq	done1				;br=yep
noact_1
	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_down
	jrnz	movit_1
	calla	update_cursor
	dsj	a10,delay_1
	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_cur
	calla	move_cursor
	calla	update_cursor
	movi	15,a10				;repeat delay
	jruc	delay_1
movit_1
	calla	move_cursor
	calla	update_cursor
	jruc	loop1
done1
	move	*a13(PC_CURSOBJ),a0,L		;delete cursor
	calla	DELOBJ
	move	*a13(PC_OBJID),a0		;OBJ ID's created by this PROC
	calla	obj_del1c			;delete all objs with this ID

	calla	del_butn_info_text		;delete directions
	calla	turn_off_name_objs

	move	@changing_name,a0		;is plyr just changing name ?
	jrnz	done2				;br=yep
	callr	setup_plr_record

	SLEEP	70
	movi	120,a10
done1a
	SLEEPK	2
	move	*a13(PC_PLAYNUM),a0		;OBJ ID's created by this PROC
	calla	get_but_val_cur
	jrnz	done1b
	dsj	a10,done1a
done1b
	SOUND1	butn_press2

;delete record availibilty message
	move	*a13(PC_OBJID),a0		;OBJ ID's created by this PROC
	calla	obj_del1c			;delete all objs with this ID

done2
	move	@changing_name,a0
	jrz	done3
	calla	delete_name
	callr	print_entered_name
	calla	del_butn_box_stuff
	JSRP	print_changed_name_info

done3	clr	a0
	move	a0,@changing_name		;no longer changing name
	move	a0,@processing_butn		;not in butn action routine
	calla	del_butn_box_stuff
;;	calla	update_hilited_button
;done4
	RETP

;-----------------------------------------------------------------------------
;      This routine handles everything to do with finding/setting up, a 
; players record 
;-----------------------------------------------------------------------------
 SUBR	setup_plr_record

	movi	player1_data,a0,L
	move	a0,*a13(PC_DATADDR),L		;start of player data
	calla	get_player_record

	calla	del_butn_box_stuff

	move	a10,a10				;a10=0 (rec. not found) else ptr. to rec.
	jrz	#rnf_1				;br=record NOT FOUND

;record found logic

	move	a10,@player_record_ptr,L	;save ptr. to record
	calla	init_player_ram_from_record

	clr	a0
	calla	print_record_availablity_msg
	jruc	#wait_1


;record not found logic
#rnf_1
	calla	init_player_record_and_ram

	calla	get_free_record
	move	a10,@player_record_ptr,L	;save ptr. to record

	movk	1,a0
	calla	print_record_availablity_msg
#wait_1
	CREATE0	plyr_dribbling_ball
	callr	stats_area_setup
	rets


;-----------------------------------------------------------------------------
;	 This routine creates the buttons and shadows and controls
;  the cursor for selection, then the button is blinked when selected
;
; INPUT: reg. a10 - player number or > (table index for button positions)
; OUTPUT: reg a11 - cursor position (yes or no)
;-----------------------------------------------------------------------------
 SUBR	ask_yes_no			;ret. a0=answer (1=yes else 0)

	PUSHP	a8,a9,a10
	cmpi	4,a10
	jrlo	ayn_0				;br=a player
	calla	create_yes_no_buttons		;ret. a8-a9 ptrs. to obj
     	jruc	ayn_1
ayn_0	calla	create_small_yes_no_butns
ayn_1 
	movk	1,a11				;default to 'NO'
	movi	5*TSEC,a10			;timeout counter (5 sec)
sae_1
 	SLEEPK	1

	move	@GAMSTATE,a0
	cmpi	INPLYRDESIGN,a0
	jrne	sae_11
	move	@done_creating,a14
	jrnz	sae_11		
	movk	1,a11				;say 'NO'
	jruc	sae_4

;check for timeout
sae_11	dsj	a10,sae_1a			;br=dont time out...yet
	movk	1,a11				;DEFAULT to 'NO'
	calla	reset_yes_no_butn_pals
	jruc	sae_3

sae_1a
	calla	update_yes_no_button_pals

	move	*a13(PC_PLAYNUM),a0
	calla	get_stick_val_down

	cmpi	JOY_UP,a0			;joystick up ?
	jrne	sae_1b				;br=nope
	move	a11,a11
	jrz	sae_2a				;br=cursor already on 'YES'
	clr	a11				;set to 'YES'
	calla	reset_yes_no_butn_pals

	move	*a13(PC_PLAYNUM),a0
	callr	cursor_sounds
	jruc	sae_2a

sae_1b	cmpi	JOY_DOWN,a0			;joystick down ?
	jrne	sae_2a				;br=nope
	move	a11,a11
	jrnz	sae_2a				;br=cursor already on 'NO'
	movk	1,a11				;set to 'NO'
	calla	reset_yes_no_butn_pals

	move	*a13(PC_PLAYNUM),a0
	callr	cursor_sounds
;
; Now, read buttons
;
sae_2a
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down

	cmpi	TURBO_BUTTON,a0
	jreq	sae_3
	cmpi	PASS_BUTTON,a0
	jreq	sae_3
	cmpi	SHOOT_BUTTON,a0
	jrne	sae_1
sae_3
	move	*a13(PC_PLAYNUM),a0
	sll	5,a0
 	addi	yesno_sel_snds,a0
	move	*a0,a0,L
 	calla	snd_play1

	calla	stop_clock_timer
	JSRP	flash_pressed_yes_no_button
	calla	restart_clock_timer
	calla	del_butn_box_stuff
sae_4
	PULLP	a8,a9,a10
	RETP

;-----------------------------------------------------------------------------
;			 Make cursor sounds
;
;	INPUT: a0 - player number
;-----------------------------------------------------------------------------
 SUBR	cursor_sounds

	sll	5,a0
 	addi	yesno_cur_snds,a0
	move	*a0,a0,L
 	calla	snd_play1
	rets


yesno_cur_snds
	.long	yes_no_cur1,yes_no_cur2,yes_no_cur3,yes_no_cur4

yesno_sel_snds
	.long	yes_no_sel1,yes_no_sel2,yes_no_sel3,yes_no_sel4

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBRP	save_and_exit_cursor_control

	calla	print_ask_exit
	movk	4,a10
	JSRP	ask_yes_no
	move	a11,a11
	jrne	no_1				;br=nope

;chose 'YES' ,save & exit

	movi	CLOCK_PID,a0
	calla	KIL1C				;kill clock timer
	clr	a0
	move	a0,@done_creating		;goto ATTRACT MODE
	jruc	dne_1

;chose 'NO' ,not to save & exit
no_1
	calla	del_butn_box_stuff
dne_1 	RETP

;-----------------------------------------------------------------------------
; 	Restart PLAYER DESIGN clock from timing down
;-----------------------------------------------------------------------------
 SUBR	restart_clock_timer

	clr	a0
	move	a0,@stop_clock
	rets

;-----------------------------------------------------------------------------
; 	Stop PLAYER DESIGN clock from timing down
;-----------------------------------------------------------------------------
 SUBR	stop_clock_timer

	movk	1,a0
	move	a0,@stop_clock
	rets


;----------- TABLES ------------
;----------- TABLES ------------
;----------- TABLES ------------
;----------- TABLES ------------

str_slash	.string	"/",0
	.even

;palettes

BSGRNF1_P:
   .word   172
   .word   00000h,00fe8h,00fa7h,00f87h,01367h,01346h,01306h,012e6h
   .word   012c6h,01285h,01265h,01245h,00e24h,00de4h,00dc4h,00da3h
   .word   00d83h,00943h,00922h,00902h,008e2h,004a1h,00080h,00040h
   .word   00020h,0156bh,0114ah,00d28h,00927h,00505h,004e4h,00105h
   .word   000a2h,000a1h,03818h,03816h,03416h,03815h,03813h,03014h
   .word   02c73h,03811h,02c92h,02c14h,03013h,02c13h,02813h,02891h
   .word   02c12h,03011h,02812h,02851h,02c11h,02831h,0300fh,02412h
   .word   02811h,02c4fh,02c10h,02411h,02450h,02810h,02c0fh,02430h
   .word   02011h,02c0eh,02410h,0280fh,02c0dh,02010h,0204fh,02c0ch
   .word   0240fh,0280eh,0282dh,0246dh,0242eh,0200fh,0280dh,01cadh
   .word   0240eh,020ach,0280ch,0242dh,0200eh,0280bh,0240dh,0242ch
   .word   01c4dh,01c0eh,0240ch,0200dh,0240bh,01c0dh,0204bh,0240ah
   .word   0200ch,0180dh,0202bh,01c0ch,0200bh,0202ah,01c2bh,0200ah
   .word   0180ch,014a9h,0184bh,01c0bh,02009h,01889h,0180bh,01c0ah
   .word   01c29h,0140bh,01c09h,0180ah,01c08h,01829h,0140ah,01848h
   .word   01809h,01468h,01828h,0100ah,01409h,01808h,01428h,01807h
   .word   01009h,01408h,01446h,00c67h,01427h,01008h,01407h,01426h
   .word   01027h,00c08h,01406h,01007h,01405h,01026h,00c07h,01045h
   .word   00c64h,01006h,01025h,00863h,00c06h,01005h,00463h,01004h
   .word   00806h,00c05h,00c24h,00805h,00c04h,00c03h,00804h,00823h
   .word   00404h,00803h,00822h,00802h,00403h,00422h,00421h,00402h
   .word   00401h,00001h,00000h,00000h

BSGRNF2_P:
   .word   172
   .word   00000h,01febh,01fcah,01f8ah,01f6ah,01f4ah,0232ah,0230ah
   .word   022e9h,022c9h,022a9h,02289h,02268h,01e48h,01e28h,01e07h
   .word   01de7h,01dc7h,019a6h,01986h,01966h,00d03h,004c1h,00060h
   .word   00020h,01e10h,019cdh,011abh,00d69h,00947h,00567h,00169h
   .word   000c2h,000a1h,03818h,03816h,03416h,03815h,03813h,03014h
   .word   02c73h,03811h,02c92h,02c14h,03013h,02c13h,02813h,02891h
   .word   02c12h,03011h,02812h,02851h,02c11h,02831h,0300fh,02412h
   .word   02811h,02c4fh,02c10h,02411h,02450h,02810h,02c0fh,02430h
   .word   02011h,02c0eh,02410h,0280fh,02c0dh,02010h,0204fh,02c0ch
   .word   0240fh,0280eh,0282dh,0246dh,0242eh,0200fh,0280dh,01cadh
   .word   0240eh,020ach,0280ch,0242dh,0200eh,0280bh,0240dh,0242ch
   .word   01c4dh,01c0eh,0240ch,0200dh,0240bh,01c0dh,0204bh,0240ah
   .word   0200ch,0180dh,0202bh,01c0ch,0200bh,0202ah,01c2bh,0200ah
   .word   0180ch,014a9h,0184bh,01c0bh,02009h,01889h,0180bh,01c0ah
   .word   01c29h,0140bh,01c09h,0180ah,01c08h,01829h,0140ah,01848h
   .word   01809h,01468h,01828h,0100ah,01409h,01808h,01428h,01807h
   .word   01009h,01408h,01446h,00c67h,01427h,01008h,01407h,01426h
   .word   01027h,00c08h,01406h,01007h,01405h,01026h,00c07h,01045h
   .word   00c64h,01006h,01025h,00863h,00c06h,01005h,00463h,01004h
   .word   00806h,00c05h,00c24h,00805h,00c04h,00c03h,00804h,00823h
   .word   00404h,00803h,00822h,00802h,00403h,00422h,00421h,00402h
   .word   00401h,00001h,00000h,00000h

BSGRNF3_P:
   .word   172
   .word   0318ch,057f9h,053d8h,053b7h,04f96h,04f96h,04b75h,04b54h
   .word   04733h,04733h,04312h,042f1h,03ed1h,03ed0h,03aafh,03a8fh
   .word   03a8eh,0366dh,0364dh,0322ch,0322ch,029aah,01d27h,010a4h
   .word   00421h,0360eh,04272h,03e51h,03e30h,03a0fh,035efh,035ceh
   .word   02d6bh,014a5h,03818h,03816h,03416h,03815h,03813h,03014h
   .word   02c73h,03811h,02c92h,02c14h,03013h,02c13h,02813h,02891h
   .word   02c12h,03011h,02812h,02851h,02c11h,02831h,0300fh,02412h
   .word   02811h,02c4fh,02c10h,02411h,02450h,02810h,02c0fh,02430h
   .word   02011h,02c0eh,02410h,0280fh,02c0dh,02010h,0204fh,02c0ch
   .word   0240fh,0280eh,0282dh,0246dh,0242eh,0200fh,0280dh,01cadh
   .word   0240eh,020ach,0280ch,0242dh,0200eh,0280bh,0240dh,0242ch
   .word   01c4dh,01c0eh,0240ch,0200dh,0240bh,01c0dh,0204bh,0240ah
   .word   0200ch,0180dh,0202bh,01c0ch,0200bh,0202ah,01c2bh,0200ah
   .word   0180ch,014a9h,0184bh,01c0bh,02009h,01889h,0180bh,01c0ah
   .word   01c29h,0140bh,01c09h,0180ah,01c08h,01829h,0140ah,01848h
   .word   01809h,01468h,01828h,0100ah,01409h,01808h,01428h,01807h
   .word   01009h,01408h,01446h,00c67h,01427h,01008h,01407h,01426h
   .word   01027h,00c08h,01406h,01007h,01405h,01026h,00c07h,01045h
   .word   00c64h,01006h,01025h,00863h,00c06h,01005h,00463h,01004h
   .word   00806h,00c05h,00c24h,00805h,00c04h,00c03h,00804h,00823h
   .word   00404h,00803h,00822h,00802h,00403h,00422h,00421h,00402h
   .word   00401h,00001h,00000h,00000h

BSGRNF4_P:
   .word   172
   .word   00000h,057f9h,057d8h,057d8h,057d8h,057b7h,053b7h,053b7h
   .word   05396h,05396h,05396h,05376h,05375h,05375h,05355h,05355h
   .word   05354h,05354h,05334h,05334h,05334h,04270h,02dabh,018e6h
   .word   00421h,04f15h,04af4h,04ad4h,046b4h,04693h,04673h,04252h
   .word   04252h,014a5h,03818h,03816h,03416h,03815h,03813h,03014h
   .word   02c73h,03811h,02c92h,02c14h,03013h,02c13h,02813h,02891h
   .word   02c12h,03011h,02812h,02851h,02c11h,02831h,0300fh,02412h
   .word   02811h,02c4fh,02c10h,02411h,02450h,02810h,02c0fh,02430h
   .word   02011h,02c0eh,02410h,0280fh,02c0dh,02010h,0204fh,02c0ch
   .word   0240fh,0280eh,0282dh,0246dh,0242eh,0200fh,0280dh,01cadh
   .word   0240eh,020ach,0280ch,0242dh,0200eh,0280bh,0240dh,0242ch
   .word   01c4dh,01c0eh,0240ch,0200dh,0240bh,01c0dh,0204bh,0240ah
   .word   0200ch,0180dh,0202bh,01c0ch,0200bh,0202ah,01c2bh,0200ah
   .word   0180ch,014a9h,0184bh,01c0bh,02009h,01889h,0180bh,01c0ah
   .word   01c29h,0140bh,01c09h,0180ah,01c08h,01829h,0140ah,01848h
   .word   01809h,01468h,01828h,0100ah,01409h,01808h,01428h,01807h
   .word   01009h,01408h,01446h,00c67h,01427h,01008h,01407h,01426h
   .word   01027h,00c08h,01406h,01007h,01405h,01026h,00c07h,01045h
   .word   00c64h,01006h,01025h,00863h,00c06h,01005h,00463h,01004h
   .word   00806h,00c05h,00c24h,00805h,00c04h,00c03h,00804h,00823h
   .word   00404h,00803h,00822h,00802h,00403h,00422h,00421h,00402h
   .word   00401h,00001h,00000h,00000h

BSGRNF5_P:
   .word   172
   .word   0318ch,07fffh,07fffh,07fffh,07bdeh,07bdeh,07bdeh,07bdeh
   .word   07bdeh,07bdeh,07bdeh,07bdeh,07bdeh,07bdeh,07bdeh,07bdeh
   .word   07bdeh,07bdeh,07bdeh,07bdeh,07fffh,04a52h,0318ch,018c6h
   .word   00421h,06318h,06318h,05ad6h,05ef7h,056b5h,05294h,04e73h
   .word   0318ch,014a5h,03818h,03816h,03416h,03815h,03813h,03014h
   .word   02c73h,03811h,02c92h,02c14h,03013h,02c13h,02813h,02891h
   .word   02c12h,03011h,02812h,02851h,02c11h,02831h,0300fh,02412h
   .word   02811h,02c4fh,02c10h,02411h,02450h,02810h,02c0fh,02430h
   .word   02011h,02c0eh,02410h,0280fh,02c0dh,02010h,0204fh,02c0ch
   .word   0240fh,0280eh,0282dh,0246dh,0242eh,0200fh,0280dh,01cadh
   .word   0240eh,020ach,0280ch,0242dh,0200eh,0280bh,0240dh,0242ch
   .word   01c4dh,01c0eh,0240ch,0200dh,0240bh,01c0dh,0204bh,0240ah
   .word   0200ch,0180dh,0202bh,01c0ch,0200bh,0202ah,01c2bh,0200ah
   .word   0180ch,014a9h,0184bh,01c0bh,02009h,01889h,0180bh,01c0ah
   .word   01c29h,0140bh,01c09h,0180ah,01c08h,01829h,0140ah,01848h
   .word   01809h,01468h,01828h,0100ah,01409h,01808h,01428h,01807h
   .word   01009h,01408h,01446h,00c67h,01427h,01008h,01407h,01426h
   .word   01027h,00c08h,01406h,01007h,01405h,01026h,00c07h,01045h
   .word   00c64h,01006h,01025h,00863h,00c06h,01005h,00463h,01004h
   .word   00806h,00c05h,00c24h,00805h,00c04h,00c03h,00804h,00823h
   .word   00404h,00803h,00822h,00802h,00403h,00422h,00421h,00402h
   .word   00401h,00001h,00000h,00000h

BSHDRED_P:
   .word   172
   .word   00000h,07020h,06820h,06420h,06020h,05c20h,05820h,05420h
   .word   05020h,04820h,04420h,04020h,03c20h,03820h,03420h,03020h
   .word   02c20h,02820h,02420h,02020h,01c20h,01800h,01000h,00c00h
   .word   00800h,04000h,03088h,02c67h,02846h,02424h,02003h,02000h
   .word   01801h,01401h,03818h,03816h,03416h,03815h,03813h,03014h
   .word   02c73h,03811h,02c92h,02c14h,03013h,02c13h,02813h,02891h
   .word   02c12h,03011h,02812h,02851h,02c11h,02831h,0300fh,02412h
   .word   02811h,02c4fh,02c10h,02411h,02450h,02810h,02c0fh,02430h
   .word   02011h,02c0eh,02410h,0280fh,02c0dh,02010h,0204fh,02c0ch
   .word   0240fh,0280eh,0282dh,0246dh,0242eh,0200fh,0280dh,01cadh
   .word   0240eh,020ach,0280ch,0242dh,0200eh,0280bh,0240dh,0242ch
   .word   01c4dh,01c0eh,0240ch,0200dh,0240bh,01c0dh,0204bh,0240ah
   .word   0200ch,0180dh,0202bh,01c0ch,0200bh,0202ah,01c2bh,0200ah
   .word   0180ch,014a9h,0184bh,01c0bh,02009h,01889h,0180bh,01c0ah
   .word   01c29h,0140bh,01c09h,0180ah,01c08h,01829h,0140ah,01848h
   .word   01809h,01468h,01828h,0100ah,01409h,01808h,01428h,01807h
   .word   01009h,01408h,01446h,00c67h,01427h,01008h,01407h,01426h
   .word   01027h,00c08h,01406h,01007h,01405h,01026h,00c07h,01045h
   .word   00c64h,01006h,01025h,00863h,00c06h,01005h,00463h,01004h
   .word   00806h,00c05h,00c24h,00805h,00c04h,00c03h,00804h,00823h
   .word   00404h,00803h,00822h,00802h,00403h,00422h,00421h,00402h
   .word   00401h,00001h,00000h,00000h


BTGRNF1_P:
   .word   32 
   .word   0318ch,00fe7h,00be5h,00be5h,00be4h,00bc4h,00ba4h,00b84h
   .word   00b83h,00b63h,00b43h,00b23h,00b03h,00ae3h,00ac3h,00aa3h
   .word   00a83h,00a63h,00a62h,00a43h,00a42h,00a22h,00a02h,009e2h
   .word   009c2h,009a2h,00982h,00962h,00942h,00922h,00902h,008e2h

BTGRNF2_P:
   .word   32 
   .word   0318ch,01febh,01be9h,01be9h,01be8h,01be8h,01be8h,01be8h
   .word   01be7h,01be7h,01bc7h,01ba7h,01b87h,01b67h,01b47h,01b27h
   .word   01b07h,01ae7h,01ae6h,01ac7h,01ac6h,01aa6h,01a86h,01a66h
   .word   01a46h,01a26h,01a06h,019e6h,019c6h,019a6h,01986h,01966h

BTGRNF3_P:
   .word   32 
   .word   0318ch,037f1h,033efh,033efh,033eeh,033eeh,033eeh,033eeh
   .word   033edh,033edh,033edh,033edh,033edh,033edh,033edh,033edh
   .word   033cdh,033adh,033ach,0338dh,0338ch,0336ch,0334ch,0332ch
   .word   0330ch,032ech,032cch,032ach,0328ch,0326ch,0324ch,0322ch

BTGRNF4_P:
   .word   32 
   .word   0318ch,057f9h,053f7h,053f7h,053f6h,053f6h,053f6h,053f6h
   .word   053f5h,053f5h,053f5h,053f5h,053f5h,053f5h,053f5h,053f5h
   .word   053f5h,053f5h,053f4h,053f5h,053f4h,053f4h,053f4h,053f4h
   .word   053f4h,053f4h,053d4h,053b4h,05394h,05374h,05354h,05334h

BTGRNF5_P:
   .word   32 
   .word   0318ch,07fffh,07bffh,07bffh,07bffh,07bffh,07bffh,07bffh
   .word   07bffh,07bffh,07bffh,07bffh,07bffh,07bffh,07bffh,07bffh
   .word   07bffh,07bffh,07bfeh,07bffh,07bfeh,07bfeh,07bfeh,07bfeh
   .word   07bfeh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh


BUTRED_P:
   .word   32 
   .word   00000h,07c25h,07c04h,07c04h,07804h,07403h,07003h,06c03h
   .word   06c02h,06802h,06402h,06002h,05c01h,05801h,05401h,05401h
   .word   05000h,04c00h,04800h,04400h,04000h,03c00h,03800h,03800h
   .word   03400h,03000h,02c00h,02800h,02400h,02000h,01c00h,01c00h



;
; This table contains:
;
; 1) Value to update (when read a joystick LEFT or RIGHT)
;
attrib_ram_value_ptr_table
	.long	height_points
	.long	weight_points
attrib_ram_value_ptr_table2	     ;for player dribbling ball (no height and weight)
	.long	speed_points
	.long	power_points
	.long	shoot_points
	.long	dunks_points
	.long	steal_points
	.long	block_points
attrib_ram_value_ptr_table_end

attribute_adjust_amount_table
	.word	1			;height_points
	.word	1			;weight_points
	.word	1			;speed_points
	.word	1			;power_points
	.word	1			;shoot_points
	.word	1			;dunks_points
	.word	1			;steal_points
	.word	1			;block_points

;
; This table contains the following info:
;
;   1) Y coor
;   2) ptr. to Attribute bar end img
;   3) ptr. to Attribute bar notches
;

attribute_setup_table
 .long	[ATTRY,0],ATT_HT,END_HT
 .long	[ATTRY-1,0],ATT_WT,END_WT
 .long	[ATTRY-2,0],ATT_SP,END_SP
 .long	[ATTRY-3,0],ATT_PW,END_PW
 .long	[ATTRY-4,0],ATT_SH,END_SH
 .long	[ATTRY-5,0],ATT_DU,END_DU
 .long	[ATTRY-6,0],ATT_ST,END_ST
 .long	[ATTRY-7,0],ATT_BL,END_BL
attribute_setup_end



small_attrib_bar_img_tbl
	.long	ATTBAR00
	.long	ATTBAR01
	.long	ATTBAR02
	.long	ATTBAR03
	.long	ATTBAR04
	.long	ATTBAR05
	.long	ATTBAR06
	.long	ATTBAR07
	.long	ATTBAR08
	.long	ATTBAR09
	.long	ATTBAR10


big_attrib_bar_img_tbl
	.long	NOTCH_00	 ;this should be zero
	.long	NOTCH_01
	.long	NOTCH_02
	.long	NOTCH_03
	.long	NOTCH_04
	.long	NOTCH_05
	.long	NOTCH_06
	.long	NOTCH_07
	.long	NOTCH_08
	.long	NOTCH_09
	.long	NOTCH_10



;for entering game name during CREATE PLAYER
enter_name_menu
	.long	enm1
	.long	enm2
enm1	
	.word	4			;5th palette in '#palettes' table (select.asm)
	.word	148,60			;x,y start
	.long	name_table		;table
enm2
	.word	4			;palette
	.word	139,79			;x,y start
	.long	pin_nbr_table



; 
; Routines to dispatch when button is selected
;
butn_routine_table
	.long	show_players_stats_cursor_cntrl
	.long	pick_plyr_head_cntrl
	.long	choose_uniform_color_cntrl
	.long	attribute_cursor_cntrl
	.long	plyr_privileges_cursor_cntrl
	.long	choose_nick_name_cntrl
	.long	change_players_game_name
	.long	save_and_exit_cursor_control

;
; This table contains the following info:
;
;   1. X position (of all objects)
;   2. Y position (of all objects)
;   3. ptr. to left half of button shadow img
;   3. ptr. to right half of button shadow img
;   5. ptr. to button img
;   6. ptr. to button text img
;
butn_setup_table
	.long	55<<16,35<<16,BSHAD_A1,BSHAD_A2,BUTTON_A, 47<<16,TXT_VIEW
	.long	55<<16,35<<16,BSHAD_B1,BSHAD_B2,BUTTON_B, 73<<16,TXT_HEAD
	.long	55<<16,35<<16,BSHAD_C1,BSHAD_C2,BUTTON_C, 99<<16,TXT_UNIFRM
	.long	55<<16,35<<16,BSHAD_D1,BSHAD_D2,BUTTON_D,125<<16,TXT_ATTR
	.long	55<<16,35<<16,BSHAD_E1,BSHAD_E2,BUTTON_E,151<<16,TXT_PRIV
	.long	55<<16,35<<16,BSHAD_F1,BSHAD_F2,BUTTON_F,176<<16,TXT_NICK1
	.long	55<<16,35<<16,BSHAD_G1,BSHAD_G2,BUTTON_G,203<<16,TXT_NEWN
	.long	55<<16,35<<16,BSHAD_H1,BSHAD_H2,BUTTON_H,229<<16,TXT_SAVE
butn_setup_table_end


;
; Table containing setup information for the 'CREATE PLAYER' background
;
create_player_mod
	.long	SPORTBGBMOD
	.word	0,0		;x,y
	.long	0


******************************************************************************

	.end
