;-----------------------------------------------------------------------------
;
* Owner:	JOHNSON
*
; Software:	Jeff Johnson
; Initiated:	12-10-95
;
; COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
;
;.Last mod - 12/11/95 
;-----------------------------------------------------------------------------
	.file	"select4.asm"
	.title	"option screen...etc"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"macros.hdr"

	.include	"imgtbl.glo"
	.include	"mugshot.glo"
;	.include	"imgtblp.glo"
	.include	"imgtblm.glo"
	.include	"names2.glo"		;New names from pnames2.img
	.include	"mugshot8.tbl"		;New names from pnames2.img

	.include	"prizes.tbl"


	.def	OUR_MUG,TOB_MUG,JAS_MUG,QUI_MUG,BOO_MUG,MARTY_MUG,CARL_MUG
	.def	create_plr_mugshots_tbl,create_plr_mugshots_tbl_end
	.def	player_heads,player_heads2		;table addr.
	.def	player_names				;table addr.

	.ref	ATRIBUTEBMOD,OPTSCRBMOD,ATRBKITBMOD
	.ref	M_FIF_P
	.ref	M_MAT_P,M_JOS_P,M_HEI_P,M_CRL_P,M_MAR_P
	.ref	M_BOO_P,M_QUI_P,M_TOB_P,M_OUR_P,M_JAS_P

	.ref	bounce_snd
	.ref	get_all_buttons_cur2
	.ref	GET_ADJ,GAMSTATE
	.ref	BKGDBMOD,KILBGND
	.ref	prizeg_p,prize1_p,prize2_p,prize3_p

	.ref	force_selection
	.ref	IRQSKYE,TWOPLAYERS
	.ref	BAKMODS,BGND_UD1
	.ref	PSTATUS
	.ref	player1_data,player2_data,player3_data,player4_data
	.ref	get_but_val_down,get_stick_val_down
	.ref	create_title_bar
	.ref	concat_string,concat_rom_string,copy_rom_string
	.ref	setup_message,copy_rom_string
	.ref	print_string2,print_string_C2,print_string_C3,print_string
	.ref	dec_to_asc,concat_rom_string
	.ref	mess_cursy,mess_cursx,message_palette
	.ref	mess_objid,mess_line_spacing
	.ref	bast7t_ascii,pal_getf
	.ref	timeout4,credits3
	.ref	init_x,kit_x
	.ref	RNDRNG0
	.ref	obj_delc,print_plr_name
	.ref	bast8_ascii,bast8t_ascii,bast10_ascii,brush20_ascii
	.ref	pal_clean
	.ref	PLTF5_B_P,PLTF5_G_P,PLTF5_Y_P,PLTF5_R_P
	.ref	SHAKER2
	.ref	plaque_xs,plaque_flsh_pals
	.ref	plaque_land3
	.ref	print_string_C
	.ref	dpageflip,WIPEOUT
	.ref	get_all_buttons_down
	.ref	bast18_ascii
	.ref	plaque_snds,plaque_lnds_snds
	.ref	yes_no_cur1,yes_no_cur2,yes_no_cur3,yes_no_cur4
	.ref	chkmrk_snd,chkmrk_snd2,chkmrk_snd3,chkmrk_snd4
	.ref	HALT
	.ref	HIDEAT


	.bss	answer,16
	.bss	answer_value,16
	.bss	plyrs_left,16
	.bss	plyrs_playing,16
	.bss	showing_info,16
	.bss	temp_halt,16
	.bss	trivia_page,16

	.text



	.asg	4,ANSWERS_ON_SCRN

	.asg	 34,LEGAL_STR_Y
	.asg	 68,PT_AWARD_Y

	.asg	 25,QUESTION_X
	.asg	 50,QUESTION_Y
	.asg	 54,RULES_Y
	.asg	 160,HIT_BUTN_Y

	.asg	105,ANSWER_HDR_X
	.asg	ANSWER_HDR_X+10,ANSWER_X
	.asg	95,ANSWER_Y
	.asg	15,ANSWER_LINE_SPC

	.asg	ANSWER_Y+(ANSWERS_ON_SCRN*ANSWER_LINE_SPC)+8,ANSWER_VAL_Y

	.asg	ANSWER_HDR_X+29,CURSOR_X

	.asg	188,NAME_Y
	.asg	215,PASSWORD_Y
	.asg	NAME_Y+17,TRIVIA_PTS_Y

	.asg	0,ANSWER_A
	.asg	1,ANSWER_B
	.asg	2,ANSWER_C
	.asg	3,ANSWER_D

	.asg	32+(16*6),TBL_SIZE

;-----------------------------------------------------------------------------
;	This routine computes the players password and displays it
;
; INPUT: reg  a9 - ptr to player record
;        reg a10 - player number
;	 reg  a1 - objs id
;-----------------------------------------------------------------------------
 SUBR	print_plr_password

	movi	trivia_password_setup,a2
	calla	setup_message

	move	a1,@mess_objid

	move	a10,a0
	sll	4,a0
	addi	pass_xs,a0
	move	*a0,a0
	move	a0,@mess_cursx

;create 'password'
	
	.ref	PASSWORD

	move	@mess_cursx,a0
	subi	35,a0
	sll	16,a0
	movi	[PASSWORD_Y-15,0],a1				;Y pos
	movi	PASSWORD,a2				;z pos
	movi	300,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	move	@mess_objid,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2


;combine all letters into a long

	move	*a9(PR_NAME1),a3
	sll	29,a3
	move	*a9(PR_NAME2),a14
	sll	24,a14
	or	a14,a3
	move	*a9(PR_NAME3),a14
	sll	19,a14
	or	a14,a3
	move	*a9(PR_NAME4),a14
	sll	14,a14
	or	a14,a3
	move	*a9(PR_NAME5),a14
	sll	9,a14
	or	a14,a3
	move	*a9(PR_NAME6),a14
	sll	4,a14
	or	a14,a3

;rotate each byte in long by appropiate pin number

;1st
	move	a3,a14
	andi	255,a14				;get 1st byte
	move	*a9(PR_PIN_NBR1),a1
	rl	a1,a14
	or	a14,a3


;2nd
	move	a3,a14
	srl	8,a14
	andi	255,a14				;get 2nd byte
	move	*a9(PR_PIN_NBR2),a1
	rl	a1,a14
	sll	8,a14
	or	a14,a3

;3rd
	move	a3,a14
	srl	16,a14
	andi	255,a14				;get 3rd byte
	move	*a9(PR_PIN_NBR3),a1
	rl	a1,a14
	sll	16,a14
	or	a14,a3

;4th
	move	a3,a14
	srl	24,a14
	andi	255,a14				;get 4th byte
	move	*a9(PR_PIN_NBR4),a1
	rl	a1,a14
	sll	24,a14
	or	a14,a3

	move	*a9(PR_PIN_NBR1),a14
	move	*a9(PR_PIN_NBR2),a1
	add	a1,a14
	move	*a9(PR_PIN_NBR3),a1
	add	a1,a14
	move	*a9(PR_PIN_NBR4),a1
	add	a1,a14

;rotate long by additive sum of pin numbers

	rl	a14,a3

;each nibble is a table offset
	
	move	a3,a4
	andi	15,a4				;get 1st nibble
	sll	4,a4
	addi	nib1_tbl,a4
	move	*a4,a4				;get letter offset
	sll	5,a4
	addi	letr_str_tbl,a4
	move	*a4,a4,L
	calla	copy_rom_string

;2nd nibble
	move	a3,a4
	srl	4,a4
	andi	15,a4				;get 1st nibble
	sll	4,a4
	addi	nib2_tbl,a4
	move	*a4,a4				;get letter offset
	sll	5,a4
	addi	letr_str_tbl,a4
	move	*a4,a4,L
	calla	concat_rom_string

;3rd nibble

	move	a3,a4
	srl	8,a4
	andi	15,a4				;get 1st nibble
	sll	4,a4
	addi	nib3_tbl,a4
	move	*a4,a4				;get letter offset
	sll	5,a4
	addi	letr_str_tbl,a4
	move	*a4,a4,L
	calla	concat_rom_string

;4th nibble

	move	a3,a4
	srl	12,a4
	andi	15,a4				;get 1st nibble
	sll	4,a4
	addi	nib4_tbl,a4
	move	*a4,a4				;get letter offset
	sll	5,a4
	addi	letr_str_tbl,a4
	move	*a4,a4,L
	calla	concat_rom_string

;5th nibble

	move	a3,a4
	srl	16,a4
	andi	15,a4				;get 1st nibble
	sll	4,a4
	addi	nib5_tbl,a4
	move	*a4,a4				;get letter offset
	sll	5,a4
	addi	letr_str_tbl,a4
	move	*a4,a4,L
	calla	concat_rom_string

;6th nibble

	move	a3,a4
	srl	20,a4
	andi	15,a4				;get 1st nibble
	sll	4,a4
	addi	nib6_tbl,a4
	move	*a4,a4				;get letter offset
	sll	5,a4
	addi	letr_str_tbl,a4
	move	*a4,a4,L
	calla	concat_rom_string

;7th nibble

	move	a3,a4
	srl	24,a4
	andi	15,a4				;get 1st nibble
	sll	4,a4
	addi	nib7_tbl,a4
	move	*a4,a4				;get letter offset
	sll	5,a4
	addi	letr_str_tbl,a4
	move	*a4,a4,L
	calla	concat_rom_string

;8th nibble

	move	a3,a4
	srl	28,a4
	andi	15,a4				;get 1st nibble
	sll	4,a4
	addi	nib8_tbl,a4
	move	*a4,a4				;get letter offset
	sll	5,a4
	addi	letr_str_tbl,a4
	move	*a4,a4,L
	calla	concat_rom_string
	calla	print_string_C
 	rets


pass_xs
	.word 	56,149,250,342

trivia_password_setup
	PRINT_STR	bast8t_ascii,9,1,199,PASSWORD_Y,BAST_W_P,0

nib1_tbl
	.word	0,15,16,4,8,0,4,23,25,3,18,10,21,20,11,19,5
nib2_tbl
	.word	14,1,12,12,10,20,23,22,2,19,21,10,21,8,7,6,4
nib3_tbl
	.word	24,1,3,5,2,4,16,7,11,19,10,8,12,23,6,9,4
nib4_tbl
	.word	15,24,23,12,11,10,19,8,17,6,15,4,13,2,1,0,15
nib5_tbl
	.word	20,11,22,23,14,25,20,25,18,9,23,0,2,5,8,21,10
nib6_tbl
	.word	0,15,16,4,8,0,4,23,18,3,18,10,21,20,11,19,4
nib7_tbl
	.word	1,9,5,7,2,11,13,15,18,21,24,25,23,0,4,8,14
nib8_tbl
	.word	11,15,24,13,12,2,6,4,1,8,7,24,12,18,19,10,8

letr_str_tbl
	.long	str_a
	.long	str_b
	.long	str_c
	.long	str_d
	.long	str_e
	.long	str_f
	.long	str_g
	.long	str_h
	.long	str_i
	.long	str_j
	.long	str_k
	.long	str_l
	.long	str_m
	.long	str_n
	.long	str_o
	.long	str_p
	.long	str_q
	.long	str_r
	.long	str_s
	.long	str_t
	.long	str_u
	.long	str_v
	.long	str_w
	.long	str_x
	.long	str_y
	.long	str_z

str_a
	.string	41h,0	;A
str_b
	.string	42h,0	;b
str_c
	.string	43h,0	;c
str_d
	.string	44h,0	;d
str_e
	.string	45h,0	;e
str_f
	.string	46h,0	;f
str_g
	.string	47h,0	;g
str_h
	.string	48h,0	;h
str_i
	.string	49h,0	;i
str_j
	.string	4ah,0	;j
str_k
	.string	4bh,0	;k
str_l
	.string	4ch,0	;l
str_m
	.string	4dh,0	;m
str_n
	.string	4eh,0	;n
str_o
	.string	4fh,0	;o
str_p
	.string	50h,0	;p
str_q
	.string	51h,0	;q
str_r
	.string	52h,0	;r
str_s
	.string	53h,0	;s
str_t
	.string	54h,0	;t
str_u
	.string	55h,0	;u
str_v
	.string	56h,0	;v
str_w
	.string	57h,0	;w
str_x
	.string	58h,0	;x
str_y
	.string	59h,0	;y
str_z
	.string	5ah,0	;z
	.even

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	trivia_game

	.asg	TYPTEXT+1,TYPFLASHTXT
	.ref	change_pal_on_text

	clr	a14
	move	a14,@trivia_page

	move	@HALT,a14
	move	a14,@temp_halt
	clr	a14
	move	a14,@HALT

;	BSSX	TRIVIA_TEST,16
;	move	@TRIVIA_TEST,a0
;	jrz	#tg1
;
;	movk	4,a14
;	jruc	tg_3
;#tg1
	clr	a14

	move	@PSTATUS,a0
	btst	0,a0				;plyr 1 ?
	jrz	tg_0				;br=nope
	move	@player1_data+PR_NAME1,a1
	jrle	tg_0				;br=player didn't enter inits
	move	@player1_data+PR_TRIVIA_PTS,a1
	cmpi	TRIVIA_PTS_NEEDED,a1
	jrhs	tg_0				;br=over prize level...ignore
	inc	a14
tg_0
	btst	1,a0				;plyr 2 ?
	jrz	tg_1				;br=nope
	move	@player2_data+PR_NAME1,a1
	jrle	tg_1				;br=player didn't enter inits
	move	@player2_data+PR_TRIVIA_PTS,a1
	cmpi	TRIVIA_PTS_NEEDED,a1
	jrhs	tg_1				;br=over prize level...ignore
	inc	a14
tg_1
	btst	2,a0				;plyr 3 ?
	jrz	tg_2				;br=nope
	move	@player3_data+PR_NAME1,a1
	jrle	tg_2				;br=player didn't enter inits
	move	@player3_data+PR_TRIVIA_PTS,a1
	cmpi	TRIVIA_PTS_NEEDED,a1
	jrhs	tg_2				;br=over prize level...ignore
	inc	a14
tg_2
	btst	3,a0				;plyr 4 ?
	jrz	tg_3				;br=nope
	move	@player4_data+PR_NAME1,a1
	jrle	tg_3				;br=player didn't enter inits
	move	@player4_data+PR_TRIVIA_PTS,a1
	cmpi	TRIVIA_PTS_NEEDED,a1
	jrhs	tg_3				;br=over prize level...ignore
	inc	a14
tg_3
	move	a14,a14
	jrz	tg_end				;br=nobody entered initial
	move	a14,@plyrs_playing
	move	a14,@plyrs_left

 SUBR	show_prizes

	movk	ADJTRIVIA,a0
	calla	GET_ADJ
	move	a0,a0			;if value is NON-ZERO, dont allow
	jrz	#dotriv
	RETP

#dotriv
	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT
	calla	pal_clean

	clr	a0
	move	a0,@IRQSKYE

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	SLEEPK	1

	movi	trivia_mod_prizes,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movk	1,a0
	calla	create_title_bar

	movi	trivia_game_title_setup,a2
	calla	setup_message
	movi	trivia_game_title,a4
	calla	print_string_C2

	movi	[198,0],a0			;Show prizes
	movi	[100,0],a1
	movi	300,a3
	movi	DMAWNZ|M_SCRNREL,a4
	movi	RULES_ID,a5
	clr	a6
	clr	a7
	movi	prizeG,a2
	calla	BEGINOBJ
	movi	[95,0],a0
	movi	[138,0],a1
	movi	prize1,a2
	calla	BEGINOBJ
	movi	[305,0],a0
	movi	[138,0],a1
	movi	prize2,a2
	calla	BEGINOBJ
	movi	[200,0],a0
	movi	[193,0],a1
	movi	prize3,a2
	calla	BEGINOBJ

	movi	prize_levels_str_setup,a2	;Show prize levels
	calla	setup_message
	movi	RULES_ID,a0
	move	a0,@mess_objid

	movi	37,a0				;!!!
	move	a0,@mess_cursy
	movi	przg_str,a4
	calla	print_string_C2
	movi	48,a0				;!!!
	move	a0,@mess_cursx
	movi	66,a0				;!!!
	move	a0,@mess_cursy
	movi	prz1_str,a4
	calla	print_string_C2
	movi	350,a0				;!!!
	move	a0,@mess_cursx
	movi	73,a0				;!!!
	move	a0,@mess_cursy
	movi	prz2_str,a4
	calla	print_string_C2
	movi	165,a0				;!!!
	move	a0,@mess_cursx
	movi	209,a0				;!!!
	move	a0,@mess_cursy
	movi	prz3_str,a4
	calla	print_string_C2

	movi	legal_notice_str_setup,a2	;Show prize descriptions
	calla	setup_message
	movi	RULES_ID,a0
	move	a0,@mess_objid
	movk	10,a0
	move	a0,@mess_line_spacing

	movi	55,a0				;!!!
	move	a0,@mess_cursy
	movi	dprzg_str,a4
	calla	print_string_C2
	movi	48,a0				;!!!
	move	a0,@mess_cursx
	movi	83,a0				;!!!
	move	a0,@mess_cursy
	movi	dprz1_str,a4
	calla	print_string_C2
	movi	350,a0				;!!!
	move	a0,@mess_cursx
	movi	90,a0				;!!!
	move	a0,@mess_cursy
	movi	dprz2_str,a4
	calla	print_string_C2
	movi	253,a0				;!!!
	move	a0,@mess_cursx
	movi	205,a0				;!!!
	move	a0,@mess_cursy
	movi	dprz3_str,a4
	calla	print_string_C2
	movi	70,a0				;!!!
	move	a0,@mess_cursx
	movi	205,a0				;!!!
	move	a0,@mess_cursy
	movi	bas7_alt,a0
	move	a0,@message_palette,L
	movi	ddln_str,a4
	calla	print_string_C2

	move	@GAMSTATE,a0
	cmpi	INAMODE,a0
	jrnz	#notam

	movk	1,a0				;In attract
	move	a0,@DISPLAYON
	calla	display_unblank

	SLEEP	40

	movi	7*TSEC,a8
#butp
	SLEEPK	1				;Show, wait, & die!
	calla	get_all_buttons_cur2
	jrz	#nobutp2
	SOUND1	bounce_snd
	jruc	#butp2
#nobutp2
	dsj	a8,#butp
#butp2
	RETP

#notam
	movi	rules_butn_setup,a2		;In trivia contest
	calla	setup_message
	movi	TYPFLASHTXT,a10
	move	a10,@mess_objid
	CREATE	FLSH_TXT_PID,change_pal_on_text

	movi	rules_butn_str,a4
	calla	print_string_C2

	movk	1,a0
	move	a0,@DISPLAYON
	calla	display_unblank

	movi	7*TSEC,a8
#przlp	
	SLEEPK	1
	calla	get_all_buttons_down
	jrz	#noprzb
	SOUND1	bounce_snd
	jruc	#tg0
#noprzb
	dsj	a8,#przlp
#tg0
	clr	a0				;Keep this page up while
	move	a0,@DISPLAYON			; building the next one
	move	a0,@dpageflip

	movi	RULES_ID,a0
	calla	obj_del1c
	movi	TYPFLASHTXT,a0
	calla	obj_del1c
	calla	KILBGND

	movi	trivia_mod_kit,a0
	move	@TWOPLAYERS,a14			;0 = NO, 1 = YES 2 players
	jrnz	tg_4
	movi	trivia_mod,a0
tg_4	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movk	1,a10
	CREATE0	plyr_select_answer
	movk	2,a10
	CREATE0	plyr_select_answer

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrnz	#2plr

	clr	a10
	CREATE0	plyr_select_answer
	movk	3,a10
	CREATE0	plyr_select_answer
#2plr
	movk	1,a14				;Don't show cursors yet
	move	a14,@trivia_page

;print game rules

	movi	trivia_rules_str_setup,a2	;Show rules
	calla	setup_message
	movi	RULES_ID,a0
	move	a0,@mess_objid
	movk	13,a0
	move	a0,@mess_line_spacing
	movi	rules_str,a4
	calla	print_string_C2
	
	movi	hit_butn_str_setup,a2		;Show button press
	calla	setup_message
	movi	TYPFLASHTXT,a0
	move	a0,@mess_objid
	movi	hit_butn_str,a4
	calla	print_string_C2

	CREATE0	credits3			;Display credits

	SLEEPK	1				;Make sure procs go active!

	movk	1,a0
	move	a0,@DISPLAYON
	move	a0,@dpageflip

	movi	7*TSEC,a8
tg_4a	
	SLEEPK	1
	calla	get_all_buttons_down
	jrz	#noprzb1
	SOUND1	bounce_snd
	jruc	tg_4b
#noprzb1
	dsj	a8,tg_4a
tg_4b
	clr	a0				;Keep this page up while
	move	a0,@DISPLAYON			; building the next one
	move	a0,@dpageflip

	movi	RULES_ID,a0
	calla	obj_del1c
	movi	TYPFLASHTXT,a0
	calla	obj_del1c
	calla	pal_clean

;print question
	movi	question_str_setup,a2
	calla	setup_message

	movi	RULES_ID,a0
	move	a0,@mess_objid

	movk	13,a0
	move	a0,@mess_line_spacing

	movi	NBR_QUESTIONS-1,a0		;Select rnd question #!
	calla	RNDRNG0

	move	a0,a1				;save table ptr.
	movi	TBL_SIZE,a0
	mpyu	a0,a1
	addi	trivia_tbl,a1
	move	a1,a10
	move	*a10+,a4,L			;get question str. ptr
	calla	print_string2

;get question value
 
	move	*a10+,a14,W
	move	a14,@answer_value

;print answers
	movi	answer_str_setup,a2
	calla	setup_message

	movi	RULES_ID,a0
	move	a0,@mess_objid

	movi	hdr_str_a,a4,L
	calla	copy_rom_string

;A
	move	*a10+,a14,W			;get first answer
	sll	5,a14
	addi	answer_tbl,a14
	move	*a14,a4,L			;get answer string ptr.
	calla	concat_rom_string
	calla	print_string

	move	@mess_cursy,a14
	addk	ANSWER_LINE_SPC,a14
	move	a14,@mess_cursy
;B
	movi	hdr_str_b,a4,L
	calla	copy_rom_string

	move	*a10+,a14,W			;get second answer
	sll	5,a14
	addi	answer_tbl,a14
	move	*a14,a4,L			;get answer string ptr.
	calla	concat_rom_string
	calla	print_string

	move	@mess_cursy,a14
	addk	ANSWER_LINE_SPC,a14
	move	a14,@mess_cursy
;C
	movi	hdr_str_c,a4,L
	calla	copy_rom_string

	move	*a10+,a14,W			;get third answer
	sll	5,a14
	addi	answer_tbl,a14
	move	*a14,a4,L			;get answer string ptr.
	calla	concat_rom_string
	calla	print_string

	move	@mess_cursy,a14
	addk	ANSWER_LINE_SPC,a14
	move	a14,@mess_cursy
;D
	move	@mess_cursx,a0
	inc	a0
	move	a0,@mess_cursx			;account for width of 'D'

	movi	hdr_str_d,a4,L
	calla	copy_rom_string

	move	*a10+,a14,W			;get fourth answer
	sll	5,a14
	addi	answer_tbl,a14
	move	*a14,a4,L			;get answer string ptr.
	calla	concat_rom_string
	calla	print_string

	move	*a10,a14,W			;get correct answer
	move	a14,@answer

;print answer value

	movi	answer_value_setup,a2
	calla	setup_message

	movi	RULES_ID,a0
	move	a0,@mess_objid

	movi	answer_val_str,a4
	calla	copy_rom_string

	move	@answer_value,a14			;get fourth answer
	sll	5,a14
	addi	pt_str_tbl,a14
	move	*a14,a4,L			;get answer string ptr.
	calla	concat_rom_string
	calla	print_string_C

	clr	a14
	move	a14,@force_selection
	move	a14,@showing_info		;not showing contest entry info

	movi	9*TSEC,a10			;10 seconds total
	CREATE	CNTDWN_PID,timeout4

	movk	2,a14				;Show cursors
	move	a14,@trivia_page

	SLEEPK	1				;Let them come up

	movk	1,a0
	move	a0,@DISPLAYON
	move	a0,@dpageflip

	.ref	tst_triva_sp
	SOUND1	tst_triva_sp
tg_9
	SLEEPK	1
	move	@plyrs_playing,a14
	jrgt	tg_9				; br=all player exited

tg_end
	move	@temp_halt,a14
	move	a14,@HALT

	movi	RULES_ID,a0
	calla	obj_del1c
	calla	pal_clean

	movi	CYCPID,a0
	calla	KIL1C
 	RETP


;-----------------------------------------------------------------------------
;	This PROCESS handles the logic for the player choosing an answer
; during the TRIVIA screen
;
; INPUT: reg. a10 - player number
;-----------------------------------------------------------------------------
 SUBRP	plyr_select_answer

	move	a10,a9
	sll	5,a9
	addi	plr_struct_tbl,a9
	move	*a9,a9,L			;get player data ptr.

;	move	@TRIVIA_TEST,a0
;	jrnz	tt_1				;br=trivia test...

	move	*a9(PR_NAME1),a14
	jrle	psa_end				;br=plyr didn't enter initials
	move	*a9(PR_TRIVIA_PTS),a14
	cmpi	TRIVIA_PTS_NEEDED,a14
	jrhs	psa_end				;br=over prize level...ignore
tt_1
	movi	name_setup,a2,L
	calla	setup_message
	calla	print_plr_name

	callr	print_trivia_pts_str
;
; create cursor
;
tt_2	SLEEPK	1
	move	@trivia_page,a14
	subk	1,a14
	jrle	tt_2

	clr	a11				;cursor position
	move	a10,a14
	sll	6,a14

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#2pr
	addi	plyr_cursor_tbl2,a14
	jruc	#2pr1    	
#2pr	addi	plyr_cursor_tbl,a14

#2pr1
	move	*a14+,a2,L
	move	*a14,a3,L			;get Z pos

	movi	[CURSOR_X,0],a0
	movi	[ANSWER_Y-2,0],a1				;Y pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	SLEEP	35
psa_2
	SLEEPK	1
	move	@trivia_page,a14
	jrz	psa_2
	move	@force_selection,a14
	jrnz	psa_5				;br=timed out, force selection

	move	a10,a0
	calla	get_stick_val_down
	cmpi	JOY_UP,a0
	jrne	psa_3
	move	a11,a11				;zero ?
	jrle	psa_4				;br=yep				
	dec	a11
psa_2a	move	*a8(OYPOS),a14
	subk	ANSWER_LINE_SPC,a14
	move	a14,*a8(OYPOS)
	callr	move_cursor_snd
	jruc	psa_4

psa_3	cmpi	JOY_DOWN,a0
	jrne	psa_4
	cmpi	ANSWERS_ON_SCRN-1,a11		;at limit ?
	jrge	psa_4				;br=yep, dont move cursor
	inc	a11
	move	*a8(OYPOS),a14
	addk	ANSWER_LINE_SPC,a14
	move	a14,*a8(OYPOS)
	callr	move_cursor_snd

psa_4	move	a10,a0
	calla	get_but_val_down
    	cmpi	TURBO_BUTTON,a0
	jreq	psa_5
    	cmpi	SHOOT_BUTTON,a0
	jreq	psa_5
    	cmpi	PASS_BUTTON,a0
	jrne	psa_2

psa_5
	callr	move_select_snd
	JSRP	flash_plyr_cursor

	move	@plyrs_left,a0
	dec	a0
	move	a0,@plyrs_left			;player selected ANSWER !!

	PUSHP	a9
	movi	wrong_answer_imgs,a14
	move	@answer,a0
	cmp	a0,a11				;answer correct ?
	jrne	psa_5a				;br=no
	movi	correct_answer_imgs,a14
psa_5a	move	a10,a0
	sll	5,a0
	add	a0,a14
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	psa_5b
	addi	4*32,a14			;get KIT image ptr.
psa_5b	move	*a14,a9,L
	JSRP	anim_answer_plaque
	PULLP	a9

	calla	DELOBJA8			;delete players cursor

	move	@answer,a0
	cmp	a0,a11				;answer correct ?
	jrne	psa_6a				;br=no

	move	*a9(PR_TRIVIA_PTS),a14
	move	@answer_value,a0		;points to add
	add	a14,a0
	move	a0,*a9(PR_TRIVIA_PTS)
	cmpi	TRIVIA_PTS_NEEDED,a0
	jrlo	psa_6				;br=not at prize level...yet
	JSRP	show_player_password
	jruc	psa_6a
psa_6
	callr	update_trivia_pts_msg
psa_6a

;;FIX!! (remove after show)
;	move	@jeftmp,a14,L
;	cmpi	QUALIFYgrn,a14
;	jrne	aap5a
;	movi	3*TSEC,a8			;max time to hold
;	jruc	aap6
;;FIX!! (remove after show)
aap5a
	SLEEP	15
	movi	2*TSEC,a8			;max time to hold
aap6
	SLEEPK	1
	move	a10,a0
	calla	get_but_val_down
	jrnz	aap7
     	dsj	a8,aap6
aap7
	

	move	@plyrs_playing,a14
	dec	a14
	move	a14,@plyrs_playing
psa_end
	DIE

;-----------------------------------------------------------------------------
;		Make cursor sounds
;
; INPUT: reg a10 - player number
;-----------------------------------------------------------------------------
 SUBR	move_cursor_snd

	move	a10,a14
	sll	5,a14
	addi	cur_snds_tbl,a14
	move	*a14,a0,L
	calla	snd_play1
	rets


;-----------------------------------------------------------------------------
;		Make select sound
;
; INPUT: reg a10 - player number
;-----------------------------------------------------------------------------
 SUBR	move_select_snd

	move	a10,a14
	sll	5,a14
	addi	select_snds_tbl,a14
	move	*a14,a0,L
	calla	snd_play1
	rets



cur_snds_tbl
	.long	yes_no_cur1
	.long	yes_no_cur2
	.long	yes_no_cur3
	.long	yes_no_cur4


select_snds_tbl
	.long	chkmrk_snd
	.long	chkmrk_snd2
	.long	chkmrk_snd3
	.long	chkmrk_snd4


bas7_alt
	.word	3
	.word	0,0,(1fh*32+0ch)*32+1fh


rules_butn_setup
	PRINT_STR	bast10_ascii,8,0,199,235,BAST_W_P,0

prize_levels_str_setup
	PRINT_STR	bast10_ascii,8,0,199,RULES_Y,BAST_Y_P,0

trivia_rules_str_setup
	PRINT_STR	bast10_ascii,8,0,199,RULES_Y,BAST_W_P,0

hit_butn_str_setup
	PRINT_STR	bast8_ascii,7,0,199,HIT_BUTN_Y,BAST_W_P,0

question_str_setup
	PRINT_STR	bast10_ascii,8,0,QUESTION_X,QUESTION_Y,BAST_Y_P,0

answer_str_setup
	PRINT_STR	bast10_ascii,8,0,ANSWER_X,ANSWER_Y,BAST_W_P,0

trivia_game_title_setup
	PRINT_STR	brush20_ascii,10,0,199,5,BRSHGYOP,0

legal_notice_str_setup
	PRINT_STR	bast7t_ascii,5,0,199,LEGAL_STR_Y,BAST_W_P,0

answer_value_setup
	PRINT_STR	bast7t_ascii,5,0,199,ANSWER_VAL_Y+2,BAST_C_P,0


pt_str_tbl
	.long	0
	.long	one_point
	.long	two_points
	.long	three_points
	.long	four_points
	.long	five_points
	.long	six_points
	.long	seven_points
	.long	eight_points
	.long	nine_points
	.long	ten_points


przg_str
	.string	"GRAND PRIZE",0
	.even
dprzg_str
	.string	"A TRIP FOR 2 TO AN NBA GAME!",0
	.even
prz1_str
	.string	"1ST",0
	.even
dprz1_str
	.string	"NBA HANGTIME",1
	.string	"ARCADE GAME",0
	.even
prz2_str
	.string	"2ND",0
	.even
dprz2_str
	.string	"25 OFFICIAL",1
	.string	"NBA JERSEYS",0
	.even
prz3_str
	.string	"3RD",0
	.even
dprz3_str
	.string	"1,000 HANGTIME",1
	.string	"T-SHIRTS",0
	.even
ddln_str
	.string	"CONTEST ENDS",1
	.string	"SEPTEMBER 13,1996",0
	.even
rules_butn_str
	.string	"HIT ANY BUTTON FOR RULES",0
	.even

one_point
	.string " 1 POINT",0
	.even
two_points
	.string " 2 ",81h,0
	.even
three_points
	.string " 3 ",81h,0
	.even
four_points
	.string " 4 ",81h,0
	.even
five_points
	.string " 5 ",81h,0
	.even
six_points
	.string " 6 ",81h,0
	.even
seven_points
	.string " 7 ",81h,0
	.even
eight_points
	.string " 8 ",81h,0
	.even
nine_points
	.string " 9 ",81h,0
	.even
ten_points
	.string " 10 ",81h,0
	.even


trivia_game_title
	.string	80h," ",81h,0
;	.string	"TRIVIA CONTEST",0
	.even

answer_val_str
	.string 80h,0
;	.string "CORRECT ANSWER: ",0
	.even

hit_butn_str
	.string "HIT ANY BUTTON FOR TRIVIA QUESTION",0
;;	.string "START BUTTON BYPASSES TRIVIA CONTEST",0
	.even

rules_str
;	.string	"TO SELECT AN ANSWER TO THE TRIVIA",1
;	.string	"QUESTION, MOVE THE JOYSTICK UP OR DOWN",1
;	.string	"AND THEN PRESS ANY BUTTON.",1
;	.string	1
	.string	"RAISE YOUR TRIVIA POINT TOTAL TO",1
	.string	"100 POINTS TO BECOME AN",1
	.string	"NBA HANGTIME TRIVIA CHAMPION!",1
	.string	1
	.string	"YOU WILL THEN BE GIVEN A SECRET",1
	.string	"PASSWORD FOR ENTRY INTO THE",1
	.string	"NBA HANGTIME TRIVIA SWEEPSTAKES!",1
	.even
	

trivia_mod
	.long	OPTSCRBMOD			;option screen background
	.word	0,0
	.long	ATRIBUTEBMOD			;option screen background
	.word	0,178		;x,y
	.long	0
	
trivia_mod_kit
	.long	OPTSCRBMOD			;option screen background
	.word	0,0
	.long	ATRBKITBMOD			;option screen background
	.word	0,178		;x,y
	.long	0

trivia_mod_prizes
	.long	BKGDBMOD
	.word	0,0
	.long	0


;
; This table contains:
;
; 1) Question to ask
; 2) Possible answer A
; 3) Possible answer B
; 4) Possible answer C
; 5) Possible answer D
; 6) Correct answer
;
trivia_tbl
   LWWWWWW	question1,  1,  1,  4, 6,   7,ANSWER_B
   LWWWWWW	question2,  2, 12, 13,14,  15,ANSWER_C
   LWWWWWW	question3,  1,233,234,235,236,ANSWER_A
   LWWWWWW	question4,  1, 16, 17, 18, 19,ANSWER_B
   LWWWWWW	question5,  1, 20, 21, 22, 23,ANSWER_D
   LWWWWWW	question6,  1, 20, 21, 22, 23,ANSWER_D
   LWWWWWW	question7,  1,247,235,245,236,ANSWER_A
   LWWWWWW	question8,  1,236,270,271,245,ANSWER_D
   LWWWWWW	question9,  1,  2,  3,  6,  5,ANSWER_A
   LWWWWWW	question10, 1, 24, 25, 17, 26,ANSWER_A
   LWWWWWW	question11, 2, 27, 28, 29, 18,ANSWER_A
   LWWWWWW	question12, 2, 30, 31, 32, 33,ANSWER_D
   LWWWWWW	question13, 2, 34, 12, 35, 36,ANSWER_A
   LWWWWWW	question14, 2, 37, 38, 36, 39,ANSWER_C
   LWWWWWW	question15, 1, 40, 38, 41, 42,ANSWER_A
   LWWWWWW	question16, 2, 24, 16, 23, 39,ANSWER_D
   LWWWWWW	question17, 1, 43, 44, 45, 46,ANSWER_A
   LWWWWWW	question18, 1, 43, 44, 45, 46,ANSWER_B
   LWWWWWW	question19, 1, 43, 44, 45, 46,ANSWER_C
   LWWWWWW	question20, 1, 43, 44, 45, 46,ANSWER_D
   LWWWWWW	question21, 1, 43, 44, 45, 47,ANSWER_D
   LWWWWWW	question22, 1,266,292,244,253,ANSWER_A
   LWWWWWW	question23, 1,260,270,259,274,ANSWER_A
   LWWWWWW	question24, 2, 12, 14, 15, 62,ANSWER_C
;   LWWWWWW	question25, 2, 63, 64, 36, 65,ANSWER_B
   LWWWWWW	question26, 1, 40, 66, 67, 68,ANSWER_B
   LWWWWWW	question27, 1, 69, 70, 71, 72,ANSWER_B
   LWWWWWW	question28, 1, 20, 16, 70, 18,ANSWER_D
;   LWWWWWW	question29, 1, 73, 40, 16, 49,ANSWER_C
   LWWWWWW	question30, 1, 20, 74, 37, 75,ANSWER_C
   LWWWWWW	question31, 1, 24, 76, 77, 13,ANSWER_B
   LWWWWWW	question32, 1, 78, 79, 29, 19,ANSWER_C
   LWWWWWW	question33, 2, 80, 81, 82, 50,ANSWER_A
   LWWWWWW	question34, 2, 29, 43, 47, 63,ANSWER_B
   LWWWWWW	question35, 2, 26, 83, 84, 78,ANSWER_C
   LWWWWWW	question36, 1, 64, 70, 85, 86,ANSWER_D
   LWWWWWW	question37, 2, 87, 88, 89, 90,ANSWER_D
   LWWWWWW	question38, 1,  8,  9, 10, 11,ANSWER_B
   LWWWWWW	question39, 1, 73, 91, 54, 92,ANSWER_C
;   LWWWWWW	question40, 1, 93, 94, 68, 95,ANSWER_D
   LWWWWWW	question41, 1, 23, 73, 19, 21,ANSWER_B
   LWWWWWW	question42, 1, 16, 74, 70, 73,ANSWER_C
   LWWWWWW	question43, 1, 96, 28, 97, 26,ANSWER_D
   LWWWWWW	question44, 2,246,235,233,247,ANSWER_C
   LWWWWWW	question45, 2,271,244,254,300,ANSWER_A
   LWWWWWW	question46, 5,272,236,301,233,ANSWER_D
   LWWWWWW	question47, 2,187,188,189,190,ANSWER_D
   LWWWWWW	question48, 2,191,192,193,194,ANSWER_A
   LWWWWWW	question49, 2,198,195,207,196,ANSWER_D
   LWWWWWW	question50, 2,196,197,198,188,ANSWER_D
   LWWWWWW	question51, 2,199,200,201,191,ANSWER_C
   LWWWWWW	question52, 2,198,197,202,203,ANSWER_B
   LWWWWWW	question53, 2,192,191,204,193,ANSWER_D
   LWWWWWW	question54, 2,205,206,202,207,ANSWER_C
   LWWWWWW	question55, 2,208,188,197,189,ANSWER_B
   LWWWWWW	question56, 2,202,190,209,210,ANSWER_D
   LWWWWWW	question57, 2,206,205,210,195,ANSWER_C
   LWWWWWW	question58, 2,206,212,205,213,ANSWER_A
   LWWWWWW	question59, 2,212,189,196,213,ANSWER_B
   LWWWWWW	question60, 2,188,214,215,216,ANSWER_B
   LWWWWWW	question61, 1,163,164,165,166,ANSWER_A
;   LWWWWWW	question62, 1, 48, 34, 49, 16,ANSWER_D
   LWWWWWW	question63, 2, 29, 38, 50, 16,ANSWER_B
   LWWWWWW	question64, 2,174,173,172,175,ANSWER_B
   LWWWWWW	question65, 1,170,167,169,168,ANSWER_B
   LWWWWWW	question66, 1, 51, 52, 33, 53,ANSWER_B
   LWWWWWW	question67, 1, 54, 55, 56, 57,ANSWER_C
   LWWWWWW	question68, 1, 58, 59, 60, 61,ANSWER_D
   LWWWWWW	question69, 1,243,244,235,301,ANSWER_D
   LWWWWWW	question70, 1, 98, 99, 35,100,ANSWER_A
;   LWWWWWW	question71, 1,177,182,180,181,ANSWER_C
   LWWWWWW	question72, 1, 14, 71, 62,101,ANSWER_C
   LWWWWWW	question73, 1,171,176,179,178,ANSWER_C
   LWWWWWW	question74, 2,102, 68,103,112,ANSWER_A
   LWWWWWW	question75, 1, 30, 26,104,340,ANSWER_B
   LWWWWWW	question76, 1,105, 64, 47, 63,ANSWER_D
   LWWWWWW	question77, 2,233,246,247,236,ANSWER_A
   LWWWWWW	question78, 2, 83,106,107, 32,ANSWER_C
   LWWWWWW	question79, 1, 47, 45,108, 43,ANSWER_A
   LWWWWWW	question80, 1,109,110, 77, 12,ANSWER_C
   LWWWWWW	question81, 1,248,249,250,251,ANSWER_C
   LWWWWWW	question82, 1,247,252,253,254,ANSWER_B
   LWWWWWW	question83, 1,255,221,256,257,ANSWER_A
;   LWWWWWW	question84, 1,183,184,185,186,ANSWER_C
   LWWWWWW	question85, 1,219,238,251,258,ANSWER_B
   LWWWWWW	question86, 2,109, 85, 20, 21,ANSWER_A
   LWWWWWW	question87, 1,243,261,325,259,ANSWER_D
   LWWWWWW	question88, 1,247,252,260,261,ANSWER_A
   LWWWWWW	question89, 1, 50,111, 49, 69,ANSWER_A
   LWWWWWW	question90, 1, 18,113, 19,114,ANSWER_A
;   LWWWWWW	question91, 1,111, 38, 16, 50,ANSWER_C
   LWWWWWW	question92, 1,230,226,262,263,ANSWER_D
   LWWWWWW	question93, 2,115, 19,116, 21,ANSWER_D
   LWWWWWW	question94, 2,117,112,118, 62,ANSWER_B
   LWWWWWW	question95, 2, 73,114,119,107,ANSWER_D
   LWWWWWW	question96, 2,120,113,121, 96,ANSWER_B
   LWWWWWW	question97, 2, 24, 38,106,111,ANSWER_D
   LWWWWWW	question98, 1,122, 17,123,112,ANSWER_D
   LWWWWWW	question99, 1,264,223,265,256,ANSWER_C
   LWWWWWW	question100,2, 70, 78,124,125,ANSWER_C
   LWWWWWW	question101,2, 13, 70, 77, 60,ANSWER_C
   LWWWWWW	question102,2, 77,126,124,127,ANSWER_B
   LWWWWWW	question103,2, 76,128,129, 51,ANSWER_A
   LWWWWWW	question104,2, 70, 21, 18, 20,ANSWER_D
   LWWWWWW	question105,2, 23, 70, 14, 20,ANSWER_B
   LWWWWWW	question106,2, 70, 19, 34, 77,ANSWER_A
;   LWWWWWW	question107,2, 20,130, 18,131,ANSWER_C
   LWWWWWW	question108,2, 20, 29, 23, 76,ANSWER_C
   LWWWWWW	question109,2, 70, 18, 14, 73,ANSWER_D
   LWWWWWW	question110,2,132, 99,133, 83,ANSWER_B
   LWWWWWW	question111,2,117,106,135,132,ANSWER_D
   LWWWWWW	question112,2,117,106,135, 86,ANSWER_A
   LWWWWWW	question113,2, 20,134, 26, 28,ANSWER_C
   LWWWWWW	question114,2,134, 26,135,136,ANSWER_B
;   LWWWWWW	question115,2,137, 14, 26, 20,ANSWER_D
   LWWWWWW	question116,2, 26, 17, 14,138,ANSWER_C
   LWWWWWW	question117,2, 75, 23, 78, 18,ANSWER_B
   LWWWWWW	question118,2, 17, 37, 73, 18,ANSWER_C
;   LWWWWWW	question119,2,139, 23, 19,140,ANSWER_C
   LWWWWWW	question120,2,230,231,232,237,ANSWER_D
   LWWWWWW	question121,2,226,232,238,221,ANSWER_B
   LWWWWWW	question122,2, 29, 19,114, 14,ANSWER_D
   LWWWWWW	question123,2,217,218,219,239,ANSWER_C
   LWWWWWW	question124,2,302,303,341,304,ANSWER_C
   LWWWWWW	question125,2,220,221,222,223,ANSWER_D
   LWWWWWW	question126,2,224,225,226,227,ANSWER_C
   LWWWWWW	question127,2,228,229,240,218,ANSWER_D
   LWWWWWW	question128,2,241,227,239,242,ANSWER_B
   LWWWWWW	question129,2,123, 74,141,142,ANSWER_A
   LWWWWWW	question130,2,143,144,129,145,ANSWER_D
   LWWWWWW	question131,2,146, 98,100, 35,ANSWER_C
   LWWWWWW	question132,1, 98, 75,147,148,ANSWER_B
   LWWWWWW	question133,1,149, 38,111,150,ANSWER_B
   LWWWWWW	question134,1,271,247,267,274,ANSWER_B
   LWWWWWW	question135,1,271,247,267,274,ANSWER_A
   LWWWWWW	question136,1,270,247,259,274,ANSWER_C
   LWWWWWW	question137,1,266,267,268,243,ANSWER_D
   LWWWWWW	question138,1,233,244,245,234,ANSWER_D
   LWWWWWW	question139,2,269,252,243,260,ANSWER_A
   LWWWWWW	question140,2,272,273,247,233,ANSWER_C
;   LWWWWWW	question141,2,151,152,153,154,ANSWER_A
;   LWWWWWW	question142,2,155,156,157,158,ANSWER_B
;   LWWWWWW	question143,2,247,268,267,244,ANSWER_A
;   LWWWWWW	question144,1,312,313,314,317,ANSWER_C
;   LWWWWWW	question145,1,312,313,314,321,ANSWER_A
   LWWWWWW	question146,1,312,313,314,331,ANSWER_B
   LWWWWWW	question147,1,312,313,314,332,ANSWER_B
;   LWWWWWW	question148,2,306,310,307,305,ANSWER_A
   LWWWWWW	question149,2,336,337,338,339,ANSWER_B
   LWWWWWW	question150,1,312,313,314,326,ANSWER_A
   LWWWWWW	question151,1,312,313,314,334,ANSWER_A
   LWWWWWW	question152,1,312,313,314,335,ANSWER_B
   LWWWWWW	question153,1,270,254,260,234,ANSWER_A
   LWWWWWW	question154,2,266,274,272,236,ANSWER_C
   LWWWWWW	question155,2,268,266,273,271,ANSWER_A
   LWWWWWW	question156,1,292,247,271,266,ANSWER_C
   LWWWWWW	question157,1,293,294,295,296,ANSWER_C
   LWWWWWW	question158,1,203,189,205,206,ANSWER_B
   LWWWWWW	question159,1,275,276,277,278,ANSWER_C
   LWWWWWW	question160,1,279,280,281,275,ANSWER_B
   LWWWWWW	question161,1,312,314,313,321,ANSWER_B
   LWWWWWW	question162,1,312,314,313,316,ANSWER_B
   LWWWWWW	question163,1,312,314,313,324,ANSWER_B
   LWWWWWW	question164,1,312,314,313,317,ANSWER_B
   LWWWWWW	question165,1,312,314,313,330,ANSWER_C
   LWWWWWW	question166,1,312,314,313,332,ANSWER_A
   LWWWWWW	question167,1,312,314,313,323,ANSWER_B
   LWWWWWW	question168,1,312,314,313,315,ANSWER_B
   LWWWWWW	question169,1,312,314,313,316,ANSWER_C
   LWWWWWW	question170,1,282,283,284,285,ANSWER_A
   LWWWWWW	question171,1,286,287,288,289,ANSWER_C
   LWWWWWW	question172,1,290,291,289,288,ANSWER_C
   LWWWWWW	question173,1,112, 50, 54, 24,ANSWER_A
   LWWWWWW	question174,1,159, 78, 22, 88,ANSWER_A
   LWWWWWW	question175,1,160, 30, 62, 71,ANSWER_D
   LWWWWWW	question176,1,261,244,245,260,ANSWER_A
   LWWWWWW	question177,1,289,297,298,299,ANSWER_B
   LWWWWWW	question178,1,289,298,299,297,ANSWER_C
   LWWWWWW	question179,2,307,311,309,308,ANSWER_A
   LWWWWWW	question180,1,269,254,247,259,ANSWER_B
   LWWWWWW	question181,2,269,252,272,234,ANSWER_B
   LWWWWWW	question182,2,244,271,252,266,ANSWER_A
;   LWWWWWW	question183,2, 14, 16, 20,118,ANSWER_C
   LWWWWWW	question184,2, 17,161,107,162,ANSWER_A
   LWWWWWW	question185,2,246,236,244,243,ANSWER_A
   LWWWWWW	question186,1,312,314,313,331,ANSWER_A
   LWWWWWW	question187,1,312,314,313,322,ANSWER_B
   LWWWWWW	question188,1,312,314,313,330,ANSWER_A
   LWWWWWW	question189,1,312,314,313,324,ANSWER_C
   LWWWWWW	question190,1,312,314,313,329,ANSWER_C
   LWWWWWW	question191,1,312,314,313,328,ANSWER_B
   LWWWWWW	question192,1,312,314,313,325,ANSWER_A
   LWWWWWW	question193,1,312,314,313,331,ANSWER_A
   LWWWWWW	question194,1,312,314,313,327,ANSWER_A
   LWWWWWW	question195,1,312,314,313,326,ANSWER_A
   LWWWWWW	question196,1,312,314,313,332,ANSWER_B
   LWWWWWW	question197,1,312,314,313,318,ANSWER_A
   LWWWWWW	question198,1,312,314,313,319,ANSWER_B
   LWWWWWW	question199,1,312,314,313,320,ANSWER_A
   LWWWWWW	question200,1,312,314,313,334,ANSWER_A
trivia_tbl_end
   .long	-1

NBR_QUESTIONS equ	(trivia_tbl_end-trivia_tbl)/(32+(16*6))



question1
	.string	"WHAT COLLEGE DID SCOTTIE PIPPEN",1
	.string	"ATTEND ?",0
	.even
question2
	.string	"WHAT PLAYER'S DRAFT RIGHTS DID THE",1
	.string	"SEATTLE SUPERSONICS TRADE FOR THE",1
	.string "DRAFT RIGHTS OF OLDEN POLYNICE ?",0
	.even
question3
	.string	"WHAT TEAM DID BOBBY PHILLS PLAY FOR",1
	.string "DURING THE 1994-95 NBA SEASON ?",0
	.even
question4
	.string	"WHO RECEIVED THE HIGHEST NUMBER OF FANS",1
	.string "VOTES FOR THE 1995 NBA ALL-STAR GAME ?",0
	.even
question5
	.string "WHO WAS SELECTED WITH THE FIRST OVERALL",1
	.string "PICK IN THE 1984 NBA DRAFT ?",0
	.even
question6
	.string "WHO WAS SELECTED WITH THE FIRST OVERALL",1
	.string "PICK IN THE 1985 NBA DRAFT ?",0
	.even
question7
	.string "WHAT TEAM ACQUIRED THE DRAFT RIGHTS TO",1
	.string "CHARLES OAKLEY IN 1985 ?",0
	.even
question8
	.string "WHAT NBA TEAM DRAFTED TWO PLAYERS FROM",1
	.string "THE UNIVERSITY OF ARKANSAS IN 1992 ?",0
	.even
question9
	.string "WHAT COLLEGE DID GLEN RICE ATTEND ?",0
	.even
question10
	.string "WHAT NBA PLAYER HAS THE NICKNAMES",1
	.string "THE 'WAITER' AND 'PINK PANTHER' ?",0
	.even
question11
	.string "WHAT NBA PLAYER SURPASSED NATE ARCHIBALD",1
	.string "AS THE ALL-TIME SCORING LEADER AT THE",1
	.string "UNIVERSITY OF TEXAS-EL PASO ?",0
	.even
question12
	.string "WHO WAS THE FIRST PLAYER IN NBA HISTORY",1
	.string "TO IMPROVE HIS SCORING AVERAGE IN EACH",1
	.string "OF HIS FIRST EIGHT YEARS IN THE LEAGUE ?",0
	.even
question13
	.string "WHAT NBA PLAYER WAS NAMED PLAYER",1
	.string "OF THE YEAR FOR THE ACC CONFERENCE",1
	.string "DURING THE 1986-87 BASKETBALL SEASON ?",0
	.even	  
question14
	.string "WHAT NBA PLAYER WAS NAMED PLAYER OF THE",1
	.string "YEAR FOR THE SOUTHEASTERN CONFERENCE",1
	.string "DURING THE 1987-88 BASKETBALL SEASON ?",0
	.even
question15
	.string "WHAT NBA PLAYER WAS A MEMBER OF",1
	.string "BACK-TO-BACK NCAA CHAMPIONSHIP TEAMS",1
	.string "WITH BOBBY HURLEY AND GRANT HILL ?",0
	.even	  
question16
	.string "WHAT NBA PLAYER WAS BORN IN TRINIDAD",1
	.string "AND RAISED IN VENEZUELA ?",0
	.even
question17
	.string "WHAT NBA PLAYER WAS SELECTED WITH",1
	.string "THE FIRST OVERALL PICK IN THE 1995",1
	.string "NBA DRAFT ?",0
	.even
question18
	.string "WHAT NBA PLAYER WAS SELECTED WITH",1
	.string "THE SECOND OVERALL PICK IN THE 1995",1
	.string "NBA DRAFT ?",0
	.even
question19
	.string "WHAT NBA PLAYER WAS SELECTED WITH",1
	.string "THE THIRD OVERALL PICK IN THE 1995",1
	.string "NBA DRAFT ?",0
	.even
question20
	.string "WHAT NBA PLAYER WAS SELECTED WITH",1
	.string "THE FOURTH OVERALL PICK IN THE 1995",1
	.string "NBA DRAFT ?",0
	.even
question21
	.string "WHAT NBA PLAYER WAS SELECTED WITH THE",1
	.string "FIFTH OVERALL PICK IN THE 1995 NBA DRAFT ?",0
	.even
question22
	.string "WHAT TEAM DRAFTED DAMON STOUDAMIRE IN",1
	.string "THE 1995 NBA DRAFT ?",0
	.even
question23
	.string "WHAT NBA TEAM DID OTIS THORPE PLAY FOR",1
	.string "DURING THE 1993-94 SEASON ?",0
	.even
question24
	.string "WHAT NBA PLAYER WAS THE SECOND OVERALL",1
	.string "PICK IN THE 1988 NBA DRAFT ?",0
	.even
;question25
;	.string "WHAT CHICAGO BULLS PLAYER WENT ON THE",1
;	.string "INJURED LIST ON MARCH 18, 1995 WHEN",1
;	.string "MICHAEL JORDAN CAME OUT OF RETIREMENT ?",0
;	.even
question26
	.string "WHAT NBA PLAYER WAS AWARDED THE",1
	.string "WOODEN AWARD IN 1990 AS COLLEGE ",1
	.string "BASKETBALLS' PLAYER OF THE YEAR ?",0
	.even
question27
	.string "WHAT NBA PLAYERS' NICKNAME IS",1
	.string "'THE WORM' ?",0
	.even
question28
	.string "WHAT NBA PLAYER CLINCHED THE SCORING",1
	.string "TITLE FOR THE 1993-94 SEASON ?",0
	.even
;question29
;	.string "WHO WAS THE ONLY ROOKIE TO PLAY IN",1
;	.string "THE 1992 NBA ALL-STAR GAME ?",0
;	.even
question30
	.string "WHAT NBA PLAYER WON THE SLAM DUNK",1
	.string "CONTEST FOR THE SECOND TIME IN 1995 ?",0
	.even
question31
	.string "WHAT NBA PLAYER WON THE NBA'S SIXTH",1
	.string "MAN AWARD FOR THE 1994-95 SEASON ?",0
	.even
question32
	.string "WHAT NBA PLAYER HAS THE NICKNAME",1
	.string "'THE MAILMAN' ?",0
	.even
question33
	.string "WHAT NBA PLAYER WAS SELECTED 10TH",1
	.string "OVERALL IN THE 1993 NBA DRAFT ?",0
	.even
question34
	.string "WHICH OF THE FOLLOWING NBA PLAYERS WAS",1
	.string "BORN IN 1975 ?",0
	.even
question35
	.string "WHICH OF THE FOLLOWING NBA PLAYERS WAS",1
	.string "NOT SELECTED IN THE FIRST ROUND OF",1
	.string "THE NBA DRAFT ?",0
	.even
question36
	.string "WHICH PLAYER PLAYED IN THE CONTINENTIAL",1
	.string "BASKETBALL ASSOCIATION AND THE WORLD",1
	.string "BASKETBALL LEAGUE BEFORE JOINING THE NBA ?",0
	.even
question37
	.string "WHICH OF THE FOLLOWING NBA PLAYERS HAS",1
	.string "THE NICKNAME 'WOOKIE' ?",0
	.even
question38
	.string "WHAT COLLEGE DID SARUNAS MARCIULIONIS",1
	.string "ATTEND ?",0
	.even
question39
	.string "WHAT NBA PLAYER LED THE DENVER NUGGETS",1
	.string "IN ASSISTS DURING THE 1994-95 SEASON ?",0
	.even
;question40
;	.string "WHAT NBA CENTER WAS A TEAMMATE OF",1
;	.string "SHAQUILLE O'NEAL IN COLLEGE ?",0
;	.even
question41
	.string "WHAT PLAYER WAS THE NBA LEAGUE LEADER",1
	.string "IN BLOCKED SHOTS FOR THE 1994-95 SEASON ?",0
	.even
question42
	.string "WHAT PLAYER WAS THE NBA LEAGUE LEADER",1
	.string "IN REBOUNDS FOR THE 1994-95 NBA SEASON ?",0
	.even
question43
	.string "WHAT PLAYER WAS THE NBA LEAGUE LEADER",1
	.string "IN ASSISTS FOR THE 1994-95",1
	.string "NBA SEASON ?",0
	.even
question44
	.string "WHAT NBA TEAM ALLOWED THE FEWEST POINTS",1
	.string "PER GAME DURING THE 1994-95 SEASON ?",0
	.even
question45
	.string "WHAT NBA TEAM SCORED THE MOST POINTS",1
	.string "PER GAME DURING THE 1994-95 SEASON ?",0
	.even
question46
	.string "WHAT NBA TEAM SCORED THE FEWEST POINTS",1
	.string "PER GAME DURING THE 1994-95 SEASON ?",0
	.even
question47
	.string "WHAT IS RIK SMITS' NATIVE COUNTRY ?",0
	.even
question48
	.string "WHAT IS HAKEEM OLAJUWONS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question49
	.string "WHAT IS GHEORGHE MURESANS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question50
	.string "WHAT IS TONI KUKOCS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question51
	.string "WHERE WAS PATRICK EWING BORN ?",0
	.even
question52
	.string "WHAT IS VLADE DIVACS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question53
	.string "WHAT IS DIKEMBE MUTOMBOS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question54
	.string "WHAT IS DETLEF SCHREMPFS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question55
	.string "WHAT IS DINO RADJAS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question56
	.string "WHAT IS SARUNAS MARCIULIONIS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question57
	.string "WHAT IS ARVYDAS SABONIS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question58
	.string "WHAT IS LUC LONGLEYS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question59
	.string "WHAT IS BILL WENNINGTONS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question60
	.string "WHAT IS GEORGE ZIDEKS' NATIVE",1
	.string "COUNTRY ?",0
	.even
question61
	.string "WHAT IS BRYANT REEVES' NICKNAME ?",0
	.even
;question62
;	.string "WHAT ORLANDO MAGIC PLAYER ALSO HAS",1
;	.string "RELEASED A CD WITH RAP MUSIC ?",0
;	.even
question63
	.string "WHAT NBA PLAYER WAS THE NUMBER TWO",1
	.string "OVERALL PICK IN THE 1992 NBA DRAFT ?",0
	.even
question64
	.string "HOW MANY NBA CHAMPIONSHIP TITLES",1
	.string "HAVE THE BOSTON CELTICS WON ?",0
	.even
question65
	.string "WHAT JERSEY NUMBER DOES ANFERNEE",1
	.string "HARDAWAY WEAR ?",0
	.even
question66
	.string "WHAT NBA PLAYER ALSO WON THE",1
	.string "HEISMAN TROPHY ?",0
	.even
question67
	.string "WHICH ONE OF THE BULLETS' PLAYERS",1
	.string "WAS ALSO A MEMBER OF THE 'FAB FIVE'",1
	.string "TEAM AT THE UNIVERSITY OF MICHIGAN ?",0
	.even
question68
	.string "WHICH NBA PLAYER WAS SELECTED IN THE",1
	.string "FIRST ROUND OF THE NBA DRAFT BY THE",1
	.string "NEW JERSEY NETS IN 1995 ?",0
	.even
question69
	.string "ON WHICH NBA TEAM DID DANNY MANNING",1
	.string "BEGIN HIS CAREER ?",0
	.even
question70
	.string "WHICH OF THE FOLLOWING NBA PLAYERS",1
	.string "WON THE NBA SLAM DUNK CONTEST AS A",1
	.string "MEMBER OF THE BOSTON CELTICS ?",0
	.even
;question71
;	.string "WHAT JERSEY NUMBER DID MICHAEL JORDAN ",1
;	.string "WEAR DURING THE FIRST GAME BACK IN THE",1
;	.string "NBA AFTER ENDING HIS RETIREMENT ?",0
;	.even
question72
	.string "WHO IS THE ALL-TIME LEADING SCORER IN",1
	.string "THE HISTORY OF THE INDIANA PACERS ?",0
	.even
question73
	.string "WHAT JERSEY NUMBER IS WORN BY",1
	.string "SCOTTIE PIPPEN ?",0
	.even
question74
	.string "WHICH OF THE FOLLOWING NBA PLAYERS",1
	.string "IS AMBIDEXTROUS ?",0
	.even
question75
	.string "WHICH PLAYER IS THE NBA ALL-TIME",1
	.string "LEADER IN ASSISTS ?",0
	.even
question76
	.string "WHICH PLAYER WAS SELECTED IN THE",1
	.string "FIRST ROUND OF THE 1995 NBA DRAFT BY",1
	.string "THE CHICAGO BULLS ?",0
	.even
question77
	.string "WHAT NBA TEAM DID KEVIN JOHNSON PLAY",1
	.string "FOR DURING HIS ROOKIE SEASON ?",0
	.even
question78
	.string "WHICH OF THE NBA PLAYERS WAS A MEMBER",1
	.string "OF THE 1988 NCAA MEN'S BASKETBALL",1
	.string "CHAMPIONSHIP TEAM ?",0
	.even
question79
	.string "WHAT NBA PLAYER WAS PLAYING HIGH",1
	.string "SCHOOL BASKETBALL DURING THE 1994-95",1
	.string "BASKETBALL SEASON ?",0
	.even
question80
	.string "WHAT PORTLAND TRAIL BLAZERS PLAYER",1
	.string "WEARS A HEADBAND DURING GAMES ?",0
	.even
question81
	.string "WHAT CITY IS HOME TO THE NBA TEAM",1
	.string "WITH THE NAME 'HORNETS' ?",0
	.even
question82
	.string "WHAT TEAM WON TWO NBA TITLES WITH",1
	.string "JOE DUMARS AS A STARTING GUARD ?",0
	.even
question83
	.string "WHAT CITY IS HOME TO THE NBA TEAM",1
	.string "WITH THE NAME 'MAVERICKS' ?",0
	.even
;question84
;	.string "WITH WHICH SELECTION IN THE FIRST ROUND",1
;	.string "DID THE CHICAGO BULLS DRAFT",1
;	.string "MICHAEL JORDAN IN 1984 ?",0
;	.even
question85
	.string "WHAT CITY IS HOME TO THE NBA TEAM",1
	.string "WITH THE NAME 'JAZZ' ?",0
	.even
question86
	.string "WHAT NBA PLAYER WAS ROOKIE OF THE",1
	.string "YEAR FOR THE 1981-82 NBA SEASON ?",0
	.even
question87
	.string "WHAT NBA TEAM WON A RECORD EIGHT",1
	.string "STRAIGHT NBA CHAMPIONSHIPS ?",0
	.even
question88
	.string "WHAT TEAM WON THE NBA CHAMPIONSHIP",1
	.string "TITLE FOR THE 1990-91 SEASON ?",0
	.even
question89
	.string "WHO WAS THE NBA ROOKIE OF THE YEAR",1
	.string "FOR THE 1993-94 SEASON ?",0
	.even
question90
	.string "WHO WAS THE NBA ROOKIE OF THE YEAR",1
	.string "FOR THE 1989-90 SEASON ?",0
	.even
;question91
;	.string "WHO WAS THE NBA ROOKIE OF THE YEAR",1
;	.string "FOR THE 1992-93 SEASON ?",0
;	.even
question92
	.string "WHAT CITY IS HOME TO THE NBA TEAM",1
	.string "WITH THE NAME 'BUCKS' ?",0
	.even
question93
	.string "WHO WAS THE NUMBER ONE OVERALL DRAFT",1
	.string "PICK IN THE 1985 NBA DRAFT ?",0
	.even
question94
	.string "WHO WAS THE NUMBER ONE OVERALL PICK",1
	.string "IN THE 1987 NBA DRAFT ?",0
	.even
question95
	.string "WHO WAS THE NUMBER ONE OVERALL PICK",1
	.string "IN THE 1988 NBA DRAFT ?",0
	.even
question96
	.string "WHO WAS THE NUMBER ONE OVERALL PICK",1
	.string "IN THE 1990 NBA DRAFT ?",0
	.even
question97
	.string "WHO WAS THE NUMBER ONE OVERALL PICK",1
	.string "IN THE 1991 NBA DRAFT ?",0
	.even
question98
	.string "WHO WAS THE NUMBER ONE OVERALL PICK",1
	.string "IN THE 1994 NBA DRAFT ?",0
	.even
question99
	.string "WHAT CITY IS HOME TO THE NBA TEAM",1
	.string "WITH THE NAME 'RAPTORS' ?",0
	.even
question100
	.string "WHAT PLAYER WON THE NBA'S 6TH MAN",1
	.string "AWARD FOR THE 1990-91 SEASON ?",0
	.even
question101
	.string "WHAT PLAYER WON THE NBA'S 6TH MAN",1
	.string "AWARD FOR THE 1992-93 SEASON ?",0
	.even
question102
	.string "WHAT PLAYER WON THE NBA'S 6TH MAN",1
	.string "AWARD FOR THE 1993-94 SEASON ?",0
	.even
question103
	.string "WHAT PLAYER WON THE NBA'S 6TH MAN",1
	.string "AWARD FOR THE 1994-95 SEASON ?",0
	.even
question104
	.string "WHAT PLAYER WAS THE NBA'S DEFENSIVE",1
	.string "PLAYER OF THE YEAR FOR THE 1987-88",1
	.string "SEASON ?",0
	.even
question105
	.string "WHAT PLAYER WAS THE NBA'S DEFENSIVE",1
	.string "PLAYER OF THE YEAR FOR THE 1989-90",1
	.string "SEASON ?",0
	.even
question106
	.string "WHAT PLAYER WAS THE NBA'S DEFENSIVE",1
	.string "PLAYER OF THE YEAR FOR THE 1990-91",1
	.string "SEASON ?",0
	.even
;question107
;	.string "WHAT PLAYER WAS THE NBA'S DEFENSIVE",1
;	.string "PLAYER OF THE YEAR FOR THE 1991-92",1
;	.string "SEASON ?",0
;	.even
question108
	.string "WHAT PLAYER WAS THE NBA'S DEFENSIVE",1
	.string "PLAYER OF THE YEAR FOR THE 1993-94",1
	.string "SEASON ?",0
	.even
question109
	.string "WHAT PLAYER WAS THE NBA'S DEFENSIVE",1
	.string "PLAYER OF THE YEAR FOR THE 1994-95",1
	.string "SEASON ?",0
	.even
question110
	.string "WHAT PLAYER WON THE NBA'S MOST",1
	.string "IMPROVED PLAYER OF THE YEAR AWARD",1
	.string "FOR THE 1994-95 SEASON ?",0
	.even
question111
	.string "WHAT PLAYER WON THE NBAS' MOST",1
	.string "IMPROVED PLAYER OF THE YEAR AWARD",1
	.string "FOR THE 1993-94 SEASON ?",0
	.even
question112
	.string "WHAT PLAYER WON THE NBAS' MOST",1
	.string "IMPROVED PLAYER OF THE YEAR AWARD",1
	.string "FOR THE 1989-90 SEASON ?",0
	.even
question113
	.string "WHAT NBA PLAYER LEAD THE LEAGUE IN",1
	.string "ASSISTS DURING THE 1989-90 SEASON ?",0
	.even
question114
	.string "WHAT NBA PLAYER LEAD THE LEAGUE IN",1
	.string "ASSISTS DURING THE 1991-92 SEASON ?",0
	.even
;question115
;	.string "WHAT NBA PLAYER LEAD THE LEAGUE IN",1
;	.string "STEALS DURING THE 1989-90 SEASON ?",0
;	.even
question116
	.string "WHAT NBA PLAYER LEAD THE LEAGUE IN",1
	.string "ASSISTS DURING THE 1994-95 SEASON ?",0
	.even
question117
	.string "WHAT NBA PLAYER LEAD THE LEAGUE IN",1
	.string "BLOCKED SHOTS DURING THE 1989-90",1
	.string "SEASON ?",0
	.even
question118
	.string "WHAT NBA PLAYER LEAD THE LEAGUE IN",1
	.string "BLOCKED SHOTS DURING THE 1993-94",1
	.string "SEASON ?",0
	.even
;question119
;	.string "WHAT NBA PLAYER LEAD THE LEAGUE IN",1
;	.string "REBOUNDING DURING THE 1987 SEASON ?",0
;	.even
question120
	.string "WHAT CITY HOSTED THE 1983 NBA",1
	.string "ALL-STAR GAME ?",0
	.even
question121
	.string "WHAT WAS THE HOST CITY FOR THE 1988",1
	.string "NBA ALL-STAR GAME ?",0
	.even
question122
	.string "WHO WAS NAMED MVP OF THE 1994 NBA",1
	.string "ALL-STAR GAME IN MINNEAPOLIS ?",0
	.even
question123
	.string "WHAT CITY WAS HOME TO THE JAZZ",1
	.string "BEFORE UTAH ?",0
	.even
question124
	.string "WHAT WAS THE FIRST SEASON THE",1
	.string "ORLANDO MAGIC COMPETED IN THE NBA ?",0
	.even
question125
	.string "WHEN THE WARRIORS FRANCHISE ENTERED",1
	.string "THE NBA, WHAT CITY WAS THEIR HOME ?",0
	.even
question126
	.string "WHEN THE LAKERS FRANCHISE ENTERED",1
	.string "THE NBA, WHAT CITY WAS THEIR HOME ?",0
	.even
question127
	.string "WHEN THE PISTONS FRANCHISE ENTERED",1
	.string "THE NBA, WHAT CITY WAS THEIR HOME ?",0
	.even
question128
	.string "WHEN THE CLIPPERS FRANCHISE ENTERED",1
	.string "THE NBA, WHAT CITY WAS THEIR HOME ?",0
	.even
question129
	.string "WHAT PLAYER LED THE NBA IN PERSONAL",1
	.string "FOULS DURING THE 1994-95 SEASON ?",0
	.even
question130
	.string "WHAT PLAYER LED THE ATLANTA HAWKS IN",1
	.string "SCORING FOR THE 1994-95 SEASON ?",0
	.even
question131
	.string "WHAT PLAYER LEAD THE BOSTON CELTICS IN",1
	.string "REBOUNDS FOR THE 1994-95 SEASON ?",0
	.even
question132
	.string "WHO IS THE SHORTEST PLAYER EVER TO WIN",1
	.string "AN NBA SLAM-DUNK TITLE ?",0
	.even
question133
	.string "WHAT PLAYER LED THE CHARLOTTE HORNETS",1
	.string "IN SCORING FOR THE 1994-95 NBA SEASON ?",0
	.even
question134
	.string "WHAT TEAM DID HORACE GRANT PLAY FOR",1
	.string "DURING THE 1993-94 NBA SEASON ?",0
	.even
question135
	.string "WHAT TEAM DID HORACE GRANT PLAY FOR",1
	.string "DURING THE 1994-95 NBA SEASON ?",0
	.even
question136
	.string "WHAT TEAM DID DINO RADJA PLAY FOR",1
	.string "DURING THE 1993-94 NBA SEASON ?",0
	.even
question137
	.string "WHAT TEAM DID B.J. TYLER PLAY FOR",1
	.string "DURING THE 1994-95 NBA SEASON ?",0
	.even
question138
	.string "WHAT TEAM DID HAROLD MINER PLAY FOR",1
	.string "DURING THE 1992-1993 NBA SEASON ?",0
	.even
question139
	.string "WHAT TEAM DID MARK MACON PLAY FOR",1
	.string "DURING THE 1992-1993 NBA SEASON ?",0
	.even
question140
	.string "WHAT NBA TEAM SELECTED BYRON HOUSTON",1
	.string "IN THE 1992 NBA DRAFT ?",0
	.even
;question141
;	.string "WHO WAS NAMED NBA COACH OF THE YEAR",1
;	.string "FOR THE 1993-1994 NBA SEASON ?",0
;	.even
;question142
;	.string "WHAT CURRENT NBA COACH WAS NAMED",1
;	.string "COACH OF THE YEAR FOR THE 1970-1971",1
;	.string "NBA SEASON ?",0
;	.even
;question143
;	.string "WHAT TEAM DID DICK MOTTA COACH WHEN",1
;	.string "HE WAS NAMED COACH OF THE YEAR ?",0
;	.even
;question144
;	.string "WHAT POSITION DOES CHARLES BARKLEY",1
;	.string "PLAY ?",0
;	.even
;question145
;	.string "WHAT POSITION DOES MICHAEL JORDAN",1
;	.string "PLAY ?",0
;	.even
question146
	.string "WHAT POSITION DOES PATRICK EWING",1
	.string "PLAY ?",0
	.even
question147
	.string "WHAT POSITION DOES DAVID ROBINSON",1
	.string "PLAY ?",0
	.even
;question148
;	.string "WHAT YEAR WAS MICHAEL JORDAN BORN ?",1
;	.even
;
;Add more birthday questions...
;
question149
	.string "FOR WHICH BRANCH OF THE UNITED STATES",1
	.string "ARMED FORCES DID DAVID ROBINSON SERVE ?",0
	.even
question150
	.string "WHAT POSITION DOES LATRELL SPREWELL",1
	.string "PLAY ?",0
	.even
question151
	.string "WHAT POSITION DOES ANFERNEE HARDAWAY",1
	.string "PLAY ?",0
	.even
question152
	.string "WHAT POSITION DOES MATT GEIGER",1
	.string "PLAY ?",0
	.even
question153
	.string "WHAT TEAM DID CLYDE DREXLER PLAY FOR",1
	.string "DURING THE 1992-93 NBA SEASON ?",0
	.even
question154
	.string "WHAT TEAM DID KEITH JENNINGS PLAY FOR",1
	.string "DURING THE 1994-95 NBA SEASON ?",0
	.even
question155
	.string "WHAT TEAM DID LUCIOUS HARRIS PLAY FOR",1
	.string "DURING THE 1994-95 NBA SEASON ?",0
	.even
question156
	.string "WHICH OF THE FOLLOWING TEAMS WAS AN",1
	.string "EXPANSION TEAM DURING THE 1990-91",1
	.string "NBA SEASON ?",0
	.even
question157
	.string "WHAT IS THE NAME OF THE NBA",1
	.string "FRANCHISE IN TORONTO ?",0
	.even
question158
	.string "WHAT WAS THE FIRST COUNTRY OTHER THAN",1
	.string "THE UNITED STATES TO HAVE AN NBA",1
	.string "FRANCHISE ?",0
	.even
question159
	.string "WHAT IS THE NAME OF THE NBA",1
	.string "FRANCHISE IN PORTLAND ?",0
	.even
question160
	.string "WHAT IS THE NAME OF THE NBA",1
	.string "FRANCHISE IN NEW JERSEY ?",0
	.even
question161
	.string "WHAT POSITION DOES DEREK STRONG",1
	.string "PLAY ?",0
	.even
question162
	.string "WHAT POSITION DOES CHARLES SMITH",1
	.string "PLAY ?",0
	.even
question163
	.string "WHAT POSITION DOES MALIK SEALY",1
	.string "PLAY ?",0
	.even
question164
	.string "WHAT POSITION DOES TIM PERRY",1
	.string "PLAY ?",0
	.even
question165
	.string "WHAT POSITION DOES ALONZO MOURNING",1
	.string "PLAY ?",0
	.even
question166
	.string "WHAT POSITION DOES STEVE KERR",1
	.string "PLAY ?",0
	.even
question167
	.string "WHAT POSITION DOES JAMAL MASHBURN",1
	.string "PLAY ?",0
	.even
question168
	.string "WHAT POSITION DOES SAM MITCHELL",1
	.string "PLAY ?",0
	.even
question169
	.string "WHAT POSITION DOES JIM MCILVAINE",1
	.string "PLAY ?",0
	.even
question170
	.string "WHAT IS THE NAME OF THE NBA",1
	.string "FRANCHISE IN MILWAUKEE ?",0
	.even
question171
	.string "WHAT IS THE NAME OF THE NBA",1
	.string "FRANCHISE IN MIAMI ?",0
	.even
question172
	.string "WHAT IS THE NAME OF THE NBA",1
	.string "FRANCHISE IN ORLANDO ?",0
	.even
question173
	.string "WHO WAS THE FIRST PICK OVERALL IN",1
	.string "THE 1994 NBA DRAFT ?",0
	.even
question174
	.string "WHAT NBA PLAYER HAS THE NICKNAME",1
	.string "THE 'POLISH RIFLE' ?",0
	.even
question175
	.string "WHAT NBA PLAYER HAS THE NICKNAME",1
	.string "'THE RIFLEMAN' ?",0
	.even
question176
	.string "WHAT NBA TEAM DID ANTHONY PEELER PLAY",1
	.string "FOR DURING THE 1994-95 SEASON ?",0
	.even
question177
	.string "WHAT IS THE NAME OF THE NBA",1
	.string "FRANCHISE IN HOUSTON ?",0
	.even
question178
	.string "WHAT IS THE NAME OF THE NBA",1
	.string "FRANCHISE IN SAN ANTONIO ?",0
	.even
question179
	.string "WHAT YEAR DID THE CHICAGO BULLS JOIN",1
	.string "THE NBA ?",0
	.even
question180
	.string "WHAT NBA TEAM DID SEAN ELLIOTT PLAY",1
	.string "FOR IN THE 1994-95 SEASON ?",0
	.even
question181
	.string "WHAT NBA TEAM DID ERIC LECKNER PLAY",1
	.string "FOR DURING THE 1994-95 NBA SEASON ?  ",0
	.even
question182
	.string "WHAT TEAM DID NEGELE KNIGHT PLAY FOR",1
	.string "DURING THE 1990-1991 NBA SEASON ?",0
	.even
;question183
;	.string "WHAT NBA PLAYER WAS IN THE CHICAGO",1
;	.string "WHITESOX MINOR LEAGUE BASEBALL SYSTEM",1
;	.string "IN 1994 ?",0
;	.even
question184
	.string "WHAT NBA PLAYER'S FATHER PLAYED IN",1
	.string "THE NATIONAL FOOTBALL LEAGUE ?",0
	.even
question185
	.string "WHAT TEAM DID JOHN CROTTY PLAY FOR",1
	.string "DURING THE 1994-95 NBA SEASON ?",0
	.even
question186
	.string "WHAT POSITION DOES JOHN CROTTY",1
	.string "PLAY ?",0
	.even
question187
	.string "WHAT POSITION DOES CHRISTIAN LAETTNER",1
	.string "PLAY ?",0
	.even
question188
	.string "WHAT POSITION DOES ELLIOT PERRY",1
	.string "PLAY ?",0
	.even
question189
	.string "WHAT POSITION DOES STACEY KING",1
	.string "PLAY ?",0
	.even
question190
	.string "WHAT POSITION DOES CHRIS DUDLEY",1
	.string "PLAY ?",0
	.even
question191
	.string "WHAT POSITION DOES CEDRIC CEBALLOS",1
	.string "PLAY ?",0
	.even
question192
	.string "WHAT POSITION DOES B.J. TYLER",1
	.string "PLAY ?",0
	.even
question193
	.string "WHAT POSITION DOES JOHN STARKS",1
	.string "PLAY ?",0
	.even
question194
	.string "WHAT POSITION DOES BRIAN SHAW",1
	.string "PLAY ?",0
	.even
question195
	.string "WHAT POSITION DOES HERSEY HAWKINS",1
	.string "PLAY ?",0
	.even
question196
	.string "WHAT POSITION DOES DANNY FERRY",1
	.string "PLAY ?",0
	.even
question197
	.string "WHAT POSITION DOES WINSTON GARLAND",1
	.string "PLAY ?",0
	.even
question198
	.string "WHAT POSITION DOES HARVEY GRANT",1
	.string "PLAY ?",0
	.even
question199
	.string "WHAT POSITION DOES ROBERT PACK",1
	.string "PLAY ?",0
	.even
question200
	.string "WHAT POSITION DOES RYAN LORTHRIDGE",1
	.string "PLAY ?",0
	.even



answer_tbl
	.long	answr1		;0
	.long	answr1		;1
	.long	answr2
	.long	answr3
	.long	answr4
	.long	answr5
	.long	answr6
	.long	answr7
	.long	answr8
	.long	answr9
	.long	answr10
	.long	answr11
	.long	answr12
	.long	answr13
	.long	answr14
	.long	answr15
	.long	answr16
	.long	answr17
	.long	answr18
	.long	answr19
	.long	answr20
	.long	answr21
	.long	answr22
	.long	answr23
	.long	answr24
	.long	answr25
	.long	answr26
	.long	answr27
	.long	answr28
	.long	answr29
	.long	answr30
	.long	answr31
	.long	answr32
	.long	answr33
	.long	answr34
	.long	answr35
	.long	answr36
	.long	answr37
	.long	answr38
	.long	answr39
	.long	answr40
	.long	answr41
	.long	answr42
	.long	answr43
	.long	answr44
	.long	answr45
	.long	answr46
	.long	answr47
	.long	answr48
	.long	answr49
	.long	answr50
	.long	answr51
	.long	answr52
	.long	answr53
	.long	answr54
	.long	answr55
	.long	answr56
	.long	answr57
	.long	answr58
	.long	answr59
	.long	answr60
	.long	answr61
	.long	answr62
	.long	answr63
	.long	answr64
	.long	answr65
	.long	answr66
	.long	answr67
	.long	answr68
	.long	answr69
	.long	answr70
	.long	answr71
	.long	answr72
	.long	answr73
	.long	answr74
	.long	answr75
	.long	answr76
	.long	answr77
	.long	answr78
	.long	answr79
	.long	answr80
	.long	answr81
	.long	answr82
	.long	answr83
	.long	answr84
	.long	answr85
	.long	answr86
	.long	answr87
	.long	answr88
	.long	answr89
	.long	answr90
	.long	answr91
	.long	answr92
	.long	answr93
	.long	answr94
	.long	answr95
	.long	answr96
	.long	answr97
	.long	answr98
	.long	answr99
	.long	answr100
	.long	answr101
	.long	answr102
	.long	answr103
	.long	answr104
	.long	answr105
	.long	answr106
	.long	answr107
	.long	answr108
	.long	answr109
	.long	answr110
	.long	answr111
	.long	answr112
	.long	answr113
	.long	answr114
	.long	answr115
	.long	answr116
	.long	answr117
	.long	answr118
	.long	answr119
	.long	answr120
	.long	answr121
	.long	answr122
	.long	answr123
	.long	answr124
	.long	answr125
	.long	answr126
	.long	answr127
	.long	answr128
	.long	answr129
	.long	answr130
	.long	answr131
	.long	answr132
	.long	answr133
	.long	answr134
	.long	answr135
	.long	answr136
	.long	answr137
	.long	answr138
	.long	answr139
	.long	answr140
	.long	answr141
	.long	answr142
	.long	answr143
	.long	answr144
	.long	answr145
	.long	answr146
	.long	answr147
	.long	answr148
	.long	answr149
	.long	answr150
	.long	answr151
	.long	answr152
	.long	answr153
	.long	answr154
	.long	answr155
	.long	answr156
	.long	answr157
	.long	answr158
	.long	answr159
	.long	answr160
	.long	answr161
	.long	answr162
	.long	answr163
	.long	answr164
	.long	answr165
	.long	answr166
	.long	answr167
	.long	answr168
	.long	answr169
	.long	answr170
	.long	answr171
	.long	answr172
	.long	answr173
	.long	answr174
	.long	answr175
	.long	answr176
	.long	answr177
	.long	answr178
	.long	answr179
	.long	answr180
	.long	answr181
	.long	answr182
	.long	answr183
	.long	answr184
	.long	answr185
	.long	answr186
	.long	answr187
	.long	answr188
	.long	answr189
	.long	answr190
	.long	answr191
	.long	answr192
	.long	answr193
	.long	answr194
	.long	answr195
	.long	answr196
	.long	answr197
	.long	answr198
	.long	answr199
	.long	answr200
	.long	answr201
	.long	answr202
	.long	answr203
	.long	answr204
	.long	answr205
	.long	answr206
	.long	answr207
	.long	answr208
	.long	answr209
	.long	answr210
	.long	answr211
	.long	answr212
	.long	answr213
	.long	answr214
	.long	answr215
	.long	answr216
	.long	answr217
	.long	answr218
	.long	answr219
	.long	answr220
	.long	answr221
	.long	answr222
	.long	answr223
	.long	answr224
	.long	answr225
	.long	answr226
	.long	answr227
	.long	answr228
	.long	answr229
	.long	answr230
	.long	answr231
	.long	answr232
	.long	answr233
	.long	answr234
	.long	answr235
	.long	answr236
	.long	answr237
	.long	answr238
	.long	answr239
	.long	answr240
	.long	answr241
	.long	answr242
	.long	answr243
	.long	answr244
	.long	answr245
	.long	answr246
	.long	answr247
	.long	answr248
	.long	answr249
	.long	answr250
	.long	answr251
	.long	answr252
	.long	answr253
	.long	answr254
	.long	answr255
	.long	answr256
	.long	answr257
	.long	answr258
	.long	answr259
	.long	answr260
	.long	answr261
	.long	answr262
	.long	answr263
	.long	answr264
	.long	answr265
	.long	answr266
	.long	answr267
	.long	answr268
	.long	answr269
	.long	answr270
	.long	answr271
	.long	answr272
	.long	answr273
	.long	answr274
	.long	answr275
	.long	answr276
	.long	answr277
	.long	answr278
	.long	answr279
	.long	answr280
	.long	answr281
	.long	answr282
	.long	answr283
	.long	answr284
	.long	answr285
	.long	answr286
	.long	answr287
	.long	answr288
	.long	answr289
	.long	answr290
	.long	answr291
	.long	answr292
	.long	answr293
	.long	answr294
	.long	answr295
	.long	answr296
	.long	answr297
	.long	answr298
	.long	answr299
	.long	answr300
	.long	answr301
	.long	answr302
	.long	answr303
	.long	answr304
	.long	answr305
	.long	answr306
	.long	answr307
	.long	answr308
	.long	answr309
	.long	answr310
	.long	answr311
	.long	answr312
	.long	answr313
	.long	answr314
	.long	answr315
	.long	answr316
	.long	answr317
	.long	answr318
	.long	answr319
	.long	answr320
	.long	answr321
	.long	answr322
	.long	answr323
	.long	answr324
	.long	answr325
	.long	answr326
	.long	answr327
	.long	answr328
	.long	answr329
	.long	answr330
	.long	answr331
	.long	answr332
	.long	answr333
	.long	answr334
	.long	answr335
	.long	answr336
	.long	answr337
	.long	answr338
	.long	answr339
	.long	answr340
	.long	answr341
	.long	answr341
answer_tbl_end


answr1
	.string	"UNIVERSITY OF NORTH CAROLINA",0
answr2
	.string	"UNIVERSITY OF MICHIGAN",0
answr3
	.string	"UNIVERSITY OF MIAMI",0
answr4
	.string	"CENTRAL ARKANSAS UNIVERSITY",0
answr5
	.string	"DEPAUL UNIVERSITY",0
answr6
	.string	"INDIANA UNIVERSITY",0
answr7
	.string	"UCLA",0
answr8
	.string	"GEORGETOWN UNIVERSITY",0
answr9
	.string	"UNIVERSITY OF VILNIUS",0
answr10
	.string	"SYRACUSE UNIVERSITY",0
answr11
	.string	"FLORIDA STATE UNIVERSITY",0
answr12
	.string	"HARVEY GRANT",0
answr13
	.string	"RICKY PIERCE",0
answr14
	.string	"SCOTTIE PIPPEN",0
answr15
	.string	"RICK SMITS",0
answr16
	.string	"B.J. TYLER",0
answr17
     	.string	"GRANT HILL",0
answr18
	.string	"DAVID ROBINSON",0
answr19
	.string	"TONI KUKOC",0
answr20
	.string	"HORACE GRANT",0
answr21
	.string	"PATRICK EWING",0
answr22
	.string	"CLYDE DREXLER",0
answr23
	.string	"HAKEEM OLAJUWON",0
answr24
	.string	"TONI KUKOC",0
answr25
	.string	"ED PINCKNEY",0
answr26
	.string	"JOHN STOCKTON",0
answr27
	.string	"LATRELL SPREWELL",0
answr28
     	.string	"TIM HARDAWAY",0
answr29
	.string	"KARL MALONE",0
answr30
	.string	"B.J. ARMSTRONG",0
answr31
	.string	"KENNY SMITH",0
answr32
	.string	"DANNY FERRY",0
answr33
	.string	"DEREK HARPER",0
answr34
	.string	"HORACE GRANT",0
answr35
	.string	"RICK FOX",0
answr36
	.string	"WILL PERDUE",0
answr37
	.string	"HAROLD MINER",0
answr38
	.string	"ALONZO MOURNING",0
answr39
	.string	"CARL HERRERA",0
answr40
	.string	"CHRISTIAN LAETTNER",0
answr41
	.string	"JAMAL MASHBURN",0
answr42
	.string	"STEVE KERR",0
answr43
	.string	"JOE SMITH",0
answr44
	.string	"ANTONIO MCDYESS",0
answr45
	.string	"JERRY STACKHOUSE",0
answr46
	.string	"RASHEED WALLACE",0
answr47
	.string	"KEVIN GARNETT",0
answr48
	.string	"DENNIS SCOTT",0
answr49
	.string	"ANFERNEE HARDAWAY",0
answr50
	.string	"CHRIS WEBBER",0
answr51
	.string	"CHARLES SMITH",0
answr52
	.string	"CHARLIE WARD",0
answr53
	.string	"MONTY WILLIAMS",0
answr54
	.string	"JALEN ROSE",0
answr55
	.string	"CALBERT CHEANEY",0
answr56
	.string	"JUWAN HOWARD",0
answr57
	.string	"BRENT PRICE",0
answr58
	.string	"ARMON GILLIAM",0
answr59
	.string	"YINKA DARE",0
answr60
	.string	"DAN MAJERLE",0
answr61
	.string	"ED O'BANNON",0
answr62
	.string	"REGGIE MILLER",0
answr63
	.string	"JASON CAFFEY",0
answr64
	.string	"DICKEY SIMPKINS",0
answr65
	.string	"SCOTT WILLIAMS ",0
answr66
	.string	"LIONEL SIMMONS",0
answr67
	.string	"BRIAN SHAW",0
answr68
	.string	"OLIVER MILLER",0
answr69
	.string	"GLEN ROBINSON",0
answr70
	.string	"DENNIS RODMAN",0
answr71
	.string	"CHUCK PERSON",0
answr72
	.string	"KEVIN WILLIS",0
answr73
	.string	"DIKEMBE MUTOMBO",0
answr74
	.string	"SHAWN KEMP",0
answr75
	.string	"SPUD WEBB",0
answr76
	.string	"ANTHONY MASON",0
answr77
	.string	"CLIFFORD ROBINSON",0
answr78
	.string	"VIN BAKER",0
answr79
	.string	"VERN FLEMING",0
answr80
	.string	"LINDSEY HUNTER",0
answr81
	.string	"BLUE EDWARDS",0
answr82
	.string	"TONY DUMAS",0
answr83
	.string	"GLEN RICE",0
answr84
	.string	"NICK VAN EXEL",0
answr85
	.string	"TERRY CUMMINGS",0
answr86
	.string	"JOHN STARKS",0
answr87
	.string	"SEAN ROOKS",0
answr88
	.string	"BILL WENNINGTON",0
answr89
	.string	"XAVIER MCDANIEL",0
answr90
	.string	"AVERY JOHNSON",0
answr91
	.string	"MARK MACON",0
answr92
	.string	"TOM HAMMONDS",0
answr93
	.string	"LUC LONGLEY",0
answr94
	.string	"OLDEN POLYNICE",0
answr95
	.string	"STANLEY ROBERTS",0
answr96
	.string	"KENNY ANDERSON",0
answr97
	.string	"ROD STRICKLAND",0
answr98
	.string	"DEE BROWN",0
answr99
	.string	"DANA BARROS",0
answr100
	.string	"DINO RADJA",0
answr101
	.string	"BYRON SCOTT",0
answr102
	.string	"SARUNAS MARCIULIONIS",0
answr103
	.string	"CHRIS MULLIN",0
answr104
	.string	"RODNEY RODGERS",0
answr105
	.string	"ISAIAH RIDER",0
answr106
	.string	"PERVIS ELLISON",0
answr107
	.string	"DANNY MANNING",0
answr108
	.string	"TYUS EDNEY",0
answr109
	.string	"BUCK WILLIAMS",0
answr110
	.string	"CHRIS DUDLEY",0
answr111
	.string	"LARRY JOHNSON",0
answr112
	.string	"GLENN ROBINSON",0
answr113
	.string	"DERRICK COLEMAN",0
answr114
	.string	"MITCH RICHMOND",0
answr115
	.string	"RIK SMITS",0
answr116
	.string	"BRAD DOUGHERTY",0
answr117
	.string	"RONY SEIKALY",0
answr118
	.string	"MARK JACKSON",0
answr119
	.string	"A.C. GREEN",0
answr120
	.string	"DONYELL MARSHALL",0
answr121
	.string	"TOM GUGLIOTTA",0
answr122
	.string	"JOE KLEIN",0
answr123
	.string	"SHAWN BRADLEY",0
answr124
	.string	"DETLEF SCHREMPF",0
answr125
	.string	"KENDALL GILL",0
answr126
	.string	"DELL CURRY",0
answr127
	.string	"VERNON MAXWELL",0
answr128
	.string	"JAYSON WILLIAMS",0
answr129
	.string	"STEVE SMITH",0
answr130
	.string	"SEAN ELLIOTT",0
answr131
	.string	"GARY CANTON",0
answr132
	.string	"DON MACLEAN",0
answr133
      	.string	"MAHMOUD ABDUL-RAUF",0
answr134
	.string	"GARY PAYTON ",0
answr135
	.string	"KEVIN JOHNSON",0
answr136
	.string	"MARK PRICE",0
answr137
	.string	"NATE MCMILLAN",0
answr138
	.string	"POOU RICHARDSON",0
answr139
	.string	"MICHAEL CAGE",0
answr140
      	.string	"CHARLES OAKLEY",0
answr141
	.string	"TODD DAY",0
answr142
      	.string	"EDDIE JONES",0
answr143
	.string	"MOOKIE BLAYLOCK",0
answr144
	.string	"GRANT LONG",0
answr145
	.string	"STACEY AUGMON",0
answr146
	.string	"ERIC MONTROS",0
answr147
      	.string	"ISAIAH RIDES",0
answr148
	.string	"TYRONE BOUGES",0
answr149
      	.string	"HERSEY HAWKINS",0
answr150
	.string	"SCOTT BURRELL",0
answr151
	.string	"LENNY WILKENS",0
answr152
	.string	"PAT RILEY",0
answr153
	.string	"DON NELSON",0
answr154
	.string	"PHIL JACKSON",0
answr155
      	.string	"COTTON FITZSIMMONS",0
answr156
	.string	"DICK MOTTA",0
answr157
	.string	"MIKE DUNLEAVY",0
answr158
	.string	"BOB HILL",0
answr159
	.string	"ERIC PIATOWSKI",0
answr160
	.string	"ERIC MONTROSS",0
answr161
	.string	"ADAM KEEFE",0
answr162
	.string	"BYRON HOUSTON",0
answr163
	.string	"BIG COUNTRY",0
answr164
	.string	"BIG DOG",0
answr165
	.string	"BIG HURT",0
answr166
	.string	"BIG UNIT",0
answr167
	.string	"1",0
answr168
	.string	"3",0
answr169
	.string	"10",0
answr170
	.string	"11",0
answr171
	.string	"13",0
answr172
	.string	"15",0
answr173
	.string	"16",0
answr174
	.string	"17",0
answr175
	.string	"19",0
answr176
	.string	"21",0
answr177
	.string	"23",0
answr178
	.string	"32",0
answr179
	.string	"33",0
answr180
	.string	"45",0
answr181
	.string	"54",0
answr182
	.string	"90",0
answr183
	.string	"FIRST",0
answr184
	.string	"SECOND",0
answr185
	.string	"THIRD",0
answr186
	.string	"FOURTH",0
answr187
	.string	"NEW ZEALAND",0
answr188
	.string	"CROATIA",0
answr189
	.string	"CANADA",0
answr190
	.string	"HOLLAND",0
answr191
	.string	"NIGERIA",0
answr192
	.string	"SUDAN",0
answr193
	.string	"ZAIRE",0
answr194
	.string	"ALGERIA",0
answr195
	.string	"RUSSIA",0
answr196
	.string	"ROMANIA",0
answr197
	.string	"YUGOSLAVIA",0
answr198
	.string	"SPAIN",0
answr199
	.string	"NEW YORK",0
answr200
	.string	"ST. THOMAS",0
answr201
     	.string	"JAMAICA",0
answr202
	.string	"GERMANY",0
answr203
	.string	"MEXICO",0
answr204
	.string	"ST. CROIX",0
answr205
	.string	"FRANCE",0
answr206
     	.string	"AUSTRALIA",0
answr207
     	.string	"ENGLAND",0
answr208
     	.string	"ITALY",0
answr209
     	.string	"SWEDEN",0
answr210
     	.string	"LITHUANIA",0
answr211
     	.string	"AUSTRALIA",0
answr212
     	.string	"UNITED STATES OF AMERICA",0
answr213
     	.string	"BRAZIL",0
answr214
	.string	"CZECH REPUBLIC",0
answr215
	.string	"SOUTH AFRICA",0
answr216
	.string	"SCOTLAND",0
answr217
	.string	"KANSAS CITY",0
answr218
	.string	"FT. WAYNE",0
answr219
	.string	"NEW ORLEANS",0
answr220
	.string	"DENVER",0
answr221
	.string	"PHOENIX",0
answr222
	.string	"PITTSBURGH",0
answr223
	.string	"PHILADELPHIA",0
answr224
	.string	"DES MOINES",0
answr225
	.string	"MADISON",0
answr226
	.string	"MINNEAPOLIS",0
answr227
	.string	"BUFFALO",0
answr228
	.string	"SOUTH BEND",0
answr229
	.string	"GARY",0
answr230
	.string	"BOSTON	",0
answr231
	.string	"ATLANTA",0
answr232
	.string	"CHICAGO",0
answr233
      	.string	"CLEVELAND CAVALIERS",0
answr234
	.string	"MIAMI HEAT",0
answr235
	.string	"NEW YORK KNICKS",0
answr236
	.string	"SACRAMENTO KINGS",0
answr237
	.string	"LOS ANGELES",0
answr238
	.string	"SALT LAKE CITY",0
answr239
	.string	"CINCINNATI",0
answr240
	.string	"KALAMAZOO",0
answr241
	.string	"SAN DIEGO",0
answr242
	.string	"ST. LOUIS",0
answr243
	.string	"PHILADELPHIA 76ERS",0
answr244
	.string	"PHOENIX SUNS",0
answr245
	.string	"MILWAUKEE BUCKS",0
answr246
	.string	"UTAH JAZZ",0
answr247
	.string	"CHICAGO BULLS",0
answr248
	.string	"ORLANDO",0
answr249
	.string	"MIAMI",0
answr250
	.string	"CHARLOTTE",0
answr251
	.string	"PORTLAND",0
answr252
	.string	"DETROIT PISTONS",0
answr253
	.string	"INDIANA PACERS",0
answr254
	.string	"SAN ANTONIO SPURS",0
answr255
	.string	"DALLAS",0
answr256
	.string	"SAN ANTONIO",0
answr257
	.string	"MINNESOTA",0
answr258
      	.string	"MEMPHIS",0
answr259
	.string	"BOSTON CELTICS",0
answr260
	.string	"HOUSTON ROCKETS",0
answr261
	.string	"LOS ANGELES LAKERS",0
answr262
	.string	"CLEVELAND",0
answr263
      	.string	"MILWAUKEE",0
answr264
	.string	"RENO",0
answr265
	.string	"TORONTO",0
answr266
	.string	"TORONTO RAPTORS",0
answr267
	.string	"CHARLOTTE HORNETS",0
answr268
	.string	"DALLAS MAVERICKS",0
answr269
	.string	"DENVER NUGGETS",0
answr270
	.string	"PORTLAND TRAIL BLAZERS",0
answr271
	.string	"ORLANDO MAGIC",0
answr272
	.string	"GOLDEN STATE WARRIORS",0
answr273
	.string	"SEATTLE SUPERSONICS",0
answr274
	.string	"NEW JERSEY NETS",0
answr275
	.string	"KINGS",0
answr276
	.string	"PUPPYDOGS",0
answr277
	.string	"TRAIL BLAZERS",0
answr278
	.string	"PRINCES",0
answr279
	.string	"KNICKS",0
answr280
	.string	"NETS",0
answr281
	.string	"DEVILS",0
answr282
	.string	"BUCKS",0
answr283
	.string	"BULLS",0
answr284
	.string	"PACERS",0
answr285
	.string	"CHEESEHEADS",0
answr286
	.string	"DOLPHINS",0
answr287
	.string	"HURRICANES",0
answr288
	.string	"HEAT",0
answr289
	.string	"MAGIC",0
answr290
	.string	"DUCKS",0
answr291
	.string	"MICE",0
answr292
	.string	"VANCOUVER GRIZZLIES",0
answr293
	.string	"GRIZZLIES",0
answr294
	.string	"TORNADOES",0
answr295
	.string	"RAPTORS",0
answr296
	.string	"CANADIANS",0
answr297
	.string	"ROCKETS",0
answr298
	.string	"SUNS",0
answr299
	.string	"SPURS",0
answr300
	.string	"MINNESOTA TIMBERWOLVES",0
answr301
	.string	"LOS ANGELES CLIPPERS",0
answr302
	.string	"1989-90",0
answr303
	.string	"1988-89",0
answr304
	.string	"1990-91",0
answr305
	.string	"1962",0
answr306
	.string	"1963",0
answr307
	.string	"1966",0
answr308
	.string	"1970",0
answr309
	.string	"1974",0
answr310
	.string	"1983",0
answr311
	.string	"1991",0
answr312
	.string	"GUARD",0
answr313
	.string	"CENTER",0
answr314
	.string	"FORWARD",0
answr315
	.string	"HALFBACK",0
answr316
	.string "SHORTSTOP",0
answr317
	.string	"PLACE KICKER",0
answr318
	.string	"QUARTERBACK",0
answr319
	.string	"FREE SAFTEY",0
answr320
	.string	"FULLBACK",0
answr321
	.string	"LEFT WING",0
answr322
	.string	"RIGHT WING",0
answr323
	.string	"CENTERFIELD",0
answr324
	.string "LINEBACKER",0
answr325
	.string "FIRST BASEMAN",0
answr326
	.string "SECOND BASEMAN",0
answr327
	.string "PUNTER",0
answr328
	.string "CENTER FIELDER",0
answr329
	.string "LEFT TACKLE",0
answr330
	.string "WIDE RECEIVER",0
answr331
	.string	"GOALIE",0
answr332
	.string	"CATCHER",0
answr333
	.string	"SECOND BASE",0
answr334
	.string	"REFEREE",0
answr335
	.string	"STRIKER",0
answr336
	.string	"ARMY",0
answr337
	.string	"NAVY",0
answr338
	.string	"AIR FORCE",0
answr339
	.string	"MARINES",0
answr340
	.string	"JOE DUMARS",0
answr341
	.string	"1987-88",0
	.even




hdr_str_a
	.string "A) ",0
	.even
hdr_str_b
	.string "B) ",0
	.even
hdr_str_c
	.string "C) ",0
	.even
hdr_str_d
	.string "D) ",0
	.even


	.asg	41,CONGRATS_Y
	.asg	73,ENTRY_Y
	.asg	125,ADDRESS_Y
	.asg	166,ENTRY_DATE_Y

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	print_trivia_entry_msg

	move	@showing_info,a14
	jrnz	ptem_1				;br=already printed info
	inc	a14
	move	a14,@showing_info

	calla	pal_clean

	movi	congrats_str_setup,a2
	calla	setup_message
	movi	congrats_str,a4
	calla	print_string_C2

;	.ref	CYCLE_TABLE,BSTCYCB_P
;	movi	[1,31],a8		;START AT COLOR 10, CYCLE 7 COLORS
;	movi	BST18B2_P,a9			;PAL NAME
;	movi	BSTCYCB_P,a10
;	movk	2,a11			;RATE OF CYCLE IN TICKS
;	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	movi	trivia_entry_str_setup,a2
	calla	setup_message
	movk	12,a0
	move	a0,@mess_line_spacing
	movi	trivia_entry_str,a4
	calla	print_string_C2

	movi	trivia_address_str_setup,a2
	calla	setup_message
	movk	12,a0
	move	a0,@mess_line_spacing
	movi	trivia_addr_str,a4
	calla	print_string_C2

	movi	entry_date_str_setup,a2
	calla	setup_message
	movi	entry_data_str,a4
	calla	print_string_C2
ptem_1 	rets



congrats_str_setup
	PRINT_STR	bast18_ascii,10,0,199,CONGRATS_Y,BSTGWWOP,0

trivia_entry_str_setup
	PRINT_STR	bast8t_ascii,6,0,199,ENTRY_Y,BAST_Y_P,0

trivia_address_str_setup
	PRINT_STR	bast8t_ascii,6,0,199,ADDRESS_Y,BAST_W_P,0

entry_date_str_setup
	PRINT_STR	bast7t_ascii,6,0,199,ENTRY_DATE_Y,BAST_Y_P,0

congrats_str
	.string	"CONGRATUATIONS !!!",0
	.even

trivia_entry_str
	.string	"TO BE ENTERD INTO A DRAWING FOR VALUABLE PRIZES,",1
	.string	"SEND YOUR PASSWORD, GAME NAME AND PIN NUMBER,",1
	.string	"ALONG WITH YOUR FULL NAME, AGE, ADDRESS AND",1
	.string	"PHONE NUMBER TO:",0

trivia_addr_str
	.string	"NBA HANGTIME TRIVIA GAME ENTRIES",1
	.string	"P.O. BOX 52990, DEP. 7526",1
	.string	"PHOENIX, AZ. 85072-2990",0
	.even

entry_data_str
	.string	"ENTRIES MUST BE RECEIVED BY SEPTEMBER 13, 1996",0
	.even

;-----------------------------------------------------------------------------
;	This routine prints the player TRIVIA POINT count in his/her 
; attribute box
;
;	INPUT: reg a10 - player number
;-----------------------------------------------------------------------------
 SUBRP	print_trivia_pts_str

	movi	trivia_title_setup,a2,L
	calla	setup_message

	move	a10,a0
	sll	4,a0
	addi	pts_id_tbl,a0
	move	*a0,a0,W
	move	a0,@mess_objid

	movi	init_x,a14,L
	move	@TWOPLAYERS,a0			;0 = NO, 1 = YES 2 players
	jrz	psa_0a
	movi	kit_x,a14,L			;kit x vals
psa_0a
	move	a10,a1
	sll	4,a1
	add	a1,a14
	move	*a14,a14			;get center X coor.
	move	a14,@mess_cursx

	movi	str_trivia_pts,a4
	calla	print_string_C2

	move	@mess_cursy,a0
	addk	13,a0
	move	a0,@mess_cursy

	movi	BAST_W_P,a1
	move	a1,@message_palette,L
	move	*a9(PR_TRIVIA_PTS),a0
	jrnz	psa_0
	movi	str_zero,a4
	calla	print_string_C2
	jruc	psa_1
psa_0	movi	200,a1				;max value
	calla	dec_to_asc
	calla	print_string_C3			;centered
psa_1
	rets



trivia_title_setup
	PRINT_STR	bast8t_ascii,7,1,200,TRIVIA_PTS_Y,BAST_Y_P,0

str_trivia_pts	.string 98h,0
;str_trivia_pts	.string "TRIVIA PTS:",0
		.even

str_zero	.string	"NONE",0
		.even

name_setup
	PRINT_STR	bast8_ascii,7,0,200,NAME_Y,BAST_W_P,0
	

plr_struct_tbl
	.long	player1_data
	.long	player2_data
	.long	player3_data
	.long	player4_data

plyr_cursor_tbl
	LWW	TRIVIA1,5000,0
	LWW	TRIVIA2,6000,0
	LWW	TRIVIA3,7000,0
	LWW	TRIVIA4,8000,0

plyr_cursor_tbl2
	LWW	TRIVIA1,5000,0
	LWW	TRIVIA1,5000,0
	LWW	TRIVIA2,6000,0
	LWW	TRIVIA2,6000,0


correct_answer_imgs
	.long	CORECTgrn
	.long	CORECTgrn
	.long	CORECTgrn
	.long	CORECTgrn
	.long	CORECTgrn ;For kit
	.long	CORECTgrn
	.long	CORECTgrn
	.long	CORECTgrn

;	.long	CORECTblu
;	.long	CORECTgrn
;	.long	CORECTyel
;	.long	CORECTred
;	.long	CORECTgrn ;For kit
;	.long	CORECTblu
;	.long	CORECTred
;	.long	CORECTyel

wrong_answer_imgs
	.long	INCRECTred
	.long	INCRECTred
	.long	INCRECTred
	.long	INCRECTred
	.long	INCRECTred ;For kit
	.long	INCRECTred
	.long	INCRECTred
	.long	INCRECTred

;	.long	INCRECTblu
;	.long	INCRECTgrn
;	.long	INCRECTyel
;	.long	INCRECTred
;	.long	INCRECTgrn ;For kit
;	.long	INCRECTblu
;	.long	INCRECTred
;	.long	INCRECTyel


;-----------------------------------------------------------------------------
;	This routine shows the player the instructions/password for 
; reaching the trivia point prize level
;
;  INPUT: reg a10 - player number
; RETURN: nothing
;-----------------------------------------------------------------------------
 SUBRP	show_player_password

;delete question and answers

	movi	RULES_ID,a0
	calla	obj_del1c

;delete trivia points msg
	move	a10,a0
	sll	4,a0
	addi	pts_id_tbl,a0
	move	*a0,a0,W
	calla	obj_del1c

	SLEEPK	1

	callr	print_trivia_entry_msg

	PUSHP	a9
	JSRP	drop_qualify_plaque
	PULLP	a9

;delete trivia points msg.
	move	a10,a0
	sll	4,a0
	addi	pts_id_tbl,a0
	move	*a0,a0,W
	calla	obj_del1c

	move	a10,a0
	sll	4,a0
	addi	pts_id_tbl,a0
	move	*a0,a1,W
	callr	print_plr_password

	SLEEP	30
	movi	5*TSEC,a8			;max time to hold
wlp_1
	SLEEPK	1
	move	a10,a0
	calla	get_but_val_down
	jrnz	wlp_2
     	dsj	a8,wlp_1
wlp_2

;delete players password
	move	a10,a0
	sll	4,a0
	addi	pts_id_tbl,a0
	move	*a0,a0,W
	calla	obj_del1c
 	RETP

;-----------------------------------------------------------------------------
;		Drops the 'TRIVIA DRAWING QUALIFIER' plaque
;	
;  INPUT: reg a10 - player number
;-----------------------------------------------------------------------------
 SUBR	drop_qualify_plaque

	movi	trivia_qualify_imgs,a14
	move	a10,a0
	sll	5,a0
	add	a0,a14
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	spp_1
	addi	4*32,a14			;get KIT image ptr.
spp_1	move	*a14,a9,L
	JSRP	anim_answer_plaque
	RETP

;-----------------------------------------------------------------------------
;	  A PROCESS to drop the 'TRIVIA DRAWING QUALIFIER' plaque
;-----------------------------------------------------------------------------
 SUBR	qualify_plaque

	JSRP	drop_qualify_plaque
	DIE



trivia_qualify_imgs
	.long	QUALIFYgrn
	.long	QUALIFYgrn
	.long	QUALIFYgrn
	.long	QUALIFYgrn
	.long	QUALIFYgrn ;For kit
	.long	QUALIFYgrn
	.long	QUALIFYgrn
	.long	QUALIFYgrn

;	.long	QUALIFYblu
;	.long	QUALIFYgrn
;	.long	QUALIFYyel
;	.long	QUALIFYred
;	.long	QUALIFYgrn ;For kit
;	.long	QUALIFYblu
;	.long	QUALIFYred
;	.long	QUALIFYyel

;-----------------------------------------------------------------------------
;	This routine deletes and reprints the players trivia points message
;
; INPUT: reg a10 - player number
;-----------------------------------------------------------------------------
 SUBR	update_trivia_pts_msg

	move	a10,a0
	sll	4,a0
	addi	pts_id_tbl,a0
	move	*a0,a0,W
	calla	obj_del1c

	callr	print_trivia_pts_str
 	rets



pts_id_tbl
	.word	TRIVIA_PTS_1_ID
	.word	TRIVIA_PTS_2_ID
	.word	TRIVIA_PTS_3_ID
	.word	TRIVIA_PTS_4_ID



	.asg	183,PLAQUE_Y

;;FIX!! (remove after show)
;	.bss	jeftmp,32
;;FIX!! (remove after show)

;-----------------------------------------------------------------------------
;	This routine drops a plaque into the players TV area
;
; INPUT: reg a10 - player number
;	 reg a9 - ptr. to plaque image to drop
;-----------------------------------------------------------------------------
 SUBRP	anim_answer_plaque

	PUSHP	a8
;	move	a9,@jeftmp,L
aap_0
	SLEEPK	1
	move	@plyrs_left,a14
	jrgt	aap_0

	movi	CNTDWN_PID,a0
	calla	KIL1C
	movi	TRIVIA_TIMER,a0
	calla	obj_del1c

	move	a10,a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	aap1
	addk	4,a0				;add in offset for 2 PLYR KIT
aap1
	sll	4,a0				;x 16
	addi	plaque_xs,a0
	move	*a0,a0				;x val
	sll	16,a0
	movi	[PLAQUE_Y-(16*16),0],a1		;y val
	move	a9,a2
	movi	20300,a3			;z (allow FULLGAME PLAQUE over it)
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	movi	[16,0],a7			;y vel
	calla	BEGINOBJ2

	move	a10,a0
	sll	5,a0
	addi	plaque_snds,a0
	move	*a0,a0,L
	calla	snd_play1
aap2
	SLEEPK	1
	move	*a8(OYPOS),a0
	cmpi	PLAQUE_Y,a0
	jrlt	aap2
	clr	a0
	move	a0,*a8(OYVEL),L

	move	a10,a0
	sll	5,a0
	addi	plaque_lnds_snds,a0
	move	*a0,a0,L
	calla	snd_play1

	PUSHP	a10
	movk	22,a10
	calla	SHAKER2
	PULLP	a10

	move	a10,a9
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	aap3
	addk	4,a9				;add in offset for 2 PLYR KIT
aap3	sll	5,a9
	addi	plaque_flsh_pals,a9
	move	*a9,a9,L			;get pal flash tbl ptr.
aap4
	move	*a9+,a0,L			;at end of table ?
	jrnn	aap5				;br=yes
	calla	pal_getf
;FIX!!
;	move	a0,*a8(OPAL),L
	SLEEPK	3
	jruc	aap4
aap5
	SLEEP	68
	calla	DELOBJA8

	PULLP	a8
	RETP


	.asg	10,NUM_FLSH_PALS

;-----------------------------------------------------------------------------
;	This routine flashes the players cursor when the player select an
; answer
;
; INPUT: reg a8 - obj ptr. of obj. to flash
;        reg a10 - player number
;-----------------------------------------------------------------------------
 SUBRP	flash_plyr_cursor

	PUSHP	a10
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	fpc_0
	addk	4,a10				;add in offset for 2 PLYR KIT
fpc_0	sll	5,a10
	addi	plaque_flsh_pals,a10
	move	*a10,a10,L			;get pal flash tbl ptr.
fpc_1
	move	*a10+,a0,L				;at end of table ?
	jrnn	fpc_2				;br=yes
	calla	pal_getf
	move	a0,*a8(OPAL),L
	SLEEPK	2
	jruc	fpc_1
fpc_2
	PULLP	a10
	RETP

;-----------------------------------------------------------------------------
;	This routine puts up a plaque to HIDE the players attributes
;
; INPUT: a10 = player number (0-3)
;-----------------------------------------------------------------------------
 SUBR	hide_plyr_attribs

	move	a10,a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	hpa_1
	addk	4,a0				;add in offset for 2 PLYR KIT
hpa_1	move	a0,a9
	sll	4,a0				;x 16
	addi	plaque_xs,a0
	move	*a0,a0				;x val
	sll	16,a0
	movi	[PLAQUE_Y,0],a1			;y val
	movi	HIDEAT,a2
	movi	15000,a3			;z (allow FULLGAME PLAQUE over it)
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;x vel
	calla	BEGINOBJ2

	SOUND1	plaque_land3
	sll	5,a9
	addi	hide_atts_pal_tbl,a9
	move	*a9,a9,L			;table of pals to cycle with
hpa_1a
	move	a9,a10
hpa_2
	move	*a10+,a0,L
	cmpi	4000,a0
	jreq	hpa_1a
	calla	pal_getf
	move	a0,*a8(OPAL)
	SLEEPK	6
     	jruc	hpa_2



hide_atts_pal_tbl
	.long	hide_atts_red_tbl
	.long	hide_atts_yel_tbl
	.long	hide_atts_grn_tbl
	.long	hide_atts_blu_tbl
	.long	hide_atts_red_tbl	;kit
	.long	hide_atts_red_tbl
	.long	hide_atts_blu_tbl
	.long	hide_atts_blu_tbl

hide_atts_red_tbl
	.long	HIDER1_P
	.long	HIDER2_P
	.long	HIDER3_P
	.long	HIDER4_P
	.long	HIDER5_P
	.long	HIDER6_P
	.long	HIDER7_P
	.long	HIDER8_P
	.long	HIDER7_P
	.long	HIDER6_P
	.long	HIDER5_P
	.long	HIDER4_P
	.long	HIDER3_P
	.long	HIDER2_P
	.long	4000

hide_atts_yel_tbl
	.long	HIDEY1_P
	.long	HIDEY2_P
	.long	HIDEY3_P
	.long	HIDEY4_P
	.long	HIDEY5_P
	.long	HIDEY6_P
	.long	HIDEY7_P
	.long	HIDEY8_P
	.long	HIDEY7_P
	.long	HIDEY6_P
	.long	HIDEY5_P
	.long	HIDEY4_P
	.long	HIDEY3_P
	.long	HIDEY2_P
	.long	4000

hide_atts_grn_tbl
	.long	HIDEG1_P
	.long	HIDEG2_P
	.long	HIDEG3_P
	.long	HIDEG4_P
	.long	HIDEG5_P
	.long	HIDEG6_P
	.long	HIDEG7_P
	.long	HIDEG8_P
	.long	HIDEG7_P
	.long	HIDEG6_P
	.long	HIDEG5_P
	.long	HIDEG4_P
	.long	HIDEG3_P
	.long	HIDEG2_P
	.long	4000

hide_atts_blu_tbl
	.long	HIDEB1_P
	.long	HIDEB2_P
	.long	HIDEB3_P
	.long	HIDEB4_P
	.long	HIDEB5_P
	.long	HIDEB6_P
	.long	HIDEB7_P
	.long	HIDEB8_P
	.long	HIDEB7_P
	.long	HIDEB6_P
	.long	HIDEB5_P
	.long	HIDEB4_P
	.long	HIDEB3_P
	.long	HIDEB2_P
	.long	4000

;---------
;palettes
;---------

	.def	HIDER1_P,OVERW_P

OVERW_P:
	.word	8
	.word	04631H,00H,07FFFH,06F7BH,05AD6H,04631H,03DEFH,035ADH

HIDER1_P
   .word   60
   .word   04631H,00H,04800H,04400H,04400H,04000H,04000H,03C00H
   .word   03C00H,03800H,03400H,03400H,03000H,03000H,02C00H,02C00H
   .word   02800H,02400H,01C00H,01800H,01400H,01000H,0C00H,0800H
   .word   0400H,03C1AH,03015H,03014H,02C13H,02811H,02410H,0240FH
   .word   0200EH,0200DH,01C0DH,01C0CH,01C0BH,0180BH,0180AH,01409H
   .word   01408H,01008H,01007H,01006H,0C06H,0C05H,0804H,0803H
   .word   0403H,0402H,01H,07FFFH,0739CH,06739H,05AD6H,04E73H
   .word   04210H,035ADH,0294AH,01CE7H

HIDER2_P:
   .word   60 
   .word   04631h,00000h,05400h,05000h,04c00h,04800h,04400h,04400h
   .word   04000h,03c00h,03800h,03800h,03400h,03000h,02c00h,02c00h
   .word   02800h,02400h,01c00h,01800h,01400h,01000h,00c00h,00800h
   .word   00400h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDER3_P:
   .word   60 
   .word   04631h,00000h,05c00h,05800h,05400h,05000h,04c00h,04800h
   .word   04400h,04000h,03c00h,03800h,03400h,03000h,03000h,02c00h
   .word   02800h,02400h,01c00h,01800h,01400h,01000h,00c00h,00800h
   .word   00400h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDER4_P:
   .word   60 
   .word   04631h,00000h,06000h,06400h,06000h,05c00h,05800h,05400h
   .word   05000h,04800h,04400h,04000h,03c00h,03800h,03400h,03000h
   .word   02c00h,02800h,02000h,01c00h,01800h,01400h,01000h,00c00h
   .word   00800h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDER5_P:
   .word   60 
   .word   04631h,00000h,07000h,06800h,06400h,06000h,05c00h,05800h
   .word   05400h,04c00h,04800h,04400h,04000h,03c00h,03800h,03400h
   .word   03000h,02c00h,02400h,02000h,01c00h,01800h,01400h,01000h
   .word   00c00h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDER6_P:
   .word   60 
   .word   04631h,00000h,07c00h,07800h,07000h,06c00h,06800h,06000h
   .word   05c00h,05800h,05000h,04c00h,04800h,04000h,03c00h,03800h
   .word   03400h,03000h,02800h,02400h,02000h,01c00h,01800h,01400h
   .word   01000h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDER7_P:
   .word   60 
   .word   04631h,00000h,07c00h,07c00h,07c00h,07800h,07000h,06c00h
   .word   06400h,06000h,05800h,05400h,04c00h,04800h,04000h,03c00h
   .word   03800h,03400h,02c00h,02800h,02400h,02000h,01c00h,01800h
   .word   01400h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDER8_P:
   .word   60 
   .word   04631h,00000h,07c00h,07c00h,07c00h,07c00h,07800h,07000h
   .word   06c00h,06400h,05c00h,05800h,05000h,04c00h,04400h,04000h
   .word   03c00h,03800h,03000h,02c00h,02800h,02400h,02000h,01c00h
   .word   01800h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h


HIDEY1_P:
   .word   60 
   .word   04631h,00000h,039c0h,039c0h,039c0h,035a0h,035a0h,035a0h
   .word   03180h,03180h,03180h,03180h,02d60h,02d60h,02d60h,02d60h
   .word   02520h,02100h,01ce0h,018c0h,014a0h,01080h,00c60h,00840h
   .word   00420h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEY2_P:
   .word   60 
   .word   04631h,00000h,04620h,04200h,04200h,03de0h,03de0h,039c0h
   .word   039c0h,035a0h,035a0h,03180h,03180h,02d60h,02d60h,02d60h
   .word   02520h,02100h,01ce0h,018c0h,014a0h,01080h,00c60h,00840h
   .word   00420h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEY3_P:
   .word   60 
   .word   04631h,00000h,04e60h,04a40h,04a40h,04620h,04200h,04200h
   .word   03de0h,039c0h,039c0h,035a0h,035a0h,03180h,02d60h,02d60h
   .word   02520h,02100h,01ce0h,018c0h,014a0h,01080h,00c60h,00840h
   .word   00420h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEY4_P:
   .word   60 
   .word   04631h,00000h,05ac0h,056a0h,05280h,04e60h,04a40h,04620h
   .word   04200h,04200h,03de0h,039c0h,035a0h,03180h,02d60h,02d60h
   .word   02520h,02100h,01ce0h,018c0h,014a0h,01080h,00c60h,00840h
   .word   00420h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEY5_P:
   .word   60 
   .word   04631h,00000h,06300h,05ee0h,05ac0h,056a0h,05280h,04e60h
   .word   04a40h,04620h,04200h,03de0h,039c0h,035a0h,03180h,02d60h
   .word   02520h,02100h,01ce0h,018c0h,014a0h,01080h,00c60h,00840h
   .word   00420h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEY6_P:
   .word   60 
   .word   04631h,00000h,06b40h,06300h,05ee0h,05ac0h,056a0h,05280h
   .word   04e60h,04620h,04200h,03de0h,039c0h,035a0h,03180h,02d60h
   .word   02520h,02100h,01ce0h,018c0h,014a0h,01080h,00c60h,00840h
   .word   00420h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEY7_P:
   .word   60 
   .word   04631h,00000h,06f60h,06b40h,06720h,05ee0h,05ac0h,056a0h
   .word   04e60h,04a40h,04620h,04200h,039c0h,035a0h,03180h,02d60h
   .word   02520h,02100h,01ce0h,018c0h,014a0h,01080h,00c60h,00840h
   .word   00420h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEY8_P:
   .word   60 
   .word   04631h,00000h,077a0h,06f60h,06b40h,06300h,05ee0h,05ac0h
   .word   05280h,04e60h,04620h,04200h,03de0h,035a0h,03180h,02d60h
   .word   02520h,02100h,01ce0h,018c0h,014a0h,01080h,00c60h,00840h
   .word   00420h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h


HIDEG1_P:
   .word   60 
   .word   04631h,00000h,001c0h,001c0h,001c0h,001a0h,001a0h,001a0h
   .word   00180h,00180h,00180h,00180h,00160h,00160h,00160h,00160h
   .word   00120h,00100h,000e0h,000c0h,000a0h,00080h,00060h,00040h
   .word   00020h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEG2_P:
   .word   60 
   .word   04631h,00000h,00220h,00200h,00200h,001e0h,001e0h,001c0h
   .word   001c0h,001a0h,001a0h,00180h,00180h,00160h,00160h,00160h
   .word   00120h,00100h,000e0h,000c0h,000a0h,00080h,00060h,00040h
   .word   00020h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEG3_P:
   .word   60 
   .word   04631h,00000h,00260h,00240h,00220h,00220h,00200h,001e0h
   .word   001e0h,001c0h,001c0h,001a0h,00180h,00180h,00160h,00160h
   .word   00120h,00100h,000e0h,000c0h,000a0h,00080h,00060h,00040h
   .word   00020h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEG4_P:
   .word   60 
   .word   04631h,00000h,002a0h,00280h,00260h,00240h,00220h,00220h
   .word   00200h,001e0h,001c0h,001c0h,001a0h,00180h,00160h,00160h
   .word   00120h,00100h,000e0h,000c0h,000a0h,00080h,00060h,00040h
   .word   00020h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEG5_P:
   .word   60 
   .word   04631h,00000h,002e0h,002c0h,002a0h,00280h,00260h,00240h
   .word   00220h,00200h,001e0h,001c0h,001a0h,00180h,00160h,00160h
   .word   00120h,00100h,000e0h,000c0h,000a0h,00080h,00060h,00040h
   .word   00020h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEG6_P:
   .word   60 
   .word   04631h,00000h,00320h,002e0h,002c0h,002a0h,00280h,00260h
   .word   00240h,00220h,00200h,001e0h,001c0h,001a0h,00180h,00160h
   .word   00120h,00100h,000e0h,000c0h,000a0h,00080h,00060h,00040h
   .word   00020h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEG7_P:
   .word   60 
   .word   04631h,00000h,00360h,00320h,00300h,002e0h,002c0h,00280h
   .word   00260h,00240h,00220h,001e0h,001c0h,001a0h,00180h,00160h
   .word   00120h,00100h,000e0h,000c0h,000a0h,00080h,00060h,00040h
   .word   00020h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEG8_P:
   .word   60 
   .word   04631h,00000h,003a0h,00360h,00340h,00300h,002e0h,002c0h
   .word   00280h,00260h,00220h,00200h,001e0h,001a0h,00180h,00160h
   .word   00120h,00100h,000e0h,000c0h,000a0h,00080h,00060h,00040h
   .word   00020h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h


HIDEB1_P:
   .word   60 
   .word   04631h,00000h,00012h,00011h,00011h,00010h,00010h,0000fh
   .word   0000fh,0000eh,0000dh,0000dh,0000ch,0000ch,0000bh,0000bh
   .word   00009h,00008h,00007h,00006h,00005h,00004h,00003h,00002h
   .word   00001h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEB2_P:
   .word   60 
   .word   04631h,00000h,00014h,00013h,00013h,00012h,00011h,00010h
   .word   00010h,0000fh,0000eh,0000dh,0000dh,0000ch,0000bh,0000bh
   .word   00009h,00008h,00007h,00006h,00005h,00004h,00003h,00002h
   .word   00001h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEB3_P:
   .word   60 
   .word   04631h,00000h,00016h,00015h,00014h,00013h,00013h,00012h
   .word   00011h,00010h,0000fh,0000eh,0000dh,0000ch,0000bh,0000bh
   .word   00009h,00008h,00007h,00006h,00005h,00004h,00003h,00002h
   .word   00001h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h
HIDEB4_P:
   .word   60 
   .word   04631h,00000h,00019h,00018h,00017h,00016h,00015h,00014h
   .word   00013h,00012h,00011h,00010h,0000fh,0000eh,0000dh,0000ch
   .word   0000ah,00009h,00008h,00007h,00006h,00005h,00004h,00003h
   .word   00002h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEB5_P:
   .word   60 
   .word   04631h,00000h,0001ch,0001bh,0001ah,00018h,00017h,00016h
   .word   00015h,00014h,00013h,00011h,00010h,0000fh,0000eh,0000dh
   .word   0000bh,0000ah,00009h,00008h,00007h,00006h,00005h,00004h
   .word   00003h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEB6_P:
   .word   60 
   .word   04631h,00000h,0043fh,0043eh,0043ch,0043bh,0043ah,00438h
   .word   00437h,00436h,00434h,00433h,00432h,00430h,0042fh,0042eh
   .word   0042ch,0042bh,0042ah,00429h,00428h,00427h,00426h,00425h
   .word   00424h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEB7_P:
   .word   60 
   .word   04631h,00000h,0085fh,0085fh,0085fh,0085eh,0085ch,0085bh
   .word   00859h,00858h,00856h,00855h,00853h,00852h,00850h,0084fh
   .word   0084dh,0084ch,0084bh,0084ah,00849h,00848h,00847h,00846h
   .word   00845h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h

HIDEB8_P:
   .word   60 
   .word   04631h,00000h,00c7fh,00c7fh,00c7fh,00c7fh,00c7eh,00c7ch
   .word   00c7bh,00c79h,00c77h,00c76h,00c74h,00c73h,00c71h,00c70h
   .word   00c6eh,00c6dh,00c6ch,00c6bh,00c6ah,00c69h,00c68h,00c67h
   .word   00c67h,03c1ah,03015h,03014h,02c13h,02811h,02410h,0240fh
   .word   0200eh,0200dh,01c0dh,01c0ch,01c0bh,0180bh,0180ah,01409h
   .word   01408h,01008h,01007h,01006h,00c06h,00c05h,00804h,00803h
   .word   00403h,00402h,00001h,07fffh,0739ch,06739h,05ad6h,04e73h
   .word   04210h,035adh,0294ah,01ce7h



;-----------------------------------------------------------------------------
;    This table is used for the STARRING nba players page in attract mode
;-----------------------------------------------------------------------------
player_heads2
	.long	AUG_ATL
	.long	BLY_ATL
	.long	SMI_ATL
	.long	LAE_ATL
	.long	NOR_ATL

	.long	BRO_BOS
	.long	BAR_BOS
	.long	MON_BOS
	.long	RAD_BOS
	.long	FOX_BOS

	.long	AND_CHA
	.long	JON_CHA
	.long	RCE_CHA
	.long	ZID_CHA
	.long	CUR_CHA

	.long	PIP_CHI
	.long	ROD_CHI
	.long	KUK_CHI
	.long	LON_CHI
	.long	KER_CHI
	
	.long	HIL_CLE
	.long	MIL_CLE
	.long	PHL_CLE
	.long	BRA_CLE
	.long	FER_CLE

	.long	JAC_DAL
	.long	KID_DAL
	.long	MAS_DAL
	.long	JON_DAL
	.long	MCC_DAL

	.long	RAF_DEN
	.long	MUT_DEN
	.long	MCD_DEN
	.long	ROS_DEN
	.long	ELL_DEN

	.long	DUM_DET
	.long	HIL_DET
	.long	MLS_DET
	.long	THR_DET
	.long	HOU_DET

	.long	WLS_GLD
	.long	SPR_GLD
	.long	SKL_GLD
	.long	SMI_GLD
	.long	MUL_GLD

	.long	OLA_HOU
	.long	DRX_HOU
	.long	HOR_HOU
	.long	CAS_HOU
	.long	SMT_HOU

	.long	MIL_IND
	.long	DAV_IND
	.long	SMI_IND
	.long	MCK_IND
	.long	JAC_IND

	.long	VAU_CLP
	.long	ROG_CLP
	.long	MUR_CLP
	.long	RCH_CLP
	.long	BAR_CLP

	.long	VAN_LAK
	.long	DIV_LAK
	.long	CEB_LAK
	.long	CAM_LAK
	.long	JON_LAK

	.long	MOU_MIA
	.long	WIL_MIA
	.long	CHP_MIA
	.long	HRD_MIA
	.long	DAN_MIA

	.long	BAK_MLW
	.long	ROB_MLW
	.long	RES_MLW
	.long	BEN_MLW
	.long	DOU_MLW

	.long	RID_MIN
	.long	LNG_MIN
	.long	WEB_MIN
	.long	GUG_MIN
	.long	GAR_MIN

	.long	GLL_NEJ
	.long	BRA_NEJ
	.long	GIL_NEJ
	.long	OBA_NEJ
	.long	EDW_NEJ

	.long	EWG_NEY
	.long	MAS_NEY
	.long	HPR_NEY
	.long	OAK_NEY
	.long	STA_NEY

	.long	HAR_ORL
	.long	GRT_ORL
	.long	AND_ORL
	.long	SCO_ORL
	.long	KON_ORL

	.long	STA_PHL
	.long	COL_PHL
	.long	WEA_PHL
	.long	RUF_PHL
	.long	MAX_PHL

	.long	JOH_PHX
	.long	TIS_PHX
	.long	MAN_PHX
	.long	PER_PHX
	.long	FIN_PHX

	.long	STR_PRT
	.long	ROB_PRT
	.long	SAB_PRT
	.long	WIL_PRT
	.long	CHI_PRT

	.long	OWE_SAC
	.long	RIC_SAC
	.long	GRA_SAC
	.long	MAR_SAC
	.long	EDN_SAC

	.long	ELL_SAN
	.long	ROB_SAN
	.long	JON_SAN
	.long	PRS_SAN
	.long	DEL_SAN

	.long	KMP_SEA
	.long	PAY_SEA
	.long	SCH_SEA
	.long	HWK_SEA
	.long	FOR_SEA

	.long	ROG_TOR
	.long	STO_TOR
	.long	ROB_TOR
	.long	MIL_TOR
	.long	MUR_TOR

	.long	STK_UTA
	.long	MLN_UTA
	.long	HRN_UTA
	.long	BEN_UTA
	.long	MOR_UTA

	.long	ANT_VAN
	.long	EDW_VAN
	.long	SCO_VAN
	.long	REV_VAN
	.long	MUR_VAN

	.long	HWD_WAS
	.long	WEB_WAS
	.long	CHE_WAS
	.long	PAC_WAS
	.long	MUR_WAS

;-----------------------------------------------------------------------------
;		***NOTE*** if change this table...must also update 
;			'player_names' and 'team_sqaud_cnts'
;-----------------------------------------------------------------------------
player_heads

;00 ATLANTA
	.long	AUG_ATL,BLY_ATL
	.long	AUG_ATL,SMI_ATL
	.long	AUG_ATL,LAE_ATL
	.long	AUG_ATL,NOR_ATL

	.long	BLY_ATL,AUG_ATL
	.long	BLY_ATL,SMI_ATL
	.long	BLY_ATL,LAE_ATL
	.long	BLY_ATL,NOR_ATL

	.long	SMI_ATL,AUG_ATL
	.long	SMI_ATL,BLY_ATL
	.long	SMI_ATL,LAE_ATL
	.long	SMI_ATL,NOR_ATL

	.long	LAE_ATL,AUG_ATL
	.long	LAE_ATL,BLY_ATL
	.long	LAE_ATL,SMI_ATL
	.long	LAE_ATL,NOR_ATL

	.long	NOR_ATL,AUG_ATL
	.long	NOR_ATL,BLY_ATL
	.long	NOR_ATL,SMI_ATL
	.long	NOR_ATL,LAE_ATL

;01 BOSTON
	.long	BRO_BOS,BAR_BOS
	.long	BRO_BOS,MON_BOS
	.long	BRO_BOS,RAD_BOS
	.long	BRO_BOS,FOX_BOS

	.long	BAR_BOS,BRO_BOS
	.long	BAR_BOS,MON_BOS
	.long	BAR_BOS,RAD_BOS
	.long	BAR_BOS,FOX_BOS

	.long	MON_BOS,BRO_BOS
	.long	MON_BOS,BAR_BOS
	.long	MON_BOS,RAD_BOS
	.long	MON_BOS,FOX_BOS

	.long	RAD_BOS,BRO_BOS
	.long	RAD_BOS,BAR_BOS
	.long	RAD_BOS,MON_BOS
	.long	RAD_BOS,FOX_BOS

	.long	FOX_BOS,BRO_BOS
	.long	FOX_BOS,BAR_BOS
	.long	FOX_BOS,MON_BOS
	.long	FOX_BOS,RAD_BOS

;02 CHARLOTTE
	.long	AND_CHA,JON_CHA
	.long	AND_CHA,RCE_CHA
	.long	AND_CHA,ZID_CHA
	.long	AND_CHA,CUR_CHA

	.long	JON_CHA,AND_CHA
	.long	JON_CHA,RCE_CHA
	.long	JON_CHA,ZID_CHA
	.long	JON_CHA,CUR_CHA

	.long	RCE_CHA,AND_CHA
	.long	RCE_CHA,JON_CHA
	.long	RCE_CHA,ZID_CHA
	.long	RCE_CHA,CUR_CHA

	.long	ZID_CHA,AND_CHA
	.long	ZID_CHA,JON_CHA
	.long	ZID_CHA,RCE_CHA
	.long	ZID_CHA,CUR_CHA

	.long	CUR_CHA,AND_CHA
	.long	CUR_CHA,JON_CHA
	.long	CUR_CHA,RCE_CHA
	.long	CUR_CHA,ZID_CHA

;03 CHICAGO
	.global	ROD_CHI

	.long	PIP_CHI,ROD_CHI
	.long	PIP_CHI,KUK_CHI
	.long	PIP_CHI,LON_CHI
	.long	PIP_CHI,KER_CHI

	.long	ROD_CHI,PIP_CHI
	.long	ROD_CHI,KUK_CHI
	.long	ROD_CHI,LON_CHI
	.long	ROD_CHI,KER_CHI

	.long	KUK_CHI,PIP_CHI
	.long	KUK_CHI,ROD_CHI
	.long	KUK_CHI,LON_CHI
	.long	KUK_CHI,KER_CHI

	.long	LON_CHI,PIP_CHI
	.long	LON_CHI,ROD_CHI
	.long	LON_CHI,KUK_CHI
	.long	LON_CHI,KER_CHI

	.long	KER_CHI,PIP_CHI
	.long	KER_CHI,ROD_CHI
	.long	KER_CHI,KUK_CHI
	.long	KER_CHI,LON_CHI

;04 CLEVELAND
	.long	HIL_CLE,MIL_CLE
	.long	HIL_CLE,PHL_CLE
	.long	HIL_CLE,BRA_CLE
	.long	HIL_CLE,FER_CLE

	.long	MIL_CLE,HIL_CLE
	.long	MIL_CLE,PHL_CLE
	.long	MIL_CLE,BRA_CLE
	.long	MIL_CLE,FER_CLE

	.long	PHL_CLE,HIL_CLE
	.long	PHL_CLE,MIL_CLE
	.long	PHL_CLE,BRA_CLE
	.long	PHL_CLE,FER_CLE

	.long	BRA_CLE,HIL_CLE
	.long	BRA_CLE,MIL_CLE
	.long	BRA_CLE,PHL_CLE
	.long	BRA_CLE,FER_CLE

	.long	FER_CLE,HIL_CLE
	.long	FER_CLE,MIL_CLE
	.long	FER_CLE,PHL_CLE
	.long	FER_CLE,BRA_CLE

;05 DALLAS
	.long	JAC_DAL,KID_DAL
	.long	JAC_DAL,MAS_DAL
	.long	JAC_DAL,JON_DAL
	.long	JAC_DAL,MCC_DAL

	.long	KID_DAL,JAC_DAL
	.long	KID_DAL,MAS_DAL
	.long	KID_DAL,JON_DAL	
	.long	KID_DAL,MCC_DAL
	
	.long	MAS_DAL,JAC_DAL
	.long	MAS_DAL,KID_DAL
	.long	MAS_DAL,JON_DAL
	.long	MAS_DAL,MCC_DAL

	.long	JON_DAL,JAC_DAL
	.long	JON_DAL,KID_DAL
	.long	JON_DAL,MAS_DAL
	.long	JON_DAL,MCC_DAL

	.long	MCC_DAL,JAC_DAL
	.long	MCC_DAL,KID_DAL
	.long	MCC_DAL,MAS_DAL
	.long	MCC_DAL,JON_DAL

;06 DENVER
	.long	RAF_DEN,MUT_DEN
	.long	RAF_DEN,MCD_DEN
	.long	RAF_DEN,ROS_DEN
	.long	RAF_DEN,ELL_DEN

	.long	MUT_DEN,RAF_DEN
	.long	MUT_DEN,MCD_DEN
	.long	MUT_DEN,ROS_DEN
	.long	MUT_DEN,ELL_DEN

	.long	MCD_DEN,RAF_DEN
	.long	MCD_DEN,MUT_DEN
	.long	MCD_DEN,ROS_DEN
	.long	MCD_DEN,ELL_DEN

	.long	ROS_DEN,RAF_DEN
	.long	ROS_DEN,MUT_DEN
	.long	ROS_DEN,MCD_DEN
	.long	ROS_DEN,ELL_DEN

	.long	ELL_DEN,RAF_DEN
	.long	ELL_DEN,MUT_DEN
	.long	ELL_DEN,MCD_DEN
	.long	ELL_DEN,ROS_DEN

;07 DETROIT
	.long	DUM_DET,HIL_DET
	.long	DUM_DET,MLS_DET
	.long	DUM_DET,THR_DET
	.long	DUM_DET,HOU_DET

	.long	HIL_DET,DUM_DET
	.long	HIL_DET,MLS_DET
	.long	HIL_DET,THR_DET
	.long	HIL_DET,HOU_DET

	.long	MLS_DET,DUM_DET
	.long	MLS_DET,HIL_DET
	.long	MLS_DET,THR_DET
	.long	MLS_DET,HOU_DET

	.long	THR_DET,DUM_DET
	.long	THR_DET,HIL_DET
	.long	THR_DET,MLS_DET
	.long	THR_DET,HOU_DET

	.long	HOU_DET,DUM_DET
	.long	HOU_DET,HIL_DET
	.long	HOU_DET,MLS_DET
	.long	HOU_DET,THR_DET

;08 GOLDEN STATE
	.long	WLS_GLD,SPR_GLD
	.long	WLS_GLD,SKL_GLD
	.long	WLS_GLD,SMI_GLD
	.long	WLS_GLD,MUL_GLD

	.long	SPR_GLD,WLS_GLD
	.long	SPR_GLD,SKL_GLD
	.long	SPR_GLD,SMI_GLD
	.long	SPR_GLD,MUL_GLD
			
	.long	SKL_GLD,WLS_GLD
	.long	SKL_GLD,SPR_GLD
	.long	SKL_GLD,SMI_GLD
	.long	SKL_GLD,MUL_GLD
			
	.long	SMI_GLD,WLS_GLD
	.long	SMI_GLD,SPR_GLD
	.long	SMI_GLD,SKL_GLD
	.long	SMI_GLD,MUL_GLD
			
	.long	MUL_GLD,WLS_GLD
	.long	MUL_GLD,SPR_GLD
	.long	MUL_GLD,SKL_GLD
	.long	MUL_GLD,SMI_GLD
			
;09 HOUSTON
	.long	OLA_HOU,DRX_HOU
	.long	OLA_HOU,HOR_HOU
	.long	OLA_HOU,CAS_HOU
	.long	OLA_HOU,SMT_HOU

	.long	DRX_HOU,OLA_HOU
	.long	DRX_HOU,HOR_HOU
	.long	DRX_HOU,CAS_HOU
	.long	DRX_HOU,SMT_HOU

	.long	HOR_HOU,OLA_HOU
	.long	HOR_HOU,DRX_HOU
	.long	HOR_HOU,CAS_HOU
	.long	HOR_HOU,SMT_HOU

	.long	CAS_HOU,OLA_HOU
	.long	CAS_HOU,DRX_HOU
	.long	CAS_HOU,HOR_HOU
	.long	CAS_HOU,SMT_HOU

	.long	SMT_HOU,OLA_HOU
	.long	SMT_HOU,DRX_HOU
	.long	SMT_HOU,HOR_HOU
	.long	SMT_HOU,CAS_HOU

;10 INDIANA
	.long	MIL_IND,DAV_IND
	.long	MIL_IND,SMI_IND
	.long	MIL_IND,MCK_IND
	.long	MIL_IND,JAC_IND

	.long	DAV_IND,MIL_IND
	.long	DAV_IND,SMI_IND
	.long	DAV_IND,MCK_IND
	.long	DAV_IND,JAC_IND

	.long	SMI_IND,MIL_IND
	.long	SMI_IND,DAV_IND
	.long	SMI_IND,MCK_IND
	.long	SMI_IND,JAC_IND

	.long	MCK_IND,MIL_IND
	.long	MCK_IND,DAV_IND
	.long	MCK_IND,SMI_IND
	.long	MCK_IND,JAC_IND

	.long	JAC_IND,MIL_IND
	.long	JAC_IND,DAV_IND
	.long	JAC_IND,SMI_IND
	.long	JAC_IND,MCK_IND

;11 L.A. CLIPPERS
	.long	VAU_CLP,ROG_CLP
	.long	VAU_CLP,MUR_CLP
	.long	VAU_CLP,RCH_CLP
	.long	VAU_CLP,BAR_CLP

	.long	ROG_CLP,VAU_CLP
	.long	ROG_CLP,MUR_CLP
	.long	ROG_CLP,RCH_CLP
	.long	ROG_CLP,BAR_CLP

	.long	MUR_CLP,VAU_CLP
	.long	MUR_CLP,ROG_CLP
	.long	MUR_CLP,RCH_CLP
	.long	MUR_CLP,BAR_CLP

	.long	RCH_CLP,VAU_CLP
	.long	RCH_CLP,ROG_CLP
	.long	RCH_CLP,MUR_CLP
	.long	RCH_CLP,BAR_CLP

	.long	BAR_CLP,VAU_CLP
	.long	BAR_CLP,ROG_CLP
	.long	BAR_CLP,MUR_CLP
	.long	BAR_CLP,RCH_CLP

;12 L.A. LAKERS
;FIX!!!
;JOH_LAK for JON_LAK
	.long	VAN_LAK,DIV_LAK
	.long	VAN_LAK,CEB_LAK
	.long	VAN_LAK,CAM_LAK
	.long	VAN_LAK,JON_LAK

	.long	DIV_LAK,VAN_LAK
	.long	DIV_LAK,CEB_LAK
	.long	DIV_LAK,CAM_LAK
	.long	DIV_LAK,JON_LAK

	.long	CEB_LAK,VAN_LAK
	.long	CEB_LAK,DIV_LAK
	.long	CEB_LAK,CAM_LAK
	.long	CEB_LAK,JON_LAK

	.long	CAM_LAK,VAN_LAK
	.long	CAM_LAK,DIV_LAK
	.long	CAM_LAK,CEB_LAK
	.long	CAM_LAK,JON_LAK

	.long	JON_LAK,VAN_LAK
	.long	JON_LAK,DIV_LAK
	.long	JON_LAK,CEB_LAK
	.long	JON_LAK,CAM_LAK

;13 MIAMI
	.long	MOU_MIA,WIL_MIA
	.long	MOU_MIA,CHP_MIA
	.long	MOU_MIA,HRD_MIA
	.long	MOU_MIA,DAN_MIA

	.long	WIL_MIA,MOU_MIA
	.long	WIL_MIA,CHP_MIA
	.long	WIL_MIA,HRD_MIA
	.long	WIL_MIA,DAN_MIA

	.long	CHP_MIA,MOU_MIA
	.long	CHP_MIA,WIL_MIA
	.long	CHP_MIA,HRD_MIA
	.long	CHP_MIA,DAN_MIA

	.long	HRD_MIA,MOU_MIA
	.long	HRD_MIA,WIL_MIA
	.long	HRD_MIA,CHP_MIA
	.long	HRD_MIA,DAN_MIA

	.long	DAN_MIA,MOU_MIA
	.long	DAN_MIA,WIL_MIA
	.long	DAN_MIA,CHP_MIA
	.long	DAN_MIA,HRD_MIA

;14 MILWAUKEE
	.long	BAK_MLW,ROB_MLW
	.long	BAK_MLW,RES_MLW
	.long	BAK_MLW,BEN_MLW
	.long	BAK_MLW,DOU_MLW

	.long	ROB_MLW,BAK_MLW
	.long	ROB_MLW,RES_MLW
	.long	ROB_MLW,BEN_MLW
	.long	ROB_MLW,DOU_MLW

	.long	RES_MLW,BAK_MLW
	.long	RES_MLW,ROB_MLW
	.long	RES_MLW,BEN_MLW
	.long	RES_MLW,DOU_MLW

	.long	BEN_MLW,BAK_MLW
	.long	BEN_MLW,ROB_MLW
	.long	BEN_MLW,RES_MLW
	.long	BEN_MLW,DOU_MLW

	.long	DOU_MLW,BAK_MLW
	.long	DOU_MLW,ROB_MLW
	.long	DOU_MLW,RES_MLW
	.long	DOU_MLW,BEN_MLW

;15 MINNESOTTA
	.long	RID_MIN,LNG_MIN
	.long	RID_MIN,WEB_MIN
	.long	RID_MIN,GUG_MIN
	.long	RID_MIN,GAR_MIN

	.long	LNG_MIN,RID_MIN
	.long	LNG_MIN,WEB_MIN
	.long	LNG_MIN,GUG_MIN
	.long	LNG_MIN,GAR_MIN

	.long	WEB_MIN,RID_MIN
	.long	WEB_MIN,LNG_MIN
	.long	WEB_MIN,GUG_MIN
	.long	WEB_MIN,GAR_MIN

	.long	GUG_MIN,RID_MIN
	.long	GUG_MIN,LNG_MIN
	.long	GUG_MIN,WEB_MIN
	.long	GUG_MIN,GAR_MIN

	.long	GAR_MIN,RID_MIN
	.long	GAR_MIN,LNG_MIN
	.long	GAR_MIN,WEB_MIN
	.long	GAR_MIN,GUG_MIN

;16 NEW JERSEY
;GLL is Gill
;GIL is Gilliam
	.long	GLL_NEJ,BRA_NEJ
	.long	GLL_NEJ,GIL_NEJ
	.long	GLL_NEJ,OBA_NEJ
	.long	GLL_NEJ,EDW_NEJ

	.long	BRA_NEJ,GLL_NEJ
	.long	BRA_NEJ,GIL_NEJ
	.long	BRA_NEJ,OBA_NEJ
	.long	BRA_NEJ,EDW_NEJ

	.long	GIL_NEJ,GLL_NEJ
	.long	GIL_NEJ,BRA_NEJ
	.long	GIL_NEJ,OBA_NEJ
	.long	GIL_NEJ,EDW_NEJ

	.long	OBA_NEJ,GLL_NEJ
	.long	OBA_NEJ,BRA_NEJ
	.long	OBA_NEJ,GIL_NEJ
	.long	OBA_NEJ,EDW_NEJ

	.long	EDW_NEJ,GLL_NEJ
	.long	EDW_NEJ,BRA_NEJ
	.long	EDW_NEJ,GIL_NEJ
	.long	EDW_NEJ,OBA_NEJ

;17 NEW YORK
	.long	EWG_NEY,MAS_NEY
	.long	EWG_NEY,HPR_NEY
	.long	EWG_NEY,OAK_NEY
	.long	EWG_NEY,STA_NEY

	.long	MAS_NEY,EWG_NEY
	.long	MAS_NEY,HPR_NEY
	.long	MAS_NEY,OAK_NEY
	.long	MAS_NEY,STA_NEY

	.long	HPR_NEY,EWG_NEY
	.long	HPR_NEY,MAS_NEY
	.long	HPR_NEY,OAK_NEY
	.long	HPR_NEY,STA_NEY

	.long	OAK_NEY,EWG_NEY
	.long	OAK_NEY,MAS_NEY
	.long	OAK_NEY,HPR_NEY
	.long	OAK_NEY,STA_NEY

	.long	STA_NEY,EWG_NEY
	.long	STA_NEY,MAS_NEY
	.long	STA_NEY,HPR_NEY
	.long	STA_NEY,OAK_NEY

;18 ORLANDO
	.long	HAR_ORL,GRT_ORL
	.long	HAR_ORL,AND_ORL
	.long	HAR_ORL,SCO_ORL
	.long	HAR_ORL,KON_ORL

	.long	GRT_ORL,HAR_ORL
	.long	GRT_ORL,AND_ORL
	.long	GRT_ORL,SCO_ORL
	.long	GRT_ORL,KON_ORL

	.long	AND_ORL,HAR_ORL
	.long	AND_ORL,GRT_ORL
	.long	AND_ORL,SCO_ORL
	.long	AND_ORL,KON_ORL

	.long	SCO_ORL,HAR_ORL
	.long	SCO_ORL,GRT_ORL
	.long	SCO_ORL,AND_ORL
	.long	SCO_ORL,KON_ORL

	.long	KON_ORL,HAR_ORL
	.long	KON_ORL,GRT_ORL
	.long	KON_ORL,AND_ORL
	.long	KON_ORL,SCO_ORL

;19 PHILADELPHIA
	.long	STA_PHL,COL_PHL
	.long	STA_PHL,WEA_PHL
	.long	STA_PHL,RUF_PHL
	.long	STA_PHL,MAX_PHL

	.long	COL_PHL,STA_PHL
	.long	COL_PHL,WEA_PHL
	.long	COL_PHL,RUF_PHL
	.long	COL_PHL,MAX_PHL

	.long	WEA_PHL,STA_PHL
	.long	WEA_PHL,COL_PHL
	.long	WEA_PHL,RUF_PHL
	.long	WEA_PHL,MAX_PHL

	.long	RUF_PHL,STA_PHL
	.long	RUF_PHL,COL_PHL
	.long	RUF_PHL,WEA_PHL
	.long	RUF_PHL,MAX_PHL

	.long	MAX_PHL,STA_PHL
	.long	MAX_PHL,COL_PHL
	.long	MAX_PHL,WEA_PHL
	.long	MAX_PHL,RUF_PHL

;20 PHOENIX
	.long	JOH_PHX,TIS_PHX
	.long	JOH_PHX,MAN_PHX
	.long	JOH_PHX,PER_PHX
	.long	JOH_PHX,FIN_PHX

	.long	TIS_PHX,JOH_PHX
	.long	TIS_PHX,MAN_PHX
	.long	TIS_PHX,PER_PHX
	.long	TIS_PHX,FIN_PHX

	.long	MAN_PHX,JOH_PHX
	.long	MAN_PHX,TIS_PHX
	.long	MAN_PHX,PER_PHX
	.long	MAN_PHX,FIN_PHX

	.long	PER_PHX,JOH_PHX
	.long	PER_PHX,TIS_PHX
	.long	PER_PHX,MAN_PHX
	.long	PER_PHX,FIN_PHX

	.long	FIN_PHX,JOH_PHX
	.long	FIN_PHX,TIS_PHX
	.long	FIN_PHX,MAN_PHX
	.long	FIN_PHX,PER_PHX

;21 PORTLAND
	.long	STR_PRT,ROB_PRT
	.long	STR_PRT,SAB_PRT
	.long	STR_PRT,WIL_PRT
	.long	STR_PRT,CHI_PRT

	.long	ROB_PRT,STR_PRT
	.long	ROB_PRT,SAB_PRT
	.long	ROB_PRT,WIL_PRT
	.long	ROB_PRT,CHI_PRT

	.long	SAB_PRT,STR_PRT
	.long	SAB_PRT,ROB_PRT
	.long	SAB_PRT,WIL_PRT
	.long	SAB_PRT,CHI_PRT

	.long	WIL_PRT,STR_PRT
	.long	WIL_PRT,ROB_PRT
	.long	WIL_PRT,SAB_PRT
	.long	WIL_PRT,CHI_PRT

	.long	CHI_PRT,STR_PRT
	.long	CHI_PRT,ROB_PRT
	.long	CHI_PRT,SAB_PRT
	.long	CHI_PRT,WIL_PRT

;22 SACRAMENTO
	.long	OWE_SAC,RIC_SAC
	.long	OWE_SAC,GRA_SAC
	.long	OWE_SAC,MAR_SAC
	.long	OWE_SAC,EDN_SAC

	.long	RIC_SAC,OWE_SAC
	.long	RIC_SAC,GRA_SAC
	.long	RIC_SAC,MAR_SAC
	.long	RIC_SAC,EDN_SAC

	.long	GRA_SAC,OWE_SAC
	.long	GRA_SAC,RIC_SAC
	.long	GRA_SAC,MAR_SAC
	.long	GRA_SAC,EDN_SAC

	.long	MAR_SAC,OWE_SAC
	.long	MAR_SAC,RIC_SAC
	.long	MAR_SAC,GRA_SAC
	.long	MAR_SAC,EDN_SAC

	.long	EDN_SAC,OWE_SAC
	.long	EDN_SAC,RIC_SAC
	.long	EDN_SAC,GRA_SAC
	.long	EDN_SAC,MAR_SAC

;23 SAN ANTONIO
	.long	ELL_SAN,ROB_SAN
	.long	ELL_SAN,JON_SAN
	.long	ELL_SAN,PRS_SAN
	.long	ELL_SAN,DEL_SAN

	.long	ROB_SAN,ELL_SAN
	.long	ROB_SAN,JON_SAN
	.long	ROB_SAN,PRS_SAN
	.long	ROB_SAN,DEL_SAN

	.long	JON_SAN,ELL_SAN
	.long	JON_SAN,ROB_SAN
	.long	JON_SAN,PRS_SAN
	.long	JON_SAN,DEL_SAN

	.long	PRS_SAN,ELL_SAN
	.long	PRS_SAN,ROB_SAN
	.long	PRS_SAN,JON_SAN
	.long	PRS_SAN,DEL_SAN

	.long	DEL_SAN,ELL_SAN
	.long	DEL_SAN,ROB_SAN
	.long	DEL_SAN,JON_SAN
	.long	DEL_SAN,PRS_SAN

;24 SEATTLE
	.long	KMP_SEA,PAY_SEA
	.long	KMP_SEA,SCH_SEA
	.long	KMP_SEA,HWK_SEA
	.long	KMP_SEA,FOR_SEA

	.long	PAY_SEA,KMP_SEA
	.long	PAY_SEA,SCH_SEA
	.long	PAY_SEA,HWK_SEA
	.long	PAY_SEA,FOR_SEA

	.long	SCH_SEA,KMP_SEA
	.long	SCH_SEA,PAY_SEA
	.long	SCH_SEA,HWK_SEA
	.long	SCH_SEA,FOR_SEA

	.long	HWK_SEA,KMP_SEA
	.long	HWK_SEA,PAY_SEA
	.long	HWK_SEA,SCH_SEA
	.long	HWK_SEA,FOR_SEA

	.long	FOR_SEA,KMP_SEA
	.long	FOR_SEA,PAY_SEA
	.long	FOR_SEA,SCH_SEA
	.long	FOR_SEA,HWK_SEA

;25 TORONTO
;FIX!!!
;Put back MUR_TOR when mugshot gets done
;MUR_TOR
	.long	ROG_TOR,STO_TOR
	.long	ROG_TOR,ROB_TOR
	.long	ROG_TOR,MIL_TOR
	.long	ROG_TOR,MUR_TOR

	.long	STO_TOR,ROG_TOR
	.long	STO_TOR,ROB_TOR
	.long	STO_TOR,MIL_TOR
	.long	STO_TOR,MUR_TOR

	.long	ROB_TOR,ROG_TOR
	.long	ROB_TOR,STO_TOR
	.long	ROB_TOR,MIL_TOR
	.long	ROB_TOR,MUR_TOR

	.long	MIL_TOR,ROG_TOR
	.long	MIL_TOR,STO_TOR
	.long	MIL_TOR,ROB_TOR
	.long	MIL_TOR,MUR_TOR

	.long	MUR_TOR,ROG_TOR
	.long	MUR_TOR,STO_TOR
	.long	MUR_TOR,ROB_TOR
	.long	MUR_TOR,MIL_TOR

;26 UTAH
	.long	STK_UTA,MLN_UTA
	.long	STK_UTA,HRN_UTA
	.long	STK_UTA,BEN_UTA
	.long	STK_UTA,MOR_UTA

	.long	MLN_UTA,STK_UTA
	.long	MLN_UTA,HRN_UTA
	.long	MLN_UTA,BEN_UTA
	.long	MLN_UTA,MOR_UTA

	.long	HRN_UTA,STK_UTA
	.long	HRN_UTA,MLN_UTA
	.long	HRN_UTA,BEN_UTA
	.long	HRN_UTA,MOR_UTA

	.long	BEN_UTA,STK_UTA
	.long	BEN_UTA,MLN_UTA
	.long	BEN_UTA,HRN_UTA
	.long	BEN_UTA,MOR_UTA

	.long	MOR_UTA,STK_UTA
	.long	MOR_UTA,MLN_UTA
	.long	MOR_UTA,HRN_UTA
	.long	MOR_UTA,BEN_UTA

;27 VANCOUVER
	.long	ANT_VAN,EDW_VAN
	.long	ANT_VAN,SCO_VAN
	.long	ANT_VAN,REV_VAN
	.long	ANT_VAN,MUR_VAN

	.long	EDW_VAN,ANT_VAN
	.long	EDW_VAN,SCO_VAN
	.long	EDW_VAN,REV_VAN
	.long	EDW_VAN,MUR_VAN

	.long	SCO_VAN,ANT_VAN
	.long	SCO_VAN,EDW_VAN
	.long	SCO_VAN,REV_VAN
	.long	SCO_VAN,MUR_VAN

	.long	REV_VAN,ANT_VAN
	.long	REV_VAN,EDW_VAN
	.long	REV_VAN,SCO_VAN
	.long	REV_VAN,MUR_VAN

	.long	MUR_VAN,ANT_VAN
	.long	MUR_VAN,EDW_VAN
	.long	MUR_VAN,SCO_VAN
	.long	MUR_VAN,REV_VAN

;28 WASHINGTON
	.long	HWD_WAS,WEB_WAS
	.long	HWD_WAS,CHE_WAS
	.long	HWD_WAS,PAC_WAS
	.long	HWD_WAS,MUR_WAS

	.long	WEB_WAS,HWD_WAS
	.long	WEB_WAS,CHE_WAS
	.long	WEB_WAS,PAC_WAS
	.long	WEB_WAS,MUR_WAS

	.long	CHE_WAS,HWD_WAS
	.long	CHE_WAS,WEB_WAS
	.long	CHE_WAS,PAC_WAS
	.long	CHE_WAS,MUR_WAS

	.long	PAC_WAS,HWD_WAS
	.long	PAC_WAS,WEB_WAS
	.long	PAC_WAS,CHE_WAS
	.long	PAC_WAS,MUR_WAS

	.long	MUR_WAS,HWD_WAS
	.long	MUR_WAS,WEB_WAS
	.long	MUR_WAS,CHE_WAS
	.long	MUR_WAS,PAC_WAS


;;27 MORTAL KOMBAT
;	.long	MLN_UTA,KMP_SEA
;	.long	ROB_SAN,BRK_PHX
;	.long	DRX_PRT,HAR_ORL
;	.long	EWG_NEY,AND_NEJ
;	.long	COL_NEJ,AND_ORL
;	.long	STK_UTA,JOH_PHX
;
;	.long	GIL_SEA,RIC_SAC
;	.long	BRA_PHL,WEB_SAC
;	.long	DUM_DET,STA_NEY
;	.long	MUT_DEN,WLK_ATL
;	.long	HRP_CLP,RID_MIN
;	.long	MIL_IND,JON_CHA
;
;	.long	OLA_HOU,BAK_MLW
;	.long	ARM_CHI,MAX_HOU
;	.long	MOU_CHA,RCE_MIA
;	.long	WLS_GLD,JAC_DAL
;	.long	PIP_CHI,MIN_MIA
;	.long	THM_DET,WEB_GLD
;	.long	MAS_DAL,WOR_LAK
;	.long	MUL_GLD,MAN_CLP


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
player_names

;00 ATLANTA
	.long	AUGMON,BLAYLOCK
	.long	AUGMON,SSMITH
	.long	AUGMON,LAETTNER
	.long	AUGMON,KNORMAN

	.long	BLAYLOCK,AUGMON
	.long	BLAYLOCK,SSMITH
	.long	BLAYLOCK,LAETTNER
	.long	BLAYLOCK,KNORMAN

	.long	SSMITH,AUGMON
	.long	SSMITH,BLAYLOCK
	.long	SSMITH,LAETTNER
	.long	SSMITH,KNORMAN

	.long	LAETTNER,AUGMON
	.long	LAETTNER,BLAYLOCK
	.long	LAETTNER,SSMITH
	.long	LAETTNER,KNORMAN

	.long	KNORMAN,AUGMON
	.long	KNORMAN,BLAYLOCK
	.long	KNORMAN,SSMITH
	.long	KNORMAN,LAETTNER

;01 BOSTON
	.long	BROWN,BARROS
	.long	BROWN,MONTROSS
	.long	BROWN,RADJA
	.long	BROWN,FOX

	.long	BARROS,BROWN
	.long	BARROS,MONTROSS
	.long	BARROS,RADJA
	.long	BARROS,FOX

	.long	MONTROSS,BROWN
	.long	MONTROSS,BARROS
	.long	MONTROSS,RADJA
	.long	MONTROSS,FOX

	.long	RADJA,BROWN
	.long	RADJA,BARROS
	.long	RADJA,MONTROSS
	.long	RADJA,FOX

	.long	FOX,BROWN
	.long	FOX,BARROS
	.long	FOX,MONTROSS
	.long	FOX,RADJA


;02 CHARLOTTE
	.long	KANDERSON,JOHNSN_L
	.long	KANDERSON,RICE
	.long	KANDERSON,ZIDEK
	.long	KANDERSON,CURRY

	.long	JOHNSN_L,KANDERSON
	.long	JOHNSN_L,RICE
	.long	JOHNSN_L,ZIDEK
	.long	JOHNSN_L,CURRY

	.long	RICE,KANDERSON
	.long	RICE,JOHNSN_L
	.long	RICE,ZIDEK
	.long	RICE,CURRY

	.long	ZIDEK,KANDERSON
	.long	ZIDEK,JOHNSN_L
	.long	ZIDEK,RICE
	.long	ZIDEK,CURRY

	.long	CURRY,KANDERSON
	.long	CURRY,JOHNSN_L
	.long	CURRY,RICE
	.long	CURRY,ZIDEK



;03 CHICAGO
	.long	PIPPEN,RODMAN
	.long	PIPPEN,KUKOC
	.long	PIPPEN,LONGLEY
	.long	PIPPEN,KERR

	.long	RODMAN,PIPPEN
	.long	RODMAN,KUKOC
	.long	RODMAN,LONGLEY
	.long	RODMAN,KERR

	.long	KUKOC,PIPPEN
	.long	KUKOC,RODMAN
	.long	KUKOC,LONGLEY
	.long	KUKOC,KERR

	.long	LONGLEY,PIPPEN
	.long	LONGLEY,RODMAN
	.long	LONGLEY,KUKOC
	.long	LONGLEY,KERR

	.long	KERR,PIPPEN
	.long	KERR,RODMAN
	.long	KERR,KUKOC
	.long	KERR,LONGLEY



;04 CLEVELAND
	.long	THILL,CMILLS
	.long	THILL,PHILLS
	.long	THILL,BRANDON
	.long	THILL,FERRY

	.long	CMILLS,THILL
	.long	CMILLS,PHILLS
	.long	CMILLS,BRANDON
	.long	CMILLS,FERRY

	.long	PHILLS,THILL
	.long	PHILLS,CMILLS
	.long	PHILLS,BRANDON
	.long	PHILLS,FERRY

	.long	BRANDON,THILL
	.long	BRANDON,CMILLS
	.long	BRANDON,PHILLS
	.long	BRANDON,FERRY

	.long	FERRY,THILL
	.long	FERRY,CMILLS
	.long	FERRY,PHILLS
	.long	FERRY,BRANDON


;05 DALLAS
	.long	JACK,KIDD
	.long	JACK,MASH
	.long	JACK,PJONES
	.long	JACK,MCCLOUD

	.long	KIDD,JACK
	.long	KIDD,MASH
	.long	KIDD,PJONES
	.long	KIDD,MCCLOUD
	
	.long	MASH,JACK
	.long	MASH,KIDD
	.long	MASH,PJONES
	.long	MASH,MCCLOUD

	.long	PJONES,JACK
	.long	PJONES,KIDD
	.long	PJONES,MASH
	.long	PJONES,MCCLOUD

	.long	MCCLOUD,JACK
	.long	MCCLOUD,KIDD
	.long	MCCLOUD,MASH
	.long	MCCLOUD,PJONES


;06 DENVER
	.long	ABDULRAU,MUTUMBO
	.long	ABDULRAU,MCDYESS
	.long	ABDULRAU,ROSE
	.long	ABDULRAU,DELLIS

	.long	MUTUMBO,ABDULRAU
	.long	MUTUMBO,MCDYESS
	.long	MUTUMBO,ROSE
	.long	MUTUMBO,DELLIS

	.long	MCDYESS,ABDULRAU
	.long	MCDYESS,MUTUMBO
	.long	MCDYESS,ROSE
	.long	MCDYESS,DELLIS

	.long	ROSE,ABDULRAU
	.long	ROSE,MUTUMBO
	.long	ROSE,MCDYESS
	.long	ROSE,DELLIS

	.long	DELLIS,ABDULRAU
	.long	DELLIS,MUTUMBO
	.long	DELLIS,MCDYESS
	.long	DELLIS,ROSE

;07 DETROIT
	.long	DUMARS,GHILL
	.long	DUMARS,TMILLS
	.long	DUMARS,THORPE
	.long	DUMARS,HOUSTON

	.long	GHILL,DUMARS
	.long	GHILL,TMILLS
	.long	GHILL,THORPE
	.long	GHILL,HOUSTON

	.long	TMILLS,DUMARS
	.long	TMILLS,GHILL
	.long	TMILLS,THORPE
	.long	TMILLS,HOUSTON

	.long	THORPE,DUMARS
	.long	THORPE,GHILL
	.long	THORPE,TMILLS
	.long	THORPE,HOUSTON

	.long	HOUSTON,DUMARS
	.long	HOUSTON,GHILL
	.long	HOUSTON,TMILLS
	.long	HOUSTON,THORPE


;08 GOLDEN STATE
	.long	WILLIS,SPREWELL
	.long	WILLIS,SEIKALY
	.long	WILLIS,JSMITH
	.long	WILLIS,MULLIN

	.long	SPREWELL,WILLIS
	.long	SPREWELL,SEIKALY
	.long	SPREWELL,JSMITH
	.long	SPREWELL,MULLIN
			
	.long	SEIKALY,WILLIS
	.long	SEIKALY,SPREWELL
	.long	SEIKALY,JSMITH
	.long	SEIKALY,MULLIN
			
	.long	JSMITH,WILLIS
	.long	JSMITH,SPREWELL
	.long	JSMITH,SEIKALY
	.long	JSMITH,MULLIN
			
	.long	MULLIN,WILLIS
	.long	MULLIN,SPREWELL
	.long	MULLIN,SEIKALY
	.long	MULLIN,JSMITH
			


;09 HOUSTON
	.long	OLAJUWON,DREXLER
	.long	OLAJUWON,HORRY
	.long	OLAJUWON,CASSELL
	.long	OLAJUWON,SMITH

	.long	DREXLER,OLAJUWON
	.long	DREXLER,HORRY
	.long	DREXLER,CASSELL
	.long	DREXLER,SMITH

	.long	HORRY,OLAJUWON
	.long	HORRY,DREXLER
	.long	HORRY,CASSELL
	.long	HORRY,SMITH

	.long	CASSELL,OLAJUWON
	.long	CASSELL,DREXLER
	.long	CASSELL,HORRY
	.long	CASSELL,SMITH

	.long	SMITH,OLAJUWON
	.long	SMITH,DREXLER
	.long	SMITH,HORRY
	.long	SMITH,CASSELL

;10 INDIANA
	.long	MILLER,DDAVIS
	.long	MILLER,SMITS
	.long	MILLER,MCKEE2
	.long	MILLER,MJACKSON

	.long	DDAVIS,MILLER
	.long	DDAVIS,SMITS
	.long	DDAVIS,MCKEE2
	.long	DDAVIS,MJACKSON

	.long	SMITS,MILLER
	.long	SMITS,DDAVIS
	.long	SMITS,MCKEE2
	.long	SMITS,MJACKSON

	.long	MCKEE2,MILLER
	.long	MCKEE2,DDAVIS
	.long	MCKEE2,SMITS
	.long	MCKEE2,MJACKSON

	.long	MJACKSON,MILLER
	.long	MJACKSON,DDAVIS
	.long	MJACKSON,SMITS
	.long	MJACKSON,MCKEE2


;11 L.A. CLIPPERS
	.long	VAUGHT,RROGERS
	.long	VAUGHT,LMURRAY
	.long	VAUGHT,PRICHARD
	.long	VAUGHT,BBARRY

	.long	RROGERS,VAUGHT
	.long	RROGERS,LMURRAY
	.long	RROGERS,PRICHARD
	.long	RROGERS,BBARRY

	.long	LMURRAY,VAUGHT
	.long	LMURRAY,RROGERS
	.long	LMURRAY,PRICHARD
	.long	LMURRAY,BBARRY

	.long	PRICHARD,VAUGHT
	.long	PRICHARD,RROGERS
	.long	PRICHARD,LMURRAY
	.long	PRICHARD,BBARRY

	.long	BBARRY,VAUGHT
	.long	BBARRY,RROGERS
	.long	BBARRY,LMURRAY
	.long	BBARRY,PRICHARD

;12 L.A. LAKERS
;MJOHNSON or EJONES
	.long	VANEXEL,DIVAC
	.long	VANEXEL,CEBALLOS
	.long	VANEXEL,CAMPBELL
	.long	VANEXEL,EJONES

	.long	DIVAC,VANEXEL
	.long	DIVAC,CEBALLOS
	.long	DIVAC,CAMPBELL
	.long	DIVAC,EJONES

	.long	CEBALLOS,VANEXEL
	.long	CEBALLOS,DIVAC
	.long	CEBALLOS,CAMPBELL
	.long	CEBALLOS,EJONES

	.long	CAMPBELL,VANEXEL
	.long	CAMPBELL,DIVAC
	.long	CAMPBELL,CEBALLOS
	.long	CAMPBELL,EJONES

	.long	EJONES,VANEXEL
	.long	EJONES,DIVAC
	.long	EJONES,CEBALLOS
	.long	EJONES,CAMPBELL


;13 MIAMI
	.long	MOURN,WWILLIAM
	.long	MOURN,CHAPMAN
	.long	MOURN,THARDAWAY
	.long	MOURN,DANILOVI

	.long	WWILLIAM,MOURN
	.long	WWILLIAM,CHAPMAN
	.long	WWILLIAM,THARDAWAY
	.long	WWILLIAM,DANILOVI

	.long	CHAPMAN,MOURN
	.long	CHAPMAN,WWILLIAM
	.long	CHAPMAN,THARDAWAY
	.long	CHAPMAN,DANILOVI

	.long	THARDAWAY,MOURN
	.long	THARDAWAY,WWILLIAM
	.long	THARDAWAY,CHAPMAN
	.long	THARDAWAY,DANILOVI

	.long	DANILOVI,MOURN
	.long	DANILOVI,WWILLIAM
	.long	DANILOVI,CHAPMAN
	.long	DANILOVI,THARDAWAY


;14 MILWAUKEE
	.long	BAKER,GROBINSO
	.long	BAKER,RESPERT
	.long	BAKER,BENJAMIN
	.long	BAKER,DOUGLAS

	.long	GROBINSO,BAKER
	.long	GROBINSO,RESPERT
	.long	GROBINSO,BENJAMIN
	.long	GROBINSO,DOUGLAS

	.long	RESPERT,BAKER
	.long	RESPERT,GROBINSO
	.long	RESPERT,BENJAMIN
	.long	RESPERT,DOUGLAS

	.long	BENJAMIN,BAKER
	.long	BENJAMIN,GROBINSO
	.long	BENJAMIN,RESPERT
	.long	BENJAMIN,DOUGLAS

	.long	DOUGLAS,BAKER
	.long	DOUGLAS,GROBINSO
	.long	DOUGLAS,RESPERT
	.long	DOUGLAS,BENJAMIN


;15 MINNESOTTA
	.long	RIDER,LANG
	.long	RIDER,WEBB
	.long	RIDER,GUGLI2
	.long	RIDER,GARNETT

	.long	LANG,RIDER
	.long	LANG,WEBB
	.long	LANG,GUGLI2
	.long	LANG,GARNETT

	.long	WEBB,RIDER
	.long	WEBB,LANG
	.long	WEBB,GUGLI2
	.long	WEBB,GARNETT

	.long	GUGLI2,RIDER
	.long	GUGLI2,LANG
	.long	GUGLI2,WEBB
	.long	GUGLI2,GARNETT

	.long	GARNETT,RIDER
	.long	GARNETT,LANG
	.long	GARNETT,WEBB
	.long	GARNETT,GUGLI2


;16 NEW JERSEY
	.long	GILL,BRADLEY
	.long	GILL,GILLIAM
	.long	GILL,OBANNON
	.long	GILL,KEDWARDS

	.long	BRADLEY,GILL
	.long	BRADLEY,GILLIAM
	.long	BRADLEY,OBANNON
	.long	BRADLEY,KEDWARDS

	.long	GILLIAM,GILL
	.long	GILLIAM,BRADLEY
	.long	GILLIAM,OBANNON
	.long	GILLIAM,KEDWARDS

	.long	OBANNON,GILL
	.long	OBANNON,BRADLEY
	.long	OBANNON,GILLIAM
	.long	OBANNON,KEDWARDS

	.long	KEDWARDS,GILL
	.long	KEDWARDS,BRADLEY
	.long	KEDWARDS,GILLIAM
	.long	KEDWARDS,OBANNON


;17 NEW YORK
	.long	EWING,MASON
	.long	EWING,HARPER_D
	.long	EWING,OAKLEY
	.long	EWING,STARKS

	.long	MASON,EWING
	.long	MASON,HARPER_D
	.long	MASON,OAKLEY
	.long	MASON,STARKS

	.long	HARPER_D,EWING
	.long	HARPER_D,MASON
	.long	HARPER_D,OAKLEY
	.long	HARPER_D,STARKS

	.long	OAKLEY,EWING
	.long	OAKLEY,MASON
	.long	OAKLEY,HARPER_D
	.long	OAKLEY,STARKS

	.long	STARKS,EWING
	.long	STARKS,MASON
	.long	STARKS,HARPER_D
	.long	STARKS,OAKLEY



;18 ORLANDO
	.long	AHARDAWAY,GRANT_HC
	.long	AHARDAWAY,NANDERSON
	.long	AHARDAWAY,DSCOTT
	.long	AHARDAWAY,KONCAK

	.long	GRANT_HC,AHARDAWAY
	.long	GRANT_HC,NANDERSON
	.long	GRANT_HC,DSCOTT
	.long	GRANT_HC,KONCAK

	.long	NANDERSON,AHARDAWAY
	.long	NANDERSON,GRANT_HC
	.long	NANDERSON,DSCOTT
	.long	NANDERSON,KONCAK

	.long	DSCOTT,AHARDAWAY
	.long	DSCOTT,GRANT_HC
	.long	DSCOTT,NANDERSON
	.long	DSCOTT,KONCAK

	.long	KONCAK,AHARDAWAY
	.long	KONCAK,GRANT_HC
	.long	KONCAK,NANDERSON
	.long	KONCAK,DSCOTT

;19 PHILADELPHIA
	.long	STACKHOU,COLEMAN
	.long	STACKHOU,WEATHSPN
	.long	STACKHOU,RUFFIN
	.long	STACKHOU,VMAXWELL

	.long	COLEMAN,STACKHOU
	.long	COLEMAN,WEATHSPN
	.long	COLEMAN,RUFFIN
	.long	COLEMAN,VMAXWELL

	.long	WEATHSPN,STACKHOU
	.long	WEATHSPN,COLEMAN
	.long	WEATHSPN,RUFFIN
	.long	WEATHSPN,VMAXWELL

	.long	RUFFIN,STACKHOU
	.long	RUFFIN,COLEMAN
	.long	RUFFIN,WEATHSPN
	.long	RUFFIN,VMAXWELL

	.long	VMAXWELL,STACKHOU
	.long	VMAXWELL,COLEMAN
	.long	VMAXWELL,WEATHSPN
	.long	VMAXWELL,RUFFIN


;20 PHOENIX
	.long	KJOHNSON,TISDALE
	.long	KJOHNSON,MANNING
	.long	KJOHNSON,WPERSON
	.long	KJOHNSON,FINLEY

	.long	TISDALE,KJOHNSON
	.long	TISDALE,MANNING
	.long	TISDALE,WPERSON
	.long	TISDALE,FINLEY

	.long	MANNING,KJOHNSON
	.long	MANNING,TISDALE
	.long	MANNING,WPERSON
	.long	MANNING,FINLEY

	.long	WPERSON,KJOHNSON
	.long	WPERSON,TISDALE
	.long	WPERSON,MANNING
	.long	WPERSON,FINLEY

	.long	FINLEY,KJOHNSON
	.long	FINLEY,TISDALE
	.long	FINLEY,MANNING
	.long	FINLEY,WPERSON


;21 PORTLAND
	.long	STRICKLA,CROBINSON
	.long	STRICKLA,SABONIS
	.long	STRICKLA,BWILLIAM
	.long	STRICKLA,CHILDRES

	.long	CROBINSON,STRICKLA
	.long	CROBINSON,SABONIS
	.long	CROBINSON,BWILLIAM
	.long	CROBINSON,CHILDRES

	.long	SABONIS,STRICKLA
	.long	SABONIS,CROBINSON
	.long	SABONIS,BWILLIAM
	.long	SABONIS,CHILDRES

	.long	BWILLIAM,STRICKLA
	.long	BWILLIAM,CROBINSON
	.long	BWILLIAM,SABONIS
	.long	BWILLIAM,CHILDRES

	.long	CHILDRES,STRICKLA
	.long	CHILDRES,CROBINSON
	.long	CHILDRES,SABONIS
	.long	CHILDRES,BWILLIAM


;22 SACRAMENTO
	.long	BOWENS,RICH
	.long	BOWENS,BGRANT
	.long	BOWENS,MARCIULO
	.long	BOWENS,EDNEY

	.long	RICH,BOWENS
	.long	RICH,BGRANT
	.long	RICH,MARCIULO
	.long	RICH,EDNEY

	.long	BGRANT,BOWENS
	.long	BGRANT,RICH
	.long	BGRANT,MARCIULO
	.long	BGRANT,EDNEY

	.long	MARCIULO,BOWENS
	.long	MARCIULO,RICH
	.long	MARCIULO,BGRANT
	.long	MARCIULO,EDNEY

	.long	EDNEY,BOWENS
	.long	EDNEY,RICH
	.long	EDNEY,BGRANT
	.long	EDNEY,MARCIULO


;23 SAN ANTONIO
	.long	ELLIOT2,DROBINSON
	.long	ELLIOT2,AJOHNSON
	.long	ELLIOT2,PERSON
	.long	ELLIOT2,DELNEGRO

	.long	DROBINSON,ELLIOT2
	.long	DROBINSON,AJOHNSON
	.long	DROBINSON,PERSON
	.long	DROBINSON,DELNEGRO

	.long	AJOHNSON,ELLIOT2
	.long	AJOHNSON,DROBINSON
	.long	AJOHNSON,PERSON
	.long	AJOHNSON,DELNEGRO

	.long	PERSON,ELLIOT2
	.long	PERSON,DROBINSON
	.long	PERSON,AJOHNSON
	.long	PERSON,DELNEGRO

	.long	DELNEGRO,ELLIOT2
	.long	DELNEGRO,DROBINSON
	.long	DELNEGRO,AJOHNSON
	.long	DELNEGRO,PERSON



;24 SEATTLE
	.long	KEMP,PAYTON
	.long	KEMP,SCHREMPF
	.long	KEMP,HAWKINS
	.long	KEMP,SFORD

	.long	PAYTON,KEMP
	.long	PAYTON,SCHREMPF
	.long	PAYTON,HAWKINS
	.long	PAYTON,SFORD

	.long	SCHREMPF,KEMP
	.long	SCHREMPF,PAYTON
	.long	SCHREMPF,HAWKINS
	.long	SCHREMPF,SFORD

	.long	HAWKINS,KEMP
	.long	HAWKINS,PAYTON
	.long	HAWKINS,SCHREMPF
	.long	HAWKINS,SFORD

	.long	SFORD,KEMP
	.long	SFORD,PAYTON
	.long	SFORD,SCHREMPF
	.long	SFORD,HAWKINS


;25 TORONTO
	.long	CROGERS,STOUDAMI
	.long	CROGERS,ROBERTSON
	.long	CROGERS,OMILLER
	.long	CROGERS,TMURRAY

	.long	STOUDAMI,CROGERS
	.long	STOUDAMI,ROBERTSON
	.long	STOUDAMI,OMILLER
	.long	STOUDAMI,TMURRAY

	.long	ROBERTSON,CROGERS
	.long	ROBERTSON,STOUDAMI
	.long	ROBERTSON,OMILLER
	.long	ROBERTSON,TMURRAY

	.long	OMILLER,CROGERS
	.long	OMILLER,STOUDAMI
	.long	OMILLER,ROBERTSON
	.long	OMILLER,TMURRAY

	.long	TMURRAY,CROGERS
	.long	TMURRAY,STOUDAMI
	.long	TMURRAY,ROBERTSON
	.long	TMURRAY,OMILLER


;26 UTAH
	.long	STOCKTON,MALONE_K
	.long	STOCKTON,HORNACEK
	.long	STOCKTON,BENOIT
	.long	STOCKTON,CMORRIS

	.long	MALONE_K,STOCKTON
	.long	MALONE_K,HORNACEK
	.long	MALONE_K,BENOIT
	.long	MALONE_K,CMORRIS

	.long	HORNACEK,STOCKTON
	.long	HORNACEK,MALONE_K
	.long	HORNACEK,BENOIT
	.long	HORNACEK,CMORRIS

	.long	BENOIT,STOCKTON
	.long	BENOIT,MALONE_K
	.long	BENOIT,HORNACEK
	.long	BENOIT,CMORRIS

	.long	CMORRIS,STOCKTON
	.long	CMORRIS,MALONE_K
	.long	CMORRIS,HORNACEK
	.long	CMORRIS,BENOIT



;27 VANCOUVER
	.long	ANTHONY,EDWARDS
	.long	ANTHONY,SCOTT
	.long	ANTHONY,BREEVES
	.long	ANTHONY,EMURDOCK

	.long	EDWARDS,ANTHONY
	.long	EDWARDS,SCOTT
	.long	EDWARDS,BREEVES
	.long	EDWARDS,EMURDOCK

	.long	SCOTT,ANTHONY
	.long	SCOTT,EDWARDS
	.long	SCOTT,BREEVES
	.long	SCOTT,EMURDOCK

	.long	BREEVES,ANTHONY
	.long	BREEVES,EDWARDS
	.long	BREEVES,SCOTT
	.long	BREEVES,EMURDOCK

	.long	EMURDOCK,ANTHONY
	.long	EMURDOCK,EDWARDS
	.long	EMURDOCK,SCOTT
	.long	EMURDOCK,BREEVES


;28 WASHINGTON
	.long	JHOWARD,WEBBER
	.long	JHOWARD,CHEANEY
	.long	JHOWARD,PACK
	.long	JHOWARD,MURESAN

	.long	WEBBER,JHOWARD
	.long	WEBBER,CHEANEY
	.long	WEBBER,PACK
	.long	WEBBER,MURESAN

	.long	CHEANEY,JHOWARD
	.long	CHEANEY,WEBBER
	.long	CHEANEY,PACK
	.long	CHEANEY,MURESAN

	.long	PACK,JHOWARD
	.long	PACK,WEBBER
	.long	PACK,CHEANEY
	.long	PACK,MURESAN

	.long	MURESAN,JHOWARD
	.long	MURESAN,WEBBER
	.long	MURESAN,CHEANEY
	.long	MURESAN,PACK



;
; This table contains the MUGSHOT of the small head img. for the heads in
;  'CREATE PLAYER'  (coresponds with 'plr_heads_small' in plyr3.asm)
;
create_plr_mugshots_tbl
	.long	COW
	.long	ALIEN
	.long	PIP_CHI
	.long	CHK
	.long	KIM_MUG
	.long	FIFI_MUG
	.long	GOR
	.long	JON_CHA
	.long	MIK
	.long	LIS
	.long	BAL_MUG
	.long	OLD
	.long	JAC_MUG
	.long	CLO_MUG
	.long	MAR_MUG
	.long	HIL_DET
	.long	BER
	.long	OLA_HOU
	.long	FAT
	.long	ANG
	.long	VIK_MUG
	.long	MOU_MIA
	.long	FRA
	.long	HAR_ORL
	.long	GUIDO
	.long	GRE
	.long	PIG
	.long	KMP_SEA
	.long	CHE_MUG
	.long	MEL
	.long	WIZ
	.long	WEB_WAS
	.long	JOE
	.long	MXV_MUG
	.long	EDD_MUG
	.long	OUR_MUG
	.long	BAR_MUG
	.long	WIL_MUG
	.long	ERI_MUG
	.long	SEA_MUG
	.long	MIK_MUG
	.long	DIM_MUG

create_plr_mugshots_tbl_end
	.long	COW
	.long	ALIEN
	.long	PIP_CHI
	.long	CHK
create_plr_mugshots_tbl_end2

;-----------------------------------------------------------------------------

	.end

