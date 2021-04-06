**************************************************************
*
* Owner:	none
*
* Software:	JAMIE BEGELMAN, KURT MAHAN, EUGENE P. JARVIS
* Initiated:	?
*
* Modified:	Shawn Liptak, 11/14/91	-Total carnage clean up
* 		Shawn Liptak, 1/20/92	-DIP switch test
* 		Shawn Liptak, 1/24/92	-Added line_draw
* 		Shawn Liptak, 2/20/92	-Basketball cleanup
* 		GEORGE PETRO, 1/17/93	-NBA JAM
* 		JEFF JOHNSON, 6/9/95	-NBA 2
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/24/93 16:48
*.Last mod - 4/12/95 4:00pm
**************************************************************
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"gsp.equ"
	.include	"sys.equ"
	.include	mproc.equ
	.include	link.equ
	.include	imgtbl.glo
;	.include	"imgtbl2.glo"
	.include	"macros.hdr"
	.INCLUDE	GAME.EQU
	.INCLUDE	DIPSW.EQU


	.ref	_tseconds
	.ref	_switch_map_mode
	.ref	_coin_addr
	.ref	_switch_addr
	.ref	_switch2_addr
	.ref	_watchdog_addr
	.ref	_dipswitch_addr
	.ref	_sound_addr
	.ref	_soundirq_addr
	.ref	_coin_counter_addr
	.ref	InitAddresses
	.ref	dec_to_asc
	.ref	copy_string,copy_rom_string
	.ref	concat_string
	.ref	message_buffer
	.ref	SOUNDSUP
	.ref	_rtc_seconds
	.ref	_rtc_minutes
	.ref	_rtc_hours
	.ref	_rtc_day
	.ref	_rtc_date
	.ref	_rtc_month
	.ref	_rtc_year
	.ref	_year
	.ref	_month
	.ref	_day
	.ref	_serial_number
	.ref	_man_date

	.globl	_get_time
	.globl	_set_time
	.globl	_aquire_time


SCRXFUDGE	equ	56
**************************************************************************
*									 *
*	DEFS AND REFS							 *
*									 *
**************************************************************************
	.ref	fudge_switches, fudge_switches_diag, CKTEST, CPU_RET
	.REF	SNDSND,INTIO,WARMSET,GET_AUD,STORE_AUDIT,WDOGDIS
	.ref	dirqtimer, AUD1, GAMSTATE, KILL_AUD, PCMOSRET
	.ref	CLR_AUD, FAC_SET, CMOS_VAL, ROM_NAME

	.DEF	POWERTST, DIAGCPUTEST, POWERCMOS
	.def	SWITCHTEST, SWSET1, SWSET2
	.DEF	CROSS_H,COL_BARS,BURN_IN,STRNEW1

	.DEF	CIRCLE,HVLINE,STRING,RECTANGLE,POINT,DSCRCLR,INITCOLR
	.DEF	READ_DIP

	.REF	SNDTST
	.REF	SYSCOPY
*SYMBOLS IN MENU.ASM
	.REF	USA_1, USA_2, USA_3, USA_4, USA_ELECTITLE
	.REF	GERMAN_1, GERMAN_2, GERMAN_3, GERMAN_4, GERMAN_ELECTITLE
	.REF	FRENCH_1, FRENCH_2, FRENCH_3, FRENCH_4, FRENCH_ELECTITLE
	.REF	DIPCOINTAB


	.REF	GET_ADJ, GET_CSPT, NO_CREDS
	.REF	PUT_ADJ, CRED_P, HEXTOASC, F_ADC_S, SET_COIN_ADJ
	.REF	init_all, mainlp, DIAG_COLORS

*
*DIAGNOSTIC SOUND EQUATES
*
CMOS_ERROR_SND	.EQU	00cah
CPU_ERROR_SND	.EQU	00cah
DIP_SND		.EQU	0c8h
SWITCH_SND	.EQU	0c8h

;CMOS_ERROR_SND	.EQU	0FF92H
;CPU_ERROR_SND	.EQU	0FF92H
;DIP_SND		.EQU	0FF83H
;SWITCH_SND	.EQU	0FF80H

	.BSS	SWSET1,32		; FOR SWITCH TEST
	.BSS	SWSET2,32

	.BSS	DIPVAL,16
	.BSS	DIP1ST,16

	.BSS	FORCEDIP,16		; FOR FORCING THE USE OF THE DIP
	.BSS	CERRORS,32
	.BSS	CPASSES,32
	.BSS	SCHANGE,16

	.bss	_snd_status,32
	.bss	_b6_save,32		; Temporary register fer me
	.bss	_temporary,32		; Another temp fer me
	.bss	_snd_diag_code,16	; Temporary storage for sound diag code
	.bss	_snd_chip_count,16	; Temporary register fer me
	.bss	_pic_raw,128		; Stuff fer the PIC
	.bss	_pic_temp,64


**************************************************************************
*									 *
*	USEFUL MACROS							 *
*									 *
**************************************************************************
*
*	TIMED PAUSE
*
PAUSE	.macro TIME, REG
	MOVI	:TIME:,:REG:,L
LABEL?	NOP
	DSJS	:REG:,LABEL?
	.endm

*BIT SET
*	BSET	BIT# 0-31(KONSTANT OR REGISTER),REGISTER TO SET BIT IN
* NOTE: A14 IS DESTROYED, 'A' FILE REGISTERS ONLY

BSET	.macro	P1,R1
	MOVK	1,A14
	SLL	:P1:,A14
	OR	A14,:R1:
	.endm


*
*RJST - RIGHT JUSTIFIES BITS IN A LONG WORD, I.E. RIGHTMOST BIT
*	TO BIT POSITION 0
*	RJST	REG
RJST	.macro	REG
	MOVE	:REG:,:REG:
	JRZ	MX?
MLP?
	SRL	1,:REG:
	JRNC	MLP?
	SLL	1,:REG:
	ADDK	1,:REG:
MX?
	.endm


BUT_MAC	.macro	X,Y,RADIUS,COLOR,MASK,SHIFT,EXTEND
	.WORD	:X:	
	.WORD	:Y:
	.WORD	:RADIUS:
	.LONG	:COLOR:
	.LONG	:MASK:
	.WORD	:SHIFT:
	.WORD	:EXTEND:
	.endm

STR_MAC	.macro	X,Y,STRING,COLOR,DIR
	.WORD	:X:	
	.WORD	:Y:
	.LONG	:STRING:
	.WORD	:COLOR:
	.WORD	:DIR:
	.endm

VECMAC	.macro	COLOR,X1,Y1,X2,Y2
	.WORD	:COLOR:
	.WORD	:X1:
	.WORD	:Y1:
	.WORD	:X2:
	.WORD	:Y2:
	.endm

DOTMAC	.macro	COLOR,X,Y
	.WORD	:COLOR:
	.WORD	:X:
	.WORD	:Y:
	.endm

RECTMAC	.macro	COLOR,X,Y,W,H
	.WORD	:W:
	.WORD	:H:
	.WORD	:X:
	.WORD	:Y:
	.WORD	:COLOR:
	.endm

CHIPMAC	.macro	NUM,X1,Y1,X2,Y2,X3,Y3,STRING,DIR,X4,Y4,STUFFED
	.WORD	:NUM:
	.WORD	:X1:
	.WORD	:Y1:
	.WORD	:X2:
	.WORD	:Y2:
	.WORD	:X3:
	.WORD	:Y3:
	.LONG	:STRING:
	.WORD	:DIR:
	.WORD	:X4:
	.WORD	:Y4:
	.WORD	:STUFFED:
	.endm

CMNUM		EQU	0
CMLOC		EQU	CMNUM+16
CMXLOC		EQU	CMLOC
CMYLOC		EQU	CMLOC+16
CMSIZE		EQU	CMLOC+32
CMXSIZE		EQU	CMSIZE
CMYSIZE		EQU	CMSIZE+16
CMOFFSET	EQU	CMSIZE+32
CMSTRING	EQU	CMOFFSET+32
CMDIR		EQU	CMSTRING+32
CMPINLOC	EQU	CMDIR+16
CMSTUFFED	EQU	CMPINLOC+32
CMEND		EQU	CMSTUFFED+16
	

**************************************************************************
*									 *
* RAM_CHIP: MACRO DEFINES A RAM CHIP RECORD.				 *
*									 *
*	CHIP_NO    -- CHIP NUMBER					 *
*	WIDTH	   -- CHIP CELL SIZE IN BITS (MUST BE > 0)		 *
*	INTERLEAVE -- DISTANCE BETWEEN ADJACENT CELLS ON CHIP (IN BITS)	 *
*	START_ADDR -- ADDRESS OF FIRST CELL ON CHIP			 *
*	END_ADDR   -- ADDRESS OF LAST CELL ON CHIP			 *
*									 *
**************************************************************************

RAM_CHIP .macro TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR

	.WORD	:WIDTH:
	.WORD	:INTERLEAVE:
	.WORD	:CHIP_NO:
	.LONG	:START_ADDR:
	.LONG	:END_ADDR:
	.LONG	:TAB_LINK:
	.endm

RAM_WDTH EQU	000H		    ; OFFSETS INTO RAM CHIP RECORD
RAM_ITLV EQU	010H
RAM_NMBR EQU	020H
RAM_SADR EQU	030H
RAM_EADR EQU	050H
RAM_LINK	EQU	070H
RAM_SIZE EQU	090H

ROM_CKSM	EQU	000H
ROM_WDTH	EQU	010H		    ; OFFSETS INTO ROM CHIP RECORD
ROM_ITLV	EQU	020H
ROM_NMBR	EQU	030H
ROM_SADR	EQU	040H
ROM_EADR	EQU	060H
ROM_LINK	EQU	080H
ROM_SIZE	EQU	0A0H

****************************************************************************
* ROM_CHIP: MACRO DEFINES A ROM CHIP RECORD.				    *
*									    *
*	 CHIP_NO    -- CHIP NUMBER					    *
*	 WIDTH	    -- CHIP CELL SIZE IN BITS (MUST BE > 0)		    *
*	 INTERLEAVE -- DISTANCE BETWEEN ADJACENT CELLS ON CHIP (IN BITS)    *
*	 START_ADDR -- ADDRESS OF FIRST CELL ON CHIP			    *
*	 END_ADDR   -- ADDRESS OF LAST CELL ON CHIP			    *
*	 CHECK_SUM  -- DATAIO CHECK SUM FOR CHIP			    *
****************************************************************************

ROM_CHIP .macro TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR, CHECK_SUM

	.WORD	:CHECK_SUM:
	.WORD  :WIDTH:
	.WORD  :INTERLEAVE:
	.WORD  :CHIP_NO:
	.LONG  :START_ADDR:
	.LONG  :END_ADDR:
	.LONG	:TAB_LINK:

	 .endm


RANDOM_SEED EQU 5A5A5A5Ah	       ; RAM TESTS: PSEUDO-RANDOM SEQUENCE
ZERO_EXTEND EQU 1Fh		       ; PARAMETERS
SIGN_EXTEND EQU 20h
PAL_SELECT  EQU 0FFDCH		       ; ENABLE VIDEO PALETTE MAP ACCESS


	.text
	.even


**************************************************************************
*									 *
*	POWERTST							 *
*									 *
*	POWERUP SELF TEST ROUTINES					 *
*									 *
*	ENTRY								 *
*		NOTHING							 *
*									 *
*	EXIT								 *
*		NOTHING							 *
*									 *
**************************************************************************
POWERTST
	dint
	setf	16,1,0
	setf	32,0,1
	MOVI	STCKST,SP,L
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0

;	HALT DMA AND ENABLE CACHE

	clr	a14
	move	a14,@DMACTRL
	move	a14,@DMACTRL

	FCALL	INTIO,B6

;	DISABLE VIDEO PALETTE RAMS, AUTOERASE AND ERROR LED

	MOVI	SYSCINIT,A13
	MOVE	A13,@SYSCTRL

	FCALL	CPUTEST,SP
	JAUC	WARMSET

****************************************************************************
*                                                                          *
*  PIC SECURITY STUFF                                                      *
*                                                                          *
*  Security source for WWF-UNIT's PIC                                      *
*                                                                          *
*  Version 1.00                                                            *
*  Written by:   Michael J. Lynch                                          *
*  Copyright (c) 1994 by Williams Electronics Games Inc.                   *
*  All rights reserved                                                     *
*                                                                          *
*     TTTTT   OOO  PPPP         SSS   EEEEE   CCC   RRRR  EEEEE TTTTT      *
*       T    O   O P   P       S   S  E      C   C  R   R E       T        *
*       T    O   O P   P       S      E      C      R   R E       T        *
*       T    O   O PPPP         SSS   EEEE   C      RRRR  EEEE    T        *
*       T    O   O P               S  E      C      R R   E       T        *
*       T    O   O P           S   S  E      C   C  R  R  E       T        *
*       T     OOO  P            SSS   EEEEE   CCC   R   R EEEEE   T        *
*                                                                          *
*                                                                          *
*                    Company Confidential Information                      *
*                        NEED TO KNOW BASIS ONLY                           *
*                                                                          *
* USE OR DISCLOSURE STRICTLY PROHIBITED UNLESS APPROVED IN WRITING FROM    *
* WILLIAMS ELECTRONICS GAMES INC.                                          *
*                                                                          *
* Unapproved use or disclosure will result in severe torture!!!!!          *
*                                                                          *
****************************************************************************

; _pic_bin2bcd Converts a hex number in a7 to BCD and puts it in A3
_pic_bin2bcd:
	clr	a3
	movi	100000,a0
_bin2bcd_loop:
	sll	4,a3
	move	a7,a1
	divu	a0,a1
	or	a1,a3
	mpyu	a0,a1
	sub	a1,a7
	move	a0,a1
	movk	10,a0
	divu	a0,a1
	move	a1,a0
	jrnz	_bin2bcd_loop
	FRET	b6

******************************************************************************
*                                                                            *
* _bcd2hex - Converts a 32 bit (8 digit) BCD Number to Hexidecimal           *
*                                                                            *
* ENTRY                                                                      *
*         A0 - BCD Number to be converted                                    *
*         B6 - Return Address                                                *
*                                                                            *
* EXIT                                                                       *
*         A2 - Converted Number (hex)                                        *
*                                                                            *
* USES                                                                       *
*         A1 - Multiplier                                                    *
*         A3 - Temporary                                                     *
*         A4 - Digit Counter                                                 *
*                                                                            *
* Written by:  Michael J. Lynch                                              *
*                                                                            *
******************************************************************************
_bcd2hex:
	clr	a2		; Start with 0
	movk	1,a1		; Starting Multiplier
	movk	8,a4		; Number of BCD digits to convert
_b2h_loop:			; Main BCD to hex conversion loop
	move	a0,a3		; Put BCD number in temporary register
	andi	0fh,a3		; get rid of bits not interested in
	mpyu	a1,a3		; multiply by current multiplier
	add	a3,a2		; Accumulate into final register
	srl	4,a0		; Shift to next BCD digit
	movk	10,a3		; Calculate next multiplier (mult = mult * 10)
	mpyu	a3,a1		; New Multiplier
	dsjs	a4,_b2h_loop	; Keep going until 8 BCD digits are done
	FRET	b6		; return

_read_pic_data:
	setf	8,0
	setf	32,0,1
	movk	16,a9		; Number of bytes of data to read
	movi	_pic_raw,a1	; address at which to store raw data from PIC
	movk	010h,a8		; Send Request Serial Number Data Command
	move	a8,@PIC_COMMAND
_rp_data_loop:
	setf	16,0
	clr	a8
	move	a8,@PIC_COMMAND
	movi	1000000,a2	; Wait for PIC to acknowledge 
_rp_ack_loop:
	move	a2,a2		; Check for command timeout
	jrz	gn_bad		; WOA PIC never acknowledged - ERROR!!!!
	move	@_watchdog_addr,a8,L
	move	a8,*a8
	move	@_soundirq_addr,a8,L
	move	*a8,a8
	subi	1,a2
	btst	12,a8		; Data available ?
	jrnz	_rp_ack_loop	; NO
	setf	8,0		; YES
	move	@PIC_DATA,a0	; read data
	move	a0,*a1+		; write to temp holding area
	movk	010h,a8		; Acknowledge reciept of data
	setf	16,0
	move	a8,@PIC_COMMAND
	movi	1000000,a2	; Wait for PIC n acknowlegde
_rp_nack_loop:
	move	a2,a2
	jrz	gn_bad
	move	@_watchdog_addr,a8,L
	move	a8,*a8
	move	@_soundirq_addr,a8,L
	move	*a8,a8
	subi	1,a2
	btst	12,a8
	jrz	_rp_nack_loop
	dsj	a9,_rp_data_loop
	clr	a4		; Holding Register for X
	clr	a5		; Holding Register for Y
	setf	8,0
	movi	_pic_raw,a10
	addi	060h,a10
	move	*a10+,a4	; Get X
	move	*a10,a5		; Get Y
	setf	24,0
	clr	a7		; Calculate B-3-5-9
	movi	_pic_raw,a10
	move	*a10,a7
	subi	15732,a7
	movi	581,a0
	divu	a0,a7
	sub	a4,a7		; B359 (binary)
	FCALL	_pic_bin2bcd,b6	; B359 (bcd) a1 = B359
	setf	4,0
	srl	4,a3
	move	a3,a0
	andi	0fh,a0
	movi	_pic_temp,a10
	addi	014h,a10
	move	a0,*a10		; Stuff the 5
	srl	4,a3
	move	a3,a0
	andi	0fh,a0
	movi	_pic_temp,a10
	addk	0ch,a10
	move	a0,*a10		; Stuff the 3


	movi	_pic_raw,a10
	addi	018h,a10
	move	*a10,a7,1	; Calculate 2-A-0-8-6
	subi	7463513,a7
	movi	4223,a0
	divu	a0,a7
	sub	a5,a7
	sub	a5,a7
	sub	a4,a7		; 2A086 (binary)
	FCALL	_pic_bin2bcd,b6	; 2A086 (bcd)
	move	a3,a0
	andi	0fh,a0
	movi	_pic_temp,a10
	addk	018h,a10
	move	a0,*a10		; Stuff the 6
	srl	4,a3
	move	a3,a0
	andi	0fh,a0
	movi	_pic_temp,a10
	addi	020h,a10
	move	a0,*a10		; Stuff the 8
	srl	4,a3
	move	a3,a0
	andi	0fh,a0
	movi	_pic_temp,a10
	move	a0,*a10		; Stuff the 0
	srl	8,a3
	move	a3,a0
	andi	0fh,a0
	movi	_pic_temp,a10
	addk	8,a10
	move	a0,*a10		; Stuff the 2


	setf	24,0		; Calcuate 1-7-4
	movi	038h,a10
	addi	_pic_raw,a10
	move	*a10,a7
	subi	127984,a7
	movi	7117,a0
	divu	a0,a7
	sub	a5,a7
	sub	a5,a7
	sub	a5,a7
	sub	a5,a7
	sub	a5,a7		; 174 (binary)
	FCALL	_pic_bin2bcd,b6	; 174 (bcd) a1 = 174
	setf	4,0
	move	a3,a0
	andi	0fh,a0
	movi	_pic_temp,a10
	addk	010h,a10
	move	a0,*a10		; Stuff the 4
	srl	4,a3
	move	a3,a0
	andi	0fh,a0
	movi	_pic_temp,a10
	addk	01ch,a10
	move	a0,*a10		; Stuff the 7
	srl	4,a3
	move	a3,a0
	andi	0fh,a0
	movi	_pic_temp,a10
	addk	4,a10
	move	a0,*a10		; Stuff the 1

	setf	16,0
	movi	050h,a10
	addi	_pic_raw,a10
	move	*a10,a0		; This is a pointer to the date code
	move	*a10,a1
	sll	8,a1
	srl	8,a0
	andi	0ffh,a0
	andi	0ff00h,a1
	or	a1,a0
	move	a0,@_man_date,L

	setf	4,0
	movi	_pic_temp,a10
	addk	0ch,a10
	move	*a10+,a0	; Most Significant Digit (serial number)
	sll	4,a0
	move	*a10+,a1
	or	a1,a0
	sll	4,a0
	move	*a10+,a1
	or	a1,a0
	sll	4,a0
	move	*a10+,a1
	or	a1,a0
	sll	4,a0
	move	*a10+,a1
	or	a1,a0
	sll	4,a0
	move	*a10+,a1	; Least Significant Digit (serial number)
	or	a1,a0
	FCALL	_bcd2hex,b6	; Convert to hex (a2 = serial # hex)
	move	a2,@_serial_number,L
	
	setf	4,0
	movi	_pic_temp,a10
	move	*a10+,a0	; Most Significant Digit (game number)
	sll	4,a0
	move	*a10+,a1
	or	a1,a0
	sll	4,a0
	move	*a10+,a1	; Least Significant Digit (game number)
	or	a1,a0
	FCALL	_bcd2hex,b6	; Convert to hex

	clr	a1
	cmpi	528,a2		; Development PIC Game Number
	jrz	gn_good
	cmpi	459,a2		; Real Game Number (Hangtime)
	jrz	gn_good
gn_bad:
	movi	SEC_MESS_2,a0	; Level 2 Security Check failure
	FCALL	STRINGCENTER,b6
	addi	[220,0],a1
	clr	a2
	movi	COLOR_RED,a3
	FCALL	STRING,b6
; MJL
	jauc	$		; Let the dog catch us
;	LOCKUP
; MJL END
gn_good:
	setf	8,0		; Stomp on memory used to decode PIC
	clr	a0
	movi	16,a1
	movi	_pic_raw,a2
_stomp_temp:
	move	a0,*a2+
	dsjs	a1,_stomp_temp
	movi	8,a1
	movi	_pic_temp,a2
_stomp_temp1:
	move	a0,*a2+
	dsjs	a1,_stomp_temp1
	setf	16,1,0			;Field0 = Word sign extend
	setf	32,0,1			;Field1 = Long word
	rets


**************************************************************************
*											     *
* 	POWERCMOS									     *
* 											     *
* 	CHECK THE CMOS AND DO A LOT OF OTHER STUFF -- SHOW THE	     *
* 	POWER UP MESSAGES								     *
* 											     *
* 	ENTRY	NOTHING									     *
* 	EXIT	NOTHING									     *
*											     *
**************************************************************************
POWERCMOS:	
	DINT
	MOVI	SYSCINIT,A1
	MOVE	A1,@SYSCTRL,W

	CALLA	WDOGDIS			; GET RID OF WATCH DOG

	CLR	A13			; USED TO DECIDE WHETHER PAUSE OR NOT
	MOVE	A13,@DMACTRL,W
	MOVE	A13,@DMACTRL,W
	FCALL	INITCOLR,B5		; FIX UP THE COLORS
	FCALL	INTIO,B6
	FCALL	DSCRCLR,B6		; MAKE SURE OF SCREEN
	MOVI	ROM_NAME,A0
	FCALL	STRINGCENTER,B6		; GET WIDTH OF STRING
	ADDI	[30,0],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	callr	_read_pic_data
	movi	05018h,a13		; Palette 128 match color (BLACK)
	move	a13,@VMUX_BREG1,W
	movi	08080h,a13		; Set Palette # to 128
	move	a13,@DMACMAP,W
	movi	SEC_MESS_1,a0		; Print the message (won't show up)
	FCALL	STRINGCENTER,b6		; Note - only shows up on pirate
	addi	[210,0],a1		; hardware
	clr	a2
	movi	COLOR_RED,a3
	FCALL	STRING,b6
	clr	a13			; Set palette # back to 0
	move	a13,@DMACMAP,W
	
	movi	SNDREVPROMPT,a0		; Sound Revision Prompt
	FCALL	STRINGCENTER,b6
	addi	[120,0],a1
	clr	a2
	movi	COLOR_PURPLE,a3
	FCALL	STRING,b6
	move	@_watchdog_addr,a0,L
	move	a0,*a0,W
	move	@_coin_counter_addr,a0,L
	movi	030h,a1				; Yank down the reset
	move	a1,*a0,W
	movi	10000,a1			; Hold it fer a while
	dsjs	a1,$
	movi	020h,a1				; Let it go
	move	a1,*a0,W
	movi	10000,a1
	dsjs	a1,$
	move	@_sound_addr,a0,L		; Bypass the diags
	movb	a0,*a0
	move	@_watchdog_addr,a0,L		; Kill the dog
	move	a0,*a0,W
	movi	500000,a1			; Wait fer a while
_swait_lp
	move	@_watchdog_addr,a0,L
	move	*a0,a0,W
	dsjs	a1,_swait_lp
;	movk	2,a2
;_wait_diag
;	movi	1000000,a1
;_wait_diag_1
;	move	@_soundirq_addr,a0,L
;	move	*a0,a0,W
;	btst	B_SDAV,a0		; Sound data waiting
;	jrz	_diag_byte_1
;	move	@_watchdog_addr,a0,L
;	move	a0,*a0,W
;	dsjs	a1,_wait_diag_1
;	jruc	_snd_timeout
;_diag_byte_1
;	move	@SOUND,a0,W		; Yes - get rid of it
;	movi	10000,a1
;	dsjs	a1,$
;	dsjs	a2,_wait_diag
	clr	a3			; Turn on the sounds
	move	a3,@SOUNDSUP,W
	movi	999,a3			; Send revision request sound call
	calla	SNDSND
	movi	1000000,a2
_sndrev_loop
	move	@_watchdog_addr,a0,L
	movb	a0,*a0
	move	@_soundirq_addr,a0,L	; Wait fer a response
	move	*a0,a1,W
	btst	B_SDAV,a1		; Got a response ?
	jrz	_snd_response		; BR = yes
	dsjs	a2,_sndrev_loop
_snd_timeout
	movi	SNDTIMEOUT,a0		; If we get here we never got a response
	FCALL	STRINGCENTER,b6		; Tell operator about it
	addi	[135,0],a1
	clr	a2
	movi	COLOR_RED,a3
	FCALL	STRING,b6
	jruc	_sndrev_done		; Then we be done
_snd_response
	move	@_sound_addr,a0,L	; Get sound revision data
	move	*a0,a0,W
	move	a0,@_snd_chip_count,W	; Put up sound revision
	move	a0,a1
;	andi	0d0h,a1
	andi	0ffh,a1
	cmpi	0ffh,a1
	jrz	_snd_timeout
	andi	0f0h,a1
	cmpi	0d0h,a1
	jrz	_proto_version
	movi	SNDRELEASEPROMPT,a4
	jruc	_do_snd_version
_proto_version
	movi	SNDPROTOPROMPT,a4
_do_snd_version
	calla	copy_rom_string
	move	@_snd_chip_count,a0,W
	andi	0fh,a0
	movk	15,a1
	calla	dec_to_asc
	calla	concat_string
	movi	message_buffer,a0
	FCALL	STRINGCENTER,b6
	addi	[135,0],a1
	clr	a2
	movi	COLOR_WHITE,a3
	FCALL	STRING,b6
_sndrev_done

	movi	GAMESNPROMPT,a0		; Put up Game Serial number
	FCALL	STRINGCENTER,b6
	addi	[160,0],a1
	clr	a2
	movi	COLOR_PURPLE,a3
	FCALL	STRING,b6
	move	@_serial_number,a0,L	; Serial number put here by _get_serial_number
	movi	1000000,a1
	calla	dec_to_asc
	calla	copy_string
	movi	message_buffer,a0
	FCALL	STRINGCENTER,b6
	addi	[175,0],a1
	clr	a2
	movi	COLOR_WHITE,a3
	FCALL	STRING,b6

	CALLA	CMOS_VAL		; CHECKSUM AUDITS/ADJUSTMENTS
	JREQ	CMOSOK
*
* BAD CHECKSUM ON POWERUP ----> FACTORY SET
*
;	CALLA	RES_ALL			;ALL TIME TABLE
	clr	a0			;Full
	CALLA	FAC_SET
	CALLA	CLR_AUD

	MOVK	1,A13			; FLAG ERROR
	CALLA	CMOS_VAL		; TRY AGAIN
	JREQ	CMOSB1			; BR = OK WE'RE IN

	MOVI	CMOS_BAD,A0
	FCALL	STRINGCENTER,B6
	ADDI	[50,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	MOVI	CMOS_UNFAC,A0
	FCALL	STRINGCENTER,B6
	ADDI	[65,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	CMOS1
CMOSB1
	MOVI	CMOS_FACRES,A0
	FCALL	STRINGCENTER,B6
	ADDI	[50,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	CMOS1
CMOSOK
	MOVI	CMOS_OK,A0
	FCALL	STRINGCENTER,B6
	ADDI	[50,0],A1
	CLR	A2
	MOVI	COLOR_GREEN,A3
	FCALL	STRING,B6

CMOS1
	CALLA	CRED_P			;CHECK OUT CREDITS, THIS WILL CLEAR
					;IF NECESSARY.  THANX LINKY!

	CALLR	READ_DIP
	ANDI	DPUSECMOS,A0
	JRNZ	CMOS3			; BR = USING CMOS COINAGE

	MOVI	CMOS_DIP,A0
	FCALL	STRINGCENTER,B6
;	ADDI	[110,0],A1
	ADDI	[75,0],A1
	CLR	A2
	MOVI	COLOR_WHITE,A3
	FCALL	STRING,B6
	
	CALLR	SET_DIP_COINAGE
	JRUC	CMOS4

CMOS3
;
;        USING CMOS HERE
;
	MOVI	CMOS_CMOS,A0
	FCALL	STRINGCENTER,B6
;	ADDI	[110,0],A1
	ADDI	[75,0],A1
	CLR	A2
	MOVI	COLOR_WHITE,A3
	FCALL	STRING,B6
CMOS4	
;	CALLR	PLOTCOINAGE		; PLOT SOME COINAGE 
;	MOVE	@SWITCH,A0,L		; CHECK SLAM SWITCH
;	NOT	A0
;	ANDI	00080000H,A0
	move	@_coin_addr,a0,L
	move	*a0,a0,W
	not	a0
	andi	8h,a0
	JRZ	CMOSRET
	MOVI	CMOS_TILT,A0
	FCALL	STRINGCENTER,B6
	ADDI	[205,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	MOVK	1,A13			; FLAG ERROR
CMOSRET
	MOVE	A13,A13
	JRZ	CTMP0

	MOVI	CMOS_ERROR_SND,A0
;	MOVE	A0,@SOUND,W
	move	@_sound_addr,a13,L
	move	a0,*a13,W

	MOVI	CMOS_WAIT,A0
	FCALL	STRINGCENTER,B6
	ADDI	[230,0],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	CALLA	WDOGDIS			; DISABLE WOOF WOOF

	CALLA	fudge_switches		;get fudged switches in a0
	andi	BUTTONS|START_BITS,a0
	MOVE	A0,@SWSET1,L
CTMP1
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0
	CALLA	fudge_switches		;get fudged switches in a0
	andi	BUTTONS|START_BITS,a0
	MOVE	@SWSET1,A1,L
	CMP	A0,A1
	JRZ	CTMP1
	JRUC	CTMP2
CTMP0
	MOVI	200H,A0
CTMP_WAIT
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a1,L
	move	a1,*a1


;FIX - Temp!!!!! 
;FIX - Speed up warm reset - Replace when we ship!
	.if DEBUG
	.else
	PAUSE	1000H,B6
	PAUSE	2000h,B6		;Go fast
	DSJS	A0,CTMP_WAIT
	.endif

CTMP2
	move	@_serial_number,b5,L
	move	@_man_date,b6,L
	JAUC	PCMOSRET


SNDREVPROMPT
	.string	"SOUND SYSTEM VERSION",0
	.even
SNDPROTOPROMPT
	.string	"PROTO ",0
	.even
SNDRELEASEPROMPT
	.string	"RELEASE ",0
	.even
SNDTIMEOUT
	.string	"TIMEOUT ON RESPONSE FROM SOUND SECTION",0
	.even
GAMESNPROMPT
	.string	"GAME SERIAL NUMBER",0
	.even

CMOS_TILT
	.STRING	"WARNING -- SLAM SWITCH CLOSED",0
	.EVEN
	
CMOS_DIP
	.STRING	"USING DIPSWITCH COINAGE",0
	.EVEN

CMOS_CMOS
	.STRING	"USING CMOS COINAGE",0
	.EVEN

CMOS_WAIT
	.STRING	"ERRORS DETECTED -- ANY BUTTON TO CONTINUE",0
	.EVEN

CMOS_FACRES
	.STRING	"CMOS INVALID -- FACTORY SETTINGS RESTORED",0
	.EVEN

CMOS_BAD
	.string	"CMOS CHIP U62 BAD",0
	.EVEN

CMOS_UNFAC
	.STRING	"UNABLE TO RESTORE FACTORY SETTINGS",0
	.EVEN

CMOS_OK
	.STRING	"CMOS OK",0
	.EVEN

**************************************************************************
*								         *
* 	BURNIN								 *
* 									 *
* 	FACTORY BURNIN TEST -- EXITS BY RESETING THE GAME		 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING 						 *
* 									 *
* 	CALL								 *
* 		JAUC							 *
*								         *
**************************************************************************

BURN_IN:
	DINT
	MOVI	AUDAUTO,A0		;ZERO OUT BURNIN AUDIT
	CALLA	KILL_AUD
BURNLOOP
	CALLA	WDOGDIS			;MAKE SURE THE DOG IS ASLEEP
	FCALL	CPUTEST,SP
BURNSP:
	setf	16,1,0
	setf	32,0,1
	MOVI	STCKST,SP,L		;RESTORE THE STACK PTR
	MOVI	SYSCINIT,A0		;RE-INITIALIZE SYSTEM CONTROL
	MOVE	A0,@SYSCTRL,W
	MOVE	A0,@SYSCOPY,W		;KEEP A COPY IN RAM
	MOVI	AUDAUTO,A0
	CALLA	AUD1			;ANOTHER ONE WORKED
	JRUC	BURNLOOP

**************************************************************************
*								         *
* 	DIAGCPUTEST							 *
* 									 *
* 	DIAGNOSTIC CALL FOR THE CPU TEST				 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		JUMPS TO *EXEC_LP* AFTER SETTING EVERYTHING UP		 *
* 									 *
* 	CALL								 *
* 		JAUC							 *
*								         *
**************************************************************************

DIAGCPUTEST:
	CALLA	WDOGDIS
	DINT
	calla	InitAddresses		; Make sure I/O addresses are initialized
	FCALL	CPUTEST,SP
DIAGSP:
	SETF	16,1,0			; WORD NO SIGN EXTEND
	SETF	32,0,1			; LONG WORD
	MOVI	STCKST,SP,L
	CALLA	init_all

	callr	_read_pic_data
  
	CALLA	DIAG_COLORS		;FIRE UP THE COLORS

;	EINT				; ENABLE INTERRUPTS AND WE'RE OFF
;	DISPON				; ENABLE THE DISPLAY SYSTEM
	CREATE	DIAG_PID,CPU_RET
	MOVI	INDIAG,A0
	MOVE	A0,@GAMSTATE,W
	movk	1,a0			; Menu driver switch mapping mode
	move	a0,@_switch_map_mode,L
	calla	InitAddresses
	JAUC	mainlp

****************************************
* bin2bcd - Converts binary number pointed to by a0 to bcd and stores it back
*           into area pointed to by a0.
*
 SUBR bin2bcd
	mmtm	sp,a0,a1,a2,a3
	move	*a0,a2,W
	move	a2,a1
	movi	10,a3
	divu	a3,a1
	sll	4,a1
	movi	10,a3
	modu	a3,a2
	or	a2,a1
	move	a1,*a0,W
	mmfm	sp,a0,a1,a2,a3
	rets

*********************************************************
* _set_time - Sets the real time clock based on values in
*             _rtc_seconds
*             _rtc_minutes
*             _rtc_hours
*             _rtc_day
*             _rtc_date
*             _rtc_month
*             _rtc_year
* Time is set through the PIC.
 SUBR _set_time
	mmtm	sp,a0,a1,a2,a3,a4
	movi	_rtc_seconds,a0,L
	movi	7,a4
_st_cnvt_loop
	callr	bin2bcd
	addk	16,a0
	dsjs	a4,_st_cnvt_loop
	movi	14,a4
	movi	_rtc_seconds,a3,L
	pushst
	dint
	movi	012h,a0
	move	a0,@PIC_COMMAND,W
_st_next_val
	movk	2,a0
	move	a0,@PIC_COMMAND,W
	movi	1000000,a1
_st_ack_wait
	move	@_watchdog_addr,a2,L
	move	a2,*a2,W
	move	@_soundirq_addr,a2,L
	move	*a2,a2,W
	btst	12,a2
	jrz	_got_st_ack
	dsjs	a1,_st_ack_wait
	jruc	_st_done
_got_st_ack
	pushst
	setf	4,0
	move	*a3,a1,0
	popst
	move	a1,@PIC_COMMAND,W
	ori	010h,a1
	move	a1,@PIC_COMMAND,W
	addk	4,a3
	btst	3,a3
	jrz	_addr_ok
	addk	8,a3
_addr_ok
	movi	1000000,a0
_st_nack_wait
	move	@_watchdog_addr,a2,L
	move	a2,*a2,W
	move	@_soundirq_addr,a2,L
	move	*a2,a2,W
	btst	12,a2
	jrnz	_got_st_nack
	dsjs	a0,_st_nack_wait
	jruc	_st_done
_got_st_nack
	dsj	a4,_st_next_val
_st_done
	popst
	mmfm	sp,a0,a1,a2,a3,a4
	rets

********************************************
* bcd2hex - Converts 2 digit BCD number in a1 to hex and stores back in a1
*
 SUBR bcd2hex
	mmtm	sp,a0,a3
	move	a1,a2
	movk	10,a3
	andi	0f0h,a1
	srl	4,a1
	mpyu	a3,a1
	andi	0fh,a2
	add	a2,a1
	mmfm	sp,a0,a3
	rets

***********************************************
* _aquire_time - Time aquisition trigger function called in the DIRQ
*                Starts the acquisition of time information from the
*                Real Time Clock (RTC).  The time information is transfered
*                from the RTC to the PIC by the PIC.  This is done this way
*                because the RTC to PIC interface is an I2C bus interface
*                and requires approximately 3 ms to transfer the data from
*                the RTC to the PIC.  This function is called by the DIRQ
*                every 27 ticks (495ms) and then on the next DIRQ the function
*                to transfer the time information from the PIC to this
*                application is called.  This prevents this application from
*                being bogged down while the time information is being
*                moved from the RTC to the PIC.
 SUBR _aquire_time
	mmtm	sp,a0,a1
	movi	011h,a0			;Command code 0x1
	move	a0,@PIC_COMMAND,W
_at_next_byte
	movi	01h,a0
	move	a0,@PIC_COMMAND,W
	movi	100000,a0		;Wait for Acknowledge
_at_ack_wait
	move	@_watchdog_addr,a1,L
	move	a1,*a1,W
	move	@_soundirq_addr,a1,L
	move	*a1,a1,W
	btst	12,a1
	jrz	_got_at_ack
	dsjs	a0,_at_ack_wait
	jruc	_at_done
_got_at_ack
	movi	010h,a1
	move	a1,@PIC_COMMAND,W	;Take away Request
_at_done
	mmfm	sp,a0,a1
	rets

*************************************************
* _get_time - This function transfers the time information that was extracted
*             from the RTC by the PIC from the PIC to some global memory
*             area for use by this application.  The time information is
*             stored in hexidecimal word sized global values as follows
*
*             _tseconds	(0-59) Current seconds
*             _tminutes (0-59) Current minutes
*             _thours   (0-23) Current hours
*             _tday     (1-7)  Current Day (1=Sunday, 7=Saturday)
*             _tdate    (1-31) Current Date
*             _tmonth   (1-12) Current Month (1=January, 12=December)
*             _tyear    (0-99) Current Last 2 Digits of year
 SUBR _get_time
	mmtm	sp,a0,a1,a2,a3
	movk	8,a3			;Number of bytes of data to get
	movi	_tseconds,a2
	movi	013h,a0			;Command code 0x3
	move	a0,@PIC_COMMAND,W
_gt_next_byte
	movi	03h,a0
	move	a0,@PIC_COMMAND,W
	movi	100000,a0		;Wait for Acknowledge
_get_time_data_wait
	move	@_watchdog_addr,a1,L
	move	a1,*a1,W
	move	@_soundirq_addr,a1,L
	move	*a1,a1,W
	btst	12,a1
	jrz	_got_gt_ack
	dsjs	a0,_get_time_data_wait
	cmpi	1,a3
	jrz	_get_time_adjust
	movk	1,a0
	jruc	_get_time_done
_got_gt_ack
	move	@PIC_DATA,a0,W		;Read the data
	movi	010h,a1
	move	a1,@PIC_COMMAND,W	;Tell PIC we took data
	andi	0ffh,a0
	move	a0,*a2+,W
	movi	100000,a0
_gt_wait_nack
	move	@_watchdog_addr,a1,L
	move	a1,*a1,W
	move	@_soundirq_addr,a1,L
	move	*a1,a1,L
	btst	12,a1
	jrnz	_got_gt_nack
	dsjs	a0,_gt_wait_nack
_got_gt_nack
	dsj	a3,_gt_next_byte
_get_time_adjust
	movi	_tseconds,a0,L
	move	*a0,a1,W		;Mask off unused bits for seconds
	andi	07fh,a1
	callr	bcd2hex			;Convert to hex
	move	a1,a1
	jrnn	_chk_seconds59
	clr	a1
	jruc	_seconds_ok
_chk_seconds59
	cmpi	60,a1
	jrlt	_seconds_ok
	clr	a1
_seconds_ok
	move	a1,*a0+,W
	move	*a0,a1,W		;Mask off unused bits for minutes
	andi	07fh,a1
	callr	bcd2hex			;Convert to hex
	move	a1,a1
	jrnn	_chk_minutes59
	clr	a1
	jruc	_minutes_ok
_chk_minutes59
	cmpi	60,a1
	jrlt	_minutes_ok
	clr	a1
_minutes_ok
	move	a1,*a0+,W
	move	*a0,a1,W		;Mask off unused bits for hours
	andi	03fh,a1
	callr	bcd2hex			;Convert to hex
	move	a1,a1
	jrnn	_chk_hours23
	clr	a1
	jruc	_hours_ok
_chk_hours23
	cmpi	24,a1
	jrlt	_hours_ok
	clr	a1
_hours_ok
	move	a1,*a0+,W
	move	*a0,a1,W		;Mask off unused bits for day
	andi	07h,a1
	callr	bcd2hex			;Convert to hex
	move	a1,a1
	jrnz	_chk_day7
	movk	1,a1
	jruc	_day_ok
_chk_day7
	cmpi	8,a1
	jrlt	_day_ok
	movk	1,a1
_day_ok
	move	a1,*a0+,W
	move	*a0,a1,W		;Mask off unused bits for date
	andi	03fh,a1
	callr	bcd2hex			;Convert to hex
	move	a1,a1
	jrnz	_chk_date31
	movk	1,a1
	jruc	_date_ok
_chk_date31
	cmpi	32,a1
	jrlt	_date_ok
	movk	1,a1
_date_ok
	move	a1,*a0+,W
	move	*a0,a1			;Mask off unused bits for month
	andi	01fh,a1
	callr	bcd2hex			;Convert to hex
	move	a1,a1
	jrnz	_chk_month12
	movk	1,a1
	jruc	_month_ok
_chk_month12
	cmpi	13,a1
	jrlt	_month_ok
	movk	1,a1
_month_ok

	move	a1,*a0+,W
	move	*a0,a1,W
	callr	bcd2hex			;Convert to hex
	move	a1,a1
	jrnn	_chk_year99
	clr	a1
	jruc	_year_ok
_chk_year99
	cmpi	100,a1
	jrlt	_year_ok
	clr	a1
_year_ok
	move	a1,*a0,W
	clr	a0			;All bits used for year
_get_time_done
	mmfm	sp,a0,a1,a2,a3
	rets

***********************************************
* PICCHECK - Power up test for the PIC MicroController
* Checks basic communications with the PIC chip
*
PICCHECK
	movi	1fh,a0			;Command code 0xf
	move	a0,@PIC_COMMAND,W
	movi	0fh,a0
	move	a0,@PIC_COMMAND,W
	movi	100000,a0		;Wait for Acknowledge
pic_loop
	move	@_watchdog_addr,a1,L
	move	a1,*a1,W
	move	@_soundirq_addr,a1,L
	move	*a1,a1,W
	btst	12,a1
	jrz	_got_pic_ack		;BR = got acknowledge
	dsjs	a0,pic_loop
	movk	1,a0
	jruc	_piccheck_done
_got_pic_ack
	move	@PIC_DATA,a0,W		;Read the data
	movi	010h,a1
	move	a1,@PIC_COMMAND,W	;Tell PIC we took data
	movi	100000,a1
_pic_nack_loop
	move	@_watchdog_addr,a2,L
	move	a2,*a2,W
	move	@_soundirq_addr,a2,L
	move	*a2,a2,W
	btst	12,a2
	jrnz	_got_pic_nack
	dsjs	a1,_pic_nack_loop
	movk	1,a0
	jruc	_piccheck_done
_got_pic_nack
	andi	0fh,a0
	cmpi	0fh,a0
	jrz	_pic_ok
	movk	1,a0
	jruc	_piccheck_done
_pic_ok
	clr	a0
_piccheck_done
	FRET	b5

***************************************************
* SNDCHECK - Sound Subsystem Check during CPUTEST
*
SNDCHECK
	move	b6,@_b6_save,L
	move	@_coin_counter_addr,a0,L
	movi	030h,a1
	move	a1,*a0,W
	movi	8,a1
	dsjs	a1,$
	movi	020h,a1
	move	a1,*a0,W
	movi	1000000,a1
dsp_loop1
	move	@_watchdog_addr,a0,L
	move	a0,*a0,W
	move	@_soundirq_addr,a0,L
	move	*a0,a2,W
	btst	B_SDAV,a2
	jrz	dsp_lp1_exit
	dsjs	a1,dsp_loop1
	movi	DSP,a10
	movk	1,a0
	move	a0,a11
	inc	a11
	FCALL	CHIPOUT,b5
	movk	1,a0
	jruc	dspcheck_done
dsp_lp1_exit
	move	@_sound_addr,a0,L
	move	*a0,a0,W
	andi	0ffh,a0
	cmpi	079h,a0
	jrz	dsp_next_byte
	movi	DSP,a10
	movk	1,a0
	move	a0,a11
	inc	a11
	FCALL	CHIPOUT,b5
	movk	1,a0
	jruc	dspcheck_done
dsp_next_byte
	movi	10000000,a1
dsp_loop2
	move	@_watchdog_addr,a0,L
	move	a0,*a0,W
	move	@_soundirq_addr,a0,L
	move	*a0,a2,W
	btst	B_SDAV,a2
	jrz	dsp_lp2_exit
	dsjs	a1,dsp_loop2
	movi	DSP,a10
	movk	1,a0
	move	a0,a11
	inc	a11
	FCALL	CHIPOUT,b5
	movk	1,a0
	jruc	dspcheck_done
dsp_lp2_exit
	movi	DSP,a10
	clr	a0
	move	a0,a11
	inc	a11
	FCALL	CHIPOUT,b5
	move	@_sound_addr,a0,L
	move	*a0,a0,W
	andi	0ffh,a0
	move	a0,a14
	clr	a0
	move	a0,a0
	jrz	dsp_ok
	movk	1,a0
	jruc	dspcheck_done
dsp_ok
	clr	a0
	move	a0,@_snd_status,L
	subi	2,a14
	move	a14,@_snd_diag_code,W
	clr	a14
	move	a14,@_snd_chip_count,W
	movi	SROMTAB,a12,L
snd_romok_loop
	move	*a12+,a10,L
	jrz	sndrom_done
	move	@_snd_chip_count,a14,W
	move	@_snd_diag_code,a11,W
	cmp	a11,a14
	jrnz	sndchip_ok
	movk	2,a11
	move	a11,@_snd_status,L
	jruc	snd_chip_out
sndchip_ok
	movk	1,a11
snd_chip_out
	addk	1,a14
	move	a14,@_snd_chip_count,W
	FCALL	CHIPOUT,b5
	move	@_snd_status,a11,L
	jrz	snd_romok_loop
	movk	1,a0
	jruc	dspcheck_done
sndrom_done
	movi	SNDRAMTAB,a12,L
snd_ramok_loop
	move	*a12+,a10,L
	jrz	sndram_done
	move	@_snd_diag_code,a14,W
	cmpi	8,a14
	jrnz	sndram_ok
	movk	2,a11
	move	a11,@_snd_status,L
	jruc	snd_ram_out
sndram_ok
	movk	1,a11
snd_ram_out
	FCALL	CHIPOUT,b5
	move	@_snd_status,a11,L
	jrz	snd_ramok_loop
	movk	1,a0
	jruc	dspcheck_done
sndram_done
	clr	a0
dspcheck_done
	movi	1000000,a1
dspcheck_wait_exit_loop
	move	@_watchdog_addr,a2,L
	move	a2,*a2,W
	dsjs	a1,dspcheck_wait_exit_loop
	move	@_b6_save,b6,L
	FRET	b6

**************************************************************************
*								         *
* 	CPUTEST								 *
* 									 *
* 	THE ACTUAL CPU TEST STUFF					 *
* 									 *
* 	ENTRY								 *
* 		SP	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		WHO KNOWS						 *
* 									 *
* 	CALL								 *
* 		FCALL	CPUTEST,SP					 *
*								         *
**************************************************************************
;CPUT_X	.EQU	25	;TEXT X POSITION
;CPUT_Y1	.EQU	128	;TEXT ROW 1 Y POSITION
;CPUT_Y2	.EQU	140	;TEXT ROW 2 Y POSITION
;CPUT_Y3	.EQU	152	;TEXT ROW 3 Y POSITION
;CPUT_CLR .EQU	[CPUT_Y1,CPUT_X]	;CLEAR START
;CPUT_CLRS .EQU	[CPUT_Y3-CPUT_Y1+15,200-CPUT_X]

CPUT_X	.EQU	180	;TEXT X POSITION
CPUT_Y1	.EQU	118	;TEXT ROW 1 Y POSITION
CPUT_Y2	.EQU	130	;TEXT ROW 2 Y POSITION
CPUT_Y3	.EQU	142	;TEXT ROW 3 Y POSITION
CPUT_CLRS .EQU	[CPUT_Y3-CPUT_Y1+10,389-CPUT_X]
CPUT_CLR .EQU	[CPUT_Y1,CPUT_X]	;CLEAR START

CPUTEST:	
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0
	FCALL	INITCOLR,B5		;HEY! IT LOOKS BETTER THIS WAY
	FCALL	DSCRCLR,B6		;BLOW THE SCREEN OR IT LOOKS TOO UGLY

	CLR	B0

	.if	WWFUNIT
	movi	SYSCINIT,a13
	.else
	MOVI	0FFFCH,A13
	.endif

	MOVE	A13,@SYSCTRL,W		;MAKE SURE WE'RE WRITING TO BIT MAP
	MOVI	VRAMCHIPS,A14		;VERIFY BIT MAP
	FCALL	RAMCHECK,B5

;	ENABLE VIDEO PALETTE MAP ACCESS

	.if	WWFUNIT
;	movi	PALENB,a13
	movi	SYSCINIT,a13
	andni	PALENB,a13

	.else
	MOVI	PAL_SELECT,A13
	.endif

	MOVE	A13,@SYSCTRL,W
	MOVI	PALCHIPS,A14		;VERIFY OBJECT PALETTE RAM
	FCALL	RAMCHECK,B5
	MOVE	B0,A12
	
;	DISABLE VIDEO PALETTE MAP ACCESS

	.if	WWFUNIT
	movi	SYSCINIT,a13
	.else
	MOVI	0FFFCH,A13
	.endif

	MOVE	A13,@SYSCTRL,W
	FCALL	INITCOLR,B5		;RELOAD THE COLORS
	FCALL	DSCRCLR,B6

	FCALL	CPUDRAW,B5		;SHOW THE CPU
	MOVI	CPU,A10			;WE GOT THIS FAR, CPU MUST BE OK
	MOVI	1,A11
	FCALL	CHIPOUT,B5

	MOVI	VRAMTAB,A9
	FCALL	CHIPTABLE,B5		;PLOT OUT THE CHIP TABLE

	MOVE	A12,A12
	JRZ	PSRAMCK
PBADRAM
	MOVI	RAMBADMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	PCPUBAD

PSRAMCK
	MOVI	SRAMCHECK,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	CLR	B0
	MOVI	SRAMCHIPS,A14		;VERIFY SCRATCH RAMS
	FCALL	RAMCHECK,B5
	MOVE	B0,A12
	move	sp,a1
	movi	STCKST,sp		; Set up a temporary stack
	calla	InitAddresses		; Reset the I/O Addresses
	move	a1,sp

	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	MOVE	A12,A12
	JRNZ	PBADRAM
PROMCK
	MOVI	ROMCMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	MOVI	CPUEXIT1_MESS,A0
	MOVI	[CPUT_Y2,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	MOVI	CPUEXIT2_MESS,A0
	MOVI	[CPUT_Y3,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	CLR	B0			;KEEP THE STATS HERE

	MOVI	PROMCHIPS,A14
	FCALL	ROMCHECK,B5
	JRNZ	PROMABORT

;;	move	@DIPSWITCH,a14,W
;;	andi	DP4MEG_DIAG,a14
;;	jrz	test_8meg_iroms
;;	MOVI	IROMCHIPS,A14
;;	FCALL	ROMCHECK,B5
;;	jrnz	PROMABORT
;;	movi	SYSCINIT,a14
;;	ori	0100h,a14
;;	move	a14,@SYSCTRL,W		; Image IROM bank 1
;;	movi	IROMCHIPS1,a14
;;	FCALL	ROMCHECK,b5
;;	jrnz	PROMABORT
;;
;;	jruc	irom_test_done
;;test_8meg_iroms:			; 8 Megabit Irom chips

	MOVI	IROMCHIPS_8MEG,A14
	FCALL	ROMCHECK,B5
	jrnz	PROMABORT
	movi	SYSCINIT,a14
	ori	0100h,a14
	move	a14,@SYSCTRL,W		; Image IROM bank 1
	movi	IROMCHIPS1_8MEG,a14
	FCALL	ROMCHECK,b5
	jrnz	PROMABORT
	movi	SYSCINIT,a14
	ori	0200h,a14
	move	a14,@SYSCTRL,W		; Image IROM bank 2
	movi	IROMCHIPS2_8MEG,a14
	FCALL	ROMCHECK,b5

PROMABORT
	getst	a3			;Save Z bit
	movi	SYSCINIT,a14
	move	a14,@SYSCTRL,W		; Back to IROM bank 0
	MOVE	B0,A12
	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	btst	29,a3			;Was ROM test user aborted?
	jrz	PDMACK			; br=yes (Z if cc was NZ)
	MOVE	A12,A12
	JRNZ	PBADROM

*WE CHECK ON THE DMA HERE
PDMACK
	MOVI	DMACMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_YELLOW,A3
	FCALL	STRING,B6

	FCALL	DMACHECK,B5		;CHECK THE DMA
	MOVI	DMA,A10
	MOVE	A0,A11
	MOVE	A0,A12
	INC	A11			;GREEN/RED
	FCALL	CHIPOUT,B5

	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	MOVE	A12,A12
	jrnz	PBADDMA
	movi	SNDCMESS,a0
	movi	[CPUT_Y1,CPUT_X],a1
	clr	a2
	movi	COLOR_YELLOW,a3
	FCALL	STRING,b6
	FCALL	SNDCHECK,b6
;	movi	DSP,a10
;	move	a0,a11
	move	a0,a12
;	inc	a11
;	FCALL	CHIPOUT,b5
	movi	CPUT_CLR,a0
	movi	CPUT_CLRS,a1
	movi	COLOR_BLACK,a2
	FCALL	RECTANGLE,b6
	move	a12,a12
	jrnz	PBADSND

	movi	PICCMESS,a0
	movi	[CPUT_Y1,CPUT_X],a1
	clr	a2
	movi	COLOR_YELLOW,a3
	FCALL	STRING,b6
	FCALL	PICCHECK,b5
	movi	PIC,a10
	move	a0,a11
	move	a0,a12
	inc	a11
	FCALL	CHIPOUT,b5
	movi	CPUT_CLR,a0
	movi	CPUT_CLRS,a1
	movi	COLOR_BLACK,a2
	FCALL	RECTANGLE,b6
	move	a12,a12
	JRZ	PCPUGOOD
	movi	PICBADMESS,a0
	movi	[CPUT_Y1,CPUT_X],a1
	clr	a2
	movi	COLOR_RED,a3
	FCALL	STRING,b6
	jruc	PCPUBAD
PBADSND
	movi	SNDBADMESS,a0
	movi	[CPUT_Y1,CPUT_X],a1
	clr	a2
	movi	COLOR_RED,a3
	FCALL	STRING,b6
	jruc	PCPUBAD
PBADDMA
	MOVI	DMABADMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6
	JRUC	PCPUBAD
PBADROM
	MOVI	CPUT_CLR,A0
	MOVI	CPUT_CLRS,A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6
	MOVI	ROMBADMESS,A0
	MOVI	[CPUT_Y1,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6

PCPUBAD
	MOVI	CPUPAUSE,A0
	MOVI	[CPUT_Y2,CPUT_X],A1
	CLR	A2
	MOVI	COLOR_RED,A3
	FCALL	STRING,B6

PCPUWAIT
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0

	.IF	TUNIT
	MOVI	CPU_ERROR_SND,A0
;	MOVE	A0,@SOUND,W
	move	@_sound_addr,a3,L
	move	a0,*a3,W
	.ELSE
	MOVI	0FD00H|CPU_ERROR_SND,A0
;	MOVE	A0,@SOUND,W
	move	@_sound_addr,a3,L
	move	a0,*a3,W
	MOVI	0FF00H|CPU_ERROR_SND,A0
;	MOVE	A0,@SOUND,W		; LET HIM HEAR IT
	move	@_sound_addr,a3,L
	move	a0,*a3,W
	.ENDIF

	MOVE	A13,B5
	PAUSE	10000,B6
	FCALL	fudge_switches_diag,B6
	andi	BUTTONS|START_BITS,a0
	MOVE	A0,B1
	MOVI	-1,B0			; ASSUME DON'T TIMEOUT
	CMPI	DIAGSP,SP
	JRZ	PCPUTMP1
	CMPI	BURNSP,SP
	JRZ	PCPUTMP1
	MOVI	200000H,B0
PCPUTMP1
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0
	MOVE	B0,B0
	JRN	PCPUNOTIMEOUT
	DEC	B0
	JRZ	PCPURET			; TIMEOUT HERE
PCPUNOTIMEOUT
	FCALL	fudge_switches_diag,B6
	andi	BUTTONS|START_BITS,a0
	MOVE	B1,A1
	CMP	A0,A1
	JRNZ	PCPURET
	JRUC	PCPUTMP1
PCPUGOOD
	CLR	A0
	JRUC	PCPUREALRET
PCPURET
	MOVK	1,A0
PCPUREALRET
	MOVE	A0,A0
	FRET	SP

DMACMESS
	.STRING	"CHECKING CUSTOM",0
	.EVEN
DMABADMESS
;	.STRING	"CUSTOM CHIP UE13 BAD",0
	.STRING	"CUSTOM CHIP U33 BAD",0
	.EVEN

ROMCMESS
	.STRING	"CHECKING ROMS",0
	.EVEN
ROMBADMESS
	.STRING	"ROM CHIPS BAD",0
	.EVEN

RAMBADMESS
	.STRING	"RAM CHIPS BAD",0
	.EVEN

SNDCMESS
	.string	"CHECKING SOUND SECTION",0
	.even
SNDBADMESS
	.string	"SOUND SECTION BAD",0
	.even
PICCMESS
	.string	"CHECKING PIC CHIP",0
	.even
PICBADMESS
	.string	"PIC CHIP BAD",0
	.even

CPUGOOD
	.STRING	"CPU BOARD OK",0
	.EVEN

CPUPAUSE
	.STRING	"PRESS ANY BUTTON",0
	.EVEN

CPUEXIT1_MESS
	.STRING "HOLD START BUTTON",0
	.EVEN
CPUEXIT2_MESS
	.STRING "TO EXIT.",0
	.EVEN


**************************************************************************
*								         *
* 	CPUDRAW								 *
* 									 *
* 	PLOT THE CPU BOARD AND DRAW ALL THE CHIPS			 *
* 									 *
* 	ENTRY								 *
* 		B5	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CPUDRAW:
	MOVI	CPU_VECS,A9		; POINT AT VECTOR TABLE
CPUDLP1
	MOVE	*A9+,A2,W		; GET COLOR
	JRZ	CPUD1
	MOVE	*A9+,A0,L		; START POINT
	MOVE	*A9+,A1,L		; END POINT
	FCALL	HVLINE,B6
	JRUC	CPUDLP1
CPUD1
	MOVE	B5,A13
	FCALL	CHIPPLOT,B5		; PLOT ALL THE CHIPS
;;	MOVI	BOARDSTRING,A0
;;	move	@DIPSWITCH,a1,W
;;	andi	DP4MEG_DIAG,a1
;;	jrnz	bdtype_4meg
	movi	BOARDSTRING1,a0

;;bdtype_4meg:

	MOVI	[25,270],A1
;	MOVI	[25,11],A1
	CLR	A2
	MOVI	COLOR_WHITE,A3
	FCALL	STRING,B6
	MOVI	BOARDSTRING2,A0
;	MOVI	[37,13],A1
	MOVI	[37,274],A1
	FCALL	STRING,B6
	MOVE	A13,B5
	FRET	B5

;;BOARDSTRING	
;;;	.STRING	"A-14816-40043",0
;;	.string	"A-18968-40030",0
;;	.EVEN
BOARDSTRING1:
	.string	"A-20362-08MEG",0
	.even

BOARDSTRING2
	.STRING	"NBA HANGTIME",0
	.EVEN

**************************************************************************
*								         *
* 	CHIPTABLE							 *
* 									 *
* 	UPDATE A LIST OF CHIPS, BASED ON THEIR VALUES IN A12		 *
* 									 *
* 	ENTRY								 *
* 		A9	POINTER TO TABLE				 *
* 		A12	LIST OF ON/OFF BITS				 *
* 		B5	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

CHIPTABLE:
	MOVE	B5,A14
CTABLOOP
	MOVE	*A9+,A10,L		; GET POINTER TO CHIP RECORD
	JRZ	CTABDONE
	MOVK	1,A11
	MOVE	*A10(CMNUM),A0,W	; GET THE BIT NUMBER
	BTST	A0,A12			; CHECK BIT NUMBER
	JRZ	CTABL2
	MOVK	2,A11
CTABL2
	FCALL	CHIPOUT,B5
	JRUC	CTABLOOP

CTABDONE
	MOVE	A14,B5
	FRET	B5
	
**************************************************************************
*								         *
* 	CHIPPLOT							 *
* 									 *
* 	PLOT OUT THE CHIP LIST						 *
* 									 *
* 	ENTRY								 *
* 		B5	RET VALUE					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
**************************************************************************

CHIPPLOT:
	MOVE	B5,A14
	MOVI	CPU_CHIPS,A10
CPPLOTLOOP
	CLR	A11
	MOVE	*A10,A0,L
	JRZ	CPPLOTDONE
	FCALL	CHIPOUT,B5
	ADDI	CMEND,A10
	JRUC	CPPLOTLOOP

CPPLOTDONE
	MOVE	A14,B5
	FRET	B5
	
**************************************************************************
*								         *
* 	CHIPOUT								 *
* 									 *
* 	ACTUALLY PLOT THE CHIP						 *
* 									 *
* 	ENTRY								 *
* 		A10	POINTS TO CHIP TO PLOT				 *
* 		A11	COLOR OF CHIP					 *
* 				00 = OUTLINE				 *
* 				01 = GREEN				 *
* 				02 = RED				 *
* 				03 = GREY				 *
* 									 *
* 	EXIT								 *
* 		A10	IS INTACT					 *
*								         *
**************************************************************************
		
CHIPOUT:
	MOVE	*A10(CMLOC),A5,L	; CHIP OUTLINE
	MOVE	A5,A6
	MOVE	A5,A7
	MOVE	A5,A8
	MOVE	*A10(CMXSIZE),A0,W
	ADD	A0,A6
	ADD	A0,A7
	MOVE	*A10(CMYSIZE),A0,W
	SLL	16,A0
	ADD	A0,A7
	ADD	A0,A8
	MOVE	A5,A0
	MOVE	A6,A1
	MOVI	COLOR_WHITE,A2
	FCALL	HVLINE,B6
	MOVE	A6,A0
	MOVE	A7,A1
	ADDI	[1,0],A1
	MOVI	COLOR_WHITE,A2
	FCALL	HVLINE,B6
	MOVE	A8,A0
	MOVE	A7,A1
	MOVI	COLOR_WHITE,A2
	FCALL	HVLINE,B6
	MOVE	A5,A0
	MOVE	A8,A1
	MOVI	COLOR_WHITE,A2
	FCALL	HVLINE,B6
;
	MOVE	*A10(CMSTUFFED),A0,W	; CHECK FOR STUFFED
	JRNZ	CONOSTUF
	MOVK	3,A11			; WANT IT GREY, DUDE

CONOSTUF
	MOVE	A11,A11			; CHECK FOR FILLING THE CHIP
	JRZ	CONOFILL
	MOVE	*A10(CMLOC),A0,L
	ADDI	00010001H,A0
	MOVE	*A10(CMSIZE),A1,L
	SUBI	00010001H,A1		; GET INTERNAL AREA
	MOVE	A11,A2
	SLL	4,A2
	ADDI	CHIPCOLORS,A2
	MOVE	*A2,A2,W		; GET ME A COLOR
	FCALL	RECTANGLE,B6
CONOFILL
	MOVE	*A10(CMPINLOC),A1,L	; PIN LOCATION
	MOVE	A5,A0
	ADD	A1,A0
	MOVI	COLOR_WHITE,A1
	FCALL	POINT,B6

	MOVE	*A10(CMSTRING),A0,L	; CHIP TEXT
	MOVE	A5,A1
	MOVE	*A10(CMOFFSET),A2,L
	ADD	A2,A1
	MOVE	*A10(CMDIR),A2,W
	MOVI	COLOR_BLACK,A3
	MOVE	A11,A11			; CHECK FOR COLOR
	JRNZ	COBLACK
	MOVI	COLOR_WHITE,A3
COBLACK
	FCALL	STRING,B6
	FRET	B5

CHIPCOLORS:
	.WORD	COLOR_BLACK
	.WORD	COLOR_GREEN
	.WORD	COLOR_RED
	.WORD	COLOR_GREY

**************************************************************************
*								         *
* 	DMACHECK							 *
* 									 *
* 	CHECK THE DMA OUT						 *
* 									 *
* 	ENTRY								 *
* 		B5	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		A0	DMA STATUS					 *
* 				0 = GOOD				 *
* 				1 = BAD					 *
*								         *
**************************************************************************
DMACHECK
	setf	16,1,0

;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0

	CLR	A14
	MOVE	A14,@DMACTRL,W
	MOVE	A14,@DMACTRL,W

	MOVK	DMACF4,A14
	MOVE	A14,@DMACONF,W		;ADJUST WINDOW RIGHT/LEFT BORDER
	MOVI	[511,0],A14
	MOVE	A14,@DMAWINDOW,L	;OPEN LEFT TO RIGHT
	MOVI	DMAWIN|DMACF4,A14
	MOVE	A14,@DMACONF,W		;ADJUST WINDOW RIGHT/LEFT BORDER
	MOVI	[511,0],A14
	MOVE	A14,@DMAWINDOW,L	;FULL HEIGHT WINDOW
	MOVI	[100H,100H],A14
;	MOVE	A14,@DMASCALEX
	MOVE	A14,@DMASCALEX,L

	MOVI	[1,448],A14		;BLOW OUT TRADEMARK
	MOVE	A14,@DMAHSIZE,L

	CLR	A14
	MOVE	A14,@DMAOFFST,W		;OFFSET
	MOVE	A14,@DMACONST,W		;CONSTANT
	MOVE	A14,@DMAHORIZ,L		;CLEAR DESTINATION ADDRESS

;	MOVI	2000000H,A14		;DMA LOGO LOCATION
	clr	a14
	MOVE	A14,@DMASAGL,L

	MOVI	257,A14
	MOVE	A14,@DMAVERT,W		;OFFSCREEN PLOT

	MOVI	0505H,A14
	MOVE	A14,@DMACMAP,W

	MOVI	8003H,A14		;USE IMAGE ROM - WRITE ALWAYS
	MOVE	A14,@DMACTRL,W		;KICK OFF THE DMA

	MOVI	7FFFH,A14		;LOAD TIMEOUT COUNTER
DMACWAIT

;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0

	MOVE	@DMACTRL,A0,W		;DMA BUSY?
	JRNN	DMADONE			;BR = NO, TIME TO CHECK
	DSJS	A14,DMACWAIT
	JRUC	DMACBAD			;DMA TIMED OUT

DMADONE
	CLR	A0			;GET BACK TO A REAL PALETTE
	MOVE	A0,@DMACMAP,W
	MOVI	0101000H,A0		;LINEAR SCREEN LOCATION OF DATA
	MOVI	2000000H,A1		;DMA LOGO LOCATION
	MOVI	448,A2			;NUMBER OF BYTES TO COMPARE
DMACLOOP	     
	MOVB	*A0,A3			;DESTINATION BYTE
;	SLL	28,A3
;	SRL	28,A3
	MOVB	*A1,A4			;SOURCE BYTE
;	SLL	28,A4
;	SRL	28,A4
	ADDK	8,A0
	ADDK	8,A1
	CMP	A3,A4
	JRNZ	DMACBAD			;BR = DATA ERROR
	DSJS	A2,DMACLOOP
*
*CHECK DATA IN OBJECT PALETTE
*
	.if	WWFUNIT
;	movi	PALENB,a13
	movi	SYSCINIT,a13
	andni	PALENB,a13
	.else
	MOVI	PAL_SELECT,A13
	.endif


	MOVE	A13,@SYSCTRL,W		;ENABLE PALETTE

	MOVI	0101000H,A0		;LOCATION
	MOVI	224,A2			;NUMBER OF WORDS TO COMPARE
DMACLOOP2
	MOVE	*A0+,A3,W
;	ANDI	0F0FH,A3
	CMPI	0505H,A3
	JRNZ	DMACBAD
	DSJS	A2,DMACLOOP2
	CLR	A0
	JRUC	DMACRET
DMACBAD
	CLR	A0			;GET BACK TO A REAL PALETTE
	MOVE	A0,@DMACTRL,W
	MOVE	A0,@DMACTRL,W
	MOVE	A0,@DMACMAP,W
	MOVK	1,A0
DMACRET
	.if WWFUNIT
;	movi	SYSCINIT,a3
	movi	SYSCINIT,a13
	.else
	MOVI	0FFFCH,A13
	.endif

	MOVE	A13,@SYSCTRL,W

	SETF	16,0,0

	MOVE	A0,A0
	FRET	B5


DOG_COUNT	.EQU	8000H	;EVERY 32K
	.align
**************************************************************************
*								         *
* 	RAMCHECK							 *
* 									 *
* 	CHECK A BANK OF RAM, GIVEN A STARTING TABLE ADDRESS		 *
* 									 *
* 	ENTRY								 *
* 		A14	POINTER TO RAM TABLE				 *
* 		B5	RETURN ADDRESS					 *
* 									 *
* 	EXIT								 *
* 		B0	LIST OF ERRORS					 *
*								         *
**************************************************************************

RAMCHECK:
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0

	SETF	16,0,0
	SETF	32,0,1

;	SNAG NEXT CHIP RECORD

RAMLOOP:
	CLR	B2
	MOVE	*A14(RAM_SADR),A12,L	; STARTING ADDRESS
	MOVE	*A14(RAM_EADR),A13,L	; ENDING ADDRESS
	MOVE	*A14(RAM_ITLV),A11,W	; INTERLEAVE
	MOVE	*A14(RAM_WDTH),A10,W	; WIDTH

;	CELL COUNT

	SUB	A12,A13                   ; (END-START)/INTERLEAVE+1
	DIVU	A11,A13
	INC	A13

;	SET FIELD SIZES

	MOVE	A11,A9			; FS1 = INTERLEAVE
	ANDI	ZERO_EXTEND,A9
	EXGF	A9,1

	MOVE	A10,A9			; FS0 = WIDTH
	ANDI	ZERO_EXTEND,A9
	EXGF	A9,0

;	FILL IN ASCENDING ORDER

	MOVE	A13,A9                    ; XEROX COUNT
	MOVE	A12,A8                    ; XEROX START

	MOVI	RANDOM_SEED,A7
	CLR	A5
	MOVI	DOG_COUNT,B14

RAC1
	SLA	1,A7			; GENERATE A PSEUDO
	JRV	RAC2			; RANDOM NUMBER
	movk	2,a4
	or	a4,a7
RAC2
	MOVE	A7,A6
	ADDC	A5,A6

	MOVE	A6,*A8+,1		; WRITE
	DSJS	B14,RAC1_NODOG

;	movb	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	movb	a0,*a0

	MOVI	DOG_COUNT,B14		;AND RELOAD COUNT
RAC1_NODOG
	DSJS	A9,RAC1

					;READBACK IN ASCENDING ORDER
	MOVE	A13,A9			; XEROX COUNT
	MOVE	A12,A8			; XEROX START

	MOVI	RANDOM_SEED,A7
	MOVI	DOG_COUNT,B14

RAC3	SLA	1,A7			; GENERATE A PSEUDO
	JRV	RAC4			; RANDOM NUMBER
	movk	2,a4
	or	a4,a7
RAC4	MOVE	A7,A6
	ADDC	A5,A6

	move	*a8,a4,0		;Read
	add	a11,a8
	ZEXT	A6

	CMP	A6,A4
	jrne	rac5			;Error?

	DSJS	B14,RAC5_NODOG

;	movb	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	movb	a0,*a0

	MOVI	DOG_COUNT,B14		;AND RELOAD COUNT
RAC5_NODOG
	DSJS	A9,RAC3

	jruc	showstat

rac5					;Error!
	SETF	16,0,0			; RESET FIELDS
	SETF	32,0,1
	MOVE	*A14(RAM_NMBR),A4,W	; GET BIT NUMBER TO SET
	MOVE	A4,B1
	MOVK	1,B2
	SLL	B1,B2
	OR	B2,B0			; SET THAT BIT


showstat
	SETF	16,0,0			; RESET FIELDS
	SETF	32,0,1
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0


;	B1 SHOULD BE ZERO IF THE CHIP IS COOL HERE

	MOVE	*A14(RAM_LINK),A10,L
	JRZ	RAMNOPLOT
	MOVK	1,A11
	MOVE	B2,B2
	JRZ	RAMPLOT
	MOVK	2,A11
RAMPLOT
	MOVE	B5,A9			; I HOPE THIS ONE IS SAFE!
	MOVE	B0,A13
	FCALL	CHIPOUT,B5
	MOVE	A13,B0
	MOVE	A9,B5

RAMNOPLOT
	ADDI	RAM_SIZE,A14		; ADVANCE TO NEXT GUY
	MOVE	*A14,A7,W
	JRNZ	RAMLOOP			; HERE WE GO AGAIN
	FRET	B5


**************************************************************************
*								         *
* ROMCHECK - ROUTINE TO CHECKSUM THE PROGRAM AND IMAGE ROMS.		 *
* RETURNS								 *
* 	B0  = BITS SET FOR BAD ROMS.					 *
* 	 Z = TEST FINISHED.						 *
* 	NZ = TEST ABORTED BY USER.					 *
*								         *
**************************************************************************
	.align

ROMCHECK:
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0
ROMLOOP	
	CLR	B2
	MOVE	*A14(ROM_CKSM),A13,L	; CHECK TO SEE IF ROM SOCKET THERE
	JRZ	ROMEMPTY
	CLR	A8			; CHECKSUM

	MOVI	DOG_COUNT,B14

	MOVE	*A14(ROM_SADR),A12,L	; STARTING ADDRESS
	MOVE	*A14(ROM_EADR),A13,L	; ENDING ADDRESS
	MOVE	*A14(ROM_ITLV),A11,W	; INTERLEAVE
;
;	SUM UP A GIVEN IMAGE ROM -- THE TUNIT WAY
;
	SUB	A12,A13			; (( EADDR - SADDR ) / INTERLEAVE) + 1
	DIVU	A11,A13
	INC	A13
	setf	8,0,1
rcilp
	move	*a12,a7,1		;Get a byte
	add	a11,a12
	add	a7,a8
	dsjs	b14,rcilp_nodog
;	move	a0,@WATCHDOG		;Reset
	setf	32,0,1
	move	@_watchdog_addr,a0,L
	move	a0,*a0
	setf	8,0,1
	movi	DOG_COUNT,b14		;AND RELOAD COUNT
rcilp_nodog
	dsjs	a13,rcilp

	setf	32,0,1

*LAND HERE FROM IMAGE CHECKSUM TO DETERMINE IF WE HIT IT
;ROMCKCK
	MOVE	*A14(ROM_CKSM),A7,W
ROM_COMPARE
	ZEXT	A7
	ZEXT	A8
	CMP	A7,A8
	JRZ	ROMRELOOP
	MOVE	*A14(ROM_NMBR),A4,W	; GET BIT NUMBER TO SET
	MOVE	A4,B1
	MOVK	1,B2
	SLL	B1,B2
	OR	B2,B0			; SET THAT BIT
ROMRELOOP
;	move	a0,@WATCHDOG		;Reset
	move	@_watchdog_addr,a0,L
	move	a0,*a0
	MOVE	*A14(ROM_LINK),A10,L
	JRZ	ROMNOPLOT
	MOVK	1,A11
	MOVE	B2,B2
	JRZ	ROMPLOT
	MOVK	2,A11
ROMPLOT
	MOVE	B5,A9			; I HOPE THIS ONE IS SAFE!
	MOVE	B0,A13
	FCALL	CHIPOUT,B5
	MOVE	A13,B0
	MOVE	A9,B5

ROMNOPLOT
	ADDI	ROM_SIZE,A14
*CHECKING FOR EARLY EXIT BY OPERATOR
;	MOVE	@SWITCH,A13,L
	move	@_coin_addr,a13,L
	move	*a13,a13,W
;MJL
	sll	16,a13
;MJL END

	ANDI	START_BITS,A13
	CMPI	START_BITS,A13
	JRNE	ROMABORT
;	MOVE	A13,A8
;	ANDI	00000004H,A13		;CHECK PLAYER 1 START
;	JRZ	ROMABORT		;BR = IT'S PRESSED
;	ANDI	00000020H,A8		;CHECK PLAYER 2 START
;	JRZ	ROMABORT		;BR = IT'S PRESSED
	JRUC	ROMLOOP			;BACK FOR THE NEXT
*HERE ON OPERATOR ABORT
ROMABORT
	CLRZ
	FRET	B5
ROMEMPTY
	clr	a12
	setz
	FRET	B5


**************************************************************************
*									 *
*	MONITOR STUFF							 *
*									 *
**************************************************************************
CROSS_H
CONV_PLOT
	MOVI	MON_RECS,A9
CPRLP1
	MOVE	*A9+,A2,W		; GET COLOR
	JRZ	CPRDONE
	MOVE	*A9+,A0,L		; START POINT
	MOVE	*A9+,A1,L		; DIMENSIONS
	FCALL	RECTANGLE,B6
	JRUC	CPRLP1
CPRDONE
	MOVI	MON_VECS,A9		; POINT AT VECTOR TABLE
CPVLP1
	MOVE	*A9+,A2,W		; GET COLOR
	JRZ	CPVDONE
	MOVE	*A9+,A0,L		; START POINT
	MOVE	*A9+,A1,L		; END POINT
	FCALL	HVLINE,B6
	JRUC	CPVLP1
CPVDONE
	MOVI	MON_DOTS,A9		; POINT AT DOT TABLE
CPDLP1
	MOVE	*A9+,A1,W		; GET COLOR
	JRZ	CPDDONE
	MOVE	*A9+,A0,L		; GET THE POINT
	FCALL	POINT,B6
	JRUC	CPDLP1
CPDDONE
	RETS
**************************************************************************
*									 *
*	MONITOR TEST DATA AREA						 *
*									 *
**************************************************************************

MON_VECS:
	VECMAC	ROBO_WHITE,004,004,390,004
	VECMAC	ROBO_WHITE,004,004,004,250
	VECMAC	ROBO_WHITE,004,250,390,250
	VECMAC	ROBO_WHITE,390,250,390,004
	VECMAC	ROBO_WHITE,060,005,060,250
	VECMAC	ROBO_WHITE,115,005,115,250
	VECMAC	ROBO_WHITE,170,005,170,250
	VECMAC	ROBO_WHITE,225,005,225,250
	VECMAC	ROBO_WHITE,280,005,280,250
	VECMAC	ROBO_WHITE,335,005,335,250
	VECMAC	ROBO_WHITE,005,054,390,054
	VECMAC	ROBO_WHITE,005,103,390,103
	VECMAC	ROBO_WHITE,005,152,390,152
	VECMAC	ROBO_WHITE,005,201,390,201
	.LONG	0

MON_RECS:
	VECMAC	ROBO_RED,	182,000,030,005	; TOP
	VECMAC	ROBO_GREEN,	182,005,030,006
	VECMAC	ROBO_RED,	182,250,030,005	; BOTTOM
	VECMAC	ROBO_GREEN,	182,244,030,006
	VECMAC	ROBO_RED,	000,117,005,020	; LEFT
	VECMAC	ROBO_GREEN,	005,117,006,020
	VECMAC	ROBO_RED,	390,117,005,020	; RIGHT
	VECMAC	ROBO_GREEN,	384,117,006,020
	.LONG	0

MON_DOTS:
	DOTMAC	ROBO_WHITE,032,029
	DOTMAC	ROBO_WHITE,087,029
	DOTMAC	ROBO_WHITE,142,029
	DOTMAC	ROBO_WHITE,197,029
	DOTMAC	ROBO_WHITE,252,029
	DOTMAC	ROBO_WHITE,307,029
	DOTMAC	ROBO_WHITE,362,029

	DOTMAC	ROBO_WHITE,032,078
	DOTMAC	ROBO_WHITE,087,078
	DOTMAC	ROBO_WHITE,142,078
	DOTMAC	ROBO_WHITE,197,078
	DOTMAC	ROBO_WHITE,252,078
	DOTMAC	ROBO_WHITE,307,078
	DOTMAC	ROBO_WHITE,362,078

	DOTMAC	ROBO_WHITE,032,127
	DOTMAC	ROBO_WHITE,087,127
	DOTMAC	ROBO_WHITE,142,127
	DOTMAC	ROBO_WHITE,197,127
	DOTMAC	ROBO_WHITE,252,127
	DOTMAC	ROBO_WHITE,307,127
	DOTMAC	ROBO_WHITE,362,127

	DOTMAC	ROBO_WHITE,032,176
	DOTMAC	ROBO_WHITE,087,176
	DOTMAC	ROBO_WHITE,142,176
	DOTMAC	ROBO_WHITE,197,176
	DOTMAC	ROBO_WHITE,252,176
	DOTMAC	ROBO_WHITE,307,176
	DOTMAC	ROBO_WHITE,362,176

	DOTMAC	ROBO_WHITE,032,225
	DOTMAC	ROBO_WHITE,087,225
	DOTMAC	ROBO_WHITE,142,225
	DOTMAC	ROBO_WHITE,197,225
	DOTMAC	ROBO_WHITE,252,225
	DOTMAC	ROBO_WHITE,307,225
	DOTMAC	ROBO_WHITE,362,225
	.LONG	0

PRIMARY_COLORS:
	RECTMAC	ROBO_RED,0,0,395,255
	RECTMAC	ROBO_GREEN,0,0,395,255
	RECTMAC	ROBO_BLUE,0,0,395,255
	.LONG	0

COLOR_BARS:

	RECTMAC	ROBO_BLACK,   0, 0, 49, 16
	RECTMAC	ROBO_BLACK,  49, 0, 49, 16
	RECTMAC	ROBO_BLACK,  98, 0, 49, 16
	RECTMAC	ROBO_BLACK, 147, 0, 49, 16
	RECTMAC	ROBO_BLACK, 196, 0, 49, 16	
	RECTMAC	ROBO_BLACK, 245, 0, 49, 16
	RECTMAC	ROBO_BLACK, 294, 0, 49, 16
	RECTMAC	ROBO_BLACK, 343, 0, 49, 16
	.LONG	0



**************************************************************************
*									 *
*	COLORBAR							 *
*									 *
**************************************************************************
COL_BARS
COLORBAR

	MOVI	INTENSITIES_START,A0,L
	MOVI	COLRAM+100H,A1,L

	MOVK	16, A2			;5 BITS / COLOR
	MOVK	8, A6			;# COLOR BARS
CB3
	ADDI	>F00,A1			;STEP TO NEXT PALETTE
	MOVE	*A0+,A3			;STARTING COLOR
	MOVE	*A0+,A4			;COLOR DECREMENT

	MOVE	A2,A5

CB4	MOVE	A3,*A1+
	SUB	A4,A3
	DSJS	A5,CB4
	DSJS	A6,CB3

;	=========================
;	| DISPLAY COLOR BARS	|
;	=========================

	CLR	A14
	MOVE	A14,@DMACTRL,W		; HALT THE DMA
	MOVE	A14,@DMACTRL,W
	MOVI	0101H,A14
	MOVE	A14,A8

	MOVI COLOR_BARS,  A3, L        ; COLOR BAR TABLE
	MOVI [16,0], A13, L		; POSITION INCRMENT
	MOVI	101H,A12
	MOVK   16,  A11 		; # INTENSITIES / BAR
	MOVK	8,A6			;THIS MANY BARS
CB6
	CLR A2			     ; STARTING COLOR
	MOVE	*A3+,A1,L
	JRZ	CB8
	MOVE	A8,@DMACMAP,W		;STUFF PALETTE
	MOVE	*A3+,A0,L
	ADDK	16,A3
	MOVE	A11,A10
CB7
	FCALL RECTANGLE, B6
	ADD   A13, A0
	ADD   A12, A2
	DSJS  A10, CB7
	ADD	A14,A8			;NEXT PALETTE PLEASE
	DSJ	A6,CB6

CB8
	CLR	A14
	MOVE	A14,@DMACMAP
	RETS


INTENSITIES_START

	.WORD 03E0H		   ; GREEN
	.WORD 0040H		   ; BUMP GREEN

	.WORD 7C00H		   ; RED
	.WORD 0800H		   ; BUMP RED

	.WORD 001FH		   ; BLUE
	.WORD 0002H		   ; BUMP BLUE

	.WORD 0000H		   ; BLACK
	.WORD 0000H		   ; BUMP BLACK

	.WORD 7FFFH		   ; WHITE
	.WORD 0842H		   ; BUMP WHITE

	.WORD 7FE0H		   ; YELLOW
	.WORD 0840H		   ; BUMP YELLOW

	.WORD 7C1FH		   ; PURPLE
	.WORD 0802H		   ; BUMP PURPLE

	.WORD 03FFH		   ; CYAN
	.WORD 0042H		   ; BUMP CYAN

	.LONG	0

**************************************************************************
* SWITCHTEST - Test regular or DIP switches
* A0=Mode (0=Switches, 1=DIPs)

DONEMASK	EQU	00240000H		; P1 + P2 START
	.BSS	DONECNT,32		; FOR SWITCH TEST

SWITCHTEST
	PUSH	a12,a13

	subk	1,a0
	jreq	DIPTEST
	clr	a0
	move	a0,@_switch_map_mode,L	; No switch mapping

;	CALLA	WDOGDIS
	movk	10h,A13
	MOVE	A13,@DONECNT,L
	CLR	A13			; THE HOLD ME REGISTER
	MOVE	A13,@SWSET1,L
	MOVE	A13,@SWSET2,L
	MOVI	BUT_TABLE,A9
	CLR	A10
	CALLR	BUT_PLOT		; PLOT SOME BUTTONS
	MOVI	JOY_TABLE,A9
	CALLR	JOY_PLOT		; PLOT THE JOYSTICKS
	MOVI	STR_TABLE,A9
	CALLR	STR_PLOT		; PLOT THE STRINGS
	MOVI	BUT_STRS,A9
	CALLR	STR_PLOT		; PLOT THE BUTTON STRINGS
;	MOVI	[180,0],A0
;	MOVI	[180,400],A1
	MOVI	[172,0],A0
	MOVI	[172,400],A1
	MOVI	ROBO_WHITE,A2
	FCALL	HVLINE,B6		; DRAW LITTLE WHITE LINE
SDLOOP
	PULL	a12,a13
	SLEEPK	2
	PUSH	a12,a13

;	move	@COINS,a10,W
;	move	@SWITCH,a14,W
	move	@_coin_addr,a10,L
	move	*a10,a10,W
	move	@_switch_addr,a14,L
	move	*a14,a14,W
	sll	16,a10
	sll	16,a14		;mask off top 16
	srl	16,a14
	or	a14,a10

;	MOVE	@SWITCH,A10,L		; GRAB ME A SWITCH REGISTER

	NOT	A10
	MOVE	A10,A0
	ANDI	DONEMASK,A0
	CMPI	DONEMASK,A0,L		; CHECK FOR DONE
	JRNZ	SDGO
	MOVE	@DONECNT,A0,L		;REQUIRE A CERTAIN TIME
	DEC	A0
	MOVE	A0,@DONECNT,L
	JRNE	SDGO

switchx	PULL	a12,a13
	movk	1,a0
	move	a0,@_switch_map_mode,L	; Back to menu switch map
	RETP

SDGO
	MOVE	@SWSET1,A11,L
	CMP	A11,A10			; CHECK FOR CHANGES
	JRZ	SDCK2
	MOVE	A10,@SWSET1,L
;	MOVE	@SWITCH+32,A10,L
	move	@_switch2_addr,a10,L
	move	*a10,a10,W
	NOT	A10
	SLL	16,A10
	SRL	16,A10
	JRUC	SDPRC1
SDCK2
;JML
;	MOVE	@SWITCH+32,A10,L
;	NOT	A10
;	SLL	16,A10
;	SRL	16,A10
;	move 	@SWITCH2,a10,W
	move	@_switch2_addr,a10,L
	move	*a10,a10,W
	not	a10
	sll	16,a10
	srl	16,a10
;JML End
	MOVE	@SWSET2,A11,L
	CMP	A11,A10
	JRZ	SDLOOP
SDPRC1
	MOVE	A10,@SWSET2,L
SDPROC
	CLR	A0
	MOVE	A0,@SCHANGE

	MOVI	BUT_TABLE,A9
	CALLR	BUT_PLOT
	MOVI	BUT_STRS,A9
	CALLR	STR_PLOT		; PLOT THE BUTTON STRINGS
	MOVI	JOY_TABLE,A9
	CALLR	JOY_UPDATE		; UPDATE THE JOYSTICK INFO

	MOVE	@SCHANGE,A0
	JRZ	SDLOOP

	MOVI	SWITCH_SND,A0
	MOVE	A0,@SOUND
	JRUC	SDLOOP



**************************************************************************
*											     *
* SET_DIP_COINAGE - SETUP COINAGE ACCORDING TO THE DIPSWITCHES		     *
*											     *
**************************************************************************
SET_DIP_COINAGE
	MMTM	SP,A0,A1,A2,A6

	CALLR	READ_DIP
	MOVE	A0,A2
	ANDI	DPUSECMOS,A2		;USING CMOS?
	JRNZ	SDC_X			;BR=YES, DO NOT LOAD COINAGE

	MOVE	A0,A2
	ANDI	DPCOUNTRY,A0

	SRL	DPCOUNTRY_SRL,A0	; CHANGE TO TO MULTIPLE OF 32
	SLL	5,A0

	ADDI	DIPCOINTAB,A0
	MOVE	*A0,A1,L		; POINTER TO RIGHT COIN TABLE

	ANDI	DPCOINAGE,A2
	CMPI	DPCOINAGE,A2		; CHECK FOR FREEPLAY
	JRZ	CMOS21

	SRL	DPCOINAGE_SRL,A2
	SLL	4,A2

	ADD	A2,A1
	MOVE	*A1,A1,W		; WHICH COIN TABLE TO USE

	MOVI	ADJPRICE,A0
	CALLA	GET_ADJ			;GET THE COIN SELECT NUMBER BEING USED.
	CMP	A0,A1			;DID WE CHANGE COIN MODES
	JREQ	SDC_SAMEC
	CALLA	NO_CREDS		;CLEAR CREDITS
	CALLA	CRED_P			;LINK-OUT!
SDC_SAMEC
	MOVI	ADJPRICE,A0		; MASTER PRICING
	CALLA	PUT_ADJ			; STUFF IT IN CMOS
	MOVI	ADJFREPL,A0
	CLR	A1			; MAKE SURE NO FREEPLAY
	CALLA	PUT_ADJ
CMOS20
	MOVI	ADJ1ST6,A0		;MAKE THEM UNTOUCHED PLEASE
	MOVK	1,A1
	CALLA	PUT_ADJ

	CALLA   F_ADC_S			;CHECKSUM THE ADJUSTMENTS

	CALLA	GET_CSPT
	CALLA	SET_COIN_ADJ		; SET THE ADJUSTMENTS UP IN CMOS

	CALLA   F_ADC_S			;CHECKSUM THE ADJUSTMENTS

	JRUC	SDC_X
CMOS21
	MOVI	ADJFREPL,A0
	MOVK	1,A1			; FREEPLAY, DUDE!
	CALLA	PUT_ADJ
	JRUC	CMOS20
SDC_X
	MMFM	SP,A0,A1,A2,A6
	RETS

**************************************************************************
*								         *
* 	DIPTEST								 *
* 									 *
* 	DIP SWITCH TESTING						 *
*								         *
**************************************************************************

DIPTEST:
	movk	3,a14
	move	a14,@_switch_map_mode,L	; Any button mapping
	MOVK	1,A14
	MOVE	A14,@DIP1ST,W		;YES THIS IS THE FIRST TIME THROUGH
	CALLR	READ_DIP
	MOVE	A0,@DIPVAL,W

DT_PLOT
	MOVI	DIP_VECS,A9		; POINT AT VECTOR TABLE
DTVLP1
	MOVE	*A9+,A2,W		; GET COLOR
	JRZ	DTVDONE
	MOVE	*A9+,A0,L		; START POINT
	MOVE	*A9+,A1,L		; END POINT
	FCALL	HVLINE,B6
	JRUC	DTVLP1
DTVDONE
	MOVI	DIP_STRS,A9
	CALLR	STR_PLOT

	CALLR	SET_DIP_COINAGE

	CALLR	DIPPLOT
	CALLR	DIPSTATE

	MOVE	@DIP1ST,A14,W
	JRNZ	DTL_SKIP_SND

	MOVI	DIP_SND,A0
;	MOVE	A0,@SOUND,W
	move	@_sound_addr,a9,L
	move	a0,*a9,W

DTL_SKIP_SND
	CLRM	@DIP1ST,W

	CALLA	fudge_switches		;get fudged switches in a0
	andi	BUTTONS|START_BITS,a0
	MOVE	A0,@SWSET1,L
DTLOOP
	PULL	a12,a13
	SLEEPK	1
	PUSH	a12,a13

;	CALLA	CKTEST			; EMERGENCY EXIT
	CALLA	fudge_switches		;get fudged switches in a0
	MOVE	@SWSET1,A1,L
	andi	BUTTONS|START_BITS,a0
	CMP	A0,A1
	JRNZ	DT_X

	CALLR	READ_DIP
	MOVE	@DIPVAL,A1,W
	ZEXT	A1
	CMP	A0,A1
	JRZ	DTLOOP			;BR = NO CHANGE
	MOVE	A0,@DIPVAL,W		;SAVE THE OLD
	JRUC	DT_PLOT			;PLOT THE NEW SWITCH STUFF
DT_X
	JRUC	switchx


**************************************************************************
*								         *
* 	DIPSTATE							 *
* 									 *
* 	PLOT OUT THE STATES OF ALL THE DIP SWITCHES			 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
DIPSTATE
;;	MOVI	[32,74],A0
	MOVI	[82,74],A0
	MOVI	[104,140],A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6
	MOVI	[82,284],A0
;;	MOVI	[32,284],A0
	MOVI	[104,111],A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6

	CALLR	READ_DIP
	MOVE	A0,A10			;LET'S KEEP A COPY 

	CLR	A2
	MOVI	COLOR_WHITE,A3

	CLR	A7
	MOVI	DUSECMOS_0,A1
	ANDI	DPUSECMOS,A0
	JRZ	DS1
	MOVK	1,A7
	MOVI	DUSECMOS_1,A1
DS1
	MOVE	A1,A0
;;	MOVI	[39,75],A1
	MOVI	[89,75],A1
	FCALL	STRING,B6

*PLOT CURRENT COINAGE
	MOVE	A7,A7			;ARE WE CMOS OR DIPSWITCH
	JRZ	DS_PC			;BR = DIPSWITCH

;;	MOVI	[63,75],A1
	MOVI	[113,75],A1
	MOVI	DUNUSED,A0		;JUST PRINT UNUSED
	FCALL	STRING,B6
	JRUC	DS_SC			;AND GO FOR THE NEXT SWITCHES
     	
DS_PC
	MOVI	COLOR_WHITE,A3
;;	MOVI	[51,75],A1
	MOVI	[101,75],A1
	MOVI	DCOINAGE,A0
	FCALL	STRING,B6
	MOVE	A10,A0
	ANDI	DPCOUNTRY,A0
	SRL	DPCOUNTRY_SRL,A0		
	SLL	5,A0
	ADDI	DCOINTAB,A0
	MOVE	*A0,A1,L		; POINTER TO RIGHT COIN TABLE
	MOVE	A10,A0
	ANDI	DPCOINAGE,A0
	SRL	DPCOINAGE_SRL,A0
	SLL	5,A0
	ADD	A0,A1
	MOVE	*A1,A0,L		; NOW POINTING AT MESSAGE
	CLR	A2
;;	MOVI	[51,132],A1
	MOVI	[101,132],A1
	FCALL	STRING,B6

*PLOT CREDITS TO START, CREDITS TO CONTINUE
	MOVI	DTOSTART,A0
;;	MOVI	[63,90],A1
	MOVI	[113,90],A1
	FCALL	STRING,B6

	MOVI	DTOCONTINUE,A0
;;	MOVI	[75,90],A1
	MOVI	[125,90],A1
	FCALL	STRING,B6

	MOVI	ADJCSTRT,A0
	CALLA	GET_ADJ			; GET NUMBER NEEDED ( IN A0 )
	MOVE	A0,A8
	CMPI	9,A8
	JRLS	DSTS_1
      	MOVK	9,A8
DSTS_1
	CALLA	HEXTOASC
	MOVE	A8,A0
;;	MOVI	[63,80],A1
	MOVI	[113,80],A1
	FCALL	STRING,B6

	MOVI	ADJCCONT,A0
	CALLA	GET_ADJ			; GET NUMBER NEEDED ( IN A0 )
	MOVE	A0,A8
	CMPI	9,A8
	JRLS	DSTC_1
      	MOVK	9,A8
DSTC_1
	CALLA	HEXTOASC
	MOVE	A8,A0
;;	MOVI	[75,80],A1
	MOVI	[125,80],A1
	FCALL	STRING,B6


DS_SC
*PLOT COUNTRY SELECTION
	MOVE	A10,A0
	ANDI	DPCOUNTRY,A0
	SRL	DPCOUNTRY_SRL,A0
	SLL	5,A0
	ADDI	DCOUNTRY_TAB,A0
	MOVE	*A0,A0,L
;;	MOVI	[93,75],A1
	MOVI	[143,75],A1
	FCALL	STRING,B6

*PLOT COIN COUNTER MODE
	MOVE	A10,A7
	ANDI	DPCOUNTER,A7
	SRL	DPCOUNTER_SRL,A7
	SLL	6,A7
	ADDI	DCOUNTER_TAB,A7
	MOVE	*A7+,A0,L
	MOVI	[163,75],A1
;;	MOVI	[113,75],A1
	FCALL	STRING,B6
	MOVE	*A7+,A0,L
;;	MOVI	[125,75],A1
	MOVI	[175,75],A1
	FCALL	STRING,B6


*PLOT NUMBER OF PLAYERS ALLOWED
	MOVE	A10,A0 			;ADD THE FOLLOWING FOR PLAYER #
	ANDI	DPPLAYERS,A0
	RJST	A0
	SLL	5,A0
	ADDI	DPLAYER_TAB,A0
	MOVE	*A0,A0,L


;TEMP!!! TAKE THIS OUT FOR KIT; IS THIS HOW TE SHIPPED?
;	MOVI	DUNUSED,A0


;;	MOVI	[39,285],A1
	MOVI	[89,285],A1
	FCALL	STRING,B6
;;;

*PLOT DOLLAR BILL VALIDATOR STATUS
	MOVI	DNOVALIDATOR,A0		;ASSUME NO VALIDATOR
	MOVE	A10,A1
	ANDI	DPVALIDATOR,A1		;DO WE HAVE ONE?
	JRZ	DSTS_NOV		;BR = NO
	MOVI	DVALIDATOR,A0		;ASSUME NO VALIDATOR

DSTS_NOV
	MOVI	[101,285],A1
;;	MOVI	[51,285],A1
	FCALL	STRING,B6


*PLOT SW1 SWITCH 6

;;*PLOT video clips off/on message
;;	MOVI	DCLIPS,A0		;Assume clips on
;;	MOVE	A10,A1
;;	ANDI	DPNOVIDCLIPS,A1
;;	JRZ	DSTS_NOC		;BR = NO
;;	MOVI	DNOCLIPS,A0		;Assume no clips wanted
;;
;;DSTS_NOC

	MOVI	DUNUSED,A0
;;	MOVI	[63,285],A1
	MOVI	[113,285],A1
	FCALL	STRING,B6


*PLOT SW1 SWITCH 5
	MOVI	DUNUSED,A0
;;	MOVI	[75,285],A1
	MOVI	[125,285],A1
	FCALL	STRING,B6


*PLOT SW1 SWITCH 4
	MOVI	DUNUSED,A0
;;	MOVI	[87,285],A1
	MOVI	[137,285],A1
	FCALL	STRING,B6


*PLOT SW1 SWITCH 3
;;	movi	D4MEGIROM,a0
;;	move	a10,a1
;;	andi	DP4MEG,a1
;;	jrz	dsts_4meg
;;	movi	D8MEGIROM,a0
;;dsts_4meg:

	MOVI	DUNUSED,A0
;;	MOVI	[99,285],A1
	MOVI	[149,285],A1
	FCALL	STRING,B6


*PLOT SKIP OVER POWERUP TEST MESSAGE
	MOVI	DPOWER,A0
	MOVE	A10,A1
	ANDI	DPPOWER,A1
	JRZ	DSTS_NOP
	MOVI	DNOPOWER,A0
DSTS_NOP
	MOVI	[161,285],A1
;;	MOVI	[111,285],A1
	FCALL	STRING,B6


*PLOT TEST SWITCH MESSAGE
	MOVI	DTEST_0,A0
	MOVI	[173,285],A1
;;	MOVI	[123,285],A1
	FCALL	STRING,B6

	RETS				


**************************************************************************
*								         *
* 	DIPPLOT								 *
* 									 *
* 	PLOT OUT THE DIP SWITCHES					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

DIPPLOT:
;;	MOVI	[33,21],A0
	MOVI	[83,21],A0
	MOVI	[104,38],A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6
;;	MOVI	[33,231],A0
	MOVI	[83,231],A0
	MOVI	[104,38],A1
	MOVI	COLOR_BLACK,A2
	FCALL	RECTANGLE,B6
	CALLR	READ_DIP
	CLR	A2
DIPLOOP
	MOVE	A2,A3
	SLL	5,A3
	ADDI	DIPYTAB,A3
	MOVE	*A3,A3,L
	SLL	16,A3			; GOT THE Y LOC

	CLR	A5
	CMPI	8,A2
	.IF TUNIT=0
	JRLO	DIPL2
	.ELSE
	JRHS	DIPL2
	.ENDIF
	MOVI	210,A5
DIPL2
	MOVX	A5,A3

	BTST	A2,A0			; CHECK IF BIT IS SET
	JRNZ	DIPON
	MOVI	DP_OFF,A1
	ADDI	29,A3
	MOVI	COLOR_GREY,A4
	JRUC	DIPSTR

DIPON
	MOVI	DP_ON,A1
	ADDI	32,A3
	MOVI	COLOR_WHITE,A4

DIPSTR
	MMTM	SP,A0,A2
	MOVE	A1,A0			; SET STRING
	MOVE	A3,A1			; SET LOCATION
	MOVE	A4,A3
	CLR	A2			; HORIZONTAL
	FCALL	STRING,B6
	MMFM	SP,A0,A2
	INC	A2
	CMPI	16,A2
	JRLO	DIPLOOP
	RETS


DIPYTAB
	.LONG	89,101,113,125,137,149,161,173
	.LONG	89,101,113,125,137,149,161,173
;;	.LONG	39,51,63,75,87,99,111,123
;;	.LONG	39,51,63,75,87,99,111,123


**************************************************************************
*								         *
* 	READ_DIP							 *
* 									 *
* 	READ IN BOTH DIP SWITCHES					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A0	DIP SWITCH					 *
*								         *
**************************************************************************

READ_DIP:
	MMTM	SP,A1,A2,A3

;	MOVE	@DIPSWITCH,A0,W		; READ IT IN
	move	@_dipswitch_addr,a0,L
	move	*a0,a0,W
	NOT	A0			; INVERT IT FOR TRUE BITS
	CLR	A1
	movk	7,a2
RDLOOP
	BTST	A2,A0
	JRZ	RD1
	MOVK	7,A3
	SUB	A2,A3
	BSET	A3,A1
RD1
	addk	8,a2
	BTST	A2,A0
	JRZ	RD2
	MOVK	15,A3
	SUB	A2,A3
	addk	8,a3
	BSET	A3,A1
RD2
	subk	8,a2
	DEC	A2
	JRNN	RDLOOP
	MOVE	A1,A0

	MMFM	SP,A1,A2,A3
	RETS


**************************************************************************
*									 *
*	JOY_MESS							 *
*									 *
*	PLOT THE STATUS OF A JOYSTICK AROUND A CIRCLE			 *
*									 *
*	ENTRY								 *
*		A9	CENTER OF STICK CIRCLE				 *
*		A10	BUTTON MASK					 *
*		A11	COLOR						 *
*									 *
*	EXIT								 *
*		NOTHING							 *
*									 *
**************************************************************************
	
JOY_MESS
	MOVI	JJJTAB,A8
	MOVK	4,A7
JML
	MOVI	ROBO_BLACK,A3
	SRL	1,A10
	JRNC	JM1
	MOVE	A11,A3			; SET COLOR
	MOVK	1,A14
	MOVE	A14,@SCHANGE,W
JM1
	MOVE	*A8+,A0,L
	MOVE	A9,A1			; CIRCLE CENTER
	MOVB	*A8,A2			;X CORRECTION
	ADDK	8,A8
	ADD	A2,A1
	MOVB	*A8,A2			;Y CORRECTION
	ADDK	8,A8
	SLL	16,A2
	ADD	A2,A1
	CLR	A2			; DIRECTION
	CALLR	STRNEW
	DSJS	A7,JML
	RETS
*
*JOYSTICK MESSAGE TABLE
*
JJJTAB
	.LONG	UPMESS
	.BYTE	-7,-25

	.LONG	DOWNMESS
	.BYTE	-13,18

	.LONG	LEFTMESS
	.BYTE	-39,-4

	.LONG	RIGHTMESS
	.BYTE	18,-4



**************************************************************************
*									 *
*	BUT_PLOT							 *
*									 *
*	PLOT A BUTTON TABLE ON THE SCREEN				 *
*									 *
*	ENTRY								 *
*		A9	POINTS TO BUTTON TABLE LIST			 *
*		A10	SETTINGS OF THE SWITCH REGISTER			 *
*									 *
*	EXIT								 *
*		NOTHING							 *
*									 *
**************************************************************************

BUT_PLOT:
	clr	b4			;OFFSET

	MOVE	*A9,A1,L		; XY LOC
	JRZ	BPDONE
	ADDK	32,A9			
	MOVE	*A9+,A0			; RADIUS
	MOVE	*A9+,A6,L		; COLOR
	MOVE	*A9+,A11,L		; GET MASK
	ADDK	16,A9			; SHIFT COUNT
	MOVE	*A9,A8,W		; JAMMA EXTEND-O-BIT
	JRZ	BPLOW
	MOVE	@SWSET2,A10,L
	JRUC	BPAND
BPLOW
	MOVE	@SWSET1,A10,L
BPAND
	ADDK	16,A9
	AND	A10,A11			; MASK OFF SOMETHING USEFUL
	JRZ	BPHOLLOW
	ADDI	CFILL,A6		; MASK IN THE FILL BITS
	JRUC	BPCIRC
BPHOLLOW
	MMTM	SP,A0,A1,A6
	MOVI	ROBO_BLACK,A6
	ADDI	CFILL,A6
	FCALL	CIRCLE,B6
	MMFM	SP,A0,A1,A6
	JRUC	BPCIRC2
BPCIRC
	MOVK	1,A14
	MOVE	A14,@SCHANGE,W
BPCIRC2
	FCALL	CIRCLE,B6
	JRUC	BUT_PLOT
BPDONE
	RETS

**************************************************************************
*									 *
*	JOY_PLOT							 *
*									 *
*	PLOT A BUTTON TABLE ON THE SCREEN				 *
*									 *
*	ENTRY								 *
*		A9	POINTS TO BUTTON TABLE LIST			 *
*									 *
**************************************************************************

JOY_PLOT:
	MOVE	*A9,A1,L		; XY LOC
	JRZ	JPDONE
	ADDK	32,A9			
	MOVE	*A9+,A0			; RADIUS
	MOVE	*A9,A6,L		; COLOR
	ADDI	96,A9
	FCALL	CIRCLE,B6
	JRUC	JOY_PLOT
JPDONE
	RETS

**************************************************************************
*									 *
*	JOY_UPDATE							 *
*									 *
*	UPDATE ALL THE STICK INFORMATION				 *
*									 *
*	ENTRY								 *
*		A9	JOYSTICK TABLE POINTER				 *
*		A10	SWITCH INFORMATION				 *
*									 *
*	EXIT								 *
*		NOTHING							 *
*									 *
**************************************************************************

JOY_UPDATE:
	MOVE	*A9,A1,L		; XY LOC
	JRZ	JUDONE
	ADDI	32,A9			
	MOVE	*A9+,A0			; RADIUS
	MOVE	*A9+,A11,L		; COLOR
	MOVE	*A9+,A6,L		; MASK
	MOVE	*A9+,A7			; SHIFT COUNT
	MOVE	*A9,A8			; EXTEND-O-BIT FOR JAMMA
	JRZ	JULOW
	MOVE	@SWSET2,A10,L
	JRUC	JUAND
JULOW
	MOVE	@SWSET1,A10,L
JUAND
	ADDK	16,A9
	AND	A10,A6			; MASK OFF JOYSTICK BITS
	NOT	A7
	ADDK	1,A7
	SRL	A7,A6			; ZERO BASE THE LITTLE SUCKER
	MMTM	SP,A9,A10,A8,A7
	MOVE	A1,A9			; CENTER OF STICK HERE
	MOVE	A6,A10			; BUTTON MASK
	CALLR	JOY_MESS
	MMFM	SP,A9,A10,A8,A7
	JRUC	JOY_UPDATE
JUDONE
	RETS


**************************************************************************
*									 *
*	STR_PLOT							 *
*									 *
*	PLOT A STRING TABLE ON THE SCREEN				 *
*									 *
*	ENTRY								 *
*		A9	POINTS TO STRING TABLE LIST			 *
*									 *
**************************************************************************

STR_PLOT
	MOVE	*A9,A1,L		;XY LOC
	JRZ	STDONE
	ADDK	32,A9			
	MOVE	*A9+,A0,L		;STRING PTR
	MOVE	*A9+,A3			;COLOR
	MOVE	*A9+,A2			;DIRECTION
	FCALL	STRING,B6
	JRUC	STR_PLOT
STDONE
	RETS

CFILL	EQU	0FFFF0000H


;	FORMAT
;
;	X,Y,RADIUS,COLOR,MASK,SHIFT COUNT ( FOR JOYSTICK STUFF ), EXTENDBIT

P1BC	.equ	80
P2BC	.equ	160
P3BC	.equ	240
P4BC	.equ	320
PBCY	.equ	161
;;BCY	.equ	162-40

P1BX	equ	P2BC
P2BX	equ	P4BC
PBY	equ	110

BUT_TABLE
	BUT_MAC	P1BC+20,PBCY,10,ROBO_BLUE,020H,0,0		; P1 A2
	BUT_MAC	P1BC,PBCY-12,10,ROBO_RED,010H,0,0		; P1 A1
	BUT_MAC	P1BC-20,PBCY,10,ROBO_WHITE,040H,0,0		; P1 A3

	BUT_MAC	P2BC+20,PBCY,10,ROBO_BLUE,02000H,0,0		; P2 A2
	BUT_MAC	P2BC,PBCY-12,10,ROBO_RED,01000H,0,0		; P2 A1
	BUT_MAC	P2BC-20,PBCY,10,ROBO_WHITE,04000H,0,0		; P2 A3

	BUT_MAC	P3BC+20,PBCY,10,ROBO_BLUE,020H,0,1		; P3 A2
	BUT_MAC	P3BC,PBCY-12,10,ROBO_RED,010H,0,1		; P3 A1
	BUT_MAC	P3BC-20,PBCY,10,ROBO_WHITE,040H,0,1		; P3 A3

	BUT_MAC	P4BC+20,PBCY,10,ROBO_BLUE,02000H,0,1		; P4 A2
	BUT_MAC	P4BC,PBCY-12,10,ROBO_RED,01000H,0,1		; P4 A1
	BUT_MAC	P4BC-20,PBCY,10,ROBO_WHITE,04000H,0,1		; P4 A3

	BUT_MAC	P1BC,70,10,ROBO_WHITE,00040000H,0,0	; P1 START
	BUT_MAC	P2BC,70,10,ROBO_WHITE,00200000H,0,0	; P2 START
	BUT_MAC	P3BC,70,10,ROBO_WHITE,02000000H,0,0	; P3 START
	BUT_MAC	P4BC,70,10,ROBO_WHITE,04000000H,0,0	; P4 START

	BUT_MAC 30,188,10,COLOR_GREEN,00010000H,0,0	; COIN LEFT
	BUT_MAC	30,224,10,COLOR_GREEN,00020000H,0,0	; COIN RIGHT
	BUT_MAC	75,188,10,COLOR_GREEN,00800000H,0,0	; COIN CENTER
	BUT_MAC	75,224,10,COLOR_GREEN,01000000H,0,0	; FOURTH COIN
	BUT_MAC	126,204,10,COLOR_GREEN,00400000H,0,0	; SERVICE CREDIT

	BUT_MAC	277,188,10,COLOR_GREEN,00080000H,0,0	; SLAM
	BUT_MAC	277,224,10,COLOR_GREEN,00100000H,0,0	; TEST
	BUT_MAC	352,188,10,COLOR_GREEN,10000000H,0,0	; VOLUME UP
	BUT_MAC	352,224,10,COLOR_GREEN,08000000H,0,0	; VOLUME DOWN
	BUT_MAC	194,188,10,COLOR_PURPLE,20000000H,0,0	; COINDOOR INTERLOCK
	BUT_MAC 194,224,10,COLOR_GREEN,80000000H,0,0	; BILL VALIDATOR INPUT
	.LONG	0


	;	X,Y,RADIUS,COLOR,MASK,SHIFT,EXTEND
JOY_TABLE
	BUT_MAC	P1BC,110,16,CFILL+ROBO_RED,0fH,0,0		; P1 MOVE
	BUT_MAC	P2BC,110,16,CFILL+ROBO_RED,0f00H,8,0		; P2 MOVE
	BUT_MAC	P3BC,110,16,CFILL+ROBO_RED,0fh,0,1		; P3 MOVE
	BUT_MAC	P4BC,110,16,CFILL+ROBO_RED,0f00H,8,1		; P4 MOVE
	.LONG	0


STR_TABLE
	STR_MAC	136,15,STSTART,ROBO_YELLOW,0	; JAM SWITCH MESSAGE

	STR_MAC	P1BC-24,47,P1START,ROBO_RED,0	; P1 START
	STR_MAC	P2BC-24,47,P2START,ROBO_RED,0	; P2 START
	STR_MAC	P3BC-24,47,P3START,ROBO_RED,0	; P1 START
	STR_MAC	P4BC-24,47,P4START,ROBO_RED,0	; P2 START

	STR_MAC	94,30,GETOUT1,ROBO_WHITE,0	;GET OUT MESSAGE 1

;	STR_MAC	12,233,LEFTSLOT,COLOR_GREEN,0		;LEFT COIN
;	STR_MAC	56,233,RIGHTSLOT,COLOR_GREEN,0		;RIGHT COIN
	STR_MAC	58,202,CENTER,COLOR_GREEN,0		;CENTER COIN
	STR_MAC	58,237,FOURTH,COLOR_GREEN,0		;COIN MIDDLE
	STR_MAC	10,202,COINMESS1,COLOR_GREEN,0		;BOTTOM MESSAGE
	STR_MAC	10,237,COINMESS2,COLOR_GREEN,0

	STR_MAC	102,217,SERVICE1,COLOR_GREEN,0		;SERVICE CREDIT
	STR_MAC	106,227,SERVICE2,COLOR_GREEN,0		;SERVICE CREDIT
	STR_MAC	247,202,SLAM,COLOR_GREEN,0		;SLAM
	STR_MAC	261,237,TEST,COLOR_GREEN,0		;TEST SWITCH

	STR_MAC	P1BC-15,110-3,J1MESS,ROBO_WHITE,0
	STR_MAC	P2BC-15,110-3,J2MESS,ROBO_WHITE,0
	STR_MAC	P3BC-15,110-3,J3MESS,ROBO_WHITE,0
	STR_MAC	P4BC-15,110-3,J4MESS,ROBO_WHITE,0
	STR_MAC	330,202,VOLUP,COLOR_GREEN,0		;VOLUME UP
	STR_MAC	314,237,VOLDOWN,COLOR_GREEN,0		;VOLUME DOWN
	STR_MAC	162,202,CDINTERLOCK2,COLOR_PURPLE,0	;COINDOOR INTERLOCK 2
	STR_MAC 174,237,BILLVALID,COLOR_GREEN,0		;BILL VALIDATOR
	.LONG	0


BUT_STRS
	STR_MAC	P1BC+18,PBCY-4,PASSMESS,ROBO_BLUE,0		; P1 A2
	STR_MAC	P1BC-3,PBCY-16,SHOOTMESS,ROBO_RED,0		; P1 A1
	STR_MAC	P1BC-23,PBCY-4,TURBOMESS,ROBO_WHITE,0		; P1 A3

	STR_MAC	P2BC+18,PBCY-4,PASSMESS,ROBO_BLUE,0		; P1 A2
	STR_MAC	P2BC-3,PBCY-16,SHOOTMESS,ROBO_RED,0		; P1 A1
	STR_MAC	P2BC-23,PBCY-4,TURBOMESS,ROBO_WHITE,0		; P1 A3

	STR_MAC	P3BC+18,PBCY-4,PASSMESS,ROBO_BLUE,0		; P1 A2
	STR_MAC	P3BC-3,PBCY-16,SHOOTMESS,ROBO_RED,0		; P1 A1
	STR_MAC	P3BC-23,PBCY-4,TURBOMESS,ROBO_WHITE,0		; P1 A3

	STR_MAC	P4BC+18,PBCY-4,PASSMESS,ROBO_BLUE,0		; P1 A2
	STR_MAC	P4BC-3,PBCY-16,SHOOTMESS,ROBO_RED,0		; P1 A1
	STR_MAC	P4BC-23,PBCY-4,TURBOMESS,ROBO_WHITE,0		; P1 A3

	.LONG	0

**************************************************************************
*								         *
* 	DIP SWITCH DISPLAY STUFF					 *
*								         *
**************************************************************************

DIP_VECS:
	VECMAC	COLOR_RED,20,82,60,82		; DS1
	VECMAC	COLOR_RED,20,82,20,188
	VECMAC	COLOR_RED,20,188,60,188	
	VECMAC	COLOR_RED,60,82,60,188

	VECMAC	COLOR_RED,230,82,270,82	; DS2
	VECMAC	COLOR_RED,230,82,230,188
	VECMAC	COLOR_RED,230,188,270,188	
	VECMAC	COLOR_RED,270,82,270,188

	VECMAC	COLOR_WHITE,63,92,73,92

	VECMAC	COLOR_WHITE,63,104,68,104		;COINAGE MODE
	VECMAC	COLOR_WHITE,63,128,68,128
	VECMAC	COLOR_WHITE,68,104,68,128
	VECMAC	COLOR_WHITE,68,116,73,116

	VECMAC	COLOR_WHITE,63,140,68,140	;COUNTRY
	VECMAC	COLOR_WHITE,63,152,68,152
	VECMAC	COLOR_WHITE,68,140,68,152
	VECMAC	COLOR_WHITE,68,146,73,146

	VECMAC	COLOR_WHITE,63,164,68,164	;COIN COUNTER MODE
	VECMAC	COLOR_WHITE,63,176,68,176
	VECMAC	COLOR_WHITE,68,164,68,176
	VECMAC	COLOR_WHITE,68,170,73,170

	VECMAC	COLOR_WHITE,273,92,283,92	;# OF PLAYERS

	VECMAC	COLOR_WHITE,273,104,283,104	;UNUSED
	VECMAC	COLOR_WHITE,273,116,283,116	;UNUSED
	VECMAC	COLOR_WHITE,273,128,283,128	;UNUSED
	VECMAC	COLOR_WHITE,273,140,283,140	;UNUSED
	VECMAC	COLOR_WHITE,273,152,283,152	;UNUSED
	VECMAC	COLOR_WHITE,273,164,283,164	;UNUSED

	VECMAC	COLOR_WHITE,273,176,283,176	;TEST SWITCH

	.LONG	0



DIP_STRS:
;	STR_MAC	124,8,DP_TITLE,COLOR_GREEN,0
   	STR_MAC	30,70,DP_DS1,COLOR_WHITE,0
	STR_MAC	240,70,DP_DS2,COLOR_WHITE,0

	STR_MAC	7,89,DP_DSN1,COLOR_WHITE,0
	STR_MAC	7,101,DP_DSN2,COLOR_WHITE,0
	STR_MAC	7,113,DP_DSN3,COLOR_WHITE,0
	STR_MAC	7,125,DP_DSN4,COLOR_WHITE,0
	STR_MAC	7,137,DP_DSN5,COLOR_WHITE,0
	STR_MAC	7,149,DP_DSN6,COLOR_WHITE,0
	STR_MAC	7,161,DP_DSN7,COLOR_WHITE,0
	STR_MAC	7,173,DP_DSN8,COLOR_WHITE,0

	STR_MAC	217,89,DP_DSN1,COLOR_WHITE,0
	STR_MAC	217,101,DP_DSN2,COLOR_WHITE,0
	STR_MAC	217,113,DP_DSN3,COLOR_WHITE,0
	STR_MAC	217,125,DP_DSN4,COLOR_WHITE,0
	STR_MAC	217,137,DP_DSN5,COLOR_WHITE,0
	STR_MAC	217,149,DP_DSN6,COLOR_WHITE,0
	STR_MAC	217,161,DP_DSN7,COLOR_WHITE,0
	STR_MAC	217,173,DP_DSN8,COLOR_WHITE,0
	STR_MAC	100,230,DP_INS1,ROBO_LASER,0
	.LONG	0

DP_DS1:
	.STRING	"SW2",0
;	.STRING	"UJ1",0
	.EVEN
DP_DS2:
	.STRING	"SW1",0
;	.STRING	"UJ2",0
	.EVEN

DP_DSN1
	.STRING	"8",0
	.EVEN
DP_DSN2
	.STRING	"7",0
	.EVEN
DP_DSN3
	.STRING	"6",0
	.EVEN
DP_DSN4
	.STRING	"5",0
	.EVEN
DP_DSN5
	.STRING	"4",0
	.EVEN
DP_DSN6
	.STRING	"3",0
	.EVEN	 
DP_DSN7
	.STRING	"2",0
	.EVEN
DP_DSN8
	.STRING	"1",0
	.EVEN

;D4MEGIROM:
;	.string	"4 MEG IROM",0
;	.even
;D8MEGIROM:
;	.string	"8 MEG IROM",0
;	.even

DUSECMOS_1:
	.STRING	"CMOS COINAGE",0
	.EVEN

DUSECMOS_0:
	.STRING	"DIPSWITCH COINAGE",0
	.EVEN

;DMIRROR_0
;	.STRING	"MIRROR DISPLAY",0
;	.EVEN
;
;DMIRROR_1
;	.STRING	"NORMAL DISPLAY",0
;	.EVEN

DCOUNTER_0a
	.STRING	"ONE COIN COUNTER",0
	.EVEN
DCOUNTER_0b
	.STRING	"1 COUNT/COIN",0
	.EVEN

DCOUNTER_1a
	.STRING	"TWO COIN COUNTERS",0
	.EVEN
DCOUNTER_1b
	.STRING	"1 COUNT/COIN",0
	.EVEN

DCOUNTER_2a
	.STRING	"ONE COIN COUNTER",0
	.EVEN
DCOUNTER_2b
	.STRING	"TOTALIZING ",0
	.EVEN


DCOUNTER_TAB
	.LONG	DCOUNTER_0a, DCOUNTER_0b
	.LONG	DCOUNTER_1a, DCOUNTER_1b
	.LONG	DCOUNTER_2a, DCOUNTER_2b
	.LONG	DCOUNTER_0a, DCOUNTER_0b

DCOINAGE
	.STRING	"COINAGE",0
	.EVEN

DCOUNTRY_0
	.STRING	"USA",0
	.EVEN
DCOUNTRY_2
	.STRING	"FRENCH",0
	.EVEN

DPLAYER_TAB
	.LONG	DPLAYER_0, DPLAYER_1

DCOUNTRY_1
	.STRING	"GERMAN",0
	.EVEN

DCOUNTRY_TAB
	.LONG	DCOUNTRY_0, DCOUNTRY_1, DCOUNTRY_2, DCOUNTRY_3

DCREDITS
	.STRING	"CREDITS...",0
	.EVEN
DTOSTART
	.STRING	"TO START",0
	.EVEN
DTOCONTINUE
	.STRING	"TO CONTINUE",0
	.EVEN

DTEST_0
	.STRING	"TEST SWITCH",0
	.EVEN

DPLAYER_0
	.STRING	"4 PLAYER KIT",0
	.EVEN
DPLAYER_1
	.STRING	"2 PLAYER KIT",0
	.EVEN

DNOVALIDATOR
	.STRING	"NO VALIDATOR",0
	.EVEN
DVALIDATOR
	.STRING	"VALIDATOR INST.",0
	.EVEN
;DCLIPS
;	.STRING	"SHOW VIDEO",0
;	.EVEN
;DNOCLIPS
;	.STRING	"SKIP VIDEO",0
;	.EVEN
DPOWER
	.STRING	"POWERUP TEST",0
	.EVEN
DNOPOWER
	.STRING	"SKIP TEST",0
	.EVEN

DUCOIN7
	.STRING	"FREEPLAY",0
	.EVEN

DCOINTAB
	.LONG	DUCOINTAB, DGCOINTAB, DFCOINTAB, DUCOINTAB

DP_TITLE
	.STRING	"DIPSWITCH SETTINGS",0
	.EVEN

DP_INS1
	.STRING	"PRESS ANY BUTTON TO EXIT",0
	.EVEN

DP_ON
	.STRING	"ON",0
	.EVEN
DP_OFF
	.STRING	"OFF",0

DUNUSED
DGCOIN4
DCOUNTRY_3 
	.STRING	"UNUSED",0
	.EVEN

DUCOINTAB
	.LONG	USA_1,USA_2,USA_3,USA_4,USA_ELECTITLE,DGCOIN4
	.LONG	DGCOIN4,DUCOIN7

DGCOINTAB
	.LONG	GERMAN_1,GERMAN_2,GERMAN_3,GERMAN_4,GERMAN_ELECTITLE
	.LONG	DGCOIN4,DGCOIN4,DUCOIN7

DFCOINTAB
	.LONG	FRENCH_1,FRENCH_2,FRENCH_3,FRENCH_4,FRENCH_ELECTITLE
	.LONG	DGCOIN4,DGCOIN4,DUCOIN7

DCREDTAB
	.LONG	DP_DSN2,DP_DSN1
	.LONG	DP_DSN1,DP_DSN1
	.LONG	DP_DSN2,DP_DSN2
	.LONG	DP_DSN3,DP_DSN1
	.LONG	DP_DSN4,DP_DSN1
	.LONG	DP_DSN3,DP_DSN2
	.LONG	DP_DSN4,DP_DSN2
	.LONG	DP_DSN3,DP_DSN3


	.if 0
dip_t
	STR_MAC	090h,20h,DIPMES0,ROBO_YELLOW,0 ;DIP SWITCH TEST
	STR_MAC	DS1_XPOS+16,3Ch,DIPMES1,ROBO_GREEN,0	;DIP SWITCH 1
	STR_MAC	DS2_XPOS+16,3Ch,DIPMES2,ROBO_GREEN,0	;DIP SWITCH 2
	STR_MAC	200-12*8,220,GETOUT2,ROBO_GREEN,0	;exit message
	.LONG	0

dipline_t
	.word	20,10,379,10
	.word	379,10,379,245
	.word	379,245,20,245
	.word	20,245,20,10

	.word	DS1_XPOS+12,DIP_YPOS-4,		DS1_XPOS+43,DIP_YPOS-4
	.word	DS1_XPOS+12,DIP_YPOS+109,	DS1_XPOS+43,DIP_YPOS+109
	.word	DS1_XPOS+12,DIP_YPOS-4,		DS1_XPOS+12,DIP_YPOS+109
	.word	DS1_XPOS+43,DIP_YPOS-4,		DS1_XPOS+43,DIP_YPOS+109

	.word	DS2_XPOS+12,DIP_YPOS-4,		DS2_XPOS+43,DIP_YPOS-4
	.word	DS2_XPOS+12,DIP_YPOS+109,	DS2_XPOS+43,DIP_YPOS+109
	.word	DS2_XPOS+12,DIP_YPOS-4,		DS2_XPOS+12,DIP_YPOS+109
	.word	DS2_XPOS+43,DIP_YPOS-4,		DS2_XPOS+43,DIP_YPOS+109

	.long	-1

dipline2
	.word	DS1_XPOS+45,DIP_YPOS+3,		DS1_XPOS+48,DIP_YPOS+3
	.word	DS1_XPOS+45,DIP_YPOS+4+5*14,	DS1_XPOS+48,DIP_YPOS+4+5*14
	.word	DS1_XPOS+48,DIP_YPOS+3,		DS1_XPOS+48,DIP_YPOS+4+5*14
	.word	DS1_XPOS+49,DIP_YPOS-2+3*14,	DS1_XPOS+51,DIP_YPOS-2+3*14
	.word	DS1_XPOS+45,DIP_YPOS+4+6*14,	DS1_XPOS+51,DIP_YPOS+4+6*14
	.word	DS2_XPOS+45,DIP_YPOS+4,		DS2_XPOS+51,DIP_YPOS+4
	.long	-1

country_text
	.long	cntry0,cntry1,cntry2,cntry3	;4
	.long	cntry4,cntry5,cntry6,cntry7	;8
	.long	cntry8,cntry9,cntry10,cntry11	;12
	.long	cntry12,cntry13,cntry14,cntry15	;16
	.long	cntry16,cntry17,cntry18,cntry19	;20
	.long	cntry20,cntry21,cntry22,cntry23	;24
	.long	cntry24,cntry25,cntry26,cntry0	;28
	.long	cntry0,cntry0,cntry0,cntry0	;32

	.long	cntry0,cntry0,cntry0,cntry0	;36
	.long	cntry0,cntry0,cntry0,cntry0	;40
	.long	cntry0,cntry0,cntry0,cntry0	;44
	.long	cntry0,cntry0,cntry0,cntry0	;48
	.long	cntry0,cntry0,cntry0,cntry0	;52
	.long	cntry0,cntry0,cntry0,cntry0	;56
	.long	cntry0,cntry0,cntry0,cntry0	;60
	.long	cntry0,cntry0,cntry0,cntry0	;64

cntry0	.string	"USA 1",0	;0
cntry1	.string	"USA 2",0	;1
cntry2	.string	"USA 3",0	;2
cntry3	.string	"GERMANY 1",0	;3
cntry4	.string	"GERMANY 2",0	;4
cntry5	.string	"GERMANY 3",0	;5
cntry6	.string	"FRANCE 1",0	;6
cntry7	.string	"FRANCE 2",0	;7
cntry8	.string	"FRANCE 3",0	;8
cntry9	.string	"SWISS 1",0	;9
cntry10	.string	"ITALY",0	;10
cntry11	.string	"UK 1",0	;11
cntry12	.string	"UK 2",0	;12
cntry13	.string	"UK ELEC",0	;13
cntry14	.string	"SPAIN 1",0	;14
cntry15	.string	"AUSTRALIA 1",0	;15
cntry16	.string	"JAPAN 1",0	;16
cntry17	.string	"JAPAN 2",0	;17
cntry18	.string	"AUSTRIA 1",0	;18
cntry19	.string	"BELGIUM 1",0	;19
cntry20	.string	"BELGIUM 2",0	;20
cntry21	.string	"SWEDEN",0	;21
cntry22	.string	"NEW ZEALAND",0	;22
cntry23	.string	"NETHERLANDS",0	;23
cntry24	.string	"FINLAND",0	;24
cntry25	.string	"NORWAY",0	;25
cntry26	.string	"DENMARK",0	;26

DIP_COIN1	.string	"CMOS COINAGE",0
DIP_COIN2	.string	"DIP COINAGE",0
DIP_TESTSW1	.string	"TEST MODE",0
DIP_TESTSW2	.string	"GAME MODE",0

DIPMES0	.STRING	"DIP SWITCH TEST",0
DIPMES1	.STRING	"DS1",0
DIPMES2	.STRING	"DS2",0
DIPMES01	.string	"1",0
DIPMES02	.string	"2",0
DIPMES03	.string	"3",0
DIPMES04	.string	"4",0
DIPMES05	.string	"5",0
DIPMES06	.string	"6",0
DIPMES07	.string	"7",0
DIPMES08	.string	"8",0
DIPMES18
	.STRING "1 2 3 4 5 6 7 8",0
DIPON	.STRING	"ON",0
DIPOFF	.STRING	"OFF",0

	.endif

LEFTSLOT
	.STRING "LEFT",0
	.EVEN
RIGHTSLOT
	.STRING	"RIGHT",0
	.EVEN
SERVICE1
	.STRING	"SERVICE",0
	.EVEN
SERVICE2
	.STRING	"CREDIT",0
	.EVEN

COINMESS1
	.STRING	"COIN1",0
	.EVEN
COINMESS2
	.STRING	"COIN2",0	
	.EVEN

CENTER
	.STRING	"COIN3",0
	.EVEN
FOURTH
	.STRING	"COIN4",0
	.EVEN

SLAM
	.STRING	"SLAM TILT",0
	.EVEN
TEST
	.STRING	"TEST",0
	.EVEN

VOLUP
	.STRING	"VOL. UP",0
	.EVEN
VOLDOWN
	.STRING	"VOL. DOWN",0
	.EVEN

CDINTERLOCK1
	.string	"COINDOOR",0
	.even
CDINTERLOCK2
	.string	"INTERLOCK",0
	.even
BILLVALID
	.string	"BILL IN",0
	.even



SEC_MESS_1
	.string	"LEVEL 1 SECURITY CHECK",0
	.even
SEC_MESS_2
	.string	"LEVEL 2 SECURITY CHECK FAILURE",0
	.even


J1MESS	.string	"JOY1",0
J2MESS	.string	"JOY2",0
J3MESS	.string	"JOY3",0
J4MESS	.string	"JOY4",0

PASSMESS .STRING	"P",0
SHOOTMESS .STRING	"S",0
TURBOMESS .STRING	"T",0

GETOUT2	.STRING	"PRESS ANY BUTTON TO EXIT",0
GETOUT1	.STRING	"START1 AND START2 TO EXIT",0
;	.STRING	"TEST SWITCH OFF TO EXIT",0
	.EVEN

STSTART	.STRING	"TEST SWITCHES",0
	.EVEN

P1START	.STRING	"START1",0
	.EVEN
P2START	.STRING	"START2",0
	.EVEN
P3START	.STRING	"START3",0
	.EVEN
P4START	.STRING	"START4",0
	.EVEN

LEFTMESS
	.STRING	"LFT",0
	.EVEN
RIGHTMESS
	.STRING	"RT",0
	.EVEN
UPMESS
	.STRING	"UP",0
	.EVEN
DOWNMESS
	.STRING	"DWN",0
	.EVEN

P1MOVE
	.STRING	"P1 MOVE",0
	.EVEN
P2MOVE
	.STRING	"P2 MOVE",0
	.EVEN
P3MOVE
	.STRING	"P3 MOVE",0
	.EVEN
P4MOVE
	.STRING	"P4 MOVE",0
	.EVEN


****************************************************************************
* INITCOLR: INITIALIZE COLORS; ROUTINE LOADS PALETTE 0 WITH THE COLOR	    *
*	     PALETTE USED BY DIAGNOSTIC TESTS.				    *
****************************************************************************

INITCOLR

	MOVI	COLRAM,A0,L		; PALETTE LOCATION

	.ref	DIAGP

	MOVI	DIAGP,A1,L
	MOVE	*A1+,A2,W		; LENGTH OF PALETTE
LPLP1
	MOVE	*A1+,*A0+,W
	DSJS	A2,LPLP1		; KEEP ON CHUGGIN, BABY

	CLR  A14
	MOVE A14, @CMAPSEL

	FRET B5
****************************************************************************
* POINT: FUNCTION DISPLAYS A POINT OF ANY COLOR.			    *
*									    *
*	      ENTRY: A0 = XY SCREEN ADDRESS OF THE POINT		    *
*		     A1 = COLOR VALUE					    *
*		     B6 = RETURN ADDRESS				    *
*									    *
*	      USES:  A0, A1, B2, B3, B4, B6, B10			    *
****************************************************************************

POINT:
	ADDI	SCRXFUDGE,A0

	MOVI SCRN_PTCH, DPTCH
	CLR  OFFSET

	LMO  DPTCH, B10
	MOVE B10, @CONVDP

	PIXT A1, *A0.XY

	FRET B6

****************************************************************************
* RECTANGLE: FUNCTION DISPLAYS A RECTANGLE OF ANY COLOR.		    *
*									    *
*	      ENTRY: A0 = XY SCREEN ADDRESS OF UPPER LEFT CORNER	    *
*		     A1 = XY RECTANGLE DIMENSIONS			    *
*		     A2 = COLOR VALUE					    *
*									    *
*		     B6 = RETURN ADDRESS				    *
*									    *
*	      USES:  A0, A1, A2, B2, B3, B4, B6, B7, B9, B10		    *
****************************************************************************

RECTANGLE:
	ADDI	SCRXFUDGE,A0

	MOVI SCRN_PTCH, DPTCH
	CLR  OFFSET

	LMO  DPTCH, B10
	MOVE B10, @CONVDP

	MOVE A2, COLOR1
	MOVE A0, DADDR
	MOVE A1, DYDX

	move	a1,@_temporary,L	;Temporary Storage fer these
	move	a2,SADDR
	move	@CONTROL,a1,W
	move	a1,a2
	andni	020h,a2
	move	a2,@CONTROL,W		; Pixel Transparency OFF
	move	a2,a2

	FILL  XY
	move	a1,@CONTROL,W		; Restore Pixel Transparency
	move	SADDR,a2		; Restore these reggies
	move	@_temporary,a1,L

	SUBI	SCRXFUDGE,A0

	FRET B6

****************************************************************************
* LINE: FUNCTION DRAWS HORIZONTAL OR VERTICAL LINES OF ANY COLOR.
*
*	      ENTRY: A0 = BEGINNING XY SCREEN ADDRESS
*		     A1 = ENDING XY SCREEN ADDRESS
*		     A2 = COLOR VALUE
*
*		     B6 = RETURN ADDRESS
*
*	USES: A0-A4, B3,B4,B6,B9,B10
****************************************************************************

HVLINE
	MOVI	SCRXFUDGE,A3
	ADDXY	A3,A0
	ADDXY	A3,A1

	MOVI	SCRN_PTCH,DPTCH
	CLR	OFFSET

	LMO	DPTCH,B10
	MOVE	B10,@CONVDP

	MOVE	A2,COLOR1

	MOVK	1, A2			; DRAV DX: ASSUME HORIZONTAL LINE

	MOVE	A0,A3			; DETERMINE (P2 > P1) OR (P2 < P1)
	CVXYL	A3,A3

	MOVE	A1,A4
	CVXYL	A4,A4

	CMP	A3,A4			; IF (P2 < P1) ~(INCREMENT)
	JRP	$100

	NEG	A2 			; INCREMENT IS A SIGNED WORD
	ZEXT	A2

$100	CMPXY	A0,A1			; IF VERTICAL LINE
	JRZ	$110			; DRAV DX -> DRAV DY
	SLL	16,A2
	
$110	DRAV	A2,A0			; DRAW LINE
	CMPXY	A0,A1
	JRNN	$110
	JRNZ	$110

	FRET B6


********************************
* Draw a line
* A0=YX Start
* A1=YX End
* A2=Color
* B6=Return addr
* Trashes B0-B5,B7-B13

 SUBRP	line_draw

 	ADDI	SCRXFUDGE,A0
	ADDI	SCRXFUDGE,A1

	move	a2,COLOR1
	movi	SCRN_PTCH,DPTCH
	clr	OFFSET		;B4
	lmo	DPTCH,b0
	move	b0,@CONVDP

	move	a0,b2		;YX strt
	move	a1,b10		;YX end
	clr	b7		;b:a
	subxy	b2,b10
	jrnc	bpos
	jrnv	bneg_apos
	subxy	b10,b7
	movi	-1,b11
	jruc	cmp_b_a
bneg_apos
	subxy	b10,b7
	movx	b10,b7
	movi	>ffff0000,b11
	jruc	cmp_b_a
bpos	jrnv	bpos_apos
bpos_aneg
	subxy	b10,b7
	movy	b10,b7
	movi	>1ffff,b11
	jruc	cmp_b_a
bpos_apos
	move	b10,b7
	movi	>10001,b11
cmp_b_a	clr	b12

	move	b7,b0
	srl	16,b0
	clr	b10
	movx	b7,b10
	cmp	b0,b10
	jrgt	a_ge_b

	move	b0,b10
	movx	b7,b0
	rl	16,b7		;Swap b:a
	movy	b11,b12
	sll	1,b0
	sub	b10,b0
	addk	1,b10
	move	b11,b11
	jrn	line1
line0	line	0
	jruc	ldx

a_ge_b	movx	b11,b12
	sll	1,b0
	sub	b10,b0
	move	b11,b11
	jrnn	line0
line1	line	1

ldx	FRET B6


****************************************************************************
* STRING: FUNCTION DISPLAYS AN ASCII STRING OF ANY COLOR EITHER VERTICALLY
*	   OR HORIZONTALLY.
*
*	      ENTRY: A0 = STARTING STRING ADDRESS
*		     A1 = Y:X SCREEN ADDRESS
*		     A2 = DIRECTION
*		     A3 = COLOR
*
*		     B6 = RETURN ADDRESS
*
*	      USES: A0 - A6, B0 - B4, B6 - B14
****************************************************************************
STRNEW1
	MMTM	SP,A1,A2,A3,A4,A5,A6
	FCALL	STRING,B6
	MMFM	SP,A1,A2,A3,A4,A5,A6
	RETS
STRNEW
	PUSH	a0
	CALLR	STRNEW1
	MMFM	SP,A0
	RETS

STRING
	ADDI	SCRXFUDGE,A1

	MOVI	SCRN_PTCH,DPTCH
	CLR	OFFSET

	LMO	DPTCH,B10
	MOVE	B10,@CONVDP

	MOVE	A3,COLOR1 
	CLR	COLOR0


$200	MOVB	*A0,A4			;GET CHARACTER
	JRZ	$230			;QUIT IF NULL

	ADDK	8,A0
	SUBK	32,A4			;GET POINTER TO CHARACTER HEADER
	SLL	3,A4
	ADDI	SYSFONT,A4,L
	MOVB	*A4,A4
	SLL	5,A4
	ADDI	T2_SP,A4
	MOVE	*A4+,A5			;CHAR DIMENSIONS
	MOVE	A5,A6			;SPLIT UP BYTE
	SLL	12,A6			;SHIFT UP HEIGHT TO Y
	SLL	28,A5			;STRIP AWAY HEIGHT
	SRL	28,A5
	MOVY	A6,A5
	RL	16,A5
	MOVE	A5,DYDX

	CLR	A6 			;A6 = CHAR WIDTH
	MOVX	A5,A6

	ADDK	7, A6			;ROUND UP WIDTH TO INTEGRAL NUMBER
	SRL	3, A6			;OF BYTES = SOURCE PITCH
	SLL	3, A6
	MOVE	A6,SPTCH

	MOVE	*A4,A6			;CHAR DATA
	ADDI	CBASE,A6
	MOVE	A6,SADDR
	
	MOVE	A1,DADDR

	PIXBLT	B,XY

	CLR	A6
	MOVE	A2,A2
	JRZ	$210

	MOVY	A5,A6			;A1 += (CHAR HEIGHT + SPACING)
	SRL	16,A6			;DIRECTION = DOWN
	ADDK	1,A6
	SLL	16,A6
	ADD	A6,A1
	JRUC	$200
	
$210	MOVX	A5,A6			;A1 += (CHAR WIDTH + SPACING)
	ADDK	2,A6			;DIRECTION = RIGHT
	ADD	A6,A1
	JRUC	$200

$230					;SETF 16, 1, 0
	FRET B6

STRINGCENTER:
	SETF 	8, 0, 0
	CLR	A1
	MOVE	A0,A2
SPLLOOP
	MOVE	*A0+, A4 		; GET THE CHAR
	JRZ	SPLEND			; END OF STRING

	SUBK	32, A4			; GET POINTER TO CHARACTER HEADER

	SLL	3,A4
	ADDI	SYSFONT,A4,L
	MOVB	*A4,A4
	SLL	5,A4
	ADDI	T2_SP,A4

	MOVE	*A4+, A5, 1		; CHAR DIMENSIONS
	ZEXT	A5

	SRL	4,A5			; GET JUST THE X DIMENSION

;	ADDK	7, A5			; ROUND UP WIDTH TO INTEGRAL NUMBER
;	SRL	3, A5			; OF BYTES = SOURCE PITCH
;	SLL	3, A5
        
	ADDK	2H, A5			; GIVE IN TO SPACING
	ADD	A5, A1
	JRUC	SPLLOOP

SPLEND
	SETF 	16, 1, 0
	MOVE	A2,A0			; RESTORE STRING ADDRESS
	SRL	1,A1
	MOVI	200,A2
	SUB	A1,A2
	MOVE	A2,A1
        FRET 	B6

;****************************************************************************
;* CIRCLE: FUNCTION DRAWS OUTLINE OR FILLED CIRCLES.			    *
;*									    *
;*	 ENTRY: A0 = radius						    *
;*		A1 = center  (Y:X)					    *
;*		A6 = <00:15> = color					    *
;*		A6 = <15:31> = fill: 0=no fill, 1=fill			    *
;*									    *
;*	 USES:	A0 - A8, B0, B10					    *
;****************************************************************************

CIRCLE
	ADDI	SCRXFUDGE,A1

	movi  plot8,a7		     ; assume no fill
	btst  16,a6
	jrz   CIRC0
	movi  fill4,a7
CIRC0
	movi	SCRN_PTCH,DPTCH		;Restore screen pitch and convdp
	movk	>13,b10			;this is faster
	MOVE	B10,@CONVDP
	MOVE	A6,COLOR1
	movi	[1,0],DYDX		 ; Y width always 1

	clr	a2		      ; x = 0
	move	a0,a3		      ; y = r
	move	a0,a4
	sll	1,a4
	subk	3,a4
	neg	a4		     ; d = 3 - 2*r
cloop
	cmp	a3,a2		     ; if x > y, we are done
	jrgt	done

	MOVE	A7,B0		     ; PLOT ROUTINE
	EXGPC	B0

	move  a2,a5		     ; x -> a5
	btst  31,a4
	jrz   dpos		     ; branch if d is positive

;	      d negative

	sll   2,a5		     ; 4*x -> a5
	addk  6,a5		     ; 4*x+6 -> a5
	jruc  cont

;	      d positive

dpos	sub   a3,a5		     ; x-y -> a5
	sll   2,a5		     ; 4*(x-y) -> a5
	addk  10,a5		     ; 4*(x-y)+10 -> a5
	subk  1,a3		     ; y = y - 1

cont	add   a5,a4		     ; d = d + a5
	addk  1,a2		     ; x = x + 1
	jruc  cloop

done	FRET B6

plot8
	move  a3,a5
	neg   a5		   ; -y into a5; +y in a3
	sll   16,a5
	sll   16,a3
	movx  a2,a5		   ; a3 = (y:x)
	movx  a2,a3		   ; a5 = (-y:x)

	movk  2,a8
put4
	move  a1,a0		   ; center (Y:X) in a0
	addxy a3,a0		   ; (cx+x),(cy+y)
	pixt  a6,*a0.XY
	move  a1,a0		   ; center (Y:X) in a0
	addxy a5,a0		   ; (cx+x),(cy-y)
	pixt  a6,*a0.XY
	move  a1,a0		   ; center (Y:X) in a0
	subxy a3,a0		   ; (cx-x),(cy-y)
	pixt  a6,*a0.XY
	move  a1,a0		   ; center (Y:X) in a0
	subxy a5,a0		   ; (cx-x),(cy+y)
	pixt  A6,*a0.XY
	rl    16,a3
	rl    16,a5		   ; transpose x and y	
	dsj   a8,put4
	sra   16,a3		   ; restore y

	FRET	B0

fill4:
	move  a2,b10		   ; x
	sll   1,b10		   ; 2x
	movx  b10,DYDX		   ; delta x = 2x
	move  a3,a5
	neg   a5		   ; -y into a5      +y in a3
	sll   16,a5
	sll   16,a3
	movx  a2,a5		   ; a3 = (y:x)
	movx  a2,a3		   ; a5 = (-y:x)
	movk  2,a8
put2:	
	move  a1,a0
	subxy a5,a0
	move  a0,DADDR
	fill  XY

	move  a1,a0
	subxy a3,a0
	move  a0,DADDR
	fill  XY
	rl    16,a3		   ; a3 = (x:y)
	rl    16,a5		   ; transpose x and y	
	clr   a6
	subxy a5,a6
	move  a6,a5		   ; a5 = (-x:y)
	move  a3,b10		   ; y
	sll   1,b10		   ; 2y
	movx  b10,DYDX		   ; delta x = 2y
	dsj   a8,put2
	sra   16,a3		   ; restore y

	FRET B0

********************************
*SCRCLR - CLEAR ENTIRE BIT MAP
*	USES:B2,B3,B4	CALL WITH B6
DSCRCLR
	CLR	B2
DSWRITE
	CLR	B3
	MOVE	B3,@DMACMAP,0
	MOVI	SCREEN,B3,L
	MOVI	(SCRNE-SCREEN)/32,B4,L
SCRLP	MOVE	B2,*B3+,L
	DSJS	B4,SCRLP
	FRET	B6



**************************************************************************
*								         *
* 	CPU BOARD INFORMATION						 *
*								         *
**************************************************************************

CPU_VECS:		       
;	VECMAC	COLOR_WHITE,5,15,390,15		; BOARD OUTLINE
;	VECMAC	COLOR_WHITE,390,15,390,254
;	VECMAC	COLOR_WHITE,5,253,390,253
;	VECMAC	COLOR_WHITE,5,15,5,100
;	VECMAC	COLOR_WHITE,5,100,15,100
;	VECMAC	COLOR_WHITE,15,100,15,115
;	VECMAC	COLOR_WHITE,5,115,15,115
;	VECMAC	COLOR_WHITE,5,115,5,135
;	VECMAC	COLOR_WHITE,5,135,15,135
;	VECMAC	COLOR_WHITE,15,135,15,138
;	VECMAC	COLOR_WHITE,5,138,15,138
;	VECMAC	COLOR_WHITE,5,138,5,215
;	VECMAC	COLOR_WHITE,5,215,15,215
;	VECMAC	COLOR_WHITE,15,215,15,230
;	VECMAC	COLOR_WHITE,5,230,15,230
;	VECMAC	COLOR_WHITE,5,230,5,254
;	.LONG	0
	VECMAC	COLOR_WHITE,5,5,5,243		; BOARD OUTLINE
	VECMAC	COLOR_WHITE,5,243,390,243
	VECMAC	COLOR_WHITE,390,243,390,5
	VECMAC	COLOR_WHITE,390,5,355,5
	VECMAC	COLOR_WHITE,355,5,355,10
	VECMAC	COLOR_WHITE,355,10,343,10
	VECMAC	COLOR_WHITE,343,10,343,5
	VECMAC	COLOR_WHITE,343,5,326,5
	VECMAC	COLOR_WHITE,326,5,326,10
	VECMAC	COLOR_WHITE,326,10,323,10
	VECMAC	COLOR_WHITE,323,10,323,5
	VECMAC	COLOR_WHITE,323,5,212,5
	VECMAC	COLOR_WHITE,212,5,212,10
	VECMAC	COLOR_WHITE,212,10,200,10
	VECMAC	COLOR_WHITE,200,10,200,5
	VECMAC	COLOR_WHITE,200,5,5,5
	.LONG	0


CPUXBASE	EQU	5
CPUYBASE	EQU	5


CPU_CHIPS:
;CRAM1	CHIPMAC	0,125,25,20,45,7,11,CNAMEA8,1,2,2,1	; COLOR RAM
;CRAM2	CHIPMAC	1,125,75,20,45,7,11,CNAMEC8,1,2,2,1	; COLOR RAM
;VRAM1	CHIPMAC	2,190,25,15,38,6,2,CNAMEA11,1,2,2,1	; BANK 1 VIDEO RAM
;VRAM2	CHIPMAC	3,207,25,15,38,6,2,CNAMEA12,1,2,2,1	;   (PALETTE)
;VRAM3	CHIPMAC	4,224,25,15,38,6,2,CNAMEA13,1,2,2,1
;VRAM4	CHIPMAC	5,241,25,15,38,6,2,CNAMEA14,1,2,2,1
;VRAM5	CHIPMAC	6,190,71,15,38,6,2,CNAMEB11,1,2,2,1	; BANK 2 VIDEO RAM
;VRAM6	CHIPMAC	7,207,71,15,38,6,2,CNAMEB12,1,2,2,1	;   (PIXEL)
;VRAM7	CHIPMAC	8,224,71,15,38,6,2,CNAMEB13,1,2,2,1
;VRAM8	CHIPMAC	9,241,71,15,38,6,2,CNAMEB14,1,2,2,1
;CPU	CHIPMAC	0,330,60,35,35,4,13,CNAMEB21,0,3,3,1	; CPU
;DMA	CHIPMAC	0,201,120,38,38,6,16,CNAMEE13,0,3,3,1	; DMA
;PROM1	CHIPMAC	1,155,210,20,40,7,3,CNAMEJ12,1,2,2,1	; PROGRAM ROM 1
;PROM2	CHIPMAC	0,155,167,20,40,7,3,CNAMEG12,1,2,2,1	; PROGRAM ROM 2
;IROM1	CHIPMAC	1,195,167,20,40,7,3,CNAMEG14,1,2,2,1	; IMAGE ROM
;IROM2	CHIPMAC	2,217,167,20,40,7,3,CNAMEG16,1,2,2,1	; IMAGE ROM
;IROM3	CHIPMAC	3,239,167,20,40,7,3,CNAMEG17,1,2,2,1	; IMAGE ROM
;IROM4	CHIPMAC	4,261,167,20,40,7,3,CNAMEG18,1,2,2,1	; IMAGE ROM
;IROM5	CHIPMAC	5,283,167,20,40,7,3,CNAMEG19,1,2,2,1	; IMAGE ROM
;IROM6	CHIPMAC	6,305,167,20,40,7,3,CNAMEG20,1,2,2,1	; IMAGE ROM
;IROM7	CHIPMAC	7,327,167,20,40,7,3,CNAMEG22,1,2,2,1	; IMAGE ROM
;IROM8	CHIPMAC	8,349,167,20,40,7,3,CNAMEG23,1,2,2,1	; IMAGE ROM
;IROM9	CHIPMAC	9,195,210,20,40,7,3,CNAMEJ14,1,2,2,1	; IMAGE ROM
;IROM10	CHIPMAC	10,217,210,20,40,7,3,CNAMEJ16,1,2,2,1	; IMAGE ROM
;IROM11	CHIPMAC	11,239,210,20,40,7,3,CNAMEJ17,1,2,2,1	; IMAGE ROM
;IROM12	CHIPMAC	12,261,210,20,40,7,3,CNAMEJ18,1,2,2,1	; IMAGE ROM
;IROM13	CHIPMAC	13,283,210,20,40,7,3,CNAMEJ19,1,2,2,1	; IMAGE ROM
;IROM14	CHIPMAC	14,305,210,20,40,7,3,CNAMEJ20,1,2,2,1	; IMAGE ROM
;IROM15	CHIPMAC	15,327,210,20,40,7,3,CNAMEJ22,1,2,2,1	; IMAGE ROM
;IROM16	CHIPMAC	16,349,210,20,40,7,3,CNAMEJ23,1,2,2,1	; IMAGE ROM
;SRAM1	CHIPMAC	0,50,210,13,33,4,4,CNAMEJ4,1,2,2,1	; SCRATCH PAD
;SRAM2	CHIPMAC	1,67,210,13,33,4,4,CNAMEJ5,1,2,2,1	; SCRATCH PAD
;SRAM3	CHIPMAC	2,84,210,13,33,4,4,CNAMEJ6,1,2,2,1	; SCRATCH PAD
;SRAM4	CHIPMAC	3,101,210,13,33,4,4,CNAMEJ7,1,2,2,1	; SCRATCH PAD
;	.LONG	0

CRAM1	CHIPMAC	0,347,152,30,13,5,3,CNAMEU36,0,28,2,1	; COLOR RAM (U36)
CRAM2	CHIPMAC	1,313,152,30,13,5,3,CNAMEU37,0,28,2,1	; COLOR RAM (U37)

VRAM1	CHIPMAC	2,347,207,38,13,8,3,CNAMEU14,0,36,2,1	; BANK 1 VIDEO RAM (U14)
VRAM2	CHIPMAC	3,307,207,38,13,8,3,CNAMEU15,0,36,2,1	;   (PALETTE) (U15)
VRAM3	CHIPMAC	4,267,207,38,13,8,3,CNAMEU16,0,36,2,1	; (U16)
VRAM4	CHIPMAC	5,227,207,38,13,8,3,CNAMEU17,0,36,2,1	; (U17)

VRAM5	CHIPMAC	6,347,225,38,13,8,3,CNAMEU10,0,36,2,1	; BANK 2 VIDEO RAM (U10)
VRAM6	CHIPMAC	7,307,225,38,13,8,3,CNAMEU11,0,36,2,1	;   (PIXEL) (U11)
VRAM7	CHIPMAC	8,267,225,38,13,8,3,CNAMEU12,0,36,2,1	; (U12)
VRAM8	CHIPMAC	9,227,225,38,13,8,3,CNAMEU13,0,36,2,1	; (U13)

CPU	CHIPMAC	0,330,50,35,35,7,13,CNAMEU59,0,3,3,1	; CPU (U59)

DMA	CHIPMAC	0,246,157,38,38,8,16,CNAMEU33,0,3,3,1	; DMA (U33)

PROM1	CHIPMAC	1,220,65,40,13,9,3,CNAMEU63,0,38,2,1	; PROGRAM ROM 1 (U63)
PROM2	CHIPMAC	0,220,83,40,13,9,3,CNAMEU54,0,38,2,1	; PROGRAM ROM 2 (U54)

IROM1	CHIPMAC	1,10,122,40,13,6,3,  CNAMEU133,0,38,2,1	; IMAGE ROM (U133)
IROM2	CHIPMAC	2,52,122,40,13,6,3,  CNAMEU132,0,38,2,1	; IMAGE ROM (U132)
IROM3	CHIPMAC	3,94,122,40,13,6,3,  CNAMEU131,0,38,2,1	; IMAGE ROM (U131)
IROM4	CHIPMAC	4,136,122,40,13,6,3, CNAMEU130,0,38,2,1	; IMAGE ROM (U130)

IROM5	CHIPMAC	5,10,137,40,13,6,3,  CNAMEU129,0,38,2,1	; IMAGE ROM (U129)
IROM6	CHIPMAC	6,52,137,40,13,6,3,  CNAMEU128,0,38,2,1	; IMAGE ROM (U128)
IROM7	CHIPMAC	7,94,137,40,13,6,3,  CNAMEU127,0,38,2,1	; IMAGE ROM (U127)
IROM8	CHIPMAC	8,136,137,40,13,6,3, CNAMEU126,0,38,2,1	; IMAGE ROM (U126)

IROM9	CHIPMAC	9,10,152,40,13,6,3,  CNAMEU125,0,38,2,1	; IMAGE ROM (U125)
IROM10	CHIPMAC	10,52,152,40,13,6,3, CNAMEU124,0,38,2,1	; IMAGE ROM (U124)
IROM11	CHIPMAC	11,94,152,40,13,6,3, CNAMEU123,0,38,2,1	; IMAGE ROM (U123)
IROM12	CHIPMAC	12,136,152,40,13,6,3,CNAMEU122,0,38,2,1	; IMAGE ROM (U122)

IROM13	CHIPMAC	13,10,167,40,13,6,3, CNAMEU121,0,38,2,1	; IMAGE ROM (U121)
IROM14	CHIPMAC	14,52,167,40,13,6,3, CNAMEU120,0,38,2,1	; IMAGE ROM (U120)
IROM15	CHIPMAC	15,94,167,40,13,6,3, CNAMEU119,0,38,2,1	; IMAGE ROM (U119)
IROM16	CHIPMAC	16,136,167,40,13,6,3,CNAMEU118,0,38,2,1	; IMAGE ROM (U118)

IROM17	CHIPMAC	17,10,182,40,13,6,3, CNAMEU117,0,38,2,1	; IMAGE ROM (U117)
IROM18	CHIPMAC	18,52,182,40,13,6,3, CNAMEU116,0,38,2,1	; IMAGE ROM (U116)
IROM19	CHIPMAC	19,94,182,40,13,6,3, CNAMEU115,0,38,2,1	; IMAGE ROM (U115)
IROM20	CHIPMAC	20,136,182,40,13,6,3,CNAMEU114,0,38,2,1	; IMAGE ROM (U114)

IROM21	CHIPMAC	21,10,197,40,13,6,3, CNAMEU113,0,38,2,1	; IMAGE ROM (U113)
IROM22	CHIPMAC	22,52,197,40,13,6,3, CNAMEU112,0,38,2,1	; IMAGE ROM (U112)
IROM23	CHIPMAC	23,94,197,40,13,6,3, CNAMEU111,0,38,2,1	; IMAGE ROM (U111)
IROM24	CHIPMAC	24,136,197,40,13,6,3,CNAMEU110,0,38,2,1	; IMAGE ROM (U110)

IROM25	CHIPMAC	25,10,212,40,13,6,3, CNAMEU109,0,38,2,1	; IMAGE ROM (U109)
IROM26	CHIPMAC	26,52,212,40,13,6,3, CNAMEU108,0,38,2,1	; IMAGE ROM (U108)
IROM27	CHIPMAC	27,94,212,40,13,6,3, CNAMEU107,0,38,2,1	; IMAGE ROM (U107)
IROM28	CHIPMAC	28,136,212,40,13,6,3,CNAMEU106,0,38,2,1	; IMAGE ROM (U106)

IROM29	CHIPMAC	29,10,227,40,13,6,3, CNAMEU105,0,38,2,1	; IMAGE ROM (U105)
IROM30	CHIPMAC	30,52,227,40,13,6,3, CNAMEU104,0,38,2,1	; IMAGE ROM (U104)
IROM31	CHIPMAC	31,94,227,40,13,6,3, CNAMEU103,0,38,2,1	; IMAGE ROM (U103)
IROM32	CHIPMAC	32,136,227,40,13,6,3,CNAMEU102,0,38,2,1	; IMAGE ROM (U102)

SRAM1	CHIPMAC	0,225,101,30,13,4,3,CNAMEU49,0,28,2,1	; SCRATCH PAD (U49)

PIC	CHIPMAC	0,177,65,40,13,9,3,CNAMEU64,0,38,2,1	; PIC CHIP (U64)

SROM1	CHIPMAC	1,49,57,40,13,14,3, CNAMEU2,0,38,2,1	; Sound Rom (U2)
SROM2	CHIPMAC	2,49,72,40,13,14,3, CNAMEU3,0,38,2,1	; Sound Rom (U3)
SROM3	CHIPMAC	3,49,87,40,13,14,3, CNAMEU4,0,38,2,1	; Sound Rom (U4)
SROM4	CHIPMAC	4,49,102,40,13,14,3,CNAMEU5,0,38,2,1	; Sound Rom (U5)
SROM5	CHIPMAC	5,7,57,40,13,14,3,  CNAMEU6,0,38,2,1	; Sound Rom (U6)
SROM6	CHIPMAC	6,7,72,40,13,14,3,  CNAMEU7,0,38,2,1	; Sound Rom (U7)
SROM7	CHIPMAC	7,7,87,40,13,14,3,  CNAMEU8,0,38,2,1	; Sound Rom (U8)
SROM8	CHIPMAC	8,7,102,40,13,14,3, CNAMEU9,0,38,2,1	; Sound Rom (U9)

DSP	CHIPMAC	0,118,77,35,35,13,13,CNAMEU1,0,3,3,1	; Sound DSP (U1)

SNDRAM1	CHIPMAC	1,115,29,40,13,9,3,CNAMEU86,0,38,2,1	; Sound Ram 1 (U86)
SNDRAM2	CHIPMAC	2,115,44,40,13,9,3,CNAMEU80,0,38,2,1	; Sound Ram 2 (U80)
SNDRAM3	CHIPMAC	3,115,59,40,13,9,3,CNAMEU73,0,38,2,1	; Sound Ram 3 (U73)
	.LONG	0

VRAMTAB	.LONG	CRAM1,CRAM2
	.LONG	VRAM1,VRAM2,VRAM3,VRAM4,VRAM5,VRAM6
	.LONG	VRAM7,VRAM8
	.LONG	0
PROMTAB	.LONG	PROM1,PROM2
	.LONG	0
IROMTAB	.LONG	IROM1,IROM2,IROM3,IROM4
	.LONG	IROM5,IROM6,IROM7,IROM8
	.LONG	IROM9,IROM10,IROM11,IROM12
	.LONG	IROM13,IROM14,IROM15,IROM16
	.long	IROM17,IROM18,IROM19,IROM20
	.long	IROM21,IROM22,IROM23,IROM24
	.long	IROM25,IROM26,IROM27,IROM28
	.long	IROM29,IROM30,IROM31,IROM32
	.LONG	0
;SRAMTAB	.LONG	SRAM1,SRAM2,SRAM3,SRAM4
SRAMTAB	.LONG	SRAM1
	.LONG	0
SROMTAB	.long	SROM1, SROM2, SROM3, SROM4
;;	.long	SROM5, SROM6, SROM7, SROM8
	.long	0
SNDRAMTAB
	.long	SNDRAM1, SNDRAM2, SNDRAM3
	.long	0

CNAMEU1
	.string	"U1",0
	.even
CNAMEU2
	.string	"U2",0
	.even
CNAMEU3
	.string	"U3",0
	.even
CNAMEU4
	.string	"U4",0
	.even
CNAMEU5
	.string	"U5",0
	.even
CNAMEU6
	.string	"U6",0
	.even
CNAMEU7
	.string	"U7",0
	.even
CNAMEU8
	.string	"U8",0
	.even
CNAMEU9
	.string	"U9",0
	.even
CNAMEU10
	.string	"U10",0
	.even
CNAMEU11
	.string	"U11",0
	.even
CNAMEU12
	.string	"U12",0
	.even
CNAMEU13
	.string	"U13",0
	.even
CNAMEU14
	.string	"U14",0
	.even
CNAMEU15
	.string	"U15",0
	.even
CNAMEU16
	.string	"U16",0
	.even
CNAMEU17
	.string	"U17",0
	.even
CNAMEU33
	.string	"U33",0
	.even
CNAMEU36
	.string	"U36",0
	.even
CNAMEU37
	.string	"U37",0
	.even
CNAMEU49
	.string	"U49",0
	.even
CNAMEU54
	.string	"U54",0
	.even
CNAMEU59
	.string	"U59",0
	.even
CNAMEU63
	.string	"U63",0
	.even
CNAMEU64
	.string	"U64",0
	.even
CNAMEU73
	.string	"U73",0
	.even
CNAMEU80
	.string	"U80",0
	.even
CNAMEU86
	.string	"U86",0
	.even
CNAMEU133
	.string	"U133",0
	.even
CNAMEU132
	.string	"U132",0
	.even
CNAMEU131
	.string	"U131",0
	.even
CNAMEU130
	.string	"U130",0
	.even
CNAMEU129
	.string	"U129",0
	.even
CNAMEU128
	.string	"U128",0
	.even
CNAMEU127
	.string	"U127",0
	.even
CNAMEU126
	.string	"U126",0
	.even
CNAMEU125
	.string	"U125",0
	.even
CNAMEU124
	.string	"U124",0
	.even
CNAMEU123
	.string	"U123",0
	.even
CNAMEU122
	.string	"U122",0
	.even
CNAMEU121
	.string	"U121",0
	.even
CNAMEU120
	.string	"U120",0
	.even
CNAMEU119
	.string	"U119",0
	.even
CNAMEU118
	.string	"U118",0
	.even
CNAMEU117
	.string	"U117",0
	.even
CNAMEU116
	.string	"U116",0
	.even
CNAMEU115
	.string	"U115",0
	.even
CNAMEU114
	.string	"U114",0
	.even
CNAMEU113
	.string	"U113",0
	.even
CNAMEU112
	.string	"U112",0
	.even
CNAMEU111
	.string	"U111",0
	.even
CNAMEU110
	.string	"U110",0
	.even
CNAMEU109
	.string	"U109",0
	.even
CNAMEU108
	.string	"U108",0
	.even
CNAMEU107
	.string	"U107",0
	.even
CNAMEU106
	.string	"U106",0
	.even
CNAMEU105
	.string	"U105",0
	.even
CNAMEU104
	.string	"U104",0
	.even
CNAMEU103
	.string	"U103",0
	.even
CNAMEU102
	.string	"U102",0
	.even
	
;CNAMEA8
;	.STRING	"UA8",0
;	.EVEN
;CNAMEA11	
;	.STRING	"UA11",0
;	.EVEN
;CNAMEA12	
;	.STRING	"UA12",0
;	.EVEN
;CNAMEA13	
;	.STRING	"UA13",0
;	.EVEN
;CNAMEA14	
;	.STRING	"UA14",0
;	.EVEN
;
;CNAMEB11
;	.STRING	"UB11",0
;	.EVEN
;CNAMEB12
;	.STRING	"UB12",0
;	.EVEN
;CNAMEB13
;	.STRING	"UB13",0
;	.EVEN
;CNAMEB14
;	.STRING	"UB14",0
;	.EVEN
;CNAMEB21
;	.STRING	"UB21",0
;	.EVEN
;
;CNAMEC8
;	.STRING	"UC8",0
;	.EVEN
;
;CNAMEE13
;	.STRING	"UE13",0
;	.EVEN
;
;CNAMEG12	
;	.STRING	"UG12",0
;	.EVEN
;CNAMEG14
;	.STRING	"UG14",0
;	.EVEN
;CNAMEG16	
;	.STRING	"UG16",0
;	.EVEN
;CNAMEG17
;	.STRING	"UG17",0
;	.EVEN
;CNAMEG18	
;	.STRING	"UG18",0
;	.EVEN
;CNAMEG19	
;	.STRING	"UG19",0
;	.EVEN
;CNAMEG20	
;	.STRING	"UG20",0
;	.EVEN
;CNAMEG22	
;	.STRING	"UG22",0
;	.EVEN
;CNAMEG23	
;	.STRING	"UG23",0
;	.EVEN
;
;CNAMEJ4
;	.STRING	"UJ4",0
;	.EVEN
;CNAMEJ5
;	.STRING	"UJ5",0
;	.EVEN
;CNAMEJ6
;	.STRING	"UJ6",0
;	.EVEN
;CNAMEJ7
;	.STRING	"UJ7",0
;	.EVEN
;CNAMEJ12
;	.STRING	"UJ12",0
;	.EVEN
;CNAMEJ14
;       	.STRING	"UJ14",0
;	.EVEN
;CNAMEJ16
;	.STRING	"UJ16",0
;	.EVEN
;CNAMEJ17
;	.STRING	"UJ17",0
;	.EVEN
;CNAMEJ18
;	.STRING	"UJ18",0
;	.EVEN
;CNAMEJ19
;	.STRING	"UJ19",0
;	.EVEN
;CNAMEJ20
;	.STRING	"UJ20",0
;	.EVEN
;CNAMEJ22
;	.STRING	"UJ22",0
;	.EVEN
;CNAMEJ23
;	.STRING	"UJ23",0
;	.EVEN


**************************************************************************
*								         *
* 	RAM CHIP DATA							 *
*								         *
**************************************************************************

;
;	MAKE SURE THESE TABLES CORRESPOND WITH THE STUFF ABOVE
;

VRAMCHIPS:
;	COLOR RAMS

;;	RAM_CHIP 0,0, 8, 16, 1800000H, 187FFF0H		; UA8  (  0 - 3  )
;;	RAM_CHIP 0,1, 8, 16, 1800008H, 187FFF8H		; UC8  (  8 - 11 )

	RAM_CHIP 0,1, 8, 16, 1880000H, 18FFFF0H		; U37  (  0 - 7  )
	RAM_CHIP 0,0, 7, 16, 1880008H, 18FFFF8H		; U36  (  8 - 14 )

;	VIDEO RAMS
;	RAM_CHIP $MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR 		
;	RAM_CHIP 0, 6, 8, 32, 0000018H, 03FFFF8H	; UB11 ( 24 - 27 )
;	RAM_CHIP 0, 8, 8, 32, 0000010H, 03FFFF0H	; UB13 ( 16 - 19 )
;	RAM_CHIP 0, 7, 8, 32, 0000008H, 03FFFE8H	; UB12 (  8 - 11 )
;	RAM_CHIP 0, 9, 8, 32, 0000000H, 03FFFE0H	; UB14 (  0 - 3  )
	RAM_CHIP 0, 8, 8, 32, 0000018H, 03FFFF8H	; U12
	RAM_CHIP 0, 4, 8, 32, 0000010H, 03FFFF0H	; U16
	RAM_CHIP 0, 9, 8, 32, 0000008H, 03FFFE8H	; U13
	RAM_CHIP 0, 5, 8, 32, 0000000H, 03FFFE0H	; U17

	.LONG	0

PALCHIPS:
;	VIDEO PALETTE RAMS
;	RAM_CHIP $MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR 		
;	RAM_CHIP 0,2, 8, 32, 0000018H, 03FFFF8H		; UA11 (  24 - 27 )
;	RAM_CHIP 0,4, 8, 32, 0000010H, 03FFFF0H		; UA13 (  16 - 19  )
;	RAM_CHIP 0,3, 8, 32, 0000008H, 03FFFE8H		; UA12 (  8 - 11 )
;	RAM_CHIP 0,5, 8, 32, 0000000H, 03FFFE0H		; UA14 (  0 - 3  )
	RAM_CHIP 0,6, 8, 32, 0000018H, 03FFFF8H		; U10
	RAM_CHIP 0,2, 8, 32, 0000010H, 03FFFF0H		; U14
	RAM_CHIP 0,7, 8, 32, 0000008H, 03FFFE8H		; U11
	RAM_CHIP 0,3, 8, 32, 0000000H, 03FFFE0H		; U15
	.LONG	0

;	SCRATCH RAMS

SRAMCHECK
	.STRING	"CHECKING SCRATCH RAMS",0
	.EVEN

SRAMCHIPS
;	RAM_CHIP SRAM4,3, 4, 16, 1000004H, 13FFFF4H	; UJ7 (  4 - 7  )
;	RAM_CHIP SRAM3,2, 4, 16, 1000000H, 13FFFF0H	; UJ6 (  0 - 3  )
;	RAM_CHIP SRAM2,1, 4, 16, 1000008H, 13FFFF8H	; UJ5 (  8 - 11 )
;	RAM_CHIP SRAM1,0, 4, 16, 100000CH, 13FFFFCH	; UJ4 ( 12 - 15 )
	RAM_CHIP SRAM1,0, 16, 16, 1000000H, 13FFFF0H	; U49 (0-15)
	.LONG	0

****************************************************************************
* SYSFONT: SYSTEM FONT; MODULE DEFINES THE FONT USED WITH SYSTEM	    *
*	    DIAGNOSTICS.						    *
****************************************************************************

; ===========================
; | DYDX CHAR DIMENSIONS    |
; | POINTER TO XY CHAR DATA |
; ===========================

T2_SP	.WORD	048h
	.word	I2_SP-CBASE

T2_MN	.WORD	088h
	.WORD	I2_MN-CBASE

T2_PER	.WORD	028H
	.WORD	I2_PER-CBASE

T2_SLASH
	.WORD	068H
	.WORD	I2_SLASH-CBASE
T2_00
   .WORD    068h
   .WORD    I2_00-CBASE

T2_11:
   .WORD    068h
   .WORD    I2_11-CBASE

T2_22:
   .WORD    068h
   .WORD    I2_22-CBASE

T2_33:
   .WORD    068h
   .WORD    I2_33-CBASE

T2_44:
   .WORD    068h
   .WORD    I2_44-CBASE

T2_55:
   .WORD    068h
   .WORD    I2_55-CBASE

T2_66:
   .WORD    068h
   .WORD    I2_66-CBASE

T2_77:
   .WORD    068h
   .WORD    I2_77-CBASE

T2_88:
   .WORD    068h
   .WORD    I2_88-CBASE

T2_99:
   .WORD    068h
   .WORD    I2_99-CBASE

T2_AA:
   .WORD    068h
   .WORD    I2_AA-CBASE

T2_BB:
   .WORD    068h
   .WORD    I2_BB-CBASE

T2_CC:
   .WORD    068h
   .WORD    I2_CC-CBASE

T2_DD:
   .WORD    068h
   .WORD    I2_DD-CBASE

T2_EE:
   .WORD    068h
   .WORD    I2_EE-CBASE

T2_FF:
   .WORD    068h
   .WORD    I2_FF-CBASE

T2_GG:
   .WORD    068h
   .WORD    I2_GG-CBASE

T2_HH:
   .WORD    068h
   .WORD    I2_HH-CBASE

T2_II:
   .WORD    028h
   .WORD    I2_II-CBASE

T2_JJ:
   .WORD    068h
   .WORD    I2_JJ-CBASE

T2_KK:
   .WORD    068h
   .WORD    I2_KK-CBASE

T2_LL:
   .WORD    058h
   .WORD    I2_LL-CBASE

T2_MM:
   .WORD    0A8h
   .WORD    I2_MM-CBASE

T2_NN:
   .WORD    078h
   .WORD    I2_NN-CBASE

T2_OO:
   .WORD    078h
   .WORD    I2_OO-CBASE

T2_PP:
   .WORD    068h
   .WORD    I2_PP-CBASE

T2_QQ:
   .WORD    07Ah
   .WORD    I2_QQ-CBASE

T2_RR:
   .WORD    068h
   .WORD    I2_RR-CBASE

T2_SS:
   .WORD    068h
   .WORD    I2_SS-CBASE

T2_TT:
   .WORD    068h
   .WORD    I2_TT-CBASE

T2_UU:
   .WORD    068h
   .WORD    I2_UU-CBASE

T2_VV:
   .WORD    078h
   .WORD    I2_VV-CBASE

T2_WW:
   .WORD    0B8h
   .WORD    I2_WW-CBASE

T2_XX:
   .WORD    078h
   .WORD    I2_XX-CBASE

T2_YY:
   .WORD    068h
   .WORD    I2_YY-CBASE

T2_ZZ:
   .WORD    068h
   .WORD    I2_ZZ-CBASE

; ===========================
; | CHARACTER DIRECTORY     |
; ===========================

SYSFONT

	.BYTE	(T2_SP-T2_SP)/32	;SPACE CHARACTER, " "
	.BYTE	(T2_SP-T2_SP)/32	;FILLER
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_SP-T2_SP)/32
	.BYTE	(T2_MN-T2_SP)/32	; MINUS CHARACTER, "-"
	.BYTE	(T2_PER-T2_SP)/32
	.BYTE	(T2_SLASH-T2_SP)/32	; "/"
	.BYTE	(T2_00-T2_SP)/32	;0
	.BYTE	(T2_11-T2_SP)/32	;1
	.BYTE	(T2_22-T2_SP)/32	;2
	.BYTE	(T2_33-T2_SP)/32	;3
	.BYTE	(T2_44-T2_SP)/32	;4
	.BYTE	(T2_55-T2_SP)/32	;5
	.BYTE	(T2_66-T2_SP)/32	;6
	.BYTE	(T2_77-T2_SP)/32	;7
	.BYTE	(T2_88-T2_SP)/32	;8
	.BYTE	(T2_99-T2_SP)/32	;9
	.BYTE	(T2_00-T2_SP)/32			; no :
	.BYTE	(T2_00-T2_SP)/32			; no ;
	.BYTE	(T2_00-T2_SP)/32			; no <
	.BYTE	(T2_00-T2_SP)/32			; no =
	.BYTE	(T2_00-T2_SP)/32			; no >
	.BYTE	(T2_00-T2_SP)/32			; no ?
	.BYTE	(T2_00-T2_SP)/32			; no @
	.BYTE	(T2_AA-T2_SP)/32	;A
	.BYTE	(T2_BB-T2_SP)/32	;B
	.BYTE	(T2_CC-T2_SP)/32	;C
	.BYTE	(T2_DD-T2_SP)/32	;D
	.BYTE	(T2_EE-T2_SP)/32	;E
	.BYTE	(T2_FF-T2_SP)/32	;F
	.BYTE	(T2_GG-T2_SP)/32	;G
	.BYTE	(T2_HH-T2_SP)/32	;H
	.BYTE	(T2_II-T2_SP)/32	;I
	.BYTE	(T2_JJ-T2_SP)/32	;J
	.BYTE	(T2_KK-T2_SP)/32	;K
	.BYTE	(T2_LL-T2_SP)/32	;L
	.BYTE	(T2_MM-T2_SP)/32	;M
	.BYTE	(T2_NN-T2_SP)/32	;N
	.BYTE	(T2_OO-T2_SP)/32	;O
	.BYTE	(T2_PP-T2_SP)/32	;P
	.BYTE	(T2_QQ-T2_SP)/32	;Q
	.BYTE	(T2_RR-T2_SP)/32	;R
	.BYTE	(T2_SS-T2_SP)/32	;S
	.BYTE	(T2_TT-T2_SP)/32	;T
	.BYTE	(T2_UU-T2_SP)/32	;U
	.BYTE	(T2_VV-T2_SP)/32	;V
	.BYTE	(T2_WW-T2_SP)/32	;W
	.BYTE	(T2_XX-T2_SP)/32	;X
	.BYTE	(T2_YY-T2_SP)/32	;Y
	.BYTE	(T2_ZZ-T2_SP)/32	;Z

; ===========================
; | CHARACTER DEFINITIONS   |
; ===========================
CBASE
I2_SP
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h
   .byte    00h

I2_MN:
   .byte    000h
   .byte    000h
   .byte    000h
   .byte    0FFh
   .byte    0FFh
   .byte    000h
   .byte    000h
   .byte    000h

I2_PER:
	.BYTE	0
	.BYTE	0
	.BYTE	0
	.BYTE	0
	.BYTE	0
	.BYTE	0
	.BYTE	0FFH
	.BYTE	0FFH

I2_SLASH:
	.BYTE	30H
	.BYTE	30H
	.BYTE	18H
	.BYTE	18H
	.BYTE	06H
	.BYTE	06H
	.BYTE	03H
	.BYTE	03H

I2_00:
   .byte    01Eh
   .byte    03Fh
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_11:
   .byte    0Eh
   .byte    0Fh
   .byte    0Fh
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch

I2_22:
   .byte    01Fh
   .byte    03Fh
   .byte    038h
   .byte    01Ch
   .byte    0Eh
   .byte    07h
   .byte    03Fh
   .byte    03Fh

I2_33:
   .byte    01Fh
   .byte    03Fh
   .byte    030h
   .byte    01Eh
   .byte    01Eh
   .byte    030h
   .byte    03Fh
   .byte    01Fh

I2_44:
   .byte    038h
   .byte    03Ch
   .byte    036h
   .byte    033h
   .byte    03Fh
   .byte    03Fh
   .byte    030h
   .byte    030h

I2_55:
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    01Fh
   .byte    03Fh
   .byte    030h
   .byte    03Fh
   .byte    01Fh

I2_66:
   .byte    03Eh
   .byte    03Fh
   .byte    03h
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_77:
   .byte    03Fh
   .byte    03Fh
   .byte    030h
   .byte    018h
   .byte    018h
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch

I2_88:
   .byte    01Eh
   .byte    03Fh
   .byte    033h
   .byte    01Eh
   .byte    01Eh
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_99:
   .byte    01Eh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    03Eh
   .byte    030h
   .byte    03Fh
   .byte    01Fh

I2_AA:
   .byte    01Eh
   .byte    03Fh
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    03Fh
   .byte    033h
   .byte    033h

I2_BB:
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    01Fh
   .byte    033h
   .byte    03Fh
   .byte    01Fh

I2_CC:
   .byte    03Eh
   .byte    03Fh
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03Fh
   .byte    03Eh

I2_DD:
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    01Fh

I2_EE:
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    03Fh
   .byte    03Fh

I2_FF:
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    03Fh
   .byte    03Fh
   .byte    03h
   .byte    03h
   .byte    03h

I2_GG:
   .byte    03Eh
   .byte    03Fh
   .byte    03h
   .byte    03h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_HH:
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    03Fh
   .byte    033h
   .byte    033h
   .byte    033h

I2_II:
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h

I2_JJ:
   .byte    030h
   .byte    030h
   .byte    030h
   .byte    030h
   .byte    030h
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_KK:
   .byte    033h
   .byte    033h
   .byte    01Bh
   .byte    0Fh
   .byte    01Fh
   .byte    033h
   .byte    033h
   .byte    033h

I2_LL:
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    03h
   .byte    01Fh
   .byte    01Fh

I2_MM:
   .byte    087h,03h
   .byte    0CFh,03h
   .byte    0CFh,03h
   .byte    07Bh,03h
   .byte    07Bh,03h
   .byte    033h,03h
   .byte    033h,03h
   .byte    033h,03h

I2_NN:
   .byte    063h
   .byte    067h
   .byte    06Fh
   .byte    06Fh
   .byte    07Bh
   .byte    07Bh
   .byte    073h
   .byte    063h

I2_OO:
   .byte    03Eh
   .byte    07Fh
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    07Fh
   .byte    03Eh

I2_PP:
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    01Fh
   .byte    03h
   .byte    03h
   .byte    03h

I2_QQ:
   .byte    03Eh
   .byte    07Fh
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    07Fh
   .byte    03Eh
   .byte    060h
   .byte    060h

I2_RR:
   .byte    01Fh
   .byte    03Fh
   .byte    033h
   .byte    03Fh
   .byte    01Fh
   .byte    033h
   .byte    033h
   .byte    033h

I2_SS:
   .byte    03Eh
   .byte    03Fh
   .byte    03h
   .byte    01Fh
   .byte    03Eh
   .byte    030h
   .byte    03Fh
   .byte    01Fh

I2_TT:
   .byte    03Fh
   .byte    03Fh
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch

I2_UU:
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    033h
   .byte    03Fh
   .byte    01Eh

I2_VV:
   .byte    063h
   .byte    063h
   .byte    063h
   .byte    036h
   .byte    036h
   .byte    03Eh
   .byte    01Ch
   .byte    01Ch

I2_WW:
   .byte    023h,06h
   .byte    023h,06h
   .byte    073h,06h
   .byte    076h,03h
   .byte    076h,03h
   .byte    0DEh,03h
   .byte    08Ch,01h
   .byte    08Ch,01h

I2_XX:
   .byte    063h
   .byte    063h
   .byte    036h
   .byte    01Ch
   .byte    01Ch
   .byte    036h
   .byte    063h
   .byte    063h

I2_YY:
   .byte    033h
   .byte    033h
   .byte    01Eh
   .byte    01Eh
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch
   .byte    0Ch

I2_ZZ:
   .byte    03Fh
   .byte    03Fh
   .byte    038h
   .byte    01Ch
   .byte    0Eh
   .byte    07h
   .byte    03Fh
   .byte    03Fh


   .EVEN
*
*		ROM chip definitions and checksums
*
CKSUM1	.equ	>bce1
CKSUM2	.equ	>f4dc

PROMCHIPS
;	ROM_CHIP PROM1,0,0,16, 0FF800000H, 0FFFFFFF0H, CKSUM1	; UJ12
;	ROM_CHIP PROM2,1,0,16, 0FF800008H, 0FFFFFFF8H, CKSUM2	; UG12
	ROM_CHIP PROM2,1,0,16, 0FF800000H, 0FFFFFFF0H, CKSUM1	; U54
	ROM_CHIP PROM1,0,0,16, 0FF800008H, 0FFFFFFF8H, CKSUM2	; U63
	.LONG	0

* CHECKSUM PATCHES
	.WORD	>ffff-CKSUM1	;1'S COMPLEMENT OF THE UJ12 CHECKSUM
	.WORD	>ffff-CKSUM2	;1'S COMPLEMENT OF THE UG12 CHECKSUM


**************************************************************************
*								         *
* 		     IMAGE ROM CHECKSUM TABLES				 *
* 									 *
* 		NOTE: COMMENT OUT ANY UNSTUFFED PARTS THAT		 *
* 			EXIST BEFORE THE .LONG 0 TERMINATOR!		 *
*								         *
**************************************************************************
;	ROM_CHIP $MACRO TAB_LINK,CHIP_NO, WIDTH, INTERLEAVE, START_ADDR, END_ADDR, CHECK_SUM

;1161 = NBA2_20.0
;748D = NBA2_20.1
;8B9D = NBA2_20.2
;5AFE = NBA2_20.3
;3E9B = NBA2_30.0
;5CA0 = NBA2_30.1
;C6EC = NBA2_30.2
;C336 = NBA2_30.3
;F400 = NBA2_40.0
;B70D = NBA2_40.1
;F731 = NBA2_40.2
;7BE3 = NBA2_40.3
;0ADB = NBA2_50.0
;3E90 = NBA2_50.1
;3C9B = NBA2_50.2
;0648 = NBA2_50.3
;F7A6 = NBA_PROG.0
;BE66 = NBA_PROG.1

;BDD6 = NBA2_50.0
;F515 = NBA2_50.1
;EF39 = NBA2_50.2
;B948 = NBA2_50.3



;3/7/96
;Image ROM checksums:  (We are keeping the first 8 meg locked down...
;Put these in...  I'm not sure how they are layed out...

;NBA2.0:	5918
;NBA2.1:	E85C
;NBA2.2:	95D8
;NBA2.3:	E855
;
;NBA4.0:	154F
;NBA4.1:	8227
;NBA4.2:	13BA
;NBA4.3:	B21D
;
;NBA6.0:	FA38
;NBA6.1:	D4F8
;NBA6.2:	C1EB
;NBA6.3:	B9E4
;
;NBA8.0:	8636
;NBA8.1:	BA7A
;NBA8.2:	E826
;NBA8.3:	3B7C
;
;NBAC.0:	D00D
;NBAC.1:	B113
;NBAC.2:	59D2
;NBAC.3:	61A8


;IROMCHIPS
;	.EVEN
;;	ROM_CHIP IROM1,  1, 8,32,  2000000H, 2FFFFE0H, 01161H	; UG14
;;	ROM_CHIP IROM9,  9, 8,32,  2000008H, 2FFFFE8H, 0748dH	; UJ14
;;	ROM_CHIP IROM5,  5, 8,32,  2000010H, 2FFFFF0H, 08b9dH	; UG19 
;;	ROM_CHIP IROM13,13, 8,32,  2000018H, 2FFFFF8H, 05afeH	; UJ19 
;;
;;	ROM_CHIP IROM2,  2, 8,32,  3000000H, 3FFFFE0H, 03e9bH	; UG16
;;	ROM_CHIP IROM10,10, 8,32,  3000008H, 3FFFFE8H, 05ca0H	; UJ16
;;	ROM_CHIP IROM6,  6, 8,32,  3000010H, 3FFFFF0H, 0c6ecH	; UG20
;;	ROM_CHIP IROM14,14, 8,32,  3000018H, 3FFFFF8H, 0c336H	; UJ20
;;
;;	ROM_CHIP IROM3,  3, 8,32,  4000000H, 4FFFFE0H, 0f400H	; UG17
;;	ROM_CHIP IROM11,11, 8,32,  4000008H, 4FFFFE8H, 0b70dH	; UJ17
;;	ROM_CHIP IROM7,  7, 8,32,  4000010H, 4FFFFF0H, 0f731H	; UG22
;;	ROM_CHIP IROM15,15, 8,32,  4000018H, 4FFFFF8H, 07be3H	; UJ22
;;
;;	ROM_CHIP IROM4,  4, 8,32,  5000000H, 5FFFFE0H, 0bdd6H	; UG18
;;	ROM_CHIP IROM12,12, 8,32,  5000008H, 5FFFFE8H, 0f515H	; UJ18
;;	ROM_CHIP IROM8,  8, 8,32,  5000010H, 5FFFFF0H, 0ef39H	; UG23
;;	ROM_CHIP IROM16,16, 8,32,  5000018H, 5FFFFF8H, 0b948H	; UJ23
;;
;	ROM_CHIP IROM1,  0, 8,32,  2000000H, 2FFFFE0H, 0H	; U133
;	ROM_CHIP IROM2,  1, 8,32,  2000008H, 2FFFFE8H, 0H	; U132
;	ROM_CHIP IROM3,  2, 8,32,  2000010H, 2FFFFF0H, 0H	; U131
;	ROM_CHIP IROM4,  3, 8,32,  2000018H, 2FFFFF8H, 0H	; U130
;
;	ROM_CHIP IROM5,  4, 8,32,  3000000H, 3FFFFE0H, 0H	; U129
;	ROM_CHIP IROM6,  5, 8,32,  3000008H, 3FFFFE8H, 0H	; U128
;	ROM_CHIP IROM7,  6, 8,32,  3000010H, 3FFFFF0H, 0H	; U127
;	ROM_CHIP IROM8,  7, 8,32,  3000018H, 3FFFFF8H, 0H	; U126
;
;	ROM_CHIP IROM9,  8, 8,32,  4000000H, 4FFFFE0H, 0H	; U125
;	ROM_CHIP IROM10, 9, 8,32,  4000008H, 4FFFFE8H, 0H	; U124
;	ROM_CHIP IROM11,10, 8,32,  4000010H, 4FFFFF0H, 0H	; U123
;	ROM_CHIP IROM12,11, 8,32,  4000018H, 4FFFFF8H, 0H	; U122
;
;	ROM_CHIP IROM13,12, 8,32,  5000000H, 5FFFFE0H, 0H	; U121
;	ROM_CHIP IROM14,13, 8,32,  5000008H, 5FFFFE8H, 0H	; U120
;	ROM_CHIP IROM15,14, 8,32,  5000010H, 5FFFFF0H, 0H	; U119
;	ROM_CHIP IROM16,15, 8,32,  5000018H, 5FFFFF8H, 0H	; U118
;	.LONG	0		; FORCE IT TO STOP HERE
;
;; This and possibly other tables need to be set up yet
;IROMCHIPS1
;	ROM_CHIP IROM17,16, 8,32,  2000000H, 2FFFFE0H, 0H	; U117
;	ROM_CHIP IROM18,17, 8,32,  2000008H, 2FFFFE8H, 0H	; U116
;	ROM_CHIP IROM19,18, 8,32,  2000010H, 2FFFFF0H, 0H	; U115
;	ROM_CHIP IROM20,19, 8,32,  2000018H, 2FFFFF8H, 0H	; U114
;
;	ROM_CHIP IROM21,20, 8,32,  3000000H, 3FFFFE0H, 0H	; U113
;	ROM_CHIP IROM22,21, 8,32,  3000008H, 3FFFFE8H, 0H	; U112
;	ROM_CHIP IROM23,22, 8,32,  3000010H, 3FFFFF0H, 0H	; U111
;	ROM_CHIP IROM24,23, 8,32,  3000018H, 3FFFFF8H, 0H	; U110
;
;	ROM_CHIP IROM25,24, 8,32,  4000000H, 4FFFFE0H, 0H	; U109
;	ROM_CHIP IROM26,25, 8,32,  4000008H, 4FFFFE8H, 0H	; U108
;	ROM_CHIP IROM27,26, 8,32,  4000010H, 4FFFFF0H, 0H	; U107
;	ROM_CHIP IROM28,27, 8,32,  4000018H, 4FFFFF8H, 0H	; U106
;
;	ROM_CHIP IROM29,28, 8,32,  5000000H, 5FFFFE0H, 0H	; U105
;	ROM_CHIP IROM30,29, 8,32,  5000008H, 5FFFFE8H, 0H	; U104
;	ROM_CHIP IROM31,30, 8,32,  5000010H, 5FFFFF0H, 0H	; U103
;	ROM_CHIP IROM32,31, 8,32,  5000018H, 5FFFFF8H, 0H	; U102
;	.LONG	0		; FORCE IT TO STOP HERE

IROMCHIPS_8MEG
	.EVEN
	ROM_CHIP IROM1,  0, 8,32,  2000000H, 3FFFFE0H,05918H 	; U133
	ROM_CHIP IROM2,  1, 8,32,  2000008H, 3FFFFE8H,0E85CH 	; U132
	ROM_CHIP IROM3,  2, 8,32,  2000010H, 3FFFFF0H,095D8H 	; U131
	ROM_CHIP IROM4,  3, 8,32,  2000018H, 3FFFFF8H,0E855H 	; U130

	ROM_CHIP IROM5,  4, 8,32,  4000000H, 5FFFFE0H,0154FH 	; U129
	ROM_CHIP IROM6,  5, 8,32,  4000008H, 5FFFFE8H,08227H 	; U128
	ROM_CHIP IROM7,  6, 8,32,  4000010H, 5FFFFF0H,013BAH 	; U127
	ROM_CHIP IROM8,  7, 8,32,  4000018H, 5FFFFF8H,0B21DH 	; U126
	.LONG	0

IROMCHIPS1_8MEG
	ROM_CHIP IROM9,  8, 8,32,  2000000H, 3FFFFE0H,03da3H 	; U125
	ROM_CHIP IROM10, 9, 8,32,  2000008H, 3FFFFE8H,03f1cH 	; U124
	ROM_CHIP IROM11,10, 8,32,  2000010H, 3FFFFF0H,05a84H 	; U123
	ROM_CHIP IROM12,11, 8,32,  2000018H, 3FFFFF8H,04237H 	; U122

	ROM_CHIP IROM13,12, 8,32,  4000000H, 5FFFFE0H,06dd1H 	; U121
	ROM_CHIP IROM14,13, 8,32,  4000008H, 5FFFFE8H,0a7bbH 	; U120
	ROM_CHIP IROM15,14, 8,32,  4000010H, 5FFFFF0H,03446H 	; U119
	ROM_CHIP IROM16,15, 8,32,  4000018H, 5FFFFF8H,0ff49H 	; U118
	.LONG	0

IROMCHIPS2_8MEG
	ROM_CHIP IROM21,16, 8,32,  4000000H, 5FFFFE0H,0ea80H 	; U???
	ROM_CHIP IROM22,17, 8,32,  4000008H, 5FFFFE8H,044d0H 	; U???
	ROM_CHIP IROM23,18, 8,32,  4000010H, 5FFFFF0H,08505H 	; U???
	ROM_CHIP IROM24,19, 8,32,  4000018H, 5FFFFF8H,008f2H 	; U???
	.LONG	0

	.END
