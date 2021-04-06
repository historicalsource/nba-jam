**************************************************************
*
* Software:		Warren Davis
* Initiated:		9/3/91
*
* Modified:		Shawn Liptak, 8/13/92	-Basketball
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/24/93 11:23
**************************************************************
	.file	"unzip.asm"
	.title	"pkzip unzipper"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"imgtbl.glo"
	.include	"macros.hdr"		;Macros
;	.include	"shawn.hdr"		;Macros
;	.include	"frame.tbl"

	.include	"bbvda.tbl"


	.ref	pal_getf

;	.ref	pal_clean

	.ref	SYSCOPY

;	.ref	last_score,scores,tvpanelon
	.ref	get_all_buttons_cur



BPP		.set 	3
RAMBUFSIZ	.set	(4*1024)*8		; << BPP
;SCRN_ST		.set	(170*SCRN_PTCH)+(150*8)
;PXLS_PR_TIK	.set	10000

PAGE1ADR	.equ	PAGE1YO*512*8

CARYTEST	.equ	0		;1 for Cary's board testing
ERRORTEST	.equ	0		;1 for random pixel test
DEBUGPORT	.equ	>1d01010


	STRUCTPD
	LONG	PTEMP1
	LONG	PIXPERFRM
;	WORD	FRAMENUM
;	LONG	CLIPSND
;	WORD	HOLDFADE	;Time to hold first frame
;	WORD	DEBUGCNT	;For TUNIT debugging


;RamBuffer	.usect	"unzip",RAMBUFSIZ
RamBuffer	equ	>1200000

	BSSX	lengthtree	,256*32
	.bss	disttree	,256*32
	.bss	minptrtbl	,256*32


	.text


#*******************************

	.ref	display_blank,WIPEOUT,dpageflip,IRQSKYE
	.ref	dtype,display_unblank,get_all_buttons_cur2
	.ref	SOUNDSUP,bounce_snd

 SUBR	show_trophy

	calla	display_blank
	calla	WIPEOUT

	movk	1,a0
	move	a0,@dpageflip

	clr	a0
	move	a0,@dtype		;2D

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	1

	movk	1,a0
	move	a0,@DISPLAYON
	calla	display_unblank

	movi	TROPHY,a8
	clr	a9
	movi	SCRNST+SCRNXP,a10	;XY
	JSRP	movie_run

	movi	6*TSEC,a10
#lp	SLEEPK	1
	calla	get_all_buttons_cur2
	jrz	#nob

      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#xb
#nob	
	dsj	a10,#lp
#xb
	calla	WIPEOUT

	RETP


#*******************************
* Stop for error (DEBUG)

	.if	TUNITDB

 SUBRP	movie_error

	PUSH	a0,a1
	pushst
	dint

	move	@SYSCOPY,a0
	ori	4,a0
	move	a0,@SYSCOPY
	move	a0,@SYSCTRL

#lp2	movi	20000,a1
#lp	move	a0,@ERASELOC
	addk	1,a0
	dsj	a1,#lp

	move	@SWITCH+16,a1
	not	a1
	andi	>624,a1
	jrz	#lp2

	move	@SYSCOPY,a0
	xori	4,a0
	move	a0,@SYSCOPY
	move	a0,@SYSCTRL

	popst
	PULL	a0,a1
	rets

	.endif


#*******************************
* Run movie footage (JSRP)
* A8=* compressed picture data
* A9=Mode (0=Normal, 1=x2)
* A10=Screen * for top left of picture
* Trashes scratch, A2-A11,B2-B10

 SUBR	movie_run

;DEBUG
;	jauc	0

	addi	SCRNXP*8,a10		;+XPad offset
	move	@dpage,a14
	jrnz	#p2
	addi	PAGE1YO*512*8,a10	;Start in page 1 if page 0 is being displayed
#p2

	callr	movie_waitdma

	.if	CARYTEST
	movk	1,a14
	move	a14,@DEBUGPORT
	.endif

	callr	movie_parsehdr
	jrnz	#error

	move	b3,a14			;Height
	subk	1,a14
	movi	SCRN_PTCH,a1
	mpys	a14,a1
	add	a1,a10			;* to bottom left

	callr	movie_getpal
	jrz	#error
					;A4=# frames
					;A6=X size
					;B3=Y size
					;B4=strtpal
	movi	blowline,b10
	move	a9,a9
	jrz	#mode0
	movi	blowlinex2,b10
#mode0

	JSRP	movie_unzip

#x	setf	16,1,0
	setf	32,0,1

	RETP

#error
	clr	a14
	move	a14,@DEBUGPORT

	LOCKUP
	jruc	#x


#*******************************
* Wait for DMA activity to stop
* Trashes A14

 SUBRP	movie_waitdma

#wtlp
	move	b13,b13			;Wait for DMAQ empty
	jrge	#wtlp
	move	@DMACTRL,a14
	jrn	#wtlp


	.if	CARYTEST=0

	movk	1,a14
	move	a14,@DEBUGPORT

#dly	movi	200,a14			;Wait 400 cycles
	dsj	a14,$

	move	@DMACTRL,a14
	jrnn	#x
	LOCKUP
	jruc	#dly

	.endif

#x	rets


#*******************************
* Get a movie palette
* A7=# of colors
* A8=* to color data
* >A0=Color map allocated (0000-cfcf)
* Z set if no palette free
* Trashes scratch

 SUBRP	movie_getpal

	move	a8,a0
	subk	16,a0		;Point to # colors
	calla	pal_getf
	jrz	#x

	move	a7,a1
	sll	4,a1		;*16
	add	a1,a8

	move	a0,b4
	addk	1,a1		;Clr Z

#x	rets



#*******************************
* Get movie info
* A8=* to compressed data
*Rets:
* >A0=!0 if error (CC)
* >A4=# frames
* >A6/B9=X
* >A7=# colors in palette
* >B3=Y
* Trashes scratch

movie_parsehdr

	move	a8,a14
	movk	30,a0		;# retries

#rd	move	*a8+,a6		;X size of frames
	move	*a8+,a1		;Y size of frames
	move	*a8+,a4		;# of frames
	move	*a8+,a7		;# of colors
	move	a1,b3
	move	a6,b9

;	cmpi	100,a6		;X
;	jrne	#error
;	cmpi	68,b3		;Y
;	jrne	#error
;	cmpi	5,a4		;#frms
;	jrlt	#error
;	cmpi	35,a4
;	jrgt	#error
;	cmpi	200,a7		;#colors
;	jrlt	#error
;	cmpi	255,a7
;	jrhi	#error

	clr	a0
	rets

#error
	movk	101b,a8
	move	a8,@DEBUGPORT

	move	a14,a8
	dsj	a0,#rd

	addk	1,a0
	rets


********************************
* GSP Decompression routine
*
*	ASSUMPTIONS:  1) There is no literal table
*	              2) the size of the sliding window is 4K
*
*	Needs the following Data Tables:
*		CompressedDataTable will contain the following once
*		it is uncompressed:
*			# frames            (1 byte)
*			# colors in palette (1 byte)
*			X size of frame     (1 byte)
*			Y Size of frame     (1 byte)
*			variable length palette data
*			data for each frame
*
*	Needs the following RAM variables:
*		LengthTree   256 long words
*		DistanceTree 256 long words
*		MinPtrTable  256 long words (used for sort)
*		RamBuffer    circular buffer
*	        Tree layout is as follows...
*			low 16 bits = Code
*			next 8 bits = Bit length
*
*	B reg usage...
*		B0 = Ptr to Length tree
*		B1 = Ptr to Distance tree
*		B3 = start of line
*		B4 = start palette duped to fill 16 bits
*		B5 = used for outputting pal bits to DMAPAL
*		B6 = temp storage in ReadTree and UncompressTree
*		B7 = constant mask for pxl palette split
*		B8 = DMAPAL
*		B9 = Master X storage



#*******************************
* Uncompress a tree
* A7=* to tree table
* A8=* to compressed data
* >A0=!0 if error (CC)

UncompressTree:

	PUSH	a4,a5

	move	a7,a5		;Save start of tree

	clr	a4
	PUSH	a8
				;>Determine how many codes of each bit length
	setf	8,0,0
	move	*a8+,a0		;# compressed bytes to describe tree - 1
	addk	1,a0
	movk	>f,a3		;Constant
	clr	a6		;Total number of codes in tree
utr0
	move	*a8+,a1		;(# codes - 1 << 4) | bit lngth - 1
	add	a1,a4		;Chksum
	move	a1,a2
	srl	4,a2
	addk	1,a2		;number of codes of this bit length
	add	a2,a6		;adjust total
	and	a3,a1
	addk	1,a1		;bit length
	move	a1,a11
	sll	16,a11
	movy	a11,a1		;duplicate bit length for sort
utr1
	move	a1,*a7+,L
	dsj	a2,utr1		;fill table

	dsj	a0,utr0		;a6 now contains size of tree


	PULL	a8		;>Recalc chksum
	clr	a2
	move	*a8+,a0		;# compressed bytes to describe tree - 1
	addk	1,a0
#chklp	move	*a8+,a1
	add	a1,a2
	dsj	a0,#chklp

	setf	16,1,0

	cmp	a2,a4
	jrne	#error		;Chksums don't match?


*	Sort Tree by increasing Bit Length.
*		The translation index is placed in the upper byte
*		of the long word.

	movi	minptrtbl,a0	; for placing translation ptrs
	move	a6,a9		; outer loop count (# entries in tree table)

*	Outer loop, after each pass, we have found the next minimum

utr2
	move	a5,a7		; restore start of tree
	movi	06543h,a14	; current minimum
	move	a6,b6		; inner loop count
	movi	07654h,a1	; constant

*	Inner loop, go through all values in table and find min.
*	When we find it, we set it to a high value so we don't detect
*	it again.

utr3
	move	*a7,a2		; look at next bit length
	cmp	a14,a2		; is it less than the last minimum
	jrge	nonewmin
	move	a2,a14		; if yes, save new minimum
	move	a7,a11		;         save pointer to minimum
nonewmin
	addk	32,a7		; point to next entry
	dsj	b6,utr3

;	end of inner loop: min is in a14, ptr to min is in a7

	move	a1,*a11		; set this minimum high.
	move	a11,*a0+,L	; place translation ptr in MinPtrTbl.

	dsjs	a9,utr2

				;>Compute the codes
	clr	a11		;Code
	clr	a1		;CodeInc
	clr	a2		;LastBitLength
	move	a6,a14		;loop counter
utr4
	move	*-a0,a7,L	;translated pointer
	add	a1,a11
	movb	*a7(16),a3	;bit length
	cmp	a3,a2
	jreq	samebitlng
	move	a3,a2		;set new LastBitLength
	movk	16,a3
	sub	a2,a3		;16-LastBitLength
	movk	1,a1
	sll	a3,a1		;CodeInc = 1 << (16-LastBitLength)
samebitlng
	move	a11,a5		;copy of Code in a5
	movk	16,a9		;reverse bit loop count
rvrsbts
	sll	1,a5		;Reverse bits of word
	movy	a5,a3
	srl	1,a3
	zext	a5
	dsjs	a9,rvrsbts

	move	a3,*a7		;store code with bits reversed
	dsjs	a14,utr4

	clr	a0

#x	PULL	a4,a5
	move	a0,a0
	rets


#error
	movk	1001b,a14
	move	a14,@DEBUGPORT

	LOCKUP
	movk	1,a0		;Error!
	jruc	#x



********************************

SetConstants:
	movi	lengthtree,b0
	movi	disttree,b1
SetConstX
	movi	RamBuffer+RAMBUFSIZ-1,a0	;mask for rambuf ptr
	movi	RamBuffer,a6			;used for negative wraparound
	movi	0c0c0h,b7			;for blowing words of
	movi	DMACMAP,b8
;	movi	blowline,b10
	rets



#*******************************
* Initialize and run unzip loop (JSRP)
* A4=# of frames
* A8=* compressed data table
* A10=Screen * for top left of picture
* B3=Y size
* B4=strt pal
* B9=X size

 SUBRP	movie_unzip


	.if	TUNITDB
	jruc	#debugstrt
	.endif


	movi	lengthtree,b0
	movi	disttree,b1

	movk	10,a5
#ltlp	move	b0,a7			;Length Tree
	move	a8,b2
	callr	UncompressTree
	jrz	#ltok			;OK?
	move	b2,a8
	dsj	a5,#ltlp
	jruc	#error
#ltok

	movk	10,a5
#dtlp	move	b1,a7			;Distance Tree
	move	a8,b2
	callr	UncompressTree
	jrz	#dtok			;OK?
	move	b2,a8
	dsj	a5,#dtlp
	jruc	#error
#dtok

	.if	CARYTEST
	clr	a14
	move	a14,@DEBUGPORT
	.endif

#debugstrt

	;Clear top 4K of buffer to take care of initial wraparound

	movi	RamBuffer+RAMBUFSIZ,a1	;End of buffer
	movi	1024,a2			;4K
	clr	a3
clrbuf
	move	a3,*-a1,L
	dsj	a2,clrbuf

					;Do some initializing
	mpyu	b9,b3
	move	b3,a11			;total # bytes in frame in a11
	move	a11,*a13(PIXPERFRM),L
	callr	SetConstX
	move	a6,a9			;Where to uncompress to
	move	a9,b3			;first frame start
	clr	b5			;pixel count for Stills only

	cmpi	1,a4
	jreq	UncompressFrame		;1 frame?

;----

#lp
	mmtm	a12,a4,a10

	callr	movie_waitdma

	.if	CARYTEST
	movk	10b,a14
	move	a14,@DEBUGPORT
	.endif

	.if	TUNITDB
	movi	50,a0
#dblp
	movi	80,a2
#dblp2
	move	a8,a9
	addi	GRANT_F2-GRANT_F,a9
	movb	*a8,a14
	movb	*a9,a1
	move	a14,@SCRATCH+13
	move	a1,@SCRATCH+16+15
	cmp	a1,a14
	jreq	#cmpok
#dberr	callr	movie_error
	mmfm	a12,a4,a10
	RETP
#cmpok
	move	@DMACTRL,a1
	move	@DMACTRL,a1
	move	@DMACTRL,a1
	move	@SWITCH,a1,L
	move	@SWITCH,a1,L
	move	@SWITCH,a1,L
	movb	*a9,a1
	cmp	a1,a14
	jrne	#dberr
	move	@SCRATCH+13,a1
	cmp	a1,a14
	jrne	#dberr
	movb	*a8,a14
	move	@SCRATCH+16+15,a1
	cmp	a1,a14
	jrne	#dberr

	movb	a14,*a10
	addk	8,a8
	addk	8,a9
	addk	8,a10
	dsj	a2,#dblp2
	addi	(512-80)*8,a10
	dsj	a0,#dblp

	jruc	#skipuncomp
	.endif


	JSRP	UncompressFrame

	clr	a0
	move	a0,@DEBUGPORT
#skipuncomp

	movk	1,a0			;1 tick sleep
;	move	*a13(FRAMENUM),a14	;if 1st frame, check for hold
;	jrz	chk4hold
;	subk	1,a14
;	jrne	nonono
;
;	move	*a13(HOLDFADE),a14	;on second frame, wait for hold time
;	add	a14,a0
;	jruc	nonono
;
;chk4hold
;	move	*a13(HOLDFADE),a14
;	jrz	nonono			; if need to hold, create fade process
;	PUSH	a8
;	move	b4,a8
;;	CREATE0	HOLD_FADE_PROC
;	PULL	a8
;	movk	6,a0			; sleep longer if we are fading pal
;nonono


	movi	swappg,a14
	jruc	GoToSleep


swappg

	mmfm	a12,a4,a10

	xori	PAGE1YO*512*8,a10	;Flip * to other page

;	PUSH	a0

	setf	16,1,0


;	move	*a13(FRAMENUM),a14	;sound only on first frame
;	jrnz	no
;	move	*a13(CLIPSND),a0,L	;sound from sound table
;	jrz	no
;	PUSH	a14
;	calla	snd_play1
;	PULL	a14
;no
;	PULL	a0
;
;	addk	1,a14
;	move	a14,*a13(FRAMENUM)	;save next frame number

	move	*a13(PIXPERFRM),a14,L	;number of pixels in a frame
	add	a14,a11			;adjust by extra pixels done last time

;	cmpi	2,a4
;	jrne	#nxtf
;	movi	blowlinelastfrm,b10

#nxtf
	PUSH	a0,a1,a2
	calla	get_all_buttons_cur
	PULL	a0,a1,a2
	jrnz	#abort


	dsj	a4,#lp			;Loop once for each frame

#abort
	callr	movie_waitdma
					;>Copy visable frame to other page
	move	*a13(PIXPERFRM),a14,L	;# of pixels in a frame

	move	b4,*b8			;Set pallette

	move	a10,a2 			;* screen
	xori	PAGE1YO*512*8,a2	;Flip * to other page
#cpylp
	move	a2,a0
	move	a10,a1

	move	b9,a5			;X size
	srl	1,a5			;X/2 = loop counter
#cllp	move	*a0+,*a1+
	dsj	a5,#cllp

	subi	SCRN_PTCH,a2
	subi	SCRN_PTCH,a10
	move	b9,a0
	sub	a0,a14
	jrgt	#cpylp			;More pixels?


#x
	RETP


#error	LOCKUP
	jruc	#x


********************************


GoToSleep
	getst	b2
	move	a12,b6
	mmtm	b6,b2,b3,b4,b5,b9,b10
	move	b6,a12

	setf	16,1,0
	setf	32,0,1
	move	a14,*a13(PTEMP1),L
	calla	PRCSLP

	move	a12,b6
	mmfm	b6,b2,b3,b4,b5,b9,b10
	move	b6,a12

	callr	SetConstants
	move	*a13(PTEMP1),a14,L

	putst	b2
	exgpc	a14			;Return



********************************
* Uncompress a single frame
* A0=Address mask for circular buffer
* A8=* to compressed data
* A9=* to buffer for uncompressed bytes
* A11=How many to place before returning
* B0=*Length tree
* B1=*Distance tree
*
*Trashes:
*	a1 = Distance
*	a2 = ptr to leftover data if there is any
*	a4 = Length
*
* ReadTree uses A2-A5,A7,A14,B6
* Need to Preserve: 	B9-B10

UncompressFrame:

	setf	16,0,1		;Field 1 = 16 bits no sign-ext
	move	b4,*b8,1	;Set pallette

UncFr0
	setf	1,0,0
	move	*a8+,a14	; if bit = 1, read 8 bits and copy
	.if	ERRORTEST
	move	@HCOUNT,a14
	.endif
	jrz	decode_still
	setf	8,0,0

	move	*a8+,*a9+
	and	a0,a9

	addk	1,b5		; pixel count
	subk	1,a11
us1
	cmp	b5,b9		; have we filled a line yet?
	jrgt	us0

    	call	b10		; Blow Line Routine

us0
	move	a11,a11
	jrgt	UncFr0

	setf	16,1,0
	setf	32,0,1
	RETP


decode_still:		 	; if bit = 0, decode from trees
	setf	6,0,0
	move	*a8+,a1		; lower 6 bits of distance

	.if	ERRORTEST
	move	@HCOUNT,a1
	.endif

	move	b1,a5		; Distance Tree in a5
	callr	ReadTree	; Result in a7
	sll	6,a7
	or	a7,a1
	inc	a1		; DISTANCE in a1
	sll	BPP,a1		; turn it into a pointer

	move	b0,a5		; Length Tree in a5
	callr	ReadTree	; Result in a7

	setf	8,0,0

	cmpi	63,a7
	jrne	notmaxs
	move	*a8+,a3		; If length is 63, get next byte, and

	.if	ERRORTEST
	move	@HCOUNT,a3
	.endif

	add	a3,a7		; add it to the length
notmaxs
	addk	2,a7		; add MML, LENGTH in a7

;	We now have Length and Distance,  now determine where to copy from

	move	a9,a2		; copy of current position in a2
	sub	a1,a2  		; initial attempt
	and	a0,a2		; handle wraparound
	or	a6,a2		;copy pointer is now in a2

	sub	a7,a11		;Adjust total pixel count
	move	a7,b6
	add	b6,b5	    	;Adjust pixel counter for this line

copys
	move	*a2+,*a9+	;>Copy
	and	a0,a2
	and	a0,a9
	dsj	a7,copys

	jruc	us1


#*******************************
* Read compression tree
* A5=*Tree table
* A8=*Compressed data
* Field 1 = 16 bits
* >A7=Data
*
* Trashes: A2-A5,A14,B6
*
* Must preserve: A0,A1,A6,A8-A11

ReadTree:
	movk	1,a2		; bits_read
	setf	1,0,0
	move	*a8+,a7		; read a bit
	rl	31,a7		; rotate right one more bit
	clr	b6		; result
	jruc	#strt
#lp
	addk	1,b6
#strt	move	*a5+,a3,1	; Code in a3
	move	*a5+,a4,1	; Blngth in a4
	movk	32,a14
	sub	a2,a14
	rl	a14,a3		; rotate right as many bits have been read
#lp2
	cmpxy	a3,a7
	jrynz	#lp

	cmp	a2,a4
	jreq	#x
	move	*a8+,a14	; read a bit
	or	a14,a7		; accumulate with other bits
	inc	a2		; inc bits_read
	rl	31,a7		; rotate right one more bit
	rl	31,a3		; shift code for check of next bit
	jruc	#lp2

#x
	move	b6,a7
	rets			;Result returned in a7



#*******************************
* BlowLine is used during decompression of a Still Picture to blow out
* a single line of data.  Since only a single line needs to be stored at
* once, the RamBuffer can be as small as 4K.
* A0=Address mask for circular buffer
* Field 1 = 16 bits
* Trashes A1-A2,A5

 SUBRP	blowline

;	setf	32,0,0

	move	a10,a2 		;* screen

	move	b3,a1		;Start of line
	move	b9,a5		;X size
	srl	2,a5		;X/4 = loop counter
	jrnc	#by4
	move	*a1+,*a2+,1	;Copy 2 pixels
	and	a0,a1
#by4
#lp
	move	*a1+,*a2+,1	;Copy 2 pixels
	and	a0,a1
	move	*a1+,*a2+,1	;Copy 2 pixels
	and	a0,a1
	dsj	a5,#lp


endblowline
	subi	SCRN_PTCH,a10
	move	a1,b3		;save for next frame
	sub	b9,b5		;readjust pixels for next line
	cmp	b9,b5		;added 6/92. if there are enough pixels
	jrge	#nuther		;left to do another line, do it.

      	rets

#nuther
	jruc	blowline


#*******************************
* BlowLine is used during decompression of a Still Picture to blow out
* a single line of data.  Since only a single line needs to be stored at
* once, the RamBuffer can be as small as 4K.
* A0=Address mask for circular buffer
* Field 1 = 16 bits

 SUBRP	blowlinex2


	move	a10,a2 		;* screen
	move	a10,a3
	addi	SCRN_PTCH,a3

	move	b3,a1		;start of line
	move	b9,a5		;X size

	setf	8,0,0
#lp
	move	*a1+,a14	;Get 8 bits
	move	a14,a4
	sll	8,a4
	or	a4,a14
	move	a14,*a2+,1	;16 bits
	move	a14,*a3+,1
	and	a0,a1
	dsjs	a5,#lp


	subi	SCRN_PTCH*2,a10
	move	a1,b3		; save for next frame
	sub	b9,b5		; readjust pixels for next line
	cmp	b9,b5		; added 6/92. if there are enough pixels
	jrge	#nuther		; left to do another line, do it.

      	rets

#nuther
	jruc	blowlinex2


********************************
* Show movies (test) (Process)

; SUBR	movie_test
;
;	calla	pal_clean
;
;	movi	5*60,a1			;Delay tv score panel
;	move	@tvpanelon,a0,L
;	move	a1,*a0(PTIME)
;	
;	movi	[9,0],a9
;	movi	[>8c,0],a10
;	movi	(24+83*512)*8,a11	;XY
;
;	move	@last_score,a0,L
;	cmpi	scores,a0
;	jrz	#tm1
;
;	movi	[9+216,0],a9
;	movi	[>8c,0],a10
;	movi	>53780,a11		;XY
;
;#tm1	callr	show_edging		;Turn on clip borders
;
;	SLEEPK	10
;
;	movi	GRANT_F,a8
;	clr	a9
;
;	move	a11,a10
;	JSRP	movie_run
;
;	movi	>2001,a0
;	calla	obj_del1c
;
;	movk	10,a1			;Delay tv score panel
;	move	@tvpanelon,a0,L
;	move	a1,*a0(PTIME)
;
;	DIE


;********************************
;
; SUBRP	show_edging
;
;	move	a9,a0
;	move	a10,a1
;
;	movi	livet,a2
;	movi	19989,a3		;z pos - Below buyin box
;	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
;	movi	>2001,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;
;	move	a9,a0
;	move	a10,a1
;	movi	liveb,a2
;	calla	BEGINOBJ2
;
;	move	a9,a0
;	move	a10,a1
;	movi	livel,a2
;	calla	BEGINOBJ2
;
;	move	a9,a0
;	move	a10,a1
;	movi	liver,a2
;	calla	BEGINOBJ2
;
;	rets
;
;

#*******************************
* Show movies in attract mode

; SUBR	movie_demo
;
;	calla	pal_clean
;
;	movi	GRANT_F,a8
;	clr	a9
;	movi	(100+50*512)*8,a10	;XY
;	JSRP	movie_run
;
;	movi	PIPPEN_F,a8
;	clr	a9
;;	movi	(140+70*512)*8,a10	;XY
;	movi	(100+70*512)*8,a10	;XY
;	JSRP	movie_run
;
;;	movi	GRANT_F,a8
;;	movk	1,a9
;;	movi	(100+50*512)*8,a10	;XY
;;	JSRP	movie_run
;;
;;	movi	PIPPEN_F,a8
;;	movk	1,a9
;;	movi	(140+70*512)*8,a10	;XY
;;	JSRP	movie_run
;
;#x	RETP


********************************
* Same as BlowLine, but blows to both screens
* Trashes A1,A3-A5

;blowlinelastfrm
;
;	move	a10,a3 		; where on screen to put
;	move	a3,a4
;	xori	PAGE1ADR,a4
;	move	b3,a1		; start of line
;	move	b9,a5		; X size
;	srl	1,a5		; X/2 = loop counter
;
;spbl1
;	move	*a1+,a14,1		; write into both screens
;	move	a14,*a3+,1
;	move	a14,*a4+,1		; write into both screens
;	and	a0,a1
;	dsjs	a5,spbl1
;
;	jruc	endblowline

	.end
