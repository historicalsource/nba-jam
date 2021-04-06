*************************************************************
*
* Owner:	THOMPSON
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		7/17/90
*
* Modified:		Shawn Liptak, 1/27/92	-Started basketball
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 11/18/92 23:00
**************************************************************
	.file	"bb3.asm"
	.title	"Basketball game program"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"world.equ"		;Court-world defs
	.include	"game.equ"
	.include	"audit.equ"
	.include	"macros.hdr"		;Macros

	.include	"crowd.tbl"
	.include	"courtflr.tbl"

	.include	"court.tbl"
	.include	"outdoor.tbl"
	.include	"outdoor.glo"

	.include	"imgtbl.glo"
	.include	"hoop.glo"

	.asg		0,SEQT
	.include	"plyr.equ"


	.def	COURT
	.def	OUTDOOR


	.ref	pup_court,pup_aba,HALT
	.ref	gndx
	.ref	team1,team2
	.ref	oteam1
	.ref	crt_colors
	.ref	bkcrt_colors
;;	.ref	refcrt_colors
	.ref	gndpos_t,pal_getf
	.ref	team_city_tbl,teampal_t

	.ref	P1CTRL
	.ref	P2CTRL
	.ref	P3CTRL
	.ref	P4CTRL
	.ref	RNDRNG0
;;	.ref	crowd_aniflag	
;;	.ref	bench_aniflag	

	.ref	pal_set,pal_find,pal_clean


	.bss	tm1pal_t,(1+128)*16	;Team 1 bench palette
	.bss	tm2pal_t,(1+128)*16	;Team 2 bench palette
	.bss	coachpal_t,(1+128)*16	;Coach palette

	BSSX	rimlf,32	;rim/net left front img pntr for animation
	.bss	rimlb,32	;rim/net left back
	BSSX	rimrf,32	;rim/net rgt front
	.bss	rimrb,32	;rim/net rgt back

	.bss	bnchl_p,32	;plyr bench, lft
	.bss	bnchr_p,32	;plyr bench, rgt
	.bss	coachl_p,32	;coachs, lft
	.bss	coachr_p,32	;coachs, rgt

	.bss	cr1st1_p,32	;1st row, far lft
	.bss	cr1st2_p,32	;1st row, lft
;	.bss	cr1st3_p,32	;1st row, lft ctr
;	.bss	cr1st4_p,32	;1st row, ctr lft
;	.bss	cr1st5_p,32	;1st row, ctr rgt
;	.bss	cr1st6_p,32	;1st row, rgt ctr
	.bss	cr1st7_p,32	;1st row, rgt
	.bss	cr1st8_p,32	;1st row, far rgt

	.bss	cr2nd1_p,32	;2nd row, far lft
	.bss	cr2nd2_p,32	;2nd row, lft
	.bss	cr2nd3_p,32	;2nd row, lft ctr
;	.bss	cr2nd4_p,32	;2nd row, ctr lft
;	.bss	cr2nd5_p,32	;2nd row, ctr rgt
	.bss	cr2nd6_p,32	;2nd row, rgt ctr
	.bss	cr2nd7_p,32	;2nd row, rgt
	.bss	cr2nd8_p,32	;2nd row, far rgt

	.bss	cr3rd1_p,32	;3rd row, far lft
	.bss	cr3rd2_p,32	;3rd row, lft
	.bss	cr3rd3_p,32	;3rd row, lft ctr
;	.bss	cr3rd4_p,32	;3rd row, ctr lft
;	.bss	cr3rd5_p,32	;3rd row, ctr rgt
	.bss	cr3rd6_p,32	;3rd row, rgt ctr
	.bss	cr3rd7_p,32	;3rd row, rgt
	.bss	cr3rd8_p,32	;3rd row, far rgt

	BSSX	crbox1_p,32*5	;sky box, all

;	.bss	bnch_ram_plist,32*(8+1)		;bench ani *proc
	.bss	crwd_ram_plist,32*(24+1)	;crowd ani *proc

	.bss	ad1_ptr,32   
	.bss	ad1ref_ptr,32
	.bss	ad2_ptr,32   
	.bss	ad2ref_ptr,32

	BSSX	crt_pal		,16	;pal_getf result for court

	.bss	city1obj,32	;outdoor crt city obj
	.bss	city2obj,32	;outdoor crt city obj
	.bss	city3obj,32	;outdoor crt city obj

	.bss	moonobj,32	;outdoor crt moon obj
	.bss	stormobj,32	;outdoor crt MK storm obj


#*******************************
* Initialize the game objs
* Trashes scratch, A0-A11

	BSSX	otdscroll_p,32

 SUBR	game_initobjs


	movi	#init_t,a11		;>Setup crowd, hoops, side crowd
	move	@pup_court,a0
	jrz	#next
	CREATE0	otd_scroller
	move	a0,@otdscroll_p,L
	movi	#init_otd_t,a11		;>Setup outdoor court objs
	jruc	#next
#lp
	cmpi	4001,a0			;>Start process
	jrne	#svptr
	clr	a1
	move	*a11+,a7,L		;*Code
	calla	GETPRC			;Pass last obj in A8
	jruc	#next

#svptr	cmpi	4002,a0			;>Save variable
	jrne	#obj
	move	*a11+,a1,L		;*Var
	move	a8,*a1,L
	jruc	#next

#obj	move	*a11+,a1		;Y
	sll	16,a0
	sll	16,a1
	move	*a11+,a3		;Z
	move	*a11+,a9		;Z offset
	move	*a11+,a4
	ori	DMAWNZ|M_NOCOLL,a4
	move	*a11+,a2,L
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	move	a9,*a8(OMISC)		;save Z offset
;
;Old code here basically eliminates any alignment between
; related objs by using anim pts, due in large part to the
; attempt of using the mid X of the image as the "anim pt";
; 3DQ X projections are done around THIS pt as opposed to
; any common coordinate
;
;	move	*a2,a0			;get width & make it an INT:FRC
;	sll	15,a0			; /2 for obj mid X
;	move	a0,*a8(OXANI),L		;Save "anipt" (offset to mid X)
;
	move	*a8(OIMG),a1,L		;get ani pts while we still have
	move	*a8(OSIZE),a2,L		; OFLAGS handy
	calla	GANIOF
	move	a6,*a8(OXANI),L		;save for debug ref only

	btst	B_3DQ,a4
	jrz	#next
					;>Convert 3D to 3DQ
	add	a9,a3			;add Z offset to Z
	move	a3,a5			;save for later X2Z conv
	subi	GZBASE,a3
	move	a3,a4
;
;Old code here ends up having the object look at gndpos_t
; 5 to 6 lines above (screen-wise) the object's actual Y
;	sll	8,a3			;shift for quotient int resolution
;	movi	725,a1			;should be 683 to match the 3/8's Z-
;	divu	a1,a3			; to-Y rule (256/(3/8))
;
	sra	1,a4			;Z/2
	sra	3,a3			;Z/8
	sub	a3,a4			;=Z/2.667
	move	a4,a3

	sll	4,a3			;*16
	addi	gndpos_t,a3
	move	a3,*a8(ODATA_p),L

	addi	GND_Y,a4
	move	*a8(OYPOS),a0
	add	a0,a4
	move	a4,*a8(OYPOS)

	move	*a8(OXVAL),a3,L
	subi	[WRLDMID,0],a3
	add	a6,a3

	PRJX2Z	a3,a5,0

	addi	200,a3
	sra	16,a6
	sub	a6,a3			;-X anipt
	move	a3,*a8(OXPOS)

#next	move	*a11+,a0		;X
	cmpi	4000,a0
	jrne	#lp			;!End?

	move	@team1,a0
	move	a0,@oteam1
	callr	random_ads

	calla	pal_clean

	move	@crt_colors,a0,L
	calla	pal_getf
	move	a0,@crt_pal
	rets


;----------------------------------------------------------------------------
; .word	X, Y, Z, Z-offset, DMA
; .long	IMG_p

#init_t
	.asg	200,SXO				;Screen center Xoffs
	.asg	M_3DQ|M_NOSCALE,F
	.asg	M_3DQ|M_NOSCALE|M_FLIPH,FF

;--------------------
; hoops

	.asg	HOOPBASE_X,X
;FIX!!!  Alignment should be done with img ani pts, not offsets here!
	.asg	HOOPBASE_Y-4,Y
	.asg	CZMID,Z

;Regular indoor hoop setup - left side

	.word	SXO-X-2,Y,Z-18, 18,F		;lft hoop
	.long	hooptop
	.word	SXO-X-2,Y,Z,     0,F
	.long	hoopbot
	.word	SXO-X-2,Y,Z-17, 17,F
	.long	back1
	WL	4001,backboard_ani

	.word	SXO-X-2,Y,Z-10, 10,F
	.long	RIM0_B_00		;rim1b
	WL	4002,rimlb
	.word	SXO-X-2,Y,Z+10,-10,F
	.long	RIM0_F_00		;rim1f
	WL	4002,rimlf

;;TEMP!!! begin	left hoop lying on the floor
;;	.word	SXO-X,Y-HOOPY,Z,     0,F
;;	.long	rimbase
;	.word	SXO-X,Y-HOOPY,Z-10, 10,F
;	.long	rim1b
;	.word	SXO-X,Y-HOOPY,Z+10,-10,F
;	.long	rim1f
;;TEMP!!! end

;Regular indoor hoop setup - right side

	.word	SXO+X,Y,Z-18, 18,FF		;rgt hoop
	.long	hooptop
	.word	SXO+X,Y,Z,     0,FF
	.long	hoopbot
	.word	SXO+X,Y,Z-17, 17,FF
	.long	back1
	WL	4001,backboard_svrptr

	.word	SXO+X,Y,Z-10, 10,FF
	.long	RIM0_B_00		;rim1b
	WL	4002,rimrb
	.word	SXO+X,Y,Z+10,-10,FF
	.long	RIM0_F_00		;rim1f
	WL	4002,rimrf

;--------------------
; crt refs

	.asg	0,Y			;Y to realign after ZOFF
	.asg	CZMIN-90,Z		;Z priority back from crt top
	.asg	90-(0*Y2Z),ZOFF		;Z off for gndpos_t element to use

	.word	SXO-308,Y,Z+96,ZOFF,F		;crt light refs
	.long	ref01n
	WL	4001,set_crt_colors
	.word	SXO-308,Y,Z+202,ZOFF,F
	.long	ref02n
	WL	4001,set_crt_colors
	.word	SXO-124,Y,Z+128,ZOFF,F
	.long	ref03n
	WL	4001,set_crt_colors
	.word	SXO-124,Y,Z+220,ZOFF,F
	.long	ref04n
	WL	4001,set_crt_colors
	.word	SXO+104, Y,Z+124,ZOFF,F
	.long	ref05n
	WL	4001,set_crt_colors
	.word	SXO+104, Y,Z+224,ZOFF,F
	.long	ref06n
	WL	4001,set_crt_colors
	.word	SXO+308,Y,Z+104,ZOFF,F
	.long	ref07n
	WL	4001,set_crt_colors
	.word	SXO+308,Y,Z+204,ZOFF,F
	.long	ref08n
	WL	4001,set_crt_colors

;--------------------
; floors & stairs

;	.asg	7,Y			;Y to realign after ZOFF
;	.asg	CZMIN-300,Z		;Z priority back from crt top
;	.asg	300-(7*Y2Z),ZOFF	;Z off for gndpos_t element to use
;
;	.word	SXO-359,Y,Z,ZOFF,FF		;flr above main crt
;	.long	bk_flr
;	WL	4001,set_bkcrt_colors
;	.word	SXO-146,Y,Z,ZOFF,FF
;	.long	bk_flr
;	WL	4001,set_bkcrt_colors
;	.word	SXO+146,Y,Z,ZOFF,F
;	.long	bk_flr
;	WL	4001,set_bkcrt_colors
;	.word	SXO+359,Y,Z,ZOFF,F
;	.long	bk_flr
;	WL	4001,set_bkcrt_colors

;	.asg	-3,Y			;Y to realign after ZOFF
;	.asg	205,Z			;Z priority back from crt top
;	.asg	CZMIN-Z-(28*Y2Z),ZOFF	;Z off for gndpos_t element to use
;
;	.word	SXO-367,Y,Z,ZOFF,FF		;stairs between crowd rows
;	.long	STAIRS
;	.word	SXO-124,Y,Z,ZOFF,FF		;stairs between crowd rows
;	.long	STAIRS
;	.word	SXO+124,Y,Z,ZOFF,FF		;stairs between crowd rows
;	.long	STAIRS
;	.word	SXO+367,Y,Z,ZOFF,FF		;stairs between crowd rows
;	.long	STAIRS

	.asg	3,Y			;Y to realign after ZOFF
	.asg	205,Z			;Z priority back from crt top
	.asg	CZMIN-Z-(34*Y2Z),ZOFF	;Z off for gndpos_t element to use

	.word	SXO-367,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS01
	.word	SXO-124,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS01
	.word	SXO+124,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS01
	.word	SXO+367,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS01

	.asg	-3,Y			;Y to realign after ZOFF
	.asg	CZMIN-Z-(28*Y2Z),ZOFF	;Z off for gndpos_t element to use

	.word	SXO-367,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS02
	.word	SXO-124,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS02
	.word	SXO+124,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS02
	.word	SXO+367,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS02

	.asg	-11,Y			;Y to realign after ZOFF
	.asg	CZMIN-Z-(20*Y2Z),ZOFF	;Z off for gndpos_t element to use

	.word	SXO-367,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS03
	.word	SXO-124,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS03
	.word	SXO+124,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS03
	.word	SXO+367,Y,Z,ZOFF,FF		;stairs between crowd rows
	.long	STAIRS03

;--------------------
; tables

	.asg	7,Y			;Y to realign after ZOFF
	.asg	CZMIN-300,Z		;Z priority back from crt top
	.asg	300-(7*Y2Z),ZOFF	;Z off for gndpos_t element to use

;	.word	SXO+1,Y,Z,ZOFF,F		;ad refs
;	.long	ad01_ref_l
;	.word	SXO+1,Y,Z,ZOFF,F
;	.long	ad01_ref_r

	.word	SXO+1,Y,Z,ZOFF,F		;ad refs
	.long	ad01_ref_nl
	.word	SXO+1,Y,Z,ZOFF,F
	.long	ad01_ref_nr

	.asg	CZMIN-20,Z		;Z priority back from crt top
	.asg	20-(7*Y2Z),ZOFF		;Z off for gndpos_t element to use

;	.word	SXO,Y,Z,ZOFF,F			;midcrt table refs
;	.long	flr_ref_l
;	WL	4001,set_bkcrt_colors
;	.word	SXO,Y,Z,ZOFF,F
;	.long	flr_ref_r
;	WL	4001,set_bkcrt_colors

;	.word	SXO+1,Y,Z,ZOFF,F		;midcrt table
;	.long	tabltop_l
;	.word	SXO+1,Y,Z,ZOFF,F
;	.long	tabltop_r

;	.word	SXO+1,Y,Z,ZOFF,F		;ads
;	.long	ad01_l
;	.word	SXO+1,Y,Z,ZOFF,F
;	.long	ad01_r

	.word	SXO+1,Y,Z,ZOFF,F		;midcrt table
	.long	tabletop

	.word	SXO+1,Y,Z,ZOFF,F		;ads
	.long	ad01_nl
	.word	SXO+1,Y,Z,ZOFF,F
	.long	ad01_nr

;--------------------
; plyr benchs/coachs

	.asg	2,Y			;Y to realign after ZOFF
;	.asg	-400,Y
	.asg	CZMIN-30,Z		;Z priority back from crt top
	.asg	30-(9*Y2Z),ZOFF		;Z off for gndpos_t element to use

	.word	-320,Y,Z,ZOFF,F
	.long	BNCHPL01
	WL	4002,bnchl_p
	WL	4001,set_tm1_colors
	.word	528,Y,Z,ZOFF,F
	.long	BNCHPL01
	WL	4002,bnchr_p
	WL	4001,set_tm2_colors


	.word	-116,Y,Z,ZOFF,F
	.long	COACH01
	WL	4002,coachl_p
	WL	4001,set_coach_colors
	.word	516,Y,Z,ZOFF,FF
	.long	COACH01
	WL	4002,coachr_p
	WL	4001,set_coach_colors


	.word	-6,Y,Z,ZOFF,F
	.long	bk_flr
	WL	4001,set_bkcrt_colors
	.word	346,Y,Z,ZOFF,F
	.long	bk_flr
	WL	4001,set_bkcrt_colors


;--------------------
; crowd - 1st row

	.asg	-9,Y			;Y to realign after ZOFF
;	.asg	-400,Y
	.asg	250,Z			;Z priority back from crt top
	.asg	CZMIN-Z-(20*Y2Z),ZOFF	;Z off for gndpos_t element to use

	.word	-298,Y,Z,ZOFF,F
	.long	CR2FST01
	WL	4002,cr1st1_p


	.word	-155,Y,Z,ZOFF,F
;	.word	-153,Y,Z,ZOFF,F
	.long	CR0FST01n
	WL	4002,cr1st2_p

;	.word	-153,Y,Z,ZOFF,F
;	.long	CR4FST01
;	WL	4002,cr1st2_p
;	.word	-49,Y,Z,ZOFF,F
;	.long	CR1FST01
;	WL	4002,cr1st3_p


	.word	88,Y,Z,ZOFF,F
	.long	CR2FST01
;	WL	4002,cr1st4_p
	.word	318,Y,Z,ZOFF,FF
	.long	CR3FST01
;	WL	4002,cr1st5_p


;	.word	336,Y,Z,ZOFF,F
;	.long	CR4FST01
;	WL	4002,cr1st6_p
;	.word	440,Y,Z,ZOFF,F
;	.long	CR1FST01
;	WL	4002,cr1st7_p

	.word	336,Y,Z,ZOFF,F
	.long	CR0FST01n
	WL	4002,cr1st7_p


	.word	690,Y,Z,ZOFF,FF
	.long	CR3FST01
	WL	4002,cr1st8_p

;--------------------
; crowd - 2nd row

	.asg	-11,Y			;Y to realign after ZOFF
;	.asg	-400,Y
	.asg	240,Z			;Z priority back from crt top
	.asg	CZMIN-Z-(28*Y2Z),ZOFF	;Z off for gndpos_t element to use

	.word	-298,Y,Z,ZOFF,F
	.long	CR4SEC01
	WL	4002,cr2nd1_p


	.word	-156,Y,Z,ZOFF,F
	.long	CR2SEC01
	WL	4002,cr2nd2_p
	.word	-44,Y,Z,ZOFF,F
	.long	CR1SEC01
	WL	4002,cr2nd3_p


	.word	89,Y,Z,ZOFF,F
	.long	CR5SEC01
;	WL	4002,cr2nd4_p
	.word	193,Y,Z,ZOFF,F
	.long	CR4SEC01
;	WL	4002,cr2nd5_p


	.word	336,Y,Z,ZOFF,F
	.long	CR2SEC01
	WL	4002,cr2nd6_p
	.word	450,Y,Z,ZOFF,F
	.long	CR3SEC01
	WL	4002,cr2nd7_p


	.word	578,Y,Z,ZOFF,F
	.long	CR5SEC01
	WL	4002,cr2nd8_p

;--------------------
; crowd - 3rd row

	.asg	-21,Y			;Y to realign after ZOFF
;	.asg	-400,Y
	.asg	230,Z			;Z priority back from crt top
	.asg	CZMIN-Z-(34*Y2Z),ZOFF	;Z off for gndpos_t element to use

	.word	-310,Y,Z,ZOFF,F
	.long	CR1THD01
	WL	4002,cr3rd1_p


	.word	-160,Y,Z,ZOFF,F
	.long	CR4THD01
	WL	4002,cr3rd2_p
	.word	-52,Y,Z,ZOFF,F
	.long	CR2THD01
	WL	4002,cr3rd3_p


	.word	84,Y,Z,ZOFF,F
	.long	CR3THD01
;	WL	4002,cr3rd4_p
	.word	196,Y,Z,ZOFF,F
	.long	CR4THD01
;	WL	4002,cr3rd5_p


	.word	328,Y,Z,ZOFF,F
	.long	CR1THD01
	WL	4002,cr3rd6_p
	.word	442,Y,Z,ZOFF,F
	.long	CR3THD01
	WL	4002,cr3rd7_p


	.word	576,Y,Z,ZOFF,F
	.long	CR2THD01
	WL	4002,cr3rd8_p

;--------------------
; crowd - camera people

	.asg	0,Y			;Y to realign after ZOFF
	.asg	CZMIN+(42*Y2Z),Z	;Z priority back from crt top
	.asg	0,ZOFF			;Z off for gndpos_t element to use

	.word	SXO-500,Y,Z,ZOFF,FF
	.long	SIDECAMS
	.word	SXO+500,Y,Z,ZOFF,F
	.long	SIDECAMS

;--------------------
; crowd - skybox/upper deck

	.asg	-61,Y			;Y to realign after ZOFF
	.asg	220,Z			;Z priority back from crt top
	.asg	CZMIN-Z-(30*Y2Z),ZOFF	;Z off for gndpos_t element to use

	.word	SXO-438,Y,Z,ZOFF,FF
	.long	TOPCRV
	WL	4002,crbox1_p

	.word	SXO-230,Y,Z,ZOFF,F
	.long	TOPCHK
	WL	4002,crbox1_p+32

	.word	SXO,Y,Z,ZOFF,F
	.long	TOPCHK
	WL	4002,crbox1_p+64

	.word	SXO+231,Y,Z,ZOFF,F
	.long	TOPCHK
	WL	4002,crbox1_p+96

	.word	SXO+439,Y,Z,ZOFF,F
	.long	TOPCRV
	WL	4002,crbox1_p+128

;--------------------
; big crowd backdrop

	.asg	18,Y			;Y to realign after ZOFF
	.asg	210,Z			;Z priority back from crt top

	.word	SXO-526,Y+60,Z,0,M_FLIPH
	.long	SIDECHK

	.word	SXO-249-125-100,Y,Z,0,M_FLIPH
	.long	BOTCRV

	.word	SXO-249,Y,Z,0,0
	.long	BOTCHK

	.word	SXO,Y,Z,0,0
	.long	BOTCHK

	.word	SXO+249,Y,Z,0,0
	.long	BOTCHK

	.word	SXO+249+125+100,Y,Z,0,0
	.long	BOTCRV

	.word	SXO+526,Y+60,Z,0,0
	.long	SIDECHK


	.word	4000			;End


;----------------------------------------------------------------------------
; .word	X, Y, Z, Z-offset, DMA
; .long	IMG_p

#init_otd_t

;--------------------
; hoops

	.asg	HOOPBASE_X,X
;FIX!!!  Alignment should be done with img ani pts, not offsets here!
	.asg	HOOPBASE_Y-4,Y
	.asg	CZMID,Z

;Outdoor hoop setup - left side

	.word	SXO-X-4,Y,Z,     0,F
	.long	nhoopbot
	.word	SXO-X-4,Y,Z-17, 17,F
	.long	nback1
	WL	4001,backboard_ani

	.word	SXO-X-2,Y,Z-10, 10,F
	.long	CHAN1B_01
	WL	4002,rimlb
	.word	SXO-X-2,Y,Z+10,-10,F
	.long	CHAN1F_01
	WL	4002,rimlf

;Outdoor hoop setup - right side

	.word	SXO+X+2,Y,Z,     0,FF
	.long	nhoopbot
	.word	SXO+X+2,Y,Z-17, 17,FF
	.long	nback1
	WL	4001,backboard_svrptr

	.word	SXO+X,Y,Z-10, 10,FF
	.long	CHAN1B_01
	WL	4002,rimrb
	.word	SXO+X,Y,Z+10,-10,FF
	.long	CHAN1F_01
	WL	4002,rimrf

;--------------------
; backcourt roof edge

	.asg	-14,Y			;Y to realign after ZOFF
;	.asg	-400,Y
	.asg	CZMIN-40,Z		;Z priority back from crt top
	.asg	40-(2*Y2Z),ZOFF		;Z off for gndpos_t element to use


	.word	SXO-493,Y,Z,ZOFF,F
	.long	BKg1
	.word	SXO-326,Y,Z,ZOFF,F
	.long	BKg2
	.word	SXO,Y,Z,ZOFF,FF
	.long	BKg2
	.word	SXO,Y,Z,ZOFF,F
	.long	BKg2
	.word	SXO+326,Y,Z,ZOFF,FF
	.long	BKg2
	.word	SXO+493,Y,Z,ZOFF,FF
	.long	BKg1

;--------------------
; wall

	.asg	-16,Y			;Y to realign after ZOFF
;	.asg	-400,Y
	.asg	CZMIN-40,Z		;Z priority back from crt top
	.asg	40-(16*Y2Z),ZOFF	;Z off for gndpos_t element to use


	.word	SXO-496,Y,Z,ZOFF,F
	.long	bkwall
	.word	SXO-330,Y,Z,ZOFF,F
	.long	bkwall
	.word	SXO-165,Y,Z,ZOFF,F
	.long	bkwall
	.word	SXO,Y,Z,ZOFF,F
	.long	bkwall
	.word	SXO+166,Y,Z,ZOFF,F
	.long	bkwall
	.word	SXO+331,Y,Z,ZOFF,F
	.long	bkwall

;--------------------
; street lights

	.asg	-130,Y			;Y to realign after ZOFF
;	.asg	-400,Y
	.asg	220,Z			;Z priority back from crt top
	.asg	CZMIN-Z-(39*Y2Z),ZOFF	;Z off for gndpos_t element to use


	.word	SXO-468,Y,Z,ZOFF,F
	.long	lamp1

	.word	SXO-154-80,Y,Z,ZOFF,F
	.long	lamp2
	.word	SXO+150-80,Y,Z,ZOFF,F
	.long	lamp2

	.word	SXO+464,Y,Z,ZOFF,FF
	.long	lamp1


;--------------------
; side buildings

	.asg	-33,Y			;Y to realign after ZOFF
;	.asg	-400,Y
	.asg	CZMIN-39,Z		;Z priority back from crt top
	.asg	39-(16*Y2Z),ZOFF	;Z off for gndpos_t element to use

	.word	SXO-544,Y,Z,ZOFF,F
	.long	sidebot
	.word	SXO+540,Y,Z,ZOFF,FF
	.long	sidebot


	.asg	290,Z			;Z priority back from crt top
	.asg	CZMIN-Z-(16*Y2Z),ZOFF	;Z off for gndpos_t element to use

	.word	SXO-544,Y,Z,ZOFF,F
	.long	sidetop
	.word	SXO+540,Y,Z,ZOFF,FF
	.long	sidetop

;--------------------
; city backdrop

	.asg	-92,Y			;Y to realign after ZOFF
	.asg	210,Z			;Z priority back from crt top

	.word	SXO-300,Y,Z,0,0
	.long	city1
	WL	4002,city1obj
	.word	SXO-100,Y,Z,0,0
	.long	city2
	WL	4002,city2obj
	.word	SXO+100,Y,Z,0,0
	.long	city3
	WL	4002,city3obj

	.word	SXO-28,-140,Z+1,0,0
	.long	moon
	WL	4002,moonobj

	.word	SXO-28+200-74h+8,-140,Z+1,0,0
	.long	STORM01
	WL	4002,stormobj


	.word	4000			;End


;--------------------

 SUBRP	set_crt_colors

	SLEEPK	3
	move	@crt_colors,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)
	DIE

 SUBRP	set_bkcrt_colors

	SLEEPK	3
	move	@bkcrt_colors,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)
	DIE

 SUBRP	set_coach_colors

	SLEEPK	3

	move	*a8(OIMG),a1,L
	move	*a1(ICMAP),a1,L
	movi	coachpal_t,a2
	move	a2,a3

	move	*a1,a0			;Copy coach palette cnt & palette
	addk	1,a0
#bcp1	move	*a1+,*a2+
	dsjs	a0,#bcp1

	move	@bkcrt_colors,a1,L
	move	*a1+,a0
	move	a0,a14
	sll	4,a14
	sub	a14,a2
#bcp2	move	*a1+,*a2+
	dsjs	a0,#bcp2

	move	a3,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
	DIE

;; SUBRP	set_refcrt_colors
;;
;;	SLEEPK	3
;;	move	@refcrt_colors,a0,L
;;	calla	pal_getf
;;	move	a0,*a8(OPAL)
;;	DIE

 SUBRP	set_tm1_colors

	move	@team1,a3
	move	@team2,a4
	movi	tm1pal_t,a2
	jruc	#set_tm

 SUBRP	set_tm2_colors

	move	@team2,a3
	move	@team1,a4
	movi	tm2pal_t,a2

#set_tm
	move	a3,a6
	sll	5,a6
	addi	team_city_tbl,a6
	move	*a6,a6,L
	move	a6,a7

	sll	3,a3
	sll	3,a4
	addi	teampal_t,a3
	addi	teampal_t,a4
	movb	*a3,a3
	jrn	#keepc			;I always keep? yes if neg
	movb	*a4,a4
	move	a4,a14
	sll	32-4,a3
	sll	32-4,a14
	cmp	a3,a14
	jrne	#keepc			;Different colors?
	move	a4,a4
	jrn	#altc			;Other team always keeps?
	cmpi	tm2pal_t,a2
	jrz	#keepc			;2nd team?
#altc	addk	32,a6			;use alternates
#keepc

;----------
; Build bench palette

	move	a2,a3
	move	*a8(OIMG),a1,L
	move	*a1(ICMAP),a1,L

	move	*a1+,a0			;Copy bench palette
	addk	16,a3
#bbp1	move	*a1+,*a3+
	dsjs	a0,#bbp1

	move	a2,a3			;Save *pal
	movi	128,a0
	move	a0,*a2+			;Set # colors

	move	*a7(PAT_PALF_p),a1,L	;Skip flesh & copy court floor
	move	*a1+,a14
	move	@bkcrt_colors,a1,L
	move	*a1+,a0
	.if	DEBUG
	cmpi	16,a0
	jrnz	#lck0
	cmpi	53,a14
	jrz	#nolck0
#lck0
	LOCKUP
#nolck0
	.endif
	sub	a0,a14
	sll	4,a14
	add	a14,a2
#bbp1a	move	*a1+,*a2+
	dsjs	a0,#bbp1a

	move	*a6(PAT_PALT_p),a1,L	;Copy trim
	move	*a1+,a0
	.if	DEBUG
	cmpi	17,a0
	jrz	#nolck1
	LOCKUP
#nolck1
	.endif
	addk	16,a1
	subk	1,a0 
#bbp2	move	*a1+,*a2+
	dsjs	a0,#bbp2

	move	*a6(PAT_PALU_p),a1,L	;Copy uniform
	move	*a1+,a0
	.if	DEBUG
	cmpi	25,a0
	jrz	#nolck2
	LOCKUP
#nolck2
	.endif
	addk	16,a1
	subk	1,a0 
#bbp3	move	*a1+,*a2+
	dsjs	a0,#bbp3

	addi	13*16,a2		;Skip shoes

	move	*a6(PAT_PALSW_p),a1,L	;Copy trim
	move	*a1+,a0
	.if	DEBUG
	cmpi	12,a0
	jrz	#nolck3
	LOCKUP
#nolck3
	.endif
	addk	16,a1
	subk	1,a0
#bbp4	move	*a1+,*a2+
	dsjs	a0,#bbp4

	move	*a6(PAT_PALVP_p),a1,L	;Copy trim
	move	*a1+,a0
	.if	DEBUG
	cmpi	12,a0
	jrz	#nolck4
	LOCKUP
#nolck4
	.endif
	addk	16,a1
	subk	1,a0
#bbp5	move	*a1+,*a2+
	dsjs	a0,#bbp5

	move	a3,a0
	calla	pal_getf
	move	a0,*a8(OPAL)
	DIE


#*******************************
* Outdoor court obj scroller
*

 SUBRP	otd_scroller

	CREATE0	blink_lights

	move	@city1obj,a9,L
	move	@city2obj,a10,L
	move	@city3obj,a11,L
	move	@moonobj,a8,L
	move	@stormobj,a0,L
	move	*a0(OXPOS),*a13(PDATA+96)


;MJT Start
	move	@P1CTRL,a0
	cmpi	JOY_UP_RIGHT,a0
	jrz	#ok
	move	@P2CTRL,a0
	cmpi	JOY_UP_RIGHT,a0
	jrz	#ok
	move	@P3CTRL,a0
	cmpi	JOY_UP_RIGHT,a0
	jrz	#ok
	move	@P4CTRL,a0
	cmpi	JOY_UP_RIGHT,a0
	jrz	#ok


;	movi	100,a0
;	calla	RNDPER
;	jrhi	#ok
;Turn off MK storm image
	move	@stormobj,a0,L
	.ref	OBJOFF
	calla	OBJOFF
	jruc	#ok2
#ok
	.ref	robo_2_snd
	SOUND1	robo_2_snd
#ok2
;MJT End

	move	*a9(OXPOS),*a13(PDATA)
	move	*a10(OXPOS),*a13(PDATA+16)
	move	*a11(OXPOS),*a13(PDATA+32)
	move	*a8(OXPOS),*a13(PDATA+48)

	move	*a9(OYPOS),*a13(PDATA+64)
	move	*a8(OYPOS),*a13(PDATA+80)

#lp
	SLEEPK	1
	move	@HALT,a14
	jrnz	#lp

 SUBR	otdscroller_wake

	move	@WORLDTLX+16,a0
	subi	WRLDMID-200,a0
	move	a0,a14
	sra	2,a14			;Take frac of difference (now 11/16)
	sub	a14,a0
	sra	2,a14
	sub	a14,a0

	move	*a13(PDATA),a1
	add	a0,a1
	move	a1,*a9(OXPOS)

	move	*a13(PDATA+16),a1
	add	a0,a1
	move	a1,*a10(OXPOS)

	move	*a13(PDATA+32),a1
	add	a0,a1
	move	a1,*a11(OXPOS)

	move	*a13(PDATA+48),a1
	add	a0,a1
	move	a1,*a8(OXPOS)

	move	*a13(PDATA+96),a1
	add	a0,a1
	move	@stormobj,a14,L
	move	a1,*a14(OXPOS)

	move	@WORLDTLY+16,a0
	move	a0,a14
	sra	3,a0			;Take frac of difference (now 9/64)
	sra	6,a14
	add	a14,a0

	move	*a13(PDATA+64),a1
	add	a0,a1
	move	a1,*a9(OYPOS)
	move	a1,*a10(OYPOS)
	move	a1,*a11(OYPOS)

	move	*a13(PDATA+80),a1
	add	a0,a1
	move	a1,*a8(OYPOS)

	move	@stormobj,a14,L
	addi	34h,a1
	move	a1,*a14(OYPOS)

	jruc	#lp


#*******************************
*
* Blink city lights for outdoor court

 SUBRP	blink_lights

	.bss	cycram1		,3*2*16	;Palette cycle mem
	.bss	cycram2		,3*2*16	
;	.bss	cycram3		,3*2*16	
;	.bss	cycram4		,3*2*16	
;	.bss	cycram5		,3*2*16	
	.bss	cycram6		,3*2*16	
	.bss	cycram7		,3*2*16	
;	.bss	cycram8		,3*2*16	
;	.bss	cycram9		,3*2*16	
;	.bss	cycram10	,3*2*16	
	.bss	cycram11	,3*2*16	
	.bss	cycram12	,3*2*16	
;	.bss	cycram13	,3*2*16	
;	.bss	cycram14	,3*2*16	
;	.bss	cycram15	,3*2*16	

;Blink 2nd city piece
	movi	city1_p,a8
	movi	cycram1,a9
	movi	[60,62],a10		;1st,last color

	movi	2*60,a0
	calla	RNDRNG0
	addi	1*60,a0
	move	a0,a11			;Rate

	.ref	COLCYC
	CREATE	CYCPID,COLCYC

	movi	city1_p,a8
	movi	cycram2,a9
	movi	[62,64],a10		;1st,last color
	movi	2*60,a0
	calla	RNDRNG0
	addi	1*60,a0
	move	a0,a11			;Rate
	CREATE	CYCPID,COLCYC

;	movi	city1_p,a8
;	movi	cycram3,a9
;	movi	[249,251],a10		;1st,last color
;	movi	2*60,a0
;	calla	RNDRNG0
;	addi	3*60,a0
;	move	a0,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	city1_p,a8
;	movi	cycram4,a9
;	movi	[251,253],a10		;1st,last color
;	movi	2*60,a0
;	calla	RNDRNG0
;	addi	3*60,a0
;	move	a0,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	city1_p,a8
;	movi	cycram5,a9
;	movi	[253,255],a10		;1st,last color
;	movi	2*60,a0
;	calla	RNDRNG0
;	addi	3*60,a0
;	move	a0,a11			;Rate
;	CREATE	CYCPID,COLCYC
;

;Blink 2nd city piece
	movi	city2_p,a8
	movi	cycram6,a9
	movi	[60,62],a10		;1st,last color

	movi	2*60,a0
	calla	RNDRNG0
	addi	1*60,a0
	move	a0,a11			;Rate
	CREATE	CYCPID,COLCYC

	movi	city2_p,a8
	movi	cycram7,a9
	movi	[62,64],a10		;1st,last color
	movi	2*60,a0
	calla	RNDRNG0
	addi	1*60,a0
	move	a0,a11			;Rate
	CREATE	CYCPID,COLCYC

;	movi	city2_p,a8
;	movi	cycram8,a9
;	movi	[249,251],a10		;1st,last color
;	movi	2*60,a0
;	calla	RNDRNG0
;	addi	3*60,a0
;	move	a0,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	city2_p,a8
;	movi	cycram9,a9
;	movi	[251,253],a10		;1st,last color
;	movi	2*60,a0
;	calla	RNDRNG0
;	addi	3*60,a0
;	move	a0,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	city2_p,a8
;	movi	cycram10,a9
;	movi	[253,255],a10		;1st,last color
;	movi	2*60,a0
;	calla	RNDRNG0
;	addi	3*60,a0
;	move	a0,a11			;Rate
;	CREATE	CYCPID,COLCYC

;Blink 3rd city piece
	movi	city3_p,a8
	movi	cycram11,a9
	movi	[60,62],a10		;1st,last color

	movi	2*60,a0
	calla	RNDRNG0
	addi	1*60,a0
	move	a0,a11			;Rate
	CREATE	CYCPID,COLCYC

	movi	city3_p,a8
	movi	cycram12,a9
	movi	[62,64],a10		;1st,last color
	movi	2*60,a0
	calla	RNDRNG0
	addi	1*60,a0
	move	a0,a11			;Rate
	CREATE	CYCPID,COLCYC

;	movi	city3_p,a8
;	movi	cycram13,a9
;	movi	[249,251],a10		;1st,last color
;	movi	2*60,a0
;	calla	RNDRNG0
;	addi	3*60,a0
;	move	a0,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	city3_p,a8
;	movi	cycram14,a9
;	movi	[251,253],a10		;1st,last color
;	movi	2*60,a0
;	calla	RNDRNG0
;	addi	3*60,a0
;	move	a0,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	city3_p,a8
;	movi	cycram15,a9
;	movi	[253,255],a10		;1st,last color
;	movi	2*60,a0
;	calla	RNDRNG0
;	addi	3*60,a0
;	move	a0,a11			;Rate
;	CREATE	CYCPID,COLCYC

	DIE


#*******************************
* Init crowd ani procs
*

 SUBR	initcrowd_ani

;	movi	bnch_ram_plist,a9
	movi	crwd_ram_plist,a10

	move	@pup_court,a8			;Outdoor court?
	jrnz	#x				; br=yes

;	move	@bnchl_p,a8,L
;	movi	BNCHPL_LST,a11
;	CREATE0	bnch_ani
;	move	a0,*a9+,L
;
;	move	@bnchr_p,a8,L
;	movi	BNCHPL_LST,a11
;	CREATE0	bnch_ani
;	move	a0,*a9+,L

;--------------------

	move	@cr1st1_p,a8,L
	movi	CR2FST_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L


	move	@cr1st2_p,a8,L
	movi	CR0FST_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L

;	move	@cr1st2_p,a8,L
;	movi	CR4FST_LST,a11
;	CREATE0	crwd_ani
;	move	@cr1st3_p,a8,L
;	movi	CR1FST_LST,a11
;	CREATE0	crwd_ani


;	move	@cr1st4_p,a8,L		;Never see?
;	movi	CR2FST_LST,a11
;	CREATE0	crwd_ani
;	move	@cr1st5_p,a8,L		;Never see?
;	movi	CR3FST_LST,a11
;	CREATE0	crwd_ani


;	move	@cr1st6_p,a8,L
;	movi	CR4FST_LST,a11
;	CREATE0	crwd_ani
;	move	@cr1st7_p,a8,L
;	movi	CR1FST_LST,a11
;	CREATE0	crwd_ani

	move	@cr1st7_p,a8,L
	movi	CR0FST_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L


	move	@cr1st8_p,a8,L
	movi	CR3FST_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L

;--------------------

	move	@cr2nd1_p,a8,L
	movi	CR4SEC_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L


	move	@cr2nd2_p,a8,L
	movi	CR2SEC_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L
	move	@cr2nd3_p,a8,L
	movi	CR1SEC_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L


;	move	@cr2nd4_p,a8,L		;Never see?
;	movi	CR5SEC_LST,a11
;	CREATE0	crwd_ani
;	move	@cr2nd5_p,a8,L		;Never see?
;	movi	CR4SEC_LST,a11
;	CREATE0	crwd_ani


	move	@cr2nd6_p,a8,L
	movi	CR2SEC_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L
	move	@cr2nd7_p,a8,L
	movi	CR3SEC_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L


	move	@cr2nd8_p,a8,L
	movi	CR5SEC_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L

;--------------------

	move	@cr3rd1_p,a8,L
	movi	CR1THD_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L


	move	@cr3rd2_p,a8,L
	movi	CR4THD_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L
	move	@cr3rd3_p,a8,L
	movi	CR2THD_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L


;	move	@cr3rd4_p,a8,L		;Never see?
;	movi	CR3THD_LST,a11
;	CREATE0	crwd_ani
;	move	@cr3rd5_p,a8,L		;Never see?
;	movi	CR4THD_LST,a11
;	CREATE0	crwd_ani


	move	@cr3rd6_p,a8,L
	movi	CR1THD_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L
	move	@cr3rd7_p,a8,L
	movi	CR3THD_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L


	move	@cr3rd8_p,a8,L
	movi	CR2THD_LST,a11
	CREATE0	crwd_ani
	move	a0,*a10+,L

#x
	clr	a0
;	move	a0,*a9+,L			;Set end of bench plist
	move	a0,*a10+,L			;Set end of crowd plist

	rets


#*-------------------
; Turn on bench animation, wait a bit, then die

; SUBR	bench_animate
;
;	SLEEPK	8
;	movk	1,a1
;	movi	bnch_ram_plist,a10
;#lp
;	move	*a10+,a0,L
;	jaz	SUCIDE
;	move	a1,*a0(PTIME)
;	addk	1,a1
;	jruc	#lp


#*-------------------
; Turn on crowd animation, wait a bit, then die

 SUBR	start_animate

	.ref	RNDPER
;	movi	150,a0			;!!! ;Randomly knock down his %
; 	calla	RNDPER
;	jrls	#skp
;	CREATE0	bench_animate
;#skp
	movk	1,a1
	movi	crwd_ram_plist,a10
#lp
	move	*a10+,a0,L
	jaz	SUCIDE
	move	a1,*a0(PTIME)
	addk	1,a1
	jruc	#lp


#*-------------------
; Do bench ani seq proc

; SUBRP	bnch_ani
;
;	SLEEP	32767
;
;	move	a11,a10			;Get *seq list
;	jruc	#lp
;#lptop
;	move	*a8(OIMG),a3,L		;>Get old & set new *img
;	move	a1,*a8(OIMG),L
;	move	*a1,a2,L
;	move	a2,*a8(OSIZE),L
;	move	*a1(ISAG),*a8(OSAG),L
;
;	move	*a3(IANIOFFY),a14
;	move	*a1(IANIOFFY),a0
;	sub	a14,a0			;Newaniy-Oldaniy
;	move	*a8(OYPOS),a14
;	sub	a0,a14
;	move	a14,*a8(OYPOS)
;
;	move	*a3(IANIOFFX),a14
;	move	*a1(IANIOFFX),a0
;	sub	a14,a0			;Newanix-Oldanix
;	move	*a8(OXPOS),a14
;	sub	a0,a14
;	move	a14,*a8(OXPOS)
;
;	move	*a10+,a0
;	calla	PRCSLP
;#lp
;	move	*a10+,a1,L		;New *img or is seq complete?
;	jrnz	#lptop			; br=new *img
;
;	jruc	bnch_ani


#*--------------------
; Do crowd ani seq proc

 SUBRP	crwd_ani

	SLEEP	32767

	move	a11,a10			;Get *seq list
	jruc	#lp
#lptop
	move	*a8(OIMG),a3,L		;>Get old & set new *img
	move	a1,*a8(OIMG),L
	move	*a1,a2,L
	move	a2,*a8(OSIZE),L
	move	*a1(ISAG),*a8(OSAG),L

	move	*a3(IANIOFFY),a14
	move	*a1(IANIOFFY),a0
	sub	a14,a0			;Newaniy-Oldaniy
	move	*a8(OYPOS),a14
	sub	a0,a14
	move	a14,*a8(OYPOS)

	move	*a3(IANIOFFX),a14
	move	*a1(IANIOFFX),a0
	sub	a14,a0			;Newanix-Oldanix
	move	*a8(OXPOS),a14
	sub	a0,a14
	move	a14,*a8(OXPOS)

	move	*a10+,a0
	calla	PRCSLP
#lp
	move	*a10+,a1,L		;New *img or is seq complete?
	jrnz	#lptop			; br=new *img

	jruc	crwd_ani


;--------------------
; Bench/crowd ani seq lists

;BNCHPL_LST
;	LW	BNCHPL02,9
;	LW	BNCHPL03,8

;	LW	BNCHPL04,8
;	LW	BNCHPL05,7
;	LW	BNCHPL06,7
;	LW	BNCHPL07,7
;	LW	BNCHPL06,7
;	LW	BNCHPL05,8
;	LW	BNCHPL04,8
;	LW	BNCHPL03,9

;	LW	BNCHPL02,9
;	LWL0	BNCHPL01,3*60

;COACH_LST
;	LW	COACH02,9
;	LW	COACH03,9
;	LW	COACH04,9
;	LW	COACH05,9
;	LW	COACH06,9
;	LW	COACH05,9
;	LW	COACH04,9
;	LW	COACH03,9
;	LW	COACH02,9
;	LWL0	COACH01,3*60


CR0FST_LST
	LW	CR0FST02n,8
	LW	CR0FST03n,7
	LW	CR0FST04n,6
	LW	CR0FST05n,5
	LW	CR0FST06n,6
	LW	CR0FST07n,8
	LW	CR0FST06n,6
	LW	CR0FST05n,7
	LW	CR0FST06n,6
	LW	CR0FST07n,8
	LW	CR0FST06n,7
	LW	CR0FST07n,7
	LW	CR0FST06n,6
	LW	CR0FST05n,6
	LW	CR0FST04n,6
	LW	CR0FST03n,7
	LW	CR0FST02n,8
	LWL0	CR0FST01n,3*60

;CR1FST_LST
;	LW	CR1FST02,8
;	LW	CR1FST03,7
;	LW	CR1FST04,6
;	LW	CR1FST05,5
;	LW	CR1FST06,6
;	LW	CR1FST07,7
;	LW	CR1FST06,5
;	LW	CR1FST05,5
;	LW	CR1FST06,6
;	LW	CR1FST07,7
;	LW	CR1FST06,6
;	LW	CR1FST05,6
;	LW	CR1FST04,7
;	LW	CR1FST03,8
;	LW	CR1FST02,9
;	LWL0	CR1FST01,3*60

CR2FST_LST
	LW	CR2FST02,8
	LW	CR2FST03,7
	LW	CR2FST04,6
	LW	CR2FST05,6
	LW	CR2FST06,7
	LW	CR2FST07,8
	LW	CR2FST05,6
	LW	CR2FST06,7
	LW	CR2FST07,8
	LW	CR2FST06,7
	LW	CR2FST05,6
	LW	CR2FST04,7
	LW	CR2FST03,8
	LW	CR2FST02,9
	LWL0	CR2FST01,3*60

CR3FST_LST
	LW	CR3FST02,7
	LW	CR3FST03,6
	LW	CR3FST04,5
	LW	CR3FST05,5
	LW	CR3FST06,6
	LW	CR3FST07,8
	LW	CR3FST06,6
	LW	CR3FST07,8
	LW	CR3FST06,6
	LW	CR3FST05,5
	LW	CR3FST06,6
	LW	CR3FST07,8
	LW	CR3FST06,6
	LW	CR3FST05,6
	LW	CR3FST04,6
	LW	CR3FST03,7
	LW	CR3FST02,8
	LWL0	CR3FST01,3*60

;CR4FST_LST
;	LW	CR4FST02,8
;	LW	CR4FST03,7
;	LW	CR4FST04,6
;	LW	CR4FST05,5
;	LW	CR4FST06,6
;	LW	CR4FST07,8
;	LW	CR4FST06,6
;	LW	CR4FST05,7
;	LW	CR4FST06,6
;	LW	CR4FST07,8
;	LW	CR4FST06,7
;	LW	CR4FST07,7
;	LW	CR4FST06,6
;	LW	CR4FST05,6
;	LW	CR4FST04,6
;	LW	CR4FST03,7
;	LW	CR4FST02,8
;	LWL0	CR4FST01,3*60


CR1SEC_LST
	LW	CR1SEC02,8
	LW	CR1SEC03,7
	LW	CR1SEC04,6
	LW	CR1SEC05,6
	LW	CR1SEC06,6
	LW	CR1SEC07,7
	LW	CR1SEC06,6
	LW	CR1SEC05,6
	LW	CR1SEC06,6
	LW	CR1SEC07,7
	LW	CR1SEC06,6
	LW	CR1SEC05,6
	LW	CR1SEC04,7
	LW	CR1SEC03,8
	LW	CR1SEC02,9
	LWL0	CR1SEC01,3*60

CR2SEC_LST
	LW	CR2SEC02,8
	LW	CR2SEC03,7
	LW	CR2SEC04,6
	LW	CR2SEC05,5
	LW	CR2SEC06,5
	LW	CR2SEC07,8
	LW	CR2SEC06,7
	LW	CR2SEC05,7
	LW	CR2SEC04,6
	LW	CR2SEC05,5
	LW	CR2SEC06,5
	LW	CR2SEC07,8
	LW	CR2SEC06,6
	LW	CR2SEC05,6
	LW	CR2SEC04,7
	LW	CR2SEC03,8
	LW	CR2SEC02,9
	LWL0	CR2SEC01,3*60

CR3SEC_LST
	LW	CR3SEC02,8
	LW	CR3SEC03,7
	LW	CR3SEC04,6
	LW	CR3SEC05,6
	LW	CR3SEC06,6
	LW	CR3SEC07,8
	LW	CR3SEC06,7
	LW	CR3SEC05,6
	LW	CR3SEC06,6
	LW	CR3SEC07,8
	LW	CR3SEC06,7
	LW	CR3SEC05,6
	LW	CR3SEC04,7
	LW	CR3SEC03,8
	LW	CR3SEC02,9
	LWL0	CR3SEC01,3*60

CR4SEC_LST
	LW	CR4SEC02,7
	LW	CR4SEC03,6
	LW	CR4SEC04,5
	LW	CR4SEC05,5
	LW	CR4SEC06,5
	LW	CR4SEC07,7
	LW	CR4SEC06,5
	LW	CR4SEC05,5
	LW	CR4SEC06,4
	LW	CR4SEC07,6
	LW	CR4SEC06,5
	LW	CR4SEC05,5
	LW	CR4SEC06,4
	LW	CR4SEC07,7
	LW	CR4SEC06,5
	LW	CR4SEC05,5
	LW	CR4SEC04,6
	LW	CR4SEC03,7
	LW	CR4SEC02,8
	LWL0	CR4SEC01,3*60

CR5SEC_LST
	LW	CR5SEC02,8
	LW	CR5SEC03,7
	LW	CR5SEC04,6
	LW	CR5SEC05,6
	LW	CR5SEC06,6
	LW	CR5SEC07,7
	LW	CR5SEC06,6
	LW	CR5SEC07,7
	LW	CR5SEC06,6
	LW	CR5SEC05,6
	LW	CR5SEC06,5
	LW	CR5SEC07,7
	LW	CR5SEC06,8
	LW	CR5SEC05,8
	LW	CR5SEC04,8
	LW	CR5SEC02,9
	LWL0	CR5SEC01,3*60


CR1THD_LST
	LW	CR1THD02,8
	LW	CR1THD03,7
	LW	CR1THD04,6
	LW	CR1THD05,5
	LW	CR1THD06,5
	LW	CR1THD07,5
	LW	CR1THD06,5
	LW	CR1THD05,5
	LW	CR1THD06,5
	LW	CR1THD07,5
	LW	CR1THD06,5
	LW	CR1THD05,6
	LW	CR1THD04,7
	LW	CR1THD03,8
	LW	CR1THD02,9
	LWL0	CR1THD01,3*60

CR2THD_LST
	LW	CR2THD02,8
	LW	CR2THD03,7
	LW	CR2THD04,6
	LW	CR2THD05,6
	LW	CR2THD06,6
	LW	CR2THD07,6
	LW	CR2THD06,6
	LW	CR2THD07,6
	LW	CR2THD06,6
	LW	CR2THD07,6
	LW	CR2THD06,6
	LW	CR2THD05,6
	LW	CR2THD04,7
	LW	CR2THD03,8
	LW	CR2THD02,9
	LWL0	CR2THD01,3*60

CR3THD_LST
	LW	CR3THD02,8
	LW	CR3THD03,7
	LW	CR3THD04,6
	LW	CR3THD05,5
	LW	CR3THD06,5
	LW	CR3THD07,5
	LW	CR3THD06,5
	LW	CR3THD05,5
	LW	CR3THD06,5
	LW	CR3THD07,5
	LW	CR3THD06,5
	LW	CR3THD05,6
	LW	CR3THD04,7
	LW	CR3THD03,8
	LW	CR3THD02,9
	LWL0	CR3THD01,3*60

CR4THD_LST
	LW	CR4THD02,8
	LW	CR4THD03,7
	LW	CR4THD04,6
	LW	CR4THD05,5

;	LW	CR4THD06,5
;	LW	CR4THD07,5
;	LW	CR4THD06,5
	LW	CR4THD04,5
	LW	CR4THD05,5
	LW	CR4THD04,5

	LW	CR4THD05,5

;	LW	CR4THD06,5
;	LW	CR4THD07,5
;	LW	CR4THD06,5
	LW	CR4THD04,5
	LW	CR4THD05,5
	LW	CR4THD04,5

	LW	CR4THD05,6
	LW	CR4THD04,7
	LW	CR4THD03,8
	LW	CR4THD02,9
	LWL0	CR4THD01,3*60


#*******************************
* Turn on random advertisement
*

 SUBR	random_ads

	rets

	.if 0	;TEMP

	movi	adpid,a0
	calla	KIL1C


;left side ad
	movk	01,a0			;10
	calla	RNDRNG0
	sll	5,a0

	movi	ad1_t,a1
	add	a0,a1
	move	*a1,a1,L

;reflection
	addi	ad1ref_t,a0
	move	*a0,a3,L

	move	@ad1_ptr,a8,L
	move	a1,*a8(OIMG),L
	move	*a1,a2,L
	move	a2,*a8(OSIZE),L
	move	*a1(ISAG),*a8(OSAG),L


;reflection
	move	@ad1ref_ptr,a8,L
	move	a3,*a8(OIMG),L
	move	*a3,a2,L
	move	a2,*a8(OSIZE),L
	move	*a3(ISAG),*a8(OSAG),L

	move	*a8(OIMG),a0,L
	cmpi	RF_KOM1_L,a0
	jrnz	#noani0
;Start an animation for this ad
	CREATE	adpid,MK3_ad
	jruc	#noani
#noani0
	cmpi	RF_CHAL_L,a0
	jrnz	#noani
;Start an animation for this ad
	CREATE	adpid,wwf_ad
#noani

;right side ad
	movk	3,a0
	calla	RNDRNG0
	sll	5,a0

	movi	ad2_t,a1
	add	a0,a1
	move	*a1,a1,L

;reflection
	addi	ad2ref_t,a0
	move	*a0,a3,L

	move	@ad2_ptr,a8,L
	move	a1,*a8(OIMG),L
	move	*a1,a2,L
	move	a2,*a8(OSIZE),L
	move	*a1(ISAG),*a8(OSAG),L


;reflection
	move	@ad2ref_ptr,a8,L
	move	a3,*a8(OIMG),L
	move	*a3,a2,L
	move	a2,*a8(OSIZE),L
	move	*a3(ISAG),*a8(OSAG),L

	.endif	;TEMP

;--------------------
; Fix crowd_p pal for floor reflections!
;

 SUBR	fix_floorclr

	move	@oteam1,a2
	sll	5,a2
	.ref	crt_pals_z
	addi	crt_pals_z,a2
	move	*a2,a11,L
;FIX!!!
;	movi	CROWD_p,a0
;	calla	pal_find		;Put in PDATA??!!!!

	andi	0ff00h,a0

	move	a0,a1			;dest pal
	ori	236,a1
	move	a11,a0

	movk	9,a2			;9 colors
	calla	pal_set
	rets


ad1_t
;	.long	adjet
;	.long	adhot
ad1ref_t
;	.long	jetref
;	.long	hotref
ad2_t
;	.long	adnba2,adjam2
;	.long	admid2,adblue2
ad2ref_t
;	.long	nbaref,jamref
;	.long	midref,blueref



;ad1_t	.long	ad1,adjet
;	.long	adhot,AD_CHAL_L,AD_KOM1_L,AD_PEK_L
;	.long	AD_III_L,AD_KANO_L,AD_KOM1_L,AD_KOM1_L,AD_CHAL_L
;ad1ref_t
;	.long	ad1ref,jetref
;	.long	hotref,RF_CHAL_L,RF_KOM1_L,RF_PEK_L
;	.long	RF_III_L,RF_KANO_L,RF_KOM1_L,RF_KOM1_L,RF_CHAL_L
;
;ad2_t	.long	ad2,adnba2,adjam2
;	.long	adrecy2,admid2,adblue2,AD_REV_R,AD_SMO_R,AD_MUS_R
;ad2ref_t
;	.long	ad2ref,nbaref,jamref
;	.long	recycref,midref,blueref,RF_REV_R,RF_SMO_R,RF_MUS_R


wwf_t	
;	.long	AD_CHAL_L,RF_CHAL_L
;	.long	AD_WWF_L,RF_WWF_L
;	.long	0

MK3_t
;	.long	AD_KOM1_L,5*60
;	.long	AD_KOM2_L,4
;	.long	AD_KOM1_L,4
;	.long	AD_KOM2_L,4
;	.long	AD_KOM1_L,30
;	.long	AD_KOM2_L,5
;	.long	AD_KOM1_L,5
;	.long	AD_KOM2_L,5
;	.long	AD_KOM1_L,5
;	.long	AD_KOM2_L,5
;	.long	0

;--------------------

 SUBRP	wwf_ad

	movi	wwf_t,a9
wwf_lp
	move	*a9+,a0,L
	jrz	wwf_ad
	move	*a9+,a1,L

	move	@ad1_ptr,a8,L
	move	a0,*a8(OIMG),L
	move	*a0,a2,L
	move	a2,*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

;reflection
	move	@ad1ref_ptr,a8,L
	move	a1,*a8(OIMG),L
	move	*a1,a2,L
	move	a2,*a8(OSIZE),L
	move	*a1(ISAG),*a8(OSAG),L

	SLEEP	120
	jruc	wwf_lp


 SUBRP	MK3_ad

	movi	MK3_t,a9
mk3_lp
	move	*a9+,a0,L
	jrz	MK3_ad
;	move	*a9+,a1,L

	move	@ad1_ptr,a8,L
	move	a0,*a8(OIMG),L
	move	*a0,a2,L
	move	a2,*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L

;reflection
;	move	@ad1ref_ptr,a8,L
;	move	a1,*a8(OIMG),L
;	move	*a1,a2,L
;	move	a2,*a8(OSIZE),L
;	move	*a1(ISAG),*a8(OSAG),L

	move	*a9+,a0,L
	calla	PRCSLP
	jruc	mk3_lp


#********************************
* Animate backboard to proper angle (Process)
* A8=*Object (left)

	.ref	bbshatter

	.bss	bbrgt_p	,32		;*Rgt bboard

	.asg	244-16,BOARD_ANI_MINX	;-16 to make hoop be off-screen also

 SUBRP	backboard_ani

	SLEEPK	30

	move	@bbrgt_p,a9,L		;Init ptr to rgt hoop obj
	movi	bbshatter,a10		;Init ptr to shattered flag
	movi	gndx+16,a11		;Init ptr to look at current court X
#lp
	move	a8,a6			;Set for lft hoop
	move	*a11,a0			;Chk current crt X
	jrn	#lft
	move	a9,a6			;Set for rgt hoop
#lft
	abs	a0
	subi	BOARD_ANI_MINX,A0	;Too far away (hoop off screen)?
	jrn	#fixbb			;Yes if neg

	srl	4,a0			;Shf X down for anim-step #
	sll	5,a0			;Shf up for tbl offset
	addi	#ani_t,a0
	move	@pup_court,a14		;Outdoor court?
;;	jrz	#nootd			; br=no
	jrz	#bok			; br=no
	addi	#ani_otd_t-#ani_t,a0,W	;Set ptr to shattered tbl
;;	jruc	#bok
;;#nootd
;;	move	*a10,a14		;Is bkbrd shattered? No if 0
;;;FIX!!!
;;	jruc	#bok		;Skip code for bboard shatter ani
;;	jrz	#bok
;;	addi	#sani_t-#ani_t,a0,W	;Set ptr to shattered tbl
#bok
	move	*a0,a0,L		;Deref for new backboard ptr
	move	*a6(OIMG),a14,L		;Get old *bkbrd
	cmp	a14,a0			;New image?
	jrz	#slp			; br=yes
	move	*a14,a1			;Get old bkbrd ISIZEX:IANIOFFX
	move	*a14(IANIOFFX),a2
	sll	16,a1
	movx	a2,a1

	move	a0,*a6(OIMG),L		;Set new *bkbrd,OSAG,OSIZE
	move	*a0(ISAG),*a6(OSAG),L
	movb	*a0(ICTRL+7),a14	;Set 5 z comp & 3 bpp bits
	movb	a14,*a6(OCTRL+7)
	move	*a0(ISIZE),a14,L
	move	a14,*a6(OSIZE),L
	move	*a0(IANIOFFX),a2	;Get new bkbrd ISIZEX:IANIOFFX
	sll	16,a14
	movx	a2,a14

	subxy	a14,a1			;Calc XY SIZE:ANI changes
	cmp	a8,a6			;Doing lft or rgt hoop? Lft if =
	jreq	#nof
	move	a1,a14			;Rgt hoop. Assume(!) it is the FLIPH
	sra	16,a14			; of lft hoop & correct ani X with
	sext	a1			; hoop SIZEX diff
	neg	a1
	add	a14,a1
#nof
	move	*a6(OXPOS),a14		;Correct X for change in size/ani
	addxy	a1,a14
	move	a14,*a6(OXPOS)
;
;	move	*a0,a0,L		;deref for new OSIZE
;	move	*a6(OSIZE),a1,L		;get old OSIZE
;	move	a0,*a6(OSIZE),L
;
;	subxy	a1,a0			;calc XY size changes
;	jrxz	#slp			;any X change?
;	move	*a6(OFLAGS),a1		;yes, lets assume some more!
;	btst	B_FLIPH,a1		;don't worry about it if its not
;	jrz	#slp			; flipped
;	move	*a6(OXPOS),a1		;correct X for change in size
;	subxy	a0,a1
;	move	a1,*a6(OXPOS)
;
#slp	SLEEPK	1

	.if CRTALGN
	move	@P1CTRL,a14		;Make hoops go away if owners press
	move	@P2CTRL,a0		; TURBO so hoop dot align can be
	or	a0,a14			; checked
	xori	BUT3_M,a14
	andi	BUT3_M,a14
	srl	BUT3_B-B_3DQ,a14
	move	@rimrf,a1,L		;*Rgt hoop objs
	move	@rimrb,a2,L
	move	*a1(OFLAGS),a0
	andi	~M_3DQ,a0
	or	a14,a0
	move	a0,*a1(OFLAGS)
	move	a0,*a2(OFLAGS)
	move	*a9(OFLAGS),a0		;Rgt bbrd obj
	andi	~M_3DQ,a0
	or	a14,a0
	move	a0,*a9(OFLAGS)
;	movi	OBJLST,A1		;Find rgt rimbase & do it too
;#fndbr	move	*a1,a1,L
;	jrz	#nobr			;End?
;	move	*a1(OIMG),a2,L
;	cmpi	rimbase,a2
;	jrne	#fndbr			;No match?
;	move	*a1(OXPOS),a2		;The side we want?
;	jrn	#fndbr
;	move	*a1(OFLAGS),a0		;Rgt rimbase
;	andi	~M_3DQ,a0
;	or	a14,a0
;	move	a0,*a1(OFLAGS)
;#nobr
	move	@P3CTRL,a14
	move	@P4CTRL,a0
	or	a0,a14
	xori	BUT3_M,a14
	andi	BUT3_M,a14
	srl	BUT3_B-B_3DQ,a14
	move	@rimlf,a1,L		;*Lft hoop objs
	move	@rimlb,a2,L
	move	*a1(OFLAGS),a0
	andi	~M_3DQ,a0
	or	a14,a0
	move	a0,*a1(OFLAGS)
	move	a0,*a2(OFLAGS)
	move	*a8(OFLAGS),a0		;Lft bbrd obj
	andi	~M_3DQ,a0
	or	a14,a0
	move	a0,*a8(OFLAGS)
;	movi	OBJLST,A1		;Find lft rimbase & do it too
;#fndbl	move	*a1,a1,L
;	jrz	#nobl			;End?
;	move	*a1(OIMG),a2,L
;	cmpi	rimbase,a2
;	jrne	#fndbl			;No match?
;	move	*a1(OXPOS),a2		;The side we want?
;	jrnn	#fndbl
;	move	*a1(OFLAGS),a0		;Lft rimbase
;	andi	~M_3DQ,a0
;	or	a14,a0
;	move	a0,*a1(OFLAGS)
;#nobl
	.endif

	jruc	#lp

#fixbb	clr	a0			;Hoop off-screen. Make sure it won't
	move	a0,*a10			; be shattered next time we see it

	move	@rimlf,a1,L		;Assume doing lft hoop
	cmp	a8,a6			;Lft or rgt? Lft if =
	jreq	#fxbb1
	movk	1,a0			;Set for rgt hoop
	move	@rimrf,a1,L
#fxbb1
	move	*a1(OIMG),a1,L		;Deref *obj
	cmpi	RIM0_F_00,a1,L		;Is it norm hoop img? Yes if =
	jreq	#slp
	clr	a1			;No. Do netani to reset the hoop
	callr	net_ani
	jruc	#slp


#ani_t
;Indoor court backboard
	.long	back2			;Fill for BOARD_ANI_MINX -16

	.long	back2,back3,back4,back5,back6,back7,back8
	.long	back9,back10,back10,back10,back10

#ani_otd_t
;Outdoor court backboard
	.long	nback2			;Fill for BOARD_ANI_MINX -16

	.long	nback2,nback3,nback4,nback5,nback6,nback7,nback8
	.long	nback9,nback10,nback10,nback10,nback10

#sani_t
;	.long	bturn_5,bturn_4,bturn_3,bturn_2,bturn_1,bbord_10
;	.long	bbord_10,bbord_10,bbord_10,bbord_10


;--------------------
; Save the right backboard object ptr (Process)

 SUBRP	backboard_svrptr

	move	a8,@bbrgt_p,L
	DIE


#********************************
* Animate net/rim after made or missed shot
* A0=0 if left hoop, !0 if rgt hoop
* A1=Ani seq # (0-17)
* Trashes scratch

 SUBR	net_ani

	PUSH	a7,a8,a9,a10

	move	a0,a0
	jrz	#lft
	move	@rimrf,a8,L		;*Right hoop objs
	move	@rimrb,a9,L
    	jruc	#tag
#lft
	move	@rimlf,a8,L		;Left ^
	move	@rimlb,a9,L
#tag
	sll	5,a1
	addi	#net_t,a1
	move	@pup_court,a14
	jrz	#tag1
	addi	#netc_t-#net_t,a1
#tag1
	move	*a1,a10,L
	CREATE	HOOP_PID,do_net_ani
	PULL	a7,a8,a9,a10
	rets

;--------------------

#net_t	.long	netrst_l	;Net ani reset
	.long	0		;(make next ani's start even #'d)

	.long	net00_l,net01_l	;Deep Z - out far
	.long	net02_l,net03_l	;Deep Z - in close
	.long	net04_l,net05_l	;Mid Z  - out far
	.long	net06_l,net07_l	;Mid Z  - in close
	.long	net08_l,net09_l	;Near Z - out far
	.long	net10_l,net11_l	;Near Z - in close

	.long	net12_l		;Missed shot rim bend - out far
	.long	net13_l		;Missed shot rim bend - in close

	.long	net14_l		;Soft ball roll in
	.long	net15_l		;Dunk shot rim bend
	.long	net16_l		;Shatter backboard

	.long	net17_l		;On-fire shot net burn
	.long	net18_l		;On-fire shot net burn

;--------------------

#netc_t	.long	netcrst_l	;Net ani reset
	.long	0		;(make next ani's start even #'d)

	.long	netc00_l,netc01_l	;Deep Z - out far
	.long	netc02_l,netc03_l	;Deep Z - in close
	.long	netc04_l,netc05_l	;Mid Z  - out far
	.long	netc06_l,netc07_l	;Mid Z  - in close
	.long	netc08_l,netc09_l	;Near Z - out far
	.long	netc10_l,netc11_l	;Near Z - in close

	.long	netc12_l		;Missed shot rim bend - out far
	.long	netc13_l		;Missed shot rim bend - in close

	.long	netc14_l		;Soft ball roll in
	.long	netc15_l		;Dunk shot rim bend
	.long	netc16_l		;Shatter backboard

	.long	netc17_l		;On-fire shot net burn
	.long	netc18_l		;On-fire shot net burn


********************************

do_net_ani

#lp	move	*a10+,a0,L
	jaz	SUCIDE
	jrp	#slp

	move	*a10+,a3,L

	setf	3,0,0
	move	*a0(ICTRL+12),a14
	move	a14,*a8(OCTRL+12)	;Write bits per pixel
	move	*a3(ICTRL+12),a14
	move	a14,*a9(OCTRL+12)
	setf	16,1,0

	move	*a8(OFLAGS),a1
	calla	obj_aniq

	move	a3,a0
	move	a8,a2
	move	a9,a8
	move	*a8(OFLAGS),a1
	calla	obj_aniq
	move	a2,a8

	movk	4,a0
#slp
	calla	PRCSLP
	jruc	#lp

;--------------------

netrst_l
	.long	RIM0_F_00,RIM0_B_00,0	;Net ani reset

net00_l
net01_l
	.long	4
	.long	RIM7_F_01,RIM7_B_01	;Deep Z - out far
	.long	RIM7_F_02,RIM7_B_02
	.long	RIM7_F_03,RIM7_B_03
	.long	RIM7_F_04,RIM7_B_04
	.long	RIM7_F_05,RIM7_B_05
	.long	RIM7_F_06,RIM7_B_06
	.long	RIM7_F_07,RIM7_B_07
	.long	RIM7_F_08,RIM7_B_08
	.long	RIM7_F_09,RIM7_B_09
	.long	RIM0_F_00,RIM0_B_00
	.long	RIM7_F_11,RIM7_B_11
	.long	RIM0_F_00,RIM0_B_00,0

net02_l
net03_l
	.long	3
	.long	RIM8_F_01,RIM8_B_01	;Deep Z - in close
	.long	RIM8_F_02,RIM8_B_02
	.long	RIM8_F_03,RIM8_B_03
	.long	RIM8_F_04,RIM8_B_04
	.long	RIM8_F_05,RIM8_B_05
	.long	RIM8_F_06,RIM8_B_06
	.long	RIM0_F_00,RIM0_B_00,0

net04_l
net05_l

net06_l					;Mid Z - in close
net07_l
	.long	1
	.long	RIM2_F_01,RIM2_B_01	;Mid Z - out far
	.long	RIM2_F_02,RIM2_B_02
	.long	RIM2_F_03,RIM2_B_03
	.long	RIM2_F_04,RIM2_B_03
	.long	RIM2_F_05,RIM2_B_05
	.long	RIM2_F_06,RIM2_B_06
	.long	RIM0_F_00,RIM0_B_00
	.long	RIM2_F_08,RIM2_B_08
	.long	RIM0_F_00,RIM0_B_00,0

net10_l
net11_l
					;Near Z - in close
net08_l
net09_l
	.long	3
	.long	RIM1_F_01,RIM1_B_01	;Near Z - out far
	.long	RIM1_F_02,RIM1_B_02
	.long	RIM1_F_03,RIM1_B_03
	.long	RIM1_F_04,RIM1_B_03
	.long	RIM1_F_05,RIM1_B_03
	.long	RIM1_F_06,RIM1_B_06
	.long	RIM1_F_07,RIM1_B_07
	.long	RIM1_F_08,RIM1_B_08
	.long	RIM1_F_09,RIM1_B_09
	.long	RIM1_F_10,RIM1_B_10
	.long	RIM1_F_11,RIM1_B_11
	.long	RIM0_F_00,RIM0_B_00,0

net12_l
	.long	RIM3_F_01,RIM3_B_01	;Missed shot rim bend - out far
	.long	RIM3_F_02,RIM3_B_02
	.long	RIM4_F_01,RIM4_B_01
	.long	RIM0_F_00,RIM0_B_00
	.long	RIM4_F_02,RIM4_B_02
	.long	RIM0_F_00,RIM0_B_00,0

net13_l
	.long	RIM5_F_01,RIM5_B_01	;Missed shot rim bend - in close
	.long	RIM0_F_00,RIM0_B_00
	.long	RIM5_F_03,RIM5_B_03
	.long	RIM0_F_00,RIM0_B_00,0

net14_l
	.long	RIM4_F_01,RIM4_B_01	;Soft ball roll in
	.long	RIM0_F_00,RIM0_B_00
	.long	RIM4_F_02,RIM4_B_02
	.long	RIM0_F_00,RIM0_B_00,0

net15_l
	.long	RIM3_F_01,RIM3_B_01	;Dunk shot rim bend
	.long	RIM3_F_02,RIM3_B_02
	.long	RIM3_F_03,RIM3_B_03
	.long	RIM3_F_04,RIM3_B_04
	.long	RIM3_F_05,RIM3_B_05
	.long	RIM3_F_06,RIM3_B_06
	.long	RIM3_F_07,RIM3_B_07
	.long	RIM3_F_08,RIM3_B_08
	.long	RIM3_F_09,RIM3_B_09
	.long	RIM0_F_00,RIM0_B_00
	.long	RIM3_F_11,RIM3_B_11
	.long	RIM0_F_00,RIM0_B_00,0

net16_l
;	.long	rimbndF_1,rimbndB_1	;Shatter backboard
;	.long	rimbndF_2,rimbndB_2
;	.long	rimbndF_3,rimbndB_3
;	.long	rimbndF_4,rimbndB_4
;	.long	rimbndF_5,rimbndB_5
;	.long	rimbndF_6,rimbndB_6
;	.long	rimbndF_7,rimbndB_7
;	.long	rimbndF_8,rimbndB_8
;	.long	rimbndF_9,rimbndB_9
;	.long	rimbndF_10,rimbndB_10
;	.long	rimbndF_11,rimbndB_11
;	.long	rimbndF_12,rimbndB_12
;	.long	rimbndF_13,rimbndB_13
;	.long	rimbndF_14,rimbndB_14
;	.long	rimbndF_15,rimbndB_15
;	.long	rimbndF_16,rimbndB_16
;	.long	rimbndF_17,rimbndB_17
	.long	RIM0_F_00,RIM0_B_00,0

net17_l
netc17_l
	.long	FLAME_F_01,RIM0_B_00	;On-fire shot net burn
	.long	FLAME_F_02,RIM0_B_00
	.long	FLAME_F_03,RIM0_B_00
	.long	FLAME_F_04,RIM0_B_00
	.long	FLAME_F_05,RIM0_B_00
	.long	FLAME_F_06,RIM0_B_00
	.long	FLAME_F_07,RIM0_B_00
	.long	FLAME_F_08,RIM0_B_00
	.long	FLAME_F_09,RIM0_B_00
	.long	FLAME_F_10,RIM0_B_00
	.long	FLAME_F_11,RIM0_B_00
	.long	FLAME_F_12,RIM0_B_00
	.long	FLAME_F_13,RIM0_B_00,0

net18_l
netc18_l
	.long	FLAME2F_01,RIM0_B_00	;On-fire shot net burn
	.long	FLAME2F_02,RIM0_B_00
	.long	FLAME2F_03,RIM0_B_00
	.long	FLAME2F_04,RIM0_B_00
	.long	FLAME2F_05,RIM0_B_00
	.long	FLAME2F_06,RIM0_B_00
	.long	FLAME2F_07,RIM0_B_00
	.long	FLAME2B_08,RIM0_B_00
	.long	FLAME2B_09,RIM0_B_00
	.long	FLAME2B_10,RIM0_B_00
	.long	FLAME2B_11,RIM0_B_00
	.long	FLAME2B_12,RIM0_B_00
	.long	FLAME2F_13,RIM0_B_00,0

;--------------------

netcrst_l
netc16_l
	.long	CHAN1F_01,CHAN1B_01,0	;Net ani reset

netc04_l
netc05_l

netc06_l				;Mid Z - in close
netc07_l
	.long	1
	.long	CHAN2F_01,CHAN2B_01	;Mid Z - out far
	.long	CHAN2F_02,CHAN2B_02
	.long	CHAN2F_03,CHAN2B_03
	.long	CHAN2F_04,CHAN2B_04
	.long	CHAN2F_05,CHAN2B_05
	.long	CHAN2F_06,CHAN2B_06
	.long	CHAN1F_01,CHAN1B_01
	.long	CHAN2F_07,CHAN2B_07
	.long	CHAN1F_01,CHAN1B_01,0

netc02_l
netc03_l
					;Deep Z - in close
netc10_l
netc11_l
;	.long	3
	.long	CHAN1F_01,CHAN1B_01	;Near Z - in close
	.long	CHAN1F_02,CHAN1B_02
	.long	CHAN1F_03,CHAN1B_03
	.long	CHAN1F_04,CHAN1B_04
	.long	CHAN1F_05,CHAN1B_05
	.long	CHAN1F_08,CHAN1B_08
	.long	CHAN1F_09,CHAN1B_09
	.long	CHAN1F_01,CHAN1B_01
	.long	CHAN1F_10,CHAN1B_10
	.long	CHAN1F_01,CHAN1B_01,0

netc00_l
netc01_l
					;Deep Z - out far
netc08_l
netc09_l
;	.long	3
	.long	CHAN1F_01,CHAN1B_01	;Near Z - out far
	.long	CHAN1F_02,CHAN1B_02
	.long	CHAN1F_03,CHAN1B_03
	.long	CHAN1F_04,CHAN1B_04
	.long	CHAN1F_05,CHAN1B_05
	.long	CHAN1F_06,CHAN1B_06
	.long	CHAN1F_07,CHAN1B_07
	.long	CHAN1F_08,CHAN1B_08
	.long	CHAN1F_09,CHAN1B_09
	.long	CHAN1F_01,CHAN1B_01
	.long	CHAN1F_10,CHAN1B_10
	.long	CHAN1F_01,CHAN1B_01,0

netc12_l
	.long	CHAN3F_01,CHAN3B_01	;Missed shot rim bend - out far
	.long	CHAN3F_02,CHAN3B_02
	.long	CHAN1F_01,CHAN1B_01
	.long	CHAN3F_01,CHAN3B_01
	.long	CHAN1F_01,CHAN1B_01,0

netc13_l
	.long	CHAN3F_01,CHAN3B_01	;Missed shot rim bend - in close
	.long	CHAN1F_01,CHAN1B_01
	.long	CHAN3F_01,CHAN3B_01
	.long	CHAN1F_01,CHAN1B_01,0

netc14_l
	.long	CHAN1F_01,CHAN1B_01	;Soft ball roll in
	.long	CHAN1F_02,CHAN1B_02
	.long	CHAN1F_03,CHAN1B_03
	.long	CHAN1F_02,CHAN1B_02
	.long	CHAN1F_01,CHAN1B_01,0

netc15_l
	.long	CHAN3F_01,CHAN3B_01	;Dunk shot rim bend
	.long	CHAN3F_02,CHAN3B_02
	.long	CHAN3F_03,CHAN3B_03
	.long	CHAN3F_04,CHAN3B_04
	.long	CHAN3F_05,CHAN3B_05
	.long	CHAN3F_06,CHAN3B_06
	.long	CHAN3F_07,CHAN3B_07
	.long	CHAN3F_08,CHAN3B_08
	.long	CHAN3F_09,CHAN3B_09
	.long	CHAN1F_01,CHAN1B_01
	.long	CHAN3F_10,CHAN3B_10
	.long	CHAN1F_01,CHAN1B_01,0

#*****************************************************************************
*
* Start secret powerup processes at start of matchup_screen
*
* This gets called once each GAME for every player in the game.
* It creates the set of 'watchdog' processes that look out for special
* joystick/button moves for powerups.
*
* If someone buys in after these have started, tough luck...
* 

	STRUCTPD
	WORD	STKREL_P1
	WORD	STKREL_P2
	WORD	STKREL_P3
	WORD	STKREL_P4

 SUBR	start_powerups
	
	movk	3,a9
	move	a13,a8
	addi	PDATA+48,a8
	.ref	PSTATUS
#lp	move	@PSTATUS,a0
	btst	a9,a0
	jrz	#inc

	movi	#special_moves,a2	;This player in game, start processes
#loop
	move	*a2+,a7,L
	jrz	#inc
	movi	SMOVE_PID,a1
	calla	GETPRC
	jruc	#loop
#inc
	subk	16,a8
	subk	1,a9
	jrnn	#lp

	clr	a8
	clr	a9
	clr	a10
	clr	a11
	move	a8,*A13(STKREL_P1)
	move	a8,*A13(STKREL_P2)
	move	a8,*A13(STKREL_P3)
	move	a8,*A13(STKREL_P4)
#stklp
	SLEEPK	1			;>Track stick transitions
	.ref	joy_read2
	calla	joy_read2

	move	@P1CTRL,a0
	xor	a0,a8
	sll	32-8,a8
	jrz	#no1
	move	a0,a8
	sll	32-8,a8
	srl	32-8,a8
#no1
	move	a8,*A13(STKREL_P1)
	move	a0,a8

	move	@P2CTRL,a0
	xor	a0,a9
	sll	32-8,a9
	jrz	#no2
	move	a0,a9
	sll	32-8,a9
	srl	32-8,a9
#no2
	move	a9,*A13(STKREL_P2)
	move	a0,a9

	move	@P3CTRL,a0
	xor	a0,a10
	sll	32-8,a10
	jrz	#no3
	move	a0,a10
	sll	32-8,a10
	srl	32-8,a10
#no3
	move	a10,*A13(STKREL_P3)
	move	a0,a10

	move	@P4CTRL,a0
	xor	a0,a11
	sll	32-8,a11
	jrz	#no4
	move	a0,a11
	sll	32-8,a11
	srl	32-8,a11
#no4
	move	a11,*A13(STKREL_P4)
	move	a0,a11

	jruc	#stklp


******************************************************************************
*
* SPECIAL MOVE PROCESSES - Secret moves
*

#special_moves

	.long	sp_lockcombo
	.long	sp_bighead
	.long	sp_hugehead
	.long	sp_showshotper
	.long	sp_notag
	.long	sp_nodrift
	.long	sp_noassistance
	.long	sp_aba
	.long	sp_court
	.long	sp_special
	.long	0


#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

;;#TIMEOUT	.equ	40

sp_lockcombo

	SLEEPK	1
	move	*a8,a0
;	andi	JOY_DOWN|JOY_LEFT|JOY_RIGHT,a0
	andi	JOY_DOWN,a0
	jrz	sp_lockcombo

;;	cmpi	:SWITCHES:,a0
;;	jrne	:FAILADDR:
;;#lp
;;	clr	a11
;;
;;	WAITSWITCH_DWN	JOY_UP,0,#lp
;;
;;	movi	#TIMEOUT,a11
;;
;;	WAITSWITCH_DWN	JOY_UP_RIGHT,0,#lp
;;	WAITSWITCH_DWN	JOY_RIGHT,0,#lp
;;	WAITSWITCH_DWN	JOY_DOWN_RIGHT,0,#lp
;;	WAITSWITCH_DWN	JOY_DOWN,0,#lp
;;	WAITSWITCH_DWN	JOY_DOWN_LEFT,0,#lp
;;	WAITSWITCH_DWN	JOY_LEFT,0,#lp
;;	WAITSWITCH_DWN	JOY_UP_LEFT,0,#lp

;a9=0-3 for player
	.ref	pup_lockcombo
	move	@pup_lockcombo,a0
	movk	1,a1
	sll	a9,a1
	or	a1,a0
	move	a0,@pup_lockcombo

     	sll	5,a9
	addi	lock_cmbo_snds,a9
	move	*a9,a0,L
	calla	snd_play1
;	LOCKUP
	DIE

	.ref	combo_lock1,combo_lock2,combo_lock3,combo_lock4
lock_cmbo_snds
	.long	combo_lock1
	.long	combo_lock2
	.long	combo_lock3
	.long	combo_lock4

#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

;#TIMEOUT	.equ	60

sp_bighead

	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	JOY_UP|BUT_TURBO|BUT_PASS,0,#lp

;a9=0-3 for player
	.ref	pup_bighead
	.ref	pup_hugehead
	move	@pup_bighead,a0
	movk	1,a1
	sll	a9,a1
	or	a1,a0
	move	a0,@pup_bighead
	move	@pup_hugehead,a0
	andn	a1,a0
	move	a0,@pup_hugehead

;MJT Start
	CREATE0	flash_backdrop

 	jruc	pupsnd

flash_backdrop
	.ref	lock_ram
	move	a9,a0
	sll	5,a0
	addi	lock_ram,a0
	move	*a0,a8,L

	movi	0101h,a2
	move	a2,*a8(OCONST)

	movk	2,a11
#again
	setf	4,0,0
	movk	M_CONNON,a0		;Replace non-zero data with constant
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0
	movk	3,a9
#tg0
	SLEEPK	1
	dsj	a9,#tg0
	setf	4,0,0
	movk	M_WRNONZ,a0
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0

	movk	3,a9
#tg2
	SLEEPK	1
	dsj	a9,#tg2

	dsj	a11,#again

	DIE
;MJT End

#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

;MJT Start
;#TIMEOUT	.equ	40
#TIMEOUT	.equ	60
;MJT End

sp_hugehead

	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	JOY_UP,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	JOY_UP,0,#lp
	WAITSWITCH_DWN	BUT_PASS,0,#lp
	WAITSWITCH_DWN	BUT_TURBO,0,#lp

;a9=0-3 for player
	move	@pup_hugehead,a0
	movk	1,a1
	sll	a9,a1
	or	a1,a0
	move	a0,@pup_hugehead
	move	@pup_bighead,a0
	andn	a1,a0
	move	a0,@pup_bighead

;MJT Start
	CREATE0	flash_backdrop
;MJT End

 	jruc	pupsnd

#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

;MJT Start
;#TIMEOUT	.equ	55
#TIMEOUT	.equ	60
;MJT End

sp_showshotper

	SLEEPK	1
#lp
;MJT Start
;	clr	a11
;
;	WAITSWITCH_DWN	JOY_LEFT,0,#lp
;
;	movi	#TIMEOUT,a11
;
;	WAITSWITCH_DWN	JOY_DOWN_LEFT,0,#lp
;	WAITSWITCH_DWN	JOY_DOWN,0,#lp
;	WAITSWITCH_DWN	JOY_DOWN_RIGHT,0,#lp
;	WAITSWITCH_DWN	JOY_RIGHT,0,#lp
;	WAITSWITCH_DWN	JOY_RIGHT|BUT_SHOOT,0,#lp
;	WAITSWITCH_DWN	JOY_RIGHT,0,#lp
;	WAITSWITCH_DWN	JOY_RIGHT|BUT_SHOOT,0,#lp
;	WAITSWITCH_DWN	JOY_RIGHT,0,#lp
;	WAITSWITCH_DWN	JOY_RIGHT|BUT_PASS,0,#lp


;Make easier - just 360 swirl

	clr	a11

	WAITSWITCH_DWN	JOY_UP,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	JOY_UP_RIGHT,0,#lp
	WAITSWITCH_DWN	JOY_RIGHT,0,#lp
	WAITSWITCH_DWN	JOY_DOWN_RIGHT,0,#lp
	WAITSWITCH_DWN	JOY_DOWN,0,#lp
	WAITSWITCH_DWN	JOY_DOWN_LEFT,0,#lp
	WAITSWITCH_DWN	JOY_LEFT,0,#lp
	WAITSWITCH_DWN	JOY_UP_LEFT,0,#lp


;a9=0-3 for player
	.ref	pup_showshotper
	move	@pup_showshotper,a0
	jrnz	pupsnd

	movk	1,a0
	sll	a9,a0
	move	a0,@pup_showshotper

;MJT Start
	CREATE0	flash_backdrop
;MJT End
 	jruc	pupsnd

#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

;MJT Start
;#TIMEOUT	.equ	50
#TIMEOUT	.equ	60
;MJT End

sp_notag

	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	JOY_LEFT,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	JOY_LEFT,0,#lp
	WAITSWITCH_DWN	BUT_PASS,0,#lp
	WAITSWITCH_DWN	BUT_PASS,0,#lp
	WAITSWITCH_DWN	BUT_TURBO,0,#lp

;a9=0-3 for player
	.ref	pup_notag
	move	@pup_notag,a0
	movk	1,a1
	sll	a9,a1
	or	a1,a0
	move	a0,@pup_notag

;MJT Start
	CREATE0	flash_backdrop
;MJT End
 	jruc	pupsnd

#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

;MJT Start
;#TIMEOUT	.equ	50
#TIMEOUT	.equ	60
;MJT End

sp_nodrift

	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	JOY_DOWN,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	JOY_DOWN,0,#lp
	WAITSWITCH_DWN	BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	BUT_TURBO,0,#lp

;a9=0-3 for player
	.ref	pup_nodrift
	move	@pup_nodrift,a0
	movk	1,a1
	sll	a9,a1
	or	a1,a0
	move	a0,@pup_nodrift

;MJT Start
	CREATE0	flash_backdrop
;MJT End
 	jruc	pupsnd

#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

#TIMEOUT	.equ	60

sp_noassistance

	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	JOY_UP,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	JOY_UP_RIGHT,0,#lp
	WAITSWITCH_DWN	JOY_RIGHT,0,#lp
	WAITSWITCH_DWN	JOY_DOWN_RIGHT,0,#lp
	WAITSWITCH_DWN	JOY_DOWN,0,#lp
	WAITSWITCH_DWN	JOY_DOWN_LEFT,0,#lp
	WAITSWITCH_DWN	JOY_LEFT,0,#lp
	WAITSWITCH_DWN	JOY_UP_LEFT,0,#lp
	WAITSWITCH_DWN	JOY_UP,0,#lp
	WAITSWITCH_DWN	JOY_UP|BUT_SHOOT,0,#lp

;a9=0-3 for player
	.ref	pup_noassistance
	movk	1,a0
	move	a0,@pup_noassistance

;MJT Start
	CREATE0	flash_backdrop
;MJT End
 	jruc	pupsnd

#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

;MJT Start
;#TIMEOUT	.equ	40
#TIMEOUT	.equ	60
;MJT End

sp_aba

	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	JOY_RIGHT,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	JOY_RIGHT|BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	JOY_RIGHT,0,#lp
	WAITSWITCH_DWN	JOY_RIGHT|BUT_TURBO,0,#lp
	WAITSWITCH_DWN	JOY_RIGHT,0,#lp
	WAITSWITCH_DWN	JOY_RIGHT|BUT_PASS,0,#lp

;a9=0-3 for player
	movk	1,a0
	move	a0,@pup_aba

;MJT Start
	CREATE0	flash_backdrop
;MJT End
 	jruc	pupsnd

#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

#TIMEOUT	.equ	60

sp_court

	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	JOY_LEFT,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	JOY_LEFT|BUT_TURBO,0,#lp
	WAITSWITCH_DWN	JOY_LEFT,0,#lp
	WAITSWITCH_DWN	JOY_LEFT|BUT_TURBO,0,#lp
;MJT Start
;	WAITSWITCH_DWN	JOY_LEFT,0,#lp
;	WAITSWITCH_DWN	JOY_LEFT|BUT_TURBO,0,#lp
;MJT End

;a9=0-3 for player
	movk	1,a0
	move	a0,@pup_court

;MJT Start
	CREATE0	flash_backdrop
;MJT End

pupsnd
     	sll	5,a9
	addi	pwrup_snds,a9
	move	*a9,a0,L
	calla	snd_play1
	DIE

pwrup_snds
	.ref	chkmrk_snd,chkmrk_snd2,chkmrk_snd3,chkmrk_snd4
	.long	chkmrk_snd,chkmrk_snd2,chkmrk_snd3,chkmrk_snd4

#*******************************************************************************
* a8=PnCTRL for this player
* a9=plyr #

#TIMEOUT	.equ	80

sp_special

	SLEEPK	1
#lp
	clr	a11

	WAITSWITCH_DWN	BUT_SHOOT,0,#lp

	movi	#TIMEOUT,a11

	WAITSWITCH_DWN	BUT_SHOOT,0,#lp
;MJT Start
;	WAITSWITCH_DWN	BUT_SHOOT,0,#lp
;	WAITSWITCH_DWN	BUT_SHOOT,0,#lp
;MJT End
	WAITSWITCH_DWN	JOY_UP|BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	JOY_UP_RIGHT|BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	JOY_RIGHT|BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	JOY_DOWN_RIGHT|BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	JOY_DOWN|BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	JOY_DOWN_LEFT|BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	JOY_LEFT|BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	JOY_UP_LEFT|BUT_SHOOT,0,#lp
	WAITSWITCH_DWN	JOY_UP|BUT_SHOOT,0,#lp

;a9=0-3 for player
	movk	1,a0
	move	a0,@pup_aba
	move	a0,@pup_court

	sll	a9,a0

	move	@pup_showshotper,a1
	jrnz	nossp
	move	a0,@pup_showshotper
nossp
	move	@pup_bighead,a1
	or	a0,a1
	move	a1,@pup_bighead
	move	@pup_hugehead,a1
	andn	a0,a1
	move	a1,@pup_hugehead

     	sll	5,a9
	addi	spcpwrup_snds,a9
	move	*a9,a0,L
	calla	snd_play1

;MJT Start
	CREATE0	flash_backdrop
;MJT End

	DIE

spcpwrup_snds
	.ref	yes_no_sel1,yes_no_sel2,yes_no_sel3,yes_no_sel4
	.long	yes_no_sel1,yes_no_sel2,yes_no_sel3,yes_no_sel4

	.end
