****************************************************************
*
* Owner:	JOHNSON
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
	.include	"game.equ"
	.include	"audit.equ"
	.include	"macros.hdr"
	.include	"link.equ"

	.include	"credturb.glo"
	.include	"imgtbl.glo"
	.include	"bgndtbl.glo"
	.include	"bgndtbl7.asm"
	.include	"bgndpal7.asm"
	.include	"bgndtbl7.glo"

	.def	COLTAB
	.def	creditscreen

	.ref	tuneend_snd,bounce_snd
	.ref	tuneq1_snd,tuneq2_snd,tuneq3_snd,tuneq4_snd
	.ref	QSNDRST

	.ref	show_prizes
	.ref	drw_chicks
	.ref	TWOPLAYERS			;0 = NO, 1 = YES 2 players
	.ref	COLTAB2
	.ref	get_all_buttons_down,get_all_buttons_cur2
	.ref	fade_up,fade_down
	.ref	bast7t_ascii,bast8_ascii,bast8t_ascii,bast10_ascii
	.ref	bast7tcyc_ascii
	.ref	brush20_ascii,inga16_ascii
	.ref	brush10_ascii
	.ref	special_heads
	.ref	our_heads,our_names
	.ref	get_opponent_team
	.ref	winningteam
	.ref	credits2,credits3
	.ref	show_hiscore,WNDWOFF
	.ref	player1_data,player2_data,player3_data,player4_data
	.ref	player_names,player_heads
	.ref	FRANIMQ
	.ref	GAMSTATE,HALT,KILBGND
	.ref	process_init
	.ref	tvpanelon,gndstat
	.ref	BAKMODS,BGND_UD1,CLR_SCRN
	.ref	CR_CONTP,P_CONT,CR_STRTP,P_START,WSPEED
	.ref	WNDWON,CRD_SCRN2,IRQSKYE
	.ref	pal_clean,pal_getf,dmaq_wait,display_init,AUD1
	.ref	GET_ADJ
	.ref	conttimers
	.ref	GETHIGH,pal_set,PALFRAM
	.ref	COLCYC,COLRPRC
	.ref	anim_script,anim_killall
	.ref	GET_AUD,DEF_PAGE
	.ref	PSTATUS,PSTATUS2
	.ref	dirqtimer,dirq_wait
	.ref	dpageflip,dpageflip_off
	.ref	WIPEOUT
	.ref	demogame_start
	.ref	system_savegame,system_restoregame
	.ref	create_stat_titles
	.ref	do_scrn_transition
	.ref	wipe_horz_stag_dwn,un_wipe_horz_stag_dwn
	.ref	wipe_horz_comb
	.ref	NO_CREATE_DEL_OBJS,CREATE_NO_DEL_OBJS
	.ref	scores
	.ref	print_string,print_string2,print_string_C,print_string_C2
	.ref	message_palette
	.ref	message_ascii,mess_spacing,mess_objid,mess_cursx,mess_cursy
	.ref	mess_cursx2,mess_justify,kern_chars,print_string2b
	.ref	setup_message
	.ref	message_buffer
	.ref	dec_to_asc,dec_to_pct
	.ref	copy_string,copy_rom_string
	.ref	concat_string,concat_rom_string
	.ref	print_string_R,print_string_R2
	.ref	FADERAM,RNDRNG0
	.ref	player_stats
;	.ref	get_stick_val_cur
	.ref	new_team_select_screen
	.ref	get_name_string
	.ref	bast18_ascii,brush12_ascii
;	.ref	create_heads
	.ref	create_names,create_plyrs_name
	.ref	create_name_backplates
	.ref	create_title_bar
	.ref	anim_fire_for_best_plyr
	.ref	kill_fire_anim
	.ref	create_player_head_backdrops
	.ref	create_score_backdrop
	.ref	set_volume_for_amode
	.ref	team1,team2
	.ref	tick_snd
	.ref	best_plyr_speech
	.ref	un_wipe_horizontal,wipe_horizontal
	.ref	mess_line_spacing
	.ref	CYCLE_TABLE,BSTCYCB_P
;	.ref	p1taps,p2taps,p3taps,p4taps
	.ref	result_screen
	.ref	kp_team1,kp_scores,kp_team2
	.ref	SOUNDSUP
	.ref	STRCNRMO
	.ref	ADJ_PAGE,RC_BYTEI
	.ref	RD7FONT
	.ref	STRLNRMO_1
	.ref	STRCNRMO_1
	.ref	octopus2		
	.ref	prt_credits
	.ref	start_msgs
	.ref	fix_dropout_msgs
	.ref	sc_proc
	.ref	buyin_screen
	.ref	trivia_game
	.ref	gmqrtr
	.ref	start_teams
	.ref	create_heading2
	.ref	flash_bigtxt2
	.ref	bast8_2_ascii,hangfnt38_ascii
	.ref	HANGF_R_P
	.ref	crwdbed_kill
	.ref	kill_flsh_txt_proc
	.ref	change_pal_on_text
	.ref	plyr_onfire
	.ref	BASTC_W_P
	.ref	create_player_nubs
	.ref	create_player_heads
	.ref	update_player_heads
	.ref	award_plr_attrib_pts

	.ref	pup_showshotper,pup_noassistance
	.ref	pup_court,pup_aba
	.ref	kp_p1_crtplr,kp_p2_crtplr,kp_p3_crtplr,kp_p4_crtplr
	.ref	logos,name_sort,player_heads2
	.ref	plyr_names_img_tbl,BALLBAK1
	.ref	city_names_str_tbl

;ram
	BSSX	ENTERON		,16	;INITIALS BEING ENTERD FLAG

	BSSX	hisclong	,16	;!0=Show hiscore table longer


;	.bss	cycram		,8*2*16	;Palette cycle mem
;
;;	.bss	RAMLST,32*40 ;35		;IMG PNTRS FOR DELETION WHILE SCROLL

;RAMLST	.bss	RAMLST		,8*2*16	;Temp obj ram

;
;	.bss	cycram2		,8*2*16	;^
;	.bss	cycram3		,7*2*16	;^
;	.bss	cycram4		,7*2*16	;^
;	.bss	cycram5		,7*2*16	;^
;	.bss	cycram6		,7*2*16	;^
;	.bss	cycram7		,9*2*16	;^

	.bss	team_cnts	,32	;left team cnt, +16=rgt team cnt
	.bss	stick		,32	;stick ram for team selection

	.bss	loop		,16	;Cntr for when to show design team
	.bss	otdloop		,16	;Cntr for when to show outdoor crt
	.bss	tmnbr		,16
	.bss	tmloop		,16



	.text

********************************
* Attract mode start up routine (Process)


#slp	SLEEPK	1

 SUBR	amode_start

	movi	ACTIVE,a0		;>Look for indestructables
	jruc	#nxt

#ilp	move	*a0(PROCID),a14
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
;	move	a0,@p1taps
;	move	a0,@p2taps
;	move	a0,@p3taps
;	move	a0,@p4taps

;Fall through

********************************
* Attract mode loop (Process)


 SUBRP	amode

#lp
	movi	AMODE_PID,a0
	move	a0,*a13(PROCID)

;Temp - non stop gameplay in attract
;;	JSRP	demogame
;;	jruc	#lp

;	.ref	grand_champs_screen
;	JSRP	grand_champs_screen

	JSRP	show_title
	calla	set_volume_for_amode
	JSRP	show_hiscore
;TEMP!!!

;	JSRP	show_operatormsg
	JSRP	new_page
	JSRP	creditscreen
	JSRP	demogame
	SOUND1	tuneend_snd

	JSRP	hint_page2
	JSRP	show_hiscore

	JSRP	show_prizes
;;;;	JSRP	drw_stars
	JSRP	creditscreen
	JSRP	demogame
	SOUND1	tuneend_snd
	JSRP	show_nba_plyrs

	JSRP	result_screen
	JSRP	new_page
	JSRP	show_title
	JSRP	show_copyright
	JSRP	creditscreen
;	JSRP	show_operatormsg
	JSRP	demogame
	SOUND1	tuneend_snd
	JSRP	show_nba_plyrs

;;;;	JSRP	drw_chicks
;;;;	JSRP	drw_ladder

	move	@loop,a0
	inc	a0
	move	a0,@loop
	andi	3,a0
	subk	2,a0			;Show on non-zero loop count
	jrnz	#chknxt
;;	JSRP	show_designteam
#chknxt
	move	@loop,a0
	andi	>3f,a0
	jrnz	#lp
	JSRP	trivia_rules
	jruc	#lp


	.def	pObj
	.bss	pObj,32



#****************************************************************
* Title screen

show_title

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

	SLEEPK	2

	movi	title_scr_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1


	movk	1,a0
	move	a0,@DISPLAYON
	calla	display_unblank

;	movi	STATIC_p,a8
;	movi	cycram,a9
;	movi	[1,8],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	P_STATIC,a8
;	movi	cycram2,a9
;	movi	[21,27],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	P_STATIC,a8
;	movi	cycram3,a9
;	movi	[28,34],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	P_STATIC,a8
;	movi	cycram4,a9
;	movi	[35,41],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	P_STATIC,a8
;	movi	cycram5,a9
;	movi	[42,48],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	P_STATIC,a8
;	movi	cycram6,a9
;	movi	[49,55],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC
;
;	movi	P_STATIC,a8
;	movi	cycram7,a9
;	movi	[56,63],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC


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

;TEMP
	movi	CYCPID,a0
	calla	KIL1C
	SLEEP	40

	calla	WIPEOUT
	RETP

title_scr_mod
	.long	hangtimeBMOD
	.word	0,0
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


#****************************************************************
* Show an operator message if one has been entered


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


	movi	INGA_Y_P,a0
	calla	pal_getf
	move	a0,a6

	move	a13,a8
	addi	som_string,a8
	clr	a0
	movk	1,a10
	movi	inga16_asc_tbl,a11
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

	movi	our_legal_msg_setup,a2
	calla	setup_message
	movk	11,a0
	move	a0,@mess_line_spacing
	movi	our_legal_msg_str,a4
	calla	print_string_C2

	movi	[0a8h,0],a0
	movi	[03bh,0],a1
	.ref	hang_logo
	movi	hang_logo,a2			;* image
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

	SLEEP	1*TSEC

	movi	1*TSEC,a10
#lp0	SLEEPK	1
	calla	get_all_buttons_cur2
	jrz	#nob0
      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
	jruc	#xb0
#nob0
	dsj	a10,#lp0
#xb0
	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40

	movi	CLSDEAD,a0
	calla	obj_del1c
	movi	TYPTEXT,a0
	calla	obj_del1c

	movi	legal_msg_setup,a2
	calla	setup_message
	movk	11,a0
	move	a0,@mess_line_spacing
	movi	legal_msg_str,a4
	calla	print_string_C2

	movi	[200,0],a0
	movi	[107,0],a1
	.ref	OFFNBA
	movi	OFFNBA,a2			;* image
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

	SLEEP	1*TSEC

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

our_legal_msg_setup
	PRINT_STR	bast8t_ascii,4,0,200,140,BAST_W_P,0


our_legal_msg_str
	.string	"(C) 1996 MIDWAY MANUFACTURING COMPANY",1
	.string	"ALL RIGHTS RESERVED",0
	.even

legal_msg_setup
	PRINT_STR	bast8t_ascii,4,0,200,140,BAST_W_P,0

legal_msg_str
	.string	"THE NBA AND INDIVIDUAL NBA TEAM IDENTIFICATIONS USED",1
	.string	"ON OR IN THIS PRODUCT ARE TRADEMARKS, COPYRIGHTED",1
	.string	"DESIGNS AND OTHER FORMS OF INTELLECTUAL PROPERTY OF",1
	.string	"NBA PROPERTIES, INC. AND THE RESPECTIVE TEAMS AND MAY",1
	.string	"NOT BE USED, IN WHOLE OR IN PART, WITHOUT THE PRIOR",1
	.string	"WRITTEN CONSENT OF NBA PROPERTIES, INC.",1
	.string	"(C) 1996 NBA PROPERTIES, INC.",1
	.string	"ALL RIGHTS RESERVED",0
	.even

;FIXX!!!  Or take out...
#****************************************************************
* Show design team names and messages

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
	WL	-1,BRSH_B_P
	.word	-2,118,3
	.byte	"DESIGN TEAM:",0
	.long	0
	WL	-1,BRSH_Y_P
	.word	-2,60,37
;	.byte	"MARK TURMELL",0
;	LWW	MRK_TURM,>b2,>32
;	.byte	"SHAWN LIPTAK",0
;	LWW	SHA_LIPM,>f0,>1d
;	WL	-1,AQUAPAL
;	.byte	"TONY GOSKIE",0			;-6
;	LWW	TON_GOSM,185,>1f
;	.byte	"JOHN CARLTON",0
;	LWW	JON_CARM,>ff92,>20
;	.byte	"SAL DIVITA",0
;	LWW	SAL_DIVM,>ffa3,>20
;	WL	-1,GREENPAL
;	.byte	"JON HEY",0
;	LWW	JON_HEYM,>ffbf,>1c
;	WL	-1,BRSH_Y_P
;	.byte	"JAMIE RIVETT",0
;	LWW	JAM_RIVM,>a0,>18
	.word	0

thanx_t
	WL	-1,BRSH_W_P
	.word	-2,200,3
	.byte	"STARRING:",0
	.long	0
	WL	-1,BRSH_B_P
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
	WL	-1,BRSH_W_P
	.word	-2,200,3
	.byte	"HARDWARE SUPPORT:",0
	.long	0
	WL	-1,BRSH_R_P
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
	WL	-1,BRSH_W_P
	.word	-2,200,3
	.byte	"SPECIAL THANKS:",0
	.long	0
	WL	-1,BRSH_R_P
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
	WL	-1,BRSH_R_P
	.word	-2,200,3
	.byte	"SPECIAL THANKS:",0
	.long	0
	WL	-1,BRSH_G_P
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
	WL	-1,BRSH_R_P
	.word	-2,200,3
	.byte	"SPECIAL THANKS:",0
	.long	0
	WL	-1,BRSH_G_P
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
	WL	-1,BRSH_W_P
	.word	-2,200,20
	.byte	"EXECUTIVE PRODUCERS:",0
	.long	0
	WL	-1,BRSH_R_P
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
	WL	-1,SGMD8WHT
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
	movi	brush20_ascii,a11
	PUSHP	a9

	cmpi	thanx_t,a8
	jrge	#cn

	JSRP	STRLNRMO_1
	jruc	#cnx

#cn
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
	movi	brush20_ascii,a11
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


;
; Font table for OPERATOR MESSAGE
;
	.def	inga16_asc_tbl
inga16_asc_tbl
	.long	INGA16EXC,INGA16APO,INGA16NUM,INGA16DOL		;!"#$
	.long	INGA16PCT,INGA16SPC,INGA16APO,INGA16PRL		;%&'(
	.long	INGA16PRR,INGA16SPC,INGA16ADD,INGA16COM		;)*+,
	.long	INGA16SUB,INGA16PER,INGA16SLS			;-./
	.long	INGA16_0,INGA16_1,INGA16_2,INGA16_3,INGA16_4
	.long	INGA16_5,INGA16_6,INGA16_7,INGA16_8,INGA16_9
	.long	INGA16COL,INGA16SPC,INGA16SPC,INGA16SPC		;:;<=
	.long	INGA16SPC,INGA16QUE,INGA16SPC			;>?@
	.long	INGA16_A,INGA16_B,INGA16_C,INGA16_D
	.long	INGA16_E,INGA16_F,INGA16_G,INGA16_H
	.long	INGA16_I,INGA16_J,INGA16_K,INGA16_L
	.long	INGA16_M,INGA16_N,INGA16_O,INGA16_P
	.long	INGA16_Q,INGA16_R,INGA16_S,INGA16_T
	.long	INGA16_U,INGA16_V,INGA16_W,INGA16_X
	.long	INGA16_Y,INGA16_Z
	.long	INGA16SPC,INGA16SPC,INGA16SPC,INGA16END		;[\]^
	.long	INGA16DEL,INGA16APO,BAST10SPC			;_`



#*******************************
* Look at the buttons, read a sequence table,
* and set octopus2 flag if sequence successful


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
;      	clr	a0
;	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
;	movk	1,a0
;	move	a0,@SOUNDSUP		;turn all sounds off
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
;      	clr	a0
;	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
;	movk	1,a0
;	move	a0,@SOUNDSUP		;turn all sounds off
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





#***************************************************************
* Show some gameplay

 SUBRP	demogame

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

;;;;	calla	set_volume_for_amode

	movi	-1,a0
	move	a0,@special_heads,L
	move	a0,@special_heads+20h,L
	clr	a0
	move	a0,@pup_showshotper
	move	a0,@pup_noassistance

	movk	NUM_TEAMS-1,a0
	calla	RNDRNG0
;TEMP!!!
;	movk	12,a0		;Team #
	move	a0,@team1		;Team controlled by plyrs 1 & 2
	move	a0,a8
#agn	movk	NUM_TEAMS-1,a0
	calla	RNDRNG0
	cmp	a0,a8
	jreq	#agn
;TEMP!!!
;	movk	4,a0		;Team #
    	move	a0,@team2		;Team controlled by plyrs 3 & 4

	clr	a0
	move	@otdloop,a14
	addk	1,a14
	cmpi	100,a14			;!!!
	jrlo	#otd
	clr	a14
	movk	1,a0
#otd
	move	a14,@otdloop
	move	a0,@pup_court
	move	a0,@pup_aba

	SOUND1	tuneend_snd

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

;	CREATE0	drwnbalogo

	SLEEPK	5
	calla	update_insert

	SLEEP	3*TSEC

#loop
;FIX!!!
	movi	27*60,a10
;	movi	50*60,a10
#lp	SLEEPK	2
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
	calla	pal_clean
	SLEEPK	1

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
	calla	snd_play1
	DIE

tunes_t
	.long	tuneq1_snd
	.long	tuneq2_snd
	.long	tuneq3_snd
	.long	tuneq4_snd


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
	.asg	16,YSPACE

 SUBR	show_create_plyr_info

	movk	INAMODE,a0
	move	a0,@GAMSTATE

	movi	wipe_horizontal,a0,L
	movi	CREATE_NO_DEL_OBJS,a14		;dont delete objs. when done
	JSRP	do_scrn_transition

	SLEEPK	1

	calla	KILBGND			;Kill old background
	calla	pal_clean
	clr	a0
	movi	-1,a1
	calla	obj_delc		;Kill all objs (Screen mem is clr)
	clr	a0
	clr	a1				;kill all processes
	calla	KILALL

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	2

	movi	#hintpage_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movk	1,a0
	calla	create_title_bar

	movi	heading_setup,a2
	calla	setup_message
	movi	#caplr_heading,a4
	calla	print_string_C2

	movi	caplr_str_setup,a2
	calla	setup_message
	movi	#caplr_info_str,a4
	calla	print_string_C2

	movi	caplr_str_setup2,a2
	calla	setup_message
	movk	13,a0
	move	a0,@mess_line_spacing
	movi	#caplr_info_str2,a4
	calla	print_string2

	SLEEPK	1

	movi	un_wipe_horizontal,a0,L
	movi	NO_CREATE_DEL_OBJS,a14
	JSRP	do_scrn_transition

	SLEEP	1*TSEC

	movi	14*TSEC,a10
#capi1
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#capi2
	dsj	a10,#capi1
#capi2
	SOUND1	bounce_snd
 	
 	RETP



*****************************************************************************
	.asg	16,YSPACE

 SUBR	hint_page2

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	SLEEPK	1

	movi	#hintpage_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movi	[1,31],a8		;START AT COLOR 10, CYCLE 7 COLORS
	movi	BST18B2_P,a9			;PAL NAME
	movi	BSTCYCB_P,a10
	movk	2,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	movk	1,a0
	calla	create_title_bar

	movi	heading_setup,a2
	calla	setup_message
	movi	#str_heading,a4
	calla	print_string_C2

	movi	YSPACE,a0
	move	a0,@mess_line_spacing

	movi	heading2_setup,a2
	calla	setup_message

;	movk	26,a0
	movi	44,a0
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

	SLEEP	2*TSEC

	movi	7*TSEC,a10
#butp
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrz	#butp1
	SOUND1	bounce_snd
	jruc	#butp2
#butp1
	dsj	a10,#butp
#butp2

	movi	CYCPID,a0
	calla	KIL1C
	RETP



*****************************************************************************
	.asg	16,YSPACE

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

	clr	a0
	move	a0,@IRQSKYE

	movi	[1,31],a8		;START AT COLOR 10, CYCLE 7 COLORS
	movi	BST18B2_P,a9			;PAL NAME
	movi	BSTCYCB_P,a10
	movk	2,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	movk	1,a0
	calla	create_title_bar

	movi	heading_setup,a2
	calla	setup_message
	movi	#str_heading,a4
	calla	print_string_C2

	movi	YSPACE,a0
	move	a0,@mess_line_spacing

	movi	heading2_setup,a2
	calla	setup_message

;	movk	26,a0
	movi	44,a0
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
 
	SLEEPK	1		;2

	calla	system_restoregame

;	movk	INGAME,a0
;	move	a0,@GAMSTATE

	movi	CLSDEAD|creditid,a0
	calla	obj_del1c		;kill credit/qrtr imgs

	calla	prt_credits
	CREATE0	start_msgs
	calla	fix_dropout_msgs
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
	.long	ATTRACTBMOD
	.word	0,0
	.long	0


	.asg	20,LN0
	.asg	120,LN1

heading_setup
	PRINT_STR	brush20_ascii,8,0,200,7,BRSHGYOP,0
heading2_setup
	PRINT_STR	bast18_ascii,8,0,200,LN0+45,BST18B2_P,0
LN1_setup
	PRINT_STR	bast10_ascii,6,0,44,LN1-10,BAST_D_P,0


#str_heading
	.string	"coaching tips",0
	.even

#caplr_heading
	.string	"created player info",0
	.even


caplr_str_setup
	PRINT_STR	bast10_ascii,8,0,200,45,BAST_G_P,0

caplr_str_setup2
	PRINT_STR	bast10_ascii,8,0,20,80,BAST_W_P,0

hve_fun_str_setup
	PRINT_STR	brush20_ascii,8,0,200,220,BRSHGYGP,0

#caplr_info_str
	.string	"thank you for creating a character!!",0
	.even

#caplr_info_str2
	.string	"1) you can earn extra attribute points",1
	.string	"   by winning 3 games!",1
	.string	"",1
	.string	"2) you can reenter 'create player',",1
	.string	"   using your players' name and",1
	.string	"   pin number!",1
	.string	"",1
	.string	"3) find the best combination of attributes",1
	.string	"   and privileges!",1
	.string	"",1
	.string	"4) you have special abilities that normal",1
	.string	"   players don't!",0
	.even


	.asg	1,CR

#random_hints
	.long	#str_h0,#str_h1,#str_h2,#str_h3,#str_h4
	.long	#str_h5,#str_h6,#str_h7,#str_h8
	.long	#str_h9,#str_h10,#str_h11,#str_h12
	.long	#str_h13,#str_h14,#str_h15,#str_h16,#str_h17,#str_h18
	.long	#str_h19,#str_h20,#str_h21,#str_h22,#str_h23,#str_h24
	.long	#str_h25,#str_h26,#str_h27
 
	.long	#str_h28,#str_h29,#str_h30
	.long	#str_h31,#str_h32,#str_h33
	.long	#str_h34,#str_h35,#str_h36
	.long	#str_h37,#str_h38
	.long	#str_h39,#str_h40
	.long	#str_h41
	.long	#str_h42
	.long	#str_h43
	.long	#str_h44


#random_hints2
	.long	#str_h0a,#str_h1a,#str_h2a,#str_h3a,#str_h4a
	.long	#str_h5a,#str_h6a,#str_h7a,#str_h8a
	.long	#str_h9a,#str_h10a,#str_h11a,#str_h12a
	.long	#str_h13a,#str_h14a,#str_h15a,#str_h16a,#str_h17a,#str_h18a
	.long	#str_h19a,#str_h20a,#str_h21a,#str_h22a,#str_h23a,#str_h24a
	.long	#str_h25a,#str_h26a,#str_h27a

	.long	#str_h28a,#str_h29a,#str_h30a
	.long	#str_h31a,#str_h32a,#str_h33a
	.long	#str_h34a,#str_h35a,#str_h36a
	.long	#str_h37a,#str_h38a
	.long	#str_h39a,#str_h40a
	.long	#str_h41a
	.long	#str_h42a
	.long	#str_h43a
	.long	#str_h44a


#str_h0
	.string	"hook shots",0
#str_h0a
	.string	"When you're running perpendicular,",1
	.string "near the hoop, press the shoot button.",1
	.string " ",1
	.string	"pressing turbo and shoot will give",1
	.string "the ball a higher arc!",0

#str_h1
	.string	"super dunks",0
#str_h1a
	.string	"press the turbo and Shoot buttons",1
	.string "while running toward the basket.",1
	.string	" ",1
	.string "remember, some players have more",1
	.string "spectacular dunks than others!",0

#str_h2
	.string	"head fakes",0
#str_h2a
	.string	"tap the Shoot button once.  However,",1
	.string	"this also causes you to pick up your",1
	.string	"dribble.",1
	.string	" ",1
	.string	"Try faking out CPU Drones!",0

#str_h3
	.string	"jump shot pass",0
#str_h3a
	.string	"Press and hold the shoot button,",1
	.string	"then press the pass button.  This",1
	.string	"allows you to dish off to your",1
	.string	"teammate.",1
	.string	" ",1
	.string "this is most effective when you are",1
	.string	"about to be rejected!",0

#str_h4
	.string	"accurate jump shots",0
#str_h4a
	.string	"increase the chances of a jump",1
	.string	"shot going in by releasing the Shoot",1
	.string	"button at the peak of your jump.",1
	.string	" ",1
	.string	"Avoid being rejected by holding on",1
	.string	"to the ball until the defender is",1
	.string	"out of position.",0

#str_h5
	.string	"spin move",0
#str_h5a
	.string	"When running, quickly tap the",1
	.string	"turbo button twice. This will cause",1
	.string	"you to spin around your opponent.",1
	.string	" ",1
	.string	"while spinning you're less likely to",1
	.string	"get cleared out by an opponent!",0

#str_h6
	.string	"clearing out",0
#str_h6a
	.string	"when facing your opponent, press the",1
	.string	"turbo and pass buttons at the same",1
	.string	"time. This will clear him out!",1
	.string	" ",1
	.string	"remember, small players can't clear",1
	.string	"out big players!",0

#str_h7
	.string "protect the ball",0
#str_h7a
	.string	"When standing in position with the",1
	.string	"ball, quickly tap the turbo button.",1
	.string "this will cause the player to protect",1
	.string "the ball!",0

#str_h8
	.string	"turbo pass",0
#str_h8a
	.string	"press the turbo and pass buttons at",1
	.string "the same time for a fast pass.",1
	.string " ",1
	.string "Turbo passes are less likely to be",1
	.string "intercepted by the defense!",0

#str_h9
	.string	"super jumps",0
#str_h9a
	.string	"jump extra high when shooting,",1
	.string	"blocking, or rebounding by pressing",1
	.string "the turbo and shoot buttons at the",1
	.string "same time!",0

#str_h10
	.string	"dunk pass",0
#str_h10a
	.string	"to avoid having your dunk blocked,",1
	.string "pass off to your teammate.",1
	.string	" ",1
	.string "This is most effective when your",1
	.string "teammate is open for a three point",1
	.string "shot!",0

#str_h11
	.string	"layups",0
#str_h11a
	.string	"When running at the hoop, quickly",1
	.string	"press the turbo and shoot buttons!",1
	.string	" ",1
	.string	"Holding the shoot button delays",1
	.string	"the release of the ball. Use this",1
	.string	"to fake out your opponent!",0

;MJT Start
;Fix!!!  Put in for maximum version!
;#str_h12
;	.string	"hotspots",0
;#str_h12a
;	.string	"if a player makes 3 jump shots",1
;	.string	"from the same spot on the court,",1
;	.string	"then that spot becomes his hotspot!",1
;	.string	" ",1
;	.string	"shooting from a hotspot dramatically",1
;	.string	"increases the shot percentage!!",0

#str_h12
#str_h13
	.string	"lean-out jumper",0
#str_h12a
#str_h13a
;MJT End
	.string	"If you are facing straight up or",1
	.string	"down, pull the joystick to the left",1
	.string	"or right!",1
	.string	" ",1
	.string	"holding the shoot button delays the",1
	.string	"release of the ball!",0

#str_h14
	.string	"hot streak",0
#str_h14a
	.string "When a player scores 3 consecutive",1
	.string "baskets, he is on fire!",1
	.string " ",1
	.string "When a player goes on a hot streak,",1
	.string	"give him the ball!  he will remain",1
	.string	"hot for several shots or until the",1
	.string	"other team scores.",0

#str_h15
	.string "double-dunks",0
#str_h15a
	.string	"When a player is in a dunk, his",1
	.string	"teammate can also start a dunk.",1
	.string	"The player with the ball can then",1
	.string	"press the pass button to lob the",1
	.string	"the ball to his teammate.",1
	.string	"",1
	.string	"Try for 3 in a row!",0

#str_h16
	.string "drone control",0
#str_h16a
	.string	"Cause a teammate controlled by the",1
	.string	"CPU to shoot or pass by pressing",1
	.string	"your own shoot or pass buttons.",1
	.string	" ",1
	.string	"pass to your drone when he is under",1
	.string	"the hoop for a quick dunk.",0

#str_h17
	.string	"fade-away jumper",0
#str_h17a
	.string	"Just as you jump up for a shot, pull",1
	.string	"the joystick in the opposite direction",1
	.string	"your player is facing.",1
	.string	" ",1
	.string	"holding the shoot button delays the",1
	.string	"release of the ball!",0

#str_h18
	.string	"Player Attributes",0
#str_h18a
	.string	"For maximum success, pay attention",1
	.string "to your player's strengths and",1
	.string	"weaknesses.  Play big guys near the",1
	.string "hoop, and small guys outside.",1
	.string	" ",1
	.string "Big guys are poor 3 point shooters!",0

#str_h19
	.string	"power attribute",0
#str_h19a
	.string	"The greater a player's Power rating,",1
	.string "the harder it is to clear him out",1
	.string	"or to block his dunks.  Try to avoid",1
	.string "size mismatches. ",1
	.string	" ",1
	.string	"powerful guys tend to hold onto",1
	.string "the ball when cleared out!",0

#str_h20
	.string	"alley-oop play",0
#str_h20a
	.string	"When your teammate has the ball,",1
	.string "drive the open lane toward the hoop",1
	.string	"and press turbo and shoot.",1
	.string	"Once airborne, your teammate must",1
	.string	"quickly pass you the ball!",1
	.string	"",1
	.string	"Try for 3 in a row!",0

#str_h21
	.string	"teamwork",0
#str_h21a
	.string	"A combination of 3 consecutive",1
	.string "alley-oops or double-dunks will",1
	.string	"put your team in the zone!",1
	.string	" ",1
	.string	"Don't be a ball hog!",0

#str_h22
	.string	"steal attribute",0
#str_h22a
	.string	"The greater a player's steal rating,",1
	.string "the more effective his swiping",1
	.string	"becomes. He will also intercept more",1
	.string "passes!",1
	.string	" ",1
	.string	"Smaller, quicker players are very",1
	.string "skilled at stealing the ball.",0

#str_h23
	.string	"dunk attribute",0
#str_h23a
	.string	"The greater a player's dunk rating,",1
	.string "the more spectacular his dunks. a",1
	.string	"player with a zero dunk rating will",1
	.string "perform just layups.",1
	.string	" ",1
	.string "Layups are generally less successful",1
	.string "than dunks.",0

#str_h24
	.string	"speed attribute",0
#str_h24a
	.string	"The greater a player's speed rating,",1
	.string "the faster he moves.  Usually, the",1
	.string	"faster players are less powerful",1
	.string "and therefore get cleared out more.",1
	.string	" ",1
	.string "Match speed against speed.",0

#str_h25
	.string	"create player",0
#str_h25a
	.string	"At start of a game, choose the",1
	.string "'create player' option and",1
	.string "customize a player to fit your",1
	.string "individual playing style.",1
	.string " ",1
	.string "created players can earn extra",1
	.string "attribute points with 3 wins!",0

#str_h26
	.string	"power-ups",0
#str_h26a
	.string	"On the versus screen, press the",1
	.string "turbo, shoot and pass buttons to",1
	.string	"select a combination. In order",1
	.string	"to activate some power-ups, all",1
	.string	"players must enter the same",1
	.string	"combination!",1
	.string	"",1
	.string	"enter '111' for tournament mode!",0

#str_h27
	.string	"lean-in jumper",0
#str_h27a
	.string	"Just as you jump up for a shot, push",1
	.string	"the joystick in the direction your",1
	.string	"player is facing!",1
	.string	" ",1
	.string	"holding the shoot button delays the",1
	.string	"release of the ball!",0

#str_h28
	.string	"Smart turbo useage",0
#str_h28a
	.string	"The amount of turbo remaining is",1
	.string	"displayed at the top of the screen.",1
	.string	" ",1
	.string	"all turbo actions deplete this",1
	.string	"amount, so conserve just enough for",1
	.string	"that all important next move!",0

#str_h29
	.string	"Substitutions",0
#str_h29a
	.string	"Some players may become fatigued",1
	.string "during the second half!  Try",1
	.string	"substituting those players with",1
	.string "fresh players at halftime.",1
	.string " ",0

#str_h30
	.string	"Burst of speed",0
#str_h30a
	.string	"avoid pesky defenders and increase",1
	.string	"the speed of your player by holding",1
	.string	"down the Turbo button.",0

#str_h31
	.string	"Court awareness",0
#str_h31a
	.string	"locate a player's position when he",1
	.string	"is off screen by watching for his",1
	.string	"arrow.  Try to anticipate his moves.",1
	.string	" ",1
	.string	"When off screen, try to stay away",1
	.string	"from opposing players.",0

#str_h32
	.string	"Smart play",0
#str_h32a
	.string	"An open player is more likely to",1
	.string	"make a basket, so pass to your open",1
	.string	"teammate whenever possible!",1
	.string	" ",1
	.string	"Try to anticipate your opponent's next",1
	.string	"move before he makes it!",0

#str_h33
	.string	"Secret power-ups",0
#str_h33a
	.string "Ball Players can be powered up with",1
	.string "super human abilities.  Try special",1
	.string	"joystick/button moves during the",1
	.string	"team matchup screen!",0

#str_h34
	.string "Strong defense",0
#str_h34a
	.string	"decrease the chance of an opponent's",1
	.string	"shot going in the basket by getting",1
	.string	"up real close to him!",1
	.string	" ",1
	.string	"clear him out, steal the ball!",0

#str_h35
	.string	"Hidden Passing attribute",0
#str_h35a
	.string	"The greater a player's hidden pass",1
	.string "rating, the faster he passes.",1
	.string	" ",1
	.string	"It is more difficult to intercept a",1
	.string "quick pass than a slow pass.  You",1
	.string "should always try a turbo pass.",0

#str_h36
	.string	"Blocking attribute",0
#str_h36a
	.string	"The greater a player's block",1
	.string "rating, the better he is at blocking",1
	.string	"dunks and regular jump shots.",1
	.string	" ",1
	.string	"It is also harder for someone to",1
	.string "drive by him for a dunk.",0

#str_h37
	.string	"Hidden Clutch attribute",0
#str_h37a
	.string	"The greater a player's hidden clutch",1
	.string "rating, the more chance that he will",1
	.string	"make a great play during the last 10",1
	.string "seconds of any period.",0

#str_h38
	.string	"Stats pages",0
#str_h38a
	.string	"On the stats page, the steals",1
	.string "category includes slap aways and",1
	.string	"clear outs of ball carriers.",1
	.string	" ",1
	.string	"The injured category represents how",1
	.string "many times you were cleared out!",0

#str_h39
	.string "Layup out of dunks",0
#str_h39a
	.string	"When a player is in a dunk, he can",1
	.string	"press the shoot button to lob the",1
	.string	"the ball toward the hoop.",1
	.string	"",1
	.string	"This is most effective if your dunk",1
	.string	"is about to get blocked.",0

#str_h40
	.string "On demand layups",0
#str_h40a
	.string "run toward the basket without",1
	.string	"holding down the turbo button.",1
	.string "then press the turbo and Shoot",1
	.string	"buttons.  Release shoot button",1
	.string "to layup the ball.",0

#str_h41
	.string	"strengthen created player",0
#str_h41a
	.string	"Each time a created player wins",1
	.string "3 games, he is awarded additional",1
	.string "attribute points.  As you increase",1
	.string "your players strength, hidden",1
	.string "features will become accessible",1
	.string "for that player!",0

#str_h42
	.string	"shot swatting",0
#str_h42a
	.string	"When swatting at a jump shot, hold",1
	.string "the block button down until your",1
	.string "opponent releases the ball, then",1
	.string "release the block button to follow",1
	.string "through with the swat.",0

#str_h43
	.string	"Hidden rebound attribute",0
#str_h43a
	.string	"The greater a player's hidden rebound",1
	.string "rating, the more chance that he will",1
	.string	"snag the rebound from a crowd of",1
	.string "players.  He will also jump higher",1
	.string "when trying to rebound.",0

#str_h44
	.string	"successful rebounding",0
#str_h44a
	.string	"Wait until the ball has hit the rim",1
	.string "before pressing the block button.",1
	.string	"",1
	.string	"Auto rebounding may also occur when",1
	.string "the ball is directly above your head.",0

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

	SLEEPK	1

	movi	#newpage_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movk	1,a0
	calla	create_title_bar

	movi	#heading_setup,a2
	calla	setup_message
	movi	#str_heading,a4
	calla	print_string_C2

	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2

	calla	display_unblank

	movi	#str_tbl,a9,L
#lp
	movi	LN1b_setup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	move	a0,@mess_objid		;OBJ ID's for text
	move	*a9+,a4,L
	calla	print_string_C2

	movi	LN2b_setup,a2
	calla	setup_message
	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	move	a0,@mess_objid		;OBJ ID's for text
	move	*a9+,a4,L
	calla	print_string_C2

	CREATE	CYCPID,flash_bigtxt

	move	*a9,a14
	cmpi	4000,a14
	jrz	#cont0

	SLEEP	40

	movi	1*TSEC,a10
#whopper_with_chees
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exi
	dsj	a10,#whopper_with_chees
#exi	move	a10,a10
      	jrz	#contz

      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off

	jruc	#cont
#contz

	movi	OBJLST,a10
	jruc	#start
#next_obj
	move	*a10(OID),a0
	cmpi	CLSNEUT|TYPTEXT|SUBMES1,a0
	jrne	#not_gover
	movi	[15,0],a0
	move	a0,*a10(OYVEL),L	;Fall off scrn
#not_gover
#start
	move	*a10,a10,L
	jrnz	#next_obj

	SLEEPK	17
     
	movi	CLSNEUT|TYPTEXT|SUBMES1,a0
	calla	obj_del1c
	jruc	#lp

#cont0
	SLEEP	2*TSEC
#cont
	movi	CYCPID,A0
	calla	KIL1C

	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40

	RETP


#heading_setup
	PRINT_STR	brush20_ascii,8,0,200,7,BRSHGYOP,0
LN1b_setup
	PRINT_STR	brush50_ascii,24,0,200,62,BRSH50R_P,0
LN2b_setup
	.ref	brush50_ascii
	PRINT_STR	brush50_ascii,24,0,200,133,BRSH50R_P,0

#newpage_mod
	.long	ATTRACTBMOD
	.word	0,0
	.long	0

#str_tbl
  .long	#str_h0
  .long	#str_h0a
  .long	#str_h1
  .long	#str_h1a
  .long	#str_h2
  .long	#str_h2a
  .long	#str_h3
  .long	#str_h3a
  .long	#str_h4
  .long	#str_h4a
  .long	#str_h5
  .long	#str_h5a
  .long	#str_h6
  .long	#str_h6a
  .long	#str_h7
  .long	#str_h7a
  .long	#str_h8
  .long	#str_h8a
  .long	#str_h9
  .long	#str_h9a
  .long	#str_h10
  .long	#str_h10a
  .long	4000,4000


#str_heading
	.string	"HANGTIME HIGHLIGHTS",0
	.asg	1,CR		    

#str_h0
	.string	"150 NBA",0
#str_h0a
	.string	"PLAYERS",0

#str_h1
	.string	"CREATE",0
#str_h1a
	.string	"PLAYER",0

#str_h2
	.string	"ALLEY",0
#str_h2a
	.string	"OOPS",0

#str_h3
	.string	"DOUBLE",0
#str_h3a
	.string	"DUNKS",0

#str_h4
	.string	"ROOF TOP",0
#str_h4a
	.string	"COURT",0

#str_h5
	.string	"SPIN",0
#str_h5a
	.string	"MOVES",0

#str_h6
	.string	"DIGITAL",0
#str_h6a
	.string	"SOUND",0

#str_h7
	.string	"M DOC",0
#str_h7a
	.string	"RAPS",0

#str_h8
	.string	"TRIVIA",0
#str_h8a
	.string	"CONTEST",0

#str_h9
	.string	"MEGA",0
#str_h9a
	.string	"SECRETS",0

#str_h10
	.string	"AND",0
#str_h10a
	.string	"MORE!",0

	.even
#*****************************************************************************
	.ref	fontram

 SUBRP	flash_bigtxt
  
	movi	OBJLST,a14
	movi	fontram,a3
	clr	a4
	move	a4,*a3,L
	
#lp
	move	*a14,a14,L
	jrz	#x
	move	*a14(OID),a2
	cmpi	CLSNEUT|TYPTEXT|SUBMES1,a2
	jrne	#lp
	move	a14,*a3+,L
	move	a4,*a3,L
	jruc	#lp

		
#x	movk	3,a10
	.ref	white_pal
#top	movi	white_pal,a0
	calla	pal_getf
	movi	fontram,a3
	
#lp2
	move	*a3+,a1,L
	jrz	#xx
	move	a0,*a1(OPAL)
	jruc	#lp2

#xx	SLEEPK	3

	movi	BRSH50R_P,a0
	calla	pal_getf
	movi	fontram,a3
	
#lp3
	move	*a3+,a1,L
	jrz	#xxx
	move	a0,*a1(OPAL)
	jruc	#lp3

#xxx	SLEEPK	5
	dsj	a10,#top
	DIE

#*****************************************************************************


time_delay
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit2
	dsj	a10,time_delay
#exit2	RETP


;#txt
;	move	a9,a0
;	sll	5,a0
;	addi	#random_hints,a0
;	move	*a0,a4,L
;	calla	print_string2
;
;	move	a9,a0
;	sll	5,a0
;	addi	#random_hints2,a0
;	move	*a0,a4,L
;	calla	print_string2
;
;	move	@mess_cursy,a0
;	addk	30,a0
;	move	a0,@mess_cursy
;
;
;	movk	1,a0
;	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON
;	ADJUST	ADJMUSIC		;GET MUSIC ON OFF FOR DEMO
;	MOVE	A0,A0
;	JRNZ	#NONO1
;	CLR	A0
;	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON
;
;	SOUND1	tick_snd
;	movk	1,a0
;	move	a0,@SOUNDSUP		;turn all sounds off
;
;#NONO1	rets




#*****************************************************************************
* INPUT:	a0 = 0	(1st half stats)
*		a0 = 1	(final game stats)
*-----------------------------------------------------------------------------

	STRUCTPD
	WORD	HTS_STARTX
	WORD	HTS_STARTY
	APTR	HTS_STATSADDR
	APTR	HTS_PALETTE1		;2 pts
	APTR	HTS_PALETTE2		;3 pts.
	APTR	HTS_PALETTE3		;turnovers
	APTR	HTS_PALETTE4		;points
	APTR	HTS_PALETTE5		;dunks
	APTR	HTS_PALETTE6		;assists
	APTR	HTS_PALETTE7		;steals
	APTR	HTS_PALETTE8		;blocks
	APTR	HTS_PALETTE9		;rebounds
	APTR	HTS_PALETTEa		;injured


	.asg	11,STARTX1
	.asg	90,STARTY1
	.asg	128,STARTX2
	.asg	90,STARTY2
	.asg	205,STARTX3
	.asg	90,STARTY3
	.asg	323,STARTX4
	.asg	90,STARTY4
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

;;	movi	4<<10+4<<5+7,a0
	clr	a0
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

	movi	#heading_setup,a2
	calla	setup_message
	PULLP	a0
	movi	#str_heading1,a4
	move	a0,a0
	jrz	#1st_half
	movi	#str_heading2,a4
#1st_half
	calla	print_string_C2

	move	@special_heads,a1,L
;	move	@player_toggle1,a0
	PUSH	a0,a1


	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrsb

	move	@special_heads,a0
	move	@special_heads+10h,a1

	move	a1,@special_heads
	move	a0,@special_heads+10h

#4_plyrsb
	movk	2,a0
	calla	create_title_bar
	calla	create_stat_titles
	clr	a0
	calla	create_score_backdrop		;for the scores
	movk	1,a0
	calla	create_score_backdrop		;for the scores

	movk	4,a0
	calla	create_player_heads
	calla	update_player_heads

	clr	a10
	calla	create_player_nubs

	movi	105,a1				;Y position
	calla	create_names

	calla	create_plyrs_name
	calla	create_name_backplates
	PULL	a0,a1
	move	a1,@special_heads,L

	callr	print_scores

	movi	[2,14],a8		;START AT COLOR 2, CYCLE 15 COLORS
	movi	BASTC_G_P,a9		;PAL NAME
	movi	BASTCYCGP,a10
	movk	3,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	movi	[2,14],a8		;START AT COLOR 2, CYCLE 15 COLORS
	movi	BASTC_R_P,a9		;PAL NAME
	movi	BASTCYCRP,a10
	movk	3,a11			;RATE OF CYCLE IN TICKS
	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

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

	movi	STARTY1+29,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrs_ps1
	movi	STARTY1+29,a0
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
	movi	STARTX2,a0
	move	a0,*a13(HTS_STARTX)

	movi	STARTY2+29,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#4_plyrs_ps2
	movi	STARTY2+29,a0
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
	movi	STARTX3,a0
	move	a0,*a13(HTS_STARTX)
	movi	STARTY3+29,a0
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
	movi	STARTX4,a0
	move	a0,*a13(HTS_STARTX)
	movi	STARTY4+29,a0
	move	a0,*a13(HTS_STARTY)
	callr	print_pstats

***********************************************


	movk	1,a0
	move	a0,@DISPLAYON

	SLEEPK	2
	calla	display_unblank

	movi	STAT_TEXT_ID,a10,L
	CREATE	FLSH_TXT_PID,change_pal_on_text

	move	@plyr_onfire,a10
	jrz	#nofire
	srl	1,a10
	jrnc	#nop1
	clr	a11
	CREATE	FIRE_ANIM_PID,anim_fire_for_best_plyr

#nop1	srl	1,a10
	jrnc	#nop2
	movk	1,a11
	CREATE	FIRE_ANIM_PID,anim_fire_for_best_plyr

#nop2	srl	1,a10
	jrnc	#nop3
	movk	2,a11
	CREATE	FIRE_ANIM_PID,anim_fire_for_best_plyr

#nop3	srl	1,a10
	jrnc	#nofire
	movk	3,a11
	CREATE	FIRE_ANIM_PID,anim_fire_for_best_plyr
#nofire

	SLEEPK	20

	calla	get_best_player
	calla	best_plyr_speech
	move	a0,a8
	.ref	flash_plyrs_mugshot
	CREATE	CYCPID,flash_plyrs_mugshot

	movi	21*TSEC,a10

#whopper_with_cheese
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit
	dsj	a10,#whopper_with_cheese
#exit
	SLEEPK	3

	calla	kill_fire_anim
	calla	kill_flsh_txt_proc

	movi	CYCPID,a0
	calla	KIL1C

	move	@gmqrtr,a0
	cmpi	4,a0
	jrlo	#noat
	JSRP	award_plr_attrib_pts

#noat
	SOUND1	bounce_snd

	move	@gmqrtr,a0
	cmpi	2,a0
	jrnz	#noth
	JSRP	plyr_subs
	clr	a0
	.ref	in_team_select
	move	a0,@in_team_select
#noth
	JSRP	buyin_screen
;TRIVIA
	movk	ADJTRIVIA,a0		;Get difficulty level
	calla	GET_ADJ
	move	a0,a0			;if value is NON-ZERO, dont allow
	jrnz	#notriv

	move	@gmqrtr,a0
	cmpi	4,a0
	jrlt	#notriv
	JSRP	trivia_game
#notriv
;TRIVIA

	clr	a0
	move	a0,@DISPLAYON

;	JSRP	QSNDRST

	SLEEPK	2

	calla	system_restoregame

	movi	JOIN_CYCLE_PID,a0
	calla	KIL1C

	movi	CLSDEAD|creditid,a0
	calla	obj_del1c		;kill credit/qrtr imgs

	calla	prt_credits

	CREATE0	start_msgs
	calla	fix_dropout_msgs

	move	@gmqrtr,a0
	cmpi	4,a0
	jrlt	#notn
	SOUND1	crwdbed_kill
#notn

	RETP


******************************************************************************
*
* RETURNS: a0 - best player (based on stats)
******************************************************************************
 SUBR	get_best_player

	movi	player_stats+(0*PS_SIZE*10h),a2
	callr	add_plyr_stats
	move	a14,a3
	movi	player_stats+(1*PS_SIZE*10h),a2
	callr	add_plyr_stats
	move	a14,a4
	movi	player_stats+(2*PS_SIZE*10h),a2
	callr	add_plyr_stats
	move	a14,a5
	movi	player_stats+(3*PS_SIZE*10h),a2
	callr	add_plyr_stats
	move	a14,a2

	clr	a0
	cmp	a4,a3
	jrhi	#pl2				;br=plr 2 is better
	move	a4,a3
	movk	1,a0
#pl2
	cmp	a5,a3
	jrhi	#pl3				;br=plr 2 is better
	move	a5,a3
	movk	2,a0
#pl3	
	cmp	a2,a3
	jrhi	#pl4				;br=plr 2 is better
	move	a2,a3
	movk	3,a0
#pl4
	rets


******************************************************************************
*		This routine add some of the players stats together
*
* INPUT:  reg a2 - ptr to plyr stat ram
* RETURN: reg a14 - stat additive
******************************************************************************
 SUBR	add_plyr_stats

	move	*a2(PS_2PTS_MADE*10h),a14
	move	*a2(PS_3PTS_MADE*10h),a1
	add	a1,a14
	sll	1,a14				;x 2
	add	a1,a14				;3 pts

	move	a14,a1
	srl	1,a1				;double value
	add	a1,a14

	move	*a2(PS_ASSISTS*10h),a1
	add	a1,a14
	move	*a2(PS_BLOCKS*10h),a1
	add	a1,a14
	move	*a2(PS_STEALS*10h),a1
	add	a1,a14
	rets


BASTC_G_P:
   .word   16 
   .word   00000h,00000h,00280h,003e0h,003e0h,003e0h,003c0h,003a0h
   .word   003a0h,00380h,00360h,00340h,00320h,00300h,002e0h,07fffh

BASTCYCGP:
   .word   003e0h,003c0h,003a0h,003a0h,00380h,00360h,00340h,00320h
   .word   00300h,002e0h,00300h,00320h,00340h,00360h,00380h,003a0h
   .word   003c0h,003c0h,003a0h,00380h,00340h,00320h,00340h,00380h
   .word   003a0h,003c0h,003a0h,00380h,00360h,00340h,00300h,002e0h
   .word   00300h,00300h,00320h,00340h,00340h,00360h,00360h,00380h
   .word   003a0h,003a0h,003c0h,003e0h

   .word   003e0h,003c0h,003a0h,003a0h,00380h,00360h,00340h,00320h
   .word   00300h,002e0h,00300h,00320h,00340h,00360h,00380h,003a0h
   .word   003c0h,003c0h,003a0h,00380h,00340h,00320h,00340h,00380h
   .word   003a0h,003c0h,003a0h,00380h,00360h,00340h,00300h,002e0h
   .word   00300h,00300h,00320h,00340h,00340h,00360h,00360h,00380h
   .word   003a0h,003a0h,003c0h,003e0h
   .word   -1
   .even


BASTC_R_P:
   .word   16 
   .word   00000h,00000h,05000h,07c00h,07c00h,07c00h,07c00h,07800h
   .word   07800h,07400h,07000h,06c00h,06800h,06400h,06000h,07fffh



BASTCYCRP:
   .word   07c00h,07800h,07800h,07400h
   .word   07000h,06c00h,06800h,06400h,06000h,06400h,06800h,06c00h
   .word   07000h,07400h,07800h
   .word   07800h,07400h,06c00h,06800h,06c00h,07000h,07400h,07800h
   .word   07400h,06c00h,06800h,06400h,06000h,06400h,06400h,06800h
   .word   06c00h,06c00h,07000h,07000h,07400h,07800h,07800h,07c00h

   .word   07c00h,07800h,07800h,07400h
   .word   07000h,06c00h,06800h,06400h,06000h,06400h,06800h,06c00h
   .word   07000h,07400h,07800h
   .word   07800h,07400h,06c00h,06800h,06c00h,07000h,07400h,07800h
   .word   07400h,06c00h,06800h,06400h,06000h,06400h,06400h,06800h
   .word   06c00h,06c00h,07000h,07000h,07400h,07800h,07800h,07c00h
   .word   -1
   .even


***********************************************
***********************************************
 SUBR	plyr_subs

	movi	DMAWNZ,a0
	movi	OBJLST,a1
	jruc	so20

so10	move	a0,*a1(OFLAGS)
so20	move	*a1,a1,L
	jrnz	so10

;	movi	CYCPID,a0
;	calla	KIL1C

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
	.long	HTSTATSBMOD
	.word	0,0
	.long	0


#halftime_mod2
	.long	HTSTATSBMOD
	.word	0,0
	.long	0

#heading_setup
	PRINT_STR	brush20_ascii,8,0,200,7,BRSHGYOP,0
#str_heading1
	.string	"1st half stats",0
#str_heading2
	.string	"end game stats",0

	.even

#*****************************************************************************

	.asg	 44,SX1
	.asg	359,SX2

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
	PRINT_STR	brush20_ascii,8,0,200,7,BRSH_Y_P,0

#*****************************************************************************
*
* INPUT:	a2 = * player to check
*		a3 = * other player 1
*		a4 = * other player 2
*		a5 = * other player 3
*
* message_palette = BAST_Y_P default
*		  = BAST_W_P if highest stat
*
*-----------------------------------------------------------------------------
 SUBRP	highlight_best

	movi	BASTC_W_P,a6
	move	*a2(PS_2PTS_MADE*10h),a0
	move	*a2(PS_3PTS_MADE*10h),a7
	add	a7,a0
	jrz	#not_best1

	move	*a3(PS_2PTS_MADE*10h),a1
	move	*a3(PS_3PTS_MADE*10h),a7
	add	a7,a1
	cmp	a1,a0
	jrlo	#not_best1

	move	*a4(PS_2PTS_MADE*10h),a1
	move	*a4(PS_3PTS_MADE*10h),a7
	add	a7,a1
	cmp	a1,a0
	jrlo	#not_best1

	move	*a5(PS_2PTS_MADE*10h),a1
	move	*a5(PS_3PTS_MADE*10h),a7
	add	a7,a1
	cmp	a1,a0
	jrlo	#not_best1
	movi	BASTC_G_P,a6
#not_best1
	move	a6,*a13(HTS_PALETTE1),L

	movi	BASTC_W_P,a6
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
	movi	BASTC_G_P,a6
#not_best2
	move	a6,*a13(HTS_PALETTE2),L

	movi	BASTC_W_P,a6
	move	*a2(PS_2PTS_MADE*10h),a0
	move	*a2(PS_3PTS_MADE*10h),a7
	add	a7,a0
	sll	1,a0				;x 2
	add	a7,a0				;3 pts
	jrz	#not_best4

	move	*a3(PS_2PTS_MADE*10h),a1
	move	*a3(PS_3PTS_MADE*10h),a7
	add	a7,a1
	sll	1,a1				;x 2
	add	a7,a1				;3 pts
	cmp	a1,a0
	jrlo	#not_best4

	move	*a4(PS_2PTS_MADE*10h),a1
	move	*a4(PS_3PTS_MADE*10h),a7
	add	a7,a1
	sll	1,a1				;x 2
	add	a7,a1				;3 pts
	cmp	a1,a0
	jrlo	#not_best4

	move	*a5(PS_2PTS_MADE*10h),a1
	move	*a5(PS_3PTS_MADE*10h),a7
	add	a7,a1
	sll	1,a1				;x 2
	add	a7,a1				;3 pts
	cmp	a1,a0
	jrlo	#not_best4

	movi	BASTC_G_P,a6
#not_best4
	move	a6,*a13(HTS_PALETTE4),L


	movi	BASTC_W_P,a6
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
	movi	BASTC_G_P,a6
#not_best5
	move	a6,*a13(HTS_PALETTE5),L


	movi	BASTC_W_P,a6
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
	movi	BASTC_G_P,a6
#not_best6
	move	a6,*a13(HTS_PALETTE6),L


	movi	BASTC_W_P,a6
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
	movi	BASTC_G_P,a6
#not_best7
	move	a6,*a13(HTS_PALETTE7),L


	movi	BASTC_W_P,a6
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
	movi	BASTC_G_P,a6
#not_best8
	move	a6,*a13(HTS_PALETTE8),L


	movi	BASTC_W_P,a6
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
	movi	BASTC_G_P,a6
#not_best9
	move	a6,*a13(HTS_PALETTE9),L


	movi	BASTC_W_P,a6
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
	movi	BASTC_R_P,a6
#not_besta
	move	a6,*a13(HTS_PALETTEa),L


;check turnovers
	movi	BASTC_W_P,a6
	move	*a2(PS_TURNOVERS*10h),a0
	jrz	#not_bestb
	move	*a3(PS_TURNOVERS*10h),a1
	cmp	a1,a0
	jrlo	#not_bestb
	move	*a4(PS_TURNOVERS*10h),a1
	cmp	a1,a0
	jrlo	#not_bestb
	move	*a5(PS_TURNOVERS*10h),a1
	cmp	a1,a0
	jrlo	#not_bestb
	movi	BASTC_R_P,a6
#not_bestb
	move	a6,*a13(HTS_PALETTE3),L
	rets


#*****************************************************************************

	.asg	18,COLOFF1
	.asg	67,COLOFF2

 SUBRP	print_pstats

	movi	#stats_setup,a2
	calla	setup_message

	movi	STAT_TEXT_ID,a0
	move	a0,@mess_objid

*** all shots made / all shots taken	percentage

	move	*a13(HTS_PALETTE1),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	move	a0,@mess_cursy

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
	addi	COLOFF1+6,a0
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
	addi	COLOFF2-3,a0
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

*** 3pt shots made / 3pt shots taken	percentage

	move	*a13(HTS_PALETTE2),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	1*YSPACING1,a0
	move	a0,@mess_cursy

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
	addi	COLOFF1+6,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_3PTS_TRY*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string

	move	*a13(HTS_STARTX),a0
	addi	COLOFF2-3,a0
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

*** total points

	move	*a13(HTS_PALETTE4),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	2*YSPACING1,a0
	move	a0,@mess_cursy

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	clr	a6
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

*** dunks

	move	*a13(HTS_PALETTE5),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	3*YSPACING1,a0
	move	a0,@mess_cursy

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_DUNKS_MADE*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

*** assists

	move	*a13(HTS_PALETTE6),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	4*YSPACING1,a0
	move	a0,@mess_cursy

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_ASSISTS*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

*** steals

	move	*a13(HTS_PALETTE7),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	5*YSPACING1,a0
	move	a0,@mess_cursy

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_STEALS*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

*** blocks

	move	*a13(HTS_PALETTE8),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	6*YSPACING1,a0
	move	a0,@mess_cursy

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_BLOCKS*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

*** rebounds

	move	*a13(HTS_PALETTE9),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	7*YSPACING1,a0
	move	a0,@mess_cursy

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
	addi	COLOFF1+6,a0
	move	a0,@mess_cursx
	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_DEF_REB*10h),a0
	move	*a10(PS_OFF_REB*10h),a1
	add	a1,a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string

*** injury

	move	*a13(HTS_PALETTEa),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	8*YSPACING1,a0
	move	a0,@mess_cursy

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_INJURY*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R

*** turnovers

	move	*a13(HTS_PALETTE3),a0,L
	move	a0,@message_palette,L

	move	*a13(HTS_STARTY),a0
	addi	9*YSPACING1,a0
	move	a0,@mess_cursy

	move	*a13(HTS_STARTX),a0
	addi	COLOFF1+8,a0
	move	a0,@mess_cursx

	move	*a13(HTS_STATSADDR),a10,L
	move	*a10(PS_TURNOVERS*10h),a0
	movi	99,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	calla	print_string_R
	rets


#stats_setup
	PRINT_STR	bast7tcyc_ascii,4,0,200,LN0,BASTC_W_P,0

#str_slash
	.string	"/",0
#str_pct
	.string	"%",0
	.even





	.asg	 15,OBJID
	.asg	 16,NAME_ID
	.asg	300,LOGO_X
	.asg	 80,LOGO_Y
	.asg	-10,HD1_X
	.asg	 65,HD2_X
	.asg	140,HD3_X
	.asg	215,HD4_X
	.asg	290,HD5_X
	.asg	190,HDS_Y

#*****************************************************************************
******************************************************************************

 SUBRP	show_nba_plyrs

	calla	display_blank
	calla	WIPEOUT
	calla	pal_clean

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

	movi	#players_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movk	1,a0
	calla	create_title_bar

	movi	#heading_setup,a2
	calla	setup_message

	movi	kern_chars,a0
	move	a0,@mess_justify,L	;justification method

	movi	132,a0
	move	a0,@mess_cursx2

	movi	#str_staring,a4
	calla	print_string2b

	movk	1,a0
	move	a0,@DISPLAYON
	calla	display_unblank

	clr	a0
	move	a0,@tmloop

;create logo backdrop

	movi	[LOGO_X,0],a0,L			;X
	movi	[LOGO_Y,0],a1,L			;Y
	movi	BALLBAK1,a2
	movi	1900,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

;print city name and team name
#lp
	move	@tmnbr,a8
	cmpi	NUM_TEAMS-1,a8
	jrle	#vok
	clr	a0
	move	a0,@tmnbr
#vok
	sll	6,a8
	addi	city_names_str_tbl,a8
	move	*a8+,a4,L

	movi	#tm_nme_str_setup,a2
	calla	setup_message

	movk	OBJID,a0
	move	a0,@mess_objid
	calla	print_string_C2			;city of team
		
	move	@mess_cursy,a0
	addk	23,a0
	move	a0,@mess_cursy

	move	*a8,a4,L
	calla	print_string_C2			;name of team

;create team logo

	move	@tmnbr,a2
	sll	5,a2
	addi	logos,a2,L
	move	*a2,a2,L

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movk	OBJID,a5
	movi	[LOGO_X,0],a0,L			;X
	movi	[LOGO_Y,0],a1,L			;Y
	movi	1901,a3				;z pos
	calla	BEGINOBJ2

;head 1
	movi	[HD1_X,0],a0,L			;X
	movi	[HDS_Y,0],a1,L			;Y
	movi	MUGPLAT,a2
	movi	1900,a3				;z pos
	calla	BEGINOBJ2
		 
	move	@tmnbr,a11
	movi	5*32,a0
	mpyu	a0,a11
	addi	player_heads2,a11,L
	move	*a11+,a2,L

	movi	[HD1_X+26,0],a0,L			;X
	movi	[HDS_Y+10,0],a1,L			;Y
	movi	2000,a3				;z pos
	calla	BEGINOBJ2

	clr	a1
	callr	create_plr_name

	SLEEPK	1
	movk	1,a0
	move	a0,@DISPLAYON
	move	a0,@dpageflip


	movi	TSEC-20,a8
#lp1	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#mksnd
	dsj	a8,#lp1

	movk	NAME_ID,a0
	calla	obj_del1c

;head 2
	movi	[HD2_X,0],a0,L			;X
	movi	[HDS_Y,0],a1,L			;Y
	movi	1900,a3				;z pos
	movi	MUGPLAT,a2
	movi	1900,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a6				;x vel
	clr	a7				;y vel
	movk	OBJID,a5
	calla	BEGINOBJ2

	movi	[HD2_X+26,0],a0,L			;X
	movi	[HDS_Y+10,0],a1,L			;Y
	move	*a11+,a2,L
	movi	2000,a3				;z pos
	calla	BEGINOBJ2

	movk	1,a1
	callr	create_plr_name

	movi	TSEC-20,a8
#lp2	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#mksnd
	dsj	a8,#lp2

	movk	NAME_ID,a0
	calla	obj_del1c

;head 3
	movi	[HD3_X,0],a0,L			;X
	movi	[HDS_Y,0],a1,L			;Y
	movi	1900,a3				;z pos
	movi	MUGPLAT,a2
	movi	1900,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a6				;x vel
	clr	a7				;y vel
	movk	OBJID,a5
	calla	BEGINOBJ2

	movi	[HD3_X+26,0],a0,L			;X
	movi	[HDS_Y+10,0],a1,L			;Y
	move	*a11+,a2,L
	movi	2000,a3				;z pos
	calla	BEGINOBJ2

	movk	2,a1
	callr	create_plr_name

	movi	TSEC-20,a8
#lp3	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#mksnd
	dsj	a8,#lp3

	movk	NAME_ID,a0
	calla	obj_del1c

;head 4
	movi	[HD4_X,0],a0,L			;X
	movi	[HDS_Y,0],a1,L			;Y
	movi	1900,a3				;z pos
	movi	MUGPLAT,a2
	movi	1900,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a6				;x vel
	clr	a7				;y vel
	movk	OBJID,a5
	calla	BEGINOBJ2

	movi	[HD4_X+26,0],a0,L			;X
	movi	[HDS_Y+10,0],a1,L			;Y
	move	*a11+,a2,L
	movi	2000,a3				;z pos
	calla	BEGINOBJ2

	movk	3,a1
	callr	create_plr_name

	movi	TSEC-20,a8
#lp4	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#mksnd
	dsj	a8,#lp4

	movk	NAME_ID,a0
	calla	obj_del1c

;head 5
	movi	[HD5_X,0],a0,L			;X
	movi	[HDS_Y,0],a1,L			;Y
	movi	1900,a3				;z pos
	movi	MUGPLAT,a2
	movi	1900,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a6				;x vel
	clr	a7				;y vel
	movk	OBJID,a5
	calla	BEGINOBJ2

	movi	[HD5_X+26,0],a0,L			;X
	movi	[HDS_Y+10,0],a1,L			;Y
	move	*a11+,a2,L
	movi	2000,a3				;z pos
	calla	BEGINOBJ2

	movk	4,a1
	callr	create_plr_name

	movi	TSEC-10,a8
#lp5	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#mksnd
	dsj	a8,#lp5

	clr	a0				;Keep this page up while
	move	a0,@DISPLAYON			; building the next one
	move	a0,@dpageflip

	movk	NAME_ID,a0
	calla	obj_del1c

	movk	OBJID,a0
	calla	obj_del1c

	move	@tmnbr,a0
	inc	a0
	move	a0,@tmnbr
	cmpi	NUM_TEAMS-1,a0
	jrle	#nxt
	clr	a0
	move	a0,@tmnbr
#nxt
	move	@tmloop,a0
	inc	a0
	move	a0,@tmloop
	subk	4,a0
	jrlt	#lp
	jruc	#xb
#mksnd
      	clr	a0
	move	a0,@SOUNDSUP		;turn all sounds on
	SOUND1	bounce_snd
	movk	1,a0
	move	a0,@SOUNDSUP		;turn all sounds off
#xb
	movk	OBJID,a0
	calla	obj_del1c
	movk	NAME_ID,a0
	calla	obj_del1c
	RETP
    

#tm_nme_str_setup
	PRINT_STR	brush20_ascii,8,0,125,59,BRSHGWKP,0
	

#heading_setup
	PRINT_STR	brush20_ascii,8,0,200,7,BRSHGYOP,kern_chars


#str_staring
  .string  "ST",1,-4,"ARRING:",0
  .even


#players_mod
	.long	ATTRACTBMOD
	.word	0,0
	.long	0



******************************************************************************
******************************************************************************
 SUBRP	create_plr_name

	move	@tmnbr,a0
	sll	7,a0
	move	@tmnbr,a10
	sll	5,a10
	add	a0,a10
	addi	plyr_names_img_tbl,a10
	sll	5,a1				;goto player name
	add	a1,a10
	move	*a10,a2,L

	movi	200,a0
	move	*a2(ISIZEX),a1
	srl	1,a1
	sub	a1,a0
	sll	16,a0

	movi	[222,0],a1,L			;Y
	movk	NAME_ID,a5
	calla	BEGINOBJ2
	rets


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
	move	@player1_data+PR_NAME1,a0
	jrgt	#have_initials
#nop1
	move	@PSTATUS,a0
	btst	1,a0
	jrz	#nop2
	move	@player2_data+PR_NAME1,a0
	jrgt	#have_initials
#nop2
	move	@PSTATUS,a0
	btst	2,a0
	jrz	#nop3
	move	@player3_data+PR_NAME1,a0
	jrgt	#have_initials
#nop3
	move	@PSTATUS,a0
	btst	3,a0
	jrz	#nop4
	move	@player4_data+PR_NAME1,a0
	jrgt	#have_initials
#nop4
	RETP


#have_initials

	calla	display_blank
	calla	WIPEOUT			;CLEAN SYSTEM OUT

	clr	a0
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

;;;	MOVI	[3,9],a8		;START AT COLOR 3, CYCLE 9 COLORS
;;;	MOVI	SGMD8PLV,a9		;PAL NAME
;;;	MOVI	COLTAB,a10		;TABLE TO CYCLE WITH
;;;	MOVK	3,a11			;RATE OF CYCLE IN TICKS
;;;	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	CREATE0	credits3

	movk	1,a10
	callr	print_column
	movk	2,a10
	callr	print_column

;	movi	#rank_mod,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrnz	#is_2

	clr	a10
	callr	print_column
	movk	3,a10
	callr	print_column
#is_2
	SLEEPK	2
	calla	display_unblank

	SLEEP	TSEC
	movi	9*TSEC,a10
#whopper_with_cheese
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrnz	#exit
	dsj	a10,#whopper_with_cheese
#exit
	SLEEPK	1

	RETP





#rank_mod
	.long	ENTER4BMOD
	.word	0,0
	.long	ATRIBUTEBMOD		;NEW stats box map
	.word	0,178		;x,y
	.long	0


#rank_kit_mod
	.long	ENTERKITBMOD
	.word	0,0		;x,y
	.long	ATRBKITBMOD			;option screen background
	.word	0,178		;x,y
	.long	0




	.asg	25,RANKY
	.asg	40,RECY
	.asg	51,WLY
	.asg	62,PCTY

	.asg	78,STREAKY1
	.asg	88,STREAKY2

	.asg	106,HAVDEFY1
	.asg	116,HAVDEFY2
	.asg	126,HAVDEFY3

	.asg	144,NEXTY1
	.asg	154,NEXTY2
	.asg	164,NEXTY3

	.asg	204,INITY

#heading_setup
	PRINT_STR	bast18_ascii,8,0,200,6,BST18G_P,0
#rank_setup1
	PRINT_STR	bast8t_ascii,3,0,0,RANKY,BAST_W_P,0
#initials_setup1
	PRINT_STR	bast8_ascii,5,0,94,6,BAST_W_P,0

stat_title_tbl
	.long	#stats_setup1
	.long	#stats_setup2
	.long	#stats_setup3
	.long	#stats_setup4

#stats_setup1
	PRINT_STR	bast8_ascii,4,0,344,11,BAST_W_P,0
#stats_setup2
	PRINT_STR	bast8_ascii,4,0,344,11,BAST_W_P,0
#stats_setup3
	PRINT_STR	bast8_ascii,4,0,344,11,BAST_W_P,0
#stats_setup4
	PRINT_STR	bast8_ascii,4,0,344,11,BAST_W_P,0


#str_cpu
	.string	"CPU",0
#str_rank
	.string	"RANK: #",0	;"RANK #"
#str_record
;	.string	81h,0		;"RECORD: "
;#str_w	.string 8ah," - ",0	;" (W) - "
;#str_l	.string	8bh,0		;"(L)"
	.string	"RECORD",0	;"RECORD: "
#str_w	.string "(W) - ",0	;" (W) - "
#str_l	.string	"(L)",0		;"(L)"

#str_pct
	.string	"PCT: .",0	;"PCT: ."
;	.string	83h,"  .",0	;"PCT: ."
#str_pct100
	.string	"PCT: 1.000",0	;"PCT: 1.000"
;	.string	83h,"  1.000",0	;"PCT: 1.000"
#str_streak
	.string	"STREAK",0
#str_win
	.string	" WIN",0
#str_wins
	.string	" WINS",0
#str_none
	.string	"NONE",0
#str_next
	.string	"next cpu",0
#str_vs
	.string	"opponent",0

;#str_hd0	.string	87h,0		;"YOU HAVE"
;#str_hd1	.string 85h,' ',0	;"DEFEATED XX"
;#str_hd2	.string	88h,0		;"OF THE 29"
;#str_hd3	.string	89h,0		;"NBA TEAMS"
;#str_all	.string	" ",8ch,0	;" ALL"
#str_hd1	.string "DEFEATED ",0	;"DEFEATED XX"
#str_hd2	.string	"OF THE 29",0	;"OF THE 29"
#str_hd3	.string	"NBA TEAMS",0	;"NBA TEAMS"
;#str_all	.string	" ALL",0	;" ALL"
#str_all	.string	" 29",0		;" ALL"
#str_dash	.string	"-",0


	.even

#pdatas
	.long	player1_data
	.long	player2_data
	.long	player3_data
	.long	player4_data

#center_xs
	.word	54,60,	0,0		;player 1
	.word	150,151,101,0		;player 2
	.word	248,254,295,0		;player 3
	.word	344,345,0,0		;player 4


;-----------------------------------------------------------------------------
;a10  = player number (0-3)
;-----------------------------------------------------------------------------
print_column

	move	@PSTATUS2,a0
	btst	a10,a0
	jrz	#cpu_player

	move	a10,a0
	sll	5,a0			;x 32 bits
	addi	#pdatas,a0
	move	*a0,a11,L

	move	*a11(PR_NAME1),a0
	jrle	#no_initials

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
	addi	PR_NAME1,a4
	calla	get_name_string
	calla	print_string_C

;print 'stats' title
	calla	create_heading2

;	move	a10,a2
;	sll	5,a2
;	addi	stat_title_tbl,a2
;	move	*a2,a2
;	calla	setup_message
;	movi	stats_str,a4,L
;	calla	print_string_C2

	movi	#rank_setup1,a2
	calla	setup_message

	move	a10,a0
	sll	6,a0			;x16x4
	addi	#center_xs,a0
	move	@TWOPLAYERS,a1		;0 = NO, 1 = YES 2 players
	jrz	#not_2d
	addi	20h,a0
#not_2d
	move	*a0,a0
	move	a0,@mess_cursx

	movi	BAST_Y_P,a0
	move	a0,@message_palette,L

	movi	#str_rank,a4
	callr	copy_rom_string
	move	*a11(PR_RANK),a0	;rank
	cmpi	10,a0
	jrgt	#notten
	movi	BAST_W_P,a1		;highlight cycle colour
	move	a1,@message_palette,L
#notten
	movi	999,a1			;max value
	callr	dec_to_asc
	callr	concat_string
	callr	print_string_C		;centered

	movi	BAST_Y_P,a0		;highlight cycle colour
	move	a0,@message_palette,L

	movi	RECY,a0
	move	a0,@mess_cursy
	movi	#str_record,a4		;"RECORD:"
	callr	print_string_C2		;centered

	movi	BAST_W_P,a0
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

	movi	BAST_W_P,a0
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

	movi	BAST_Y_P,a0
	move	a0,@message_palette,L

;	move	*a11(PR_WINSTREAK),a0	;no. consecutive wins
;	cmpi	3,a0
;	jrlt	#no_hilght
;	movi	BAST_W_P,a1		;highlight cycle colour
;	move	a1,@message_palette,L
;#no_hilght
	movi	STREAKY1,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_streak,a4
	callr	print_string_C2

	movi	BAST_W_P,a0
	move	a0,@message_palette,L

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
	movi	BAST_Y_P,a0
	move	a0,@message_palette,L

	movi	HAVDEFY1,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_hd1,a4		;"DEFEATED NN"
	callr	copy_rom_string

	move	*a11(PR_NUMDEF),a0	;number teams defeated
	cmpi	NUM_TEAMS,a0
	jrlo	#not_all

	movi	#str_all,a4		;" ALL"
	callr	concat_rom_string
	jruc	#skipit
#not_all
	movi	NUM_TEAMS,a1			;max value
	callr	dec_to_asc
	callr	concat_string
#skipit
	callr	print_string_C		;centered

	movi	BAST_W_P,a0
	move	a0,@message_palette,L

	movi	HAVDEFY2,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_hd2,a4		;"OF THE 30"
	callr	print_string_C2		;centered

	movi	HAVDEFY3,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_hd3,a4		;"NBA TEAMS"
	callr	print_string_C2		;centered

	move	*a11(PR_NUMDEF),a0	;number teams defeated
	cmpi	NUM_TEAMS,a0
	jreq	#defeated_all

	movi	BAST_Y_P,a0
	move	a0,@message_palette,L

	movi	NEXTY1,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_next,a4
	callr	print_string_C2

	movi	NEXTY2,a0
	move	a0,@mess_cursy		;message cursor pos Y
	movi	#str_vs,a4
	callr	print_string_C2

	movi	BAST_W_P,a0
	move	a0,@message_palette,L

	movi	NEXTY3,a0
	move	a0,@mess_cursy		;message cursor pos Y

	movi	bast8_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table

	move	*a11(PR_TEAMSDEF),a1,L
	andi	ALL_TMS_DEFEATD,a1
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


stats_str
	.string	"STATS",0
	.even


#*****************************************************************************
;
;
;deloff	SLEEP	1ch
;	callr	deloffbot
;	jruc	deloff
;
;deloffbot:
;;delete foreground objects that are off bottom of screen
;	move	@WORLDTLY,a1,L
;	addi	[260,0],a1
;	srl	16,a1
;	movi	RAMLST,a3
;	clr	a0
;	move	a0,*a3,L
;	movi	OBJLST,a0
;sobjs1
;	move	*a0,a0,L
;	jreq	sobjsx
;	move	*a0(OYPOS),a2
;	cmp	a2,a1
;	jrnc	sobjs1
;contab
;	move	a0,*a3+,L		;img to be deleted
;	clr	a4
;	move	a4,*a3,L		;zero next entry
;	move	a4,*a3(32),L		;zero next entry
;	jruc	sobjs1
;sobjsx
;	movi	RAMLST,a1
;delt	move	*a1+,a0,L
;	jrz	delx
;	PUSH	a1
;	calla	DELOBJ
;	PULL	a1
;	jruc	delt
;delx	rets


#********************************

 SUBR	winning_msg

	movi	LN0_setup,a2
	calla	setup_message
	move	*a2,a0,L
	move	a0,@mess_justify,L	;justification method
	movi	CLSDEAD|123,a0
	move	a0,@mess_objid

	move	@team1,a14
	move	@scores,a0
	move	@scores+16,a1
	cmp	a0,a1
	jrlt	#ok
	move	@team2,a14
#ok
	move	a14,a10
	sll	5,a14
	addi	strings,a14
	move	*a14,a4,L
	move	*a4+,a0
	move	a0,@mess_cursx2

	calla	print_string2b

	movi	#swin,a4
	subk	30-1,a10
	jrnz	#ok1
	movi	#swina,a4
#ok1
	move	*a4+,a0
	move	a0,@mess_cursx2
	movi	114,a0
	move	a0,@mess_cursy

	calla	print_string2b

	CREATE0	flash_bigtxt2
	move	a0,a9
	
	SLEEP	3*60

	move	a9,a0
	calla	KILL

	movi	TYPTEXT,a0
	calla	obj_del1c
	movi	CLSDEAD|123,a0
	calla	obj_del1c		;delete text

	DIE


LN0_setup
	PRINT_STR	hangfnt38_ascii,14,0,200,60,HANGF_R_P,kern_chars
	.even

strings	.long	#s1,#s2,#s3,#s4,#s5,#s6,#s7,#s8,#s9,#s10
	.long	#s11,#s12,#s13,#s14,#s15,#s16,#s17,#s18,#s19,#s20
	.long	#s21,#s22,#s23,#s24,#s25,#s26,#s27,#s28
	.long	#s29,#s30

#s1	.word	96
	.string	"H",1,-6,"A",1,4,"W",1,-5,"K",1,-5,"S",0
#s2	.word	85
	.string	"C",1,-4,"E",1,-5,"L",1,6,"T",1,-3,"I",1,-1,"C",1,-2,"S",0
#s3	.word	74
	.string	"H",1,-3,"O",1,-2,"R",1,-3,"N",1,-5,"E",1,1,"T",1,-5,"S",0
#s4	.word	113
	.string	"B",1,-1,"U",1,-5,"L",1,1,"L",1,2,"S",0
#s5	.word	49
	.string	"C",1,-5,"A",1,4,"V",1,-10,"A",1,3,"L",1,3,"I",1,-3,"E",1,-4,"R",1,-2,"S",0
#s6	.word	40
	.string	"M",1,-6,"A",1,4,"V",1,-7,"E",1,-4,"R",1,-1,"I",1,-1,"C",1,-3,"K",1,-5,"S",0
#s7	.word	76
	.string	"N",1,-3,"U",1,-3,"G",1,-1,"G",1,-4,"E",1,1,"T",1,-5,"S",0
#s8	.word	80
	.string	"P",1,-1,"I",1,-1,"S",1,2,"T",1,-4,"O",1,-3,"N",1,-4,"S",0
#s9	.word	55
	.string	"W",1,-8,"A",1,3,"R",1,-3,"R",1,-1,"I",1,-1,"O",1,-2,"R",1,-2,"S",0
#s10	.word	75
	.string	"R",1,-2,"OC",1,-3,"K",1,-6,"E",1,1,"T",1,-5,"S",0
#s11	.word	94
	.string	"P",1,-7,"A",1,3,"C",1,-4,"E",1,-4,"R",1,-2,"S",0
#s12	.word	68
	.string	"C",1,-4,"L",1,3,"I",1,-2,"P",1,-3,"P",1,-4,"E",1,-4,"R",1,-2,"S",0
#s13	.word	93
	.string	"L",1,1,"A",1,2,"K",1,-6,"E",1,-4,"R",1,-2,"S",0
#s14	.word	130
	.string	"H",1,-6,"E",1,-5,"A",1,3,"T",0
#s15	.word	108
	.string	"B",1,-1,"U",1,-3,"C",1,-3,"K",1,-5,"S",0
#s16	.word	68
	.string	"T",1,3,"'",1,1,"W",1,-4,"O",1,-3,"L",1,6,"V",1,-7,"E",1,-3,"S",0
#s17	.word	129
	.string	"N",1,-5,"E",1,1,"T",1,-5,"S",0
#s18	.word	92
	.string	"K",1,-5,"N",1,-3,"I",1,-1,"C",1,-3,"K",1,-5,"S",0
#s19	.word	109
	.string	"M",1,-6,"A",1,2,"G",1,-1,"I",1,-1,"C",0
#s20	.word	113
	.string	"7",1,-3,"6",1,-1,"E",1,-4,"R",1,-2,"S",0
#s21	.word	126
	.string	"S",1,-1,"U",1,-5,"N",1,-4,"S",0
#s22	.word	77
	.string	"B",1,-4,"L",1,1,"A",1,2,"Z",1,-5,"E",1,-4,"R",1,-2,"S",0
#s23	.word	112
	.string	"K",1,-4,"I",1,-4,"N",1,-3,"G",1,-2,"S",0
#s24	.word	110
	.string	"S",1,-3,"P",1,-1,"U",1,-4,"R",1,-2,"S",0
#s25	.word	96
	.string	"SO",1,-3,"N",1,-2,"I",1,-1,"C",1,-2,"S",0
#s26	.word	73
	.string	"R",1,-3,"A",1,2,"P",1,3,"T",1,-4,"O",1,-2,"R",1,-2,"S",0
#s27	.word	128
	.string	"J",1,-7,"A",1,2,"Z",1,-6,"Z",0
#s28	.word	58
	.string	"G",1,-3,"R",1,-1,"I",1,-3,"Z",1,-6,"Z",1,-5,"L",1,3,"I",1,-3,"E",1,-3,"S",0
#s29	.word	83
	.string	"B",1,-1,"U",1,-5,"L",1,1,"L",1,1,"E",1,1,"T",1,-5,"S",0
#s30	.word	29
	.string	"T",1,-6,"H",1,-6,"E C",1,-4,"H",1,-6,"A",1,2,"M",1,-5,"P",1,-2,"S",0

#swina	.word	49
	.string	"W",1,-5,"I",1,-4,"N A",1,2,"G",1,-4,"A",1,3,"I",1,-5,"N",0
#swin	.word	144
	.string	"W",1,-5,"I",1,-4,"N",0
	.even


#*****************************************************************************
 SUBR	trivia_rules

	movk	ADJTRIVIA,a0		;Get difficulty level
	calla	GET_ADJ
	move	a0,a0			;if value is NON-ZERO, dont allow
	jrnz	#notriv

	calla	display_blank
	calla	WIPEOUT

	clr	a0
	move	a0,@dtype		;2D

	movk	1,a0			;page flipping on
	move	a0,@dpageflip
	move	a0,@DISPLAYON

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L

	clr	a0
	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L
	move	a0,@IRQSKYE

	calla	display_unblank

	SLEEPK	1			;Make sure page is clear

	movi	#strops,a11
#lp
	clr	a0
	move	a0,@DISPLAYON
	move	a0,@dpageflip
	SLEEPK	1

	movi	#rules_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movk	1,a0
	calla	create_title_bar

	movk	24,a0
	move	a0,@mess_line_spacing

	movi	#heading_setup,a2
	calla	setup_message
	movi	#str_heading,a4
	calla	print_string_C2

	movi	#nopurch_setup,a2
	calla	setup_message
	movi	#str_nopurch,a4
	calla	print_string_C2

	movi	#rules_setup,a2
	calla	setup_message
	movk	9,a0
	move	a0,@mess_line_spacing

	jruc	#nxt

#dostr
	move	*a11+,a0
	move	*a11+,a1,L
	move	a0,@mess_cursx
	move	a1,@message_palette,L
	calla	print_string_C2
#nxt
	move	*a11+,a4,L
	jrnz	#dostr

	movk	1,a0
	move	a0,@DISPLAYON
	SLEEPK	1
	clr	a0
	move	a0,@DISPLAYON

	clr	a1
	dec	a1
	calla	obj_delc
	calla	KILBGND

	move	*a11+,a4,L
	jrn	#dostr

	move	a4,a10

	movk	1,a0
	move	a0,@dpageflip
	SLEEPK	1
	clr	a0
	move	a0,@dpageflip
#butp
	SLEEPK	1
	calla	get_all_buttons_cur2
	jrz	#nobutp2
	SOUND1	bounce_snd
	jruc	#butp2
#nobutp2
	dsj	a10,#butp

#butp2
	move	*a11,a4,L
	jrnz	#lp

	clr	a10
	movk	8,a11
	CREATE0	fade_down

	SLEEP	40
#notriv
 	RETP


#strops
	LWL	#rules_str1,  87,#bas7_alt
	LWL	#rules_str1a, 245,#bas7_white
	LWL	#rules_str1b, 200,#bas7_white
	.long	0
	LWL	#rules_str2,  64,#bas7_alt
	LWL	#rules_str2a, 226,#bas7_white
	LWL	#rules_str2b, 200,#bas7_white
	.long	0
	.long	TSEC*25

	LWL	#rules_str3,  48,#bas7_alt
	LWL	#rules_str3a, 226,#bas7_white
	LWL	#rules_str3b, 200,#bas7_white
	.long	0
	LWL	#rules_str4,  121,#bas7_alt
	LWL	#rules_str4a, 273,#bas7_white
	LWL	#rules_str4b, 200,#bas7_white
	.long	0
	LWL	#rules_str5 , 200,#bas7_white
	.long	0
	.long	TSEC*25

	LWL	#rules_str6 , 200,#bas7_white
	.long	0
	LWL	#rules_str7 , 200,#bas7_white
	.long	0
	LWL	#rules_str8 , 200,#bas7_white
	.long	0
	.long	TSEC*25

	LWL	#rules_str9 , 200,#bas7_white
	.long	0
	.long	TSEC*15

	LWL	#rules_str10, 116,#bas7_alt
	LWL	#rules_str10a,284,#bas7_white
	LWL	#rules_str10b,200,#bas7_white
	.long	0
	LWL	#rules_str11, 200,#bas7_white
	.long	0
	LWL	#rules_str12, 200,#bas7_white
	.long	0
	.long	TSEC*25

	LWL	#rules_str13, 200,#bas7_alt
	LWL	#rules_str14,  82,#bas7_alt
	LWL	#rules_str14a,243,#bas7_white
	LWL	#rules_str14b,200,#bas7_white
	.long	0
	LWL	#rules_str15, 200,#bas7_white
	.long	0
	LWL	#rules_str16,  80,#bas7_alt
	LWL	#rules_str16a,242,#bas7_white
	LWL	#rules_str16b,200,#bas7_white
	.long	0
	.long	TSEC*20

	LWL	#rules_str17,  93,#bas7_alt
	LWL	#rules_str17a,250,#bas7_white
	LWL	#rules_str17b,200,#bas7_white
	LWL	#rules_str18, 130,#bas7_alt
	LWL	#rules_str18a,251,#bas7_white
	LWL	#rules_str18b,200,#bas7_white
	LWL	#rules_str19, 170,#bas7_alt
	LWL	#rules_str19a,285,#bas7_white
	.long	0
	LWL	#rules_str20,  46,#bas7_alt
	LWL	#rules_str20a,217,#bas7_white
	LWL	#rules_str21,  58,#bas7_alt
	LWL	#rules_str21a,230,#bas7_white
	LWL	#rules_str21b,200,#bas7_white
	.long	0
	.long	TSEC*25

	LWL	#rules_str22,  76,#bas7_alt
	LWL	#rules_str22a,238,#bas7_white
	LWL	#rules_str22b,200,#bas7_white
	.long	0
	LWL	#rules_str23, 200,#bas7_white
	.long	0
	.long	TSEC*20

	LWL	#rules_str24, 200,#bas7_white
	.long	0
	LWL	#rules_str25,  91,#bas7_alt
	LWL	#rules_str25a,239,#bas7_white
	LWL	#rules_str25b,200,#bas7_white
	LWL	#rules_str25c,200,#bas7_alt
	LWL	#rules_str25d,200,#bas7_white
	.long	0
	.long	TSEC*20

	.long	0

#rules_mod
	.long	BKGDBMOD
	.word	0,0
	.long	0

#bas7_alt
	.word	3
	.word	0,0,(1fh*32+0ch)*32+1fh

#bas7_white
	.word	3
	.word	0,0,(1fh*32+1fh)*32+1fh

#heading_setup
	PRINT_STR	bast18_ascii,8,0,200,7,BSTGYO_P,0

#str_heading
	.string	"NBA HANGTIME SWEEPSTAKES",1
	.string	"OFFICIAL RULES",0
	.even

#nopurch_setup
	PRINT_STR	bast10_ascii,8,0,200,59,BAST_G_P,0

#str_nopurch
	.string	"NO PURCHASE NECESSARY",0
	.even

#rules_setup
	PRINT_STR	bast7t_ascii,5,0,200,76,#bas7_alt,0
	
#rules_str1
	.string	"Who May Enter: ",0
#rules_str1a
	.string	"The NBA HANGTIME SWEEPSTAKES is open to",1,0
#rules_str1b
	.string	"all legal residents of the United States, except residents",1
	.string	"of Arizona, New York, Vermont and Washington, employees",1
	.string	"of WMS Industries, the National Basketball Association,",1
	.string	"related parties and their immediate families. All federal,",1
	.string	"state and local laws apply. Void where prohibited.",1
	.string	"Contest sponsored by Midway Manufacturing Company,",1
	.string	"3401 N. California, Chicago, IL 60618.",1,1,0

#rules_str2
	.string "Deadline: ",0
#rules_str2a
	.string	"The NBA HANGTIME SWEEPSTAKES begins on April 10,",1,0
#rules_str2b
	.string	"1996. To be eligible, all entries must be received no later",1
	.string	"than 11:59 p.m. Eastern Standard Time on September 13, 1996.",1
	.string "Sponsor is not responsible for lost, stolen, late or",1
	.string	"misdirected mail, mechanical errors, typographical or",1
	.string	"printing errors, third party interference or electrical,",1
	.string "network, computer, hardware or software malfunctions.",0

#rules_str3
	.string "To Enter: ",0
#rules_str3a
	.string	"Participants may enter the NBA HANGTIME SWEEPSTAKES",1,0
#rules_str3b
	.string	"after answering NBA HANGTIME trivia questions worth 100",1
	.string	"points. A participant may reach 100 points in two ways:",1,1,0

#rules_str4
	.string "(1) GAME METHOD OF ENTRY: ",0
#rules_str4a
	.string	"Each player who purchases a",1,0
#rules_str4b
	.string "full, four-quarter length game of NBA HANGTIME will have",1
	.string	"the option of establishing a Personal Identification",1
	.string "Number (PIN).  After each full, four-quarter length game",1
	.string "of NBA HANGTIME, PLAYED ON ONE SPECIFIC MACHINE, IN ONE",1
	.string "PARTICULAR LOCATION, in which one or more participants",1
	.string	"have entered his or her PIN number, the NBA HANGTIME TRIVIA",1
	.string	"GAME will be activated for those participant(s).",1,1,0

#rules_str5
	.string "When activated, the player will see a trivia contest",1
	.string	"screen that explains the contest rules.",0

#rules_str6
	.string	"A second screen will then appear with a multiple choice",1
	.string	"trivia question. Beside each question will be a point value",1
	.string	"that can be earned for answering that question correctly.",1
	.string	"Each question has a constant point value, specific to that",1
	.string	"question. Each player will have 10 seconds to answer the",1
	.string	"question. If answered correctly, the point value of that",1
	.string	"question will be stored in the machine, cross-referenced",1,0

#rules_str7
	.string	"with the participant's PIN number. The point value of each",1
	.string	"subsequent, correctly answered question submitted under",1
	.string	"that PIN number will be added to the participant's point",1
	.string "total, and the machine will keep a running score of each",1
	.string	"player's total points, for each player with a PIN number",1
	.string	"assigned to that machine. PIN numbers may only be used on",1
	.string "one, specific machine. A participant's point total will not",1,0

#rules_str8
	.string	"include points earned in games played on other NBA HANGTIME",1
	.string	"machines played at other locations. ",0

#rules_str9
	.string "Once a player reaches a total of 100 points, they will be",1
	.string	"designated an 'NBA Trivia Champion.' A screen will then",1
	.string	"appear with a password. NBA Trivia Champions must then send",1
	.string	"their password, along with their name, age, address and",1
	.string	"phone number, printed or typed legibly, to NBA HANGTIME",1
	.string	"TRIVIA GAME Entries, P.O. Box 52990, Dept. 7526, Phoenix,",1
	.string	"Arizona 85072-2990 to be entered in the NBA HANGTIME",1
	.string "SWEEPSTAKES drawing.",0

#rules_str10
	.string "(2) WRITE-IN METHOD OF ENTRY: ",0
#rules_str10a
	.string	"Participants may send a self-",1,0
#rules_str10b
	.string	"addressed, stamped envelope to NBA HANGTIME TRIVIA GAME",1
	.string	"Winners List/Rules Requests, P.O. Box 52912, Dept. 7527,",1
	.string	"Phoenix, Arizona 85072-2912. They will then receive, by",1
	.string	"mail, a complete set of trivia questions identical to the",1
	.string	"trivia questions that appear in the NBA HANGTIME arcade",1
	.string	"game, with identical point values, and a complete set of",1,0

#rules_str11
	.string	"these Rules. After answering the questions provided to the",1
	.string	"best of the participant's ability, spending no more time",1
	.string	"than one minute answering each question, the answers must",1
	.string	"be sent to NBA HANGTIME TRIVIA GAME Entries, P.O. Box 52990,",1
	.string	"Dept. 7526, Phoenix, Arizona 85072-2990 for scoring, along",1
	.string	"with the participant's name, age, address and phone number,",1
	.string	"printed or typed legibly. Participants who correctly answer",1,0

#rules_str12
	.string	"enough of the questions provided to achieve a point total of",1
	.string	"at least 100 points will be designated 'NBA Trivia Champion'",1
	.string	"and will be entered in the NBA HANGTIME SWEEPSTAKES drawing.",0

#rules_str13
	.string "Prizes:",1,1,0

#rules_str14
	.string "Grand prize (1): ",0
#rules_str14a
	.string	"A trip for two to any one regular season",1,0
#rules_str14b
	.string	"NBA game during the 1996-97 NBA season. The winner may",1
	.string	"choose any regular season game. The prize package includes",1
	.string	"airfare for two to the city in which the game is played,",1
	.string	"two tickets to the game, two nights hotel accommodations",1
	.string	"for two, double occupancy, and $500.00 to cover meals and",1
	.string	"transportation to and from the airport. The winner will be",1,0

#rules_str15
	.string	"provided a schedule of games by October 15, 1996. They",1
	.string	"must then notify Midway Manufacturing of their choice by",1
	.string	"October 31, 1996. (Approximate Retail Value: $5,300.00)",1,1,0

#rules_str16
	.string "First Prize (1): ",0
#rules_str16a
	.string	"An NBA HANGTIME coin-operated arcade game",1,0
#rules_str16b
	.string	"(Approximate Retail Value: $5,000.00)",0

#rules_str17
	.string "Second Prize (25): ",0
#rules_str17a
	.string	"An Official NBA Champion Brand Jersey.",1,0
#rules_str17b
	.string	"Winners will receive either a Scottie Pippen, Anfernee",1
	.string	"Hardaway, Shawn Kemp, Magic Johnson, Grant Hill or Jason",1
	.string	"Kidd jersey. Winners will not be able to select which",1
	.string	"jersey they receive (Approximate Retail Value: $125.00 each)",1,1,0

#rules_str18
	.string "Third Prize (1,000): ",0
#rules_str18a
	.string	"An NBA HANGTIME T-shirt",1,0
#rules_str18b
	.string	"(Approximate Retail Value: $10.00)",1,1,0

#rules_str19
	.string "Total approximate prize value: ",0
#rules_str19a
	.string	"$23,425.00",1,1,0

#rules_str20
	.string "Odds: ",0
#rules_str20a
	.string	"Odds are dependent upon the number of entries received.",1,1,0

#rules_str21
	.string "Selection: ",0
#rules_str21a
	.string	"Winners will be randomly selected by Continental",1,0
#rules_str21b
	.string	"Promotion Group Inc., an independent judging and fulfillment",1
	.string	"agency, on or about September 18, 1996. All decisions of the",1
	.string "judges are final and binding in all respects.",1,1,0

#rules_str22
	.string "Notification: ",0
#rules_str22a
	.string	"Winners will be notified by overnight courier",1,0
#rules_str22b
	.string	"and/or telephone on or about September 22, 1996. ",1
	.string	1
	.string "Only one entry per participant. No entries by facsimile",1
	.string	"or electronic transmission. Winners will be required to",1
	.string	"complete affidavit of eligibility, waiver of liability and",1
	.string	"publicity release, which must be returned within 15 days of",1
	.string	"receipt or any prize award will be void. If winner is under",1,0

#rules_str23
	.string "the age of 18, winner must provide signed parental consent,",1
	.string	"in a form provided by the Sponsor, in order to receive prize.",1
	.string	"Limit one prize per household.",1
	.string	1
	.string	"All prizes will be awarded. No substitution or transfer of",1
	.string	"prizes. Taxes are the responsibility of winners.",0

#rules_str24
	.string	"By participating winners consent to use of their name,",1
	.string	"address and likeness for advertising, promotional and",1
	.string	"publicity purposes without additional compensation, except",1
	.string	"where prohibited by law. All entries become the property",1
	.string	"of sponsor and will not be returned.",1,1,0

#rules_str25
	.string "Winners List: ",0
#rules_str25a
	.string	"For a winners list, please send a self-",1,0
#rules_str25b
	.string	"addressed, stamped envelope by September 22, 1997 to:",1,1,0
#rules_str25c
	.string	"NBA HANGTIME TRIVIA GAME Winners List/Rules Requests",1,0
#rules_str25d
	.string	"P.O. Box 52912, Dept. 7527, Phoenix, Arizona 85072-2912",0
	.even






	.if	0

#****************************************************************
* Title screen

; SUBRP	show_title2
;
;	calla	display_blank
;	calla	WIPEOUT
;
;	clr	a0
;	move	a0,@dtype		;2D
;
;	movk	1,a0			;page flipping on
;	move	a0,@dpageflip
;
;	movi	SCRNEND,a0		;[256,405]
;	move	a0,@SCRNLR,L
;
;	clr	a0
;	move	a0,@WORLDTLX,L
;	move	a0,@WORLDTLY,L
;	move	a0,@IRQSKYE
;
;	SLEEPK	2
;
;	movi	#ttl_t,a0
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1
;
;	CREATE0	startcyc
;
;	clr	a10
;	movk	16,a11
;
;	CREATE0	fade_up
;
;	movk	1,a0
;	move	a0,@DISPLAYON
;
;	SLEEPK	2
;	calla	display_unblank
;
;	SLEEP	1*TSEC+30
;
;	movi	7*TSEC,a10
;#lp	SLEEPK	1
;	calla	get_all_buttons_cur2
;	jrz	#nob
;      	clr	a0
;	move	a0,@SOUNDSUP		;turn all sounds on
;	SOUND1	bounce_snd
;	movk	1,a0
;	move	a0,@SOUNDSUP		;turn all sounds off
;	jruc	#xb
;#nob	
;	dsj	a10,#lp
;#xb
;	movi	CYCPID,a0
;	calla	KIL1C
;
;	clr	a10
;	movk	8,a11
;	CREATE0	fade_down
;
;	SLEEP	40
;
;	RETP

;#ttl_t
;	.long	ttitleBMOD
;	.word	23,25
;	.long	0

;startcyc
;	SLEEPK	9
;	movi	STATIC_p,a8
;	movi	cycram,a9
;	movi	[1,8],a10		;1st,last color
;	movk	2,a11			;Rate
;	CREATE	CYCPID,COLCYC
;	DIE

	.endif


#*****************************************************************************

; SUBRP	drw_stars
;
;	calla	display_blank
;	calla	WIPEOUT
;
;	clr	a0
;	move	a0,@dtype		;2D
;
;	movk	1,a0			;page flipping on
;	move	a0,@dpageflip
;
;	movi	SCRNEND,a0		;[256,405]
;	move	a0,@SCRNLR,L
;
;	clr	a0
;	move	a0,@WORLDTLX,L
;	move	a0,@WORLDTLY,L
;	move	a0,@IRQSKYE
;
;	SLEEPK	2
;
;	movi	coinin_mod,a0
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1
;
;	clr	a10
;	movk	16,a11
;	CREATE0	fade_up
;
;	movk	1,a0
;	move	a0,@DISPLAYON
;
;	SLEEPK	2
;
;	calla	display_unblank
;
;	movk	1,a0
;	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON
;	ADJUST	ADJMUSIC		;GET MUSIC ON OFF FOR DEMO
;	MOVE	A0,A0
;	JRNZ	#NONO1
;	CLR	A0
;	MOVE	A0,@SOUNDSUP,W		;TURN ALL SOUNDS ON
;
;	movi	tuneend1_snd,a0
;	calla	snd_play1ovr
;
;#NONO1
;
;	.ref	starring
;	JSRP	starring
;
;;	movk	8,a11
;;	.ref	FADE_DOWN
;;	CREATE0	FADE_DOWN
;
;	SLEEP	30
;
;	clr	a10
;	movk	8,a11
;	CREATE0	fade_down
;
;	SLEEP	40
;	movi	musicoff_snd,a0
;	calla	snd_play1ovr
;
;	RETP


;coinin_mod
;	.long	viewfrtBMOD
;	.word	0,5
;	.long	0



#*****************************************************************************

; SUBRP	drw_ladder
;
;	calla	display_blank
;	calla	WIPEOUT
;	calla	pal_clean
;
;	clr	a0
;	move	a0,@dtype		;2D
;	move	a0,@HALT
;
;	movk	1,a0			;page flipping on
;	move	a0,@dpageflip
;
;	movi	SCRNEND,a0		;[256,405]
;	move	a0,@SCRNLR,L
;
;	clr	a0
;	move	a0,@WORLDTLX,L
;	movi	[13*360-8,0],a0
;	move	a0,@WORLDTLY,L
;
;	SLEEPK	2
;
;	movi	#ladder_mod,a0
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1
;
;	CREATE0	deloff
;
;	CREATE0	drw_teams
;
;	SLEEPK	2
;
;	clr	a10
;	movk	16,a11
;	CREATE0	fade_up
;
;	movk	1,a0
;	move	a0,@DISPLAYON
;	SLEEPK	2
;	calla	display_unblank
;
;
;	SLEEP	2*60
;
;	CREATE0	drwnbalogoUP
;
;	movi	>772-4,a10
;#lp	SLEEPK	1
;	move	@WORLDTLY,a0,L
;	subi	[2,8000h],a0
;	move	A0,@WORLDTLY,L
;	calla	BGND_UD1
;
;
;	calla	get_all_buttons_cur2
;	jrz	#nob
;      	clr	a0
;	move	a0,@SOUNDSUP		;turn all sounds on
;	SOUND1	bounce_snd
;	movk	1,a0
;	move	a0,@SOUNDSUP		;turn all sounds off
;	jruc	#xb
;#nob	dsj	a10,#lp
;
;	SLEEP	4*64
;
;#xb
;
;;delete foreground objects that are not within visible screen area
;;init object ram stack
;	clr	a1
;	movi	FADERAM,a2
;
;	movi	100,a0			;uhl to clear
;clrlup:
;	move	a1,*a2+,L
;	dsjs	a0,clrlup
;
;	movi	FADERAM,a9
;	move	@OBJLST,a8,L		;look through the fgndlist
;	jreq	ofail			;does not exist! indicate error
;chkfobj:
;	calla	SCRTST			;test for object on screen
;	jreq	onscrn			;object is definitely on screen!
;	move	a8,*a9+,L		;dump into ram stack
;onscrn:
;	move	*a8(OLINK),a8,L		;let's search for another
;	jrne	chkfobj
;	clr	a0
;	move	a0,*a9,L		;terminate table
;
;objpull:
;	movi	FADERAM,a9
;lupobj:
;	move	*a9+,a0,L
;	jrz	ofail			;no object list exits!
;	calla	DELOBJ			;delete object from list
;	jruc	lupobj
;
;ofail:
;
;	calla	pal_clean
;
;	clr	a10
;	movk	8,a11
;	CREATE0	fade_down
;
;	SLEEP	22h
;	RETP


;drwnbalogoUP
;
;	SLEEP	1*60
;#drw
;	movi	[60,0],a11
;;	movi	nbalogo,a9
;	movi	TSMLOGO,a9
;	CREATE0	logo_drift
;	movi	[334,0],a11
;	movi	TSMLOGO,a9
;	CREATE0	logo_drift
;	SLEEP	15*60
;	movi	[60,0],a11
;	movi	TSMLOGO,a9
;	CREATE0	logo_drift
;	movi	[334,0],a11
;	movi	TSMLOGO,a9
;	CREATE0	logo_drift
;	DIE
;
;logo_drift
;
;	move	a11,a0
;	movi	[248+48,0],a1
;	movi	>7591,a3				;Z
;	movi	DMAWNZ|M_NOCOLL,a4
;	move	a9,a2
;	movi	CLSDEAD,a5
;	clr	a6
;	movi	[-3,0],a7
;	calla	BEGINOBJ
;
;	SLEEP	25*60
;	jauc	DELOBJDIE



;drw_teams
;
;	.ref	ladder_imgs0,ladder_imgs1,ladder_imgs2,ladder_imgs3,ladder_imgs4
;	.ref	ladder_imgs5,ladder_imgs6
;
;	movi	ladder_imgs0,a9
;	callr	#drlp
;	SLEEP	90
;	movi	ladder_imgs1,a9
;	callr	#drlp
;	SLEEP	140h
;	callr	deloffbot
;	movi	ladder_imgs2,a9
;	callr	#drlp
;	SLEEP	110h
;	callr	deloffbot
;	movi	ladder_imgs3,a9
;	callr	#drlp
;	SLEEP	110h
;	callr	deloffbot
;	movi	ladder_imgs4,a9
;	callr	#drlp
;	SLEEP	110h
;	callr	deloffbot
;	movi	ladder_imgs5,a9
;	callr	#drlp
;	SLEEP	110h
;	callr	deloffbot
;	movi	ladder_imgs6,a9
;	callr	#drlp
;	DIE
	

;#drlp	move	*a9+,a2,L
;	jrz	#x
;
;	move	*a9+,a0,L
;	move	*a9+,a1,L
;	sll	16,a0
;	sll	16,a1
;	movi	20000,a3
;	movi	DMAWNZ|M_NOCOLL,a4
;	movi	CLSDEAD,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;	callr	#clippit
;
;
;	move	*a9+,a2,L
;	move	*a9+,a0,L
;	move	*a9+,a1,L
;	sll	16,a0
;	sll	16,a1
;	movi	20000,a3
;	movi	DMAWNZ|M_NOCOLL,a4
;	movi	CLSDEAD,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;	callr	#clippit
;
;	move	*a9+,a2,L
;	move	*a9+,a0,L
;	move	*a9+,a1,L
;	sll	16,a0
;	sll	16,a1
;	movi	20000,a3
;;	movi	DMAWNZ|M_FLIPH|M_NOCOLL,a4
;	movi	DMAWNZ|M_NOCOLL,a4
;	movi	CLSDEAD,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;	callr	#clippit
;
;	move	*a9+,a2,L
;	move	*a9+,a0,L
;	move	*a9+,a1,L
;	sll	16,a0
;	sll	16,a1
;	movi	20000,a3
;	movi	DMAWNZ|M_NOCOLL,a4
;	movi	CLSDEAD,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;	jruc	#drlp
;#x	rets


;	.asg	65,HEAD_WIDTH
;#clippit
;	move	*a8(OSIZEX),a0
;	subi	HEAD_WIDTH,a0
;	jrb	#no_clip
;	move	a0,*a8(OFSET)
;#no_clip
;	rets


;#ladder_mod
;	.long	dabullBMOD
;	.word	>ff4b+5,>ffa1+3
;	.long	ladderBMOD
;	.word	0+5,-92+360
;	.long	ladderBMOD
;	.word	0+5,-92+360*2
;	.long	ladderBMOD
;	.word	0+5,-92+360*3
;	.long	ladderBMOD
;	.word	0+5,-92+360*4
;	.long	ladderBMOD
;	.word	0+5,-92+360*5
;	.long	ladderBMOD
;	.word	0+5,-92+360*6
;	.long	ladderBMOD
;	.word	0+5,-92+360*7
;	.long	ladderBMOD
;	.word	0+5,-92+360*8
;	.long	ladderBMOD
;	.word	0+5,-92+360*9
;	.long	ladderBMOD
;	.word	0+5,-92+360*10
;	.long	ladderBMOD
;	.word	0+5,-92+360*11
;	.long	ladderBMOD
;	.word	0+5,-92+360*12
;	.long	ladderBMOD
;	.word	0+5,-92+360*13
;	.long	0



#****************************************************************

; SUBRP	drw_cutaway
;
;	calla	display_blank
;	calla	WIPEOUT
;	calla	pal_clean
;
;	clr	a0
;	move	a0,@dtype		;2D
;
;	movk	1,a0			;page flipping on
;	move	a0,@dpageflip
;
;	movi	SCRNEND,a0		;[256,405]
;	move	a0,@SCRNLR,L
;
;	clr	a0
;	move	a0,@WORLDTLX,L
;	move	a0,@WORLDTLY,L
;
;	SLEEPK	2
;
;	movi	#cut_mod,a0
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1
;
;	movk	1,a0
;	move	a0,@DISPLAYON
;
;	SLEEPK	2
;
;	calla	display_unblank
;
;;	CREATE0	drw_cards
;;	SLEEP	4*64
;;	clr	a0
;;	move	a0,@DISPLAYON
;
;	SLEEP	1*TSEC+30
;
;	movi	3*TSEC,a10
;#lp	SLEEPK	1
;	calla	get_all_buttons_cur2
;	jrz	#nob
;      	clr	a0
;	move	a0,@SOUNDSUP		;turn all sounds on
;	SOUND1	bounce_snd
;	movk	1,a0
;	move	a0,@SOUNDSUP		;turn all sounds off
;	jruc	#xb
;#nob	
;	dsj	a10,#lp
;#xb
;
;	clr	a10
;	movk	8,a11
;	CREATE0	fade_down
;
;	SLEEP	40
;
;	RETP


;#cut_mod
;	.long	viewfrtBMOD
;	.word	0,5
;	.long	0


	.end

