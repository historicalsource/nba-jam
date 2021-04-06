**************************************************************
*
* Software:	George Petro
* Initiated:		
*
* Modified:	Shawn Liptak, 9/30/91	-High speed version (Total carnage)
* 		Shawn Liptak, 1/8/92	-Reserved 8 channels
* 		Shawn Liptak, 2/19/92	-Basketball (cleanup)
* 		Shawn Liptak, 10/2/92	-TUNIT mods
*		Jamie Rivett,		-NBA JAM
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 10/9/92 22:50
**************************************************************
	.file	"sounds.asm"
	.title	"sound processor"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"sys.equ"
	.include	"game.equ"
	.include	"shawn.hdr"
	.include	"audit.equ"


	.ref	AUD1
	.ref	gmqrtr

;sound driver stuff

	.def	SNDSND
	.def	musicoff_snd,YAMOFF,FADE_DOWN,ALLOFF,FADE_UP,ALLOFF

;sound headers used in game

	.def	coin_snd,beep2_snd
	.def	cntdown_snd
	.def	tune2_snd,horn_snd

*SOUND PROCESSOR MAKES SOUNDS FOR N-CHANNELS (CURRENTLY 6):
*
*		CHANNEL #0	OKI CHANNEL 3
*		CHANNEL #1	OKI CHANNEL 4
*		CHANNEL #2	YAMAHA SOUNDS
*		CHANNEL #3	MUSIC	      
*		CHANNEL #4	OKI CHANNEL 1 (PLAYER 1)
*		CHANNEL #5	OKI CHANNEL 2 (PLAYER 2)
*
*SOUND TABLE FORMAT
*
*SOUND DESCRIPTION:
*	.WORD PRIORITY, TIME, SOUND CODE, (PRIORITY), (TIME), (SOUND CODE), 0
*
*SOUND ENDS IN 0000.
*PRIORITY WORD = 1111INNNPPPPPPPP; I=1=NON-INTERRUPTABLE
*NNN=CHANNEL #(0-7);
*PP=PRIORITY (00-FF), FF=HIGHEST.
*TIME WORD =TTTT (0000-7FFF X 16MS).
*SOUND WORD =8SSS SSS=SOUND CODE(000-FFF).

SNDPRI	.SET	0  	;PRIORITY (00=LOWEST, FF=HIGHEST)
SNDTMR	.SET	010h	;TIMER COUNTDOWN
SNDPTR	.SET	020h	;POINTER TO SOUND TABLE DATA
SNDREP	.SET	040h	;REPEAT COUNT OF SOUND
;SNDTIM	.SET	050h	;TIMER 000-7FFF
SNDST	.SET	060h	;ADDRESS OF SOUND TABLE START
SNDSIZ	.SET	080h	;Note: Code uses shifts

SL_CHANNEL	EQU	21	;SHIFTS REQUIRED TO ISOLATE CHANNEL NUMBER
SR_CHANNEL	EQU	29

NCHAN		EQU	6	;DECLARE NUMBER OF ALLOWED CHANNELS
MUSICHAN	EQU	3	;THIS CHANNEL IS FOR THE TUNES

RESETBIT	EQU	0FE00H	;THIS IS THE ^RESET BIT

EXTENDED_CODE	EQU	7AH	;SEND THIS TO INDICATE EXTENDED SOUND CALL


	BSSX	sound_rev	,16
	BSSX	SOUNDSUP	,16		;!0=Sounds off
	.bss	SNDSTR		,8*SNDSIZ	;RESERVE STORAGE AREA
	.bss	SNDEND		,0		;END OF SOUND PROCESSOR RAM

; 	.if DEBUG
;	BSSX	sounds_list,	32*16		;32 * 16 bits
;	BSSX	slist_offset,	16
;	.endif

	.text


**************************************************************************
* Hardware reset of sound board
* Trashes scratch

 SUBR	snd_reset

	movi	RESETBIT,a0	;Reset on
	move	a0,@SOUND

	movi	100,a0		;Delay
	dsj	a0,$

;	movi	-1,a0		;Reset off
	movi	0FF00h,a0	;Reset off	;gnp 2/15/93
	move	a0,@SOUND

	clr	a0
	movi	SNDSTR,a1
#lp	move	a0,*a1+
	cmpi	SNDEND,a1
	jrlo	#lp

	rets

********************************
* Quiet hardware reset of sound board
* Trashes scratch

 SUBR	QSNDRST

	PUSH	a3

	callr	snd_reset
	movi	50*6/3,a0
	dsj	a0,$		;Delay 50us
	clr	a3
	callr	SNDSND		;Kill dig sound

	PULL	a3
	rets


********************************
* Plays a sound once, overriding any current lower priority sound
* A0=* to sound data
* Trashes scratch

 SUBR	snd_play1ovrp

 	PUSH	a2,a3
	movk	1,a1
;2/9/92
	move	@SOUNDSUP,a2
	jrnz	#x			;Quiet?

	move	*a0,a2			;Get priority word
	move	a2,a3
	sll	SL_CHANNEL,a2
	srl	SR_CHANNEL,a2		;Extract channel bits
	sll	7,a2			;*SNDSIZ
	addi	SNDSTR,a2 		;+Base

	move	*a2,a14			;Get current priority
	sll	32-8,a3			;Mask priorities
	sll	32-8,a14
	cmp	a14,a3
	jrls	#x			;New pri <= old pri?

	jruc	sl50


********************************
* Plays a sound once, overriding any current sound
* A0=* to sound data
* Trashes scratch

 SUBR	snd_play1ovr

 	PUSH	a2,a3
	movk	1,a1
;2/9/92
	move	@SOUNDSUP,a2
	jrnz	#x			;Quiet?
	move	*a0,a2			;Get priority word
	sll	SL_CHANNEL,a2
	srl	SR_CHANNEL,a2		;Extract channel bits
	sll	7,a2			;*SNDSIZ
	addi	SNDSTR,a2 		;+Base
	jruc	sl50


********************************
* Plays a sound once
* A0=* to sound data
* Trashes scratch

 SUBR	snd_play1

	movk	1,a1

********************************
;RJR (replace routine)
* Plays a sound
* A0=* to sound data
* A1=Repeat count
* Trashes scratch

;CC = sound played ok
;CS = sound not played

 SUBR	snd_play

	PUSH	a2,a3

sl20
;2/9/92
	move	@SOUNDSUP,a2
	jrnz	#x			;Quiet?

	move	*a0,a2			;Get priority word
	move	a2,a3
	sll	SL_CHANNEL,a2
	srl	SR_CHANNEL,a2		;Extract channel bits
	sll	7,a2			;*SNDSIZ
	addi	SNDSTR,a2 		;+Base

	move	*a2,a14			;Get current priority
	btst	11,a14
	jrnz	#x			;Non-interruptable?
	sll	32-8,a3			;Mask priorities
	sll	32-8,a14
	cmp	a14,a3
	jrlo	#x			;New pri < old pri?

sl50	move	a0,*a2(SNDST),L 	;Setup sound start pointer
	move	*a0+,*a2+,L		;Set PRI,TMR
	move	*a0+,a3			;Snd code
	move	a0,*a2+,L		;Set PTR
	move	a1,*a2+			;Set RPT (Repeat count)
	callr	SNDSND			;Send sound code
	PULL	a2,a3
	clrc				;ok
	rets

#x	PULL	a2,a3
	setc				;fail
	rets


********************************
* Sound processor called every main loop (16 MSEC)
* Trashes scratch, A2-A3

 SUBR	snd_update

	movi	SNDSTR,a0
	movk	NCHAN,a1
splp	move	*a0(SNDTMR),a2 	;Check timer
	jrz	sp5		;Inactive channel?
	subk	1,a2
	move	a2,*a0(SNDTMR)	;New time
	jrnz	sp5		;No timeout?
	callr	SNDUPD		;Update sound
sp5	addi	SNDSIZ,a0
	dsjs	a1,splp
	rets


********************************
* Update sound
* A0=* to sound channel ram

SNDUPD
        move	*a0(SNDPTR),a2,L	;Get * to rom table
sud2	move	*a2+,a3			;Get next rom table entry
	jrnz	sud8			;Another snd?

	move	*a0(SNDREP),a3		;Check repeat count
	subk	1,a3
	move	a3,*a0(SNDREP)
	jrle	sud6			;No repeats?
	move	*a0(SNDST),a2,L
	jruc	sud2			;Start sound over

sud6	clr	a2
	move	a2,*a0			;Clear sound priority
	move	a2,*a0(SNDST),L		;Clear sound ptr 
	rets

sud8
;RJR
	move	a2,*a0(SNDST),L		;setup sound start pointer (SNDST)
	move	*a2+,*a0+,L		;set PRI,TMR
	move	*a2+,a3			;snd code
	move	a2,*a0+,L		;set SNDPTR
	subi	40h,a0			;fix a0


;RJR
 .if 0
	move	a3,*a0+			;Set PRI
	move	*a2+,*a0+		;Set TMR
	move	*a2+,a3			;Get code
	move	a2,*a0,L		;Set PTR
	subk	32,a0			;Fix A0
 .endif

;	jruc	SNDSND			;Send sound code
;Fall through

#*******************************
* SNDSND - Raw hardware sound call
* A3=Sound code 0->1ff
* Trashes B0,A14

SNDSND
	PUSH	a3

	sll	32-9,a3
	srl	32-9,a3			;Strip off bits

; .if DEBUG
; 	callr	save_sound
; .endif

	cmpi	>100,a3
	jrlo	ss20			;Not extended sound call?
	move	a3,b0
	movi	EXTENDED_CODE,a3	;Send the extended feature
	callr	SNDSND
	move	b0,a3

	sll	32-8,a3
	srl	32-8,a3
ss20
	addi	SOUNDBIT,a3		;Pull sound section interrupt
	move	a3,@SOUND		;Hit sound (LOW)

	.if	TUNIT
	movk	8,a14
	dsj	a14,$			;Slow it down a bit

	.else

	movk	8,a14
	dsj	a14,$

	ori	>ff00,a3		;Put out 1's
	move	a3,@SOUND

	movk	8,a14
	dsj	a14,$
	.endif

	movi	390/3,a3		;180 micros max firq delay on snd board
ss50	movb	@SOUNDIRQ+B_SIRQ-7,a14
	jrn	#x			;Done?
	dsj	a3,ss50
	.if	DEBUG
	nop				;So we can breakpoint
	.endif

#x	PULL	a3
	rets


**************************************************************************
*								         *
* IS_SOUND - CHECK SOUND DATA BASE TO SEE IF THE GIVEN SOUND SCRIPT	 *
* 		IS CURRENTLY BEING PROCESSED. (I.E. ANOTHER SOUND	 *
* 		HAS OR HAS NOT TAKEN OVER.)				 *
* A0 = PTR TO SOUND SCRIPT						 *
* RETURNS								 *
* 	 Z = SAME SCRIPT						 *
* 	NZ = SCRIPT NO LONGER ACTIVE					 *
*								         *
**************************************************************************
;IS_SOUND		
;	PUSH	A3
;	MOVE	*A0,A14		;GET CHANNEL/PRIORITY WORD
;	MOVI	SNDSIZ,A3
;	SLL	SL_CHANNEL,A14
;	SRL	SR_CHANNEL,A14	;EXTRACT CHANNEL BITS
;	MPYU	A14,A3
;	ADDI	SNDSTR,A3 	;GET THE CORRECT RAM CHANNEL ADDRESS
;	MOVE	*A3(SNDST),A14,L
;	CMP	A0,A14		;SAME SCRIPT ACTIVE?
;	PULL	A3
;	RETS

**************************************************************************
*                                                                        *
* CKSNDPRI - CHECK SOUND CHANNEL FOR EXISTANCE OF A GIVEN SOUND PRIORITY *
* A0 = CHANNEL #							 *
* A1 = SOUND PRIORITY							 *
* RETURNS:								 *
* CARRY CLEAR = PRIORITY NOT ACTIVE					 *
* CARRY SET = PRIORITY ACTIVE						 *
*                                                                        *
**************************************************************************
;CKSNDPRI
;	MMTM	SP,A0,A2
;	MOVI	SNDSTR,A2
;	SLL	7,A0			;CHANNEL x 128
;	ADD	A2,A0			;OFFSET TO CORRECT CHANNEL AREA
;	MOVB	*A0,A0
;	CMP	A0,A1
;	JRNE	CKSPRI1			;BR = PRIORITY NOT ACTIVE
;	SETC
;	MMFM	SP,A0,A2
;	RETS
;CKSPRI1
;	CLRC
;	MMFM	SP,A0,A2
;	RETS


**************************************************************************
*                                                                        *
* FADE_UP - PROCESS TO FADE THE SOUND UP				 *
* A11 = FADE RATE							 *
*                                                                        *
**************************************************************************
FADE_UP
	MOVI	FADE_UP_TAB,A8
	JRUC	FADER
**************************************************************************
*                                                                        *
* FADE_DOWN - PROCESS TO FADE THE SOUND UP				 *
* A11 = FADE RATE							 *
*                                                                        *
**************************************************************************
FADE_DOWN
	MOVI	FADE_DOWN_TAB,A8
	JRUC	FADER

FADER
	MOVI	FADEPID,A0
	CLR	A1
	NOT	A1
	CALLA	KILALL			;WASTE ANY OTHER FADERS
FADE_LP
	MOVE	*A8+,A0,L
	JRZ	FADE_DONE
	callr	snd_play1
	SLOOPR	A11,FADE_LP
FADE_DONE
	DIE

FADE_UP_TAB
	.LONG	VOLUME0
	.LONG	VOLUME1
	.LONG	VOLUME2
	.LONG	VOLUME3
	.LONG	VOLUME4
	.LONG	VOLUME5
	.LONG	VOLUME6
	.LONG	VOLUME7
	.LONG	VOLUME8
	.LONG	VOLUME9
	.LONG	VOLUMEA
	.LONG	VOLUMEB
	.LONG	VOLUMEC
	.LONG	VOLUMED
	.LONG	VOLUMEE
	.LONG	VOLUMEF
	.LONG	0

FADE_DOWN_TAB
	.LONG	VOLUMEF
	.LONG	VOLUMEE
	.LONG	VOLUMED
	.LONG	VOLUMEC
	.LONG	VOLUMEB
	.LONG	VOLUMEA
	.LONG	VOLUME9
	.LONG	VOLUME8
	.LONG	VOLUME7
	.LONG	VOLUME6
	.LONG	VOLUME5
	.LONG	VOLUME4
	.LONG	VOLUME3
	.LONG	VOLUME2
	.LONG	VOLUME1
	.LONG	VOLUME0
	.LONG	0


**************************************************************************
* POPULAR SOUND CALLS

*HIGH PRIORITY OFF CODES, NOTHING SHOULD BEAT THESE
CVSDOFF		.WORD	>F0FF|>800,>01,>8000,0	;CVSD BACKGROUND LOOP OFF
CVSDFOFF 	.WORD	>F0FF|>800,>01,>8000,0	;CVSD FOREGROUND LOOP OFF
SOUNDOFF 	.WORD	>F0FF|>800,>01,>8000,0	;TURN SOUND SIDE OFF
ALLOFF	 	.WORD	>F3FF|>800,>01,>8000,0	;MUSIC AND EFFECTS OFF
musicoff_snd	.WORD	>F3FF|>800,>01,>807E,0	;TURN JUST MUSIC OFF
MUSITOFF	.WORD	>F3FF|>800,>01,>8040,0	;MUSIC TRANSITION OFF
YAMOFF		.WORD	>F2FF|>800,>01,>807F,0	;YAMAHA EFFECT OFF

VOLUME0	.WORD	>F3FE,>1,>802F,0
VOLUME1	.WORD	>F3FE,>1,>802E,0
VOLUME2	.WORD	>F3FE,>1,>802D,0
VOLUME3	.WORD	>F3FE,>1,>802C,0
VOLUME4	.WORD	>F3FE,>1,>802B,0
VOLUME5	.WORD	>F3FE,>1,>802A,0
VOLUME6	.WORD	>F3FE,>1,>8029,0
VOLUME7	.WORD	>F3FE,>1,>8028,0
VOLUME8	.WORD	>F3FE,>1,>8027,0
VOLUME9	.WORD	>F3FE,>1,>8026,0
VOLUMEA	.WORD	>F3FE,>1,>8025,0
VOLUMEB	.WORD	>F3FE,>1,>8024,0
VOLUMEC	.WORD	>F3FE,>1,>8023,0
VOLUMED	.WORD	>F3FE,>1,>8022,0
VOLUMEE	.WORD	>F3FE,>1,>8021,0
VOLUMEF	.WORD	>F3FE,>1,>8020,0


*SOUND PROCESSOR MAKES SOUNDS FOR N-CHANNELS (CURRENTLY 6):
*
*		CHANNEL #0	OKI CHANNEL 3 MISC. SAMPLES
*		CHANNEL #1	OKI CHANNEL 4 SPEECH
*		CHANNEL #2	YAMAHA SOUNDS FX
*		CHANNEL #3	BACKGROUND MUSIC
*		CHANNEL #4	OKI CHANNEL 1 EXPLOSIONS
*		CHANNEL #5	OKI CHANNEL 2 GUN SHOTS
*
*PRIORITY WORD = 1111INNNPPPPPPPP; I=1=NON-INTERRUPTABLE
*NNN=CHANNEL #(0-7);
*PP=PRIORITY (00-FF), FF=HIGHEST.
*TIME WORD =TTTT (0000-7FFF X 16MS).
*SOUND WORD =8SSS SSS=SOUND CODE(000-FFF).


coin_snd	.word	>f3ff,>8,>80a4,0	;coin in melody snd

beep2_snd	.word	>fcf7,>5,>8123,0	;beep tone for diagnostics
cntdown_snd	.word	>fcf5,5,>8123,0		;buyin cntdwn clang

;RJR (wrong channel - was 1 OKI 4  - supposed to be 0 OKI 3)
;;;horn_snd	.word	>f9fe,>58,>8159,0	;horn
horn_snd	.word	>f8fe,>58,>8159,0	;horn


tune2_snd	.word	>f3fe,1,>8002,0		;main game play tune

#*****************************************************************************
* saves 16 bits in a3

;	.if DEBUG
;
; SUBRP	save_sound
;
;	PUSH	a1,a2
;
;	cmpi	EXTENDED_CODE,a3	;extended?
;	jreq	#nosave
;
;	move	@slist_offset,a1
;	inc	a1
;	andi	31,a1
;	move	a1,@slist_offset
;	sll	4,a1		;*16
;	addi	sounds_list,a1
;	move	a3,*a1+		;save it
;
;	movi	0ffffh,a2
;	move	@slist_offset,a1
;	inc	a1
;	andi	31,a1
;	sll	4,a1		;*16
;	addi	sounds_list,a1
;	move	a2,*a1		;mark end of buffer
;
;#nosave
;	PULL	a1,a2
;	rets
;
;	.endif

#*****************************************************************************

; SUBR	set_sound_rev
;
;
;	RETP


#*****************************************************************************


 SUBR	sound_watchdog


	SLEEPK	1

	move	@SOUNDR,a0		;clear sound data available latch

	movi	0ffaah,a3		;Pull sound section interrupt
	move	a3,@SOUND		;Hit sound (LOW)

	SLEEPK	8

	movb	@SOUNDR,a3
	move	a3,@sound_rev		;determine snd board rev.


#watchdog_loop

	SLEEP	60


	movi	0ffaah,a3		;Pull sound section interrupt
	move	a3,@SOUND		;Hit sound (LOW)

	movk	8,a14
	dsj	a14,$			;Slow it down a bit




	.if	0

	movi	390/3,a3		;180 micros max firq delay on snd board
#lp1	movb	@SOUNDIRQ+B_SIRQ-7,a14
	jrn	#ok1			;Done?
	dsj	a3,#lp1

*		timed out, irq must be dead!
* ERROR #1
	movi	AUD_SNDERR1,a0		;log it
	calla	AUD1
	jruc	#reset_board


	.endif




#ok1

	move	@sound_rev,a0		;if old sound board software
	cmpi	05ah,a0			;then skip these two checks
	jrne	sound_watchdog


	SLEEPK	8			;approx 128 msec delay

	movb	@SOUNDIRQ+B_SDAV-7,a14
	jrn	#ok2

*		sound data not available
* ERROR #2
	movi	AUD_SNDERR,a0		;log it
	calla	AUD1
	jruc	#reset_board

#ok2

	movb	@SOUNDR,a3
	cmpi	05ah,a3
	jreq	#watchdog_loop

*		invalid read back value
* ERROR #3
	movi	AUD_SNDERR,a0		;log it
	calla	AUD1
#reset_board

	callr	QSNDRST			;quiet hardware sound board reset

	SLEEP	90

	move	@gmqrtr,a0
	sll	5,a0
	addi	#tune_t,a0
	move	*a0,a0,L
	calla	snd_play1ovr

	jruc	#watchdog_loop


#tune_t	.long	tuneq2_snd,tuneq2_snd,tuneq3_snd,tuneq4_snd,tuneot_snd
	.long	tuneot_snd,tuneot_snd,tuneot_snd,tuneot_snd
	.long	tuneot_snd,tuneot_snd,tuneot_snd,tuneot_snd

tuneq2_snd	.word	>f3ff,>8,>8006,0	;Quarter 2 tune
tuneq3_snd	.word	>f3ff,>8,>8007,0	;Quarter 3 tune
tuneq4_snd	.word	>f3ff,>8,>8008,0	;Quarter 4 tune
tuneot_snd	.word	>f3ff,>8,>800b,0	;Quarter o.t.



******************************************************************************
	.end
