**************************************************************
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
	.include	"shawn.hdr"		;Macros
	.asg		0,SEQT
	.include	"plyr.equ"
	.include	"imgpalp.asm"
	.include	"imgpal3.asm"
	.include	"imgtbl4.glo"
	.include	"plyrhd4.tbl"


;sounds external


;symbols externally defined

	.ref	scale74f_t,scale59_t,scale61f_t,scale63f_t
	.ref	scale57_t,scale58_t,scale60_t,scale61_t,scale61t_t,scale62_t
	.ref	scale62t_t,scale63_t,scale65_t,scale64t_t,scale64_t,scale67_t
	.ref	scale66_t,scale65t_t,scale67t_t,scale66t_t,scale65f_t
	.ref	scale67f_t,scale66f_t,scale69_t,scale69f_t,scale68f_t
	.ref	scale68t_t,scale68_t,scale611_t,scale610_t,scale611t_t
	.ref	scale610t_t,scale611f_t,scale610f_t,scale70t_t,scale70f_t
	.ref	scale70_t,scale71_t,scale72_t,scale76et_t,scale74_t,scale72f_t

	.ref	team1,team2
	.ref	Lohaus_h,Gug_h,Edwrd_h
	.ref	Worthy_h,Laetner_h,Hawkins_h,LJohnson_h,Divac_h,Seikaly_h
;McHale_h,Lewis_h,
	.ref	KMalone_h,Stockton_h,Ewing_h,RHarper_h
	.ref	Seikaly_h,Price_h,Rice_h,Miller_h,Mutumbo_h,Oakley_h,Olajuwon_h
	.ref	Skiles_h,Porter_h,Schrempf_h,Robinson_h,Tisdale_h
;Petrovic_h
	.ref	Webb_h,Smith_h,Thomas_h
	.ref	Kemp_h,Pippen_h,Gill_h,Daughert_h,Mullin_h,Wilkins_h
	.ref	Person_h,Augmon_h,Benjamin_h,Barkley_h,Coleman_h,Drexler_h
	.ref	Ellis_h,Elliot_h,Hardaway_h,DHarper_h,HCGrant_h,HVGrant_h
	.ref	Hornacek_h,Majerle_h,Manning_h

	.ref	McDan_h,Brown_h,KAnderson_h
	.ref	Willis_h,Gamble_h,Mourn_h,Armstrng_h,Kukoc_h,Nance_h,Jack_h
	.ref	Dumars_h,Rodman_h,Hunter_h,Webber_h,Maxwell_h,Horry_h,Smits_h
	.ref	Roberts_h,Peeler_h,Campbell_h,Miner_h,Baker_h,Day_h
	.ref	Mason_h,Starks_h,AHard_h,NAnders_h,Weath_h,Brad_h,KJohn_h
	.ref	Hurley_h,Rich_h,DEllis_h,Payton_h,Mckey_h,Benoit_h,Ellison_h
	.ref	Mash_h,Rogers_h,Cheaney_h,CRobin_h,Simmons_h,Rider_h,Morris_h
	.ref	Sealy_h


;symbols defined in this file

	.def	RA_H
	.def	spechds_t
	.def	ATL_t

	.def	lighten1
	.def	lighten2
	.def	lighten3
	.def	lighten4
	.def	lighten5
	.def	lighten6
	.def	lighten7


;uninitialized ram definitions


;equates for this file



	.text


;Speeds
	.asg	>1040->80+>42*1,BV
	.asg	>1040->80+>42*2,BV1
	.asg	>1040->80+>42*3,BV2
	.asg	>1040->80+>42*4,BV3
	.asg	>1040->80+>42*5,BV4
	.asg	>1040->80+>42*6,BV5
	.asg	>1040->80+>42*7,BV6
	.asg	>1040->80+>42*8,BV7
;MJT - 2/6/94!
	.asg	>1040->80+>42*10+>20,BV8
	.asg	>1040->80+>42*11+>30,BV9
	.asg	>1040->80+>42*12+>40,BV10

;Drone skills
	.asg	0,DSKL0
	.asg	1,DSKL1
	.asg	2,DSKL2
	.asg	3,DSKL3
	.asg	4,DSKL4
	.asg	5,DSKL5
	.asg	-1,DSKL_1
	.asg	-2,DSKL_2
	.asg	-3,DSKL_3
	.asg	-4,DSKL_4
	.asg	-5,DSKL_5
	.asg	-6,DSKL_6
	.asg	-7,DSKL_7
	.asg	-8,DSKL_8
	.asg	-9,DSKL_9
	.asg	-10,DSKL_10
	.asg	-11,DSKL_11

;Shot skill %
;	.asg	890,SHT0		;890
;	.asg	910,SHT1		;910
;	.asg	960,SHT2		;960
;	.asg	980,SHT3		;980
;	.asg	1000,SHT4		;1000
;	.asg	1020,SHT5		;1020
;	.asg	1040,SHT6		;1040
;	.asg	1060,SHT7
;	.asg	1070,SHT8
;	.asg	1090,SHT9
;	.asg	1150,SHT10

;12/15/93
;	.asg	820,SHT0		;890
;	.asg	840,SHT1		;910
;	.asg	890,SHT2		;960
;	.asg	930,SHT3		;980
;	.asg	1020,SHT4		;1000
;	.asg	1040,SHT5		;1020
;	.asg	1060,SHT6		;1040
;	.asg	1080,SHT7
;	.asg	1100,SHT8
;	.asg	1120,SHT9
;	.asg	1150,SHT10

;12/16/93
	.asg	860,SHT0		;890
	.asg	890,SHT1		;910
	.asg	920,SHT2		;960
	.asg	970,SHT3		;980
	.asg	1040,SHT4		;1000
	.asg	1070,SHT5		;1020
	.asg	1080,SHT6		;1040
	.asg	1100,SHT7
	.asg	1130,SHT8
	.asg	1150,SHT9
	.asg	1200,SHT10

	.asg	1201,SHT11		;MK SPECIAL FLAG

;Dunk ability
	.asg	0,DNK0
	.asg	1,DNK1
	.asg	2,DNK2
	.asg	3,DNK3
	.asg	4,DNK4
	.asg	5,DNK5
	.asg	6,DNK6
	.asg	7,DNK7
	.asg	8,DNK8
	.asg	9,DNK9
	.asg	10,DNK10

;Defensive block ability
	.asg	0,DEF0
	.asg	1,DEF1
	.asg	2,DEF2
	.asg	3,DEF3
	.asg	4,DEF4
	.asg	5,DEF5
	.asg	6,DEF6
	.asg	7,DEF7
	.asg	8,DEF8
	.asg	9,DEF9
	.asg	10,DEF10

;Defensive steal ability
;	.asg	180,SDEF0
;	.asg	185,SDEF1
;	.asg	190,SDEF2		;Old normal
;	.asg	195,SDEF3
;	.asg	200,SDEF4
;	.asg	205,SDEF5
;	.asg	210,SDEF6
;	.asg	215,SDEF7
;	.asg	220,SDEF8
;	.asg	225,SDEF9
;	.asg	230,SDEF10

;	.asg	160,SDEF0
;	.asg	170,SDEF1
;	.asg	180,SDEF2		;Old normal
;	.asg	195,SDEF3
;	.asg	200,SDEF4
;	.asg	205,SDEF5
;	.asg	215,SDEF6
;	.asg	245,SDEF7
;	.asg	260,SDEF8
;	.asg	285,SDEF9
;	.asg	300,SDEF10

	.asg	0,SDEF0
	.asg	1,SDEF1
	.asg	2,SDEF2		;Old normal
	.asg	3,SDEF3
	.asg	4,SDEF4
	.asg	5,SDEF5
	.asg	6,SDEF6
	.asg	7,SDEF7
	.asg	8,SDEF8
	.asg	9,SDEF9
	.asg	10,SDEF10


;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

ATL_t
	LWWWWWW	scale610f_t,BV7,SHT7,DNK7,DEF5,SDEF4,DSKL0
	.long	FL28_p, Un4_p,Un14_p, TR1_p,TR4_p,Manning_h
	.word	2,6,7	
	LWWWWWW	scale66t_t,BV10,SHT7,DNK2,DEF2,SDEF4,DSKL0
	.long	FL1_p, Un4_p,Un14_p, TR1_p,TR4_p,Augmon_h
	.word	5,1,5
	LWWWWWW	scale70f_t,BV6,SHT4,DNK6,DEF9,SDEF0,DSKL0
	.long	FL1_p, Un4_p,Un14_p, TR1_p,TR4_p,Willis_h
	.word	4,9,1

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;BOST_t
	LWWWWWW	scale61_t,BV8,SHT7,DNK8,DEF2,SDEF6,DSKL0
	.long	FL25_p, Un13_p,Un14_p, TR2_p,TR6_p,Brown_h
	.word	6,1,5	
	LWWWWWW	scale67_t,BV5,SHT5,DNK5,DEF9,SDEF3,DSKL0
	.long	FL25_p, Un13_p,Un14_p, TR2_p,TR6_p,McDan_h
	.word	1,8,8	
	LWWWWWW	scale65t_t,BV3,SHT7,DNK2,DEF4,SDEF4,DSKL0
	.long	FL18_p, Un13_p,Un14_p, TR2_p,TR6_p,Gamble_h
	.word	5,5,4

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;CHAR_t
	LWWWWWW	scale610f_t,BV7,SHT7,DNK9,DEF5,SDEF3,DSKL0   	;Can shatter
	.long	FL25_p, Un12_p,Un14_p, TR2_p,TR7_p,LJohnson_h
	.word	3,9,7	
	LWWWWWW	scale65t_t,BV7,SHT7,DNK0,DEF3,SDEF4,DSKL0
	.long	FL18_p, Un12_p,Un14_p, TR2_p,TR7_p,Hawkins_h
	.word	5,2,6	
	LWWWWWW	scale71_t,BV7,SHT5,DNK8,DEF9,SDEF4,DSKL0
	.long	FL34_p, Un12_p,Un14_p, TR2_p,TR7_p,Mourn_h
	.word	5,9,9	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;CHI_t
	LWWWWWW	scale68_t,BV8,SHT6,DNK10,DEF5,SDEF9,DSKL5	;Can shatter
	.long	FL38_p, Un4_p,Un14_p, TR2_p,TR4_p,Pippen_h
	.word	7,3,5	
	LWWWWWW	scale62_t,BV8,SHT9,DNK0,DEF0,SDEF4,DSKL5
	.long	FL15_p, Un4_p,Un14_p, TR2_p,TR4_p,Armstrng_h
	.word	5,0,9	
	LWWWWWW	scale611t_t,BV6,SHT5,DNK2,DEF7,SDEF4,DSKL5
	.long	FL40_p, Un4_p,Un14_p, TR2_p,TR4_p,Kukoc_h
	.word	9,4,4
	LWWWWWW	scale611_t,BV6,SHT1,DNK5,DEF9,SDEF2,DSKL5
	.long	FL15_p, Un4_p,Un14_p, TR2_p,TR4_p,HCGrant_h
	.word	2,9,4	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;CLEV_t
	LWWWWWW	scale60_t,BV8,SHT9,DNK0,DEF0,SDEF10,DSKL0
	.long	FL40_p, Un8_p,Un14_p, TR5_p,TR7_p,Price_h
	.word	8,2,9	
	LWWWWWW	scale70_t,BV7,SHT3,DNK8,DEF7,SDEF3,DSKL0
	.long	FL6_p,  Un8_p,Un14_p, TR5_p,TR7_p,Daughert_h
	.word	4,6,6	
	LWWWWWW	scale610_t,BV3,SHT4,DNK7,DEF9,SDEF3,DSKL0
	.long	FL6_p,  Un8_p,Un14_p, TR5_p,TR7_p,Nance_h
	.word	3,7,2	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;DAL_t
;	LWWWWWW	scale64_t,BV5,SHT5,DNK2,DEF3,SDEF4,DSKL_11
;	.long	FL5_p,  Un5_p,Un14_p, TR6_p,TR6_p,DHarper_h
;	.word	5,5,6	
	LWWWWWW	scale66_t,BV8,SHT6,DNK1,DEF3,SDEF5,DSKL_11
	.long	FL34_p, Un5_p,Un14_p, TR6_p,TR6_p,Jack_h
	.word	9,5,6	
	LWWWWWW	scale68t_t,BV8,SHT8,DNK7,DEF6,SDEF3,DSKL_11
	.long	FL13_p, Un5_p,Un14_p, TR6_p,TR6_p,Mash_h
	.word	4,8,6	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;DEN_t
	LWWWWWW	scale72_t,BV5,SHT1,DNK8,DEF9,SDEF2,DSKL_7	;Can shatter
	.long	FL32_p, Un8_p,Un14_p, TR8_p,TR7_p,Mutumbo_h
	.word	1,8,2	
	LWWWWWW	scale69f_t,BV6,SHT5,DNK6,DEF5,SDEF2,DSKL_7
	.long	FL12_p, Un8_p,Un14_p, TR8_p,TR7_p,Ellis_h
	.word	3,5,3	
	LWWWWWW	scale67_t,BV7,SHT5,DNK3,DEF3,SDEF3,DSKL_7
	.long	FL12_p, Un8_p,Un14_p, TR8_p,TR7_p,Rogers_h
	.word	4,7,1	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;DET_t
	LWWWWWW	scale60_t,BV10,SHT8,DNK0,DEF0,SDEF7,DSKL1
	.long	FL50_p, Un9_p,Un14_p, TR4_p,TR7_p,Thomas_h
	.word	8,1,9
	LWWWWWW	scale63_t,BV8,SHT7,DNK0,DEF2,SDEF4,DSKL1
	.long	FL36_p, Un9_p,Un14_p, TR4_p,TR7_p,Dumars_h
	.word	5,3,8
	LWWWWWW	scale69_t,BV7,SHT6,DNK6,DEF6,SDEF5,DSKL_3
	.long	FL10_p, Un9_p,Un14_p, TR4_p,TR7_p,Elliot_h
	.word	5,4,5
	LWWWWWW	scale62t_t,BV10,SHT5,DNK0,DEF0,SDEF4,DSKL1
	.long	FL42_p, Un9_p,Un14_p, TR4_p,TR7_p,Hunter_h
	.word	6,2,2
;	LWWWWWW	scale611f_t,BV,SHT6,DNK0,DEF5,SDEF1,DSKL1
;	.long	FL27_p, Un9_p,Un14_p, TR4_p,TR7_p,Laim_h
;	.word	4,9,6

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;GOLD_t
	LWWWWWW	scale62_t,BV9,SHT6,DNK0,DEF0,SDEF8,DSKL_4
	.long	FL17_p, Un5_p,Un14_p, TR9_p,TR7_p,Hardaway_h
	.word	5,4,6	
	LWWWWWW	scale67_t,BV4,SHT10,DNK3,DEF3,SDEF4,DSKL_4
	.long	FL31_p, Un5_p,Un14_p, TR9_p,TR7_p,Mullin_h
	.word	5,5,9	
	LWWWWWW	scale610f_t,BV8,SHT4,DNK8,DEF8,SDEF3,DSKL_4
	.long	FL17_p, Un5_p,Un14_p, TR9_p,TR7_p,Webber_h
	.word	7,9,0	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;HOU_t
	LWWWWWW	scale71_t,BV8,SHT2,DNK9,DEF9,SDEF3,DSKL1
	.long	FL35_p, Un4_p,Un14_p, TR9_p,TR4_p,Olajuwon_h
	.word	4,8,8
	LWWWWWW	scale64t_t,BV6,SHT4,DNK1,DEF3,SDEF2,DSKL1
	.long	FL48_p, Un4_p,Un14_p, TR9_p,TR4_p,Maxwell_h
	.word	7,0,2	
	LWWWWWW	scale610t_t,BV7,SHT6,DNK7,DEF7,SDEF4,DSKL1
	.long	FL48_p, Un4_p,Un14_p, TR9_p,TR4_p,Horry_h
	.word	5,6,4	
;	LWWWWWW	scale69_t,BV7,SHT6,DNK6,DEF6,SDEF5,DSKL_3
;	.long	FL10_p, Un4_p,Un14_p, TR9_p,TR4_p,Elliot_h
;	.word	5,4,5
	LWWWWWW	scale63_t,BV7,SHT8,DNK1,DEF3,SDEF4,DSKL1
	.long	FL48_p, Un4_p,Un14_p, TR9_p,TR4_p,Smith_h
	.word	7,2,4	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;IND_t
	LWWWWWW	scale67t_t,BV7,SHT9,DNK5,DEF4,SDEF5,DSKL0
	.long	FL30_p, Un10_p,Un14_p, TR9_p,TR7_p,Miller_h
	.word	6,4,8	
	LWWWWWW	scale68t_t,BV6,SHT4,DNK5,DEF6,SDEF1,DSKL0
	.long	FL30_p, Un10_p,Un14_p, TR9_p,TR7_p,Sealy_h
	.word	4,5,2	
	LWWWWWW	scale74_t,BV2,SHT2,DNK4,DEF8,SDEF1,DSKL0
	.long	FL45_p, Un10_p,Un14_p, TR9_p,TR7_p,Smits_h
	.word	3,7,6

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;LAC_t
	LWWWWWW	scale610_t,BV8,SHT6,DNK10,DEF8,SDEF4,DSKL0	;Can shatter
	.long	FL53_p, Un4_p,Un14_p, TR2_p,TR4_p,Wilkins_h
	.word	2,3,8	
	LWWWWWW	scale66_t,BV8,SHT7,DNK4,DEF7,SDEF8,DSKL0
	.long	FL41_p, Un4_p,Un14_p, TR2_p,TR4_p,RHarper_h
	.word	3,4,6	
	LWWWWWW	scale70f_t,BV1,SHT4,DNK3,DEF8,SDEF2,DSKL0
	.long	FL41_p, Un4_p,Un14_p, TR2_p,TR4_p,Roberts_h
	.word	3,9,2	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;LAL_t
	LWWWWWW	scale64_t,BV8,SHT7,DNK4,DEF2,SDEF4,DSKL1
	.long	FL54_p, Un2_p,Un15_p, TR3_p,TR10_p,Peeler_h
	.word	4,0,8	
	LWWWWWW	scale71_t,BV3,SHT5,DNK7,DEF7,SDEF4,DSKL1
	.long	FL8_p, Un2_p,Un15_p, TR3_p,TR10_p,Divac_h
	.word	2,6,8	
	LWWWWWW	scale70t_t,BV7,SHT4,DNK6,DEF9,SDEF2,DSKL1
	.long	FL54_p, Un2_p,Un15_p, TR3_p,TR10_p,Campbell_h
	.word	2,8,6	

;	LWWWWWW	scale69_t,BV4,SHT8,DNK2,DEF5,SDEF8,DSKL1
;	.long	FL54_p, Un2_p,Un15_p, TR3_p,TR10_p,Magic_h
;	.word	9,5,9	

	LWWWWWW	scale69_t,BV5,SHT7,DNK7,DEF5,SDEF5,DSKL1
	.long	FL54_p, Un2_p,Un15_p, TR3_p,TR10_p,Worthy_h
	.word	5,4,6	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;MIAMI_t
	LWWWWWW	scale68f_t,BV7,SHT9,DNK5,DEF4,SDEF4,DSKL_6
	.long	FL42_p, Un1_p,Un14_p, TR4_p,TR4_p,Rice_h
	.word	2,3,8	
	LWWWWWW	scale70_t,BV3,SHT3,DNK8,DEF8,SDEF3,DSKL_6
	.long	FL46_p, Un1_p,Un14_p, TR4_p,TR4_p,Seikaly_h
	.word	4,6,3	
	LWWWWWW	scale65f_t,BV9,SHT5,DNK9,DEF6,SDEF7,DSKL_6
	.long	FL44_p, Un1_p,Un14_p, TR4_p,TR4_p,Miner_h
	.word	7,2,8	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;MILW_t
	LWWWWWW	scale611t_t,BV7,SHT4,DNK7,DEF9,SDEF2,DSKL_2
	.long	FL2_p, Un11_p,Un14_p, TR6_p,TR6_p,Baker_h
	.word	1,2,2	
	LWWWWWW	scale68_t,BV4,SHT4,DNK3,DEF4,SDEF4,DSKL_2
	.long	FL2_p, Un11_p,Un14_p, TR6_p,TR6_p,Edwrd_h
	.word	5,5,5	
	LWWWWWW	scale66_t,BV6,SHT4,DNK5,DEF5,SDEF6,DSKL_2
	.long	FL2_p, Un11_p,Un14_p, TR6_p,TR6_p,Day_h
	.word	6,4,5	
	LWWWWWW	scale611_t,BV2,SHT4,DNK2,DEF8,SDEF1,DSKL_2
	.long	FL37_p, Un11_p,Un14_p, TR6_p,TR6_p,Lohaus_h
	.word	1,8,5	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;MINN_t
	LWWWWWW	scale611_t,BV5,SHT6,DNK4,DEF6,SDEF3,DSKL_10
	.long	FL24_p, Un5_p,Un14_p, TR2_p,TR7_p,Laetner_h
	.word	0,4,8	
	LWWWWWW	scale68f_t,BV5,SHT9,DNK5,DEF3,SDEF4,DSKL_10
	.long	FL36_p, Un5_p,Un14_p, TR2_p,TR7_p,Person_h
	.word	0,7,9	
	LWWWWWW	scale65_t,BV9,SHT4,DNK9,DEF5,SDEF5,DSKL_10
	.long	FL36_p, Un5_p,Un14_p, TR2_p,TR7_p,Rider_h
	.word	5,6,5

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;NJ_t
	LWWWWWW	scale610f_t,BV7,SHT7,DNK8,DEF8,SDEF2,DSKL0
	.long	FL4_p, Un14_p,Un5_p, TR4_p,TR4_p,Coleman_h
	.word	2,9,8
	LWWWWWW	scale61t_t,BV9,SHT7,DNK0,DEF1,SDEF7,DSKL0
	.long	FL36_p, Un14_p,Un5_p, TR4_p,TR4_p,KAnderson_h
	.word	9,2,5
	LWWWWWW	scale68f_t,BV2,SHT4,DNK4,DEF8,SDEF2,DSKL0
	.long	FL3_p, Un14_p,Un5_p, TR4_p,TR4_p,Morris_h
	.word	4,9,2
	LWWWWWW	scale72f_t,BV2,SHT4,DNK4,DEF6,SDEF2,DSKL0
	.long	FL3_p, Un14_p,Un5_p, TR4_p,TR4_p,Benjamin_h
	.word	3,9,2

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;NY_t
	LWWWWWW	scale72f_t,BV7,SHT4,DNK9,DEF9,SDEF4,DSKL2	;Shatter
	.long	FL13_p, Un5_p,Un14_p, TR5_p,TR5_p,Ewing_h
	.word	2,8,9	
	LWWWWWW	scale68f_t,BV4,SHT2,DNK4,DEF7,SDEF3,DSKL2
	.long	FL34_p, Un5_p,Un14_p, TR5_p,TR5_p,Mason_h
	.word	6,9,3	
;Pass ability, power, clutch
	LWWWWWW	scale65t_t,BV8,SHT6,DNK3,DEF1,SDEF6,DSKL2
	.long	FL34_p, Un5_p,Un14_p, TR5_p,TR5_p,Starks_h
	.word	6,2,6	
	LWWWWWW	scale610f_t,BV3,SHT1,DNK5,DEF8,SDEF1,DSKL2
	.long	FL34_p, Un5_p,Un14_p, TR5_p,TR5_p,Oakley_h
	.word	4,9,1
	LWWWWWW	scale64_t,BV5,SHT5,DNK2,DEF3,SDEF4,DSKL_11
	.long	FL5_p,  Un5_p,Un14_p, TR5_p,TR5_p,DHarper_h
	.word	5,5,6

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;ORL_t
;	LWWWWWW	scale72f_t,BV7,SHT0,DNK10,DEF9,SDEF4,DSKL2	;Can shatter
;	.long	FL33_p, Un1_p,Un14_p, TR7_p,TR7_p,ONeal_h
;	.word	3,9,3	

	LWWWWWW	scale67t_t,BV10,SHT8,DNK3,DEF4,SDEF7,DSKL2
	.long	FL34_p, Un1_p,Un14_p, TR7_p,TR7_p,AHard_h
	.word	8,2,5
	LWWWWWW	scale66_t,BV7,SHT9,DNK5,DEF6,SDEF8,DSKL2
	.long	FL33_p, Un1_p,Un14_p, TR7_p,TR7_p,NAnders_h
	.word	5,6,4	
	LWWWWWW	scale61_t,BV7,SHT9,DNK0,DEF1,SDEF8,DSKL2
	.long	FL47_p, Un1_p,Un14_p, TR7_p,TR7_p,Skiles_h
	.word	7,1,6	
;	LWWWWWW	scale60_t,BV3,SHT6,DNK0,DEF0,SDEF4,DSKL_11
;	.long	FL49_p, Un1_p,Un14_p, TR7_p,TR7_p,Iuz_h
;	.word	4,4,2	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;PHIL_t
	LWWWWWW	scale67f_t,BV5,SHT6,DNK6,DEF8,SDEF3,DSKL_9
	.long	FL18_p, Un4_p,Un14_p, TR7_p,TR4_p,Weath_h
	.word	2,8,2	
	LWWWWWW	scale76et_t,BV7,SHT3,DNK9,DEF9,SDEF7,DSKL_9
	.long	FL27_p, Un4_p,Un14_p, TR7_p,TR4_p,Brad_h
	.word	6,5,1	
;	LWWWWWW	scale65_t,BV6,SHT8,DNK0,DEF4,SDEF4,DSKL_9
;	.long	FL19_p, Un4_p,Un14_p, TR7_p,TR4_p,Hornacek_h
;	.word	7,3,6	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;PHX_t
	LWWWWWW	scale610f_t,BV7,SHT7,DNK9,DEF5,SDEF5,DSKL3
	.long	FL2_p, Un3_p,Un14_p, TR2b_p,TR2b_p,Barkley_h
	.word	5,9,9	
	LWWWWWW	scale66_t,BV5,SHT8,DNK4,DEF3,SDEF3,DSKL3
	.long	FL27_p, Un3_p,Un14_p, TR2b_p,TR2b_p,Majerle_h
	.word	4,5,9	
	LWWWWWW	scale61_t,BV8,SHT7,DNK0,DEF0,SDEF7,DSKL3
	.long	FL2_p, Un3_p,Un14_p, TR2b_p,TR2b_p,KJohn_h
	.word	8,1,1	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;PORT_t
	LWWWWWW	scale610t_t,BV7,SHT6,DNK9,DEF6,SDEF5,DSKL3	;Can shatter
	.long	FL9_p, Un1_p,Un14_p, TR4_p,TR4_p,Drexler_h
	.word	5,4,6	
	LWWWWWW	scale63_t,BV8,SHT8,DNK1,DEF0,SDEF8,DSKL3
	.long	FL39_p, Un1_p,Un14_p, TR4_p,TR4_p,Porter_h
	.word	8,4,3	
	LWWWWWW	scale610_t,BV5,SHT3,DNK7,DEF9,SDEF3,DSKL3
	.long	FL39_p, Un1_p,Un14_p, TR4_p,TR4_p,CRobin_h
	.word	4,9,2	
	LWWWWWW	scale69_t,BV5,SHT4,DNK6,DEF7,SDEF3,DSKL_5
	.long	FL16_p, Un1_p,Un14_p, TR4_p,TR4_p,HVGrant_h
	.word	4,7,6	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;SAC_t
	LWWWWWW	scale67_t,BV5,SHT1,DNK5,DEF5,SDEF6,DSKL_8	;Can shatter
	.long	FL52_p, Un5_p,Un14_p, TR2_p,TR7_p,Simmons_h
	.word	6,3,4	
	LWWWWWW	scale60_t,BV9,SHT6,DNK0,DEF0,SDEF9,DSKL_8
	.long	FL47_p, Un5_p,Un14_p, TR2_p,TR7_p,Hurley_h
	.word	8,2,8	
	LWWWWWW	scale65_t,BV7,SHT9,DNK3,DEF2,SDEF5,DSKL_8
	.long	FL34_p, Un5_p,Un14_p, TR2_p,TR7_p,Rich_h
	.word	6,8,7	
	LWWWWWW	scale610f_t,BV3,SHT3,DNK8,DEF5,SDEF2,DSKL_8
	.long	FL51_p, Un5_p,Un14_p, TR2_p,TR7_p,Tisdale_h
	.word	4,9,6	
	LWWWWWW	scale57_t,BV10,SHT6,DNK10,DEF0,SDEF7,DSKL_8
	.long	FL52_p, Un5_p,Un14_p, TR2_p,TR7_p,Webb_h
	.word	3,0,4	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;SANANT_t
	LWWWWWW	scale71_t,BV7,SHT3,DNK8,DEF9,SDEF3,DSKL_3
	.long	FL43_p, Un1_p,Un14_p, TR2_p,TR11_p,Robinson_h
	.word	5,7,7	
	LWWWWWW	scale610_t,BV8,SHT5,DNK7,DEF9,SDEF7,DSKL1
	.long	FL22_p, Un1_p,Un14_p, TR2_p,TR11_p,Rodman_h
	.word	5,9,4
	LWWWWWW	scale67_t,BV4,SHT9,DNK2,DEF5,SDEF5,DSKL_3
	.long	FL10_p, Un1_p,Un14_p, TR2_p,TR11_p,DEllis_h
	.word	5,5,5

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;SEA_t
	LWWWWWW	scale611_t,BV8,SHT5,DNK10,DEF8,SDEF3,DSKL0
	.long	FL22_p, Un6_p,Un14_p, TR3_p,TR6_p,Kemp_h
	.word	3,8,6	
	LWWWWWW	scale64_t,BV8,SHT5,DNK1,DEF1,SDEF7,DSKL0
	.long	FL22_p, Un6_p,Un14_p, TR3_p,TR6_p,Payton_h
	.word	8,5,4	
	LWWWWWW	scale65_t,BV7,SHT7,DNK7,DEF7,SDEF7,DSKL0
	.long	FL14_p, Un6_p,Un14_p, TR3_p,TR6_p,Gill_h
	.word	6,6,6
	LWWWWWW	scale610t_t,BV3,SHT6,DNK4,DEF6,SDEF4,DSKL0
	.long	FL45_p, Un6_p,Un14_p, TR3_p,TR6_p,Schrempf_h
	.word	5,8,6	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;UTAH_t
	LWWWWWW	scale610f_t,BV7,SHT4,DNK9,DEF8,SDEF3,DSKL4	;Can shatter
	.long	FL21_p, Un7_p,Un14_p, TR2_p,TR10_p,KMalone_h
	.word	5,9,8	
	LWWWWWW	scale61_t,BV8,SHT9,DNK0,DEF0,SDEF10,DSKL4
	.long	FL49_p, Un7_p,Un14_p, TR2_p,TR10_p,Stockton_h
	.word	9,0,6	
	LWWWWWW	scale68_t,BV5,SHT4,DNK4,DEF6,SDEF4,DSKL4
	.long	FL21_p, Un7_p,Un14_p, TR2_p,TR10_p,Benoit_h
	.word	3,4,3	
	LWWWWWW	scale65_t,BV6,SHT8,DNK0,DEF4,SDEF4,DSKL_9
	.long	FL19_p, Un7_p,Un14_p, TR2_p,TR10_p,Hornacek_h
	.word	7,3,6	

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

;WASH_t
	LWWWWWW	scale610_t,BV7,SHT7,DNK7,DEF5,SDEF4,DSKL_5
	.long	FL27_p, Un4_p,Un14_p, TR7_p,TR7_p,Gug_h
	.word	5,8,4
	LWWWWWW	scale610f_t,BV5,SHT2,DNK6,DEF9,SDEF1,DSKL_5
	.long	FL16_p, Un4_p,Un14_p, TR7_p,TR7_p,Ellison_h
	.word	3,8,5
	LWWWWWW	scale67_t,BV8,SHT8,DNK3,DEF4,SDEF7,DSKL_5
	.long	FL16_p, Un4_p,Un14_p, TR7_p,TR7_p,Cheaney_h
	.word	5,2,8

;Special defeated all 27 teams team:

	LWWWWWW	scale610f_t,BV7,SHT4,DNK9,DEF8,SDEF3,DSKL4	;Can shatter
	.long	FL21_p, Un7_p,Un14_p, TR2_p,TR10_p,KMalone_h
	.word	5,9,8	
	LWWWWWW	scale611_t,BV8,SHT5,DNK10,DEF8,SDEF3,DSKL0
	.long	FL22_p, Un6_p,Un14_p, TR3_p,TR6_p,Kemp_h
	.word	3,8,6	
	LWWWWWW	scale71_t,BV7,SHT3,DNK8,DEF9,SDEF3,DSKL_3
	.long	FL43_p, Un1_p,Un14_p, TR2_p,TR11_p,Robinson_h
	.word	5,7,7	
	LWWWWWW	scale610f_t,BV7,SHT7,DNK9,DEF5,SDEF5,DSKL3
	.long	FL2_p, Un3_p,Un14_p, TR2b_p,TR2b_p,Barkley_h
	.word	5,9,9	
	LWWWWWW	scale610t_t,BV7,SHT6,DNK9,DEF6,SDEF5,DSKL3	;Can shatter
	.long	FL9_p, Un1_p,Un14_p, TR4_p,TR4_p,Drexler_h
	.word	5,4,6	
	LWWWWWW	scale67t_t,BV10,SHT8,DNK3,DEF4,SDEF7,DSKL2
	.long	FL34_p, Un1_p,Un14_p, TR7_p,TR7_p,AHard_h
	.word	8,2,5
	LWWWWWW	scale72f_t,BV7,SHT4,DNK9,DEF9,SDEF4,DSKL2	;Shatter
	.long	FL13_p, Un5_p,Un14_p, TR5_p,TR5_p,Ewing_h
	.word	2,8,9	
	LWWWWWW	scale61t_t,BV9,SHT7,DNK0,DEF1,SDEF7,DSKL0
	.long	FL36_p, Un14_p,Un5_p, TR4_p,TR4_p,KAnderson_h
	.word	9,2,5
	LWWWWWW	scale610f_t,BV7,SHT7,DNK8,DEF8,SDEF2,DSKL0
	.long	FL4_p, Un14_p,Un5_p, TR4_p,TR4_p,Coleman_h
	.word	2,9,8
	LWWWWWW	scale66_t,BV7,SHT9,DNK5,DEF6,SDEF8,DSKL2
	.long	FL33_p, Un1_p,Un14_p, TR7_p,TR7_p,NAnders_h
	.word	5,6,4	
	LWWWWWW	scale61_t,BV8,SHT9,DNK0,DEF0,SDEF10,DSKL4
	.long	FL49_p, Un7_p,Un14_p, TR2_p,TR10_p,Stockton_h
	.word	9,0,6	
	LWWWWWW	scale61_t,BV8,SHT7,DNK0,DEF0,SDEF7,DSKL3
	.long	FL2_p, Un3_p,Un14_p, TR2b_p,TR2b_p,KJohn_h
	.word	8,1,1	
	LWWWWWW	scale65_t,BV7,SHT7,DNK7,DEF7,SDEF7,DSKL0
	.long	FL14_p, Un6_p,Un14_p, TR3_p,TR6_p,Gill_h
	.word	6,6,6
	LWWWWWW	scale65_t,BV7,SHT9,DNK3,DEF2,SDEF5,DSKL_8
	.long	FL34_p, Un5_p,Un14_p, TR2_p,TR7_p,Rich_h
	.word	6,8,7	
	LWWWWWW	scale76et_t,BV7,SHT3,DNK9,DEF9,SDEF7,DSKL_9
	.long	FL27_p, Un4_p,Un14_p, TR7_p,TR4_p,Brad_h
	.word	6,5,1	
	LWWWWWW	scale57_t,BV10,SHT6,DNK10,DEF0,SDEF7,DSKL_8
	.long	FL52_p, Un5_p,Un14_p, TR2_p,TR7_p,Webb_h
	.word	3,0,4	
	LWWWWWW	scale63_t,BV8,SHT7,DNK0,DEF2,SDEF4,DSKL1
	.long	FL36_p, Un9_p,Un14_p, TR4_p,TR7_p,Dumars_h
	.word	5,3,8
	LWWWWWW	scale65t_t,BV8,SHT6,DNK3,DEF1,SDEF6,DSKL2
	.long	FL34_p, Un5_p,Un14_p, TR5_p,TR5_p,Starks_h
	.word	6,2,6	
	LWWWWWW	scale72_t,BV5,SHT1,DNK8,DEF9,SDEF2,DSKL_7	;Can shatter
	.long	FL32_p, Un8_p,Un14_p, TR8_p,TR7_p,Mutumbo_h
	.word	1,8,2	
	LWWWWWW	scale610_t,BV8,SHT6,DNK10,DEF8,SDEF4,DSKL0	;Can shatter
	.long	FL53_p, Un4_p,Un14_p, TR2_p,TR4_p,Wilkins_h
	.word	2,3,8	
	LWWWWWW	scale66_t,BV8,SHT7,DNK4,DEF7,SDEF8,DSKL0
	.long	FL41_p, Un4_p,Un14_p, TR2_p,TR4_p,RHarper_h
	.word	3,4,6	
	LWWWWWW	scale65_t,BV9,SHT4,DNK9,DEF5,SDEF5,DSKL_10
	.long	FL36_p, Un5_p,Un14_p, TR2_p,TR7_p,Rider_h
	.word	5,6,5
	LWWWWWW	scale67t_t,BV7,SHT9,DNK5,DEF4,SDEF5,DSKL0
	.long	FL30_p, Un10_p,Un14_p, TR9_p,TR7_p,Miller_h
	.word	6,4,8	
	LWWWWWW	scale610f_t,BV7,SHT7,DNK9,DEF5,SDEF3,DSKL0   	;Can shatter
	.long	FL25_p, Un12_p,Un14_p, TR2_p,TR7_p,LJohnson_h
	.word	3,9,7	
	LWWWWWW	scale71_t,BV8,SHT2,DNK9,DEF9,SDEF3,DSKL1
	.long	FL35_p, Un4_p,Un14_p, TR9_p,TR4_p,Olajuwon_h
	.word	4,8,8
	LWWWWWW	scale611t_t,BV7,SHT4,DNK7,DEF9,SDEF2,DSKL_2
	.long	FL2_p, Un11_p,Un14_p, TR6_p,TR6_p,Baker_h
	.word	1,2,2	
	LWWWWWW	scale62_t,BV8,SHT9,DNK0,DEF0,SDEF4,DSKL5
	.long	FL15_p, Un4_p,Un14_p, TR2_p,TR4_p,Armstrng_h
	.word	5,0,9	
	LWWWWWW	scale64t_t,BV6,SHT4,DNK1,DEF3,SDEF2,DSKL1
	.long	FL48_p, Un4_p,Un14_p, TR9_p,TR4_p,Maxwell_h
	.word	7,0,2	
	LWWWWWW	scale71_t,BV7,SHT5,DNK8,DEF9,SDEF4,DSKL0
	.long	FL34_p, Un12_p,Un14_p, TR2_p,TR7_p,Mourn_h
	.word	5,9,9	
	LWWWWWW	scale68f_t,BV7,SHT9,DNK5,DEF4,SDEF4,DSKL_6
	.long	FL42_p, Un1_p,Un14_p, TR4_p,TR4_p,Rice_h
	.word	2,3,8	
	LWWWWWW	scale62_t,BV9,SHT6,DNK0,DEF0,SDEF8,DSKL_4
	.long	FL17_p, Un5_p,Un14_p, TR9_p,TR7_p,Hardaway_h
	.word	5,4,6	
	LWWWWWW	scale66_t,BV8,SHT6,DNK1,DEF3,SDEF5,DSKL_11
	.long	FL34_p, Un5_p,Un14_p, TR6_p,TR6_p,Jack_h
	.word	9,5,6	
	LWWWWWW	scale68_t,BV8,SHT6,DNK10,DEF5,SDEF9,DSKL5	;Can shatter
	.long	FL38_p, Un4_p,Un14_p, TR2_p,TR4_p,Pippen_h
	.word	7,3,5	
	LWWWWWW	scale65f_t,BV9,SHT5,DNK9,DEF6,SDEF7,DSKL_6
	.long	FL44_p, Un1_p,Un14_p, TR4_p,TR4_p,Miner_h
	.word	7,2,8	
	LWWWWWW	scale60_t,BV10,SHT8,DNK0,DEF0,SDEF7,DSKL1
	.long	FL50_p, Un9_p,Un14_p, TR4_p,TR7_p,Thomas_h
	.word	8,1,9
	LWWWWWW	scale610f_t,BV8,SHT4,DNK8,DEF8,SDEF3,DSKL_4
	.long	FL17_p, Un5_p,Un14_p, TR9_p,TR7_p,Webber_h
	.word	7,9,0	
	LWWWWWW	scale68t_t,BV8,SHT8,DNK7,DEF6,SDEF3,DSKL_11
	.long	FL13_p, Un5_p,Un14_p, TR6_p,TR6_p,Mash_h
	.word	4,8,6	
	LWWWWWW	scale69_t,BV5,SHT7,DNK7,DEF5,SDEF5,DSKL1
	.long	FL54_p, Un2_p,Un15_p, TR3_p,TR10_p,Worthy_h
	.word	5,4,6	
	LWWWWWW	scale67_t,BV4,SHT10,DNK3,DEF3,SDEF4,DSKL_4
	.long	FL31_p, Un5_p,Un14_p, TR9_p,TR7_p,Mullin_h
	.word	5,5,9	
	LWWWWWW	scale610f_t,BV7,SHT7,DNK7,DEF5,SDEF4,DSKL0
	.long	FL28_p, Un4_p,Un14_p, TR1_p,TR4_p,Manning_h
	.word	2,6,7	



;;MORTAL KOMBAT
;;Scorpion
;	LWWWWWW	scale610_t,BV9,SHT11,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL31_p, UNI_SCO_P,UNI_SCO_P, TR_BLK_P,TR_BLK_P,SC_H
;	.word	2,3,8	
;;Raiden
;	LWWWWWW	scale610_t,BV8,SHT11,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL31_p, Un14_p,Un14_p, TR2_p,TR2_p,RA_H
;	.word	2,3,8
;;Reptile
;	LWWWWWW	scale610_t,BV9,SHT11,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL31_p, Un6_p,Un6_p, TR_BLK_P,TR_BLK_P,RP_H
;	.word	2,3,8
;;Sub Zero
;	LWWWWWW	scale610_t,BV8,SHT11,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL47_p, Un8_p,Un8_p, TR_BLK_P,TR_BLK_P,SZ_H
;	.word	2,3,8	
;;Hoskins
;	LWWWWWW	scale62t_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,KH_H
;	.word	2,3,8	
;;Olivia
;	LWWWWWW	scale62_t,BV9,SHT10,DNK10,DEF8,SDEF6,DSKL5
;	.long	FL3_p, Un6_p,Un14_p, TR2_p,TR2_p,OL_H
;	.word	2,3,8	
;;Turmell
;	LWWWWWW	scale70_t,BV10,SHT11,DNK10,DEF9,SDEF9,DSKL5
;	.long	FL27_p, Un12_p,Un14_p, TR2_p,TR7_p,mt_h
;	.word	9,9,9

;Size, speed, shot%, dunks, block defense, steals, drone skill
;Pass ability, power, clutch

spechds_t
	LWWWWWW	scale610_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL49_p, Un1_p,Un14_p, TR7_p,TR7_p,tg_h
	.word	2,3,8	
	LWWWWWW	scale66_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un6_p,Un6_p, TR2b_p,TR2b_p,jr_h
	.word	2,3,8
 	LWWWWWW	scale58_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL49_p, Un4_p,Un1_p, TR2_p,TR1_p,jc_h
	.word	2,3,8	
	LWWWWWW	scale610_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL49_p, Un1_p,Un1_p, TR4_p,TR4_p,sd_h
	.word	9,9,8	
	LWWWWWW	scale72_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL49_p, Un6_p,Un6_p, TR2b_p,TR2b_p,sl_h
	.word	2,3,8	
	LWWWWWW	scale70_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un2_p,Un2_p, TR3_p,TR3_p,mt_h
	.word	9,9,8	
	LWWWWWW	scale63_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL49_p, Un6_p,Un6_p, TR2b_p,TR2b_p,jh_h
	.word	2,3,8
	LWWWWWW	scale66_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un2_p,Un2_p, TR3_p,TR3_p,gp_h
	.word	2,3,8
	LWWWWWW	scale610f_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un2_p,Un2_p, TR3_p,TR3_p,jn_h
	.word	2,3,8	
	LWWWWWW	scale66f_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un2_p,Un2_p, TR3_p,TR3_p,so_h
	.word	2,3,8	
	LWWWWWW	scale64_t,BV7,SHT5,DNK4,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,AL_H		;LASKO
	.word	2,3,8	
	LWWWWWW	scale610t_t,BV9,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL36_p, Un4_p,Un1_p, TR2_p,TR1_p,wi_h
	.word	2,3,8	
	LWWWWWW	scale64_t,BV7,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,CM_H
	.word	2,3,8	
	LWWWWWW	scale62_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,DF_H
	.word	2,3,8	
	LWWWWWW	scale62t_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,EK_H
	.word	2,3,8	
	LWWWWWW	scale67_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,EJ_H
	.word	2,3,8	
;Sub Zero
	LWWWWWW	scale610_t,BV8,SHT11,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un8_p,Un8_p, TR_BLK_P,TR_BLK_P,SZ_H
	.word	2,3,8	
	LWWWWWW	scale65f_t,BV8,SHT9,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,JH_H
	.word	2,3,8	
	LWWWWWW	scale64_t,BV8,SHT9,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,JS_H
	.word	2,3,8	
	LWWWWWW	scale65f_t,BV8,SHT8,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,JG_H
	.word	2,3,8	
	LWWWWWW	scale64_t,BV8,SHT8,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,JGE_H
	.word	2,3,8	
	LWWWWWW	scale65f_t,BV7,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,JD_H
	.word	2,3,8	
	LWWWWWW	scale62_t,BV7,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,JL_H
	.word	2,3,8	
	LWWWWWW	scale66t_t,BV7,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,JV_H
	.word	2,3,8	
	LWWWWWW	scale64t_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,JT_H
	.word	2,3,8	
	LWWWWWW	scale65f_t,BV7,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,LD_H
	.word	2,3,8	
	LWWWWWW	scale60_t,BV7,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,LDE_H
	.word	2,3,8	
	LWWWWWW	scale65f_t,BV8,SHT8,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,MB_H
	.word	2,3,8	
	LWWWWWW	scale66f_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,ML_H
	.word	2,3,8	
	LWWWWWW	scale65_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,MP_H
	.word	2,3,8	
	LWWWWWW	scale65_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,PB_H
	.word	2,3,8	
	LWWWWWW	scale65t_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,PC_H
	.word	2,3,8
;Raiden
	LWWWWWW	scale610_t,BV8,SHT11,DNK10,DEF8,SDEF6,DSKL5
	.long	FL31_p, Un14_p,Un14_p, TR2_p,TR2_p,RA_H
	.word	2,3,8
	LWWWWWW	scale72f_t,BV9,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL_RPR_P, Un7_p,Un14_p, TR2_p,TR2_p,RE_H
	.word	2,3,8
	LWWWWWW	scale66_t,BV7,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,RM_H
	.word	2,3,8
	LWWWWWW	scale64_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,RS_H
	.word	2,3,8	
	LWWWWWW	scale610t_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,SB_H
	.word	2,3,8	
	LWWWWWW	scale65f_t,BV1,SHT1,DNK1,DEF1,SDEF1,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,TC_H
	.word	2,3,8	
	LWWWWWW	scale74f_t,BV10,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL23_p, Un7_p,Un14_p, TR2_p,TR2_p,KO_H
	.word	2,3,8	
	LWWWWWW	scale60_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,VP_H
	.word	2,3,8
	LWWWWWW	scale67t_t,BV9,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,EL_H
	.word	2,3,8	
	LWWWWWW	scale66f_t,BV7,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,WD_H
	.word	2,3,8	
	LWWWWWW	scale66_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,EB_H
	.word	2,3,8	
	LWWWWWW	scale63_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,JTO_H
	.word	2,3,8	
	LWWWWWW	scale66f_t,BV3,SHT1,DNK1,DEF1,SDEF1,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,PH_H
	.word	2,3,8	
	LWWWWWW	scale610t_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,BD_H
	.word	2,3,8	
	LWWWWWW	scale65f_t,BV6,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,MM_H
	.word	2,3,8	
	LWWWWWW	scale60_t,BV6,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL45_p, Un7_p,Un14_p, TR2_p,TR2_p,RD_H
	.word	2,3,8	
	LWWWWWW	scale62t_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,KH_H
	.word	2,3,8	
	LWWWWWW	scale62_t,BV9,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL3_p, Un7_p,Un14_p, TR2_p,TR2_p,OL_H
	.word	2,3,8	
;Scorpion
	LWWWWWW	scale610_t,BV9,SHT11,DNK10,DEF8,SDEF6,DSKL5
	.long	FL31_p, UNI_SCO_P,UNI_SCO_P, TR_BLK_P,TR_BLK_P,SC_H
	.word	2,3,8	
;Reptile
	LWWWWWW	scale610_t,BV9,SHT11,DNK10,DEF8,SDEF6,DSKL5
	.long	FL31_p, Un6_p,Un6_p, TR_BLK_P,TR_BLK_P,RP_H
	.word	2,3,8
	LWWWWWW	scale65f_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,CG_H
	.word	2,3,8	
	LWWWWWW	scale60_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,RG_H
	.word	2,3,8
	LWWWWWW	scale67t_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL47_p, Un7_p,Un14_p, TR2_p,TR2_p,JSK_H
	.word	9,9,8
	LWWWWWW	scale62t_t,BV8,SHT10,DNK10,DEF8,SDEF6,DSKL5
	.long	FL27_p, Un7_p,Un14_p, TR2_p,TR2_p,JLI_H
	.word	2,3,8


;Superstar guests

	LWWWWWW	scale610_t,BV7,SHT11,DNK10,DEF8,SDEF4,DSKL0	;Can shatter
	.long	FL53_p, Un4_p,Un14_p, TR1_p,TR4_p,Wilkins_h
	.word	2,3,8	
	LWWWWWW	scale61_t,BV8,SHT11,DNK8,DEF2,SDEF6,DSKL0
	.long	FL25_p, Un13_p,Un14_p, TR2_p,TR6_p,Brown_h
	.word	6,1,5	
	LWWWWWW	scale71_t,BV7,SHT11,DNK8,DEF9,SDEF4,DSKL0
	.long	FL34_p, Un12_p,Un14_p, TR2_p,TR7_p,Mourn_h
	.word	5,9,9	
	LWWWWWW	scale68_t,BV8,SHT11,DNK10,DEF5,SDEF9,DSKL5	;Can shatter
	.long	FL38_p, Un4_p,Un14_p, TR2_p,TR4_p,Pippen_h
	.word	7,3,5	
	LWWWWWW	scale60_t,BV10,SHT11,DNK0,DEF0,SDEF7,DSKL1
	.long	FL50_p, Un9_p,Un14_p, TR4_p,TR7_p,Thomas_h
	.word	8,1,9
	LWWWWWW	scale610f_t,BV7,SHT11,DNK8,DEF8,SDEF3,DSKL_4
	.long	FL17_p, Un5_p,Un14_p, TR9_p,TR7_p,Webber_h
	.word	5,8,0	
	LWWWWWW	scale71_t,BV8,SHT11,DNK9,DEF9,SDEF3,DSKL1
	.long	FL35_p, Un4_p,Un14_p, TR9_p,TR4_p,Olajuwon_h
	.word	4,8,8
	LWWWWWW	scale610f_t,BV7,SHT11,DNK8,DEF8,SDEF2,DSKL0
	.long	FL4_p, Un14_p,Un5_p, TR4_p,TR4_p,Coleman_h
	.word	2,9,8
	LWWWWWW	scale72f_t,BV7,SHT11,DNK9,DEF9,SDEF4,DSKL2	;Shatter
	.long	FL13_p, Un5_p,Un14_p, TR5_p,TR5_p,Ewing_h
	.word	2,8,9	
	LWWWWWW	scale610f_t,BV6,SHT11,DNK9,DEF5,SDEF5,DSKL3
	.long	FL2_p, Un3_p,Un14_p, TR2b_p,TR2b_p,Barkley_h
	.word	5,9,9	
	LWWWWWW	scale71_t,BV7,SHT11,DNK8,DEF9,SDEF3,DSKL_3
	.long	FL43_p, Un1_p,Un14_p, TR2_p,TR11_p,Robinson_h
	.word	5,7,7	
	LWWWWWW	scale611_t,BV8,SHT11,DNK10,DEF8,SDEF3,DSKL0
	.long	FL22_p, Un6_p,Un14_p, TR3_p,TR6_p,Kemp_h
	.word	3,8,6	
	LWWWWWW	scale610f_t,BV6,SHT11,DNK9,DEF8,SDEF3,DSKL4	;Can shatter
	.long	FL21_p, Un7_p,Un14_p, TR2_p,TR10_p,KMalone_h
	.word	5,9,8	


AL_H	;LASKO
	.long	ALLASC01
	.long	ALLASC01,ALLASC02,ALLASC03,ALLASC04,ALLASC05
	.long	ALLASC01,ALLASC02,ALLASC03,ALLASC04,ALLASC05
	.long	ALLASC01,ALLASC02,ALLASC03,ALLASC04,ALLASC05
	.long	ALLASC03
CM_H	;MEDNICK
	.long	CARMED01
	.long	CARMED01,CARMED02,CARMED03,CARMED04,CARMED05
	.long	CARMED01,CARMED02,CARMED03,CARMED04,CARMED05
	.long	CARMED01,CARMED02,CARMED03,CARMED04,CARMED05
	.long	CARMED16
DF_H	;FORDEN
	.long	DANFOR01
	.long	DANFOR01,DANFOR02,DANFOR03,DANFOR04,DANFOR05
	.long	DANFOR01,DANFOR02,DANFOR03,DANFOR04,DANFOR05
	.long	DANFOR01,DANFOR02,DANFOR03,DANFOR04,DANFOR05
	.long	DANFOR16
EK_H	;KINKEAD
	.long	ERCKIN01
	.long	ERCKIN01,ERCKIN02,ERCKIN03,ERCKIN04,ERCKIN05
	.long	ERCKIN01,ERCKIN02,ERCKIN03,ERCKIN04,ERCKIN05
	.long	ERCKIN01,ERCKIN02,ERCKIN03,ERCKIN04,ERCKIN05
	.long	ERCKIN16
EJ_H	;JARVIS
	.long	EUGENE01
	.long	EUGENE01,EUGENE02,EUGENE03,EUGENE04,EUGENE05
	.long	EUGENE01,EUGENE02,EUGENE03,EUGENE04,EUGENE05
	.long	EUGENE01,EUGENE02,EUGENE03,EUGENE04,EUGENE05
	.long	EUGENE16
SZ_H	;SUBZERO
	.long	SUBZER01
	.long	SUBZER01,SUBZER02,SUBZER03,SUBZER04,SUBZER05
	.long	SUBZER01,SUBZER02,SUBZER03,SUBZER04,SUBZER05
	.long	SUBZER01,SUBZER02,SUBZER03,SUBZER04,SUBZER05
	.long	SUBZER16
JH_H	;HAEGER
	.long	JACHAG01
	.long	JACHAG01,JACHAG02,JACHAG03,JACHAG04,JACHAG05
	.long	JACHAG01,JACHAG02,JACHAG03,JACHAG04,JACHAG05
	.long	JACHAG01,JACHAG02,JACHAG03,JACHAG04,JACHAG05
	.long	JACHAG16
JS_H	;SIMPSON
	.long	JAKSIM01
	.long	JAKSIM01,JAKSIM02,JAKSIM03,JAKSIM04,JAKSIM05
	.long	JAKSIM01,JAKSIM02,JAKSIM03,JAKSIM04,JAKSIM05
	.long	JAKSIM01,JAKSIM02,JAKSIM03,JAKSIM04,JAKSIM05
	.long	JAKSIM16
JG_H	;GREEN
	.long	JGREEN01
	.long	JGREEN01,JGREEN02,JGREEN03,JGREEN04,JGREEN05
	.long	JGREEN01,JGREEN02,JGREEN03,JGREEN04,JGREEN05
	.long	JGREEN01,JGREEN02,JGREEN03,JGREEN04,JGREEN05
	.long	JGREEN16
JGE_H	;GENTILE
	.long	JIMGEN01
	.long	JIMGEN01,JIMGEN02,JIMGEN03,JIMGEN04,JIMGEN05
	.long	JIMGEN01,JIMGEN02,JIMGEN03,JIMGEN04,JIMGEN05
	.long	JIMGEN01,JIMGEN02,JIMGEN03,JIMGEN04,JIMGEN05
	.long	JIMGEN03
JD_H	;DILLON
	.long	JOEDIL01
	.long	JOEDIL01,JOEDIL02,JOEDIL03,JOEDIL04,JOEDIL05
	.long	JOEDIL01,JOEDIL02,JOEDIL03,JOEDIL04,JOEDIL05
	.long	JOEDIL01,JOEDIL02,JOEDIL03,JOEDIL04,JOEDIL05
	.long	JOEDIL16
JLI_H	;LINHOFF
	.long	JOELIN01
	.long	JOELIN01,JOELIN02,JOELIN03,JOELIN04,JOELIN05
	.long	JOELIN01,JOELIN02,JOELIN03,JOELIN04,JOELIN05
	.long	JOELIN01,JOELIN02,JOELIN03,JOELIN04,JOELIN05
	.long	JOELIN16
JL_H	;LOWES
	.long	JONLOW01
	.long	JONLOW01,JONLOW02,JONLOW03,JONLOW04,JONLOW05
	.long	JONLOW01,JONLOW02,JONLOW03,JONLOW04,JONLOW05
	.long	JONLOW01,JONLOW02,JONLOW03,JONLOW04,JONLOW05
	.long	JONLOW03
JV_H	;VOGEL
	.long	JONVOG01
	.long	JONVOG01,JONVOG02,JONVOG03,JONVOG04,JONVOG05
	.long	JONVOG01,JONVOG02,JONVOG03,JONVOG04,JONVOG05
	.long	JONVOG01,JONVOG02,JONVOG03,JONVOG04,JONVOG05
	.long	JONVOG16
JT_H	;TSUI
	.long	JOSTSU01
	.long	JOSTSU01,JOSTSU02,JOSTSU03,JOSTSU04,JOSTSU05
	.long	JOSTSU01,JOSTSU02,JOSTSU03,JOSTSU04,JOSTSU05
	.long	JOSTSU01,JOSTSU02,JOSTSU03,JOSTSU04,JOSTSU05
	.long	JOSTSU16
LD_H	;DEMAR
	.long	LARDUM01
	.long	LARDUM01,LARDUM02,LARDUM03,LARDUM04,LARDUM05
	.long	LARDUM01,LARDUM02,LARDUM03,LARDUM04,LARDUM05
	.long	LARDUM01,LARDUM02,LARDUM03,LARDUM04,LARDUM05
	.long	LARDUM16
LDE_H	;DEAL
	.long	LINDEL01
	.long	LINDEL01,LINDEL02,LINDEL03,LINDEL04,LINDEL05
	.long	LINDEL01,LINDEL02,LINDEL03,LINDEL04,LINDEL05
	.long	LINDEL01,LINDEL02,LINDEL03,LINDEL04,LINDEL05
	.long	LINDEL16
MB_H	;BOOTY
	.long	MATBUT01
	.long	MATBUT01,MATBUT02,MATBUT03,MATBUT04,MATBUT05
	.long	MATBUT01,MATBUT02,MATBUT03,MATBUT04,MATBUT05
	.long	MATBUT01,MATBUT02,MATBUT03,MATBUT04,MATBUT05
	.long	MATBUT16
ML_H	;LOFFE
	.long	MRKLOF01
	.long	MRKLOF01,MRKLOF02,MRKLOF03,MRKLOF04,MRKLOF05
	.long	MRKLOF01,MRKLOF02,MRKLOF03,MRKLOF04,MRKLOF05
	.long	MRKLOF01,MRKLOF02,MRKLOF03,MRKLOF04,MRKLOF05
	.long	MRKLOF16
MP_H	;PENACHO
	.long	MRKPEN01
	.long	MRKPEN01,MRKPEN02,MRKPEN03,MRKPEN04,MRKPEN05
	.long	MRKPEN01,MRKPEN02,MRKPEN03,MRKPEN04,MRKPEN05
	.long	MRKPEN01,MRKPEN02,MRKPEN03,MRKPEN04,MRKPEN05
	.long	MRKPEN16
PB_H	;BARKER
	.long	PALBAR01
	.long	PALBAR01,PALBAR02,PALBAR03,PALBAR04,PALBAR05
	.long	PALBAR01,PALBAR02,PALBAR03,PALBAR04,PALBAR05
	.long	PALBAR01,PALBAR02,PALBAR03,PALBAR04,PALBAR05
	.long	PALBAR16
PC_H	;COX
	.long	PATCOX01
	.long	PATCOX01,PATCOX02,PATCOX03,PATCOX04,PATCOX05
	.long	PATCOX01,PATCOX02,PATCOX03,PATCOX04,PATCOX05
	.long	PATCOX01,PATCOX02,PATCOX03,PATCOX04,PATCOX05
	.long	PATCOX03
RA_H	;RAIDEN
	.long	RAIDEN01
	.long	RAIDEN01,RAIDEN02,RAIDEN03,RAIDEN04,RAIDEN05
	.long	RAIDEN06,RAIDEN07,RAIDEN08,RAIDEN09,RAIDEN10
	.long	RAIDEN11,RAIDEN12,RAIDEN13,RAIDEN14,RAIDEN15
	.long	RAIDEN16
RE_H	;REAPER
	.long	REAPER01
	.long	REAPER01,REAPER02,REAPER03,REAPER04,REAPER05
	.long	REAPER01,REAPER02,REAPER03,REAPER04,REAPER05
	.long	REAPER01,REAPER02,REAPER03,REAPER04,REAPER05
	.long	REAPER16
RM_H	;MACIKA
	.long	RAYMOS01
	.long	RAYMOS01,RAYMOS02,RAYMOS03,RAYMOS04,RAYMOS05
	.long	RAYMOS01,RAYMOS02,RAYMOS03,RAYMOS04,RAYMOS05
	.long	RAYMOS01,RAYMOS02,RAYMOS03,RAYMOS04,RAYMOS05
	.long	RAYMOS16
RS_H	;SHARPE
	.long	ROGSHR01
	.long	ROGSHR01,ROGSHR02,ROGSHR03,ROGSHR04,ROGSHR05
	.long	ROGSHR01,ROGSHR02,ROGSHR03,ROGSHR04,ROGSHR05
	.long	ROGSHR01,ROGSHR02,ROGSHR03,ROGSHR04,ROGSHR05
	.long	ROGSHR16
SB_H	;BERAN
	.long	STVBER01
	.long	STVBER01,STVBER02,STVBER03,STVBER04,STVBER05
	.long	STVBER01,STVBER02,STVBER03,STVBER04,STVBER05
	.long	STVBER01,STVBER02,STVBER03,STVBER04,STVBER05
	.long	STVBER16
TC_H	;COMAN
	.long	TIMCOM01
	.long	TIMCOM01,TIMCOM02,TIMCOM03,TIMCOM04,TIMCOM05
	.long	TIMCOM01,TIMCOM02,TIMCOM03,TIMCOM04,TIMCOM05
	.long	TIMCOM01,TIMCOM02,TIMCOM03,TIMCOM04,TIMCOM05
	.long	TIMCOM16
KO_H	;KING KONG
	.long	VIKAPE01
	.long	VIKAPE01,VIKAPE02,VIKAPE03,VIKAPE04,VIKAPE05
	.long	VIKAPE06,VIKAPE07,VIKAPE08,VIKAPE09,VIKAPE10
	.long	VIKAPE11,VIKAPE12,VIKAPE13,VIKAPE14,VIKAPE15
	.long	VIKAPE16
VP_H	;VINCE
	.long	VNCPON01
	.long	VNCPON01,VNCPON02,VNCPON03,VNCPON04,VNCPON05
	.long	VNCPON01,VNCPON02,VNCPON03,VNCPON04,VNCPON05
	.long	VNCPON01,VNCPON02,VNCPON03,VNCPON04,VNCPON05
	.long	VNCPON16
EL_H	;ELVIS
	.long	VOGHED01
	.long	VOGHED01,VOGHED02,VOGHED03,VOGHED04,VOGHED05
	.long	VOGHED01,VOGHED02,VOGHED03,VOGHED04,VOGHED05
	.long	VOGHED01,VOGHED02,VOGHED03,VOGHED04,VOGHED05
	.long	VOGHED16
WD_H	;DAVIS
	.long	WARDAV01
	.long	WARDAV01,WARDAV02,WARDAV03,WARDAV04,WARDAV05
	.long	WARDAV01,WARDAV02,WARDAV03,WARDAV04,WARDAV05
	.long	WARDAV01,WARDAV02,WARDAV03,WARDAV04,WARDAV05
	.long	WARDAV03
EB_H	;BOON
	.long	EDBOON01
	.long	EDBOON01,EDBOON02,EDBOON03,EDBOON04,EDBOON05
	.long	EDBOON01,EDBOON02,EDBOON03,EDBOON04,EDBOON05
	.long	EDBOON01,EDBOON02,EDBOON03,EDBOON04,EDBOON05
	.long	EDBOON16
JTO_H	;TOBIAS
	.long	TOBIAS01
	.long	TOBIAS01,TOBIAS02,TOBIAS03,TOBIAS04,TOBIAS05
	.long	TOBIAS01,TOBIAS02,TOBIAS03,TOBIAS04,TOBIAS05
	.long	TOBIAS01,TOBIAS02,TOBIAS03,TOBIAS04,TOBIAS05
	.long	TOBIAS16
PH_H	;HEITSCH
	.long	PALHEI01
	.long	PALHEI01,PALHEI02,PALHEI03,PALHEI04,PALHEI05
	.long	PALHEI01,PALHEI02,PALHEI03,PALHEI04,PALHEI05
	.long	PALHEI01,PALHEI02,PALHEI03,PALHEI04,PALHEI05
	.long	PALHEI16
BD_H	;DABELS
	.long	BILDAB01
	.long	BILDAB01,BILDAB02,BILDAB03,BILDAB04,BILDAB05
	.long	BILDAB01,BILDAB02,BILDAB03,BILDAB04,BILDAB05
	.long	BILDAB01,BILDAB02,BILDAB03,BILDAB04,BILDAB05
	.long	BILDAB16
MM_H	;MARTIN
	.long	MARMAR01
	.long	MARMAR01,MARMAR02,MARMAR03,MARMAR04,MARMAR05
	.long	MARMAR01,MARMAR02,MARMAR03,MARMAR04,MARMAR05
	.long	MARMAR01,MARMAR02,MARMAR03,MARMAR04,MARMAR05
	.long	MARMAR03
RD_H	;RACHEL
	.long	RACDAV01
	.long	RACDAV01,RACDAV02,RACDAV03,RACDAV04,RACDAV05
	.long	RACDAV01,RACDAV02,RACDAV03,RACDAV04,RACDAV05
	.long	RACDAV01,RACDAV02,RACDAV03,RACDAV04,RACDAV05
	.long	RACDAV03
KH_H	;HOSKINS
	.long	KARHOS01
	.long	KARHOS01,KARHOS02,KARHOS03,KARHOS04,KARHOS05
	.long	KARHOS01,KARHOS02,KARHOS03,KARHOS04,KARHOS05
	.long	KARHOS01,KARHOS02,KARHOS03,KARHOS04,KARHOS05
	.long	KARHOS16
OL_H	;OLIVIA
	.long	LOROLI01
	.long	LOROLI01,LOROLI02,LOROLI03,LOROLI04,LOROLI05
	.long	LOROLI01,LOROLI02,LOROLI03,LOROLI04,LOROLI05
	.long	LOROLI01,LOROLI02,LOROLI03,LOROLI04,LOROLI05
	.long	LOROLI16
SC_H	;SCORPION
	.long	SCORPI01
	.long	SCORPI01,SCORPI02,SCORPI03,SCORPI04,SCORPI05
	.long	SCORPI01,SCORPI02,SCORPI03,SCORPI04,SCORPI05
	.long	SCORPI01,SCORPI02,SCORPI03,SCORPI04,SCORPI05
	.long	SCORPI16
RP_H	;REPTILE
	.long	REPTIL01
	.long	REPTIL01,REPTIL02,REPTIL03,REPTIL04,REPTIL05
	.long	REPTIL01,REPTIL02,REPTIL03,REPTIL04,REPTIL05
	.long	REPTIL01,REPTIL02,REPTIL03,REPTIL04,REPTIL05
	.long	REPTIL16
CG_H	;GRANNER
	.long	CHRGRA01
	.long	CHRGRA01,CHRGRA02,CHRGRA03,CHRGRA04,CHRGRA05
	.long	CHRGRA01,CHRGRA02,CHRGRA03,CHRGRA04,CHRGRA05
	.long	CHRGRA01,CHRGRA02,CHRGRA03,CHRGRA04,CHRGRA05
	.long	CHRGRA16
RG_H	;GAY
	.long	RAYGAY01
	.long	RAYGAY01,RAYGAY02,RAYGAY03,RAYGAY04,RAYGAY05
	.long	RAYGAY01,RAYGAY02,RAYGAY03,RAYGAY04,RAYGAY05
	.long	RAYGAY01,RAYGAY02,RAYGAY03,RAYGAY04,RAYGAY05
	.long	RAYGAY03
JSK_H	;SKILES
	.long	JASFLA01
	.long	JASFLA01,JASFLA02,JASFLA03,JASFLA04,JASFLA05
	.long	JASFLA01,JASFLA02,JASFLA03,JASFLA04,JASFLA05
	.long	JASFLA01,JASFLA02,JASFLA03,JASFLA04,JASFLA05
	.long	JASFLA16

tg_h
	.long	TG01
	.long	TG01,TG02,TG03,TG04,TG05
	.long	TG06,TG07,TG08,TG09,TG10
	.long	TG11,TG12,TG13,TG14,TG15
	.long	TG16
jr_h
	.long	jamie1
	.long	jamie1,jamie2,jamie3,jamie4,jamie5
	.long	jamie6,jamie7,jamie8,jamie9,jamie10
	.long	jamie11,jamie12,jamie13,jamie14,jamie15
	.long	jamie16
jc_h
	.long	JC1
	.long	JC1,JC2,JC3,JC4,JC5
	.long	JC6,JC7,JC8,JC9,JC10
	.long	JC11,JC12,JC13,JC14,JC15
	.long	JC16
sd_h
	.long	SAL1
	.long	SAL1,SAL2,SAL3,SAL4,SAL5
	.long	SAL6,SAL7,SAL8,SAL9,SAL10
	.long	SAL11,SAL12,SAL13,SAL14,SAL15
	.long	SAL16
sl_h
	.long	SHAW1
	.long	SHAW1,SHAW2,SHAW3,SHAW4,SHAW5
	.long	SHAW6,SHAW7,SHAW8,SHAW9,SHAW10
	.long	SHAW11,SHAW12,SHAW13,SHAW14,SHAW15
	.long	SHAW16
mt_h
	.long	MT01
	.long	MT01,MT02,MT03,MT04,MT05
	.long	MT06,MT07,MT08,MT09,MT10
	.long	MT11,MT12,MT13,MT14,MT15
	.long	MT16
	.long	MT01,MT02,MT03,MT04,MT05
jh_h
	.long	JONH1
	.long	JONH1,JONH2,JONH3,JONH4,JONH5
	.long	JONH6,JONH7,JONH8,JONH9,JONH10
	.long	JONH11,JONH12,JONH13,JONH14,JONH15
	.long	JONH16
gp_h
	.long	GEOR1
	.long	GEOR1,GEOR2,GEOR3,GEOR4,GEOR5
	.long	GEOR1,GEOR2,GEOR3,GEOR4,GEOR5
	.long	GEOR1,GEOR2,GEOR3,GEOR4,GEOR5
	.long	GEOR16
jn_h
	.long	JOHNN01
	.long	JOHNN01,JOHNN02,JOHNN03,JOHNN04,JOHNN05
	.long	JOHNN01,JOHNN02,JOHNN03,JOHNN04,JOHNN05
	.long	JOHNN01,JOHNN02,JOHNN03,JOHNN04,JOHNN05
	.long	JOHNN03
so_h
	.long	SHER1
	.long	SHER1,SHER2,SHER3,SHER4,SHER5
	.long	SHER1,SHER2,SHER3,SHER4,SHER5
	.long	SHER1,SHER2,SHER3,SHER4,SHER5
	.long	SHER16
;sh_h
;	.long	steve1
;	.long	steve1,steve2,steve3,steve4,steve5
;	.long	steve1,steve2,steve3,steve4,steve5
;	.long	steve1,steve2,steve3,steve4,steve5
;	.long	steve3
wi_h
	.long	wil1
	.long	wil1,wil2,wil3,wil4,wil5
	.long	wil1,wil2,wil3,wil4,wil5
	.long	wil1,wil2,wil3,wil4,wil5
	.long	wil3
	.long	wil1,wil2,wil3,wil4,wil5
;ts_h
;	.long	tonysc1
;	.long	tonysc1,tonysc2,tonysc3,tonysc4,tonysc5
;	.long	tonysc1,tonysc2,tonysc3,tonysc4,tonysc5
;	.long	tonysc1,tonysc2,tonysc3,tonysc4,tonysc5
;	.long	tonysc3
;	.long	tonysc1,tonysc2,tonysc3,tonysc4,tonysc5	;PADDING


****************************************************************

	.end
