;-----------------------------------------------------------------------------
*
* Owner:	JOHNSON
*
; Software:	Jeff Johnson
; Initiated:	7-26-95
;
; COPYRIGHT (C) 1995 WILLIAMS ELECTRONICS GAMES, INC.
;
;.Last mod - 8/24/95 
;-----------------------------------------------------------------------------
	.file	"screen.asm"
	.title	"screen transition effects"
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
	.include	"macros.hdr"
	.asg		0,SEQT
	.include	"plyr.equ"


MAX_OBJS	equ	20
OBJ_Z_VAL	equ	30005
RAM_OBJ_SIZE	equ	(32+(16*2))
SKIP_ALT_TBL_PTR   equ	32


	.def	do_scrn_transition
	.def	wipe_horz_stag_dwn,un_wipe_horz_stag_dwn
	.def	wipe_horizontal,un_wipe_horizontal
	.def	wipe_stack_vertical,un_wipe_vertical
	.def	wipe_horz_comb
	.def	wipe_stack_vert_up
	.def	wipe_center_up_dwn,unwipe_center_up_dwn
	.def	transition_flag
	.def	CREATE_DEL_OBJS,CREATE_NO_DEL_OBJS
	.def	NO_CREATE_DEL_OBJS,NO_CREATE_NO_DEL_OBJS

	.ref	dpageflip,dtype
	.ref	del_transition_objs
	.ref	get_all_buttons_cur,get_all_buttons_down
	.ref	HALT
	.ref	snd_play1
	.ref	trns1_snd,trns2_snd,trns3_snd,trns4_snd
	.ref	trnd1_snd,trnd2_snd,trnd3_snd,trnd4_snd
	.ref	untrns1_snd,untrns2_snd,untrns3_snd,untrns4_snd
	.ref	gmqrtr

	
	.bss	num_objects,16
	.bss	trans_tbl_ptr,32
	.bss	del_flag,16
	.bss	transition_flag,16		;0=no transition goin, else 1

	.bss	obj_data,RAM_OBJ_SIZE*MAX_OBJS  ;ptr. to obj,xvel,yvel
	.bss	my_halt,16
						;delay cnt,indx cnt

	.text

;
; Options for TRANSITION effects
;
CREATE_NO_DEL_OBJS   	equ	0	;create objs., move them
CREATE_DEL_OBJS	     	equ	1	;create objs., move them and delete
NO_CREATE_NO_DEL_OBJS  	equ	2	;no create objs, move previous
NO_CREATE_DEL_OBJS   	equ	3	;no create objs, move previous, delete


LWWWWWWWLLL	.macro l1,w,w2,w3,w4,w5,w6,w7,l4,l5,l6
		.long	:l1:
		.word	:w:,:w2:,:w3:,:w4:,:w5:,:w6:,:w7:
		.long	:l4:,:l5:,:l6:
		.endm

LINE_LENGTH	.equ	(32+(16*7)+(32*3))


;----------- TABLES ------------
;----------- TABLES ------------
;----------- TABLES ------------
;
;  NOTE:  If you want to add a transition effect.
;
;     1) MUST follow format of one the existing tables
;     2) .def your table name
;     3) Must end table with '4000'
;     4) Dont have more than MAX_OBJS
;
;
; DEFINITION of each table line:
;   1) IMG    - ptr to img to use as transition obj
;   2) STARTX - starting X coor. of above obj.
;   3) STARTY - starting Y coor. of above obj.
;   4) ENDX   - ending X coor. of above obj.
;   5) ENDY   - ending Y coor. of above obj.
;   6) TICKS  - ticks to reach destination
;   7) DELAY  - Nbr. tick delay before animate this object
;   8) INDEX    - starting offset into anim. table (param passed to below rts)
;   9) ROUTINE - routine to call before obj. is moved (every time)
;

	.asg	0,NO_DELAY
	.asg	0,NO_INDX

;
;ROM transition table offsets
;
	.asg	 0,IMGPTR
	.asg	32,STARTX
	.asg	48,STARTY
	.asg	64,ENDX
	.asg	80,ENDY
	.asg	96,TICKS_TO_DEST
	.asg	112,DELAY_CNT
	.asg	128,INDEX_CNT
	.asg    144,ROUTINE
	.asg    176,STRT_SND_PTR
	.asg    208,END_SND_PTR

;RAM obj. data table offsets
	.asg	 0,OBJ_PTR
	.asg 	32,DELAY_CNT_RAM
	.asg 	48,INDEX_CNT_RAM



;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
wipe_center_up_dwn
 .long	wipe_horz_fast  ;(fast version)
  LWWWWWWWLLL TRANBR15,-6,-41,-6, -3,13,15,1,chg_img_vert,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-6,-41,-6, 29,15,10,0,chg_img_vert,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15,-6,-41,-6, 61,15, 5,0,chg_img_vert,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-6,-41,-6, 93,15, 0,0,chg_img_vert,trns4_snd,trnd4_snd
  LWWWWWWWLLL TRANBR15,-6,259,-6,125,15, 0,0,chg_img_vert,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-6,259,-6,157,15, 5,0,chg_img_vert,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15,-6,259,-6,189,15,10,0,chg_img_vert,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-6,259,-6,221,15,15,1,chg_img_vert,trns4_snd,trnd4_snd
  .long 4000
  .even

;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
unwipe_center_up_dwn
 .long	un_wipe_horz_fast  ;(fast version)
  LWWWWWWWLLL TRANBR15,-6, -3,-6,-35,15, 0,0,chg_img_vert,untrns1_snd,0
  LWWWWWWWLLL TRANBR15,-6, 29,-6,-35,15, 5,0,chg_img_vert,untrns2_snd,0
  LWWWWWWWLLL TRANBR15,-6, 61,-6,-35,15,10,0,chg_img_vert,untrns3_snd,0
  LWWWWWWWLLL TRANBR15,-6, 93,-6,-35,15,15,0,chg_img_vert,untrns4_snd,0
  LWWWWWWWLLL TRANBR15,-6,125,-6,256,15,15,0,chg_img_vert,untrns1_snd,0
  LWWWWWWWLLL TRANBR15,-6,157,-6,256,15,10,0,chg_img_vert,untrns2_snd,0
  LWWWWWWWLLL TRANBR15,-6,189,-6,256,15, 5,0,chg_img_vert,untrns3_snd,0
  LWWWWWWWLLL TRANBR15,-6,221,-6,256,15, 0,0,chg_img_vert,untrns4_snd,0
  .long 4000
  .even


;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
wipe_horz_stag_dwn
 .long	wipe_horz_fast  ;(fast version)
  LWWWWWWWLLL TRANBR01, 400, -3,-6, -3,15, 0,0,chg_img_hor,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR01,-414, 29,-6, 29,15, 3,0,chg_img_hor,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR01, 400, 61,-6, 61,15, 6,0,chg_img_hor,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR01,-414, 93,-6, 93,15, 9,0,chg_img_hor,trns4_snd,trnd4_snd
  LWWWWWWWLLL TRANBR01, 400,125,-6,125,15,12,0,chg_img_hor,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR01,-414,157,-6,157,15,15,0,chg_img_hor,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR01, 400,189,-6,189,15,18,0,chg_img_hor,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR01,-414,221,-6,221,15,21,0,chg_img_hor,trns4_snd,trnd4_snd
  .long	4000
  .even

;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
un_wipe_horz_stag_dwn
 .long	un_wipe_horz_fast  ;(fast version)
  LWWWWWWWLLL TRANBR01,-6, -3,-414, -3,13, 0,0,chg_img_hor,untrns1_snd,0
  LWWWWWWWLLL TRANBR01,-6, 29, 400, 29,13, 3,0,chg_img_hor,untrns2_snd,0
  LWWWWWWWLLL TRANBR01,-6, 61,-414, 61,13, 6,0,chg_img_hor,untrns3_snd,0
  LWWWWWWWLLL TRANBR01,-6, 93, 400, 93,13, 9,0,chg_img_hor,untrns4_snd,0
  LWWWWWWWLLL TRANBR01,-6,125,-414,125,13,12,0,chg_img_hor,untrns1_snd,0
  LWWWWWWWLLL TRANBR01,-6,157, 400,157,13,15,0,chg_img_hor,untrns2_snd,0
  LWWWWWWWLLL TRANBR01,-6,189,-414,189,13,18,0,chg_img_hor,untrns3_snd,0
  LWWWWWWWLLL TRANBR01,-6,221, 400,221,13,21,0,chg_img_hor,untrns4_snd,0
  .long	4000
  .even

;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
wipe_horizontal
 .long	wipe_horz_fast  ;(fast version)
  LWWWWWWWLLL TRANBR15,400, -3,-6, -3,15, 0,0,chg_img_hor,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,400, 29,-6, 29,15, 3,0,chg_img_hor,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15,400, 61,-6, 61,15, 6,0,chg_img_hor,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,400, 93,-6, 93,15, 9,0,chg_img_hor,trns4_snd,trnd4_snd
  LWWWWWWWLLL TRANBR15,400,125,-6,125,15,12,0,chg_img_hor,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,400,157,-6,157,15,15,0,chg_img_hor,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15,400,189,-6,189,15,18,0,chg_img_hor,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,400,221,-6,221,15,21,0,chg_img_hor,trns4_snd,trnd4_snd
  .long	4000
  .even

;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
wipe_horz_comb
  .long	wipe_horz_fast		;alternate effect
  LWWWWWWWLLL TRANBR15, 400, -3,-6, -3,15,0,0,simply_rets,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-414, 29,-6, 29,15,0,0,simply_rets,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15, 400, 61,-6, 61,15,0,0,simply_rets,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-414, 93,-6, 93,15,0,0,simply_rets,trns4_snd,trnd4_snd
  LWWWWWWWLLL TRANBR15, 400,125,-6,125,15,0,0,simply_rets,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-414,157,-6,157,15,0,0,simply_rets,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15, 400,189,-6,189,15,0,0,simply_rets,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-414,221,-6,221,15,0,0,simply_rets,trns4_snd,trnd4_snd
  .long	4000
  .even


;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
un_wipe_horizontal
 .long	un_wipe_horz_fast  ;(fast version)
  LWWWWWWWLLL TRANBR15,-6, -3,-406, -3,13,21,0,chg_img_hor,untrns1_snd,0
  LWWWWWWWLLL TRANBR15,-6, 29,-406, 29,13,18,0,chg_img_hor,untrns2_snd,0
  LWWWWWWWLLL TRANBR15,-6, 61,-406, 61,13,15,0,chg_img_hor,untrns3_snd,0
  LWWWWWWWLLL TRANBR15,-6, 93,-406, 93,13,12,0,chg_img_hor,untrns4_snd,0
  LWWWWWWWLLL TRANBR15,-6,125,-406,125,13, 9,0,chg_img_hor,untrns1_snd,0
  LWWWWWWWLLL TRANBR15,-6,157,-406,157,13, 6,0,chg_img_hor,untrns2_snd,0
  LWWWWWWWLLL TRANBR15,-6,189,-406,189,13, 3,0,chg_img_hor,untrns3_snd,0
  LWWWWWWWLLL TRANBR15,-6,221,-406,221,13, 0,0,chg_img_hor,untrns4_snd,0
  .long	4000
  .even


;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
wipe_stack_vert_up
 .long	wipe_horz_fast  ;(fast version)
  LWWWWWWWLLL TRANBR15,-6,256,-6, -3,15, 0,0,chg_img_vert,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-6,256,-6, 29,15, 4,0,chg_img_vert,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15,-6,256,-6, 61,15, 8,0,chg_img_vert,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-6,256,-6, 93,15,12,0,chg_img_vert,trns4_snd,trnd4_snd
  LWWWWWWWLLL TRANBR15,-6,256,-6,125,15,16,0,chg_img_vert,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-6,256,-6,157,15,20,0,chg_img_vert,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15,-6,256,-6,189,15,24,0,chg_img_vert,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-6,256,-6,221,15,28,2,chg_img_vert,trns4_snd,trnd4_snd
  .long 4000
  .even


;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
wipe_stack_vertical
 .long	wipe_horz_fast  ;(fast version)
  LWWWWWWWLLL TRANBR15,-6,-41,-6, -3,15,28,1,chg_img_vert,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-6,-35,-6, 29,15,24,0,chg_img_vert,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15,-6,-35,-6, 61,15,20,0,chg_img_vert,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-6,-35,-6, 93,15,16,0,chg_img_vert,trns4_snd,trnd4_snd
  LWWWWWWWLLL TRANBR15,-6,-35,-6,125,15,12,0,chg_img_vert,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-6,-35,-6,157,15, 8,0,chg_img_vert,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15,-6,-35,-6,189,15, 4,0,chg_img_vert,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-6,-35,-6,221,15, 0,0,chg_img_vert,trns4_snd,trnd4_snd
  .long 4000
  .even

;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
un_wipe_vertical
 .long	un_wipe_horz_fast  ;(fast version)
  LWWWWWWWLLL TRANBR15,-6, -3,-6,256,15,28,0,chg_img_vert,untrns1_snd,0
  LWWWWWWWLLL TRANBR15,-6, 29,-6,256,15,24,0,chg_img_vert,untrns2_snd,0
  LWWWWWWWLLL TRANBR15,-6, 61,-6,256,15,20,0,chg_img_vert,untrns3_snd,0
  LWWWWWWWLLL TRANBR15,-6, 93,-6,256,15,16,0,chg_img_vert,untrns4_snd,0
  LWWWWWWWLLL TRANBR15,-6,125,-6,256,15,12,0,chg_img_vert,untrns1_snd,0
  LWWWWWWWLLL TRANBR15,-6,157,-6,256,15, 8,0,chg_img_vert,untrns2_snd,0
  LWWWWWWWLLL TRANBR15,-6,189,-6,256,15, 4,0,chg_img_vert,untrns3_snd,0
  LWWWWWWWLLL TRANBR15,-6,221,-6,256,15, 0,0,chg_img_vert,untrns4_snd,0
  .long 4000
  .even


;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
wipe_horz_fast
  .long	0		;alternate effect
  LWWWWWWWLLL TRANBR15, 400, -3,-6, -3,10,0,0,simply_rets,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-414, 29,-6, 29,10,0,0,simply_rets,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15, 400, 61,-6, 61,10,0,0,simply_rets,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-414, 93,-6, 93,10,0,0,simply_rets,trns4_snd,trnd4_snd
  LWWWWWWWLLL TRANBR15, 400,125,-6,125,10,0,0,simply_rets,trns1_snd,trnd1_snd
  LWWWWWWWLLL TRANBR15,-414,157,-6,157,10,0,0,simply_rets,trns2_snd,trnd2_snd
  LWWWWWWWLLL TRANBR15, 400,189,-6,189,10,0,0,simply_rets,trns3_snd,trnd3_snd
  LWWWWWWWLLL TRANBR15,-414,221,-6,221,10,0,0,simply_rets,trns4_snd,trnd4_snd
  .long	4000
  .even


;
; img, startX, startY, endX, endY, ticks 2 dest
;                       delay cnt, index pos., routine to call, sound
;
un_wipe_horz_fast
  .long	0		;alternate effect
  LWWWWWWWLLL TRANBR15,-6, -3,-414, -3,8,0,0,simply_rets,untrns1_snd,0
  LWWWWWWWLLL TRANBR15,-6, 29, 400, 29,8,0,0,simply_rets,untrns2_snd,0
  LWWWWWWWLLL TRANBR15,-6, 61,-414, 61,8,0,0,simply_rets,untrns3_snd,0
  LWWWWWWWLLL TRANBR15,-6, 93, 400, 93,8,0,0,simply_rets,untrns4_snd,0
  LWWWWWWWLLL TRANBR15,-6,125,-414,125,8,0,0,simply_rets,untrns1_snd,0
  LWWWWWWWLLL TRANBR15,-6,157, 400,157,8,0,0,simply_rets,untrns2_snd,0
  LWWWWWWWLLL TRANBR15,-6,189,-414,189,8,0,0,simply_rets,untrns3_snd,0
  LWWWWWWWLLL TRANBR15,-6,221, 400,221,8,0,0,simply_rets,untrns4_snd,0
  .long	4000
  .even



;----------- CODE ------------
;----------- CODE ------------
;----------- CODE ------------

transition_option_tbl
	.word	0,0		;create objs, dont delete obj. when done
	.word	0,1		;create objs, delete obj. when done
	.word	1,0		;dont create objs, dont delete obj. when done
	.word	1,1		;dont create objs, delete obj. when done


;-----------------------------------------------------------------------------
;  This routine reads and performs the actions from a TRANSITION TABLE SCRIPT
;
; must be JSRP'd
;
; INPUT: reg. a0  : ptr. to transition definition table
;	 reg. a14 : option
;
; destroys: a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a14
;-----------------------------------------------------------------------------
 SUBRP	do_scrn_transition

	move	@HALT,a1
	move	a1,@my_halt
	clr	a1
	move	a1,@HALT

	move	a0,@trans_tbl_ptr,L		;save TRANSITION table ptr.

	movk	1,a0
	move	a0,@transition_flag		;in TRANSITION state

;set options
	sll	5,a14				;*32
	addi	transition_option_tbl,a14,L
	move	*a14(16),a0
	move	a0,@del_flag			;delete flag

; if a button is down, change effect to a super fast transition

	move	@gmqrtr,a0
	jrgt	nbtn_1				;dont allow fast tran. in game

	calla	get_all_buttons_cur
	jreq	nbtn_1
	move	@trans_tbl_ptr,a0,L
	move	*a0,a0,L			;get alternate effect ptr.
	jreq	nbtn_1				;if zero, regular
	move	a0,@trans_tbl_ptr,L		;save new TRANSITION table ptr.

;if a0=1 then NO OBJECTS ARE CREATED...assumes prior transition effect
nbtn_1
	move	*a14,a0       			;create objs. flag
	jrne	dst_1a				;br=dont create objs.
;
; Create objects in TRANSITION effect table
;
	move	@trans_tbl_ptr,a10,L		;get TRANSITION table ptr.
	addi	SKIP_ALT_TBL_PTR,a10		;bypass other trans. tbl ptr.
	movi	obj_data,a9,L
	clr	a0
	move	a0,@num_objects

	movi	OBJ_Z_VAL,a3			;z pos (ABOVE EVERYTHING)
	movi	TRANS_OBJ_ID,a5
	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a6				;x vel
	clr	a7				;y vel
dst_1
	move	*a10(IMGPTR),a2,L		;get ptr. to img
	move	*a10(STARTX),a0	 		;get X coor.
	sll	16,a0
	move	*a10(STARTY),a1			;get Y coor.
	sll	16,a1
	calla	BEGINOBJ2
	move	a8,*a9(OBJ_PTR),L		;save ptr. to obj.

	move	@num_objects,a0
	inc	a0
	move	a0,@num_objects

	addi	RAM_OBJ_SIZE,a9,L		;next obj. ram data area
	addi	LINE_LENGTH,a10,L		;next transition obj. setup line

	move	*a10,a0,L			;check for end of table
	cmpi	4000,a0				;at end of table ?
	jrne	dst_1				;br=nope
dst_1a
	callr	set_obj_ram
;
; Now watch the objects
;
dst_3
	SLEEPK	1
	callr	maybe_set_obj_velocity
	callr	call_all_table_routines
	calla	calc_num_objs_at_dest
	move	@num_objects,a0
	cmp	a0,a14				;ALL objs. reached dest. ?
	jrlo	dst_3				;br=nope

	move	@del_flag,a14
	jreq	dos_2				;br=dont delete objects.

;dont clear flag if not deleting objs. (cant seen screen)
	clr	a0
	move	a0,@transition_flag		;in TRANSITION state

	movi	TRANS_OBJ_ID,a0
	calla	del_transition_objs			;delete transition effect objs.
	calla	clear_trans_obj_data_ram
dos_2
;	SLEEPK	1				;hide bog caused by RETP

	move	@my_halt,a14
	move	a14,@HALT
	RETP


;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	maybe_set_obj_velocity

	move	@trans_tbl_ptr,a10,L		;get TRANSITION table ptr
	addi	SKIP_ALT_TBL_PTR,a10		;bypass other trans. tbl ptr.
	movi	obj_data,a9,L
uodc_0
	move	*a9(OBJ_PTR),a8,L			;get obj. ptr.
	move	*a9(DELAY_CNT_RAM),a1		;get current delay count
	jrn	uodc_1				;br=velocity already set
	dec	a1
	move	a1,*a9(DELAY_CNT_RAM)		;store updated delay count
	move	a1,a1				;is delay = -1
	jrnn	uodc_1				;br= nope, exit
	callr	set_obj_velocity

	move	*a10(STRT_SND_PTR),a0,L
	jrz	uodc_1
	PUSH	a14
	calla	snd_play1
	PULL	a14

uodc_1
	addi	RAM_OBJ_SIZE,a9,L		;next obj. ram area
	addi	LINE_LENGTH,a10,L		;add offset to table pointer
	move	*a10,a0,L			;check for end of table		
	cmpi	4000,a0				;at end of table ?
	jrne	uodc_0
	rets

;-----------------------------------------------------------------------------
; This routine just computes the obj. velocity based on START X,Y and END X,Y
; and the TICK_TO_DEST variable
;
; INPUT: a10 - ptr. to tranisition table
;	  a8 - ptr. to obj. ram area
;-----------------------------------------------------------------------------
 SUBR	set_obj_velocity

;compute X velocity
	move	*a10(ENDX),a1
	move	*a10(STARTX),a0
	sub	a0,a1
	sll	16,a1
	move	*a10(TICKS_TO_DEST),a0
	divs	a0,a1				;dont do a 64 bit divide
	move	a1,*a8(OXVEL),L

;compute Y velocity
	move	*a10(ENDY),a1
	move	*a10(STARTY),a0
	sub	a0,a1
	sll	16,a1
	move	*a10(TICKS_TO_DEST),a0
	divs	a0,a1
	move	a1,*a8(OYVEL),L
	rets

;-----------------------------------------------------------------------------
;	This routine sets all the DELAYS and INDEXes for each object in the
;  transition table
;-----------------------------------------------------------------------------
 SUBR	set_obj_ram

	move	@trans_tbl_ptr,a10,L		;get TRANSITION table ptr
	addi	SKIP_ALT_TBL_PTR,a10		;bypass other trans. tbl ptr.
	movi	obj_data,a9,L
sor_0
	move	*a10(DELAY_CNT),a0
	move	a0,*a9(DELAY_CNT_RAM)		;set DELAY count

	move	*a10(INDEX_CNT),a0
	move	a0,*a9(INDEX_CNT_RAM)		;set INDEX count

	addi	RAM_OBJ_SIZE,a9,L		;next obj. ram area
	addi	LINE_LENGTH,a10,L		;add offset to table pointer
	move	*a10,a0,L			;check for end of table		
	cmpi	4000,a0				;at end of table ?
	jrne	sor_0
 	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	call_all_table_routines

	move	@trans_tbl_ptr,a10,L		;get TRANSITION table ptr
	addi	SKIP_ALT_TBL_PTR,a10		;bypass other trans. tbl ptr.
	movi	obj_data,a9,L
catr_1
	move	*a9(OBJ_PTR),a8,L
	jrz	catr_2				;br=invalid obj...no routine
	move	*a9(DELAY_CNT_RAM),a0
	jrnn	catr_2				;obj. is waiting to move..no routine
	move	*a10(ROUTINE),a0,L
	call	a0
catr_2	
	addi	RAM_OBJ_SIZE,a9,L		;next obj. ram data area
	addi	LINE_LENGTH,a10,L		;add offset to table pointer
	move	*a10,a0,L			;check for end of table		
	cmpi	4000,a0				;at end of table ?
	jrne	catr_1
	rets

;-----------------------------------------------------------------------------
;  This routine calculates the number of objects at their destination
;
; returns: a14 = count
;-----------------------------------------------------------------------------
 SUBR	calc_num_objs_at_dest

	clr	a14
	move	@trans_tbl_ptr,a10,L		;get TRANSITION table ptr
	addi	SKIP_ALT_TBL_PTR,a10		;bypass other trans. tbl ptr.
	movi	obj_data,a9,L
cno_1
	move	*a9(OBJ_PTR),a8,L

;ignore object until its delay time is negative
	move	*a9(DELAY_CNT_RAM),a0		;is object animating..yet ?
	jrnn	cno_3				;br=nope

	move	*a8(OXVEL),a0,L
	jrnz	cno_1aa
	move	*a8(OYVEL),a0,L
	jrz	cno_2c 				;obj. has no VELOCITY, skip
cno_1aa
	move	*a8(OXVEL),a1,L
	jrn	cno_1a				;br=negative VELOCTIY

	move	*a8(OXVAL),a0,L
	move	*a10(ENDX),a1
	sll	16,a1
	cmp	a0,a1
	jrgt	cno_3				;br=obj. not at X dest.
	jruc	cno_1b
cno_1a
	move	*a8(OXVAL),a0,L
	move	*a10(ENDX),a1
	sll	16,a1
	cmp	a0,a1
	jrlt	cno_3				;br=obj. not at X dest.

;obj. at X dest. now see if at Y dest.

cno_1b
	move	*a8(OYVEL),a1,L
	jrn	cno_2a				;br=negative VELOCTIY

	move	*a8(OYVAL),a0,L
	move	*a10(ENDY),a1
	sll	16,a1
	cmp	a0,a1
	jrgt	cno_3				;br=obj. not at Y dest.
	jruc	cno_2b
cno_2a
	move	*a8(OYVAL),a0,L
	move	*a10(ENDY),a1
	sll	16,a1
	cmp	a0,a1
	jrlt	cno_3				;br=obj. not at Y dest.

;stop object from moving (and set OXVAL to ENDX,Y)

cno_2b	clr	a0
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OXVEL),L

;just in case obj. moved passed ENDX,ENDY
	move	*a10(ENDX),a1
	sll	16,a1
	move	a1,*a8(OXVAL),L
	move	*a10(ENDY),a1,L
	sll	16,a1
	move	a1,*a8(OYVAL),L

	move	*a10(END_SND_PTR),a0,L
	jrz	cno_2c
	PUSH	a14
	calla	snd_play1
	PULL	a14

cno_2c
	inc	a14
cno_3
	addi	RAM_OBJ_SIZE,a9,L		;next obj. ram data area
	addi	LINE_LENGTH,a10,L		;add offset to table pointer
	move	*a10,a0,L			;check for end of table		
	cmpi	4000,a0				;at end of table ?
	jrne	cno_1
	rets

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
 SUBR	clear_trans_obj_data_ram

	movi	MAX_OBJS,a0				;counter
 	movi	obj_data,a1,L
	clr	a14
ctop_1	move	a14,*a1+,L		;1 long and 2 words
	move	a14,*a1+,L
	dsj	a0,ctop_1
 	rets


;----------- TRANSITION ACTION ROUTINES ------------
;----------- TRANSITION ACTION ROUTINES ------------
;----------- TRANSITION ACTION ROUTINES ------------
;----------- TRANSITION ACTION ROUTINES ------------

;-----------------------------------------------------------------------------
; 	This routine (called from TRANSITION table) scales the obj. 
;
; INPUT:   a8 - ptr. to obj
;	   a9 - ptr. to obj ram area
;	  a10 - ptr. to transition table
;-----------------------------------------------------------------------------
; SUBR	scale_obj_to_gone
;
;	move	*a9(INDEX_CNT_RAM),a0
;	inc	a0
;	move	a0,a14
;	sll	5,a0
;	addi	scale_down_tbl,a0,L		;pt. to next scale factor
;	cmpi	scale_down_tbl_end,a0		;at end of table ?
;	jrhs	sotg_1
;	move	a14,*a9(INDEX_CNT_RAM)		;save new count
;	move	*a0,a0,L			;get scale factor
;	move	a0,*a8(OSCALE),L
;sotg_1 	rets

;-----------------------------------------------------------------------------
; 	This routine (called from TRANSITION table) scales the obj. 
;
; INPUT:   a8 - ptr. to obj
;	   a9 - ptr. to obj ram area
;	  a10 - ptr. to transition table
;-----------------------------------------------------------------------------
; SUBR	scale_upward
;
;	move	*a9(INDEX_CNT_RAM),a0
;	inc	a0
;	move	a0,a14
;	sll	5,a0
;	addi	scale_up_tbl,a0,L		;pt. to next scale factor
;	cmpi	scale_up_tbl_end,a0		;at end of table ?
;	jrhs	su_1
;	move	a14,*a9(INDEX_CNT_RAM)		;save new count
;	move	*a0,a0,L			;get scale factor
;	move	a0,*a8(OSCALE),L
;su_1 	rets
;

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; SUBR	rotate_left
;
;	move	*a9(INDEX_CNT_RAM),a1
;	inc	a1
;	move	a1,a14
;	sll	5,a1
;	addi	rotate_left_tbl,a1		;pt. at scale factor and frame
;	cmpi	rotate_left_tbl_end,a1		;at end of table ?
;	jrhs	rl_1				;br=yes
;	move	a14,*a9(INDEX_CNT_RAM)		;save new count
;	move	*a1,a0,L			;NEW img
;	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
;	calla	obj_aniq
;rl_1 	rets

;-----------------------------------------------------------------------------
;	This routine scales and spins obj. downward to destination		
;
; INPUT:   a8 - ptr. to obj
;	   a9 - ptr. to obj ram area
;	  a10 - ptr. to transition table
;-----------------------------------------------------------------------------
; SUBR	rotate_right
;	
;	move	*a9(INDEX_CNT_RAM),a1
;	inc	a1
;	move	a1,a14
;	sll	5,a1
;	addi	rotate_right_tbl,a1		;pt. at scale factor and frame
;	cmpi	rotate_right_tbl_end,a1		;at end of table ?
;	jrhs	rr_1				;br=yes
;	move	a14,*a9(INDEX_CNT_RAM)		;save new count
;	move	*a1,a0,L			;NEW img
;	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
;	calla	obj_aniq
;rr_1 	rets

;-----------------------------------------------------------------------------
;	This routine changes the image for the Vertical wipe
;
; INPUT:   a8 - ptr. to obj
;	   a9 - ptr. to obj ram area
;	  a10 - ptr. to transition table
;-----------------------------------------------------------------------------
 SUBR	chg_img_vert
	
	move	*a9(INDEX_CNT_RAM),a0
	inc	a0
	move	a0,a14
	sll	5,a0
	addi	wipe_vert_img_tbl,a0,L
	cmpi	wipe_vert_img_tbl_end,a0,L		;at end of table ?
	jrhs	civw_1					;br=yes
	move	a14,*a9(INDEX_CNT_RAM)			;save new count
	move	*a0,a0,L				;NEW img
	movi	DMAWNZ|M_SCRNREL,a1			;DMA flags
	calla	obj_aniq
civw_1	rets

;-----------------------------------------------------------------------------
;	This routine changes the image for the Horizontal wipe
;
; INPUT:   a8 - ptr. to obj
;	   a9 - ptr. to obj ram area
;	  a10 - ptr. to transition table
;-----------------------------------------------------------------------------
 SUBR	chg_img_hor

	move	*a9(INDEX_CNT_RAM),a0
	inc	a0
	move	a0,a14
	sll	5,a0
	addi	wipe_hor_img_tbl,a0,L
	cmpi	wipe_hor_img_tbl_end,a0,L		;at end of table ?
	jrhs	cihw_1					;br=yes
	move	a14,*a9(INDEX_CNT_RAM)			;save new count
	move	*a0,a0,L				;NEW img
	movi	DMAWNZ|M_SCRNREL,a1		;DMA flags
	calla	obj_aniq
cihw_1	rets

;-----------------------------------------------------------------------------
; 		A dummy routine for TRANSITION effect tables
; 
; INPUT:   a8 - ptr. to obj
;	   a9 - ptr. to obj ram area
;	  a10 - ptr. to transition table
;-----------------------------------------------------------------------------
 SUBR	simply_rets
 	rets



;----------- DATA TABLES ------------
;----------- DATA TABLES ------------
;----------- DATA TABLES ------------

;scale_down_tbl
;	.long	01000100H
;	.long	01200120H
;	.long	01400140H
;	.long	01600160H
;	.long	01800180H
;	.long	02000200H
;	.long	02200220H
;	.long	02400240H
;	.long	02600260H
;	.long	02800280H
;	.long	03000300H
;	.long	03200320H
;	.long	03400340H
;scale_down_tbl_end
;
;
;scale_up_tbl
;	.long	03400340H
;	.long	03200320H
;	.long	03000300H
;	.long	02800280H
;	.long	02600260H
;	.long	02400240H
;	.long	02200220H
;	.long	02000200H
;	.long	01800180H
;	.long	01600160H
;	.long	01400140H
;	.long	01200120H
;	.long	01000100H
;scale_up_tbl_end
;
;
;rotate_left_tbl
;	.long	NBASPN01
;	.long	NBASPN01
;	.long	NBASPN02
;	.long	NBASPN02
;	.long	NBASPN03
;	.long	NBASPN03
;	.long	NBASPN04
;	.long	NBASPN04
;	.long	NBASPN05
;	.long	NBASPN05
;	.long	NBASPN06
;	.long	NBASPN06
;	.long	NBASPN07
;	.long	NBASPN07
;	.long	NBASPN08
;	.long	NBASPN08
;	.long	NBASPN09
;	.long	NBASPN09
;	.long	NBASPN10
;	.long	NBASPN10
;	.long	NBASPN11
;	.long	NBASPN11
;	.long	NBASPN12
;	.long	NBASPN12
;	.long	NBASPN13
;	.long	NBASPN13
;	.long	NBASPN14
;	.long	NBASPN14
;	.long	NBASPN15
;	.long	NBASPN15
;	.long	NBASPN01
;	.long	NBASPN01
;	.long	NBASPN02
;	.long	NBASPN02
;	.long	NBASPN03
;	.long	NBASPN03
;	.long	NBASPN04
;	.long	NBASPN04
;	.long	NBASPN05
;	.long	NBASPN05
;	.long	NBASPN06
;	.long	NBASPN06
;	.long	NBASPN07
;rotate_left_tbl_end
;
;
;rotate_right_tbl
;	.long	NBASPN10
;	.long	NBASPN09
;	.long	NBASPN08
;	.long	NBASPN07
;	.long	NBASPN06
;	.long	NBASPN05
;	.long	NBASPN05
;	.long	NBASPN04
;	.long	NBASPN04
;	.long	NBASPN03
;	.long	NBASPN02
;	.long	NBASPN02
;	.long	NBASPN01
;	.long	NBASPN01
;	.long	NBASPN15
;	.long	NBASPN15
;	.long	NBASPN14
;	.long	NBASPN14
;	.long	NBASPN13
;	.long	NBASPN13
;	.long	NBASPN12
;	.long	NBASPN11
;	.long	NBASPN10
;	.long	NBASPN09
;	.long	NBASPN09
;	.long	NBASPN08
;	.long	NBASPN08
;	.long	NBASPN07
;	.long	NBASPN07
;	.long	NBASPN06
;	.long	NBASPN06
;	.long	NBASPN05
;	.long	NBASPN05
;	.long	NBASPN04
;	.long	NBASPN04
;	.long	NBASPN03
;	.long	NBASPN03
;	.long	NBASPN02
;	.long	NBASPN02
;	.long	NBASPN01
;	.long	NBASPN01
;	.long	NBASPN15
;	.long	NBASPN15
;rotate_right_tbl_end


wipe_hor_img_tbl
	.long	TRANBR01
	.long	TRANBR02
	.long	TRANBR03
	.long	TRANBR04
	.long	TRANBR05
	.long	TRANBR06
	.long	TRANBR07
	.long	TRANBR08
	.long	TRANBR09
	.long	TRANBR10
	.long	TRANBR11
	.long	TRANBR12
	.long	TRANBR13
	.long	TRANBR13
	.long	TRANBR14
	.long	TRANBR14
	.long	TRANBR15
	.long	TRANBR15
wipe_hor_img_tbl_end

wipe_vert_img_tbl
	.long	TRANBR01
	.long	TRANBR02
	.long	TRANBR03
	.long	TRANBR04
	.long	TRANBR05
	.long	TRANBR06
	.long	TRANBR06
	.long	TRANBR07
	.long	TRANBR08
	.long	TRANBR09
	.long	TRANBR09
	.long	TRANBR10
	.long	TRANBR11
	.long	TRANBR12
	.long	TRANBR13
	.long	TRANBR13
	.long	TRANBR14
	.long	TRANBR15
	.long	TRANBR15
wipe_vert_img_tbl_end

******************************************************************************
	.end

