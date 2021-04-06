 	.MLIB	"APMACS.LIB"
	.FILE	"APUNZIP.ASM"
	.TITLE	"<<< AMUSEMENT PARK - UNZIPPER WBD  9/3/91 >>>"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

**************************************************************************
*								         *
* 	COPYRIGHT (C) 1992 MIDWAY MANUFACTURING COMPANY.		 *
* 		       ALL RIGHTS RESERVED.				 *
*								         *
**************************************************************************

	.INCLUDE	"AP.H"
	.INCLUDE	"STRING.H"
	.INCLUDE	"IMGTBL.GLO"

* from AP.ASM
	.REF	MOVIE_KILL, DUXNOFADE, SLEEP_SWITCHX
* from APPALL.ASM
	.ref	PALSET,	FREEPALCNT
* from APFADE.ASM
	.ref	FADEINS,FADEBLAK,FADE_256_OUT,FADEFULL_TEXT,FADEOUT
	.ref	FADEBLAK_TEXT,FADEOUT_TEXT,FADEIN_TEXT,FADEIN_TEXTSLW, FADEIN
	.ref	FADE_64_BLAK,FADE_64_IN,FADEOUTRED
	.ref	FADE_256_BLAK,FADE_256_IN

STILNOFADE:
	.long	T2FIXED, BLUPLAYR, REDPLAYR, 0

*
*	MONTENT	clipname,scrnX,scrnY,Text,Sndtable
*
MONTENT	.MACRO	P1,P2,P3,P4,P5
	.long	:P1:	    		
	.long	(:P2:*8)+(:P3:*SCRN_PTCH)
	.long	:P5:,:P4:
	.ENDM

*
*	GOOM	clipname,scrnX,scrnY
*
GOOMENT	.MACRO	P1,P2,P3,P4
	.long	:P1:	    		
	.long	(:P2:*8)+(:P3:*SCRN_PTCH)
	.long	:P4:
	.ENDM


LINE	.set	1
ART	.set	0
PREVIEW	.set	0

	.if	ART
COLORPAL	.set 01800000h
	.else
COLORPAL	.set 01810000h
	.endif
DMAPAL	.set	1a80080h

BPP		.set 	3
RAMBUFSIZ	.set	(4*1024)*8		; << BPP
SCRN_ST		.set	(170*SCRN_PTCH)+(150*8)
PXLS_PR_TIK	.set	10000


	.if	DEBUG
	.bss	NUM_LINES,32
	.endif

	.bss	FRAMENUM,16
	.bss	CLIPSND,32
	.bss	HOLDFADE,16	; time to hold first frame

	.text

*
*	started from STILL
*
DELAYFADE:
	sleep	6
	movi	DUXNOFADE,a0
	dec	a11
	jrz	slfade
	calla	FADEIN
	DIE

slfade:
	calla	FADEINS
	DIE


*	a8 = ptr to frames
*	a10 = screen dest
*	a11 = controlling process  (0 if none)
MOVIE_PROC
	mmtm	a12,a11
	clr	a14
	move	a14,@FRAMENUM
	JSRP	MOVIE
*
*	Tell Montage Process to continue
*
	mmfm	a12,a11
	move	a11,a11			; is there a controlling process?
	jrz	nomontage
	clr	a14			; if yes, get clr reg a11 of that process
	move	a14,*a11(PA11),L	;	  (to tell it we are done)
	move	*a13(PTEMP1+16),*a11(PA10),L	; and put last palette slot in reg a10
nomontage:
	
	DIE


*
*	a8 = start of compressed picture data
*	a10 = screen address of picture start
*
MOVIE:
	move	@PAGE,a14
	jrnz	nopgchg
	addi	PAGE1ADR,a10	; start in page 1 if page 0 is currently displayed
nopgchg:

	callr	ParseHeader
	callr	ALLOCPALS
	jrz	nostill			; and return... 	
					;	a6 = X size
					;	b3 = Y size
					;	a4 = # frames
					;	b4 = strtpal
					;	     (if hi bit set, means single pal)
	MOVIM	07fffh,*a13(PTEMP1),W
	JSRP	DECOMPRESS
	setf	32,0,1
	setf	16,1,0

	RETP

*
*	a10 = 0 if you want to center still in Y
*	a8 = start of compressed picture data
*	a11 = 1 start faded do slow fade,
*	     2 start faded, do normal fade
*	     0 no fade
*
STILL:
	CLRM	@HOLDFADE,W
	callr	ParseHeader    
	move	a10,a10
	jrnz	nocentery
	movi	SCRHGHT,a10
	sub	a10,a1
	neg	a1
	srl	1,a1
	sub	a1,a10
	dec	a10
nocentery:
	sll	12,a10			; shift over to make address
	
	movi	SCRWIDTH,a14
	sub	a6,a14
	addk	5,a14
	srl	2,a14
	sll	4,a14		; get bit address
	add	a14,a10		; center based on X size of picture
	
*
*	ColorPalette...  Start of Palette data in a8, Number of colors in a7
*
	callr	ALLOCPALS
	jrz	nostill		; and return... 	
					;	a6 = X size
					;	b3 = Y size
					;	a4 = # frames
					;	b4 = strtpal
					;	     (if hi bit set, means single pal)
	move	a11,a11
	jrz	nofade
	move	b3,a2
	move	b4,a3
	mmtm	a12,a2,a3,a4,a6
	clr	a0
	calla	FADEBLAK
	SLEEP	1
	CREATE	PFADEPID,DELAYFADE
	mmfm	a12,a2,a3,a4,a6
	move	a2,b3
	move	a3,b4
	move	a6,b9
nofade:
	MOVIM	PXLS_PR_TIK,*a13(PTEMP1),W
	JSRP	DECOMPRESS
nostill:	
	setf	32,0,1
	setf	16,1,0
	RETP



**************************************************************************
*								         *
* ALLOCPALS - ALLOCATES A PALETTES FOR MOVIE FOOTAGE     		 *
*       A8 = ADDRESS OF COLOR DATA	    				 *
*	A7 = NUMBER OF COLORS
* RETURNS:								 *
* 	 Z = FAILURE, NO PALETTES FREE					 *
* 		A0 = 0							 *
* 	NZ = PALETTE ALLOCATED						 *
* 		A0 = STARTING COLOR MAP (0000 - 0F0F)  			 *
*								         *
**************************************************************************
ALLOCPALS:
*CHECK FOR A SPARE PALETTE
	MOVI	NUMPAL,A3
	MOVI	PALRAM,A5	
ALLPL1:	
	MOVE	*A5(PALCNT),A2,W
	JRNE	CKNXTPAL		;PALETTE NOT EMPTY

	;CHECK TIME WHEN FREED, CAN'T REALLOCATE ON SAME TIK
	MOVE	*A5(PALTIME),A2,W
	JRZ	ALLPAL2
	MOVE	@WAVEIRQS,A14,W		;ONLY NEED THE BOTTOM 16 BITS
	CMP	A2,A14
	JRNE	ALLPAL2		;PALETTE OK TO GRAB
CKNXTPAL
	ADDI	PALRSIZ,A5
	DSJS	A3,ALLPL1

	CLR	A0		;NO PALETTES DEFAULT 0 AND 
	JRUC	uzabt		;SPLIT

*SETUP YOUR NEW PALETTE
ALLPAL2:
;	move	a7,a14
;	sll	8,a7
;	add	a7,a14
;	move	a14,b4
;	srl	8,a7
;	jrnz	donxt
;	ori	80000000h,b4
;donxt:
;	move	*a8+,a2		; number of colors in this palette

	move	a7,a2		; number of colors in palette
	ori	80000000h,b4
	CALLA	SET1PAL		; SETUP PALETTE TRANSFER
	jreq	uzabt		; abort
	sll	4,a2
	add	a2,a8		; adjust condensed pointer accordingly
;	dec	a7
;	jrge	donxt

	move	a0,b14		; adjust start palette
;	subxy	b4,b14
	movx	b14,b4
	inc	b14		; clear z flg
uzabt:
	rets	


SET1PAL:
	MOVE	*A5(PALCNT),A14,W
	JRNE	ALLPLX			;PALETTE NOT EMPTY

	DECM	@FREEPALCNT,W

	MOVE	A3,A1		;PALETTE #
	SUBI	NUMPAL,A1	;COMPUTE PALETTE #
	NEG	A1
	move	a1,*a13(PTEMP1+16) ; save slot number

;	.IF	YUNIT
;	MOVE	A1,A14		;MOVE BITS 4,5 TO 6,7 FOR YUNIT
;	SLL	28,A1		;STRIP OFF BITS 4,5
;	SRL	28,A1
;	SRL	4,A14
;	SLL	6,A14
;	ADD	A14,A1
;	.ENDIF

	SLL	8,A1		;X 256

	move	a8,a0
	calla	PALSET
	jreq	ALLPLX
;	subk	16,a0		; include word with num colors
	MOVE	A0,*A5,L	;STUFF PALETTE I.D.
ALLPL3:
	move	a1,a0
	srl	8,a0
	add	a1,a0
	
	MOVE	*A5(PALCNT),A14,W	;INCREMENT COUNT
	ADDK	1,A14			;SET NE FOR SUCCESS 
	MOVE	A14,*A5(PALCNT),W
	dec	a3
	addi	PALRSIZ,a5
ALLPLX:
	RETS




****************************************************************
*
*	a8 = Ptr to compressed data
*
*	Returns:  a6 and b9 = X
*		  b3 = Y
*		  a4 = # frames
*                 a7 = # colors in palette
*
ParseHeader:
	move	*a8+,a6		; X size of frames
	move	*a8+,a1		; Y size of frames
	move	*a8+,a4		; number of frames
	move	*a8+,a7		; number of colors
	move	a1,b3
	move	a6,b9
	rets	

;LengthTree	.set	RamBuffer+RAMBUFSIZ
;DistTree	.set	LengthTree+(256*32)
;MinPtrTbl	.set	DistTree+(256*32)
;	.bss 	RamBuffer,RAMBUFSIZ

RamBuffer	.set	1000000h
	.bss	LengthTree,256*32
	.bss	DistTree,256*32
	.bss	MinPtrTbl,256*32


	.sect	"UNZIP"

*
*	GSP Decompression routine
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
*		b5 = used for outputting pal bits to DMAPAL
*		b6 = pixel sleep count
*		b7 = constant mask for pxl palette split
*		b8 = DMAPAL
*		b9  = Master X storage
*		b0 = Ptr to Length tree
*		b1 = Ptr to Distance tree
*		b3 = start of line
*		b4 = start palette duped to fill 16 bits 
*                               (bit 31 set if only 1 palette used)
*		b14 = temp storage in ReadTree and UncompressTree
*


****************************************************************
*
*	a8 = Ptr to compressed data
*	a7 = Ptr to tree table
*
UncompressTree:
*
*	Determine how many codes of each bit length
*
	setf	8,0,0
	move	*a8+,a0		; # compressed bytes to describe tree - 1;
	inc	a0
	movk	0fh,a3		; constant 0xF
	clr	a6		; total number of codes in tree
	move	a7,a5		; save start of tree
*
utr0:
	move	*a8+,a1		; (# codes - 1 << 4) | bit lngth - 1
	move	a1,a2
	srl	4,a2
	inc	a2		; number of codes of this bit length
	add	a2,a6		; adjust total
	and	a3,a1
	inc	a1		; bit length
	move	a1,a11
	sll	16,a11
	movy	a11,a1		; duplicate bit length for sort
utr1:
	move	a1,*a7+,L
	dsjs	a2,utr1		; fill table

	dsjs	a0,utr0		; a6 now contains size of tree
	setf	16,1,0
*
*	Sort Tree by increasing Bit Length.
*		The translation index is placed in the upper byte 
*		of the long word. 
*
	movi	MinPtrTbl,a0	; for placing translation ptrs
	move	a6,a9		; outer loop count (# entries in tree table)
*
*	Outer loop, after each pass, we have found the next minimum
*
utr2:
	move	a5,a7		; restore start of tree
	movi	06543h,a14	; current minimum
	move	a6,b14		; inner loop count	
	movi	07654h,a1	; constant
*
*	Inner loop, go through all values in table and find min.
*	When we find it, we set it to a high value so we don't detect
*	it again.
*
utr3:
	move	*a7,a2		; look at next bit length
	cmp	a14,a2		; is it less than the last minimum
	jrge	nonewmin
	move	a2,a14		; if yes, save new minimum
	move	a7,a11		;         save pointer to minimum
nonewmin:
	addk	32,a7		; point to next entry
	dsjs	b14,utr3
*
*	end of inner loop: min is in a14, ptr to min is in a7
*
	move	a1,*a11		; set this minimum high.
	move	a11,*a0+,L	; place translation ptr in MinPtrTbl.

	dsjs	a9,utr2
*
*	END OF SORT,  Now compute the codes
*
	clr	a11		; Code
	clr	a1		; CodeInc
	clr	a2		; LastBitLength
	move	a6,a14		; loop counter
utr4:
	move	*-a0,a7,L	; translated pointer
	add	a1,a11
	movb	*a7(16),a3	; bit length
	cmp	a3,a2
	jreq	samebitlng
	move	a3,a2		; set new LastBitLength
	movk	16,a3
	sub	a2,a3		; 16-LastBitLength
	movk	1,a1
	sll	a3,a1		; CodeInc = 1 << (16-LastBitLength)
samebitlng:
	move	a11,a5		; copy of Code in a5
	movk	16,a9		; reverse bit loop count
rvrsbts:
	sll	1,a5		; Reverse bits of word
	movy	a5,a3
	srl	1,a3
	zext	a5
	dsjs	a9,rvrsbts

	move	a3,*a7		; store code with bits reversed
	dsjs	a14,utr4
	
	rets


*	a8 = (sgn bit = 1, 1 pal, otherwise 4 pals)
*		(low 16 bits contain repeated palette slot number
*
HOLD_FADE_PROC:
	move	a8,a9
	sll	24,a9
	srl	24,a9		; save 8 bits only
	sleep	2		; let palette get loaded
	move	a9,a0
	move	a8,a8
	jrn	unoout
	calla	FADE_256_BLAK	; bring to zero
	jruc	hfphk1
unoout:
	calla	FADE_64_BLAK
hfphk1:
	sleep	4		; let it fade
	move	a9,a0
	move	a8,a8		
	jrn	unoin
	calla	FADE_256_IN	; fade in
	jruc	hfphk2
unoin:
	calla	FADE_64_IN
hfphk2:
	DIE


SetConstants:
	movi	LengthTree,b0
	movi	DistTree,b1
SetConstX:
	movi	RamBuffer+RAMBUFSIZ-1,a0	; mask for rambuf ptr
	movi	RamBuffer,a6 	; used for negative wraparound
	movi	0c0c0h,b7	; for blowing words of 
	movi	DMAPAL,b8     
	move	*a13(PTEMP1),a14   	; pixels between sleep
	move	a14,b6
	movi	BlowLine,b10
	rets


MovieSleep:
	movk	1,a0		; assume a 1 tick sleep
	move	@FRAMENUM,a14	; if 1st frame, check for hold
	jrz	chk4hold
	dec	a14
	jrnz	nonono
	move	@HOLDFADE,a14	; on second frame, wait for hold time
	add	a14,a0
	jruc	nonono

chk4hold:
	move	@HOLDFADE,a14
	jrz	nonono		; if need to hold, create fade process
	PUSH	a8
	move	b4,a8
	CREATE	PID_IND,HOLD_FADE_PROC
	PULLQ	a8
	movk	6,a0		; sleep longer if we are fading palette
nonono:
	movi	swappg,a14
	jruc	GoToSleep
swappg:
	move	@VCOUNT,a4
	cmpi	200,a4
	jrle	swappg
	mmfm	a12,a4,a10
*
*	Swap Display Pages between frames
*
	PUSH	a0
	clr	a3
	movi	DPYSTRT0,a14
	movi	PAGE1ADR,a0	; change screen address for swap
	btst	20,a10		; which page are we on?
	jrz	onp1
	neg	a0
	movi	DPYSTRT1,a14
	movk	1,a3
onp1:	
	add	a0,a10
	setf	16,1,0
	move	A14,@DPYSTRT,W
	move	a3,@PAGE,W

	move	@FRAMENUM,a14	; sound only on first frame
	jrnz	no
	move	@CLIPSND,a0,L	; sound from sound table
	jrz	no
	calla	ONESND
no:
	PULLQ	a0
	inc	a14
	move	a14,@FRAMENUM		; save next frame number

	move	*a13(PTEMP3),a14,L	; number of pixels in a frame
	add	a14,a11			; adjust by extra pixels done last time

	cmpi	2,a4
	jrne	nxtfrm
	movi	BlowLineLastFrm,b10
	jruc	nxtfrm



StillSleep:
	movk	1,a0
	movi	us0,a14			; return address
GoToSleep:
	getst	b2
	move	a12,b14
	mmtm	b14,b2,b3,b4,b5,b9
	move	b14,a12
	setf	32,0,1
	setf	16,1,0
	move	a14,*a13(PTEMP2),L
	calla	PRCSLP

	move	a12,b14
	mmfm	b14,b2,b3,b4,b5,b9
	move	b14,a12

	callr	SetConstants
	move	*a13(PTEMP2),a14,L

	putst	b2
	exgpc	a14


*
*	ENTERING:
*		a4 = Number of frames
*		a8 = Ptr to Compressed Data Table
*		b3 = Y size
*		b4 = strt pal
*		b9 = X size
*
DECOMPRESS:
	movi	LengthTree,b0
	movi	DistTree,b1

	move	b0,a7			; Length Tree
	callr	UncompressTree

	move	b1,a7			; Distance Tree
	callr	UncompressTree
*
*	clear upper 4K of RamBuffer to take care of initial wraparound
*
	movi	RamBuffer+RAMBUFSIZ,a1		; end of buffer
	movi	1024,a2				; 4K bytes = 1K long words
	clr	a3
clrbuf:
	move	a3,*-a1,L
	dsjs	a2,clrbuf
*
*	Do some initializing
*
	mpyu	b9,b3
	move	b3,a11		; total # bytes in frame in a11
	move	a11,*a13(PTEMP3),L
	callr	SetConstX
	move	a6,a9		; Where to uncompress to
	move	a9,b3		; first frame start
	clr	b5		; pixel count for Stills only
	cmpi	1,a4
	jreq	UncompressFrame
*	   .align
nutha1:
	.if DEBUG	
	CLRM	@NUM_LINES,L
	.endif
	mmtm	a12,a4,a10
	JSRP	UncompressFrame	; a7 is available
	jruc	MovieSleep	; to swap display pages and sleep
nxtfrm:
	dsjs	a4,nutha1	; loop once for each frame

	RETP


*******************************************************************
*
*	Entry:	Table in a5
*		Compressed data ptr in a8
*
*	Uses:	a2 = bits read
*		a3 = Code
*		a4 = Blngth
*		a14 = temp storage
*		a7 = data parsed from input stream
*
*	Must preserve:
*		a9, a1, a6, a11, a8, a0, a10 
*
ReadTree:
	movk	1,a2		; bits_read
	clr	b14		; result
	setf	1,0,0
	move	*a8+,a7	; read a bit
	rl	31,a7		; rotate right one more bit
rtlp:
	move	*a5,a3,L	; Code in a3
	move	*a5(16),a4,L	; Blngth in a4
	movk	32,a14
	sub	a2,a14
	rl	a14,a3		; rotate right as many bits have been read
rtlp2:
	cmpxy	a3,a7
	jryz	ident
	addk	32,a5
	inc	b14
	jruc	rtlp
ident:
	cmp	a2,a4
	jrz	finis
	move	*a8+,a14	; read a bit
	or	a14,a7		; accumulate with other bits
	inc	a2		; inc bits_read
	rl	31,a7		; rotate right one more bit
	rl	31,a3		; shift code for check of next bit
	jruc	rtlp2

finis:
	move	b14,a7		; leave result in a7
	rets			; Result returned in a7



******************************************************************************
*
*	BlowLine  is used during decompression of a Still Picture to blow out
*	a single line of data.  Since only a single line needs to be stored at
*	once, the RamBuffer can be as small as 4K.
*
BlowLine:
	.if DEBUG
	INCM	@NUM_LINES,L
	.endif
	move	a10,a3 		; where on screen to put
	move	b3,a1		; start of line
	move	b9,a5		; X size
	srl	1,a5		; X/2 = loop counter

	move	b4,b4
	jrn	SglPalBlowLine
	move	b7,a2		; mask

BlowL1:
	move	*a1+,a14,L
	and	a0,a1
	move	a14,b14
	andn	a2,a14
	and	b7,b14
	srl	6,b14
	add	b4,b14
	move	b14,*b8,L	; write palette register
	move	a14,*a3+,L	; write data to screen
	dsjs	a5,BlowL1

EndBlowLine:
	subi	SCRN_PTCH,a10
	move	a1,b3		; save for next frame
	sub	b9,b5		; readjust pixels for next line
	CMP	B9,B5		; ADDED 6/92. If there are enough pixels
	JRGE	NUTHER		; left to do another line, do it.
	sub	b9,b6		; pixel sleep count
	jrgt	noslp
      	clr	b6		; set zero flag to indicate sleepytime
noslp:
      	rets

NUTHER:
	SUB	B9,B6
	JRUC	BlowLine

SglPalBlowLine:
	move	b4,*b8,L		; Set Pallette Register
SPBlowL1:
	move	*a1+,*a3+,L		; write into both screens
	and	a0,a1
	dsjs	a5,SPBlowL1

	jruc	EndBlowLine



****************************************************************
*
*	a8 = Ptr to compressed data
*	a9 = Where to put uncompressed bytes
*	a11 = How many to place before returning.
*	a0 = mask for a9
*
*	Uses:	a4 = Length
*		a1 = Distance
*		a2 = ptr to leftover data if there is any
*
*	ReadTree uses a2-a5,a7,a14
*	Need to Preserve: 	B9-B13
*	 			a0 = Ram Buffer addr mask
UncompressFrame:
	setf	16,0,1		; FIELD 1 IS 16 BITS!!!
UncFr0:
	setf	1,0,0
	move	*a8+,a14	; if bit = 1, read 8 bits and copy		
	jrz	decode_still
	setf	8,0,0

	move	*a8+,*a9+
	and	a0,a9
	
	inc	b5		; pixel count
	dec	a11
us1:
	cmp	b5,b9		; have we filled a line yet?	
	jrgt	us0
    	call	b10		; Blow Line Routine
	jrz	StillSleep
us0:	
	move	a11,a11
	jrgt	UncFr0
	setf	32,0,1
	RETP

decode_still:		 	; if bit = 0, decode from trees
	setf	6,0,0
	move	*a8+,a1		; lower 6 bits of distance
	move	b1,a5		; Distance Tree in a5
	callr	ReadTree	; Result in a7
	sll	6,a7
	or	a7,a1			
	inc	a1		; DISTANCE in a1
	sll	BPP,a1		; turn it into a pointer

	move	b0,a5		; Length Tree in a5
	callr	ReadTree	; Result in a7
	move	a7,a4
	cmpi	63,a4
	jrne	notmaxs
	setf	8,0,0		; If length is 63,
	move	*a8+,a3		; get next byte, and 
	add	a3,a4		; add it to the length
notmaxs:
	addk	2,a4		; add MML, LENGTH in a4
	setf	8,0,0
*
*	We now have Length and Distance,  now determine where to copy from
*
	move	a9,a2		; copy of current position in a2
	sub	a1,a2  		; initial attempt
	and	a0,a2		; handle wraparound
	or	a6,a2
*
*	COPY POINTER is now in a2, do the copying
*
	move	a4,a14
copys:
	move	*a2+,*a9+
	and	a0,a9
	and	a0,a2
	dsjs	a14,copys

	move	a4,b14
	add	b14,b5	    	; adjust pixel counter for this line
	sub	a4,a11		; adjust total pixel count
	jruc	us1


******************************************************************************
*
*	Same as BlowLine, but blows to both screens
*
BlowLineLastFrm:
	move	a10,a3 		; where on screen to put
	move	a3,a4
	xori	PAGE1ADR,a4
	move	b3,a1		; start of line
	move	b9,a5		; X size
	srl	1,a5		; X/2 = loop counter

	move	b4,b4
	jrn	SglPalBLLF
	move	b7,a2		; mask
	

BlowL1LF:
	move	*a1+,a14,L
	and	a0,a1
	move	a14,b14
	andn	a2,a14
	and	b7,b14
	srl	6,b14
	add	b4,b14
	move	b14,*b8,L	; write palette register
	move	a14,*a3+,L	; write data to screen
	move	a14,*a4+,L	; write data to screen
	
	dsjs	a5,BlowL1LF
	jruc	EndBlowLine


SglPalBLLF:
	move	b4,*b8,L		; Set Pallette Register
SPBL1:
	move	*a1+,a14,L		; write into both screens
	move	a14,*a3+,L
	move	a14,*a4+,L		; write into both screens
	and	a0,a1
	dsjs	a5,SPBL1

	jruc	EndBlowLine



