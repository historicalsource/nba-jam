**************************************************************
*
* Owner:	none
*
* Software:		LARRY DEMAR and DR. J
* Initiated:		?
*
* Modified:		Shawn Liptak, 11/1/91	-Total carnage
* 			Shawn Liptak, 1/20/92	-Coinage from T2, Dipswitch
* 			Shawn Liptak, 1/24/92	-Coinage corrections
* 			Shawn Liptak, 3/4/92	-Basketball mods
* 			Shawn Liptak, 10/2/92	-TUNIT sound mods
*	 		GEORGE PETRO, 1/17/93	-NBA JAM
*	 		Jeff Johnson, 4/10/95	-NBA 2 (for wwf unit)
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/24/93 18:27
*.Last mod - 4/11/95 10:30am
**************************************************************
	.file	"menu.asm"
	.title	"test menus"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"game.equ"
	.include	"link.equ"
	.include	"menu.equ"
	.include	"macros.hdr"		;Macros

	.text

;	 IN THIS MODULE

	.DEF	MEN_MAIN,GET_CSPT
	.DEF	MESS_FAC
	.DEF	ANY_BUT,MEN_YN
	.DEF	STR_OBJ
	.DEF	STR_FREE
	.DEF	CKPROMPT
	.DEF	GO_DIAG		;ROUTINE FOR DIAGNOSTIC MENU
	.DEF	RTR_LEV,ROM_LEV
	.DEF	MESS_MM
	.DEF	CS_ENTS		;NUMBER OF HIGHEST IN COIN TABLE
	.DEF	TWO_TS,TWO_TP
	.DEF	FAC_STUF
	.DEF	BUILD_ST
	.DEF	SCODE		;SYNTH CODE CURRENTLY BEING MADE
	.DEF	DCODE		;DIG CODE CURRENTLY BEING MADE
	.DEF	HID_P
	.DEF	SNDTST
	.DEF	USA_1, USA_2, USA_3, USA_4, USA_ELECTITLE
	.DEF	GERMAN_1, GERMAN_2, GERMAN_3, GERMAN_4, GERMAN_ELECTITLE
	.DEF	FRENCH_1, FRENCH_2, FRENCH_3, FRENCH_4, FRENCH_ELECTITLE
	.DEF	DIPCOINTAB

;	IN SOUNDS.ASM
	.ref	snd_reset, QSNDRST

;	 IN TEST.ASM

	.ref	get_but_val_down,get_stick_val_cur,dpageflip_off

	.ref	SNDSND,nosounds,set_volume
	.ref	MENU_TOP

	.ref	copy_rom_string
	.ref	concat_string,concat_rom_string
	.ref	dec_to_asc
	.ref	_coin_addr
	.ref	_switch_addr
	.ref	_switch2_addr
	.ref	_sound_addr
	.ref	_soundirq_addr
	.ref	_coin_counter_addr
	.ref	_set_time
	.ref	message_buffer
	.ref	_clk_rd
	.ref	_get_time
	.ref	_aquire_time
	.ref	RECTANGLE
	.ref	COL_INST
	.ref	GETSTICK
	.ref	ST_STICK
	.ref	CLR_MAIN
	.ref	ADJ_INST
	.ref	CADJ_BOX
	.ref	CLR_CUR

	.ref	fudge_switches,fudge_switches2
	.ref	fswitches_cur,fswitches_last,fswitches_down
	.REF	WDOGDIS,pal_getf
	.REF	GEN_MENU,B_MENU
	.REF	L_MESS,TOP_BOX
	.REF	GET_AUD
	.REF	LM_FINIS
	.REF	BAD_AUD
	.REF	MAIN_RET
	.REF	AREUSURE
	.REF	F_TITLE
	.REF	ST_STICK
	.REF	GETSTICK
	.REF	FAC_SET
	.REF	SUR_MESS
	.REF	SURE_BOX
	.REF	GET_FAC
	.REF	WAIT_BUT
	.REF	DIGSRT
	.REF	DIAG_EX
;	.REF	GET_ADV
	.REF	STD_BORD
	.REF	SND_MADE
	.REF	NO_CLEAR
	.REF	LAST_BUT
	.REF	G_BORDER
	.ref	opmsg_main

;	IN AUDIT.ASM

	.REF LM_SETUP
;	.REF ROM_NAME
	.REF GET_ADJ
	.REF STRCAT
;	.REF CLR_SUBS
	.REF NO_CREDS
	.REF CLR_AUDR
	.REF CLR_AUD
	.REF CAT_A0
	.REF CK_MAX
	.REF ADJ_PAGE
	.REF F_ADC_S
	.REF WC_BYTEI
	.REF RC_WORD
	.REF DEF_PAGE
	.REF WAIT_MUT
	.REF STORE_AUDIT

;	IN HSTD.ASM

	.REF	INIT_TB,FORM_ADC,WC_WORD,CMOS_VAL
	.REF	P_FORK,GET_HSC,INIT_HSR

;	IN ADJUST.ASM

	.REF	GO_ADJ


;	IN UTIL.ASM

	.ref	FILLAREA
	.ref	CLR_SCRN
	.ref	dpageflip_off

;	IN ATT.ASM

	.ref	amode_start

;DIAG STUFF

	.ref	show_player_records
	.ref	SWITCHTEST
	.REF	COL_BARS,CROSS_H,BURN_IN,STRNEW1

	.REF	RD15FONT,SCRCLR,display_init,STRCNRM,GAMSTATE
	.REF	STRNGRAM,BLNKAREA,STRLNRM,RD7FONT,HEXTOASC
	.REF	CLR_SCRN,STRRNRM
	.REF	WARMSET, DIAGCPUTEST

	.ref	_sound_addr
	.ref	_soundirq_addr
	.ref	_coin_counter_addr
	.ref	_switch_map_mode

	.BSS	FAC_FLAG,16		;FLAG SAYS CLEAR AUDITS AND HSTABLE
					;IF FACTORY SETTINGS SUCCEED.
	.BSS	SCODE,16		;SYNTH CODE LAST MADE!
	.BSS	DCODE,16		;DIG CODE LAST MADE!
	.BSS	TMPOBJ,32		;TEMPORARY OBJECT FROM STR_OBJ

	BSSX	octopus2,16

	.globl	_rtc_seconds, _rtc_day, _rtc_date, _rtc_month
	.globl	_rtc_minutes, _rtc_hours, _rtc_year
	.globl	_tseconds,_tminutes,_thours,_tday,_tdate,_tmonth,_tyear
	.globl	_serial_number,_month,_day,_year,_man_date

	.bss	_setup_mess,10*16	;Used for built messages
	.bss	_setup_mess_msg,8*40	;Used for built message strings

	.bss	_rtc_seconds,16		;These are used when SETTING the RTC
	.bss	_rtc_minutes,16
	.bss	_rtc_hours,16
	.bss	_rtc_day,16
	.bss	_rtc_date,16
	.bss	_rtc_month,16
	.bss	_rtc_year,16

	.bss	_last_seconds,16	;This is used when displaying the time

	.bss	_tseconds,16		;This is where the current time is
	.bss	_tminutes,16		;stored when the time data is read
	.bss	_thours,16		;from the PIC.
	.bss	_tday,16
	.bss	_tdate,16
	.bss	_tmonth,16
	.bss	_tyear,16
	.bss	_mytemp,32

	.bss	_serial_number,32	;Game Serial Number  (Hexidecimal)
	.bss	_man_date,32		;Date of manufacture (composite)
	.bss	_month,32	 	;Date of manufacture (month)
	.bss	_day,32		 	;Date of manufacture (date)
	.bss	_year,32	 	;Date of manufacture (year)

	.bss	_auto_update_save,32	;Save area for clock auto update


**************************************************************************
*									 *
*	   COIN TABLE							 *
*									 *
**************************************************************************
*
*	The coin table is made up of the normal entries from
*	the pinball system, as well as some new ones that
*	determine start and buy-in cost, and others that
*	aid in the determination of a "total collection".
*
*	Left Slot Multiplier		word
*	Center Slot Multiplier		word
*	Right Slot Multiplier		word
*	fourth slot Muliplier		word
*	bill validator Muliplier	word
*	Units for Credit		word
*	Units for Bonus			word
*	Minimum Units			word
*	Credits to start		word
*	Credits to Continue		word
*	Divisor in money calculation	word   0 means "OFF"
*
* --------------------------------------------------------------
* The above value get copied as adjustments (and are adjustable).
* In addition, the coin table contains help on how to arrive at
* the "Total Collection" for the coin audits.
* --------------------------------------------------------------
*
*	Count for each Left coin		word
*	Count for each Center coin		word
*	Count for each Right coin		word
*	Count for fourth coin			word
*	Count for DBV				word
*	Pointer to Leading text string		long
*	Pointer to Following text string	long
*
**************************************************************************
*
*	GET_CSPT
*
*	THIS IS CALLED TO RETURN IN A6 THE CURRENT
*	CSELCT LINE AS STORED IN THE ADJUSTMENT TABLE.
*
**************************************************************************
GET_CSPT
	PUSH	a0
	movk	ADJPRICE,a0
	CALLA	GET_ADJ 	;GET THE COIN SELECT NUMBER BEING USED.
	CALLR	CS_POINT
	PULL	a0
	RETS
	
**************************************************************************
* CS_POINT - Point at selected entry in the coinage select table
* A0=Offset #
* Rets: A6=*Coinage table
**************************************************************************
CS_POINT
	MMTM	SP,A0,A1
	MOVE	A0,A0		;ZERO?
	JRZ	CS1		;YEP...RETURN FIRST LINE

	CMPI	CS_ENTS,A0	;IN RANGE?
	JRLS	CS2		;YEP...CONTINUE
	MOVK	1,A0		;TOO LARGE.......USE 1ST LINE.

CS2	DEC	A0		;INDEX INTO TABLE
CS1	MOVI	CS_SIZE,A1	;SIZE PER ENTRY
	MPYU	A0,A1		;OFFSET INTO TABLE
	ADDI	CSELCT,A1
	MOVE	A1,A6		;RETURN THE POINTER
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*
*	CKPROMPT
*
*	IS THERE A PROMPT STRING FOR THE CREDITS PAGE.
*
*	A0 RETURNS:
*
*	YES.....RETURN POINTER TO SOMETHING
*	NO......RETURN ZERO
*
*	IF A0 HAS A POINTER THEN....
*
*	IF A1 = 0 THEN A0 IS AN L_MESS STRING THAT SHOULD
*		JUST BE SENT OUT.
*
*	IF A1 != 0 THEN A0 IS A POINTER LIST OF UP TO 2 MESSAGES.
*		THAT GIVE PRICING INFO
*
*	A1 = 0 PLOT THE A0 STRING OUTRIGHT USING L_MESS
*		(IT CONTAINS ALL DATA)
*
*	A1 = 1  PLOT ONLY THE STRING LIST (1 OR 2 POINTERS
*		CENTERED APPROPRIATELY
*
*	A1 = 2  PLOT THE 1ST LINE OF THE STRING LIST ALONG
*		WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
*	A1 = 3  PLOT THE 2ND LINE OF THE STRING LIST ALONG
*		WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
*	A1 = 4  PLOT THE 3RD LINE OF THE STRING LIST ALONG
*		WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
*	A1 = 5  PLOT THE 1ST LINE OF THE STRING LIST ALONG
*		ALONG WITH 2 COINS PER PLAYER
*
*	A1 = 6  PLOT THE 2ND LINE OF THE STRING LIST ALONG
*		ALONG WITH 2 COINS PER PLAYER
*
*	A1 = 7  PLOT THE 3RD LINE OF THE STRING LIST ALONG
*		ALONG WITH 2 COINS PER PLAYER
*
*	A1 = 8  CUSTOM MESSAGE
*
**************************************************************************
								
CKPROMPT
	PUSH	a6
	movk	ADJFREPL,a0
	CALLA	GET_ADJ
	jrnz	RET_NO			;Free play?

	CALLA	CK_MAX			;ARE WE AT MAX CREDITS?
	JRHS	RET_MAX

	movk	ADJNOCPAG,a0
	CALLA	GET_ADJ 		;CHECK THE ADJUSTMENT
	JRNZ	CKSPCASE		;WE'RE SET TO SHUT UP.JUST START/CONT

	movk	ADJ1ST6,a0		;has operator messed around?
	CALLA	GET_ADJ
	JRZ	CKSPCASE		;YEP...GO FOR GENERIC "2 TO START"

*	OPERATOR IS USING CANNED COINAGE....WE NEED TO USE THE
*	CHECK IF ITS 2/1 OR 2/2

	CALLR	CK_2_CRED		;IS IT A 2 CREDIT MODE?
	JRZ	NOT_2_MODE		;NOPE...PRINT STOCK STUFF

	MOVE	A0,A1			;COPY 2/1	 2/2 CODE
	CALLR	GET_CSPT		;POINT A6 AT CSEL FOR US NOW.
	MOVE	*A6(CS_PICK),A0		;GET INDICATION OF WHICH LINE
	JRZ	CKSPCASE		;IT SAYS JUST ENUMERATE THE MODE!

*	NOW....IF ITS 2/1, A0 HAS THE CORRECT RETURN CODE
*	IF ITS 2/2 WE NEED TO ADD 2

	subk	1,a1
	JRZ	RET_A0_VAL		;2/1?

	addk	3,a0
	JRUC	RET_A0_VAL		;RETURN THIS!

NOT_2_MODE
	CALLR	GET_CSPT		;POINT A6 AT CSEL FOR US NOW.
	MOVE	*A6(CS_PROMPT),A0,L	;FETCH POINTER TO MESSAGE (IF ANY)
	JRZ	CKSPCASE
					;WE HAVE SOMETHING STORED AT THE PROMPT
	CMPI	CSM_LAST,A0		;IS IT LITTLE?
	JRHI	CKEXIT			;NOPE..ITS A POINTER..RETURN L_MESS STATUE

RET_A0_VAL
	MOVE	A0,A1			;ITS LITTLE...RETURN IT AS A CODE
	MOVE	*A6(CS_LIST),A0,L	;PASS BACK MESSAGE LIST FOR THIS MODE
	JRUC	CK_BYE

RET_NO	CLR	A0			;IT IS FREE PLAY.
CKEXIT	CLR	A1			;NO FANCIES YET
CK_BYE	PULL	a6
	move	a0,a0			;Pass Z
	rets

*	CONTROL COMES HERE IF IT LOOKS LIKE NO MESSAGE IS
*	APPROPRIATE....CHECK FOR 2 TO START 1 TO CONTINUE GENERIC NEEDED.

CKSPCASE
	CALLR	CK_2_CRED		;CHECK IF THERE ARE 2 CREDIT MODES.
	JRZ	RET_NO			;NOT A 2 CREDIT MODE.

	subk	1,a0
	JRZ	TWO_ONE			;YEP...RETURN 2/1

	MOVI	TWO_CRED_PER_PLAYER,A0
	JRUC	CKEXIT			;RETURN IT!


TWO_ONE	MOVI	TWO_TO_START_2C,A0


	JRUC	CKEXIT

RET_MAX	MOVI	MAX_C_M,A0
	JRUC	CKEXIT


**************************************************************************
* CK_2_CRED - Checks if in a 2-credit to start mode
*
* A0=0	NOT 2/1 OR 2/2 CREDIT MODE
* A0=1	2 TO START 1 TO CONTINUE
* A0=2	2 TO START 2 TO CONTINUE
*
* Z	NOT 2/1 OR 2/2 CREDIT MODE
* NZ	IS 2/1 OR 2/2 CREDIT MODE
**************************************************************************
CK_2_CRED
	MOVI	ADJCSTRT,A0
	CALLA	GET_ADJ 	;HOW MANY TO START
	subk	2,a0
	jrnz	c2c20		;!2 to start?

	MOVI	ADJCCONT,A0
	CALLA	GET_ADJ 	;GET CONTINUE NUMBER
	cmpi	2,a0		;1 or 2 is what we return
	jrhi	c2c20		;>2?
	move	a0,a0		;Return NZ (unless its 2/0)
	rets

c2c20	clr	a0		;Pass Z
	rets

**************************************************************************
*									 *
*	   MENU HANDLING SOFTWARE					 *
*									 *
**************************************************************************

**************************************************************************
*									 *
*	   FORCE_MAIN							 *
*									 *
*	   THIS IS CALLED TO GET TO MAIN MENU FROM LEVEL FURTHER	 *
*	   THAN 1 DOWN.  IT SETS THE GLOBAL FLAG "MAIN_RET"		 *
*	   NON ZERO.  GEN_MENU WILL KEEP RETURNING UNTIL		 *
*	   IT GETS BACK TO THE MAIN MENU.				 *
*									 *
**************************************************************************
FORCE_MAIN
	MOVK	1,A0		;POSITIVE NUMBER FORCES MAIN MENU.
	MOVE	A0,@MAIN_RET
	RETP			;NOW "RETURN TO THE MENU"

**************************************************************************
*									 *
*	  DIAGNOSTIC TESTS SELECTED......SHOW DIAGNOSTIC TEST MENU	 *
*									 *
**************************************************************************
GO_DIAG
	MOVI	MEN_DIAG,A8	;PUT UP THE MENU AND GO!
	JAUC	GEN_MENU	;THIS WILL RETURN TO LEVEL ABOVE US!

**************************************************************************
*									 *
*	  COIN BOOKKEEPING SELECTED					 *
*									 *
**************************************************************************
gb20	JSRP	DO_CLCOIN
GO_BOOK
	CALLA	CLR_SCRN
	MOVI	MES_BOOK,A2
	MOVI	ROBO_WHITE,A3
	JSRP	TOP_BOX 		;PRINT TITLE BOX.

	MOVI	COIN_AUDS,A0		;PUT TABLE UP.
	JSRP	PRNT_AUD
	MOVI	COIN1_AUDS,A0		;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	AUDLCOIN,A8		;NOW PRINT MONEY FOR 1ST 3
	JSRP	PRINT_COL

	MOVI	COIN2_AUDS,A0		;PUT TABLE UP.
	JSRP	PRNT_AUD



;	MOVI	COIN_A2,A0		;PUT PART 2 OF THE TABLE THERE.
;	JSRP	PRNT_AUD

	MOVI	MEN_DETAIL,A8
	MOVK	2,A9			;CURSOR ON 2nd ENTRY
	JSRP	B_MENU			;SEE IF THEY WANT PAGE 2.
	CMPI	1,A8			;DID WE GET 1'ST ENTRY?
	jreq	gb20

	RETP


;DETAIL_SCREEN
;	 CALLA	 CLR_SCRN		;CLEAR OUT FOR ACTION!
;
;	 MOVI	 DT_Y1,A0		;HEIGHT OF TOP TITLE
;	 MOVI	 ROBO_YELLOW,A9		;COLOR
;	 CALLA	 F_TITLE		;FRAME IT
;
;	 MOVI	 DT_Y2,A0		;HEIGHT OF 2ND TITLE
;	 CALLA	 F_TITLE		;FRAME IT
;
;	 MOVI	 DETAIL_TITLES,A8     ;NO ROOM FOR PRETTY TOP BOX...DO TITLES
;	 JSRP	 L_MESS 	      ;ESTABLISH THE TITLES.
;
;	 MOVI	 COIN_D1,A0	      ;DETAILED AUDIT 1
;	 JSRP	 PRNT_AUD	      ;PRINT IT
;
;	 MOVI	 AUDLCOIN,A8	      ;NOW PRINT MONEY FOR 1ST 3
;	 JSRP	 PRINT_COL	
;
;	 MOVI	 AUDLCSUB,A8	      ;SUB-TOTAL OF TOTAL MONEY
;	 JSRP	 PRINT_SUBTOTAL       ;PRINT IT.
;
;	 MOVI	 COIN_D2,A0	      ;DETAILED AUDIT 2
;	 JSRP	 PRNT_AUD
;
;	 MOVI	 AUDLCDC,A8	      ;NOW PRINT MONEY FOR DOOR CLOSED SET
;	 JSRP	 PRINT_COL
;
;	 MOVI	 AUDLCDCS,A8	      ;NOW PRINT SUB-TOTAL FOR DOOR CLOSED
;	 JSRP	 PRINT_SUBTOTAL       ;THATS IT!
;
;	 MOVI	 MEN_CLR_SUB,A8       ;CLEAR SUBTOTAL OR RETURN TO MAIN MENU
;	 MOVI	 2,A9		      ;CURSOR ON 2ND ENTRY
;	 JSRP	 B_MENU 	
;
;	 CMPI	 1,A8		      ;CHOICE 1 IS CLEAR.....
;	 JRNZ	 NO_CLEAR_SUB	      ;NOPE...RETURN TO CALLER!
;
;	 MOVI	 MESS_CLEAR_SUBS,A8   ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
;	 MOVI	 CLR_SUBS,A9	      ;ROUTINE TO DO IT
;	 MOVI	 MESS_SUBS_CLEAR,A10  ;CONFIRMATION.
;	 JSRP	 AREUSURE	      ;ASK EM.
;	 JRUC	 DETAIL_SCREEN	      ;NOW PUT THIS SCREEN BACK UP.
;
;NO_CLEAR_SUB
;NO_DETAIL
;	 RETP			      ;AND RETURN TO OUR CALLER.
;
;PRINT_SUBTOTAL
;	  CALLR   ADD_AUDIT_DY	       ;PUSH THE Y 1 LEVEL
;	  MOVI	  T_SUB,A9	       ;USE "SUB-TOTAL" MESSAGE
;	  JAUC	  PRINT_MONEY	       ;AND NOW PRINT THE REQUESTED SUM.

**************************************************************************
*									 *
*	   GAME AUDITS SELECTED 					 *
*									 *
**************************************************************************

**************************************************************************
*									 *
*	   AUDITS TO BE SHOWN ON GAME AUDITS PAGE:			 *
*									 *
*	   EXTRA MEN							 *
*	   GAMES COMPLETED						 *
*	   1 PLAYER MINUTES						 *
*	   2 PLAYER MINUTES						 *
*	   TOTAL HOURS PLAYED						 *
*	   AVG "PLAYER" GAME TIME					 *
*	   AVG. ELAPSED TIME / PLAY					 *
*									 *
**************************************************************************

GO_AUD
	CALLA	CLR_SCRN
	MOVI	MES_AUD,A2
	MOVI	ROBO_CYAN,A3
	JSRP	TOP_BOX 	;PRINT TITLE BOX.

	MOVI	GAME_AUDS,A0	;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	MEN_AP1,A8	;AUDIT PAGE 1 MENU
	MOVK	1,A9		;CURSOR ON 1ST ENTRY
	JSRP	B_MENU		;SEE IF THEY WANT PAGE 2.

	CMPI	1,A8		;DID WE GET 1'ST ENTRY?
	JRNZ	NO_AP2		;NOPE...RETURN TO OUR CALLER


#page2
	CALLA	CLR_SCRN

	MOVI	MES_AUD,A2
	MOVI	ROBO_CYAN,A3
	JSRP	TOP_BOX 	;PRINT TITLE BOX.

	MOVI	GAME_AUDS1a,A0	;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	MEN_AP2,A8
	MOVK	1,A9		;CURSOR ON 1ST ENTRY
	JSRP	B_MENU		;SEE IF THEY WANT PAGE 2.
	cmpi	2,A8		;DID WE GET 2nd ENTRY (RETURN TO PAGE 1)
	jreq	GO_AUD		;YEP...PUT IT UP!

#page3
	CALLA	CLR_SCRN

	MOVI	MES_AUD,A2
	MOVI	ROBO_CYAN,A3
	JSRP	TOP_BOX 	;PRINT TITLE BOX.

	MOVI	GAME_AUDS1b,A0	;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	MEN_AP2,A8
	MOVK	1,A9		;CURSOR ON 1ST ENTRY
	JSRP	B_MENU		;SEE IF THEY WANT PAGE 2.
	cmpi	2,A8		;DID WE GET 2nd ENTRY (RETURN TO PAGE 1)
	jrz	#page2		;YEP...PUT IT UP!
	
#page4
	CALLA	CLR_SCRN

	MOVI	MES_AUD,A2
	MOVI	ROBO_CYAN,A3
	JSRP	TOP_BOX 	;PRINT TITLE BOX.

	MOVI	GAME_AUD2a,A0	;PUT TABLE UP.
	JSRP	PRNT_AUD
	MOVI	GAME_AUD2b,A0	;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	MEN_AP3,A8
	MOVK	1,A9		;CURSOR ON 2ND ENTRY
	JSRP	B_MENU		;SEE IF THEY WANT PAGE 2.
	CMPI	2,A8		;DID WE GET 2nd ENTRY (RETURN TO PAGE 2)
	JRZ	#page3		;YEP...PUT IT UP!

NO_AP2
	RETP

GO_UTIL
	MOVI	MEN_UTIL,A8
	JAUC	GEN_MENU	;PROCESS THE UTILITY MENU!
*
*	INDIVIDUAL UTILITY PROGRAMS
*

DO_CLCRED
	MOVI	MESS_CLCRED,A8	;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	CLR_CREDITS,A9	;ROUTINE TO DO IT
	MOVI	MESS_CCCONF,A10	;CONFIRMATION.
	JAUC	AREUSURE	;ASK EM......THEN RETURN!


**************************************************************************
*                                                                        *
*         HARDWARE INFORMATION SELECTED                                  *
*                                                                        *
**************************************************************************
	.data

M_DIPTEST
	.string	"DIPSWITCH TEST",0
	.even
M_SWTEST
	.string	"GENERAL SWITCH TEST",0
	.even
M_GAME_VOL
	.string	"GAME VOLUME ADJ.",0
	.even
M_AMODE_VOL
	.string	"ATTRACT MODE VOLUME ADJ.",0
	.even
HARDWARE_HELP
	.word	0
	.word	COLOR_BLUE
	.word	2
	.long	HDWH_SN
	.long	HDWH_MAN
HDWH_SN
	.string	"SERIAL NUMBER",0
	.even
HDWH_MAN
	.string	"MANUFACTURE DATE",0
	.even

CLOCK_HELP
	.word	0
	.word	COLOR_BLUE
	.word	2
	.long	CLKH_MESS1
	.long	CLKH_MESS2
CLKH_MESS1
	.string	"DISPLAY OR SET",0
	.even
CLKH_MESS2
	.string	"THE REAL TIME CLOCK",0
	.even
CLK_DISPLAY_HELP
	.word	0
	.word	COLOR_BLUE
	.word	3
	.long	CDISP_H1
	.long	CDISP_H2
	.long	CDISP_H3
CDISP_H1
	.string	"DISPLAYS THE CURRENT",0
	.even
CDISP_H2
	.string	"DATE AND TIME FROM",0
	.even
CDISP_H3
	.string	"THE REAL TIME CLOCK",0
	.even
CLK_SET_HELP
	.word	0
	.word	COLOR_BLUE
	.word	3
	.long	CSET_H1
	.long	CSET_H2
	.long	CSET_H3
CSET_H1
	.string	"ALLOWS SETTING OF THE",0
	.even
CSET_H2
	.string	"DATE AND TIME FOR",0
	.even
CSET_H3
	.string	"THE REAL TIME CLOCK",0
	.even
CLK_CALIBRATE_HELP
	.word	0
	.word	COLOR_BLUE
	.word	3
	.long	CCAL_H1
	.long	CCAL_H2
	.long	CCAL_H3
CCAL_H1
	.string	"PREFORMS AUTOMATIC",0
	.even
CCAL_H2
	.string	"CALIBRATION OF THE",0
	.even
CCAL_H3
	.string	"REAL TIME CLOCK",0
	.even

MESS_HARDWARE
	.string	"HARDWARE INFO",0
	.even
MESS_CLOCK
	.string	"REAL TIME CLOCK",0
	.even

CAL_MESS_Y	EQU	114

CLK_CALIBRATE_MESS
	MESS_MAC RD15FONT,SPACING07,200,CAL_MESS_Y+20,ROBO_YELLOW,STRCNRM,0
	.string	"Calibrating Real Time Clock"
	.byte	0,1
	.even
	MESS_MAC RD15FONT,SPACING07,200,CAL_MESS_Y,ROBO_DECAY,STRCNRM,0
	.string	"Please Wait"
	.byte	0,0
	.even
CLK_CALIBRATE_OK_MESS
	MESS_MAC RD15FONT,SPACING07,200,CAL_MESS_Y+7,ROBO_WHITE,STRCNRM,0
	.string	"Calibration Successful"
	.byte	0,0
	.even
M_CLK_DISPLAY
	.string	"DATE AND TIME DISPLAY",0,0
	.even
M_CLK_CALIBRATE
	.string	"REAL TIME CLOCK CALIBRATION",0,0
	.even
M_CLK_SET
	.string	"SETTING REAL TIME CLOCK",0,0
	.even

CDAY_PROMPT_Y	EQU	50
CTIME_PROMPT_Y	EQU	130
CDAY_Y		EQU	CDAY_PROMPT_Y+30
CDATE_Y		EQU	CDAY_Y+20
CTIME_Y		EQU	CTIME_PROMPT_Y+30

MESS_CLKD_PROMPTS
	MESS_MAC RD15FONT,SPACING07,200,CDAY_PROMPT_Y,ROBO_WHITE,STRCNRM,0
	.string	"Current Date"
	.byte	0,1
	.even
	MESS_MAC RD15FONT,SPACING07,200,CTIME_PROMPT_Y,ROBO_WHITE,STRCNRM,0
	.string	"Current Time"
	.byte	0,1
	.even
MESS_QUIT
	MESS_MAC RD7FONT,SPACING07,200,230,ROBO_DECAY,STRCNRM,0
	.string	"PRESS ANY BUTTON TO QUIT"
	.byte	0,0
	.even
MESS_RTC_SET
	MESS_MAC RD7FONT,SPACING07,200,215,ROBO_LASER,STRCNRM,0
	.string	"THE REAL TIME CLOCK HAS BEEN SET"
	.byte	0,0
	.even
MESS_SUNDAY
	.string	"Sunday",0
	.even
MESS_MONDAY
	.string	"Monday",0
	.even
MESS_TUESDAY
	.string	"Tuesday",0
	.even
MESS_WEDNESDAY
	.string	"Wednesday",0
	.even
MESS_THURSDAY
	.string	"Thursday",0
	.even
MESS_FRIDAY
	.string	"Friday",0
	.even
MESS_SATURDAY
	.string	"Saturday",0
	.even

DAY_TABLE	.long	MESS_SUNDAY,MESS_MONDAY,MESS_TUESDAY,MESS_WEDNESDAY
		.long	MESS_THURSDAY,MESS_FRIDAY,MESS_SATURDAY
		.even

MESS_JANUARY
	.string	"January  ",0
	.even
MESS_FEBRUARY
	.string	"February  ",0
	.even
MESS_MARCH
	.string	"March  ",0
	.even
MESS_APRIL
	.string	"April  ",0
	.even
MESS_MAY
	.string	"May  ",0
	.even
MESS_JUNE
	.string	"June  ",0
	.even
MESS_JULY
	.string	"July  ",0
	.even
MESS_AUGUST
	.string	"August  ",0
	.even
MESS_SEPTEMBER
	.string	"September  ",0
	.even
MESS_OCTOBER
	.string	"October  ",0
	.even
MESS_NOVEMBER
	.string	"November  ",0
	.even
MESS_DECEMBER
	.string	"December  ",0
	.even
MONTH_TABLE
	.long	MESS_JANUARY, MESS_FEBRUARY, MESS_MARCH, MESS_APRIL
	.long	MESS_MAY, MESS_JUNE, MESS_JULY, MESS_AUGUST, MESS_SEPTEMBER
	.long	MESS_OCTOBER, MESS_NOVEMBER, MESS_DECEMBER
	.even
MESS_HYEARS
	.string	", 19",0
	.even
TSEPERATOR
	.string	":",0
	.even
ZPAD
	.string	"0",0
	.even
TIME_PM
	.string	" PM",0
	.even
TIME_AM
	.string	" AM",0
	.even
DAY_SETUP
	MESS_MAC RD15FONT,SPACING07,200,CDAY_Y,ROBO_GREEN,STRCNRM,0
	.string	""
	.byte	0,0
	.even
DATE_SETUP
	MESS_MAC RD15FONT,SPACING07,200,CDATE_Y,ROBO_GREEN,STRCNRM,0
	.string	""
	.byte	0,0
	.even
TIME_SETUP
	MESS_MAC RD15FONT,SPACING07,200,CTIME_Y,ROBO_GREEN,STRCNRM,0
	.string	""
	.byte	0,0
	.even
DAYADJ_SETUP
	MESS_MAC RD15FONT,SPACING07,284,185,ROBO_GREEN,STRCNRM,0
	.string	""
	.byte	0,0
	.even
DATEADJ_SETUP
	MESS_MAC RD15FONT,SPACING07,286,205,ROBO_GREEN,STRCNRM,0
	.string	""
	.byte	0,0
	.even
TADJ_SETUP
	MESS_MAC RD15FONT,SPACING07,284,225,ROBO_GREEN,STRCNRM,0
	.string	""
	.byte	0,0
	.even

;SNDRELEASE_NUM_PROMPT:
;	MESS_MAC RD15FONT,SPACING07,200,130,ROBO_PURPLE,STRCNRM,0
;	.string	"Sound Software Version:\n"
;	.string "RELEASE %2ld"
;	.byte	0,0
;	.long	_serial_number
;	.even
;SNDPROTO_NUM_PROMPT:
;	MESS_MAC RD15FONT,SPACING07,200,130,ROBO_PURPLE,STRCNRM,0
;	.string	"Sound Software Version:\n"
;	.string "PROTO %2ld"
;	.byte	0,0
;	.long	_serial_number
;	.even

WILLY_Y		EQU	50
UNIT_Y		EQU	WILLY_Y+50
SERIAL_Y	EQU	UNIT_Y+40
MAN_Y		EQU	SERIAL_Y+40

M_DOM
	.string	"DATE OF MANUFACTURE:  ",0
	.even
M_SERIAL
	.string	"SERIAL NUMBER:  ",0
	.even
MAN_DATE_SETUP:
	MESS_MAC RD7FONT, SPACING07,200, MAN_Y, ROBO_PURPLE,STRCNRM,0
	.string ""
	.byte	0,0
	.even
WILLY_PROMPT:
	MESS_MAC RD15FONT, SPACING07, 200, WILLY_Y, ROBO_GREEN, STRCNRM,0
	.string	"Midway Manufacturing Inc."
	.byte	0,1
	.even
	MESS_MAC RD15FONT, SPACING20, 200, UNIT_Y, ROBO_YELLOW, STRCNRM, 0
	.string	"HANG TIME UNIT"
	.byte	0,0
	.even
SERIAL_NUM_SETUP:
	MESS_MAC RD7FONT,SPACING07,200,SERIAL_Y,ROBO_PURPLE,STRCNRM,0
	.string ""
	.byte	0,0
	.even

M_HARDWARE_INFO
	.string	"HARDWARE INFORMATION",0
	.even

MESS_CLK_TITLE
	.string	"REAL TIME CLOCK",0
	.even
MESS_DISPLAY
	.string	"DISPLAY",0
	.even
MESS_SET
	.string	"SET",0
	.even
MESS_CALIBRATE
	.string	"CALIBRATE",0
	.even

MEN_CLOCK
	.long	RD7FONT		;FONT
	.long	STRCNRM		;CENTER PLEASE
	.long	MESS_CLK_TITLE	;TITLE
	.word	COLOR_GREEN	;COLOR OF TITLE
	.word	104		;UL X
	.word	MENU_Y-3	;UL Y
	.word	MENU_DY-4	;VERTICAL SPACING
	.word	ROBO_WHITE	;COLOR WHEN NOT SELECTED
	.word	16		;HEIGHT OF SELECTION BAR
	.word	-4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.word	BAR_DX		;EXTRA X ON EACH SIDE.
	.word	BAR_WID		;WIDTH OF BAR!  (A LITTLE FATTER)
	.word	ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM (SHOULD BE DECAY)
	.long	MESS_DISPLAY,GO_DISPLAY,CLK_DISPLAY_HELP
	.long	MESS_SET,GO_TIME_SET,CLK_SET_HELP
;	.long	MESS_CALIBRATE,GO_CALIBRATE,CLK_CALIBRATE_HELP
	.long	MESS_MM,RET_CLOCK,NO_HELP
	.long	0



*
*	CLOCK SET MENU IS SKINNY..LEAVING ROOM FOR EXPLANATION.
*
CS_BDY	EQU	-2
CS_WID	EQU	0A7H
CS_X	EQU	TIT_ULX+GAP+MB_XWID+(CS_WID/2)+C_KLUDGE
CS_Y	EQU	INST_LRY+BOX_YGAP+MB_YWID+GAP-CS_BDY
*
*	RIGHT MARGIN OF ADJUST MENU BOX
*
CS_RX	EQU	TIT_ULX+(2*GAP)+CS_WID+(2*MB_XWID)
*
*	LEFT MARGIN OF HELP BOX
*
CS_HX	EQU	CS_RX+BOX_XGAP

M_TIME_SET
	.string	"SET REAL TIME CLOCK",0
	.even
MESS_YEAR_SET
	.string	"YEAR",0
	.even
MESS_DATE_SET
	.string	"DATE",0
	.even
MESS_MONTH_SET
	.string	"MONTH",0
	.even
MESS_DAY_SET
	.string	"DAY",0
	.even
MESS_HOUR_SET
	.string	"HOURS",0
	.even
MESS_MINUTE_SET
	.string	"MINUTES",0
	.even
MESS_SECOND_SET
	.string	"SECONDS",0
	.even
MESS_SET_CLOCK
	.string	"SET TIME/DATE",0
	.even
MESS_CLK_RET
	.string	"RETURN TO PREV MENU",0
	.even

MEN_TIME_SET
	.LONG	RD7FONT 	;FONT
	.LONG	STRCNRM 	;CENTER PLEASE
	.LONG	M_TIME_SET	;TITLE
	.WORD	COLOR_WHITE    ;COLOR OF TITLE
	.WORD	CS_X		;UL X
	.WORD	CS_Y		;UL Y
	.WORD	12
	.WORD	COLOR_WHITE     ;COLOR WHEN NOT SELECTED
	.WORD	12		;HEIGHT OF SELECTION BAR
	.WORD	CS_BDY		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	CS_WID		;WIDTH OF BAR!
	.WORD	COLOR_DECAY     ;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_CLK_RET,0,BLNK_HELP	   ;RETURN TO MAIN MENU
	.LONG	MESS_YEAR_SET,DO_YEAR,ADJ_HELP
	.LONG	MESS_DATE_SET,DO_DATE,ADJ_HELP
	.LONG	MESS_MONTH_SET,DO_MONTH,ADJ_HELP	;FREE PLAY
	.LONG	MESS_DAY_SET,DO_DAY,ADJ_HELP
	.LONG	MESS_HOUR_SET,DO_HOUR,ADJ_HELP
	.LONG	MESS_MINUTE_SET,DO_MINUTE,ADJ_HELP
	.LONG	MESS_SECOND_SET,DO_SECOND,ADJ_HELP
	.LONG	MESS_SET_CLOCK,GO_CLOCK_SET,SET_CLOCK_HELP
	.LONG	MESS_CLK_RET,0,BLNK_HELP	   ;RETURN TO MAIN MENU
	.LONG	0		;END

INSTR_Y  EQU	 INST_ULY+5
INSTR_2Y EQU	 INSTR_Y+10

CS_ADV
	  MESS_MAC  RD7FONT,SPACING07,CS_X,INSTR_Y,COLOR_BPR,STRCNRM,0
	 .STRING   "SELECT WITH ANY STICK"
	 .BYTE	 0,1
	 .EVEN
	 MESS_MAC  RD7FONT,SPACING07,CS_X,INSTR_2Y,COLOR_BPR,STRCNRM,0
	 .STRING   "PRESS A BUTTON TO MODIFY"
	 .BYTE	 0,0
	 .EVEN

SCH_1
	.string	"SETS THE REAL TIME CLOCK",0
	.even
SCH_2
	.string	"TO THE VALUES SPECIFIED BY",0
	.even
SCH_3
	.string	"THE OTHER MENU ITEMS.",0
	.even
SET_CLOCK_HELP
	.word	1
	.word	COLOR_BLUE
	.word	3
	.long	SCH_1
	.long	SCH_2
	.long	SCH_3
	.even
YSH_1
	.string	" SET THE REAL TIME CLOCK's",0
	.even
YSH_2
	.string	"        YEAR VALUE.",0
	.even
YSH_3
	.string	" Takes effect when SET is",0
	.even
YSH_4
	.string	" selected on the RTC MENU",0
	.even
HELP_YEAR
	.word	1
	.word	COLOR_BLUE
	.word	4
	.long	YSH_1
	.long	YSH_2
	.long	YSH_3
	.long	YSH_4
	.even
DO_YEAR
	.long	GEN_TS			; Routine to run
	.long	MESS_YEAR_SET		; Header Message
	.long	HELP_YEAR		; Help Messages
	.word	6			; Index number of val to change
	.long	0			; Minimum value
	.long	99			; Maximum value
	.long	1			; Move up and down by 1's
	.long	0			; Dont sub zero for any
	.long	YEAR_SET		; Message list for values
	.word	WRAP_VAL		; Wrap around
	.long	0			; Just Show Number
	.long	MESS_YEAR_SET		; Header Message

DTSH_2
	.string	"        DATE VALUE.",0
	.even
HELP_DATE
	.word	1
	.word	COLOR_BLUE
	.word	4
	.long	YSH_1
	.long	DTSH_2
	.long	YSH_3
	.long	YSH_4
	.even
DO_DATE
	.long	GEN_TS			; Routine to run
	.long	MESS_DATE_SET		; Header Message
	.long	HELP_DATE		; Help Messages
	.word	4			; Index Number of val to change
	.long	1			; Minimum value
	.long	31			; Maximum value
	.long	1			; Move up and down by 1's
	.long	0			; Dont sub zero for any
	.long	DATE_SET		; Message list for values
	.word	WRAP_VAL		; Wrap around
	.long	0			; Just Show Number
	.long	MESS_DATE_SET		; Header Message


MSH_2
	.string	"       MONTH OF YEAR.",0
	.even
HELP_MONTH
	.word	1
	.word	COLOR_BLUE
	.word	4
	.long	YSH_1
	.long	MSH_2
	.long	YSH_3
	.long	YSH_4
	.even
DO_MONTH
	.long	GEN_TS			; Routine to run
	.long	MESS_MONTH_SET		; Header Message
	.long	HELP_MONTH		; Help Messages
	.word	5			; Index Number of val to change
	.long	1			; Minimum value
	.long	12			; Maximum value
	.long	1			; Move up and down by 1's
	.long	0			; Dont sub zero for any
	.long	MONTH_SET		; Message list for values
	.word	WRAP_VAL		; Wrap around
	.long	MONTH_TABLE		; Just Show Number
	.long	MESS_MONTH_SET		; Header Message


DSH_2
	.string	"        DAY OF WEEK.",0
	.even
HELP_DAY
	.word	1
	.word	COLOR_BLUE
	.word	4
	.long	YSH_1
	.long	DSH_2
	.long	YSH_3
	.long	YSH_4
	.even
DO_DAY
	.long	GEN_TS			; Routine to run
	.long	MESS_DAY_SET		; Header Message
	.long	HELP_DAY		; Help Messages
	.word	3			; Index Number of val to change
	.long	1			; Minimum value
	.long	7			; Maximum value
	.long	1			; Move up and down by 1's
	.long	0			; Dont sub zero for any
	.long	DAY_SET			; Message list for values
	.word	WRAP_VAL		; Wrap around
	.long	DAY_TABLE		; Just Show Number
	.long	MESS_DAY_SET		; Header Message

HSH_2
	.string	"         HOUR VALUE.",0
	.even
HELP_HOUR
	.word	1
	.word	COLOR_BLUE
	.word	4
	.long	YSH_1
	.long	HSH_2
	.long	YSH_3
	.long	YSH_4
	.even
DO_HOUR
	.long	GEN_TS			; Routine to run
	.long	MESS_HOUR_SET		; Header Message
	.long	HELP_HOUR		; Help Messages
	.word	2			; Index Number of val to change
	.long	1			; Minimum value
	.long	24			; Maximum value
	.long	1			; Move up and down by 1's
	.long	0			; Dont sub zero for any
	.long	HOUR_SET		; Message list for values
	.word	WRAP_VAL		; Wrap around
	.long	0			; Just Show Number
	.long	MESS_HOUR_SET		; Header Message


MINSH_2
	.string	"        MINUTE VALUE.",0
	.even
HELP_MINUTE
	.word	1
	.word	COLOR_BLUE
	.word	4
	.long	YSH_1
	.long	MINSH_2
	.long	YSH_3
	.long	YSH_4
	.even
DO_MINUTE
	.long	GEN_TS			; Routine to run
	.long	MESS_MINUTE_SET		; Header Message
	.long	HELP_MINUTE		; Help Messages
	.word	1			; Index Number of val to change
	.long	0			; Minimum value
	.long	59			; Maximum value
	.long	1			; Move up and down by 1's
	.long	0			; Dont sub zero for any
	.long	MINUTE_SET		; Message list for values
	.word	WRAP_VAL		; Wrap around
	.long	0			; Just Show Number
	.long	MESS_MINUTE_SET		; Header Message

SSH_2
	.string	"        SECOND VALUE.",0
	.even
HELP_SECOND
	.word	1
	.word	COLOR_BLUE
	.word	4
	.long	YSH_1
	.long	SSH_2
	.long	YSH_3
	.long	YSH_4
	.even
DO_SECOND
	.long	GEN_TS			; Routine to run
	.long	MESS_SECOND_SET		; Header Message
	.long	HELP_SECOND		; Help Messages
	.word	0			; Not used
	.long	0			; Minimum value
	.long	59			; Maximum value
	.long	1			; Move up and down by 1's
	.long	0			; Dont sub zero for any
	.long	SECOND_SET		; Message list for values
	.word	WRAP_VAL		; Wrap around
	.long	0			; Just Show Number
	.long	MESS_SECOND_SET		; Header Message

	.text

GO_HARDWARE:
	move	@_man_date,a2,L
	move	a2,a1
	subk	1,a1
	movi	372,a0
	divu	a0,a1
	movi	372,a3
	mpyu	a1,a3
	sub	a3,a2
	addi	80,a1
	move	a1,@_year,1
	move	a2,a0
	movi	31,a1
	modu	a1,a0
	move	a0,@_day,1
	move	a2,a1
	subk	1,a1
	movi	31,a0
	divu	a0,a1
	addk	1,a1
	move	a1,@_month,1
	calla	CLR_SCRN		; Clear the screen
	movi	M_HARDWARE_INFO,a2	; Put up Title Box
	movi	ROBO_GREEN,a3
	JSRP	TOP_BOX
	movi	WILLY_PROMPT,a8
	JSRP	L_MESS
	movi	M_DOM,a4
	calla	copy_rom_string		; Copy the Date of manufacture prompt
	move	@_month,a0
	dec	a0
	sll	5,a0
	movi	MONTH_TABLE,a8
	add	a0,a8
	move	*a8,a4,L
	calla	concat_rom_string	; Copy the month name
	move	@_day,a0		; Convert date to ascii
	movi	31,a1
	calla	dec_to_asc
	calla	concat_string		; Add date to string
	movi	MESS_HYEARS,a4		; Add , 19 to string
	calla	concat_rom_string
	move	@_year,a0		; Convert year to ascii
	movi	99,a1
	calla	dec_to_asc
	calla	concat_string		; Add year to string
	movi	MAN_DATE_SETUP,a0	; Setup message
	callr	_setup_message
	movi	_setup_mess,a8
	JSRP	L_MESS			; Print Date of Manufacture

	movi	M_SERIAL,a4
	calla	copy_rom_string		; Copy serial number prompt
	move	@_serial_number,a0,L	; Convert serial number to ascii
	movi	1000000,a1
	calla	dec_to_asc
	calla	concat_string		; Add serial number to prompt
	movi	SERIAL_NUM_SETUP,a0	; Setup the message
	callr	_setup_message
	movi	_setup_mess,a8
	JSRP	L_MESS			; Print the Serial Number
	movi	MESS_QUIT,a8
	JSRP	L_MESS
_hardware_check_sw:			; Wait for a button to be pressed
	SLEEP	10
	move	@_switch2_addr,a0,L
	move	*a0,a0,W
	move	@_switch_addr,a1,L
	move	*a1,a1,W
	sll	16,a0
	srl	16,a0
	sll	16,a1
	srl	16,a1
	and	a0,a1
	move	@_coin_addr,a0,L
	move	*a0,a0
	sll	16,a0
	or	a1,a0
	not	a0
	jrz	_hardware_check_sw
RET_HARDWARE:
	JSRP	FORCE_MAIN
	RETP


GO_CLOCK:
	move	@_clk_rd,a8,L		;Save current auto update state
	move	a8,@_auto_update_save,L
	clr	a8			;Enable auto update
	move	a8,@_clk_rd,L
	JSRP	_GetTime
	movi	MEN_CLOCK,a8
	jauc	GEN_MENU
RET_CLOCK:
	move	@_auto_update_save,a8,L	;Restore Auto Update state
	move	a8,@_clk_rd,L
	JSRP	FORCE_MAIN
	RETP


GO_CALIBRATE:
	calla	CLR_SCRN		; Clear the screen
	movi	M_CLK_CALIBRATE,a2	; Put up Title Box
	movi	ROBO_GREEN,a3
	JSRP	TOP_BOX
	movi	CLK_CALIBRATE_MESS,a8	; Put up calibrating message
	JSRP	L_MESS
	SLEEP	5*60			; Do calibration here
	move	@0c00000b0h,a0		; Make sure transparency is OFF
	move	a0,-*sp
	andni	020h,a0
	move	a0,@0c00000b0h
	movi	[CAL_MESS_Y,0],a0	; Get rid of calibrating message
	movi	[40,400],a1
	movi	ROBO_BLACK,a2
	fcall	RECTANGLE,b6
	move	*sp+,a0
	move	a0,@0c00000b0h		; Restore CONTROL register
	movi	CLK_CALIBRATE_OK_MESS,a8	; Put up success message
	JSRP	L_MESS
	SLEEP	60			; Let user see it
	calla	CLR_SCRN
	RETP				; All done

; a0 = pointer to MESS_MAC TO COPY message is copied from message_buffer
_setup_message:
	movi	_setup_mess,a1
	movk	10,a2
_sm_lp1:
	move	*a0+,*a1+
	dsjs	a2,_sm_lp1
	movi	_setup_mess_msg,a1
	movi	message_buffer,a0
	pushst
	setf	8,0
_sm_lp2:
	move	*a0+,a2
	move	a2,*a1+
	move	a2,a2
	jrnz	_sm_lp2
_sm_done
	popst
	clr	a2
	move	a2,*a1
	rets

*******************************************************************
* _GetTime - Process subroutine to get the current time.  Time is
*            returned in the _tXXXXXX globals.
*
  SUBRP _GetTime
	move	@_clk_rd,a0,L	;Save status of auto update
	move	a0,@_auto_update_save,L
	movi	-1,a0		;Shut down auto update
	move	a0,@_clk_rd,L
	calla	_aquire_time	;Arm time aquistion
	SLEEPK	5		;Wait for it to aquire time
	calla	_get_time	;Get the current time
	move	@_auto_update_save,a0,L
	move	a0,@_clk_rd,L	;Restore auto update status
	RETP			;All done

; Process Subroutine to print time
_display_time:
	clr	a0
	move	a0,@message_buffer
	move	@_thours,a0		; Hours
	jrnz	_hour_gz1
	addk	12,a0
	jruc	_time_is_am
_hour_gz1
	cmpi	12,a0
	jrle	_time_is_am
	move	@_thours,a0		; Hours
	subi	12,a0
_time_is_am
	movi	12,a1			; Max hours
	calla	dec_to_asc
	calla	concat_string
	movi	TSEPERATOR,a4
	calla	concat_rom_string
	move	@_tminutes,a0
	cmpi	9,a0
	jrgt	_no_min_pad
	movi	ZPAD,a4
	calla	concat_rom_string
_no_min_pad
	move	@_tminutes,a0
	movi	59,a1			; Max Minutes
	calla	dec_to_asc
	calla	concat_string
	movi	TSEPERATOR,a4
	calla	concat_rom_string
	move	@_tseconds,a0
	move	a0,@_last_seconds
	cmpi	9,a0
	jrgt	_no_sec_pad
	movi	ZPAD,a4
	calla	concat_rom_string
_no_sec_pad
	move	@_tseconds,a0
	movi	59,a1			; Max Seconds
	calla	dec_to_asc
	calla	concat_string
	move	@_thours,a0		; Hours
	cmpi	11,a0
	jrgt	_time_is_pm
	movi	TIME_AM,a4
	jruc	_tdone
_time_is_pm
	movi	TIME_PM,a4
_tdone
	calla	concat_rom_string
	movi	TIME_SETUP,a0
	callr	_setup_message
	movi	_setup_mess,a8
	JSRP	L_MESS
_time_check_sw:
	SLEEP	1
	move	@_switch2_addr,a0,L
	move	*a0,a0,W
	move	@_switch_addr,a1,L
	move	*a1,a1,W
	sll	16,a0
	srl	16,a0
	sll	16,a1
	srl	16,a1
	and	a0,a1
	move	@_coin_addr,a0,L
	move	*a0,a0,W
	sll	16,a0
	or	a1,a0
	not	a0
	jrnz	_dtime_done
	move	@_tseconds,a0
	move	@_last_seconds,a1
	cmp	a0,a1
	jrz	_time_check_sw
	.ref	cntdown_snd
	SOUND1	cntdown_snd
;	movi	1cch,a3
;	calla	SNDSND
	move	@CONTROL,a0		; Make sure transparency is OFF
	move	a0,-*sp
	andni	020h,a0
	move	a0,@CONTROL
	movi	[CTIME_Y,0],a0		; Get rid of calibrating message
	movi	[20,400],a1
	movi	ROBO_BLACK,a2
	fcall	RECTANGLE,b6
	move	*sp+,a0
	move	a0,@CONTROL		; Restore CONTROL register
	jruc	_display_time
_dtime_done
	RETP
	

GO_DISPLAY:
	calla	CLR_SCRN		; Clear the screen
	movi	M_CLK_DISPLAY,a2	; Put up Title Box
	movi	ROBO_GREEN,a3
	JSRP	TOP_BOX
GO_CLKS:
;	move	@_clk_rd,a0,L		;Save current auto update state
;	move	a0,@_auto_update_save,L
;	clr	a0			;Enable auto update
;	move	a0,@_clk_rd,L
;	JSRP	_GetTime
	movi	MESS_CLKD_PROMPTS,a8	; Put up assorted prompts
	JSRP	L_MESS
	SLEEP	5
	movi	DAY_TABLE,a8		; Put Day of week up
	move	@_tday,a0		; Day of week (1-7)
	dec	a0
	cmpi	6,a0
	jrgt	_bad_day
	sll	5,a0
	add	a0,a8
	move	*a8,a4,L
	calla	copy_rom_string
	movi	DAY_SETUP,a0
	callr	_setup_message
	movi	_setup_mess,a8
	JSRP	L_MESS
_bad_day
	movi	MONTH_TABLE,a8		; Put month of year up
	move	@_tmonth,a0		; Month of year number (0-11)
	dec	a0
	cmpi	11,a0
	jrgt	_bad_month
	sll	5,a0
	add	a0,a8
	move	*a8,a4,L
	calla	copy_rom_string		; Copy month name to buffer
_bad_month
	move	@_tdate,a0		; Date (1-31)
	cmpi	9,a0
	jrgt	_no_date_pad
	movi	ZPAD,a4
	calla	concat_rom_string
_no_date_pad
	move	@_tdate,a0		; Date (1-31)
	movi	31,a1			; Maximum Date
	calla	dec_to_asc		; Convert Date to ascii
	calla	concat_string		; Add to buffer
	movi	MESS_HYEARS,a4		; , 19
	calla	concat_rom_string	; Add to buffer
	move	@_tyear,a0		; Year (0 - 99)
	cmpi	9,a0
	jrgt	_no_year_pad
	movi	ZPAD,a4
	calla	concat_rom_string
_no_year_pad
	move	@_tyear,a0
	movi	99,a1			; Max year
	calla	dec_to_asc		; Convert Years to ascii
	calla	concat_string		; Add to buffer
	movi	DATE_SETUP,a0
	callr	_setup_message
	movi	_setup_mess,a8
	JSRP	L_MESS
	JSRP	_display_time
;	move	@_auto_update_save,a0,L	;Restore Auto Update state
;	move	a0,@_clk_rd,L
	SOUND1	cntdown_snd
;	movi	0c7h,a3
;	calla	SNDSND
	RETP				; All done

_transfer_time
	mmtm	sp,a1,a2,a3
	movi	_rtc_seconds,a1
	movi	_tseconds,a2
	movi	7,a3
_tt_loop1
	move	*a2+,*a1+
	dsjs	a3,_tt_loop1
	mmfm	sp,a1,a2,a3
	rets

GO_CLOCK_SET:
	calla	CLR_SCRN		; Clear the screen
	movi	M_CLK_SET,a2		; Put up Title Box
	movi	ROBO_GREEN,a3
	JSRP	TOP_BOX
	calla	_set_time
	movi	MESS_RTC_SET,a8		; Put up "CLOCK SET" message
	JSRP	L_MESS
;	SLEEP	16
	SLEEP	30
	callr	_transfer_time
	jauc	GO_CLKS

GO_TIME_SET
;	JSRP	_GetTime
	callr	_transfer_time
	movi	MEN_TIME_SET,a8
GEN_TIME_SET
	move	a8,-*a12,L
	movk	1,a0
	move	a0,-*a12,W
TIME_SET_LOOP
	calla	CLR_SCRN
	movi	CS_ADV,a8
	JSRP	L_MESS
	move	*a12(WORD_SIZE),a8,L
	JSRP	MENU_TOP
	movi	COLOR_RED,a9
	calla	COL_INST
	move	*a12,a9,W
	JSRP	B_MENU
	move	a9,a9
	jrz	GO_TS_QUIT
_not_set_time
	move	a8,*a12,W
	move	*a9(AD_ROUT),a0,L
	movi	TIME_SET_LOOP,a7
	move	a7,-*a12,L
	cmpi	9,a8
	jrz	_time_set
	jump	a0
_time_set
	jauc	GO_CLOCK_SET
GO_TS_QUIT
	addk	WORD_SIZE,a12
	addk	LONG_SIZE,a12
	RETP

_do_title
	mmtm	a12,a10,a11,a8	     ;SAVE STUFF FOR CALLER
;	move	@_clk_rd,a0,L		;Save current auto update state
;	move	a0,@_auto_update_save,L
;	clr	a0			;Enable auto update
;	move	a0,@_clk_rd,L
;	JSRP	_GetTime
	subk	4,a10
	move	a11,a6
	movi	CS_HX,a9
	addi	TIT_LRX,a9
	srl	1,a9
	subk	4,a9
	sll	16,a10		     ;SHIFT Y DOWN
	movy	a10,a9		     ;X,Y SET
	move	a2,a8		     ;TEXT POINTER
	clr	a0		     ;NO SLEEP
	movi	SPACING20,a10
	movi	RD15FONT,a11
	JSRP	STRCNRM 	     ;DO IT!
	mmfm	a12,a10,a11,a8	     ;POP THE STUFF.
	RETP

_adj_time_and_date
	movi	DAY_TABLE,a8		; Put Day of week up
	move	@_rtc_day,a0		; Day of week number (1-7)
	dec	a0
;	cmpi	6,a0
;	jrgt	_abad_day
	sll	5,a0
	add	a0,a8
	move	*a8,a4,L
	calla	copy_rom_string
	movi	DAYADJ_SETUP,a0
	callr	_setup_message
	movi	_setup_mess,a8
	JSRP	L_MESS
_abad_day
	movi	MONTH_TABLE,a8		; Put month of year up
	move	@_rtc_month,a0		; Month of year number (1 - 12)
	dec	a0
;	cmpi	11,a0
;	jrgt	_abad_month
	sll	5,a0
	add	a0,a8
	move	*a8,a4,L
	calla	copy_rom_string		; Copy month name to buffer
_abad_month
	move	@_rtc_date,a0		; Date
	cmpi	9,a0
	jrgt	_no_date_pad1
	movi	ZPAD,a4
	calla	concat_rom_string
_no_date_pad1
	move	@_rtc_date,a0		; Date
	movi	31,a1			; Maximum Date
	calla	dec_to_asc		; Convert Date to ascii
	calla	concat_string		; Add to buffer
	movi	MESS_HYEARS,a4		; , 19
	calla	concat_rom_string	; Add to buffer
	move	@_rtc_year,a0		; Year
	cmpi	9,a0
	jrgt	_no_year_pad1
	movi	ZPAD,a4
	calla	concat_rom_string
_no_year_pad1
	move	@_rtc_year,a0
	movi	99,a1			; Max year
	calla	dec_to_asc		; Convert Years to ascii
	calla	concat_string		; Add to buffer
	movi	DATEADJ_SETUP,a0
	callr	_setup_message
	movi	_setup_mess,a8
	JSRP	L_MESS

	clr	a0
	move	a0,@message_buffer
	move	@_rtc_hours,a0		; Hours
	jrnz	_hour_gz
	addk	12,a0
	jruc	_time_is_am1
_hour_gz
	cmpi	12,a0
	jrle	_time_is_am1
	move	@_rtc_hours,a0		; Hours
	subi	12,a0
_time_is_am1
	movi	12,a1			; Max hours
	calla	dec_to_asc
	calla	concat_string
	movi	TSEPERATOR,a4
	calla	concat_rom_string
	move	@_rtc_minutes,a0
	cmpi	9,a0
	jrgt	_no_min_pad1
	movi	ZPAD,a4
	calla	concat_rom_string
_no_min_pad1
	move	@_rtc_minutes,a0
	movi	59,a1			; Max Minutes
	calla	dec_to_asc
	calla	concat_string
	movi	TSEPERATOR,a4
	calla	concat_rom_string
	move	@_rtc_seconds,a0
	cmpi	9,a0
	jrgt	_no_sec_pad1
	movi	ZPAD,a4
	calla	concat_rom_string
_no_sec_pad1
	move	@_rtc_seconds,a0
	movi	59,a1			; Max Seconds
	calla	dec_to_asc
	calla	concat_string
	move	@_rtc_hours,a0		; Hours
	cmpi	11,a0
	jrgt	_time_is_pm1
	movi	TIME_AM,a4
	jruc	_tdone1
_time_is_pm1
	movi	TIME_PM,a4
_tdone1
	calla	concat_rom_string
	movi	TADJ_SETUP,a0
	callr	_setup_message
	movi	_setup_mess,a8
	JSRP	L_MESS
	RETP

_set_it_up
	calla	CLR_CUR
	movi	6,a1
	movk	5,a4
	calla	CADJ_BOX
	movi	1,a1
	clr	a4
	calla	CADJ_BOX
	movi	[ADJ_CULY+5,CS_HX+5],A3
	movi	[21,185],A4
	calla	BLNKAREA
	movi	[ADJ_CULY+31,CS_HX+5],A3
	movi	[58,185],A4
	calla	BLNKAREA
	SLEEPK	2			; I dare you to take this out
	RETP


YEAR_SET
	JSRP	_set_it_up
	movi	MESS_YEAR_SET,a2
	JSRP	_do_title
	JSRP	_adj_time_and_date
	RETP

MONTH_SET
	JSRP	_set_it_up
	movi	MESS_MONTH_SET,a2
	JSRP	_do_title
	JSRP	_adj_time_and_date
	RETP

DATE_SET
	JSRP	_set_it_up
	movi	MESS_DATE_SET,a2
	JSRP	_do_title
	JSRP	_adj_time_and_date
	RETP

DAY_SET
	JSRP	_set_it_up
	movi	MESS_DAY_SET,a2
	JSRP	_do_title
	JSRP	_adj_time_and_date
	RETP

HOUR_SET
	JSRP	_set_it_up
	movi	MESS_HOUR_SET,a2
	JSRP	_do_title
	JSRP	_adj_time_and_date
	RETP

MINUTE_SET
	JSRP	_set_it_up
	movi	MESS_MINUTE_SET,a2
	JSRP	_do_title
	JSRP	_adj_time_and_date
	RETP

SECOND_SET
	JSRP	_set_it_up
	movi	MESS_SECOND_SET,a2
	JSRP	_do_title
	JSRP	_adj_time_and_date
	RETP

; a0 = value code
; a8 = PTR to data struct
; TRASHES a0, a3, a2
_ts_val_up:
	mmtm	sp,a0,a2,a3
	sll	4,a0
	addi	_rtc_seconds,a0
	move	*a0,a3
	addk	1,a3
	move	*a8(AD_MAX),a2,L
	cmp	a3,a2
	jrge	_ts_vu_done
	move	*a8(AD_MIN),a3,L
_ts_vu_done
	andi	0ffh,a1
	move	a3,*a0
	mmfm	sp,a0,a2,a3
	rets

; a0 = value code
; a8 = PTR to data struct
; TRASHES a0, a3
_ts_val_down:
	mmtm	sp,a0,a3,a1
	sll	4,a0
	addi	_rtc_seconds,a0
	move	*a0,a3
	subk	1,a3
	move	*a8(AD_MIN),a1,L
	cmp	a1,a3
	jrge	_ts_vd_done
	move	*a8(AD_MAX),a3,L
_ts_vd_done
	andi	0ffh,a3
	move	a3,*a0
	mmfm	sp,a0,a3,a1
	rets

GEN_TS:
	movk	2,a0
	move	a0,@_switch_map_mode,L
	move	a9,*a13(PDATA),L
	move	a9,a8
	calla	CLR_MAIN
	calla	ADJ_INST
	JSRP	ST_STICK
	SLEEPK	2
TS_CHNG
	SLEEPK	1
	movi	31000h,a5
	JSRP	GETSTICK
	move	*a13(PDATA),a8,L
	move	a0,a1
	jrz	TS_CHNG
	move	*a8(AD_CMOS),a0,W	; Get What we are adjusting
	cmpi	3,a1
	jrz	TS_BUTT
	cmpi	2,a1
	jrz	TS_DOWN
	callr	_ts_val_up		; Incrment the value
	jruc	TS_JOIN
TS_DOWN:
	callr	_ts_val_down		; Decrement the value
TS_JOIN:
;	movi	beep1_snd,a3
;	calla	SNDSND
	JSRP	TS_UPDATE
	jruc	TS_CHNG
TS_UPDATE:
	move	*a8(AD_NAMEIT),a0,L
	movi	ROBO_LASER,a11
	jump	a0
TS_BUTT:

;	movi	beep2_snd,a3
;	calla	SNDSND
	JSRP	TS_UPDATE
	SLEEPK	5
TS_CAN:
	movk	1,a0
	move	a0,@_switch_map_mode,L
	RETP

**************************************************************************
*									 *
*	  VOLUME ADJUSTMENT SELECTED					 *
*									 *
**************************************************************************

	.bss	bar_height,16

	.bss	bar_height2,16
	.ref	set_volume_amode_diag
GO_AMODE_VOL
	calla	display_blank
	calla	dpageflip_off		;page flipping off
	
	calla	CLR_SCRN
	movi	M_AMODE_VOL,a2
	movi	ROBO_GREEN,a3
	JSRP	TOP_BOX

	create	FX_PID,background_sound	;noise

	movi	pf_volume_2,a8
	JSRP	L_MESS
	movi	pf_volume_3,a8
	JSRP	L_MESS

	movi	bxy,a0			;frame
	movi	bw|bh,a1
	movi	ROBO_BLUE,a2
	fcall	RECTANGLE,b6

	movi	bxy+>00030003,a0	;make frame by filling blue with black
	movi	bw|bh->00060006,a1
	movi	ROBO_BLACK,a2
	fcall	RECTANGLE,b6

	movi	pf_volume_4,a8		;MIN/MAX
	JSRP	L_MESS
	movi	pf_volume_5,a8
	JSRP	L_MESS

	clr	a0
	move	a0,@bar_height2
	movi	ADJAVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	calla	set_volume_amode_diag
	callr	vol_to_ht
	callr	adjust_bar_height2
	SLEEPK	2
	calla	display_unblank

vtop_1
	SLEEPK	1

	;check for done
	clr	a1
	clr	a0			;player 1
	calla	get_but_val_down
	or	a0,a1
	movk	1,a0			;player 2
	calla	get_but_val_down
	or	a0,a1
	movk	2,a0			;player 3
	calla	get_but_val_down
	or	a0,a1
	movk	3,a0			;player 4
	calla	get_but_val_down
	or	a0,a1

	move	@_coin_addr,a0,L
	move	*a0,a0
	not	a0
	andi	0e7ffh,a0
	or	a0,a1
	jrnz	vdone_1

	;check for a vol change
	clr	a0			;player 1
	calla	get_stick_val_cur
	or	a0,a1
	movk	1,a0			;player 2
	calla	get_stick_val_cur
	or	a0,a1
	movk	2,a0			;player 3
	calla	get_stick_val_cur
	or	a0,a1
	movk	3,a0			;player 4
	calla	get_stick_val_cur
	or	a0,a1
	andi	0011b,a1		;filter out left/right

	;listen to the coin door switches too.  OR them in.
	move	@_coin_addr,a0,L
	move	*a0,a0
	not	a0
	andi	0800h,a0
	srl	10,a0
	or	a0,a1
	move	@_coin_addr,a0,L
	move	*a0,a0
	not	a0
	andi	1000h,a0
	srl	12,a0
	or	a0,a1
	jrz	vtop_1

	;get the volume
	movi	ADJAVOLUME,a0
	calla	GET_ADJ

	;make sure the volume is in range
	BADCHK	a0,1,255,28		;reg, lo, hi, val if bad

	btst	JOYDN,a1
	jrnz	vdec_1

	;increment volume
	cmpi	255,a0
	jreq	vtop_1
	inc	a0
	calla	set_volume_amode_diag
	callr	vol_to_ht
	callr	adjust_bar_height2
	jruc	vtop_1

vdec_1
	cmpi	4,a0
	jreq	vtop_1
	dec	a0
	calla	set_volume_amode_diag
	callr	vol_to_ht
	callr	adjust_bar_height2
	jruc	vtop_1

vdone_1
;dont use a-mode sound level for diag.
	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	calla	set_volume

	movi	FX_PID,a0	;kill the background noise
	calla	KIL1C
	calla	nosounds

	RETP
	
GO_VOL

	calla	display_blank
	calla	dpageflip_off		;page flipping off
	
	calla	CLR_SCRN
	movi	M_GAME_VOL,a2
	movi	ROBO_GREEN,a3
	JSRP	TOP_BOX

	create	FX_PID,background_sound	;noise

;	movi	pf_volume_1,a8		;title/instructions
;	JSRP	L_MESS
	movi	pf_volume_2,a8
	JSRP	L_MESS
	movi	pf_volume_3,a8
	JSRP	L_MESS

	movi	bxy,a0			;frame
	movi	bw|bh,a1
;	movi	ROBO_GREEN,a2
	movi	ROBO_BLUE,a2
	fcall	RECTANGLE,b6

	movi	bxy+>00030003,a0	;make frame by filling blue with black
	movi	bw|bh->00060006,a1
	movi	ROBO_BLACK,a2
	fcall	RECTANGLE,b6

	movi	pf_volume_4,a8		;MIN/MAX
	JSRP	L_MESS
	movi	pf_volume_5,a8
	JSRP	L_MESS

	clr	a0
	move	a0,@bar_height
	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	calla	set_volume
	callr	vol_to_ht
	callr	adjust_bar_height
	SLEEPK	2
	calla	display_unblank

vol_loop_top
	SLEEPK	1

	;check for done
	clr	a1
	clr	a0			;player 1
	calla	get_but_val_down
	or	a0,a1
	movk	1,a0			;player 2
	calla	get_but_val_down
	or	a0,a1
	movk	2,a0			;player 3
	calla	get_but_val_down
	or	a0,a1
	movk	3,a0			;player 4
	calla	get_but_val_down
	or	a0,a1
;	clr	a1
;	clr	a0
;	calla	get_but_val_down
;	or	a0,a1
;	movk	1,a0
;	calla	get_but_val_down
;	or	a0,a1

	move	@_coin_addr,a0,L
	move	*a0,a0
	not	a0
	andi	0e7ffh,a0
	or	a0,a1
	jrnz	vol_loop_done

	;check for a vol change
	clr	a0			;player 1
	calla	get_stick_val_cur
	or	a0,a1
	movk	1,a0			;player 2
	calla	get_stick_val_cur
	or	a0,a1
	movk	2,a0			;player 3
	calla	get_stick_val_cur
	or	a0,a1
	movk	3,a0			;player 4
	calla	get_stick_val_cur
	or	a0,a1
	andi	0011b,a1		;filter out left/right

;	clr	a0
;	calla	get_stick_val_cur
;	move	a0,a1
;	movk	1,a0
;	calla	get_stick_val_cur
;	or	a0,a1
;	andi	0011b,a1		;filter out left/right

	;listen to the coin door switches too.  OR them in.
;	move	@COINS,a0		;the down switch
	move	@_coin_addr,a0,L
	move	*a0,a0
	not	a0
	andi	0800h,a0
	srl	10,a0
	or	a0,a1
;	move	@COINS,a0		;the up switch
	move	@_coin_addr,a0,L
	move	*a0,a0
	not	a0
	andi	1000h,a0
	srl	12,a0
	or	a0,a1
	jrz	vol_loop_top

	;get the volume
	movi	ADJVOLUME,a0
	calla	GET_ADJ

	;make sure the volume is in range
	BADCHK	a0,1,255,28		;reg, lo, hi, val if bad
;	cmpi	4,a0
;	jrge	vol_notlow
;	movi	4,a0
;	jruc	vol_nothigh
;vol_notlow
;	cmpi	255,a0
;	jrle	vol_nothigh
;	movi	255,a0
;vol_nothigh

	btst	JOYDN,a1
	jrnz	vol_dec

	;increment volume
	cmpi	255,a0
	jreq	vol_loop_top
	inc	a0
	calla	set_volume
	callr	vol_to_ht
	callr	adjust_bar_height
	jruc	vol_loop_top

vol_dec	;decrement volume
	cmpi	4,a0
	jreq	vol_loop_top
	dec	a0
	calla	set_volume
	callr	vol_to_ht
	callr	adjust_bar_height
	jruc	vol_loop_top

vol_loop_done
	movi	FX_PID,a0	;kill the background noise
	calla	KIL1C
	calla	nosounds

	RETP

#***************************************
* Adjusts the bar height
* >a0=new height (1-170)

 SUBRP	adjust_bar_height2

	move	a0,a1
	move	@bar_height2,a0
#adjust_loop
	cmp	a1,a0
	jreq	#done
	jrlt	#grow_bar

	movi	ROBO_BLACK,a2
	callr	vol_bar_line
	dec	a0
	jruc	#adjust_loop

#grow_bar	
	inc	a0
	movi	ROBO_RED,a2
	callr	vol_bar_line
	jruc	#adjust_loop

#done
	move	a0,@bar_height2
	rets


#***************************************
* Adjusts the bar height
* >a0=new height (1-170)

 SUBRP	adjust_bar_height

	move	a0,a1
	move	@bar_height,a0
#adjust_loop
	cmp	a1,a0
	jreq	#done
	jrlt	#grow_bar

	movi	ROBO_BLACK,a2
	callr	vol_bar_line
	dec	a0
	jruc	#adjust_loop

#grow_bar	
	inc	a0
	movi	ROBO_RED,a2
	callr	vol_bar_line
	jruc	#adjust_loop

#done
	move	a0,@bar_height
	rets


****************************************
* Draws a line on the volume bar, but won't overwrite green pixels (text)
* >a0=line index (not Ypos) >a2=color

 SUBRP	vol_bar_line

	PUSH	a0,a1,a2
	;convert the line index to a linear address
	sla	16,a0
	neg	a0
	addi	bxy+bh->00030000+59,a0	;various fudges here
	cvxyl	a0,a0

	;now write the color value to all non-green pixels
	movi	bw-6,a14
vbl_pixel_loop
	movb	*a0,a1
;	cmpi	ROBO_GREEN&0Fh,a1
	cmpi	ROBO_BLUE&0Fh,a1
	jreq	vbl_skip_pixel
	movb	a2,*a0
vbl_skip_pixel
	addk	8,a0
	dsj	a14,vbl_pixel_loop

	PULL	a0,a1,a2
	rets
	
****************************************
* Converts a 0-255 volume value to a 1-170 bar height value
* >a0=volume
* <a0=height

 SUBRP	vol_to_ht

	PUSH	a1
	move	a0,a1
	movi	169,a14
	mpyu	a14,a1
	movi	255,a14
	divu	a14,a1
	inc	a1
	move	a1,a0
	PULL	a1

	rets

****************************************
* Makes noises during sound test.
*

 SUBRP	background_sound
	clr	a3
	calla	SNDSND
	movi	1000,a3
	calla	SNDSND
	SLEEP	>40

bgsnd3	movi	sound_fx_table,a10
bgsnd6	move	*a10+,a3,W
	jrz	bgsnd3
	calla	SNDSND
	SLEEP	>20
	jruc	bgsnd6

sound_fx_table
	.word	>7
	.word	>36f			;!!!LOOK!!!
	.word	>33b
	.word	>92f
	.word	>36b
	.word	>900
	.word	>222
	.word	>f8
	.word	>f4
	.word	>4ba
	.word	>ca
	.word	0

pf_volume_2
	MESS_MAC RD7FONT,SPACING20,200,174+53,COLOR_YELLOW,STRCNRM,0
	.string	"ADJUST VOLUME WITH JOYSTICKS OR VOLUME BUTTONS",0,0
	.even

pf_volume_3
	MESS_MAC RD7FONT,SPACING20,200,184+53,ROBO_LASER,STRCNRM,0
	.string "ANY OTHER BUTTON TO QUIT",0,0
	.even

pf_volume_4
	MESS_MAC RD7FONT,SPACING20,201,vb_y+>05,ROBO_BLUE,STRCNRM,0
	.string	"MAX",0,0
	.even

pf_volume_5
	MESS_MAC RD7FONT,SPACING20,201,vb_y+>a0,ROBO_BLUE,STRCNRM,0
	.string	"MIN",0,0
	.even

vb_y		.set	>2f
vb_height	.set	171
bxy	.set	>002e0000+200->18

bh	.set	>b0*>10000
bw	.set	>30

bthickx	.set	3
bthicky	.set	3*>10000

volume_table
	.long	bh+3,bxy		; height:width  /  y:x coordinates
	.long	bh+3,bxy+bw		; height:width  /  y:x coordinates

	.long	bthicky+bw,bxy			; height:width  /  y:x coordinates
	.long	bthicky+bw+bthickx,bxy+bh	; height:width  /  y:x coordinates
	.long	0

**************************************************************************
*									 *
*	   CLR_CREDITS							 *
*									 *
*	   ROUTINE TO CLEAR OUT THE CREDITS POSTED ON THE GAME. 	 *
*									 *
**************************************************************************
CLR_CREDITS
	CALLA	NO_CREDS		;CALL THE ROUTINE THAT DOES IT
	RETP

DO_CLCOIN
	MOVI	MESS_CLCOIN,A8		;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	CLR_COINS,A9		;ROUTINE TO DO IT
	MOVI	MESS_CCNCONF,A10	;CONFIRMATION.
	JAUC	AREUSURE		;ASK EM......THEN RETURN!

CLR_COINS
	MOVI	FRST_C,A0
	MOVI	LAST_C,A1
	CALLA	CLR_AUDR
	RETP

DO_CLAUD
	MOVI	MESS_CLAUD,A8		;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	CLR_AUDITS,A9		;ROUTINE TO DO IT
	MOVI	MESS_CAUDCONF,A10	;CONFIRMATION.
	JAUC	AREUSURE		;ASK EM......THEN RETURN!

DO_CLPLRECS
	movi	MESS_CLPLRECS,A8	;CLEAR PLAYER RECORDS
	movi	clr_plr_records,a9	;ROUTINE TO DO IT
	movi	MESS_CLPLRECSCONF,a10	;CONFIRMATION.
	jauc	AREUSURE		;ASK EM......THEN RETURN!

	.global	clear_player_records
clr_plr_records
	calla	clear_player_records
	.ref	reset_world_records
	calla	reset_world_records
	RETP

CLR_AUDITS
	MOVI	FRSTGAUD,A0
	MOVI	LASTGAUD,A1
	CALLA	CLR_AUDR
;	CALLA	DUMP_FS 		;AND START THE "DUMP" RECORDS OVER
	RETP

DO_HSRES
	MOVI	MESS_HSRESET,A8
	MOVI	HSSOFT,A9
	MOVI	MESS_HSRCONF,A10
	JAUC	AREUSURE

HSSOFT
	CALLR	RES_ALL
	RETP				;PROGRAM TO DO THE JOB!

**************************************************************************
*
*	RES_ALL
*
*	RESET ALL TIME HIGH SCORE TABLE AND THE
*	HIGH SCORE RESET COUNTER.
*
**************************************************************************
RES_ALL
;	MOVI	ALL_TAB,A8		;ALWAYS CLEAR OUT TODAYS TABLE
;	CALLA	INIT_TB
	jauc	INIT_HSR		;RE-SET THE HIGH SCORE RESET COUNTER

DO_FACSET
	 MOVI	 MESS_FACSET,A8
	 MOVK	 1,A0
	 JRUC	 DEF_ADJ_PART

**************************************************************************
*									 *
*	   DO_DEF_ADJ	   THIS IS CALLED FROM UTILITY MENU TO		 *
*			   DO THE DEFAULT ADJUSTMENTS.			 *
*									 *
*	   DEF_ADJ_PART    THIS IS CALLED OUT OF THE FULL		 *
*			   FACTORY SETTING TO HANDLE THE		 *
*			   ADJUSTMENT PART.				 *
*									 *
*			   A8 MUST HAVE THE MESSAGE FOR "ARE YOU SURE"	 *
*			   A0 .NE. 0 FOR FULL FACTORY SETTINGS (ON	 *
*				     SUCCESS OF ADJUSTMENT PART 	 *
*									 *
**************************************************************************
DO_DEF_ADJ
	MOVI	MESS_DEF_ADJ,A8
	CLR	A0

DEF_ADJ_PART
	MOVE	A0,@FAC_FLAG,W		;INDICATE THIS IS ADJUSTMENTS ONLY
	MOVI	DEFADJSOFT,A9
	MOVI	NULL_ST,A10		;DON'T PRINT ANYTHING....ROUTINE WILL.
	JSRP	AREUSURE
	RETP

DEFADJSOFT
*
*	NOW SMASH THE CHECKSUM
*
	CALLA	FORM_ADC	       ;FORM THE CKSUM
	MOVE	A1,A0		       ;PUT IN CMOS WRITING REGGIE
	MOVI	ADJ_CKSUM,A7
	INC	A0		       ;THIS SMASHES ADJUSTMENTS
	CALLA	WC_WORD 	       ;AND STORE IT
*
*	NOW MAKE SURE ITS SMASHED
*
	CALLA	CMOS_VAL
	JRZ	AD_FAIL 	       ;WE CAN'T DO IT.....PRINT FAILURE.
*
*	NOW SET THE ADJUSTMENTS TO THE FACTORY VALUE.
*
	clr	a0		;Full
	CALLA	FAC_SET
	CALLA	CMOS_VAL	;IS IT OK NOW?
	JRNZ	AD_FAIL 	;NOPE...PRINT FAILURE

	MOVI	MESS_DEFCONF,A8 ;THIS IS SINGLE MESSAGE

	MOVE	@FAC_FLAG,A0,W	;DO WE NEED TO CLEAR THE TABLES?
	JRZ	DAX		;NOPE...POST SINGLE MESSAGE

	CALLA	CLR_SCRN	;CLEAR THE SCREEN FOR OUR MESSAGES.
	CALLR	FAC_STUF	;DO AUDITS AND HIGH SCORE TABLE

	MOVI	MESS_FFSCONF,A8 ;PRINT THE REST OF THE MESSAGES
	JSRP	L_MESS		;THAT DOES IT!

NOTABS
	RETP

*
*	ON A FULL FACTORY SETTING (EITHER REQUESTED OR
*	ADJUSTMENT FAILURE) THIS CLEARS THE AUDITS AND
*	HIGH SCORE TABLE.
*
FAC_STUF
	CALLA	CLR_AUD 	;CLEAR AUDITS TOO
	CALLR	RES_ALL 	;ALL TIME TABLE
	RETS

AD_FAIL
	MOVI	MESS_FACFAIL,A8
	JRUC	DAX

DEF_CAN
	MOVI	MESS_CANCELLED,A8
DAX
	CALLA	CLR_SCRN
	JSRP	SUR_MESS
	RETP
**************************************************************************
*									 *
*	   EXIST_LET							 *
*									 *
*	   IS THE E_INITS PROCESS RUNNING?				 *
*									 *
**************************************************************************
EXIST_LET
	MOVI	OPMES_PID,A0		       ;SETUP FOR THE EXISTP
	MOVI	0FFFFH,A1
	JAUC   EXISTP
**************************************************************************
*									 *
*	   BUILD_ST							 *
*									 *
*	   THIS IS CALLED TO TAKE THE STRING POINTED TO 		 *
*	   BY -A10- AND REMOVE LEADING AND TRAILING BLANKS		 *
*	   AND MOVE THE STRING TO "STRNGRAM".				 *
*									 *
*	   RETURN THE NUMBER OF TRAILING BLANKS IN A2.			 *
*	   RETURN .EQ. IF ALL BLANK!					 *
*									 *
**************************************************************************
BUILD_ST
	MMTM	SP,A0,A1,A3,A4,A5,A10
	CLR	A4		       ;A4 = ZERO UNTIL 1ST NON-BLANK
	MOVI	STRNGRAM-BYTE_SIZE,A5  ;LAST NON-SPACE CHAR
	MOVI	STRNGRAM,A1	     ;DESTINATION POINTER
	MOVI	CMESS_CHARS,A2	     ;CHAR COUNT

BSLOOP
	MOVB	*A10,A3 	     ;FETCH A BYTE
	ANDI	BYTE_MASK,A3	     ;KILL SIGN EXTEND.
	JRNZ	BS1		     ;NOT ZERO
	MOVI	SPACE,A3	     ;REPLACE ZERO WITH SPACE.

BS1
	CMPI	SPACE,A3	     ;IS IT A SPACE?
	JRZ	BS2		     ;IT IS...
*
*	NON-SPACE CHARACTER
*
	OR	A3,A4		     ;INDICATE 1ST NON-BLANK SEEN
	MOVE	A1,A5		     ;INDICATE THIS IS CURRENT TERMINATOR.
	JRUC	BS3

BS2
	MOVE	A4,A4		     ;HAS 1ST SPACE BEEN SEEN?
	JRZ	BS4		     ;NOT YET...DON'T STORE
BS3
	MOVB	A3,*A1		     ;STORE IT IN MEMORY
	ADDK	BYTE_SIZE,A1	     ;PUSH DESTINATION POINTER
BS4
	ADDK	BYTE_SIZE,A10	     ;PUSH SOURCE POINTER
	DSJS	A2,BSLOOP	     ;AND FINISH PARSE
*
*	 A5 NOW POINTS AT LAST NON-BLANK CHARACTER
*
	ADDK	BYTE_SIZE,A5	     ;THIS IS 1 BEYOND
	CLR	A2
	MOVB	A2,*A5		     ;TERMINATE WITH A ZERO.
*
*	FOR OUR RETURN, WE NEED TO COMPUTE THE NUMBER OF
*	TRAILING SPACES IGNORED.
*
	MOVE	A4,A4		     ;ALL BLANK?
	JRNZ	NOT_BLNK
	MOVI	CMESS_CHARS,A2	     ;ALL CHARS ARE TRAILING BLANKS
	JRUC	BL_EX		     ;RETURN THIS

NOT_BLNK
	MOVE	A1,A2		     ;THIS IS LAST CHAR WE WROTE
	SUB	A5,A2		     ;THIS IS NUMBER OF TRAILING SPACES (TIMES 8)
	SRL	3,A2		     ;DIVIDE BY 8 TO GET SPACES
BL_EX
	MOVE	A4,A4		     ;FLAG ZERO FOR ALL BLANK!
	MMFM	SP,A0,A1,A3,A4,A5,A10
	RETS

* A1 = <COLOR><PALETTE>
* A3 = DAG OF AREA [YPOS,XPOS]						
* A4 = [Y,X] SIZE OF AREA						

GO_RED
	MOVI	ROBO_RED,A1
	JAUC	SC_COL

GO_GREEN
	MOVI	ROBO_GREEN,A1
	JAUC	SC_COL

GO_BLUE
	MOVI	ROBO_BLUE,A1
SC_COL
	SLL	16,A1		;[color,palette]
	clr	a3		;[y,x] start
	movi	[256,399],a4	;[Y,X] SIZE OF AREA
	CALLA	FILLAREA	;THIS DOES THE SCREEN
	JAUC	WAIT_BUT	;NOW WAIT FOR ANY BUTTON!

GO_CPUTEST
	JAUC	DIAGCPUTEST

	
GO_CROSS
	CALLA	SCRCLR
	CALLA	CROSS_H

	movk	3,a1			; Any button map mode
	move	a1,@_switch_map_mode,L
;	JAUC	WAIT_BUT	     ;NOW WAIT FOR ANY BUTTON!
	JSRP	WAIT_BUT
	movk	1,a1
	move	a1,@_switch_map_mode,L	; Back to menu map mode
	RETP
;	JSRP	WAIT_BUT
;	CALLA	SCRCLR
;	CALLA	display_init
;	RETP

GO_SWTEST
	CALLA	SCRCLR
	clr	a0
	JSRP	SWITCHTEST
;	CALLA	SCRCLR
;	CALLA	display_init
	RETP

dipsw_test
	CALLA	SCRCLR
	movi	M_DIPTEST,a2
	movi	ROBO_GREEN,a3
	JSRP	TOP_BOX
	movk	1,a0			;DIP mode
	JSRP	SWITCHTEST
	RETP
	
;GO_ROMTEST
;	JAUC	ROM_CHK

GO_BARS
;	MOVI	8000H,A1
;	CLR	A0
;	CALLA	KILALL
	CALLA	SCRCLR
	MMTM	SP,A12,A13
	CALLA	COL_BARS
	MMFM	SP,A12,A13
	JAUC	WAIT_BUT	     ;NOW WAIT FOR ANY BUTTON!
;	JSRP	WAIT_BUT
;	CALLA	SCRCLR
;	CALLA	display_init
;	CALLA	COLRSTRT
;	RETP

DO_BURN
	MOVI	MESS_BURN,A8	     ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	BURN_IN,A9	     ;ENTRY POINT
	MOVI	MESS_BURN,A10	     ;THIS WILL NEVER BE SEEN!
	JAUC	AREUSURE	     ;ASK EM.

ANY_BUT
	MOVI	ANY_MENU,A8	     ;ANY BUTTON TO CONTINUE
	MOVK	1,A9		     ;CURSOR ON ENTRY 1
	JAUC	B_MENU		     ;DO IT....RETURN WHEN PRESSED.


********************************
* DIAGNOSTIC TESTS
*
* SOUND TEST STUFF

NCHAN		EQU	6	;DECLARE NUMBER OF ALLOWED CHANNELS
MUSICHAN	EQU	3	;THIS CHANNEL IS FOR THE TUNES


;RESETBIT	EQU	0FE00H	;Sound board reset bit


GO_STEST

	CALLA	CLR_SCRN

	movi	MEN_SOUNDTEST,a8
	movk	1,a9			;CURSOR ON 1st ENTRY

	JAUC	GEN_MENU	     	;THIS WILL RETURN TO LEVEL ABOVE US!

;	jsrp	B_MENU			;SEE IF THEY WANT PAGE 2.
;	cmpi	1,A8			;DID WE GET 1'ST ENTRY?
;	RETP

SNDTST
	MOVI	SNDMES,A8	;MESSAGE POINTER
SNDTLP
	CALLA	SCRCLR
	MOVI	M_STEST,A0	;SOUND TEST MESSAGE
	MOVI	>6080,A1
	CLR	A2
	MOVI	ROBO_WHITE,A3
	CALLA	STRNEW1
	MOVI	>B080,A1	;SCREEN ADDRESS
	MOVE	A8,A0
	CALLA	STRNEW1
	ADDK	8,A0
	MOVB	*A0,A5		;Channel
	ADDK	8,A0
	MOVB	*A0,A3		;Sound #
	sll	32-8,a3		;Kill sign extend
	srl	32-8,a3
	ADDK	8,A0
	CALLA	SNDSND
	MOVE	A0,A8
	MOVE	A13,A13		;AUTO-CYCLE?
	JRNE	SNDSLP		;NO
	CALLA	WDOGDIS
	MOVI	3000000,A13
SNDAUTO	DSJS	A13,SNDAUTO
	JRUC	SNDSLP1
SNDSLP
	SLEEP	120
SNDSLP1	
	MOVB	*A8,A5
	JRNE	SNDTLP
	MOVE	A13,A13		;AUTO CYCLE EXIT
	JREQ	SNDX1
	RETP

SNDX1	RETS

*SOUND TABLE
*MESSAGE,CHANNEL,SOUNDCODE
*
SNDMES	
	.byte	"TUNE 1 (1)",0
	.byte	MUSICHAN,1
	.byte	"NO WAY (E6)",0
	.byte	1,>e6
	.byte	"EXPL1 (30)",0
	.byte	4,>30
	.byte	"TUNE 2 (9)",0
	.byte	MUSICHAN,9
	.byte	"SPIDER BOUNCE (83)",0
	.byte	4,>83
	.byte	"MUSIC OFF (0)",0
	.byte	MUSICHAN,0
	.byte	0		;THE END OF TABLE
	.even
*******************************************************************************
DO_GENTEST

	CALLA   CLR_SCRN
        MOVI    M_DIGT,A2
        MOVI    ROBO_GREEN,A3
        JSRP    TOP_BOX			;PRINT TITLE BOX.

        CALLA   SURE_BOX		;PUT A NICE BOX UP!

	movi	#snd_testing_mess,a8
	JSRP	L_MESS

	;reset the board
	movi	SNDRSTBIT|32,a0		;pull bit low
;	move	a0,@COIN_COUNTERS,W
	move	@_coin_counter_addr,a8,L
	move	a0,*a8,W
	movi	8,a14			;wait a bit
	dsjs	a14,$

	movi	32,a0			;send it high again
;	move	a0,@COIN_COUNTERS,W
	move	@_coin_counter_addr,a8,L
	move	a0,*a8,W

	SLEEP	TSEC/4			;250ms wait

	movi	TSEC*7,a0		;wait for data available
	JSRP	poll_sdav

;	movb	@SOUNDR,a0		;read from the board (better be 0x79)
	move	@_sound_addr,a0,L
	movb	*a0,a0
	cmpi	79h,a0
	jrne	sdav_not79

	movi	TSEC/5,a0
	JSRP	poll_sdav		;great.  now wait for the bong count

;	movb	@SOUNDR,a0
	move	@_sound_addr,a0,L
	movb	*a0,a0
	sll	5,a0			;X32
	addi	diag_message_table,a0
	move	*a0,a8,L
	JSRP	L_MESS
	jauc	ANY_BUT

sdav_not79
;;	movi	AUD_SNDERR4,a0
;;	calla	AUD1
	.if	DEBUG			;sound board misbehaving.  should
	LOCKUP				; write a 0x79 after the checksum
	.endif				; tests.  it wrote something else.
        jauc    ANY_BUT

diag_message_table
	.long	#check_hardware
	.long	#board_ok
	.long	#bad_u2_checksum
	.long	#bad_u3_checksum
	.long	#bad_u4_checksum
	.long	#bad_u5_checksum
	.long	#bad_u6_checksum
	.long	#bad_u7_checksum
	.long	#bad_u8_checksum
	.long	#bad_u9_checksum
	.long	#bad_ram


****************************************
* Wait for sound board Data AVailable to go active, with timeout.
* >a0=timeout
* <a0=time remaining

 SUBR	poll_sdav
	PUSHP	a8
	move	a0,a8


;psdav_0	move	@SOUNDIRQ,a1,W

psdav_0
	move	@_soundirq_addr,a1,L
	move	*a1,a1,W

	btst	B_SDAV,a1
	jrz	psdav_found
	SLEEPK	1
	dsj	a8,psdav_0
	jruc	psdav_timeout

psdav_found
	nop

psdav_timeout
	move	a8,a0
	PULLP	a8
	RETP

	
****************************************
*blank the inside of the "are you sure" box
*
BLNK_SURE_BOX
	MOVI	[41H,29H],A3
	MOVI	[0F2H,166H]-[41H,29H],A4
	JAUC	BLNKAREA		;ITS BLANK!


M_DIGT
	.STRING	"GENERAL SOUND TEST",0,0
	.EVEN

SIRQ_DETECT
         MESS_MAC  RD7FONT,SPACING07,200,165,ROBO_GREEN,STRCNRM,0
	.STRING	"SOUND IRQ DETECT FUNCTIONAL.",0,0
	.EVEN

*
*MESSAGE FOR SOUND BOARD IRQ NOT WORKING
*
SIRQ_ERR
	MESS_MAC RD15FONT,SPACING07,200,95,COLOR_LF,STRCNRM,0
	.STRING	"** WARNING! **",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,120,COLOR_YELLOW,STRCNRM,0
	.STRING	"UNABLE TO DETECT SOUND BOARD IRQ.",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,135,COLOR_YELLOW,STRCNRM,0
	.STRING	"THIS MAY RESULT IN ERRANT SOUNDS.",0,0
	.EVEN

SIRQ_ERR2
         MESS_MAC  RD7FONT,SPACING07,200,165,ROBO_RED,STRCNRM,0
	.STRING	"ERROR - SOUND IRQ NOT DETECTED.",0,0
	.EVEN

DAC_LX	EQU	125
DAC_LX2	EQU     DAC_LX+52
DAC_ERR
	MESS_MAC RD7FONT,SPACING07,200,80,COLOR_LF,STRCNRM,0
	.STRING	"LISTEN FOR TONES:",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,DAC_LX,105,COLOR_YELLOW,STRLNRM,0
	.STRING	"0 TONES - CHECK HARDWARE",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,DAC_LX,117,COLOR_YELLOW,STRLNRM,0
	.STRING	"1 TONE",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,101,COLOR_YELLOW,STRCNRM,0
	.STRING	"2 TONES - BAD U2 CHECKSUM",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,111,COLOR_YELLOW,STRCNRM,0
	.STRING	"3 TONES - BAD U3 CHECKSUM",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,121,COLOR_YELLOW,STRCNRM,0
	.STRING	"4 TONES - BAD U4 CHECKSUM",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,131,COLOR_YELLOW,STRCNRM,0
	.STRING	"5 TONES - BAD U5 CHECKSUM",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,141,COLOR_YELLOW,STRCNRM,0
	.STRING	"6 TONES - BAD U6 CHECKSUM",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,151,COLOR_YELLOW,STRCNRM,0
	.STRING	"10 TONES - RAM TEST FAILED",0,0
	.EVEN
;	MESS_MAC RD7FONT,SPACING07,DAC_LX2,117,COLOR_YELLOW,STRLNRM,0
;	.STRING	"- SOUND BOARD OK",0,1
;	.EVEN
;	MESS_MAC RD7FONT,SPACING07,DAC_LX,129,COLOR_YELLOW,STRLNRM,0
;	.STRING	"2 TONES - RAM ERROR U2",0,1
;	.EVEN
;        MESS_MAC  RD7FONT,SPACING07,DAC_LX,141,COLOR_YELLOW,STRLNRM,0
;	.STRING	"3 TONES - ROM ERROR U3",0,0
;	.EVEN

#snd_testing_mess
	MESS_MAC RD7FONT,SPACING07,200,81,COLOR_YELLOW,STRCNRM,0
	.STRING	"TESTING",0,0
	.EVEN

#check_hardware
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"NO RESPONSE FROM SOUND SYSTEM",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,101,COLOR_YELLOW,STRCNRM,0
	.STRING	"CHECK HARDWARE",0,0
	.EVEN

#board_ok
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"1 TONE - SOUND BOARD OK",0,0
	.EVEN

#bad_u2_checksum
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"BAD U2 CHECKSUM",0,0
	.EVEN

#bad_u3_checksum
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"BAD U3 CHECKSUM",0,0
	.EVEN

#bad_u4_checksum
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"BAD U4 CHECKSUM",0,0
	.EVEN

#bad_u5_checksum
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"BAD U5 CHECKSUM",0,0
	.EVEN

#bad_u6_checksum
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"BAD U6 CHECKSUM",0,0
	.EVEN

#bad_u7_checksum
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"BAD U7 CHECKSUM",0,0
	.EVEN

#bad_u8_checksum
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"BAD U8 CHECKSUM",0,0
	.EVEN

#bad_u9_checksum
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"BAD U9 CHECKSUM",0,1
	.EVEN

#bad_ram
	MESS_MAC RD7FONT,SPACING07,200,91,COLOR_YELLOW,STRCNRM,0
	.STRING	"RAM TEST FAILED",0,1
	.EVEN

**************************************************************************
DO_PLAYSOUNDS

	MOVI	SND_INST,A8
	JSRP	L_MESS				;PUT INSTRUCTION OUT.

	JSRP	QSNDRST

	movi	[177,200-105],a4	;upper left
	movi	[238+16,200+104-1],a5	;bottom right
	MOVI	COLOR_WHITE,a9
	CALLR	STD_BORD

	CLR	A10
	movi	COLOR_LF,a0
	move	a10,a1
	callr	plot_sound
	move	a10,a3
	CALLR	MAKE_SOUND
#loop
	SLEEPK	1
	calla	fudge_switches2
	move	@fswitches_down,a0,L
	andi	START_BITS,a0
	jrnz	#exit

	move	@fswitches_down,a0,L
	andi	ACTION_BITS,a0
	jrz	#no_play_sound
	move	a10,a3
	CALLR	MAKE_SOUND
	jruc	#loop
#no_play_sound

	move	a10,a2
	move	@fswitches_cur,a0,L
	andi	UP_BITS,a0
	jrz	#no_down
	inc	a2
#no_down
	move	@fswitches_cur,a0,L
	andi	DOWN_BITS,a0
	jrz	#no_up
	dec	a2
#no_up
	cmp	a2,a10
	jreq	#loop		;no change

	push	a2
	movi	ROBO_BLACK,a0
	move	a10,a1
	callr	plot_sound
	pull	a10
	andi	7,a10
	SLEEPK	6
	movi	COLOR_LF,a0
	move	a10,a1
	callr	plot_sound
	move	a10,a3
	CALLR	MAKE_SOUND

	movi	30,a11
#wait_release
	calla	fudge_switches2
	move	@fswitches_cur,a0,L
	andi	UP_BITS|DOWN_BITS,a0
	jrz	#loop
	SLEEPK	1
	dsj	a11,#wait_release
	jruc	#loop

#exit
	JSRP	QSNDRST
	RETP

**************************************************************************
* colour in a0
* sound number 0-3 passed in a1
plot_sound
	PUSH	a10
	sll	5,a1			;x 32 bits
	addi	sounds_tab,a1		;base addr
	move	*a1,a1,L
	PUSH	a0,a1
	movi	SND_SETUP,a8
	calla	LM_SETUP		;GET CONFIRMATION DATA READY.
	PULL	a6,a8			;colour,string
	JSRP	LM_FINIS		;plot strings
	PULL	a10
	rets
*
*MAKE_SOUND - MAKE A SOUND TEST SOUND
*A3 = INDEX INTO TEST SOUND LIST
*NOTE: TRASHES A3
MAKE_SOUND
	SLL	4,A3
	ADDI	TEST_SOUND_TAB,A3
	MOVE	*A3,A3,W
	JAUC	SNDSND

**************************************************************************
*									 *
*	   MONITOR PATTERNS						 *
*									 *
**************************************************************************
GO_PATTERNS
	MOVI	MEN_PATTERNS,A8      ;PUT UP THE MENU AND GO!
	JAUC	GEN_MENU	     ;THIS WILL RETURN TO LEVEL ABOVE US!

*******************************************************************************
*******************************************************************************
*******************************************************************************
*
*	       A   U   D   I   T	D   I	S   P	L   A	Y   S
*
*******************************************************************************
*******************************************************************************
*******************************************************************************
**************************************************************************
*									 *
*	   AUDIT TABLE STRUCTURE					 *
*									 *
**************************************************************************

	STRUCT	0
	APTR	AUD_MESS	;*Text
	APTR	AUD_ROUTINE	;*Code to call or 0
	WORD	AUD_NUMBER	;Audit number to show or 0
	WORD	AUD_COLOR	;Color for this line
	LABEL	AUD_T_SIZE	;Size of structure

AMAC	.macro	mess,rout,audit,color
	.long	:mess:,:rout:
	.word	:audit:,:color:
	.endm

TXTLINE	.macro	s
	.byte	":s:",0
	.even
	.endm


AUD_LM		EQU	TIT_ULX		;SQUARE OFF AUDITS W/ HEADER.
AUD_RM		EQU	TIT_LRX
AUD_Y_STRT	EQU	54
AUD_DY		EQU	14

CP2_Y		EQU	156		;PART 2 OF COIN AUDIT PAGE.

********************************
* (doesn't display dollar values)

COIN_OCTO_AUDS
	.word	AUD_Y_STRT+50,12+8		;Y start, Y spacing
	.word	AUD_LM+30,AUD_RM-30		;LFT/RGT margin X
	AMAC	M_LCOIN2,0,AUDLCOIN,ROBO_YELLOW
	AMAC	M_RCOIN2,0,AUDRCOIN,ROBO_YELLOW
	AMAC	M_CCOIN2,0,AUDCCOIN,ROBO_YELLOW
;;	AMAC	amst_s,0,AUDBEGIN,ROBO_GREEN	;On parachute
;;	AMAC	M_START,STARTS,0,ROBO_GREEN
;;	AMAC	M_PAIDC,0,AUDPAIDC,ROBO_WHITE
;;	AMAC	M_SERV,0,AUDSERV,>1212
;;	AMAC	M_PLAYS,DOPLAYS,0,ROBO_YELLOW
	.long	0



********************************
* TOP HALF OF COIN AUDIT PAGE 1 TABLE

COIN_AUDS
	.word	AUD_Y_STRT,11			;Y start, Y spacing
;	.word	AUD_Y_STRT,12+5			;Y start, Y spacing
	.word	AUD_LM+13,AUD_RM-13			;LFT/RGT margin X
	AMAC	M_LCOIN,0,AUDLCOIN,ROBO_YELLOW
	AMAC	M_RCOIN,0,AUDRCOIN,ROBO_YELLOW
	AMAC	M_CCOIN,0,AUDCCOIN,ROBO_YELLOW
	AMAC	M_XCOIN,0,AUDXCOIN,ROBO_YELLOW
	AMAC	M_DBV,0,AUD_DBV,ROBO_YELLOW
	AMAC	amst_s,0,AUDBEGIN,ROBO_GREEN	;On parachute
	AMAC	M_START,STARTS,0,ROBO_GREEN
;	AMAC	M_CONTO,0,AUD_CONTOFFERED,ROBO_GREEN
;	AMAC	M_CONT,0,AUD_CONTTAKEN,ROBO_GREEN
	.long	0

COIN1_AUDS
	.word	AUD_Y_STRT+116,AUD_DY
	.word	AUD_LM+13,AUD_RM-13
	AMAC	M_PAIDC,0,AUDPAIDC,ROBO_WHITE
	.long	0

COIN2_AUDS
	.word	AUD_Y_STRT+85,11		;Y start, Y spacing
	.word	AUD_LM+13,AUD_RM-13		;LFT/RGT margin X
	AMAC	M_SERV,0,AUDSERV,>1212
	AMAC	M_PLAYS,DOPLAYS,0,ROBO_YELLOW
	.long	0

amst_s	TXTLINE	"ATTRACT MODE STARTS"
M_START TXTLINE	"MID GAME STARTS"
M_CONTO	TXTLINE	"CONTINUES OFFERED"
M_CONT	TXTLINE	"CONTINUES TAKEN"
M_EXTRA	TXTLINE	"EXTRA MEN COLLECTED/EARNED"
M_P1MIN	TXTLINE	"HOURS OF SINGLE PLAY"
M_P2MIN	TXTLINE	"HOURS OF DUAL PLAY"
M_HOURS	TXTLINE	"TOTAL HOURS OF PLAY"
M_AVGT	.byte	"AVG. ",ASCII_DQ,"PLAYER",ASCII_DQ," GAME TIME (MIN.)",0
	.even


;*	  BOTTOM HALF OF COIN AUDIT PAGE 1 TABLE
;COIN_A2	.WORD CP2_Y 		;Y START
;	.WORD AUD_DY		;Y BETWEEN ENTRIES
;	.WORD AUD_LM		;LEFT MARGIN X
;	.WORD AUD_RM		;RIGHT MARGIN X
;	AMAC	M_START,STARTS,0,ROBO_YELLOW
;	AMAC	M_CONT,CONTINS,0,ROBO_YELLOW
;	AMAC	M_PLAYS,DOPLAYS,0,ROBO_YELLOW
;	AMAC	M_HSLEFT,DOHSLEFT,0,ROBO_YELLOW
;	.LONG 0

**************************************************************************
*									 *
*	   COIN_D1							 *
*									 *
*	   THIS IS TOP HALF OF DETAILED COIN AUDIT PAGE 		 *
*	   ITS THE SAME AS THE OTHER COIN PAGE WITH THE Y POSITIONING	 *
*	   A LITTLE DIFFERENT						 *
*									 *
**************************************************************************
;COIN_D1
;	  .WORD   39H			;Y START
;	  .WORD   11H			;Y BETWEEN ENTRIES
;	  .WORD   AUD_LM		;LEFT MARGIN X
;	  .WORD   AUD_RM		;RIGHT MARGIN X
;	  AMAC	  M_LCOIN,0,AUDLCOIN,ROBO_YELLOW
;	  AMAC	  M_CCOIN,0,AUDCCOIN,ROBO_YELLOW
;	  AMAC	  M_RCOIN,0,AUDRCOIN,ROBO_YELLOW
;	  .LONG   0
*
*	 DOOR CLOSED AUDITS.
*
;COIN_D2
;	  .WORD   090H			;Y START
;	  .WORD   11H			;Y BETWEEN ENTRIES
;	  .WORD   AUD_LM		;LEFT MARGIN X
;	  .WORD   AUD_RM		;RIGHT MARGIN X
;	  AMAC	  M_LCOIN,0,AUDLCDC,ROBO_YELLOW
;	  AMAC	  M_CCOIN,0,AUDCCDC,ROBO_YELLOW
;	  AMAC	  M_RCOIN,0,AUDRCDC,ROBO_YELLOW
;	  .LONG   0

**************************************************************************
*									 *
*	   GAME PLAY AUDIT SCREEN					 *
*									 *
**************************************************************************

	.asg	45,LM
	.asg	400-45,RM

GAME_AUDS
	.word	55-10,11,LM,RM ;Y start, Y spacing, L margin, R margin

	AMAC	str_totuptime,	prn_uptime,0,	ROBO_WHITE
	AMAC	str_totpltime,	prn_pltime,0,	ROBO_WHITE
	AMAC	str_totplys,	0,AUD_TOTPLYS,	ROBO_GREEN
	AMAC	str_totstarts,	0,AUD_TOTSTARTS,ROBO_GREEN
	AMAC	str_avginit,	prn_initpct,0,	ROBO_ORANGE
	AMAC	str_avgfulg,	prn_fullgmpct,0,ROBO_YELLOW
	AMAC	str_tot1plyt,	prn_1plpct,0,	ROBO_CYAN
	AMAC	str_tot2plyt,	prn_2plpct,0,	ROBO_CYAN
	AMAC	str_tot3plyt,	prn_3plpct,0,	ROBO_CYAN
	AMAC	str_tot4plyt,	prn_4plpct,0,	ROBO_CYAN
	AMAC	str_ply21st,	prn_1stqtrpct,0,ROBO_GREY
	AMAC	str_ply22nd,	prn_1sthlfpct,0,ROBO_GREY
	AMAC	str_ply23rd,	prn_3rdqtrpct,0,ROBO_GREY
	AMAC	str_ply2comp,	prn_comppct,0,	ROBO_GREY
	AMAC	str_2ovrtime,	prn_ovtmpct,0,	ROBO_BLUE
;	AMAC	str_creatd_plr,	0,AUD_CREATED_PLR,ROBO_RED
;	AMAC	str_snderr,	0,AUD_SNDERR,	ROBO_RED
	.long	0


GAME_AUDS1a
	.word	55-10,11,LM,RM ;Y start, Y spacing, L margin, R margin

	AMAC	str_snderr,	0,AUD_SNDERR,	ROBO_RED
;;;	AMAC	str_snderr1,	0,AUD_SNDERR1,	ROBO_RED
	AMAC	str_lockups,	0,AUDLOCK,	ROBO_RED
	AMAC	str_lockups2,	0,AUD_LOCKUP,	ROBO_RED
;	AMAC	str_cliplock,	0,AUD_CLIPLOCK,	ROBO_RED
	AMAC	str_avgscr,	prn_avgscr,0,	ROBO_GREEN
	AMAC	str_avgplyscr,	prn_avghumscr,0,ROBO_GREEN
	AMAC	str_avgcpuscr,	prn_avgcpuscr,0,ROBO_GREEN
	AMAC	str_avgwin,	prn_avgwin,0,	ROBO_CYAN
	AMAC	str_avglos,	prn_avglos,0,	ROBO_CYAN
	AMAC	str_cpuvic,	prn_cpuwins,0,	ROBO_PINK
	AMAC	str_cpuwin,	0,AUD_CPUWINMARG,ROBO_ORANGE
	AMAC	str_cpulos,	0,AUD_CPULOSMARG,ROBO_ORANGE
	AMAC	str_scrdiff,	prn_avgdropdif,0,ROBO_YELLOW
;	AMAC	str_drpcpu,	prn_dropcpu,0,	ROBO_GREY
;	AMAC	str_drphum,	prn_drophum,0,	ROBO_GREY
	AMAC	str_humans,	prn_humans,0,	ROBO_GREY
	AMAC	str_leftwins,	prn_leftwins,0,	ROBO_GREY
;	AMAC	str_numhotstrks,prn_numhot,0,	ROBO_BLUE
;	AMAC	str_hotstrkpts,	prn_hotpts,0,	ROBO_BLUE

	.long	0

GAME_AUDS1b
	.word	55,11,LM-5,RM ;Y start, Y spacing, L margin, R margin

	AMAC	str_numhotstrks,prn_numhot,0,	ROBO_RED
	AMAC	str_hotstrkpts,	prn_hotpts,0,	ROBO_RED

	AMAC	str_tm_fire,0,AUD_TM_FIRE,	ROBO_YELLOW
	AMAC	str_tm_fire_pts,prn_avg_tm_pts,0,ROBO_YELLOW

	AMAC	str_alley_oops,0,AUD_ALLEYOOPS,	ROBO_GREY
	AMAC	str_dble_dnks,0,AUD_DBLE_DNKS,ROBO_GREY

	AMAC	str_creatd_plr,	0,AUD_CREATED_PLR,ROBO_GREEN
	AMAC	str_atb_pts_inc,0,AUD_ATRB_PTS_INC,ROBO_GREEN

	.long	0


str_creatd_plr	TXTLINE	"CREATED A PLAYER"
str_tm_fire	TXTLINE	"TOTAL TEAM FIRES"
str_tm_fire_pts	TXTLINE	"AVG. PTS. SCORED DURING TEAM FIRE"
str_alley_oops	TXTLINE	"TOTAL ALLEY-OOPS"
str_dble_dnks	TXTLINE	"TOTAL DOUBLE DUNKS"
str_atb_pts_inc TXTLINE "ATTRIBUTE POINT INCREASE AWARDS"
str_snderr	TXTLINE	"SND ERR (DAV & READ BACK)"
;str_snderr1	TXTLINE	"SND ERR #1 (IRQ)"
;str_snderr2	TXTLINE	"SND ERR #2 (DATA AVAILABLE)"
;str_snderr3	TXTLINE	"SND ERR #3 (READ BACK)"

str_lockups	TXTLINE	"DOGS"
str_lockups2	TXTLINE	"PROCESS KO"
;str_cliplock	TXTLINE	"CLIP KO"
str_totuptime	TXTLINE	"TOTAL GAME UPTIME (HRS:MINS)"
str_totpltime	TXTLINE	"TOTAL GAME PLAY TIME (HRS:MINS)"
str_totplys	TXTLINE	"GAMES STARTED"
str_totstarts	TXTLINE	"INDIVIDUAL PLAYER STARTS"
str_avginit	TXTLINE	"INITIALS ENTERED"
str_avgfulg	TXTLINE	"FULL GAMES PURCHASED"
str_tot1plyt	TXTLINE	"1 PLAYER PLAY"
str_tot2plyt	TXTLINE	"2 PLAYER PLAY"
str_tot3plyt	TXTLINE	"3 PLAYER PLAY"
str_tot4plyt	TXTLINE	"4 PLAYER PLAY"
str_ply21st	TXTLINE	"FINISHED 1ST QUARTER"
str_ply22nd	TXTLINE	"FINISHED 2ND QUARTER"
str_ply23rd	TXTLINE	"FINISHED 3RD QUARTER"
str_ply2comp	TXTLINE	"FINISHED 4TH QUARTER"
str_2ovrtime	TXTLINE	"GONE TO OVERTIME"
str_avgscr	TXTLINE	"AVERAGE SCORE"
str_avgplyscr	TXTLINE	"AVERAGE HUMAN SCORE"
str_avgcpuscr	TXTLINE	"AVERAGE CPU SCORE"
str_avgwin	TXTLINE	"AVERAGE WINNING SCORE"
str_avglos	TXTLINE	"AVERAGE LOSING SCORE"
str_cpuvic	TXTLINE	"CPU VICTORIES"
str_cpuwin	TXTLINE	"GREATEST CPU VICTORY MARGIN"
str_cpulos	TXTLINE	"GREATEST CPU LOSS MARGIN"
str_scrdiff	TXTLINE	"SCORE DIFFERENTIAL AT DROPOUT"
;str_drpcpu	TXTLINE	"DROPOUTS VS CPU"
;str_drphum	TXTLINE	"DROPOUTS VS HUMAN"
str_humans	TXTLINE	"HUMAN VS. HUMAN - GAMES PLAYED"
str_leftwins	TXTLINE	"LSW"
str_numhotstrks	TXTLINE	"TOTAL HOT STREAKS STARTED"
str_hotstrkpts	TXTLINE	"AVERAGE PTS. SCORED ON HOT STREAK"
str_pct		TXTLINE	"%"
	.even

	.asg	10,COL1
	.asg	COL1+200,COL2
	.asg	160,WIDTH


GAME_AUD2a
	.word	60-4,11,COL1,COL1+WIDTH ;Y start, Y spacing, L margin, R margin

	AMAC	str_atl,0,AUD_ATL,ROBO_GREEN
	AMAC	str_bos,0,AUD_BOS,ROBO_WHITE
	AMAC	str_cha,0,AUD_CHA,ROBO_BLUE
	AMAC	str_chi,0,AUD_CHI,ROBO_YELLOW
	AMAC	str_cle,0,AUD_CLE,ROBO_CYAN
	AMAC	str_dal,0,AUD_DAL,ROBO_PURPLE
	AMAC	str_den,0,AUD_DEN,ROBO_GREEN
	AMAC	str_det,0,AUD_DET,ROBO_WHITE
	AMAC	str_gld,0,AUD_GLD,ROBO_BLUE
	AMAC	str_hou,0,AUD_HOU,ROBO_YELLOW
	AMAC	str_ind,0,AUD_IND,ROBO_CYAN
	AMAC	str_lac,0,AUD_LAC,ROBO_PURPLE
	AMAC	str_lal,0,AUD_LAL,ROBO_GREEN
	AMAC	str_mi, 0,AUD_MI, ROBO_WHITE
	AMAC	str_mil,0,AUD_MIL,ROBO_BLUE
	.long	0

GAME_AUD2b
	.word	60-4,11,COL2,COL2+WIDTH ;Y start, Y spacing, L margin, R margin

	AMAC	str_min,0,AUD_MIN,ROBO_WHITE
	AMAC	str_nj, 0,AUD_NJ, ROBO_BLUE
	AMAC	str_jy, 0,AUD_JY, ROBO_YELLOW
	AMAC	str_orl,0,AUD_ORL,ROBO_CYAN
	AMAC	str_phi,0,AUD_PHI,ROBO_PURPLE
	AMAC	str_phx,0,AUD_PHX,ROBO_GREEN
	AMAC	str_por,0,AUD_POR,ROBO_WHITE
	AMAC	str_sac,0,AUD_SAC,ROBO_BLUE
	AMAC	str_san,0,AUD_SAN,ROBO_YELLOW
	AMAC	str_sea,0,AUD_SEA,ROBO_CYAN
	AMAC	str_tor,0,AUD_TOR,ROBO_BLUE
	AMAC	str_uta,0,AUD_UTA,ROBO_PURPLE
	AMAC	str_van,0,AUD_VAN,ROBO_WHITE	;3 new teams
	AMAC	str_was,0,AUD_WAS,ROBO_GREEN
	.long	0


 .if 0
ROBO_GREY       EQU     0101H	;[0E0H-223,0E0H-223]
ROBO_WHITE      EQU     0202H	;[0E1H-223,0E1H-223]
ROBO_RED        EQU     0303H	;[0E2H-223,0E2H-223]
ROBO_ORANGE     EQU     0404H	;[0E3H-223,0E3H-223]
ROBO_YELLOW     EQU     0505H	;[0E4H-223,0E4H-223]
ROBO_GREEN      EQU     0606H	;[0E5H-223,0E5H-223]
ROBO_BLUE       EQU     0707H	;[0E6H-223,0E6H-223]
ROBO_LF         EQU     03E3EH 
ROBO_CYAN       EQU     0E0EH	;[0EDH-223,0EDH-223]
ROBO_DECAY      EQU     03F3FH
ROBO_RGOLD      EQU     0A0AH	;[0E9H-223,0E9H-223]
ROBO_LASER      EQU     03E3EH
ROBO_LASER2	EQU	03F3FH
ROBO_BLUWH      EQU     0C0CH	;[0EBH-223,0EBH-223]
ROBO_PINK       EQU     0303H	;[0E2H-223,0E2H-223]
ROBO_SKY        EQU     0D0DH	;[0ECH-223,0ECH-223]  ;LAST COLOR IN ROBO IS "SKY" COLOR
ROBO_PURPLE     EQU     ROBO_SKY     ;PURPLE FOR TEST MODE
ROBO_BLACK	EQU	1414H	;BLACK AS COAL
 .endif


str_atl	TXTLINE	"ATLANTA"
str_bos	TXTLINE	"BOSTON"
str_cha	TXTLINE	"CHARLOTTE"
str_chi	TXTLINE	"CHICAGO"
str_cle	TXTLINE	"CLEVELAND"
str_dal	TXTLINE	"DALLAS"
str_den	TXTLINE	"DENVER"
str_det	TXTLINE	"DETROIT"
str_gld	TXTLINE	"GOLDEN STATE"
str_hou	TXTLINE	"HOUSTON"
str_ind	TXTLINE	"INDIANA"
str_lac	TXTLINE	"L.A. CLIPPERS"
str_lal	TXTLINE	"L.A. LAKERS"
str_mi	TXTLINE	"MIAMI"
str_mil	TXTLINE	"MILWAUKEE"
str_min	TXTLINE	"MINNESOTA"
str_nj	TXTLINE	"NEW JERSEY"
str_jy	TXTLINE	"NEW YORK"
str_orl	TXTLINE	"ORLANDO"
str_phi	TXTLINE	"PHILADELPHIA"
str_phx	TXTLINE	"PHOENIX"
str_por	TXTLINE	"PORTLAND"
str_sac	TXTLINE	"SACRAMENTO"
str_san	TXTLINE	"SAN ANTONIO"
str_sea	TXTLINE	"SEATTLE"
str_tor	TXTLINE	"TORONTO"
str_uta	TXTLINE	"UTAH"
str_van	TXTLINE	"VANCOUVER"
str_was	TXTLINE	"WASHINGTON"
;str_los	TXTLINE	"LOS ANGELES"
	.even

#*****************************************************************************
* total uptime
prn_uptime
	movi	AUD_UPTIME,a0
	calla	GET_AUD
					;* 5 sec incs / 60 (sec p/min) = /12
	movk	12,a0
	divu	a0,a1			;mins
	jruc	P_TIME


#*****************************************************************************
* actual play time
prn_pltime
	movi	AUD_PLTIME,a0
	calla	GET_AUD
					;* 5 sec incs / 60 (sec p/min) = /12
	movk	12,a0
	divu	a0,a1			;mins
	jruc	P_TIME


#*****************************************************************************
* percentage of players entering initials
prn_initpct
	movi	AUD_TOTPLYS,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_INITENTRD,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK

#*****************************************************************************
* percentage of players purchasing full game
prn_fullgmpct
	movi	AUD_PRESTARTS,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_PURCHASED,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK

#*****************************************************************************
* percentage of 1 player play
prn_1plpct
	movi	AUD_PLTIME,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_1PLAYTIME,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK

#*****************************************************************************
* percentage of 2 player play
prn_2plpct
	movi	AUD_PLTIME,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_2PLAYTIME,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK


#*****************************************************************************
* percentage of 3 player play
prn_3plpct
	movi	AUD_PLTIME,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_3PLAYTIME,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK


#*****************************************************************************
* percentage of 4 player play
prn_4plpct
	movi	AUD_PLTIME,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_4PLAYTIME,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK


#*****************************************************************************
* percentage of games finished 1st quarter
prn_1stqtrpct
	movi	AUD_TOTPLYS,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_1STQUARTR,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK


#*****************************************************************************
* percentage of games finished 1st half
prn_1sthlfpct
	movi	AUD_TOTPLYS,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_HALFTIME,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK


#*****************************************************************************
* percentage of games finished 3rd quarter
prn_3rdqtrpct
	movi	AUD_TOTPLYS,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_3RDQUARTR,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK


#*****************************************************************************
* percentage of games finished 4th quarter
prn_comppct
	movi	AUD_TOTPLYS,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_COMPLETED,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK


#*****************************************************************************
* percentage of games gone to overtime
prn_ovtmpct
	movi	AUD_TOTPLYS,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_OVERTIME,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK


#*****************************************************************************
*
prn_avgscr
	movi	AUD_COMPLETED,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_WIN_SCORE,a0
	calla	GET_AUD
	srl	1,a1			;/2
	PUSH	a1
	movi	AUD_LOS_SCORE,a0
	calla	GET_AUD
	srl	1,a1			;/2
	PULL	a3
	add	a1,a3
	move	a3,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	NUMBER_WORK


#*****************************************************************************
*
prn_avgwin
	movi	AUD_COMPLETED,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_WIN_SCORE,a0
	calla	GET_AUD
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	NUMBER_WORK


#*****************************************************************************
*
prn_avglos
	movi	AUD_COMPLETED,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_LOS_SCORE,a0
	calla	GET_AUD
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	NUMBER_WORK


#*****************************************************************************
*
prn_cpuwins
	movi	AUD_COMPLETED,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_CPUWINS,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK


#*****************************************************************************
*
prn_leftwins
	movi	AUD_HUMANVSHUMAN,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_WINSONLEFT,a0
	calla	GET_AUD
	movi	100,a0
	mpyu	a0,a1
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	PERCENT_WORK

#*****************************************************************************
*
prn_humans
	movi	AUD_HUMANVSHUMAN,a0
	calla	GET_AUD
	move	a1,a3
	jruc	NUMBER_WORK

;#*****************************************************************************
;*
;prn_dropcpu
;	movi	AUD_NUMDROPOUT,a0
;	calla	GET_AUD
;	move	a1,a4
;
;	movi	AUD_DROPVSCPU,a0
;	calla	GET_AUD
;	movi	100,a0
;	mpyu	a0,a1
;	move	a1,a2
;	move	a4,a0
;	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
;	move	a2,a3
;	jruc	PERCENT_WORK
;
;
;#*****************************************************************************
;*
;prn_drophum
;	movi	AUD_NUMDROPOUT,a0
;	calla	GET_AUD
;	move	a1,a4
;
;	movi	AUD_DROPVSHUM,a0
;	calla	GET_AUD
;	movi	100,a0
;	mpyu	a0,a1
;	move	a1,a2
;	move	a4,a0
;	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
;	move	a2,a3
;	jruc	PERCENT_WORK


#*****************************************************************************
*
prn_avgcpuscr

	movi	AUD_CPUGAMES,a0		;a cpu team
	calla	GET_AUD
	move	a1,a4

	movi	AUD_CPUSCORES,a0
	calla	GET_AUD
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	NUMBER_WORK


#*****************************************************************************
*
prn_avghumscr

	movi	AUD_HUMGAMES,a0		;a human team
	calla	GET_AUD
	move	a1,a4

	movi	AUD_HUMSCORES,a0
	calla	GET_AUD
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	NUMBER_WORK


#*****************************************************************************
*	average score differential at dropout
prn_avgdropdif

	movi	AUD_NUMDROPOUT,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_DROPDIFF,a0
	calla	GET_AUD
	move	a1,a2
	move	a4,a0
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	NUMBER_WORK

#*****************************************************************************
prn_numhot

	movi	AUD_NUMHOTSTRK,a0
	calla	GET_AUD
	move	a1,a3
	jruc	NUMBER_WORK

#*****************************************************************************
*	average # points scored per hot streak
prn_hotpts

	movi	AUD_HOTSTRKPTS,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_NUMHOTSTRK,a0
	calla	GET_AUD
	move	a1,a0
	move	a4,a2
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	NUMBER_WORK

#*****************************************************************************
*	average # points scored per hot streak
prn_avg_tm_pts

	movi	AUD_TM_FIRE_PTS,a0
	calla	GET_AUD
	move	a1,a4

	movi	AUD_TM_FIRE,a0
	calla	GET_AUD
	move	a1,a0
	move	a4,a2
	callr	ROUNDED_A0_INTO_A2	;DIVIDES A0 INTO A2. RESULT IN A2
	move	a2,a3
	jruc	NUMBER_WORK

**************************************************************************
* NUMBER_WORK - Print audit number
* A3=#

PERCENT_WORK
	MOVI	MESS_AUD_NUM,A8 	;SETUP FOR AUDIT NUMBER
	CALLA	LM_SETUP

	MOVE	A3,A8			;NOW WE HAVE BINARY NUMBER
	CALLA	HEXTOASC		;NOW WE POINT TO THE STRING.

	PUSH	a8
	move	a8,a7
	movi	str_pct,a8
	CALLA	STRCAT
	PULL	a8

	PUSH	a0
	move	*a13(AT_RX),a0
	PUSHP	a0
	addi	13,a0
	move	a0,*a13(AT_RX)
	PULL	a0

	move	*a13(AT_PTR),a6,L	;Get *audit
	move	*a6(AUD_COLOR),a6

	JSRP	RIGHT_FINISH

	PULLP	a0
	move	a0,*a13(AT_RX)		;restore right margin
	RETP

#*****************************************************************************

MISC_AUD
	.word	50,18,AUD_LM,AUD_RM		;Y start, Y spacing, LMar, RMar
	AMAC	M_SECBON,0,AUDSURV,ROBO_YELLOW	;WARPS TAKEN
	AMAC	M_HIDB,0,AUDBONE,ROBO_YELLOW	;GAMES NOT FINISHED
	AMAC	M_PLAYS,DOPLAYS,0,ROBO_YELLOW	;PLAYS ON TOP
	AMAC	M_P1MIN,DO_P1MIN,0,ROBO_YELLOW
	AMAC	M_P2MIN,DO_P2MIN,0,ROBO_YELLOW
	AMAC	M_AVGT,DO_AVGT,0,ROBO_YELLOW
	AMAC	M_ELAPSE,DO_ELAPSE,0,ROBO_YELLOW
	AMAC	adiff_s,diff_prt,0,>1212
	.LONG	0

adiff_s	TXTLINE	"GAME DIFFICULTY LEVEL"


	.IF	0
********************************
* Display revision message
* Do coin DIP if enabled
* Check cmos, if bad reset to factory

FACCHECK
	calla	dpageflip_off

	CALLA	CLR_SCRN
	MOVI	DIAGP,A0
	CALLA	pal_getf

	MOVI	AUDSTAT,A0		;CLEAR GAME STATE AUDIT
	CLR	A1
	CALLA	STORE_AUDIT

	MOVI	ROM_NAME,A2
	MOVI	ROBO_LF,A3
	JSRP	TOP_BOX			;PRINT TITLE BOX.

	.if	YUNIT
	move	@SWITCH+30h,a0
	btst	6,a0
	jrnz	fc40			;No DIP coinage?

	movk	1,a0			;Just coinage
	calla	FAC_SET
	movi	dipcoinage_mess,a8
	JSRP	L_MESS
fc40
	.endif

	.if	DEBUG
	SLEEPK	1			;Show it DEBUG
	.else
	SLEEP	120			;Show it
	.endif

	CALLA	CMOS_VAL		;CMOS BOGUS?
	JRZ	FACC0			;NO

	MOVI	MESS_RESET,A8		;ERROR MESSAGE
	JSRP	L_MESS
	SLEEP	60

	CALLR	RES_ALL			;ALL TIME TABLE
	clr	a0			;Full
	CALLA	FAC_SET

	MOVI	MESS_FAC,A8
	CALLA	LM_SETUP		;GET CONFIRMATION DATA READY.
	JSRP	LM_FINIS
	SLEEP	60
	CALLA	CMOS_VAL		;CMOS BOGUS?
	JRZ	FACC00			;NO

	CALLA	SCRCLR
	MOVI	MESS_RESET,A8		;ERROR MESSAGE
	JSRP	L_MESS
FACC00
	SLEEP	240

FACC0	CALLA	SCRCLR
	jauc	amode_start


dipcoinage_mess
	MESS_MAC RD7FONT,SPACING20,200,65,ROBO_WHITE,STRCNRM,0
	.byte	"USING DIPSWITCH COINAGE",0,0
	.even

	.ENDIF

SECRET_NAME
	.byte	"SECRET MIDWAY MENU",0
	.even


********************************
* Octopuss sucessful, show stats

	.ref	show_designteam

HID_P
	clr	a0
	move	a0,@octopus2

	JSRP	show_designteam

	move	@octopus2,a0
	JAZ	DIAG_EX			;NOW GET OUT!

	CALLA	display_init 		;MAKE SURE A13 IS OK BEFORE ANY ACTIONS!
	CALLA	DIGSRT			;RE-INIT THE WORLD!

	MOVI	SECRET_NAME,A2
	MOVI	ROBO_LF,A3
	JSRP	TOP_BOX 		;PRINT TITLE BOX.

*	A4 = UPPER LEFT Y,X					      *
*	A5 = LOWER RIGHT Y,X					      *
*	A6 = NUMBER OF SLICES GOING IN. 			      *

;	MOVI	[4EH,TIT_ULX],A4
;	MOVI	[190H,TIT_LRX],A5
;	MOVK	16,A6
;	CALLA	G_BORDER

;	MOVI	M_TEAM,A8		;PUT UP THE DESIGN TEAM!
;	JSRP	L_MESS
;
;	JSRP	WAIT_BUT

	calla	CLR_SCRN		;Clr screen

	movi	COIN_OCTO_AUDS,a0
	JSRP	PRNT_AUD

	movi	AUD_Y_STRT,a0		;aud Y start
	MOVE	a0,*A13(AT_Y),W   	;set Y COORDINATE
	MOVI	AUDLCOIN,A8		;NOW PRINT MONEY FOR 1ST 3
	JSRP	PRINT_COL2


;	movi	COIN_AUDS,a0		;PUT TABLE UP
;	JSRP	PRNT_AUD
;	movi	COIN1_AUDS,a0		;PUT TABLE UP
;	JSRP	PRNT_AUD
;	movi	AUDLCOIN,a8		;NOW PRINT MONEY FOR 1ST 3
;	JSRP	PRINT_COL
;	movi	COIN2_AUDS,a0		;PUT TABLE UP
;	JSRP	PRNT_AUD

	JSRP	WAIT_BUT


	calla	CLR_SCRN		;Clr screen
	movi	GAME_AUDS,A0		;Show 1st screen
	JSRP	PRNT_AUD
	JSRP	WAIT_BUT

	calla	CLR_SCRN		;Clr screen
	movi	GAME_AUDS1a,A0		;Show 2nd screen
	JSRP	PRNT_AUD
	JSRP	WAIT_BUT

	calla	CLR_SCRN		;Clr screen
	movi	GAME_AUDS1b,A0		;Show 2nd screen
	JSRP	PRNT_AUD
	JSRP	WAIT_BUT

	calla	CLR_SCRN		;Clr screen
	movi	GAME_AUD2a,a0
	JSRP	PRNT_AUD
	movi	GAME_AUD2b,a0
	JSRP	PRNT_AUD
;	MOVI	AUDLCOIN,A8		;Prt money
;	JSRP	PRINT_COL
	JSRP	WAIT_BUT

;	JSRP	DISPDUMP
;	JSRP	WAIT_MUT		;Clrs dump if sticks down

	JSRP	show_player_records

	JAUC	DIAG_EX			;NOW GET OUT!


**************************************************************************
* PRNT_AUD - THIS IS CALLED TO PRINT OUT AN AUDIT TABLE

AT_PTR	 EQU	PDATA			;LONG
AT_Y	 EQU	PDATA+LONG_SIZE		;WORD
AT_DY	 EQU	AT_Y+WORD_SIZE		;WORD
AT_LX	 EQU	AT_DY+WORD_SIZE		;WORD LEFT MARGIN X
AT_RX	 EQU	AT_LX+WORD_SIZE		;WORD RIGHT MARGIN X
AT_OBJ	 EQU	AT_RX+WORD_SIZE		;LONG OBJECT POINTER FOR COLLECTION ROUT
AT_MESS  EQU	AT_OBJ+LONG_SIZE	;LONG PRINT_MONEY MESSAGE STASH
	
PRNT_AUD
	MOVE	*A0+,A1			;GET STARTING HEIGHT
	MOVE	A1,*A13(AT_Y)	 	;STORE

	MOVE	*A0+,A1			;GET DY TO USE
	MOVE	A1,*A13(AT_DY)		;STASH IT AWAY

	MOVE	*A0+,A1			;GET LEFT MARGIN
	MOVE	A1,*A13(AT_LX)		;STORE

	MOVE	*A0+,A1			;GET RIGHT MARGIN
	MOVE	A1,*A13(AT_RX)		;STASH IT AWAY

	MOVE	A0,*A13(AT_PTR),L	;SAVE POINTER INTO AREA

PA1	JSRP	aud_prtone

	MOVE	*A13(AT_PTR),A0,L	;GET POINTER
	ADDI	AUD_T_SIZE,A0
	MOVE	A0,*A13(AT_PTR),L	;PUT BACK

	CALLR	ADD_AUDIT_DY

	MOVE	*A0,A1,L		;ARE WE DONE?
	JRNZ	PA1

	RETP

**************************************************************************
*									 *
*	   ADD_AUDIT_DY 						 *
*									 *
*	   THIS IS CALLED TO MOVE THE AUDIT Y (STORE IN 		 *
*	   PROCESS AREA) TO THE NEXT AUDIT BY ADDING THE		 *
*	   CURRENT DY (ALSO STORED IN PROCESS AREA).			 *
*									 *
**************************************************************************
ADD_AUDIT_DY
	MMTM	SP,A1,A2
	MOVE	*A13(AT_Y),A1,W
	MOVE	*A13(AT_DY),A2,W	;GET DELTA Y
	ADD	A2,A1			;MOVE THE Y DOWN
	MOVE	A1,*A13(AT_Y),W
	MMFM	SP,A1,A2
	RETS

BEGIN_AUDIT
	MMTM	SP,A0
	CLR	A0
	MOVE	A0,@BAD_AUD,W		;MONITOR CORRUPTION.
	MMFM	SP,A0
	RETS

********************************
* Print an audit line

 SUBRP	aud_prtone

	CALLR	BEGIN_AUDIT
	MOVE	*A13(AT_PTR),A3,L	;GET POINTER
	MOVE	*A3(AUD_ROUTINE),A4,L
	jrz	apo20			;No code?

	movi	apo50,a7
	MOVE	A7,-*A12,L		;PUSH RET ADDR
	JUMP	A4			;"CALL" THE ROUTINE

apo20	MOVE	*A3(AUD_NUMBER),A0	;FETCH THE AUDIT NUMBER
	CALLA	GET_AUD 		;TURN INTO AUDIT COUNT!
	MOVE	A1,A3			;PROTECT FOR A SECOND.
	JSRP	NUMBER_WORK		;GET THE NUMBER IN A3 UP THERE!

apo50
	movi	MESS_AUD_LINE,a8
	calla	LM_SETUP		;Setup for audit printing

	move	*a13(AT_PTR),a3,L	;Get *audit
	move	*a3(AUD_COLOR),a6
	move	*a3(AUD_MESS),a8,L	;Get *text

	jruc	LEFT_FINISH


********************************
* LEFT_FINISH AND RIGHT_FINISH
*
* THESE ARE CALLED TO PUT AUDIT INFO
* ON THE LEFT OR RIGHT SIDE ONCE A8 POINTS AT
* THE CORRECT DATA TO PRINT

LEFT_FINISH
	CALLR	TURN_RED_IF_NEC
	CALLR	SET_FOR_Y		;SET FOR AUDIT'S Y
	CALLR	SET_LEFT_X		;SET FOR LEFT X
	JSRP	LM_FINIS		;AND TYPE UP THE MESSAGE!
	RETP

RIGHT_FINISH
	CALLR	TURN_RED_IF_NEC 	;CHANGE COLOR IF CORRUPTED.
	CALLR	SET_FOR_Y		;SET FOR AUDIT'S Y
	CALLR	SET_RIGHT_X
	JSRP	LM_FINIS		;FINISH THE JOB!

	MOVE	@BAD_AUD,A0,W	       ;IS IT CORRUPTED?
	JRZ	RFX		       ;NOPE....RETURN

	MOVI	MESS_ERROR,A8
	CALLA	LM_SETUP	       ;SETUP "ERROR"

	CALLR	SET_FOR_Y	       ;SET FOR AUDIT'S Y
	ADDI	40000H,A9	       ;PUSH 4 Y UNITS TO CENTER
	CALLR	SET_RIGHT_X
	JSRP	LM_FINIS	       ;FINISH THE JOB!

RFX	RETP

TURN_RED_IF_NEC
	MMTM	SP,A3
	MOVE	@BAD_AUD,A3	;CHANGE TO RED?
	JRZ	DAA_1		;NOPE...ITS OK!
	MOVI	ROBO_RED,A6    ;CHANGE COLOR TO RED
DAA_1	MMFM	SP,A3
	RETS
			
SET_FOR_Y
	MMTM	SP,A3
	MOVE	*A13(AT_Y),A3,W   ;GET Y COORDINATE
	SLL	16,A3		  ;PUT IT IN POSITION
	MOVY	A3,A9		  ;PUT IT IN PLACE
	MMFM	SP,A3
	RETS

SET_LEFT_X
	MMTM	SP,A3
	MOVE	*A13(AT_LX),A3,W
	MOVX	A3,A9		  ;PUT THE X IN PLACE
	MMFM	SP,A3
	RETS

SET_RIGHT_X
	MMTM	SP,A3
	MOVE	*A13(AT_RX),A3,W
	MOVX	A3,A9		  ;PUT THE X IN PLACE
	MMFM	SP,A3
	RETS

**************************************************************************
* NUMBER_WORK - Print audit number
* A3=#

NUMBER_WORK
	MOVI	MESS_AUD_NUM,A8 	;SETUP FOR AUDIT NUMBER
	CALLA	LM_SETUP

	MOVE	A3,A8			;NOW WE HAVE BINARY NUMBER
	CALLA	HEXTOASC		;NOW WE POINT TO THE STRING.
	move	*a13(AT_PTR),a6,L	;Get *audit
	move	*a6(AUD_COLOR),a6
	jruc	RIGHT_FINISH

**************************************************************************
*									 *
*	   GET_STARTS							 *
*									 *
*	   TOTAL GAME STARTS IN A2.					 *
*									 *
**************************************************************************
GET_STARTS
	MMTM	SP,A0,A1
	MOVK	AUD1STRT,A0
	CALLA	GET_AUD
	MOVE	A1,A2

	MOVK	AUD2STRT,A0
	CALLA	GET_AUD
	ADD	A1,A2
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*									 *
*	   GET_CONTS							 *
*									 *
*	   TOTAL GAME CONTINUES IN A2.					 *
*									 *
**************************************************************************
GET_CONTS
	MMTM	SP,A0,A1
	MOVK	AUD1CONT,A0
	CALLA	GET_AUD
	MOVE	A1,A2

	MOVK	AUD2CONT,A0
	CALLA	GET_AUD
	ADD	A1,A2
	MMFM	SP,A0,A1
	RETS


**************************************************************************
* Get total plays (Beginning+starts+continues)
* Rets: A2=#

GET_PLAYS
	PUSH	a0
	movk	AUDBEGIN,a0
	calla	GET_AUD
	move	a1,a0
	callr	GET_STARTS	;Actually middle starts
	add	a2,a0
	callr	GET_CONTS
	add	a0,a2
	PULL	a0
	rets

**************************************************************************
*									 *
*	   PRINT_MONEY							 *
*									 *
*	   THIS IS CALLED TO PRINT OUT THE "MONEY" ON THE MONEY 	 *
*	   LINE OF THE AUDIT TABLE.					 *
*									 *
*	   AUDIT X AND Y IS SET FOR THE LINE TO DISPLAY IT ON.		 *
*									 *
*	   A8 HAS THE 1ST OF 3 AUDITS TO USE FOR THE CALCULATION	 *
*	   A9 HAS THE MESSAGE TO LEFT JUSTIFY ON THE CURRENT LINE	 *
*									 *
**************************************************************************
PRINT_COL
	MOVI	T_MONEY,A9	     ;THIS ENTRYPOINT IS FOR COLLECTION MESSAGE
	
PRINT_MONEY
	MOVE	A9,*A13(AT_MESS),L   ;HOLD MESSAGE FOR WHEN WE NEED IT!
	MOVI	ADJCDIV,A0	     ;IF DIVISOR IS ZERO..THEN ITS OFF!
	CALLA	GET_ADJ
	JRZ	NO_MONEY	     ;THAT'S ALL FOLKS!

	CALLR	BEGIN_AUDIT	     ;KEEP TRACK OF SANITY OF CALC.
*
*	ROUTINE IN A2 FORMS STRING BASED ON 3 AUDITS STARTING
*	WITH THE NUMBER IN A8.
*
	CALLR	STR_OBJ 	     ;GET AN OBJECT FOR STRINGING
	JRC	NO_MONEY	     ;COULDN'T GET AN OBJECT!

	CALLR	SUM_COINS	     ;ADD UP THE COIN PARTS IN A2

*
*	WE'RE DOING A PREFIX STRING...NO PREFIX IF ITS BEEN TAMPERED
*
	CALLR	SIXP		     ;HAVE THE 6 BEEN TAMPERED
	JRZ	NO_PREFIX
	CALLR	GET_CSPT	     ;A6 POINTS AT CSECECT DATA.
	MOVE	*A6(CS_LMES),A8,L    ;LEFT STRING FOR MONEY TOTAL
	CALLA	STRCAT		     ;SHOVE THE STRING IN!

NO_PREFIX
	MOVK	1,A0		     ;DIVIDE COINS BY 1 IF ITS BEEN TAMPERED WITH
	CALLR	SIXP
	JRZ	DIV_BY_1	     ;TAMPERED WITH...DIVIDE BY 1 FOR "COINS"

	MOVI	ADJCDIV,A0	     ;GET THE COIN PARTS PLEASE
	CALLA	GET_ADJ
*
*	GET QUOTIENT IN A2
*	REMAINDER IN A3
*
DIV_BY_1
	MOVE	A2,A3		     ;SETUP <A2><A3> AS DIVIDEND
	CLR	A2
	DIVU	A0,A2		     ;DIVIDE UNITS/DIVISOR

	MOVE	A2,A8		     ;WE NEED TO PUT QUOTIENT IN STRING
	CALLA	HEXTOASC	     ;THIS FORMS STRING FOR QUOTIENT

	CALLA	STRCAT		     ;ADD QUOTIENT TO PRINTOUT

	CMPI	1,A0		     ;IS DIVISOR ONE??????
	JRZ	NOFRAC		     ;YEP.......NO DECIMAL!
*
*	WE HAVE A DIVISOR.....WE NEED TO DISPLAY CENTS.
*
	MOVI	ME_DECIMAL,A8	     ;ADD DECIMAL POINT
	CALLA	STRCAT		     ;ITS THERE!
*
*	REMAINDER IS IN A3....TURN IT TO 100THS.
*
	MOVI	100,A2
	MPYU	A2,A3		     ;REMAINDER TIMES 100
	MOVE	A3,A2		     ;DIVIDEND IN A2

	CALLR	ROUNDED_A0_INTO_A2
	CALLR	A2_100TH	     ;CAT THE 100THS IN A2 TO THE A7 STRING.

NOFRAC
	MOVI	COINS_TRAIL,A8		 ;ASSUME IT WILL BE "COINS"
	CALLR	SIXP		     ;TAMPERED?
	JRZ	COIN_SUF	     ;YEP....USE " COINS"
	MOVE	*A6(CS_RMES),A8,L    ;FINISH IT OFF WITH RIGHT STRING

COIN_SUF
	CALLA	STRCAT		     ;SHOVE THE STRING IN!
	MOVI	M_MONEY,A8		  ;MESSAGE FOR THIS LINE PASSED IN A9
	CALLA	LM_SETUP

	MOVE	@TMPOBJ,A8,L	     ;POINTER TO MONEY STRING
	JSRP	RIGHT_FINISH		;PUT ON RIGHT MARGIN

	CALLR	STR_FREE

	MOVE	*A13(AT_MESS),A8,L	;SETUP PASSED MESSAGE
	CALLA	LM_SETUP
	JSRP	LEFT_FINISH		;PUT UP PASSED MESSAGE.
NO_MONEY
	RETP

**************************************************************************
* prints up collection minus $$$
*

PRINT_COL2
	MOVI	T_MONEY2,A9	     ;THIS ENTRYPOINT IS FOR COLLECTION MESSAGE
	
	MOVE	A9,*A13(AT_MESS),L   ;HOLD MESSAGE FOR WHEN WE NEED IT!
	MOVI	ADJCDIV,A0	     ;IF DIVISOR IS ZERO..THEN ITS OFF!
	CALLA	GET_ADJ
	JRZ	NO_MONEY2	     ;THAT'S ALL FOLKS!

	CALLR	BEGIN_AUDIT	     ;KEEP TRACK OF SANITY OF CALC.
*
*	ROUTINE IN A2 FORMS STRING BASED ON 3 AUDITS STARTING
*	WITH THE NUMBER IN A8.
*
	CALLR	STR_OBJ 	     ;GET AN OBJECT FOR STRINGING
	JRC	NO_MONEY2	     ;COULDN'T GET AN OBJECT!

	CALLR	SUM_COINS	     ;ADD UP THE COIN PARTS IN A2

*
*	WE'RE DOING A PREFIX STRING...NO PREFIX IF ITS BEEN TAMPERED
*
;;	CALLR	SIXP		     ;HAVE THE 6 BEEN TAMPERED
;;	JRZ	NO_PREFIX2
;;	CALLR	GET_CSPT	     ;A6 POINTS AT CSECECT DATA.
;;	MOVE	*A6(CS_LMES),A8,L    ;LEFT STRING FOR MONEY TOTAL
	movi	M_VERINF,a8
	CALLA	STRCAT		     ;SHOVE THE STRING IN!

NO_PREFIX2
	MOVK	1,A0		     ;DIVIDE COINS BY 1 IF ITS BEEN TAMPERED WITH
	CALLR	SIXP
	JRZ	DIV_BY_12	     ;TAMPERED WITH...DIVIDE BY 1 FOR "COINS"

	MOVI	ADJCDIV,A0	     ;GET THE COIN PARTS PLEASE
	CALLA	GET_ADJ
*
*	GET QUOTIENT IN A2
*	REMAINDER IN A3
*
DIV_BY_12
	MOVE	A2,A3		     ;SETUP <A2><A3> AS DIVIDEND
	CLR	A2
	DIVU	A0,A2		     ;DIVIDE UNITS/DIVISOR

	MOVE	A2,A8		     ;WE NEED TO PUT QUOTIENT IN STRING
	CALLA	HEXTOASC	     ;THIS FORMS STRING FOR QUOTIENT

	CALLA	STRCAT		     ;ADD QUOTIENT TO PRINTOUT

	CMPI	1,A0		     ;IS DIVISOR ONE??????
	JRZ	NOFRAC2		     ;YEP.......NO DECIMAL!
*
*	WE HAVE A DIVISOR.....WE NEED TO DISPLAY CENTS.
*
;;	MOVI	ME_DECIMAL,A8	     ;ADD DECIMAL POINT
	MOVI	ME_DASH,A8	     ;ADD DASH
	CALLA	STRCAT		     ;ITS THERE!
*
*	REMAINDER IS IN A3....TURN IT TO 100THS.
*
	MOVI	100,A2
	MPYU	A2,A3		     ;REMAINDER TIMES 100
	MOVE	A3,A2		     ;DIVIDEND IN A2

	CALLR	ROUNDED_A0_INTO_A2
	CALLR	A2_100TH	     ;CAT THE 100THS IN A2 TO THE A7 STRING.

NOFRAC2
	MOVI	COINS_TRAIL,A8		 ;ASSUME IT WILL BE "COINS"
	CALLR	SIXP		     ;TAMPERED?
	JRZ	COIN_SUF2	     ;YEP....USE " COINS"
	MOVE	*A6(CS_RMES),A8,L    ;FINISH IT OFF WITH RIGHT STRING

COIN_SUF2
	CALLA	STRCAT		     ;SHOVE THE STRING IN!
	MOVI	M_MONEY,A8		  ;MESSAGE FOR THIS LINE PASSED IN A9
	CALLA	LM_SETUP

	MOVE	@TMPOBJ,A8,L	     ;POINTER TO MONEY STRING
	JSRP	RIGHT_FINISH		;PUT ON RIGHT MARGIN

	CALLR	STR_FREE

	MOVE	*A13(AT_MESS),A8,L	;SETUP PASSED MESSAGE
	CALLA	LM_SETUP
	JSRP	LEFT_FINISH		;PUT UP PASSED MESSAGE.
NO_MONEY2
	RETP

**************************************************************************
*									 *
*	   STR_OBJ							 *
*									 *
*	   THIS IS CALLED TO GET AN OBJECT FOR				 *
*	   CONCATONATING STRINGS TOGETHER.				 *
*									 *
*	   A7 POINTS AT NULL STRING					 *
*									 *
*	   NOTE THAT THIS IS NO LONGER RE-ENTRANT!			 *
*									 *
*	   YOU MUST CALL STR_FREE BEFORE SLEEPING!			 *
*									 *
**************************************************************************
STR_OBJ
	PUSH	a0,a1,a14
	CALLA	GETOBJ		     ;USE AN OBJECT BLOCK FOR STRING MANIPULATION
	JRNZ	STR_O1
*
*	NO OBJECTS DURING TEST MODE
*
	SETC	
	JRUC	STR_OFAIL

STR_O1
	MOVE	A0,@TMPOBJ,L	     ;SAVE TO FREE LATER
	MOVE	A0,A7		     ;THIS IS WHERE IT BELONGS.
	CLR	A0
	MOVB	A0,*A7		     ;MAKE STRING NULL
	CLRC			     ;RETURN SUCCESS
STR_OFAIL
	PULL	a0,a1,a14
	RETS

**************************************************************************
*									 *
*	   ROUNDED_A0_INTO_A2						 *
*									 *
*	   THIS DIVIDES A0 INTO A2.  IT LEAVES THE RESULT IN A2 	 *
*	   AND ROUNDS UP IF NECESSARY.					 *
*									 *
**************************************************************************
ROUNDED_A0_INTO_A2
	MMTM	SP,A3
	MOVE	A0,A0		     ;DIVIDE BY ZERO?
	JRNZ	NDZ
	MOVE	A0,A2		     ;RETURN ZERO
	JRUC	NOROUND
NDZ
	MOVE	A2,A3
	CLR	A2		     ;<A2> <A3> AS DIVIDEND
	DIVU	A0,A2		     ;DIVIDE AND A2 = PENNIES....A3 = REMAINDER
	SLL	1,A3		     ;SHIFT REMAINDER
	CMP	A0,A3		     ;COMPARE TO DIVISOR
	JRLO	NOROUND 	     ;TOO LOW TO ROUND UP
	INC	A2		     ;A2 HAS CORRECT PENNIES
NOROUND
	MMFM	SP,A3
	RETS

**************************************************************************
*									 *
*	   A2_100TH							 *
*									 *
*	   A7 HAS A STRING TO BE PRINTED.  WE HAVE THE			 *
*	   LAST TWO NUMBERS (NOT TO BE LEAD ZERO BLANKED) IN		 *
*	   A2.	CONCATONATE THEM ONTO THE A7 STRING.			 *
*									 *
*	   THIS IS USED FOR PENNIES, HOURS AND MINUTES. 		 *
*									 *
**************************************************************************
A2_100TH
	MMTM	SP,A8
	CMPI	9,A2		     ;9 OR LESS REQUIES LEAD ZERO.
	JRHI	NOLEAD

	MOVI	ME_ZERO,A8	     ;THROW IN THE LEAD ZERO
	CALLA	STRCAT		     ;THIS DOES IT!

NOLEAD
	MOVE	A2,A8
	CALLA	HEXTOASC	     ;MAKE STRING
	CALLA	STRCAT		     ;PUT IT IN!
	MMFM	SP,A8
	RETS

**************************************************************************
*									 *
*	   SUM_COINS							 *
*									 *
*	   A8 HAS FIRST OF THE 4 AUDIT NUMBERS OF INTEREST		 *
*									 *
*	   RETURN COINS TIMES THEIR FACTORS IN A2.			 *
*									 *
**************************************************************************
SUM_COINS
	MMTM	SP,A0,A1,A3,A6,A4

	MOVE	A8,A0			  ;POINT AT AUDIT NUMBER
	CLR	A2			  ;SUM = ZERO

	CALLR	GET_CSPT		  ;A6 POINTS AT CSELECT TABLE
	ADDI	CS_LVAL,A6		  ;POINT AT 1ST MULTIPLIER

	MOVI	CHUTES,A4		  ;NOW...ITERATE OVER THE CHUTES

NEXT_CHUTE
	MOVE	*A6+,A3,W		  ;GET MULTPLIER FOR THIS CHUTE
	CALLR	FIX_A3			  ;REPLACE A3 WITH 1 (MULTIPLIER) IF
					  ;ITS SOME CUSTOM MODE.
	CALLR	ADD_AUD_A0_TIMES_A3_TO_A2
	INC	A0			  ;NEXT AUDIT
	DSJS	A4,NEXT_CHUTE

	MMFM	SP,A0,A1,A3,A6,A4
	RETS

ADD_AUD_A0_TIMES_A3_TO_A2
	CALLA	GET_AUD 		  ;FETCH THE AUDIT
	MPYU	A1,A3			  ;TIME THE FACTOR
	ADD	A3,A2
	RETS

**************************************************************************
* FIX_A3
*
* THIS IS CALLED BY THE LOW LEVEL MONEY TOTALIZER.
* THE MULTIPLIER FOR THE COIN SLOT THAT ITS WORKING
* ON IS IN A3.  WE REPLACE IT WITH "1" TO SUM "TOTAL COINS"
* IF ITS IN A NON-STANDARD COIN MODE.
*
**************************************************************************
FIX_A3
	CALLR	SIXP		     ;HAS IT BEEN TAMPERED WITH?
	JRNZ	FIX_A3X 	     ;NOPE...LEAVE A3

	MOVK	1,A3
FIX_A3X
	RETS

**************************************************************************
* SIXP
*
* THIS IS CALLED TO SEE IF THE 1ST 6 COIN PARAMETERS HAVE
* BEEN TAMPERED WITH.
*
* Z=YES
*
**************************************************************************
SIXP
	MMTM	SP,A0
	MOVI	ADJ1ST6,A0
	CALLA	GET_ADJ		;HAS IT BEEN TAMPERED WITH?
	MMFM	SP,A0
	RETS

STARTS
	CALLR	GET_STARTS
	MOVE	A2,A3		;GET IN PRINTOUT REG.
	jruc	NUMBER_WORK	;AND PRINT IT

CONTINS
	CALLR	GET_CONTS
	MOVE	A2,A3		;GET IN PRINTOUT REG.
	jruc	NUMBER_WORK	;AND PRINT IT

DOPLAYS
	CALLR	GET_PLAYS
	MOVE	A2,A3		;PUT IN PLACE
	jruc	NUMBER_WORK

DOHSLEFT
	MOVI	ADJHSRES,A0
	CALLA	GET_ADJ 	;IS IF OFF?
	JRZ	DOHSOFF 	;YEP...PRINT IT

	CALLA	GET_HSC 	;GET THE COUNTER VALUE
	MOVE	A0,A3
	jruc	NUMBER_WORK	;AND SHOW IT!

DOHSOFF
	MOVI	MESS_AUD_NUM,A8
	CALLA	LM_SETUP	;SETUP FOR AUDIT PRINTING.

	MOVI	M_HSOFF,A8	;THIS EFFECTIVELY ERASES LINE!
	JAUC	RIGHT_FINISH

DO_P1MIN
	MOVI	AUD1TIME,A0
P1MJ
	CALLA	GET_AUD 	;TURN INTO NUMBER
	MOVE	A1,A4		;MOVE NUMBER TO "HOUR" COMPUTATION REGGIE
	JRUC	DH11		;AND DO LIKE THE HOURS!


DO_P2MIN
	MOVI	AUD2TIME,A0
	JRUC	P1MJ

DO_HOURS
	CALLR	TOT_TIME	;READ OUT THE TOTAL TIME.
DH11	MOVE	A4,A5		;A5 HAS RUNNING PLAY TIME
	CLR	A4		;<A4><A5> READY FOR DIVISION
	MOVK	12,A0
	DIVU	A0,A4		;A4 HAS MINUTES
	CMPI	6,A5		;ROUND PROPERLY
	JRLO	DH1		;NOT ENOUGH
	INC	A4
DH1
	MOVE	A4,A1		;NOW THIS DIVIDED BY 60 IS WHAT WE NEED
	jruc	P_TIME		;DO IT!

DO_AVGT
	CALLR	TOT_TIME	;A3 HAS WEIGHTED TIME

DOAVC	CALLR	GET_PLAYS	;GET TOTAL PLAYS IN A2
	MOVE	A2,A0		;STASH IN A0.
	MOVK	5,A1		;TURN INTO SECONDS
	MPYU	A1,A3		;A3 HAS SECONDS OF INTEREST
	MOVE	A3,A2
	CALLR	ROUNDED_A0_INTO_A2   ;DIVIDE A2 BY PLAYS (AND ROUND)
	MOVE	A2,A1		;NOW GET IN PLACE FOR P_TIME
	jruc	P_TIME		;DO IT!

DO_ELAPSE
	CALLR	TOT_TIME
	MOVE	A4,A3		;USE ELAPSED TIME
	JRUC	DOAVC		;AND THE REST IS IDENTICAL.


keyavg_prt
;	movi	AUDKEYTOT,a0
;	calla	GET_AUD
;	move	a1,a3
;	movi	AUDFULLGAMES,a0
;	calla	GET_AUD
;	divs	a1,a3
;	jruc	NUMBER_WORK	;Print it


diff_prt
	movk	ADJDIFF,a0
	calla	GET_ADJ
	move	a0,a3
	jruc	NUMBER_WORK	;Print it


**************************************************************************
*									 *
*	   P_TIME							 *
*									 *
*	   THIS IS CALLED TO DISPLAY AN AUDIT IN TIME (0:00)		 *
*	   FORMAT.  THE NUMBER TO BE USED IS PASSED IN A1.		 *
*									 *
**************************************************************************
P_TIME
	CALLR	STR_OBJ		;USE AN OBJECT BLOCK FOR STRING MANIPULATION
	JRC	NO_OBJS		;NO OBJECTS....PRINT NOTHING

	CLR	A0		;DIVIDEND IN <A0><A1>
	MOVI	60,A2
	DIVU	A2,A0		;A0 = "MINUTES"....A1 = "SECONDS

	CALLA	CAT_A0		;ADD A0 STRING TO A7 BUILD
	MOVI	ME_COLON,A8
	CALLA	STRCAT		;PUT THE COLON IN.

	MOVE	A1,A2		;GET "SECONDS" IN A2
	CALLR	A2_100TH	;AND GET THE 100THS IN.

	MOVI	MESS_AUD_NUM,A8	;SETUP FOR AUDIT NUMBER
	CALLA	LM_SETUP
	move	*a13(AT_PTR),a6,L	;Get *audit
	move	*a6(AUD_COLOR),a6

	MOVE	A7,A8		;PUT STRING CORRECT REGGIE
	JSRP	RIGHT_FINISH	;PRINT THE LINE

	CALLR	STR_FREE	;FREE UP THE OBJECT!

NO_OBJS
	RETP			;NOW RETURN TO CALLER

STR_FREE
	MOVE	@TMPOBJ,A0,L	;GET OBJECT BACK
	JRNZ	FREE_IT_NOW

	.IF	DEBUG
	JRUC	$
	.ENDIF
	RETS			;NO OBJECT...RETURN!

FREE_IT_NOW
	jauc	FREEOBJ 	;AND LET IT GO.
	
**************************************************************************
*									 *
*	TOT_TIME							 *
*									 *
*	(1 * P1TIME) + (2 * P2TIME) IN A3				 *
*	ELAPSED TIME IN A4						 *
*									 *
**************************************************************************
TOT_TIME
	MMTM	SP,A0,A1
	MOVI	AUD1TIME,A0
	CALLA	GET_AUD
	MOVE	A1,A3
	MOVE	A1,A4
	MOVI	AUD2TIME,A0
	CALLA	GET_AUD
	ADD	A1,A4		     ;A4 HAS SIMPLE SUM NOW
	SLL	1,A1		     ;DOUBLE THE PLAYER 2 TIME
	ADD	A1,A3
	MMFM	SP,A0,A1
	RETS


********************************
**** DATA SECTION BEGINS ****

	.DATA



********************************
* AUDIT TEXT

MESS_ERROR
	MESS_MAC RD7FONT,SPACING07,0,0,ROBO_RED,STRLNRM,0
	TXTLINE	"  ERROR"

MESS_AUD_NUM
	MESS_MAC RD7FONT,SPACING20,367,227,ROBO_YELLOW,STRRNRM,0

MESS_AUD_LINE
	MESS_MAC RD7FONT,SPACING20,23,227,ROBO_YELLOW,STRLNRM,0


MES_AUD	TXTLINE	"GAME AUDITS"

MES_BOOK
	TXTLINE	"COIN BOOKKEEPING"

M_LCOIN TXTLINE	"LEFT SLOT COINS"
M_CCOIN TXTLINE	"CENTER SLOT (3) COINS"
M_RCOIN TXTLINE	"RIGHT SLOT COINS"

M_LCOIN2 TXTLINE "JAMS FROM THE LEFT"
M_CCOIN2 TXTLINE "JAMS FROM THE CENTER"
M_RCOIN2 TXTLINE "JAMS FROM THE RIGHT"

M_XCOIN TXTLINE	"EXTRA SLOT (4) COINS"
M_DBV	TXTLINE "BILL VALIDATOR"

M_PAIDC TXTLINE	"PAID CREDITS"

M_SERV	TXTLINE	"SERVICE CREDITS"


M_PLAYS TXTLINE	"TOTAL PLAYS"

M_HSLEFT
	TXTLINE	"PLAYS UNTIL H.S. RESET"

M_HSOFF TXTLINE	"OFF"

	.even
M_ELAPSE
	TXTLINE	"AVG. ELAPSED TIME/PLAY"

M_MONEY	MESS_MAC  RD15FONT,SPACING20,367,227,ROBO_WHITE,STRRNRM,0

T_MONEY MESS_MAC  RD15FONT,SPACING20,23,227,ROBO_WHITE,STRLNRM,0
	TXTLINE	"TOTAL COLLECTION"

T_MONEY2 MESS_MAC  RD15FONT,SPACING20,23,227,ROBO_WHITE,STRLNRM,0
	TXTLINE	"JAM INFO"

M_VERINF
	TXTLINE	"031-0"

M_LOCKUP
	TXTLINE	"LOCKUPS"
M_HIDB	TXTLINE	"GAMES NOT FINISHED"

M_SECBON
	TXTLINE	"WARPS"


**************************************************************************
*									 *
*	   MENU DESCRIPTORS						 *
*									 *
**************************************************************************
*
*	 MAIN TEST MENU
*
MEN_MAIN
	 .LONG	 RD7FONT	;FONT	
	 .LONG	 STRCNRM	;CENTER PLEASE
	 .LONG	 MESSMAIN	;TITLE
	 .WORD	 ROBO_WHITE	;COLOR OF TITLE
	 .WORD	 MENU_X 	;UL X
	 .WORD	 MENU_Y-3	;UL Y
;	 .WORD	 MENU_DY-6	;VERTICAL SPACING
	 .WORD	 MENU_DY-7	;VERTICAL SPACING
	 .WORD	 ROBO_WHITE	;COLOR WHEN NOT SELECTED
	 .WORD	 16		;HEIGHT OF SELECTION BAR
	 .WORD	 -4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	 .WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	 .WORD	 BAR_WID	;WIDTH OF BAR!
	 .WORD	 ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	 .LONG	 MESS_DIAG,GO_DIAG,DIAG_HELP
	 .LONG	 MESS_COIN_AUD,GO_BOOK,COIN_HELP
	 .LONG	 MESS_GAME_AUD,GO_AUD,AUDIT_HELP
	 .LONG	 MESS_GAME_ADJ,GO_ADJ,ADJUST_HELP
	 .LONG	 MESS_UTIL,GO_UTIL,UTIL_HELP
	 .LONG	 MESS_HARDWARE,GO_HARDWARE,HARDWARE_HELP
;	 .LONG	 MESS_CLOCK,GO_CLOCK,CLOCK_HELP
	 .LONG	 MESS_VOL,GO_VOL,VOL_HELP
	 .LONG	 MESS_AMOD_VOL,GO_AMODE_VOL,AMODE_VOL_HELP
	 .LONG	 MESS_EXIT,0,EXIT_HELP	;SPECIAL CASE!
	 .LONG	 0		;END

* UTILITES MENU GOES LEFT OF CENTER

UM_WID	 EQU	 206
UM_X	 EQU	 TIT_ULX+GAP+MB_XWID+(UM_WID/2)+C_KLUDGE

MEN_UTIL
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESSUTIL	;TITLE
	.WORD	COLOR_WHITE	;COLOR OF TITLE
	.WORD	UM_X		;UL X
	.WORD	MENU_Y-3	;UL Y
	.WORD	18		;VERTICAL SPACING
	.WORD	COLOR_WHITE	;COLOR WHEN NOT SELECTED
	.WORD	16		;HEIGHT OF SELECTION BAR
	.WORD	-4		;DISTANCE OF BAR FROM TOP OF TEXT (NEG)
	.WORD	BAR_DX 		;EXTRA X ON EACH SIDE.
	.WORD	UM_WID 		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_CLCRED,DO_CLCRED,CLCRED_HELP
	.LONG	MESS_CLCOIN,DO_CLCOIN,CLCOIN_HELP
	.LONG	MESS_CLAUD,DO_CLAUD,CLAUD_HELP
;	.LONG	MESS_HSRES,DO_HSRES,HSRES_HELP
	.LONG	MESS_CLPLRECS,DO_CLPLRECS,CLPLRECS_HELP
	.LONG	MESS_DEF_ADJ,DO_DEF_ADJ,DEF_ADJ_HELP
	.LONG	MESS_FACSET,DO_FACSET,FACSET_HELP
;	.LONG	opmsg_s,opmsg_main,OPMSG_HELP
	.LONG	MESS_MM,0,BLNK_HELP	;RETURN TO MAIN MENU
	.LONG	0			;END

* DIAGNOSTIC TESTS MENU

MEN_DIAG
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESSDIAG	;TITLE
	.WORD	COLOR_RED	;COLOR OF TITLE
	.WORD	200		;UL X
	.WORD	MENU_Y-3	;UL Y
	.WORD	20		;VERTICAL SPACING
	.WORD	COLOR_RED	;COLOR WHEN NOT SELECTED
	.WORD	16		;HEIGHT OF SELECTION BAR
	.WORD	-4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	195		;WIDTH OF BAR!  (A LITTLE FATTER)
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_SWTEST,GO_SWTEST,BLNK_HELP
	.LONG	diptst_mess,dipsw_test,BLNK_HELP
ROM_LEV EQU	3		;TEST NUMBER FOLLOWING ROM TEST
	.LONG	MESS_CPUTEST,GO_CPUTEST,BLNK_HELP
RTR_LEV EQU	4		;TEST NUMBER FOLLOWING CPU TEST (FOR RETURN)
	.LONG	M_STEST,GO_STEST,BLNK_HELP
	.LONG	MESS_PATTERNS,GO_PATTERNS,BLNK_HELP
	.LONG	MESS_BURN,DO_BURN,BLNK_HELP
	.LONG	MESS_MM,0,BLNK_HELP	;RETURN TO MAIN MENU
	.LONG	0

STM_WID EQU	  250


* PRESS ANY BUTTON TO CONTINUE

ANY_MENU
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	0		;TITLE
	.WORD	0		;COLOR OF TITLE
	.WORD	200		;UL X
	.WORD	200		;UL Y
	.WORD	MENU_DY		;VERTICAL SPACING
	.WORD	COLOR_BLUE	;COLOR WHEN NOT SELECTED
	.WORD	BAR_HITE	;HEIGHT OF SELECTION BAR
	.WORD	-9		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	234		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_ANY,0,NO_HELP
	.LONG	0

* MONITOR PATTERNS

MEN_PATTERNS
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESSPAT		;TITLE
	.WORD	COLOR_RED	;COLOR OF TITLE
	.WORD	200		;UL X	    (CENTER IT!)
	.WORD	MENU_Y-3	;UL Y
	.WORD	23		;VERTICAL SPACING
	.WORD	COLOR_YELLOW	;COLOR WHEN NOT SELECTED
	.WORD	16		;HEIGHT OF SELECTION BAR
	.WORD	-4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	234		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_RED,GO_RED,BLNK_HELP
	.LONG	MESS_GREEN,GO_GREEN,BLNK_HELP
	.LONG	MESS_BLUE,GO_BLUE,BLNK_HELP
	.LONG	MESS_BARS,GO_BARS,BLNK_HELP
	.LONG	MESS_CROSS,GO_CROSS,BLNK_HELP
	.LONG	MESS_DIAGM,0,BLNK_HELP
	.LONG	MESS_MM,FORCE_MAIN,NO_HELP	;RETURN TO MAIN MENU
	.LONG	0

* DETAILED COINAGE AVAILABLE (ON 1ST COINAGE PAGE)

MEN_DETAIL
	.LONG	RD7FONT	;FONT
	.LONG	STRCNRM	;CENTER PLEASE
	.LONG	MESSPAT	;TITLE
	.WORD	COLOR_YELLOW	;COLOR OF TITLE
	.WORD	200		;UL X	    (CENTER IT!)
	.WORD	224		;UL Y
	.WORD	12		;VERTICAL SPACING
	.WORD	COLOR_BLUE	;COLOR WHEN NOT SELECTED
	.WORD	10		;HEIGHT OF SELECTION BAR
	.WORD	-1		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX 	;EXTRA X ON EACH SIDE.
	.WORD	157		;WIDTH OF BAR!
	.WORD	COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_CLCOIN,0,NO_HELP		;Clr coins
	.LONG	MESS_MM,FORCE_MAIN,NO_HELP	;RETURN TO MAIN MENU
	.LONG	0

* YES/NO   (FOR ARE YOU SURE?)

MEN_YN	.LONG	 RD7FONT	;FONT
	.LONG	 STRCNRM	;CENTER PLEASE
	.LONG	 MESSDIAG	;TITLE
	.WORD	 COLOR_RED	;COLOR OF TITLE
	.WORD	 200		;UL X
	.WORD	 166		;UL Y
	.WORD	 19		;VERTICAL SPACING
	.WORD	 COLOR_YELLOW	;COLOR WHEN NOT SELECTED
	.WORD	 16		;HEIGHT OF SELECTION BAR
	.WORD	 -4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	.WORD	 78		;WIDTH OF BAR!  (A LITTLE FATTER)
	.WORD	 COLOR_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	 MESS_YES,0,NO_HELP
	.LONG	 MESS_NO,0,NO_HELP
	.LONG	 0

* NEXT AUDIT PAGE

MEN_AP1 .LONG	 RD7FONT	;FONT
	.LONG	 STRCNRM	;CENTER PLEASE
	.LONG	 MESSPAT	;TITLE
	.WORD	 ROBO_YELLOW	;COLOR OF TITLE
	.WORD	 200		;UL X	    (CENTER IT!)
	.WORD	 226		;UL Y
	.WORD	 12		;VERTICAL SPACING
	.WORD	 COLOR_BLUE	;COLOR WHEN NOT SELECTED
	.WORD	 10		;HEIGHT OF SELECTION BAR
	.WORD	 -1		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	.WORD	 157		;WIDTH OF BAR!
	.WORD	 ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	 MESS_TOPAGE2,0,NO_HELP 	;DETAILED SECTION
	.LONG	 MESS_MM,FORCE_MAIN,NO_HELP;RETURN TO MAIN MENU
	.LONG	 0


* PREVIOUS AUDIT PAGE?  (ON 2ND GAME AUDIT PAGE)

MEN_AP2 .LONG	 RD7FONT	;FONT
	.LONG	 STRCNRM	;CENTER PLEASE
	.LONG	 MESSPAT	;TITLE
	.WORD	 ROBO_YELLOW	;COLOR OF TITLE
	.WORD	 200		;UL X	    (CENTER IT!)
	.WORD	 226		;UL Y
	.WORD	 12		;VERTICAL SPACING
	.WORD	 COLOR_BLUE	;COLOR WHEN NOT SELECTED
	.WORD	 10		;HEIGHT OF SELECTION BAR
	.WORD	 -1		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	.WORD	 157		;WIDTH OF BAR!
	.WORD	 ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	 MESS_TOPAGE2,0,NO_HELP
	.LONG	 MESS_BACKP1,0,NO_HELP		;DETAILED SECTION
	.LONG	 0



MEN_AP3 .LONG	 RD7FONT	;FONT
	.LONG	 STRCNRM	;CENTER PLEASE
	.LONG	 MESSPAT	;TITLE
	.WORD	 ROBO_YELLOW	;COLOR OF TITLE
	.WORD	 200		;UL X	    (CENTER IT!)
	.WORD	 226		;UL Y
	.WORD	 12		;VERTICAL SPACING
	.WORD	 COLOR_BLUE	;COLOR WHEN NOT SELECTED
	.WORD	 10		;HEIGHT OF SELECTION BAR
	.WORD	 -1		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	.WORD	 157		;WIDTH OF BAR!
	.WORD	 ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	 MESS_MM,FORCE_MAIN,NO_HELP;RETURN TO MAIN MENU
	.LONG	 MESS_BACKP1,0,NO_HELP		;DETAILED SECTION
	.LONG	 0


MEN_SOUNDTEST
	.LONG	RD7FONT	;FONT
	.LONG	STRCNRM	;CENTER PLEASE
	.LONG	MESS_SNDTST0	;TITLE
	.WORD	ROBO_YELLOW	;COLOR OF TITLE
	.WORD	200		;UL X	    (CENTER IT!)
	.WORD	MENU_Y-3	;UL Y
	.WORD	20		;VERTICAL SPACING
	.word	ROBO_RED	;colour when not selected
	.WORD	16		;HEIGHT OF SELECTION BAR
	.WORD	-4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX 		;EXTRA X ON EACH SIDE.
	.WORD	192+6		;WIDTH OF BAR!
	.WORD	ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.long	MESS_SNDTST1,DO_GENTEST,NO_HELP
	.long	MESS_SNDTST2,DO_PLAYSOUNDS,NO_HELP
	.long	MESS_SNDTST3,0,NO_HELP
	.long	MESS_SNDTST4,FORCE_MAIN,NO_HELP
	.LONG	0

**************************************************************************
*									 *
*	  HELP MENUS FOR MAIN MENU					 *
*									 *
**************************************************************************
*	 HM_JUST	 0 = CENTER   1 = LEFT
*	 HM_COLOR
*	 HM_ENTS

DIAG_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	6		;# ENTRIES
	.LONG	MESS_SWTEST
	.long	diptst_mess
	.LONG	MESS_CPUTEST
	.LONG	M_STEST
	.LONG	MESS_PATTERNS
	.LONG	U_BURNIN

COIN_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	3		;2 ENTRIES
	.LONG	CH_0
	.LONG	CH_1
	.LONG	CH_2

AUDIT_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	2		;2 ENTRIES
	.LONG	AH_1
	.LONG	AH_2

ADJUST_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	3		;3 ENTRIES
	.LONG	AD_1
	.LONG	AD_2
	.LONG	AD_3

UTIL_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	6		;# of ENTRIES
	.LONG	U_CLR_CRED
	.LONG	U_CLR_COIN
	.LONG	U_CLR_AUD
;	.LONG	U_HSRESET
	.LONG	U_CLRRECS
	.LONG	U_FACTORY
	.long	opmsg_s

VOL_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	2		;2 ENTRIES
	.LONG	MESS_ATV
	.LONG	MESS_OTG

AMODE_VOL_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	2		;2 ENTRIES
	.LONG	MESS_ATV
	.LONG	MESS_FAM

EXIT_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	1		;1 ENTRY
	.LONG	U_END


********************************
* HELP FOR UTILITY MENU

CLCRED_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	3		;# entries
	.LONG	MEH_CLCRED1
	.LONG	MEH_CLCRED2
	.LONG	MEH_CLCRED3

CLCOIN_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	3		;# entries
	.LONG	MEH_CLCOIN1
	.LONG	MEH_CLCOIN2
	.LONG	MEH_CLCOIN3
;	.LONG	MEH_CLCOIN4

CLAUD_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	2		;# entries
	.LONG	MEH_CLAUD1
	.LONG	MEH_CLAUD2

CLPLRECS_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	4		;# entries
	.long	MEH_CLPLRECS1
	.long	MEH_CLPLRECS2
	.long	MEH_CLPLRECS3
	.long	MEH_CLPLRECS4

HSRES_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	3		;# entries
	.LONG	MEH_RESHS1
	.LONG	MEH_RESHS2
	.LONG	MEH_RESHS3

DEF_ADJ_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	7		;# entries
	.LONG	MEH_DEFA1
	.LONG	MEH_DEFA2
	.LONG	MEH_DEFA3
	.LONG	MEH_DEFA4
	.LONG	MEH_DEFA5
	.LONG	MEH_DEFA6
	.LONG	MEH_DEFA7

FACSET_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	COLOR_BLUE	;COLOR
	.WORD	6		;# entries
	.LONG	MEH_FAC1
	.LONG	MEH_FAC2
	.LONG	MEH_FAC3
	.LONG	MEH_FAC4
	.LONG	MEH_FAC5
	.LONG	MEH_FAC6

OPMSG_HELP
	.word	0		;CENTER JUSTIFY
	.word	COLOR_BLUE	;COLOR
	.word	3		;# entries
	.long	opmsgh1_s
	.long	opmsgh2_s
	.long	opmsgh3_s


**************************************************************************
*									 *
*	   TEXT STRINGS 						 *
*									 *
**************************************************************************

SIY0	equ	190
SIY1	equ	212
SIY2	equ	224
SIY3	equ	236

SND_INST
	 MESS_MAC  RD7FONT,SPACING07,200,SIY1,ROBO_WHITE,STRCNRM,0
	.STRING   "UP AND DOWN TO SELECT SOUND",0,1
	.EVEN
	 MESS_MAC  RD7FONT,SPACING07,200,SIY2,ROBO_WHITE,STRCNRM,0
	.STRING   "PRESS ACTION BUTTON TO PLAY",0,1
	.EVEN
	 MESS_MAC  RD7FONT,SPACING07,200,SIY3,ROBO_WHITE,STRCNRM,0
	.STRING   "PRESS START BUTTON TO EXIT",0,0

SND_SETUP MESS_MAC  RD15FONT,SPACING20,200,SIY0,ROBO_WHITE,STRCNRM,0

sounds_tab	.long	SND_ST0,SND_ST1,SND_ST2,SND_ST3
		.long	SND_ST0,SND_ST1,SND_ST2,SND_ST3


SND_ST0	.string	"JET PLANE  (U2)",0
SND_ST1	.string	"ORGAN      (U3)",0
SND_ST2	.string	"FOR THREE  (U4)",0
SND_ST3	.string	"AIRBALL    (U5)",0

	.EVEN
TEST_SOUND_TAB
	.WORD	2f9H,1b5H,7e6H,1edH,2f9H,1b5H,7e6H,1edH

MESS_SNDTST0	.string	"SOUND BOARD TEST",0
MESS_SNDTST1	.string	"GENERAL TEST",0
MESS_SNDTST2	.string	"PLAY SOUNDS",0
MESS_SNDTST3	.string	"BACK TO DIAGNOSTICS MENU",0
MESS_SNDTST4	.string	"RETURN TO MAIN MENU",0

MESS_YES
	.byte	 "YES",0
	.EVEN

MESS_NO .byte	 "NO",0
	.EVEN

;MESS_CLEAR_SUBS
;	  .byte	  "CLEAR SUBTOTALS"
;	  .BYTE 	  0
;	  .EVEN
;
;MESS_SUBS_CLEAR
;	  .byte	  "SUBTOTALS CLEARED"
;	  .BYTE 	  0
;	  .EVEN

MESS_TOPAGE2
	 .byte	 "NEXT AUDIT PAGE"
	 .BYTE		 0
	 .EVEN

MESS_BACKP1
	 .byte	 "PREVIOUS AUDIT PAGE"
	 .BYTE		 0
	 .EVEN

MESS_ANY
	 .byte	 "ANY BUTTON TO CONTINUE"
	 .BYTE		 0
	 .EVEN

MESS_MM
	 .byte	 "RETURN TO MAIN MENU"
	 .BYTE		 0
	 .EVEN

MESSDIAG				;THIS IS TITLE OF PAGE
MESS_DIAG
	 .byte	 "DIAGNOSTIC TESTS"
	 .BYTE	   0
	 .EVEN
MESS_COIN_AUD
	 .byte	 "COIN BOOKKEEPING"
	 .BYTE	   0
	 .EVEN
MESS_GAME_AUD
	 .byte	 "GAME AUDITS"
	 .BYTE	   0
	 .EVEN

MESS_GAME_ADJ
	 .byte	 "GAME ADJUSTMENT"
	 .BYTE	   0
	 .EVEN
MESS_UTIL
	 .byte	 "UTILITIES"
	 .BYTE	   0
	 .EVEN

MESS_VOL
	.byte	"GAME VOLUME ADJ."
	.BYTE	   0
	.EVEN

MESS_AMOD_VOL
	.byte	"A-MODE VOLUME ADJ."
	.BYTE	   0
	.EVEN

MESS_EXIT
	 .byte	 "EXIT TO GAME OVER"
	 .BYTE	   0
	 .EVEN

CH_0	 .byte	 "VIEW COINBOX"
	 .BYTE	 0
	 .EVEN
CH_1	 .byte	 "TOTALS AND"
	 .BYTE	 0
	 .EVEN
CH_2	 .byte	 "GAMEPLAY COUNTERS"
	 .BYTE	 0
	 .EVEN

AH_1	 .byte	 "VIEW GAME"
	 .BYTE	 0
	 .EVEN
AH_2	 .byte	 "PLAY STATISTICS"
	 .BYTE	 0
	 .EVEN

AD_1	 .byte	 "MAKE CHANGES TO",0
	 .EVEN
AD_2	 .byte	 "PRICING, GAMEPLAY SETTINGS,",0
	 .EVEN
AD_3	 .byte	 "AND DRONE DIFFICULTY",0
	 .EVEN

MESS_CLCRED
U_CLR_CRED	 .byte "CLEAR CREDITS"
	 .BYTE	 0
	 .EVEN

MESS_CCCONF	 .byte "CREDITS CLEARED."
	 .BYTE	 0
	 .EVEN

MESS_CLCOIN
U_CLR_COIN	 .byte "CLEAR COIN COUNTERS"
	 .BYTE	 0
	 .EVEN

MESS_CLAUD
U_CLR_AUD	 .byte "CLEAR GAME AUDITS"
	 .BYTE	 0
	 .EVEN

MESS_CLPLRECS
U_CLRRECS
	.string	"CLEAR PLAYER RECORDS",0
	.EVEN

MESS_HSRESET
U_HSRESET	 .byte "RESET HIGH SCORES"
	 .BYTE	 0
	 .EVEN

MESS_HSRES
	 .byte "RESET HIGH SCORES"
	 .BYTE	 0
	 .EVEN


MESS_ATV
	.byte	"ADJUST THE VOLUME",0
	.even
MESS_OTG
	.byte	"FOR GAME PLAY",0
	.even
MESS_FAM
	.byte	"FOR ATTRACT MODE",0
	.even
;M_OPMESS_TIT
;U_OPMESS	  .byte "OPERATOR MESSAGE"
;	  .BYTE   0
;	  .EVEN

;M_SET_OMESS
;;MESS_OPMESS	   .byte "SET OPERATOR MESSAGE"
;	  .BYTE   0
;	  .EVEN

U_BURNIN	.byte "BURN-IN TEST",0
	.even

MESS_BURN	.byte "RUN BURN-IN TEST",0
	.even

MESS_DEF_ADJ	TXTLINE	"DEFAULT ADJUSTMENTS"
U_FACTORY	TXTLINE	"FACTORY SETTINGS"
MESS_FACSET	TXTLINE	"FULL FACTORY RESTORE"

opmsg_s		TXTLINE	"OPERATOR MESSAGE"
opmsgh1_s	TXTLINE	"ENTER AN OPERATOR"
opmsgh2_s	TXTLINE	"ATTRACT MODE MESSAGE"
opmsgh3_s	TXTLINE	"TO THE PLAYERS"


U_END	.byte "END TESTING",0
	.even

MESS_SWTEST	.byte "SWITCH TEST",0
	.even
diptst_mess	.byte "DIP SWITCH TEST",0
	.even
MESS_CPUTEST	.byte "CPU BOARD TEST",0
	.even
M_STEST	.byte	"SOUND BOARD TEST",0
	.even

MESSPAT 		;HEADER TITLE
MESS_PATTERNS	.byte "MONITOR PATTERNS",0
	.EVEN

MESS_RED	.byte "RED SCREEN",0
	.EVEN
MESS_GREEN	 .byte "GREEN SCREEN",0
	.EVEN
MESS_BLUE	 .byte "BLUE SCREEN",0
	.EVEN
MESS_BARS	 .byte "COLOR BARS",0
	.EVEN
MESS_CROSS	 .byte "CROSSHATCH  PATTERN",0
	.EVEN
MESS_DIAGM	 .byte "BACK TO DIAGNOSTICS MENU",0
	.EVEN

*	ON FULL RESTORE....THE FOLLOWING IS PRINTED.
	;0 = END OF STRING...1 = MORE MESSAGES!

	.asg	14,Y_SPC
	.asg	70,START_Y
	.asg	START_Y+Y_SPC,NXT_LNE

MESS_RESET
	MESS_MAC  RD7FONT,SPACING20,200,START_Y,ROBO_RED,STRCNRM,0
MESS_FACFAIL
	.byte  "FAILURE IN CMOS RAM",0,0
	.EVEN

MESS_FFSCONF
MESS_FAC MESS_MAC RD7FONT,SPACING20,200,NXT_LNE,COLOR_WHITE,STRCNRM,0
MESS_DEFCONF
	.byte   "ADJUSTMENTS RESTORED.",0,1
	.EVEN

	MESS_MAC RD7FONT,SPACING20,200,NXT_LNE*2,COLOR_YELLOW,STRCNRM,0
MESS_CCNCONF
	.byte  "COIN COUNTERS CLEARED.",0,1
	.EVEN

	MESS_MAC RD7FONT,SPACING20,200,NXT_LNE*3,COLOR_BLUE,STRCNRM,0
MESS_CAUDCONF
	.byte  "GAME AUDITS CLEARED.",0,1
	.EVEN

	MESS_MAC RD7FONT,SPACING20,200,NXT_LNE*4,COLOR_RED,STRCNRM,0
MESS_CLPLRECSCONF
	.string	"PLAYER RECORDS CLEARED.",0,1
	.EVEN

	MESS_MAC RD7FONT,SPACING20,200,NXT_LNE*5,COLOR_CYAN,STRCNRM,0
MESS_CLWRLDRECSCONF
	.string	"WORLD RECORDS CLEARED.",0,1
	.EVEN

	MESS_MAC RD7FONT,SPACING20,200,NXT_LNE*6,COLOR_WHITE,STRCNRM,0
MESS_CLTMRECSCONF
	.string	"TEAM STATISTICS CLEARED.",0,0
	.EVEN

	MESS_MAC RD7FONT,SPACING20,200,NXT_LNE*4,COLOR_RED,STRCNRM,0
MESS_HSRCONF
	.byte  "HIGH SCORE TABLE RESET.",0,1
	.EVEN

MESS_CANCELLED
	.byte "CANCELLED",0
	.EVEN

CIN_X	EQU	(TIT_ULX+TIT_LRX)/2
CR_X	EQU	CIN_X-34
CIN_Y	EQU	86

CIY1	EQU	CIN_Y+14
CIY2	EQU	CIY1+15
CIY3	EQU	CIY2+25
CIY4	EQU	CIY3+25

M_TEAM	MESS_MAC  RD7FONT,SPACING20,200,67,ROBO_WHITE,STRCNRM,0
	.byte	"TOTAL CARNAGE TEAM:",0,1
	MESS_MAC  RD7FONT,SPACING20,200,97,ROBO_WHITE,STRCNRM,0
	.byte	"MARK TURMELL",0,1
	MESS_MAC  RD7FONT,SPACING20,200,107,ROBO_WHITE,STRCNRM,0
	.byte	"JOHN TOBIAS",0,1
	MESS_MAC  RD7FONT,SPACING20,200,117,ROBO_WHITE,STRCNRM,0
	.byte	"JIM GENTILE",0,1
	MESS_MAC  RD7FONT,SPACING20,200,127,ROBO_WHITE,STRCNRM,0
	.byte	"SHAWN LIPTAK",0,1
	MESS_MAC  RD7FONT,SPACING20,200,137,ROBO_WHITE,STRCNRM,0
	.byte	"JON HEY",0,1
	MESS_MAC  RD7FONT,SPACING20,200,147,ROBO_WHITE,STRCNRM,0
	.byte	"TONY GOSKIE",0,0
	.even

**************************************************************************
*									 *
*	   STRINGS FOR UTILITY HELP MENUS				 *
*									 *
**************************************************************************
MEH_CLCRED1	 .byte "REMOVE ANY",0
		 .EVEN
MEH_CLCRED2	 .byte "POSTED CREDITS",0
		 .EVEN
MEH_CLCRED3	 .byte "FROM THE GAME",0
		 .EVEN

MEH_CLCOIN1	 .byte "CLEAR COIN SLOT",0
		 .EVEN
MEH_CLCOIN2	 .byte "COUNTERS AND COINBOX",0
		 .EVEN
MEH_CLCOIN3	 .byte "TOTAL COLLECTIONS",0
		 .EVEN

MEH_CLAUD1	 .byte "CLEAR GAMEPLAY",0
		 .EVEN
MEH_CLAUD2	 .byte "STATISTICS",0
		 .EVEN

MEH_CLPLRECS1	.string	"CLEAR PLAYER CMOS",0
		.even
MEH_CLPLRECS2	.string	"RECORDS, INCLUDING",0
		.even
MEH_CLPLRECS3	.string	"ALL CREATED PLAYERS",0
		.even
MEH_CLPLRECS4	.string	"AND WORLD RECORDS",0
		.even

MEH_RESHS1	 .byte "RESET HIGH SCORE",0
		 .EVEN
MEH_RESHS2	 .byte "TABLE TO FACTORY",0
		 .EVEN
MEH_RESHS3	 .byte "DEFAULT VALUES",0
		 .EVEN

MEH_DEFA1	 .byte "RESET ALL GAME",0
		 .EVEN
MEH_DEFA2	 .byte "ADJUSTMENTS TO THEIR",0
		 .EVEN
MEH_DEFA3	 .byte "FACTORY DEFAULTS AND",0
		 .EVEN
MEH_DEFA4	 .byte "CLEAR PLAYER CMOS",0
		 .EVEN
MEH_DEFA5	 .byte "RECORDS, INCLUDING",0
		 .EVEN
MEH_DEFA6	 .byte "ALL CREATED PLAYERS",0
		 .EVEN
MEH_DEFA7	 .byte "AND WORLD RECORDS",0
		 .EVEN


MEH_FAC1	.STRING "RESET ALL COUNTERS,",0
		.EVEN
MEH_FAC2	.STRING "AUDITS, PLAYER CMOS",0
		.EVEN
MEH_FAC3	.STRING "RECORDS AND CREATED",0
		.EVEN
MEH_FAC4	.STRING "PLAYERS, WORLD RECORDS,",0
		.EVEN
MEH_FAC5	.STRING "TEAM STATISTICS, AND",0
		.EVEN
MEH_FAC6	.STRING "GAME ADJUSTMENTS",0
		.EVEN


**************************************************************************
*									 *
*	  MAIN MENU NAMES						 *
*									 *
**************************************************************************
MESSMAIN
	.byte	"TEST MENU",0
	.even

MESSUTIL
	.byte	"UTILITY MENU",0
	.even



CSELCT
**************************************************************************
*											     *
*   USA 1: 1 COIN = 1 CREDIT								     *
* 											     *
*          2 TO START / 2 TO CONTINUE							     *
*											     *
**************************************************************************
	.WORD	1,0,1,0,4,1,0,0,2,2	;WILLY PRICING
;;	.WORD	1,4,1,0,1,0,0,2,2	;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1			;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			;COIN VALUE
;;	.WORD	1,4,1,0			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	OCOP			;ONE COIN ONE PLAY
	.LONG	USA_1			;TITLE OF COIN MODE
	.LONG	Q_Q		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_NONE		;NO PRICING LINE ON 2/1
	.LONG	USA_QDQ			;QUARTER

**************************************************************************
*											     *
*   USA 2: 1 COIN = 1 CREDIT								     *
* 											     *
*          2 TO START / 1 TO CONTINUE							     *
*											     *
**************************************************************************
	.WORD	1,0,1,0,4,1,0,0,2,1	;WILLY PRICING
;;	.WORD	1,4,1,0,1,0,0,2,1	;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1			;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			;COIN VALUE
;;	.WORD	1,4,1,0			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	OCOP			;ONE COIN ONE PLAY
	.LONG	USA_2			;TITLE OF COIN MODE
	.LONG	Q_Q		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_NONE		;NO PRICING LINE ON 2/1
	.LONG	USA_QDQ			;QUARTER


**************************************************************************
*											     *
* 	USA 3	 COINAGE IS 25 CENT		 					     *
*		 1 TO START / 1 TO CONTINUE						*
*											     *
**************************************************************************

	.WORD	1,0,1,0,4,1,0,0,1,1	   ;WILLY PRICING
;;	.WORD	1,4,1,0,1,0,0,1,1	   ;WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1				;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
;;	.WORD	1,4,1,0			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;ONE COIN ONE PLAY
	.LONG	USA_3			 ;TITLE OF COIN MODE
	.LONG	Q_Q			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_NONE		;NO PRICING LINE ON 2/1
	.LONG	USA_QDQ			;QUARTER

**************************************************************************
*											     *
* 	USA 4	 COINAGE IS 50 CENT	 3/$1.00					     *
*		 1 TO START / 1 TO CONTINUE						*
*											     *
**************************************************************************

	.WORD	1,0,1,0,4,2,4,0,1,1     ; WILLY PRICING
;;	.WORD	1,4,1,0,2,4,0,1,1     ; WILLY PRICING
	.WORD	4		  	; 4 COINS PER DOLLAR (FOR CALC)
	.WORD	1		  	; DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4		   	; COIN VALUE
;;	.WORD	1,4,1,0		   	; COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	; CHARACTER STRINGS.
	.LONG	CSM_LIST		; PRINT THE 2 THE OP SEES
	.LONG	USA_4			; TITLE OF COIN MODE
	.LONG	DOLLAR_3		; 1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			; SHOW LINE 2
	.LONG	USA_QDQ			; QUARTER
						

**************************************************************************
*											     *
*  ADDITION "FULL PRICE" COINAGES							     *
*											     *
**************************************************************************

	.IF	FULLPRICE

**************************************************************************
*											     *
* 	USA 5	 COINAGE IS 50 CENT	 4/$1.00					     *
*		 2 TO START / 1 TO CONTINUE						*
*											     *
**************************************************************************

	.WORD	3,0,3,0,12,4,12,6,2,1	 ;WILLY PRICING
;;	.WORD	3,12,3,0,4,12,6,2,1	 ;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;NO COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
;;	.WORD	1,4,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_5			 ;TITLE OF COIN MODE
	.LONG	DOLLAR_4			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

*
*	USA 6	 50 PER CREDIT
*
	.WORD	1,0,1,0,4,2,0,0,1,1	; WILLY PRICING
;;	.WORD	1,4,1,0,2,0,0,1,1	; WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1				;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;2 COINS PER PLAYER
	.LONG	USA_6			 ;TITLE OF COIN MODE
	.LONG	F_F_1S1C		 ;2 COINS PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_1			;SHOW LINE 1
	.LONG	USA_QDQ			;QUARTER
*						
*	USA 7	 COINAGE IS 50 CENT	 3/$1.00
*
;;	.WORD	1,4,1,0,2,4,0,1,1	   ;WILLY PRICING
	.WORD	1,0,1,0,4,2,4,0,1,1     ; WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;DISPLAY COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_7			 ;TITLE OF COIN MODE
	.LONG	UFS3D			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

*						
*	USA 8	 COINAGE IS 50 CENT	 4/$1.00
*
*	       L, C,R, 4,DBV,U/C,U/B,MINUNITS /START /CONTINUE
;;;;	.WORD	3,12,3,0,4,12,6,2,2	 ;WILLY PRICING
	.WORD	3,0,3,0,12,4,12,6,2,2	 ;WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;NO COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_8			 ;TITLE OF COIN MODE
	.LONG	UFS4D			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

*	USA 9	 COINAGE IS 50 CENT	 4/$1.00
*
*	       L, C,R, 4,DBV,U/C,U/B,MINUNITS /START /CONTINUE
	.WORD	1,0,1,0,4,1,0,1,3,2	 ;WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;NO COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_9			 ;TITLE OF COIN MODE
	.LONG	Q_Q		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

*	USA 10	 COINAGE IS 50 CENT	 4/$1.00
*
	.WORD	1,0,1,0,4,1,0,1,3,3	 ;WILLY PRICING
	.WORD	4				;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0				;NO COIN FRACTIONS
	.WORD	1,0,1,0,4			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;PRINT THE 2 THE OP SEES
	.LONG	USA_10			 ;TITLE OF COIN MODE
	.LONG	Q_Q		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QDQ			;QUARTER

	.ENDIF
*
*	USA ELECTRONIC
*
	.WORD	20,2,5,1,20,5,0,0,2,2	; L,C,R,4,U/C,U/B,MINUNITS
;;	.WORD	20,2,5,1,5,0,0,2,2	; L,C,R,4,U/C,U/B,MINUNITS
	.WORD	20			; COINS/DOLLAR
	.WORD	1			; DISPLAY FRACTIONS
	.WORD	20,2,5,1,20		; L,C,R,4
;;	.WORD	20,2,5,1		; L,C,R,4
	.LONG	DOLLAR_LEAD,NULL_ST	; CHARACTER STRINGS.
	.LONG	USA_ELECTRONIC		; SPECIAL MESSAGE
	.LONG	USA_ELECTITLE		; TITLE OF COIN MODE
	.LONG	USA_EL			; SETTINGS DESCRIPTION
	.WORD	SHOW_2			; LINES TO SHOW ON
	.LONG	USA_ESLOT		; QUARTER

*
*	GERMAN 1    COINAGE IS 6 PLAYS FOR 5 DM
*			 2 TO START, 2 TO CONTINUE
*
	.WORD	6,0,30,0,0,5,0,0,2,2	 ;WILLY PRICING
;;	.WORD	6,12,30,0,5,0,0,2,2	 ;WILLY PRICING
	.WORD	1		   	 ;DMS HAVE NO FRACTIONS
	.WORD	0			 ;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,2,5,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_1			 ;TITLE OF COIN MODE
	.LONG	DM_6			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM

G1SEL	EQU	($-CSELCT)/CS_SIZE	    ;COIN SELECT VALUE FOR GERMAN 1
*
*	GERMAN 2    COINAGE IS 7 PLAYS FOR 5 DM
*			 2 TO START, 1 TO CONTINUE
*
	.WORD	6,0,30,0,0,5,30,0,2,1		;WILLY PRICING
;;	.WORD	6,12,30,0,5,30,0,2,1		;WILLY PRICING
	.WORD	1				;DMS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,2,5,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_2			 ;TITLE OF COIN MODE
	.LONG	DM_7			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM
*
*	GERMAN 3    COINAGE IS 8 PLAYS FOR 5 DM
*			 2 TO START, 1 TO CONTINUE
*
	.WORD	7,0,35,0,0,5,35,0,2,1		;WILLY PRICING
;;	.WORD	7,14,35,0,5,35,0,2,1		;WILLY PRICING
	.WORD	1				;DMS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,2,5,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_3			 ;TITLE OF COIN MODE
	.LONG	DM_8			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM
*
*	GERMAN 4    COINAGE IS 5 PLAYS FOR 5 DM
*			 2 TO START, 1 TO CONTINUE
*
	.WORD	1,0,5,0,0,1,0,0,2,1	   ;WILLY PRICING
;;	.WORD	1,2,5,0,1,0,0,2,1	   ;WILLY PRICING
	.WORD	1				;DMS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,2,5,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_4			 ;TITLE OF COIN MODE
	.LONG	DM_5			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM

*
*	GERMAN 5    COINAGE IS 6 PLAYS FOR 5 DM
*			 2 TO START, 1 TO CONTINUE
*
	.WORD	6,0,30,0,0,5,0,0,2,1	 ;WILLY PRICING
;;	.WORD	6,12,30,0,5,0,0,2,1	 ;WILLY PRICING
	.WORD	1		   	 ;DMS HAVE NO FRACTIONS
	.WORD	0			 ;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,2,5,0			 ;COIN VALUE
	.LONG	NULL_ST,DM_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	GERMAN_5			 ;TITLE OF COIN MODE
	.LONG	DM_6			  ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	GERMAN_15			;1 DM / 5 DM

*
*	GERMAN ELECTRONIC
*			 2 TO START, 2 TO CONTINUE
*
	.WORD	60,12,24,0,0,10,0,0,2,2	; L,C,R,4,U/C,U/B,MINUNITS
;;	.WORD	60,12,24,0,10,0,0,2,2	; L,C,R,4,U/C,U/B,MINUNITS
	.WORD	1			; COINS/DOLLAR
	.WORD	0			; DISPLAY FRACTIONS
	.WORD	5,1,2,0,0			; L,C,R,4
;;	.WORD	5,1,2,0			; L,C,R,4
	.LONG	NULL_ST,DM_TRAIL	;CHARACTER STRINGS.
	.LONG	GERMAN_ELECTRONIC	; SPECIAL MESSAGE
	.LONG	GERMAN_ELECTITLE	; TITLE OF COIN MODE
	.LONG	DM112265		; SETTINGS DESCRIPTION
	.WORD	SHOW_3			; LINES TO SHOW ON
	.LONG	GERMAN_ESLOT		; QUARTER

****************************************************************************
****************************************************************************
*******	THE FOLLOWING NUMBERS ARE FIGURED FOR THE FRENCH SETTINGS
*******	REQUESTED BY DIMITRI K. OF P.S.D.
*******
*******			 	1F   5F   10F   U/C   U/B  M/U
*******				--------------------------------
*******	1/2F  3/5F    7/10F	3	15	 30	  5	  30    0
*******	1/3F  2/5F    5/10F	2	10	 20	  5	  20    0
*******	1/5F  3/10F		1	 5	 10    5    10    0
*******	1/5F  3/10F   7/20F	3	15	 30	 10	  60   15
*******	2/5F  4/10F   9/20F	2	10	 20	  5	  40   10
*******	2/5F  5/10F  11/20F	1	 5	 10	  2	  20    5
*******
*
*
*	FRENCH 1	      2/5F	 5/10F
*
*
	.WORD	2,0,4,0,0,1,4,0,2,2		; 2/5F    5/10F
;;	.WORD	2,0,4,0,1,4,0,2,2		; 2/5F    5/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
;;	.WORD	5,0,10,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST			;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_1			;TITLE OF COIN MODE
	.LONG	FIVE_10				;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	FRENCH510

F1SEL	EQU	($-CSELCT)/CS_SIZE	    ;COIN SELECT VALUE FOR FRENCH 1

*
*	FRENCH 2	      2/5F	 4/10F
*
*
	.WORD	2,0,4,0,0,1,0,0,2,1	   ; 2/5F    4/10F
;;	.WORD	2,0,4,0,1,0,0,2,1	   ; 2/5F    4/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
;;	.WORD	5,0,10,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_2			 ;TITLE OF COIN MODE
	.LONG	FOUR_10			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	FRENCH510
*
*	FRENCH 3	      1/5F  3/10F	
*
*
	.WORD	1,0,2,0,0,1,2,0,2,1	    ;1/5F  3/10F	
;;	.WORD	1,0,2,0,1,2,0,2,1	    ;1/5F  3/10F	
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
;;	.WORD	5,0,10,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_3			 ;TITLE OF COIN MODE
	.LONG	THREE_10			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2
	.LONG	FRENCH510
*
*	FRENCH 4	      1/5F  2/10F 
*
*
	.WORD	1,0,2,0,0,1,0,0,2,1	 ;1/5F  2/10F
;;	.WORD	1,0,2,0,1,0,0,2,1	 ;1/5F  2/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
;;	.WORD	5,0,10,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_4			 ;TITLE OF COIN MODE
	.LONG	TWO_10			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_1
	.LONG	FRENCH510

	.IF	FULLPRICE

*
*
*	FRENCH 5	      2/5F	 5/10F	11/2 X 10F
*
*
	.WORD	5,0,10,0,0,2,20,0,2,1		 ;2/5F  5/10F	11/20F
;;	.WORD	5,0,10,0,2,20,0,2,1		 ;2/5F  5/10F	11/20F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
;;	.WORD	5,0,10,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_5			 ;TITLE OF COIN MODE
	.LONG	FIVE_10_11		    ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH510
*
*	FRENCH 6	      2/5F	 4/10F	9/2 X 10F
*
*
	.WORD	2,0,4,0,0,1,8,0,2,1		   ;2/5F	4/10F   9/20F
;;	.WORD	2,0,4,0,1,8,0,2,1		   ;2/5F	4/10F   9/20F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
;;	.WORD	5,0,10,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_6			 ;TITLE OF COIN MODE
	.LONG	FOUR_10_9			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH510
*
*	FRENCH 7	      1/5F	 3/10F	7/2 X 10F
*
*
	.WORD	3,0,6,0,0,2,12,0,2,1		  ;1/5F  3/10F   7/20F
;;	.WORD	3,0,6,0,2,12,0,2,1		  ;1/5F  3/10F   7/20F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
;;	.WORD	5,0,10,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_7			 ;TITLE OF COIN MODE
	.LONG	THREE_10_7		    ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH510
*
*	FRENCH 8	      1/5F	 2/10F	5/2 X 10F
*
*
	.WORD	1,0,2,0,0,1,4,0,2,1		   ;1/5F	2/10F  5/20F
;;	.WORD	1,0,2,0,1,4,0,2,1		   ;1/5F	2/10F  5/20F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	5,0,10,0,0			;COIN VALUE
;;	.WORD	5,0,10,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_8			 ;TITLE OF COIN MODE
	.LONG	TWO_10_5			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH510

*
*	FRENCH 9	      1/3 X 1F	  2/5F
*
*	COIN SLOTS ARE	1F -- 5F
*
*
	.WORD	2,0,10,0,0,5,0,0,2,1		  ;1/3X1F  2/5F
;;	.WORD	2,0,10,0,5,0,0,2,1		  ;1/3x1F  2/5F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,0,5,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_9			 ;TITLE OF COIN MODE
	.LONG	F1325			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH1F5F
*
*	FRENCH 10	      1/2 X 1F	  3/5F
*
*	COIN SLOTS ARE	1F -- 5F
*
*
	.WORD	3,0,15,0,0,5,0,0,2,1		  ;1/2X1F  3/5F
;;	.WORD	3,0,15,0,5,0,0,2,1		  ;1/2x1F  3/5F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,0,5,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_10			;TITLE OF COIN MODE
	.LONG	F1235			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH1F5F
*
*	FRENCH 11	      1/3 X 1F	  2/5F	5/2 X 5F
*
*	COIN SLOTS ARE	1F -- 5F
*
*
	.WORD	2,0,10,0,0,5,20,0,2,1		 ;1/3X1F	2/5F  5/10F
;;	.WORD	2,0,10,0,5,20,0,2,1		 ;1/3x1F	2/5F  5/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
;;	.WORD	1,0,5,0			 ;COIN VALUE
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_11			;TITLE OF COIN MODE
	.LONG	F13255			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH1F5F

*
*	FRENCH 12	      1/2 X 1F	  3/5F	  7 / 2 X 5F
*
*	COIN SLOTS ARE	1F -- 5F
*
*
	.WORD	3,0,15,0,0,5,30,0,2,1		 ;1/2X1F	3/5F  7/10F
;;	.WORD	3,0,15,0,5,30,0,2,1		 ;1/2x1F	3/5F  7/10F
	.WORD	1				;1 FRANC PER FRANC
	.WORD	0				;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,0,5,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST			 ;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_12			;TITLE OF COIN MODE
	.LONG	F12355			 ;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_3			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG	FRENCH1F5F

	.ENDIF

*
*	FRANCE ELECTRONIC    1/3 X 1F   2/5F   5/2 X 5F
*
	.WORD	1,15,6,30,0,3,0,0,2,2	; L,C,R,4,U/C,U/B,MINUNITS
;;	.WORD	1,15,6,0,3,0,0,2,2	; L,C,R,4,U/C,U/B,MINUNITS
	.WORD	1			; COINS/DOLLAR
	.WORD	0			;DON'T DISPLAY COIN FRACTIONS
	.WORD	1,10,5,20,0		; L,C,R,4
;;	.WORD	1,10,5,0		; L,C,R,4
	.LONG	NULL_ST,FRANC_TRAIL	; CHARACTER STRINGS.
	.LONG	FRANCE_ELECTRONIC	; SPECIAL MESSAGE
	.LONG	FRENCH_ELECTITLE	; TITLE OF COIN MODE
	.LONG	F13255			;COIN PAGE DESCRIPTION
	.WORD	SHOW_3			;THREE LINES FOR THIS BABY
	.LONG	FRANCE_ESLOT		; QUARTER

*
*	CANADA    COINAGE IS 50 CENT   3/$1.00
*
	.WORD   1,0,4,0,4,2,4,0,2,2    ;WILLY PRICING
;;	.WORD   1,0,4,0,2,4,0,2,2    ;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1			;DISPLAY COIN FRACTIONS
	.WORD	1,0,4,0,4			;COIN VALUE
;;	.WORD	1,0,4,0			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	CSM_LIST		;PRINT THE 2 THE OP SEES
	.LONG   CANADA			;TITLE OF COIN MODE
	.LONG	CAN_1503D		;1 PLAY 50, 3 FOR A DOLLAR
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG   CAN_QD			;QUARTER

	.IF	FULLPRICE

*	SWISS 1    COINAGE IS 6 PLAYS FOR 5 FRANC

	.WORD	6,0,30,0,0,5,0,0,2,2		 ;WILLY PRICING
;;	.WORD	6,0,30,0,5,0,0,2,2		 ;WILLY PRICING
	.WORD	1				;FRANCS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,0,5,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWISS_1			;TITLE OF COIN MODE
	.LONG	SFRANC_6			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_2
	.LONG	SWISS15

*	SWISS 2    COINAGE IS 7 PLAYS FOR 5 FRANC

	.WORD	6,0,30,0,0,5,30,0,2,2		;WILLY PRICING
;;	.WORD	6,0,30,0,5,30,0,2,2		;WILLY PRICING
	.WORD	1				;FRANCS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0			 ;COIN VALUE
;;	.WORD	1,0,5,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWISS_2			;TITLE OF COIN MODE
	.LONG	SFRANC_7			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_2
	.LONG	SWISS15

*	SWISS 3     COINAGE IS 8 PLAYS FOR 5 FRANC

	.WORD	7,0,35,0,0,5,35,0,2,2		;WILLY PRICING
;;	.WORD	7,0,35,0,5,35,0,2,2		;WILLY PRICING
	.WORD	1				;FRANCS HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0				;COIN VALUE
;;	.WORD	1,0,5,0				;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWISS_3				;TITLE OF COIN MODE
	.LONG	SFRANC_8			;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_2
	.LONG	SWISS15

*	ITALY COINAGE IS 1 PLAYS FOR 500 LIRE

	.WORD	1,0,1,0,0,1,0,0,2,2		;WILLY PRICING
;;	.WORD	1,0,1,0,1,0,0,2,2		;WILLY PRICING
	.WORD	1				;LIRE HAVE NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
;;	.WORD	500,0,500,0			 ;COIN VALUE
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	NULL_ST,LIRE_TRAIL		 ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ITALY_1			;TITLE OF COIN MODE
	.LONG	P1500L			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	ITALYLIRE


*	U.K. 1
*
*	LFT = 20P  RGT = 50P  3RD = ---  4TH = ---
*	1 PLAY / 20 P
*	3 PLAY / 50 P
*
*		LFT,CTR,RGT,XTR,DBV,U/C,U/B,U/M,STR,CNT

	.WORD	  6,  0, 15,  0,  0,  5,  0,  0,  2,  2	;FOR CREDIT CALC
	.WORD	10					;COINS PER ...
	.WORD	0					;NO COIN FRAC DISPLAY
	.WORD	  2,  0,  5,  0,  0			;COIN VALUES
	.LONG	NULL_ST,POUND_TRAIL			;LMES & RMES
	.LONG	UK_MECH1				;CREDIT SCREEN INFO
	.LONG	UK_1					;COIN MODE TITLE
	.LONG	UK_CL1					;COIN LIST
	.WORD	SHOW_2					;SHOW 2ND LINE
	.LONG	UK2050					;COIN SLOT DESCRIPTION


*	U.K. 2
*
*	LFT = 20P  RGT = 50P  3RD = ---  4TH = ---
*	2 PLAY / 20 P
*	5 PLAY / 50 P
*
*		LFT,CTR,RGT,XTR,DBV,U/C,U/B,U/M,STR,CNT

	.WORD	  2,  0,  5,  0,  0,  1,  0,  0,  2,  2	;FOR CREDIT CALC
	.WORD	10					;COINS PER ...
	.WORD	0					;NO COIN FRAC DISPLAY
	.WORD	  2,  0,  5,  0,  0			;COIN VALUES
	.LONG	NULL_ST,POUND_TRAIL			;LMES & RMES
	.LONG	UK_MECH2				;CREDIT SCREEN INFO
	.LONG	UK_2					;COIN MODE TITLE
	.LONG	UK_CL2					;COIN LIST
	.WORD	SHOW_2					;SHOW 2ND LINE
	.LONG	UK2050					;COIN SLOT DESCRIPTION


*	U.K. ECA 1
*
*	LFT = PND  RGT = 50P  3RD = 20P  4TH = 10P
*	1 PLAY / 20 P
*	3 PLAY / 50 P
*	7 PLAY / PND
*
*		LFT,CTR,RGT,XTR,DBV,U/C,U/B,U/M,STR,CNT

	.WORD	 28,  4, 12,  2,  0,  4,  0,  0,  2,  2	;FOR CREDIT CALC
	.WORD	10					;COINS PER ...
	.WORD	0					;NO COIN FRAC DISPLAY
	.WORD	 10,  2,  5,  1,  0			;COIN VALUES
	.LONG	NULL_ST,POUND_TRAIL			;LMES & RMES
	.LONG	UK_ECA1					;CREDIT SCREEN INFO
	.LONG	UK_1E					;COIN MODE TITLE
	.LONG	UK_CL1E					;COIN LIST
	.WORD	SHOW_3					;SHOW 2ND LINE
	.LONG	UK_ELEC					;COIN SLOT DESCRIPTION


*	U.K. ECA 2
*
*	LFT = PND  RGT = 50P  3RD = 20P  4TH = 10P
*	1 PLAY / 30 P
*	2 PLAY / 50 P
*	4 PLAY / PND
*
*		LFT,CTR,RGT,XTR,DBV,U/C,U/B,U/M,STR,CNT

	.WORD	 12,  2,  6,  1,  0,  3,  0,  0,  1,  1	;FOR CREDIT CALC
	.WORD	10					;COINS PER ...
	.WORD	0					;NO COIN FRAC DISPLAY
	.WORD	 10,  2,  5,  1,  0			;COIN VALUES
	.LONG	NULL_ST,POUND_TRAIL			;LMES & RMES
	.LONG	UK_ECA2					;CREDIT SCREEN INFO
	.LONG	UK_2E					;COIN MODE TITLE
	.LONG	UK_CL2E					;COIN LIST
	.WORD	SHOW_3					;SHOW 2ND LINE
	.LONG	UK_ELEC					;COIN SLOT DESCRIPTION


*	U.K. ECA 3
*
*	LFT = PND  RGT = 50P  3RD = 20P  4TH = 10P
*	1 PLAY / 30 P
*	2 PLAY / 50 P
*	5 PLAY / PND
*
*		LFT,CTR,RGT,XTR,DBV,U/C,U/B,U/M,STR,CNT

	.WORD	 15,  2,  6,  1,  0,  3,  0,  0,  1,  1	;FOR CREDIT CALC
	.WORD	10					;COINS PER ...
	.WORD	0					;NO COIN FRAC DISPLAY
	.WORD	 10,  2,  5,  1,  0			;COIN VALUES
	.LONG	NULL_ST,POUND_TRAIL			;LMES & RMES
	.LONG	UK_ECA3					;CREDIT SCREEN INFO
	.LONG	UK_3E					;COIN MODE TITLE
	.LONG	UK_CL3E					;COIN LIST
	.WORD	SHOW_3					;SHOW 2ND LINE
	.LONG	UK_ELEC					;COIN SLOT DESCRIPTION


*	U.K. ECA 4
*
*	LFT = PND  RGT = 50P  3RD = 20P  4TH = 10P
*	1 PLAY / 50 P
*	2 PLAY / PND
*
*		LFT,CTR,RGT,XTR,DBV,U/C,U/B,U/M,STR,CNT

	.WORD	 10,  2,  5,  1,  0,  5,  0,  0,  1,  1	;FOR CREDIT CALC
	.WORD	10					;COINS PER ...
	.WORD	0					;NO COIN FRAC DISPLAY
	.WORD	 10,  2,  5,  1,  0			;COIN VALUES
	.LONG	NULL_ST,POUND_TRAIL			;LMES & RMES
	.LONG	UK_ECA4					;CREDIT SCREEN INFO
	.LONG	UK_4E					;COIN MODE TITLE
	.LONG	UK_CL4E					;COIN LIST
	.WORD	SHOW_2					;SHOW 2ND LINE
	.LONG	UK_ELEC					;COIN SLOT DESCRIPTION


*	U.K. ECA 5
*
*	LFT = PND  RGT = 50P  3RD = 20P  4TH = 10P
*	1 PLAY / 50 P
*	3 PLAY / PND
*
*		LFT,CTR,RGT,XTR,DBV,U/C,U/B,U/M,STR,CNT

	.WORD	 15,  2,  5,  1,  0,  5,  0,  0,  1,  1	;FOR CREDIT CALC
	.WORD	10					;COINS PER ...
	.WORD	0					;NO COIN FRAC DISPLAY
	.WORD	 10,  2,  5,  1,  0			;COIN VALUES
	.LONG	NULL_ST,POUND_TRAIL			;LMES & RMES
	.LONG	UK_ECA5					;CREDIT SCREEN INFO
	.LONG	UK_5E					;COIN MODE TITLE
	.LONG	UK_CL5E					;COIN LIST
	.WORD	SHOW_2					;SHOW 2ND LINE
	.LONG	UK_ELEC					;COIN SLOT DESCRIPTION


*	U.K. ECA 6
*
*	LFT = PND  RGT = 50P  3RD = 20P  4TH = 10P
*	3 PLAY / PND
*
*		LFT,CTR,RGT,XTR,DBV,U/C,U/B,U/M,STR,CNT

	.WORD	 30,  6, 15,  3,  0, 10,  0, 20,  1,  1	;FOR CREDIT CALC
	.WORD	10					;COINS PER ...
	.WORD	0					;NO COIN FRAC DISPLAY
	.WORD	 10,  2,  5,  1,  0			;COIN VALUES
	.LONG	NULL_ST,POUND_TRAIL			;LMES & RMES
	.LONG	UK_ECA6					;CREDIT SCREEN INFO
	.LONG	UK_6E					;COIN MODE TITLE
	.LONG	UK_CL6E					;COIN LIST
	.WORD	SHOW_1					;SHOW 2ND LINE
	.LONG	UK_ELEC					;COIN SLOT DESCRIPTION


*	U.K. ELECT/CCU
*
*	LFT = PND  RGT = CCU  3RD = ---  4TH = ---
*	1 PLAY / 30 P
*	2 PLAY / 50 P
*	4 PLAY / PND
*
*		LFT,CTR,RGT,XTR,DBV,U/C,U/B,U/M,STR,CNT

	.WORD	  1,  0,  0,  0,  0,  1,  0,  0,  1,  1	;FOR CREDIT CALC
	.WORD	10					;COINS PER ...
	.WORD	0					;NO COIN FRAC DISPLAY
	.WORD	  1,  0,  0,  0,  0			;COIN VALUES
	.LONG	NULL_ST,POUND_TRAIL			;LMES & RMES
	.LONG	UK_ECAC					;CREDIT SCREEN INFO
	.LONG	UK_CE					;COIN MODE TITLE
	.LONG	UK_CLCE					;COIN LIST
	.WORD	SHOW_3					;SHOW 2ND LINE
	.LONG	UK_CCU					;COIN SLOT DESCRIPTION


*	DONE BECAUSE WE LEARNED SOME NEW SPANISH SHIT!

*	SPAIN 1     1 PLAY / 100 PESETA   6 PLAY / 500 PESETA

	.WORD	1,0,5,0,0,1,5,0,2,2		;WILLY PRICING
	.WORD	1				;NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0			;COIN VALUE
	.LONG	NULL_ST,PESETA_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SP_1				;TITLE OF COIN MODE
	.LONG	SP_5100				;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	PESETA100


*	SPAIN 2     1 PLAY / 25 PESETA   5 PLAY / 100 PESETA

	.WORD	1,0,5,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;NO FRACTIONS
	.WORD	0				;DON'T DISPLAY COIN FRACTIO
	.WORD	1,0,5,0,0			;COIN VALUE
	.LONG	NULL_ST,PESETA_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SP_2			  ;TITLE OF COIN MODE
	.LONG	SP_4100			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	PESETA100


*	AUSTRALIA 1   1 PLAY / 3 X 20 CENTS	2 FOR $1.00

	.WORD	2,0,10,0,0,5,0,0,2,2		  ;WILLY PRICING
	.WORD	5				;DOLLARS
	.WORD	0				;DON'T SHOW FRACTIONS FOR T
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	AUS_1			 ;TITLE OF COIN MODE
	.LONG	AU_60			 ;1 COIN PER CREDIT (SERIES OF S
	.WORD	SHOW_2
	.LONG	AUST20C
*
*	AUSTRALIA 2   1 PLAY / $1.00    2 PLAYS FOR $2.00
*
	.WORD	1,0,5,0,0,5,0,0,1,1	 ; WILLY PRICING
	.WORD	5			 ; DOLLARS
	.WORD	1			 ; SHOW FRACTIONS FOR THE 3 C
	.WORD	1,0,5,0,0			 ; COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	 ; CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	AUS_2			 ; TITLE OF COIN MODE
	.LONG	AU_100			 ; 1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	AUST20C

	.ENDIF

*	JAPAN 1  1 PLAY / 100 YEN

	.WORD	1,0,1,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	1,0,1,0,0		   ;COIN VALUE
	.LONG	NULL_ST,YEN_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	JAP_1			 ;TITLE OF COIN MODE
	.LONG	JAP_100			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	YEN100

	.IF	FULLPRICE
*	JAPAN 2  2 PLAY / 100 YEN

	.WORD	2,0,2,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	1,0,1,0,0		   ;COIN VALUE
	.LONG	NULL_ST,YEN_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	JAP_2			 ;TITLE OF COIN MODE
	.LONG	JAP_200			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	YEN100

*	AUSTRIA  1   1 PLAY / 5 SCHILLING  2 PLAY / 10 SCHILLING

	.WORD	1,0,2,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,SHILL_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ASTA_1			 ;TITLE OF COIN MODE
	.LONG	ASTA_15			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	SHILL510

*	AUSTRIA  2   1 PLAY / 2 X 5 SCHILLING	3 PLAY / 10 SCHILLING

	.WORD	1,0,2,0,0,2,4,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	5,0,10,0,0			;COIN VALUE
	.LONG	NULL_ST,SHILL_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ASTA_2			 ;TITLE OF COIN MODE
	.LONG	ASTA_10			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	SHILL510

*	BELGIUM 1  1 PLAY / 20F

	.WORD	1,0,1,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	4,0,4,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	BEL_1			 ;TITLE OF COIN MODE
	.LONG	BEL_120			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	FRANC20

*	BELGIUM 2  3 PLAY / 20F

	.WORD	3,0,3,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	4,0,4,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	BEL_2			 ;TITLE OF COIN MODE
	.LONG	BEL_320			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	FRANC20

*	BELGIUM 3  2 PLAY / 20F

	.WORD	2,0,2,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	1				;FRACTIONS OK
	.WORD	4,0,4,0,0			 ;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	BEL_3			 ;TITLE OF COIN MODE
	.LONG	BEL_220			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	FRANC20

*
*	BELGIUM ELECTRONIC
*
	.WORD	10,1,4,0,0,4,0,0,2,2		; L,C,R,4,U/C,U/B,MINUNITS
	.WORD	1			; COINS/DOLLAR
	.WORD	1			; DISPLAY FRACTIONS
	.WORD	10,1,4,0,0		; L,C,R,4
	.LONG	NULL_ST,FRANC_TRAIL		 ;CHARACTER STRINGS.
	.LONG	BELGIUM_ELECTRONIC		; SPECIAL MESSAGE
	.LONG	BELGIUM_ELECTITLE		; TITLE OF COIN MODE
	.LONG	BEL_ELEC			; SETTINGS DESCRIPTION
	.WORD	SHOW_2			; LINES TO SHOW ON
	.LONG	BELGIUM_ESLOT		; QUARTER

*	SWEDEN	1 PLAY / 3 X 1 KRONA   2 PLAY	5 KRONA

	.WORD	2,0,10,0,0,5,0,0,2,2		 ;WILLY PRICING
	.WORD	1				;DOLLARS
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,KRONA_TRAIL	   ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWED_1			;TITLE OF COIN MODE
	.LONG	SWED_2X5			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_1
	.LONG	KRONA5

*	NEW ZEALAND 1	1 PLAY / 3 X 20 CENT

	.WORD	1,0,1,0,0,3,0,0,1,1		   ;WILLY PRICING
	.WORD	5				;FIVE PER
	.WORD	1				;SHOW FRACTIONS
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NZ_1			  ;TITLE OF COIN MODE
	.LONG	NZ_13			 ;1 COIN PER CREDIT (SERIES OF S
	.WORD	SHOW_1
	.LONG	NZ20


*	NEW ZEALAND 2	1 PLAY / 2 X 20 CENT

	.WORD	1,0,1,0,0,2,0,0,1,1		   ;WILLY PRICING
	.WORD	5				;FIVE PER
	.WORD	1				;SHOW FRACTIONS
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NZ_2			  ;TITLE OF COIN MODE
	.LONG	NZ_12			 ;1 COIN PER CREDIT (SERIES OF S
	.WORD	SHOW_1
	.LONG	NZ20

*	NETHERLANDS	1 PLAY / 1 HFL.	3 PLAY / 2.5 HFL.

	.WORD	1,0,3,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	2,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,HFL_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NETH			  ;TITLE OF COIN MODE
	.LONG	NETH_HF			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	HFSLOT


*	FINLAND	1 PLAY / 1 MARKKA

	.WORD	1,0,1,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	NULL_ST,MARKKA_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	FINLAND			;TITLE OF COIN MODE
	.LONG	FINMKA			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	MKSLOT

*	NORWAY	1 PLAY / 2 X 1 KRONE    3/ 5 X 1 KRONE

	.WORD	3,0,3,0,0,5,0,0,2,2		   ;WILLY PRICING
	.WORD	1				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,1,0,0			 ;COIN VALUE
	.LONG	NULL_ST,KRONE_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NORWAY			;TITLE OF COIN MODE
	.LONG	KR_LIST			 ;1 COIN PER CREDIT (SERIES OF STRI
	.WORD	SHOW_2
	.LONG	NKRSLOT

*	DENMARK	1 PLAY / 2 X 1 KRONE    3/ 5 KRONE	  7 / 10 KRONE

	.WORD	3,0,15,0,0,5,30,0,2,2		 ;WILLY PRICING
	.WORD	1				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,5,0,0			 ;COIN VALUE
	.LONG	NULL_ST,KRONE_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	DENMARK			;TITLE OF COIN MODE
	.LONG	DKR_LIST			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_3
	.LONG	DKRSLOT


*	ANTILLES      1 PLAY / 25 CENTS	4 PLAYS / 1 GUILDER

	.WORD	1,0,4,0,0,1,0,0,2,2		   ;WILLY PRICING
	.WORD	4				;FIVE PER
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,4,0,0			 ;COIN VALUE
	.LONG	NULL_ST,GUILDER_TRAIL	  ;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ANTILLES			 ;TITLE OF COIN MODE
	.LONG	ANT_LIST			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_1
	.LONG	ANTSLOT

*	HUNGARY     1 CREDIT / 2X10 FORINT  3 CREDITS / 2X20 FORINT

	.WORD	1,0,2,0,0,2,4,0,2,2		;WILLY PRICING
	.WORD	1				;1 TO 1
	.WORD	0				;DON'T SHOW FRACTIONS
	.WORD	1,0,2,0,0			;COIN VALUE
	.LONG	NULL_ST,FORINT_TRAIL		;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	HUNGARY				;TITLE OF COIN MODE
	.LONG	HUNG_LIST			 ;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_1
	.LONG	HUNGSLOT

	.ENDIF

CS_ENTS	EQU	($-CSELCT)/CS_SIZE	    ;NUMBER OF ENTRIES IN TABLE


;
;	DIP SWITCH TABLES
;

USABASE	EQU	1
GERBASE	EQU	G1SEL
FRABASE	EQU	F1SEL

	.IF	FULLPRICE

USADIP	.WORD	USABASE+0, USABASE+1, USABASE+2, USABASE+3, USABASE+8
	.WORD	USABASE+8, USABASE+8

GERDIP	.WORD	GERBASE+0, GERBASE+1, GERBASE+2, GERBASE+3, GERBASE+4
	.WORD	GERBASE+4, GERBASE+4

FRADIP	.WORD	FRABASE+0, FRABASE+1, FRABASE+2, FRABASE+3, FRABASE+12
	.WORD	FRABASE+12, FRABASE+12

	.ELSE

USADIP	.WORD	USABASE+0, USABASE+1, USABASE+2, USABASE+3, USABASE+4
	.WORD	USABASE+4, USABASE+4

GERDIP	.WORD	GERBASE+0, GERBASE+1, GERBASE+2, GERBASE+3, GERBASE+4
	.WORD	GERBASE+4, GERBASE+4

FRADIP	.WORD	FRABASE+0, FRABASE+1, FRABASE+2, FRABASE+3, FRABASE+4
	.WORD	FRABASE+4, FRABASE+4

	.ENDIF


DIPCOINTAB	.LONG	USADIP, GERDIP, FRADIP, USADIP


**************************************************************************
*									*
*	 COLLECTION MESSAGES					  *
*									*
**************************************************************************
ME_ZERO	 .STRING "0"
	.BYTE	0
	.EVEN

ME_DASH		.string	"-",0
	.even

ME_DECIMAL	.STRING "."
	.BYTE	0
	.EVEN

ME_COLON .STRING ":"
	.BYTE	0
	.EVEN

DOLLAR_LEAD	.STRING "$  "
	.BYTE	0
	.EVEN

POUND_LEAD
	.STRING FONT_EPOUND,"  ",0
	.EVEN
POUND_TRAIL
	.STRING	"  PND",0
	.EVEN

NULL_ST	
	.BYTE	0
	.EVEN

DM_TRAIL	.STRING "  DM"
	.BYTE	0
	.EVEN

FRANC_TRAIL	.STRING "  FRANC"
	.BYTE	0
	.EVEN
	
	.IF	FULLPRICE
LIRE_TRAIL	.STRING "  LIRE"
	.BYTE	0
	.EVEN

PESETA_TRAIL	.STRING "  PESETA"
	.BYTE	0
	.EVEN
	.ENDIF

YEN_TRAIL
	.STRING "  YEN"
	.BYTE	0
	.EVEN

	.IF	FULLPRICE
SHILL_TRAIL
	.STRING "  SCHILLINGS"
	.BYTE	0
	.EVEN

KRONA_TRAIL
	.STRING "  KRONA"
	.BYTE	0
	.EVEN
	.ENDIF

COINS_TRAIL
	.STRING "  COINS"
	.BYTE	0
	.EVEN

	.IF	FULLPRICE
HFL_TRAIL
	.STRING "  HFI."
	.BYTE	0
	.EVEN

MARKKA_TRAIL
	.STRING "  MARKKA"
	.BYTE	0
	.EVEN

KRONE_TRAIL
	.STRING "  KRONE"
	.BYTE 0
	.EVEN

GUILDER_TRAIL
	.STRING "  GUILDER"
	.BYTE 0
	.EVEN

FORINT_TRAIL
	.STRING	"  FT",0
	.ENDIF

*
*	FOR THE COINAGE ADJUSTMENT MODE:
*
*
*	THIS SET IS TITLES FOR THE CANNED MODES.
*
USA_1	.STRING "USA 1",0
	.EVEN
USA_2	.STRING "USA 2",0
	.EVEN
USA_3	.STRING "USA 3",0
	.EVEN
USA_4	.STRING "USA 4",0
	.EVEN

	.IF	FULLPRICE
USA_5	.STRING "USA 5",0
	.EVEN
USA_6	.STRING "USA 6",0
	.EVEN
USA_7	.STRING "USA 7",0
	.EVEN
USA_8	.STRING "USA 8",0
	.EVEN
USA_9	.STRING "USA 9",0
	.EVEN
USA_10	.STRING "USA 10",0
	.EVEN
	.ENDIF

USA_ELECTITLE
	.STRING	"USA ECA",0
	.EVEN

FRENCH_ELECTITLE
	.STRING	"FRANCE ECA",0
	.EVEN

GERMAN_ELECTITLE
	.STRING	"GERMAN ECA",0
	.EVEN

BEL_ELECTITLE
	.STRING	"BELGUIM ECA",0
	.EVEN

GERMAN_1 .STRING "GERMAN 1",0
	.EVEN
GERMAN_2 .STRING "GERMAN 2",0
	.EVEN
GERMAN_3 .STRING "GERMAN 3",0
	.EVEN
GERMAN_4 .STRING "GERMAN 4",0
	.EVEN
GERMAN_5 .STRING "GERMAN 5",0
	.EVEN

FRENCH_1 .STRING "FRANCE 1",0
	.EVEN
FRENCH_2 .STRING "FRANCE 2",0
	.EVEN
FRENCH_3 .STRING "FRANCE 3",0
	.EVEN
FRENCH_4 .STRING "FRANCE 4",0
	.EVEN

	.IF	FULLPRICE
FRENCH_5 .STRING "FRANCE 5",0
	.EVEN
FRENCH_6 .STRING "FRANCE 6",0
	.EVEN
FRENCH_7 .STRING "FRANCE 7",0
	.EVEN
FRENCH_8 .STRING "FRANCE 8",0
	.EVEN
FRENCH_9 .STRING "FRANCE 9",0
	.EVEN
FRENCH_10 .STRING "FRANCE 10",0
	.EVEN
FRENCH_11 .STRING "FRANCE 11",0
	.EVEN
FRENCH_12 .STRING "FRANCE 12",0
	.EVEN

CANADA
	.STRING	"CANADA",0
	.EVEN

SWISS_1 .STRING "SWISS 1"
	.BYTE	0
	.EVEN
SWISS_2 .STRING "SWISS 2"
	.BYTE	0
	.EVEN
SWISS_3 .STRING "SWISS 3"
	.BYTE	0
	.EVEN
ITALY_1 .STRING "ITALY"
	.BYTE	0
	.EVEN

UK_1	.STRING "U.K. 1"
	.BYTE	0
	.EVEN
UK_2	.STRING "U.K. 2"
	.BYTE	0
	.EVEN
UK_1E	.STRING "U.K. ECA 1"
	.BYTE	0
	.EVEN
UK_2E	.STRING "U.K. ECA 2"
	.BYTE	0
	.EVEN
UK_3E	.STRING "U.K. ECA 3"
	.BYTE	0
	.EVEN
UK_4E	.STRING "U.K. ECA 4"
	.BYTE	0
	.EVEN
UK_5E	.STRING "U.K. ECA 5"
	.BYTE	0
	.EVEN
UK_6E	.STRING "U.K. ECA 6"
	.BYTE	0
	.EVEN
UK_CE	.STRING "U.K. ELECT/CCU"
	.BYTE	0
	.EVEN

SP_1	.STRING "SPAIN 1"
	.BYTE	0
	.EVEN
SP_2	.STRING "SPAIN 2"
	.BYTE	0
	.EVEN
AUS_1	.STRING "AUSTRALIA 1"
	.BYTE	0
	.EVEN
AUS_2	.STRING "AUSTRALIA 2"
	.BYTE	0
	.EVEN
	.ENDIF

JAP_1	.STRING "JAPAN 1"
	.BYTE	0
	.EVEN

	.IF	FULLPRICE
JAP_2	.STRING "JAPAN 2"
	.BYTE	0
	.EVEN
ASTA_1	.STRING "AUSTRIA 1"
	.BYTE	0
	.EVEN
ASTA_2	.STRING "AUSTRIA 2"
	.BYTE	0
	.EVEN
BEL_1	.STRING "BELGIUM 1"
	.BYTE	0
	.EVEN
BEL_2	.STRING "BELGIUM 2"
	.BYTE	0
	.EVEN
BEL_3	.STRING "BELGIUM 3"
	.BYTE	0
	.EVEN
BELGIUM_ELECTITLE
	.STRING	"BELGIUM ECA",0
	.EVEN
SWED_1	.STRING "SWEDEN"
	.BYTE	0
	.EVEN
NZ_1	.STRING "NEW ZEALAND 1"
	.BYTE	0
	.EVEN
NZ_2	.STRING "NEW ZEALAND 2"
	.BYTE	0
	.EVEN
NETH	.STRING "NETHERLANDS"
	.BYTE	0
	.EVEN

FINLAND	.STRING "FINLAND"
	.BYTE 0
	.EVEN

NORWAY	.STRING "NORWAY"
	.BYTE 0
	.EVEN

DENMARK	.STRING "DENMARK"
	.BYTE 0
	.EVEN

ANTILLES .STRING "ANTILLES"
	.BYTE 0
	.EVEN

HUNGARY
	.STRING "HUNGARY",0
	.EVEN

	.ENDIF
*
*	THIS SECTION IS A POINTER TO STRING LISTS
*	FOR THE "CURRENT SETTING" BOX.
*
USA_EL
	.LONG	EC1
	.LONG	DOLL4
	.LONG	0
*
*	1 COIN / 1 CREDIT
Q_Q
	.LONG	C11		 ;THIS POINTS AT MESSAGE
	.LONG	0		   ;THIS ENDS LIST
*
*	2 COINS / 1 CREDIT
*
F_F_1S1C
	.LONG	C21
	.LONG	0

*************************************************************************


*
*	2 COINS / 1 CREDIT
*	4 COINS / 3 CREDITS
*
DOLLAR_3 .LONG	C21
	.LONG	C43
	.LONG	0
*
*	2 COINS / 1 CREDIT
*	4 COINS / 4 CREDITS
*
DOLLAR_4 .LONG	C21
	.LONG	C44
	.LONG	0


********************************************************************


	.IF	FULLPRICE

U1Q4D	.LONG	C11		 ;THIS POINTS AT MESSAGE
	.LONG	DOLL4		;4 FOR A DOLLAR
	.LONG	0

;UFS2D	.LONG	C21		; THIS POINTS AT MESSAGE
;	.LONG	DOLL2		; 2 FOR A DOLLAR
;	.LONG	0

UFS3D	.LONG	C21		 ;THIS POINTS AT MESSAGE
	.LONG	DOLL3		;3 FOR A DOLLAR
	.LONG	0

UFS4D	.LONG	C21		 ;THIS POINTS AT MESSAGE
	.LONG	DOLL4		;4 FOR A DOLLAR
	.LONG	0

	.ENDIF

*
*	1 PLAY 1/DM
*	5 PLAY 5/DM
*
DM_5	.LONG	DM11
	.LONG	DM55
	.LONG	0

DM_6	.LONG	DM11
	.LONG	DM65
	.LONG	0

DM_7	.LONG	DM11
	.LONG	DM75
	.LONG	0

DM_8	.LONG	DM11
	.LONG	DM85
	.LONG	0

DM112265
	.LONG	DM11
	.LONG	DM22
	.LONG	DM65
	.LONG	0

SFRANC_6     .LONG   SFRANC11
	.LONG	SFRANC65
	.LONG	0

CAN_1503D
	.LONG   C15		;THIS POINTS AT MESSAGE
	.LONG   DOLL3		;3 FOR A DOLLAR
	.LONG   0

SFRANC_7     .LONG   SFRANC11
	.LONG	SFRANC75
	.LONG	0

SFRANC_8     .LONG   SFRANC11
	.LONG	SFRANC85
	.LONG	0
*
*	2 PLAYS 5F / 5 PLAYS 10F
*
FIVE_10	.LONG	F25
	.LONG	F510
	.LONG	0

FIVE_10_11
	.LONG	F25
	.LONG	F510
	.LONG	F1120
	.LONG	0

FOUR_10	.LONG	F25
	.LONG	F410
	.LONG	0

FOUR_10_9
	.LONG	F25
	.LONG	F410
	.LONG	F4109
	.LONG	0

THREE_10 .LONG	F15
	.LONG	F310
	.LONG	0

THREE_10_7
	.LONG	F15
	.LONG	F310
	.LONG	F4107
	.LONG	0

TWO_10	.LONG	F15
	.LONG	F210
	.LONG	0

TWO_10_5 .LONG	F15
	.LONG	F210
	.LONG	F4105
	.LONG	0

F1325	.LONG	F3X1F
	.LONG	F2F5
	.LONG	0

F13255	.LONG	F3X1F
	.LONG	F2F5
	.LONG	F52X5
;	.LONG	F5X10F
	.LONG	0

F1235	.LONG	F2X1F
	.LONG	F3F5
	.LONG	0

F12355	.LONG	F2X1F
	.LONG	F3F5
	.LONG	F72X5
	.LONG	0

	.IF	FULLPRICE

*	500 LIRE

P1500L	.LONG	P1500L_P
	.LONG	0

*	1 PLAY / 20 P	 3 PLAYS 50 P

UK_CL1	.LONG	UK_120
	.LONG	UK_350
	.LONG	0

UK_CL2	.LONG	UK_220
	.LONG	UK_550
	.LONG	0

UK_CL1E	.LONG	UK_120
	.LONG	UK_350
	.LONG	UK_7P
	.LONG	0

UK_CL2E	.LONG	UK_130
	.LONG	UK_250
	.LONG	UK_4P
	.LONG	0

UK_CL3E	.LONG	UK_130
	.LONG	UK_250
	.LONG	UK_5P
	.LONG	0

UK_CL4E	.LONG	UK_150
	.LONG	UK_2P
	.LONG	0

UK_CL5E	.LONG	UK_150
	.LONG	UK_3P
	.LONG	0

UK_CL6E	.LONG	UK_3P
	.LONG	0

UK_CLCE	.LONG	UK_130
	.LONG	UK_250
	.LONG	UK_4P
	.LONG	0

SP_4100	.LONG	SP_11
	.LONG	SP_44
	.LONG	0

SP_5100	.LONG	SP_11
	.LONG	SP_54
	.LONG	0

AU_60	.LONG	AU_36
	.LONG	AU_2D
	.LONG	0

AU_100	.LONG	AU_520
	.LONG	AU_1D
	.LONG	0

	.ENDIF

JAP_100	.LONG	JAP_101
	.LONG	0

	.IF	FULLPRICE

JAP_200	.LONG	JAP_201
	.LONG	0

ASTA_10	.LONG	ASTA101
	.LONG	ASTA102
	.LONG	0

ASTA_15	.LONG	ASTA151
	.LONG	ASTA152
	.LONG	0

BEL_120	.LONG	BEL_1201
	.LONG	0
BEL_220	.LONG	BEL_2201
	.LONG	0
BEL_320	.LONG	BEL_3201
	.LONG	0
BEL_ELEC
	.LONG	BEL_1201
	.LONG	0

SWED_2X5 .LONG	SWED_S51
	.LONG	SWED_S52
	.LONG	0

NZ_12	.LONG	NZ_121
	.LONG	0

NZ_13	.LONG	NZ_131
	.LONG	0

NETH_HF	.LONG	HF_11
	.LONG	HF_32
	.LONG	0

FINMKA	.LONG	FIN_1
	.LONG	0

KR_LIST	.LONG	NOR_12
	.LONG	NOR_35
	.LONG	0

DKR_LIST .LONG	DEN_12
	.LONG	DEN_35
	.LONG	DEN_710
	.LONG	0

ANT_LIST .LONG	ANT1P25
	.LONG	ANT4DOL
	.LONG	0

HUNG_LIST
	.LONG	HUNG2X10
	.LONG	HUNG2X20
	.LONG	0

	.ENDIF

EC1	.STRING	"1 CREDIT / 25 CENTS",0
	.EVEN
C11	.STRING  "1 CREDIT / 1 COIN"
	.BYTE 0
	.EVEN
C21	.STRING  "1 CREDIT / 2 COINS"
	.BYTE 0
	.EVEN
C43	.STRING  "3 CREDIT / 4 COINS"
	.BYTE 0
	.EVEN
C44	.STRING  "4 CREDITS / 4 COINS"
	.BYTE 0
	.EVEN
C15
	.STRING	"1 CREDIT / 2 X 25 CENTS",0
	.EVEN

DOLL2	.STRING  "2 CREDITS / $1.00"
	.BYTE 0
	.EVEN

DOLL3	.STRING  "3 CREDITS / $1.00"
	.BYTE 0
	.EVEN

DOLL4	.STRING  "4 CREDITS / $1.00"
	.BYTE 0
	.EVEN

DM11	.STRING  "1 CREDIT / 1 DM",0
	.EVEN
DM22	.STRING  "2 CREDITS / 2 DM",0
	.EVEN
DM55	.STRING  "5 CREDITS / 5 DM",0
	.EVEN
DM65	.STRING  "6 CREDITS / 5 DM",0
	.EVEN
DM75	.STRING  "7 CREDITS / 5 DM",0
	.EVEN
DM85	.STRING  "8 CREDITS / 5 DM",0
	.EVEN

F3F5	.STRING  "3 CREDITS / 5F"
	.BYTE 0
	.EVEN
F2F5
F25	.STRING  "2 CREDITS / 5F"
	.BYTE 0
	.EVEN
F15	.STRING  "1 CREDIT / 5F"
	.BYTE 0
	.EVEN
F510	.STRING  "5 CREDITS / 10F"
	.BYTE 0
	.EVEN
F1120	.STRING  "11 CREDITS / 2 X 10F"
	.BYTE 0
	.EVEN
F4109	.STRING  "9 CREDITS / 2 X 10F"
	.BYTE 0
	.EVEN
F4107	.STRING  "7 CREDITS / 2 X 10F"
	.BYTE 0
	.EVEN
F4105	.STRING  "5 CREDITS / 2 X 10F"
	.BYTE 0
	.EVEN
F410	.STRING  "4 CREDITS / 10F"
	.BYTE 0
	.EVEN
F310	.STRING  "3 CREDITS / 10F"
	.BYTE 0
	.EVEN
F210	.STRING  "2 CREDITS / 10F"
	.BYTE 0
	.EVEN

F3X1F	.STRING  "1 CREDIT / 3 X 1F"
	.BYTE	0
	.EVEN

F2X1F	.STRING  "1 CREDIT / 2 X 1F"
	.BYTE	0
	.EVEN

F52X5	.STRING  "5 CREDITS / 2 X 5F"
	.BYTE	0
	.EVEN

F5X10F	.STRING  "5 CREDITS / 10F"
	.BYTE	0
	.EVEN

F72X5	.STRING  "7 CREDITS / 2 X 5F"
	.BYTE	0
	.EVEN

SFRANC11     .STRING  "1 CREDIT / 1F"
	.BYTE 0
	.EVEN
SFRANC65     .STRING  "6 CREDITS / 5F"
	.BYTE 0
	.EVEN
SFRANC75     .STRING  "7 CREDITS / 5F"
	.BYTE 0
	.EVEN
SFRANC85     .STRING  "8 CREDITS / 5F"
	.BYTE 0
	.EVEN

	.IF	FULLPRICE
P1500L_P .STRING      "1 CREDIT / 500 LIRE"
	.BYTE 0
	.EVEN

UK_120	.STRING	"1 CREDIT / 20 P"
	.BYTE 0
	.EVEN
UK_220	.STRING	"2 CREDIT / 20 P"
	.BYTE 0
	.EVEN
UK_130	.STRING	"1 CREDIT / 30 P"
	.BYTE 0
	.EVEN
UK_150	.STRING	"1 CREDITS / 50 P"
	.BYTE 0
	.EVEN
UK_250	.STRING	"2 CREDITS / 50 P"
	.BYTE 0
	.EVEN
UK_350	.STRING	"3 CREDITS / 50 P"
	.BYTE 0
	.EVEN
UK_550	.STRING	"5 CREDITS / 50 P"
	.BYTE 0
	.EVEN
UK_2P	.STRING	"2 CREDITS / L1.00"
	.BYTE 0
	.EVEN
UK_3P	.STRING	"3 CREDITS / L1.00"
	.BYTE 0
	.EVEN
UK_4P	.STRING	"4 CREDITS / L1.00"
	.BYTE 0
	.EVEN
UK_5P	.STRING	"5 CREDITS / L1.00"
	.BYTE 0
	.EVEN
UK_7P	.STRING	"7 CREDITS / L1.00"
	.BYTE 0
	.EVEN

SP_11	.STRING	"1 CREDIT / 100 PESETA"
	.BYTE	0
	.EVEN

SP_44	.STRING	"5 CREDITS / 500 PESETA"
	.BYTE	0
	.EVEN

SP_54	.STRING	"6 CREDITS / 500 PESETA"
	.BYTE	0
	.EVEN
NZ_131
AU_36	.STRING	"1 CREDIT / 3 X 20 CENTS"
	.BYTE	0
	.EVEN
AU_2D	.STRING	"2 CREDITS / $ 1.00"
	.BYTE	0
	.EVEN
AU_520	.STRING	"1 CREDIT / 5 X 20 CENTS"
	.BYTE	0
	.EVEN
AU_1D	.STRING	"1 CREDIT / $ 1.00"
	.BYTE	0
	.EVEN
	.ENDIF

JAP_101	.STRING	"1 CREDIT / 100 YEN"
	.BYTE	0
	.EVEN

	.IF FULLPRICE

JAP_201	.STRING	"2 CREDITS / 100 YEN"
	.BYTE	0
	.EVEN
ASTA101	.STRING	"1 CREDIT / 2 X 5 SCHILLING"
	.BYTE	0
	.EVEN
ASTA102	.STRING	"3 CREDITS / 2 X 10 SCHILLING"
	.BYTE	0
	.EVEN
ASTA151	.STRING	"1 CREDIT / 5 SCHILLING"
	.BYTE	0
	.EVEN
ASTA152	.STRING	"2 CREDITS / 10 SCHILLING"
	.BYTE	0
	.EVEN

BEL_1201 .STRING	"1 CREDIT / 2OF"
	.BYTE	0
	.EVEN
BEL_2201 .STRING	"2 CREDITS / 2OF"
	.BYTE	0
	.EVEN
BEL_3201 .STRING	"3 CREDITS / 2OF"
	.BYTE	0
	.EVEN

SWED_S51 .STRING	"1 CREDIT / 3 X 1 KRONA"
	.BYTE	0
	.EVEN
SWED_S52 .STRING	"2 CREDITS / 5 KRONA"
	.BYTE	0
	.EVEN

NZ_121	.STRING	"1 CREDIT / 2 X 20 CENTS"
	.BYTE	0
	.EVEN

HF_11	.STRING	"1 CREDIT / 1 HFI"
	.BYTE	0
	.EVEN

HF_32	.STRING	"3 CREDITS / 2.5 HFI"
	.BYTE	0
	.EVEN

FIN_1	.STRING	"1 CREDIT / 1 MARKKA"
	.BYTE	0
	.EVEN

DEN_12
NOR_12	.STRING	"1 CREDIT / 2 X 1 KRONE"
	.BYTE 0
	.EVEN

NOR_35	.STRING	"3 CREDITS / 5 X 1 KRONE"
	.BYTE 0
	.EVEN

DEN_35	.STRING	"3 CREDITS / 5 KRONE"
	.BYTE 0
	.EVEN

DEN_710	.STRING	"7 CREDITS / 2 X 5 KRONE"
	.BYTE 0
	.EVEN

ANT1P25	.STRING	"1 CREDIT / 25 CENTS"
	.BYTE 0
	.EVEN

ANT4DOL	.STRING	"4 CREDITS / 1 GUILDER"
	.BYTE 0
	.EVEN

HUNG2X10
	.STRING	"1 CREDIT / 2 X 10 FORINT",0
	.EVEN

HUNG2X20
	.STRING	"3 CREDITS / 2 X 20 FORINT",0
	.EVEN

	.ENDIF

**************************************************************************
*									*
*	 COIN SLOT TITLES						*
*									*
**************************************************************************

USA_ESLOT	
	.STRING	"$1.00  .10    .25     .5    $1.00",0
;;	.STRING	"1 DOLLAR  10/25/5 CENT",0
	.EVEN

FRANCE_ESLOT
	.STRING	"1F   5F   10F   20F",0
;;	.STRING	"1/10/5 FRANCS",0
	.EVEN

GERMAN_ESLOT
	.STRING	"5DM    2DM    1DM",0
;;	.STRING	"5/1/2 DM",0
	.EVEN

BELGIUM_ESLOT
	.STRING	"50/5/20 FR",0
	.STRING	"50F    20F    5F",0
;;	.EVEN

USA_QQ	    .STRING   "25 CENT       25 CENT"
	    .BYTE 0
	    .EVEN

	.IF	FULLPRICE
USA_QDQ
	.STRING   ".25    .25       $1.00",0
;;	.STRING   "25 CENT     $1.00     25 CENT",0
	.EVEN
	.ENDIF

GERMAN_15    .STRING   "1 DM      5 DM"
	    .BYTE 0
	    .EVEN
FRENCH510    .STRING   "5 F       10 F"
	    .BYTE 0
	    .EVEN
FRENCH1F5F
	.STRING   "1 F       5 F",0
	.EVEN

CAN_QD
	.STRING	".25  $1.00     $1.00",0
;;	.STRING	"25 CENT       $ 1.00",0
	.EVEN

	.IF	FULLPRICE
SWISS15
	.STRING   "1 F       5 F"
	    .BYTE 0
	    .EVEN
ITALYLIRE    .STRING   "500L 500L"
	    .BYTE 0
	    .EVEN

UK2050	    .STRING   "20P    50P"
	    .BYTE 0
	    .EVEN
UK_ELEC	    .STRING   "L1.00  20P  50P  10P"
	    .BYTE 0
	    .EVEN
UK_CCU	    .STRING   "CCU ON LEFT SLOT "
	    .BYTE 0
	    .EVEN

PESETA100
	.STRING   "100 P  500 P",0
;;	.STRING   "100 PESETA     500 PESETA",0
	.EVEN
AUST20C
	.STRING   ".20   $ 1.00",0
;;	.STRING   "20 CENT       $ 1.00",0
	.EVEN

	.ENDIF

YEN100	    .STRING   "100Y 100Y"
	    .BYTE 0
	    .EVEN

	.IF	FULLPRICE
SHILL510     .STRING   "5       10 SCHILLING"
	    .BYTE 0
	    .EVEN
FRANC20	    .STRING   "20F   20F"
	    .BYTE 0
	    .EVEN
KRONA5	    .STRING   "1 KR  5 KR"
	    .BYTE 0
	    .EVEN
NZ20	    .STRING   ".20     .20"
	    .BYTE 0
	    .EVEN
HFSLOT	    .STRING   "1HFI  2.5HFI"
	    .BYTE 0
	    .EVEN

MKSLOT	    .STRING   "1       1 MARKKA"             
	    .BYTE 0
	    .EVEN

NKRSLOT	    .STRING   "1 KR  1 KR"
	    .BYTE 0
	    .EVEN

DKRSLOT	    .STRING   "1 KR  5 KR"
	    .BYTE 0
	    .EVEN

ANTSLOT	    .STRING   ".25    1 GUILDER"
	    .BYTE 0
	    .EVEN

HUNGSLOT
	.STRING	"10     20 FORINT",0
	.EVEN

	.ENDIF

;;CP_CX	EQU	200
;;CP_11	EQU	11
;;CP_13	EQU	13
;;CP_23	EQU	23
;;CP_33	EQU	33




;TXT_2_TO_START
;	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_11,ROBO_YELLOW,STRCNRM,0
;	.byte	"2 CREDITS TO START",0,1
;	.even
;	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_23,ROBO_YELLOW,STRCNRM,0
;	.byte	"1 CREDIT TO CONTINUE",0,0
;	.even

;TWO_PER_PLAYER
;	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_11,ROBO_YELLOW,STRCNRM,0
;	.STRING   "2 COINS PER PLAYER"
;	.BYTE	  0,0
;	.EVEN

OCOP	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_11,ROBO_YELLOW,STRCNRM,0
	.STRING   "1 COIN / 1 PLAY"
	.BYTE	  0,0
	.EVEN

USA_ELECTRONIC:
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_YELLOW,STRCNRM,0
	.STRING	"1 CREDIT  /  25 CENTS"	
	.STRING	"\n4 CREDITS /  1 DOLLAR",0,1
	.EVEN

FRANCE_ELECTRONIC:
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_YELLOW,STRCNRM,0
	.STRING	"1 CREDIT  /  25 CENTS"	
	.STRING	"\n4 CREDITS /  1 DOLLAR",0,1
	.EVEN

GERMAN_ELECTRONIC:
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_YELLOW,STRCNRM,0
	.STRING	"1 CREDIT  /  1 DM"	
	.STRING	"\n6 CREDITS /  5 DM",0,1
	.EVEN

	.IF	FULLPRICE
BELGIUM_ELECTRONIC:
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_YELLOW,STRCNRM,0
	.STRING	"1 CREDIT  /  20 FR"	
	.EVEN

UK_MECH1
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_LF,STRCNRM,0
	.STRING   "1 CREDIT / 20 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,ROBO_LF,STRCNRM,0
	.STRING   "3 CREDITS / 50 P"
	.BYTE	  0,0
	.EVEN
UK_MECH2
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_LF,STRCNRM,0
	.STRING   "2 CREDIT / 20 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,ROBO_LF,STRCNRM,0
	.STRING   "5 CREDITS / 50 P"
	.BYTE	  0,0
	.EVEN
UK_ECA1
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_LF,STRCNRM,0
	.STRING   "1 CREDIT / 20 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_23,ROBO_LF,STRCNRM,0
	.STRING   "3 CREDITS / 50 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,ROBO_LF,STRCNRM,0
	.STRING   "7 CREDITS / "
	.BYTE	  FONT_EPOUND
	.STRING   "1.00"
	.BYTE	  0,0
	.EVEN
UK_ECA2
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_LF,STRCNRM,0
	.STRING   "1 CREDIT / 30 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_23,ROBO_LF,STRCNRM,0
	.STRING   "2 CREDITS / 50 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,ROBO_LF,STRCNRM,0
	.STRING   "4 CREDITS / "
	.BYTE	  FONT_EPOUND
	.STRING   "1.00"
	.BYTE	  0,0
	.EVEN
UK_ECA3
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_LF,STRCNRM,0
	.STRING   "1 CREDIT / 30 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_23,ROBO_LF,STRCNRM,0
	.STRING   "2 CREDITS / 50 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,ROBO_LF,STRCNRM,0
	.STRING   "5 CREDITS / "
	.BYTE	  FONT_EPOUND
	.STRING   "1.00"
	.BYTE	  0,0
	.EVEN
UK_ECA4
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_LF,STRCNRM,0
	.STRING   "1 CREDIT / 50 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,ROBO_LF,STRCNRM,0
	.STRING   "2 CREDITS / "
	.BYTE	  FONT_EPOUND
	.STRING   "1.00"
	.BYTE	  0,0
	.EVEN
UK_ECA5
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_LF,STRCNRM,0
	.STRING   "1 CREDIT / 50 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,ROBO_LF,STRCNRM,0
	.STRING   "3 CREDITS / "
	.BYTE	  FONT_EPOUND
	.STRING   "1.00"
	.BYTE	  0,0
	.EVEN
UK_ECA6
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_23,ROBO_LF,STRCNRM,0
	.STRING   "3 CREDITS / "
	.BYTE	  FONT_EPOUND
	.STRING   "1.00"
	.BYTE	  0,0
	.EVEN
UK_ECAC
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_13,ROBO_LF,STRCNRM,0
	.STRING   "1 CREDIT / 30 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_23,ROBO_LF,STRCNRM,0
	.STRING   "2 CREDITS / 50 P"
	.BYTE	  0,1
	.EVEN
	MESS_MAC  RD7FONT,SPACING07,CP_CX,CP_33,ROBO_LF,STRCNRM,0
	.STRING   "4 CREDITS / "
	.BYTE	  FONT_EPOUND
	.STRING   "1.00"
	.BYTE	  0,0
	.EVEN
	.ENDIF


*
*	THE FOLLOWING 2 MESSAGES ARE GENERIC AND WILL
*	BE DISPLAYED IF THE MODE MATCHES AND NO
*	APPROPRIATE MESSAGE EXISTS
*
*	THIS IS FOR THIS BEING THE ONLY MESSAGE DISPLAYED ON
*	THE SCREEN
*
TWO_TO_START
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_12,ROBO_LASER,STRCNRM,0
	.byte	"2 CREDITS TO START",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0
	.byte	"1 CREDIT TO CONTINUE",0,0
	.even

TWO_TO_START_2C
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_12,ROBO_LASER,STRCNRM,0
	.byte	"2 CREDITS TO START",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0
	.byte	"2 CREDITS TO CONTINUE",0,0
	.even
*
*	 THIS IS FOR LINES TWO AND 3 WITH AN ADDITIONAL LINE ABOVE
*

TWO_TS	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_23,ROBO_LASER,STRCNRM,0
	.byte   "2 CREDITS TO START",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_33,ROBO_LASER,STRCNRM,0
	.byte   "1 CREDIT TO CONTINUE",0,0
	.even

TWO_TP	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0
	.byte   "2 CREDITS PER PLAYER",0,0
	.even

TWO_CRED_PER_PLAYER
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LASER,STRCNRM,0
	.byte   "2 CREDITS PER PLAYER",0,0
	.even

MAX_C_M MESS_MAC RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LF,STRCNRM,0
	.byte   "MAXIMUM CREDITS!",0,0
	.even

******************************************************************************

	.end
