**************************************************************
*
* Owner:	TURMELL
*
* Software:		Shawn Liptak, Mark Turmell
* Initiated:		11/20/92
*
* Modified:		Shawn Liptak, 10/5/92	-Split from plyr2.asm
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/13/93 0:55
**************************************************************
	.file	"plyrat.asm"
	.title	"basketball player code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"macros.hdr"		;Macros
	.asg		0,SEQT
	.include	"plyr.equ"

	.include	"imgtblp.glo"
;	.include	"imgpal3.asm"
	.include	"imgtbl.glo"
	.include	"imgtbl1.glo"
	.include	"imgtblm.glo"
	.include	"plyrhd6.glo"
	.include	"plyrhd6a.glo"


;sounds external


;symbols externally defined

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
	.ref	scale77ef_t

	.ref	team1,team2


;From plyrat3.asm
	.ref	sd_h
	.ref	jeff_h
	.ref	dan_h	
	.ref	carym_h
	.ref	eug_h
	.ref	bud_h
	.ref	jhey_h
	.ref	jfer_h
	.ref	jcartn
	.ref	nicke_h
	.ref	jroot_h
	.ref	bardo_h
	.ref	willy_h
	.ref	mxv_h
	.ref	eddie_h
	.ref	min_h
	.ref	quinn_h
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
	.ref	DEllis_h
	.ref	Elliot_h
	.ref	Hardaway_h
	.ref	DHarper_h
	.ref	HCGrant_h
	.ref	Hornacek_h
	.ref	Manning_h

;From plyr3.asm
	.ref	Gug_h		
	.ref	BEdwrds_h
	.ref	Brown_h
	.ref	KAnderson_h
	.ref	Willis_h
	.ref	Mourn_h
	.ref	Kukoc_h
	.ref	Jack_h	
	.ref	Mash_h	
	.ref	Dumars_h
	.ref	Rodman_h
	.ref	Webber_h
	.ref	Horry_h
	.ref	Smits_h
	.ref	Campbell_h
	.ref	Baker_h
	.ref	Rider_h
	.ref	Morris_h
	.ref	Mason_h
	.ref	Starks_h
	.ref	AHard_h
	.ref	NAnders_h
	.ref	Weath_h
	.ref	Brad_h
	.ref	KJohn_h
	.ref	CRobinson_h
	.ref	Rich_h
	.ref	DEllis_h
	.ref	Payton_h
	.ref	Mckey_h
	.ref	Benoit_h
	.ref	Cheaney_h

	.ref	Robertson_h
	.ref	Chapman_h
	.ref	Lang_h
	.ref	Scott_h
	.ref	Webb_h
;	.ref	MJohnson_h
	.ref	Ruffin_h
	.ref	roan_h
	.ref	turmel_h
	.ref	jamie_h
	.ref	patf_h
	.ref	mperry_h
	.ref	neilf_h
	.ref	mdoc_h
	.ref	Old_h
	.ref	Wiz_h
	.ref	edboon_h
	.ref	jtobias_h
	.ref	oursler_h
	.ref	marty_h
	.ref	carlos_h
	.ref	jason_h

;symbols refined in this file

;	.def	EB_H,JTO_H	;RA_H
	.def	spechds_t
	.def	ATL_t
	.def	DEFAULT_t

;	.def	lighten1
;	.def	lighten2
;	.def	lighten3
;	.def	lighten4
;	.def	lighten5
;	.def	lighten6
;	.def	lighten7

	.global	BV,BV1,BV2,BV3,BV4,BV5,BV6,BV7,BV8,BV9,BV10
	.global	SHT0,SHT1,SHT2,SHT3,SHT4,SHT5,SHT6,SHT7,SHT8,SHT9,SHT10,SHT11
	.global	DNK0,DNK1,DNK2,DNK3,DNK4,DNK5,DNK6,DNK7,DNK8,DNK9,DNK10
	.global	DEF0,DEF1,DEF2,DEF3,DEF4,DEF5,DEF6,DEF7,DEF8,DEF9,DEF10
	.global	SDEF0,SDEF1,SDEF2,SDEF3,SDEF4,SDEF5,SDEF6,SDEF7,SDEF8,SDEF9,SDEF10


;uninitialized ram definitions

	BSSX	created_plyr1_attrib_tables,496   ;sizeof ATL_t in plyrat.asm
	BSSX	created_plyr2_attrib_tables,496
	BSSX	created_plyr3_attrib_tables,496
	BSSX	created_plyr4_attrib_tables,496   ;sizeof ATL_t in plyrat.asm

;	BSSX	created_plyr1_attrib_tables,PLYRAT_TBL_SIZE	
;	BSSX	created_plyr2_attrib_tables,PLYRAT_TBL_SIZE
;	BSSX	created_plyr3_attrib_tables,PLYRAT_TBL_SIZE
;	BSSX	created_plyr4_attrib_tables,PLYRAT_TBL_SIZE

;equates for this file



	.text


GrantG_F:
	.word	 53
	.word	00H,07293H,07292H,06E52H,06E50H,06630H,0662FH,0662FH
	.word	0620FH,0620EH,05E0FH,05E0EH,05DCEH,05DCCH,05DCBH,059CCH
	.word	05DABH,055ABH,051ABH,0518BH,05169H,04D6BH,05168H,04D69H
	.word	05169H,05168H,04949H,04948H,04949H,04D45H,04948H,04927H
	.word	04508H,04507H,04505H,04505H,03CE7H,040E4H,03CE5H,03CE5H
	.word	034E8H,03CC6H,034C6H,038C4H,034A4H,030A4H,03484H,03083H
	.word	02C84H,02C63H,02843H,02423H,02023H

GRANTG_P:
	.word	 64
	.word	03E0H,040E5H,030A3H,02C83H,02443H,01C21H,02863H,034C5H
	.word	038A3H,04D04H,04506H,04D48H,05168H,05546H,04927H,0516BH
	.word	04529H,03D07H,03CE4H,02421H,01001H,05125H,03462H,04505H
	.word	0558BH,04D47H,05988H,055ADH,059CCH,065CAH,05DABH,06231H
	.word	069EAH,01C22H,01022H,061EDH,05E0EH,07E71H,02C84H,030A5H
	.word	01824H,06E2FH,038A4H,040A3H,07671H,06A71H,05881H,01809H
	.word	01891H,02556H,01C6FH,07A0H,072B7H,0565CH,076B3H,0E65H
	.word	010B6H,03113H,07F1AH,0D84H,051F5H,056DFH,041B4H,0B01H

Horna_f:
	.word	 53
	.word	00H,07F59H,07F57H,07F37H,07F34H,07EF5H,07EF3H,07EF3H
	.word	07EB3H,07EB1H,07EB3H,07EB1H,07E71H,07E6FH,07E6DH,07E6FH
	.word	07E4EH,07A2DH,0762DH,0760EH,071EBH,06DEDH,071E9H,06DEBH
	.word	071CAH,071C9H,069ABH,069A9H,065ABH,06DA5H,065A9H,06987H
	.word	06169H,06167H,06165H,06145H,05927H,05D23H,05925H,05525H
	.word	04D29H,05506H,04D06H,050E3H,04CC4H,044C4H,048A3H,04482H
	.word	04084H,03C62H,03842H,03422H,03002H

HORNA_P:
	.word	 60
	.word	04010H,07EF3H,07EB3H,07EB2H,07E6FH,07E2DH,07E0CH,07DEBH
	.word	07DCAH,0760CH,075CAH,071EBH,075A9H,06DC9H,06988H,065A9H
	.word	06966H,06188H,06566H,05DA9H,06167H,05D67H,05945H,05565H
	.word	0516AH,0498BH,05525H,05504H,04D45H,04D24H,058A1H,04524H
	.word	03549H,048E3H,03528H,03906H,03106H,03CA1H,02CE7H,028E5H
	.word	024C6H,028A3H,020A5H,020A4H,03400H,01C84H,02042H,01863H
	.word	01C42H,01463H,01C40H,01442H,01821H,0C00H,01400H,0C01H
	.word	0C00H,0400H,0801H,0800H

Manning_f:
	.word	 53
	.word	00H,0724FH,0724EH,06E0EH,06E0CH,065ECH,065EBH,065EBH
	.word	061CBH,061CAH,05DCBH,05DCAH,05D8AH,05D88H,05D87H,05988H
	.word	05D67H,05567H,05167H,05147H,05125H,04D27H,05124H,04D25H
	.word	05125H,05124H,04905H,04904H,04905H,04D01H,04904H,048E3H
	.word	044C4H,044C3H,044C1H,044C1H,03CA3H,040A0H,03CA1H,03CA1H
	.word	034A4H,03C82H,03482H,03880H,03460H,03060H,03440H,03040H
	.word	02C40H,02C20H,02800H,02400H,02000H

MANNING_P:
	.word	 64
	.word	03E0H,01C20H,03061H,030A3H,030E6H,02CC6H,040E5H,03C8BH
	.word	01800H,01000H,071C9H,04D48H,044E4H,03CC4H,05104H,02400H
	.word	02840H,03CC3H,03882H,03082H,02C40H,04906H,061ECH,02862H
	.word	06189H,05946H,048C4H,038A3H,02463H,05967H,04925H,02063H
	.word	068CEH,065ECH,048E3H,0C00H,01C00H,0598BH,06188H,04504H
	.word	030C5H,0764EH,061CBH,02484H,0720DH,05546H,03507H,07A93H
	.word	01822H,07E0H,01400H,06CC8H,02041H,01C43H,0504BH,01C84H
	.word	028E8H,028A6H,02084H,028A5H,04006H,05611H,041D0H,03543H

	.def	OFFNBA_P
OFFNBA_P:
	.word	 64
	.word	01565H,00H,074H,095H,0B6H,0F6H,0136H,04D5H
	.word	0842H,0CF6H,0D36H,0C63H,01516H,01537H,014A5H,01977H
	.word	018C6H,021B7H,02529H,031F9H,0318CH,035ADH,03DEFH,03E59H
	.word	04210H,0425AH,04A52H,04E73H,05294H,056DBH,056B5H,05AD6H
	.word	05AFCH,05EF7H,06739H,06B5DH,06F7BH,06F9DH,0739CH,0739DH
	.word	077BDH,07401H,07404H,07423H,07444H,077BEH,07BDEH,07802H
	.word	078A6H,07909H,0792AH,0796CH,079EFH,07A11H,07A73H,07A95H
	.word	07FFFH,07F59H,07F7CH,07FBDH,07FFEH,02DH,05C23H,03401H


;Speeds

;These have been reduced from TE!  Used to be >1040
;BV	.equ	>1040->80+>42*1

BV	.equ	>1040->80+>42*1
BV1	.equ	>1040->80+>42*2
BV2	.equ	>1040->80+>42*3
BV3	.equ	>1040->80+>42*4
BV4	.equ	>1040->80+>42*5
BV5	.equ	>1040->80+>42*6
BV6	.equ	>1040->80+>42*7
BV7	.equ	>1040->80+>42*8
BV8	.equ	>1040->80+>42*10+>20
BV9	.equ	>1040->80+>42*11+>30
BV10	.equ	>1040->80+>42*12+>40

;Drone skills
DSKL0	.equ	0
DSKL1	.equ	1
DSKL2	.equ	2
DSKL3	.equ	3
DSKL4	.equ	4
DSKL5	.equ	5
DSKL_1	.equ	-1
DSKL_2	.equ	-2
DSKL_3	.equ	-3
DSKL_4	.equ	-4
DSKL_5	.equ	-5
DSKL_6	.equ	-6
DSKL_7	.equ	-7
DSKL_8	.equ	-8
DSKL_9	.equ	-9
DSKL_10	.equ	-10
DSKL_11	.equ	-11

;Shot skill %
;SHT0	.equ	890		;890
;SHT1	.equ	910		;910
;SHT2	.equ	960		;960
;SHT3	.equ	980		;980
;SHT4	.equ	1000		;1000
;SHT5	.equ	1020		;1020
;SHT6	.equ	1040		;1040
;SHT7	.equ	1060
;SHT8	.equ	1070
;SHT9	.equ	1090
;SHT10	.equ	1150

;12/15/93
;SHT0	.equ	820		;890
;SHT1	.equ	840		;910
;SHT2	.equ	890		;960
;SHT3	.equ	930		;980
;SHT4	.equ	1020		;1000
;SHT5	.equ	1040		;1020
;SHT6	.equ	1060		;1040
;SHT7	.equ	1080
;SHT8	.equ	1100
;SHT9	.equ	1120
;SHT10	.equ	1150

;12/16/93
;SHT0	.equ	860		;890
;SHT1	.equ	890		;910
;SHT2	.equ	920		;960
;SHT3	.equ	970		;980
;SHT4	.equ	1040		;1000
;SHT5	.equ	1070		;1020
;SHT6	.equ	1080		;1040
;SHT7	.equ	1100
;SHT8	.equ	1130
;SHT9	.equ	1150
;SHT10	.equ	1200
;SHT11	.equ	1201		;MK SPECIAL FLAG

;3/15/96
;SHT0	.equ	820		;890
;SHT1	.equ	840		;910
;SHT2	.equ	890		;960
;SHT3	.equ	930		;980
;SHT4	.equ	1020		;1000
;SHT5	.equ	1040		;1020
;SHT6	.equ	1060		;1040
;SHT7	.equ	1080
;SHT8	.equ	1100
;SHT9	.equ	1120
;SHT10	.equ	1150
;SHT11	.equ	1201		;MK SPECIAL FLAG

;12/16/93
SHT0	.equ	860		;890
SHT1	.equ	890		;910
SHT2	.equ	920		;960
SHT3	.equ	970		;980
SHT4	.equ	1040		;1000
SHT5	.equ	1070		;1020
SHT6	.equ	1080		;1040
SHT7	.equ	1100
SHT8	.equ	1130
SHT9	.equ	1150
SHT10	.equ	1200
SHT11	.equ	1201		;MK SPECIAL FLAG

;Dunk ability
DNK0	.equ	0
DNK1	.equ	1
DNK2	.equ	2
DNK3	.equ	3
DNK4	.equ	4
DNK5	.equ	5
DNK6	.equ	6
DNK7	.equ	7
DNK8	.equ	8
DNK9	.equ	9
DNK10	.equ	10

;Defensive block ability
DEF0	.equ	0
DEF1	.equ	1
DEF2	.equ	2
DEF3	.equ	3
DEF4	.equ	4
DEF5	.equ	5
DEF6	.equ	6
DEF7	.equ	7
DEF8	.equ	8
DEF9	.equ	9
DEF10	.equ	10

;Defensive steal ability
;SDEF0	.equ	180
;SDEF1	.equ	185
;SDEF2	.equ	190		;Old normal
;SDEF3	.equ	195
;SDEF4	.equ	200
;SDEF5	.equ	205
;SDEF6	.equ	210
;SDEF7	.equ	215
;SDEF8	.equ	220
;SDEF9	.equ	225
;SDEF10	.equ	230

;SDEF0	.equ	160
;SDEF1	.equ	170
;SDEF2	.equ	180		;Old normal
;SDEF3	.equ	195
;SDEF4	.equ	200
;SDEF5	.equ	205
;SDEF6	.equ	215
;SDEF7	.equ	245
;SDEF8	.equ	260
;SDEF9	.equ	285
;SDEF10	.equ	300

SDEF0	.equ	0
SDEF1	.equ	1
SDEF2	.equ	2		;Old normal
SDEF3	.equ	3
SDEF4	.equ	4
SDEF5	.equ	5
SDEF6	.equ	6
SDEF7	.equ	7
SDEF8	.equ	8
SDEF9	.equ	9
SDEF10	.equ	10


	.def	ply_city_tbl
;
; This table is used by 'change uniform' in CREATE PLAYER
;
ply_city_tbl
	.long	ATL_t
	.long	BOST_t
	.long	CHAR_t
	.long	CHI_t
	.long	CLEV_t
	.long	DEFAULT_t		;default team
	.long	DAL_t
	.long	DEN_t
	.long	DET_t
	.long	GOLD_t
	.long	HOU_t
	.long	IND_t
	.long	LAC_t
	.long	LAL_t
	.long	MIAMI_t
	.long	MILW_t
	.long	MINN_t
	.long	NJ_t
	.long	NY_t
	.long	ORL_t
	.long	PHIL_t
	.long	PHX_t
	.long	PORT_t
	.long	SAC_t
	.long	SANANT_t
	.long	SEA_t
	.long	TORONTO_t
	.long	UTAH_t
	.long	VANCOU_t
	.long	WASH_t
	.long	CUST_1t
	.long	CUST_2t
	.long	CUST_3t
	.long	CUST_4t
	.long	CUST_5t
	.long	CUST_6t
	.long	CUST_7t
	.long	CUST_8t
	.long	CUST_9t
	.long	CUST_10t

;--------------------
; Table used for bench plyr img palette build

	.def	team_city_tbl

team_city_tbl
	.long	ATL_t,BOST_t,CHAR_t,CHI_t
	.long	CLEV_t,DAL_t,DEN_t,DET_t
	.long	GOLD_t,HOU_t,IND_t,LAC_t
	.long	LAL_t,MIAMI_t,MILW_t,MINN_t
	.long	NJ_t,NY_t,ORL_t,PHIL_t
	.long	PHX_t,PORT_t,SAC_t,SANANT_t
	.long	SEA_t,TORONTO_t,UTAH_t,VANCOU_t
	.long	WASH_t

;MJT Start

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch
ATL_t
	LWWWWWW	scale68t_t,BV8,SHT5,DNK7,DEF2,SDEF6,DSKL0

	;Flesh pal, Primary uniform pal, Alternate uniform pal, Primary
	;trim pal, Alternate trim pal

	.long	Augmon_f, UN_ATLP_P,UN_ATLS_P, TR_ATLP_P,TR_ATLS_P,Augmon_h
	.word	4,3,8

	;Primary swipe pal, Alternate swipe pal, Primary vertical panel pal,
	;Alternate vertical panel pal

	.long	SW_ATLP_P,SW_ATLS_P,VP_ATLP_P,VP_ATLS_P

ATL_tend
	LWWWWWW	scale61_t,BV9,SHT7,DNK0,DEF1,SDEF9,DSKL0
	.long	BLAYLO_F, UN_ATLP_P,UN_ATLS_P, TR_ATLP_P,TR_ATLS_P,Blaylock_h
	.word	7,2,9
	.long	SW_ATLP_P,SW_ATLS_P,VP_ATLP_P,VP_ATLS_P
	LWWWWWW	scale68_t,BV7,SHT8,DNK5,DEF2,SDEF5,DSKL0
	.long	SSMITH_F, UN_ATLP_P,UN_ATLS_P, TR_ATLP_P,TR_ATLS_P,Ssmith_h
	.word	4,5,6
	.long	SW_ATLP_P,SW_ATLS_P,VP_ATLP_P,VP_ATLS_P
	LWWWWWW	scale611_t,BV7,SHT7,DNK3,DEF5,SDEF5,DSKL_10
	.long	laet_f, UN_ATLP_P,UN_ATLS_P, TR_ATLP_P,TR_ATLS_P,Laetner_h
	.word	5,6,8
	.long	SW_ATLP_P,SW_ATLS_P,VP_ATLP_P,VP_ATLS_P
	LWWWWWW	scale68_t,BV7,SHT6,DNK6,DEF5,SDEF4,DSKL0
	.long	KNORMA_F, UN_ATLP_P,UN_ATLS_P, TR_ATLP_P,TR_ATLS_P,Knorman_h
	.word	4,4,2
	.long	SW_ATLP_P,SW_ATLS_P,VP_ATLP_P,VP_ATLS_P


	.def	PLYRAT_TBL_SIZE
PLYRAT_TBL_SIZE	equ	ATL_tend-ATL_t


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

BOST_t	;Done

	LWWWWWW	scale61_t,BV8,SHT5,DNK7,DEF1,SDEF7,DSKL0
;MJT End
	.long	BROWN_F, UN_BOSP_P,UN_BOSS_P, TR_BOSP_P,TR_BOSS_P,Brown_h
	.word	5,2,2
	.long	SW_BOSP_P,SW_BOSS_P,VP_BOSP_P,VP_BOSS_P
	LWWWWWW	scale511_t,BV9,SHT9,DNK1,DEF1,SDEF7,DSKL0
	.long	BARROS_F, UN_BOSP_P,UN_BOSS_P, TR_BOSP_P,TR_BOSS_P,Barros_h
	.word	6,1,5
	.long	SW_BOSP_P,SW_BOSS_P,VP_BOSP_P,VP_BOSS_P
	LWWWWWW	scale70f_t,BV4,SHT3,DNK7,DEF6,SDEF1,DSKL0
	.long	MONTRO_F, UN_BOSP_P,UN_BOSS_P, TR_BOSP_P,TR_BOSS_P,Montross_h
	.word	3,8,3
	.long	SW_BOSP_P,SW_BOSS_P,VP_BOSP_P,VP_BOSS_P
	LWWWWWW	scale611_t,BV7,SHT7,DNK7,DEF9,SDEF7,DSKL0
	.long	RADJA_F, UN_BOSP_P,UN_BOSS_P, TR_BOSP_P,TR_BOSS_P,Radja_h
	.word	1,8,6
	.long	SW_BOSP_P,SW_BOSS_P,VP_BOSP_P,VP_BOSS_P
	LWWWWWW	scale67ef_t,BV5,SHT7,DNK5,DEF5,SDEF8,DSKL0
	.long	FOX_F, UN_BOSP_P,UN_BOSS_P, TR_BOSP_P,TR_BOSS_P,Fox_h
	.word	7,9,7
	.long	SW_BOSP_P,SW_BOSS_P,VP_BOSP_P,VP_BOSS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

CHAR_t
	LWWWWWW	scale61t_t,BV10,SHT6,DNK0,DEF3,SDEF8,DSKL0
	.long	K_AND_F, UN_CHAP_P,UN_CHAS_P, TR_CHAP_P,TR_CHAS_P,KAnderson_h
	.word	9,3,6
	.long	SW_CHAP_P,SW_CHAS_P,VP_CHAP_P,VP_CHAS_P
	LWWWWWW	scale67f_t,BV7,SHT7,DNK8,DEF5,SDEF4,DSKL0   	;Can shatter
	.long	johnson_f, UN_CHAP_P,UN_CHAS_P, TR_CHAP_P,TR_CHAS_P,LJohnson_h
	.word	7,8,8
	.long	SW_CHAP_P,SW_CHAS_P,VP_CHAP_P,VP_CHAS_P
	LWWWWWW	scale68_t,BV7,SHT10,DNK5,DEF2,SDEF6,DSKL_6
	.long	Rice_f, UN_CHAP_P,UN_CHAS_P, TR_CHAP_P,TR_CHAS_P,Rice_h
	.word	2,5,9	
	.long	SW_CHAP_P,SW_CHAS_P,VP_CHAP_P,VP_CHAS_P
	LWWWWWW	scale70f_t,BV3,SHT4,DNK4,DEF7,SDEF2,DSKL0
	.long	ZIDEK_F, UN_CHAP_P,UN_CHAS_P, TR_CHAP_P,TR_CHAS_P,Zidek_h
	.word	3,8,2	
	.long	SW_CHAP_P,SW_CHAS_P,VP_CHAP_P,VP_CHAS_P
	LWWWWWW	scale65_t,BV8,SHT7,DNK1,DEF1,SDEF8,DSKL0
	.long	CURRY_F, UN_CHAP_P,UN_CHAS_P, TR_CHAP_P,TR_CHAS_P,Curry_h
	.word	4,2,7	
	.long	SW_CHAP_P,SW_CHAS_P,VP_CHAP_P,VP_CHAS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

CHI_t
	LWWWWWW	scale67_t,BV8,SHT8,DNK9,DEF8,SDEF9,DSKL5	;Can shatter
	.long	pippin_f, UN_CHIP_P,UN_CHIS_P, TR_CHIP_P,TR_CHIS_P,Pippen_h
	.word	7,6,8	
	.long	SW_CHIP_P,SW_CHIS_P,VP_CHIP_P,VP_CHIS_P
	LWWWWWW	scale68_t,BV7,SHT1,DNK4,DEF7,SDEF4,DSKL1
;	.long	ALIEN_F, UN_CHIP_P,UN_CHIS_P, TR_CHIP_P,TR_CHIS_P,Rodman_h
	.long	RODMAN_F, UN_CHIP_P,UN_CHIS_P, TR_CHIP_P,TR_CHIS_P,Rodman_h
	.word	4,9,3
	.long	SW_CHIP_P,SW_CHIS_P,VP_CHIP_P,VP_CHIS_P
	LWWWWWW	scale611t_t,BV7,SHT7,DNK6,DEF5,SDEF7,DSKL5
	.long	KUKOC_F, UN_CHIP_P,UN_CHIS_P, TR_CHIP_P,TR_CHIS_P,Kukoc_h
	.word	8,5,10
	.long	SW_CHIP_P,SW_CHIS_P,VP_CHIP_P,VP_CHIS_P
	LWWWWWW	scale72f_t,BV5,SHT5,DNK3,DEF7,SDEF2,DSKL5
	.long	LONG_F, UN_CHIP_P,UN_CHIS_P, TR_CHIP_P,TR_CHIS_P,Longley_h
	.word	6,8,2
	.long	SW_CHIP_P,SW_CHIS_P,VP_CHIP_P,VP_CHIS_P
	LWWWWWW	scale63_t,BV6,SHT9,DNK0,DEF1,SDEF6,DSKL5
	.long	KERR_F, UN_CHIP_P,UN_CHIS_P, TR_CHIP_P,TR_CHIS_P,Kerr_h
	.word	4,2,8
	.long	SW_CHIP_P,SW_CHIS_P,VP_CHIP_P,VP_CHIS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

CLEV_t
	LWWWWWW	scale69f_t,BV6,SHT6,DNK6,DEF6,SDEF3,DSKL0
	.long	THILL_F, UN_CLEP_P,UN_CLES_P, TR_CLEP_P,TR_CLES_P,Thill_h
	.word	4,8,7	
	.long	SW_CLEP_P,SW_CLES_P,VP_CLEP_P,VP_CLES_P
	LWWWWWW	scale66_t,BV7,SHT7,DNK3,DEF5,SDEF4,DSKL0
	.long	CMILLS_F, UN_CLEP_P,UN_CLES_P, TR_CLEP_P,TR_CLES_P,Cmills_h
	.word	4,5,2	
	.long	SW_CLEP_P,SW_CLES_P,VP_CLEP_P,VP_CLES_P
	LWWWWWW	scale65_t,BV8,SHT7,DNK1,DEF4,SDEF8,DSKL0
	.long	PHILLS_F, UN_CLEP_P,UN_CLES_P, TR_CLEP_P,TR_CLES_P,Phills_h
	.word	7,5,2	
	.long	SW_CLEP_P,SW_CLES_P,VP_CLEP_P,VP_CLES_P
	LWWWWWW	scale511_t,BV9,SHT8,DNK1,DEF1,SDEF8,DSKL0
	.long	BRAND_F, UN_CLEP_P,UN_CLES_P, TR_CLEP_P,TR_CLES_P,Brandon_h
	.word	7,2,9	
	.long	SW_CLEP_P,SW_CLES_P,VP_CLEP_P,VP_CLES_P
	LWWWWWW	scale610_t,BV4,SHT7,DNK2,DEF2,SDEF5,DSKL3
	.long	FERRY_F, UN_CLEP_P,UN_CLES_P, TR_CLEP_P,TR_CLES_P,Ferry_h
	.word	5,7,8	
	.long	SW_CLEP_P,SW_CLES_P,VP_CLEP_P,VP_CLES_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

DAL_t
	LWWWWWW	scale66_t,BV7,SHT7,DNK5,DEF4,SDEF5,DSKL_11
	.long	JACK_F, UN_DALP_P,UN_DALS_P, TR_DALP_P,TR_DALS_P,Jack_h
	.word	5,4,7	
	.long	SW_DALP_P,SW_DALS_P,VP_DALP_P,VP_DALS_P
	LWWWWWW	scale64_t,BV9,SHT4,DNK5,DEF6,SDEF6,DSKL_11
	.long	KIDD_F, UN_DALP_P,UN_DALS_P, TR_DALP_P,TR_DALS_P,Kidd_h
	.word	8,4,8	
	.long	SW_DALP_P,SW_DALS_P,VP_DALP_P,VP_DALS_P
	LWWWWWW	scale68f_t,BV8,SHT9,DNK8,DEF7,SDEF4,DSKL_11
	.long	MASH_F, UN_DALP_P,UN_DALS_P, TR_DALP_P,TR_DALS_P,Mash_h
	.word	5,3,9	
	.long	SW_DALP_P,SW_DALS_P,VP_DALP_P,VP_DALS_P
	LWWWWWW	scale68f_t,BV5,SHT4,DNK7,DEF6,SDEF4,DSKL_11
	.long	PJONES_F, UN_DALP_P,UN_DALS_P, TR_DALP_P,TR_DALS_P,Pjones_h
	.word	3,8,3	
	.long	SW_DALP_P,SW_DALS_P,VP_DALP_P,VP_DALS_P
	LWWWWWW	scale68_t,BV7,SHT7,DNK5,DEF5,SDEF5,DSKL_11
	.long	MCCLOU_F, UN_DALP_P,UN_DALS_P, TR_DALP_P,TR_DALS_P,McCloud_h
	.word	4,5,2	
	.long	SW_DALP_P,SW_DALS_P,VP_DALP_P,VP_DALS_P


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

DEN_t
	LWWWWWW	scale61_t,BV8,SHT7,DNK0,DEF1,SDEF8,DSKL_7
	.long	RAUF_F, UN_DENP_P,UN_DENS_P, TR_DENP_P,TR_DENS_P,Rauf_h
	.word	8,2,9	
	.long	SW_DENP_P,SW_DENS_P,VP_DENP_P,VP_DENS_P
	LWWWWWW	scale72t_t,BV6,SHT4,DNK8,DEF10,SDEF5,DSKL_7	;Can shatter
	.long	Mutumbo_f, UN_DENP_P,UN_DENS_P, TR_DENP_P,TR_DENS_P,Mutumbo_h
	.word	3,9,7	
	.long	SW_DENP_P,SW_DENS_P,VP_DENP_P,VP_DENS_P
	LWWWWWW	scale69_t,BV7,SHT6,DNK7,DEF7,SDEF5,DSKL_7
	.long	MCDYES_F, UN_DENP_P,UN_DENS_P, TR_DENP_P,TR_DENS_P,Mcdyes_h
	.word	3,1,7	
	.long	SW_DENP_P,SW_DENS_P,VP_DENP_P,VP_DENS_P
	LWWWWWW	scale68_t,BV9,SHT6,DNK6,DEF6,SDEF8,DSKL_7
	.long	ROSE_F, UN_DENP_P,UN_DENS_P, TR_DENP_P,TR_DENS_P,Rose_h
	.word	8,4,9	
	.long	SW_DENP_P,SW_DENS_P,VP_DENP_P,VP_DENS_P
	LWWWWWW	scale67_t,BV7,SHT8,DNK2,DEF1,SDEF6,DSKL_7
	.long	DELLIS_F, UN_DENP_P,UN_DENS_P, TR_DENP_P,TR_DENS_P,DEllis_h
	.word	5,6,8	
	.long	SW_DENP_P,SW_DENS_P,VP_DENP_P,VP_DENS_P


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

DET_t
	LWWWWWW	scale63f_t,BV6,SHT8,DNK0,DEF1,SDEF6,DSKL1
	.long	DUMARS_F, UN_DETP_P,UN_DETS_P, TR_DETP_P,TR_DETS_P,Dumars_h
	.word	8,4,9
	.long	SW_DETP_P,SW_DETS_P,VP_DETP_P,VP_DETS_P
	LWWWWWW	scale68_t,BV9,SHT8,DNK8,DEF5,SDEF8,DSKL1
	.long	GHILL_F, UN_DETP_P,UN_DETS_P, TR_DETP_P,TR_DETS_P,Ghill_h
	.word	8,5,9
	.long	SW_DETP_P,SW_DETS_P,VP_DETP_P,VP_DETS_P
	LWWWWWW	scale610ef_t,BV4,SHT6,DNK2,DEF2,SDEF4,DSKL1
	.long	TMILLS_F, UN_DETP_P,UN_DETS_P, TR_DETP_P,TR_DETS_P,Tmills_h
	.word	5,6,8
	.long	SW_DETP_P,SW_DETS_P,VP_DETP_P,VP_DETS_P
	LWWWWWW	scale610f_t,BV7,SHT5,DNK7,DEF7,SDEF4,DSKL1
	.long	THORPE_F, UN_DETP_P,UN_DETS_P, TR_DETP_P,TR_DETS_P,Thorpe_h
	.word	5,9,2
	.long	SW_DETP_P,SW_DETS_P,VP_DETP_P,VP_DETS_P
	LWWWWWW	scale66_t,BV8,SHT10,DNK2,DEF3,SDEF4,DSKL1
	.long	HOUSTO_F, UN_DETP_P,UN_DETS_P, TR_DETP_P,TR_DETS_P,Houston_h
	.word	5,1,7
	.long	SW_DETP_P,SW_DETS_P,VP_DETP_P,VP_DETS_P


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

GOLD_t
	LWWWWWW	scale70t_t,BV5,SHT5,DNK7,DEF4,SDEF4,DSKL_6
	.long	WILLIS_F, UN_GLDP_P,UN_GLDS_P, TR_GLDP_P,TR_GLDS_P,Willis_h
	.word	1,9,4	
	.long	SW_GLDP_P,SW_GLDS_P,VP_GLDP_P,VP_GLDS_P
	LWWWWWW	scale65_t,BV9,SHT8,DNK8,DEF2,SDEF7,DSKL_4
	.long	SPREWE_F, UN_GLDP_P,UN_GLDS_P, TR_GLDP_P,TR_GLDS_P,Sprewell_h
	.word	4,4,8	
	.long	SW_GLDP_P,SW_GLDS_P,VP_GLDP_P,VP_GLDS_P
	LWWWWWW	scale611_t,BV5,SHT5,DNK3,DEF7,SDEF3,DSKL_6
	.long	shiek_f, UN_GLDP_P,UN_GLDS_P, TR_GLDP_P,TR_GLDS_P,Seikaly_h
	.word	4,8,4	
	.long	SW_GLDP_P,SW_GLDS_P,VP_GLDP_P,VP_GLDS_P
	LWWWWWW	scale610t_t,BV7,SHT7,DNK9,DEF8,SDEF7,DSKL_4
	.long	JSMITH_F, UN_GLDP_P,UN_GLDS_P, TR_GLDP_P,TR_GLDS_P,Jsmith_h
	.word	2,7,3	
	.long	SW_GLDP_P,SW_GLDS_P,VP_GLDP_P,VP_GLDS_P
	LWWWWWW	scale67_t,BV4,SHT9,DNK2,DEF4,SDEF8,DSKL_4
	.long	mullin_f, UN_GLDP_P,UN_GLDS_P, TR_GLDP_P,TR_GLDS_P,Mullin_h
	.word	7,5,8	
	.long	SW_GLDP_P,SW_GLDS_P,VP_GLDP_P,VP_GLDS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

HOU_t
	LWWWWWW	scale70_t,BV7,SHT7,DNK8,DEF10,SDEF7,DSKL1
	.long	Hakeem_f, UN_HOUP_P,UN_HOUS_P, TR_HOUP_P,TR_HOUS_P,Olajuwon_h
	.word	7,10,7
	.long	SW_HOUP_P,SW_HOUS_P,VP_HOUP_P,VP_HOUS_P
	LWWWWWW	scale67_t,BV7,SHT8,DNK9,DEF2,SDEF8,DSKL3	;Can shatter
	.long	Drex_f, UN_HOUP_P,UN_HOUS_P, TR_HOUP_P,TR_HOUS_P,Drexler_h
	.word	8,3,8	
	.long	SW_HOUP_P,SW_HOUS_P,VP_HOUP_P,VP_HOUS_P
	LWWWWWW	scale610t_t,BV8,SHT6,DNK8,DEF8,SDEF7,DSKL1
	.long	HORRY_F, UN_HOUP_P,UN_HOUS_P, TR_HOUP_P,TR_HOUS_P,Horry_h
	.word	5,6,9	
	.long	SW_HOUP_P,SW_HOUS_P,VP_HOUP_P,VP_HOUS_P
	LWWWWWW	scale63_t,BV9,SHT6,DNK1,DEF1,SDEF4,DSKL1
	.long	CASSEL_F, UN_HOUP_P,UN_HOUS_P, TR_HOUP_P,TR_HOUS_P,Cassel_h
	.word	6,1,2	
	.long	SW_HOUP_P,SW_HOUS_P,VP_HOUP_P,VP_HOUS_P
	LWWWWWW	scale63t_t,BV6,SHT6,DNK1,DEF1,SDEF7,DSKL1
	.long	smith_f, UN_HOUP_P,UN_HOUS_P, TR_HOUP_P,TR_HOUS_P,Smith_h
	.word	7,4,4	
	.long	SW_HOUP_P,SW_HOUS_P,VP_HOUP_P,VP_HOUS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

IND_t
	LWWWWWW	scale67t_t,BV7,SHT9,DNK6,DEF5,SDEF6,DSKL0
	.long	OMILLER_F, UN_INDP_P,UN_INDS_P, TR_INDP_P,TR_INDS_P,Miller_h
	.word	5,4,9	
	.long	SW_INDP_P,SW_INDS_P,VP_INDP_P,VP_INDS_P
	LWWWWWW	scale611_t,BV5,SHT4,DNK6,DEF8,SDEF5,DSKL0
	.long	DDAVIS_F, UN_INDP_P,UN_INDS_P, TR_INDP_P,TR_INDS_P,Ddavis_h
	.word	2,6,2
	.long	SW_INDP_P,SW_INDS_P,VP_INDP_P,VP_INDS_P
	LWWWWWW	scale74f_t,BV6,SHT7,DNK3,DEF6,SDEF4,DSKL0
	.long	SMITS_F, UN_INDP_P,UN_INDS_P, TR_INDP_P,TR_INDS_P,Smits_h
	.word	2,9,9
	.long	SW_INDP_P,SW_INDS_P,VP_INDP_P,VP_INDS_P
	LWWWWWW	scale610_t,BV7,SHT5,DNK5,DEF7,SDEF7,DSKL0
	.long	MCKEE_F, UN_INDP_P,UN_INDS_P, TR_INDP_P,TR_INDS_P,Mckee_h
	.word	6,5,3
	.long	SW_INDP_P,SW_INDS_P,VP_INDP_P,VP_INDS_P
	LWWWWWW	scale61f_t,BV7,SHT6,DNK1,DEF4,SDEF9,DSKL0
	.long	MJACKS_F, UN_INDP_P,UN_INDS_P, TR_INDP_P,TR_INDS_P,MJackson_h
	.word	9,4,4
	.long	SW_INDP_P,SW_INDS_P,VP_INDP_P,VP_INDS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

LAC_t
	LWWWWWW	scale69f_t,BV5,SHT7,DNK6,DEF6,SDEF6,DSKL0
	.long	VAUGHT_F, UN_LACP_P,UN_LACS_P, TR_LACP_P,TR_LACS_P,Vaught_h
	.word	1,7,8	
	.long	SW_LACP_P,SW_LACS_P,VP_LACP_P,VP_LACS_P
	LWWWWWW	scale67ef_t,BV6,SHT5,DNK5,DEF3,SDEF2,DSKL0
	.long	RROGER_F, UN_LACP_P,UN_LACS_P, TR_LACP_P,TR_LACS_P,Rrogers_h
	.word	2,8,5	
	.long	SW_LACP_P,SW_LACS_P,VP_LACP_P,VP_LACS_P
	LWWWWWW	scale67_t,BV8,SHT6,DNK5,DEF4,SDEF8,DSKL0
	.long	LMURRA_F, UN_LACP_P,UN_LACS_P, TR_LACP_P,TR_LACS_P,Lmurray_h
	.word	6,5,9	
	.long	SW_LACP_P,SW_LACS_P,VP_LACP_P,VP_LACS_P
	LWWWWWW	scale61_t,BV8,SHT4,DNK1,DEF1,SDEF8,DSKL0
	.long	PRICHA_F, UN_LACP_P,UN_LACS_P, TR_LACP_P,TR_LACS_P,Richardson_h
	.word	8,1,2	
	.long	SW_LACP_P,SW_LACS_P,VP_LACP_P,VP_LACS_P
	LWWWWWW	scale66t_t,BV8,SHT8,DNK4,DEF2,SDEF7,DSKL0
	.long	BBARRY_F, UN_LACP_P,UN_LACS_P, TR_LACP_P,TR_LACS_P,Bbarry_h
	.word	5,2,8	
	.long	SW_LACP_P,SW_LACS_P,VP_LACP_P,VP_LACS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

LAL_t
	LWWWWWW	scale61_t,BV10,SHT7,DNK1,DEF1,SDEF6,DSKL1
	.long	EXEL_F, UN_LALP_P,UN_LALS_P, TR_LALP_P,TR_LALS_P,Vanexel_h
	.word	8,2,9	
	.long	SW_LALP_P,SW_LALS_P,VP_LALP_P,VP_LALS_P
	LWWWWWW	scale71_t,BV5,SHT4,DNK4,DEF9,SDEF5,DSKL1
	.long	divac_f, UN_LALP_P,UN_LALS_P, TR_LALP_P,TR_LALS_P,Divac_h
	.word	6,8,2	
	.long	SW_LALP_P,SW_LALS_P,VP_LALP_P,VP_LALS_P
	LWWWWWW	scale67_t,BV8,SHT9,DNK7,DEF2,SDEF8,DSKL1
	.long	CEBALL_F, UN_LALP_P,UN_LALS_P, TR_LALP_P,TR_LALS_P,Ceballos_h
	.word	2,3,8	
	.long	SW_LALP_P,SW_LALS_P,VP_LALP_P,VP_LALS_P
	LWWWWWW	scale611_t,BV6,SHT5,DNK6,DEF9,SDEF8,DSKL1
	.long	CAMP_F, UN_LALP_P,UN_LALS_P, TR_LALP_P,TR_LALS_P,Campbell_h
	.word	1,5,3	
	.long	SW_LALP_P,SW_LALS_P,VP_LALP_P,VP_LALS_P

	LWWWWWW	scale66_t,BV8,SHT7,DNK5,DEF7,SDEF4,DSKL1
	.long	EJONES_F, UN_LALP_P,UN_LALS_P, TR_LALP_P,TR_LALS_P,Ejones_h
	.word	8,4,2	
	.long	SW_LALP_P,SW_LALS_P,VP_LALP_P,VP_LALS_P


;	LWWWWWW	scale69f_t,BV7,SHT8,DNK1,DEF5,SDEF8,DSKL1
;	.long	MJohnson_f, UN_LALP_P,UN_LALS_P, TR_LALP_P,TR_LALS_P,MJohnson_h
;	.word	9,7,9	
;	.long	SW_LALP_P,SW_LALS_P,VP_LALP_P,VP_LALS_P


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

MIAMI_t		;Done
	LWWWWWW	scale610f_t,BV8,SHT6,DNK9,DEF9,SDEF4,DSKL0
	.long	MOURN_F, UN_MIAP_P,UN_MIAS_P, TR_MIAP_P,TR_MIAS_P,Mourn_h
	.word	3,10,7
	.long	SW_MIAP_P,SW_MIAS_P,VP_MIAP_P,VP_MIAS_P
	LWWWWWW	scale68_t,BV8,SHT7,DNK7,DEF8,SDEF5,DSKL_8
	.long	WWILLI_F, UN_MIAP_P,UN_MIAS_P, TR_MIAP_P,TR_MIAS_P,Wwilliams_h
	.word	6,6,3	
	.long	SW_MIAP_P,SW_MIAS_P,VP_MIAP_P,VP_MIAS_P
	LWWWWWW	scale64_t,BV6,SHT8,DNK2,DEF4,SDEF2,DSKL_8
	.long	Chapman_f, UN_MIAP_P,UN_MIAS_P, TR_MIAP_P,TR_MIAS_P,Chapman_h
	.word	6,3,9	
	.long	SW_MIAP_P,SW_MIAS_P,VP_MIAP_P,VP_MIAS_P
	LWWWWWW	scale60f_t,BV9,SHT7,DNK0,DEF1,SDEF8,DSKL_4
	.long	Hrdaway_f, UN_MIAP_P,UN_MIAS_P, TR_MIAP_P,TR_MIAS_P,Hardaway_h
	.word	8,5,6	
	.long	SW_MIAP_P,SW_MIAS_P,VP_MIAP_P,VP_MIAS_P
	LWWWWWW	scale66f_t,BV5,SHT8,DNK2,DEF5,SDEF4,DSKL_6
	.long	DANILO_F, UN_MIAP_P,UN_MIAS_P, TR_MIAP_P,TR_MIAS_P,Danilovic_h
	.word	5,5,4	
	.long	SW_MIAP_P,SW_MIAS_P,VP_MIAP_P,VP_MIAS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

MILW_t
	LWWWWWW	scale611_t,BV8,SHT7,DNK8,DEF7,SDEF5,DSKL_2
	.long	BAKER_F, UN_MILP_P,UN_MILS_P, TR_MILP_P,TR_MILS_P,Baker_h
	.word	4,5,6	
	.long	SW_MILP_P,SW_MILS_P,VP_MILP_P,VP_MILS_P
	LWWWWWW	scale67f_t,BV7,SHT9,DNK6,DEF2,SDEF7,DSKL_2
	.long	GROBIN_F, UN_MILP_P,UN_MILS_P, TR_MILP_P,TR_MILS_P,Grobinson_h
	.word	4,7,8	
	.long	SW_MILP_P,SW_MILS_P,VP_MILP_P,VP_MILS_P
	LWWWWWW	scale62_t,BV9,SHT6,DNK0,DEF1,SDEF7,DSKL_2
	.long	RESPER_F, UN_MILP_P,UN_MILS_P, TR_MILP_P,TR_MILS_P,Respert_h
	.word	7,1,9	
	.long	SW_MILP_P,SW_MILS_P,VP_MILP_P,VP_MILS_P
	LWWWWWW	scale70f_t,BV3,SHT4,DNK4,DEF7,SDEF3,DSKL0
	.long	Benja_f, UN_MILP_P,UN_MILS_P, TR_MILP_P,TR_MILS_P,Benjamin_h
	.word	1,9,1
	.long	SW_MILP_P,SW_MILS_P,VP_MILP_P,VP_MILS_P
	LWWWWWW	scale61f_t,BV6,SHT6,DNK0,DEF1,SDEF6,DSKL_2
	.long	DOUGLA_F, UN_MILP_P,UN_MILS_P, TR_MILP_P,TR_MILS_P,Douglas_h
	.word	6,3,3	
	.long	SW_MILP_P,SW_MILS_P,VP_MILP_P,VP_MILS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

MINN_t
	LWWWWWW	scale65_t,BV9,SHT5,DNK9,DEF1,SDEF4,DSKL_10
	.long	RIDER_F, UN_MINP_P,UN_MINS_P, TR_MINP_P,TR_MINS_P,Rider_h
	.word	2,4,6
	.long	SW_MINP_P,SW_MINS_P,VP_MINP_P,VP_MINS_P
	LWWWWWW	scale611_t,BV6,SHT5,DNK6,DEF9,SDEF4,DSKL_10
	.long	Lang_f, UN_MINP_P,UN_MINS_P, TR_MINP_P,TR_MINS_P,Lang_h
	.word	2,8,4
	.long	SW_MINP_P,SW_MINS_P,VP_MINP_P,VP_MINS_P
	LWWWWWW	scale57_t,BV10,SHT5,DNK9,DEF0,SDEF7,DSKL_8
	.long	Webb_f, UN_MINP_P,UN_MINS_P, TR_MINP_P,TR_MINS_P,Webb_h
	.word	6,0,5	
	.long	SW_MINP_P,SW_MINS_P,VP_MINP_P,VP_MINS_P
	LWWWWWW	scale610_t,BV7,SHT7,DNK5,DEF7,SDEF9,DSKL_5
	.long	gug_f, UN_MINP_P,UN_MINS_P, TR_MINP_P,TR_MINS_P,Gug_h
	.word	6,6,3
	.long	SW_MINP_P,SW_MINS_P,VP_MINP_P,VP_MINS_P
	LWWWWWW	scale611t_t,BV8,SHT5,DNK8,DEF8,SDEF5,DSKL_10
	.long	GARNET_F, UN_MINP_P,UN_MINS_P, TR_MINP_P,TR_MINS_P,Garnett_h
	.word	4,2,3
	.long	SW_MINP_P,SW_MINS_P,VP_MINP_P,VP_MINS_P


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

NJ_t
	LWWWWWW	scale65_t,BV8,SHT6,DNK5,DEF5,SDEF7,DSKL0
	.long	gill_f, UN_NEJP_P,UN_NEJS_P, TR_NEJP_P,TR_NEJS_P,Gill_h
	.word	7,2,3
	.long	SW_NEJP_P,SW_NEJS_P,VP_NEJP_P,VP_NEJS_P
	LWWWWWW	scale76et_t,BV5,SHT5,DNK8,DEF10,SDEF4,DSKL_9
	.long	BRAD_F, UN_NEJP_P,UN_NEJS_P, TR_NEJP_P,TR_NEJS_P,Brad_h
	.word	3,2,4	
	.long	SW_NEJP_P,SW_NEJS_P,VP_NEJP_P,VP_NEJS_P
	LWWWWWW	scale69f_t,BV6,SHT7,DNK6,DEF6,SDEF7,DSKL0
	.long	GILLIA_F, UN_NEJP_P,UN_NEJS_P, TR_NEJP_P,TR_NEJS_P,Gilliam_h
	.word	4,8,2
	.long	SW_NEJP_P,SW_NEJS_P,VP_NEJP_P,VP_NEJS_P
	LWWWWWW	scale68_t,BV8,SHT5,DNK6,DEF5,SDEF9,DSKL0
	.long	OBANN_F, UN_NEJP_P,UN_NEJS_P, TR_NEJP_P,TR_NEJS_P,Obannon_h
	.word	5,4,8
	.long	SW_NEJP_P,SW_NEJS_P,VP_NEJP_P,VP_NEJS_P
	LWWWWWW	scale63_t,BV7,SHT6,DNK1,DEF1,SDEF8,DSKL0
	.long	KEDWAR_F, UN_NEJP_P,UN_NEJS_P, TR_NEJP_P,TR_NEJS_P,KEdwards_h
	.word	3,2,3
	.long	SW_NEJP_P,SW_NEJS_P,VP_NEJP_P,VP_NEJS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

NY_t
	LWWWWWW	scale70f_t,BV6,SHT7,DNK8,DEF10,SDEF4,DSKL2	;Shatter
	.long	ewing_f, UN_NEYP_P,UN_NEYS_P, TR_NEYP_P,TR_NEYS_P,Ewing_h
	.word	2,10,8	
	.long	SW_NEYP_P,SW_NEYS_P,VP_NEYP_P,VP_NEYS_P
	LWWWWWW	scale67ef_t,BV6,SHT6,DNK5,DEF3,SDEF3,DSKL2
	.long	MASON_F, UN_NEYP_P,UN_NEYS_P, TR_NEYP_P,TR_NEYS_P,Mason_h
	.word	4,9,6	
	.long	SW_NEYP_P,SW_NEYS_P,VP_NEYP_P,VP_NEYS_P
	LWWWWWW	scale64f_t,BV6,SHT6,DNK1,DEF1,SDEF7,DSKL_11
	.long	DHARP_F,  UN_NEYP_P,UN_NEYS_P, TR_NEYP_P,TR_NEYS_P,DHarper_h
	.word	5,5,5
	.long	SW_NEYP_P,SW_NEYS_P,VP_NEYP_P,VP_NEYS_P
	LWWWWWW	scale69f_t,BV5,SHT5,DNK7,DEF2,SDEF5,DSKL2
	.long	Oakley_f, UN_NEYP_P,UN_NEYS_P, TR_NEYP_P,TR_NEYS_P,Oakley_h
	.word	4,8,2
	.long	SW_NEYP_P,SW_NEYS_P,VP_NEYP_P,VP_NEYS_P
	LWWWWWW	scale65t_t,BV9,SHT8,DNK2,DEF2,SDEF7,DSKL2
	.long	STARKS_F, UN_NEYP_P,UN_NEYS_P, TR_NEYP_P,TR_NEYS_P,Starks_h
	.word	8,5,8	
	.long	SW_NEYP_P,SW_NEYS_P,VP_NEYP_P,VP_NEYS_P


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

ORL_t
	LWWWWWW	scale67t_t,BV10,SHT8,DNK8,DEF7,SDEF8,DSKL2
	.long	A_HARD_F, UN_ORLP_P,UN_ORLS_P, TR_ORLP_P,TR_ORLS_P,AHard_h
	.word	8,4,10
	.long	SW_ORLP_P,SW_ORLS_P,VP_ORLP_P,VP_ORLS_P
	LWWWWWW	scale610_t,BV6,SHT5,DNK6,DEF8,SDEF4,DSKL5
	.long	GrantG_F, UN_ORLP_P,UN_ORLS_P, TR_ORLP_P,TR_ORLS_P,HCGrant_h
	.word	4,8,4	
	.long	SW_ORLP_P,SW_ORLS_P,VP_ORLP_P,VP_ORLS_P
	LWWWWWW	scale66_t,BV7,SHT8,DNK3,DEF4,SDEF8,DSKL2
	.long	N_AND_F, UN_ORLP_P,UN_ORLS_P, TR_ORLP_P,TR_ORLS_P,NAnders_h
	.word	4,4,4	
	.long	SW_ORLP_P,SW_ORLS_P,VP_ORLP_P,VP_ORLS_P
	LWWWWWW	scale68_t,BV7,SHT9,DNK3,DEF4,SDEF4,DSKL2
	.long	DSCOTT_F, UN_ORLP_P,UN_ORLS_P, TR_ORLP_P,TR_ORLS_P,Dscott_h
	.word	5,3,4	
	.long	SW_ORLP_P,SW_ORLS_P,VP_ORLP_P,VP_ORLS_P
	LWWWWWW	scale70f_t,BV4,SHT5,DNK7,DEF5,SDEF3,DSKL2
	.long	KONCAK_F, UN_ORLP_P,UN_ORLS_P, TR_ORLP_P,TR_ORLS_P,Koncak_h
	.word	3,6,2	
	.long	SW_ORLP_P,SW_ORLS_P,VP_ORLP_P,VP_ORLS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

PHIL_t
	LWWWWWW	scale66_t,BV8,SHT7,DNK8,DEF3,SDEF5,DSKL_9
	.long	STACK_F, UN_PHLP_P,UN_PHLS_P, TR_PHLP_P,TR_PHLS_P,Stackhouse_h
	.word	5,4,7	
	.long	SW_PHLP_P,SW_PHLS_P,VP_PHLP_P,VP_PHLS_P
	LWWWWWW	scale610ef_t,BV5,SHT7,DNK6,DEF5,SDEF3,DSKL0
	.long	Cole_f, UN_PHLP_P,UN_PHLS_P, TR_PHLP_P,TR_PHLS_P,Coleman_h
	.word	3,8,2
	.long	SW_PHLP_P,SW_PHLS_P,VP_PHLP_P,VP_PHLS_P
	LWWWWWW	scale67f_t,BV5,SHT6,DNK6,DEF6,SDEF4,DSKL_9
	.long	WEATH_F, UN_PHLP_P,UN_PHLS_P, TR_PHLP_P,TR_PHLS_P,Weath_h
	.word	5,6,7	
	.long	SW_PHLP_P,SW_PHLS_P,VP_PHLP_P,VP_PHLS_P
	LWWWWWW	scale61_t,BV8,SHT7,DNK1,DEF1,SDEF4,DSKL_9
	.long	Ruffin_f, UN_PHLP_P,UN_PHLS_P, TR_PHLP_P,TR_PHLS_P,Ruffin_h
	.word	7,1,4	
	.long	SW_PHLP_P,SW_PHLS_P,VP_PHLP_P,VP_PHLS_P
	LWWWWWW	scale64t_t,BV7,SHT8,DNK3,DEF3,SDEF5,DSKL_9
	.long	VMAX_F, UN_PHLP_P,UN_PHLS_P, TR_PHLP_P,TR_PHLS_P,VMaxwell_h
	.word	6,4,4	
	.long	SW_PHLP_P,SW_PHLS_P,VP_PHLP_P,VP_PHLS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

PHX_t
	LWWWWWW	scale61_t,BV9,SHT8,DNK2,DEF3,SDEF8,DSKL3
	.long	K_JOHN_F, UN_PHXP_P,UN_PHXS_P, TR_PHXP_P,TR_PHXS_P,KJohn_h
	.word	8,2,9
	.long	SW_PHXP_P,SW_PHXS_P,VP_PHXP_P,VP_PHXS_P
	LWWWWWW	scale69ef_t,BV4,SHT8,DNK6,DEF6,SDEF4,DSKL_8
	.long	tisdale_f, UN_PHXP_P,UN_PHXS_P, TR_PHXP_P,TR_PHXS_P,Tisdale_h
	.word	5,8,7	
	.long	SW_PHXP_P,SW_PHXS_P,VP_PHXP_P,VP_PHXS_P
	LWWWWWW	scale610_t,BV5,SHT5,DNK7,DEF5,SDEF4,DSKL0
	.long	Manning_f, UN_PHXP_P,UN_PHXS_P, TR_PHXP_P,TR_PHXS_P,Manning_h
	.word	3,6,6
	.long	SW_PHXP_P,SW_PHXS_P,VP_PHXP_P,VP_PHXS_P
	LWWWWWW	scale66_t,BV8,SHT7,DNK4,DEF5,SDEF8,DSKL_10
	.long	WPERS_F, UN_PHXP_P,UN_PHXS_P, TR_PHXP_P,TR_PHXS_P,Wperson_h
	.word	4,5,9	
	.long	SW_PHXP_P,SW_PHXS_P,VP_PHXP_P,VP_PHXS_P
	LWWWWWW	scale67_t,BV9,SHT7,DNK9,DEF2,SDEF7,DSKL_8
	.long	FINLEY_F, UN_PHXP_P,UN_PHXS_P, TR_PHXP_P,TR_PHXS_P,Finley_h
	.word	4,2,9
	.long	SW_PHXP_P,SW_PHXS_P,VP_PHXP_P,VP_PHXS_P


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

PORT_t
	LWWWWWW	scale63_t,BV8,SHT7,DNK0,DEF1,SDEF7,DSKL3
	.long	STRICK_F, UN_PORP_P,UN_PORS_P, TR_PORP_P,TR_PORS_P,Strickland_h
	.word	10,3,6	
	.long	SW_PORP_P,SW_PORS_P,VP_PORP_P,VP_PORS_P
	LWWWWWW	scale610_t,BV8,SHT6,DNK6,DEF7,SDEF6,DSKL3
	.long	C_ROB_F, UN_PORP_P,UN_PORS_P, TR_PORP_P,TR_PORS_P,CRobinson_h
	.word	2,7,8	
	.long	SW_PORP_P,SW_PORS_P,VP_PORP_P,VP_PORS_P
	LWWWWWW	scale73ef_t,BV4,SHT6,DNK5,DEF7,SDEF3,DSKL3
	.long	SABONI_F, UN_PORP_P,UN_PORS_P, TR_PORP_P,TR_PORS_P,Sabonis_h
	.word	2,9,4	
	.long	SW_PORP_P,SW_PORS_P,VP_PORP_P,VP_PORS_P
	LWWWWWW	scale68f_t,BV6,SHT4,DNK6,DEF5,SDEF4,DSKL3
	.long	BWILLI_F, UN_PORP_P,UN_PORS_P, TR_PORP_P,TR_PORS_P,Bwilliams_h
	.word	4,5,4	
	.long	SW_PORP_P,SW_PORS_P,VP_PORP_P,VP_PORS_P
	LWWWWWW	scale62_t,BV9,SHT5,DNK0,DEF1,SDEF6,DSKL3
	.long	CHILD_F, UN_PORP_P,UN_PORS_P, TR_PORP_P,TR_PORS_P,Childress_h
	.word	8,2,8	
	.long	SW_PORP_P,SW_PORS_P,VP_PORP_P,VP_PORS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

SAC_t
	LWWWWWW	scale69_t,BV7,SHT7,DNK6,DEF2,SDEF4,DSKL_6
	.long	BOWENS_F, UN_SACP_P,UN_SACS_P, TR_SACP_P,TR_SACS_P,Bowens_h
	.word	7,6,6	
	.long	SW_SACP_P,SW_SACS_P,VP_SACP_P,VP_SACS_P
	LWWWWWW	scale65f_t,BV7,SHT8,DNK2,DEF1,SDEF9,DSKL_8
	.long	RICH_F, UN_SACP_P,UN_SACS_P, TR_SACP_P,TR_SACS_P,Rich_h
	.word	6,7,8	
	.long	SW_SACP_P,SW_SACS_P,VP_SACP_P,VP_SACS_P
	LWWWWWW	scale69f_t,BV5,SHT5,DNK6,DEF9,SDEF2,DSKL_8
	.long	BGRANT_F, UN_SACP_P,UN_SACS_P, TR_SACP_P,TR_SACS_P,Bgrant_h
	.word	1,6,6	
	.long	SW_SACP_P,SW_SACS_P,VP_SACP_P,VP_SACS_P
	LWWWWWW	scale65_t,BV4,SHT8,DNK1,DEF1,SDEF8,DSKL_8
	.long	MARCIU_F, UN_SACP_P,UN_SACS_P, TR_SACP_P,TR_SACS_P,Marciulonis_h
	.word	2,5,7	
	.long	SW_SACP_P,SW_SACS_P,VP_SACP_P,VP_SACS_P
	LWWWWWW	scale510et_t,BV10,SHT6,DNK0,DEF0,SDEF8,DSKL_8
	.long	EDNEY_F, UN_SACP_P,UN_SACS_P, TR_SACP_P,TR_SACS_P,Edney_h
	.word	8,1,4
	.long	SW_SACP_P,SW_SACS_P,VP_SACP_P,VP_SACS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

SANANT_t
	LWWWWWW	scale68_t,BV8,SHT8,DNK7,DEF5,SDEF4,DSKL_3
	.long	Elliot_f, UN_SANP_P,UN_SANS_P, TR_SANP_P,TR_SANS_P,Elliot_h
	.word	2,4,8
	.long	SW_SANP_P,SW_SANS_P,VP_SANP_P,VP_SANS_P
	LWWWWWW	scale71_t,BV8,SHT8,DNK6,DEF10,SDEF5,DSKL_3
	.long	Robins_f, UN_SANP_P,UN_SANS_P, TR_SANP_P,TR_SANS_P,DRobinson_h
	.word	4,9,6
	.long	SW_SANP_P,SW_SANS_P,VP_SANP_P,VP_SANS_P
	LWWWWWW	scale511_t,BV10,SHT5,DNK0,DEF1,SDEF8,DSKL_10
	.long	AJOHN_F, UN_SANP_P,UN_SANS_P, TR_SANP_P,TR_SANS_P,Ajohnson_h
	.word	9,1,2
	.long	SW_SANP_P,SW_SANS_P,VP_SANP_P,VP_SANS_P
	LWWWWWW	scale68f_t,BV6,SHT6,DNK4,DEF4,SDEF4,DSKL_10
	.long	Person_f, UN_SANP_P,UN_SANS_P, TR_SANP_P,TR_SANS_P,Person_h
	.word	2,6,7
	.long	SW_SANP_P,SW_SANS_P,VP_SANP_P,VP_SANS_P
	LWWWWWW	scale64_t,BV7,SHT6,DNK1,DEF1,SDEF7,DSKL_10
	.long	DELNEG_F, UN_SANP_P,UN_SANS_P, TR_SANP_P,TR_SANS_P,Delnegro_h
	.word	3,3,2
	.long	SW_SANP_P,SW_SANS_P,VP_SANP_P,VP_SANS_P


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

SEA_t
	LWWWWWW	scale610_t,BV8,SHT8,DNK10,DEF9,SDEF6,DSKL0
	.long	kemp_f, UN_SEAP_P,UN_SEAS_P, TR_SEAP_P,TR_SEAS_P,Kemp_h
	.word	3,7,7	
	.long	SW_SEAP_P,SW_SEAS_P,VP_SEAP_P,VP_SEAS_P
	LWWWWWW	scale64_t,BV10,SHT7,DNK0,DEF2,SDEF10,DSKL0
	.long	PAYTON_F, UN_SEAP_P,UN_SEAS_P, TR_SEAP_P,TR_SEAS_P,Payton_h
	.word	8,3,8	
	.long	SW_SEAP_P,SW_SEAS_P,VP_SEAP_P,VP_SEAS_P
	LWWWWWW	scale610t_t,BV5,SHT8,DNK5,DEF4,SDEF2,DSKL0
	.long	schremp_f, UN_SEAP_P,UN_SEAS_P, TR_SEAP_P,TR_SEAS_P,Schrempf_h
	.word	4,6,2	
	.long	SW_SEAP_P,SW_SEAS_P,VP_SEAP_P,VP_SEAS_P
	LWWWWWW	scale63_t,BV6,SHT7,DNK0,DEF4,SDEF6,DSKL0
	.long	hawkins_f, UN_SEAP_P,UN_SEAS_P, TR_SEAP_P,TR_SEAS_P,Hawkins_h
	.word	5,3,7	
	.long	SW_SEAP_P,SW_SEAS_P,VP_SEAP_P,VP_SEAS_P
	LWWWWWW	scale67t_t,BV7,SHT4,DNK4,DEF4,SDEF4,DSKL0
	.long	FORD_F, UN_SEAP_P,UN_SEAS_P, TR_SEAP_P,TR_SEAS_P,Sford_h
	.word	6,3,4	
	.long	SW_SEAP_P,SW_SEAS_P,VP_SEAP_P,VP_SEAS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

TORONTO_t
	LWWWWWW	scale611t_t,BV6,SHT5,DNK5,DEF4,SDEF6,DSKL_6
	.long	CROGER_F, UN_TORP_P,UN_TORS_P, TR_TORP_P,TR_TORS_P,Crogers_h
	.word	5,8,1	
	.long	SW_TORP_P,SW_TORS_P,VP_TORP_P,VP_TORS_P
	LWWWWWW	scale510_t,BV10,SHT7,DNK0,DEF1,SDEF8,DSKL_6
	.long	STOUD_F, UN_TORP_P,UN_TORS_P, TR_TORP_P,TR_TORS_P,Stoudamire_h
	.word	9,1,8	
	.long	SW_TORP_P,SW_TORS_P,VP_TORP_P,VP_TORS_P
	LWWWWWW	scale64f_t,BV6,SHT6,DNK1,DEF6,SDEF9,DSKL_6
	.long	Robertsnf, UN_TORP_P,UN_TORS_P, TR_TORP_P,TR_TORS_P,Robertson_h
	.word	7,4,8	
	.long	SW_TORP_P,SW_TORS_P,VP_TORP_P,VP_TORS_P
	LWWWWWW	scale69ef_t,BV4,SHT5,DNK2,DEF9,SDEF4,DSKL_6
	.long	OMILLER_F, UN_TORP_P,UN_TORS_P, TR_TORP_P,TR_TORS_P,OMiller_h
	.word	4,8,2	
	.long	SW_TORP_P,SW_TORS_P,VP_TORP_P,VP_TORS_P
	LWWWWWW	scale67_t,BV4,SHT7,DNK5,DEF3,SDEF3,DSKL_6
	.long	MURRAY_F, UN_TORP_P,UN_TORS_P, TR_TORP_P,TR_TORS_P,TMurray_h
	.word	2,5,7	
	.long	SW_TORP_P,SW_TORS_P,VP_TORP_P,VP_TORS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

UTAH_t
	LWWWWWW	scale61_t,BV7,SHT8,DNK0,DEF1,SDEF10,DSKL4
	.long	stock_f, UN_UTAP_P,UN_UTAS_P, TR_UTAP_P,TR_UTAS_P,Stockton_h
	.word	10,2,8	
	.long	SW_UTAP_P,SW_UTAS_P,VP_UTAP_P,VP_UTAS_P
	LWWWWWW	scale69ef_t,BV7,SHT8,DNK8,DEF5,SDEF8,DSKL4	;Can shatter
	.long	kmalone_f, UN_UTAP_P,UN_UTAS_P, TR_UTAP_P,TR_UTAS_P,KMalone_h
	.word	6,10,7	
	.long	SW_UTAP_P,SW_UTAS_P,VP_UTAP_P,VP_UTAS_P
	LWWWWWW	scale64_t,BV5,SHT7,DNK2,DEF2,SDEF7,DSKL_9
	.long	Horna_f, UN_UTAP_P,UN_UTAS_P, TR_UTAP_P,TR_UTAS_P,Hornacek_h
	.word	5,5,6	
	.long	SW_UTAP_P,SW_UTAS_P,VP_UTAP_P,VP_UTAS_P
	LWWWWWW	scale68_t,BV6,SHT5,DNK6,DEF5,SDEF5,DSKL4
	.long	BENOIT_F, UN_UTAP_P,UN_UTAS_P, TR_UTAP_P,TR_UTAS_P,Benoit_h
	.word	5,5,4	
	.long	SW_UTAP_P,SW_UTAS_P,VP_UTAP_P,VP_UTAS_P
	LWWWWWW	scale68_t,BV5,SHT7,DNK5,DEF4,SDEF8,DSKL0
	.long	MORRIS_F, UN_UTAP_P,UN_UTAS_P, TR_UTAP_P,TR_UTAS_P,Morris_h
	.word	4,6,2
	.long	SW_UTAP_P,SW_UTAS_P,VP_UTAP_P,VP_UTAS_P


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

VANCOU_t
	LWWWWWW	scale61_t,BV8,SHT5,DNK1,DEF2,SDEF7,DSKL0
	.long	ANTHON_F, UN_VANP_P,UN_VANS_P, TR_VANP_P,TR_VANS_P,Anthony_h
	.word	7,4,2
	.long	SW_VANP_P,SW_VANS_P,VP_VANP_P,VP_VANS_P
	LWWWWWW	scale64_t,BV7,SHT7,DNK4,DEF5,SDEF8,DSKL_2
	.long	BEdwrd_f, UN_VANP_P,UN_VANS_P, TR_VANP_P,TR_VANS_P,BEdwrds_h
	.word	3,6,7	
	.long	SW_VANP_P,SW_VANS_P,VP_VANP_P,VP_VANS_P
	LWWWWWW	scale64f_t,BV7,SHT8,DNK1,DEF3,SDEF4,DSKL0
	.long	Scott_f, UN_VANP_P,UN_VANS_P, TR_VANP_P,TR_VANS_P,Scott_h
	.word	4,4,9
	.long	SW_VANP_P,SW_VANS_P,VP_VANP_P,VP_VANS_P
	LWWWWWW	scale70ef_t,BV5,SHT6,DNK4,DEF8,SDEF5,DSKL0
	.long	BREEV_F, UN_VANP_P,UN_VANS_P, TR_VANP_P,TR_VANS_P,Breeves_h
	.word	2,10,2
	.long	SW_VANP_P,SW_VANS_P,VP_VANP_P,VP_VANS_P
	LWWWWWW	scale61_t,BV8,SHT6,DNK1,DEF1,SDEF9,DSKL_2
	.long	EMURD_F, UN_VANP_P,UN_VANS_P, TR_VANP_P,TR_VANS_P,EMurdock_h
	.word	6,2,5	
	.long	SW_VANP_P,SW_VANS_P,VP_VANP_P,VP_VANS_P

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

WASH_t
	LWWWWWW	scale69f_t,BV7,SHT8,DNK6,DEF3,SDEF5,DSKL_5
	.long	JHOW_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Jhoward_h
	.word	4,7,6
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P
	LWWWWWW	scale610f_t,BV8,SHT8,DNK8,DEF4,SDEF6,DSKL_4
	.long	WEBBER_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Webber_h
	.word	6,8,7	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P
	LWWWWWW	scale67_t,BV7,SHT6,DNK6,DEF2,SDEF6,DSKL_5
	.long	CHEAN_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Cheaney_h
	.word	2,5,8
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P
	LWWWWWW	scale62_t,BV9,SHT6,DNK0,DEF0,SDEF9,DSKL0
	.long	PACK_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Pack_h
	.word	9,3,2	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P
	LWWWWWW	scale77ef_t,BV4,SHT5,DNK2,DEF9,SDEF3,DSKL_5
	.long	MURESA_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Muresan_h
	.word	1,9,4
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P


;MJT End

DEFAULT_t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Cheaney_h
	.word	5,2,8
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P
CUST_1t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUST1P,UN_CUST1P, TR_CUST1P,TR_CUST1P,Cheaney_h
	.word	5,2,8
	.long	SW_CUST1P,SW_CUST1P,VP_CUST1P,VP_CUST1P
CUST_2t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUST2P,UN_CUST2P, TR_CUST2P,TR_CUST2P,Cheaney_h
	.word	5,2,8
	.long	SW_CUST2P,SW_CUST2P,VP_CUST2P,VP_CUST2P
CUST_3t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUST3P,UN_CUST3P, TR_CUST3P,TR_CUST3P,Cheaney_h
	.word	5,2,8
	.long	SW_CUST3P,SW_CUST3P,VP_CUST3P,VP_CUST3P
CUST_4t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUST4P,UN_CUST4P, TR_CUST4P,TR_CUST4P,Cheaney_h
	.word	5,2,8
	.long	SW_CUST4P,SW_CUST4P,VP_CUST4P,VP_CUST4P
CUST_5t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUST5P,UN_CUST5P, TR_CUST5P,TR_CUST5P,Cheaney_h
	.word	5,2,8
	.long	SW_CUST5P,SW_CUST5P,VP_CUST5P,VP_CUST5P
CUST_6t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUST6P,UN_CUST6P, TR_CUST6P,TR_CUST6P,Cheaney_h
	.word	5,2,8
	.long	SW_CUST6P,SW_CUST6P,VP_CUST6P,VP_CUST6P
CUST_7t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUST7P,UN_CUST7P, TR_CUST7P,TR_CUST7P,Cheaney_h
	.word	5,2,8
	.long	SW_CUST7P,SW_CUST7P,VP_CUST7P,VP_CUST7P
CUST_8t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUST8P,UN_CUST8P, TR_CUST8P,TR_CUST8P,Cheaney_h
	.word	5,2,8
	.long	SW_CUST8P,SW_CUST8P,VP_CUST8P,VP_CUST8P
CUST_9t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUST9P,UN_CUST9P, TR_CUST9P,TR_CUST9P,Cheaney_h
	.word	5,2,8
	.long	SW_CUST9P,SW_CUST9P,VP_CUST9P,VP_CUST9P
CUST_10t
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	CHEAN_F, UN_CUS10P,UN_CUS10P, TR_CUS10P,TR_CUS10P,Cheaney_h
	.word	5,2,8
	.long	SW_CUS10P,SW_CUS10P,VP_CUS10P,VP_CUS10P



UN_CUST1P:
   .word   25 
   .word   00000h,0318ch,0294ah,02529h,02108h,01ce7h,018c6h,018c6h
   .word   014a5h,014a5h,01084h,01084h,00c63h,00c63h,00842h,00421h
   .word   00421h,00000h,00000h,00000h,00000h,00000h,00000h,00000h
   .word   00000h

TR_CUST1P:
   .word   17 
   .word   00000h,03defh,035adh,0318ch,0294ah,02529h,01ce7h,018c6h
   .word   01084h,00842h,00421h,00000h,00000h,00000h,00000h,00000h
   .word   00000h

SW_CUST1P:
   .word   12 
   .word   00000h,03defh,0318ch,0294ah,01ce7h,01084h,00842h,00000h
   .word   00000h,00000h,00000h,00000h

VP_CUST1P:
   .word   12 
   .word   00000h,03defh,0318ch,0294ah,01ce7h,01084h,00842h,00000h
   .word   00000h,00000h,00000h,00000h



SW_CUST2P:
   .word   12 
   .word   00000h,07fffh,07fffh,077bdh,06f7bh,06739h,05ef7h,056b5h
   .word   04e73h,04631h,03defh,035adh

TR_CUST2P:
   .word   17 
   .word   00000h,07fffh,07bdeh,077bdh,0739ch,06f7bh,06b5ah,06739h
   .word   06318h,05ef7h,05ad6h,056b5h,05294h,04e73h,04a52h,04631h
   .word   04210h

UN_CUST2P:
   .word   25 
   .word   00000h,07fffh,07bdeh,077bdh,0739ch,0737bh,06f5ah,06b39h
   .word   06718h,06718h,05ed6h,05ab5h,05694h,05273h,04e52h,04a31h
   .word   04610h,041efh,03dceh,039adh,0358ch,0316bh,02d4ah,02929h
   .word   02508h

VP_CUST2P:
   .word   12 
   .word   00000h,07fffh,07fffh,077bdh,06f7bh,06739h,05ef7h,056b5h
   .word   04e73h,04631h,03defh,035adh


SW_CUST3P:
   .word   12 
   .word   00000h,07d40h,07dc0h,07e40h,07ec0h,07f60h,07fe0h,07f60h
   .word   07ec0h,07e40h,07dc0h,07d40h

TR_CUST3P:
   .word   17 
   .word   00000h,07d40h,07da0h,07e00h,07e60h,07ec0h,07f20h,07f80h
   .word   07fe0h,07f80h,07f40h,07ee0h,07e80h,07e20h,07de0h,07d80h
   .word   07d20h

UN_CUST3P:
   .word   25 
   .word   00000h,06118h,058d6h,05495h,04c54h,04812h,04411h,04011h
   .word   03c10h,03c0fh,0380eh,0340eh,0340dh,0300ch,02c0bh,02c0bh
   .word   0280ah,02409h,02409h,02008h,01c07h,01c07h,01405h,00c03h
   .word   00802h

VP_CUST3P:
   .word   12 
   .word   00000h,07d40h,07da0h,07e00h,07e80h,07ee0h,07f60h,07ec0h
   .word   07e40h,07dc0h,07d40h,014a0h



SW_CUST4P:
   .word   12 
   .word   00000h,003e0h,003a0h,00360h,00320h,002c0h,00280h,00240h
   .word   001c0h,00180h,00140h,000a0h


TR_CUST4P:
   .word   17 
   .word   00000h,03defh,035adh,0318ch,0294ah,02529h,01ce7h,018c6h
   .word   01084h,00842h,00421h,00000h,00000h,00000h,00000h,00000h
   .word   00000h

UN_CUST4P:
   .word   25 
   .word   00000h,003e0h,003c0h,003a0h,00380h,00360h,00340h,00320h
   .word   00300h,002e0h,002c0h,002a0h,00280h,00260h,00240h,00220h
   .word   00220h,00200h,001e0h,001c0h,001a0h,00180h,00160h,00140h
   .word   00120h

VP_CUST4P:
   .word   12 
   .word   00000h,03defh,0318ch,0294ah,01ce7h,01084h,00842h,00000h
   .word   00000h,00000h,00000h,00000h



SW_CUST5P:
   .word   12 
   .word   00000h,07f60h,07f20h,07f00h,07ee0h,07680h,06e40h,06600h
   .word   05dc0h,059a0h,05160h,04940h

TR_CUST5P:
   .word   17 
   .word   00000h,07f60h,07f20h,07f00h,07ee0h,07aa0h,07280h,06e60h
   .word   06a40h,06600h,061e0h,05dc0h,059a0h,05580h,05160h,04d40h
   .word   04940h

UN_CUST5P:
   .word   25 
   .word   00000h,07df9h,07d98h,07d37h,07cf6h,07c96h,07c55h,07c15h
   .word   07813h,07412h,07011h,06c10h,0680fh,0640eh,0600dh,05c0ch
   .word   0580bh,0540ah,05009h,04c09h,04808h,04407h,04006h,03c06h
   .word   03805h

VP_CUST5P:
   .word   12 
   .word   00000h,07f60h,07f20h,07f00h,07ee0h,07680h,06e40h,06600h
   .word   05dc0h,059a0h,05160h,04940h


SW_CUST6P:
   .word   12 
   .word   00000h,07d9dh,07d5bh,07d38h,07d16h,078f4h,070d2h,068b0h
   .word   0608eh,0588ch,0508ah,04888h

TR_CUST6P:
   .word   17 
   .word   00000h,07d5dh,07d3bh,07d1ah,07cf8h,07cd7h,07cb6h,078b4h
   .word   07493h,07092h,06870h,0646fh,0604eh,0584ch,0544bh,04c49h
   .word   04848h

UN_CUST6P:
   .word   25 
   .word   00000h,0318ch,0294ah,02529h,02108h,01ce7h,018c6h,018c6h
   .word   014a5h,014a5h,01084h,01084h,00c63h,00c63h,00842h,00421h
   .word   00421h,00000h,00000h,00000h,00000h,00000h,00000h,00000h
   .word   00000h

VP_CUST6P:
   .word   12 
   .word   00000h,07d9dh,07d5bh,07d38h,07d16h,078f4h,070d2h,068b0h
   .word   0608eh,0588ch,0508ah,04888h


SW_CUST7P:
   .word   12 
   .word   00000h,03defh,0318ch,0294ah,01ce7h,01084h,00842h,00000h
   .word   00000h,00000h,00000h,00000h

TR_CUST7P:
   .word   17 
   .word   00000h,07d8bh,07949h,07507h,074e6h,070a4h,06c63h,06c42h
   .word   06820h,06800h,06000h,05800h,05000h,04c00h,04400h,03c00h
   .word   03800h

UN_CUST7P:
   .word   25 
   .word   00000h,074c5h,070a4h,06c62h,06841h,06400h,06400h,06000h
   .word   05c00h,05800h,05400h,05000h,04c00h,04800h,04800h,04400h
   .word   04000h,03c00h,03800h,03400h,03000h,03000h,02800h,02000h
   .word   01800h

VP_CUST7P:
   .word   12 
   .word   00000h,00380h,00340h,00300h,002c0h,00280h,00240h,00200h
   .word   001c0h,00180h,00140h,00100h


SW_CUST8P:
   .word   12 
   .word   00000h,07f60h,07f20h,07f00h,07ee0h,07680h,06e40h,06600h
   .word   05dc0h,059a0h,05160h,04940h

TR_CUST8P:
   .word   17 
   .word   00000h,03defh,035adh,0318ch,0294ah,02529h,01ce7h,018c6h
   .word   01084h,00842h,00421h,00000h,00000h,00000h,00000h,00000h
   .word   00000h

UN_CUST8P:
   .word   25 
   .word   00000h,07f80h,07b40h,07700h,072e0h,072a0h,06e80h,06e80h
   .word   06e60h,06a40h,06a40h,06a20h,06600h,061e0h,061c0h,05dc0h
   .word   05da0h,05980h,05960h,05560h,05120h,04d00h,048e0h,044c0h
   .word   040c0h

VP_CUST8P:
   .word   12 
   .word   00000h,03defh,0318ch,0294ah,01ce7h,01084h,00842h,00000h
   .word   00000h,00000h,00000h,00000h


SW_CUST9P:
   .word   12 
   .word   00000h,05ef7h,056b5h,04e73h,04631h,04210h,039ceh,0318ch
   .word   0294ah,02529h,01ce7h,014a5h

TR_CUST9P:
   .word   17 
   .word   00000h,05ef7h,056b5h,05294h,04e73h,04a52h,04631h,04210h
   .word   039ceh,035adh,0318ch,02d6bh,0294ah,02529h,01ce7h,018c6h
   .word   014a5h

UN_CUST9P:
   .word   25 
   .word   00000h,05ef7h,05ad6h,056b5h,05294h,05294h,04e73h,04a52h
   .word   04631h,04210h,04210h,03defh,039ceh,035adh,035adh,0318ch
   .word   02d6bh,0294ah,0294ah,02529h,02108h,01ce7h,01ce7h,018c6h
   .word   014a5h

VP_CUST9P:
   .word   12 
   .word   00000h,07d8ah,074e6h,06c62h,06400h,05c00h,05800h,05000h
   .word   04c00h,04400h,03c00h,03800h


SW_CUS10P:
   .word   12 
   .word   00000h,07de0h,07dc0h,07580h,06960h,06140h,05920h,05100h
   .word   044e0h,03ca0h,034a0h,02c80h

TR_CUS10P:
   .word   17 
   .word   00000h,03defh,035adh,0318ch,0294ah,02529h,01ce7h,018c6h
   .word   01084h,00842h,00421h,00000h,00000h,00000h,00000h,00000h
   .word   00000h

UN_CUS10P:
   .word   25 
   .word   00000h,07de0h,07dc0h,07dc0h,079a0h,075a0h,07180h,06d80h
   .word   06960h,06560h,06140h,05d40h,05920h,05500h,05100h,04ce0h
   .word   048e0h,044e0h,040c0h,03cc0h,038a0h,034a0h,03480h,03080h
   .word   02c80h

VP_CUS10P:
   .word   12 
   .word   00000h,07de0h,07dc0h,07580h,06960h,06140h,05920h,05100h
   .word   044e0h,03ca0h,034a0h,02c80h



;;Special defeated all 27 teams team:
;;
;;	LWWWWWW	scale610f_t,BV7,SHT4,DNK9,DEF8,SDEF3,DSKL4	;Can shatter
;;	WASP_P, UWASS_P_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,KMalone_h
;;	.word	5,9,8	
;;	LWWWWWW	scale611_t,BV8,SHT5,DNK10,DEF8,SDEF3,DSKL0
;;	.long	FL22_p, UN_6_p,UN_14_p, TR_3_p,TR_6_p,Kemp_h
;;	.word	3,8,6	
;;	LWWWWWW	scale71_t,BV7,SHT3,DNK8,DEF9,SDEF3,DSKL_3
;;	.long	FL43_p, UN_1_p,UN_14_p, TR_2_p,TR_11_p,Robinson_h
;;	.word	5,7,7	
;;
;;;	LWWWWWW	scale610_t,BV8,SHT5,DNK7,DEF9,SDEF7,DSKL1
;;;	.long	FL22_p, UN_1_p,UN_14_p, TR_2_p,TR_11_p,Rodman_h
;;;	.word	5,9,4
;;	LWWWWWW	scale610f_t,BV7,SHT7,DNK9,DEF5,SDEF5,DSKL3
;;	.long	FL2_p, UN_3_p,UN_14_p, TR_2b_p,TR_2b_p,Barkley_h
;;	.word	5,9,9	
;;
;;	LWWWWWW	scale610t_t,BV7,SHT6,DNK9,DEF6,SDEF5,DSKL3	;Can shatter
;;	.long	FL9_p, UN_1_p,UN_14_p, TR_4_p,TR_4_p,Drexler_h
;;	.word	5,4,6	
;;	LWWWWWW	scale67t_t,BV10,SHT8,DNK3,DEF4,SDEF7,DSKL2
;;	.long	FL34_p, UN_1_p,UN_14_p, TR_7_p,TR_7_p,AHard_h
;;	.word	8,2,5
;;	LWWWWWW	scale72f_t,BV7,SHT4,DNK9,DEF9,SDEF4,DSKL2	;Shatter
;;	.long	FL13_p, UN_5_p,UN_14_p, TR_5_p,TR_5_p,Ewing_h
;;	.word	2,8,9	
;;	LWWWWWW	scale61t_t,BV9,SHT7,DNK0,DEF1,SDEF7,DSKL0
;;	.long	FL36_p, UN_14_p,UN_5_p, TR_4_p,TR_4_p,KAnderson_h
;;	.word	9,2,5
;;	LWWWWWW	scale610f_t,BV7,SHT7,DNK8,DEF8,SDEF2,DSKL0
;;	.long	FL4_p, UN_14_p,UN_5_p, TR_4_p,TR_4_p,Coleman_h
;;	.word	2,9,8
;;	LWWWWWW	scale66_t,BV7,SHT9,DNK5,DEF6,SDEF8,DSKL2
;;	.long	FL33_p, UN_1_p,UN_14_p, TR_7_p,TR_7_p,NAnders_h
;;	.word	5,6,4	
;;	LWWWWWW	scale61_t,BV8,SHT9,DNK0,DEF0,SDEF10,DSKL4
;;	.long	FL49_p, UN_7_p,UN_14_p, TR_2_p,TR_10_p,Stockton_h
;;	.word	9,0,6	
;;	LWWWWWW	scale61_t,BV8,SHT7,DNK0,DEF0,SDEF7,DSKL3
;;	.long	FL2_p, UN_3_p,UN_14_p, TR_2b_p,TR_2b_p,KJohn_h
;;	.word	8,1,1	
;;	LWWWWWW	scale65_t,BV7,SHT7,DNK7,DEF7,SDEF7,DSKL0
;;	.long	FL14_p, UN_6_p,UN_14_p, TR_3_p,TR_6_p,Gill_h
;;	.word	6,6,6
;;	LWWWWWW	scale65_t,BV7,SHT9,DNK3,DEF2,SDEF5,DSKL_8
;;	.long	FL34_p, UN_5_p,UN_14_p, TR_2_p,TR_7_p,Rich_h
;;	.word	6,8,7	
;;	LWWWWWW	scale76et_t,BV7,SHT3,DNK9,DEF9,SDEF7,DSKL_9
;;	.long	FL27_p, UN_4_p,UN_14_p, TR_7_p,TR_4_p,Brad_h
;;	.word	6,5,1	
;;	LWWWWWW	scale57_t,BV10,SHT6,DNK10,DEF0,SDEF7,DSKL_8
;;	.long	FL52_p, UN_5_p,UN_14_p, TR_2_p,TR_7_p,Webb_h
;;	.word	3,0,4	
;;	LWWWWWW	scale63_t,BV8,SHT7,DNK0,DEF2,SDEF4,DSKL1
;;	.long	FL36_p, UN_9_p,UN_14_p, TR_4_p,TR_7_p,Dumars_h
;;	.word	5,3,8
;;	LWWWWWW	scale65t_t,BV8,SHT6,DNK3,DEF1,SDEF6,DSKL2
;;	.long	FL34_p, UN_5_p,UN_14_p, TR_5_p,TR_5_p,Starks_h
;;	.word	6,2,6	
;;	LWWWWWW	scale72_t,BV5,SHT1,DNK8,DEF9,SDEF2,DSKL_7	;Can shatter
;;	.long	FL32_p, UN_8_p,UN_14_p, TR_8_p,TR_7_p,Mutumbo_h
;;	.word	1,8,2	
;;	LWWWWWW	scale610_t,BV8,SHT6,DNK10,DEF8,SDEF4,DSKL0	;Can shatter
;;	.long	FL53_p, UN_4_p,UN_14_p, TR_2_p,TR_4_p,Wilkins_h
;;	.word	2,3,8	
;;	LWWWWWW	scale66_t,BV8,SHT7,DNK4,DEF7,SDEF8,DSKL0
;;	.long	FL41_p, UN_4_p,UN_14_p, TR_2_p,TR_4_p,RHarper_h
;;	.word	3,4,6	
;;	LWWWWWW	scale65_t,BV9,SHT4,DNK9,DEF5,SDEF5,DSKL_10
;;	.long	FL36_p, UN_5_p,UN_14_p, TR_2_p,TR_7_p,Rider_h
;;	.word	5,6,5
;;	LWWWWWW	scale67t_t,BV7,SHT9,DNK5,DEF4,SDEF5,DSKL0
;;	.long	FL30_p, UN_10_p,UN_14_p, TR_9_p,TR_7_p,Miller_h
;;	.word	6,4,8	
;;	LWWWWWW	scale610f_t,BV7,SHT7,DNK9,DEF5,SDEF3,DSKL0   	;Can shatter
;;	.long	FL25_p, UN_12_p,UN_14_p, TR_2_p,TR_7_p,LJohnson_h
;;	.word	3,9,7	
;;	LWWWWWW	scale71_t,BV8,SHT2,DNK9,DEF9,SDEF3,DSKL1
;;	.long	FL35_p, UN_4_p,UN_14_p, TR_9_p,TR_4_p,Olajuwon_h
;;	.word	4,8,8
;;	LWWWWWW	scale611t_t,BV7,SHT4,DNK7,DEF9,SDEF2,DSKL_2
;;	.long	FL2_p, UN_11_p,UN_14_p, TR_6_p,TR_6_p,Baker_h
;;	.word	1,2,2	
;;	LWWWWWW	scale62_t,BV8,SHT9,DNK0,DEF0,SDEF4,DSKL5
;;	.long	FL15_p, UN_4_p,UN_14_p, TR_2_p,TR_4_p,Armstrng_h
;;	.word	5,0,9	
;;	LWWWWWW	scale64t_t,BV6,SHT4,DNK1,DEF3,SDEF2,DSKL1
;;	.long	FL48_p, UN_4_p,UN_14_p, TR_9_p,TR_4_p,Maxwell_h
;;	.word	7,0,2	
;;	LWWWWWW	scale71_t,BV7,SHT5,DNK8,DEF9,SDEF4,DSKL0
;;	.long	FL34_p, UN_12_p,UN_14_p, TR_2_p,TR_7_p,Mourn_h
;;	.word	5,9,9	
;;	LWWWWWW	scale68f_t,BV7,SHT9,DNK5,DEF4,SDEF4,DSKL_6
;;	.long	FL42_p, UN_1_p,UN_14_p, TR_4_p,TR_4_p,Rice_h
;;	.word	2,3,8	
;;	LWWWWWW	scale62_t,BV9,SHT6,DNK0,DEF0,SDEF8,DSKL_4
;;	.long	FL17_p, UN_5_p,UN_14_p, TR_9_p,TR_7_p,Hardaway_h
;;	.word	5,4,6	
;;	LWWWWWW	scale66_t,BV8,SHT6,DNK1,DEF3,SDEF5,DSKL_11
;;	.long	FL34_p, UN_5_p,UN_14_p, TR_6_p,TR_6_p,Jack_h
;;	.word	9,5,6	
;;	LWWWWWW	scale68_t,BV8,SHT6,DNK10,DEF5,SDEF9,DSKL5	;Can shatter
;;	.long	FL38_p, UN_4_p,UN_14_p, TR_2_p,TR_4_p,Pippen_h
;;	.word	7,3,5	
;;	LWWWWWW	scale65f_t,BV9,SHT5,DNK9,DEF6,SDEF7,DSKL_6
;;	.long	FL44_p, UN_1_p,UN_14_p, TR_4_p,TR_4_p,Miner_h
;;	.word	7,2,8	
;;	LWWWWWW	scale60_t,BV10,SHT8,DNK0,DEF0,SDEF7,DSKL1
;;	.long	FL50_p, UN_9_p,UN_14_p, TR_4_p,TR_7_p,Thomas_h
;;	.word	8,1,9
;;	LWWWWWW	scale610f_t,BV8,SHT4,DNK8,DEF8,SDEF3,DSKL_4
;;	.long	FL17_p, UN_5_p,UN_14_p, TR_9_p,TR_7_p,Webber_h
;;	.word	7,9,0	
;;	LWWWWWW	scale68t_t,BV8,SHT8,DNK7,DEF6,SDEF3,DSKL_11
;;	.long	FL13_p, UN_5_p,UN_14_p, TR_6_p,TR_6_p,Mash_h
;;	.word	4,8,6	
;;	LWWWWWW	scale69_t,BV5,SHT7,DNK7,DEF5,SDEF5,DSKL1
;;	.long	FL54_p, UN_2_p,UN_15_p, TR_3_p,TR_10_p,Worthy_h
;;	.word	5,4,6	
;;	LWWWWWW	scale67_t,BV4,SHT10,DNK3,DEF3,SDEF4,DSKL_4
;;	.long	FL31_p, UN_5_p,UN_14_p, TR_9_p,TR_7_p,Mullin_h
;;	.word	5,5,9	
;;	LWWWWWW	scale610f_t,BV7,SHT7,DNK7,DEF5,SDEF4,DSKL0
;;	.long	FL28_p, UN_4_p,UN_14_p, TR_1_p,TR_4_p,Manning_h
;;	.word	2,6,7	



;;MORTAL KOMBAT
;;Scorpion
;	LWWWWWW	scale610_t,BV9,SHT11,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL31_p, UNI_SCO_P,UNI_SCO_P, TR__BLK_P,TR__BLK_P,SC_H
;	.word	2,3,8	
;Raiden
;	LWWWWWW	scale610_t,BV8,SHT11,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL31_p, UN_14_p,UN_14_p, TR_2_p,TR_2_p,RA_H
;	.word	2,3,8
;;Reptile
;	LWWWWWW	scale610_t,BV9,SHT11,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL31_p, UN_6_p,UN_6_p, TR__BLK_P,TR__BLK_P,RP_H
;	.word	2,3,8
;;Sub Zero
;	LWWWWWW	scale610_t,BV8,SHT11,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL47_p, UN_8_p,UN_8_p, TR__BLK_P,TR__BLK_P,SZ_H
;	.word	2,3,8	
;;Hoskins
;	LWWWWWW	scale62t_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL27_p, UN_7_p,UN_14_p, TR_2_p,TR_2_p,KH_H
;	.word	2,3,8	
;;Olivia
;	LWWWWWW	scale62_t,BV9,SHT10,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL3_p, UN_6_p,UN_14_p, TR_2_p,TR_2_p,OL_H
;	.word	2,3,8	
;;Turmell
;	LWWWWWW	scale70_t,BV10,SHT11,DNK10,DEF9,SDEF9,DSKL5
;	.long	FL27_p, UN_12_p,UN_14_p, TR_2_p,TR_7_p,mt_h
;	.word	9,9,9

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

; **NOTE***:
; **NOTE***:
;
;    if this tables HEAD img ptr. and there order are modified/changed
;   'our_heads_small' (in select2.asm) table needs to be updated.
;
; **NOTE***:
; **NOTE***:

spechds_t
	LWWWWWW	scale68_t,BV10,SHT9,DNK9,DEF8,SDEF6,DSKL5
	.long	JEFF_F, UN_CUST9P,UN_CUST9P, TR_CUST9P,TR_CUST9P,jeff_h
	.word	7,6,8	
	.long	SW_CUST9P,SW_CUST9P,VP_CUST9P,VP_CUST9P		;JOHNSON

	LWWWWWW	scale68f_t,BV10,SHT9,DNK9,DEF9,SDEF9,DSKL5
	.long	SAL_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,sd_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;DIVITA

	LWWWWWW	scale70t_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	TURMEL_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,turmel_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;TURMELL

	LWWWWWW	scale65et_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	DAN_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,dan_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;THOMPSON

	LWWWWWW	scale68f_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	EUGG_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,eug_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;GEER

	LWWWWWW	scale59_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	JOHNC_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,jcartn
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;CARLTON

	LWWWWWW	scale59_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	JEN_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,jfer_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;HEDRICK

	LWWWWWW	scale59_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	HEY_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,jhey_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;JOHN HEY

	LWWWWWW	scale70t_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	WIL_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,willy_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;AIR MORRIS

	LWWWWWW	scale70t_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	BARD_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,bardo_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;STEVE BARDO

	LWWWWWW	scale70t_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	MIN_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,min_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;MINIFEE

	LWWWWWW	scale58f_t,BV8,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	MARTY_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,marty_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;MARTINEZ

	LWWWWWW	scale65f_t,BV9,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	CARLOS_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,carlos_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;PESINA

	LWWWWWW	scale65t_t,BV9,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	WIZ_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Wiz_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;LIPTAK

	LWWWWWW	scale63f_t,BV9,SHT9,DNK9,DEF8,SDEF6,DSKL5
	.long	EDDIE_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,eddie_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;EDDIE

	LWWWWWW	scale66f_t,BV9,SHT9,DNK8,DEF7,SDEF6,DSKL5
	.long	MXV_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,mxv_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;MIKE V

	LWWWWWW	scale66_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	JAMIE_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,jamie_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;JAMIE

	LWWWWWW	scale66_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	NIK_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,nicke_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;NICK E.

	LWWWWWW	scale64et_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	ROOT_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,jroot_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;J. ROOT

	LWWWWWW	scale59_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	CARY_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,carym_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;MEDNICK

	LWWWWWW	scale69_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	ROH_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,roan_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;DAN ROAH

	LWWWWWW	scale65_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	PAT_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,patf_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;PAT F.

	LWWWWWW	scale66_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	BOON_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,edboon_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;ED BOON

	LWWWWWW	scale61_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	TOBIAS_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,jtobias_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;J. TOBIAS

	LWWWWWW	scale65_t,BV10,SHT9,DNK9,DEF7,SDEF6,DSKL5
	.long	OURSL_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,oursler_h
	.word	7,6,8	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;OURSLER

	LWWWWWW	scale65_t,BV8,SHT8,DNK8,DEF8,SDEF7,DSKL5
	.long	JASON_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,jason_h
	.word	7,7,7	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;JASON 

	LWWWWWW	scale67_t,BV8,SHT8,DNK8,DEF8,SDEF7,DSKL5
	.long	QUINN_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,quinn_h
	.word	7,7,7	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;QUINN

	LWWWWWW	scale68_t,BV8,SHT8,DNK8,DEF8,SDEF7,DSKL5
	.long	PERRY_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,mperry_h
	.word	7,7,7	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;M. PERRY

	LWWWWWW	scale68_t,BV8,SHT8,DNK8,DEF8,SDEF7,DSKL5
	.long	NEILF_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,neilf_h
	.word	7,7,7	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;N. FUNK

	LWWWWWW	scale68_t,BV8,SHT8,DNK8,DEF8,SDEF7,DSKL5
	.long	MDOC_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,mdoc_h
	.word	7,7,7	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;MDOC

	LWWWWWW	scale68_t,BV1,SHT2,DNK2,DEF2,SDEF7,DSKL5
	.long	BUD_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,bud_h
	.word	3,3,3	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;BUD

	LWWWWWW	scale611f_t,BV8,SHT7,DNK5,DEF4,SDEF7,DSKL5
	.long	OLD_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Old_h
	.word	6,6,6	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;MARIUS

;FIXX!!!
;Superstar guests
	LWWWWWW	scale67_t,BV8,SHT8,DNK9,DEF8,SDEF9,DSKL5
	.long	pippin_f, UN_CHIP_P,UN_CHIS_P, TR_CHIP_P,TR_CHIS_P,Pippen_h
	.word	7,6,8	
	.long	SW_CHIP_P,SW_CHIS_P,VP_CHIP_P,VP_CHIS_P		;PIPPEN

	LWWWWWW	scale68_t,BV7,SHT2,DNK3,DEF5,SDEF4,DSKL1
	.long	RODMAN_F, UN_CHIP_P,UN_CHIS_P, TR_CHIP_P,TR_CHIS_P,Rodman_h
	.word	4,9,3
	.long	SW_CHIP_P,SW_CHIS_P,VP_CHIP_P,VP_CHIS_P		;RODMAN

	LWWWWWW	scale67f_t,BV7,SHT7,DNK8,DEF5,SDEF4,DSKL0
	.long	johnson_f, UN_CHAP_P,UN_CHAS_P, TR_CHAP_P,TR_CHAS_P,LJohnson_h
	.word	7,8,8
	.long	SW_CHAP_P,SW_CHAS_P,VP_CHAP_P,VP_CHAS_P	 	;LARRY JOHNSON

	LWWWWWW	scale68_t,BV7,SHT10,DNK5,DEF2,SDEF6,DSKL_6
	.long	Rice_f, UN_CHAP_P,UN_CHAS_P, TR_CHAP_P,TR_CHAS_P,Rice_h
	.word	2,5,9	
	.long	SW_CHAP_P,SW_CHAS_P,VP_CHAP_P,VP_CHAS_P		;GLENN RICE

	LWWWWWW	scale64_t,BV9,SHT4,DNK5,DEF6,SDEF6,DSKL_11
	.long	KIDD_F, UN_DALP_P,UN_DALS_P, TR_DALP_P,TR_DALS_P,Kidd_h
	.word	8,4,8	
	.long	SW_DALP_P,SW_DALS_P,VP_DALP_P,VP_DALS_P		;JASON KIDD

	LWWWWWW	scale72t_t,BV6,SHT4,DNK8,DEF10,SDEF5,DSKL_7
	.long	Mutumbo_f, UN_DENP_P,UN_DENS_P, TR_DENP_P,TR_DENS_P,Mutumbo_h
	.word	3,9,7	
	.long	SW_DENP_P,SW_DENS_P,VP_DENP_P,VP_DENS_P		;MUTUMBO
							   	
	LWWWWWW	scale68_t,BV9,SHT8,DNK8,DEF5,SDEF8,DSKL1
	.long	GHILL_F, UN_DETP_P,UN_DETS_P, TR_DETP_P,TR_DETS_P,Ghill_h
	.word	8,5,9
	.long	SW_DETP_P,SW_DETS_P,VP_DETP_P,VP_DETS_P		;GRANT HILL

	LWWWWWW	scale70_t,BV7,SHT7,DNK8,DEF10,SDEF7,DSKL1
	.long	Hakeem_f, UN_HOUP_P,UN_HOUS_P, TR_HOUP_P,TR_HOUS_P,Olajuwon_h
	.word	7,10,7
	.long	SW_HOUP_P,SW_HOUS_P,VP_HOUP_P,VP_HOUS_P		;HAKEEN

	LWWWWWW	scale67t_t,BV7,SHT8,DNK6,DEF5,SDEF5,DSKL0
	.long	OMILLER_F, UN_INDP_P,UN_INDS_P, TR_INDP_P,TR_INDS_P,Miller_h
	.word	5,2,9	
	.long	SW_INDP_P,SW_INDS_P,VP_INDP_P,VP_INDS_P		;R. MILLER

	LWWWWWW	scale74f_t,BV5,SHT7,DNK3,DEF4,SDEF4,DSKL0
	.long	SMITS_F, UN_INDP_P,UN_INDS_P, TR_INDP_P,TR_INDS_P,Smits_h
	.word	2,9,9
	.long	SW_INDP_P,SW_INDS_P,VP_INDP_P,VP_INDS_P		;SMITS

	LWWWWWW	scale610f_t,BV8,SHT7,DNK9,DEF9,SDEF4,DSKL0
	.long	MOURN_F, UN_MIAP_P,UN_MIAS_P, TR_MIAP_P,TR_MIAS_P,Mourn_h
	.word	3,10,7
	.long	SW_MIAP_P,SW_MIAS_P,VP_MIAP_P,VP_MIAS_P		;MOURNING

	LWWWWWW	scale67f_t,BV6,SHT9,DNK6,DEF2,SDEF7,DSKL_2
	.long	GROBIN_F, UN_MILP_P,UN_MILS_P, TR_MILP_P,TR_MILS_P,Grobinson_h
	.word	4,7,8	
	.long	SW_MILP_P,SW_MILS_P,VP_MILP_P,VP_MILS_P		;G. ROBINSON

	LWWWWWW	scale57_t,BV10,SHT5,DNK9,DEF0,SDEF7,DSKL_8
	.long	Webb_f, UN_MINP_P,UN_MINS_P, TR_MINP_P,TR_MINS_P,Webb_h
	.word	6,0,5	
	.long	SW_MINP_P,SW_MINS_P,VP_MINP_P,VP_MINS_P		;SPUD WEBB

	LWWWWWW	scale70f_t,BV6,SHT7,DNK8,DEF10,SDEF4,DSKL2
	.long	ewing_f, UN_NEYP_P,UN_NEYS_P, TR_NEYP_P,TR_NEYS_P,Ewing_h
	.word	2,9,8	
	.long	SW_NEYP_P,SW_NEYS_P,VP_NEYP_P,VP_NEYS_P	  	;EWING

	LWWWWWW	scale65t_t,BV9,SHT7,DNK2,DEF2,SDEF7,DSKL2
	.long	STARKS_F, UN_NEYP_P,UN_NEYS_P, TR_NEYP_P,TR_NEYS_P,Starks_h
	.word	8,5,8	
	.long	SW_NEYP_P,SW_NEYS_P,VP_NEYP_P,VP_NEYS_P		;STARKS

	LWWWWWW	scale67t_t,BV10,SHT8,DNK8,DEF7,SDEF8,DSKL2
	.long	A_HARD_F, UN_ORLP_P,UN_ORLS_P, TR_ORLP_P,TR_ORLS_P,AHard_h
	.word	8,5,10
	.long	SW_ORLP_P,SW_ORLS_P,VP_ORLP_P,VP_ORLS_P		;A. HARDAWAY

	LWWWWWW	scale610_t,BV6,SHT5,DNK6,DEF8,SDEF4,DSKL5
	.long	GrantG_F, UN_ORLP_P,UN_ORLS_P, TR_ORLP_P,TR_ORLS_P,HCGrant_h
	.word	4,7,4	
	.long	SW_ORLP_P,SW_ORLS_P,VP_ORLP_P,VP_ORLS_P		;H. GRANT

	LWWWWWW	scale66_t,BV8,SHT7,DNK8,DEF3,SDEF5,DSKL_9
	.long	STACK_F, UN_PHLP_P,UN_PHLS_P, TR_PHLP_P,TR_PHLS_P,Stackhouse_h
	.word	5,4,7	
	.long	SW_PHLP_P,SW_PHLS_P,VP_PHLP_P,VP_PHLS_P		;STACKHOUSE

	LWWWWWW	scale610_t,BV8,SHT6,DNK6,DEF7,SDEF6,DSKL3
	.long	C_ROB_F, UN_PORP_P,UN_PORS_P, TR_PORP_P,TR_PORS_P,CRobinson_h
	.word	2,7,8	
	.long	SW_PORP_P,SW_PORS_P,VP_PORP_P,VP_PORS_P		;C. ROBINSON

	LWWWWWW	scale71_t,BV8,SHT8,DNK6,DEF10,SDEF5,DSKL_3
	.long	Robins_f, UN_SANP_P,UN_SANS_P, TR_SANP_P,TR_SANS_P,DRobinson_h
	.word	4,9,6
	.long	SW_SANP_P,SW_SANS_P,VP_SANP_P,VP_SANS_P		;D. ROBINSON

	LWWWWWW	scale68_t,BV8,SHT8,DNK7,DEF5,SDEF4,DSKL_3
	.long	Elliot_f, UN_SANP_P,UN_SANS_P, TR_SANP_P,TR_SANS_P,Elliot_h
	.word	2,4,8
	.long	SW_SANP_P,SW_SANS_P,VP_SANP_P,VP_SANS_P		;S. ELLIOT

	LWWWWWW	scale610_t,BV8,SHT8,DNK10,DEF9,SDEF6,DSKL0
	.long	kemp_f, UN_SEAP_P,UN_SEAS_P, TR_SEAP_P,TR_SEAS_P,Kemp_h
	.word	3,7,7	
	.long	SW_SEAP_P,SW_SEAS_P,VP_SEAP_P,VP_SEAS_P		;KEMP

	LWWWWWW	scale69ef_t,BV7,SHT8,DNK8,DEF5,SDEF8,DSKL4
	.long	kmalone_f, UN_UTAP_P,UN_UTAS_P, TR_UTAP_P,TR_UTAS_P,KMalone_h
	.word	6,10,7	
	.long	SW_UTAP_P,SW_UTAS_P,VP_UTAP_P,VP_UTAS_P		;K. MALONE

	LWWWWWW	scale610f_t,BV8,SHT8,DNK8,DEF4,SDEF6,DSKL_4
	.long	WEBBER_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Webber_h
	.word	6,8,7	
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;WEBBER

	LWWWWWW	scale77ef_t,BV4,SHT5,DNK2,DEF9,SDEF3,DSKL_5
	.long	MURESA_F, UN_WASP_P,UN_WASS_P, TR_WASP_P,TR_WASS_P,Muresan_h
	.word	1,9,4
	.long	SW_WASP_P,SW_WASS_P,VP_WASP_P,VP_WASS_P		;MURESAN

;These are superstar players (Or leftover art) that can be picked with name
;and pin # - allowing them to be 'traded' from team to team
;Make sure these guys work - get their birthdays for pin #'s
;	LWWWWWW	scale68_t,BV8,SHT11,DNK10,DEF5,SDEF9,DSKL5	;Can shatter
;	.long	NFL55_p, UN_CHIP_P,UN_CHIS_P, TR_CHIP_P,TR_CHIS_P,Pippen_h
;	.word	7,3,5	
;	.long	SW_CHIP_P,SW_CHIS_P,VP_CHIP_P,VP_CHIS_P
;	LWWWWWW	scale69_t,BV6,SHT5,DNK6,DEF8,SDEF5,DSKL0
;	.long	NFL55_p, UN_ATLP_P,UN_ATLS_P, TR_ATLP_P,TR_ATLS_P,Henderso_h
;	.word	4,4,3
;	.long	SW_ATLP_P,SW_ATLS_P,VP_ATLP_P,VP_ATLS_P
;	LWWWWWW	scale62f_t,BV6,SHT5,DNK5,DEF4,SDEF6,DSKL_6
;	.long	NFL55_p, UN_GLDP_P,UN_GLDS_P, TR_GLDP_P,TR_GLDS_P,Coles_h
;	.word	5,5,5	
;	.long	SW_GLDP_P,SW_GLDS_P,VP_GLDP_P,VP_GLDS_P
;	LWWWWWW	scale610_t,BV5,SHT5,DNK6,DEF6,SDEF3,DSKL_10
;	.long	NFL55_p, UN_ATLP_P,UN_ATLS_P, TR_ATLP_P,TR_ATLS_P,Rooks_h
;	.word	1,8,4
;	.long	SW_ATLP_P,SW_ATLS_P,VP_ATLP_P,VP_ATLS_P
;	LWWWWWW	scale68_t,BV7,SHT6,DNK5,DEF6,SDEF4,DSKL_6
;	.long	NFL55_p, UN_NEYP_P,UN_NEYS_P, TR_NEYP_P,TR_NEYS_P,WAnderson_h
;	.word	5,2,7	
;	.long	SW_NEYP_P,SW_NEYS_P,VP_NEYP_P,VP_NEYS_P
;	LWWWWWW	scale68f_t,BV5,SHT5,DNK6,DEF6,SDEF3,DSKL0
;	.long	NFL55_p, UN_ORLP_P,UN_ORLS_P, TR_ORLP_P,TR_ORLS_P,Gattison_h
;	.word	4,6,5
;	.long	SW_ORLP_P,SW_ORLS_P,VP_ORLP_P,VP_ORLS_P
;	LWWWWWW	scale66_t,BV8,SHT7,DNK5,DEF7,SDEF4,DSKL1
;	.long	NFL55_p, UN_LALP_P,UN_LALS_P, TR_LALP_P,TR_LALS_P,Ejones_h
;	.word	8,4,2	
;	.long	SW_LALP_P,SW_LALS_P,VP_LALP_P,VP_LALS_P
;	LWWWWWW	scale611_t,BV5,SHT4,DNK7,DEF7,SDEF4,DSKL_9
;	.long	NFL55_p, UN_TORP_P,UN_TORS_P, TR_TORP_P,TR_TORS_P,Wright_h
;	.word	4,5,4	
;	.long	SW_TORP_P,SW_TORS_P,VP_TORP_P,VP_TORS_P


****************************************************************

	.end
