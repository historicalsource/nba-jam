;-----------------------------------------------------------------------------
*
* Owner:	JOHNSON
*
; Software:	Jeff Johnson
; Initiated:	5-20-95
;
; COPYRIGHT (C) 1995 WILLIAMS ELECTRONICS GAMES, INC.
;
;.Last mod - 6/30/95 
;-----------------------------------------------------------------------------
	.file	"makeplr2.asm"
	.title	"create player logic"
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"

	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"bgndtbl.glo"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"world.equ"
	.include	"macros.hdr"
;	.include	"plyrseq.tbl"
	.include	"ncknme.tbl"
	.asg		0,SEQT
	.include	"plyr.equ"


	.global	player1_data,player2_data,player3_data,player4_data

	.def	PASSWORD
	.def	stx_avgallow,stx_avgscore

	.def	NUM_NICK_NAMES
	.def	NUM_UNIFORM_NAMES
	.def	body_scale_table

	.def	nickname_img_tbl

	.ref	CUST6,CUST7,CUST8,CUST9,CUST10
	.ref	cntdown_snd
	.ref	transition_flag
	.ref	butn_cursor_pos
	.ref	mess_objid,mess_line_spacing
	.ref	mess_cursy,message_palette
	.ref	setup_message,print_string_C2
	.ref	pal_getf,obj_on,obj_off
	.ref	speed_points
	.ref	power_points
	.ref	shoot_points
	.ref	dunks_points
	.ref	steal_points
	.ref	block_points
	.ref	height_points
	.ref	weight_points
	.ref	total_points
	.ref	dither_objs,dither_objs2
	.ref	done_creating
	.ref	clock_minutes,clock_seconds
	.ref	done_creating			;exit flag for CREATE PLAYER
	.ref	fog_obj_ptr,yes_no_buttons_ptr
	.ref	stop_clock			;1=yes, 0=no
	.ref	brush12_ascii,brush20_ascii
	.ref	brush10_ascii
	.ref	bast8t_ascii,bast7t_ascii
	.ref	bast8tcyc_ascii
	.ref	p1_slide_box_flag,p2_slide_box_flag
	.ref	p3_slide_box_flag,p4_slide_box_flag
	.ref	GAMSTATE
	.ref	TUBE_O_P,TUBE_R_P
	.ref	TWOPLAYERS
	.ref	nick_name_nbr
	.ref	uniform_nbr
	.ref	get_all_buttons_down,get_all_buttons_cur
	.ref	select_arrow_obj
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
	.ref	concat_rom_string,print_string_C
	.ref	copy_string,dec_to_asc
	.ref	whitsle_snd
	.ref	nick_nme1,nick_nme2,nick_nme3,nick_nme4
	.ref	nick_nme5,nick_nme6,nick_nme7,nick_nme8
	.ref	nick_nme9,nick_nme10,nick_nme11,nick_nme12
	.ref	nick_nme13,nick_nme14,nick_nme15,nick_nme16
	.ref	nick_nme17,nick_nme18,nick_nme19,nick_nme20
	.ref	nick_nme21,nick_nme22,nick_nme23,nick_nme24
	.ref	nick_nme26,nick_nme27,nick_nme28
	.ref	nick_nme29,nick_nme30,nick_nme31,nick_nme32
	.ref	nick_nme33,nick_nme34,nick_nme35,nick_nme36
	.ref	get_but_val_down,get_but_val_cur
	.ref	bx_slide_snd


	.text

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	print_changed_name_info

	movi	name_chnge_str_setup,a2,L
	calla	setup_message
	movi	BUTN_BOX_STUFF,a0			;object ID
	move	a0,@mess_objid
	movi	name_chnge_str,a4,L
	calla	print_string_C2

	movi	name_chnge_str_setup2,a2,L
	calla	setup_message
	movi	BUTN_BOX_STUFF,a0			;object ID
	move	a0,@mess_objid
	movk	11,a0
	move	a0,@mess_line_spacing
	movi	name_chnge_str2,a4,L
	calla	print_string_C2

	SLEEP	70
	movi	360,a10
pcni_1
	SLEEPK	2
	move	*a13(PC_PLAYNUM),a0
	calla	get_but_val_cur
	jrnz	pcni_2
	dsj	a10,pcni_1
pcni_2
 	RETP



name_chnge_str_setup
	PRINT_STR	bast8t_ascii,4,0,185,90,BAST_Y_P,0

name_chnge_str_setup2
	PRINT_STR	bast8t_ascii,4,0,185,115,BAST_W_P,0

name_chnge_str
	.string	"--- NOTICE ---",0
	.even

name_chnge_str2
	.string	"YOUR PLAYERS' NAME",1
	.string	"AND PIN NUMBER HAVE",1
	.string	"BEEN CHANGED.",1
	.string	" ",1
	.string	"TO ACCESS THIS RECORD,",1
	.string	"YOU MUST USE YOUR",1
	.string	"NEW NAME AND PIN",1
	.string	"NUMBER.",0
	.even

;-----------------------------------------------------------------------------
;	This routine checks to see if the player entered a naugthy 6 letter
; name. 
;
;   INPUT: a0 - player number
; RETURNS: carry clear if naughty word
;-----------------------------------------------------------------------------
 SUBR	censor_players_name

	PUSH	a0,a1,a2,a3,a4
	move	a0,a10
	sll	5,a0
	addi	plyr_data_tbl,a0,L
	move	*a0,a0,L			;get player data ptr.
	addi	PR_NAME1,a0,L
	move	a0,a4

;;check special cases first
;
;	movi	NAME_LETTERS,a3
;cpn_inv
;	move	*a0+,a2				;get entered letter
;	jrz	cpn_1
;	cmp	a2,a14
;	dsj	a3,cpn_inv
;
;

	movi	naughty_word_tbl,a1,L
cpn_top
	movi	NAME_LETTERS,a3
	move	a4,a0
cpn_00
	move	*a1+,a14			;get letter of bad word
	jrn	cpn_4				;br=found match
cpn_0a
	move	*a0+,a2
	jrz	cpn_1
	cmp	a2,a14
	dsjne	a3,cpn_0a
	jrnz	cpn_1
cpn_0
	move	*a1+,a14			;get letter of bad word
	jrn	cpn_4				;br=found match
cpn_1a
	move	*a0+,a2				;get entered letter
	jrz	cpn_1				;br=end of plyr entered name
	cmpi	SPACE_CHAR,a2
	dsjeq	a3,cpn_1a
	jreq	cpn_1
	cmp	a2,a14
	jreq	cpn_0
cpn_1
	move	*a1+,a14
	jrnn	cpn_1
	move	*a1,a14				;at end of table
	jrnn	cpn_top				;br=no
	jruc	cpn_5

;found a NAUGHTY word
cpn_4
	SOUND1	whitsle_snd
	clrc
	jruc	cpn_6


;no NAUGHTY word found
cpn_5
	setc
cpn_6 	PULL	a0,a1,a2,a3,a4
	rets



	.def	plyr_data_tbl
plyr_data_tbl
	.long	player1_data
	.long	player2_data
	.long	player3_data
	.long	player4_data



AA	equ	1
BB	equ	2
CC	equ	3
DD	equ	4
EE	equ	5
FF	equ	6
GG	equ	7
HH	equ	8
II	equ	9
JJ	equ	10
KK	equ	11
LL	equ	12
MM	equ	13
NN	equ	14
OO	equ	15
PP	equ	16
QQ	equ	17
R2	equ	18
SS	equ	19
TT	equ	20
UU	equ	21
VV	equ	22
WW	equ	23
XX	equ	24
YY	equ	25
ZZ	equ	26
EX	equ	27
;DL	equ	28
;SPC	equ	29
;END	equ	0


naughty_word_tbl
 .word	FF,CC,KK,-1		;FCK (ie. FCKYOU, FCK IT...etc)
 .word	PP,HH,KK,-1		;PHK (ie. FCKYOU, FCK IT...etc)
 .word	VV,AA,GG,II,NN,AA,-1	;vagina
 .word	FF,UU,CC,KK,-1		;fuck
 .word	FF,UU,KK,-1		;fuk
 .word	FF,UU,CC,-1		;fuc
 .word	AA,SS,SS,WW,YY,PP,-1	;asswyp
 .word	AA,SS,SS,LL,II,KK,-1	;asslik
 .word	AA,SS,HH,OO,LL,EE,-1	;ashole
 .word	AA,HH,OO,LL,EE,-1	;ahole
 .word	WW,HH,OO,R2,EE,-1	;whore
 .word	BB,UU,TT,TT,-1		;butt
 .word	CC,UU,MM,-1		;cum
 .word	GG,AA,YY,BB,OO,YY,-1	;gayboy
 .word	DD,AA,MM,NN,-1		;damn
 .word	JJ,II,ZZ,-1		;jiz
 .word	PP,II,SS,SS,-1		;piss
 .word	PP,II,SS,HH,-1		;pish
 .word	PP,UU,SS,SS,-1		;puss
 .word	CC,OO,CC,KK,-1		;cock
 .word	CC,UU,NN,TT,-1		;cunt
 .word	SS,HH,II,TT,-1		;shit
 .word	SS,LL,UU,TT,-1		;slut
 .word	CC,LL,II,TT,-1		;clit
 .word	PP,HH,UU,CC,KK,-1	;phuck
 .word	PP,HH,UU,KK,-1		;phuk
 .word	BB,II,TT,CC,HH,-1	;bitch
 .word	PP,R2,LL,JJ,AA,MM,-1	;pearl jam
 .word	BB,AA,SS,TT,R2,DD,-1	;bastard
 .word	PP,R2,II,CC,KK,-1	;prick
 .word	NN,II,GG,GG,EE,R2,-1	;nigger
 .word	JJ,AA,GG,OO,FF,FF,-1	;jagoff
 .word	JJ,AA,KK,OO,FF,FF,-1	;jakoff
 .word	PP,EE,NN,II,SS,-1	;penis
 .word	JJ,II,SS,MM,-1		;jism
 .word	JJ,EE,WW,BB,OO,YY,-1	;jewboy
 .word	EE,AA,TT,MM,EE,-1	;eatme
 .word	BB,LL,OO,WW,-1		;blow
 .word	BB,LL,OO,JJ,OO,BB,-1	;blojob
 .word	BB,LL,WW,JJ,OO,BB,-1	;blwjob
 .word	SS,UU,CC,KK,MM,EE,-1	;suckme
 .word	SS,UU,KK,MM,EE,-1	;sukme
 .word	SS,EE,MM,EE,NN,-1	;semen
 .word	JJ,R2,KK,OO,FF,FF,-1	;jrkoff
 .word	PP,UU,TT,AA,NN,GG,-1	;putang
 .word	-1



	.asg	87<<16,BOX_END_Y
	.asg	-150<<16,BOX_STRT_Y

;-----------------------------------------------------------------------------
; on the 'nick name' page
;-----------------------------------------------------------------------------
 SUBR	create_arrow_and_text_bar

;create up/dwn bar
	movi	200,a3					;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	BUTN_BOX_STUFF,a5			;object class
	clr	a6					;x vel
	clr	a7					;y vel
	movi	[BBOXX+5,0],a0,L				;get X pos.
	movi	[BBOXY+63,0],a1,L				;get Y pos.
	movi	NNABAR,a2,L
	calla	BEGINOBJ2

;create hi-liter bar (under 'nick name img')

	movi	200,a3					;z pos (sorting)
	movi	[BBOXX+24,0],a0,L				;get X pos.
	movi	[BBOXY+127,0],a1,L				;get Y pos.
	movi	NNBAR,a2,L
	calla	BEGINOBJ2
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	clr_select_arrow_ram

	clr	a0
	move	a0,@select_arrow_obj,L
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_select_arrow

	PUSH	a0
	move	@select_arrow_obj,a8,L
	jrz	dsa_1
	calla	DELOBJA8
	callr	clr_select_arrow_ram
dsa_1	PULL	a0
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_up_arrow

	callr	del_select_arrow
	movi	400,a3					;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL|M_FLIPV,a4		;DMA flags
	movi	BUTN_BOX_STUFF,a5		;object class
	clr	a6					;x vel
	clr	a7					;y vel
	movi	[BBOXX+8,0],a0,L				;get X pos.
	movi	[BBOXY+127,0],a1,L				;get Y pos.
	movi	NNAROW,a2,L
	calla	BEGINOBJ2
	move	a8,@select_arrow_obj,L
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_down_arrow

	callr	del_select_arrow
	movi	400,a3					;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	BUTN_BOX_STUFF,a5		;object class
	clr	a6					;x vel
	clr	a7					;y vel
	movi	[BBOXX+8,0],a0,L				;get X pos.
	movi	[BBOXY+138,0],a1,L				;get Y pos.
	movi	NNAROW,a2,L
	calla	BEGINOBJ2
	move	a8,@select_arrow_obj,L
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_rght_arrow

	callr	del_select_arrow
	movi	400,a3					;z pos (sorting)
	movi	M_FLIPH|DMAWNZ|M_SCRNREL,a4	;DMA flags
	movi	BUTN_BOX_STUFF,a5		;object class
	clr	a6					;x vel
	clr	a7					;y vel
	movi	[BBOXX+107,0],a0			;x val of first head
	movi	[BBOXY+109,0],a1			;y val
	movi	HDAROW,a2,L
	calla	BEGINOBJ2
	move	a8,@select_arrow_obj,L
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_left_arrow

	callr	del_select_arrow
	movi	400,a3					;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	BUTN_BOX_STUFF,a5		;object class
	clr	a6					;x vel
	clr	a7					;y vel
	movi	[BBOXX+45,0],a0			;x val of first head
	movi	[BBOXY+109,0],a1			;y val
	movi	HDAROW,a2,L
	calla	BEGINOBJ2
	move	a8,@select_arrow_obj,L
	rets


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_uniform_names

	movi	UNIFORM_NAME_OBJS,a0
	clr	a1
	calla	obj_del1c
 	rets


	.asg	BBOXX+43,UNFM_NME_X
	.asg	BBOXY+72,UNFM_NME_Y
	.asg	11<<16,UNFM_NME_SPC
	.asg	2<<16,UNFM_NME_X_SPC

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_uniform_names

	movi	2000,a3					;z pos.
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	UNIFORM_NAME_OBJS,a5			;object class
	clr	a6					;x vel
	clr	a7					;y vel
	clr	a10					;counter

	move	@uniform_nbr,a9
	sll	5,a9
	addi	uniform_img_tbl,a9,L

	movi	[UNFM_NME_Y,0],a1,L			;Y coor
cun_1
	move	*a9+,a2,L				;get img to create
	movi	[UNFM_NME_X,0],a0,L			;X coor

	movi	BAST_W_P,b0,L
	cmpi	MIDDLE_UNIFORM_NBR,a10
	jrne	cun_2
	addi	UNFM_NME_X_SPC,a1			;extra spacing
	movi	BAST_Y_P,b0,L
cun_2
	cmpi	MIDDLE_UNIFORM_NBR+1,a10
	jrne	cun_2a
	addi	UNFM_NME_X_SPC+1,a1			;extra spacing

cun_2a	move	a1,a11
	calla	BEGINOBJP2
	move	a11,a1
	addi	UNFM_NME_SPC,a1,L			;add in spacing
	inc	a10
	cmpi	UNIFORM_NAMES_ON_SCRN,a10
	jrlo	cun_1
 	rets


;
; Contains:
; 
; 1) uniform name img
; 
uniform_img_tbl
	.long	city_atl
	.long	city_bos
	.long	city_cha
	.long	city_chi
	.long	city_cle
	.long	DEFAULT			;color of selected team during team select
	.long	city_dal
	.long	city_den
	.long	city_det
	.long	city_gol
	.long	city_hou
	.long	city_ind
	.long	city_lac
	.long	city_lal
	.long	city_mia
	.long	city_mil
	.long	city_min
	.long	city_nej
	.long	city_ney
	.long	city_orl
	.long	city_phi
	.long	city_pho
	.long	city_por
	.long	city_sac
	.long	city_san
	.long	city_sea
	.long	city_tor
	.long	city_uta
	.long	city_van
	.long	city_was
	.long	CUST1
	.long	CUST2
	.long	CUST3
	.long	CUST4
	.long	CUST5
	.long	CUST6
	.long	CUST7
	.long	CUST8
	.long	CUST9
	.long	CUST10
uniform_img_tbl_end
	.long	city_atl		;wrap around case
	.long	city_bos
	.long	city_cha
	.long	city_chi
	.long	city_cle
	.long	DEFAULT			;color of selected team during team select
	.long	city_dal
	.long	city_den
	.long	city_det
	.long	city_gol
	.long	city_hou
	.long	city_ind
	.long	city_lac
	.long	city_lal
	.long	city_mia
	.long	city_mil


NUM_UNIFORM_NAMES	equ	(uniform_img_tbl_end-uniform_img_tbl)/32			;on screen at once


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_nick_names

	movi	NICK_NAME_IMGS,a0
	clr	a1
	calla	obj_del1c
 	rets

	.asg	BBOXX+43,NIK_NME_X
	.asg	BBOXY+72,NIK_NME_Y
	.asg	11<<16,NIK_NME_SPC
	.asg	2<<16,NIK_NME_X_SPC
	.asg	0,NICK_NAME_IMG
	.asg	32,NICK_NAME_SND

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_nick_names

	movi	2000,a3					;z pos.
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	NICK_NAME_IMGS,a5			;object class
	clr	a6					;x vel
	clr	a7					;y vel
	clr	a10					;counter

	move	@nick_name_nbr,a9
;	move	@nick_name_cur_pos,a9
	sll	6,a9
	addi	nickname_img_tbl,a9,L

	movi	[NIK_NME_Y,0],a1,L			;Y coor
cnn_1
	move	*a9(NICK_NAME_IMG),a2,L			;get img to create
	movi	[NIK_NME_X,0],a0,L			;X coor

	movi	BAST_W_P,b0,L
	cmpi	MIDDLE_NICK_NAME,a10
	jrne	cnn_2
	addi	NIK_NME_X_SPC,a1			;extra spacing
	movi	BAST_Y_P,b0,L
cnn_2
	cmpi	MIDDLE_NICK_NAME+1,a10
	jrne	ccn_2a
	addi	NIK_NME_X_SPC+1,a1			;extra spacing

ccn_2a	move	a1,a11
	calla	BEGINOBJP2
	move	a11,a1
	addi	NIK_NME_SPC,a1,L			;add in spacing
	addi	64,a9					;next table line
	inc	a10
	cmpi	NICK_NAMES_ON_SCRN,a10
	jrlo	cnn_1
 	rets

;
; Contains:
; 
; 1) nick name img
; 2) sound table ptr for nick name
; 

nickname_img_tbl
	.long	NN_ACE,nick_nme1
	.long	NN_BERTHA,nick_nme2
	.long	NN_BIGDAD,nick_nme3
	.long	NN_BIGFOOT,nick_nme4
	.long	NN_BOOGY,nick_nme5
	.long	NN_BUBBA,nick_nme6
	.long	NN_CHILLY,nick_nme7
	.long	NN_CORNEL,nick_nme8
	.long	NN_CUCKOO,nick_nme9
	.long	NN_DINGBAT,nick_nme10
	.long	NN_FATBOY,nick_nme11
	.long	NN_FLASH,nick_nme12
	.long	NN_FRANKIE,nick_nme13
	.long	NN_FRNKCOW,nick_nme14
	.long	NN_GATOR,nick_nme15
	.long	NN_GRANDPA,nick_nme16
	.long	NN_HAMMER,nick_nme17
	.long	NN_HAWKEYE,nick_nme18
	.long	NN_HOMEBOY,nick_nme19
	.long	NN_JOKER,nick_nme20
	.long	NN_LOVER,nick_nme21
	.long	NN_MADDOG,nick_nme22
	.long	NN_MARGE,nick_nme23
	.long	NN_MERLIN,nick_nme24
;	.long	NN_MJ,nick_nme25
	.long	NN_PONGO,nick_nme26
	.long	NN_SHADOW,nick_nme27
	.long	NN_SLIM,nick_nme28
	.long	NN_SNAKE,nick_nme29
	.long	NN_SPANKY,nick_nme30
	.long	NN_SPIDER,nick_nme31
	.long	NN_SPIKE,nick_nme32
	.long	NN_TOPGUN,nick_nme33
	.long	NN_TREXX,nick_nme34
	.long	NN_VIPER,nick_nme35
	.long	NN_ZIPPY,nick_nme36
nickname_img_tbl_end
	.long	NN_ACE,nick_nme1
	.long	NN_BERTHA,nick_nme2
	.long	NN_BIGDAD,nick_nme3
	.long	NN_BIGFOOT,nick_nme4
	.long	NN_BOOGY,nick_nme5
	.long	NN_BUBBA,nick_nme6
	.long	NN_CHILLY,nick_nme7
	.long	NN_CORNEL,nick_nme8
	.long	NN_CUCKOO,nick_nme9
	.long	NN_DINGBAT,nick_nme10
	.long	NN_FATBOY,nick_nme11
	.long	NN_FLASH,nick_nme12
	.long	NN_FRANKIE,nick_nme13
	.long	NN_FRNKCOW,nick_nme14
	.long	NN_GATOR,nick_nme15
nickname_img_tbl_end2


NUM_NICK_NAMES	equ	(nickname_img_tbl_end-nickname_img_tbl)/64			;on screen at once

;-----------------------------------------------------------------------------
;   This routine creates the box which slides on the screen, and informs
; the player that CREDIT NOT TAKEN during CREATE PLAYER
;
; INPUT: reg a8 = player number (0-3)
;-----------------------------------------------------------------------------
	.asg	176,UP_END_Y
	.asg	256,DWN_END_Y

 SUBR	slide_info_box_on_off

sbo_0
	SLEEPK	1
	move	@transition_flag,a0		;in TRANSITION ?
	jrnz	sbo_0				;br=yep

;set players flag
	move	a8,a11
	sll	5,a11					;*32
	addi	plyr_flag_tbl,a11,L
	move	*a11,a0,L				;get ram ptr
	movk	1,a1					;set players flag	
	move	a1,*a0


;create box
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	clr	a5
	clr	a6					;x vel
	clr	a7					;y vel

	movi	plyr_box_xys,a10,L
	sll	6,a8					;*64
	add	a8,a10

;create box
	move	*a10(0),a0,L				;get X pos.
	move	*a10(32),a1,L				;get Y pos.
	movi	firstwin,a2,L
	movi	20400,a3				;z pos (sorting)
	calla	BEGINOBJ2
	move	a8,a9

;create info
	move	*a10(0),a0,L				;get X pos.
	move	*a10(32),a1,L				;get Y pos.
	movi	CREDNOT,a2,L
	movi	20500,a3				;z pos (sorting)
	calla	BEGINOBJ2

;slide box on
sbo_1
	SLEEPK	1
	move	@transition_flag,a0		;in TRANSITION ?
	jrnz	sbo_1				;br=yep

	SOUND1	bx_slide_snd
sbo_1a
	SLEEPK	1

	move	*a8(OYPOS),a1
	subk	10,a1
	move	a1,*a8(OYPOS)			;change BOX location

	move	*a9(OYPOS),a1
	subk	10,a1
	move	a1,*a9(OYPOS)			;change TEXT location
	cmpi	176,a1
	jrgt	sbo_1a

	movi	UP_END_Y,a1
	move	a1,*a8(OYPOS)			;set box location
	movi	UP_END_Y-10,a1
	move	a1,*a9(OYPOS)			;set TEXT location

	SLEEP	120

;slide box off
sbo_2
	SLEEPK	1
	move	@transition_flag,a0		;in TRANSITION ?
	jrnz	sbo_2				;br=yep

	SOUND1	bx_slide_snd

sbo_2a
	SLEEPK	1
	
	move	*a8(OYPOS),a1
	addk	20,a1
	move	a1,*a8(OYPOS)			;change BOX location

	move	*a9(OYPOS),a1
	addk	20,a1
	move	a1,*a9(OYPOS)			;change TEXT location
	cmpi	DWN_END_Y,a1
	jrlo	sbo_2a

;delete objects
	calla	DELOBJA8
	move	a9,a8
	calla	DELOBJA8

;clear players flag
	move	*a11,a0,L				;get ram ptr
	clr	a1					;clear players flag
	move	a1,*a0
 	DIE



plyr_flag_tbl
	.long	p1_slide_box_flag
	.long	p2_slide_box_flag
	.long	p3_slide_box_flag
	.long	p4_slide_box_flag


plyr_box_xys
	.long	1<<16,306<<16		;player 1 box pos.
	.long	100<<16,306<<16		;player 2 box pos.
	.long	200<<16,306<<16		;player 3 box pos.
	.long	300<<16,306<<16		;player 4 box pos.


;-----------------------------------------------------------------------------
;	This routine deletes the YES/NO buttons with the passed in 
; table index
;
; INPUT: a10 - table offset
;-----------------------------------------------------------------------------
 SUBR	del_yes_no_buttons

	sll	4,a10
	addi	butn_pid_tbl,a10
	move	*a10,a0,W
	clr	a1
	calla	obj_del1c
 	rets


butn_pid_tbl
	.word	P1_BTUNS
	.word	P2_BTUNS
	.word	P3_BTUNS
	.word	P4_BTUNS
	.word	YES_NO_BUTNS

;-----------------------------------------------------------------------------
;	This routine create the small yes/no buttons
;
; INPUT: reg a10 - player number (table offset)
;-----------------------------------------------------------------------------
 SUBR	create_small_yes_no_butns

	PUSH	a10,a11
	movi	2000,a3					;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	clr	a6					;x vel
	clr	a7					;y vel

	sll	5,a10
	addi	yes_no_butn_tbl,a10
	move	*a10,a10,L

	move	*a10+,a5,W			;get OBJ ID

;'YES' button
	movi	SMYES,a2,L
	move	*a10+,a0,L			;X coor.
	move	*a10+,a1,L			;Y coor.
	calla	BEGINOBJ2
	move	a8,a9
;'NO' button
	movi	SMNO,a2,L
	move	*a10+,a0,L			;X coor.
	move	*a10+,a1,L			;Y coor.
	calla	BEGINOBJ2

	PUSH	a8,a9

	move	*a10+,a0,L			;X coor.
	jrn	nosh_1				;br=no shadow imgs.

	movi	1900,a3				;z pos (sorting)
;'YES' shadow
	movi	SMYSHP,a2,L
	move	*a10+,a1,L			;Y coor.
	calla	BEGINOBJ2

;'NO' shadow
	movi	SMNSHP,a2,L
	move	*a10+,a0,L			;X coor.
	move	*a10,a1,L			;Y coor.
	calla	BEGINOBJ2
nosh_1

	PULL	a8,a9				;returned values
	PULL	a10,a11
 	rets


yes_no_butn_tbl
	.long	p1_xys		;0
	.long	p2_xys		;1
	.long	p3_xys		;2
	.long	p4_xys		;3
	.long	opt_scrn_xys	;4


	.asg	99,BUTN_Y
p1_xys
	.word	P1_BTUNS
	.long	[11,0],[BUTN_Y,0],[11,0],[BUTN_Y+3,0]		;buttons
	.long	-1						;shadows
p2_xys
	.word	P2_BTUNS
	.long	[106,0],[BUTN_Y,0],[106,0],[BUTN_Y+3,0]
	.long	-1
p3_xys
	.word	P3_BTUNS
	.long	[204,0],[BUTN_Y,0],[204,0],[BUTN_Y+3,0]
	.long	-1
p4_xys
	.word	P4_BTUNS
	.long	[300,0],[BUTN_Y,0],[300,0],[BUTN_Y+3,0]
	.long	-1
opt_scrn_xys
	.word	YES_NO_BUTNS
	.long	[BALL1X+3,0],[BALL1Y,0],[BALL1X+3,0],[BALL1Y+3,0]
	.long	[BALL1X+3,0],[BALL1Y+2,0],[BALL1X+3,0],[BALL1Y+3,0]

;-----------------------------------------------------------------------------
;   This routine create the big yes/no buttons during create player
;-----------------------------------------------------------------------------
 SUBR	create_yes_no_buttons

	movi	30,a3					;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL,a4			;DMA flags
	movi	BUTN_BOX_STUFF,a5			;object ID
	clr	a6					;x vel
	clr	a7					;y vel
;'YES' button
	movi	YES,a2,L
	movi	[BBOXX+13,0],a0,L			;X coor.
	movi	[BBOXY+80,0],a1,L			;Y coor.
;	movi	[BBOXY+54,0],a1,L			;Y coor.
	calla	BEGINOBJ2
	move	a8,a9				;save 'YES' button obj. ptr
;'NO' button
	movi	NO,a2,L
	movi	[BBOXX+13,0],a0,L			;X coor.
	movi	[BBOXY+139,0],a1,L			;Y coor.
;	movi	[BBOXY+124,0],a1,L			;Y coor.
	calla	BEGINOBJ2
	rets


	.asg	6,BLINK_CNT
;-----------------------------------------------------------------------------
; This routine restores the YES and NO button palettes after the player moves
;  the cursor (corrects the palette if blinking stopped on incorrect palette)
; Also handles the launching and updating of the blink 'YES' or 'NO'
;   button logic
;
; called when player changes from 'YES' to 'NO' or vice versa
;
; INPUT:  a8 - ptr to NO button obj.
; 	  a9 - ptr to YES button obj.
;	 a11 - cursor position
;-----------------------------------------------------------------------------
 SUBR	update_yes_no_button_pals

 	move	a11,a11				;update YES or NO ?
	jrnz	uno_1				;br='NO' button

;update 'YES' button pal

	move	*a9(OMISC),a14
	cmpi	BLINK_CNT,a14
	jrhs	uyes_1				;change button palette
	inc	a14
	move	a14,*a9(OMISC)
	jruc	uend_1
uyes_1
	clr	a14
	move	a14,*a9(OMISC)

	movi	YESP_P,a0,L
	calla	pal_getf
	move	*a9(OPAL),a14
	cmp	a0,a14			;on non-hilited pal ?
	jrne	uyes_2
	movi	YESS_P,a0,L
	calla	pal_getf
uyes_2	move	a0,*a9(OPAL)			;change button palette
	jruc	uend_1

;update 'NO' button pal

uno_1
	move	*a8(OMISC),a14
	cmpi	BLINK_CNT,a14
	jrhs	uno_2				;change button palette
	inc	a14
	move	a14,*a8(OMISC)
	jruc	uend_1
uno_2
	clr	a14
	move	a14,*a8(OMISC)
	movi	NOP_P,a0,L
	calla	pal_getf
	move	*a8(OPAL),a14
	cmp	a0,a14			;on non-hilited pal ?
	jrne	uno_3
	movi	NOS_P,a0,L
	calla	pal_getf
uno_3	move	a0,*a8(OPAL)			;change button palette
uend_1	rets

;-----------------------------------------------------------------------------
;	This routine set the YES/NO buttons to their original pals
;
; INPUT: a8 - ptr to 'NO' button
;	 a9 - ptr to 'YES' button
;
;-----------------------------------------------------------------------------
 SUBR	reset_yes_no_butn_pals

	movi	NOS_P,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)

	movi	YESS_P,a0,L
	calla	pal_getf
	move	a0,*a9(OPAL)
 	rets

;-----------------------------------------------------------------------------
;	     This routine flashes the button when SELECTED
;
; INPUT:  a8 - ptr to NO button obj.
; 	  a9 - ptr to YES button obj.
;	 a11 - cursor position
;-----------------------------------------------------------------------------
 SUBR	flash_pressed_yes_no_button

	PUSHP	a10,a11

	move	a11,a11
	jrnz	flno_0				;br=cursor on 'NO'

;flash 'YES' button
	movi	yes_pal_flash_table,a11
	movi	NUM_PALS_Y,a10
flys_1
	move	*a11+,a0,L			;get palette
	calla	pal_getf
	move	a0,*a9(OPAL)			;update 'YES' button
	SLEEPK	1
	dsj	a10,flys_1
	jruc	fldn_1

;flash 'NO' button
flno_0
	movi	no_pal_flash_table,a11
	movi	NUM_PALS_N,a10
flno_1
	move	*a11+,a0,L			;get palette
	calla	pal_getf
	move	a0,*a8(OPAL)			;update 'NO' button
	SLEEPK	1
	dsj	a10,flno_1

fldn_1	PULLP	a10,a11
	RETP


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_fog_image
 	
	movi	1,a3				;z pos (sorting)
	movi	FOG_IMG_STUFF,a5		;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	movi	FOG_01,a2,L
	movi	[296,0],a0,L			;X coor.
	movi	[0,0],a1,L			;Y coor.
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	calla	BEGINOBJ2
	move	a8,@fog_obj_ptr,L			;save ptr. to FOG obj

	CREATE	FOG_PID,animate_fog
 	rets

;-----------------------------------------------------------------------------
;  This PROCESS control the animating of the FOG behind player dribbling ball
;-----------------------------------------------------------------------------
 SUBRP	animate_fog

	movi	fog_frame_table,a10,L
	move	@fog_obj_ptr,a8,L		;get OLD obj. ptr
anfg_1
	cmpi	fog_frame_table_end,a10		;still in range ?
	jrlo	anfg_2				;yep
	movi	fog_frame_table,a10,L
anfg_2	move	*a10+,a0,L			;get NEW img. ptr

	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	calla	obj_aniq
	SLEEPK	6
	jruc	anfg_1
	calla	DELOBJA8
	DIE

;-----------------------------------------------------------------------------
;	This routine creates the big box containing the players current
; editing information/directions
;-----------------------------------------------------------------------------
 SUBR	create_information_box

	movi	50,a3				;z pos (sorting)
	movi	BIG_BOX_STUFF,a5		;object ID
	clr	a6				;x vel
	clr	a7				;y vel

;left side
	movi	BIGBOX,a2,L
	movi	[BBOXX,0],a0,L			;X coor.
	movi	[BBOXY,0],a1,L			;Y coor.
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	calla	BEGINOBJ2

;right side
	movi	[BBOXX+153,0],a0,L		;X coor.
	movi	[BBOXY,0],a1,L			;Y coor.
	movi	DMAWNZ|M_SCRNREL|M_FLIPH,a4	;DMA flags
	calla	BEGINOBJ2

;title bar for this box
	movi	TUBE02,a2,L
	movi	[BBOXX+5,0],a0,L		;X coor.
	movi	[BBOXY+5,0],a1,L		;X coor.
	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
	calla	BEGINOBJ2

;drop shadow
;	movi	DROPSH02,a2,L			;vertical shadow
;	movi	[BBOXX+3,0],a0,L			;X coor.
;	movi	[BBOXY+1,0],a1,L			;X coor.
;	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
;	calla	BEGINOBJ2
	rets

;-----------------------------------------------------------------------------
; This routine create the dithering patterns and starts the process which
;  toggles the patterns on and off.
;-----------------------------------------------------------------------------
 SUBR	create_dithering_patterns

	movi	dither_objs,a9,L		;ram to store object ptrs.
	movi	dither_img_table,a10,L
	clr	a11				;counter

	movi	5,a3				;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	BIG_BOX_STUFF,a5		;object ID
	clr	a6				;x vel
	clr	a7				;y vel
ntdith_1
	move	*a10+,a2,L
	movi	[BBOXX+4,0],a0,L		;X coor.
	movi	[BBOXY+8,0],a1,L		;Y coor.
	calla	BEGINOBJ2
	move	a8,*a9+,L			;save object ptr.
	inc	a11
	cmpi	DITH_IMGS,a11
	jrlo	ntdith_1

;now create second set of dither patterns offset by 1 in X
	clr	a11
	movi	dither_objs2,a9,L		;ram to store object ptrs.
	movi	dither_img_table,a10,L
ntdith_2
	move	*a10+,a2,L
	movi	[BBOXX+5,0],a0,L		;X coor.
	movi	[BBOXY+8,0],a1,L		;X coor.
	calla	BEGINOBJ2
	move	a8,*a9+,L			;save object ptr.
	calla	obj_off				;turn off second set...for now
	inc	a11
	cmpi	DITH_IMGS,a11
	jrlo	ntdith_2
	CREATE0	toggle_dither_patterns_on_off
 	rets

;-----------------------------------------------------------------------------
;	This process turns on set of dither patterns on and the other off
; every tick
;-----------------------------------------------------------------------------
 SUBRP	toggle_dither_patterns_on_off

	SLEEPK	1
tdpof_1
	movi	dither_objs,a9,L
	move	*a9+,a8,L
	calla	obj_off
	move	*a9+,a8,L
	calla	obj_off
	move	*a9+,a8,L
	calla	obj_off
	move	*a9,a8,L
	calla	obj_off
	movi	dither_objs2,a9,L
	move	*a9+,a8,L
	calla	obj_on
	move	*a9+,a8,L
	calla	obj_on
	move	*a9+,a8,L
	calla	obj_on
	move	*a9,a8,L
	calla	obj_on

	SLEEPK	1

	move	@done_creating,a0			;exit CREATE PLAYER...?
	jrz	tdpof_2	

	movi	dither_objs2,a9,L
	move	*a9+,a8,L
	calla	obj_off
	move	*a9+,a8,L
	calla	obj_off
	move	*a9+,a8,L
	calla	obj_off
	move	*a9,a8,L
	calla	obj_off
	movi	dither_objs,a9,L
	move	*a9+,a8,L
	calla	obj_on
	move	*a9+,a8,L
	calla	obj_on
	move	*a9+,a8,L
	calla	obj_on
	move	*a9,a8,L
	calla	obj_on
	SLEEPK	1

	move	@done_creating,a0			;exit CREATE PLAYER...?
	jrnz	tdpof_1
tdpof_2
 	DIE

;-----------------------------------------------------------------------------
;	This routine creates the small box containing the players
; stats during "CREATE PLAEYR"
;-----------------------------------------------------------------------------
 SUBR	create_stats_area

	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel

;area backdrop
	movi	BBTXT,a2,L
	movi	[SBOXX,0],a0,L			;X coor.
	movi	[SBOXY,0],a1,L			;Y coor.
	movi	10,a3				;z pos (sorting)
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	calla	BEGINOBJ2

	movi	TUBESH,a2,L
	movi	15,a3				;z pos (sorting)
	movi	[SBOXX,0],a0,L			;X coor.
	movi	[SBOXY,0],a1,L			;Y coor.
	calla	BEGINOBJ2

	movi	TUBE02,a2,L
	movi	15,a3				;z pos (sorting)
	movi	[SBOXX,0],a0,L			;X coor.
	movi	[SBOXY,0],a1,L			;Y coor.
	calla	BEGINOBJ2

	movi	SPOTFL,a2,L
	movi	10,a3				;z pos (sorting)
	movi	[SBOXX,0],a0,L			;X coor.
	movi	[SBOXY-40,0],a1,L			;Y coor.
	calla	BEGINOBJ2
 	rets



	.asg		0,TITLE_BARX
	.asg		10,TITLE_BARY

;-----------------------------------------------------------------------------
;	Plots the screen length bar on screen
;
; INPUT: a0 - value for table reading
;-----------------------------------------------------------------------------
 SUBR	create_title_bar

	sll	7,a0
	addi	title_br_xy,a0
	move	*a0+,a1,L
	move	a1,b0				;pallete
	move	*a0+,a1,L			;Y pos
	move	*a0,a0,L			;X pos
	movi	TUBE01,a2,L
	movi	10,a3				;z pos (sorting)
	movi	DMAWNZ,a4		;DMA flags
;;	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	TITLE_BAR,a5			;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJP2
	rets

	;  x pos., Y pos, palette
title_br_xy
	.long	TUBEB_P,[TITLE_BARY,0],[TITLE_BARX,0],0	;option screen, create player
	.long	TUBE_R_P,[TITLE_BARY,0],[TITLE_BARX,0],0  ;hiscore page
	.long	TUBE_V_P,[TITLE_BARY,0],[TITLE_BARX,0],0  ;stat screen

;-----------------------------------------------------------------------------
; Prints title on title bar
;-----------------------------------------------------------------------------
 SUBR	print_title

	movi	char_design_str_setup,a2,L
	calla	setup_message
	movi	TITLE_BAR,a0
	move	a0,@mess_objid
	movk	10,a0
	move	a0,@mess_line_spacing
	movi	char_design_str,a4,L
	calla	print_string_C2
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_time_box

;	movi	SCRB_TX,a2,L
;	movi	[0,0],a0,L		;X coor.
;	movi	[5,0],a1,L		;Y coor.
;	movi	10,a3			;z pos (sorting)
;	movi	DMAWNZ|M_SCRNREL,a4	;DMA flags
;	clr	a5			;object ID
;	clr	a6			;x vel
;	clr	a7			;y vel
;	calla	BEGINOBJ2
 	rets

;-----------------------------------------------------------------------------
;	This routine prints "RECORD FOUND" or "RECORD NOT FOUND"
; based on passes parameter
;
; INPUT: a0 = flag of which message to print
;-----------------------------------------------------------------------------
 SUBR	print_record_availablity_msg

 	move	a0,a0
	jrnz	rnf_1
 	
;print 'record found'

	movi	record_found_str_setup,a2,L
	calla	setup_message
	move	*a13(PC_OBJID),a0
	move	a0,@mess_objid
	movi	record_found_str,a4,L
	calla	print_string_C2

	move	@mess_cursy,a0
	addk	15,a0
	move	a0,@mess_cursy
	movi	BAST_W_P,a0,L
	move	a0,@message_palette
	movi	record_found_str2,a4,L
	calla	print_string_C2
	jruc	dne_1

rnf_1

;print 'record not found'

	movi	record_not_found_str_setup,a2,L
	calla	setup_message
	move	*a13(PC_OBJID),a0
	move	a0,@mess_objid
	movi	record_not_found_str,a4,L
	calla	print_string_C2

	move	@mess_cursy,a0
	addk	15,a0
	move	a0,@mess_cursy
	movi	BAST_W_P,a0,L
	move	a0,@message_palette
	movi	record_not_found_str2,a4,L
	calla	print_string_C2
dne_1 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	print_ask_exit

	movi	exit_str_setup,a2,L
	calla	setup_message
	movi	BUTN_BOX_STUFF,a0
	move	a0,@mess_objid
	movi	exit_str,a4,L
	calla	print_string_C2
	rets

exit_str_setup
;	PRINT_STR	bast8t_ascii,4,0,185,72,BAST_W_P,0
	PRINT_STR	bast8t_ascii,4,0,185,69,BAST_W_P,0

exit_str
	.string	"DO YOU REALLY",1
	.string	"WANT TO EXIT",1
	.string	"CREATE PLAYER ?",0
	.even

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	print_ask_chg_nme

	movi	chgn_name_str_setup,a2,L
	calla	setup_message
	movi	BUTN_BOX_STUFF,a0
	move	a0,@mess_objid
	movi	chgn_name_str,a4,L
	calla	print_string_C2
	rets

chgn_name_str_setup
	PRINT_STR	bast8t_ascii,4,0,185,69,BAST_W_P,0

chgn_name_str
	.string	"DO YOU REALLY",1
	.string	"WANT TO CHANGE YOUR",1
	.string	"NAME AND PIN # ?",0
	.even


;-----------------------------------------------------------------------------
;	This routine prints the text when EXIT the CREATE PLAYER feature
;-----------------------------------------------------------------------------
 SUBR	print_goodbye_msg

    	move	@clock_minutes,a14,L
	jrnz	pgm_0

	movi	timeout_str_setup2,a2,L
	calla	setup_message
;	movi	BUTN_BOX_STUFF,a0
;	move	a0,@mess_objid
	movi	time_ranout_str,a4,L
	calla	print_string_C2
pgm_0

	movi	goodbye_str_setup,a2,L
	calla	setup_message
;	movi	BUTN_BOX_STUFF,a0
;	move	a0,@mess_objid
	movi	goodbye_str,a4,L
	calla	print_string_C2

	movi	goodbye_str_setup2,a2,L
	calla	setup_message
	movk	11,a0
	move	a0,@mess_line_spacing
	movi	goodbye_str2,a4,L
	calla	print_string_C2

	SLEEP	70
	movi	240,a10
pgm_1
	SLEEPK	1
	calla	get_all_buttons_cur
	jrnz	pgm_2
	dsj	a10,pgm_1
pgm_2
	callr	del_butn_box_stuff
	RETP

;-----------------------------------------------------------------------------
; This routine plots all the instructions for the hi-lited button, after the
;  players hits a button to begin editing
;-----------------------------------------------------------------------------
 SUBR	create_a9_butn_instructions		;a9 =butn instructions to plot

	callr	del_butn_info_text
	jruc	cii_1

 SUBR	create_butn_instructions
 	
 	callr	del_butn_info_text
	move	@butn_cursor_pos,a9		;get hi-lited butn nbr.
cii_1	sll	7,a9				;*128 (4 longs)
	addi	butn_instructions_table,a9,L

;print TITLE
	move	*a9+,a2,L			;get string setup table addr.
	calla	setup_message
	movi	BUTN_BOX_STUFF,a0			;object ID
	move	a0,@mess_objid
	move	*a9+,a4,L			;get string addr. to blit
	calla	print_string_C2

;print INSTRUCTIONS
	move	*a9+,a2,L			;get string setup table addr.
	cmpi	-1,a2				;if negative...no instructions
	jreq	noint_1
	calla	setup_message
	movi	BUTN_BOX_INST,a0			;object ID
	move	a0,@mess_objid
	movk	10,a0
	move	a0,@mess_line_spacing
	move	*a9,a4,L			;get string addr. to blit
	calla	print_string_C2
noint_1
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	turn_off_name_objs

	move	*a13(PC_NAM1OBJ),a8,L
	calla	obj_off
	move	*a13(PC_NAM2OBJ),a8,L
	calla	obj_off
	move	*a13(PC_NAM3OBJ),a8,L
	calla	obj_off
	move	*a13(PC_NAM4OBJ),a8,L
	calla	obj_off
	move	*a13(PC_NAM5OBJ),a8,L
	calla	obj_off
	move	*a13(PC_NAM6OBJ),a8,L
	calla	obj_off
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	print_privileges_info

	movi	privileges_str_setup,a2,L
	calla	setup_message
	movi	BUTN_PRIV_INST,a0
	move	a0,@mess_objid
	movi	privileges_str,a4,L
	calla	print_string_C2
	rets

;-----------------------------------------------------------------------------
;     This creates the name characters (echo) when player enters his/her name
; during ENTER NAME menu
;
; INPUT: a5 = object ID
;-----------------------------------------------------------------------------
 SUBR	create_name_objs

 	PUSH	a6
	move	a13,a1
	addi	PC_NAM1OBJ,a1
;	addi	PC_LTR1OBJ,a1
	movk	NAME_LETTERS,a2		;6 letters allowed for name
cnl_1
	PUSH	a0,a1,a2,a5

;change Y val based on mode
	movi	[400h | (213-7),0],a1		;assume not in CREATE Plyr (y val)
	move	@GAMSTATE,a0
	cmpi	INPLYRDESIGN,a0
	jrne	cnl_1a		      		;not in CREATE PLAYER
	movi	[222|400h,0],a1			;y val

cnl_1a	clr	a0				;x val
	movi	BAST10DSH,a2			;* image
	movi	100,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	PULL	a0,a1,a2,a5
	move	a8,*a1+,L			;save * object
	addi	[12,0],a0
	dsj	a2,cnl_1
	PULL	a6
	rets

;-----------------------------------------------------------------------------
;	 This routine prints the players name as its being entered during
; ENTER INITIALS menu
;-----------------------------------------------------------------------------
 SUBR	print_players_name

	clr	a5
	movk	1,a7				;num objs

	callr	turn_off_name_objs

	move	*a13(PC_DATADDR),a2,L		;start of player data

;first char. of name
	move	*a2+,a0
	move	*a13(PC_NAM1OBJ),a8,L
	move	*a8(OIMG),a0,L
	cmpi	BAST10SPC,a0
	jreq	#is_space1
	calla	obj_on
#is_space1
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

;second char. of name
	move	*a2+,a0
;;;;	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_NAM2OBJ),a8,L
	move	*a8(OIMG),a0,L
	cmpi	BAST10SPC,a0
	jreq	#is_space2
	calla	obj_on
#is_space2
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

;third char. of name
	move	*a2+,a0
;;;;	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_NAM3OBJ),a8,L
	move	*a8(OIMG),a0,L
	cmpi	BAST10SPC,a0
	jreq	#is_space3
	calla	obj_on
#is_space3
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

;fourth char. of name
	move	*a2+,a0
;;;;	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_NAM4OBJ),a8,L
	move	*a8(OIMG),a0,L
	cmpi	BAST10SPC,a0
	jreq	#is_space4
	calla	obj_on
#is_space4
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

;fifth char. of name
	move	*a2+,a0
;;;;	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_NAM5OBJ),a8,L
	move	*a8(OIMG),a0,L
	cmpi	BAST10SPC,a0
	jreq	#is_space5
	calla	obj_on
#is_space5
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

;sixth char. of name
	move	*a2+,a0
;;;;	jrn	#skip
	inc	a7
	addk	2,a5				;+ 2 pixel space
	move	*a13(PC_NAM6OBJ),a8,L
	move	*a8(OIMG),a0,L
	cmpi	BAST10SPC,a0
;	cmpi	OSGEMD_SPC,a0
	jreq	#is_space6
	calla	obj_on
#is_space6
	move	*a8(OSIZEX),a0			;width of object
	add	a0,a5

;seventh char. of name
;	move	*a2,a0
;	jrn	#skip
;	inc	a7
;	addk	2,a5				;+ 2 pixel space
;	move	*a13(PC_NAM7OBJ),a8,L
;	move	*a8(OIMG),a0,L
;	cmpi	OSGEMD_SPC,a0
;	jreq	#is_space7
;	calla	obj_on
;#is_space7
;	move	*a8(OSIZEX),a0			;width of object
;	add	a0,a5

#skip
	inc	a5				;+ 1/2
	srl	1,a5				;width / 2
	move	*a13(PC_CENTERX2),a6

	move	@TWOPLAYERS,a0			;0 = NO, 1 = YES 2 players
	jrz	#no_2p
	move	*a13(PC_CENTERXkit),a6
#no_2p
	sub	a5,a6				;center - width/2
	movi	PC_NAM1OBJ,a4
	add	a13,a4
decmr_1
	move	*a4+,a2,L		;* object
	move	a6,*a2(OXPOS)
	move	*a2(OSIZEX),a0		;width of object
	add	a0,a6
;	addk	2,a6			;2 pixel spacing
	addk	1,a6			;1 pixel spacing
	dsj	a7,decmr_1		;another img?
	rets



	.asg	210,START_WEIGHT
	.asg	5,HT_WGHT_INC
	.asg	5,WEIGHT_INC

;-----------------------------------------------------------------------------
;   This routine prints the players body dimensions...under player dribbling
; ball
;-----------------------------------------------------------------------------
 SUBR	print_body_dimensions

	PUSH	a10
	movi	BODY_STYLE_STR,a0
	calla	obj_del1c			;delete OLD body style string

;print height
	movi	body_height_str_setup,a2,L
	calla	setup_message
	movi	BODY_STYLE_STR,a0
	move	a0,@mess_objid

;compute which string to use
	move	@height_points,a10
	move	a10,a14
	sll	5,a10
	sll	4,a14
	add	a14,a10
	addi	body_height_str_table,a10
	move	*a10+,a4,L
	calla	print_string_C2

;print weight
	movi	body_weight_str_setup,a2,L
	calla	setup_message
	movi	BODY_STYLE_STR,a0
	move	a0,@mess_objid

	move	*a10+,a0			;get weight value
	move	@weight_points,a14		;get current WEIGHT factor
	sll	4,a14				;mult. by 32
	addi	body_weight_str_table,a14
	move	*a14,a14
	add	a14,a0

	movi	999,a1			;max value
	calla	dec_to_asc
	calla	copy_string
	movi	lbs_str,a4,L
	calla	concat_rom_string
	calla	print_string_C		;centered

	PULL	a10
	rets

;
; The following tables are for the players 'BODY SIZE' strings
;
body_height_str_setup
	PRINT_STR	bast8t_ascii,4,0,305,194,BAST_W_P,0	;height

body_weight_str_setup
	PRINT_STR	bast8t_ascii,4,0,356,194,BAST_W_P,0	;weight


body_height_str_table
	LW	body_height_str_0,START_WEIGHT-6*HT_WGHT_INC
	LW	body_height_str_1,START_WEIGHT-5*HT_WGHT_INC
	LW	body_height_str_2,START_WEIGHT-4*HT_WGHT_INC
	LW	body_height_str_3,START_WEIGHT-3*HT_WGHT_INC
	LW	body_height_str_4,START_WEIGHT-2*HT_WGHT_INC
	LW	body_height_str_5,START_WEIGHT-1*HT_WGHT_INC
	LW	body_height_str_6,START_WEIGHT
	LW	body_height_str_7,START_WEIGHT+2*HT_WGHT_INC
	LW	body_height_str_8,START_WEIGHT+3*HT_WGHT_INC
	LW	body_height_str_9,START_WEIGHT+4*HT_WGHT_INC
	LW	body_height_str_10,START_WEIGHT+5*HT_WGHT_INC

body_weight_str_table
	.word	WEIGHT_INC*-4
	.word	WEIGHT_INC*-3
	.word	WEIGHT_INC*-2
	.word	WEIGHT_INC*-1
	.word	WEIGHT_INC*0
	.word	WEIGHT_INC*2
	.word	WEIGHT_INC*4
	.word	WEIGHT_INC*6
	.word	WEIGHT_INC*8
	.word	WEIGHT_INC*10
	.word	WEIGHT_INC*12

lbs_str
	.string	" LBS.",0
	.even


body_height_str_0
	.string	"5' 7''",0
	.even
body_height_str_1
	.string	"5' 9''",0
	.even
body_height_str_2
	.string	"5' 11''",0
	.even
body_height_str_3
	.string	"6' 0''",0
	.even
body_height_str_4
	.string	"6' 2''",0
	.even
body_height_str_5
	.string	"6' 4''",0
	.even
body_height_str_6
	.string	"6' 8''",0
	.even
body_height_str_7
	.string	"6' 11''",0
	.even
body_height_str_8
	.string	"7' 2''",0
	.even
body_height_str_9
	.string	"7' 4''",0
	.even
body_height_str_10
	.string	"7' 6''",0
	.even


;-----------------------------------------------------------------------------
;  This routine displays the appropiate text for the currently hi-lited butn
;-----------------------------------------------------------------------------
 SUBR	print_butn_information

 	callr	del_butn_info_text
	move	@butn_cursor_pos,a9		;get hi-lited butn nbr.
	sll	6,a9
	addi	butn_str_setup_addr_table,a9,L
	move	*a9+,a2,L			;get string setup table addr.
	calla	setup_message
	movi	CLSDEAD|123,a0
	move	a0,@mess_objid
	movk	10,a0
	move	a0,@mess_line_spacing
	move	*a9,a4,L			;get string addr. to blit
	calla	print_string_C2
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_butn_info_text

;	movi	CYCPID,a0
;	calla	KIL1C

	movi	CLSDEAD|123,a0
	clr	a1
	calla	obj_del1c
	rets

;-----------------------------------------------------------------------------
;          This routine deletes all objects pertaining to the butn
;-----------------------------------------------------------------------------
 SUBR	del_butn_box_stuff

	movi	BUTN_BOX_INST,a0
	clr	a1				;mask
	calla	obj_del1c			;delete all objs with this ID

	movi	BUTN_PRIV_INST,a0
	clr	a1				;mask
	calla	obj_del1c			;delete all objs with this ID

	movi	BUTN_BOX_STUFF,a0			;object ID
	clr	a1				;mask
	calla	obj_del1c			;delete all objs with this ID
	rets


;-----------------------------------------------------------------------------
; 	This PROCESS handles the timing of the CREATE PLAYER mode
;
; id = CLOCK_PID
;-----------------------------------------------------------------------------
 SUBR	timedown_clock

	clr	a14
	move	a14,@clock_seconds		;initial value :00
	movk	2,a14
	move	a14,@clock_minutes

	callr	create_clock_objs

	SLEEP	70			;wait for transition to finish..etc
tcpt_0
	move	@clock_minutes,a14
	jrnz	tcpt_1a
	move	@clock_seconds,a14
	subk	20,a14
	jrgt	tcpt_1a				;br=only make sounds < 30 sec.
	SOUND1	cntdown_snd
	movi	TSEC+45,a8
	jruc	tcpt_1
tcpt_1a	

	movi	TSEC,a8
tcpt_1 	SLEEPK	1
	move	@stop_clock,a14			;check every second (liberal)
	jrnz	tcpt_1				;br=dont time down
	dsj	a8,tcpt_1

;	move	@clock_minutes,a14
;	jrnz	tcpt_1a
;	move	@clock_seconds,a14
;	cmpi	20,a14
;	jrhi	tcpt_1a				;br=only make sounds < 30 sec.
;	SOUND1	cntdown_snd
;tcpt_1a	
	move	@clock_seconds,a14
	dec	a14
	jrge	tcpt_2				;br=seconds >= 0

	move	@clock_minutes,a14
	dec	a14
	jrn	tcpt_3				;br=at 0:00 - time out!!!
	move	a14,@clock_minutes

	calla	update_clock_minute_imgs

	movi	59,a14				;reset seconds
tcpt_2
	move	a14,@clock_seconds		;save new SECONDS count
	calla	update_clock_seconds_imgs
	jruc	tcpt_0

tcpt_3	
	callr	del_clock_objs
	clr	a0
	move	a0,@done_creating			;exit CREATE PLAYER...
	DIE

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	del_clock_objs

 	movi	CREATE_PLYR_TIMER,a0
	calla	obj_del1c
	rets

;-----------------------------------------------------------------------------
;	This routine creates the images for the clock during
; create player
;
; RETURN:  reg a9 - 1st digit of sec. obj. ptr.
;         reg a10 - 2nd digit of sec. obj. ptr.
;         reg a11 - minute obj. ptr.
;-----------------------------------------------------------------------------
 SUBR	create_clock_objs
 	
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	CREATE_PLYR_TIMER,a5		;object ID
	clr	a6				;x vel
	clr	a7				;y vel

;backdrop
	movi	[TITLE_BARX+293,0],a0
	movi	[TITLE_BARY-1,0],a1
	movi	TIMEPRT,a2,L
	movi	1400,a3				;z pos (sorting)
	calla	BEGINOBJ2

;create time digits (minutes : seconds)
;minutes
	movi	1600,a3				;z pos (sorting)
	movi	BRSH1802,a2,L
	movi	[TITLE_BARX+311,0],a0			;X coor.
	movi	[TITLE_BARY-3,0],a1			;Y coor.
	calla	BEGINOBJ2
	move	a8,a11
;colon
	movi	BRSH18CO,a2,L
	movi	[TITLE_BARX+324,0],a0			;X coor.
	movi	[TITLE_BARY-3,0],a1			;Y coor.
	calla	BEGINOBJ2

;2nd digit of seconds
	movi	BRSH1800,a2,L
	movi	[TITLE_BARX+356,0],a0			;X coor.
	movi	[TITLE_BARY-3,0],a1			;Y coor.
	calla	BEGINOBJ2
	move	a8,a10

;1st digit of seconds
	movi	BRSH1800,a2,L
	movi	[TITLE_BARX+338,0],a0			;X coor.
	movi	[TITLE_BARY-3,0],a1			;Y coor.
	calla	BEGINOBJ2
	move	a8,a9
	rets

;-----------------------------------------------------------------------------
;	This routine reads the CLOCK ram values and converts them to single
; digits, then updates the clock objects to match
;
; INPUT: reg a11 - ptr. to minutes obj.
;-----------------------------------------------------------------------------
 SUBR	update_clock_minute_imgs

	move	@clock_minutes,a0
	jrnz	min_0
	move	a11,a8
	calla	obj_off				;dont show '0' minutes
	jruc	min_1

min_0	sll	5,a0
	addi	timer_img_table,a0,L
	move	*a0,a0,L			;ptr. to NEW minute image
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	move	a11,a8
	calla	obj_aniq
min_1	rets

;-----------------------------------------------------------------------------
;	This routine reads the CLOCK ram values and converts them to single
; digits, then updates the clock objects to match
;
; INPUT:  reg a9 - ptr. to 1st digit of seconds obj. ptr
;	 reg a10 - ptr. to 2nd digit of seconds obj. ptr
;-----------------------------------------------------------------------------
 SUBR	update_clock_seconds_imgs

; Seperate SECONDS into 2 digits
min_2
	clr	a0			;reset counter
	move	@clock_seconds,a14	;get new SECONDS count
	cmpi	10,a14
	jrlt	div_dne			;seconds < 10 (0 1st digit)
div_10
	inc	a0			;a0 will become the 1st digit
	subk	10,a14			;a14 will become the 2nd digit
	cmpi	10,a14
	jrhs	div_10			;timer > 10 sec. still
div_dne
	sll	5,a0			;compute offset into table (1st digit)
	sll	5,a14			;compute offset into table (2nd digit)
	movi	timer_img_table,a1,L
	add	a1,a0			;a0 = table addr. of digit
	add	a1,a14			;a14 = table addr. of digit
	move	*a0,a0,L		;a0 = img. pointer of 1st digit
	move	*a14,a2,L		;a14 = img. pointer of 2nd digit
;
; Update first digit of seconds
;
secs_1
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	move	a9,a8
	calla	obj_aniq
;
; Update second digit of seconds
;
	move	a2,a0
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	move	a10,a8
	calla	obj_aniq
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	create_pick_head_objs

	movi	20,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	BUTN_BOX_STUFF,a5		;object class
	clr	a6				;x vel
	clr	a7				;y vel

;create divider bar
	movi	TUBE02,a2,L
	movi	[BBOXX+5,0],a0,L		;X coor.
	movi	[BBOXY+47,0],a1,L		;X coor.
	calla	BEGINOBJ2

;create HEAD backdrop
	movi	[BBOXX+5,0],a0
	movi	[BBOXY+61,0],a1			;y val
	movi	HDSPTLT,a2,L
	calla	BEGINOBJ2

;create	BIG HEAD backdrop
	movi	[BBOXX+5,0],a0
	movi	[BBOXY+122,0],a1		;y val
	movi	HDSPTLT2,a2,L
	calla	BEGINOBJ2

;create bottom divider bar
	movi	40,a3				;z pos
	movi	TUBE02,a2,L
	movi	[BBOXX+5,0],a0,L		;X coor.
	movi	[BBOXY+189,0],a1,L		;X coor.
	calla	BEGINOBJ2

;create HEAD cursor bar
	movi	50,a3				;z pos
	movi	[BBOXX+5,0],a0			;x val of first head
	movi	[BBOXY+107,0],a1		;y val
	movi	HDBAR,a2,L
	calla	BEGINOBJ2
	rets

;-----------------------------------------------------------------------------
;  This routine creates the OBJECT (bar) until the total points fraction
; during the ADJUST ATTRIBUTES option
;
; INPUT: reg a0 - table offset for positing the bar
;-----------------------------------------------------------------------------
 SUBR	create_divider_bar

	sll	6,a0
	addi	divider_bar_xys,a0,L
	move	*a0+,a1,L			;get Y coor.
	move	*a0,a0,L			;get X coor.
	movi	TOTALBR,a2,L
	movk	15,a3				;z pos
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	movi	BUTN_BOX_STUFF,a5		;object class
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
 	rets


;----------- TABLES ------------
;----------- TABLES ------------
;----------- TABLES ------------
;----------- TABLES ------------

;
; This table contains the HEIGHT scale table pointers
;
body_scale_table
	.long	scale_plyr_57	;height=0
	.long	scale_plyr_59	;1
	.long	scale_plyr_511	;2
	.long	scale_plyr_60	;3
	.long	scale_plyr_62	;4
	.long	scale_plyr_64	;5
	.long	scale_plyr_68	;6
	.long	scale_plyr_611	;7
	.long	scale_plyr_72	;8
	.long	scale_plyr_74	;9
	.long	scale_plyr_76	;10

scale_plyr_57
	.long	scale57et_t,scale57et_t,scale57t_t,scale57_t,scale57f_t,scale57ef_t
scale_plyr_59
	.long	scale59et_t,scale59et_t,scale59t_t,scale59_t,scale59f_t,scale59ef_t
scale_plyr_511
	.long	scale511et_t,scale511et_t,scale511t_t,scale511_t,scale511f_t,scale511ef_t
scale_plyr_60
	.long	scale60et_t,scale60et_t,scale60t_t,scale60_t,scale60f_t,scale60ef_t
scale_plyr_62
	.long	scale62et_t,scale62et_t,scale62t_t,scale62_t,scale62f_t,scale62ef_t
scale_plyr_64
	.long	scale64et_t,scale64et_t,scale64t_t,scale64_t,scale64f_t,scale64ef_t
scale_plyr_68
	.long	scale68et_t,scale68et_t,scale68t_t,scale68_t,scale68f_t,scale68ef_t
scale_plyr_611
	.long	scale611et_t,scale611et_t,scale611t_t,scale611_t,scale611f_t,scale611ef_t
scale_plyr_72
	.long	scale72et_t,scale72et_t,scale72t_t,scale72_t,scale72f_t,scale72ef_t
scale_plyr_74
	.long	scale74et_t,scale74et_t,scale74t_t,scale74_t,scale74f_t,scale74ef_t
scale_plyr_76
	.long	scale76et_t,scale76et_t,scale76t_t,scale76_t,scale76f_t,scale76ef_t


divider_bar_xys
	.long	[BBOXY+56,0],[BBOXX+5,0]		;y,x (attributes)
	.long	[BBOXY+174,0],[BBOXX+5,0]		;y,x (enter name/pin nbr)
	.long	[BBOXY+25,0],[BBOXX+5,0]		;y,x (enter name/pin nbr)
	.long	[BBOXY+62,0],[BBOXX+5,0]		;y,x (privileges)
	.long	[BBOXY+55,0],[BBOXX+5,0]		;y,x (nick name)
	.long	[BBOXY+41,0],[BBOXX+5,0]		;y,x (stats)

BRSH18R_P:
   .word   14 
   .word   0318ch,07c62h,07441h,06c41h,06421h,05c20h,05400h,04c00h
   .word   04400h,03c00h,03400h,02c00h,02400h,00400h


;palette_flash_table
;	.long	yes_pal_flash_table		;0  YES
;	.long	no_pal_flash_table		;1  NO


yes_pal_flash_table
	.long	YESP_P
	.long	YESP_P
	.long	YESP15_P
	.long	YESP15_P
	.long	YESP_P
	.long	YESP_P
	.long	YESP15_P
	.long	YESP15_P

	.long	YESP14_P
	.long	YESP13_P
	.long	YESP12_P
	.long	YESP11_P
	.long	YESP10_P
	.long	YESP09_P
	.long	YESP08_P
	.long	YESP07_P
	.long	YESP06_P
	.long	YESP05_P
	.long	YESP04_P
	.long	YESP03_P
	.long	YESP02_P
	.long	YESP01_P
	.long	YESP_P
yes_pal_flash_table_end


no_pal_flash_table
	.long	NOP_P
	.long	NOP_P
	.long	NOP15_P
	.long	NOP15_P
	.long	NOP_P
	.long	NOP_P
	.long	NOP15_P
	.long	NOP15_P

	.long	NOP14_P
	.long	NOP13_P
	.long	NOP12_P
	.long	NOP11_P
	.long	NOP10_P
	.long	NOP09_P
	.long	NOP08_P
	.long	NOP07_P
	.long	NOP06_P
	.long	NOP05_P
	.long	NOP04_P
	.long	NOP03_P
	.long	NOP02_P
	.long	NOP01_P
	.long	NOP_P
no_pal_flash_table_end

NUM_PALS_Y	.equ	(yes_pal_flash_table_end-yes_pal_flash_table)/32
NUM_PALS_N	.equ	(no_pal_flash_table_end-no_pal_flash_table)/32


;
; These are SOURCE palettes for the above table
;
YESP01_P:
   .word   64 
   .word   024a8h,04ff3h,043f0h,03beeh,033ech,02beah,023e8h,017e5h
   .word   00fe3h,00fe3h,00fc3h,00ba2h,00b82h,00b42h,00b22h,00b02h
   .word   00ae2h,00ac2h,00aa2h,00a82h,00a62h,00a42h,00a22h,00a02h
   .word   009e2h,009c2h,009a2h,00982h,00962h,00942h,00922h,00922h
   .word   01642h,01a62h,01e62h,02282h,026a2h,02ec2h,032e2h,03b02h
   .word   04322h,04742h,04f62h,05782h,05fa2h,06bc2h,073e2h,07be2h
   .word   07fe2h,07fe2h,07fa2h,07b82h,07742h,07322h,072e2h,06ec2h
   .word   06aa2h,06662h,06242h,05e22h,05e02h,05a82h,04aa2h,036a2h

YESP02_P:
   .word   64 
   .word   024a8h,057f5h,04bf2h,043f0h,03beeh,033ech,02beah,01fe7h
   .word   017e5h,017e5h,017e5h,013e4h,013c4h,01384h,01364h,01344h
   .word   01324h,01304h,012e4h,012c4h,012a4h,01284h,01264h,01244h
   .word   01224h,01204h,011e4h,011c4h,011a4h,01184h,01164h,01164h
   .word   01e84h,022a4h,026a4h,02ac4h,02ee4h,03704h,03b24h,04344h
   .word   04b64h,04f84h,057a4h,05fc4h,067e4h,073e4h,07be4h,07fe4h
   .word   07fe4h,07fe4h,07fe4h,07fc4h,07f84h,07b64h,07b24h,07704h
   .word   072e4h,06ea4h,06a84h,06664h,06644h,062c4h,052e4h,03ee4h

YESP03_P:
   .word   64 
   .word   024a8h,05ff7h,053f4h,04bf2h,043f0h,03beeh,033ech,027e9h
   .word   01fe7h,01fe7h,01fe7h,01be6h,01be6h,01bc6h,01ba6h,01b86h
   .word   01b66h,01b46h,01b26h,01b06h,01ae6h,01ac6h,01aa6h,01a86h
   .word   01a66h,01a46h,01a26h,01a06h,019e6h,019c6h,019a6h,019a6h
   .word   026c6h,02ae6h,02ee6h,03306h,03726h,03f46h,04366h,04b86h
   .word   053a6h,057c6h,05fe6h,067e6h,06fe6h,07be6h,07fe6h,07fe6h
   .word   07fe6h,07fe6h,07fe6h,07fe6h,07fc6h,07fa6h,07f66h,07f46h
   .word   07b26h,076e6h,072c6h,06ea6h,06e86h,06b06h,05b26h,04726h

YESP04_P:
   .word   64 
   .word   024a8h,067f9h,05bf6h,053f4h,04bf2h,043f0h,03beeh,02febh
   .word   027e9h,027e9h,027e9h,023e8h,023e8h,023e8h,023e8h,023c8h
   .word   023a8h,02388h,02368h,02348h,02328h,02308h,022e8h,022c8h
   .word   022a8h,02288h,02268h,02248h,02228h,02208h,021e8h,021e8h
   .word   02f08h,03328h,03728h,03b48h,03f68h,04788h,04ba8h,053c8h
   .word   05be8h,05fe8h,067e8h,06fe8h,077e8h,07fe8h,07fe8h,07fe8h
   .word   07fe8h,07fe8h,07fe8h,07fe8h,07fe8h,07fe8h,07fa8h,07f88h
   .word   07f68h,07f28h,07b08h,076e8h,076c8h,07348h,06368h,04f68h

YESP05_P:
   .word   64 
   .word   024a8h,06ffbh,063f8h,05bf6h,053f4h,04bf2h,043f0h,037edh
   .word   02febh,02febh,02febh,02beah,02beah,02beah,02beah,02beah
   .word   02beah,02bcah,02baah,02b8ah,02b6ah,02b4ah,02b2ah,02b0ah
   .word   02aeah,02acah,02aaah,02a8ah,02a6ah,02a4ah,02a2ah,02a2ah
   .word   0374ah,03b6ah,03f6ah,0438ah,047aah,04fcah,053eah,05beah
   .word   063eah,067eah,06feah,077eah,07feah,07feah,07feah,07feah
   .word   07feah,07feah,07feah,07feah,07feah,07feah,07feah,07fcah
   .word   07faah,07f6ah,07f4ah,07f2ah,07f0ah,07b8ah,06baah,057aah

YESP06_P:
   .word   64 
   .word   024a8h,077fdh,06bfah,063f8h,05bf6h,053f4h,04bf2h,03fefh
   .word   037edh,037edh,037edh,033ech,033ech,033ech,033ech,033ech
   .word   033ech,033ech,033ech,033cch,033ach,0338ch,0336ch,0334ch
   .word   0332ch,0330ch,032ech,032cch,032ach,0328ch,0326ch,0326ch
   .word   03f8ch,043ach,047ach,04bcch,04fech,057ech,05bech,063ech
   .word   06bech,06fech,077ech,07fech,07fech,07fech,07fech,07fech
   .word   07fech,07fech,07fech,07fech,07fech,07fech,07fech,07fech
   .word   07fech,07fach,07f8ch,07f6ch,07f4ch,07fcch,073ech,05fech

YESP07_P:
   .word   64 
   .word   024a8h,07fffh,073fch,06bfah,063f8h,05bf6h,053f4h,047f1h
   .word   03fefh,03fefh,03fefh,03beeh,03beeh,03beeh,03beeh,03beeh
   .word   03beeh,03beeh,03beeh,03beeh,03beeh,03bceh,03baeh,03b8eh
   .word   03b6eh,03b4eh,03b2eh,03b0eh,03aeeh,03aceh,03aaeh,03aaeh
   .word   047ceh,04beeh,04feeh,053eeh,057eeh,05feeh,063eeh,06beeh
   .word   073eeh,077eeh,07feeh,07feeh,07feeh,07feeh,07feeh,07feeh
   .word   07feeh,07feeh,07feeh,07feeh,07feeh,07feeh,07feeh,07feeh
   .word   07feeh,07feeh,07fceh,07faeh,07f8eh,07feeh,07beeh,067eeh

YESP08_P:
   .word   64 
   .word   024a8h,07fffh,07bfeh,073fch,06bfah,063f8h,05bf6h,04ff3h
   .word   047f1h,047f1h,047f1h,043f0h,043f0h,043f0h,043f0h,043f0h
   .word   043f0h,043f0h,043f0h,043f0h,043f0h,043f0h,043f0h,043d0h
   .word   043b0h,04390h,04370h,04350h,04330h,04310h,042f0h,042f0h
   .word   04ff0h,053f0h,057f0h,05bf0h,05ff0h,067f0h,06bf0h,073f0h
   .word   07bf0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07fd0h,07ff0h,07ff0h,06ff0h

YESP09_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07bfeh,073fch,06bfah,063f8h,057f5h
   .word   04ff3h,04ff3h,04ff3h,04bf2h,04bf2h,04bf2h,04bf2h,04bf2h
   .word   04bf2h,04bf2h,04bf2h,04bf2h,04bf2h,04bf2h,04bf2h,04bf2h
   .word   04bf2h,04bd2h,04bb2h,04b92h,04b72h,04b52h,04b32h,04b32h
   .word   057f2h,05bf2h,05ff2h,063f2h,067f2h,06ff2h,073f2h,07bf2h
   .word   07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h
   .word   07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h
   .word   07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,077f2h

YESP10_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07bfeh,073fch,06bfah,05ff7h
   .word   057f5h,057f5h,057f5h,053f4h,053f4h,053f4h,053f4h,053f4h
   .word   053f4h,053f4h,053f4h,053f4h,053f4h,053f4h,053f4h,053f4h
   .word   053f4h,053f4h,053f4h,053d4h,053b4h,05394h,05374h,05374h
   .word   05ff4h,063f4h,067f4h,06bf4h,06ff4h,077f4h,07bf4h,07ff4h
   .word   07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h
   .word   07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h
   .word   07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h

YESP11_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07bfeh,073fch,067f9h
   .word   05ff7h,05ff7h,05ff7h,05bf6h,05bf6h,05bf6h,05bf6h,05bf6h
   .word   05bf6h,05bf6h,05bf6h,05bf6h,05bf6h,05bf6h,05bf6h,05bf6h
   .word   05bf6h,05bf6h,05bf6h,05bf6h,05bf6h,05bd6h,05bb6h,05bb6h
   .word   067f6h,06bf6h,06ff6h,073f6h,077f6h,07ff6h,07ff6h,07ff6h
   .word   07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h
   .word   07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h
   .word   07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h

YESP12_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07fffh,07bfeh,06ffbh
   .word   067f9h,067f9h,067f9h,063f8h,063f8h,063f8h,063f8h,063f8h
   .word   063f8h,063f8h,063f8h,063f8h,063f8h,063f8h,063f8h,063f8h
   .word   063f8h,063f8h,063f8h,063f8h,063f8h,063f8h,063f8h,063f8h
   .word   06ff8h,073f8h,077f8h,07bf8h,07ff8h,07ff8h,07ff8h,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h

YESP13_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,077fdh
   .word   06ffbh,06ffbh,06ffbh,06bfah,06bfah,06bfah,06bfah,06bfah
   .word   06bfah,06bfah,06bfah,06bfah,06bfah,06bfah,06bfah,06bfah
   .word   06bfah,06bfah,06bfah,06bfah,06bfah,06bfah,06bfah,06bfah
   .word   077fah,07bfah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah
   .word   07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah
   .word   07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah
   .word   07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah

YESP14_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   077fdh,077fdh,077fdh,073fch,073fch,073fch,073fch,073fch
   .word   073fch,073fch,073fch,073fch,073fch,073fch,073fch,073fch
   .word   073fch,073fch,073fch,073fch,073fch,073fch,073fch,073fch
   .word   07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch
   .word   07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch
   .word   07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch
   .word   07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch

YESP15_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fffh,07fffh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh
   .word   07bfeh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh
   .word   07bfeh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh,07bfeh
   .word   07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh
   .word   07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh
   .word   07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh
   .word   07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh


NOP01_P:
   .word   64 
   .word   024a8h,07e73h,07e10h,07dceh,07d8ch,07d4ah,07d08h,07ca5h
   .word   07c63h,07c42h,07c42h,07842h,07042h,06c42h,06442h,06042h
   .word   05c42h,05842h,05442h,05042h,04c42h,04842h,04442h,04042h
   .word   03c42h,03842h,03442h,03042h,02c42h,02842h,02442h,02442h
   .word   048a2h,04cc2h,04ce2h,05102h,05522h,05962h,05d82h,061c2h
   .word   06602h,06a22h,06e62h,072a2h,076e2h,07b42h,07f82h,07fc2h
   .word   07fe2h,07fe2h,07fa2h,07b82h,07742h,07722h,072e2h,06ec2h
   .word   06aa2h,06662h,06642h,06222h,05e02h,059e2h,055c2h,055a2h

NOP02_P:
   .word   64 
   .word   024a8h,07eb5h,07e52h,07e10h,07dceh,07d8ch,07d4ah,07ce7h
   .word   07ca5h,07c84h,07c84h,07c84h,07884h,07484h,06c84h,06884h
   .word   06484h,06084h,05c84h,05884h,05484h,05084h,04c84h,04884h
   .word   04484h,04084h,03c84h,03884h,03484h,03084h,02c84h,02c84h
   .word   050e4h,05504h,05524h,05944h,05d64h,061a4h,065c4h,06a04h
   .word   06e44h,07264h,076a4h,07ae4h,07f24h,07f84h,07fc4h,07fe4h
   .word   07fe4h,07fe4h,07fe4h,07fc4h,07f84h,07f64h,07b24h,07704h
   .word   072e4h,06ea4h,06e84h,06a64h,06644h,06224h,05e04h,05de4h

NOP03_P:
   .word   64 
   .word   024a8h,07ef7h,07e94h,07e52h,07e10h,07dceh,07d8ch,07d29h
   .word   07ce7h,07cc6h,07cc6h,07cc6h,07cc6h,07cc6h,074c6h,070c6h
   .word   06cc6h,068c6h,064c6h,060c6h,05cc6h,058c6h,054c6h,050c6h
   .word   04cc6h,048c6h,044c6h,040c6h,03cc6h,038c6h,034c6h,034c6h
   .word   05926h,05d46h,05d66h,06186h,065a6h,069e6h,06e06h,07246h
   .word   07686h,07aa6h,07ee6h,07f26h,07f66h,07fc6h,07fe6h,07fe6h
   .word   07fe6h,07fe6h,07fe6h,07fe6h,07fc6h,07fa6h,07f66h,07f46h
   .word   07b26h,076e6h,076c6h,072a6h,06e86h,06a66h,06646h,06626h

NOP04_P:
   .word   64 
   .word   024a8h,07f39h,07ed6h,07e94h,07e52h,07e10h,07dceh,07d6bh
   .word   07d29h,07d08h,07d08h,07d08h,07d08h,07d08h,07d08h,07908h
   .word   07508h,07108h,06d08h,06908h,06508h,06108h,05d08h,05908h
   .word   05508h,05108h,04d08h,04908h,04508h,04108h,03d08h,03d08h
   .word   06168h,06588h,065a8h,069c8h,06de8h,07228h,07648h,07a88h
   .word   07ec8h,07ee8h,07f28h,07f68h,07fa8h,07fe8h,07fe8h,07fe8h
   .word   07fe8h,07fe8h,07fe8h,07fe8h,07fe8h,07fe8h,07fa8h,07f88h
   .word   07f68h,07f28h,07f08h,07ae8h,076c8h,072a8h,06e88h,06e68h

NOP05_P:
   .word   64 
   .word   024a8h,07f7bh,07f18h,07ed6h,07e94h,07e52h,07e10h,07dadh
   .word   07d6bh,07d4ah,07d4ah,07d4ah,07d4ah,07d4ah,07d4ah,07d4ah
   .word   07d4ah,0794ah,0754ah,0714ah,06d4ah,0694ah,0654ah,0614ah
   .word   05d4ah,0594ah,0554ah,0514ah,04d4ah,0494ah,0454ah,0454ah
   .word   069aah,06dcah,06deah,0720ah,0762ah,07a6ah,07e8ah,07ecah
   .word   07f0ah,07f2ah,07f6ah,07faah,07feah,07feah,07feah,07feah
   .word   07feah,07feah,07feah,07feah,07feah,07feah,07feah,07fcah
   .word   07faah,07f6ah,07f4ah,07f2ah,07f0ah,07aeah,076cah,076aah

NOP06_P:
   .word   64 
   .word   024a8h,07fbdh,07f5ah,07f18h,07ed6h,07e94h,07e52h,07defh
   .word   07dadh,07d8ch,07d8ch,07d8ch,07d8ch,07d8ch,07d8ch,07d8ch
   .word   07d8ch,07d8ch,07d8ch,0798ch,0758ch,0718ch,06d8ch,0698ch
   .word   0658ch,0618ch,05d8ch,0598ch,0558ch,0518ch,04d8ch,04d8ch
   .word   071ech,0760ch,0762ch,07a4ch,07e6ch,07each,07ecch,07f0ch
   .word   07f4ch,07f6ch,07fach,07fech,07fech,07fech,07fech,07fech
   .word   07fech,07fech,07fech,07fech,07fech,07fech,07fech,07fech
   .word   07fech,07fach,07f8ch,07f6ch,07f4ch,07f2ch,07f0ch,07eech

NOP07_P:
   .word   64 
   .word   024a8h,07fffh,07f9ch,07f5ah,07f18h,07ed6h,07e94h,07e31h
   .word   07defh,07dceh,07dceh,07dceh,07dceh,07dceh,07dceh,07dceh
   .word   07dceh,07dceh,07dceh,07dceh,07dceh,079ceh,075ceh,071ceh
   .word   06dceh,069ceh,065ceh,061ceh,05dceh,059ceh,055ceh,055ceh
   .word   07a2eh,07e4eh,07e6eh,07e8eh,07eaeh,07eeeh,07f0eh,07f4eh
   .word   07f8eh,07faeh,07feeh,07feeh,07feeh,07feeh,07feeh,07feeh
   .word   07feeh,07feeh,07feeh,07feeh,07feeh,07feeh,07feeh,07feeh
   .word   07feeh,07feeh,07fceh,07faeh,07f8eh,07f6eh,07f4eh,07f2eh

NOP08_P:
   .word   64 
   .word   024a8h,07fffh,07fdeh,07f9ch,07f5ah,07f18h,07ed6h,07e73h
   .word   07e31h,07e10h,07e10h,07e10h,07e10h,07e10h,07e10h,07e10h
   .word   07e10h,07e10h,07e10h,07e10h,07e10h,07e10h,07e10h,07a10h
   .word   07610h,07210h,06e10h,06a10h,06610h,06210h,05e10h,05e10h
   .word   07e70h,07e90h,07eb0h,07ed0h,07ef0h,07f30h,07f50h,07f90h
   .word   07fd0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h,07ff0h
   .word   07ff0h,07ff0h,07ff0h,07ff0h,07fd0h,07fb0h,07f90h,07f70h

NOP09_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fdeh,07f9ch,07f5ah,07f18h,07eb5h
   .word   07e73h,07e52h,07e52h,07e52h,07e52h,07e52h,07e52h,07e52h
   .word   07e52h,07e52h,07e52h,07e52h,07e52h,07e52h,07e52h,07e52h
   .word   07e52h,07a52h,07652h,07252h,06e52h,06a52h,06652h,06652h
   .word   07eb2h,07ed2h,07ef2h,07f12h,07f32h,07f72h,07f92h,07fd2h
   .word   07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h
   .word   07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h
   .word   07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07ff2h,07fd2h,07fb2h

NOP10_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fdeh,07f9ch,07f5ah,07ef7h
   .word   07eb5h,07e94h,07e94h,07e94h,07e94h,07e94h,07e94h,07e94h
   .word   07e94h,07e94h,07e94h,07e94h,07e94h,07e94h,07e94h,07e94h
   .word   07e94h,07e94h,07e94h,07a94h,07694h,07294h,06e94h,06e94h
   .word   07ef4h,07f14h,07f34h,07f54h,07f74h,07fb4h,07fd4h,07ff4h
   .word   07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h
   .word   07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h
   .word   07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h,07ff4h

NOP11_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07fdeh,07f9ch,07f39h
   .word   07ef7h,07ed6h,07ed6h,07ed6h,07ed6h,07ed6h,07ed6h,07ed6h
   .word   07ed6h,07ed6h,07ed6h,07ed6h,07ed6h,07ed6h,07ed6h,07ed6h
   .word   07ed6h,07ed6h,07ed6h,07ed6h,07ed6h,07ad6h,076d6h,076d6h
   .word   07f36h,07f56h,07f76h,07f96h,07fb6h,07ff6h,07ff6h,07ff6h
   .word   07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h
   .word   07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h
   .word   07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h,07ff6h

NOP12_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07fffh,07fdeh,07f7bh
   .word   07f39h,07f18h,07f18h,07f18h,07f18h,07f18h,07f18h,07f18h
   .word   07f18h,07f18h,07f18h,07f18h,07f18h,07f18h,07f18h,07f18h
   .word   07f18h,07f18h,07f18h,07f18h,07f18h,07f18h,07f18h,07f18h
   .word   07f78h,07f98h,07fb8h,07fd8h,07ff8h,07ff8h,07ff8h,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h
   .word   07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h,07ff8h

NOP13_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fbdh
   .word   07f7bh,07f5ah,07f5ah,07f5ah,07f5ah,07f5ah,07f5ah,07f5ah
   .word   07f5ah,07f5ah,07f5ah,07f5ah,07f5ah,07f5ah,07f5ah,07f5ah
   .word   07f5ah,07f5ah,07f5ah,07f5ah,07f5ah,07f5ah,07f5ah,07f5ah
   .word   07fbah,07fdah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah
   .word   07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah
   .word   07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah
   .word   07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah,07ffah

NOP14_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fbdh,07f9ch,07f9ch,07f9ch,07f9ch,07f9ch,07f9ch,07f9ch
   .word   07f9ch,07f9ch,07f9ch,07f9ch,07f9ch,07f9ch,07f9ch,07f9ch
   .word   07f9ch,07f9ch,07f9ch,07f9ch,07f9ch,07f9ch,07f9ch,07f9ch
   .word   07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch
   .word   07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch
   .word   07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch
   .word   07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch,07ffch

NOP15_P:
   .word   64 
   .word   024a8h,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh,07fffh
   .word   07fffh,07fdeh,07fdeh,07fdeh,07fdeh,07fdeh,07fdeh,07fdeh
   .word   07fdeh,07fdeh,07fdeh,07fdeh,07fdeh,07fdeh,07fdeh,07fdeh
   .word   07fdeh,07fdeh,07fdeh,07fdeh,07fdeh,07fdeh,07fdeh,07fdeh
   .word   07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh
   .word   07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh
   .word   07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh
   .word   07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh,07ffeh

;
; This table contains the images which make up the dithering pattern
;
dither_img_table
	.long	DITH_A
	.long	DITH_B
	.long	DITH_C
	.long	DITH_D
dither_img_table_end

DITH_IMGS	equ	(dither_img_table_end-dither_img_table)/32


;
; This table contains the frames for the FOG effect during CREATE PLAYER
;
fog_frame_table
	.long	FOG_01
	.long	FOG_02
	.long	FOG_03
	.long	FOG_04
	.long	FOG_05
	.long	FOG_06
	.long	FOG_07
	.long	FOG_08
	.long	FOG_09
	.long	FOG_10
	.long	FOG_11
	.long	FOG_12
	.long	FOG_13
	.long	FOG_14
	.long	FOG_15
	.long	FOG_16
fog_frame_table_end

;
; Info. for privileges option in CREATE PLAYER
;
privileges_str_setup
	PRINT_STR	bast8t_ascii,2,0,BBOXX+76,BBOXY+61,BAST_W_P,0

privileges_str
	.string	"CHECK  2 OF THE 7",0
	.even


;
; Title message for CREATE PLAYER option
;
char_design_str_setup
	PRINT_STR	brush20_ascii,10,0,165,7,BRSHGYOP,0

char_design_str
	.string	"CREATE PLAYER",0
	.even

;
; This table contains:
;
;   1) Addresses of other tables for the STRING initialization routines
;   2) Address of table containing the string to blit
;
butn_instructions_table
	.long	title_setup,plr_stats_title,     dirs_setup2,plr_stats_dirs
	.long	title_setup,choose_head_title,   dirs_setup1,choose_head_dirs
	.long	title_setup,change_uniform_title,dirs_setup1,change_uniform_dirs
	.long	title_setup,adj_attrib_title,    dirs_setup1,adj_attrib_dirs
	.long	title_setup,pick_privs_title,    dirs_setup2,privilege_dirs
	.long	title_setup,pick_nick_name_title,dirs_setup1,nick_name_dirs
	.long	title_setup,change_name_title,   -1,-1
	.long	title_setup,save_exit_title,     -1,-1
	.long	title_setup,enter_name_title,    -1,-1  ;NOT A button...just here to use same code
	.long	title_setup,enter_pin_title,     -1,-1  ;NOT A button...just here to use same code
	.long	title_setup,move_cursor_title,   -1,-1  ;NOT A button...

title_setup
	PRINT_STR	brush12_ascii,4,0,185,40,BRUSH_W_P,0


dirs_setup1
	PRINT_STR	bast7t_ascii,4,0,185,57,BAST_Y_P,0
dirs_setup2
	PRINT_STR	bast7t_ascii,4,0,185,60,BAST_Y_P,0
;dirs_setup3
;	PRINT_STR	bast7t_ascii,4,0,185,62,BAST_Y_P,0


move_cursor_title
	.string	"choose option",0
	.even

enter_name_title
	.string	"enter name/pin",0
	.even

enter_pin_title
	.string	"enter pin number",0
	.even

change_uniform_title
	.string	"change uniform",0
	.even
change_uniform_dirs
	.string	"up/dwn: select uniform",1
	.string	"lft/rgt: home/away team",1
	.string	"buttons: save & exit",0
	.even

choose_head_title
	.string	"choose head",0
	.even
choose_head_dirs
	.string	"lft/rgt: select head",1
	.string	"buttons: save & exit",0
	.even

adj_attrib_title
	.string	"adjust attributes",0
	.even
adj_attrib_dirs
	.string	"up/dwn: move cursor",1
	.string	"lft/rgt: adjust attrib.",1
	.string	"buttons: save & exit",0
	.even

pick_privs_title
	.string	"choose privileges",0
	.even

privilege_dirs
	.string	"up/dwn: move cursor",1
	.string	"lft/rt: toggle check",1
	.string	"buttons: save & exit",0
	.even

pick_nick_name_title
	.string	"choose nick name",0
	.even

nick_name_dirs
	.string	"up/dwn: select name",1
	.string	"lft/rgt: play sound",1
	.string	"buttons: save & exit",0
	.even

change_name_title
	.string	"change name/pin",0
	.even

plr_stats_title
	.string	"player statistics",0
	.even
plr_stats_dirs
	.string	"buttons: next page",0
	.even

save_exit_title
	.string	"save and exit",0
	.even
save_exit_dirs
	.string	"choose wisely",0
	.even


;
; This table contains:
;
;   1) Addresses of other tables for the STRING initialization routines
;   2) Address of table containing the string to blit
;
butn_str_setup_addr_table
	.long	butn_str_setup1,explain_plyr_stats_strs
	.long	butn_str_setup2,explain_choose_head_strs
	.long	butn_str_setup3,explain_change_uniform_strs
	.long	butn_str_setup4,explain_adjust_attrib_strs
	.long	butn_str_setup5,explain_privileges_strs
	.long	butn_str_setup6,explain_nick_name_strs
	.long	butn_str_setup7,explain_enter_name_strs
	.long	butn_str_setup8,explain_save_exit_strs

butn_str_setup1
	PRINT_STR	bast8t_ascii,4,0,185,56,BAST_W_P,0
butn_str_setup2
	PRINT_STR	bast8t_ascii,4,0,185,66,BAST_W_P,0
butn_str_setup3
	PRINT_STR	bast8t_ascii,4,0,185,89,BAST_W_P,0
butn_str_setup4
	PRINT_STR	bast8t_ascii,4,0,185,114,BAST_W_P,0
butn_str_setup5
	PRINT_STR	bast8t_ascii,4,0,185,139,BAST_W_P,0
butn_str_setup6
	PRINT_STR	bast8t_ascii,4,0,185,165,BAST_W_P,0
butn_str_setup7
	PRINT_STR	bast8t_ascii,4,0,185,191,BAST_W_P,0
butn_str_setup8
	PRINT_STR	bast8t_ascii,4,0,185,215,BAST_W_P,0


explain_privileges_strs
	.string	"press any button",1
	.string "to choose your",1
	.string "players privileges",0
	.even

explain_nick_name_strs
	.string	"press any button",1
	.string "to choose your",1
	.string "unique speech call",0
	.even

explain_change_uniform_strs
	.string	"press any button",1
	.string	"to change your",1
	.string	"players uniform",0
	.even

explain_choose_head_strs
	.string	"press any button",1
	.string	"to change your",1
	.string	"players head",0
	.even

explain_adjust_attrib_strs
	.string	"press any button",1
	.string	"to adjust your",1
	.string	"players attributes",0
	.even

explain_enter_name_strs
	.string	"press any button",1
	.string	"to change your",1
	.string	"players name/pin",0
	.even

explain_plyr_stats_strs
	.string	"press any button",1
	.string	"to see your",1
	.string	"players statistics",0
	.even

explain_save_exit_strs
	.string	"press any button",1
	.string	"to save and exit",0
	.even


;
; Goodbye message from CREATE PLAYER
;
goodbye_str_setup
	PRINT_STR	bast8t_ascii,4,0,185,90,BAST_Y_P,0

goodbye_str_setup2
	PRINT_STR	bast8t_ascii,4,0,185,115,BAST_W_P,0

timeout_str_setup2
	PRINT_STR	brush10_ascii,4,0,185,65,BRUSH_R_P,0

time_ranout_str
	.string	"TIME EXPIRED!",0
	.even
goodbye_str
	.string	"record saved.",0
	.even
goodbye_str2
	.string	"you can play this",1
	.string	"character by",1
	.string	"entering your",1
	.string	"name and pin",1
	.string	"number at the",1
	.string	"start of a new",1
	.string	"game.",0
	.even

;
; Record availablity messages
;
record_found_str_setup
	PRINT_STR	bast8t_ascii,4,0,185,110,BAST_Y_P,0

record_not_found_str_setup
	PRINT_STR	bast8t_ascii,4,0,185,110,BAST_Y_P,0

record_not_found_str
	.string	"record not found",0
	.even
record_not_found_str2
	.string	"opening new record",1
	.string	"using default values.",0
	.even

record_found_str
	.string	"record found",0
	.even
record_found_str2
	.string	"data from record",1
	.string	"read in!",0
	.even

;
; This table contains the images which corespond to
;    each digit of the CREATE PLAYER timer
;
timer_img_table
	.long	BRSH1800
	.long	BRSH1801
	.long	BRSH1802
	.long	BRSH1803
	.long	BRSH1804
	.long	BRSH1805
	.long	BRSH1806
	.long	BRSH1807
	.long	BRSH1808
	.long	BRSH1809

;
;
;
my_alpha_table
  .long	BAST8T_A,BAST8T_B,BAST8T_C,BAST8T_D,BAST8T_E,BAST8T_F,BAST8T_G,BAST8T_H		;0-7
  .long	BAST8T_I,BAST8T_J,BAST8T_K,BAST8T_L,BAST8T_M,BAST8T_N,BAST8T_O,BAST8T_P		;8-15
  .long	BAST8T_Q,BAST8T_R,BAST8T_S,BAST8T_T,BAST8T_U,BAST8T_V,BAST8T_W,BAST8T_X		;16-23
  .long	BAST8T_Y,BAST8T_Z,BAST8TAND,BAST8TSPC,BAST8TSPC					;24-31


********






*********************************************************************

	.end


