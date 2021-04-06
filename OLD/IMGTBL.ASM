	.FILE "imgtbl.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

shadow1:
	.word   59,9,29,4
	.long   04ea3161H
	.word   01000H
	.long   shad_p
shadow2:
	.word   55,7,27,3
	.long   04ea3374H
	.word   01000H
	.long   shad_p
shadow3:
	.word   51,7,25,3
	.long   04ea34f5H
	.word   01000H
	.long   shad_p
shadow4:
	.word   49,7,24,3
	.long   04ea365aH
	.word   01000H
	.long   shad_p
shadow5:
	.word   47,7,23,3
	.long   04ea37b1H
	.word   01000H
	.long   shad_p
shadow6:
	.word   45,7,22,3
	.long   04ea38faH
	.word   01000H
	.long   shad_p
shadow7:
	.word   43,6,21,2
	.long   04ea3a35H
	.word   01000H
	.long   shad_p
shadow8:
	.word   43,5,21,2
	.long   04ea3b37H
	.word   01000H
	.long   shad_p
shadow9:
	.word   39,5,19,2
	.long   04ea3c0eH
	.word   01000H
	.long   shad_p
shadow10:
	.word   37,5,18,2
	.long   04ea3cd1H
	.word   01000H
	.long   shad_p
shadow11:
	.word   35,5,17,2
	.long   04ea3d8aH
	.word   01000H
	.long   shad_p
ball11:
	.word   11,11,5,10
	.long   04ea3e39H
	.word   07000H
	.long   BALL_p
shadow12:
	.word   31,5,15,2
	.long   04ea4188H
	.word   01000H
	.long   shad_p
shadow13:
	.word   29,5,15,2
	.long   04ea4223H
	.word   01000H
	.long   shad_p
shadow14:
	.word   27,5,14,2
	.long   04ea42b4H
	.word   01000H
	.long   shad_p
shadow15:
	.word   25,5,13,2
	.long   04ea433bH
	.word   01000H
	.long   shad_p
ballshad5:
	.word   14,4,7,2
	.long   04ea43b8H
	.word   01000H
	.long   shad_p
reftip1:
	.word   33,91,13,82
	.long   04f7b400H
	.word   00H
	.long   Ref_p
	.word   7,35,5,0
reftip10:
	.word   36,73,14,62
	.long   04f811d8H
	.word   00H
	.long   Ref_p
	.word   7,48,5,0
reftip11:
	.word   32,76,13,65
	.long   04f863f8H
	.word   00H
	.long   Ref_p
	.word   7,56,5,0
reftip12:
	.word   30,89,11,79
	.long   04f8aff8H
	.word   00H
	.long   Ref_p
	.word   9,27,5,0
reftip13:
	.word   33,118,12,107
	.long   04f90368H
	.word   00H
	.long   Ref_p
	.word   8,7,-1,0
reftip14:
	.word   36,111,14,102
	.long   04f97d18H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
reftip15:
	.word   45,94,26,86
	.long   04f9f9f8H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
reftip16:
	.word   43,94,25,86
	.long   04fa7e28H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
reftip2:
	.word   33,91,13,82
	.long   04fafc78H
	.word   00H
	.long   Ref_p
	.word   7,35,5,0
reftip3:
	.word   33,91,13,82
	.long   04fb5a50H
	.word   00H
	.long   Ref_p
	.word   7,35,5,0
reftip4:
	.word   31,88,13,80
	.long   04fbb828H
	.word   00H
	.long   Ref_p
	.word   7,37,5,0
reftip5:
	.word   31,90,13,81
	.long   04fc0d68H
	.word   00H
	.long   Ref_p
	.word   7,36,5,0
reftip6:
	.word   34,92,13,82
	.long   04fc6498H
	.word   00H
	.long   Ref_p
	.word   7,35,5,0
reftip7:
	.word   34,89,14,80
	.long   04fcc658H
	.word   00H
	.long   Ref_p
	.word   7,35,5,0
reftip8:
	.word   32,86,13,77
	.long   04fd24e8H
	.word   00H
	.long   Ref_p
	.word   8,35,5,0
reftip9:
	.word   40,83,17,73
	.long   04fd7ae8H
	.word   00H
	.long   Ref_p
	.word   8,42,5,0
refbk1:
	.word   37,87,18,85
	.long   04fde2a8H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
refbk2:
	.word   39,87,19,85
	.long   04fe4740H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
refbk3:
	.word   44,89,20,85
	.long   04feb148H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
refbk4:
	.word   47,89,21,85
	.long   04ff2ba8H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
refbk5:
	.word   45,88,21,86
	.long   04ffae60H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
refbk6:
	.word   44,87,23,85
	.long   05002a20H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
refbk7:
	.word   42,87,23,85
	.long   0500a1c0H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
refbk8:
	.word   37,89,22,86
	.long   050113f0H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
refsqt5:
	.word   48,84,29,83
	.long   05017ad8H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
refsqt4:
	.word   37,83,21,81
	.long   0501f8d8H
	.word   00H
	.long   Ref_p
	.word   0,0,0,0
t0000:
	.word   55,14,27,0
	.long   050258d0H
	.word   05000H
	.long   timers_b
tx000:
	.word   55,14,27,0
	.long   050267daH
	.word   05000H
	.long   timers_r
txx00:
	.word   55,14,27,0
	.long   050276e4H
	.word   05000H
	.long   timers_b
txxx0:
	.word   55,14,27,0
	.long   050285eeH
	.word   05000H
	.long   timers_b
txxxx:
	.word   55,14,27,0
	.long   050294f8H
	.word   05000H
	.long   timers_b
t1000:
	.word   55,14,27,0
	.long   0502a402H
	.word   05000H
	.long   timers_b
t1100:
	.word   55,14,27,0
	.long   0502b30cH
	.word   05000H
	.long   timers_b
t1110:
	.word   55,14,27,0
	.long   0502c216H
	.word   05000H
	.long   timers_b
t1111:
	.word   55,14,27,0
	.long   0502d120H
	.word   05000H
	.long   timers_b
tx100:
	.word   55,14,27,0
	.long   0502e02aH
	.word   05000H
	.long   timers_b
tx110:
	.word   55,14,27,0
	.long   0502ef34H
	.word   05000H
	.long   timers_b
tx111:
	.word   55,14,27,0
	.long   0502fe3eH
	.word   05000H
	.long   timers_b
txx10:
	.word   55,14,27,0
	.long   05030d48H
	.word   05000H
	.long   timers_b
txx11:
	.word   55,14,27,0
	.long   05031c52H
	.word   05000H
	.long   timers_b
txxx1:
	.word   55,14,27,0
	.long   05032b5cH
	.word   05000H
	.long   timers_b
BERAN:
	.word   34,9,17,0
	.long   05033a66H
	.word   06000H
	.long   scorep
BOON:
	.word   28,9,14,0
	.long   05034192H
	.word   06000H
	.long   scorep
BOOTY:
	.word   35,9,17,0
	.long   0503477aH
	.word   06000H
	.long   scorep
MARTINEZ:
	.word   55,9,27,0
	.long   05034edcH
	.word   06000H
	.long   scorep
PENACHO:
	.word   47,9,23,0
	.long   05035a76H
	.word   06000H
	.long   scorep
DABEL:
	.word   63,9,31,0
	.long   05036460H
	.word   06000H
	.long   scorep
VOGEL:
	.word   33,9,16,0
	.long   050371aaH
	.word   06000H
	.long   scorep
DAVIS:
	.word   31,9,15,0
	.long   050378a0H
	.word   06000H
	.long   scorep
GENTILE:
	.word   42,9,21,0
	.long   05037f2aH
	.word   06000H
	.long   scorep
HEITSCH:
	.word   43,9,21,0
	.long   05038806H
	.word   06000H
	.long   scorep
KINKEAD:
	.word   44,9,22,0
	.long   05039118H
	.word   06000H
	.long   scorep
LINHOFF:
	.word   42,9,21,0
	.long   05039a60H
	.word   06000H
	.long   scorep
LOWES:
	.word   37,9,18,0
	.long   0503a33cH
	.word   06000H
	.long   scorep
MACIKA:
	.word   41,9,20,0
	.long   0503ab0aH
	.word   06000H
	.long   scorep
MEDNICK:
	.word   47,9,23,0
	.long   0503b3b0H
	.word   06000H
	.long   scorep
PONTAREL:
	.word   63,9,31,0
	.long   0503bd9aH
	.word   06000H
	.long   scorep
SHARPE:
	.word   41,9,20,0
	.long   0503cae4H
	.word   06000H
	.long   scorep
DAVIES:
	.word   37,9,18,0
	.long   0503d38aH
	.word   06000H
	.long   scorep
TOBIAS:
	.word   38,9,19,0
	.long   0503db58H
	.word   06000H
	.long   scorep
TSUI:
	.word   24,9,12,0
	.long   0503e35cH
	.word   06000H
	.long   scorep
LASKO:
	.word   34,9,17,0
	.long   0503e86cH
	.word   06000H
	.long   scorep
GRANN:
	.word   48,9,24,0
	.long   0503ef98H
	.word   06000H
	.long   scorep
FORD:
	.word   40,9,20,0
	.long   0503f9b8H
	.word   06000H
	.long   scorep
JARVIS:
	.word   37,9,18,0
	.long   05040228H
	.word   06000H
	.long   scorep
HAEGER:
	.word   40,9,20,0
	.long   050409f6H
	.word   06000H
	.long   scorep
GREEN:
	.word   33,9,16,0
	.long   05041266H
	.word   06000H
	.long   scorep
DILLON:
	.word   36,9,18,0
	.long   0504195cH
	.word   06000H
	.long   scorep
KAM:
	.word   36,9,18,0
	.long   050420f4H
	.word   06000H
	.long   scorep
DEAL:
	.word   26,9,13,0
	.long   0504288cH
	.word   06000H
	.long   scorep
LOFFRE:
	.word   52,9,26,0
	.long   05042e08H
	.word   06000H
	.long   scorep
BARKER:
	.word   41,9,20,0
	.long   05043900H
	.word   06000H
	.long   scorep
COX:
	.word   20,9,10,0
	.long   050441a6H
	.word   06000H
	.long   scorep
RAIDEN:
	.word   37,9,18,0
	.long   050445deH
	.word   06000H
	.long   scorep
REAPER:
	.word   40,9,20,0
	.long   05044dacH
	.word   06000H
	.long   scorep
KONGO:
	.word   35,9,17,0
	.long   0504561cH
	.word   06000H
	.long   scorep
ELVIS:
	.word   59,9,29,0
	.long   05045d7eH
	.word   06000H
	.long   scorep
HOSK:
	.word   46,9,23,0
	.long   050469f0H
	.word   06000H
	.long   scorep
OLIV:
	.word   33,9,16,0
	.long   050473a4H
	.word   06000H
	.long   scorep
SCORP:
	.word   51,9,25,0
	.long   05047a9aH
	.word   06000H
	.long   scorep
REPT:
	.word   42,9,21,0
	.long   0504855cH
	.word   06000H
	.long   scorep
SUBZ:
	.word   53,9,26,0
	.long   05048e38H
	.word   06000H
	.long   scorep
COMAN:
	.word   38,9,19,0
	.long   05049966H
	.word   06000H
	.long   scorep
GAY:
	.word   21,9,10,0
	.long   0504a16aH
	.word   06000H
	.long   scorep
PETRO:
	.word   34,9,17,0
	.long   0504a5d8H
	.word   06000H
	.long   scorep
NEWCOMER:
	.word   61,9,30,0
	.long   0504ad04H
	.word   06000H
	.long   scorep
OURSLER:
	.word   47,9,23,0
	.long   0504b9e2H
	.word   06000H
	.long   scorep
MORRIS:
	.word   64,9,32,0
	.long   0504c3ccH
	.word   06000H
	.long   scorep
SIMPSON:
	.word   49,9,24,0
	.long   0504d14cH
	.word   06000H
	.long   scorep
JSKILES:
	.word   36,9,18,0
	.long   0504dba2H
	.word   06000H
	.long   scorep
HEY:
	.word   20,9,10,0
	.long   0504e33aH
	.word   06000H
	.long   scorep
CARLTON:
	.word   46,9,23,0
	.long   0504e772H
	.word   06000H
	.long   scorep
GOSKIE:
	.word   37,9,18,0
	.long   0504f126H
	.word   06000H
	.long   scorep
DIVITA:
	.word   36,9,18,0
	.long   0504f8f4H
	.word   06000H
	.long   scorep
TURMELL:
	.word   50,9,25,0
	.long   0505008cH
	.word   06000H
	.long   scorep
RIVETT:
	.word   37,9,18,0
	.long   05050b18H
	.word   06000H
	.long   scorep
LIPTAK:
	.word   37,9,18,0
	.long   050512e6H
	.word   06000H
	.long   scorep
DoubleOT:
	.word   107,12,-57,-44
	.long   05051ab4H
	.word   06000H
	.long   scorep
TripleOT:
	.word   105,12,-57,-44
	.long   050538ccH
	.word   06000H
	.long   scorep
endof1:
	.word   123,14,-58,-43
	.long   05055654H
	.word   06000H
	.long   scorep
endof3:
	.word   124,14,-58,-43
	.long   05057eb0H
	.word   06000H
	.long   scorep
endof4:
	.word   124,14,-58,-43
	.long   0505a760H
	.word   06000H
	.long   scorep
halftime:
	.word   57,12,-58,-44
	.long   0505d010H
	.word   06000H
	.long   scorep
shotclok:
	.word   48,52,-2,34
	.long   0505e018H
	.word   06000H
	.long   scorep
quarter:
	.word   50,13,-84,-44
	.long   05061a98H
	.word   06000H
	.long   scorep
start:
	.word   35,19,20,0
	.long   050629d4H
	.word   06000H
	.long   scorep
insert:
	.word   37,19,21,0
	.long   0506396aH
	.word   06000H
	.long   scorep
colon:
	.word   3,5,0,0
	.long   050649e4H
	.word   02000H
	.long   ledw
cpu:
	.word   21,11,0,-4
	.long   05064a02H
	.word   06000H
	.long   scorep
timerlow:
	.word   36,19,18,-4
	.long   05064f6cH
	.word   06000H
	.long   scorep
one:
	.word   20,13,-57,-43
	.long   05065f74H
	.word   06000H
	.long   scorep
two:
	.word   23,13,-55,-43
	.long   0506658cH
	.word   06000H
	.long   scorep
three:
	.word   35,14,-46,-42
	.long   05066c8eH
	.word   06000H
	.long   scorep
four:
	.word   22,13,-54,-43
	.long   0506780aH
	.word   06000H
	.long   scorep
freeply:
	.word   43,6,0,0
	.long   05067ebeH
	.word   06000H
	.long   scorep
crplate:
	.word   49,12,0,0
	.long   050684caH
	.word   06000H
	.long   scorep
crplate2:
	.word   49,20,0,0
	.long   05069292H
	.word   06000H
	.long   scorep
credit:
	.word   28,6,0,0
	.long   0506a98aH
	.word   06000H
	.long   scorep
scorebox:
	.word   65,36,8,0
	.long   0506ad7aH
	.word   06000H
	.long   scorep
qrtr1:
	.word   34,7,1,1
	.long   0506e452H
	.word   06000H
	.long   scorep
qrtr2:
	.word   34,7,1,1
	.long   0506e9e6H
	.word   06000H
	.long   scorep
qrtr3:
	.word   34,7,1,1
	.long   0506ef7aH
	.word   06000H
	.long   scorep
qrtr4:
	.word   34,7,1,1
	.long   0506f50eH
	.word   06000H
	.long   scorep
AUGMON:
	.word   46,9,23,0
	.long   0506faa2H
	.word   06000H
	.long   scorep
BARKLEY:
	.word   47,9,23,0
	.long   05070456H
	.word   06000H
	.long   scorep
BENJAMIN:
	.word   54,9,27,0
	.long   05070e40H
	.word   06000H
	.long   scorep
COLEMAN:
	.word   50,9,25,0
	.long   050719a4H
	.word   06000H
	.long   scorep
DAUGHRTY:
	.word   62,9,31,0
	.long   05072430H
	.word   06000H
	.long   scorep
EDWARDS:
	.word   52,9,26,0
	.long   05073144H
	.word   06000H
	.long   scorep
DREXLER:
	.word   46,9,23,0
	.long   05073c3cH
	.word   06000H
	.long   scorep
ELLIOT:
	.word   35,9,17,0
	.long   050745f0H
	.word   06000H
	.long   scorep
LELLIS:
	.word   28,9,14,0
	.long   05074d52H
	.word   06000H
	.long   scorep
GUGLI:
	.word   54,9,27,0
	.long   0507533aH
	.word   06000H
	.long   scorep
EWING:
	.word   34,9,17,0
	.long   05075e9eH
	.word   06000H
	.long   scorep
GILL:
	.word   22,9,11,0
	.long   050765caH
	.word   06000H
	.long   scorep
GRANT_HC:
	.word   35,9,17,0
	.long   05076a6eH
	.word   06000H
	.long   scorep
GRANT_HV:
	.word   35,9,17,0
	.long   050771d0H
	.word   06000H
	.long   scorep
THARDAWAY:
	.word   60,9,30,0
	.long   05077932H
	.word   06000H
	.long   scorep
HARPER_D:
	.word   41,9,20,0
	.long   050785daH
	.word   06000H
	.long   scorep
HARPER_R:
	.word   41,9,20,0
	.long   05078e80H
	.word   06000H
	.long   scorep
HAWKINS:
	.word   49,9,24,0
	.long   05079726H
	.word   06000H
	.long   scorep
HORNACEK:
	.word   54,9,27,0
	.long   0507a17cH
	.word   06000H
	.long   scorep
JOHNSN_L:
	.word   48,9,24,0
	.long   0507ace0H
	.word   06000H
	.long   scorep
DIVAC:
	.word   30,9,15,0
	.long   0507b700H
	.word   06000H
	.long   scorep
KEMP:
	.word   31,9,15,0
	.long   0507bd54H
	.word   06000H
	.long   scorep
LAETNER:
	.word   53,9,26,0
	.long   0507c3deH
	.word   06000H
	.long   scorep
AHARDAWAY:
	.word   60,9,30,0
	.long   0507cf0cH
	.word   06000H
	.long   scorep
MAJERLE:
	.word   49,9,24,0
	.long   0507dbb4H
	.word   06000H
	.long   scorep
MALONE_K:
	.word   44,9,22,0
	.long   0507e60aH
	.word   06000H
	.long   scorep
LOHAUS:
	.word   41,9,20,0
	.long   0507ef52H
	.word   06000H
	.long   scorep
MANNING:
	.word   49,9,24,0
	.long   0507f7f8H
	.word   06000H
	.long   scorep
MILLER:
	.word   39,9,19,0
	.long   0508024eH
	.word   06000H
	.long   scorep
MULLIN:
	.word   40,9,20,0
	.long   05080a88H
	.word   06000H
	.long   scorep
MUTUMBO:
	.word   57,9,28,0
	.long   050812f8H
	.word   06000H
	.long   scorep
OAKLEY:
	.word   40,9,20,0
	.long   05081efeH
	.word   06000H
	.long   scorep
OLAJUWON:
	.word   58,9,29,0
	.long   0508276eH
	.word   06000H
	.long   scorep
ONEAL:
	.word   36,9,18,0
	.long   050833aaH
	.word   06000H
	.long   scorep
PERSON:
	.word   41,9,20,0
	.long   05083b42H
	.word   06000H
	.long   scorep
PIPPEN:
	.word   37,9,18,0
	.long   050843e8H
	.word   06000H
	.long   scorep
PORTER:
	.word   41,9,20,0
	.long   05084bb6H
	.word   06000H
	.long   scorep
PRICE:
	.word   29,9,14,0
	.long   0508545cH
	.word   06000H
	.long   scorep
RICE:
	.word   22,9,11,0
	.long   05085a7aH
	.word   06000H
	.long   scorep
DROBINSON:
	.word   52,9,26,0
	.long   05085f1eH
	.word   06000H
	.long   scorep
SCHREMPF:
	.word   57,9,28,0
	.long   05086a16H
	.word   06000H
	.long   scorep
SEIKALY:
	.word   42,9,21,0
	.long   0508761cH
	.word   06000H
	.long   scorep
SKILES:
	.word   36,9,18,0
	.long   05087ef8H
	.word   06000H
	.long   scorep
SMITH:
	.word   35,9,17,0
	.long   05088690H
	.word   06000H
	.long   scorep
STOCKTON:
	.word   55,9,27,0
	.long   05088df2H
	.word   06000H
	.long   scorep
THOMAS:
	.word   46,9,23,0
	.long   0508998cH
	.word   06000H
	.long   scorep
TISDALE:
	.word   43,9,21,0
	.long   0508a340H
	.word   06000H
	.long   scorep
WEBB:
	.word   31,9,15,0
	.long   0508ac52H
	.word   06000H
	.long   scorep
KANDERSON:
	.word   55,9,27,0
	.long   0508b2dcH
	.word   06000H
	.long   scorep
NANDERSON:
	.word   55,9,27,0
	.long   0508be76H
	.word   06000H
	.long   scorep
WILKINS:
	.word   44,9,22,0
	.long   0508ca10H
	.word   06000H
	.long   scorep
WORTHY:
	.word   46,9,23,0
	.long   0508d358H
	.word   06000H
	.long   scorep
KJOHNSON:
	.word   48,9,24,0
	.long   0508dd0cH
	.word   06000H
	.long   scorep
CROBINSON:
	.word   52,9,26,0
	.long   0508e72cH
	.word   06000H
	.long   scorep
DELLIS:
	.word   28,9,14,0
	.long   0508f224H
	.word   06000H
	.long   scorep
bbal:
	.word   78,42,0,0
	.long   0508f80cH
	.word   07000H
	.long   bbal_pal
bbal_w:
	.word   78,42,0,0
	.long   0508f80cH
	.word   07000H
	.long   bbal_palw
tocontrol:
	.word   66,9,35,0
	.long   050951a0H
	.word   06000H
	.long   scorep
METERg:
	.word   49,12,25,-5
	.long   05095f8cH
	.word   06000H
	.long   scorep
LITUPg:
	.word   49,5,-4,-17
	.long   05096d54H
	.word   06000H
	.long   scorep
METERr:
	.word   49,12,25,-5
	.long   05097312H
	.word   06000H
	.long   scorepr
LITUPr:
	.word   49,5,-4,-17
	.long   05096d54H
	.word   06000H
	.long   scorepr
METERy:
	.word   49,12,25,-5
	.long   05097312H
	.word   06000H
	.long   scorepy
LITUPy:
	.word   49,5,-4,-17
	.long   05096d54H
	.word   06000H
	.long   scorepy
METERb:
	.word   49,12,25,-5
	.long   05097312H
	.word   06000H
	.long   scorepb
LITUPb:
	.word   49,5,-4,-17
	.long   05096d54H
	.word   06000H
	.long   scorepb
font60:
	.word   5,6,0,0
	.long   050980daH
	.word   06000H
	.long   scorep
font61:
	.word   3,6,-3,0
	.long   0509818eH
	.word   06000H
	.long   scorep
font62:
	.word   5,6,0,0
	.long   050981faH
	.word   06000H
	.long   scorep
font63:
	.word   5,6,0,0
	.long   050982aeH
	.word   06000H
	.long   scorep
font64:
	.word   5,6,0,0
	.long   05098362H
	.word   06000H
	.long   scorep
font65:
	.word   5,6,0,0
	.long   05098416H
	.word   06000H
	.long   scorep
font66:
	.word   5,6,0,0
	.long   050984caH
	.word   06000H
	.long   scorep
font67:
	.word   5,6,0,0
	.long   0509857eH
	.word   06000H
	.long   scorep
font68:
	.word   5,6,0,0
	.long   05098632H
	.word   06000H
	.long   scorep
font69:
	.word   5,6,0,0
	.long   050986e6H
	.word   06000H
	.long   scorep
clock:
	.word   40,15,-266,-42
	.long   0509879aH
	.word   05000H
	.long   metprp_p
clock2:
	.word   40,15,-266,-42
	.long   05099352H
	.word   05000H
	.long   metprp_p
font90:
	.word   8,9,0,0
	.long   05099f0aH
	.word   02000H
	.long   ledw
font60w:
	.word   5,6,0,0
	.long   05099f9aH
	.word   06000H
	.long   scorepw
font60r:
	.word   5,6,0,0
	.long   0509a04eH
	.word   06000H
	.long   scoreprd
font60g:
	.word   5,6,0,0
	.long   0509a102H
	.word   06000H
	.long   scorepg
font6?:
	.word   5,6,0,0
	.long   0509a1b6H
	.word   06000H
	.long   scorep
font91:
	.word   3,9,-6,0
	.long   0509a26aH
	.word   02000H
	.long   ledw
font92:
	.word   8,9,0,0
	.long   0509a2a0H
	.word   02000H
	.long   ledw
font93:
	.word   7,9,-1,0
	.long   0509a330H
	.word   02000H
	.long   ledw
font94:
	.word   8,9,0,0
	.long   0509a3aeH
	.word   02000H
	.long   ledw
font95:
	.word   8,9,0,0
	.long   0509a43eH
	.word   02000H
	.long   ledw
font96:
	.word   8,9,0,0
	.long   0509a4ceH
	.word   02000H
	.long   ledw
font97:
	.word   7,9,-1,0
	.long   0509a55eH
	.word   02000H
	.long   ledw
font98:
	.word   8,9,0,0
	.long   0509a5dcH
	.word   02000H
	.long   ledw
font99:
	.word   8,9,0,0
	.long   0509a66cH
	.word   02000H
	.long   ledw
metal1:
	.word   40,60,-8,0
	.long   0509a6fcH
	.word   05000H
	.long   metprp_p
overtime:
	.word   58,12,-57,-44
	.long   0509d5dcH
	.word   06000H
	.long   scorep
final:
	.word   36,12,-58,-44
	.long   0509e62cH
	.word   06000H
	.long   scorep
font90r:
	.word   8,9,0,0
	.long   0509f04cH
	.word   02000H
	.long   ledr
metal2:
	.word   321,21,-47,-39
	.long   0509f0dcH
	.word   05000H
	.long   metprp_p
S_LED_0:
	.word   7,7,0,0
	.long   050a7485H
	.word   02000H
	.long   ledw
S_LED_1:
	.word   3,7,-5,0
	.long   050a74e7H
	.word   02000H
	.long   ledw
S_LED_2:
	.word   7,7,0,0
	.long   050a7511H
	.word   02000H
	.long   ledw
S_LED_3:
	.word   6,7,-1,0
	.long   050a7573H
	.word   02000H
	.long   ledw
S_LED_4:
	.word   7,7,0,0
	.long   050a75c7H
	.word   02000H
	.long   ledw
S_LED_5:
	.word   7,7,0,0
	.long   050a7629H
	.word   02000H
	.long   ledw
S_LED_6:
	.word   7,7,0,0
	.long   050a768bH
	.word   02000H
	.long   ledw
S_LED_7:
	.word   6,7,-1,0
	.long   050a76edH
	.word   02000H
	.long   ledw
S_LED_8:
	.word   7,7,0,0
	.long   050a7741H
	.word   02000H
	.long   ledw
S_LED_9:
	.word   7,7,0,0
	.long   050a77a3H
	.word   02000H
	.long   ledw
S_LED_MAX:
	.word   25,9,1,1
	.long   050a7805H
	.word   02000H
	.long   ledw
BigLED_0:
	.word   16,19,0,0
	.long   050a79c7H
	.word   06000H
	.long   scorep
BigLED_1:
	.word   4,17,-12,-1
	.long   050a80e7H
	.word   06000H
	.long   scorep
BigLED_2:
	.word   16,19,0,0
	.long   050a827fH
	.word   06000H
	.long   scorep
BigLED_3:
	.word   14,19,-2,0
	.long   050a899fH
	.word   06000H
	.long   scorep
BigLED_4:
	.word   16,17,0,-1
	.long   050a8fdbH
	.word   06000H
	.long   scorep
BigLED_5:
	.word   16,19,0,0
	.long   050a963bH
	.word   06000H
	.long   scorep
BigLED_6:
	.word   16,19,0,0
	.long   050a9d5bH
	.word   06000H
	.long   scorep
BigLED_7:
	.word   14,18,-2,0
	.long   050aa47bH
	.word   06000H
	.long   scorep
BigLED_8:
	.word   16,19,0,0
	.long   050aaa63H
	.word   06000H
	.long   scorep
BigLED_9:
	.word   16,19,0,0
	.long   050ab183H
	.word   06000H
	.long   scorep
please:
	.word   39,19,25,0
	.long   050ab8a3H
	.word   06000H
	.long   scorep
S_LED_0r:
	.word   7,7,0,0
	.long   050aca01H
	.word   02000H
	.long   ledr
MCDAN:
	.word   54,9,26,0
	.long   050aca63H
	.word   06000H
	.long   scorep
WILLIS:
	.word   36,9,17,0
	.long   050ad5c7H
	.word   06000H
	.long   scorep
BROWN:
	.word   39,9,19,0
	.long   050add5fH
	.word   06000H
	.long   scorep
GAMBLE:
	.word   44,9,21,0
	.long   050ae599H
	.word   06000H
	.long   scorep
MOURN:
	.word   56,9,27,0
	.long   050aeee1H
	.word   06000H
	.long   scorep
ARMSTR:
	.word   67,9,33,0
	.long   050afab1H
	.word   06000H
	.long   scorep
KUKOC:
	.word   34,9,16,0
	.long   050b08d3H
	.word   06000H
	.long   scorep
NANCE:
	.word   33,9,16,0
	.long   050b0fffH
	.word   06000H
	.long   scorep
JACK:
	.word   47,9,23,0
	.long   050b16f5H
	.word   06000H
	.long   scorep
MASH:
	.word   60,9,29,0
	.long   050b20dfH
	.word   06000H
	.long   scorep
ROGERS:
	.word   41,9,20,0
	.long   050b2d87H
	.word   06000H
	.long   scorep
DUMARS:
	.word   46,9,22,0
	.long   050b362dH
	.word   06000H
	.long   scorep
RODMAN:
	.word   46,9,22,0
	.long   050b3fe1H
	.word   06000H
	.long   scorep
HUNTER:
	.word   41,9,20,0
	.long   050b4995H
	.word   06000H
	.long   scorep
WEBBER:
	.word   44,9,21,0
	.long   050b523bH
	.word   06000H
	.long   scorep
MAXWELL:
	.word   54,9,26,0
	.long   050b5b83H
	.word   06000H
	.long   scorep
HORRY:
	.word   35,9,17,0
	.long   050b66e7H
	.word   06000H
	.long   scorep
SMITS:
	.word   35,9,17,0
	.long   050b6e49H
	.word   06000H
	.long   scorep
SEALY:
	.word   32,9,16,0
	.long   050b75abH
	.word   06000H
	.long   scorep
ROBERTS:
	.word   48,9,23,0
	.long   050b7c6bH
	.word   06000H
	.long   scorep
PEELER:
	.word   38,9,18,0
	.long   050b868bH
	.word   06000H
	.long   scorep
CAMPBELL:
	.word   56,9,27,0
	.long   050b8e8fH
	.word   06000H
	.long   scorep
MINER:
	.word   34,9,16,0
	.long   050b9a5fH
	.word   06000H
	.long   scorep
BAKER:
	.word   34,9,16,0
	.long   050ba18bH
	.word   06000H
	.long   scorep
DAY:
	.word   21,9,10,0
	.long   050ba8b7H
	.word   06000H
	.long   scorep
RIDER:
	.word   30,9,14,0
	.long   050bad25H
	.word   06000H
	.long   scorep
CMORRIS:
	.word   42,9,20,0
	.long   050bb379H
	.word   06000H
	.long   scorep
MASON:
	.word   39,9,19,0
	.long   050bbc55H
	.word   06000H
	.long   scorep
STARKS:
	.word   42,9,20,0
	.long   050bc48fH
	.word   06000H
	.long   scorep
WEATH:
	.word   72,9,36,0
	.long   050bcd6bH
	.word   06000H
	.long   scorep
BRAD:
	.word   47,9,23,0
	.long   050bdc9bH
	.word   06000H
	.long   scorep
SIMM:
	.word   53,9,26,0
	.long   050be685H
	.word   06000H
	.long   scorep
HURL:
	.word   40,9,19,0
	.long   050bf1b3H
	.word   06000H
	.long   scorep
RICH:
	.word   55,9,27,0
	.long   050bfa23H
	.word   06000H
	.long   scorep
MCKEY:
	.word   38,9,18,0
	.long   050c05bdH
	.word   06000H
	.long   scorep
PAYTON:
	.word   42,9,20,0
	.long   050c0dc1H
	.word   06000H
	.long   scorep
BENOIT:
	.word   37,9,18,0
	.long   050c169dH
	.word   06000H
	.long   scorep
ELLISON:
	.word   42,9,20,0
	.long   050c1e6bH
	.word   06000H
	.long   scorep
CHEANEY:
	.word   46,9,22,0
	.long   050c2747H
	.word   06000H
	.long   scorep
font6_A:
	.word   5,6,0,0
	.long   050c30fbH
	.word   02000H
	.long   font6_PAL
font6_B:
	.word   5,6,0,0
	.long   050c3137H
	.word   02000H
	.long   font6_PAL
font6_C:
	.word   5,6,0,0
	.long   050c3173H
	.word   02000H
	.long   font6_PAL
font6_D:
	.word   5,6,0,0
	.long   050c31afH
	.word   02000H
	.long   font6_PAL
font6_E:
	.word   5,6,0,0
	.long   050c31ebH
	.word   02000H
	.long   font6_PAL
font6_F:
	.word   4,6,0,0
	.long   050c3227H
	.word   02000H
	.long   font6_PAL
font6_G:
	.word   5,6,0,0
	.long   050c3257H
	.word   02000H
	.long   font6_PAL
font6_H:
	.word   5,6,0,0
	.long   050c3293H
	.word   02000H
	.long   font6_PAL
font6_I:
	.word   2,6,0,0
	.long   050c32cfH
	.word   02000H
	.long   font6_PAL
font6_J:
	.word   5,6,0,0
	.long   050c32e7H
	.word   02000H
	.long   font6_PAL
font6_K:
	.word   5,6,0,0
	.long   050c3323H
	.word   02000H
	.long   font6_PAL
font6_L:
	.word   5,6,0,0
	.long   050c335fH
	.word   02000H
	.long   font6_PAL
font6_M:
	.word   6,6,0,0
	.long   050c339bH
	.word   02000H
	.long   font6_PAL
font6_N:
	.word   5,6,0,0
	.long   050c33e3H
	.word   02000H
	.long   font6_PAL
font6_O:
	.word   5,6,0,0
	.long   050c341fH
	.word   02000H
	.long   font6_PAL
font6_P:
	.word   5,6,0,0
	.long   050c345bH
	.word   02000H
	.long   font6_PAL
font6_Q:
	.word   5,7,0,0
	.long   050c3497H
	.word   02000H
	.long   font6_PAL
font6_R:
	.word   5,6,0,0
	.long   050c34ddH
	.word   02000H
	.long   font6_PAL
font6_S:
	.word   5,6,0,0
	.long   050c3519H
	.word   02000H
	.long   font6_PAL
font6_T:
	.word   6,6,0,0
	.long   050c3555H
	.word   02000H
	.long   font6_PAL
font6_U:
	.word   5,6,0,0
	.long   050c359dH
	.word   02000H
	.long   font6_PAL
font6_V:
	.word   6,6,0,0
	.long   050c35d9H
	.word   02000H
	.long   font6_PAL
font6_W:
	.word   6,6,0,0
	.long   050c3621H
	.word   02000H
	.long   font6_PAL
font6_X:
	.word   6,6,0,0
	.long   050c3669H
	.word   02000H
	.long   font6_PAL
font6_Y:
	.word   6,6,0,0
	.long   050c36b1H
	.word   02000H
	.long   font6_PAL
font6_Z:
	.word   6,6,0,0
	.long   050c36f9H
	.word   02000H
	.long   font6_PAL
font6_EXP:
	.word   2,6,0,0
	.long   050c3741H
	.word   02000H
	.long   font6_PAL
spark2:
	.word   3,4,0,0
	.long   050c3759H
	.word   05000H
	.long   spark_p
spark3:
	.word   4,4,0,0
	.long   050c3795H
	.word   05000H
	.long   spark_p
spark4:
	.word   4,4,0,0
	.long   050c37e5H
	.word   05000H
	.long   spark_p
spark5:
	.word   4,3,0,0
	.long   050c3835H
	.word   05000H
	.long   spark_p
spark1:
	.word   4,5,0,0
	.long   050c3871H
	.word   05000H
	.long   spark_p
back2:
	.word   28,78,-64,3
	.long   050c38d5H
	.word   07000H
	.long   HOOP_p
back3:
	.word   27,78,-64,3
	.long   050c748dH
	.word   07000H
	.long   HOOP_p
back4:
	.word   26,78,-64,3
	.long   050cae23H
	.word   07000H
	.long   HOOP_p
back5:
	.word   25,78,-64,3
	.long   050ce597H
	.word   07000H
	.long   HOOP_p
back6:
	.word   23,78,-64,3
	.long   050d1ae9H
	.word   07000H
	.long   HOOP_p
rim1f:
	.word   24,18,0,1
	.long   050d4bf7H
	.word   07000H
	.long   HOOP_p
rim1b:
	.word   25,19,-1,0
	.long   050d57c7H
	.word   07000H
	.long   HOOP_p
rim2f:
	.word   24,19,2,1
	.long   050d64c4H
	.word   07000H
	.long   HOOP_p
rim2b:
	.word   25,19,2,-1
	.long   050d713cH
	.word   07000H
	.long   HOOP_p
rim3f:
	.word   24,18,2,1
	.long   050d7e39H
	.word   07000H
	.long   HOOP_p
rim3b:
	.word   25,16,1,-2
	.long   050d8a09H
	.word   07000H
	.long   HOOP_p
rimbase:
	.word   9,6,-1,0
	.long   050d94f9H
	.word   07000H
	.long   HOOP_p
rim4f:
	.word   25,17,2,1
	.long   050d9673H
	.word   07000H
	.long   HOOP_p
rim4b:
	.word   24,14,-1,-1
	.long   050da212H
	.word   07000H
	.long   HOOP_p
hoopbot:
	.word   33,105,65,-92
	.long   050dab42H
	.word   07000H
	.long   HOOP_p
hooptop:
	.word   123,74,61,-13
	.long   050e0a01H
	.word   07000H
	.long   HOOP_p
swish1b:
	.word   25,18,-1,0
	.long   050f02e3H
	.word   07000H
	.long   HOOP_p
swish1f:
	.word   24,18,0,1
	.long   050f0f31H
	.word   07000H
	.long   HOOP_p
swish2b:
	.word   25,16,-1,0
	.long   050f1b01H
	.word   07000H
	.long   HOOP_p
swish2f:
	.word   24,17,0,1
	.long   050f25f1H
	.word   07000H
	.long   HOOP_p
swish3b:
	.word   25,12,-1,0
	.long   050f3119H
	.word   07000H
	.long   HOOP_p
swish3f:
	.word   25,13,0,1
	.long   050f394dH
	.word   07000H
	.long   HOOP_p
swish4b:
	.word   25,9,-1,2
	.long   050f4230H
	.word   07000H
	.long   HOOP_p
swish4f:
	.word   24,13,0,9
	.long   050f4857H
	.word   07000H
	.long   HOOP_p
swish5b:
	.word   27,8,0,0
	.long   050f50dfH
	.word   07000H
	.long   HOOP_p
swish5f:
	.word   27,9,1,1
	.long   050f56c7H
	.word   07000H
	.long   HOOP_p
farshot1b:
	.word   25,18,-1,0
	.long   050f5d6cH
	.word   07000H
	.long   HOOP_p
farshot1f:
	.word   24,19,0,1
	.long   050f69baH
	.word   07000H
	.long   HOOP_p
farshot2b:
	.word   26,15,0,0
	.long   050f7632H
	.word   07000H
	.long   HOOP_p
farshot2f:
	.word   26,16,2,1
	.long   050f80dcH
	.word   07000H
	.long   HOOP_p
farshot3b:
	.word   27,10,1,0
	.long   050f8c3cH
	.word   07000H
	.long   HOOP_p
farshot3f:
	.word   28,11,4,1
	.long   050f939eH
	.word   07000H
	.long   HOOP_p
farshot4b:
	.word   26,8,0,0
	.long   050f9c0aH
	.word   07000H
	.long   HOOP_p
farshot4f:
	.word   29,10,5,1
	.long   050fa1baH
	.word   07000H
	.long   HOOP_p
bbord_1:
	.word   23,78,-64,3
	.long   050fa9a8H
	.word   07000H
	.long   HOOP_p
bbord_2:
	.word   23,78,-64,3
	.long   050fdab6H
	.word   07000H
	.long   HOOP_p
bbord_3:
	.word   23,78,-64,3
	.long   05100bc4H
	.word   07000H
	.long   HOOP_p
bbord_4:
	.word   23,78,-64,3
	.long   05103cd2H
	.word   07000H
	.long   HOOP_p
bbord_5:
	.word   23,78,-64,3
	.long   05106de0H
	.word   07000H
	.long   HOOP_p
bbord_6:
	.word   23,78,-64,3
	.long   05109eeeH
	.word   07000H
	.long   HOOP_p
bbord_7:
	.word   23,78,-64,3
	.long   0510cffcH
	.word   07000H
	.long   HOOP_p
bbord_8:
	.word   23,78,-64,3
	.long   0511010aH
	.word   07000H
	.long   HOOP_p
bbord_9:
	.word   23,78,-64,3
	.long   05113218H
	.word   07000H
	.long   HOOP_p
bbord_10:
	.word   23,78,-64,3
	.long   05116326H
	.word   07000H
	.long   HOOP_p
bturn_1:
	.word   25,78,-64,3
	.long   05119434H
	.word   07000H
	.long   HOOP_p
bturn_2:
	.word   26,78,-64,3
	.long   0511c986H
	.word   07000H
	.long   HOOP_p
bturn_3:
	.word   27,78,-64,3
	.long   051200faH
	.word   07000H
	.long   HOOP_p
bturn_4:
	.word   28,78,-64,3
	.long   05123a90H
	.word   07000H
	.long   HOOP_p
bturn_5:
	.word   30,78,-64,3
	.long   05127648H
	.word   07000H
	.long   HOOP_p
shard1_1:
	.word   3,1,0,0
	.long   0512b644H
	.word   07000H
	.long   HOOP_p
shard1_2:
	.word   3,2,0,0
	.long   0512b659H
	.word   07000H
	.long   HOOP_p
shard1_3:
	.word   3,2,0,0
	.long   0512b683H
	.word   07000H
	.long   HOOP_p
shard1_4:
	.word   3,2,0,0
	.long   0512b6adH
	.word   07000H
	.long   HOOP_p
shard1_5:
	.word   3,1,0,0
	.long   0512b6d7H
	.word   07000H
	.long   HOOP_p
shard1_6:
	.word   3,2,0,0
	.long   0512b6ecH
	.word   07000H
	.long   HOOP_p
shard1_7:
	.word   3,2,0,0
	.long   0512b716H
	.word   07000H
	.long   HOOP_p
shard1_8:
	.word   3,2,0,0
	.long   0512b740H
	.word   07000H
	.long   HOOP_p
shard2_1:
	.word   3,2,1,0
	.long   0512b76aH
	.word   07000H
	.long   HOOP_p
shard2_2:
	.word   3,3,1,1
	.long   0512b794H
	.word   07000H
	.long   HOOP_p
shard2_3:
	.word   3,3,0,1
	.long   0512b7d3H
	.word   07000H
	.long   HOOP_p
shard2_4:
	.word   3,3,1,1
	.long   0512b812H
	.word   07000H
	.long   HOOP_p
shard2_5:
	.word   3,2,1,0
	.long   0512b851H
	.word   07000H
	.long   HOOP_p
shard2_6:
	.word   3,3,0,1
	.long   0512b87bH
	.word   07000H
	.long   HOOP_p
shard2_7:
	.word   3,3,0,1
	.long   0512b8baH
	.word   07000H
	.long   HOOP_p
shard2_8:
	.word   3,3,1,1
	.long   0512b8f9H
	.word   07000H
	.long   HOOP_p
shard3_1:
	.word   4,4,1,1
	.long   0512b938H
	.word   07000H
	.long   HOOP_p
shard3_2:
	.word   4,4,1,1
	.long   0512b938H
	.word   07000H
	.long   HOOP_p
shard3_3:
	.word   4,4,1,1
	.long   0512b9a8H
	.word   07000H
	.long   HOOP_p
shard3_4:
	.word   4,2,1,0
	.long   0512ba18H
	.word   07000H
	.long   HOOP_p
shard3_5:
	.word   4,1,1,0
	.long   0512ba50H
	.word   07000H
	.long   HOOP_p
shard3_6:
	.word   3,3,1,1
	.long   0512ba6cH
	.word   07000H
	.long   HOOP_p
shard3_7:
	.word   4,4,1,1
	.long   0512baabH
	.word   07000H
	.long   HOOP_p
shard3_8:
	.word   4,4,1,1
	.long   0512baabH
	.word   07000H
	.long   HOOP_p
shard3_9:
	.word   4,4,1,1
	.long   0512baabH
	.word   07000H
	.long   HOOP_p
shard3_10:
	.word   3,1,1,0
	.long   0512bb1bH
	.word   07000H
	.long   HOOP_p
shard3_11:
	.word   4,1,1,0
	.long   0512ba50H
	.word   07000H
	.long   HOOP_p
shard3_12:
	.word   3,3,1,1
	.long   0512bb30H
	.word   07000H
	.long   HOOP_p
shard4_1:
	.word   6,4,2,1
	.long   0512bb6fH
	.word   07000H
	.long   HOOP_p
shard4_2:
	.word   7,5,3,2
	.long   0512bc17H
	.word   07000H
	.long   HOOP_p
shard4_3:
	.word   5,5,2,2
	.long   0512bd0cH
	.word   07000H
	.long   HOOP_p
shard4_4:
	.word   3,4,0,1
	.long   0512bdbbH
	.word   07000H
	.long   HOOP_p
shard4_5:
	.word   3,4,1,1
	.long   0512be0fH
	.word   07000H
	.long   HOOP_p
shard4_6:
	.word   6,4,2,1
	.long   0512be63H
	.word   07000H
	.long   HOOP_p
shard4_7:
	.word   7,5,3,2
	.long   0512bf0bH
	.word   07000H
	.long   HOOP_p
shard4_8:
	.word   5,5,2,2
	.long   0512c000H
	.word   07000H
	.long   HOOP_p
shard4_9:
	.word   3,5,0,2
	.long   0512c0afH
	.word   07000H
	.long   HOOP_p
shard4_10:
	.word   3,4,1,1
	.long   0512c118H
	.word   07000H
	.long   HOOP_p
shard5_1:
	.word   4,4,1,1
	.long   0512c16cH
	.word   07000H
	.long   HOOP_p
shard5_2:
	.word   5,3,2,1
	.long   0512c1dcH
	.word   07000H
	.long   HOOP_p
shard5_3:
	.word   4,4,1,1
	.long   0512b9a8H
	.word   07000H
	.long   HOOP_p
shard5_4:
	.word   3,5,1,2
	.long   0512c245H
	.word   07000H
	.long   HOOP_p
shard5_5:
	.word   4,4,1,1
	.long   0512c2aeH
	.word   07000H
	.long   HOOP_p
shard5_6:
	.word   5,3,2,1
	.long   0512c1dcH
	.word   07000H
	.long   HOOP_p
shard5_7:
	.word   4,4,1,1
	.long   0512c31eH
	.word   07000H
	.long   HOOP_p
shard5_8:
	.word   3,5,1,2
	.long   0512c245H
	.word   07000H
	.long   HOOP_p
shard6_1:
	.word   3,2,0,0
	.long   0512c38eH
	.word   07000H
	.long   HOOP_p
shard6_2:
	.word   3,3,0,1
	.long   0512c3b8H
	.word   07000H
	.long   HOOP_p
shard6_3:
	.word   3,3,0,1
	.long   0512c3f7H
	.word   07000H
	.long   HOOP_p
shard6_4:
	.word   3,3,0,1
	.long   0512c436H
	.word   07000H
	.long   HOOP_p
shard6_5:
	.word   3,3,0,1
	.long   0512c475H
	.word   07000H
	.long   HOOP_p
shard6_6:
	.word   3,3,0,1
	.long   0512c4b4H
	.word   07000H
	.long   HOOP_p
shard6_7:
	.word   3,3,0,1
	.long   0512c4f3H
	.word   07000H
	.long   HOOP_p
shard6_8:
	.word   3,3,0,1
	.long   0512c532H
	.word   07000H
	.long   HOOP_p
shard7_1:
	.word   5,5,2,2
	.long   0512c571H
	.word   07000H
	.long   HOOP_p
shard7_2:
	.word   5,5,2,2
	.long   0512c620H
	.word   07000H
	.long   HOOP_p
shard7_3:
	.word   3,4,1,1
	.long   0512c6cfH
	.word   07000H
	.long   HOOP_p
shard7_4:
	.word   3,4,0,1
	.long   0512c723H
	.word   07000H
	.long   HOOP_p
shard7_5:
	.word   3,5,1,2
	.long   0512c777H
	.word   07000H
	.long   HOOP_p
shard7_6:
	.word   5,5,2,2
	.long   0512c7e0H
	.word   07000H
	.long   HOOP_p
shard7_7:
	.word   5,6,2,2
	.long   0512c88fH
	.word   07000H
	.long   HOOP_p
shard7_8:
	.word   3,6,1,2
	.long   0512c961H
	.word   07000H
	.long   HOOP_p
shard7_9:
	.word   3,6,0,2
	.long   0512c9dfH
	.word   07000H
	.long   HOOP_p
shard7_10:
	.word   3,6,1,2
	.long   0512ca5dH
	.word   07000H
	.long   HOOP_p
shard8_1:
	.word   3,2,0,0
	.long   0512cadbH
	.word   07000H
	.long   HOOP_p
shard8_2:
	.word   3,2,0,0
	.long   0512cb05H
	.word   07000H
	.long   HOOP_p
shard8_3:
	.word   3,1,0,0
	.long   0512cb2fH
	.word   07000H
	.long   HOOP_p
shard8_4:
	.word   3,1,0,0
	.long   0512cb44H
	.word   07000H
	.long   HOOP_p
shard8_5:
	.word   3,1,0,0
	.long   0512cb59H
	.word   07000H
	.long   HOOP_p
shard8_6:
	.word   3,1,0,0
	.long   0512cb6eH
	.word   07000H
	.long   HOOP_p
shard8_7:
	.word   3,2,0,0
	.long   0512b716H
	.word   07000H
	.long   HOOP_p
shard8_8:
	.word   3,2,0,0
	.long   0512cb83H
	.word   07000H
	.long   HOOP_p
shard8_9:
	.word   3,2,0,0
	.long   0512cbadH
	.word   07000H
	.long   HOOP_p
shard8_10:
	.word   3,2,0,0
	.long   0512cb05H
	.word   07000H
	.long   HOOP_p
shat1_1:
	.word   10,4,4,1
	.long   0512cbd7H
	.word   07000H
	.long   HOOP_p
shat1_2:
	.word   15,5,7,2
	.long   0512ccefH
	.word   07000H
	.long   HOOP_p
shat1_3:
	.word   20,5,9,2
	.long   0512cefcH
	.word   07000H
	.long   HOOP_p
shat1_4:
	.word   30,7,14,3
	.long   0512d1b8H
	.word   07000H
	.long   HOOP_p
shat1_5:
	.word   41,9,20,4
	.long   0512d776H
	.word   07000H
	.long   HOOP_p
shat2_1:
	.word   7,5,3,2
	.long   0512e18dH
	.word   07000H
	.long   HOOP_p
shat2_2:
	.word   10,5,4,2
	.long   0512e282H
	.word   07000H
	.long   HOOP_p
shat2_3:
	.word   18,7,8,3
	.long   0512e3e0H
	.word   07000H
	.long   HOOP_p
shat2_4:
	.word   27,8,13,3
	.long   0512e752H
	.word   07000H
	.long   HOOP_p
shat2_5:
	.word   39,9,19,4
	.long   0512ed3aH
	.word   07000H
	.long   HOOP_p
shat3_1:
	.word   3,2,1,0
	.long   0512b76aH
	.word   07000H
	.long   HOOP_p
shat3_2:
	.word   4,2,1,0
	.long   0512f6d3H
	.word   07000H
	.long   HOOP_p
shat3_3:
	.word   8,2,3,0
	.long   0512f70bH
	.word   07000H
	.long   HOOP_p
shat3_4:
	.word   12,4,5,1
	.long   0512f77bH
	.word   07000H
	.long   HOOP_p
shat3_5:
	.word   20,5,9,2
	.long   0512f8cbH
	.word   07000H
	.long   HOOP_p
shat4_1:
	.word   3,1,0,0
	.long   0512b644H
	.word   07000H
	.long   HOOP_p
shat4_2:
	.word   4,4,1,1
	.long   0512fb87H
	.word   07000H
	.long   HOOP_p
shat4_3:
	.word   8,5,3,2
	.long   0512fbf7H
	.word   07000H
	.long   HOOP_p
shat4_4:
	.word   14,5,6,2
	.long   0512fd0fH
	.word   07000H
	.long   HOOP_p
shat4_5:
	.word   12,6,5,2
	.long   0512fef9H
	.word   07000H
	.long   HOOP_p
rimbndF_1:
	.word   24,19,1,1
	.long   051300f1H
	.word   07000H
	.long   HOOP_p
rimbndF_2:
	.word   24,18,1,1
	.long   05130d69H
	.word   07000H
	.long   HOOP_p
rimbndF_3:
	.word   25,17,2,1
	.long   05131939H
	.word   07000H
	.long   HOOP_p
rimbndF_4:
	.word   23,21,4,1
	.long   051324d8H
	.word   07000H
	.long   HOOP_p
rimbndF_5:
	.word   15,28,6,1
	.long   0513320dH
	.word   07000H
	.long   HOOP_p
rimbndF_6:
	.word   18,25,4,1
	.long   05133d89H
	.word   07000H
	.long   HOOP_p
rimbndF_7:
	.word   22,21,3,1
	.long   051349d7H
	.word   07000H
	.long   HOOP_p
rimbndF_8:
	.word   25,17,2,1
	.long   05135679H
	.word   07000H
	.long   HOOP_p
rimbndF_9:
	.word   25,17,1,1
	.long   05136218H
	.word   07000H
	.long   HOOP_p
rimbndF_10:
	.word   23,20,1,4
	.long   05136db7H
	.word   07000H
	.long   HOOP_p
rimbndF_11:
	.word   25,19,1,7
	.long   05137a4bH
	.word   07000H
	.long   HOOP_p
rimbndF_12:
	.word   27,14,1,5
	.long   05138748H
	.word   07000H
	.long   HOOP_p
rimbndF_13:
	.word   27,9,2,1
	.long   0513919eH
	.word   07000H
	.long   HOOP_p
rimbndF_14:
	.word   27,10,3,2
	.long   05139843H
	.word   07000H
	.long   HOOP_p
rimbndF_15:
	.word   26,14,3,1
	.long   05139fa5H
	.word   07000H
	.long   HOOP_p
rimbndF_16:
	.word   27,14,3,1
	.long   0513a999H
	.word   07000H
	.long   HOOP_p
rimbndF_17:
	.word   27,18,2,1
	.long   0513b3efH
	.word   07000H
	.long   HOOP_p
rimbndB_1:
	.word   25,19,-1,0
	.long   0513c139H
	.word   07000H
	.long   HOOP_p
rimbndB_2:
	.word   25,16,-1,-1
	.long   0513ce36H
	.word   07000H
	.long   HOOP_p
rimbndB_3:
	.word   24,14,-1,-1
	.long   0513d926H
	.word   07000H
	.long   HOOP_p
rimbndB_4:
	.word   22,20,2,-1
	.long   0513e256H
	.word   07000H
	.long   HOOP_p
rimbndB_5:
	.word   11,27,2,-1
	.long   0513ee5eH
	.word   07000H
	.long   HOOP_p
rimbndB_6:
	.word   16,22,0,-2
	.long   0513f67dH
	.word   07000H
	.long   HOOP_p
rimbndB_7:
	.word   21,20,0,-1
	.long   0514001dH
	.word   07000H
	.long   HOOP_p
rimbndB_8:
	.word   24,14,-1,-1
	.long   05140b99H
	.word   07000H
	.long   HOOP_p
rimbndB_9:
	.word   25,10,-1,0
	.long   051414c9H
	.word   07000H
	.long   HOOP_p
rimbndB_10:
	.word   25,15,-1,3
	.long   05141b9fH
	.word   07000H
	.long   HOOP_p
rimbndB_11:
	.word   25,13,-1,6
	.long   051425e0H
	.word   07000H
	.long   HOOP_p
rimbndB_12:
	.word   27,11,-1,4
	.long   05142ec3H
	.word   07000H
	.long   HOOP_p
rimbndB_13:
	.word   27,8,0,0
	.long   051436e2H
	.word   07000H
	.long   HOOP_p
rimbndB_14:
	.word   27,11,1,-1
	.long   05143ccaH
	.word   07000H
	.long   HOOP_p
rimbndB_15:
	.word   26,14,1,-1
	.long   051444e9H
	.word   07000H
	.long   HOOP_p
rimbndB_16:
	.word   27,10,1,-1
	.long   05144eddH
	.word   07000H
	.long   HOOP_p
rimbndB_17:
	.word   25,11,-1,0
	.long   0514563fH
	.word   07000H
	.long   HOOP_p
firimB_1:
	.word   25,19,-1,0
	.long   05145dc4H
	.word   07000H
	.long   HOOP_p
firimB_2:
	.word   25,18,-1,0
	.long   05146ac1H
	.word   07000H
	.long   HOOP_p
firimB_3:
	.word   25,16,-1,0
	.long   0514770fH
	.word   07000H
	.long   HOOP_p
firimB_4:
	.word   25,12,-1,0
	.long   051481ffH
	.word   07000H
	.long   HOOP_p
firimB_5:
	.word   25,12,-1,5
	.long   05148a33H
	.word   07000H
	.long   HOOP_p
firimB_6:
	.word   27,15,0,7
	.long   05149267H
	.word   07000H
	.long   HOOP_p
firimB_7:
	.word   25,11,-1,3
	.long   05149d7aH
	.word   07000H
	.long   HOOP_p
firimB_8:
	.word   25,10,-1,0
	.long   0514a4ffH
	.word   07000H
	.long   HOOP_p
firimB_9:
	.word   25,11,-1,0
	.long   0514abd5H
	.word   07000H
	.long   HOOP_p
firimB_10:
	.word   25,11,-1,0
	.long   0514abd5H
	.word   07000H
	.long   HOOP_p
firimF_1:
	.word   24,18,0,1
	.long   0514b35aH
	.word   07000H
	.long   HOOP_p
firimF_2:
	.word   24,18,0,1
	.long   0514bf2aH
	.word   07000H
	.long   HOOP_p
firimF_3:
	.word   24,17,0,1
	.long   0514cafaH
	.word   07000H
	.long   HOOP_p
firimF_4:
	.word   25,13,0,1
	.long   0514d622H
	.word   07000H
	.long   HOOP_p
firimF_5:
	.word   24,35,0,29
	.long   0514df05H
	.word   07000H
	.long   HOOP_p
firimF_6:
	.word   27,25,1,15
	.long   0514f5fdH
	.word   07000H
	.long   HOOP_p
firimF_7:
	.word   24,29,0,13
	.long   05150872H
	.word   07000H
	.long   HOOP_p
firimF_8:
	.word   24,36,0,17
	.long   05151b7aH
	.word   07000H
	.long   HOOP_p
firimF_9:
	.word   25,42,1,20
	.long   0515331aH
	.word   07000H
	.long   HOOP_p
firimF_10:
	.word   29,49,3,22
	.long   05154fd0H
	.word   07000H
	.long   HOOP_p
firimB_11:
	.word   25,9,-1,0
	.long   051576abH
	.word   07000H
	.long   HOOP_p
firimF_11:
	.word   24,9,0,1
	.long   05157cd2H
	.word   07000H
	.long   HOOP_p
firimF_12:
	.word   31,51,3,21
	.long   051582baH
	.word   07000H
	.long   HOOP_p
firimF_13:
	.word   37,31,5,22
	.long   0515adf5H
	.word   07000H
	.long   HOOP_p
firimF_14:
	.word   48,42,10,26
	.long   0515cd52H
	.word   07000H
	.long   HOOP_p
firimF_15:
	.word   42,33,8,24
	.long   05160472H
	.word   07000H
	.long   HOOP_p
firimF_16:
	.word   47,34,11,25
	.long   05162a58H
	.word   07000H
	.long   HOOP_p
firimF_17:
	.word   50,34,11,25
	.long   0516560aH
	.word   07000H
	.long   HOOP_p
firimB_bnd:
	.word   25,7,2,-1
	.long   05168486H
	.word   07000H
	.long   HOOP_p
firimF_bnd:
	.word   24,10,2,0
	.long   0516894fH
	.word   07000H
	.long   HOOP_p
BirthM_B:
	.word   190,14,94,0
	.long   05168fdfH
	.word   06000H
	.long   FGAMEPAL
Stats_B:
	.word   190,14,94,0
	.long   0516ce37H
	.word   06000H
	.long   FGAMEPAL
INITIALS_B:
	.word   190,14,94,0
	.long   05170c8fH
	.word   06000H
	.long   FGAMEPAL
BirthD_B:
	.word   190,14,94,0
	.long   05174ae7H
	.word   06000H
	.long   FGAMEPAL
PRESSBUTT:
	.word   241,18,120,8
	.long   0517893fH
	.word   05000H
	.long   BUTT_P
PRESSTURB:
	.word   225,18,112,8
	.long   0517ddf9H
	.word   05000H
	.long   TURBO_P
selectbox:
	.word   87,40,43,0
	.long   05182d13H
	.word   01000H
	.long   selpal
CENTERBAR:
	.word   6,40,3,0
	.long   05183aabH
	.word   06000H
	.long   METLPALC
TopTenred:
	.word   83,36,0,0
	.long   0518404bH
	.word   04000H
	.long   fgpalred
TopTengrn:
	.word   83,36,0,0
	.long   0518404bH
	.word   04000H
	.long   fgpalgrn
TopTenorg:
	.word   83,36,0,0
	.long   0518404bH
	.word   04000H
	.long   fgpalorg
TopTengld:
	.word   83,36,0,0
	.long   0518404bH
	.word   04000H
	.long   fgpalgld
start3:
	.word   49,29,24,14
	.long   05186efbH
	.word   04000H
	.long   SGMD8YEL
insert3:
	.word   56,29,27,14
	.long   0518852fH
	.word   04000H
	.long   SGMD8YEL
freplay3:
	.word   81,14,40,6
	.long   05189e8fH
	.word   04000H
	.long   SGMD8YEL
join3:
	.word   61,14,30,6
	.long   0518b047H
	.word   04000H
	.long   SGMD8YEL
INITIALS:
	.word   92,14,46,0
	.long   0518bd9fH
	.word   06000H
	.long   FGAMEPAL
BirthM:
	.word   92,14,46,0
	.long   0518dbcfH
	.word   06000H
	.long   FGAMEPAL
BirthD:
	.word   92,14,46,0
	.long   0518f9ffH
	.word   06000H
	.long   FGAMEPAL
Stats:
	.word   92,14,46,0
	.long   0519182fH
	.word   06000H
	.long   FGAMEPAL
start2:
	.word   35,19,17,0
	.long   0519365fH
	.word   04000H
	.long   SGMD8YEL
insert2:
	.word   37,19,18,0
	.long   051940c3H
	.word   04000H
	.long   SGMD8YEL
freeplay:
	.word   55,9,27,-5
	.long   05194bbfH
	.word   04000H
	.long   SGMD8VIO
yesnobak:
	.word   115,67,0,0
	.long   0519537bH
	.word   04000H
	.long   YESNOPAL
FulGamered:
	.word   83,36,0,0
	.long   0519cbdfH
	.word   04000H
	.long   fgpalred
FulGameorg:
	.word   83,36,0,0
	.long   0519cbdfH
	.word   04000H
	.long   fgpalorg
FulGamegrn:
	.word   83,36,0,0
	.long   0519cbdfH
	.word   04000H
	.long   fgpalgrn
FulGamegld:
	.word   83,36,0,0
	.long   0519cbdfH
	.word   04000H
	.long   fgpalgld
rosterblu:
	.word   83,36,0,0
	.long   0519fa8fH
	.word   04000H
	.long   fgpalblu
rosterred:
	.word   83,36,0,0
	.long   0519fa8fH
	.word   04000H
	.long   fgpalred
fatalred:
	.word   83,36,0,0
	.long   051a293fH
	.word   04000H
	.long   fgpalred
fatalblu:
	.word   83,36,0,0
	.long   051a57efH
	.word   04000H
	.long   fgpalblu
swapblu:
	.word   83,36,0,0
	.long   051a869fH
	.word   04000H
	.long   fgpalblu
swapred:
	.word   83,36,0,0
	.long   051a869fH
	.word   04000H
	.long   fgpalred
_4playbx:
	.word   213,95,106,0
	.long   051ab54fH
	.word   06000H
	.long   GROWBOX
_4playline:
	.word   117,4,58,1
	.long   051c8f91H
	.word   04000H
	.long   SGMD8GLD
useupbx:
	.word   117,74,58,0
	.long   051c96e1H
	.word   06000H
	.long   WHITEPAL
OSGEMD_AND:
	.word   21,22,0,0
	.long   051d61cdH
	.word   06000H
	.long   OSGEMD
OSGEMD_A:
	.word   14,22,0,0
	.long   051d6ca1H
	.word   06000H
	.long   ORANGPAL
OSGEMD_B:
	.word   14,22,0,0
	.long   051d73d9H
	.word   06000H
	.long   GREENPAL
OSGEMD_C:
	.word   12,22,0,0
	.long   051d7b11H
	.word   06000H
	.long   GOLD
OSGEMD_D:
	.word   14,22,0,0
	.long   051d8141H
	.word   06000H
	.long   REDPAL
OSGEMD_E:
	.word   12,22,0,0
	.long   051d8879H
	.word   06000H
	.long   WHITEPAL
OSGEMD_F:
	.word   11,22,0,0
	.long   051d8ea9H
	.word   06000H
	.long   PURPLE
OSGEMD_G:
	.word   14,22,0,0
	.long   051d9455H
	.word   06000H
	.long   TURQUSE
OSGEMD_H:
	.word   14,22,0,0
	.long   051d9b8dH
	.word   06000H
	.long   BLUE
OSGEMD_I:
	.word   7,22,0,0
	.long   051da2c5H
	.word   06000H
	.long   RUBYPAL
OSGEMD_J:
	.word   11,22,0,0
	.long   051da661H
	.word   06000H
	.long   AQUAPAL
OSGEMD_K:
	.word   14,22,0,0
	.long   051dac0dH
	.word   06000H
	.long   WHITE2PAL
OSGEMD_L:
	.word   11,22,0,0
	.long   051db345H
	.word   06000H
	.long   OSGEMD
OSGEMD_M:
	.word   21,22,0,0
	.long   051db8f1H
	.word   06000H
	.long   OSGEMD
OSGEMD_N:
	.word   14,22,0,0
	.long   051dc3c5H
	.word   06000H
	.long   OSGEMD
OSGEMD_O:
	.word   14,22,0,0
	.long   051dcafdH
	.word   06000H
	.long   OSGEMD
OSGEMD_P:
	.word   14,22,0,0
	.long   051dd235H
	.word   06000H
	.long   OSGEMD
OSGEMD_Q:
	.word   14,25,0,0
	.long   051dd96dH
	.word   06000H
	.long   OSGEMD
OSGEMD_R:
	.word   14,22,0,0
	.long   051de1a1H
	.word   06000H
	.long   OSGEMD
OSGEMD_S:
	.word   13,22,0,0
	.long   051de8d9H
	.word   06000H
	.long   OSGEMD
OSGEMD_T:
	.word   13,22,0,0
	.long   051def8dH
	.word   06000H
	.long   OSGEMD
OSGEMD_U:
	.word   14,22,0,0
	.long   051df641H
	.word   06000H
	.long   OSGEMD
OSGEMD_V:
	.word   14,22,0,0
	.long   051dfd79H
	.word   06000H
	.long   OSGEMD
OSGEMD_W:
	.word   21,22,0,0
	.long   051e04b1H
	.word   06000H
	.long   OSGEMD
OSGEMD_X:
	.word   14,22,0,0
	.long   051e0f85H
	.word   06000H
	.long   OSGEMD
OSGEMD_Y:
	.word   14,22,0,0
	.long   051e16bdH
	.word   06000H
	.long   OSGEMD
OSGEMD_Z:
	.word   13,22,0,0
	.long   051e1df5H
	.word   06000H
	.long   OSGEMD
OSGEMD_EXP:
	.word   7,22,0,0
	.long   051e24a9H
	.word   06000H
	.long   OSGEMD
OSGEMD_DAS:
	.word   14,9,0,-7
	.long   051e2845H
	.word   06000H
	.long   OSGEMD
OSGEMD_DEL:
	.word   19,26,0,0
	.long   051e2b39H
	.word   06000H
	.long   OSGEMD
OSGEMD_DOT:
	.word   7,9,0,-13
	.long   051e36cdH
	.word   06000H
	.long   OSGEMD
OSGEMD_DOL:
	.word   16,22,0,0
	.long   051e3847H
	.word   06000H
	.long   OSGEMD
OSGEMD_SLS:
	.word   14,22,0,0
	.long   051e4087H
	.word   06000H
	.long   OSGEMD
OSGEMD_APO:
	.word   7,11,0,0
	.long   051e47bfH
	.word   06000H
	.long   OSGEMD
OSGEMD_COM:
	.word   7,11,0,-13
	.long   051e47bfH
	.word   06000H
	.long   OSGEMD
OSGEMD_QUE:
	.word   14,22,0,0
	.long   051e498dH
	.word   06000H
	.long   OSGEMD
growbox:
	.word   91,95,0,0
	.long   051e50c5H
	.word   06000H
	.long   GROWBOX
OSGEMD_BAK:
	.word   14,21,0,0
	.long   051f1b63H
	.word   06000H
	.long   OSGEMD
OSGEMD_SPC:
	.word   21,22,0,0
	.long   051f2247H
	.word   06000H
	.long   OSGEMD
OSGEMD_END:
	.word   20,22,0,0
	.long   051f2d1bH
	.word   06000H
	.long   OSGEMD
OSGEMD_COL:
	.word   7,18,0,-3
	.long   051f376bH
	.word   06000H
	.long   OSGEMD
OSGEMD_OBR:
	.word   10,23,0,0
	.long   051f3a5fH
	.word   06000H
	.long   OSGEMD
OSGEMD_CBR:
	.word   10,23,0,0
	.long   051f3fc3H
	.word   06000H
	.long   OSGEMD
OSGEMD_NUM:
	.word   19,21,0,-1
	.long   051f4527H
	.word   06000H
	.long   OSGEMD
OSGEMD_0:
	.word   14,22,0,0
	.long   051f4e81H
	.word   06000H
	.long   OSGEMD
OSGEMD_1:
	.word   9,22,0,0
	.long   051f55b9H
	.word   06000H
	.long   OSGEMD
OSGEMD_2:
	.word   14,22,0,0
	.long   051f5a5dH
	.word   06000H
	.long   OSGEMD
OSGEMD_3:
	.word   14,22,0,0
	.long   051f6195H
	.word   06000H
	.long   OSGEMD
OSGEMD_4:
	.word   16,22,0,0
	.long   051f68cdH
	.word   06000H
	.long   OSGEMD
OSGEMD_5:
	.word   14,22,0,0
	.long   051f710dH
	.word   06000H
	.long   OSGEMD
OSGEMD_6:
	.word   14,22,0,0
	.long   051f7845H
	.word   06000H
	.long   OSGEMD
OSGEMD_7:
	.word   14,22,0,0
	.long   051f7f7dH
	.word   06000H
	.long   OSGEMD
OSGEMD_8:
	.word   14,22,0,0
	.long   051f86b5H
	.word   06000H
	.long   OSGEMD
OSGEMD_9:
	.word   14,22,0,0
	.long   051f8dedH
	.word   06000H
	.long   OSGEMD
MD_JAN:
	.word   35,22,0,0
	.long   051f9525H
	.word   06000H
	.long   OSGEMD
MD_FEB:
	.word   33,22,0,0
	.long   051fa731H
	.word   06000H
	.long   OSGEMD
MD_MAR:
	.word   45,22,0,0
	.long   051fb835H
	.word   06000H
	.long   OSGEMD
MD_APR:
	.word   38,22,0,0
	.long   051fcf69H
	.word   06000H
	.long   OSGEMD
MD_MAY:
	.word   45,22,0,0
	.long   051fe301H
	.word   06000H
	.long   OSGEMD
MD_JUN:
	.word   35,22,0,0
	.long   051ffa35H
	.word   06000H
	.long   OSGEMD
MD_JUL:
	.word   32,22,0,0
	.long   05200c41H
	.word   06000H
	.long   OSGEMD
MD_AUG:
	.word   38,22,0,0
	.long   05201cc1H
	.word   06000H
	.long   OSGEMD
MD_SEP:
	.word   35,22,0,0
	.long   05203059H
	.word   06000H
	.long   OSGEMD
MD_OCT:
	.word   35,22,0,0
	.long   05204265H
	.word   06000H
	.long   OSGEMD
MD_NOV:
	.word   38,22,0,0
	.long   05205471H
	.word   06000H
	.long   OSGEMD
MD_DEC:
	.word   34,22,0,0
	.long   05206809H
	.word   06000H
	.long   OSGEMD
OSGENM_1:
	.word   7,21,0,0
	.long   05207991H
	.word   06000H
	.long   OSGEMD
OSGENM_2:
	.word   10,21,0,0
	.long   05207d03H
	.word   06000H
	.long   OSGEMD
OSGENM_3:
	.word   10,21,0,0
	.long   052081efH
	.word   06000H
	.long   OSGEMD
OSGENM_4:
	.word   12,21,0,0
	.long   052086dbH
	.word   06000H
	.long   OSGEMD
OSGENM_5:
	.word   10,21,0,0
	.long   05208cc3H
	.word   06000H
	.long   OSGEMD
OSGENM_6:
	.word   10,21,0,0
	.long   052091afH
	.word   06000H
	.long   OSGEMD
OSGENM_7:
	.word   10,21,0,0
	.long   0520969bH
	.word   06000H
	.long   OSGEMD
OSGENM_8:
	.word   10,21,0,0
	.long   05209b87H
	.word   06000H
	.long   OSGEMD
OSGENM_9:
	.word   10,21,0,0
	.long   0520a073H
	.word   06000H
	.long   OSGEMD
OSGENM_10:
	.word   17,21,0,0
	.long   0520a55fH
	.word   06000H
	.long   OSGEMD
OSGENM_11:
	.word   14,21,0,0
	.long   0520adbdH
	.word   06000H
	.long   OSGEMD
OSGENM_12:
	.word   17,21,0,0
	.long   0520b4a1H
	.word   06000H
	.long   OSGEMD
OSGENM_13:
	.word   17,21,0,0
	.long   0520bcffH
	.word   06000H
	.long   OSGEMD
OSGENM_14:
	.word   18,21,0,0
	.long   0520c55dH
	.word   06000H
	.long   OSGEMD
OSGENM_15:
	.word   17,21,0,0
	.long   0520ce39H
	.word   06000H
	.long   OSGEMD
OSGENM_16:
	.word   17,21,0,0
	.long   0520d697H
	.word   06000H
	.long   OSGEMD
OSGENM_17:
	.word   17,21,0,0
	.long   0520def5H
	.word   06000H
	.long   OSGEMD
OSGENM_18:
	.word   17,21,0,0
	.long   0520e753H
	.word   06000H
	.long   OSGEMD
OSGENM_19:
	.word   17,21,0,0
	.long   0520efb1H
	.word   06000H
	.long   OSGEMD
OSGENM_20:
	.word   19,21,0,0
	.long   0520f80fH
	.word   06000H
	.long   OSGEMD
OSGENM_21:
	.word   17,21,0,0
	.long   05210169H
	.word   06000H
	.long   OSGCYC1
OSGENM_22:
	.word   19,21,0,0
	.long   052109c7H
	.word   06000H
	.long   OSGCYC2
OSGENM_23:
	.word   19,21,0,0
	.long   05211321H
	.word   06000H
	.long   OSGCYC3
OSGENM_24:
	.word   20,21,0,0
	.long   05211c7bH
	.word   06000H
	.long   OSGCYC4
OSGENM_25:
	.word   19,21,0,0
	.long   05212653H
	.word   06000H
	.long   OSGCYC5
OSGENM_26:
	.word   19,21,0,0
	.long   05212fadH
	.word   06000H
	.long   OSGCYC6
OSGENM_27:
	.word   19,21,0,0
	.long   05213907H
	.word   06000H
	.long   OSGCYC7
OSGENM_28:
	.word   19,21,0,0
	.long   05214261H
	.word   06000H
	.long   OSGCYC8
OSGENM_29:
	.word   19,21,0,0
	.long   05214bbbH
	.word   06000H
	.long   OSGCYC9
OSGENM_30:
	.word   19,21,0,0
	.long   05215515H
	.word   06000H
	.long   OSGCYC10
OSGENM_31:
	.word   17,21,0,0
	.long   05215e6fH
	.word   06000H
	.long   OSGCYC11
T_BULLS:
	.word   59,58,29,29
	.long   052166cdH
	.word   0580H
	.long   P_BULS
T_HAWKS:
	.word   62,62,31,31
	.long   0521b0edH
	.word   0580H
	.long   P_HAWKS
T_NUGS:
	.word   87,51,43,29
	.long   05220e8dH
	.word   0a80H
	.long   P_NUGS
T_BLAZ:
	.word   78,18,39,9
	.long   05227dadH
	.word   080H
	.long   P_BLAZ
T_SONICS:
	.word   81,57,40,29
	.long   0522a86dH
	.word   0680H
	.long   P_SONICS
T_76RS:
	.word   64,60,32,30
	.long   052304fdH
	.word   0580H
	.long   P_76RS
T_SUNS:
	.word   56,60,28,30
	.long   0523691dH
	.word   080H
	.long   P_SUNS
T_SPURS:
	.word   78,39,39,19
	.long   0523bb4dH
	.word   0480H
	.long   P_SPURS
T_MAGIC:
	.word   80,27,40,14
	.long   05240a1dH
	.word   0980H
	.long   P_MAGIC
T_PACER:
	.word   72,56,36,28
	.long   05244035H
	.word   0480H
	.long   P_PACER
T_CAVS:
	.word   83,33,41,17
	.long   0524a275H
	.word   0680H
	.long   P_CAVS
T_BUCKS:
	.word   55,63,27,31
	.long   0524e555H
	.word   0580H
	.long   P_BUCKS
T_HEAT:
	.word   44,60,22,30
	.long   05253115H
	.word   0180H
	.long   P_HEAT
T_CLIPS:
	.word   81,54,40,27
	.long   052562fdH
	.word   0680H
	.long   P_CLIPS
T_BULTS:
	.word   82,31,41,16
	.long   0525d23dH
	.word   0a80H
	.long   P_BULTS
T_WARS:
	.word   68,61,34,32
	.long   0525fd85H
	.word   0580H
	.long   P_WARS
T_HORS:
	.word   59,60,29,30
	.long   052658bdH
	.word   0580H
	.long   P_HORS
T_PISS:
	.word   62,59,31,30
	.long   0526ad7dH
	.word   0580H
	.long   P_PISS
T_LAKS:
	.word   81,47,40,24
	.long   05270a95H
	.word   0580H
	.long   P_LAKS
T_TWOLV:
	.word   50,63,25,32
	.long   05275c15H
	.word   080H
	.long   P_TWOV
T_CELTS:
	.word   51,61,25,31
	.long   0527aef5H
	.word   0580H
	.long   P_CELTS
T_JAZZ:
	.word   85,34,42,17
	.long   0527f905H
	.word   0180H
	.long   P_JAZZ
T_KINGS:
	.word   52,63,26,32
	.long   05284225H
	.word   080H
	.long   P_KINGS
T_NETS:
	.word   66,63,33,32
	.long   0528a2cdH
	.word   0580H
	.long   P_NETS
T_MAVS:
	.word   83,31,41,16
	.long   05290dd5H
	.word   0880H
	.long   P_MAVS
T_ROCKS:
	.word   62,62,31,31
	.long   05294245H
	.word   0580H
	.long   P_ROCKS
T_KNIKS:
	.word   86,59,43,30
	.long   0529a345H
	.word   0a80H
	.long   P_KNIKS
cities1:
	.word   79,81,0,0
	.long   052a02adH
	.word   04000H
	.long   SGMD8YEL
cities2:
	.word   71,81,0,0
	.long   052a66a9H
	.word   04000H
	.long   SGMD8YEL
cities3:
	.word   64,81,0,0
	.long   052ac085H
	.word   04000H
	.long   SGMD8VIO
cities4:
	.word   73,81,0,0
	.long   052b1185H
	.word   04000H
	.long   SGMD8VIO
C_PORT:
	.word   55,9,0,0
	.long   052b6de9H
	.word   04000H
	.long   SGMD8YEL
C_LA:
	.word   71,9,0,0
	.long   052b75a5H
	.word   04000H
	.long   SGMD8YEL
C_LALaks:
	.word   65,9,0,0
	.long   052b7fa1H
	.word   04000H
	.long   SGMD8YEL
C_LAClips:
	.word   74,9,0,0
	.long   052b88c5H
	.word   04000H
	.long   SGMD8YEL
C_PHX:
	.word   44,9,0,0
	.long   052b932dH
	.word   04000H
	.long   SGMD8YEL
C_GOLD:
	.word   79,9,0,0
	.long   052b995dH
	.word   04000H
	.long   SGMD8YEL
C_SEA:
	.word   46,9,0,0
	.long   052ba479H
	.word   04000H
	.long   SGMD8YEL
C_SAC:
	.word   72,9,0,0
	.long   052baaf1H
	.word   04000H
	.long   SGMD8YEL
C_HOU:
	.word   49,9,0,0
	.long   052bb511H
	.word   04000H
	.long   SGMD8YEL
C_SAN:
	.word   71,9,0,0
	.long   052bbbf5H
	.word   04000H
	.long   SGMD8YEL
C_UTAH:
	.word   28,9,0,0
	.long   052bc5f1H
	.word   04000H
	.long   SGMD8YEL
C_DAL:
	.word   40,9,0,0
	.long   052bc9e1H
	.word   04000H
	.long   SGMD8YEL
C_MINN:
	.word   62,9,0,0
	.long   052bcf81H
	.word   04000H
	.long   SGMD8YEL
C_DEN:
	.word   40,9,0,0
	.long   052bd839H
	.word   04000H
	.long   SGMD8YEL
C_CHIC:
	.word   43,9,0,0
	.long   052bddd9H
	.word   04000H
	.long   SGMD8VIO
C_DET:
	.word   44,9,0,0
	.long   052be3e5H
	.word   04000H
	.long   SGMD8VIO
C_IND:
	.word   41,9,0,0
	.long   052bea15H
	.word   04000H
	.long   SGMD8VIO
C_CLEV:
	.word   58,9,0,0
	.long   052befd9H
	.word   04000H
	.long   SGMD8VIO
C_MILW:
	.word   64,9,0,0
	.long   052bf801H
	.word   04000H
	.long   SGMD8VIO
C_ATL:
	.word   48,9,0,0
	.long   052c0101H
	.word   04000H
	.long   SGMD8VIO
C_CHAR:
	.word   60,9,0,0
	.long   052c07c1H
	.word   04000H
	.long   SGMD8VIO
C_PHIL:
	.word   73,9,0,0
	.long   052c1031H
	.word   04000H
	.long   SGMD8VIO
C_BOST:
	.word   42,9,0,0
	.long   052c1a75H
	.word   04000H
	.long   SGMD8VIO
C_NY:
	.word   57,9,0,0
	.long   052c205dH
	.word   04000H
	.long   SGMD8VIO
C_NJ:
	.word   69,9,0,0
	.long   052c2861H
	.word   04000H
	.long   SGMD8VIO
C_WASH:
	.word   70,9,0,0
	.long   052c3215H
	.word   04000H
	.long   SGMD8VIO
C_ORL:
	.word   48,9,0,0
	.long   052c3bedH
	.word   04000H
	.long   SGMD8VIO
C_MIAMI:
	.word   35,9,0,0
	.long   052c42adH
	.word   04000H
	.long   SGMD8VIO
C_PORT_O:
	.word   63,11,0,0
	.long   052c4799H
	.word   04000H
	.long   SGMD8YEL
C_LALaks_O:
	.word   76,11,0,0
	.long   052c526dH
	.word   04000H
	.long   SGMD8YEL
C_LAClips_O:
	.word   87,11,0,0
	.long   052c5f7dH
	.word   04000H
	.long   SGMD8YEL
C_PHX_O:
	.word   51,11,0,0
	.long   052c6e71H
	.word   04000H
	.long   SGMD8YEL
C_GOLD_O:
	.word   91,11,0,0
	.long   052c7735H
	.word   04000H
	.long   SGMD8YEL
C_SEA_O:
	.word   53,11,0,0
	.long   052c86d9H
	.word   04000H
	.long   SGMD8YEL
C_SAC_O:
	.word   82,11,0,0
	.long   052c8ff5H
	.word   04000H
	.long   SGMD8YEL
C_HOU_O:
	.word   56,11,0,0
	.long   052c9e0dH
	.word   04000H
	.long   SGMD8YEL
C_SAN_O:
	.word   82,11,0,0
	.long   052ca7adH
	.word   04000H
	.long   SGMD8YEL
C_UTAH_O:
	.word   32,11,0,0
	.long   052cb5c5H
	.word   04000H
	.long   SGMD8YEL
C_DAL_O:
	.word   46,11,0,0
	.long   052cbb45H
	.word   04000H
	.long   SGMD8YEL
C_MINN_O:
	.word   71,11,0,0
	.long   052cc32dH
	.word   04000H
	.long   SGMD8YEL
C_DEN_O:
	.word   46,11,0,0
	.long   052ccf61H
	.word   04000H
	.long   SGMD8YEL
C_CHIC_O:
	.word   50,11,0,0
	.long   052cd749H
	.word   04000H
	.long   SGMD8YEL
C_DET_O:
	.word   51,11,0,0
	.long   052cdfe1H
	.word   04000H
	.long   SGMD8YEL
C_IND_O:
	.word   48,11,0,0
	.long   052ce8a5H
	.word   04000H
	.long   SGMD8YEL
C_CLEV_O:
	.word   67,11,0,0
	.long   052cf0e5H
	.word   04000H
	.long   SGMD8YEL
C_MILW_O:
	.word   73,11,0,0
	.long   052cfc69H
	.word   04000H
	.long   SGMD8YEL
C_ATL_O:
	.word   55,11,0,0
	.long   052d08f5H
	.word   04000H
	.long   SGMD8YEL
C_CHAR_O:
	.word   69,11,0,0
	.long   052d1269H
	.word   04000H
	.long   SGMD8YEL
C_PHIL_O:
	.word   85,11,0,0
	.long   052d1e45H
	.word   04000H
	.long   SGMD8YEL
C_BOST_O:
	.word   48,11,0,0
	.long   052d2ce1H
	.word   04000H
	.long   SGMD8YEL
C_NY_O:
	.word   65,11,0,0
	.long   052d3521H
	.word   04000H
	.long   SGMD8YEL
C_NJ_O:
	.word   78,11,0,0
	.long   052d404dH
	.word   04000H
	.long   SGMD8YEL
C_WASH_O:
	.word   80,11,0,0
	.long   052d4db5H
	.word   04000H
	.long   SGMD8YEL
C_ORL_O:
	.word   55,11,0,0
	.long   052d5b75H
	.word   04000H
	.long   SGMD8YEL
C_MIAMI_O:
	.word   40,11,0,0
	.long   052d64e9H
	.word   04000H
	.long   SGMD8YEL
lgmd_A:
	.word   37,61,0,0
	.long   052d6bc9H
	.word   06000H
	.long   LGMDGLD
lgmd_B:
	.word   37,61,0,0
	.long   052da0afH
	.word   06000H
	.long   LGMDBLU
lgmd_C:
	.word   26,61,0,0
	.long   052dd595H
	.word   06000H
	.long   LGGEMD1
lgmd_D:
	.word   38,61,0,0
	.long   052dfac1H
	.word   06000H
	.long   LGMDCHR
lgmd_E:
	.word   30,61,0,0
	.long   052e3115H
	.word   06000H
	.long   LGMDGLD
lgmd_F:
	.word   27,61,0,0
	.long   052e5bf9H
	.word   06000H
	.long   LGMDORNG
lgmd_G:
	.word   37,61,0,0
	.long   052e8293H
	.word   06000H
	.long   LGMDRED2
lgmd_H:
	.word   37,61,0,0
	.long   052eb779H
	.word   06000H
	.long   LGMDSLV
lgmd_I:
	.word   18,61,0,0
	.long   052eec5fH
	.word   06000H
	.long   LGMDWHT
lgmd_J:
	.word   24,61,0,0
	.long   052f061bH
	.word   06000H
	.long   LGMDPURP
lgmd_K:
	.word   37,61,0,0
	.long   052f286bH
	.word   06000H
	.long   LGMDGLDlt
lgmd_L:
	.word   27,61,0,0
	.long   052f5d51H
	.word   06000H
	.long   LGMDGLDdk
lgmd_M:
	.word   57,61,0,0
	.long   052f83ebH
	.word   06000H
	.long   LGMDGLD
lgmd_N:
	.word   38,61,0,0
	.long   052fd569H
	.word   06000H
	.long   LGMDGLD
lgmd_O:
	.word   37,61,0,0
	.long   05300bbdH
	.word   06000H
	.long   LGMDGLD
lgmd_P:
	.word   37,61,0,0
	.long   053040a3H
	.word   06000H
	.long   LGMDGLD
lgmd_Q:
	.word   38,73,0,0
	.long   05307589H
	.word   06000H
	.long   LGMDGLD
lgmd_R:
	.word   38,61,0,0
	.long   0530b68dH
	.word   06000H
	.long   LGMDGLD
lgmd_S:
	.word   31,61,0,0
	.long   0530ece1H
	.word   06000H
	.long   LGMDGLD
lgmd_T:
	.word   30,61,0,0
	.long   05311933H
	.word   06000H
	.long   LGMDGLD
lgmd_U:
	.word   37,61,0,0
	.long   05314417H
	.word   06000H
	.long   LGMDGLD
lgmd_V:
	.word   37,61,0,0
	.long   053178fdH
	.word   06000H
	.long   LGMDGLD
lgmd_W:
	.word   56,61,0,0
	.long   0531ade3H
	.word   06000H
	.long   LGMDGLD
lgmd_X:
	.word   37,61,0,0
	.long   0531fdf3H
	.word   06000H
	.long   LGMDGLD
lgmd_Y:
	.word   38,61,0,0
	.long   053232d9H
	.word   06000H
	.long   LGMDGLD
lgmd_Z:
	.word   33,61,0,0
	.long   0532692dH
	.word   06000H
	.long   LGMDGLD
lgmd_0:
	.word   35,61,0,0
	.long   0532985bH
	.word   06000H
	.long   LGMDGLD
lgmd_1:
	.word   20,61,0,0
	.long   0532ca65H
	.word   06000H
	.long   LGMDGLD
lgmd_2:
	.word   36,61,0,0
	.long   0532e6fdH
	.word   06000H
	.long   LGMDGLD
lgmd_3:
	.word   35,61,0,0
	.long   05331a75H
	.word   06000H
	.long   LGMDGLD
lgmd_4:
	.word   44,61,0,0
	.long   05334c7fH
	.word   06000H
	.long   LGMDGLD
lgmd_5:
	.word   35,61,0,0
	.long   05338b67H
	.word   06000H
	.long   LGMDGLD
lgmd_6:
	.word   35,61,0,0
	.long   0533bd71H
	.word   06000H
	.long   LGMDGLD
lgmd_7:
	.word   35,61,0,0
	.long   0533ef7bH
	.word   06000H
	.long   LGMDGLD
lgmd_8:
	.word   35,61,0,0
	.long   05342185H
	.word   06000H
	.long   LGMDGLD
lgmd_9:
	.word   35,61,0,0
	.long   0534538fH
	.word   06000H
	.long   LGMDGLD
lgmd_DOT:
	.word   18,22,0,-39
	.long   05348599H
	.word   06000H
	.long   LGMDGLD
lgmd_EXP:
	.word   18,61,0,0
	.long   05348ee1H
	.word   06000H
	.long   LGMDGLD
lgmd_COL:
	.word   18,46,-7,-8
	.long   0534a89dH
	.word   06000H
	.long   LGMDGLD
lgmd_NUM:
	.word   31,37,0,0
	.long   0534bc05H
	.word   06000H
	.long   LGMDGLD
omlgmd_A:
	.word   28,44,0,0
	.long   0534d6e7H
	.word   06000H
	.long   LGMDCHR
omlgmd_B:
	.word   28,44,0,0
	.long   0534f3c7H
	.word   06000H
	.long   LGMDCHR
omlgmd_C:
	.word   20,44,0,0
	.long   053510a7H
	.word   06000H
	.long   LGMDCHR
omlgmd_D:
	.word   28,44,0,0
	.long   05352547H
	.word   06000H
	.long   LGMDCHR
omlgmd_E:
	.word   22,44,0,0
	.long   05354227H
	.word   06000H
	.long   LGMDCHR
omlgmd_F:
	.word   21,44,0,0
	.long   053558d7H
	.word   06000H
	.long   LGMDCHR
omlgmd_G:
	.word   28,44,0,0
	.long   05356e7fH
	.word   06000H
	.long   LGMDCHR
omlgmd_H:
	.word   27,44,0,0
	.long   05358b5fH
	.word   06000H
	.long   LGMDCHR
omlgmd_I:
	.word   14,44,0,0
	.long   0535a737H
	.word   06000H
	.long   LGMDCHR
omlgmd_J:
	.word   20,44,0,0
	.long   0535b5a7H
	.word   06000H
	.long   LGMDCHR
omlgmd_K:
	.word   29,44,0,0
	.long   0535ca47H
	.word   06000H
	.long   LGMDCHR
omlgmd_L:
	.word   21,44,0,0
	.long   0535e82fH
	.word   06000H
	.long   LGMDCHR
omlgmd_M:
	.word   43,44,0,0
	.long   0535fdd7H
	.word   06000H
	.long   LGMDCHR
omlgmd_N:
	.word   29,44,0,0
	.long   05362a2fH
	.word   06000H
	.long   LGMDCHR
omlgmd_O:
	.word   28,44,0,0
	.long   05364817H
	.word   06000H
	.long   LGMDCHR
omlgmd_P:
	.word   27,44,0,0
	.long   053664f7H
	.word   06000H
	.long   LGMDCHR
omlgmd_Q:
	.word   28,52,0,0
	.long   053680cfH
	.word   06000H
	.long   LGMDCHR
omlgmd_R:
	.word   28,44,0,0
	.long   0536a2efH
	.word   06000H
	.long   LGMDCHR
omlgmd_S:
	.word   24,44,0,0
	.long   0536bfcfH
	.word   06000H
	.long   LGMDCHR
omlgmd_T:
	.word   24,44,0,0
	.long   0536d88fH
	.word   06000H
	.long   LGMDCHR
omlgmd_U:
	.word   28,44,0,0
	.long   0536f14fH
	.word   06000H
	.long   LGMDCHR
omlgmd_V:
	.word   29,44,0,0
	.long   05370e2fH
	.word   06000H
	.long   LGMDCHR
omlgmd_W:
	.word   42,44,0,0
	.long   05372c17H
	.word   06000H
	.long   LGMDCHR
omlgmd_X:
	.word   28,44,0,0
	.long   05375767H
	.word   06000H
	.long   LGMDCHR
omlgmd_Y:
	.word   28,44,0,0
	.long   05377447H
	.word   06000H
	.long   LGMDCHR
omlgmd_Z:
	.word   25,44,0,0
	.long   05379127H
	.word   06000H
	.long   LGMDCHR
omlgmd_EXP:
	.word   14,44,0,0
	.long   0537aaefH
	.word   06000H
	.long   LGMDCHR
omlgmd_DOT:
	.word   14,15,0,-29
	.long   0537b95fH
	.word   06000H
	.long   LGMDCHR
scorshad1:
	.word   100,24,0,0
	.long   0537be4bH
	.word   06000H
	.long   METLPALC
scorshad2:
	.word   100,24,0,0
	.long   0537f68bH
	.word   06000H
	.long   METLPALC
ATT_BLU:
	.word   83,36,2,11
	.long   05382ecbH
	.word   03000H
	.long   ATT_B_P
stx_rank:
	.word   54,11,0,0
	.long   053851cfH
	.word   04000H
	.long   SGMD8YEL
stx_pct:
	.word   28,11,0,0
	.long   05385b17H
	.word   04000H
	.long   SGMD8YEL
stx_w:
	.word   24,11,0,0
	.long   05385fe7H
	.word   04000H
	.long   SGMD8YEL
stx_l:
	.word   19,11,0,0
	.long   05386407H
	.word   04000H
	.long   SGMD8YEL
stx_lastmtch:
	.word   85,11,0,0
	.long   0538674bH
	.word   04000H
	.long   SGMD8YEL
stx_defeated:
	.word   60,11,0,0
	.long   053875e7H
	.word   04000H
	.long   SGMD8YEL
stx_lostto:
	.word   53,11,0,0
	.long   05388037H
	.word   04000H
	.long   SGMD8YEL
stx_youhave:
	.word   61,11,0,0
	.long   05388953H
	.word   04000H
	.long   SGMD8YEL
stx_ofthe27:
	.word   66,11,0,0
	.long   053893cfH
	.word   04000H
	.long   SGMD8YEL
stx_nbateams:
	.word   80,13,0,1
	.long   05389f27H
	.word   04000H
	.long   SGMD8YEL
stx_all:
	.word   22,11,0,0
	.long   0538af67H
	.word   04000H
	.long   SGMD8YEL
stx_norecord:
	.word   83,14,41,6
	.long   0538b32fH
	.word   04000H
	.long   SGMD8YEL
stx_record:
	.word   51,11,0,0
	.long   0538c557H
	.word   04000H
	.long   SGMD8YEL
credbox:
	.word   57,11,0,0
	.long   0538ce1bH
	.word   06000H
	.long   METLPGRA
stx_fgs:
	.word   26,9,0,0
	.long   0538dccdH
	.word   04000H
	.long   SGMD8YEL
stx_3pts:
	.word   35,9,0,0
	.long   0538e075H
	.word   04000H
	.long   SGMD8YEL
stx_atline:
	.word   26,9,0,0
	.long   0538e561H
	.word   04000H
	.long   SGMD8YEL
stx_points:
	.word   41,9,0,0
	.long   0538e909H
	.word   04000H
	.long   SGMD8YEL
stx_dunks:
	.word   38,9,0,0
	.long   0538eecdH
	.word   04000H
	.long   SGMD8YEL
stx_ast:
	.word   44,9,0,0
	.long   0538f425H
	.word   04000H
	.long   SGMD8YEL
stx_steals:
	.word   43,9,0,0
	.long   0538fa55H
	.word   04000H
	.long   SGMD8YEL
stx_blocks:
	.word   43,9,0,0
	.long   05390061H
	.word   04000H
	.long   SGMD8YEL
stx_rebs:
	.word   44,9,0,0
	.long   0539066dH
	.word   04000H
	.long   SGMD8YEL
stx_injury:
	.word   46,9,0,0
	.long   05390c9dH
	.word   04000H
	.long   SGMD8YEL
stshad1:
	.word   116,99,0,0
	.long   05391315H
	.word   01000H
	.long   SHADOW
stshad2:
	.word   116,99,0,0
	.long   05393ff1H
	.word   01000H
	.long   SHADOW
SGMD8_A:
	.word   7,9,0,0
	.long   05396ccdH
	.word   04000H
	.long   SGMD8YEL
SGMD8_B:
	.word   7,9,0,0
	.long   05396dc9H
	.word   04000H
	.long   SGMD8BLU
SGMD8_C:
	.word   6,9,0,0
	.long   05396ec5H
	.word   04000H
	.long   SGMD8VIO
SGMD8_D:
	.word   7,9,0,0
	.long   05396f9dH
	.word   04000H
	.long   SGMD8WHT
SGMD8_E:
	.word   6,9,0,0
	.long   05397099H
	.word   04000H
	.long   SGMD8GRY
SGMD8_F:
	.word   6,9,0,0
	.long   05397171H
	.word   04000H
	.long   SGMD8PLV
SGMD8_G:
	.word   7,9,0,0
	.long   05397249H
	.word   04000H
	.long   SGMD8PLR
SGMD8_H:
	.word   7,9,0,0
	.long   05397345H
	.word   04000H
	.long   SGMD8PLB
SGMD8_I:
	.word   3,9,0,0
	.long   05397441H
	.word   04000H
	.long   SGMD8PLY
SGMD8_J:
	.word   6,9,0,0
	.long   053974adH
	.word   04000H
	.long   SGMD8YEL
SGMD8_K:
	.word   7,9,0,0
	.long   05397585H
	.word   04000H
	.long   SGMD8YEL
SGMD8_L:
	.word   6,9,0,0
	.long   05397681H
	.word   04000H
	.long   SGMD8YEL
SGMD8_M:
	.word   11,9,0,0
	.long   05397759H
	.word   04000H
	.long   SGMD8YEL
SGMD8_N:
	.word   7,9,0,0
	.long   053978e5H
	.word   04000H
	.long   SGMD8YEL
SGMD8_O:
	.word   7,9,0,0
	.long   053979e1H
	.word   04000H
	.long   SGMD8YEL
SGMD8_P:
	.word   7,9,0,0
	.long   05397addH
	.word   04000H
	.long   SGMD8YEL
SGMD8_Q:
	.word   7,10,0,0
	.long   05397bd9H
	.word   04000H
	.long   SGMD8YEL
SGMD8_R:
	.word   7,9,0,0
	.long   05397cf1H
	.word   04000H
	.long   SGMD8YEL
SGMD8_S:
	.word   7,9,0,0
	.long   05397dedH
	.word   04000H
	.long   SGMD8YEL
SGMD8_T:
	.word   7,9,0,0
	.long   05397ee9H
	.word   04000H
	.long   SGMD8YEL
SGMD8_U:
	.word   7,9,0,0
	.long   05397fe5H
	.word   04000H
	.long   SGMD8YEL
SGMD8_V:
	.word   7,9,0,0
	.long   053980e1H
	.word   04000H
	.long   SGMD8YEL
SGMD8_W:
	.word   11,9,0,0
	.long   053981ddH
	.word   04000H
	.long   SGMD8YEL
SGMD8_X:
	.word   7,9,0,0
	.long   05398369H
	.word   04000H
	.long   SGMD8YEL
SGMD8_Y:
	.word   7,9,0,0
	.long   05398465H
	.word   04000H
	.long   SGMD8YEL
SGMD8_Z:
	.word   7,9,0,0
	.long   05398561H
	.word   04000H
	.long   SGMD8YEL
SGMD8_0:
	.word   7,9,0,0
	.long   0539865dH
	.word   04000H
	.long   SGMD8YEL
SGMD8_1:
	.word   4,9,0,0
	.long   05398759H
	.word   04000H
	.long   SGMD8YEL
SGMD8_2:
	.word   7,9,0,0
	.long   053987e9H
	.word   04000H
	.long   SGMD8YEL
SGMD8_3:
	.word   7,9,0,0
	.long   053988e5H
	.word   04000H
	.long   SGMD8YEL
SGMD8_4:
	.word   7,9,0,0
	.long   053989e1H
	.word   04000H
	.long   SGMD8YEL
SGMD8_5:
	.word   7,9,0,0
	.long   05398addH
	.word   04000H
	.long   SGMD8YEL
SGMD8_6:
	.word   7,9,0,0
	.long   05398bd9H
	.word   04000H
	.long   SGMD8YEL
SGMD8_7:
	.word   7,9,0,0
	.long   05398cd5H
	.word   04000H
	.long   SGMD8YEL
SGMD8_8:
	.word   7,9,0,0
	.long   05398dd1H
	.word   04000H
	.long   SGMD8YEL
SGMD8_9:
	.word   7,9,0,0
	.long   05398ecdH
	.word   04000H
	.long   SGMD8YEL
SGMD8_DOT:
	.word   3,3,0,-6
	.long   05398fc9H
	.word   04000H
	.long   SGMD8YEL
SGMD8_DAS:
	.word   6,3,0,-3
	.long   05398fedH
	.word   04000H
	.long   SGMD8YEL
SGMD8_EXP:
	.word   3,9,0,0
	.long   05399035H
	.word   04000H
	.long   SGMD8YEL
SGMD8_NUM:
	.word   9,9,0,0
	.long   053990a1H
	.word   04000H
	.long   SGMD8YEL
SGMD8_COM:
	.word   3,5,0,-6
	.long   053991e5H
	.word   04000H
	.long   SGMD8YEL
SGMD8_OBR:
	.word   4,9,0,0
	.long   05399221H
	.word   04000H
	.long   SGMD8YEL
SGMD8_CBR:
	.word   4,9,0,0
	.long   053992b1H
	.word   04000H
	.long   SGMD8YEL
SGMD8_COL:
	.word   3,6,0,-2
	.long   05399341H
	.word   04000H
	.long   SGMD8YEL
SGMD8_AND:
	.word   10,9,0,0
	.long   05399389H
	.word   04000H
	.long   SGMD8YEL
SGMD8_APO:
	.word   3,5,0,0
	.long   053991e5H
	.word   04000H
	.long   SGMD8YEL
SGMD8_SLS:
	.word   7,9,0,0
	.long   053994f1H
	.word   04000H
	.long   SGMD8YEL
SGMD8_PCT:
	.word   7,9,0,0
	.long   053995edH
	.word   04000H
	.long   SGMD8YEL
plyr1:
	.word   61,9,-19,-7
	.long   053996e9H
	.word   04000H
	.long   SGMD8RED
plyr2:
	.word   63,9,-19,-7
	.long   05399f7dH
	.word   04000H
	.long   SGMD8WHT
plyr3:
	.word   63,9,-19,-7
	.long   0539a859H
	.word   04000H
	.long   SGMD8WHT
plyr4:
	.word   63,9,-19,-7
	.long   0539b135H
	.word   04000H
	.long   SGMD8WHT
threepnts:
	.word   54,26,27,0
	.long   0539ba11H
	.word   04000H
	.long   SGMD8WHT
nosecrets:
	.word   73,31,0,0
	.long   0539d001H
	.word   04000H
	.long   SGMD8WHT
osgmd8_A:
	.word   8,11,0,0
	.long   0539f35dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_B:
	.word   8,11,0,0
	.long   0539f4bdH
	.word   04000H
	.long   SGMD8YEL
osgmd8_C:
	.word   7,11,0,0
	.long   0539f61dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_D:
	.word   8,11,0,0
	.long   0539f751H
	.word   04000H
	.long   SGMD8YEL
osgmd8_E:
	.word   7,11,0,0
	.long   0539f8b1H
	.word   04000H
	.long   SGMD8YEL
osgmd8_F:
	.word   7,11,0,0
	.long   0539f9e5H
	.word   04000H
	.long   SGMD8YEL
osgmd8_G:
	.word   8,11,0,0
	.long   0539fb19H
	.word   04000H
	.long   SGMD8YEL
osgmd8_H:
	.word   8,11,0,0
	.long   0539fc79H
	.word   04000H
	.long   SGMD8YEL
osgmd8_I:
	.word   4,11,0,0
	.long   0539fdd9H
	.word   04000H
	.long   SGMD8YEL
osgmd8_J:
	.word   7,11,0,0
	.long   0539fe89H
	.word   04000H
	.long   SGMD8YEL
osgmd8_K:
	.word   8,11,0,0
	.long   0539ffbdH
	.word   04000H
	.long   SGMD8YEL
osgmd8_L:
	.word   7,11,0,0
	.long   053a011dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_M:
	.word   12,11,0,0
	.long   053a0251H
	.word   04000H
	.long   SGMD8YEL
osgmd8_N:
	.word   8,11,0,0
	.long   053a0461H
	.word   04000H
	.long   SGMD8YEL
osgmd8_O:
	.word   8,11,0,0
	.long   053a05c1H
	.word   04000H
	.long   SGMD8YEL
osgmd8_P:
	.word   8,11,0,0
	.long   053a0721H
	.word   04000H
	.long   SGMD8YEL
osgmd8_Q:
	.word   8,12,0,0
	.long   053a0881H
	.word   04000H
	.long   SGMD8YEL
osgmd8_R:
	.word   8,11,0,0
	.long   053a0a01H
	.word   04000H
	.long   SGMD8YEL
osgmd8_S:
	.word   8,11,0,0
	.long   053a0b61H
	.word   04000H
	.long   SGMD8YEL
osgmd8_T:
	.word   8,11,0,0
	.long   053a0cc1H
	.word   04000H
	.long   SGMD8YEL
osgmd8_U:
	.word   8,11,0,0
	.long   053a0e21H
	.word   04000H
	.long   SGMD8YEL
osgmd8_V:
	.word   8,11,0,0
	.long   053a0f81H
	.word   04000H
	.long   SGMD8YEL
osgmd8_W:
	.word   12,11,0,0
	.long   053a10e1H
	.word   04000H
	.long   SGMD8YEL
osgmd8_X:
	.word   8,11,0,0
	.long   053a12f1H
	.word   04000H
	.long   SGMD8YEL
osgmd8_Y:
	.word   8,11,0,0
	.long   053a1451H
	.word   04000H
	.long   SGMD8YEL
osgmd8_Z:
	.word   8,11,0,0
	.long   053a15b1H
	.word   04000H
	.long   SGMD8YEL
osgmd8_0:
	.word   8,11,0,0
	.long   053a1711H
	.word   04000H
	.long   SGMD8YEL
osgmd8_1:
	.word   5,11,0,0
	.long   053a1871H
	.word   04000H
	.long   SGMD8YEL
osgmd8_2:
	.word   8,11,0,0
	.long   053a194dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_3:
	.word   8,11,0,0
	.long   053a1aadH
	.word   04000H
	.long   SGMD8YEL
osgmd8_4:
	.word   8,11,0,0
	.long   053a1c0dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_5:
	.word   8,11,0,0
	.long   053a1d6dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_6:
	.word   8,11,0,0
	.long   053a1ecdH
	.word   04000H
	.long   SGMD8YEL
osgmd8_7:
	.word   8,11,0,0
	.long   053a202dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_8:
	.word   8,11,0,0
	.long   053a218dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_9:
	.word   8,11,0,0
	.long   053a22edH
	.word   04000H
	.long   SGMD8YEL
osgmd8_DOT:
	.word   4,5,0,-6
	.long   053a244dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_DAS:
	.word   7,5,0,-3
	.long   053a249dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_EXP:
	.word   4,11,0,0
	.long   053a2529H
	.word   04000H
	.long   SGMD8YEL
osgmd8_NUM:
	.word   10,11,0,0
	.long   053a25d9H
	.word   04000H
	.long   SGMD8YEL
osgmd8_COM:
	.word   4,7,0,-6
	.long   053a2791H
	.word   04000H
	.long   SGMD8YEL
osgmd8_OBR:
	.word   5,11,0,0
	.long   053a2801H
	.word   04000H
	.long   SGMD8YEL
osgmd8_CBR:
	.word   5,11,0,0
	.long   053a28ddH
	.word   04000H
	.long   SGMD8YEL
osgmd8_COL:
	.word   4,8,0,-2
	.long   053a29b9H
	.word   04000H
	.long   SGMD8YEL
osgmd8_AND:
	.word   11,11,0,0
	.long   053a2a39H
	.word   04000H
	.long   SGMD8YEL
osgmd8_APO:
	.word   4,7,0,0
	.long   053a2791H
	.word   04000H
	.long   SGMD8YEL
osgmd8_SLS:
	.word   9,11,0,0
	.long   053a2c1dH
	.word   04000H
	.long   SGMD8YEL
osgmd8_PCT:
	.word   9,11,0,0
	.long   053a2da9H
	.word   04000H
	.long   SGMD8YEL
getready:
	.word   85,31,42,0
	.long   053a2f35H
	.word   04000H
	.long   SGMD8GLD
_1quart:
	.word   68,33,33,0
	.long   053a5861H
	.word   04000H
	.long   SGMD8GLD
continue:
	.word   85,24,42,11
	.long   053a7b71H
	.word   04000H
	.long   SGMD8GLD
_2quart:
	.word   68,33,33,0
	.long   053a9b51H
	.word   04000H
	.long   SGMD8GLD
_3quart:
	.word   68,33,33,0
	.long   053abe61H
	.word   04000H
	.long   SGMD8GLD
_4quart:
	.word   68,33,33,0
	.long   053ae171H
	.word   04000H
	.long   SGMD8GLD
overtme:
	.word   85,14,42,0
	.long   053b0481H
	.word   04000H
	.long   SGMD8GLD
congrats_l:
	.word   148,24,73,11
	.long   053b1719H
	.word   04000H
	.long   SGMD8GLD
winstay_l:
	.word   143,53,71,26
	.long   053b4e99H
	.word   04000H
	.long   SGMD8GLD
chalneed_l:
	.word   95,53,47,26
	.long   053bc505H
	.word   04000H
	.long   SGMD8GLD
chalacc_l:
	.word   85,53,42,26
	.long   053c13b1H
	.word   04000H
	.long   SGMD8GLD
winfree:
	.word   144,53,71,26
	.long   053c5a15H
	.word   04000H
	.long   SGMD8GLD
TMATE:
	.word   79,31,39,15
	.long   053cd155H
	.word   04000H
	.long   SGMD8GLD
CHALENG:
	.word   86,31,42,15
	.long   053cf799H
	.word   04000H
	.long   SGMD8GLD
osgmd10_A:
	.word   10,13,0,0
	.long   053d2141H
	.word   04000H
	.long   SGMD8GLD
osgmd10_B:
	.word   10,13,0,0
	.long   053d2349H
	.word   04000H
	.long   SGMD8GLD
osgmd10_C:
	.word   9,13,0,0
	.long   053d2551H
	.word   04000H
	.long   SGMD8GLD
osgmd10_D:
	.word   10,13,0,0
	.long   053d2725H
	.word   04000H
	.long   SGMD8GLD
osgmd10_E:
	.word   9,13,0,0
	.long   053d292dH
	.word   04000H
	.long   SGMD8GLD
osgmd10_F:
	.word   9,13,0,0
	.long   053d2b01H
	.word   04000H
	.long   SGMD8GLD
osgmd10_G:
	.word   10,13,0,0
	.long   053d2cd5H
	.word   04000H
	.long   SGMD8GLD
osgmd10_H:
	.word   10,13,0,0
	.long   053d2eddH
	.word   04000H
	.long   SGMD8GLD
osgmd10_I:
	.word   5,13,0,0
	.long   053d30e5H
	.word   04000H
	.long   SGMD8GLD
osgmd10_J:
	.word   9,13,0,0
	.long   053d31e9H
	.word   04000H
	.long   SGMD8GLD
osgmd10_K:
	.word   10,13,0,0
	.long   053d33bdH
	.word   04000H
	.long   SGMD8GLD
osgmd10_L:
	.word   9,13,0,0
	.long   053d35c5H
	.word   04000H
	.long   SGMD8GLD
osgmd10_M:
	.word   15,13,0,0
	.long   053d3799H
	.word   04000H
	.long   SGMD8GLD
osgmd10_N:
	.word   10,13,0,0
	.long   053d3aa5H
	.word   04000H
	.long   SGMD8GLD
osgmd10_O:
	.word   10,13,0,0
	.long   053d3cadH
	.word   04000H
	.long   SGMD8GLD
osgmd10_P:
	.word   10,13,0,0
	.long   053d3eb5H
	.word   04000H
	.long   SGMD8GLD
osgmd10_Q:
	.word   10,15,0,0
	.long   053d40bdH
	.word   04000H
	.long   SGMD8GLD
osgmd10_R:
	.word   10,13,0,0
	.long   053d4315H
	.word   04000H
	.long   SGMD8GLD
osgmd10_S:
	.word   10,13,0,0
	.long   053d451dH
	.word   04000H
	.long   SGMD8GLD
osgmd10_T:
	.word   9,13,0,0
	.long   053d4725H
	.word   04000H
	.long   SGMD8GLD
osgmd10_U:
	.word   10,13,0,0
	.long   053d48f9H
	.word   04000H
	.long   SGMD8GLD
osgmd10_V:
	.word   10,13,0,0
	.long   053d4b01H
	.word   04000H
	.long   SGMD8GLD
osgmd10_W:
	.word   15,13,0,0
	.long   053d4d09H
	.word   04000H
	.long   SGMD8GLD
osgmd10_X:
	.word   10,13,0,0
	.long   053d5015H
	.word   04000H
	.long   SGMD8GLD
osgmd10_Y:
	.word   11,13,0,0
	.long   053d521dH
	.word   04000H
	.long   SGMD8GLD
osgmd10_Z:
	.word   10,13,0,0
	.long   053d5459H
	.word   04000H
	.long   SGMD8GLD
osgmd10_0:
	.word   10,13,0,0
	.long   053d5661H
	.word   04000H
	.long   SGMD8GLD
osgmd10_1:
	.word   6,13,0,0
	.long   053d5869H
	.word   04000H
	.long   SGMD8GLD
osgmd10_2:
	.word   10,13,0,0
	.long   053d59a1H
	.word   04000H
	.long   SGMD8GLD
osgmd10_3:
	.word   10,13,0,0
	.long   053d5ba9H
	.word   04000H
	.long   SGMD8GLD
osgmd10_4:
	.word   12,13,0,0
	.long   053d5db1H
	.word   04000H
	.long   SGMD8GLD
osgmd10_5:
	.word   10,13,0,0
	.long   053d6021H
	.word   04000H
	.long   SGMD8GLD
osgmd10_6:
	.word   10,13,0,0
	.long   053d6229H
	.word   04000H
	.long   SGMD8GLD
osgmd10_7:
	.word   10,13,0,0
	.long   053d6431H
	.word   04000H
	.long   SGMD8GLD
osgmd10_8:
	.word   10,13,0,0
	.long   053d6639H
	.word   04000H
	.long   SGMD8GLD
osgmd10_9:
	.word   10,13,0,0
	.long   053d6841H
	.word   04000H
	.long   SGMD8GLD
osgmd10_PCT:
	.word   14,13,0,0
	.long   053d6a49H
	.word   04000H
	.long   SGMD8GLD
osgmd10_EXP:
	.word   5,13,0,0
	.long   053d6d21H
	.word   04000H
	.long   SGMD8GLD
osgmd10_OBR:
	.word   6,13,0,0
	.long   053d6e25H
	.word   04000H
	.long   SGMD8GLD
osgmd10_CBR:
	.word   6,13,0,0
	.long   053d6f5dH
	.word   04000H
	.long   SGMD8GLD
osgmd10_QUE:
	.word   10,13,0,0
	.long   053d7095H
	.word   04000H
	.long   SGMD8GLD
osgmd10_COM:
	.word   5,7,0,-8
	.long   053d729dH
	.word   04000H
	.long   SGMD8GLD
osgmd10_DOT:
	.word   5,5,0,-8
	.long   053d7329H
	.word   04000H
	.long   SGMD8GLD
osgmd10_COL:
	.word   5,9,0,-2
	.long   053d738dH
	.word   04000H
	.long   SGMD8GLD
osgmd10_DAS:
	.word   8,5,0,-4
	.long   053d7441H
	.word   04000H
	.long   SGMD8GLD
osgmd10_NUM:
	.word   12,13,0,0
	.long   053d74e1H
	.word   04000H
	.long   SGMD8GLD
osgmd10_AND:
	.word   13,13,0,0
	.long   053d7751H
	.word   04000H
	.long   SGMD8GLD
osgmd10_SLS:
	.word   14,13,0,0
	.long   053d79f5H
	.word   04000H
	.long   SGMD8GLD
osgmd10_DOL:
	.word   10,13,0,0
	.long   053d7ccdH
	.word   04000H
	.long   SGMD8GLD
osgmd10_APO:
	.word   5,7,0,0
	.long   053d7ed5H
	.word   04000H
	.long   SGMD8GLD
dronetxt:
	.word   87,71,-7,-16
	.long   053d7f61H
	.word   04000H
	.long   textp
firstwin:
	.word   101,107,0,0
	.long   053ddfe5H
	.word   05000H
	.long   GROWBOXb
colormessage:
	.word   80,22,-10,-45
	.long   053eb2f8H
	.word   04000H
	.long   textp
joycontrol:
	.word   80,14,-10,-17
	.long   053ece78H
	.word   04000H
	.long   textp
red:
	.word   17,6,-40,-69
	.long   053edff8H
	.word   04000H
	.long   textp
blue:
	.word   23,6,-39,-69
	.long   053ee190H
	.word   04000H
	.long   textp
green:
	.word   29,6,-34,-69
	.long   053ee3b8H
	.word   04000H
	.long   textp
yellow:
	.word   37,6,-31,-69
	.long   053ee670H
	.word   04000H
	.long   textp
message1:
	.word   71,29,-15,-22
	.long   053ee9e8H
	.word   04000H
	.long   textp
message2:
	.word   77,30,-12,-10
	.long   053f0a14H
	.word   04000H
	.long   textp
message3:
	.word   64,29,-18,-21
	.long   053f2e2cH
	.word   04000H
	.long   textp
message4:
	.word   89,38,-6,-10
	.long   053f4b2cH
	.word   04000H
	.long   textp
message5:
	.word   86,38,-7,-19
	.long   053f8004H
	.word   04000H
	.long   textp
message6:
	.word   80,30,-10,-22
	.long   053fb314H
	.word   04000H
	.long   textp
message7:
	.word   78,38,-11,-56
	.long   053fd894H
	.word   04000H
	.long   textp
message9:
	.word   85,32,-8,-57
	.long   054006e4H
	.word   04000H
	.long   textp
message2a:
	.word   77,30,-13,-23
	.long   053f0a14H
	.word   04000H
	.long   textp
infobox:
	.word   101,64,0,0
	.long   05403164H
	.word   05000H
	.long   GROWBOXg
infoboxy:
	.word   101,64,0,0
	.long   05403164H
	.word   05000H
	.long   GROWBOXy
infoboxr:
	.word   101,64,0,0
	.long   05403164H
	.word   05000H
	.long   GROWBOXr
TROPHYD1:
	.word   136,201,0,0
	.long   05439563H
	.word   0a80H
	.long   TROPHY_P
CLD1A:
	.word   9,9,4,4
	.long   0545f56bH
	.word   06000H
	.long   GREYPAL
CLDB1:
	.word   12,11,5,5
	.long   0545f751H
	.word   06000H
	.long   BLUBOOM
CLDB1YELL:
	.word   12,11,6,20
	.long   0545f751H
	.word   06000H
	.long   YELLPAL
CLDB1WHT:
	.word   12,11,6,20
	.long   0545f751H
	.word   06000H
	.long   WHTPAL
CLDB1ORNG:
	.word   12,11,6,20
	.long   0545f751H
	.word   06000H
	.long   ORNGPAL
CLDB1LGRY:
	.word   12,11,6,20
	.long   0545f751H
	.word   06000H
	.long   LGRYPAL
CLDB1GRN:
	.word   12,11,6,20
	.long   0545f751H
	.word   06000H
	.long   GRNPAL
CLDB1PURP:
	.word   12,11,6,20
	.long   0545f751H
	.word   06000H
	.long   PURPPAL
CLD2:
	.word   25,29,12,15
	.long   0545fa69H
	.word   06000H
CLD3:
	.word   29,32,15,17
	.long   05460b67H
	.word   06000H
CLD4:
	.word   25,31,13,18
	.long   05462127H
	.word   06000H
CLD4A:
	.word   28,37,14,26
	.long   05463351H
	.word   06000H
CLD4B:
	.word   32,38,17,29
	.long   05464b99H
	.word   06000H
CLD5:
	.word   36,34,17,17
	.long   05466819H
	.word   06000H
CLD6:
	.word   36,36,18,19
	.long   054684c9H
	.word   06000H
CLD7:
	.word   36,36,18,19
	.long   0546a329H
	.word   06000H
CLD8:
	.word   32,32,16,18
	.long   0546c189H
	.word   06000H
CLD9:
	.word   30,29,16,15
	.long   0546d989H
	.word   06000H
CLD10:
	.word   29,30,14,15
	.long   0546ededH
	.word   06000H
CLD11:
	.word   29,30,14,15
	.long   05470251H
	.word   06000H
CLDB2:
	.word   22,22,11,11
	.long   054716b5H
	.word   06000H
CLDB3:
	.word   28,30,13,14
	.long   0547220dH
	.word   06000H
CLDB4:
	.word   32,31,15,15
	.long   054735bdH
	.word   06000H
t_plateV:
	.word   89,71,0,0
	.long   05474cfdH
	.word   06000H
	.long   mtchpal
	.include BGNDTBL.GLO

TSMLOGO:
	.word   120,97,58,48
	.long   0589d2f3H
	.word   00H
	.long   SMLOGO_p
TSMLOGO2:
	.word   120,97,58,62
	.long   0589d2f3H
	.word   00H
	.long   SMLOGO_p
flash1:
	.word   3,3,1,1
	.long   058b3eb3H
	.word   00H
	.long   CROWD_p
flash4:
	.word   22,23,11,11
	.long   058b3efbH
	.word   00H
	.long   CROWD_p
flash3:
	.word   20,19,10,9
	.long   058b4ecbH
	.word   00H
flash3a:
	.word   35,37,17,18
	.long   058b5aabH
	.word   00H
flash5:
	.word   50,44,24,22
	.long   058b8323H
	.word   00H
flash6:
	.word   61,51,30,25
	.long   058bc7e3H
	.word   00H
flash2:
	.word   9,9,4,4
	.long   058c291bH
	.word   00H