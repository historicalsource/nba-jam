**************************************************************
*
* Owner:	none
*
* Software:		Shawn Liptak and ?
* Initiated:		?
*
* Modified:		Shawn Liptak, 8/?/91	-Clean up
* 			Shawn Liptak, 1/27/92	-Basketball start
* 			Shawn Liptak, 3/19/93	-Clean up
* 			Jeff Johnson, 4/10/95	-New hardware support (wwf)
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/24/93 14:58
*.Last mod - 4/10/95 8:00pm
*.Last mod - ??/??/95 ??:??pm - DJT
**************************************************************
	.file	"main.asm"
	.title	"initialization and interrupts"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"gsp.equ"
	.include	"sys.equ"
	.include	"game.equ"
	.include	"macros.hdr"
	.include	"dipsw.equ"
	.include	"bbsec.equ"


; stack segment def

STACKL	.equ	512*16			;stack size
STACKB	.usect	"STACK",STACKL,1
STACKE	.equ	STACKB+STACKL		;top of stack
			

; globals elsewhere

	.ref	init_prog
	.ref	display_init
	.ref	process_init
	.ref	snd_reset,qsndrst_proc
	.ref	pal_transfer
	.ref	dma_irq

	.ref	GAMSTATE
	.ref	C_FRAC,C_FLAGS,COINCNTR
	.ref	COLRTEMP
	.ref	swstack_p,swstackbot, swstacktop
	.ref	READ_DIP

	.ref	_sound_addr
	.ref	_coin_addr
	.ref	_switch_addr
	.ref	_switch2_addr
	.ref	_watchdog_addr
	.ref	_dipswitch_addr
	.ref	_soundirq_addr
	.ref	_coin_counter_addr
	.ref	_get_time
	.ref	_aquire_time
	.ref	_tmonth
	.ref	_tdate
	.ref	_thours
	.ref	_tminutes
	.ref	_tseconds


; globals in here

	.def	SecFuncCheck

	.globl	RemapIO
	.globl	_clk_rd
	.globl	SecFuncCheck

ALARM_MAC	.macro	month,date,hour,minute,func
	.word	:month:			;month number 1-12 (-1 = don't care)
	.word	:date:			;date (1-31) (-1 = don't care)
	.word	:hour:			;hour (0-23) (-1 = don't care)
	.word	:minute:		;minute (0-59) (-1 = don't care)
	.long	:func:			;func - Pointer to function to call
	.endm


; ram variables

	.bss	_clk_rd,32		;Clock Trigger Counter
	.bss	_io_map,32		;Current I/O Map

	BSSX	dma_bog,16		;VCOUNT at end of DIRQ
	BSSX	dma_meter,16		;show line?
	BSSX	cpu_meter,16		;show line for cpu

	BSSX	SYSCOPY		,16	;Copy of SYSCTRL latch

	BSSX	WDOGRAM		,32	;INITIALIZED LONG FOR WATCH DOG DETECT

	BSSX	IRQSKYE		,16	;Erase color
	BSSX	dpageflip	,16	;1=Enable page flip and erasure, -1=No erasure

	BSSX	dirqtimer	,16	;+1 by dirq, cleared by mproc
	.bss	dirqcnt		,16	;+1 each dirq
	.bss	dirqdraw	,16	;!0=Still drawing last frame

	.bss	swtemp1		,16
	.bss	swtemp2		,16

;--------------------
	.bss	FSWITCH		,64	;Do not re-order the switch entries!
	BSSX	switches_old	,64
	BSSX	switches_cur	,64
	BSSX	switches_up	,64
	BSSX	switches_down	,64
;--------------------

	BSSX	NPLAYERS	,16	;NUMBER OF PLAYERS ALLOWED - GNP 1/17/93
	BSSX	COUNTER_MODE	,16	;COIN COUNTER MODE - GNP 1/17/93
	BSSX	VALIDATOR	,16	;VALIDATOR FLAG 0 = NONE, 1 = INSTALLED - GNP 1/22/93

	BSSX	TWOPLAYERS	,16	;0 = NO, 1 = YES 2 players
	BSSX	ROLLING_COUNT,16


; defined data

	.data

ALARM_TAB
	ALARM_MAC	-1,-1,-1,38,RemapIO	;Remap I/O at 38 minutes past hour
	ALARM_MAC	-1,-1,11,4,RemapIO	;Remap I/O at 11:04 a.m. every day
	ALARM_MAC	-1,31,16,27,RemapIO	;Remap I/O on the 31st at 4:27 p.m.
	ALARM_MAC	4,1,12,30,RemapIO	;Remap I/O at 12:30 p.m. on April fools day
	.long		0
	.even

_SecurityFunctions	.long	SetAddresses

	.even


; code start

	.text

********************************
* Alarm Clock Support (Called by DIRQ when seconds are 0)
* Trashes a0
  SUBR	_AlarmClock
	mmtm	sp,a0,a1,a2
	movi	ALARM_TAB,a0,L
_ac_loop
	move	*a0,a1,W		;Get Alarm month
	jrz	_ac_done		;BR = No more alarm settings
	jrn	_ac_date		;Do we care what month BR = NO
	move	@_tmonth,a2,W		;Get current month
	cmp	a1,a0			;Same ?
	jrnz	_ac_next		;Nope - Done with this alarm
_ac_date
	move	*a0(16),a1,W		;Get Alarm Date
	jrn	_ac_hour		;Do we care what date BR = no
	move	@_tdate,a2,W		;Get current date
	cmp	a1,a2			;Same ?
	jrnz	_ac_next		;Nope -	Done with this alarm
_ac_hour
	move	*a0(32),a1,W		;Get Alarm Hour
	jrn	_ac_minute		;Do we care what hour BR = no
	move	@_thours,a2,W		;Get current hour
	cmp	a1,a2			;Same ?
	jrnz	_ac_next		;Nope - Done with this alarm
_ac_minute
	move	*a0(48),a1,W		;Get Alarm minute
	jrn	_ac_next		;Do we care what minute BR = no
	move	@_tminutes,a2,W		;Get current minute
	cmp	a1,a2			;Same ?
	jrnz	_ac_next		;Nope - Done with this alarm
	move	*a0(64),a0,L		;Yes - run this alarm function
	call	a0
_ac_next
	addi	96,a0			;Increment to next alarm record
	jruc	_ac_loop
_ac_done
	mmfm	sp,a0,a1,a2		;All done - restore registers
	rets				;Go back to interrupt handler

********************************
* Remap I/O space - Changes the I/O map
* Trashes a0,a1
 SUBR	RemapIO

	;temp!
	rets

	move	@_io_map,a0,L		;Get Current I/O map
	addk	1,a0			;Increment it
	cmpi	5,a0			;>= 5?
	jrlt	#map_ok			;Nope - then use it
	clr	a0			;else reset it back to 0
#map_ok
	move	a0,@_io_map,L		;a0 = I/O map number
	clr	a1			;a1 = SetAddresses Trap Request
	trap	3			;Remap I/O space
	rets
RemapIO_End

SecFuncTable
	.long	RemapIO,RemapIO_End
	.word	06a9h			;This is a checksum of the function
	.long	0

******************************************************************************
 SUBR  InitAddresses
	movi	COINS,a0
	move	a0,@_coin_addr,L
	movi	SWITCH,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS,a0
	move	a0,@_coin_counter_addr,L
	movi	VMUX_INITMODE,a0
	move	a0,@VMUX_CONTROL
	rets

******************************************************************************
 SUBR  AddressSet1
	movi	COINS_M1,a0
	move	a0,@_coin_addr,L
	movi	SWITCH_M1,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2_M1,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG_M1,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH_M1,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND_M1,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ_M1,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS_M1,a0
	move	a0,@_coin_counter_addr,L
	movi	(VMUX_INITMODE|VMUX_MODE1),a0
	move	a0,@VMUX_CONTROL
	rets

******************************************************************************
 SUBR  AddressSet2
	movi	COINS_M2,a0
	move	a0,@_coin_addr,L
	movi	SWITCH_M2,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2_M2,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG_M2,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH_M2,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND_M2,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ_M2,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS_M2,a0
	move	a0,@_coin_counter_addr,L
	movi	(VMUX_INITMODE|VMUX_MODE2),a0
	move	a0,@VMUX_CONTROL
	rets

******************************************************************************
 SUBR  AddressSet3
	movi	COINS_M3,a0
	move	a0,@_coin_addr,L
	movi	SWITCH_M3,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2_M3,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG_M3,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH_M3,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND_M3,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ_M3,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS_M3,a0
	move	a0,@_coin_counter_addr,L
	movi	(VMUX_INITMODE|VMUX_MODE3),a0
	move	a0,@VMUX_CONTROL
	rets

******************************************************************************
 SUBR  AddressSet4
	movi	COINS_M4,a0
	move	a0,@_coin_addr,L
	movi	SWITCH_M4,a0
	move	a0,@_switch_addr,L
	movi	SWITCH2_M4,a0
	move	a0,@_switch2_addr,L
	movi	WATCHDOG_M4,a0
	move	a0,@_watchdog_addr,L
	movi	DIPSWITCH_M4,a0
	move	a0,@_dipswitch_addr,L
	movi	SOUND_M4,a0
	move	a0,@_sound_addr,L
	movi	SOUNDIRQ_M4,a0
	move	a0,@_soundirq_addr,L
	movi	COIN_COUNTERS_M4,a0
	move	a0,@_coin_counter_addr,L
	movi	(VMUX_INITMODE|VMUX_MODE4),a0
	move	a0,@VMUX_CONTROL
	rets

AddressTable	.long	InitAddresses, AddressSet1, AddressSet2
		.long	AddressSet3, AddressSet4

******************************************************************************
; A0 = Address Set to install (0-4)

 SUBR  SetAddresses
	move	a0,a0
	jrn	_invalid
	cmpi	4,a0
	jrgt	_invalid
	sll	5,a0
	addi	AddressTable,a0
	move	*a0,a0,L
	pushst
	dint
	call	a0
	popst
_invalid
	rets

**********************************
* SecFuncCheck - Checks to make sure security functions have not be mucked with
* Trashes a0,a1,a2,a3, a4
 SUBR	SecFuncCheck


	rets		;<----------------temp!!!!!!!!!!!!!!!!!!!!!!


	movi	SecFuncTable,a0,L	;Table of security functions to check
SFC_loop
	move	*a0+,a1,L		;Pointer to beginning of function
	jrz	SFC_done
	move	*a0+,a2,L		;Pointer to end of function
	sub	a1,a2
	srl	3,a2
	clr	a3
SFC_iloop
	movb	*a1,a4
	andi	0ffh,a4
	add	a4,a3
	addk	8,a1
	dsjs	a2,SFC_iloop
	move	*a0+,a4,W
	cmp	a4,a3
	jrz	SFC_loop
	LOCKUP
SFC_done
	

***************************************************************
* InitPIC - Initializes the PIC Microcontroller
*
  SUBR	InitPIC
	calla	InitAddresses
	clr	a0			;Reset the PIC
	move	@_coin_counter_addr,a1,L
	move	a0,*a1,W
	movi	10,a0			;Hold RESET fer a bit
	dsjs	a0,$
	movi	010h,a0			;Set no command request
	move	a0,@PIC_COMMAND,W
	movi	020h,a0			;Allow PIC to run
	move	@_coin_counter_addr,a1,L
	move	a0,*a1,W
	movi	200000000,a1
_pwait_loop
	move	@_soundirq_addr,a0,L
	move	*a0,a0,W
	btst	12,a0
	jrz	_pnwait
	move	@_watchdog_addr,a0,L
	move	a0,*a0
	dsjs	a1,_pwait_loop
_pnwait
	movi	010h,a0
	move	a0,@PIC_COMMAND,W
	movi	2000000,a1
_pwait_loop1
	move	@_soundirq_addr,a0,L
	move	*a0,a0,W
	btst	12,a0
	jrnz	_pwait_done
	move	@_watchdog_addr,a0,L
	move	a0,*a0
	dsjs	a1,_pwait_loop1
_pwait_done
	rets

********************************
* Init hardware, IO, RAM
* Trashes scratch, A2-A7

 SUBR	init_all
	dint				;No interrupts until addresses set up

	.if 0
	movi	56781234h,a0		;stack init for test
	movi	STACKB,a1
	movi	STACKL/32-32,a2
	move	a0,*a1+,L
	dsjs	a2,$-16
	.endif

	clr	a0			;Zero all scratch mem except stack
	movi	STACKE,a1		;Start at bottom of stack
	movi	(SCRATL-STACKL)/32,a2	;Scratch minus stack size
	move	a0,*a1+,L
	dsjs	a2,$-16
;
	movi	-1,a0			;Auto Clock update OFF
	move	a0,@_clk_rd,L
	calla	InitPIC			;Initialize the PIC
;
	movi	WDOGNUM,a0
	move	a0,@WDOGRAM,L		;Mark system as initialized

	movi	SYSCINIT|WPIROM,a0
;	movi	SYSCINIT,a0
	move	a0,@SYSCTRL
	move	a0,@SYSCOPY		;Copy

	callr	io_init			;Initialize the I/O regs

;	calla	snd_reset		;Sound board reset (makes sound!)

	calla	display_init		;Init display system

	calla	process_init		;Init process list

	calla	snd_reset		;Sound board reset (makes sound!)

	movk	INAMODE,a0
	move	a0,@GAMSTATE
	movi	81261A8CH,a0		;Random seed
	move	a0,@RAND,L

	movi	swstacktop,a0		;Initialize switch stack
	move	a0,@swstack_p,L

	callr	dip_init		;Initialize the dipswitches

;	CREATE	QSNDRST_PID,qsndrst_proc	;Init sound board
;;	CALLA	RESET_VOICE_QUEUE
;;	CREATE	VOICE_PID,ANNOUNCE_VOICE

	movk	1,a0
	move	a0,@DISPLAYON

	;clear write-to-rom ints
	; Toddview messes with the interrupt vector table at startup,
	; and we end up with a pending WROM int.  Clear it out to avoid
	; hanging right off the bat.
	move	@SYSCOPY,a0
	xori	02000h,a0
	move	a0,@SYSCTRL
	move	@SYSCOPY,a0
	move	a0,@SYSCTRL

	eint

	rets


********************************
* Initialize options via dip switch settings

dip_init
	PUSH	a0,a1

	calla	READ_DIP		;Get the current dip switch bits
	move	a0,a1

	andi	DPPLAYERS,a0		;AQUIRE THE NUMBER OF PLAYERS
	sll	3,a0
	addi	#pnum_t,a0
	movb	*a0,a0
	move	a0,@NPLAYERS

	move	a1,a0
	andi	DPCOUNTER,a0
	srl	DPCOUNTER_SRL-3,a0
	addi	#cntr_t,a0
	movb	*a0,a0			;Match eugene's old shit
	move	a0,@COUNTER_MODE

	move	a1,a0
	andi	DPVALIDATOR,a0		;AQUIRE THE VALIDATOR STATUS
	srl	DPVALIDATOR_SRL,a0
	move	a0,@VALIDATOR		;SAVE IT

	move	a1,a0
	andi	DPPLAYERS,a0
	move	a0,@TWOPLAYERS		;0=4 plyrs, 1=2 plyrs

	PULL	a0,a1
	rets

;Translate dipswitch into number of players allowed

#pnum_t	.byte	4,2

;Translate dipswitch coin counter adjustment to what the old cmos values were

#cntr_t	.byte	2,3,1,2
	.even


**************************************************************************
* Initialize GSP I/O registers

 SUBR	io_init

	PUSH	b2,b6
	movi	INTIO,b6
	exgpc	b6
	PULL	b2,b6
	rets


#*******************************
* Initialize GSP I/O registers
* B6=*Return address
* Trashes B0-B2

 SUBR	INTIO

	movi	HESYNC,b2
	movi	gspioinit_t,b0
	movi	(giiend-gspioinit_t)/16,b1
#lp	move	*b0+,*b2+
	dsj	b1,#lp

	movi	VMUX_INITMODE,a0
	move	a0,@VMUX_CONTROL,W
	exgpc	b6


#*******************************
* Watch dog disable
* Note: Call while interrupts are turned off

 SUBR	WDOGDIS

	.if	TUNIT=0

	PUSH	a0,a1,a2,a3,a4

	pushst
	setf	16,1,0

	movi	#dis_t,a1
	move	@SYSCOPY,a2
	movk	1,a3
	movi	SYSCTRL,a4
	move	*a1+,a0

#lp	or	a2,a0
	move	a0,*a4
	xor	a3,a0
	move	a0,*a4
	move	*a1+,a0
	jrnn	#lp

	move	a2,*a4

	popst
	PULL	a0,a1,a2,a3,a4
	rets


#dis_t	.word	0,0,0,0, 2,0,2,0, -1	;WATCH DOG DISABLE TABLE

	.else

	rets

	.endif


****************************************************************
* Display IRQ

DIRQ
	mmtm	sp,b0,b1,b2,b3,b4,b5,b6,b7,b11
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14


	setf	1,0,0
	move	sp,@INTPEND+DIP		;Clear int pending
	move	sp,@INTENB+DIP		;Disable display int

	eint				;Let DMA int run

	setf	16,1,0			;Word sign extend
	MOVE	@ROLLING_COUNT,A1
	INC	A1
	MOVE	A1,@ROLLING_COUNT

	movi	DPYCTL,a8

	move	*a8,a7			;>Shift register read to restart DMA
	movi	NIL|DXV|SRT|>10,a0
	move	a0,*a8
	movi	510*>1000,a2		;*Autoerase lines
	pixt	*a2,a2			;Mem to shift reg xfer


	move	@dirqdraw,a0
	jrnz	di50			;In draw code?

	move	b13,b0
	jrn	#chkmp			;DMA done?


	move	@GAMSTATE,a0
	jrn	#chkmp			;In diagnostics? (B13 invalid)

	movi	26000/4,a1		;>Make sure DMA is OK
#dqwait	cmp	b13,b0
	jrne	di50			;DMAQ changed?
	dsj	a1,#dqwait

	.if	DEBUG
	trap	29
	.endif

	clr	a1
	move	a1,@DMACTRL		;Timed out
	move	a1,@DMACTRL
	subk	1,a1
	move	a1,b13

di50	move	a7,*a8			;Restore
	jruc	#60hzcode		;Skip flip


#chkmp	move	@dirqtimer,a1
	jrnz	di50			;Mproc not done?

	move	@dpageflip,a2
	jrz	di400			;Flipping off?


	movi	-4,a0			;Page0
	movi	PAGE1YO*>1000,b2	;*Page1
	move	@dpage,a1
	jrnz	#onp1
	movi	->1004,a0		;Page1
	clr	b2			;*Page0
#onp1	move	a0,@DPYSTRT		;If we don't page flip next time
	move	a0,@DPYADR		;Override DPYSTRT
	not	a1			;Flip
	move	a1,@dpage


	dint
	movi	26000/8,a1		;>Wait on last DMA
#dwait	move	@DMACTRL,a0
	jrnn	#dmaoff			;DMA stopped?
	dsj	a1,#dwait
	move	a1,@DMACTRL		;Timed out
	.if	DEBUG
	trap	29
	.endif
#dmaoff

	move	a2,a2
	jrn	#noerase		;Erase off?

	movi	CONTROL,a9		;>Clear whole page
	move	*a9,a6

;NEW - This is a bug - NEVER Turn OFF CAS before RAS Refreshes
;There is a possibility that by putting an 8 in the CONTROL register
;the Dynamic RAM device's (Bitmap RAM and/or Scratch RAM) could lose
;data. Because the amount of time that CAS before RAS refreshes are turned
;off is very short, the probabilty of actual data loss is minimal.  Data
;loss could occur if the CAS before RAS refreshes are shut off just prior
;to a refresh cycle occuring.  This is not very likely though because of the
;asynchronous nature of the 34010's refresh cycles.  Setting the control
;register to 0ch will guarentee that there will be no possibilty of losing
;refresh cycles to the DRAM and VRAM devices.  This NOTE is here simply to
;explain the reason for the code change below.
;  --->	movk	8,a0 <---

	MOVk	0ch,a0

	move	a0,*a9			;Transparency off
	movk	16,a0
	move	a0,@PSIZE
	movi	SCRN_PTCH*2,b3		;Pitch (2 lines)
	PUSH	b10,b11,b12,b13,b14
	movi	[127,1],b7		;Rows:Columns
	fill	l
	PULL	b10,b11,b12,b13,b14

	move	a6,*a9			;Restore
	movk	PXSIZE,a0
	move	a0,@PSIZE		;Normal
#noerase

di400	move	a7,*a8			;Restore
	eint


	calla	pal_transfer		;Copy new PALs

	move	@IRQSKYE,@ERASELOC	;Copy bkgnd color
;	move	@COLRTEMP,a0,L
;	jrz	#notindiag
;	movi	CYCOLORS,a1
;	move	a0,*a1+,L		;Copy diagnostics color cycler
;	move	@COLRTEMP+32,*a1,L
;#notindiag

	callr	switch_stack		;Scan misc switches

	movk	1,a0

	move	a0,@dirqdraw

	setf	1,0,0			;Enable display int
	move	a0,@INTENB+DIP
	setf	16,1,0


	calla	DISPLAY			;Build DMAQ, update XYPOS

	dint
	clr	a0
	move	a0,@dirqdraw		;Draw done

#60hzcode				;*** This code must run at 60HZ

	move	@_clk_rd,a2,L		;Increment the time get counter
	jrn	_no_gt			;If negative then no auto clock update
	addk	1,a2
	move	a2,@_clk_rd,L
	cmpi	1,a2			;Time to transfer the time?
	jrz	_gt			;BR = yes go get time
	xori	01bh,a2			;Time to trigger time aquisition?
	jrnz	_no_gt			;BR = nope - exit
	move	a2,@_clk_rd,L		;Set counter back to 0
	calla	_aquire_time		;Trigger time aquistion
	jruc	_no_gt			;Done
_gt
	calla	_get_time		;Transfer time from PIC
	move	@_tseconds,a2,W		;Seconds = 0 ?
	jrnz	_no_gt			;BR = Nope - all done
	calla	_AlarmClock		;else - go check for alarm functions
_no_gt

	movi	FSWITCH,a4
	move	@_switch_addr,a2,L
	move	*a2,a0
	move	@_switch2_addr,a2,L
	move	*a2,a1
	move	@_coin_addr,a2,L
	move	*a2,a2
	sll	16,a2
	movy	a2,a0
	not	a0
	move	@_dipswitch_addr,a2,L
	move	*a2,a2
	sll	16,a2
	movy	a2,a1
	not	a1

	move	@TWOPLAYERS,a14		;if 2-player kit then fudge
	jrz	#not_2			;the switches

	clr	a2
	movx	a0,a2
	sll	8,a2
	movx	a2,a0
	srl	8+8,a2
	movx	a2,a1

#not_2
	move	a0,*a4+,L
	move	a1,*a4+,L

	move	*a4(64),a2,L		;>switches_cur
	move	*a4(96),a3,L		;>switches_cur+32
	move	a2,*a4+,L		;>switches_old
	move	a3,*a4+,L		;>switches_old+32
	move	a0,*a4+,L		;>switches_cur
	move	a1,*a4+,L		;>switches_cur+32
	move	a2,a14
	xor	a0,a14
	and	a14,a0			;down transitions
	and	a14,a2			;up transitions
	move	a3,a14
	xor	a1,a14
	and	a14,a1			;down transitions
	and	a14,a3			;up transitions
	move	a2,*a4+,L		;>switches_up
	move	a3,*a4+,L		;>switches_up+32
	move	a0,*a4+,L		;>switches_down
	move	a1,*a4+,L		;>switches_down+32


	move	@dirqtimer,a1		;Tell mproc to run
	addk	1,a1
	move	a1,@dirqtimer

	callr	switch_stack		;Scan misc switches

	MOVK	5,A1
	MOVI	C_FLAGS,A2
ALL_COUNTERS_DONE
	MOVB	*A2,A3
	JRZ	NO_WORRY_COUNTER
	SUBK	1,A3
	MOVE	A3,*A2
NO_WORRY_COUNTER
	ADDK	8,A2
	DSJS	A1,ALL_COUNTERS_DONE


	dint
	setf	1,0,0			;Enable display int
	movk	1,a1
	move	a1,@INTENB+DIP
	setf	16,1,0


	move	@dirqcnt,a0
	addk	1,a0
	move	a0,@dirqcnt
	sll	32-3,a0
	jrnz	dirqx			;Skip?


					;>Do every 8 ticks
	.if	DEBUG
	.else
	move	@dirqtimer,a0
	cmpi	400,a0
	jahs	init_prog		;Reset?
	.endif


	move	@C_FRAC,a0		;>Count down coin fraction timer
	jrz	#nfrc			;No frac?
	sll	32-8,a0
	srl	32-8,a0
	subk	1,a0
	move	a0,@C_FRAC
#nfrc

					;>Coin counters
	move	@COINCNTR,a0,L
	jrz	l_dog			;Counters, timers inactive?

	movk	2,a4			;do both counters
	movi	COINCNTR,a5
ccntr0l
	movb	*a5,a1			;more counts for counter ?
	jrz	c_cntr0			;no
	movb	*a5(16),a2		;previous pulse time out?
	jrnz	c_cntr0			;no
	movk	2,a2
	movb	a2,*a5(16)		;start new pulse
	dec	a1			;decrement counts
	movb	a1,*a5
c_cntr0
	addk	8,a5
	dsjs	a4,ccntr0l

	clr	a2			;counter on mask
;	movi	>100,a3
	movk	1,a3
	movk	2,a4
c_cntr1l
	movb	*a5,a0			;counter timer active?
	jreq	c_cntr1			;no
	dec	a0			;yes, dec it and store
	movb	a0,*a5
	jreq	c_cntr1			;done
	add	a3,a2			;turn counter solenoid on
c_cntr1
	sll	1,a3
	addk	8,a5
	dsjs	a4,c_cntr1l

	move	@_coin_counter_addr,a0,L
	ori	32,a2

	andi	21h,a2			;only set bits 5 and maybe 0.

	move	a2,*a0,W

l_dog
	.if	TUNIT2
;	move	a0,@WATCHDOG		;Hit
	move	@_watchdog_addr,a0,L
	move	a0,*a0
	.else

	movi	wdogbone_t,a1		;>Clock watchdog
	move	@SYSCOPY,a2
	movk	1,a3
	movi	SYSCTRL,a4
	move	*a1+,a0

roverl	or	a2,a0
	move	a0,*a4
	xor	a3,a0
	move	a0,*a4
	move	*a1+,a0
	jrnn	roverl			;More?

	move	a2,*a4			;Restore
	.endif

	move	@VCOUNT,a14
	move	a14,@dma_bog

dirqx	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14
	mmfm	sp,b0,b1,b2,b3,b4,b5,b6,b7,b11
	reti


wdogbone_t
	.word	0,2,0,2,2,-1		;Watchdog feed table



#*******************************
* Scan switches

 SUBRP	switch_stack

	move	@_coin_addr,a0,L	;Get coin door extras
	move	*a0,a0,W

	move	@GAMSTATE,a1,W		;In diagnostics?
	jrn	#no_diptest
	move	@_dipswitch_addr,a1,L	;No. Map TEST dipswitch to coin door
	move	*a1,a1,W		; TEST switch
	sll	4-0,a1			;Dip TEST bit0 -> coin TEST bit4
	ori	~BIT4,a1		;Keep the rest of the coin door bits
	and	a1,a0

#no_diptest
	ori	>ffff0000,a0		;Pull unused bits UP

	move	@swtemp2,a2,W		;Get previous previous state
	move	@swtemp1,a1,W		;Get previous state
	move	a1,@swtemp2,W		;Save new previous previous
	move	a0,@swtemp1,W		;Save new previous
	and	a1,a2			;Only stack if UP then UP & now DOWN
	andn	a0,a2			; (new DOWNS now pos logic)
	jrz	#x			;None to do if 0

	move	@swstack_p,a3,L		;Current switch stack ptr
	movk	>1f,a1			;XOR constant

#lp	cmpi	swstackbot,a3		;Switch stack overflow?
	jreq	#x
	lmo	a2,a0
	sll	a0,a2			;Get rid of DOWN bit
	sll	1,a2
	xor	a1,a0			;Do 1's comp to get true bit #
	move	a0,-*a3,W		;Push switch # (0-15)
	rl	a0,a2			;Restore remaining DOWN bits
	jrnz	#lp			;Continue if more are DOWN (!0)

	move	a3,@swstack_p,L		;Save new stack ptr

#x	rets


**************************************************************************
* badtrapx - Come here when a trap is hit that is not defined and log it

badtrap31
badtrap30
badtrap28
badtrap27
badtrap26
badtrap25
badtrap24
badtrap23
badtrap22
badtrap21
badtrap20
badtrap19
badtrap18
badtrap17
badtrap16
badtrap15
badtrap14
badtrap13
badtrap12
badtrap11
badtrap9
badtrap8
badtrap7
badtrap6
badtrap5
badtrap4
badtrap3
;badtrap2

;WRITE TO CODE/IMAGE ROM
wrom_int


	.if	IMGVIEW
;Allow me to exit TV and go into IT to tweak these mofo's
	PUSH	a14
	movi	SYSCINIT,a14
	xori	02000h,a14
	move	a14,@SYSCTRL
	ori	02000h,a14
	move	a14,@SYSCTRL
	PULL	a14
	eint
	reti
	.endif


	
	.if	DEBUG

;If debug, just	lockup so we can fix it.
	LOCKUP
	eint
	.else

;If shipping code, audit the error and clear the int
	PUSH	a14
	movi	SYSCINIT,a14
	xori	02000h,a14
	move	a14,@SYSCTRL
	ori	02000h,a14
	move	a14,@SYSCTRL
	PULL	a14
	CALLERR	9,0
	eint
	.endif

	reti

badtrap
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	9,0
	.endif

	reti

badtrap29
	.if	DEBUG
	reti
;	LOCKUP			;A write to ROM!
	.endif
	jruc	badtrap


******************************************************************************
* trap3_handler - Security Trap
* a1 = Security Service Identifier
*      0 = SetAddresses (I/O address remap)
* a0 = Data for particular Security Service
*      Security Service		Value
*            0			Don't Care
 SUBR trap3_handler
	sll	5,a1
	addi	_SecurityFunctions,a1
	move	*a1,a1,L
	call	a1
	reti


;Initial GSP I/O register values

gspioinit_t
;NEW - Values change because dot clock is twice as fast.
;	.word	015h		;>C0000000 -- HESYNC
;	.word	HEBLNKINIT	;>C0000010 -- HEBLNK
;	.word	0fah		;>C0000020 -- HSBLNK
;	.word	0fch		;>C0000030 -- HTOTAL

	.word	02bh		;>C0000000 -- HESYNC
	.word	HEBLNKINIT	;>C0000010 -- HEBLNK
	.word	01f5h		;>C0000020 -- HSBLNK
	.word	01f9h		;>C0000030 -- HTOTAL

	.word	3		;>C0000040 -- VESYNC
	.word	20		;>C0000050 -- VEBLNK
	.word	274		;>C0000060 -- VSBLNK	;254 lines
	.word	288		;>C0000070 -- VTOTAL
	.word	>f010		;>C0000080 -- DPYCTL	ENV|NIL|DXV|SRE|>10
	.word	0fffch		;>C0000090 -- DPYSTRT
	.word	EOSINT		;>C00000A0 -- DPYINT 
	.word	2ch		;>C00000B0 -- CONTROL
	.word	0		;>C00000C0 -- HSTDATA
	.word	0		;>C00000D0 -- HSTADRL
	.word	0		;>C00000E0 -- HSTADRH
	.word	0		;>C00000F0 -- HSTCTLL
	.word	0		;>C0000100 -- HSTCTLH
	.word	0		;>C0000110 -- INTENBL
	.word	0		;>C0000120 -- INTPEND
	.word	0		;>C0000130 -- CONVSP
	.word	0		;>C0000140 -- CONVDP
	.word	PXSIZE		;>C0000150 -- PSIZE
	.word	0		;>C0000160 -- PMASK
	.word	0		;>C0000170 -- RESERVED
	.word	0		;>C0000180 -- RESERVED
	.word	0		;>C0000190 -- RESERVED
	.word	0		;>C00001A0 -- RESERVED
	.word	28		;>C00001B0 -- DPYTAP
giiend


;Initialize all 32 trap vectors

	.sect	"VECTORS"

	.long	badtrap31	;TRAP 31
	.long	badtrap30	;TRAP 30	ILLOP --- ILLEGAL OPCODE
	.long	badtrap29	;TRAP 29
	.long	badtrap28	;TRAP 28
	.long	badtrap27	;TRAP 27
	.long	badtrap26	;TRAP 26
	.long	badtrap25	;TRAP 25
	.long	badtrap24	;TRAP 24
	.long	badtrap23	;TRAP 23
	.long	badtrap22	;TRAP 22
	.long	badtrap21	;TRAP 21
	.long	badtrap20	;TRAP 20
	.long	badtrap19	;TRAP 19
	.long	badtrap18	;TRAP 18
	.long	badtrap17	;TRAP 17
	.long	badtrap16	;TRAP 16
	.long	badtrap15	;TRAP 15
	.long	badtrap14	;TRAP 14
	.long	badtrap13	;TRAP 13
	.long	badtrap12	;TRAP 12
	.long	badtrap11	;TRAP 11	WV --- WINDOW VIOLATION
	.long	DIRQ		;TRAP 10	DI --- DISPLAY INTERRUPT
	.long	badtrap9	;TRAP 9		HI --- HOST INTERRUPT
	.long	badtrap8	;TRAP 8		NMI -- NONMASKABLE INTERRUPT
	.long	badtrap7	;TRAP 7
	.long	badtrap6	;TRAP 6
	.long	badtrap5	;TRAP 5
	.long	badtrap4	;TRAP 4
	.long	trap3_handler	;TRAP 3		Security Trap
	.long	wrom_int	;TRAP 2		INT2 --- EXTERNAL INTERRUPT 2
;		.long	badtrap3	;TRAP 3
;		.long	badtrap2	;TRAP 2		INT2 --- EXTERNAL INTERRUPT 2
	.long	dma_irq		;TRAP 1		INT1 --- EXTERNAL INTERRUPT 1
	.long	init_prog	;TRAP 0		RESET


	.end
