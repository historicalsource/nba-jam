**************************************************************
*
* Owner:	TURMELL
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		9/17/92
*
* Modified:		Mark Turmell, 1/6/93	-Split from PLYR.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/23/93 15:13
**************************************************************
	.file	"plyr3.asm"
	.title	"basketball player code"
	.width	132
	.option	b,d,l,t
	.mnolist

	.include	"hotspot.tbl"

	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"audit.equ"
	.include	"world.equ"		;Court-world defs
	.include	"game.equ"
	.include	"macros.hdr"		;Macros
	.asg		0,SEQT
	.include	"plyr.equ"

	.include	"imgtbl7.glo"
	.include	"imgtbl1.glo"

	.include	"plyrhd.glo"
	.include	"plyrhd2.glo"
	.include	"plyrhd5.glo"
	.include	"HOTSPOT.GLO"

	.include	"ball.tbl"
	.include	"ballshad.tbl"
	.include	"ballshad.glo"


;sounds external



;symbols externally defined

	.ref	gug1,BEdwrd1

	.ref	pup_court,pup_aba
	.ref	anipt_getsclxy
	.ref	BAKMODS,BGND_UD1
;	.ref	snd_play1ovr
	.ref	IRQSKYE
	.ref	dpageflip
	.ref	GAMSTATE
	.ref	COLCYC
	.ref	system_savegame,system_restoregame
	.ref	tvpanelon
	.ref	RNDRNG0
	.ref	READ_DIP

	.ref	pal_getf

;From plyrat3.asm
	.ref	sd_h
;	.ref	RA_H
	.ref	Blaylock_h
	.ref	Ssmith_h
	.ref	Knorman_h
;	.ref	Henderso_h
	.ref	Barros_h
	.ref	Montross_h
	.ref	Radja_h
	.ref	Curry_h
	.ref	Zidek_h
	.ref	Kerr_h
	.ref	Thill_h
	.ref	Cmills_h
	.ref	Phills_h
	.ref	Kidd_h
	.ref	Pjones_h
	.ref	Rauf_h
	.ref	Pack_h
	.ref	Mcdyes_h
	.ref	Ghill_h
	.ref	Tmills_h
	.ref	Thorpe_h
	.ref	Sprewell_h
	.ref	Jsmith_h
	.ref	Cassel_h
	.ref	Ddavis_h
	.ref	Mckee_h
	.ref	Vaught_h
	.ref	Rrogers_h
	.ref	Lmurray_h
	.ref	Richardson_h
	.ref	Bbarry_h
	.ref	Vanexel_h
	.ref	Ceballos_h
	.ref	Ejones_h
	.ref	Bowens_h
	.ref	Grobinson_h
	.ref	EMurdock_h
	.ref	Respert_h
;	.ref	Rooks_h
	.ref	Garnett_h
	.ref	Gilliam_h
	.ref	Obannon_h
	.ref	Dscott_h
	.ref	Wright_h
	.ref	Stackhouse_h
	.ref	Wperson_h
	.ref	Finley_h
	.ref	Strickland_h
	.ref	Sabonis_h
	.ref	Bwilliams_h
	.ref	Childress_h
	.ref	Wwilliams_h
	.ref	Bgrant_h
	.ref	Marciulonis_h
	.ref	Ajohnson_h
	.ref	Sford_h
	.ref	Crogers_h
	.ref	Stoudamire_h
	.ref	Anthony_h
;	.ref	Gattison_h
	.ref	Breeves_h
	.ref	Jhoward_h
	.ref	McCloud_h
	.ref	Houston_h
	.ref	Muresan_h	
	.ref	KEdwards_h
	.ref	Fox_h
	.ref	Ferry_h
	.ref	Mullin_h
	.ref	Longley_h
	.ref	MJackson_h
	.ref	Danilovic_h
	.ref	OMiller_h
	.ref	Delnegro_h
	.ref	Douglas_h
	.ref	WAnderson_h
	.ref	TMurray_h
	.ref	Koncak_h
	.ref	Rose_h
	.ref	Brandon_h
;	.ref	Coles_h
	.ref	DHarper_h
	.ref	Edney_h
	.ref	VMaxwell_h

;From plyrat2.asm
	.ref	Laetner_h
	.ref	Hawkins_h
	.ref	LJohnson_h
	.ref	Divac_h
	.ref	KMalone_h
	.ref	Stockton_h
	.ref	Ewing_h
	.ref	Seikaly_h
	.ref	Miller_h
	.ref	Mutumbo_h
	.ref	Oakley_h
	.ref	Olajuwon_h
	.ref	Rice_h
	.ref	DRobinson_h
	.ref	Schrempf_h
	.ref	Smith_h
	.ref	Tisdale_h
	.ref	Kemp_h
	.ref	Pippen_h
	.ref	Gill_h
	.ref	Mullin_h
	.ref	Person_h
	.ref	Augmon_h
	.ref	Benjamin_h
	.ref	Coleman_h
	.ref	Drexler_h
;	.ref	DEllis_h
	.ref	Elliot_h
	.ref	Hardaway_h
	.ref	HCGrant_h
	.ref	Hornacek_h
	.ref	Manning_h
    	.ref	Cow_h
	.ref	fifi_h
	.ref	FIFI_F
	.ref	Alien_h
	.ref	Mel_h
	.ref	Mik_h
	.ref	Joe_h
	.ref	Ang_h
	.ref	Lis_h
	.ref	Guido_h
	.ref	Ber_h
	.ref	Chk_h
	.ref	Fat_h
	.ref	Fra_h
	.ref	Gor_h
	.ref	Gre_h
	.ref	Old_h
	.ref	Pig_h
	.ref	Wiz_h
	.ref	eric_h
	.ref	madball_h
	.ref	jackjr_h
	.ref	kim_h
	.ref	clown_h
	.ref	ape_h
	.ref	cheech_h
	.ref	mar_h
	.ref	bardo_h
	.ref	oursler_h
	.ref	mxv_h
	.ref	eddie_h
	.ref	dim_h
	.ref	mike_h
	.ref	sean_h
	.ref	bud_h
	.ref	BUD_F
	.ref	bardo_h
	.ref	willy_h

	.ref	plyrobj_t
	.ref	BOON_F,TOBIAS_F,OURSL_F
	.ref	EDDIE_F

;symbols defined in this file

	.def	NBALL101,NBALL601,ABALL101

	.def	plr_heads_small,plr_heads_small_end
	.def	SM_HEADS_CNT


;uninitialized ram definitions

;	.bss	cycram		,9*16
;	.bss	clipbits	,32	;Bit set for each clip # shown
;
;	BSSX	clipsrunning	,32

	BSSX	ditch_meter,16

;equates for this file


	.text

#*******************************
* do ball animation

 SUBR	do_ball_ani

	move	*a8(OZPOS),a2		;No
	subi	CZMIN-32,a2		;-Base -32 to go 1 smaller @ crt top
	jrge	#zge
	clr	a2
#zge
	srl	5,a2
	move	*a13(ball_zsznum),a4
	sub	a2,a4
	jrne	#newani			;Same Z range? br=no
	dsj	a10,#skipa

#newani
	move	a2,*a13(ball_zsznum)
	sll	5,a2
	move	a2,a3
	move	*a8(OPAL),a1		;Chk for correct palette
	sll	32-8,a1
	srl	32-8-5,a1
	.ref	PALRAM
	addi	PALRAM-32,a1
	move	*a1,a1,L
	movi	BBALL_P,a0		;=reg ball pal
	move	*a13(ball_onfire),a14	;Is someone on-fire?
	jrz	#nofpal			; br=no
	addi	#anif_t,a2
	move	@balltmshotcnt,a14	;Is it a team on-fire?
	subk	TMFIRE_MINCNT,a14
	jrlt	#notd			; br=no
	movi	BBALFLA_P,a0		;=blue ball pal
	jruc	#notd
#nofpal
	addi	#ani_t,a2
	move	@pup_aba,a14
	jrz	#notd
	movi	ABALL_P,a0		;=reg ball pal
	addi	#ania_t-#ani_t,a2
#notd
	cmp	a1,a0			;Does ball have the right palette?
	jreq	#gotp			; br=yes
	calla	pal_getf
	move	a0,*a8(OPAL)		;Set correct palette

#gotp
	move	*a13(ball_ani1st_p),a1,L
	move	*a2,a2,L
	cmp	a1,a2
	jreq	#sameseq

	addi	#shad_t,a3		;Set new shadow img
	move	*a3,a0,L
	move	a0,*a9(OIMG),L
	move	*a0,a14,L
	move	a14,*a9(OSIZE),L
	move	*a0(ISAG),*a9(OSAG),L
	move	*a0(IANIOFFY),a14
	neg	a14
	move	a14,*a9(OYPOS)

	move	a2,*a13(ball_ani1st_p),L
	jruc	#newz

#sameseq
	move	*a13(ball_onfire),a14
	jrnz	#movin			;On fire?
	move	*a8(OXVEL),a0,L
	abs	a0
	srl	2,a0
	jrnz	#movin
	movk	5,a10
	move	*a8(OZVEL),a0,L
	abs	a0
	srl	2,a0
	jrz	#skipa
#movin
	move	*a13(ball_ani_p),a2,L
	move	*a2+,a0,L		;*Next img
	jrnz	#notend
	move	a1,a2
#newz
	move	*a2+,a0,L		;*1st img
#notend
	move	*a2+,a10
	move	a2,*a13(ball_ani_p),L

	move	a0,*a8(OIMG),L		;Set new ball img
	movb	*a0(ICTRL+7),*a8(OCTRL+7)	;Set 5 z comp & 3 bpp bits
	move	*a0,a2,L
	move	a2,*a8(OSIZE),L
	move	*a0(ISAG),*a8(OSAG),L
	move	*a0(IANIOFFX),a2
	move	*a0(IANIOFFY),*a13(ball_aniy)
	move	*a13(ball_anix),a1
	move	a2,*a13(ball_anix)
	move	*a8(OXPOS),a0
	add	a1,a0			;Old ani X
	sub	a2,a0			;-New ani X
	move	a0,*a8(OXPOS)

#skipa
	rets


#ani_t
	.long	#b1_l

	.long	#b1_l,#b1_l,#b1_l,#b2_l,#b2_l,#b3_l
	.long	#b3_l,#b4_l,#b5_l,#b6_l,#b7_l

	.long	#b8_l,#b8_l,#b8_l,#b8_l,#b8_l,#b8_l

;	.long	#b1_l
;
;	.long	#b2_l,#b2_l,#b3_l,#b3_l,#b4_l,#b4_l
;	.long	#b5_l,#b6_l,#b7_l,#b8_l,#b9_l
;
;	.long	#b10_l,#b10_l,#b10_l,#b10_l,#b10_l,#b10_l

	.asg	2,D

#b1_l
	LWLWLWLW NBALL101,D,NBALL102,D,NBALL103,D,NBALL104,D
	LWLWLWLW NBALL105,D,NBALL106,D,NBALL107,D,NBALL108,D
	LWLWLWLW NBALL109,D,NBALL110,D,NBALL111,D,NBALL112,D
	LWLWLWLW NBALL113,D,NBALL114,D,NBALL115,D,NBALL116,D
	LWLWLWLW NBALL117,D,NBALL118,D,NBALL119,D,NBALL120,D
	LWLWLWLW NBALL121,D,NBALL122,D,NBALL123,D,NBALL124,D
	LWLWLWLW NBALL125,D,NBALL126,D,NBALL127,D,NBALL128,D
	LWLW     NBALL129,D,NBALL130,D
	.long    0

#b2_l
	LWLWLWLW NBALL201,D,NBALL202,D,NBALL203,D,NBALL204,D
	LWLWLWLW NBALL205,D,NBALL206,D,NBALL207,D,NBALL208,D
	LWLWLWLW NBALL209,D,NBALL210,D,NBALL211,D,NBALL212,D
	LWLWLWLW NBALL213,D,NBALL214,D,NBALL215,D,NBALL216,D
	LWLWLWLW NBALL217,D,NBALL218,D,NBALL219,D,NBALL220,D
	LWLWLWLW NBALL221,D,NBALL222,D,NBALL223,D,NBALL224,D
	LWLWLWLW NBALL225,D,NBALL226,D,NBALL227,D,NBALL228,D
	LWLW     NBALL229,D,NBALL230,D
	.long    0

#b3_l
	LWLWLWLW NBALL301,D,NBALL302,D,NBALL303,D,NBALL304,D
	LWLWLWLW NBALL305,D,NBALL306,D,NBALL307,D,NBALL308,D
	LWLWLWLW NBALL309,D,NBALL310,D,NBALL311,D,NBALL312,D
	LWLWLWLW NBALL313,D,NBALL314,D,NBALL315,D,NBALL316,D
	LWLWLWLW NBALL317,D,NBALL318,D,NBALL319,D,NBALL320,D
	LWLWLWLW NBALL321,D,NBALL322,D,NBALL323,D,NBALL324,D
	LWLWLWLW NBALL325,D,NBALL326,D,NBALL327,D,NBALL328,D
	LWLW     NBALL329,D,NBALL330,D
	.long    0

#b4_l
	LWLWLWLW NBALL401,D,NBALL402,D,NBALL403,D,NBALL404,D
	LWLWLWLW NBALL405,D,NBALL406,D,NBALL407,D,NBALL408,D
	LWLWLWLW NBALL409,D,NBALL410,D,NBALL411,D,NBALL412,D
	LWLWLWLW NBALL413,D,NBALL414,D,NBALL415,D,NBALL416,D
	LWLWLWLW NBALL417,D,NBALL418,D,NBALL419,D,NBALL420,D
	LWLWLWLW NBALL421,D,NBALL422,D,NBALL423,D,NBALL424,D
	LWLWLWLW NBALL425,D,NBALL426,D,NBALL427,D,NBALL428,D
	LWLW     NBALL429,D,NBALL430,D
	.long    0

#b5_l
	LWLWLWLW NBALL501,D,NBALL502,D,NBALL503,D,NBALL504,D
	LWLWLWLW NBALL505,D,NBALL506,D,NBALL507,D,NBALL508,D
	LWLWLWLW NBALL509,D,NBALL510,D,NBALL511,D,NBALL512,D
	LWLWLWLW NBALL513,D,NBALL514,D,NBALL515,D,NBALL516,D
	LWLWLWLW NBALL517,D,NBALL518,D,NBALL519,D,NBALL520,D
	LWLWLWLW NBALL521,D,NBALL522,D,NBALL523,D,NBALL524,D
	LWLWLWLW NBALL525,D,NBALL526,D,NBALL527,D,NBALL528,D
	LWLW     NBALL529,D,NBALL530,D
	.long    0

#b6_l
	LWLWLWLW NBALL601,D,NBALL602,D,NBALL603,D,NBALL604,D
	LWLWLWLW NBALL605,D,NBALL606,D,NBALL607,D,NBALL608,D
	LWLWLWLW NBALL609,D,NBALL610,D,NBALL611,D,NBALL612,D
	LWLWLWLW NBALL613,D,NBALL614,D,NBALL615,D,NBALL616,D
	LWLWLWLW NBALL617,D,NBALL618,D,NBALL619,D,NBALL620,D
	LWLWLWLW NBALL621,D,NBALL622,D,NBALL623,D,NBALL624,D
	LWLWLWLW NBALL625,D,NBALL626,D,NBALL627,D,NBALL628,D
	LWLW     NBALL629,D,NBALL630,D
	.long    0

#b7_l
	LWLWLWLW NBALL701,D,NBALL702,D,NBALL703,D,NBALL704,D
	LWLWLWLW NBALL705,D,NBALL706,D,NBALL707,D,NBALL708,D
	LWLWLWLW NBALL709,D,NBALL710,D,NBALL711,D,NBALL712,D
	LWLWLWLW NBALL713,D,NBALL714,D,NBALL715,D,NBALL716,D
	LWLWLWLW NBALL717,D,NBALL718,D,NBALL719,D,NBALL720,D
	LWLWLWLW NBALL721,D,NBALL722,D,NBALL723,D,NBALL724,D
	LWLWLWLW NBALL725,D,NBALL726,D,NBALL727,D,NBALL728,D
	LWLW     NBALL729,D,NBALL730,D
	.long    0

#b8_l
	LWLWLWLW NBALL801,D,NBALL802,D,NBALL803,D,NBALL804,D
	LWLWLWLW NBALL805,D,NBALL806,D,NBALL807,D,NBALL808,D
	LWLWLWLW NBALL809,D,NBALL810,D,NBALL811,D,NBALL812,D
	LWLWLWLW NBALL813,D,NBALL814,D,NBALL815,D,NBALL816,D
	LWLWLWLW NBALL817,D,NBALL818,D,NBALL819,D,NBALL820,D
	LWLWLWLW NBALL821,D,NBALL822,D,NBALL823,D,NBALL824,D
	LWLWLWLW NBALL825,D,NBALL826,D,NBALL827,D,NBALL828,D
	LWLW     NBALL829,D,NBALL830,D
	.long    0

;;#b9_l
;;	LWLWLWLW NBALL901,D,NBALL902,D,NBALL903,D,NBALL904,D
;;	LWLWLWLW NBALL905,D,NBALL906,D,NBALL907,D,NBALL908,D
;;	LWLWLWLW NBALL909,D,NBALL910,D,NBALL911,D,NBALL912,D
;;	LWLWLWLW NBALL913,D,NBALL914,D,NBALL915,D,NBALL916,D
;;	LWLWLWLW NBALL917,D,NBALL918,D,NBALL919,D,NBALL920,D
;;	LWLWLWLW NBALL921,D,NBALL922,D,NBALL923,D,NBALL924,D
;;	LWLWLWLW NBALL925,D,NBALL926,D,NBALL927,D,NBALL928,D
;;	LWLW     NBALL929,D,NBALL930,D
;;	.long    0
;;
;;#b10_l
;;	LWLWLWLW NBALL1001,D,NBALL1002,D,NBALL1003,D,NBALL1004,D
;;	LWLWLWLW NBALL1005,D,NBALL1006,D,NBALL1007,D,NBALL1008,D
;;	LWLWLWLW NBALL1009,D,NBALL1010,D,NBALL1011,D,NBALL1012,D
;;	LWLWLWLW NBALL1013,D,NBALL1014,D,NBALL1015,D,NBALL1016,D
;;	LWLWLWLW NBALL1017,D,NBALL1018,D,NBALL1019,D,NBALL1020,D
;;	LWLWLWLW NBALL1021,D,NBALL1022,D,NBALL1023,D,NBALL1024,D
;;	LWLWLWLW NBALL1025,D,NBALL1026,D,NBALL1027,D,NBALL1028,D
;;	LWLW     NBALL1029,D,NBALL1030,D
;;	.long    0


#anif_t
	.long	#bf1_l

	.long	#bf1_l,#bf1_l,#bf1_l,#bf2_l,#bf2_l,#bf3_l
	.long	#bf3_l,#bf4_l,#bf5_l,#bf6_l,#bf7_l

	.long	#bf8_l,#bf8_l,#bf8_l,#bf8_l,#bf8_l,#bf8_l

;	.long	#bf1_l
;
;	.long	#bf2_l,#bf2_l,#bf3_l,#bf3_l,#bf4_l,#bf4_l
;	.long	#bf5_l,#bf6_l,#bf7_l,#bf8_l,#bf9_l
;
;	.long	#bf10_l,#bf10_l,#bf10_l,#bf10_l,#bf10_l,#bf10_l


	.asg	2,D

#bf1_l
	LWLWLWLW FBALL101,D,FBALL102,D,FBALL103,D,FBALL104,D
	LWLWLWLW FBALL105,D,FBALL106,D,FBALL107,D,FBALL108,D
	LWLWLWLW FBALL109,D,FBALL110,D,FBALL111,D,FBALL112,D
	LWLWLWLW FBALL113,D,FBALL114,D,FBALL115,D,FBALL116,D
	LWLWLWLW FBALL117,D,FBALL118,D,FBALL119,D,FBALL120,D
	LWLWLWLW FBALL121,D,FBALL122,D,FBALL123,D,FBALL124,D
	LWLWLWLW FBALL125,D,FBALL126,D,FBALL127,D,FBALL128,D
	LWLW     FBALL129,D,FBALL130,D
	.long    0

#bf2_l
	LWLWLWLW FBALL201,D,FBALL202,D,FBALL203,D,FBALL204,D
	LWLWLWLW FBALL205,D,FBALL206,D,FBALL207,D,FBALL208,D
	LWLWLWLW FBALL209,D,FBALL210,D,FBALL211,D,FBALL212,D
	LWLWLWLW FBALL213,D,FBALL214,D,FBALL215,D,FBALL216,D
	LWLWLWLW FBALL217,D,FBALL218,D,FBALL219,D,FBALL220,D
	LWLWLWLW FBALL221,D,FBALL222,D,FBALL223,D,FBALL224,D
	LWLWLWLW FBALL225,D,FBALL226,D,FBALL227,D,FBALL228,D
	LWLW     FBALL229,D,FBALL230,D
	.long    0

#bf3_l
	LWLWLWLW FBALL301,D,FBALL302,D,FBALL303,D,FBALL304,D
	LWLWLWLW FBALL305,D,FBALL306,D,FBALL307,D,FBALL308,D
	LWLWLWLW FBALL309,D,FBALL310,D,FBALL311,D,FBALL312,D
	LWLWLWLW FBALL313,D,FBALL314,D,FBALL315,D,FBALL316,D
	LWLWLWLW FBALL317,D,FBALL318,D,FBALL319,D,FBALL320,D
	LWLWLWLW FBALL321,D,FBALL322,D,FBALL323,D,FBALL324,D
	LWLWLWLW FBALL325,D,FBALL326,D,FBALL327,D,FBALL328,D
	LWLW     FBALL329,D,FBALL330,D
	.long    0

#bf4_l
	LWLWLWLW FBALL401,D,FBALL402,D,FBALL403,D,FBALL404,D
	LWLWLWLW FBALL405,D,FBALL406,D,FBALL407,D,FBALL408,D
	LWLWLWLW FBALL409,D,FBALL410,D,FBALL411,D,FBALL412,D
	LWLWLWLW FBALL413,D,FBALL414,D,FBALL415,D,FBALL416,D
	LWLWLWLW FBALL417,D,FBALL418,D,FBALL419,D,FBALL420,D
	LWLWLWLW FBALL421,D,FBALL422,D,FBALL423,D,FBALL424,D
	LWLWLWLW FBALL425,D,FBALL426,D,FBALL427,D,FBALL428,D
	LWLW     FBALL429,D,FBALL430,D
	.long    0

#bf5_l
	LWLWLWLW FBALL501,D,FBALL502,D,FBALL503,D,FBALL504,D
	LWLWLWLW FBALL505,D,FBALL506,D,FBALL507,D,FBALL508,D
	LWLWLWLW FBALL509,D,FBALL510,D,FBALL511,D,FBALL512,D
	LWLWLWLW FBALL513,D,FBALL514,D,FBALL515,D,FBALL516,D
	LWLWLWLW FBALL517,D,FBALL518,D,FBALL519,D,FBALL520,D
	LWLWLWLW FBALL521,D,FBALL522,D,FBALL523,D,FBALL524,D
	LWLWLWLW FBALL525,D,FBALL526,D,FBALL527,D,FBALL528,D
	LWLW     FBALL529,D,FBALL530,D
	.long    0

#bf6_l
	LWLWLWLW FBALL601,D,FBALL602,D,FBALL603,D,FBALL604,D
	LWLWLWLW FBALL605,D,FBALL606,D,FBALL607,D,FBALL608,D
	LWLWLWLW FBALL609,D,FBALL610,D,FBALL611,D,FBALL612,D
	LWLWLWLW FBALL613,D,FBALL614,D,FBALL615,D,FBALL616,D
	LWLWLWLW FBALL617,D,FBALL618,D,FBALL619,D,FBALL620,D
	LWLWLWLW FBALL621,D,FBALL622,D,FBALL623,D,FBALL624,D
	LWLWLWLW FBALL625,D,FBALL626,D,FBALL627,D,FBALL628,D
	LWLW     FBALL629,D,FBALL630,D
	.long    0

#bf7_l
	LWLWLWLW FBALL701,D,FBALL702,D,FBALL703,D,FBALL704,D
	LWLWLWLW FBALL705,D,FBALL706,D,FBALL707,D,FBALL708,D
	LWLWLWLW FBALL709,D,FBALL710,D,FBALL711,D,FBALL712,D
	LWLWLWLW FBALL713,D,FBALL714,D,FBALL715,D,FBALL716,D
	LWLWLWLW FBALL717,D,FBALL718,D,FBALL719,D,FBALL720,D
	LWLWLWLW FBALL721,D,FBALL722,D,FBALL723,D,FBALL724,D
	LWLWLWLW FBALL725,D,FBALL726,D,FBALL727,D,FBALL728,D
	LWLW     FBALL729,D,FBALL730,D
	.long    0

#bf8_l
	LWLWLWLW FBALL801,D,FBALL802,D,FBALL803,D,FBALL804,D
	LWLWLWLW FBALL805,D,FBALL806,D,FBALL807,D,FBALL808,D
	LWLWLWLW FBALL809,D,FBALL810,D,FBALL811,D,FBALL812,D
	LWLWLWLW FBALL813,D,FBALL814,D,FBALL815,D,FBALL816,D
	LWLWLWLW FBALL817,D,FBALL818,D,FBALL819,D,FBALL820,D
	LWLWLWLW FBALL821,D,FBALL822,D,FBALL823,D,FBALL824,D
	LWLWLWLW FBALL825,D,FBALL826,D,FBALL827,D,FBALL828,D
	LWLW     FBALL829,D,FBALL830,D
	.long    0

;;#bf9_l
;;	LWLWLWLW FBALL901,D,FBALL902,D,FBALL903,D,FBALL904,D
;;	LWLWLWLW FBALL905,D,FBALL906,D,FBALL907,D,FBALL908,D
;;	LWLWLWLW FBALL909,D,FBALL910,D,FBALL911,D,FBALL912,D
;;	LWLWLWLW FBALL913,D,FBALL914,D,FBALL915,D,FBALL916,D
;;	LWLWLWLW FBALL917,D,FBALL918,D,FBALL919,D,FBALL920,D
;;	LWLWLWLW FBALL921,D,FBALL922,D,FBALL923,D,FBALL924,D
;;	LWLWLWLW FBALL925,D,FBALL926,D,FBALL927,D,FBALL928,D
;;	LWLW     FBALL929,D,FBALL930,D
;;	.long    0
;;
;;#bf10_l
;;	LWLWLWLW FBALL1001,D,FBALL1002,D,FBALL1003,D,FBALL1004,D
;;	LWLWLWLW FBALL1005,D,FBALL1006,D,FBALL1007,D,FBALL1008,D
;;	LWLWLWLW FBALL1009,D,FBALL1010,D,FBALL1011,D,FBALL1012,D
;;	LWLWLWLW FBALL1013,D,FBALL1014,D,FBALL1015,D,FBALL1016,D
;;	LWLWLWLW FBALL1017,D,FBALL1018,D,FBALL1019,D,FBALL1020,D
;;	LWLWLWLW FBALL1021,D,FBALL1022,D,FBALL1023,D,FBALL1024,D
;;	LWLWLWLW FBALL1025,D,FBALL1026,D,FBALL1027,D,FBALL1028,D
;;	LWLW     FBALL1029,D,FBALL1030,D
;;	.long    0


#ania_t
	.long	#ba1_l

	.long	#ba1_l,#ba1_l,#ba1_l,#ba2_l,#ba2_l,#ba3_l
	.long	#ba3_l,#ba4_l,#ba5_l,#ba6_l,#ba7_l

	.long	#ba8_l,#ba8_l,#ba8_l,#ba8_l,#ba8_l,#ba8_l

;	.long	#ba1_l
;
;	.long	#ba2_l,#ba2_l,#ba3_l,#ba3_l,#ba4_l,#ba4_l
;	.long	#ba5_l,#ba6_l,#ba7_l,#ba8_l,#ba9_l
;
;	.long	#ba10_l,#ba10_l,#ba10_l,#ba10_l,#ba10_l,#ba10_l

	.asg	2,D

#ba1_l
	LWLWLWLW ABALL101,D,ABALL102,D,ABALL103,D,ABALL104,D
	LWLWLWLW ABALL105,D,ABALL106,D,ABALL107,D,ABALL108,D
	LWLWLWLW ABALL109,D,ABALL110,D,ABALL111,D,ABALL112,D
	LWLWLWLW ABALL113,D,ABALL114,D,ABALL115,D,ABALL116,D
	LWLWLWLW ABALL117,D,ABALL118,D,ABALL119,D,ABALL120,D
	LWLWLWLW ABALL121,D,ABALL122,D,ABALL123,D,ABALL124,D
	LWLWLWLW ABALL125,D,ABALL126,D,ABALL127,D,ABALL128,D
	LWLW     ABALL129,D,ABALL130,D
	.long    0

#ba2_l
	LWLWLWLW ABALL201,D,ABALL202,D,ABALL203,D,ABALL204,D
	LWLWLWLW ABALL205,D,ABALL206,D,ABALL207,D,ABALL208,D
	LWLWLWLW ABALL209,D,ABALL210,D,ABALL211,D,ABALL212,D
	LWLWLWLW ABALL213,D,ABALL214,D,ABALL215,D,ABALL216,D
	LWLWLWLW ABALL217,D,ABALL218,D,ABALL219,D,ABALL220,D
	LWLWLWLW ABALL221,D,ABALL222,D,ABALL223,D,ABALL224,D
	LWLWLWLW ABALL225,D,ABALL226,D,ABALL227,D,ABALL228,D
	LWLW     ABALL229,D,ABALL230,D
	.long    0

#ba3_l
	LWLWLWLW ABALL301,D,ABALL302,D,ABALL303,D,ABALL304,D
	LWLWLWLW ABALL305,D,ABALL306,D,ABALL307,D,ABALL308,D
	LWLWLWLW ABALL309,D,ABALL310,D,ABALL311,D,ABALL312,D
	LWLWLWLW ABALL313,D,ABALL314,D,ABALL315,D,ABALL316,D
	LWLWLWLW ABALL317,D,ABALL318,D,ABALL319,D,ABALL320,D
	LWLWLWLW ABALL321,D,ABALL322,D,ABALL323,D,ABALL324,D
	LWLWLWLW ABALL325,D,ABALL326,D,ABALL327,D,ABALL328,D
	LWLW     ABALL329,D,ABALL330,D
	.long    0

#ba4_l
	LWLWLWLW ABALL401,D,ABALL402,D,ABALL403,D,ABALL404,D
	LWLWLWLW ABALL405,D,ABALL406,D,ABALL407,D,ABALL408,D
	LWLWLWLW ABALL409,D,ABALL410,D,ABALL411,D,ABALL412,D
	LWLWLWLW ABALL413,D,ABALL414,D,ABALL415,D,ABALL416,D
	LWLWLWLW ABALL417,D,ABALL418,D,ABALL419,D,ABALL420,D
	LWLWLWLW ABALL421,D,ABALL422,D,ABALL423,D,ABALL424,D
	LWLWLWLW ABALL425,D,ABALL426,D,ABALL427,D,ABALL428,D
	LWLW     ABALL429,D,ABALL430,D
	.long    0

#ba5_l
	LWLWLWLW ABALL501,D,ABALL502,D,ABALL503,D,ABALL504,D
	LWLWLWLW ABALL505,D,ABALL506,D,ABALL507,D,ABALL508,D
	LWLWLWLW ABALL509,D,ABALL510,D,ABALL511,D,ABALL512,D
	LWLWLWLW ABALL513,D,ABALL514,D,ABALL515,D,ABALL516,D
	LWLWLWLW ABALL517,D,ABALL518,D,ABALL519,D,ABALL520,D
	LWLWLWLW ABALL521,D,ABALL522,D,ABALL523,D,ABALL524,D
	LWLWLWLW ABALL525,D,ABALL526,D,ABALL527,D,ABALL528,D
	LWLW     ABALL529,D,ABALL530,D
	.long    0

#ba6_l
	LWLWLWLW ABALL601,D,ABALL602,D,ABALL603,D,ABALL604,D
	LWLWLWLW ABALL605,D,ABALL606,D,ABALL607,D,ABALL608,D
	LWLWLWLW ABALL609,D,ABALL610,D,ABALL611,D,ABALL612,D
	LWLWLWLW ABALL613,D,ABALL614,D,ABALL615,D,ABALL616,D
	LWLWLWLW ABALL617,D,ABALL618,D,ABALL619,D,ABALL620,D
	LWLWLWLW ABALL621,D,ABALL622,D,ABALL623,D,ABALL624,D
	LWLWLWLW ABALL625,D,ABALL626,D,ABALL627,D,ABALL628,D
	LWLW     ABALL629,D,ABALL630,D
	.long    0

#ba7_l
	LWLWLWLW ABALL701,D,ABALL702,D,ABALL703,D,ABALL704,D
	LWLWLWLW ABALL705,D,ABALL706,D,ABALL707,D,ABALL708,D
	LWLWLWLW ABALL709,D,ABALL710,D,ABALL711,D,ABALL712,D
	LWLWLWLW ABALL713,D,ABALL714,D,ABALL715,D,ABALL716,D
	LWLWLWLW ABALL717,D,ABALL718,D,ABALL719,D,ABALL720,D
	LWLWLWLW ABALL721,D,ABALL722,D,ABALL723,D,ABALL724,D
	LWLWLWLW ABALL725,D,ABALL726,D,ABALL727,D,ABALL728,D
	LWLW     ABALL729,D,ABALL730,D
	.long    0

#ba8_l
	LWLWLWLW ABALL801,D,ABALL802,D,ABALL803,D,ABALL804,D
	LWLWLWLW ABALL805,D,ABALL806,D,ABALL807,D,ABALL808,D
	LWLWLWLW ABALL809,D,ABALL810,D,ABALL811,D,ABALL812,D
	LWLWLWLW ABALL813,D,ABALL814,D,ABALL815,D,ABALL816,D
	LWLWLWLW ABALL817,D,ABALL818,D,ABALL819,D,ABALL820,D
	LWLWLWLW ABALL821,D,ABALL822,D,ABALL823,D,ABALL824,D
	LWLWLWLW ABALL825,D,ABALL826,D,ABALL827,D,ABALL828,D
	LWLW     ABALL829,D,ABALL830,D
	.long    0

;;#ba9_l
;;	LWLWLWLW ABALL901,D,ABALL902,D,ABALL903,D,ABALL904,D
;;	LWLWLWLW ABALL905,D,ABALL906,D,ABALL907,D,ABALL908,D
;;	LWLWLWLW ABALL909,D,ABALL910,D,ABALL911,D,ABALL912,D
;;	LWLWLWLW ABALL913,D,ABALL914,D,ABALL915,D,ABALL916,D
;;	LWLWLWLW ABALL917,D,ABALL918,D,ABALL919,D,ABALL920,D
;;	LWLWLWLW ABALL921,D,ABALL922,D,ABALL923,D,ABALL924,D
;;	LWLWLWLW ABALL925,D,ABALL926,D,ABALL927,D,ABALL928,D
;;	LWLW     ABALL929,D,ABALL930,D
;;	.long    0
;;
;;#ba10_l
;;	LWLWLWLW ABALL1001,D,ABALL1002,D,ABALL1003,D,ABALL1004,D
;;	LWLWLWLW ABALL1005,D,ABALL1006,D,ABALL1007,D,ABALL1008,D
;;	LWLWLWLW ABALL1009,D,ABALL1010,D,ABALL1011,D,ABALL1012,D
;;	LWLWLWLW ABALL1013,D,ABALL1014,D,ABALL1015,D,ABALL1016,D
;;	LWLWLWLW ABALL1017,D,ABALL1018,D,ABALL1019,D,ABALL1020,D
;;	LWLWLWLW ABALL1021,D,ABALL1022,D,ABALL1023,D,ABALL1024,D
;;	LWLWLWLW ABALL1025,D,ABALL1026,D,ABALL1027,D,ABALL1028,D
;;	LWLW     ABALL1029,D,ABALL1030,D
;;	.long    0


#shad_t
	.long	ballshad7

	.long	ballshad7,ballshad7,ballshad7,ballshad6,ballshad6,ballshad5
	.long	ballshad5,ballshad4,ballshad4,ballshad3,ballshad2

	.long	ballshad2,ballshad2,ballshad2,ballshad2,ballshad2,ballshad2

;	.long	ballshad9
;
;	.long	ballshad8,ballshad8,ballshad7,ballshad7,ballshad7,ballshad7
;	.long	ballshad6,ballshad5,ballshad4,ballshad4,ballshad2
;
;	.long	ballshad2,ballshad2,ballshad2,ballshad2,ballshad2,ballshad2


#*******************************
* Show halftime intro and clips (JSRP)


CLIPTEST	.equ	0

 SUBR	halftime_showclips

	movi	4*60,a10

#stop	SLEEPK	1
	subk	1,a10
	jrle	#tvout
	move	@tvpanelon,a0,L
	jrnz	#stop
#tvout

	RETP


**************************************************************
*	
**************************************************************
 SUBR	seq_handle_fadeaside

	move	*a13(plyr_seq),a0
	cmpi	SHOOT_SEQ,a0
	jrne	#nofdsd
	move	*a13(plyr_num),a14
	move	@PSTATUS,a0
	btst	a14,a0
	jrz	#nofdsd				;br=a drone!
	move	*a13(plyr_num),a0
	.ref	get_stick_val_cur
	calla	get_stick_val_cur		;ret. a0=joy switch value

	move	*a13(plyr_num),a14
	srl	1,a14
	jrnz	#fdtm2				;br=team 1

	cmpi	JOY_LEFT,a0
	jrne	#nofdsd				;br=dont do fade-aside
	movi	-2500h*6,a1			;x velocity
     	jruc	#fdtm1
#fdtm2
	cmpi	JOY_RIGHT,a0
	jrne	#nofdsd
	movi	2500h*6,a1			;x velocity
	addk	32,b4				;skip over fade-away seq. ptr
#fdtm1
	move	*b4,b4,L			;set new seq.
	move	a1,*a8(OXVEL),L
	rets

#nofdsd
	addi	32*2,b4
	rets


**************************************************************
*	
**************************************************************
 SUBR	seq_handle_fade_away

	move	*a13(plyr_seq),a0
	cmpi	SHOOT_SEQ,a0
	jrne	#nofadwy

	move	*a13(plyr_ohpdist),a14
	cmpi	25,a14				;too close to hoop ?
	jrlt	#nofadwy			;br=yes

	move	*a13(plyr_num),a14
	move	@PSTATUS,a0
	btst	a14,a0
	jrnz	#humn				;br=not a drone!
	move	*a13(plyr_ohpdist),a14
	cmpi	>ff,a14				;too far from hoop ?
	jrgt	#nofadwy			;br=yes

	move	*a13(PA8),a2,L
	move	*a2(OXANI+16),a1
	move	*a2(OXPOS),a2			;my X pos.
	add	a1,a2

	movk	2,a14				;team 2
	move	*a13(plyr_num),a5
	srl	1,a5				;get opponents proc.
	jrz	#drnf2				;br=team 1
	clr	a14
#drnf2
	sll	5,a14
	addi	plyrobj_t,a14
	move	*a14+,a5,L			;get opponent #1's X
	move	*a5(OXANI+16),a1
	move	*a5(OXPOS),a5
	add	a1,a5

	move	*a14,a3,L			;get opponent #2's X
	move	*a3(OXANI+16),a1
	move	*a3(OXPOS),a3			
	add	a1,a3

	move	*a13(plyr_seqdir),a14
	move	a14,a0

	move	*a13(plyr_o1dist),a1
	cmpi	70,a1
	jrgt	#ckop2				;br=opponent #1 to far
	move	*a13(plyr_anirevff),a1
	jrnz	#lhp				;br=team 2
	cmp	a5,a2				;is opponent #1 behind me ?
	jrgt	#fdin				;br=yes
	jruc	#drnfd2
#lhp
	cmp	a2,a5				;is opponent #1 behind me ?
	jrgt	#fdin				;br=yes
	jruc	#drnfd2

#ckop2
	move	*a13(plyr_o2dist),a1
	cmpi	70,a1
	jrgt	#nofadwy			;br=opponent #2 to far
	move	*a13(plyr_anirevff),a1
	jrnz	#lhp2				;br=team 2
	cmp	a3,a2				;is opponent #2 behind me ?
	jrgt	#fdin				;br=yes
	jruc	#drnfd2
#lhp2
	cmp	a2,a3				;is opponent #2 behind me ?
	jrlt	#drnfd2				;br=no

#fdin
	xori	4,a0				;change to opp. dir (FADE IN)
	jruc	#drnfd2
#humn
	move	*a13(plyr_seqdir),a14

	move	*a13(plyr_num),a0
	calla	get_stick_val_cur		;ret. a0=joy switch value

	sll	32-4,a0
	srl	32-4-4,a0
	addi	joy_dir_tbl,a0
	move	*a0,a0
	jrn	#nofadwy			;br=joy. not in correct dir.

;This is a lean in or fade away, reduce % only if a 3 pt shot
	movk	1,a4
	.ref	reduce_3ptr
	move	a4,@reduce_3ptr

#drnfd2
	move	a0,a2
	sll	6,a0
	addi	vels_tbl,a0
	move	*a0+,a1,L				;get X vel
	move	*a0,a0,L				;get Z vel

	cmp	a2,a14
	jreq	#fdawy
	xori	4,a2				;change to opposite dir
	cmp	a2,a14
	jrne	#nofadwy

	move	*a13(plyr_ohpdist),a14
	cmpi	60,a14				;too close for fade-in ?
	jrlt	#nofadwy			;br=yes
	addk	32,b4				;do FADE-IN seq
#fdawy
	move	*b4,b4,L
	move	a1,*a8(OXVEL),L
;#nox
	move	a0,*a8(OZVEL),L
	rets
#nofadwy
	addi	32*2,b4
	rets


joy_dir_tbl
	.word	-1,-1,-1,-1,2,3,1,-1,6,5,7,-1,-1,-1,-1,-1,-1,-1

vels_tbl
	.long	 0      , 0    		;direction 1
	.long	-21efh*7, 21efh*7	;^ 2          (3000h * .707)
	.long	-3000h*6, 0    		;^ 3
	.long	-21efh*7,-21efh*7	;^ 4
	.long	 0      , 0    		;^ 5
	.long	 21efh*7,-21efh*7	;^ 6
	.long	 3000h*6, 0		;^ 7 
	.long	 21efh*7, 21efh*7	;^ 8


#*******************************
* Dispatch salt explosions from rim at on fire time
* A8=*Ball object

 SUBR	rim_salt

	movk	8,a9
#lp	CREATE0	#do_salt
	SLEEPK	2
	dsj	a9,#lp
	DIE

#do_salt
	movi	#salt_t,a9
	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE,a4

	movi	10000h,a0
	calla	RNDRNG0
	move	a0,a6
	movi	60000h,a0
	calla	RNDRNG0
	addi	10000h,a0
	move	a0,a7
	btst	0,a7
	jrz	#1
	movi	#salt2_t,a9
#1
	move	*a8(OZPOS),a3
	addk	1h,a3
	move	*a8(OYVAL),a1,L
	move	*a8(OXVAL),a0,L
	addi	[10,0],a0

	move	*a8(OXPOS),a14
	cmpi	WRLDMID,a14
	jrlt	#lft
	addi	[6,0],a0
	movi	DMAWNZ|M_FLIPH|M_NOCOLL|M_3D|M_NOSCALE,a4
#lft
	movi	SALTA01,a2
	movi	CLSDEAD,a5
	calla	BEGINOBJ2

	SLEEPK	1
	jauc	FRQDELDIE


#salt_t 
	.ref	SALTTR_P
	LW	SALTA01,1
	LW	SALTA02,2
	LW	SALTA03,2
	LW	SALTA04,2
	LW	SALTA05,2
	LW	SALTA06,2
	LW	SALTA07,2
	LW	SALTA08,3
	LW	SALTA09,3
	LWL0	SALTA10,3

#salt2_t 
	LW	SALTB01,2
	LW	SALTB02,2
	LW	SALTB03,2
	LW	SALTB04,2
	LW	SALTB05,2
	LW	SALTB06,2
	LW	SALTB07,2
	LW	SALTB08,3
	LW	SALTB09,3
	LW	SALTB10,3
	LWL0	SALTB11,3


#*******************************
* Fire circle under feet
* A8=*Src obj
* A10=*Plyr process

 SUBR	fire_circle


	move	@pup_court,a14
	jrz	#notd

	CREATE0	#foot_smoke
	CREATE0	#foot_smoke2
#notd

	movi	#fire_circle_t,a9

	move	*a10(plyr_shadobj_p),a8,L
	move	*a8(OXANI+16),a0
	move	*a8(OXPOS),a2
	add	a0,a2
	addi	14,a2 
	move	a2,a0
	sll	16,a0

	clr	a1
	
	move	*a8(OZPOS),a3
	addi	22h,a3

	movi	HOTNA_01,a2
	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

;	movi	scale50_t,a0
;	move	a0,*a8(ODATA_p),L
	SLEEPK	1
	jauc	FRQDELDIE


#fire_circle_t
	.ref	HOT_P
	LW	HOTNA_01,1
	LW	HOTNA_02,2
	LW	HOTNA_03,2
	LW	HOTNA_04,2
	LW	HOTNA_05,2
	LW	HOTNA_06,2
	LW	HOTNA_07,2
	LW	HOTNA_08,3
	LW	HOTNA_09,3
	LW	HOTNA_10,3
	LW	HOTNA_11,3
	LW	HOTNA_12,4
	LWL0	HOTNA_13,4

#foot_smoke
	SLEEPK	2
#foot_smoke2
	movi	#smoke_t,a9

	movi	20000h,a0
	calla	RNDRNG0
	subi	10000h,a0
	move	a0,a6
	movi	60000h,a0
	calla	RNDRNG0
	neg	a0
	move	a0,a7
 
	move	*a10(plyr_shadobj_p),a8,L
	move	*a8(OXANI+16),a0
	move	*a8(OXPOS),a2
	add	a0,a2
	addi	8,a2 
	move	a2,a0
	sll	16,a0

	clr	a1
	
	move	*a8(OZPOS),a3
	addi	22h,a3

	movi	SMOKE01,a2
	movi	DMAWNZ|M_NOCOLL|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	calla	BEGINOBJ2

	SLEEPK	1
	jauc	FRQDELDIE


#smoke_t 
	.ref	SMOKE_P
	LW	SMOKE01,1
	LW	SMOKE02,2
	LW	SMOKE03,2
	LW	SMOKE04,2
	LW	SMOKE05,2
	LW	SMOKE06,2
	LW	SMOKE07,2
	LW	SMOKE08,3
	LW	SMOKE09,3
	LWL0	SMOKE10,3

#*******************************
* Smoke trail (Process)
* A8=*Src obj
;* A10=*Plyr process

; SUBR	ball_smoketrail
;
;	movi	8000,a11
;#lp	CREATE0	ball_smokepuff
;	SLEEPK	2
;	dsj	a11,#lp
;	DIE


;#*******************************
;* Start sparks in AMODE
;
; SUBR	do_ball_spark
;
;	movi	45,a11
;#lp	CREATE0	ball_spark
;	SLEEPK	4
;	dsj	a11,#lp
;	DIE


#*******************************
* Smoke trail puff (Process)
* A8=*Src obj

 SUBR	ball_smokepuff

	move	a8,a11

;	move	@HCOUNT,a0
;	sll	32-1,a0
;	jrnz	#nosprk
;	CREATE0	ball_spark
;#nosprk
	movk	3,a0
	callr	rnd
	sll	5,a0


	.ref	balltmshotcnt
	move	@balltmshotcnt,a14
	subk	TMFIRE_MINCNT,a14
	jrn	#reg

;Use blue smoke for team on fire
	addi	smoke_team_t,a0
	jruc	#cont
#reg

	addi	smoke_t,a0
#cont	move	*a0,a9,L

	move	*a8(OZPOS),a3		;puff ZPOS
	movk	3,a0
	callr	rnd
;	subk	2,a0			;-2 to 1
	add	a0,a3

	move	*a8(OXVAL),a0,L		;puff XPOS @ ball mid X
	move	*a8(OSIZEX),a2
	sll	16-1,a2
	add	a2,a0

	move	*a8(OYVAL),a1,L		;puff YPOS @ ball mid Y
	move	*a8(OSIZEY),a2
	sll	16-1,a2
	add	a2,a1

	move	*a9+,a2,L		;puff IMG

	move	*a2(IANIOFF),a6,L	;Add ani X,Y so obj X,Y is still
	clr	a7			; ball mid X,Y
	movy	a6,a7
	sll	16,a6
	add	a6,a0
	add	a7,a1

	movi	DMAWNZ|M_3D|M_NOCOLL,a4
	movi	CLSDEAD,a5
	move	*a8(OXVEL),a6,L		;puff XVEL & YVEL
	move	*a8(OYVEL),a7,L
	sra	2,a6
	sra	2,a7
	calla	BEGINOBJ2

	movi	scale50_t,a0		;puff *scale
	move	a0,*a8(ODATA_p),L
	move	*a11(OZVEL),a0,L	;puff ZVEL
	sra	2,a0
	move	a0,*a8(OZVEL),L

	calla	anipt_getsclxy		;Adjust for scaled puff ani X,Y
	move	*a8(OXVAL),a14,L
	sub	a0,a14
	move	a14,*a8(OXVAL),L
	move	*a8(OYVAL),a14,L
	sub	a1,a14
	move	a14,*a8(OYVAL),L

	move	*a11(OXANI),a14,L	;Get ball ani X
	jrz	#alp			; br=skip if 0
	move	a14,*a8(OXANI),L	;Save it to puff & go resolve for X
	move	a8,a0
	.ref	convfmprel
	calla	convfmprel
	jruc	#alp

#lp
	move	*a8(OCTRL),a1
	move	*a0(ICTRL),a14
	andi	>8003,a1
	or	a14,a1
	move	a1,*a8(OCTRL)
	calla	obj_aniq_scld
	clr	a0
	move	a0,*a8(OXANI),L		;Clr scaled anipt
#alp
	move	*a9+,a0			;Any flags with sleep cnt?
	jrnn	#slp			; br=no
	move	a0,a2
	move	*a9+,a0,L
	calla	pal_getf
	move	a0,*a8(OPAL)
	move	a2,a0
	sll	32-8,a0			;Keep 8 lsbs for sleep cnt
	srl	32-8,a0
#slp
	calla	PRCSLP
	move	*a9+,a0,L
	jrnz	#lp
	jauc	DELOBJDIE


smoke_t
	.long	smoko_l,smokw_l,smoko_l,smokp_l
smoke_team_t
	.long	smokb_l,smokw_l,smokb_l,smokb_l

smoko_l
	LW	XPLOD_YEL,2
	LWL	SMOK1_01,2+>8000,SMOK_O_P
	LW	SMOK1_02,2
	LW	SMOK1_03,2
	LWL	SMOK1_04,2+>8000,SMOK_W_P
	LW	SMOK1_05,2
	LW	SMOK1_06,2
	LW	SMOK1_07,2
	LW	SMOK1_08,2
	LW	SMOK1_09,2
	LW	SMOK1_10,2
	LW	SMOK1_11,2
	LWL0	SMOK1_12,2
smokw_l
	LW	XPLOD_BRT,2
	LWL	SMOK1_02,2+>8000,SMOK_W_P
	LW	SMOK1_03,2
	LW	SMOK1_04,2
	LW	SMOK1_05,2
	LW	SMOK1_06,2
	LW	SMOK1_07,2
	LW	SMOK1_08,2
	LW	SMOK1_09,2
	LW	SMOK1_10,1
	LW	SMOK1_11,1
	LWL0	SMOK1_12,1
smokb_l
	LW	XPLOD_BLU,2
	LWL	SMOK1_01,2+>8000,SMOK_B_P
	LW	SMOK1_02,2
	LW	SMOK1_03,2
	LWL	SMOK1_04,2+>8000,SMOK_W_P
	LW	SMOK1_05,2
	LW	SMOK1_06,2
	LW	SMOK1_07,2
	LW	SMOK1_08,2
	LW	SMOK1_09,2
	LW	SMOK1_10,2
	LW	SMOK1_11,2
	LWL0	SMOK1_12,2
smokp_l
	LW	XPLOD_BLU,2
	LWL	SMOK1_02,2+>8000,SMOK_P_P
	LW	SMOK1_03,2
	LW	SMOK1_04,2
	LWL	SMOK1_05,2+>8000,SMOK_W_P
	LW	SMOK1_06,2
	LW	SMOK1_07,2
	LW	SMOK1_08,2
	LW	SMOK1_09,2
	LW	SMOK1_10,1
	LW	SMOK1_11,1
	LWL0	SMOK1_12,1


SCLT	.macro	sx,sy,sxa,sya
	.eval	:sx:*1048,X	;Convert (has slight error)
	.eval	:sy:*1048,Y
	.eval	:sxa:*1048,XA
	.eval	:sya:*1048,YA
	.loop	10
	.word	>10000000/X,>10000000/Y
	.word	>100000/(>10000000/X),>100000/(>10000000/Y)
	.eval	X+XA*1/4,X
	.eval	Y+YA*1/4,Y
	.endloop
	.loop	10
	.word	>10000000/X,>10000000/Y
	.word	>100000/(>10000000/X),>100000/(>10000000/Y)
	.eval	X+XA*2/4,X
	.eval	Y+YA*2/4,Y
	.endloop
	.loop	10
	.word	>10000000/X,>10000000/Y
	.word	>100000/(>10000000/X),>100000/(>10000000/Y)
	.eval	X+XA*3/4,X
	.eval	Y+YA*3/4,Y
	.endloop
	.loop	10
	.word	>10000000/X,>10000000/Y
	.word	>100000/(>10000000/X),>100000/(>10000000/Y)
	.eval	X+XA,X
	.eval	Y+YA,Y
	.endloop
	.endm

;--------------------
; Generate scale tables

;scale30_t
;	SCLT	300,300,19,19

;scale50_t
;	SCLT	500,500,31,31

scale50_t
	SCLT	330,330,18,18


********************************
* Get random # with mask
* A0=Mask
* >A0=Rnd # (Pass CC)
* Trashes scratch

 SUBRP	rnd

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	and	a1,a0
	rets

#*******************************
*
* A3 - direction
* >a0 - dunk seq.

 SUBR	getdunkseq


	move	*a13(plyr_num),a0	;If on fire, don't use turbo on run
	.ref	plyr_onfire
	move	@plyr_onfire,a1
	btst	a0,a1
	jrnz	set5				;br=player is on fire!!

	move	*a13(plyr_attrib_p),a0,L
	move	*a0(PAT_DUNKSKILL),a0

;	movk 	9,a0

	sll	5,a0
	addi	jmp_t,a0
	move	*a0,a0,L
	jump	a0

set5
	addi	d5u_t,a3

	cmpi	40,a4
	jrle	#shortd			;Under hoop?
	addi	d5s_t-d5u_t,a3

	cmpi	70,a4			;Short range
;	cmpi	60,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d5m_t-d5s_t,a3,W

	cmpi	100,a4			;Med range
	jrle	#shortd
	addi	d5l_t-d5m_t,a3,W
	jruc	#shortd
;
set4
	addi	d4u_t,a3

	cmpi	40,a4
	jrle	#shortd			;Under hoop?
	addi	d4s_t-d4u_t,a3

	cmpi	70,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d4m_t-d4s_t,a3,W

	cmpi	100,a4			;Med range
	jrle	#shortd
	addi	d4l_t-d4m_t,a3,W
	jruc	#shortd

;
set3
	addi	d3u_t,a3

	cmpi	40,a4
	jrle	#shortd			;Under hoop?
	addi	d3s_t-d3u_t,a3

	cmpi	70,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d3m_t-d3s_t,a3,W

	cmpi	100,a4			;Med range
	jrle	#shortd
	addi	d3l_t-d3m_t,a3,W
	jruc	#shortd

;
set2
	addi	d3u_t,a3

	cmpi	40,a4
	jrle	#shortd			;Under hoop?
	addi	d2s_t-d2u_t,a3

	cmpi	70,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d2m_t-d2s_t,a3,W

	cmpi	100,a4			;Med range
	jrle	#shortd
	addi	d2l_t-d2m_t,a3,W
	jruc	#shortd

;
set1
	addi	d1u_t,a3

	cmpi	40,a4
;	cmpi	60,a4
	jrle	#shortd			;Under hoop?
	addi	d1s_t-d1u_t,a3

	cmpi	70,a4			;Short range
;	cmpi	80,a4			;Short range
	jrle	#shortd

	move	*a13(plyr_turbon),a14
	jrz	#sj

	addi	d1m_t-d1s_t,a3,W

	cmpi	100,a4			;Med range
;	cmpi	110,a4			;Med range
	jrle	#shortd

	addi	d1l_t-d1m_t,a3,W


#shortd	clr	a0
	rets
#sj	movk	1,a0
	rets


;
; Which set of dunks to use based on 0-10 attribute level
;
jmp_t	.long	set1,set1,set1,set2,set2
	.long	set3,set4,set4,set5,set5,set5


#****************************************************************************


;Set of dunks for #5 skill level 

d5u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d5s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d5m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d5l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t

;UNDER hoop
#d1u_t	.word	3-1
	.word	DUNKA3_SEQ,DUNKS2_SEQ,DUNKU3_SEQ

#d2u_t	.word	4-1
	.word	DUNKA3_SEQ,DUNKL3_SEQ,DUNKP2_SEQ,DUNKU3_SEQ

#d3u_t	.word	3-1
	.word	DUNKD2_SEQ,DUNKL3_SEQ,DUNKU3_SEQ

#d4u_t	.word	4-1
	.word	DUNKD2_SEQ,DUNKE_SEQ,DUNKL3_SEQ,DUNKP2_SEQ

#d5u_t	.word	2-1
	.word	DUNKE_SEQ,DUNKP2_SEQ


;NEAR hoop
#d1s_t	.word	6-1
	.word	DUNKA2_SEQ,DUNKP2_SEQ,DUNKA2_SEQ,DUNKP2_SEQ
	.word	DUNKS2_SEQ,DUNKU3_SEQ

#d2s_t	.word	3-1
	.word	DUNKA2_SEQ,DUNKP2_SEQ,DUNKU3_SEQ

#d3s_t	.word	1-1
	.word	DUNKU3_SEQ

#d4s_t	.word	4-1
	.word	DUNKE_SEQ,DUNKP2_SEQ,DUNKP2_SEQ,DUNKV4_SEQ

#d5s_t	.word	2-1
	.word	DUNKE_SEQ,DUNKP2_SEQ


;MEDIUM to hoop
#d1m_t	.word	13-1
	.word	DUNKA_SEQ,DUNKA2_SEQ,DUNKC_SEQ,DUNKK_SEQ
	.word	DUNKK2_SEQ,DUNKK_SEQ,DUNKZ3_SEQ,DUNKR2_SEQ
	.word	DUNKU2_SEQ,DUNKY2_SEQ,DUNKLAY_SEQ,DUNKC_SEQ
	.word	DUNKZ3_SEQ


#d2m_t	.word	14-1
	.word	DUNKA_SEQ,DUNKA2_SEQ,DUNKB_SEQ,DUNKJ2_SEQ
	.word	DUNKK_SEQ,DUNKN_SEQ,DUNKC_SEQ,DUNKP_SEQ
	.word	DUNKT_SEQ,DUNKT2_SEQ,DUNKV_SEQ,DUNKZ3_SEQ
	.word	DUNKY2_SEQ,DUNKZ2_SEQ


#d3m_t	.word	12-1
	.word	DUNKB_SEQ,DUNKJ_SEQ,DUNKQ_SEQ,DUNKV_SEQ
	.word	DUNKLAY_SEQ,DUNKY2_SEQ,DUNKJ2_SEQ,DUNKD_SEQ
	.word	DUNKK_SEQ,DUNKX2_SEQ,DUNKX3_SEQ,DUNKT_SEQ


#d4m_t	.word	9-1
	.word	DUNKJ2_SEQ,DUNKP_SEQ,DUNKQ_SEQ,DUNKT2_SEQ
	.word	DUNKP_SEQ,DUNKX2_SEQ,DUNKX3_SEQ,DUNKD_SEQ
	.word	DUNKE2_SEQ


#d5m_t	.word	3-1
	.word	DUNKE2_SEQ,DUNKP_SEQ,DUNKZ_SEQ


;FAR from hoop
#d1l_t	.word	11-1
	.word	DUNKB3_SEQ,DUNKU2_SEQ,DUNKK2_SEQ,DUNKN_SEQ
	.word	DUNKY2_SEQ,DUNKN3_SEQ,DUNKO_SEQ,DUNKP3_SEQ
	.word	DUNKY_SEQ,DUNKLAY_SEQ,DUNKZ3_SEQ


#d2l_t	.word	32-1
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKK2_SEQ,DUNKB3_SEQ
	.word	DUNKN_SEQ,DUNKN2_SEQ,DUNKN3_SEQ,DUNKO_SEQ
	.word	DUNKP_SEQ,DUNKP3_SEQ,DUNKG2_SEQ,DUNKF_SEQ
	.word	DUNKS_SEQ,DUNKT_SEQ,DUNKT3_SEQ,DUNKLAY2_SEQ
	.word	DUNKV2_SEQ,DUNKT5_SEQ,DUNKU2_SEQ,DUNKV_SEQ
	.word	DUNKV2_SEQ,DUNKV3_SEQ,DUNKW3_SEQ,DUNKJ2_SEQ
	.word	DUNKLAY3_SEQ,DUNKY2_SEQ,DUNKZ2_SEQ,DUNKY_SEQ
	.word	DUNKLAY6_SEQ,DUNKX3_SEQ,DUNKZ3_SEQ,DUNKLAY_SEQ


#d3l_t	.word	37-1
	.word	DUNKB_SEQ,DUNKK2_SEQ,DUNKD_SEQ,DUNKG2_SEQ
	.word	DUNKL_SEQ,DUNKN_SEQ,DUNKN2_SEQ,DUNKJ_SEQ
	.word	DUNKN3_SEQ,DUNKO_SEQ,DUNKP3_SEQ,DUNKQ_SEQ
	.word	DUNKQ2_SEQ,DUNKS_SEQ,DUNKT_SEQ,DUNKQ3_SEQ
	.word	DUNKT3_SEQ,DUNKV_SEQ,DUNKT5_SEQ,DUNKU2_SEQ
	.word	DUNKV_SEQ,DUNKV2_SEQ,DUNKV3_SEQ,DUNKW_SEQ
	.word	DUNKW2_SEQ,DUNKW3_SEQ,DUNKX_SEQ,DUNKP3_SEQ
	.word	DUNKY_SEQ,DUNKLAY_SEQ,DUNKLAY2_SEQ,DUNKY2_SEQ
	.word	DUNKLAY3A_SEQ,DUNKV_SEQ,DUNKLAY7_SEQ,DUNKO2_SEQ
	.word	DUNKL2_SEQ


#d4l_t	.word	17-1
	.word	DUNKG2_SEQ,DUNKJ_SEQ,DUNKK2_SEQ,DUNKY_SEQ
	.word	DUNKP_SEQ,DUNKQ_SEQ,DUNKQ2_SEQ,DUNKX2_SEQ
	.word	DUNKW_SEQ,DUNKW2_SEQ,DUNKW3_SEQ,DUNKX_SEQ
	.word	DUNKP3_SEQ,DUNKT5_SEQ,DUNKJ_SEQ,DUNKY2_SEQ
	.word	DUNKD_SEQ


#d5l_t	.word	6-1
	.word	DUNKP_SEQ,DUNKW_SEQ,DUNKW2_SEQ,DUNKW3_SEQ
	.word	DUNKX_SEQ,DUNKZ_SEQ


#****************************************************************************
;Set of dunks for #4 skill players

d4u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d4s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d4m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d4l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t

;UNDER hoop
#d1u_t	.word	3-1
	.word	DUNKA3_SEQ,DUNKS2_SEQ,DUNKU3_SEQ

#d2u_t	.word	3-1
	.word	DUNKA3_SEQ,DUNKL3_SEQ,DUNKP2_SEQ

#d3u_t	.word	3-1
	.word	DUNKD2_SEQ,DUNKL3_SEQ,DUNKU3_SEQ

#d4u_t	.word	4-1
	.word	DUNKD2_SEQ,DUNKE_SEQ,DUNKL3_SEQ,DUNKP2_SEQ

#d5u_t	.word	2-1
	.word	DUNKE_SEQ,DUNKP2_SEQ


;NEAR hoop
#d1s_t	.word	4-1
	.word	DUNKA2_SEQ,DUNKS2_SEQ,DUNKU3_SEQ,DUNKLAY3C_SEQ

#d2s_t	.word	6-1
	.word	DUNKA2_SEQ,DUNKP2_SEQ,DUNKU3_SEQ,DUNKR_SEQ
	.word	DUNKLAY3C_SEQ,DUNKP2_SEQ

#d3s_t	.word	2-1
	.word	DUNKU3_SEQ,DUNKLAY3C_SEQ

#d4s_t	.word	2-1
	.word	DUNKE_SEQ,DUNKP2_SEQ

#d5s_t	.word	2-1
	.word	DUNKE_SEQ,DUNKP2_SEQ


;MEDIUM to hoop
#d1m_t	.word	12-1
	.word	DUNKA_SEQ,DUNKA2_SEQ,DUNKB3_SEQ,DUNKC_SEQ
	.word	DUNKK_SEQ,DUNKR2_SEQ,DUNKU2_SEQ,DUNKY2_SEQ
	.word	DUNKZ3_SEQ,DUNKR2_SEQ,DUNKZ3_SEQ,DUNKLAY3A_SEQ


#d2m_t	.word	16-1
	.word	DUNKA_SEQ,DUNKA2_SEQ,DUNKB_SEQ,DUNKC_SEQ
	.word	DUNKK_SEQ,DUNKV_SEQ,DUNKR_SEQ,DUNKT_SEQ
	.word	DUNKLAY_SEQ,DUNKZ2_SEQ,DUNKZ3_SEQ,DUNKLAY8_SEQ
	.word	DUNKP_SEQ,DUNKY2_SEQ,DUNKJ2_SEQ,DUNKT2_SEQ


#d3m_t	.word	11-1
	.word	DUNKB_SEQ,DUNKD_SEQ,DUNKJ2_SEQ,DUNKV_SEQ
	.word	DUNKY2_SEQ,DUNKT_SEQ,DUNKT2_SEQ,DUNKX2_SEQ
	.word	DUNKQ_SEQ,DUNKLAY_SEQ,DUNKX3_SEQ


#d4m_t	.word	9-1
	.word	DUNKJ2_SEQ,DUNKX3_SEQ,DUNKE2_SEQ,DUNKD_SEQ
	.word	DUNKP_SEQ,DUNKQ_SEQ,DUNKX2_SEQ,DUNKT2_SEQ
	.word	DUNKV_SEQ


#d5m_t	.word	3-1
	.word	DUNKP_SEQ,DUNKE2_SEQ,DUNKZ_SEQ


;FAR from hoop
#d1l_t	.word	12-1
	.word	DUNKB3_SEQ,DUNKU2_SEQ,DUNKK2_SEQ,DUNKN_SEQ
	.word	DUNKN2_SEQ,DUNKP3_SEQ,DUNKU2_SEQ,DUNKY2_SEQ
	.word	DUNKY_SEQ,DUNKLAY_SEQ,DUNKZ3_SEQ,DUNKP3_SEQ


#d2l_t	.word	24-1
	.word	DUNKZ3_SEQ,DUNKB_SEQ,DUNKK2_SEQ,DUNKB3_SEQ
	.word	DUNKF_SEQ,DUNKG_SEQ,DUNKG2_SEQ,DUNKJ2_SEQ
	.word	DUNKY2_SEQ,DUNKK2_SEQ,DUNKV2_SEQ,DUNKV3_SEQ
	.word	DUNKN2_SEQ,DUNKP_SEQ,DUNKP3_SEQ,DUNKT_SEQ
	.word	DUNKT3_SEQ,DUNKT5_SEQ,DUNKU2_SEQ,DUNKV_SEQ
	.word	DUNKY_SEQ,DUNKLAY_SEQ,DUNKZ2_SEQ,DUNKS_SEQ


#d3l_t	.word	28-1
	.word	DUNKB_SEQ,DUNKJ_SEQ,DUNKD_SEQ,DUNKQ_SEQ
	.word	DUNKG_SEQ,DUNKG2_SEQ,DUNKJ_SEQ,DUNKY2_SEQ
	.word	DUNKK2_SEQ,DUNKL_SEQ,DUNKN2_SEQ,DUNKP3_SEQ
	.word	DUNKQ2_SEQ,DUNKS_SEQ,DUNKT_SEQ,DUNKQ3_SEQ
	.word	DUNKY_SEQ,DUNKT3_SEQ,DUNKT5_SEQ,DUNKU2_SEQ
	.word	DUNKV_SEQ,DUNKV2_SEQ,DUNKW_SEQ,DUNKW3_SEQ
	.word	DUNKX_SEQ,DUNKLAY8_SEQ,DUNKO2_SEQ,DUNKL2_SEQ

#d4l_t	.word	20-1
	.word	DUNKJ_SEQ,DUNKD_SEQ,DUNKG_SEQ,DUNKP_SEQ
	.word	DUNKG2_SEQ,DUNKJ_SEQ,DUNKD_SEQ,DUNKK2_SEQ
	.word	DUNKQ_SEQ,DUNKQ2_SEQ,DUNKT3_SEQ,DUNKY2_SEQ
	.word	DUNKT5_SEQ,DUNKV_SEQ,DUNKV2_SEQ,DUNKV3_SEQ
	.word	DUNKW_SEQ,DUNKW3_SEQ,DUNKX_SEQ,DUNKY_SEQ


#d5l_t	.word	5-1
	.word	DUNKP_SEQ,DUNKW_SEQ,DUNKW3_SEQ,DUNKX_SEQ
	.word	DUNKZ_SEQ


#****************************************************************************
;Set of dunks for #3 skill players

d3u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d3s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d3m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d3l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t

;UNDER hoop
#d1u_t	.word	2-1
	.word	DUNKS2_SEQ,DUNKU3_SEQ

#d2u_t	.word	1-1
	.word	DUNKA3_SEQ

#d3u_t	.word	2-1
	.word	DUNKD2_SEQ,DUNKU3_SEQ

#d4u_t	.word	1-1
	.word	DUNKD2_SEQ

#d5u_t	.word	2-1
	.word	DUNKLAY6_SEQ,DUNKE_SEQ


;NEAR hoop
#d1s_t	.word	4-1
	.word	DUNKA2_SEQ,DUNKS2_SEQ,DUNKU3_SEQ,DUNKLAY3C_SEQ

#d2s_t	.word	4-1
	.word	DUNKA2_SEQ,DUNKP2_SEQ,DUNKU3_SEQ,DUNKLAY3C_SEQ

#d3s_t	.word	2-1
	.word	DUNKU3_SEQ,DUNKLAY3C_SEQ

#d4s_t	.word	3-1
	.word	DUNKE_SEQ,DUNKE_SEQ,DUNKP2_SEQ

#d5s_t	.word	2-1
	.word	DUNKE_SEQ,DUNKP2_SEQ


;MEDIUM to hoop
#d1m_t	.word	12-1
	.word	DUNKA_SEQ,DUNKA2_SEQ,DUNKB3_SEQ,DUNKC_SEQ
	.word	DUNKK_SEQ,DUNKLAY6_SEQ,DUNKR2_SEQ,DUNKZ3_SEQ
	.word	DUNKLAY_SEQ,DUNKLAY3A_SEQ,DUNKLAY7_SEQ,DUNKLAY3B_SEQ


#d2m_t	.word	16-1
	.word	DUNKA2_SEQ,DUNKB_SEQ,DUNKK_SEQ,DUNKC_SEQ
	.word	DUNKP_SEQ,DUNKV_SEQ,DUNKR_SEQ,DUNKJ2_SEQ
	.word	DUNKLAY_SEQ,DUNKLAY2_SEQ,DUNKZ3_SEQ,DUNKLAY3A_SEQ
	.word	DUNKLAY3C_SEQ,DUNKLAY5_SEQ,DUNKLAY7_SEQ,DUNKLAY8_SEQ


#d3m_t	.word	15-1
	.word	DUNKD_SEQ,DUNKJ2_SEQ,DUNKK_SEQ,DUNKLAY3B_SEQ
	.word	DUNKQ_SEQ,DUNKV_SEQ,DUNKX3_SEQ,DUNKB_SEQ
	.word	DUNKLAY2_SEQ,DUNKLAY3_SEQ,DUNKX2_SEQ,DUNKLAY8_SEQ
	.word	DUNKLAY6_SEQ,DUNKLAY7A_SEQ,DUNKX2_SEQ


#d4m_t	.word	11-1
	.word	DUNKD_SEQ,DUNKE2_SEQ,DUNKX3_SEQ,DUNKP_SEQ
	.word	DUNKT2_SEQ,DUNKJ2_SEQ,DUNKLAY6_SEQ,DUNKX2_SEQ
	.word	DUNKQ_SEQ,DUNKV_SEQ,DUNKX2_SEQ

#d5m_t	.word	4-1
	.word	DUNKE2_SEQ,DUNKP_SEQ,DUNKLAY6_SEQ,DUNKZ_SEQ


;FAR from hoop
#d1l_t	.word	11-1
	.word	DUNKB3_SEQ,DUNKB3_SEQ,DUNKK2_SEQ,DUNKN2_SEQ
	.word	DUNKP3_SEQ,DUNKU2_SEQ,DUNKY_SEQ,DUNKLAY7_SEQ
	.word	DUNKLAY_SEQ,DUNKLAY3_SEQ,DUNKLAY3B_SEQ


#d2l_t	.word	29-1
	.word	DUNKA_SEQ,DUNKB_SEQ,DUNKB_SEQ,DUNKB3_SEQ
	.word	DUNKG_SEQ,DUNKG2_SEQ,DUNKJ2_SEQ,DUNKP3_SEQ
	.word	DUNKP_SEQ,DUNKK2_SEQ,DUNKN2_SEQ,DUNKY_SEQ
	.word	DUNKS_SEQ,DUNKT_SEQ,DUNKT_SEQ,DUNKT3_SEQ
	.word	DUNKT5_SEQ,DUNKU2_SEQ,DUNKV_SEQ,DUNKV2_SEQ
	.word	DUNKLAY_SEQ,DUNKLAY2_SEQ,DUNKLAY3_SEQ,DUNKLAY3A_SEQ
	.word	DUNKLAY3B_SEQ,DUNKLAY8_SEQ,DUNKLAY6_SEQ,DUNKLAY7_SEQ
	.word	DUNKX3_SEQ


#d3l_t	.word	29-1
	.word	DUNKB_SEQ,DUNKB2_SEQ,DUNKD_SEQ,DUNKX_SEQ
	.word	DUNKG_SEQ,DUNKG2_SEQ,DUNKJ_SEQ,DUNKW_SEQ
	.word	DUNKK2_SEQ,DUNKL_SEQ,DUNKN2_SEQ,DUNKP3_SEQ
	.word	DUNKQ_SEQ,DUNKQ2_SEQ,DUNKS_SEQ,DUNKT_SEQ
	.word	DUNKT_SEQ,DUNKT3_SEQ,DUNKT5_SEQ,DUNKU2_SEQ
	.word	DUNKV_SEQ,DUNKV2_SEQ,DUNKW3_SEQ,DUNKLAY8_SEQ
	.word	DUNKY_SEQ,DUNKLAY_SEQ,DUNKLAY3C_SEQ,DUNKLAY6_SEQ
	.word	DUNKLAY7A_SEQ


#d4l_t	.word	18-1
	.word	DUNKD_SEQ,DUNKG_SEQ,DUNKP_SEQ,DUNKQ_SEQ
	.word	DUNKG2_SEQ,DUNKJ_SEQ,DUNKK2_SEQ,DUNKX_SEQ
	.word	DUNKQ2_SEQ,DUNKT3_SEQ,DUNKLAY6_SEQ,DUNKY_SEQ
	.word	DUNKT5_SEQ,DUNKV_SEQ,DUNKV2_SEQ,DUNKW_SEQ
	.word	DUNKW3_SEQ,DUNKX2_SEQ


#d5l_t	.word	6-1
	.word	DUNKP_SEQ,DUNKW_SEQ,DUNKW3_SEQ,DUNKX_SEQ
	.word	DUNKLAY6_SEQ,DUNKZ_SEQ


#****************************************************************************
;Set of dunks for #2 skill players

d2u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d2s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d2m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d2l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t

;UNDER hoop
#d1u_t	.word	1-1
	.word	DUNKS2_SEQ

#d2u_t	.word	1-1
	.word	DUNKA3_SEQ

#d3u_t	.word	1-1
	.word	DUNKU3_SEQ

#d4u_t	.word	1-1
	.word	DUNKE_SEQ

#d5u_t	.word	1-1
	.word	DUNKLAY6_SEQ


;NEAR hoop
#d1s_t	.word	2-1
	.word	DUNKU3_SEQ,DUNKLAY3C_SEQ

#d2s_t	.word	1-1
	.word	DUNKLAY3C_SEQ

#d3s_t	.word	1-1
	.word	DUNKLAY3C_SEQ

#d4s_t	.word	1-1
	.word	DUNKA2_SEQ

#d5s_t	.word	1-1
	.word	DUNKE_SEQ


;MEDIUM to hoop
#d1m_t	.word	6-1
	.word	DUNKA2_SEQ,DUNKC_SEQ,DUNKLAY3_SEQ,DUNKLAY3A_SEQ
	.word	DUNKLAY5_SEQ,DUNKLAY6_SEQ


#d2m_t	.word	13-1
	.word	DUNKP_SEQ,DUNKR_SEQ,DUNKA2_SEQ,DUNKC_SEQ,DUNKA_SEQ
	.word	DUNKLAY8_SEQ,DUNKLAY_SEQ,DUNKLAY2_SEQ,DUNKLAY7A_SEQ
	.word	DUNKLAY5_SEQ,DUNKLAY6_SEQ,DUNKLAY7_SEQ,DUNKJ2_SEQ
	.word	DUNKLAY3_SEQ


#d3m_t	.word	14-1
	.word	DUNKJ2_SEQ,DUNKP3_SEQ,DUNKQ_SEQ,DUNKLAY8_SEQ
	.word	DUNKLAY_SEQ,DUNKLAY2_SEQ,DUNKLAY3_SEQ,DUNKLAY3A_SEQ
	.word	DUNKLAY5_SEQ,DUNKLAY6_SEQ,DUNKLAY7_SEQ,DUNKLAY7A_SEQ
	.word	DUNKT_SEQ,DUNKD_SEQ


#d4m_t	.word	5-1
	.word	DUNKQ_SEQ,DUNKE2_SEQ,DUNKJ_SEQ,DUNKD_SEQ
	.word	DUNKLAY6_SEQ


#d5m_t	.word	2-1
	.word	DUNKE2_SEQ,DUNKLAY6_SEQ


;FAR from hoop
#d1l_t	.word	7-1
	.word	DUNKP3_SEQ,DUNKU2_SEQ,DUNKLAY_SEQ,DUNKLAY3C_SEQ
	.word	DUNKLAY3_SEQ,DUNKLAY3B_SEQ,DUNKLAY7_SEQ


#d2l_t	.word	10-1
	.word	DUNKLAY2_SEQ,DUNKLAY3_SEQ,DUNKLAY3A_SEQ,DUNKLAY7A_SEQ
	.word	DUNKLAY7_SEQ,DUNKLAY8_SEQ,DUNKA_SEQ,DUNKB3_SEQ
	.word	DUNKB2_SEQ,DUNKLAY_SEQ


#d3l_t	.word	12-1
	.word	DUNKG_SEQ,DUNKG2_SEQ,DUNKJ_SEQ,DUNKQ_SEQ
	.word	DUNKD_SEQ,DUNKLAY_SEQ,DUNKLAY2_SEQ,DUNKLAY3_SEQ
	.word	DUNKLAY3A_SEQ,DUNKLAY6_SEQ,DUNKLAY7_SEQ,DUNKLAY8_SEQ


#d4l_t	.word	4-1
	.word	DUNKV2_SEQ,DUNKJ_SEQ,DUNKLAY6_SEQ,DUNKG_SEQ


#d5l_t	.word	3-1
	.word	DUNKP_SEQ,DUNKW3_SEQ,DUNKLAY6_SEQ


#****************************************************************************
;Set of dunks for #1 skill players

d1u_t	.long	#d1u_t,#d2u_t,#d3u_t,#d4u_t
	.long	#d5u_t,#d4u_t,#d3u_t,#d2u_t, #d1u_t

d1s_t	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

d1m_t	.long	#d1m_t,#d2m_t,#d3m_t,#d4m_t
	.long	#d5m_t,#d4m_t,#d3m_t,#d2m_t, #d1m_t

d1l_t	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t

;UNDER hoop
#d1u_t	.word	1-1
	.word	DUNKS2_SEQ

#d2u_t	.word	1-1
	.word	DUNKA3_SEQ

#d3u_t	.word	1-1
	.word	DUNKD2_SEQ

#d4u_t	.word	1-1
	.word	DUNKE_SEQ

#d5u_t	.word	1-1
	.word	DUNKLAY6_SEQ


;NEAR hoop
#d1s_t	.word	2-1
	.word	DUNKLAY7_SEQ,DUNKLAY6_SEQ

#d2s_t	.word	2-1
	.word	DUNKLAY7_SEQ,DUNKLAY6_SEQ

#d3s_t	.word	2-1
	.word	DUNKLAY3C_SEQ,DUNKLAY7_SEQ

#d4s_t	.word	2-1
	.word	DUNKLAY3C_SEQ,DUNKLAY6_SEQ

#d5s_t	.word	2-1
	.word	DUNKLAY3C_SEQ,DUNKLAY6_SEQ


;MEDIUM to hoop
#d1m_t	.word	1-1
	.word	DUNKLAY6_SEQ


#d2m_t	.word	2-1
	.word	DUNKLAY5_SEQ,DUNKLAY6_SEQ


#d3m_t	.word	2-1
	.word	DUNKLAY5_SEQ,DUNKLAY6_SEQ


#d4m_t	.word	1-1
	.word	DUNKLAY6_SEQ


#d5m_t	.word	1-1
	.word	DUNKLAY6_SEQ


;FAR from hoop
#d1l_t	.word	2-1
	.word	DUNKLAY5_SEQ,DUNKLAY6_SEQ


#d2l_t	.word	2-1
	.word	DUNKLAY6_SEQ,DUNKLAY7_SEQ


#d3l_t	.word	2-1
	.word	DUNKLAY6_SEQ,DUNKLAY8_SEQ


#d4l_t	.word	1-1
	.word	DUNKLAY6_SEQ


#d5l_t	.word	1-1
	.word	DUNKLAY6_SEQ


;Small heads!
	.def	Gug_h		
	.def	BEdwrds_h
	.def	Brown_h
	.def	KAnderson_h
	.def	Willis_h
	.def	Mourn_h
	.def	Kukoc_h
	.def	Jack_h	
	.def	Mash_h	
	.def	Dumars_h
	.def	Rodman_h
	.def	Webber_h
	.def	Horry_h
	.def	Smits_h
	.def	Campbell_h
	.def	Baker_h
	.def	Rider_h
	.def	Morris_h
	.def	Mason_h
	.def	Starks_h
	.def	AHard_h
	.def	NAnders_h
	.def	Weath_h
	.def	Brad_h
	.def	KJohn_h
	.def	CRobinson_h
	.def	Rich_h
	.def	Payton_h
	.def	Mckey_h
	.def	Benoit_h
	.def	Cheaney_h


	.def	Robertson_h
	.def	Chapman_h
	.def	Lang_h
	.def	Scott_h
	.def	Webb_h
;	.def	MJohnson_h
	.def	Ruffin_h

Robertson_h
	HDMAC	Robertsn1
Chapman_h
	HDMAC	Chapman1
Lang_h
	HDMAC	Lang1
Scott_h
	HDMAC	Scott1
Webb_h
	HDMAC	Webb1
;MJohnson_h
;	HDMAC	MJohnson1
Ruffin_h
	HDMAC	Ruffin1



Gug_h		
	HDMAC	gug1
BEdwrds_h
	HDMAC	BEdwrd1
Brown_h
	HDMAC	BROWN1
KAnderson_h
	HDMAC	K_AND1
Willis_h
	HDMAC	WILLIS1
Mourn_h
	HDMAC	MOURN1
Kukoc_h
	HDMAC	KUKOC1
Jack_h	
	HDMAC	JACK1
Mash_h	
	HDMAC	MASH1
Dumars_h
	HDMAC	DUMARS1
Rodman_h
;	HDMAC	ALIEN01
	HDMAC	RODMAN1
Webber_h
	HDMAC	WEBBER1
Horry_h
	HDMAC	HORRY1
Smits_h
	HDMAC	SMITS1
Campbell_h
	HDMAC	CAMP1
Baker_h
	HDMAC	BAKER1
Rider_h
	HDMAC	RIDER1
Morris_h
	HDMAC	MORRIS1
Mason_h
	HDMAC	MASON1
Starks_h
	HDMAC	STARKS1
AHard_h
	HDMAC	A_HARD1
NAnders_h
	HDMAC	N_AND1
Weath_h
	HDMAC	WEATH1
Brad_h
	HDMAC	BRAD1
KJohn_h
	HDMAC	K_JOHN1
CRobinson_h
	HDMAC	C_ROB1
Rich_h
	HDMAC	RICH1
Payton_h
	HDMAC	PAYTON1
Mckey_h
	HDMAC	MCKEY1
Benoit_h
	HDMAC	BENOIT1
Cheaney_h
	HDMAC	CHEAN1


; This table contains the SMALL head img. table ptrs. for the heads in
;  'CREATE PLAYER'  (coresponds with mugshots_tbl in select3.asm)
;
plr_heads_small
	.long	Cow_h
	.long	Alien_h
	.long	Pippen_h
	.long	Chk_h
	.long	kim_h
	.long	fifi_h
	.long	Gor_h
	.long	LJohnson_h
	.long	Mik_h
	.long	Lis_h
	.long	madball_h
	.long	Old_h
	.long	jackjr_h
	.long	clown_h
	.long	mar_h
	.long	Ghill_h
	.long	Ber_h
	.long	Olajuwon_h
	.long	Fat_h
	.long	Ang_h
	.long	ape_h
	.long	Mourn_h
	.long	Fra_h
	.long	AHard_h
	.long	Guido_h
	.long	Gre_h
	.long	Pig_h
	.long	Kemp_h
	.long	cheech_h
	.long	Mel_h
	.long	Wiz_h
	.long	Webber_h
	.long	Joe_h
	.long	mxv_h
	.long	eddie_h
	.long	oursler_h
	.long	bardo_h
	.long	willy_h
	.long	eric_h
	.long	sean_h
	.long	mike_h
	.long	dim_h

plr_heads_small_end
	.long	Cow_h
	.long	Alien_h
	.long	Pippen_h
	.long	Chk_h
plr_heads_small_end2


SM_HEADS_CNT	equ	((plr_heads_small_end-plr_heads_small)/32)

;
; This table contains the SMALL head flesh pal table ptrs. for the heads in
;  'CREATE PLAYER'  (coresponds with mugshots_tbl in select3.asm)
;
	.def	plr_flesh_pal_tbl
plr_flesh_pal_tbl
	.long	COW_F
	.long	ALIEN_F
	.long	pippin_f
	.long	CHK_F
	.long	KIM_F
	.long	FIFI_F
	.long	GOR_F
	.long	johnson_f
	.long	MIK_F
	.long	LIS_F
	.long	MADBAL_F
	.long	OLD_F
	.long	JACKJR_F
	.long	CLOWN_F
	.long	MAR_F
	.long	GHILL_F
	.long	BER_F
	.long	Hakeem_f
	.long	FAT_F
	.long	ANG_F
	.long	VIKAPE_F
	.long	MOURN_F
	.long	FRA_F
	.long	A_HARD_F
	.long	GUIDO_F
	.long	GRE_F
	.long	PIG_F
	.long	kemp_f
	.long	CHEECH_F
	.long	MEL_F
	.long	WIZ_F
	.long	WEBBER_F
	.long	JOE_F
	.long	MXV_F
	.long	EDDIE_F
	.long	OURSL_F
	.long	BARD_F
	.long	WIL_F
	.long	ERI_F
	.long	SEA_F
	.long	MIKE_F
	.long	DIM_F

	.long	COW_F
	.long	ALIEN_F
	.long	pippin_f
	.long	CHK_F
plr_flesh_pal_tbl_end

#*****************************************************************************
*
* a9  = meter to display on which side? 0 or 1
* a11 = player number (0 - 3 )

GETUP_SIZE	equ	80 ;102	;174	;99
MAX_TIME	equ	6*TSEC
INV_MULT	equ	256*GETUP_SIZE/MAX_TIME
ONSCR_X		equ	173+1
OFFSCR_X	equ	221

	STRUCTPD
	LONG	IPTR_FRAME
	LONG	IPTR_GREEN
	WORD	DISPLAY_VAL
	LONG	BUTN_PROC

 SUBR	jumpball_meter

;Human players only!
	.ref	PSTATUS
	.ref	plyrproc_t
	SLEEPK	11
	.ref	HALT
#lpx	move	@HALT,a0
	jrz	#contx
	SLEEPK	1
	jruc	#lpx
#contx


;	move	@PSTATUS,a0
;	btst	a11,a0
;	jaz	SUCIDE

	SLEEP	40

	clr	a0
	move	a0,*a13(DISPLAY_VAL)

	;set our x-position based on PLYR_SIDE
	movi	[OFFSCR_X,0],a10
	move	a9,a9
	jrnz	#p2

	dec	a10
	neg	a10
#p2

	.ref	RECVRBLK,JMPBAL_R,JMPBAL_L

	movi	RECVRBLK,a2			;* image (green bar)
	movi	[109,0],a1			;y pos
	movi	1801h,a3			;z pos
	callr	#begin_obj
	move	a8,*a13(IPTR_GREEN),L
	movi	JMPBAL_R,a2			;* image (frame)
	move	a9,a9
	jrnz	#p2_meter
	movi	JMPBAL_L,a2			;* image (frame)
#p2_meter
	movi	[189,0],a1			;y pos
	movi	1800h,a3			;z pos
	callr	#begin_obj
	move	a8,*a13(IPTR_FRAME),L

	move	a11,a10
	sll	5,a10
	addi	plyrproc_t,a10
	move	*a10,a10,L
	move	a13,*a10(plyr_meter_proc),L

	movi	200,a0
	move	a0,*a10(plyr_meter_time)

	CREATE0	#ck_butns
	move	a0,*a13(BUTN_PROC),L


 SUBR 	slide_offscr

;Don't allow a meter to come out for awhile (unless flung)

	movk	10,a11

#offscr_loop
	move	a11,a11
	jrz	#update
	dec	a11
	jruc	#cont
#update
	movi	[OFFSCR_X,0],a0
	callr	#set_x

	move	*a10(plyr_meter_time),a14
	jrnz	#onscr

#cont
	SLEEPK	1
	jruc	#offscr_loop

#exit_offscr
	SLEEP	40	
	movk	10,a11
#exit_loop
	movi	[OFFSCR_X,0],a0
	callr	#set_x
	SLEEPK	1
	dsjs	a11,#exit_loop

	move	*a13(IPTR_FRAME),a0,L
	calla	DELOBJ
	move	*a13(IPTR_GREEN),a0,L
	calla	DELOBJ
	move	*a13(BUTN_PROC),a0,L
	calla	KILL
	DIE

#onscr
	move	a14,a11

	movi	GETUP_SIZE,a0
	move	a0,*a13(DISPLAY_VAL)

;	MOVI	0BDH,A0			;Meter announce sound
;	CALLA	triple_sound

	movi	120,a6
	move	*a10(plyr_meter_time),a5

#onscr_loop

	movi	[ONSCR_X,0],a0
	callr	#set_x

	move	*a10(plyr_meter_time),a7

	movi	GETUP_SIZE,a0
	mpyu	a0,a7			;* GETUP_SIZE
	divu	a11,a7			;/ INITIAL GETUP TIME

	move	*a13(DISPLAY_VAL),a0
	move	a0,a2
	move	a0,a4
	cmp	a0,a7			;has getup been incremented?
	jrle	#ok1

	move	a7,a11
	movi	GETUP_SIZE,a0
	mpyu	a0,a7			;* GETUP_SIZE
	divu	a11,a7			;/ INITIAL GETUP TIME

	move	a7,a3
	sub	a2,a3
	cmpi	10,a3
	jrlt	#ok0
	addk	9,a2
	move	a2,a7
	move	a7,a3
	sub	a4,a3
#ok0
	srl	1,a3
	sub	a3,a7	

#ok1

	subk	1,a6
	jrnz	#dont_bother
	move	*a10(plyr_meter_time),a0
	sub	a0,a5

#dont_bother

	PUSH	a5,a6
	callr	#update_meter
	PULL	a5,a6

	move	a7,a7
	jrz	#exit_offscr
	move	@ditch_meter,a0
	jrnz	#exit_offscr
	

	PUSHP	a5,a6
	SLEEPK	1
	PULLP	a5,a6
	jruc	#onscr_loop

**********
#ck_butns

	movk	20,a8
#lp1	move	*a10(plyr_meter_time),a0
	subk	6,a0
	move	a0,*a10(plyr_meter_time)
	SLEEPK	1
	dsj	a8,#lp1

#ck_butns2

	.ref	PCNT
	move	@PCNT,a0
	ANDK	1,a0
	jrnz	#no

	move	*a10(plyr_meter_time),a0
	inc	a0
	cmpi	200,a0
	jreq	#stop2
	move	a0,*a10(plyr_meter_time)

#no
	move	@PSTATUS,a0
	btst	a11,a0
	jrnz	#conta
;Jumpball player is not in game
;Check teammate
	cmpi	1,a11
	jrnz	#tm2
	btst	0,a0
	jrz	#drone_taps
;Have player 0 control meter
	clr	a0
	jruc	#getbut
#tm2	btst	3,a0
	jrz	#drone_taps
;Have player 3 control meter
	movk	3,a0
	jruc	#getbut

#drone_taps
	movi	190,a0
	.ref	RNDPER
	calla	RNDPER
	jrhi	#yes
	jruc	#no2

#conta	move	a11,a0
	.ref	get_but_val_down
#getbut	calla	get_but_val_down
	jrz	#no2
#yes
	move	*a10(plyr_meter_time),a0
	subk	4,a0
	jrz	#stop
	jrn	#stop
	move	a0,*a10(plyr_meter_time)
#no2

	SLEEPK	1
	jruc	#ck_butns2

#stop
	clr	a0
#stop2
	move	a0,*a10(plyr_meter_time)
;Killed by creating process
	SLEEP	7fffh
	
	DIE



**********
 SUBRP	#set_x

	move	a9,a9
	jrnz	#p22
	neg	a0
#p22
;	addi	[200-1,0],a0			;center of screen
	addi	[0afh,0],a0			;center of screen
	move	a13,a14
	addi	IPTR_FRAME,a14
	move	*a14,a8,L
	move	*a8(OXVAL),a1,L
	sub	a1,a0
	sra	2,a0
	movk	3-1,a1
#lp	move	*a14+,a8,L
	move	*a8(OXVAL),a2,L
	add	a0,a2
	move	a2,*a8(OXVAL),L
	dsj	a1,#lp
	rets


**********
 SUBRP	#begin_obj

	movi	[200-1,0],a0			;x pos
	add	a10,a0

	movi	DMAWNZ|M_SCRNREL,a4		;DMA flags
	clr	a5				;object ID
	clr	a6				;x vel
	clr	a7				;y vel
	calla	BEGINOBJ2
	rets


**********
 SUBRP	#update_meter

	move	*a13(DISPLAY_VAL),a0
	add	a0,a7
	srl	1,a7
	move	a7,*a13(DISPLAY_VAL)
	move	a7,a1

	neg	a1
	addi	GETUP_SIZE,a1
	jrp	#ok
	clr	a1
#ok	movi	GETUP_SIZE,a0
	cmp	a0,a1				;meter can't be taller
	jrle	#ok2				;than GETUP_SIZE pixels
	move	a0,a1
#ok2	move	*a13(IPTR_GREEN),a8,L

	MOVI	GETUP_SIZE,A2
	SUB	A1,A2
	MOVE	A2,*A8(OSIZEY)
	MOVI	RECVRBLK,A0
	MOVE	*A0(ICTRL),A5
	SRL	12,A5
	MOVE	A1,A3
	MPYU	A5,A3
	MOVE	*A0(ISIZEX),A5
	MPYU	A5,A3
	MOVE	*A0(ISAG),A0,L
	ADD	A3,A0
	MOVE	A0,*A8(OSAG),L

	rets

#*****************************************************************************
*
*	a0  = # ticks to add
*	a13 = * wrestler process

 SUBR	inc_getup_time

	PUSH	a14
	move	*a13(plyr_meter_time),a14
	cmpi	20,a14
	jrlt	#exit
	add	a0,a14
	move	a14,*a13(plyr_meter_time)
#exit
	PULL	a14
	rets


;#*****************************************************************************
;*
;* makes your getup meter go away if you've got one out.
;
; SUBR	ditch_getup_meter_a9
;	PUSH	a13
;	move	a9,a13
;	callr	ditch_getup_meter
;	PULL	a13
;	rets
;
; SUBR	ditch_getup_meter
;
;	move	*a13(GETUP_TIME),a0
;	jrz	#cont
;	move	*a13(PLYR_DIZZY),a0
;	jrnz	#cont
;
;;This guy has a getup meter on screen and is running out of control!
;;Cause getup meter to slide off screen.
;
;	move	*a13(METER_PROC),a0,L
;	jrz	#cont		;skip if we don't have a meter.
;	PUSH	a8,a9,a10
;	move	*a0(PA8),a8,L
;	move	*a0(PA9),a9,L
;	move	*a0(PA10),a10,L
;	movi	GETUP_PID,a1
;	movi	slide_offscr,a7
;	calla	XFERPROC
;	PULL	a8,a9,a10
;
;#cont	rets  





;********************************
;* Spark from flaming ball (Process)
;* A8/A11=*Ball obj
;
; SUBR	ball_spark
;
;	movi	spark_l,a9
;
;	move	*a11(OXVEL),a6,L
;	sra	2,a6
;	movk	>a,a0
;	callr	rnd
;	subk	5,a0
;	sll	14,a0			;XVel
;	add	a0,a6
;
;;	movk	3,a0
;;	callr	rnd
;;	jrnz	#xnorm
;;	sll	2,a6			;*4
;#xnorm
;
;	move	*a11(OYVEL),a7,L
;	movk	>3,a0
;	callr	rnd
;	sll	16,a0			;YVel
;	neg	a0
;	add	a0,a7
;
;
;;	move	*a11(OYVEL),a7,L
;;	sra	2,a7
;;	movk	>a,a0
;;	callr	rnd
;;	subk	5,a0
;;	sll	15,a0			;YVel
;;	add	a0,a7
;;	neg	a7
;;
;;	movk	3,a0
;;	callr	rnd
;;	jrnz	#ynorm
;;	sll	2,a7			;*4
;#ynorm
;	move	*a8(OZPOS),a3
;	movk	3,a0
;	callr	rnd
;	subk	2,a0
;	add	a0,a3			;-2 to 1
;
;	move	*a8(OXPOS),a0
;;	move	*a8(OSIZEX),a2
;;	srl	1,a2			;/2
;;	add	a2,a0
;	move	*a8(OXANI+16),a2
;	add	a2,a0
;	move	*a8(OYPOS),a1
;	move	*a8(OSIZEY),a2
;	srl	1,a2			;/2
;	add	a2,a1
;
;	sll	16,a0
;	sll	16,a1
;	movi	spark1,a2
;	movi	DMAWNZ|M_3D|M_NOSCALE,a4
;	movi	CLSDEAD,a5
;	calla	BEGINOBJ2
;
;	move	*a11(OZVEL),a2,L
;	sra	2,a2			;/4
;	movk	>f,a0
;	callr	rnd
;	subk	7,a0
;	sll	14,a0
;	add	a0,a2
;	move	a2,*a8(OZVEL),L
;
;
;	movk	3,a11
;;	callr	rnd
;;	addk	1,a0
;;	move	a0,a11
;	jruc	#strt
;
;#lp	dsj	a10,#noani
;#strt
;	move	a11,a10
;	move	*a9,a0,L
;	jrz	#die			;noani
;	addk	32,a9
;
;	move	*a8(OCTRL),a1
;	calla	obj_aniq
;#noani
;	SLEEPK	3
;	move	*a8(OYVEL),a2,L
;	addi	GRAV*2,a2
;	move	a2,*a8(OYVEL),L
;	jrn	#lp			;Going up?
;	move	*a8(OYVAL),a1,L
;	jrlt	#lp			;Above gnd?
;	clr	a1
;	move	a1,*a8(OYVAL),L
;
;;	move	@HCOUNT,a14
;;	sll	32-2,a14
;;	jrz	#die
;;	neg	a2
;;	sra	3,a2
;;	move	a2,*a8(OYVEL),L
;;	cmpi	-(GRAV*2),a2
;;	jrlt	#lp
;;
;
;#die
;	clr	a0
;	move	a0,*a8(OXVEL),L
;	move	a0,*a8(OYVEL),L
;	move	a0,*a8(OZVEL),L
;;	SLEEPK	4
;
;	jauc	DELOBJDIE
;
;
;spark_l
;	.long	spark1
;	.long	spark2
;	.long	spark3
;	.long	spark4
;	.long	spark5
;	.long	spark1
;	.long	spark2
;	.long	spark3
;	.long	spark4
;	.long	spark5
;	.long	spark1
;	.long	spark2
;	.long	spark3
;	.long	spark4
;	.long	spark5,0

;	.endif

;	movi	STATIC_p,a8
;	movi	cycram,a9
;	movi	[1,62],a10		;1st,last color
;	movk	5,a11			;Rate
;	CREATE	CYCPID,COLCYC

;---------------------------------------

	.if	0		;vid clips .if 0

	jruc	#x			;Skip clips for ROMKIT

	calla	READ_DIP
	btst	DPNOVIDCLIPS_B,a0
	jrnz	#x			;Clips off?


	calla	system_savegame

	movi	>12345678,a0
	move	a0,@clipsrunning,L


	movk	INPLYRINFO,a0
	move	a0,@GAMSTATE

	clr	a0
	move	a0,@dtype		;2D

	move	a0,@WORLDTLX,L
	move	a0,@WORLDTLY,L

	JSRP	scrn_scaleininit

	movi	half_mod,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1
	SLEEPK	2

	JSRP	scrn_scalein

;	movi	4<<10+4<<5+4,a0
	clr	a0
	move	a0,@IRQSKYE		;background color


	CREATE0	plyr_jscrowdsnda

	SLEEPK	10

;	SOUND1	report_snd

	movi	-1,a0
	move	a0,@dpageflip		;No erasure

#test
	movk	2,a5			;# clips to show
	clr	a6
#lp
	move	a6,a0
	addk	1,a6
	sll	5,a0
	addi	#xy_t,a0
	move	*a0+,a10,L		;XY

	move	@clipbits,a2,L
	cmpi	>3ffff,a2		;18 bits
	jrlo	#ok
	clr	a2
#ok
#crlp	movk	18-1,a0			;Total # clips
	calla	RNDRNG0
	btst	a0,a2
	jrnz	#crlp			;Have already shown?

	movk	1,a14			;Set bit
	sll	a0,a14
	or	a14,a2
	move	a2,@clipbits,L

	.if	CLIPTEST
	clr	a0
	.endif

	sll	5,a0
	addi	#mv_t,a0
	move	*a0,a8,L

	clr	a9
	PUSHP	a5,a6
	PUSHP	a8

	move	a10,a0
	sll	32-12,a0
	srl	7,a0			;X
	move	a10,a1
	srl	12,a1
	sll	16,a1			;Y
	movi	scobars,a2
	movi	500,a3			;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	SLEEPK	30
	calla	DELOBJA8

	PULLP	a8
	PUSHP	a10

	.ref	movie_run

	JSRP	movie_run
	PULLP	a10

	PULLP	a5,a6

	dsj	a5,#lp

	.if	CLIPTEST
	jruc	#test			;Infinite loop
	.endif

	movi	TSEC*1+30,a10
#butlp
	SLEEPK	1
	.ref	get_all_buttons_cur
	calla	get_all_buttons_cur
	move	a0,a0
	jrnz	#exit1
	dsj	a10,#butlp
#exit1

	calla	display_blank

	clr	a0
	move	a0,@clipsrunning,L

	calla	system_restoregame

#x	RETP


plyr_jscrowdsnda
	CREATE0	scrms
	SLEEP	40
	SOUND1	cheer1_snd
	SOUND1	cheer2_snd
	SLEEP	35
	SOUND1	cheer1_snd
	SOUND1	cheer2_snd
;	SLEEP	24
;	SOUND1	cheer1_snd
;	SOUND1	cheer2_snd
	DIE

scrms
	SOUND1	scrm1_snd
	SLEEP	15
	SOUND1	scrm2_snd
	SLEEP	15
	SOUND1	scrm3_snd
	SLEEP	15
	SOUND1	scrm4_snd
	SLEEP	15
	DIE

	.ref	scrm1_snd,scrm2_snd,scrm3_snd,scrm4_snd


half_mod
	.long	htclipsBMOD
	.word	0,0
	.long	0

#xy_t	.long	(88+52*512)*8
;	.long	(212+52*512)*8
;	.long	(88+140*512)*8
	.long	(212+140*512)*8
#mv_t
	.long	V4C_F
	.long	V5C_F
	.long	V6C_F
	.long	V8C_F
	.long	V10C_F
	.long	V11C_F
	.long	V13C_F
	.long	V14C_F
	.long	V15C_F
	.long	V17C_F
	.long	V18C_F
	.long	V19C_F
	.long	V20C_F
	.long	V22C_F
	.long	V23C_F
	.long	VNEW2_F
	.long	V1C_F
	.long	V3C_F

;	.long	V7C_F
;	.long	VNEW1_F


	.endif			;vid clips .if 0

;--------------------

	.if	0		;plyr smoketrail .if 0

#*******************************
* Smoke trail (Process)
* A8=*Src obj
* A10=*Plyr process

 SUBR	plyr_smoketrail

	movk	15,a11
#lp	CREATE0	plyr_smokepuff
	SLEEPK	4
	dsj	a11,#lp

	DIE

#*******************************
* Smoke trail (Process)
* A8=*Src obj
* A10=*Plyr process

 SUBR	plyr_smoketrail2

	movk	20,a11
#lp	CREATE0	plyr_smokepuff
	SLEEPK	1
	dsj	a11,#lp

	DIE


#*******************************
* Smoke trail puff (Process)
* A8=*Src obj
* A10=*Plyr process

 SUBRP	plyr_smokepuff

	move	*a10(plyr_dir),a10
	srl	2,a10

	move	*a8(OZPOS),a3
	movk	3,a0
	callr	rnd
	subk	2,a0
	add	a0,a3			;-2 to 1

	movk	3,a0
	callr	rnd
	sll	5,a0			;*32
	addi	smoke_t,a0
	move	*a0,a9,L

	move	*a8(OXVEL),a6,L
	move	*a8(OYVEL),a7,L
	sra	2,a6			;/4
	sra	2,a7

	move	*a8(OXPOS),a0
	move	*a8(OSIZEX),a2
	srl	1,a2			;/2
	add	a2,a0
	move	*a8(OYPOS),a1
	move	*a8(OSIZEY),a2
	srl	1,a2			;/2
	add	a2,a1
	sll	4,a10			;*16
	addi	mslstxy_t,a10
	move	*a10(8*16),a2
	add	a2,a0			;+X offset
	move	*a10,a2
	add	a2,a1			;+YO
	sll	16,a0			;X
	sll	16,a1			;Y
	movi	CLDB1ORNG,a2
	movi	DMAWNZ|M_3D|M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5
	calla	BEGINOBJ2
	movi	scale50_t,a0
	move	a0,*a8(ODATA_p),L
	SLEEPK	3
	jauc	FRQDELDIE

mslstxy_t
	.word	12,12,11,10,8,6,3,1		;Y
	.word	0,-1,-3,-6,-8,-10,-11,-12	;X
	.word	-12,-12,-11,-10,-8,-6,-3,-1
	.word	0,1,3,6,8,10,11,12
	.word	12,12,11,10,8,6,3,1

	.endif			;plyr smoketrail .if 0

;---------------------------------------

	 .if 0	;NOP out free throw, plyr alignment dots

#*******************************
* Control players for free throws (Process)
* A11=Team who scored (0=2, !0=1)

	STRUCTPD
	WORD	pft_pball	;Plyr # (0-3) who gets ball
	WORD	pft_pball2	;P# who gets ball passed to him
	APTR	pft_bbobj	;*Backboard/crowd object


 SUBR	plyr_freethrow

	jruc	plyr_takeoutball

	movi	TSEC,a10		;>Let shot finish
#lp	movi	-1,a0
	move	a0,@ballpnum
	SLEEPK	1
	dsj	a10,#lp


	movi	[20,0],a0
	movi	[20,0],a1
;	movi	ftbackbd,a2
	movi	[500,0],a3		;Z
	movi	DMAWNZ|M_NOCOLL|M_SCRNREL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	move	a8,*a13(pft_bbobj),L


	movk	1,a0
	callr	plyr_setac

	clr	a2
	movk	2,a9			;A9=1st p# of team on defense
	movi	plyrproc_t,a0
	move	a11,a11
	jrz	#t1
	movk	2,a2
	clr	a9
	addi	32*2,a0
#t1
	move	*a0+,a8,L		;A8=*Proc of plyr who gets ball
	move	*a0+,a7,L
	move	*a8(plyr_balldist),a0
	move	*a7(plyr_balldist),a1
	cmp	a1,a0
	jrle	#1st			;Closer?
	move	a7,a8
	addk	1,a2			;2nd in team
#1st
	move	a2,*a13(pft_pball)
	XORK	1,a2
	move	a2,*a13(pft_pball2)


	movi	TSEC*4,a10		;>Get ball

#gblp
	movi	-1,a0
	move	a0,@ballpnum
	SLEEPK	1

	callr	plyrtob_moveo3

	move	@ballobj_p,a3,L
	move	*a3(OXPOS),a0
	addk	6,a0
	move	*a3(OZPOS),a1
	move	*a13(pft_pball),a2
	callr	plyrtob_seekxy

	move	@ballpnum,a0
	jrn	#gbcnt
	cmp	a0,a2
	jreq	#gotball

#gbcnt	dsj	a10,#gblp

#gotball
	move	*a13(pft_pball),a0
	move	a0,@ballpnum


	movi	TSEC*3,a10		;>Run out of bounds

#outlp
	SLEEPK	1

	callr	plyrtob_moveo3

	movi	-370,a0
	move	a11,a11
	jrz	#outl			;Team2 on def
	neg	a0
#outl	addi	WRLDMID,a0
	move	a0,a3
	movi	CZMID-20,a1
	move	*a13(pft_pball),a2
	callr	plyrtob_seekxy
	jrz	#outofb

;	move	*a8(PA8),a2,L		;Get * obj
;	move	*a2(OXPOS),a0
;	move	*a2(OXANI+16),a14
;	add	a14,a0
;	abs	a0
;	abs	a3
;	sub	a0,a3
;	subk	20,a3
;	jrlt	#outofb

	dsj	a10,#outlp

#outofb
	movi	TSEC*3,a10		;>Wait for other 3 to get in place

#wtlp	SLEEPK	1
	callr	plyrtob_moveo3
	jrz	#inpos
	dsj	a10,#wtlp
#inpos

	move	*a13(pft_pball),a10	;>Pass with turbo
	sll	4,a10			;*16
	addi	P1CTRL,a10
	movi	>60,a0
	move	a0,*a10

	SLEEPK	10
	clr	a0
	move	a0,*a10

	SLEEP	40

	clr	a0
	callr	plyr_setac

	move	*a13(pft_bbobj),a0,L
	calla	DELOBJ

	DIE


********************************
* Start an alignment dot for a player
* A13=*Plyr proc
* Trashes scratch

 SUBRP	plyr_getgndaligndot

	PUSH	a2,a3,a4,a5,a6,a7,a8

	clr	a0			;X
	clr	a1			;Y
	movi	CZMIN,a3		;Z
	movi	#alignimg_t,a2
	movi	>800c|M_NOCOLL|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	movi	>101,a0
	move	a0,*a8(OCONST)
	movi	-300,a0
	move	a0,*a8(OMISC)		;Z offset

	move	a8,*a13(plyr_aligndot_p),L

	PULL	a2,a3,a4,a5,a6,a7,a8
	rets


********************************
* Set alignment dot to players position
* A8=*Plyr obj
* A13=*Plyr proc
* Trashes scratch

 SUBRP	plyr_setgndaligndot

	PUSH	a2,a3,a4,a5,a6,a7

	callr	anipt_getsclxy
	move	*a8(OXVAL),a14,L
	add	a14,a0
	move	*a13(plyr_aligndot_p),a2,L
	move	a0,*a2(OXVAL),L

	move	*a8(OZPOS),a14
	addi	300,a14
	move	a14,*a2(OZPOS)

	PULL	a2,a3,a4,a5,a6,a7
	rets

	.endif

;---------------------------------------

	.if 0	;NOP out board shatter, shards

#*******************************
* Shatter backboard (Process)

 SUBRP	board_shatter

;FIX!!!
	DIE

	SOUND1	explode_snd

	SOUND1	ohmy

	CREATE0	board_glssnd
	movk	10,a1
	move	a1,*a0(PTIME)

	move	@ballpnumshot,a11
	movk	10,a8
	move	a11,a0
	subk	2,a0
	jrnz	#n0
	addk	1,a0
#n0	move	a0,@bbshatter
#shlp
	movk	13,a2
#shlp2	CREATE0	board_shard
	dsj	a2,#shlp2
	SLEEPK	1
	dsj	a8,#shlp

	DIE

board_glssnd
;Turmell
	SLEEPK	10
	SOUND1	explode_snd
	SLEEPK	20
	SOUND1	glass_snd
	DIE

********************************
* Flying shard of glass (Process)
* A11=Plyr # who shot the ball (0-3)

	STRUCTPD
	APTR	shd_ani1st_p	;*1st ani_l pos

 SUBRP	board_shard

	movk	10,a0
	callr	rndrng0
	sll	5,a0			;*32
	addi	#shard_t,a0
	move	*a0,a9,L
	move	*a9+,a0,L
	PUSHP	a0
	move	a9,*a13(shd_ani1st_p),L

	movk	>f,a0
	callr	rnd
	subk	5,a0
	move	a0,a6
	sll	13,a6			;XVel

	movk	3,a0
	callr	rnd
	jrnz	#xnorm
	sll	2,a6			;*4
#xnorm
	movk	>f,a0
	callr	rnd
	subk	6,a0
	move	a0,a7
	sll	14,a7			;YVel

	movk	3,a0
	callr	rnd
	jrnz	#ynorm
	sll	2,a7			;*4
#ynorm

	movi	36,a0
	callr	rndrng0
	move	a0,a1
	neg	a1			;Y offset

	movi	HOOPLX-13,a0
	subk	2,a11
	jrge	#p23
	movi	HOOPRX+13,a0
	neg	a6
#p23
	sll	16,a0
	addi	HOOPY,a1
	sll	16,a1
	movi	shard1_1,a2
	movi	CZMID,a3
	movi	DMAWNZ|M_3D|M_NOSCALE,a4
	movi	CLSDEAD,a5
	calla	BEGINOBJ2

	movk	7,a0
	callr	rnd
	subk	4,a0
	sll	16,a0
	move	a0,*a8(OZVEL),L

	movk	1,a0
	callr	rnd
	addk	1,a0
	move	a0,a11
	jruc	#strt

#lp	dsj	a10,#noani
#strt
	move	a11,a10
;	move	*a9+,a10
;	jrz	#x
	move	*a9+,a0,L
	jrnz	#ani
	move	*a13(shd_ani1st_p),a9,L
	move	*a9+,a0,L
#ani
	move	*a8(OCTRL),a1
	calla	obj_aniq
#noani
	SLEEPK	1
	move	*a8(OYVEL),a2,L
	addi	GRAV,a2
	move	a2,*a8(OYVEL),L
	jrn	#lp			;Going up?
	move	*a8(OYVAL),a1,L
	jrlt	#lp			;Above gnd?
	clr	a1
	move	a1,*a8(OYVAL),L
	move	@HCOUNT,a14
	sll	32-2,a14
	jrz	#shatter
	neg	a2
	sra	2,a2
	move	a2,*a8(OYVEL),L
	cmpi	-(GRAV*2),a2
	jrlt	#lp

#shatter
	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OYVEL),L
	move	a0,*a8(OZVEL),L

;	movk	3,a0
;	callr	rnd
;	sll	5,a0			;*32
;	addi	#shat_t,a0
;	move	*a0,a9,L
	PULLP	a9
	movk	3,a10
	jruc	#strt2

#lp2
;	dsj	a10,#noani2
;	movk	2,a10
	move	*a8(OCTRL),a1
	calla	obj_aniq
#noani2
	SLEEPK	1
#strt2	move	*a9+,a0,L
	jrnz	#lp2


	jauc	DELOBJDIE


#shard_t
	.long	s1_t,s2_t,s3_t,s4_t,s5_t,s6_t,s7_t,s8_t
	.long	s1_t,s6_t,s8_t

s1_t
	.long	st4_t
	.long	shard1_1
	.long	shard1_2
	.long	shard1_3
	.long	shard1_4
	.long	shard1_5
	.long	shard1_6
	.long	shard1_7
	.long	shard1_8
	.long	0
s2_t
	.long	st3_t
	.long	shard2_1
	.long	shard2_2
	.long	shard2_3
	.long	shard2_4
	.long	shard2_5
	.long	shard2_6
	.long	shard2_7
	.long	shard2_8
	.long	0
s3_t
	.long	st2_t
	.long	shard3_1
	.long	shard3_2
	.long	shard3_3
	.long	shard3_4
	.long	shard3_5
	.long	shard3_6
	.long	shard3_7
	.long	shard3_8
	.long	shard3_9
	.long	shard3_10
	.long	shard3_11
	.long	shard3_12
	.long	0
s4_t
	.long	st1_t
	.long	shard4_1
	.long	shard4_2
	.long	shard4_3
	.long	shard4_4
	.long	shard4_5
	.long	shard4_6
	.long	shard4_7
	.long	shard4_8
	.long	shard4_9
	.long	shard4_10
	.long	0
s5_t
	.long	st2_t
	.long	shard5_1
	.long	shard5_2
	.long	shard5_3
	.long	shard5_4
	.long	shard5_5
	.long	shard5_6
	.long	shard5_7
	.long	shard5_8
	.long	0
s6_t
	.long	st4_t
	.long	shard6_1
	.long	shard6_2
	.long	shard6_3
	.long	shard6_4
	.long	shard6_5
	.long	shard6_6
	.long	shard6_7
	.long	shard6_8
	.long	0
s7_t
	.long	st2_t
	.long	shard7_1
	.long	shard7_2
	.long	shard7_3
	.long	shard7_4
	.long	shard7_5
	.long	shard7_6
	.long	shard7_7
	.long	shard7_8
	.long	shard7_9
	.long	shard7_10
	.long	0
s8_t
	.long	st4_t
	.long	shard8_1
	.long	shard8_2
	.long	shard8_3
	.long	shard8_4
	.long	shard8_5
	.long	shard8_6
	.long	shard8_7
	.long	shard8_8
	.long	shard8_9
	.long	shard8_10
	.long	0

;#shat_t
;	.long	st1_t,st2_t,st3_t,st4_t
st1_t	.long	shat1_1
	.long	shat1_2
	.long	shat1_3
	.long	shat1_4
	.long	shat1_5
	.long	0
st2_t	.long	shat2_1
	.long	shat2_2
	.long	shat2_3
	.long	shat2_4
	.long	shat2_5
	.long	0
st3_t	.long	shat3_1
	.long	shat3_2
	.long	shat3_3
	.long	shat3_4
	.long	shat3_5
	.long	0
st4_t	.long	shat4_1
	.long	shat4_2
	.long	shat4_3
	.long	shat4_4
	.long	shat4_5
	.long	0

	.endif

;---------------------------------------


	.end
