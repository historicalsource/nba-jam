	.OPTION	B,D,L,T
	.include	"BGNDTBL.GLO"
	.DATA

kjamHDRS:
	.word	180,120	;x size, y size
	.long	0136E835H	;address
	.word	05000H	;dma ctrl
blankjamBLKS:
	.word	040H	;flags
	.word	0,0 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	040H,0,120,00H
	.word	040H,0,240,00H
	.word	040H,180,0,00H
	.word	040H,180,120,00H
	.word	040H,180,240,00H
	.word	040H,360,0,00H
	.word	040H,360,120,00H
	.word	040H,360,240,00H
	.word	0FFFFH	;End Marker
blankjamBMOD:
	.word	540,360,9	;x size, y size, #blocks
	.long	blankjamBLKS, kjamHDRS, kjamPALS

SEL4HDRS:
	.word	100,104	;x size, y size
	.long	01388E15H	;address
	.word	07000H	;dma ctrl
	.word	8,74
	.long	0139AA75H
	.word	07000H
	.word	8,100
	.long	0139BAA5H
	.word	07000H
	.word	8,75
	.long	0139D085H
	.word	07000H
	.word	84,5
	.long	0139E0EDH
	.word	07000H
	.word	84,5
	.long	0139EC69H
	.word	07000H
	.word	180,5
	.long	0139F7E5H
	.word	07000H
	.word	180,5
	.long	013A1081H
	.word	07000H
	.word	104,104
	.long	013A291DH
	.word	07000H
	.word	8,76
	.long	013B50DDH
	.word	07000H
	.word	8,59
	.long	013B617DH
	.word	07000H
	.word	192,17
	.long	013B6E65H
	.word	07000H
	.word	92,5
	.long	013BC7A5H
	.word	07000H
	.word	92,5
	.long	013BD439H
	.word	07000H
	.word	4,74
	.long	013BE0CDH
	.word	05000H
	.word	100,104
	.long	013BE695H
	.word	07000H
	.word	56,17
	.long	013D02F5H
	.word	07000H
	.word	100,104
	.long	013D1CFDH
	.word	06000H
	.word	52,9
	.long	013E10BDH
	.word	07000H
	.word	8,76
	.long	013E1D89H
	.word	07000H
	.word	192,17
	.long	013E2E29H
	.word	07000H
	.word	8,74
	.long	013E8769H
	.word	06000H
	.word	8,76
	.long	013E9549H
	.word	07000H
	.word	200,104
	.long	013EA5E9H
	.word	07000H
	.word	192,17
	.long	0140DEA9H
	.word	07000H
	.word	12,59
	.long	014137E9H
	.word	07000H
	.word	192,17
	.long	01414B45H
	.word	07000H
	.word	200,104
	.long	0141A485H
	.word	07000H
	.word	192,17
	.long	0143DD45H
	.word	06000H
	.word	192,17
	.long	014429C5H
	.word	06000H
ATRBKITBLKS:
	.word	06748H	;flags
	.word	0,0 ;x,y
	.word	09H	;pal5,pal4,hdr13-0
	.word	06941H,8,0,0AH
	.word	06748H,8,59,0BH
	.word	06941H,13,0,0CH
	.word	06941H,13,54,0DH
	.word	06A41H,76,56,010H
	.word	06941H,103,0,0CH
	.word	06941H,103,54,0DH
	.word	06942H,175,61,012H
	.word	06951H,190,0,0AH
	.word	06748H,198,0,013H
	.word	06748H,202,59,014H
	.word	06941H,202,0,0AH
	.word	06941H,207,0,0CH
	.word	06941H,207,54,0DH
	.word	06A41H,270,56,010H
	.word	06941H,297,54,0DH
	.word	06941H,297,0,0CH
	.word	06951H,384,0,0AH
	.word	06748H,392,0,016H
	.word	0FFFFH	;End Marker
ATRIBUTEBLKS:
	.word	06848H	;flags
	.word	0,0 ;x,y
	.word	09H	;pal5,pal4,hdr13-0
	.word	06941H,8,0,0AH
	.word	06748H,8,59,018H
	.word	06941H,13,0,0CH
	.word	06941H,13,54,0DH
	.word	06A41H,30,56,010H
	.word	06A41H,97,0,019H
	.word	06941H,103,0,0CH
	.word	06941H,103,54,0DH
	.word	06A41H,122,56,010H
	.word	06942H,175,60,012H
	.word	06951H,190,0,0AH
	.word	06748H,197,0,013H
	.word	06941H,202,0,0AH
	.word	06748H,202,59,01CH
	.word	06941H,207,0,0CH
	.word	06941H,207,54,0DH
	.word	06A41H,224,56,010H
	.word	06A41H,291,0,019H
	.word	06941H,297,0,0CH
	.word	06941H,297,54,0DH
	.word	06A41H,317,56,010H
	.word	06951H,384,0,0AH
	.word	06748H,392,0,016H
	.word	0FFFFH	;End Marker
TEAMSEL4BLKS:
	.word	0A48H	;flags
	.word	0,0 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	0A48H,0,104,01H
	.word	0F40H,7,4,02H
	.word	0F40H,8,104,03H
	.word	0F40H,12,4,04H
	.word	0F40H,12,99,05H
	.word	0F40H,13,174,06H
	.word	0F40H,13,104,07H
	.word	0F50H,91,4,02H
	.word	0A45H,99,0,08H
	.word	0F50H,190,104,03H
	.word	0A48H,198,104,0EH
	.word	0A44H,200,0,0FH
	.word	0F43H,202,104,03H
	.word	0F43H,207,104,07H
	.word	0F43H,207,174,06H
	.word	0F43H,300,4,02H
	.word	0A48H,300,0,011H
	.word	0F43H,305,99,05H
	.word	0F43H,305,4,04H
	.word	0F53H,384,104,03H
	.word	0F53H,384,4,02H
	.word	0A48H,392,104,015H
	.word	0FFFFH	;End Marker
HTIMEBLKS:
	.word	0A46H	;flags
	.word	0,0 ;x,y
	.word	017H	;pal5,pal4,hdr13-0
	.word	0A48H,0,104,01H
	.word	0F40H,8,104,03H
	.word	0F40H,13,174,06H
	.word	0F40H,13,104,07H
	.word	0F50H,190,104,03H
	.word	0A48H,198,104,0EH
	.word	0A47H,200,0,01BH
	.word	0F43H,202,104,03H
	.word	0F43H,207,174,06H
	.word	0F43H,207,104,07H
	.word	0F53H,384,104,03H
	.word	0A48H,392,104,015H
	.word	0FFFFH	;End Marker
ATRBHTKTBLKS:
	.word	06848H	;flags
	.word	0,0 ;x,y
	.word	09H	;pal5,pal4,hdr13-0
	.word	06748H,7,59,01AH
	.word	06941H,8,0,0AH
	.word	06941H,13,54,0DH
	.word	06941H,13,0,0CH
	.word	06941H,103,54,0DH
	.word	06941H,103,0,0CH
	.word	06942H,175,61,012H
	.word	06951H,190,0,0AH
	.word	06748H,198,0,013H
	.word	06748H,202,59,01DH
	.word	06941H,202,0,0AH
	.word	06941H,207,0,0CH
	.word	06941H,207,54,0DH
	.word	06941H,297,0,0CH
	.word	06941H,297,54,0DH
	.word	06951H,384,0,0AH
	.word	06748H,392,0,016H
	.word	0FFFFH	;End Marker
ATRBHTBLKS:
	.word	06848H	;flags
	.word	0,0 ;x,y
	.word	09H	;pal5,pal4,hdr13-0
	.word	06748H,7,59,01AH
	.word	06941H,8,0,0AH
	.word	06941H,13,54,0DH
	.word	06941H,13,0,0CH
	.word	06A41H,97,0,019H
	.word	06941H,103,54,0DH
	.word	06941H,103,0,0CH
	.word	06542H,175,61,012H
	.word	06951H,190,0,0AH
	.word	06748H,198,0,013H
	.word	06748H,202,59,01DH
	.word	06941H,202,0,0AH
	.word	06941H,207,54,0DH
	.word	06941H,207,0,0CH
	.word	06A41H,291,0,019H
	.word	06941H,297,54,0DH
	.word	06941H,297,0,0CH
	.word	06951H,384,0,0AH
	.word	06748H,392,0,016H
	.word	0FFFFH	;End Marker
ATRBKITBMOD:
	.word	400,76,20	;x size, y size, #blocks
	.long	ATRBKITBLKS, SEL4HDRS, SEL4PALS
ATRIBUTEBMOD:
	.word	400,76,24	;x size, y size, #blocks
	.long	ATRIBUTEBLKS, SEL4HDRS, SEL4PALS
TEAMSEL4BMOD:
	.word	400,179,23	;x size, y size, #blocks
	.long	TEAMSEL4BLKS, SEL4HDRS, SEL4PALS
HTIMEBMOD:
	.word	400,179,13	;x size, y size, #blocks
	.long	HTIMEBLKS, SEL4HDRS, SEL4PALS
ATRBHTKTBMOD:
	.word	400,76,18	;x size, y size, #blocks
	.long	ATRBHTKTBLKS, SEL4HDRS, SEL4PALS
ATRBHTBMOD:
	.word	400,76,20	;x size, y size, #blocks
	.long	ATRBHTBLKS, SEL4HDRS, SEL4PALS

R4HDRS:
	.word	200,74	;x size, y size
	.long	01447645H	;address
	.word	05000H	;dma ctrl
	.word	100,104
	.long	01459755H
	.word	05000H
	.word	8,174
	.long	01466275H
	.word	05000H
	.word	8,175
	.long	01467DA5H
	.word	07000H
	.word	84,5
	.long	0146A3EDH
	.word	07000H
	.word	84,5
	.long	0146AF69H
	.word	07000H
	.word	104,104
	.long	0146BAE5H
	.word	04000H
	.word	100,104
	.long	014763E5H
	.word	04000H
	.word	200,74
	.long	01480665H
	.word	05000H
	.word	100,104
	.long	01492775H
	.word	04000H
	.word	8,174
	.long	0149C9F5H
	.word	05000H
	.word	204,4
	.long	0149E525H
	.word	05000H
	.word	84,50
	.long	0149F515H
	.word	05000H
	.word	84,38
	.long	014A471DH
	.word	06000H
	.word	84,39
	.long	014A91EDH
	.word	06000H
	.word	84,38
	.long	014ADEB5H
	.word	06000H
	.word	4,174
	.long	014B2985H
	.word	05000H
	.word	84,31
	.long	014B371DH
	.word	06000H
	.word	84,40
	.long	014B7425H
	.word	06000H
	.word	84,40
	.long	014BC2E5H
	.word	06000H
	.word	84,54
	.long	014C11A5H
	.word	06000H
	.word	4,174
	.long	014C7BF5H
	.word	05000H
	.word	200,4
	.long	014C898DH
	.word	04000H
	.word	84,52
	.long	014C960DH
	.word	06000H
	.word	84,41
	.long	014CFC6DH
	.word	06000H
	.word	84,40
	.long	014D4D25H
	.word	06000H
	.word	84,32
	.long	014D9BE5H
	.word	06000H
	.word	4,174
	.long	014DDAE5H
	.word	05000H
	.word	84,33
	.long	014DE87DH
	.word	06000H
	.word	84,38
	.long	014E2975H
	.word	06000H
	.word	84,36
	.long	014E7445H
	.word	06000H
	.word	84,58
	.long	014EBB25H
	.word	06000H
ENTER4BLKS:
	.word	0A4CH	;flags
	.word	0,0 ;x,y
	.word	0BH	;pal5,pal4,hdr13-0
	.word	0A4CH,0,4,02H
	.word	0F40H,8,4,03H
	.word	0F40H,13,4,05H
	.word	0F40H,13,174,04H
	.word	0F44H,13,124,0CH
	.word	0F44H,13,86,0DH
	.word	0F44H,13,47,0EH
	.word	0F44H,13,9,0FH
	.word	0F50H,94,4,03H
	.word	0A4CH,102,3,010H
	.word	0F40H,104,4,03H
	.word	0F40H,109,4,05H
	.word	0F40H,109,174,04H
	.word	0F45H,109,9,011H
	.word	0F45H,109,40,012H
	.word	0F45H,109,80,013H
	.word	0F45H,109,120,014H
	.word	0F50H,190,4,03H
	.word	0A4CH,198,4,015H
	.word	0A4CH,200,0,016H
	.word	0F42H,202,4,03H
	.word	0F42H,207,174,04H
	.word	0F42H,207,4,05H
	.word	0F46H,207,122,017H
	.word	0F46H,207,81,018H
	.word	0F46H,207,41,019H
	.word	0F46H,207,9,01AH
	.word	0F52H,288,4,03H
	.word	0A4CH,296,3,01BH
	.word	0F42H,298,4,03H
	.word	0F42H,303,4,05H
	.word	0F42H,303,174,04H
	.word	0F41H,303,9,01CH
	.word	0F41H,303,42,01DH
	.word	0F41H,303,80,01EH
	.word	0F41H,303,116,01FH
	.word	0A52H,384,4,03H
	.word	0A4CH,392,4,0AH
	.word	0FFFFH	;End Marker
ENTERKITBLKS:
	.word	0A43H	;flags
	.word	0,104 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	0A47H,0,0,01H
	.word	0A4CH,0,4,02H
	.word	0F40H,8,4,03H
	.word	0F40H,13,174,04H
	.word	0F40H,13,4,05H
	.word	0E40H,63,4,05H
	.word	0F40H,75,174,04H
	.word	0A48H,99,0,06H
	.word	0F40H,109,174,04H
	.word	0F40H,109,4,05H
	.word	0F50H,190,4,03H
	.word	0A49H,200,0,07H
	.word	0A4BH,200,104,08H
	.word	0F42H,202,4,03H
	.word	0F42H,207,174,04H
	.word	0F42H,207,4,05H
	.word	0E42H,250,4,05H
	.word	0F42H,262,174,04H
	.word	0A4AH,300,0,09H
	.word	0F42H,303,174,04H
	.word	0F42H,303,4,05H
	.word	0F52H,384,4,03H
	.word	0A4CH,392,4,0AH
	.word	0FFFFH	;End Marker
ENTER4BMOD:
	.word	400,179,39	;x size, y size, #blocks
	.long	ENTER4BLKS, R4HDRS, R4PALS
ENTERKITBMOD:
	.word	400,179,24	;x size, y size, #blocks
	.long	ENTERKITBLKS, R4HDRS, R4PALS

CRHDRS:
	.word	100,104	;x size, y size
	.long	01459755H	;address
	.word	05000H	;dma ctrl
	.word	200,74
	.long	01447645H
	.word	05000H
	.word	200,76
	.long	014F2D55H
	.word	06000H
	.word	104,104
	.long	0146BAE5H
	.word	04000H
	.word	100,104
	.long	014763E5H
	.word	04000H
	.word	200,74
	.long	01480665H
	.word	05000H
	.word	200,76
	.long	01509195H
	.word	06000H
	.word	100,104
	.long	01492775H
	.word	04000H
OPTSCRBLKS:
	.word	04047H	;flags
	.word	0,104 ;x,y
	.word	01H	;pal5,pal4,hdr13-0
	.word	04040H,0,0,00H
	.word	04041H,99,0,03H
	.word	04046H,200,104,05H
	.word	04043H,200,0,04H
	.word	04042H,300,0,07H
	.word	0FFFFH	;End Marker
BKGDBLKS:
	.word	04040H	;flags
	.word	0,0 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	04047H,0,104,01H
	.word	04044H,0,178,02H
	.word	04041H,99,0,03H
	.word	04043H,200,0,04H
	.word	04046H,200,104,05H
	.word	04045H,200,178,06H
	.word	04042H,300,0,07H
	.word	0FFFFH	;End Marker
OPTSCRBMOD:
	.word	400,178,6	;x size, y size, #blocks
	.long	OPTSCRBLKS, CRHDRS, CRPALS
BKGDBMOD:
	.word	400,254,8	;x size, y size, #blocks
	.long	BKGDBLKS, CRHDRS, CRPALS

TBGHDRS:
	.word	200,90	;x size, y size
	.long	0151F5D5H	;address
	.word	07000H	;dma ctrl
	.word	200,85
	.long	0153E205H
	.word	07000H
	.word	200,80
	.long	0155B2DDH
	.word	07000H
	.word	72,90
	.long	0157685DH
	.word	06000H
	.word	72,85
	.long	0158003DH
	.word	06000H
	.word	72,80
	.long	01588FADH
	.word	05000H
SPORTBGBLKS:
	.word	0A43H	;flags
	.word	0,165 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	0A42H,0,80,01H
	.word	0A40H,0,0,02H
	.word	0A45H,200,165,03H
	.word	0A41H,200,80,04H
	.word	0A44H,200,0,05H
	.word	0FFFFH	;End Marker
SPORTBGBMOD:
	.word	272,255,6	;x size, y size, #blocks
	.long	SPORTBGBLKS, TBGHDRS, TBGPALS

ACTHDRS:
	.word	200,125	;x size, y size
	.long	0159002DH	;address
	.word	06000H	;dma ctrl
	.word	200,130
	.long	015B4A1DH
	.word	06000H
	.word	200,125
	.long	015DAB7DH
	.word	06000H
	.word	200,130
	.long	015FF56DH
	.word	06000H
ATTRACTBLKS:
	.word	04040H	;flags
	.word	0,0 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	04040H,0,125,01H
	.word	04040H,200,0,02H
	.word	04040H,200,125,03H
	.word	0FFFFH	;End Marker
ATTRACTBMOD:
	.word	400,255,4	;x size, y size, #blocks
	.long	ATTRACTBLKS, ACTHDRS, ACTPALS

TIMEHDRS:
	.word	8,221	;x size, y size
	.long	016256CDH	;address
	.word	06000H	;dma ctrl
	.word	200,34
	.long	0162803DH
	.word	05000H
	.word	8,212
	.long	0163050DH
	.word	07000H
	.word	192,9
	.long	0163336DH
	.word	05000H
	.word	88,5
	.long	084A56DH
	.word	07000H
	.word	88,5
	.long	084B175H
	.word	07000H
	.word	88,64
	.long	0163552DH
	.word	06000H
	.word	92,138
	.long	0163D92DH
	.word	06000H
	.word	4,77
	.long	016502BDH
	.word	07000H
	.word	4,12
	.long	01650B29H
	.word	07000H
	.word	92,138
	.long	01650C79H
	.word	06000H
	.word	8,103
	.long	01663609H
	.word	06000H
	.word	8,152
	.long	01664959H
	.word	06000H
	.word	200,34
	.long	016665D9H
	.word	05000H
	.word	192,9
	.long	0166EAA9H
	.word	05000H
	.word	88,64
	.long	01670C69H
	.word	06000H
	.word	92,138
	.long	01679069H
	.word	07000H
	.word	92,138
	.long	0168EB91H
	.word	07000H
	.word	8,221
	.long	016A46B9H
	.word	06000H
HTSTATSBLKS:
	.word	04048H	;flags
	.word	0,34 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	0A47H,0,0,01H
	.word	06E42H,8,34,02H
	.word	0A49H,8,246,03H
	.word	06E42H,13,34,04H
	.word	06E42H,13,241,05H
	.word	0A44H,13,39,06H
	.word	0A46H,13,103,07H
	.word	06B42H,27,34,04H
	.word	06B42H,79,241,05H
	.word	07341H,101,38,08H
	.word	04041H,101,229,09H
	.word	0A46H,103,103,0AH
	.word	06E42H,105,34,04H
	.word	06E42H,105,241,05H
	.word	0A44H,105,39,06H
	.word	06E52H,190,34,02H
	.word	0A48H,198,0,0BH
	.word	0A48H,198,103,0CH
	.word	06E40H,203,34,02H
	.word	0A4BH,203,0,0DH
	.word	0A4AH,203,246,0EH
	.word	06E40H,208,241,05H
	.word	06E40H,208,34,04H
	.word	0A45H,208,39,0FH
	.word	0A43H,208,103,010H
	.word	06B40H,221,34,04H
	.word	06B40H,260,241,05H
	.word	07341H,296,38,08H
	.word	04041H,296,229,09H
	.word	0A43H,298,103,011H
	.word	06E40H,300,34,04H
	.word	06E40H,300,241,05H
	.word	0A45H,300,39,0FH
	.word	06E50H,385,34,02H
	.word	04048H,393,34,012H
	.word	0FFFFH	;End Marker
HTSTATSBMOD:
	.word	403,255,36	;x size, y size, #blocks
	.long	HTSTATSBLKS, TIMEHDRS, TIMEPALS
