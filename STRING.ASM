****************************************************************
*
* Owner:	JOHNSON
*
* Software:	Jamie Rivett
* Initiated:	
*
* Modified:
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 8/10/95 4:29
****************************************************************
	.file	"string.asm"
	.title	"string printing stuff"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"imgtbl.glo"
	.include	"bgndtbl.glo"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"macros.hdr"
	.include	"hangfont.tbl"
	.include	"imgpal7.asm"
	.include	"imgtbl7.glo"
	.include	"bastcyc.tbl"


;sounds

	.def	CHI_RODBP
	.def	CHI_RODOP
	.def	CHI_RODPP
	.def	CHI_RODRP
	.def	CHI_RODWP
	.def	CHI_RODYP
	.def	CHI_RODGP
	.def	CHI_RODKP


;symbols defined externally

	.ref	TWOPLAYERS			;0 = NO, 1 = YES 2 players
	.global	player1_data,player2_data,player3_data,player4_data

	.global	initials_entry
	.global	cmos_test

	.ref	P1DATA,P2DATA,P3DATA,P4DATA
	.ref	sorted_teams,teams_pop
	.ref	team1,team2

	.ref	BINBCD
	.ref	CRED_P
	.ref	PCNT
	.ref	pal_find
	.ref	switches_old
	.ref	switches_cur
	.ref	switches_down
	.ref	adv_stats
	.ref	stx_avgallow,stx_avgscore
	.ref	compute_plyr_off_rank,compute_plyr_def_rank
	.ref	SENDTO,ENTRIES

;symbols defined in this file

	.def	prizeg_p,prize1_p,prize2_p,prize3_p
	.def	print_string2b,kern_chars,mess_justify,mess_cursx2
	.def	print_teams_defeated
	.def	clear_buffers
	.def	SENDTO_P

;	.global	print_ranking
	.global	message_palette
	.global	mess_space_width
	.global	print_string,print_string2,print_string_C,print_string_C2
	.global	print_string_R,print_string_R2
	.global	message_ascii
	.global	mess_spacing
	.global	mess_objid
	.global	mess_cursx
	.global	mess_cursy
	.global	brush10_ascii,brush12_ascii
	.global	brush20_ascii,bast18_ascii,inga16_ascii
	.global	brush50_ascii
	.global	bast7t_ascii,bast7tcyc_ascii
	.global	hangfnt38_ascii
	.global	bast8_ascii,bast10_ascii
	.global	bast8t_ascii,bast8tcyc_ascii
;	.global	osgemd_ascii
;	.global	omlgmd_ascii
	.global	message_buffer
;	.global	get_initials_string
	.global	dec_to_asc,dec_to_pct
	.global	copy_string,copy_rom_string
	.global	concat_string,concat_rom_string
	.global	print_message,setup_message
	.global	mess_line_spacing
	.global	get_name_string


MBUFF_SIZE	equ	40

;ram
	.bss	message_ascii,	32	;* ascii lookup table
	.bss	message_palette,32	;* palette
	.bss	message_buffer,	16*MBUFF_SIZE ;null terminated string
	.bss	message_buffer2, 16*MBUFF_SIZE
	.bss	mess_cursx,	16	;message cursor pos X original
	.bss	mess_cursx2,	16	;message cursor pos X temp
	.bss	mess_cursy,	16	;message cursor pos Y
	.bss	mess_space_width, 16	;width in pixels of space char
	.bss	mess_spacing,16		;spacing between chars
	.bss	mess_line_spacing,16	;spacing between lines
	.bss	mess_objid,16		;OBJECT ID for string
	.bss	mess_justify,32		;justification method
	.bss	ptr_player_data,32	;start address of player data
	.text


#*****************************************************************************

 SUBRP	clear_buffers

	callr	clear_buffer
	callr	clear_buffer2
	rets

clear_buffer
	movi	MBUFF_SIZE,a2
	clr	a0
	movi	message_buffer,a1
#clear_loop1
	move	a0,*a1+
	dsj	a2,#clear_loop1
	rets

clear_buffer2
	movi	MBUFF_SIZE,a2
	clr	a0
	movi	message_buffer2,a1
#clear_loop2
	move	a0,*a1+
	dsj	a2,#clear_loop2
	rets


#*****************************************************************************
* INPUT:	a3 = * string dest
*		a4 = * name string
*-----------------------------------------------------------------------------
 SUBRP	get_name_string

;clear out space for 6 characters (bytes) and a null terminator
	clr	a0
	move	a0,*a3,L			;null terminate
	move	a0,*a3(20h),L			;null terminate

	movi	init_convert_table,a5
;1st letter
	move	*a4+,a0				;get LETTER nbr. from record
	jrz	#no_more
	sll	4,a0				;*16
	add	a5,a0
	move	*a0,a0				;get ascii LETTER from table
	movb	a0,*a3

;2nd letter
	move	*a4+,a0
	jrz	#no_more
	sll	4,a0
	add	a5,a0
	move	*a0,a0
	movb	a0,*a3(8h)

;3rd letter
	move	*a4+,a0
	jrz	#no_more
	sll	4,a0
	add	a5,a0
	move	*a0,a0
	movb	a0,*a3(10h)

;4th letter
	move	*a4+,a0
	jrz	#no_more
	sll	4,a0
	add	a5,a0
	move	*a0,a0
	movb	a0,*a3(18h)

;5th letter
	move	*a4+,a0
	jrz	#no_more
	sll	4,a0
	add	a5,a0
	move	*a0,a0
	movb	a0,*a3(20h)

;6th letter
	move	*a4,a0
	jrz	#no_more
	sll	4,a0
	add	a5,a0
	move	*a0,a0
	movb	a0,*a3(28h)
#no_more
	rets


#*****************************************************************************
*-----------------------------------------------------------------------------


	.ref	get_but_val_cur
	.ref	get_but_val_down
	.ref	check_world_records
	.ref	get_opponent_team
	.ref	find_record,get_plr_rank
	.ref	GAMSTATE,create_heading

	.asg	28,LINE1_Y
	.asg	88,LINE6_Y

	.asg	10,ONE_LINE_SPC
	.asg	20,TWO_LINE_SPC



 SUBR	print_player_stats

;PAGE 1 of STATS
	callr	setup_page	

	move	*a13(PC_DATADDR),a2,L	;start of player data
;	move	*a2(PR_CREATED_PLYR),a0
;	jrp	#has_record

	move	*a2(PR_WON),a0
	move	*a2(PR_LOST),a1
	add	a0,a1
	jrnz	#has_record

	movi	LINE6_Y,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	str_norecord,a4		;"NO RECORD"
	callr	print_string_C2		;already centered

	SLEEPK	15			;minimum time to hold for

	movi	3*TSEC,a10
#pps1	SLEEPK	1
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down
	jrnz	#pps2
	dsj	a10,#pps1
#pps2	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	calla	obj_del1c		;delete all objs with this ID
	RETP

#has_record
	movk	5,a0
	move	a0,@mess_space_width

;------------------------
;print players overall rank
;
	movi	LINE1_Y,a0
	move	@GAMSTATE,a14
	cmpi	INPLYRDESIGN,a14
	jrne	#ntcp
	movi	LINE6_Y,a0
#ntcp	move	a0,@mess_cursy		;message cursor pos X

;overall rank
	movi	str_ovr_rnk,a4
	callr	print_string_C2

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_RANK),a0		;rank
	movi	999,a1			;max value
	callr	dec_to_asc

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC,a0
	move	a0,@mess_cursy
	callr	print_string_C3		;centered

;------------------------
;print players w/l record
;
	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC-2,a0
	move	a0,@mess_cursy
	movi	str_line0b,a4		;"RECORD:"
	callr	print_string_C2		;centered

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	ONE_LINE_SPC,a0
	move	a0,@mess_cursy

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_WON),a0		;games won
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	copy_string
	movi	str_w,a4
	callr	concat_rom_string
	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_LOST),a0		;games lost
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	concat_string
;;	movi	str_l,a4
;;	callr	concat_rom_string
	callr	print_string_C		;centered

	move	@mess_cursy,a0
	addi	ONE_LINE_SPC,a0
	move	a0,@mess_cursy

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_LOST),a2		;games lost
	jrz	#no_losses
; % < 1000
	movi	str_line0d,a4		;"PCT: ."
	callr	copy_rom_string
	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_LOST),a2		;games lost
	move	*a0(PR_WON),a1		;games won
	add	a1,a2			;total games
	movi	1000,a0
	mpys	a0,a1			;games won * 1000
	divs	a2,a1			;/ total games
	move	a1,a0
	callr	dec_to_pct
	callr	concat_string
	callr	print_string_C		;centered
	jruc	#skip_loss

#no_losses
	movi	str_line0d1,a4		;"PCT: 1.000"
	callr	print_string_C2		;centered

#skip_loss

;------------------------
;defensive rank
	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC-2,a0
	move	a0,@mess_cursy
	movi	str_def_rnk,a4
	callr	print_string_C2

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a1
	addi	TWO_LINE_SPC,a1
	move	a1,@mess_cursy

	move	*a13(PC_DATADDR),a6,L	;start of player data
	calla	find_record		;ret a11 - rec. number
	move	a11,a4
	calla	get_plr_rank
	move	*a9,a8,L

	move	*a8(RS_GAMES_PLAYED),a1
	subk	5,a1
	jrge	#defr			;br=at least 5 games played
	movi	str_na,a4
	callr	print_string_C2
	jruc	#offr
#defr
	move	*a8(RS_DEF_RANK),a0
	calla	compute_plyr_def_rank
	movi	NUM_PRECORDS,a1				;max value
	callr	dec_to_asc
	callr	print_string_C3		;centered
	
;------------------------
;offensive rank
#offr
	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC-2,a0
	move	a0,@mess_cursy
	movi	str_off_rnk,a4
	callr	print_string_C2

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

;	move	a11,a4
;	calla	get_plr_rank
;	move	*a9,a8,L

	move	@mess_cursy,a1
	addi	TWO_LINE_SPC,a1
	move	a1,@mess_cursy

	move	*a8(RS_GAMES_PLAYED),a1
	subk	5,a1
	jrge	#offr1			;br=at least 5 games played
	movi	str_na,a4
	callr	print_string_C2
	jruc	#pg01
#offr1
	move	*a8(RS_OFF_RANK),a0
	calla	compute_plyr_off_rank
	movi	NUM_PRECORDS,a1				;max value
	callr	dec_to_asc
	callr	print_string_C3		;centered
#pg01
	SLEEPK	15			;minimum time to hold for

	movi	8*TSEC,a10
#pg1	SLEEPK	1
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down
	jrnz	#pg1a
	dsj	a10,#pg1
#pg1a	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	calla	obj_del1c		;delete all objs with this ID

	SOUND1	adv_stats

;PAGE 2 of STATS
;------------------------
;print players win streak

	calla	create_heading
	callr	setup_page	

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_WINSTREAK),a0	;no. consecutive wins

	movi	LINE1_Y,a0
	move	@GAMSTATE,a14
	cmpi	INPLYRDESIGN,a14
	jrne	#ntcp2
	movi	LINE6_Y,a0
#ntcp2	move	a0,@mess_cursy		;message cursor pos X

	movi	str_streak,a4
	callr	print_string_C2

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC,a0
	move	a0,@mess_cursy
	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_WINSTREAK),a0	;no. consecutive wins
	jrnz	#not0
	movi	str_none,a4
	callr	print_string_C2
	jruc	#contws
#not0
	PUSH	a0
	movi	99,a1			;max value
	callr	dec_to_asc
	callr	copy_string
	PULL	a0
	movi	str_wins,a4
	dec	a0
	jrnz	#iswins
	movi	str_win,a4
#iswins
	callr	concat_rom_string
	callr	print_string_C
#contws

;------------------------------
;print players avg. pts. scored
	
	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC-2,a0
	move	a0,@mess_cursy
	movi	str_pts_scrd,a4
	callr	print_string_C2

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC,a0
	move	a0,@mess_cursy

	move	*a13(PC_DATADDR),a14,L	;start of player data
	move	*a14(PR_PTS_SCORED),a0
	movi	100,a1			;2 decimal place purcision
	mpyu	a0,a1			;wins*1000
	move	*a14(PR_COUNT),a0	;games played
	divu	a0,a1			;wins*1000/played
	move	a1,a7
	jrz	#ptss			;br="00.00"
	clr	a6
	movi	100,a1				;max value
	divu	a1,a6
	move	a6,a0
	movi	99,a1				;max value
	callr	dec_to_asc
	callr	copy_string

	movi	str_dot,a4
	calla	concat_rom_string

	move	a7,a0
	movi	99,a1				;max value
	callr	dec_to_asc
	callr	concat_string
	callr	print_string_C
	jruc	#ptss1

#ptss	movi	str_00,a4
	callr	print_string_C2
#ptss1

;-------------------------------
;print players avg. pts. allowed

	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC-2,a0
	move	a0,@mess_cursy

	movi	str_pts_allowd,a4
	callr	print_string_C2

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC,a0
	move	a0,@mess_cursy

	move	*a13(PC_DATADDR),a14,L	;start of player data
	move	*a14(PR_PTS_ALLOWED),a0
	movi	100,a1			;2 decimal place purcision
	mpyu	a0,a1			;wins*1000
	move	*a14(PR_COUNT),a0	;games played
	divu	a0,a1			;wins*1000/played
	move	a1,a7
	jrz	#ptsa			;br="00.00"
	clr	a6
	movi	100,a1				;max value
	divu	a1,a6
	move	a6,a0
	movi	99,a1				;max value
	callr	dec_to_asc
	callr	copy_string

	movi	str_dot,a4
	callr	concat_rom_string

	move	a7,a0
	movi	99,a1				;max value
	callr	dec_to_asc
	callr	concat_string
	callr	print_string_C
	jruc	#ptsa1

#ptsa	movi	str_00,a4
	callr	print_string_C2
#ptsa1

;---------------------------------------
;print players created player attrib. pts

	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC-2,a0
	move	a0,@mess_cursy
	movi	str_plr_att_pts,a4
	callr	print_string_C2

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC,a0
	move	a0,@mess_cursy

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_TOTAL_PTS),a14
	jrp	#not0a
	movi	str_none,a4
	callr	print_string_C2
	jruc	#contcp
#not0a
	clr	a1
	move	*a0(PR_HEIGHT_PTS),a14
	add	a14,a1
	move	*a0(PR_WEIGHT_PTS),a14
	add	a14,a1
	move	*a0(PR_SPEED_PTS),a14
	add	a14,a1
	move	*a0(PR_POWER_PTS),a14
	add	a14,a1
	move	*a0(PR_SHOOT_PTS),a14
	add	a14,a1
	move	*a0(PR_DUNKS_PTS),a14
	add	a14,a1
	move	*a0(PR_STEAL_PTS),a14
	add	a14,a1
	move	*a0(PR_BLOCKS_PTS),a14
	add	a14,a1
	move	*a0(PR_TOTAL_PTS),a0
	sub	a1,a0				;get points remaining
	movi	99,a1				;max value
	callr	dec_to_asc
	callr	copy_string

	movi	str_slash,a4
	calla	concat_rom_string

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_TOTAL_PTS),a0
	movi	99,a1				;max value
	callr	dec_to_asc
	callr	concat_string
	callr	print_string_C

;;	callr	print_string_C3		;centered
#contcp
	SLEEPK	15			;minimum time to hold for

	movi	8*TSEC,a10
#pg2	SLEEPK	1
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_cur
	jrnz	#pg2a
	dsj	a10,#pg2
#pg2a	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	calla	obj_del1c		;delete all objs with this ID

	SOUND1	adv_stats


;PAGE 3 of STATS

	calla	create_heading
	callr	setup_page	
;-----------------------------
;print players trivia points

	movi	LINE1_Y,a0
	move	@GAMSTATE,a14
	cmpi	INPLYRDESIGN,a14
	jrne	#ntcp3
	movi	LINE6_Y,a0
#ntcp3	move	a0,@mess_cursy		;message cursor pos X

;	movi	str_tourn_wins,a4
	movi	str_trivia_pts,a4
	callr	print_string_C2

	move	@mess_cursy,a0
	addi	ONE_LINE_SPC,a0
	move	a0,@mess_cursy

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L
	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_TRIVIA_PTS),a0	;no. consecutive wins
	jrnz	#trva
	movi	str_none,a4
	callr	print_string_C2
	jruc	#wrld1
#trva	movi	200,a1			;max value
	callr	dec_to_asc
	callr	print_string_C3		;centered

;----------------------------
; print players world records

#wrld1
	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC-2,a0
	move	a0,@mess_cursy

	movi	str_wrld_recs,a4
	callr	print_string_C2

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC,a0
	move	a0,@mess_cursy

	move	*a13(PC_DATADDR),a2,L	;start of player data
	calla	check_world_records

	sll	5,a14
	addi	num_str_tbl,a14
	move	*a14,a4,L

;	move	a14,a14
;	jrnz	#wrld2			;br=plyr has a WORLD RECORD
;
;
;	movi	str_none,a4
;	callr	print_string_C2
;	jruc	#nxtcpu
;
;#wrld2
;	movi	str_one,a4
;	srl	1,a14
;	jrc	#wrld3
;	movi	str_two,a4
;	srl	1,a14
;	jrc	#wrld3
;	movi	str_three,a4
;	srl	1,a14
;	jrc	#wrld3
;	movi	str_four,a4
#wrld3	callr	print_string_C2

;--------------------------------
; print players next CPU opponent
;
#nxtcpu
	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC-2,a0
	move	a0,@mess_cursy

	movi	str_next_cpu,a4
	callr	print_string_C2

	movi	BAST_W_P,a0
	move	a0,@message_palette,L
	move	@mess_cursy,a0
	addi	TWO_LINE_SPC,a0
	move	a0,@mess_cursy

	movi	bast8_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	move	*a13(PC_DATADDR),a1,L	;start of player data
	move	*a1(PR_TEAMSDEF),a1,L	;number teams defeated (in BITS!!)
;	andi	07ffffffh,a1
	andi	ALL_TMS_DEFEATD,a1
	calla	get_opponent_team
	move	a2,a0
	addi	90h,a0			;asc table cities start offset
	movb	a0,@message_buffer+00h
	clr	a0
	movb	a0,@message_buffer+08h
	callr	print_string_C

;----------------------------------
; print players team defeated count
;
	movi	bast8t_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	move	@mess_cursy,a0
	addi	TWO_LINE_SPC-2,a0
	move	a0,@mess_cursy

	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	movi	str_line11,a4		"DEFEATED NN"
	callr	copy_rom_string

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_NUMDEF),a0	;number teams defeated
	cmpi	NUM_TEAMS,a0
	jrlo	#not_all

	movi	str_all,a4		" ALL"
	callr	concat_rom_string
	jruc	#skipit
#not_all
	movi	NUM_TEAMS,a1		;max value
	callr	dec_to_asc
	callr	concat_string
#skipit
	callr	print_string_C		;centered

	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L

	move	@mess_cursy,a0
	addi	ONE_LINE_SPC,a0
	move	a0,@mess_cursy
	movi	str_line12,a4
	callr	print_string_C2		;centered

	move	@mess_cursy,a0
	addi	ONE_LINE_SPC+1,a0
	move	a0,@mess_cursy
	movi	str_line13,a4
	callr	print_string_C2		;centered

	SLEEPK	15			;minimum time to hold for

	movi	8*TSEC,a10
#pg3	SLEEPK	1
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_cur
	jrnz	#pg3a
	dsj	a10,#pg3
#pg3a	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	calla	obj_del1c		;delete all objs with this ID

	SOUND1	adv_stats

	RETP

	.ref	print_plr_password
;-----------------------------------------------------------------------------
;	This routine shows the trivia entry info
;
;
; INPUT: reg. a13 - process stack
;-----------------------------------------------------------------------------
 SUBR	show_trivia_stuff

	move	*a13(PC_PLAYNUM),a10
	move	*a13(PC_DATADDR),a9,L		;start of player data
	move	*a13(PC_OBJID),a1
	ori	10h,a1
	calla	print_plr_password

	move	*a13(PC_CENTERX),a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	sts_0
	move	*a13(PC_CENTERXkit),a0
sts_0
	sll	16,a0
	movk	24,a1
	sll	16,a1
	movi	SENDTO,a2,L
	movi	500,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	move	*a13(PC_OBJID),a5	;OBJ ID's created by this PROC
;	ori	10h,a5
	clr	a6
	clr	a7
	movi	SENDTO_P,b0,L		;* palette
	calla	BEGINOBJP2

	SLEEPK	15

	movi	4*TSEC,a10
sts_1	SLEEPK	1
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down
	jrz	sts_1			;br=no button pressed yet.
	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
;	ori	10h,a0
	calla	obj_del1c		;delete all objs with this ID

	move	*a13(PC_CENTERX),a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	sts_2
	move	*a13(PC_CENTERXkit),a0
sts_2
	sll	16,a0
	movk	24,a1
	sll	16,a1
	movi	ENTRIES,a2,L
	movi	500,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	move	*a13(PC_OBJID),a5	;OBJ ID's created by this PROC
	ori	10h,a5
	clr	a6
	clr	a7
	movi	SENDTO_P,b0,L		;* palette
	calla	BEGINOBJP2

	SLEEPK	15

	movi	6*TSEC,a10
sts_3	SLEEPK	1
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_down
	jrz	sts_3			;br=no button pressed yet.
	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	ori	10h,a0
	calla	obj_del1c		;delete all objs with this ID
 	RETP


SENDTO_P:
	.word	  4
	.word	00H,00H,07FFFH,07FE0H
	.even


;-----------------------------------------------------------------------------
;	This routine prints the TRIVIA CONTEST status when asking YES/NO
;
; INPUT: reg a10 - player number
;	 reg a13 - player cursor process
;-----------------------------------------------------------------------------
 SUBR	print_trivia_info

	move	a10,a0
	sll	4,a0
	addi	msg_id_tbl,a0
	move	*a0,a0
	move	a0,@mess_objid

	move	*a13(PC_CENTERX),a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	pti_0
	move	*a13(PC_CENTERXkit),a0
pti_0	move	a0,@mess_cursx		;message cursor pos X
	movi	LINE1_Y-2,a0
	move	a0,@mess_cursy		;message cursor pos y
	movk	5,a0
	move	a0,@mess_space_width
	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L
	movi	bast8t_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	movk	11,a0
	move	a0,@mess_line_spacing
	movi	trivia_qualify_str,a4,L
	calla	print_string_C2

	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L
	movi	LINE6_Y+8,a0
	move	a0,@mess_cursy		;message cursor pos y
	movi	trivia_show_info_str,a4,L
	calla	print_string_C2
	rets


msg_id_tbl
	.word	P1_BTUNS
	.word	P2_BTUNS
	.word	P3_BTUNS
	.word	P4_BTUNS


trivia_qualify_str
	.string	"YOU HAVE",1
	.string	"QUALIFIED",1
	.string	"TO ENTER",1
	.string	"THE TRIVIA",1
	.string	"CONTEST",1
	.string	"DRAWING",1
	.even

trivia_show_info_str
	.string	"SHOW INFO ?",0
	.even


#*****************************************************************************
******************************************************************************
 SUBRP	setup_page

	movi	BAST_Y_P,a1		;highlight cycle colour
	move	a1,@message_palette,L
	movk	5,a0
	move	a0,@mess_space_width
	movi	bast8t_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	move	a0,@mess_objid

	move	*a13(PC_CENTERX),a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#no2
	move	*a13(PC_CENTERXkit),a0
#no2	move	a0,@mess_cursx		;message cursor pos X
	rets

#*****************************************************************************
*-----------------------------------------------------------------------------
 SUBRP	print_teams_defeated

	.asg	10,HEADY
	.asg	36,TEAMY

	move	*a13(PC_DATADDR),a6,L		;start of player data

	move	*a13(PC_OBJID),a0		;OBJ ID's created by this PROC
	move	a0,@mess_objid

	movi	bast8t_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	movk	3,a0
	move	a0,@mess_space_width	;space char width
	movi	BAST_Y_P,a0
	move	a0,@message_palette,L

	move	*a13(PC_CENTERX),a0
	inc	a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#no_2p
	move	*a13(PC_CENTERXkit),a0
#no_2p
	move	a0,@mess_cursx		;message cursor pos X

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_NUMDEF),a0	;number teams defeated
	cmpi	15,a0			;defeated more than 15 teams?
	jrhs	#disp_undef

;disp defeated teams

	movi	HEADY,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_uhav,a4
	callr	print_string_C2
	movi	HEADY+9,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_def,a4
	callr	print_string_C2

	movi	bast8_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table
	movi	BAST_W_P,a0
	move	a0,@message_palette,L

	movi	TEAMY-3,a0
	move	a0,@mess_cursy		;message cursor pos Y

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_TEAMSDEF),a1,L

	movi	NUM_TEAMS,a2
#next_team
	srl	1,a1
	jrnc	#not_def
	PUSH	a1,a2
	movi	NUM_TEAMS,a0
	sub	a2,a0			;0-26
	addi	90h,a0			;asc table cities start offset
	movb	a0,@message_buffer+00h
	clr	a0
	movb	a0,@message_buffer+08h
	callr	print_string_C
	move	@mess_cursy,a0
	addk	10,a0
	move	a0,@mess_cursy		;message cursor pos Y
	PULL	a1,a2
#not_def
	dsj	a2,#next_team

	rets

#disp_undef	;undefeated teams

	movi	HEADY,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_uhavnt,a4
	callr	print_string_C2
	movi	HEADY+9,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_def,a4
	callr	print_string_C2

	movi	bast8_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table
	movi	BAST_W_P,a0
	move	a0,@message_palette,L

	movi	TEAMY-3,a0
	move	a0,@mess_cursy		;message cursor pos Y

	move	*a13(PC_DATADDR),a0,L	;start of player data
	move	*a0(PR_TEAMSDEF),a1,L

	movi	NUM_TEAMS,a2
#next_team2
	srl	1,a1
	jrc	#def
	PUSH	a1,a2
	movi	NUM_TEAMS,a0
	sub	a2,a0			;0-26
	addi	90h,a0			;asc table cities start offset
	movb	a0,@message_buffer+00h
	clr	a0
	movb	a0,@message_buffer+08h
	callr	print_string_C
	move	@mess_cursy,a0
	addk	10,a0
	move	a0,@mess_cursy		;message cursor pos Y
	PULL	a1,a2
#def
	dsj	a2,#next_team2
	rets


#str_uhav	.string	92h,0	;"YOU HAVE",0
#str_uhavnt	.string	87h,0	;"YOU HAVE NOT",0
#str_def	.string	85h,0	;"DEFEATED",0
	.even

#*****************************************************************************
*
* INPUT:	a0 = number to convert
*		a1 = max value
* converts value in A0 to an decimal ASCII string in message_buffer2
* - removes leading spaces
*
*-----------------------------------------------------------------------------
 SUBRP	dec_to_asc

	cmp	a0,a1			;a1-a0
	jrhi	#not_max
	move	a1,a0			;set num to max
#not_max

	calla	BINBCD			;dec number in A0
	move	a0,a1
	movi	message_buffer2,a2

	clr	a3			;leading zero flag

	andi	0f000h,a0
	srl	3*4,a0
	jrnz	#no_zero0
	move	a3,a3			;leading zero
	jrz	#skip_zero0
#no_zero0
	inc	a3
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
#skip_zero0

	move	a1,a0
	andi	0f00h,a0
	srl	2*4,a0
	jrnz	#no_zero1
	move	a3,a3			;leading zero
	jrz	#skip_zero1
#no_zero1
	inc	a3
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
#skip_zero1

	move	a1,a0
	andi	0f0h,a0
	srl	1*4,a0
	jrnz	#no_zero2
	move	a3,a3			;leading zero
	jrz	#skip_zero2
#no_zero2
	inc	a3
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
#skip_zero2

	move	a1,a0
	andi	0fh,a0
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
	clr	a0
	movb	a0,*a2			;null terminate string

	rets


#*****************************************************************************
*
* INPUT:	a0 = number to convert
* converts value in A0 to an decimal ASCII % string in message_buffer2
* range 000-999
*
*-----------------------------------------------------------------------------

 SUBRP	dec_to_pct

	calla	BINBCD			;dec number in A0
	move	a0,a1
	movi	message_buffer2,a2

	andi	0f00h,a0
	srl	2*4,a0
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2

	move	a1,a0
	andi	0f0h,a0
	srl	1*4,a0
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2

	move	a1,a0
	andi	0fh,a0
	addi	'0',a0
	movb	a0,*a2
	addk	8,a2
	clr	a0
	movb	a0,*a2			;null terminate string

	rets


#*****************************************************************************
*
* copies string in message_buffer2 to message_buffer
*
*-----------------------------------------------------------------------------

 SUBRP	copy_string

	movi	message_buffer-8,a2
	movi	message_buffer2-8,a3

#next_char
	addk	8,a2
	addk	8,a3
	movb	*a3,*a2
	movb	*a3,a0				;NULL?
	jrnz	#next_char
	rets

#*****************************************************************************
* concatenates string in message_buffer2 to string in message_buffer
*-----------------------------------------------------------------------------
 SUBRP	concat_string

	movi	message_buffer-8,a2
	movi	message_buffer2-8,a3
#next_char
	addk	8,a2
	movb	*a2,a0
	jrnz	#next_char
	subk	8,a2

#next_char2
	addk	8,a2
	addk	8,a3
	movb	*a3,*a2
	movb	*a3,a0				;NULL?
	jrnz	#next_char2

	rets

#*****************************************************************************
*
* INPUT:	a4 = * null terminated rom string
*
* copies string in rom to message_buffer
*
*-----------------------------------------------------------------------------

 SUBRP	copy_rom_string

	movi	message_buffer-8,a1

	subk	8,a4

#next_char
	addk	8,a1
	addk	8,a4
	movb	*a4,*a1
	movb	*a4,a0				;NULL ?
	jrnz	#next_char

	rets

#*****************************************************************************
* INPUT:	a4 = * null terminated rom string
*
* concatenates string in rom to string in message_buffer
*-----------------------------------------------------------------------------

 SUBRP	concat_rom_string

	movi	message_buffer-8,a1
#next_char
	addk	8,a1
	movb	*a1,a0
	jrnz	#next_char

	subk	8,a1
	subk	8,a4

#next_char2
	addk	8,a1
	addk	8,a4
	movb	*a4,*a1
	movb	*a4,a0				;NULL ?
	jrnz	#next_char2

	rets

#*****************************************************************************
* INPUT:	a4 = * null terminated rom string
*
* concatenates string in rom to string in message_buffer2
*-----------------------------------------------------------------------------
 SUBRP	concat_rom_string2

	movi	message_buffer2-8,a1
#next_char
	addk	8,a1
	movb	*a1,a0
	jrnz	#next_char

	subk	8,a1
	subk	8,a4

#next_char2
	addk	8,a1
	addk	8,a4
	movb	*a4,*a1
	movb	*a4,a0				;NULL ?
	jrnz	#next_char2

	rets

#*****************************************************************************
*
* INPUT:	a4 = * NULL terminated ASCII string (print_string2)
*
* RETURN:	a2 = width of string in pixels
*
*-----------------------------------------------------------------------------

 SUBRP	get_string_len

	movi	message_buffer,a4
get_string_len2
	clr	a2
	subk	8,a4
#next_char
	addk	8,a4
	movb	*a4,a0
	andi	0ffh,a0
	jrz	#done
	cmpi	1,a0
	jreq	#done
	cmpi	32,a0
	jrne	#no_space
	move	@mess_space_width,a0
	add	a0,a2
	jruc	#next_char
#no_space
	sll	5,a0			;x 32 bits
	move	@message_ascii,a1,L
	add	a1,a0
	move	*a0,a1,L		;* image
	jrz	#next_char
	move	*a1,a0			;image width
	add	a0,a2
	move	@mess_spacing,a0
	add	a0,a2
	jruc	#next_char

#done
	move	@mess_spacing,a0
	sub	a0,a2
	rets

#*****************************************************************************
*
* INPUT:	a4 = * NULL terminated ASCII string (print_string_C2)
*		centers & prints a text string
*
*-----------------------------------------------------------------------------
 SUBR	print_string_C3

	movi	message_buffer2,a4
	movi	#center_justify,a0
	move	a0,@mess_justify,L	;justification method
	callr	#center_justify
	callr	print_string2b
	rets


 SUBRP	print_string_C

	movi	message_buffer,a4
	movi	#center_justify,a0
	move	a0,@mess_justify,L	;justification method
	callr	#center_justify
	callr	print_string2b
	rets

print_string_C2
	movi	#center_justify,a0
	move	a0,@mess_justify,L	;justification method
	callr	#center_justify
	callr	print_string2b
	rets

#center_justify
	PUSH	a2,a4
	callr	get_string_len2
	srl	1,a2			;/2
	move	@mess_cursx,a0
	sub	a2,a0			;- string_width/2
	move	a0,@mess_cursx2		;message cursor pos X
	PULL	a2,a4
	rets

#*****************************************************************************
*
* INPUT:	a4 = * NULL terminated ASCII string (print_string_C2)
*		right justifies & prints a text string
*
*-----------------------------------------------------------------------------

 SUBRP	print_string_R

	movi	message_buffer,a4
	movi	#right_justify,a0
	move	a0,@mess_justify,L	;justification method
	callr	#right_justify
	callr	print_string2b
	rets

print_string_R2
	movi	#right_justify,a0
	move	a0,@mess_justify,L	;justification method
	callr	#right_justify
	callr	print_string2b
	rets

#right_justify
	PUSH	a2,a4
	callr	get_string_len2
	move	@mess_cursx,a0
	sub	a2,a0			;- string_width/2
	move	a0,@mess_cursx2		;message cursor pos X
	PULL	a2,a4
	rets

#*****************************************************************************
*
* INPUT:	a4 = * NULL terminated ASCII string (print_string2)
*
*-----------------------------------------------------------------------------

#left_justify
	move	@mess_cursx,a0
	move	a0,@mess_cursx2
	rets

 SUBRP	print_string

	movi	message_buffer,a4

print_string2
	movi	#left_justify,a0
	move	a0,@mess_justify,L	;justification method
	move	@mess_cursx,a0
	move	a0,@mess_cursx2
print_string2b

	subk	8,a4
#next_char
	addk	8,a4
	movb	*a4,a0
	andi	0ffh,a0
	jrz	#done
	cmpi	1,a0
	jrne	#no_newline
;newline
	move	@mess_line_spacing,a0
	move	@mess_cursy,a1
	add	a0,a1
	move	a1,@mess_cursy

	move	@mess_justify,a0,L	;justification method
	addi	8,a4			;skip newline char
	call	a0
	subi	8,a4
	jruc	#next_char
#no_newline
	cmpi	32,a0
	jrne	#no_space
;space
	move	@mess_space_width,a0
	move	@mess_cursx2,a1
	add	a0,a1
	move	a1,@mess_cursx2
	jruc	#next_char
#no_space
	sll	5,a0			;x 32 bits
	move	@message_ascii,a1,L
	add	a1,a0
	move	*a0,a2,L		;* image
	jrz	#next_char

	PUSH	a4,a8
	move	@message_palette,b0,L	;* palette
	move	@mess_cursx2,a0
	sll	16,a0			;x val
	move	@mess_cursy,a1
	sll	16,a1			;y val
	movi	20000,a3		;Z
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	move	@mess_objid,a5		;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJP2
	move	*a8(OSIZEX),a0
	move	@mess_cursx2,a1
	add	a0,a1
	move	@mess_spacing,a0
	add	a0,a1
	move	a1,@mess_cursx2
	PULL	a4,a8
	jruc	#next_char

#done
	rets


#*****************************************************************************
*
*-----------------------------------------------------------------------------

 SUBR	kern_chars

	movb	*a4,a0
	jrz	#nok
	move	@mess_cursx2,a1
	add	a0,a1
	move	a1,@mess_cursx2

	move	@mess_line_spacing,a0
	move	@mess_cursy,a1
	sub	a0,a1
	move	a1,@mess_cursy
#nok
	addk	8,a4
	rets


#*****************************************************************************
* INPUT	:   a2 = * to message
*-----------------------------------------------------------------------------
 SUBRP	setup_message

	movi	TYPTEXT,a0
	move	a0,@mess_objid		;OBJ ID's for text

	move	*a2+,a0,L		;* ascii lookup table
	move	a0,@message_ascii,L	;
	move	*a2+,a0			;space char width
	move	a0,@mess_space_width	;
	move	*a2+,a0			;spacing between chars
	move	a0,@mess_spacing	;
	move	*a2+,a0			;message cursor pos X
	move	a0,@mess_cursx		;
	move	*a2+,a0			;message cursor pos Y
	move	a0,@mess_cursy		;
	move	*a2+,a0,L
	move	a0,@message_palette,L
	movi	#rets,a0
	move	a0,@mess_justify,L	;justification method
#rets
	rets


#*****************************************************************************
* INPUT	:	a2 = * to message
*-----------------------------------------------------------------------------
 SUBRP	print_message

	PUSH	a4,a5,a6,a7,a8,a9,a10,a11

	movi	TYPTEXT,a0
	move	a0,@mess_objid		;OBJ ID's for text

	move	*a2+,a0,L		;* ascii lookup table
	move	a0,@message_ascii,L	;
	move	*a2+,a0			;space char width
	move	a0,@mess_space_width	;
	move	*a2+,a0			;spacing between chars
	move	a0,@mess_spacing	;
	move	*a2+,a0			;message cursor pos X
	move	a0,@mess_cursx		;
	move	*a2+,a0			;message cursor pos Y
	move	a0,@mess_cursy		;
	move	*a2+,a0,L
	move	a0,@message_palette,L
	move	*a2+,a0,L		;print method

	move	a2,a4			;* text string
	call	a0

	PULL	a4,a5,a6,a7,a8,a9,a10,a11
	rets


#*****************************************************************************

num_str_tbl
	.long	str_none
	.long	str_one
	.long	str_two
	.long	str_three
	.long	str_four


init_convert_table
	.word	0,'A','B','C','D','E','F','G','H'
	.word	'I','J','K','L','M','N','O','P'
	.word	'Q','R','S','T','U','V','W','X'
	.word	'Y','Z','!',0,' ',0			;Y Z ! del spc end

	.def	init_convert_img
init_convert_img
	.long	0
	.long	BAST8T_A,BAST8T_B,BAST8T_C,BAST8T_D,BAST8T_E,BAST8T_F
	.long	BAST8T_G,BAST8T_H,BAST8T_I,BAST8T_J,BAST8T_K,BAST8T_L
	.long	BAST8T_M,BAST8T_N,BAST8T_O,BAST8T_P,BAST8T_Q,BAST8T_R
	.long	BAST8T_S,BAST8T_T,BAST8T_U,BAST8T_V,BAST8T_W,BAST8T_X
	.long	BAST8T_Y,BAST8T_Z,BAST8TEXC,0,BAST8TSPC

#*****************************************************************************
*            FONT TABLES
******************************************************************************

hangfnt38_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,HANGF_EXC,0,0,0,0,0,HANGF_APO					;$20	SP! " # $ % & '
 .long 0,0,0,0,0,0,0,0							;$28	( ) * + , - . /
 .long HANGF_0,HANGF_1,HANGF_2,HANGF_3,HANGF_4,HANGF_5,HANGF_6,HANGF_7	;$30	0 1 2 3 4 5 6 7
 .long HANGF_8,HANGF_9,0,0,0,0,0,0					;$38	8 9 : ; < - > ?
 .long 0,HANGF_A,HANGF_B,HANGF_C,HANGF_D,HANGF_E,HANGF_F,HANGF_G	;$40	@ A B C D E F G
 .long HANGF_H,HANGF_I,HANGF_J,HANGF_K,HANGF_L,HANGF_M,HANGF_N,HANGF_O	;$48	H I J K L M N O
 .long HANGF_P,HANGF_Q,HANGF_R,HANGF_S,HANGF_T,HANGF_U,HANGF_V,HANGF_W	;$50	P Q R S T U V W
 .long HANGF_X,HANGF_Y,HANGF_Z,0,0,0,0,0				;$58	X Y Z [ \ ] ^ _
 .long 0,HANGF_A,HANGF_B,HANGF_C,HANGF_D,HANGF_E,HANGF_F,HANGF_G	;$60	` a b c d e f g
 .long HANGF_H,HANGF_I,HANGF_J,HANGF_K,HANGF_L,HANGF_M,HANGF_N,HANGF_O	;$68	h i j k l m n o
 .long HANGF_P,HANGF_Q,HANGF_R,HANGF_S,HANGF_T,HANGF_U,HANGF_V,HANGF_W	;$70	p q r s t u v w
 .long HANGF_X,HANGF_Y,HANGF_Z,0,0,0,0,0				;$78	x y z { | } ~

bast7tcyc_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,B7TCYC_EXC,0,B7TCYC_NUM,B7TCYC_DOL,B7TCYC_PCT,B7TCYC_AND,B7TCYC_APO		;$20	SP! " # $ % & '
 .long B7TCYC_PRL,B7TCYC_PRR,0,B7TCYC_PLS,B7TCYC_COM,B7TCYC_DSH,B7TCYC_PER,B7TCYC_SLS	;$28	( ) * + , - . /
 .long B7TCYC_0,B7TCYC_1,B7TCYC_2,B7TCYC_3,B7TCYC_4,B7TCYC_5,B7TCYC_6,B7TCYC_7		;$30	0 1 2 3 4 5 6 7
 .long B7TCYC_8,B7TCYC_9,B7TCYC_COL,B7TCYC_SEM,0,B7TCYC_DSH,0,B7TCYC_QUE			;$38	8 9 : ; < - > ?
 .long 0,B7TCYC_A,B7TCYC_B,B7TCYC_C,B7TCYC_D,B7TCYC_E,B7TCYC_F,B7TCYC_G		;$40	@ A B C D E F G
 .long B7TCYC_H,B7TCYC_I,B7TCYC_J,B7TCYC_K,B7TCYC_L,B7TCYC_M,B7TCYC_N,B7TCYC_O		;$48	H I J K L M N O
 .long B7TCYC_P,B7TCYC_Q,B7TCYC_R,B7TCYC_S,B7TCYC_T,B7TCYC_U,B7TCYC_V,B7TCYC_W		;$50	P Q R S T U V W
 .long B7TCYC_X,B7TCYC_Y,B7TCYC_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,B7TCYC_A,B7TCYC_B,B7TCYC_C,B7TCYC_D,B7TCYC_E,B7TCYC_F,B7TCYC_G		;$60	` a b c d e f g
 .long B7TCYC_H,B7TCYC_I,B7TCYC_J,B7TCYC_K,B7TCYC_L,B7TCYC_M,B7TCYC_N,B7TCYC_O		;$68	h i j k l m n o
 .long B7TCYC_P,B7TCYC_Q,B7TCYC_R,B7TCYC_S,B7TCYC_T,B7TCYC_U,B7TCYC_V,B7TCYC_W		;$70	p q r s t u v w
 .long B7TCYC_X,B7TCYC_Y,B7TCYC_Z,0,0,0,0,0					;$78	x y z { | } ~

bast7t_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,BAST7TEXC,0,BAST7TNUM,BAST7TDOL,BAST7TPCT,BAST7TAND,BAST7TAPO		;$20	SP! " # $ % & '
 .long BAST7TLPR,BAST7TRPR,BAST7TAST,BAST7TPLS,BAST7TCOM,BAST10DSH,BAST7TPER,BAST7TSLS	;$28	( ) * + , - . /
 .long BAST7T_0,BAST7T_1,BAST7T_2,BAST7T_3,BAST7T_4,BAST7T_5,BAST7T_6,BAST7T_7		;$30	0 1 2 3 4 5 6 7
 .long BAST7T_8,BAST7T_9,BAST7TCOL,BAST7TSEM,0,BAST10DSH,0,BAST7TQUE			;$38	8 9 : ; < - > ?
 .long 0,BAST7T_A,BAST7T_B,BAST7T_C,BAST7T_D,BAST7T_E,BAST7T_F,BAST7T_G		;$40	@ A B C D E F G
 .long BAST7T_H,BAST7T_I,BAST7T_J,BAST7T_K,BAST7T_L,BAST7T_M,BAST7T_N,BAST7T_O		;$48	H I J K L M N O
 .long BAST7T_P,BAST7T_Q,BAST7T_R,BAST7T_S,BAST7T_T,BAST7T_U,BAST7T_V,BAST7T_W		;$50	P Q R S T U V W
 .long BAST7T_X,BAST7T_Y,BAST7T_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,BAST7T_A,BAST7T_B,BAST7T_C,BAST7T_D,BAST7T_E,BAST7T_F,BAST7T_G		;$60	` a b c d e f g
 .long BAST7T_H,BAST7T_I,BAST7T_J,BAST7T_K,BAST7T_L,BAST7T_M,BAST7T_N,BAST7T_O		;$68	h i j k l m n o
 .long BAST7T_P,BAST7T_Q,BAST7T_R,BAST7T_S,BAST7T_T,BAST7T_U,BAST7T_V,BAST7T_W		;$70	p q r s t u v w
 .long BAST7T_X,BAST7T_Y,BAST7T_Z,0,0,0,0,0					;$78	x y z { | } ~
 .long CORRECT,POINTS											;$80

bast8tcyc_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,B8TCYC_EXC,0,B8TCYC_NUM,B8TCYC_DOL,B8TCYC_PCT,B8TCYC_AND,B8TCYC_APO			;$20	SP! " # $ % & '
 .long B8TCYC_PRL,B8TCYC_PRR,0,0,B8TCYC_COM,0,B8TCYC_PER,B8TCYC_SLS		;$28	( ) * + , - . /
 .long B8TCYC_0,B8TCYC_1,B8TCYC_2,B8TCYC_3,B8TCYC_4,B8TCYC_5,B8TCYC_6,B8TCYC_7	;$30	0 1 2 3 4 5 6 7
 .long B8TCYC_8,B8TCYC_9,B8TCYC_COL,0,0,0,0,B8TCYC_QUE			;$38	8 9 : ; < - > ?
 .long 0,B8TCYC_A,B8TCYC_B,B8TCYC_C,B8TCYC_D,B8TCYC_E,B8TCYC_F,B8TCYC_G		;$40	@ A B C D E F G
 .long B8TCYC_H,B8TCYC_I,B8TCYC_J,B8TCYC_K,B8TCYC_L,B8TCYC_M,B8TCYC_N,B8TCYC_O		;$48	H I J K L M N O
 .long B8TCYC_P,B8TCYC_Q,B8TCYC_R,B8TCYC_S,B8TCYC_T,B8TCYC_U,B8TCYC_V,B8TCYC_W		;$50	P Q R S T U V W
 .long B8TCYC_X,B8TCYC_Y,B8TCYC_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,B8TCYC_A,B8TCYC_B,B8TCYC_C,B8TCYC_D,B8TCYC_E,B8TCYC_F,B8TCYC_G			;$60	` a b c d e f g
 .long B8TCYC_H,B8TCYC_I,B8TCYC_J,B8TCYC_K,B8TCYC_L,B8TCYC_M,B8TCYC_N,B8TCYC_O		;$68	h i j k l m n o
 .long B8TCYC_P,B8TCYC_Q,B8TCYC_R,B8TCYC_S,B8TCYC_T,B8TCYC_U,B8TCYC_V,B8TCYC_W		;$70	p q r s t u v w
 .long B8TCYC_X,B8TCYC_Y,B8TCYC_Z,0,0,0,0,0						;$78	x y z { | } ~

bast8t_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,BAST8TEXC,0,BAST8TNUM,BAST8TDOL,BAST8TPCT,BAST8TAND,BAST8TAPO			;$20	SP! " # $ % & '
 .long BAST8TPRL,BAST8TPRR,0,0,BAST8TCOM,BAST10DSH,BAST8TPER,BAST8TSLS		;$28	( ) * + , - . /
 .long BAST8T_0,BAST8T_1,BAST8T_2,BAST8T_3,BAST8T_4,BAST8T_5,BAST8T_6,BAST8T_7	;$30	0 1 2 3 4 5 6 7
 .long BAST8T_8,BAST8T_9,BAST8TCOL,0,0,BAST10DSH,0,BAST8TQUE			;$38	8 9 : ; < - > ?
 .long 0,BAST8T_A,BAST8T_B,BAST8T_C,BAST8T_D,BAST8T_E,BAST8T_F,BAST8T_G		;$40	@ A B C D E F G
 .long BAST8T_H,BAST8T_I,BAST8T_J,BAST8T_K,BAST8T_L,BAST8T_M,BAST8T_N,BAST8T_O		;$48	H I J K L M N O
 .long BAST8T_P,BAST8T_Q,BAST8T_R,BAST8T_S,BAST8T_T,BAST8T_U,BAST8T_V,BAST8T_W		;$50	P Q R S T U V W
 .long BAST8T_X,BAST8T_Y,BAST8T_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,BAST8T_A,BAST8T_B,BAST8T_C,BAST8T_D,BAST8T_E,BAST8T_F,BAST8T_G			;$60	` a b c d e f g
 .long BAST8T_H,BAST8T_I,BAST8T_J,BAST8T_K,BAST8T_L,BAST8T_M,BAST8T_N,BAST8T_O		;$68	h i j k l m n o
 .long BAST8T_P,BAST8T_Q,BAST8T_R,BAST8T_S,BAST8T_T,BAST8T_U,BAST8T_V,BAST8T_W		;$70	p q r s t u v w
 .long BAST8T_X,BAST8T_Y,BAST8T_Z,0,0,0,0,0						;$78	x y z { | } ~
 .long stx_all,stx_avgallow,stx_avgscore,stx_created,stx_current,stx_defeated,stx_defrank,stx_havenot	;$80
 .long stx_l,stx_nbateams,stx_nextcpu,stx_offrank,stx_ofthe27,stx_overall,stx_record,stx_tournwin	;$88
 .long stx_w,stx_worldrec,stx_youhave,stx_avepoint,stx_norecord,stx_pct,stx_wins,stx_overall		;$90
 .long TRIVPTS


	.global	bast8_2_ascii
bast8_2_ascii
 .long BAST8EXC,0,BAST8NUM,BAST8DOL,BAST8PCT,BAST8AND,BAST8APO		;$20	SP! " # $ % & '
 .long BAST8PRL,BAST8PRR,0,0,BAST8COM,BAST10DSH,BAST8PER,BAST8SLS		;$28	( ) * + , - . /
 .long BAST8_0,BAST8_1,BAST8_2,BAST8_3,BAST8_4,BAST8_5,BAST8_6,BAST8_7		;$30	0 1 2 3 4 5 6 7
 .long BAST8_8,BAST8_9,BAST8COL,0,0,BAST10DSH,0,BAST8QUE			;$38	8 9 : ; < - > ?
 .long 0,BAST8_A,BAST8_B,BAST8_C,BAST8_D,BAST8_E,BAST8_F,BAST8_G		;$40	@ A B C D E F G
 .long BAST8_H,BAST8_I,BAST8_J,BAST8_K,BAST8_L,BAST8_M,BAST8_N,BAST8_O		;$48	H I J K L M N O
 .long BAST8_P,BAST8_Q,BAST8_R,BAST8_S,BAST8_T,BAST8_U,BAST8_V,BAST8_W		;$50	P Q R S T U V W
 .long BAST8_X,BAST8_Y,BAST8_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,BAST8_A,BAST8_B,BAST8_C,BAST8_D,BAST8_E,BAST8_F,BAST8_G		;$60	` a b c d e f g
 .long BAST8_H,BAST8_I,BAST8_J,BAST8_K,BAST8_L,BAST8_M,BAST8_N,BAST8_O		;$68	h i j k l m n o
 .long BAST8_P,BAST8_Q,BAST8_R,BAST8_S,BAST8_T,BAST8_U,BAST8_V,BAST8_W		;$70	p q r s t u v w
 .long BAST8_X,BAST8_Y,BAST8_Z,0,0,0,0,0					;$78	x y z { | } ~

bast8_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,BAST8EXC,0,BAST8NUM,BAST8DOL,BAST8PCT,BAST8AND,BAST8APO		;$20	SP! " # $ % & '
 .long BAST8PRL,BAST8PRR,0,0,BAST8COM,BAST10DSH,BAST8PER,BAST8SLS		;$28	( ) * + , - . /
 .long BAST8_0,BAST8_1,BAST8_2,BAST8_3,BAST8_4,BAST8_5,BAST8_6,BAST8_7		;$30	0 1 2 3 4 5 6 7
 .long BAST8_8,BAST8_9,BAST8COL,0,0,BAST10DSH,0,BAST8QUE			;$38	8 9 : ; < - > ?
 .long 0,BAST8_A,BAST8_B,BAST8_C,BAST8_D,BAST8_E,BAST8_F,BAST8_G		;$40	@ A B C D E F G
 .long BAST8_H,BAST8_I,BAST8_J,BAST8_K,BAST8_L,BAST8_M,BAST8_N,BAST8_O		;$48	H I J K L M N O
 .long BAST8_P,BAST8_Q,BAST8_R,BAST8_S,BAST8_T,BAST8_U,BAST8_V,BAST8_W		;$50	P Q R S T U V W
 .long BAST8_X,BAST8_Y,BAST8_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,BAST8_A,BAST8_B,BAST8_C,BAST8_D,BAST8_E,BAST8_F,BAST8_G		;$60	` a b c d e f g
 .long BAST8_H,BAST8_I,BAST8_J,BAST8_K,BAST8_L,BAST8_M,BAST8_N,BAST8_O		;$68	h i j k l m n o
 .long BAST8_P,BAST8_Q,BAST8_R,BAST8_S,BAST8_T,BAST8_U,BAST8_V,BAST8_W		;$70	p q r s t u v w
 .long BAST8_X,BAST8_Y,BAST8_Z,0,0,0,0,0					;$78	x y z { | } ~
 .long 0,0,0,0,0,0,0,0								;$80
 .long 0,0,0,0,0,0,0,0								;$88
 .long	city_atl		;ATLANTA	(96)
 .long	city_bos		;BOSTON		(103)
 .long	city_cha		;CHARLOTTE
 .long	city_chi		;CHICAGO
 .long	city_cle		;CLEVELAND
 .long	city_dal		;DALLAS		(117)
 .long	city_den		;DENVER
 .long	city_det		;DETROIT
 .long	city_gol		;GOLDEN STATE	(110)
 .long	city_hou		;HOUSTON
 .long	city_ind		;INDIANA
 .long	city_lac		;LOS ANGELES (CLIPPERS)
 .long	city_lal		;LOS ANGELES (LAKERS)
 .long	city_mia		;MIAMI
 .long	city_mil		;MILWAUKEE
 .long	city_min		;MINNESOTA
 .long	city_nej		;NEW JERSEY
 .long	city_ney		;NEW YORK
 .long	city_orl		;ORLANDO
 .long	city_phi		;PHILADELPHIA
 .long	city_pho		;PHOENIX
 .long	city_por		;PORTLAND
 .long	city_sac		;SACRAMENTO
 .long	city_san		;SAN ANTONIO
 .long	city_sea		;SEATTLE
 .long	city_tor		;TORONTO (new)
 .long	city_uta		;UTAH
 .long	city_van		;VANCOUVER (new)
 .long	city_was		;WASHINGTON


bast10_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,BAST10EXC,0,BAST10NUM,BAST10DOL,0,BAST10AND,BAST10APO			;$20	SP! " # $ % & '
 .long BAST10PRL,BAST10PRR,0,BAST10PLS,BAST10COM,BAST10DSH,BAST10PER,BAST10SLS	;$28	( ) * + , - . /
 .long BAST10_0,BAST10_1,BAST10_2,BAST10_3,BAST10_4,BAST10_5,BAST10_6,BAST10_7	;$30	0 1 2 3 4 5 6 7
 .long BAST10_8,BAST10_9,BAST10COL,BAST10SEM,0,BAST10DSH,0,BAST10QUE		;$38	8 9 : ; < - > ?
 .long 0,BAST10_A,BAST10_B,BAST10_C,BAST10_D,BAST10_E,BAST10_F,BAST10_G		;$40	@ A B C D E F G
 .long BAST10_H,BAST10_I,BAST10_J,BAST10_K,BAST10_L,BAST10_M,BAST10_N,BAST10_O	;$48	H I J K L M N O
 .long BAST10_P,BAST10_Q,BAST10_R,BAST10_S,BAST10_T,BAST10_U,BAST10_V,BAST10_W	;$50	P Q R S T U V W
 .long BAST10_X,BAST10_Y,BAST10_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,BAST10_A,BAST10_B,BAST10_C,BAST10_D,BAST10_E,BAST10_F,BAST10_G		;$60	` a b c d e f g
 .long BAST10_H,BAST10_I,BAST10_J,BAST10_K,BAST10_L,BAST10_M,BAST10_N,BAST10_O	;$68	h i j k l m n o
 .long BAST10_P,BAST10_Q,BAST10_R,BAST10_S,BAST10_T,BAST10_U,BAST10_V,BAST10_W	;$70	p q r s t u v w
 .long BAST10_X,BAST10_Y,BAST10_Z,0,0,0,0,0					;$78	x y z { | } ~

brush10_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,BRSH10EXC,0,BRSH10NUM,BRSH10DOL,0,BRSH10AND,0				;$20	SP! " # $ % & '
 .long BRSH10PRL,BRSH10PRR,0,0,BRSH10COM,0,BRSH10PER,BRSH10SLS			;$28	( ) * + , - . /
 .long BRSH10_0,BRSH10_1,BRSH10_2,BRSH10_3,BRSH10_4,BRSH10_5,BRSH10_6,BRSH10_7	;$30	0 1 2 3 4 5 6 7
 .long BRSH10_8,BRSH10_9,BRSH10COL,0,0,0,0,BRSH10QUE				;$38	8 9 : ; < - > ?
 .long 0,BRSH10_A,BRSH10_B,BRSH10_C,BRSH10_D,BRSH10_E,BRSH10_F,BRSH10_G		;$40	@ A B C D E F G
 .long BRSH10_H,BRSH10_I,BRSH10_J,BRSH10_K,BRSH10_L,BRSH10_M,BRSH10_N,BRSH10_O	;$48	H I J K L M N O
 .long BRSH10_P,BRSH10_Q,BRSH10_R,BRSH10_S,BRSH10_T,BRSH10_U,BRSH10_V,BRSH10_W	;$50	P Q R S T U V W
 .long BRSH10_X,BRSH10_Y,BRSH10_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,BRSH10_A,BRSH10_B,BRSH10_C,BRSH10_D,BRSH10_E,BRSH10_F,BRSH10_G		;$60	` a b c d e f g
 .long BRSH10_H,BRSH10_I,BRSH10_J,BRSH10_K,BRSH10_L,BRSH10_M,BRSH10_N,BRSH10_O	;$68	h i j k l m n o
 .long BRSH10_P,BRSH10_Q,BRSH10_R,BRSH10_S,BRSH10_T,BRSH10_U,BRSH10_V,BRSH10_W	;$70	p q r s t  v w
 .long BRSH10_X,BRSH10_Y,BRSH10_Z,0,0,0,0,0					;$78	x y z { | } ~

brush12_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,BRSH12EXC,0,BRSH12NUM,BRSH12DOL,0,BRSH12AND,0			;$20	SP! " # $ % & '
 .long BRSH12PRL,BRSH12PRR,0,0,BRSH12COM,BRSH12DAS,BRSH12PER,BRSH12SLS		;$28	( ) * + , - . /
 .long BRSH12_0,BRSH12_1,BRSH12_2,BRSH12_3,BRSH12_4,BRSH12_5,BRSH12_6,BRSH12_7	;$30	0 1 2 3 4 5 6 7
 .long BRSH12_8,BRSH12_9,BRSH12COL,0,0,BRSH12DAS,0,BRSH12QUE			;$38	8 9 : ; < - > ?
 .long 0,BRSH12_A,BRSH12_B,BRSH12_C,BRSH12_D,BRSH12_E,BRSH12_F,BRSH12_G		;$40	@ A B C D E F G
 .long BRSH12_H,BRSH12_I,BRSH12_J,BRSH12_K,BRSH12_L,BRSH12_M,BRSH12_N,BRSH12_O	;$48	H I J K L M N O
 .long BRSH12_P,BRSH12_Q,BRSH12_R,BRSH12_S,BRSH12_T,BRSH12_U,BRSH12_V,BRSH12_W	;$50	P Q R S T U V W
 .long BRSH12_X,BRSH12_Y,BRSH12_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,BRSH12_A,BRSH12_B,BRSH12_C,BRSH12_D,BRSH12_E,BRSH12_F,BRSH12_G		;$60	` a b c d e f g
 .long BRSH12_H,BRSH12_I,BRSH12_J,BRSH12_K,BRSH12_L,BRSH12_M,BRSH12_N,BRSH12_O	;$68	h i j k l m n o
 .long BRSH12_P,BRSH12_Q,BRSH12_R,BRSH12_S,BRSH12_T,BRSH12_U,BRSH12_V,BRSH12_W	;$70	p q r s t u v w
 .long BRSH12_X,BRSH12_Y,BRSH12_Z,0,0,0,0,0						;$78	x y z { | } ~

inga16_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,INGA16EXC,0,INGA16NUM,INGA16DOL,INGA16PCT,0,INGA16APO			;$20	SP! " # $ % & '
 .long INGA16PRL,INGA16PRR,INGA16AST,INGA16ADD,INGA16COM,INGA16SUB,INGA16PER,INGA16SLS	;$28	( ) * + , - . /
 .long INGA16_0,INGA16_1,INGA16_2,INGA16_3,INGA16_4,INGA16_5,INGA16_6,INGA16_7	;$30	0 1 2 3 4 5 6 7
 .long INGA16_8,INGA16_9,INGA16COL,0,0,INGA16SUB,0,INGA16QUE			;$38	8 9 : ; < - > ?
 .long 0,INGA16_A,INGA16_B,INGA16_C,INGA16_D,INGA16_E,INGA16_F,INGA16_G		;$40	@ A B C D E F G
 .long INGA16_H,INGA16_I,INGA16_J,INGA16_K,INGA16_L,INGA16_M,INGA16_N,INGA16_O	;$48	H I J K L M N O
 .long INGA16_P,INGA16_Q,INGA16_R,INGA16_S,INGA16_T,INGA16_U,INGA16_V,INGA16_W	;$50	P Q R S T U V W
 .long INGA16_X,INGA16_Y,INGA16_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,INGA16_A,INGA16_B,INGA16_C,INGA16_D,INGA16_E,INGA16_F,INGA16_G		;$60	` a b c d e f g
 .long INGA16_H,INGA16_I,INGA16_J,INGA16_K,INGA16_L,INGA16_M,INGA16_N,INGA16_O	;$68	h i j k l m n o
 .long INGA16_P,INGA16_Q,INGA16_R,INGA16_S,INGA16_T,INGA16_U,INGA16_V,INGA16_W	;$70	p q r s t u v w
 .long INGA16_X,INGA16_Y,INGA16_Z,0,0,0,0,0					;$78	x y z { | } ~

bast18_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,BAST18EXC,0,BAST18NUM,BAST18DOL,BAST18PCT,0,BAST18APO			;$20	SP! " # $ % & '
 .long BAST18PRL,BAST18PRR,0,BAST18ADD,BAST18COM,BAST18DSH,BAST18PER,BAST18SLS	;$28	( ) * + , - . /
 .long BAST18_0,BAST18_1,BAST18_2,BAST18_3,BAST18_4,BAST18_5,BAST18_6,BAST18_7	;$30	0 1 2 3 4 5 6 7
 .long BAST18_8,BAST18_9,BAST18COL,0,0,BAST18DSH,0,0				;$38	8 9 : ; < - > ?
 .long 0,BAST18_A,BAST18_B,BAST18_C,BAST18_D,BAST18_E,BAST18_F,BAST18_G		;$40	@ A B C D E F G
 .long BAST18_H,BAST18_I,BAST18_J,BAST18_K,BAST18_L,BAST18_M,BAST18_N,BAST18_O	;$48	H I J K L M N O
 .long BAST18_P,BAST18_Q,BAST18_R,BAST18_S,BAST18_T,BAST18_U,BAST18_V,BAST18_W	;$50	P Q R S T U V W
 .long BAST18_X,BAST18_Y,BAST18_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,BAST18_A,BAST18_B,BAST18_C,BAST18_D,BAST18_E,BAST18_F,BAST18_G		;$60	` a b c d e f g
 .long BAST18_H,BAST18_I,BAST18_J,BAST18_K,BAST18_L,BAST18_M,BAST18_N,BAST18_O	;$68	h i j k l m n o
 .long BAST18_P,BAST18_Q,BAST18_R,BAST18_S,BAST18_T,BAST18_U,BAST18_V,BAST18_W	;$70	p q r s t u v w
 .long BAST18_X,BAST18_Y,BAST18_Z,0,0,0,0,0					;$78	x y z { | } ~

brush20_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
	.ref	BRSH20APO
 .long 0,BRSH20EXC,0,0,0,BRSH20PCT,0,BRSH20APO					;$20	SP! " # $ % & '
 .long 0,0,0,0,BRSH20COM,0,BRSH20PER,BRSH20SLS					;$28	( ) * + , - . /
 .long BRSH20_0,BRSH20_1,BRSH20_2,BRSH20_3,BRSH20_4,BRSH20_5,BRSH20_6,BRSH20_7	;$30	0 1 2 3 4 5 6 7
 .long BRSH20_8,BRSH20_9,BRSH20COL,0,0,0,0,BRSH20QUE				;$38	8 9 : ; < - > ?
 .long 0,BRSH20_A,BRSH20_B,BRSH20_C,BRSH20_D,BRSH20_E,BRSH20_F,BRSH20_G		;$40	@ A B C D E F G
 .long BRSH20_H,BRSH20_I,BRSH20_J,BRSH20_K,BRSH20_L,BRSH20_M,BRSH20_N,BRSH20_O	;$48	H I J K L M N O
 .long BRSH20_P,BRSH20_Q,BRSH20_R,BRSH20_S,BRSH20_T,BRSH20_U,BRSH20_V,BRSH20_W	;$50	P Q R S T U V W
 .long BRSH20_X,BRSH20_Y,BRSH20_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,BRSH20_A,BRSH20_B,BRSH20_C,BRSH20_D,BRSH20_E,BRSH20_F,BRSH20_G		;$60	` a b c d e f g
 .long BRSH20_H,BRSH20_I,BRSH20_J,BRSH20_K,BRSH20_L,BRSH20_M,BRSH20_N,BRSH20_O	;$68	h i j k l m n o
 .long BRSH20_P,BRSH20_Q,BRSH20_R,BRSH20_S,BRSH20_T,BRSH20_U,BRSH20_V,BRSH20_W	;$70	p q r s t u v w
 .long BRSH20_X,BRSH20_Y,BRSH20_Z,0,0,0,0,0					;$78	x y z { | } ~
 .long TRIVIA,CONTEST								;$80

brush50_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,BRSH50EXC,0,BRSH50NUM,BRSH50DOL,BRSH50PCT,BRSH50AND,0			;$20	SP! " # $ % & '
 .long BRSH50PRL,BRSH50PRR,0,0,BRSH50COM,0,BRSH50PER,BRSH50SLS			;$28	( ) * + , - . /
 .long BRSH50_0,BRSH50_1,BRSH50_2,BRSH50_3,BRSH50_4,BRSH50_5,BRSH50_6,BRSH50_7	;$30	0 1 2 3 4 5 6 7
 .long BRSH50_8,BRSH50_9,BRSH50COL,0,0,0,0,BRSH50QUE				;$38	8 9 : ; < - > ?
 .long 0,BRSH50_A,BRSH50_B,BRSH50_C,BRSH50_D,BRSH50_E,BRSH50_F,BRSH50_G		;$40	@ A B C D E F G
 .long BRSH50_H,BRSH50_I,BRSH50_J,BRSH50_K,BRSH50_L,BRSH50_M,BRSH50_N,BRSH50_O	;$48	H I J K L M N O
 .long BRSH50_P,BRSH50_Q,BRSH50_R,BRSH50_S,BRSH50_T,BRSH50_U,BRSH50_V,BRSH50_W	;$50	P Q R S T U V W
 .long BRSH50_X,BRSH50_Y,BRSH50_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,BRSH50_A,BRSH50_B,BRSH50_C,BRSH50_D,BRSH50_E,BRSH50_F,BRSH50_G		;$60	` a b c d e f g
 .long BRSH50_H,BRSH50_I,BRSH50_J,BRSH50_K,BRSH50_L,BRSH50_M,BRSH50_N,BRSH50_O	;$68	h i j k l m n o
 .long BRSH50_P,BRSH50_Q,BRSH50_R,BRSH50_S,BRSH50_T,BRSH50_U,BRSH50_V,BRSH50_W	;$70	p q r s t u v w
 .long BRSH50_X,BRSH50_Y,BRSH50_Z,0,0,0,0,0					;$78	x y z { | } ~

;osgemd_ascii
; .long 0,0,0,0,0,0,0,0								;$00
; .long 0,0,0,0,0,0,0,0								;$08
; .long 0,0,0,0,0,0,0,0								;$10
; .long 0,0,0,0,0,0,0,0								;$18
; .long 0,OSGEMD_EXP,0,OSGEMD_NUM,OSGEMD_DOL,0,OSGEMD_AND,OSGEMD_APO		;$20	SP! " # $ % & '
; .long OSGEMD_OBR,OSGEMD_CBR,0,0,OSGEMD_COM,OSGEMD_DAS,OSGEMD_DOT,OSGEMD_SLS		;$28	( ) * + , - . /
; .long OSGEMD_0,OSGEMD_1,OSGEMD_2,OSGEMD_3,OSGEMD_4,OSGEMD_5,OSGEMD_6,OSGEMD_7	;$30	0 1 2 3 4 5 6 7
; .long OSGEMD_8,OSGEMD_9,OSGEMD_COL,0,0,0,0,OSGEMD_QUE				;$38	8 9 : ; < - > ?
; .long 0,OSGEMD_A,OSGEMD_B,OSGEMD_C,OSGEMD_D,OSGEMD_E,OSGEMD_F,OSGEMD_G		;$40	@ A B C D E F G
; .long OSGEMD_H,OSGEMD_I,OSGEMD_J,OSGEMD_K,OSGEMD_L,OSGEMD_M,OSGEMD_N,OSGEMD_O	;$48	H I J K L M N O
; .long OSGEMD_P,OSGEMD_Q,OSGEMD_R,OSGEMD_S,OSGEMD_T,OSGEMD_U,OSGEMD_V,OSGEMD_W	;$50	P Q R S T U V W
; .long OSGEMD_X,OSGEMD_Y,OSGEMD_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
; .long 0,OSGEMD_A,OSGEMD_B,OSGEMD_C,OSGEMD_D,OSGEMD_E,OSGEMD_F,OSGEMD_G		;$60	` a b c d e f g
; .long OSGEMD_H,OSGEMD_I,OSGEMD_J,OSGEMD_K,OSGEMD_L,OSGEMD_M,OSGEMD_N,OSGEMD_O	;$68	h i j k l m n o
; .long OSGEMD_P,OSGEMD_Q,OSGEMD_R,OSGEMD_S,OSGEMD_T,OSGEMD_U,OSGEMD_V,OSGEMD_W	;$70	p q r s t u v w
; .long OSGEMD_X,OSGEMD_Y,OSGEMD_Z,0,0,0,0,0					;$78	x y z { | } ~

;omlgmd_ascii
; .long 0,0,0,0,0,0,0,0								;$00
; .long 0,0,0,0,0,0,0,0								;$08
; .long 0,0,0,0,0,0,0,0								;$10
; .long 0,0,0,0,0,0,0,0								;$18
; .long 0,omlgmd_EXP,0,0,0,0,0,0								;$20	SP! " # $ % & '
; .long 0,0,0,0,0,0,omlgmd_DOT,0								;$28	( ) * + , - . /
; .long 0,0,0,0,0,0,0,0								;$30	0 1 2 3 4 5 6 7
; .long 0,0,0,0,0,0,0,0								;$38	8 9 : ; < - > ?
; .long 0,omlgmd_A,omlgmd_B,omlgmd_C,omlgmd_D,omlgmd_E,omlgmd_F,omlgmd_G		;$40	@ A B C D E F G
; .long omlgmd_H,omlgmd_I,omlgmd_J,omlgmd_K,omlgmd_L,omlgmd_M,omlgmd_N,omlgmd_O	;$48	H I J K L M N O
; .long omlgmd_P,omlgmd_Q,omlgmd_R,omlgmd_S,omlgmd_T,omlgmd_U,omlgmd_V,omlgmd_W	;$50	P Q R S T U V W
; .long omlgmd_X,omlgmd_Y,omlgmd_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
; .long 0,omlgmd_A,omlgmd_B,omlgmd_C,omlgmd_D,omlgmd_E,omlgmd_F,omlgmd_G		;$60	` a b c d e f g
; .long omlgmd_H,omlgmd_I,omlgmd_J,omlgmd_K,omlgmd_L,omlgmd_M,omlgmd_N,omlgmd_O	;$68	h i j k l m n o
; .long omlgmd_P,omlgmd_Q,omlgmd_R,omlgmd_S,omlgmd_T,omlgmd_U,omlgmd_V,omlgmd_W	;$70	p q r s t u v w
; .long omlgmd_X,omlgmd_Y,omlgmd_Z,0,0,0,0,0					;$78	x y z { | } ~


******************************************************************************
* strings

str_slash	.string	"/",0
str_dash	.string	"-",0
str_dash2	.string	" - ",0
str_sp		.string	" ",0
str_2sp		.string	"  ",0
str_3sp		.string	"   ",0
str_dot		.string	".",0
str_00		.string	"00.00",0
str_and		.string	" & ",0
str_obr		.string "(",0
str_cbr		.string ")",0
str_w		.string " - ",0		;" (W) - "
;str_l		.string	88h,0		;"(L)"
str_all		.string	" ALL",0	;" ALL"
str_norecord	.string 94h,0		;"NO RECORD"
str_line0a	.string	9fh,0		;"RANK #"
str_line0b	.string	8eh,0		;"RECORD: "
str_line0c	.string	82h,' ',0	;"LOSSES: "
str_line0d	.string	95h,"  .",0	;"PCT: ."
str_line0d1	.string	95h,"  1.000",0	;"PCT: 1.000"

str_na		.string	"N/A",0
str_streak	.string	84h,0
str_win		.string	" WIN",0
str_wins	.string	" WINS",0
str_none	.string	"NONE",0
str_ovr_rnk	.string 8dh,0
str_def_rnk	.string 86h,0
str_off_rnk	.string 8bh,0
str_pts_scrd	.string 81h,0
str_pts_allowd	.string 82h,0
str_wrld_recs	.string 91h,0
str_plr_att_pts	.string	83h,0
str_trivia_pts	.string "TRIVIA",1
		.string "POINTS",0
;str_tourn_wins	.string 8fh,0
str_next_cpu	.string 8ah,0
str_line10	.string	87h,0		;"YOU HAVE"
str_line11	.string 85h,' ',0	;"DEFEATED XX"
str_line12	.string	8ch,0		;"OF THE 29"
str_line13	.string	89h,0		;"NBA TEAMS"

;str_win_strks	.string	"WINSTREAK",0
;str_pts_game	.string	"PTS/GAME",0
;str_rebnds_game	.string	"REBOUNDS",0
;str_assist_game	.string	"ASSISTS",0
str_one		.string	"1",0
str_two		.string	"2",0
str_three	.string	"3",0
str_four	.string	"4",0

		.even

******************************************************************************

	.end

