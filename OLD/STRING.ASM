****************************************************************
*
* Software:	Jamie Rivett
* Initiated:	
*
* Modified:
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 10/9/92 23:07
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
	.include	"mac2.asm"
	.include	"imgtbl.glo"
	.include	"bgndtbl.glo"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"shawn.hdr"


;sounds


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

;symbols defined in this file

	.def	print_player_stats
	.def	print_teams_defeated
	.global	message_palette
	.global	mess_space_width
	.global	print_string,print_string2,print_string_C,print_string_C2
	.global	print_string_R,print_string_R2
	.global	message_ascii
	.global	mess_spacing
	.global	mess_objid
	.global	mess_cursx
	.global	mess_cursy
	.global	osgemd_ascii,sgmd8_ascii,osgmd8_ascii
	.global	lgmd_ascii,omlgmd_ascii,ogmd10_ascii
	.global	message_buffer
	.global	get_initials_string
	.global	dec_to_asc,dec_to_pct
	.global	copy_string,copy_rom_string
	.global	concat_string,concat_rom_string
	.global	print_ranking
	.global	print_message,setup_message
	.global	mess_line_spacing


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

 SUBRP	print_ranking


	movi	sgmd8_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	movi	TYPTEXT,a0
	move	a0,@mess_objid

	movk	3,a0
	move	a0,@mess_space_width	;space char width
	clr	a0
	move	a0,@mess_spacing	;spacing between chars

	movi	SGMD8YEL,a0
	move	a0,@message_palette,L



	clr	a11
#next_team
	PUSH	a11

	clr	a10			;current rank
	clr	a8			;count

	sll	5,a11			;x 32 bits
	addi	#teams,a11
	move	*a11,a0,L
	move	*a0,a2			;team1 / team2

	movi	sorted_teams,a4
	movi	teams_pop,a5
	move	*a5,a9,L		;current count
#keep_looking
	move	*a5+,a0,L
	cmp	a0,a9
	jreq	#no_change
	move	a0,a9			;new count
	move	a8,a10			;new rank
#no_change
	inc	a8
	cmpi	27,a8			;safety
	jrhs	#last
	move	*a4+,a3
	cmp	a3,a2
	jrne	#keep_looking
#last

	PULL	a11
	PUSH	a11
	sll	4,a11
	addi	#xpos,a11
	move	*a11,a0
	PUSH	a0
	move	a0,@mess_cursx		;message cursor pos X
	movi	210,a0
	move	a0,@mess_cursy		;message cursor pos Y

	sll	5,a10			;x 32 bits
	addi	#txt_table,a10
	move	*a10,a4,L
	callr	copy_rom_string		;"2nd, 3rd etc"

	movi	#str_l1,a4
	callr	concat_rom_string

	callr	print_string_C

	PULL	a0
	move	a0,@mess_cursx		;message cursor pos X
	movi	225,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_l2,a4
	callr	print_string_C2

	PULL	a11
	inc	a11
	cmpi	2,a11
	jrlo	#next_team
	rets


#teams
	.long	team1,team2
#xpos
	.word	90,306

	.even
#str_l1	.string	" MOST POPULAR TEAM",0
#str_l2	.string	"IN THIS LOCATION",0

	.even
#txt_table
	.long	#S1,#S2,#S3,#S4
	.long	#S5,#S6,#S7,#S8
	.long	#S9,#S10,#S11,#S12
	.long	#S13,#S14,#S15,#S16
	.long	#S17,#S18,#S19,#S20
	.long	#S21,#S22,#S23,#S24
	.long	#S25,#S26,#S27

	.even
#S1	.string	0
#S2	.string	"2ND",0
#S3	.string	"3RD",0
#S4	.string	"4TH",0
#S5	.string	"5TH",0
#S6	.string	"6TH",0
#S7	.string	"7TH",0
#S8	.string	"8TH",0
#S9	.string	"9TH",0
#S10	.string	"10TH",0
#S11	.string	"11TH",0
#S12	.string	"12TH",0
#S13	.string	"13TH",0
#S14	.string	"14TH",0
#S15	.string	"15TH",0
#S16	.string	"16TH",0
#S17	.string	"17TH",0
#S18	.string	"18TH",0
#S19	.string	"19TH",0
#S20	.string	"20TH",0
#S21	.string	"21ST",0
#S22	.string	"22ND",0
#S23	.string	"23RD",0
#S24	.string	"24TH",0
#S25	.string	"25TH",0
#S26	.string	"26TH",0
#S27	.string	"27TH",0
	.even

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
*
* INPUT:	a3 = * string dest
*		a4 = * initials string
*
*-----------------------------------------------------------------------------

 SUBRP	get_initials_string

	clr	a0
	move	a0,*a3,L			;null terminate

	movi	init_convert_table,a5
	move	*a4+,a0
	jrn	#no_more
	sll	4,a0
	add	a5,a0
	move	*a0,a0
	movb	a0,*a3

	move	*a4+,a0
	jrn	#no_more
	sll	4,a0
	add	a5,a0
	move	*a0,a0
	movb	a0,*a3(8h)

	move	*a4,a0
	jrn	#no_more
	sll	4,a0
	add	a5,a0
	move	*a0,a0
	movb	a0,*a3(10h)
#no_more
	rets

#*****************************************************************************
*
*
*
*-----------------------------------------------------------------------------

	.asg	225,PSTATY

	.asg	25-3,RESULTY0a		;"RANK: #XXX"

	.asg	40-3,RESULTY0b		;"RECORD:"
	.asg	50+2-3,RESULTY0c	;"N(W) - N(L)"
	.asg	60+4-3,RESULTY0d	;"PCT: .NNN"

	.asg	70+7,RESULTYw1		;"STREAK:"
	.asg	80+8,RESULTYw2		;"XX WINS"

	.asg	75+29,RESULTY0		;"LAST MATCH:"

	.asg	90+29,RESULTY1		;"(ABC & DEF)"
	.asg	100+29,RESULTY2		;"TEAM1"

	.asg	113+29,RESULTY3		;"DEFEATED" | "LOST TO"

	.asg	126+29,RESULTY4		;"TEAM2"
	.asg	136+29,RESULTY5		;"(GHI & JKL)"

	.asg	149+29,RESULTY6		;"NNN - NNN"


	.asg	160+5+32+1,RESULTY10	;"YOU HAVE"

	.asg	170+5+26,RESULTY11	;"DEFEATED NN"
	.asg	180+5+26+1,RESULTY12	;"OF THE 27"
	.asg	190+5+26+2,RESULTY13	;"NBA TEAMS"

	.asg	115-10,NOREC_Y		;"NO RECORD"


 SUBRP	print_player_stats


	move	*a13(PC_DATADDR),a6,L		;start of player data
	move	a6,@ptr_player_data,L		;start address of player data

	move	*a13(PC_OBJID),a0		;OBJ ID's created by this PROC
	ori	10h,a0
	move	a0,@mess_objid

	move	a6,a4
	addi	PR_INIT1,a4			;* src initials
	movi	message_buffer,a3		;* string dest
	callr	get_initials_string

	move	*a6(PR_WON),a0
	move	*a6(PR_LOST),a1
	add	a0,a1
	jrz	#first_game		;so don't print win-loss record

	movi	str_sp,a4
	callr	concat_rom_string

	move	*a6(PR_WON),a0
	movi	99,a1			;max value
	callr	dec_to_asc
	callr	concat_string

	movi	str_dash,a4
	callr	concat_rom_string

	move	*a6(PR_LOST),a0
	movi	99,a1			;max value
	callr	dec_to_asc
	callr	concat_string
#first_game

;;	movi	osgemd_ascii,a0
	movi	osgmd8_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	movi	SGMD8YEL,a0
	move	a0,@message_palette,L

	move	*a13(PC_CENTERX2),a0
	move	a0,@mess_cursx		;message cursor pos X
	movi	PSTATY,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movk	3,a0	;6,a0
	move	a0,@mess_space_width	;space char width
	movk	1,a0
	clr	a0
	move	a0,@mess_spacing	;spacing between chars
;;;;	callr	print_string_C		;centered

	move	*a13(PC_OBJID),a0	;OBJ ID's created by this PROC
	move	a0,@mess_objid

	move	@ptr_player_data,a2,L	;start address of player data
	move	*a2(PR_WON),a0
	move	*a2(PR_LOST),a1
	add	a0,a1
	jrnz	#has_record

	move	*a13(PC_CENTERX),a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#no_2p
	move	*a13(PC_CENTERXkit),a0
#no_2p
	move	a0,@mess_cursx		;message cursor pos X

	movi	NOREC_Y,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	str_norecord,a4		;"NO RECORD"
	callr	print_string2		;already centered

	rets



#has_record

	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	movi	str_line0a,a4
	callr	copy_rom_string
	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_RANK),a0		;rank
	cmpi	10,a0
	jrgt	#notten
	movi	SGMD8PLV,a1		;highlight cycle colour
	move	a1,@message_palette,L
#notten
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	concat_string

;Turmell
	move	*a13(PC_CENTERX),a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#no_2pb
	move	*a13(PC_CENTERXkit),a0
#no_2pb
	move	a0,@mess_cursx		;message cursor pos X

	movi	RESULTY0a,a0
	move	a0,@mess_cursy		;message cursor pos Y
	callr	print_string_C		;centered

	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	RESULTY0b,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	str_line0b,a4		;"RECORD:"
	callr	print_string_C2		;centered

	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	movi	RESULTY0c,a0
	move	a0,@mess_cursy		;message cursor pos Y
	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_WON),a0		;games won
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	copy_string
	movi	str_w,a4
	callr	concat_rom_string
	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_LOST),a0		;games lost
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	concat_string
	movi	str_l,a4
	callr	concat_rom_string
	callr	print_string_C		;centered


	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	RESULTY0d,a0
	move	a0,@mess_cursy		;message cursor pos Y
	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_LOST),a2		;games lost
	jrz	#no_losses
; % < 1000
	movi	str_line0d,a4		;"PCT: ."
	callr	copy_rom_string
	move	@ptr_player_data,a0,L	;start address of player data
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

	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_WINSTREAK),a0	;no. consecutive wins
	cmpi	3,a0
	jrlt	#no_hilght
	movi	SGMD8PLV,a1		;highlight cycle colour
	move	a1,@message_palette,L
#no_hilght

	movi	RESULTYw1,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	str_streak,a4
	callr	print_string_C2

	movi	RESULTYw2,a0
	move	a0,@mess_cursy		;message cursor pos Y
	move	@ptr_player_data,a0,L	;start address of player data
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



	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	RESULTY0,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	str_line0,a4
	callr	print_string_C2		;centered


	movi	RESULTY1,a0
	move	a0,@mess_cursy		;message cursor pos Y
	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_PTEAM),a2	;players team (last game)
	addi	90h,a2			;asc table start offset
	movb	a2,@message_buffer+00h
	clr	a2
	movb	a2,@message_buffer+08h
	callr	print_string_C


	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	RESULTY2,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	str_obr,a4		;"("
	callr	copy_rom_string
	move	@ptr_player_data,a4,L
	addi	PR_INIT1,a4		;* src initials
	movi	message_buffer2,a3	;* string dest
	callr	get_initials_string
	callr	concat_string
	movi	str_and,a4		;" & "
	callr	concat_rom_string
	move	@ptr_player_data,a4,L
	addi	PR_TMATEINIT1,a4	;* src initials
	movi	message_buffer2,a3	;* string dest
	callr	get_initials_string
	callr	concat_string
	movi	str_cbr,a4		;")"
	callr	concat_rom_string
	callr	print_string_C		;centered


	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	movi	RESULTY3,a0
	move	a0,@mess_cursy		;message cursor pos Y
	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_PSCORE),a1	;players score
	move	*a0(PR_OSCORE),a2	;opponents score
	movi	str_line3w,a4
	cmp	a2,a1			;pscore - oscore
	jrge	#won
	movi	str_line3l,a4		;lost
#won	callr	print_string_C2		;centered

	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	RESULTY4,a0
	move	a0,@mess_cursy		;message cursor pos Y
	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_OTEAM),a2	;opponents team (last game)
	addi	90h,a2			;asc table start offset
	movb	a2,@message_buffer+00h
	clr	a2
	movb	a2,@message_buffer+08h
	callr	print_string_C

	movi	SGMD8PLY,a0
	move	a0,@message_palette,L


	movi	RESULTY5,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	str_obr,a4		;"("
	callr	copy_rom_string
	move	@ptr_player_data,a4,L
	addi	PR_OP1INIT1,a4		;* src initials
	movi	message_buffer2,a3	;* string dest
	callr	get_initials_string
	callr	concat_string
	movi	str_and,a4		;" & "
	callr	concat_rom_string
	move	@ptr_player_data,a4,L
	addi	PR_OP2INIT1,a4		;* src initials
	movi	message_buffer2,a3	;* string dest
	callr	get_initials_string
	callr	concat_string
	movi	str_cbr,a4		;")"
	callr	concat_rom_string
	callr	print_string_C		;centered

	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	RESULTY6,a0
	move	a0,@mess_cursy		;message cursor pos Y
	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_PSCORE),a0	;players score
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	copy_string
	movi	str_dash2,a4
	callr	concat_rom_string
	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_OSCORE),a0	;opponents score
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	concat_string
	callr	print_string_C		;centered

	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	move	*a13(PC_CENTERX2),a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#no_2pc
	move	*a13(PC_CENTERXkit),a0
#no_2pc
	move	a0,@mess_cursx

	movi	str_line11,a4		"DEFEATED NN"
	callr	copy_rom_string

	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_NUMDEF),a0	;number teams defeated
	cmpi	27,a0
	jrlo	#not_all

	movi	str_all,a4		" ALL"
	callr	concat_rom_string
	jruc	#skipit
#not_all
	movi	27,a1			;max value

	callr	dec_to_asc
	callr	concat_string
#skipit
	movi	RESULTY11,a0
	move	a0,@mess_cursy		;message cursor pos Y
	callr	print_string_C		;centered

	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	RESULTY12,a0		;"OF THE 27"
	move	a0,@mess_cursy		;message cursor pos Y
	movi	str_line12,a4
	callr	print_string_C2		;centered

	movi	RESULTY13,a0		;"NBA TEAMS"
	move	a0,@mess_cursy		;message cursor pos Y
	movi	str_line13,a4
	callr	print_string_C2		;centered

	rets

#*****************************************************************************
*
*
*-----------------------------------------------------------------------------

 SUBRP	print_teams_defeated

	.asg	8,HEADY
	.asg	36,TEAMY

	move	*a13(PC_DATADDR),a6,L		;start of player data
	move	a6,@ptr_player_data,L		;start address of player data

	move	*a13(PC_OBJID),a0		;OBJ ID's created by this PROC
	move	a0,@mess_objid

;	movi	sgmd8_ascii,a0
	movi	osgmd8_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	movk	3,a0
	move	a0,@mess_space_width	;space char width
	clr	a0
	move	a0,@mess_spacing	;spacing between chars

	movi	SGMD8YEL,a0
	move	a0,@message_palette,L

	move	*a13(PC_CENTERX),a0	;
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#no_2p
	move	*a13(PC_CENTERXkit),a0
#no_2p
	move	a0,@mess_cursx		;message cursor pos X

	movi	HEADY+10,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_def,a4
	callr	print_string_C2

	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_NUMDEF),a0	;number teams defeated
	cmpi	13,a0			;defeated more than 13 teams?
	jrhi	#disp_undef

;disp defeated teams

	movi	HEADY,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_uhav,a4
	callr	print_string_C2

	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	movi	TEAMY,a0
	move	a0,@mess_cursy		;message cursor pos Y

	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_TEAMSDEF),a1,L

	movk	27,a2
#next_team
	srl	1,a1
	jrnc	#not_def
	PUSH	a1,a2
	movi	27,a0
	sub	a2,a0			;0-26
	addi	90h,a0			;asc table cities start offset
	movb	a0,@message_buffer+00h
	clr	a0
	movb	a0,@message_buffer+08h
	callr	print_string_C
	move	@mess_cursy,a0
	addk	12,a0
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

	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	movi	TEAMY,a0
	move	a0,@mess_cursy		;message cursor pos Y

	move	@ptr_player_data,a0,L	;start address of player data
	move	*a0(PR_TEAMSDEF),a1,L

	movk	27,a2
#next_team2
	srl	1,a1
	jrc	#def
	PUSH	a1,a2
	movi	27,a0
	sub	a2,a0			;0-26
	addi	90h,a0			;asc table cities start offset
	movb	a0,@message_buffer+00h
	clr	a0
	movb	a0,@message_buffer+08h
	callr	print_string_C
	move	@mess_cursy,a0
	addk	12,a0
	move	a0,@mess_cursy		;message cursor pos Y
	PULL	a1,a2
#def
	dsj	a2,#next_team2

	rets


#str_uhav	.string	"YOU HAVE",0
#str_uhavnt	.string	"YOU HAVE NOT",0
#str_def	.string	"DEFEATED:",0
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
*
* concatenates string in message_buffer2 to string in message_buffer
*
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
*
* INPUT:	a4 = * null terminated rom string
*
* concatenates string in rom to string in message_buffer
*
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
;	movi	120,a3			;z pos
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
* INPUT	:	a2 = * to message
*
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
*
* INPUT	:	a2 = * to message
*
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

init_convert_table
	.word	'A','B','C','D','E','F','G','H'
	.word	'I','J','K','L','M','N','O','P'
	.word	'Q','R','S','T','U','V','W','X'
	.word	'Y','Z',' '

#*****************************************************************************

osgemd_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,OSGEMD_EXP,0,OSGEMD_NUM,OSGEMD_DOL,0,OSGEMD_AND,OSGEMD_APO		;$20	SP! " # $ % & '
; .long OSGEMD_OBR,OSGEMD_CBR,0,0,0,OSGEMD_DAS,OSGEMD_DOT,OSGEMD_SLS		;$28	( ) * + , - . /
 .long OSGEMD_OBR,OSGEMD_CBR,0,0,OSGEMD_COM,OSGEMD_DAS,OSGEMD_DOT,OSGEMD_SLS		;$28	( ) * + , - . /
 .long OSGEMD_0,OSGEMD_1,OSGEMD_2,OSGEMD_3,OSGEMD_4,OSGEMD_5,OSGEMD_6,OSGEMD_7	;$30	0 1 2 3 4 5 6 7
 .long OSGEMD_8,OSGEMD_9,OSGEMD_COL,0,0,0,0,OSGEMD_QUE				;$38	8 9 : ; < - > ?
 .long 0,OSGEMD_A,OSGEMD_B,OSGEMD_C,OSGEMD_D,OSGEMD_E,OSGEMD_F,OSGEMD_G		;$40	@ A B C D E F G
 .long OSGEMD_H,OSGEMD_I,OSGEMD_J,OSGEMD_K,OSGEMD_L,OSGEMD_M,OSGEMD_N,OSGEMD_O	;$48	H I J K L M N O
 .long OSGEMD_P,OSGEMD_Q,OSGEMD_R,OSGEMD_S,OSGEMD_T,OSGEMD_U,OSGEMD_V,OSGEMD_W	;$50	P Q R S T U V W
 .long OSGEMD_X,OSGEMD_Y,OSGEMD_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,OSGEMD_A,OSGEMD_B,OSGEMD_C,OSGEMD_D,OSGEMD_E,OSGEMD_F,OSGEMD_G		;$60	` a b c d e f g
 .long OSGEMD_H,OSGEMD_I,OSGEMD_J,OSGEMD_K,OSGEMD_L,OSGEMD_M,OSGEMD_N,OSGEMD_O	;$68	h i j k l m n o
 .long OSGEMD_P,OSGEMD_Q,OSGEMD_R,OSGEMD_S,OSGEMD_T,OSGEMD_U,OSGEMD_V,OSGEMD_W	;$70	p q r s t u v w
 .long OSGEMD_X,OSGEMD_Y,OSGEMD_Z,0,0,0,0,0					;$78	x y z { | } ~

sgmd8_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long stx_fgs,stx_3pts,stx_atline,stx_points,stx_dunks,stx_ast,stx_steals,stx_blocks	;$08
; .long stx_rebs,0,0,0,0,0,0,0							;$10
 .long stx_rebs,stx_injury,0,0,0,0,0,0							;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,SGMD8_EXP,0,SGMD8_NUM,0,SGMD8_PCT,SGMD8_AND,SGMD8_APO			;$20	SP! " # $ % & '
 .long SGMD8_OBR,SGMD8_CBR,0,0,SGMD8_COM,SGMD8_DAS,SGMD8_DOT,SGMD8_SLS		;$28	( ) * + , - . /
 .long SGMD8_0,SGMD8_1,SGMD8_2,SGMD8_3,SGMD8_4,SGMD8_5,SGMD8_6,SGMD8_7		;$30	0 1 2 3 4 5 6 7
 .long SGMD8_8,SGMD8_9,SGMD8_COL,0,0,0,0,0					;$38	8 9 : ; < - > ?
 .long 0,SGMD8_A,SGMD8_B,SGMD8_C,SGMD8_D,SGMD8_E,SGMD8_F,SGMD8_G		;$40	@ A B C D E F G
 .long SGMD8_H,SGMD8_I,SGMD8_J,SGMD8_K,SGMD8_L,SGMD8_M,SGMD8_N,SGMD8_O		;$48	H I J K L M N O
 .long SGMD8_P,SGMD8_Q,SGMD8_R,SGMD8_S,SGMD8_T,SGMD8_U,SGMD8_V,SGMD8_W		;$50	P Q R S T U V W
 .long SGMD8_X,SGMD8_Y,SGMD8_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,SGMD8_A,SGMD8_B,SGMD8_C,SGMD8_D,SGMD8_E,SGMD8_F,SGMD8_G		;$60	` a b c d e f g
 .long SGMD8_H,SGMD8_I,SGMD8_J,SGMD8_K,SGMD8_L,SGMD8_M,SGMD8_N,SGMD8_O		;$68	h i j k l m n o
 .long SGMD8_P,SGMD8_Q,SGMD8_R,SGMD8_S,SGMD8_T,SGMD8_U,SGMD8_V,SGMD8_W		;$70	p q r s t u v w
 .long SGMD8_X,SGMD8_Y,SGMD8_Z,0,0,0,0,0					;$78	x y z { | } ~
 .long stx_rank,stx_record,stx_norecord,stx_pct,stx_lastmtch,stx_defeated,stx_lostto,stx_youhave	;$80
 .long stx_ofthe27,stx_nbateams,stx_w,stx_l,stx_all,0,0,0			;$88
 .long	C_ATL		;ATLANTA	$90
 .long	C_BOST		;BOSTON
 .long	C_CHAR		;CHARLOTTE
 .long	C_CHIC		;CHICAGO
 .long	C_CLEV		;CLEVELAND
 .long	C_DAL		;DALLAS
 .long	C_DEN		;DENVER
 .long	C_DET		;DETROIT
 .long	C_GOLD		;GOLDEN STATE
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
 .long	C_UTAH		;UTAH
 .long	C_WASH		;WASHINGTON


osgmd8_ascii
 .long 0,0,0,0,0,0,0,0									;$00
 .long stx_fgs,stx_3pts,stx_atline,stx_points,stx_dunks,stx_ast,stx_steals,stx_blocks	;$08
 .long stx_rebs,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0									;$18
 .long 0,osgmd8_EXP,0,osgmd8_NUM,0,osgmd8_PCT,osgmd8_AND,osgmd8_APO			;$20	SP! " # $ % & '
 .long osgmd8_OBR,osgmd8_CBR,0,0,osgmd8_COM,osgmd8_DAS,osgmd8_DOT,osgmd8_SLS		;$28	( ) * + , - . /
 .long osgmd8_0,osgmd8_1,osgmd8_2,osgmd8_3,osgmd8_4,osgmd8_5,osgmd8_6,osgmd8_7		;$30	0 1 2 3 4 5 6 7
 .long osgmd8_8,osgmd8_9,osgmd8_COL,0,0,0,0,0						;$38	8 9 : ; < - > ?
 .long 0,osgmd8_A,osgmd8_B,osgmd8_C,osgmd8_D,osgmd8_E,osgmd8_F,osgmd8_G			;$40	@ A B C D E F G
 .long osgmd8_H,osgmd8_I,osgmd8_J,osgmd8_K,osgmd8_L,osgmd8_M,osgmd8_N,osgmd8_O		;$48	H I J K L M N O
 .long osgmd8_P,osgmd8_Q,osgmd8_R,osgmd8_S,osgmd8_T,osgmd8_U,osgmd8_V,osgmd8_W		;$50	P Q R S T U V W
 .long osgmd8_X,osgmd8_Y,osgmd8_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,osgmd8_A,osgmd8_B,osgmd8_C,osgmd8_D,osgmd8_E,osgmd8_F,osgmd8_G			;$60	` a b c d e f g
 .long osgmd8_H,osgmd8_I,osgmd8_J,osgmd8_K,osgmd8_L,osgmd8_M,osgmd8_N,osgmd8_O		;$68	h i j k l m n o
 .long osgmd8_P,osgmd8_Q,osgmd8_R,osgmd8_S,osgmd8_T,osgmd8_U,osgmd8_V,osgmd8_W		;$70	p q r s t u v w
 .long osgmd8_X,osgmd8_Y,osgmd8_Z,0,0,0,0,0						;$78	x y z { | } ~
 .long stx_rank,stx_record,stx_norecord,stx_pct,stx_lastmtch,stx_defeated,stx_lostto,stx_youhave	;$80
 .long stx_ofthe27,stx_nbateams,stx_w,stx_l,stx_all,0,0,0				;$88
 .long	C_ATL_O		;ATLANTA	$90
 .long	C_BOST_O	;BOSTON
 .long	C_CHAR_O	;CHARLOTTE
 .long	C_CHIC_O	;CHICAGO
 .long	C_CLEV_O	;CLEVELAND
 .long	C_DAL_O		;DALLAS
 .long	C_DEN_O		;DENVER
 .long	C_DET_O		;DETROIT
 .long	C_GOLD_O	;GOLDEN STATE
 .long	C_HOU_O		;HOUSTON
 .long	C_IND_O		;INDIANA
 .long	C_LAClips_O	;LOS ANGELES (CLIPPERS)
 .long	C_LALaks_O	;LOS ANGELES (LAKERS)
 .long	C_MIAMI_O	;MIAMI
 .long	C_MILW_O	;MILWAUKEE
 .long	C_MINN_O	;MINNESOTA
 .long	C_NJ_O		;NEW JERSEY
 .long	C_NY_O		;NEW YORK
 .long	C_ORL_O		;ORLANDO
 .long	C_PHIL_O	;PHILADELPHIA
 .long	C_PHX_O		;PHOENIX
 .long	C_PORT_O	;PORTLAND
 .long	C_SAC_O		;SACRAMENTO
 .long	C_SAN_O		;SAN ANTONIO
 .long	C_SEA_O		;SEATTLE
 .long	C_UTAH_O	;UTAH
 .long	C_WASH_O	;WASHINGTON



lgmd_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18
 .long 0,lgmd_EXP,0,lgmd_NUM,0,0,0,0						;$20	SP! " # $ % & '
 .long 0,0,0,0,0,0,lgmd_DOT,0							;$28	( ) * + , - . /
 .long lgmd_0,lgmd_1,lgmd_2,lgmd_3,lgmd_4,lgmd_5,lgmd_6,lgmd_7			;$30	0 1 2 3 4 5 6 7
 .long lgmd_8,lgmd_9,lgmd_COL,0,0,0,0,0						;$38	8 9 : ; < - > ?
 .long 0,lgmd_A,lgmd_B,lgmd_C,lgmd_D,lgmd_E,lgmd_F,lgmd_G			;$40	@ A B C D E F G
 .long lgmd_H,lgmd_I,lgmd_J,lgmd_K,lgmd_L,lgmd_M,lgmd_N,lgmd_O			;$48	H I J K L M N O
 .long lgmd_P,lgmd_Q,lgmd_R,lgmd_S,lgmd_T,lgmd_U,lgmd_V,lgmd_W			;$50	P Q R S T U V W
 .long lgmd_X,lgmd_Y,lgmd_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,lgmd_A,lgmd_B,lgmd_C,lgmd_D,lgmd_E,lgmd_F,lgmd_G			;$60	` a b c d e f g
 .long lgmd_H,lgmd_I,lgmd_J,lgmd_K,lgmd_L,lgmd_M,lgmd_N,lgmd_O			;$68	h i j k l m n o
 .long lgmd_P,lgmd_Q,lgmd_R,lgmd_S,lgmd_T,lgmd_U,lgmd_V,lgmd_W			;$70	p q r s t u v w
 .long lgmd_X,lgmd_Y,lgmd_Z,0,0,0,0,0						;$78	x y z { | } ~

omlgmd_ascii
 .long 0,0,0,0,0,0,0,0								;$00
 .long 0,0,0,0,0,0,0,0								;$08
 .long 0,0,0,0,0,0,0,0								;$10
 .long 0,0,0,0,0,0,0,0								;$18

;Turmell
 .long 0,omlgmd_EXP,0,0,0,0,0,0								;$20	SP! " # $ % & '
 .long 0,0,0,0,0,0,omlgmd_DOT,0								;$28	( ) * + , - . /

 .long 0,0,0,0,0,0,0,0								;$30	0 1 2 3 4 5 6 7
 .long 0,0,0,0,0,0,0,0								;$38	8 9 : ; < - > ?
 .long 0,omlgmd_A,omlgmd_B,omlgmd_C,omlgmd_D,omlgmd_E,omlgmd_F,omlgmd_G		;$40	@ A B C D E F G
 .long omlgmd_H,omlgmd_I,omlgmd_J,omlgmd_K,omlgmd_L,omlgmd_M,omlgmd_N,omlgmd_O	;$48	H I J K L M N O
 .long omlgmd_P,omlgmd_Q,omlgmd_R,omlgmd_S,omlgmd_T,omlgmd_U,omlgmd_V,omlgmd_W	;$50	P Q R S T U V W
 .long omlgmd_X,omlgmd_Y,omlgmd_Z,0,0,0,0,0					;$58	X Y Z [ \ ] ^ _
 .long 0,omlgmd_A,omlgmd_B,omlgmd_C,omlgmd_D,omlgmd_E,omlgmd_F,omlgmd_G		;$60	` a b c d e f g
 .long omlgmd_H,omlgmd_I,omlgmd_J,omlgmd_K,omlgmd_L,omlgmd_M,omlgmd_N,omlgmd_O	;$68	h i j k l m n o
 .long omlgmd_P,omlgmd_Q,omlgmd_R,omlgmd_S,omlgmd_T,omlgmd_U,omlgmd_V,omlgmd_W	;$70	p q r s t u v w
 .long omlgmd_X,omlgmd_Y,omlgmd_Z,0,0,0,0,0					;$78	x y z { | } ~

ogmd10_ascii
 .long 0,0,0,0,0,0,0,0									;$00
 .long 0,0,0,0,0,0,0,0									;$08
 .long 0,0,0,0,0,0,0,0									;$10
 .long 0,0,0,0,0,0,0,0									;$18
 .long 0,osgmd10_EXP,0,osgmd10_NUM,osgmd10_DOL,osgmd10_PCT,osgmd10_AND,osgmd10_APO	;$20	SP! " # $ % & '
 .long osgmd10_OBR,osgmd10_CBR,0,0,osgmd10_COM,osgmd10_DAS,osgmd10_DOT,osgmd10_SLS	;$28	( ) * + , - . /
 .long osgmd10_0,osgmd10_1,osgmd10_2,osgmd10_3,osgmd10_4,osgmd10_5,osgmd10_6,osgmd10_7	;$30	0 1 2 3 4 5 6 7
 .long osgmd10_8,osgmd10_9,osgmd10_COL,0,0,0,0,0					;$38	8 9 : ; < - > ?
 .long 0,osgmd10_A,osgmd10_B,osgmd10_C,osgmd10_D,osgmd10_E,osgmd10_F,osgmd10_G		;$40	@ A B C D E F G
 .long osgmd10_H,osgmd10_I,osgmd10_J,osgmd10_K,osgmd10_L,osgmd10_M,osgmd10_N,osgmd10_O	;$48	H I J K L M N O
 .long osgmd10_P,osgmd10_Q,osgmd10_R,osgmd10_S,osgmd10_T,osgmd10_U,osgmd10_V,osgmd10_W	;$50	P Q R S T U V W
 .long osgmd10_X,osgmd10_Y,osgmd10_Z,0,0,0,0,0						;$58	X Y Z [ \ ] ^ _
 .long 0,osgmd10_A,osgmd10_B,osgmd10_C,osgmd10_D,osgmd10_E,osgmd10_F,osgmd10_G		;$60	` a b c d e f g
 .long osgmd10_H,osgmd10_I,osgmd10_J,osgmd10_K,osgmd10_L,osgmd10_M,osgmd10_N,osgmd10_O	;$68	h i j k l m n o
 .long osgmd10_P,osgmd10_Q,osgmd10_R,osgmd10_S,osgmd10_T,osgmd10_U,osgmd10_V,osgmd10_W	;$70	p q r s t u v w
 .long osgmd10_X,osgmd10_Y,osgmd10_Z,0,0,0,0,0						;$78	x y z { | } ~

******************************************************************************
* strings

str_dash	.string	"-",0
str_dash2	.string	" - ",0
str_sp		.string	" ",0
str_2sp		.string	"  ",0
str_3sp		.string	"   ",0
str_and		.string	" & ",0
str_obr		.string "(",0
str_cbr		.string ")",0
str_w		.string 8ah," - ",0	;" (W) - "
str_l		.string	8bh,0		;"(L)"
str_all		.string	" ",8ch,0	;" ALL"
str_norecord	.string 82h,0		;"NO RECORD"
str_line0a	.string	80h,0		;"RANK #"
str_line0b	.string	81h,0		;"RECORD: "
str_line0c	.string	82h,' ',0	;"LOSSES: "
str_line0d	.string	83h,"  .",0	;"PCT: ."
str_line0d1	.string	83h,"  1.000",0	;"PCT: 1.000"

str_streak	.string	"STREAK:",0
str_win		.string	" WIN",0
str_wins	.string	" WINS",0
str_none	.string	"NONE",0

str_line0	.string 84h,0		;"LAST MATCH:"
str_line1	.string "C",0
str_line2	.string "(ABC & DEF)",0
str_line3w	.string 85h,' ',0	;"DEFEATED"
str_line3l	.string	86h,' ',0	;"LOST TO"
str_line4	.string "D",0
str_line5	.string "(GHI & IJK)",0
str_line6	.string	"112 - 109",0

str_line10	.string	87h,0		;"YOU HAVE"
str_line11	.string 85h,' ',0	;"DEFEATED XX"
str_line12	.string	88h,0		;"OF THE 27"
str_line13	.string	89h,0		;"NBA TEAMS"

******************************************************************************
;end

