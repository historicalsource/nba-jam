**************************************************************
*
* Owner:	none
*
* Software:	?, Shawn Liptak and Mark Turmell
* Initiated:	4/13/89 (palstuff)
*
* Modified:	Shawn Liptak, 7/23/91	-New FADEIN/OUT (Total carnage)
* 		Shawn Liptak, 7/28/91	-Merged with fbstuff
* 		Shawn Liptak, 8/12/91	-PAL_TOWHT/PAL_FMWHT
* 		Shawn Liptak, 8/21/91	-Merged pall & palstuff
* 		Shawn Liptak, 9/13/91	-Clean up!
* 		Shawn Liptak, 9/17/91	-New PAL struct
* 		Shawn Liptak, 11/19/91	-Improved GETxPAL with CLNPAL
* 		Shawn Liptak, 2/20/92	-Basketball cleanup
* 		Shawn Liptak, 4/29/92	-Conditional bgndpal assembly
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 11/18/92 20:30
**************************************************************
	.title	"palette allocator and fader control"
	.file	"pal.asm"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"bgndtbl.glo"
	.include	"imgtbl.glo"
	.include	"game.equ"
	.include	"macros.hdr"
	.include	"plyrhd6.tbl"
	.include	"plyrhd6.glo"
	.include	"imgpal8.asm"
	.include	"mugshot.tbl"
	.include	"mugshot.glo"


;refs
	.ref	IRQSKYE
	.ref	DIAGP

;defs
	.def	BOON_F,TOBIAS_F,OURSL_F
	.def	EDDIE_F
	.def	FIFI_F
	.def	BUD_F
	.def	M_FIF_P
	.def	M_MAT_P,M_JOS_P,M_HEI_P,M_CRL_P,M_MAR_P
	.def	M_BOO_P,M_QUI_P,M_TOB_P,M_OUR_P,M_JAS_P

;equates

FPALNUM	.equ	8
FPALSZ	.equ	256*16


;ram

	.bss 	fade_start,16
	.bss	fade_end,16
	.bss	fade_inc,16
	.bss	fade_list,32		;list of palettes not to fade


	BSSX	PALRAM	,0		;Palette allocation ram
	BSSX	PALFRAM	,PALRSIZ*NMFPAL
	BSSX	PALBRAM	,PALRSIZ*NMBPAL
	BSSX	PALTRAM	,PALTSIZ*NUMPALT

	BSSX	FADERAM	,FPALSZ*NMFPAL	;Fade mem for palettes

	BSSX	palfmin	,16
	.bss	irqskyeo,16		;Orignal autoerase color


morfpal1	equ	FADERAM+0*16*64
morfpal2	equ	FADERAM+1*16*64
morfpal3	equ	FADERAM+2*16*64
morfpal4	equ	FADERAM+3*16*64
morfpal5	equ	FADERAM+4*16*64
morfpal6	equ	FADERAM+5*16*64
morfpal7	equ	FADERAM+6*16*64
morfpal8	equ	FADERAM+7*16*64
morfpal9	equ	FADERAM+8*16*64
morfpal10	equ	FADERAM+9*16*64
morfpal11	equ	FADERAM+10*16*64

	.def	morfpal1,morfpal2
	.def	morfpal3,morfpal4
	.def	morfpal5,morfpal6
	.def	morfpal7,morfpal8
	.def	morfpal9,morfpal10
	.def	morfpal11

	.text

********************************
* Note: Scratch = A0-A1,A14,B0-B1


#*******************************
* Clear out palette allocation and xfer ram
* Trashes scratch

 SUBR	pal_init

	movi	PALRAM,a0		;*Pal list
	movi	PALRSIZ*NUMPAL/16,b0	;# of words

	clr	a1
#l1	move	a1,*a0+
	dsj	b0,#l1

	movi	PALTRAM,a0		;*xfer ram
	movi	PALTSIZ*NUMPALT/16,b0	;# of words

#l2	move	a1,*a0+
	dsj	b0,#l2

;always start with DIAGP as pal 0!
	movi	DIAGP,a0
	callr	pal_getf
	rets


#*******************************
* Cleanup unused palettes
* Trashes A1,A14,B0-B1

 SUBR	pal_clean

	PUSH	a0,a2,a3,a4
	movi	PALRAM+PALRSIZ,a2	;Skip 1st pal

	movi	NUMPAL-1,a3		;Chk all pals
	movi	>0101,a4		;2nd PAL #

#lp	move	@OBJLST,a0,L
	jrz	cp30			;No objs, chk backgnd

cp20	move	*a0(OPAL),a14
	cmp	a14,a4
	jreq	cp80			;Used? Chk next
	move	*a0,a0,L
	jrnz	cp20

cp30	move	@BAKLST,a0,L		;Check in bgnd list
	jrz	cp60			;No objects, clean it out

cp50	move	*a0(OPAL),a14
	cmp	a14,a4
	jreq	cp80			;Used? Chk next
	move	*a0,a0,L
	jrnz	cp50

cp60
;	move	*a2,a0,L
;	cmpi	WARPP,a0
;	jrne	cp70			;Not warp pal?
;
;	movi	CYCPID,a0
;	movi	-1,a1
;	calla	EXISTP
;	move	a0,a0
;	jrnz	cp80			;Found cycler?

cp70	clr	a0			;Palette not used, free it
	move	a0,*a2,L

cp80	addi	>0101,a4		;Next pal
	.if	PAL64
	btst	4,a4
	jrz	cp90
	addi	>3030,a4
	sext	a4			;For compare
	.endif

cp90	addk	PALRSIZ,a2
	dsj	a3,#lp

	PULL	a0,a2,a3,a4
	rets


#*******************************
* Find the color map # to which the given palette is assigned
* A0=*Pallette
* >A0=PAL # (DMA format) or 0 (Z)
* Trashes scratch

 SUBR	pal_find

	movi	PALRAM,a1
	movi	NUMPAL,b0

#lp	move	*a1+,a14,L	;Get * palette
	cmp	a0,a14
	jreq	#ok		;Found?
	dsj	b0,#lp
	clr	a0		;Set Z
	rets

#ok	subi	NUMPAL,b0	;Compute pal #
	neg	b0
	move	b0,a1

	.if	PAL64
	movk	>f,a14
	and	a1,a14		;A14=4 low bits
	srl	4,a1		;Move B4/B5 to B6/B7
	sll	6,a1
	add	a14,a1
	.endif

	move	a1,a0		;Return pal #
	sll	8,a1
	add	a1,a0
	addk	1,a1		;Clr Z (OK)
	rets



#*******************************
* Get a foreground palette
* A0=*Palette
*Rets:
* A0=Color map allocated (0000-cfcf)
* Z set if no palette free
* Trashes scratch

 SUBR	pal_getf

	PUSH	a2,a3

	movi	PALRAM,a1	;>Check if palette already exists
	movi	NUMPAL,a3
gfp4	move	*a1+,a2,L	;Get *palette
	cmp	a0,a2
	jreq	getpn		;Already in color ram?
	dsj	a3,gfp4

	movi	PALFRAM,a1	;>Check for a spare palette
	movi	NMFPAL,a3
gfp8	move	*a1+,a2,L
	jrz	getfp		;Palette empty? Grab it
	dsj	a3,gfp8

	.if	DEBUG
;	LOCKUP
;	eint
	.endif
	callr	pal_clean

	movi	PALFRAM,a1	;>Check for a spare palette
	movi	NMFPAL,a3
gfp20	move	*a1+,a2,L
	jrz	getfp		;Palette empty? Grab it
	dsj	a3,gfp20

#err	PULL	a2,a3
	clr	a0		;Set Z error
	rets


********************************
* Get a background palette
* A0=*Palette
*Rets:
* A0=Color map allocated (0000-cfcf)
* Z set if no palette free
* Trashes scratch

	.if	NMBPAL

 SUBR	pal_getb

	PUSH	a2,a3

	movi	PALRAM,a1	;>Check if palette already exists
	movi	NUMPAL,a3
gbp4	move	*a1+,a2,L	;Get *palette
	cmp	a0,a2
	jreq	getpn		;Already in color ram?
	dsj	a3,gbp4

	movi	PALBRAM,a1	;>Check for a spare palette
	movk	NMBPAL,a3
gbp8	move	*a1+,a2,L
	jrz	gbp30		;Palette empty? Grab it
	dsj	a3,gbp8

	.if	DEBUG
	LOCKUP
	eint
	.endif
	callr	pal_clean

	movi	PALBRAM,a1	;>Check for a spare palette
	movk	NMBPAL,a3
gbp10	move	*a1+,a2,L
	jrz	gbp30		;Palette empty? Grab it
	dsj	a3,gbp10
	jruc	#err


getfp	addk	NMBPAL,a3	;>Setup your new palette

	.else
getfp

	.endif


gbp30	PUSH	a0,a1
	move	a3,a1		;Palette #
	subi	NUMPAL,a1	;Compute palette #
	neg	a1

	.if	PAL64
	movk	>f,a2
	and	a1,a2		;A2=4 low bits
	srl	4,a1		;Move B4/B5 to B6/B7
	sll	6,a1
	add	a2,a1
	.endif

	sll	8,a1		;*256
	move	*a0+,a2		;Get # colors in pal
	callr	pal_set		;Setup pal transfer
	mmfm	sp,a0,a1
	jrz	#err		;Failed to get transfer?
	move	a0,-*a1,L	;Stuff palette *

getpn	subi	NUMPAL,a3	;Compute palette #
	neg	a3

	.if	PAL64
	movk	>f,a1
	and	a3,a1		;A2=4 low bits
	srl	4,a3		;Move B4/B5 to B6/B7
	sll	6,a3
	add	a1,a3
	.endif

	move	a3,a0		;Return palette #
	sll	8,a3
	add	a3,a0		;Double it up for DMA

	PULL	a2,a3
	addk	1,a1		;Clr Z for OK
	rets


#*******************************
* Setup palette transfer
* A0=* to palette color data
* A1=Bit 8-15 destination palette | Bit 0-7 start color
* A2=Color count (0-255)
* Rets: Z set if unable to setup transfer
* Trashes scratch

 SUBR	pal_set

	move	a3,b1

	movi	PALTRAM,a3
	movi	NUMPALT,b0	;# of palette transfers allowed

#lp	move	*a3+,a14
	jrz	#set		;Cell free?
	addi	PALTSIZ-16,a3
	dsj	b0,#lp
	.if	DEBUG
	LOCKUP
	eint
	.endif
	jruc	#x

#set	move	a0,*a3+,L	;Set PALSRC
	move	a1,*a3		;Set PALDEST
	move	a2,*a3(-48)	;Set PLDCNT (Must set last)

#x	move	b1,a3
	move	b0,b0		;Return Z (error) or NZ (ok)
	rets



#*******************************
* Transfer palette data
* Called during vblank
* Looks through PALTRAM for transfers
* Trashes A0-A7

 SUBR	pal_transfer

	movi	PALTRAM,a0
	movi	NUMPALT,a3	;# OF PALETTES

	clr	a6
	movi	COLRAM,a7

#lp	move	*a0,a4		;Get count
	jrz	#x		;End?

	move	a6,*a0+		;Clear out tranfer count
	move	*a0+,a1,L	;Source address
	move	*a0+,a2		;Destination palette
	zext	a2

	.if	PAL64
	move	a2,a5		;Convert to color ram address
	sll	32-12,a5
	srl	32-12-4,a5	;*16
	srl	14,a2		;Move B14/15 to B6/7
	sll	6+4,a2
	add	a5,a2
	.else
	sll	4,a2		;*16 for word addr
	.endif

	add	a7,a2		;+color ram base address

	sll	32-9,a4		;Make 0-511
	srl	32-9+1,a4
	jrnc	#1		;Even data count?
	move	*a1+,*a2+

#1	srl	1,a4		;/2 data count
	jrnc	#2		;Even?
	move	*a1+,*a2+,L

#2	srl	1,a4		;/2 data count
	jrnc	#3		;Even?
	move	*a1+,*a2+,L
	move	*a1+,*a2+,L
#3	jrz	#5		;Cnt=0?

#4	move	*a1+,*a2+,L
	move	*a1+,*a2+,L
	move	*a1+,*a2+,L
	move	*a1+,*a2+,L
	dsj	a4,#4

#5	dsj	a3,#lp

#x	rets



#*******************************
* Black out selected palette
* A0=* palette to black out
* Trashes scratch

 SUBR	pal_blacken

	PUSH	a2

	callr	pal_find
	jrz	#err
	sll	8,a0
	move	a0,a1
	movi	FADERAM,a0
	movk	32,b0
	clr	a2
#lp	move	a2,*a0+,L
	dsj	b0,#lp
	movi	FADERAM,a0
	movi	64,a2
	callr	pal_set

#err	PULL	a2
	rets


********************************
* PUMP_RED PROCESS, CYCLE NUCLEAR REACTORS

;PUMP_RED
;	SLEEPK	18H
;	MOVI	REACTR,A0
;	MOVE	A0,@KPBASE,L
;	CALLR	find_pal
;	JRZ	REDOUT
;	SLL	8,A0
;	MOVE	A0,A11			 ;NEEDED LATER FOR pal_set
;
;	MOVI	25,A10			;PUMP RED A10 TIMES
;	MOVI	128,A8
;REDLOOP MOVI	FADERAM,A0
;	ADDK	10H,A8
;	CALLR	DO_MULT
;	SLEEPK	1
;	DSJ	A10,REDLOOP
;REDOUT
;	MOVK	25,A10			;PUMP RED A10 TIMES
;RED2	MOVI	FADERAM,A0
;	SUBI	10H,A8
;	CALLR	DO_MULT
;	SLEEPK	1
;	DSJ	A10,RED2
;	JRUC	PUMP_RED
;
;DO_MULT
;	MOVE	A8,A2
;	PUSH	a8,a10,a11
;
;	MOVE	@KPBASE,A1,L		;REACTR,A1
;;PARAMS
;;	A0 - DEST RAM FOR PAL
;;	A1 - SRC FOR PAL
;;	A2 - COLOR MULTIPLIER
;; EACH COLOR IN PALETTE WILL BE MULTIPLIED BY A2 THEN DIVIDED BY 128
;
;	move	*a1+,a14
;	move	a14,*a0+
;	SLL	23,A14		;TOP BITS OF FIELD ARE FLAGS
;	SRL	23,A14		;ONLY 9 BITS NEEDED FOR # COLORS
;	MOVI	>7C00,A4	;A4 - PRE MULT MASK FOR 5 BITS OF RED
;;	MOVI	>03E0,A6	;A6 - PRE MULT MASK FOR 5 BITS OF GREEN
;;	MOVI	>001F,A8	;A8 - PRE MULT MASK FOR 5 BITS OF BLUE
;	MOVE	A4,A9
;;	MOVE	A6,A10
;;	MOVE	A8,A11
;	SLL	7,A9		; A9 - POST MULT MAX FOR 5 BITS OF RED
;;	SLL	7,A10		;A10 - POST MULT MAX FOR 5 BITS OF GREEN
;;	SLL	7,A11		;A11 - POST MULT MAX FOR 5 BITS OF BLUE
;FADELPR
;	MOVE	*A1+,A3,W	;A3 - RED
;	MOVE	A3,A5
;	ANDI	03FFH,A5
;;	MOVE	A3,A5		;A5 - GREEN
;;	MOVE	A3,A7		;A7 - BLUE
;	AND	A4,A3
;	CMPI	1001H,A3
;	JRC	REDOKR
;;	AND	A6,A5
;;	AND	A8,A7
;	MPYU	A2,A3
;;	MPYU	A2,A5
;;	MPYU	A2,A7
;	CMP	A9,A3
;	JRLE	REDOKR
;	MOVE	A9,A3
;REDOKR
;;	CMP	A10,A5
;;	JRLE	GREENOK
;;	MOVE	A10,A5
;;GREENOK
;;	CMP	A11,A7
;;	JRLE	BLUEOK
;;	MOVE	A11,A7
;;BLUEOK
;	AND	A9,A3
;	SRL	7,A3
;;	AND	A10,A5
;	OR	A5,A3
;;	OR	A7,A3
;;	SRL	7,A3
;	MOVE	A3,*A0+
;	DSJS	A14,FADELPR
;
;
;	PULL	a8,a10,a11
;
;	movi	FADERAM,a0	;*Color data
;	move	a11,a1		;Pal#
;	move	*a0+,a2		;#Colors
;	jruc	pal_set



********************************
* Fade in all selected palettes from black
* A0=*Palette list to fade in (autoerase + 0-8 pals)
* A1=Fade delay in ticks
* Trashes scratch,A7,A9-A10
* If 1st entry not neg then it enables autoerase fading


 SUBR	pal_fadein

	move	a0,a9		;A9=*Palette list
	move	a1,a10		;A10=Fade delay
	CREATE0	fadein
	rets

fadein
	move	a13,a6
	addi	PDATA,a6
	movk	FPALNUM,a7

	move	a9,a11
	move	*a11+,a0,L		;!-=Autoerase color
	jrn	fi30
	move	a0,@irqskyeo		;Save color

fi20	move	*a11+,a0,L		;Get * palette
	jrz	fi70			;0=End
fi30	callr	pal_find
	jrnz	fi60			;OK?
	not	a0			;Make neg (should = -256)
fi60	sll	8,a0
	move	a0,*a6+			;Save palette #
	dsj	a7,fi20

fi70	clr	a8			;A8=Brightness


fi100	addk	8,a8

	movi	FADERAM,a5
	move	a13,a6
	addi	PDATA,a6
	movk	FPALNUM,a7

	move	a9,a11
	move	*a11,a1,L
	jrn	fi200
	addk	32,a11
	move	a8,a2
	callr	pal_fadeae

fi200	move	*a11+,a1,L
	jrz	fi400			;End?
	move	a5,a0
	move	a8,a2
	callr	pal_fade
	move	a5,a0			;*Palette colors
	move	*a6+,a1			;Palette #
	cmpi	-256,a1			;FF00
	jreq	fi230			;Couldn't find?
	move	*a0+,a2			;#Colors
	callr	pal_set
fi230	addi	FPALSZ,a5
	dsj	a7,fi200

fi400	move	a10,a0
	calla	PRCSLP
	cmpi	128,a8
	jrlo	fi100

fi800	DIE




********************************
* Fade out all selected palettes to black
* A0=*Palette list to fade out (autoerase + 0-8 pals)
* A1=Fade delay in ticks
* If 1st entry not neg then it enables autoerase fading


 SUBR	pal_fadeout

	clr	a10
	move	a10,@palfmin

 SUBR	pal_fadeout2

	move	a0,a9		;A9=*Palette list
	move	a1,a10		;A10=Fade delay
	CREATE0	fadeout
	rets

fadeout
	move	a13,a6
	addi	PDATA,a6
	movk	FPALNUM,a7

	move	a9,a11
	move	*a11+,a0,L		;!-=Autoerase color
	jrn	fo30
	move	@IRQSKYE,a0		;Save color
	move	a0,@irqskyeo

fo20	move	*a11+,a0,L		;Get * palette
	jrz	fo70			;0=End
fo30	callr	pal_find
	jrnz	fo60
	not	a0			;Make neg
fo60	sll	8,a0
	move	a0,*a6+			;Save palette #
	dsj	a7,fo20

fo70	movi	128,a8			;A8=Brightness


fo100	subk	8,a8

	movi	FADERAM,a5
	move	a13,a6
	addi	PDATA,a6
	movk	FPALNUM,a7

	move	a9,a11
	move	*a11+,a1,L
	jrn	fo220
	move	a8,a2
	callr	pal_fadeae

fo200	move	*a11+,a1,L
	jrz	fo400
fo220	move	a5,a0
	move	a8,a2
	callr	pal_fade
	move	a5,a0			;*Palette colors
	move	*a6+,a1			;Palette #
	cmpi	-256,a1			;FF00
	jrz	fo250
	move	*a0+,a2			;#Colors
	callr	pal_set
fo250	addi	FPALSZ,a5
	dsj	a7,fo200

fo400	move	a10,a0
	calla	PRCSLP
	move	@palfmin,a0
	cmp	a0,a8
	jrgt	fo100

fo800	DIE


********************************
* Fade autoerase color

 SUBRP	pal_fadeae	;A2=Brightness (0-128)

	PUSH	a3,a5,a7,a8

	movi	IRQSKYE,a0
	movi	irqskyeo,a1
	movk	1,a14
	jruc	pf1c


********************************
* Fade a palette
* Each color in palette will be multiplied by a2 then divided by 128
* A0=*Ram for pal, A1=*Palette, A2=Brightness (0-128)
* Trashes scratch

 SUBRP	pal_fade

	PUSH	a3,a5,a7,a8

	move	*a1+,a14	;# Colors
	move	a14,*a0+

	sll	32-9,a14	;Remove any flags
	srl	32-9,a14	;9 bits needed for # colors

pf1c	movk	>1f,a8		;A8=5 bit color mask

pf100	move	*a1+,a3
	movk	>1f,a7
	and	a3,a7		;A7=Blue
	srl	5,a3
	movk	>1f,a5
	and	a3,a5		;A5=Green
	srl	5,a3		;A3=Red

	mpyu	a2,a3
	mpyu	a2,a5
	mpyu	a2,a7
	srl	7,a3		;/128
	srl	7,a5
	srl	7,a7

	cmp	a8,a3
	jrls	pfrok
	move	a8,a3

pfrok	cmp	a8,a5
	jrls	pfgok
	move	a8,a5

pfgok	cmp	a8,a7
	jrls	pfbok
	move	a8,a7

pfbok	sll	10,a3
	sll	5,a5
	or	a5,a3
	or	a7,a3
	move	a3,*a0+		;Save color
	dsj	a14,pf100

	PULL	a3,a5,a7,a8
	rets



**************************************************************************
* Fade palettes from black to their normal colors except for list
* A0=*List NOT to fade or 0
* Trashes scratch

 SUBR	pal_fadeinx

	PUSH	a2,a6,a7,a8,a9,a10
	movk	8,a10
	jruc	fbf10


**************************************************************************
* Fade palettes down to black except for list
* A0=*List NOT to fade or 0
* Trashes scratch

 SUBR	pal_fadeoutx

	PUSH	a2,a6,a7,a8,a9,a10
	movi	-8,a10

fbf10	move	a0,a6
					;Start proc to fade each palette
	clr	a9			;palette slot
	movi	PALRAM,a2		;A2=*Palette table

fbf20	move	*a2+,a8,L		;Ptr to palette
	jrz	fbf70
	move	a6,a7			;A6=*List of palettes to skip
	jrz	fbf60

fbf50	move	*a7+,a1,L
	jrz	fbf60
	cmp	a1,a8
	jreq	fbf70			;Skip pal?
	jruc	fbf50

fbf60	CREATE0	fadeonep

fbf70	addk	1,a9
	cmpi	NUMPAL,a9
	jrlt	fbf20

fbfx	PULL	a2,a6,a7,a8,a9,a10
	rets


**************************************************************************
* fadeonep - Fade one palette (Process)
*
* A8=*Palette to be faded
* A9=Palette slot # (0 to NUMPAL-1)
* A10=Add value per fade (!0)

fadeonep

	.if	PAL64
	movk	>f,a2
	and	a9,a2		;A2=4 low bits
	srl	4,a9		;Move B4/B5 to B6/B7
	sll	6,a9
	add	a2,a9
	.endif

	sll	8,a9		;B8-15 dest pal, B0-7 color (0)

	clr	a11		;For up fade
	move	a10,a10
	jrgt	fop60
	movi	128,a11		;For dn fade
	jruc	fop60
				;>Set up faded pal in process data space
foplp
	move	a11,a2		;A2=Color Multiplier
	move	a13,a0
	addi	PDATA,a0	;A0=Dest Ram for Pal
	move	a0,a5
	move	a8,a1		;A1=Src for Pal
	callr	pal_fade

	move	a5,a0		;>Move faded palette to palram
	move	a9,a1
	move	*a0+,a2		;Get # colors in palette
	callr	pal_set		;Set transfer

	SLEEPK	2
fop60	add	a10,a11
	cmpi	128,a11
	jrls	foplp


	SLEEPK	2		;Wait on last pal_set
	DIE


****************************************************************
* Fade palettes from white to their normal colors except for list
* A0=*List NOT to fade or 0
* A1=Do Autoerase (!0=Yes)

 SUBR	pal_fmwht

	PUSH	a2,a6,a7,a8,a9,a10
	movi	-1,a10
	jruc	ptw10


****************************************************************
* Brighten palettes to white except for list
* A0=*List NOT to fade or 0
* A1=Do Autoerase (!0=Yes)

 SUBR	pal_towht

	PUSH	a2,a6,a7,a8,a9,a10
	move	@IRQSKYE,a2		;Save color
	move	a2,@irqskyeo
	movk	1,a10

ptw10	move	a0,a6
	move	a1,a1
	jrz	ptw15			;Skip AE
	CREATE0	addbrt_ae
					;Start proc to fade each palette
ptw15	clr	a9			;palette slot
	movi	PALRAM,a2		;A2=*Palette table

ptw20	move	*a2+,a8,L		;Ptr to palette
	jrz	ptw70
	move	a6,a7			;A6=*List of palettes to skip
	jrz	ptw60

ptw50	move	*a7+,a1,L
	jrz	ptw60
	cmp	a1,a8
	jreq	ptw70			;Skip pal?
	jruc	ptw50

ptw60	CREATE0	brightenonep

ptw70	addk	1,a9
	cmpi	NUMPAL,A9
	jrlt	ptw20

ptwx	PULL	a2,a6,a7,a8,a9,a10
	rets


********************************
* Brighten one palette (Process)
* A8=*Palette to be faded
* A9=Palette slot #
* A10=Add value per loop (!0)

brightenonep
	.if	PAL64
	movk	>f,a2
	and	a9,a2		;A2=4 low bits
	srl	4,a9		;Move B4/B5 to B6/B7
	sll	6,a9
	add	a2,a9
	.endif

	sll	8,a9		;B8-15 dest pal, B0-7 color (0)

	clr	a11		;For up fade
	move	a10,a10
	jrgt	bop20
	movk	31,a11		;For dn fade
bop20
				;Set up faded pal in process data space
boplp	add	a10,a11
	cmpi	31,a11
	jrhi	bopx
	move	a11,a2		;A2=Brightness
	move	a13,a0
	addi	PDATA,a0	;A0=Dest Ram for Pal
	move	a0,a5
	move	a8,a1		;A1=Src for Pal
	callr	pal_addb

	move	a5,a0		;>Move faded palette to palram
	move	a9,a1
	move	*a0+,a2		;Get # colors in palette
	callr	pal_set		;Set transfer

	SLEEPK	3
	jruc	boplp

bopx	SLEEPK	1		;give last xfer a chance to go
	DIE


********************************
* Change brightness of autoerase (Process)
* A10=Add value per loop (!0)

 SUBR	addbrt_ae

	clr	a11		;For up fade
	move	a10,a10
	jrgt	abae20
	movk	31,a11		;For dn fade
abae20
abaelp	add	a10,a11
	cmpi	31,a11
	jrhi	abaex
	move	a11,a2		;A2=Brightness
	callr	addbae

	SLEEPK	3
	jruc	abaelp

abaex	DIE


********************************
* Change brightness of autoerase
* A2=Brightness (-31 to 31)

 SUBRP	addbae

	PUSH	a3,a5,a7,a8

	movi	IRQSKYE,a0
	movi	irqskyeo,a1
	movk	1,a14
	jruc	pb1c


********************************
* Change brightness of a palette
* Each color in palette will have A2 added to its RGB
* A0=*Ram for pal, A1=*Palette, A2=Brightness (-31 to 31)
* Trashes scratch

 SUBRP	pal_addb

	PUSH	a3,a5,a7,a8

	move	*a1+,a14	;# Colors
	move	a14,*a0+

	sll	23,a14		;Remove any flags
	srl	23,a14		;9 bits needed for # colors

pb1c	movk	>1f,a8		;A8=Mask for 5 bits of color

pb100	move	*a1+,a3
	movk	>1f,a7
	and	a3,a7		;A7=Blue
	srl	5,a3
	movk	>1f,a5
	and	a3,a5		;A5=Green
	srl	5,a3		;A3=Red

	add	a2,a3
	add	a2,a5
	add	a2,a7

	cmp	a8,a3
	jrls	pbrok
	move	a8,a3

pbrok	cmp	a8,a5
	jrls	pbgok
	move	a8,a5

pbgok	cmp	a8,a7
	jrls	pbbok
	move	a8,a7

pbbok	sll	10,a3
	sll	5,a5
	or	a5,a3
	or	a7,a3
	move	a3,*a0+		;Save color
	dsj	a14,pb100

	PULL	a3,a5,a7,a8
	rets


#*****************************************************************************
*
* INPUT:	a10 = * list palettes not to fade (0 terminated)
* A11=Fade increment (1-256)
*-----------------------------------------------------------------------------

 SUBR	fade_up

	move	a10,@fade_list,L

	clr	a0
	move	a0,@fade_start

	movi	256,a0
	move	a0,@fade_end

	move	a11,a0			;movk 8
	move	a0,@fade_inc

	jruc	do_fade

#*****************************************************************************
* Fade palettes down (process)
* A10=* list palettes not to fade (0 terminated)
* A11=Fade increment (1-256)
*-----------------------------------------------------------------------------

 SUBR	fade_down

	move	a10,@fade_list,L

	movi	256,a0
	move	a0,@fade_start

	clr	a0
	move	a0,@fade_end

	move	a11,@fade_inc

	jruc	do_fade

#*****************************************************************************
*
* INPUT:	a10 = * list palettes not to fade (0 terminated)
*
*-----------------------------------------------------------------------------

 SUBR	fade_up_half

	move	a10,@fade_list,L

	movi	32,a0			;64;128
	move	a0,@fade_start

	movi	256,a0
	move	a0,@fade_end

	movk	32,a0			;16
	move	a0,@fade_inc

	jruc	do_fade

#*****************************************************************************
*
* INPUT:	a10 = * list palettes not to fade (0 terminated)
*
*-----------------------------------------------------------------------------

 SUBR	fade_down_half

	move	a10,@fade_list,L

	movi	256,a0
	move	a0,@fade_start

	movi	112,a0			;128
	move	a0,@fade_end

	movk	16,a0
	move	a0,@fade_inc

	jruc	do_fade

#*****************************************************************************

 SUBRP	do_fade

	move	@IRQSKYE,a0
	move	a0,@irqskyeo

	move	@fade_start,a10
#fade_loop

	move	@irqskyeo,a11
	movk	>1f,a7
	and	a11,a7		;A7  = Blue
	srl	5,a11
	movk	>1f,a9
	and	a11,a9		;A9  = Green
	srl	5,a11		;A11 = Red

	mpyu	a10,a7		; X (0 - 32)
	srl	8,a7		;/256
	mpyu	a10,a9
	srl	8,a9
	mpyu	a10,a11
	srl	8,a11

	sll	10,a11		;red
	or	a11,a7
	sll	5,a9		;green
	or	a9,a7

	move	a7,@IRQSKYE


	movi	FADERAM,a4
	movi	PALRAM,a1
	movi	NUMPAL,a3
#next_pal
	move	*a1+,a2,L	;Get *palette
	jrz	#empty_pal

	move	@fade_list,a7,L
	jrz	#skip_check
	jruc	#start

#next_check
	cmp	a9,a2
	jreq	#done		;skip this palette
#start
	move	*a7+,a9,L
	jrnz	#next_check

#skip_check

	move	*a2+,a5		;Number colours in palette
	move	a5,a8
	move	a4,a6

#copy_loop
	move	*a2+,a11
	movk	>1f,a7
	and	a11,a7		;A7  = Blue
	srl	5,a11
	movk	>1f,a9
	and	a11,a9		;A9  = Green
	srl	5,a11		;A11 = Red

	mpyu	a10,a7		; X (0 - 32)
	srl	8,a7		;/256
	mpyu	a10,a9
	srl	8,a9
	mpyu	a10,a11
	srl	8,a11

	sll	10,a11		;red
	or	a11,a7
	sll	5,a9		;green
	or	a9,a7

	move	a7,*a6+		;1 word

	dsj	a8,#copy_loop


	PUSH	a1,a2
	move	a4,a0		;* colour data
	movi	NUMPAL,a1
	sub	a3,a1		;dest palette ( 0 - NUMPAL-1 )
	sll	8,a1		;
	move	a5,a2		;# colours
	callr	pal_set
	PULL	a1,a2
#done
#empty_pal
	addi	FPALSZ,a4
	dsj	a3,#next_pal

	SLEEPK	1

	move	@fade_start,a0
	move	@fade_end,a1
	cmp	a0,a1
	jrhi	#fading_up
				;fading_down
	move	@fade_inc,a0	;signed inc
	sub	a0,a10
	cmp	a1,a10
	jrge	#fade_loop

	DIE

#fading_up
	move	@fade_inc,a0	;signed inc
	add	a0,a10
	cmp	a1,a10
	jrls	#fade_loop

	DIE


#*****************************************************************************
	.end

