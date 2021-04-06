******************************************************************************
*
* Software:	Jamie Rivett
* Initiated:	9-27-92
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/5/92 19:34
******************************************************************************

	.file	"record.asm"
	.title	"CMOS records etc"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"mac2.asm"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"link.equ"
	.include	"shawn.hdr"
	.include	"imgtbl.glo"
	.include	"bgndtbl.glo"

******************************************************************************

	.global	sort_wins
	.global	save_player_records

	.global	get_player_record
	.global	find_record
	.global	player1_data,player2_data,player3_data,player4_data
	.global	show_player_records
	.global	clear_player_records

	.global	message_palette
	.global	mess_space_width
	.global	print_string,print_string2
	.global	print_string_C,print_string_C2
	.global	message_ascii
	.global	mess_spacing
	.global	mess_objid
	.global	mess_cursx,mess_cursy
	.global	lgmd_ascii,osgemd_ascii,sgmd8_ascii
	.global	setup_message
	.global	message_buffer
	.global	get_initials_string
	.global	dec_to_asc,dec_to_pct
	.global	copy_string,copy_rom_string
	.global	concat_string,concat_rom_string
	.global	print_string_R,print_string_R2

******************************************************************************

	.ref	pal_getf
	.ref	morf_pal
	.ref	morfpal1,morfpal2
	.ref	morfpal3,morfpal4
	.ref	morfpal5,morfpal6
	.ref	morfpal7,morfpal8
	.ref	morfpal9,morfpal10
	.ref	morfpal11

	.ref	CYCLE_TABLE

	.ref	get_teams_pop,sorted_teams
	.ref	BAKMODS
	.ref	BGND_UD1
	.ref	SET_PAGE
	.ref	WC_BYTE,RC_BYTE
	.ref	WC_BYTEI,RC_BYTEI
	.ref	WC_WORD,RC_WORD
	.ref	WC_WORDI,RC_WORD
	.ref	WC_LONG,RC_LONG
	.ref	WC_LONGI,RC_LONG

	.ref	dpageflip
	.ref	IRQSKYE
	.ref	KILBGND
	.ref	get_all_buttons_cur
	.ref	get_all_buttons_cur2

	.ref	get_all_sticks_down2
	.ref	get_all_buttons_cur2

	.ref	WIPEOUT
	.ref	CLR_SCRN
	.ref	COLRTEMP
	.ref	obj_del1c
	.ref	get_all_sticks_down
	.ref	get_all_sticks_cur,get_all_sticks_cur2

	.ref	team1,team2
	.ref	PSTATUS,PSTATUS2
	.ref	scores

******************************************************************************

 .if 0

PR_COUNT	equ	0
PR_WON		equ	PR_COUNT+16
PR_LOST		equ	PR_WON+16
PR_LASTPLAY	equ	PR_LOST+16
PR_INIT1	equ	PR_LASTPLAY+16
PR_INIT2	equ	PR_INIT1+16
PR_INIT3	equ	PR_INIT2+16
PR_MONTH	equ	PR_INIT3+16
PR_DAY		equ	PR_MONTH+16
PR_TMATEINIT1	equ	PR_DAY+16
PR_TMATEINIT2	equ	PR_TMATEINIT1+16
PR_TMATEINIT3	equ	PR_TMATEINIT2+16
PR_OP1INIT1	equ	PR_TMATEINIT3+16
PR_OP1INIT2	equ	PR_OP1INIT1+16
PR_OP1INIT3	equ	PR_OP1INIT2+16
PR_OP2INIT1	equ	PR_OP1INIT3+16
PR_OP2INIT2	equ	PR_OP2INIT1+16
PR_OP2INIT3	equ	PR_OP2INIT2+16
PR_PTEAM	equ	PR_OP2INIT3+16
PR_OTEAM	equ	PR_PTEAM+16
PR_OSCORE	equ	PR_OTEAM+16
PR_PSCORE	equ	PR_OSCORE+16
PR_TEAMSDEF	equ	PR_PSCORE+16
PR_NUMDEF	equ	PR_TEAMSDEF+32
PR_NUMDEFOLD	equ	PR_NUMDEF+16
PR_WINSTREAK	equ	PR_NUMDEFOLD+16
PR_RANK		equ	PR_WINSTREAK+16
PR_CHECKSUM	equ	PR_RANK+16
PR_SIZE		equ	PR_CHECKSUM+16


PKDPR_COUNT	equ	0			;11 bits
PKDPR_WON	equ	PKDPR_COUNT+11		;11 bits

PKDPR_LASTPLAY	equ	PKDPR_WON+11		;11 bits
PKDPR_INIT1	equ	PKDPR_LASTPLAY+11	; 5 bits

PKDPR_INIT2	equ	PKDPR_INIT1+5		; 5 bits
PKDPR_INIT3	equ	PKDPR_INIT2+5		; 5 bits
PKDPR_MONTH	equ	PKDPR_INIT3+5		; 4 bits
PKDPR_DAY	equ	PKDPR_MONTH+4		; 5 bits
PKDPR_TMATEINIT1 equ	PKDPR_DAY+5		; 5 bits
PKDPR_TMATEINIT2 equ	PKDPR_TMATEINIT1+5	; 5 bits
PKDPR_TMATEINIT3 equ	PKDPR_TMATEINIT2+5	; 5 bits
PKDPR_OP1INIT1	equ	PKDPR_TMATEINIT3+5	; 5 bits
PKDPR_OP1INIT2	equ	PKDPR_OP1INIT1+5	; 5 bits
PKDPR_OP1INIT3	equ	PKDPR_OP1INIT2+5	; 5 bits
PKDPR_OP2INIT1	equ	PKDPR_OP1INIT3+5	; 5 bits
PKDPR_OP2INIT2	equ	PKDPR_OP2INIT1+5	; 5 bits
PKDPR_OP2INIT3	equ	PKDPR_OP2INIT2+5	; 5 bits
PKDPR_PTEAM	equ	PKDPR_OP2INIT3+5	; 5 bits
PKDPR_OTEAM	equ	PKDPR_PTEAM+5		; 5 bits
PKDPR_OSCORE	equ	PKDPR_OTEAM+5		; 8 bits
PKDPR_PSCORE	equ	PKDPR_OSCORE+8		; 8 bits
PKDPR_TEAMSDEF	equ	PKDPR_PSCORE+8		;27 bits

PKDPR_WINSTREAK	equ	PKDPR_TEAMSDEF+27	; 6 bits
PKDPR_CHECKSUM	equ	PKDPR_WINSTREAK+6	; 8 bits  (168 bits total)

PKDPR_SIZE	equ	((PKDPR_CHECKSUM+8+7)/8)*8 ;must be on byte boundary

RS_RECORD_NUM	equ	0
RS_GAMES_PLAYED	equ	RS_RECORD_NUM+10h
RS_WINS		equ	RS_GAMES_PLAYED+10h
RS_AVERAGE	equ	RS_WINS+10h
RS_TEAMSDEF	equ	RS_AVERAGE+10h
RS_STREAK	equ	RS_TEAMSDEF+10h
RS_SIZE		equ	RS_STREAK+10h

 .endif

_27BITS		equ	7ffffffh
_11BITS		equ	011111111111b
_10BITS		equ	01111111111b
_8BITS		equ	011111111b
_6BITS		equ	0111111b
_5BITS		equ	011111b
_4BITS		equ	01111b

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

	.bss	player1_data,	PR_SIZE
	.bss	player2_data,	PR_SIZE
	.bss	player3_data,	PR_SIZE
	.bss	player4_data,	PR_SIZE
	.bss	temp_record,	PR_SIZE
	.bss	packed_record,	((PKDPR_SIZE+15)/16)*16+32
				;word align & pad 32 bits at end

	.bss	player_stats,	PS_SIZE*10h*4
	.global	player_stats


	.bss	record_sort_ptrs,	32*NUM_PRECORDS

record_sort_ram	equ	SCRATCH+8*256*1024


	.bss	hiscore_type,	16
	.global	hiscore_type
	.text

bounce_snd	.word	>fc80,10,>8129,0	;Ball bounce

#******************************************************************************

 SUBRP	save_player_records

	move	@team1,a0
	move	a0,@player1_data+PR_PTEAM
	move	a0,@player2_data+PR_PTEAM
	move	a0,@player3_data+PR_OTEAM
	move	a0,@player4_data+PR_OTEAM

	move	@team2,a0
	move	a0,@player1_data+PR_OTEAM
	move	a0,@player2_data+PR_OTEAM
	move	a0,@player3_data+PR_PTEAM
	move	a0,@player4_data+PR_PTEAM

	movi	player1_data,a4		;fill player 1's initials
	movi	player2_data,a5
	movi	player3_data,a6
	movi	player4_data,a7
	callr	copy_inits

	movi	player2_data,a4		;fill player 2's initials
	movi	player1_data,a5
	movi	player3_data,a6
	movi	player4_data,a7
	callr	copy_inits

	movi	player3_data,a4		;fill player 3's initials
	movi	player4_data,a5
	movi	player1_data,a6
	movi	player2_data,a7
	callr	copy_inits

	movi	player4_data,a4		;fill player 4's initials
	movi	player3_data,a5
	movi	player1_data,a6
	movi	player2_data,a7
	callr	copy_inits

	move	@scores,a0
	move	@scores+10h,a1

	move	a0,@player1_data+PR_PSCORE
	move	a1,@player1_data+PR_OSCORE
	move	a0,@player2_data+PR_PSCORE
	move	a1,@player2_data+PR_OSCORE

	move	a1,@player3_data+PR_PSCORE
	move	a0,@player3_data+PR_OSCORE
	move	a1,@player4_data+PR_PSCORE
	move	a0,@player4_data+PR_OSCORE

	cmp	a0,a1
	jrgt	#t2_wins
;#t1_wins
	move	@player1_data+PR_WON,a0
	inc	a0
	move	a0,@player1_data+PR_WON
	move	@player1_data+PR_WINSTREAK,a0
	inc	a0
	andi	_6BITS,a0
	jrz	#no_wrap1
	move	a0,@player1_data+PR_WINSTREAK
#no_wrap1

	move	@player2_data+PR_WON,a0
	inc	a0
	move	a0,@player2_data+PR_WON
	move	@player2_data+PR_WINSTREAK,a0
	inc	a0
	andi	_6BITS,a0
	jrz	#no_wrap2
	move	a0,@player2_data+PR_WINSTREAK
#no_wrap2

	clr	a0
	move	a0,@player3_data+PR_WINSTREAK
	move	a0,@player4_data+PR_WINSTREAK

	move	@team2,a0
	movk	1,a1
	sll	a0,a1

	move	@PSTATUS2,a0		;if opponent is human then don't
	andi	01100b,a0		;count wins for top five teams
	jrz	#t2cpu
	andni	(1<<_UTA) | (1<<_NY) | (1<<_POR) | (1<<_PHX) | (1<<_CHI),a1
#t2cpu
	move	@player1_data+PR_TEAMSDEF,a0,L
	or	a1,a0
	move	a0,@player1_data+PR_TEAMSDEF,L
	move	@player2_data+PR_TEAMSDEF,a0,L
	or	a1,a0
	move	a0,@player2_data+PR_TEAMSDEF,L
	jruc	#cont1
#t2_wins
	move	@player3_data+PR_WON,a0
	inc	a0
	move	a0,@player3_data+PR_WON
	move	@player3_data+PR_WINSTREAK,a0
	inc	a0
	andi	_6BITS,a0
	jrz	#no_wrap3
	move	a0,@player3_data+PR_WINSTREAK
#no_wrap3

	move	@player4_data+PR_WON,a0
	inc	a0
	move	a0,@player4_data+PR_WON
	move	@player4_data+PR_WINSTREAK,a0
	inc	a0
	andi	_6BITS,a0
	jrz	#no_wrap4
	move	a0,@player4_data+PR_WINSTREAK
#no_wrap4

	clr	a0
	move	a0,@player1_data+PR_WINSTREAK
	move	a0,@player2_data+PR_WINSTREAK

	move	@team1,a0
	movk	1,a1
	sll	a0,a1

	move	@PSTATUS2,a0		;if opponent is human then don't
	andi	011b,a0			;count wins for top five teams
	jrz	#t1cpu
	andni	(1<<_UTA) | (1<<_NY) | (1<<_POR) | (1<<_PHX) | (1<<_CHI),a1
#t1cpu
	move	@player3_data+PR_TEAMSDEF,a0,L
	or	a1,a0
	move	a0,@player3_data+PR_TEAMSDEF,L
	move	@player4_data+PR_TEAMSDEF,a0,L
	or	a1,a0
	move	a0,@player4_data+PR_TEAMSDEF,L
#cont1

	calla	dec_lastplay

	move	*a13(PC_DATADDR),a0,L
	PUSHP	a0

	move	@PSTATUS,a0
	btst	0,a0
	jrz	#no1
	move	@player1_data+PR_INIT1,a0
	jrn	#no1
	movi	player1_data,a6
	calla	save_record
#no1
	move	@PSTATUS,a0
	btst	1,a0
	jrz	#no2
	move	@player2_data+PR_INIT1,a0
	jrn	#no2
	movi	player2_data,a6
	calla	save_record
#no2
	move	@PSTATUS,a0
	btst	2,a0
	jrz	#no3
	move	@player3_data+PR_INIT1,a0
	jrn	#no3
	movi	player3_data,a6
	calla	save_record
#no3
	move	@PSTATUS,a0
	btst	3,a0
	jrz	#no4
	move	@player4_data+PR_INIT1,a0
	jrn	#no4
	movi	player4_data,a6
	calla	save_record
#no4

	calla	get_all_records			;resort players
	calla	sort_wins			;for new ranking


	move	@PSTATUS,a0
	btst	0,a0
	jrz	#no1b
	move	@player1_data+PR_INIT1,a0
	jrn	#no1b
	movi	player1_data,a0
	move	a0,*a13(PC_DATADDR),L		;start of player data
	callr	get_player_record		;re-calc rank etc..
#no1b

	move	@PSTATUS,a0
	btst	1,a0
	jrz	#no2b
	move	@player2_data+PR_INIT1,a0
	jrn	#no2b
	movi	player2_data,a0
	move	a0,*a13(PC_DATADDR),L		;start of player data
	callr	get_player_record		;re-calc rank etc..
#no2b

	move	@PSTATUS,a0
	btst	2,a0
	jrz	#no3b
	move	@player3_data+PR_INIT1,a0
	jrn	#no3b
	movi	player3_data,a0
	move	a0,*a13(PC_DATADDR),L		;start of player data
	callr	get_player_record		;re-calc rank etc..
#no3b

	move	@PSTATUS,a0
	btst	3,a0
	jrz	#no4b
	move	@player4_data+PR_INIT1,a0
	jrn	#no4b
	movi	player4_data,a0
	move	a0,*a13(PC_DATADDR),L		;start of player data
	callr	get_player_record		;re-calc rank etc..
#no4b


	PULLP	a0
	move	a0,*a13(PC_DATADDR),L
	rets

copy_inits
	move	*a5(PR_INIT1),a0		;get teammates initials
	jrnn	#not_cpu1
	movi	'C'-'A',a0
	move	a0,*a4(PR_TMATEINIT1)
	movi	'P'-'A',a0
	move	a0,*a4(PR_TMATEINIT2)
	movi	'U'-'A',a0
	move	a0,*a4(PR_TMATEINIT3)
	jruc	#cont01
#not_cpu1
	move	a0,*a4(PR_TMATEINIT1)
	move	*a5(PR_INIT2),a0
	move	a0,*a4(PR_TMATEINIT2)
	move	*a5(PR_INIT3),a0
	move	a0,*a4(PR_TMATEINIT3)
#cont01


	move	*a6(PR_INIT1),a0		;get 1st opponents initials
	jrnn	#not_cpu2
	movi	'C'-'A',a0
	move	a0,*a4(PR_OP1INIT1)
	movi	'P'-'A',a0
	move	a0,*a4(PR_OP1INIT2)
	movi	'U'-'A',a0
	move	a0,*a4(PR_OP1INIT3)
	jruc	#cont02
#not_cpu2
	move	a0,*a4(PR_OP1INIT1)
	move	*a6(PR_INIT2),a0
	move	a0,*a4(PR_OP1INIT2)
	move	*a6(PR_INIT3),a0
	move	a0,*a4(PR_OP1INIT3)
#cont02

	move	*a7(PR_INIT1),a0		;get 2nd opponents initials
	jrnn	#not_cpu3
	movi	'C'-'A',a0
	move	a0,*a4(PR_OP2INIT1)
	movi	'P'-'A',a0
	move	a0,*a4(PR_OP2INIT2)
	movi	'U'-'A',a0
	move	a0,*a4(PR_OP2INIT3)
	rets
#not_cpu3
	move	a0,*a4(PR_OP2INIT1)
	move	*a7(PR_INIT2),a0
	move	a0,*a4(PR_OP2INIT2)
	move	*a7(PR_INIT3),a0
	move	a0,*a4(PR_OP2INIT3)
	rets


#*****************************************************************************

 SUBR	clear_player_stats

	clr	a0
	movi	player_stats,a1
	movi	PS_SIZE*4,b0
#clear_next
	move	a0,*a1+
	dsj	b0,#clear_next
	rets


#*****************************************************************************
*
* INPUT:	a0 = stat number (use equates in GAME.EQU)
*		a1 = player number
*
* TRASHES:	a0,a1,a14
*-----------------------------------------------------------------------------

 SUBR	inc_player_stat

	movi	PS_SIZE,a14
	mpyu	a14,a1			;player number * PS_SIZE
	add	a1,a0			;+ stat offset
	sll	4,a0			;x 16 bits
	addi	player_stats,a0		;+ base address
	move	*a0,a14
	inc	a14
	move	a14,*a0
	rets

#*****************************************************************************
*
* INPUT:	a0 = stat number (use equates in GAME.EQU)
*		a1 = player number
*
* TRASHES:	a0,a1,a14
*-----------------------------------------------------------------------------

 SUBR	dec_player_stat

	movi	PS_SIZE,a14
	mpyu	a14,a1			;player number * PS_SIZE
	add	a1,a0			;+ stat offset
	sll	4,a0			;x 16 bits
	addi	player_stats,a0		;+ base address
	move	*a0,a14
	dec	a14
	move	a14,*a0
	rets



#*****************************************************************************
*
* INPUT:	a6 = * player data
*
*-----------------------------------------------------------------------------
*
* RETURN:	a0 = 8 bit checksum value
*
* calculates an 8 bit xor checksum of the player data
*
*-----------------------------------------------------------------------------

 SUBRP	calc_checksum

	PUSH	a1
	clr	a0

	move	*a6(PR_COUNT),a1
	xor	a1,a0
	move	*a6(PR_WON),a1
	xor	a1,a0
	move	*a6(PR_LOST),a1
	xor	a1,a0
	move	*a6(PR_LASTPLAY),a1
	xor	a1,a0
	move	*a6(PR_INIT1),a1
	xor	a1,a0
	move	*a6(PR_INIT2),a1
	xor	a1,a0
	move	*a6(PR_INIT3),a1
	xor	a1,a0
	move	*a6(PR_MONTH),a1
	xor	a1,a0
	move	*a6(PR_DAY),a1
	xor	a1,a0
	move	*a6(PR_TMATEINIT1),a1
	xor	a1,a0
	move	*a6(PR_TMATEINIT2),a1
	xor	a1,a0
	move	*a6(PR_TMATEINIT3),a1
	xor	a1,a0
	move	*a6(PR_OP1INIT1),a1
	xor	a1,a0
	move	*a6(PR_OP1INIT2),a1
	xor	a1,a0
	move	*a6(PR_OP1INIT3),a1
	xor	a1,a0
	move	*a6(PR_OP2INIT1),a1
	xor	a1,a0
	move	*a6(PR_OP2INIT2),a1
	xor	a1,a0
	move	*a6(PR_OP2INIT3),a1
	xor	a1,a0
	move	*a6(PR_PTEAM),a1
	xor	a1,a0
	move	*a6(PR_OTEAM),a1
	xor	a1,a0
	move	*a6(PR_OSCORE),a1
	xor	a1,a0
	move	*a6(PR_PSCORE),a1
	xor	a1,a0
	move	*a6(PR_TEAMSDEF),a1
	xor	a1,a0
	move	*a6(PR_TEAMSDEF+10h),a1
	xor	a1,a0
	move	*a6(PKDPR_WINSTREAK),a1
	xor	a1,a0
	andi	_8BITS,a0
	PULL	a1
	rets


#*****************************************************************************
*
* INPUT:	a6  = * player data
*		a10 = * cmos record
*
*-----------------------------------------------------------------------------


 SUBRP	get_temp_record

	PUSH	a6,a7
 	movi	temp_record,a6
	jruc	#start

 SUBRP	get_plr_record

	PUSH	a6,a7				;a6 = * player data
#start
	movi	RECORD_SELECT,A1
	calla	SET_PAGE

	move	a10,a7

	movi	PKDPR_SIZE/8,a3			;number bytes to fetch
	movi	packed_record,a2
#next_word
	calla	RC_BYTEI
	movb	a0,*a2
	addk	8,a2
	dsj	a3,#next_word

	movi	packed_record,a2



	move	*a2(PKDPR_COUNT),a1		;total plays count
	andi	_11BITS,a1
	move	a1,*a6(PR_COUNT)

	move	*a2(PKDPR_WON),a0
	andi	_10BITS,a0
	move	a0,*a6(PR_WON)

	sub	a0,a1				;total plays - wins = losses

	move	a1,*a6(PR_LOST)

	move	*a2(PKDPR_LASTPLAY),a0
	andi	_11BITS,a0
	move	a0,*a6(PR_LASTPLAY)

	move	*a2(PKDPR_INIT1),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_INIT1)

	move	*a2(PKDPR_INIT2),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_INIT2)

	move	*a2(PKDPR_INIT3),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_INIT3)

	move	*a2(PKDPR_MONTH),a0
	andi	_4BITS,a0
	move	a0,*a6(PR_MONTH)

	move	*a2(PKDPR_DAY),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_DAY)

	move	*a2(PKDPR_TMATEINIT1),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_TMATEINIT1)

	move	*a2(PKDPR_TMATEINIT2),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_TMATEINIT2)

	move	*a2(PKDPR_TMATEINIT3),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_TMATEINIT3)

	move	*a2(PKDPR_OP1INIT1),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_OP1INIT1)

	move	*a2(PKDPR_OP1INIT2),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_OP1INIT2)

	move	*a2(PKDPR_OP1INIT3),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_OP1INIT3)

	move	*a2(PKDPR_OP2INIT1),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_OP2INIT1)

	move	*a2(PKDPR_OP2INIT2),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_OP2INIT2)

	move	*a2(PKDPR_OP2INIT3),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_OP2INIT3)

	move	*a2(PKDPR_PTEAM),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_PTEAM)

	move	*a2(PKDPR_OTEAM),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_OTEAM)

	move	*a2(PKDPR_OSCORE),a0
	andi	_8BITS,a0
	move	a0,*a6(PR_OSCORE)

	move	*a2(PKDPR_PSCORE),a0
	andi	_8BITS,a0
	move	a0,*a6(PR_PSCORE)

	move	*a2(PKDPR_TEAMSDEF),a1,L
	andi	_27BITS,a1
	move	a1,*a6(PR_TEAMSDEF),L

	move	*a2(PKDPR_WINSTREAK),a0
	andi	_6BITS,a0
	move	a0,*a6(PR_WINSTREAK)

	PUSH	a2
	clr	a0
	movk	27,a2
#next_team
	srl	1,a1
	jrnc	#not_def
	inc	a0			;teams defeated count ++
#not_def
	dsj	a2,#next_team
	move	a0,*a6(PR_NUMDEF)	;number teams defeated
	PULL	a2

	move	*a2(PKDPR_CHECKSUM),a0
	andi	_8BITS,a0
	move	a0,*a6(PR_CHECKSUM)
	move	a0,a1
	callr	calc_checksum
	cmp	a0,a1
	jreq	#checksum_ok

	.if	DEBUG
	LOCKUP
	eint
	.endif

	callr	clear_record		;bad checksum, so delete record
#checksum_ok
	PULL	a6,a7
	rets



#*****************************************************************************
*
* INPUT:	a6  = * player data
*		a10 = * cmos record dest
*
*-----------------------------------------------------------------------------

 SUBRP	put_temp_record

	PUSH	a6
	movi	temp_record,a6
	jruc	#start

 SUBRP	put_plr_record

	PUSH	a6
#start

	movi	RECORD_SELECT,A1
	calla	SET_PAGE

	movi	packed_record,a2

	move	*a6(PR_COUNT),a1
	andi	_11BITS,a1
	move	a1,*a2(PKDPR_COUNT)

	move	*a6(PR_WON),a0
	andi	_10BITS,a0
	move	a0,*a2(PKDPR_WON)

	sub	a0,a1
	move	a1,*a6(PR_LOST)			;used for calc checksum

	move	*a6(PR_LASTPLAY),a0
	andi	_11BITS,a0
	move	a0,*a2(PKDPR_LASTPLAY)

	move	*a6(PR_INIT1),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_INIT1)

	move	*a6(PR_INIT2),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_INIT2)

	move	*a6(PR_INIT3),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_INIT3)

	move	*a6(PR_MONTH),a0
	andi	_4BITS,a0
	move	a0,*a2(PKDPR_MONTH)

	move	*a6(PR_DAY),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_DAY)

	move	*a6(PR_TMATEINIT1),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_TMATEINIT1)

	move	*a6(PR_TMATEINIT2),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_TMATEINIT2)

	move	*a6(PR_TMATEINIT3),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_TMATEINIT3)

	move	*a6(PR_OP1INIT1),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_OP1INIT1)

	move	*a6(PR_OP1INIT2),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_OP1INIT2)

	move	*a6(PR_OP1INIT3),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_OP1INIT3)

	move	*a6(PR_OP2INIT1),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_OP2INIT1)

	move	*a6(PR_OP2INIT2),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_OP2INIT2)

	move	*a6(PR_OP2INIT3),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_OP2INIT3)

	move	*a6(PR_PTEAM),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_PTEAM)

	move	*a6(PR_OTEAM),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_OTEAM)

	move	*a6(PR_OSCORE),a0
	andi	_8BITS,a0
	move	a0,*a2(PKDPR_OSCORE)

	move	*a6(PR_PSCORE),a0
	andi	_8BITS,a0
	move	a0,*a2(PKDPR_PSCORE)

	move	*a6(PR_TEAMSDEF),a0,L
	andi	_27BITS,a0
	move	a0,*a2(PKDPR_TEAMSDEF),L

	move	*a6(PR_WINSTREAK),a0
	andi	_6BITS,a0
	move	a0,*a2(PKDPR_WINSTREAK)

	callr	calc_checksum			;8 bit xor checksum
	andi	_8BITS,a0
	move	a0,*a2(PKDPR_CHECKSUM)

	PUSH	a7
	move	a10,a7

	movi	PKDPR_SIZE/8,a3			;number bytes to write
	movi	packed_record,a2
#next_word
	movb	*a2,a0
	calla	WC_BYTEI
	addk	8,a2
	dsj	a3,#next_word

	PULL	a7
	PULL	a6
	rets


#*****************************************************************************
*
* INPUT:	a6 = * player data
*
*-----------------------------------------------------------------------------
*
* RETURN:	a10 = * matching CMOS record
*	 	(a10 = 0 if no match found)
*
*-----------------------------------------------------------------------------

 SUBRP	find_record

	movi	RECORD_SELECT,A1
	calla	SET_PAGE

	movi	NUM_PRECORDS,a11
	movi	RECORD_ORIGIN,a10
#search_loop
	callr	get_temp_record		;data in temp_record
	callr	compare_record
	jrne	#no_match
	rets

#no_match
	addi	PKDPR_SIZE*2,a10	;cmos words
	dsj	a11,#search_loop
	clr	a10
 	rets


#*****************************************************************************
*
* INPUT:	NONE
*
*-----------------------------------------------------------------------------
*
* RETURN: 	a10 = * free CMOS record
*
*-----------------------------------------------------------------------------

 SUBRP	get_free_record

	movi	RECORD_SELECT,A1
	calla	SET_PAGE

	movi	2048,a8			;last play count (max)
	movi	NUM_PRECORDS,a11
	movi	RECORD_ORIGIN,a10
	move	a10,a9			;least used record to date
#search_loop
	callr	get_temp_record
	move	@temp_record+PR_COUNT,a0
	jrz	#free_record
	move	@temp_record+PR_LASTPLAY,a0

	cmp	a8,a0			;a0-a8
	jrhs	#skip			;skip if a0 >= a8
	move	a0,a8
	move	a10,a9			;least used record to date
#skip					;(lowest lastplay count)
	addi	PKDPR_SIZE*2,a10	;cmos words
	dsj	a11,#search_loop
	move	a9,a10
	rets

#free_record
 	rets


#*****************************************************************************
*
* INPUT:	a6 = * player data
*
*-----------------------------------------------------------------------------

 SUBRP	compare_record

	move	@temp_record+PR_COUNT,a1	;valid record?
	jrz	#no_match

	move	*a6(PR_INIT1),a0
	move	@temp_record+PR_INIT1,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_INIT2),a0
	move	@temp_record+PR_INIT2,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_INIT3),a0
	move	@temp_record+PR_INIT3,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_MONTH),a0
	move	@temp_record+PR_MONTH,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_DAY),a0
	move	@temp_record+PR_DAY,a1
	cmp	a0,a1
	jrne	#no_match
	rets					;Z set

#no_match
	movi	1,a0				;clear Z
	rets

#*****************************************************************************
*
* INPUT:	a4 = cmos record number (0 - NUM_RECORDS-1 )
*
* RETURN:	a2 = player rank
*
*-----------------------------------------------------------------------------

 SUBRP	get_plr_rank

	PUSH	a8
	movk	1,a2
	movi	record_sort_ptrs,a9
#loop
	move	*a9,a8,L
	move	*a8(RS_RECORD_NUM),a0
	cmp	a4,a0
	jreq	#found_match

	addi	20h,a9
	inc	a2
	cmpi	NUM_PRECORDS,a2
	jrls	#loop
#found_match
	PULL	a8
	rets

#*****************************************************************************
*
*
*
*-----------------------------------------------------------------------------

 SUBRP	get_player_record

	move	*a13(PC_DATADDR),a6,L		;start of player data

	callr	find_record
	move	a10,a10
	jrz	#no_match
	callr	get_plr_record

	movi	NUM_PRECORDS,a4
	sub	a11,a4				;record number
	callr	get_plr_rank
	move	*a13(PC_DATADDR),a6,L		;start of player data
	move	a2,*a6(PR_RANK)
	rets

#no_match
	clr	a0
	move	a0,*a6(PR_COUNT)
	move	a0,*a6(PR_WON)
	move	a0,*a6(PR_LOST)
	move	a0,*a6(PR_LASTPLAY)
	move	a0,*a6(PR_OSCORE)
	move	a0,*a6(PR_PSCORE)
	move	a0,*a6(PR_TEAMSDEF),L
	move	a0,*a6(PR_WINSTREAK)
	move	a0,*a6(PR_NUMDEF)
	move	a0,*a6(PR_NUMDEFOLD)

	movi	300,a0
	move	a0,*a6(PR_RANK)
	rets


#*****************************************************************************
*
* INPUT:	a6 = * player data
*
*-----------------------------------------------------------------------------

 SUBRP	save_record

	callr	find_record
	move	a10,a10
	jrnz	#found_match

	movk	1,a0			;1st game
	move	a0,*a6(PR_COUNT)

	movi	50,a0
	move	a0,*a6(PR_LASTPLAY)

	callr	get_free_record
	callr	put_plr_record

	rets

#found_match

	move	*a6(PR_COUNT),a0
	cmpi	2047,a0
	jrhs	#at_max
	inc	a0			;play count (check for wrap!!!)
	move	a0,*a6(PR_COUNT)
#at_max
	move	*a6(PR_LASTPLAY),a0
	addi	50,a0
	cmpi	2047,a0
	jrle	#ok
	movi	2047,a0
#ok
	move	a0,*a6(PR_LASTPLAY)	;zero lastplay count

	move	*a6(PR_NUMDEF),a0
	move	a0,*a6(PR_NUMDEFOLD)

	callr	put_plr_record

	rets


#*****************************************************************************
*
* decs lastplay count for all records
*
*-----------------------------------------------------------------------------

 SUBRP	dec_lastplay

	movi	NUM_PRECORDS,a11
	movi	RECORD_ORIGIN,a10
#dec_loop
	PUSH	a10,a11

	callr	get_temp_record		;read record
	move	@temp_record+PR_LASTPLAY,a0
	jrz	#at_min
	dec	a0
	move	a0,@temp_record+PR_LASTPLAY
	callr	put_temp_record		;write out record
#at_min

	PULL	a10,a11
	addi	PKDPR_SIZE*2,a10	;cmos words
	dsj	a11,#dec_loop
	rets

#*****************************************************************************

 SUBR	get_all_records

	PUSH	a12

	movi	record_sort_ptrs,a12
	clr	a11
	movi	RECORD_ORIGIN,a10
	movi	record_sort_ram,a9
#get_next
	PUSH	a9,a10,a11,a12

	callr	get_temp_record		;read record

	PULL	a9,a10,a11,a12

	move	a11,*a9(RS_RECORD_NUM)

	move	@temp_record+PR_WON,a0		;wins
	move	a0,*a9(RS_WINS)
	jrnz	#has_wins

	move	@temp_record+PR_COUNT,a0	;games played
	move	a0,*a9(RS_GAMES_PLAYED)
	clr	a0
	move	a0,*a9(RS_AVERAGE)
	move	a0,*a9(RS_TEAMSDEF)
	move	a0,*a9(RS_STREAK)
	jruc	#cont1

#has_wins
	movi	1000,a1
	mpyu	a0,a1				;wins*1000
	move	@temp_record+PR_COUNT,a0	;games played
	move	a0,*a9(RS_GAMES_PLAYED)
	divu	a0,a1				;wins*1000/played
	move	a1,*a9(RS_AVERAGE)

;	move	@temp_record+PR_TEAMSDEF,a1,L
;	callr	calc_num_defeated

	move	@temp_record+PR_NUMDEF,a0	;number teams defeated
	move	a0,*a9(RS_TEAMSDEF)
#cont1
	move	@temp_record+PR_WINSTREAK,a0
	move	a0,*a9(RS_STREAK)

	move	a9,*a12+,L
	addi	RS_SIZE,a9
	addi	PKDPR_SIZE*2,a10	;cmos words
	inc	a11
	cmpi	NUM_PRECORDS,a11
	jrlo	#get_next

	PULL	a12			;process SP
	rets


#******************************************************************************
*
* INPUT:	call get_all_records to build ram copy of records
*
*	sorts teams based on wins
*	player must have 5 wins
*	then sorted on average (wins / games played)
*	then different teams defeated
*-----------------------------------------------------------------------------

 SUBRP	sort_wins

	movi	NUM_PRECORDS-1,a11
#loop1

	movi	NUM_PRECORDS-1,a10

	movi	record_sort_ptrs,a9

	clr	a14
#loop2
	move	*a9,a4,L
	move	*a9(20h),a5,L

	move	*a4(RS_WINS),a0
	move	*a5(RS_WINS),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap

;same, so compare average
	move	*a4(RS_AVERAGE),a0
	move	*a5(RS_AVERAGE),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap


;same, so compare teams defeated
	move	*a4(RS_TEAMSDEF),a0
	move	*a5(RS_TEAMSDEF),a1
	cmp	a1,a0				;a0-a1
	jrhs	#no_swap

#swap
	movk	1,a14

	move	a5,*a9,L
	move	a4,*a9(20h),L

#no_swap
;;	addi	RS_SIZE,a9
	addi	20h,a9

	dsj	a10,#loop2
	move	a14,a14
	jrz	#done
	dsj	a11,#loop1

#done
	rets

#******************************************************************************
*
* INPUT:	call get_all_records to build ram copy of records
*
*	sorts players based on streaks
*	then on wins
*	then sorted on average (wins / games played)
*	then on teams defeated
*-----------------------------------------------------------------------------

 SUBRP	sort_streak

	movi	NUM_PRECORDS-1,a11
#loop1

	movi	NUM_PRECORDS-1,a10

	movi	record_sort_ptrs,a9

	clr	a14
#loop2
	move	*a9,a4,L
	move	*a9(20h),a5,L

	move	*a4(RS_STREAK),a0
	move	*a5(RS_STREAK),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap

;same, so compare wins
	move	*a4(RS_WINS),a0
	move	*a5(RS_WINS),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap

;same, so compare average
	move	*a4(RS_AVERAGE),a0
	move	*a5(RS_AVERAGE),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap


;same, so compare teams defeated
	move	*a4(RS_TEAMSDEF),a0
	move	*a5(RS_TEAMSDEF),a1
	cmp	a1,a0				;a0-a1
	jrhs	#no_swap

#swap
	movk	1,a14

	move	a5,*a9,L
	move	a4,*a9(20h),L

#no_swap
	addi	20h,a9

	dsj	a10,#loop2
	move	a14,a14
	jrz	#done
	dsj	a11,#loop1

#done
	rets

#******************************************************************************
*
* INPUT:	call get_all_records to build ram copy of records
*
*	sorts teams based on games played
*	then sorted on wins
*	then sorted on average (wins / games played)
*	then different teams defeated
*-----------------------------------------------------------------------------

 SUBRP	sort_exp

	movi	NUM_PRECORDS-1,a11
#loop1

	movi	NUM_PRECORDS-1,a10
	movi	record_sort_ptrs,a9

	clr	a14
#loop2
	move	*a9,a4,L
	move	*a9(20h),a5,L

	move	*a4(RS_GAMES_PLAYED),a0
	move	*a5(RS_GAMES_PLAYED),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap

;same, so compare wins
	move	*a4(RS_WINS),a0
	move	*a5(RS_WINS),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap

;same, so compare average
	move	*a4(RS_AVERAGE),a0
	move	*a5(RS_AVERAGE),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap


;same, so compare teams defeated
	move	*a4(RS_TEAMSDEF),a0
	move	*a5(RS_TEAMSDEF),a1
	cmp	a1,a0				;a0-a1
	jrhs	#no_swap
;	jrlo	#swap

#swap
	movk	1,a14

	move	a5,*a9,L
	move	a4,*a9(20h),L

#no_swap
	addi	20h,a9
	dsj	a10,#loop2
	move	a14,a14
	jrz	#done
	dsj	a11,#loop1

#done
	rets

#******************************************************************************
*
* INPUT:	call get_all_records to build ram copy of records
*
*	sort teams based on different teams defeated
*	then on wins
*	then sorted on average (wins / games played)
*-----------------------------------------------------------------------------

 SUBRP	sort_champs

	movi	NUM_PRECORDS-1,a11
#loop1

	movi	NUM_PRECORDS-1,a10
	movi	record_sort_ptrs,a9

	clr	a14
#loop2
	move	*a9,a4,L
	move	*a9(20h),a5,L

	move	*a4(RS_TEAMSDEF),a0
	move	*a5(RS_TEAMSDEF),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap

;same, so compare wins
	move	*a4(RS_WINS),a0
	move	*a5(RS_WINS),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap

;same, so compare average
	move	*a4(RS_AVERAGE),a0
	move	*a5(RS_AVERAGE),a1
	cmp	a1,a0				;a0-a1
	jrhs	#no_swap
;	jrlo	#swap

#swap
	movk	1,a14

	move	a5,*a9,L
	move	a4,*a9(20h),L
;;

#no_swap
	addi	20h,a9
	dsj	a10,#loop2
	move	a14,a14
	jrz	#done
	dsj	a11,#loop1

#done
	rets

#******************************************************************************
*
* INPUT:	call get_all_records to build ram copy of records
*
*	sorts teams on average (wins / games played)
*	then sorted based on games lost
*	then different teams defeated
*-----------------------------------------------------------------------------

 SUBRP	sort_losses

	movi	NUM_PRECORDS-1,a11
#loop1


	movi	NUM_PRECORDS-1,a10
	movi	record_sort_ptrs,a9

	clr	a14
#loop2
	move	*a9,a4,L
	move	*a9(20h),a5,L

	move	*a4(RS_GAMES_PLAYED),a0
	jrz	#swap
	cmpi	5,a0
	jrlo	#swap
	move	*a5(RS_GAMES_PLAYED),a0
	jrz	#no_swap
	cmpi	5,a0
	jrlo	#no_swap

	move	*a4(RS_AVERAGE),a0
	move	*a5(RS_AVERAGE),a1
	cmp	a1,a0				;a0-a1
	jrlo	#no_swap
	jrhi	#swap

;same, so comapre losses
	move	*a4(RS_GAMES_PLAYED),a0
	move	*a4(RS_WINS),a2
	sub	a2,a0

	move	*a5(RS_GAMES_PLAYED),a1
	move	*a5(RS_WINS),a2
	sub	a2,a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap

;same, so compare teams defeated
	move	*a4(RS_TEAMSDEF),a0
	move	*a5(RS_TEAMSDEF),a1
	cmp	a1,a0				;a0-a1
	jrlo	#no_swap
	jrhi	#swap

#swap
	movk	1,a14

	move	a5,*a9,L
	move	a4,*a9(20h),L

#no_swap
	addi	20h,a9
	dsj	a10,#loop2
	move	a14,a14
	jrz	#done
	dsj	a11,#loop1

#done
	rets

#******************************************************************************
*
* INPUT:	defeated teams in A1
*
* RETURN:	a0 = # teams defeated
*
*------------------------------------------------------------------------------

 SUBR	calc_num_defeated

	PUSH	a1,a2
	clr	a0
	movk	27,a2
#next_team
	srl	1,a1
	jrnc	#not_def
	inc	a0			;teams defeated count ++
#not_def
	dsj	a2,#next_team
	PULL	a1,a2
	rets

#*****************************************************************************
*
* clears out all cmos player records
* and puts in defaults for high score table
*
*-----------------------------------------------------------------------------


 SUBRP	clear_player_records

	clr	a0
	movi	PR_SIZE/16,a1
	movi	temp_record,a2
#clrit
	move	a0,*a2+
	dsj	a1,#clrit

	movi	NUM_PRECORDS,a11
	movi	RECORD_ORIGIN,a10
#clear_loop
	PUSH	a10,a11

	callr	put_temp_record		;write out record

	PULL	a10,a11
	addi	PKDPR_SIZE*2,a10	;cmos words
	dsj	a11,#clear_loop



	movk	23,a11

	movi	RECORD_ORIGIN,a10
	movi	#default_records,a9
#init_loop
	PUSH	a9,a10,a11

	movb	*a9,a0
	subi	'A',a0
	move	a0,@temp_record+PR_INIT1

	movb	*a9(8h),a0
	subi	'A',a0
	move	a0,@temp_record+PR_INIT2

	movb	*a9(10h),a0
	subi	'A',a0
	move	a0,@temp_record+PR_INIT3

	move	*a9(20h),a0
	dec	a0
	move	a0,@temp_record+PR_MONTH

	move	*a9(30h),a0
	dec	a0
	move	a0,@temp_record+PR_DAY

	move	*a9(40h),a0
	move	a0,@temp_record+PR_COUNT	;games played

	move	*a9(50h),a0
	move	a0,@temp_record+PR_WON		;wins

	move	*a9(60h),a0
	move	a0,@temp_record+PR_WINSTREAK

	move	*a9(70h),a0,L
	move	a0,@temp_record+PR_TEAMSDEF,L

	movi	2047,a0
	move	a0,@temp_record+PR_LASTPLAY

	movk	'C'-'A',a0
	move	a0,@temp_record+PR_TMATEINIT1
	move	a0,@temp_record+PR_OP1INIT1
	move	a0,@temp_record+PR_OP2INIT1
	movk	'P'-'A',a0
	move	a0,@temp_record+PR_TMATEINIT2
	move	a0,@temp_record+PR_OP1INIT2
	move	a0,@temp_record+PR_OP2INIT2
	movk	'U'-'A',a0
	move	a0,@temp_record+PR_TMATEINIT3
	move	a0,@temp_record+PR_OP1INIT3
	move	a0,@temp_record+PR_OP2INIT3

	movk	3,a0				;chicago
	move	a0,@temp_record+PR_PTEAM
	movk	7,a0				;detroit
	move	a0,@temp_record+PR_OTEAM

	movi	137,a0
	move	a0,@temp_record+PR_PSCORE
	movi	86,a0
	move	a0,@temp_record+PR_OSCORE

	callr	put_temp_record
	PULL	a9,a10,a11

	addi	9*10h,a9
	addi	PKDPR_SIZE*2,a10	;cmos words
	dsj	a11,#init_loop

	rets

RECMAC	.macro	NAME,MONTH,DAY,PLAYED,WINS,STREAK,DEFEATED
	.string	":NAME:"
	.word	:MONTH:,:DAY:
	.word	:PLAYED:,:WINS:,:STREAK:
	.long	:DEFEATED:
	.endm


#default_records
	RECMAC	"MDP ",01,13,	20,8,	1,	000000000000001001000000000b	;1
	RECMAC	"DOZ ",12,31,	16,9,	1,	100000001000000000000000000b	;2
	RECMAC	"JCV ",06,27,	9,4,	2,	000000100000000000000000000b	;3
	RECMAC	"JMS ",02,22,	16,6,	1,	000000001000000010000000001b	;4
	RECMAC	"JFL ",04,16,	15,7,	1,	000000100000000100000000000b	;5

	RECMAC	"JRN ",06,18,	21,7,	1,	000000010000000000001000000b	;6
	RECMAC	"GET ",10,19,	20,9,	2,	101000010001000010000100000b	;7
	RECMAC	"TJC ",10,12,	15,9,	4,	000000000000100000000000000b	;8

	RECMAC	"GNP ",10,08,	14,8,	2,	001000000100010000100010000b	;9
	RECMAC	"JWH ",09,20,	13,9,	1,	000000010000100000000110000b	;10
	RECMAC	"CMM ",07,02,	11,5,	1,	100000100000000000001000000b	;11
	RECMAC	"MJT ",03,22,	28,17,	1,	000001001001010001000001000b	;12
;	RECMAC	"MJT ",03,22,	28,17,	1,	111111111111111111111111110b

	RECMAC	"RJR ",01,17,	14,12,	1,	100001000100100100000100000b	;13
	RECMAC	"SAL ",02,01,	13,10,	1,	000001001100010000010000000b	;14
	RECMAC	"TWG ",12,07,	12,9,	1,	100000001100000010000000000b	;15
	RECMAC	"JMC ",08,05,	19,12,	3,	001000010010010010001000001b	;16

	.byte	'S','L','A'+26
	.word	6,24
	.word	25,15
	.word	0
	.long	010010011011100110100100110b	;17
;	RECMAC	"SLX ",06,24,	32,22,	000000001000000000000000000b	;17

	RECMAC	"WMN ",11,11,	15,8,	4,	001000010010010000001000001b	;18
	RECMAC	"DIE ",02,23,	12,2,	1,	000000010000000000001000000b	;19
	RECMAC	"EJB ",02,23,	19,8,	2,	010100010000100010001000000b	;20

	RECMAC	"CRL ",01,01,	5,5,	5,	000000010001000100001000001b	;21
	RECMAC	"SAN ",01,01,	5,5,	2,	000000010001000100001000001b	;22
	RECMAC	"SNO ",01,03,	11,5,	3,	000000010001000100001000001b	;23

	.even


#*****************************************************************************
*
* INPUT:	a10 = * cmos record to delete

 SUBRP	clear_record

	clr	a0
	move	a0,@temp_record+00h,L
	move	a0,@temp_record+20h,L
	move	a0,@temp_record+40h,L
	callr	put_temp_record		;write out record
	rets

#*****************************************************************************
*
* INPUT:	a0 = hiscore type
*
*		0 = GREATEST PLAYERS
*		1 = EXPERIENCED PLAYERS
*		2 = GRAND CHAMPIONS
*		3 = MOST POPULAR TEAMS
*
*-----------------------------------------------------------------------------
	.asg	24,YOFF
	.asg	64,COL0			;#
	.asg	COL0+29,COL0b		;1-8
	.asg	150,COL1		;initials
	.asg	230,COL2		;wins
	.asg	COL2+2,COL3		;dash
	.asg	COL3+16,COL4		;losses
	.asg	310,COL5		;average

 SUBR	show_hiscore

	andi	7,a0
	move	a0,@hiscore_type

	callr	get_all_records

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	4<<10+4<<5+7,a0
	move	a0,@IRQSKYE

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	#hiscore_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movi	[10,7],a8		;START AT COLOR 10, CYCLE 7 COLORS
	movi	BLUE,a9			;PAL NAME
	movi	COLTAB2,a10		;TABLE TO CYCLE WITH
	movk	2,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

;	movi	[10,7],a8		;START AT COLOR 10, CYCLE 7 COLORS
;	movi	REDPAL,a9		;PAL NAME
;	movi	COLTAB2,a10		;TABLE TO CYCLE WITH
;	movk	4,a11			;RATE OF CYCLE IN TICKS
;	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE


	movi	OSGCYC8,a0
	calla	pal_getf
	movi	OSGCYC9,a0
	calla	pal_getf
	movi	OSGCYC10,a0
	calla	pal_getf

	.asg	1,SPD

	movk	SPD,a8
	movi	OSGCYC1,a9
	movi	#morf_plist1,a10
	movi	morfpal1,a11
	CREATE0	morf_pal

	movk	SPD,a8
	movi	OSGCYC2,a9
	movi	#morf_plist2,a10
	movi	morfpal2,a11
	CREATE0	morf_pal

	movk	SPD,a8
	movi	OSGCYC3,a9
	movi	#morf_plist3,a10
	movi	morfpal3,a11
	CREATE0	morf_pal

	movk	SPD,a8
	movi	OSGCYC4,a9
	movi	#morf_plist4,a10
	movi	morfpal4,a11
	CREATE0	morf_pal

	movk	SPD,a8
	movi	OSGCYC5,a9
	movi	#morf_plist5,a10
	movi	morfpal5,a11
	CREATE0	morf_pal

	movk	SPD,a8
	movi	OSGCYC6,a9
	movi	#morf_plist6,a10
	movi	morfpal6,a11
	CREATE0	morf_pal

	movk	SPD,a8
	movi	OSGCYC7,a9
	movi	#morf_plist7,a10
	movi	morfpal7,a11
	CREATE0	morf_pal


	movk	4,a8
	movi	OSGCYC8,a9
	movi	#morf_plist8,a10
	movi	morfpal8,a11
	CREATE0	morf_pal

	movk	4,a8
	movi	OSGCYC9,a9
	movi	#morf_plist9,a10
	movi	morfpal9,a11
	CREATE0	morf_pal

	movk	4,a8
	movi	OSGCYC10,a9
	movi	#morf_plist10,a10
	movi	morfpal10,a11
	CREATE0	morf_pal


	clr	a0
#loopit
	move	a0,@hiscore_type

	movi	TYPTEXT,a0		;delete text
	calla	obj_del1c

	callr	print_stuff			;heading and hiscore

	move	@hiscore_type,a0
	jrnz	#no_unblank

	SLEEPK	7

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank
	SLEEPK	15
#no_unblank

	SLEEP	TSEC

	movi	4*60,a10

#delay
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit0
	dsj	a10,#delay
	jruc	#exit

#exit0
      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	.ref	SOUNDSUP
	move	a0,@SOUNDSUP		;turn all sounds off
#exit
	move	@hiscore_type,a0
	inc	a0
	cmpi	5,a0
	jrlt	#loopit

	RETP



print_stuff
	movi	#heading1_setup,a2
	calla	setup_message
	movi	TYPTEXT,a0
	move	a0,@mess_objid
	move	@hiscore_type,a0
	sll	5,a0				;x 32 bits
	PUSH	a0
	addi	#headings1,a0
	move	*a0,a4,L
	calla	print_string_C2

	movi	#heading2_setup,a2
	calla	setup_message
	movi	TYPTEXT,a0
	move	a0,@mess_objid
	PULL	a0
	addi	#headings2,a0
	move	*a0,a4,L
	calla	print_string_C2

	move	@hiscore_type,a0
	sll	5,a0				;x 32 bits
	addi	#sort_routines,a0
	move	*a0,a0,L
	call	a0

	move	@hiscore_type,a0
	sll	5,a0				;x 32 bits
	addi	#print_methods,a0
	move	*a0,a0,L
	call	a0
	rets


	.def	COLTAB2
COLTAB2
	.word   0079fh,0077eh,0077eh,0035eh,0033eh,0031eh,002feh
	.word   002feh,002deh,002beh,002beh,0029eh,0029eh,0027dh,0025dh
	.word   0025dh,0023dh,0023dh,0021eh,0023eh,0025eh,0027eh,0029eh
	.word   0029eh,002beh,002deh,002feh,0033eh,0035eh,0077eh,0079eh
	.word   0079eh,0037eh,0037eh,0035eh,0033eh,0033eh,0031eh,0031eh
	.word   002feh,002feh,0131eh,0273eh,03b5eh,04f9fh,063bfh,077ffh
	.word   063bfh,04f9fh,03b5eh,0273eh,0131eh,002feh,002feh,0031eh
	.word   0031eh,0033eh,0033eh,0035eh,0037eh,0037eh,0079eh,0079eh

	.word   0079fh,0077eh,0077eh,0035eh,0033eh,0031eh,002feh
	.word   002feh,002deh,002beh,002beh,0029eh,0029eh,0027dh,0025dh
	.word   0025dh,0023dh,0023dh,0021eh,0023eh,0025eh,0027eh,0029eh
	.word   0029eh,002beh,002deh,002feh,0033eh,0035eh,0077eh,0079eh
	.word   0079eh,0037eh,0037eh,0035eh,0033eh,0033eh,0031eh,0031eh
	.word   002feh,002feh,0131eh,0273eh,03b5eh,04f9fh,063bfh,077ffh
	.word   063bfh,04f9fh,03b5eh,0273eh,0131eh,002feh,002feh,0031eh
	.word   0031eh,0033eh,0033eh,0035eh,0037eh,0037eh,0079eh,0079eh

	.word	-1






#morf_plist1
	.long	GOLD
	.long	63
	.long	WHITE2PAL
	.long	GOLD
	.long	63
	.long	WHITEPAL
	.long	GOLD
	.long	0

#morf_plist2
	.long	GOLD
	.long	55
	.long	WHITE2PAL
	.long	GOLD
	.long	63
	.long	WHITEPAL
	.long	GOLD
	.long	8
	.long	0

#morf_plist3
	.long	GOLD
	.long	48
	.long	WHITE2PAL
	.long	GOLD
	.long	63
	.long	WHITEPAL
	.long	GOLD
	.long	15
	.long	0

#morf_plist4
	.long	GOLD
	.long	41
	.long	WHITE2PAL
	.long	GOLD
	.long	63
	.long	WHITEPAL
	.long	GOLD
	.long	22
	.long	0

#morf_plist5
	.long	GOLD
	.long	34
	.long	WHITE2PAL
	.long	GOLD
	.long	63
	.long	WHITEPAL
	.long	GOLD
	.long	29
	.long	0

#morf_plist6
	.long	GOLD
	.long	27
	.long	WHITE2PAL
	.long	GOLD
	.long	63
	.long	WHITEPAL
	.long	GOLD
	.long	36
	.long	0

#morf_plist7
	.long	GOLD
	.long	20
	.long	WHITE2PAL
	.long	GOLD
	.long	63
	.long	WHITEPAL
	.long	GOLD
	.long	43
	.long	0


#morf_plist10
	.long	LGMDGLD
	.long	66
	.long	LGMDGLDlt
	.long	LGMDGLD
	.long	0

#morf_plist9
	.long	LGMDGLD
	.long	54
	.long	LGMDGLDlt
	.long	LGMDGLD
	.long	12
	.long	0

#morf_plist8
	.long	LGMDGLD
	.long	42
	.long	LGMDGLDlt
	.long	LGMDGLD
	.long	24
	.long	0


******************************************************************************
	.even
#print_methods
	.long	#method1		;0 (greatest players)
	.long	#method2b		;1 (grand champions)
	.long	#method2		;2 (experienced players)
	.long	#method1b		;3 (win streak)
	.long	#method3		;4 (most popular teams)
	.long	#method1		;5
	.long	#method1		;6
	.long	#method1		;7 (worst players!)

******************************************************************************
*
* prints rank, initials, win-loss, average
*
*-----------------------------------------------------------------------------
#method1

	movi	LN0_setup,a2
	calla	setup_message
	movi	TYPTEXT,a0
	move	a0,@mess_objid

	movk	8,a10
	movi	record_sort_ptrs,a9

#next_player
	PUSH	a9,a10

	movi	GOLD,a0
	move	a0,@message_palette,L

	movk	9,a0
	sub	a10,a0				;1-8
	movk	8,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	movi	COL0b,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	COL0,a0
	move	a0,@mess_cursx
	movi	#str_num,a4
	calla	print_string2

	move	*a9,a8,L
	move	*a8(RS_RECORD_NUM),a0
	movi	PKDPR_SIZE*2,a1			;cmos words
	mpyu	a0,a1
	addi	RECORD_ORIGIN,a1
	PUSH	a10
	move	a1,a10
	callr	get_temp_record

	PULL	a0
	sll	5,a0			;x 32 bits
	addi	#winpals-20h,a0
	move	*a0,a0,L
	move	a0,@message_palette,L


	movi	temp_record+PR_INIT1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_initials_string
	movi	COL1,a0
	move	a0,@mess_cursx
	calla	print_string_C

	move	@temp_record+PR_WON,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	COL2,a0
	move	a0,@mess_cursx
	calla	print_string_R

	movi	COL3,a0
	move	a0,@mess_cursx
	movi	#str_dash,a4
	calla	print_string2

	move	@temp_record+PR_LOST,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	COL4,a0
	move	a0,@mess_cursx
	calla	print_string

	movi	#str_dot,a4
	calla	copy_rom_string

	move	*a8(RS_AVERAGE),a0
	jrnz	#not_zip

	movi	#str_0,a4
	calla	copy_rom_string
	jruc	#skip1
#not_zip
	cmpi	1000,a0
	jrlo	#not_max

	movi	#str_1000,a4
	calla	copy_rom_string
	movi	COL5-9,a0
	move	a0,@mess_cursx
	jruc	#skip2

#not_max
	movi	999,a1			;max value
	calla	dec_to_pct
	calla	concat_string
#skip1
	movi	COL5,a0
	move	a0,@mess_cursx
#skip2
	calla	print_string


	move	@mess_cursy,a0
	addi	YOFF,a0
	move	a0,@mess_cursy

	PULL	a9,a10
;	addi	RS_SIZE,a9
	addi	20h,a9
	dsj	a10,#next_player

	rets

#winpals
	.long	OSGCYC7
	.long	OSGCYC6
	.long	OSGCYC5
	.long	OSGCYC4
	.long	OSGCYC3
	.long	OSGCYC2
	.long	OSGCYC1
	.long	BLUE

******************************************************************************
*
* prints rank, initials, streak, average
*
*-----------------------------------------------------------------------------
#method1b

	movi	LN0_setup,a2
	calla	setup_message
	movi	TYPTEXT,a0
	move	a0,@mess_objid

	movk	8,a10
	movi	record_sort_ptrs,a9

#next_player1b
	PUSH	a9,a10

	movi	GOLD,a0
	move	a0,@message_palette,L

    	movk	9,a0
	sub	a10,a0				;1-8
	movk	8,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	movi	COL0b,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	COL0,a0
	move	a0,@mess_cursx
	movi	#str_num,a4
	calla	print_string2

	move	*a9,a8,L
	move	*a8(RS_RECORD_NUM),a0
	movi	PKDPR_SIZE*2,a1			;cmos words
	mpyu	a0,a1
	addi	RECORD_ORIGIN,a1
	PUSH	a10
	move	a1,a10
	callr	get_temp_record

	PULL	a0
	sll	5,a0			;x 32 bits
	addi	#streakpals-20h,a0
	move	*a0,a0,L
	move	a0,@message_palette,L


	movi	temp_record+PR_INIT1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_initials_string
	movi	COL1,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	COL3+11,a0
	move	a0,@mess_cursx
	move	@temp_record+PR_WINSTREAK,a0
	movi	63,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	movi	#str_wins,a4
	calla	concat_rom_string
	calla	print_string_C

	.asg	96,OFFX

	move	@temp_record+PR_WON,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	COL2+OFFX,a0
	move	a0,@mess_cursx
	calla	print_string_R

	movi	COL3+OFFX,a0
	move	a0,@mess_cursx
	movi	#str_dash,a4
	calla	print_string2

	move	@temp_record+PR_LOST,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	COL4+OFFX,a0
	move	a0,@mess_cursx
	calla	print_string



	move	@mess_cursy,a0
	addi	YOFF,a0
	move	a0,@mess_cursy

	PULL	a9,a10
;	addi	RS_SIZE,a9
	addi	20h,a9
	dsj	a10,#next_player1b

	rets

#str_wins
	.string	" WINS",0


#streakpals
	.long	OSGCYC7
	.long	OSGCYC6
	.long	OSGCYC5
	.long	OSGCYC4
	.long	OSGCYC3
	.long	OSGCYC2
	.long	OSGCYC1
	.long	BLUE

******************************************************************************
*
* prints rank, initials, games played, average
*
*-----------------------------------------------------------------------------
#method2

	.asg	153,XCOL1		;initials
	.asg	238,XCOL3		;plays
	.asg	310,XCOL5		;average

	movi	LN0_setup,a2
	calla	setup_message
	movi	TYPTEXT,a0
	move	a0,@mess_objid

	movk	8,a10
	movi	record_sort_ptrs,a9

#next_player2
	PUSH	a9,a10

	movi	GOLD,a0
	move	a0,@message_palette,L

	movk	9,a0
	sub	a10,a0				;1-8
	movk	8,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	movi	COL0b,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	COL0,a0
	move	a0,@mess_cursx
	movi	#str_num,a4
	calla	print_string2

	move	*a9,a8,L
	move	*a8(RS_RECORD_NUM),a0
	movi	PKDPR_SIZE*2,a1			;cmos words
	mpyu	a0,a1
	addi	RECORD_ORIGIN,a1
	PUSH	a10
	move	a1,a10
	callr	get_temp_record

	PULL	a0
	sll	5,a0			;x 32 bits
	addi	#exppals-20h,a0
	move	*a0,a0,L
	move	a0,@message_palette,L
	movi	temp_record+PR_INIT1,a4		;* src initials


	movi	message_buffer,a3		;* string dest
	calla	get_initials_string
	movi	XCOL1,a0
	move	a0,@mess_cursx
	calla	print_string_C

	move	@temp_record+PR_COUNT,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	XCOL3,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	#str_dot,a4
	calla	copy_rom_string

	move	*a8(RS_AVERAGE),a0
	jrnz	#not_zip2

	movi	#str_0,a4
	calla	copy_rom_string
	jruc	#skip1b
#not_zip2
	cmpi	1000,a0
	jrlo	#not_max2

	movi	#str_1000,a4
	calla	copy_rom_string
	movi	XCOL5-9,a0
	move	a0,@mess_cursx
	jruc	#skip2b

#not_max2
	movi	999,a1			;max value
	calla	dec_to_pct
	calla	concat_string
#skip1b
	movi	XCOL5,a0
	move	a0,@mess_cursx
#skip2b
	calla	print_string


	move	@mess_cursy,a0
	addi	YOFF,a0
	move	a0,@mess_cursy

	PULL	a9,a10
	addi	20h,a9
	dsj	a10,#next_player2

	rets

#exppals
	.long	OSGCYC7
	.long	OSGCYC6
	.long	OSGCYC5
	.long	OSGCYC4
	.long	OSGCYC3
	.long	OSGCYC2
	.long	OSGCYC1
	.long	BLUE

******************************************************************************
*
* initials only
* champions screen (only prints 3 players)
*
*-----------------------------------------------------------------------------
#method2b

	.asg	132,LCOL1
	.asg	230,LCOL2
	.asg	65,YOFF2

	movi	LN0b_setup,a2
	calla	setup_message
	movi	TYPTEXT,a0
	move	a0,@mess_objid

	movk	3,a10
	movi	record_sort_ptrs,a9

#next_player2b
	PUSH	a9,a10

	movi	LGMDGLD,a0
	move	a0,@message_palette,L

	movi	LCOL1-38,a0
	move	a0,@mess_cursx
	movi	#str_num,a4
	calla	print_string_C2

	movk	4,a0
	sub	a10,a0				;1-3
	movk	3,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	movi	LCOL1,a0
	move	a0,@mess_cursx
	calla	print_string_C

	move	*a9,a8,L
	move	*a8(RS_RECORD_NUM),a0
	movi	PKDPR_SIZE*2,a1			;cmos words
	mpyu	a0,a1
	addi	RECORD_ORIGIN,a1
	PUSH	a10
	move	a1,a10
	callr	get_temp_record

	movi	LCOL2,a0
	move	a0,@mess_cursx

	PULL	a0
	sll	5,a0			;x 32 bits
	addi	#champals-20h,a0
	move	*a0,a0,L
	move	a0,@message_palette,L


	move	@temp_record+PR_NUMDEF,a0
	cmpi	27,a0
	jrge	#is_champ

	movi	LGMDGLD,a0
	move	a0,@message_palette,L

	movi	#str_none,a4
	calla	print_string_C2
	jruc	#not_champ
#is_champ
	movi	temp_record+PR_INIT1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_initials_string
	calla	print_string_C

#not_champ
	move	@mess_cursy,a0
	addi	YOFF2,a0
	move	a0,@mess_cursy

	PULL	a9,a10
	addi	20h,a9
	dsj	a10,#next_player2b

	rets

#str_none
	.string	". . .",0
	.even


#champals
	.long	OSGCYC8
	.long	OSGCYC9
	.long	OSGCYC10


******************************************************************************
*
* prints rank, team name
*
*-----------------------------------------------------------------------------
#method3

	.asg	115,TCOL1
	movi	LN0_setup,a2
	calla	setup_message
	movi	TYPTEXT,a0
	move	a0,@mess_objid

	movk	8,a10
	movi	sorted_teams,a9

#next_team
	PUSH	a9,a10

	movi	GOLD,a0
	move	a0,@message_palette,L

	PUSH	a9
	movk	9,a0
	sub	a10,a0				;1-8
	movk	8,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	movi	COL0b,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	COL0,a0
	move	a0,@mess_cursx
	movi	#str_num,a4
	calla	print_string2

	move	a10,a0
	sll	5,a0			;x 32 bits
	addi	#teampals-20h,a0
	move	*a0,a0,L
	move	a0,@message_palette,L

	movi	TCOL1,a0
	move	a0,@mess_cursx
	PULL	a9
	move	*a9,a0				;team number (0-26)
	sll	5,a0
	addi	#team_names,a0
	move	*a0,a4,L
	calla	print_string2


	move	@mess_cursy,a0
	addi	YOFF,a0
	move	a0,@mess_cursy

	PULL	a9,a10
	addi	10h,a9
	dsj	a10,#next_team
	rets

#teampals
	.long	OSGCYC7
	.long	OSGCYC6
	.long	OSGCYC5
	.long	OSGCYC4
	.long	OSGCYC3
	.long	OSGCYC2
	.long	OSGCYC1
	.long	BLUE


******************************************************************************
#sort_routines
	.long	#sort_wins		;0 (greatest players)
	.long	#sort_champs		;1 (grand champions)
	.long	#sort_exp		;2 (experienced players)
	.long	#sort_streak		;3 (win streaks)
	.long	#sort_teams		;4 (most popular teams)
	.long	#sort_wins		;5
	.long	#sort_wins		;6
	.long	#sort_losses		;7 (worst players!)

#sort_wins
	callr	sort_wins
	rets

#sort_exp
	callr	sort_exp
	rets

#sort_champs
	callr	sort_champs
	rets

#sort_losses
	callr	sort_losses
	rets

#sort_teams
	calla	get_teams_pop
	rets

#sort_streak
	calla	sort_streak
	rets


LN0_setup
	RJR_STR	osgemd_ascii,6,0,200,50,GOLD,0
LN0b_setup
	RJR_STR	lgmd_ascii,6,2,200,50,LGMDGLD,0
#heading1_setup
	RJR_STR	osgemd_ascii,6,0,200,8,ORANGPAL,0
#heading2_setup
	RJR_STR	sgmd8_ascii,3,0,200,29+1,SGMD8YEL,0

#hiscore_mod
	.long	hiscoreBMOD
	.word	0,0
	.long	0

#headings1
	.long	#hd1,#hd2,#hd3,#hd4
	.long	#hd5,#hd6,#hd1,#hd1

#headings2
	.long	#hd21,#hd22,#hd23,#hd24
	.long	#hd25,#hd26,#hd21,#hd21

#hd1	.string	"GREATEST PLAYERS",0
#hd2	.string	"GRAND CHAMPIONS",0
#hd3	.string	"EXPERIENCED PLAYERS",0
#hd4	.string	"LONGEST WINNING STREAK",0
#hd5	.string	"MOST POPULAR TEAMS",0
#hd6	.string	"WORST PLAYERS!",0

#hd21	.string	"( most  games  won )",0
#hd22	.string	"( defeated  all  27  nba  teams )",0
#hd23	.string	"( most  games  played )",0
#hd24	.string	"( consecutive wins )",0
#hd25	.string	"( at  this  location )",0
#hd26	.string	"( worst  average )",0

#str_dash
	.string	"-",0
#str_dot
	.string	".",0
#str_1000
	.string	"1.000",0
#str_0
	.string	".000",0
#str_num
	.string	"#",0

	.even

#team_names
	.long	#t0,#t1,#t2,#t3
	.long	#t4,#t5,#t6,#t7	
	.long	#t8,#t9,#t10,#t11
	.long	#t12,#t13,#t14,#t15
	.long	#t16,#t17,#t18,#t19
	.long	#t20,#t21,#t22,#t23
	.long	#t24,#t25,#t26


#t0	.string	"ATLANTA HAWKS",0
#t1	.string	"BOSTON CELTICS",0
#t2	.string	"CHARLOTTE HORNETS",0
#t3	.string	"CHICAGO BULLS",0
#t4	.string	"CLEVELAND CAVALIERS",0
#t5	.string	"DALLAS MAVERICKS",0
#t6	.string	"DENVER NUGGETS",0
#t7	.string	"DETROIT PISTONS",0
#t8	.string	"GOLDEN STATE WARRIORS",0		;ok
#t9	.string	"HOUSTON ROCKETS",0
#t10	.string	"INDIANA PACERS",0
#t11	.string	"L.A. CLIPPERS",0
#t12	.string	"L.A. LAKERS",0
#t13	.string	"MIAMI HEAT",0
#t14	.string	"MILWAUKEE BUCKS",0
;#t15	.string	"MINNESOTA TIMBERWOLVES",0		;too long
#t15	.string	"MINNESOTA TIMBERWLVS",0
#t16	.string	"NEW JERSEY NETS",0
#t17	.string	"NEW YORK KNICKS",0
#t18	.string	"ORLANDO MAGIC",0
#t19	.string	"PHILADELPHIA 76ERS",0
#t20	.string	"PHOENIX SUNS",0
#t21	.string	"PORTLAND TRAILBLAZERS",0
#t22	.string	"SACRAMENTO KINGS",0
#t23	.string	"SAN ANTONIO SPURS",0
#t24	.string	"SEATTLE SUPERSONICS",0
#t25	.string	"UTAH JAZZ",0
#t26	.string	"WASHINGTON BULLETS",0

	.even

#*****************************************************************************

RECORDS_ONSCREEN	equ	10

 SUBRP	show_player_records

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	.asg	80,COL0
	.asg	90,COL1
	.asg	170,COL2
	.asg	215,COL3
	.asg	280,COL4
	.asg	310,COL5
	.asg	22,YOFF

	movi	osgemd_ascii,a0
;	movi	sgmd8_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	movi	TYPTEXT,a0
	move	a0,@mess_objid

	movk	10,a0
	move	a0,@mess_space_width	;space char width
	clr	a0
	move	a0,@mess_spacing	;spacing between chars


;	movi	GOLD,a0
;	movi	SGMD8YEL,a0
	movi	OSGEMD,a0
	move	a0,@message_palette,L

	clr	a4
#display_loop
	PUSHP	a4
	callr	display_audits


	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank


	movk	6,a10
#loopy
	SLEEPK	1
	calla	get_all_sticks_down2
	move	a0,a0
	jrnz	#got_stick
	dsj	a10,#loopy

#wait_for_input
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit

#got_stick
	PULLP	a4
	calla	get_all_sticks_cur2
	btst	1,a0
	jrz	#no_down
	move	a4,a1
	addi	RECORDS_ONSCREEN,a1
	cmpi	NUM_PRECORDS,a1
	jrhs	#no_down
	addi	RECORDS_ONSCREEN,a4
	jruc	#display_loop
#no_down
	btst	0,a0
	jrz	#no_up
	move	a4,a4
	jrz	#no_up
	subi	RECORDS_ONSCREEN,a4
	jruc	#display_loop
#no_up
	PUSHP	a4
	jruc	#wait_for_input

#exit
	PULLP	a4
	RETP

#*****************************************************************************
*
* INPUT:	a4 = starting record (0 - NUM_PRECORDS-1)
*
*-----------------------------------------------------------------------------

 SUBRP	display_audits

	movi	TYPTEXT,a0		;delete text
	calla	obj_del1c

	movi	20,a0
	move	a0,@mess_cursy		;message cursor pos Y

	movi	PKDPR_SIZE*2,a1		;cmos words
	mpyu	a4,a1
	movi	RECORD_ORIGIN,a10
	add	a1,a10
	movi	RECORDS_ONSCREEN,a6
#search_loop
	PUSH	a6,a10
	PUSH	a4
	
	callr	get_temp_record		;data in temp_record

	movi	str_obr,a4
	calla	copy_rom_string
	clr	a0
	move	a0,@mess_cursx		;message cursor pos X

	PULL	a1
	move	a1,a0
	inc	a1
	PUSH	a1
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	concat_string
	movi	str_cbr,a4
	calla	concat_rom_string
	calla	print_string

	movi	temp_record+PR_INIT1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_initials_string

	movi	COL2,a0
	move	a0,@mess_cursx		;message cursor pos X

	move	@temp_record+PR_COUNT,a0
	jrnz	#not_empty

	movi	str_unused,a4
	calla	print_string_C2
	jruc	#skipit
#not_empty
	calla	print_string_C		;centered

	movi	COL0,a0
	move	a0,@mess_cursx		;message cursor pos X
	move	@temp_record+PR_COUNT,a0
	movi	2047,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string

	movi	COL4,a0
	move	a0,@mess_cursx		;message cursor pos X
	move	@temp_record+PR_LASTPLAY,a0
	movi	2047,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

#skipit

	move	@mess_cursy,a0		;message cursor pos Y
	addi	YOFF,a0
	move	a0,@mess_cursy		;message cursor pos Y

	PULL	a4
	PULL	a6,a10
	addi	PKDPR_SIZE*2,a10	;cmos words
	dsj	a6,#search_loop

	rets

str_num	.string "#",0
str_obr	.string	"(",0
str_cbr	.string	")",0
str_sp	.string	" ",0
str_2sp	.string	"  ",0

str_unused
	.string	"UNUSED",0

#months
	.string	"JAN",0
	.string	"FEB",0
	.string	"MAR",0
	.string	"APR",0
	.string	"MAY",0
	.string	"JUN",0
	.string	"JUL",0
	.string	"AUG",0
	.string	"SEP",0
	.string	"OCT",0
	.string	"NOV",0
	.string	"DEC",0

******************************************************************************
;end

