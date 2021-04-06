**************************************************************
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
	.include	"shawn.hdr"		;Macros
	.include	"imgtbl.glo"
	.include	"plyrhd.tbl"
	.asg		0,SEQT
	.include	"plyr.equ"


;sounds external


;symbols externally defined

	.ref	team1,team2
	.ref	special_heads,spechds_t
	.ref	ATL_t,name_sort,player_names
	.ref	tm1set,tm2set
	.ref	attrib1_obj,attrib2_obj
	.ref	attrib3_obj,attrib4_obj


;symbols defined in this file


	.def	Kemp_h,Pippen_h,Gill_h,Daughert_h,Mullin_h,Wilkins_h

	.def	Worthy_h,Laetner_h,Hawkins_h,LJohnson_h,Divac_h,Seikaly_h
	.def	KMalone_h,Stockton_h,Ewing_h,RHarper_h
	.def	Seikaly_h,Price_h,Rice_h,Miller_h,Mutumbo_h,Oakley_h,Olajuwon_h
	.def	Skiles_h
;Lewis_h,Petrovic_h
	.def	Porter_h,Schrempf_h,Robinson_h,Tisdale_h
	.def	Webb_h,Smith_h,Thomas_h
	.def	Person_h,Augmon_h,Benjamin_h,Barkley_h,Coleman_h,Drexler_h
	.def	Ellis_h,Elliot_h,Hardaway_h,DHarper_h,HCGrant_h,HVGrant_h
	.def	Hornacek_h,Majerle_h,Manning_h

;uninitialized ram definitions


;equates for this file



	.text


#*******************************
* Set * to player attribute table
* A8=Plyr #
* A13=*Plyr process
* >A10=*Attribute for uniform (ignores spechds)
* Trashes scratch

 SUBR	plyr_getattributes

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
	addi	20*64,a10
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
	addi	320+16*3,a1
	dec	a10
	jruc	#lp5

#out

;	move	@team1,a1
;	btst	1,a8
;	jrz	#t1
;	move	@team2,a1
;#t1
;	sll	5,a1
;	addi	tm_t,a1
;	move	*a1,a1,L
;
;	btst	0,a8
;	jrz	#p0			;Plyr0?
;	addi	PAT_SIZE,a1
;#p0
	move	a1,a10

	move	a8,a0
	sll	4,a0			;*16
	addi	special_heads,a0
	move	*a0,a0
	jrn	#norm2
	movi	PAT_SIZE,a1
	mpyu	a0,a1
	addi	spechds_t,a1

#norm2	move	a1,*a13(plyr_attrib_p),L

	rets

;a_tbl	.long	attrib1_obj+20h,attrib2_obj+20h
;	.long	attrib3_obj+20h,attrib4_obj+20h

a1_tbl	.long	team1,team1
	.long	team2,team2

a2_tbl	.long	tm1set,tm1set
	.long	tm2set,tm2set

a3_tbl	.long	0,32
	.long	0,32


#********************************
* A8=plyr # 0-3
* >A0=*plyr head img

 SUBR	getwindowhead

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
	addi	20*64,a10
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
	addi	320+16*3,a1
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

	rets


Worthy_h
	.long	worthy1
	.long	worthy1
	.long	worthy2,worthy3,worthy4,worthy5,worthy6,worthy7,worthy8,worthy9
	.long	worthy10,worthy11,worthy12,worthy13,worthy14,worthy15,worthy16
Laetner_h
	.long	laet1
	.long	laet1,laet2,laet3,laet4,laet5,laet6,laet7,laet8,laet9,laet10
	.long	laet11,laet12,laet13,laet14,laet15,laet16
Hawkins_h
	.long	hawkins1
	.long	hawkins1,hawkins2,hawkins3
	.long	hawkins4,hawkins5,hawkins6,hawkins7,hawkins8,hawkins9,hawkins10
	.long	hawkins11,hawkins12,hawkins13,hawkins14,hawkins15,hawkins16
LJohnson_h
	.long	johnson1
	.long	johnson1
	.long	johnson2,johnson3,johnson4,johnson5,johnson6,johnson7,johnson8,johnson9
	.long	johnson10,johnson11,johnson12,johnson13,johnson14,johnson15,johnson16
Divac_h	.long	divac1
	.long	divac1,divac2,divac3,divac4,divac5,divac6,divac7,divac8,divac9,divac10
	.long	divac11,divac12,divac13,divac14,divac15,divac16
;Lewis_h
;	.long	lewis1
;	.long	lewis1,lewis2,lewis3,lewis4,lewis5
;	.long	lewis6,lewis7,lewis8,lewis9,lewis10
;	.long	lewis11,lewis12,lewis13,lewis14,lewis15
;	.long	lewis16
;	.long	ewing11,ewing12,ewing13,ewing14,ewing15
KMalone_h
	.long	kmalone1
	.long	kmalone1,kmalone2,kmalone3,kmalone4,kmalone5
	.long	kmalone6,kmalone7,kmalone8,kmalone9,kmalone10
	.long	kmalone11,kmalone12,kmalone13,kmalone14,kmalone15
	.long	kmalone16
	.long	ewing11,ewing12,ewing13,ewing14,ewing15
Stockton_h
	.long	stock1
	.long	stock1,stock2,stock3,stock4,stock5
	.long	stock6,stock7,stock8,stock9,stock10
	.long	stock11,stock12,stock13,stock14,stock15
	.long	stock16
	.long	ewing11,ewing12,ewing13,ewing14,ewing15
Ewing_h
	.long	ewing1
	.long	ewing1,ewing2,ewing3,ewing4,ewing5
	.long	ewing6,ewing7,ewing8,ewing9,ewing10
	.long	ewing11,ewing12,ewing13,ewing14,ewing15
	.long	ewing16
	.long	ewing11,ewing12,ewing13,ewing14,ewing15
RHarper_h
	.long	rharp1
	.long	rharp1,rharp2,rharp3,rharp4,rharp5
	.long	rharp6,rharp7,rharp8,rharp9,rharp10
	.long	rharp11,rharp12,rharp13,rharp14,rharp15
	.long	rharp16
	.long	ewing11,ewing12,ewing13,ewing14,ewing15

Seikaly_h
	.long	shiek1
	.long	shiek1,shiek2,shiek3,shiek4,shiek5
	.long	shiek6,shiek7,shiek8,shiek9,shiek10
	.long	shiek11,shiek12,shiek13,shiek14,shiek15
	.long	shiek16
	.long	ewing11,ewing12,ewing13,ewing14,ewing15
Miller_h
	.long	Miller1
	.long	Miller1,Miller2,Miller3,Miller4,Miller5,Miller6,Miller7
	.long	Miller8,Miller9,Miller10,Miller11,Miller12,Miller13,Miller14,Miller15
	.long	Miller16
Mutumbo_h
	.long	Mutumbo1
	.long	Mutumbo1,Mutumbo2,Mutumbo3,Mutumbo4,Mutumbo5,Mutumbo6,Mutumbo7
	.long	Mutumbo8,Mutumbo9,Mutumbo10,Mutumbo11,Mutumbo12,Mutumbo13,Mutumbo14
	.long	Mutumbo15,Mutumbo16
Oakley_h
	.long	Oakley1
	.long	Oakley1,Oakley2,Oakley3,Oakley4,Oakley5,Oakley6
	.long	Oakley7,Oakley8,Oakley9,Oakley10,Oakley11,Oakley12,Oakley13,Oakley14
	.long	Oakley15,Oakley16
Olajuwon_h
	.long	Hakeem1
	.long	Hakeem1,Hakeem2,Hakeem3,Hakeem4,Hakeem5,Hakeem6
	.long	Hakeem7,Hakeem8,Hakeem9,Hakeem10,Hakeem11,Hakeem12,Hakeem13,Hakeem14
	.long	Hakeem15,Hakeem16
;Petrovic_h
;	.long	Petro1
;	.long	Petro1,Petro2,Petro3,Petro4,Petro5,Petro6,Petro7
;	.long	Petro8,Petro9,Petro10,Petro11,Petro12,Petro13,Petro14,Petro15,Petro16
Porter_h
	.long	Porter1
	.long	Porter1,Porter2,Porter3,Porter4,Porter5,Porter6,Porter7,Porter8,Porter9
	.long	Porter10,Porter11,Porter12,Porter13,Porter14,Porter15,Porter16
Price_h
	.long	Price1
	.long	Price1
	.long	Price2,Price3,Price4,Price5,Price6,Price7,Price8,Price9,Price10,Price11
	.long	Price12,Price13,Price14,Price15,Price16
Rice_h
	.long	Rice1
	.long	Rice1,Rice2,Rice3,Rice4,Rice5
	.long	Rice6,Rice7,Rice8,Rice9,Rice10,Rice11,Rice12,Rice13,Rice14,Rice15
	.long	Rice16
Robinson_h
	.long	Robins1
	.long	Robins1,Robins2,Robins3,Robins4,Robins5,Robins6,Robins7,Robins8
	.long	Robins9,Robins10,Robins11,Robins12,Robins13,Robins14,Robins15,Robins16
Schrempf_h
	.long	schremp1
	.long	schremp1,schremp2
	.long	schremp3,schremp4,schremp5,schremp6,schremp7,schremp8,schremp9
	.long	schremp10,schremp11,schremp12,schremp13,schremp14,schremp15,schremp16
Skiles_h
	.long	skiles1
	.long	skiles1,skiles2,skiles3,skiles4,skiles5,skiles6,skiles7,skiles8,skiles9
	.long	skiles10,skiles11,skiles12,skiles13,skiles14,skiles15,skiles16
;ONeal_h
;	.long	oneil1
;	.long	oneil1
;	.long	oneil2,oneil3,oneil4,oneil5,oneil6,oneil7,oneil8,oneil9,oneil10,oneil11
;	.long	oneil12,oneil13,oneil14,oneil15,oneil16
Smith_h
	.long	smith1
	.long	smith1,smith2,smith3,smith4
	.long	smith5,smith6,smith7,smith8,smith9,smith10,smith11,smith12,smith13
	.long	smith14,smith15,smith16
Thomas_h
	.long	thomas1
	.long	thomas1,thomas2,thomas3,thomas4,thomas5,thomas6
	.long	thomas7,thomas8,thomas9,thomas10,thomas11,thomas12,thomas13,thomas14
	.long	thomas15,thomas16
Tisdale_h
	.long	tisdale1
	.long	tisdale1,tisdale2,tisdale3,tisdale4,tisdale5,tisdale6
	.long	tisdale7,tisdale8,tisdale9,tisdale10,tisdale11,tisdale12,tisdale13
	.long	tisdale14,tisdale15,tisdale16
Webb_h
	.long	webb1
	.long	webb1,webb2,webb3,webb4,webb5,webb6,webb7
	.long	webb8,webb9,webb10,webb11,webb12,webb13,webb14,webb15,webb16
	.long	ewing11,ewing12,ewing13,ewing14,ewing15
	.long	ewing11,ewing12,ewing13,ewing14,ewing15

Kemp_h
	.long	kemp1
	.long	kemp1,kemp2,kemp3,kemp4,kemp5,kemp6,kemp7,kemp8,kemp9
	.long	kemp10,kemp11,kemp12,kemp13,kemp14,kemp15,kemp16
Pippen_h
	.long	pippin1
	.long	pippin1,pippin2,pippin3,pippin4,pippin5,pippin6,pippin7,pippin8,pippin9
	.long	pippin10,pippin11,pippin12,pippin13,pippin14,pippin15,pippin16
Gill_h
	.long	gill1
	.long	gill1
	.long	gill2,gill3,gill4,gill5,gill6,gill7,gill8,gill9,gill10,gill11,gill12
	.long	gill13,gill14,gill15,gill16
Daughert_h
	.long	daug1
	.long	daug1,daug2,daug3,daug4,daug5,daug6,daug7
	.long	daug8,daug9,daug10,daug11,daug12,daug13,daug14,daug15,daug16
Mullin_h
	.long	mullin1
	.long	mullin1
	.long	mullin2,mullin3,mullin4,mullin5,mullin6,mullin7,mullin8,mullin9
	.long	mullin10,mullin11,mullin12,mullin13,mullin14,mullin15,mullin16
Wilkins_h
	.long	wilkens1
	.long	wilkens1
	.long	wilkens2,wilkens3,wilkens4,wilkens5,wilkens6,wilkens7,wilkens8,wilkens9
	.long	wilkens10,wilkens11,wilkens12,wilkens13,wilkens14,wilkens15,wilkens16
Person_h
	.long	Person1
	.long	Person1,Person2,Person3,Person4,Person5,Person6,Person7,Person8,Person9
	.long	Person10,Person11,Person12,Person13,Person14,Person15,Person16
Augmon_h
	.long	Augmon1
	.long	Augmon1
	.long	Augmon2,Augmon3,Augmon4,Augmon5,Augmon6,Augmon7,Augmon8,Augmon9
	.long	Augmon10,Augmon11,Augmon12,Augmon13,Augmon14,Augmon15,Augmon16
Benjamin_h
	.long	Benja1
	.long	Benja1
	.long	Benja2,Benja3,Benja4,Benja5,Benja6,Benja7,Benja8,Benja9,Benja10,Benja11
	.long	Benja12,Benja13,Benja14,Benja15,Benja16
Barkley_h
	.long	Barkley1
	.long	Barkley1,Barkley2,Barkley3
	.long	Barkley4,Barkley5,Barkley6,Barkley7,Barkley8,Barkley9,Barkley10
	.long	Barkley11,Barkley12,Barkley13,Barkley14,Barkley15,Barkley16
Coleman_h
	.long	Cole1
	.long	Cole1,Cole2
	.long	Cole3,Cole4,Cole5,Cole6,Cole7,Cole8,Cole9,Cole10,Cole11,Cole12,Cole13
	.long	Cole14,Cole15,Cole16
Drexler_h
	.long	Drex1
	.long	Drex1,Drex2,Drex3,Drex4,Drex5,Drex6
	.long	Drex7,Drex8,Drex9,Drex10,Drex11,Drex12,Drex13,Drex14,Drex15,Drex16
Ellis_h
	.long	Ellis1
	.long	Ellis1,Ellis2,Ellis3,Ellis4,Ellis5,Ellis6,Ellis7,Ellis8,Ellis9,Ellis10
	.long	Ellis11,Ellis12,Ellis13,Ellis14,Ellis15,Ellis16
Elliot_h
	.long	Elliot1
	.long	Elliot1,Elliot2,Elliot3
	.long	Elliot4,Elliot5,Elliot6,Elliot7,Elliot8,Elliot9,Elliot10,Elliot11
	.long	Elliot12,Elliot13,Elliot14,Elliot15,Elliot16
Hardaway_h
	.long	Hrdaway1
	.long	Hrdaway1,Hrdaway2,Hrdaway3
	.long	Hrdaway4,Hrdaway5,Hrdaway6,Hrdaway7,Hrdaway8,Hrdaway9,Hrdaway10
	.long	Hrdaway11,Hrdaway12,Hrdaway13,Hrdaway14,Hrdaway15,Hrdaway16
DHarper_h
	.long	HarpMav1
	.long	HarpMav1,HarpMav2,HarpMav3,HarpMav4,HarpMav5,HarpMav6,HarpMav7,HarpMav8
	.long	HarpMav9,HarpMav10,HarpMav11,HarpMav12,HarpMav13,HarpMav14,HarpMav15
	.long	HarpMav16
HCGrant_h
	.long	GrantG1
	.long	GrantG1
	.long	GrantG2,GrantG3,GrantG4,GrantG5,GrantG6,GrantG7,GrantG8,GrantG9
	.long	GrantG10,GrantG11,GrantG12,GrantG13,GrantG14,GrantG15,GrantG16
HVGrant_h
	.long	Grant1
	.long	Grant1,Grant2,Grant3,Grant4,Grant5,Grant6,Grant7,Grant8
	.long	Grant9,Grant10,Grant11,Grant12,Grant13,Grant14,Grant15,Grant16
Hornacek_h
	.long	Horna1
	.long	Horna1
	.long	Horna2,Horna3,Horna4,Horna5,Horna6,Horna7,Horna8,Horna9,Horna10,Horna11
	.long	Horna12,Horna13,Horna14,Horna15,Horna16
Majerle_h
	.long	Majerle1
	.long	Majerle1
	.long	Majerle2,Majerle3,Majerle4,Majerle5,Majerle6,Majerle7,Majerle8,Majerle9
	.long	Majerle10,Majerle11,Majerle12,Majerle13,Majerle14,Majerle15,Majerle16
Manning_h
	.long	Manning1
	.long	Manning1,Manning2,Manning3,Manning4,Manning5,Manning6,Manning7,Manning8
	.long	Manning9,Manning10,Manning11,Manning12,Manning13,Manning14,Manning15
	.long	Manning16

	.long	ewing11,ewing12,ewing13,ewing14,ewing15
	.long	ewing11,ewing12,ewing13,ewing14,ewing15




	.end

