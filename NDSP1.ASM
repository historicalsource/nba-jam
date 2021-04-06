**************************************************************************
*
* Owner:	THOMPSON
*
*	GSP DMA OBJECT HANDLER
*
*	Version 1.0  By Warren Davis 9/1/87
*	Version 2.01 By Eugene Jarvis 10/25/87
*	Version 3.0  By Eugene Jarvis 12/20/87
*	Version 3.1  By Eugene Jarvis 7/4/88
*	Version 3.2  By Eugene Jarvis 8/8/88
*	Version 3.21 By Shawn Liptak 7/24/91 - Minor improvements (Total carnage)
*	Version 3.3  By Shawn Liptak 9/13/91 - More improvements
*	Version 4.0  By Shawn Liptak 1/27/92 - Basketball started
*	Version 4.1  By Shawn Liptak 3/23/92 - DMA 2 version
*	Version 4.2  By Shawn Liptak 7/23/92 - Faster
*	Version 4.3  By Shawn Liptak 10/2/92 - Added dtype
*
*	COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 10/5/93 18:53
*.Last mod - 4/17/95 -- JBJ -- for WWFUNIT
*
*	Version 4.4  -- DJT ??/??/95 - NBA/2
*
**************************************************************************
	.file	"ndsp1.asm"
	.title	"GSP display processor V 4.4"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	gsp.equ
	.include	sys.equ
	.include	mproc.equ
	.include	disp.equ
	.include	macros.hdr
	.include	"world.equ"		;Court-world defs
	.include	GAME.EQU


;--------------------
; globals elsewhere

	.if	DEBUG
	.ref	SLDEBUG
	.endif

	.ref	pup_court
	.ref	HALT,pal_getf,FRANIMQ
;	.ref	_3d_build
;	.ref	d3vis_p
	.ref	PCNT
	.ref	crt_colors
	.ref	dirq_wait
	.ref	SYSCOPY,IRQSKYE


;--------------------
; globals in here

	.def	scale_t,scale_t_sm,scale_t_size
	.def	scalebaby_t,scalehead_t,scalebighead_t,scalehugehead_t
	.def	scale57_t,scale57et_t,scale57t_t,scale57f_t,scale57ef_t
	.def	scale58_t,scale58et_t,scale58t_t,scale58f_t,scale58ef_t
	.def	scale59_t,scale59et_t,scale59t_t,scale59f_t,scale59ef_t
	.def	scale510_t,scale510et_t,scale510t_t,scale510f_t,scale510ef_t
	.def	scale511_t,scale511et_t,scale511t_t,scale511f_t,scale511ef_t
	.def	scale60_t,scale60et_t,scale60t_t,scale60f_t,scale60ef_t
	.def	scale61_t,scale61et_t,scale61t_t,scale61f_t,scale61ef_t
	.def	scale62_t,scale62et_t,scale62t_t,scale62f_t,scale62ef_t
	.def	scale63_t,scale63et_t,scale63t_t,scale63f_t,scale63ef_t
	.def	scale64_t,scale64et_t,scale64t_t,scale64f_t,scale64ef_t
	.def	scale65_t,scale65et_t,scale65t_t,scale65f_t,scale65ef_t
	.def	scale66_t,scale66et_t,scale66t_t,scale66f_t,scale66ef_t
	.def	scale67_t,scale67et_t,scale67t_t,scale67f_t,scale67ef_t
	.def	scale68_t,scale68et_t,scale68t_t,scale68f_t,scale68ef_t
	.def	scale69_t,scale69et_t,scale69t_t,scale69f_t,scale69ef_t
	.def	scale610_t,scale610et_t,scale610t_t,scale610f_t,scale610ef_t
	.def	scale611_t,scale611et_t,scale611t_t,scale611f_t,scale611ef_t
	.def	scale70_t,scale70et_t,scale70t_t,scale70f_t,scale70ef_t
	.def	scale71_t,scale71et_t,scale71t_t,scale71f_t,scale71ef_t
	.def	scale72_t,scale72et_t,scale72t_t,scale72f_t,scale72ef_t
	.def	scale73_t,scale73et_t,scale73t_t,scale73f_t,scale73ef_t
	.def	scale74_t,scale74et_t,scale74t_t,scale74f_t,scale74ef_t
	.def	scale75_t,scale75et_t,scale75t_t,scale75f_t,scale75ef_t
	.def	scale76_t,scale76et_t,scale76t_t,scale76f_t,scale76ef_t
	.def	del_transition_objs

	.def	scale77ef_t

;--------------------
; Constants


;--------------------
; global linked-list pointers

	.sect	"OBJBSS"

OBJLST	.long	0		;*Active object list
OFREE	.long	0		;*Free object block
BAKLST	.long	0		;*Background list


;--------------------
; ram variables

	.bss	SCROLLX		,32	;X scroll value
	.bss	SCROLLY		,32	;Y scroll value
					;/ Must stay in order
	.bss	WORLDTLX	,32	;Left X screen coord (16:16)
	.bss	WORLDTLY	,32	;Top Y screen coord (16:16)
	.bss	WORLDTL		,32	;Top left world Y:X

	.bss	SCRNTL		,32	;TOP LEFT [Y,X] SCREEN (SCRN COORD.)
	.bss	SCRNLR		,32	;LOWER RIGHT [Y,X] SCREEN (SCRN COORD.)

	.bss	dpage		,16	;Display page; 0=Page0, -1=Page1
	.bss	dtype		,16	;Display type; 0=2D, 1=3D, -=Special
	.bss	dcode_p		,32	;!0=*Special code (^ must = neg)
	BSSX	DMAQCUR		,32	;Misc DMAQ position

	.bss	OBJSTR  ,NOBJ*OBSIZ	;Object structure mem

QSIZE	.set	(NOBJ+GNDI_H)*BQCELL
QMSIZE	.set	NOBJ*BQCELL
	.bss	dmaq0	     ,QSIZE	;Main DMA queue
	BSSX	DMAQ	    ,QMSIZE	;Misc DMA queue

	BSSX	gndstat		,16	;!0=Show ground
	BSSX	gndpos_t	,16*GND_H
	BSSX	gndx		,32

	.bss	DISPLAYON	,16	;!0=Do display processing
;	BSSX	QDMAFLG		,16	;!0=Misc DMAQ being updated

	BSSX	_3dstat		,16	;!0=Show polygons


;--------------------
; code start

	.text

********************************
* NO CODE BEFORE DMA INT!!! (Cache aligned)

********************************
* DMA interrupt
* B12=*End of DMA regs
* B13=DMAQ count-1 or Neg
* B14=*Next DMAQ fetch

 SUBR	dma_irq

	move	-*b14,-*b12,L
	move	-*b14,-*b12,L
	move	-*b14,-*b12,L
	move	-*b14,-*b12,L
	or	b8,b12			;Add DMAREGS offset for 20Mb IROM mod
	move	-*b14,-*b12,L
	move	-*b14,-*b12,L		;DMA go!

	move	b9,b12			;Restore *DMAREGS
	subk	1,b13
	jrn	dmaint1			;Queue empty?
	reti

dmaint1
	setf	1,0,0			;>Disable dma interrupt
	move	b12,@INTENB+1		;Clr X1E
	clr	b13			;For safety!
	subk	1,b13			;-1
	reti


********************************
* Load DMA Q from obj list (3D type)
* A0=*Obj list
* A4=*DMAQ next free spot
* A13=Screen BR, A14=Screen TL
* B2=Y offset for top of page : XPad offset
* B4=World Y:X
* B5=OFLAGS offset
* B6=World center scrn X * 64K
* B7=Default scale
* B11=*DMACTRL

	.align

#lp	move	b5,a3
	add	a0,a3
	move	*a3+,a1			;Get OFLAGS

	btst	B_CHARGEN,a1		;Chargen obj type? Yes if !0
	jrnz	char_gen

	mmfm	a3,a12,a11,a9,a8	;OFST:CTRL, SAG, SIZEY:SIZEX, CNST:PAL
	move	*a0(OYVAL),a10,L	;Get Y INT:FRAC

	btst	B_3DQ,a1
	jrz	#chk3d

	move	b4,a6			;World TL Y:X
	subxy	a6,a10			;-world coord to get screen coord
	move	*a0(OXPOS),a2		;X
	move	*a0(ODATA_p),a3,L	;*gndpos_t
	move	*a3,a3			;Get X shift
	sub	a3,a2
	movx	a2,a10			;A10=Obj Y:X
	jruc	#noscl

#chk3d	btst	B_3D,a1
	jrnz	#3d

	move	*a0(OXPOS),a2		;X
	movx	a2,a10			;A10=Obj Y:X
	btst	B_SCRNREL,a1
	jrnz	#noscl			;Screen relative XY?
	move	b4,a6			;World TL Y:X
	subxy	a6,a10			;-world coord to get screen coord

#noscl	move	b7,a5			;A5=Y:X scale
					;A8=Const:PAL
					;A9=VSize:HSize
					;A10=Dest Y:X
					;A11=*SAG
					;A12=Offset:Ctrl

;Check for flipping, clipping, adjust offset, sag

				;>Calc top,bot,lft,rgt clips
	clr	a3		;A3=TL clip size
	move	a10,a2
	addxy	a9,a2		;BR Y:X
	subxy	a13,a2		;A2=BR clip size
	JRYGE	#10
	movy	a3,a2		;Clr bclip if y neg
#10	JRXGE	#20
	movx	a3,a2		;Clr rclip if x neg

#20	btst	7,a12			;dont clip bit if ZERO compressed
	jrz	#25

	move	a14,a6
	subxy	a10,a6		;tc : lc
	JRYLT	#21
	movy	a6,a3		;Top clip size

#21	JRXLT	#22
	movx	a6,a3		;Left clip size

#22	add	a3,a2		;TL clip+BR clip
	jrz	#chkvflip
	cmpxy	a2,a9		;Chk clipped size
	JRXLE	#nxt		;Totally clipped?
	JRYLE	#nxt
	jruc	#chkvflip

#25	move	a14,a6
	subxy	a10,a6		;tc : lc
	JRYLT	#30
	movy	a6,a3		;Top clip size
	movy	a14,a10		;Adjust start position to window edge

#30	JRXLT	#35
	movx	a6,a3		;Left clip size
	movx	a14,a10		;Adjust start position to window edge

#35	move	a2,b0		;Save
	add	a3,a2		;TL clip+BR clip
	jrz	#chkvflip

;do obj clipping

	movx	a9,a6		;Save HSize

	subxy	a2,a9		;Get clipped size
	JRXLE	#nxt		;Totally clipped?
	JRYLE	#nxt

	movk	8,a1
	cmpxy	a1,a9		;Obj now <=8 pixels wide? Skip so DMA won't
	jrxle	#nxt		; lockup if so; br=yes

	movx	a6,a9		;Restore hsize

	clr	a1
	cmpxy	a2,a1		;Is X clipped at all? No if X=0
	jrxz	#nofh
	movx	a3,a1		;Yes. A1=Left clip

	btst	B_FLIPH,a12
	jrz	#nofh

	subxy	a1,a10		;X-LClip

	move	b0,a1		;A1=RClip
	zext	a1
	subxy	a1,a10		;X-RClip

#nofh	btst	B_FLIPV,a12
	jrz	#nofv
	move	b0,a3		;Bot clip

#nofv	srl	16,a3		;A3=Top or bot clip
	jrz	#t0
	zext	a6
	mpyu	a6,a3		;T or B clip * total hsize

#t0	add	a1,a3		;Add left clip + tc*ths

	move	a12,a1
	sll	32-15,a1	;Get bits/pix in CRTL bits 12-14
	srl	32-15+12,a1
	jrnz	#not8
	movk	8,a1

#not8	mpys	a1,a3		;# of bits to skip
	add	a3,a11		;Add to SAG
	sll	16,a2
	addxy	a2,a12		;Add clip offset to offset

#chkvflip
	btst	B_FLIPV,a12
	jrz	#chkhflip

	movy	a9,a1			;VSize
	srl	16,a1
	subk	1,a1
	sll	16,a1
	addxy	a1,a10

#chkhflip
	btst	B_FLIPH,a12
	jrz	#nofh2

	movx	a9,a1			;HSize
	subk	1,a1
	zext	a1
	addxy	a1,a10

#nofh2
	move	b2,a1
	addxy	a1,a10			;Add the page y offset : XPad
	rl	16,a12			;Flip ctrl & offset

	mmtm	a4,a5,a8,a9,a10,a11,a12	;Save the DMA regs
	addk	1,b13			;Inc DMA queue cnt
	jrp	#nxt			;DMA irq active? Yes if +
#dodma
	dint
	setf	1,0,0			;Enable DMA irq
	movk	1,a1
	move	a1,@INTENB+1		;X1E
	setf	16,1,0

	move	*b11,b0			;DMA busy (will irq)? Yes if -
	jrn	#dmaok
	trap	1			;Cause DMA irq
#dmaok	eint

dma_objlst				;Entry point
#nxt
	move	*a0,a0,L		;Get next link
	jrnz	#lp			;More?
	rets

;A0 = *OBJ
;A1 = OFLAGS
;A4 = *DMAQ
;A8 = OCONST:OPAL
;A9 = OSIZEY:OSIZEX
;A10= OYVAL
;A11= OSAG
;A12= OFSET:OCTRL
;A13= SCRNLR
;A14= SCRNTL

#3d					;3D coord conversion
;
;calc X offset from center of screen
;
	move	*a0(OXVAL),a7,L
	move	b4,a2			; WorldY:X
	subxy	a2,a10			; OYPOS-WorldY:OYFRAC-WorldX
	move	b6,a2			; CenterX:0
	sub	a2,a7			; OXVAL-CenterX
	move	*a0(OXANI),a5,L
	add	a5,a7			; (OXVAL-CenterX)+OXANI
;
;calc final Z from actual + OMISC Z offset (for shadows,heads)
;
	move	*a0(OZPOS),a2
	move	*a0(OMISC),a3		; ZOFF
	add	a3,a2			; A2=ZOFF+OZPOS
	move	a2,a6			; A6=A2 for later Y calc
;
;calc screen X by multiplying X offset from center & final Z
;
;TEMP!!! begin
;	BSSX	pre_xval,32
;	BSSX	pst_xval,16
;	BSSX	dlt_xval,16
;	move	*a0(OID),a3
;	cmpi	TYPBALL-CLSENMY,a3
;	jrnz	#tmpx_1
;	move	a7,@pre_xval,L
;#tmpx_1
;	PRJX2Z	a7,a2,0
;	cmpi	TYPBALL-CLSENMY,a3
;	jrnz	#tmpx_2
;	move	a7,@pst_xval
;	move	@pre_xval+16,a3
;	sub	a7,a3
;	abs	a3
;	move	a3,@dlt_xval
;#tmpx_2
;TEMP!!! end; was just PRJ
	PRJX2Z	a7,a2,0

	addi	200,a7			;make X 0-based from left of screen
	sra	16,a5			;shift down int part of OXANI &
	sub	a5,a7			; take it back out of X
	movx	a7,a10			;put X away in DESTY:X
;
;calc screen Y
;
	subi	GZBASE,a6
	jrge	#zok
	clr	a6
#zok	move	a6,a2			; A2=A6 for later scale lookup

	move	a6,a3			;take 3/8 of A6
	sra	1,a6
	sra	3,a3
	sub	a3,a6

	addi	GND_Y,a6
	sll	16,a6
	addxy	a6,a10

	btst	B_NOSCALE,a1		;does obj want Z-based scaling?
	jrnz	#noscl			; yes if !0

	btst	B_SHAD,a1		;no. Is it a shadow-type obj?
	jrz	#notshad		; no if 0
	srl	1,a10			;yes. Lose X lsb
	move	@PCNT,a5		;make X even or odd to "shimmer"
	srl	1,a5			; the img
	addc	a10,a10
	jruc	#noscl
;
;check screen side clips & get Z-based scale if visible
;
#notshad
	move	a10,*a0(OSCALE),L

	cmpxy	a13,a10
	JRXGE	#nxt			;Left edge past rclip?

	move	a10,a3			;add (non-scaled!) OSIZEY:OSIZEX to
	addxy	a9,a3			; DESTY:X. Overkill if it gets smaller
	cmpxy	a14,a3			; but what if it gets bigger?!?
	JRXLT	#nxt			;Rgt edge past lclip?

	srl	4,a2			;clr low 4 bits of Z &
	sll	6,a2			; * scale table element size

	move	*a0(ODATA_p),a5,L	;get *scale_t
	add	a2,a5
	move	*a5,a5,L		;A5=SCALEY:X

	btst	B_FLIPH,a12
	jrz	#nofh2

	movx	a9,a1			;HSize
	subk	1,a1
	zext	a1
	addxy	a1,a10

	move	b2,a1
	addxy	a1,a10			;Add the page y offset : XPad
	rl	16,a12			;Flip ctrl & offset

	mmtm	a4,a5,a8,a9,a10,a11,a12	;Save the DMA regs
	addk	1,b13			;Inc DMA queue cnt
	jrp	#nxt			;DMA irq active? Yes if +
	jruc	#dodma


#********************
* Character generator for dma_objlst
*
* Enters with:
*  A0 *Obj list
*  A1 OFLAGS
*  A4 *DMAQ next free spot
* A13 Screen BR
* A14 Screen TL
*  B2 Y offset for top of page : XPad offset
*  B4 World Y:X
*  B5 OFLAGS offset
*  B6 World center scrn X * 64K
*  B7 Default scale
* B11 *DMACTRL
*
* Uses for DMA:
*   A7 SCALEY:SCALEX
*   A8 CNST:PAL
*   A9 SIZEY:SIZEX
*  A10 YPOS:XPOS
*  A11 SAG
*  A12 CTRL:OFST

	.align

	.ref	init_convert_img

 SUBR	char_gen

	move	*a0(ODATA_p),a1,L	;Get *plyrname
	move	b7,a7			;SCALEY:SCALEX
	move	*a0(OPAL),a8,L		;OCNST:OPAL
	move	*a0(OYPOS),a10		;OYPOS
	move	*a0(OMISC),a3		;OXPOS
	sll	16,a10
	movx	a3,a10			;-> OYPOS:OXPOS
	move	b2,a2
	addxy	a2,a10			;Add the page Y offset : XPad
	move	*a0(OCTRL),a5		;OCTRL
	andi	DMAWAL|DMACAL,a5	;-> CTRL
	movi	init_convert_img,a6,L
	movk	NAME_LETTERS,b0		;Init char cnt
#lp
	move	*a1+,a11		;Get next char *img
	jrz	#done			;Done if not a char (if 0)
	sll	5,a11
	add	a6,a11
	move	*a11,a11,L
	move	*a11,a9,L		;ISIZEY:ISIZEX
	move	*a11(ICTRL),a12		;ICTRL
	add	a5,a12
	sll	16,a12			;-> CTRL:OFST
	move	*a11(ISAG),a11,L	;ISAG
	mmtm	a4,a7,a8,a9,a10,a11,a12	;Save the DMA regs
	zext	a9			;Clr SIZEY
	addxy	a9,a10			;Add SIZEX for next XPOS
	dsj	b0,#lp
#done
	neg	b0			;Redo cnt to get # of chars
	addk	NAME_LETTERS,b0
	jrz	dma_objlst		;Done if there weren't any

	move	a3,a3			;Was OMISC 0? First time here if so
	jrnz	#strtdma
	subxy	a2,a10			;Remove the page Y offset : XPad
	zext	a10			;0->YPOS so XPOS is name pix width
	sra	1,a10

	move	*a0(OIMG),a1,L		;Get default *img
	move	*a0(OXPOS),a2		;OXPOS
	move	*a1(IANIOFFX),a3	;IANIOFFX
	add	a3,a2			;Calc obj ctr X coor
	sub	a10,a2			;Sub .5 of width for new starting X
	move	a2,*a0(OMISC)		;Put it away for next time

	move	a4,a1			;Step thru DMAq just built to add the
	move	b0,a5			; new X to the zero-based imgs
	addi	DMAHORIZ-DMAOFFST,a1	;Ptr to 1st (last q'd) img X
#fixx
	move	*a1,a3
	add	a2,a3
	move	a3,*a1
	addi	DMAWINDOW-DMAOFFST,a1
	dsj	a5,#fixx

#strtdma
	add	b0,b13			;Inc DMA queue cnt
	sub	b13,b0			;DMA irq active? Yes if <=
	jrle	dma_objlst

	dint
	setf	1,0,0			;Enable DMA irq
	movk	1,a1
	move	a1,@INTENB+1		;X1E
	setf	16,1,0

	move	*b11,b0			;DMA busy (will irq)? Yes if -
	jrn	#dmaok
	trap	1			;Cause DMA irq
#dmaok	eint

	jruc	dma_objlst		;Reenter obj loop


#*******************************
* Load DMA Q from obj list (2D type)
* A0=*Obj list
* A4=*DMAQ next free spot
* A13=Screen BR, A14=Screen TL
* B2=Y offset for top of page : XPad offset
* B4=World Y:X
* B5=OFLAGS offset
* B6=World center scrn X * 64K
* B11=*DMACTRL

dma_objlst2d
;	movi	>1000100,a5		;A5=Y:X scale
	jruc	#nxt

	.align

#lp
	move	*a0(OSCALE),a5,L
	move	b5,a3
	add	a0,a3
	move	*a3+,a1			;Get OFLAGS
	mmfm	a3,a12,a11,a9,a8

	move	*a0(OYVAL),a10,L	;Get int Y

	move	*a0(OXPOS),a2		;X
	movx	a2,a10			;A10=Obj Y:X
	btst	B_SCRNREL,a1
	jrnz	#noscl			;Screen relative XY?
	move	b4,a6			;A6=World TL Y:X
	subxy	a6,a10			;-world coord to get screen coord
#noscl
					;A8=Const:PAL
					;A9=VSize:HSize
					;A10=Dest Y:X
					;A11=*SAG
					;A12=Offset:Ctrl

;Check for flipping, clipping, adjust offset, sag

				;>Calc top,bot,lft,rgt clips
	clr	a3		;A3=TL clip size
	move	a10,a2
	addxy	a9,a2		;BR Y:X
	subxy	a13,a2		;A2=BR clip size
	JRYGE	#10
	movy	a3,a2		;Clr bclip if y neg
#10	JRXGE	#20
	movx	a3,a2		;Clr rclip if x neg

#20	move	a14,a7
	subxy	a10,a7		;wstart - pt -> a7 (tc : lc)
	JRYLT	#30
	movy	a7,a3		;Top clip size
	btst	7,a12
	jrnz	#30		;Zero compression on?
	movy	a14,a10		;Adjust start position to window edge

#30	JRXLT	#35
	movx	a7,a3		;Left clip size
	btst	7,a12
	jrnz	#35		;Zero compression on?
	movx	a14,a10		;Adjust start position to window edge

#35	move	a2,b0		;Save
	add	a3,a2		;TL clip+BR clip
	jrz	#noclip		;Zero clip?


	move	a9,a6		;Save VSize:HSize

	subxy	a2,a9		;Get clipped size
	JRXLE	#nxt		;Totally clipped?
	JRYLE	#nxt

	btst	7,a12
	jrz	#nozc		;Zero compression off?
	move	a6,a9		;Restore v:h size
	jruc	#noclip

#nozc
	clr	a1
	movx	a2,a1
	move	a1,a1
	jrz	#xclipzero
	movx	a9,a1
	subk	8,a1
	jrle	#nxt		;<=8 wide? Skip so DMA doesn't lockup

#xclipzero
	movx	a6,a9		;Restore hsize

	movx	a3,a1		;A1=Left clip


	btst	B_FLIPH,a12
	jrz	#nofh

	subxy	a1,a10		;Original X

	move	b0,a1		;LClip=RClip
	zext	a1
	subxy	a1,a10		;X-RClip


#nofh	btst	B_FLIPV,a12
	jrz	#nofv

	move	b0,a3		;Bot clip

#nofv	srl	16,a3		;A3=Top or bot clip
	jrz	#t0
	zext	a6
	mpyu	a6,a3		;T or B clip * total hsize


#t0
	add	a1,a3		;Add left clip + tc*ths
	move	a12,a1
	sll	32-15,a1	;Get bits 12-14
	srl	32-15+12,a1
	jrnz	#not8
	movk	8,a1
#not8	mpys	a1,a3		;# of bits to skip
	add	a3,a11		;Add to SAG
	sll	16,a2
	addxy	a2,a12		;Add clip offset to offset


#noclip
	btst	B_FLIPH,a12
	jrz	#300

	movx	a9,a1			;HSize
	subk	1,a1
	zext	a1
	addxy	a1,a10

#300	btst	B_FLIPV,a12
	jrz	#400

	movy	a9,a1			;VSize
	srl	16,a1
	subk	1,a1
	sll	16,a1
	addxy	a1,a10

#400
	move	b2,a1
	addxy	a1,a10			;Add the page y offset : XPad
	rl	16,a12			;Flip ctrl & offset
	mmtm	a4,a5,a8,a9,a10,a11,a12	;Save the dma regs
	addk	1,b13			;+1 Q cnt
	jrgt	#nxt			;DMA going?

	dint

	setf	1,0,0			;>Enable DMA int
	movk	1,a1
	move	a1,@INTENB+1		;X1E
	setf	16,1,0

	move	*b11,b0
	jrn	#dmaok			;DMA busy?

	move	b13,b13
	jrn	#dmaok			;DMA int done?

	trap	1			;Cause DMA int

#dmaok	eint
#nxt
	move	*a0,a0,L		;Get next link
	jrnz	#lp			;More?
	rets


#*******************************
* Load DMA Q from obj list (2D type)
* A0=*Obj list
* A4=*DMAQ next free spot
* A13=Screen BR, A14=Screen TL
* B2=Y offset for top of page : XPad offset
* B4=World Y:X
* B5=OFLAGS offset
* B6=World center scrn X * 64K
* B11=*DMACTRL

dma_objlst2dscl

;	movi	>1000100,a5		;A5=Y:X scale
	jruc	#nxt

	.align

#lp
	move	b5,a3
	add	a0,a3
	move	*a3+,a1			;Get OFLAGS
	mmfm	a3,a12,a11,a9,a8

	move	*a0(ODATA_p),a5,L	;Get scale value

	move	*a0(OYVAL),a10,L	;Get int Y

	move	*a0(OXPOS),a2		;X
	movx	a2,a10			;A10=Obj Y:X
	btst	B_SCRNREL,a1
	jrnz	#noscl			;Screen relative XY?
	move	b4,a6			;A6=World TL Y:X
	subxy	a6,a10			;-world coord to get screen coord
#noscl
					;A8=Const:PAL
					;A9=VSize:HSize
					;A10=Dest Y:X
					;A11=*SAG
					;A12=Offset:Ctrl

;Check for flipping, clipping, adjust offset, sag

				;>Calc top,bot,lft,rgt clips
	clr	a3		;A3=TL clip size
	move	a10,a2
	addxy	a9,a2		;BR Y:X
	subxy	a13,a2		;A2=BR clip size
	JRYGE	#10
	movy	a3,a2		;Clr bclip if y neg
#10	JRXGE	#20
	movx	a3,a2		;Clr rclip if x neg

#20	move	a14,a7
	subxy	a10,a7		;wstart - pt -> a7 (tc : lc)
	JRYLT	#30
	movy	a7,a3		;Top clip size
	movy	a14,a10		;Adjust start position to window edge

#30	JRXLT	#35
	movx	a7,a3		;Left clip size
	movx	a14,a10		;Adjust start position to window edge

#35	move	a2,b0		;Save
	add	a3,a2		;TL clip+BR clip
	jrz	#noclip		;Zero clip?


	movx	a9,a6		;HSize

	subxy	a2,a9		;Get clipped size
	JRXLE	#nxt		;Totally clipped?
	JRYLE	#nxt

	clr	a1
	movx	a2,a1
	move	a1,a1
	jrz	#xclipzero
	movx	a9,a1
	subk	8,a1
	jrle	#nxt		;<=8 wide? Skip so DMA doesn't lockup

#xclipzero
	movx	a6,a9		;Restore hsize

	movx	a3,a1		;A1=Left clip


	btst	B_FLIPH,a12
	jrz	#nofh

	subxy	a1,a10		;Original X

	move	b0,a1		;LClip=RClip
	zext	a1
	subxy	a1,a10		;X-RClip


#nofh	btst	B_FLIPV,a12
	jrz	#nofv

	move	b0,a3		;Bot clip

#nofv	srl	16,a3		;A3=Top or bot clip
	jrz	#t0
	zext	a6
	mpyu	a6,a3		;T or B clip * total hsize


#t0
	add	a1,a3		;Add left clip + tc*ths
	move	a12,a1
	sll	32-15,a1	;Get bits 12-14
	srl	32-15+12,a1
	jrnz	#not8
	movk	8,a1
#not8	mpys	a1,a3		;# of bits to skip
	add	a3,a11		;Add to SAG
	sll	16,a2
	addxy	a2,a12		;Add clip offset to offset


#noclip
	btst	B_FLIPH,a12
	jrz	#300

	movx	a9,a1			;HSize
	subk	1,a1
	zext	a1
	addxy	a1,a10

#300	btst	B_FLIPV,a12
	jrz	#400

	movy	a9,a1			;VSize
	srl	16,a1
	subk	1,a1
	sll	16,a1
	addxy	a1,a10

#400
	move	b2,a1
	addxy	a1,a10			;Add the page y offset : XPad
	rl	16,a12			;Flip ctrl & offset
	mmtm	a4,a5,a8,a9,a10,a11,a12	;Save the dma regs
	addk	1,b13			;+1 Q cnt
	jrgt	#nxt			;DMA going?

	dint

	setf	1,0,0			;>Enable DMA int
	movk	1,a1
	move	a1,@INTENB+1		;X1E
	setf	16,1,0

	move	*b11,b0
	jrn	#dmaok			;DMA busy?

	move	b13,b13
	jrn	#dmaok			;DMA int done?

	trap	1			;Cause DMA int

#dmaok	eint
#nxt
	move	*a0,a0,L		;Get next link
	jrnz	#lp			;More?
	rets


#*******************************
* Display object lists, called by DIRQ

DISPLAY
	movi	DMACTRL,b11		;B11=*DMACTRL

	movi	SCRNXP,b2		;B2=Page y offset : XPad offset
	movi	[253,0],b3
	move	@dpage,a1
	jrnz	#p1
	movi	[PAGE1YO,SCRNXP],b2
	movi	[509,256],b3
#p1
	movi	dmaq0+QSIZE,a4		;A4=*DMAQ for new data (Top)
	clr	b13			;Kill DMA
	move	b13,*b11
	move	b13,*b11
	movi	>80000,b8		;B8=*DMAREGS offset for 20Mb IROM mod
	movi	DMAREGS,b9		;B9=*DMAREGS to restore B12 with
	move	b9,b12			;B12=*DMAREGS
	subk	1,b13			;B13=Q count (-1)
	move	a4,b14			;B14=*DMAQ for next fetch (Top)

	movi	>30,b0
	move	b0,*b12(30h)		;DMACONF (Top/Bottom)
	move	b3,*b12,L		;DMAWINDOW

	move	@DISPLAYON,a0
	jrz	#doff			;Stop DMA of objects except for score?

	movi	WORLDTLX,b0		;>Scroll world
;	move	@SCROLLX,b6,L
;	move	@SCROLLY,b7,L
;	move	*b0,b3,L
;	add	b6,b3
;	move	b3,*b0+,L		;TLX
;	move	*b0,b4,L
;	add	b7,b4
;	move	b4,*b0+,L		;TLY

	move	*b0+,b3,L		;Quick version of ^
	move	*b0+,b4,L

	srl	16,b3
	movx	b3,b4			;B4=World top left Y:X
	move	b4,*b0,L		;WORLDTL

	movi	OFLAGS,b5		;B5=Obj data offset
	move	b4,b6
	addi	200,b6
	sll	16,b6			;B6=World center scrn X * 64K
	move	@SCRNLR,a13,L		;A13=Screen BR
	move	@SCRNTL,a14,L		;A14=Screen TL

	.if	DEBUG
	clr	b3			;trap1 cnt
	.endif

	move	@gndstat,a0
	jrz	#70			;Off?
	callr	gnd_dodma
#70
;	move	@_3dstat,a0
;	jrz	#80			;Off?
;	calla	_3d_build
;	callr	_3d_draw
;#80
	move	@dtype,a1
	jrnz	#3dtype

	movi	BAKLST,a0
	callr	dma_objlst2d

	.if	DEBUG
	move	@SLDEBUG,a0
	jrnn	#nol2d
	movi	31<<10+10<<5,a0		;Proc usage
	move	a0,@ERASELOC
#nol2d
	.endif

	movi	OBJLST,a0
	callr	dma_objlst2d
	jruc	#doff
#3dtype
	jrgt	#3dgame

	move	@dcode_p,a0,L
	jrnn	#3dgame			;No special code?
	call	a0
	jruc	#x
#3dgame
;	movi	BAKLST,a0
;	movi	>1000100,b7		;Original scale
;	callr	dma_objlst

	.if	DEBUG
	move	@SLDEBUG,a0
	jrnn	#nol3d
	movi	31<<10+10<<5,a0		;Proc usage
	move	a0,@ERASELOC
#nol3d
	.endif

	movi	OBJLST,a0
	movi	>1000100,b7		;Original scale
	callr	dma_objlst
#doff
;	move	@QDMAFLG,a2
;	jrnz	#noman			;Q being modified?
	move	@DMAQCUR,a2,L
	movi	DMAQ+QMSIZE,a1
	cmp	a1,a2
	jrhs	#noman			;Empty?
	move	a1,@DMAQCUR,L		;Reset top of queue

	move	b2,a5

#lp	move	-*a1,-*a4,L		;>Copy manual DMAQ to end of Q
	move	-*a1,-*a4,L
	move	-*a1,-*a4,L
	move	-*a1,a0,L
	addxy	a5,a0			;+Y
	move	a0,-*a4,L
	move	-*a1,-*a4,L
	move	-*a1,-*a4,L
	addk	1,b13
	cmp	a2,a1
	jrhi	#lp

	move	*b11,b0
	jrn	#noman			;DMA busy?

	move	b13,b13
	jrn	#noman			;DMA int done?

	setf	1,0,0			;>Enable DMA int
	movk	1,a1
	move	a1,@INTENB+1		;X1E
	setf	16,1,0

	trap	1			;Cause DMA int
#noman
;	movi	nulldma,a0		;>Put null DMA at end of Q
;	mmfm	a0,a7,a8,a9,a10,a11,a12
;	mmtm	a4,a7,a8,a9,a10,a11,a12

	move	@HALT,a0
	jrnz	#novel			;Skip vel update?

	movi	OBJLST,a0
	move	*a0,a0,L
	jrz	#novel

; Velocity add loop

#valp	move	a0,a1
	addk	OXVEL,a1

	mmfm	a1,a2,a3,a4,a5,a6,a7	;A7=XV, A6=YV, A5=ZV, A4=X, A3=Y, A2=Z

	add	a5,a2			;Add ZVEL to Z
	move	a2,-*a1,L
	add	a6,a3			;Add YVEL to Y (Uses hidden cycle!)
	move	a3,-*a1,L
	add	a7,a4			;Add XVEL to X ^
	move	a4,-*a1,L

	move	*a0,a0,L
	jrnz	#valp			;!End?

#novel
#x
;	.if	DEBUG
;	move	@SLDEBUG,a0
;	jrnn	#noline
;
;	movi	31<<10+31<<5,a0		;Proc usage
;	move	a0,@ERASELOC
;
;#dqwt	move	b13,b13
;	jrge	#dqwt			;DMA busy?
;
;	movi	20<<10,a0		;DMA usage
;	move	a0,@ERASELOC
;
;#noline
;	.endif

	rets


;Null dma data
;nulldma	.long	>80000000,IROM,0,>00010001,0,>1000100


#*******************************
* Fill DMAQ with ground data for each line
*  A4  *DMAQ next free spot
*  A13 SCRNLR
*  A14 SCRNTL
*  B2  Y offset for top of page : XPad offset
*  B4  World Y:X
*  B11 *DMACTRL
* Trashes A0-A3,A5-A12,B0
*  A4  *DMAQ next free spot

	.asg	8,COURT_BC		;Court img bit count

DMACRT	.equ	(((8|COURT_BC)<<12)|DMAWNZ)<<16

	.asg	0,BNKCRT		;Court img IROM bank (0,1,2)
	.asg	1,BNKOTD		;Outdoor court img IROM bank (0,1,2)

	.if 	1		;1 for locked court, 0 for new court
	.ref	COURT
	.ref	OUTDOOR
SAGCRT	.equ	  COURT-IROM+(GNDI_W/2-200)*COURT_BC+BNKCRT*>4000000
SAGOTD	.equ	OUTDOOR-IROM+(GNDI_W/2-200)*COURT_BC+BNKOTD*>4000000
	.else
	.ref	COURTNEW
	.ref	OUTDOOR
SAGCRT	.equ	COURTNEW-IROM+(GNDI_W/2-200)*COURT_BC+BNKCRT*>4000000
SAGOTD	.equ	 OUTDOOR-IROM+(GNDI_W/2-200)*COURT_BC+BNKOTD*>4000000
	.endif


 SUBRP	gnd_dodma

;Always build the X table

	move	@gndx,a2,L		;A2=16:16 mid-screen court X
	move	a2,a1			;A1=A2 for divide
	sll	DIVRES,a1		; shift up for DIVSLP frac
	movi	DIVSLP,a3		;A3=per-line ratio
	divs	a3,a1			;A1=per-line delta X

	movi	gndpos_t,a0		;A0=X table ptr
	movi	GND_H,a5		;A5=# of lines to calc X's for
#do_x_t	move	a2,a3			;Eliminate X frac & put in table
	sra	16,a3
	move	a3,*a0+
	add	a1,a2			;A2+=delta X
	dsjs	a5,#do_x_t

	cmpxy	a14,a13			;Screen closed?
	jryle	#exit
	jrxle	#exit

	movi	gndpos_t+40*16,a3	;A3=*1st court X
	movi	SAGCRT,a6		;A6=*1st line centered of court img
	move	@pup_court,a2		;Outdoor court?
	jrz	#crt			; br=no
	movi	SAGOTD,a6		;A6=*1st line centered of court img
#crt
	movi	GNDI_W*COURT_BC,a2	;K> A2=court img bit width
	movi	GNDI_H,a5		;A5=court img line count
	movi	[GNDI_Y,0],a10
	move	b4,a11
	movx	a10,a11
	subxy	a11,a10			;A10=screen Y:X for court top
	move	a10,a9			;Calc diff between court upper Y &
	subxy	a14,a9			; screen upper Y
	jryge	#tyval			;Court above screen top? No if >=

	sra	16,a9			;Pull down the line count
	add	a9,a5			;Adjust court line count
	jrle	#exit			;No lines visible if new count <=0
	move	a9,a7
	sll	4,a7			;Lines over * gndpos_t element size &
	sub	a7,a3			; add to X ptr (by subing a neg #)
	mpys	a2,a9			;Lines over * court img bit width &
	sub	a9,a6			; add to img ptr (by subing a neg #)
	movy	a14,a10			;Set new court Y
	
#tyval	move	a13,a9			;Calc diff between screen lower Y &
	subxy	a10,a9			; court upper Y
	jryle	#exit			;Court below screen bottom? Yes if >=
	srl	16,a9			;Pull down the line count (always +)
	cmp	a5,a9			;More court lines than visible?
	jrge	#byval
	move	a9,a5			;Adjust court count

#byval	move	b2,a11
	addxy	a11,a10			;A10=DMA DEST Y:X

;;	move	@crt_colors,a0,L
;;	calla	pal_getf
;;	move	a0,a8
	.ref	crt_pal
	move	@crt_pal,a8		;K> A8=DMA CONSTANT:PALETTE

	movi	>1000100,a7		;K> A7=DMA Y:X scale
	movi	[1,400],a9		;K> A9=DMA VSIZE:HSIZE
	movi	DMACRT,a12		;K> A12=DMA CONTROL:OFFSET
	movi	[1,0],a1		;K> A1=Y:X inc

	.align
#lp	move	*a3+,a11		;Get next line X
	sll	3,a11			;Make it 8-bit
	add	a6,a11			;A11=DMA SOURCE

	mmtm	a4,a7,a8,a9,a10,a11,a12	;Save the DMA regs
	addk	1,b13			;Inc DMA queue cnt
	jrp	#next			;DMA irq active? Yes if +

	dint
	setf	1,0,0			;Enable DMA irq
	movk	1,a0
	move	a0,@INTENB+1		;X1E
	setf	16,1,0

	move	*b11,b0			;DMA busy (will irq)? Yes if -
	jrn	#dmaok
	trap	1			;Cause DMA irq
#dmaok	eint

#next	add	a2,a6			;->next img line
	add	a1,a10			;->next Y
	dsjs	a5,#lp

#exit	rets


	.if	0
#*******************************
* Dump 3D data to DMA
* B2=Y offset for top of page : XPad offset
* B11=*DMACTRL
* B12=*End of DMA regs
* Trashes A0-A3,A5-A12,B0-B1


	.bss	linelsxy	,32
	.bss	linersxy	,32

D3XPTS	.equ	>140		;UHL *Xformed points array (Cnt, XYZ,XYZ..)

 SUBRP	_3d_draw	;B1 Free (B14)

	PUSH	a4,a13,a14
	PUSH	b3,b4,b5,b6,b7,b8,b9,b10,b13,b14


	setf	1,0,0			;>Disable DMA interrupt
	move	sp,@INTENB+1		;Clr X1E
	setf	16,1,0

	movi	[1,1],b13		;B13=Const 1:1

;	clr	b14			;DEBUG

	movi	>1000100,b5		;B5=1:1 scale
	movi	IROM,b9			;B9=*IROM
	movi	>800c<<16,b10		;B10=OFFSET:CONTROL

	movi	d3vis_p,a12		;A12=*3D object


;D3PTS	.equ	>120		;UHL *Points array (Cnt, XYZ,XYZ..)
;
;	PUSH	a0,a1			;DEBUG
;	movi	d3vis_p,a1
;	move	*a1,a0,L
;	jrz	#dx
;#debug	move	a1,a0
;	move	*a0,a1,L
;	jrnz	#debug
;	move	*a0(D3PTS),a1,L
;	jrz	$			;ERROR!!!
;#dx	PULL	a0,a1



	.align

#lpobj	move	*a12,a12,L
	jrz	#x			;End?
	move	a12,a14
	addi	D3XPTS,a14
	move	*a14+,a13,L		;A13=*Base of points_t
	move	*a14+,a14,L		;A14=*1st entry of face line_t

	move	*a13+,a0		;# pts
	jrz	#lpobj			;Not visable?


#facelp
	move	*a14+,a0
	move	a0,b6			;B6=Const:Pal for face
	sll	16,b6
	move	a14,a4
	movi	>7fff,a8		;>Find lowest/highest X Y

;DO BETTER
	move	a8,a9
	not	a9			;>8000
	move	a8,a10
	move 	a9,a11
	jruc	dd150

#lp2	add	a13,a1			;+Base
	move	*a1+,a2			;Get X
	cmp	a8,a2
	jrge	#xbig			;Bigger X?
	move	a2,a8			;New low
#xbig	cmp	a9,a2
	jrle	#xsml			;Smaller X?
	move	a2,a9			;New high
#xsml
	move	*a1,a1			;Get Y
	cmp	a10,a1
	jrge	#ybig			;Bigger Y?
	move	a1,a10			;New low
	move	a4,a5			;A5=*Left line line table
#ybig	cmp	a11,a1
	jrle	dd150
	move	a1,a11			;New high

dd150	move	*a4+,a1
	jrnn	#lp2			;Good offset?


	subk	16,a4			;A4=*Null end entry of line_t


	cmpi	200,a8
	jrge	#nextf			;Face off screen?
	cmpi	-200,a9
	jrle	#nextf			;Face off screen?


	move	a11,a0
	sub	a10,a11
	jreq	#nextf			;Height of 1?

	cmpi	254,a10
	jrge	#nextf			;Off screen bottom?
	cmpi	-400,a10
	jrle	#nextf			;Way off screen top?

	subi	253,a0
	jrle	dd300
	sub	a0,a11
dd300	addk	1,a11			;A11=Main loop cnt


	sll	16,a10			;A10=Dest Y:X

	move	a5,a6			;A6=*Rgt line line table
	subk	16,a6

	move	-*a5,a0			;Get offset
	add	a13,a0
	cmp	a14,a5
	jrhi	dd500			;!At start?
	move	a4,a5			;Put at end

dd500	move	*a6+,a1			;Get offset
	add	a13,a1
	cmp	a4,a6
	jrlo	dd550			;!Past end
	move	a14,a6			;Put at start
dd550
	move	*a0,a2,L
	move	*a1,a3,L
	move	a2,@linelsxy,L		;Needed???
	move	a3,@linersxy,L

	movk	1,b3			;B3=Y cntdn till end of left line
	movk	1,b4			;B4=Y cntdn till end of rgt line


	;A8 Free
	movi	[1,0],a8		;A8=Const 1:0

#linelp

	dsj	b3,dd750

dd700	move	-*a5,a0			;Get offset
	add	a13,a0
	cmp	a14,a5
	jrhi	dd720			;!At start?
	move	a4,a5			;Put at end
dd720
	move	*a0,a1,L
	move	@linelsxy,a2,L		;Start XY
	move	a1,@linelsxy,L
	subxy	a2,a1
	move	a1,a7
	jrn	#nextf			;Neg Y?
	srl	16,a1
	jrz	dd700			;Same Y?

	move	a1,b3			;New Y cnt
	sll	16,a7			;A7=Delta X
	divs	a1,a7			;Divide DeltaX into Y increments

	sll	16,a2			;A2=Left line X (16:16)


dd750	dsj	b4,dd850

dd800	move	*a6+,a0			;Get offset
	add	a13,a0
	cmp	a4,a6
	jrlo	dd820			;!Past end
	move	a14,a6			;Put at start
dd820
	move	*a0,a1,L
	move	@linersxy,a3,L		;Start XY
	move	a1,@linersxy,L
	subxy	a3,a1
	move	a1,a9
	jrn	#nextf			;Neg Y?
	srl	16,a1
	jrz	dd800			;Different Y?

dd840	move	a1,b4			;New Y cnt
	sll	16,a9			;A9=Delta X
	divs	a1,a9			;Divide DeltaX into Y increments

	sll	16,a3			;A3=Rgt line X (16:16)


dd850	add	a7,a2			;+Offset to left X
	add	a9,a3			;^ rgt X

	cmp	a3,a2
	jrgt	#nextf			;X flipped?

	move	a10,a10
	jrn	#nextl			;Off screen top?

	move	a2,a0
	sra	16,a0			;Int (0=Screen center)
	cmpi	200,a0
	jrge	#nextl			;L line to rgt of screen?
	addi	200,a0
	jrge	dd1000			;On screen?
	clr	a0
dd1000	movx	a0,a10			;X pos

	move	a3,a1			;>Calc HSize
	sra	16,a1			;Int
	addi	200,a1
	jrlt	#nextl			;R line to left of screen?
	sub	a0,a1			;Width

	add	a1,a0			;Rgt X
	subi	400,a0
	jrlt	dd1500			;On screen?
	subxy	a0,a1			;-difference

dd1500
;	move	a1,a0			;DEBUG chk VS:HS
;	srl	16,a0
;	jrnz	$
;	move	a1,a0
;	sll	16,a0
;	jrlt	$
	move	a1,b7
	addxy	b13,b7			;B7=VSIZE:HSIZE

	move	a10,b8
	addxy	b2,b8			;Add the page y offset

;	move	*b11,b0
;	jrnn	#dfree
;	addk	1,b14			;DEBUG

#dwait	move	*b11,b0
	jrn	#dwait			;DMA busy?


#dfree	mmtm	b12,b5,b6,b7,b8,b9,b10	;Set the dma regs
	addi	>c0,b12			;Fix DMAREGS


#nextl
	add	a8,a10			;Next Y
	dsj	a11,#linelp


#nextf	move	a4,a14
	addk	16,a14
	move	*a14,a0
	jrnn	#facelp			;Another set of lines?

	jruc	#lpobj


#x	PULL	b3,b4,b5,b6,b7,b8,b9,b10,b13,b14
	PULL	a4,a13,a14
	rets

	.endif


#*******************************
* Manual DMA
* A1=Constant color:Palette
* A2=Vsize:Hsize
* A3=Dest Y:X
* A4=SAG
* A5=Offset:Control
* Trashes A0,A14

 SUBR	QDMAN
;	movk	1,a0
;	move	a0,@QDMAFLG		;Q being modified

	move	@DMAQCUR,a14,L
	cmpi	DMAQ,a14
	jrls	#x			;Q full?

	movi	>1000100,a0		;No scale
	rl	16,a5			;Flip DMA & offset
	mmtm	a14,a0,a1,a2,a3,a4,a5
	rl	16,a5			;Flip DMA & offset
	move	a14,@DMAQCUR,L

#x
;	clr	a0
;	move	a0,@QDMAFLG
	rets


#*******************************
* Turn on the 2d with scaling display mode
* Trashes scratch

 SUBRP	display_2dsclmodeon

	movi	#drawcode,a0
	move	a0,@dcode_p,L
	movi	-1,a0
	move	a0,@dtype

	rets

#drawcode
	movi	BAKLST,a0
	callr	dma_objlst2d

	movi	OBJLST,a0
	jruc	dma_objlst2dscl


#*******************************
* Turn on the 2d, with scaling and stars, display mode
* Trashes scratch

	.asg	MEGBIT1,STARBUF
NSTARS	.equ	900
STARSZ	.equ	32*6+16

 SUBRP	display_2dsclstarmodeon

	movi	NSTARS,b0		;>Init star array
	movi	STARBUF,a1
	movi	-1,a0
#silp	move	a0,*a1,L		;X
	addi	STARSZ,a1
	dsj	b0,#silp

	movi	#drawcode,a0
	move	a0,@dcode_p,L
	movi	-1,a0
	move	a0,@dtype

	rets

********************************
* B2=Y offset for top of page : XPad offset
* Trashes A0-A3,A5-A12,B0-B3

CFRAC	.equ	2

	.bss	starcolor	,16

#drawcode
	PUSH	a13,a14
	PUSH	b4

	movk	3,a0
	callr	rnd
	move	@starcolor,a6
	add	a0,a6
	move	a6,@starcolor
	sll	32-3-6,a6
	srl	32-3,a6			;Remove fraction
	sll	5+CFRAC,a6


	movi	NSTARS,a5		;>Find a free star
	movi	STARBUF,a2
	movk	3,a3
#flp	move	*a2,a0,L		;X
	jrn	#found
	addi	STARSZ,a2
#fnxt	dsj	a5,#flp
	jruc	#nofree

#found	movi	[200,0],a0		;>Create star
	move	a0,*a2+,L		;X
	movi	[252,0],a0
	move	a0,*a2+,L		;Y

	clr	a0
	move	a0,*a2+,L		;XV
	movi	->3e000,a0
	move	a0,*a2+,L		;YV

	movi	>7ff,a0
	callr	rnd
	subi	>3ff,a0
	move	a0,*a2+,L		;XA
	movi	>3ff,a0
	callr	rnd
	addi	>7ff,a0
	move	a0,*a2+,L		;YA

	move	a6,*a2+			;Color type
	dsj	a3,#fnxt
#nofree

	movi	#star_p,a0		;>Update stars
	calla	pal_getf
	move	a0,@DMACMAP

	movi	512*8,b3
	lmo	b3,b0
	move	b0,@CONVDP
	clr	b4

	movi	1<<(32-5-CFRAC),a11
	movi	[400,0],a13		;A13=X max+1
	movi	[254,0],a14		;A14=Y max+1
	move	b2,a12
	movi	NSTARS,b0
	movi	STARBUF,a8
#lp
;	move	*a8+,a2,L		;X
;	move	*a8+,a3,L		;Y
;	move	*a8+,a5,L		;XV
;	move	*a8+,a6,L		;YV
;	move	*a8+,a9,L		;XA
;	move	*a8+,a10,L		;YA
	mmfm	a8,a2,a3,a5,a6,a9,a10	;YA,XA,YV,XV,Y,X
	move	*a8+,a1			;Color
	move	a10,a10
	jrn	#nxt

	add	a2,a5
	add	a3,a6
	add	a5,a9
	add	a6,a10
	cmp	a13,a10
	jrhs	#offscr			;X off screen?
	cmp	a14,a9
	jrlo	#plot			;Y on screen?
#offscr
	movi	-1,a0
	move	a0,*a8(-STARSZ),L
	jruc	#nxt
#plot
	move	a10,*a8(-STARSZ),L
	move	a9,*a8(-STARSZ+32),L
	move	a6,*a8(-STARSZ+32*2),L
	move	a5,*a8(-STARSZ+32*3),L

	move	a1,a0
	sll	32-5-CFRAC,a0
	add	a11,a0
	jrc	#maxc			;Overflow?
;	cmpi	32*4,a1
;	jrge	#offscr
	addk	1,a1
	move	a1,*a8(-16)
#maxc	srl	CFRAC,a1		;Remove fraction
	srl	16,a10
	movx	a10,a9
	addxy	a12,a9
	pixt	a1,*a9.XY
#nxt
	dsj	b0,#lp

	PULL	b4
	PULL	a13,a14

	movi	BAKLST,a0
	callr	dma_objlst2d

	movi	OBJLST,a0
	jruc	dma_objlst2dscl

#star_p
	.word	256
	COLORW	01,01,01, 02,02,02, 03,03,03, 04,04,04	;Grey
	COLORW	05,05,05, 06,06,06, 07,07,07, 08,08,08
	COLORW	09,09,09, 10,10,10, 11,11,11, 12,12,12
	COLORW	13,13,13, 14,14,14, 15,15,15, 16,16,16
	COLORW	17,17,17, 18,18,18, 19,19,19, 20,20,20
	COLORW	21,21,21, 22,22,22, 23,23,23, 24,24,24
	COLORW	25,25,25, 26,26,26, 27,27,27, 28,28,28
	COLORW	29,29,29, 30,30,30, 31,31,31, 31,31,31
	COLORW	01,01,00, 02,02,00, 03,03,00, 04,04,00	;Yellow
	COLORW	05,05,00, 06,06,00, 07,07,00, 08,08,00
	COLORW	09,09,00, 10,10,00, 11,11,00, 12,12,00
	COLORW	13,13,00, 14,14,00, 15,15,00, 16,16,00
	COLORW	17,17,00, 18,18,00, 19,19,00, 20,20,00
	COLORW	21,21,00, 22,22,00, 23,23,00, 24,24,00
	COLORW	25,25,00, 26,26,00, 27,27,00, 28,28,00
	COLORW	29,29,00, 30,30,00, 31,31,00, 31,31,00
	COLORW	01,00,00, 02,00,00, 03,00,00, 04,00,00	;Red
	COLORW	05,00,00, 06,00,00, 07,00,00, 08,00,00
	COLORW	09,00,00, 10,00,00, 11,00,00, 12,00,00
	COLORW	13,00,00, 14,00,00, 15,00,00, 16,00,00
	COLORW	17,00,00, 18,00,00, 19,00,00, 20,00,00
	COLORW	21,00,00, 22,00,00, 23,00,00, 24,00,00
	COLORW	25,00,00, 26,00,00, 27,00,00, 28,00,00
	COLORW	29,00,00, 30,00,00, 31,00,00, 31,00,00
	COLORW	00,01,00, 00,02,00, 00,03,00, 00,04,00	;Green
	COLORW	00,05,00, 00,06,00, 00,07,00, 00,08,00
	COLORW	00,09,00, 00,10,00, 00,11,00, 00,12,00
	COLORW	00,13,00, 00,14,00, 00,15,00, 00,16,00
	COLORW	00,17,00, 00,18,00, 00,19,00, 00,20,00
	COLORW	00,21,00, 00,22,00, 00,23,00, 00,24,00
	COLORW	00,25,00, 00,26,00, 00,27,00, 00,28,00
	COLORW	00,29,00, 00,30,00, 00,31,00, 00,31,00
	COLORW	00,00,01, 00,00,02, 00,00,03, 00,00,04	;Blue
	COLORW	00,00,05, 00,00,06, 00,00,07, 00,00,08
	COLORW	00,00,09, 00,00,10, 00,00,11, 00,00,12
	COLORW	00,00,13, 00,00,14, 00,00,15, 00,00,16
	COLORW	00,00,17, 00,00,18, 00,00,19, 00,00,20
	COLORW	00,00,21, 00,00,22, 00,00,23, 00,00,24
	COLORW	00,00,25, 00,00,26, 00,00,27, 00,00,28
	COLORW	00,00,29, 00,00,30, 00,00,31, 00,00,31
	COLORW	00,00,01, 00,00,02, 00,00,03, 00,00,04	;Lt blue
	COLORW	00,00,05, 00,00,06, 00,00,07, 00,00,08
	COLORW	00,00,09, 01,01,10, 02,02,11, 03,03,12
	COLORW	04,04,13, 05,05,14, 06,06,15, 07,07,16
	COLORW	08,08,17, 09,09,18, 10,10,19, 11,11,20
	COLORW	12,12,21, 14,14,22, 16,16,23, 18,18,24
	COLORW	20,20,25, 22,22,26, 24,24,27, 26,26,28
	COLORW	28,28,29, 30,30,30, 30,30,31, 31,31,31
	COLORW	01,00,01, 02,00,02, 03,00,03, 04,00,04	;Purple
	COLORW	05,00,05, 06,00,06, 07,00,07, 08,00,08
	COLORW	09,00,09, 10,00,10, 11,00,11, 12,00,12
	COLORW	13,00,13, 14,00,14, 15,00,15, 16,00,16
	COLORW	17,00,17, 18,00,18, 19,00,19, 20,00,20
	COLORW	21,00,21, 22,00,22, 23,00,23, 24,00,24
	COLORW	25,00,25, 26,00,26, 27,00,27, 28,00,28
	COLORW	29,00,29, 30,00,30, 31,00,31, 31,00,31
	COLORW	00,01,01, 00,02,02, 00,03,03, 00,04,04	;Cyan
	COLORW	00,05,05, 00,06,06, 00,07,07, 00,08,08
	COLORW	00,09,09, 00,10,10, 00,11,11, 00,12,12
	COLORW	00,13,13, 00,14,14, 00,15,15, 00,16,16
	COLORW	00,17,17, 00,18,18, 00,19,19, 00,20,20
	COLORW	00,21,21, 00,22,22, 00,23,23, 00,24,24
	COLORW	00,25,25, 00,26,26, 00,27,27, 00,28,28
	COLORW	00,29,29, 00,30,30, 00,31,31, 00,31,31


********************************
* Get random # with mask
* A0=Mask
* >A0=Rnd # (Pass CC)
* Trashes scratch

 SUBRP	rnd

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	and	a1,a0
	rets


********************************
* Zeros velocities for all objects on OBJLST

STOPOBJS
	clr	a0
	movi	OBJLST,a1
	jruc	so20

so10	move	a0,*a1(OXVEL),L
	move	a0,*a1(OYVEL),L
	move	a0,*a1(OZVEL),L
so20	move	*a1,a1,L
	jrnz	so10

	rets


********************************
* Sort object list in Z:Y priority
* Trashes A0-A7

	.align

 SUBR	obj_yzsort

	movi	OBJLST,a0
	movk	1,a1			;Lowest Z
	sll	31,a1			;Make >80000000
	jruc	yzlp

yz0	move	*a2(OZPOS),a6		;Get Z
	move	*a2(OYPOS),a7		;Get Y
	cmp	a1,a6
	jrgt	priok			;Next Z > Current Z?
	jrlt	priswap

	cmp	a5,a7
	jrge	priok			;Next Y > Current Y?

priswap	dint				;>Make current after next
	move	a2,*a4,L		;Point last to next
	move	*a2,*a0,L		;Point current to block after next
	move	a0,*a2,L		;Point next to current
	eint
	move	a2,a4
	jruc	yzlp			;Continue sort of current obj

priok	move	a0,a4			;A4=*Last obj
	move	a2,a0			;A0=*Current obj
	move	a6,a1			;A1=Current Z
	move	a7,a5			;A5=Current Y

yzlp	move	*a0,a2,L		;A2=*Next obj
	jrnz	yz0

	rets


**************************************************************************
* TEST IF OBJECT ON SCREEN
* A8=OBJECT
* RETURNS Z IF ON SCREEN

*ENTER HERE AND PROVIDE YOUR OWN SCREEN BOUNDRIES
SCRTSTG
	mmtm	sp,a1,a2,a3
	jruc	scrtst1

*NORMAL SCREEN BOUNDRIES
SCRTST
	mmtm	sp,a1,a2,a3
	move	@SCRNTL,a2,L		;Get screen top left
	move	@SCRNLR,a3,L		;Get screen lower rgt

scrtst1	move	*a8(OYPOS),a0
	move	*a8(OXPOS),a1
	sll	16,a0
	movx	a1,a0			;get top left of object
	move	@WORLDTL,a1,L
	subxy	a1,a0			;subtract out world base
	move	*a8(OSIZE),a1,L
	addxy	a0,a1			;get lower rt of object

	cmpxy	a3,a0			;is it lower than lower rt?
	JRYGE	scrtf_d			;lower
	JRXGE	scrtf_r			;to the right

	cmpxy	a2,a1
	JRYLE	scrtf_u			;above...
	JRXLE	scrtf_l			;to the left..

	mmfm	sp,a1,a2,a3
	clr	a0			;On screen Z
	rets
scrtf_l	movi	1,a0			;Pass NZ
	mmfm	sp,a1,a2,a3
	rets

scrtf_r	movi	2,a0
	mmfm	sp,a1,a2,a3
	rets

scrtf_u	movi	3,a0
	mmfm	sp,a1,a2,a3
	rets

scrtf_d	movi	4,a0
	mmfm	sp,a1,a2,a3
	rets


#*******************************
* Initialize display system
* Trashes scratch

 SUBR	display_init

	pushst
	dint
	movi	DIE+X2E,a0
	move	a0,@INTENB		;Display int on, DMA int off

	clr	a0
	move	a0,@DMACTRL		;>Init DMA
	move	a0,@DMACTRL
	move	a0,@CMAPSEL		;Clear color map select
	move	a0,@DMATEST
	move	a0,@DMACONF
	movi	[511,0],a1		;L/R (full width to fix glitch)
	move	a1,@DMAWINDOW,L
	movi	>30,a1
	move	a1,@DMACONF		;Top/Bottom
	movi	[509,0],a1
	move	a1,@DMAWINDOW,L
	movi	>1000100,a1
	move	a1,@DMASCALEX,L

	movi	-1,b13			;DMAQ cnt

	clr	a1			;>Clr video mem
	movi	(SCRNE-512*8*2)/64,b0
#clp	move	a0,*a1+,L
	move	a0,*a1+,L
	dsj	b0,#clp
					;>Set autoerase lines
	movi	510*512*8,a1		;Store to last 2 lines of bitmap
	movi	ERASECOL,a14		;Color pair
	movi	512*8*2/16,b0
#lp	move	a14,*a1+
	dsj	b0,#lp


	movi	SCRNST,a1		;Screen top left [Y,X]
	move	a1,@SCRNTL,L
	movi	SCRNEND,a1		;Screen lower right [Y,X]
	move	a1,@SCRNLR,L

	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@WORLDTL,L
	move	a0,@SCROLLX,L
	move	a0,@SCROLLY,L

	move	a0,@BAKLST,L		;Null backgnd object list
	move	a0,@OBJLST,L		;Null object list

	move	a0,@dcode_p,L

	movi	DMAQ+QMSIZE,a1
	move	a1,@DMAQCUR,L		;Init misc DMA queue

	movi	OBJSTR,a1,L		;>Init free list
	move	a1,@OFREE,L
	movi	NOBJ,b0			;# of object blocks

#olp	move	a1,a14
	addi	OBSIZ,a1
	move	a1,*a14,L		;link em up
	dsj	b0,#olp

	move	a0,*a14,L		;Null end

	popst

	rets


********************************
* Get a free object block
* Trashes scratch
* >A0=*Object or 0 (Z)

GETOBJ
	move	@OFREE,a0,L
	jrz	nonelft			;None free?

	move	*a0,a1,L
	move	a1,@OFREE,L		;Unlink
	clr	a1
	move	a1,*a0(OPLINK),L
	move	a1,*a0(ODATA_p),L
getox
	move	a0,a0
	rets

nonelft
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	3,0
	.endif
	jruc	getox


********************************
* Add object to free list
* Can trash A0-A1 (currently doesn't)

FREEOBJ
	move	@OFREE,*a0+,L
	subk	32,a0
	move	a0,@OFREE,L
	rets


#*******************************
* Unlink an object from object list
* A0=*Obj
* Trashes scratch

; SUBR	obj_unlink
;
;	movi	OBJLST,a14
;
;#lp	move	a14,a1		;A1=*Prev
;	move	*a14,a14,L	;A14=*Next
;	jrz	#err
;	cmp	a14,a0
;	jrne	#lp
;
;	move	*a0,*a1,L	;Unlink from obj list
;	rets
;
;#err
;	.if	DEBUG
;	LOCKUP
;	eint
;	.endif
;	rets


********************************
* Insert an object block into an object list
* List is sorted by increasing z and increasing y within constant z


#*******************************
* Insert background object
* A0=*Obj
* Trashes scratch

INSBOBJ
	movi	BAKLST,a14
	jruc	#strt

********************************
* Insert foreground object
* A0=*Obj
* Trashes scratch

INSOBJ

	movi	OBJLST,a14

#strt	PUSH	a2,a3,a4

	move	*a0(OZPOS),a1
	move	*a0(OYPOS),a4
#lp
	move	a14,a2			;A2=*prev
	move	*a14,a14,L		;A14=*next
	jrz	#x
	move	*a14(OZPOS),a3
	cmp	a3,a1
	jrgt	#lp
	jrlt	#x

	move	*a14(OYPOS),a3		;Test y position
	cmp	a3,a4
	jrgt	#lp


#x	move	a14,*a0,L		;Put *next in new block
	move	a0,*a2,L		;Put *new in prev block

	PULL	a2,a3,a4
	rets


#*******************************
* Delete background object
* A0=*Obj

DELBOBJ

	movi	BAKLST,a14
	jruc	#lp


********************************
* Delete foreground object
* A8=*Obj

DELOBJA8

	move	a8,a0

********************************
* Delete foreground object
* A0=*Obj
* Trashes scratch

DELOBJ
	movi	OBJLST,a14

#lp	move	a14,a1		;A1=*Prev
	move	*a14,a14,L	;A14=*Next
	jrz	delerr
	cmp	a14,a0
	jrne	#lp

	move	*a0,*a1,L	;Unlink from obj list

	clr	a1
	move	a1,*a0(OXPOS)	;Indicates not in use for collisions

	move	@OFREE,*a0+,L	;Add to free list
	subk	32,a0
	move	a0,@OFREE,L

#x	rets

delerr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	1,0
	.endif
	jruc	#x



********************************
* FRANIM list an object, delete it and DIE
* A8=*Obj
* A9=*FRANIM list

FRQDELDIE

	JSRP	FRANIMQ

#*******************************
* Delete foreground object and DIE
* A8=*Obj

DELOBJDIE

	movi	OBJLST,a14

#lp	move	a14,a1		;A1=*Prev
	move	*a14,a14,L	;A14=*Next
	jrz	doderr
	cmp	a14,a8
	jrne	#lp

	move	*a8,*a1,L	;Unlink from obj list

	clr	a1
	move	a1,*a8(OXPOS)	;Indicates not in use for collisions

	move	@OFREE,*a8+,L	;Add to free list
	subk	32,a8
	move	a8,@OFREE,L

#x	jauc	SUCIDE

doderr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	1,0
	.endif
	jruc	#x



#*******************************
* Delete one class from the obj list
* A0=OID
* Trashes scratch

obj_del1c

	clr	a1

********************************
* Delete a class from the obj list
* A0=OID
* A1=!Mask (Bits to remove)
* Trashes scratch

obj_delc
	move	a2,b0
	move	a3,b1

	movi	OBJLST,a14
	sext	a0
	andn	a1,a0		;Form match

#lp	move	a14,a3		;A3=*Prev
	move	*a14,a14,L	;A14=*Next
	jrz	#x

#cmp	move	*a14(OID),a2

	cmpi	TRANS_OBJ_ID,a2	;transition effect obj. ?
	jreq	#lp		;br=yes

	andn	a1,a2		;Mask
	cmp	a0,a2
	jrne	#lp

	move	*a14,*a3,L	;Unlink from obj list

	move	@OFREE,*a14+,L	;Add to free list
	subk	32,a14
	move	a14,@OFREE,L
	move	*a3,a14,L
	jrnz	#cmp

#x
	move	b1,a3
	move	b0,a2
	rets



**********************************************
* Delete the TRANSITION objs from the obj list
* A0=OID
* Trashes scratch

del_transition_objs
	move	a2,b0
	move	a3,b1
	movi	OBJLST,a14
;	sext	a0
#dto_1	move	a14,a3		;A3=*Prev
	move	*a14,a14,L	;A14=*Next
	jrz	#x1
#cmp1	move	*a14(OID),a2
	cmp	a0,a2
	jrne	#dto_1
	move	*a14,*a3,L	;Unlink from obj list
	move	@OFREE,*a14+,L	;Add to free list
	subk	32,a14
	move	a14,@OFREE,L
	move	*a3,a14,L
	jrnz	#cmp1
#x1	move	b1,a3
	move	b0,a2
	rets



#*******************************
* Check objlst for an object with a certain OID
* A0=OID
* A1=!Mask (Bits to remove)
* >A0=*Obj or 0 (Z)
* Trashes scratch

EXISTOBJ
	move	a2,b0

	movi	OBJLST,a14
	sext	a0
	andn	a1,a0		;Form match
#lp
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a2
	andn	a1,a2		;Mask
	cmp	a0,a2
	jrne	#lp

#x	move	b0,a2
	move	a14,a0
	rets


#*******************************
* Check if object on free list
* A0=*Obj
* >A0=*Obj or 0 (Z)
* Trashes scratch

;ISFREE
;	movi	OFREE,a1
;	jruc	#lp


********************************
* Check if object on OBJLST
* A0=*Obj
* >A0=*Obj or 0 (Z)
* Trashes scratch

ISOBJ
	movi	OBJLST,a1

#lp	move	*a1,a1,L
	jrz	#x		;End?
	cmp	a0,a1
	jrne	#lp		;No match?

	move	a0,a0		;Clr Z
	rets

#x	clr	a0		;Set Z
	rets


********************************
* Add world coordinates to an object
* A0=*Obj
* Trashes scratch, !A0

 SUBR	obj_addworldxy

	move	@WORLDTLX,a14,L
	move	*a0(OXVAL),a1,L
	add	a14,a1
	move	a1,*a0(OXVAL),L

	move	@WORLDTLY,a14,L
	move	*a0(OYVAL),a1,L
	add	a14,a1
	move	a1,*a0(OYVAL),L

	rets


**************************************************************************
*									 *
* ADJNEWTL - ADJUST AN OBJECT TO A NEW SET OF X,Y WORLD COORDINATES	 *
*	   BEFORE THEY ARE STORED(TAKE EFFECT).				 *
* NOTE: CURRENT OBJECT COORDS. MUST BE ABSOLUTE WORLD.			 *
* A0 = PTR TO OBJECT							 *
* A4 = NEW WTLX, 32 BITS						 *
* A5 = NEW WTLY, 32 BITS						 *

ADJNEWTL
	PUSH	a1,a2
	CALLR	GSCRNREL		;SCREEN RELATIVE PLEASE
	ADD	A4,A1
	ADD	A5,A2			;ADJUST
	MOVE	A1,*A0(OXVAL),L
	MOVE	A2,*A0(OYVAL),L		;STORE
	PULL	a1,a2
	RETS


**************************************************************************
*									 *
* GSCRNREL - GET THE SCREEN RELATIVE X,Y COORDINATES OF AN OBJECT	 *
*	   IT IS ASSUMED THATE THE CURRENT X,Y COORDINATES ARE		 *
*	   WORLD ABSOLUTE.						 *
* A0 = PTR TO THE OBJECT BLOCK						 *
* RETURNS								 *
* A1 = X SCREEN RELATIVE, 32 BITS					 *
* A2 = Y SCREEN RELATIVE, 32 BITS					 *

GSCRNREL
	PUSH	a5
	MOVE	@WORLDTLX,A5,L
	MOVE	*A0(OXVAL),A1,L
	SUB	A5,A1
	MOVE	@WORLDTLY,A5,L
	MOVE	*A0(OYVAL),A2,L
	SUB	A5,A2
	PULL	a5
	RETS


**************************************************************************
*									 *
* SCRNRELV - MAKE THE X & Y VELOCITIES OF AN OBJECT RELATIVE TO THE	 *
*	   SCREEN. IN OTHER WORDS, ADJUST THEM SO THAT THE CURRENT	 *
*	   SCROLL RATE DOESN'T AFFECT THEM. 				 *
* A0 = PTR TO OBJECT							 *
*									 *
**************************************************************************

SCRNRELV
	PUSH	a1,a5
	MOVE	@SCROLLX,A5,L
	MOVE	*A0(OXVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OXVEL),L
	MOVE	@SCROLLY,A5,L
	MOVE	*A0(OYVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OYVEL),L
	PULL	a1,a5
	RETS


********************************
* Adjust current object image with respect to it's anipt and flip flags
* A0=*Object
* A2=New YVAL
* A3=New XVAL
* A4=New FLAGS (Only DMA bits)
* Trashes A1,A14,B0-B1
* >A2=Adjusted YVAL
* >A3=Adjusted XVAL

GANISAG
	PUSH	a4,a6,a7

	PUSH	a2
	move	*a0(OIMG),a1,L
	move	*a1,a2,L		;ISIZE
	move	a2,*a0(OSIZE),L
	callr	GANIOF
	PULL	a2

	sub	a6,a3
	sub	a7,a2			;adjust upper left corner
	move	a3,*a0(OXVAL),L
	move	a2,*a0(OYVAL),L

	move	*a1(ICTRL),a1		;Get DMA flags
	andi	>803f,a4		;Kill mode bits
	or	a1,a4
	move	a4,*a0(OCTRL),L		;&OFFSET

	PULL	a4,a6,a7
	rets


********************************
* Begin an object
* A0=XVAL, A1=YVAL, A2=*IMG, A3=ZPOS, A4=FLAGS, A5=OID, A6=XVEL, A7=YVEL
* >A8=*Obj
* Trashes scratch

BEGINOBJ
	move	@WORLDTLX,a8,L		;Adjust for world coord
	add	a8,a0
	btst	B_3D,a4
	jrnz	BEGINOBJ2		;No Y add for 3D?
	move	@WORLDTLY,a8,L
	add	a8,a1

BEGINOBJ2
	PUSH	a2,a3,a4,a6,a7,a9,a10
	move	a0,a9			;X
	move	a1,a10			;Y

	move	*a2(ICMAP),a0,L		;Get *palette
	.if	DEBUG
	jrnn	bopalerr		;No pallette?
	.endif
	calla	pal_getf

bo20	move	@OFREE,a8,L		;Pointer to next available obj block
	jrz	begobjerr		;No objs?
	move	*a8,a1,L
	move	a1,@OFREE,L		;Adjust pointer to free list

	move	a0,*a8(OPAL),L		;Set pallette & constant
	clr	a0
	move	a0,*a8(ODATA_p),L	;Clr stuff
	move	a0,*a8(OXANI),L
	move	a0,*a8(OZVEL),L
	move	a0,*a8(OMISC)

;oscale
	movi	01000100H,a0
	move	a0,*a8(OSCALE),L

	move	a3,*a8(OZPOS)
	move	a5,*a8(OID)
	move	a6,*a8(OXVEL),L
	move	a7,*a8(OYVEL),L

	move	a2,a1			;*Img
	move	*a1,a2,L		;ISIZE
	callr	GANIOF			;Adjust animation offset
	move	*a1(ISAG),a3,L		;Get top left sag

	sub	a6,a9			;- x anioff
	sub	a7,a10			;- y anioff
	move	a9,*a8(OXVAL),L
	move	a10,*a8(OYVAL),L

	move	a1,*a8(OIMG),L
	move	a2,*a8(OSIZE),L
	move	a3,*a8(OSAG),L
	move	a4,*a8(OFLAGS)
	move	*a1(ICTRL),a0		;Get DMA flags
	andi	>803f,a4		;Kill mode bits
	or	a0,a4
	move	a4,*a8(OCTRL),L		;&OFSET

	PULL	a2,a3,a4,a6,a7,a9,a10

	move	a13,*a8(OPLINK),L
	move	a8,a0
	jruc	INSOBJ			;Insert object into list


	.if	DEBUG
bopalerr
	LOCKUP				;Object doesn't have pallette!
	eint
	clr	a0
	jruc	bo20
	.endif

begobjerr
	.if	DEBUG
	LOCKUP				;Out of objects!
	eint
	.else
	CALLERR	3,7
	.endif
	move	@OBJLST,a8,L		;Pass 1st obj on list
	PULL	a2,a3,a4,a6,a7,a9,a10
	rets



#*******************************
* Begin an object with specified palette
* A0=XVAL, A1=YVAL, A2=*IMG, A3=ZPOS, A4=FLAGS, A5=OID, A6=XVEL, A7=YVEL
* B0=*Palette
* >A8=*Obj
* Trashes scratch

BEGINOBJP
	move	@WORLDTLX,a8,L		;Adjust for world coord
	add	a8,a0
	btst	B_3D,a4
	jrnz	BEGINOBJP2		;No Y add for 3D?
	move	@WORLDTLY,a8,L
	add	a8,a1

BEGINOBJP2
	PUSH	a2,a3,a4,a6,a7,a9,a10
	move	a0,a9			;X
	move	a1,a10			;Y

	move	b0,a0			;Get *palette
	.if	DEBUG
	jrnn	#bopalerr		;No pallette?
	.endif
	calla	pal_getf

#bo20	move	@OFREE,a8,L		;Pointer to next available obj block
	jrz	begobjerr		;No objs?
	move	*a8,a1,L
	move	a1,@OFREE,L		;Adjust pointer to free list

	move	a0,*a8(OPAL),L		;Set pallette & constant
	clr	a0
	move	a0,*a8(ODATA_p),L	;Clr stuff
	move	a0,*a8(OXANI),L
	move	a0,*a8(OZVEL),L
	move	a0,*a8(OMISC)

;oscale
	movi	01000100H,a0
	move	a0,*a8(OSCALE),L

	move	a3,*a8(OZPOS)
	move	a5,*a8(OID)
	move	a6,*a8(OXVEL),L
	move	a7,*a8(OYVEL),L

	move	a2,a1			;*Img
	move	*a1,a2,L		;ISIZE
	callr	GANIOF			;Adjust animation offset
	move	*a1(ISAG),a3,L		;Get top left sag

	sub	a6,a9			;- x anioff
	sub	a7,a10			;- y anioff
	move	a9,*a8(OXVAL),L
	move	a10,*a8(OYVAL),L

	move	a1,*a8(OIMG),L
	move	a2,*a8(OSIZE),L
	move	a3,*a8(OSAG),L
	move	a4,*a8(OFLAGS)
	move	*a1(ICTRL),a0		;Get DMA flags
	andi	>803f,a4		;Kill mode bits
	or	a0,a4
	move	a4,*a8(OCTRL),L		;&OFSET

	PULL	a2,a3,a4,a6,a7,a9,a10

	move	a13,*a8(OPLINK),L
	move	a8,a0
	jruc	INSOBJ			;Insert object into list


	.if	DEBUG
#bopalerr
	LOCKUP				;Object doesn't have pallette!
	eint
	clr	a0
	jruc	#bo20
	.endif


#*******************************
* Set new image for an object
* A1=*Image hdr
* A4=New FLAGS
* A8=*Obj
* Trashes A1,A14

 SUBR	ANI

	PUSH	a0,a2,a3,a4,a5,a6,a7

	cmpi	ROM,a1
	jrlo	anierr

	move	a1,a3
	move	a4,a5
	move	*a8(OIMG),a1,L
	move	*a8(OCTRL),a4
	cmp	a1,a3
	jrne	#1			;Different img?

	sext	a5
	cmp	a4,a5
	jreq	#x			;All the same?

#1	move	*a8(OSIZE),a2,L
	callr	GANIOF			;Get old animation offset
	move	a3,a1			;New OIMG
	srl	6,a4
	sll	6,a4
	or	a5,a4			;Set new OCTRL
	move	a6,a0
	move	a7,a5
	move	*a1(ISAG),a3,L		;Get top left sag
	move	*a1,a2,L		;ISIZE
	callr	GANIOF			;Get new animation offset
	move	a1,*a8(OIMG),L
	sub	a6,a0			;Subtract new from old
	sub	a7,a5
	zext	a4			;Zero offset in A4

	move	a8,a6			;Get push address of octrl,osag,osize
	addi	OCTRL+>60,a6
	mmtm	a6,a2,a3,a4		;Save new data

	subi	OCTRL-OXVAL,a6
	move	*a6,a7,L		;New OXVAL
	add	a0,a7
	move	a7,*a6+,L
	move	*a6,a7,L		;New OYVAL
	add	a5,a7
	move	a7,*a6,L

#x	PULL	a0,a2,a3,a4,a5,a6,a7
	rets

anierr
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	2,7
	.endif
	jruc	#x


#*******************************
* Change an objects image (Doesn't check VFLIP)
* A0=*New image
* A1=New flip flags & const
* A8=*Obj
* Trashes scratch

 SUBRP	obj_aniq


	PUSH	a2,a3

	cmpi	ROM,a0
	jrlo	#anierr

	move	a0,a2
	move	a1,a3

	callr	anipt_getxy

	move	a2,*a8(OIMG),L
	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L

	setf	5,0,0
	move	*a2(ICTRL+7),*a8(OCTRL+7) ;Write 5 z comp bits
	setf	6,0,0
	move	a3,*a8(OCTRL)		;Write 6 low bits
	setf	16,1,0

	move	a0,a2
	move	a1,a3
	callr	anipt_getxy

	sub	a0,a2			;Subtract new from old
	sub	a1,a3

	move	a8,a0			;Get base address
	addi	OXVAL,a0
	move	*a0,a14,L		;New OXVAL
	add	a2,a14
	move	a14,*a0+,L
	move	*a0,a14,L		;New OYVAL
	add	a3,a14
	move	a14,*a0,L

#x	PULL	a2,a3
	rets

#anierr 
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	2,2
	.endif
	jruc	#x


#*******************************
* Get an objects anipt XY (Doesn't check VFLIP)
* A8=*Obj
* >A0=Scaled Ani X (16:16)
* >A1=Scaled Ani Y
* Trashes scratch

 SUBRP	anipt_getxy

	move	a2,b0

	move	*a8(OIMG),a2,L

	move	*a2(IANIOFFX),a0
	sll	16,a0
	move	*a2(IANIOFFY),a1
	sll	16,a1

	move	*a8(OCTRL),a14
	btst	B_FLIPH,a14
	jrz	#x			;No flip?

	move	*a2,a2			;ISIZEX
	subk	1,a2
	sll	16,a2			;*64K
	neg	a0
	add	a2,a0			;+size


#x	move	b0,a2
	rets



#*******************************
* Change an objects image (doesn't check flip flags)
* A0=*New image
* A1=New OCTRL
* A8=*Obj
* Trashes scratch

 SUBRP	obj_aniq_cnoff

	move	a2,b0

	move	a1,*a8(OCTRL)		;Write new ctrl

	move	*a8(OIMG),a14,L
	move	*a14(IANIOFFX),a2
	move	*a14(IANIOFFY),a14

	move	a0,*a8(OIMG),L
	move	*a0(0),*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

	move	*a0(IANIOFFY),a1
	move	*a0(IANIOFFX),a0

	sub	a0,a2			;Subtract new from old
	sub	a1,a14
	sll	16,a2
	sll	16,a14

	move	a8,a0			;Get base address
	addi	OXVAL,a0
	move	*a0,a1,L		;New OXVAL
	add	a2,a1
	move	a1,*a0+,L
	move	*a0,a1,L		;New OYVAL
	add	a14,a1
	move	a1,*a0,L

	move	b0,a2
	rets



#*******************************
* Change an scaled objects image (Doesn't check VFLIP)
* A0=*New image
* A1=New OCTRL (low 8 bits)
* A8=*Obj
* Trashes scratch, A2,A3

	.ref	anipt_getsclxy

 SUBRP	obj_aniq_scld


	cmpi	ROM,a0
	jrlo	#anierr

	move	a0,a2
	move	a1,a3

	calla	anipt_getsclxy

	movb	a3,*a8(OCTRL)

	move	a2,*a8(OIMG),L
	move	*a2(0),*a8(OSIZE),L
	move	*a2(ISAG),*a8(OSAG),L

	move	a0,a2
	move	a1,a3
	calla	anipt_getsclxy

	sub	a0,a2			;Subtract new from old
	sub	a1,a3

	move	a0,*a8(OXANI),L		;Save scaled anipt

	move	a8,a0			;Get base address
	addi	OXVAL,a0
	move	*a0,a14,L		;New OXVAL
	add	a2,a14
	move	a14,*a0+,L
	move	*a0,a14,L		;New OYVAL
	add	a3,a14
	move	a14,*a0,L

#x	rets


#anierr 
	.if	DEBUG
	LOCKUP
	eint
	.else
	CALLERR	2,0
	.endif
	jruc	#x



********************************
* Get the x and y positions of an objects animation point
* A8=*Object
* Trashes scratch
* >A2=Ani pt Y 16:16
* >A3=Ani pt X 16:16

GETANIXY
	PUSH	a4,a6,a7
	move	*a8(OIMG),a1,L
	move	*a8(OSIZE),a2,L
	move	*a8(OCTRL),a4
	callr	GANIOF
	move	*a8(OXVAL),a3,L
	move	*a8(OYVAL),a2,L
	add	a6,a3
	add	a7,a2
	PULL	a4,a6,a7
	rets


#********************************
* Get animation offset (Fast!)
* A1=*Image header, A2=H:W, A4=OCTRL
* Trashes A14
*Rets:
* A6=X ani offset * 64K
* A7=Y ani offset * 64K

GANIOF
	move	*a1(IANIOFF),a6,L
	cmpi	ROM,a1
	jrlo	#err

#h	clr	a7
	movy	a6,a7
	sll	16,a6		;Move to upper word

	btst	B_FLIPH,a4
	jrz	#v
	move	a2,a14
	subk	1,a14
	sll	16,a14		;Move W to upper word
	neg	a6
	add	a14,a6		;Sub Width-1

#v	btst	B_FLIPV,a4
	jrz	#x
	move	a2,a14
	neg	a7
	srl	16,a14
	subk	1,a14
	sll	16,a14
	add	a14,a7		;Sub Hgt-1

#x	rets

#err	clr	a6
	jruc	#h


#*******************************
* Scale screen out (JSRP)

	.asg	MEGBIT0,SCRNBUF
	.asg	MEGBIT1,PALBUF

	.bss	scrnscl		,16

 SUBR	scrn_scaleout

	movk	1,a0
	move	a0,@HALT

	move	@dtype,a0
	PUSHP	a0
	move	@gndstat,a0
	PUSHP	a0

	movi	>160,a0
	move	a0,@scrnscl

	movi	#initcode,a0
	move	a0,@dcode_p,L

	movi	-1,a0
	move	a0,@dtype
	clr	a0
	move	a0,@gndstat
	move	a0,@IRQSKYE

#lp	SLEEPK	1

	movi	scrnscl,a14
	move	*a14,a5
	move	a5,a0
	srl	3,a0
	add	a0,a5
	move	a5,*a14
	cmpi	>7000,a5
	jrlt	#lp

	clr	a0
	move	a0,@dcode_p,L

	PULLP	a0
	move	a0,@gndstat
	PULLP	a0
	move	a0,@dtype


	RETP

#initcode
	callr	scrn_copy
	movi	scrn_scale,a0
	move	a0,@dcode_p,L
	jump	a0


#*******************************
* Initialization for scrn_scalein (JSRP)

 SUBR	scrn_scaleininit

	dint
#lp	move	@VCOUNT,a0
	cmpi	EOSINT,a0
	jrlt	#lp
	move	@HSBLNK,a0	;Blank screen
	move	a0,@HEBLNK
	eint
	SLEEPK	2

	RETP

#*******************************
* Scale screen in (JSRP)

 SUBR	scrn_scalein

	PUSHP	a8

	move	@HALT,a0
	PUSHP	a0
	movk	1,a0
	move	a0,@HALT

	move	@dtype,a0
	PUSHP	a0
	move	@gndstat,a0
	PUSHP	a0
	move	@dcode_p,a0,L
	PUSHP	a0

	movi	>7000,a0
	move	a0,@scrnscl

	movi	#initcode,a0
	move	a0,@dcode_p,L
	movi	-1,a0
	move	a0,@dtype
	clr	a0
	move	a0,@gndstat


	.if	DEBUG
;	movi	>1a0,a0
;	move	a0,@scrnscl
;	SLEEP	TSEC*2
	.endif


#lp	SLEEPK	1

	movi	scrnscl,a14
	move	*a14,a5
	move	a5,a0
	srl	2,a0
	sub	a0,a5
	move	a5,*a14
	cmpi	>100,a5
	jrgt	#lp


	PULLP	a0
	move	a0,@dcode_p,L
	PULLP	a0
	move	a0,@gndstat
	PULLP	a0
	move	a0,@dtype

	PULLP	a0
	move	a0,@HALT


	PULLP	a8
	RETP


#initcode
	callr	scrn_copy
	movi	scrn_scaledison,a0
	move	a0,@dcode_p,L
	jruc	scrn_scale


#*******************************
* B2=Y offset for top of page : XPad offset
* Trashes A0-A3,A7

 SUBRP	scrn_copy

;
; THIS COULD BE A PROBLEM....
;
	move	b2,a0
	srl	16,a0
	xori	>100,a0			;Flip to the page being shown
	sll	12,a0			;*512*8
	addi	SCRNXP*8,a0		;A0=*Scrn mem
	PUSH	a0

	movi	SCRNBUF,a1
	movi	254,a3
	movi	(512-400)*8,a7
#cslp
	movi	400/16,a2
#cslp2
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	dsj	a2,#cslp2

	add	a7,a0
	add	a7,a1
	dsj	a3,#cslp

	move	@SYSCOPY,a0

	.if	WWFUNIT
	andni	PALENB,a0
	move	a0,@SYSCOPY
	.if	DEBUG
	andni	LEDON,a0
	ori	WROMINTCLR,a0
	.endif
	.else
	andni	100000b,a0
	move	a0,@SYSCOPY
	.if	DEBUG
	andni	1000000b,a0
	.endif
	.endif

	move	a0,@SYSCTRL

	PULL	a0
	movi	PALBUF,a1
	movi	254,a3
#cplp
	movi	400/16,a2
#cplp2
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	move	*a0+,*a1+,L
	dsj	a2,#cplp2

	add	a7,a0
	add	a7,a1
	dsj	a3,#cplp

	move	@SYSCOPY,a0

	.if	WWFUNIT
	ori	PALENB,a0
	move	a0,@SYSCOPY
	.if	DEBUG
	andni	LEDON,a0
	ori	WROMINTCLR,a0
	.endif
	.else
;	ori	100000b,a0
	move	a0,@SYSCOPY
	.if	DEBUG
	andni	1000000b,a0
	.endif
	.endif

	move	a0,@SYSCTRL

	rets


#*******************************
* Copy screen data (throw out 1 in 5 pixels)
* B2=Y offset for top of page : XPad offset

 SUBRP	scrn_scale140

	PUSH	a4,a14

	movi	>140,a5

	move	b2,a1
	srl	16,a1
	addi	25,a1
	sll	12,a1			;*512*8
	addi	SCRNXP*8+40*8,a1	;A1=*Scrn mem

	movi	DMACMAP,a6
	clr	a7			;Y line 8:8
#lp
	move	a7,a2
	srl	8,a2
	sll	12,a2			;*512*8
	move	a2,a3

	addi	SCRNBUF,a2
	addi	PALBUF,a3
	movi	400/2/5,b0		;Copy 1 line
#cslp
	move	*a3,*a6			;Set pal latch
	addk	16,a3
	move	*a2+,*a1+		;Copy 2 pixels

	move	*a3,*a6
	addk	16,a3
	move	*a2+,*a1+

	move	*a3,*a6
	addk	16,a3
	move	*a2+,*a1+

	move	*a3,*a6
	addk	16,a3
	move	*a2+,*a1+

	addk	16,a3
	addk	16,a2

	dsj	b0,#cslp

	addi	(512-320)*8,a1

	add	a5,a7
	cmpi	254<<8,a7
	jrlt	#lp


#x	PULL	a4,a14
	rets



#*******************************
* Copy screen data (throw out 1 in 3 pixels)
* B2=Y offset for top of page : XPad offset

 SUBRP	scrn_scale180

	PUSH	a4,a14

	movi	>180,a5

	move	b2,a1
	srl	16,a1
	addi	42,a1
	sll	12,a1			;*512*8
	addi	SCRNXP*8+68*8,a1	;A1=*Scrn mem

	movi	DMACMAP,a6
	clr	a7			;Y line 8:8
#lp
	move	a7,a2
	srl	8,a2
	sll	12,a2			;*512*8
	move	a2,a3

	addi	SCRNBUF,a2
	addi	PALBUF,a3
	movi	400/2/3,b0		;Copy 1 line
#cslp
	move	*a3,*a6			;Set pal latch
	addk	16,a3
	move	*a2+,*a1+		;Copy 2 pixels

	move	*a3,*a6
	addk	16,a3
	move	*a2+,*a1+

	addk	16,a3
	addk	16,a2

	dsj	b0,#cslp

	addi	(512-264)*8,a1

	add	a5,a7
	cmpi	254<<8,a7
	jrlt	#lp


#x	PULL	a4,a14
	rets


********************************

 SUBRP	scrn_scaledison

	movi	HEBLNKINIT,a0		;Display on
	move	a0,@HEBLNK
	movi	scrn_scale,a0
	move	a0,@dcode_p,L


#*******************************
* Copy screen data with variable down scaling
* B2=Y offset for top of page : XPad offset

 SUBRP	scrn_scale

	move	@scrnscl,a5
	cmpi	>168,a5
	jrlt	scrn_scale140
	cmpi	>190,a5
	jrlt	scrn_scale180

	PUSH	a4,a14

	move	b2,a9
	srl	16,a9
	movi	127<<8,a3
	divu	a5,a3
	sub	a3,a9
	addi	127,a9
	sll	12,a9			;*512*8

	addi	(SCRNXP+200)*8,a9	;A9=*Scrn mem
	movi	100<<8,a3
	divu	a5,a3
	sll	4,a3			;*16
	sub	a3,a9

	movi	DMACMAP,a6
	clr	a7			;Y line 8:8
	movi	200<<8,a10
#lp
	move	a7,a2
	srl	8,a2
	sll	12,a2			;*512*8
	move	a2,a3

	move	a9,a1
	addi	SCRNBUF,a2
	addi	PALBUF,a3
	clr	a8			;X 8:8
#cslp
	move	*a3,*a6			;Set pal latch
	move	*a2,*a1			;Copy 2 pixels
	addk	16,a1

	move	a8,a0
	add	a5,a8
	sra	8,a0
	move	a8,a14
	sra	8,a14
	sub	a0,a14

#nxtp
	addk	16,a3
	addk	16,a2
	subk	1,a14
	jrgt	#nxtp

	cmp	a10,a8
	jrlt	#cslp


	addi	512*8,a9		;Next line

	add	a5,a7
	cmpi	254<<8,a7
	jrlt	#lp


#x	PULL	a4,a14
	rets

#*******************************
* Object Z scaling math values
*
*  Scale base constants to derive everything else from
*
;Original set
;	.asg	>180,S_XBEG			;Begining scale values for
;	.asg	>180,S_YBEG			; ref plyr (6'8") @ crt tp
;
;	.asg	>100,S_XEND			;Ending scale values for
;	.asg	>100,S_YEND			; ref plyr (6'8") @ crt bt

	.asg	>188,S_XBEG			;Begining scale values for
	.asg	>180,S_YBEG			; ref plyr (6'8") @ crt tp

	.asg	>100,S_XEND			;Ending scale values for
	.asg	>f8,S_YEND			; ref plyr (6'8") @ crt bt

	.asg	1024,Sp_XRES			;Scale parameter resolutions
	.asg	1024,Sp_YRES			; (># = bigger image)
;
;  Court area element cnts
;
	.asg	0,TOP_PAD				;Pad @ Z bt
	.eval	(CZMIN-GZMIN)/16,            TOP_C	;Z bt to crt tp
	.eval	(CZMAX-GZMIN)/16-TOP_C,      CRT_C	;Crt tp to crt bt
	.eval	(GZMAX-GZMIN)/16-TOP_C-CRT_C,BOT_C	;Crt bt to Z bt
	.asg	8,BOT_PAD				;Pad @ Z tp
;
;  Scale-rate subregion element cnts
;  
;Original set
;	.eval	TOP_PAD+TOP_C,      TOPRGN_C
;	.eval	CRT_C*3/8,          RGN1_C
;	.eval	CRT_C*3/8,          RGN2_C
;	.eval	CRT_C-RGN2_C-RGN1_C,RGN3_C
;	.eval	BOT_PAD+BOT_C,      BOTRGN_C

	.eval	TOP_PAD+TOP_C,      TOPRGN_C
	.eval	CRT_C*3/8,          RGN1_C
	.eval	CRT_C*3/8,          RGN2_C
	.eval	CRT_C-RGN2_C-RGN1_C,RGN3_C
	.eval	BOT_PAD+BOT_C,      BOTRGN_C
;
;  Scale-rate subregion rate fractions
;
;Original set
;	.asg	1/8,TOPRGN_Fr
;	.asg	2/8,RGN1_Fr
;	.asg	5/8,RGN2_Fr
;	.asg	8/8,RGN3_Fr
;	.asg	0/8,BOTRGN_Fr

	.asg	1/8,TOPRGN_Fr
	.asg	3/8,RGN1_Fr
	.asg	5/8,RGN2_Fr
	.asg	8/8,RGN3_Fr
	.asg	0/8,BOTRGN_Fr
;
;  Scale math constants
;
Sk_XDRS	.equ	1024*256			;Scale dividend resolutions
Sk_YDRS	.equ	1024*256			; (do not change;see Sp_?RES)

Sk_XDIV	.equ	1024*Sk_XDRS			;Scale calc values
Sk_YDIV	.equ	1024*Sk_YDRS			; (do not change;see Sp_?RES)

Rk_XDIV	.equ	1024*1024			;Scale ratio calc values
Rk_YDIV	.equ	1024*1024			; (do not change;see Sp_?RES)
;
;  Scale math constants - calculated
;
	.asg	32,Fk				;Fraction multiplier

	.eval	    Fk*RGN1_C*RGN1_Fr,FrC
	.eval	FrC+Fk*RGN2_C*RGN2_Fr,FrC
	.eval	FrC+Fk*RGN3_C*RGN3_Fr,FrC

	.eval	Fk*Sk_XDRS/S_XBEG,Sk_Xb
	.eval	Fk*Sk_YDRS/S_YBEG,Sk_Yb
	.eval	Fk*Sk_XDRS/S_XEND,Sk_Xe
	.eval	Fk*Sk_YDRS/S_YEND,Sk_Ye

;--------------------
; Scaler-table macro
;
SCLT	.macro	sxb,syb,sxe,sye

	.eval	:sxb:*Sp_XRES,X
	.eval	:syb:*Sp_YRES,Y

	.eval	(:sxe:-:sxb:)*Fk*Sp_XRES/FrC,Xr
	.eval	(:sye:-:syb:)*Fk*Sp_YRES/FrC,Yr

	.eval	X-TOPRGN_C*Xr*TOPRGN_Fr,X	;Pull back so initial # is
	.eval	Y-TOPRGN_C*Yr*TOPRGN_Fr,Y	; still for top of court

	.loop	TOPRGN_C
	.word	Sk_XDIV/(X/Fk),           Sk_YDIV/(Y/Fk)
	.word	Rk_XDIV/(Sk_XDIV/(X/Fk)), Rk_YDIV/(Sk_YDIV/(Y/Fk))
	.eval	X+Xr*TOPRGN_Fr,X
	.eval	Y+Yr*TOPRGN_Fr,Y
	.endloop

	.loop	RGN1_C
	.word	Sk_XDIV/(X/Fk),           Sk_YDIV/(Y/Fk)
	.word	Rk_XDIV/(Sk_XDIV/(X/Fk)), Rk_YDIV/(Sk_YDIV/(Y/Fk))
	.eval	X+Xr*RGN1_Fr,X
	.eval	Y+Yr*RGN1_Fr,Y
	.endloop

	.loop	RGN2_C
	.word	Sk_XDIV/(X/Fk),           Sk_YDIV/(Y/Fk)
	.word	Rk_XDIV/(Sk_XDIV/(X/Fk)), Rk_YDIV/(Sk_YDIV/(Y/Fk))
	.eval	X+Xr*RGN2_Fr,X
	.eval	Y+Yr*RGN2_Fr,Y
	.endloop

	.loop	RGN3_C
	.word	Sk_XDIV/(X/Fk),           Sk_YDIV/(Y/Fk)
	.word	Rk_XDIV/(Sk_XDIV/(X/Fk)), Rk_YDIV/(Sk_YDIV/(Y/Fk))
	.eval	X+Xr*RGN3_Fr,X
	.eval	Y+Yr*RGN3_Fr,Y
	.endloop

	.loop	BOTRGN_C
	.word	Sk_XDIV/(X/Fk),           Sk_YDIV/(Y/Fk)
	.word	Rk_XDIV/(Sk_XDIV/(X/Fk)), Rk_YDIV/(Sk_YDIV/(Y/Fk))
	.eval	X+Xr*BOTRGN_Fr,X
	.eval	Y+Yr*BOTRGN_Fr,Y
	.endloop

	.endm

;--------------------
; Object Z scaling tables

;scalehead_t	SCLT Sk_Xb*625/800,Sk_Yb*625/800,Sk_Xe*625/800,Sk_Ye*625/800
scalehead_t	SCLT Sk_Xb*580/800,Sk_Yb*580/800,Sk_Xe*580/800,Sk_Ye*580/800
scalebighead_t	SCLT Sk_Xb*840/800,Sk_Yb*840/800,Sk_Xe*840/800,Sk_Ye*840/800
scalehugehead_t	SCLT Sk_Xb*1100/800,Sk_Yb*1100/800,Sk_Xe*1100/800,Sk_Ye*1100/800

;Original set
;	.asg	88/100,KT
;	.asg	95/100,Kt
;	.asg	105/100,Kn
;	.asg	115/100,Kf
;	.asg	122/100,KF

;Mod 1 - larger than original set
;	.asg	100/100,KT
;	.asg	106/100,Kt
;	.asg	116/100,Kn
;	.asg	125/100,Kf
	.asg	132/100,KF

;Mod 2 - a little less large than mod 1
;	.asg	97/100,KT
;	.asg	102/100,Kt
;	.asg	112/100,Kn
;	.asg	124/100,Kf
;	.asg	131/100,KF

;Mod 3 - a bump from 2
	.asg	97/100,KT
	.asg	102/100,Kt
	.asg	110/100,Kn
	.asg	118/100,Kf
	.asg	124/100,KF

scale_t				;Start of large-image scale tables

scale57_t	SCLT Sk_Xb*Kn*670/800,Sk_Yb*670/800,Sk_Xe*Kn*670/800,Sk_Ye*670/800
scale57et_t	SCLT Sk_Xb*KT*670/800,Sk_Yb*670/800,Sk_Xe*KT*670/800,Sk_Ye*670/800
scale57t_t	SCLT Sk_Xb*Kt*670/800,Sk_Yb*670/800,Sk_Xe*Kt*670/800,Sk_Ye*670/800
scale57f_t	SCLT Sk_Xb*Kf*670/800,Sk_Yb*670/800,Sk_Xe*Kf*670/800,Sk_Ye*670/800
scale57ef_t	SCLT Sk_Xb*KF*670/800,Sk_Yb*670/800,Sk_Xe*KF*670/800,Sk_Ye*670/800

scale58_t	SCLT Sk_Xb*Kn*680/800,Sk_Yb*680/800,Sk_Xe*Kn*680/800,Sk_Ye*680/800
scale58et_t	SCLT Sk_Xb*KT*680/800,Sk_Yb*680/800,Sk_Xe*KT*680/800,Sk_Ye*680/800
scale58t_t	SCLT Sk_Xb*Kt*680/800,Sk_Yb*680/800,Sk_Xe*Kt*680/800,Sk_Ye*680/800
scale58f_t	SCLT Sk_Xb*Kf*680/800,Sk_Yb*680/800,Sk_Xe*Kf*680/800,Sk_Ye*680/800
scale58ef_t	SCLT Sk_Xb*KF*680/800,Sk_Yb*680/800,Sk_Xe*KF*680/800,Sk_Ye*680/800

scale59_t	SCLT Sk_Xb*Kn*690/800,Sk_Yb*690/800,Sk_Xe*Kn*690/800,Sk_Ye*690/800
scale59et_t	SCLT Sk_Xb*KT*690/800,Sk_Yb*690/800,Sk_Xe*KT*690/800,Sk_Ye*690/800
scale59t_t	SCLT Sk_Xb*Kt*690/800,Sk_Yb*690/800,Sk_Xe*Kt*690/800,Sk_Ye*690/800
scale59f_t	SCLT Sk_Xb*Kf*690/800,Sk_Yb*690/800,Sk_Xe*Kf*690/800,Sk_Ye*690/800
scale59ef_t	SCLT Sk_Xb*KF*690/800,Sk_Yb*690/800,Sk_Xe*KF*690/800,Sk_Ye*690/800

scale510_t	SCLT Sk_Xb*Kn*700/800,Sk_Yb*700/800,Sk_Xe*Kn*700/800,Sk_Ye*700/800
scale510et_t	SCLT Sk_Xb*KT*700/800,Sk_Yb*700/800,Sk_Xe*KT*700/800,Sk_Ye*700/800
scale510t_t	SCLT Sk_Xb*Kt*700/800,Sk_Yb*700/800,Sk_Xe*Kt*700/800,Sk_Ye*700/800
scale510f_t	SCLT Sk_Xb*Kf*700/800,Sk_Yb*700/800,Sk_Xe*Kf*700/800,Sk_Ye*700/800
scale510ef_t	SCLT Sk_Xb*KF*700/800,Sk_Yb*700/800,Sk_Xe*KF*700/800,Sk_Ye*700/800

scale511_t	SCLT Sk_Xb*Kn*710/800,Sk_Yb*710/800,Sk_Xe*Kn*710/800,Sk_Ye*710/800
scale511et_t	SCLT Sk_Xb*KT*710/800,Sk_Yb*710/800,Sk_Xe*KT*710/800,Sk_Ye*710/800
scale511t_t	SCLT Sk_Xb*Kt*710/800,Sk_Yb*710/800,Sk_Xe*Kt*710/800,Sk_Ye*710/800
scale511f_t	SCLT Sk_Xb*Kf*710/800,Sk_Yb*710/800,Sk_Xe*Kf*710/800,Sk_Ye*710/800
scale511ef_t	SCLT Sk_Xb*KF*710/800,Sk_Yb*710/800,Sk_Xe*KF*710/800,Sk_Ye*710/800

scale60_t	SCLT Sk_Xb*Kn*720/800,Sk_Yb*720/800,Sk_Xe*Kn*720/800,Sk_Ye*720/800
scale60et_t	SCLT Sk_Xb*KT*720/800,Sk_Yb*720/800,Sk_Xe*KT*720/800,Sk_Ye*720/800
scale60t_t	SCLT Sk_Xb*Kt*720/800,Sk_Yb*720/800,Sk_Xe*Kt*720/800,Sk_Ye*720/800
scale60f_t	SCLT Sk_Xb*Kf*720/800,Sk_Yb*720/800,Sk_Xe*Kf*720/800,Sk_Ye*720/800
scale60ef_t	SCLT Sk_Xb*KF*720/800,Sk_Yb*720/800,Sk_Xe*KF*720/800,Sk_Ye*720/800

scale61_t	SCLT Sk_Xb*Kn*730/800,Sk_Yb*730/800,Sk_Xe*Kn*730/800,Sk_Ye*730/800
scale61et_t	SCLT Sk_Xb*KT*730/800,Sk_Yb*730/800,Sk_Xe*KT*730/800,Sk_Ye*730/800
scale61t_t	SCLT Sk_Xb*Kt*730/800,Sk_Yb*730/800,Sk_Xe*Kt*730/800,Sk_Ye*730/800
scale61f_t	SCLT Sk_Xb*Kf*730/800,Sk_Yb*730/800,Sk_Xe*Kf*730/800,Sk_Ye*730/800
scale61ef_t	SCLT Sk_Xb*KF*730/800,Sk_Yb*730/800,Sk_Xe*KF*730/800,Sk_Ye*730/800

scale62_t	SCLT Sk_Xb*Kn*740/800,Sk_Yb*740/800,Sk_Xe*Kn*740/800,Sk_Ye*740/800
scale62et_t	SCLT Sk_Xb*KT*740/800,Sk_Yb*740/800,Sk_Xe*KT*740/800,Sk_Ye*740/800
scale62t_t	SCLT Sk_Xb*Kt*740/800,Sk_Yb*740/800,Sk_Xe*Kt*740/800,Sk_Ye*740/800
scale62f_t	SCLT Sk_Xb*Kf*740/800,Sk_Yb*740/800,Sk_Xe*Kf*740/800,Sk_Ye*740/800
scale62ef_t	SCLT Sk_Xb*KF*740/800,Sk_Yb*740/800,Sk_Xe*KF*740/800,Sk_Ye*740/800

scale63_t	SCLT Sk_Xb*Kn*750/800,Sk_Yb*750/800,Sk_Xe*Kn*750/800,Sk_Ye*750/800
scale63et_t	SCLT Sk_Xb*KT*750/800,Sk_Yb*750/800,Sk_Xe*KT*750/800,Sk_Ye*750/800
scale63t_t	SCLT Sk_Xb*Kt*750/800,Sk_Yb*750/800,Sk_Xe*Kt*750/800,Sk_Ye*750/800
scale63f_t	SCLT Sk_Xb*Kf*750/800,Sk_Yb*750/800,Sk_Xe*Kf*750/800,Sk_Ye*750/800
scale63ef_t	SCLT Sk_Xb*KF*750/800,Sk_Yb*750/800,Sk_Xe*KF*750/800,Sk_Ye*750/800

scale64_t	SCLT Sk_Xb*Kn*760/800,Sk_Yb*760/800,Sk_Xe*Kn*760/800,Sk_Ye*760/800
scale64et_t	SCLT Sk_Xb*KT*760/800,Sk_Yb*760/800,Sk_Xe*KT*760/800,Sk_Ye*760/800
scale64t_t	SCLT Sk_Xb*Kt*760/800,Sk_Yb*760/800,Sk_Xe*Kt*760/800,Sk_Ye*760/800
scale64f_t	SCLT Sk_Xb*Kf*760/800,Sk_Yb*760/800,Sk_Xe*Kf*760/800,Sk_Ye*760/800
scale64ef_t	SCLT Sk_Xb*KF*760/800,Sk_Yb*760/800,Sk_Xe*KF*760/800,Sk_Ye*760/800

scale65_t	SCLT Sk_Xb*Kn*770/800,Sk_Yb*770/800,Sk_Xe*Kn*770/800,Sk_Ye*770/800
scale65et_t	SCLT Sk_Xb*KT*770/800,Sk_Yb*770/800,Sk_Xe*KT*770/800,Sk_Ye*770/800
scale65t_t	SCLT Sk_Xb*Kt*770/800,Sk_Yb*770/800,Sk_Xe*Kt*770/800,Sk_Ye*770/800
scale65f_t	SCLT Sk_Xb*Kf*770/800,Sk_Yb*770/800,Sk_Xe*Kf*770/800,Sk_Ye*770/800
scale65ef_t	SCLT Sk_Xb*KF*770/800,Sk_Yb*770/800,Sk_Xe*KF*770/800,Sk_Ye*770/800

scale66_t	SCLT Sk_Xb*Kn*780/800,Sk_Yb*780/800,Sk_Xe*Kn*780/800,Sk_Ye*780/800
scale66et_t	SCLT Sk_Xb*KT*780/800,Sk_Yb*780/800,Sk_Xe*KT*780/800,Sk_Ye*780/800
scale66t_t	SCLT Sk_Xb*Kt*780/800,Sk_Yb*780/800,Sk_Xe*Kt*780/800,Sk_Ye*780/800
scale66f_t	SCLT Sk_Xb*Kf*780/800,Sk_Yb*780/800,Sk_Xe*Kf*780/800,Sk_Ye*780/800
scale66ef_t	SCLT Sk_Xb*KF*780/800,Sk_Yb*780/800,Sk_Xe*KF*780/800,Sk_Ye*780/800

scale67_t	SCLT Sk_Xb*Kn*790/800,Sk_Yb*790/800,Sk_Xe*Kn*790/800,Sk_Ye*790/800
scale67et_t	SCLT Sk_Xb*KT*790/800,Sk_Yb*790/800,Sk_Xe*KT*790/800,Sk_Ye*790/800
scale67t_t	SCLT Sk_Xb*Kt*790/800,Sk_Yb*790/800,Sk_Xe*Kt*790/800,Sk_Ye*790/800
scale67f_t	SCLT Sk_Xb*Kf*790/800,Sk_Yb*790/800,Sk_Xe*Kf*790/800,Sk_Ye*790/800
scale67ef_t	SCLT Sk_Xb*KF*790/800,Sk_Yb*790/800,Sk_Xe*KF*790/800,Sk_Ye*790/800

scale68_t	SCLT Sk_Xb*Kn*800/800,Sk_Yb*800/800,Sk_Xe*Kn*800/800,Sk_Ye*800/800
scale68et_t	SCLT Sk_Xb*KT*800/800,Sk_Yb*800/800,Sk_Xe*KT*800/800,Sk_Ye*800/800
scale68t_t	SCLT Sk_Xb*Kt*800/800,Sk_Yb*800/800,Sk_Xe*Kt*800/800,Sk_Ye*800/800
scale68f_t	SCLT Sk_Xb*Kf*800/800,Sk_Yb*800/800,Sk_Xe*Kf*800/800,Sk_Ye*800/800
scale68ef_t	SCLT Sk_Xb*KF*800/800,Sk_Yb*800/800,Sk_Xe*KF*800/800,Sk_Ye*800/800

scale69_t	SCLT Sk_Xb*Kn*810/800,Sk_Yb*810/800,Sk_Xe*Kn*810/800,Sk_Ye*810/800
scale69et_t	SCLT Sk_Xb*KT*810/800,Sk_Yb*810/800,Sk_Xe*KT*810/800,Sk_Ye*810/800
scale69t_t	SCLT Sk_Xb*Kt*810/800,Sk_Yb*810/800,Sk_Xe*Kt*810/800,Sk_Ye*810/800
scale69f_t	SCLT Sk_Xb*Kf*810/800,Sk_Yb*810/800,Sk_Xe*Kf*810/800,Sk_Ye*810/800
scale69ef_t	SCLT Sk_Xb*KF*810/800,Sk_Yb*810/800,Sk_Xe*KF*810/800,Sk_Ye*810/800

scale610_t	SCLT Sk_Xb*Kn*820/800,Sk_Yb*820/800,Sk_Xe*Kn*820/800,Sk_Ye*820/800
scale610et_t	SCLT Sk_Xb*KT*820/800,Sk_Yb*820/800,Sk_Xe*KT*820/800,Sk_Ye*820/800
scale610t_t	SCLT Sk_Xb*Kt*820/800,Sk_Yb*820/800,Sk_Xe*Kt*820/800,Sk_Ye*820/800
scale610f_t	SCLT Sk_Xb*Kf*820/800,Sk_Yb*820/800,Sk_Xe*Kf*820/800,Sk_Ye*820/800
scale610ef_t	SCLT Sk_Xb*KF*820/800,Sk_Yb*820/800,Sk_Xe*KF*820/800,Sk_Ye*820/800

scale611_t	SCLT Sk_Xb*Kn*830/800,Sk_Yb*830/800,Sk_Xe*Kn*830/800,Sk_Ye*830/800
scale611et_t	SCLT Sk_Xb*KT*830/800,Sk_Yb*830/800,Sk_Xe*KT*830/800,Sk_Ye*830/800
scale611t_t	SCLT Sk_Xb*Kt*830/800,Sk_Yb*830/800,Sk_Xe*Kt*830/800,Sk_Ye*830/800
scale611f_t	SCLT Sk_Xb*Kf*830/800,Sk_Yb*830/800,Sk_Xe*Kf*830/800,Sk_Ye*830/800
scale611ef_t	SCLT Sk_Xb*KF*830/800,Sk_Yb*830/800,Sk_Xe*KF*830/800,Sk_Ye*830/800

scale70_t	SCLT Sk_Xb*Kn*840/800,Sk_Yb*840/800,Sk_Xe*Kn*840/800,Sk_Ye*840/800
scale70et_t	SCLT Sk_Xb*KT*840/800,Sk_Yb*840/800,Sk_Xe*KT*840/800,Sk_Ye*840/800
scale70t_t	SCLT Sk_Xb*Kt*840/800,Sk_Yb*840/800,Sk_Xe*Kt*840/800,Sk_Ye*840/800
scale70f_t	SCLT Sk_Xb*Kf*840/800,Sk_Yb*840/800,Sk_Xe*Kf*840/800,Sk_Ye*840/800
scale70ef_t	SCLT Sk_Xb*KF*840/800,Sk_Yb*840/800,Sk_Xe*KF*840/800,Sk_Ye*840/800

scale71_t	SCLT Sk_Xb*Kn*850/800,Sk_Yb*850/800,Sk_Xe*Kn*850/800,Sk_Ye*850/800
scale71et_t	SCLT Sk_Xb*KT*850/800,Sk_Yb*850/800,Sk_Xe*KT*850/800,Sk_Ye*850/800
scale71t_t	SCLT Sk_Xb*Kt*850/800,Sk_Yb*850/800,Sk_Xe*Kt*850/800,Sk_Ye*850/800
scale71f_t	SCLT Sk_Xb*Kf*850/800,Sk_Yb*850/800,Sk_Xe*Kf*850/800,Sk_Ye*850/800
scale71ef_t	SCLT Sk_Xb*KF*850/800,Sk_Yb*850/800,Sk_Xe*KF*850/800,Sk_Ye*850/800

scale72_t	SCLT Sk_Xb*Kn*860/800,Sk_Yb*860/800,Sk_Xe*Kn*860/800,Sk_Ye*860/800
scale72et_t	SCLT Sk_Xb*KT*860/800,Sk_Yb*860/800,Sk_Xe*KT*860/800,Sk_Ye*860/800
scale72t_t	SCLT Sk_Xb*Kt*860/800,Sk_Yb*860/800,Sk_Xe*Kt*860/800,Sk_Ye*860/800
scale72f_t	SCLT Sk_Xb*Kf*860/800,Sk_Yb*860/800,Sk_Xe*Kf*860/800,Sk_Ye*860/800
scale72ef_t	SCLT Sk_Xb*KF*860/800,Sk_Yb*860/800,Sk_Xe*KF*860/800,Sk_Ye*860/800

scale73_t	SCLT Sk_Xb*Kn*870/800,Sk_Yb*870/800,Sk_Xe*Kn*870/800,Sk_Ye*870/800
scale73et_t	SCLT Sk_Xb*KT*870/800,Sk_Yb*870/800,Sk_Xe*KT*870/800,Sk_Ye*870/800
scale73t_t	SCLT Sk_Xb*Kt*870/800,Sk_Yb*870/800,Sk_Xe*Kt*870/800,Sk_Ye*870/800
scale73f_t	SCLT Sk_Xb*Kf*870/800,Sk_Yb*870/800,Sk_Xe*Kf*870/800,Sk_Ye*870/800
scale73ef_t	SCLT Sk_Xb*KF*870/800,Sk_Yb*870/800,Sk_Xe*KF*870/800,Sk_Ye*870/800

scale74_t	SCLT Sk_Xb*Kn*880/800,Sk_Yb*880/800,Sk_Xe*Kn*880/800,Sk_Ye*880/800
scale74et_t	SCLT Sk_Xb*KT*880/800,Sk_Yb*880/800,Sk_Xe*KT*880/800,Sk_Ye*880/800
scale74t_t	SCLT Sk_Xb*Kt*880/800,Sk_Yb*880/800,Sk_Xe*Kt*880/800,Sk_Ye*880/800
scale74f_t	SCLT Sk_Xb*Kf*880/800,Sk_Yb*880/800,Sk_Xe*Kf*880/800,Sk_Ye*880/800
scale74ef_t	SCLT Sk_Xb*KF*880/800,Sk_Yb*880/800,Sk_Xe*KF*880/800,Sk_Ye*880/800

scale75_t	SCLT Sk_Xb*Kn*890/800,Sk_Yb*890/800,Sk_Xe*Kn*890/800,Sk_Ye*890/800
scale75et_t	SCLT Sk_Xb*KT*890/800,Sk_Yb*890/800,Sk_Xe*KT*890/800,Sk_Ye*890/800
scale75t_t	SCLT Sk_Xb*Kt*890/800,Sk_Yb*890/800,Sk_Xe*Kt*890/800,Sk_Ye*890/800
scale75f_t	SCLT Sk_Xb*Kf*890/800,Sk_Yb*890/800,Sk_Xe*Kf*890/800,Sk_Ye*890/800
scale75ef_t	SCLT Sk_Xb*KF*890/800,Sk_Yb*890/800,Sk_Xe*KF*890/800,Sk_Ye*890/800

scale76_t	SCLT Sk_Xb*Kn*900/800,Sk_Yb*900/800,Sk_Xe*Kn*900/800,Sk_Ye*900/800
scale76et_t	SCLT Sk_Xb*KT*900/800,Sk_Yb*900/800,Sk_Xe*KT*900/800,Sk_Ye*900/800
scale76t_t	SCLT Sk_Xb*Kt*900/800,Sk_Yb*900/800,Sk_Xe*Kt*900/800,Sk_Ye*900/800
scale76f_t	SCLT Sk_Xb*Kf*900/800,Sk_Yb*900/800,Sk_Xe*Kf*900/800,Sk_Ye*900/800
scale76ef_t	SCLT Sk_Xb*KF*900/800,Sk_Yb*900/800,Sk_Xe*KF*900/800,Sk_Ye*900/800

scale77ef_t	SCLT Sk_Xb*KF*910/800,Sk_Yb*910/800,Sk_Xe*KF*910/800,Sk_Ye*910/800

scalebaby_t	SCLT Sk_Xb*420/800,Sk_Yb*420/800,Sk_Xe*420/800,Sk_Ye*420/800

;--------------------

	.asg	110/100,Ks

scale_t_sm			;Start of small-image scale tables

scale_t_size	.equ	scale_t_sm-scale_t

scale57_t_sm	SCLT Sk_Xb*Ks*Kn*670/800,Sk_Yb*Ks*670/800,Sk_Xe*Ks*Kn*670/800,Sk_Ye*Ks*670/800
scale57et_t_sm	SCLT Sk_Xb*Ks*KT*670/800,Sk_Yb*Ks*670/800,Sk_Xe*Ks*KT*670/800,Sk_Ye*Ks*670/800
scale57t_t_sm	SCLT Sk_Xb*Ks*Kt*670/800,Sk_Yb*Ks*670/800,Sk_Xe*Ks*Kt*670/800,Sk_Ye*Ks*670/800
scale57f_t_sm	SCLT Sk_Xb*Ks*Kf*670/800,Sk_Yb*Ks*670/800,Sk_Xe*Ks*Kf*670/800,Sk_Ye*Ks*670/800
scale57ef_t_sm	SCLT Sk_Xb*Ks*KF*670/800,Sk_Yb*Ks*670/800,Sk_Xe*Ks*KF*670/800,Sk_Ye*Ks*670/800

scale58_t_sm	SCLT Sk_Xb*Ks*Kn*680/800,Sk_Yb*Ks*680/800,Sk_Xe*Ks*Kn*680/800,Sk_Ye*Ks*680/800
scale58et_t_sm	SCLT Sk_Xb*Ks*KT*680/800,Sk_Yb*Ks*680/800,Sk_Xe*Ks*KT*680/800,Sk_Ye*Ks*680/800
scale58t_t_sm	SCLT Sk_Xb*Ks*Kt*680/800,Sk_Yb*Ks*680/800,Sk_Xe*Ks*Kt*680/800,Sk_Ye*Ks*680/800
scale58f_t_sm	SCLT Sk_Xb*Ks*Kf*680/800,Sk_Yb*Ks*680/800,Sk_Xe*Ks*Kf*680/800,Sk_Ye*Ks*680/800
scale58ef_t_sm	SCLT Sk_Xb*Ks*KF*680/800,Sk_Yb*Ks*680/800,Sk_Xe*Ks*KF*680/800,Sk_Ye*Ks*680/800

scale59_t_sm	SCLT Sk_Xb*Ks*Kn*690/800,Sk_Yb*Ks*690/800,Sk_Xe*Ks*Kn*690/800,Sk_Ye*Ks*690/800
scale59et_t_sm	SCLT Sk_Xb*Ks*KT*690/800,Sk_Yb*Ks*690/800,Sk_Xe*Ks*KT*690/800,Sk_Ye*Ks*690/800
scale59t_t_sm	SCLT Sk_Xb*Ks*Kt*690/800,Sk_Yb*Ks*690/800,Sk_Xe*Ks*Kt*690/800,Sk_Ye*Ks*690/800
scale59f_t_sm	SCLT Sk_Xb*Ks*Kf*690/800,Sk_Yb*Ks*690/800,Sk_Xe*Ks*Kf*690/800,Sk_Ye*Ks*690/800
scale59ef_t_sm	SCLT Sk_Xb*Ks*KF*690/800,Sk_Yb*Ks*690/800,Sk_Xe*Ks*KF*690/800,Sk_Ye*Ks*690/800

scale510_t_sm	SCLT Sk_Xb*Ks*Kn*700/800,Sk_Yb*Ks*700/800,Sk_Xe*Ks*Kn*700/800,Sk_Ye*Ks*700/800
scale510et_t_sm	SCLT Sk_Xb*Ks*KT*700/800,Sk_Yb*Ks*700/800,Sk_Xe*Ks*KT*700/800,Sk_Ye*Ks*700/800
scale510t_t_sm	SCLT Sk_Xb*Ks*Kt*700/800,Sk_Yb*Ks*700/800,Sk_Xe*Ks*Kt*700/800,Sk_Ye*Ks*700/800
scale510f_t_sm	SCLT Sk_Xb*Ks*Kf*700/800,Sk_Yb*Ks*700/800,Sk_Xe*Ks*Kf*700/800,Sk_Ye*Ks*700/800
scale510ef_t_sm	SCLT Sk_Xb*Ks*KF*700/800,Sk_Yb*Ks*700/800,Sk_Xe*Ks*KF*700/800,Sk_Ye*Ks*700/800

scale511_t_sm	SCLT Sk_Xb*Ks*Kn*710/800,Sk_Yb*Ks*710/800,Sk_Xe*Ks*Kn*710/800,Sk_Ye*Ks*710/800
scale511et_t_sm	SCLT Sk_Xb*Ks*KT*710/800,Sk_Yb*Ks*710/800,Sk_Xe*Ks*KT*710/800,Sk_Ye*Ks*710/800
scale511t_t_sm	SCLT Sk_Xb*Ks*Kt*710/800,Sk_Yb*Ks*710/800,Sk_Xe*Ks*Kt*710/800,Sk_Ye*Ks*710/800
scale511f_t_sm	SCLT Sk_Xb*Ks*Kf*710/800,Sk_Yb*Ks*710/800,Sk_Xe*Ks*Kf*710/800,Sk_Ye*Ks*710/800
scale511ef_t_sm	SCLT Sk_Xb*Ks*KF*710/800,Sk_Yb*Ks*710/800,Sk_Xe*Ks*KF*710/800,Sk_Ye*Ks*710/800

scale60_t_sm	SCLT Sk_Xb*Ks*Kn*720/800,Sk_Yb*Ks*720/800,Sk_Xe*Ks*Kn*720/800,Sk_Ye*Ks*720/800
scale60et_t_sm	SCLT Sk_Xb*Ks*KT*720/800,Sk_Yb*Ks*720/800,Sk_Xe*Ks*KT*720/800,Sk_Ye*Ks*720/800
scale60t_t_sm	SCLT Sk_Xb*Ks*Kt*720/800,Sk_Yb*Ks*720/800,Sk_Xe*Ks*Kt*720/800,Sk_Ye*Ks*720/800
scale60f_t_sm	SCLT Sk_Xb*Ks*Kf*720/800,Sk_Yb*Ks*720/800,Sk_Xe*Ks*Kf*720/800,Sk_Ye*Ks*720/800
scale60ef_t_sm	SCLT Sk_Xb*Ks*KF*720/800,Sk_Yb*Ks*720/800,Sk_Xe*Ks*KF*720/800,Sk_Ye*Ks*720/800

scale61_t_sm	SCLT Sk_Xb*Ks*Kn*730/800,Sk_Yb*Ks*730/800,Sk_Xe*Ks*Kn*730/800,Sk_Ye*Ks*730/800
scale61et_t_sm	SCLT Sk_Xb*Ks*KT*730/800,Sk_Yb*Ks*730/800,Sk_Xe*Ks*KT*730/800,Sk_Ye*Ks*730/800
scale61t_t_sm	SCLT Sk_Xb*Ks*Kt*730/800,Sk_Yb*Ks*730/800,Sk_Xe*Ks*Kt*730/800,Sk_Ye*Ks*730/800
scale61f_t_sm	SCLT Sk_Xb*Ks*Kf*730/800,Sk_Yb*Ks*730/800,Sk_Xe*Ks*Kf*730/800,Sk_Ye*Ks*730/800
scale61ef_t_sm	SCLT Sk_Xb*Ks*KF*730/800,Sk_Yb*Ks*730/800,Sk_Xe*Ks*KF*730/800,Sk_Ye*Ks*730/800

scale62_t_sm	SCLT Sk_Xb*Ks*Kn*740/800,Sk_Yb*Ks*740/800,Sk_Xe*Ks*Kn*740/800,Sk_Ye*Ks*740/800
scale62et_t_sm	SCLT Sk_Xb*Ks*KT*740/800,Sk_Yb*Ks*740/800,Sk_Xe*Ks*KT*740/800,Sk_Ye*Ks*740/800
scale62t_t_sm	SCLT Sk_Xb*Ks*Kt*740/800,Sk_Yb*Ks*740/800,Sk_Xe*Ks*Kt*740/800,Sk_Ye*Ks*740/800
scale62f_t_sm	SCLT Sk_Xb*Ks*Kf*740/800,Sk_Yb*Ks*740/800,Sk_Xe*Ks*Kf*740/800,Sk_Ye*Ks*740/800
scale62ef_t_sm	SCLT Sk_Xb*Ks*KF*740/800,Sk_Yb*Ks*740/800,Sk_Xe*Ks*KF*740/800,Sk_Ye*Ks*740/800

scale63_t_sm	SCLT Sk_Xb*Ks*Kn*750/800,Sk_Yb*Ks*750/800,Sk_Xe*Ks*Kn*750/800,Sk_Ye*Ks*750/800
scale63et_t_sm	SCLT Sk_Xb*Ks*KT*750/800,Sk_Yb*Ks*750/800,Sk_Xe*Ks*KT*750/800,Sk_Ye*Ks*750/800
scale63t_t_sm	SCLT Sk_Xb*Ks*Kt*750/800,Sk_Yb*Ks*750/800,Sk_Xe*Ks*Kt*750/800,Sk_Ye*Ks*750/800
scale63f_t_sm	SCLT Sk_Xb*Ks*Kf*750/800,Sk_Yb*Ks*750/800,Sk_Xe*Ks*Kf*750/800,Sk_Ye*Ks*750/800
scale63ef_t_sm	SCLT Sk_Xb*Ks*KF*750/800,Sk_Yb*Ks*750/800,Sk_Xe*Ks*KF*750/800,Sk_Ye*Ks*750/800

scale64_t_sm	SCLT Sk_Xb*Ks*Kn*760/800,Sk_Yb*Ks*760/800,Sk_Xe*Ks*Kn*760/800,Sk_Ye*Ks*760/800
scale64et_t_sm	SCLT Sk_Xb*Ks*KT*760/800,Sk_Yb*Ks*760/800,Sk_Xe*Ks*KT*760/800,Sk_Ye*Ks*760/800
scale64t_t_sm	SCLT Sk_Xb*Ks*Kt*760/800,Sk_Yb*Ks*760/800,Sk_Xe*Ks*Kt*760/800,Sk_Ye*Ks*760/800
scale64f_t_sm	SCLT Sk_Xb*Ks*Kf*760/800,Sk_Yb*Ks*760/800,Sk_Xe*Ks*Kf*760/800,Sk_Ye*Ks*760/800
scale64ef_t_sm	SCLT Sk_Xb*Ks*KF*760/800,Sk_Yb*Ks*760/800,Sk_Xe*Ks*KF*760/800,Sk_Ye*Ks*760/800

scale65_t_sm	SCLT Sk_Xb*Ks*Kn*770/800,Sk_Yb*Ks*770/800,Sk_Xe*Ks*Kn*770/800,Sk_Ye*Ks*770/800
scale65et_t_sm	SCLT Sk_Xb*Ks*KT*770/800,Sk_Yb*Ks*770/800,Sk_Xe*Ks*KT*770/800,Sk_Ye*Ks*770/800
scale65t_t_sm	SCLT Sk_Xb*Ks*Kt*770/800,Sk_Yb*Ks*770/800,Sk_Xe*Ks*Kt*770/800,Sk_Ye*Ks*770/800
scale65f_t_sm	SCLT Sk_Xb*Ks*Kf*770/800,Sk_Yb*Ks*770/800,Sk_Xe*Ks*Kf*770/800,Sk_Ye*Ks*770/800
scale65ef_t_sm	SCLT Sk_Xb*Ks*KF*770/800,Sk_Yb*Ks*770/800,Sk_Xe*Ks*KF*770/800,Sk_Ye*Ks*770/800

scale66_t_sm	SCLT Sk_Xb*Ks*Kn*780/800,Sk_Yb*Ks*780/800,Sk_Xe*Ks*Kn*780/800,Sk_Ye*Ks*780/800
scale66et_t_sm	SCLT Sk_Xb*Ks*KT*780/800,Sk_Yb*Ks*780/800,Sk_Xe*Ks*KT*780/800,Sk_Ye*Ks*780/800
scale66t_t_sm	SCLT Sk_Xb*Ks*Kt*780/800,Sk_Yb*Ks*780/800,Sk_Xe*Ks*Kt*780/800,Sk_Ye*Ks*780/800
scale66f_t_sm	SCLT Sk_Xb*Ks*Kf*780/800,Sk_Yb*Ks*780/800,Sk_Xe*Ks*Kf*780/800,Sk_Ye*Ks*780/800
scale66ef_t_sm	SCLT Sk_Xb*Ks*KF*780/800,Sk_Yb*Ks*780/800,Sk_Xe*Ks*KF*780/800,Sk_Ye*Ks*780/800

scale67_t_sm	SCLT Sk_Xb*Ks*Kn*790/800,Sk_Yb*Ks*790/800,Sk_Xe*Ks*Kn*790/800,Sk_Ye*Ks*790/800
scale67et_t_sm	SCLT Sk_Xb*Ks*KT*790/800,Sk_Yb*Ks*790/800,Sk_Xe*Ks*KT*790/800,Sk_Ye*Ks*790/800
scale67t_t_sm	SCLT Sk_Xb*Ks*Kt*790/800,Sk_Yb*Ks*790/800,Sk_Xe*Ks*Kt*790/800,Sk_Ye*Ks*790/800
scale67f_t_sm	SCLT Sk_Xb*Ks*Kf*790/800,Sk_Yb*Ks*790/800,Sk_Xe*Ks*Kf*790/800,Sk_Ye*Ks*790/800
scale67ef_t_sm	SCLT Sk_Xb*Ks*KF*790/800,Sk_Yb*Ks*790/800,Sk_Xe*Ks*KF*790/800,Sk_Ye*Ks*790/800

scale68_t_sm	SCLT Sk_Xb*Ks*Kn*800/800,Sk_Yb*Ks*800/800,Sk_Xe*Ks*Kn*800/800,Sk_Ye*Ks*800/800
scale68et_t_sm	SCLT Sk_Xb*Ks*KT*800/800,Sk_Yb*Ks*800/800,Sk_Xe*Ks*KT*800/800,Sk_Ye*Ks*800/800
scale68t_t_sm	SCLT Sk_Xb*Ks*Kt*800/800,Sk_Yb*Ks*800/800,Sk_Xe*Ks*Kt*800/800,Sk_Ye*Ks*800/800
scale68f_t_sm	SCLT Sk_Xb*Ks*Kf*800/800,Sk_Yb*Ks*800/800,Sk_Xe*Ks*Kf*800/800,Sk_Ye*Ks*800/800
scale68ef_t_sm	SCLT Sk_Xb*Ks*KF*800/800,Sk_Yb*Ks*800/800,Sk_Xe*Ks*KF*800/800,Sk_Ye*Ks*800/800

scale69_t_sm	SCLT Sk_Xb*Ks*Kn*810/800,Sk_Yb*Ks*810/800,Sk_Xe*Ks*Kn*810/800,Sk_Ye*Ks*810/800
scale69et_t_sm	SCLT Sk_Xb*Ks*KT*810/800,Sk_Yb*Ks*810/800,Sk_Xe*Ks*KT*810/800,Sk_Ye*Ks*810/800
scale69t_t_sm	SCLT Sk_Xb*Ks*Kt*810/800,Sk_Yb*Ks*810/800,Sk_Xe*Ks*Kt*810/800,Sk_Ye*Ks*810/800
scale69f_t_sm	SCLT Sk_Xb*Ks*Kf*810/800,Sk_Yb*Ks*810/800,Sk_Xe*Ks*Kf*810/800,Sk_Ye*Ks*810/800
scale69ef_t_sm	SCLT Sk_Xb*Ks*KF*810/800,Sk_Yb*Ks*810/800,Sk_Xe*Ks*KF*810/800,Sk_Ye*Ks*810/800

scale610_t_sm	SCLT Sk_Xb*Ks*Kn*820/800,Sk_Yb*Ks*820/800,Sk_Xe*Ks*Kn*820/800,Sk_Ye*Ks*820/800
scale610et_t_sm	SCLT Sk_Xb*Ks*KT*820/800,Sk_Yb*Ks*820/800,Sk_Xe*Ks*KT*820/800,Sk_Ye*Ks*820/800
scale610t_t_sm	SCLT Sk_Xb*Ks*Kt*820/800,Sk_Yb*Ks*820/800,Sk_Xe*Ks*Kt*820/800,Sk_Ye*Ks*820/800
scale610f_t_sm	SCLT Sk_Xb*Ks*Kf*820/800,Sk_Yb*Ks*820/800,Sk_Xe*Ks*Kf*820/800,Sk_Ye*Ks*820/800
scale610ef_t_sm	SCLT Sk_Xb*Ks*KF*820/800,Sk_Yb*Ks*820/800,Sk_Xe*Ks*KF*820/800,Sk_Ye*Ks*820/800

scale611_t_sm	SCLT Sk_Xb*Ks*Kn*830/800,Sk_Yb*Ks*830/800,Sk_Xe*Ks*Kn*830/800,Sk_Ye*Ks*830/800
scale611et_t_sm	SCLT Sk_Xb*Ks*KT*830/800,Sk_Yb*Ks*830/800,Sk_Xe*Ks*KT*830/800,Sk_Ye*Ks*830/800
scale611t_t_sm	SCLT Sk_Xb*Ks*Kt*830/800,Sk_Yb*Ks*830/800,Sk_Xe*Ks*Kt*830/800,Sk_Ye*Ks*830/800
scale611f_t_sm	SCLT Sk_Xb*Ks*Kf*830/800,Sk_Yb*Ks*830/800,Sk_Xe*Ks*Kf*830/800,Sk_Ye*Ks*830/800
scale611ef_t_sm	SCLT Sk_Xb*Ks*KF*830/800,Sk_Yb*Ks*830/800,Sk_Xe*Ks*KF*830/800,Sk_Ye*Ks*830/800

scale70_t_sm	SCLT Sk_Xb*Ks*Kn*840/800,Sk_Yb*Ks*840/800,Sk_Xe*Ks*Kn*840/800,Sk_Ye*Ks*840/800
scale70et_t_sm	SCLT Sk_Xb*Ks*KT*840/800,Sk_Yb*Ks*840/800,Sk_Xe*Ks*KT*840/800,Sk_Ye*Ks*840/800
scale70t_t_sm	SCLT Sk_Xb*Ks*Kt*840/800,Sk_Yb*Ks*840/800,Sk_Xe*Ks*Kt*840/800,Sk_Ye*Ks*840/800
scale70f_t_sm	SCLT Sk_Xb*Ks*Kf*840/800,Sk_Yb*Ks*840/800,Sk_Xe*Ks*Kf*840/800,Sk_Ye*Ks*840/800
scale70ef_t_sm	SCLT Sk_Xb*Ks*KF*840/800,Sk_Yb*Ks*840/800,Sk_Xe*Ks*KF*840/800,Sk_Ye*Ks*840/800

scale71_t_sm	SCLT Sk_Xb*Ks*Kn*850/800,Sk_Yb*Ks*850/800,Sk_Xe*Ks*Kn*850/800,Sk_Ye*Ks*850/800
scale71et_t_sm	SCLT Sk_Xb*Ks*KT*850/800,Sk_Yb*Ks*850/800,Sk_Xe*Ks*KT*850/800,Sk_Ye*Ks*850/800
scale71t_t_sm	SCLT Sk_Xb*Ks*Kt*850/800,Sk_Yb*Ks*850/800,Sk_Xe*Ks*Kt*850/800,Sk_Ye*Ks*850/800
scale71f_t_sm	SCLT Sk_Xb*Ks*Kf*850/800,Sk_Yb*Ks*850/800,Sk_Xe*Ks*Kf*850/800,Sk_Ye*Ks*850/800
scale71ef_t_sm	SCLT Sk_Xb*Ks*KF*850/800,Sk_Yb*Ks*850/800,Sk_Xe*Ks*KF*850/800,Sk_Ye*Ks*850/800

scale72_t_sm	SCLT Sk_Xb*Ks*Kn*860/800,Sk_Yb*Ks*860/800,Sk_Xe*Ks*Kn*860/800,Sk_Ye*Ks*860/800
scale72et_t_sm	SCLT Sk_Xb*Ks*KT*860/800,Sk_Yb*Ks*860/800,Sk_Xe*Ks*KT*860/800,Sk_Ye*Ks*860/800
scale72t_t_sm	SCLT Sk_Xb*Ks*Kt*860/800,Sk_Yb*Ks*860/800,Sk_Xe*Ks*Kt*860/800,Sk_Ye*Ks*860/800
scale72f_t_sm	SCLT Sk_Xb*Ks*Kf*860/800,Sk_Yb*Ks*860/800,Sk_Xe*Ks*Kf*860/800,Sk_Ye*Ks*860/800
scale72ef_t_sm	SCLT Sk_Xb*Ks*KF*860/800,Sk_Yb*Ks*860/800,Sk_Xe*Ks*KF*860/800,Sk_Ye*Ks*860/800

scale73_t_sm	SCLT Sk_Xb*Ks*Kn*870/800,Sk_Yb*Ks*870/800,Sk_Xe*Ks*Kn*870/800,Sk_Ye*Ks*870/800
scale73et_t_sm	SCLT Sk_Xb*Ks*KT*870/800,Sk_Yb*Ks*870/800,Sk_Xe*Ks*KT*870/800,Sk_Ye*Ks*870/800
scale73t_t_sm	SCLT Sk_Xb*Ks*Kt*870/800,Sk_Yb*Ks*870/800,Sk_Xe*Ks*Kt*870/800,Sk_Ye*Ks*870/800
scale73f_t_sm	SCLT Sk_Xb*Ks*Kf*870/800,Sk_Yb*Ks*870/800,Sk_Xe*Ks*Kf*870/800,Sk_Ye*Ks*870/800
scale73ef_t_sm	SCLT Sk_Xb*Ks*KF*870/800,Sk_Yb*Ks*870/800,Sk_Xe*Ks*KF*870/800,Sk_Ye*Ks*870/800

scale74_t_sm	SCLT Sk_Xb*Ks*Kn*880/800,Sk_Yb*Ks*880/800,Sk_Xe*Ks*Kn*880/800,Sk_Ye*Ks*880/800
scale74et_t_sm	SCLT Sk_Xb*Ks*KT*880/800,Sk_Yb*Ks*880/800,Sk_Xe*Ks*KT*880/800,Sk_Ye*Ks*880/800
scale74t_t_sm	SCLT Sk_Xb*Ks*Kt*880/800,Sk_Yb*Ks*880/800,Sk_Xe*Ks*Kt*880/800,Sk_Ye*Ks*880/800
scale74f_t_sm	SCLT Sk_Xb*Ks*Kf*880/800,Sk_Yb*Ks*880/800,Sk_Xe*Ks*Kf*880/800,Sk_Ye*Ks*880/800
scale74ef_t_sm	SCLT Sk_Xb*Ks*KF*880/800,Sk_Yb*Ks*880/800,Sk_Xe*Ks*KF*880/800,Sk_Ye*Ks*880/800

scale75_t_sm	SCLT Sk_Xb*Ks*Kn*890/800,Sk_Yb*Ks*890/800,Sk_Xe*Ks*Kn*890/800,Sk_Ye*Ks*890/800
scale75et_t_sm	SCLT Sk_Xb*Ks*KT*890/800,Sk_Yb*Ks*890/800,Sk_Xe*Ks*KT*890/800,Sk_Ye*Ks*890/800
scale75t_t_sm	SCLT Sk_Xb*Ks*Kt*890/800,Sk_Yb*Ks*890/800,Sk_Xe*Ks*Kt*890/800,Sk_Ye*Ks*890/800
scale75f_t_sm	SCLT Sk_Xb*Ks*Kf*890/800,Sk_Yb*Ks*890/800,Sk_Xe*Ks*Kf*890/800,Sk_Ye*Ks*890/800
scale75ef_t_sm	SCLT Sk_Xb*Ks*KF*890/800,Sk_Yb*Ks*890/800,Sk_Xe*Ks*KF*890/800,Sk_Ye*Ks*890/800

scale76_t_sm	SCLT Sk_Xb*Ks*Kn*900/800,Sk_Yb*Ks*900/800,Sk_Xe*Ks*Kn*900/800,Sk_Ye*Ks*900/800
scale76et_t_sm	SCLT Sk_Xb*Ks*KT*900/800,Sk_Yb*Ks*900/800,Sk_Xe*Ks*KT*900/800,Sk_Ye*Ks*900/800
scale76t_t_sm	SCLT Sk_Xb*Ks*Kt*900/800,Sk_Yb*Ks*900/800,Sk_Xe*Ks*Kt*900/800,Sk_Ye*Ks*900/800
scale76f_t_sm	SCLT Sk_Xb*Ks*Kf*900/800,Sk_Yb*Ks*900/800,Sk_Xe*Ks*Kf*900/800,Sk_Ye*Ks*900/800
scale76ef_t_sm	SCLT Sk_Xb*Ks*KF*900/800,Sk_Yb*Ks*900/800,Sk_Xe*Ks*KF*900/800,Sk_Ye*Ks*900/800

scale77ef_t_sm	SCLT Sk_Xb*Ks*KF*910/800,Sk_Yb*Ks*910/800,Sk_Xe*Ks*KF*910/800,Sk_Ye*Ks*910/800

scalebaby_t_sm	SCLT Sk_Xb*Ks*420/800,Sk_Yb*Ks*420/800,Sk_Xe*Ks*420/800,Sk_Ye*Ks*420/800


	.end
