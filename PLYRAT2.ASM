**************************************************************
*
* Owner:	TURMELL
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		11/20/92
*
* Modified:		Shawn Liptak, 12/?/92	-Split from plyrat.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/24/93 16:20
**************************************************************
	.file	"plyrat2.asm"
	.title	"basketball player code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"macros.hdr"		;Macros
	.include	"imgtbl.glo"
	.include        "plyrhd.glo"
	.asg		0,SEQT
	.include	"plyr.equ"
	.include	"game.equ"		;Display proc equates
	.include	"imgtblp.glo"
	.include	"plyrhd6a.tbl"
	.include	"plyrhd6a.glo"

	.def	OFFNBA

;sounds external


;symbols externally defined

	.ref	team1,team2,OFFNBA_P
	.ref	special_heads,spechds_t
	.ref	ATL_t,name_sort,player_names
	.ref	tm1set,tm2set
	.ref	attrib1_obj,attrib2_obj
	.ref	attrib3_obj,attrib4_obj

	.ref	BV,BV1,BV2,BV3,BV4,BV5,BV6,BV7,BV8,BV9,BV10
	.ref	SHT0,SHT1,SHT2,SHT3,SHT4,SHT5,SHT6,SHT7,SHT8,SHT9,SHT10,SHT11
	.ref	DNK0,DNK1,DNK2,DNK3,DNK4,DNK5,DNK6,DNK7,DNK8,DNK9,DNK10
	.ref	DEF0,DEF1,DEF2,DEF3,DEF4,DEF5,DEF6,DEF7,DEF8,DEF9,DEF10
	.ref	SDEF0,SDEF1,SDEF2,SDEF3,SDEF4,SDEF5,SDEF6,SDEF7,SDEF8,SDEF9,SDEF10

	.ref	scale57_t,scale57et_t,scale57t_t,scale57f_t,scale57ef_t
	.ref	scale58_t,scale58et_t,scale58t_t,scale58f_t,scale58ef_t
	.ref	scale59_t,scale59et_t,scale59t_t,scale59f_t,scale59ef_t
	.ref	scale510_t,scale510et_t,scale510t_t,scale510f_t,scale510ef_t
	.ref	scale511_t,scale511et_t,scale511t_t,scale511f_t,scale511ef_t
	.ref	scale60_t,scale60et_t,scale60t_t,scale60f_t,scale60ef_t
	.ref	scale61_t,scale61et_t,scale61t_t,scale61f_t,scale61ef_t
	.ref	scale62_t,scale62et_t,scale62t_t,scale62f_t,scale62ef_t
	.ref	scale63_t,scale63et_t,scale63t_t,scale63f_t,scale63ef_t
	.ref	scale64_t,scale64et_t,scale64t_t,scale64f_t,scale64ef_t
	.ref	scale65_t,scale65et_t,scale65t_t,scale65f_t,scale65ef_t
	.ref	scale66_t,scale66et_t,scale66t_t,scale66f_t,scale66ef_t
	.ref	scale67_t,scale67et_t,scale67t_t,scale67f_t,scale67ef_t
	.ref	scale68_t,scale68et_t,scale68t_t,scale68f_t,scale68ef_t
	.ref	scale69_t,scale69et_t,scale69t_t,scale69f_t,scale69ef_t
	.ref	scale610_t,scale610et_t,scale610t_t,scale610f_t,scale610ef_t
	.ref	scale611_t,scale611et_t,scale611t_t,scale611f_t,scale611ef_t
	.ref	scale70_t,scale70et_t,scale70t_t,scale70f_t,scale70ef_t
	.ref	scale71_t,scale71et_t,scale71t_t,scale71f_t,scale71ef_t
	.ref	scale72_t,scale72et_t,scale72t_t,scale72f_t,scale72ef_t
	.ref	scale73_t,scale73et_t,scale73t_t,scale73f_t,scale73ef_t
	.ref	scale74_t,scale74et_t,scale74t_t,scale74f_t,scale74ef_t
	.ref	scale75_t,scale75et_t,scale75t_t,scale75f_t,scale75ef_t
	.ref	scale76_t,scale76et_t,scale76t_t,scale76f_t,scale76ef_t

	.ref	Brown_h
	.ref	player1_data,player2_data,player3_data,player4_data
	.ref	ply_city_tbl
	.ref	plr_heads_small
	.ref	body_scale_table
	.ref	plr_flesh_pal_tbl
;symbols defined in this file

	.def	setup_created_plyr_attrib_tbl

	.def	Laetner_h
	.def	Hawkins_h
	.def	LJohnson_h
	.def	Divac_h
	.def	KMalone_h
	.def	Stockton_h
	.def	Ewing_h
	.def	Seikaly_h
	.def	Miller_h
	.def	Mutumbo_h
	.def	Oakley_h
	.def	Olajuwon_h
	.def	Rice_h
	.def	DRobinson_h
	.def	Schrempf_h
	.def	Smith_h
	.def	Tisdale_h
	.def	Kemp_h
	.def	Pippen_h
	.def	Gill_h
	.def	Mullin_h
	.def	Person_h
	.def	Augmon_h
	.def	Benjamin_h
	.def	Coleman_h
	.def	Drexler_h
	.def	Elliot_h
	.def	Hardaway_h
	.def	HCGrant_h
	.def	Hornacek_h
	.def	Manning_h

;	.def	created_plyr1_attrib_tables
;	.def	created_plyr2_attrib_tables
;	.def	created_plyr3_attrib_tables
;	.def	created_plyr4_attrib_tables
	.ref	created_plyr1_attrib_tables
	.ref	created_plyr2_attrib_tables
	.ref	created_plyr3_attrib_tables
	.ref	created_plyr4_attrib_tables

;uninitialized ram definitions

	.ref	PLYRAT_TBL_SIZE
;	.bss	created_plyr1_attrib_tables,PLYRAT_TBL_SIZE   ;sizeof ATL_t in plyrat.asm
;	.bss	created_plyr2_attrib_tables,PLYRAT_TBL_SIZE
;	.bss	created_plyr3_attrib_tables,PLYRAT_TBL_SIZE
;	.bss	created_plyr4_attrib_tables,PLYRAT_TBL_SIZE

;equates for this file

	.text

;deleted alot of .asg's
;-----------------------------------------------------------------------------
;  This routine is called to setup the players attribute table if this 
;   player is playing with a CREATED CHARACTER, the values are read from the
;   players record.
;
; called from SELECT.ASM ('player_cursor' process)
; 
; INPUT:  a8 = player number
;        a13 = *Plyr process
;
; RETURNS: carry clear, if created player ram table setup
;	   a10 - ptr. to attribute ram area
;-----------------------------------------------------------------------------
 SUBR	setup_created_plyr_attrib_tbl

	PUSH	a7
	move	a8,a14
	sll	5,a14
	addi	plyr_data_ptr_table,a14,L
	move	*a14,a0,L

	move	*a0(PR_CREATED_PLYR),a14	;player 'created' ?
	jrle	mpat_9				;br=nope...

;get addr. of players attribute table array
	move	a8,a1
	sll	5,a1
	addi	created_plyr_attrib_ptr_table,a1
	move	*a1,a1,L			;ptr. to 'created' plyr. attrib. tbl

;figure out SCALE for players body
	
	move	*a0(PR_HEIGHT_PTS),a2		;0-10 (which LINE in table)
	sll	5,a2
	addi	body_scale_table,a2,L
	move	*a2,a2,L			;get scale table ptr.
	move	*a0(PR_WEIGHT_PTS),a14		;0-10 (which LINE in table)
	srl	1,a14				;divide by 2 (0,2,4,6,8 valid)
	sll	5,a14
	add	a14,a2
	move	*a2,a3,L			;get scale factor table ptr.
	move	a3,*a1(PAT_SCL_p),L		;1st element is scale ptr
;speed
	move	*a0(PR_SPEED_PTS),a2		;0-10  (BV?)
	sll	4,a2				;get offset for table
	addi	speed_table,a2,L
	move	*a2,a2
	move	a2,*a1(PAT_BVEL)		;write data to array

;shot %
	move	*a0(PR_SHOOT_PTS),a2		;0-10  (BV?)
	sll	4,a2				;get offset for table
	addi	shot_percent_table,a2,L
	move	*a2,a2
	move	a2,*a1(PAT_SHOTSKILL)		;write data to array

;dunk
	move	*a0(PR_DUNKS_PTS),a2		;0-10  (DNK?)
	sll	4,a2				;get offset for table
	addi	dunk_ability_table,a2,L
	move	*a2,a2
	move	a2,*a1(PAT_DUNKSKILL)		;write data to array

;block 
	move	*a0(PR_BLOCKS_PTS),a2		;0-10
	sll	4,a2				;get offset for table
	addi	block_ability_table,a2,L
	move	*a2,a2
	move	a2,*a1(PAT_DEFSKILL)		;write data to array

;steal
	move	*a0(PR_STEAL_PTS),a2		;0-10
	sll	4,a2				;get offset for table
	addi	steal_ability_table,a2,L
	move	*a2,a2
	move	a2,*a1(PAT_STLSKILL)		;write data to array

;drone skill
	movk	3,a2
	move	a2,*a1(PAT_SKILL)		;write data to array

	move	*a0(PR_UNIFORM_NBR),a7
	andni	40h,a7				;clr HOME team bit
	sll	5,a7
	addi	ply_city_tbl,a7,L
	move	*a7,a7,L

;body flesh palette ptr.

	move	*a0(PR_HEAD_NBR),a2
;	addi	MIDDLE_HEAD,a2
	sll	5,a2
	addi	plr_flesh_pal_tbl,a2,L
	move	*a2,a2,L
;;	move	*a7(PAT_PALF_p),a2,L	;Copy flesh
	move	a2,*a1(PAT_PALF_p),L

;body uniform 1 palette ptr.
	move	*a7(PAT_PALU_p),a2,L
	move	a2,*a1(PAT_PALU_p),L

;body uniform 2 palette ptr.
	move	*a7(PAT_PALU2_p),a2,L
	move	a2,*a1(PAT_PALU2_p),L

;body trim 1 palette ptr.
	move	*a7(PAT_PALT_p),a2,L
	move	a2,*a1(PAT_PALT_p),L

;body trim 2 palette ptr.
	move	*a7(PAT_PALT2_p),a2,L
	move	a2,*a1(PAT_PALT2_p),L

;head_t ptr.
	move	*a0(PR_HEAD_NBR),a2
	sll	5,a2
	addi	plr_heads_small,a2,L
	move	*a2,a2,L			;HEAD frame to show
;	movi	Brown_h,a2,L
	move	a2,*a1(PAT_HEADT_p),L

;passing
	movk	6,a2
	move	a2,*a1(PAT_PASS),W	;write data to array

;power
	move	*a0(PR_POWER_PTS),a2		;0-10
	move	a2,*a1(PAT_POWER),W	;write data to array

;clutch
	clr	a2
	move	a2,*a1(PAT_CLUTCH),W	;write data to array

;jersey swipe pal1
	move	*a7(PAT_PALSW_p),a2,L
	move	a2,*a1(PAT_PALSW_p),L	;write data to array

;jersey swipe pal2

	move	*a7(PAT_PALSW2_p),a2,L
	move	a2,*a1(PAT_PALSW2_p),L	;write data to array

;vertical swipe pal1

	move	*a7(PAT_PALVP_p),a2,L
	move	a2,*a1(PAT_PALVP_p),L	;write data to array

;vertical swipe pal2

	move	*a7(PAT_PALVP2_p),a2,L
	move	a2,*a1(PAT_PALVP2_p),L	;write data to array

;save table ptr.
	move	a1,*a13(plyr_attrib_p),L
	move	a1,a10
	clrc
	jruc	mpat_9a

mpat_9	setc
mpat_9a	PULL	a7
	rets

#*******************************
* Set * to player attribute table
* A8=Plyr #
* A13=*Plyr process
* >A10=*Attribute for uniform (ignores spechds)
* Trashes scratch

 SUBR	plyr_getattributes

	callr	setup_created_plyr_attrib_tbl
	jrnc	#norm3			;br=create plyr. (built ram table)

	move	a8,a0
	sll	5,a0
	movi	a1_tbl,a1		;team1 or team2
	add	a0,a1
	move	*a1,a2,L
	movi	a2_tbl,a1		;tm1set or tm2set
	add	a0,a1
	move	*a1,a3,L
	movi	a3_tbl,a1		;0 or 32
	add	a0,a1
	move	*a1,a4,L

	movi	player_names,a10
	move	*a2,a0			;get team nbr.
#lp3	cmpi	0,a0
	jrz	#out3
	addi	NEXT_TEAM_NAMES,a10
;;	addi	20*64,a10
	dec	a0
	jruc	#lp3
#out3
	move	*a2,a0			;get team nbr. again
	sll	4,a0
	add	a3,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10

	add	a4,a10

	move	*a10,a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp4
	inc	a10
	move	*a14+,a1,L
	cmp	a1,a0
	jrnz	#lp4

	.if	HEADCK
	.ref	debug_plyr_num
	move	@debug_plyr_num,a10
	move	a10,a1
	inc	a1
	move	a1,@debug_plyr_num
	.ref	show_name
	CREATE0	show_name
	.endif




;addi 320 for each name
	movi	ATL_t,a1
#lp5	cmpi	0,a10
	jrz	#out
	addi	PLYRAT_TBL_SIZE,a1
	dec	a10
	jruc	#lp5

#out
	move	a1,a10

;if player is playing with special initials use those attributes
	move	a8,a0
	sll	4,a0				;*16
	addi	special_heads,a0
	move	*a0,a0				;a0=head nbr of special head
	jrn	#norm2

#ncrtd	
	movi	PAT_SIZE,a1
	mpyu	a0,a1
	addi	spechds_t,a1
#norm2	move	a1,*a13(plyr_attrib_p),L
#norm3	rets



;a_tbl	.long	attrib1_obj+20h,attrib2_obj+20h
;	.long	attrib3_obj+20h,attrib4_obj+20h

a1_tbl	.long	team1,team1
	.long	team2,team2
	.long	team1,team2

a2_tbl	.long	tm1set,tm1set
	.long	tm2set,tm2set
	.long	tm1set,tm2set

a3_tbl	.long	0,32
	.long	0,32
	.long	0,32


#********************************
* A8=plyr # 0-3
* >A0=*plyr head img

 SUBR	getwindowhead

	move	a8,a0
	sll	5,a0
	addi	plyr_data_ptr_table,a0
	move	*a0,a0,L			;get player data pointer
	move	*a0(PR_CREATED_PLYR),a14
	jrle	#nocrt
	move	*a0(PR_HEAD_NBR),a0
	sll	5,a0
	addi	plr_heads_small,a0,L
	move	*a0,a0,L			;Created player HEAD
	move	*a0(5*32),a0,L			;get 5th head
	jruc	#exit
#nocrt
	move	a8,a0
	sll	5,a0
	movi	a1_tbl,a1		;team1 or team2
	add	a0,a1
	move	*a1,a2,L
	movi	a2_tbl,a1		;tm1set or tm2set
	add	a0,a1
	move	*a1,a3,L
	movi	a3_tbl,a1		;0 or 32
	add	a0,a1
	move	*a1,a4,L

	movi	player_names,a10
	move	*a2,a0
#lp3	cmpi	0,a0
	jrz	#out3
	addi	NEXT_TEAM_NAMES,a10
;;	addi	20*64,a10
	dec	a0
	jruc	#lp3
#out3
	move	*a2,a0
	sll	4,a0
	add	a3,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10

	add	a4,a10

	move	*a10,a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp4
	inc	a10
	move	*a14+,a1,L
	cmp	a1,a0
	jrnz	#lp4

;addi 320 for each name
	movi	ATL_t,a1
#lp5	cmpi	0,a10
	jrz	#out
	addi	PLYRAT_TBL_SIZE,a1
	dec	a10
	jruc	#lp5

#out

	move	a8,a0
	sll	4,a0			;*16
	addi	special_heads,a0
	move	*a0,a0
	jrn	#norm2
	movi	PAT_SIZE,a1
	mpyu	a0,a1
	addi	spechds_t,a1
#norm2
	addi	272+16,a1			;272
	move	*a1,a0,L
	move	*a0(5*32),a0,L
#exit
	rets

;==================
;      TABLES
;==================

;
; This table contains the HEIGHT/WEIGHT scale table pointers
;
; 1st:height & skinny,   2nd:height & normal,    3rd:height & chubby
;
;scale_factor_table
;	.long	scale57_t,scale57_t,scale60_t
;	.long	scale60_t,scale61_t,scale61f_t
;	.long	scale62_t,scale62_t,scale62t_t
;	.long	scale65_t,scale65t_t,scale65f_t
;	.long	scale66_t,scale66t_t,scale66f_t
;	.long	scale69_t,scale69t_t,scale69f_t
;	.long	scale610_t,scale610t_t,scale610f_t
;	.long	scale70_t,scale70t_t,scale70f_t
;	.long	scale71_t,scale72f_t,scale72f_t
;	.long	scale74_t,scale74_t,scale72f_t
;	.long	scale76et_t,scale74_t,scale74f_t


;
; Just a table of PLAYERS data pointers
; 
plyr_data_ptr_table
	.long	player1_data
	.long	player2_data
	.long	player3_data
	.long	player4_data

;
; This table contains the addresses of each players attribute table array
;
;  These arrays are used only if the player is playing with a character
;   which was CREATED
;
created_plyr_attrib_ptr_table
	.long	created_plyr1_attrib_tables
	.long	created_plyr2_attrib_tables
	.long	created_plyr3_attrib_tables
	.long	created_plyr4_attrib_tables

;
; Plyr attributes defined in plyrat.asm
;
speed_table
	.word	BV,BV1,BV2,BV3,BV4,BV5
	.word	BV6,BV7,BV8,BV9,BV10

shot_percent_table
	.word	SHT0,SHT1,SHT2,SHT3,SHT4,SHT5
	.word	SHT6,SHT7,SHT8,SHT9,SHT10,SHT11

dunk_ability_table
	.word	DNK0,DNK1,DNK2,DNK3,DNK4,DNK5
	.word	DNK6,DNK7,DNK8,DNK9,DNK10

block_ability_table
	.word	DEF0,DEF1,DEF2,DEF3,DEF4,DEF5
	.word	DEF6,DEF7,DEF8,DEF9,DEF10

steal_ability_table
	.word	SDEF0,SDEF1,SDEF2,SDEF3,SDEF4,SDEF5
	.word	SDEF6,SDEF7,SDEF8,SDEF9,SDEF10

;in makeplr.asm
;
; This is the table I use which converts the HEIGHT_PTS and WEIGHT_PTS
;  to an actual in-game SCALE table ptr.
;
;	.long	scale57_t
;	.long	scale61_t
;	.long	scale62_t
;	.long	scale65_t
;	.long	scale66_t
;	.long	scale69_t
;	.long	scale610_t
;	.long	scale70_t
;	.long	scale71_t
;	.long	scale74_t
;	.long	scale76et_t



Laetner_h
	HDMAC	laet1
Hawkins_h
	HDMAC	hawkins1
LJohnson_h
	HDMAC	johnson1
Divac_h
	HDMAC	divac1
KMalone_h
	HDMAC	kmalone1
Stockton_h
	HDMAC	stock1
Ewing_h
	HDMAC	ewing1
Seikaly_h
	HDMAC	shiek1
Miller_h
	HDMAC	Miller1
Mutumbo_h
	HDMAC	Mutumbo1
Oakley_h
	HDMAC	Oakley1
Olajuwon_h
	HDMAC	Hakeem1
Rice_h
	HDMAC	Rice1
DRobinson_h
	HDMAC	Robins1
Schrempf_h
	HDMAC	schremp1
Smith_h
	HDMAC	smith1
Tisdale_h
	HDMAC	tisdale1
Kemp_h
	HDMAC	kemp1
Pippen_h
	HDMAC	pippin1
Gill_h
	HDMAC	gill1
Mullin_h
	HDMAC	mullin1
Person_h
	HDMAC	Person1
Augmon_h
	HDMAC	Augmon1
Benjamin_h
	HDMAC	Benja1
Coleman_h
	HDMAC	Cole1
Drexler_h
	HDMAC	Drex1
Elliot_h
	HDMAC	Elliot1
Hardaway_h
	HDMAC	Hrdaway1
HCGrant_h
	HDMAC	GrantG1
Hornacek_h
	HDMAC	Horna1
Manning_h
	HDMAC	Manning1

	.end



