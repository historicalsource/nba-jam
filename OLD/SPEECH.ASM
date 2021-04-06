****************************************************************
*
* Software:	Jamie Rivett
* Initiated:	?
*
* Modified:	?
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
****************************************************************
	.file	"speech.asm"
	.title	"announcer speech etc..."
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"sys.equ"
	.include	"gsp.equ"
	.include	"mac2.asm"
	.include	"imgtbl.glo"
	.include	"imgtbl2.glo"
	.include	"bgndtbl.glo"
	.include	"game.equ"
	.include	"audit.equ"
	.include	"shawn.hdr"

	.asg		0,SEQT
	.include	"plyr.equ"

******************************************************************************

;	.ref	player_toggle1,player_toggle2

	.ref	fire_flags
	.ref	ballobj_p
	.ref	special_heads			;-1 = normal player head

	.ref	brick_count
	.ref	plyrproc_t
	.ref	ballpnum,ballpnumshot
	.ref	inbound
	.ref	ballrimhitcnt,ballbbhitcnt
	.ref	snd_play1,snd_play1ovrp
	.ref	snd_play1ovr
	.ref	rndrng0,RNDPER
	.ref	game_time
	.ref	gmqrtr,scores
	.ref	ballptsforshot		;Point value for current shot (1-3)
	.ref	team1,team2

	.ref	ballpnumscored		;Last plyr who scored (0-3) or neg
	.ref	ballnumscored		;# times last plyr scored
	.ref	plyrnumonfire		;plyr who is on fire


#*****************************************************************************
;ram

	BSSX	last_name,	16	;last name called (0-3)
	BSSX	last_name_time,	16	;# ticks since name called
	BSSX	shot_type,	16	;dunk, 3ptr etc
	BSSX	plyr_shot,	16	;player who shot last
	BSSX	shot_percentage,16	;0-999
	BSSX	shot_distance,	16	;distance from hoop
	.bss	ugly_stat,	16	;0=not ugly, 1=ugly called
	BSSX	score_diff,	16	;+winning by, -losing by
	.bss	blowout_called,	16	;0=not called, 1=called
	.bss	needshot_called,16	;0=not called, 1=called
	.bss	freakout,	16	;0=no freakout
	BSSX	jam_speech,	16	;speech type to call when jammed
	BSSX	next_call,	16	;# shots before next score call
	.bss	sound_ram,	16*4*4	;queued speech ram
	.bss	sound_ram2,	16*4*4	;queued speech ram
	.bss	skycalled,	16	;skyhook called (0=no)
	BSSX	spch_name_ram,	32*4
	BSSX	spch_pass_ram,	32*4

	.text

#*****************************************************************************
;speech tables

STAB_START

scrs0	.word	>f981,60,>8182,0	;and it's good
scrs1	.word	>f9a1,60,>81e0,0	;it's good (excited)
scrs2	.word	>f981,30,>8187,0	;got it!
scrs3	.word	>f981,30,>81da,0	;finds the hole
scrs4	.word	>f981,30,>81dc,0	;what a shot
scrs5	.word	>f981,30,>81df,0	;hooks it in
scrs6	.word	>f981,30,>81a0,0	;finger rolls it in
scrs7	.word	>f981,98,>81ea,0	;oh my!
scrs8	.word	>f981,30,>81f5,0	;spectacular dunk
scrs9	.word	>f981,60,>819d,0	;sweet touch
scrs10	.word	>f1a0,39,>81e1,0	;IT IS....
scrs11	.word	>f9a1,51,>81e2,0	;GOOOOD!!!
scrs12	.word	>f981,47,>819b,0	;scores
scrs13	.word	>f981,87,>8184,0	;gets a lucky bounce
scrs14	.word	>f990,100,>81d6,0	;the nail in the coffin!
scrs15	.word	>f981,30,>81af,0	;lays it up
scrs16	.word	>f981,70,>819c,0	;boom shakalaka
scrs17	.word	>f981,86,>81a8,0	;razzle dazzle (incredible dunk)
scrs18	.word	>f981,60,>81ad,0	;is it the shoes?
scrs19	.word	>f981,51,>81ae,0	;kaboom
scrs20	.word	>f981,90,>81b2,0	;monster jam
;scrs21	.word	>f981,72,>81ba,0	;slams one home
scrs22	.word	>f981,59,>81bb,0	;slams it
scrs23	.word	>f981,49,>81bc,0	;stuffs it
scrs24	.word	>f981,73,>812d,0	;the easy jam
scrs25	.word	>f981,76,>812f,0	;fancy move
scrsrz	.word	>f981,76,>81a8,0	;razzle dazzle
scrs26	.word	>f981,76,>812B,0	;FANTASTIC!

jamsit	.word	>f981,74,>81a4,0	;jams it in

twopts	.word	>f981,50,>81ca,0	;gets two (two points)
;getstwo	.word	>f981,45,>8197,0	;gets two
bookit	.word	>f981,42,>81a6,0	;book it
;countit	.word	>f981,38,>81a7,0	;count it
uncon	.word	>f981,86,>816f,0	;he's unconscious
cantbuy	.word	>f981,73,>8175,0	;can't buy a bucket
baddec	.word	>f981,72,>81b7,0	;bad decision		<--change!


blowout_snd
	.word	>f990,25,>81fe,1	;silence
	.word	>f990,67,>8172,0	;it's a blowout
blowout2_snd
	.word	>f990,25,>81fe,1	;silence
	.word	>f990,87,>81ab,0	;Whoomp, there it is
swish_snd
	.word	>f981,5,>81fe,1		;silence
	.word	>f981,43,>81e8,0	;SWISH!
allnet_snd
	.word	>f981,5,>81fe,1		;silence
	.word	>f981,72,>8195,0	;nothing but net

shts0	.word	>f180,95,>818a,0	;from the 3 point line
shts1	.word	>f180,53,>81e6,0	;shoots for 3
shts2	.word	>f180,98,>818e,0	;from down town
shts3	.word	>f180,99,>8190,0	;he shoots from the outside
shtsrb	.word	>f180,99,>81f0,0	;rainbow
shts4	.word	>f980,67,>81c1,0	;wild shot
shts5	.word	>f180,81,>818b,0	;from long range
shts6	.word	>f980,70,>81e3,0	;out of range (launches a shot)
shts7	.word	>f9a0,70,>8183,0	;at the buzzer
shts8	.word	>f180,53,>81a3,0	;for two
;shts9	.word	>f180,80,>81b9,0	;with the sky hook
hooksht	.word	>f990,60,>81bd,0	;takes the hook shot	<----check this

;getoutb	.word	>f990,86,>81b5,0	;get that beep outta here
getout	.word	>f990,86,>815d,0	;get that outta here
yes	.word	>f981,46,>81c2,0	;YES!
greatsht .word	>f981,62,>81d8,0	;great shot!
wideopen .word	>f981,66,>81dd,0	;wide open
gottasht .word	>f990,51,>81d7,0	;they've gotta shoot it
nogood	.word	>f981,58,>81f1,0	;NO GOOD!
hescores .word	>f981,63,>81f6,0	;he scores

ugly0
	.word	>f980,25,>81fe,1	;silence
	.word	>f980,63,>81d9,0	;ugly shot!

ugly1
	.word	>f980,25,>81fe,1	;silence
	.word	>f980,64,>8198,0	;puts up a brick

ugly2
	.word	>f980,25,>81fe,1	;silence
	.word	>f980,66,>819f,0	;terrible shot!



matchup	.word	>f9ff,66,>81de,0	;tonight's matchup
versus	.word	>f9ff,42,>802f,0	;versus

ovrtme .word	>f9ff,69,>8180,0	;overtime!
wingame	.word	>f9ff,75,>8173,0	;win the game
arewinrs .word	>f9ff,69,>8174,0	;are the winners


munged	.word	>f990,49,>812e,0	;munged
ambushed .word	>f990,47,>81c4,0	;ugly knockdown	(ambushed)
takethat .word	>f990,46,>8189,0	;take that!
flagrant .word	>f990,50,>8178,0	;flagrant
;uglyknok .word	>f990,73,>81c6,0	;ugly knock down
tofloor	.word	>f990,81,>81ce,0	;knocked to the floor
hello	.word	>f990,47,>81c8,0	;hello!
excuse	.word	>f990,57,>81c0,0	;excuse me!

reject	.word	>f990,79,>81b6,0	;rejected!
rejects	.word	>f990,93,>81f2,0	;rejects the shot
greatd	.word	>f990,70,>8188,0	;great defense
noway	.word	>f990,68,>81b4,0	;no way!
grabreb	.word	>f990,84,>81ef,0	;grabs the rebound
;withbrd	.word	>f990,78,>81f0,0	;comes away with the board
intrcpt	.word	>f990,59,>81a9,0	;intercepted!
turnovr	.word	>f990,51,>81bf,0	;the turnover!
stolen	.word	>f990,47,>81f3,0	;steals the ball

downby	.word	>f990,41,>81cd,0	;down by
upby	.word	>f990,34,>81cf,0	;up by
scrtied	.word	>f990,83,>81ba,0	;the score is tied

snd_1	.word	>f990,45,>81d0,0	;
snd_2	.word	>f990,42,>81d1,0	;
snd_3	.word	>f990,46,>81d2,0	;
snd_4	.word	>f990,44,>81d3,0	;
snd_5	.word	>f990,41,>81d4,0	;
snd_6	.word	>f990,38,>81d5,0	;
snd_7	.word	>f990,47,>81f7,0	;
snd_8	.word	>f990,38,>81f8,0	;
snd_9	.word	>f990,46,>81f9,0	;
snd_10	.word	>f990,43,>81fa,0	;
snd_15	.word	>f990,57,>81fb,0	;
snd_20	.word	>f990,50,>81fc,0	;


heatup_snd	.word	>f9f1,60,>8168,0	;He's heating up
onfire_snd	.word	>f9a1,83,>8169,0	;He's on fire
hothand		.word	>f990,87,>81fd,0	;He's got a hot hand
organ1_snd	.word	>f3ff,>8,>80ae,0
organ2_snd	.word	>f3ff,>8,>80af,0

needshot	.word	>f981,55,>81fe,1	;silence
		.word	>f998,71,>81e9,0	;They need a shot here

silence55	.word	>f981,55,>81fe,1	;silence

runout		.word	>f990,8,>81fe,1		;silence
		.word	>f990,90,>8186,0	;running out of time

	.def	pass_speech

pass_speech

 .word	>f980,32,>8050,0	;TO MANNING
 .word	>f980,31,>80ef,0	;TO AUGMON	( ATLANTA )
 .word	>f980,40,>8162,0	;TO WILLIS

 .word	>f980,43,>80f8,0	;TO BROWN	( BOSTON )
 .word	>f980,28,>80f7,0	;TO MCDAN
 .word	>f980,30,>8145,0	;TO GAMBLE

 .word	>f980,50,>80e9,0	;TO JOHNSN_L	( CHARLOTTE )
 .word	>f980,43,>8061,0	;TO HAWKINS
 .word	>f980,45,>8121,0	;TO MOURNING

 .word	>f980,29,>80e7,0	;TO PIPPEN
 .word	>f980,49,>8130,0	;TO ARMSTRNG
 .word	>f980,40,>817c,0	;TO KUKOC
 .word	>f980,34,>80e6,0	;TO GRANT_HC	( CHICAGO )

 .word	>f980,33,>8055,0	;TO PRICE
 .word	>f980,34,>8056,0	;TO DAUGHRTY	( CLEVELAND )
 .word	>f980,34,>8122,0	;TO NANCE

; .word	>f980,28,>8051,0	;TO HARPER_D
 .word	>f980,34,>817b,0	;TO JACKSON
 .word	>f980,34,>817d,0	;TO MASHBURN

 .word	>f980,46,>8059,0	;TO MUTUMBO
 .word	>f980,29,>805a,0	;TO ELLIS	( DENVER )
 .word	>f980,34,>8137,0	;TO ROGERS

 .word	>f980,42,>80fe,0	;TO THOMAS
 .word	>f980,34,>8141,0	;TO DUMARS
 .word	>f980,37,>80f6,0	;TO ELLIOT
 .word	>f980,34,>8147,0	;TO HUNTER
; .word	>f980,45,>80fd,0	;TO LAIMBEER	( DETROIT )

 .word	>f980,37,>80fb,0	;TO HARDAWAY
 .word	>f980,30,>80fc,0	;TO MULLIN	( GOLDEN STATE )
 .word	>f980,34,>8161,0	;TO WEBBER

 .word	>f980,43,>8058,0	;TO OLAJUWON
 .word	>f980,34,>817f,0	;TO MAXWELL
 .word	>f980,34,>8146,0	;TO HORRY
 .word	>f980,25,>8057,0	;TO SMITH	( HOUSTON )

 .word	>f980,22,>804d,0	;TO MILLER
 .word	>f980,34,>8149,0	;TO SEALY
 .word	>f980,34,>814f,0	;TO SMITS

 .word	>f980,37,>80f0,0	;TO WILKINS
 .word	>f980,28,>8051,0	;TO HARPER_R	( L.A. CLIPPERS )
 .word	>f980,40,>802b,0	;TO ROBERTS

 .word	>f980,34,>8125,0	;TO PEELER
 .word	>f980,37,>804e,0	;TO DIVAC	( L.A. LAKERS )
 .word	>f980,34,>813e,0	;TO CAMPBELL
;**************** .word	>f980,50,>80e9,0	;TO MAGIC
 .word	>f980,31,>804f,0	;TO WORTHY

 .word	>f980,27,>8054,0	;TO RICE
 .word	>f980,33,>8053,0	;TO SEIKALY	( MIAMI )
 .word	>f980,34,>811c,0	;TO MINER

 .word	>f980,34,>8131,0	;TO BAKER
 .word	>f980,29,>804b,0	;TO EDWARDS	( MILWAUKEE )
 .word	>f980,34,>8140,0	;TO DAY
 .word	>f980,32,>80ff,0	;TO LOHAUS

 .word	>f980,37,>805e,0	;TO LAETNER
 .word	>f980,30,>805d,0	;TO PERSON	( MINNESOTTA )
 .word	>f980,34,>812a,0	;TO RIDER

 .word	>f980,31,>8060,0	;TO COLEMAN
 .word	>f980,50,>805f,0	;TO KANDERSON	( NEW JERSEY )
 .word	>f980,34,>811e,0	;TO CMORRIS
 .word	>f980,40,>80f2,0	;TO BENJAMIN	( SEATTLE )

 .word	>f980,37,>80ee,0	;TO EWING
 .word	>f980,34,>817e,0	;TO MASON
 .word	>f980,34,>8151,0	;TO STARKS
 .word	>f980,38,>80ed,0	;TO OAKLEY	( NEW YORK )
 .word	>f980,28,>8051,0	;TO HARPER_D

;******************** .word	>f980,39,>80e5,0	;TO ONEAL

 .word	>f980,37,>80fb,0	;TO AHARDAWAY
 .word	>f980,50,>805f,0	;TO NANDERSON
 .word	>f980,40,>80e4,0	;TO SKILES	( ORLANDO )
; .word	>f980,38,>8052,0	;TO IUZZ	( DALLAS )

 .word	>f980,34,>8152,0	;TO WEATHERSPOON
 .word	>f980,34,>8133,0	;TO BRADLEY
; .word	>f980,36,>8062,0	;TO HORNACEK	( PHILADELPHIA )

 .word	>f980,36,>80ec,0	;TO BARKLEY
 .word	>f980,38,>80eb,0	;TO MAJERLE	( PHOENIX )
 .word	>f980,50,>80e9,0	;TO KJOHNSON

 .word	>f980,33,>80f4,0	;TO DREXLER
 .word	>f980,24,>80f3,0	;TO PORTER	( PORTLAND )
 .word	>f980,46,>80f5,0	;TO CROBINSON
 .word	>f980,34,>80e6,0	;TO GRANT_HV

 .word	>f980,34,>814c,0	;TO SIMMONS
 .word	>f980,34,>817a,0	;TO HURLEY
 .word	>f980,34,>8127,0	;TO RICHMOND
 .word	>f980,43,>805b,0	;TO TISDALE
 .word	>f980,46,>805c,0	;TO WEBB	( SACRAMENTO )

 .word	>f980,46,>80f5,0	;TO ROBINSON	( SAN ANTONIO )
 .word	>f980,34,>8135,0	;TO RODMAN
 .word	>f980,29,>805a,0	;TO DELLIS 

 .word	>f980,31,>80f1,0	;TO KEMP
 .word	>f980,40,>8126,0	;TO PAYTON	( SEATTLE )
 .word	>f980,28,>80ea,0	;TO GILL
 .word	>f980,26,>804c,0	;TO SCHREMPF	( INDIANA )

 .word	>f980,37,>80fa,0	;TO MALONE_K
 .word	>f980,31,>80f9,0	;TO STOCKTON	( UTAH )
 .word	>f980,40,>8132,0	;TO BENOIT
 .word	>f980,36,>8062,0	;TO HORNACEK	( PHILADELPHIA )

 .word	>f980,36,>80e8,0	;TO GUGLIOTA	( WASHINGTON )
 .word	>f980,40,>8142,0	;TO ELLISON
 .word	>f980,40,>813f,0	;TO CHEANEY

 .word	>f980,37,>80fa,0	;TO MALONE_K
 .word	>f980,31,>80f1,0	;TO KEMP
 .word	>f980,46,>80f5,0	;TO ROBINSON	( SAN ANTONIO )
 .word	>f980,36,>80ec,0	;TO BARKLEY
 .word	>f980,33,>80f4,0	;TO DREXLER
 .word	>f980,37,>80fb,0	;TO AHARDAWAY
 .word	>f980,37,>80ee,0	;TO EWING
 .word	>f980,50,>805f,0	;TO KANDERSON	( NEW JERSEY )
 .word	>f980,31,>8060,0	;TO COLEMAN
 .word	>f980,50,>805f,0	;TO NANDERSON
 .word	>f980,31,>80f9,0	;TO STOCKTON	( UTAH )
 .word	>f980,50,>80e9,0	;TO KJOHNSON
 .word	>f980,28,>80ea,0	;TO GILL
 .word	>f980,34,>8127,0	;TO RICHMOND
 .word	>f980,34,>8133,0	;TO BRADLEY
 .word	>f980,46,>805c,0	;TO WEBB	( SACRAMENTO )
 .word	>f980,34,>8141,0	;TO DUMARS
 .word	>f980,34,>8151,0	;TO STARKS
 .word	>f980,46,>8059,0	;TO MUTUMBO
 .word	>f980,37,>80f0,0	;TO WILKINS
 .word	>f980,28,>8051,0	;TO HARPER_R	( L.A. CLIPPERS )
 .word	>f980,34,>812a,0	;TO RIDER
 .word	>f980,22,>804d,0	;TO MILLER
 .word	>f980,50,>80e9,0	;TO JOHNSN_L	( CHARLOTTE )
 .word	>f980,43,>8058,0	;TO OLAJUWON
 .word	>f980,34,>8131,0	;TO BAKER
 .word	>f980,49,>8130,0	;TO ARMSTRNG
 .word	>f980,45,>8121,0	;TO MOURNING
 .word	>f980,27,>8054,0	;TO RICE
 .word	>f980,37,>80fb,0	;TO HARDAWAY
 .word	>f980,34,>817b,0	;TO JACKSON
 .word	>f980,29,>80e7,0	;TO PIPPEN
 .word	>f980,34,>811c,0	;TO MINER
 .word	>f980,42,>80fe,0	;TO THOMAS
 .word	>f980,34,>8161,0	;TO WEBBER
 .word	>f980,34,>817d,0	;TO MASHBURN
 .word	>f980,31,>804f,0	;TO WORTHY
 .word	>f980,30,>80fc,0	;TO MULLIN	( GOLDEN STATE )
 .word	>f980,32,>8050,0	;TO MANNING


; .word	>f980,36,>81a2,0	;TO SCORPION	( MORTAL KOMBAT )
; .word	>f980,50,>80e5,0	;TO RAIDEN
; .word	>f980,50,>81a6,0	;TO REPTILE
; .word	>f980,50,>81a1,0	;TO SUBZERO
; .word	>f990,8,>81fe,1		;silence
; .word	>f990,8,>81fe,1		;silence
; .word	>f990,8,>81fe,1		;silence


	.def	name_speech

name_speech


 .word	>f980,32,>80d2,0	;MANNING	( L.A. CLIPPERS )
 .word	>f980,31,>80bc,0	;AUGMON
 .word	>f980,35,>806a,0	;WILLIS

;_brwn
 .word	>f980,43,>80c3,0	;BROWN		( BOSTON )
 .word	>f980,28,>80c4,0	;MCDAN
 .word	>f980,40,>8019,0	;GAMBLE

 .word	>f980,50,>80b6,0	;JOHNSN_L	( CHARLOTTE )
 .word	>f980,43,>80e3,0	;HAWKINS
 .word	>f980,43,>8025,0	;MOURNING

 .word	>f980,29,>80b2,0	;PIPPEN		( CHICAGO )
 .word	>f980,40,>8010,0	;ARMSTRNG
 .word	>f980,35,>801e,0	;KUKOC
 .word	>f980,34,>80b3,0	;GRANT_HC

 .word	>f980,33,>80d7,0	;PRICE		( CLEVELAND )
 .word	>f980,34,>80d6,0	;DAUGHRTY
 .word	>f980,34,>8026,0	;NANCE

; .word	>f980,28,>80d1,0	;HARPER_D	( DALLAS )
 .word	>f980,34,>801d,0	;JACKSON
 .word	>f980,44,>801f,0	;MASHBURN

 .word	>f980,46,>80db,0	;MUTUMBO	( DENVER )
 .word	>f980,29,>80da,0	;ELLIS
 .word	>f980,34,>8063,0	;ROGERS

 .word	>f980,42,>80c9,0	;THOMAS		( DETROIT )
 .word	>f980,40,>8017,0	;DUMARS
 .word	>f980,37,>80c1,0	;ELLIOT
 .word	>f980,40,>801b,0	;HUNTER
; .word	>f980,45,>80ca,0	;LAIMBEER

 .word	>f980,37,>80c8,0	;HARDAWAY	( GOLDEN STATE )
 .word	>f980,30,>80c7,0	;MULLIN
 .word	>f980,40,>8069,0	;WEBBER

 .word	>f980,43,>80d8,0	;OLAJUWON	( HOUSTON )
 .word	>f980,40,>8021,0	;MAXWELL
 .word	>f980,34,>801a,0	;HORRY
 .word	>f980,25,>80d9,0	;SMITH

 .word	>f980,22,>80cd,0	;MILLER		( INDIANA )
 .word	>f980,34,>8064,0	;SEALY
 .word	>f980,34,>8066,0	;SMITS

 .word	>f980,37,>80bb,0	;WILKINS	( ATLANTA )
 .word	>f980,28,>80d1,0	;HARPER_R
 .word	>f980,34,>802b,0	;ROBERTS

 .word	>f980,34,>8027,0	;PEELER
 .word	>f980,37,>80d0,0	;DIVAC
 .word	>f980,45,>8014,0	;CAMPBELL
;******************* .word	>f980,34,>81fe,0	;MAGIC
 .word	>f980,31,>80cf,0	;WORTHY		( L.A. LAKERS )

 .word	>f980,27,>80d4,0	;RICE		( MIAMI )
 .word	>f980,33,>80d5,0	;SEIKALY
 .word	>f980,34,>8023,0	;MINER

 .word	>f980,37,>8011,0	;BAKER
 .word	>f980,29,>80cb,0	;EDWARDS
 .word	>f980,34,>8016,0	;DAY
 .word	>f980,32,>80cc,0	;LOHAUS		( MILWAUKEE )

 .word	>f980,37,>80de,0	;LAETNER	( MINNESOTTA )
 .word	>f980,30,>80df,0	;PERSON
 .word	>f980,34,>802a,0	;RIDER

 .word	>f980,31,>80e0,0	;COLEMAN	( NEW JERSEY )
 .word	>f980,45,>80e1,0	;KANDERSON
 .word	>f980,34,>8024,0	;CMORRIS
 .word	>f980,40,>80bd,0	;BENJAMIN

 .word	>f980,37,>80b9,0	;EWING		( NEW YORK )
 .word	>f980,34,>8020,0	;MASON
 .word	>f980,34,>8067,0	;STARKS
 .word	>f980,38,>80ba,0	;OAKLEY
 .word	>f980,28,>80d1,0	;HARPER_D	( DALLAS )

;****************** .word	>f980,39,>80b0,0	;ONEAL		( ORLANDO )
 .word	>f980,37,>80c8,0	;AHARDAWAY
 .word	>f980,45,>80e1,0	;NANDERSON
 .word	>f980,40,>80b1,0	;SKILES
; .word	>f980,38,>80d3,0	;IUZZOLINO

 .word	>f980,44,>8068,0	;WEATHERSPOON	( PHILADELPHIA )
 .word	>f980,40,>8013,0	;BRADLEY
; .word	>f980,36,>80e2,0	;HORNACEK

 .word	>f980,36,>80b7,0	;BARKLEY	( PHOENIX )
 .word	>f980,38,>80b8,0	;MAJERLE
 .word	>f980,50,>80b6,0	;KJOHNSON

 .word	>f980,33,>80bf,0	;DREXLER	( PORTLAND )
 .word	>f980,24,>80c0,0	;PORTER
 .word	>f980,46,>80c2,0	;CROBINSON
 .word	>f980,34,>80b3,0	;GRANT_HV

 .word	>f980,34,>8065,0	;SIMMONS
 .word	>f980,34,>801c,0	;HURLEY
 .word	>f980,43,>8029,0	;RICHMOND
 .word	>f980,43,>80dd,0	;TISDALE	( SACRAMENTO )
 .word	>f980,46,>80dc,0	;WEBB

 .word	>f980,46,>80c2,0	;ROBINSON	( SAN ANTONIO )
 .word	>f980,34,>802c,0	;RODMAN
 .word	>f980,29,>80da,0	;DELLIS 

 .word	>f980,31,>80be,0	;KEMP		( SEATTLE )
 .word	>f980,40,>8028,0	;PAYTON
 .word	>f980,28,>80ea,0	;GILL
 .word	>f980,26,>80ce,0	;SCHREMPF

 .word	>f980,37,>80c5,0	;MALONE_K	( UTAH )
 .word	>f980,31,>80c6,0	;STOCKTON
 .word	>f980,40,>8012,0	;BENOIT
 .word	>f980,36,>80e2,0	;HORNACEK

 .word	>f980,36,>80b4,0	;GUGLIOTTA	( WASHINGTON )
 .word	>f980,47,>8018,0	;ELLISON
 .word	>f980,40,>8015,0	;CHEANEY

 .word	>f980,37,>80c5,0	;MALONE_K	( UTAH )
 .word	>f980,31,>80be,0	;KEMP		( SEATTLE )
 .word	>f980,46,>80c2,0	;ROBINSON	( SAN ANTONIO )
 .word	>f980,36,>80b7,0	;BARKLEY	( PHOENIX )
 .word	>f980,33,>80bf,0	;DREXLER	( PORTLAND )
 .word	>f980,37,>80c8,0	;AHARDAWAY
 .word	>f980,37,>80b9,0	;EWING		( NEW YORK )
 .word	>f980,45,>80e1,0	;KANDERSON
 .word	>f980,31,>80e0,0	;COLEMAN	( NEW JERSEY )
 .word	>f980,45,>80e1,0	;NANDERSON
 .word	>f980,31,>80c6,0	;STOCKTON
 .word	>f980,50,>80b6,0	;KJOHNSON
 .word	>f980,28,>80ea,0	;GILL
 .word	>f980,43,>8029,0	;RICHMOND
 .word	>f980,40,>8013,0	;BRADLEY
 .word	>f980,46,>80dc,0	;WEBB
 .word	>f980,40,>8017,0	;DUMARS
 .word	>f980,34,>8067,0	;STARKS
 .word	>f980,46,>80db,0	;MUTUMBO	( DENVER )
 .word	>f980,37,>80bb,0	;WILKINS	( ATLANTA )
 .word	>f980,28,>80d1,0	;HARPER_R
 .word	>f980,34,>802a,0	;RIDER
 .word	>f980,22,>80cd,0	;MILLER		( INDIANA )
 .word	>f980,50,>80b6,0	;JOHNSN_L	( CHARLOTTE )
 .word	>f980,43,>80d8,0	;OLAJUWON	( HOUSTON )
 .word	>f980,37,>8011,0	;BAKER
 .word	>f980,40,>8010,0	;ARMSTRNG
 .word	>f980,40,>8021,0	;MAXWELL
 .word	>f980,43,>8025,0	;MOURNING
 .word	>f980,27,>80d4,0	;RICE		( MIAMI )
 .word	>f980,37,>80c8,0	;HARDAWAY	( GOLDEN STATE )
 .word	>f980,34,>801d,0	;JACKSON
 .word	>f980,29,>80b2,0	;PIPPEN		( CHICAGO )
 .word	>f980,34,>8023,0	;MINER
 .word	>f980,42,>80c9,0	;THOMAS		( DETROIT )
 .word	>f980,40,>8069,0	;WEBBER
 .word	>f980,44,>801f,0	;MASHBURN
 .word	>f980,31,>80cf,0	;WORTHY		( L.A. LAKERS )
 .word	>f980,30,>80c7,0	;MULLIN
 .word	>f980,32,>80d2,0	;MANNING	( L.A. CLIPPERS )


; .word	>f980,50,>8197,0	;SCORPION	( MORTAL KOMBAT )
; .word	>f980,43,>80b0,0	;RAIDEN
; .word	>f980,50,>81a5,0	;REPTILE
; .word	>f980,50,>8196,0	;SUBZERO
; .word	>f990,8,>81fe,1		;silence
; .word	>f990,8,>81fe,1		;silence
; .word	>f990,8,>81fe,1		;silence

name_blank
pass_blank
 .word	>f980,1,>81fe,0		;blank


special_name_speech
;special guests

	.word	>f980,1,>81fe,0		;0  GOSKIE	
	.word	>f980,1,>81fe,0		;1  RIVETT		
	.word	>f980,1,>81fe,0		;2  CARLTON
	.word	>f980,1,>81fe,0		;3  DIVITA
	.word	>f980,1,>81fe,0		;4  LIPTAK
	.word	>f980,1,>81fe,0		;5  TURMELL
	.word	>f980,1,>81fe,0		;6  HEY
	.word	>f980,1,>81fe,0		;7  PETRO
	.word	>f980,1,>81fe,0		;8  NEWCOMER
	.word	>f980,1,>81fe,0		;9  OURSLER
	.word	>f980,1,>81fe,0		;10 LASCO
	.word	>f980,1,>81fe,0		;11 MORRIS
	.word	>f980,1,>81fe,0		;12 MEDNICK
	.word	>f980,1,>81fe,0		;13 FORDEN	
	.word	>f980,1,>81fe,0		;14 KINKEAD
	.word	>f980,1,>81fe,0		;15 JARVIS	
	.word	>f980,50,>8196,0	;16 SUBZ	
	.word	>f980,1,>81fe,0		;17 HAEGER	
	.word	>f980,1,>81fe,0		;18 SIMPSON
	.word	>f980,1,>81fe,0		;19 GREEN	
	.word	>f980,1,>81fe,0		;20 GENTILE
	.word	>f980,1,>81fe,0		;21 DILLON	
	.word	>f980,1,>81fe,0		;22 LOWES	
	.word	>f980,1,>81fe,0		;23 VOGEL	
	.word	>f980,1,>81fe,0		;24 TSUI	
	.word	>f980,1,>81fe,0		;25 KAM		
	.word	>f980,1,>81fe,0		;26 DEAL		
	.word	>f980,1,>81fe,0		;27 BOOTY		
	.word	>f980,1,>81fe,0		;28 LOFFRE		
	.word	>f980,1,>81fe,0		;29 PENACHO	
	.word	>f980,1,>81fe,0		;30 BARKER		
	.word	>f980,1,>81fe,0		;31 COX			
	.word	>f980,43,>80b0,0	;32 RAIDEN
	.word	>f980,1,>81fe,0		;33 REAPER		
	.word	>f980,1,>81fe,0		;34 MACIKA		
	.word	>f980,1,>81fe,0		;35 SHARPE		
	.word	>f980,1,>81fe,0		;36 BERAN		
	.word	>f980,1,>81fe,0		;37 COMAN		
	.word	>f980,1,>81fe,0		;38 KONGO	
	.word	>f980,1,>81fe,0		;39 PONTAREL	
	.word	>f980,1,>81fe,0		;40 ELVIS		
	.word	>f980,1,>81fe,0		;41 DAVIS		
	.word	>f980,1,>81fe,0		;42 BOON		
	.word	>f980,1,>81fe,0		;43 TOBIAS		
	.word	>f980,1,>81fe,0		;44 HEITSCH	
	.word	>f980,1,>81fe,0		;45 DABEL		
	.word	>f980,1,>81fe,0		;46 MARTINEZ	
	.word	>f980,1,>81fe,0		;47 DAVIES		
	.word	>f980,1,>81fe,0		;48 HOSK		
	.word	>f980,1,>81fe,0		;49 OLIV		
	.word	>f980,50,>8197,0	;50 SCORP		
	.word	>f980,50,>81a5,0	;51 REPT		
	.word	>f980,1,>81fe,0		;52 GRANNER
	.word	>f980,1,>81fe,0		;53 GAY
	.word	>f980,1,>81fe,0		;54 SKILES
	.word	>f980,1,>81fe,0		;55 LINHOFF

;Superstar guests

	.word	>f980,37,>80bb,0	;56 WILKINS
	.word	>f980,43,>80c3,0	;57 BROWN
	.word	>f980,43,>8025,0	;58 MOURNING
	.word	>f980,29,>80b2,0	;59 PIPPEN  
	.word	>f980,42,>80c9,0	;60 I. THOMAS
	.word	>f980,40,>8069,0	;61 WEBBER
	.word	>f980,43,>80d8,0	;62 OLAJUWON
	.word	>f980,31,>80e0,0	;63 COLEMAN
	.word	>f980,37,>80b9,0	;64 EWING
	.word	>f980,36,>80b7,0	;65 BARKLEY
	.word	>f980,46,>80c2,0	;66 ROBINSON
	.word	>f980,31,>80be,0	;67 KEMP
	.word	>f980,37,>80c5,0	;68 MALONE


special_pass_speech
;special guests

	.word	>f980,1,>81fe,0		;0  GOSKIE	
	.word	>f980,1,>81fe,0		;1  RIVETT		
	.word	>f980,1,>81fe,0		;2  CARLTON
	.word	>f980,1,>81fe,0		;3  DIVITA
	.word	>f980,1,>81fe,0		;4  LIPTAK
	.word	>f980,1,>81fe,0		;5  TURMELL
	.word	>f980,1,>81fe,0		;6  HEY
	.word	>f980,1,>81fe,0		;7  PETRO
	.word	>f980,1,>81fe,0		;8  NEWCOMER
	.word	>f980,1,>81fe,0		;9  OURSLER
	.word	>f980,1,>81fe,0		;10 LASCO
	.word	>f980,1,>81fe,0		;11 MORRIS
	.word	>f980,1,>81fe,0		;12 MEDNICK
	.word	>f980,1,>81fe,0		;13 FORDEN	
	.word	>f980,1,>81fe,0		;14 KINKEAD
	.word	>f980,1,>81fe,0		;15 JARVIS	
	.word	>f980,50,>81a1,0	;16 SUBZ	
	.word	>f980,1,>81fe,0		;17 HAEGER	
	.word	>f980,1,>81fe,0		;18 SIMPSON
	.word	>f980,1,>81fe,0		;19 GREEN	
	.word	>f980,1,>81fe,0		;20 GENTILE
	.word	>f980,1,>81fe,0		;21 DILLON	
	.word	>f980,1,>81fe,0		;22 LOWES	
	.word	>f980,1,>81fe,0		;23 VOGEL	
	.word	>f980,1,>81fe,0		;24 TSUI	
	.word	>f980,1,>81fe,0		;25 KAM		
	.word	>f980,1,>81fe,0		;26 DEAL		
	.word	>f980,1,>81fe,0		;27 BOOTY		
	.word	>f980,1,>81fe,0		;28 LOFFRE		
	.word	>f980,1,>81fe,0		;29 PENACHO	
	.word	>f980,1,>81fe,0		;30 BARKER		
	.word	>f980,1,>81fe,0		;31 COX			
	.word	>f980,50,>80e5,0	;32 RAIDEN
	.word	>f980,1,>81fe,0		;33 REAPER		
	.word	>f980,1,>81fe,0		;34 MACIKA		
	.word	>f980,1,>81fe,0		;35 SHARPE		
	.word	>f980,1,>81fe,0		;36 BERAN		
	.word	>f980,1,>81fe,0		;37 COMAN		
	.word	>f980,1,>81fe,0		;38 KONGO	
	.word	>f980,1,>81fe,0		;39 PONTAREL	
	.word	>f980,1,>81fe,0		;40 ELVIS		
	.word	>f980,1,>81fe,0		;41 DAVIS		
	.word	>f980,1,>81fe,0		;42 BOON		
	.word	>f980,1,>81fe,0		;43 TOBIAS		
	.word	>f980,1,>81fe,0		;44 HEITSCH	
	.word	>f980,1,>81fe,0		;45 DABEL		
	.word	>f980,1,>81fe,0		;46 MARTINEZ	
	.word	>f980,1,>81fe,0		;47 DAVIES		
	.word	>f980,1,>81fe,0		;48 HOSK		
	.word	>f980,1,>81fe,0		;49 OLIV		
	.word	>f980,50,>81a2,0	;50 SCORP		
	.word	>f980,50,>81a6,0	;51 REPT		
	.word	>f980,1,>81fe,0		;52 GRANNER
	.word	>f980,1,>81fe,0		;53 GAY
	.word	>f980,1,>81fe,0		;54 SKILES
	.word	>f980,1,>81fe,0		;55 LINHOFF


;Superstar guests pass speech

	.word	>f980,37,>80f0,0	;56 WILKINS
	.word	>f980,43,>80f8,0	;57 BROWN
	.word	>f980,45,>8121,0	;58 MOURNING
	.word	>f980,29,>80e7,0	;59 PIPPEN  
	.word	>f980,42,>80fe,0	;60 I. THOMAS
	.word	>f980,45,>8161,0	;61 WEBBER
	.word	>f980,43,>8058,0	;62 OLAJUWON
	.word	>f980,40,>8060,0	;63 COLEMAN
	.word	>f980,40,>80ee,0	;64 EWING
	.word	>f980,40,>80ec,0	;65 BARKLEY
	.word	>f980,40,>80f5,0	;66 ROBINSON
	.word	>f980,40,>80f1,0	;67 KEMP
	.word	>f980,40,>80fa,0	;68 MALONE


******************************************************************************

team_speech
 .word	>f981,50,>8035,0	;00 ATLANTA		"Hawks"
 .word	>f981,55,>8033,0	;01 BOSTON		"Celtics"
 .word	>f981,37,>8036,0	;02 CHARLOTTE		"Hornets"
 .word	>f981,43,>8031,0	;03 CHICAGO		"Bulls"
 .word	>f981,65,>8032,0	;04 CLEVELAND		"Cavaliers"
 .word	>f981,45,>803c,0	;05 DALLAS		"Maverick"
 .word	>f981,40,>803e,0	;06 DENVER		"Nuggets"
 .word	>f981,40,>8040,0	;07 DETROIT		"Pistons"
 .word	>f981,48,>8048,0	;08 GOLDEN STATE	"Warriors"
 .word	>f981,43,>8041,0	;09 HOUSTON		"Rockets"
 .word	>f981,46,>803f,0	;10 INDIANA		"Pacers"
 .word	>f981,43,>8034,0	;11 L.A. CLIPPERS	"Clippers"
 .word	>f981,42,>803a,0	;12 L.A. LAKERS		"Lakers"
 .word	>f981,37,>8046,0	;13 MIAMI		"Heat"
 .word	>f981,26,>804a,0	;14 MILWAUKEE		"Bucks"
 .word	>f981,51,>8047,0	;15 MINNESOTTA		"Timberwolves"
 .word	>f981,40,>803d,0	;16 NEW JERSEY		"Nets"
 .word	>f981,43,>8039,0	;17 NEW YORK		"Knicks"
 .word	>f981,38,>803b,0	;18 ORLANDO		"Magic"
 .word	>f981,47,>8042,0	;19 PHILADELPHIA	"Sixers"
 .word	>f981,42,>8044,0	;20 PHOENIX		"Suns"
 .word	>f981,48,>8049,0	;21 PORTLAND		"Blazers"
 .word	>f981,49,>8038,0	;22 SACRAMENTO		"Kings"
 .word	>f981,46,>8043,0	;23 SAN ANTONIO		"Spurs"
 .word	>f981,59,>8045,0	;24 SEATTLE		"Supersonics"
 .word	>f981,42,>8037,0	;25 UTAH		"Jazz"
 .word	>f981,39,>8030,0	;26 WASHINGTON		"Bullets"
 .word	>f981,51,>81e2,0	;GOOOOD!!!

; .word	>fcf9,250,>8153,0	;Backboard smash
; .word	>f990,25,>81fe,1	;silence


STAB_END


#*****************************************************************************
* a0 = * sound table

 SUBRP	speech_play

	calla	snd_play1
	rets

#*****************************************************************************
* a0 = * sound table

 SUBR	speech_playovrp

	calla	snd_play1ovrp
	rets


#*****************************************************************************
;a player has just launched a shot
;a0 = player number (0-3)

 SUBR	shoots_speech

	PUSH	a1,a2

	move	a0,@plyr_shot
	callr	calc_score_diff

	clr	a0
	move	a0,@ugly_stat		;not ugly
	move	a0,@freakout		;no freakout on score

	callr	at_buzzer
	jrnc	#xshtspeech

	move	@shot_type,a0
	sll	5,a0			;x 32 bits
	addi	#shoots_table,a0
	move	*a0,a0,L
	call	a0

#xshtspeech
	PULL	a1,a2
	rets

#shoots_table
	.long	#desperation
	.long	#long_range
	.long	#2_points
	.long	#3_points
	.long	#hook_shot
	.long	#lay_up
	.long	#finger_roll
	.long	#dunk_short
	.long	#dunk_med
	.long	#dunk_long

****************
#desperation

	movi	2,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#desptab,a0
	move	*a0,a0,L
	calla	speech_play
	rets

#desptab
	.long	shts5	;from long range
	.long	shts6	;launches a shot
	.long	shts4	;wild shot

****************
#long_range

	movi	1,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#longtab,a0
	move	*a0,a0,L
	calla	speech_play
	rets

#longtab
	.long	shts5	;from long range
	.long	shts6	;launches a shot

****************
#2_points

	callr	ugly_shot
	jrnc	#ugly_2pts

	callr	wideopen_speech
	jrnc	#x2pts

	movi	100,a0			;call for two 10% time
	calla	RNDPER
	jrhi	#do_for2

	move	@plyr_shot,a0
	callr	call_player_name
	jrnc	#x2pts			;nc = name called

#do_for2
	movi	shts8,a0	;for two
	calla	speech_play
#x2pts
#ugly_2pts
	rets


****************
#3_points

	callr	ugly_shot
	jrnc	#x3pts

	callr	wideopen_speech
	jrnc	#x3pts

	movi	300,a0			;call name 30% time
	calla	RNDPER
	jrls	#no_name3p

	move	@plyr_shot,a0
	callr	call_player_name
	jrnc	#x3pts			;nc = name called

#no_name3p
	movi	4,a0
	calla	rndrng0
	sll	5,a0	;x 32 bits
	addi	#3ptab,a0
	move	*a0,a0,L
	jrz	#x3pts
	calla	speech_play
#x3pts
	rets

#3ptab
	.long	shts0		;from the 3 point line
	.long	shts1		;shoots for 3
	.long	shts1		;shoots for 3
	.long	shts2		;from down town
	.long	shts3		;he shoots from the outside
	.long	shtsrb		;rainbow

****************
#hook_shot

	clr	a0
	move	a0,@skycalled

	callr	ugly_shot
	jrnc	#xhook

	move	@shot_distance,a0	;distance from hoop
	cmpi	130,a0
	jrlt	#too_close

	movi	1,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#hooktab,a0
	move	*a0,a0,L
	calla	speech_play
	jrc	#failed

	movk	1,a0
	move	a0,@skycalled
	rets

#failed
#too_close
	move	@plyr_shot,a0
	callr	call_player_name

#xhook
	rets

#hooktab
	.long	hooksht		;1 takes the hook shot
	.long	hooksht		;1 takes the hook shot
;	.long	shts9		;0 with the sky hook

****************
#lay_up

	rets

	move	@plyr_shot,a0
	callr	call_player_name

#xlay
	rets

****************
#finger_roll

	move	@plyr_shot,a0
	callr	call_player_name

#xfing
	rets

****************
#dunk_short

	move	@plyr_shot,a0
	callr	call_player_name

	rets

****************
#dunk_med

	move	@plyr_shot,a0
	callr	call_player_name

	rets

****************
#dunk_long

	movi	400,a0			;call name 40% time
	calla	RNDPER
	jrls	#noname_dnkl

	move	@plyr_shot,a0
	callr	call_player_name
	jrnc	#xdnkl			;nc = name called

#noname_dnkl
	movi	1,a0
	calla	rndrng0
	sll	5,a0	;x 32 bits
	addi	#dnktab,a0
	move	*a0,a0,L
	jrz	#xdnkl
	calla	speech_play
#xdnkl
	rets

#dnktab
	.long	scrs7		;oh my!
	.long	scrs8		;spectacular dunk

#*****************************************************************************
;a player has just scored a basket

 SUBR	scored_speech

	PUSH	a1,a2

	callr	blowout
	jrnc	#xscrdspeech

	callr	onfire_speech
	jrnc	#xscrdspeech

	callr	lucky_bounce
	jrnc	#xscrdspeech

	move	@shot_type,a0
	sll	5,a0			;x 32 bits
	addi	#scored_table,a0
	move	*a0,a0,L
	call	a0

#xscrdspeech
	PULL	a1,a2
	rets


#scored_table
	.long	#desperation
	.long	#long_range
	.long	#2_points
	.long	#3_points
	.long	#hook_shot
	.long	#lay_up
	.long	#finger_roll
	.long	#dunk_short
	.long	#dunk_med
	.long	#dunk_long

****************
#desperation
hotscored

	callr	itsgood
	jrnc	#xdesp

	movi	5,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#desptab,a0
	move	*a0,a0,L
	calla	speech_play
#xdesp
	rets

#desptab
	.long	scrs7		;0 oh my!
	.long	scrs7		;1 oh my!
	.long	scrs7		;2 oh my!
	.long	scrs7		;3 oh my!
	.long	takethat	;4 take that!
	.long	hello		;5 hello!

****************
#long_range

	callr	itsgood
	jrnc	#xlong

	movi	3,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#longtab,a0
	move	*a0,a0,L
	calla	speech_play
#xlong
	rets

#longtab
	.long	scrs4		;0 what a shot
	.long	scrs0		;1 and it's good
	.long	greatsht	;2 great shot!
	.long	hescores	;4 he scores

****************
#2_points

	movi	500,a0		;call 50% swishes
	callr	swish_speech
	jrnc	#x2pts

	movi	300,a0		;call scores 20% time
	calla	RNDPER
	jrls	#x2pts

	movi	6,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#2tab,a0
	move	*a0,a0,L
	calla	speech_play
#x2pts

	rets

#2tab
	.long	scrs12		;0 count it (scores)
	.long	scrs12		;1 count it (scores)
	.long	hescores	;2 he scores
	.long	hescores	;3 he scores
	.long	hescores	;5 he scores
	.long	twopts		;6 two points
	.long	twopts		;7 two points

;	.long	countit		;6 count it
;	.long	bookit		;7 book it
;	.long	getstwo		;8 gets two


****************
#3_points

	callr	itsgood
	jrnc	#x3p

	movi	350,a0		;call 35% swishes
	callr	swish_speech
	jrnc	#x3p

	movi	6,a0
	calla	rndrng0
	sll	5,a0	;x 32 bits
	addi	#3ptab,a0
	move	*a0,a0,L
	jrz	#x3p
	calla	speech_play
#x3p
	rets

#3ptab
	.long	scrs0		;0 and it's good
	.long	scrs0		;1 and it's good
	.long	scrs2		;2 got it!
	.long	scrs4		;3 what a shot
	.long	greatsht	;4 great shot!
	.long	yes		;5 yes!
	.long	hescores	;6 he scores


****************
#hook_shot

	callr	itsgood
	jrnc	#xhook

	move	@skycalled,a0	;sky hook called?
	jrz	#nosky

	jruc	#2_points	;call like regular 2 pointer
	calla	speech_play
	rets

#nosky
	movi	scrs5,a0	;hooks it in
	calla	speech_play

#xhook
	rets


****************
#lay_up

	movk	3,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#laytab,a0
	move	*a0,a0,L
	calla	speech_play
	rets

#laytab
	.long	scrs9	;0 sweet touch
	.long	scrs25	;1 fancy move
	.long	scrsrz	;2 razzle dazzle
	.long	scrs26	;3 fantastic

****************
#finger_roll

	movi	5,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#fingtab,a0
	move	*a0,a0,L
	calla	speech_play
	rets

#fingtab
	.long	scrs9	;0 sweet touch
	.long	scrs3	;1 finds the hole
	.long	scrs6	;2 finger rolls it in
	.long	scrs25	;3 fancy move
	.long	scrsrz	;4 razzle dazzle
	.long	scrs26	;5 fantastic


****************
#dunk_short
#dunk_med
#dunk_long


	move	@jam_speech,a0		;speech type to call when jammed
	jrz	#no_speech
	sll	5,a0			;x 32 bits
	addi	#jam_jump,a0
	move	*a0,a0,L
	call	a0
#no_speech
	rets


#jam_jump
	.long	0
	.long	#easy_jam
	.long	#med_jam
	.long	#good_jam
	.long	#great_jam

****************
#easy_jam

	movi	5,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#easy_tab,a0
	move	*a0,a0,L
	calla	speech_play
	rets

#easy_tab
	.long	scrs19	;0 kaboom
	.long	scrs22	;1 slams it
	.long	scrs23	;2 stuffs it
	.long	scrs24	;3 the easy jam
	.long	jamsit	;4 jams it in
	.long	scrs26	;5 fantastic


****************
#med_jam

	movi	6,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#med_tab,a0
	move	*a0,a0,L
	calla	speech_play
	rets

#med_tab
	.long	scrs16		;0 boom shakalaka
	.long	scrs19		;1 kaboom
	.long	scrs20		;2 monster jam
	.long	jamsit		;3 jams it in
	.long	scrs22		;4 slams it
	.long	scrs23		;5 stuffs it
	.long	scrs26		;6 fantastic


****************
#good_jam

	movi	2,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#good_tab,a0
	move	*a0,a0,L
	calla	speech_play
	rets

#good_tab
	.long	scrs16	;0 boom shakalaka
	.long	scrs19	;1 kaboom
	.long	jamsit	;2 jams it in


****************
#great_jam

	movi	6,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#great_tab,a0
	move	*a0,a0,L
	calla	speech_play
	rets

#great_tab
	.long	scrs8		;0 spectacular dunk
	.long	scrs16		;1 boom shakalaka
	.long	scrs17		;2 razzle dazzle
	.long	scrs18		;3 is it the shoes?
	.long	scrs19		;4 kaboom
	.long	scrs20		;5 monster jam
	.long	takethat	;6 take that

#*****************************************************************************

 SUBR	seq_call_name

	move	*a13(plyr_num),a0	;(0-3)
	callr	call_player_name
	rets


#*****************************************************************************
;calls player name speech
;a0 = player number to call (0-3)
;
;RETURNS:
;CC = name called
;CS = name NOT called

 SUBRP	call_player_name

;	move	a0,a1
;	sll	4,a1			;x16
;	addi	special_heads,a1	;-1 = normal player head
;	move	*a1,a1
;	jrnn	#snd_fail


	move	@last_name_time,a1	;# ticks since name called
	cmpi	TSEC*2,a1
	jrhs	#playit

	move	@last_name,a1		;if name called in last 3 secs
	cmp	a0,a1			;then don't call it again
	jreq	#snd_fail

#playit
	PUSH	a0

	move	a0,a1
	sll	5,a1
	addi	spch_name_ram,a1
	move	*a1,a0,L

;	move	a0,a1
;	srl	1,a0			;team 0-1
;	sll	4,a0
;	addi	team1,a0
;	move	*a0,a0			;team (0-26)
;	sll	7,a0			;x 16bits x 4 x 2
;	addi	name_speech,a0
;	andi	1,a1
;	sll	6,a1			;x 16bits x 4
;	add	a1,a0


	calla	speech_play
	PULL	a0
	jrc	#snd_fail
	move	a0,@last_name		;last player name called
	clr	a0
	move	a0,@last_name_time	;# ticks since name called
	clrc
	rets

#snd_fail
	setc
	rets


#*****************************************************************************
;calls "to player" speech when players pass the ball
;
;a1 = player number passing ball (0-3)
;
;RETURNS:
;CC = name called
;CS = name NOT called

 SUBR	pass_to_speech

	move	@last_name_time,a0	;# ticks since name called
	cmpi	TSEC*3,a0
	jrls	#snd_fail

;	move	a1,a0
;	xori	1,a0
;	sll	4,a0			;x16
;	addi	special_heads,a0	;-1 = normal player head
;	move	*a0,a0
;	jrnn	#snd_fail

	move	a1,a0

	PUSH	a1

	move	a0,a1
	sll	5,a1
	addi	spch_pass_ram,a1
	move	*a1,a0,L


;	move	a1,a0
;	srl	1,a0			;team 0-1
;	sll	4,a0
;	addi	team1,a0
;	move	*a0,a0			;team (0-26)
;	sll	7,a0			;x 16bits x 4 x 2
;	addi	pass_speech,a0
;	andi	1,a1
;	sll	6,a1			;x 16bits x 4
;	add	a1,a0


	calla	speech_play
	PULL	a1
	jrc	#snd_fail
	move	a1,a0
	xori	1,a0
	move	a0,@last_name		;last player name called
	clr	a0
	move	a0,@last_name_time	;# ticks since name called
	clrc
	rets

#snd_fail
	setc
	rets

#*****************************************************************************
;
;CC = at buzzer called
;CS = at buzzer NOT called

	.asg	040500h,MAX_TIME	;45 seconds
	.asg	020500h,MAX_TIME2	;25 seconds
	.asg	000200h,MIN_TIME	;2 seconds

 SUBRP	blowout

	move	@freakout,a1		;no freakout on score
	jrz	#no_freakout

	movi	scrs1,a0		;it's good (excited)
	dec	a1
	jrnz	#ok
	move	@game_time,a0,L
	cmpi	MAX_TIME,a0
	jrhi	#snd_fail
	movi	scrs11,a0		;GOOOOD!!!
#ok
	callr	speech_playovrp
	jrc	#snd_fail
	rets


#no_freakout
	move	@gmqrtr,a0
	cmpi	3,a0
	jrlt	#not_last_qtr

	move	@game_time,a0,L
	cmpi	MAX_TIME,a0
	jrhi	#snd_fail
	cmpi	MIN_TIME,a0
	jrlo	#snd_fail

	move	@blowout_called,a0
	jrnz	#snd_fail

	move	@ballpnumscored,a0	;Last plyr who scored (0-3) or neg
	callr	calc_score_diff

	move	@score_diff,a1
	cmpi	6,a1
	jrge	#isblow

	cmpi	3,a1
	jrlt	#snd_fail

	move	@needshot_called,a0
	jrnz	#snd_fail

	move	@game_time,a0,L
	cmpi	MAX_TIME2,a0
	jrhi	#snd_fail


	movi	1,a0
	calla	rndrng0
	move	a0,a0
	jrz	#do_needshot

;say " TEAM... running out of time"

	move	@ballpnumscored,a0	;Last plyr who scored (0-3) or neg
	jrn	#error

	movi	silence55,a2
	movi	sound_ram2,a4
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L

	move	@team1,a2
	srl	1,a0			;0-1
	jrnz	#tm1_scored
;tm2_scored
	move	@team2,a2
#tm1_scored
	sll	6,a2			;x 16bits x 4
	addi	team_speech,a2
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L
	movk	1,a0
	move	a0,@sound_ram2+40h+30h

	movi	runout,a2
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L

	movi	sound_ram2,a0
	jruc	#playit
	rets

#error
#do_needshot
	movi	needshot,a0		;They need a shot here
#playit
	calla	speech_play
	jrc	#snd_fail
	movk	1,a0
	move	a0,@needshot_called
	rets


#isblow
	movi	blowout_snd,a0		;it's a blowout
	cmpi	9,a1
	jrge	#blowout

	movi	blowout2_snd,a0		;Whoomp
	move	@HCOUNT,a14
	btst	0,a14
	jrz	#whoomp
	movi	scrs14,a0		;the nail in the coffin!
#whoomp
#blowout
	calla	speech_play
	jrc	#snd_fail

	movk	1,a0
	move	a0,@blowout_called

	clrc
	rets


#not_last_qtr
	clr	a0
	move	a0,@blowout_called
	move	a0,@needshot_called

#snd_fail
	setc
	rets

#*****************************************************************************
;
;CC = at buzzer called
;CS = at buzzer NOT called

 SUBRP	at_buzzer

	move	@shot_type,a0		;don't call on dunks
	cmpi	DUNK_SHORT,a0
	jrhs	#check_buzzer

	move	@game_time,a0,L
	cmpi	400h,a0			;less than 4 seconds left
	jrgt	#snd_fail

	move	@gmqrtr,a0
	cmpi	3,a0			;last quarter?
	jrlt	#not_last_qtr

	move	@score_diff,a0
	jrp	#in_front		;already in front
	move	@ballptsforshot,a1	;Point value for current shot (1-3)
	add	a1,a0
	jrz	#ties_it
	jrn	#behind
#wins_it
	movi	scrs10,a0		;IT IS....
	calla	speech_play
	jrc	#snd_fail
	movk	1,a0
	move	a0,@freakout		;freak out if it scores
	rets

#ties_it
	movi	shts6,a0		;launches a shot
	calla	speech_play
	jrc	#snd_fail

	movk	2,a0
	move	a0,@freakout		;freak out if it scores
	rets


#behind
#in_front
#not_last_qtr
#check_buzzer
	move	@game_time,a0,L
	cmpi	200h,a0
	jrgt	#snd_fail

	movi	shts7,a0		;at the buzzer
	callr	speech_playovrp
	jrc	#snd_fail
	rets

#snd_fail
	setc
	rets

#*****************************************************************************
;
;CC = lucky bounce called
;CS = lucky bounce NOT called

 SUBRP	lucky_bounce

	move	@shot_type,a0
	cmpi	DUNK_SHORT,a0		;no lucky bounce on dunks!
	jrge	#snd_fail

	move	@ugly_stat,a0
	jrz	#snd_fail		;ugly not called

	movi	scrs13,a0		;gets a lucky bounce
	calla	speech_play
	jrc	#snd_fail
	clrc
	rets

#snd_fail
	setc
	rets

#*****************************************************************************
;
;CC = ugly called
;CS = ugly NOT called

 SUBRP	ugly_shot

	move	@shot_percentage,a0	;0=ugly, 1=ok
	jrn	#doit
	jrnz	#snd_fail

	movi	100,a0			;call ugly 20% time
	calla	RNDPER
	jrls	#snd_fail

#doit
	movi	2,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#uglytab,a0
	move	*a0,a0,L
	calla	speech_play
	jrc	#snd_fail

	movk	1,a0
	move	a0,@ugly_stat		;ugly called

	clrc
	rets

#snd_fail
	setc
	rets

#uglytab
	.long	ugly0	;ugly shot!
	.long	ugly1	;puts up a brick
	.long	ugly2	;terrible shot!


#*****************************************************************************
;calls team names speech
;a0 = team number to call (0-26)

 SUBR	call_team_name

	sll	6,a0			;x 16bits x 4
	addi	team_speech,a0
	calla	speech_play
	rets


#*****************************************************************************

 SUBR	call_matchup

	SLEEP	20

	movi	matchup,a0
	calla	snd_play1

	SLEEP	1*TSEC+20

	move	@team1,a2
	sll	6,a2			;x 16bits x 4
	addi	team_speech,a2
	movi	sound_ram,a4
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L
	movk	1,a0
	move	a0,@sound_ram+30h

	movi	versus,a2
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L
	movk	1,a0
	move	a0,@sound_ram+40h+30h

	move	@team2,a2
	sll	6,a2			;x 16bits x 4
	addi	team_speech,a2
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L

	movi	sound_ram,a0
	calla	snd_play1

	DIE


#*****************************************************************************
* a0 = player who last scored or shot

calc_score_diff

	PUSH	a0,a1,a2

	move	@scores,a1
	move	@scores+10h,a2
	sub	a2,a1
	srl	1,a0
	jrz	#team1
	neg	a1			;team2, so negate
#team1
	move	a1,@score_diff
	PULL	a0,a1,a2
	rets

#*****************************************************************************
;called when player with ball gets pushed and loses ball

 SUBR	pushed_speech

	movi	4,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#pushtab,a0
	move	*a0,a0,L
	jrz	#snd_fail
	calla	speech_play

#snd_fail
	setc
	rets

#pushtab
	.long	munged		;0 munged
	.long	ambushed	;1 ambushed
	.long	excuse		;2 excuse me
	.long	tofloor		;3 knocked to the floor
	.long	takethat	;4 take that

#*****************************************************************************
;called when a player rejects a shot

 SUBR	rejected_speech

;Check to make sure ball is high enough in air
	move	@ballobj_p,a1,L
	move	*a1(OYPOS),a0
	cmpi	-28,a0
	jrgt	#yes		;Br=near ground

	movk	7,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#regtab,a0
	move	*a0,a0,L
	calla	speech_playovrp
#yes
	rets

#regtab
	.long	reject		;0 rejected!
	.long	reject		;1 rejected!
	.long	rejects		;2 rejects the shot
	.long	greatd		;3 great defense
	.long	greatd		;4 great defense
	.long	noway		;5 no way!
	.long	getout		;6 get that outta here!
	.long	getout		;8 get that outta here!

#*****************************************************************************
;called when a player rejects a dunk

 SUBR	rejected_dnk_speech

;Check to make sure ball is high enough in air
	move	@ballobj_p,a1,L
	move	*a1(OYPOS),a0
	cmpi	-28,a0
	jrgt	#yes		;Br=near ground

	movk	3,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#regdnktab,a0
	move	*a0,a0,L
	calla	speech_playovrp
#yes
	rets

#regdnktab
	.long	reject		;0 rejected!
	.long	reject		;1 rejected!
	.long	noway		;2 no way!
	.long	getout		;3 get that outta here!
;	.long	getoutb		;4 get that beep outta here!

#*****************************************************************************

 SUBR	rebound_speech

	PUSH	a1,a2

	move	@game_time,a0,L	;don't call if clock run down
	jrz	#snd_fail

	movi	1,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#rebtab,a0
	move	*a0,a0,L

	move	@ballpnum,a1
	jrn	#snd_fail

	sll	4,a1			;x16
	addi	special_heads,a1	;-1 = normal player head
	move	*a1,a1
;	jrnn	#no_name

	move	@last_name,a2
	cmp	a1,a2
	jrne	#call_name

#no_name
	calla	speech_play
	jrc	#snd_fail
	PULL	a1,a2
	rets

#call_name
	movi	sound_ram+40h,a2
	move	*a0+,*a2+,L
	move	*a0+,*a2+,L

	move	@ballpnum,a0

;Fix for new players
;	move	a0,a1
;	srl	1,a1			;team 0-1
;	sll	4,a1			;x 16
;	addi	player_toggle1,a1
;	move	*a1,a1			;toggle names?
;	jrz	#no_toggle
;	xori	1,a0			;toggle
;#no_toggle


	move	a0,a1
	sll	5,a1
	addi	spch_name_ram,a1
	move	*a1,a0,L


;	move	a0,a1
;	srl	1,a0			;team 0-1
;	sll	4,a0
;	addi	team1,a0
;	move	*a0,a0			;team (0-26)
;	sll	7,a0			;x 16bits x 4 x 2
;	addi	name_speech,a0
;	andi	1,a1
;	sll	6,a1			;x 16bits x 4
;	add	a1,a0
 

	movi	sound_ram,a2
	move	*a0+,*a2+,L
	move	*a0+,*a2+,L
	movk	1,a0
	move	a0,@sound_ram+30h
	movi	sound_ram,a0
	calla	speech_play
	jrc	#snd_fail

	move	@ballpnum,a0
	move	a0,@last_name		;last player name called
	clr	a0
	move	a0,@last_name_time	;# ticks since name called

	PULL	a1,a2
	rets


#snd_fail
	setc
	PULL	a1,a2
	rets

#rebtab
	.long	grabreb		;0 grabs the rebound
	.long	grabreb		;0 grabs the rebound
;	.long	withbrd		;1 comes away with the board


#*****************************************************************************

 SUBR	intercepted_speech

	movi	1,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#intcptab,a0
	move	*a0,a0,L
	calla	speech_playovrp
	rets

#intcptab
	.long	intrcpt		;intercepted!
	.long	turnovr		;the turnover!

#*****************************************************************************

 SUBR	stolen_speech

	movi	1,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#stealstab,a0
	move	*a0,a0,L
	calla	speech_playovrp
	rets

#stealstab
	.long	turnovr		;the turnover!
	.long	stolen		;stolen!


#*****************************************************************************
;calls "it's good" whenever a player scores from 3pt out with no time left
;CC = it's good called
;CS = it's good NOT called

 SUBRP	itsgood

	move	@game_time,a0,L
	jrnz	#snd_fail

	movi	scrs1,a0	;it's good (excited)
	calla	speech_play
	jrc	#snd_fail
	rets

#snd_fail
	setc
	rets


#*****************************************************************************

 SUBR	seq_lay_up_start

	movi	scrs15,a0	;lays it up
	calla	speech_play
	rets

#*****************************************************************************
* B4=*Next data in seq list

 SUBR	seq_jam_speech

	move	*b4+,b0
	move	b0,a0		;jam speech type
	move	a0,@jam_speech	;speech type to call when jammed
 	rets

#*****************************************************************************
* a0 = % of swishes to call

 SUBRP	swish_speech

	move	@ballrimhitcnt,a1
	jrnz	#noswish

	move	@ballbbhitcnt,a1
	jrnz	#snd_fail

	calla	RNDPER
	jrls	#snd_fail

#doit
	movi	2,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#swishtab,a0
	move	*a0,a0,L
	calla	speech_play
	rets
#snd_fail
	setc
	rets

#noswish
	cmpi	9,a1
	jrlt	#snd_fail

	movi	scrs13,a0	;gets a lucky bounce
	calla	speech_play

	rets


#swishtab
	.long	swish_snd	;0 SWISH!
	.long	allnet_snd	;1 nothing but net
	.long	swish_snd	;2 SWISH!


#*****************************************************************************
* A11=Team who gets ball (0=1, !0=2)

 SUBR	call_scores

	PUSH	a0,a1,a7,a14
	PUSH	b0,b1

	move	@game_time,a0,L
	jrz	#no_call0

	cmpi	010000h,a0		;10 seconds
	jrlt	#no_call0

;	move	@gmqrtr,a1		;don't call if in last quarter and
;	cmpi	3,a1			;less than 30 seconds on clock
;	jrlt	#not_last_qtr
;	cmpi	030000h,a0		;30 seconds
;	jrlt	#no_call0

#not_last_qtr

	move	@next_call,a0
	jrz	#do_call
	dec	a0
	move	a0,@next_call
	jruc	#no_call0

#do_call
	CREATE0	call_scores_proc

#no_call0
	PULL	b0,b1
	PULL	a0,a1,a7,a14
	rets


 SUBRP	call_scores_proc

	SLEEP	TSEC+30

	move	@game_time,a0,L
	jrz	#no_call

	move	@scores,a1
	move	@scores+10h,a0
	sub	a0,a1

	move	a11,a11
	jrnz	#tm1_scored
#tm2_scored
	move	@team2,a2
	neg	a1
	jruc	#cnt

#tm1_scored
	move	@team1,a2
#cnt
	sll	6,a2			;x 16bits x 4
	addi	team_speech,a2
	movi	sound_ram,a4
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L
	movk	1,a0
	move	a0,@sound_ram+30h

	movi	upby,a2
	move	a1,a1
	jrz	#tied
	jrp	#pos

	movi	downby,a2
	neg	a1
#pos
	cmpi	20,a1
	jreq	#ok
	cmpi	15,a1
	jreq	#ok
	cmpi	10,a1
	jrgt	#outrange


#ok
	movi	sound_ram+40h,a4
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L
	movk	1,a0
	move	a0,@sound_ram+40h+30h

	sll	5,a1			;x 32 bits
	addi	#numtab-20h,a1
	move	*a1,a2,L
	movi	sound_ram+80h,a4
	move	*a2+,*a4+,L
	move	*a2+,*a4+,L

	movi	sound_ram,a0
	calla	speech_play
	jrc	#snd_fail		;so try again

	movi	2,a0
	move	a0,@next_call

#snd_fail
#outrange
#no_call
	DIE


#tied
	movi	scrtied,a0		;the score is tied
	calla	speech_play
	jrc	#snd_fail		;so try again

	movi	2,a0
	move	a0,@next_call

	move	@gmqrtr,a0
	jrz	#noorg
	movi	150,a0
	calla	RNDPER
	jrls	#noorg

	move	@game_time,a1,L
	cmpi	020000h,a1
	jrlt	#noorg

	SLEEP	3*60

	movi	organ1_snd,a1
	btst	0,a0
	jrz	#org1
	movi	organ2_snd,a1
#org1	move	a1,a0
	calla	snd_play1ovr

#noorg

	DIE

#numtab
	.long	snd_1
	.long	snd_2
	.long	snd_3
	.long	snd_4
	.long	snd_5
	.long	snd_6
	.long	snd_7
	.long	snd_8
	.long	snd_9
	.long	snd_10
	.long	0,0,0,0
	.long	snd_15
	.long	0,0,0,0
	.long	snd_20


;RJR
	movi	needshot,a0		;They need a shot here


#*****************************************************************************
* process

 SUBR	name_call

#restart
	movi	TSEC*2,a10
#loop
	SLEEPK	1

	move	@game_time,a0,L
	jrz	#restart

	move	@inbound,a0
	jrnn	#restart

	move	@ballpnum,a0
	jrn	#restart		;ball free

;	move	a0,a1
;	sll	4,a1			;x16
;	addi	special_heads,a1	;-1 = normal player head
;	move	*a1,a1
;	jrnn	#restart

	move	a0,a1
	sll	5,a1			;*32
	addi	plyrproc_t,a1
	move	*a1,a1,L
	move	*a1(plyr_seqflgs),a1
	btst	DUNK_B,a1
	jrnz	#restart

	dsj	a10,#loop

	move	@last_name,a1		;if name called in last 3 secs
	cmp	a0,a1
	jrne	#diff_name

	move	@last_name_time,a1	;# ticks since name called
	cmpi	TSEC*2,a1
	jrlt	#restart

#diff_name
	callr	call_player_name

	movi	TSEC*4,a10
	jruc	#loop


#*****************************************************************************
;CC = onfire called
;CS = onfire NOT called

 SUBRP	onfire_speech

	move	@game_time,a0,L
	jrz	#snd_fail


	move	@ballpnumscored,a0	;Last plyr who scored (0-3) or neg
;	move	@fire_flags,a14
;	btst	a0,a14
;	jrz	#normf
;
;	move	@ballnumscored,a0	;# times last plyr scored
;	cmpi	4,a0
;	jrge	#onfire
;	cmpi	3,a0
;	jrne	#snd_fail		;is cold
;
;	movi	heatup_snd,a0
;	jruc	#heatup
;
;#normf

	move	@ballnumscored,a0	;# times last plyr scored
	cmpi	3,a0
	jrge	#onfire
	cmpi	2,a0
	jrne	#snd_fail		;is cold

	movi	heatup_snd,a0
	jruc	#heatup

#onfire
	move	@plyrnumonfire,a0	;plyr who is on fire
	move	@ballpnumscored,a1	;Last plyr who scored (0-3) or neg
	cmp	a0,a1
	jrne	#was_teammate

	move	@shot_type,a0
	jrnz	#not_desp

	movi	400,a0			;call desp speech 40% time
	calla	RNDPER
	jrhi	hotscored

#not_desp
	movi	3,a0
	calla	rndrng0
	sll	5,a0		;x 32 bits
	addi	#onfiretab,a0
	move	*a0,a0,L
#heatup
	callr	speech_playovrp
	rets

#was_teammate
#snd_fail
	setc
	rets

#onfiretab
	.long	onfire_snd		;0 he's on fire
	.long	hothand			;1 he's got a hot hand
	.long	takethat		;2 take that!
	.long	uncon			;3 he's unconscious

#*****************************************************************************
* call wide open if applicable

	.asg	140,RANGE

 SUBRP	 wideopen_speech

	move	@plyr_shot,a0		;player who shot last (0-3)
	sll	5,a0			;*32
	addi	plyrproc_t,a0
	move	*a0,a0,L
	move	*a0(plyr_o1dist),a1	;opponent 1 dist
	cmpi	RANGE,a1
	jrlt	#not_open
	move	*a0(plyr_o2dist),a1	;opponent 2 dist
	cmpi	RANGE,a1
	jrlt	#not_open

	movi	wideopen,a0
	calla	speech_play

	rets

#not_open
	setc
	rets


#*****************************************************************************

	.asg	3,BRICK_MAX

 SUBR	nogood_speech

	PUSH	a10

	move	@ballpnumshot,a10
	sll	4,a10			;x 16
	addi	brick_count,a10
	move	*a10,a1			;brick_count
	cmpi	BRICK_MAX,a1
	jrlt	#no_good
	movi	cantbuy,a0		;can't buy a bucket
	callr	speech_play
	jrc	#failed
	clr	a0
	move	a0,*a10			;played, now clear it

#no_good
	move	@game_time,a0,L		;always call if clock at zero
	jrz	#doit_baby

	movi	400,a0			;don't call 40% of no goods
	calla	RNDPER
	jrls	#failed

#doit_baby
	movi	nogood,a0		;NO GOOD!
	callr	speech_play

#failed
	PULL	a10
	rets

#*****************************************************************************

 SUBR	victory_speech

	move	@team1,a0
	move	@scores,a1
	move	@scores+10h,a2
	cmp	a1,a2
	jrlt	#t1_wins
	move	@team2,a0
#t1_wins
	sll	6,a0			;x 16bits x 4
	addi	team_speech,a0

	movi	sound_ram2,a4
	move	*a0+,*a4+,L
	move	*a0+,*a4+,L
	movk	1,a0
	move	a0,@sound_ram2+30h

	movi	wingame,a0
	move	*a0+,*a4+,L
	move	*a0+,*a4+,L

	movi	sound_ram2,a0
	callr	speech_play

	rets

#******************************************************************************

;After teams have been selected, call this routine
;Stuff name_ram for calling player name based on who's been picked

	.ref	player_names,tm1set,tm2set,name_sort

 SUBR	setup_speech

	movi	player_names,a10
	move	@team1,a2

;	cmpi	27,a2
;	jrnz	#lp3
;	movi	name_speech,a10
;	movi	pass_speech,a0
;	jruc	#tag2

#lp3	cmpi	0,a2
	jrz	#out3
	addi	20*64,a10
	dec	a2
	jruc	#lp3
#out3
	move	@team1,a0
	sll	4,a0
	addi	tm1set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10

	move	*a10,a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp4
	inc	a10
	move	*a14+,a1,L
	cmp	a1,a0
	jrnz	#lp4

	sll	6,a10
	move	a10,a0
	addi	name_speech,a10
	addi	pass_speech,a0

	move	@special_heads,a14
	jrn	#tag1
	sll	6,a14
	addi	special_name_speech,a14
	move	a14,a10
#tag1
	move	@special_heads,a14
	jrn	#tag2
	sll	6,a14
	addi	special_pass_speech,a14
	move	a14,a0
#tag2

	move	a10,@spch_name_ram,L
	move	a0,@spch_pass_ram+32,L

#*

;Player 2 on team 1

	movi	player_names,a10
	move	@team1,a2



;	cmpi	27,a2
;	jrnz	#lp3
;	movi	_brwn,a10
;	movi	to_brwn,a0
;	jruc	#tag2a



#lp3	cmpi	0,a2
	jrz	#out3
	addi	20*64,a10
	dec	a2
	jruc	#lp3
#out3
	move	@team1,a0
	sll	4,a0
	addi	tm1set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10

	addk	32,a10

	move	*a10,a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp4
	inc	a10
	move	*a14+,a1,L
	cmp	a1,a0
	jrnz	#lp4

	sll	6,a10
	move	a10,a0
	addi	name_speech,a10
	addi	pass_speech,a0

	move	@special_heads+10h,a14
	jrn	#tag1a
	sll	6,a14
	addi	special_name_speech,a14
	move	a14,a10
#tag1a
	move	@special_heads+10h,a14
	jrn	#tag2a
	sll	6,a14
	addi	special_pass_speech,a14
	move	a14,a0
#tag2a


	move	a10,@spch_name_ram+32,L
	move	a0,@spch_pass_ram,L


#*
;Do team 2

	movi	player_names,a10
	move	@team2,a2
#lp3	cmpi	0,a2
	jrz	#out3
	addi	20*64,a10
	dec	a2
	jruc	#lp3
#out3
	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10

	move	*a10,a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp4
	inc	a10
	move	*a14+,a1,L
	cmp	a1,a0
	jrnz	#lp4

	sll	6,a10
	move	a10,a0
	addi	name_speech,a10
	addi	pass_speech,a0

	move	@special_heads+20h,a14
	jrn	#tag1b
	sll	6,a14
	addi	special_name_speech,a14
	move	a14,a10
#tag1b
	move	@special_heads+20h,a14
	jrn	#tag2b
	sll	6,a14
	addi	special_pass_speech,a14
	move	a14,a0
#tag2b

	move	a10,@spch_name_ram+64,L
	move	a0,@spch_pass_ram+96,L

#*

;Player 2 on team 2

	movi	player_names,a10
	move	@team2,a2
#lp3	cmpi	0,a2
	jrz	#out3
	addi	20*64,a10
	dec	a2
	jruc	#lp3
#out3
	move	@team2,a0
	sll	4,a0
	addi	tm2set,a0
	move	*a0,a14
	sll	6,a14
	add	a14,a10

	addk	32,a10

	move	*a10,a0,L
	movi	name_sort,a14
	movi	-1,a10
#lp4
	inc	a10
	move	*a14+,a1,L
	cmp	a1,a0
	jrnz	#lp4

	sll	6,a10
	move	a10,a0
	addi	name_speech,a10
	addi	pass_speech,a0

	move	@special_heads+30h,a14
	jrn	#tag1c
	sll	6,a14
	addi	special_name_speech,a14
	move	a14,a10
#tag1c
	move	@special_heads+30h,a14
	jrn	#tag2c
	sll	6,a14
	addi	special_pass_speech,a14
	move	a14,a0
#tag2c

	move	a10,@spch_name_ram+96,L
	move	a0,@spch_pass_ram+64,L

	rets

	.end
