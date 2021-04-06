;-----------------------------------------------------------------------------
;
* Owner:	JOHNSON
*
; Software:	Jeff Johnson
; Initiated:	7-31-95
;
; COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
;
;.Last mod - 7/31/95 
;-----------------------------------------------------------------------------
	.file	"select3.asm"
	.title	"option screen...etc"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
;	.include	"gsp.equ"
	.include	"game.equ"
	.include	"macros.hdr"
	.include	"audit.equ"

	.include	"bgndtbl.glo"
	.include	"imgtbl.glo"
;	.include	"imgtbl2.glo"
	.include	"mugshot.glo"
	.include	"imgtblp.glo"
	.include	"imgtblm.glo"
;	.include	"imgtbl4.glo"

	.include	"plaques.tbl"


	.ref	create_plr_mugshots_tbl,create_plr_mugshots_tbl_end
	.ref	player_heads,player_names			;table addr.
	.ref	winner_stays_msg
	.ref	mess_objid,mess_line_spacing
	.ref	message_palette,message_ascii
	.ref	mess_space_width
	.ref	mess_cursx,mess_cursy
	.ref	cur_pos,create_plyr
	.ref	get_all_sticks_cur,get_all_buttons_down
	.ref	setup_message
	.ref	scrnrel_off,print_string_C2,print_string_C
	.ref	print_string,print_string2
	.ref	dec_to_asc,concat_string
	.ref	copy_string,RNDRNG0
	.ref	obj_on,obj_off
	.ref	PSTATUS,PSTATUS2
	.ref	create_title_bar
	.ref	pal_getf,GAMSTATE
	.ref	brush10_ascii,brush12_ascii,brush20_ascii
	.ref	city_table_start
	.ref	del_butn_box_stuff
	.ref	del_yes_no_buttons
	.ref	create_small_yes_no_butns
	.ref	joy_pos
	.ref	update_yes_no_button_pals
	.ref	get_stick_val_cur,get_stick_val_down
	.ref	flash_pressed_yes_no_button
	.ref	get_all_buttons_cur
	.ref	timeout
	.ref	KIL1C,delete_text
	.ref	IRQSKYE,TWOPLAYERS
	.ref	bast8t_ascii,bast8_ascii,bast10_ascii
	.ref	GET_ADJ,CRED_P
	.ref	special_heads
	.ref	our_names
	.ref	player1_data,player2_data,player3_data,player4_data
	.ref	team1,team2,tm1set,tm2set
	.ref	setup_message,mess_cursx,mess_cursy
	.ref	message_buffer
	.ref	get_name_string
	.ref	get_all_buttons_cur2
	.ref	get_but_val_cur
	.ref	get_but_val_down
	.ref	inmatchup

	.ref	pal_clean,KILBGND

	.ref	pup_court,pup_aba,pup_baby,pup_bighead
	.ref	pup_nomusic,pup_maxblock,pup_hypspeed
	.ref	pup_hugehead
	.ref	pup_maxpower,pup_tournament,pup_maxsteal
	.ref	pup_fastpass,pup_showhotspots,pup_notag
	.ref	pup_goaltend,pup_trbinfinite
	.ref	pup_trbstealth
	.ref	pup_nopush,pup_maxspeed,pup_showshotper
	.ref	pup_noassistance,pup_tournament,pup_maxpower
	.ref	pup_lockcombo

	.ref	print_plr_name,print_string_C3
	.ref	credits3,exit_status

	.ref	TM_NAMES_ON_SCRN,MIDDLE_TEAM_NAME
	.ref	plate1_objs,plate2_objs
	.ref	transition_flag
	.ref	teamset1_obj,teamset2_obj
	.ref	SHAKER2
	.ref	compute_team_def_off_rank
	.ref	get_teams_pop,copy_rom_string
	.ref	sorted_teams,teams_pop
	.ref	concat_rom_string,dec_to_pct
	.ref	print_string_R,print_string_R2
	.ref	HALT
	.ref	check_world_records
	.ref	get_plr_rank
	.ref	force_selection
	.ref	find_record
	.ref	BGND_UD1,BAKMODS
	.ref	plaque_fall1,plaque_fall2
	.ref	plaque_fall3,plaque_fall4
	.ref	plaque_land1,plaque_land2
	.ref	plaque_land3,plaque_land4
	.ref	opt_scr_cur,opt_scr_sel
	.ref	get_all_sticks_down
	.ref	reset_yes_no_butn_pals
	.ref	combo_but1,combo_but2,combo_but3,combo_but4
	.ref	yes_no_cur1,yes_no_sel1
 	.ref	qtr_purchased
	.ref	clear_buffers
	.ref	change_pal_on_text
	.ref	nickname_img_tbl
	.ref	compute_plyr_off_rank
	.ref	compute_plyr_def_rank

	.def	TUBE_O_P,TUBE_R_P,TUBE_Y_P,TUBE_G_P
	.def	PLTF5_B_P,PLTF5_G_P,PLTF5_Y_P,PLTF5_R_P
	.def	plaque_xs,plaque_flsh_pals
	.def	plaque_snds,plaque_lnds_snds


SPOTLITE_PARTS		equ	5
BBALL_PARTS		equ	1			;big bball parts
PBALL_PARTS		equ	1			;pressed bball parts
PBALL_SHDW_PARTS	equ	2
BBALL_SHDW_PARTS	equ	2


TURBO_NEEDED	equ	0
SHOOT_NEEDED	equ	16
PASS_NEEDED	equ	32
AWARD_ROUTINE	equ	48


	.bss	bball_1_obj_ptrs,BBALL_PARTS*32		;4 pieces for non hi-lited bball
	.bss	bball_2_obj_ptrs,BBALL_PARTS*32		;4 pieces for non hi-lited bball
	.bss	bball_3_obj_ptrs,BBALL_PARTS*32		;4 pieces for non hi-lited bball
	.bss	pball_obj_ptrs,PBALL_PARTS*32		;4 pieces for pressd bball
	.bss	bball_1_text_obj_ptr,32
	.bss	bball_2_text_obj_ptr,32
	.bss	bball_3_text_obj_ptr,32

	.bss	p1_butn_cnts,16
	.bss	p2_butn_cnts,16
	.bss	p3_butn_cnts,16
	.bss	p4_butn_cnts,16

	BSSX	rodman_colors,32

	.text


;-----------------------------------------------------------------------------
;	This process handles the dropping of best-player plaques on the team
; select page
;
;-----------------------------------------------------------------------------
 SUBR	best_player_plaques

	clr	a0
	move	a0,*a13(PDATA)			;counter of plaques (delay)

;	clr	a0				;count
	move	@player1_data+PR_NAME1,a14
	jrle	#np1				;br=plr - no inits
	move	@player1_data+PR_COUNT,a14
	jrle	#np1
	inc	a0
#np1	move	@player2_data+PR_NAME1,a14
	jrle	#np2				;br=plr - no inits
	move	@player2_data+PR_COUNT,a14
	jrle	#np2
	inc	a0
#np2	move	@player3_data+PR_NAME1,a14
	jrle	#np3				;br=plr - no inits
	move	@player3_data+PR_COUNT,a14
	jrle	#np3
	inc	a0
#np3	move	@player4_data+PR_NAME1,a14
	jrle	#np4				;br=plr - no inits
	move	@player4_data+PR_COUNT,a14
	jrle	#np4
	inc	a0
#np4	subk	1,a0				;br=more than 1 plyr ?
	jrle	#die				;br=no

;drop rank plaque
	clr	a0				;player nbr.
	move	@player1_data+PR_RANK,a14
	move	@player2_data+PR_RANK,a8
	move	@player3_data+PR_RANK,a9
	move	@player4_data+PR_RANK,a10
	cmp	a8,a14
	jrlo	#rnk1				;br=plr 1 is better
	move	a8,a14
	movk	1,a0
#rnk1	cmp	a9,a14
	jrlo	#rnk2
	move	a9,a14
	movk	2,a0
#rnk2	cmp	a10,a14
	jrlo	#rnk3
	movk	3,a0
#rnk3
	move	a0,*a13(PDATA+16)		;flag for plyr nbr
	movi	BST_RNKred,a9,L
	JSRP	anim_plyr_plaque

;drop win streak plaque

	clr	a0				;player nbr.
	move	@player1_data+PR_WINSTREAK,a14
	inc	a14				;in case negative
	move	@player2_data+PR_WINSTREAK,a8
	inc	a8
	move	@player3_data+PR_WINSTREAK,a9
	inc	a9
	move	@player4_data+PR_WINSTREAK,a10
	inc	a10
	cmp	a8,a14
	jrhi	#rnk4				;br=plr 1 is better
	move	a8,a14
	movk	1,a0
#rnk4	cmp	a9,a14
	jrhi	#rnk5
	move	a9,a14
	movk	2,a0
#rnk5	cmp	a10,a14
	jrhi	#rnk6
	movk	3,a0
#rnk6
	move	a0,*a13(PDATA+16)		;flag for plyr nbr
	movi	BST_STKred,a9,L
	JSRP	anim_plyr_plaque

;drop best offense plaque

	clr	a0				;player nbr.
	move	@player1_data+PR_PTS_SCORED,a14
	inc	a14				;in case negative
	move	@player2_data+PR_PTS_SCORED,a8
	inc	a8
	move	@player3_data+PR_PTS_SCORED,a9
	inc	a9
	move	@player4_data+PR_PTS_SCORED,a10
	inc	a10
	cmp	a8,a14
	jrhi	#rnk7				;br=plr 1 is better
	move	a8,a14
	movk	1,a0
#rnk7	cmp	a9,a14
	jrhi	#rnk8
	move	a9,a14
	movk	2,a0
#rnk8	cmp	a10,a14
	jrhi	#rnk9
	movk	3,a0
#rnk9
	move	a0,*a13(PDATA+16)		;flag for plyr nbr
	movi	BST_OFFred,a9,L
	JSRP	anim_plyr_plaque

;drop best defense plaque

	clr	a0				;player nbr.
	move	@player1_data+PR_PTS_ALLOWED,a14
	move	@player2_data+PR_PTS_ALLOWED,a8
	move	@player3_data+PR_PTS_ALLOWED,a9
	move	@player4_data+PR_PTS_ALLOWED,a10
	cmp	a8,a14
	jrlo	#rnka				;br=plr 1 is better
	move	a8,a14
	movk	1,a0
#rnka	cmp	a9,a14
	jrlo	#rnkb
	move	a9,a14
	movk	2,a0
#rnkb	cmp	a10,a14
	jrlo	#rnkc
	movk	3,a0
#rnkc
	move	a0,*a13(PDATA+16)		;flag for plyr nbr
	movi	BST_DEFred,a9,L
	JSRP	anim_plyr_plaque
#die	
	DIE


best_plq_pals
	.long	PLAT_B_P
	.long	PLAT_G_P
	.long	PLAT_Y_P
	.long	PLAT_R_P
	.long	PLAT_G_P	;kit
	.long	PLAT_B_P
	.long	PLAT_R_P
	.long	PLAT_Y_P


;-----------------------------------------------------------------------------
;	This PROCESS handles the showing of the players status thru plaques
;
; INPUT: reg a11 - ptr to plyr process
;-----------------------------------------------------------------------------
 SUBR	plyr_plaques

	move	*a11(PC_DATADDR),a0,L	;start of player data

	clr	a14
	move	a14,*a13(PDATA)		;counter of plaques
	not	a14
	move	a14,*a13(PDATA+16)		;flag for plyr nbr

;----------------------
;check 'created player'

	move	*a0(PR_CREATED_PLYR),a14
	jrle	#ccp2

	movi	custm_plr_imgs,a14
	move	*a11(PC_PLAYNUM),a10
	sll	5,a10
	add	a10,a14
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#ccp1
	addi	4*32,a14			;get KIT image ptr.
#ccp1
	move	*a14,a9,L			;get img. from table
	JSRP	anim_plyr_plaque

;-----------------
;check player rank

#ccp2
	move	*a0(PR_COUNT),a1
	jrz	#nornk

	movi	top1_imgs,a14
	move	*a0(PR_RANK),a1
	jrz	#nornk
	cmpi	1,a1
	jreq	#cpr0
	movi	top5_imgs,a14
	cmpi	5,a1
	jrls	#cpr0
	movi	top10_imgs,a14
	cmpi	10,a1
	jrgt	#nornk
#cpr0
	move	*a11(PC_PLAYNUM),a10
	sll	5,a10
	add	a10,a14

	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#cpr1
	addi	4*32,a14			;get KIT image ptr.
#cpr1
	move	*a14,a9,L			;get img. from table
	JSRP	anim_plyr_plaque

;-----------------------
;check player winstreaks

#nornk
	move	*a11(PC_DATADDR),a0,L
	move	*a0(PR_WINSTREAK),a1
	subk	5,a1
	jrlt	#nowin
	movi	grt_win_strk_imgs,a14
	move	*a11(PC_PLAYNUM),a10
	sll	5,a10
	add	a10,a14
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#cpw1
	addi	4*32,a14			;get KIT image ptr.
#cpw1
	move	*a14,a9,L			;get img. from table
	JSRP	anim_plyr_plaque
#nowin

;---------------------------
;check player teams defeated

	move	*a11(PC_DATADDR),a0,L
	move	*a0(PR_NUMDEF),a1
	cmpi	NUM_TEAMS,a1
	jrlo	#nochmp
	movi	nba_champ_imgs,a14
	move	*a11(PC_PLAYNUM),a10
	sll	5,a10
	add	a10,a14
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#cptd1
	addi	4*32,a14			;get KIT image ptr.
#cptd1
	move	*a14,a9,L			;get img. from table
	JSRP	anim_plyr_plaque
#nochmp

;---------------------
;check defensive rank

	move	*a11(PC_DATADDR),a6,L		;start of player data
	move	*a6(PR_COUNT),a14
	subk	5,a14
	jrlt	#nodef	
;	jrz	#nodef
	PUSH	a11
	calla	find_record			;ret a11 - rec. number
	move	a11,a4
	PULL	a11
	move	a10,a10
	jrz	#ccp2				;br=rec not found...not DEFENSE or OFFENSE check
	calla	get_plr_rank
	move	*a9,a8,L
	move	*a8(RS_DEF_RANK),a0
	jrz	#nodef
	calla	compute_plyr_def_rank

	movi	bst_def_imgs,a14
	cmpi	1,a0
	jrls	#cdr0
	movi	top5_def_imgs,a14
	cmpi	5,a0
	jrls	#cdr0
	movi	top10_def_imgs,a14
	cmpi	10,a0
	jrgt	#nodef

#cdr0	move	*a11(PC_PLAYNUM),a10
	sll	5,a10
	add	a10,a14
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#cdr1
	addi	4*32,a14			;get KIT image ptr.
#cdr1
	move	*a14,a9,L			;get img. from table
	JSRP	anim_plyr_plaque

;---------------------
;check offensive rank

#nodef
	move	*a11(PC_DATADDR),a0,L
	move	*a0(PR_COUNT),a1
	subk	5,a1
	jrle	#nooff
;	jrz	#nooff
	move	*a8(RS_OFF_RANK),a0
	jrz	#nooff
	calla	compute_plyr_off_rank

	movi	bst_off_imgs,a14
	cmpi	1,a0
	jrls	#cor0
	movi	top5_off_imgs,a14
	cmpi	5,a0
	jrls	#cor0
	movi	top10_off_imgs,a14
	cmpi	10,a0
	jrgt	#nooff

#cor0	move	*a11(PC_PLAYNUM),a10
	sll	5,a10
	add	a10,a14
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#cor1
	addi	4*32,a14			;get KIT image ptr.
#cor1
	move	*a14,a9,L			;get img. from table
	JSRP	anim_plyr_plaque

;-------------------
;check world records

#nooff	
	move	*a11(PC_DATADDR),a2,L		;start of player data
	calla	check_world_records		;ret. 14
	move	a14,a14
	jrz	#nowrld

	movi	wrldrec_imgs,a14
	move	*a11(PC_PLAYNUM),a10
	sll	5,a10
	add	a10,a14
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#cwr1
	addi	4*32,a14			;get KIT image ptr.
#cwr1
	move	*a14,a9,L			;get img. from table
	JSRP	anim_plyr_plaque

#nowrld
	DIE



	.asg	183,PLAQUE_Y

#*****************************************************************************
;a9 = ptr to image


 SUBRP	anim_plyr_plaque

	PUSHP	a8
#app0
	SLEEPK	1
	move	@HALT,a0
	jrnz	#app0

	move	*a13(PDATA),a14
	jrz	#app00

	SLEEPK	10
#app00
	move	*a13(PDATA),a14
	inc	a14
	move	a14,*a13(PDATA)		;counter of plaques

	move	*a13(PDATA+16),a0
	jrge	#app1				;br=player nbr passed in

	move	*a11(PC_PLAYNUM),a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#app1
	addk	4,a0				;add in offset for 2 PLYR KIT
#app1
	sll	4,a0				;x 16
	addi	plaque_xs,a0
	move	*a0,a0				;x val
	sll	16,a0
	movi	[PLAQUE_Y-(16*16),0],a1		;y val
	move	a9,a2

	move	*a13(PDATA),a3
	addi	20300,a3			;z (allow FULLGAME PLAQUE over it)

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	movi	[16,0],a7			;y vel

	move	*a13(PDATA+16),a14
	jrlt	#nrm				;br=player nbr passed in
	move	a14,b0
	sll	5,b0
	addi	best_plq_pals,b0,L
	move	@TWOPLAYERS,a14			;0 = NO, 1 = YES 2 players
	jrz	#n2p
	addi	4*32,b0				;get KIT image ptr.
#n2p	move	*b0,b0,L
	calla	BEGINOBJP2
	jruc	#nrm2
#nrm
	calla	BEGINOBJ2

#nrm2
	move	*a13(PDATA+16),a0
	jrge	#plx				;br=player nbr passed in
	move	*a11(PC_PLAYNUM),a0
#plx
	sll	5,a0
	addi	plaque_snds,a0
	move	*a0,a0,L
	calla	snd_play1
#waitf
	SLEEPK	1
	move	*a8(OYPOS),a0
	cmpi	PLAQUE_Y,a0
	jrlt	#waitf
	clr	a0
	move	a0,*a8(OYVEL),L

	move	*a13(PDATA+16),a0
	jrge	#plx2				;br=player nbr passed in
	move	*a11(PC_PLAYNUM),a0
#plx2
	sll	5,a0
	addi	plaque_lnds_snds,a0
	move	*a0,a0,L
	calla	snd_play1

	movk	22,a10
	calla	SHAKER2

	move	*a13(PDATA+16),a9
	jrge	#plx3				;br=player nbr passed in
	move	*a11(PC_PLAYNUM),a9
#plx3
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#app2
	addk	4,a9				;add in offset for 2 PLYR KIT
#app2	sll	5,a9
	addi	plaque_flsh_pals,a9
	move	*a9,a9,L			;get pal flash tbl ptr.
#flsh
	move	*a9+,a0,L				;at end of table ?
	jrnn	#flsh1				;br=yes
	calla	pal_getf
	move	a0,*a8(OPAL),L
	SLEEPK	3
	jruc	#flsh
#flsh1
	CREATE0	show_n_del_plate

	PULLP	a8
	RETP

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	show_n_del_plate

	SLEEP	32
	calla	DELOBJA8

 	DIE



;tmodex	.long	[20,0],[6ch,0],[0d7h,0],[12eh,0]

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	nosecrets_drw

	move	a8,a0
	sll	5,a0
	addi	nosecret_imgs,a0
	move	@TWOPLAYERS,a14			;0 = NO, 1 = YES 2 players
	jrz	nsec_0
	addi	4*32,a0			;get KIT image ptr.
nsec_0	move	*a0,a2,L

	move	a8,a0
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	nsec_1
	addk	4,a0				;add in offset for 2 PLYR KIT
nsec_1	sll	4,a0				;x 16
	addi	plaque_xs,a0
	move	*a0,a0				;x val
	sll	16,a0
	movi	[PLAQUE_Y,0],a1			;18
	movi	20450,a3
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

;	.ref	blink_plyr2
;
;	CREATE0	blink_plyr2
;	move	a0,a9
	SLEEP	90
;	move	a9,a0
;	calla	KILL
;	move	a8,a0
	calla	DELOBJA8
	DIE


nosecret_imgs
	.long	TurnNSblu
	.long	TurnNSgrn
	.long	TurnNSyel
	.long	TurnNSred
	.long	TurnNSgrn ;For kit
	.long	TurnNSblu
	.long	TurnNSred
	.long	TurnNSyel


#*****************************************************************************
;
; INPUT: reg a10 - X pos
;        reg a11 - player number
******************************************************************************
 SUBR	fullgame_purchased

	SLEEPK	1
	move	@HALT,a1
	jrnz	fullgame_purchased

	move	a10,a0				;x val
	movi	[PLAQUE_Y-(16*16),0],a1		;y val
	move	a9,a2				;* image
	movi	20500,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	movi	[16,0],a7			;y vel
	calla	BEGINOBJ2

	move	a11,a0
	sll	5,a0
	addi	plaque_snds,a0
	move	*a0,a0,L
	calla	snd_play1
;;	SOUND1	plaque_fall1
#waitf
	SLEEP	1
	move	*a8(OYPOS),a0
	cmpi	PLAQUE_Y,a0
	jrlt	#waitf
	movi	PLAQUE_Y,a0
	move	a0,*a8(OYPOS)
	clr	a0
	move	a0,*a8(OYVEL),L

	move	a11,a0
	sll	5,a0
	addi	plaque_lnds_snds,a0
	move	*a0,a0,L
	calla	snd_play1
;;	SOUND1	plaque_land1

	movk	22,a10
	calla	SHAKER2

	movk	3,a10
	move	@TWOPLAYERS,a1			;0 = NO, 1 = YES 2 players
	jrz	#fgp1
	addk	4,a11				;add in offset for 2 PLYR KIT
#fgp1	sll	5,a11
	addi	plaque_flsh_pals,a11
	move	*a11,a11,L			;get pal flash tbl ptr.
#fgp2
	move	*a11+,a0,L			;at end of table ?
	jrnn	#fgp3				;br=yes
	calla	pal_getf
	move	a0,*a8(OPAL),L
	SLEEPK	3
	jruc	#fgp2
#fgp3
	SLEEP	20
	calla	DELOBJA8
	DIE


plaque_snds
	.long	plaque_fall1,plaque_fall2,plaque_fall3,plaque_fall4

plaque_lnds_snds
	.long	plaque_land1,plaque_land2,plaque_land3,plaque_land4

plaque_xs
	.word	13,105,207,299			;4 plr 
	.word	0,59,254,0		;2 plr kit

plaque_flsh_pals
	.long	p1_flsh_pals
	.long	p2_flsh_pals
	.long	p3_flsh_pals
	.long	p4_flsh_pals
	.long	p2_flsh_pals	;2 plyr kit
	.long	p1_flsh_pals
	.long	p4_flsh_pals
	.long	p3_flsh_pals


p1_flsh_pals
	.long	PLTF5_B_P
	.long	PLAT_B_P
	.long	PLTF5_B_P
	.long	PLAT_B_P
	.long	PLTF4_B_P
	.long	PLTF3_B_P
	.long	PLTF2_B_P
	.long	PLTF1_B_P
	.long	PLAT_B_P
	.long	1

p2_flsh_pals
	.long	PLTF5_G_P
	.long	PLAT_G_P
	.long	PLTF5_G_P
	.long	PLAT_G_P
	.long	PLTF4_G_P
	.long	PLTF3_G_P
	.long	PLTF2_G_P
	.long	PLTF1_G_P
	.long	PLAT_G_P
	.long	1

p3_flsh_pals
	.long	PLTF5_Y_P
	.long	PLAT_Y_P
	.long	PLTF5_Y_P
	.long	PLAT_Y_P
	.long	PLTF4_Y_P
	.long	PLTF3_Y_P
	.long	PLTF2_Y_P
	.long	PLTF1_Y_P
	.long	PLAT_Y_P
	.long	1


p4_flsh_pals
	.long	PLTF5_R_P
	.long	PLAT_R_P
	.long	PLTF5_R_P
	.long	PLAT_R_P
	.long	PLTF4_R_P
	.long	PLTF3_R_P
	.long	PLTF2_R_P
	.long	PLTF1_R_P
	.long	PLAT_R_P
	.long	1


custm_plr_imgs
	.long	Customblu
	.long	Customgrn
	.long	Customyel
	.long	Customred
	.long	Customgrn ;For kit
	.long	Customblu
	.long	Customred
	.long	Customyel

wrldrec_imgs
	.long	WorldRblu
	.long	WorldRgrn
	.long	WorldRyel
	.long	WorldRred
	.long	WorldRgrn ;For kit
	.long	WorldRblu
	.long	WorldRred
	.long	WorldRyel

top10_imgs
	.long	TopTenblu
	.long	TopTengrn
	.long	TopTenyel
	.long	TopTenred
	.long	TopTengrn ;For kit
	.long	TopTenblu
	.long	TopTenred
	.long	TopTenyel


top5_imgs
	.long	TopFivblu
	.long	TopFivgrn
	.long	TopFivyel
	.long	TopFivred
	.long	TopFivgrn ;For kit
	.long	TopFivblu
	.long	TopFivred
	.long	TopFivyel


top1_imgs
	.long	onePlblu
	.long	onePlgrn
	.long	onePlyel
	.long	onePlred
	.long	onePlgrn ;For kit
	.long	onePlblu
	.long	onePlred
	.long	onePlyel


bst_def_imgs
	.long	BstDfPlblu
	.long	BstDfPlgrn
	.long	BstDfPlyel
	.long	BstDfPlred
	.long	BstDfPlgrn ;For kit
	.long	BstDfPlblu
	.long	BstDfPlred
	.long	BstDfPlyel

top5_def_imgs
	.long	Top5DPblu
	.long	Top5DPgrn
	.long	Top5DPyel
	.long	Top5DPred
	.long	Top5DPgrn ;For kit
	.long	Top5DPblu
	.long	Top5DPred
	.long	Top5DPyel

top10_def_imgs
	.long	Top10Dblu
	.long	Top10Dgrn
	.long	Top10Dyel
	.long	Top10Dred
	.long	Top10Dgrn ;For kit
	.long	Top10Dblu
	.long	Top10Dred
	.long	Top10Dyel

bst_off_imgs
	.long	BstOfPlblu
	.long	BstOfPlgrn
	.long	BstOfPlyel
	.long	BstOfPlred
	.long	BstOfPlgrn ;For kit
	.long	BstOfPlblu
	.long	BstOfPlred
	.long	BstOfPlyel

top5_off_imgs
	.long	Top5OPblu
	.long	Top5OPgrn
	.long	Top5OPyel
	.long	Top5OPred
	.long	Top5OPgrn ;For kit
	.long	Top5OPblu
	.long	Top5OPred
	.long	Top5OPyel

top10_off_imgs
	.long	Top10Oblu
	.long	Top10Ogrn
	.long	Top10Oyel
	.long	Top10Ored
	.long	Top10Ogrn ;For kit
	.long	Top10Oblu
	.long	Top10Ored
	.long	Top10Oyel

grt_win_strk_imgs
	.long	GrtWnSblu
	.long	GrtWnSgrn
	.long	GrtWnSyel
	.long	GrtWnSred
	.long	GrtWnSgrn ;For kit
	.long	GrtWnSblu
	.long	GrtWnSred
	.long	GrtWnSyel

nba_champ_imgs
	.long	NbaChpblu
	.long	NbaChpgrn
	.long	NbaChpyel
	.long	NbaChpred
	.long	NbaChpgrn ;For kit
	.long	NbaChpblu
	.long	NbaChpred
	.long	NbaChpyel



	.asg	157,VS_X
	.asg	-76,VS_Y


	.asg	224,COMBIN_Y		;vs. screen head Y position
	.asg	10,COMBIN_X1		;vs. screen head X position 1
	.asg	105,COMBIN_X2		;vs. screen head X position 2
	.asg	203,COMBIN_X3		;vs. screen head X position 3
	.asg	298,COMBIN_X4		;vs. screen head X position 4
	.asg	17,COMBIN_W		;vs. screen head width


;-----------------------------------------------------------------------------
;	This routine prints the headers for the team stat. info
;
; INPUT: reg. a1 - team number (0-1)
;	 reg. a5 - obj. id
;-----------------------------------------------------------------------------
 SUBR	create_team_stat_title
 	
	move	a0,a11
	move	a1,a10
	sll	5,a1
	addi	stat_xys,a1
	move	*a1,a9,L			;get coor. tbl addr.

	movi	1400,a3				;z pos (sorting)
	movi	DMAWNZ,a4			;DMA flags
	clr	a6				;x vel
	clr	a7				;y vel

	move	*a9+,a2,L			;get img
	move	*a9+,a1,L			;get img
	move	*a9+,a0,L			;get img
	movi	BAST_Y_P,b0
	calla	BEGINOBJP2
	move	*a9+,a2,L			;get img
	move	*a9+,a1,L			;get img
	move	*a9,a0,L			;get img
	movi	BAST_C_P,b0
	calla	BEGINOBJP2
	move	a11,a0
	move	a10,a1
 	rets

stat_xys
	.long	tm1_stxy
	.long	tm2_stxy

tm1_stxy
	.long	TEAMST,[31,0],[112,0]		;team 1
	.long	TEAMST4,[31,0],[104,0]		;team 1
tm2_stxy
	.long	TEAMST,[31,0],[216,0]		;team 2
	.long	TEAMST4,[31,0],[208,0]		;team 2


	.asg	193,TM1_STAT_X
	.asg	296,TM2_STAT_X
	.asg	44,WINS_Y
	.asg	56,OFF_RANK_Y
	.asg	68,DEF_RANK_Y
	.asg	80,POPULAR_Y


;-----------------------------------------------------------------------------
;	This routine just deletes all the objects that show team stats
;
;
; INPUT: reg a5 - obj id to delete
;-----------------------------------------------------------------------------
 SUBR	del_team_stats

 	PUSH	a0,a1
	move	a5,a0
	calla	obj_del1c
	PULL	a0,a1
	rets

;-----------------------------------------------------------------------------
;	This routine prints the NBA teams stats during TEAM SELECT
;
; INPUT: a0 - NBA team number (0-NUM_TEAMS)
;	 a1 - team number (0-1)
;-----------------------------------------------------------------------------
 SUBR	print_team_stats

	move	a0,a0
	jrn	pts_1				;br=invalid team number
	cmpi	NUM_TEAMS,a0
	jrhi	pts_1				;br=invalid team number

	PUSH	a0,a1				;save NBA team number

	movi	TM1_STAT_OBJS,a5 		;object ID
	move	a1,a1				;team 1 ?
	jreq	pts_00				;br=yep
	movi	TM2_STAT_OBJS,a5 		;object ID
pts_00 
	move	a5,@mess_objid
	callr	del_team_stats
	callr	create_team_stat_title

	calla	compute_team_def_off_rank	;ret. a6 - ptr. to TEAM STATS

	movi	TM1_STAT_X,a0
	move	a1,a1
	jreq	pts_0
	movi	TM2_STAT_X,a0
pts_0	move	a0,@mess_cursx			;message cursor pos X

	movi	bast8t_ascii,a0
	move	a0,@message_ascii,L		;* ascii lookup table
	movi	BAST_W_P,a0
	move	a0,@message_palette,L
	movi	WINS_Y,a0
	move	a0,@mess_cursy			;message cursor pos Y

	move	a6,a11				;save TEAM stat ram ptr

	calla	get_teams_pop

;print wins
	calla	clear_buffers

;	movi	message_buffer,a3		;* string dest
;	clr	a0
;	move	a0,*a3,L
;	move	a0,*a3(16),L

	PULL	a0
	move	a0,a14				;get NBA team nbr (0-NUM_TEAMS)
	PUSH	a0

	sll	5,a14
	addi	teams_pop,a14,L
	move	*a14,a0,L			;get team 'picked count' audit
	move	a0,a2
	move	*a11(TR_WINS),a1
	sub	a1,a0 				;a0=games lost
	jrle	pts_0a

	movi	100,a14				;2 digits of signifigence
	mpys	a14,a1				;games won * 100
	divs	a2,a1				;/ total games
	move	a1,a0
;	calla	dec_to_pct
	calla	dec_to_asc
	calla	concat_string
;	calla	print_string_C
	movi	str_prcnt,a4
	calla	concat_rom_string
	calla	print_string_R
	jruc	pts_0b

pts_0a	movi	str_100,a4
;	calla	print_string_C2		;centered
	calla	print_string_R2

;print offensive rank
pts_0b	movi	message_buffer,a3		;* string dest
	clr	a0
	move	a0,*a3,L
	movi	OFF_RANK_Y,a0
	move	a0,@mess_cursy			;message cursor pos Y
	move	*a11(TR_OFF_RANK),a0
	movi	NUM_TEAMS+1,a1			;max value
	calla	dec_to_asc
	calla	concat_string
;	calla	print_string_C
	calla	print_string_R

;print defensive rank
	movi	message_buffer,a3		;* string dest
	clr	a0
	move	a0,*a3,L
	movi	DEF_RANK_Y,a0
	move	a0,@mess_cursy			;message cursor pos Y
	move	*a11(TR_DEF_RANK),a0
	movi	NUM_TEAMS+1,a1			;max value
	calla	dec_to_asc
	calla	concat_string
	calla	print_string_R
;	calla	print_string_C

;print teams popularity

	PULL	a0,a1
	PUSH	a1
	move	a0,a2
	callr	print_ranking
	PULL	a1

;a1=0 or 1 for team
;If Rodman is on this team, change his hair color...

	move	a1,a1
	jrnz	#tm2

	movi	rodman_colors,a1

	move	@head1_obj,a14,L
	move	*a14(OIMG),a0,L
	.ref	ROD_CHI
	cmpi	ROD_CHI,a0
	jrz	#yes

	move	@head2_obj,a14,L
	move	*a14(OIMG),a0,L
	cmpi	ROD_CHI,a0
	jrz	#yes
	jruc	pts_1

#tm2	

	movi	rodman_colors+16,a1

	move	@head3_obj,a14,L
	move	*a14(OIMG),a0,L
	cmpi	ROD_CHI,a0
	jrz	#yes

	.ref	head1_obj
	.ref	head2_obj
	.ref	head3_obj
	.ref	head4_obj

	move	@head4_obj,a14,L
	move	*a14(OIMG),a0,L
	cmpi	ROD_CHI,a0
	jrnz	pts_1

#yes
	move	*a1,a0
	inc	a0
	move	a0,*a1
	cmpi	8,a0
	jrnz	#restuff
	clr	a0
	move	a0,*a1
#restuff
	sll	5,a0
	addi	#rod_tbl,a0
	move	*a0,a0,L
	move	a14,a2
	calla	pal_getf
	move	a0,*a2(OPAL)

pts_1	rets


 SUBR	check_rodman
;Mugshot

	cmpi	ROD_CHI,a2
	jrnz	#ex

	movi	rodman_colors,a1

	move	a14,a14
	jrz	#tm1

	movi	rodman_colors+16,a1
#tm1
	move	*a1,a0
	sll	5,a0
	addi	#rod_tbl,a0
	move	*a0,a0,L

#ex	rets

#rod_tbl
	.ref	CHI_RODBP
	.ref	CHI_RODOP
	.ref	CHI_RODPP
	.ref	CHI_RODRP
	.ref	CHI_RODWP
	.ref	CHI_RODYP
	.ref	CHI_RODKP
	.ref	CHI_RODGP

	.long	CHI_RODGP
	.long	CHI_RODBP
	.long	CHI_RODOP
	.long	CHI_RODPP
	.long	CHI_RODRP
	.long	CHI_RODWP
	.long	CHI_RODYP
	.long	CHI_RODKP

#*
 SUBR	check_rodman2
;Small head

	.ref	RODMAN1
	cmpi	RODMAN1+240h,a2
	jrnz	#ex

	movi	rodman_colors,a1

	move	a14,a14
	jrz	#tm1

	movi	rodman_colors+16,a1
#tm1
	move	*a1,a0
	sll	5,a0
	addi	#rod_tbl,a0
	move	*a0,a0,L

#ex	rets

#rod_tbl
	.ref	RODMANBP
	.ref	RODMANKP
	.ref	RODMANOP
	.ref	RODMANPP
	.ref	RODMANRP
	.ref	RODMANWP
	.ref	RODMANYP
	.ref	RODMANGP

	.long	RODMANGP
	.long	RODMANBP
	.long	RODMANOP
	.long	RODMANPP
	.long	RODMANRP
	.long	RODMANWP
	.long	RODMANYP
	.long	RODMANKP

str_prcnt	.string	"%",0
		.even	

str_100		.string	"100%",0
		.even	
	
;-----------------------------------------------------------------------------
;	       This routine prints the NBA TEAMS popularity
;
;INPUT: reg a2 - NBA team number
;-----------------------------------------------------------------------------
 SUBR	print_ranking

	clr	a10			;current rank
	clr	a8			;count
	movi	sorted_teams,a4
	movi	teams_pop,a5
	move	*a5,a9,L		;current count
#keep_looking
	move	*a5+,a0,L
	cmp	a0,a9
	jreq	#no_change
	move	a0,a9			;new count
	move	a8,a10			;new rank
#no_change
	inc	a8
	cmpi	NUM_TEAMS,a8			;safety
	jrhs	#last
	move	*a4+,a3
	cmp	a3,a2
	jrne	#keep_looking
#last
	movi	POPULAR_Y,a0
	move	a0,@mess_cursy		;message cursor pos Y

	sll	5,a10			;x 32 bits
	addi	#txt_table,a10
	move	*a10,a4,L
	calla	copy_rom_string		;"2nd, 3rd etc"
;	calla	print_string_C
	calla	print_string_R
	rets


	.even
#txt_table
	.long	#S1,#S2,#S3,#S4
	.long	#S5,#S6,#S7,#S8
	.long	#S9,#S10,#S11,#S12
	.long	#S13,#S14,#S15,#S16
	.long	#S17,#S18,#S19,#S20
	.long	#S21,#S22,#S23,#S24
	.long	#S25,#S26,#S27,#S28,#S29

	.even
#S1	.string	"1",0
#S2	.string	"2",0
#S3	.string	"3",0
#S4	.string	"4",0
#S5	.string	"5",0
#S6	.string	"6",0
#S7	.string	"7",0
#S8	.string	"8",0
#S9	.string	"9",0
#S10	.string	"10",0
#S11	.string	"11",0
#S12	.string	"12",0
#S13	.string	"13",0
#S14	.string	"14",0
#S15	.string	"15",0
#S16	.string	"16",0
#S17	.string	"17",0
#S18	.string	"18",0
#S19	.string	"19",0
#S20	.string	"20",0
#S21	.string	"21",0
#S22	.string	"22",0
#S23	.string	"23",0
#S24	.string	"24",0
#S25	.string	"25",0
#S26	.string	"26",0
#S27	.string	"27",0
#S28	.string	"28",0
#S29	.string	"29",0
	.even









;-----------------------------------------------------------------------------
;	This routine creates the objects underneath the scores
; on the stats page
;
; INPUT: reg a0 - xy table offset
;-----------------------------------------------------------------------------
 SUBR	create_score_backdrop

	sll	5,a0
	addi	scr_bkdrp_ptrs,a0,L
	move	*a0,a0,L

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	move	*a0+,a14,W				;flip image ?
	jrz	csb_1				;br=nope
	movi	M_FLIPH|DMAWNZ|M_SCRNREL,a4		;DMA flags
csb_1
	move	*a0+,a1,L			;Y pos
	move	*a0,a0,L			;X pos
	movi	SCORE,a2,L
	movi	1400,a3				;z pos (sorting)
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
 	rets


scr_bkdrp_ptrs
	.long	bkdrp1_xys
	.long	bkdrp2_xys

bkdrp1_xys
	.word	0					;flip img flag
	.long	[9,0],[12,0]	;stats screen left

bkdrp2_xys
	.word	1
	.long	[9,0],[388,0]	;stats screen right


;-----------------------------------------------------------------------------
;	This PROCESS creates the BACKDROP for the squad number
; during team select and animates the backdrop
;
; INPUT: a10 = table offset to use for coordinates
;-----------------------------------------------------------------------------
 SUBR	anim_squad_bball
	
	sll	5,a10
	addi	squad_ball_xys,a10
	move	*a10+,a1			;Y coor.
	sll	16,a1
	move	*a10,a0				;X coor.
	sll	16,a0
	movi	16000,a3			;z pos
	movi	SQDBAL01,a2,L
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2

;now animate bball
asb_0
	movi	ball_anim_tbl,a10,L
asb_1
	move	*a10+,a0,L			;new image
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	calla	obj_aniq
	SLEEPK	4
	cmpi	ball_anim_tbl_end,a10
	jrlo	asb_1
	jruc	asb_0
	DIE


squad_ball_xys
	.word	TM1_Y+4,TM1_X-88
	.word	TM2_Y+4,TM2_X-95


ball_anim_tbl
	.long	SQDBAL01
	.long	SQDBAL02
	.long	SQDBAL03
	.long	SQDBAL04
	.long	SQDBAL05
	.long	SQDBAL06
	.long	SQDBAL07
	.long	SQDBAL08
	.long	SQDBAL09
	.long	SQDBAL10
	.long	SQDBAL11
	.long	SQDBAL12
	.long	SQDBAL13
	.long	SQDBAL14
	.long	SQDBAL15
	.long	SQDBAL16
	.long	SQDBAL17
	.long	SQDBAL18
	.long	SQDBAL19
	.long	SQDBAL20
	.long	SQDBAL21
	.long	SQDBAL22
	.long	SQDBAL23
	.long	SQDBAL24
	.long	SQDBAL25
	.long	SQDBAL26
	.long	SQDBAL27
	.long	SQDBAL28
	.long	SQDBAL29
	.long	SQDBAL30
ball_anim_tbl_end

;-----------------------------------------------------------------------------
;	This routine creates the NUMBERS representing the squad
; number during team select
;
; INPUT: a0 = team number (table offset for coordinates)
;RETURN: a8 = ptr. to squad nbr. obj. ram
;-----------------------------------------------------------------------------
 SUBR	create_team_squad_nbr

	PUSH	a10,a11
	move	a0,a10
	CREATE0	anim_squad_bball
	move	a10,a0
	sll	5,a0				;x 32 bits
	addi	squad_xys,a0
	move	*a0+,a1
	sll	16,a1				;y pos
	move	*a0,a0				;x val
	sll	16,a0

	move	a10,a10
	jrnz	crsn_1a				;br=team 1
	move	@team1,a2
	jrnn	crsn_1
	clr	a2
crsn_1	sll	4,a2				;offset into TEAM LINEUP array
	addi	tm1set,a2			;point to team
	move	*a2,a2				;get current squad nbr
	jruc	crsn_2a
crsn_1a
	move	@team2,a2
	jrnn	crsn_2
	clr	a2
crsn_2	sll	4,a2				;offset into TEAM LINEUP array
	addi	tm2set,a2			;point to team
	move	*a2,a2				;get current squad nbr
crsn_2a
;	movi	SQUD_01,a2			;* image
	sll	5,a2
	addi	squd_nbr_imgs,a2
	move	*a2,a2,L


	movi	19000,a3			;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	PULL	a10,a11
	rets

squad_xys
	.word	TM1_Y+44,TM1_X+3
	.word	TM2_Y+44,TM2_X-4


;-----------------------------------------------------------------------------
;	This routine updates the teams squad number to reflect the current
; squad being shown
;
; INPUT: reg  a8 - ptr. to teams squad nbr. obj
;	 reg a14 - squad number
;-----------------------------------------------------------------------------
 SUBR	update_team_squad_nbr

	sll	5,a14
	addi	squd_nbr_imgs,a14
	move	*a14,a0,L			;NEW image addr
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	calla	obj_aniq			;change object image
	rets


squd_nbr_imgs
	.long	SQUD_01,SQUD_02,SQUD_03,SQUD_04,SQUD_05
	.long	SQUD_06,SQUD_07,SQUD_08,SQUD_09,SQUD_10
	.long	SQUD_11,SQUD_12,SQUD_13,SQUD_14,SQUD_15
	.long	SQUD_16,SQUD_17,SQUD_18,SQUD_19,SQUD_20,SQUD_20


;-----------------------------------------------------------------------------
;	This PROCESS flashes the plate behind the players heads
; on the team select screen 
;
; INPUT:  a10 - team number (0-1)
;	  a11 - ptr. to plyr. head backdrop obj
;-----------------------------------------------------------------------------
 SUBR	flash_backdrop

	sll	6,a10
	addi	flsh_bkdrop_tbl,a10,L
	move	*a10+,a9,L			;get start tbl addr.
	move	*a10,a10,L			;get end tbl addr.
	move	a11,a8

fbk_1	move	*a9+,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL),L		;Set palette & constant
	SLEEPK	3
	cmp	a10,a9
	jrlo	fbk_1
	DIE


flsh_bkdrop_tbl
	.long	bflsh_bkdrop_tbl,bflsh_bkdrop_tbl_end
	.long	rflsh_bkdrop_tbl,rflsh_bkdrop_tbl_end

bflsh_bkdrop_tbl
	.long	SQDFB7_P
	.long	SQAD_VB_P
	.long	SQDFB7_P
	.long	SQAD_VB_P
	.long	SQDFB7_P
	.long	SQDFB6_P
	.long	SQDFB5_P
	.long	SQDFB4_P
	.long	SQDFB3_P
	.long	SQDFB2_P
	.long	SQDFB1_P
	.long	SQAD_VB_P
bflsh_bkdrop_tbl_end


rflsh_bkdrop_tbl
	.long	SQDFR7_P
	.long	SQAD_VR_P
	.long	SQDFR7_P
	.long	SQAD_VR_P
	.long	SQDFR7_P
	.long	SQDFR6_P
	.long	SQDFR5_P
	.long	SQDFR4_P
	.long	SQDFR3_P
	.long	SQDFR2_P
	.long	SQDFR1_P
	.long	SQAD_VR_P
rflsh_bkdrop_tbl_end

;POWER-UP logic
;-----------------------------------------------------------------------------
; This PROCESS (for each player in game) lets the players input
;    a button combination for secrets
;
; INPUT: reg a10 - player number
;-----------------------------------------------------------------------------
 SUBR	plyr_get_combination

;wait for player to join-in
pgc_0
	SLEEPK	2
	move	@inmatchup,a0
	jrz	pgc_5				;not in MATCH_UP screen, exit
	move	@PSTATUS,a0
	btst	a10,a0
	jrz	pgc_0				;br=plyr hasn't joined in 

;clear ram
	clr	a14
	move	a10,a0
	sll	5,a0
	addi	butn_cnt_ram_ptr_tbl,a0,L
	move	*a0,a0,L			;get pointer to ram
	move	a14,*a0				;clear plyr button cnt ram

	callr	create_combo_symbol_backdrops	;Want to keep this A8!
;MJT Start
	move	a10,a0
	sll	5,a0
	BSSX	lock_ram,32*4
	addi	lock_ram,a0
	move	a8,*a0,L
;MJT End


	callr	create_combination_symbols
	
pgc_1
	SLEEPK	1
	move	@pup_lockcombo,a0
	btst	a10,a0
	jrnz	pgc_flash

	move	a10,a0
	calla	get_but_val_down
	move	a0,a3
	jrz	pgc_1

	move	a10,a0
	sll	5,a0
	addi	combo_sounds,a0
	move	*a0,a0,L
	calla	snd_play1

	clr	a2
	move	a10,a0
	calla	get_stick_val_cur
	btst	0,a0				;is joystick UP ?
	jrz	pgc_1a				;br=no
	movi	-1,a2				;flag - dec. not inc. value
pgc_1a
	btst	0,a3				;shoot button pressed ?
	jrz	pgc_2				;br=nope
	callr	update_shoot_butn_cnt
pgc_2
	btst	1,a3				;pass button pressed ?
	jrz	pgc_3				;br=nope
	callr	update_pass_butn_cnt
pgc_3
	btst	2,a3				;turbo button pressed ?
	jrz	pgc_4				;br=nope
	callr	update_turbo_butn_cnt

pgc_4	callr	del_combination_symbols
	callr	create_combination_symbols

	move	@inmatchup,a0
	jrnz	pgc_1
pgc_5
	DIE

pgc_flash
	movi	0101h,a2
	move	a2,*a8(OCONST)

	movk	4,a11
#again
	setf	4,0,0
	movk	M_CONNON,a0		;Replace non-zero data with constant
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0
	movk	3,a9
#tg0
	move	@inmatchup,a0
	jrz	#tg1
	SLEEPK	1
	dsj	a9,#tg0
#tg1
	setf	4,0,0
	movk	M_WRNONZ,a0
	move	a0,*a8(OCTRL)		;Write 4 low bits
	setf	16,1,0

	movk	3,a9
#tg2
	move	@inmatchup,a0
	jrz	pgc_5
	SLEEPK	1
	dsj	a9,#tg2

	dsj	a11,#again
	jruc	pgc_5


combo_sounds
	.long	combo_but1,combo_but2
	.long	combo_but3,combo_but4


	.asg	0000000000001111b,PASS_CNT_MASK
	.asg	0000000011110000b,SHOOT_CNT_MASK
	.asg	0000111100000000b,TURBO_CNT_MASK


;-----------------------------------------------------------------------------
;	This routine updates the players TURBO button hit count
;
; INPUT: reg. a2 (if negative, decrement value)
;-----------------------------------------------------------------------------
 SUBR	update_turbo_butn_cnt

	move	a10,a0
	sll	5,a0
	addi	butn_cnt_ram_ptr_tbl,a0,L
	move	*a0,a0,L			;get pointer to ram
	move	*a0,a1				;get plyr button cnt ram value
	move	a1,a14
	andni	TURBO_CNT_MASK,a14		;clear turbo button count
	andi	TURBO_CNT_MASK,a1
	srl	8,a1				;put into 1st nibble

	move	a2,a2				;dec. value ?
	jrn	utbc_1				;br=negative, YEP
	inc	a1
	cmpi	NBR_SYMBOLS,a1
	jrlo	utbc_2				;br=haven't cycled all heads
	clr	a1
	jruc	utbc_2
utbc_1
	dec	a1
	jrge	utbc_2				;br=value >= 0
	movi	NBR_SYMBOLS-1,a1		;set to bottom of table
utbc_2
	sll	8,a1
	or	a14,a1
	move	a1,*a0			;save PASS button count value
	rets

;-----------------------------------------------------------------------------
;	This routine updates the players SHOOT button hit count
;
; INPUT: reg. a2 (if negative, decrement value)
;-----------------------------------------------------------------------------
 SUBR	update_shoot_butn_cnt

	move	a10,a0
	sll	5,a0
	addi	butn_cnt_ram_ptr_tbl,a0,L
	move	*a0,a0,L			;get pointer to ram
	move	*a0,a1				;get plyr button cnt ram value
	move	a1,a14
	andni	SHOOT_CNT_MASK,a14		;clear turbo button count
	andi	SHOOT_CNT_MASK,a1
	srl	4,a1				;put into 1st nibble

	move	a2,a2				;dec. value ?
	jrn	usbc_1				;br=negative, YEP
	inc	a1
	cmpi	NBR_SYMBOLS,a1
	jrlo	usbc_2				;br=haven't cycled all heads
	clr	a1
	jruc	usbc_2
usbc_1
	dec	a1
	jrge	usbc_2				;br=value >= 0
	movi	NBR_SYMBOLS-1,a1		;set to bottom of table
usbc_2
	sll	4,a1
	or	a14,a1
	move	a1,*a0				;save SHOOT button count value
	rets

;-----------------------------------------------------------------------------
;	This routine updates the players PASS button hit count
;
; INPUT: reg. a2 (if negative, decrement value)
;-----------------------------------------------------------------------------
 SUBR	update_pass_butn_cnt

	move	a10,a0
	sll	5,a0
	addi	butn_cnt_ram_ptr_tbl,a0,L
	move	*a0,a0,L			;get pointer to ram
	move	*a0,a1				;get plyr button cnt ram value
	move	a1,a14
	andni	PASS_CNT_MASK,a14		;clear turbo button count
	andi	PASS_CNT_MASK,a1

	move	a2,a2				;dec. value ?
	jrn	upbc_1				;br=negative, YEP
	inc	a1
	cmpi	NBR_SYMBOLS,a1
	jrlo	upbc_2				;br=haven't cycled all heads
	clr	a1
	jruc	upbc_2
upbc_1
	dec	a1
	jrge	upbc_2				;br=value >= 0
	movi	NBR_SYMBOLS-1,a1		;set to bottom of table
upbc_2
	or	a14,a1
	move	a1,*a0				;save TURBO button count value
	rets


;
; Pointers to the players button count ram
;
butn_cnt_ram_ptr_tbl
	.long	p1_butn_cnts
	.long	p2_butn_cnts
	.long	p3_butn_cnts
	.long	p4_butn_cnts


combo_obj_id_tbl
	.word	COMBO_SYMBOLS_P1
	.word	COMBO_SYMBOLS_P2
	.word	COMBO_SYMBOLS_P3
	.word	COMBO_SYMBOLS_P4
	
;-----------------------------------------------------------------------------
; INPUT: a10 = player number
;-----------------------------------------------------------------------------
 SUBR	del_combination_symbols

	move	a10,a0
	sll	4,a0
	addi	combo_obj_id_tbl,a0
	move	*a0,a0				;get obj class to delete
	calla	obj_del1c
 	rets


;-----------------------------------------------------------------------------
;	This routine creates the backdrop behind the number SYMBOLS
; on the verus screen
;
; INPUT: a10 - player number
;-----------------------------------------------------------------------------
 SUBR	create_combo_symbol_backdrops

	PUSH	a10
	move	a10,a0
	sll	4,a0
	addi	combo_plate_xs,a0,L

	movi	100,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5
	clr	a6
	clr	a7

	movi	CODE,a2,L
	move	*a0,a0			;get X coor.
	sll	16,a0
	movi	[COMBIN_Y,0],a1			;get Y coor.
	movi	CODE_V_P,b0
	calla	BEGINOBJP2
	PULL	a10
 	rets


combo_plate_xs
	.word	COMBIN_X1
	.word	COMBIN_X2
	.word	COMBIN_X3
	.word	COMBIN_X4
combo_plate_xs_end



;-----------------------------------------------------------------------------
;	This routine creates the number SYMBOLS on the verus screen
;
; INPUT: a10 - player number
;-----------------------------------------------------------------------------
 SUBR	create_combination_symbols

	PUSH	a8,a10
	move	a10,a0
	move	a10,a9
	sll	4,a0
	addi	combo_obj_id_tbl,a0
	move	*a0,a5				;get obj class to delete

	sll	6,a10
	addi	combo_symbol_xys,a10

	movi	1000,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags

	clr	a6
	clr	a7

;1st symbol (turbo button changes this symbol)

	sll	5,a9				;*32
	addi	butn_cnt_ram_ptr_tbl,a9,L
	move	*a9,a9,L			;get ptr to PLYR butn cnt ram
	move	*a9,a9,L			;get ram value
	move	a9,a0
	andi	TURBO_CNT_MASK,a0
	srl	3,a0
	addi	combo_symbols_tbl,a0,L
	move	*a0,a2,L			;get img ptr.
	move	*a10+,a0			;get X coor.
	sll	16,a0
	movi	[COMBIN_Y+3,0],a1		;get Y coor.
	calla	BEGINOBJ2

;2nd symbol (shoot button changed this symbol)
	move	a9,a0
	andi	SHOOT_CNT_MASK,a0
	sll	1,a0
	addi	combo_symbols_tbl,a0,L
	move	*a0,a2,L
	move	*a10+,a0			;get X coor.
	sll	16,a0
	movi	[COMBIN_Y+3,0],a1		;get Y coor.
	calla	BEGINOBJ2

;3rd symbol (pass button changed this symbol)
	move	a9,a0
	andi	PASS_CNT_MASK,a0
	sll	5,a0
	addi	combo_symbols_tbl,a0,L
	move	*a0,a2,L
	move	*a10,a0				;get X coor.
	sll	16,a0
	movi	[COMBIN_Y+3,0],a1		;get Y coor.
	calla	BEGINOBJ2
	PULL	a8,a10
 	rets


combo_symbols_tbl
	.long	BRSH20_0
	.long	BRSH20_1
	.long	BRSH20_2
	.long	BRSH20_3
	.long	BRSH20_4
	.long	BRSH20_5
	.long	BRSH20_6
	.long	BRSH20_7
	.long	BRSH20_8
	.long	BRSH20_9
combo_symbols_tbl_end


NBR_SYMBOLS	equ	(combo_symbols_tbl_end-combo_symbols_tbl)/32


combo_symbol_xys
	.word	COMBIN_X1+8,COMBIN_X1+37,COMBIN_X1+66,0		;player 1
	.word	COMBIN_X2+8,COMBIN_X2+37,COMBIN_X2+66,0		;player 2
	.word	COMBIN_X3+8,COMBIN_X3+37,COMBIN_X3+66,0		;player 3
	.word	COMBIN_X4+8,COMBIN_X4+37,COMBIN_X4+66,0		;player 4




;POWER-UP stuff
	.asg	>00000001,TOURN	;tournament mode
	.asg	>00000002,BABYS	;baby mode
	.asg	>00000004,NOMUS	;no music mode
	.asg	>00000008,GOALT	;goal tending
	.asg	>00000010,MXBLK	;block power
	.asg	>00000020,MXSTL	;steal power; quick hands
	.asg	>00000040,MXPWR	;max power
	.asg	>00000080,MXSPD	;max speed
	.asg	>00000100,HYPER	;hyper speed
	.asg	>00000200,TBSTL	;stealth turbo
	.asg	>00000400,TBINF	;unlimited turbo
	.asg	>00000800,NOPSH	;no pushing
	.asg	>00001000,FPASS	;fast passing


;	.asg	>00000000,BIGHD	;big heads
;	.asg	>00000000,HUGHD	;huge heads
;	.asg	>00000000,NOTAG	;no tag arrows
;	.asg	>00000000,SHTPR	;show shot percent
;	.asg	>00000000,ABALL	;ABA ball in use
;	.asg	>00000000,COURT	;outside court
;	.asg	>00000000,NOASS	;no cpu assistance
;	.asg	>00000000,HOTSP	;show hot spots
;
;	.asg	>00000000,STRNG	;strong men


combination_tbl
	WL  >111,TOURN
	WL  >025,BABYS
	WL  >048,NOMUS
	WL  >937,GOALT
	WL  >616,MXBLK
	WL  >709,MXSTL
	WL  >802,MXPWR
	WL  >284,MXSPD
	WL  >552,HYPER
	WL  >273,TBSTL
	WL  >461,TBINF
	WL  >390,NOPSH
	WL  >120,FPASS

;Joystick/butn powerups:

;	WL  >001,BIGHD
;	WL  >011,HUGHD
;	WL  >040,NOTAG
;	WL  >100,SHTPR
;	WL  >999,COURT
;	WL  >030,HOTSP
;	WL  >222,NOASS

;	WL  >121,GOALT|STLPW
;	WL  >191,HUGHD|BABYS
;	WL  >666,NOTAG|GOALT|NOPSH

combination_tbl_end

NBR_CODE_COMBOS	equ	(combination_tbl_end-combination_tbl)/(16+32)


;-----------------------------------------------------------------------------
;	This routine checks all the players buttons counts to see if
; a powerup exists for there count.
;-----------------------------------------------------------------------------
 SUBR	set_plyrs_powerup_ram
 	
	movk	1,a0			;player 1 (bit 0)
	move	@p1_butn_cnts,a1
	callr	set_plyr_powerup_ram
	movk	2,a0			;player 2 (bit 1)
	move	@p2_butn_cnts,a1
	callr	set_plyr_powerup_ram
	movk	4,a0			;player 3 (bit 2)
	move	@p3_butn_cnts,a1
	callr	set_plyr_powerup_ram
	movk	8,a0			;player 4 (bit 3)
	move	@p4_butn_cnts,a1
	callr	set_plyr_powerup_ram

	movi	pup_baby,a0		;!!!

	move	@PSTATUS,a1		;Is it a plyr-v-plyr game?
	movi	>eee0,a14
	btst	a1,a14			;Do team agreement test if so
	jrnz	sppr0			; br=yes
	movi	>fffe,a14		;Share any powerups that are set
sppr0
	move	*a0,a1
	clr	a2
	btst	a1,a14
	jrz	sppr1
	movk	>f,a2
sppr1
	move	a2,*a0+
	cmpi	pup_fastpass,a0		;!!!
	jrle	sppr0

	rets


	.asg	0,TBL_COMBO
	.asg	16,POWERUPS

;-----------------------------------------------------------------------------
;	This routine sets the BITS in all the powerup ram based
; on code entered and player number (if combination found in table!!!)
;
;  INPUT: reg a0 - plyr bit number (mask)
;         reg a1 - plyr butn press count
;
;RETURNS: carry set if didn't find combination in table
;-----------------------------------------------------------------------------
 SUBR	set_plyr_powerup_ram

	move	@PSTATUS,a14
	and	a0,a14				;is this player in game ?
	jrz	cvc_x				;br=nope
;
;search table for a matching combination
;
	movi	combination_tbl,a2,L
	movi	NBR_CODE_COMBOS,a3
#lp
	move	*a2(TBL_COMBO),a14		;get count from table
	cmp	a14,a1				;plyrs and tbl count the same?
	jreq	cvc_00				;br=yes !!!
	addi	16+32,a2		;next line in combination table
	dsj	a3,#lp
	jruc	cvc_x				;br=no match found

;found match
cvc_00
	move	*a2(POWERUPS),a14,L
	srl	1,a14
	jrnc	cvc_01				;br=not this power up
	move	@PSTATUS,a2
	movi	>116,a3
	btst	a2,a3				;No tmode if only 1 plyr
	jrz	dotmd
	PUSH	a0,a14
	.ref	no_sp
	SOUND1	no_sp
	PULL	a0,a14
	jruc	cvc_01				;br=not this power up
dotmd
	move	@pup_tournament,a3
	or	a0,a3
	move	a3,@pup_tournament
cvc_01
	srl	1,a14
	jrnc	cvc_02
	move	@pup_baby,a3
	or	a0,a3
	move	a3,@pup_baby
cvc_02
	srl	1,a14
	jrnc	cvc_03
	move	@pup_nomusic,a3
	or	a0,a3
	move	a3,@pup_nomusic
cvc_03
	srl	1,a14
	jrnc	cvc_04
	move	@pup_goaltend,a3
	or	a0,a3
	move	a3,@pup_goaltend
cvc_04
	srl	1,a14
	jrnc	cvc_05
	move	@pup_maxblock,a3
	or	a0,a3
	move	a3,@pup_maxblock
cvc_05
	srl	1,a14
	jrnc	cvc_06
	move	@pup_maxsteal,a3
	or	a0,a3
	move	a3,@pup_maxsteal
cvc_06
	srl	1,a14
	jrnc	cvc_07
	move	@pup_maxpower,a3
	or	a0,a3
	move	a3,@pup_maxpower
cvc_07
	srl	1,a14
	jrnc	cvc_08
	move	@pup_maxspeed,a3
	or	a0,a3
	move	a3,@pup_maxspeed
cvc_08
	srl	1,a14
	jrnc	cvc_09
	move	@pup_hypspeed,a3
	or	a0,a3
	move	a3,@pup_hypspeed
cvc_09
	srl	1,a14
	jrnc	cvc_10
	move	@pup_trbstealth,a3
	or	a0,a3
	move	a3,@pup_trbstealth
cvc_10
	srl	1,a14
	jrnc	cvc_11
	move	@pup_trbinfinite,a3
	or	a0,a3
	move	a3,@pup_trbinfinite
cvc_11
	srl	1,a14
	jrnc	cvc_12
	move	@pup_nopush,a3
	or	a0,a3
	move	a3,@pup_nopush
cvc_12
	srl	1,a14
	jrnc	cvc_13
	move	@pup_fastpass,a3
	or	a0,a3
	move	a3,@pup_fastpass
cvc_13
cvc_x
	rets


;-----------------------------------------------------------------------------
;		 This routine deletes the CREATED players name
;-----------------------------------------------------------------------------
 SUBR	delete_name

	movi	SM_PLYRS_NAME,a0
	clr	a1
	calla	obj_del1c
	rets

;-----------------------------------------------------------------------------
;	 This routine prints the CREATED players name at the X,Y from table
;
; INPUT: reg. a0 - X coor (center)
;        reg. a1 - Y coor
;-----------------------------------------------------------------------------
 SUBR	print_name

	move	a0,@mess_cursx		;message cursor pos X
	move	a1,@mess_cursy		;message cursor pos Y

	addi	PR_NAME1,a4			;* src NAME
	movi	message_buffer,a3		;* string dest
	calla	get_name_string

	movi	bast8_ascii,a0
	move	a0,@message_ascii,L	;* ascii lookup table
	movi	BAST_W_P,a0
	move	a0,@message_palette,L
	movk	9,a0			;6,a0
	move	a0,@mess_space_width	;space char width
	movi	SM_PLYRS_NAME,a0
	move	a0,@mess_objid
	calla	print_string_C
 	rets


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------

	.asg	97,STBOX_W		;width of stat box
	.asg	8,STBOX_X1
	.asg	STBOX_X1+STBOX_W+1,STBOX_X2
	.asg	STBOX_X2+STBOX_W+1,STBOX_X3
	.asg	STBOX_X3+STBOX_W+1,STBOX_X4
	.asg	34,STBOX_Y
	.asg	34,STBOX_Y1
	.asg	34,STBOX_Y2
	.asg	34,STBOX_Y3
	.asg	34,STBOX_Y4


;-----------------------------------------------------------------------------
; This routine just kills the PROCESS which animates FIRE around the players
; stat box on the STAT pages
;-----------------------------------------------------------------------------
 SUBR	kill_fire_anim

	movi	FIRE_ANIM_PID,a0
	calla	KIL1C
 	rets

	.asg	0,FIRE_X 	;table offsets
	.asg	32,FIRE_X2
	.asg	64,FIRE_Y

;-----------------------------------------------------------------------------
;	This PROCESS animated FIRE for the best player at halftime and game
; over
;
;  INPUT: a11 - player number
;-----------------------------------------------------------------------------
 SUBR	anim_fire_for_best_plyr

	sll	7,a11
	addi	fire_anim_xys,a11,L

afbp_1	movi	fire_anim_tbl,a9,L

;left side of fire
afbp_2	movi	2000,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5		   		;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	move	*a9+,a2,L
	move	*a11(FIRE_X),a0,L		;get X coor.
	move	*a11(FIRE_Y),a1,L		;get Y coor.
	calla	BEGINOBJ2
	move	a8,a10

;right side of fire
	movi	M_FLIPH|DMAWNZ|M_SCRNREL,a4	;DMA flags
	move	*a9+,a2,L
	move	*a11(FIRE_X2),a0,L		;get X coor.
	move	*a11(FIRE_Y),a1,L		;get Y coor.
	calla	BEGINOBJ2
	SLEEPK	5

;delete fire frames
	calla	DELOBJA8
	move	a10,a8
	calla	DELOBJA8

	cmpi	fire_anim_tbl_end,a9,L
	jrlo	afbp_2
	jruc	afbp_1
	DIE


fire_anim_xys
	.long	[STBOX_X1+6,0],[STBOX_X1+92,0],[STBOX_Y+206,0],0    ;plyr 1
	.long	[STBOX_X2-1,0],[STBOX_X2+86,0],[STBOX_Y+206,0],0    ;plyr 2
	.long	[STBOX_X3+4,0],[STBOX_X3+91,0],[STBOX_Y+206,0],0    ;plyr 3
	.long	[STBOX_X4-2,0],[STBOX_X4+84,0],[STBOX_Y+206,0],0    ;plyr 4

fire_anim_tbl
	.long	HTFIRE01,HTFIRE04
	.long	HTFIRE02,HTFIRE05
	.long	HTFIRE03,HTFIRE06
	.long	HTFIRE04,HTFIRE07
	.long	HTFIRE05,HTFIRE08
	.long	HTFIRE06,HTFIRE09
	.long	HTFIRE07,HTFIRE10
	.long	HTFIRE08,HTFIRE01
	.long	HTFIRE09,HTFIRE02
	.long	HTFIRE10,HTFIRE03
fire_anim_tbl_end
	

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_name_backplates

	movk	2,a9
	callr	create_name_backplate
	movk	3,a9
	callr	create_name_backplate
	movk	4,a9
	callr	create_name_backplate
	movk	5,a9
	callr	create_name_backplate
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_name_backplates

	movi	TEAM_SEL_OBJS,a0
	calla	obj_del1c
 	rets

;-----------------------------------------------------------------------------
; Create the Hi-Lighter bar
;
; INPUT: reg b0 - which bar to put up (table offset)
;-----------------------------------------------------------------------------
 SUBR	create_name_backplate
	
	sll	5,a9
	addi	backplt_xys,a9		;x val
	move	*a9,a9,L
cnb_0
	move	*a9+,a2,L		;get image
	move	*a9+,a1,L		;palette
	move	a1,b0
	move	*a9+,a1,L		;x val
	move	*a9+,a0,L		;x val
;	movi	TEAMBR,a2
	movi	50,a3			;z pos (sorting) over city names
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
;	movi	M_FLIPH|DMAWNZ|M_SCRNREL,a4	;DMA flags
	movi	TEAM_SEL_OBJS,a5	   	;object ID
	clr	a6			;x vel
	clr	a7			;y vel
	calla	BEGINOBJP2

	move	*a9+,a0,L		;move to plot ?
	jrnz	cnb_0			;yep
	rets


backplt_xys
	.long	bar1table
	.long	bar2table
	.long	bar3table
	.long	bar4table
	.long	bar5table
	.long	bar6table
	.long	bar1kit
	.long	bar2kit

bar1table
  .long	TEXTBAR,TUBE_LB_P,[TM1_Y-56,0],[TM1_X-87,0],0	;team select, plyr 1
bar2table
  .long	TEXTBAR,TUBE_LR_P,[TM2_Y-56,0],[TM2_X+5,0],0	;team select, plyr 2

bar3table
  .long	TEXTBAR,TUBE_LB_P,[STBOX_Y1+69,0],[STBOX_X1+5,0],1	;stat pg. plr 1
  .long	TEXTBAR,TUBE_LB_P,[STBOX_Y1+69,0],[STBOX_X1+11,0],1	;stat pg. plr 1
  .long	TEXTBAR,TUBE_LB_P,[STBOX_Y1+195,0],[STBOX_X1+5,0],1	;stat pg. plr 1
  .long	TEXTBAR,TUBE_LB_P,[STBOX_Y1+195,0],[STBOX_X1+11,0],0	;stat pg. plr 1

bar4table
  .long	TEXTBAR,TUBE_LB_P,[STBOX_Y2+69,0],[STBOX_X2-1,0],1	;stat pg. plr 2
  .long	TEXTBAR,TUBE_LB_P,[STBOX_Y2+69,0],[STBOX_X2+5,0],1	;stat pg. plr 2
  .long	TEXTBAR,TUBE_LB_P,[STBOX_Y2+195,0],[STBOX_X2-1,0],1	;stat pg. plr 2
  .long	TEXTBAR,TUBE_LB_P,[STBOX_Y2+195,0],[STBOX_X2+5,0],0	;stat pg. plr 2

bar5table
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y3+69,0],[STBOX_X3+4,0],1	;stat pg. plr 3
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y3+69,0],[STBOX_X3+9,0],1	;stat pg. plr 3
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y3+195,0],[STBOX_X3+4,0],1	;stat pg. plr 3
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y3+195,0],[STBOX_X3+10,0],0	;stat pg. plr 3

bar6table
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+69,0],[STBOX_X4-2,0],1	;stat pg. plr 4
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+69,0],[STBOX_X4+3,0],1	;stat pg. plr 4
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+195,0],[STBOX_X4-2,0],1	;stat pg. plr 4
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+195,0],[STBOX_X4+3,0],0	;stat pg. plr 4

bar1kit
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+69,0],[STBOX_X4+5,0],1	;stat pg. plr 1 (kit)
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+69,0],[STBOX_X4+10,0],1	;stat pg. plr 1
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+196,0],[STBOX_X4+5,0],1	;stat pg. plr 1 (kit)
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+196,0],[STBOX_X4+10,0],0	;stat pg. plr 1

bar2kit
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+69,0],[STBOX_X4+5,0],1	;stat pg. plr 2 (kit)
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+69,0],[STBOX_X4+10,0],1	;stat pg. plr 2
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+196,0],[STBOX_X4+5,0],1	;stat pg. plr 2 (kit)
  .long	TEXTBAR,TUBE_LR_P,[STBOX_Y4+196,0],[STBOX_X4+10,0],0	;stat pg. plr 2



TUBE_LR_P:
   .word   127
   .word   0294ah,07ed5h,07e72h,079eeh,075eeh,07dabh,075cdh,079ach
   .word   07d69h,0798bh,0758bh,0718bh,0756ah,07949h,07948h,07548h
   .word   07928h,07927h,07106h,078c5h,06d07h,070e6h,06907h,06ce6h
   .word   06cc5h,07482h,060e6h,05ce6h,060c5h,07062h,06c82h,07061h
   .word   06883h,05cc5h,06882h,07041h,06c61h,06483h,06862h,06482h
   .word   06861h,06c41h,054c5h,06462h,06082h,06461h,06841h,054a5h
   .word   06062h,054a4h,06061h,06441h,05c62h,06041h,05c61h,05862h
   .word   04ca4h,05c41h,05861h,05462h,05841h,05461h,04c83h,05062h
   .word   05441h,05061h,04484h,05041h,04c42h,04c41h,05021h,04861h
   .word   04083h,04842h,04462h,04841h,04c21h,03c83h,04442h,04441h
   .word   05821h,05042h,05421h,05041h,04c42h,05021h,04c41h,04842h
   .word   04c21h,04841h,04063h,04442h,04821h,04441h,04042h,04421h
   .word   03863h,04021h,03c41h,03462h,03c21h,03841h,03822h,03423h
   .word   03442h,03821h,03441h,03023h,03042h,03041h,03421h,02c42h
   .word   02c41h,03021h,02823h,02842h,02c21h,02442h,02821h,02441h
   .word   02422h,02042h,02421h,02021h,01c21h,01821h,01421h



;#*****************************************************************************
;*  Create player heads on the STATs PAGE
;******************************************************************************
;;;;;	.asg	65,HEAD_WIDTH
;	.asg	95,HEAD_WIDTH
;
; SUBR	create_heads
;
;	movi	player_heads,a10
;	move	@team1,a2
;#lp	cmpi	0,a2
;	jrz	#out
;	addi	NEXT_TEAM,a10			;compute offset into HEAD tbl
;;;	addi	20*64,a10
;	dec	a2
;	jruc	#lp	
;#out
;	move	@team1,a0
;	sll	4,a0
;	addi	tm1set,a0
;	move	*a0,a14
;	sll	6,a14
;	add	a14,a10
;	move	*a10,a2,L			;image addr
;;
;; Head 1 (team 1)
;;
;	movi	player1_data,a14
;	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
;	jrle	#ncr1				;br=nope
;	move	*a14(PR_HEAD_NBR),a2		;get head number
;	sll	5,a2
;	addi	create_plr_mugshots_tbl,a2
;	move	*a2,a2,L			;get mugshot img
;	jruc	#no_spec1
;#ncr1
;	move	@special_heads,a0
;	jrn	#no_spec1
;	sll	5,a0				;x 32 bits
;	addi	our_heads,a0
;	move	*a0,a2,L
;#no_spec1
;	movi	[STBOX_X1+15,0],a0		;x val
;	movi	[STBOX_Y1+69,0],a1		;y val
;	movi	120,a3				;z pos
;	movi	DMAWNZ,a4			;DMA flags
;	clr	a5				;object ID
;	clr	a6				;x vel
;	clr	a7				;y vel
;	calla	BEGINOBJ2
;;
;; Head 2 (team 1)
;;
;	move	*a10(20h),a2,L			;image addr
;
;	movi	player2_data,a14
;	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
;	jrle	#ncr2				;br=nope
;	move	*a14(PR_HEAD_NBR),a2		;get head number
;	sll	5,a2
;	addi	create_plr_mugshots_tbl,a2
;	move	*a2,a2,L			;get mugshot img
;	jruc	#no_spec2
;#ncr2
;	move	@special_heads+10h,a0
;	jrn	#no_spec2
;	sll	5,a0				;x 32 bits
;	addi	our_heads,a0
;	move	*a0,a2,L
;#no_spec2
;	movi	[STBOX_X2+15,0],a0		;x val
;	movi	[STBOX_Y2+69,0],a1		;y val
;	movi	120,a3				;z pos
;	movi	DMAWNZ,a4			;DMA flags
;	clr	a5				;object ID
;	clr	a6				;x vel
;	clr	a7				;y vel
;	calla	BEGINOBJ2
;
;;team 2
;	movi	player_heads,a10
;	move	@team2,a2
;#lp1	cmpi	0,a2
;	jrz	#out1
;	addi	NEXT_TEAM,a10			;compute offset into HEAD tbl
;	dec	a2
;	jruc	#lp1
;#out1
;	move	@team2,a0
;	sll	4,a0
;	addi	tm2set,a0
;	move	*a0,a14
;	sll	6,a14
;	add	a14,a10
;;
;; Head 1 (team 2)
;;
;	move	*a10,a2,L			;image addr
;
;	movi	player3_data,a14
;	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
;	jrle	#ncr3				;br=nope
;	move	*a14(PR_HEAD_NBR),a2		;get head number
;	sll	5,a2
;	addi	create_plr_mugshots_tbl,a2
;	move	*a2,a2,L			;get mugshot img
;	jruc	#no_spec3
;#ncr3
;	move	@special_heads+20h,a0
;	jrn	#no_spec3
;	sll	5,a0				;x 32 bits
;	addi	our_heads,a0
;	move	*a0,a2,L
;#no_spec3
;
;	movi	[STBOX_X3+15,0],a0		;x val
;	movi	[STBOX_Y3+69,0],a1		;y val
;	movi	120,a3				;z pos
;	movi	DMAWNZ,a4			;DMA flags
;	clr	a5				;object ID
;	clr	a6				;x vel
;	clr	a7				;y vel
;	calla	BEGINOBJ2
;;
;; Head 2 (team 2)
;;
;	move	*a10(20h),a2,L			;image addr
;
;	movi	player4_data,a14
;	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
;	jrle	#ncr4				;br=nope
;	move	*a14(PR_HEAD_NBR),a2		;get head number
;	sll	5,a2
;	addi	create_plr_mugshots_tbl,a2
;	move	*a2,a2,L			;get mugshot img
;	jruc	#no_spec4
;#ncr4
;	move	@special_heads+30h,a0
;	jrn	#no_spec4
;	sll	5,a0				;x 32 bits
;	addi	our_heads,a0
;	move	*a0,a2,L
;#no_spec4
;
;	movi	[STBOX_X4+15,0],a0		;x val
;	movi	[STBOX_Y4+69,0],a1		;y val
;	movi	120,a3				;z pos
;	movi	DMAWNZ,a4			;DMA flags
;	clr	a5				;object ID
;	clr	a6				;x vel
;	clr	a7				;y vel
;	calla	BEGINOBJ2
;#cnt4a
;	rets


#*****************************************************************************
* Create stats title images (on the STAT page)
******************************************************************************
 SUBR	create_stat_titles
	
	movi	stat_title_tbl,a10,L
	movi	16000,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	clr	a5					;object ID
	clr	a6					;x vel
	clr	a7					;y vel
cst_1
	move	*a10+,a0,L				;X coor.
	move	*a10+,a1,L				;Y coor.
	movi	HLFSTATS,a2,L
	calla	BEGINOBJ2
	cmpi	stat_title_tbl_end,a10
	jrlo	cst_1
 	rets


stat_title_tbl
	.long	[STBOX_X2-21,0],[STBOX_Y2+85,0]
	.long	[STBOX_X4-23,0],[STBOX_Y4+85,0]
stat_title_tbl_end


#*****************************************************************************
* Show players name (on the STAT page)
******************************************************************************
 SUBR	create_plyrs_name

	movi	#initials_setup,a2
	calla	setup_message

	movi	STBOX_Y1+196,a0
	move	a0,@mess_cursy
	movi	STBOX_X1+48,a0
	move	a0,@mess_cursx
	move	@PSTATUS,a0
	btst	0,a0
	jrnz	#ok1
	movi	#str_cpu,a4
	calla	print_string_C2
	jruc	#skip1
#ok1
	movi	message_buffer,a3
	movi	player1_data+PR_NAME1,a4
	move	@player1_data+PR_CREATED_PLYR,a14
	jrle	#nm1					;br=not created
	movi	STBOX_Y1+71,a0
	move	a0,@mess_cursy
	movi	STBOX_Y1+196,a0
	move	@player1_data+PR_NICKNAME_NBR,a2
	callr	create_plr_nickname
#nm1
	calla	get_name_string
	calla	print_string_C

#skip1
	movi	STBOX_Y2+196,a0
	move	a0,@mess_cursy
	movi	STBOX_X2+41,a0
	move	a0,@mess_cursx
	move	@PSTATUS,a0
	btst	1,a0
	jrnz	#ok2
	movi	#str_cpu,a4
	calla	print_string_C2
	jruc	#skip2
#ok2
	movi	message_buffer,a3
	movi	player2_data+PR_NAME1,a4
	move	@player2_data+PR_CREATED_PLYR,a14
	jrle	#nm2
	movi	STBOX_Y2+71,a0
	move	a0,@mess_cursy
	movi	STBOX_Y2+196,a0
	move	@player2_data+PR_NICKNAME_NBR,a2
	callr	create_plr_nickname
#nm2
	calla	get_name_string
	calla	print_string_C

#skip2
	movi	STBOX_Y3+196,a0
	move	a0,@mess_cursy
	movi	STBOX_X3+47,a0
	move	a0,@mess_cursx
	move	@PSTATUS,a0
	btst	2,a0
	jrnz	#ok3
	movi	#str_cpu,a4
	calla	print_string_C2
	jruc	#skip3
#ok3
	movi	message_buffer,a3
	movi	player3_data+PR_NAME1,a4
	move	@player3_data+PR_CREATED_PLYR,a14
	jrle	#nm3
	movi	STBOX_Y3+71,a0
	move	a0,@mess_cursy
	movi	STBOX_Y3+196,a0
	move	@player3_data+PR_NICKNAME_NBR,a2
	callr	create_plr_nickname
#nm3
	calla	get_name_string
	calla	print_string_C

#skip3
	movi	STBOX_Y4+196,a0
	move	a0,@mess_cursy
	movi	STBOX_X4+40,a0
	move	a0,@mess_cursx
	move	@PSTATUS,a0
	btst	3,a0
	jrnz	#ok4
	movi	#str_cpu,a4
	calla	print_string_C2
	jruc	#skip4
#ok4
	movi	message_buffer,a3
	movi	player4_data+PR_NAME1,a4
	move	@player4_data+PR_CREATED_PLYR,a14
	jrle	#nm4
	movi	STBOX_Y4+71,a0
	move	a0,@mess_cursy
	movi	STBOX_Y4+196,a0
	move	@player4_data+PR_NICKNAME_NBR,a2
	callr	create_plr_nickname
#nm4
	calla	get_name_string
	calla	print_string_C
#skip4
	rets


#initials_setup
	PRINT_STR	bast8t_ascii,8,1,200,4,BAST_W_P,0
#str_cpu
	.string	"CPU",0
	.even

	.ref	tm1set,tm2set

#*****************************************************************************
*		This routine prints the players' nickname under mugshot
*
*   INPUT: reg a0 - Y pos
*          reg a2 - nick name number
******************************************************************************
 SUBRP	create_plr_nickname
 	
	PUSH	a3,a4
	move	a0,a1
	sll	16,a1
	move	@mess_cursx,a0

	sll	6,a2				;2*32
	addi	nickname_img_tbl,a2,L
	move	*a2,a2,L

	move	*a2(ISIZEX),a14			;center obj. at X coor.
	srl	1,a14
	sub	a14,a0
	sll	16,a0

	movi	6000,a3					;z pos.
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	clr	a5			;object class
	clr	a6					;x vel
	clr	a7					;y vel
	calla	BEGINOBJ2
	PULL	a3,a4
 	rets


#*****************************************************************************
* Show name of HEAD (basketball players name)
*
* INPUT: reg a1 - Y position
**************************************************
 SUBR	create_names

	PUSH	a9
	sll	16,a1
	move	a1,a9

	movi	player_names,a10
	move	@team1,a2
#lp	cmpi	0,a2
	jrz	#out
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
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
;
;name 1 (team 1)
;
	movi	player1_data,a14
	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
	jrgt	#hd2				;br=yep..dont show a name

	move	@special_heads,a0
	jrn	#not_spec1
	sll	5,a0				;x 32 bits
	addi	our_names,a0
	move	*a0,a2,L
#not_spec1
	movi	[STBOX_X1+48,0],a0			;x val
	move	a9,a1
;	movi	[STBOX_Y1+71,0],a1			;y val
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
;
;name 2 (team 1)
;
#hd2	move	*a10(20h),a2,L			;image addr

	movi	player2_data,a14
	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
	jrgt	#hd3				;br=yep..dont show a name

	move	@special_heads+10h,a0
	jrn	#not_spec2
	sll	5,a0				;x 32 bits
	addi	our_names,a0
	move	*a0,a2,L
#not_spec2
	movi	[STBOX_X2+42,0],a0			;x val
	move	a9,a1
;	movi	[STBOX_Y2+71,0],a1			;y val
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
#hd3
	movi	player_names,a10
	move	@team2,a2
#lp1	cmpi	0,a2
	jrz	#out1
	addi	NEXT_TEAM_NAMES,a10		;compute offset into table
	dec	a2
	jruc	#lp1
#out1
	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10
;
; name 1 (team 2)
;
	move	*a10,a2,L			;image addr

	movi	player3_data,a14
	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
	jrgt	#hd4				;br=yep..dont show a name

	move	@special_heads+20h,a0
	jrn	#not_spec3
	sll	5,a0				;x 32 bits
	addi	our_names,a0
	move	*a0,a2,L
#not_spec3

	movi	[STBOX_X3+47,0],a0			;x val
	move	a9,a1
;	movi	[STBOX_Y3+71,0],a1			;y val
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
;
; name 2 (team 2)
;
#hd4	move	*a10(20h),a2,L			;image addr

	movi	player4_data,a14
	move	*a14(PR_CREATED_PLYR),a0	;is player created ?
	jrgt	#hd5				;br=yep..dont show a name

	move	@special_heads+30h,a0
	jrn	#not_spec4
	sll	5,a0				;x 32 bits
	addi	our_names,a0
	move	*a0,a2,L
#not_spec4
	movi	[STBOX_X4+41,0],a0			;x val
	move	a9,a1
;	movi	[STBOX_Y4+71,0],a1			;y val
	movi	120,a3				;z pos
	movi	DMAWNZ,a4			;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
#hd5	PULL	a9
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_hi_score_page_objs

;create vertical bar
	movi	10,a3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5
	clr	a6
	clr	a7
	movi	[7,0],a0
	movi	[0,0],a1
	movi	NBABAR,a2,L
	calla	BEGINOBJ2


;create nba logo
	movi	12,a3
	movi	[7,0],a0
	movi	[181,0],a1
	movi	NBALOGO,a2,L
	calla	BEGINOBJ2
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	animate_vs_logo

	movi	2000,a3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5
	clr	a6
	clr	a7

;create V and S letters
	movi	[VS_X,0],a0
	movi	[VS_Y+104,0],a1
	movi	VSB01,a2
	calla	BEGINOBJ2
	move	a8,a10

	movi	[VS_X,0],a0
	movi	[VS_Y+104,0],a1
	movi	VSS01,a2
	calla	BEGINOBJ2
	move	a8,a9

;animate VS logo
	movi	vs_logo_anim_tbl,a11
avsl_1
;V
	move	*a11+,a0,L			;new V img.
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	move	a9,a8				;get V obj. ptr
	calla	obj_aniq
;S
	move	*a11+,a0,L			;new V img.
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	move	a10,a8				;get V obj. ptr
	calla	obj_aniq

	move	*a11+,a0			;get sleep time
	calla	PRCSLP

	cmpi	vs_logo_anim_tbl_end,a11,L
	jrlo	avsl_1
 	DIE

;
; This table contains information pertaining to the VS logo animating
;
; 1) img frame of V
; 3) Y pos of V
; 2) img frame of S
; 4) Y pos of S
; 5) sleep time
;
vs_logo_anim_tbl
	.long	VSB01,VSS01
	.word	2
	.long	VSB02,VSS02
	.word	2
	.long	VSB03,VSS03
	.word	2
	.long	VSB04,VSS04
	.word	2
	.long	VSB05,VSS05
	.word	2
	.long	VSB06,VSS06
	.word	3
	.long	VSB07,VSS07
	.word	3
	.long	VSB08,VSS08
	.word	3
	.long	VSB09,VSS09
	.word	3
vs_logo_anim_tbl_end
	

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	kill_vs_logo

	movi	VS_LOGO_PID,a0
	calla	KIL1C
	rets
 
;-----------------------------------------------------------------------------
;	This routine deletes the current PRESSED in BUTTON
;-----------------------------------------------------------------------------
 SUBR	del_pressed_bball

	movi	pball_obj_ptrs,a2,L			;ram to save obj ptrs
	move	*a2+,a8,L
	calla	DELOBJA8

;delete its shadow
	movi	BBALL_SHADOW,a0
	calla	obj_del1c
	rets

;-----------------------------------------------------------------------------
;	This routine deletes the current normal BBALL
;-----------------------------------------------------------------------------
 SUBR	del_normal_hilited_bball

	move	@cur_pos,a0
	sll	5,a0
	addi	bball_obj_ram_ptrs,a0,L
	move	*a0,a2,L			;get ptr. to ram ptrs.
dnb_1
	move	*a2,a8,L
	calla	DELOBJA8

;delete its shadow
	movi	BBALL_SHADOW,a0
	calla	obj_del1c
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_not_allowed_symbol
 	
	movi	[BALL1X-3,0],a0			;x val
	movi	[BALL1Y+1,0],a1			;y val
 	movi	F_NO1,a2,L
	movi	500,a3
	movi	DMAWNZ,a4		;DMA flags
;;	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	OPTION_STUFF,a5		;object ID
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movi	[BALL1X-3,0],a0			;x val
	movi	[BALL1Y+1,0],a1			;y val
	movi	F_NO2,a2,L
 	calla	BEGINOBJ2

	movi	[BALL1X-3,0],a0			;x val
	movi	[BALL1Y+1,0],a1			;y val
	movi	600,a3
 	movi	ONE,a2,La
 	calla	BEGINOBJ2
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_team_sel_header

	movi	[99,0],a0			;x val
	movi	[9,0],a1			;y val
 	movi	HEADER,a2,L
	movi	50,a3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	TEAM_SEL_OBJS,a5				;object ID
	clr	a6
	clr	a7
	movi	TUBE_V_P,b0,L
 	calla	BEGINOBJP2
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_option_screen_stuff
	
	movi	SPOTLIGHT,a0				;object ID
	calla	obj_del1c
	movi	BBALL_SHADOW,a0
	calla	obj_del1c
	movi	OPTION_STUFF,a0
	calla	obj_del1c
 	movi	TITLE_BAR,a0
	calla	obj_del1c
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	kill_countdown_timer

	movi	CNTDWN_PID,a0
	calla	KIL1C
	calla	delete_text
 	rets


;-----------------------------------------------------------------------------
;   This routine handles the logic for the player chosing an option at
;  begining of game
;
; RETURNS: a0 = 0:player design, 1:enter initials,  2:select teams
;-----------------------------------------------------------------------------
 SUBR	options_screen

	movk	1,a0			;start on 'enter initials'
	move	a0,@cur_pos

	clr	a0
	move	a0,@create_plyr
	move	a0,@IRQSKYE		;BLACK background color

	calla	del_create_spotlight
	clr	a0
	calla	create_title_bar

;create text for screen
	movi	opt_str_setup,a2
	calla	setup_message
	movi	OPTION_STUFF,a0
	move	a0,@mess_objid
	movk	22,a0
	move	a0,@mess_line_spacing
	movi	option_strings,a4
	calla	print_string_C2

	movi	bball_1_obj_ptrs,a9,L
	movi	[BALL1X,0],a0,L				;X coor.
	movi	[BALL1Y,0],a1,L				;Y coor.
	calla	create_normal_bball

	movi	bball_2_obj_ptrs,a9,L
	movi	[BALL2X-2,0],a0,L			;X coor.
	movi	[BALL2Y,0],a1,L				;Y coor.
	calla	create_normal_bball

	movi	bball_3_obj_ptrs,a9,L
	movi	[BALL3X-1,0],a0,L			;X coor.
	movi	[BALL3Y,0],a1,L				;Y coor.
	calla	create_normal_bball

	calla	create_bball_text

	calla	update_bball_text_pals
	calla	update_bball_palettes

	.ref	pregame_tune
	SOUND1	pregame_tune

	CREATE	WIN_STAY_PID,winner_stays_msg

	SLEEPK	6

	movi	5*TSEC,a10
	CREATE	CNTDWN_PID,timeout

	movi	20*TSEC,a7		;timeout time
	clr	a10			;used to mark last joystick pos.
#input_loop
;
; Here I check to see if the 'CREATE PLAYER' should still be allowed ...
; If more than 1 player is in game, move it to 'ENTER INITIALS' and dont allow
;  CREATE PLAYER option.
;
#nxtchk
	move	@create_plyr,a0
	jrn	#curok			;did DISALLOWING create plyr logic
	callr	check_for_buyins
	move	a0,a0
	jrnn	#curok			;br=only 1 player in game
	move	a0,@create_plyr
	callr	create_not_allowed_symbol
	move	@cur_pos,a0
	jrnz	#curok			;br= cursor isn't on 'create player'
	jruc	#j_right
#curok
	calla	get_all_sticks_cur
	cmp	a10,a0			;same as last joystick pos. ?
	jreq	#no_change		;yep...ignore
	move	a0,a10			;save NEW joystick position
	cmpi	JOY_RIGHT,a0
	jreq	#j_right
	cmpi	JOY_LEFT,a0
	jrne	#no_change
;
; Move cursor left (maybe)
;
	move	@cur_pos,a0		;get current option (0,1 or 2)
	jrle	#updateX		;br=cant move left
	cmpi	1,a0			;on 'Enter Name" ?
	jrne	#jlft1
	move	@create_plyr,a14
	jrn	#no_change		;br='create player' isn't allowed
#jlft1
	dec	a0			;move cursor 1 left
	move	a0,@cur_pos
	SOUND1	opt_scr_cur
	jruc	#updateX
;
; Move cursor right (maybe)
;
#j_right
	move	@cur_pos,a0		;get current option (0,1 or 2)
	cmpi	2,a0
	jrge	#updateX	        ;br=cant move right
;	move	@create_plyr,a1
;	jrn	#no_change		;br='create player' isn't allowed
	inc	a0			;move cursor 1 right
	move	a0,@cur_pos
	SOUND1	opt_scr_cur

#updateX
	calla	del_create_spotlight
	calla	update_bball_palettes
	calla	update_bball_text_pals
#no_change
	SLEEPK	1

	move	@force_selection,a0
	jrz	#no_timeout			;timeout yet ?

	movk	2,a0				;default to 'team select'
	move	a0,@cur_pos

	calla	del_create_spotlight
	calla	update_bball_palettes
	jruc	#timeout

#no_timeout
	calla	get_all_buttons_down
	jrz	#input_loop
;
; Player hit a button...or timer expired
;
#timeout
	SOUND1	opt_scr_sel

	move	@cur_pos,a0
	jrnz	#tmeout2			;br=cursor NOT on CREATE PLYR

;plyr selected CREATE PLAYER, make sure its what player wants

	move	@bball_1_text_obj_ptr,a8,L
	calla	obj_off				;hide ball 1 text

	callr	del_normal_hilited_bball
	calla	create_pressed_bball_and_shadow

	callr	print_create_plr_info
	JSRP	ask_create_plyr_yes_no
	movk	4,a10
	calla	del_yes_no_buttons
	callr	del_pressed_bball

	movi	bball_1_obj_ptrs,a9,L
	movi	[BALL1X,0],a0,L				;X coor.
	movi	[BALL1Y,0],a1,L				;Y coor.
	callr	create_normal_bball
	callr	create_normal_bball_shadow

	move	@bball_1_text_obj_ptr,a8,L
	calla	obj_on				;un-hide ball 1 text

	move	a11,a11				;did player select 'YES' ?
	jrnz	#input_loop			;br=no

#tmeout2
;	SOUND1	opt_scr_sel

	calla	kill_countdown_timer

	calla	del_create_spotlight
	calla	update_bball_palettes

	callr	del_normal_hilited_bball
	calla	create_pressed_bball_and_shadow
	JSRP	flash_pressed_bball

	movi	WATCH_FOR_PLAYERS_PID,a0,L
	calla	KIL1C

	move	@cur_pos,a0			;a0=0,1 or 2 (return value)
	RETP

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_winner_stay_free_msg

	movi	WIN_STAY_PID,a0
	movi	-1,a1
 	calla	EXISTP
	move	a0,a0				;find process ?
	jrz	dwsf_1				;br=nope

	movi	WIN_STAY_PID,a0
	calla	KIL1C
	movi	WIN_STAY_MSG,a0			;object ID
	calla	obj_del1c			;delete text
dwsf_1 	rets


;-----------------------------------------------------------------------------
;	This routine creates the images that makeup the spotlights on the
; options screen
;-----------------------------------------------------------------------------
 SUBR	del_create_spotlight

 	PUSH	a7,a10
;delete all spotlights (and shadows)

	movi	SPOTLIGHT,a0				;object ID
	calla	obj_del1c
	movi	BBALL_SHADOW,a0
	calla	obj_del1c

;create new spotlight
	movi	10,a3					;z pos (sorting)
	movi	DMAWNZ,a4			;DMA flags
;;	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	clr	a6					;x vel
	clr	a7					;y vel
	movi	SPOTLITE_PARTS,a11			;count

	move	@cur_pos,a10
	move	a10,a14
	sll	6,a10					;*64
	sll	5,a14					;*32
	add	a14,a10					;+96
	addi	sptlght_img_tbl_ptr_tbl,a10
	move	*a10+,a0,L
	move	*a10+,a1,L
	move	*a10,a9,L				;get table ptr.
cfsl_1
	move	*a9+,a2,L
	PUSH	a0,a1
	movi	SPOTLIGHT,a5				;object ID
	calla	BEGINOBJ2
	PULL	a0,a1
	dsj	a11,cfsl_1
	PULL	a7,a10
	callr	create_normal_bball_shadow
	rets

;-----------------------------------------------------------------------------
;create ball shadow
;-----------------------------------------------------------------------------
 SUBR	create_normal_bball_shadow

	PUSH	a7,a10,a11
	movi	15,a3					;z pos (sorting)
	movi	DMAWNZ,a4			;DMA flags
;;	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	BBALL_SHADOW,a5
	clr	a6					;x vel
	clr	a7					;y vel
	movi	BBALL_SHDW_PARTS,a11			;2 pieces for shadow

	move	@cur_pos,a10
	move	a10,a14
	sll	6,a10					;*64
	sll	5,a14					;*32
	add	a14,a10					;+96
	addi	sptlght_bball_shadw_img_tbl,a10
	move	*a10+,a0,L
	move	*a10+,a1,L
	move	*a10,a9,L				;get table ptr.
cnbs_1
	move	*a9+,a2,L
	PUSH	a0,a1
	calla	BEGINOBJ2
	PULL	a0,a1
	dsj	a11,cnbs_1
	PULL	a7,a10,a11
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_normal_bball

	movi	20,a3					;z pos (sorting)
;;	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	DMAWNZ,a4			;DMA flags
	movi	OPTION_STUFF,a5				;object ID
	clr	a6					;x vel
	clr	a7					;y vel
cfbb_1
	movi	BIGBAL1,a2,L
	calla	BEGINOBJ2
	move	a8,*a9+,L
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	update_bball_text_pals

	movi	bball_text_obj_ptrs,a7,L
	clr	a2
ubtp_0
	move	@cur_pos,a14,L
	move	*a7+,a8,L			;get ptr to obj. ptr
	move	*a8,a8,L			;get obj. ptr
	movi	FNT_W_P,a0,L
	cmp	a14,a2
	jrne	ubtp_1
	movi	FNT_G_P,a0,L
ubtp_1	calla	pal_getf
	move	a0,*a8(OPAL)			;change text palette

	inc	a2
	cmpi	bball_text_obj_ptrs_end,a7
	jrlo	ubtp_0
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_bball_text

	movi	bball_text_img_setup,a10,L
	movi	80,a3					;z pos (sorting)
	movi	DMAWNZ,a4			;DMA flags
;;	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	OPTION_STUFF,a5				;object ID
	clr	a6					;x vel
	clr	a7					;y vel
cbt_1
	move	*a10+,a9,L			;get ptr. to ram location
	move	*a10+,a2,L			;get img ptr.
	move	*a10+,a0,L			;get X coor.
	move	*a10+,a1,L			;get Y coor.

	calla	BEGINOBJ2
	move	a8,*a9,L

	cmpi	bball_text_img_setup_end,a10,L
	jrlo	cbt_1

;;	CREATE	PAL_CYCLE_PID,cycle_bball_text_pal

 	rets

;-----------------------------------------------------------------------------
; This process blinks the color of the TEXT on the ball
;-----------------------------------------------------------------------------
; SUBRP	cycle_bball_text_pal
;
;	move	@cur_pos,a0,L
;	sll	5,a0
;	addi	bball_text_obj_ptrs,a0
;	move	*a0,a0,L
;	move	*a0,a8,L
;cbtp_1	movi	bball_text_cycle_tbl,a10,L
;cbtp_2
;;	move	*a2+,a8,L			;get bball img. obj. ptr
;	move	*a10+,a0,L
;	calla	pal_getf
;	move	a0,*a8(OPAL)			;change button palette
;;	SLEEPK	20
;
;	move	*a10+,a0
;	calla	PRCSLP
;
;	cmpi	bball_text_cycle_tbl_end,a10,L
;	jrlo	cbtp_2
;	jruc	cbtp_1
; 	DIE

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	update_bball_palettes

;first ball

	movi	bball_1_obj_ptrs,a2,L
	clr	a1
	calla	change_bball_pal

;second ball

	movi	bball_2_obj_ptrs,a2,L
	movk	1,a1
	calla	change_bball_pal

;third ball

	movi	bball_3_obj_ptrs,a2,L
	movk	2,a1
	calla	change_bball_pal
	rets

;-----------------------------------------------------------------------------
;   This routine changes the palettes on all the BASKETBALL images during
; the OPTION screen (not cursor = dim, else bright pal)
;
; INPUT: a1: bball nbr. updating (0-2)
;        a2: ptr to ram pointer of obj.
;-----------------------------------------------------------------------------
 SUBR	change_bball_pal

	movi	BIGBLD_P,a0,L			;dim bball pal
	move	@cur_pos,a3			;get current hi-lited option
	cmp	a3,a1 				;this one hi-lited ?
	jrne	cbpp_1				;br=nope
	movi	BIGBAL_P,a0,L			;bright bball pal
cbpp_1	

cbpp_2	move	*a2+,a8,L			;get bball img. obj. ptr
	calla	pal_getf
	move	a0,*a8(OPAL)			;change button palette
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_pressed_bball_and_shadow

	movi	pball_obj_ptrs,a9,L			;ram to save obj ptrs
	movi	21,a3					;z pos (sorting)
	movi	DMAWNZ,a4			;DMA flags
;;	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	OPTION_STUFF,a5				;object ID
	clr	a6					;x vel
	clr	a7					;y vel

;create pressed bball (get X,Y coords. from table)
	move	@cur_pos,a2,L
	sll	6,a2
	addi	pressed_bball_xys,a2,L
	move	*a2+,a0,L				;get X coor.
	move	*a2+,a1,L				;get Y coor.
cpbas_1
	movi	SMBAL1,a2,L
	calla	BEGINOBJ2
	move	a8,*a9+,L

;create pressed bball shadow   (get X,Y coords. from table)

	movi	BBALL_SHADOW,a5				;object ID
	movi	PBALL_SHDW_PARTS,a11				;2 pieces for shadow
	move	@cur_pos,a10,L
	sll	7,a10
	addi	pressed_bball_shadw_tbl,a10,L
	move	*a10+,a0,L				;get X coor.
	move	*a10+,a1,L				;get Y coor.
cpbas_2
	move	*a10+,a2,L
	PUSH	a0,a1
	calla	BEGINOBJ2
;	move	a8,*a9+,L
	PULL	a0,a1
	dsj	a11,cpbas_2
 	rets


bball_obj_ram_ptrs
	.long	bball_1_obj_ptrs
	.long	bball_2_obj_ptrs
	.long	bball_3_obj_ptrs

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBRP	flash_pressed_bball

	movk	5,a9
	move	@pball_obj_ptrs,a8,L			;ram to save obj ptrs
fpb_1
;pure white
	movi	0101h,a2
	move	a2,*a8(OCONST)
	move	*a8(OCTRL),a0
	andni	01111b,a0
	ori	M_CONNON,a0		;Replace all with constant
	move	a0,*a8(OCTRL)
	SLEEPK	1

;show normal image
	move	*a8(OCTRL),a0
	andni	01111b,a0
	ori	M_WRNONZ,a0
	move	a0,*a8(OCTRL)
	SLEEPK	1
	dsj	a9,fpb_1
	RETP


;-----------------------------------------------------------------------------
; This routine checks to see if more than 1 player has bought or a player 
;  has bought more than 1 quater of game play.
; If so, then CREATE PLAYER, is not allowed
;
; OUTPUT: reg a0  (if negative, disallow 'create-a-player')
;-----------------------------------------------------------------------------
 SUBR	check_for_buyins

	movk	ADJFREPL,a0
	calla	GET_ADJ 	;SEE IF FREEPLAY......(Z BIT CLEAR IF SO!)
	jrnz	frep1
;	calla	CRED_P
;	move	a0,a0
;	jrnz	w3p_0	

frep1	move	@qtr_purchased,a0
	move	@qtr_purchased+16,a14
	add	a14,a0
	move	@qtr_purchased+32,a14
	add	a14,a0
	move	@qtr_purchased+48,a14
	add	a14,a0
	cmpi	1,a0
	jrls	w3p_1

;	move	@PSTATUS,a0		;a0=players in game (rep. by bits)
;	cmpi	8,a0			;check for player 4 only
;	jreq	w3p_1			;br=yep
;	cmpi	4,a0			;check for player 3 only
;	jreq	w3p_1			;br=yep
;	cmpi	2,a0			;check for player 2 only
;	jreq	w3p_1			;br=yep
;	cmpi	1,a0			;check for player 1 only
;	jreq	w3p_1			;br=yep

w3p_0
	movi	-1,a0
w3p_1	rets


	.asg	0,TM_NAME_Y
	.asg	12,TM_NAME_SPC

;-----------------------------------------------------------------------------
;	This routine deletes a set of team city names
;
; INPUT: a0 - obj. id to delete
;-----------------------------------------------------------------------------
 SUBR	delete_team_city_names

	clr	a1
	calla	obj_del1c
	rets

;-----------------------------------------------------------------------------
;        This routine creates TM_NAMES_ON_SCRN city name objects
;
; INPUT: a0 = X coor
;        a5 = obj id
;	 a14 = table index
;-----------------------------------------------------------------------------
 SUBR	create_team_city_names

	move	a14,a11
	sll	5,a11				;long
	sll	4,a14				;word
	add	a14,a11
	addi	city_table_start,a11

	movi	1800,a3				;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a6				;x vel
	clr	a7				;y vel
	movi	TM_NAMES_ON_SCRN,a10		;nbr. team names to plot
	movi	[TM_NAME_Y,0],a1		;starting Y val
#ccn_1
	movi	BAST_D_P,b0			;default pal. for city imgs.
	addi	[TM_NAME_SPC,0],a1		;add spacing
	cmpi	MIDDLE_TEAM_NAME,a10		;plotting hi-lighted city ?
	jrne	#nhlit2				;br=nope
;	movi	BAST_W_P,b0			;HILITED middle city name
	movi	BAST_Y_P,b0			;HILITED middle city name
	addi	[1,0],a1			;space around the backplate
#nhlit2
	cmpi	MIDDLE_TEAM_NAME-1,a10	      	;1 after hilited city ?
	jrne	#nhlit2a			;br=nope
	addi	[1,0],a1			;space around the backplate
#nhlit2a
	move	*a11,a2,L			;get TEAM NAME image ptr
	PUSH	a0,a1
	calla	BEGINOBJP2
	PULL	a0,a1

	addi	OFFSET_NXT_CITY_NAME,a11        ;ptr. next city img. (skip city nbr.)
	dsj	a10,#ccn_1
	rets


;-----------------------------------------------------------------------------
;	 Create both backdrops for TEAM PLAYERS HEADS
;
;
; INPUT: reg a0 - table offset for coor.
;-----------------------------------------------------------------------------
 SUBR	create_player_head_backdrops

	movi	hd_bkdrp_tbl,a9,L
	sll	7,a0
	add	a0,a9

;left backdrop
	move	*a9+,a0,L			;get X coor
	move	*a9+,a1,L			;get Y coor
 	movi	RHEAD,a2,L
	movi	6,a3
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	TEAM_SEL_OBJS,a5				;object ID
	clr	a6
	clr	a7
	movi	HEADW_P,b0,L
 	calla	BEGINOBJP2
	move	a8,@plate1_objs,L

;right backdrop
	move	*a9+,a0,L			;get X coor
	move	*a9+,a1,L			;get Y coor
 	movi	LHEAD,a2,L
	movi	6,a3
	movi	HEADW_P,b0,L
	calla	BEGINOBJP2
	move	a8,@plate2_objs,L
	rets 	


hd_bkdrp_tbl
	.long	[TM1_X-86,0],[TM1_Y+6,0]
	.long	[TM2_X-93,0],[TM2_Y+6,0] 		;teamsel page

	.long	[TM1_X-86,0],[TM1_Y-65,0]		;stat page
	.long	[TM2_X-93,0],[TM2_Y-65,0]


;-----------------------------------------------------------------------------
;	This routine changed the image behind the player heads
; during team select.
;
; INPUT: reg. a0 - team nbr (0-1)
;-----------------------------------------------------------------------------
 SUBR	update_player_head_backdrop
	
	sll	7,a0
	addi	plate_obj_tbl,a0
	move	*a0+,a8,L			;get pointer
	move	*a8,a8,L			;get OLD img (ptr addr)
	move	*a0+,a9,L			;get NEW img. ptr

;update palette and bits per pixel
	move	*a0,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)

	move	*a8(OCTRL),a1
	andi	>80ff,a1		;DMA flags
	move	*a9(ICTRL),a14
	andni	>80ff,a14		;DMA flags
	or	a14,a1
	move	a1,*a8(OCTRL)

	move	a9,a0

	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	calla	obj_aniq
 	rets


plate_obj_tbl
;	.long	plate1_objs,SQUAD1,SQUAD_P,0
	.long	plate1_objs,SQUAD1,SQAD_VB_P,0
	.long	plate2_objs,SQUAD2,SQAD_VR_P,0


SQUAD_P:
   .word   63 
   .word   039ach,05294h,04e73h,04a52h,04631h,04210h,03defh,039ceh
   .word   035adh,0318ch,0316ch,0294ah,02529h,02509h,02108h,020e8h
   .word   01ce7h,01cc7h,018c6h,018a6h,014a5h,01485h,01084h,00c63h
   .word   00842h,00421h,00401h,06a9fh,05e1dh,0559bh,04d3ah,044d8h
   .word   040d7h,03c96h,03876h,03455h,03014h,02c13h,02410h,0200dh
   .word   01c0ch,0180bh,0180ah,01409h,01408h,01006h,00c05h,07fe0h
   .word   07bc0h,077a0h,07380h,06f60h,06b40h,06720h,05ee0h,05ac0h
   .word   056a0h,05280h,04e60h,04620h,03de0h,035a0h,02100h


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBRP	ask_create_plyr_yes_no

	movk	4,a10				;a table offset
	calla	create_small_yes_no_butns

	movk	1,a11				;DEFAULT to 'NO'

	movi	6*TSEC,a10			;timeout counter (6 seconds)
ayn_0
 	SLEEPK	1

;
; during option screen, if >1 player buys in while the other player was
;  answering the yes/no question...stop all yes/no processing and return
;
	calla	check_for_buyins
	move	a0,a0
	jrnn	ayn_1				;br=only 1 plr. in game...

;'CREATE PLAYER' NOT allowed, stop asking yes/no
	movk	1,a11				;set to 'NO'
	jruc	ayn_6

;check for timeout
ayn_1
	dsj	a10,ayn_2			;br=dont time out...yet
	movk	1,a11				;DEFAULT to 'NO'
	calla	reset_yes_no_butn_pals
	jruc	ayn_3

ayn_2
	calla	get_all_sticks_down

	cmpi	JOY_UP,a0			;joystick up ?
	jrne	ayn_1b				;br=nope
	move	a11,a11
	jrz	ayn_2a				;br=cursor already on 'YES'
	clr	a11				;set to 'YES'
	calla	reset_yes_no_butn_pals
	SOUND1	yes_no_cur1
	jruc	ayn_2a

ayn_1b	cmpi	JOY_DOWN,a0			;joystick down ?
	jrne	ayn_2a				;br=nope
	move	a11,a11
	jrnz	ayn_2a				;br=cursor already on 'NO'
	movk	1,a11				;set to 'NO'
	calla	reset_yes_no_butn_pals
	SOUND1	yes_no_cur1
;
; Now, read buttons
;
ayn_2a
	calla	update_yes_no_button_pals

	calla	get_all_buttons_down

	cmpi	TURBO_BUTTON,a0
	jreq	ayn_3
	cmpi	PASS_BUTTON,a0
	jreq	ayn_3
	cmpi	SHOOT_BUTTON,a0
	jrne	ayn_0
ayn_3
	SOUND1	yes_no_sel1

	move	a11,a11				;did player choose 'YES'
	jrnz	ayn_3a				;br=no
	
;this is set, so that the START BUTTON can be ignored prior to entering
; create player mode (so don't eat credits)

	movi	IN_PRE_PLYR_DESIGN,a0
	move	a0,@GAMSTATE

ayn_3a	JSRP	flash_pressed_yes_no_button
ayn_6
	RETP

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	print_subsitution_directions

	movi	substutn_dirs_str_setup,a2
	calla	setup_message
	movi	HIT_PTS_FRACTION,a0
	move	a0,@mess_objid
	movk	12,a0
	move	a0,@mess_line_spacing
	movi	substutn_dirs_strs,a4,L
	calla	print_string_C2

	movi	HIT_PTS_FRACTION,a10,L
	CREATE	FLSH_TXT_PID,change_pal_on_text
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	print_subsitution_title

	movi	subsitution_str_setup,a2
	calla	setup_message
	clr	a0
	move	a0,@mess_objid
	movk	10,a0
	move	a0,@mess_line_spacing
	movi	subsitution_str,a4,L
	calla	print_string_C2
	rets

;-----------------------------------------------------------------------------
;     This message is displayed when player selects CREATE PLAYER option
;-----------------------------------------------------------------------------
 SUBR	print_create_plr_info
 	
	movi	create_plr_info_setup,a2
	calla	setup_message
	movi	YES_NO_BUTNS,a0
	move	a0,@mess_objid
	movk	10,a0
	move	a0,@mess_line_spacing
	movi	create_plr_info,a4,L
	calla	print_string_C2
	rets


;----------- TABLES ------------
;----------- TABLES ------------
;----------- TABLES ------------
;----------- TABLES ------------

PLTF1_B_P:
   .word   58 
   .word   04210h,0297fh,0257fh,0255fh,0215fh,0213fh,01d3fh,01d1fh
   .word   0191fh,018ffh,014ffh,010dfh,014dfh,010bfh,010dfh,010bfh
   .word   010dfh,010dfh,010bfh,010bfh,010beh,010bdh,010bch,010bbh
   .word   010bah,010b9h,010b8h,010b7h,010b6h,010b5h,01095h,010b4h
   .word   01094h,010b3h,01093h,010b2h,01092h,01091h,01090h,0108fh
   .word   0108eh,0108dh,0108ch,0108bh,0108ah,01089h,01088h,01087h
   .word   01086h,01085h,01084h,04631h,04e73h,056b5h,06318h,06b5ah
   .word   07fffh,07fffh

PLTF2_B_P:
   .word   58 
   .word   04210h,039ffh,035ffh,035dfh,031dfh,031bfh,02dbfh,02d9fh
   .word   0299fh,0297fh,0257fh,0215fh,0255fh,0213fh,0215fh,0213fh
   .word   0215fh,0215fh,0213fh,0213fh,0213fh,0213fh,0213fh,0213fh
   .word   0213eh,0213dh,0213ch,0213bh,0213ah,02139h,02119h,02138h
   .word   02118h,02137h,02117h,02136h,02116h,02115h,02114h,02113h
   .word   02112h,02111h,02110h,0210fh,0210eh,0210dh,0210ch,0210bh
   .word   0210ah,02109h,02108h,056b5h,05ef7h,06739h,0739ch,07bdeh
   .word   07fffh,07fffh

PLTF3_B_P:
   .word   58 
   .word   04210h,056dfh,052dfh,052bfh,04ebfh,04e9fh,04a9fh,04a7fh
   .word   0467fh,0465fh,0425fh,03e3fh,0423fh,03e1fh,03e3fh,03e1fh
   .word   03e3fh,03e3fh,03e1fh,03e1fh,03e1fh,03e1fh,03e1fh,03e1fh
   .word   03e1fh,03e1fh,03e1fh,03e1fh,03e1fh,03e1fh,03dffh,03e1fh
   .word   03dffh,03e1eh,03dfeh,03e1dh,03dfdh,03dfch,03dfbh,03dfah
   .word   03df9h,03df8h,03df7h,03df6h,03df5h,03df4h,03df3h,03df2h
   .word   03df1h,03df0h,03defh,0739ch,07bdeh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF4_B_P:
   .word   58 
   .word   04210h,06f9fh,06b9fh,06b7fh,0677fh,0675fh,0635fh,0633fh
   .word   05f3fh,05f1fh,05b1fh,056ffh,05affh,056dfh,056ffh,056dfh
   .word   056ffh,056ffh,056dfh,056dfh,056dfh,056dfh,056dfh,056dfh
   .word   056dfh,056dfh,056dfh,056dfh,056dfh,056dfh,056bfh,056dfh
   .word   056bfh,056dfh,056bfh,056dfh,056bfh,056bfh,056bfh,056bfh
   .word   056bfh,056beh,056bdh,056bch,056bbh,056bah,056b9h,056b8h
   .word   056b7h,056b6h,056b5h,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF5_B_P:
   .word   58 
   .word   04210h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF1_Y_P:
   .word   58 
   .word   04210h,07fe9h,07fe8h,07fe8h,07fe7h,07fe7h,07fe6h,07fe6h
   .word   07fe5h,07fe5h,07fe4h,07fe3h,07fe4h,07fe3h,07fe3h,07fe3h
   .word   07fe3h,07fe3h,07fe3h,07bc3h,077a3h,07383h,06f63h,06b43h
   .word   06723h,06303h,05ee3h,05ac3h,056a3h,05283h,05283h,04e63h
   .word   04e63h,04a43h,04a43h,04623h,04623h,04203h,03de3h,039c3h
   .word   035a3h,03183h,02d63h,02943h,02523h,02103h,01ce3h,018c3h
   .word   014a3h,01083h,00c63h,04210h,04a52h,05294h,05ef7h,06739h
   .word   07bdeh,07fffh

PLTF2_Y_P:
   .word   58 
   .word   04210h,07fech,07febh,07febh,07feah,07feah,07fe9h,07fe9h
   .word   07fe8h,07fe8h,07fe7h,07fe6h,07fe7h,07fe6h,07fe6h,07fe6h
   .word   07fe6h,07fe6h,07fe6h,07fe6h,07fe6h,07fe6h,07bc6h,077a6h
   .word   07386h,06f66h,06b46h,06726h,06306h,05ee6h,05ee6h,05ac6h
   .word   05ac6h,056a6h,056a6h,05286h,05286h,04e66h,04a46h,04626h
   .word   04206h,03de6h,039c6h,035a6h,03186h,02d66h,02946h,02526h
   .word   02106h,01ce6h,018c6h,04e73h,056b5h,05ef7h,06b5ah,0739ch
   .word   07fffh,07fffh

PLTF3_Y_P:
   .word   58 
   .word   04210h,07ff2h,07ff1h,07ff1h,07ff0h,07ff0h,07fefh,07fefh
   .word   07feeh,07feeh,07fedh,07fech,07fedh,07fech,07fech,07fech
   .word   07fech,07fech,07fech,07fech,07fech,07fech,07fech,07fech
   .word   07fech,07fech,07fech,07fech,07bcch,077ach,077ach,0738ch
   .word   0738ch,06f6ch,06f6ch,06b4ch,06b4ch,0672ch,0630ch,05eech
   .word   05acch,056ach,0528ch,04e6ch,04a4ch,0462ch,0420ch,03dech
   .word   039cch,035ach,0318ch,06739h,06f7bh,077bdh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF4_Y_P:
   .word   58 
   .word   04210h,07ff6h,07ff5h,07ff5h,07ff4h,07ff4h,07ff3h,07ff3h
   .word   07ff2h,07ff2h,07ff1h,07ff0h,07ff1h,07ff0h,07ff0h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07bf0h,07bf0h,077d0h,073b0h,06f90h
   .word   06b70h,06750h,06330h,05f10h,05af0h,056d0h,052b0h,04e90h
   .word   04a70h,04650h,04230h,077ddh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF5_Y_P:
   .word   58 
   .word   04210h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07bffh,077ffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF1_G_P:
   .word   58 
   .word   04210h,027e9h,023e8h,023e8h,01fe7h,01fe7h,01be6h,01be6h
   .word   017e5h,017e5h,013e4h,00fe3h,013e4h,00fe3h,00fe3h,00fe3h
   .word   00fe3h,00fe3h,00fe3h,00fc3h,00fa3h,00f83h,00f63h,00f43h
   .word   00f23h,00f03h,00ee3h,00ec3h,00ea3h,00e83h,00e83h,00e63h
   .word   00e63h,00e43h,00e43h,00e23h,00e23h,00e03h,00de3h,00dc3h
   .word   00da3h,00d83h,00d63h,00d43h,00d23h,00d03h,00ce3h,00cc3h
   .word   00ca3h,00c83h,00c63h,04210h,04a52h,05294h,05ef7h,06739h
   .word   07bdeh,07fffh

PLTF2_G_P:
   .word   58 
   .word   04210h,033ech,02febh,02febh,02beah,02beah,027e9h,027e9h
   .word   023e8h,023e8h,01fe7h,01be6h,01fe7h,01be6h,01be6h,01be6h
   .word   01be6h,01be6h,01be6h,01be6h,01be6h,01be6h,01bc6h,01ba6h
   .word   01b86h,01b66h,01b46h,01b26h,01b06h,01ae6h,01ae6h,01ac6h
   .word   01ac6h,01aa6h,01aa6h,01a86h,01a86h,01a66h,01a46h,01a26h
   .word   01a06h,019e6h,019c6h,019a6h,01986h,01966h,01946h,01926h
   .word   01906h,018e6h,018c6h,04e73h,056b5h,05ef7h,06b5ah,0739ch
   .word   07fffh,07fffh

PLTF3_G_P:
   .word   58 
   .word   04210h,04bf2h,047f1h,047f1h,043f0h,043f0h,03fefh,03fefh
   .word   03beeh,03beeh,037edh,033ech,037edh,033ech,033ech,033ech
   .word   033ech,033ech,033ech,033ech,033ech,033ech,033ech,033ech
   .word   033ech,033ech,033ech,033ech,033cch,033ach,033ach,0338ch
   .word   0338ch,0336ch,0336ch,0334ch,0334ch,0332ch,0330ch,032ech
   .word   032cch,032ach,0328ch,0326ch,0324ch,0322ch,0320ch,031ech
   .word   031cch,031ach,0318ch,06739h,06f7bh,077bdh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF4_G_P:
   .word   58 
   .word   04210h,063f9h,05ff8h,05ff8h,05bf7h,05bf7h,057f6h,057f6h
   .word   053f5h,053f5h,04ff4h,04bf3h,04ff4h,04bf3h,04bf3h,04bf3h
   .word   04bf3h,04bf3h,04bf3h,04bf3h,04bf3h,04bf3h,04bf3h,04bf3h
   .word   04bf3h,04bf3h,04bf3h,04bf3h,04bf3h,04bf3h,04bf3h,04bf3h
   .word   04bf3h,04bf3h,04bf3h,04bf3h,04bf3h,04bf3h,04bf3h,04bd3h
   .word   04bb3h,04b93h,04b73h,04b53h,04b33h,04b13h,04af3h,04ad3h
   .word   04ab3h,04a93h,04a73h,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF5_G_P:
   .word   58 
   .word   04210h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF1_R_P:
   .word   58 
   .word   04210h,07d28h,07d27h,07d07h,07d06h,07ce6h,07ce5h,07cc5h
   .word   07cc4h,07ca4h,07ca3h,07c82h,07c83h,07c62h,07c82h,07c62h
   .word   07c82h,07882h,07862h,07462h,07062h,06c62h,06862h,06462h
   .word   06062h,05c62h,05862h,05462h,05062h,04c62h,04c42h,04862h
   .word   04842h,04462h,04442h,04062h,04042h,03c42h,03842h,03442h
   .word   03042h,02c42h,02842h,02442h,02042h,01c42h,01842h,01442h
   .word   01042h,00c42h,00842h,03defh,04631h,04e73h,05ad6h,06318h
   .word   077bdh,07fffh

PLTF2_R_P:
   .word   58 
   .word   04210h,07d8bh,07d8ah,07d6ah,07d69h,07d49h,07d48h,07d28h
   .word   07d27h,07d07h,07d06h,07ce5h,07ce6h,07cc5h,07ce5h,07cc5h
   .word   07ce5h,07ce5h,07cc5h,07cc5h,07cc5h,078c5h,074c5h,070c5h
   .word   06cc5h,068c5h,064c5h,060c5h,05cc5h,058c5h,058a5h,054c5h
   .word   054a5h,050c5h,050a5h,04cc5h,04ca5h,048a5h,044a5h,040a5h
   .word   03ca5h,038a5h,034a5h,030a5h,02ca5h,028a5h,024a5h,020a5h
   .word   01ca5h,018a5h,014a5h,04a52h,05294h,05ad6h,06739h,06f7bh
   .word   07fffh,07fffh

PLTF3_R_P:
   .word   58 
   .word   04210h,07e72h,07e71h,07e51h,07e50h,07e30h,07e2fh,07e0fh
   .word   07e0eh,07deeh,07dedh,07dcch,07dcdh,07dach,07dcch,07dach
   .word   07dcch,07dcch,07dach,07dach,07dach,07dach,07dach,07dach
   .word   07dach,07dach,07dach,07dach,079ach,075ach,0758ch,071ach
   .word   0718ch,06dach,06d8ch,069ach,0698ch,0658ch,0618ch,05d8ch
   .word   0598ch,0558ch,0518ch,04d8ch,0498ch,0458ch,0418ch,03d8ch
   .word   0398ch,0358ch,0318ch,06739h,06f7bh,077bdh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF4_R_P:
   .word   58 
   .word   04210h,07fbch,07fbbh,07f9bh,07f9ah,07f7ah,07f79h,07f59h
   .word   07f58h,07f38h,07f37h,07f16h,07f17h,07ef6h,07f16h,07ef6h
   .word   07f16h,07f16h,07ef6h,07ef6h,07ef6h,07ef6h,07ef6h,07ef6h
   .word   07ef6h,07ef6h,07ef6h,07ef6h,07ef6h,07ef6h,07ed6h,07ef6h
   .word   07ed6h,07ef6h,07ed6h,07ef6h,07ed6h,07ed6h,07ed6h,07ed6h
   .word   07ed6h,07ed6h,07ad6h,076d6h,072d6h,06ed6h,06ad6h,066d6h
   .word   062d6h,05ed6h,05ad6h,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh

PLTF5_R_P:
   .word   58 
   .word   04210h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh




SQDFB1_P:
   .word   63 
   .word   039ach,07a1eh,075ddh,071bch,06d7bh,0655ah,06139h,05d18h
   .word   058d7h,054b6h,05095h,04c94h,04873h,04452h,04031h,03c30h
   .word   0382fh,0342eh,0302ch,02c2bh,0242ah,02028h,01c27h,01426h
   .word   01024h,00c23h,00822h,04e7fh,03dffh,0319fh,0211fh,0109fh
   .word   0043fh,0043fh,0043dh,0043bh,0043ah,00438h,00437h,00435h
   .word   00434h,00432h,00431h,0042fh,0042eh,0042ch,0042bh,07fe1h
   .word   07fe1h,07bc1h,077a1h,07381h,06f61h,06b41h,06301h,05ee1h
   .word   05ac1h,056a1h,05281h,04a41h,04201h,039c1h,02521h


SQDFB2_P:
   .word   63 
   .word   039ach,07e5fh,07e1fh,079feh,075bdh,06d9ch,0697bh,0655ah
   .word   06119h,05cf8h,058d7h,054d6h,050b5h,04c94h,04873h,04472h
   .word   04071h,03c70h,0386eh,0346dh,02c6ch,0286ah,02469h,01c68h
   .word   01866h,01465h,01064h,056bfh,0463fh,039dfh,0295fh,018dfh
   .word   00c7fh,00c7fh,00c7fh,00c7dh,00c7ch,00c7ah,00c79h,00c77h
   .word   00c76h,00c74h,00c73h,00c71h,00c70h,00c6eh,00c6dh,07fe3h
   .word   07fe3h,07fe3h,07fe3h,07bc3h,077a3h,07383h,06b43h,06723h
   .word   06303h,05ee3h,05ac3h,05283h,04a43h,04203h,02d63h

SQDFB3_P:
   .word   63 
   .word   039ach,07ebfh,07e7fh,07e5fh,07e1fh,079ffh,075deh,071bdh
   .word   06d7ch,0695bh,0653ah,06139h,05d18h,058f7h,054d6h,050d5h
   .word   04cd4h,048d3h,044d1h,040d0h,038cfh,034cdh,030cch,028cbh
   .word   024c9h,020c8h,01cc7h,0631fh,0529fh,0463fh,035bfh,0253fh
   .word   018dfh,018dfh,018dfh,018dfh,018dfh,018ddh,018dch,018dah
   .word   018d9h,018d7h,018d6h,018d4h,018d3h,018d1h,018d0h,07fe6h
   .word   07fe6h,07fe6h,07fe6h,07fe6h,07fe6h,07fe6h,077a6h,07386h
   .word   06f66h,06b46h,06726h,05ee6h,056a6h,04e66h,039c6h


SQDFB4_P:
   .word   63 
   .word   039ach,07f3fh,07effh,07edfh,07e9fh,07e7fh,07e5fh,07e3fh
   .word   07dffh,079dfh,075beh,071bdh,06d9ch,0697bh,0655ah,06159h
   .word   05d58h,05957h,05555h,05154h,04953h,04551h,04150h,0394fh
   .word   0354dh,0314ch,02d4bh,0739fh,0631fh,056bfh,0463fh,035bfh
   .word   0295fh,0295fh,0295fh,0295fh,0295fh,0295fh,0295fh,0295eh
   .word   0295dh,0295bh,0295ah,02958h,02957h,02955h,02954h,07feah
   .word   07feah,07feah,07feah,07feah,07feah,07feah,07feah,07feah
   .word   07feah,07bcah,077aah,06f6ah,0672ah,05eeah,04a4ah

SQDFB5_P:
   .word   63 
   .word   039ach,07fffh,07fbfh,07f9fh,07f5fh,07f3fh,07f1fh,07effh
   .word   07ebfh,07e9fh,07e7fh,07e7fh,07e5fh,07e3fh,07e1fh,07a1fh
   .word   0761eh,0721dh,06e1bh,06a1ah,06219h,05e17h,05a16h,05215h
   .word   04e13h,04a12h,04611h,07fffh,07bdfh,06f7fh,05effh,04e7fh
   .word   0421fh,0421fh,0421fh,0421fh,0421fh,0421fh,0421fh,0421fh
   .word   0421fh,0421fh,0421fh,0421eh,0421dh,0421bh,0421ah,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,077b0h,06310h

SQDFB6_P:
   .word   63 
   .word   039ach,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fbfh,07f9fh,07f7fh,07f7fh,07f5fh,07f3fh,07f1fh,07f1fh
   .word   07f1fh,07f1fh,07f1fh,07f1fh,07f1fh,07f1fh,07b1eh,0731dh
   .word   06f1bh,06b1ah,06719h,07fffh,07fffh,07fffh,07fffh,06f7fh
   .word   0631fh,0631fh,0631fh,0631fh,0631fh,0631fh,0631fh,0631fh
   .word   0631fh,0631fh,0631fh,0631fh,0631fh,0631fh,0631fh,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h

SQDFB7_P:
   .word   63 
   .word   039ach,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh


SQDFR1_P:
   .word   63 
   .word   039ach,07a1eh,075ddh,071bch,06d7bh,0655ah,06139h,05d18h
   .word   058d7h,054b6h,05095h,04c94h,04873h,04452h,04031h,03c30h
   .word   0382fh,0342eh,0302ch,02c2bh,0242ah,02028h,01c27h,01426h
   .word   01024h,00c23h,00822h,07e73h,07defh,07d8ch,07d08h,07c84h
   .word   07c21h,07821h,07021h,06821h,06021h,05821h,05021h,04c21h
   .word   04421h,03c21h,03421h,02c21h,02421h,01c21h,01421h,07fe1h
   .word   07fe1h,07bc1h,077a1h,07381h,06f61h,06b41h,06301h,05ee1h
   .word   05ac1h,056a1h,05281h,04a41h,04201h,039c1h,02521h

SQDFR2_P:
   .word   63 
   .word   039ach,07e5fh,07e1fh,079feh,075bdh,06d9ch,0697bh,0655ah
   .word   06119h,05cf8h,058d7h,054d6h,050b5h,04c94h,04873h,04472h
   .word   04071h,03c70h,0386eh,0346dh,02c6ch,0286ah,02469h,01c68h
   .word   01866h,01465h,01064h,07eb5h,07e31h,07dceh,07d4ah,07cc6h
   .word   07c63h,07c63h,07863h,07063h,06863h,06063h,05863h,05463h
   .word   04c63h,04463h,03c63h,03463h,02c63h,02463h,01c63h,07fe3h
   .word   07fe3h,07fe3h,07fe3h,07bc3h,077a3h,07383h,06b43h,06723h
   .word   06303h,05ee3h,05ac3h,05283h,04a43h,04203h,02d63h

SQDFR3_P:
   .word   63 
   .word   039ach,07ebfh,07e7fh,07e5fh,07e1fh,079ffh,075deh,071bdh
   .word   06d7ch,0695bh,0653ah,06139h,05d18h,058f7h,054d6h,050d5h
   .word   04cd4h,048d3h,044d1h,040d0h,038cfh,034cdh,030cch,028cbh
   .word   024c9h,020c8h,01cc7h,07f18h,07e94h,07e31h,07dadh,07d29h
   .word   07cc6h,07cc6h,07cc6h,07cc6h,074c6h,06cc6h,064c6h,060c6h
   .word   058c6h,050c6h,048c6h,040c6h,038c6h,030c6h,028c6h,07fe6h
   .word   07fe6h,07fe6h,07fe6h,07fe6h,07fe6h,07fe6h,077a6h,07386h
   .word   06f66h,06b46h,06726h,05ee6h,056a6h,04e66h,039c6h

SQDFR4_P:
   .word   63 
   .word   039ach,07f3fh,07effh,07edfh,07e9fh,07e7fh,07e5fh,07e3fh
   .word   07dffh,079dfh,075beh,071bdh,06d9ch,0697bh,0655ah,06159h
   .word   05d58h,05957h,05555h,05154h,04953h,04551h,04150h,0394fh
   .word   0354dh,0314ch,02d4bh,07f9ch,07f18h,07eb5h,07e31h,07dadh
   .word   07d4ah,07d4ah,07d4ah,07d4ah,07d4ah,07d4ah,0754ah,0714ah
   .word   0694ah,0614ah,0594ah,0514ah,0494ah,0414ah,0394ah,07feah
   .word   07feah,07feah,07feah,07feah,07feah,07feah,07feah,07feah
   .word   07feah,07bcah,077aah,06f6ah,0672ah,05eeah,04a4ah

SQDFR5_P:
   .word   63 
   .word   039ach,07fffh,07fbfh,07f9fh,07f5fh,07f3fh,07f1fh,07effh
   .word   07ebfh,07e9fh,07e7fh,07e7fh,07e5fh,07e3fh,07e1fh,07a1fh
   .word   0761eh,0721dh,06e1bh,06a1ah,06219h,05e17h,05a16h,05215h
   .word   04e13h,04a12h,04611h,07fffh,07fdeh,07f7bh,07ef7h,07e73h
   .word   07e10h,07e10h,07e10h,07e10h,07e10h,07e10h,07e10h,07e10h
   .word   07e10h,07a10h,07210h,06a10h,06210h,05a10h,05210h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,077b0h,06310h

SQDFR6_P:
   .word   63 
   .word   039ach,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fbfh,07f9fh,07f7fh,07f7fh,07f5fh,07f3fh,07f1fh,07f1fh
   .word   07f1fh,07f1fh,07f1fh,07f1fh,07f1fh,07f1fh,07b1eh,0731dh
   .word   06f1bh,06b1ah,06719h,07fffh,07fffh,07fffh,07fffh,07f7bh
   .word   07f18h,07f18h,07f18h,07f18h,07f18h,07f18h,07f18h,07f18h
   .word   07f18h,07f18h,07f18h,07f18h,07f18h,07b18h,07318h,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h

SQDFR7_P:
   .word   63 
   .word   039ach,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh


CODE_G_P:
   .word   64 
   .word   00000h,07fffh,06f7bh,06b5ah,05ef7h,05ad6h,056b5h,04e73h
   .word   04a52h,04631h,04210h,039ceh,035adh,0318ch,02d6bh,0294ah
   .word   02949h,0254ah,0292ah,02529h,02528h,02129h,02508h,02108h
   .word   01ce8h,01ce7h,018c6h,018c5h,014a5h,014a4h,01484h,01085h
   .word   01084h,00c63h,00000h,00320h,00300h,002e0h,002c0h,002c0h
   .word   002a0h,00280h,00280h,00260h,00240h,00220h,00220h,00200h
   .word   001e0h,001c0h,001c0h,001a0h,00180h,00160h,00160h,00140h
   .word   00120h,00100h,000e0h,000e0h,000c0h,000a0h,00080h,00060h

CODE_R_P:
   .word   64 
   .word   00000h,07fffh,06f7bh,06b5ah,05ef7h,05ad6h,056b5h,04e73h
   .word   04a52h,04631h,04210h,039ceh,035adh,0318ch,02d6bh,0294ah
   .word   02949h,0254ah,0292ah,02529h,02528h,02129h,02508h,02108h
   .word   01ce8h,01ce7h,018c6h,018c5h,014a5h,014a4h,01484h,01085h
   .word   01084h,00c63h,00000h,06800h,06400h,06000h,06000h,05c00h
   .word   05800h,05400h,05000h,04c00h,04c00h,04800h,04400h,04000h
   .word   03c00h,03c00h,03800h,03400h,03000h,03000h,02c00h,02800h
   .word   02400h,02400h,02000h,01c00h,01800h,01800h,01400h,01000h

CODE_Y_P:
   .word   64 
   .word   00000h,07fffh,06f7bh,06b5ah,05ef7h,05ad6h,056b5h,04e73h
   .word   04a52h,04631h,04210h,039ceh,035adh,0318ch,02d6bh,0294ah
   .word   02949h,0254ah,0292ah,02529h,02528h,02129h,02508h,02108h
   .word   01ce8h,01ce7h,018c6h,018c5h,014a5h,014a4h,01484h,01085h
   .word   01084h,00c63h,00000h,06720h,06300h,06300h,05ee0h,05ac0h
   .word   05ac0h,056a0h,05280h,04e60h,04e60h,04a40h,04620h,04620h
   .word   041e0h,03dc0h,039a0h,03580h,03160h,02d40h,02920h,02900h
   .word   024e0h,020c0h,01ca0h,018a0h,01880h,01460h,01060h,01040h


TUBE_O_P:
   .word   127
   .word   00000h,07f41h,07f20h,07ec0h,07ec0h,07ea0h,07ea0h,07ea0h
   .word   07e80h,07e80h,07e80h,07e60h,07e60h,07e60h,07e60h,07e40h
   .word   07e60h,07e40h,07e20h,07e20h,07e20h,07e20h,07e00h,07e00h
   .word   07e00h,07de0h,07de0h,07dc0h,07dc0h,07de0h,07dc0h,07dc0h
   .word   07dc0h,079c0h,079c0h,07dc0h,079c0h,079c0h,079c0h,075a0h
   .word   075a0h,079c0h,071a0h,075a0h,071a0h,071a0h,075a0h,071a0h
   .word   071a0h,06d80h,06d80h,071a0h,06d80h,06d80h,06980h,06980h
   .word   06560h,06980h,06560h,06560h,06560h,06160h,06160h,06160h
   .word   06160h,05d40h,05d40h,05d40h,05d40h,05940h,05d40h,05520h
   .word   05520h,05940h,05520h,05520h,05940h,05120h,05520h,05120h
   .word   05520h,05120h,05120h,04d00h,04d00h,04d00h,04900h,04900h
   .word   04900h,044e0h,044e0h,044e0h,044e0h,040e0h,040e0h,040e0h
   .word   03cc0h,03cc0h,038c0h,034a0h,038c0h,034a0h,034a0h,030a0h
   .word   034a0h,034a0h,030a0h,02c80h,030a0h,02c80h,030a0h,02c80h
   .word   02880h,02c80h,02460h,02880h,02880h,02460h,02460h,02060h
   .word   02060h,02060h,02060h,01c40h,01840h,01420h,01020h

TUBE_R_P:
   .word   127
   .word   0294ah,07ed5h,07e72h,079eeh,075eeh,07dabh,075cdh,079ach
   .word   07d69h,0798bh,0758bh,0718bh,0756ah,07949h,07948h,07548h
   .word   07928h,07927h,07106h,078c5h,06d07h,070e6h,06907h,06ce6h
   .word   06cc5h,07482h,060e6h,05ce6h,060c5h,07062h,06c82h,07061h
   .word   06883h,05cc5h,06882h,07041h,06c61h,06483h,06862h,06482h
   .word   06861h,06c41h,054c5h,06462h,06082h,06461h,06841h,054a5h
   .word   06062h,054a4h,06061h,06441h,05c62h,06041h,05c61h,05862h
   .word   04ca4h,05c41h,05861h,05462h,05841h,05461h,04c83h,05062h
   .word   05441h,05061h,04484h,05041h,04c42h,04c41h,05021h,04861h
   .word   04083h,04842h,04462h,04841h,04c21h,03c83h,04442h,04441h
   .word   04821h,04042h,04421h,04041h,03c42h,04021h,03c41h,03842h
   .word   03c21h,03841h,03063h,03442h,03821h,03441h,03042h,03421h
   .word   02863h,03021h,02c41h,02462h,02c21h,02841h,02822h,02423h
   .word   02442h,02821h,02441h,02023h,02042h,02041h,02421h,01c42h
   .word   01c41h,02021h,01823h,01842h,01c21h,01442h,01821h,01441h
   .word   01422h,01042h,01421h,01021h,00c21h,00821h,00421h


TUBE_Y_P:
   .word   127
   .word   00000h,07fe0h,07fc0h,07fa0h,07f80h,07f80h,07f80h,07f80h
   .word   07f60h,07f80h,07f60h,07f60h,07f60h,07f60h,07f60h,07f60h
   .word   07f60h,07f60h,07f40h,07f40h,07f40h,07f40h,07f20h,07f20h
   .word   07f20h,07f20h,07f00h,07ee0h,07ee0h,07f00h,07ee0h,07ee0h
   .word   07ee0h,07ee0h,07ee0h,07ee0h,07ee0h,07ee0h,07ee0h,07ac0h
   .word   07ac0h,07ee0h,076a0h,07ac0h,076a0h,076a0h,07ac0h,076a0h
   .word   076a0h,07280h,07280h,076a0h,07280h,07280h,06e80h,06e80h
   .word   06a60h,06e80h,06a60h,06a60h,06a60h,06640h,06640h,06640h
   .word   06640h,06220h,06220h,06220h,06220h,05e20h,06220h,05a00h
   .word   05a00h,05e20h,05a00h,05a00h,05e20h,055e0h,05a00h,055e0h
   .word   05a00h,055e0h,055e0h,051c0h,051c0h,051c0h,04da0h,04da0h
   .word   04da0h,049a0h,049a0h,049a0h,049a0h,04580h,04580h,04580h
   .word   04160h,04160h,03d60h,03940h,03d60h,03940h,03940h,03520h
   .word   03940h,03940h,03520h,03100h,03520h,03100h,03520h,03100h
   .word   02ce0h,03100h,028e0h,02ce0h,02ce0h,028e0h,028e0h,024c0h
   .word   024c0h,024c0h,024c0h,020a0h,01c80h,01880h,01460h


TUBE_G_P:
   .word   127
   .word   00000h,063d4h,05bd1h,04bcch,04bcbh,047cah,047cah,047cah
   .word   043c8h,043c9h,043c8h,03fc7h,03fc7h,03fc7h,03bc6h,03bc5h
   .word   03bc6h,03bc5h,033c2h,033c3h,02fc1h,033c2h,02fc1h,02fc1h
   .word   02bc1h,02bc1h,027a1h,02781h,02781h,027a1h,02781h,02781h
   .word   02781h,02361h,02361h,02781h,02361h,02361h,02361h,02341h
   .word   02341h,02361h,02321h,02341h,02321h,02321h,02341h,02321h
   .word   02321h,01f01h,01f01h,02321h,01f01h,01f01h,01ee1h,01ee1h
   .word   01ec1h,01ee1h,01ec1h,01ec1h,01ec1h,01aa1h,01aa1h,01aa1h
   .word   01aa1h,01a81h,01a81h,01a81h,01a81h,01a61h,01a81h,01641h
   .word   01641h,01a61h,01641h,01641h,01a61h,01621h,01641h,01621h
   .word   01641h,01621h,01621h,01601h,01601h,01601h,011e1h,011e1h
   .word   011e1h,011c1h,011c1h,011c1h,011c1h,00da1h,00da1h,00da1h
   .word   00d81h,00d81h,00d61h,00941h,00d61h,00941h,00941h,00921h
   .word   00941h,00941h,00921h,00901h,00921h,00901h,00921h,00901h
   .word   004e1h,00901h,004c1h,004e1h,004e1h,004c1h,004c1h,004a1h
   .word   004a1h,004a1h,004a1h,00481h,00461h,00441h,00421h




LOGOB_P:
   .word   30 
   .word   00000h,018dfh,00cbfh,00c9fh,0001fh,0001eh,0001ch,0001bh
   .word   0001ah,00019h,00018h,00017h,00016h,00015h,00014h,00013h
   .word   00012h,00011h,00010h,0000fh,0000eh,0000dh,0000ch,0000bh
   .word   0000ah,00009h,00008h,00007h,00006h,00005h


substutn_dirs_str_setup
	PRINT_STR	bast8t_ascii,4,0,200,50,BAST_W_P,0

substutn_dirs_strs
	.string	"PRESS TURBO TO SWAP",1
	.string	"PRESS SHOOT TO SELECT",0
	.even


subsitution_str_setup
	PRINT_STR	brush20_ascii,4,0,200,7,BRSHGYOP,0

subsitution_str
	.string	"SUBSTITUTIONS",0
	.even


create_plr_info_setup
	PRINT_STR	bast8t_ascii,4,0,BALL1X+52,BALL1Y-34,BAST_W_P,0
create_plr_info_setup2
	PRINT_STR	bast8t_ascii,4,0,BALL1X+52,BALL1Y-24,BAST_W_P,0

create_plr_info
	.string	"THIS OPTION INVOLVES",1
	.string	"NO GAME PLAY.",1
	.string	"ARE YOU SURE ?",0
	.even

HEADB_P:
   .word   27 
   .word   00000h,0001bh,0001ch,0001dh,0001eh,00018h,00019h,0001ah
   .word   00016h,00017h,00015h,00014h,00013h,00011h,00012h,00010h
   .word   0000fh,0000eh,0000dh,0000ch,0000bh,0000ah,00009h,00008h
   .word   00007h,00006h,00005h

HEADR_P:
   .word   27 
   .word   00000h,06c00h,07000h,07400h,07800h,06000h,06400h,06800h
   .word   05800h,05c00h,05400h,05000h,04c00h,04400h,04800h,04000h
   .word   03c00h,03800h,03400h,03000h,02c00h,02800h,02400h,02000h
   .word   01c00h,01800h,01400h


;
; This table contains the RAM ptrs. for the TEXT on the balls
;
bball_text_obj_ptrs
	.long	bball_1_text_obj_ptr
	.long	bball_2_text_obj_ptr
	.long	bball_3_text_obj_ptr
bball_text_obj_ptrs_end

;
; This table contains:
; 
;  1) ram location to save obj ptr
;  2) img ptr
;  3) X coor.
;  4) Y coor.
;
bball_text_img_setup
	.long	bball_1_text_obj_ptr,FNT_CRE,[BALL1X+46,0],[BALL1Y+40,0]
	.long	bball_2_text_obj_ptr,FNT_ENT,[BALL2X+47,0],[BALL2Y+40,0]
	.long	bball_3_text_obj_ptr,FNT_SEL,[BALL3X+47,0],[BALL3Y+40,0]
bball_text_img_setup_end


BIGBLD_P:
   .word   196
   .word   00000h,04210h,00c20h,00820h,00400h,00000h,00800h,00c20h
   .word   01020h,00800h,00400h,00c00h,00820h,01020h,01020h,01420h
   .word   00c01h,01020h,00c00h,01820h,01c20h,01c40h,01c40h,02040h
   .word   01441h,00421h,01820h,02040h,02040h,02040h,01840h,01420h
   .word   00421h,02440h,01840h,01041h,00421h,00c41h,00801h,00802h
   .word   00802h,01844h,03061h,03c80h,03460h,01441h,01841h,03860h
   .word   03881h,018c6h,02041h,03880h,03881h,03c81h,03ca1h,03ca2h
   .word   040a2h,040e3h,040c2h,04104h,040e4h,04105h,034a2h,034c4h
   .word   02ca4h,020a3h,01084h,01064h,00c43h,01441h,02c61h,03480h
   .word   03481h,03060h,03060h,02c60h,02c60h,02840h,01043h,02c60h
   .word   02860h,03460h,030c4h,02861h,03480h,03881h,040c3h,03cc3h
   .word   03ca2h,02ca2h,01c62h,01063h,00842h,02c61h,03061h,03061h
   .word   02441h,01861h,01440h,028e5h,02c81h,01c62h,00841h,00821h
   .word   03081h,01444h,02860h,028e6h,03481h,00c42h,00421h,00821h
   .word   03081h,02c61h,02841h,01841h,01421h,024c5h,03cc3h,03081h
   .word   01441h,01043h,03481h,02461h,020c5h,02460h,02440h,02c40h
   .word   02881h,02461h,02840h,02461h,02861h,02440h,01c41h,00420h
   .word   00c21h,01c44h,02043h,03461h,03461h,02441h,01c41h,01844h
   .word   01064h,04080h,04080h,028a2h,02882h,02861h,02461h,01c62h
   .word   02041h,024a3h,02083h,03481h,01444h,02c82h,01ca4h,01841h
   .word   00c44h,038c3h,01c84h,040a1h,01c63h,034e4h,01883h,04081h
   .word   040a0h,038c3h,02907h,01884h,01065h,03506h,01ce6h,040a1h
   .word   02062h,02460h,01463h,020e7h,01462h,00c42h,02061h,01862h
   .word   030c4h,04105h,02841h,01ce6h,01cc5h,018c6h,014a4h,024a4h
   .word   01ce7h,030e5h,024e7h,03505h




pressed_bball_xys
	.long	[BALL1X+3,0],[BALL1Y+2,0]
	.long	[BALL2X+3,0],[BALL2Y+2,0]
	.long	[BALL3X+3,0],[BALL3Y+2,0]


pressed_bball_shadw_tbl
	.long	[BALL1X-5,0],[BALL1Y-5,0],SMBALSA1,SMBALSA2
	.long	[BALL2X-5,0],[BALL2Y-5,0],SMBALSB1,SMBALSB2
	.long	[BALL3X-5,0],[BALL3Y-5,0],SMBALSC1,SMBALSC2


;
; This table contains:
; 	1) X of SPOTLIGHT
; 	2) Y pf SPOTLIGHT
; 	3) Table addr. of image table ptr.
;
sptlght_img_tbl_ptr_tbl
 .long	[BALL1X-14,0],[0,0],spotlight_1_imgs
 .long	[BALL2X-18,0],[0,0],spotlight_2_imgs
 .long	[BALL3X-14,0],[0,0],spotlight_3_imgs

;
; This table contains:
; 	4) X of ball SHADOW
; 	5) Y of ball SHADOW
; 	6) Table addr. of image table ptr.
;
sptlght_bball_shadw_img_tbl
 .long	[BALL1X-6,0],[BALL1Y+47,0],bball_1_shadow_imgs
 .long	[BALL2X-6,0],[BALL2Y+47,0],bball_2_shadow_imgs
 .long	[BALL3X-6,0],[BALL3Y+47,0],bball_3_shadow_imgs


spotlight_1_imgs
	.long	SPOTLTA1
	.long	SPOTLTA2
	.long	SPOTLTA3
	.long	SPOTLTA4
	.long	SPOTLTA5

bball_1_shadow_imgs
	.long	BGBALSA1,BGBALSA2


spotlight_2_imgs
	.long	SPOTLTB1
	.long	SPOTLTB2
	.long	SPOTLTB3
	.long	SPOTLTB4
	.long	SPOTLTB5

bball_2_shadow_imgs
	.long	BGBALSB1,BGBALSB2


spotlight_3_imgs
	.long	SPOTLTC1
	.long	SPOTLTC2
	.long	SPOTLTC3
	.long	SPOTLTC4
	.long	SPOTLTC5

bball_3_shadow_imgs
	.long	BGBALSC1,BGBALSC2



opt_str_setup
	PRINT_STR	brush20_ascii,10,0,199,7,BRSHGYOP,0
;	PRINT_STR	brush20_ascii,10,0,199,5,BRSHGYO_P,0

option_strings
	.string	"choose option",0
	.even

;;the real version will have two tables...one with all three options and one
;; with only two options
;;plate_xys			;create plyr, select teams, and enter inits.
;	.word	OPT_PLATE_LX,OPT_PLATE_CX,OPT_PLATE_RX
;plate_xys2			;select teams and enter initials
;	.word	135,250

******************************************************************************
	.end

