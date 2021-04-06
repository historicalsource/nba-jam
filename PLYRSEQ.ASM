;I'm not putting initials in plyrseq files! 
**************************************************************
*
* Owner:	TURMELL
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		10/8/92
*
* Modified:		Shawn Liptak, 10/8/92	-Split from BB.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/18/92 1:40
**************************************************************
	.file	"plyrseq.asm"
	.title	"basketball plyr sequence code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"game.equ"
	.include	"macros.hdr"
	.asg		1,SEQT
	.include	"plyr.equ"
	.include	"plyrseq.glo"
	.include	"plyrseq3.glo"
	.include	"behind.tbl"
	.include	"plyrdsp.tbl"
	.include	"plyrjsht.tbl"
	.include	"dunks.glo"
	.include	"world.equ"

;sounds external

	.ref	swipe_snd

;symbols externally defined

	.ref	plyr_pass,plyr_shoot
	.ref	seq_newdir
	.ref	seq_slamball
	.ref	seq_strtdunk
	.ref	seq_jump
	.ref	seq_jump2
	.ref	seq_resetseq
	.ref	seq_stand
	.ref	seq_stealstand
	.ref	seq_block,seq_push,seq_rebounda
	.ref	seq_run
	.ref	seq_snd
	.ref	clr_autorbnd

	.ref	rndrng0
	.ref	seq_handle_fade_away,seq_handle_fadeaside
	.ref	fades_sp,fadeaway_sp,leans_bck_sp
	.ref	leans_sp,leans_in_sp,pull_jmpr_sp
	.ref	bslne_lnr_sp
	.ref	seq_goto_line
;symbols defined in this file

;	.def	w3run1
;	.def	w3desp1
;	.def	w1blok3,w2blok3,w4blok3,w5blok3
;	.def	w1blok2,w2blok2,w4blok2,w5blok2
;	.def	w5dst1

	.ref	w1jupa
	.ref	w2jupa
	.ref	w3jupa
	.ref	w4jupa
	.ref	w5jupa

;uninitialized ram definitions



;equates for this file

M_YF	.equ	>8000	;Y free (OFLAGS)

	.bss	keep_xvel,32
	.bss	keep_zvel,32

	.text


********************************


	.asg	M_WRNONZ,F
	.asg	M_WRNONZ|M_FLIPH,FF

;#*
;putback_t
;;(very close range only)
;;	.word	DUNK_M|NOJUMP_M|NOJOY_M|NOCOLLP_M	;DFLGS
;	.word	NOJUMP_M|BLOCKREB_M|NOSTEAL_M|NOJOY_M
;	.long	seq_stand
;	.long	#1,#2,#3,#4
;	.long	#5,#4,#3,#2
;#1
;	WLW	3,w2blokl1,FF
;	WLW	3,w2blokl2,FF
;	WLW	3,w2blokl3,FF
;	WLL	-1,seq_block,w2blokl4
;	WLW	27,w2blokl4,FF
;	WLW	500,w2blokl5,FF
;	WLW	3,w2blokl6,FF
;	WLW	3,w2blokl7,FF
;	WLW	-1,seq_newdir,1*16
;	W0
;
;;	WLW	3,w2blokl1,F
;;	WLLW	-1,seq_strtdunk,w2blokl3,19
;;	WLW	3,w2blokl2,F
;;	WLW	3,w2blokl3,F
;;	WLW	12,w2blokl4,F
;;	WLL	-1,check_own_ball,#1a
;;	WLW	1,w2blokl5,F
;;	WLW	-1,seq_slamball,3
;;	WLL	-1,seq_snd,put_back_sp
;;	WLW	500,w2blokl5,F
;;	WLW	3,w2blokl6,F
;;	WLW	3,w2blokl7,F
;;	WLW	-1,seq_newdir,1*16
;;	W0
;
;#1a
;	WLW	500,w2blokl4,F
;	WLW	3,w2blokl7,F
;	WLW	-1,seq_newdir,1*16
;	W0
;	
;
;#2
;#3
;#4
;	WLW	3,w3blokl1,FF
;	WLW	3,w3blokl2,FF
;	WLW	3,w3blokl3,FF
;	WLL	-1,seq_block,w3blokl4
;	WLW	27,w3blokl4,FF
;	WLW	500,w3blokl5,FF
;	WLW	3,w3blokl6,FF
;	WLW	3,w3blokl7,FF
;	WLW	-1,seq_newdir,2*16
;	W0
;
;;	WLW	3,w3blokl1,F
;;	WLLW	-1,seq_strtdunk,w3blokl3,19
;;	WLW	3,w3blokl2,F
;;	WLW	3,w3blokl3,F
;;	WLW	12,w3blokl4,F
;;	WLL	-1,check_own_ball,#3a
;;	WLW	1,w3blokl5,F
;;	WLW	-1,seq_slamball,3
;;	WLL	-1,seq_snd,put_back_sp
;;	WLW	500,w3blokl5,F
;;	WLW	3,w3blokl6,F
;;	WLW	3,w3blokl7,F
;;	WLW	-1,seq_newdir,2*16
;;	W0
;
;#3a
;	WLW	500,w3blokl4,F
;	WLW	3,w3blokl7,F
;	WLW	-1,seq_newdir,2*16
;	W0
;
;#5
;	WLW	3,w4blokl1,FF
;	WLW	3,w4blokl2,FF
;	WLW	3,w4blokl3,FF
;	WLL	-1,seq_block,w4blokl4
;	WLW	27,w4blokl4,FF
;	WLW	500,w4blokl5,FF
;	WLW	3,w4blokl6,FF
;	WLW	3,w4blokl7,FF
;	WLW	-1,seq_newdir,3*16
;	W0
;
;;	WLW	3,w4blokl1,F
;;	WLLW	-1,seq_strtdunk,w4blokl3,19
;;	WLW	3,w4blokl2,F
;;	WLW	3,w4blokl3,F
;;	WLW	12,w4blokl4,F
;;	WLL	-1,check_own_ball,#5a
;;	WLW	1,w4blokl5,F
;;	WLW	-1,seq_slamball,3
;;	WLL	-1,seq_snd,put_back_sp
;;	WLW	500,w4blokl5,F
;;	WLW	3,w4blokl6,F
;;	WLW	3,w4blokl7,F
;;	WLW	-1,seq_newdir,3*16
;;	W0
;;
;#5a
;	WLW	500,w4blokl4,F
;	WLW	3,w4blokl7,F
;	WLW	-1,seq_newdir,3*16
;	W0
;
;
;check_own_ball
;	move	*b4+,b0,L		      ;get Alternative ending for seq
;	move	*a13(plyr_ownball),a14
;	jrp	cob_1				;I own the ball, do reg. end
;	move	b0,b4			      ;change to Alternative ending
;cob_1	rets


stnd2_t	.word	EASYSTAG_M
	.long	0
	.long	#s1_l,#s2_l,#s3_l,#s4_l
	.long	#s5_l,#s4_l,#s3_l,#s2_l
#s1_l
	WLW	5,w1stand1,F
	WLW	5,w1stand2,F
	WLW	5,w1stand3,F
	WLW	5,w1stand4,F
	WLW	5,w1stand3,F
	WLW	5,w1stand2,F
	W0
#s2_l
	WLW	5,w2stand1,F
	WLW	5,w2stand2,F
	WLW	5,w2stand3,F
	WLW	5,w2stand4,F
	WLW	5,w2stand3,F
	WLW	5,w2stand2,F
	W0
#s3_l
	WLW	5,w3stand1,F
	WLW	5,w3stand2,F
	WLW	5,w3stand3,F
	WLW	5,w3stand4,F
	WLW	5,w3stand3,F
	WLW	5,w3stand2,F
	W0
#s4_l
	WLW	5,w4stand1,F
	WLW	5,w4stand2,F
	WLW	5,w4stand3,F
	WLW	5,w4stand4,F
	WLW	5,w4stand3,F
	WLW	5,w4stand2,F
	W0
#s5_l
	WLW	5,w5stand1,F
	WLW	5,w5stand2,F
	WLW	5,w5stand3,F
	WLW	5,w5stand4,F
	WLW	5,w5stand3,F
	WLW	5,w5stand2,F
	W0


;stndwb_t
;	.word	EASYSTAG_M|NOMV_M
;	.long	0
;	.long	#stndwb1_l,#stndwb2_l,#stndwb3_l,#stndwb4_l
;	.long	#stndwb5_l,#stndwb4_l,#stndwb3_l,#stndwb2_l
;
;#stndwb1_l
;	WLW	5,w1stwbl1,F
;	WLW	5,w1stwbl2,F
;	WLW	5,w1stwbl3,F
;	WLW	5,w1stwbl4,F
;	WLW	5,w1stwbl3,F
;	WLW	5,w1stwbl2,F
;	W0
;#stndwb2_l
;	WLW	5,w2stwbl1,F
;	WLW	5,w2stwbl2,F
;	WLW	5,w2stwbl3,F
;	WLW	5,w2stwbl4,F
;	WLW	5,w2stwbl3,F
;	WLW	5,w2stwbl2,F
;	W0
;#stndwb3_l
;	WLW	5,w3stwbl1,F
;	WLW	5,w3stwbl2,F
;	WLW	5,w3stwbl3,F
;	WLW	5,w3stwbl4,F
;	WLW	5,w3stwbl3,F
;	WLW	5,w3stwbl2,F
;	W0
;#stndwb4_l
;	WLW	5,w4stwbl1,F
;	WLW	5,w4stwbl2,F
;	WLW	5,w4stwbl3,F
;	WLW	5,w4stwbl4,F
;	WLW	5,w4stwbl3,F
;	WLW	5,w4stwbl2,F
;	W0
;#stndwb5_l
;	WLW	5,w5stwbl1,F
;	WLW	5,w5stwbl2,F
;	WLW	5,w5stwbl3,F
;	WLW	5,w5stwbl4,F
;	WLW	5,w5stwbl3,F
;	WLW	5,w5stwbl2,F
;	W0

stnddrib_t
	.word	EASYSTAG_M|DRIBBLE_M
	.long	0
	.long	#stndd1_l,#stndd2_l,#stndd3_l,#stndd4_l
	.long	#stndd5_l,#stndd4_l,#stndd3_l,#stndd2_l

#stndd1_l
	WLW	1,w1dst1,F
	WLW	2,w1dst1,F|M_YF
	WLW	3,w1dst2,F
	WLW	3,w1dst3,F
	WLW	3,w1dst4,F
	WLW	3,w1dst5,F
	WLW	3,w1dst6,F
	WLW	3,w1dst7,F
	WLW	3,w1dst8,F
	WLW	3,w1dst9,F
	WLW	3,w1dst10,F
	W0

#stndd2_l
	WLW	1,w2dst1,F
	WLW	2,w2dst1,F|M_YF
	WLW	3,w2dst2,F
	WLW	3,w2dst3,F
	WLW	3,w2dst4,F
	WLW	3,w2dst5,F
	WLW	3,w2dst6,F
	WLW	3,w2dst7,F
	WLW	3,w2dst8,F
	WLW	3,w2dst9,F
	WLW	3,w2dst10,F
	W0

#stndd3_l
	WLW	1,w3dst1,F
	WLW	2,w3dst1,F|M_YF
	WLW	3,w3dst2,F
	WLW	3,w3dst3,F
	WLW	3,w3dst4,F
	WLW	3,w3dst5,F
	WLW	3,w3dst6,F
	WLW	3,w3dst7,F
	WLW	3,w3dst8,F
	WLW	3,w3dst9,F
	WLW	3,w3dst10,F
	W0

#stndd4_l
	WLW	1,w4dst1,F
	WLW	2,w4dst1,F|M_YF
	WLW	3,w4dst2,F
	WLW	3,w4dst3,F
	WLW	3,w4dst4,F
	WLW	3,w4dst5,F
	WLW	3,w4dst6,F
	WLW	3,w4dst7,F
	WLW	3,w4dst8,F
	WLW	3,w4dst9,F
	WLW	3,w4dst10,F
	W0

#stndd5_l
	WLW	1,w5dst1,F
	WLW	2,w5dst1,F|M_YF
	WLW	3,w5dst2,F
	WLW	3,w5dst3,F
	WLW	3,w5dst4,F
	WLW	3,w5dst5,F
	WLW	3,w5dst6,F
	WLW	3,w5dst7,F
	WLW	3,w5dst8,F
	WLW	3,w5dst9,F
	WLW	3,w5dst10,F
	W0


stnddrib2_t
	.word	EASYSTAG_M|DRIBBLE_M
	.long	0
	.long	#stndd21_l,#stndd22_l,#stndd23_l,#stndd24_l
	.long	#stndd25_l,#stndd24_l,#stndd23_l,#stndd22_l

#stndd21_l
	WLW	1,w1drcr1,F
	WLW	1,w1drcr1,F|M_YF
	WLW	2,w1drcr2,F
	WLW	2,w1drcr3,F
	WLW	2,w1drcr4,F
	WLW	2,w1drcr5,F
	WLW	2,w1drcr6,F
	WLW	2,w1drcr7,F
	WLW	2,w1drcr8,F
	WLW	2,w1drcr9,F
	WLW	2,w1drcr10,F
	WLW	2,w1drcr11,F
	WLW	2,w1drcr12,F
	W0
#stndd22_l
	WLW	1,w2drcr1,F
	WLW	1,w2drcr1,F|M_YF
	WLW	2,w2drcr2,F
	WLW	2,w2drcr3,F
	WLW	2,w2drcr4,F
	WLW	2,w2drcr5,F
	WLW	2,w2drcr6,F
	WLW	2,w2drcr7,F
	WLW	2,w2drcr8,F
	WLW	2,w2drcr9,F
	WLW	2,w2drcr10,F
	WLW	2,w2drcr11,F
	WLW	2,w2drcr12,F
	W0
#stndd23_l
	WLW	1,w3drcr1,F
	WLW	1,w3drcr1,F|M_YF
	WLW	2,w3drcr2,F
	WLW	2,w3drcr3,F
	WLW	2,w3drcr4,F
	WLW	2,w3drcr5,F
	WLW	2,w3drcr6,F
	WLW	2,w3drcr7,F
	WLW	2,w3drcr8,F
	WLW	2,w3drcr9,F
	WLW	2,w3drcr10,F
	WLW	2,w3drcr11,F
	WLW	2,w3drcr12,F
	W0
#stndd24_l
	WLW	1,w4drcr1,F
	WLW	1,w4drcr1,F|M_YF
	WLW	2,w4drcr2,F
	WLW	2,w4drcr3,F
	WLW	2,w4drcr4,F
	WLW	2,w4drcr5,F
	WLW	2,w4drcr6,F
	WLW	2,w4drcr7,F
	WLW	2,w4drcr8,F
	WLW	2,w4drcr9,F
	WLW	2,w4drcr10,F
	WLW	2,w4drcr11,F
	WLW	2,w4drcr12,F
	W0
#stndd25_l
	WLW	1,w5drcr1,F
	WLW	1,w5drcr1,F|M_YF
	WLW	2,w5drcr2,F
	WLW	2,w5drcr3,F
	WLW	2,w5drcr4,F
	WLW	2,w5drcr5,F
	WLW	2,w5drcr6,F
	WLW	2,w5drcr7,F
	WLW	2,w5drcr8,F
	WLW	2,w5drcr9,F
	WLW	2,w5drcr10,F
	WLW	2,w5drcr11,F
	WLW	2,w5drcr12,F
	W0


stnddribdef_t
	.word	EASYSTAG_M|DRIBBLE_M
	.long	0
	.long	#sdd1_l,#sdd1_l,#sdd3_l,#sdd4_l
	.long	#sdd5_l,#sdd4_l,#sdd3_l,#sdd1_l
#sdd1_l
	WLW	1,w1drcr1,F
	WLW	2,w1drcr1,F|M_YF
	WLW	3,w1drcr2,F
	WLW	3,w1drcr3,F
	WLW	3,w1drcr4,F
	WLW	3,w1drcr5,F
	WLW	3,w1drcr6,F
	WLW	3,w1drcr7,F
	WLW	3,w1drcr8,F
	WLW	3,w1drcr9,F
	WLW	3,w1drcr10,F
	WLW	3,w1drcr11,F
	WLW	3,w1drcr12,F
	W0
#sdd3_l
	WLW	1,w3drcr1,F
	WLW	2,w3drcr1,F|M_YF
	WLW	3,w3drcr2,F
	WLW	4,w3drcr3,F
	WLW	4,w3drcr4,F
	WLW	4,w3drcr5,F
	WLW	4,w3drcr6,F
	WLW	4,w3drcr7,F
	WLW	4,w3drcr8,F
	WLW	4,w3drcr9,F
	WLW	4,w3drcr10,F
	WLW	4,w3drcr11,F
	WLW	4,w3drcr12,F
	W0
#sdd4_l
	WLW	1,w4drcr1,F
	WLW	2,w4drcr1,F|M_YF
	WLW	3,w4drcr2,F
	WLW	3,w4drcr3,F
	WLW	3,w4drcr4,F
	WLW	3,w4drcr5,F
	WLW	3,w4drcr6,F
	WLW	3,w4drcr7,F
	WLW	3,w4drcr8,F
	WLW	3,w4drcr9,F
	WLW	3,w4drcr10,F
	WLW	3,w4drcr11,F
	WLW	3,w4drcr12,F
	W0
#sdd5_l
	WLW	1,w5drcr1,F
	WLW	2,w5drcr1,F|M_YF
	WLW	3,w5drcr2,F
	WLW	3,w5drcr3,F
	WLW	3,w5drcr4,F
	WLW	3,w5drcr5,F
	WLW	3,w5drcr6,F
	WLW	3,w5drcr7,F
	WLW	3,w5drcr8,F
	WLW	3,w5drcr9,F
	WLW	3,w5drcr10,F
	WLW	3,w5drcr11,F
	WLW	3,w5drcr12,F
	W0


#*
block_t
	.word	NOJUMP_M|DRIFT_M|BLOCKREB_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2


#1
	WLW	2,w1blokl1,F
	WLW	2,w1blokl2,F
	WLL	-1,seq_block,w1blokl4
	WLW	3,w1blokl3,F
	WLW	99,w1blokl4,F
;If art doesn't strike ball, we fall to ground and land!
;If art does strike ball, we jump into good_block_t sequence (Below)
	WLW	3,w1blokl3,F
	WLW	2,w1blokl2,F
	WLW	2,w1blokl1,F
	W0
#2
	WLW	2,w2blokl1,F
	WLW	2,w2blokl2,F
	WLL	-1,seq_block,w2blokl4
	WLW	3,w2blokl3,F
	WLW	99,w2blokl4,F
	WLW	3,w2blokl3,F
	WLW	2,w2blokl2,F
	WLW	2,w2blokl1,F
	W0
#3
	WLW	2,w3blokl1,F
	WLW	2,w3blokl2,F
	WLL	-1,seq_block,w3blokl4
	WLW	3,w3blokl3,F
	WLW	99,w3blokl4,F
	WLW	3,w3blokl3,F
	WLW	2,w3blokl2,F
	WLW	2,w3blokl1,F
	W0
#4
	WLW	2,w4blokl1,F
	WLW	2,w4blokl2,F
	WLL	-1,seq_block,w4blokl4
	WLW	3,w4blokl3,F
	WLW	99,w4blokl4,F
	WLW	3,w4blokl3,F
	WLW	2,w4blokl2,F
	WLW	2,w4blokl1,F
	W0
#5
	WLW	2,w5blokl1,F
	WLW	2,w5blokl2,F
	WLL	-1,seq_block,w5blokl1
	WLW	3,w5blokl3,F
	WLW	99,w5blokl4,F
	WLW	3,w5blokl3,F
	WLW	2,w5blokl2,F
	WLW	2,w5blokl1,F
	W0


#*
;good_block_t
;;Block_t sequence successfully hit ball!
;;Follow thru with swat & possibly cradle ball (Stick to it)
;	.word	NOJUMP_M|DRIFT_M|BLOCKREB_M|NOJOY_M
;	.long	seq_stand
;	.long	#1,#2,#3,#4,#5,#4,#3,#2
;
;
;#1
;	WLW	3,w1blokl4,F
;	WLW	3,w1blokl5,F
;	WLW	99,w1blokl6,F
;	WLW	3,w1blokl7,F
;	WLW	3,w1blokl8,F
;	W0
;#2
;	WLW	3,w2blokl4,F
;	WLW	3,w2blokl5,F
;	WLW	99,w2blokl6,F
;	WLW	3,w2blokl7,F
;	WLW	3,w2blokl8,F
;	W0
;#3
;	WLW	3,w3blokl4,F
;	WLW	99,w3blokl5,F
;	WLW	3,w3blokl6,F
;	WLW	3,w3blokl7,F
;	WLW	3,w3blokl8,F
;	W0
;#4
;	WLW	3,w4blokl4,F
;	WLW	3,w4blokl5,F
;	WLW	99,w4blokl6,F
;	WLW	3,w4blokl7,F
;	WLW	3,w4blokl8,F
;	W0
;#5
;	WLW	3,w5blokl4,F
;	WLW	99,w5blokl5,F
;	WLW	3,w5blokl6,F
;	WLW	3,w5blokl7,F
;	WLW	3,w5blokl8,F
;	W0
;#*

nospear_t
	.word	NOJUMP_M|DRIFT_M|BLOCKREB_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2

#1
	WLW	1,w1blokl4,F
	WLW	3,w1reb5,F
	WLW	99,w1reb7,F
	WLW	3,w1reb8,F
	WLW	3,w1reb9,F
	WLW	3,w1reb10,F
	W0
#2
	WLW	1,w2blokl4,F
	WLW	3,w2reb3,F
;	WLW	1,w2reb4,F
	WLW	1,w2reb5,F
	WLW	1,w2reb6,F
	WLW	99,w2reb7,F
	WLW	3,w2reb8,F
	WLW	3,w2reb9,F
	WLW	3,w2reb10,F
	W0
#3
;	WLW	1,w3blokl4,F
;	WLW	3,w3reb3,F
;	WLW	1,w3reb4,F
;	WLW	1,w3reb5,F
;	WLW	1,w3reb6,F
;	WLW	99,w3reb8,F
;	WLW	3,w3reb9,F
;	WLW	3,w3reb10,F
;	W0
#4
	WLW	1,w4blokl4,F
	WLW	3,w4reb5,F
	WLW	99,w4reb7,F
	WLW	3,w4reb8,F
	WLW	3,w4reb9,F
	WLW	3,w4reb10,F
	W0
#5
	WLW	1,w5blokl4,F
	WLW	3,w5reb5,F
	WLW	99,w5reb7,F
	WLW	3,w5reb8,F
	WLW	3,w5reb9,F
	W0


#*
blockrej_t
	.word	NOJUMP_M|DRIFT_M|BLOCKREB_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
#1
	WLW	2,w1rej1,F
	WLL	-1,seq_block,w1rej6	;29
	WLW	-1,seq_set_hold,25
	WLW	6,w1rej2,F		;20

	WLW	1,w1rej2,F		;20
	WL	-1,seq_hold_block

	WLL	-1,seq_snd,swipe_snd
	WLW	2,w1rej3,F
	WLW	2,w1rej4,F
	WLW	2,w1rej5,F
	WLW	2,w1rej6,F
	WLW	2,w1rej7,F
	WLW	2,w1rej8,F
	WL	-1,seq_stop_shoulder
	WLW	77,w1rej9,F
	WLW	3,w1rej10,F
	WLW	3,w1rej11,F
	W0

seq_stop_shoulder
;This stops goaltends from registering when the swat has followed thru and
;a collision still happens!
	move	*a13(plyr_ownball),a0
	jrp	#own
	movi	50,a0
	move	a0,*a13(plyr_shtdly)
#own	rets


seq_set_hold
	move	*b4+,b0
	move	b0,a0
	move	a0,*a13(plyr_hold_block)
	rets

seq_hold_block
	move	*a13(plyr_hold_block),a0
	dec	a0
	move	a0,*a13(plyr_hold_block)
	jrz	#cont_blk
;Check to see if player is still keeping his arm cocked
	.ref	get_block_but_cur
	move	*a13(plyr_num),a0
	.ref	PSTATUS
	move	@PSTATUS,a1
	btst	a0,a1
	jrnz	#notdrn
;Have drone keep arm cocked for a random time...
;Drone logic could improve here!
	movi	900,a0
	.ref	RNDPER
	calla	RNDPER
	jrhi	#cont_blk
	subi	48+64,b4
	rets
	
#notdrn	move	*a13(plyr_num),a0
	calla	get_block_but_cur
	jrz	#cont_blk
;Player is still holding button down, hold on swat frame!
;Go back to swat frame in front of hold block entry
	subi	48+64,b4
#cont_blk
	rets



#2
#3
	WLW	2,w2rej1,F
	WLL	-1,seq_block,w2rej6
	WLW	-1,seq_set_hold,25
	WLW	6,w2rej2,F
	WLW	1,w2rej2,F
	WL	-1,seq_hold_block
	WLL	-1,seq_snd,swipe_snd
	WLW	2,w2rej3,F
	WLW	2,w2rej4,F
	WLW	2,w2rej5,F
	WLW	2,w2rej6,F
	WLW	2,w2rej7,F
	WLW	2,w2rej8,F
	WL	-1,seq_stop_shoulder
	WLW	77,w2rej9,F
	WLW	3,w2rej10,F	
	WLW	3,w2rej11,F	
	W0

;Save art
;	WLW	2,w3rej1,F
;	WLL	-1,seq_block,w3rej6
;	WLW	3,w3rej2,F
;	WLW	3,w3rej3,F
;	WLW	17,w3rej4,F
;	WLL	-1,seq_snd,swipe_snd
;	WLW	3,w3rej5,F
;	WLW	3,w3rej6,F
;	WLW	3,w3rej7,F
;	WLW	3,w3rej8,F
;	WLW	77,w3rej9,F	
;	WLW	3,w3rej10,F	
;	WLW	3,w3rej11,F	
;	W0
#4
#5
	WLW	2,w4rej1,F
	WLL	-1,seq_block,w4rej1
	WLW	-1,seq_set_hold,25
	WLW	3,w4rej2,F
	WLW	6,w4rej3,F
	WLW	1,w4rej3,F
	WL	-1,seq_hold_block
	WLL	-1,seq_snd,swipe_snd
	WLW	2,w4rej4,F
	WLW	2,w4rej5,F
	WLW	2,w4rej6,F
	WLW	2,w4rej7,F
	WLW	2,w4rej8,F
	WL	-1,seq_stop_shoulder
	WLW	77,w4rej9,F		;Land
	WLW	3,w4rej10,F	
	WLW	3,w4rej11,F	
	W0

#*
fastblockrej_t
	.word	NOJUMP_M|DRIFT_M|BLOCKREB_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
#1
	WLW	2,w1rej1,F
	WLL	-1,seq_block,w1rej6	;29
	WLW	-1,seq_set_hold,25
	WLW	6,w1rej2,F
	WLW	1,w1rej2,F
	WL	-1,seq_hold_block
	WLL	-1,seq_snd,swipe_snd
	WLW	2,w1rej3,F
	WLW	1,w1rej4,F
	WLW	2,w1rej5,F
	WLW	1,w1rej6,F
	WLW	2,w1rej7,F
	WLW	1,w1rej8,F
	WL	-1,seq_stop_shoulder
	WLW	77,w1rej9,F	
	WLW	3,w1rej10,F	
	WLW	3,w1rej11,F	
	W0
#2
#3
	WLW	2,w2rej1,F
	WLL	-1,seq_block,w2rej6
	WLW	-1,seq_set_hold,25
	WLW	6,w2rej2,F
	WLW	1,w2rej2,F
	WL	-1,seq_hold_block
	WLL	-1,seq_snd,swipe_snd
	WLW	2,w2rej3,F
	WLW	1,w2rej4,F
	WLW	2,w2rej5,F
	WLW	1,w2rej6,F
	WLW	2,w2rej7,F
	WLW	1,w2rej8,F
	WL	-1,seq_stop_shoulder
	WLW	77,w2rej9,F
	WLW	3,w2rej10,F	
	WLW	3,w2rej11,F	
	W0

;	WLW	2,w3rej1,F
;	WLL	-1,seq_block,w3rej6
;	WLW	2,w3rej2,F
;	WLW	2,w3rej3,F
;	WLW	21,w3rej4,F
;	WLL	-1,seq_snd,swipe_snd
;	WLW	2,w3rej5,F
;	WLW	2,w3rej6,F
;	WLW	2,w3rej7,F
;	WLW	2,w3rej8,F
;	WLW	77,w3rej9,F	
;	WLW	3,w3rej10,F	
;	WLW	3,w3rej11,F	
;	W0
#4
#5
	WLW	2,w4rej1,F
	WLL	-1,seq_block,w4rej1
;	WLL	-1,seq_block,w4rej6
	WLW	-1,seq_set_hold,25
	WLW	2,w4rej2,F
	WLW	6,w4rej3,F
	WLW	1,w4rej3,F
	WL	-1,seq_hold_block
	WLL	-1,seq_snd,swipe_snd
	WLW	2,w4rej4,F
	WLW	1,w4rej5,F
	WLW	2,w4rej6,F
	WLW	1,w4rej7,F
	WLW	2,w4rej8,F
	WL	-1,seq_stop_shoulder
	WLW	77,w4rej9,F		;Land
	WLW	3,w4rej10,F
	WLW	3,w4rej11,F
	W0

#*
rebound_t
	.word	NOJUMP_M|DRIFT_M|BLOCKREB_M|NOSTEAL_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
#1
	WLW	2,w1reb10,F
	WLW	2,w1reb9,F
	WL	-1,#ck_ball
	WLL	-1,seq_block,w1reb5
	WLW	3,w1reb8,F
	WLW	27,w1reb5,F
	WLW	500,w1reb7,F
	WLW	3,w1reb8,F
	WLW	3,w1reb9,F
	WLW	3,w1reb10,F
	W0
#1a
	WLW	5,w1reb8,F
	WLW	3,w1reb9,F
	WLW	3,w1reb10,F
	W0
#ck_ball
;If ball is near head, and is close enough, no need to jump high!
	move	*a13(plyr_balldist),a0
	cmpi	>30,a0
	jrgt	#cont

	.ref	ballobj_p
	move	@ballobj_p,a0,L
	move	*a0(OYPOS),a14
;Could add in yvel here also for some more accuracy
	cmpi	-100,a14
	jrlt	#cont


	move	*a13(plyr_seqdir),a0
	sll	5,a0
	addi	#tbl,a0
	move	*a0,a0,L
	move	a0,b4
#cont
	rets

#tbl	.long	#1a,#2a,#3a,#4a,#5a,#4a,#3a,#2a

#2
	WLW	2,w2reb1,F
	WLW	2,w2reb2,F
	WL	-1,#ck_ball
	WLL	-1,seq_block,w2reb6
	WLW	27,w2reb3,F
;	WLW	1,w2reb4,F		;Land
	WLW	1,w2reb5,F
	WLW	1,w2reb6,F
	WLW	500,w2reb7,F
	WLW	3,w2reb8,F
	WLW	3,w2reb9,F
	WLW	3,w2reb10,F
	W0
#2a
	WLW	5,w2reb8,F
	WLW	3,w2reb9,F
	WLW	3,w2reb10,F
	W0
;#3
;	WLW	2,w3reb1,F
;	WLW	2,w3reb2,F
;	WL	-1,#ck_ball
;	WLL	-1,seq_block,w3reb3
;	WLW	27,w3reb3,F
;	WLW	1,w3reb4,F		;Land
;	WLW	1,w3reb5,F
;	WLW	1,w3reb6,F
;	WLW	500,w3reb8,F
;	WLW	3,w3reb9,F
;	WLW	3,w3reb10,F
;	W0
;#3a
;	WLW	5,w3reb9,F
;	WLW	3,w3reb10,F
;	W0
#3
#4
	WLW	2,w4reb10,F
	WLW	2,w4reb9,F
	WL	-1,#ck_ball
	WLL	-1,seq_block,w4reb4
	WLW	2,w4reb8,F
	WLW	2,w4reb7,F
	WLW	2,w4reb5,F
	WLW	27,w4reb4,F
	WLW	500,w4reb7,F
	WLW	3,w4reb8,F
	WLW	3,w4reb9,F
	WLW	3,w4reb10,F
	W0
#3a
#4a
	WLW	5,w4reb9,F
	WLW	3,w4reb10,F
	W0
#5
	WLW	2,w5reb9,F
	WLW	2,w5reb8,F
	WL	-1,#ck_ball
	WLL	-1,seq_block,w5reb7
	WLW	3,w5reb7,F
	WLW	27,w5reb5,F
	WLW	500,w5reb7,F
	WLW	3,w5reb8,F
	WLW	3,w5reb9,F
	W0
#5a
	WLW	5,w5reb8,F
	WLW	3,w5reb9,F
	W0

#*
rebounda_t
	.word	NOJUMP_M|DRIFT_M|BLOCKREB_M|NOSTEAL_M|NOJOY_M|NOCOLLP_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
;	.long	#2,#2,#2,#2,#2,#2,#2,#2
#1
	WLW	2,w1reb10,F
	WLW	2,w1reb9,F
	WL	-1,#ck_ball
	WLL	-1,seq_rebounda,w1reb5
	WLW	2,w1reb8,F
	WLW	27,w1reb5,F
	WLW	500,w1reb7,F
	WLW	3,w1reb8,F
	WLW	3,w1reb9,F
	WLW	3,w1reb10,F
	WL	-1,clr_autorbnd
	W0
#1a
	WLW	5,w1reb8,F
	WLW	3,w1reb9,F
	WLW	3,w1reb10,F
	WL	-1,clr_autorbnd
	W0


#ck_ball
;If ball is near head, and is close enough, no need to jump high!
	move	*a13(plyr_balldist),a0
	cmpi	>30,a0
	jrgt	#cont

	.ref	ballobj_p
	move	@ballobj_p,a0,L
	move	*a0(OYPOS),a14
;Could add in yvel here also for some more accuracy
	cmpi	-100,a14
	jrlt	#cont


	move	*a13(plyr_seqdir),a0
	sll	5,a0
	addi	#tbl,a0
	move	*a0,a0,L
	move	a0,b4
#cont
	rets

#tbl	.long	#1a,#2a,#3a,#4a,#5a,#4a,#3a,#2a

#2
	WLW	2,w2reb1,F
	WLW	2,w2reb2,F
	WL	-1,#ck_ball
	WLL	-1,seq_rebounda,w2reb3
	WLW	27,w2reb3,F
;	WLW	1,w2reb4,F		;Land
	WLW	1,w2reb5,F
	WLW	1,w2reb6,F
	WLW	500,w2reb7,F
	WLW	3,w2reb8,F
	WLW	3,w2reb9,F
	WLW	3,w2reb10,F
	WL	-1,clr_autorbnd
	W0

#2a	WLW	5,w2reb8,F
	WLW	3,w2reb9,F
	WLW	3,w2reb10,F
	WL	-1,clr_autorbnd
	W0

;#3
;	WLW	2,w3reb1,F
;	WLW	2,w3reb2,F
;	WL	-1,#ck_ball
;	WLL	-1,seq_rebounda,w3reb3
;	WLW	27,w3reb3,F
;	WLW	1,w3reb4,F		;Land
;	WLW	1,w3reb5,F
;	WLW	1,w3reb6,F
;	WLW	500,w3reb8,F
;	WLW	3,w3reb9,F
;	WLW	3,w3reb10,F
;	WL	-1,clr_autorbnd
;	W0
;#3a
;	WLW	5,w3reb9,F
;	WLW	3,w3reb10,F
;	WL	-1,clr_autorbnd
;	W0

#3
#4
	WLW	2,w4reb10,F
	WLW	2,w4reb9,F
	WL	-1,#ck_ball
	WLL	-1,seq_rebounda,w4reb4
	WLW	2,w4reb8,F
	WLW	2,w4reb7,F
	WLW	2,w4reb5,F
	WLW	27,w4reb4,F
	WLW	500,w4reb7,F
	WLW	3,w4reb8,F
	WLW	3,w4reb9,F
	WLW	3,w4reb10,F
	WL	-1,clr_autorbnd
	W0
#3a
#4a
	WLW	5,w4reb9,F
	WLW	3,w4reb10,F
	WL	-1,clr_autorbnd
	W0
#5
	WLW	2,w5reb9,F
	WLW	2,w5reb8,F
	WL	-1,#ck_ball
	WLL	-1,seq_rebounda,w5reb7
	WLW	2,w5reb7,F
	WLW	27,w5reb5,F
	WLW	500,w5reb7,F
	WLW	3,w5reb8,F
	WLW	3,w5reb9,F
	WL	-1,clr_autorbnd
	W0
#5a	WLW	5,w5reb8,F
	WLW	3,w5reb9,F
	WL	-1,clr_autorbnd
	W0

#*

fadeaside_seq1a			;team 2
	WL	-1,#store_vels
;	WLW	3,W1UNDR1,F
;	WLW	3,W1UNDR2,F
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WL	-1,#announce_side_fade
	WLW	3,W1UNDR3,F
	WLW	3,W1UNDR4,F
	WLW	77,W1UNDR5,F
	WLW	3,W1UNDR6,F
	WLW	3,W1UNDR7,F
	WLW	77,W1UNDR8,F
	WLW	3,W1UNDR9,F
	WLW	-1,seq_newdir,0*16
	W0

fadeaside_seq1			;team1
	WL	-1,#store_vels
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WL	-1,#announce_side_fade
	WLW	3,W1UNDR3,FF
	WLW	3,W1UNDR4,FF
	WLW	77,W1UNDR5,FF
	WLW	3,W1UNDR6,FF
	WLW	3,W1UNDR7,FF
	WLW	77,W1UNDR8,FF
	WLW	3,W1UNDR9,FF
	WLW	-1,seq_newdir,0*16
	W0

fadeaway_seq2
	WL	-1,#store_vels
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WLW	3,W2FADAW3,F
	WL	-1,#announce_fadeaway
	WLW	3,W2FADAW4,F
	WLW	77,W2FADAW5,F
	WLW	3,W2FADAW6,F
	WLW	3,W2FADAW7,F
	WLW	77,W2FADAW8,F
	WLW	3,W2FADAW9,F
	WLW	3,W2FADAW10,F
	WLW	3,W2FADAW11,F
	WLW	3,W2FADAW12,F
	WLW	3,W2FADAW13,F
	WLW	-1,seq_newdir,1*16
	W0

fadein_seq2
	WL	-1,#store_vels
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WLW	3,W2FADIN4,F
	WL	-1,#announce_fadein
	WLW	3,W2FADIN5,F
	WLW	3,W2FADIN6,F
	WLW	77,W2FADIN7,F
	WLW	3,W2FADIN8,F
	WLW	3,W2FADIN9,F
	WLW	3,W2FADIN10,F
	WLW	77,W2FADIN11,F
	WLW	3,W2FADIN12,F
	WLW	3,W2FADIN13,F
	WLW	-1,seq_newdir,1*16
	W0

fadeaway_seq3
	WL	-1,#store_vels
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WLW	3,W3FADAW3,F
	WL	-1,#announce_fadeaway
	WLW	3,W3FADAW4,F
	WLW	3,W3FADAW5,F
	WLW	77,W3FADAW6,F
	WLW	3,W3FADAW7,F
	WLW	3,W3FADAW8,F
	WLW	77,W3FADAW9,F
	WLW	3,W3FADAW10,F
	WLW	8,W3FADAW11,F
	WLW	4,W3FADAW12,F
	WLW	4,W3FADAW13,F
	WLW	-1,seq_newdir,2*16
	W0

fadein_seq3
	WL	-1,#store_vels
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WLW	1,W3FADIN5,F
	WL	-1,#announce_fadein
	WLW	2,W3FADIN5,F
	WLW	3,W3FADIN6,F
	WLW	77,W3FADIN7,F
	WLW	3,W3FADIN8,F
	WLW	3,W3FADIN9,F
	WLW	3,W3FADIN10,F
	WLW	77,W3FADIN11,F
	WLW	3,W3FADIN12,F
	WLW	3,W3FADIN13,F
	WLW	-1,seq_newdir,2*16
	W0

fadeaway_seq4
	WL	-1,#store_vels
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WLW	3,W4FADAW3,F
	WL	-1,#announce_fadeaway
	WLW	3,W4FADAW4,F
	WLW	77,W4FADAW5,F
	WLW	3,W4FADAW6,F
	WLW	77,W4FADAW7,F
	WLW	3,W4FADAW8,F
	WLW	3,W4FADAW9,F
	WLW	3,W4FADAW10,F
	WLW	3,W4FADAW11,F
	WLW	3,W4FADAW12,F
	WLW	3,W4FADAW13,F
	WLW	-1,seq_newdir,3*16
	W0

fadein_seq4
	WL	-1,#store_vels
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WLW	2,W4FADIN2,F
	WL	-1,#announce_fadein
	WLW	2,W4FADIN3,F
	WLW	2,W4FADIN4,F
	WLW	77,W4FADIN5,F
	WLW	2,W4FADIN8,F
	WLW	2,W4FADIN9,F
	WLW	77,W4FADIN10,F
	WLW	3,W4FADIN11,F
	WLW	3,W4FADIN12,F
	WLW	3,W4FADIN13,F 
	WLW	-1,seq_newdir,3*16
	W0

fadeaside_seq5a
	WL	-1,#store_vels
	WLW	3,W5UNDR2,F
	WLW	3,W5UNDR3,F
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WL	-1,#announce_side_fade
	WLW	3,W5UNDR4,F
	WLW	3,W5UNDR5,F
	WLW	77,W5UNDR6,F
;	WLW	3,W5UNDR7,F
	WLW	3,W5UNDR8,F
	WLW	77,W5UNDR9,F
	WLW	4,W5UNDR10,F
	WLW	4,W5UNDR11,F
	W0

fadeaside_seq5
	WL	-1,#store_vels
	WLW	3,W5UNDR2,FF
	WLW	3,W5UNDR3,FF
	WL	-1,seq_jump
	WL	-1,#restore_vels
	WL	-1,#announce_side_fade
	WLW	3,W5UNDR4,FF
	WLW	3,W5UNDR5,FF
	WLW	77,W5UNDR6,FF
;	WLW	3,W5UNDR7,FF
	WLW	3,W5UNDR8,FF
	WLW	77,W5UNDR9,FF
	WLW	4,W5UNDR10,FF
	WLW	4,W5UNDR11,FF
	W0

#announce_side_fade
	movk	7,a0
	calla	rndrng0
	sll	5,a0
	addi	#side_fade_sp_tbl,a0
	move	*a0,a0,L
	jrz	#asf
	calla	snd_play1
#asf	rets


#announce_fadeaway
	movk	8,a0
	calla	rndrng0
	sll	5,a0
	addi	#fadeaway_sp_tbl,a0
	move	*a0,a0,L
	jrz	#no
	calla	snd_play1
#no	rets

#announce_fadein
	movk	8,a0
	calla	rndrng0
	sll	5,a0
	addi	#fadein_sp_tbl,a0
	move	*a0,a0,L
	jrz	#no
	calla	snd_play1
#no1	rets


#side_fade_sp_tbl
	.long	fades_sp
	.long	leans_sp
	.long	0
	.long	pull_jmpr_sp
	.long	leans_sp
	.long	fades_sp
	.long	0
	.long	fades_sp

#fadeaway_sp_tbl
	.long	fades_sp
	.long	leans_bck_sp
	.long	fades_sp
	.long	0
	.long	fadeaway_sp
	.long	fades_sp
	.long	0
	.long	leans_bck_sp
	.long	fades_sp

#fadein_sp_tbl
	.long	leans_sp
	.long	0
	.long	leans_in_sp
	.long	pull_jmpr_sp
	.long	leans_sp
	.long	leans_in_sp
	.long	pull_jmpr_sp
	.long	0
	.long	leans_sp



#store_vels
	move	*a8(OXVEL),a0,L
	move	a0,@keep_xvel,L
	move	*a8(OZVEL),a0,L
	move	a0,@keep_zvel,L
	rets

#restore_vels
	move	@keep_xvel,a0,L
	move	a0,*a8(OXVEL),L
	move	@keep_zvel,a0,L
	move	a0,*a8(OZVEL),L
	rets


#*
undr_hoop_sht_tbl	;(team 2)
	.word	NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#6,#7,#8
#2
#8
	WLW	2,w2js1,F
#1a
	WLW	3,W1UNDR1,F
	WLW	3,W1UNDR2,F
	WL	-1,seq_jump
	WLL	-1,seq_snd,bslne_lnr_sp
	WL	-1,set_vels
	WLW	3,W1UNDR3,F
	WLW	3,W1UNDR4,F
	WLW	25,W1UNDR5,F
	WL	-1,plyr_shoot
	WLW	1,W1UNDR5,F
	WLW	3,W1UNDR6,F
	WLW	77,W1UNDR7,F
	WLW	3,W1UNDR8,F
	WLW	3,W1UNDR9,F
	WLW	-1,seq_newdir,0*16
	W0
#1
	WLW	2,w1js1,F
	WLL	-1,seq_goto_line,#1a
	W0

#4
	WLW	2,w4js1,F
#6
	WLW	3,W5UNDR1,F
	WLW	3,W5UNDR2,F
	WLW	3,W5UNDR3,F
	WL	-1,seq_jump
	WLL	-1,seq_snd,bslne_lnr_sp
	WL	-1,set_vels2
	WLW	3,W5UNDR4,F
	WLW	3,W5UNDR5,F
	WLW	26,W5UNDR6,F
	WL	-1,plyr_shoot
	WLW	2,W5UNDR7,F
	WLW	3,W5UNDR8,F
	WLW	77,W5UNDR9,F
	WLW	3,W5UNDR10,F
	WLW	3,W5UNDR11,F
	WLW	-1,seq_newdir,4*16
	W0
#3
#7
	WLW	2,w3js1,F

	WLW	3,W1UNDR1,F
	WLW	3,W1UNDR2,F
	WL	-1,seq_jump
	WLL	-1,seq_snd,bslne_lnr_sp
	WL	-1,set_vels3
	WLW	3,W1UNDR3,F
	WLW	3,W1UNDR4,F
	WLW	25,W1UNDR5,F
	WL	-1,plyr_shoot
	WLW	1,W1UNDR5,F
	WLW	3,W1UNDR6,F
	WLW	77,W1UNDR7,F
	WLW	3,W1UNDR8,F
	WLW	3,W1UNDR9,F
	WLW	-1,seq_newdir,0*16
	W0

#5
	WLW	3,W5UNDR1,F
	WLW	3,W5UNDR2,F
	WLW	3,W5UNDR3,F
	WL	-1,seq_jump
	WLL	-1,seq_snd,bslne_lnr_sp
	WL	-1,set_vels2
	WLW	3,W5UNDR4,F
	WLW	3,W5UNDR5,F
	WLW	26,W5UNDR6,F
	WL	-1,plyr_shoot
	WLW	2,W5UNDR7,F
	WLW	3,W5UNDR8,F
	WLW	77,W5UNDR9,F
	WLW	3,W5UNDR10,F
	WLW	3,W5UNDR11,F
	WLW	-1,seq_newdir,4*16
	W0



#*
undr_hoop_sht_tbl2	;(team 1)
	.word	NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#6,#7,#8

#1
	WLW	2,w1js1,FF
	WLL	-1,seq_goto_line,#1a
#2
	WLW	2,w2js1,FF
	WLL	-1,seq_goto_line,#1a
#8
	WLW	2,w2js1,F
	WLL	-1,seq_goto_line,#8a
#1a
	WLW	2,W1UNDR1,FF
	WLW	2,W1UNDR2,FF
	WL	-1,seq_jump
	WLL	-1,seq_snd,bslne_lnr_sp
	WL	-1,set_vels
	WLW	3,W1UNDR3,FF
	WLW	3,W1UNDR4,FF
	WLW	25,W1UNDR5,FF
	WL	-1,plyr_shoot
	WLW	1,W1UNDR5,FF
	WLW	3,W1UNDR6,FF
	WLW	77,W1UNDR7,FF
	WLW	3,W1UNDR8,FF
	WLW	3,W1UNDR9,FF
	WLW	-1,seq_newdir,0*16
	W0

#3
#7
	WLW	2,w3js1,F
#8a
	WLW	2,W1UNDR1,F
	WLW	2,W1UNDR2,F
	WL	-1,seq_jump
	WLL	-1,seq_snd,bslne_lnr_sp
	WL	-1,set_vels3
	WLW	3,W1UNDR3,F
	WLW	3,W1UNDR4,F
	WLW	25,W1UNDR5,F
	WL	-1,plyr_shoot
	WLW	1,W1UNDR5,F
	WLW	3,W1UNDR6,F
	WLW	77,W1UNDR7,F
	WLW	3,W1UNDR8,F
	WLW	3,W1UNDR9,F
	WLW	-1,seq_newdir,0*16
	W0

#5
	WLW	2,W5UNDR1,FF
	WLW	2,W5UNDR2,FF
	WLW	2,W5UNDR3,FF
	WL	-1,seq_jump
	WLL	-1,seq_snd,bslne_lnr_sp
	WL	-1,set_vels2
	WLW	3,W5UNDR4,FF
	WLW	3,W5UNDR5,FF
	WLW	26,W5UNDR6,FF
	WL	-1,plyr_shoot
	WLW	2,W5UNDR7,FF
	WLW	3,W5UNDR8,FF
	WLW	77,W5UNDR9,FF
	WLW	3,W5UNDR10,FF
	WLW	3,W5UNDR11,FF
	WLW	-1,seq_newdir,4*16
	W0

#4
	WLW	2,w4js1,F
#6
	WLW	2,W5UNDR1,F
	WLW	2,W5UNDR2,F
	WLW	2,W5UNDR3,F
	WL	-1,seq_jump
	WLL	-1,seq_snd,bslne_lnr_sp
	WL	-1,set_vels2
	WLW	3,W5UNDR4,F
	WLW	3,W5UNDR5,F
	WLW	26,W5UNDR6,F
	WL	-1,plyr_shoot
	WLW	2,W5UNDR7,F
	WLW	3,W5UNDR8,F
	WLW	77,W5UNDR9,F
	WLW	3,W5UNDR10,F
	WLW	3,W5UNDR11,F
	WLW	-1,seq_newdir,4*16
	W0



set_vels
	movi	00f000h,a14
	move	*a13(plyr_num),a0
	srl	1,a0
	jrnz	sxv_1			;br=team 2
	movi	-00f000h,a14
sxv_1	move	a14,*a8(OXVEL),L

	movi	013000h,a14
	move	a14,*a8(OZVEL),L
	rets


set_vels2
	movi	00f000h,a14
	move	*a13(plyr_num),a0
	srl	1,a0
	jrnz	sxv2_1			;br=team 2
	movi	-00f000h,a14
sxv2_1	move	a14,*a8(OXVEL),L

	movi	-00f000h,a14
	move	a14,*a8(OZVEL),L
	rets


set_vels3
	movi	006000h,a14
	move	*a13(plyr_num),a0
	srl	1,a0
	jrnz	sxv3_1			;br=team 2
	movi	-006000h,a14
sxv3_1	move	a14,*a8(OXVEL),L

	movi	025000h,a14
	move	a14,*a8(OZVEL),L
	rets


#*
shoot_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2

	.asg	3,N
#1
	WLW	N,w1js1,F
	WLLL	-1,seq_handle_fadeaside,fadeaside_seq1,fadeaside_seq1a
	WLW	N,w1js2,F
	WLW	1,w1js3,F
	WL	-1,seq_jump
	WLW	2,w1js3,F
	WLW	77,w1js4,F
	WLW	3,w1js5,F
	WLW	3,w1js6,F
	WLW	77,w1js7,F
	WLW	4,w1js8,F
	WLW	4,w1js9,F
	WLW	4,w1js10,F
	W0
#2
	WLW	N,w2js1,F
	WLW	N,w2js2,F
	WLLL	-1,seq_handle_fade_away,fadeaway_seq2,fadein_seq2
	WLW	1,w2js3,F
	WL	-1,seq_jump
	WLW	2,w2js3,F
	WLW	77,w2js4,F
	WLW	3,w2js5,F
	WLW	3,w2js6,F
	WLW	77,w2js7,F
	WLW	4,w2js8,F
	WLW	4,w2js9,F
	WLW	4,w2js10,F
	W0
#3
	WLW	N,w3js1,F
	WLW	N,w3js2,F
	WLLL	-1,seq_handle_fade_away,fadeaway_seq3,fadein_seq3
	WLW	1,w3js3,F
	WL	-1,seq_jump
	WLW	2,w3js3,F
	WLW	77,w3js4,F
	WLW	3,w3js5,F
	WLW	3,w3js6,F
	WLW	3,w3js7,F
	WLW	77,w3js8,F
	WLW	4,w3js9,F
	WLW	4,w3js10,F
	W0
#4
	WLW	N,w4js1,F
	WLW	N,w4js2,F
	WLLL	-1,seq_handle_fade_away,fadeaway_seq4,fadein_seq4
	WLW	1,w4js3,F
	WL	-1,seq_jump
	WLW	2,w4js3,F
	WLW	77,w4js4,F
	WLW	3,w4js5,F
	WLW	3,w4js6,F
	WLW	77,w4js7,F
	WLW	4,w4js8,F
	WLW	4,w4js9,F
	WLW	4,w4js10,F
	W0
#5
	WLW	N,w5js1,F
	WLLL	-1,seq_handle_fadeaside,fadeaside_seq5,fadeaside_seq5a
	WLW	N,w5js2,F
	WLW	1,w5js3,F
	WL	-1,seq_jump
	WLW	2,w5js3,F
	WLW	77,w5js4,F
	WLW	3,w5js5,F
	WLW	3,w5js6,F
	WLW	3,w5js7,F
	WLW	77,w5js8,F
	WLW	4,w5js9,F
	WLW	4,w5js10,F
	W0

#*
qshoot_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2

	.asg	3,N
#1
	WLW	N,w1js1,F
	WLW	N,w1js2,F
	WLW	N,w1js3,F
	WL	-1,seq_jump2
	WLW	77,w1js4,F
	WLW	N,w1js5,F
	WLW	N,w1js6,F
	WLW	77,w1js7,F
	WLW	4,w1js8,F
	WLW	3,w1js9,F
	WLW	3,w1js10,F
	W0
#2
	WLW	N,w2js1,F
	WLW	N,w2js2,F
	WLW	N,w2js3,F
	WL	-1,seq_jump2
	WLW	77,w2js4,F
	WLW	3,w2js5,F
	WLW	3,w2js6,F
	WLW	77,w2js7,F
	WLW	3,w2js8,F
	WLW	3,w2js9,F
	WLW	3,w2js10,F
	W0
#3
	WLW	N,w3js1,F
	WLW	N,w3js2,F
	WLW	N,w3js3,F
	WL	-1,seq_jump2
	WLW	77,w3js4,F
	WLW	3,w3js5,F
	WLW	3,w3js6,F
	WLW	3,w3js7,F
	WLW	77,w3js8,F
	WLW	3,w3js9,F
	WLW	3,w3js10,F
	W0
#4
	WLW	N,w4js1,F
	WLW	N,w4js2,F
	WLW	N,w4js3,F
	WL	-1,seq_jump2
	WLW	77,w4js4,F
	WLW	3,w4js5,F
	WLW	3,w4js6,F
	WLW	77,w4js7,F
	WLW	3,w4js8,F
	WLW	3,w4js9,F
	WLW	3,w4js10,F
	W0
#5
	WLW	N,w5js1,F
	WLW	N,w5js2,F
	WLW	N,w5js3,F
	WL	-1,seq_jump2
	WLW	77,w5js4,F
	WLW	3,w5js5,F
	WLW	3,w5js6,F
	WLW	3,w5js7,F
	WLW	77,w5js8,F
	WLW	3,w5js9,F
	WLW	3,w5js10,F
	W0

#*
;Hold and shoot desperations
shootdesp_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2

#1
#2
#3
#4
#5
;Use this as a pass also!
	WLW	3,T4DESPA1,F
	WLL	-1,seq_snd,swipe_snd
	WLW	3,T4DESPA2,F
	WL	-1,seq_jump
	WL	-1,#lower_jump
	WLW	3,T4DESPA3,F
	WLW	3,T4DESPA4,F
	WLW	1,T4DESPA5,F
	WL	-1,plyr_shoot
	WLW	2,T4DESPA5,F
	WLW	50,T4DESPA6,F
	WLW	3,T4DESPA7,F
	WLW	3,T4DESPA8,F
;Never see these frames
;	WLW	4,T4DESPA9,F
;	WLW	4,T4DESPA10,F
	W0

#lower_jump
	move	*a8(OYVEL),a0,L
	sra	1,a0
	move	a0,*a8(OYVEL),L

	jruc	lower_jump


#*
shootdesp3_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
#1
#2
#3
#4
#5
	WLW	4,T3DESPB1,F
	WLW	4,T3DESPB2,F
	WL	-1,seq_jump
	WL	-1,lower_jump
	WLW	50,T3DESPB3,F
	WLW	3,T3DESPB4,F
	WLW	3,T3DESPB5,F
	WLW	50,T3DESPB6,F
	WLW	3,T3DESPB7,F
	WLW	3,T3DESPB8,F
;Never see these frames
;	WLW	4,T3DESPB9,F
;	WLW	4,T3DESPB10,F
	W0


lower_jump
;	move	*a8(OYVEL),a0,L
;	sra	1,a0
;	move	a0,*a8(OYVEL),L

;Give seq a little x drift
	movi	>10000,a2		;For this desperation shot, we
	move	*a13(plyr_num),a0	;need some x velocity
	subk	2,a0
	jrlt	#ok
	movi	->10000,a2
#ok	move	a2,*a8(OXVEL),L
	rets
	

#*
;Grenade launch - last second shot
shootdesp2_t
	.word	NOJUMP_M|SHOOT_M|NOJOY_M
	.long	seq_stand
	.long	#3,#3,#3,#3,#3,#3,#3,#3
#3
	WLW	2,T3DESPA1,F
	WLL	-1,seq_snd,swipe_snd
	WLW	2,T3DESPA2,F
	WLW	2,T3DESPA3,F
	WLW	2,T3DESPA4,F
	WL	-1,seq_jump
	WLW	2,T3DESPA5,F
	WLW	2,T3DESPA6,F
	WL	-1,plyr_shoot
	WLW	66,T3DESPA7,F
;Never see these frames
;	WLW	4,T3DESPA8,F
;	WLW	4,T3DESPA9,F
;	WLW	4,T3DESPA10,F
	W0

#*
;shootdesp3_t
;	.word	NOJUMP_M|SHOOT_M|NOJOY_M
;	.long	seq_stand
;	.long	#3,#3,#3,#3,#3,#3,#3,#3
;#3
;	WLW	4,T2DESP1,F
;	WLW	4,T2DESP2,F
;	WL	-1,seq_jump
;	WLW	12h,T2DESP3,F
;	WLW	62h,T2DESP4,F
;	WLW	28,T2DESP5,F
;	WLW	4,T2DESP6,F
;	W0


#*	;(chest pass)
passc_t		
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#passc1_l,#passc2_l,#passc3_l,#passc4_l
	.long	#passc5_l,#passc4_l,#passc3_l,#passc2_l
	.asg	3,N
#passc1_l
	WLW	N,w1cp1,F
	WLW	N,w1cp2,F
	WLW	N,w1cp3,F
	WLW	N,w1cp4,F
	WL	-1,plyr_pass
	WLW	N,w1cp5,F
	WLW	N,w1cp6,F
	WLW	N,w1cp5,F
	WLW	N,w1cp4,F
	WLW	N,w1cp3,F
	WLW	N,w1cp2,F
	WLW	N,w1cp1,F
	W0
#passc2_l
	WLW	N,w2cp1,F
	WLW	N,w2cp2,F
	WLW	N,w2cp3,F
	WLW	N,w2cp4,F
	WL	-1,plyr_pass
	WLW	N,w2cp5,F
	WLW	N,w2cp6,F
	WLW	N,w2cp5,F
	WLW	N,w2cp4,F
	WLW	N,w2cp3,F
	WLW	N,w2cp2,F
	WLW	N,w2cp1,F
	W0
#passc3_l
	WLW	N,w3cp1,F
	WLW	N,w3cp2,F
	WLW	N,w3cp3,F
	WLW	N,w3cp4,F
	WL	-1,plyr_pass
	WLW	N,w3cp5,F
	WLW	N,w3cp6,F
	WLW	N,w3cp5,F
	WLW	N,w3cp4,F
	WLW	N,w3cp3,F
	WLW	N,w3cp2,F
	WLW	N,w3cp1,F
	W0
#passc4_l
	WLW	N,w4cp1,F
	WLW	N,w4cp2,F
	WLW	N,w4cp3,F
	WLW	N,w4cp4,F
	WL	-1,plyr_pass
	WLW	N,w4cp5,F
	WLW	N,w4cp6,F
	WLW	N,w4cp5,F
	WLW	N,w4cp4,F
	WLW	N,w4cp3,F
	WLW	N,w4cp2,F
	WLW	N,w4cp1,F
	W0
#passc5_l
	WLW	N,w5cp1,F
	WLW	N,w5cp2,F
	WLW	N,w5cp3,F
	WLW	N,w5cp4,F
	WL	-1,plyr_pass
	WLW	N,w5cp5,F
	WLW	N,w5cp6,F
	WLW	N,w5cp5,F
	WLW	N,w5cp4,F
	WLW	N,w5cp3,F
	WLW	N,w5cp2,F
	WLW	N,w5cp1,F
	W0

#*	;(fast, chest pass)
fastpassc_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#passc1_l,#passc2_l,#passc3_l,#passc4_l
	.long	#passc5_l,#passc4_l,#passc3_l,#passc2_l
	.asg	2,N
#passc1_l
	WLW	N,w1cp1,F
	WLW	N,w1cp2,F
	WLW	N,w1cp3,F
	WLW	N,w1cp4,F
	WL	-1,plyr_pass
	WLW	N,w1cp5,F
	WLW	N,w1cp6,F
	WLW	N,w1cp5,F
	WLW	N,w1cp4,F
	WLW	N,w1cp3,F
	WLW	N,w1cp2,F
	WLW	N,w1cp1,F
	W0
#passc2_l
	WLW	N,w2cp1,F
	WLW	N,w2cp2,F
	WLW	N,w2cp3,F
	WLW	N,w2cp4,F
	WL	-1,plyr_pass
	WLW	N,w2cp5,F
	WLW	N,w2cp6,F
	WLW	N,w2cp5,F
	WLW	N,w2cp4,F
	WLW	N,w2cp3,F
	WLW	N,w2cp2,F
	WLW	N,w2cp1,F
	W0
#passc3_l
	WLW	N,w3cp1,F
	WLW	N,w3cp2,F
	WLW	N,w3cp3,F
	WLW	N,w3cp4,F
	WL	-1,plyr_pass
	WLW	N,w3cp5,F
	WLW	N,w3cp6,F
	WLW	N,w3cp5,F
	WLW	N,w3cp4,F
	WLW	N,w3cp3,F
	WLW	N,w3cp2,F
	WLW	N,w3cp1,F
	W0
#passc4_l
	WLW	N,w4cp1,F
	WLW	N,w4cp2,F
	WLW	N,w4cp3,F
	WLW	N,w4cp4,F
	WL	-1,plyr_pass
	WLW	N,w4cp5,F
	WLW	N,w4cp6,F
	WLW	N,w4cp5,F
	WLW	N,w4cp4,F
	WLW	N,w4cp3,F
	WLW	N,w4cp2,F
	WLW	N,w4cp1,F
	W0
#passc5_l
	WLW	N,w5cp1,F
	WLW	N,w5cp2,F
	WLW	N,w5cp3,F
	WLW	N,w5cp4,F
	WL	-1,plyr_pass
	WLW	N,w5cp5,F
	WLW	N,w5cp6,F
	WLW	N,w5cp5,F
	WLW	N,w5cp4,F
	WLW	N,w5cp3,F
	WLW	N,w5cp2,F
	WLW	N,w5cp1,F
	W0


#*	;(dish out, of dunk, or rebound!)
passdo_t
	.word	PASS_M|NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#passdo1_l,#passdo2_l,#passdo3_l,#passdo4_l
	.long	#passdo5_l,#passdo4_l,#passdo3_l,#passdo2_l

#passdo1_l
	WL	-1,dble_yvel
	WLW	1,w1jupa,F
	WL	-1,plyr_pass
	WLW	4,w1jupa,F
	WLW	77,w1js4,F
	WLW	4,w1js2,F
	WLW	3,w1js1,F
	W0
#passdo2_l
	WL	-1,dble_yvel
	WLW	1,w2jupa,F
	WL	-1,plyr_pass
	WLW	4,w2jupa,F
	WLW	77,w2js4,F
	WLW	3,w2js3,F
	WLW	3,w2js2,F
	WLW	2,w2js1,F
	W0
#passdo3_l
	WL	-1,dble_yvel
	WLW	1,w3jupa,F
	WL	-1,plyr_pass
	WLW	4,w3jupa,F
	WLW	77,w3js5,F
	WLW	3,w3js4,F
	WLW	3,w3js3,F
	WLW	3,w3js2,F
	WLW	2,w3js1,F
	W0
#passdo4_l
	WL	-1,dble_yvel
	WLW	1,w4jupa,F
	WL	-1,plyr_pass
	WLW	4,w4jupa,F
	WLW	77,w4js5,F
	WLW	3,w4js4,F
	WLW	3,w4js3,F
	WLW	3,w4js2,F
	WLW	2,w4js1,F
	W0
#passdo5_l
	WL	-1,dble_yvel
	WLW	1,w5jupa,F
	WL	-1,plyr_pass
	WLW	4,w5jupa,F
	WLW	77,w5js4,F
	WLW	3,w5js3,F
	WLW	3,w5js2,F
	WLW	2,w5js1,F
	W0

passdo2_t
	.word	PASS_M|NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#passdo21_l,#passdo22_l,#passdo23_l,#passdo24_l
	.long	#passdo25_l,#passdo24_l,#passdo23_l,#passdo22_l

#passdo21_l
	WL	-1,dble_yvel
	WLW	1,w1js4,F
	WL	-1,plyr_pass
	WLW	77,w1js4,F
	WLW	4,w1js2,F
	WLW	3,w1js1,F
	W0
#passdo22_l
	WL	-1,dble_yvel
	WLW	1,w2js4,F
	WL	-1,plyr_pass
	WLW	77,w2js4,F
	WLW	3,w2js3,F
	WLW	3,w2js2,F
	WLW	2,w2js1,F
	W0
#passdo23_l
	WL	-1,dble_yvel
	WLW	1,w3js5,F
	WL	-1,plyr_pass
	WLW	77,w3js5,F
	WLW	3,w3js4,F
	WLW	3,w3js3,F
	WLW	3,w3js2,F
	WLW	2,w3js1,F
	W0
#passdo24_l
	WL	-1,dble_yvel
	WLW	1,w4js5,F
	WL	-1,plyr_pass
	WLW	77,w4js5,F
	WLW	3,w4js4,F
	WLW	3,w4js3,F
	WLW	3,w4js2,F
	WLW	2,w4js1,F
	W0
#passdo25_l
	WL	-1,dble_yvel
	WLW	1,w5js4,F
	WL	-1,plyr_pass
	WLW	77,w5js4,F
	WLW	3,w5js3,F
	WLW	3,w5js2,F
	WLW	2,w5js1,F
	W0


dble_yvel
	move	*a8(OYVEL),a14,L
	jrz	#ex
	addi	30000h,a14
	move	a14,*a8(OYVEL),L
	rets
#ex
;	LOCKUP
;	nop
	rets


#*     ;(short, chest pass)
passs_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
	.asg	2,N
#1
	WLW	N,w1cp1,F
	WLW	N,w1cp2,F
	WLW	N,w1cp3,F
	WLW	N,w1cp4,F
	WL	-1,plyr_pass
;	WLW	N,w1cp5,F
	WLW	N,w1cp4,F
	WLW	N,w1cp3,F
	WLW	N,w1cp2,F
	WLW	N,w1cp1,F
	W0
#2
	WLW	N,w2cp1,F
	WLW	N,w2cp2,F
	WLW	N,w2cp3,F
	WLW	N,w2cp4,F
	WL	-1,plyr_pass
;	WLW	N,w2cp5,F
	WLW	N,w2cp4,F
	WLW	N,w2cp3,F
	WLW	N,w2cp2,F
	WLW	N,w2cp1,F
	W0
#3
	WLW	N,w3cp1,F
	WLW	N,w3cp2,F
	WLW	N,w3cp3,F
	WLW	N,w3cp4,F
	WL	-1,plyr_pass
;	WLW	N,w3cp5,F
	WLW	N,w3cp4,F
	WLW	N,w3cp3,F
	WLW	N,w3cp2,F
	WLW	N,w3cp1,F
	W0
#4
	WLW	N,w4cp1,F
	WLW	N,w4cp2,F
	WLW	N,w4cp3,F
	WLW	N,w4cp4,F
	WL	-1,plyr_pass
;	WLW	N,w4cp5,F
	WLW	N,w4cp4,F
	WLW	N,w4cp3,F
	WLW	N,w4cp2,F
	WLW	N,w4cp1,F
	W0
#5
	WLW	N,w5cp1,F
	WLW	N,w5cp2,F
	WLW	N,w5cp3,F
	WLW	N,w5cp4,F
	WL	-1,plyr_pass
;	WLW	N,w5cp5,F
	WLW	N,w5cp4,F
	WLW	N,w5cp3,F
	WLW	N,w5cp2,F
	WLW	N,w5cp1,F
	W0


#*	;(overhead pass)
passnewoh_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#passnoh1_l,#passnoh2_l,#passnoh3_l,#passnoh4_l
	.long	#passnoh5_l,#passnoh4_l,#passnoh3_l,#passnoh2_l

	.asg	3,N
#passnoh1_l
	WLW	N,w1ohp1,F
	WLW	N,w1ohp2,F
	WLW	N,w1ohp3,F
	WLW	N,w1ohp4,F
	WLW	N,w1ohp5,F
	WLW	N,w1ohp6,F
	WLW	N-2,w1ohp7,F
	WL	-1,plyr_pass
	WLW	N-1,w1ohp7,F
	WLW	N,w1ohp8,F
	WLW	N,w1ohp9,F
	WLW	N,w1ohp10,F
	WLW	N,w1ohp11,F
	W0
#passnoh2_l
	WLW	N,w2ohp1,F
	WLW	N,w2ohp2,F
	WLW	N,w2ohp3,F
	WLW	N,w2ohp4,F
	WLW	N,w2ohp5,F
	WLW	N-1,w2ohp6,F
	WL	-1,plyr_pass
	WLW	N-1,w2ohp7,F
	WLW	N,w2ohp8,F
	WLW	N,w2ohp9,F
	WLW	N,w2ohp10,F
	WLW	N,w2ohp11,F
	W0
#passnoh3_l
;If passer is facing #4 or #5 and we are doing a #3 pass, sometimes use
;desperation art as a pass!
	WL	-1,choose_desp

	WLW	N,w3ohp1,F
	WLW	N,w3ohp2,F
	WLW	N,w3ohp3,F
	WLW	N,w3ohp4,F
	WLW	N,w3ohp5,F
	WLW	N-1,w3ohp6,F
	WL	-1,plyr_pass
	WLW	1,w3ohp6,F
	WLW	N,w3ohp7,F
	WLW	N,w3ohp8,F
	WLW	N,w3ohp9,F
	WLW	N,w3ohp10,F
	WLW	N,w3ohp11,F
	W0

choose_desp
	move	*a13(plyr_tmdist),a14
	cmpi	180,a14
	jrlt	#not
	movi	600,a0
	calla	RNDPER
	jrls	#not
;Need to look at dir I was facing - not where pass code tells me to face.
	move	*a13(plyr_old_seqdir),a0
	cmpi	3,a0
	jrz	#yes
	cmpi	4,a0
	jrz	#yes
	cmpi	5,a0
	jrnz	#not

#yes
	movi	#desp_pass,b4
#not
	rets
	.def	T4DESPA5

#desp_pass
	WLW	3,T4DESPA1,F
	WLW	3,T4DESPA2,F
	WLW	3,T4DESPA3,F
	WLW	3,T4DESPA4,F
	WLW	1,T4DESPA5,F
	WL	-1,plyr_pass
	WLW	2,T4DESPA5,F
	WLW	50,T4DESPA6,F
	WLW	3,T4DESPA7,F
	WLW	3,T4DESPA8,F
;Never see these frames
;	WLW	4,T4DESPA9,F
;	WLW	4,T4DESPA10,F
	WLW	-1,seq_newdir,2*16
	W0




#passnoh4_l
	WLW	N,w4ohp1,F
	WLW	N,w4ohp2,F
	WLW	N,w4ohp3,F
	WLW	N,w4ohp4,F
	WLW	N,w4ohp5,F
	WLW	N,w4ohp6,F
	WLW	N-1,w4ohp7,F
	WL	-1,plyr_pass
	WLW	1,w4ohp7,F
	WLW	N,w4ohp8,F
	WLW	N,w4ohp9,F
	WLW	N,w4ohp10,F
	WLW	N,w4ohp11,F
	W0
#passnoh5_l
	WLW	N,w5ohp1,F
	WLW	N,w5ohp2,F
	WLW	N,w5ohp3,F
	WLW	N,w5ohp4,F
	WLW	N,w5ohp5,F
	WLW	N,w5ohp6,F
	WLW	N-2,w5ohp7,F
	WL	-1,plyr_pass
	WLW	N-1,w5ohp7,F
	WLW	N,w5ohp8,F
	WLW	N,w5ohp9,F
	WLW	N,w5ohp10,F
	WLW	N,w5ohp11,F
	W0


#*	;(fast, overhead pass)
fastpassnewoh_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#passnoh1_l,#passnoh2_l,#passnoh3_l,#passnoh4_l
	.long	#passnoh5_l,#passnoh4_l,#passnoh3_l,#passnoh2_l

	.asg	2,N
#passnoh1_l
	WLW	N,w1ohp1,F
	WLW	N,w1ohp2,F
	WLW	N,w1ohp3,F
	WLW	N,w1ohp4,F
	WLW	N,w1ohp5,F
	WLW	N,w1ohp6,F
	WLW	1,w1ohp7,F
	WL	-1,plyr_pass
	WLW	1,w1ohp7,F
	WLW	N,w1ohp8,F
	WLW	N,w1ohp9,F
	WLW	N,w1ohp10,F
	WLW	N,w1ohp11,F
	W0
#passnoh2_l
	WLW	N,w2ohp1,F
	WLW	N,w2ohp2,F
	WLW	N,w2ohp3,F
	WLW	N,w2ohp4,F
	WLW	N,w2ohp5,F
	WLW	1,w2ohp6,F
	WL	-1,plyr_pass
	WLW	1,w2ohp6,F
	WLW	N,w2ohp7,F
	WLW	N,w2ohp8,F
	WLW	N,w2ohp9,F
	WLW	N,w2ohp10,F
	WLW	N,w2ohp11,F
	W0
#passnoh3_l
	WL	-1,choose_desp

	WLW	N,w3ohp1,F
	WLW	N,w3ohp2,F
	WLW	N,w3ohp3,F
	WLW	N,w3ohp4,F
	WLW	N,w3ohp5,F
	WLW	1,w3ohp6,F
	WL	-1,plyr_pass
	WLW	1,w3ohp6,F
	WLW	N,w3ohp7,F
	WLW	N,w3ohp8,F
	WLW	N,w3ohp9,F
	WLW	N,w3ohp10,F
	WLW	N,w3ohp11,F
	W0
#passnoh4_l
	WLW	N,w4ohp1,F
	WLW	N,w4ohp2,F
	WLW	N,w4ohp3,F
	WLW	N,w4ohp4,F
	WLW	N,w4ohp5,F
	WLW	N,w4ohp6,F
	WLW	1,w4ohp7,F
	WL	-1,plyr_pass
	WLW	1,w4ohp7,F
	WLW	N,w4ohp8,F
	WLW	N,w4ohp9,F
	WLW	N,w4ohp10,F
	WLW	N,w4ohp11,F
	W0
#passnoh5_l
	WLW	N,w5ohp1,F
	WLW	N,w5ohp2,F
	WLW	N,w5ohp3,F
	WLW	N,w5ohp4,F
	WLW	N,w5ohp5,F
	WLW	N,w5ohp6,F
	WLW	1,w5ohp7,F
	WL	-1,plyr_pass
	WLW	1,w5ohp7,F
	WLW	N,w5ohp8,F
	WLW	N,w5ohp9,F
	WLW	N,w5ohp10,F
	WLW	N,w5ohp11,F
	W0



#*
passbh_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#1,#1,#1,#1,#1,#1,#1,#1

	.asg	3,N
#1
	WL	-1,#choose
#1a
	WLW	N,T1HINDR10,F
	WLW	N,T1HINDR9,F
	WLW	N-1,T1HINDR8,F
	WLW	N-1,T1HINDR7,F
	WL	-1,plyr_pass
	WLW	N+1,T1HINDR6,F
	WLW	N,T1HINDR7,F
	WLW	N,T1HINDR8,F
	WLW	N,T1HINDR9,F
	WLW	N,T1HINDR10,F
	WLW	-1,seq_newdir,0*16
	W0

#choose
;Need to look at dir I was facing - not where pass code tells me to face.
	move	*a13(plyr_old_seqdir),a0
	sll	5,a0
	addi	#tbl,a0
	move	*a0,a0,L
	move	a0,b4
	rets

#tbl	.long	#1a,#2,#3,#4,#5,#6,#7,#8


#2
#8
	WLW	N,T2HINDR10,F
	WLW	N,T2HINDR9,F
	WLW	N-1,T2HINDR8,F
	WLW	N-1,T2HINDR7,F
	WL	-1,plyr_pass
	WLW	N+1,T2HINDR6,F
	WLW	N,T2HINDR7,F
	WLW	N,T2HINDR8,F
	WLW	N,T2HINDR9,F
	WLW	N,T2HINDR10,F
	WLW	-1,seq_newdir,1*16
	W0

#3
#7
	WLW	N,T3HINDR10,F
	WLW	N,T3HINDR9,F
	WLW	N-1,T3HINDR8,F
	WLW	N-1,T3HINDR7,F
	WL	-1,plyr_pass
	WLW	N+1,T3HINDR6,F
	WLW	N,T3HINDR7,F
	WLW	N,T3HINDR8,F
	WLW	N,T3HINDR9,F
	WLW	N,T3HINDR10,F
	WLW	-1,seq_newdir,2*16
	W0
#4
#5
#6
	WLW	N,T4HINDR10,F
	WLW	N,T4HINDR9,F
	WLW	N-1,T4HINDR8,F
	WLW	N-1,T4HINDR7,F
	WL	-1,plyr_pass
	WLW	N+1,T4HINDR6,F
	WLW	N,T4HINDR7,F
	WLW	N,T4HINDR8,F
	WLW	N,T4HINDR9,F
	WLW	N,T4HINDR10,F
	WLW	-1,seq_newdir,3*16
	W0

#*
passbh2_t
	.word	PASS_M|NOJOY_M
	.long	seq_stand
	.long	#1,#1,#1,#1,#1,#1,#1,#1

	.asg	3,N
#choose
;Need to look at dir I was facing - not where pass code tells me to face.
	move	*a13(plyr_old_seqdir),a0
	sll	5,a0
	addi	#tbl,a0
	move	*a0,a0,L
	move	a0,b4
	rets

#tbl	.long	#1a,#2,#3,#4,#5,#6,#7,#8

#1
	WL	-1,#choose
#1a
;Should never get here...

#8
#2
	WLW	N,T2HINDL10,F
	WLW	N,T2HINDL9,F
	WLW	N-1,T2HINDL8,F
	WLW	N-1,T2HINDL7,F
	WL	-1,plyr_pass
	WLW	N+1,T2HINDL6,F
	WLW	N,T2HINDL7,F
	WLW	N,T2HINDL8,F
	WLW	N,T2HINDL9,F
	WLW	N,T2HINDL10,F
	WLW	-1,seq_newdir,1*16
	W0

#3
#7
	WLW	N,T3HINDL10,F
	WLW	N,T3HINDL9,F
	WLW	N-1,T3HINDL8,F
	WLW	N-1,T3HINDL7,F
	WL	-1,plyr_pass
	WLW	N+1,T3HINDL6,F
	WLW	N,T3HINDL7,F
	WLW	N,T3HINDL8,F
	WLW	N,T3HINDL9,F
	WLW	N,T3HINDL10,F
	WLW	-1,seq_newdir,2*16
	W0
#4
	WLW	N,T4HINDL10,F
	WLW	N,T4HINDL9,F
	WLW	N-1,T4HINDL8,F
	WLW	N-1,T4HINDL7,F
	WL	-1,plyr_pass
	WLW	N+1,T4HINDL6,F
	WLW	N,T4HINDL7,F
	WLW	N,T4HINDL8,F
	WLW	N,T4HINDL9,F
	WLW	N,T4HINDL10,F
	WLW	-1,seq_newdir,3*16
	W0
#5
#6
;Is this seq used?
	WLW	N,T4HINDR10,F
	WLW	N,T4HINDR9,F
	WLW	N-1,T4HINDR8,F
	WLW	N-1,T4HINDR7,F
	WL	-1,plyr_pass
	WLW	N+1,T4HINDR6,F
	WLW	N,T4HINDR7,F
	WLW	N,T4HINDR8,F
	WLW	N,T4HINDR9,F
	WLW	N,T4HINDR10,F
	WLW	-1,seq_newdir,3*16
	W0


#*
steal_t
	.word	NOMV_M|NOSTEAL_M|NOJUMP_M|NOJOY_M
	.long	seq_stealstand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
#1
	WLW	1,T1SWPE5,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T1SWPE6,F
	WLW	1,T1SWPE7,F
	WLW	1,T1SWPE8,F
	WLW	1,T1SWPE9,F
	WLW	1,T1SWPE10,F
	WLW	1,T1SWPE11,F
	WLW	1,T1SWPE12,F
	WL	-1,seq_stealstand
	WLW	1,T1SWPE11,F
	WLW	1,T1SWPE10,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T1SWPE9,F
	WLW	1,T1SWPE8,F
	WLW	1,T1SWPE7,F
	WLW	1,T1SWPE6,F
	WLW	1,T1SWPE5,F
	WL	-1,seq_stealstand
	WLW	1,T1SWPE4,F
	WLW	1,T1SWPE3,F
	WLW	1,T1SWPE2,F
	WLW	1,T1SWPE1,F
	WLW	1,T1SWPE2,F
	WLW	1,T1SWPE3,F
	WLW	1,T1SWPE4,F
	W0
#2
	WLW	1,T2SWPE3,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T2SWPE4,F
	WLW	1,T2SWPE5,F
	WLW	1,T2SWPE6,F
	WLW	1,T2SWPE7,F
	WLW	1,T2SWPE8,F
	WLW	1,T2SWPE9,F
	WLW	1,T2SWPE10,F
	WL	-1,seq_stealstand
	WLW	1,T2SWPE11,F
	WLW	1,T2SWPE12,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T2SWPE11,F
	WLW	1,T2SWPE10,F
	WLW	1,T2SWPE9,F
	WLW	1,T2SWPE8,F
	WLW	1,T2SWPE7,F
	WL	-1,seq_stealstand
	WLW	1,T2SWPE6,F
	WLW	1,T2SWPE5,F
	WLW	1,T2SWPE4,F
	WLW	1,T2SWPE3,F
	WLW	1,T2SWPE2,F
	WLW	1,T2SWPE1,F
	WLW	1,T2SWPE2,F
	W0
#3
	WLW	1,T3SWPE5,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T3SWPE6,F
	WLW	1,T3SWPE7,F
	WLW	1,T3SWPE8,F
	WLW	1,T3SWPE9,F
	WLW	1,T3SWPE10,F
	WLW	1,T3SWPE11,F
	WLW	1,T3SWPE12,F
	WL	-1,seq_stealstand
	WLW	1,T3SWPE11,F
	WLW	1,T3SWPE10,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T3SWPE9,F
	WLW	1,T3SWPE8,F
	WLW	1,T3SWPE7,F
	WLW	1,T3SWPE6,F
	WLW	1,T3SWPE5,F
	WL	-1,seq_stealstand
	WLW	1,T3SWPE4,F
	WLW	1,T3SWPE3,F
	WLW	1,T3SWPE2,F
	WLW	1,T3SWPE1,F
	WLW	1,T3SWPE2,F
	WLW	1,T3SWPE3,F
	WLW	1,T3SWPE4,F
	W0
#4
	WLW	1,T4SWPE6,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T4SWPE7,F
	WLW	1,T4SWPE8,F
	WLW	1,T4SWPE9,F
	WLW	1,T4SWPE10,F
	WLW	1,T4SWPE11,F
	WLW	1,T4SWPE12,F
	WLW	1,T4SWPE11,F
	WL	-1,seq_stealstand
	WLW	1,T4SWPE10,F
	WLW	1,T4SWPE9,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T4SWPE8,F
	WLW	1,T4SWPE7,F
	WLW	1,T4SWPE6,F
	WLW	1,T4SWPE5,F
	WLW	1,T4SWPE4,F
	WL	-1,seq_stealstand
	WLW	1,T4SWPE3,F
	WLW	1,T4SWPE2,F
	WLW	1,T4SWPE1,F
	WLW	1,T4SWPE2,F
	WLW	1,T4SWPE3,F
	WLW	1,T4SWPE4,F
	WLW	1,T4SWPE5,F
	W0
#5
	WLW	1,T5SWPE5,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T5SWPE6,F
	WLW	1,T5SWPE7,F
	WLW	1,T5SWPE8,F
	WLW	1,T5SWPE9,F
	WLW	1,T5SWPE10,F
	WLW	1,T5SWPE11,F
	WLW	1,T5SWPE12,F
	WL	-1,seq_stealstand
	WLW	1,T5SWPE11,F
	WLW	1,T5SWPE10,F
	WLL	-1,seq_snd,swipe_snd
	WLW	1,T5SWPE9,F
	WLW	1,T5SWPE8,F
	WLW	1,T5SWPE7,F
	WLW	1,T5SWPE6,F
	WLW	1,T5SWPE5,F
	WL	-1,seq_stealstand
	WLW	1,T5SWPE4,F
	WLW	1,T5SWPE3,F
	WLW	1,T5SWPE2,F
	WLW	1,T5SWPE1,F
	WLW	1,T5SWPE2,F
	WLW	1,T5SWPE3,F
	WLW	1,T5SWPE4,F
	W0

#*
push_t
	.word	NOMV_M|NOJUMP_M|NOJOY_M
	.long	seq_stand
	.long	#1,#2,#3,#4,#5,#4,#3,#2
#1
	WLW	2,w1push1,F
	WLW	2,w1push2,F
	WLW	4,w1push3,F
	WL	-1,seq_push
	WLW	2,w1push4,F
	WLW	2,w1push5,F
	WLW	2,w1push6,F
	WLW	2,w1push7,F
	WLW	2,w1push8,F
	WLW	2,w1push9,F
	WLW	2,w1push10,F
	WLW	2,w1push11,F
	W0
#2
	WLW	2,w2push1,F
	WLW	2,w2push2,F
	WLW	4,w2push3,F
	WL	-1,seq_push
	WLW	2,w2push4,F
	WLW	2,w2push5,F
	WLW	2,w2push6,F
	WLW	2,w2push7,F
	WLW	2,w2push8,F
	WLW	2,w2push9,F
	WLW	2,w2push10,F
	WLW	2,w2push11,F
	W0
#3
	WLW	2,w3push1,F
	WLW	2,w3push2,F
	WLW	4,w3push3,F
	WL	-1,seq_push
	WLW	2,w3push4,F
	WLW	2,w3push5,F
	WLW	2,w3push6,F
	WLW	2,w3push7,F
	WLW	2,w3push8,F
	WLW	2,w3push9,F
	WLW	2,w3push10,F
	WLW	2,w3push11,F
	W0
#4
	WLW	2,w4push1,F
	WLW	2,w4push2,F
	WLW	4,w4push3,F
	WL	-1,seq_push
	WLW	2,w4push4,F
	WLW	2,w4push5,F
	WLW	2,w4push6,F
	WLW	2,w4push7,F
	WLW	2,w4push8,F
	WLW	2,w4push9,F
	WLW	2,w4push10,F
	WLW	2,w4push11,F
	W0
#5
	WLW	2,w5push1,F
	WLW	2,w5push2,F
	WLW	4,w5push3,F
	WL	-1,seq_push
	WLW	2,w5push4,F
	WLW	2,w5push5,F
	WLW	2,w5push6,F
	WLW	2,w5push7,F
	WLW	2,w5push8,F
	WLW	2,w5push9,F
	WLW	2,w5push10,F
	WLW	2,w5push11,F
	W0

	.end






