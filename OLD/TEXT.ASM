**************************************************************
*
* Software:		Mark Turmell
* Initiated:		4/13/89
*
* Modified:		Shawn Liptak, 2/19/92	-Started basketball
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/21/92 15:04
**************************************************************
	.file	"text.asm"
	.title	"font tables"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"text.tbl"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"


	.ref	DUXPAL		;text.tbl


;,RD19FONT
	.def	RD7FONT,RD15FONT,FONT7A,FON15A
 
	.def	FON150,FON151,FON152,FON153,FON154,FON155,FON156,FON157
	.def	FON158,FON159
	.def   	FON15X,FON15W,FON15V,FON15M,FONT7colon


	.text

**************************************************************************
* Font tables starting at ASCII 33
**************************************************************************

;7 POINT FONT

RD7FONT
	.long  FONT7excla,FONT7quote,FONT7pound,FONT7doll,FONT7percen,FONT7and
	.long  FONT7apost,FONT7parenl,FONT7parenr,FONT7ast,FONT7plus
	.long  FONT7comma,FONT7dash,FONT7period,FONT7forsp,FONT70,FONT71
	.long  FONT72,FONT73,FONT74,FONT75,FONT76,FONT77,FONT78,FONT79
	.long  FONT7colon,FONT7semicol,FONT7less,FONT7equal,FONT7more
	.long  FONT7quest,FONT7dash
	.long  FONT7A,FONT7B,FONT7C,FONT7D,FONT7E,FONT7F,FONT7G,FONT7H
	.long  FONT7I,FONT7J,FONT7K,FONT7L,FONT7M,FONT7N,FONT7O,FONT7P
	.long  FONT7Q,FONT7R,FONT7S,FONT7T,FONT7U,FONT7V,FONT7W,FONT7X
	.long  FONT7Y,FONT7Z
	.long  FONT7bracl,FONT7backsp,FONT7bracr,FONT7excla,FONT7line
	.long  FONT7apost	
	.long  FONT7a,FONT7b,FONT7c,FONT7d,FONT7e,FONT7f,FONT7g,FONT7h
	.long  FONT7i,FONT7j,FONT7k,FONT7l,FONT7m,FONT7n,FONT7o,FONT7p
	.long  FONT7q,FONT7r,FONT7s,FONT7t,FONT7u,FONT7v,FONT7W,FONT7X
	.long  FONT7Y,FONT7Z
	.long  FONT7paren2l,FONT7break,FONT7paren2r

;15 POINT FONT. @ is missing (GNP 10/20/88)

RD15FONT
	.long  FON15excla,FON15quote,FON15poun,FON15doll,FON15perc,FON15and
	.long  FON15apos,FON15parenl,FON15parenr,FON15ast,FON15plus
	.long  FON15comma,FON15dash,FON15period,FON15forsp,FON150,FON151
	.long  FON152,FON153,FON154,FON155,FON156,FON157,FON158,FON159
	.long  FON15colon,FON15semicol,FON15less,FON15equal,FON15more
	.long  FON15quest,FON15dash
;WARPTXT
	.long  FON15A,FON15B,FON15C,FON15D,FON15E,FON15F,FON15G,FON15H
	.long  FON15I,FON15J,FON15K,FON15L,FON15M,FON15N,FON15O,FON15P
	.long  FON15Q,FON15R,FON15S,FON15T,FON15U,FON15V,FON15W,FON15X
	.long  FON15Y,FON15Z
	.long  FON15brackl,FON15backsp,FON15brackr,FON15carr,FON15line
	.long  FON15apos1	
	.long  FON15la,FON15lb,FON15lc,FON15ld,FON15le,FON15lf,FON15lg,FON15lh
	.long  FON15li,FON15lj,FON15lk,FON15ll,FON15lm,FON15ln,FON15lo,FON15lp
	.long  FON15lq,FON15lr,FON15ls,FON15lt,FON15lu,FON15lv,FON15lw,FON15lx
	.long  FON15ly,FON15lz
	.long  FON15paren2l,FON15break,FON15paren2r
;RD19FONT
;	.long  FON15excla,FON15quote,FON15poun,FON15doll,FON15perc,FON15and
;	.long  FON15apos,FON15parenl,FON15parenr,FON15ast,FON15plus
;	.long  FON15comma,FON15dash,FON15period,FON15forsp
;
;;,SMD16_0,SMD16_1
;;	.long  SMD16_2,SMD16_3,SMD16_4,SMD16_5,SMD16_6,SMD16_7,SMD16_8,SMD16_9
;
;	.long  FONT70,FONT71,FONT72,FONT73,FONT74,FONT75,FONT76,FONT77,FONT78
;	.long  FONT79
;
;	.long  FON15colon,FON15semicol,FON15less,FON15equal,FON15more
;	.long  FON15quest,FON15dash
;	.long  font19a,font19b,font19c,font19d,font19e,font19f,font19g,font19h
;	.long  font19i,font19j,font19k,font19l,font19m,font19n,font19o,font19p
;	.long  font19q,font19r,font19s,font19t,font19u,font19v,font19w,font19x
;	.long  font19y,font19z
;	.long  FON15brackl,FON15backsp,FON15brackr,FON15carr,FON15line
;	.long  FON15apos1	
;	.long  FON15la,FON15lb,FON15lc,FON15ld,FON15le,FON15lf,FON15lg,FON15lh
;	.long  FON15li,FON15lj,FON15lk,FON15ll,FON15lm,FON15ln,FON15lo,FON15lp
;	.long  FON15lq,FON15lr,FON15ls,FON15lt,FON15lu,FON15lv,FON15lw,FON15lx
;	.long  FON15ly,FON15lz
;	.long  FON15paren2l,FON15break,FON15paren2r

	.def	set_imgs
	.def	SQUD_1
	.def	SQUD_2

set_imgs
	.long	SQUD_1,SQUD_2,SQUD_3,SQUD_4,SQUD_5,SQUD_6,SQUD_7,SQUD_8,SQUD_9,SQUD_10
	.long	SQUD_11,SQUD_12,SQUD_13,SQUD_14,SQUD_15,SQUD_16,SQUD_17,SQUD_18,SQUD_19
	.long	SQUD_20

	.end
