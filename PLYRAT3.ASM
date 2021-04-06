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
	.file	"plyrat3.asm"
	.title	"basketball player code"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"		;Mproc equates
	.include	"disp.equ"		;Display proc equates
	.include	"gsp.equ"		;Gsp asm equates
	.include	"sys.equ"
	.include	"macros.hdr"		;Macros
	.include	"game.equ"
	.include	"macros.hdr"		;Macros
	.include	"plyrhd5.glo"
;;	.include	"plyrhd4.tbl"
	.include	"plyrhd2.tbl"
	.include        "plyrhd.glo"
	.include	"plyrhd6.glo"


	.def	gug1,BEdwrd1

;	.def	lighten1
;	.def	lighten2
;	.def	lighten3
;	.def	lighten4
;	.def	lighten5
;	.def	lighten6
;	.def	lighten7

	.def	DEllis_h
	.def	sd_h
;	.def	RA_H
	.def	Blaylock_h
	.def	Ssmith_h
	.def	Knorman_h
;	.def	Henderso_h
	.def	Barros_h
	.def	Montross_h
	.def	Radja_h
	.def	Curry_h
	.def	Zidek_h
	.def	Kerr_h
	.def	Thill_h
	.def	Cmills_h
	.def	Phills_h
	.def	Kidd_h
	.def	Pjones_h
	.def	Rauf_h
	.def	Pack_h
	.def	Mcdyes_h
	.def	Ghill_h
	.def	Tmills_h
	.def	Thorpe_h
	.def	Sprewell_h
	.def	Jsmith_h
	.def	Cassel_h
	.def	Ddavis_h
	.def	Mckee_h
	.def	Vaught_h
	.def	Rrogers_h
	.def	Lmurray_h
	.def	Richardson_h
	.def	Bbarry_h
	.def	Vanexel_h
	.def	Ceballos_h
	.def	Ejones_h
	.def	Bowens_h
	.def	Grobinson_h
	.def	EMurdock_h
	.def	Respert_h
;	.def	Rooks_h
	.def	Garnett_h
	.def	Gilliam_h
	.def	Obannon_h
	.def	Dscott_h
	.def	Wright_h
	.def	Stackhouse_h
	.def	Wperson_h
	.def	Finley_h
	.def	Strickland_h
	.def	Sabonis_h
	.def	Bwilliams_h
	.def	Childress_h
	.def	Wwilliams_h
	.def	Bgrant_h
	.def	Marciulonis_h
	.def	Ajohnson_h
	.def	Sford_h
	.def	Crogers_h
	.def	Stoudamire_h
	.def	Anthony_h
;	.def	Gattison_h
	.def	Breeves_h
	.def	Jhoward_h
	.def	McCloud_h
	.def	Houston_h
	.def	Muresan_h	
	.def	KEdwards_h
	.def	Fox_h
	.def	Ferry_h
	.def	Longley_h
	.def	MJackson_h
	.def	Danilovic_h
	.def	OMiller_h
	.def	Delnegro_h
	.def	Douglas_h
	.def	WAnderson_h
	.def	TMurray_h
	.def	Koncak_h
	.def	Rose_h
	.def	Brandon_h
;	.def	Coles_h
	.def	DHarper_h
	.def	Edney_h
	.def	VMaxwell_h
    	.def	Cow_h
	.def	Alien_h
	.def	Mel_h
	.def	Mik_h
	.def	Joe_h
	.def	Ang_h
	.def	Lis_h
	.def	Guido_h
	.def	Ber_h
	.def	Chk_h
	.def	Fat_h
	.def	Fra_h
	.def	Gor_h
	.def	Gre_h
	.def	Old_h
	.def	Pig_h
	.def	Wiz_h
	.def	fifi_h
	.def	eric_h
	.def	madball_h
	.def	jackjr_h
	.def	kim_h
	.def	clown_h
	.def	ape_h
	.def	cheech_h
	.def	mar_h
	.def	bardo_h
	.def	willy_h
	.def	sean_h
	.def	jeff_h
	.def	dan_h	
	.def	carym_h
	.def	eug_h
	.def	bud_h
	.def	jhey_h
	.def	jfer_h
	.def	jcartn
	.def	nicke_h
	.def	jroot_h
	.def	mxv_h
	.def	min_h
	.def	eddie_h
	.def	roan_h
	.def	turmel_h
	.def	jamie_h
	.def	patf_h
	.def	mperry_h
	.def	neilf_h
	.def	edboon_h
	.def	jtobias_h
	.def	oursler_h
	.def	marty_h
	.def	carlos_h
	.def	jason_h
	.def	quinn_h
	.def	mike_h
	.def	dim_h
	.def	mdoc_h
	.text


quinn_h
	HDMAC	QUINN01
edboon_h
	HDMAC	BOON01
jtobias_h
	HDMAC	TOBIAS01
oursler_h
	HDMAC	OURSL01
marty_h
	HDMAC2	MARTY01
carlos_h
	HDMAC2	CARLOS01
jason_h
	HDMAC2	JASON01
roan_h
	HDMAC	ROH01
turmel_h
	HDMAC	TURMEL01
jamie_h	
	HDMAC	JAMIE01
patf_h
	HDMAC	PAT01
mperry_h
	HDMAC	PERRY01
mdoc_h
	HDMAC	MDOC01
neilf_h	
	HDMAC2	NEILF01
fifi_h
	HDMAC	FIFI01
jeff_h
	HDMAC	JEFF01
dan_h
	HDMAC	DAN01
carym_h
	HDMAC2	CARY01
eddie_h
	HDMAC	EDDIE01
eug_h
	HDMAC	EUGG01
bud_h
	HDMAC	BUD01
jhey_h
	HDMAC	HEY01
jfer_h
	HDMAC	JEN01
jcartn
	HDMAC	JOHNC01
nicke_h
	HDMAC	NIK01
jroot_h
	HDMAC	ROOT01
eric_h	
	HDMAC	ERI01
kim_h
	HDMAC	KIM01
mar_h	
	HDMAC	MAR01
roh_h
	HDMAC	ROH01
sean_h
	HDMAC	SEA01
cheech_h
	HDMAC	CHEECH01
clown_h
	HDMAC	CLOWN01
madball_h
	HDMAC	MADBAL01
ape_h
	HDMAC	VIKAPE01
amrich_h
	HDMAC	AMRICH01
bardo_h
	HDMAC	BARD01
dim_h
	HDMAC2	DIM01
jackjr_h
	HDMAC	JACKJR01
jigget_h
	HDMAC2	JIGGET01
jon_h
	HDMAC	JON01
mike_h
	HDMAC	MIKE01
min_h
	HDMAC	MIN01
mund_h
	HDMAC	MUND01
mxv_h
	HDMAC	MXV01
north_h
	HDMAC2	NORTH01
willy_h
	HDMAC	WIL01

;college heads

marbry_h
	HDMAC	MARBRY01
allen_h
	HDMAC	ALLEN01
camb_h
	HDMAC	CAMB01
damp_h
	HDMAC	DAMP01
dun_h
	HDMAC	DUN01
ham_h
	HDMAC	HAM01
harr_h
	HDMAC	HARR01
iversn_h
	HDMAC	IVER01
kit_h
	HDMAC	KIT01
minr_h
	HDMAC	MINR01
rily_h
	HDMAC	RILY01
wal_h
	HDMAC	WAL01

;college heads


Ber_h
	HDMAC	BER01
Chk_h
	HDMAC	CHK01
Fat_h
	HDMAC	FAT01
Fra_h
	HDMAC	FRA01
Gor_h
	HDMAC	GOR01
Gre_h
	HDMAC	GRE01
Old_h
	HDMAC	OLD01
Pig_h
	HDMAC	PIG01
Wiz_h
	HDMAC	WIZ01
	
Cow_h
	HDMAC	COW01
Alien_h
	HDMAC	ALIEN01
Mel_h
	HDMAC	MEL_01
Mik_h
	HDMAC	MIK_01
Joe_h
	HDMAC	JOE_01
Ang_h
	HDMAC	ANG_01
Lis_h
	HDMAC	LIS_01
Guido_h
	HDMAC	GUIDO01

sd_h
	HDMAC	SAL01
;RA_H
;	HDMAC	RAIDEN01
Blaylock_h
	HDMAC	BLAYLO1
Ssmith_h
	HDMAC	SSMITH1
Knorman_h
	HDMAC	KNORMA1
;Henderso_h
;	HDMAC	HENDER1
Barros_h
	HDMAC	BARROS1
Montross_h
	HDMAC	MONTRO1
Radja_h
	HDMAC	RADJA1
Curry_h
	HDMAC	CURRY1
Zidek_h
	HDMAC	ZIDEK1
Kerr_h
	HDMAC	KERR1
Thill_h
	HDMAC	THILL1
Cmills_h
	HDMAC	CMILLS1
Phills_h
	HDMAC	PHILLS1
Kidd_h
	HDMAC	KIDD1
Pjones_h
	HDMAC	PJONES1
Rauf_h
	HDMAC	RAUF1
Pack_h
	HDMAC	PACK1
Mcdyes_h
	HDMAC	MCDYES1
Ghill_h
	HDMAC	GHILL1
Tmills_h
	HDMAC	TMILLS1
Thorpe_h
	HDMAC	THORPE1
Sprewell_h
	HDMAC	SPREWE1
Jsmith_h
	HDMAC	JSMITH1
Cassel_h
	HDMAC	CASSEL1
Ddavis_h
	HDMAC	DDAVIS1
Mckee_h
	HDMAC	MCKEE1
Vaught_h
	HDMAC	VAUGHT1
Rrogers_h
	HDMAC	RROGER1
Lmurray_h
	HDMAC	LMURRA1
Richardson_h
	HDMAC	PRICHA1
Bbarry_h
	HDMAC	BBARRY1
Vanexel_h
	HDMAC	EXEL1
Ceballos_h
	HDMAC	CEBALL1
Ejones_h
	HDMAC	EJONES1
Bowens_h
	HDMAC	BOWENS1
Grobinson_h
	HDMAC	GROBIN1
EMurdock_h
	HDMAC	EMURD1
Respert_h
	HDMAC	RESPER1
;Rooks_h
;	HDMAC	ROOKS1
Garnett_h
	HDMAC	GARNET1
Gilliam_h
	HDMAC	GILLIA1
Obannon_h
	HDMAC	OBANN1
Dscott_h
	HDMAC	DSCOTT1
Wright_h
	HDMAC	WRIGHT1
Stackhouse_h
	HDMAC	STACK1
Wperson_h
	HDMAC	WPERS1
Finley_h
	HDMAC	FINLEY1
Strickland_h
	HDMAC	STRICK1
Sabonis_h
	HDMAC	SABONI1
Bwilliams_h
	HDMAC	BWILLI1
Childress_h
	HDMAC	CHILD1
Wwilliams_h
	HDMAC	WWILLI1
Bgrant_h
	HDMAC	BGRANT1
Marciulonis_h
	HDMAC	MARCIU1
Ajohnson_h
	HDMAC	AJOHN1
Sford_h
	HDMAC	FORD1
Crogers_h
	HDMAC	CROGER1
Stoudamire_h
	HDMAC	STOUD1
Anthony_h
	HDMAC	ANTHON1
;Gattison_h
;	HDMAC	GATTIS1
Breeves_h
	HDMAC	BREEV1
Jhoward_h
	HDMAC	JHOW1
McCloud_h
	HDMAC	MCCLOU1
Houston_h
	HDMAC	HOUSTO1
Muresan_h	
	HDMAC	MURESA1
KEdwards_h
	HDMAC	KEDWAR1
Fox_h
	HDMAC	FOX1
Ferry_h
	HDMAC	FERRY1
Longley_h
	HDMAC	LONG1
MJackson_h
	HDMAC	MJACKS1
Danilovic_h
	HDMAC	DANILO1
OMiller_h
	HDMAC	OMILLER1
Delnegro_h
	HDMAC	DELNEG1
Douglas_h
	HDMAC	DOUGLA1
WAnderson_h
	HDMAC	WANDERS1
TMurray_h
	HDMAC	MURRAY1
Koncak_h
	HDMAC	KONCAK1
Rose_h
	HDMAC	ROSE1
Brandon_h
	HDMAC	BRAND1
;Coles_h
;	HDMAC	COLES1
DHarper_h
	HDMAC	DHARP1
Edney_h
	HDMAC	EDNEY1
VMaxwell_h
	HDMAC	VMAX1
DEllis_h
	HDMAC	DELLIS1

	.END


