****************************************************************
*
* Software:	?
* Initiated:	?
*
* Modified:	Shawn Liptak 8/6/91  - Hiscore display and entry (Total carnage)
* 		Shawn Liptak 11/9/91 - Title screen
* 		Shawn Liptak 2/7/92  - Stripped for basketball
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/22/93 16:24
****************************************************************
	.file	"attract.asm"
	.title	"attract mode"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"mac2.asm"
	.include	"imgtbl.glo"
	.include	"bgndtbl.glo"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"shawn.hdr"
	.include	"link.equ"

;sounds

	.ref	musicoff_snd,ALLOFF,QSNDRST

;logosnd	.word	>f420,1,>8047,0		;Logo spins
;exp1snd	.word	>fc80,10,>803f,0	;Explosion
;ttlgun		.word	>fca0,4,>8031,0		;Title guy shoots gun
bounce_snd	.word	>fc80,10,>8129,0	;Ball bounce
tuneend_snd	.word	>f3ff,8,>8009,0		;End game time tune
tuneend1_snd	.word	>f3ff,>8,>800a,0	;End quarter 1 tune


;symbols defined in this file

	.def	COLTAB

;symbols defined externally

	.ref	ball101
	.ref	MRK_TURM,SHA_LIPM,TON_GOSM,JON_CARM,SAL_DIVM
	.ref	JON_HEYM,JAM_RIVM
	.ref	drw_chicks
	.ref	TWOPLAYERS			;0 = NO, 1 = YES 2 players

	.ref	COLTAB2
;	.ref	player_toggle1,player_toggle2
	.ref	get_all_buttons_down
	.ref	get_all_buttons_cur2
	.ref	fade_up
	.ref	fade_down

	.ref	special_heads
	.ref	our_heads,our_names

	.ref	get_opponent_team
	.ref	winningteam

	.ref	credits2,credits3
	.ref	show_hiscore,WNDWOFF
	.ref	player1_data,player2_data,player3_data,player4_data
	.ref	player_names,player_heads
	.ref	gndstat
	.ref	FRANIMQ
	.ref	GAMSTATE,HALT,KILBGND
	.ref	process_init

	.ref	tvpanelon

	.ref	BAKMODS,BGND_UD1
;KILL_CRD
	.ref	CLR_SCRN

	.ref	CR_CONTP,P_CONT,CR_STRTP,P_START,SOUNDSUP,WSPEED
	.ref	WNDWON,CRD_SCRN2,IRQSKYE
	.ref	pal_clean,pal_getf,dmaq_wait,display_init,AUD1
	.ref	GET_ADJ,CYCLE_TABLE
	.ref	conttimers
;	.ref	wbmcolor_t
	.ref	GETHIGH,pal_set,PALFRAM
	.ref	COLRPRC
	.ref	COLCYC
	.ref	anim_script,anim_killall
	.ref	RNDRNGS
	.ref	GET_AUD,DEF_PAGE
	.ref	PSTATUS,PSTATUS2
	.ref	dirq_wait
	.ref	dirqtimer
	.ref	dpageflip,dpageflip_off
	.ref	WIPEOUT
	.ref	demogame_start
;	.ref	movie_demo
;	.ref	COLRTEMP
	.ref	system_savegame,system_restoregame

	.ref	scores
	.ref	print_string,print_string2,print_string_C,print_string_C2
	.ref	message_palette
	.ref	message_ascii
	.ref	mess_spacing
	.ref	mess_objid
	.ref	mess_cursx
	.ref	mess_cursy
	.ref	lgmd_ascii,osgemd_ascii,sgmd8_ascii,omlgmd_ascii,ogmd10_ascii
	.ref	osgmd8_ascii
	.ref	setup_message
	.ref	message_buffer
	.ref	get_initials_string
	.ref	dec_to_asc,dec_to_pct
	.ref	copy_string,copy_rom_string
	.ref	concat_string,concat_rom_string
	.ref	print_string_R,print_string_R2
	.ref	FADERAM

	.ref	player_stats
	.ref	RNDRNG0

;ram

	BSSX	ENTERON		,16	;INITIALS BEING ENTERD FLAG

	BSSX	hisclong	,16	;!0=Show hiscore table longer


	.bss	cycram		,8*2*16	;Palette cycle mem

;	.bss	RAMLST,32*40 ;35		;IMG PNTRS FOR DELETION WHILE SCROLL
RAMLST	.equ	cycram

	.bss	cycram2		,8*2*16	;^
	.bss	cycram3		,7*2*16	;^
	.bss	cycram4		,7*2*16	;^
	.bss	cycram5		,7*2*16	;^
	.bss	cycram6		,7*2*16	;^
	.bss	cycram7		,9*2*16	;^

	.bss	team_cnts	,32	;left team cnt, +16=rgt team cnt
	.bss	stick		,32	;stick ram for team selection

	.bss	loop		,16	;



	.text

********************************
* Attract mode start up routine (Process)

	.ref	p1taps,p2taps,p3taps,p4taps

#slp	SLEEPK	1

 SUBR	amode_start

	movi	ACTIVE,a0		;>Look for indestructables
	jruc	#nxt

#ilp	move	*a0(PROCID),a0
	jrn	#slp			;Found?
#nxt	move	*a0,a0,L
	jrnz	#ilp

	calla	process_init		;Init process list

	move	@FREE,a13,L		;Get 1st free
	move	*a13,a0,L
	move	a0,@FREE,L
	clr	a0
	move	a0,*a13,L
	move	a13,@ACTIVE,L		;Put me on active list

	move	a13,a12
	addi	PRCSIZ,a12

	movi	AMODE_PID,a0
	move	a0,*a13(PROCID)


;	movi	musicoff_snd,a0
;	calla	snd_play1

	movi	-1,a0
	move	a0,@winningteam

	movk	1,a0
	move	a0,@dpageflip

;	move	@GAMSTATE,a0
;	jan	SUCIDE			;INDIAG?

	movk	INAMODE,a0
	move	a0,@GAMSTATE
	calla	COLRPRC
	movi	AMODE_PID,a1
	movi	amode,a7
	calla	GETPRC

	clr	a0
	move	a0,@HALT
	move	a0,@ENTERON
	move	a0,@p1taps
	move	a0,@p2taps
	move	a0,@p3taps
	move	a0,@p4taps

;Fall through

********************************
* Attract mode loop (Process)

	.ref	result_screen
	.ref	kp_team1,kp_scores,kp_team2

 SUBRP	amode

#lp
	movi	AMODE_PID,a0
	move	a0,*a13(PROCID)

;	JSRP	show_designteam

	move	@kp_scores,a0,L
	move	a0,@scores,L
	move	@scores,a0
	move	@scores+16,a14
	add	a0,a14
	cmpi	40,a14
	jrlt	#nog
	move	@kp_team1,a0
	move	a0,@team1
	move	@kp_team2,a0
	move	a0,@team2
	JSRP	result_screen
	JSRP	drw_chicks
#nog
	JSRP	new_page
	JSRP	show_title
	JSRP	creditscreen
	JSRP	demogame
	calla	QSNDRST
	movi	musicoff_snd,a0
	calla	snd_play1ovr
	JSRP	show_hiscore

	JSRP	drw_stars
	JSRP	creditscreen
	JSRP	demogame
	movi	musicoff_snd,a0
	calla	snd_play1ovr
	JSRP	new_page
	JSRP	show_title
	JSRP	show_copyright
	JSRP	creditscreen
	JSRP	show_operatormsg

	JSRP	demogame
	movi	musicoff_snd,a0
	calla	snd_play1ovr
	JSRP	drw_chicks
	JSRP	drw_ladder

	move	@loop,a0
	inc	a0
	move	a0,@loop
	ANDK	3,a0
	jrnz	#lp

	JSRP	show_designteam

	jruc	#lp



;weekend_test
;
;	clr	a0
;	move	a0,@WORLDTLX,L
;	move	a0,@WORLDTLY,L
;
;	move	a0,@WSPEED
;	JSRP	WNDWON			;Grow window
;
;	SLEEPK	2
;
;	movi	coinin_mod,a0
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1
;	movi	4<<10+4<<5+7,a0
;	move	a0,@IRQSKYE
;
;	JSRP	WNDWOFF
;	SLEEP	1*60		;5
;	movi	OWSPD,a0
;	move	a0,@WSPEED
;	JSRP	WNDWON			;Grow window
;
;	calla	WIPEOUT
;	RETP
;
;
;coinin_mod
;	.long	empjambBMOD
;	.word	0,0
;	.long	0
;


#****************************************************************
* Title screen

show_title

	clr	a0
	move	a0,@IRQSKYE		;background color

	calla	display_blank
	calla	WIPEOUT

	movk	1,a0
	move	a0,@dpageflip
	calla	display_2dsclmodeon

	movk	10,a0
	move	a0,@WORLDTLX+16
	movi	1000,a0
	move	a0,@WORLDTLY+16

	SLEEPK	2
	movi	ttl_t,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1
	JSRP	scrn_scaleininit
	SLEEPK	2

	movi	STATIC_p,a8
	movi	cycram,a9
	movi	[1,8],a10		;1st,last color
	movk	2,a11			;Rate
	CREATE	CYCPID,COLCYC

;MJT

;	movi	SUBLOGO_p,a8
;	movi	cycram2,a9
;	movi	[211,217],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC

	movi	P_STATIC,a8
	movi	cycram2,a9
	movi	[21,27],a10		;1st,last color
	movk	2,a11			;Rate
	CREATE	CYCPID,COLCYC

	movi	P_STATIC,a8
	movi	cycram3,a9
	movi	[28,34],a10		;1st,last color
	movk	2,a11			;Rate
	CREATE	CYCPID,COLCYC

	movi	P_STATIC,a8
	movi	cycram4,a9
	movi	[35,41],a10		;1st,last color
	movk	2,a11			;Rate
	CREATE	CYCPID,COLCYC

	movi	P_STATIC,a8
	movi	cycram5,a9
	movi	[42,48],a10		;1st,last color
	movk	2,a11			;Rate
	CREATE	CYCPID,COLCYC

	movi	P_STATIC,a8
	movi	cycram6,a9
	movi	[49,55],a10		;1st,last color
	movk	2,a11			;Rate
	CREATE	CYCPID,COLCYC

	movi	P_STATIC,a8
	movi	cycram7,a9
	movi	[56,63],a10		;1st,last color
	movk	2,a11			;Rate
	CREATE	CYCPID,COLCYC


	JSRP	scrn_scalein


	.if 0

	clr	a0
	clr	a1
	movi	SUBLOGO,a2
	movi	500,a3			;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movi	[>400,>400],a10
#uplp
	callr	ttl_setscl
	SLEEPK	1
	subi	[>20,>20],a10
	cmpi	[>a0,>a0],a10
	jrgt	#uplp

#dnlp
	callr	ttl_setscl
	SLEEPK	1
	addi	[>10,>10],a10
	cmpi	[>110,>110],a10
	jrlt	#dnlp
     	
	.endif

	movi	6*TSEC,a10
#lp	SLEEPK	1
	calla	get_all_buttons_cur2
	jrz	#nob
      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	.ref	SOUNDSUP
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#xb
#nob	
	dsj	a10,#lp
#xb

	JSRP	scrn_scaleout

	calla	WIPEOUT

	RETP

ttl_t
	.long	trnedBMOD
	.word	-37,>3b1
	.long	0


ttl_setscl
	move	*a8(OIMG),a2,L
	movi	[>100,0],a3
	clr	a14
	movx	a10,a14
	divu	a14,a3
;	move	*a2(IANIOFFX),a1
	movi	-106,a1
	mpys	a3,a1
	sra	16,a1
	addi	200,a1			;X base
	move	a1,*a8(OXPOS)
;	move	*a2(IANIOFFY),a1
	movi	-98,a1
	mpys	a3,a1
	sra	16,a1
	addi	124,a1			;Y base
	move	a1,*a8(OYPOS)

	move	a10,*a8(ODATA_p),L	;Set scale value
	rets


	.if	0

#****************************************************************
* Title screen

 SUBRP	show_title2

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	2

	movi	#ttl_t,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	CREATE0	startcyc

	clr	a10
	movk	16,a11
	CREATE0	fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	SLEEP	1*TSEC+30

	movi	7*TSEC,a10
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
	movi	CYCPID,a0
	calla	KIL1C

	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40

	RETP

#ttl_t
	.long	ttitleBMOD
	.word	23,25
	.long	0

startcyc
	SLEEPK	9
	movi	STATIC_p,a8
	movi	cycram,a9
	movi	[1,8],a10		;1st,last color
	movk	2,a11			;Rate
	CREATE	CYCPID,COLCYC
;	movi	SUBLOGO_p,a8
;	movi	cycram2,a9
;	movi	[211,217],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC
	DIE

	.endif


#****************************************************************
* Show an operator message if one has been entered

	.ref	STRCNRMO_1
	.ref	STRCNRMO
	.ref	ADJ_PAGE,RC_BYTEI

	STRUCTPD
	WORD	som_string


 SUBR	show_operatormsg


	calla	ADJ_PAGE
	movk	CMESS_LINES,a2		;>Check for a message
	movi	CUSTOM_MESSAGE,a7
#cmlp
	calla	RC_BYTEI
	jrnz	#msg
	addi	CMESS_LINE_SIZE,a7
	dsj	a2,#cmlp
	jruc	#x
#msg
	calla	display_blank
	calla	WIPEOUT

	movk	1,a0
	move	a0,@dpageflip
	move	a0,@DISPLAYON
	calla	display_2dsclstarmodeon

	movk	10,a0
	move	a0,@WORLDTLX+16
	movi	1000,a0
	move	a0,@WORLDTLY+16

	SLEEPK	2

	calla	display_unblank

	CREATE0	showdt_scl


	movk	CMESS_LINES,a2		;>Check for a message
	movi	CUSTOM_MESSAGE,a7
	movi	[50,200],a9
#prtlp
	PUSHP	a2,a7

	calla	ADJ_PAGE

	move	a13,a2
	addi	som_string,a2
#getlp	calla	RC_BYTEI
	movb	a0,*a2
	addk	8,a2
	move	a0,a0
	jrnz	#getlp


	movi	GOLD,a0
	calla	pal_getf
	move	a0,a6

	move	a13,a8
	addi	som_string,a8
	clr	a0
	movk	1,a10
	movi	osgfont_t,a11
	PUSHP	a9
	JSRP	STRCNRMO_1
	PULLP	a9

	movi	OBJLST,a14

#olp	move	*a14,a14,L	;A14=*Next
	jrz	#oend
	move	*a14(ODATA_p),a0,L
	jrnz	#olp
	movi	[>320,>320],a1
	move	a1,*a14(ODATA_p),L
	jruc	#olp
#oend

	PUSHP	a6
	SLEEPK	30
	PULLP	a6
	PULLP	a2,a7
#nxt
	addi	[45,0],a9

	addi	CMESS_LINE_SIZE,a7
	dsj	a2,#prtlp



	SLEEP	TSEC*6

;	clr	a0
;	movi	-1,a1
;	calla	obj_delc
;
;	movi	#thanx_t,a8
;	JSRP	prt_dt
;
;	SLEEP	TSEC*2+20

	JSRP	scrn_scaleout

	calla	WIPEOUT

#x	RETP

#*

 SUBRP	show_copyright

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	2


	.ref	RD7FONT
	movi	textp,a0
	calla	pal_getf
	move	a0,a6

	clr	a0
	clr	a6
	movi	#ln1,a8
	movi	[50+65,200],a9
 	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln2,a8
	movi	[62+65,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln3,a8
	movi	[74+65,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln4,a8
	movi	[86+65,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln5,a8
	movi	[98+65,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln6,a8
	movi	[110+65,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	clr	a0
	movi	#ln7,a8
	movi	[122+65,200],a9
	movk	1,a10
	movi	RD7FONT,a11
	JSRP	STRCNRMO_1

	movi	[200,0],a0
	movi	[35+20,0],a1
	movi	TSMLOGO,a2			;* image
	movi	20000,a3
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	clr	a10
	movk	8,a11
	CREATE0	fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	SLEEP	1*TSEC+30

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
	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40
	RETP

	
#ln1	.string	"COPYRIGHT 1993, 1994",0
#ln2	.string	"MIDWAY IS A TRADEMARK OF MIDWAY MANUFACTURING CO.",0
#ln3	.string	"THE NBA AND NBA TEAM TRADEMARKS USED HEREIN ARE",0
#ln4	.string	"USED UNDER LICENSE FROM NBA PROPERTIES, INC.",0
#ln5	.string	"NBA JAM SESSION IS TRADEMARKED AND",0
#ln6	.string	"OWNED BY NBA PROPERTIES, INC.",0
#ln7	.string	"ALL RIGHTS RESERVED",0
	.EVEN

#****************************************************************
* Show design team names and messages

;	STRUCTPD
;	WORD	ttl_anix
;	WORD	ttl_aniy

	.ref	STRLNRMO_1

 SUBR	show_designteam

	calla	display_blank
	calla	WIPEOUT

	movk	1,a0
	move	a0,@dpageflip
	move	a0,@DISPLAYON
	calla	display_2dsclstarmodeon

	movk	10,a0
	move	a0,@WORLDTLX+16
	movi	1000,a0
	move	a0,@WORLDTLY+16

	SLEEPK	2

	calla	display_unblank

	CREATE0	showdt_scl

	CREATE0	ck_octopus2

;Temp
;	movi	#thanx6_t,a8
;	JSRP	prt_dt2
;
;	movi	TSEC*4+40,a10
;	JSRP	time_delay		;SLEEP	30





	movi	#des_t,a8
	JSRP	prt_dt

	SLEEP	TSEC*4+40

;	movi	TSEC*4+40,a10
;	JSRP	time_delay		;SLEEP	30

	move	*a13(PROCID),a0
	cmpi	DIAG_PID,a0
	jreq	#sclout			;Called from octopuss?

	clr	a0
	movi	-1,a1
	calla	obj_delc

	movi	thanx_t,a8
	JSRP	prt_dt

	movi	TSEC*2+50,a10
	JSRP	time_delay		;SLEEP	30
	
	clr	a0
	movi	-1,a1
	calla	obj_delc

;;;;;;
;	jruc	#dog

	movi	thanx1_t,a8
	JSRP	prt_dt

	movi	TSEC*2+50,a10
	JSRP	time_delay		;SLEEP	30

	clr	a0
	movi	-1,a1
	calla	obj_delc

	movi	#thanx2_t,a8
	JSRP	prt_dt

	movi	TSEC*2+50,a10
	JSRP	time_delay		;SLEEP	30

	clr	a0
	movi	-1,a1
	calla	obj_delc

	movi	#thanx3_t,a8
	JSRP	prt_dt

	movi	TSEC*2+50,a10
	JSRP	time_delay		;SLEEP	30

	clr	a0
	movi	-1,a1
	calla	obj_delc

	movi	#thanx4_t,a8
	JSRP	prt_dt

	movi	TSEC*2+50,a10
	JSRP	time_delay		;SLEEP	30

	clr	a0
	movi	-1,a1
	calla	obj_delc

	movi	#thanx5_t,a8
	JSRP	prt_dt

	movi	TSEC*2+50,a10
	JSRP	time_delay		;SLEEP	30

	clr	a0
	movi	-1,a1
	calla	obj_delc

;#dog

;#sclout
;	JSRP	scrn_scaleout

	calla	display_blank
	calla	WIPEOUT

	movk	1,a0
	move	a0,@dpageflip
	move	a0,@DISPLAYON

	movk	10,a0
	move	a0,@WORLDTLX+16
	movi	1000,a0
	move	a0,@WORLDTLY+16

	SLEEPK	2

	calla	display_unblank

;Temp
	movi	#thanx6_t,a8
	JSRP	prt_dt2

	movi	TSEC*5,a10
	JSRP	time_delay		;SLEEP	30

#sclout
	JSRP	scrn_scaleout

	calla	display_blank
	calla	WIPEOUT

	movk	1,a0
	move	a0,@dpageflip
	move	a0,@DISPLAYON

	movk	10,a0
	move	a0,@WORLDTLX+16
	movi	1000,a0
	move	a0,@WORLDTLY+16

	SLEEPK	2

	calla	display_unblank

	RETP

#des_t
	WL	-1,TURQUSE
	.word	-2,118,3
	.byte	"DESIGN TEAM:",0
	.long	0
	WL	-1,GOLD
	.word	-2,60,37
	.byte	"MARK TURMELL",0
	LWW	MRK_TURM,>b2,>32
	.byte	"SHAWN LIPTAK",0
	LWW	SHA_LIPM,>f0,>1d
	WL	-1,AQUAPAL
	.byte	"TONY GOSKIE",0			;-6
	LWW	TON_GOSM,185,>1f
	.byte	"JOHN CARLTON",0
	LWW	JON_CARM,>ff92,>20
	.byte	"SAL DIVITA",0
	LWW	SAL_DIVM,>ffa3,>20
	WL	-1,GREENPAL
	.byte	"JON HEY",0
	LWW	JON_HEYM,>ffbf,>1c
	WL	-1,GOLD
	.byte	"JAMIE RIVETT",0
	LWW	JAM_RIVM,>a0,>18
	.word	0

thanx_t
	WL	-1,WHITEPAL
	.word	-2,200,3
	.byte	"STARRING:",0
	.long	0
	WL	-1,BLUE
	.word	-2,200,37
	.byte	"STEPHEN HOWARD",0
	.long	0
	.byte	"WILLIE MORRIS JR",0
	.long	0
	.byte	"TODD MCCLEARN",0
	.long	0
	.byte	"TONY SCOTT",0
	.long	0
	.byte	"KERRI HOSKINS",0
	.long	0
	.byte	"LORRAINE OLIVIA",0
	.long	0
	.byte	"AWARDS BY KAYDAN",0
	.long	0
	.word	0
thanx1_t
	WL	-1,WHITEPAL
	.word	-2,200,3
	.byte	"HARDWARE SUPPORT:",0
	.long	0
	WL	-1,RUBYPAL
	.word	-2,200,37
	.byte	"CARY MEDNICK",0
	.long	0
	.byte	"PAT COX",0
	.long	0
	.byte	"RAY MACIKA",0
	.long	0
	.byte	"SHERIDAN OURSLER",0
	.long	0
	.byte	"MATT BOOTY",0
	.long	0
	.byte	"JOHN LOWES",0
	.long	0
	.byte	"AL LASKO",0
	.long	0
	.word	0


#thanx2_t
	WL	-1,WHITEPAL
	.word	-2,200,3
	.byte	"SPECIAL THANKS:",0
	.long	0
	WL	-1,RUBYPAL
	.word	-2,200,37
	.byte	"GEORGE PETRO",0
	.long	0
	.byte	"JOHN NEWCOMER",0
	.long	0
	.byte	"WARREN DAVIS",0
	.long	0
	.byte	"EUGENE JARVIS",0
	.long	0
	.BYTE	"MARK LOFFREDO",0
	.long	0
	.byte	"L.E.D.",0
	.long	0
	.byte	"RAY GAY",0
	.long	0
	.word	0

#thanx3_t
	WL	-1,REDPAL
	.word	-2,200,3
	.byte	"SPECIAL THANKS:",0
	.long	0
	WL	-1,PURPLE
	.word	-2,200,37
	.byte	"BETTY PURCELL",0
	.long	0
	.byte	"PAUL HEITSCH",0
	.long	0
	.byte	"CHRIS GRANNER",0
	.long	0
	.byte	"JIM GREENE",0
	.long	0
	.byte	"ED BOON",0
	.long	0
	.byte	"JOHN TOBIAS",0
	.long	0
	.byte	"JOSH & FLANDERS",0
	.long	0
	.word	0


#thanx4_t
	WL	-1,REDPAL
	.word	-2,200,3
	.byte	"SPECIAL THANKS:",0
	.long	0
	WL	-1,PURPLE
	.word	-2,200,37
	.byte	"DAN FORDEN",0
	.long	0
	.byte	"LINDA DEAL",0
	.long	0
	.byte	"JACK HAEGER",0
	.long	0
	.byte	"ROGER SHARPE",0
	.long	0
	.byte	"JAKE SIMPSON",0
	.long	0
	.byte	"TIM KIZEROW",0
	.long	0
	.byte	"FELECIA TURMELL",0
	.long	0
	.word	0


#thanx5_t
	WL	-1,WHITEPAL
	.word	-2,200,20
	.byte	"EXECUTIVE PRODUCERS:",0
	.long	0
	WL	-1,RUBYPAL
	.word	-2,200,80
	.byte	"NEIL NICASTRO",0
	.long	0
	.byte	"KEN FEDESNA",0
	.long	0
	.byte	"WALLY SMOLUCHA",0
	.long	0
	.byte	"PAUL DUSSAULT",0
	.long	0
	.word	0

#thanx6_t
	WL	-1,SGMD8WHT
	.word	-2,200-42,25
	.byte	"THANK YOU:",0
	.long	0
	WL	-1,SGMD8VIO
	.word	-2,40,60
	.byte	"MANY INTERNET USERS",0
	.long	0
	.byte	"RANDOLPH VANCE",0
	.long	0
	.byte	"WILLIAM HENDERSON",0
	.long	0
	.byte	"RAY KIRKLAND",0
	.long	0
	.byte	"MIKE DAVIDSON",0
	.long	0
	.byte	"LEWIS PODLASZEWSKI",0
	.long	0
	.byte	"ANDREW PODLASZEWSKI",0
	.long	0
	.byte	"SEAN STEWART",0
	.long	0
	.byte	"CHRIS JOHNSON",0
	.long	0
	.byte	"CHRIS CANIANO",0
	.long	0
	.byte	"ERIC HOLMA",0
	.long	0
	.byte	"MIKE OVERBY",0
	.long	0
	.word	-2,250,60
	.byte	"CASEY",0
	.long	0
	.byte	"VINCE FIELDS",0
	.long	0
	.byte	"DAVE EDENZON",0
	.long	0
	.byte	"RIC RORSCHACH",0
	.long	0
	.byte	"DARYL GREEN",0
	.long	0
	.byte	"JERRY CATTELL",0
	.long	0
	.byte	"SHAWN PETREN",0
	.long	0
	.byte	"CHUCK HOROWITZ",0
	.long	0
	.byte	"MACE",0
	.long	0
	.byte	"JIM HSU",0
	.long	0
	.byte	"JASON DRISKO",0
	.long	0
	.byte	"CARL CHAVEZ",0
	.long	0
	.word	0

	.even

#*******************************
* A8=*Data

 SUBRP	prt_dt
	jruc	#nxt

#prtlp
	cmpi	-1,a0
	jrne	#nopal

	move	*a8+,a0,L	;>Change pal
	calla	pal_getf
	move	a0,a6
	jruc	#nxt

#nopal
	cmpi	-2,a0		;>New XY
	jrne	#noxy
	move	*a8+,a9,L
	jruc	#nxt

#noxy
	subk	16,a8
	clr	a0
	movk	1,a10
	movi	osgfont_t,a11
	PUSHP	a9

	cmpi	thanx_t,a8
	jrge	#cn

	JSRP	STRLNRMO_1
	jruc	#cnx

#cn
	.ref	STRCNRMO_1
	JSRP	STRCNRMO_1
#cnx
	PULLP	a9

	addk	15,a8
	srl	4,a8
	sll	4,a8
	move	*a8+,a2,L
	jrz	#noobj			;No object?

	move	*a8+,a0,L
	PUSH	a6,a8

	addxy	a9,a0
	clr	a1
	movy	a0,a1			;Y
	sll	16,a0			;X
	movi	500,a3			;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	PULL	a6,a8
#noobj
	addi	[30,0],a9
	cmpi	thanx_t,a8
	jrge	#cn2
	addi	[0,15],a9
#cn2

	movi	OBJLST,a14

#olp	move	*a14,a14,L	;A14=*Next
	jrz	#oend
	move	*a14(ODATA_p),a0,L
	jrnz	#olp
	movi	[>320,>320],a1
	move	a1,*a14(ODATA_p),L
	jruc	#olp
#oend

	PUSHP	a6
	SLEEPK	20
	PULLP	a6
#nxt
	move	*a8+,a0
	jrnz	#prtlp
	RETP


#*******************************
* A8=*Data

 SUBRP	prt_dt2
	jruc	#nxt

#prtlp
	cmpi	-1,a0
	jrne	#nopal

	move	*a8+,a0,L	;>Change pal
	calla	pal_getf
	move	a0,a6
	jruc	#nxt

#nopal
	cmpi	-2,a0		;>New XY
	jrne	#noxy
	move	*a8+,a9,L
	jruc	#nxt

#noxy
	subk	16,a8
	clr	a0
	movk	1,a10
	movi	osgfont8_t,a11
	PUSHP	a9


	JSRP	STRLNRMO_1
;	JSRP	STRCNRMO_1
	PULLP	a9

	addk	15,a8
	srl	4,a8
	sll	4,a8
	move	*a8+,a2,L
	jrz	#noobj			;No object?

	move	*a8+,a0,L
	PUSH	a6,a8

	addxy	a9,a0
	clr	a1
	movy	a0,a1			;Y
	sll	16,a0			;X
	movi	500,a3			;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	PULL	a6,a8
#noobj
	addi	[15,0],a9

;	movi	OBJLST,a14
;
;#olp	move	*a14,a14,L	;A14=*Next
;	jrz	#oend
;	move	*a14(ODATA_p),a0,L
;	jrnz	#olp
;	movi	[>320,>320],a1
;	move	a1,*a14(ODATA_p),L
;	jruc	#olp
;#oend

	PUSHP	a6
	SLEEPK	10
	PULLP	a6
#nxt
	move	*a8+,a0
	jrnz	#prtlp
	RETP

	.def	osgfont_t
osgfont_t
	.long	OSGEMD_EXP,OSGEMD_APO,OSGEMD_NUM,OSGEMD_DOL	;!"#$
	.long	OSGEMD_SPC,OSGEMD_AND,OSGEMD_APO,OSGEMD_OBR	;%&'(
	.long	OSGEMD_CBR,OSGEMD_SPC,OSGEMD_SPC,OSGEMD_SPC	;)*+,
	.long	OSGEMD_DAS,OSGEMD_DOT,OSGEMD_SLS		;-./
	.long	OSGEMD_0,OSGEMD_1,OSGEMD_2,OSGEMD_3,OSGEMD_4
	.long	OSGEMD_5,OSGEMD_6,OSGEMD_7,OSGEMD_8,OSGEMD_9
	.long	OSGEMD_COL,OSGEMD_SPC,OSGEMD_SPC,OSGEMD_SPC	;:;<=
	.long	OSGEMD_SPC,OSGEMD_QUE,OSGEMD_SPC		;>?@
	.long	OSGEMD_A,OSGEMD_B,OSGEMD_C,OSGEMD_D
	.long	OSGEMD_E,OSGEMD_F,OSGEMD_G,OSGEMD_H
	.long	OSGEMD_I,OSGEMD_J,OSGEMD_K,OSGEMD_L
	.long	OSGEMD_M,OSGEMD_N,OSGEMD_O,OSGEMD_P
	.long	OSGEMD_Q,OSGEMD_R,OSGEMD_S,OSGEMD_T
	.long	OSGEMD_U,OSGEMD_V,OSGEMD_W,OSGEMD_X
	.long	OSGEMD_Y,OSGEMD_Z
	.long	OSGEMD_SPC,OSGEMD_SPC,OSGEMD_SPC,OSGEMD_END	;[\]^
	.long	OSGEMD_BAK,OSGEMD_SPC,OSGEMD_SPC		;_`


osgfont8_t
	.long	OSGEMD_EXP,OSGEMD_APO,OSGEMD_NUM,OSGEMD_DOL	;!"#$
	.long	OSGEMD_SPC,OSGEMD_AND,OSGEMD_APO,OSGEMD_OBR	;%&'(
	.long	OSGEMD_CBR,OSGEMD_SPC,OSGEMD_SPC,OSGEMD_SPC	;)*+,
	.long	OSGEMD_DAS,OSGEMD_DOT,OSGEMD_SLS		;-./
	.long	SGMD8_0,SGMD8_1,SGMD8_2,SGMD8_3
	.long	SGMD8_4,SGMD8_5,SGMD8_6,SGMD8_7
	.long	SGMD8_8,SGMD8_9
	.long	SGMD8_COL,OSGEMD_SPC,OSGEMD_SPC,OSGEMD_SPC	;:;<=
	.long	OSGEMD_SPC,OSGEMD_QUE,OSGEMD_SPC		;>?@
	.long	SGMD8_A,SGMD8_B,SGMD8_C,SGMD8_D
	.long	SGMD8_E,SGMD8_F,SGMD8_G,SGMD8_H
	.long	SGMD8_I,SGMD8_J,SGMD8_K,SGMD8_L
	.long	SGMD8_M,SGMD8_N,SGMD8_O,SGMD8_P
	.long	SGMD8_Q,SGMD8_R,SGMD8_S,SGMD8_T
	.long	SGMD8_U,SGMD8_V,SGMD8_W,SGMD8_X
	.long	SGMD8_Y,SGMD8_Z
	.long	OSGEMD_SPC,OSGEMD_SPC,OSGEMD_SPC,OSGEMD_END	;[\]^
	.long	OSGEMD_BAK,OSGEMD_SPC,OSGEMD_SPC		;_`



#*******************************
* Look at the buttons, read a sequence table,
* and set octopus2 flag if sequence successful

	.ref	octopus2		

ck_octopus2

	clr	a10
	movi	butn_lst,a9

#lp	SLEEPK	1

	move	@SWITCH,a0
	zext	a0
	cmpi	>ffff,a0
	jrnz	#tag1
	clr	a11
	jruc	#lp

#tag1	move	a11,a11
	jrnz	#lp

	inc	a11

	move	*a9,a1,W
	zext	a1
	cmp	a0,a1
	jrz	#yes
	movi	butn_lst,a9
	jruc	#lp
#yes	addk	16,a9
	move	*a9,a0
	jrnz	#lp
	movk	1,a0
	move	a0,@octopus2		

	DIE

butn_lst

;Buttons required for 2nd octopus:
;p1turbo,p1turbo,p2shoot,p2shoot,p2shoot,p2pass,p2pass,p1shoot,p1pass,p2turbo
;p2turbo

	.word	>ffbf,>ffbf,>efff,>efff,>efff,>dfff,>dfff
	.word	>ffef,>ffdf,>bfff,>bfff,0


#*******************************

showdt_scl
#lp
	movi	OBJLST,a14

#olp	move	*a14,a14,L	;A14=*Next
	jrz	#oend
	move	*a14(ODATA_p),a0,L
	cmpi	[>100,>100],a0
	jrle	#olp
	subi	[>10,>10],a0
	move	a0,*a14(ODATA_p),L
	jruc	#olp
#oend
	SLEEPK	1
	jruc	#lp



#*****************************************************************************

	.if	0

 SUBRP	drw_love

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	2

	movi	#love_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	clr	a10
	movk	16,a11
	CREATE0	fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	SLEEP	1*TSEC+30

	movi	4*TSEC,a10
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

	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40

	RETP

#love_mod
	.long	loveBMOD
	.word	1ch,14h
	.long	0


#*****************************************************************************

 SUBRP	drw_school

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	2

	movi	[200,0],a0
	movi	[60-26,0],a1
	movi	stay,a2			;* image
	movi	19001,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	0,a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

	clr	a10
	movk	16,a11
	CREATE0	fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2

	calla	display_unblank

	SLEEP	1*TSEC+30

	movi	3*TSEC,a10
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

	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40

	RETP

	.endif


#*****************************************************************************

 SUBRP	drw_stars

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	2

	movi	coinin_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	clr	a10
	movk	16,a11
	CREATE0	fade_up

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2

	calla	display_unblank

	movk	1,a0
	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON
	ADJUST	ADJMUSIC		;GET MUSIC ON OFF FOR DEMO
	MOVE	A0,A0
	JRNZ	#NONO1
	CLR	A0
	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON

	movi	tuneend1_snd,a0
	calla	snd_play1ovr

#NONO1

	.ref	starring
	JSRP	starring

;	movk	8,a11
;	.ref	FADE_DOWN
;	CREATE0	FADE_DOWN

	SLEEP	30

	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40
	movi	musicoff_snd,a0
	calla	snd_play1ovr

	RETP


coinin_mod
	.long	viewfrtBMOD
	.word	0,5
;	.long	empjambBMOD
;	.word	0,0
	.long	0



#*****************************************************************************

 SUBRP	drw_ladder

	calla	display_blank
	calla	WIPEOUT
	calla	pal_clean

	clr	a0
	move	a0,@dtype		;2D
	move	a0,@HALT

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	movi	[13*360-8,0],a0
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	#ladder_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	CREATE0	deloff

	CREATE0	drw_teams

	SLEEPK	2

	clr	a10
	movk	16,a11
	CREATE0	fade_up

	movk	1,a0
	move	a0,@DISPLAYON
	SLEEPK	2
	calla	display_unblank


	SLEEP	2*60

	CREATE0	drwnbalogoUP

	movi	>772-4,a10
#lp	SLEEPK	1
	move	@WORLDTLY,a0,L
	subi	[2,8000h],a0
	move	A0,@WORLDTLY,L
	calla	BGND_UD1


	calla	get_all_buttons_cur2
	jrz	#nob
      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#xb
#nob	dsj	a10,#lp

	SLEEP	4*64

#xb

;delete foreground objects that are not within visible screen area
;init object ram stack
	clr	a1
	movi	FADERAM,a2

	movi	100,a0			;uhl to clear
clrlup:
	move	a1,*a2+,L
	dsjs	a0,clrlup

	movi	FADERAM,a9
	move	@OBJLST,a8,L		;look through the fgndlist
	jreq	ofail			;does not exist! indicate error
chkfobj:
	calla	SCRTST			;test for object on screen
	jreq	onscrn			;object is definitely on screen!
	move	a8,*a9+,L		;dump into ram stack
onscrn:
	move	*a8(OLINK),a8,L		;let's search for another
	jrne	chkfobj
	clr	a0
	move	a0,*a9,L		;terminate table

objpull:
	movi	FADERAM,a9
lupobj:
	move	*a9+,a0,L
	jrz	ofail			;no object list exits!
	calla	DELOBJ			;delete object from list
	jruc	lupobj

ofail:

	calla	pal_clean

	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	22h
	RETP


drwnbalogoUP

	SLEEP	1*60
#drw
	movi	[60,0],a11
;	movi	nbalogo,a9
	movi	TSMLOGO,a9
	CREATE0	logo_drift
	movi	[334,0],a11
	movi	TSMLOGO,a9
	CREATE0	logo_drift
	SLEEP	15*60
	movi	[60,0],a11
	movi	TSMLOGO,a9
	CREATE0	logo_drift
	movi	[334,0],a11
	movi	TSMLOGO,a9
	CREATE0	logo_drift
	DIE

logo_drift

	move	a11,a0
	movi	[248+48,0],a1
	movi	>7591,a3				;Z
	movi	DMAWNZ|M_NOCOLL,a4
	move	a9,a2
	movi	CLSDEAD,a5
	clr	a6
	movi	[-3,0],a7
	calla	BEGINOBJ

	SLEEP	25*60
	jauc	DELOBJDIE



drw_teams

	.ref	ladder_imgs0,ladder_imgs1,ladder_imgs2,ladder_imgs3,ladder_imgs4
	.ref	ladder_imgs5,ladder_imgs6

	movi	ladder_imgs0,a9
	callr	#drlp
	SLEEP	90
	movi	ladder_imgs1,a9
	callr	#drlp
	SLEEP	140h
	callr	deloffbot
	movi	ladder_imgs2,a9
	callr	#drlp
	SLEEP	110h
	callr	deloffbot
	movi	ladder_imgs3,a9
	callr	#drlp
	SLEEP	110h
	callr	deloffbot
	movi	ladder_imgs4,a9
	callr	#drlp
	SLEEP	110h
	callr	deloffbot
	movi	ladder_imgs5,a9
	callr	#drlp
	SLEEP	110h
	callr	deloffbot
	movi	ladder_imgs6,a9
	callr	#drlp
	DIE
	

#drlp	move	*a9+,a2,L
	jrz	#x

	move	*a9+,a0,L
	move	*a9+,a1,L
	sll	16,a0
	sll	16,a1
	movi	20000,a3
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	callr	#clippit


	move	*a9+,a2,L
	move	*a9+,a0,L
	move	*a9+,a1,L
	sll	16,a0
	sll	16,a1
	movi	20000,a3
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	callr	#clippit

	move	*a9+,a2,L
	move	*a9+,a0,L
	move	*a9+,a1,L
	sll	16,a0
	sll	16,a1
	movi	20000,a3
;	movi	DMAWNZ|M_FLIPH|M_NOCOLL,a4
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	callr	#clippit

	move	*a9+,a2,L
	move	*a9+,a0,L
	move	*a9+,a1,L
	sll	16,a0
	sll	16,a1
	movi	20000,a3
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	jruc	#drlp
#x	rets


	.asg	65,HEAD_WIDTH
#clippit
	move	*a8(OSIZEX),a0
	subi	HEAD_WIDTH,a0
	jrb	#no_clip
	move	a0,*a8(OFSET)
#no_clip
	rets


#ladder_mod
	.long	dabullBMOD
	.word	>ff4b+5,>ffa1+3
	.long	ladderBMOD
	.word	0+5,-92+360
	.long	ladderBMOD
	.word	0+5,-92+360*2
	.long	ladderBMOD
	.word	0+5,-92+360*3
	.long	ladderBMOD
	.word	0+5,-92+360*4
	.long	ladderBMOD
	.word	0+5,-92+360*5
	.long	ladderBMOD
	.word	0+5,-92+360*6
	.long	ladderBMOD
	.word	0+5,-92+360*7
	.long	ladderBMOD
	.word	0+5,-92+360*8
	.long	ladderBMOD
	.word	0+5,-92+360*9
	.long	ladderBMOD
	.word	0+5,-92+360*10
	.long	ladderBMOD
	.word	0+5,-92+360*11
	.long	ladderBMOD
	.word	0+5,-92+360*12
	.long	ladderBMOD
	.word	0+5,-92+360*13
	.long	0



#****************************************************************

 SUBRP	drw_cutaway

	calla	display_blank
	calla	WIPEOUT
	calla	pal_clean

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	#cut_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2

	calla	display_unblank

;	CREATE0	drw_cards
;	SLEEP	4*64
;	clr	a0
;	move	a0,@DISPLAYON

	SLEEP	1*TSEC+30

	movi	3*TSEC,a10
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

	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40

	RETP


#cut_mod
	.long	viewfrtBMOD
	.word	0,5
	.long	0



#***************************************************************
* Show some gameplay

 SUBRP	demogame

	.ref	team1,team2

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	movi	-1,a0
	move	a0,@special_heads,L
	move	a0,@special_heads+20h,L
	.ref	show_shot,assistance_off
	clr	a0
	move	a0,@show_shot
	move	a0,@assistance_off

	movk	26,a0
	calla	RNDRNG0
	move	a0,@team1		;Team controlled by plyrs 1 & 2
	move	a0,a8
#agn	movk	26,a0
	calla	RNDRNG0
	cmp	a0,a8
	jreq	#agn
    	move	a0,@team2		;Team controlled by plyrs 3 & 4

;	movk	1,a0
;	move	a0,@SOUNDSUP

	.ref	snd_play1ovr
	movi	ALLOFF,a0
	calla	snd_play1ovr
	movi	musicoff_snd,a0
	calla	snd_play1ovr

	movk	1,a0
	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON
	ADJUST	ADJMUSIC		;GET MUSIC ON OFF FOR DEMO
	MOVE	A0,A0
	JRNZ	NONO1
	CLR	A0
	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON
	CREATE0	sndstrt
NONO1

	CREATE0	demogame_start

;	.ref	drwnbalogo
;	CREATE0	drwnbalogo

	SLEEPK	5
	calla	update_insert

	SLEEP	3*TSEC

#loop
;	movi	27*60,a10
	movi	60*60,a10
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
;2/9/93
;	jruc	#loop

	movi	CYCPID,a0
	calla	KIL1C

	clr	a10
	movk	16,a11
	CREATE0	fade_down

	SLEEPK	24


	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	clr	a0
	move	a0,@HALT

	movk	1,a0
	move	a0,@dpageflip

	calla	COLRPRC			;Init fixed pal 0 and maybe 2nd pal
	movi	AMODE_PID,a0
	move	a0,*a13(PROCID)
	RETP


sndstrt	SLEEP	3*60
	movk	3,a0
	calla	RNDRNG0
	sll	5,a0
	addi	tunes_t,a0
	move	*a0,a0,L
	calla	snd_play1ovr
	DIE

tunes_t	.long	tuneq2_snd,tuneq3_snd,tuneq4_snd,tuneot_snd

tuneq2_snd	.word	>f3ff,>8,>8006,0	;Quarter 2 tune
tuneq3_snd	.word	>f3ff,>8,>8007,0	;Quarter 3 tune
tuneq4_snd	.word	>f3ff,>8,>8008,0	;Quarter 4 tune
tuneot_snd	.word	>f3ff,>8,>800b,0	;Quarter o.t. tune


#*******************************

update_insert

	calla	CR_STRTP		;Credits to start
	jrlo	#x			;No?
	movi	start,a1
	movi	OBJLST,a8

#lp	move	*a8,a8,L
	jrz	#x		;End?
	move	*a8(OIMG),a0,L
	cmpi	insert,a0
	jrne	#lp		;No match?
  	move	*a8(OFLAGS),a4
	calla	ANI
	jruc	#lp
#x	rets



****************************************************************
* Show credits screen

 SUBRP	creditscreen

	calla	pal_clean

	movk	1,a10
	JSRP	CRD_SCRN2
	movi	AMODE_PID,a0
	move	a0,*a13(PROCID)
;	calla	WIPEOUT			;CLEAN SYSTEM OUT
;	SLEEPK	1

	RETP



****************************************************************
* THIS SHOULD BE CALLED IN PLACE OF ANY JRxx $
* IN CASE OF ERROR. IF WE ARE IN DEBUG MODE
* IT WILL HANG, IF NOT, THE ERROR WILL BE LOGGED
* AND IT WILL RETURN.
* A1 = RETURN ADDRESS OF CALLING ROUTINE
* A2 = ERROR CODE

ERRORLOG
	MMTM	SP,A2,A3,A4,A5,A6,A7
;	SLL	16,A2
;ERRLOGG				;A8 IS IN A8
;
;	MOVE	A13,A7		;PROC. BLOCK IN A7
;	MOVE	*A7(PROCID),A6
;	SLL	16,A6
;	MOVE	*A8(OID),A3
;	MOVX	A3,A6		;A6 = [PROCID:*A8(OID)]		
;
;;	MOVE	@CIRCUIT,A5
;;	SLL	16,A5
;;	MOVE	@WAVE,A3
;	MOVX	A3,A5		;A5 = [CIRCUIT#:WAVE#,)]
;
;	MOVI	AUD1STRT,A4	;PLAY #
;	callr	GETAUD4
;
;	SLL	16,A4
;	MOVE	*A0(OID),A3	;A4 = [STRT#:*A0(OID)]
;	MOVX	A3,A4
;
;	MOVE	@GAMSTATE,A3	;A2 = [PSTATUS:GAMSTATE]
;	MOVX	A3,A2
;
;	MOVE	@PSTATUS,A3	;A2 = [ERROR CODE:PSTATUS]
;	MOVX	A3,A2
;			
;	MOVE	*SP(0C0H),A3,L	;A3=GET THE RETURN ADDRESS
;	MOVE	*SP(0E0H),A1,L	;A1=CALLING ADDRESS
;;	CALLA	ADD_DUMP

	MMFM	SP,A2,A3,A4,A5,A6,A7
	RETS


********************************
* Get an audit
* A4=Audit #
* >A4=Audit

GETAUD4
	mmtm	sp,a0,a1
	move	a4,a0
	calla	GET_AUD
	calla	DEF_PAGE	     ;POINT AT DEFAULT PAGE.
	move	a1,a4
	mmfm	sp,a0,a1
	rets



#*****************************************************************************
	.asg	17,YSPACE

 SUBR	hint_page

	movi	4*60,a10
#lp
	SLEEPK	1
	dec	a10
	jrz	#tvout
	move	@tvpanelon,a0,L
	jrnz	#lp

#tvout

	callr	kill_tvpanel

	SOUND1	bounce_snd

	calla	display_blank
	calla	system_savegame

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movk	INPLYRINFO,a0
	move	a0,@GAMSTATE

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	#hintpage_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movi	6<<10+3<<5+7,a0
	move	a0,@IRQSKYE



	.ref	CYCLE_TABLE,COLTAB2
	movi	[10,7],a8		;START AT COLOR 10, CYCLE 7 COLORS
	movi	BLUE,a9			;PAL NAME
	movi	COLTAB2,a10		;TABLE TO CYCLE WITH
	movk	2,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE




	.ref	logos

;	movk	1,a0
;	move	a0,@team1
;	movk	2,a0
;	move	a0,@team2


	movi	logos,a0
	move	@team1,a10
	sll	5,a10
	add	a10,a0
	move	*a0,a2,L
	cmpi	TSMLOGO2,a2
	jrnz	#not
	movi	TSMLOGO,a2
#not

	movi	[72,0],a0
;	movi	[113,0],a1
	movi	[50,0],a1
	movi	20000,a3
	movi	DMAWNZ|M_SCRNREL|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movi	logos,a0
	move	@team2,a10
	sll	5,a10
	add	a10,a0
	move	*a0,a2,L
	cmpi	TSMLOGO2,a2
	jrnz	#not2
	movi	TSMLOGO,a2
#not2

	movi	[328,0],a0
;	movi	[113,0],a1
	movi	[50,0],a1
	movi	20000,a3
	movi	DMAWNZ|M_SCRNREL|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2




	movi	heading_setup,a2
	calla	setup_message
	movi	#str_heading,a4
	calla	print_string_C2


	.global	mess_line_spacing
	movi	YSPACE,a0
	move	a0,@mess_line_spacing

	movi	heading2_setup,a2
	calla	setup_message

	movk	26,a0
	calla	RNDRNG0			;0-7
	sll	5,a0			;x 32 bits
	move	a0,a9
	addi	#random_hints,a0
	move	*a0,a4,L
	calla	print_string_C2

	movi	LN1_setup,a2
	calla	setup_message

	addi	#random_hints2,a9
	move	*a9,a4,L
	calla	print_string2

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	SLEEP	TSEC*2

	movi	7*TSEC,a10
#whopper_with_cheese
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit
	dsj	a10,#whopper_with_cheese
#exit

	SOUND1	bounce_snd

	JSRP	buyin_screen

	movi	CYCPID,a0
	calla	KIL1C

	clr	a0
	move	a0,@IRQSKYE		;background color
	move	a0,@DISPLAYON

;2/9/93
	calla	QSNDRST
 
	SLEEPK	1		;2

;MJT	SLEEPK	2

	calla	system_restoregame

;	movk	INGAME,a0
;	move	a0,@GAMSTATE

	movi	CLSDEAD|creditid,a0
	calla	obj_del1c		;kill credit/qrtr imgs

	.ref	prt_credits
	calla	prt_credits
	.ref	start_msgs
	CREATE0	start_msgs
	.ref	fix_dropout_msgs
	calla	fix_dropout_msgs

;	calla	QSNDRST
;	SLEEPK	2

	RETP


kill_tvpanel
	movi	CLSDEAD|tvid,a0
	calla	obj_del1c
	movi	CLSDEAD|tvscrid,a0
	calla	obj_del1c
	movi	tvid,a0			;Delete big clock at botm of scrn
	calla	KIL1C
	movi	CLSDEAD|bclockid,a0
	calla	obj_del1c

	movi	clockid,a0
	calla	KIL1C 			;Kill existing shot clock proc
	movi	CLSDEAD|clockid,a0
	calla	obj_del1c		;Delete any 24 second shot clock imgs
	.ref	sc_proc
	clr	a0
	move	a0,@sc_proc,L

	move	@tvpanelon,a0,L
	jrz	#x1
	calla	KILL
	clr	a0
	move	a0,@tvpanelon,L
#x1
	rets


#hintpage_mod
	.long	empjambBMOD
	.word	0,1
	.long	0

	.asg	20,LN0

	.asg	120,LN1

heading_setup
	RJR_STR	osgemd_ascii,8,0,200,LN0,BLUE,0
heading2_setup
	RJR_STR	ogmd10_ascii,8,0,200,LN0+50,SGMD8BLU,0
LN1_setup
	RJR_STR	ogmd10_ascii,8,0,35,LN1+5,SGMD8GLD,0

#str_heading
	.string	"coaching tips",0
	.asg	1,CR
	.even

#random_hints
	.long	#str_h0,#str_h1,#str_h2,#str_h3,#str_h4
	.long	#str_h5,#str_h6,#str_h7,#str_h8
	.long	#str_h9,#str_h10,#str_h11,#str_h12
	.long	#str_h13,#str_h14,#str_h15,#str_h16,#str_h17	;,#str_h18
	.long	#str_h19,#str_h20,#str_h21,#str_h22,#str_h23,#str_h24
	.long	#str_h25,#str_h26,#str_h27
	.even

#random_hints2
	.long	#str_h0a,#str_h1a,#str_h2a,#str_h3a,#str_h4a
	.long	#str_h5a,#str_h6a,#str_h7a,#str_h8a
	.long	#str_h9a,#str_h10a,#str_h11a,#str_h12a
	.long	#str_h13a,#str_h14a,#str_h15a,#str_h16a,#str_h17a	;,#str_h18a
	.long	#str_h19a,#str_h20a,#str_h21a,#str_h22a,#str_h23a,#str_h24a
	.long	#str_h25a,#str_h26a,#str_h27a
	.even

#str_h0
	.string	"Substitutions:",0
#str_h0a
	.string	"Some players may become fatigued",1
	.string "during the second half!  Try",1
	.string	"substituting those players with",1
	.string "fresh players at halftime.",1
	.string " ",0

#str_h1
	.string	"Super Dunks:",0
#str_h1a
	.string	"press the turbo and Shoot buttons",1
	.string "while running toward the basket.",1
	.string	" ",1
	.string "remember, some players have more",1
	.string "spectacular dunks than others!",0

#str_h2
	.string	"Head fakes:",0
#str_h2a
	.string	"tap the Shoot button once.  However,",1
	.string	"this also causes you to pick up your",1
	.string	"dribble.  Try faking out CPU Drones!",0

#str_h3
	.string	"Jump shot pass:",0
#str_h3a
	.string	"Press and hold the shoot button,",1
	.string	"then press the pass button.  This",1
	.string	"allows you to dish off to your open",1
	.string	"teammate.  this is most effective",1
	.string	"when you are about to be rejected!",0

#str_h4
	.string	"Accurate jump shot:",0
#str_h4a
	.string	"increase the chances of a jump",1
	.string	"shot going in by releasing the Shoot",1
	.string	"button at the peak of your jump.",1
	.string	" ",1
	.string	"Avoid being rejected by holding on",1
	.string	"to the ball until defender is out",1
	.string	"of position.",0

#str_h5
	.string	"Burst of speed:",0
#str_h5a
	.string	"avoid pesky defenders and increase",1
	.string	"the speed of your player by holding",1
	.string	"down the Turbo button.",0

#str_h6
	.string	"Physical play:",0
#str_h6a
	.string	"clear an opponent out of the way by",1
	.string	"pressing the turbo and steal buttons",1
	.string	"at the same time.",0

#str_h7
	.string	"Clear out:",0
#str_h7a
	.string	"When holding the ball, quickly tap",1
	.string	"the turbo button.  This will cause",1
	.string "the player to throw his elbows.",0

#str_h8
	.string	"Turbo pass:",0
#str_h8a
	.string	"press the turbo and pass buttons at",1
	.string "the same time for a turbo pass.",1
	.string " ",1
	.string "Turbo passes are less likely to be",1
	.string "intercepted by the defense.",0

#str_h9
	.string	"Super jumps:",0
#str_h9a
	.string	"jump extra high when shooting,",1
	.string	"blocking, or rebounding by pressing",1
	.string "the turbo and shoot buttons at the",1
	.string "same time.",0

#str_h10
	.string	"Dunk pass:",0
#str_h10a
	.string	"to avoid having your dunk blocked,",1
	.string "pass off to your open teammate.",1
	.string "This is most effective when your",1
	.string "teammate is open for a three point",1
	.string "attempt!",0
#str_h11
	.string	"Court awareness:",0
#str_h11a
	.string	"locate a player's position when he",1
	.string	"is off screen by watching for his",1
	.string	"arrow.  Try to anticipate his moves.",1
	.string	" ",1
	.string	"When off screen, try to stay away",1
	.string	"from opposing players.",0

#str_h12
	.string	"Smart play:",0
#str_h12a
	.string	"An open player is more likely to",1
	.string	"make a basket, so pass to your open",1
	.string	"teammate whenever possible!",1
	.string	" ",1
	.string	"Try to anticipate your opponent's next",1
	.string	"move before he makes it!",0

#str_h13
	.string	"Secret powerups:",0
#str_h13a
	.string "Ball Players can be powered up with",1
	.string "super human abilities.  Try special",1
	.string	"joystick/button moves during the",1
	.string	"team matchup screen!",0

#str_h14
	.string	"Hot streak:",0
#str_h14a
	.string "When a player scores 3 consecutive",1
	.string "buckets, he is on fire!",1
	.string " ",1
	.string "When a player goes on a Hot Streak,",1
	.string	"give him the ball!  He remains hot",1
	.string	"for several shots, or until the other",1
	.string	"team scores.",0

#str_h15
	.string "Strong defense:",0
#str_h15a
	.string	"decrease the chance of an opponent's",1
	.string	"shot going in the basket by getting",1
	.string	"in his face!",1
	.string	" ",1
	.string	"knock him down and steal the ball!",0

#str_h16
	.string "Drone control:",0
#str_h16a
	.string	"cause a teammate controlled by the",1
	.string	"CPU to shoot or pass by pressing your",1
	.string	"own shoot or pass buttons.",1
	.string	" ",1
	.string	"pass to your drone when he is under",1
	.string	"the hoop for a quick dunk.",0

#str_h17
	.string	"Smart turbo useage:",0
#str_h17a
	.string	"The amount of turbo remaining is",1
	.string	"displayed at the top of the screen.",1
	.string	" ",1
	.string	"all turbo actions deplete this",1
	.string	"amount, so conserve just enough for",1
	.string	"that all important next move!",0

;#str_h18
;	.string	"Alley-Oop Pass:",0
;#str_h18a
;	.string	"When near the hoop, lob the ball",1
;	.string	"toward the hoop by pressing the",1
;	.string	"shoot and pass buttons.",1
;	.string	" ",1
;	.string	"Your teammate must press turbo and",1
;	.string	"shoot while running toward hoop.",1
;	.string	" ",0

#str_h19
	.string	"Power attribute:",0
#str_h19a
	.string	"The greater a player's Power rating,",1
	.string "the harder it is to knock him down",1
	.string	"or to block his dunks.  Try to Avoid",1
	.string "size mismatches. ",1
	.string	" ",1
	.string	"Remember, powerful guys are usually",1
	.string "weak outside players.",0

#str_h20
	.string	"Passing attribute:",0
#str_h20a
	.string	"The greater a player's Pass rating,",1
	.string "the faster he passes.",1
	.string	" ",1
	.string	"It is more difficult to intercept a",1
	.string "quick pass than a slow pass.  You",1
	.string "should always try a turbo pass.",0

#str_h21
	.string	"Blocking attribute:",0
#str_h21a
	.string	"The greater a player's block",1
	.string "rating, the better he is at blocking",1
	.string	"dunks and regular jump shots.",1
	.string	" ",1
	.string	"It is also harder for someone to",1
	.string "drive by him for a dunk.",0

#str_h22
	.string	"Steal attribute:",0
#str_h22a
	.string	"The greater a player's steal rating,",1
	.string "the more effective his swiping",1
	.string	"becomes.  He will also intercept more",1
	.string "passes.",1
	.string	" ",1
	.string	"Smaller, quicker players are very",1
	.string "skilled at taking the ball.",0

#str_h23
	.string	"Dunk attribute:",0
#str_h23a
	.string	"The greater a player's dunk rating,",1
	.string "the more spectacular his dunks.",1
	.string	"A player with a zero dunk rating",1
	.string "will perform just layups.",1
	.string	" ",1
	.string "Layups are generally less successful",1
	.string "than dunks.",0

#str_h24
	.string	"Speed attribute:",0
#str_h24a
	.string	"The greater a player's speed rating,",1
	.string "the faster he moves.  Usually, the",1
	.string	"faster players are less powerful",1
	.string "and therefore get pushed down more.",1
	.string	" ",1
	.string "Match speed against speed.",0

#str_h25
	.string	"Clutch attribute:",0
#str_h25a
	.string	"The greater a player's clutch",1
	.string "rating, the more chance that he will",1
	.string	"make a great play during the last 10",1
	.string "seconds of any period.",0

#str_h26
	.string	"Stats pages:",0
#str_h26a
	.string	"On the stats page, the steals",1
	.string "category includes slap aways and",1
	.string	"knock downs of ball carriers.",1
	.string	" ",1
	.string	"The injured category represents how",1
	.string "many times you were knocked down!",0

#str_h27
	.string	"Player Attributes:",0
#str_h27a
	.string	"For maximum success, pay attention",1
	.string "to your player's strengths and",1
	.string	"weaknesses.  Play big guys near the",1
	.string "hoop, and small guys outside.",1
	.string	" ",1
	.string "Big guys are poor 3 point shooters!",0

	.even



;What's new about the game?
#*****************************************************************************
	.asg	17,YSPACE

 SUBR	new_page

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	SLEEPK	2

	movi	#newpage_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1


	.ref	CYCLE_TABLE,COLTAB2
	movi	[10,7],a8		;START AT COLOR 10, CYCLE 7 COLORS
	movi	BLUE,a9			;PAL NAME
	movi	COLTAB2,a10		;TABLE TO CYCLE WITH
	movk	2,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	movi	#heading_setup,a2
	calla	setup_message
	movi	#str_heading,a4
	calla	print_string_C2

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	movk	12,a0
	move	a0,@mess_line_spacing

	movi	#heading2_setup,a2
	calla	setup_message

	movi	TYPBALL,a0
	move	a0,@mess_objid		;OBJ ID's for text

	SLEEPK	10

	clr	a9
	callr	#txt

	movi	[30,0],a0		;x val
	movi	[>63,0],a1		;y val
	movi	ball11,a2
	movk	1,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPBALL,a5		;OBJ ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	movi	ball101,a0
	move	*a8(OFLAGS),a1
	calla	obj_aniq


	movi	30,a10
	JSRP	time_delay		;SLEEP	30
	SLEEPK	7

	movk	1,a9
	callr	#txt


	movi	[30,0],a0		;x val
	movi	[>8d,0],a1		;y val
	movi	ball11,a2
	movk	1,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPBALL,a5		;OBJ ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	movi	ball101,a0
	move	*a8(OFLAGS),a1
	calla	obj_aniq

	movi	30,a10
	JSRP	time_delay		;SLEEP	30
	SLEEPK	7

	movk	2,a9
	callr	#txt

	movi	[30,0],a0		;x val
	movi	[>b7,0],a1		;y val
	movi	ball11,a2
	movk	1,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPBALL,a5		;OBJ ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	movi	ball101,a0
	move	*a8(OFLAGS),a1
	calla	obj_aniq

	movi	30,a10
	JSRP	time_delay		;SLEEP	30
	SLEEPK	7

	movk	3,a9
	callr	#txt

	movi	[30,0],a0		;x val
	movi	[>e1,0],a1		;y val
	movi	ball11,a2
	movk	1,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPBALL,a5		;OBJ ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	movi	ball101,a0
	move	*a8(OFLAGS),a1
	calla	obj_aniq

	SLEEPK	30

	movi	13*TSEC,a10
#whopper_with_cheese
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit
	dsj	a10,#whopper_with_cheese
#exit

	movi	TYPBALL,a0
	calla	obj_del1c

	movk	12,a0
	move	a0,@mess_line_spacing

	movi	#heading2_setup,a2
	calla	setup_message

	movi	TYPBALL,a0
	move	a0,@mess_objid		;OBJ ID's for text

	movk	4,a9
	callr	#txt

	movi	[30,0],a0		;x val
	movi	[>63,0],a1		;y val
	movi	ball11,a2
	movk	1,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPBALL,a5		;OBJ ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	movi	ball101,a0
	move	*a8(OFLAGS),a1
	calla	obj_aniq


	movi	30,a10
	JSRP	time_delay		;SLEEP	30
	SLEEPK	7

	movk	5,a9
	callr	#txt


	movi	[30,0],a0		;x val
	movi	[>8d,0],a1		;y val
	movi	ball11,a2
	movk	1,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPBALL,a5		;OBJ ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	movi	ball101,a0
	move	*a8(OFLAGS),a1
	calla	obj_aniq

	movi	30,a10
	JSRP	time_delay		;SLEEP	30
	SLEEPK	7

	movk	6,a9
	callr	#txt

	movi	[30,0],a0		;x val
	movi	[>b7,0],a1		;y val
	movi	ball11,a2
	movk	1,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPBALL,a5		;OBJ ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	movi	ball101,a0
	move	*a8(OFLAGS),a1
	calla	obj_aniq

	movi	30,a10
	JSRP	time_delay		;SLEEP	30
	SLEEPK	7

	movi	[30,0],a0		;x val
	movi	[>e1,0],a1		;y val
	movi	ball11,a2
	movk	1,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	movi	TYPBALL,a5		;OBJ ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	movi	ball101,a0
	move	*a8(OFLAGS),a1
	calla	obj_aniq

	movk	7,a9
	callr	#txt

	movi	13*TSEC,a10
#whopper_with_chees
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exi
	dsj	a10,#whopper_with_chees
#exi

      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off

	movi	CYCPID,a0
	calla	KIL1C

	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40

	RETP

time_delay
#whopper_with_chee
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit2
	dsj	a10,#whopper_with_chee
#exit2	RETP


#txt
	move	a9,a0
	sll	5,a0
	addi	#random_hints,a0
	move	*a0,a4,L
	calla	print_string2

	move	a9,a0
	sll	5,a0
	addi	#random_hints2,a0
	move	*a0,a4,L
	calla	print_string2

	move	@mess_cursy,a0
	addk	30,a0
	move	a0,@mess_cursy


	movk	1,a0
	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON
	ADJUST	ADJMUSIC		;GET MUSIC ON OFF FOR DEMO
	MOVE	A0,A0
	JRNZ	#NONO1
	CLR	A0
	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON

	movi	ting_snd,a0
	calla	snd_play1ovr
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off

#NONO1	rets

ting_snd	.word	>f3ff,>8,>80a6,0	;Scroll snd


#newpage_mod
	.long	empjambBMOD
	.word	0,1
	.long	0

	.asg	20,LN0
	.asg	120,LN1

#heading_setup
	RJR_STR	osgemd_ascii,8,0,200,LN0,BLUE,0
#heading2_setup
	RJR_STR	sgmd8_ascii,8,0,60,LN0+60,SGMD8GLD,0

#str_heading
	.string	"Tournament Edition Features:",0
	.asg	1,CR		    
	.even

#random_hints
	.long	#str_h0,#str_h1,#str_h2,#str_h3,#str_h4
	.long	#str_h5,#str_h6,#str_h7

#random_hints2
	.long	#str_h0a,#str_h1a,#str_h2a,#str_h3a,#str_h4a
	.long	#str_h5a,#str_h6a,#str_h7a

	.even

#str_h0
	.string	"Updated team rosters with at least 3 players",1
#str_h0a
	.string "from each team.  25% of NBA now included!",0
	.string	" ",0

#str_h1
	.string	"Player attributes for Power, Blocks, Steals,",1
#str_h1a
	.string "Clutch & Passing.",0
	.string	" ",0

#str_h2
	.string	"Halftime substitutions.  This allows players",1
#str_h2a
	.string	"to solve matchup problems.",0
	.string	" ",0

#str_h3
	.string	"Allow players to choose the same team.  This",1
#str_h3a
	.string	"should help determine the better player!",0
	.string	" ",0

#str_h4
	.string	"Improved gameplay with faster movement, more",1
#str_h4a
	.string	"realistic situations, and more depth.",0
	.string	" ",0

#str_h5
	.string	"More dunks, more secret powerups, more special",1
#str_h5a
	.string	"moves, more speech, more skill!",0
	.string	" ",0

#str_h6
	.string	"Super star matchups & other surprises if you",1
#str_h6a
	.string	"can defeat all 27 teams.",0
	.string	" ",0

#str_h7
	.string	"Tournament mode turns off all powerups and",1
#str_h7a
	.string	"disallows any hidden features.",0
	.string	" ",0


	.even



#*****************************************************************************
*
* INPUT:	a0 = 0	(1st half stats)
*		a0 = 1	(final game stats)
*
*-----------------------------------------------------------------------------

	STRUCTPD
	WORD	HTS_STARTX
	WORD	HTS_STARTY
	APTR	HTS_STATSADDR
	APTR	HTS_PALETTE1
	APTR	HTS_PALETTE2
	APTR	HTS_PALETTE3
	APTR	HTS_PALETTE4
	APTR	HTS_PALETTE5
	APTR	HTS_PALETTE6
	APTR	HTS_PALETTE7
	APTR	HTS_PALETTE8
	APTR	HTS_PALETTE9
	APTR	HTS_PALETTEa


;	.asg	125,STARTX1
	.asg	128,STARTX1
;	.asg	39+1,STARTY1
	.asg	39+1-5,STARTY1

;	.asg	321,STARTX2
	.asg	324,STARTX2
;	.asg	146+1,STARTY2
	.asg	146+1-5,STARTY2
	.asg	11,YSPACING1

 SUBR	stats_page2

	PUSHP	a0
	jruc	#tvout

 SUBR	stats_page

	PUSHP	a0

	movi	4*60,a10

#stop	SLEEPK	1
	dec	a10
	jrz	#tvout
	move	@tvpanelon,a0,L
	jrnz	#stop
#tvout
	callr	kill_tvpanel


	calla	display_blank
	calla	system_savegame

	clr	a0
	move	a0,@dtype		;2D

	movi	4<<10+4<<5+7,a0
	move	a0,@IRQSKYE		;background color

	movk	INPLYRINFO,a0
	move	a0,@GAMSTATE

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	#halftime_mod,a0

	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrs

	movi	#halftime_mod2,a0
#4_plyrs
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	.ref	create_bits
	calla	create_bits

	MOVI	[3,9],a8		;START AT COLOR 3, CYCLE 9 COLORS
	MOVI	SGMD8WHT,a9		;PAL NAME
	MOVI	COLTAB2,a10		;TABLE TO CYCLE WITH
	MOVK	3,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE
 
	MOVI	[3,9],a8		;START AT COLOR 3, CYCLE 9 COLORS
	MOVI	SGMD8VIO,a9		;PAL NAME
	MOVI	COLTABRED,a10		;TABLE TO CYCLE WITH
	MOVK	3,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE
 
	movi	#heading_setup,a2
	calla	setup_message
	PULLP	a0
	movi	#str_heading1,a4
	move	a0,a0
	jrz	#1st_half
	movi	#str_heading2,a4
#1st_half
	calla	print_string_C2


	CREATE0	stats_shadow


	move	@special_heads,a1,L
;	move	@player_toggle1,a0
	PUSH	a0,a1


	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrsb

;	xori	1,a0
;	move	a0,@player_toggle1

	move	@special_heads,a0
	move	@special_heads+10h,a1

	move	a1,@special_heads
	move	a0,@special_heads+10h

#4_plyrsb
	callr	create_heads
	callr	create_names
	callr	create_initials
	PULL	a0,a1
;	move	a0,@player_toggle1
	move	a1,@special_heads,L

	callr	print_scores
	CREATE0	credits2

	movi	[170,0],a0		;x val
	movi	[243,0],a1		;y val
	movi	credbox,a2		;* image
	movi	20000-2,a3		;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2

***********************************************
* player 1

	movi	player_stats+(0*PS_SIZE*10h),a2
	movi	player_stats+(1*PS_SIZE*10h),a3
	movi	player_stats+(2*PS_SIZE*10h),a4
	movi	player_stats+(3*PS_SIZE*10h),a5
	callr	highlight_best

	movi	player_stats + 0*PS_SIZE*10h,a0
	move	a0,*a13(HTS_STATSADDR),L
	movi	STARTX1,a0
	move	a0,*a13(HTS_STARTX)

	movi	STARTY1,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrs_ps1
	movi	STARTY2,a0
#4_plyrs_ps1
	move	a0,*a13(HTS_STARTY)
	callr	print_pstats

***********************************************
* player 2

	movi	player_stats+(1*PS_SIZE*10h),a2
	movi	player_stats+(0*PS_SIZE*10h),a3
	movi	player_stats+(2*PS_SIZE*10h),a4
	movi	player_stats+(3*PS_SIZE*10h),a5
	callr	highlight_best

	movi	player_stats + 1*PS_SIZE*10h,a0
	move	a0,*a13(HTS_STATSADDR),L
	movi	STARTX1,a0
	move	a0,*a13(HTS_STARTX)

	movi	STARTY2,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrs_ps2
	movi	STARTY1,a0
#4_plyrs_ps2
	move	a0,*a13(HTS_STARTY)
	callr	print_pstats

***********************************************
* player 3

	movi	player_stats+(2*PS_SIZE*10h),a2
	movi	player_stats+(0*PS_SIZE*10h),a3
	movi	player_stats+(1*PS_SIZE*10h),a4
	movi	player_stats+(3*PS_SIZE*10h),a5
	callr	highlight_best

	movi	player_stats + 2*PS_SIZE*10h,a0
	move	a0,*a13(HTS_STATSADDR),L
	movi	STARTX2,a0
	move	a0,*a13(HTS_STARTX)
	movi	STARTY1,a0
	move	a0,*a13(HTS_STARTY)
	callr	print_pstats

***********************************************
* player 4

	movi	player_stats+(3*PS_SIZE*10h),a2
	movi	player_stats+(0*PS_SIZE*10h),a3
	movi	player_stats+(1*PS_SIZE*10h),a4
	movi	player_stats+(2*PS_SIZE*10h),a5
	callr	highlight_best

	movi	player_stats + 3*PS_SIZE*10h,a0
	move	a0,*a13(HTS_STATSADDR),L
	movi	STARTX2,a0
	move	a0,*a13(HTS_STARTX)
	movi	STARTY2,a0
	move	a0,*a13(HTS_STARTY)
	callr	print_pstats

***********************************************


	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	SLEEP	TSEC*1

	movi	24*TSEC,a10

#whopper_with_cheese
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit
	dsj	a10,#whopper_with_cheese
#exit

	SOUND1	bounce_snd

	move	@gmqrtr,a0
	cmpi	2,a0
	jrnz	#noth
	JSRP	plyr_subs
#noth
	.ref	buyin_screen
	JSRP	buyin_screen

	clr	a0
	move	a0,@DISPLAYON

;2/9/93
	calla	QSNDRST
	SLEEPK	2

	calla	system_restoregame

;	callr	kill_tvpanel

;	movk	INGAME,a0
;	move	a0,@GAMSTATE

	movi	CLSDEAD|creditid,a0
	calla	obj_del1c		;kill credit/qrtr imgs

	calla	prt_credits

	CREATE0	start_msgs
	calla	fix_dropout_msgs

;	calla	QSNDRST
;	SLEEPK	2

	.ref	gmqrtr
	move	@gmqrtr,a0
	cmpi	4,a0
	jrlt	#notn
	SOUND1	tuneend_snd
#notn

	RETP

 SUBR	plyr_subs

	movi	DMAWNZ,a0
	movi	OBJLST,a1
	jruc	so20

so10	move	a0,*a1(OFLAGS)
so20	move	*a1,a1,L
	jrnz	so10

;	movi	CYCPID,a0
;	calla	KIL1C

	.ref	start_teams

	JSRP	start_teams

	RETP



RGB	.macro	R,G,B
	.word	(:R:<<10) | (:G:<<5) | :B:
	.endm

COLTAB
	.word	07fffh,07bffh,077ffh,073ffh,06fffh
	.word	06bffh,067deh,063deh,05fdeh,05bdeh,057deh,043bdh,033bdh
	.word	01f9ch,00f7bh,0037bh,00f7bh,01b9ch,02b9ch,03bbdh,04bbdh
	.word	05fdeh,063deh,067deh,06bdeh,06fffh,077ffh,07bffh,07fffh

	.word	07fffh,07bffh,077ffh,073ffh,06fffh
	.word	06bffh,067deh,063deh,05fdeh,05bdeh,057deh,043bdh,033bdh
	.word	01f9ch,00f7bh,0037bh,00f7bh,01b9ch,02b9ch,03bbdh,04bbdh
	.word	05fdeh,063deh,067deh,06bdeh,06fffh,077ffh,07bffh,07fffh
	.word	-1

COLTABRED
	.word   07d2ah,07d08h,07cc6h,07ca5h,07c63h,07c42h,07c00h
	.word   07c00h,07c00h,07c42h,07c63h,07c84h,07ca5h,07ce7h,07d08h
	.word   07d29h,07d4ah,07d8ch,07dadh,07dceh,07e10h,07defh,07dceh
	.word   07d8ch,07d6bh,07d4ah,07d29h,07d08h,07ce7h,07cc6h,07ca5h
	.word   07c84h,07c63h,07c42h,07c21h,07c00h,07c00h,07c21h,07c63h
	.word   07ca5h,07ce7h,07d29h,07d6bh,07dadh,07defh,07e31h,07e73h
	.word   07eb5h,07ef7h,07f39h,07f7bh,07fbdh,07fffh,07f9ch,07f39h
	.word   07ef7h,07e94h,07e31h,07defh,07d8ch,07d2ah

	.word   07d2ah,07d08h,07cc6h,07ca5h,07c63h,07c42h,07c00h
	.word   07c00h,07c00h,07c42h,07c63h,07c84h,07ca5h,07ce7h,07d08h
	.word   07d29h,07d4ah,07d8ch,07dadh,07dceh,07e10h,07defh,07dceh
	.word   07d8ch,07d6bh,07d4ah,07d29h,07d08h,07ce7h,07cc6h,07ca5h
	.word   07c84h,07c63h,07c42h,07c21h,07c00h,07c00h,07c21h,07c63h
	.word   07ca5h,07ce7h,07d29h,07d6bh,07dadh,07defh,07e31h,07e73h
	.word   07eb5h,07ef7h,07f39h,07f7bh,07fbdh,07fffh,07f9ch,07f39h
	.word   07ef7h,07e94h,07e31h,07defh,07d8ch,07d2ah
	.WORD	-1

#halftime_mod
	.long	statscrnBMOD		;stats screen
	.word	0,0
	.long	subsBMOD		;substitute players page
	.word	-4,256
	.long	namebox3BMOD		;stats box map
	.word	13-4,>1c1
	.long	0


#halftime_mod2
	.long	statscrkBMOD		;stats screen
	.word	0,0
	.long	subsBMOD		;substitute players page
	.word	-4,256
	.long	namebox4BMOD		;stats box map
	.word	13-4,>1c1
	.long	0

#heading_setup
	RJR_STR	osgemd_ascii,8,0,200,4,WHITEPAL,0
#str_heading1
	.string	"1st half stats:",0
#str_heading2
	.string	"final game stats:",0

	.even

#*****************************************************************************

	.asg	0+45,SX1
	.asg	400-45,SX2

 SUBRP	print_scores

	movi	#score_setup,a2
	calla	setup_message

	movi	SX1,a0
	move	a0,@mess_cursx
	move	@scores,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_C

	movi	SX2,a0
	move	a0,@mess_cursx
	move	@scores+16,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_C

	rets

#score_setup
	RJR_STR	osgemd_ascii,8,0,200,4,GOLD,0

#*****************************************************************************
*
* INPUT:	a2 = * player to check
*		a3 = * other player 1
*		a4 = * other player 2
*		a5 = * other player 3
*
* message_palette = SGMD8YEL default
*		  = SGMD8WHT if highest stat
*
*-----------------------------------------------------------------------------

 SUBRP	highlight_best


	movi	SGMD8YEL,a6
	move	*a2(PS_2PTS_MADE*10h),a0
	move	*a2(PS_3PTS_MADE*10h),a7
	add	a7,a0
;	move	*a2(PS_FREE_MADE*10h),a7
;	add	a7,a0
	jrz	#not_best1

	move	*a3(PS_2PTS_MADE*10h),a1
	move	*a3(PS_3PTS_MADE*10h),a7
	add	a7,a1
;	move	*a3(PS_FREE_MADE*10h),a7
;	add	a7,a1
	cmp	a1,a0
	jrlo	#not_best1

	move	*a4(PS_2PTS_MADE*10h),a1
	move	*a4(PS_3PTS_MADE*10h),a7
	add	a7,a1
;	move	*a4(PS_FREE_MADE*10h),a7
;	add	a7,a1
	cmp	a1,a0
	jrlo	#not_best1

	move	*a5(PS_2PTS_MADE*10h),a1
	move	*a5(PS_3PTS_MADE*10h),a7
	add	a7,a1
;	move	*a5(PS_FREE_MADE*10h),a7
;	add	a7,a1
	cmp	a1,a0
	jrlo	#not_best1

	movi	SGMD8WHT,a6
#not_best1
	move	a6,*a13(HTS_PALETTE1),L


	movi	SGMD8YEL,a6
	move	*a2(PS_3PTS_MADE*10h),a0
	jrz	#not_best2
	move	*a3(PS_3PTS_MADE*10h),a1
	cmp	a1,a0
	jrlo	#not_best2
	move	*a4(PS_3PTS_MADE*10h),a1
	cmp	a1,a0
	jrlo	#not_best2
	move	*a5(PS_3PTS_MADE*10h),a1
	cmp	a1,a0
	jrlo	#not_best2
	movi	SGMD8WHT,a6
#not_best2
	move	a6,*a13(HTS_PALETTE2),L


;	movi	SGMD8YEL,a6
;	move	*a2(PS_FREE_MADE*10h),a0
;	jrz	#not_best3
;	move	*a3(PS_FREE_MADE*10h),a1
;	cmp	a1,a0
;	jrlo	#not_best3
;	move	*a4(PS_FREE_MADE*10h),a1
;	cmp	a1,a0
;	jrlo	#not_best3
;	move	*a5(PS_FREE_MADE*10h),a1
;	cmp	a1,a0
;	jrlo	#not_best3
;	movi	SGMD8WHT,a6
;#not_best3
;	move	a6,*a13(HTS_PALETTE3),L



	movi	SGMD8YEL,a6
	move	*a2(PS_2PTS_MADE*10h),a0
;	move	*a2(PS_FREE_MADE*10h),a7
;	add	a7,a0
	move	*a2(PS_3PTS_MADE*10h),a7
	add	a7,a0
	sll	1,a0				;x 2
	add	a7,a0				;3 pts
	jrz	#not_best4

	move	*a3(PS_2PTS_MADE*10h),a1
;	move	*a3(PS_FREE_MADE*10h),a7
;	add	a7,a1
	move	*a3(PS_3PTS_MADE*10h),a7
	add	a7,a1
	sll	1,a1				;x 2
	add	a7,a1				;3 pts
	cmp	a1,a0
	jrlo	#not_best4

	move	*a4(PS_2PTS_MADE*10h),a1
;	move	*a4(PS_FREE_MADE*10h),a7
;	add	a7,a1
	move	*a4(PS_3PTS_MADE*10h),a7
	add	a7,a1
	sll	1,a1				;x 2
	add	a7,a1				;3 pts
	cmp	a1,a0
	jrlo	#not_best4

	move	*a5(PS_2PTS_MADE*10h),a1
;	move	*a5(PS_FREE_MADE*10h),a7
;	add	a7,a1
	move	*a5(PS_3PTS_MADE*10h),a7
	add	a7,a1
	sll	1,a1				;x 2
	add	a7,a1				;3 pts
	cmp	a1,a0
	jrlo	#not_best4

	movi	SGMD8WHT,a6
#not_best4
	move	a6,*a13(HTS_PALETTE4),L



	movi	SGMD8YEL,a6
	move	*a2(PS_DUNKS_MADE*10h),a0
	jrz	#not_best5
	move	*a3(PS_DUNKS_MADE*10h),a1
	cmp	a1,a0
	jrlo	#not_best5
	move	*a4(PS_DUNKS_MADE*10h),a1
	cmp	a1,a0
	jrlo	#not_best5
	move	*a5(PS_DUNKS_MADE*10h),a1
	cmp	a1,a0
	jrlo	#not_best5
	movi	SGMD8WHT,a6
#not_best5
	move	a6,*a13(HTS_PALETTE5),L


	movi	SGMD8YEL,a6
	move	*a2(PS_ASSISTS*10h),a0
	jrz	#not_best6
	move	*a3(PS_ASSISTS*10h),a1
	cmp	a1,a0
	jrlo	#not_best6
	move	*a4(PS_ASSISTS*10h),a1
	cmp	a1,a0
	jrlo	#not_best6
	move	*a5(PS_ASSISTS*10h),a1
	cmp	a1,a0
	jrlo	#not_best6
	movi	SGMD8WHT,a6
#not_best6
	move	a6,*a13(HTS_PALETTE6),L


	movi	SGMD8YEL,a6
	move	*a2(PS_STEALS*10h),a0
	jrz	#not_best7
	move	*a3(PS_STEALS*10h),a1
	cmp	a1,a0
	jrlo	#not_best7
	move	*a4(PS_STEALS*10h),a1
	cmp	a1,a0
	jrlo	#not_best7
	move	*a5(PS_STEALS*10h),a1
	cmp	a1,a0
	jrlo	#not_best7
	movi	SGMD8WHT,a6
#not_best7
	move	a6,*a13(HTS_PALETTE7),L


	movi	SGMD8YEL,a6
	move	*a2(PS_BLOCKS*10h),a0
	jrz	#not_best8
	move	*a3(PS_BLOCKS*10h),a1
	cmp	a1,a0
	jrlo	#not_best8
	move	*a4(PS_BLOCKS*10h),a1
	cmp	a1,a0
	jrlo	#not_best8
	move	*a5(PS_BLOCKS*10h),a1
	cmp	a1,a0
	jrlo	#not_best8
	movi	SGMD8WHT,a6
#not_best8
	move	a6,*a13(HTS_PALETTE8),L


	movi	SGMD8YEL,a6
	move	*a2(PS_OFF_REB*10h),a0
	move	*a2(PS_DEF_REB*10h),a7
	add	a7,a0
	jrz	#not_best9

	move	*a3(PS_OFF_REB*10h),a1
	move	*a3(PS_DEF_REB*10h),a7
	add	a7,a1
	cmp	a1,a0
	jrlo	#not_best9
	move	*a4(PS_OFF_REB*10h),a1
	move	*a4(PS_DEF_REB*10h),a7
	add	a7,a1
	cmp	a1,a0
	jrlo	#not_best9
	move	*a5(PS_OFF_REB*10h),a1
	move	*a5(PS_DEF_REB*10h),a7
	add	a7,a1
	cmp	a1,a0
	jrlo	#not_best9
	movi	SGMD8WHT,a6
#not_best9
	move	a6,*a13(HTS_PALETTE9),L


	movi	SGMD8YEL,a6
	move	*a2(PS_INJURY*10h),a0
	jrz	#not_besta
	move	*a3(PS_INJURY*10h),a1
	cmp	a1,a0
	jrlo	#not_besta
	move	*a4(PS_INJURY*10h),a1
	cmp	a1,a0
	jrlo	#not_besta
	move	*a5(PS_INJURY*10h),a1
	cmp	a1,a0
	jrlo	#not_besta
	movi	SGMD8VIO,a6
#not_besta
	move	a6,*a13(HTS_PALETTEa),L


	rets


#*****************************************************************************

	.asg	65,HEAD_WIDTH
	.asg	10,HEDX1
	.asg	206,HEDX2
	.asg	99,HEDY1
	.asg	206,HEDY2

 SUBRP	create_heads

;	move	@team1,a10
;	cmpi	26,a10
;	jrls	#ok1
;	clr	a10
;#ok1
	movi	player_heads,a10
	move	@team1,a2
#lp	cmpi	0,a2
	jrz	#out
	addi	20*64,a10
	dec	a2
	jruc	#lp	
#out
	move	@team1,a0
	sll	4,a0
	addi	tm1set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10
;	sll	6,a10			;x 2 x 32 bits
;	addi	player_heads,a10


	move	*a10,a2,L		;image addr
;	move	@player_toggle1,a0
;	jrz	#not1
;	move	*a10(20h),a2,L		;image addr
;#not1
	move	@special_heads,a0
	jrn	#no_spec1
	sll	5,a0			;x 32 bits
	addi	our_heads,a0
	move	*a0,a2,L
#no_spec1
	movi	[HEDX1,0],a0		;x val
	movi	[HEDY1,0],a1		;y val
	movi	120,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	callr	#clippit

	move	*a10(20h),a2,L		;image addr
;	move	@player_toggle1,a0
;	jrz	#not2
;	move	*a10,a2,L		;image addr
;#not2
	move	@special_heads+10h,a0
	jrn	#no_spec2
	sll	5,a0			;x 32 bits
	addi	our_heads,a0
	move	*a0,a2,L
#no_spec2
	movi	[HEDX1,0],a0		;x val
	movi	[HEDY2,0],a1		;y val
	movi	120,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	callr	#clippit


;	move	@team2,a10
;	cmpi	26,a10
;	jrls	#ok2
;	clr	a10
;#ok2
;	sll	6,a10			;x 2 x 32 bits
;	addi	player_heads,a10


	movi	player_heads,a10
	move	@team2,a2
#lp1	cmpi	0,a2
	jrz	#out1
	addi	20*64,a10
	dec	a2
	jruc	#lp1
#out1
	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10



	move	*a10,a2,L		;image addr
;	move	@player_toggle2,a0
;	jrz	#not3
;	move	*a10(20h),a2,L		;image addr
;#not3
	move	@special_heads+20h,a0
	jrn	#no_spec3
	sll	5,a0			;x 32 bits
	addi	our_heads,a0
	move	*a0,a2,L
#no_spec3

	movi	[HEDX2,0],a0		;x val
	movi	[HEDY1,0],a1		;y val
	movi	120,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	callr	#clippit

	move	*a10(20h),a2,L		;image addr
;	move	@player_toggle2,a0
;	jrz	#not4
;	move	*a10,a2,L		;image addr
;#not4
	move	@special_heads+30h,a0
	jrn	#no_spec4
	sll	5,a0			;x 32 bits
	addi	our_heads,a0
	move	*a0,a2,L
#no_spec4

	movi	[HEDX2,0],a0		;x val
	movi	[HEDY2,0],a1		;y val
	movi	120,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ2
	callr	#clippit
#cnt4a

	rets

#clippit
	move	*a8(OSIZEX),a0
	subi	HEAD_WIDTH,a0
	jrb	#no_clip
	move	a0,*a8(OFSET)
#no_clip
	rets

#*****************************************************************************

	.asg	45,X1
	.asg	240,X2
	.asg	101,Y1
	.asg	208,Y2
	.asg	12,YOFF1

 SUBRP	create_initials

	movi	#initials_setup,a2
	calla	setup_message

	movi	Y1+YOFF1,a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#not_2a
	movi	Y2+YOFF1,a0
#not_2a
	move	a0,@mess_cursy

	movi	X1,a0
	move	a0,@mess_cursx
	move	@PSTATUS,a0
	btst	0,a0
	jrnz	#ok1
	movi	#str_cpu,a4
	calla	print_string_C2
	jruc	#skip1
#ok1
	movi	message_buffer,a3
	movi	player1_data+PR_INIT1,a4
	calla	get_initials_string
	calla	print_string_C
#skip1


	movi	Y2+YOFF1,a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#not_2b
	movi	Y1+YOFF1,a0
#not_2b
	move	a0,@mess_cursy

	movi	X1,a0
	move	a0,@mess_cursx
	move	@PSTATUS,a0
	btst	1,a0
	jrnz	#ok2
	movi	#str_cpu,a4
	calla	print_string_C2
	jruc	#skip2
#ok2
	movi	message_buffer,a3
	movi	player2_data+PR_INIT1,a4
	calla	get_initials_string
	calla	print_string_C
#skip2


	movi	Y1+YOFF1,a0
	move	a0,@mess_cursy
	movi	X2,a0
	move	a0,@mess_cursx
	move	@PSTATUS,a0
	btst	2,a0
	jrnz	#ok3
	movi	#str_cpu,a4
	calla	print_string_C2
	jruc	#skip3
#ok3
	movi	message_buffer,a3
	movi	player3_data+PR_INIT1,a4
	calla	get_initials_string
	calla	print_string_C
#skip3


	movi	Y2+YOFF1,a0
	move	a0,@mess_cursy
	movi	X2,a0
	move	a0,@mess_cursx
	move	@PSTATUS,a0
	btst	3,a0
	jrnz	#ok4
	movi	#str_cpu,a4
	calla	print_string_C2
	jruc	#skip4
#ok4
	movi	message_buffer,a3
	movi	player4_data+PR_INIT1,a4
	calla	get_initials_string
	calla	print_string_C
#skip4
	rets


#initials_setup
	RJR_STR	osgemd_ascii,8,1,200,4,GOLD,0
#str_cpu
	.string	"CPU",0
	.even

	.ref	tm1set,tm2set

#*****************************************************************************

 SUBRP	create_names

;	move	@team1,a10
;	cmpi	26,a10
;	jrls	#ok1
;	clr	a10
;#ok1
;	sll	6,a10				;x 2 x 32 bits
;	addi	player_names,a10		;start of names

	movi	player_names,a10
	move	@team1,a2
#lp	cmpi	0,a2
	jrz	#out
	addi	20*64,a10
	dec	a2
	jruc	#lp	
#out
	move	@team1,a0
	sll	4,a0
	addi	tm1set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10

	move	*a10,a2,L			;image addr
;	move	@player_toggle1,a0
;	jrz	#not1
;	move	*a10(20h),a2,L			;* image
;#not1
	move	@special_heads,a0
	jrn	#not_spec1
	sll	5,a0				;x 32 bits
	addi	our_names,a0
	move	*a0,a2,L
#not_spec1

	movi	[X1,0],a0			;x val
	movi	[Y1,0],a1			;y val
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

	move	*a10(20h),a2,L			;image addr
;	move	@player_toggle1,a0
;	jrz	#not2
;	move	*a10,a2,L			;* image
;#not2
	move	@special_heads+10h,a0
	jrn	#not_spec2
	sll	5,a0				;x 32 bits
	addi	our_names,a0
	move	*a0,a2,L
#not_spec2
	movi	[X1,0],a0			;x val
	movi	[Y2,0],a1			;y val
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2


;	move	@team2,a10
;	cmpi	26,a10
;	jrls	#ok2
;	clr	a10
;#ok2
;	sll	6,a10				;x 2 x 32 bits
;	addi	player_names,a10		;start of names



	movi	player_names,a10
	move	@team2,a2
#lp1	cmpi	0,a2
	jrz	#out1
	addi	20*64,a10
	dec	a2
	jruc	#lp1
#out1
	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10



	move	*a10,a2,L			;image addr
;	move	@player_toggle2,a0
;	jrz	#not3
;	move	*a10(20h),a2,L			;* image
;#not3
	move	@special_heads+20h,a0
	jrn	#not_spec3
	sll	5,a0				;x 32 bits
	addi	our_names,a0
	move	*a0,a2,L
#not_spec3

	movi	[X2,0],a0			;x val
	movi	[Y1,0],a1			;y val
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

	move	*a10(20h),a2,L			;image addr
;	move	@player_toggle2,a0
;	jrz	#not4
;	move	*a10,a2,L			;* image
;#not4
	move	@special_heads+30h,a0
	jrn	#not_spec4
	sll	5,a0				;x 32 bits
	addi	our_names,a0
	move	*a0,a2,L
#not_spec4
	movi	[X2,0],a0			;x val
	movi	[Y2,0],a1			;y val
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

	rets


#*****************************************************************************

 SUBRP	stats_shadow

#SHAD1	equ	PDATA
#SHAD2	equ	#SHAD1+20h
#SHAD3	equ	#SHAD2+20h
#SHAD4	equ	#SHAD3+20h

	.asg	46-3,SHADXOFF
;	.asg	6,SHADYOFF
 	.asg	6+5,SHADYOFF

	movi	[STARTX1-SHADXOFF,0],a0	;x val
	movi	[STARTY1-SHADYOFF,0],a1	;y val
	movi	stshad1,a2		;* image
	movi	300,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ
	move	a8,*a13(#SHAD1),L

	movi	[STARTX2-SHADXOFF,0],a0	;x val
	movi	[STARTY1-SHADYOFF,0],a1	;y val
	movi	stshad1,a2		;* image
	movi	300,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ
	move	a8,*a13(#SHAD2),L

	movi	[STARTX1-SHADXOFF,0],a0	;x val
	movi	[STARTY2-SHADYOFF,0],a1	;y val
	movi	stshad1,a2		;* image
	movi	300,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ
	move	a8,*a13(#SHAD3),L

	movi	[STARTX2-SHADXOFF,0],a0	;x val
	movi	[STARTY2-SHADYOFF,0],a1	;y val
	movi	stshad1,a2		;* image
	movi	300,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJ
	move	a8,*a13(#SHAD4),L

	clr	a10
#big_mac
	SLEEPK	1
	xori	1,a10

	move	a10,a0
	sll	5,a0			;x 32 bits
	addi	#shadows,a0
	move	*a0,a11,L		;* image

	move	*a13(#SHAD1),a8,L
	callr	#change_shad
	move	*a13(#SHAD2),a8,L
	callr	#change_shad
	move	*a13(#SHAD3),a8,L
	callr	#change_shad
	move	*a13(#SHAD4),a8,L
	callr	#change_shad

	jruc	#big_mac

#change_shad
	move	a11,a0
	move	*a8(OCTRL),a1		;DMA flags
	calla	obj_aniq		;change object image
	rets


#shadows
	.long	stshad1,stshad2

#*****************************************************************************

	.asg	18,COLOFF1
	.asg	67,COLOFF2

 SUBRP	print_pstats

	movi	#stats_setup,a2
	calla	setup_message


***	all shots made / all shots taken	percentage

	move	*a13(HTS_PALETTE1),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_shots,a4
	calla	print_string_R2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_2PTS_MADE*10h),a0
	move	*a10(PS_3PTS_MADE*10h),a2
	add	a2,a0
	PUSH	a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1,a0
	move	a0,@mess_cursx
	movi	#str_slash,a4
	calla	print_string2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_2PTS_TRY*10h),a0
	move	*a10(PS_3PTS_TRY*10h),a3
	add	a3,a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string


	move	*a13(HTS_STARTX),a0
	addi	COLOFF2,a0

;MJT
	subk	3,a0
	
	move	a0,@mess_cursx
	PULL	a3			;total points scored
	movi	100,a0
	mpyu	a0,a3
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_2PTS_TRY*10h),a0
	move	*a10(PS_3PTS_TRY*10h),a1
	add	a1,a0
	jrz	#zippo1
	divu	a0,a3
	move	a3,a0
#zippo1
	movi	100,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	#str_pct,a4
	calla	concat_rom_string
	calla	print_string_R



***	3pt shots made / 3pt shots taken	percentage

	move	*a13(HTS_PALETTE2),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	1*YSPACING1,a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_3pts,a4
	calla	print_string_R2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_3PTS_MADE*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1,a0
	move	a0,@mess_cursx
	movi	#str_slash,a4
	calla	print_string2


	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_3PTS_TRY*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string


	move	*a13(HTS_STARTX),a0
	addi	COLOFF2,a0

;MJT
	subk	3,a0
	
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_3PTS_MADE*10h),a3
	movi	100,a0
	mpyu	a0,a3
	move	*a10(PS_3PTS_TRY*10h),a0
	jrz	#zippo2
	divu	a0,a3
	move	a3,a0
#zippo2
	movi	100,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	#str_pct,a4
	calla	concat_rom_string
	calla	print_string_R


 	.if 0
***	free throws made / free throws taken	percentage


	move	*a13(HTS_PALETTE3),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	2*YSPACING1,a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_free,a4
	calla	print_string_R2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_FREE_MADE*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1,a0
	move	a0,@mess_cursx
	movi	#str_slash,a4
	calla	print_string2


	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_FREE_TRY*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string


	move	*a13(HTS_STARTX),a0
	addi	COLOFF2,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_FREE_MADE*10h),a3
	movi	100,a0
	mpyu	a0,a3
	move	*a10(PS_FREE_TRY*10h),a0
	jrz	#zippo3
	divu	a0,a3
	move	a3,a0
#zippo3
	movi	100,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	#str_pct,a4
	calla	concat_rom_string
	calla	print_string_R
 	.endif


***	total points


	move	*a13(HTS_PALETTE4),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	2*YSPACING1,a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_points,a4
	calla	print_string_R2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_FREE_MADE*10h),a6
	move	*a10(PS_2PTS_MADE*10h),a0
	sll	1,a0			;X 2
	add	a0,a6
	move	*a10(PS_3PTS_MADE*10h),a0
	add	a0,a6
	sll	1,a0			;X 2
	add	a6,a0
	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R



***	dunks

	move	*a13(HTS_PALETTE5),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	3*YSPACING1,a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_dunks,a4
	calla	print_string_R2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_DUNKS_MADE*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R



***	assists

	move	*a13(HTS_PALETTE6),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	4*YSPACING1,a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_assists,a4
	calla	print_string_R2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_ASSISTS*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R



***	steals

	move	*a13(HTS_PALETTE7),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	5*YSPACING1,a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_steals,a4
	calla	print_string_R2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_STEALS*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R



***	blocks

	move	*a13(HTS_PALETTE8),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	6*YSPACING1,a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_blocks,a4
	calla	print_string_R2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_BLOCKS*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R



***	rebounds
	move	*a13(HTS_PALETTE9),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	7*YSPACING1,a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_rebounds,a4
	calla	print_string_R2


	move	*a13(HTS_STARTX),a0
	addi	COLOFF1,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_OFF_REB*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1,a0
	move	a0,@mess_cursx
	movi	#str_slash,a4
	calla	print_string2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_DEF_REB*10h),a0
	move	*a10(PS_OFF_REB*10h),a1
	add	a1,a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string

***	injury

	move	*a13(HTS_PALETTEa),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	8*YSPACING1,a0
	move	a0,@mess_cursy
	move	*a13(HTS_STARTX),a0
	move	a0,@mess_cursx
	movi	#str_injury,a4
	calla	print_string_R2

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_INJURY*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R


	rets


#stats_setup
	RJR_STR	sgmd8_ascii,4,0,200,LN0,SGMD8YEL,0

#str_plyrstats
	.string	8fh,0

#str_shots
	.string	08h,0
#str_3pts
	.string	09h,0
#str_free
	.string	0ah,0
#str_points
	.string	0bh,0
#str_dunks
	.string	0ch,0
#str_assists
	.string	0dh,0
#str_steals
	.string	0eh,0
#str_blocks
	.string	0fh,0
#str_rebounds
	.string	10h,0
#str_injury
	.string	11h,0
#str_slash
	.string	"/",0
#str_pct
	.string	"%",0
#str_off
	.string	" O / ",0
#str_def
	.string	" D",0
	.even

#*****************************************************************************

	.asg	8,#NOINITOFF
	.asg	21,#OFF1
	.asg	12,#SGMDYSPC
	.asg	33,#WLOFF
	.asg	160,#COL1
	.asg	210,#COL2
	.asg	4,#ROFF1

 SUBR	rank_screen


	move	@PSTATUS,a0			;if nobody has entered their
	btst	0,a0				;initials, then skip this
	jrz	#nop1
	move	@player1_data+PR_INIT1,a0
	jrnn	#have_initials
#nop1
	move	@PSTATUS,a0
	btst	1,a0
	jrz	#nop2
	move	@player2_data+PR_INIT1,a0
	jrnn	#have_initials
#nop2
	move	@PSTATUS,a0
	btst	2,a0
	jrz	#nop3
	move	@player3_data+PR_INIT1,a0
	jrnn	#have_initials
#nop3
	move	@PSTATUS,a0
	btst	3,a0
	jrz	#nop4
	move	@player4_data+PR_INIT1,a0
	jrnn	#have_initials
#nop4
	RETP

#have_initials

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	movi	4<<10+4<<5+7,a0
	move	a0,@IRQSKYE		;background color

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	movk	INPLYRINFO,a0
	move	a0,@GAMSTATE

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	#rank_mod,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not_2a
	movi	#rank_kit_mod,a0
#not_2a
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	.ref	create_bits2
	calla	create_bits2

	MOVI	[3,9],a8		;START AT COLOR 3, CYCLE 9 COLORS
	MOVI	SGMD8PLV,a9		;PAL NAME
	MOVI	COLTAB,a10		;TABLE TO CYCLE WITH
	MOVK	3,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	CREATE0	credits3

;	movi	#heading_setup,a2
;	calla	setup_message
;	movi	#str_heading,a4
;	calla	print_string_C2


	movk	1,a10
	callr	print_column
	movk	2,a10
	callr	print_column

	movi	#rank_mod,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrnz	#is_2

	clr	a10
	callr	print_column
	movk	3,a10
	callr	print_column
#is_2


	SLEEPK	2
	calla	display_unblank

	movi	10*TSEC,a10
#whopper_with_cheese
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit
	dsj	a10,#whopper_with_cheese
#exit
	SLEEPK	1

	RETP

#rank_mod
	.long	selbackBMOD
	.word	0,2
	.long	namebox2BMOD
	.word	9,207-14
	.long	0

#rank_kit_mod
	.long	selbackkBMOD
	.word	0,2
	.long	nameboxkBMOD
	.word	9,207-14
	.long	0


	.asg	22,RANKY
	.asg	38,RECY
	.asg	48+1,WLY
	.asg	58+2,PCTY

	.asg	77,STREAKY1
	.asg	87,STREAKY2

	.asg	105,HAVDEFY1
	.asg	115,HAVDEFY2
	.asg	125,HAVDEFY3
	.asg	135,HAVDEFY4

	.asg	154,NEXTY1
	.asg	164,NEXTY2
	.asg	175+2,NEXTY3

	.asg	213-7,INITY

#heading_setup
	RJR_STR	osgemd_ascii,8,0,200,6,GREENPAL,0
#initials_setup1
	RJR_STR	osgemd_ascii,5,2,94,6,GOLD,0
#rank_setup1
	RJR_STR	osgmd8_ascii,3,0,0,RANKY,SGMD8WHT,0
#initials_setup2
	RJR_STR	sgmd8_ascii,8,0,160,6,SGMD8YEL,0
#initials_setup3
	RJR_STR	sgmd8_ascii,3,0,267,0,SGMD8YEL,0
#initials_setup4
	RJR_STR	sgmd8_ascii,3,0,340,0,SGMD8YEL,0

#noinits_setup
	RJR_STR	osgemd_ascii,8,0,200,6,GOLD,0
#str_heading
	.string	"New Player Stats:",0
#str_abc
	.string	"ABC",0
#str_noinit
	.string	"NO INITIALS ENTERED",0
#str_cpu
	.string	"CPU",0
#str_num
	.string	"#",0
#str_rank
	.string	80h,0		;"RANK #"
#str_record
	.string	81h,0		;"RECORD: "
#str_w	.string 8ah," - ",0	;" (W) - "
#str_l	.string	8bh,0		;"(L)"

#str_pct
	.string	83h,"  .",0	;"PCT: ."
#str_pct100
	.string	83h,"  1.000",0	;"PCT: 1.000"
#str_streak
	.string	"STREAK:",0
#str_win
	.string	" WIN",0
#str_wins
	.string	" WINS",0
#str_none
	.string	"NONE",0
#str_next
	.string	"next cpu",0
#str_vs
	.string	"opponent:",0

;#str_rating
;	.string	"RATING:",0
;#str_fag
;	.string	"FAG BOY",0
;
;	.even
;#rankings
;	.long	#str_r0,#str_r1
;	.long	#str_r2,#str_r3
;	.even
;#str_r0
;	.string	"ALL STAR",0
;#str_r1
;	.string	"ROOKIE",0
;#str_r2
;	.string	"SUPERSTAR",0
;#str_r3
;	.string	"BENCH WARMER",0

#str_hd0	.string	87h,0		;"YOU HAVE"
#str_hd1	.string 85h,' ',0	;"DEFEATED XX"
#str_hd2	.string	88h,0		;"OF THE 27"
#str_hd3	.string	89h,0		;"NBA TEAMS"
#str_all	.string	" ",8ch,0	;" ALL"
#str_dash	.string	"-",0


	.even

#pdatas
	.long	player1_data
	.long	player2_data
	.long	player3_data
	.long	player4_data

#center_xs
	.word	52,56,	0,0		;player 1
	.word	149,145,101,0		;player 2
	.word	246,250,295,0		;player 3
	.word	343,339,0,0		;player 4


;a10  = player number (0-3)
print_column

	move	@PSTATUS2,a0
	btst	a10,a0
	jrz	#cpu_player

	move	a10,a0
	sll	5,a0			;x 32 bits
	addi	#pdatas,a0
	move	*a0,a11,L

	move	*a11(PR_INIT1),a0
	jrn	#no_initials

	movi	#initials_setup1,a2
	calla	setup_message

	move	a10,a0
	sll	6,a0			;x16x4
	addi	#center_xs+10h,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not_2c
	addi	10h,a0
#not_2c
	move	*a0,a0
	move	a0,@mess_cursx

	movi	INITY,a0
	move	a0,@mess_cursy
	movi	message_buffer,a3
	move	a11,a4
	addi	PR_INIT1,a4
	calla	get_initials_string
	calla	print_string_C


	movi	#rank_setup1,a2
	calla	setup_message

	move	a10,a0
	sll	6,a0			;x16x4
	addi	#center_xs,a0
	movi	Stats,a2		;* image
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not_2d
	addi	20h,a0
	movi	Stats_B,a2
#not_2d
	move	*a0,a0

	move	a0,@mess_cursx
	sll	16,a0
	movi	[4,0],a1		;y val
	movk	1,a3			;z pos
	movi	DMAWNZ,a4		;DMA flags
	clr	a5			;OBJ ID
	clr	a6			;x vel
	clr	a7			;y vel
	PUSH	a10,a11
	calla	BEGINOBJ2		;create "stats" heading
	PULL	a10,a11


	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	movi	#str_rank,a4
	callr	copy_rom_string
	move	*a11(PR_RANK),a0	;rank
	cmpi	10,a0
	jrgt	#notten
	movi	SGMD8PLV,a1		;highlight cycle colour
	move	a1,@message_palette,L
#notten
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	concat_string
	callr	print_string_C		;centered


	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	RECY,a0
	move	a0,@mess_cursy
	movi	#str_record,a4		;"RECORD:"
	callr	print_string_C2		;centered


	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	movi	WLY,a0
	move	a0,@mess_cursy
	move	*a11(PR_WON),a0		;games won
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	copy_string
	movi	#str_w,a4
	callr	concat_rom_string
	move	*a11(PR_LOST),a0	;games lost
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	concat_string
	movi	#str_l,a4
	callr	concat_rom_string
	callr	print_string_C		;centered


	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	PCTY,a0
	move	a0,@mess_cursy		;message cursor pos Y
	move	*a11(PR_LOST),a2	;games lost
	jrz	#no_losses
; % < 1000
	movi	#str_pct,a4		;"PCT: ."
	callr	copy_rom_string
	move	*a11(PR_LOST),a2	;games lost
	move	*a11(PR_WON),a1		;games won
	add	a1,a2			;total games
	movi	1000,a0
	mpys	a0,a1			;games won * 1000
	divs	a2,a1			;/ total games
	move	a1,a0
	callr	dec_to_pct
	callr	concat_string
	callr	print_string_C		;centered
	jruc	#skip_loss

#no_losses
	movi	#str_pct100,a4		;"PCT: 1.000"
	callr	print_string_C2		;centered
#skip_loss


	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	move	*a11(PR_WINSTREAK),a0	;no. consecutive wins
	cmpi	3,a0
	jrlt	#no_hilght
	movi	SGMD8PLV,a1		;highlight cycle colour
	move	a1,@message_palette,L
#no_hilght

	movi	STREAKY1,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_streak,a4
	callr	print_string_C2

	movi	STREAKY2,a0
	move	a0,@mess_cursy		;message cursor pos Y
	move	*a11(PR_WINSTREAK),a0	;no. consecutive wins
	jrnz	#not0
	movi	#str_none,a4
	callr	print_string_C2
	jruc	#contws
#not0
	PUSH	a0
	movi	99,a1			;max value
	callr	dec_to_asc
	callr	copy_string
	PULL	a0
	movi	#str_wins,a4
	dec	a0
	jrnz	#iswins
	movi	#str_win,a4
#iswins
	callr	concat_rom_string
	callr	print_string_C
#contws


	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	HAVDEFY1,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_hd0,a4		;"YOU HAVE"
	callr	print_string_C2		;centered

	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	movi	HAVDEFY2,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_hd1,a4		;"DEFEATED NN"
	callr	copy_rom_string

	move	*a11(PR_NUMDEF),a0	;number teams defeated
	cmpi	27,a0
	jrlo	#not_all

	movi	#str_all,a4		;" ALL"
	callr	concat_rom_string
	jruc	#skipit
#not_all
	movi	27,a1			;max value

	callr	dec_to_asc
	callr	concat_string
#skipit
	callr	print_string_C		;centered
	movi	SGMD8PLY,a0
	move	a0,@message_palette,L

	movi	HAVDEFY3,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_hd2,a4		;"OF THE 27"
	callr	print_string_C2		;centered

	movi	HAVDEFY4,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_hd3,a4		;"NBA TEAMS"
	callr	print_string_C2		;centered


	move	*a11(PR_NUMDEF),a0	;number teams defeated
	cmpi	27,a0
	jreq	#defeated_all

	movi	NEXTY1,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_next,a4
	callr	print_string_C2

	movi	NEXTY2,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_vs,a4
	callr	print_string_C2


	movi	SGMD8WHT,a0
	move	a0,@message_palette,L

	movi	NEXTY3,a0
	move	a0,@mess_cursy		;message cursor pos Y

	move	*a11(PR_TEAMSDEF),a1,L
	andi	07ffffffh,a1
	calla	get_opponent_team
	move	a2,a0
	addi	90h,a0			;asc table cities start offset
	movb	a0,@message_buffer+00h
	clr	a0
	movb	a0,@message_buffer+08h
	callr	print_string_C

#defeated_all
#no_initials
	rets


#cpu_player

 	.if 0
	movi	#initials_setup1,a2
	calla	setup_message

	move	a10,a0
	sll	5,a0			;x16x2
	addi	#center_xs+10h,a0
	move	*a0,a0
	move	a0,@mess_cursx

	movi	INITY,a0
	move	a0,@mess_cursy
	movi	#str_cpu,a4
	calla	print_string_C2
	
	.endif
	
	rets


#*****************************************************************************


deloff	SLEEP	1ch
	callr	deloffbot
	jruc	deloff

deloffbot:
;delete foreground objects that are off bottom of screen
	move	@WORLDTLY,a1,L
	addi	[260,0],a1
	srl	16,a1
	movi	RAMLST,a3
	clr	a0
	move	a0,*a3,L
	movi	OBJLST,a0
sobjs1
	move	*a0,a0,L
	jreq	sobjsx
	move	*a0(OYPOS),a2
	cmp	a2,a1
	jrnc	sobjs1
contab
	move	a0,*a3+,L		;img to be deleted
	clr	a4
	move	a4,*a3,L		;zero next entry
	move	a4,*a3(32),L		;zero next entry
	jruc	sobjs1
sobjsx
	movi	RAMLST,a1
delt	move	*a1+,a0,L
	jrz	delx
	PUSH	a1
	calla	DELOBJ
	PULL	a1
	jruc	delt
delx	rets

#********************************

 SUBR	winning_msg
	movi	65-15,a0
	move	a0,@mess_line_spacing

	movi	LN0_setup,a2
	calla	setup_message

	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	move	@team1,a14
	move	@scores,a0
	move	@scores+16,a1
	cmp	a0,a1
	jrlt	#ok
	move	@team2,a14
#ok	sll	5,a14
	move	a14,a10
	addi	strings,a14
	move	*a14,a4,L

;	movi	#str_1,a4

	calla	print_string_C2

	.REF	flash_bigtxt2
	CREATE0	flash_bigtxt2
	move	a0,a9

	
	SLEEP	3*60

	move	a9,a0
	calla	KILL

;	move	a8,a0
;	calla	DELOBJ

	movi	TYPTEXT,a0
	calla	obj_del1c
	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text
	DIE


LN0_setup
	RJR_STR	omlgmd_ascii,10,1,200,60,LGMDGLD,0		;PURP
	.even

strings	.long	#s1,#s2,#s3,#s4,#s5,#s6,#s7,#s8,#s9,#s10
	.long	#s11,#s12,#s13,#s14,#s15,#s16,#s17,#s18,#s19,#s20
	.long	#s21,#s22,#s23,#s24,#s25,#s26,#s27,#s28

;#s1	.string	"ATLANTA HAWKS WIN!",0
;#s2	.string	"BOSTON CELTICS WIN!",0
;#s3	.string	"CHARLOTTE HORNETS WIN!",0
;#s4	.string	"CHICAGO BULLS WIN!",0
;#s5	.string	"CLEVLAND CAVS WIN!",0
;#s6	.string	"DALLAS MAVERICKS WIN!",0
;#s7	.string	"DENVER NUGGETS WIN!",0
;#s8	.string	"DETROIT PISTONS WIN!",0
;#s9	.string	"GOLDEN STATE WINS!",0
;#s10	.string	"HOUSTON ROCKETS WIN!",0
;#s11	.string	"INDIANA PACERS WIN!",0
;#s12	.string	"L.A. CLIPPERS WIN!",0
;#s13	.string	"L.A. LAKERS WIN!",0
;#s14	.string	"MIAMI HEAT WIN!",0
;#s15	.string	"MILWAUKEE BUCKS WIN!",0
;#s16	.string	"TIMBERWOLVES WIN!",0
;#s17	.string	"NEW JERSEY NETS WIN!",0
;#s18	.string	"NEW YORK KNICKS WIN!",0
;#s19	.string	"ORLANDO MAGIC WIN!",0
;#s20	.string	"PHILADELPHIA WINS!",0
;#s21	.string	"PHOENIX SUNS WIN!",0
;#s22	.string	"PORTLAND TRAILBLAZERS WIN!",0
;#s23	.string	"SACRAMENTO KINGS WIN!",0
;#s24	.string	"SAN ANTONIO SPURS WIN!",0
;#s25	.string	"SEATTLE SUPERSONICS WIN!",0
;#s26	.string	"UTAH JAZZ WIN!",0
;#s27	.string	"WASHINGTON BULLETS WIN!",0

#s1	.string	"ATLANTA HAWKS",1
	.string	"WIN!",0
#s2	.string	"BOSTON CELTICS",1
	.string	"WIN!",0
#s3	.string	"CHARLOTTE",1
	.string	"WINS!",0
#s4	.string	"CHICAGO BULLS",1
	.string	"WIN!",0
#s5	.string	"THE CAVALIERS",1
	.string	"WIN!",0
#s6	.string	"THE MAVERICKS",1
	.string	"WIN!",0
#s7	.string	"THE NUGGETS",1
	.string	"WIN!",0
#s8	.string	"THE PISTONS",1
	.string	"WIN!",0
#s9	.string	"THE WARRIORS",1
	.string	"WIN!",0
#s10	.string	"THE ROCKETS",1
	.string	"WIN!",0
#s11	.string	"THE PACERS",1
	.string	"WIN!",0
#s12	.string	"THE CLIPPERS",1
	.string	"WIN!",0
#s13	.string	"THE LAKERS",1
	.string	"WIN!",0
#s14	.string	"MIAMI HEAT",1
	.string	"WIN!",0
#s15	.string	"THE BUCKS",1
	.string	"WIN!",0
#s16	.string	"THE WOLVES",1
	.string	"WIN!",0
#s17	.string	"THE NETS",1
	.string	"WIN!",0
#s18	.string	"THE KNICKS",1
	.string	"WIN!",0
#s19	.string	"THE MAGIC",1
	.string	"WIN!",0
#s20	.string	"PHILADELPHIA",1
	.string	"WINS!",0
#s21	.string	"PHOENIX SUNS",1
	.string	"WIN!",0
#s22	.string	"THE BLAZERS",1
	.string	"WIN!",0
#s23	.string	"THE KINGS",1
	.string	"WIN!",0
#s24	.string	"THE SPURS",1
	.string	"WIN!",0
#s25	.string	"SUPERSONICS",1
	.string	"WIN!",0
#s26	.string	"UTAH JAZZ",1
	.string	"WIN!",0
#s27	.string	"THE BULLETS",1
	.string	"WIN!",0
#s28	.string	"THE CHAMPS",1
	.string	"WIN AGAIN!",0

	.even

	.end
