**************************************************************
*
* Owner:	none
*
* Software:	Todd Allen, Mark Turmell, Shawn Liptak
* Initiated:	1988?
*
* Modified:	Shawn Liptak, 9/16/91	-Minor improvements (Total carnage)
* 		Shawn Liptak, 11/15/91	-CREATE0
* 		Shawn Liptak, 2/10/92	-Started basketball
* 		Shawn Liptak, 5/4/92	-Works with DMA2
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 9/23/92 12:26
**************************************************************
	.file	"bakgnd.asm"
	.title	"background handlers"
	.option	b,d,l
	.mnolist

	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"gsp.equ"
	.include	"sys.equ"
	.include	"bgndtbl.glo"		;background equates
	.include	"imgtbl.glo"
	.include	"game.equ"
	.include	"macros.hdr"


;refs

	.if	NMBPAL
	.ref	pal_getb
	.endif
	.ref	pal_getf

	.ref	BAKLST


;defs



;uninitialized ram definitions


	.bss	BGNDPALTBL	,32
	.bss	MOD_POS		,32
	BSSX	BAKBITS		,10000

	BSSX	BAKMODS		,32


	.text

********************************

*BACKGROUND UPDATER EQUATES
BLSTSTRT	.EQU	>8000
BLSTEND 	.EQU	>8001

************* LOCAL CONSTANTS FOR UPD **************
DISP_PAD	.SET	[20h,20h]	;Y:X
DISP_PAD2	.SET	[80h,20h]	;Y:X
WIDEST_BLOCK	.SET	250

* MUST KEEP THE SIZE OF THESE STRUCTURES A MULTIPLE OF 16
;MAP_ZFLAGSPAL	.SET	0
MAP_PAL		.SET	0	;SIZE 4 - PALETTE SELECT
MAP_FLAGS	.SET	4	;SIZE 4 - BIT 0 HFLIP, BIT 1 YFLIP
MAP_Z		.SET	8	;SIZE 8
MAP_X		.SET	16	;SIZE 16
MAP_Y		.SET	32	;SIZE 16
MAP_HDR		.SET	48	;SIZE 16 - OFFSET IN LONG WORDS FROM BLOCK_HDR_TBL
				; BITS 12-15 ARE BITS 4-7 OF PAL
				; MAP_HDR SET TO >FFFF IF BLOCK IS NOT ALLOCATED
BLOCK_SIZE	.SET	64	;Uses shifts!

* Offsets for a BLOCK HDR structure
;MAP_SIZE	.set	0
MAP_W		.set	0	;Word
MAP_H		.set	16	;Word
MAP_DATAPTR	.set	32	;Long
MAP_CTRL	.equ	64	;DMA ctrl word
;BLOCK_HDR_SIZE	.set	80


************************************************************************
* SCAN A MODULE LIST TO FIND OUT WHICH MODULE CONTAINS BLOCKS
* WHICH NEED TO BE CHECKED
* A0=XPOS FOR WHICH HEIGHT OF BACKGROUND NEEDS TO BE DETERMINED
*RETURNS A0 -
*	MINIMUM YPOS (MAX HEIGHT) OF PRIMARY BACKGROUND WHICH OVERLAPS
*	SPECIFIED XPOS
*	A0 = 0 IF XPOS IS INVALID

BGNDHGHT
	MMTM	SP,A1,A2,A3,A4,A7,A8,A9,A10,A11
	MOVE	A0,A1

	CLR	A10		;INIT PACKED Y:X STARTING POSITION
	CLR	A11

	MOVE	@BAKMODS,A0,L	;* A0- PTR TO THE MODULE LIST
MODLP0	MOVE	*A0+,A8,L	;LOAD MODULE PTR
	jrz	MODX0		;End?
	MOVE	*A8+,A9,L	;LOAD PACKED Y:X SIZE

	MOVE	*A0+,A3		;X START POSITION
	ZEXT	A3
	CMPI	BLSTSTRT,A3
	JRNZ	NOTLSTSTRTX
	MOVE	A11,A3		
	SUBXY	A9,A3
	JRUC	GOTNEWX0
NOTLSTSTRTX
	CMPI	BLSTEND,A3
	JRNZ	GOTNEWX0
	MOVE	A11,A3
GOTNEWX0
	MOVE	*A0+,A4		;Y START POSITION
	ZEXT	A4
	CMPI	BLSTSTRT,A4
	JRNZ	NOTLSTSTRTY
	MOVE	A11,A4		
	SUBXY	A9,A4
	JRUC	GOTNEWY0
NOTLSTSTRTY
	CMPI	BLSTEND,A4
	JRNZ	NOTLSTENDY
	MOVE	A11,A4
	JRUC	GOTNEWY0
NOTLSTENDY
	SLL	16,A4
GOTNEWY0
	MOVY	A4,A3
	MOVE	A3,A10

;	CMPXY	A10,A1
;	JRV	MODX0		;JUMP TO EXIT LOOP IF MOD START X > X SOUGHT

	;IF MOD END X < X SOUGHT KEEP SEARCHING MOD LIST
	MOVE	A10,A11
	ADDXY	A9,A11		;A11 IS MODULE Y:X END

	MOVE	*A8+,A9		;LOAD # OF BLOCKS
	ADD	A9,A7		;A7 IS NEW BAKBITS PTR
	CMPXY	A11,A1
	JRNV	MODLP0		;SKIP IF AX < BX

	MOVE	A10,A0
	SRL	16,A0
	JRUC	GOTHGHT

MODX0	CLR	A0
GOTHGHT	MMFM	SP,A1,A2,A3,A4,A7,A8,A9,A10,A11
	RETS


********************************
* PARMS
* A0=XPos of block
* A1=*Start of bkgnd block table
* A2=*End of block table
* >A0=ADDRESS OF FIRST BLOCK WITH X COORDINATE >= PARM
*	IF NEW X IS HIGHEST RETURNS NEXT EMPTY BLOCK
*	IF NO BLOCKS WITH >= X, RETURN 0

* A1 = BLOCK TABLE BASE + OFFSET TO X VAL
* A14 - THRESHHOLD FOR SWITCHING FROM BINARY TO LINEAR SEARCH
* A9 = LOW # -- # GREATEST BACKGROUND BLOCK
* A10 = MID # -- (HIGH + LOW) >> 1
* A2 = HIGH # -- # OF LOWEST BACKGROUND BLOCK

 SUBRP	bgnd_get1stx

	PUSH	a1,a2,a8,a9,a10

	clr	a9		;set low = 0
	sub	a1,a2
	srl	6,a2		;div by size of block (64)
	addi	MAP_X,a1	;block tbl base + x offset
	movk	5,a14		;threshhold for switching from binary to linear search

#lp	move	a2,a10
	sub	a9,a10		;if (high - low) <= 5 finish with linear search
	cmp	a14,a10
	jrle	lsrch

	srl	1,a10		;/2
	add	a9,a10

	move	a10,a8		;Get mid X
	sll	6,a8		;multiply by block size (64)
	add	a1,a8
	move	*a8,a8		;get x coor of the block
	cmp	a0,a8
	jrlt	blow

	move	a10,a2		;high = mid
	jruc	#lp
blow	move	a10,a9		;low = mid
	jruc	#lp

lsrch
	;* FINISH WITH A LINEAR SEARCH OF BLOCK TABLE FROM LOW TO HIGH
	;* ENDING WITH FIRST BLOCK X COOR THAT IS >= A0
	;* A0 = X VAL BEING SEARCHED FOR
	;* A9 = LOW ADDRESS -- PTS TO X OFFSET OF BLOCK
	;* A2 = HIGH ADDRESS -- PTS TO X OFFSET OF BLOCK

	SLL	6,A9		;LOW BLOCK # TO LOW BLOCK OFFSET
	SLL	6,A2		;HIGH BLOCK # TO HIGH BLOCK OFFSET
	ADD	A1,A9
	ADD	A1,A2
	MOVI	BLOCK_SIZE,A8
#linlp
	MOVE	*A9,A10		;X COOR
	CMP	A0,A10
	JRGE	GOTB		;IF LOW->X >= A0 GOTO FOUND
	ADD	A8,A9
	CMP	A2,A9
	jrle	#linlp
	clr	a0		;block not found, return 0
	jruc	#x

GOTB
	move	a9,a0		;return a ptr to the block
	subi	MAP_X,a0

#x
	PULL	a1,a2,a8,a9,a10
	rets


*********************** BAK END *******************************
;* SCAN A MODULE LIST AND RETURN THE PACKED Y:X END POINT
;PARMS
	;A0 - MODULE LIST
;RETURNS
	;A0 - PACKED Y:X END OF WAVE
;BAK_END
;	MMTM	SP,A3,A4,A8,A9,A10,A11
;
;	CLR	A10	;CLR PACKED Y:X STARTING POSITION
;	CLR	A11
;
;
;WEMODLP
;	MOVE	*A0+,A8,L		;LOAD MODULE PTR
;	JRZ	WEMODX			;END OF THE MODULE TBL
;	MOVE	*A8+,A9,L		;LOAD PACKED Y:X SIZE
;
;	MOVE	*A0+,A3,W		;X START POSITION
;	ZEXT	A3,W
;	CMPI	BLSTSTRT,A3
;	JRNZ	WENOTLASTSTARTX
;	MOVE	A11,A3		
;	SUBXY	A9,A3
;	JRUC	WEGOTNEWX
;WENOTLASTSTARTX
;	CMPI	BLSTEND,A3
;	JRNZ	WEGOTNEWX
;	MOVE	A11,A3
;WEGOTNEWX
;	MOVE	*A0+,A4,W		;Y START POSITION
;	ZEXT	A4,W
;	CMPI	BLSTSTRT,A4
;	JRNZ	WENOTLASTSTARTY
;	MOVE	A11,A4		
;	SUBXY	A9,A4
;	JRUC	WEGOTNEWY
;WENOTLASTSTARTY
;	CMPI	BLSTEND,A4
;	JRNZ	WENOTLASTENDY
;	MOVE	A11,A4
;	JRUC	WEGOTNEWY
;WENOTLASTENDY
;	SLL	16,A4
;WEGOTNEWY
;	MOVY	A4,A3
;	MOVE	A3,A10
;	
;	MOVE	A10,A11
;	ADDXY	A9,A11	;A11 IS MODULE Y:X END
;
;	JRUC	WEMODLP
;
;WEMODX
;	MOVE	A11,A0
;	MMFM	SP,A3,A4,A8,A9,A10,A11
;	RETS


*********************** BAK START *******************************
* SCAN A MODULE LIST AND RETURN THE PACKED Y:X STARTING POINT
*PARMS
*A0 - MODULE LIST
*RETURNS
*A0 - PACKED Y:X START OF WAVE
;BAK_STRT
;	MMTM	SP,A3,A4,A8,A9,A11
;
;	CLR	A11
;	MOVE	*A0+,A8,L		;LOAD MODULE PTR
;	JRZ	WSMODX			;END OF THE MODULE TBL
;	MOVE	*A8+,A9,L		;LOAD PACKED Y:X SIZE
;
;	MOVE	*A0+,A3,W		;X START POSITION
;	ZEXT	A3,W
;	CMPI	BLSTSTRT,A3
;	JRNZ	WSNOTLASTSTARTX
;	MOVE	A11,A3		
;	SUBXY	A9,A3
;	JRUC	WSGOTNEWX
;WSNOTLASTSTARTX
;	CMPI	BLSTEND,A3
;	JRNZ	WSGOTNEWX
;	MOVE	A11,A3
;WSGOTNEWX
;	MOVE	*A0+,A4,W		;Y START POSITION
;	ZEXT	A4,W
;	CMPI	BLSTSTRT,A4
;	JRNZ	WSNOTLASTSTARTY
;	MOVE	A11,A4		
;	SUBXY	A9,A4
;	JRUC	WSGOTNEWY
;WSNOTLASTSTARTY
;	CMPI	BLSTEND,A4
;	JRNZ	WSNOTLASTENDY
;	MOVE	A11,A4
;	JRUC	WSGOTNEWY
;WSNOTLASTENDY
;	SLL	16,A4
;WSGOTNEWY
;	MOVY	A4,A3
;	MOVE	A3,A0
;
;WSMODX
;	MMFM	SP,A3,A4,A8,A9,A11
;	RETS


****************************************************************
* Update disp list for main bakgnd
* Deletes all display objects which are not on the screen
* Insures all background blocks on screen are on the disp list
* Input: WORLDTL, SCRNTL, SCRNLR, BAKLST, BAKBITS, BAKMODS
* Trashes scratch

 SUBR	BGND_UD1

	PUSH	a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	PUSH	b2

	move	@WORLDTL,a3,L
	move	a3,a4
	move	@SCRNTL,a0,L
	addxy	a0,a3
	move	@SCRNLR,a0,L
	addxy	a0,a4		

	movi	DISP_PAD,a0	;XY border pad

	subxy	a0,a3		;A3=DISP_TL
	addxy	a0,a4		;A4=DISP_LR
	movi	BAKLST,a8	;A8=*bakgnd list
	callr	bgnd_delnonvis

	move	@BAKMODS,a0,L	;*Module list
	movi	BAKBITS,a7	;Bit table for block being on disp list
	movi	INSBOBJ,b2	;*Insert routine
	callr	bgnd_scanmod

	PULL	b2
	PULL	a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets


#*******************************
* Scan a module list to find out which modules contain blocks
* which need to be checked for addition to the display list.
* A0=*Module list
* A3=DISP_TL
* A4=DISP_LR
* A7=*Bakbits table
* B2=*Insert routine
* Trashes A0-A2,A5,A6,A8-A11,A14,B0-B1

 SUBRP	bgnd_scanmod

	move	a7,a6		;a6 will point to bakbits after mod
	jruc	#next

#lp
	move	*a0+,a9,L	;Y:X start

	move	*a8+,a11,L	;Mod Y:X size
	addxy	a9,a11		;Mod Y:X end

	move	*a8+,a2		;# of blocks
	add	a2,a6		;A6=*Next bakbits

	cmpxy	a3,a11
	jrxlt	#next		;Mod x end < tl x ?
	jrylt	#next		;Mod y end < tl y ?

	cmpxy	a9,a4
	jrxlt	#next		;Mod x start > br x ?
	jrylt	#next		;Mod y start > br y ?

	sll	6,a2		;*64 (each block is 4 words)
	move	*a8+,a1,L	;A1=*block table
	add	a1,a2		;A2=*block table end

	move	*a8+,a5,L	;A5=*hdrs
	move	*a8+,a10,L	;A10=*PAL table
	subxy	a9,a3
	subxy	a9,a4
	callr	bgnd_addmod
	addxy	a9,a3
	addxy	a9,a4

#next	move	a6,a7
	move	*a0+,a8,L	;* module
	jrnz	#lp		;!End?


#x	rets


#*******************************
* This function adds all module blocks in the given range of module
* relative coors to the display list.
* The boundries are included in the group to add.
*
* A1=*Bakgnd block table
* A2=*Bakgnd block table end
* A3=DISP_TL relative to the module start pos
* A4=DISP_LR ^
* A5=*Bakgnd hdr table
* A7=*Bakbits table
* A9=Module start position Y:X
* A10=*Palette table for new block
* B2=*Bakground insert routine primary|secondary
*
* Trashes A1,A8,A14,B0-B1

 SUBRP	bgnd_addmod

	PUSH	a0,a6,a7

	movx	a3,a0		;find 1st universe block with x >= a9
	sext	a0
	subi	WIDEST_BLOCK,a0	;1st x coordinate of a block
	callr	bgnd_get1stx
	jrz	#x		;no blocks with > X ?

	movi	BLOCK_SIZE,a6

	move	a0,a8		;A0=*Block
	sub	a1,a8		;subtract off start of table
	srl	6,a8		;divide by block size (64)
	add	a7,a8		;a8=ptr to bit which indicates block on list
	subk	8,a8		;after inc a8, use movb *a8 to load sign bit
	sub	a6,a0		;subtract block size
	move	a0,a7

#sclp1
	addk	1,a8
	add	a6,a7		;Next block
	cmp	a2,a7
	jrge	#x		;End?

	movb	*a8,a0		;Check bakbit
	jrn	#sclp1		;Already displayed?

	move	*a7(MAP_X),a1
	cmpxy	a3,a1
	JRXGE	#qscanstrt	;Block X >= TL X ? (Do quicker scan)

	move	*a7(MAP_HDR),a14
	sll	32-12,a14	;Bits 0-11 are hdr offset
	srl	32-12-4,a14	;*16
	move	a14,a0		;>*5
	sll	2,a0
	add	a0,a14
	add	a5,a14		;A14=*Img hdr

	move	*a14,a0		;MAP_W
	add	a0,a1
	cmpxy	a3,a1
	JRXLT	#sclp1		;Block X+W < TL X ? (not in range)

	move	*a7(MAP_Y),a1
	sll	16,a1
	cmpxy	a4,a1
	JRYGE	#sclp1       	;Block Y >= BR Y ?

	move	*a14(MAP_H),a0
	sll	16,a0
	add	a0,a1
	cmpxy	a3,a1
	JRYLT	#sclp1		;Block Y+H < TL Y ?

	callr	bgnd_addblk
	jrnc	#sclp1

	jruc	#x		;No more blocks!


* Since blocks are sorted from left to right, we can do a quicker scan
* once block left > display left

#sclp2
	addk	1,a8
	add	a6,a7		;Next block
	cmp	a2,a7
	jrge	#x		;End?

	movb	*a8,a0		;Check bakbit
	jrn	#sclp2		;Already displayed?

#qscanstrt
	move	*a7(MAP_Y),a1
	sll	16,a1
	cmpxy	a4,a1
	JRYGE	#sclp2       	;Block Y >= BR Y ?

	move	*a7(MAP_HDR),a14
	sll	32-12,a14	;Bits 0-11 are hdr offset
	srl	32-12-4,a14	;*16
	move	a14,a0		;>*5
	sll	2,a0
	add	a0,a14
	add	a5,a14		;A14=*Img hdr

	move	*a14(MAP_H),a0
	sll	16,a0
	add	a0,a1
	cmpxy	a3,a1
	JRYLT	#sclp2		;Block Y+H < TL Y ?

	move	*a7(MAP_X),a1
	cmpxy	a4,a1
	JRXGE	#x		;BLOCK X > BR X ?

	callr	bgnd_addblk
	jrnc	#sclp2


#x	PULL	a0,a6,a7
	rets


#*******************************
* Add a block (object) to a list
* A5=*Base of background block hdr
* A7=*Background block
* A8=*Bakbit for obj
* A9=Module start position Y:X
* A10=*Palette table for new block
* B2=*Ins routine
* Trashes A1,A14,B0-B1
* C set if getobj fails

 SUBRP	bgnd_addblk

	PUSH	a0,a2,a3,a4


	calla	GETOBJ
	jrz	#x

	movb	*a8,a14		;set bit in bitmap for block on list
	ori	>80,a14
	movb	a14,*a8

	move	a8,*a0(OPLINK),L ;OPLINK = *Bakbit for obj

	clr	a1
	move	a1,*a0(OID)
	move	a1,*a0(OFLAGS)
	move	a1,*a0(OXVEL),L
	move	a1,*a0(OYVEL),L
	movi	01000100H,a1
	move	a1,*a0(OSCALE),L

	move	*a7(MAP_X),a1,L	;A1=ypos:xpos of block from mod base
	addxy	a9,a1		;+module base position
	move	a1,*a0(OXPOS)
	srl	16,a1
	move	a1,*a0(OYPOS)
	move	*a7,a4		;A4=map_z,8:map_flags,4:map_pal,4
	move	a4,a3
	zext	a3
	srl	8,a3
	move	a3,*a0(OZPOS)

	move	*a7(MAP_HDR),a1
	movx	a1,a14
	sll	32-16,a14
	srl	32-4,a14
	sll	4+5,a14		;Bits 12-15 are bits 4-7 of pal index *32
	
	sll	32-12,a1	;Bits 0-11 are hdr offset
	srl	32-12-4,a1	;*16
	move	a1,a3		;>*5
	sll	2,a1
	add	a3,a1

	add	a5,a1		;A1=*Img hdr

	move	a4,a3		;A4=Map_z,8: map_flags,4: map_pal,4
	sll	32-4,a4		;Last four bits for *pal
	srl	32-4-5,a4	;*32
	add	a14,a4
	add	a10,a4		;+Pal_t base
	move	a0,a2		;Save A0
	move	*a4,a0,L	;Get *PAL
	move	a1,a4
	.if	NMBPAL
	calla	pal_getb
	.else
	calla	pal_getf
	.endif
	jrnz	bsetpal		;No PAL?
	clr	a0
bsetpal
	zext	a0
	move	a0,*a2(OPAL),L
	move	a2,a0			;Restore A0
	move	a4,a1			;^ A1
	move	a1,*a0(OIMG),L		;A1=Data block pointer

	move	*a1(MAP_CTRL),a4	;Get DMA ctrl
	ori	>8002,a4		;A4=flags (>8000 dma go, 2)
	srl	4,a3			;remove palette bits
	sll	32-2,a3
	jrc	#trans			;Transparent?
	addk	1,a4
#trans	srl	26,a3			;Line up flip bits
	or	a3,a4

	move	*a1+,a2,L		;ISIZE
	move	*a1,a3,L		;Get SAG
	zext	a4			;Zero offset in A4

	move	a0,a1
	addi	OSIZE+32,a1
	mmtm	a1,a2,a3,a4		;Stuff OSIZE,OSAG,OFFSET,OCTRL

	move	*a0(OZPOS),a4
	subi	80,a4			;> 80?
	jrlt	#normz			;Normal?

;	sll	5,a4			;*32
;	addi	z_t,a4
;	move	*a4,a4,L
;	call	a4			;Call special code

	move	a4,*a0(OZPOS)

	subi	20,a4			;> 100?
	jrgt	#no_rel
	move	*a0(OFLAGS),a4
	ori	M_SCRNREL,a4
	move	a4,*a0(OFLAGS)
	move	*a0(OYPOS),a4
	andi	0ffh,a4
	move	a4,*a0(OYPOS)
#no_rel

	clr	a4
	move	a4,*a0(OXVEL),L
	move	a4,*a0(OYVEL),L

	calla	INSOBJ			;Put on objlst
	clrc
	PULL	a0,a2,a3,a4
	rets

#normz	call	b2			;Call insert routine
	clrc
	PULL	a0,a2,a3,a4
	rets

#x	setc				;failure to get object
	PULL	a0,a2,a3,a4
	rets


********************************
* These functions are called when a block has the appropriate Z
* A0=*Obj
* You can trash A1-A4,A14,B0,B1

z_t
;80
	.long	bak_null,bak_null,bak_null,bak_null,bak_null
	.long	bak_null,bak_null,bak_null,bak_null,bak_null
;90
	.long	bak_null,bak_null,bak_null,bak_null,bak_null
	.long	bak_null,bak_null,bak_null,bak_null,bak_null
	.long	bak_null,bak_null,bak_null,bak_null,bak_null
	.long	bak_null,bak_null,bak_null,bak_null,bak_null
	.long	bak_null,bak_null,bak_null,bak_null,bak_null
	.long	bak_null,bak_null,bak_null,bak_null,bak_null
	.long	bak_null,bak_null


bak_null

	rets



#*******************************
* This function deletes all objs outside the given range
* of coors from the display list.
* The boundries are not included in the group to delete.
* A3=DISP_TL
* A4=DISP_LR
* A8=*Bakgnd list
* Trashes A0,A6-A9

 SUBR	bgnd_delnonvis

#lp	move	a8,a9			;ptr to prev in a9
	move	*a8,a8,L		;ptr to next in a8
	jrz	#x			;End?

#lp2	MOVE	*A8(OXPOS),A7
	CMPXY	A7,A4
	JRXLT	DEL_IT			;JUMP IF BR X < BLOCK X

	MOVE	*A8(OYPOS),A0
	SLL	16,A0
	CMPXY	A0,A4
	JRYLT	DEL_IT			;JUMP IF BR Y < BLOCK Y

	MOVE	*A8(OIMG),A1,L
	MOVE	*A1,A6			;A6 BLOCK WIDTH
	ADD	A6,A7
	CMPXY	A3,A7
	JRXLT	DEL_IT			;JUMP IF TL X > BLOCK X+W

	MOVE	*A1(MAP_H),A7		;A7 BLOCK HEIGHT
	SLL	16,A7
	ADD	A7,A0
	CMPXY	A3,A0
	JRYGE	#lp			;JUMP IF TL Y <= BLOCK Y+H

DEL_IT
	move	*a8(OPLINK),a0,L	;>Clr the on display list bit
	movb	*a0,a7
	sll	32-7,a7
	srl	32-7,a7
	movb	a7,*a0

	move	*a8,*a9,L		;Unlink
	move	@OFREE,a0,L
	move	a0,*a8,L
	move	a8,@OFREE,L		;Put on free list
	move	*a9,a8,L		;A8=*Next obj
	jrnz	#lp2			;More?

#x	rets






	.end

