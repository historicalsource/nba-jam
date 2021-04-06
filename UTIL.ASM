**************************************************************
*
* Owner:	none
*
* Software:	? and Shawn Liptak
* Initiated:	?
*
* Modified:	Shawn Liptak, 7/?/91	-Improved FLASHME, added FRANIMQ
* 		Shawn Liptak, 7/?/91	-New and improved random stuff
* 		Shawn Liptak, 9/13/91	-Fixed various junk (STRINGER)
* 		Shawn Liptak, 10/5/91	-Added DELTAY to FRANIMQ
* 		Shawn Liptak, 10/20/91	-Improved GETCPNT
* 		Shawn Liptak, 1/4/92	-QDMAN mods
* 		Shawn Liptak, 2/11/92	-Started basketball (cleanup)
* 		Shawn Liptak, 12/10/92	-Added security code
* 		Shawn Liptak, 3/16/93	-Fixed coin misses from wipeout
* 		Jeff Johnson, 4/12/95	-Updated for WWF hardware
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/22/93 16:25
*.Last mod - 4/12/95 11:02am
**************************************************************
	.file	"util.asm"
	.title	"utility subroutines"
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"gsp.equ"
	.include	"sys.equ"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"macros.hdr"		;Macros


;utility subroutine equates

	.def	SCRCLR
	.def	OBJOFF,OBJON
	.def	STRLNRM,STRCNRM,STRCNRMO,STRLNRMO,STRCNRMO_1,CYCLE_TABLE
	.def	BLNKAREA
	.def	FRANIM,FRANIMQ
	.def	STRNGLEN
	.def	STRRNRM,FILLAREA

	.ref	pal_init,pal_getf,pal_find,pal_set,PALRAM,WFLG


	.ref	plyrobj_t,plyrproc_t
	.ref	P1CTRL,P1DATA
	.ref	SOUNDSUP,WSPEED
	.ref	gndstat
	.ref	COLRTEMP,GAMSTATE

	.ref	display_init
	.ref	dirqtimer
	.ref	SYSCOPY
	.ref	dpageflip,IRQSKYE

	.ref	BAKBITS
	.ref	GET_ADJ

	.ref	tvpanelon
	.ref	DMAQCUR,DMAQ,QDMAN

	.def	STRNGRAM,HEXTOASC,GETANIX,WRLD
	.def	COLCYC,CYCLE_TABLE,FLASHME



	BSSX	RAND		,32		;Last random #
	.bss	STRNGRAM	,20*16
	.bss	WRLD		,16
	BSSX	LOWZ		,16

	.text

********************************
* Flash screen white

 SUBR	flash_white

	movi	[0909h,0000h],a1	;[color,pal]
	movi	[256,400],a2		;[Ysz,Xsz]
	clr	a3			;[Ypos,Xpos]
	clr	a4			;SAG
	movi	DMACAL,a5		;[offset,ctrl]
	calla	QDMAN
	rets

********************************
* Kill all background objects

 SUBR	KILBGND

	MMTM	SP,A0,A2,A3,A4,A5
	MOVI	BAKLST,A2,L	;ACTIVE BACKGROUND OBJECTS LIST
	MOVE	*A2,A0,L
	JREQ	KILOBX		;BR=NO MORE OBJECTS ON LIST
FREEB
	MOVE	A2,A3		;SAVE PREVIOUS
	MOVE	*A2,A2,L	;GET NEXT BLOCK
	JREQ	KILOBX		;BR=ALL DONE
	MOVE	*A2,*A3,L	;LINK AROUND IN ACTIVE LIST	
	MOVE	@OFREE,A5,L	;LINK INTO FREE LIST AT START
	MOVE	A5,*A2,L
	MOVE	A2,@OFREE,L	;UPDATE FREE LIST POINTER
	MOVE	A3,A2
	JRUC	FREEB		;KILL ALL OBJECTS ON BACKGROUND LIST
KILOBX
	CALLR	ZERO_BITS
	MOVE	A0,@BAKLST,L
	MMFM	SP,A0,A2,A3,A4,A5
	RETS

********************************

 SUBR	ZERO_BITS

	CLR	A0
	MOVI	10000/16,A2	;SIZE OF BAKBITS IN WORDS
	MOVI	BAKBITS,A1
KILUP
	MOVE	A0,*A1+,W
	DSJS	A2,KILUP
	RETS

; SUBR	SPECIAL_WIPEOUT
;	CALLR	WIPEOUT2
;	JAUC	SPECIAL_DISPLAY_INIT

**************************************************************************
* Wipes the system clear of all other processes, objects
* and coordinates. It returns with display processor disabled
* color ram cleared, and the bit map wiped clean.

 SUBR	WIPEOUT

	callr	dirq_wait

	calla	display_init

	pushst
	dint
	calla	pal_init
	POPST


 SUBR	WIPEOUT2

;	callr	security_chk		;Rets: A0=0 if OK!


	movi	plyrproc_t,a1		;These must be cleared!
	movi	plyrobj_t,a2
	movi	P1CTRL,a3
	movk	4,a7
#l1	move	a0,*a1+,L
	move	a0,*a2+,L
	move	a0,*a3+
	dsj	a7,#l1

	clr	a0
	move	a0,@gndstat
	move	a0,@dtype
	move	a0,@tvpanelon

	move	a0,@WFLG
	movk	OWSPD,a1
	move	a1,@WSPEED

	move	a0,a1
	calla	KILALL			;Kill all processes

	callr	ZERO_BITS
	callr	dpageflip_off
	clr	a0
	move	a0,@SOUNDSUP		;Allow sounds
	move	a0,@IRQSKYE
;	move	a0,@DISPLAYON		;TURN THE DISPLAY PROCESSOR OFF

	pushst
	dint

	move	@SYSCOPY,a0		;>Init sysctrl

	.if	WWFUNIT
	movi	SYSCINIT,a1
	.else
	srl	8,a0
	sll	8,a0
	movi	SYSCINIT&>ff,a1		;Don't touch 7seg LED
	.endif

	or	a1,a0
	move	a0,@SYSCOPY
	move	a0,@SYSCTRL

	popst
	callr	dirq_wait		;Now wait for vblank to zap color map
	rets


#*******************************
* Save display/process lists and variables of active game
* A13=*Process that stays running
* Trashes scratch, A2-A7

	.bss	sysstate_t	,16*50		;Mem for state save
	.bss	svproc_p	,32		;*Saved proc list
	.bss	pal_t		,32*NMFPAL	;Mem for pal save

SSS	.macro	a
	move	@:a:,*a1+
	.endm
SSSL	.macro	a
	move	@:a:,*a1+,L
	.endm

 SUBR	system_savegame

	movi	sysstate_t,a1

	SSSL	OBJLST
	SSSL	BAKLST
	SSSL	WORLDTLX
	SSSL	WORLDTLY

	SSS	IRQSKYE
	SSSL	COLRTEMP
	SSS	dtype
	SSS	dpageflip
	SSS	gndstat

	SSS	GAMSTATE

	movi	plyrproc_t,a2
	movi	plyrobj_t,a3
	movi	P1CTRL,a4
	movk	4,b0
#lp	move	*a2+,*a1+,L
	move	*a3+,*a1+,L
	move	*a4+,*a1+
	dsj	b0,#lp


	movi	ACTIVE,a2
	movi	svproc_p,a4
	jruc	#prnxt

#prlp	cmp	a13,a2
	jreq	#prnxt			;Me?

	move	*a2(PROCID),a14
	jrn	#prnxt			;Indestructible?

	move	*a2,*a3,L		;Unlink
	move	a2,*a4,L		;Add it to save list
	move	a2,a4
	move	a3,a2
#prnxt
	move	a2,a3
	move	*a2,a2,L
	jrnz	#prlp

	clr	a0
	move	a0,*a3,L
	move	a0,*a4,L

	move	a0,@OBJLST,L		;Null lists
	move	a0,@BAKLST,L
	move	a0,@gndstat

	callr	ZERO_BITS


	movi	PALRAM,a0		;>Save pal ptrs
	movi	pal_t,a1
	movi	NMFPAL,b0
#plp	move	*a0+,*a1+,L
	dsj	b0,#plp

	calla	pal_init

	rets


#*******************************
* Restore state of system_savegame
* Trashes scratch, A2-A8

SRS	.macro	a
	move	*a1+,a0
	move	a0,@:a:
	.endm
SRSL	.macro	a
	move	*a1+,a0,L
	move	a0,@:a:,L
	.endm

 SUBR	system_restoregame

	clr	a0
	move	a0,@DISPLAYON

	clr	a1
	calla	KILALL			;Kill all processes
	calla	KILBGND			;Kill old background
	movi	-1,a1
	calla	obj_delc		;Kill all objs

	calla	pal_init

	movi	pal_t,a3		;>Restore pal ptrs
	movi	PALRAM,a4
	clr	a5
	movi	NMFPAL,a7
#plp
	move	*a3+,a0,L		;Get * pal
	move	a0,*a4+,L
	jrz	#nxtp
	move	a5,a1
	sll	8,a1			;Pal offset
	move	*a0+,a2			;Get # colors in pal
	calla	pal_set			;Setup pal transfer
#nxtp	addk	1,a5
	cmpi	NMFPAL/2,a7
	jrne	#skipslp
	PUSHP	a3,a4,a5,a7
	PULL	a8			;Get our rets addr so we can sleep
	SLEEPK	1			;Split the transfer
	PUSH	a8
	PULLP	a3,a4,a5,a7
#skipslp
	dsj	a7,#plp


	movi	sysstate_t,a1

	SRSL	OBJLST
	SRSL	BAKLST
	SRSL	WORLDTLX
	SRSL	WORLDTLY

	SRS	IRQSKYE
	SRSL	COLRTEMP
	SRS	dtype
	SRS	dpageflip
	SRS	gndstat

	SRS	GAMSTATE

	movi	plyrproc_t,a2
	movi	plyrobj_t,a3
	movi	P1CTRL,a4
	movk	4,b0
#lp	move	*a1+,*a2+,L
	move	*a1+,*a3+,L
	move	*a1+,*a4+
	dsj	b0,#lp


	movi	ACTIVE,a2		;>Find end of list
#prlp
	move	a2,a3
	move	*a2,a2,L
	jrnz	#prlp

	move	@svproc_p,*a3+,L	;Link


	movk	1,a0
	move	a0,@DISPLAYON

	rets



********************************
* Clear all world coordinates and scroll velocities

; SUBRP	world_clr
;
;	clr	a0
;	move	a0,@SCROLLX,L		;X SCROLL VALUE
;	move	a0,@SCROLLY,L		;Y SCROLL VALUE
;	move	a0,@WORLDTLX,L		;TOP LEFT X SCREEN COORD (WORLD)
;	move	a0,@WORLDTLY,L		;TOP LEFT Y SCREEN COORD (WORLD)
;	move	a0,@WORLDTL,L
;	movi	SCRNST,a0
;	move	a0,@SCRNTL,L
;	movi	SCRNEND,a0
;	move	a0,@SCRNLR,L
;	rets


****************************************************************
*
* Animation script code by SL
*
****************************************************************

********************************
* Run an animation script (Process)


	BSSX	animscnt	,16	;# anim scripts running

	STRUCTPD
	APTR	animslobj_p		;*Last obj created
	LONG	animsv			;Temp value
	WORD	animsbx			;Base X
	WORD	animsby			;Base Y
	WORD	animsfnum		;# FRANIMs running
	APTR	animslp_p		;*Loop point table pos
;Careful!
	APTR	animslp_t		;(*Loop point, Loop cnt)*5


 SUBR	anim_script		;A8=*Script

	clr	a9

 SUBRP	anim_script2		;A8=*Script, A9=Base Y:X

	move	a9,*a13(animsbx),L	;Save XY

	move	*a13(PROCID),a11
	subi	ANIMPID,a11
	srl	8,a11
	sll	8,a11			;A11=ID offset (0->300)

	clr	a1
	move	a1,*a13(animsfnum)
	move	a13,a1
	addi	animslp_t,a1
	move	a1,*a13(animslp_p),L

anslp	move	*a8+,a1			;Get command

	addi	anims_t,a1
	move	*a1,a1,L
	jump	a1

	.long	asEND
anims_t	.long	asNEW,asDEL,asDELM,asFRA
	.long	asANI,asHIDE,asSHOW,asPAL
	.long	asXY,asXYRNG,asYA,asXYV
	.long	asXYVA,asXYV0,asZ,asBXY
	.long	asSLP,asSLP1,asSLPR
	.long	asWAIT,asTXT
	.long	asTXTR,asTXTK,asLAB,asLABR
	.long	asDSJ,asDSJS1,asJMP,asJMPR,asJMPEQ
	.long	asJMPNE,asRUN,asRUNI,asCRE
	.long	asKIL,asASM,asSND,asSNDD
	.long	asADDW
	.long	asADDWO,asADDLO,asADLVO,asSVRL
	.long	asSVRLT,asSVL


asNEW					;>New objects
	move	*a8+,a9,L		;Get data
	PUSH	a8
ans100	move	*a9+,a2,L		;*Image
	move	*a9+,a0,L		;Get XY
	move	*a13(animsbx),a3,L
	addxy	a3,a0			;Add base
	clr	a1
	movy	a0,a1
	sll	16,a0
	move	*a9+,a3			;Z
	move	*a9+,a4			;Flags
	addi	M_NOCOLL,a4
	move	*a9+,a5			;ID
	addi	CLSANIM,a5
	add	a11,a5			;+offset
	clr	a6
	clr	a7
	calla	BEGINOBJ
	move	*a9,a0
	cmpi	-1000,a0
	jrne	ans100			;End?
	move	a8,*a13(animslobj_p),L	;Save * to last one
	PULL	a8
	jruc	anslp

asFRA					;>FRANIM
	move	a11,a6			;Save a11
	move	*a8+,a9,L		;Get data
	move	*a13(PROCID),a1		;Inherit same ID+1
	addk	1,a1
	move	*a8+,a10		;OID
	jrn	ans250			;No ID?
	addi	CLSANIM,a10
	add	a11,a10			;+offset
	move	*a8+,a11		;#Loops
	jrn	ans220
	move	*a13(animsfnum),a2	;+1 FRANIM cnt
	addk	1,a2
	move	a2,*a13(animsfnum)
ans220	movi	anims_franim,a7
	calla	GETPRC
	move	a13,*a0(anfc_p),L
	move	a6,a11
	jruc	anslp

ans250	addk	16,a8			;Skip #loops
	move	a8,a10
	move	*a13(animslobj_p),a8,L	;Get * to last one
	movi	FRQDELDIE,a7
	calla	GETPRC
	move	a10,a8
	jruc	anslp


asSLP					;>SLEEP
	move	*a8+,a0			;Get time
	calla	PRCSLP
	jruc	anslp

asSLP1					;>SLEEP 1
	movk	1,a0
	calla	PRCSLP
	jruc	anslp

asSLPR					;>Sleep random
	move	*a8+,a0			;Get time
	move	*a8+,a1
	callr	RNDRNG
	calla	PRCSLP
	jruc	anslp

asWAIT					;>Wait on FRANIMs
	SLEEPK	2
	move	*a13(animsfnum),a1
	jrnz	asWAIT
	jruc	anslp

asXY					;>New XY rel to current pos
	move	*a8+,a1			;Get ID
	move	*a8+,a2
	move	*a8+,a4
	move	*a8+,a5
asxyhs					;Entry for HIDE/SHOW
asxyr	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans720	callr	obj_find
	jrz	anslp
	move	*a0(OXPOS),a6		;New X
	add	a4,a6
	move	a6,*a0(OXPOS)
	move	*a0(OYPOS),a6		;New Y
	add	a5,a6
	move	a6,*a0(OYPOS)
	move	*a0,a0,L
	jrnz	ans720
	jruc	anslp

asXYRNG					;>New XY rel to current pos in rndrng
	move	*a8+,a0
	move	*a8+,a1
	callr	RNDRNG
	move	a0,a4
	move	*a8+,a0
	move	*a8+,a1
	callr	RNDRNG
	move	a0,a5
	move	*a8+,a1
	jrn	asxyr5			;No ID?
	move	*a8+,a2
	jruc	asxyr

asxyr5	addk	16,a8			;Skip mask
	move	*a13(animslobj_p),a0,L	;Get * to last one
	move	*a0(OXPOS),a6		;New X
	add	a4,a6
	move	a6,*a0(OXPOS)
	move	*a0(OYPOS),a6		;New Y
	add	a5,a6
	move	a6,*a0(OYPOS)
	jruc	anslp

asYA					;>Set Y ani pt world relative
	move	*a8+,a1
	move	*a8+,a2			;Mask
	move	*a8+,a5			;
	sll	16,a5
	move	@WORLDTLY,a0,L
	add	a0,a5
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
asya10	callr	obj_find
	jrz	asya90

	PUSH	a1,a2
	move	*a0(OIMG),a1,L
	move	*a0(OSIZE),a2,L
	move	*a0(OCTRL),a4
	calla	GANIOF
	move	*a0(OXVAL),a3,L
	add	a6,a3			;Old X
	move	a5,a2			;New Y
	calla	GANISAG
	PULL	a1,a2

	move	*a0,a0,L
	jrnz	asya10
asya90	jruc	anslp

asXYV					;>Set XYVel
	move	*a8+,a4,L
	move	*a8+,a5,L
	move	*a8+,a1
	move	*a8+,a2
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans920	callr	obj_find
	jrz	anslp
	move	*a0(OXVEL),a6,L
	add	a4,a6
	move	a6,*a0(OXVEL),L
	move	*a0(OYVEL),a6,L
	add	a5,a6
	move	a6,*a0(OYVEL),L
	move	*a0,a0,L
	jrnz	ans920
	jruc	anslp

asXYVA					;>Set XYVel absolute
	move	*a8+,a4,L
	move	*a8+,a5,L
	move	*a8+,a1
	move	*a8+,a2
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans1020	callr	obj_find
	jrz	anslp
	move	a4,*a0(OXVEL),L
	move	a5,*a0(OYVEL),L
	move	*a0,a0,L
	jrnz	ans1020
	jruc	anslp

asXYV0					;>XYVel = 0
	move	*a13(animslobj_p),a0,L	;Get * to last one
	clr	a1
	move	a1,*a0(OXVEL),L
	move	a1,*a0(OYVEL),L
	jruc	anslp

asZ					;>Set Z pos
	move	*a8+,a1
	move	*a8+,a2
	move	*a8+,a4
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans1120	callr	obj_find
	jrz	anslp
	move	a4,*a0(OZPOS)
	move	*a0,a0,L
	jrnz	ans1120
	jruc	anslp

asLAB					;>Set label
	move	*a8+,a0
anslab	move	*a13(animslp_p),a2,L
	move	a8,*a2+,L		;Save *
	move	a0,*a2+
	move	a2,*a13(animslp_p)
	jruc	anslp

asLABR					;>Set label randomly
	move	*a8+,a0
	move	*a8+,a1
	callr	RNDRNG
	jruc	anslab

asDSJS1					;>Sleep 1, dec and loop to label
	SLEEPK	1

asDSJ					;>Decrement and loop to label
	move	*a13(animslp_p),a1,L
	move	-*a1,a2
	subk	1,a2
	move	a2,*a1
	jrz	ans1330
	move	-*a1,a8,L		;Get *Loop
	jruc	anslp
ans1330	subk	32,a1			;Del loop entry
	move	a1,*a13(animslp_p),L
	jruc	anslp

asPAL					;>Set palette
	move	*a13(animsv),a0,L	;Get *Pal
	calla	pal_getf
	move	a0,a4
	move	*a8+,a1
	jrn	ans1450
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
	clr	a2			;No mask
ans1420	callr	obj_find
	jrz	anslp
	move	a4,*a0(OPAL)
	move	*a0,a0,L
	jrnz	ans1420			;More?
	jruc	anslp

ans1450	move	*a13(animslobj_p),a0,L	;Get * to last obj
	move	a4,*a0(OPAL)
	jruc	anslp

asANI					;>Do ANI on OID
	move	*a8+,a5,L
	move	*a8+,a1			;OID
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
	clr	a2			;No mask
ans1620	callr	obj_find
	jrz	anslp
	move	a8,a9
	move	a1,a3
	move	a5,a1			;*Img
	move	a0,a8			;*Obj
	move	*a8(OCTRL),a4		;Same flags
	calla	ANI
	move	a3,a1
	move	a8,a0
	move	a9,a8
	move	*a0,a0,L
	jrnz	ans1620			;More?
	jruc	anslp

asDEL					;>Delete obj
	move	*a8+,a0
	clr	a1
asdel5	addi	CLSANIM,a0
	add	a11,a0			;+offset
	calla	obj_delc
	jruc	anslp

asDELM					;>Delete obj with mask
	move	*a8+,a0
	move	*a8+,a1
	jruc	asdel5

asRUN					;>Run a new anim script
	move	*a8+,a0,L
	move	*a13(PROCID),a1		;Inherit same ID
asrun5	move	a8,a10
	move	a0,a8			;*Script
	move	*a13(animsbx),a9,L	;Get base XY
	movi	anim_script2,a7
	calla	GETPRC
	move	a10,a8
	jruc	anslp

asRUNI					;>Run a new anim script with ID
	move	*a8+,a0,L
	move	*a8+,a1
	addi	ANIMPID,a1
	add	a11,a1			;+offset
	jruc	asrun5

asCRE					;>Create a process
	move	*a8+,a7,L
	move	*a8+,a9,L		;Pass A9 to process
	movi	ANIMPID+>ff,a1
	add	a11,a1			;+offset
	calla	GETPRC
	jruc	anslp

asKIL					;>Kill processes with mask
	move	*a8+,a0
	addi	ANIMPID,a0
	add	a11,a0			;+offset
	move	*a8+,a1
	calla	KILALLN
	jruc	anslp

asJMP					;>Jump to new location
	move	*a8+,a8,L
	jruc	anslp

asJMPR					;>Jump to new location if RND<#
	move	*a8+,a4,L
	movi	999,a0			;.1 % resolution
	callr	RNDRNG0
	move	*a8+,a1
	cmp	a1,a0
	jrhs	anslp
	move	a4,a8			;Do jmp
	jruc	anslp

asJMPEQ					;>Jump to new location if = to mem
	move	*a8+,a0,L
	move	*a0,a0			;Get value
	move	*a8+,a2,L
	move	*a8+,a1
	cmp	a1,a0
	jrne	anslp			;Not same?
	move	a2,a8			;Do jmp
	jruc	anslp

asJMPNE					;>Jump to new location if != to mem
	move	*a8+,a0,L
	move	*a0,a0			;Get value
	move	*a8+,a2,L
	move	*a8+,a1
	cmp	a1,a0
	jreq	anslp			;Same?
	move	a2,a8			;Do jmp
	jruc	anslp

asSNDD					;>Do a snd call in demo
	movk	ADJMUSIC,a0		;Get demo music ON/OFF
	calla	GET_ADJ
	jrz	asSND			;Do sounds?
	addk	32,a8
	jruc	anslp
asSND					;>Do a snd call
	move	*a8+,a0,L
	calla	snd_play1
	jruc	anslp

asASM					;>Inline code
	exgpc	a8
	jruc	anslp

asHIDE					;>Hide an OID (X+5000)
	movi	5000,a4
ashide2	move	*a8+,a1
	clr	a2
	clr	a5
	jruc	asxyhs

asSHOW					;>Show an OID (X-5000)
	movi	-5000,a4
	jruc	ashide2

asADDW					;>Add WORD to mem
	move	*a8+,a0,L
	move	*a8+,a1
	move	*a0,a2
	add	a1,a2
	move	a2,*a0
	jruc	anslp

asADDWO					;>Add WORD to last obj+offset
	move	*a8+,a0
	move	*a13(animslobj_p),a1,L	;Get * to last one
	move	*a8+,a2			;Offset
	add	a2,a1
	move	*a1,a2
	add	a0,a2
	move	a2,*a1
	jruc	anslp

asADDLO					;>Add LONG # to last obj+offset
	move	*a8+,a0,L
	move	*a13(animslobj_p),a1,L	;Get * to last one
	move	*a8+,a2			;Offset
	add	a2,a1
	move	*a1,a2,L
	add	a0,a2
	move	a2,*a1,L
	jruc	anslp

asADLVO					;>Add LONG value to last obj+offset
	move	*a8+,a0
	move	*a13(animslobj_p),a1,L	;Get * to last one
	add	a0,a1			;+Offset
	move	*a13(animsv),a0,L	;Get value
	move	*a1,a2,L
	add	a0,a2
	move	a2,*a1,L
	jruc	anslp

asSVRL					;>Set value to rnd long
	move	*a8+,a0,L
	move	*a8+,a1,L
	callr	RNDRNG
	move	a0,*a13(animsv),L
	jruc	anslp

asSVRLT					;>Set value to rnd long from a table
	move	*a8+,a4,L
	move	*a4+,a0			;#Table entries
	subk	1,a0
	callr	RNDRNG0
	sll	5,a0			;*32
	add	a0,a4
	move	*a4,a0,L
	move	a0,*a13(animsv),L
	jruc	anslp

asSVL					;>Set value to long
	move	*a8+,a0,L
	move	a0,*a13(animsv),L
	jruc	anslp

asBXY					;>Add # to BaseXY
	move	*a8+,a0,L
	move	*a13(animsbx),a1,L
	addxy	a0,a1
	move	a1,*a13(animsbx),L
	jruc	anslp

asTXTR					;>Print rnd text from table
	move	*a8+,a4,L
	move	*a4+,a0			;#Table entries
	subk	1,a0
	callr	RNDRNG0
	sll	5,a0			;*32
	add	a0,a4
	move	*a4,a0,L
	jruc	astxt5

asTXT					;>Print text
	move	*a8+,a0,L
astxt5
;	calla	prt0_xy
	jruc	anslp


asTXTK					;>Kill text
	PUSHP	a8
	callr	ERASE_TXT
;	movk	4,a11			;Save A11!
;	JSRP	text_shrink		;Sleeps
	PULLP	a8
	jruc	anslp


asEND	SLEEPK	1			;>Wait on FRANIMs before exit
	move	*a13(animsfnum),a1
	jrnz	asEND
	DIE



********************************
* Animation of a part (Process)

	STRUCTPD
	APTR	anfc_p		;*AnimScrpt process that made me, set by AS
	APTR	anfl		;*Franim list


 SUBRP	anims_franim		;A9=*FRAN list, A10=OID, A11=# Loops

	move	@OBJLST,a8,L		;>Find object
anf100	move	*a8(OID),a0
	cmp	a10,a0
	jreq	anf300
	move	*a8,a8,L
	jrnz	anf100
	jruc	anf700			;No match!

anf300	move	a9,*a13(anfl),L
anf340	JSRP	FRANIMQ
	move	*a13(anfl),a9,L		;Go to 1st
	move	a11,a11
	jrn	anf340			;-=Infinite
	dsj	a11,anf340

anf700	move	a11,a11
	jrn	anf800
	move	*a13(anfc_p),a0,L	;Get *Creator
	move	*a0(animsfnum),a2	;#Frans-1
	subk	1,a2
	move	a2,*a0(animsfnum)
anf800	DIE



********************************
* Wait for animation processes to finish

 SUBR	anim_wait

anw10	SLEEPK	3
	move	@animscnt,a1
	jrgt	anw10
	RETP

********************************
* Wait 50 and kill anim stuff (Process)

 SUBR	anim_kilslp

	SLEEP	50
	callr	anim_killall
	DIE


********************************
* Kill all animation processes and objects

 SUBR	anim_killall

	clr	a0
	move	a0,@animscnt

	movi	ANIMPID,a0	;>Kill processes
	movi	>3ff,a1
	calla	KILALLN

	movi	CLSANIM,a0	;>Delete objs
	movi	>3ff,a1
	jauc	obj_delc



********************************
* Find an object by OID
* A0=*1st obj
* A1=OID
* A2=!Mask
* >A0=*Obj or 0 (Z)
* Trashes A1,A3

 SUBRP	obj_find

	andn	a2,a1
of20	move	*a0(OID),a3
	andn	a2,a3		;Remove bits
	cmp	a1,a3
	jreq	of50
	move	*a0,a0,L
	jrnz	of20
of50	move	a0,a0		;A0=*Obj or 0
	rets			;Pass CC






#***************************************************************
* Reset autoerase color for fixing scrn glitches
* Trashes scratch

 SUBR	autoerase_set

	pushst
	dint
	callr	dma_wait		;Wait on dma

	clr	a0
	move	a0,@DMACMAP
	movi	ERASECOL,a0		;Color pair
	movi	510*512*8,a1		;Store to last 2 lines of bitmap
	movi	512*8*2/16,b0
#lp	move	a0,*a1+
	dsj	b0,#lp

	popst

	rets

#*******************************
* Flash an image by making a constant color
* A8=*Image to flash
* A9=Color to flash with (Ex. 0202h,a9)

FLASHME

	move	*a8(OCONST),a0
	jrnz	#x			;Flashing?

	move	a9,*a8(OCONST)
	setf	4,0,0
	movk	M_CONNON,a0		;Replace non-zero data with constant
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0

	SLEEPK	2

	clr	a0
	move	a0,*a8(OCONST)		;Clr color

	setf	4,0,0
	movk	M_WRNONZ,a0
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0

#x	DIE

 .if 0
#*******************************
* Flash an image by making a constant color
* A8=*Image to flash
* A9=Color to flash with *64K

FLASHME
	move	*a8(OCONST),a10
	jrnz	#x			;Flashing?
	srl	16,a9
	move	a9,*a8(OCONST)		;Set color
	move	*a8(OCTRL),a0
	movk	8,a1
	or	a1,a0			;Set constant
	move	a0,*a8(OCTRL)
	SLEEPK	2
	clr	a0
	move	a0,*a8(OCONST)		;Clr color
	move	*a8(OCTRL),a0
	andi	>fff5,a0		;Clr constant & nonzero
	addk	2,a0			;Set nonzero
	move	a0,*a8(OCTRL)
#x	DIE
 .endif

********************************
*CHEAP COLOR CYCLER
*CYCLES ANY NUMBER OF COLORS
*A8=PALETTE NAME
*A9=RAM STORAGE AREA
*A10=MSW START COLOR, LSW END COLOR
*A11=SPEED, A11=NEGATIVE FOR REVERSE CYCLER

COLCYC	
	SLEEPK	4
	MOVE	A8,A0
	calla	pal_find
	JRZ	COLCYC		;WAIT TILL IT SHOWS UP FOLKS...

	CLR	A1		;GET THE COLORS INTO RAM
	MOVX	A10,A1		;GET END COLOR
	SRL	16,A10		;ADJUST START COLOR
	SUB	A10,A1		;GET COUNT
	MOVE	A1,*A13(PDATA)	;SAVE COUNT
	MOVE	A1,A4
	SLL	4,A1		;COUNT IN WORDS
	MOVE	A10,A5
	SLL	4,A5		;OFFSET INTO PALETTE
	ADD	A8,A5
	ADDK	16,A5		;SKIP PALETTE WORD COUNT
	MOVE	A9,A3
	MOVE	A9,A6
	ADD	A1,A6
	MOVE	A6,A8

COLCYC1	MOVE	*A5+,A7		;TRANSFER IT TWICE
	MOVE	A7,*A3+
	MOVE	A7,*A6+
	DSJS	A4,COLCYC1

	SRL	8,A0
	SLL	8,A0
	ADD	A0,A10			;COLRAM DESTINATION

COLCYCB
	MOVE	A8,*A13(PDATA+>20),L	;SAVE RAM ADDRESS
COLCYCBL
	MOVE	A8,A0			;GET SOURCE ADDRESS
	MOVE	A10,A1			;GET DESTINATION CONSTANT
	MOVE	*A13(PDATA),A2,W	;GET COUNT
	calla	pal_set
	SUBK	16,A8
	CMP	A8,A9
	JRLO	CCYCBSLP
	MOVE	*A13(PDATA+>20),A8,L	;GET SOURCE TABLE START
CCYCBSLP
	MOVE	A11,A0		;GET SLEEP TIME
	CALLA	PRCSLP
	JRUC	COLCYCBL


#*******************************
* CYCLE A PAL WITH A FIXED ROM COLOR TABLE
* A8= [COLOR # TO START AT,# TO CYCLE]
* A9= PAL NAME TO CYCLE
* A10=TABLE TO CYCLE IT WITH
* A11=RATE OF CYCLE IN TICKS

CYC0	SLEEP	60

CYCLE_TABLE
	MOVE	A9,A0			;PAL NAME TO CYCLE
	calla	pal_find
	jrz	CYC0
	SRL	8,A0
	SLL	8,A0
	MOVY	A8,A1
	SRL	16,A1			;A1=COLOR # TO START WITH
	MOVE	A8,*A13(PDATA)		;PDATA WILL HAVE # TO CYCLE (CNT)
	MOVE	*A10,A2,W
	MOVE	A2,*A13(PDATA+16)	;VALUE IN TABLE TO STOP AT
	MOVE	A0,A8			;A8=[PAL #,0]
	ADD	A1,A8			;A8=[PAL #,COLOR TO START AT]
	MOVE	A10,A9			;A10=ROM TABLE TO CYCLE WITH
#loop	move	a8,a1
	MOVE	A9,A0			;A0=TABLE POSITION
	MOVE	*A13(PDATA),A2		;A2=COLOR COUNT
	calla	pal_set			;do the transfer
	MOVE	A11,A0
	CALLA	PRCSLP
	ADDK	>10,A9
	MOVE	*A9,A0
	JRN	RESTUFF
	MOVE	*A13(PDATA+16),A1	;PDATA+16=ENTRY WE STOP AT
	CMP	A0,A1
	jrne	#loop
RESTUFF	MOVE	A10,A9			;REACHED END OF TABLE, RESTUFF
	jruc	#loop


****************************************************************
* Converts a 32 bit hex # to a null terminated ascii string
* A8=#
* >A8=*String

HEXTOASC
	PUSH	a1,a2,a9
	clr	a1
	move	a1,-*sp			;Push the null terminator
	movk	10,a1			;Divisor for decimal
	move	a8,a9
hexta1	movk	3,a2			;Comma count
hexta2	clr	a8
	divu	a1,a8
	addi	'0',a9			;Make the remainder ascii
	move	a9,-*sp			;Save here
	move	a8,a9
	jrz	hexta3			;Done?
	dsj	a2,hexta2
	movi	',',a2
	move	a2,-*sp			;Stuff a comma
	jruc	hexta1

hexta3	movi	STRNGRAM,a1		;Store here for blow out
	move	a1,a8
hexta4	move	*sp+,a9
	movb	a9,*a1
	addk	8,a1
	move	a9,a9
	jrnz	hexta4

	PULL	a1,a2,a9
	rets


********************************
* Erase all text objects

 SUBR	ERASE_TXT

	movi	CLSNEUT|TYPTEXT|SUBTXT,a0
	jauc	obj_del1c


**************************************************************************
*
* STRINGER - OUTPUT A TEXT STRING, THIS IS A PROCESS!
* A0  = SLEEP TIME BETWEEN CHARACTERS
* A4  = DMA CONTROL
* A6  = COLOR (16 BITS)
* A8  = PTR TO STRING
* A9  = [Y,X] SCREEN ADDRESS OF STRING
* A10 = [Y,X] SPACING
* A11 = POINTER TO FONT TABLE
* A14 = FLAGS:JUSTIFY
*	BIT 16 = 1 INSERT ON OBJECT LIST, 0 JUST QUEUE THE DMA
*	JUSTIFY = 0 LEFT JUSTIFY
*		  1 CENTER JUSTIFY
*		  2 RIGHT JUSTIFY
* WRLD = ADJUST FOR WORLD COORDINATES
* LOWZ+20000=ZPOS
*
* RETURNS:
* A8 = POINTS TO NEXT BYTE AFTER STRING TERMINATOR
* A9 = NEXT CURSOR POSITION AFTER THE STRING
* NOTE: CALL WITH JSRP
*
**************************************************************************

;LEFT JUSTIFY, NORMAL, NOT PUT ON THE OBJECT LIST
STRLNRM
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ|M_NOCOLL,a4
	clr	a14
	jruc	stringr1

;CENTER JUSTIFY, NORMAL, NOT ON THE OBJECT LIST
STRCNRM
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ|M_NOCOLL,a4
	movk	1,a14
	jruc	stringr1
;CENTER JUSTIFY, NORMAL, DMA, MULTIPLE COLORS
 SUBR	STRCNRM_1
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMAWNZ|M_NOCOLL,a4
	movk	1,a14
	move	a6,a5
	jruc	stringr1_1

;RIGHT JUSTIFY, NORMAL, NOT PUT ON THE OBJECT LIST
STRRNRM
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ|M_NOCOLL,a4
	movk	2,a14
	jruc	stringr1

;LEFT JUSTIFY, INVERTED, NOT ON THE OBJECT LIST
;STRLINV
;	mmtm	a12,a1,a2,a3,a4,a6,a14
;	MOVI	DMACZ,A4
;	clr	a14
;	jruc	stringr1

;CENTER JUSTIFY, INVERTED, NOT ON THE OBJECT LIST
;STRCINV
;	mmtm	a12,a1,a2,a3,a4,a6,a14
;	MOVI	DMACZ,A4
;	movk	1,a14
;	jruc	stringr1
;

;LEFT JUSTIFY, NORMAL, OBJECT LIST
STRLNRMO
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ|M_NOCOLL,a4
	movi	>10000,a14
	jruc	stringr1

;CENTER JUSTIFY, NORMAL, OBJECT LIST
STRCNRMO
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ|M_NOCOLL,a4
	movi	>10001,a14
	jruc	stringr1

;CENTER JUSTIFY, NORMAL, OBJECT LIST, MULTIPLE COLORS!
STRCNRMO_1
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMAWNZ|M_NOCOLL,a4
	movi	>10001,a14
	move	a6,a5
	jruc	stringr1_1

;LEFT JUSTIFY, NORMAL, OBJECT LIST, MULTIPLE COLORS!
 SUBR	STRLNRMO_1
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMAWNZ|M_NOCOLL,a4
	movi	>10000,a14
	move	a6,a5
	jruc	stringr1_1

STRINGER
	mmtm	a12,a1,a2,a3,a4,a6,a14
stringr1
	move	a6,a5
	sll	16,a5			;Setup constant color in fixed palette
stringr1_1

	clr	a7
	movx	a14,a7
	subk	1,a7
	jrn	strr10			;Normal left justify
	jrz	strrc

	callr	STRNGLEN		;Right justify
	jruc	strra

strrc	callr	STRNGLEN		;Center justify
	srl	1,a7			;STRNGLEN/2

strra	subxy	a7,a9			;Adjust string starting position
	jruc	strr10			;Start loop


strr1	addk	5,a9			;Add a space
strr5	addxy	a10,a9			;Add spacing

strr10	movb	*a8,a1			;Get a character
	jrle	strrx			;Done?
	addk	8,a8			;Next byte

	subk	32,a1
	jrle	strr1			;Space?

					;Save sleep time
strr20	PUSH	a0

	subk	1,a1			;>Calc table offset
	sll	5,a1			;*32
	add	a11,a1
	move	*a1,a1,L		;Get * image header
	move	*a1(ICTRL),a3

	PUSH	a1,a14
	
	btst	16,a14
	jrz	strrdma			;Only do DMA?

	move	a1,a2

	calla	GETOBJ			;Create the character as an object
	jrz	strrdun			;No object?

	move	a2,*a0(OIMG),L
	move	*a2(ISAG),*a0(OSAG),L
	move	a4,*a0(OFLAGS)		;FIX!!!!!
	move	a5,*a0(OPAL),L		;&CONST
	movi	01000100h,a1
	move	a1,*a0(OSCALE),L

	move	a4,a1
	andi	>803f,a1		;Kill mode bits
	or	a1,a3
	move	a3,*a0(OCTRL),L		;&OFSET

	movi	CLSNEUT|TYPTEXT|SUBTXT,a14
	move	a14,*a0(OID)

	move	@LOWZ,a14
	addi	20000,a14
	move	a14,*a0(OZPOS)

	clr	a2
	move	a2,*a0(OXVEL),L
	move	a2,*a0(OYVEL),L
	move	a2,*a0(OZVEL),L

	movy	a9,a2			;Y
	move	a9,a3
	sll	16,a3			;X
	calla	GANISAG

	move	@WRLD,a2
	jrnz	strr100
	calla	obj_addworldxy		;Put us in the world

strr100	calla	INSOBJ
	jruc	strrdun


strrdma	PUSH	a3			;>Simple DMA
	move	*a1,a2,L		;ISIZE
	move	*a1(ISAG),a3,L		;Get top left sag
	calla	GANIOF
	move	a5,a1			;Constant:Palette
	PULL	a5
	PUSH	a4
	andi	>803f,a4
	or	a4,a5			;Offset:Control
	move	a3,a4			;SAG

	move	a9,a3			;A3=Y:X
	srl	16,a6
	movx	a6,a7
	subxy	a7,a3			;Sub anioffset

	calla	QDMAN
	PULL	a4
	move	a1,a5

strrdun	PULL	a1,a14

	move	*a1,a1			;Get ISIZEX
	addxy	a1,a9			;Add X size
	move	*sp+,a0,L
	jrz	strr5			;No sleep?

	mmtm	a12,a0,a4,a5,a14
	calla	PRCSLP
	mmfm	a12,a0,a4,a5,a14
	jruc	strr5

strrx	clr	a1
	move	a1,@LOWZ
	addk	8,a8			;Next byte
	mmfm	a12,a1,a2,a3,a4,a6,a14
	RETP


**************************************************************************
* STRNGLEN - RETURNS THE LENGTH, IN PIXELS, OF A GIVEN STRING
* A8 = PTR TO STRING
* A10 = [Y,X] SPACING OF STRING
* A11 = PTR TO FONT TABLE
* RETURNS:
* A7 = LENGTH OF STRING
* Z BIT SET IF LENGTH IS ZERO
**************************************************************************
STRNGLEN
	PUSH	a8,a14
	clr	a7		;A7=Length
	jruc	stl60

stl10	addk	8,a8		;Point to next
	subk	32,a14
	jrgt	stl20		;Good char?
	addk	5,a7		;Hard code a space
	jruc	stl40

stl20	subk	1,a14
	sll	5,a14		;*32
	add	a11,a14		;A14=*Correct character header
	move	*a14,a14,L
	move	*a14,a14	;Get ISIZEX

	addxy	a14,a7		;Add char length
stl40	addxy	a10,a7		;Add space length
stl60	movb	*a8,a14
	jrgt	stl10		;Next character?

	PULL	a8,a14
	zext	a7
	rets



**************************************************************************
*									 *
* OBJOFF - TURN AN OBJECT "OFF" I.E. SET DMA OUTPUT TO 0		 *
* A0 = PTR TO OBJECT BLOCK						 *
*									 *
**************************************************************************
OBJOFF
	PUSH	A4
	MOVE	*A0(OCTRL),A4
	SRL	4,A4
	SLL	4,A4
	MOVE	A4,*A0(OCTRL)
	move	*sp+,a4,L
	RETS

**************************************************************************
*									 *
* OBJON - TURN AN OBJECT "ON" I.E. SET DMA OUTPUT TO WRITE <> 0		 *
* A0 = PTR TO OBJECT BLOCK						 *
*									 *
**************************************************************************
OBJON
	PUSH	A4
	MOVE	*A0(OCTRL),A4
	SRL	4,A4
	SLL	4,A4
	ADDK	2,A4
	MOVE	A4,*A0(OCTRL)
	move	*sp+,a4,L
	RETS

	
**************************************************************************
*									 *
* CLRPDATA - CLEAR THE PDATA AREA OF A PROCESS BLOCK			 *
* A13 = PTR TO PROCESS BLOCK						 *
*									 *
**************************************************************************
;CLRPDATA
;	MMTM	SP,A1,A6,A14
;	MOVE	A13,A14
;	CLR	A1
;	ADDI	PDATA,A14
;	MOVI	(PSDATA-PDATA)/16,A6
;CLRSHL
;	SRL	1,A6
;	JRNC	CLRPDL
;	MOVE	A1,*A14+,W	;STUFF THE ODD WORD	
;CLRPDL
;	MOVE	A1,*A14+,L		
;	DSJS	A6,CLRPDL
;	MMFM	SP,A1,A6,A14
;	RETS
**************************************************************************
*									 *
* DFRMGRND - RETURNS THE DISTANCE FROM THE BOTTOM OF			 *
*		   AN OBJECT TO THE "GROUND."				 *
* A8 = OBJECT BLOCK							 *
* RETURN(S)								 *
* A1 = DISTANCE FROM GROUND (16 BITS)					 *
* STATUS BITS SET ACCORDING TO THE SIGN OF A1				 *
* NOTE: MAX ACCEPTABLE Y = +32K, MIN ACCEPTABLE Y = -32K		 *
*									 *
**************************************************************************
;ZORIGIN	EQU	200		;Y COORDINATE OF THE Z ORIGIN
;DFRMGRND
;	PUSH	A2
;	MOVE	*A8(OYPOS),A1,W
;	MOVE	*A8(OSIZEY),A2,W
;	ADD	A1,A2			;A2 = BOTTOM Y
;	MOVE	*A8(OZPOS),A1,W
;	SUB	A2,A1
;	ADDI	ZORIGIN,A1
;	MMFM	SP,A2
;	RETS

**************************************************************************
*									 *
* GET BOTTOM Y OF AN OBJECT						 *
* A8 = OBJECT BLOCK PTR							 *
* RETURN(S)								 *
* A1 = 16 BIT BOTTOM Y IN LSW						 *
* STATUS SET ACCORDING TO THE BOTTOM Y					 *
*NOTE: MAKE SURE OBLOCK IS INIT'D WITH GSAGOF BEFORE CALLING		 *
*									 *
**************************************************************************
;GETBOTY
;	PUSH	A2
;	MOVE	*A8(OYPOS),A1,W		;GET Y POSITION
;	MOVE	*A8(OSIZEY),A2,W	;GET THE CURRENT SIZE
;	ADD	A2,A1			;A1 = BOTTOM Y
;	MMFM	SP,A2
;	RETS


********************************
* GETCPNT - Get the center xy position of an object
* A8=*Object
* >A0=Center Y:Center X

 SUBR	GETCPNT

	move	*a8(OYVAL),a1,L
	move	*a8(OXPOS),a0
	movx	a0,a1
	move	*a8(OSIZE),a0,L
	srl	1,a0			;/2
	andi	>7fff7fff,a0		;Clr bit 15
	addxy	a1,a0
	rets


********************************
*GETANIX - GET ANIMATION POINT X COORD
*CALLING PARMS: A8=OBJECT
*RETURNS A0=16 BIT WORLD COORD OF UPPER LEFT

GETANIX
	MMTM	SP,A1,A2
	MOVE	*A8(OIMG),A1,L
	MOVE	*A1(IANIOFF),A2
	MOVE	*A8(OCTRL),A0
	BTST	B_FLIPH,A0
	JRZ	GETAX1
	MOVE	*A1,A0		;ISIZEX
	SUB	A2,A0
	DEC	A0
	MOVE	A0,A2
GETAX1	MOVE	*A8(OXPOS),A0
	ADD	A2,A0
	MMFM	SP,A1,A2
	RETS



****************************************************************
* Quickly produce a random # in range -X to +X
* A0=+X
* >A0=Random # (-A0 to +A0) (CC)
* Trashes scratch

 SUBR	RNDRNGS

	move	a0,a1
	neg	a0


********************************
* Quickly produce a random # in a given range
* A0=Lower bound
* A1=Upper bound
* >A0=Random # (A0 to A1) (CC)
* Trashes scratch

 SUBR	RNDRNG

	sub	a0,a1		;Normalize the range
	addk	1,a1
	move	a0,b0

	move	@RAND,a0,L
	rl	a0,a0
	move	@HCOUNT,a14
	rl	a14,a0
	add	sp,a0
	move	a0,@RAND,L

	mpyu	a1,a0
	move	b0,a1
	add	a1,a0
	rets


********************************
* Quickly produce a random # in range 0-X
* A0=X
* >A0=Random # (0 to A0) (No CC)
* Trashes scratch

 SUBR	RNDRNG0

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	addk	1,a0
	mpyu	a1,a0		;Condition codes not valid!

	rets


********************************
* Random % routine
* A0=Probability of event (0-1000) (0=0%, 1000=100%)
* >A0=0-999 (CC) (jrls nope, jrhi happened)
* Trashes scratch

 SUBR	RNDPER

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	move	a0,a14
	movi	1000,a0
	mpyu	a1,a0		;0-999
	cmp	a0,a14
	rets


**************************************************************************
*									 *
* FILLAREA - FILL A GIVEN SQUARE AREA ON THE SCREEN WITH A COLOR	 *
* A1 = [COLOR,PALETTE]							 *
* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
*									 *
**************************************************************************
FILLAREA
	PUSH	a0,a1,a2,a4,a5,a14
	jruc	areacon
**************************************************************************
*									 *
* BLNKAREA - BLANK A GIVEN SQUARE AREA ON THE SCREEN			 *
* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
*									 *
**************************************************************************
BLNKAREA
	PUSH	a0,a1,a2,a4,a5,a14
	clr	a1			;constant 0:palette 0
areacon
	move	a4,a2
	movi	IROM,a4			;Somewhere in image rom
	movi	DMACAL,a5
	calla	QDMAN
	PULL	a0,a1,a2,a4,a5,a14
	rets


********************************
* Wait till DIRQ
* Trashes A0-A1

 SUBR	dirq_wait

	move	@dirqtimer,a0
dirqwlp	move	@dirqtimer,a1
	cmp	a0,a1
	jreq	dirqwlp
	rets


********************************
* Wait on the DMA busy bit to clear
* Preserves A1

 SUBRP	dma_wait

dwlp	move	@DMACTRL,b0
	jrn	dwlp		;Busy?
	rets


********************************
* Wait for dma queue to empty, then wait for dma to finish
* the last one. Turn displayon off.

 SUBR	dmaq_wait

	move	@DISPLAYON,a1
	clr	a0
	move	a0,@DISPLAYON		;Display off

	move	@DMACTRL,b0
	jrnn	dqw20
dqw10	move	b13,b13
	jrge	dqw10
dqw20	callr	dma_wait
	move	a1,@DISPLAYON

	rets


********************************
* Turn page flipping and erasure off. Setup for page0
* Trashes scratch

 SUBR	dpageflip_off

	clr	a0
	move	a0,@dpageflip
	not	a0
	move	a0,@dpage
	movi	-4,a0			;Page0
	move	a0,@DPYSTRT

	rets

#*******************************
* Blank display by using HEBLNK
* Trashes scratch

 SUBRP	display_blank
	dint
#lp	move	@VCOUNT,a0
	cmpi	EOSINT,a0
	jrlt	#lp
	move	@HSBLNK,a0	;Blank screen
	move	a0,@HEBLNK
	eint

	rets

#*******************************
* Unblank display by resetting HEBLNK
* Trashes scratch

 SUBRP	display_unblank

	dint
#lp	move	@VCOUNT,a0
	cmpi	EOSINT,a0
	jrlt	#lp
	movi	HEBLNKINIT,a0
	move	a0,@HEBLNK
	eint

	rets


**************************************************************************
*									 *
* CRINIT - COLOR RAM INITIALIZATION, FIRST CLEAR ALL COLOR RAM, THEN	 *
*	 FILL WITH PALETTES.						 *
*									 *
**************************************************************************
CRINIT
	MMTM	SP,A0,A1,A2,A6
	MOVI	COLRAM,A1
	CLR	A0
	MOVI	10000H,A6,L
*CLEAR ALL COLOR PALETTES
CRINIT1
	MOVE	A0,*A1+,L	;STUFF TWO WORDS AT A TIME
	DSJS	A6,CRINIT1

	MMFM	SP,A0,A1,A2,A6
	RETS

**************************************************************************
*									 *
* CRLOAD - LOAD COLOR RAM FROM A ROM TABLE				 *
* A1 = START OF ROM TABLE						 *
* A2 = COLOR RAM START ADDRESS						 *
* A6 = PALETTE COUNT							 *
*									 *
**************************************************************************
CRLOAD
	MMTM	SP,A0,A1,A2
CRLOAD1
	MOVE	*A1+,A0,W	;GRAB FIRST COLOR FROM THIS TABLE
	JRN	CRLOAD4		;BR = NULL PALETTE
CRLOAD3
	MOVE	A0,*A2,W	;STUFF COLOR
	MOVE	*A1+,A0,W	;GRAB NEXT COLOR FROM THIS TABLE
	JRN	CRLOAD4		;BR = NEXT PALETTE
	ADDK	16,A2		;INC THIS WAY SO WE DON'T OVERRUN PALETTES
	JRUC	CRLOAD3

CRLOAD4
	ADDI	1000H,A2	;NEXT PALETTE
	SRL	12,A2
	SLL	12,A2		;MASK OFF LOW BULLSHIT
	DSJ	A6,CRLOAD1

	MMFM	SP,A0,A1,A2
	RETS


********************************
* CLEAR THE SCREEN (Kill this, only used by diagnostics)
* only call with interrupts disabled and the dma shut down, otherwise
* use clr_scrn

SCRCLR	CLR	A0

	MMTM	SP,A1,A2
	CLR	A1
	MOVE	A1,@CMAPSEL			;SELECT COLOR MAP 0
	MOVI	SCREEN,A1
	MOVI	(SCRNE-SCREEN)/32,A2
SCRLP	MOVE	A0,*A1+,L
	DSJS	A2,SCRLP

	MMFM	SP,A1,A2
	RETS



********************************
* Clear screen routine

 SUBR	CLR_SCRN

	mmtm	sp,a1,a2,a3
	move	@DISPLAYON,a3
;	clr	a1
;	move	a1,@DISPLAYON
	callr	dmaq_wait			;wait on dma
	clr	a0
	move	a0,@CMAPSEL			;Select color map 0
	movi	SCREEN,a1,L
	movi	((SCRNE-2000H)-SCREEN)/32,a2,L
clrlp	move	a0,*a1+,L
	dsjs	a2,clrlp
	move	a3,@DISPLAYON
	mmfm	sp,a1,a2,a3
	rets


********************************
* Animation list processor (JSRP)
* A1=Mode:	0=Process current frame
*		1=Process to end of list
*		4=Process current frame, no sleep (time retrn'd in a0)
* A8=*Object
* A9=*Ani list
* Rets:
* C set if end of animation list was hit
* A9=* to next frame or end of list
* Trashes scratch
*
* Animation script format
*	.long	*Image header or 0 if end
*	.word	Sleep time  <-- BITS 0 - 7 ARE THE SLEEP TIME
*			    <-- BITS 8 -15 ARE THE FLAGS:
*				Bit #	Flag
*				-----	----
*				8-12	Unused
*BNEWPAL  equ	13		13	New palette address is specified
*BFLIPBIT equ	14		14	New flip bits are specified
*			Flag hierarchy: 15-8
*			 Options should follow in this order


FRANIM
	PUSHP	a3,a4

	cmpi	ROM,a9			;Check for bogus script pointer
	jrlo	franerr

	move	a1,a3			;A3=Mode

franl	move	*a9+,a1,L
	jrz	frannd			;End?

	move	*a8(OCTRL),a4		;Current flags
	move	*a9+,a0			;Sleep time
	cmpi	>100,a0
	jrlo	fran2			;Just sleep?
	
	PUSH	a1,a2,a7

	btst	BFLIPBIT,a0
	jrz	frannobi		;No flip?
	move	*a9+,a2			;Get the new flip flags
	andni	(M_FLIPV|M_FLIPH),a4	;Clear the current flip status
	or	a2,a4			;Set flag bits

frannobi
	btst	BNEWPAL,a0
	jrz	frannopa		;No pal?

	move	a0,a7
	move	*a9+,a0,L		;Get *pal
	calla	pal_getf
	jrz	fran10			;No palette available?
	move	a0,*a8(OPAL)		;Store new palette
fran10
	move	a7,a0
frannopa
	PULL	a1,a2,a7
	sll	32-8,a0			;Kill special bits
	srl	32-8,a0

fran2
	calla	ANI			;Setup new animation

	cmpi	4,a3
	jreq	fran3			;One frame, no sleep?

	move	a3,-*a12
	calla	PRCSLP			;Sleep
	move	*a12+,a3
	jrnz	franl			;Loop til end of list?

fran3
	PULLP	a3,a4
	clrc				;Clear end flag
	RETP

frannd
	PULLP	a3,a4
	setc				;Return with end flag set
	RETP


franerr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	8,0			;Bad franim list
	.endif
	jruc	frannd


#***************************************************************
* Animation list processor (Quick list version) (JSRP)
* A8=*Object
* A9=*FRANIM List
* Trashes A0-A4,A14,B0-B1
*
* Script format
*	.long	*Image hdr or 0 if end
*	.word	Sleep time  <-- BITS 0 - 7 ARE THE SLEEP TIME
*			    <-- BITS 8 -15 ARE THE FLAGS:
*			BIT #		FLAG
*			-----		----
*			8-10,12		UNUSED
*BDELTAY	equ	11	Word is added into YPOS
*BNEWPAL	equ	13	New palette address is specified
*BFLIPBIT	equ	14	New flip bits are specified
*	Flag hierarchy: 15-8	Options should follow in this order


FRANIMQ

	cmpi	ROM,a9
	jrhs	frq80			;Franim list OK?

	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	8,0			;Bad franim list
	.endif
	jruc	#x


#lp	move	*a8(OCTRL),a4		;Current flags
	move	*a9+,a0			;Sleep time
	cmpi	>100,a0
	jrlo	frq70			;No special bits?
	
	btst	BFLIPBIT,a0		;New flip?
	jrz	frq40
	move	*a9+,a2			;Get the new flip flags
	andni	(M_FLIPV|M_FLIPH),a4	;Clear the current flip status
	or	a2,a4			;Set desired bits

frq40	btst	BNEWPAL,a0		;New palette ?
	jrz	frq60

	move	a0,a2
	move	a1,a3
	move	*a9+,a0,L		;Get the palette address
	calla	pal_getf		;Get a color map assignment
	jrz	frq50			;No palette available?
	move	a0,*a8(OPAL)		;Set new palette
frq50	move	a2,a0
	move	a3,a1

frq60	btst	BDELTAY,a0
	jrz	frq65
	move	*a9+,a2			;Get DY
	move	*a8(OYPOS),a3
	add	a2,a3
	move	a3,*a8(OYPOS)

frq65	sll	32-8,a0			;Kill special bits
	srl	32-8,a0

frq70	calla	ANI
	calla	PRCSLP			;Sleep

frq80	move	*a9+,a1,L		;Get frame
	jrnz	#lp

#x	RETP



#***************************************************************
* Hardware security check code (1b00000 & 1b80000)
* >A0=0 if OK
* Trashes scratch

;OFF	.equ	>69d2
;SEC	.equ	>1b15f50-OFF
;FAKEO	.equ	->b00050+OFF
;SECDB	.equ	0
OFF	.equ	>7db0
SEC	.equ	>1b14030-OFF
FAKEO	.equ	->b00030+OFF

 SUBR	security_chk

	PUSH	a2,a3,a4
	clr	a0
	movi	63,a3
#lp	move	a3,a14
	callr	#sc
	or	a2,a0
	subk	1,a3
	jrge	#lp
	PULL	a2,a3,a4
	rets

#sc
	movi	SEC+FAKEO,a1
	sll	15-5,a14
	add	a14,a1		;Add a bogus offset
	subi	FAKEO,a1
	move	a14,*a1(OFF)	;Write 1 of 64 to sec
	sub	a14,a1		;Sub offset so we read a different address
	move	*a1(OFF),a2	;Read 1st sec value
	sll	32-15,a2
	srl	32-6,a2
	sll	9,a2		;Move to bits 9-14
	xor	a14,a2
	sll	32-15,a2	;Remove top bits
	jrnz	#x		;Bad value?

	add	a14,a1
	srl	2+3,a14
	add	a14,a1
	pushst
	setf	6,0,0
	move	*a1(OFF+9),a2	;Read 2nd sec value
	move	a2,b1
	sll	24,b1
	getpc	a4
	addi	#sec_t-$,a4,W
	add	a4,a14
	move	*a1(OFF+>19),a2	;Read 3rd sec value
	move	a2,b0
	sll	16,b0
	or	b0,b1
	move	*a1(OFF+>29),a2	;Read 4th sec value
	move	a2,b0
	sll	8,b0
	or	b0,b1
	move	*a1(OFF+>39),a2	;Read 5th sec value
	move	a2,b0
	or	b0,b1
	popst
	move	*a14+,a2,L
	move	b1,a1
	andi	>3f3f3f3f,a1
	xor	a1,a2		;A2=0 if OK

#x	rets

#sec_t	.long	>21283b3b	;0
	.long	>2439383b
	.long	>31283b3b
	.long	>302b3938
	.long	>31283b3b
	.long	>302b3938
	.long	>232f2f2f
	.long	>26383b3b
	.long	>21283b3b	;20
	.long	>2439383b
	.long	>312a1224
	.long	>302b1120
	.long	>312a1224
	.long	>302b1120
	.long	>232d283b
	.long	>26383b3b
	.long	>2b3b3b3b	;40
	.long	>2e2e2e2e
	.long	>39383b1b
	.long	>383b3b1b
	.long	>3b3b3b1b
	.long	>3a3a3a1a
	.long	>2b3b3b3b
	.long	>2e2e2e2e
	.long	>2b39383b	;60
	.long	>2e2e2e2e
	.long	>393a1a18
	.long	>383b1b1b
	.long	>3b3b1b1b
	.long	>3a3a1a18
	.long	>2b39383b
	.long	>2e2e2e2e
	.long	>01202b3b	;80
	.long	>0431283b
	.long	>11202b3b
	.long	>1021283b
	.long	>11202b3b
	.long	>1021283b
	.long	>03273b3b
	.long	>06302b39
	.long	>09302b39	;A0
	.long	>0c232f2f
	.long	>19322e06
	.long	>18312a12
	.long	>19322e06
	.long	>18312a12
	.long	>0b31283b
	.long	>0e26383b
	.long	>03273b3b	;C0
	.long	>06302b39
	.long	>11202b3b
	.long	>1021283b
	.long	>13273938
	.long	>12243938
	.long	>03273b3b
	.long	>06302b39
	.long	>0b31283b	;E0
	.long	>0e26383b
	.long	>19322e06
	.long	>18312a12
	.long	>1b332f05
	.long	>1a302b11
	.long	>0b31283b
	.long	>0e26383b
	.def	secend
secend


;	.if	SECDB
;	clr	a0
;	rets
;	movi	SCRATCH,a5
;	clr	a0
;	clr	a3
;#tlp	move	a3,a14
;	callr	#sc
;	move	a1,*a5+,L
;	addk	1,a3
;	cmpi	128,a3
;	jrlt	#tlp
;
;	.else
;;ÄÄÄÄÄÄÄ
;	PUSH	a2,a3,a4
;	clr	a0
;	movi	128-1,a3
;#lp	move	a3,a14
;	callr	#sc
;	or	a2,a0
;	subk	1,a3
;	jrge	#lp
;	PULL	a2,a3,a4
;
;	.endif
;	rets
;
;;ÄÄÄÄÄÄÄ
;#sc
;	move	a3,a1
;	srl	6,a1		;Use bit 7 for security range (0 or 1)
;	sll	19,a1
;	addi	SEC+FAKEO,a1
;	sll	16-6,a14
;	add	a14,a1		;Add a bogus offset
;	subi	FAKEO,a1
;	move	a14,*a1(OFF)	;Write 1 of 64 to sec
;	sub	a14,a1		;Sub offset so we read a different address
;	move	*a1(OFF),a2	;Read 1st sec value
;	sll	32-15,a2
;	srl	32-6,a2
;	sll	9,a2		;Move to bits 10-15
;	xor	a14,a2
;	sll	32-15,a2	;Remove top bits
;	jrnz	#x		;Bad value?
;
;	add	a14,a1
;	srl	5,a14
;	add	a14,a1
;	pushst
;	setf	6,0,0
;	move	*a1(OFF+9),a2	;Read 2nd sec value
;	move	a2,b1
;	sll	24,b1
;	getpc	a4
;	addi	#sec_t-$,a4,W
;	add	a4,a14
;	move	*a1(OFF+>49),a2	;Read 3rd sec value
;	move	a2,b0
;	sll	16,b0
;	or	b0,b1
;	move	*a1(OFF+>89),a2	;Read 4th sec value
;	move	a2,b0
;	sll	8,b0
;	or	b0,b1
;	move	*a1(OFF+>c9),a2	;Read 5th sec value
;	move	a2,b0
;	or	b0,b1
;	popst
;	move	*a14+,a2,L
;	move	b1,a1
;
;	xor	a1,a2		;A2=0 if OK
;
;#x	rets

;#sec_t
;	.long	>00000000
;	.long	>04081020
;	.long	>08102000
;	.long	>0C183122
;	.long	>10200000
;	.long	>14281020
;	.long	>18312204
;	.long	>1C393326
;	.long	>20000001
;	.long	>24081021
;	.long	>28102000
;	.long	>2C183122
;	.long	>30200001
;	.long	>34281021
;	.long	>38312204
;	.long	>3C393326
;	.long	>00000102
;	.long	>04081122
;	.long	>08102102
;	.long	>0C183122
;	.long	>10200000
;	.long	>14281020
;	.long	>18312204
;	.long	>1C393326
;	.long	>20000103
;	.long	>24081123
;	.long	>28102102
;	.long	>2C183122
;	.long	>30200001
;	.long	>34281021
;	.long	>38312204
;	.long	>3C393326
;	.long	>00010204
;	.long	>04091224
;	.long	>08112204
;	.long	>0C193326
;	.long	>10210204
;	.long	>14291224
;	.long	>18312204
;	.long	>1C393326
;	.long	>20000001
;	.long	>24081021
;	.long	>28102000
;	.long	>2C183122
;	.long	>30200001
;	.long	>34281021
;	.long	>38312204
;	.long	>3C393326
;	.long	>00010306
;	.long	>04091326
;	.long	>08112306
;	.long	>0C193326
;	.long	>10210204
;	.long	>14291224
;	.long	>18312204
;	.long	>1C393326
;	.long	>20000103
;	.long	>24081123
;	.long	>28102102
;	.long	>2C183122
;	.long	>30200001
;	.long	>34281021
;	.long	>38312204
;	.long	>3C393326
;	.long	>00000000
;	.long	>01201028
;	.long	>02213018
;	.long	>03012030
;	.long	>04223138
;	.long	>05022110
;	.long	>06030120
;	.long	>07231108
;	.long	>08042231
;	.long	>09243219
;	.long	>0A251229
;	.long	>0B050201
;	.long	>0C261309
;	.long	>0D060321
;	.long	>0E072311
;	.long	>0F273339
;	.long	>10080422
;	.long	>1128140A
;	.long	>1229343A
;	.long	>13092412
;	.long	>142A351A
;	.long	>150A2532
;	.long	>160B0502
;	.long	>172B152A
;	.long	>180C2613
;	.long	>192C363B
;	.long	>1A2D160B
;	.long	>1B0D0623
;	.long	>1C2E172B
;	.long	>1D0E0703
;	.long	>1E0F2733
;	.long	>1F2F371B
;	.long	>20100804
;	.long	>2130182C
;	.long	>2231381C
;	.long	>23112834
;	.long	>2432393C
;	.long	>25122914
;	.long	>26130924
;	.long	>2733190C
;	.long	>28142A35
;	.long	>29343A1D
;	.long	>2A351A2D
;	.long	>2B150A05
;	.long	>2C361B0D
;	.long	>2D160B25
;	.long	>2E172B15
;	.long	>2F373B3D
;	.long	>30180C26
;	.long	>31381C0E
;	.long	>32393C3E
;	.long	>33192C16
;	.long	>343A3D1E
;	.long	>351A2D36
;	.long	>361B0D06
;	.long	>373B1D2E
;	.long	>381C2E17
;	.long	>393C3E3F
;	.long	>3A3D1E0F
;	.long	>3B1D0E27
;	.long	>3C3E1F2F
;	.long	>3D1E0F07
;	.long	>3E1F2F37
;	.long	>3F3F3F1F
;
;	.def	secend
;secend


	.end


