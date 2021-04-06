**************************************************************
*
* Owner:	none
*
* Software:	LARRY DEMAR and DR. J
* Initiated:	?
*
* Modified:	Shawn Liptak, 9/6/91	-SLEEPK (Total carnage)
* 		Shawn Liptak, 11/1/91	-Clean up
* 		Shawn Liptak, 2/11/91	-Started basketball
* 		Shawn Liptak, 11/6/92	-L_TIMER clean up
* 		GEORGE PETRO, 1/17/93	-NBA JAM
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/19/93 13:08
*.Last mod - 4/19/95 10:30    JBJ
**************************************************************
	.file	"audit.asm"
	.title	"audits and ajustments handling"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;mproc equates
	.include	"disp.equ"		;display proc. equates
	.include	"sys.equ"		;z unit system equates
	.include	"gsp.equ"
	.include	"imgtbl.glo"
	.include	"game.equ"
	.include	"link.equ"		;link equates
	.include	"menu.equ"		;menu equates
	.include	"audit.equ"
	.include	"macros.hdr"		;Macros
	.include	"imgtbl.glo"
	.include	"bgndtbl.glo"

	.include	"powertxt.glo"


*	 BAD_AUD - ANYTIME AN AUDIT NUMBER IS FETCHED, IF ITS
*			CHECKSUM IS BAD, THEN BAD_AUD GETS SET TO 1
*			THIS CAUSES "ERROR" IF ANY AUDIT IN A CALCULATION
*			IS CORRUPTED, AND KEEPS A BAD CHECKSUM BAD WHEN
*			AN AUDIT IS CHANGED.
			
	.BSS	BAD_AUD		,16	;(BAD_AUD...NOT BAD_DOG!)	
	.bss	playtimer	,16	;timer units for game
	.BSS	C_FRAC		,16	;TIME 10 SECONDS TO
					;INDICATE COIN ACTIVITY
;;	.BSS	C_FLAGS		,3*32	;INTERRUPT COIN BOUNCE
	.BSS	C_FLAGS		,5*32	;INTERRUPT COIN BOUNCE
	.BSS	COINCNTR	,32	;MECH COIN COUNTER TIMERS AND COUNTS	
COINCNT1	.EQU	COINCNTR
COINCNT2	.EQU	COINCNTR+8
*			TIMERS 1,2:B16-23,B24-B31; COUNTS 1,2 B0-B7;B8-B15
	.BSS	OCT_FLG,16		;!0=Did 1st part

			
*	 IN THIS MODULE
;	.def	ADD_DUMP
	.def	ADJ_PAGE
	.def	BAD_AUD
	.def	C_FRAC,COINCNTR			
	.def	C_FLAGS
	.def	L_MESS,AUD,AUD1,GET_ADJ
	.def	GET_AUD,SLAM_SW,STORE_AUDIT
	.def	CAT_A0
	.def	CCCC
	.def	CK_MAX
;	.def	CLRSWPRC
	.def	CLR_AUD,FAC_SET
	.def	CLR_AUDR
;	.def	CLR_SUBS
	.def	CMOS_VAL
	.def	COIN_PAG
;	.def	COINIRQ
	.def	CR_STRTP
	.def	CR_CONTP
	.def	CRD_SCRN
	.def	CRED_P	
	.def	DEF_PAGE
;	.def	DUMP_FS
	.def	FORM_ADC
	.def	F_ADC_S
	.def	GET_CREDITS
	.def	GET_CSTR
	.def	HTOHXASC
;	.def	KILL_CRD
	.def	L_TIMER
	.def	LD_CTAB
	.def	LM_SETUP
	.def	LM_FINIS
	.def	NO_CREDS
	.def	P_START
	.def	P_CONT	
	.def	PUT_ADJ
	.def	ROM_NAME
	.def	STRCAT
	.def	UNIT_CLR
	.def	WAIT_MUT
	.DEF	KILL_AUD

	.def	CCOIN,RCOIN,SERVICE,XCOIN,LCOIN
	.DEF	DBV

	.ref	brush20_ascii,hangfnt38_ascii
	.ref	HANGF_W_P,HANGF_G_P
	.ref	bast8t_ascii,bast8_ascii,bast10_ascii
	.ref	bast18_ascii
	.ref	mess_cursx,mess_cursy
	.ref	mess_line_spacing
	.ref	message_palette

	.ref	print_string2b,kern_chars,mess_justify,mess_cursx2
	.ref	print_message,setup_message
	.ref	print_string_C,print_string_C2
	.ref	dec_to_asc
	.ref	copy_string,copy_rom_string
	.ref	concat_string,concat_rom_string
	.ref	BAKMODS
	.ref	KILBGND
	.ref	BGND_UD1
	.ref	COLRTEMP
	.REF	COUNTER_MODE

	.GLOBAL	SYNCHALF,WDOGDIS,GAMSTATE

	.REF	IRQSKYE
	.ref	dpageflip_off
	.ref 	WFLG,BTIME
	.REF	PSTATUS,WRLD

;sounds
	.ref	coin_snd,beep2_snd


*	IN HSTD.ASM

	.REF		SET_PAGE
	.REF		P_FORK
	.REF		DEC_HSR,INIT_HSR
	.REF		RC_BYTEI
	.REF		RC_BYTE
	.REF		RC_WORD
	.REF		RC_LONG
	.REF		RC_LONGI
	.REF		WC_BYTE
	.REF		WC_BYTEI
	.REF		WC_WORD
	.REF		WC_WORDI
	.REF		WC_LONG
	.REF		WC_LONGI

*	IN MENU.ASM

	.REF		GET_CSPT
	.REF		STR_OBJ
	.REF		STR_FREE
	.REF		CKPROMPT
	.REF		TWO_TS,TWO_TP
	.REF		BUILD_ST
	.REF		HID_P
	.REF		DIAG
	.REF		CS_ENTS

*	 IN ROBOATT.ASM

	.REF		WIPEOUT


*	 IN TEST.ASM

;	.REF	CK_DOOR
;	.REF	WT_ADV,WW_ADV
	.REF	WAIT_BUT
	.REF	FORM_SWS
	.ref	opmsg_clr



*	 OTHERS

	.ref	TWOPLAYERS			;0 = NO, 1 = YES 2 players

;	.ref	plyr_strtb1,plyr_strtb2
	.ref	conttimers
	.ref	dirqtimer
	.ref	SOUNDSUP
	.ref	RD15FONT,RD7FONT,dmaq_wait,STRCNRM
	.ref	STRNGRAM,BLNKAREA,STRLNRM,HEXTOASC
	.ref	CLR_SCRN
	.ref	KILALL
	.ref	GETPRC,SUCIDE
	.ref	amode_start
	.ref	dpageflip
	.ref	snd_play1ovr
	.ref	update_scorebrd
	.ref	TAMPEREDP
	.ref	_coin_addr
	.ref	_dipswitch_addr


	.text

**************************************************************************
*
*	COIN HANDLING
*
**************************************************************************

**************************************************************************
*
*	L_TIMER
*
*	THIS IS CALLED EACH TICK THROUGH THE EXEC LOOP
*	BEFORE TIMER IS CLEARED. IT DOES NOTHING
*	IF THE GAME IS NOT IN PLAY, ELSE IT ADDS
*	THE EXEC TIME TO THE 1 PLAYER OR 2 PLAYER
*	TIMER BASED ON CURRENT NUMBER OF PEOPLE PLAYING.
*
**************************************************************************
FIVE_SEC equ	 TSEC*5

L_TIMER
	move	@GAMSTATE,a0
	jrn	douptime		;In diagnostics?
	subk	INAMODE,a0
;FIX!!!
;	jreq	CK_OCTO 		;ATTRACT MODE..CHECK OCTOPUS!
	subk	INGAMEOV-INAMODE,a0
	jreq	douptime

	move	@dirqtimer,a1		;get elapsed time
	move	@playtimer,a0		;get play timer
	sub	a1,a0			;add elapsed time
	move	a0,@playtimer
	jrgt	#not5			;Under 5 seconds?

	move	@PSTATUS,a2
	jrz	audup

	movi	AUD_1PLAYTIME-1,a0
	movk	4,b0
#plp	srl	1,a2
	jrnc	#nop
	addk	1,a0			;+1 plyr
#nop	dsj	b0,#plp

	callr	AUD1

	movi	AUD_PLTIME,a0
	callr	AUD1

audup
	movi	AUD_UPTIME,a0
	callr	AUD1

	movi	FIVE_SEC,a0
#not5	move	a0,@playtimer
	rets


********************************

douptime
	move	@dirqtimer,a1		;get elapsed time
	move	@playtimer,a0		;get play timer
	sub	a1,a0			;add elapsed time
	jrle	audup			;Under 5 seconds?
	move	a0,@playtimer
	rets

#*******************************
* ITS A-MODE...CHECK OCTOPUS!

CK_OCTO
	move	@SWITCH,a0
	not	a0
	andi	>7f7f,a0		;Get sticks 'n starts
	move	@OCT_FLG,a1
	jrgt	#p2			;Got part one?

	cmpi	>7171,a0		;P1&P2 all buts down & both sticks up
	jrne	#x			;Wrong?
	movi	TSEC,a1			;One sec to get part two
#p2
	subk	1,a1
	move	a1,@OCT_FLG
	jrgt	#x			;Still counting?
	cmpi	>202,a0
	jrne	#x			;Wrong?

	movi	ACTIVE,a13
	movi	HID_P,a7		;Start the process!
	movi	DIAG_PID,a1
	calla	GETPRC
;	movi	MAW,A0
;	calla	snd_play1

#x	jruc	douptime


;MAW	.WORD	>F9F7,>50,>814A,0		;OH MAW


#*******************************
* Give him a service credit

SERVICE
	move	@GAMSTATE,a0
	jrn	#x 			;In diagnostics?
	move	@_coin_addr,a0,L	;Get COIN inputs
	move	*a0,a0
	btst	CDI_BIT,a0		;Coin Door Closed ?
	jrz	#x			;Yes - Then NO Service Credits Allowed

	callr	CCCC			;MAKE SURE THINGS ARE IN TACT

	movk	AUDSERV,a0
	callr	AUD1			;CHALK UP A SERVICE CREDITS!

	callr	getcoin

	movk	10,a0
	move	a0,@BTIME		;Restuff buyin timer
	
	callr	conttimers_set

	callr	GET_CREDITS
	addk	1,a0			;Add in the new ones
	callr	PUT_CREDITS		;NOW STORE EM BACK (ENFORCE MAX)

	callr	FORM_COIN_CKSUM_AND_STORE

	calla	update_scorebrd		;redraw scoreboard credits message

	jruc	CREDSP

#x	DIE


********************************
* THE FOLLOWING COIN ROUTINES ARE PROCESSES!

LCOIN	MOVK	ADJLMULT,A8	;CMOS RAM ADJUST
	MOVI	LC_FLAG,A10	;LEFT COIN FLAG
	MOVI	AUDLCOIN,A11	;AUDIT NUMBER
	JRUC	VALID_COIN

CCOIN	MOVK	ADJCMULT,A8
	MOVI	CC_FLAG,A10	;CENTER COIN FLAG
	MOVI	AUDCCOIN,A11
	JRUC	VALID_COIN

RCOIN	MOVK	ADJRMULT,A8
	MOVI	RC_FLAG,A10	;RYTE COIN FLAG
	MOVI	AUDRCOIN,A11
	JRUC	VALID_COIN

XCOIN	MOVK	ADJXMULT,A8
	MOVI	XC_FLAG,A10	;XTRA (FOURTH) COIN FLAG
	MOVI	AUDXCOIN,A11
	JRUC	VALID_COIN

DBV	MOVK	ADJDBVMULT,A8
	MOVI	DBV_FLAG,A10	;XTRA (FOURTH) COIN FLAG
	MOVI	AUD_DBV,A11
	JRUC	VALID_COIN
;
; COIN CONTROL EQUATES
;
LC_FLAG 	.EQU	C_FLAGS		;UHB LEFT COIN
RC_FLAG 	.EQU	C_FLAGS+8	;UHB RGT   "
CC_FLAG 	.EQU	C_FLAGS+16	;UHB CNTR  "
XC_FLAG 	.EQU	C_FLAGS+24	;UHB XTRA  "
DBV_FLAG 	.EQU	C_FLAGS+32	;UHB DOLLAR BILL VALIDATOR  
;
; VALID_COIN- CHECK THE DURATION OF COIN DROP AND SEES IF IT IS A VALID
;	ENTRY
;PARAMS REQUIRED:
; A8 = MULTIPLIER FOR THAT SWITCH.			
; A10 = RAM TIMER/FLAG
; A11 = BASE AUDIT NUMBER				

VALID_COIN
	move	@GAMSTATE,a0
	jrn	CRX			;In diagnostics?

	MOVE	A8,A0			;MOVE MULTIPLIER ADJUST NUMBER TO A0
	CALLA	GET_ADJ 		;FETCH IT
	MOVE	A0,A8			;AND BACK TO STATIC REG...ANY THERE?
	JRZ	CRX			;NOPE....DON'T WASTE THE TIME!

	CALLR	SLAM_P			;SLAM AROUND?
	JRNZ	CRX			;THEN NO ACTION
	MOVI	LC_PID,A0		;ALL 4 SLOTS USE THIS ID NOW
	MOVE	A0,*A13(PROCID)		;SET OUR ID (IN CASE TABLE IS WRONG)

;	movb	*a10,a0 		;get flag byte
;	jrz	#fok
;	LOCKUP
;#fok
	MOVB	*A10,A0 		;GET FLAG BYTE
	JRNZ	CRX			;SOMEONE ELSE THERE...WE'RE A BOUNCE!

;OK....THIS IS A NEW POSITIVE EDGE....START THE DROP TIMING

	movk	5,a0			;Wait a few ticks
	movb	a0,*a10

COIN_LOOP
	SLEEPK	1			;SLEEP TILL WE GET SUCCESS OR FAIL
	MOVB	*A10,A0 		;GET THE TIMER
	JRGT	COIN_LOOP

	CALLR	SLAM_P			;SLAM?
	JRNZ	CRX			;THEN WE'RE OUT OF HERE

; 1/2 SECOND HAS PASSED WITHOUT A SLAM....INDICATE COIN DROP
					
	CLR	A0
	MOVE	A0,@SOUNDSUP		;TURN SOUNDS ON. (A-MODE SOUND SUPRESSOR)

	callr	getcoin

	MOVK	20,A0
	MOVE	A0,@BTIME		;RESTUFF BUYIN TIMER
	callr	conttimers_set

	MOVI	15*40H/8,A0		;DON'T WIPE ON GAME OVER IF ITS WITHIN
	MOVE	A0,@C_FRAC		;15 SECONDS (THIS TIMES OUT TO OVER 20)

	MOVE	A11,A0
	CALLR	AUD1			;CHALK THE DIRECT AUDIT

*HIT THE MECHANICAL COIN COUNTERS
	MOVE	@COUNTER_MODE,A0,W
	CMPI	1,A0
	JRNE	MECH20
	MOVI	ADJTOTALIZER,A0
	CALLA	GET_ADJ
	JRZ	NORMAL_TOTALIZER
	MOVI	ADJTOTALIZER,A0
	ADD	A11,A0
	CALLA	GET_ADJ
	MOVE	A0,A2
	MOVI	COINCNT1,A1
	JRUC	RE_ENTER_FROM_CUST_TOTALIZER
NORMAL_TOTALIZER

*MULTIPLE OF LEAST VALUE COIN MODE
	CALLA	GET_CSPT		;POINT TO COIN TABLE A6
;	MOVK	4,A1			;CHECK ALL CHUTES
;	ADDI	CS_LVAL,A6		;ADD IN OFFSET TO CHUTE VALUES
;	MOVE	A6,A5			;SAVE A6
;	CLR	A2
;	NOT	A2
;MECH1L
;	MOVE	*A5+,A0			;FIND LOWEST NON-ZERO NUMBER IN LIST
;	JRZ	MECH_SKIPZ
;	CMP	A2,A0
;	JRHI	MECH_SKIPZ
;	MOVE	A0,A2			;A NEW LOW!
;MECH_SKIPZ
;	DSJS	A1,MECH1L

	ADDI	CS_LVAL,A6		;ADD IN OFFSET TO CHUTE VALUES
	DEC	A11			;GET YOUR CLICK COUNT
	SLL	4,A11			;OFFSET FOR CHUTE, WORD CORRECT
	ADD	A11,A6
	MOVE	*A6,A2			;GET MONEY VALUE
	MOVE	A2,A2
	JRZ	MECH10			;SOMETHING ILLEGAL HAPPENED, JUST ONE

RE_ENTER_FROM_CUST_TOTALIZER
;	CALLA	GET_CSPT		;POINT TO COIN TABLE A6
;	DEC	A11			;GET YOUR CLICK COUNT
;	SLL	4,A11			;OFFSET FOR CHUTE, WORD CORRECT
;	ADD	A11,A6
;	MOVE	*A6,A1			;GET MONEY VALUE
;	JRZ	MECH10			;WIERDNESS, JUST ONE CLICK
;	DIVU	A2,A1			;DIVIDE BY LOWEST COMMON DENOMINATOR
;	MOVE	A1,A2			;RESULT TO KEEP COMPAT
	MOVI	COINCNT1,A1
	JRUC	MECH3B
MECH10
	MOVK	2,A0			;VALUE OVER 10, JUST GIVE ONE CLICK
MECH20
	MOVI	COINCNT1,A1
	CMPI	2,A0
	JREQ	MECH3A			;CLICK COUNTER 1 MODE
	
	CMPI	AUDLCOIN,A11
	JREQ	MECH3A
	CMPI	AUDRCOIN,A11
	JRNE	MECH4
	ADDK	8,A1
MECH3A
	MOVK	1,A2
MECH3B
	DINT
	MOVB	*A1,A0
	ADD	A2,A0
	MOVB	A0,*A1
	EINT
MECH4
	MOVE	A8,A8			;NO CREDIT UNITS?
	JRZ	CRX			;THEN NO MORE WORK TO DO.
	CALLR	ADJUST_CREDITS		;GIVE CREDIT FOR THE MONEY.
	CALLR	DEF_PAGE		;POINT PAGE AWAY!

	calla	update_scorebrd		;redraw scoreboard credits message


; SET-UP CREDITS MSG IN GAME SCREEN AND INDICATE 'INSERT COIN' IF NOT ENOUGH
; HAVE BEEN DROPPED
;
;	 CALLA	 G_MSG			;PLOT MESSAGE FOR GAME PLAY SCREEN
CREDSP
;	MOVE	@GAMSTATE,A0
;	CMPI	INAMODE,A0
;	JRNZ	NOZERO
;NOZERO
	MOVE	@PSTATUS,A0
	JRNZ	CRX
	move	@GAMSTATE,a0
	subk	INAMODE,a0		;A DISPLAY IN AMODE ONLY!
	jrne	CRX

CRY	jruc	CRD_SCRN		;PUT UP THE CREDITS SCREEN

CRX	JAUC	SUCIDE


********************************
* Set active continue timers
* A0=New value

conttimers_set

	PUSH	a2,a3
	movi	conttimers,a2
	movk	4,a3

ctslp	move	*a2,a1
	jrz	cts50		;None?
	move	a0,*a2
cts50	addk	16,a2
	dsj	a3,ctslp

	PULL	a2,a3
	rets


********************************
* Make all switch process dumdie entries

;CLRSWPRC
;	MMTM	SP,A0,A1,A3
;
;	CLR	A1		;USE SWTAB ENTRY 0 FOR DUMDIE PROC
;	MOVE	@SWSTACK,A3,L
;CLRSTKL	CMPI	SWSTST,A3,L	;STACK AT START?
;	JREQ	CLRSTKX		;YES, EXIT
;	MOVE	*A3+,A0
;	CMPI	31,A0
;	JRLS	CLRSTKL		;THIS ENTRY IS A REAL SWITCH
;	MOVE	A1,*A3(-10H)	;STORE THE DUMDIE CALL
;	JRUC	CLRSTKL
;
;CLRSTKX	MMFM	SP,A0,A1,A3
;	RETS


********************************
*	CR_STRTP - ARE THERE ENOUGH CREDITS TO START
*	CR_CONTP - ARE THERE ENOUGH CREDITS TO CONTINUE
*	P_START  - PLAYER STARTED...DEDUCT CREDITS
*	P_CONT	 - PLAYER CONTINUED...DEDUCT CREDITS
*	CRED_P	 - HOW MANY CREDITS
*
*	JRHS FOR OK TO START!

CR_STRTP
	PUSH	a0,a1
	MOVK	ADJFREPL,A0
	CALLR	GET_ADJ 		;ARE WE IN FREE PLAY?
	CMPI	1,A0			;WE ARE IF ITS NOT ZERO.
	JRHS	CR_STX

	CALLR	CCCC			;MAKE SURE THINGS ARE IN TACT
	CALLR	COIN_PAG
	CALLR	GET_CREDITS		;GET CURRENT CREDITS
	MOVE	A0,A1
	MOVK	ADJCSTRT,A0
	CALLR	GET_ADJ 		;GET NUMBER NEEDED
	CMP	A0,A1			;DO WE HAVE ENOUGH TO START?

CR_STX	MMFM	SP,A0,A1
	RETS

CR_CONTP
	PUSH	a0,a1
	MOVK	ADJFREPL,A0
	CALLR	GET_ADJ 		;ARE WE IN FREE PLAY?
	CMPI	1,A0			;WE ARE IF ITS NOT ZERO.
	JRHS	CR_STX1

	CALLR	CCCC			;MAKE SURE THINGS ARE IN TACT
	CALLR	COIN_PAG
	CALLR	GET_CREDITS		;GET CURRENT CREDITS
	MOVE	A0,A1
	MOVK	ADJCCONT,A0
	CALLR	GET_ADJ 		;GET NUMBER NEEDED
	CMP	A0,A1			;DO WE HAVE ENOUGH TO START?
CR_STX1
	MMFM	SP,A0,A1
	RETS

P_START
	MMTM	SP,A0,A1
	CALLR	CRED_P
	MOVE	A0,A1
	MOVK	ADJCSTRT,A0
	CALLR	GET_ADJ 		;GET NUMBER NEEDED
	CALLR	REMOVE_CREDITS
	CALLA	DEC_HSR 		;TAKE 1 FROM HIGH SCORE RESET COUNTER

	calla	update_scorebrd		;redraw scoreboard credits message

	movi	AUD_TOTSTARTS,a0
	calla	AUD1

	move	@GAMSTATE,a0
	subk	INAMODE,a0
	jreq	#doit
	subk	ININTRO-INAMODE,a0
	jrne	#nope
#doit
	movi	AUD_PRESTARTS,a0
	calla	AUD1
#nope
	MMFM	SP,A0,A1
	RETS

P_CONT
	MMTM	SP,A0,A1
	CALLR	CRED_P
	MOVE	A0,A1
	MOVK	ADJCCONT,A0
	CALLR	GET_ADJ 		;GET NUMBER NEEDED
	CALLR	REMOVE_CREDITS
	CALLA	DEC_HSR 		;TAKE 1 FROM HIGH SCORE RESET COUNTER
	MMFM	SP,A0,A1
	RETS

REMOVE_CREDITS
	SUB	A0,A1			;REMOVE START AMOUNT FROM WHAT WE HAVE
	JRHS	PS1			;WE'RE OK.

	CLR	A1			;IT WENT NEGATIVE....MAKE ZERO.
PS1	CALLR	COIN_PAG
	MOVI	CREDITS,A7
	MOVE	A1,A0			;PUT WHATS LEFT OUT TO WRITE
	CALLA	WC_BYTE 		;WRITE THE NEW AMOUNT

	CALLR	FORM_COIN_CKSUM_AND_STORE
	CALLR	DEF_PAGE		;POINT AT DEFAULT PAGE.
	RETS
		
**************************************************************************
*
*		NO_CREDS
*
*		THIS IS CALLED TO REMOVE CREDITS AND CREDIT FRACTIONS
*		FROM THE MACHINE.
*
**************************************************************************
NO_CREDS
	MMTM	SP,A0,A1,A7
	CALLR	FORM_COIN_CKSUM ;MAKE THE REAL CKSUM
	MOVI	COIN_CKSUM,A7
	MOVE	A1,A0
	INC	A0		;MAKE THE CKSUM BAD!
	CALLA	WC_BYTE
	MMFM	SP,A0,A1,A7
	RETS
**************************************************************************
*
*	CHALK_COIN
*
*	A11 contains the base audit number. Chalk the audit for
*	1 more coin hit there!
*
*	3 away from the base is the "door-closed" counter
*	3 away from that is the "sub-total".
*	3 away from that is the "door-closed" sub-total.
*
**************************************************************************
;CHALK_COIN
;	 MMTM	 SP,A0
;	 MOVE	 A11,A0
;*
;*	 READY TO CHALK THE AUDIT......ZERO MEANS "EXTRA SLOT"
;*
;
;CCC01
;	CALLR	CHALK_FOR_A0	;CHALK RELEVANT COUNTERS
;	MMFM	SP,A0
;	RETS

**************************************************************************
*
*	CHALK_FOR_A0
*
*	THIS IS CALLED TO CHALK THE AUDITS FOR A COIN SWITCH.
*	A0 HAS THE BASE AUDIT FOR THE COIN SWITCH.
*
**************************************************************************
;CHALK_FOR_A0
;	 MMTM	 SP,A0
;	 CALLR	 AUD1		 ;CHALK THE DIRECT AUDIT

;	 ADDI	 2*CHUTES,A0	 ;AND THE "SUB-TOTAL"
;	 CALLR	 AUD1

;	 SUBI	 CHUTES,A0	 ;MOVE TO DOOR OPEN TOTAL
;	 CALLR	 AUD1
;
;	 ADDI	 2*CHUTES,A0	 ;AND DOOR OPEN SUB-TOTAL
;	 CALLR	 AUD1

;CKCN1	
;	MMFM	SP,A0
;	RETS

**************************************************************************
*
*	ADJUST_CREDITS
*
*	This is the routine that turns the coin switch hit
*	into a tangable (if you could say that) reward.
*
*	The coin chute multiplier is in A8.
*
**************************************************************************
ADJUST_CREDITS
	
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	CALLR	CK_MAX		;ARE WE AT MAXIMUM CREDITS?
	JRHS	ADCRXX		;YEP.....DON'T ROCK THE BOAT!

	CALLR	CCCC		;VALIDATE THE CURRENT TOTALS (OR CLEAR!)

	CALLR	FETCH_REQ	;GET THE REQUIRED FOR CREDIT, BONUS AND MINIMUM

*	A2 = REQUIRED FOR CREDIT
*	A3 = FOR BONUS
*	A4 = MINIMUM

	CALLR	ADD_TO_CUNITS	;ADD TO OUR CUNITS
	MOVE	A3,A3		;BONUS EFFECTIVE?
	JRZ	NO_BUNITS	;NOPE....DON'T RUN UP THE COUNTER!

	CALLR	ADD_TO_BUNITS	;ADD TO BONUS UNITS

NO_BUNITS
	MOVE	A4,A4		;MINIMUM REQUIRED?
	JRZ	NO_MINIMUM	;NOPE.....LEAVE ALONE.

	MOVI	MINUNITS,A7	;POINT AT MINIMUM
	CALLA	RC_WORD 	;GET THE AMOUNT ACCUMULATED
	ADD	A8,A0		;ADD AMOUNT RECEIVED
	CALLA	WC_WORD 	;WRITE THE MINUNITS BACK IN CASE NOT ENOUGH.

	SUB	A4,A0		;DO WE HAVE ENOUGH TO ACT?
	JRLO	ADCRX		;NOPE....NO CREDITS YET!

	CLR	A0		;CLEAR OUT MINIMUM FOR NEXT SHOT!
	CALLA	WC_WORD 	;REMOVE ACCUMULATED MINIMUM.

NO_MINIMUM
	CLR	A6		;COUNT ACCUMULATED CREDITS IN A6
	CLR	A10		;IN CASE NO BONUS!

	CLR	A8
	MOVI	BUNITS,A7
	CALLA	RC_WORD 	;GET THE NUMBER OF BUNITS
	MOVE	A0,A9		;INTO A9

	MOVE	A3,A3		;DON'T DIVIDE BY ZERO!
	JRZ	NO_BU_BU
	DIVU	A3,A8		;DIVIDE BUNITS BY NUMBER NEEDED FOR BONUS

	MOVE	A9,A0		;WRITE REMAINDER BACK
	CALLA	WC_WORD

	MOVE	A8,A6		;NUMBER OF BONUS CREDITS EARNED.
	MOVE	A8,A10		;REMEMBER IF ANY BONUS CREDITS WERE EARNED!

NO_BU_BU
	CLR	A8
	CALLR	GET_CUNITS	;READ IN THE CUNITS
	MOVE	A0,A9

	MOVE	A2,A2		;DON'T DIVIDE BY ZERO.
	JRZ	NO_CR

	DIVU	A2,A8		;GET CREDITS!
	MOVE	A9,A0		;REMAINDER IS LEFTOVER CUNITS
	CALLR	PUT_CUNITS
	ADD	A8,A6		;A6 HAS WHAT WE'VE WON!

NO_CR
	MOVE	A6,A1
	MOVI	AUDPAIDC,A0
	CALLA	AUD		;CHALK UP THE EARNED CREDITS!

	CALLR	GET_CREDITS
	ADD	A6,A0		;ADD IN THE NEW ONES.
	CALLR	PUT_CREDITS	;NOW STORE EM BACK (ENFORCE MAX)

	MOVE	A10,A10 	;WAS THE BONUS EARNED?
	JRZ	ADCRX		;NOPE...EXIT!
*
*	 WHEN BONUS EARNED...WE START THE WHOLE SYSTEM OVER!
*
	CALLR	CLEAR_UNITS

ADCRX	CALLR	FORM_COIN_CKSUM_AND_STORE

ADCRXX	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
	RETS

**************************************************************************
*
*	PUT_CREDITS
*
*	STORE CREDIT COUNT IN A0 TO CMOS....ENFORCING MAXIMUM CREDITS.
*
**************************************************************************
PUT_CREDITS
	MMTM	SP,A0,A6,A7
	CALLR	GET_MAX 	;GET MAX CREDS IN A1....BE ON COIN PAGE
	CMP	A1,A0		;SEE HOW WE STACK UP.
	JRLO	USE_A0		;WE'RE LOWER...JUST STORE.
*
*	WE'RE AT (OR OVER) MAXIMUM CREDITS
*
	CALLR	CLEAR_UNITS	;CLEAR OUT THE UNIT FRACTIONS.
	MOVE	A1,A0		;USE MAXIMUM

USE_A0	MOVI	CREDITS,A7
	CALLA	WC_BYTE 	;WRITE THE CREDITS OUT.
	MMFM	SP,A0,A6,A7
	RETS

**************************************************************************
*
*	GET_MAX
*
*	GET MAXIMUM CREDITS IN A1.
*
*	THIS LEAVES YOU ON COIN PAGE.
*
**************************************************************************
GET_MAX
	PUSH	a0
	MOVK	ADJMAXC,A0
	CALLA	GET_ADJ_FOR_COIN	;FETCH MAXIMUM CREDITS (PUT US ON COIN PAGE)
	MOVE	A0,A1
	MMFM	SP,A0
	RETS

**************************************************************************
*
*	CK_MAX
*
*	THIS IS CALLED TO SEE IF WE ARE AT MAXIMUM CREDITS.
*	.HS. MEANS WE ARE AT MAXIMUM CREDITS.
*
**************************************************************************
CK_MAX
	MMTM	SP,A0,A1
	CALLR	GET_MAX 		;GET MAXIMUM IN A1
	CALLR	CRED_P			;GET CREDITS IN A0 (AND FLIP PAGE AWAY)
	CMP	A1,A0			;JRHS FOR MAXIMUM CREDITS!
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*
*	UNIT_CLR
*
*	THIS IS CALLED AT GAME OVER.  IT CLEARS
*	OUT ANY COIN FRACTIONS THAT WERE NOT USED BY THE
*	CURRENT PLAYER(S).  THIS ALLOWS ALL BUY-IN TO
*	TAKE ADVANTAGE OF MULTIPLE COIN BONUSES.
*
*	ANYTIME A COIN IS INSERTED, C_FRAC IS SET TO ABOUT
*	10 SECONDS. MY TIMING INTERFACE COUNTS C_FRAC DOWN
*	TO ZERO.  IF C_FRAC IS NON ZERO WHEN THIS ROUTINE IS
*	CALLED, THEN SOMEONE PUT A COIN IN NOT TOO LONG BEFORE
*	GAME OVER.  DON'T SCREW HIM OUT OF HIS FRACTIONS.
*
**************************************************************************
UNIT_CLR
	PUSH	a0
	MOVE	@C_FRAC,A0			;DO WE GIVE HIM A REPRIEVE?
	JRNZ	UC1				;YEP!
	CALLR	CCCC				;VALIDATE COINAGE
	CALLR	CLEAR_UNITS			;CLEAR OUT FRACTIONAL UNITS
	CALLR	FORM_COIN_CKSUM_AND_STORE	;MAKE ALL GOOD.
UC1
	MMFM	SP,A0
	RETS

CLEAR_UNITS
	MMTM	SP,A0,A7
	CLR	A0
	MOVI	CUNITS,A7		;3 CONSECUTIVE WORDS OF CMOS
	CALLA	WC_WORDI
	CALLA	WC_WORDI
	CALLA	WC_WORD
	MMFM	SP,A0,A7
	RETS

*	 RETURN CREDITS IN A0.........AND Z BIT CLEAR IF
*	 CREDITS EXIST OR IN FREE PLAY.

CRED_P
	CALLR	CCCC		;CHECK TO SEE IF DATA IS OK.

GET_CREDITS
	PUSH	a7
	CALLR	COIN_PAG
	MOVI	CREDITS,A7	;
	CALLA	RC_BYTE 	;READ CURRENT CREDITS
	JRNZ	GC1		;WE GOT SOME!

				;PUSH THE ZERO!
	PUSH	a0
	MOVK	ADJFREPL,A0
	CALLR	GET_ADJ 	;SEE IF FREEPLAY......(Z BIT CLEAR IF SO!)
	MMFM	SP,A0		;RESTORE A0

GC1	CALLR	DEF_PAGE	;FLIP CMOS AWAY
	MMFM	SP,A7
	RETS

ADD_TO_CUNITS
	MMTM	SP,A0,A7
	CALLR	GET_CUNITS
	ADD	A8,A0
	CALLR	PUT_CUNITS
	MMFM	SP,A0,A7
	RETS

GET_CUNITS
	PUSH	a7
	MOVI	CUNITS,A7
	CALLA	RC_WORD
	MMFM	SP,A7
	RETS

PUT_CUNITS
	PUSH	a7
	MOVI	CUNITS,A7
	CALLA	WC_WORD
	MMFM	SP,A7
	RETS

ADD_TO_BUNITS
	MMTM	SP,A7,A0
	MOVI	BUNITS,A7
	CALLA	RC_WORD
	ADD	A8,A0
	CALLA	WC_WORD
	MMFM	SP,A7,A0
	RETS


******************************************************************************

CRD_SCRN

	CLR	a10			;Sleep 7 secs

 SUBR	CRD_SCRN2			;Entry pnt for shorter sleep

	MOVI	CP_PID1,A0		;CHANGE TO "CREDIT PAGE" ID 1
	MOVE	A0,*A13(PROCID)
	MOVI	0FFFFH,A1		;CHECK TO SEE IF CREDIT PAGE IS UP
	CALLA	EXISTP
	jrnz	#exists			;credit page up, so reprint text only

;	JSRP	scrn_scaleininit	;Hide display

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	coinin_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movk	1,a0
	move	a0,@DISPLAYON		;Display processor on

	callr	crd_updatetxt

	SLEEPK	2

;	JSRP	scrn_scalein

	movi	4<<10+4<<5+7,a0
	move	a0,@IRQSKYE

	SLEEPK	2
	calla	display_unblank

	jruc	#cont


#exists
	move	@HEBLNK,a0
	cmpi	HEBLNKINIT,a0
	jrne	#inscl
	move	@dtype,a0
	jrge	#notinscl
#inscl	move	a10,a10
	jrnz	KILL_CRD2
	jruc	#die
#notinscl
	SLEEPK	3
#cont
	callr	crd_updatetxt		;Display players per credit messages

	movi	HEBLNKINIT,a0			;Display on (just in case)
	move	a0,@HEBLNK


	SLEEP	1*TSEC


	movi	4*TSEC,a11
#lp	SLEEPK	1
	.ref	get_all_buttons_cur2
	calla	get_all_buttons_cur2
	jrz	#nob


;MJT Start
      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	SLEEPK	10
;MJT End



	move	a10,a10
	jrnz	KILL_CRD2
	jruc	KILL_CRD
#nob
	dsj	a11,#lp

#ck2
	move	a10,a10
	jrnz	KILL_CRD2

	movi	10*TSEC,a11
#lp1	SLEEPK	1
	calla	get_all_buttons_cur2
	jrz	#nob1

;MJT Start
      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	SLEEPK	10
;MJT End

	jruc	KILL_CRD
#nob1
	dsj	a11,#lp1

KILL_CRD
	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT
	SLEEPK	1
	jauc	amode_start

#die	DIE


;MJT Start
	.ref	bounce_snd
;bounce_snd	.word	>fc80,10,>8129,0	;Ball bounce
;MJT End

KILL_CRD2
	RETP

coinin_mod
	.long	BKGDBMOD
;	.long	empjambBMOD
	.word	0,0
	.long	0


********************************

 SUBRP	crd_updatetxt

	movi	CP_PID1,a0		;PID
	movi	0ffffh,a1		;mask bits
	calla	KILALL			;kill all CP_PID1 procs except self

	movi	TYPTEXT,a0		;object ID
	clr	a1			;mask
	calla	obj_delc		;delete existing text

;	MOVI	CPYR_MES,a2		;COPYRIGHT MESSAGE

	PUSH	A10
	callr	credits_string
	PULL	A10
	rets

#*****************************************************************************

	.asg	25,YSPACE
	.asg	17,YSPACE0

	.asg	40,LN0
	.asg	70,LN1
	.asg	100,LN2
	.asg	130,LN3
	.asg	60,LN3x
	.asg	160,LN4
	.asg	190,LN5
	.asg	220,LN6


CM_Y_GAP	EQU	13
CM_Y_GAP2	EQU	80
CM_Y_ADDGAP	EQU	[CM_Y_GAP,200]

credits_string

	MOVK	ADJFREPL,A0		;ARE WE IN FREE PLAY?
	CALLA	GET_ADJ
	JRZ	#not_freeply

	movi	LN3x_setup,a2
	calla	setup_message
	move	*a2,a0,L
	move	a0,@mess_justify,L	;justification method
	move	@mess_cursx,a0
	move	a0,@mess_cursx2
	movi	#str_freeply,a4
	calla	print_string2b

	movi	LN3y_setup,a2
	calla	setup_message
	move	*a2,a0,L
	move	a0,@mess_justify,L	;justification method
	move	@mess_cursx,a0
	move	a0,@mess_cursx2
	movi	#str_start_fp,a4
	calla	print_string2b
	rets

#not_freeply
	move	@_dipswitch_addr,a0,L
	move	*a0,a0
	btst	6,a0			;SW1 switch 7
	jrnz	#notfair		;OFF?

;Yes, a dollar bill acceptor is hooked up!

	MOVI	dollar_mes,a2		;Dollar bill message
	calla	print_message
#notfair

;print	"BEST VALUE"
;	movi	LN0a_setup,a2
;	calla	setup_message
;	movi	#str_value,a4
;	calla	print_string_C2


;print "PURCHASE FULL GAMES FOR ONLY X CREDITS!"
	movi	LN0_setup,a2
	calla	setup_message
	movi	#str_fullg1,a4
	calla	print_string_C2

	movk	ADJCCONT,a0
	calla	GET_ADJ
	move	a0,a10
	add	a0,a10
	add	a0,a10
	movk	ADJCSTRT,a0
	calla	GET_ADJ
	add	a0,a10

	move	@mess_cursy,a0
	addi	YSPACE0,a0
	move	a0,@mess_cursy
	movi	ADJFULLG,a0
	calla	GET_ADJ 		;# credits for full game
	cmp	a0,a10
	jrge	#ok
	move	a10,a0
#ok
	movi	20,a1			;max string value

	calla	dec_to_asc
	calla	copy_string
	movi	#str_fullg2,a4
	calla	concat_rom_string
	calla	print_string_C

	calla	GET_CSPT		;a6 = * current pricing table
	movk	2,a10			;min number strings to print
	move	*a6(CS_LIST),a11,L	;a11 = * string list
	jrz	#no_strings

	move	a11,a2
#next_string
	move	*a2+,a0,L		;count up number of strings
	jrz	#last
	inc	a10
	jruc	#next_string
#last
#no_strings
	callr	CRED_P			;get number credits
	move	a0,a3
	MOVK	ADJCSTRT,A0
	callr	GET_ADJ 		;# credits to start
	divu	a0,a3			;credits / credits to start
	move	a3,a3
	jrz	#not_enough1
	inc	a10			;+1 string	(READY FOR...)
#not_enough1


;print	"CREDITS : N"

	movi	LN1_setup,a2
	calla	setup_message

	callr	CRED_P			;# credits in a0
	PUSH	a0

	movi	#crd_str,a4
	calla	copy_rom_string

	PULL	a0
	PUSH	a0
	movi	99,a1			;max string value
	calla	dec_to_asc
	calla	concat_string

	MOVK	ADJMAXC,a0
	calla	GET_ADJ_FOR_COIN 	;a0 = max credits
	PULL	a1
	cmp	a0,a1
	jrlo	#not_max_crds
	movi	#str_max,a4		;max credits
	calla	concat_rom_string
#not_max_crds
	calla	print_string_C		;"CREDITS : NN"


;print 0-3 strings from current pricing table

	movi	LN2_setup,a2
	calla	setup_message

	movi	140,a0
	movi	YSPACE0,a1
	mpyu	a10,a1			;# strings * Y spacing
	srl	1,a1			;/2
	sub	a1,a0
	move	a0,@mess_cursy		;centered Y

	calla	TAMPEREDP
	JRZ	#done

#next_string2
	move	*a11+,a4,L            	;* next string
	jrz	#done

	move	@mess_cursy,a0
	addi	YSPACE0,a0
	move	a0,@mess_cursy

	calla	print_string_C2

	jruc	#next_string2
#done


;print	"N CREDITS TO START"

	move	@mess_cursy,a0
	addi	YSPACE0,a0
	move	a0,@mess_cursy

	MOVK	ADJCSTRT,a0
	callr	GET_ADJ 		;# credits to start
	PUSH	a0
	movi	99,a1			;max string value
	calla	dec_to_asc
	calla	copy_string

	movi	#crd_2start,a4
	PULL	a0
	dec	a0
	jrz	#1credit
	movi	#crd_2starts,a4
#1credit
	calla	concat_rom_string
	calla	print_string_C


;print	"N CREDITS TO CONTINUE"

	move	@mess_cursy,a0
	addi	YSPACE0,a0
	move	a0,@mess_cursy

	MOVI	ADJCCONT,a0		;# credits to continue
	callr	GET_ADJ
	PUSH	a0
	movi	99,a1			;max string value
	calla	dec_to_asc
	calla	copy_string
	movi	#crd_2cont,a4
	PULL	a0
	dec	a0
	jrz	#1_creditb
	movi	#crd_2conts,a4
#1_creditb
	calla	concat_rom_string
	calla	print_string_C


;print READY FOR N PLAYERS and PRESS START/INSERT COIN messages
	movi	LN5_setup,a2
	calla	setup_message

	callr	CRED_P			;get number credits
	move	a0,a3

	MOVK	ADJCSTRT,A0
	callr	GET_ADJ 		;# credits to start

	divu	a0,a3			;credits / credits to start
	move	a3,a3
	jrz	#not_ready
	dec	a3

	move	@TWOPLAYERS,a0		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrs

	cmpi	2,a3
	jrlo	#not_max
	movi	1,a3

#4_plyrs
	cmpi	4,a3
	jrlo	#not_max
	movi	3,a3
#not_max
	sll	5,a3		;x 32 bits
	addi	#ready_for_lookup,a3
	move	*a3,a4,L
;	move	@mess_cursy,a0
;	addi	YSPACE,a0
;	move	a0,@mess_cursy
	calla	print_string_C2

	movi	#str_start,a4
	jruc	#ready

#not_ready
;Turmell
;	movi	RUBYPAL,a0		;redpal
;	move	a0,@message_palette
	movi	#str_insert,a4
#ready
	move	@mess_cursy,a0
	addi	YSPACE,a0
	move	a0,@mess_cursy

	calla	print_string_C2

	rets



LN0_setup
	PRINT_STR	bast10_ascii,5,0,200,LN0-YSPACE,BAST_W_P,0
	.even
LN1_setup
	PRINT_STR	bast18_ascii,10,0,200,LN1+4,BSTGYG_P,0
	.even
LN2_setup
	PRINT_STR	bast10_ascii,5,0,200,LN2,BAST_Y_P,0
	.even
LN3_setup
	PRINT_STR	bast8_ascii,5,0,200,LN3,BST18G_P,0
	.even
LN3x_setup
	PRINT_STR	hangfnt38_ascii,14,0,54,80,HANGF_G_P,kern_chars
	.even
LN3y_setup
	PRINT_STR	hangfnt38_ascii,14,0,14,145,HANGF_G_P,kern_chars
	.even
LN5_setup
	PRINT_STR	bast18_ascii,10,0,200,LN5+10,BSTGYG_P,0
	.even

#str_value
	.string	"BEST VALUE:",0
#str_fullg1
	.string	"PURCHASE FULL GAMES FOR ONLY ",0
#str_fullg2
	.string	" CREDITS PER PLAYER!",0
#str_max
	.string	" (MAXIMUM)",0
#crd_str
	.string	"CREDITS : ",0
#crd_2start
	.string	" CREDIT TO START",0
#crd_2starts
	.string	" CREDITS TO START",0
#crd_2cont
	.string	" CREDIT TO CONTINUE",0
#crd_2conts
	.string	" CREDITS TO CONTINUE",0
#str_freeply
	.string	"F",1,-5,"R",1,-3,"E",1,-5,"E P",1,-4,"L",1,1,"A",1,4,"Y",0
#str_start_fp
	.string	"P",1,-2,"R",1,-3,"E",1,-3,"S",1,-1,"S "
	.string	"S",1,2,"T",1,-10,"A",1,3,"R",1,3,"T",0
#str_start
	.string	"PRESS START",0
#str_insert
	.string	"INSERT COINS",0
	.even
#ready_for_lookup
	.long	#str_1p,#str_2p
	.long	#str_3p,#str_4p
#str_1p	.string	"READY FOR 1 PLAYER",0
#str_2p	.string	"READY FOR 1 - 2 PLAYERS",0
#str_3p	.string	"READY FOR 1 - 3 PLAYERS",0
#str_4p	.string	"READY FOR 1 - 4 PLAYERS",0
	.even


 .if 0

CM_LINE1  EQU	  CUSTOM_MESSAGE
CM_LINE2  EQU	  CUSTOM_MESSAGE+CMESS_LINE_SIZE
CM_LINE3  EQU	  CUSTOM_MESSAGE+(2*CMESS_LINE_SIZE)

;OUTPUT_CUSTOM


        CALLA   ADJ_PAGE 
        MOVI    VALID_CUSTOM,A7
        CALLA   RC_WORD
        CMPI    VALID_VALUE,A0		; CHECK TO SEE IF MESSAGE IS VALID
	JRNZ	#zippo


	movi	CM_LINE3,A10		;CHECK LINE 3
	callr	CK_LINE 		;3 VALID LINES?
	jrz	GO_FOR_2
	movi	LN2_setup,a2
	calla	setup_message
	movi	STRNGRAM,a4
	calla	print_string_C2
GO_FOR_2
	movi	CM_LINE2,A10		;CHECK LINE 2
	callr	CK_LINE 		;2 VALID LINES?
	jrz	GO_FOR_1
	movi	LN3_setup,a2
	calla	setup_message
	movi	STRNGRAM,a4
	calla	print_string_C2
GO_FOR_1
	movi	CM_LINE1,A10		;CHECK LINE 1
	callr	CK_LINE 		;1 VALID LINES?
	jrz	#zippo
	movi	LN4_setup,a2
	calla	setup_message
	movi	STRNGRAM,a4
	calla	print_string_C2
#zippo
 .endif

#*****************************************************************************

;open up window stating winners of a 4 player game get next game free

	.asg	8,Y0
	.asg	129-38,Y1
	.asg	159-38,Y2
	.asg	16,SPACING

	.ref	mess_objid
	.ref	flash_bigtxt

	.ref	pal_getf

 SUBR	winner_stays_msg

	.ref	cheer4_snd
 	SOUND1	cheer4_snd

	movk	ADJFREPL,a0			;ARE WE IN FREE PLAY?
	calla	GET_ADJ
	jrnz	#exit

	movi	ADJWINMODE,a0
	calla	GET_ADJ
	jrz	#exit				;disabled?

	sll	5,a0
	addi	winer_sty_img_tbl,a0
	move	*a0,a2,L
	jrz	#exit

	PUSH	b0
	movi	BAST_W_P,b0
	movi	[200,0],a0			;x val
	movi	[169,0],a1			;y val
	movi	1200,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	WIN_STAY_MSG,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP2
	PULL	b0

	SLEEP	TSEC*1

	movk	10,a11
wsm_1
	movi	BAST_R_P,a0
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set pallette & constant
	SLEEPK	4
	movi	BAST_W_P,a0
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set pallette & constant
	SLEEPK	4
	dsj	a11,wsm_1

	SLEEP	TSEC*2

	movi	WIN_STAY_MSG,a0			;object ID
	calla	obj_del1c			;delete text
#exit	DIE




winer_sty_img_tbl
	.long	0		;padding
	.long	WIN4FREE	;msg for '4 players' option

;	.long	0		;padding
;	.long	WNRSSTAY	;msg for 'all games' option
;	.long	WINSTAY		;msg for 'player vs. player' option
;	.long	WIN4FREE	;msg for '4 players' option


#*****************************************************************************


	.if 0
HELP_TAB
	.LONG	 L_MESS 		;0 SAYS USE L_MESS
	.LONG	 JUST_LIST		;1 SAYS USE LISTED MESSAGES ONLY
	.LONG	 LINE_ONE_PLUS		;2 SAYS USE 1ST LINE W/ 2 TO START
	.LONG	 LINE_TWO_PLUS		;3
	.LONG	 LINE_THREE_PLUS	;4
	.LONG	 LINE_ONE_PLUS_2	;5 USE 1ST LINE 2/ 2 CREDITS PER PLAYER
	.LONG	 LINE_TWO_PLUS_2	;6
	.LONG	 LINE_THREE_PLUS_2	;7
	.LONG	 OUTPUT_CUSTOM		;8 CUSTOM MESSAGE!

JUST_LIST
	MOVE	A8,A3			;STASH WHERE IT WILL SURVIVE
	MOVE	*A3(LONG_SIZE),A2,L	;ONE WORD ONLY?
	JRZ	JUST_ONE		;YEP....CENTER IT NICELY
*
*	there's a 2nd line...check for 3rd!
*
	MOVE	*A3(2*LONG_SIZE),A2,L  ;IS THERE A 3RD LINE?
	JRZ	JUST_TWO		;NOPE

	MOVI	SETUP_3_OF_3,A8
	JSRP	SET_THEN_A2

	MOVE	*A3(LONG_SIZE),A2,L	;GET LINE 2

	MOVI	SETUP_2_OF_3,A8
	JSRP	SET_THEN_A2

	MOVI	SETUP_1_OF_3,A8		;SET HEIGHT FOR TOP LINE
	JRUC	FIRST_LINE

JUST_TWO
	MOVE	*A3(LONG_SIZE),A2,L	;GET LINE 2
	MOVI	SETUP_2_OF_2,A8
	JSRP	SET_THEN_A2

	MOVI	SETUP_1_OF_2,A8

FIRST_LINE
	MOVE	*A3,A2,L
	JRUC	SET_THEN_A2		  ;DO TOP LEN AND RETURN

JUST_ONE
	MOVI	SETUP_1_OF_1,A8
	JRUC	FIRST_LINE		  ;DO TOP LEN AND RETURN

*
*	OUTPUT THE CUSTOM MESSAGE
*
CM_LINE1  EQU	  CUSTOM_MESSAGE
CM_LINE2  EQU	  CUSTOM_MESSAGE+CMESS_LINE_SIZE
CM_LINE3  EQU	  CUSTOM_MESSAGE+(2*CMESS_LINE_SIZE)

OUTPUT_CUSTOM
	MOVI	CM_LINE3,A10		;CHECK LINE 3
	CALLR	CK_LINE 		;3 VALID LINES?
	JRZ	GO_FOR_2

	MOVI	SETUP_3_OF_3,A8
	JSRP	SET_THEN_STRNGRAM	;PUT IT OUT

	MOVI	CM_LINE2,A10
	MOVI	SETUP_2_OF_3,A8
	JSRP	SET_THEN_STRNGRAM

	MOVI	CM_LINE1,A10
	MOVI	SETUP_1_OF_3,A8
	JRUC	SET_THEN_STRNGRAM

GO_FOR_2
	MOVI	CM_LINE2,A10		;CHECK LINE 2
	CALLR	CK_LINE 		;2 VALID LINES?
	JRZ	GO_FOR_1

	MOVI	SETUP_2_OF_2,A8
	JSRP	SET_THEN_STRNGRAM	;PUT IT OUT

	MOVI	CM_LINE1,A10
	MOVI	SETUP_1_OF_2,A8
	JRUC	SET_THEN_STRNGRAM

GO_FOR_1
	MOVI	CM_LINE1,A10
	MOVI	SETUP_1_OF_1,A8
	JRUC	SET_THEN_STRNGRAM

	.endif

**************************************************************************
*
*	SET_THEN_A2
*
*	THIS IS A PRIMITIVE FOR THE COIN PAGE PLOTTERS.
*
*	IT SETS UP WITH THE STRING IN A8, THEN FINSHES
*	ON THE STRING IN A2.
*
*	JSRP THIS ROUTINE!
*
**************************************************************************
SET_THEN_A2
	CALLA	LM_SETUP
	MOVE	A2,A8
	JAUC	LM_FINIS		;THAT DOES LINE 3

**************************************************************************
*
*	SET_THEN_STRNGRAM
*
*	A10 POINTS AT A CMOS STRING FOR CUSTOM MESSAGE.
*	A8 CONTAINS THE SETUP STRING FOR PRINTING THIS
*	STRING OUT. CONVERT FROM CMOS TO STRNGRAM
*	AND PRINT ON THE STRING.
*
**************************************************************************
SET_THEN_STRNGRAM
	CALLR	CK_LINE 		;TRANSFER TO STRNGRAM
	CALLR	LM_SETUP
	MOVI	STRNGRAM,A8
	JAUC	LM_FINIS

**************************************************************************
*
*	CK_LINE
*
*	A10 POINTS AT A CMOS STRING.  WE MOVE THIS STRING
*	TO OUR PDATA AREA.  THEN WE CALL BUILD_ST TO
*	PACK IT INTO "STRNGRAM" WE RETURN .EQ. (PASSED FROM
*	BUILD_ST) BACK TO OUR CALLER IF IT IS ALL SPACES.
*
**************************************************************************
CK_LINE
	MMTM	SP,A0,A7,A1,A2,A10
	MOVE	A10,A7			;INPUT POINTER TO CMOS
	MOVE	A13,A10 		;OUR PDATA AREA
	ADDI	PDATA,A10		;A10 IS DESTINATION.
	MOVE	A10,A2			;ITERATE TO LOAD IT UP.

	MOVI	CMESS_CHARS,A1		;COUNTER
	CALLA	ADJ_PAGE		;POINT THE PAGE

CK_LOOP
	CALLA	RC_BYTEI		;FETCH A BYTE
	MOVB	A0,*A2			;STORE
	ADDK	BYTE_SIZE,A2
	DSJS	A1,CK_LOOP

	CALLA	DEF_PAGE		;POINT AWAY NOW
	CALLA	BUILD_ST		;NOW XFER TO STRNGRAM (REMOVING SPACES ETC)
	MMFM	SP,A0,A7,A1,A2,A10	;RETURN .EQ. IF ITS ALL SPACES.
	RETS




LINE_ONE_PLUS
	MOVE	*A8,A2,L		;GET LINE 1
LOP_1
	MOVI	SETUP_1_OF_3,A8
	CALLR	LM_SETUP
	MOVE	A2,A8			;SWAP IN TEXT POINTER
	JSRP	LM_FINIS		;PRINT IT

LOP_2
	MOVI	TWO_TS,A8		;TWO TO START STUFF
	JAUC	L_MESS			;PRINT IT AND RETURN

*
*	 IF THE GAME IS IN A 2 TO START....2 TO CONTINUE MODE
*
LINE_THREE_PLUS
	MOVE	*A8(2*LONG_SIZE),A2,L	;FETCH LINE 3
	JRZ	LOP_2			;NOTHING ON LINE 3
	JAUC	LOP_1			;THEN ITS THE SAME AS ABOVE!

LINE_TWO_PLUS
	MOVE	*A8(LONG_SIZE),A2,L	;FETCH LINE 2
	JRZ	LOP_2			;NOTHING ON LINE 2
	JAUC	LOP_1			;THEN ITS THE SAME AS ABOVE!

LINE_ONE_PLUS_2
	MOVE	*A8,A2,L		;GET LINE 1
LOP_12
	MOVI	SETUP_1_OF_2,A8
	CALLR	LM_SETUP
	MOVE	A2,A8			;SWAP IN TEXT POINTER
	JSRP	LM_FINIS		;PRINT IT

LOP_22
	MOVI	TWO_TP,A8		;TWO CREDITS PER PLAYER
	JAUC	L_MESS			;PRINT IT AND RETURN

LINE_TWO_PLUS_2
	MOVE	*A8(LONG_SIZE),A2,L	;FETCH LINE 2
	JRZ	LOP_22			;NOTHING ON LINE 2
	JAUC	LOP_12			;THEN ITS THE SAME AS ABOVE!

LINE_THREE_PLUS_2
	MOVE	*A8(2*LONG_SIZE),A2,L	;FETCH LINE 3
	JRZ	LOP_22			;NOTHING ON LINE 3
	JAUC	LOP_12			;THEN ITS THE SAME AS ABOVE!

**************************************************************************
*
*	SELECT_SETUP
*
*	THIS IS CALLED TO SELECT A SETUP STRING FOR THE
*	CREDITS MESSAGE.  IF THERE IS PROMPTING TO ADD...WE
*	DROP IT DOWN....ELSE WE PRINT IT CENTERED.
*
**************************************************************************
SELECT_SETUP
	PUSH	a0
	MOVI	MESS_CNUM,A8		  ;ASSUME NO EXTRA PROMPT

	CALLA	CKPROMPT		  ;IS THERE ONE?
	JRZ	NO_EXTRA

	MOVI	MESS_LOWNUM,A8
NO_EXTRA
	MMFM	SP,A0			
	RETS

**************************************************************************
*
*	FETCH_REQ
*
*	THIS ROUTINE FETCHES THE NUMBER OF UNITS REQUIRED
*	FOR CREDIT, BONUS AND MINIMUM:
*
*		A2 = REQ FOR CREDITS
*		A3 = REQ FOR BONUS
*		A4 = MINIMUM
*
**************************************************************************
FETCH_REQ
	PUSH	a0
	MOVK	ADJCUNIT,A0
	CALLR	GET_ADJ
	MOVE	A0,A2

	MOVK	ADJBUNIT,A0
	CALLR	GET_ADJ
	MOVE	A0,A3

	MOVK	ADJMUNIT,A0
	CALLR	GET_ADJ_FOR_COIN
	MOVE	A0,A4
	MMFM	SP,A0
	RETS

**************************************************************************
*
*	SLAM_P
*
*	IS THERE A SLAM PROCESS RUNNING?
*
*	.EQ.	NO
*	.NE.	YES
*
**************************************************************************
SLAM_P
	MOVI	SLAM_PID,A0		;SLAM PROCESS ACTIVE?
	MOVI	0FFFFH,A1
	jauc	EXISTP

SLAM_SW
	movi	SLAM_PID|>ffff0000,a0	;So we can kill other indestructables
	move	a0,*a13(PROCID)		;Set our ID
	calla	KIL1C			;Kill others

	SLEEP	TSEC			;1 second of coin ignoring
	jauc	SUCIDE

**************************************************************************
*
*	FORM_COIN_CKSUM
*
*	THIS ROUTINE IS CALLED TO FORM THE COIN/CREDITS
*	CHECKSUM.  THE CHECKSUM IS RETURNED IN A1.
*
*	Z	IT MATCHES WHATS THERE
*	NZ	IT DOESN'T MATCH
*
**************************************************************************
FORM_COIN_CKSUM
	MMTM	SP,A0,A7,A2
	CALLR	COIN_PAG		 ;MAKE SURE WE'RE ON THE RIGHT PAGE.
	MOVI	COIN_CKSUM_START,A7	  ;POINT AT FIRST BYTE TO CHECK
	MOVI	COIN_CKSUM_BYTES,A2
	CLR	A1			  ;CLEAR OUT CHECKSUM

CN_SUM
	CALLA	RC_BYTEI		  ;FETCH A BYTE IN A0
	ADD	A0,A1			  ;ADD TO SUM
	DSJS	A2,CN_SUM		  ;TILL WE HAVE EM ALL

	NOT	A1			  ;COMPLEMENT OF COURSE
	sll	32-8,a1
	srl	32-8,a1

	MOVI	COIN_CKSUM,A7
	CALLA	RC_BYTE 		  ;FETCH THE CURRENT CKSUM
	CMP	A0,A1			  ;COMPARE TO THIS
	MMFM	SP,A0,A7,A2
	RETS

FORM_COIN_CKSUM_AND_STORE
	MMTM	SP,A1,A7,A0
	CALLR	FORM_COIN_CKSUM
	MOVI	COIN_CKSUM,A7
	MOVE	A1,A0
	CALLA	WC_BYTE
	MMFM	SP,A1,A7,A0
	RETS

**************************************************************************
*
*	CCCC
*
*	Check_Coin_and_Clear_on_bad_Checksum.
*
*	This is called before operations that deal with
*	the coinage and credits values.
*
*	It checks to see if the area is in tact. If it
*	is, then no action is performed.
*
*	Else, it clears our all values (credits, etc.)
*	so that nothing is given away erroneously.
*
**************************************************************************
CCCC
	MMTM	SP,A0,A1,A7,A2
	CALLR	FORM_COIN_CKSUM		;THIS SETS US TO THE COINAGE PAGE!
	JRZ	CCCCX			;ALL IS OK!

	MOVI	COIN_CKSUM_START,A7  ;POINT AT FIRST BYTE
	MOVI	COIN_CKSUM_BYTES,A2  ;NUMBER OF BYTES TO CLEAR
	CLR	A0

CCCC_LOOP
	CALLA	WC_BYTEI		;WRITE A BYTE
	DSJS	A2,CCCC_LOOP		;UNTIL THEY'RE DONE!

	CALLR	FORM_COIN_CKSUM_AND_STORE  ;NOW MAKE THE CKSUM VALID

CCCCX
	MMFM	SP,A0,A1,A7,A2
	RETS

**************************************************************************
*
*	COIN_PAG
*
*	THIS SETS THE CURRENT CMOS PAGE FOR COIN/CREDITS
*
**************************************************************************
COIN_PAG
	PUSH	a1
	MOVI	COIN_SELECT,A1		;THIS IS COIN/CREDITS PAGE
	CALLA	SET_PAGE		;SET IT PLEASE
	MMFM	SP,A1
	RETS


********************************
* Add the # of players to the audit
* A0=Audit #
* Trashes A0-A1,B0-B1

 SUBR	aud_addnumplyrs

	movk	1,a1		;1 plyr
	move	@PSTATUS,b0
	subk	3,b0
	jrne	aanp50		;Only 1?
	movk	2,a1		;2 plyrs
aanp50	jruc	AUD


**************************************************************************
*
*	AUDIT HANDLING
*
**************************************************************************
*
*	POINT_AT_AUDIT
*
*	THIS IS CALLED TO POINT AT THE AUDIT INDICATED BY
*	A0. A0 IS THE AUDIT NUMBER 0-30. A7 IS RETURNED
*	POINTING AT THE BEGINNING OF THE AUDIT.
*
**************************************************************************
POINT_AT_AUDIT
	PUSH	a1
	CALLR	AUDIT_PAGE

	MOVI	AUD_SIZE,A7		;THIS IS SIZE PER AUDIT
	MPYU	A0,A7			;A1 NOW HAS OFFSET
	ADDI	AUDITORG,A7		;ADD BASE
	MMFM	SP,A1
	RETS

AUDIT_PAGE
	PUSH	a1
	MOVI	AUDIT_SELECT,A1		;THIS IS AUDIT PAGE
	CALLA	SET_PAGE		;SET IT PLEASE
	MMFM	SP,A1
	RETS

**************************************************************************
*
*	FORM_AUD_CKSUM
*
*	THIS IS CALLED TO FORM THE CHECKSUM FOR THE AUDIT
*	SPECIFIED IN A0.
*
*	A1 RETURNS THE CHECKSUM.
*
*	Z BIT IS SET BASED ON WHETHER IT MATCHES THE CHECKSUM THERE.
*
**************************************************************************
FORM_AUD_CKSUM
	MMTM	SP,A0,A4,A7
	CALLR	POINT_AT_AUDIT		  ;A7 = POINTER TO CURRENT ENTRY
	MMTM	SP,A7			  ;SAVE POINTER TO ENTRY
	MOVI	AUD_BYTES_TO_CHECK,A4	  ;COUNT DOWN THE BYTES
	CLR	A1			  ;KEEP SUM IN A1
ADD_A_BYTE
	CALLA	RC_BYTEI		  ;GET A BYTE INTO A0
	ADD	A0,A1			  ;ADD TO SUM
	DSJ	A4,ADD_A_BYTE		  ;ONE MORE ADDED
	NOT	A1			  ;CHECKSUM IS NOW IN LOW WORD
	ZEXT	A1
;	 ANDI	 WORD_MASK,A1			;MASK SO ITS COOL
	MMFM	SP,A7			  ;GET POINTER BACK
	ADDI	AUD_CKSUM,A7		  ;POINT AT CHECKBYTE
	CALLA	RC_WORD 		  ;READ IN THE CKSUM
	CMP	A0,A1			  ;COMPARE WHAT'S THERE TO WHAT WE GOT
	MMFM	SP,A0,A4,A7		  ;Z BIT RETURNS COMPARE
	RETS				  ;A1 RETURNS CKSUM

**************************************************************************
*
*	STORE_AUD_CKSUM
*
*	THIS WILL STORE THE AUDIT CHECKSUM IN A1 FOR THE
*	AUDIT NUMBER SPECIFIED BY A0.
*
**************************************************************************
STORE_AUD_CKSUM
	MMTM	SP,A7,A0		  ;POINTING REGISTER
	CALLR	POINT_AT_AUDIT		  ;A7 POINTS AT AUDIT
	ADDI	AUD_CKSUM,A7		  ;POINT AT CHECKBYTE
	MOVE	A1,A0			  ;GET CHECKBYTE IN A0
	CALLA	WC_WORD 		  ;WRITE THE CKSUM
	MMFM	SP,A7,A0		  ;POINTING REGISTER
	RETS

**************************************************************************
*
*	FORM_AUD_CKSUM_AND_STORE
*
*	THE VALUE AT BAD_AUD IS USED TO DETERMINE WHETHER TO STORE
*	THE CORRECT OR INCORRECT VALUE!
*
*	A0 = AUDIT NUMBER
*
**************************************************************************
FORM_AUD_CKSUM_AND_STORE
	MMTM	SP,A1,A2			;SAVE A1!
	CALLR	FORM_AUD_CKSUM
	MOVE	@BAD_AUD,A2			;GET THE "FUDGE" WORD
	XOR	A2,A1				;MAKE CKSUM BAD IF AUDIT IS BAD
	CALLR	STORE_AUD_CKSUM
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*
*	GET_AUD
*
*	THIS IS CALLED TO FETCH THE AUDIT VALUE FOR THE AUDIT
*	SPECIFIED IN A0 INTO A1.  IF THE CHECKBYTE FOR THE
*	AUDIT IS INCORRECT, THEN RAM LOCATION BAD_AUD WILL BE
*	SET TO 1.
*
**************************************************************************
GET_AUD
	MMTM	SP,A0,A7
	CALLR	FORM_AUD_CKSUM		;SEE IF CKSUM IS OK
	JRZ	FETCH_AUDIT_1		;ITS OK....

	MOVK	1,A1			;CHECKSUM IS BAD
	MOVE	A1,@BAD_AUD		;SET THE FLAG!

FETCH_AUDIT_1
	CALLR	POINT_AT_AUDIT		;A7 POINTS AT AUDIT
	ADDI	AUD_DATA,A7		;ADD ZERO OFFSET
	CALLA	RC_LONG			;FETCH THE LONG WORD TO A0
	MOVE	A0,A1			;RETURN IN A1
	MMFM	SP,A0,A7
	RETS

**************************************************************************
*
*	STORE_AUDIT
*
*	A0 = AUDIT NUMBER TO STORE VALUE FOR
*	A1 = VALUE TO STORE.
*	BAD_AUD = NON ZERO IF BAD CHECKSUM IS TO BE MAINTAINED.
*
**************************************************************************
STORE_AUDIT
	
	MMTM	SP,A0,A7
	CALLR	POINT_AT_AUDIT		;A7 POINTS AT AUDIT
	ADDI	AUD_DATA,A7		;ADD ZERO OFFSET
	MOVE	A1,A0			;MOVE DATA TO WRITING REGISTER
	CALLA	WC_LONG 		;WRITE THE DATA BACK
	MMFM	SP,A0,A7		;GET AUDIT NUMBER BACK
	JRUC	FORM_AUD_CKSUM_AND_STORE	;STORE GOOD OR BAD CKSUM BASED
						;ON BAD_AUD

**************************************************************************
*
*	CLR_SUBS
*
*	THIS IS CALLED TO CLEAR OUT THE COINAGE SUB-TOTALS.
*
**************************************************************************
;CLR_SUBS
;	MOVI	FRST_SUB,A0
;	 MOVI	 LAST_SUB,A1
;	 CALLR	 CLR_AUDR	 ;CLEAR EM OUT!
;	 RETP
;
**************************************************************************
*
*		CLR_AUDR
*
*		THIS IS CALLED TO CLEAR OUT A RANGE OF AUDITS.
*		A0 = 1ST AUDIT NUMBER
*		A1 = LAST AUDIT NUMBER (INCLUSIVE)
*
**************************************************************************
CLR_AUDR
	MMTM	SP,A0,A1,A2
	MOVE	A1,A2			  ;MOVE "LAST" TO A2
	CLR	A1			  ;WE'LL STORE ZEROS
	MOVE	A1,@BAD_AUD		  ;MAKE CKSUMS GOOD ON STORING
CAR1
	CALLR	STORE_AUDIT		  ;STORE THIS AUDIT
	INC	A0			  ;KICK TO NEXT AUDIT
	CMP	A2,A0
	JRLS	CAR1
	MMFM	SP,A0,A1,A2
	RETS

**************************************************************************
*
*	CLR_DUMP_AUD
*
*	This is called by both joysticks down while looking
*	at dump page.	It clears out the audits associated
*	with that page.
*
**************************************************************************
;CLR_DUMP_AUD
;	 MOVI	 AUDDOGGY,A0
;	CALLR	KILL_AUD
;	 MOVI	 AUDLOCK,A0
;	CALLR	KILL_AUD
;	 MOVI	 AUDTRAP,A0
;	CALLR	KILL_AUD
;	 MOVI	 AUDSURV,A0
;	CALLR	KILL_AUD
;	 MOVI	 AUDBONE,A0
;	CALLR	KILL_AUD
;	RETS
	
**************************************************************************
*
*	KILL_AUD
*
*	This is called to clear out an audit.
*
*	A0 = audit number.
*
**************************************************************************
KILL_AUD
	PUSH	a1
	CLR	A1			  ;WE'LL STORE ZEROS
	MOVE	A1,@BAD_AUD		  ;MAKE CKSUMS GOOD ON STORING
	CALLR	STORE_AUDIT		  ;STORE THIS AUDIT
	MMFM	SP,A1
	RETS

**************************************************************************
*
*	AUD
*
*	A0 = AUDIT NUMBER.......A1 = COUNT TO ADD.
*
**************************************************************************
AUD
	MMTM	SP,A1,A2
	CLR	A2			;SET "BAD_AUD" GOOD UNTIL OTHERWISE PROVEN!
	MOVE	A2,@BAD_AUD		;ITS GOOD.
	MOVE	A1,A2			;COPY OUR COUNT
	CALLR	GET_AUD 		;FETCH THE CURRENT AUDIT COUNTER
	ADD	A2,A1			;ADD THE NEW COUNT
	CALLR	STORE_AUDIT		;STORE IT BACK
	CALLR	DEF_PAGE		;SWITCH PAGE AWAY FROM THE DATA!
	MMFM	SP,A1,A2
	RETS

AUD1
	PUSH	a1
	MOVK	1,A1
	CALLR	AUD
	MMFM	SP,A1
	RETS

**************************************************************************
*
*	CLR_AUD
*
*	This is called to clear out all of the audits.
*
*	A relatively easy task given the primitives available.
*
**************************************************************************
CLR_AUD
	MMTM	SP,A0,A1
	MOVK	1,A0			;START AT AUDIT 1
	MOVI	N_AUDITS-1,A1		;THIS IS TOTAL ALLOCATED
	CALLR	CLR_AUDR
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*
*	ADJUSTMENTS
*
**************************************************************************
**************************************************************************
*
*	CMOS_VAL
*
*	ARE ADJUSTMENTS AND NAME/REV OK?
*
*	.EQ. MEANS YES
*	.NE. MEANS NO
*
**************************************************************************
CMOS_VAL
	CALLR	FORM_ADC  ;SEE IF CKSUM IS OK.
	JRNZ	CMOS_BAD	;NOPE....RETURN .NE.

	CALLR	CHECK_NAME_AND_REV	;HOW ABOUT THE NAME AND REV?
CMOS_BAD
	RETS

**************************************************************************
*
*	Adjustments are all stored as long words in CMOS.
*	They are referenced by adjustment number.  Stuff
*	adjustment number in A0. Call GET_ADJ and the
*	value is returned in A0.
*
**************************************************************************
**************************************************************************
*
*	FORM_ADC
*
*	THIS IS CALLED TO FORM THE CHECKSUM FOR THE ADJUSTMENTS
*	AREA.  IT IS RETURNED IN A1.
*
*	IT IS COMPARED TO THE REAL CHECKSUM AND .EQ. RETURNED IF OK.
*
**************************************************************************
FORM_ADC
	MMTM	SP,A7,A0,A6
	CALLR	ADJ_PAGE	  ;SET CMOS PAGE FOR ADJUSTMENTS
	MOVI	ADJUSTORG,A7		;POINT AT FIRST BYTE
	MOVI	ADJ_BYTES_TO_CHECK,A6  ;NUMBER OF BYTES
	CLR	A1			;ACCUMULATE CKSUM HERE

ADJ_C1
	CALLA	RC_BYTEI		;READ A BYTE
	ADD	A0,A1			;ADD THE BYTE TO THE SUM
	DSJS	A6,ADJ_C1
	NOT	A1			;COMPLEMENT THE SUM
	ZEXT	A1
	MOVI	ADJ_CKSUM,A7
	CALLA	RC_WORD 		;FETCH THE CHECKSUM
	CMP	A0,A1			;COMPARE TO FETCHED VALUE
	MMFM	SP,A7,A0,A6
	RETS

**************************************************************************
*
*	F_ADC_S
*
*	CALCULATE THE ADJUSTMENT CHECKSUM AND STORE THE
*	NEW VALUE.
*
**************************************************************************
F_ADC_S
	MMTM	SP,A0,A1,A7
	CALLR	FORM_ADC		;FORM THE CKSUM
	MOVE	A1,A0			;PUT IN CMOS WRITING REGGIE
	MOVI	ADJ_CKSUM,A7
	CALLA	WC_WORD 		;AND STORE IT
	MMFM	SP,A0,A1,A7
	RETS

**************************************************************************
*
*	GET_ADJ
*
*	THIS IS CALLED TO FETCH THE VALUE OF AN ADJUSTMENT.
*
*	THE ADJUSTMENT NUMBER IS GIVEN IN A0.
*	THE VALUE FOR THE ADJUSTMENT IS RETURNED IN A0.
*
**************************************************************************
GET_ADJ
	PUSH	a1,a7
	CALLR	ADJPOINT		;POINT AT ADJUSTMENT
	CALLA	RC_LONG 		;FETCH THE ADJUST PLEASE
	CALLR	DEF_PAGE
	PULL	a1,a7
	MOVE	A0,A0			;RETURN Z BIT BASED ON ADJUSTMENT!
	RETS

**************************************************************************
*
*	PUT_ADJ
*
*	ADJUST NUMBER IN A0.
*	VALUE IN A1.
*	STORE IT!........
*
*	****************** THIS IS A UTILITY......IT DOES NOT
*			CORRECT ANY CHECKSUM CHANGE THAT
*			MAY OCCUR!!
*
**************************************************************************
PUT_ADJ
	PUSH	a0,a7
	CALLR	ADJPOINT		;POINT AT REQUESTED ADJ.
	MOVE	A1,A0			;GET VALUE IN WRITING REGGIE!
	CALLA	WC_LONG 		;WRITE THE ADJUSTMENT
	CALLR	DEF_PAGE		;SWAP PAGE AWAY.
	MMFM	SP,A7,A0
	RETS

ADJPOINT
	CALLR	ADJ_PAGE		;SET CMOS PAGE FOR ADJUSTMENTS
	MOVI	ADJ_SIZE,A7		;SIZE PER ADJUSTMENT IN A7
	MPYU	A0,A7			;TIMES ADJUSTMENT REQUESTED.
	ADDI	ADJUSTORG,A7		;ADD TO BASE
	RETS

GET_ADJ_FOR_COIN
	CALLR	GET_ADJ 		;GET THE ADJUSTMENT
	JAUC	COIN_PAG		;THEN RE-INSTATE THE COIN PAGE!

**************************************************************************
*
*	CHECK_NAME_AND_REV
*
*	THIS ROUTINE IS CALLED TO SEE IF THE GAME NAME/REV IS
*	CORRECT.  IF IT IS NOT, THE GAME WILL AUTOMATICALLY
*	FACTORY SET. Z MEANS OK!
*
**************************************************************************
CHECK_NAME_AND_REV
	MMTM	SP,A0,A1,A2,A3,A7
	CALLR	ADJ_PAGE	  ;MAKE SURE WE'RE ON THE CORRECT PAGE

	MOVI	NAME_REV,A7		;POINT AT CMOS NAME STORAGE
	MOVI	ROM_NAME,A1		;POINT AT OUR VERSION
	MOVI	NAME_REV_SIZE,A2	;MAXIMUM NAME SIZE

NEXT_LET1
	CALLA	RC_BYTEI		;FETCH A BYTE
	MOVB	*A1,A3			;GET 1 FROM ROM
	SLL	24,A3
	SRL	24,A3

	CMP	A3,A0			;THEY BETTER BE THE SAME
	JRNZ	RETURN_NOW		;NOPE....BYE  (RETURN .NE.)

	ADDK	BYTE_SIZE,A1		;KICK SOURCE POINTER
	MOVE	A0,A0			;WAS IT A ZERO?
	JRZ	RETURN_NOW		;YEP....NO MORE (RETURN .EQ.)
	DSJS	A2,NEXT_LET1
	CLR	A0			;RETURN .EQ.
	
RETURN_NOW
	MMFM	SP,A0,A1,A2,A3,A7
	RETS

**************************************************************************
*
*	ADJ_PAGE
*
*	THIS SETS THE CURRENT CMOS PAGE FOR ADJUSTMENTS.
*
**************************************************************************
ADJ_PAGE
	PUSH	a1
	MOVI	ADJUST_SELECT,A1	;THIS IS AUDIT PAGE
	CALLA	SET_PAGE		;SET IT PLEASE
	MMFM	SP,A1
	RETS


**************************************************************************
*
*	DEF_PAGE
*
*	THIS SWITCHES TO "DEFAULT" PAGE.  THE DEFAULT
*	PAGE IS THE ONE THAT WE WOULD LIKE TO SMASH
*	MOST IN THE CASE OF A CRASH.  AFTER MOST
*	PROCESSING, WE SWITCH TO THIS PAGE!
*
**************************************************************************
DEF_PAGE
 .if 0
	PUSHST				;PRESERVE CODES THAT ARE BEING RETURNED
	PUSH	a1
	MOVI	TODAYS_SELECT,A1	;THIS IS TODAY'S HIGH SCORES PAGE
	CALLA	SET_PAGE		;SET IT PLEASE
	PULL	a1
	POPST
 .endif
	RETS

**************************************************************************
* FAC_SET - Restores the factory settings to the adjustments
* A0=Mode (0=All adjustments, 1=Only coinage)

FAC_SET
	PUSH	a1,a2,a7

	move	a0,-*sp
	subk	1,a0
	jreq	fs20			;Just coinage?

;FIX!!! TEMP
; COMMENTED these out to avoid clear when change REV. number (in test games)
	.ref	clear_player_records
	calla	clear_player_records

	.ref	clear_team_records
	calla	clear_team_records

	.ref	reset_world_records
	calla	reset_world_records
;TEMP!

	calla	opmsg_clr

;;;	CALLR	DUMP_FS 		;CLEAR OUT "DUMP" MEMORY
;;;			(stomps on player records)


	CALLR	NO_CREDS		;REMOVE ANY COINS
	CALLR	ADJ_PAGE		;SET CMOS PAGE CORRECTLY

	MOVI	FACTORY_TABLE,A1	;ROM
	MOVI	ADJUSTORG,A7		;CMOS
	MOVI	N_ADJUSTS,A2		;NUMBER OF ADJUSTMENTS ALLOCATED

FACS1
	MOVE	*A1+,A0			;FETCH A ROM LONG WORD
	ZEXT	A0
	CALLA	WC_LONGI		;WRITE THE WORD TO CMOS
	DSJS	A2,FACS1		;WRITE 1 LONG WORD PER ADJUST
fs20
;	.if	YUNIT
;	move	@SWITCH+>30,a1
;	btst	6,a1
;	jrnz	fs80
;	not	a1
;	sll	32-5,a1
;	srl	32-5-3,a1		;*8
;	cmpi	(dctend-dipcoinage_t),a1
;	jrhs	fs50			;Illegal setting?
;	addi	dipcoinage_t,a1
;	movb	*a1,a1
;	movk	ADJPRICE,a0		;Master priceing
;	callr	PUT_ADJ
;fs50
;	movk	ADJFREPL,a0		;Free play
;	clr	a1			;Off
;	callr	PUT_ADJ
;fs80
;	.endif

	callr	LD_CTAB			;EXPAND THE CSELCT VALUE
	callr	F_ADC_S			;MAKE THE CHECKSUM CORRECT.

	move	*sp+,a0
	subk	1,a0
	jreq	fsx			;Only coinage?

*	NOW STORE THE GAME NAME AND REVISION INFO

	MOVI	NAME_REV,A7		;POINT AT CMOS NAME STORAGE
	MOVI	ROM_NAME,A1		;POINT AT OUR VERSION
	MOVI	NAME_REV_SIZE,A2	;MAXIMUM NAME SIZE

NEXT_LETTER
	MOVB	*A1,A0			;FETCH A BYTE
	CALLA	WC_BYTEI		;WRITE IT TO CMOS
	ADDK	BYTE_SIZE,A1		;KICK SOURCE POINTER
	move	a0,a0
	jrz	fsx			;End?
	DSJS	A2,NEXT_LETTER
	
fsx	PULL	a1,a2,a7
	rets

;dipcoinage_t
;	.byte	1,2,3, 10,11,12, 16,17,18, 29, 32, 33,34,35, 37
;	.byte	39, 41,42, 43, 45,46, 49, 50, 52, 53, 54, 55
;dctend
	.even

**************************************************************************
*
*	SWITCH_FOR_JUMPER
*
*	THIS IS CALLED OUT OF THE FACTORY SETTING SEQUENCE.
*	IT CHECKS FOR JUMPER COMBINATIONS INDICATING
*	GERMAN OR FRENCH GAMES.
*
*	THE JUMPERS ARE CONNECTED AS FOLLOWS:
*
*	GERMAN JUMPER = BIT 15 OF "COINS"
*	FRENCH JUMPER = BIT 14 OF "COINS"
*
*	IF BOTH JUMPERS ARE IN, OR BOTH ARE MISSING, THEN
*	ITS U.S. DEFAULT....LEAVE EVERYTHING ALONE.
*
*	IF GERMAN IS MISSING (READ AS A 1) THEN USE
*	GERMAN 1 COINAGE.
*
*	IF FRENCH IS MISSING THEN USE FRENCH 1 COINAGE.
*
**************************************************************************
;SWITCH_FOR_JUMPER
;	 MMTM	 SP,A0
;	 MOVE	 @COINS,A0		;GET THE 16 BITS
;	 ANDI	 JUMPERS,A0		;JUST KEEP THE BITS
;	 JRZ	 USA			;BOTH ARE IN...US!
;
;	 CMPI	 JUMPERS,A0		;ARE BOTH MISSING?
;	 JRZ	 USA			;YEP....US.
;
;	 CMPI	 GERMAN_BIT,A0		;IS JUST THE GERMAN MISSING?
;	 JRNZ	 NOGERM 		;NOPE
;
;	 CALLR	 DO_GERMAN		;DO THE GERMAN STUFF
;	 JRUC	 SFJX			;AND EXIT
;*
;*	 MUST BE FRENCH
;*
;NOGERM
;	CALLR	DO_FRENCH		;IF IT IS NOT POSSIBLE....DO IT.
;USA
;SFJX
;	MMFM	SP,A0
;	RETS
;
;DO_FRENCH
;	 MMTM	 SP,A0,A1
;	 MOVK	 ADJPRICE,A0		;AS MASTER PRICER.
;	 MOVI	 F1SEL,A1		;USE FRENCH SELECTOR
;	 CALLA	 PUT_ADJ
;	MMFM	SP,A0,A1
;	RETS
;
;DO_GERMAN
;	 MMTM	 SP,A0,A1
;	 MOVK	 ADJPRICE,A0		;AS MASTER PRICER.
;	 MOVI	 G1SEL,A1		;USE GERMAN SELECTOR
;	 CALLA	 PUT_ADJ
;
;	 MOVK	 ADJDIFF,A0
;	 MOVI	 1,A1			;DIFFICULTY 1 FOR GERMANS
;	 CALLA	 PUT_ADJ
;
;	 MOVK	 ADJBUYIN,A0
;	 MOVI	 1,A1			;EASY BUY-IN FOR GERMANS
;	 CALLA	 PUT_ADJ
;
;	MMFM	SP,A0,A1
;	RETS

**************************************************************************
*
*	LD_CTAB
*
*	THIS IS CALLED TO STORE THE CSELCT VALUES FOR
*	THE COIN SELECTOR STORED AS ADJPRICE.
*
**************************************************************************
LD_CTAB
	mmtm	sp,a0,a6,a1

	calla	GET_CSPT		;A6=CSELCT table

;{
 .IF 0
	movk	1,a1
	move	*a6(16*4),a0
	jrnn	lct5			;Normal 1 credit to start?
	movk	2,a1
lct5	movk	ADJCSTRT,a0
	callr	PUT_ADJ
	movk	1,a1
	movk	ADJCCONT,a0
	callr	PUT_ADJ

	movk	ADJC1,a0		;1st one to store
lct8	move	*a6+,a1			;Get word
	abs	a1
	callr	PUT_ADJ 		;Write this one to memory
	addk	1,a0
	cmpi	ADJCX,a0
	jrls	lct8

 .ENDIF

;}

	movi	ADJLMULT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJCMULT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJRMULT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJXMULT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJDBVMULT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJCUNIT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJBUNIT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJMUNIT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJCSTRT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJCCONT,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJCDIV,a0
	move	*a6+,a1
	calla	PUT_ADJ

	movi	ADJFRAC,a0
	move	*a6+,a1
	calla	PUT_ADJ

	PUSH	A6
	MOVI	ADJLTOTMULT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJCTOTMULT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJRTOTMULT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJXTOTMULT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	MOVI	ADJBTOTMULT,A0
	MOVE	*A6+,A1,W
	CALLA	PUT_ADJ
	PULL	A6

	movk	ADJVIRGIN,a0		;THIS SAYS 1ST 8 UNTOUCHED.
	movk	1,a1
	callr	PUT_ADJ

	movk	ADJ1ST6,a0		;THIS SAYS 1ST 6 UNTOUCHED.
	movk	1,a1
	callr	PUT_ADJ 		;DONE!

	mmfm	sp,a0,a6,a1
	rets

**************************************************************************
*
* CC_COIN
*	MMTM	SP,A7
*	CALLR	COIN_PAG
*	MOVI	HSR_C,A7
*	CALLA	RC_LONG		;GET THE TABLE COUNTER
*	JRZ	CCC_X		;ITS DOWN
*	DEC	A0		;1 LESS
*	CALLA	WC_LONG
* CCC_X	MMFM	SP,A7
*	RETS
*
**************************************************************************

**************************************************************************
*
*	L_MESS
*
*	A8 POINTS AT MESS_MAC FOLLOWED BY MESSAGE TEXT.
*	POP ALL REGGIES LEAVING A8 POINTING AT TEXT.
*	AND JUMP TO THE TEXT PROCESSOR!
*
*	THE MMFM POPS THE ROUTINE TO CALL INTO A1.
*
*	YOU ***MUST*** USE JSRP TO GET HERE.  WE JUMP TO
*	THE STRING ROUTINE WHICH WILL RETP BACK TO THE CALLER!
*
**************************************************************************
L_MESS_LOOP
	addk	BYTE_SIZE,a8		;PUSH BEYOND THIS BYTE
L_MESS	addk	>f,a8			;Round up word
	srl	4,a8
	sll	4,a8

	MMFM	A8,A1,A6,A9,A10,A11	;LOAD UP REGGIES FROM A8.
	CLR	A0			;NEVER SLEEP!

	MOVI	L_RET,A7
	MOVE	A7,-*A12,L	;PUSH RET ADDR
	JUMP	A1		;JUMP TO THE ROUTINE.
L_RET	MOVB	*A8,A0		;CHECK NEXT BYTE 0=DONE...1=MORE.
	JRNZ	L_MESS_LOOP
	RETP
	
**************************************************************************
*
*	LM_SETUP
*
*	THIS IS CALLED TO SETUP THE WORLD FOR A STRING
*	OPERATION, BUT NOT PHYSICALLY MAKE THE CALL.
*
*	THIS ALLOWS TWEAKING OF REGGIES BEFORE THE CALL.
*
*	LM_FINIS
*
*	THIS IS CALLED ONCE THE MODIFICATIONS ARE MADE!
*
**************************************************************************
LM_SETUP
	MMFM	A8,A1,A6,A9,A10,A11	  ;LOAD UP REGGIES FROM A8.
	CLR	A0			  ;DON'T SLEEP
	RETS

LM_FINIS
	JUMP	A1				;THIS RUNS ROUTINE AND

**************************************************************************
*
*	GET_CSTR
*
*	HERE WE FORM THE CREDITS STRING AND
*	RETURN IT IN THE STRING BUFFER.
*	WE RETURN A8 POINTING AT THIS BUFFER.
*
*	WE ALSO PUT APPROPRIATE FRACTION ON THE
*	END IF ADJUSTED ACCORDINGLY.
*
**************************************************************************
GET_CSTR
	MOVK	ADJFREPL,A0		;ARE WE IN FREE PLAY?
	CALLA	GET_ADJ
	JRZ	NOT_FREE

	MOVI	MESS_FREEP,A8		;RETURN POINTING AT FREE PLAY MESSAGE
	JRUC	GET_CX

NOT_FREE
	CALLA	STR_OBJ 		;ALLOCATE AN OBJECT PLEASE
	JRC	NO_SOBJ 		;NONE TO USE!
	
	MOVI	MESS_CREDITS,A8 	;POINT AT TEXT PART
	CALLA	STRCAT			;BUILD THIS IN.
	CALLR	CRED_P
	MOVE	A0,A10			;SAVE CREDITS
	CALLR	CAT_A0
*
*	NOW WE NEED TO SEE IF WE SHOULD ADD A FRACTION.
*
	MOVK	ADJFRAC,A0
	CALLA	GET_ADJ 		;CHECK THE ADJUSTMENT
	JRZ	NSFRAC			;DON'T SHOW IT!
*
*	ADD ANY FRACTION WE HAVE.
*
	CALLR	COIN_PAG		;PUT US ON COIN PAGE
	CALLR	GET_CUNITS		;A0 HAS CUNITS
	CALLR	DEF_PAGE		;FLIP CMOS AWAY
	MOVE	A0,A0			;ZERO?
	JRZ	NSFRAC			;THEN NO FRACTION.
*
*	WE HAVE A FRACTION...WERE THE CREDITS ZERO?
*
	MOVE	A10,A10 		;WE SAVED EM IN A10
	JRNZ	NZM			;NON ZERO MANTISSA

	MOVE	A7,A8			;WALK DOWN STRING LOOKING FOR THE "ZERO"
KILL_Z
	MOVB	*A8,A1			;GET A BYTE
	JRZ	NZM			;COULDN'T FIND IT....GO ON.

	CMPI	LET_0,A1		;IS THIS THE ZERO?
	JRZ	GOT_ZERO

	ADDK	BYTE_SIZE,A8
	JRUC	KILL_Z

GOT_ZERO
	CLR	A1
	MOVB	A1,*A8			;KILL THE ZERO

NZM
	MOVI	MESS_2SPACE,A8		;SPACE BET. MANTISSA AND DENMO
	CALLA	STRCAT

NOT_ZM
	CALLR	CAT_A0			;ADD A0 ONTO FRACTION

	MOVI	MESS_SLASH,A8
	CALLA	STRCAT			;ADD SLASH

	MOVK	ADJCUNIT,A0		;UNITS REQUIRED FOR CREDIT
	CALLA	GET_ADJ
	CALLR	CAT_A0			;DENOMINATOR

NSFRAC
	MOVE	A7,A8			;MOVE "OBJECT" TO A8
	MOVI	STRNGRAM,A7		;POINT AT STRING RAM
	CLR	A0
	MOVB	A0,*A7			;STRINGRAM IS NULL
	CALLA	STRCAT			;COPY THE STRING OUT OF OBJECT BLOCK
	MOVE	A7,A8
	CALLA	STR_FREE		;AND FREE UP THE OBJECT BLOCK

GET_CX
	CLRC				;RETURN OK
GET_CXX
	RETS
*
*	 NO OBJECTS AVAILABLE TO FORM STRING
*
NO_SOBJ
	MOVI	MESS_NULL,A8
	SETC
	JRUC	GET_CXX 		;RETURN BLANK STRING!

**************************************************************************
*
*	CAT_A0
*
*	A0 HAS A BINARY NUMBER.  TURN INTO DECIMAL STRING
*	AND CONCATONATE TO THE STRING WE'RE BUILDING IN	A7.								 *
*
**************************************************************************
CAT_A0
	PUSH	a8
	MOVE	A0,A8			;CREDIT COUNT IN A8
	CALLA	HEXTOASC		;STRING
	CALLA	STRCAT			;NOW WE HAVE WHOLE NUMBER.
	MMFM	SP,A8
	RETS

**************************************************************************
*
*	ADD_PROMPT
*
*	THIS IS CALLED ON THE CREDITS PAGE TO ADD A WORD OF
*	WISDOM BELOW THE CREDITS MESSAGE. IT PICKS OUT THE
*	CORRECT MESSAGES AND BLINKS THEM.
*
**************************************************************************
ADD_PROMPT
	MOVI	PROMPT_PROC,A7
	CALLA	P_FORK			;START UP ANOTHER W/ SAME ID TO FLASH!
	RETP

PROMPT_PROC
	MOVK	ADJFREPL,A0
	CALLA	GET_ADJ
	JRNZ	rf4			;ALWAYS READY FOR 4 PLAYERS!

	CALLR	CRED_P
	JRZ	PP1

	MOVE	A0,A1			;PUT CREDITS IN A1
	MOVK	ADJCSTRT,A0		;GET AMOUNT NEEDED TO START.
	CALLA	GET_ADJ
	CMP	A0,A1			;ARE THERE ENOUGH TO START?
	JRLO	PP1			;NOPE...."INSERT COIN"
*
*	WE HAVE ENOUGH TO START FOR 1....HOW ABOUT 2?
*
	jrz	PP2
	move	a0,a2
	add	a2,a2
	cmp	a1,a2
	jrz	RF2
	jrhi	PP2
	add	a0,a2
	cmp	a1,a2
	jrhi	RF2
	add	a0,a2
	cmp	a1,a2
	jrhi	rf3


*
*	>1 = READY FOR 2 PLAYERS.  PRESS START.
*
rf4
	MOVI	MESS_READY_4,A1
	JRUC	RED_1
rf3
	MOVI	MESS_READY_3,A1
	JRUC	RED_1
RF2
	MOVI	MESS_READY_2,A1
	JRUC	RED_1

PP1
	MOVI	MESS_INS_COIN,A0
	CLR	A1
	JRUC	RED_2

PP2
	MOVI	MESS_READY_1,A1
RED_1
	MOVI	MESS_PRESS_START,A0
RED_2
	MOVE	A0,*A13(PDATA),L		;HOLD MESSAGES
	MOVE	A1,*A13(PDATA+LONG_SIZE),L

BLINK_LOOP
	MOVE	*A13(PDATA),A8,L		;FIRST MESSAGE
	JSRP	L_MESS
	MOVE	*A13(PDATA+LONG_SIZE),A8,L	;2ND MESSAGE
	JRZ	BL1				;NOT HOME!

	JSRP	L_MESS

BL1
	SLEEPK	10H

	MOVE	*A13(PDATA),A8,L
	CALLR	LM_SETUP
	CLR	A6			;BLACK
	JSRP	LM_FINIS

BL2
	SLEEPK	10H
	JRUC	BLINK_LOOP

**************************************************************************
*
*	MESSAGE SECTION
*
**************************************************************************
ROM_NAME
;Current checked string length (before ending 0) = NAME_REV_SIZE = 30

	.byte	"NBA HANGTIME - VER L1.0 4/9/96",0

	.even

FACTORY_TABLE

	.word	0	;ADJNULL	0
	.word	1	;ADJPRICE	1	;MASTER PRICING
	.word	1	;ADJLMULT	2
	.word	4	;ADJCMULT	3
	.word	1	;ADJRMULT	4
	.word	0	;ADJXMULT	5
	.word	0	;ADJDBVMULT	6	;DOLLR BILL VALIDATOR
	.word	1	;ADJCUNIT	7
	.word	0	;ADJBUNIT	8
	.word	0	;ADJMUNIT	9
	.word	4	;ADJCDIV	10
	.word	1	;ADJFRAC	11	;NON ZERO SAYS SHOW HALF CREDITS
	.word	2	;ADJCSTRT	12	;CREDITS REQUIRED TO START
	.word	2	;ADJCCONT	13	;CREDITS REQUIRED TO CONTINUE

	.word	3	;ADJDIFF	14	;Difficulty

	.word	0	;		15
	.word	0	;		16
	.word	1	;ADJMUSIC	17	;attract mode music = off
	.word	50	;ADJMAXC	18	;MAXIMUM CREDITS
	.word	0	;ADJFREPL	19	;NON-ZERO MEANS FREE PLAY
	.word	1	;ADJVIRGIN	20	;NON-ZERO MEANS 1ST 8 OF COIN ADJUST BLOCK UNTOUCHED
	.word	8	;ADJFULLG	21	;credits needed to purchase full game (4-16)
	.word	1	;ADJ1ST6	22	;NON-ZERO MEANS 1ST 6 UNTOUCHED.
	.word	0	;ADJNOCPAG	23
	.word	1	;ADJCNTR	24	;COIN COUNTER MODE
	.word	3	;ADJSPEED	25	;game timer speed (1-5)
	.word	1	;ADJHEADSZ	26	;player head sizes (1-2)
	.word	1	;ADJWINMODE	27	;(winners stays free)
;	.word	3	;ADJWINMODE	27	;(winner stays free)
	.word	0	;ADJCOMPASS	28	;computer assistance (0=on)
	.word	1	;ADJTOURNEY	29	;Tournament mode (0=on)
	.word	30	;ADJVOLUME	30	;sound volume (4-255)
	.word	30	;ADJAVOLUME	30	;sound volume (4-255)
	.word	0	;ADJTRIVIA
	.WORD	0	;CUSTOM TOTALIZER  31
	.WORD	1	;TOTALIZER CHUTE 1  32
	.WORD	1	;TOTALIZER CHUTE 2  33
	.WORD	1	;TOTALIZER CHUTE 3  34
	.WORD	1	;TOTALIZER CHUTE 4  35
	.WORD	1	;TOTALIZER DBV	    36

**
	.if 0
	.word	0	;ADJ_UNUSED		0
	.word	2	;ADJ_PRICING		1  ;MASTER PRICING
	.word	1	;ADJ_LEFT_MULT		2
	.word	1	;ADJ_RIGHT_MULT		4
	.word	4	;ADJ_CENTER_MULT	3
	.word	0	;ADJ_EXTRA_MULT		5
	.word	1	;ADJ_UNITS_CREDIT	6
	.word	0	;ADJ_UNITS_BONUS	7
	.word	0	;ADJ_MIN_UNITS		8
	.word	4	;ADJCDIV		9  ;COINS PER DOLLAR
	.word	1	;SHOW FRACTIONS		10
	.word	1	;ADJ_START_CRED		11 ;CREDITS REQUIRED TO START
	.word	1	;ADJ_CONT_CRED		12 ;CREDITS REQUIRED TO CONTINUE
	.word	3	;ADJ_DIFFICULTY		13
	.word	5000	;ADJ_HSRESET		14
	.word	3	;ADJ_LIVES		15
	.word	0	;ADJ_AMODE_MUSIC	16
	.word	50	;MAXIMUM CREDITS	17
	.word	0	;FREE PLAY		18
	.word	1	;NON-ZERO MEANS COIN BLOCK (1ST 8) UNTOUCHED 19
	.word	0	;ZERO MEANS NORMAL GORE ... 1 = SOFTEN IT  20
	.word	1	;NON-ZERO MEANS 1ST 6 UNTOUCHED.		21
	.word	0	;NON-ZERO MEANS NO COIN-SPECIFIC MESSAGE ON COIN PAGE  21
	.word	1	;ADJCNTR  23   ADJUST MECH COIN COUNTER
	.endif

*	 A0 = SLEEP
*	 A1 = ROUTINE
*	 A6 = COLOR
*	 A8 = STRING POINTER
*	 A9 = SCREEN ADDRESS
*	 A10 = SPACING
*	 A11 = FONT
*	 A14 = FLAGS
*

MESS_CREDITS
	.byte	"CREDITS: ",0
	.even

*	 NORMAL CREDITS SETUP STRING
*
MESS_CNUM
	MESS_MAC  RD15FONT,SPACING20,CP_CX,135,ROBO_LF,STRCNRM,0
*
*	 "LOW" CREDITS SETUP STRING WHEN EXTRA ADVICE ON PRICING
*	 IS BEING ADDED.
*
MESS_LOWNUM
	MESS_MAC  RD15FONT,SPACING20,CP_CX,135,ROBO_LF,STRCNRM,0

MESS_FREEP
	.byte	"FREE  PLAY",0,0
	.even

MESS_READY_1
	MESS_MAC  RD15FONT,SPACING20,CP_CX,155,ROBO_YELLOW,STRCNRM,0
	.byte	"READY FOR  1  PLAYER",0,0
	.even

MESS_READY_2
	MESS_MAC  RD15FONT,SPACING20,CP_CX,155,ROBO_YELLOW,STRCNRM,0
	.byte	"READY FOR  1 - 2  PLAYERS",0,0
	.even

MESS_READY_3
	MESS_MAC  RD15FONT,SPACING20,CP_CX,155,ROBO_YELLOW,STRCNRM,0
	.byte	"READY FOR  1 - 3  PLAYERS",0,0
	.even

MESS_READY_4
	MESS_MAC  RD15FONT,SPACING20,CP_CX,155,ROBO_YELLOW,STRCNRM,0
	.byte	"READY FOR  1 - 4  PLAYERS",0,0
	.even

MESS_INS_COIN
	 MESS_MAC  RD15FONT,SPACING20,CP_CX,175,ROBO_YELLOW,STRCNRM,0
	.byte	"INSERT COINS",0,0
	.even

MESS_PRESS_START
	MESS_MAC  RD15FONT,SPACING20,CP_CX,175,ROBO_YELLOW,STRCNRM,0
	.byte	"PRESS START",0,0
	.even

 .if 0

**************************************************************************
*
*	DUMPING SOFTWARE
*
**************************************************************************
DUMP_FS
	CALLR	DUMP_PAGE
	CLR	A0
	MOVI	DUMP_PTR,A7
	CALLA	WC_WORD 		;SET NUMBER OF DUMPS TO ZERO
	RETS

**************************************************************************
*
*	ADD_DUMP
*
*	THIS IS CALLED TO RECORD A DUMP. A0 THROUGH A9 ARE
*	RECORDED IN MEMORY.
*
**************************************************************************
DUMP_SIZE	 .equ	 10*C_LONG_SIZE		;9 LONG WORDS.
DUMP_LAST	 .equ	 CMOS+>8000-DUMP_SIZE	;Let em use the whole page!
MAX_DUMP	 .equ	 8			;DON'T HOLD MORE THAN 12/PAGE

ADD_DUMP
	MMTM	SP,B0,B1,B2
	MMTM	SP,A0,A1,A7
	CALLR	DUMP_PAGE		;SET CMOS PAGE CORRECTLY.
	MOVE	A0,B0
	MOVE	A7,B2			;SAVE THESE!
	MOVE	A1,B1

	MOVI	DUMP_PTR,A7
	CALLA	RC_WORD 		;GET THE INDICATOR OF HOW MANY.
	MOVI	DUMP_SIZE,A1
	MPYU	A0,A1			;THIS IS OFFSET INTO CMOS FOR THIS ENTRY!

	ADDI	DUMP_DATA,A1		;NOW A1 POINTS WHERE WE'RE PUTTING THE DATA!
	CMPI	DUMP_LAST,A1		;ARE WE TOO FAR FOR ANOTHER?
	JRHS	NO_DUMP 		;YEP....SKIP IT

	INC	A0			;1 MORE OUT THERE!
	CALLA	WC_WORD 		;CHALK IT!

	MOVE	A1,A7			;THIS IS POINTER TO STORE DATA.
	MOVE	B0,A0			;THIS IS A0
	CALLA	WC_LONGI
	MOVE	B1,A0			;THIS IS A1
	CALLA	WC_LONGI
	MOVE	A2,A0			;THIS IS A2
	CALLA	WC_LONGI
	MOVE	A3,A0			;THIS IS A3
	CALLA	WC_LONGI
	MOVE	A4,A0			;THIS IS A4
	CALLA	WC_LONGI
	MOVE	A5,A0			;THIS IS A5
	CALLA	WC_LONGI
	MOVE	A6,A0			;THIS IS A6
	CALLA	WC_LONGI
	MOVE	B2,A0			;THIS IS A7
	CALLA	WC_LONGI
	MOVE	A8,A0			;THIS IS A8
	CALLA	WC_LONGI
	MOVE	A9,A0			;THIS IS A9
	CALLA	WC_LONGI
NO_DUMP
	MMFM	SP,A0,A1,A7
	MMFM	SP,B0,B1,B2
	RETS

DUMP_PAGE
	PUSH	a1
	MOVI	DUMP_SELECT,A1		;THIS IS DUMP PAGE
	CALLA	SET_PAGE		;SET IT PLEASE
	MMFM	SP,A1
	RETS

DISPDUMP
	CALLR	DUMP_PAGE
	MOVI	DUMP_PTR,A7
	CALLA	RC_WORD 		;GET THE INDICATOR OF HOW MANY.
	JRZ	NOTHIN_TO_DUMP

	CLR	A9			;THIS IS CURRENT ONE
	MOVE	A0,A8			;THIS IS THE LAST ONE TO DO

DO_ANOTHER_DPAGE
	CALLA	CLR_SCRN		;CLEAR SCREEN
	CALLR	DUMP_PAGE
	movk	20,a10			;This is y coordiante of current one!
	MOVI	MAX_DUMP,A11		;THIS IS MAX NUMBER PER PAGE.

DO_ANOTHER_DUMP
	JSRP	DO_DUMP
	addk	30,a10			;Kick y up
	INC	A9			;KICK TO NEXT DUMP
	CMP	A8,A9			;UNTIL THEY'RE ALL DONE!
	JRHS	DUMP_DONE		;WE'RE NOT ALL DONE YET!

	DSJS	A11,DO_ANOTHER_DUMP	;NOT FOR THIS PAGE EITHER!

	JSRP	WAIT_MUT		;WATCH FOR STICKS!
	JRUC	DO_ANOTHER_DPAGE

 .endif

**************************************************************************
*
*	WAIT_MUT
*
*	THIS IS LIKE "WAIT_BUT"....WAIT FOR ANY BUTTON EXCEPT
*	THAT IT WILL CLEAR OUT THE DUMPS IF BOTH STICKS ARE PUSHED
*	DOWN.
*
**************************************************************************
WAIT_MUT
	CALLA	FORM_SWS	;1ST STATE DOESN'T COUNT
*
*	RETURN CURRENT STATE IN A0..PREVIOUS STATE IN A1.
*
WB1
	SLEEPK	1

	CALLA	FORM_SWS
	MOVE	A0,A2		
	ANDI	2002H,A2
	CMPI	2002H,A2
	JRNZ	WB2			;NOT "CLEAR"

;	.REF	GETSPEAK
;	CALLA	GETSPEAK

;	SOUND1	COINSND
;	MOVK	10,A0
;	MOVE	A0,@BTIME		;RESTUFF BUYIN TIMER
;	callr	conttimers_set


;	CALLR	DUMP_FS 		;CLEAR OUT THE DUMPS!
;	CALLR	CLR_DUMP_AUD
	JRUC	WB1

getcoin
;	SOUND1	coin_snd
	movi	coin_snd,a0
	jauc	snd_play1


WB2	NOT	A1			;LAST = 0 AND NOW = 1 MEANS EDGE!
	AND	A1,A0			;1'S WHERE WE HAVE POSITIVE EDGE.
	ANDI	BUTTONS,A0		;IS IT A BUTTON?
	JRZ	WB1

;DO NEW SOUND CALL HERE

	SOUND1	beep2_snd
	RETP


DUMP_DONE
	RETP				;AND RETURN TO CALLER!

NOTHIN_TO_DUMP
	CALLA	CLR_SCRN		;PRINT SOMETHING PLEASE
	MOVI	MESS_NODUMP,A8
	JSRP	L_MESS
	RETP

**************************************************************************
* DO_DUMP
* A9=DUMP NUMBER TO DO
* A10=Y POSITION.

 .if 0
DO_DUMP
	MMTM	A12,A8,A9,A10,A11

	MOVI	DUMP_SIZE,A7
	MPYU	A9,A7			;THIS IS OFFSET INTO CMOS FOR THIS ENTRY!

	ADDI	DUMP_DATA,A7		;NOW A1 POINTS WHERE WE'RE PUTTING THE DATA!
*
*	Y IS IN A10
*
	MOVE	A10,A3			;Y IN A3
	MOVK	30,A2			;STORE X IN A2
	MOVK	10,A5			;NUMBER OF WORDS TO DUMP
NEXT_ELE
	CALLA	RC_LONGI		;GET A WORD
	MOVE	A0,A4			;HEX IN A4

	MOVE	A7,*A13(PDATA),L
	MOVE	A2,*A13(PDATA+LONG_SIZE),L
	MOVE	A3,*A13(PDATA+(2*LONG_SIZE)),L
	MOVE	A5,*A13(PDATA+(3*LONG_SIZE)),L

	JSRP	WRITE_HEX		;WRITE IT OUT.....A0 = DATA
*						A10 = Y
*						A11 = X
	MOVE	*A13(PDATA),A7,L
	MOVE	*A13(PDATA+LONG_SIZE),A2,L
	MOVE	*A13(PDATA+(2*LONG_SIZE)),A3,L
	MOVE	*A13(PDATA+(3*LONG_SIZE)),A5,L

	ADDI	48H,A2

	CMPI	6,A5			;WHEN WE'RE DOWN TO 4 SKIP TO NEXT LINE
	JRNZ	NO_SKIP_NOW

	ADDK	12,A3			;PUSH TO 2ND LINE
	MOVI	33,A2			;RE-MARGIN OVER. (30)

NO_SKIP_NOW
	DSJ	A5,NEXT_ELE

	MMFM	A12,A8,A9,A10,A11
	RETP

 .endif

**************************************************************************
*
*	WRITE_HEX
*
*	A4  = DATA
*	A3  = Y
*	A2  = X
*
**************************************************************************
WRITE_HEX
	MOVI	MESS_DUMP,A8
	CALLR	LM_SETUP		;SETUP FOR A DUMP!
	MOVE	A3,A9			;MOVE Y DOWN
	SLL	16,A9			;SHIFT Y INTO PLACE
	ADD	A2,A9			;ADD IN X

	MOVE	A4,A8
	CLR	A3			;NO COMMAS!
	CALLR	HTOHXASC		;CONVERT PLEASE!
	JSRP	LM_FINIS
	RETP

**************************************************************************
* HTOHXASC - CONVERTS A 32 BIT HEX # TO AN ASCII STRING TERMINATED BY 0
* A3=NON ZERO IF COMMAS ARE TO BE ADDED!
* A8=HEX #
* Rets:
* A8=PTR TO THE STRING

HTOHXASC
	MMTM	SP,A1,A2,A9
	CLR	A1
	CLR	A2			;COMMA COUNT
	MOVE	A1,-*SP			;HERE'S THE NULL TERMINATOR
	MOVK	16,A1			;DIVISOR FOR HEX
	MOVE	A8,A9
HEXTASC2
	CLR	A8
	DIVU	A1,A8
	ADDI	'0',A9			;MAKE THE REMAINDER ASCII
	CMPI	'9',A9			;IS IT IN A-F RANGE?
	JRLS	HHH1
	ADDI	7,A9			;MAKE ALPHA!
HHH1
	MOVE	A9,-*SP			;SAVE HERE
	MOVE	A8,A9
	JRZ	HEXTASC3		;BR = DONE!
	INC	A2
	CMPI	3,A2			;COMMA CHECK	
	JRLO	HEXTASC2		;BR = NO COMMA
*
*	 SEE IF WE'RE DOING COMMAS
*
	MOVE	A3,A3			;COMMAS?
	JRZ	HEXTASC2		;NOPE....IGNORE!

	MOVI	',',A2
	MOVE	A2,-*SP			;STUFF A COMMA
	CLR	A2
	JRUC	HEXTASC2
HEXTASC3
	MOVI	STRNGRAM,A1		;STORE HERE FOR BLOW OUT	
	MOVE	A1,A8

HEXTASC4
	MOVE	*SP+,A9
	MOVB	A9,*A1
	ADDK	8,A1
	MOVE	A9,A9
	JRNZ	HEXTASC4
	MMFM	SP,A1,A2,A9
	RETS

**************************************************************************
* STRCAT - THIS IS CALLED TO CONCATONATE 2 STRINGS.
* A7 <--- <A7><A8>
* THAT IS.......CONCATONATE A8 ONTO THE END OF A7.

STRCAT
	MMTM	SP,A7,A0,A8
STRC2
	MOVB	*A7,A0		;WALK DOWN A7 TO ITS ZERO.
	JRZ	STRC1		;WE'RE THERE!

	ADDK	BYTE_SIZE,A7	;KICK TO NEXT BYTE
	JRUC	STRC2
*
*	NOW A7 POINTS AT ITS ZERO.
*
STRC1
	MOVB	*A8,A0		;GET A BYTE FROM 2ND STRING
	MOVB	A0,*A7		;ADD THIS TO 1ST STRING
	ADDK	BYTE_SIZE,A7
	ADDK	BYTE_SIZE,A8
	MOVE	A0,A0		;DID WE JUST MOVE TERMINATOR?
	JRNZ	STRC1		;NOPE...MOVE ANOTHER

	MMFM	SP,A7,A0,A8
	RETS

MESS_DUMP
	MESS_MAC RD7FONT,SPACING07,23,227,ROBO_WHITE,STRLNRM,0

MESS_NODUMP
	MESS_MAC RD15FONT,SPACING20,200,128,ROBO_ORANGE,STRCNRM,0
	.byte	"NOTHING HERE....PRESS ADVANCE!",0,0
	.even

MESS_SLASH
	.byte	"/",0
	.even

MESS_2SPACE	.byte	"  "
MESS_NULL	.byte	0
		.even

SETUP_1_OF_3
	 MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_13,ROBO_LASER,STRCNRM,0
SETUP_2_OF_3
	 MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_23,ROBO_LASER,STRCNRM,0
SETUP_3_OF_3
	 MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_33,ROBO_LASER,STRCNRM,0

SETUP_1_OF_2
	 MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_12,ROBO_LASER,STRCNRM,0

SETUP_2_OF_2
	 MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0

SETUP_1_OF_1
	 MESS_MAC  RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LASER,STRCNRM,0

dollar_mes
	PRINT_STR	bast10_ascii,5,0,200,53,BAST_R_P,print_string_C2
	.byte	"THIS GAME ACCEPTS DOLLAR BILLS",0,0
	.even

CPYR_MES
	PRINT_STR	bast8_ascii,5,0,200,240,BAST_Y_P,print_string_C2
	.byte	" COPYRIGHT 1993 MIDWAY MANUFACTURING COMPANY",0,0
	.even

	MESS_MAC RD7FONT,SPACING07,CP_CX,240,ROBO_WHITE,STRCNRM,0
	.byte	" COPYRIGHT 1993 MIDWAY MANUFACTURING COMPANY",0,0
	.even


******************************************************************************

	.end
