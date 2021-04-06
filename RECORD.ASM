******************************************************************************
*
* Owner:	JOHNSON
*
* Software:	Jamie Rivett
* Initiated:	9-27-92
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/5/92 19:34
*
*  Updated to account for pin number rather than month and day
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
	.include	"game.equ"
	.include	"world.equ"
	.include	"audit.equ"
	.include	"link.equ"
	.include	"macros.hdr"
	.include	"imgtbl.glo"
	.include	"bgndtbl.glo"

******************************************************************************

	.global	sort_wins
	.global	save_record
	.global	save_player_records

	.global	get_player_record,get_free_record,put_plr_record
	.global	find_record

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
	.global	setup_message
	.global	message_buffer
	.global	get_initials_string
	.global	dec_to_asc,dec_to_pct
	.global	copy_string,copy_rom_string
	.global	concat_string,concat_rom_string
	.global	print_string_R,print_string_R2
	.global	get_name_string
	.global	player_stats
	.global	hiscore_type

******************************************************************************

	.ref	pal_getf
	.ref	morf_pal
	.ref	morfpal1,morfpal2
	.ref	morfpal3,morfpal4
	.ref	morfpal5,morfpal6
	.ref	morfpal7,morfpal8
	.ref	morfpal9,morfpal10
	.ref	morfpal11
	.ref	create_title_bar
	.ref	create_hi_score_page_objs

	.ref	bast18_ascii,brush20_ascii
	.ref	bast8t_ascii,bast8_ascii
	.ref	brush50_ascii

	.ref	CYCLE_TABLE,bounce_snd

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
	.ref	SOUNDSUP
	.ref	mess_line_spacing
	.ref	clear_buffers
	.ref	rndrng0
	.ref	win_snd,GAINED_TXT

******************************************************************************

	.asg	4,REC_MINGAMES		;Min # games req'd for high scores
;
; RECORD equates (for the 'default_records' table)
;
NAME1		equ	0h
NAME2		equ	8h
NAME3		equ	10h
NAME4		equ	18h
NAME5		equ	20h
NAME6		equ	28h
PIN1		equ	30h
PIN2		equ	38h
PIN3		equ	40h
PIN4		equ	48h
GAMPLYD		equ	50h
WINS		equ	60h
WINSTRK		equ	70h
TMSDEF		equ	80h


_30BITS		equ	0111111111111111111111111111111b
_27BITS		equ	0111111111111111111111111111b
_16BITS		equ	01111111111111111b
_11BITS		equ	011111111111b
_10BITS		equ	01111111111b
_8BITS		equ	011111111b
_7BITS		equ	001111111b
_6BITS		equ	000111111b
_5BITS		equ	000011111b
_4BITS		equ	000001111b
_1BIT		equ	000000001b

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


HISCORE_TABLES	equ	9


TEAM_RECORD_ORIGIN  equ   RECORD_ORIGIN+(NUM_PRECORDS*(PKDPR_SIZE*2))+16
WORLD_REC_ORIGIN   equ   TEAM_RECORD_ORIGIN+(NUM_TM_RECORDS*(PKDTR_SIZE*2))+16



	BSSX	player1_data,	PR_SIZE
	BSSX	player2_data,	PR_SIZE
	BSSX	player3_data,	PR_SIZE
	BSSX	player4_data,	PR_SIZE
	.if DRONES_2MORE
	BSSX	player5_data,	PR_SIZE		;always a drone
	BSSX	player6_data,	PR_SIZE		;always a drone
	.endif

;MJT Start
	BSSX	kp_p1_crtplr,	16
	BSSX	kp_p1_name1,	16
	BSSX	kp_p1_name2,	16
	BSSX	kp_p1_name3,	16
	BSSX	kp_p1_name4,	16
	BSSX	kp_p1_name5,	16
	BSSX	kp_p1_name6,	16
	BSSX	kp_p1_hdnbr,	16

	BSSX	kp_p2_crtplr,	16
	BSSX	kp_p2_name1,	16
	BSSX	kp_p2_name2,	16
	BSSX	kp_p2_name3,	16
	BSSX	kp_p2_name4,	16
	BSSX	kp_p2_name5,	16
	BSSX	kp_p2_name6,	16
	BSSX	kp_p2_hdnbr,	16

	BSSX	kp_p3_crtplr,	16
	BSSX	kp_p3_name1,	16
	BSSX	kp_p3_name2,	16
	BSSX	kp_p3_name3,	16
	BSSX	kp_p3_name4,	16
	BSSX	kp_p3_name5,	16
	BSSX	kp_p3_name6,	16
	BSSX	kp_p3_hdnbr,	16

	BSSX	kp_p4_crtplr,	16
	BSSX	kp_p4_name1,	16
	BSSX	kp_p4_name2,	16
	BSSX	kp_p4_name3,	16
	BSSX	kp_p4_name4,	16
	BSSX	kp_p4_name5,	16
	BSSX	kp_p4_name6,	16
	BSSX	kp_p4_hdnbr,	16
;MJT End


	.bss	temp_record,	PR_SIZE
	.bss	packed_record,	((PKDPR_SIZE+15)/16)*16+32
				;word align & pad 32 bits at end

	.bss	player_stats,	PS_SIZE*10h*4

	.bss	packed_tm_record,  ((PKDTR_SIZE+15)/16)*16+32
					;word align & pad 32 bits at end

	.bss	tm_stat_ram,	TR_SIZE
	

	.bss	record_sort_ptrs,	32*NUM_PRECORDS

record_sort_ram	equ	SCRATCH+8*256*1024


	.bss	hiscore_type,	16


	.bss	packed_wrld_record,  ((PKDWR_SIZE+15)/16)*16+32 ;word align & pad 32 bits
	.bss	wrld_recrd_ram,	WR_SIZE
	.bss	hiscore_cnt,16			;nbr of lines of data on screen

	.text


	.asg	0,NAME1A
	.asg	8,NAME2A
	.asg	16,NAME3A
	.asg	24,NAME4A
	.asg	32,NAME5A
	.asg	40,NAME6A
	.asg	48,PIN1A
	.asg	56,PIN2A
	.asg	64,PIN3A
	.asg	72,PIN4A
	.asg	80,WINSTREAK
	.asg	96,NAME1B
	.asg	104,NAME2B
	.asg	112,NAME3B
	.asg	120,NAME4B
	.asg	128,NAME5B
	.asg	136,NAME6B
	.asg	144,PIN1B
	.asg	152,PIN2B
	.asg   	160,PIN3B
	.asg	168,PIN4B
	.asg	176,PTS_IN_GAME
	.asg	192,NAME1C
	.asg	200,NAME2C
	.asg	208,NAME3C
	.asg	216,NAME4C
	.asg	224,NAME5C
	.asg	232,NAME6C
	.asg	240,PIN1C
	.asg	248,PIN2C
	.asg	256,PIN3C
	.asg	264,PIN4C
	.asg	272,REBNDS
	.asg	288,NAME1D
	.asg	296,NAME2D
	.asg	304,NAME3D
	.asg	312,NAME4D
	.asg	320,NAME5D
	.asg	328,NAME6D
	.asg	336,PIN1D
	.asg	344,PIN2D
	.asg	352,PIN3D
	.asg	360,PIN4D
	.asg	368,ASSISTS

;-----------------------------------------------------------------------------
; 		     Reset all cmos world records
;
; Called from FACTORY RESTORE
;-----------------------------------------------------------------------------
 SUBR	reset_world_records

;winstreak
	movi	default_wrld_records,a9,L
	
	movb	*a9(NAME1A),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME1A
	movb	*a9(NAME2A),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME2A
	movb	*a9(NAME3A),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME3A
	movb	*a9(NAME4A),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME4A
	movb	*a9(NAME5A),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME5A
	movb	*a9(NAME6A),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME6A
	movb	*a9(PIN1A),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN1A
	movb	*a9(PIN2A),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN2A
	movb	*a9(PIN3A),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN3A
	movb	*a9(PIN4A),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN4A
	move	*a9(WINSTREAK),a0
	move	a0,@wrld_recrd_ram+WR_WINSTREAK

;points in game
	movb	*a9(NAME1B),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME1B
	movb	*a9(NAME2B),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME2B
	movb	*a9(NAME3B),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME3B
	movb	*a9(NAME4B),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME4B
	movb	*a9(NAME5B),a0
	subi	'@',a0	 
	move	a0,@wrld_recrd_ram+WR_NAME5B
	movb	*a9(NAME6B),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME6B
	movb	*a9(PIN1B),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN1B
	movb	*a9(PIN2B),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN2B
	movb	*a9(PIN3B),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN3B
	movb	*a9(PIN4B),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN4B
	move	*a9(PTS_IN_GAME),a0
	move	a0,@wrld_recrd_ram+WR_PTS_IN_GAME

;rebounds in game
	movb	*a9(NAME1C),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME1C
	movb	*a9(NAME2C),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME2C
	movb	*a9(NAME3C),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME3C
	movb	*a9(NAME4C),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME4C
	movb	*a9(NAME5C),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME5C
	movb	*a9(NAME6C),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME6C
	movb	*a9(PIN1C),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN1C
	movb	*a9(PIN2C),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN2C
	movb	*a9(PIN3C),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN3C
	movb	*a9(PIN4C),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN4C
	move	*a9(REBNDS),a0
	move	a0,@wrld_recrd_ram+WR_REBNDS_IN_GAME

;ASSISTS in game

	movb	*a9(NAME1D),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME1D
	movb	*a9(NAME2D),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME2D
	movb	*a9(NAME3D),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME3D
	movb	*a9(NAME4D),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME4D
	movb	*a9(NAME5D),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME5D
	movb	*a9(NAME6D),a0
	subi	'@',a0
	move	a0,@wrld_recrd_ram+WR_NAME6D
	movb	*a9(PIN1D),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN1D
	movb	*a9(PIN2D),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN2D
	movb	*a9(PIN3D),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN3D
	movb	*a9(PIN4D),a0
	subi	'0',a0
	move	a0,@wrld_recrd_ram+WR_PIN4D
	move	*a9(ASSISTS),a0
	move	a0,@wrld_recrd_ram+WR_ASSISTS_IN_GAME

	callr	put_world_record_in_cmos
	rets						;nope


default_wrld_records
	.string	"DIVITA", "0000"
	.word	2	   		;winstreaks
	.string	"TURMEL", "0000"
	.word	10			;points in game
	.string	"DANIEL", "0000"
	.word	3			;rebounds in game
	.string	"EUGENE", "0000"
	.word	4			;assists in game
	.even


;-----------------------------------------------------------------------------
;	This routine stores the world record values from RAM to CMOS
;-----------------------------------------------------------------------------
 SUBR	put_world_record_in_cmos

	PUSH	a6
	movi	packed_wrld_record,a2
	movi	wrld_recrd_ram,a6

;winstreak
	move	*a6(WR_NAME1A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME1A)

	move	*a6(WR_NAME2A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME2A)

	move	*a6(WR_NAME3A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME3A)

	move	*a6(WR_NAME4A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME4A)

	move	*a6(WR_NAME5A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME5A)

	move	*a6(WR_NAME6A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME6A)

	move	*a6(WR_PIN1A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN1A)

	move	*a6(WR_PIN2A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN2A)

	move	*a6(WR_PIN3A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN3A)

	move	*a6(WR_PIN4A),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN4A)

	move	*a6(WR_WINSTREAK),a0
	andi	_8BITS,a0
	move	a0,*a2(PKDWR_WINSTREAK)

;points in game

	move	*a6(WR_NAME1B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME1B)

	move	*a6(WR_NAME2B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME2B)

	move	*a6(WR_NAME3B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME3B)

	move	*a6(WR_NAME4B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME4B)

	move	*a6(WR_NAME5B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME5B)

	move	*a6(WR_NAME6B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME6B)

	move	*a6(WR_PIN1B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN1B)

	move	*a6(WR_PIN2B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN2B)

	move	*a6(WR_PIN3B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN3B)

	move	*a6(WR_PIN4B),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN4B)

	move	*a6(WR_PTS_IN_GAME),a0
	andi	_8BITS,a0
	move	a0,*a2(PKDWR_PTS_IN_GAME)

;rebounds
	move	*a6(WR_NAME1C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME1C)

	move	*a6(WR_NAME2C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME2C)

	move	*a6(WR_NAME3C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME3C)

	move	*a6(WR_NAME4C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME4C)

	move	*a6(WR_NAME5C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME5C)

	move	*a6(WR_NAME6C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME6C)

	move	*a6(WR_PIN1C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN1C)

	move	*a6(WR_PIN2C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN2C)

	move	*a6(WR_PIN3C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN3C)

	move	*a6(WR_PIN4C),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN4C)

	move	*a6(WR_REBNDS_IN_GAME),a0
	andi	_8BITS,a0
	move	a0,*a2(PKDWR_REBNDS_IN_GAME)

;ASSISTS
	move	*a6(WR_NAME1D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME1D)

	move	*a6(WR_NAME2D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME2D)

	move	*a6(WR_NAME3D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME3D)

	move	*a6(WR_NAME4D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME4D)

	move	*a6(WR_NAME5D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME5D)

	move	*a6(WR_NAME6D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_NAME6D)

	move	*a6(WR_PIN1D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN1D)

	move	*a6(WR_PIN2D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN2D)

	move	*a6(WR_PIN3D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN3D)

	move	*a6(WR_PIN4D),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDWR_PIN4D)

	move	*a6(WR_ASSISTS_IN_GAME),a0
	andi	_8BITS,a0
	move	a0,*a2(PKDWR_ASSISTS_IN_GAME)

	callr	calc_wrld_rec_checksum			;8 bit xor checksum
	andi	_8BITS,a0
	move	a0,*a2(PKDWR_CHECKSUM)

	PUSH	a7
	movi	WORLD_REC_ORIGIN,a7			;start addr.
	movi	PKDWR_SIZE/8,a3			;number bytes to write
	movi	packed_wrld_record,a2
wric_1
	movb	*a2,a0
	calla	WC_BYTEI
	addk	8,a2
	dsj	a3,wric_1

	PULL	a7
	PULL	a6
	rets


;-----------------------------------------------------------------------------
;	    This routine searches the 'world record' record to see if
; this player is in it. 
;
; Called from GAME OVER
;
;
;  INPUT:  nothing
; RETURNS: carry clear if player made the 'world record' record
;-----------------------------------------------------------------------------
 SUBR	update_world_records

	PUSH	a6,a7,a10,a11
	callr	get_world_record_from_cmos	;ret a6 - ptr to ram

	movi	wrld_recrd_ram,a6,L

	move	@PSTATUS2,a0
	btst	0,a0				;plyr 1 in game ?
	jrz	uwr_1				;br=nope
	movi	player1_data,a2,L
	move	*a2(PR_NAME1),a0
	jrle	uwr_1				;br=plyr 1, no initials
	move	*a2(PR_COUNT),a0
	jrn	uwr_1				;br=plyr didn't enter inits.
	movi	player_stats+(0*PS_SIZE*10h),a3
	callr	check_stats_against_world_record

uwr_1	move	@PSTATUS2,a0
	btst	1,a0				;plyr 2 in game ?
	jrz	uwr_2				;br=nope
	movi	player2_data,a2,L
	move	*a2(PR_NAME1),a0
	jrle	uwr_2				;br=plyr 2, no initials
	move	*a2(PR_COUNT),a0
	jrn	uwr_2				;br=plyr didn't enter inits.
	movi	player_stats+(1*PS_SIZE*10h),a3
	callr	check_stats_against_world_record


uwr_2	move	@PSTATUS2,a0
	btst	2,a0				;plyr 3 in game ?
	jrz	uwr_3				;br=nope
	movi	player3_data,a2,L
	move	*a2(PR_NAME1),a0
	jrle	uwr_3				;br=plyr 3, no initials
	move	*a2(PR_COUNT),a0
	jrn	uwr_3				;br=plyr didn't enter inits.
	movi	player_stats+(2*PS_SIZE*10h),a3
	callr	check_stats_against_world_record


uwr_3	move	@PSTATUS2,a0
	btst	3,a0				;plyr 4 in game ?
	jrz	uwr_4				;br=nope
	movi	player4_data,a2,L
	move	*a2(PR_NAME1),a0
	jrle	uwr_4				;br=plyr 4, no initials
	move	*a2(PR_COUNT),a0
	jrn	uwr_4				;br=plyr didn't enter inits.
	movi	player_stats+(3*PS_SIZE*10h),a3
	callr	check_stats_against_world_record
uwr_4
	callr	put_world_record_in_cmos
	PULL	a6,a7,a10,a11
 	rets
	
;-----------------------------------------------------------------------------
;	This routine checks the see if the player beat any of
; the 'world records', if so - update world record
;
; INPUT: reg  a2 - ptr. to player data
; 	 reg  a3 - ptr to player game stat. data
;        reg  a6 - ptr. to ram copy of 'world record' record
;-----------------------------------------------------------------------------
 SUBR	check_stats_against_world_record

	move	a2,a10
	addi	PR_NAME1,a10

;check 'winstreak'
	move	*a2(PR_WINSTREAK),a14
	move	*a6(WR_WINSTREAK),a0
	cmp	a14,a0
	jrhi	csawr_1			      ;br=plyr didn't beat this record
	move	a6,a11
	addi	WR_NAME1A,a11
	callr	replace_world_rec_data

;check 'points in game'
csawr_1
	move	*a3(PS_2PTS_MADE*10h),a0
	move	*a3(PS_3PTS_MADE*10h),a14
	add	a0,a14
	sll	1,a14				;x 2
	add	a0,a14				;3 pts
	move	*a6(WR_PTS_IN_GAME),a0
	cmp	a14,a0
	jrhi	csawr_2			      ;br=plyr didn't beat this record
	move	a6,a11
	addi	WR_NAME1B,a11
	callr	replace_world_rec_data

;check 'rebounds in game'
csawr_2
	move	*a3(PS_OFF_REB*10h),a14
	move	*a3(PS_DEF_REB*10h),a0
	add	a0,a14
	move	*a6(WR_REBNDS_IN_GAME),a0
	cmp	a14,a0
	jrhi	csawr_3			      ;br=plyr didn't beat this record
	move	a6,a11
	addi	WR_NAME1C,a11
	callr	replace_world_rec_data

;check 'assists'
csawr_3
	move	*a3(PS_ASSISTS*10h),a14
	move	*a6(WR_ASSISTS_IN_GAME),a0
	cmp	a14,a0
	jrhi	csawr_4			      ;br=plyr didn't beat this record
	move	a6,a11
	addi	WR_NAME1D,a11
	callr	replace_world_rec_data
csawr_4
	rets


;-----------------------------------------------------------------------------
;    	This routine just replaces the name/pin number in the world record
; with the new champs name/pin number
;
; INPUT: reg. a10 - ptr. to first name letter in player data ram
;        reg. a11 - ptr. to 'world record' name (ram copy)
;        reg. a14 - new world record value to enter
;-----------------------------------------------------------------------------
 SUBR	replace_world_rec_data

	PUSH	a10
	movk	10,a1			;6 letters in name, 4 pin numbers
rwrd_1	move	*a10+,a0			;get data from player record
	move	a0,*a11+			;put data in world record ram copy
	dsj	a1,rwrd_1
	move	a14,*a11				;save new world rec. value
	PULL	a10
 	rets


	.asg	10,PLR_NAME_PIN_CNT
;-----------------------------------------------------------------------------
;	    This routine searches the 'world record' record to see if
; this player is in it.
;
;
;  INPUT:   a2 = ptr to player data (player record)
; RETURNS: a14 = bit number(s) set for which world record (0-3 bits)
;-----------------------------------------------------------------------------
 SUBR	check_world_records

	PUSH	a2
	callr	get_world_record_from_cmos
	PULL	a2
	clr	a14

	movi	wrld_recrd_ram,a6

	move	a6,a5
	move	a2,a3
	addi	PR_NAME1,a3
	addi	WR_NAME1A,a5

;check winstreaks
	movk	PLR_NAME_PIN_CNT,a8		;name + pin number
ipwr_0	move	*a3+,a0
	move	*a5+,a1
	cmp	a0,a1
	jrne	ipwr_2				;br=MATCH for winstreaks
	dsj	a8,ipwr_0
	inc	a14
;	ori	0001h,a14			;plyr. has this WORLD REC.

;check pts per game
ipwr_2	move	a6,a5
	move	a2,a3
	addi	PR_NAME1,a3
	addi	WR_NAME1B,a5

	movi	PLR_NAME_PIN_CNT,a8		;name + pin number
ipwr_3	move	*a3+,a0
	move	*a5+,a1
	cmp	a0,a1
	jrne	ipwr_5				;br=MATCH for pts. per game
	dsj	a8,ipwr_3
	inc	a14
;	ori	0010h,a14			;plyr. has this WORLD REC.

;check rebounds
ipwr_5	move	a6,a5
	move	a2,a3
	addi	PR_NAME1,a3
	addi	WR_NAME1C,a5

	movi	PLR_NAME_PIN_CNT,a8		;name + pin number
ipwr_6	move	*a3+,a0
	move	*a5+,a1
	cmp	a0,a1
	jrne	ipwr_8				;br=MATCH for rebounds
	dsj	a8,ipwr_6
	inc	a14
;	ori	0100h,a14			;plyr. has this WORLD REC.

;check ASSISTS
ipwr_8	move	a6,a5
	move	a2,a3
	addi	PR_NAME1,a3
	addi	WR_NAME1D,a5

	movi	PLR_NAME_PIN_CNT,a8		;name + pin number
ipwr_9	move	*a3+,a0
	move	*a5+,a1
	cmp	a0,a1
	jrne	ipwr_b				;br=MATCH for ASSISTS
	dsj	a8,ipwr_9
	inc	a14
;	ori	1000h,a14			;plyr. has this WORLD REC.
ipwr_b	rets


;-----------------------------------------------------------------------------
;	This routine stores thre world record values from RAM to CMOS
;
; RETURNS: a6 = ptr. to world record ram
;-----------------------------------------------------------------------------
 SUBR	get_world_record_from_cmos

	movi	packed_wrld_record,a2
	movi	PKDWR_SIZE/8,a3			;number bytes to fetch
	movi	WORLD_REC_ORIGIN,a7			;start addr.
gwr_1
	calla	RC_BYTEI
	movb	a0,*a2
	addk	8,a2
	dsj	a3,gwr_1

	movi	packed_wrld_record,a2
	movi	wrld_recrd_ram,a6

;winstreak
	move	*a2(PKDWR_NAME1A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME1A)

	move	*a2(PKDWR_NAME2A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME2A)

	move	*a2(PKDWR_NAME3A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME3A)

	move	*a2(PKDWR_NAME4A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME4A)

	move	*a2(PKDWR_NAME5A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME5A)

	move	*a2(PKDWR_NAME6A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME6A)

	move	*a2(PKDWR_PIN1A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN1A)

	move	*a2(PKDWR_PIN2A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN2A)

	move	*a2(PKDWR_PIN3A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN3A)

	move	*a2(PKDWR_PIN4A),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN4A)

	move	*a2(PKDWR_WINSTREAK),a0
	andi	_8BITS,a0
	move	a0,*a6(WR_WINSTREAK)

;points in game

	move	*a2(PKDWR_NAME1B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME1B)

	move	*a2(PKDWR_NAME2B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME2B)

	move	*a2(PKDWR_NAME3B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME3B)

	move	*a2(PKDWR_NAME4B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME4B)

	move	*a2(PKDWR_NAME5B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME5B)

	move	*a2(PKDWR_NAME6B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME6B)

	move	*a2(PKDWR_PIN1B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN1B)

	move	*a2(PKDWR_PIN2B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN2B)

	move	*a2(PKDWR_PIN3B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN3B)

	move	*a2(PKDWR_PIN4B),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN4B)

	move	*a2(PKDWR_PTS_IN_GAME),a0
	andi	_8BITS,a0
	move	a0,*a6(WR_PTS_IN_GAME)

;rebounds
	move	*a2(PKDWR_NAME1C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME1C)

	move	*a2(PKDWR_NAME2C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME2C)

	move	*a2(PKDWR_NAME3C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME3C)

	move	*a2(PKDWR_NAME4C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME4C)

	move	*a2(PKDWR_NAME5C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME5C)

	move	*a2(PKDWR_NAME6C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME6C)

	move	*a2(PKDWR_PIN1C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN1C)

	move	*a2(PKDWR_PIN2C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN2C)

	move	*a2(PKDWR_PIN3C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN3C)

	move	*a2(PKDWR_PIN4C),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN4C)

	move	*a2(PKDWR_REBNDS_IN_GAME),a0
	andi	_8BITS,a0
	move	a0,*a6(WR_REBNDS_IN_GAME)

;ASSISTS
	move	*a2(PKDWR_NAME1D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME1D)

	move	*a2(PKDWR_NAME2D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME2D)

	move	*a2(PKDWR_NAME3D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME3D)

	move	*a2(PKDWR_NAME4D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME4D)

	move	*a2(PKDWR_NAME5D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME5D)

	move	*a2(PKDWR_NAME6D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_NAME6D)

	move	*a2(PKDWR_PIN1D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN1D)

	move	*a2(PKDWR_PIN2D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN2D)

	move	*a2(PKDWR_PIN3D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN3D)

	move	*a2(PKDWR_PIN4D),a0
	andi	_5BITS,a0
	move	a0,*a6(WR_PIN4D)

	move	*a2(PKDWR_ASSISTS_IN_GAME),a0
	andi	_8BITS,a0
	move	a0,*a6(WR_ASSISTS_IN_GAME)

	move	*a2(PKDWR_CHECKSUM),a1
	andi	_8BITS,a1
	move	a1,*a6(WR_CHECKSUM)
	callr	calc_wrld_rec_checksum			;8 bit xor checksum
	cmp	a0,a1
	jreq	gwr_2					;br=checksums ok.

	.if	DEBUG
	LOCKUP
	eint
	.endif
	callr	reset_world_records
gwr_2
	rets


#*****************************************************************************
* INPUT:	a6 = * temp world record ram
*-----------------------------------------------------------------------------
* RETURN:	a0 = 8 bit checksum value
*
* calculates an 8 bit xor checksum of the player data
*-----------------------------------------------------------------------------
 SUBRP	calc_wrld_rec_checksum

	PUSH	a1
	clr	a0

	move	*a6(WR_NAME1A),a1
	xor	a1,a0
	move	*a6(WR_NAME2A),a1
	xor	a1,a0
	move	*a6(WR_NAME3A),a1
	xor	a1,a0
	move	*a6(WR_NAME4A),a1
	xor	a1,a0
	move	*a6(WR_NAME5A),a1
	xor	a1,a0
	move	*a6(WR_NAME6A),a1
	xor	a1,a0
	move	*a6(WR_PIN1A),a1
	xor	a1,a0
	move	*a6(WR_PIN2A),a1
	xor	a1,a0
	move	*a6(WR_PIN3A),a1
	xor	a1,a0
	move	*a6(WR_PIN4A),a1
	xor	a1,a0
	move	*a6(WR_WINSTREAK),a1
	xor	a1,a0

	move	*a6(WR_NAME1B),a1
	xor	a1,a0
	move	*a6(WR_NAME2B),a1
	xor	a1,a0
	move	*a6(WR_NAME3B),a1
	xor	a1,a0
	move	*a6(WR_NAME4B),a1
	xor	a1,a0
	move	*a6(WR_NAME5B),a1
	xor	a1,a0
	move	*a6(WR_NAME6B),a1
	xor	a1,a0	   
	move	*a6(WR_PIN1B),a1
	xor	a1,a0
	move	*a6(WR_PIN2B),a1
	xor	a1,a0
	move	*a6(WR_PIN3B),a1
	xor	a1,a0
	move	*a6(WR_PIN4B),a1
	xor	a1,a0
	move	*a6(WR_PTS_IN_GAME),a1
	xor	a1,a0

	move	*a6(WR_NAME1C),a1
	xor	a1,a0
	move	*a6(WR_NAME2C),a1
	xor	a1,a0
	move	*a6(WR_NAME3C),a1
	xor	a1,a0
	move	*a6(WR_NAME4C),a1
	xor	a1,a0
	move	*a6(WR_NAME5C),a1
	xor	a1,a0
	move	*a6(WR_NAME6C),a1
	xor	a1,a0	  
	move	*a6(WR_PIN1C),a1
	xor	a1,a0	   
	move	*a6(WR_PIN2C),a1
	xor	a1,a0
	move	*a6(WR_PIN3C),a1
	xor	a1,a0
	move	*a6(WR_PIN4C),a1
	xor	a1,a0
	move	*a6(WR_REBNDS_IN_GAME),a1
	xor	a1,a0

	move	*a6(WR_NAME1D),a1
	xor	a1,a0
	move	*a6(WR_NAME2D),a1
	xor	a1,a0
	move	*a6(WR_NAME3D),a1
	xor	a1,a0
	move	*a6(WR_NAME4D),a1
	xor	a1,a0
	move	*a6(WR_NAME5D),a1
	xor	a1,a0
	move	*a6(WR_NAME6D),a1
	xor	a1,a0	   
	move	*a6(WR_PIN1D),a1
	xor	a1,a0	   
	move	*a6(WR_PIN2D),a1
	xor	a1,a0
	move	*a6(WR_PIN3D),a1
	xor	a1,a0
	move	*a6(WR_PIN4D),a1
	xor	a1,a0
	move	*a6(WR_ASSISTS_IN_GAME),a1
	xor	a1,a0

	andi	_8BITS,a0
	PULL	a1
	rets

#*----------------------------------------------------------------------------
; 		     Clears out all cmos team records
;
; Called from FACTORY RESTORE
;-----------------------------------------------------------------------------
 SUBR	clear_team_records

	clr	a0
	movi	TR_SIZE/16,a1
	movi	tm_stat_ram,a2
#clrit
	move	a0,*a2+
	dsj	a1,#clrit

	movi	NUM_TM_RECORDS,a11			;nbr records
	movi	TEAM_RECORD_ORIGIN,a10			;start addr.
#clear_loop
	PUSH	a10,a11

	callr	put_temp_tm_record		;write out record

	PULL	a10,a11
	addi	PKDTR_SIZE*2,a10	;cmos words
	dsj	a11,#clear_loop
	rets


#*****************************************************************************
* INPUT:	a6  = * team data
*		a10 = * cmos record dest
*-----------------------------------------------------------------------------
 SUBRP	put_temp_tm_record

	PUSH	a6
	movi	tm_stat_ram,a6

	movi	packed_tm_record,a2

	move	*a6(TR_PTS_SCORED),a1
	andi	_16BITS,a1
	move	a1,*a2(PKDTR_PTS_SCORED)	;total points scored

	move	*a6(TR_PTS_ALLOWED),a1	;total points allowed
	andi	_16BITS,a1
	move	a1,*a2(PKDTR_PTS_ALLOWED)

	move	*a6(TR_WINS),a1		;total team wins
	andi	_11BITS,a1
	move	a1,*a2(PKDTR_WINS)

	callr	calc_team_rec_checksum			;8 bit xor checksum
	andi	_8BITS,a0
	move	a0,*a2(PKDTR_TM_CHECKSUM)

	PUSH	a7
	move	a10,a7

	movi	PKDTR_SIZE/8,a3			;number bytes to write
	movi	packed_tm_record,a2
#next_word
	movb	*a2,a0
	calla	WC_BYTEI
	addk	8,a2
	dsj	a3,#next_word

	PULL	a7
	PULL	a6
	rets

;-----------------------------------------------------------------------------
;	   This routine get the appriopate team record from CMOS and stores
; the data in ram
;
; INPUT: a0 = team number (0-NUM_TEAMS)
;
;OUTPUT: a6 = ptr. to team stats ram
;-----------------------------------------------------------------------------
 SUBRP	get_cmos_team_record_into_ram

	callr	get_team_record_from_cmos

;unpack values
	movi	tm_stat_ram,a6,L
	movi	packed_tm_record,a2

	move	*a2(PKDTR_PTS_SCORED),a1	;total points scored
	andi	_16BITS,a1
	move	a1,*a6(TR_PTS_SCORED)

	move	*a2(PKDTR_PTS_ALLOWED),a1	;total points allowed
	andi	_16BITS,a1
	move	a1,*a6(TR_PTS_ALLOWED)

	move	*a2(PKDTR_WINS),a1		;total team wins
	andi	_11BITS,a1
	move	a1,*a6(TR_WINS)

	move	*a2(PKDTR_TM_CHECKSUM),a1
	andi	_8BITS,a1
	move	a1,*a6(TR_TM_CHECKSUM)
	callr	calc_team_rec_checksum			;8 bit xor checksum
	cmp	a0,a1
	jreq	gctrir_2					;br=checksums ok.

	.if	DEBUG
	LOCKUP
	eint
	.endif
	callr	clear_team_records
gctrir_2
	rets


;-----------------------------------------------------------------------------
;	   This routine get the appriopate team record from CMOS and returns
; the pointer to the packed ram
;
; INPUT: a0 = team number (0-NUM_TEAMS-1)
;
;OUTPUT: a2 = ptr. to team stats ram
;	 a7 = ptr. to team stats record
;-----------------------------------------------------------------------------
 SUBRP	get_team_record_from_cmos

	PUSH	a0,a3,a14

;compute offset into team record CMOS based on team number

	movi	TEAM_RECORD_ORIGIN,a7		;start addr. of recs
	move	a0,a0
	jreq	gctr_1				;dont add a offset if 0th team
gctr_0	addi	(PKDTR_SIZE*2),a7		;size of rec in words
	dsj	a0,gctr_0
gctr_1

;read team record into ram
	movi	PKDTR_SIZE/8,a3			;number bytes to fetch
	movi	packed_tm_record,a2
gctr_2
	calla	RC_BYTEI
	movb	a0,*a2
	addk	8,a2
	dsj	a3,gctr_2

	movi	packed_tm_record,a2
 	PULL	a0,a3,a14
	rets



	.asg	0,TM1_SCORE
	.asg	16,TM2_SCORE


;-----------------------------------------------------------------------------
;	   This routine updates the last two NBA teams records which played
; a FULL GAME.
;
;  INPUT: none
; RETURN: none
;-----------------------------------------------------------------------------
 SUBR	update_team_stats_records


;team 1
	move	@PSTATUS2,a0
	andi	011b,a0					;human plyr 1 or 2 ?
	jrz	utsr_2					;br=nope

	move	@team1,a0
	jrn	utsr_2
	callr	get_cmos_team_record_into_ram
	movi	tm_stat_ram,a6,L

	movi	scores,a1				;addr of team scores
	move	*a1(TM1_SCORE),a0			;score from team 1
	srl	1,a0					;divide 1/2 (more resoultion)
	move	*a6(TR_PTS_SCORED),a14
	add	a0,a14
	move	a14,*a6(TR_PTS_SCORED)

	move	*a1(TM2_SCORE),a0			;score from team 2
	srl	1,a0					;divide 1/2 (more resoultion)
	move	*a6(TR_PTS_ALLOWED),a14
	add	a0,a14
	move	a14,*a6(TR_PTS_ALLOWED)

	move	*a1(TM1_SCORE),a0			;score from team 1
	move	*a1(TM2_SCORE),a14			;score from team 2
	cmp	a14,a0					;did team1 win ?
	jrlo	utsr_1					;br=no
	move	*a6(TR_WINS),a0
	inc	a0
	move	a0,*a6(TR_WINS)
utsr_1
	move	@team1,a1
	callr	put_team_record_in_cmos

;team 2
utsr_2
	move	@PSTATUS2,a0
	andi	01100b,a0				;human plyr 3 or 4 ?
	jrz	utsr_4					;br=nope

	move	@team2,a0
	jrn	utsr_4
	callr	get_cmos_team_record_into_ram
	movi	tm_stat_ram,a6,L

	movi	scores,a1				;addr of team scores
	move	*a1(TM2_SCORE),a0			;score from team 2
	srl	1,a0					;divide 1/2 (more resoultion)
	move	*a6(TR_PTS_SCORED),a14
	add	a0,a14
	move	a14,*a6(TR_PTS_SCORED)

	move	*a1(TM1_SCORE),a0			;score from team 1
	srl	1,a0					;divide 1/2 (more resoultion)
	move	*a6(TR_PTS_ALLOWED),a14
	add	a0,a14
	move	a14,*a6(TR_PTS_ALLOWED)

	move	*a1(TM2_SCORE),a0			;score from team 1
	move	*a1(TM1_SCORE),a14			;score from team 2
	cmp	a14,a0					;did team1 win ?
	jrlo	utsr_3					;br=no
	move	*a6(TR_WINS),a0
	inc	a0
	move	a0,*a6(TR_WINS)
utsr_3
	move	@team2,a1
	callr	put_team_record_in_cmos
utsr_4 	rets


;-----------------------------------------------------------------------------
;	This routine saves data from team stat ram to team records
;
; INPUT: reg a0 - NBA team number
;	 reg a6 - ptr. to team stat ram
;-----------------------------------------------------------------------------
 SUBRP	put_team_record_in_cmos

	movi	packed_tm_record,a2

	move	*a6(TR_PTS_SCORED),a0
	andi	_16BITS,a0
	move	a0,*a2(PKDTR_PTS_SCORED)	;total points scored

	move	*a6(TR_PTS_ALLOWED),a0
	andi	_16BITS,a0
	move	a0,*a2(PKDTR_PTS_ALLOWED)	;total points allowed

	move	*a6(TR_WINS),a0
	andi	_11BITS,a0
	move	a0,*a2(PKDTR_WINS)		;total team wins

	callr	calc_team_rec_checksum			;8 bit xor checksum
	andi	_8BITS,a0
	move	a0,*a2(PKDTR_TM_CHECKSUM)

;compute addr of team record
	
	movi	TEAM_RECORD_ORIGIN,a7		;start addr. of recs
	move	a1,a1
	jrz	ptrc_1				;dont add a offset if 0th team
ptrc_0	addi	(PKDTR_SIZE*2),a7		;size of rec in words
	dsj	a1,ptrc_0
ptrc_1
	movi	PKDTR_SIZE/8,a3			;nbr of bytes per rec
	movi	packed_tm_record,a2
ptrc_2
	movb	*a2,a0
	calla	WC_BYTEI
	addk	8,a2
	dsj	a3,ptrc_2
 	rets

;-----------------------------------------------------------------------------
* INPUT:	a6 = * temp team record ram
*-----------------------------------------------------------------------------
* RETURN:	a0 = 8 bit checksum value
*
* calculates an 8 bit xor checksum of the player data
;-----------------------------------------------------------------------------
 SUBRP	calc_team_rec_checksum

	PUSH	a1
	clr	a0
	move	*a6(TR_PTS_SCORED),a1
	xor	a1,a0
	move	*a6(TR_PTS_ALLOWED),a1
	xor	a1,a0
	move	*a6(TR_WINS),a1
	xor	a1,a0
	andi	_8BITS,a0
	PULL	a1
 	rets

;-----------------------------------------------------------------------------
;	This routine computes the TEAMS defensive and offensive rank
;
;
; INPUT:  a0 - NBA team number (0-28)
;RETURN:  a6 - ptr. to team stat. ram
;
; Destroys all registers
;-----------------------------------------------------------------------------
 SUBR	compute_team_def_off_rank

	PUSH	a1
	callr	get_cmos_team_record_into_ram	;ret.a6 - ptr to team stat ram

	movi	NUM_TM_RECORDS,a3		;nbr. records to parse
	movi	NUM_TEAMS-1,a0
	movk	NUM_TEAMS,a4			;current off. rank (worst)
	move	a4,a5				;current def. rank (worst)

	move	*a6(TR_PTS_SCORED),a14
	move	*a6(TR_PTS_ALLOWED),a11
ctor_1
	callr	get_team_record_from_cmos	;get teams stats in packed ram

;offensive rank
	move	*a2(PKDTR_PTS_SCORED),a1
	andi	_16BITS,a1			;unpack pts. scored
	cmp	a14,a1				;is this team worse ?
	jrgt	ctor_2				;br=yes
	dec	a4				;better rank

;defensive rank
ctor_2
	move	*a2(PKDTR_PTS_ALLOWED),a1
	andi	_16BITS,a1			;unpack pts. allowed
	cmp	a11,a1				;is this team worse ?
	jrgt	ctor_3				;br=yes
	dec	a5				;better rank

ctor_3	dsj	a0,ctor_1

	movi	tm_stat_ram,a6,L

	move	a4,a4
	jrgt	ctor_4
	movk	1,a4
ctor_4
	move	a4,*a6(TR_OFF_RANK)

	move	a5,a5
	jrgt	ctor_5
	movk	1,a5
ctor_5
	move	a5,*a6(TR_DEF_RANK)
	PULL	a1
 	rets

#******************************************************************************
*		This routine boosts the players attribute points if he has
* a winning streak.
*******************************************************************************
 SUBR	award_plr_attrib_pts
 
	movk	3,a10				;start with player 4
	clr	a11
#apap_0	
	move	a10,a0
	sll	5,a0
	addi	#plr_data_tbl,a0
	move	*a0,a0,L
	move	*a0(PR_NAME1),a14
	jrle	#nxt
	move	*a0(PR_CREATED_PLYR),a14
	jrle	#nxt
	move	*a0(PR_TOTAL_PTS),a14
	cmpi	69,a14				;too many ?
	jrhs	#nxt				;br=plyr has too many points

	move	*a0(PR_WON),a5

;must add 1 to value if won game, cause stats are not updated yet

	move	@scores,a8
	move	@scores+16,a9
	move	a10,a14
	srl	1,a14
	jrz	#tm1				;br=team 1
	sub	a9,a8
	jrnn	#nxt				;br=lost
	inc	a5
	jruc	#tmd
#tm1
	sub	a8,a9
	jrnn	#nxt				;br=player lost
	inc	a5
#tmd	
	movk	3,a1
	modu	a1,a5				;divide by 3
	jrnz	#nxt				;br=not third win

	movk	2,a9				;2 pts.
	move	*a0(PR_WON),a14
	subk	12,a14				;12 wins ?
	jrle	#wn16				;br=no
	movk	2,a9				;2 pts.
#wn16
	move	*a0(PR_TOTAL_PTS),a14
	add	a9,a14
	move	a14,*a0(PR_TOTAL_PTS)

	move	a10,a9
	sll	4,a9
	addi	#plyr_box_xs,a9
	move	*a9,a9
	sll	16,a9
	move	a9,a0
	movi	[150,0],a1

;create box
	movi	firstwin,a2,L
	movi	20500,a3				;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	ATTRIB_PLAQ_ID,a5		   		;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

;create message

	move	a9,a0
	movi	[150,0],a1
	movi	GAINED_TXT,a2,L
	movi	20600,a3			;z pos (sorting)
	calla	BEGINOBJ2

	inc	a11
	SOUND1	win_snd

#nxt
	dec	a10
	jrge	#apap_0
;	dsj	a10,#apap_0

	move	a11,a11
	jrz	#ext				;br=no plyrs reached level

	SLEEP	175

	movi	ATTRIB_PLAQ_ID,a0
	calla	obj_del1c
#ext	RETP



#plr_data_tbl
	.long	player1_data
	.long	player2_data
	.long	player3_data
	.long	player4_data


#plyr_box_xs
	.word	1,100,200,300



#******************************************************************************
* 		This routine is called from GAME OVER
*******************************************************************************
 SUBRP	save_player_records

	move	@scores,a0			;team 1 scores
	move	@scores+10h,a1			;team 2 scores

;normalize scores, cause maybe someone is fucking with us, cheating to get
; on the high score pages

	cmpi	80,a0
	jrls	#vok
	movi	80,a0
#vok
	cmpi	20,a0
	jrhs	#vok1
	movk	20,a0
#vok1
	cmpi	80,a1
	jrls	#vok2
	movi	80,a1
#vok2
	cmpi	20,a1
	jrhs	#vok3
	movk	20,a1
#vok3
	move	@PSTATUS2,a14
	andi	0011b,a14
	jrz	#chktm2				;br=no humans plyrs on team 1
	move	@player1_data+PR_PTS_SCORED,a14
	add	a0,a14
	move	a14,@player1_data+PR_PTS_SCORED

	move	@player2_data+PR_PTS_SCORED,a14
	add	a0,a14
	move	a14,@player2_data+PR_PTS_SCORED

	move	@player1_data+PR_PTS_ALLOWED,a14
	add	a1,a14
	move	a14,@player1_data+PR_PTS_ALLOWED

	move	@player2_data+PR_PTS_ALLOWED,a14
	add	a1,a14
	move	a14,@player2_data+PR_PTS_ALLOWED

#chktm2
	move	@PSTATUS2,a14
	andi	01100b,a14
	jrz	#chktm				;br=no humans plyrs on team 2
	move	@player3_data+PR_PTS_SCORED,a14
	add	a1,a14
	move	a14,@player3_data+PR_PTS_SCORED

	move	@player4_data+PR_PTS_SCORED,a14
	add	a1,a14
	move	a14,@player4_data+PR_PTS_SCORED

	move	@player3_data+PR_PTS_ALLOWED,a14
	add	a0,a14
	move	a14,@player3_data+PR_PTS_ALLOWED

	move	@player4_data+PR_PTS_ALLOWED,a14
	add	a0,a14
	move	a14,@player4_data+PR_PTS_ALLOWED

#chktm
	move	@scores,a0
	move	@scores+10h,a1
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
	andni	(1<<_CHI) | (1<<_SEA) | (1<<_ORL) | (1<<_SAN) | (1<<_UTA),a1
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
	andni	(1<<_CHI) | (1<<_SEA) | (1<<_ORL) | (1<<_SAN) | (1<<_UTA),a1
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
	move	@player1_data+PR_NAME1,a0
	jrle	#no1
	movi	player1_data,a6
	calla	save_record
#no1
	move	@PSTATUS,a0
	btst	1,a0
	jrz	#no2
	move	@player2_data+PR_NAME1,a0
	jrle	#no2
	movi	player2_data,a6
	calla	save_record
#no2
	move	@PSTATUS,a0
	btst	2,a0
	jrz	#no3
	move	@player3_data+PR_NAME1,a0
	jrle	#no3
	movi	player3_data,a6
	calla	save_record
#no3
	move	@PSTATUS,a0
	btst	3,a0
	jrz	#no4
	move	@player4_data+PR_NAME1,a0
	jrle	#no4
	movi	player4_data,a6
	calla	save_record
#no4
	calla	get_all_records			;resort players
	calla	sort_wins			;for new ranking


	move	@PSTATUS,a0
	btst	0,a0
	jrz	#no1b
	move	@player1_data+PR_NAME1,a0
	jrle	#no1b
	movi	player1_data,a0
	move	a0,*a13(PC_DATADDR),L		;start of player data
	callr	get_player_record		;re-calc rank etc..
#no1b

	move	@PSTATUS,a0
	btst	1,a0
	jrz	#no2b
	move	@player2_data+PR_NAME1,a0
	jrle	#no2b
	movi	player2_data,a0
	move	a0,*a13(PC_DATADDR),L		;start of player data
	callr	get_player_record		;re-calc rank etc..
#no2b

	move	@PSTATUS,a0
	btst	2,a0
	jrz	#no3b
	move	@player3_data+PR_NAME1,a0
	jrle	#no3b
	movi	player3_data,a0
	move	a0,*a13(PC_DATADDR),L		;start of player data
	callr	get_player_record		;re-calc rank etc..
#no3b

	move	@PSTATUS,a0
	btst	3,a0
	jrz	#no4b
	move	@player4_data+PR_NAME1,a0
	jrle	#no4b
	movi	player4_data,a0
	move	a0,*a13(PC_DATADDR),L		;start of player data
	callr	get_player_record		;re-calc rank etc..
#no4b
	PULLP	a0
	move	a0,*a13(PC_DATADDR),L
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
* RETURN:	a14 = stat amount
*
*
* TRASHES:	a0,a1
*-----------------------------------------------------------------------------

 SUBR	get_player_stat

	movi	PS_SIZE,a14
	mpyu	a14,a1			;player number * PS_SIZE
	add	a1,a0			;+ stat offset
	sll	4,a0			;x 16 bits
	addi	player_stats,a0		;+ base address
	move	*a0,a14
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
* INPUT:	a6 = * player data
*-----------------------------------------------------------------------------
* RETURN:	a0 = 8 bit checksum value
*
* calculates an 8 bit xor checksum of the player data
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
	move	*a6(PR_NAME1),a1
	xor	a1,a0
	move	*a6(PR_NAME2),a1
	xor	a1,a0
	move	*a6(PR_NAME3),a1
	xor	a1,a0
	move	*a6(PR_NAME4),a1
	xor	a1,a0
	move	*a6(PR_NAME5),a1
	xor	a1,a0
	move	*a6(PR_NAME6),a1
	xor	a1,a0
	move	*a6(PR_PIN_NBR1),a1
	xor	a1,a0
	move	*a6(PR_PIN_NBR2),a1
	xor	a1,a0
	move	*a6(PR_PIN_NBR3),a1
	xor	a1,a0
	move	*a6(PR_PIN_NBR4),a1
	xor	a1,a0
	move	*a6(PR_TEAMSDEF),a1
	xor	a1,a0
	move	*a6(PR_TEAMSDEF+10h),a1
	xor	a1,a0
	move	*a6(PR_WINSTREAK),a1
	xor	a1,a0
	move	*a6(PR_TOTAL_PTS),a1
	xor	a1,a0
	move	*a6(PR_HEIGHT_PTS),a1
	xor	a1,a0
	move	*a6(PR_WEIGHT_PTS),a1
	xor	a1,a0
	move	*a6(PR_SPEED_PTS),a1
	xor	a1,a0
	move	*a6(PR_POWER_PTS),a1
	xor	a1,a0
	move	*a6(PR_SHOOT_PTS),a1
	xor	a1,a0
	move	*a6(PR_DUNKS_PTS),a1
	xor	a1,a0
	move	*a6(PR_STEAL_PTS),a1
	xor	a1,a0
	move	*a6(PR_BLOCKS_PTS),a1
	xor	a1,a0
	move	*a6(PR_HEAD_NBR),a1
	xor	a1,a0
	move	*a6(PR_CREATED_PLYR),a1
	xor	a1,a0
	move	*a6(PR_NICKNAME_NBR),a1
	xor	a1,a0
	move	*a6(PR_PTS_SCORED),a1
	xor	a1,a0
	move	*a6(PR_PTS_ALLOWED),a1
	xor	a1,a0
	move	*a6(PR_UNIFORM_NBR),a1
	xor	a1,a0
	move	*a6(PR_TRIVIA_PTS),a1
	xor	a1,a0
	move	*a6(PR_PRIVILEGES),a1
	xor	a1,a0
	andi	_8BITS,a0
	PULL	a1
	rets


#*****************************************************************************
* INPUT:	a6  = * player data
*		a10 = * cmos record
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
	andi	_10BITS,a1
	move	a1,*a6(PR_COUNT)

	move	*a2(PKDPR_WON),a0
	andi	_10BITS,a0
	move	a0,*a6(PR_WON)

	sub	a0,a1				;total plays - wins = losses

	move	a1,*a6(PR_LOST)

	move	*a2(PKDPR_LASTPLAY),a0
	andi	_11BITS,a0
	move	a0,*a6(PR_LASTPLAY)

	move	*a2(PKDPR_NAME1),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_NAME1)

	move	*a2(PKDPR_NAME2),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_NAME2)

	move	*a2(PKDPR_NAME3),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_NAME3)

	move	*a2(PKDPR_NAME4),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_NAME4)

	move	*a2(PKDPR_NAME5),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_NAME5)

	move	*a2(PKDPR_NAME6),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_NAME6)

	move	*a2(PKDPR_PIN_NBR1),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_PIN_NBR1)

	move	*a2(PKDPR_PIN_NBR2),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_PIN_NBR2)

	move	*a2(PKDPR_PIN_NBR3),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_PIN_NBR3)

	move	*a2(PKDPR_PIN_NBR4),a0
	andi	_5BITS,a0
	move	a0,*a6(PR_PIN_NBR4)

	move	*a2(PKDPR_TEAMSDEF),a1,L
	andi	_30BITS,a1
	move	a1,*a6(PR_TEAMSDEF),L

	move	*a2(PKDPR_WINSTREAK),a0
	andi	_6BITS,a0
	move	a0,*a6(PR_WINSTREAK)

	move	*a2(PKDPR_TOTAL_PTS),a0
	andi	_7BITS,a0
	move	a0,*a6(PR_TOTAL_PTS)

	move	*a2(PKDPR_HEIGHT_PTS),a0
	andi	_4BITS,a0
	move	a0,*a6(PR_HEIGHT_PTS)

	move	*a2(PKDPR_WEIGHT_PTS),a0
	andi	_4BITS,a0
	move	a0,*a6(PR_WEIGHT_PTS)

	move	*a2(PKDPR_SPEED_PTS),a0
	andi	_4BITS,a0
	move	a0,*a6(PR_SPEED_PTS)

	move	*a2(PKDPR_POWER_PTS),a0
	andi	_4BITS,a0
	move	a0,*a6(PR_POWER_PTS)

	move	*a2(PKDPR_SHOOT_PTS),a0
	andi	_4BITS,a0
	move	a0,*a6(PR_SHOOT_PTS)

	move	*a2(PKDPR_DUNKS_PTS),a0
	andi	_4BITS,a0
	move	a0,*a6(PR_DUNKS_PTS)

	move	*a2(PKDPR_STEAL_PTS),a0
	andi	_4BITS,a0
	move	a0,*a6(PR_STEAL_PTS)

	move	*a2(PKDPR_BLOCKS_PTS),a0
	andi	_4BITS,a0
	move	a0,*a6(PR_BLOCKS_PTS)

	move	*a2(PKDPR_HEAD_NBR),a0
	andi	_8BITS,a0
	move	a0,*a6(PR_HEAD_NBR)

	move	*a2(PKDPR_CREATED_PLYR),a0
	andi	_1BIT,a0
	move	a0,*a6(PR_CREATED_PLYR)

	move	*a2(PKDPR_NICKNAME_NBR),a0
	andi	_6BITS,a0
	move	a0,*a6(PR_NICKNAME_NBR)

	move	*a2(PKDPR_PTS_SCORED),a0
	andi	_16BITS,a0
	move	a0,*a6(PR_PTS_SCORED)

	move	*a2(PKDPR_PTS_ALLOWED),a0
	andi	_16BITS,a0
	move	a0,*a6(PR_PTS_ALLOWED)

	move	*a2(PKDPR_UNIFORM_NBR),a0
	andi	_7BITS,a0
	move	a0,*a6(PR_UNIFORM_NBR)

	move	*a2(PKDPR_TRIVIA_PTS),a0
	andi	_8BITS,a0
	move	a0,*a6(PR_TRIVIA_PTS)

	move	*a2(PKDPR_PRIVILEGES),a0
	andi	_7BITS,a0
	move	a0,*a6(PR_PRIVILEGES)

	PUSH	a2
	clr	a0
	movi	NUM_TEAMS,a2
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
* INPUT:	a6  = * player data
*		a10 = * cmos record dest
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
	andi	_10BITS,a1
	move	a1,*a2(PKDPR_COUNT)

	move	*a6(PR_WON),a0
	andi	_10BITS,a0
	move	a0,*a2(PKDPR_WON)

	sub	a0,a1
	move	a1,*a6(PR_LOST)			;used for calc checksum

	move	*a6(PR_LASTPLAY),a0
	andi	_11BITS,a0
	move	a0,*a2(PKDPR_LASTPLAY)

	move	*a6(PR_NAME1),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_NAME1)

	move	*a6(PR_NAME2),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_NAME2)
	
	move	*a6(PR_NAME3),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_NAME3)

	move	*a6(PR_NAME4),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_NAME4)

	move	*a6(PR_NAME5),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_NAME5)

	move	*a6(PR_NAME6),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_NAME6)

	move	*a6(PR_PIN_NBR1),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_PIN_NBR1)

	move	*a6(PR_PIN_NBR2),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_PIN_NBR2)

	move	*a6(PR_PIN_NBR3),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_PIN_NBR3)

	move	*a6(PR_PIN_NBR4),a0
	andi	_5BITS,a0
	move	a0,*a2(PKDPR_PIN_NBR4)

	move	*a6(PR_TEAMSDEF),a0,L
	andi	_30BITS,a0
	move	a0,*a2(PKDPR_TEAMSDEF),L

	move	*a6(PR_WINSTREAK),a0
	andi	_6BITS,a0
	move	a0,*a2(PKDPR_WINSTREAK)

	move	*a6(PR_TOTAL_PTS),a0
	andi	_7BITS,a0
	move	a0,*a2(PKDPR_TOTAL_PTS)

	move	*a6(PR_HEIGHT_PTS),a0
	andi	_4BITS,a0
	move	a0,*a2(PKDPR_HEIGHT_PTS)

	move	*a6(PR_WEIGHT_PTS),a0
	andi	_4BITS,a0
	move	a0,*a2(PKDPR_WEIGHT_PTS)

	move	*a6(PR_SPEED_PTS),a0
	andi	_4BITS,a0
	move	a0,*a2(PKDPR_SPEED_PTS)

	move	*a6(PR_POWER_PTS),a0
	andi	_4BITS,a0
	move	a0,*a2(PKDPR_POWER_PTS)

	move	*a6(PR_SHOOT_PTS),a0
	andi	_4BITS,a0
	move	a0,*a2(PKDPR_SHOOT_PTS)

	move	*a6(PR_DUNKS_PTS),a0
	andi	_4BITS,a0
	move	a0,*a2(PKDPR_DUNKS_PTS)

	move	*a6(PR_STEAL_PTS),a0
	andi	_4BITS,a0
	move	a0,*a2(PKDPR_STEAL_PTS)

	move	*a6(PR_BLOCKS_PTS),a0
	andi	_4BITS,a0
	move	a0,*a2(PKDPR_BLOCKS_PTS)

	move	*a6(PR_HEAD_NBR),a0
	andi	_8BITS,a0
	move	a0,*a2(PKDPR_HEAD_NBR)

	move	*a6(PR_CREATED_PLYR),a0
	andi	_1BIT,a0
	move	a0,*a2(PKDPR_CREATED_PLYR)

	move	*a6(PR_NICKNAME_NBR),a0
	andi	_6BITS,a0
	move	a0,*a2(PKDPR_NICKNAME_NBR)

	move	*a6(PR_PTS_SCORED),a0
	andi	_16BITS,a0
	move	a0,*a2(PKDPR_PTS_SCORED)

	move	*a6(PR_PTS_ALLOWED),a0
	andi	_16BITS,a0
	move	a0,*a2(PKDPR_PTS_ALLOWED)

	move	*a6(PR_UNIFORM_NBR),a0
	andi	_7BITS,a0
	move	a0,*a2(PKDPR_UNIFORM_NBR)

	move	*a6(PR_TRIVIA_PTS),a0
	andi	_8BITS,a0
	move	a0,*a2(PKDPR_TRIVIA_PTS)

	move	*a6(PR_PRIVILEGES),a0
	andi	_7BITS,a0
	move	a0,*a2(PKDPR_PRIVILEGES)

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
* INPUT:	a6 = * player data
*-----------------------------------------------------------------------------
* RETURN:	a10 = * matching CMOS record (a10 = 0 if no match found)
* 		a11 = record number
*-----------------------------------------------------------------------------
 SUBRP	find_record

	movi	RECORD_SELECT,A1
	calla	SET_PAGE

	clr	a11
	movi	RECORD_ORIGIN,a10
#search_loop
	callr	get_temp_record		;data in temp_record
	callr	compare_record
	jrne	#no_match
	rets

#no_match
	addi	PKDPR_SIZE*2,a10	;cmos words

	inc	a11
	cmpi	NUM_PRECORDS-1,a11
	jrlo	#search_loop
;	dsj	a11,#search_loop
	clr	a10
 	rets


#*****************************************************************************
* INPUT:	NONE
*-----------------------------------------------------------------------------
* RETURN: 	a10 = * free CMOS record
*-----------------------------------------------------------------------------
 SUBRP	get_free_record

	movi	RECORD_SELECT,A1
	calla	SET_PAGE

	movi	1024,a8			;last play count (max)
	movi	NUM_PRECORDS,a11
	movi	RECORD_ORIGIN,a10
	move	a10,a9			;least used record to date
#search_loop
	callr	get_temp_record
;	move	@temp_record+PR_COUNT,a0
;	jrz	#free_record

	move	@temp_record+PR_COUNT,a0
	jrnz	#plyd
	move	@temp_record+PR_CREATED_PLYR,a0
	jrle	#free_record			;br=!created plr & no gme plyd
#plyd
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
* INPUT:	a6 = * player data
*-----------------------------------------------------------------------------
 SUBRP	compare_record

	move	@temp_record+PR_COUNT,a1	;valid record?
	jrnz	#mybe				;br=so far...

	move	@temp_record+PR_CREATED_PLYR,a1	;created player ?
	jrle	#no_match			;br=yes, and no games played

#mybe	move	*a6(PR_NAME1),a0
	move	@temp_record+PR_NAME1,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_NAME2),a0
	move	@temp_record+PR_NAME2,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_NAME3),a0
	move	@temp_record+PR_NAME3,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_NAME4),a0
	move	@temp_record+PR_NAME4,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_NAME5),a0
	move	@temp_record+PR_NAME5,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_NAME6),a0
	move	@temp_record+PR_NAME6,a1
	cmp	a0,a1
	jrne	#no_match

	move	*a6(PR_PIN_NBR1),a0		;just entered pin number #1
	move	@temp_record+PR_PIN_NBR1,a1	;number in players record
	cmp	a0,a1				;do they match ?
	jrne	#no_match			;br=no

	move	*a6(PR_PIN_NBR2),a0		;just entered pin number #2
	move	@temp_record+PR_PIN_NBR2,a1	;number in players record
	cmp	a0,a1				;do they match ?
	jrne	#no_match			;br=no

	move	*a6(PR_PIN_NBR3),a0		;just entered pin number #3
	move	@temp_record+PR_PIN_NBR3,a1	;number in players record
	cmp	a0,a1				;do they match ?
	jrne	#no_match			;br=no

	move	*a6(PR_PIN_NBR4),a0		;just entered pin number #4
	move	@temp_record+PR_PIN_NBR4,a1	;number in players record
	cmp	a0,a1				;do they match ?
	jrne	#no_match			;br=no
	rets					;Z set

#no_match
	movi	1,a0				;clear Z
	rets

#*****************************************************************************
* INPUT:	a4 = cmos record number (0 - NUM_RECORDS-1 )
* RETURN:	a2 = player rank
*	        a9 = ptr to record sort array
*-----------------------------------------------------------------------------
 SUBR	get_plr_rank

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
*-----------------------------------------------------------------------------
 SUBRP	get_player_record

	move	*a13(PC_DATADDR),a6,L		;start of player data

	callr	find_record
	move	a10,a10
	jrz	#no_match
	callr	get_plr_record

;	movi	NUM_PRECORDS,a4
;	sub	a11,a4				;record number

	move	a11,a4

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
	move	a0,*a6(PR_TEAMSDEF),L
	move	a0,*a6(PR_NUMDEF)
	move	a0,*a6(PR_NUMDEFOLD)
	move	a0,*a6(PR_WINSTREAK)
	move	a0,*a6(PR_TOTAL_PTS)
	move	a0,*a6(PR_HEIGHT_PTS)
	move	a0,*a6(PR_WEIGHT_PTS)
	move	a0,*a6(PR_SPEED_PTS)
	move	a0,*a6(PR_POWER_PTS)
	move	a0,*a6(PR_SHOOT_PTS)
	move	a0,*a6(PR_DUNKS_PTS)
	move	a0,*a6(PR_STEAL_PTS)
	move	a0,*a6(PR_BLOCKS_PTS)
	move	a0,*a6(PR_HEAD_NBR)
	move	a0,*a6(PR_CREATED_PLYR)
	move	a0,*a6(PR_NICKNAME_NBR)
	move	a0,*a6(PR_PTS_SCORED)
	move	a0,*a6(PR_PTS_ALLOWED)
	move	a0,*a6(PR_UNIFORM_NBR)
	move	a0,*a6(PR_TRIVIA_PTS)
	move	a0,*a6(PR_PRIVILEGES)
	movi	NUM_PRECORDS,a0
;	movi	300,a0
	move	a0,*a6(PR_RANK)
	rets


#*****************************************************************************
* INPUT:	a6 = * player data
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
	cmpi	1023,a0
	jrhs	#at_max
	inc	a0			;play count (check for wrap!!!)
	move	a0,*a6(PR_COUNT)
#at_max
	move	*a6(PR_LASTPLAY),a0
	addi	50,a0
	cmpi	1023,a0
	jrle	#ok
	movi	1023,a0
#ok
	move	a0,*a6(PR_LASTPLAY)	;zero lastplay count
	move	*a6(PR_NUMDEF),a0
	move	a0,*a6(PR_NUMDEFOLD)
	callr	put_plr_record
	rets


#*****************************************************************************
* decs lastplay count for all records
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

	move	@temp_record+PR_COUNT,a0
	subk	REC_MINGAMES,a0
	jrle	#inval
	move	@temp_record+PR_NAME1,a0
	jrgt	#vldnme
#inval
	movi	500,a14
	move	a14,*a9(RS_OFF_RANK)		;AVG. PTS scored
	movi	7000,a14
	move	a14,*a9(RS_DEF_RANK)		;AVG. PTS allowed
	clr	a14
	move	a14,*a9(RS_TRIVIA_PTS)
	move	a14,*a9(RS_WINS)
	jruc	#nonme
#vldnme
	move	@temp_record+PR_TRIVIA_PTS,a0
	move	a0,*a9(RS_TRIVIA_PTS)

	move	@temp_record+PR_PTS_SCORED,a0
	movi	100,a1				;2 decimal place purcision
	mpyu	a0,a1				;wins*1000
	move	@temp_record+PR_COUNT,a0	;games played
	divu	a0,a1				;wins*
	move	a1,*a9(RS_OFF_RANK)		;AVG. PTS scored

	move	@temp_record+PR_PTS_ALLOWED,a0
	movi	100,a1
	mpyu	a0,a1				;*1000
	move	@temp_record+PR_COUNT,a0	;games played
	divu	a0,a1				;wins*1000/played
	move	a1,*a9(RS_DEF_RANK)		;AVG. PTS allowed

	move	@temp_record+PR_WON,a0		;wins
	move	a0,*a9(RS_WINS)
	jrnz	#has_wins
#nonme
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

	move	@temp_record+PR_NUMDEF,a0	;number teams defeated
	move	a0,*a9(RS_TEAMSDEF)

	move	@temp_record+PR_WINSTREAK,a0
	move	a0,*a9(RS_STREAK)

#cont1
	move	a9,*a12+,L
	addi	RS_SIZE,a9
	addi	PKDPR_SIZE*2,a10	;cmos words
	inc	a11
	cmpi	NUM_PRECORDS,a11
	jrlo	#get_next

	PULL	a12			;process SP
	rets


;-----------------------------------------------------------------------------
;	This routine computes the PLAYERS defensive rank
;
;INPUT: a0 - players defensive ability
; >a0 - players defensive rank
;-----------------------------------------------------------------------------
 SUBR	compute_plyr_def_rank

	PUSH	a2,a9,a10

	movi	record_sort_ptrs,a10,L
	movi	NUM_PRECORDS-1,a2			;loop count
	movi	NUM_PRECORDS-1,a1			;start as worst
cpdr_1
	move	*a10+,a14,L
	move	*a14(RS_DEF_RANK),a14
	cmpi	7000,a14			;brand new record ?
	jreq	cpdr_1a				;br=yep
	cmp	a14,a0				;is this player better ?
	jrgt	cpdr_2				;br=worse rank
cpdr_1a
	dec	a1				;new rank
cpdr_2
	dsj	a2,cpdr_1
	addk	1,a1				;not ZERO rank allowed
	move	a1,a0
cpdr_3	PULL	a2,a9,a10
 	rets

;-----------------------------------------------------------------------------
;	This routine computes the PLAYERS offensive rank
;
;INPUT: a0 - players offensive ability
; >a0 - players offensive rank
;-----------------------------------------------------------------------------
 SUBR	compute_plyr_off_rank

	PUSH	a2,a9,a10

	movi	record_sort_ptrs,a10,L
	movi	NUM_PRECORDS-1,a2			;loop count
	movi	NUM_PRECORDS-1,a1			;start as worst
cpor_1
	move	*a10+,a14,L
	move	*a14(RS_OFF_RANK),a14
	cmp	a14,a0				;is this player better ?
	jrlo	cpor_2				;br=
	dec	a1				;new rank
cpor_2
	dsj	a2,cpor_1
	addk	1,a1				;not ZERO rank allowed
	move	a1,a0
cpor_3	PULL	a2,a9,a10
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
#no_swap
	addi	20h,a9
	dsj	a10,#loop2
	move	a14,a14
	jrz	#done
	dsj	a11,#loop1
#done
	rets


#******************************************************************************
* INPUT:	defeated teams in A1
* RETURN:	a0 = # teams defeated
*------------------------------------------------------------------------------
 SUBR	calc_num_defeated

	PUSH	a1,a2
	clr	a0
	movi	NUM_TEAMS,a2
;;;;	movk	27,a2
#next_team
	srl	1,a1
	jrnc	#not_def
	inc	a0			;teams defeated count ++
#not_def
	dsj	a2,#next_team
	PULL	a1,a2
	rets

#*****************************************************************************
* clears out all cmos player records  (and fills in SPECIAL PLAYER records)
* and puts in defaults for high score table
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

	movk	8,a11			;23 lines in 'team_inits' table

	movi	RECORD_ORIGIN,a10
	movi	#default_records,a9
#init_loop
	PUSH	a9,a10,a11

	movb	*a9(NAME1),a0
	subi	'@',a0
	move	a0,@temp_record+PR_NAME1
	movb	*a9(NAME2),a0
	subi	'@',a0
	move	a0,@temp_record+PR_NAME2
	movb	*a9(NAME3),a0
	subi	'@',a0
	move	a0,@temp_record+PR_NAME3
	movb	*a9(NAME4),a0
	subi	'@',a0
	move	a0,@temp_record+PR_NAME4
	movb	*a9(NAME5),a0
	subi	'@',a0
	move	a0,@temp_record+PR_NAME5
	movb	*a9(NAME6),a0
	subi	'@',a0
	move	a0,@temp_record+PR_NAME6

	movb	*a9(PIN1),a0
	subi	'0',a0
	move	a0,@temp_record+PR_PIN_NBR1

	movb	*a9(PIN2),a0
	subi	'0',a0
	move	a0,@temp_record+PR_PIN_NBR2

	movb	*a9(PIN3),a0
	subi	'0',a0
	move	a0,@temp_record+PR_PIN_NBR3

	movb	*a9(PIN4),a0
	subi	'0',a0
	move	a0,@temp_record+PR_PIN_NBR4

	move	*a9(GAMPLYD),a0
	move	a0,@temp_record+PR_COUNT	;games played

	move	*a9(WINS),a0
	move	a0,@temp_record+PR_WON		;wins

	move	*a9(WINSTRK),a0
	move	a0,@temp_record+PR_WINSTREAK

	clr	a0
	move	a0,@temp_record+PR_NICKNAME_NBR
	move	a0,@temp_record+PR_CREATED_PLYR
	move	a0,@temp_record+PR_TRIVIA_PTS
	move	a0,@temp_record+PR_PRIVILEGES
	movi	150,a0
	move	a0,@temp_record+PR_PTS_SCORED
	movi	350,a0
	move	a0,@temp_record+PR_PTS_ALLOWED

	move	*a9(TMSDEF),a0,L
	move	a0,@temp_record+PR_TEAMSDEF,L

	movi	1023,a0
	move	a0,@temp_record+PR_LASTPLAY


	callr	put_temp_record
	PULL	a9,a10,a11

	addi	10*10h,a9
	addi	PKDPR_SIZE*2,a10	;cmos words
	dsj	a11,#init_loop
	rets


RECMAC	.macro	NAME,PIN_NUM,PLAYED,WINS,STREAK,DEFEATED
	.string	":NAME:"
	.string ":PIN_NUM:"
	.word	:PLAYED:,:WINS:,:STREAK:
	.long	:DEFEATED:
	.endm
	.even
;
; if change number of lines in this table...must change
;  code in 'clear_player_records' (roughly line 1650)
;
#default_records
	RECMAC	"TURMEL", "0000", 5,4,4,000001001000000100010000000000b
;	RECMAC	"JAPPLE", "1111", 28,28,28,001111111111111111111111111111b
	RECMAC	"JAPPLE", "0000", 5,4,4,000001010010000100000000000000b
	RECMAC	"DIVITA", "0000", 5,1,0,000000000000000000000100000000b
	RECMAC	"EUGENE", "0000", 5,3,0,000000000001010100000000000000b
	RECMAC	"JENIFR", "0000", 5,3,2,000010010000010000000000000000b
	RECMAC	"DANIEL", "0000", 5,2,2,000001000010010100000000000000b
	RECMAC	"CARLTN", "0000", 5,2,1,000000001000010000000000000000b
	RECMAC	"CARLOS", "0000", 5,2,0,000000000000000000000000101000b
	RECMAC	"MARTIN", "0000", 5,3,3,000000000010000000001000000001b
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
*		0 = BEST OVERALL PLAYER
*		1 = GRAND CHAMPIONS
*		2 = WORLD RECORDS
*		3 = GREATEST PLAYERS
*		4 = BEST DEFENSIVE PLAYERS
*		5 = BEST OFFENSIVE PLAYERS
*		6 = EXPERIENCED PLAYERS
*		7 = WINNING STREAKS
*		8 = TRIVIA MASTERS
*		7 = MOST POPULAR TEAMS
*
*-----------------------------------------------------------------------------
	.asg	24,YOFF
	.asg	61,COL0			;#
	.asg	COL0+23,COL0b		;1-8
	.asg	160,COL1		;initials
	.asg	253,COL2		;wins
	.asg	COL2+2,COL3		;dash
	.asg	COL3+15,COL4		;losses
	.asg	318,COL5		;average

 SUBR	show_hiscore

	andi	7,a0
	move	a0,@hiscore_type

	callr	get_all_records

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	clr	a0
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

	movk	1,a0
	calla	create_title_bar
	calla	create_hi_score_page_objs

	movi	[1,31],a8			;START COLOR,# COLORS TO CYCLE
	movi	BST18B2_P,a9			;PAL NAME
	movi	BSTCYCB_P,a10
	movk	2,a11				;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE		;START PROCESS TO DO CYCLE

	clr	a0
#loopit
	move	a0,@hiscore_type

	movi	TYPTEXT,a0			;delete text
	calla	obj_del1c
	movi	TYPTEXT+1,a0			;delete text
	calla	obj_del1c
	movi	TYPTEXT+2,a0			;delete text
	calla	obj_del1c
	movi	TYPTEXT+3,a0			;delete text
	calla	obj_del1c
	movi	TYPTEXT+4,a0			;delete text
	calla	obj_del1c
	movi	TYPTEXT+5,a0			;delete text
	calla	obj_del1c
	movi	TYPTEXT+6,a0			;delete text
	calla	obj_del1c
	movi	TYPTEXT+7,a0			;delete text
	calla	obj_del1c
	movi	TYPTEXT+8,a0			;delete text
	calla	obj_del1c

	callr	print_hiscore_heading

	move	@hiscore_type,a0
	sll	5,a0				;x 32 bits
	addi	#sort_routines,a0
	move	*a0,a0,L
	call	a0

	move	@hiscore_type,a0
	sll	5,a0				;x 32 bits
	addi	#print_methods,a0
	move	*a0,a0,L
	JSRPR	a0

	move	@hiscore_type,a0
	jrnz	#no_unblank

;	SLEEPK	1

	movk	1,a0
	move	a0,@DISPLAYON
	calla	display_unblank
#no_unblank

	move	@hiscore_type,a0		;get 'showing' hiscore page
	cmpi	2,a0				;no trans. for first 3 pages
	jrls	#skipt

	movi	3*TSEC,a10
#waitt
	SLEEPK	1
	dsj	a10,#waitd
	move	@hiscore_cnt,a14		;wait until done sliding on
	jrgt	#waitt

#waitd	movi	TYPTEXT+8,a8
	movi	TYPTEXT+1,a9
	CREATE	HISCR_SCALE_PID,create_scale_processes
#skipt
	SLEEPK	25
	movi	6*TSEC,a10
#delay
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit0
	dsj	a10,#delay
	jruc	#exit
#exit0
	movi	HISCR_SCALE_PID,a0
	calla	KIL1C
	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#skipt2			;br=dont do obj. transition
#exit
	movi	HISCR_SCALE_PID,a0
	calla	KIL1C

	move	@hiscore_type,a0	;get 'showing' hiscore page
	cmpi	2,a0			;no trans. for first 3 pages
	jrls	#skipt2

;	SLEEP	120			;delay before wipe off screen

	movi	2*TSEC,a10
#delay1
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#skipt2
	dsj	a10,#delay1
#exit1
	movi	TYPTEXT+1,a8
	movi	TYPTEXT+8,a9
;;	JSRP	explode_screen_clear
	JSRP	slide_lines_right

#skipt2	move	@hiscore_type,a0
	inc	a0
	cmpi	HISCORE_TABLES,a0
	jrle	#loopit

	movi	CYCPID,a0
	calla	KIL1C
	RETP

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
print_hiscore_heading

	movi	#heading1_setup,a2
	calla	setup_message
	move	@hiscore_type,a0
	sll	5,a0				;x 32 bits
	addi	#headings1,a0
	move	*a0,a4,L
	calla	print_string_C2

	movi	#heading2_setup,a2
	calla	setup_message
	move	@hiscore_type,a0
	sll	5,a0				;x 32 bits
	addi	#headings2,a0
	move	*a0,a4,L
	calla	print_string_C2
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


   .def	BSTCYCB_P,BSTCYCY_P

BSTCYCY_P
;   .word   64 
   .word   07f00h,07f20h,07f40h,07f60h,07fa0h,07fe0h,07fefh
   .word   07fffh,07fefh,07fe0h,07f80h,07f20h,07ec0h,07e40h,07de0h
   .word   07e00h,07e40h,07e60h,07ea0h,07ec0h,07f00h,07f20h,07f00h
   .word   07ec0h,07ea0h,07a80h,07a60h,07a20h,07a00h,079e0h,075a0h
   .word   07580h,07560h,075a0h,075c0h,07600h,07a21h,07a61h,07a82h
   .word   07ac3h,07ae3h,07b24h,07b44h,07f65h,07fa6h,07fc6h,07fe7h
   .word   07fe0h,07fe5h,07fech,07ff2h,07ff9h,07fffh,07fdch,07fd8h
   .word   07fb5h,07f91h,07f6eh,07f6ah,07f47h,07f23h,07f20h,07f00h

   .word   07f00h,07f20h,07f40h,07f60h,07fa0h,07fe0h,07fefh
   .word   07fffh,07fefh,07fe0h,07f80h,07f20h,07ec0h,07e40h,07de0h
   .word   07e00h,07e40h,07e60h,07ea0h,07ec0h,07f00h,07f20h,07f00h
   .word   07ec0h,07ea0h,07a80h,07a60h,07a20h,07a00h,079e0h,075a0h
   .word   07580h,07560h,075a0h,075c0h,07600h,07a21h,07a61h,07a82h
   .word   07ac3h,07ae3h,07b24h,07b44h,07f65h,07fa6h,07fc6h,07fe7h
   .word   07fe0h,07fe5h,07fech,07ff2h,07ff9h,07fffh,07fdch,07fd8h
   .word   07fb5h,07f91h,07f6eh,07f6ah,07f47h,07f23h,07f20h,07f00h
   .word   -1


BSTCYCB_P
;   .word   64 
   .word   001f9h,0023ah,0027bh,002bch,0031ch,0035dh,0039eh
   .word   003ffh,003ffh,003dfh,0039fh,0037fh,0035fh,0031fh,002ffh
   .word   002dfh,0029fh,0027fh,0025fh,0025fh,0027fh,0029fh,002bfh
   .word   002dfh,002ffh,0031fh,0033fh,0035fh,0037fh,0039fh,0035fh
   .word   0031fh,002ffh,002bfh,0027fh,0025fh,0025fh,0027fh,0029fh
   .word   0029fh,002bfh,002dfh,002ffh,002ffh,0031fh,0033fh,0033fh
   .word   0035fh,0037fh,0039fh,0039fh,003bfh,0039fh,0035eh,0033dh
   .word   0031dh,002dch,002bch,0029bh,0025bh,0023ah,0021ah,0021ah

   .word   001f9h,0023ah,0027bh,002bch,0031ch,0035dh,0039eh
   .word   003ffh,003ffh,003dfh,0039fh,0037fh,0035fh,0031fh,002ffh
   .word   002dfh,0029fh,0027fh,0025fh,0025fh,0027fh,0029fh,002bfh
   .word   002dfh,002ffh,0031fh,0033fh,0035fh,0037fh,0039fh,0035fh
   .word   0031fh,002ffh,002bfh,0027fh,0025fh,0025fh,0027fh,0029fh
   .word   0029fh,002bfh,002dfh,002ffh,002ffh,0031fh,0033fh,0033fh
   .word   0035fh,0037fh,0039fh,0039fh,003bfh,0039fh,0035eh,0033dh
   .word   0031dh,002dch,002bch,0029bh,0025bh,0023ah,0021ah,0021ah
   .word   -1



;BSTCYCY_P
;   .word   64 
;   .word   00000h,07f00h,07f20h,07f40h,07f60h,07fa0h,07fe0h,07fefh
;   .word   07fffh,07fefh,07fe0h,07f80h,07f20h,07ec0h,07e40h,07de0h
;   .word   07e00h,07e40h,07e60h,07ea0h,07ec0h,07f00h,07f20h,07f00h
;   .word   07ec0h,07ea0h,07a80h,07a60h,07a20h,07a00h,079e0h,075a0h
;   .word   07580h,07560h,075a0h,075c0h,07600h,07a21h,07a61h,07a82h
;   .word   07ac3h,07ae3h,07b24h,07b44h,07f65h,07fa6h,07fc6h,07fe7h
;   .word   07fe0h,07fe5h,07fech,07ff2h,07ff9h,07fffh,07fdch,07fd8h
;   .word   07fb5h,07f91h,07f6eh,07f6ah,07f47h,07f23h,07f20h,07f00h
;   .word   -1





;#morf_plist1
;	.long	GOLD
;	.long	63
;	.long	WHITE2PAL
;	.long	GOLD
;	.long	63
;	.long	WHITEPAL
;	.long	GOLD
;	.long	0
;
;#morf_plist2
;	.long	GOLD
;	.long	55
;	.long	WHITE2PAL
;	.long	GOLD
;	.long	63
;	.long	WHITEPAL
;	.long	GOLD
;	.long	8
;	.long	0
;
;#morf_plist3
;	.long	GOLD
;	.long	48
;	.long	WHITE2PAL
;	.long	GOLD
;	.long	63
;	.long	WHITEPAL
;	.long	GOLD
;	.long	15
;	.long	0
;
;#morf_plist4
;	.long	GOLD
;	.long	41
;	.long	WHITE2PAL
;	.long	GOLD
;	.long	63
;	.long	WHITEPAL
;	.long	GOLD
;	.long	22
;	.long	0
;
;#morf_plist5
;	.long	GOLD
;	.long	34
;	.long	WHITE2PAL
;	.long	GOLD
;	.long	63
;	.long	WHITEPAL
;	.long	GOLD
;	.long	29
;	.long	0
;
;#morf_plist6
;	.long	GOLD
;	.long	27
;	.long	WHITE2PAL
;	.long	GOLD
;	.long	63
;	.long	WHITEPAL
;	.long	GOLD
;	.long	36
;	.long	0
;
;#morf_plist7
;	.long	GOLD
;	.long	20
;	.long	WHITE2PAL
;	.long	GOLD
;	.long	63
;	.long	WHITEPAL
;	.long	GOLD
;	.long	43
;	.long	0
;
;
;#morf_plist10
;	.long	LGMDGLD
;	.long	66
;	.long	LGMDGLDlt
;	.long	LGMDGLD
;	.long	0
;
;#morf_plist9
;	.long	LGMDGLD
;	.long	54
;	.long	LGMDGLDlt
;	.long	LGMDGLD
;	.long	12
;	.long	0
;
;#morf_plist8
;	.long	LGMDGLD
;	.long	42
;	.long	LGMDGLDlt
;	.long	LGMDGLD
;	.long	24
;	.long	0


******************************************************************************
	.even
#print_methods
	.long	#method0		;0 (best overall player)
	.long	#method2b		;1 (grand champions)
	.long	#method6		;2 (world records)
	.long	#method1		;3 (best win %)
	.long	#method1		;4 (most games won)
	.long	#method4		;5 (best offensive player)
	.long	#method5		;6 (best defensive player)
	.long	#method2		;7 (experienced players)
	.long	#method1b		;8 (win streak)
	.long	#method8		;9 (most trivia points)
	.long	#method3		;10 (most popular teams)


	.asg	50,TOP_LINE

	.asg	75,STAT1_X
	.asg	166,STAT1_Y

	.asg	150,STAT2_X
	.asg	166,STAT2_Y

	.asg	213,STAT3_X
	.asg	166,STAT3_Y

	.asg	271,STAT4_X
	.asg	166,STAT4_Y

	.asg	346,STAT5_X
	.asg	166,STAT5_Y

	.asg	70,STAT6_X
	.asg	220,STAT6_Y

	.asg	150,STAT7_X
	.asg	220,STAT7_Y

	.asg	256,STAT8_X
	.asg	220,STAT8_Y

	.asg	341,STAT9_X
	.asg	220,STAT9_Y

******************************************************************************
* prints BEST players name and his/her stats
*-----------------------------------------------------------------------------
#method0

	movi	record_sort_ptrs,a9
	move	*a9,a8,L			;get first rec. sort ptr.
	move	*a8(RS_RECORD_NUM),a0
	movi	PKDPR_SIZE*2,a1			;cmos words
	mpyu	a0,a1
	addi	RECORD_ORIGIN,a1
	move	a1,a10
	callr	get_temp_record

	movi	temp_record+PR_NAME1,a4
	movi	message_buffer,a3		;* string dest
	calla	get_name_string
;print name
	movi	name_str_setup,a2
	calla	setup_message
	calla	print_string_C

;print stats
 	movi	temp_record,a6

	movi	stats_msg_setup,a2
	calla	setup_message

	movk	11,a0
	move	a0,@mess_line_spacing
	movi	stats_msg,a4,L
	calla	print_string_C2

;print wins/loses

	movi	BAST_W_P,a14
	move	a14,@message_palette,L

	movi	STAT1_X,a0
	move	a0,@mess_cursx
	movi	STAT1_Y,a0
	move	a0,@mess_cursy

	move	*a8(RS_WINS),a0
	movi	1024,a1				;max value
	calla	dec_to_asc
	calla	copy_string

	movi	str_sl,a4
	calla	concat_rom_string

	move	*a8(RS_GAMES_PLAYED),a0
	move	*a8(RS_WINS),a14
	sub	a14,a0
	movi	1024,a1				;max value
	calla	dec_to_asc
	calla	concat_string
	calla	print_string_C

;print win streak

	movi	STAT2_X,a0
	move	a0,@mess_cursx
	movi	STAT2_Y,a0
	move	a0,@mess_cursy

	move	*a8(RS_STREAK),a0
	movi	1024,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_C

;print win avg

	movi	STAT3_X,a0
	move	a0,@mess_cursx
	movi	STAT3_Y,a0
	move	a0,@mess_cursy

	movi	str_per,a4,L
	calla	copy_rom_string

	move	*a8(RS_AVERAGE),a0
	cmpi	1000,a0
	jrlo	#nmax

	movi	#str_1000,a4
	calla	copy_rom_string
	jruc	#skp2
#nmax
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	concat_string
#skp2	calla	print_string_C

;print defensive rank

	movi	STAT4_X,a0
	move	a0,@mess_cursx
	movi	STAT4_Y,a0
	move	a0,@mess_cursy

	move	*a8(RS_DEF_RANK),a0
	callr	compute_plyr_def_rank
	movi	NUM_PRECORDS,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_C

;print offensive rank

	movi	STAT5_X,a0
	move	a0,@mess_cursx
	movi	STAT5_Y,a0
	move	a0,@mess_cursy

	move	*a8(RS_OFF_RANK),a0
	callr	compute_plyr_off_rank
	movi	NUM_PRECORDS,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_C

;print avg. pts scored
	
	movi	STAT6_X,a0
	move	a0,@mess_cursx
	movi	STAT6_Y,a0
	move	a0,@mess_cursy

	move	*a8(RS_OFF_RANK),a7
	callr	print_playing_rank

;print avg. pts allowed
	
	movi	STAT7_X,a0
	move	a0,@mess_cursx
	movi	STAT7_Y,a0
	move	a0,@mess_cursy

	move	*a8(RS_DEF_RANK),a7
	callr	print_playing_rank

;print teams defeated

	movi	STAT8_X,a0
	move	a0,@mess_cursx
	movi	STAT8_Y,a0
	move	a0,@mess_cursy

	move	*a8(RS_TEAMSDEF),a0
	movi	NUM_TEAMS,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_C
	
;print games played

	movi	STAT9_X,a0
	move	a0,@mess_cursx
	movi	STAT9_Y,a0
	move	a0,@mess_cursy

	move	*a8(RS_GAMES_PLAYED),a0
	movi	2048,a1				;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_C

	RETP


name_str_setup
	PRINT_STR	brush50_ascii,10,0,200,60,BRSH50G_P,0

stats_msg_setup
	PRINT_STR	bast8_ascii,6,0,215,140,BAST_Y_P,0

stats_msg
	.string	"  WIN         WIN      WIN   DEFENSIVE  OFFENSIVE",1
	.string	"RECORD    STREAK   AVG.     RANK       RANK  ",1
	.string	"",1
	.string	"",1
	.string	"",1
	.string	"AVG. PTS.   AVG. PTS.      TEAMS       GAMES  ",1
	.string	" SCORED     ALLOWED    DEFEATED     PLAYED  ",0
;	.string	"  SCORED    ALLOWED     DEFEATED    PLAYED  ",0
	.even

str_sl
	.string	"/",0
	.even

str_per
	.string	".",0
	.even


******************************************************************************
* prints 8 players trivia points total
*-----------------------------------------------------------------------------
#method8
	
	.asg	96,OFFX

	movi	LN0_setup,a2
	calla	setup_message

	movi	260,a0
	move	a0,@mess_cursy			;draw data off-screen

	movk	8,a10
	move	a10,@hiscore_cnt

	movi	record_sort_ptrs,a9

	movi	TOP_LINE,a11			;start Y (rank #1)

#nxt_plr
	PUSHP	a9,a10

	move	@mess_objid,a0
	addk	1,a0
	move	a0,@mess_objid			;ID+1 from hiscore heading

    	movk	9,a0
	sub	a10,a0				;1-8
	move	a0,a14

	sll	5,a14
	addi	#winpals-20h,a14
	move	*a14,a14,L
	move	a14,@message_palette,L

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
	move	a1,a10
	callr	get_temp_record

	movi	temp_record+PR_NAME1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_name_string
	movi	COL1,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	COL4+23,a0
	move	a0,@mess_cursx
	move	@temp_record+PR_TRIVIA_PTS,a0
	movi	999,a1				;max value (6 bits in record)
	calla	dec_to_asc
	calla	copy_string
	movi	#str_pts,a4
	calla	concat_rom_string
	calla	print_string_C

;	move	@mess_cursy,a0
;	addi	YOFF,a0
;	move	a0,@mess_cursy

	move	@mess_objid,a8
	CREATE0	slide_line_up

	addi	YOFF,a11

	PULLP	a9,a10
	addi	20h,a9
	dsj	a10,#nxt_plr
	RETP

#str_pts
	.string	"  PTS.",0
	.even


******************************************************************************
* prints 8 players offensive ratings
*-----------------------------------------------------------------------------
#method4

	movi	LN0_setup,a2
	calla	setup_message

	movi	260,a0
	move	a0,@mess_cursy			;draw data off-screen

	movk	8,a10
	move	a10,@hiscore_cnt

	movi	record_sort_ptrs,a9

	movi	TOP_LINE,a11			;start Y (rank #1)
#meth4
	PUSHP	a9,a10

	move	@mess_objid,a0
	addk	1,a0
	move	a0,@mess_objid			;ID+1 from hiscore heading

    	movk	9,a0
	sub	a10,a0				;1-8

	move	a0,a14
	sll	5,a14			;x 32 bits
	addi	#teampals-20h,a14
	move	*a14,a14,L
	move	a14,@message_palette,L

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
	move	a1,a10
	callr	get_temp_record

	movi	temp_record+PR_NAME1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_name_string
	movi	COL1,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	COL4,a0
	move	a0,@mess_cursx

	calla	clear_buffers

	move	*a8(RS_OFF_RANK),a7
	callr	print_playing_rank
;	callr	print_off_rank

	move	@mess_objid,a8
	CREATE0	slide_line_up

	addi	YOFF,a11

	PULLP	a9,a10
	addi	20h,a9
	dsj	a10,#meth4
	RETP

;-----------------------------------------------------------------------------
;	This routine prints the OFFENSIVE or DEFENSIVE rank
;
; reg a7 - defensive or offensive value
;-----------------------------------------------------------------------------
 SUBRP	print_playing_rank

	calla	clear_buffers

	clr	a6
	movi	100,a1				;max value
	divu	a1,a6

	move	a6,a0
	movi	99,a1				;max value
	calla	dec_to_asc
	calla	concat_string

	movi	#str_dot,a4
	calla	concat_rom_string

	move	a7,a0
	movi	99,a1				;max value
	calla	dec_to_asc
	calla	concat_string
	calla	print_string
	rets

;	jruc	pdr_2
;pdr_1
;	movi	str_00,a4
;	calla	print_string2
;pdr_2	rets
;
;
;str_00
;	.string	"00.00",0
;	.even


******************************************************************************
* prints 8 players defensive ratings
*-----------------------------------------------------------------------------
#method5

	movi	LN0_setup,a2
	calla	setup_message

	movi	260,a0
	move	a0,@mess_cursy			;draw data off-screen

	movk	8,a10
	move	a10,@hiscore_cnt

	movi	record_sort_ptrs,a9

	movi	TOP_LINE,a11			;start Y (rank #1)
#meth5
	PUSHP	a9,a10

	move	@mess_objid,a0
	addk	1,a0
	move	a0,@mess_objid			;ID+1 from hiscore heading

    	movk	9,a0
	sub	a10,a0				;1-8

	move	a0,a14
	sll	5,a14			;x 32 bits
	addi	#teampals-20h,a14
	move	*a14,a14,L
	move	a14,@message_palette,L

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
	move	a1,a10
	callr	get_temp_record

	movi	temp_record+PR_NAME1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_name_string
	movi	COL1,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	COL4,a0
	move	a0,@mess_cursx

	calla	clear_buffers

	move	*a8(RS_DEF_RANK),a7
	callr	print_playing_rank
;	callr	print_def_rank

	move	@mess_objid,a8
	CREATE0	slide_line_up

	addi	YOFF,a11

	PULLP	a9,a10
	addi	20h,a9
	dsj	a10,#meth5
	RETP



	.asg	200,WINSTRK_X
	.asg	58,WINSTRK_Y
	.asg	200,PTS_X
	.asg	WINSTRK_Y+40,PTS_Y
	.asg	200,ASSISTS_X
	.asg	PTS_Y+40,ASSISTS_Y
	.asg	200,REBNDS_X
	.asg	ASSISTS_Y+40,REBNDS_Y

******************************************************************************
* prints world records
*-----------------------------------------------------------------------------
#method6

;print 'winstreaks' title
	movi	winstrk_msg_setup1,a2
	calla	setup_message
	movi	wrld_rec_msg1,a4,L
	calla	print_string_C2


;print 'points in game' title
	movi	PTS_Y,a0
	move	a0,@mess_cursy
	movi	wrld_rec_msg2,a4,L
	calla	print_string_C2

;print 'assists' title
	movi	ASSISTS_Y,a0
	move	a0,@mess_cursy
	movi	wrld_rec_msg3,a4,L
	calla	print_string_C2

;print 'rebounds' title 
	movi	REBNDS_Y,a0
	move	a0,@mess_cursy
	movi	wrld_rec_msg4,a4,L
	calla	print_string_C2

	callr	get_world_record_from_cmos

;winstreak data
	movi	wrld_recrd_ram+WR_NAME1A,a4	;* src NAME
	movi	message_buffer,a3		;* string dest
	calla	get_name_string

	movi	winstrk_msg_setup2,a2
	calla	setup_message
	calla	print_string_C

	movi	message_buffer,a3		;* string dest
	clr	a0
	move	a0,*a3,L

	move	@mess_cursx,a0
	addi	100,a0
	move	a0,@mess_cursx

	move	@wrld_recrd_ram+WR_WINSTREAK,a0	;* src NAME
	movi	256,a1
	calla	dec_to_asc
	calla	concat_string
	calla	print_string_C

;points per game data
	movi	wrld_recrd_ram+WR_NAME1B,a4	;* src NAME
	movi	message_buffer,a3		;* string dest
	calla	get_name_string

	movi	pts_game_msg_setup2,a2
	calla	setup_message
	calla	print_string_C

	movi	message_buffer,a3		;* string dest
	clr	a0
	move	a0,*a3,L

	move	@mess_cursx,a0
	addi	100,a0
	move	a0,@mess_cursx

	move	@wrld_recrd_ram+WR_PTS_IN_GAME,a0	;* src NAME
	movi	256,a1
	calla	dec_to_asc
	calla	concat_string
	calla	print_string_C

;assists data
	movi	wrld_recrd_ram+WR_NAME1D,a4	;* src NAME
	movi	message_buffer,a3		;* string dest
	calla	get_name_string

	movi	assists_msg_setup2,a2
	calla	setup_message
	calla	print_string_C

	movi	message_buffer,a3		;* string dest
	clr	a0
	move	a0,*a3,L

	move	@mess_cursx,a0
	addi	100,a0
	move	a0,@mess_cursx

	move	@wrld_recrd_ram+WR_ASSISTS_IN_GAME,a0	;* src NAME
	movi	256,a1
	calla	dec_to_asc
	calla	concat_string
	calla	print_string_C

;rebounds data
	movi	wrld_recrd_ram+WR_NAME1C,a4	;* src NAME
	movi	message_buffer,a3		;* string dest
	calla	get_name_string

	movi	rebnd_msg_setup2,a2
	calla	setup_message
	calla	print_string_C

	movi	message_buffer,a3		;* string dest
	clr	a0
	move	a0,*a3,L

	move	@mess_cursx,a0
	addi	100,a0
	move	a0,@mess_cursx

	move	@wrld_recrd_ram+WR_REBNDS_IN_GAME,a0	;* src NAME
	movi	256,a1
	calla	dec_to_asc
	calla	concat_string
	calla	print_string_C
	RETP



winstrk_msg_setup1
	PRINT_STR	bast8_ascii,6,0,WINSTRK_X,WINSTRK_Y,BAST_W_P,0

winstrk_msg_setup2
	PRINT_STR	brush20_ascii,6,0,WINSTRK_X,WINSTRK_Y+10,BRSHGYGP,0

pts_game_msg_setup2
;	PRINT_STR	bast18_ascii,6,0,PTS_X,PTS_Y+10,BST18Y_P,0
	PRINT_STR	brush20_ascii,6,0,PTS_X,PTS_Y+10,BRSHGYGP,0

assists_msg_setup2
	PRINT_STR	brush20_ascii,6,0,ASSISTS_X,ASSISTS_Y+10,BRSHGYGP,0

rebnd_msg_setup2
	PRINT_STR	brush20_ascii,6,0,REBNDS_X,REBNDS_Y+10,BRSHGYGP,0


wrld_rec_msg1
	.string	"WINSTREAK",0
	.even

wrld_rec_msg2
	.string	"POINTS IN GAME",0
	.even

wrld_rec_msg3
	.string	"ASSISTS IN GAME",0
	.even

wrld_rec_msg4
	.string	"REBOUNDS IN GAME",0
	.even

******************************************************************************
* prints rank, name, win-loss, average
*-----------------------------------------------------------------------------
#method1

	movi	LN0_setup,a2
	calla	setup_message

	movi	260,a0
	move	a0,@mess_cursy			;draw data off-screen

	movk	8,a10				;nbr. of lines (8 ranks)
	move	a10,@hiscore_cnt

	movi	record_sort_ptrs,a9
	
	movi	TOP_LINE,a11			;start Y (rank #1)

#next_player
	PUSHP	a9,a10

	move	@mess_objid,a0
	addk	1,a0
	move	a0,@mess_objid			;ID+1 from hiscore heading

	movk	9,a0
	sub	a10,a0				;1-8
	move	a0,a14

	sll	5,a14
	addi	#winpals-20h,a14
	move	*a14,a14,L
	move	a14,@message_palette,L

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
	move	a1,a10
	callr	get_temp_record

	movi	temp_record+PR_NAME1,a4		;* src NAME
	movi	message_buffer,a3		;* string dest
	calla	get_name_string
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
#skip1	movi	COL5,a0
	move	a0,@mess_cursx
#skip2	calla	print_string

	move	@mess_objid,a8
	CREATE0	slide_line_up

	addi	YOFF,a11

	PULLP	a9,a10
	addi	20h,a9
	dsj	a10,#next_player
	RETP


#winpals
	.long	BST18B2_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P

;-----------------------------------------------------------------------------
;	This routine moves all objects, in the ID range, offscreen
;
; INPUT: reg a8 - starting OBJ id to move
;	 reg a9 - last OBJ id to move
;-----------------------------------------------------------------------------
 SUBR	slide_lines_right

	PUSHP	a1,a2,a3

;set obj. velocities
	clr	a11
	move	a8,a10
slr_00
	movi	OBJLST,a2
	move	*a2,a2,L			;get next obj. ptr
	jrz	slr_5				;br=no obj. list
slr_0
	move	*a2(OID),a14
	cmp	a10,a14				;is ID > than range start ?
	jrne	slr_1				;br=nope

	inc	a11				;count nbr. of matching ID's

	movi	[30,0],a14
	move	a14,*a2(OXVEL),L
	movi	[0,0],a14
	move	a14,*a2(OYVEL),L

slr_1	move	*a2,a2,L
	jrnz	slr_0

	SLEEPK	5

	inc	a10
	cmp	a9,a10
	jrls	slr_00


;watch objs until get to dest. (offscreen)

	movi	40,a10				;MAX time (40 ticks)
slr_2
	SLEEPK	1
	dec	a10
	jrle	slr_5				;br=exceeded max loop count

	movi	OBJLST,a2
slr_3
	move	*a2,a2,L			;get next obj. ptr
	jrz	slr_2				;br=no obj. lst

	move	*a2(OID),a14
	cmp	a8,a14				;is ID > than range start ?
	jrlo	slr_3				;br=nope
	cmp	a9,a14				;is ID <= than range end ?
	jrhi	slr_3				;br=nope

	move	*a2(OXPOS),a14			;get obj X
	cmpi	460,a14				;obj off rght edge of screen ?
	jrlo	slr_3				;br=nope

	move	*a2(OXVEL),a14,L
	jrz	slr_3				;br=vel. already cleared

	clr	a14
	move	a14,*a2(OXVEL),L		;stop obj. from moving
	dsj	a11,slr_3			;br=more objs. to watch
slr_5
	PULLP	a1,a2,a3
	RETP

;-----------------------------------------------------------------------------
;     This PROCESS just launches other processes to scale the hi-score data
;
; INPUT: reg a8 - first OBJ id to scale (highest)
;	 reg a9 - last OBJ id to scale	(lowest)
;-----------------------------------------------------------------------------
 SUBRP	create_scale_processes

#cscl	SLEEPK	10

	CREATE	HISCR_SCALE_PID,scale_hiscore_lines
	dec	a8
	cmp	a8,a9
	jrls	#cscl
 	DIE

;-----------------------------------------------------------------------------
;	      This PROCESS scales objects with matching ID
;
; INPUT: reg a8 - OBJ id to scale
;-----------------------------------------------------------------------------
 SUBRP	scale_hiscore_lines

	SLEEP	27				;delay before start

	movk	2,a10				;do scale effect twice
shl_0a
	movi	hiscr_scl_tbl,a11,L		;table of scale steps
shl_0b
	movi	OBJLST,a0
	move	*a0,a0,L			;get next obj. ptr
	jrz	shl_5				;br=no obj. list
shl_0
	move	*a0(OID),a14
	cmp	a8,a14				;does ID match ?
	jrne	shl_1				;br=nope

	move	*a11,a14,L			;get new scale factor
	move	a14,*a0(OSCALE),L

;found matching object ID

shl_1
	move	*a0,a0,L
	jrnz	shl_0
shl_5
	SLEEPK	2

	addi	32,a11
	move	*a11,a0,L			;point to next line in table
	jrnz	shl_0b

	SLEEP	85

	dsj	a10,shl_0a			;next obj. ID
 	DIE


hiscr_scl_tbl
	.long	01140114h
	.long	01280128h
	.long	013c013ch
	.long	01500150h
	.long	01640164h
	.long	01780178h
	.long	01640164h
	.long	01500150h
	.long	013c013ch
	.long	01280128h
	.long	01140114h
	.long	01000100h	;back to reg. size (1 to 1)
	.long	0


;hiscr_scl_tbl2
;	.long	01140114h
;	.long	01280128h
;	.long	013c013ch
;	.long	01500150h
;	.long	01640164h
;	.long	01780178h
;	.long	018C018Ch
;	.long	0

;-----------------------------------------------------------------------------
;	This PROCESS gives a velocity to all obj. with matching ID
;
; INPUT:  a8 - obj id
;        a11 - destination Y coor.
;-----------------------------------------------------------------------------
 SUBR	slide_line_up
 	
;set velocities

	movi	OBJLST,a0
	move	*a0,a0,L			;get next obj. ptr
	jrz	sinl_5				;br=no obj. list
sinl_0
	move	*a0(OID),a14
	cmp	a14,a8
	jrne	sinl_1
	movi	[-10,0],a14
	move	a14,*a0(OYVEL),L
sinl_1
	move	*a0,a0,L
	jrnz	sinl_0

;now watch obj. until get to dest.

sinl_1a
	SLEEPK	1
	movi	OBJLST,a0
sinl_2
	move	*a0,a0,L			;get next obj. ptr
	jrz	sinl_5				;br=no ID match found, exit
	move	*a0(OID),a14
	cmp	a14,a8				;do ID's match ?
	jrne	sinl_2				;br=no
	move	*a0(OYPOS),a14			;get obj Y
	cmp	a14,a11				;any obj. at dest. ?
	jrlt	sinl_1a				;br=no

;obj at dest.

	movi	OBJLST,a0
sinl_3
	move	*a0,a0,L			;get next obj. ptr
	jrz	sinl_5				;br=no ID match found, exit
	move	*a0(OID),a14
	cmp	a14,a8				;do ID's match ?
	jrne	sinl_3				;br=no
	clr	a14
	move	a14,*a0(OYVEL),L		;stop obj. from moving

;account for img. Y offset
	move	*a0(OIMG),a14,L
	move	*a14(IANIOFFY),a14
	move	a11,a9
	sub	a14,a9
	move	a9,*a0(OYPOS)			;set Y coor.
	jruc	sinl_3
sinl_5	
	move	@hiscore_cnt,a14
	dec	a14
	move	a14,@hiscore_cnt
	DIE




******************************************************************************
* prints rank, name, streak, average
*-----------------------------------------------------------------------------
#method1b

	.asg	96,OFFX

	movi	LN0_setup,a2
	calla	setup_message

	movi	260,a0
	move	a0,@mess_cursy			;draw data off-screen

	movk	8,a10
	move	a10,@hiscore_cnt

	movi	record_sort_ptrs,a9

	movi	TOP_LINE,a11			;start Y (rank #1)

#next_player1b
	PUSHP	a9,a10

	move	@mess_objid,a0
	addk	1,a0
	move	a0,@mess_objid			;ID+1 from hiscore heading

    	movk	9,a0
	sub	a10,a0				;1-8
	move	a0,a14

	sll	5,a14
	addi	#winpals-20h,a14
	move	*a14,a14,L
	move	a14,@message_palette,L

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
	move	a1,a10
	callr	get_temp_record

	movi	temp_record+PR_NAME1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_name_string
	movi	COL1,a0
	move	a0,@mess_cursx
	calla	print_string_C

	movi	COL4+22,a0
	move	a0,@mess_cursx
	move	@temp_record+PR_WINSTREAK,a0
	movi	64,a1				;max value (6 bits in record)
	calla	dec_to_asc
	calla	copy_string
	movi	#str_wins,a4
	calla	concat_rom_string
	calla	print_string_C

	move	@mess_objid,a8
	CREATE0	slide_line_up

	addi	YOFF,a11

	PULLP	a9,a10
	addi	20h,a9
	dsj	a10,#next_player1b
	RETP


#str_wins
	.string	"  WINS",0
	.even


#streakpals
	.long	BST18B2_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P

******************************************************************************
* prints rank, name, games played, average
*-----------------------------------------------------------------------------
#method2

	movi	LN0_setup,a2
	calla	setup_message

	movi	260,a0
	move	a0,@mess_cursy			;draw data off-screen

	movk	8,a10
	move	a10,@hiscore_cnt

	movi	record_sort_ptrs,a9

	movi	TOP_LINE,a11			;start Y (rank #1)

#next_player2
	PUSHP	a9,a10

	move	@mess_objid,a0
	addk	1,a0
	move	a0,@mess_objid			;ID+1 from hiscore heading

	movk	9,a0
	sub	a10,a0				;1-8
	move	a0,a14

	sll	5,a14			;x 32 bits
	addi	#exppals-20h,a14
	move	*a14,a14,L
	move	a14,@message_palette,L

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
	move	a1,a10
	callr	get_temp_record

	movi	temp_record+PR_NAME1,a4		;* src NAME
	movi	message_buffer,a3		;* string dest
	calla	get_name_string
	movi	COL1,a0
	move	a0,@mess_cursx
	calla	print_string_C

	move	@temp_record+PR_COUNT,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	COL3,a0
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
	movi	COL5-9,a0
	move	a0,@mess_cursx
	jruc	#skip2b

#not_max2
	movi	999,a1			;max value
	calla	dec_to_pct
	calla	concat_string
#skip1b
	movi	COL5,a0
	move	a0,@mess_cursx
#skip2b
	calla	print_string

	move	@mess_objid,a8
	CREATE0	slide_line_up

	addi	YOFF,a11

	PULLP	a9,a10
	addi	20h,a9
	dsj	a10,#next_player2
	RETP

#exppals
	.long	BST18B2_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P

******************************************************************************
* name only
* champions screen (only prints 3 players)
*-----------------------------------------------------------------------------
#method2b

	.asg	112,LCOL0
	.asg	132,LCOL1
	.asg	209,LCOL1a
	.asg	267,LCOL2
	.asg	70,YOFF2

	movi	LN0b_setup,a2
	calla	setup_message

	movk	3,a10
	movi	record_sort_ptrs,a9

#next_player2b
	PUSHP	a9,a10

	movk	4,a0
	sub	a10,a0				;1-3
	move	a0,a14

	sll	5,a14			;x 32 bits
	addi	#champals-20h,a14
	move	*a14,a14,L
	move	a14,@message_palette,L

;	movk	3,a1				;max value
;	calla	dec_to_asc
;	calla	copy_string
;	movi	LCOL0-6,a0
;	move	a0,@mess_cursx
;	calla	print_string_C
;
;	movi	LCOL0-46,a0
;	move	a0,@mess_cursx
;	movi	#str_num,a4
;	calla	print_string_C2

	move	*a9,a8,L
	move	*a8(RS_RECORD_NUM),a0
	movi	PKDPR_SIZE*2,a1			;cmos words
	mpyu	a0,a1
	addi	RECORD_ORIGIN,a1
	move	a1,a10
	callr	get_temp_record

;	movi	LCOL2,a0
	movi	LCOL1a,a0
	move	a0,@mess_cursx

	move	@temp_record+PR_NUMDEF,a0
	cmpi	NUM_TEAMS,a0
	jrge	#is_champ

	movi	#str_none,a4
	calla	print_string_C2
	jruc	#not_champ
#is_champ
	movi	temp_record+PR_NAME1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_name_string
	calla	print_string_C

#not_champ
	move	@mess_cursy,a0
	addi	YOFF2,a0
	move	a0,@mess_cursy

	PULLP	a9,a10
	addi	20h,a9
	dsj	a10,#next_player2b
	RETP

#str_none
	.string	".   .   .   .   .   .",0
	.even


#champals
	.long	BRSH50G_P
	.long	BRSH50W_P
	.long	BRSH50W_P


******************************************************************************
* prints rank, team name
*-----------------------------------------------------------------------------
#method3

	.asg	115,TCOL1
	movi	LN0_setup,a2
	calla	setup_message

	movi	260,a0
	move	a0,@mess_cursy			;draw data off-screen

	movk	8,a10
	move	a10,@hiscore_cnt

	movi	sorted_teams,a9

	movi	TOP_LINE,a11			;start Y (rank #1)

#next_team
	PUSHP	a9,a10

	move	@mess_objid,a0
	addk	1,a0
	move	a0,@mess_objid			;ID+1 from hiscore heading

	PUSHP	a9
	movk	9,a0
	sub	a10,a0				;1-8

	move	a0,a14
	sll	5,a14			;x 32 bits
	addi	#teampals-20h,a14
	move	*a14,a14,L
	move	a14,@message_palette,L

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

	movi	TCOL1,a0
	move	a0,@mess_cursx
	PULLP	a9
	move	*a9,a0				;team number (0-29)
	sll	5,a0
	addi	#team_names,a0
	move	*a0,a4,L
	calla	print_string2

	move	@mess_objid,a8
	CREATE0	slide_line_up

	addi	YOFF,a11

	PULLP	a9,a10
	addi	10h,a9
	dsj	a10,#next_team
	RETP


#teampals
	.long	BST18B2_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P
	.long	BSTGWW_P


******************************************************************************
#sort_routines
	.long	#sort_best		;0 (best overall player)
	.long	#sort_champs		;1 (grand champions)
	.long	#sort_world_records	;2 (world records)
	.long	#sort_win_prcnt		;3 (greatest win %)
	.long	#sort_wins		;4 (most wins)
	.long	#sort_offensive		;5 (best offensive players)
	.long	#sort_defensive		;6 (best defensive players)
	.long	#sort_exp		;7 (experienced players)
	.long	#sort_streak		;8 (win streaks)
	.long	#sort_trivia_pts	;9 (most trivia points)
	.long	#sort_teams		;10 (most popular teams)



;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
#sort_win_prcnt

	movi	NUM_PRECORDS-1,a11
#lop1
	movi	NUM_PRECORDS-1,a10

	movi	record_sort_ptrs,a9

	clr	a14
#lop2
	move	*a9,a4,L
	move	*a9(20h),a5,L

	move	*a4(RS_AVERAGE),a0
	move	*a5(RS_AVERAGE),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swp
	jrlo	#swp

;same, so compare average
	move	*a4(RS_WINS),a0
	move	*a5(RS_WINS),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swp
	jrlo	#swp

;same, so compare teams defeated
	move	*a4(RS_TEAMSDEF),a0
	move	*a5(RS_TEAMSDEF),a1
	cmp	a1,a0				;a0-a1
	jrhs	#no_swp

#swp
	movk	1,a14

	move	a5,*a9,L
	move	a4,*a9(20h),L

#no_swp
;;	addi	RS_SIZE,a9
	addi	20h,a9

	dsj	a10,#lop2
	move	a14,a14
	jrz	#dne
	dsj	a11,#lop1
#dne
	rets


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
#sort_world_records
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
#sort_trivia_pts

	movi	NUM_PRECORDS-1,a11
#loop1	movi	NUM_PRECORDS-1,a10
	movi	record_sort_ptrs,a9
	clr	a14
#loop2
	move	*a9,a4,L
	move	*a9(20h),a5,L

	move	*a4(RS_TRIVIA_PTS),a0
	move	*a5(RS_TRIVIA_PTS),a1
	cmp	a1,a0				;a0-a1
	jrhi	#no_swap
	jrlo	#swap

;same, so compare average
	move	*a4(RS_WINS),a0
	move	*a5(RS_WINS),a1
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
	
;-----------------------------------------------------------------------------
;	This routine sorts the player records ptrs. in order of best 
; overall to worst.
;  Player must have 5 wins
;
; INPUT:	call get_all_records to build ram copy of records
;-----------------------------------------------------------------------------
#sort_best

	movi	NUM_PRECORDS-1,a11
bst_1
	movi	NUM_PRECORDS-1,a10
	movi	record_sort_ptrs,a9
	clr	a14
bst_2
	move	*a9,a4,L
	move	*a9(20h),a5,L
;FIX!!
;;	move	*a4(RS_GAMES_PLAYED),a0

	move	*a4(RS_AVERAGE),a0
	sll	2,a0
	move	*a5(RS_AVERAGE),a1
	sll	2,a1				;weight the average

	move	*a4(RS_WINS),a0
	add	a2,a0
	move	*a5(RS_WINS),a1
	add	a2,a1

	move	*a4(RS_STREAK),a2
	add	a2,a0
	move	*a5(RS_STREAK),a2
	add	a2,a1

	move	*a4(RS_TEAMSDEF),a2
	add	a2,a0
	move	*a5(RS_TEAMSDEF),a2
	add	a2,a1
	cmp	a1,a0
	jrhi	noswap_bst
	jrlo	swap_bst

;same, so compare games played
	move	*a4(RS_GAMES_PLAYED),a0
	move	*a5(RS_GAMES_PLAYED),a1
	cmp	a1,a0				;a0-a1
	jrhs	noswap_bst
swap_bst
	movk	1,a14
	move	a5,*a9,L
	move	a4,*a9(20h),L
noswap_bst
	addi	20h,a9
	dsj	a10,bst_2
	move	a14,a14
	jrz	done_so
	dsj	a11,bst_1
done_bst
	rets

;-----------------------------------------------------------------------------
;	This routine sorts the player records ptrs. in order of best 
; offensive rank to worst. If tie, sorted by games played
;  Player must have 5 wins
;
; INPUT:	call get_all_records to build ram copy of records
;-----------------------------------------------------------------------------
#sort_offensive

	movi	NUM_PRECORDS-1,a11
so_1
	movi	NUM_PRECORDS-1,a10
	movi	record_sort_ptrs,a9
	clr	a14
so_2
	move	*a9,a4,L
	move	*a9(20h),a5,L

	move	*a4(RS_OFF_RANK),a0
	move	*a5(RS_OFF_RANK),a1
	cmp	a1,a0				;a0-a1
	jrhi	noswap_so
	jrlo	swap_so

;same, so compare wins
	move	*a4(RS_WINS),a0
	move	*a5(RS_WINS),a1
	cmp	a1,a0				;a0-a1
	jrhi	noswap_so
	jrlo	swap_so

;same, so compare teams defeated
	move	*a4(RS_TEAMSDEF),a0
	move	*a5(RS_TEAMSDEF),a1
	cmp	a1,a0				;a0-a1
	jrhs	noswap_so
swap_so
	movk	1,a14
	move	a5,*a9,L
	move	a4,*a9(20h),L
noswap_so
	addi	20h,a9
	dsj	a10,so_2
	move	a14,a14
	jrz	done_so
	dsj	a11,so_1
done_so
	rets

;-----------------------------------------------------------------------------
;	This routine sorts the player records ptrs. in order of best 
; defensive rank to worst. If tie, sorted by games played
;  Player must have 5 wins
;
; INPUT:	call get_all_records to build ram copy of records
;-----------------------------------------------------------------------------
#sort_defensive

	movi	NUM_PRECORDS-1,a11
sd_1
	movi	NUM_PRECORDS-1,a10
	movi	record_sort_ptrs,a9
	clr	a14
sd_2
	move	*a9,a4,L
	move	*a9(20h),a5,L

	move	*a4(RS_GAMES_PLAYED),a0
	jrz	noswap_sd
	move	*a5(RS_GAMES_PLAYED),a0
	jrz	noswap_sd

	move	*a4(RS_DEF_RANK),a0
	move	*a5(RS_DEF_RANK),a1
	cmp	a1,a0				;a0-a1
	jrlo	noswap_sd
	jrhi	swap_sd

;same, so compare wins
	move	*a4(RS_WINS),a0
	move	*a5(RS_WINS),a1
	cmp	a1,a0				;a0-a1
	jrhi	noswap_sd
	jrlo	swap_sd

;same, so compare teams defeated
	move	*a4(RS_TEAMSDEF),a0
	move	*a5(RS_TEAMSDEF),a1
	cmp	a1,a0				;a0-a1
	jrhs	noswap_sd
swap_sd
	movk	1,a14
	move	a5,*a9,L
	move	a4,*a9(20h),L
noswap_sd
	addi	20h,a9
	dsj	a10,sd_2
	move	a14,a14
	jrz	done_sd
	dsj	a11,sd_1
done_sd
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
#sort_wins
	callr	sort_wins
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
#sort_exp
	callr	sort_exp
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
#sort_champs
	callr	sort_champs
	rets

;;-----------------------------------------------------------------------------
;;-----------------------------------------------------------------------------
;#sort_losses
;	callr	sort_losses
;	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
#sort_teams
	calla	get_teams_pop
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
#sort_streak
	calla	sort_streak
	rets

LN0_setup
	PRINT_STR	bast18_ascii,6,0,200,50,BSTGYG_P,0
LN0b_setup
	PRINT_STR	brush50_ascii,6,2,200,50,BRSH50G_P,0
#heading1_setup
	PRINT_STR	brush20_ascii,6,0,200,7,BRSHGYOP,0
#heading2_setup
	PRINT_STR	bast8_ascii,7,0,200,29+3,BAST_Y_P,0

#hiscore_mod
	.long	ATTRACTBMOD
	.word	0,0
	.long	0

#headings1
	.long	#hd0,#hd1,#hd2,#hd3,#hd4,#hd5
	.long	#hd6,#hd7,#hd8,#hd9,#hda,#hd1

#headings2
	.long	#hd20,#hd21,#hd22,#hd23,#hd24,#hd25
	.long	#hd26,#hd27,#hd28,#hd29,#hd30,#hd21

#hd0	.string	"BEST OVERALL PLAYER",0
#hd1	.string	"GRAND CHAMPIONS",0
#hd2	.string	"WORLD RECORDS",0
#hd3	.string	"GREATEST PLAYERS",0
#hd4	.string	"BIGGEST WINNERS",0
#hd5	.string	"BEST OFFENSIVE PLAYERS",0
#hd6	.string	"BEST DEFENSIVE PLAYERS",0
#hd7	.string	"EXPERIENCED PLAYERS",0
#hd8	.string	"CURRENT WINNING STREAK",0
#hd9	.string	"TRIVIA MASTERS",0
#hda	.string	"MOST POPULAR TEAMS",0

#hd20	.string	"(all stats based on 4 games minimum)",0
#hd21	.string	"(defeated all 29 nba teams)",0
#hd22	.string	"(best individual records)",0
#hd23	.string	"(best win percentage)",0
#hd24	.string	"(most games won)",0
#hd25	.string	"(avg. team pts. scored per game)",0
#hd26	.string	"(avg. team pts. allowed per game)",0
#hd27	.string	"(most games played)",0
#hd28	.string	"(consecutive wins)",0
#hd29	.string	"(best NBA knowledge)",0
#hd30	.string	"(at this location)",0

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
	.long	#t24,#t25,#t26,#t27,#t28


#t0	.string	"ATLANTA HAWKS",0
#t1	.string	"BOSTON CELTICS",0
#t2	.string	"CHARLOTTE HORNETS",0
#t3	.string	"CHICAGO BULLS",0
#t4	.string	"CLEVELAND CAVALIERS",0
#t5	.string	"DALLAS MAVERICKS",0
#t6	.string	"DENVER NUGGETS",0
#t7	.string	"DETROIT PISTONS",0
#t8	.string	"GOLDEN ST. WARRIORS",0
#t9	.string	"HOUSTON ROCKETS",0
#t10	.string	"INDIANA PACERS",0
#t11	.string	"L.A. CLIPPERS",0
#t12	.string	"L.A. LAKERS",0
#t13	.string	"MIAMI HEAT",0
#t14	.string	"MILWAUKEE BUCKS",0
#t15	.string	"MINNESOTA TIMBERWLVS",0
#t16	.string	"NEW JERSEY NETS",0
#t17	.string	"NEW YORK KNICKS",0
#t18	.string	"ORLANDO MAGIC",0
#t19	.string	"PHILADELPHIA 76ERS",0
#t20	.string	"PHOENIX SUNS",0
#t21	.string	"PORTLAND TRAILBLZERS",0
#t22	.string	"SACRAMENTO KINGS",0
#t23	.string	"SAN ANTONIO SPURS",0
#t24	.string	"SEATTLE SUPERSONICS",0
#t25	.string	"TORONTO RAPTORS",0
#t26	.string	"UTAH JAZZ",0
#t27	.string	"VANCOUVER GRIZZLIES",0
#t28	.string	"WASHINGTON BULLETS",0
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

	movi	bast18_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	movi	TYPTEXT,a0
	move	a0,@mess_objid

	movk	3,a0
	move	a0,@mess_space_width	;space char width
	clr	a0
	move	a0,@mess_spacing	;spacing between chars

	movi	BST18G_P,a0
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
* INPUT:	a4 = starting record (0 - NUM_PRECORDS-1)
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

	movi	temp_record+PR_NAME1,a4		;* src initials
	movi	message_buffer,a3		;* string dest
	calla	get_name_string

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
	movi	1023,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string

	movi	COL4,a0
	move	a0,@mess_cursx		;message cursor pos X
	move	@temp_record+PR_LASTPLAY,a0
	movi	1023,a1			;max value
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
	.even

str_unused
	.string	"UNUSED",0
	.even


;-----------------------------------------------------------------------------
;	This routine moves all objects, in the ID range, offscreen
;
; INPUT: reg a8 - starting OBJ id to move
;	 reg a9 - last OBJ id to move
;-----------------------------------------------------------------------------
; SUBR	explode_screen_clear
;
;	PUSHP	a1,a2,a3
;	clr	a11
;
;	movi	OBJLST,a2
;	move	*a2,a2,L			;get next obj. ptr
;	jrz	esc_5				;br=no obj. list
;esc_0
;	move	*a2(OID),a14
;	cmp	a8,a14				;is ID > than range start ?
;	jrlo	esc_1				;br=nope
;	cmp	a9,a14				;is ID <= than range end ?
;	jrhi	esc_1				;br=nope
;
;	inc	a11				;count nbr. of matching ID's
;
;	movk	14,a0
;	calla	rndrng0
;	addk	1,a0
;	move	a0,a3
;
;	movi	100,a0
;	calla	rndrng0
;	cmpi	50,a0				;50/50 change of negating vel.
;	jrhs	esc_0a				;br=positive velocity
;
;	move	a3,a14
;	sub	a14,a3
;	sub	a14,a3				;make velocity negative
;esc_0a	sll	16,a3
;	move	a3,*a2(OXVEL),L
;
;	movk	10,a0
;	calla	rndrng0
;	addk	10,a0
;	move	a0,a3
;
;	movi	100,a0
;	calla	rndrng0
;	cmpi	50,a0				;50/50 change of negating vel.
;	jrls	esc_0b				;br=positive velocity
;
;	move	a3,a14
;	sub	a14,a3
;	sub	a14,a3				;make velocity negative
;esc_0b	sll	16,a3
;	move	a3,*a2(OYVEL),L
;
;esc_1	move	*a2,a2,L
;	jrnz	esc_0
;
;;watch objects until get to dest. (offscreen)
;
;	movi	3*TSEC,a10				;MAX time (6 seconds)
;esc_2
;	SLEEPK	1
;	dec	a10
;	jrle	esc_5				;br=exceeded max loop count
;
;	movi	OBJLST,a2
;esc_3
;	move	*a2,a2,L			;get next obj. ptr
;	jrz	esc_2				;br=no obj. lst
;	move	*a2(OID),a14
;	cmp	a8,a14				;is ID > than range start ?
;	jrlo	esc_3				;br=nope
;	cmp	a9,a14				;is ID <= than range end ?
;	jrhi	esc_3				;br=nope
;
;;OBJ ID in range
;
;;	move	*a2(OCTRL),a14,W		;get obj. control flags
;;	xori	M_FLIPH,a14
;;	move	a14,*a2(OCTRL)
;;
;;	move	*a2(OCTRL),a14			;get obj X
;;	xori	M_FLIPV,a14
;;	move	a14,*a2(OCTRL)
;
;	move	*a2(OXPOS),a14			;get obj X
;	cmpi	-30,a14				;obj off left edge of screen ?
;	jrlt	esc_4  				;br=yep
;	cmpi	405,a14				;obj off rght edge of screen ?
;	jrgt	esc_4				;br=yep
;
;	move	*a2(OYPOS),a14			;get obj Y
;	cmpi	-30,a14				;obj off top edge of screen ?
;	jrlt	esc_4				;br=yep
;	cmpi	260,a14				;obj off botm edge of screen ?
;	jrlt	esc_3				;br=nope
;esc_4
;;;	move	*a2(OMISC),a14,L
;;;	jrnz	esc_3				;br=obj. is done moving
;	move	*a2(OXVEL),a14,L
;	jrnz	esc_4a
;	move	*a2(OYVEL),a14,L			
;	jrz	esc_3
;esc_4a
;	clr	a14
;	move	a14,*a2(OXVEL),L		;stop obj. from moving
;	move	a14,*a2(OYVEL),L		;stop obj. from moving
;;;	movk	1,a14
;;;	move	a14,*a2(OMISC)			;mark obj. done !!
;	dsj	a11,esc_3
;esc_5	
;	PULLP	a1,a2,a3
 	RETP


******************************************************************************
	.end
