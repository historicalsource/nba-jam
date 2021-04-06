**************************************************************
*
* Owner:	none
*
* Software:	?
* Initiated:	?
*
* Modified:	Shawn Liptak, 11/14/91	-Total carnage cleanup
* 		Shawn Liptak, 2/20/92	-Basketball
* 		GEORGE PETRO, 1/17/93	-NBA JAM
* 		Jeff Johnson, 4/11/95	-NBA JAM 3
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/19/93 13:58
*.Last mod - 4/11/95 12:13pm
**************************************************************
	.file	"test.asm"
	.title	"test program"
	.width	132
	.option	b,d,l,t
	.mnolist

	
	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"imgtbl.glo"
	.include	"game.equ"
	.include	"link.equ"
	.include	"menu.equ"
	.include	"macros.hdr"		;Macros
	.include	"dipsw.equ"


;in this module

	.def		fudge_switches, fudge_switches2, fudge_switches_diag
	.DEF		DIAG,CHK_CMOS
	.DEF		GEN_MENU,B_MENU
	.DEF		TOP_BOX			;,WT_ADV
;	.DEF		WW_ADV
	.DEF		MAIN_RET,GMENULEV
;	.DEF		CK_DOOR
	.DEF		AREUSURE
	.DEF		F_TITLE
	.DEF		ST_STICK
	.DEF		GETSTICK
	.DEF		SUR_MESS
	.DEF		SURE_BOX
	.DEF		CPU_RET
	.DEF		GET_FAC
	.DEF		MENU_TOP
	.DEF		RED_BOX
	.DEF		BLNKHELP,H_SLAVE
	.DEF		DOBORDER
	.DEF		COL_INST
	.DEF		STD_BORD
	.DEF		DIAG_EX
	.DEF		WAIT_BUT
	.DEF		DIGSRT
;	.DEF		GET_ADV
	.DEF		SND_MADE
	.DEF		NO_CLEAR
	.DEF		LAST_BUT
	.DEF		G_BORDER
	.DEF		FORM_SWS
;	.DEF		LINKY
	.DEF		CKTEST, CKDIAG, DIAG_COLORS

;in audit.asm

	.REF		CMOS_VAL,L_MESS
	.REF		LM_SETUP,LM_FINIS
	.REF		FORM_ADC
	.REF		F_ADC_S
	.REF		GET_AUD
	.REF		FAC_SET
	.REF		CRED_P
	.REF		BAD_AUD
	.REF		CLR_AUD
	.REF		ADJ_PAGE
	.REF		COIN_PAG
	.REF		ROM_NAME
	.REF		STORE_AUDIT
	.ref		inga16_asc_tbl
*
*	IN HSTD.ASM
*
	.REF		INIT_TAB
	.REF		VAL_TAB
	.REF		P_FORK
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
*
*	 IN MENU.ASM
*
	.REF		MEN_MAIN,ANY_BUT,MEN_YN
	.REF		MESS_FAC
	.REF		GO_DIAG 	  ;ROUTINE FOR DIAGNOSTIC MENU
	.REF		RTR_LEV,ROM_LEV
	.REF		FAC_STUF
	.REF		SCODE		  ;SYNTH CODE CURRENTLY BEING MADE
	.REF		DCODE		  ;DIG CODE CURRENTLY BEING MADE

;	IN ADJUST.ASM

	.REF	DO_ADJH, CKDIP, MEN_ADJ


;	IN ATTRACT.ASM

	.REF	WIPEOUT


;	OTHERS

	.ref	TWOPLAYERS			;0 = NO, 1 = YES 2 players

	.REF	WARMSET
	.REF	QSNDRST,qsndrst_proc
	.REF	FILLAREA
	.REF	STRNGLEN

	.ref	brush20_ascii
	.REF	RD15FONT,RD7FONT,STRCNRM,STRCNRM_1,GAMSTATE
	.REF	IRQSKYE,BLNKAREA,STRLNRM,CLR_SCRN
	.REF	P1DATA,P2DATA
	.REF	WDOGDIS, READ_DIP, dpageflip_off, SWSET1, SWSET2

	.REF	PALFRAM, pal_set, pal_getf, DIAGP

	.ref	_coin_addr
	.ref	_switch_addr
	.ref	_switch2_addr


*	 MAIN_RET
*
*	 POSITIVE NUMBER HERE SAYS RETURN (UPWARD) TO MAIN MENU (GEN_MENU ONLY)
*	 NEGATIVE NUMBER HERE SAYS SETUP RESTORE AFTER RAM TEST. (GEN_MENU)

	.BSS		MAIN_RET,16	      ;FLAG SAYS RETURN TO MAIN MENU
	.BSS		GMENULEV,16	      ;HOW DEEP INTO GEN_MENU WE ARE
	.BSS		SND_MADE,16	      ;SOUND TEST FLAG
	.BSS		NO_CLEAR,16	      ;FLAG TELLS GET_MENU NOT TO CLEAR!
	.BSS		LAST_BUT,32
	.BSS		SPTEMP,32	      ;STACK POINTER TEMP

	.def	fswitches_cur,fswitches_last,fswitches_down

	.bss		fswitches_cur,32
	.bss		fswitches_last,32
	.bss		fswitches_down,32

	BSSX		_switch_map_mode,32	; 0 = no switch mapping
						; 1 = map switches for menus
						; 2 = map switches for adjustments
						; 3 = Any button mapping mode

	.text

;sounds

;beep1_snd	.word	>f3f7,>8,>8080,0	;MENU BAR MOVE SOUND
;SELECT_SND	.word	>f3f7,>8,>8084,0	;MENU OPTION SELECT SOUND
;UHOH		.WORD	0F3DFH,010H,08092H,0	;FAILURE OF ANY KIND


**************************************************************************
*									 *
*	   CPU_RET							 *
*									 *
*	   THIS IS RETURN FROM CPU TEST.   SINCE WE NEED TO TEST	 *
*	   RAM BEFORE ROM, OUR STATE IS ALSO SMASHED FROM ROM TEST.	 *
*									 *
**************************************************************************
CPU_RET:
;	CALLR	DIAG_STATE	;GET THE STATE RIGHT.....BUT DON'T MESS UP TILL BUTTON
;	JSRP	WAIT_BUT	;NOW WAIT FOR ANY BUTTON.
	CALLR	DIGSRT		;MAKE SURE WE'RE IN TEST MODE

	CLR	A0
	MOVE	A0,@GMENULEV	;INDICATE WE'RE AT LEVEL ZERO.

	MOVI	RTR_LEV,A0	;THIS IS THE LEVEL TO DIVE TO
	NEG	A0		;NEGATE IT AS FLAG TO DIVE.
	MOVE	A0,@MAIN_RET	;INDICATE
	JAUC	DIAG_RESTART	;NOW START IT UP....



**************************************************************************
*									 *
*	   WAIT_BUT							 *
*									 *
*	   THIS IS CALLED ON RETURN FROM MANY OF THE "HARD"		 *
*	   DIAGNOSTIC TESTS TO HOLD CONTROL TILL ANY BUTTON IS		 *
*	   HIT. 							 *
*									 *
**************************************************************************
WAIT_BUT:
	CALLR	FORM_SWS	;1ST STATE DOESN'T COUNT

*	RETURN CURRENT STATE IN A0..PREVIOUS STATE IN A1.

WB1:	
	SLEEPK	1
	CALLR	FORM_SWS
	NOT	A1		;LAST = 0 AND NOW = 1 MEANS EDGE!

	AND	A1,A0		;1'S WHERE WE HAVE POSITIVE EDGE.
	ANDI	BUTTONS,A0	;IS IT A BUTTON?
	JRZ	WB1

	.ref	diag_select
	SOUND1	diag_select
;	movi	beep1_snd,a3
;	calla	SNDSND
	RETP


**************************************************************************
*								         *
* 	CKTEST								 *
* 									 *
* 	CHECK TO SEE IF EITHER OF THE TEST BUTTONS IS CLOSED,		 *
* 	IF NOT, HEAD OUT TO WARMSET					 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************
CKTEST
;	rets
	PUSH	A0
	CALLA	READ_DIP
	ANDI	DPTEST,A0
	JRNZ	CKRET

;	MOVE	@SWITCH,A0,L
	move	@_coin_addr,a0,L
	move	*a0,a0,W
	sll	16,a0
	NOT	A0
	ANDI	DIAG_BITS,A0
	JAZ	WARMSET			; WE BE OUTTA HERE!
CKRET
	PULL	A0
	RETS


**************************************************************************
*								         *
* 	CKDIAG								 *
* 									 *
* 	CHECK TO SEE IF WE NEED TO GO OFF TO THE DIAGNOSTICS ROUTINES	 *
* 									 *
* 	ENTRY								 *
* 		NOTHING							 *
* 									 *
* 	EXIT								 *
* 		A0	0 = COOL, 1 = GO TO DIAGS			 *
*								         *
**************************************************************************
CKDIAG
	CLR	A0
	CALLA	READ_DIP
	ANDI	DPTEST,A0
	JRNZ	CKDGO
;	MOVE	@SWITCH,A0,L
	move	@_coin_addr,a0,L
	move	*a0,a0,W
	sll	16,a0
	NOT	A0
	ANDI	DIAG_BITS,A0
	JRZ	CKDRET
CKDGO
	MOVK	1,A0
CKDRET
	MOVE	A0,A0
	RETS

**************************************************************************
* DIAG - THIS IS THE ENTRY TO THE MAIN DIAGNOSTIC MENU.

DIAG
	movi	AUDSTAT,a0
	clr	a1
	calla	STORE_AUDIT
	move	@GAMSTATE,a0
	jan	SUCIDE		;In diagnostics

;	move	@COINS,a0	;Check coin switches
	move	@_coin_addr,a0,L
	move	*a0,a0
	btst	CDI_BIT,a0		;Coin door closed ?
	jaz	SUCIDE		;Yes - then diagnostic NOT allowed
	movk	1,a0
	move	a0,@_switch_map_mode,L

DIAG_JUMP
	CALLR	DIGSRT		;MAKE SURE WE'RE IN TEST MODE
;	JSRP	WW_ADV		;HOLD UNTIL HE LETS GO!

	CLR	A0
	MOVE	A0,@MAIN_RET	;CLEAR THE FLOAT TO TOP FLAG.
	MOVE	A0,@GMENULEV	;INDICATE WE'RE AT LEVEL ZERO.

DIAG_RESTART
	MOVI	MEN_MAIN,A8
	JSRP	GEN_MENU	;PROCESS THIS MENU!
	clr	a0
	move	a0,@_switch_map_mode,L

;	HE (FINALLY) PICKED EXIT....RETURN!

DIAG_EX
	SLEEPK	2		;LET DMA EMPTY OUT IF NECESSARY

;	CALLA	CMOS_VAL	;IF SETTINGS SMASHED....FIX EM.
;	JAUC	WARMSET




;	SLEEP	2
	CALLA	CLR_SCRN
	CALLA	CMOS_VAL		; VALIDATE THE CMOS
	CALLA	CKTEST
	CALLA	READ_DIP
	ANDI	DPTEST,A0
	MOVE	A0,@SWSET2,L
	JRZ	DE2
	MOVI	NOTCLOSEDDIP,A8
	JSRP	L_MESS
	jruc	#out
DE2
;	MOVE	@SWITCH,A0,L
	move	@_coin_addr,a0,L
	move	*a0,a0,W
	sll	16,a0
	NOT	A0
	ANDI	DIAG_BITS,A0
	MOVE	@SWSET2,A14,L
	OR	A0,A14
	MOVE	A14,@SWSET2,L
	MOVE	A0,A0
	JRZ	DE3
	MOVI	NOTCLOSEDJAMMA,A8
	JSRP	L_MESS
	jruc	#out
DE3
	JAUC	WARMSET		
#out
	MOVI	NOTCLOSEDWAIT,A8
	JSRP	L_MESS

	CALLA	fudge_switches		;get fudged switches in a0
	andi	BUTTONS|START_BITS,a0
	MOVE	A0,@SWSET1,L
DE4
	SLEEPK	1			;APPEASE THE MAIN LOOP
	CALLR	CKTEST			;CHECK STATUS OF TEST SWITCH

	CALLA	fudge_switches		;get fudged switches in a0
	MOVE	@SWSET1,A1,L
	andi	BUTTONS|START_BITS,a0
	CMP	A0,A1
	JRNZ	DE5


	MOVE	@SWSET2,A3,L
	MOVE	A3,A1
	CALLA	READ_DIP
	ANDI	DPTEST,A0
	ANDI	DPTEST,A1
	CMP	A0,A1
	JRNE	DIAG_EX

;	MOVE	@SWITCH,A0,L		;GOTTA SEE IF TIME TO LEAVE
	move	@_coin_addr,a0,L
	move	*a0,a0,W
	sll	16,a0
	NOT	A0
	ANDI	DIAG_BITS,A0
	ANDI	DIAG_BITS,A3
	CMP	A0,A3
	JRNE	DIAG_EX

	JRUC	DE4

DE5
	CALLR	CKTEST			; ONE FINAL TIME ( STILL WRONG )
	JRUC	DIAG_JUMP


NOTCLOSEDDIP
	MESS_MAC RD7FONT,SPACING07,200,50,COLOR_RED,STRCNRM,0
	.STRING	"DIPSWITCH TEST SELECT (UJ2 # 8) CLOSED.",0,0
	.EVEN

NOTCLOSEDJAMMA
	MESS_MAC RD7FONT,SPACING07,200,70,COLOR_RED,STRCNRM,0
	.STRING	"COIN DOOR TEST SWITCH CLOSED.",0,0
	.EVEN

NOTCLOSEDWAIT
	MESS_MAC RD7FONT,SPACING07,200,120,COLOR_RED,STRCNRM,0
	.STRING	"PRESS ANY BUTTON TO RETURN TO TEST MODE OR",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,132,COLOR_RED,STRCNRM,0
	.STRING	"OR",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING07,200,144,COLOR_RED,STRCNRM,0
	.STRING	"OPEN THE SWITCH(S) TO RETURN TO GAME.",0,0
	.EVEN

**************************************************************************
*									 *
*	   GEN_MENU							 *
*									 *
*	   THIS IS A GENERAL MENU HANDLER.  IT POSTS THE MENU		 *
*	   WITH SELECTION 1 AVAILABLE.	AFTER A SELECTION IS		 *
*	   MADE, IF IT HAS A ROUTINE CODE OF ZERO, (EXIT)		 *
*	   IT RETURNS TO THE LEVEL ABOVE IT.  ELSE, IT			 *
*	   JSRP'S THE NEW ROUTINE.  WHEN THE NEW ROUTINE                 *
*	   RETURNS, WE RE-POST THE SAME MENU WITH THE			 *
*	   BAR ON THE FOLLOWING ENTRY.					 *
*									 *
*	   A8 = MENU DESCRIPTOR 					 *
*									 *
**************************************************************************
*
*	 MENU ROM OFFSETS
*
MR_FONT   EQU	  0
MR_TCAL   EQU	  MR_FONT+LONG_SIZE
MR_TITLE  EQU	  MR_TCAL+LONG_SIZE	;POINTER TO TITLE FOR TILE BOX (IF NEC)
MR_TCLR   EQU	  MR_TITLE+LONG_SIZE	;COLOR OF TITLE
MR_WORDS  EQU	  MR_TCLR+WORD_SIZE	;STREAM OF WORDS TO COPY TO PDATA STARTS HERE
MR_X	  EQU	  MR_WORDS
MR_Y	  EQU	  MR_X+WORD_SIZE
MR_DY	  EQU	  MR_Y+WORD_SIZE
MR_COL	  EQU	  MR_DY+WORD_SIZE
MR_HITE   EQU	  MR_COL+WORD_SIZE
MR_BDY	  EQU	  MR_HITE+WORD_SIZE
MR_DX	  EQU	  MR_BDY+WORD_SIZE
MR_WID	  EQU	  MR_DX+WORD_SIZE
	
GEN_MENU
	MOVE	@GMENULEV,A0		;KICK LEVEL POINTER
	INC	A0
	MOVE	A0,@GMENULEV

	MOVE	A8,-*A12,L		;SAVE MENU PTR
	movk	1,A8			;START WITH "FIRST" ENTRY
	MOVE	A8,-*A12,W		;PUT MENU NUMBER AS A WORD

*	IF WE GET HERE AND MAIN_RET IS NOT ZERO, THE WE MUST
*	RETURN TO LEVEL ABOVE US IF WE'RE NOT THE MAIN
*	MENU.


GEN_LOOP
	MOVE	@MAIN_RET,A0		;ARE WE IN "EXIT" MODE?
	JRZ	NO_EXIT 		;NO

	JRN	DIVE_TO_MONITOR 	;WE'RE DIVING TO MONITOR PATTERNS.

	MOVE	@GMENULEV,A0		;CHECK LEVEL
	subk	1,a0			;are we at level 1
	jrne	GEN_EXIT		;NOPE.....POP UP A LEVEL.

*	WE'RE AT LEVEL 1....CLEAR OUT THE FLAG THAT
*	GOT US HERE.

DIVE_COMPLETE
	CLR	A0
	MOVE	A0,@MAIN_RET		;NOW WE MAY PROCEED!

NO_EXIT
	MOVE	@NO_CLEAR,A0		;INHIBIT CLEAR?
	JRNZ	SKIP_CLR
	CLR	B13
	CALLA	CLR_SCRN		;CLEAR THE SCREEN

SKIP_CLR
	CLR	A0
	MOVE	A0,@NO_CLEAR		;AND RE-SET IT!

	MOVE	*A12(WORD_SIZE),A8,L	;GET MENU DESCRIPTOR
	JSRP	MENU_TOP
	JSRP	RED_BOX		;PUT UP MAIN MENU INSTRUCTIONS

	MOVE	*A12,A9			;GET MENU NUMBER TO USE
	JSRP	B_MENU			;GET RESULT

PHONEY_MENU_RET

	MOVE	A10,A10 		;WAS IT ADVANCE?
	JRZ	NO_KICK 		;NOPE....LEAVE WHERE HE CAME FROM

	INC	A8			;KICK INDEX BY 1 FOR NEXT TIME
NO_KICK
	MOVE	A8,*A12			;AND LEAVE ON THE STACK

	MOVE	A9,A9			;NOW JSRP THE ROUTINE
	JRZ	GEN_EXIT		;NONE THERE....ITS "EXIT"

*	JSRP TO A9

	MOVI	GEN_LOOP,A7
	MOVE	A7,-*A12,L		;PUSH RET ADDR
	JUMP	A9

GEN_EXIT
	ADDI	WORD_SIZE+LONG_SIZE,A12 ;POP THE ARGUMENTS
	MOVE	@GMENULEV,A0		;KICK LEVEL POINTER
	DEC	A0
	MOVE	A0,@GMENULEV
	RETP

**************************************************************************
*									 *
*	   DIVE_TO_MONITOR						 *
*									 *
*	   WE GET CONTROL HERE WHEN WE ARE KLUDGING THE RETURN		 *
*	   FROM "CPU" TEST (WHICH BLOWS AWAY RAM!)			 *
*									 *
**************************************************************************
DIVE_TO_MONITOR:
	MOVE	@GMENULEV,A0		;CHECK LEVEL
	CMPI	1,A0			;ARE WE AT LEVEL 1
	JRNZ	DTM1			;NOPE....SET "MONITOR" LEVEL
*
*	WE'RE AT LEVEL 1......."SELECT" THE DIAGNOSTIC MENU
*	A8 = 1.....A9 = ROUTINE FOR DIAGNOSTIC MENU
*
	MOVK	1,A8
	MOVI	GO_DIAG,A9		;ROUTINE FOR DIAGNOSTIC MENU
	MOVK	1,A10			;RETURN AS IF ADVANCE WAS PRESSED
	JRUC	PHONEY_MENU_RET		;WE'RE READY TO CALL DIAG MENU
*
*	WE'RE IN DIAGNOSTIC MENU....NOW WE JUST NEED TO MAKE
*	THE "CURRENT" SELECTION THE ONE AFTER CPU TEST
*	(MONITOR PATTERNS)
*
DTM1:	
	MOVE	@MAIN_RET,A8		;FLAG IS OPPOSITE OF ENTRY NUMBER
	NEG	A8			;THIS IS RETURN LEVEL!
*	 MOVI	 RTR_LEV,A8		;START WITH "RETURN" ENTRY NUMBER
	MOVE	A8,*A12			;PUT MENU NUMBER AS A WORD
	JRUC	DIVE_COMPLETE		;THIS COMPLETES THE DIVE!

**************************************************************************
*
*	   FOR DOBORDER
*
*	   A4 = UPPER LEFT Y,X						
*	   A5 = LOWER RIGHT Y,X 				
*	   A0 = Y,X WIDTH OF BORDER					
*	   A9 = COLOR OF BORDER.					

**************************************************************************
*									 *
*	   TOP_BOX							 *
*									 *
*	   THIS DISPLAYS THE TEST BOX AT THE TOP.			 *
*									 *
*	   A2 POINTS AT THE STRING TO CENTER IN THE BOX.		 *
*	   A3 IS COLOR TO DO IT IN.					 *
*									 *
**************************************************************************
MENU_TOP:
	MOVE	*A8(MR_TITLE),A2,L	;GET TITLE INTO A2
	MOVE	*A8(MR_TCLR),A3		;AND COLOR INTO A3

TOP_BOX:
	MOVE	A8,-*A12,L		;PUSH MENU PTR
*
*	FIRST MAKE THE BOX...IT BLACKS OUT THE REGION
*
	CALLR	SCR_BOX 		;PUT UP THE TITLE BOX

	MOVI	MESS_TITLE,A8	 ;SET PARAMETERS
	CALLA	LM_SETUP	 ;PUT IT OUT.

	MOVE	A2,A8		 ;GET STRING IN THE CORRECT REGGIE
;	MOVE	A3,A6		 ;MOVE COLOR TO COLOR REGGIE

	JSRP	LM_FINIS	 ;AND PRINT IT!

	JSRP	SCR_REV 	 ;NOW ADD THE REV.

	MOVE	*A12+,A8,L	 ;RESTORE THE MENU PTR

	RETP

**************************************************************************
*									 *
*	   SCR_REV							 *
*									 *
*	   DISPLAY REV IN TITLE BOX.					 *
*									 *
**************************************************************************
SCR_REV:
	MOVI	MESS_REV,A8	;GET READY FOR REV MESSAGE
	CALLA	LM_SETUP	;SETUP FOR REV MESSAGE

	MOVI	ROM_NAME,A8	;USE ROM COPY OF REV.
	JSRP	LM_FINIS	;FINISH PRINTING MESSAGE
	RETP

**************************************************************************
*									 *
*	   SCR_BOX							 *
*									 *
*	   THIS DISPLAYS THE TITLE BOX. 				 *
*									 *
**************************************************************************
SCR_BOX:
	MOVI	TIT_ULX+(10000H*TIT_ULY),A4    ;UPPER LEFT
	MOVI	TIT_LRX+(10000H*TIT_LRY),A5    ;UPPER LEFT
	MOVI	COLOR_YELLOW,A9
	CALLR	STD_BORD
	RETS

*	 THIS PRINTS THE "MOVE JOYSTICK" BOX.
*
*	 A8 = MENU DESCRIPTOR THAT WILL ACCOMPANY IT
*	 ON SCREEN.  WE ADJUST THE BOX EDGES AND
*	 MESSAGE CENTER IN "X" ONLY TO CORRESPOND
*	 TO THE MENU BOX.

RED_BOX:
	MOVE	A8,-*A12,L			 ;PUSH THE MENU PTR

	MOVI	ROBO_RED,A9
	CALLR	COL_INST		;THIS PRINTS BOX AND STASHES
*					;CENTER X AT *A13(PDATA),W

	MOVI	MM_INST1,A8	;POINT AT INSTRUCTIONS MESSAGE
	JSRP	C_PD_M

	MOVI	MM_INST2,A8	;POINT AT INSTRUCTIONS MESSAGE
	JSRP	C_PD_M

	MOVE	*A12+,A8,L	;GET BACK MENU PTR.
	RETP

**************************************************************************
*									 *
*	   COL_INST							 *
*									 *
*	   THIS PRINTS OUT THE "CYAN" INSTRUCTION BOX			 *
*	   IN THE COLOR SPECIFIED BY A9.				 *
*									 *
**************************************************************************
COL_INST:
*
*	WE NEED TO DETERMINE LEFT AND RIGHT X
*
	CALLR	STUFF_MENU_PROCESS		 ;MOVE DATA INTO PDATA AREA
	CALLR	MEN_NUMS			 ;GET THE NUMBERS FOR THIS MENU
	MOVE	A6,*A13(PDATA),W		 ;STASH THE X CENTER
	ADDI	10000H*INST_ULY,A4		 ;UPPER LEFT Y
	ADDI	10000H*INST_LRY,A5		 ;UPPER LEFT X
	CALLR	STD_BORD
	RETS

**************************************************************************
*									 *
*	   MEN_NUMS							 *
*									 *
*	   THIS IS CALLED TO GET SOME NUMBERS ASSOCIATED		 *
*	   WITH A MENU BOX.						 *
*									 *
*	   THIS RETURNS:						 *
*									 *
*	   A4 = LEFT X							 *
*	   A5 = RIGHT X 						 *
*	   A6 = CENTER X						 *
*									 *
**************************************************************************
MEN_NUMS:
	CALLR	MENU_UL_A4_A5			 ;LEFT X IN A4
	CALLR	MENU_LR_A6_A5			 ;RIGHT X IN A6
	MOVE	A6,A5				 ;COPY RIGHT X INTO A5
	ADD	A4,A6				 ;FIND CENTER
	SRL	1,A6				 ;A6 NOW HAS CENTER X (FOR LATER)
	RETS

**************************************************************************
*									 *
*	   C_PD_M							 *
*									 *
*	   THIS PRINTS A L_MESS MESSAGE PASSED IN A8, CENTERED		 *
*	   ON THE X STORED AT *A13(PDATA),W				 *
*									 *
**************************************************************************
C_PD_M:
	CALLA	LM_SETUP	;SETUP THE MESSAGE
	MOVE	*A13(PDATA),A3	;GET THE X
	movx	a3,a9		;Move X
	JUMP	A1		;AND "CALL" THE ROUTINE

**************************************************************************
*									 *
*	   DIGSRT							 *
*									 *
*	   THIS IS CALLED ON ENTRY TO DIAGNOSTICS.			 *
*									 *
**************************************************************************

DIGSRT
	CALLR	DIAG_STATE
	CALLA	WIPEOUT 	;INITIALIZE THE OBJECT LIST
	CALLR	DIAG_COLORS	;RESTART THE COLOR PROCESSES.
	CREATE	QSNDRST_PID,qsndrst_proc	;Init sound board
;oops	JSRP	QSNDRST

	calla	dpageflip_off
	MOVK	1,A0
	MOVE	A0,@DISPLAYON	;WE NEED TO SEE THE STUFF

	movi	HEBLNKINIT,a0
	move	a0,@HEBLNK

	jauc	CLR_SCRN	;CLEAR THE SCREEN!

DIAG_STATE
	CLR	A1
	CALLA	KILALL			;KILL ABSOLUTELY EVERYONE!

	MOVI	DIAG_PID,A1		;SET OUR ID TO DIAGNOSTICS MAN
	MOVE	A1,*A13(PROCID)		;PASS OUR ID TO FORKED PROCESS

	movi	INDIAG,a0
	move	a0,@GAMSTATE		;PUT US IN TEST MODE!
	rets



NUM_DIAG_CYCLE_COLORS	.EQU	4
DIAG_CYCLE_COLOR_START	.EQU	03CH

	.BSS	DIAG_CRAM,NUM_DIAG_CYCLE_COLORS*16,1	;RAM FOR TRANSFER

**************************************************************************
*									    			*
* DIAG_COLORS - PROCESS THAT CYCLE COLORS FOR THE DIAGNOSTIC MENUS.	 	*
*									    			*
**************************************************************************
DIAG_COLORS
	MMTM	SP,A0,A1,A7
	MOVI	COLRPID,A0
	CLR	A1
	MOVE	A1,@IRQSKYE
	move	a1,@PALFRAM,L
	CALLA	KIL1C		 ;KILL ALL COLOR UPDATE PROCESSES
	MOVI	DIAGP,A0	 ;CREATE DIAGNOSTICS PALLETTE
	CALLA	pal_getf
	MOVI	COLRPID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL
	CREATE	COLRPID,PC_TRANSFER
	CREATE	COLRPID,LFLASH
	CREATE	COLRPID,RGB
	CREATE	COLRPID,BPR
	CREATE	COLRPID,DECAY
	MMFM	SP,A0,A1,A7
	RETS

**************************************************************************
*												*
* TABLE DRIVEN COLOR RAM PROCESSES					 *
*												*
**************************************************************************
*	18000B0(11)	-	BPR
*	18000C0(12)	-	DECAY
*	18000D0(13)	-	LASER FLASH
*	18000E0(14)	-	RGB

RGB	CALLR	TABDRIVE
	.LONG	RGBTAB,DIAG_CRAM+30H
	.WORD	8
RGBTAB	.WORD	07C00H,001FH,>77A0,>741A,0FFFFH

*
DECAY	CALLR	TABDRIVE
	.LONG	DCATAB,DIAG_CRAM+010H
	.WORD	2
DCATAB	.WORD	001CH,001CH,011CH,021CH,031CH,039CH,239CH,2390H,2388H
	.WORD	2380H,4300H,5280H,7180H,6180H,7080H,7000H,6000H,5000H
	.WORD	4000H,3000H,2000H,1000H,0FFFFH
*
BPR	CALLR	TABDRIVE
	.LONG	BPRTAB,DIAG_CRAM
	.WORD	1
BPRTAB	.WORD	001CH,101CH,201CH,301CH,401CH,501CH,601CH,701CH,7010H
	.WORD	7010H,7008H,7008H,7000H,7000H,7008H,7008H,7010H,7010H
	.WORD	701CH,701CH,601CH,501CH,401CH,301CH,201CH,101CH,0FFFFH

**************************************************************************
*									    *
* LFLASH - PROCESS TO CREATE THE FAMOUS LASER FLASH COLOR 		 *
*									    *
**************************************************************************
LFLASH	MOVI	07FFFH,A0
	MOVE	A0,@DIAG_CRAM+20H,W
	SLEEPK	2
LFLASH1
	MOVE	@RAND,A0,W
	ANDI	0000001FH,A0
	MOVI	COLTAB,A1
	SLL	4,A0
	ADD	A0,A1
	MOVE	*A1,A1,W
	MOVE	A1,@DIAG_CRAM+020H,W
	SLEEPK	6
	JRUC	LFLASH

COLTAB	.WORD	0380H,1380H,2380H,3380H,4380H,5380H,6380H,7380H,7300H
	.WORD	7280H,7200H,7180H,7080H,7008H,7008H,7010H,7010H,701CH
	.WORD	701CH,601CH,501CH,409CH,309CH,209CH,219CH,029CH,039CH
	.WORD	139CH,239CH,339CH,539CH,739CH,7390H,7380H,6380H,4380H
	.WORD	0FFFFH

**************************************************************************
*												*
* THE TABLE DRIVEN PROCESS						 *
*												*
**************************************************************************
TABDRIVE
	MOVE	*SP+,A0,L
	MOVE	*A0+,A11,L	;A11 = TABLE START
	MOVE	*A0+,A9,L	;A9 = LOCATION TO STUFF COLOR
	MOVE	*A0,A10,W	;A10 = SLEEP TIME
TABDRV1
	MOVE	A11,A8		;RESET TO START OF TABLE
TABDRV2
	MOVE	*A8+,A0,W	;GET A COLOR
	JRN	TABDRV1		;BR = END OF TABLE
	MOVE	A0,*A9,W
	MOVE	A10,A0
	MOVI	TABDRV2,A7
	JAUC	PRCLSP		;LOOP SLEEP

**************************************************************************
*									    *
* PC_TRANSFER - PROCESS TO TRANSFER CYCLE COLORS TO THE COLOR		 *
*		RAM EVERY TICK.						 *
*									    *
**************************************************************************
PC_TRANSFER
	MOVI	DIAG_CRAM,A0
	MOVI	DIAG_CYCLE_COLOR_START,A1
	MOVI	NUM_DIAG_CYCLE_COLORS,A2
	CALLA	pal_set
	SLOOP	1,PC_TRANSFER

**************************************************************************
*									 *
*	   CHK_CMOS							 *
*									 *
*	   This is the routine that is called at power up.		 *
*									 *
*	   It checks to see if CMOS adjustments are in tact.		 *
*	   IF THE ADJUSTMENTS ARE BAD, OR SET FOR A DIFFERENT		 *
*	   GAME OR REVISION, we cause a factory setting to		 *
*	   occur.  We then try and validate the all time		 *
*	   HSTD table.	If this is bad we then zero audits.		 *
*	   If HSTD table is ok, then we leave audits alone.		 *
*									 *
**************************************************************************
CHK_CMOS
	CALLR	DIGSRT	    ;CLEAR OUT THE SCREEN...(MESSAGE WILL FOLLOW!)
	CALLA	CMOS_VAL
	JRNZ	FAC_TIME
	MOVI	MESS_BITCHIN,A2 	 ;POINT AT DATA
	MOVI	ROBO_WHITE,A3
	JSRP	TOP_BOX
	SLEEPK	18H
	RETP
;	 JAUC	 WARMSET	      ;CMOS IS OK....RETURN!
*
*	WE NEED TO FACTORY SET THIS THING (DUE TO BAD SETTINGS.)
*
FAC_TIME:
	JSRP	GET_FAC 		  ;GET THE GAME TO FACTORY SETTINGS!
;	 JSRP	 WW_ADV 		   ;WAIT WHILE ADVANCE IS PRESSED
;
;	 JSRP	 WT_ADV 		   ;NOW WAIT TILL ADVANCE IS PRESSED
;
	CALLA	CLR_SCRN		  ;PRESSED....BLANK THE SCREEN AND
					   ;HOLD TILL HE LETS GO.
;
;	 JSRP	 WW_ADV 		   ;HOLD CONTROL HERE TILL HE LETS GO
	JAUC	 WARMSET	      ;CMOS IS OK....RETURN!
;	 JRUC	 DIAG_JUMP		   ;NOW INTO TEST MODE FOR ADV. BUTTON.

**************************************************************************
*									 *
*	   GET_FAC							 *
*									 *
*	   THIS IS CALLED TO BRING THE GAME TO A FACTORY SETTINGS	 *
*	   STATE.  IT WILL STORE THE FACTORY SETTINGS OR WAIT		 *
*	   UNTIL THE DOOR IS OPEN.  IF IT CAN'T GET FACTORY SETTINGS     *
*	   IT WILL PRINT A FAILURE MESSAGE.				 *
*									 *
**************************************************************************
GET_FAC

FAC_LOOP
	CALLA	CLR_SCRN		;CLEAR SCREEN IN ANTICIPATION OF MESSAGE
	clr	a0			;Full
	CALLA	FAC_SET
	CALLA	CMOS_VAL		;IS IT OK NOW?
	JRZ	CMOS_FIXED		;YEP....FINISH CLEANUP!

	MOVI	MESS_FAIL,A8		;POINT AT DATA
	JSRP	L_MESS			;DISPLAY LARRY MESSAGE

	JRUC	WAIT_POINT		;WE'RE DEAD..ADVANCE TAKES US TO TEST MODE!

CMOS_FIXED
*
*	THIS IS WHERE WE ARE ONCE WE HAVE FACTORY SET....
*	MESSAGE WOULD GO HERE.
*
	CALLR	CENT_BOX		;PUT A BOX AROUND IT

	MOVI	MESS_FAC,A8		;POINT AT DATA
	JSRP	L_MESS			;DISPLAY LARRY MESSAGE

*	NOW.....CLEAR HIGH SCORE TABLE
*	CLEAR OUT THE AUDITS.

	CALLA	FAC_STUF		;DO REST OF FULL FACTORY STUFF!

*	AT THIS POINT WE HANG WAITING FOR THE ADVANCE SWITCH.

WAIT_POINT
	RETP				;NOW LET CALLER TAKE OVER.

**************************************************************************
*									 *
*	   WT_ADV							 *
*									 *
*	   WAIT TILL ADVANCE.  THIS HOLDS CONTROL UNTIL ADVANCE 	 *
*	   BUTTON IS PRESSED.						 *
*									 *
**************************************************************************
;WT_ADV:
;	SLEEPK	2
;
;WT_A6: 
;	CALLR	GET_ADV 	      ;SCAN THE BUTTON
;	 JRNZ	 WT_ADV 	       ;NOT PRESSED.
;	 RETP
;

;**************************************************************************
;*									  *
;*	     WW_ADV							   *
;*									  *
;*	    WAIT WHILE ADVANCE.  THIS HOLDS CONTROL WHILE ADVANCE	  *
;*	    BUTTON IS HELD (OR STUCK).					  *
;*									  *
;**************************************************************************
;WW_ADV:
;	SLEEPK	2
;	 CALLR	 GET_ADV
;	 JRZ	 WW_ADV
;	 RETP
;
;**************************************************************************
;*									  *
;*	    GET_ADV							  *
;*									  *
;*	    THIS GETS PHYSICAL STATE OF ADVANCE BUTTON. 		  *
;*									  *
;*	    .EQ.    PRESSED						  *
;*	    .NE.    OPEN						  *
;*									  *
;**************************************************************************
;GET_ADV:
;	 MMTM	 SP,A0
;	 MOVE	 @COINS,A0,W		   ;FETCH COIN SWITCHES (LOOKING FOR ADVANCE)
;	 ANDI	 ADV_BIT,A0		   ;KEEP ADVANCE BIT.
;	MMFM	SP,A0
;	RETS
;
;**************************************************************************
;*									  *
;*	    CK_DOOR						   *
;*									  *
;*	    THIS IS CALLED TO SEE IF THE FRONT DOOR (MEMORY		  *
;*	    PROTECT SWITCH IS OPEN.					  *
;*									  *
;*	    .NE.    OPEN  (OK TO WRITE CMOS)				  *
;*	    .EQ.    CLOSED (CAN'T WRITE CMOS)                             *
;*									  *
;**************************************************************************
;CK_DOOR:
;	 MMTM	 SP,A0
;	 MOVE	 @COINS,A0,W		   ;FETCH COIN SWITCHES (LOOKING FOR ADVANCE)
;	 ANDI	 DOOR_BIT,A0		   ;KEEP COIN DOOR MEMORY PROTECT.
;	MMFM	SP,A0
;	RETS
;
**************************************************************************
*									 *
*	   GET_MENU							 *
*									 *
*	   This routine is called (via JSRP) to display a menu on	 *
*	   screen and receive a selection from the operator.		 *
*									 *
*	   The menu descriptor is passed in A8. 			 *
*									 *
*	   The selection number is returned in a8. (line 1 = 1) 	 *
*	   The routine address is returned in a9.			 *
*	   A10 is returned non-zero if advance was the button used	 *
*									 *
*	   A menu (pointed to by A8) is defined as follows:		 *
*									 *
*		       FONT TO BE USED		   (LONG)		 *
*		       X FOR LEFT MARGIN	   (WORD)		 *
*		       Y FOR TOP LINE		   (WORD)		 *
*		       DY PER ENTRY		   (WORD)		 *
*		       TEXT_COLOR		   (WORD)		 *
*		       HEIGHT OF SELECTION BAR	   (WORD)		 *
*		       DX FROM TOP OF TEXT TO SEL. BAR	(WORD)		 *
*									 *
*	   A9 POINTS AT ENTRY TO START WITH				 *
*									 *
*	   Then for each entry: 					 *
*									 *
*		       TEXT POINTER	   (LONG)			 *
*		       ACTIVATION ROUTINE  (LONG)			 *
*									 *
*	   The list is terminated by a zero.				 *
*									 *
*	   This routine forks a separate process to do the work 	 *
*	   for it.  Therefore the caller has full use of		 *
*	   the PDATA area.						 *
*									 *
**************************************************************************
*
*	 Equates for GET_MENU slave process.
*
MEN_OFF   EQU	  PDATA 	       ;WORD-OFFSET INTO MENU OF SELECTION
MEN_ROUT  EQU	  MEN_OFF+WORD_SIZE    ;LONG-ROUTINE FOR SELECTION
MEN_ROM   EQU	  MEN_ROUT+LONG_SIZE   ;LONG-POINTER TO ROM STRUCTURE
MEN_ULX   EQU	  MEN_ROM+LONG_SIZE    ;WORD-LEFT X  (CENTER X WHEN CENTERING)
MEN_ULY   EQU	  MEN_ULX+WORD_SIZE    ;WORD-TOP Y
MEN_DY	  EQU	  MEN_ULY+WORD_SIZE    ;WORD-Y UNITS PER ENTRY
MEN_COLR  EQU	  MEN_DY+WORD_SIZE     ;WORD-COLOR FOR ENTRIES
MEN_BAR   EQU	  MEN_COLR+WORD_SIZE   ;WORD-HEIGHT OF SELECTION BAR
MEN_BDY   EQU	  MEN_BAR+WORD_SIZE    ;WORD-DY FROM TOP OF TEXT TO TOP OF BAR.
MEN_BDX   EQU	  MEN_BDY+WORD_SIZE    ;WORD-DX FROM LEFT OF WORD TO LEFT OF BAR
MEN_BWID  EQU	  MEN_BDX+WORD_SIZE    ;WORD-WIDTH OF BAR
MEN_SCOL  EQU	  MEN_BWID+WORD_SIZE   ;WORD-COLOR OF SELECTED TEXT
MEN_TPTR  EQU	  MEN_SCOL+WORD_SIZE	;LONG-POINTER TO BEGINNING OF TEXT ENTRIES.
MEN_ENTS  EQU	  MEN_TPTR+LONG_SIZE   ;WORD-NUMBER OF ENTRIES IN MENU
MEN_CUR   EQU	  MEN_ENTS+WORD_SIZE   ;WORD-CURRENT SELECTION (1ST IS 1)
MEN_WALK  EQU	  MEN_CUR+WORD_SIZE    ;WORD-NUMBER OF ENTRY WE'RE ON AS WE WALK
MEN_STIK  EQU	  MEN_WALK+WORD_SIZE   ;LONG-"STUCK" STATE OF SWITCHES
MEN_ACT   EQU	  MEN_STIK+LONG_SIZE   ;LONG-SWITCH WE'RE ACTING ON. (BIT)
MEN_TYPO  EQU	  MEN_ACT+LONG_SIZE    ;WORD-TYPOMATIC COUNTER
MEN_HITS  EQU	  MEN_TYPO+WORD_SIZE   ;WORD-CONSECUTIVE TYPOMATIC HITS
MEN_ADV   EQU	  MEN_HITS+WORD_SIZE   ;WORD-NON-ZERO IF ADVANCE WAS BUTTON USED

WORD_ENTS    EQU    (MEN_TPTR-MEN_ULX)/WORD_SIZE   ;NUMBER OF WORD ENTRIES

B_MENU: 
	MOVI	BD_SLAVE,A7
	JRUC	GMJMP

GET_MENU:
	MOVI	GM_SLAVE,A7		;THIS IS ROUTINE
GMJMP:
	MOVI	MENU_PID,A1		;THIS IS ID
	CALLA	GETPRC			;CREATE IT

	MOVE	A0,A10			;SAVE HIS POINTER

GM1:	
	SLEEPK	2

	MOVI	MDUN_PID,A0
	MOVI	0FFFFH,A1
	CALLA	EXISTP			;WAIT FOR ID TO CHANGE TO THIS!

	JRZ	GM1			;LOOP UNTIL IT EXISTS!

	MOVE	*A10(MEN_OFF),A8	;RETURN OFFSET OF SELECTION
	MOVE	*A10(MEN_ROUT),A9,L	;AND ROUTINE THAT WAS SELECTED.
	MOVE	*A10(MEN_ADV),A10	;INDICATE WHETHER ADVANCE WAS USED

	MOVI	MDUN_PID,A0
	MOVI	0FFFFH,A1
	CALLA	KILALL			;KILL THE HANGING MENU GETTER!
	RETP				;AND RETURN

	
**************************************************************************
*									 *
*	   GM_SLAVE							 *
*									 *
*	   This displays the menu.......moves the selection bar 	 *
*	   and returns the selection information by stuffing		 *
*	   it in its process area and changing its ID to		 *
*	   MDUN_PID once selection is made.				 *
*									 *
*	   On entry....A8 points at the GET_MENU data structure.	 *
*		       A9 is which entry to start with selected.	 *
*									 *
**************************************************************************
BD_SLAVE
	CALLR	MENU_BORDER	     ;DRAW THE BORDER FOR SELCTIONS.
	SLEEP	3

GM_SLAVE
	JSRP	ST_STICK	  ;TELL STICK(S) AND BUTTONS WE'RE STARTING.

	CALLR	STUFF_MENU_PROCESS   ;MOVE DATA INTO PDATA AREA

*	PLOT ENTIRE MENU
*
*	DO_MENU_LINE WILL RETURN CARRY SET
*	WHEN WE GET BEYOND THE END.

	MOVK	1,A0			    ;SETUP FOR LINE 1.

DO_ANOTHER_LINE

	MOVE	A0,*A13(MEN_WALK),W	  ;WALK THROUGH.

	JSRP	DO_MENU_LINE		  ;PUT OUT LINE IN A0.
	MOVE	*A13(MEN_WALK),A0,W	  ;GET BACK THE COUNTER

	INC	A0			  ;MOVE TO NEXT ENTRY.
	MOVE	*A13(MEN_ENTS),A1,W	  ;SEE IF WE'RE DONE.
	CMP	A1,A0
	JRLS	DO_ANOTHER_LINE
*
*	MAIN MENU PLOTTED......NOW LET THE DMA UN-LOAD BEFORE PLOTTING HELP
*
	SLEEP	2
	CALLR	PLOT_HELP		  ;PLOT HELP FOR 1ST IF NECESSARY

*	 SLEEPK	 2			   ;NOW MAKE SURE THE HELP GETS PLOTTED
*
*	NOW WE JUST WANT TO UPDATE BASED ON STICK...ACT
*	ON BUTTONS!
*
*	RESPONSES:   UP....DOWN....BUTTON....NOTHING....
*
*	NOTHING = 0
*	UP = 1
*	DOWN = 2
*	BUTTON = 3
*
*	A0 = RESPONSE
*	A1 = MEN_CUR VALUE.

MENU_LOOP
	SLEEPK	1
	calla	READ_DIP		;Get the current dip switch bits
	btst	DPTEST_B,a0
	jrnz	#dipon

;	move	@COINS,a5
;	btst	4,a5
;	jrnz	DIAG_EX			;Test switch off?
#dipon
	MOVI	MENU_TYPO,A5
	JSRP	GETSTICK		;ASK THE STICK HANDLER.......
	MOVE	A0,A0			;SEE WHAT GET_STICK RETURNED.
	JRZ	MENU_LOOP		;MENU...(PAUSE)	 NOTHING.

	MOVE	*A13(MEN_CUR),A1,W	;GET CURRENT ENTRY...IN A1

	CMPI	3,A0			;BUTTON?
	JRZ	MENU_BUTTON		;YEP....WE'RE OUT OF HERE.

	CMPI	2,A0
	JRZ	MENU_DOWN		;ITS DOWN....
*
*	REQUEST TO GO UP....ARE WE AT #1
*
	CMPI	1,A1			;WELL?
	JRLS	MENU_LOOP		;YEP....IGNORE

	JSRP	UN_SELECT		;PUT BACK THE OLD "CURRENT ONE
	MOVE	*A13(MEN_CUR),A0,W	;GET CURRENT ENTRY
	DEC	A0			;MAKE ONE LESS.
	JRUC	JOIN_DOWN		;NOW PLOT THE NEW ONE.

MENU_DOWN:
	MOVE	*A13(MEN_ENTS),A2,W	;GET NUMBER IN MENU
	CMP	A2,A1			;ARE WE AT MAX
	JRHS	MENU_LOOP		;YEP...NO ACTION

	JSRP	UN_SELECT		;PUT BACK THE OLD "CURRENT ONE

	MOVE	*A13(MEN_CUR),A0,W	;GET CURRENT ENTRY
	INC	A0			;MAKE THIS THE NEXT.

JOIN_DOWN:
	MOVE	A0,*A13(MEN_CUR),W	;PUT BACK
	JSRP	DO_MENU_LINE		;PUT OUT LINE IN A0.
*
*	MAKE THE "DINK" SOUND HERE FOR ENTRY TO ENTRY MOVEMENT
*
	CALLR	PLOT_HELP		;PLOT HELP NEW ONE
	SLEEPK	1			;DELAY BEEP 1 FRAME
	SOUND1	diag_cursor
	JRUC	MENU_LOOP		;AND WAIT FOR NEXT RESPONSE.
*
*	CONTROL COMES HERE WHEN A BUTTON IS PRESSED
*
*	  The selection number is returned in a8. (line 1 = 1)		
*	  The routine address is returned in a9.			

MENU_BUTTON:
*
*	A0 HAS A 3.
*	A2 HAS THE BUTTON BIT.....IS IT ADVANCE?
*
	MOVE	*A13(MEN_ROM),A0,L
	CMPI	MEN_ADJ,A0		; SPECIAL CASE FOR MENU ADJ
	JRNZ	MBNOTADJ
	CALLA	CKDIP
	JRNZ	MBNOTADJ		; NOT USING DIP SWITCHES
	MOVE	*A13(MEN_CUR),A0,W	; GET THE SELECT ITEM
	CMPI	2,A0			; "STANDARD PRICING"
	JRZ	MBABORT
	CMPI	3,A0			; "CUSTOM PRICING"
	JRZ	MBABORT
	CMPI	4,A0			; "FREE PLAY"
	JRNZ	MBNOTADJ
MBABORT

	.ref	error_found
	SOUND1	error_found
	JRUC	MENU_LOOP
MBNOTADJ
	CLR	A0			;NOT ADVANCE

IS_ADV: 
	MOVE	A0,*A13(MEN_ADV),W	;NON ZERO IF IT WAS ADVANCE

	JSRP	BUTTON_STALL		;HIGHLIGHT SELECTION AND HANG ON BUTTON

	MOVE	*A13(MEN_CUR),A0,W	;GET "CURRENT" ENTRY.
	CALLR	GET_MENU_DATA		;A1=CURRENT_OFFSET  A2=TEXT  A3=ROUTINE
	MOVE	A0,*A13(MEN_OFF),W	;STORE THE OFFSET (CHOICE NUM)
	MOVE	A3,*A13(MEN_ROUT),L	;AND THE ROUTINE POINTER
	MOVI	MDUN_PID,A0
	MOVE	A0,*A13(PROCID),W	;CHANGE OUR ID.

MENU_DONE:
	SLEEPK	20
	JRUC	MENU_DONE		;NOW HANG TILL DISPATCHER SEES ID.

**************************************************************************
*									 *
*		  MENU UTILITIES					 *
*									 *
**************************************************************************
**************************************************************************
*									 *
*	   BUTTON_STALL 						 *
*									 *
*	   THIS IS CALLED WHEN THE MENU GETS A BUTTON HIT.		 *
*	   A1 HAS THE BIT OF THE BUTTON.				 *
*									 *
*	   WE PAINT THE MENU SQUARE TO FEEDBACK THE HIT.		 *
*									 *
*	   THEN WE HANG ON THE BUTTON UNTIL ITS LET GO. 		 *
*									 *
**************************************************************************
BUTTON_STALL:
	MOVE	A2,@LAST_BUT,L	     ;PUSH THE BUTTON STATE

	MOVE	@SCODE,A0,W	     ;NO CASH FOR REPEAT SOUND CODES
	MOVE	@DCODE,A1,W
	OR	A0,A1
	JRNZ	DONT_WAIT	     ;ITS A SOUND REPEAT....DON'T HOLD EITHER!

	.ref	diag_select
	SOUND1	diag_select	      ;MAKE SELECT SOUND

	MOVE	*A13(MEN_CUR),A0,W   ;GET CURRENT SELECTION
	MOVI	COLOR_YELLOW,A1
	CALLR	MENU_BAR	     ;CHANGE THE BAR COLOR.

	CALLR	GET_MENU_DATA		  ;GET OUR TEXT POINTER BACK
	MOVI	ROBO_WHITE,A1		 ;WHITE ON ORANGE DURING HOT MOMENT
	JSRP	MENU_TEXT		  ;AND WRITE INVERTED TEXT

	MOVE	@LAST_BUT,A8,L		  ;GET BUTTON BACK
	MOVI	08H,A9			  ;MINIMUM TIME FOR BUTTON HIGHLITE

;	 MOVI	 2AH,A10	      ;.5 SECONDS OF ADVANCE HOLD-DOWN
*				      ;WILL EXIT TEST MODE.
WAIT_FOR_RELEASE:
;	 CMPI	 ADV_HIGH,A8		   ;IS IT ADVANCE BUTTON?
;	 JRNZ	 NOT_ADV		   ;NOPE.....NEVER MIND

;	 DEC	 A10		      ;1 LESS TIME UNIT
;	 JRZ	 DIAG_EX	    ;IF HE HOLDS ADVANCE...WE'RE GONE!

;NOT_ADV:
	SLEEPK	1
	
	MOVE	A9,A9		     ;REDUCE FOR HELD TIME
	JRZ	WAIT_1		     ;ZEROED OUT ALREADY.
	DEC	A9

WAIT_1:
	CALLR	FORM_SWS	;WAIT FOR THIS ONE TO GO TO ZERO
	AND	A8,A0		     ;IS OUR BUTTON STILL DOWN?
	JRNZ	WAIT_FOR_RELEASE
*
*	ITS RELEASED...NOW SHOW ORANGE BAR FOR MINIMUM TIME

	INC	A9		     ;MAKE SURE A9 HAS 1 OR MORE
WAIT_2:
	SLEEPK	1
	DSJS	A9,WAIT_2

DONT_WAIT:
	MOVE	*A13(MEN_CUR),A0,W   ;GET CURRENT SELECTION
	CLR	A1		     ;ERASE BAR
	CALLR	MENU_BAR	     ;CHANGE THE BAR COLOR.

	CALLR	GET_MENU_DATA		  ;GET OUR TEXT POINTER BACK
	MOVE	*A13(MEN_COLR),A1,W	  ;RE-PLOT THE NORMAL TEXT
	JSRP	MENU_TEXT		

	SLEEPK	2		     ;NOW GIVE SOME BOUNCE PROTECTION.

	RETP

	.STRING	"NNBBAA  JJAAMM  --  CCOOPPYYRRIIGGHHTT  11999933  "
	.STRING	"MMIIDDWWAAYY  MMAANNUUFFAACCTTUURRIINNGG  CCOOMMPPAANNYY..  "
	.STRING	"AALLLL  RRIIGGHHTTSS  RREESSEERRVVEEDD..  "
	.STRING	"DDEESSIIGGNNEEDD  BBYY::  MMAARRKK  TTUURRMMEELLLL  "
	.STRING	"SSHHAAWWNN  LLIIPPTTAAKK  TTOONNYY  GGOOSSKKIIEE  "
	.STRING	"JJOOHHNN  CCAARRLLTTOONN  SSAALL  DDIIVVIITTAA  "
	.STRING	"JJOOHHNN  HHEEYY  AANNDD  JJAAMMIIEE  RRIIVVEETTTT..  "
	.STRING	"SSPPEECCIIAALL  TTHHAANNKKSS  TTOO::  LLIINNDDAA  DDEEAALL  "
	.STRING	"AANNDD  GGEEOORRGGEE  PPEETTRROO.."
	.even

**************************************************************************
*									 *
*	   STUFF_MENU_PROCESS						 *
*									 *
*	   THIS IS CALLED TO STUFF THE MENU ROM DATA INTO THE		 *
*	   CURRENT PROCESSES PDATA AREA.				 *
*									 *
**************************************************************************
STUFF_MENU_PROCESS:
	MMTM	SP,A0,A1,A2,A3,A8
	MOVE	A13,A0		     ;POINT IN PROCESS AREA
	ADDI	MEN_ROM,A0	     ;THIS IS WHERE 1ST TIDBIT GOES
	MOVE	A8,*A0+,L	     ;STORE OUR BASE POINTER IN STRUCTURE
	ADDI	MR_WORDS,A8	     ;MOVE TO WORD LIST

	MOVI	WORD_ENTS,A2	     ;NOW THIS MANY MORE WORDS.

GMS1:	
	MOVE	*A8+,A1
	MOVE	A1,*A0+
	DSJS	A2,GMS1
*
*	ALL THE MENU PARAMETERS ARE NOW IN THE PDATA AREA.
*	A8 POINTS AT THE FIRST ITEM TO DISPLAY.
*
	MOVE	A8,*A13(MEN_TPTR),L  ;STORE IN PROCESS AREA.
*
*	NOW WE WANT TO FIND THE NUMBER OF ENTRIES IN THE MENU
*
	CLR	A0			  ;START AT #1.
HOW_MANY:
	INC	A0			  ;MOVE TO NEXT ENTRY.
	CALLR	GET_MENU_DATA		  ;GET THE PARAMETERS FOR THIS ENTRY
	MOVE	A2,A2			  ;AND SEE IF A2=0
	JRNZ	HOW_MANY		  ;ITS REAL.....PUT IT UP.

	DEC	A0			  ;PREVIOUS LINE WAS THE LAST.
	MOVE	A0,*A13(MEN_ENTS),W	  ;STUFF NUMBER IN MENU.

	MOVE	A9,A9			  ;DID BOZO PASS ZERO AS CURRENT?
	JRZ	USE_LAST
	CMP	A0,A9			  ;MAKE SURE ITS NOT TOO HIGH
	JRHI	USE_LAST		  ;A9 IS TOO HIGH
	MOVE	A9,A0			  ;USE THE ONE PAST

USE_LAST:
	MOVE	A0,*A13(MEN_CUR),W   ;MAKE ENTRY "1" CURRENT.
	MMFM	SP,A0,A1,A2,A3,A8
	RETS

**************************************************************************
*									 *
*	   DO_MENU_LINE 						 *
*									 *
*	   A0 HAS THE LINE TO DO. (1 THROUGH N).			 *
*	   PRINT TEXT NORMAL IF NOT "MEN_CUR".				 *
*	   PRINT INVERT BAR FOLLOWED BY BLACK TEXT IF			 *
*	   ITS THE CURRENT ENTRY.					 *
*									 *
**************************************************************************
DO_MENU_LINE:
	CALLR	GET_MENU_DATA		  ;GET "CURRENT" IN A1
	CMP	A0,A1			  ;IS IT "CURRENT" ENTRY?
	JRZ	DO_CURRENT_ENT		  ;YEP....DO INVERSE STUFF
*
*	A0 HAS OFFSET (FOR POSITIONING)
*	A2 HAS TEXT POINTER (FOR MESSAGE)
*	A1 NEEDS COLOR FOR MESSAGE.
*
	MOVE	*A13(MEN_COLR),A1,W	  ;USE THE NORMAL ENTRY COLOR
	JSRP	MENU_TEXT		  ;PUT UP THE "TEXT" PORTION.
	RETP				  ;AND RETURN

DO_CURRENT_ENT: 
	MOVI	ROBO_WHITE,A1		 ;DO THE BAR IN WHITE (AT A0 HEIGHT)
	CALLR	MENU_BAR		  ;PUT IT UP (A0 PRESERVED)

	CALLR	GET_MENU_DATA		  ;GET OUR TEXT POINTER BACK
	MOVE	*A13(MEN_SCOL),A1,W	  ;GET "SELECTED" COLOR
	JSRP	MENU_TEXT		  ;AND WRITE INVERTED TEXT
	RETP				  ;THAT'S ALL FOLKS.

**************************************************************************
*									 *
*	   UN_SELECT							 *
*									 *
*	   THIS IS CALLED TO "UN-SELECT" THE CURRENT ENTRY.		 *
*									 *
**************************************************************************
UN_SELECT:
	MOVE	*A13(MEN_CUR),A0,W	  ;POINT AT CURRENT ENTRY
	CLR	A1			  ;USE BLACK FOR BACKGROUND
	CALLR	MENU_BAR		  ;THIS REMOVES THE BAR.

	CALLR	GET_MENU_DATA		  ;NOW GET A2 TO TEXT POINTER
	MOVE	*A13(MEN_COLR),A1,W	  ;USE THE NORMAL ENTRY COLOR
	JSRP	MENU_TEXT		  ;PUT UP THE "TEXT" PORTION.
	RETP				  ;AND RETURN

**************************************************************************
*									 *
*	   MENU_BAR							 *
*									 *
*	   THIS IS CALLED TO PUT UP THE SELECTION BAR FOR		 *
*	   THE ENTRY IN A0, IN THE COLOR IN A1. 			 *
*									 *
*	   THIS ROUTINE MUST PRESERVE A0.				 *
*									 *
**************************************************************************
* STRNGLEN - RETURNS THE LENGTH, IN PIXELS, OF A GIVEN STRING		 *
* A8 = PTR TO STRING							 *
* A10 = [Y,X] SPACING OF STRING						 *
* A11 = PTR TO FONT TABLE						 *
* RETURNS:								 *
* A7 = LENGTH OF STRING							 *
* Z BIT SET IF LENGTH IS ZERO						 *
*
*	 FOR FILLAREA
*
* A1 = <COLOR><PALETTE>
* A3 = DAG OF AREA [YPOS,XPOS]						
* A4 = [Y,X] SIZE OF AREA						
*
MENU_BAR:
	MMTM	SP,A0,A1,A3,A4,A5,A6,A7,A8    ;SAVE THE OFFSET
	MMTM	SP,A1			  ;SAVE COLOR!
	CALLR	GET_MENU_DATA		  ;GET THE TEXT POINTER
	CALLR	STLEN_SETUP		  ;SETUP FOR STRLEN CALL.
	CALLA	STRNGLEN		  ;FIND WIDTH OF STRING.
*
*	A7 HAS LENGTH OF STRING.
*
*	WE NEED TO GET INTO A3 THE COORDINATES UF UPPER LEFT
*	AND A4 THE LENGTH.
*
*	IF WE'RE CENTERING, WE USE THE BAR WIDTH PARAMETER
*	ALONG THE CENTER LINE.
*
*	IF WE'RE LEFT JUSTIFIED, WE'LL LET THE BOX GO THE
*	LENGTH OF THE TEXT FOR NOW.
*
	MOVE	*A13(MEN_ULX),A3,W	  ;LEFT X IN A3 		
*
*	IF WE'RE CENTERING....WE NEED TO MOVE THE "LEFT X" BACK HALF
*	THE WIDTH OF THE STRING.
*
	MOVE	*A13(MEN_ROM),A6,L	  ;GET ROM POINTER
	MOVE	*A6(MR_TCAL),A6,L	  ;CHECK ROUTINE
	CMPI	STRCNRM,A6
	JRNZ	NOT_CENTERING
*
*	WE'RE CENTERING....CENTER X IS IN A3
*
	MOVE	*A13(MEN_BWID),A7,W	  ;A7 IS THE REGISTER FOR BAR WIDTH
	MOVE	A7,A4			  ;GET COPY IN A4
	SRL	1,A4			  ;1/2 OF WIDTH COMES OFF OF CENTER
	SUB	A4,A3			  ;A3 NOW HAS "LEFT X"
	JRUC	CENTERING		  ;A7 IS WIDTH...A3 IS X

*
*	LEFT JUSTIFIED....DO IT THE OLD WAY!
*
NOT_CENTERING:
	MOVE	*A13(MEN_BDX),A4,W	  ;GET EXTRA X UNITS FOR BAR
	SUB	A4,A3

*	NOW ADD TWICE THE EXTRA X TO THE STRING LENGTH TO
*	FORM THE BAR LENGTH.
*
	SLL	1,A4			  ;NOW DOUBLE THE EXCESS DX FOR BAR
	ADD	A4,A7			  ;NOW A7 HAS WIDTH OF BAR

CENTERING:
	SUBI	C_KLUDGE,A3	     ;KLUDGE TO NULLIFY FINAL SPACE.

	CALLR	GET_ENTRY_Y		  ;GET Y FOR ENTRY IN A5

	MOVE	*A13(MEN_BDY),A6,W	  ;GET BAR DY (NEGATIVE)
	ADD	A6,A5			  ;ADJUST Y BY BAR DY
	SLL	16,A5			  ;SHIFT Y INTO POSITION

	ADD	A5,A3			  ;A3 NOW POINTS AT UPPER LEFT

	MOVE	*A13(MEN_BAR),A4,W	  ;Y HEIGHT OF BAR
	SLL	16,A4			  ;IN POSITION
	ADD	A7,A4			  ;A7 HAS X WIDTH OF BAR.

	MMFM	SP,A1			  ;NOW GET COLOR BACK!
	SLL	16,A1			  ;SHIFT COLOR TO HIGH HALF (PAL. 0)
	CALLA	FILLAREA		  ;FILL IT UP!

	MMFM	SP,A0,A1,A3,A4,A5,A6,A7,A8    ;SAVE THE OFFSET
	RETS

**************************************************************************
*									 *
*	   MENU_TEXT							 *
*									 *
*	   THIS IS CALLED TO DISPLAY THE TEXT FOR AN ENTRY.		 *
*									 *
*	   A0 HAS OFFSET (FOR POSITIONING)				 *
*	   A1 HAS COLOR FOR MESSAGE.					 *
*	   A2 HAS TEXT POINTER (FOR MESSAGE)				 *
*									 *
*	   WE NEED TO SHIFT THE DATA FOR THE TEXT ROUTINE		 *
*	   AS FOLLOWS:							 *
*									 *
*	   A0 = SLEEP							 *
*	   A6 = COLOR							 *
*	   A8 = POINTER 						 *
*	   A9 = ADDRESS 						 *
*	   A10 = SPACING						 *
*	   A11 = FONT							 *
*									 *
**************************************************************************
MENU_TEXT:
	CALLR	GET_ENTRY_Y		  ;GET Y FOR ENTRY IN A5
	SLL	16,A5			  ;SHIFT Y INTO POSITION
	MOVE	*A13(MEN_ULX),A9,W	  ;GET THE X
	ADD	A5,A9			  ;A9 SET WITH SCREEN ADDRESS

	MOVE	A1,A6			  ;COLOR
	CLR	A0			  ;NO SLEEP

	CALLR	STLEN_SETUP

	MOVE	*A13(MEN_ROM),A1,L
	MOVE	*A1(MR_TCAL),A1,L	  ;GET THE ROUTINE TO USE
	JUMP	A1			  ;AND CALL IT!

STLEN_SETUP:
	MOVE	A2,A8			  ;TEXT POINTER
	MOVI	SPACING20,A10		  ;SPACING
	MOVE	*A13(MEN_ROM),A11,L
	MOVE	*A11(MR_FONT),A11,L	  ;LOAD FONT
	RETS

**************************************************************************
*									 *
*	   MENU JOYSTICK HANDLING					 *
*									 *
**************************************************************************
ST_STICK:
	CALLR	FORM_SWS	   ;THIS LATCHES ANYONE ALREADY DOWN.
	CLR	A0
	MOVE	A0,*A13(MEN_ACT),L	;SHOW THAT WE'RE "ACTING" ON NONE.
	MOVE	A0,*A13(MEN_TYPO),W	;CLEAR TYPOMATIC COUNTER.
	MOVE	A0,*A13(MEN_HITS),W	;CLEAR OUT "CONSECUTIVE HITS"
	RETP
*
*	GETSTICK......RETURN DEBOUNCED/TYPOMATIC FOR
*			UP AND DOWN......OR EDGE OUT
*			ANY BUTTON....(INCLUDING ADVANCE)
*
*	RETURN A0=
*
*	NOTHING = 0
*	UP = 1
*	DOWN = 2
*	BUTTON = 3
*
*	A2 = BUTTON BIT ON BUTTON HITS
*
UP_OR_DOWN	 EQU	 UP_BITS+DOWN_BITS
TYPO_COUNT	 EQU	 4
TYPO_STALL	 EQU	 25
MENU_TYPO	 EQU	 (TYPO_COUNT*10000H)+14      ;14 HITS FOR MENU TILL STUCK
	
*
*	 TO USE THIS.......FIRST JSRP ST_START.
*			   THIS STICKS CLOSED SWITCHES AND
*			   INITIALIZES COUNTERS.
*
*			   DATA IS STORED IN YOUR PDATA
*			   AREA.....AT AREAS DETERMINED
*			   BY THE "MEN_" STRUCTURE.  THESE
*			   LOCATIONS MUST BE AVAILABLE.
*
*			   A8-A11 ARE NOT TOUCHED.
*
*	  AFTER ST_START.....READ AS FOLLOWS.
*
*
*	  LOOP	    SLEEP  1
*		    MOVI   TYPO_PARMS,A5
*		    JSRP   GETSTICK
*
*		    <LOGICAL STICK STATE RETURNED IN A0>
*		    <ACT ON LOGICAL STATE>
*
*		    JRUC LOOP
*		
*
*	 INPUT A5-----TOP HALF IS TYPOMATIC RATE
*		      LOW HALF IS COUNT TILL STICK IS CALLED STUCK
*
GETSTICK:
	MOVE	A5,A6
	SRL	16,A5		     ;TYPO RATE IN A5
	ANDI	WORD_MASK,A6	     ;STUCK HIT COUNT IN A6

	CALLR	FORM_SWS	;SEE WHAT THEY LOOK LIKE NOW.
*
*	RETURN CURRENT STATE IN A0..PREVIOUS STATE IN A1.
*
	NOT	A1		     ;LAST = 0 AND NOW = 1 MEANS EDGE!

	AND	A1,A0		     ;1'S WHERE WE HAVE POSITIVE EDGE.
	MOVE	A0,A4		     ;KEEP NEW EDGE STATE IN A4!

	ANDI	BUTTONS|START_BITS,A0	     ;BUTTON SAYS ACT....IGNORE STICK!
	JRNZ	TEST_BUTS	     ;NEW BUTTON......RETURN IT!
*
*	NO BUTTON.....DO STICK TYPOMATIC STUFF!
*
	MOVE	*A13(MEN_ACT),A2,L   ;IS THERE ONE TO WATCH?
	JRZ	NEW_SCAN	     ;NOPE....LOOK FOR NEW STUFF!
*
*	WE HAVE ONE THAT'S DOWN THAT WE WANT TO WATCH.
*
	CALLR	FORM_SWS	;SEE WHAT THEY LOOK LIKE NOW.
	AND	A2,A0		     ;IS IT STILL MADE?
	JRZ	GS_STICK_OPEN	     ;NOPE.......CLEAR OUT ITS STATE.
*
*	ITS STILL MADE........DO TYPOMATIC.
*
	MOVE	*A13(MEN_TYPO),A1,W  ;DECREMENT TYPOMATIC COUNTER
	DEC	A1
	MOVE	A1,*A13(MEN_TYPO),W  ;AND PUT BACK IN MEMORY
	JRNZ	GS_ZERO 	     ;NOT TIME YET.....RETURN NOTHING
*
*	WE HAVE A TYPOMATIC HIT.....WE NEED TO TURN SWITCH BIT (A0)
*	INTO "UP" OR "DOWN" AND RE-LOAD TYPOMATIC COUNTER.
*
*
	MOVE	*A13(MEN_HITS),A1,W  ;GET NUMBER OF HITS
	INC	A1		     ;AFTER 15 TYPOS.....KILL TILL OPEN!
	MOVE	A1,*A13(MEN_HITS)    ;
	CMP	A6,A1		     ;TOO MANY HITS?
	JRHS	GS_GONE 	     ;YEP....CALL THIS "STUCK"
	MOVE	A5,*A13(MEN_TYPO),W  ;TYPOMATIC COUNTER RELOADED.

RETURN_UP_DOWN:
	MOVE	A0,A1		     ;GET THE BIT
	MOVE	A1,A2		     ;MAKE A COPY
	MOVK	1,A0		     ;ASSUME UP
	ANDI	UP_BITS,A1	     ;IS IT AN "UP" BIT
	JRNZ	GS_X		     ;YEP...RETURN UP.
	MOVK	2,A0		     ;ASSUME DOWN
	ANDI	DOWN_BITS,A2	     ;IS IT A "DOWN" BIT
	JRNZ	GS_X		     ;YEP...RETURN "DOWN"
*
*	 NOT A TYPOMATIC CONDITION.
*

GS_GONE:
	CLR	A0		     ;CLEAR OUT CURRENT HIT.
	MOVE	A0,*A13(MEN_ACT),L   ;INDICATE READY FOR NEXT HIT!
	JRUC	GS_X		     ;AND RETURN THIS ZERO (NOTHING!)
*
*	STICK THAT WAS CLOSED OPENED......STOP BOUNCE UPWARD!
*
GS_STICK_OPEN:
	SLEEPK	6
	JRUC	GS_GONE 	     ;NOW.....CLEAR OUT FOR NEXT HIT.
*
*	CONTROL COMES HERE WHEN NO BUTTONS ARE PENDING.
*
NEW_SCAN:
	MOVE	A4,A0		     ;LOOK AT THE NEW EDGES.

	ANDI	UP_OR_DOWN,A0	     ;IS IT UP OR DOWN?
	JRZ	GS_ZERO 	     ;NO STICK....RETURN NO ACTION!

	CALLR	FRST_BIT	     ;REDUCE TO ONE BIT.
	MOVE	A0,*A13(MEN_ACT),L   ;STORE THIS BIT

	MOVI	TYPO_STALL,A1
	MOVE	A1,*A13(MEN_TYPO),W  ;TYPOMATIC COUNTER SET FOR LONG STALL.

	CLR	A1
	MOVE	A1,*A13(MEN_HITS),W  ;LOAD UP A BUNCH OF HITS
	JRUC	RETURN_UP_DOWN	     ;RETURN CORRECT CODE UP OR DOWN
*
*	NOT UP OR DOWN......SEE IF ITS A BUTTON.
*
TEST_BUTS:
*
*	ITS A BUTTON...ALL NEW BUTTON EDGES IN A0
*
	CALLR	FRST_BIT	     ;USE 1 OF THEM.

	MOVE	A0,A2		     ;RETURN THE BIT.

	MOVI	3,A0		     ;RETURN THAT ITS A BUTTON.
	JRUC	GS_X		     ;STUCK PROCESSING WILL BE AUTOMATIC.

GS_ZERO:
	CLR	A0		     ;RETURN NO SWITCH.
GS_X:	
	RETP

**************************************************************************
*									 *
*	   FRST_BIT							 *
*									 *
*	   A0 HAS 1 OR MORE BITS SET....RETURN 1 OF THEM.		 *
*									 *
**************************************************************************
FRST_BIT:
	MMTM	SP,A1,A2
	MOVK	1,A1		;SHIFT TILL WE FIND IT.
FB1:	
	MOVE	A0,A2
	AND	A1,A2
	JRNZ	GOT_IT		;WE HAVE ON (IN A1)
	SLL	1,A1		;SHIFT IT
	JRUC	FB1
GOT_IT: 
	MOVE	A1,A0		;RETURN THE BIT
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*									 *
*	   FORM_SWS						    *
*									 *
*	   GET THE SWITCHES....1=CLOSED.....AND SAVE			 *
*	   THIS SCAN AS "LAST STATE".  RETURN:				 *
*									 *
*	   CURRENT STATE IN A0						 *
*	   PREVIOUS STATE IN A1 					 *
*									 *
**************************************************************************
FORM_SWS:
	callr	fudge_switches

	move	*a13(MEN_STIK),a1,L	;RETURN PREVIOUS STATE
	move	a0,*a13(MEN_STIK),L	;SAVE "STUCK" STATE.
	rets

**************************************************************************
fudge_switches
	move	@_switch_addr,a0,L
	move	*a0,a0,W
	move	@_switch2_addr,a1,L
	move	*a1,a1,W
	and	a1,a0
	sll	16,a0
	srl	16,a0
	move	@_coin_addr,a1,L
	move	*a1,a1,W
	sll	16,a1
	or	a1,a0

	move	@_switch_map_mode,a1,L	;Are we mapping switches?
	jrz	_switch_mapping_done	; br=no
	cmpi	2,a1
	jrgt	_no_adjustment_mapping

	move	a0,a1			;Make vol +,- be P1 dn,up
	srl	16+11,a1
	ori	0fffffffch,a1
	and	a1,a0

	move	a0,a1			;Make serv,test be P1 C,A
	srl	16,a1
	ori	0ffffffafh,a1
	and	a1,a0

	move	@_switch_map_mode,a1,L
	cmpi	1,a1
	jrz	_switch_mapping_done

	movi	00400000h,a1
	or	a1,a0			; No Service button in adjust mode
	jruc	_switch_mapping_done

_no_adjustment_mapping
	cmpi	3,a1			; Are we in any button mapping mode
	jrnz	_no_any_mapping		; Nope - go check other modes

	move	a0,a1			;Make vol +,- be P1 C,B
	srl	16+6,a1
	ori	0ffffff9fh,a1
	and	a1,a0

	move	a0,a1			;Make test be P1 A
	srl	16,a1
	ori	0ffffffefh,a1
	and	a1,a0

	move	a0,a1			;Make serv be P1 D
	srl	16-1,a1
	ori	0ffffff7fh,a1
	and	a1,a0

	move	a0,a1			;Make start1 be P2 A
	srl	16-10,a1
	ori	0ffffefffh,a1
	and	a1,a0

	move	a0,a1			;Make start2 be P2 B
	srl	16-8,a1
	ori	0ffffdfffh,a1
	and	a1,a0

	move	a0,a1			;Make start3,4 be P2 C,D
	srl	16-5,a1
	ori	0ffff3fffh,a1
	and	a1,a0

_no_any_mapping
_switch_mapping_done
	not	a0
	rets


**************************************************************************
*SPECIAL DIAGNOSTIC VERSION OF fudge_switches
*USE FCALL WITH B6 AS THE RETURN REGISTER WHEN CALLING.
*
fudge_switches_diag
;	move	@SWITCH,a0,L		;GET BOTH SWITCH WORDS
	move	@_switch_addr,a0,L
	move	*a0,a0,W
	move	@_coin_addr,a1,L
	move	*a1,a1,W
	sll	16,a1
	or	a1,a0
	not	a0			;COMPLEMENT
	move	@_switch2_addr,a1,L
	move	*a1,a1
	not	a1
	move	a1,a14
	andi	0011b,a14
	sll	6,a14
	or	a14,a1
	or	a1,a0
	FRET	B6


;fudge_switches_diag
;
;	move	@SWITCH,a0,L		;GET BOTH SWITCH WORDS
;	not	a0			;COMPLEMENT
;
;	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
;	jrnz	#2_plyrs2
;
;	move	@SWITCH+20h,a1		;move P3UP & P3DOWN into low 32 bits
;	not	a1
;	andi	011b,a1
;	or	a1,a0
;
;	move	@SWITCH+28h,a1		;move P4UP & P4DOWN into low 32 bits
;	not	a1
;	andi	011b,a1
;	or	a1,a0
;
;	move	@SWITCH+20h,a1		;move P3 ACTION buttons into low 32 bits
;	not	a1
;	andi	01110000b,a1
;	or	a1,a0
;
;	move	@SWITCH+28h,a1		;move P4 ACTION buttons into low 32 bits
;	not	a1
;	andi	01110000b,a1
;	or	a1,a0
;
;#2_plyrs2
;	FRET	B6

**************************************************************************
fudge_switches2

	callr	fudge_switches
	move	@fswitches_cur,a1,L
	move	a1,@fswitches_last,L
	move	a0,@fswitches_cur,L
	xor	a0,a1			;bits that have changed
	and	a0,a1			;down transitions only
	move	a1,@fswitches_down,L

	rets

**************************************************************************
*									 *
*	   GET_MENU_DATA						 *
*									 *
*	   A0 IS OFFSET OF ENTRY OF INTEREST				 *
*									 *
*	   RETURN  A1 = CURRENT OFFSET					 *
*		   A2 = TEXT POINTER					 *
*		   A3 = ROUTINE 					 *
*									 *
**************************************************************************
GET_MENU_DATA:
	MMTM	SP,A0		     ;DON'T ALTER A0

	CALLR	PM_ENTRY     ;POINT A1 AT ENTRY

	MOVE	*A1(MENU_TEXT_PTR),A2,L   ;FETCH THE TEXT POINTER
	MOVE	*A1(MENU_ROUTINE),A3,L	  ;FETCH THE ROUTINE
	MOVE	*A13(MEN_CUR),A1,W	  ;RETURN CURRENT ENTRY IN A1
	MMFM	SP,A0		     ;DON'T ALTER A0
	RETS

**************************************************************************
*									 *
*	   PM_ENTRY							 *
*									 *
*	   A0 = MENU ENTRY OF INTEREST					 *
*	   RETURN A1 -> POINTS AT <TEXT><ROUTINE><HELP> FOR THIS	 *
*	   ENTRY.							 *
*									 *
**************************************************************************
PM_ENTRY:
	MMTM	SP,A0
	DEC	A0		     ;INDEX FROM ZERO
	MOVI	MENU_ENTRY_SIZE,A1   ;TIMES SIZE PER ENTRY
	MPYU	A0,A1		     ;A1 CONTAINS OFFSET INTO TABLE

	MOVE	*A13(MEN_TPTR),A0,L  ;GET THE BASE OF THE MENU TEXT ENTRIES
	ADD	A0,A1		     ;ADD TO OFFSET
	MMFM	SP,A0
	RETS

**************************************************************************
*									 *
*	   PLOT_HELP							 *
*									 *
*	   THIS ROUTINE PLOTS (OR CLEARS) THE HELP AREA 		 *
*	   FOR THE CURRENT ENTRY.					 *
*									 *
**************************************************************************
PLOT_HELP:
	MOVE	*A13(MEN_CUR),A0,W	  ;GET CURRENT ENTRY
	CALLR	PM_ENTRY	  ;A1 POINTS AT GROUP
	MOVE	*A1(MENU_HELP),A8,L	  ;GET HELP TABLE
	CMPI	NO_HELP,A8		  ;NOT A "HELP" SITUATION?
	JRZ	NO_HELP_FOR_THIS_ONE
	CMPI	ADJ_HELP,A8		  ;ADJUSTMENT HELP REQUESTED?
	JAEQ	DO_ADJH 		  ;THEN DO IT IN ADJ MODULE!
;	 CMPI	 SND_HELP,A8		   ;ARE WE IN SOUND TEST?
;	 JREQ	 DO_SHELP
;	 CMPI	 SND_PLAY,A8
;	 JREQ	 DO_SPLAY
	CALLR	DO_HELP_MENU
NO_HELP_FOR_THIS_ONE:
	 RETS

**************************************************************************
*									 *
*	   DO_SHELP							 *
*									 *
*	   THIS IS CALLED FOR EACH NON PLAYING ENTRY IN THE SOUND	 *
*	   TABLE MENU.	IT CAUSES THE SOUND BOARD TO BE SHUT		 *
*	   UP AND THE BOTTOM LINE (WHERE TITLES APPEAR) 		 *
*	   TO BE ERASED.						 *
*									 *
**************************************************************************
;DO_SHELP:	
;;	MOVE	@SND_MADE,A0,W	;DID SOMEONE MAKE A SOUND?
;;	  JRZ	  DO_SH1	  ;NOPE
;;	  CLR	  A0
;	 MOVE	 A0,@SND_MADE,W  ;CLEAR THIS AND RESET THE BOARD!
;	 MOVE	 A0,@SCODE,W
;	 MOVE	 A0,@DCODE,W
;	 CALLA	 QSNDRST		;kill any sounds in progress
;DO_SH1:
;	CALLR	BLNKSNAM	;BLANK OUT ANY WRITING!
;	 RETS
;*
;*	 A0 CONTAINS 3 FOR SYNTHESIZER...4 FOR DIGITIZER...
;*	 IF CORRESPONDING "CODE" BYTE IS NON ZERO, THEN DISPLAY
;*	 THE TEXTLINE THAT CORRESPONDS.  ELSE BLANK OUT THE
;*	 AREA.
;*
;DO_SPLAY:
;	CALLR	BLNKSNAM	;BLANK OUT LAST MESSAGE
;	 CMPI	 3,A0		 ;SYNTHESIZER?
;	 JRZ	 CK_SYNT	 ;YEP.
;*
;*	 DIGITIZER.
;*
;	 MOVE	 @SCODE,A1,W	 ;HOLD INFO IF SYNTH WAS RUNNING
;	 CLR	 A0
;	 MOVE	 A0,@SCODE,W	 ;CLEAR OUT SYNTH CODE
;	 MOVE	 @DCODE,A0	 ;ANY CODE
;	 JRZ	 DO_SPQX	 ;NOTHING HERE.....SHUT UP SOUND SYS.
;
;	 MOVI	 DTABLE,A1	 ;BASE OF POINTER TABLE FOR DIGITIZER
;	 JRUC	 DO_SP1 	 ;PRINT THE STRING.
;
;
;CK_SYNT:
;	MOVE	@DCODE,A1,W	;HOLD INFO IF DIGITIZER WAS RUNNING
;	 CLR	 A0
;	 MOVE	 A0,@DCODE,W	 ;CLEAR OUT DIG CODE
;	 MOVE	 @SCODE,A0	 ;ANY CODE
;	 JRZ	 DO_SPQX	  ;NOTHING HERE.
;
;	 MOVI	 STABLE,A1	 ;BASE OF POINTER TABLE FOR DIGITIZER
;
;DO_SP1:
;	CALLR	MEN_NUMS			   ;A4 = LEFT X  A5 = RIGHT X
;	 ADDI	 10000H*SND_MESS_Y,A4		    ;UPPER LEFT Y
;	 ADDI	 10000H*(SND_MESS_Y+SND_BOX_H),A5   ;UPPER LEFT X
;	 MOVI	 ROBO_WHITE,A9
;	 CALLR	 STD_BORD	
;
;	 DEC	 A0			   ;INDEX FROM 1.
;	 SLL	 5,A0
;	 ADD	 A0,A1
;	 MOVE	 *A1,A2,L		   ;NOW WE HAVE THE MESSAGE
;
;	 MOVI	 SND_INST,A8
;	 JSRP	 L_MESS 		   ;PUT INSTRUCTION OUT.
;
;	 MOVI	 SND_SETUP,A8
;	 CALLA	 LM_SETUP
;
;	 MOVE	 A2,A8			
;	 JSRP	 LM_FINIS		   ;DO THE DEED
;	 RETS				   ;AND RETURN
;
;DO_SPQX:
;	MOVE	A1,A1			  ;OUR SELECTION ISN'T RUNNING...WAS OTHER?
;	 JRZ	 DO_SPX 		   ;NOPE
;	 CALLA	 QSNDRST		   ;KILL SOUNDS IN PROGRESS
;	 CLR	 A0
;	 MOVE	 A0,@SND_MADE,W 	   ;NO RESET NECESSARY NOW
;DO_SPX:
;	RETS
;
;**************************************************************************
;*									  *
;*	    BLNKSNAM							  *
;*									  *
;*	    CALLED TO BLANK OUT THE SOUND CODE NAME DURING		  *
;*	    SOUND TEST. 						  *
;*									  *
;**************************************************************************
;*
;*	  A3 = POINTER
;*	  A4 = SIZE
;*
;BLNKSNAM:
;	 MOVI	 (SND_MESS_Y*10000H)+20H,A3
;	 MOVI	 (SND_BOX_H*10000H)+1E0H,A4
;	 JAUC	 BLNKAREA		   ;ITS BLANK!
;
**************************************************************************
*									 *
*	   GET_ENTRY_Y							 *
*									 *
*	   THIS RETURNS THE Y POSITIONS FOR THE ENTRY SPECIFIED 	 *
*	   IN A0.							 *
*									 *
*	   A5 = Y VALUE IN UNITS.					 *
*									 *
**************************************************************************
GET_ENTRY_Y:
	MMTM	SP,A0,A1
	MOVE	*A13(MEN_ULY),A5,W
	MOVE	*A13(MEN_DY),A1,W
	DEC	A0
	MPYU	A0,A1		     ;A1 HAS OFFSET PER ENTRY
	ADD	A1,A5
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*									 *
*	   MENU_BORDER							 *
*									 *
*	   THIS IS CALLED TO PUT A BORDER AROUND THE MENU.		 *
*									 *
*	   A8 = MENU STRUCTURE						 *
*	   A9 = 1st item to activate as current 			 *
*									 *
*	   BORDER IS DONE IN MENU TEXT COLOR				 *
*									 *
*	   THIS ASSUMES MENU IS IN THE CENTERING FORMAT 		 *
*									 *
**************************************************************************
*
*	 1ST WE NEED TO FIND UPPER LEFT.
*
*
*	 X = MENU_X - (BAR_WIDTH/2) - 2       (LESS BORDER WIDTH)
*	 Y = MENU_Y - BDY		      (LESS BORDER HEIGHT)
*
*	 LOWER RIGHT :
*
*	 X = MENU_X + (BAR_WIDTH/2) - 2       (PLUS BORDER WIDTH)
*	 Y = MENU_Y + (MENU_ENTRIES-1) * DY)) - BDY + BAR_HITE
*
*
MENU_BORDER:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
	CALLR	STUFF_MENU_PROCESS   ;MOVE DATA INTO PDATA AREA
*
*	FIRST COMPUTE UPPER LEFT
*
	CALLR	MENU_UL_A4_A5		  ;GET UPPER LEFT COORDINATES
	SLL	16,A5
	ADD	A5,A4			  ;A4 POINTS TO UPPER LEFT.
*
*	FORM LOWER RIGHT
*
	CALLR	MENU_LR_A6_A5
	SLL	16,A5			  ;SHIFT A5 DOWN
	ADD	A6,A5			  ;A5 POINTS AT LOWER RIGHT

	MOVE	*A13(MEN_COLR),A9,W	  ;GET MENU TEXT COLOR
	CALLR	STD_BORD

	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
	RETS

**************************************************************************
*									 *
*	   MCSETUP							 *
*									 *
*	   RETURN:							 *
*		   A0 = CENTER OF MENU					 *
*		   A1 = 1/2 BAR WIDTH					 *
*		   A2 = Y FOR FIRST LINE OF TEXT OF MENU		 *
*		   A3 = DELTA Y (NEGATIVE TO GET FROM TEXT TO BAR.	 *
*									 *
**************************************************************************
MCSETUP:
	MOVE	*A13(MEN_ULX),A0,W	  ;UPPER LEFT X (ACTUALLY CENTER)
	MOVE	*A13(MEN_BWID),A1,W	  ;BAR_WIDTH
	SRL	1,A1			  ;ALL CALCS USE BAR_WIDTH/2
	MOVE	*A13(MEN_ULY),A2,W	  ;UPPER LEFT Y
	MOVE	*A13(MEN_BDY),A3,W	  ;DELTA Y (NEGATIVE)
	RETS


**************************************************************************
*									 *
*	   MENU_UL_A4_A5						 *
*									 *
*	   RETURN WINDOW UPPER LEFT CORNER				 *
*									 *
*	   A4 = X							 *
*	   A5 = Y							 *
*									 *
**************************************************************************
MENU_UL_A4_A5:
	MMTM	SP,A0,A1,A2,A3
	CALLR	MCSETUP 		  ;STUFF THE REGGIES
	MOVE	A0,A4			  ;FORM ULX
	SUB	A1,A4
	SUBI	C_KLUDGE,A4	     ;A4 HAS UPPER LEFT X

	MOVE	A2,A5
	ADD	A3,A5			  ;A5 HAS UPPER LEFT Y

	SUBI	MB_XWID+GAP,A4		  ;NOW WE POINT AT UPPER LEFT FOR FRAME
	SUBI	MB_YWID+GAP,A5
	MMFM	SP,A0,A1,A2,A3
	RETS

**************************************************************************
*									 *
*	   MENU_LR_A6_A5						 *
*									 *
*	   RETURN WINDOW LOWER RIGHT CORNER				 *
*									 *
*	   A6 = X							 *
*	   A5 = Y							 *
*									 *
**************************************************************************
MENU_LR_A6_A5:
	MMTM	SP,A0,A1,A2,A3
	CALLR	MCSETUP 		  ;STUFF THE REGGIES

	MOVE	A0,A6			  ;LOWER RIGHT X
	ADD	A1,A6
	SUBI	C_KLUDGE,A6	     ;THIS IS THE X

	MOVE	*A13(MEN_ENTS),A0,W	  ;THIS IS LAST ENTRY
	CALLR	GET_ENTRY_Y		  ;A5 HAS THE Y FOR THE LAST ENTRY
	ADD	A3,A5			  ;A5 NOW HAS TOP OF LAST BOX
	MOVE	*A13(MEN_BAR),A7,W	  ;HEIGHT OF BAR
	ADD	A7,A5			  ;A5 NOW HAS LOWER RIGHT Y

	ADDI	MB_YWID+GAP,A5
	ADDI	MB_XWID+GAP,A6		  ;THIS IS END OF BORDER
	MMFM	SP,A0,A1,A2,A3
	RETS


**************************************************************************
*									 *
*	   F_TITLE							 *
*									 *
*	   THIS IS CALLED TO FRAME A TITLE IN THE SAME WIDTH		 *
*	   AS THE MAIN TITLE.						 *
*									 *
*	   A0 = Y LEVEL OF 15 POINT TEXT				 *
*	   A9 = COLOR							 *
*									 *
**************************************************************************
F_TITLE:
	MMTM	SP,A4,A5,A0
	MOVE	A0,A4		;COPY Y
	SUBI	12,A4
	SLL	16,A4
	ADDI	TIT_ULX,A4	;UPPER LEFT SET

	MOVE	A0,A5		;LOWER RIGHT
	ADDI	27,A5
	SLL	16,A5
	ADDI	TIT_LRX,A5	;LOWER RIGHT SET

	CALLR	STD_BORD
	MMFM	SP,A4,A5,A0
	RETS

FIRST_BORDER_COLOR	 EQU	 0E0E0H
LAST_BORDER_COLOR	 EQU	 0EFEFH
**************************************************************************
*									 *
*	   G_BORDER							 *
*									 *
*	   THIS IS CALLED TO DO A "HSTD TABLE" TYPE CYCLING		 *
*	   BORDER.  THIS ROUTINE GETS:					 *
*									 *
*	   A4 = UPPER LEFT Y,X						 *
*	   A5 = LOWER RIGHT Y,X 					 *
*	   A6 = NUMBER OF SLICES GOING IN.				 *
*									 *
**************************************************************************
G_BORDER:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6
	MOVI	10001H,A0		  ;1 BY 1 DIMENSION

	MOVI	LAST_BORDER_COLOR,A9	  ;USE LAST ONE 1ST
NEXT_RING:
	CALLR	DOBORDER		  ;DO THIS RING

	MOVI	10001H,A1		   ;THIS IS 1 UNIT IN X AND Y
	ADDXY	A1,A4
	SUBXY	A1,A5

	SUBI	101H,A9
	CMPI	FIRST_BORDER_COLOR,A9
	JRHS	COLOK
	MOVI	LAST_BORDER_COLOR,A9

COLOK:	
	DSJS	A6,NEXT_RING
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6
	RETS

**************************************************************************
*									 *
*	   DOBORDER							 *
*									 *
*	   THIS IS CALLED TO DRAW A BORDER FRAME.			 *
*									 *
*	   A4 = UPPER LEFT Y,X						 *
*	   A5 = LOWER RIGHT Y,X 					 *
*	   A0 = Y,X WIDTH OF BORDER					 *
*	   A9 = COLOR OF BORDER.					 *
*									 *
*	   THIS ROUTINE *** CLEARS OUT ALL AREA INSIDE THE BORDER***	 *
*	   AS A FUNCTION OF ITS OPERATION.				 *
*									 *
*	   THE BORDER IS DONE IN THE "ROBO" PALETTE			*
*									 *
*	   IT IS ASSUMED THAT THE DISPLAY SYSTEM IS RUNNING!		 *
*									 *
**************************************************************************
*
* A1 = <COLOR><PALETTE>
* A3 = DAG OF AREA [YPOS,XPOS]						
* A4 = [Y,X] SIZE OF AREA						
*
DOBORDER:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
	MOVE	A9,A1			  ;GET COLOR
	SLL	16,A1			  ;COLOR ON TOP..PALETTE 0
*
*	NOW WE NEED TO MAKE 4 BARS!
*
	MOVE	A0,A2			  ;SEPARATE DELTA
	ANDI	SX_MASK,A0
	ANDI	SY_MASK,A2

	MOVE	A4,A6			  ;UPPER LEFTS HERE
	MOVE	A4,A7

	MOVE	A5,A8			  ;LOWER RIGHTS HERE
	MOVE	A5,A9

	ANDI	SX_MASK,A6		   ;LEFT X
	ANDI	SX_MASK,A8		   ;RIGHT X

	ANDI	SY_MASK,A7		   ;TOP Y
	ANDI	SY_MASK,A9		   ;BOTTOM Y

*
*	FIRST BAR GOES FROM ORIGINAL UL XY TO RIGHT X
*	AND TOP Y+DELTA Y
*
*	A3 IS ORIGINAL A4 PASSED.
*	FORM DESTINATION IN A4
*
	MOVE	A4,A3

	MOVX	A8,A4
	MOVY	A7,A4
	ADDXY	A2,A4			  ;ADD THE DELTA

	CALLR	DO_A_LINE		  ;DO THIS LINE
*
*	GOING AROUND CLOCKWISE.....THIS ONE STARTS AT RIGHT X-DELTA
*	AND TOP Y
*
	MOVX	A8,A3
	SUBXY	A0,A3
	MOVY	A7,A3
*
*	THIS IS THE NATURAL LOWER RIGHT CORNER
*
	MOVX	A8,A4
	MOVY	A9,A4

	CALLR	DO_A_LINE
*
*	NOW FOR BOTTOM LINE.....A4 IS STILL SET!
*
	MOVX	A6,A3
	MOVY	A9,A3
	SUBXY	A2,A3

	CALLR	DO_A_LINE
*
*	LEFT WALL....FROM UPPER LEFT
*
	MOVX	A6,A3
	MOVY	A7,A3

	MOVX	A6,A4
	ADDXY	A0,A4
	MOVY	A9,A4

	CALLR	DO_A_LINE

	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9
	RETS

DO_A_LINE:
	MMTM	SP,A4
	SUBXY	A3,A4		;FORM DISTANCE
	CALLA	FILLAREA	;AND DO THE FILL
	MMFM	SP,A4
	RETS

STD_BORD:
	MMTM	SP,A0
	MOVI	BORDER_SIZE,A0
	CALLA	DOBORDER
	MMFM	SP,A0
	RETS
**************************************************************************
*									 *
*	   DO_HELP_MENU 						 *
*									 *
*	   THIS IS CALLED TO DISPLAY A HELP MENU FOR THE CURRENT	 *
*	   MENU ENTRY.							 *
*									 *
*	   A HELP MENU IS DEFINED AS FOLLOWS:				 *
*									 *
*	   HM_JUST	   WORD    0=CENTER   1=LEFT			 *
*	   HM_COLOR	   WORD    COLOR OF MENU			 *
*	   HM_ENTS	   WORD    NUMBER OF LINES IN MENU		 *
*			   LONG    LONG WORD POINTERS FOR EACH LINE!	 *
*									 *
*	   THE PROCESS AREA IS FILLED WITH THE CURRENT MENU		 *
*	   PARAMETERS.							 *
*									 *
*	   A8 = POINTER TO HELP MENU STRUCTURE ABOVE			 *
*									 *
**************************************************************************
DO_HELP_MENU:
	CALLR	BLNKHELP

	MOVE	A8,A8		     ;CHECK IF HELP MENU EXISTS.
	JRZ	DHMX		     ;NOPE JUST CLEARING WAS OUR JOB.

	MOVE	*A13(MEN_CUR),A0,W   ;THIS IS CURRENT ENTRY
	MOVE	A0,A11		     ;PASS ENTRY NUMBER IN A11
	CALLR	GET_ENTRY_Y	     ;A5 HAS THE Y FOR THE CURRENT ENTRY
*
*	NOW WE NEED TO MOVE TO MAKE TOP ENTRY BOX LINE UP.
*
	MOVE	*A13(MEN_BDY),A10,W  ;THIS IS NEGATIVE TO GIVE US BOX TOP
	ADD	A5,A10		     ;NOW WE HAVE BOX TOP

	MOVE	*A13(MEN_BAR),A5,W   ;GET BAR HEIGHT
	SRL	1,A5		     ;FIND CENTER OF BAR
	ADD	A5,A10		     ;NOW WE'RE AT BAR CENTER.

	MOVI	H_SLAVE,A7	  ;FORK OFF SO IT CAN USE PDATA!
	CALLA	P_FORK		     ;START UP ANOTHER W/ SAME ID TO FLASH!
DHMX	RETS

**************************************************************************
*									 *
*	   BLNKHELP							 *
*									 *
*	   THIS IS CALLED TO BLANK OUT THE HELP AREA.  IT IS		 *
*	   USED BY BOTH THE "NORMAL" HELP PLOTTER AND IS		 *
*	   CALLED BY THE ADJUSTMENT HELP PROGRAM.			 *
*									 *
*	   THIS RETURNS THE LEFT X FOR THE HELP MENU IN A9		 *
*									 *
**************************************************************************
BLNKHELP:
	MMTM	SP,A3,A4,A5,A6
	CALLR	MENU_LR_A6_A5	     ;GET RIGHT X OF MAIN MENU IN A6
	MOVE	A6,A9		     ;PASS TO HELP MENU SLAVE
*
*	NOW BLANK OUT THE "HELP" REGION
*
	MOVE	A6,A3		     ;UPPER LEFT X OF REGION TO BLANK OUT
	ADDI	INST_ULY*10000H,A3   ;THIS IS UPPER LEFT OF BLOCK

	MOVI	TIT_LRX+(10000H*400),A4 ;COORDINATE OF LOWER RIGHT OF HELP AREA
	SUBXY	A3,A4			;THIS IS SIZE OF REGION TO BLANK
	CALLA	BLNKAREA		;BLANK OUT THE HELP AREA
	ADDI	BOX_XGAP,A9		;RETURN X FOR HELP MENUS
	MMFM	SP,A3,A4,A5,A6
	RETS

**************************************************************************
*									 *
*	   H_SLAVE							 *
*									 *
*	   THIS IS A PROCESS CREATED TO PLOT THE HELP BOX.		 *
*	   IT DOES ITS PLOTTING THEN DIES.   THIS ALLOWS IT		 *
*	   TO USE THE PDATA AREA WITHOUT DISTURBING THE CALLER. 	 *
*									 *
*	   A8 = POINTER TO HELP BOX STRUCTURE				 *
*	   A9 = LEFT MARGIN FOR THE HELP BOX.				 *
*	   A10 = Y OF CENTER OF BOX ...HIGH HALF IS ZERO FOR Y CENTING	 *
*		 IF HIGH HALF IS NON-ZERO, THEN THIS IS TOP OF BOX	 *
*									 *
**************************************************************************
HM_JUST 	 EQU	 0
HM_COLOR	 EQU	 HM_JUST+WORD_SIZE
HM_ENTS 	 EQU	 HM_COLOR+WORD_SIZE
HM_DATA 	 EQU	 HM_ENTS+WORD_SIZE	;ENTRY POINTERS

HS_ROUT 	 EQU	 PDATA		   ;LONG-TEXT ROUTINE
HS_X		 EQU	 HS_ROUT+LONG_SIZE ;WORD-X FOR TEXT ROUTINE
HS_Y		 EQU	 HS_X+WORD_SIZE    ;WORD-CURRENT Y
HS_ENTS 	 EQU	 HS_Y+WORD_SIZE    ;WORD-ENTRIES LEFT TO DO
HS_COLOR	 EQU	 HS_ENTS+WORD_SIZE ;WORD-COLOR OF MENU
HS_PTR		 EQU	 HS_COLOR+WORD_SIZE ;LONG-CURRENT TEXT POINTER

H_SLAVE:
*
*	A9 HAS RIGHT X OF MENU
*
	MOVE	A9,A1			  ;PUT THIS X VALUE IN A1

	MOVE	*A8(HM_JUST),A0,W	  ;0 = CENTER  1=LEFT
	JRZ	HS_CENT 		  ;CENTER....SETUP X ACCORDINGLY
*
*	LEFT JUSTIFY....STORE ROUTINE
*
	MOVI	STRLNRM,A0		  ;LEFT JUSTIFY ROUTIN
*
*	NOW FORM X AS SOME MARGIN FROM WINDOW....
*
	ADDI	MB_XWID+HELP_X_MARGIN,A1  ;ADD MARGIN TO FORM X FOR TEXT
	JRUC	CENTER_JOIN		  ;CONTINUE

HS_CENT:
	MOVI	STRCNRM,A0		  ;USE CENTERING ROUTINE
*
*	A1 HAS LEFT X OF HELP BOX...FIND RIGHT X
*
	ADDI	TIT_LRX,A1
	SRL	1,A1			  ;THIS IS CENTER X

CENTER_JOIN:
	MOVE	A1,*A13(HS_X),W 	  ;STORE X
	MOVE	A0,*A13(HS_ROUT),L	  ;STORE ROUTINE

	MOVE	*A8(HM_ENTS),A1,W	  ;GET NUMBER OF ENTRIES
	MOVE	A1,*A13(HS_ENTS),W	  ;COUNT IT DOWN IN P-AREA

	MOVE	*A8(HM_COLOR),A0,W	  ;GET COLOR
	MOVE	A0,*A13(HS_COLOR),W	  ;STASH IT

	ADDI	HM_DATA,A8		  ;POINT AT 1ST ENTRY
	MOVE	A8,*A13(HS_PTR),L	  ;NOW WE'RE READY.
*
*	ALL PDATA AREA SET.....NOW WE NEED TO DRAW THE BORDER
*
*	  FOR DOBORDER
*
*	  A4 = UPPER LEFT Y,X						
*	  A5 = LOWER RIGHT Y,X					
*	  A0 = Y,X WIDTH OF BORDER				
*	  A9 = COLOR OF BORDER. 					
*
*	LOWER RIGHT X IS SUCH THAT IT LINES UP WITH TITLE BOX.
*	THE Y IS A BIT TRICKIER......NUMBER OF ENTRIES IS
*	SITTING IN A1
*
	MOVI	HELP_DY,A5		  ;DISTANCE PER ENTRY
	MPYU	A1,A5			  ;DISTANCE FOR ALL ENTRIES
	ADDI	HELP_Y_MARGIN+(MB_YWID*2)+HELP_YLO_MARGIN,A5
*
*	A5 NOW CONTAINS FULL HEIGHT OF BOX
*
*	NOW SEE IF WE'RE CENTERING ON A10 OR IF A10 IS THE TOP.
*
	CALLR	TOP_IN_A10
*
*	NOW FORM UPPER LEFT IN A4
*
	MOVE	A10,A4			  ;MOVE Y OVER
	SLL	16,A4			  ;MAKE ROOM FOR X
	ADD	A9,A4			  ;PUT IN THE X...THIS IS UPPER LEFT!

	ADD	A10,A5			  ;ADD BASE TO OFFSET
	SLL	16,A5			  ;PUT IN Y POSITION
	ADDI	TIT_LRX,A5		  ;ADD IN THE X FOR THE CORNER
*
*	NOW ADJUST FROM TOP OF BOX TO POSITION OF
*	1ST ENTRY.
*
	ADDI	MB_YWID+HELP_Y_MARGIN,A10  ;Y OF 1ST ENTRY
	MOVE	A10,*A13(HS_Y),W	   ;PUT AWAY

	MOVE	*A13(HS_COLOR),A9,W	  ;GET THE COLOR FOR DOBORDER

	CALLR	STD_BORD
*
*	NOW WE NEED TO WALK THROUGH AND PLOT THE HELP
*	MENU ENTRIES.
*
*	A0 = SLEEP
*	A1 = ROUTINE
*	A6 = COLOR
*	A8 = POINTER
*	A9 = ADDRESS
*	A10 = SPACING
*	A11 = FONT
*	A14 = FLAGS
*
NEXT_HELP:
	MOVE	*A13(HS_PTR),A2,L	  ;GET OUR CURRENT POINTER
	MOVE	*A2+,A8,L		  ;GET THE CURRENT MESSAGE POINTER
	MOVE	A2,*A13(HS_PTR),L	  ;AND PUT POINTER BACK

	CLR	A0
	MOVE	*A13(HS_ROUT),A1,L	  ;ROUTINE IN A1
	MOVE	*A13(HS_COLOR),A6,W	  ;STUFF COLOR

	MOVE	*A13(HS_Y),A9,W 	  ;GET Y
	SLL	16,A9			  ;SHIFT INTO PLACE
	MOVE	*A13(HS_X),A10,W
	ADD	A10,A9			  ;A9 IS NOW POINTING AT SCREEN

	MOVI	SPACING07,A10		  ;SPACING
	MOVI	RD7FONT,A11		  ;FONT IS BABY FONT
	JSRP	LM_FINIS		  ;PRINT IT OUT!

	MOVE	*A13(HS_Y),A9,W 	  ;GET THE Y
	ADDI	HELP_DY,A9		  ;KICK IT
	MOVE	A9,*A13(HS_Y),W 	  ;PUT IT BACK

	MOVE	*A13(HS_ENTS),A0,W	  ;ENTRY COUNT
	DEC	A0
	MOVE	A0,*A13(HS_ENTS),W	  ;PUT IT BACK
	JRNZ	NEXT_HELP

	JAUC	SUCIDE			  ;OUR WORK IS DONE!

**************************************************************************
*									 *
*	   TOP_IN_A10							 *
*									 *
*	   THIS IS CALLED BY H_SLAVE TO GET THE UPPER LEFT		 *
*	   CORNER OF THE BOX IN A10.  A10 HAS THE PASSED PARAMETER.	 *
*	   A5 HAS THE HEIGHT OF THE BOX.  IF THE TOP HALF OF A10	 *
*	   IS ZERO, THEN THEN WE WANT THE BOX CENTER AT THE		 *
*	   A10 LEVEL.  IF THE TOP HALF OF A10 IS NON-ZERO THEN		 *
*	   A10 WAS PASSED AS THE TOP.					 *
*									 *
*	   RETURN A10 AS THE Y FOR THE TOP OF THE HELP BOX.		 *
*									 *
**************************************************************************
TOP_IN_A10:
	MMTM	SP,A5
	CMPI	0FFFFH,A10		  ;IS THE TOP HALF ZERO?
	JRHI	TOP_IS_TOP		  ;TOP IS SET..RETURN
	SRL	1,A5			  ;TOP OF BOX IS HALF UP FROM MAIN MENU BAR CENTER
	SUB	A5,A10			  ;NOW A10 HAS Y BASE OF BOX
TOP_IS_TOP:
	MMFM	SP,A5
	RETS

**************************************************************************
*									 *
*	   AREUSURE							 *
*									 *
*	   THIS IS CALLED TO GET A CONFIRMATION FROM THE USER.		 *
*	   A8 = PROMPT...THIS WILL APPEAR ABOVE THE "ARE YOU SURE"	 *
*	   A9 = ROUTINE TO JSRP TO DO THE DESIRED ACTION		 *
*	   A10 = MESSAGE TO DISPLAY CONFIRMING COMPLETION		 *
*									 *
*	   RETURN A0=0 MEANS YES WAS CHOSEN.				 *
*		  A0 .NE. 0 MEANS NO					 *
*									 *
**************************************************************************
AREUSURE:
	CALLA	CLR_SCRN	     ;BLANK IT ALL OUT!
	MOVE	A9,*A13(PDATA),L     ;SAVE ROUTINE
	MOVE	A10,-*A12,L	     ;AND CONFIRM MESSAGE

	CALLR	SURE_BOX

	MOVE	A8,A2		     ;PUT MESSAGE TEXT IN SAFE PLACE
	MOVI	MESS_SURE,A8	     ;SETUP FOR TITLE
	CALLA	LM_SETUP	     ;STUFF REGGIES
	MOVE	A2,A8		     ;GET STRING IN THERE
	JSRP	LM_FINIS	     ;AND PRINT IT

	MOVI	M_SURE,A8	     ;NOW THE "ARE YOU SURE" PART
	JSRP	L_MESS		     ;PUT IT UP.

	MOVI	MEN_YN,A8	     ;PUT UP THE "YES/NO" SELECTOR.
	MOVI	2,A9		     ;CURSOR ON 2ND ENTRY (NO)

	JSRP	B_MENU		     ;AND GET A RESPONSE.
	CMPI	1,A8		     ;WAS IT YES?
	JRNZ	SURE_X		     ;NOPE....GET OUT

	CALLA	CLR_SCRN	     ;CLEAR THE SCREEN FIRST, SO ROUTINE CAN PLOT!

	MOVE	*A13(PDATA),A0,L     ;GET THE ROUTINE TO CALL
	MOVI	SURE_RET,A7
	MOVE	A7,-*A12,L	     ;PUSH RETURN ADDRESS
	JUMP	A0		     ;AND "JSRP" THE ROUTINE

SURE_RET:
	CALLR	SURE_BOX	     ;BOX IT!
	MOVE	*A12+,A8,L
	JSRP	SUR_MESS	     ;PRINT THE MESSAGE

	JSRP	ANY_BUT 	     ;NOW RETRIEVE ANY BUTTON THEN RETURN

	CLR	A0		     ;RETURN SUCCESS
	RETP

SURE_X: 
	ADDI	LONG_SIZE,A12	     ;POP MESSAGE
	MOVI	2,A0		     ;RETURN FAILURE
	RETP

**************************************************************************
*									 *
*	   SUR_MESS							 *
*									 *
*	   THIS PRINTS MESSAGE IN A8 IN THE ARE U SURE BOX		 *
*	   CONFIRMATION SPOT.						 *
*									 *
**************************************************************************
SUR_MESS:
	MOVE	A8,-*A12,L
	MOVI	MESS_CONFIRM,A8
	CALLA	LM_SETUP	     ;GET CONFIRMATION DATA READY.
	MOVE	*A12+,A8,L
	JSRP	LM_FINIS	     ;PRINT OUR PART
	RETP

SURE_BOX:
	MOVI	COLOR_YELLOW,A9
	MOVI	003D0025H,A4
	MOVI	00F6016AH,A5
	jruc	STD_BORD	    ;BORDER-IZE THE WHOLE THING.

CENT_BOX:
	MOVI	ROBO_RED,A9
CBOX_COL:
	MOVI	00450025H,A4
	MOVI	00B4016AH,A5
	jruc	STD_BORD	    ;BORDER-IZE THE WHOLE THING.

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
*****************************	 MESSAGES    *********************************
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

INSTR_Y  EQU	 INST_ULY+5
INSTR_2Y EQU	 INSTR_Y+10

MM_INST1
	MESS_MAC  RD7FONT,SPACING07,MENU_X,INSTR_Y,COLOR_BPR,STRCNRM,0
	.byte   "SELECT WITH ANY STICK"
	.BYTE	 0
	.EVEN

MM_INST2
	MESS_MAC  RD7FONT,SPACING07,MENU_X,INSTR_2Y,COLOR_BPR,STRCNRM,0
	.byte   "ACTIVATE WITH ANY BUTTON"
	.BYTE	 0
	.EVEN

MESS_DOOR
	MESS_MAC  RD7FONT,SPACING20,200,128,ROBO_RED,STRCNRM,0
	.byte  "INVALID GAME SETTINGS"
	.BYTE	 0,1		      ;0 = END OF STRING...1 = MORE MESSAGES!
	.EVEN
;MESS_OPEN
;	MESS_MAC  RD7FONT,SPACING20,200,160,ROBO_WHITE,STRCNRM,0
;	.byte  "OPEN COIN DOOR TO"
;	.BYTE   0,1		       ;0 = END OF STRING...1 = MORE MESSAGES!
;	.EVEN
;MESS_OPEN_2
;	MESS_MAC  RD7FONT,SPACING20,200,179,ROBO_WHITE,STRCNRM,0
;	.byte  "RESTORE FACTORY SETTINGS."
;	.BYTE    0,0
;	.EVEN

MESS_FAIL
	MESS_MAC  RD7FONT,SPACING20,200,112,ROBO_RED,STRCNRM,0
	.byte  "INVALID GAME SETTINGS"
	.BYTE	 0,1		      ;0 = END OF STRING...1 = MORE MESSAGES!
	.EVEN
	MESS_MAC  RD7FONT,SPACING20,200,144,ROBO_WHITE,STRCNRM,0
	.byte  "ATTEMPT TO RESTORE"
	.BYTE	 0,1		      ;0 = END OF STRING...1 = MORE MESSAGES!
	.EVEN
	MESS_MAC  RD7FONT,SPACING20,200,164,ROBO_WHITE,STRCNRM,0
	.byte  "FACTORY SETTINGS HAS FAILED."
	.BYTE	  0,0
	.EVEN

MESS_BITCHIN
	.byte	"ADJUSTMENTS OK",0
	.even

MESS_TITLE
	MESS_MAC  RD15FONT,SPACING20,TM_X,TM_Y,ROBO_GREEN,STRCNRM,0

RV_Y	EQU	 TM_Y+18

MESS_REV
	MESS_MAC  RD7FONT,SPACING20,TM_X,RV_Y,ROBO_YELLOW,STRCNRM,0
*
*	THIS IS SETUP FOR THE QUESTION BEING ASKED
*	BY "ARE YOU SURE"
*
MESS_SURE
	MESS_MAC  RD15FONT,SPACING20,200,102,ROBO_LF,STRCNRM,0
*
*	THIS IS THE "ARE YOU SURE" PART.
*
M_SURE
	MESS_MAC  RD15FONT,SPACING20,200,128,ROBO_YELLOW,STRCNRM,0
	.byte   "ARE YOU SURE?"
	.BYTE	    0,0
	.EVEN

MESS_CONFIRM
	 MESS_MAC  RD15FONT,SPACING20,200,115,COLOR_LF,STRCNRM,0


**************************************************************************
*									    			*
*	OPERATOR MESSAGE ENTRY						 			*
*									    			*
**************************************************************************
OP_LINE_CHAR	equ	PDATA
OP_LINE_LINE	equ	PDATA+WORD_SIZE
OP_LETS		equ	OP_LINE_LINE+WORD_SIZE
OP_STIME 	equ	OP_LETS+(30 * BYTE_SIZE)
OP_SVAL		equ	OP_STIME+WORD_SIZE

LET_DIST_X	equ	25
LET_DIST_Y	equ	24
LET_BOX_CX	equ	14
LET_BOX_CY	equ	2
LET_BOX_WX	equ	3
LET_BOX_WY	equ	1
LET_START_Y1	equ	163
LET_START_Y2	equ	LET_START_Y1+LET_DIST_Y
LET_START_Y3	equ	LET_START_Y2+LET_DIST_Y
LET_START_Y4	equ	LET_START_Y3+LET_DIST_Y
LET_INST1	equ	55
LET_START_X	equ	22
LET_LINE_MAX	equ	3
LET_CHAR_MAX	equ	14
LET_TEXT_GAP	equ	12
LET_TEXT1	equ	110
LET_TEXT2	equ	LET_TEXT1+LET_TEXT_GAP
LET_TEXT3	equ	LET_TEXT2+LET_TEXT_GAP
OP_MAX_CHARS	equ	CMESS_CHARS-1
FONT_T		.equ	inga16_asc_tbl


	.bss	BLINE	,16
	.bss	BCHAR	,16

 SUBR	opmsg_main

	.if	PRINTER
	movk	1,a0
	calla	PBADGUY
	.endif

	calla	CLR_SCRN
	movi	opmsg_s,a2
	movi	ROBO_YELLOW,a3
	JSRP	TOP_BOX			;KICK OUT TOP BOX

	movi	OMINST1,a8
	JSRP	print_multi

	SLEEPK	1

	clr	a8			;Do 4 rows of letters
	movk	30,a10
	callr	OPPLOTLINE

	movk	1,a8
	movk	30,a10
	callr	OPPLOTLINE

	movk	2,a8
	movk	30,a10
	callr	OPPLOTLINE

	movk	3,a8
	movk	30,a10
	callr	OPPLOTLINE

	clr	a0
	move	a0,@BLINE
	move	a0,@BCHAR

	clr	a8
	move	a8,*a13(OP_LINE_LINE)	;ON THE FIRST LINE

	callr	OM_STARTLINE		;INITIALIZE ALL THE FLAGS FOR IT

	clr	a10
	movk	1,a11
	callr	BOXCHAR			;BOX INITIAL ONE

	movk	1,a11
	callr	OMPLOTTEXT


	clr	a0
	move	a0,*a13(OP_SVAL)
	move	a0,*a13(OP_STIME)

DOLOOP					;>Loop for stick and things
	SLEEPK	1

	callr	om_getstick		;Check out the player board
	jrnz	do1			;switch closed?
	move	a0,*a13(OP_SVAL)	;Clear timer and direction
	move	a0,*a13(OP_STIME)
	jruc	DOLOOP
do1
	move	*a13(OP_SVAL),A1	;Get last direction
	ANDK	7,a1			;Mask off repeat bit
	cmp	a0,a1
	jrz	do2			;Still same thing?
	move	a0,*a13(OP_SVAL)
	clr	a1
	move	a1,*a13(OP_STIME)	;Clear the timer
	jruc	DODONE			;Process initial hit
do2
	MOVE	*A13(OP_SVAL),A1	;SNAG THE REPEAT BIT
	ANDI	80H,A1
	JRNZ	DO3			;BR = IN REPEAT MODE
	MOVE	*A13(OP_STIME),A0	;GET TIMER
	INC	A0
	MOVE	A0,*A13(OP_STIME)
	CMPI	15,A0
	btst	4,a0
	JRLO	DOLOOP			;GO BACK TO SLEEP
	CLR	A0
	MOVE	A0,*A13(OP_STIME)	;CLEAR OUT THE TIMER
	MOVE	*A13(OP_SVAL),A1
	MOVE	A1,A0
	ORI	80H,A1			;PUT UPPER BIT ON
	MOVE	A1,*A13(OP_SVAL)	;SET DIRECTION WITH REPEAT ON
	JRUC	DODONE
DO3
	MOVE	*A13(OP_STIME),A0	;GET TIMER
	INC	A0
	MOVE	A0,*A13(OP_STIME)
	CMPI	5,A0
	JRLO	DOLOOP			;GO BACK TO SLEEP
	CLR	A0
	MOVE	A0,*A13(OP_STIME)	;CLEAR OUT THE TIMER
	MOVE	*A13(OP_SVAL),A0
	ANDK	7,a0			;TURN OFF REPEAT BIT
DODONE
        move    *A13(OP_SVAL),a1	;Get current entry
	ANDK	7,a1
	move	@BLINE,a8
	move	@BCHAR,a10
	clr	a11
	callr	BOXCHAR			;UNHIGHLIGHT IT

	CMPI	1,A1			;CHECK UP
	JRNZ	DOC1
	DEC	A8
	JRUC	DOPROC
DOC1
	CMPI	2,A1
	JRNZ	DOC2
	INC	A8
	JRUC	DOPROC
DOC2
	CMPI	3,A1
	JRNZ	DOC3
	DEC	A10
	JRUC	DOPROC
DOC3
	CMPI	4,A1
	JRNZ	DOC4
	INC	A10
	JRUC	DOPROC
DOC4
	CMPI	5,A1			; DRAW BUTTON
	JRNZ	DOCCLR			; WOOF WOOF
	SOUND1	diag_select
	CALLR	OMADDCHAR		; ADD THE CHAR IN A8/A10
	CMPI	0FFH,A8			; CHECK TO SEE IF DONE WITH ALL
	JRZ	DOCEND
	MOVE	@BLINE,A8
	MOVE	@BCHAR,A10
	MOVK	1,A11
	CALLR	BOXCHAR			; TURN THE BOX BACK ON
	JRUC	DOLOOP
DOCCLR
	cmpi	6,a1			;Start button
	jrne	DOLOOP

	callr	opmsg_clr
;	clr	a7
;	move	a7,*a13(OP_LINE_LINE)
;	move	a7,*a13(OP_LETS),L
;	callr	OM_STORECMOS
;	movk	1,a7
;	move	a7,*a13(OP_LINE_LINE)
;	callr	OM_STORECMOS
;	movk	2,a7
;	move	a7,*a13(OP_LINE_LINE)
;	callr	OM_STORECMOS
;	callr	BLASTMESS

	jruc	DOCCLEAR
	
;cursor_snd4	.word	>f3f7,>8,>8083,0	;
;select_snd1	.word	>f3f7,>8,>8084,0	;select option sound
;
;	CHECK A8 ( BLINE ) AND A10 ( BCHAR ) FOR BOUNDARY STUFF
;
DOPROC
	.ref	diag_cursor
	SOUND1	diag_cursor
	move	a8,a8
	jrge	doc5
	clr	a8
doc5
	cmpi	LET_LINE_MAX,a8
	jrle	doc6
	movk	LET_LINE_MAX,a8
doc6
	move	a10,a10
	jrge	doc7
	movk	LET_CHAR_MAX,a10
doc7
	cmpi	LET_CHAR_MAX,a10
	jrle	doc8
	clr	a10
doc8
	move	a8,@BLINE
	move	a10,@BCHAR
	movk	1,a11
	callr	BOXCHAR
	jruc	DOLOOP


********************************
* HERE IS WHERE ONE COMES WHEN DONE ENTERING THE MESSAGE -- ALREADY
* STORED IN CMOS, TOO

DOCEND
	SLEEPK	2			;GET EVERYBODY CAUGHT UP
	CALLA	CLR_SCRN		;CLEAR THE SCREEN
	CALLR	SURE_BOX
	MOVI	MESS_SUCCESS,A8 	;THIS IS SUCCESS MESSAGE
#sm	JSRP	SUR_MESS		;PRINT THE MESSAGE
	jauc	ANY_BUT 		;NOW RETRIEVE ANY BUTTON THEN RETURN

DOCCLEAR
	SLEEPK	2
	CALLA	CLR_SCRN
	CALLR	SURE_BOX
	MOVI	MESS_CLEARED,A8
	jruc	#sm


MESS_SUCCESS
	.byte	"MESSAGE STORED",0
	.even

MESS_CLEARED
	.byte	"MESSAGE CLEARED",0
	.even

BLASTMESS:				;GUY ENTERED A WHOLE MESSAGE
;	CALLA	CMOSUNLOCK
	calla	ADJ_PAGE
	clr	a0
	movi	VALID_CUSTOM,a7
	calla	WC_WORD
        calla	F_ADC_S			;FIX UP THE CHECKSUM
;	calla	CMOSLOCK
	rets


#*******************************
* Clear operator message
* Trashes scratch, A2

 SUBR	opmsg_clr

	calla	ADJ_PAGE

	movi	CUSTOM_MESSAGE,a7
	movk	CMESS_LINES,a2
#lp	clr	a0
	calla	WC_BYTEI		;Write a null
	addi	CMESS_LINE_SIZE,a7
	dsj	a2,#lp

	calla   F_ADC_S			;Refresh checksum
	jruc	BLASTMESS



********************************
* Get joystick and buttons status
* >A0=Status (0-6)

om_getstick

	PUSH	a1
	move	@_switch_addr,a0,L
	move	*a0,a0,W
	move	@_coin_addr,a1,L
	move	*a1,a1,W
	sll	16,a1
	sll	16,a0
	srl	16,a0
	or	a1,a0
	not	a0
	move	a0,a1
	andi	0004007fh,a0		;P1 draw/start/stick
	andi	00207f00h,a1		;P2 draw/start/stick
	srl	8,a1
	or	a1,a0
	move	@_switch2_addr,a1,L
	move	*a1,a1,W
	not	a1
	andi	>7f,a1			;P3 draw/stick
	or	a1,a0

	btst	0,a0			;U
	jrz	og2
	movk	1,a0
	jruc	#x
og2
	btst	1,a0			;D
	jrz	og3
	movk	2,a0
	jruc	#x
og3
	btst	2,a0			;L
	jrz	og4
	movk	3,a0
	jruc	#x
og4
	btst	3,a0			;R
	jrz	og5
	movk	4,a0
	jruc	#x
og5
	movi	>70,a1
	and	a0,a1
	jrz	og6
	movk	5,a0
	jruc	#x
og6
	andi	0ffffff80h,a0		;Any other bits are start buttons
	jrz	og7
	movk	6,a0
	jruc	#x
og7
	clr	a0
#x
	PULL	a1
	move	a0,a0
	rets


;	PUSH	a1
;	move	@SWITCH,a0,L
;	not	a0
;	move	a0,a1
;	andi	0004007fh,a0		;P1 draw/start/stick
;	andi	00207f00h,a1		;P2 draw/start/stick
;	srl	8,a1
;	or	a1,a0
;	move	@SWITCH+32,a1
;	not	a1
;	andi	>7f,a1			;P3 draw/stick
;	or	a1,a0
;
;	btst	0,a0			;U
;	jrz	og2
;	movk	1,a0
;	jruc	#x
;og2
;	btst	1,a0			;D
;	jrz	og3
;	movk	2,a0
;	jruc	#x
;og3
;	btst	2,a0			;L
;	jrz	og4
;	movk	3,a0
;	jruc	#x
;og4
;	btst	3,a0			;R
;	jrz	og5
;	movk	4,a0
;	jruc	#x
;og5
;	movi	>70,a1
;	and	a0,a1
;	jrz	og6
;	movk	5,a0
;	jruc	#x
;og6
;	andi	0ffffff80h,a0		;Any other bits are start buttons
;	jrz	og7
;	movk	6,a0
;	jruc	#x
;og7
;	clr	a0
;#x
;	PULL	a1
;	move	a0,a0
;	rets


********************************
* SETUP THINGS FOR A NEW LINE OF TEXT

OM_STARTLINE

	PUSH	A0
	CLR	A0
	MOVE	A0,*A13(OP_LETS)
	MOVE	A0,*A13(OP_LINE_CHAR)
	PULL	A0

	RETS

********************************
* PLOT OUT A LINE OF TEXT ON THE SCREEN

OMPLOTTEXT

	MMTM	SP,A8,A10,A11

	PUSH	A11
	MOVI	OMTSETUP,A8
	CALLA	LM_SETUP
	MOVE	A13,A8
	ADDI	OP_LETS,A8
	MOVE	*A13(OP_LINE_LINE),A9,W
	SLL	5,A9
	ADDI	OMLOC,A9
	MOVE	*A9,A9,L
	SLL	16,A9
	MMTM	SP,A3,A4,A9
	MOVE	A9,A3
	SUBI	20000H,A3
	MOVI	[LET_TEXT_GAP+2,394],A4
	CALLA	BLNKAREA
	MMFM	SP,A3,A4,A9
	ADDI	200,A9
	JSRP	LM_FINIS

	PULL	A5
	MOVE	A5,A5			;FLAG FOR UNDERSCORE OR NOT
	JRZ	NOUNDER
	movi	ROBO_LASER,a6
	movi	underscore_s,a8
	addk	5,a9			;SHIFT THE LITTLE GUY OVER
	JSRP	LM_FINIS
NOUNDER
	MMFM	SP,A8,A10,A11
	RETS


#*******************************
* Add the character pointed to by a8/a10
* A8 =Line
* A10=Char on line

OMADDCHAR
	PUSH	a8,a10

	sll	5,a8
	addi	OLTAB,a8		;+Base
	move	*a8,a8,L
	sll	3,a10
	add	a10,a8			;char offset
	movb	*a8,a0			;snag the char
	cmpi	'_',a0
	jrne	#20

	move	*a13(OP_LINE_CHAR),a1	;>Backspace
	jrz	#x
	dec	a1
	move	a1,*a13(OP_LINE_CHAR)
	move	a1,a2
	clr	a0
	jruc	rubent

#20
	cmpi	'^',a0
	jrne	#addchar

	clr	a11
	callr	OMPLOTTEXT		; GET RID OF THE FLASHING UNDERSCORE
	clr	a0
	move	a0,@BLINE
	move	a0,@BCHAR
	callr	OM_STORECMOS		; WELL, BABY -- STORE IT
	MOVE	*A13(OP_LINE_LINE),A8	; GRAB THE LINE
	CMPI	2,A8
	JRHS	OMADONE
	INC	A8
	MOVE	A8,*A13(OP_LINE_LINE)	; ON THE FIRST LINE
	CALLR	OM_STARTLINE		; INITIALIZE ALL THE FLAGS FOR IT
	MOVK	1,A11
	CALLR	OMPLOTTEXT
	jruc	#x

;	HERE IS JUST ENTER A NORMAL CHARACTER --
;
;	A8 = LINE
;	A10 = CHARACTER

#addchar

	MOVE	*A13(OP_LINE_CHAR),A1
	MOVE	A1,A2
	CMPI	OP_MAX_CHARS,A1
	JRHS	OMACMAX
	INC	A1
	MOVE	A1,*A13(OP_LINE_CHAR)
rubent
	move	a13,a8
	ADDI	OP_LETS,A8
	SLL	3,A2
	ADD	A2,A8			;OFFSET INTO LOCAL STORAGE
	MOVB	A0,*A8
	ADDK	8,A8
	CLR	A0
	MOVB	A0,*A8			;MAKE SURE ZERO TERMINATED
	MOVK	1,A11
	CALLR	OMPLOTTEXT
;OMACRET
#x	MMFM	SP,A8,A10
	RETS

OMADONE					;COME HERE WHEN REALLY DONE
;	CALLA	CMOSUNLOCK
        CALLA   ADJ_PAGE		;GUY ENTERED A WHOLE MESSAGE
        MOVI    VALID_CUSTOM,A7
        MOVI    VALID_VALUE,A0
        CALLA   WC_WORD
        CALLA   F_ADC_S			;FIX UP THE CHECKSUM
;	CALLA	CMOSLOCK
	MMFM	SP,A8,A10
	MOVI	0FFH,A8			;FLAG DONE WITH EVERYTHING
	RETS

OMACMAX
	mmfm	sp,a8,a10
	clr	a11
	callr	BOXCHAR
	movk	3,a8
	movk	14,a10
	move	a8,@BLINE
	move	a10,@BCHAR
	rets


**************************************************************************
* STORE THE MESSAGE IN CMOS

OM_STORECMOS
;	CALLA	CMOSUNLOCK
	CALLA	ADJ_PAGE		;POINT AT ADJUSTMENTS PAGE
	MOVE	*A13(OP_LINE_LINE),A7
	MOVI	CMESS_LINE_SIZE,A6
	MPYU	A6,A7			;OFFSET ME, BABY
	ADDI	CUSTOM_MESSAGE,A7	;A7 IS CMOS LOCATION
	MOVE	A13,A6
	ADDI	OP_LETS,A6		;A6 IS THE PROCESS BLOCK LOC
	movk	CMESS_CHARS-1,a5	;CHARS/LINE

cmos_loop
	movb	*a6,a0			;fetch a character
	andi	BYTE_MASK,A0
	calla	WC_BYTEI		;WRITE A BYTE
	addk	BYTE_SIZE,A6		;POINT AT NEXT BYTE
	dsj	a5,cmos_loop

	clr	a0
	calla	WC_BYTEI		;Write a null

	calla   F_ADC_S			;REFRESH CHECKSUM
;	CALLA	CMOSLOCK

	rets

OMLOC	.LONG	LET_TEXT1, LET_TEXT2, LET_TEXT3



**************************************************************************
* BOXCHAR
* A8 =WHICH LINE (0-3)
* A10=CHARACTER ON LINE
* A11=COLOR TO USE ( 0 = BLACK, 1 = LASER FLASH )

BOXCHAR
	MMTM	SP,A1,A8,A10

	MOVI	LET_DIST_Y,A1
	MPYU	A8,A1				; DISTANCE
	ADDI	LET_START_Y1-LET_BOX_CY,A1
	SLL	16,A1
	MOVE	A1,A4
	MOVI	LET_DIST_X,A1
	MPYU	A10,A1
	ADDI	LET_START_X-LET_BOX_CX,A1
	MOVX	A1,A4				; UPPER LEFT IN A4
	MOVE	A4,A5	
	MOVI	[LET_DIST_Y+LET_BOX_WY,LET_DIST_X+LET_BOX_WX],A0
	ADDXY	A0,A5				; LOWER RIGHT IN A5

	MOVI	[1,1],A0			; BORDER HEIGHT,WIDTH
	MOVI	ROBO_BLACK,A9			; DOBORDER IS RETARDED
	MOVE	A11,A11
	JRZ	BC1
	MOVI	ROBO_LF,A9
BC1
	CALLR	DOBORDER

	MOVE	A11,A11
	JRNZ	BC2
	MOVI	0FFH,A10
BC2
	CALLR	OPPLOTLINE

	MMFM	SP,A1,A8,A10
	RETS


#*******************************
* Plot out a line of characters
* A8 =Table #
* A10=Which character to highlight

	.bss	char_s	,16

OPPLOTLINE

	PUSH	a8,a9,a10,a11

	move	a8,a9
	sll	5,a8			;*32
	addi	OLTAB,a8
	move	*a8,a8,L
	sll	4,a9
	addi	OLYTAB,a9
	move	*a9,a9
	
	sll	16,a9			;Get in the y position
	addk	LET_START_X,a9
#lp
	movb	*a8,a0			;GRAB CHAR NUMBER
	move	a0,a0	
	jrz	#x
	movb	a0,@char_s
	PUSH	a8
	PUSH	a9
	PUSH	a10
	PUSH	a9
	movi	BRSH_R_P,a0		;*Palette
	move	a10,a10
	jrnz	opl1
	movi	BRSH_W_P,a0
opl1	calla	pal_getf
	move	a0,a5

	movi	OP_MESS,a8
	calla	LM_SETUP
	move	a5,a6			;Color
	PULL	a9			;SET THE POSITION OF THE CHAR
	movi	char_s,a8
	JSRP	LM_FINIS

	PULL	a10
	dec	a10
	PULL	a9
	PULL	a8
	addk	8,a8
	addi	LET_DIST_X,a9
	jruc	#lp

#x	PULL	a8,a9,a10,a11
	rets


OP_MESS
	MESS_MAC FONT_T,1,200,95,BRSH_R_P,STRCNRM_1,0
;	.byte	"%c",0
;	.long	CHAROUT
	.even

OLTAB	.long	OL1TAB, OL2TAB, OL3TAB, OL4TAB
OLYTAB	.word	LET_START_Y1, LET_START_Y2, LET_START_Y3, LET_START_Y4

OL1TAB	.byte	"ABCDEFGHIJKLMN_",0
OL2TAB	.byte	"OPQRSTUVWXYZ?!_",0
OL3TAB	.byte	"1234567890:#$-_",0
OL4TAB	.byte	"^./'          ^",0
	.even

;OL1TAB	.byte	"ABCDEFGHI123?!_",0
;OL2TAB	.byte	"JKLMNOPQR456()_",0
;OL3TAB	.byte	"STUVWXYZ 7890:_",0
;OL4TAB	.byte	"^_ #$&-./'   _^",0

opmsg_s .byte	"OPERATOR MESSAGE",0
	.even
OMINST1
	MESS_MAC RD7FONT,SPACING07,200,LET_INST1,ROBO_WHITE,STRCNRM,0
	.byte	"USE PLAYER 1 OR 2 CONTROLS TO ENTER A MESSAGE",0,1
	.byte	"OF UP TO 3 LINES OF 25 LETTERS PER LINE.",0,1
	.byte	"SELECT end TO END EACH LINE.",0,1
	.byte	"PRESS PLAYER 1 OR 2 START TO CLEAR OUT MESSAGE.",0,0
	.even

OMTSETUP
	MESS_MAC   RD7FONT,SPACING07,200,LET_INST1,ROBO_BLUE,STRCNRM,0
	.even

underscore_s	.byte	"-",0
	.even


#*******************************
* A8=*MESS_MAC

 SUBRP	print_multi

	PUSH	a2

	move	a8,a2
	calla	LM_SETUP
	move	a9,a3		;1st XY

#lp	PUSH	a8
	move	a2,a8
	calla	LM_SETUP
	PULL	a8

	move	a3,a9

	JSRP	LM_FINIS
	addi	[12,0],a3	;Next Y

	movb	*a8,a0
	addk	8,a8
	move	a0,a0
	jrnz	#lp

	PULL	a2
	RETP



****************************************************************
* Secret embedded copyright notice

ASCIIE	.macro	str

	.var	i,c,e
	.eval	1,i
	.eval	1,e
	.loop	$symlen(str)
	.asg	:str(i):,c
	.byte	0ffh & (':c:'+e)
	.eval	i+1,i
	.eval	e+7,e
	.endloop
	.byte	0ffh & :e:

	.endm

	.byte	1,2,4,8,16,32,64,128	;ID

	ASCIIE	"NBA-3-COPYRIGHT-1993-MIDWAY-MANUFACTURING-COMPANY"
	ASCIIE	"ALL-RIGHTS-RESERVED"
	ASCIIE	"PROGRAMMED-BY-JEFF-JOHNSON-&-MARK-TURMELL-&-DAN-THOMPSON"




	.end

