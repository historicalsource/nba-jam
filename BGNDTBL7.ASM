	.OPTION	B,D,L,T
	.include	"BGNDTBL.GLO"
	.DATA

timeHDRS:
	.word	76,123	;x size, y size
	.long	05C8D817H	;address
	.word	00H	;dma ctrl
	.word	76,133
	.long	05C9FC37H
	.word	00H
	.word	76,133
	.long	05CB3817H
	.word	00H
	.word	76,123
	.long	05CC73F7H
	.word	00H
	.word	76,133
	.long	05CD9817H
	.word	00H
	.word	76,123
	.long	05CED3F7H
	.word	00H
	.word	80,133
	.long	05CFF817H
	.word	00H
	.word	76,123
	.long	05D14497H
	.word	00H
	.word	100,133
	.long	05D268B7H
	.word	00H
	.word	100,123
	.long	05D40857H
	.word	00H
	.word	68,58
	.long	05D588B7H
	.word	06000H
	.word	72,58
	.long	05D5E527H
	.word	06000H
	.word	88,58
	.long	05D64707H
	.word	06000H
	.word	84,58
	.long	05D6BEA7H
	.word	06000H
maximBLKS:
	.word	0A45H	;flags
	.word	0,123 ;x,y
	.word	01H	;pal5,pal4,hdr13-0
	.word	0A40H,0,0,00H
	.word	0404AH,27,41,0AH
	.word	0A41H,75,0,03H
	.word	0A47H,75,123,02H
	.word	0404BH,95,41,0BH
	.word	0A46H,145,123,04H
	.word	0A42H,150,0,05H
	.word	0404CH,164,42,0CH
	.word	0A48H,220,123,06H
	.word	0A43H,225,0,07H
	.word	0404DH,250,42,0DH
	.word	0A44H,300,0,09H
	.word	0A49H,300,123,08H
	.word	0FFFFH	;End Marker
hangtimeBLKS:
	.word	0A40H	;flags
	.word	0,0 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	0A45H,0,123,01H
	.word	0A47H,75,123,02H
	.word	0A41H,75,0,03H
	.word	0A46H,145,123,04H
	.word	0A42H,150,0,05H
	.word	0A48H,220,123,06H
	.word	0A43H,225,0,07H
	.word	0A49H,300,123,08H
	.word	0A44H,300,0,09H
	.word	0FFFFH	;End Marker
maximBMOD:
	.word	400,256,14	;x size, y size, #blocks
	.long	maximBLKS, timeHDRS, timePALS
hangtimeBMOD:
	.word	400,256,10	;x size, y size, #blocks
	.long	hangtimeBLKS, timeHDRS, timePALS

RHDRS:
	.word	204,23	;x size, y size
	.long	05D730D7H	;address
	.word	00H	;dma ctrl
	.word	200,21
	.long	05D7C377H
	.word	07000H
	.word	44,54
	.long	05D8364FH
	.word	05000H
	.word	44,54
	.long	05D864B7H
	.word	05000H
	.word	200,21
	.long	05D8931FH
	.word	07000H
	.word	196,23
	.long	05D905F7H
	.word	00H
VSSCRBLKS:
	.word	04142H	;flags
	.word	0,0 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	04141H,0,54,01H
	.word	04243H,175,82,02H
	.word	04243H,193,118,03H
	.word	04140H,200,54,04H
	.word	04142H,204,0,05H
	.word	0FFFFH	;End Marker
VSSCRBMOD:
	.word	400,172,6	;x size, y size, #blocks
	.long	VSSCRBLKS, RHDRS, RPALS

statHDRS:
	.word	204,23	;x size, y size
	.long	05D730D7H	;address
	.word	00H	;dma ctrl
	.word	200,70
	.long	05D992D7H
	.word	05000H
	.word	200,71
	.long	05DAA447H
	.word	06000H
	.word	200,68
	.long	05DBF117H
	.word	05000H
	.word	200,51
	.long	05DCFAB7H
	.word	06000H
	.word	192,86
	.long	05DDE9C7H
	.word	06000H
	.word	96,46
	.long	05DF6CC7H
	.word	06000H
	.word	84,12
	.long	05DFD447H
	.word	07000H
	.word	88,64
	.long	05DFEFD7H
	.word	00H
	.word	36,46
	.long	05E09FD7H
	.word	06000H
	.word	212,9
	.long	05E0C6A7H
	.word	03000H
	.word	200,65
	.long	05E0DD03H
	.word	05000H
	.word	200,72
	.long	05E1DAEBH
	.word	05000H
	.word	200,68
	.long	05E2F42BH
	.word	06000H
	.word	200,54
	.long	05E432EBH
	.word	06000H
	.word	196,23
	.long	05D905F7H
	.word	00H
	.word	64,9
	.long	05E5300BH
	.word	03000H
	.word	56,46
	.long	05E536CBH
	.word	06000H
	.word	92,138
	.long	05E5732BH
	.word	06000H
	.word	176,24
	.long	05E69CBBH
	.word	00H
	.word	148,11
	.long	05E720BBH
	.word	00H
	.word	84,9
	.long	05E7539BH
	.word	03000H
	.word	92,138
	.long	05E75C77H
	.word	06000H
	.word	100,110
	.long	05E88607H
	.word	00H
	.word	64,8
	.long	05E9DDC7H
	.word	02000H
	.word	56,8
	.long	05E9E1C7H
	.word	02000H
	.word	40,9
	.long	05E9E547H
	.word	03000H
	.word	40,107
	.long	05E9E97FH
	.word	04000H
	.word	168,24
	.long	05EA2C5FH
	.word	00H
	.word	148,11
	.long	05EAAA5FH
	.word	00H
	.word	92,138
	.long	05EADD3FH
	.word	07000H
	.word	92,138
	.long	05EC3867H
	.word	07000H
teamstatBLKS:
	.word	054CH	;flags
	.word	0,0 ;x,y
	.word	01H	;pal5,pal4,hdr13-0
	.word	04045H,0,10,00H
	.word	054DH,1,69,03H
	.word	0540H,1,137,01002H
	.word	054BH,2,206,04H
	.word	0A46H,14,107,012H
	.word	0C42H,33,98,013H
	.word	0C40H,59,232,014H
	.word	02847H,65,99,015H
	.word	0A46H,104,107,016H
	.word	0C41H,155,122,017H
	.word	02848H,176,233,018H
	.word	02848H,179,222,019H
	.word	02847H,183,99,01AH
	.word	02844H,184,112,01BH
	.word	054FH,200,72,0BH
	.word	054EH,200,0,0CH
	.word	054AH,201,135,0DH
	.word	0549H,202,203,0EH
	.word	04045H,204,10,0FH
	.word	0C42H,205,98,01CH
	.word	0C40H,206,232,01DH
	.word	0A43H,208,107,01EH
	.word	02847H,257,99,015H
	.word	0A43H,298,107,01FH
	.word	0FFFFH	;End Marker
finalresBLKS:
	.word	04045H	;flags
	.word	0,10 ;x,y
	.word	00H	;pal5,pal4,hdr13-0
	.word	054CH,0,0,01H
	.word	0540H,1,137,01002H
	.word	054DH,1,69,03H
	.word	054BH,2,206,04H
	.word	04044H,7,99,01005H
	.word	04042H,7,198,01006H
	.word	04043H,12,168,01007H
	.word	04041H,12,104,01008H
	.word	04043H,18,168,01007H
	.word	04042H,100,198,01009H
	.word	04043H,104,168,01007H
	.word	04041H,104,104,01008H
	.word	04043H,110,168,01007H
	.word	04046H,110,187,0100AH
	.word	04042H,134,198,01009H
	.word	04042H,168,198,01009H
	.word	054FH,200,70,0BH
	.word	054EH,200,0,0CH
	.word	054AH,201,135,0DH
	.word	0549H,202,203,0EH
	.word	04042H,202,198,01009H
	.word	04044H,203,99,01005H
	.word	04045H,204,10,0FH
	.word	04045H,208,168,01007H
	.word	04041H,208,104,01008H
	.word	04045H,214,168,01007H
	.word	04042H,236,198,01009H
	.word	04042H,270,198,01009H
	.word	04045H,300,168,01007H
	.word	04041H,300,104,01008H
	.word	04042H,304,198,01009H
	.word	04045H,307,168,01007H
	.word	04046H,322,187,01010H
	.word	04042H,338,198,01011H
	.word	0FFFFH	;End Marker
teamstatBMOD:
	.word	402,257,25	;x size, y size, #blocks
	.long	teamstatBLKS, statHDRS, statPALS
finalresBMOD:
	.word	402,257,35	;x size, y size, #blocks
	.long	finalresBLKS, statHDRS, statPALS
