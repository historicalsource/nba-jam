	.FILE "imgtbl.asm"
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even

DoubleOT:
	.word   133,11,-78,1
	.long   0835d2eH
	.word   04000H
	.long   BAST_W_P
TripleOT:
	.word   127,11,-78,1
	.long   083740aH
	.word   04000H
	.long   BAST_W_P
endof1:
	.word   151,13,-78,1
	.long   08389deH
	.word   04000H
	.long   BAST_W_P
endof3:
	.word   153,13,-78,1
	.long   083a88aH
	.word   04000H
	.long   BAST_W_P
endof4:
	.word   153,13,-78,1
	.long   083c79eH
	.word   04000H
	.long   BAST_W_P
halftime:
	.word   68,11,-78,1
	.long   083e6b2H
	.word   04000H
	.long   BAST_W_P
please:
	.word   40,19,19,0
	.long   083f262H
	.word   03000H
	.long   BAST_Y_P
start:
	.word   35,19,17,0
	.long   083fb4aH
	.word   03000H
	.long   BAST_Y_P
insert:
	.word   37,19,18,0
	.long   0840315H
	.word   03000H
	.long   BAST_Y_P
tocontrol:
	.word   65,9,32,0
	.long   0840b52H
	.word   03000H
	.long   BAST_Y_P
one:
	.word   92,13,-78,1
	.long   084122dH
	.word   04000H
	.long   BAST_W_P
two:
	.word   95,13,-78,1
	.long   08424ddH
	.word   04000H
	.long   BAST_W_P
three:
	.word   94,13,-78,1
	.long   0843829H
	.word   04000H
	.long   BAST_W_P
four:
	.word   94,13,-78,1
	.long   0844b41H
	.word   04000H
	.long   BAST_W_P
overtime:
	.word   71,11,-78,1
	.long   0845e59H
	.word   04000H
	.long   BAST_W_P
final:
	.word   39,11,-78,1
	.long   0846a8dH
	.word   04000H
	.long   BAST_W_P
HTSTAT01:
	.word   5,212,0,0
	.long   0847141H
	.word   07000H
	.long   MBOX2_P
HTSTAT02:
	.word   4,212,-93,0
	.long   0848e3dH
	.word   07000H
	.long   MBOX2_P
HTSTAT03:
	.word   88,5,-5,0
	.long   084a56dH
	.word   07000H
	.long   MBOX2_P
HTSTAT04:
	.word   88,5,-5,-207
	.long   084b175H
	.word   07000H
	.long   MBOX2_P
HTFIRE01:
	.word   44,100,0,99
	.long   084bd7dH
	.word   06000H
	.long   HTFIRE_P
HTFIRE02:
	.word   44,99,0,98
	.long   085249dH
	.word   06000H
	.long   HTFIRE_P
HTFIRE03:
	.word   44,98,0,97
	.long   0858ab5H
	.word   06000H
	.long   HTFIRE_P
HTFIRE04:
	.word   44,99,0,98
	.long   085efc5H
	.word   06000H
	.long   HTFIRE_P
HTFIRE05:
	.word   44,100,0,99
	.long   08655ddH
	.word   06000H
	.long   HTFIRE_P
HTFIRE06:
	.word   44,99,0,98
	.long   086bcfdH
	.word   06000H
	.long   HTFIRE_P
HTFIRE07:
	.word   44,100,0,99
	.long   0872315H
	.word   06000H
	.long   HTFIRE_P
HTFIRE08:
	.word   44,99,0,98
	.long   0878a35H
	.word   06000H
	.long   HTFIRE_P
HTFIRE09:
	.word   44,101,0,100
	.long   087f04dH
	.word   06000H
	.long   HTFIRE_P
HTFIRE10:
	.word   44,100,0,99
	.long   0885875H
	.word   06000H
	.long   HTFIRE_P
HLFSTATS:
	.word   40,107,0,0
	.long   088bf95H
	.word   04000H
	.long   STAT_W_P
SPOTLTA1:
	.word   80,29,-19,0
	.long   0890275H
	.word   06000H
	.long   SPTA1_P
SPOTLTA2:
	.word   103,37,-7,-29
	.long   08938d5H
	.word   06000H
	.long   SPTA2_P
SPOTLTA3:
	.word   118,39,-2,-66
	.long   0899227H
	.word   06000H
	.long   SPTA3_P
SPOTLTA4:
	.word   122,34,0,-105
	.long   089fe03H
	.word   06000H
	.long   SPTA4_P
SPOTLTA5:
	.word   120,41,0,-139
	.long   08a5f3bH
	.word   06000H
	.long   SPTA5_P
SPOTLTB1:
	.word   85,30,-22,0
	.long   08ad28bH
	.word   06000H
	.long   SPTB1_P
SPOTLTB2:
	.word   106,34,-11,-30
	.long   08b0e4fH
	.word   06000H
	.long   SPTB2_P
SPOTLTB3:
	.word   124,36,-3,-64
	.long   08b62c7H
	.word   06000H
	.long   SPTB3_P
SPOTLTB4:
	.word   128,38,0,-100
	.long   08bcb67H
	.word   06000H
	.long   SPTB4_P
SPOTLTB5:
	.word   128,42,0,-138
	.long   08c3d67H
	.word   05000H
	.long   SPTB5_P
SPOTLTC1:
	.word   86,36,-18,0
	.long   08ca667H
	.word   06000H
	.long   SPTC1_P
SPOTLTC2:
	.word   104,33,-7,-36
	.long   08ceef7H
	.word   06000H
	.long   SPTC2_P
SPOTLTC3:
	.word   118,35,-1,-69
	.long   08d3f67H
	.word   06000H
	.long   SPTC3_P
SPOTLTC4:
	.word   122,35,-1,-104
	.long   08da033H
	.word   06000H
	.long   SPTC4_P
SPOTLTC5:
	.word   123,41,0,-139
	.long   08e0447H
	.word   06000H
	.long   SPTC5_P
BIGBAL1:
	.word   97,91,0,0
	.long   08e7a79H
	.word   00H
	.long   BIGBAL_P
SMBAL1:
	.word   88,82,0,0
	.long   08f8e51H
	.word   00H
	.long   SMBAL_P
SMBALSA1:
	.word   52,99,0,0
	.long   0906fd1H
	.word   07000H
	.long   SMBSA1_P
SMBALSA2:
	.word   53,99,-52,0
	.long   090fc95H
	.word   07000H
	.long   SMBSA2_P
SMBALSB1:
	.word   53,99,0,0
	.long   0918c0eH
	.word   06000H
	.long   SMBSB1_P
SMBALSB2:
	.word   52,99,-53,0
	.long   0920708H
	.word   06000H
	.long   SMBSB2_P
SMBALSC1:
	.word   53,99,0,0
	.long   0927fb0H
	.word   06000H
	.long   SMBSC1_P
SMBALSC2:
	.word   52,100,-53,0
	.long   092faaaH
	.word   07000H
	.long   SMBSC2_P
BGBALSA1:
	.word   54,60,0,-2
	.long   09388daH
	.word   05000H
	.long   BGBSA1_P
BGBALSA2:
	.word   54,62,-54,0
	.long   093c822H
	.word   05000H
	.long   BGBSA2_P
BGBALSB1:
	.word   55,60,0,-2
	.long   0940986H
	.word   05000H
	.long   BGBSB1_P
BGBALSB2:
	.word   53,62,-55,0
	.long   09449faH
	.word   05000H
	.long   BGBSB2_P
BGBALSC1:
	.word   52,60,0,-2
	.long   0948a28H
	.word   05000H
	.long   BGBSC1_P
BGBALSC2:
	.word   56,62,-52,0
	.long   094c718H
	.word   05000H
	.long   BGBSC2_P
TRANBR01:
	.word   414,35,0,0
	.long   0950ae8H
	.word   080H
	.long   TRBR_P_P
TRANBR02:
	.word   414,35,0,0
	.long   096c358H
	.word   080H
	.long   TRBR_P_P
TRANBR03:
	.word   414,35,0,0
	.long   0987be8H
	.word   0f80H
	.long   TRBR_P_P
TRANBR04:
	.word   414,35,0,0
	.long   09a2e50H
	.word   0f80H
	.long   TRBR_P_P
TRANBR05:
	.word   414,35,0,0
	.long   09bdf78H
	.word   0f80H
	.long   TRBR_P_P
TRANBR06:
	.word   414,35,0,0
	.long   09d7ba0H
	.word   0f80H
	.long   TRBR_P_P
TRANBR07:
	.word   414,35,0,0
	.long   09efc88H
	.word   0f80H
	.long   TRBR_P_P
TRANBR08:
	.word   414,35,0,0
	.long   0a069f0H
	.word   0f80H
	.long   TRBR_P_P
TRANBR09:
	.word   414,35,0,0
	.long   0a1ca58H
	.word   0f80H
	.long   TRBR_P_P
TRANBR10:
	.word   414,35,0,0
	.long   0a33e40H
	.word   0f80H
	.long   TRBR_P_P
TRANBR11:
	.word   414,35,0,0
	.long   0a4d2e8H
	.word   0f80H
	.long   TRBR_P_P
TRANBR12:
	.word   414,35,0,0
	.long   0a67d90H
	.word   0f80H
	.long   TRBR_P_P
TRANBR13:
	.word   414,35,0,0
	.long   0a82ff8H
	.word   080H
	.long   TRBR_P_P
TRANBR14:
	.word   414,35,0,0
	.long   0a9e8a0H
	.word   080H
	.long   TRBR_P_P
TRANBR15:
	.word   414,35,0,0
	.long   0aba110H
	.word   0f80H
	.long   TRBR_P_P
BRSH1800:
	.word   18,20,8,0
	.long   0ad5138H
	.word   04000H
	.long   BR18G_P
BRSH1801:
	.word   11,20,5,0
	.long   0ad56d8H
	.word   04000H
	.long   BR18G_P
BRSH1802:
	.word   17,20,8,0
	.long   0ad5a48H
	.word   04000H
	.long   BR18G_P
BRSH1803:
	.word   18,20,8,0
	.long   0ad5f98H
	.word   04000H
	.long   BR18G_P
BRSH1804:
	.word   18,20,9,0
	.long   0ad6538H
	.word   04000H
	.long   BR18G_P
BRSH1805:
	.word   17,20,8,0
	.long   0ad6ad8H
	.word   04000H
	.long   BR18G_P
BRSH1806:
	.word   16,20,7,0
	.long   0ad7028H
	.word   04000H
	.long   BR18G_P
BRSH1807:
	.word   16,20,7,0
	.long   0ad7528H
	.word   04000H
	.long   BR18G_P
BRSH1808:
	.word   17,20,8,0
	.long   0ad7a28H
	.word   04000H
	.long   BR18G_P
BRSH1809:
	.word   16,20,7,0
	.long   0ad7f78H
	.word   04000H
	.long   BR18G_P
BRSH18CO:
	.word   10,18,4,-1
	.long   0ad8478H
	.word   04000H
	.long   BR18G_P
ATT_HT:
	.word   56,12,69,-4
	.long   0ad8748H
	.word   06000H
	.long   ATTBARO_P
ATT_WT:
	.word   56,12,69,-22
	.long   0ad9708H
	.word   06000H
	.long   ATTBARW_P
ATT_SP:
	.word   56,12,69,-40
	.long   0ada6c8H
	.word   06000H
	.long   ATTBARW_P
ATT_PW:
	.word   56,12,69,-58
	.long   0adb688H
	.word   06000H
	.long   ATTBARW_P
ATT_SH:
	.word   56,12,69,-76
	.long   0adc648H
	.word   06000H
	.long   ATTBARW_P
ATT_DU:
	.word   56,12,69,-94
	.long   0add608H
	.word   06000H
	.long   ATTBARW_P
ATT_ST:
	.word   56,12,69,-112
	.long   0ade5c8H
	.word   06000H
	.long   ATTBARW_P
ATT_BL:
	.word   56,12,69,-130
	.long   0adf588H
	.word   06000H
	.long   ATTBARW_P
END_HT:
	.word   82,12,13,-4
	.long   0ae0548H
	.word   06000H
	.long   ATTBARO_P
END_WT:
	.word   82,12,13,-22
	.long   0ae0548H
	.word   06000H
	.long   ATTBARW_P
END_SP:
	.word   82,12,13,-40
	.long   0ae0548H
	.word   06000H
	.long   ATTBARW_P
END_PW:
	.word   82,12,13,-58
	.long   0ae0548H
	.word   06000H
	.long   ATTBARW_P
END_SH:
	.word   82,12,13,-76
	.long   0ae0548H
	.word   06000H
	.long   ATTBARW_P
END_DU:
	.word   82,12,13,-94
	.long   0ae0548H
	.word   06000H
	.long   ATTBARW_P
END_ST:
	.word   82,12,13,-112
	.long   0ae0548H
	.word   06000H
	.long   ATTBARW_P
END_BL:
	.word   82,12,13,-130
	.long   0ae0548H
	.word   06000H
	.long   ATTBARW_P
NOTCH_00:
	.word   8,4,0,0
	.long   0ae1c58H
	.word   03000H
	.long   NOTCH1P
NOTCH_01:
	.word   8,4,0,0
	.long   0ae1cb8H
	.word   03000H
	.long   NOTCH1P
NOTCH_02:
	.word   15,4,0,0
	.long   0ae1d18H
	.word   03000H
	.long   NOTCH1P
NOTCH_03:
	.word   22,4,0,0
	.long   0ae1dccH
	.word   03000H
	.long   NOTCH1P
NOTCH_04:
	.word   29,4,0,0
	.long   0ae1ed4H
	.word   03000H
	.long   NOTCH1P
NOTCH_05:
	.word   36,4,0,0
	.long   0ae2030H
	.word   03000H
	.long   NOTCH1P
NOTCH_06:
	.word   43,4,0,0
	.long   0ae21e0H
	.word   03000H
	.long   NOTCH1P
NOTCH_07:
	.word   50,4,0,0
	.long   0ae23e4H
	.word   03000H
	.long   NOTCH1P
NOTCH_08:
	.word   57,4,0,0
	.long   0ae263cH
	.word   03000H
	.long   NOTCH1P
NOTCH_09:
	.word   64,4,0,0
	.long   0ae28e8H
	.word   03000H
	.long   NOTCH1P
NOTCH_10:
	.word   71,4,0,0
	.long   0ae2be8H
	.word   03000H
	.long   NOTCH1P
NO:
	.word   129,50,0,0
	.long   0ae2f3cH
	.word   06000H
	.long   NOS_P
NOP:
	.word   129,50,0,0
	.long   0ae2f3cH
	.word   06000H
	.long   NOP_P
YES:
	.word   129,50,0,0
	.long   0aec668H
	.word   06000H
	.long   YESS_P
YESP:
	.word   129,50,0,0
	.long   0aec668H
	.word   06000H
	.long   YESP_P
SMNOP:
	.word   73,28,-8,-41
	.long   0af5d94H
	.word   06000H
	.long   NOP_P
SMYESP:
	.word   73,28,-8,-13
	.long   0af8d7cH
	.word   06000H
	.long   YESP_P
SMYES:
	.word   73,28,-8,-13
	.long   0af8d7cH
	.word   06000H
	.long   YESS_P
SMNO:
	.word   73,28,-8,-41
	.long   0af5d94H
	.word   06000H
	.long   NOS_P
SMNSHP:
	.word   76,22,-6,-55
	.long   0afbd64H
	.word   05000H
	.long   SMNSHP_P
SMYSHP:
	.word   77,19,-7,-27
	.long   0afde0cH
	.word   06000H
	.long   SMYSHP_P
ONE:
	.word   124,11,9,20
	.long   0b00056H
	.word   05000H
	.long   BRUSH_G_P
F_NO1:
	.word   43,71,-6,-8
	.long   0b01afaH
	.word   06580H
	.long   F_NO_P
F_NO2:
	.word   50,75,-49,-5
	.long   0b03b80H
	.word   06580H
	.long   F_NO_P
FOG_01:
	.word   74,95,0,0
	.long   0b061f0H
	.word   06000H
	.long   FOG_B_P
FOG_02:
	.word   74,95,0,0
	.long   0b106b4H
	.word   06000H
	.long   FOG_B_P
FOG_03:
	.word   74,95,-1,0
	.long   0b1ab78H
	.word   06000H
	.long   FOG_B_P
FOG_04:
	.word   73,95,-1,0
	.long   0b2503cH
	.word   06000H
	.long   FOG_B_P
FOG_05:
	.word   74,95,0,0
	.long   0b2f2c6H
	.word   06000H
	.long   FOG_B_P
FOG_06:
	.word   73,95,-1,0
	.long   0b3978aH
	.word   06000H
	.long   FOG_B_P
FOG_07:
	.word   73,95,-1,0
	.long   0b43a14H
	.word   06000H
	.long   FOG_B_P
FOG_08:
	.word   73,95,-1,0
	.long   0b4dc9eH
	.word   06000H
	.long   FOG_B_P
FOG_09:
	.word   74,94,0,0
	.long   0b57f28H
	.word   06000H
	.long   FOG_B_P
FOG_10:
	.word   73,94,0,0
	.long   0b62230H
	.word   06000H
	.long   FOG_B_P
FOG_11:
	.word   74,94,0,0
	.long   0b6c304H
	.word   06000H
	.long   FOG_B_P
FOG_12:
	.word   73,95,-1,0
	.long   0b7660cH
	.word   06000H
	.long   FOG_B_P
FOG_13:
	.word   73,95,-1,0
	.long   0b80896H
	.word   06000H
	.long   FOG_B_P
FOG_14:
	.word   71,95,-3,0
	.long   0b8ab20H
	.word   06000H
	.long   FOG_B_P
FOG_15:
	.word   72,95,-2,0
	.long   0b94936H
	.word   06000H
	.long   FOG_B_P
FOG_16:
	.word   74,95,-1,0
	.long   0b9e986H
	.word   06000H
	.long   FOG_B_P
CHECK:
	.word   23,22,0,0
	.long   0ba8e4aH
	.word   05000H
	.long   CHCK_R_P
PRVLGCK1:
	.word   28,16,69,0
	.long   0ba982cH
	.word   07000H
	.long   PRIV_O_P
TEX_HA:
	.word   112,12,41,-2
	.long   0baa46cH
	.word   07000H
	.long   PRIV_W_P
TEX_SD:
	.word   112,12,41,-2
	.long   0bac92cH
	.word   07000H
	.long   PRIV_W_P
TEX_AR:
	.word   112,12,41,-2
	.long   0baedecH
	.word   07000H
	.long   PRIV_W_P
TEX_BD:
	.word   112,12,41,-2
	.long   0bb12acH
	.word   07000H
	.long   PRIV_W_P
TEX_BB:
	.word   112,12,41,-2
	.long   0bb376cH
	.word   07000H
	.long   PRIV_O_P
TEX_ST:
	.word   112,12,41,-2
	.long   0bb5c2cH
	.word   07000H
	.long   PRIV_W_P
TEX_BH:
	.word   112,12,41,-2
	.long   0bb80ecH
	.word   07000H
	.long   PRIV_W_P
HDAROW:
	.word   29,12,0,0
	.long   0bba5acH
	.word   04000H
	.long   HDAROW_P
HDBAR:
	.word   144,17,0,0
	.long   0bbab1cH
	.word   07000H
	.long   TUBEB_P
HDSPTLT:
	.word   144,47,0,0
	.long   0bbee0cH
	.word   06000H
	.long   HDSPT_P
HDSPTLT2:
	.word   144,67,0,0
	.long   0bc8cacH
	.word   07000H
	.long   HDSPT2_P
BIGBOX:
	.word   77,208,0,0
	.long   0bd947cH
	.word   07c80H
	.long   MBOX2_P
TUBE01:
	.word   400,14,0,0
	.long   0bdf66cH
	.word   07000H
	.long   TUBEB_P
TUBE02:
	.word   144,14,0,0
	.long   0be8f8cH
	.word   07000H
	.long   TUBEB_P
TUBE03:
	.word   144,14,0,0
	.long   0bec6acH
	.word   07000H
	.long   TUBEB_P
DITH_A:
	.word   73,99,0,0
	.long   0befdccH
	.word   01000H
	.long   DITH_P
DITH_B:
	.word   73,99,-72,0
	.long   0befdccH
	.word   01000H
	.long   DITH_P
DITH_C:
	.word   73,99,0,-98
	.long   0befdccH
	.word   01000H
	.long   DITH_P
DITH_D:
	.word   73,99,-72,-98
	.long   0befdccH
	.word   01000H
	.long   DITH_P
TIMEPRT:
	.word   83,16,0,0
	.long   0bf1a07H
	.word   06000H
	.long   TIMEPRT_P
CREDTOOB:
	.word   51,9,0,0
	.long   0bf3927H
	.word   07000H
	.long   TUBEB_P
SPOTFL:
	.word   130,45,0,0
	.long   0bf45b4H
	.word   00H
	.long   SPOTFLP
TUBESH:
	.word   12,14,0,0
	.long   0bffc84H
	.word   07000H
	.long   TUBEB_P
BBTXT:
	.word   131,77,0,0
	.long   0c0011cH
	.word   07000H
	.long   BKGRD_P
TOTALBR:
	.word   144,8,0,0
	.long   0c114edH
	.word   07000H
	.long   TUBEB_P
TEXTBAR:
	.word   82,12,0,0
	.long   0c1346dH
	.word   07000H
	.long   TUBE_LB_P
NNABAR:
	.word   18,140,0,0
	.long   0c14f55H
	.word   07000H
	.long   TUBEB_P
NNBAR:
	.word   125,14,0,0
	.long   0c1943dH
	.word   07000H
	.long   TUBEB_P
NNAROW:
	.word   13,44,0,0
	.long   0c1c417H
	.word   04000H
	.long   HDAROW_P
M_HOTSPT:
	.word   85,8,42,3
	.long   0c1cd07H
	.word   06000H
	.long   TUBEB_Y_P
M_NOARRW:
	.word   85,8,42,3
	.long   0c1dcf7H
	.word   06000H
	.long   TUBEB_Y_P
M_BIGHED:
	.word   85,8,42,3
	.long   0c1ece7H
	.word   06000H
	.long   TUBEB_Y_P
M_QIKHND:
	.word   85,8,42,3
	.long   0c1fcd7H
	.word   06000H
	.long   TUBEB_Y_P
M_UNLIMT:
	.word   85,8,42,3
	.long   0c20cc7H
	.word   06000H
	.long   TUBEB_Y_P
M_GOALTN:
	.word   85,8,42,3
	.long   0c21cb7H
	.word   06000H
	.long   TUBEB_Y_P
M_HYPRSP:
	.word   85,8,42,3
	.long   0c22ca7H
	.word   06000H
	.long   TUBEB_Y_P
M_FSTPAS:
	.word   85,8,42,3
	.long   0c23c97H
	.word   06000H
	.long   TUBEB_Y_P
M_MAXSPD:
	.word   85,8,42,3
	.long   0c24c87H
	.word   06000H
	.long   TUBEB_Y_P
M_BIGBAL:
	.word   85,8,42,3
	.long   0c25c77H
	.word   06000H
	.long   TUBEB_Y_P
M_NOPUSH:
	.word   85,8,42,3
	.long   0c26c67H
	.word   06000H
	.long   TUBEB_Y_P
M_MAXPOW:
	.word   85,8,42,3
	.long   0c27c57H
	.word   06000H
	.long   TUBEB_Y_P
M_SHTPCT:
	.word   85,8,42,3
	.long   0c28c47H
	.word   06000H
	.long   TUBEB_Y_P
M_BABYMD:
	.word   85,8,42,3
	.long   0c29c37H
	.word   06000H
	.long   TUBEB_Y_P
M_STELTH:
	.word   85,8,42,3
	.long   0c2ac27H
	.word   06000H
	.long   TUBEB_Y_P
BUTTON_A:
	.word   86,14,43,-5
	.long   0c2bc17H
	.word   05000H
	.long   BUTGRN_P
BUTTON_B:
	.word   86,14,43,-31
	.long   0c2bc17H
	.word   05000H
	.long   BUTGRN_P
BUTTON_C:
	.word   86,14,43,-57
	.long   0c2bc17H
	.word   05000H
	.long   BUTGRN_P
BUTTON_D:
	.word   86,14,43,-83
	.long   0c2bc17H
	.word   05000H
	.long   BUTGRN_P
BUTTON_E:
	.word   86,14,43,-109
	.long   0c2bc17H
	.word   05000H
	.long   BUTGRN_P
BUTTON_F:
	.word   86,14,43,-135
	.long   0c2bc17H
	.word   05000H
	.long   BUTGRN_P
BUTTON_G:
	.word   86,14,43,-161
	.long   0c2bc17H
	.word   05000H
	.long   BUTGRN_P
BUTTON_H:
	.word   86,14,43,-187
	.long   0c2bc17H
	.word   05000H
	.long   BUTGRN_P
BSHAD_A1:
	.word   54,27,52,0
	.long   0c2d39bH
	.word   0980H
	.long   BSHDGRN_P
BSHAD_A2:
	.word   51,26,-2,0
	.long   0c2ec93H
	.word   0680H
	.long   BSHDGRN_P
BSHAD_B1:
	.word   54,26,52,-27
	.long   0c303c3H
	.word   0980H
	.long   BSHDGRN_P
BSHAD_B2:
	.word   51,26,-2,-26
	.long   0c31c23H
	.word   0680H
	.long   BSHDGRN_P
BSHAD_C1:
	.word   54,26,52,-53
	.long   0c333e3H
	.word   0980H
	.long   BSHDGRN_P
BSHAD_C2:
	.word   51,26,-2,-52
	.long   0c34c43H
	.word   0680H
	.long   BSHDGRN_P
BSHAD_D1:
	.word   61,26,52,-78
	.long   0c36403H
	.word   0980H
	.long   BSHDGRN_P
BSHAD_D2:
	.word   44,25,-9,-78
	.long   0c37f53H
	.word   0580H
	.long   BSHDGRN_P
BSHAD_E1:
	.word   58,27,52,-104
	.long   0c3939bH
	.word   0980H
	.long   BSHDGRN_P
BSHAD_E2:
	.word   47,27,-6,-103
	.long   0c3af03H
	.word   0680H
	.long   BSHDGRN_P
BSHAD_F1:
	.word   52,25,52,-131
	.long   0c3c6b3H
	.word   0980H
	.long   BSHDGRN_P
BSHAD_F2:
	.word   53,24,0,-130
	.long   0c3dd0bH
	.word   0680H
	.long   BSHDGRN_P
BSHAD_G1:
	.word   52,26,52,-156
	.long   0c3f28bH
	.word   0980H
	.long   BSHDGRN_P
BSHAD_G2:
	.word   53,26,0,-154
	.long   0c40aabH
	.word   0680H
	.long   BSHDGRN_P
BSHAD_H1:
	.word   52,29,52,-182
	.long   0c4239bH
	.word   0980H
	.long   BSHDGRN_P
BSHAD_H2:
	.word   54,31,0,-180
	.long   0c43d53H
	.word   0680H
	.long   BSHDGRN_P
TXT_VIEW:
	.word   67,9,33,4
	.long   0c45b8bH
	.word   04000H
	.long   BFONTW_P
TXT_HEAD:
	.word   30,11,14,5
	.long   0c464f7H
	.word   04000H
	.long   BFONTW_P
TXT_UNIFRM:
	.word   51,9,25,4
	.long   0c46a1fH
	.word   04000H
	.long   BFONTW_P
TXT_ATTR:
	.word   70,9,34,4
	.long   0c4714bH
	.word   04000H
	.long   BFONTW_P
TXT_NEWN:
	.word   60,9,29,4
	.long   0c47b23H
	.word   04000H
	.long   BFONTW_P
TXT_SAVE:
	.word   64,9,31,4
	.long   0c48393H
	.word   04000H
	.long   BFONTW_P
TXT_PRIV:
	.word   63,9,31,4
	.long   0c48c93H
	.word   04000H
	.long   BFONTW_P
TXT_NICK1:
	.word   62,10,30,4
	.long   0c4956fH
	.word   04000H
	.long   BFONTW_P
TEAMBR:
	.word   82,14,0,0
	.long   0c49f1fH
	.word   07000H
	.long   TUBE_B_P
HEADER:
	.word   201,14,0,0
	.long   0c4be83H
	.word   07000H
	.long   TUBE_B_P
SQUAD1:
	.word   180,65,0,0
	.long   0c50b75H
	.word   06000H
	.long   SQAD_VB_P
SQUAD2:
	.word   180,65,0,0
	.long   0c61dadH
	.word   06000H
	.long   SQAD_VR_P
RHEAD:
	.word   180,65,0,0
	.long   0c72fe5H
	.word   05000H
	.long   HEADW_P
LHEAD:
	.word   180,65,0,0
	.long   0c81469H
	.word   05000H
	.long   HEADW_P
SCORE:
	.word   59,16,0,0
	.long   0c8f8edH
	.word   07000H
	.long   TUBE_V_P
SQDBAL01:
	.word   42,42,-70,-20
	.long   0c912bdH
	.word   06000H
	.long   SQDBAL_P
SQDBAL02:
	.word   42,42,-70,-20
	.long   0c93c15H
	.word   06000H
	.long   SQDBAL_P
SQDBAL03:
	.word   42,42,-70,-20
	.long   0c9656dH
	.word   06000H
	.long   SQDBAL_P
SQDBAL04:
	.word   42,42,-70,-20
	.long   0c98ec5H
	.word   06000H
	.long   SQDBAL_P
SQDBAL05:
	.word   42,42,-70,-20
	.long   0c9b81dH
	.word   06000H
	.long   SQDBAL_P
SQDBAL06:
	.word   42,42,-70,-20
	.long   0c9e175H
	.word   06000H
	.long   SQDBAL_P
SQDBAL07:
	.word   42,42,-70,-20
	.long   0ca0acdH
	.word   06000H
	.long   SQDBAL_P
SQDBAL08:
	.word   42,42,-70,-20
	.long   0ca3425H
	.word   06000H
	.long   SQDBAL_P
SQDBAL09:
	.word   42,42,-70,-20
	.long   0ca5d7dH
	.word   06000H
	.long   SQDBAL_P
SQDBAL10:
	.word   42,42,-70,-20
	.long   0ca86d5H
	.word   06000H
	.long   SQDBAL_P
SQDBAL11:
	.word   42,42,-70,-20
	.long   0cab02dH
	.word   06000H
	.long   SQDBAL_P
SQDBAL12:
	.word   42,42,-70,-20
	.long   0cad985H
	.word   06000H
	.long   SQDBAL_P
SQDBAL13:
	.word   42,42,-70,-20
	.long   0cb02ddH
	.word   06000H
	.long   SQDBAL_P
SQDBAL14:
	.word   42,42,-70,-20
	.long   0cb2c35H
	.word   06000H
	.long   SQDBAL_P
SQDBAL15:
	.word   42,42,-70,-20
	.long   0cb558dH
	.word   06000H
	.long   SQDBAL_P
SQDBAL16:
	.word   42,42,-70,-20
	.long   0cb7ee5H
	.word   06000H
	.long   SQDBAL_P
SQDBAL17:
	.word   42,42,-70,-20
	.long   0cba83dH
	.word   06000H
	.long   SQDBAL_P
SQDBAL18:
	.word   42,42,-70,-20
	.long   0cbd195H
	.word   06000H
	.long   SQDBAL_P
SQDBAL19:
	.word   42,42,-70,-20
	.long   0cbfaedH
	.word   06000H
	.long   SQDBAL_P
SQDBAL20:
	.word   42,42,-70,-20
	.long   0cc2445H
	.word   06000H
	.long   SQDBAL_P
SQDBAL21:
	.word   42,42,-70,-20
	.long   0cc4d9dH
	.word   06000H
	.long   SQDBAL_P
SQDBAL22:
	.word   42,42,-70,-20
	.long   0cc76f5H
	.word   06000H
	.long   SQDBAL_P
SQDBAL23:
	.word   42,42,-70,-20
	.long   0cca04dH
	.word   06000H
	.long   SQDBAL_P
SQDBAL24:
	.word   42,42,-70,-20
	.long   0ccc9a5H
	.word   06000H
	.long   SQDBAL_P
SQDBAL25:
	.word   42,42,-70,-20
	.long   0ccf2fdH
	.word   06000H
	.long   SQDBAL_P
SQDBAL26:
	.word   42,42,-70,-20
	.long   0cd1c55H
	.word   06000H
	.long   SQDBAL_P
SQDBAL27:
	.word   42,42,-70,-20
	.long   0cd45adH
	.word   06000H
	.long   SQDBAL_P
SQDBAL28:
	.word   42,42,-70,-20
	.long   0cd6f05H
	.word   06000H
	.long   SQDBAL_P
SQDBAL29:
	.word   42,42,-70,-20
	.long   0cd985dH
	.word   06000H
	.long   SQDBAL_P
SQDBAL30:
	.word   42,42,-70,-20
	.long   0cdc1b5H
	.word   06000H
	.long   SQDBAL_P
TEAMBR2:
	.word   84,14,41,0
	.long   0cdeb0dH
	.word   07000H
	.long   TUBE_B_P
ATTBAR00:
	.word   46,4,0,0
	.long   0ce0b35H
	.word   04000H
	.long   ATTBAR_P
ATTBAR01:
	.word   46,4,0,0
	.long   0ce0e15H
	.word   04000H
	.long   ATTBAR_P
ATTBAR02:
	.word   46,4,0,0
	.long   0ce10f5H
	.word   04000H
	.long   ATTBAR_P
ATTBAR03:
	.word   46,4,0,0
	.long   0ce13d5H
	.word   04000H
	.long   ATTBAR_P
ATTBAR04:
	.word   46,4,0,0
	.long   0ce16b5H
	.word   04000H
	.long   ATTBAR_P
ATTBAR05:
	.word   46,4,0,0
	.long   0ce1995H
	.word   04000H
	.long   ATTBAR_P
ATTBAR06:
	.word   46,4,0,0
	.long   0ce1c75H
	.word   04000H
	.long   ATTBAR_P
ATTBAR07:
	.word   46,4,0,0
	.long   0ce1f55H
	.word   04000H
	.long   ATTBAR_P
ATTBAR08:
	.word   46,4,0,0
	.long   0ce2235H
	.word   04000H
	.long   ATTBAR_P
ATTBAR09:
	.word   46,4,0,0
	.long   0ce2515H
	.word   04000H
	.long   ATTBAR_P
ATTBAR10:
	.word   46,4,0,0
	.long   0ce27f5H
	.word   04000H
	.long   ATTBAR_P
ATTRIBS:
	.word   36,36,0,0
	.long   0ce2ad5H
	.word   02000H
	.long   ATTRIBSP
NBABAR:
	.word   35,255,0,0
	.long   0ce34f5H
	.word   07000H
	.long   TUBE_B_P
NBALOGO:
	.word   35,64,0,0
	.long   0cf2900H
	.word   00H
	.long   NBALOG_P
JMPBAL_L:
	.word   50,97,34,90
	.long   0cf6f00H
	.word   07000H
	.long   JMPBAL_P
JMPBAL_R:
	.word   50,97,16,90
	.long   0cff39eH
	.word   07000H
	.long   JMPBAL_P
SCORTUBE:
	.word   393,12,0,2
	.long   0d0783cH
	.word   06000H
	.long   NEWPLATPP
LOGOTUBE:
	.word   35,102,-23,75
	.long   0d0e6c4H
	.word   07000H
	.long   NEWPLATPP
RECVRBLK:
	.word   8,80,4,1
	.long   0d14862H
	.word   02000H
	.long   RECBLK_P
clock:
	.word   53,14,-268,3
	.long   0d14d62H
	.word   07000H
	.long   NEWPLATPP
clock2:
	.word   53,14,-268,3
	.long   0d161acH
	.word   07000H
	.long   NEWPLATPP
city_atl:
	.word   49,9,0,0
	.long   0d175f6H
	.word   03000H
	.long   BAST_W_P
city_bos:
	.word   42,9,0,0
	.long   0d17b21H
	.word   03000H
	.long   BAST_W_P
city_cha:
	.word   62,9,0,0
	.long   0d17f8fH
	.word   03000H
city_chi:
	.word   46,9,0,0
	.long   0d18619H
	.word   03000H
city_cle:
	.word   60,9,0,0
	.long   0d18af3H
	.word   03000H
city_dal:
	.word   42,9,0,0
	.long   0d19147H
	.word   03000H
city_den:
	.word   41,9,0,0
	.long   0d195b5H
	.word   03000H
city_det:
	.word   45,9,0,0
	.long   0d19a08H
	.word   03000H
city_gol:
	.word   78,9,0,0
	.long   0d19ec7H
	.word   03000H
city_hou:
	.word   49,9,0,0
	.long   0d1a701H
	.word   03000H
city_ind:
	.word   43,9,0,0
	.long   0d1ac2cH
	.word   03000H
city_lac:
	.word   69,9,0,0
	.long   0d1b0b5H
	.word   03000H
city_lal:
	.word   61,9,0,0
	.long   0d1b7fcH
	.word   03000H
city_mia:
	.word   32,9,0,0
	.long   0d1be6bH
	.word   03000H
city_mil:
	.word   61,9,0,0
	.long   0d1c1cbH
	.word   03000H
city_min:
	.word   60,9,0,0
	.long   0d1c83aH
	.word   03000H
city_nej:
	.word   66,9,0,0
	.long   0d1ce8eH
	.word   03000H
city_ney:
	.word   56,9,0,0
	.long   0d1d584H
	.word   03000H
city_orl:
	.word   49,9,0,0
	.long   0d1db6cH
	.word   03000H
city_phi:
	.word   75,9,0,0
	.long   0d1e097H
	.word   03000H
city_pho:
	.word   44,9,0,0
	.long   0d1e880H
	.word   03000H
city_por:
	.word   56,9,0,0
	.long   0d1ed24H
	.word   03000H
city_sac:
	.word   73,9,0,0
	.long   0d1f30cH
	.word   03000H
city_san:
	.word   73,9,0,0
	.long   0d1fabfH
	.word   03000H
city_sea:
	.word   46,9,0,0
	.long   0d20272H
	.word   03000H
city_tor:
	.word   49,9,0,0
	.long   0d2074cH
	.word   03000H
city_uta:
	.word   28,9,0,0
	.long   0d20c77H
	.word   03000H
city_van:
	.word   63,9,0,0
	.long   0d20f6bH
	.word   03000H
city_was:
	.word   69,9,0,0
	.long   0d21610H
	.word   03000H
DEFAULT:
	.word   79,9,0,0
	.long   0d21d57H
	.word   03000H
CUST1:
	.word   68,9,0,0
	.long   0d225acH
	.word   03000H
CUST2:
	.word   68,9,0,0
	.long   0d22cd8H
	.word   03000H
CUST3:
	.word   68,9,0,0
	.long   0d23404H
	.word   03000H
CUST4:
	.word   68,9,0,0
	.long   0d23b30H
	.word   03000H
CUST5:
	.word   68,9,0,0
	.long   0d2425cH
	.word   03000H
REFWHS1:
	.word   49,110,29,106
	.long   0d24988H
	.word   06000H
	.long   REF_P
	.word   13,33,-3,0
REFWHS2:
	.word   50,110,29,106
	.long   0d2c7dcH
	.word   06000H
	.long   REF_P
	.word   13,33,-3,0
REFWHS3:
	.word   50,111,29,107
	.long   0d348c4H
	.word   06000H
	.long   REF_P
	.word   13,33,-3,0
REFWHS4:
	.word   49,111,29,107
	.long   0d3cad8H
	.word   06000H
	.long   REF_P
	.word   13,32,-3,0
REFWHS5:
	.word   47,112,28,108
	.long   0d44a52H
	.word   06000H
	.long   REF_P
	.word   12,32,-3,0
REFWHS6:
	.word   47,112,28,108
	.long   0d4c5b2H
	.word   06000H
	.long   REF_P
	.word   12,32,-3,0
REFWHS7:
	.word   47,110,28,106
	.long   0d54112H
	.word   06000H
	.long   REF_P
	.word   12,31,-3,0
REFWHS8:
	.word   46,106,29,102
	.long   0d5ba3eH
	.word   06000H
	.long   REF_P
	.word   12,28,-3,0
REFWHS9:
	.word   46,103,30,99
	.long   0d62c86H
	.word   06000H
	.long   REF_P
	.word   12,26,-3,0
REFTOS1:
	.word   52,109,29,105
	.long   0d69b92H
	.word   06000H
	.long   REF_P
	.word   12,34,-3,0
REFTOS2:
	.word   54,109,30,105
	.long   0d7206aH
	.word   06000H
	.long   REF_P
	.word   11,34,-3,0
REFTOS3:
	.word   54,110,29,105
	.long   0d7aa5eH
	.word   06000H
	.long   REF_P
	.word   11,37,3,0
REFTOS4:
	.word   48,113,25,103
	.long   0d83596H
	.word   06000H
	.long   REF_P
	.word   7,39,3,0
REFTOS5:
	.word   45,114,23,101
	.long   0d8b4b6H
	.word   06000H
	.long   REF_P
	.word   5,43,3,0
REFTOS6:
	.word   40,110,18,97
	.long   0d92cf2H
	.word   06000H
	.long   REF_P
	.word   3,51,3,0
REFTOS7:
	.word   37,105,15,92
	.long   0d99412H
	.word   06000H
	.long   REF_P
	.word   2,55,3,0
REFTOS8:
	.word   36,102,14,89
	.long   0d9ef20H
	.word   06000H
	.long   REF_P
	.word   2,56,3,0
REFTOS9:
	.word   37,100,15,87
	.long   0da4530H
	.word   06000H
	.long   REF_P
	.word   3,57,3,0
REFTOS10:
	.word   36,103,14,90
	.long   0da9be8H
	.word   06000H
	.long   REF_P
	.word   3,59,3,0
REFTOS11:
	.word   36,107,14,94
	.long   0daf2d0H
	.word   06000H
	.long   REF_P
	.word   3,55,3,0
REFTOS12:
	.word   36,112,14,99
	.long   0db4d18H
	.word   06000H
	.long   REF_P
	.word   3,42,3,0
REFTOS13:
	.word   36,133,14,120
	.long   0dbab98H
	.word   06000H
	.long   REF_P
	.word   4,-10,3,0
REFTOS14:
	.word   37,140,14,127
	.long   0dc1bd0H
	.word   06000H
	.long   REF_P
	.word   -1,-1,3,0
REFTOS15:
	.word   37,135,14,122
	.long   0dc9538H
	.word   06000H
	.long   REF_P
	.word   -1,-1,3,0
REFTOS16:
	.word   37,123,15,110
	.long   0dd0a4aH
	.word   06000H
	.long   REF_P
	.word   -1,-1,3,0
REFTOS17:
	.word   39,119,17,106
	.long   0dd74f4H
	.word   06000H
	.long   REF_P
	.word   -1,-1,3,0
REFTOS18:
	.word   43,118,20,105
	.long   0dde1baH
	.word   06000H
	.long   REF_P
	.word   -1,-1,3,0
REFTOS19:
	.word   44,117,19,104
	.long   0de58a6H
	.word   06000H
	.long   REF_P
	.word   -1,-1,3,0
REFRUN1:
	.word   45,113,21,103
	.long   0ded14eH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN2:
	.word   46,108,22,103
	.long   0df487cH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN3:
	.word   46,110,22,103
	.long   0dfbcecH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN4:
	.word   45,114,21,103
	.long   0e03384H
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN5:
	.word   45,117,21,104
	.long   0e0abc0H
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN6:
	.word   44,117,20,104
	.long   0e12726H
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN7:
	.word   45,113,22,103
	.long   0e19fceH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN8:
	.word   46,108,24,103
	.long   0e216fcH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN9:
	.word   46,108,24,104
	.long   0e28b6cH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN10:
	.word   45,113,22,104
	.long   0e2ffdcH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFRUN11:
	.word   44,116,20,104
	.long   0e3770aH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFSTN1:
	.word   44,106,19,100
	.long   0e3eeaaH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFSTN2:
	.word   44,103,22,97
	.long   0e45bfaH
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
REFSTN4:
	.word   49,93,24,87
	.long   0e4c632H
	.word   06000H
	.long   REF_P
	.word   -1,-1,-1,0
t0000:
	.word   47,10,0,0
	.long   0e53100H
	.word   05000H
	.long   CREDBAL_P
tX000:
	.word   35,10,-12,0
	.long   0e53a2eH
	.word   05000H
	.long   CREDBAL_P
tXX00:
	.word   23,10,-24,0
	.long   0e54104H
	.word   05000H
	.long   CREDBAL_P
tXXX0:
	.word   11,10,-36,0
	.long   0e54582H
	.word   05000H
	.long   CREDBAL_P
tXXXX:
	.word   44,8,-2,-1
	.long   0e547a8H
	.word   01000H
	.long   JOININ_P
t1000:
	.word   47,10,0,0
	.long   0e54908H
	.word   05000H
	.long   CREDBAL_P
t1100:
	.word   47,10,0,0
	.long   0e55236H
	.word   05000H
	.long   CREDBAL_P
t1110:
	.word   47,10,0,0
	.long   0e55b64H
	.word   05000H
	.long   CREDBAL_P
t1111:
	.word   47,10,0,0
	.long   0e56492H
	.word   05000H
	.long   CREDBAL_P
tX100:
	.word   35,10,-12,0
	.long   0e56dc0H
	.word   05000H
	.long   CREDBAL_P
tX110:
	.word   35,10,-12,0
	.long   0e57496H
	.word   05000H
	.long   CREDBAL_P
tX111:
	.word   35,10,-12,0
	.long   0e57b6cH
	.word   05000H
	.long   CREDBAL_P
tXX10:
	.word   23,10,-24,0
	.long   0e58242H
	.word   05000H
	.long   CREDBAL_P
tXX11:
	.word   23,10,-24,0
	.long   0e586c0H
	.word   05000H
	.long   CREDBAL_P
tXXX1:
	.word   11,10,-36,0
	.long   0e58b3eH
	.word   05000H
	.long   CREDBAL_P
ABDULRAU:
	.word   65,9,32,0
	.long   0e58d64H
	.word   03000H
	.long   BAST_Y_P
AHARDAWAY:
	.word   58,9,28,0
	.long   0e5943fH
	.word   03000H
	.long   BAST_Y_P
AJOHNSON:
	.word   48,9,23,0
	.long   0e59a5dH
	.word   03000H
	.long   BAST_Y_P
WANDERSON:
	.word   56,9,27,0
	.long   0e59f6dH
	.word   03000H
	.long   BAST_Y_P
ANTHONY:
	.word   50,9,24,0
	.long   0e5a555H
	.word   03000H
	.long   BAST_Y_P
AUGMON:
	.word   45,9,22,0
	.long   0e5aa9bH
	.word   03000H
	.long   BAST_Y_P
BAKER:
	.word   37,9,18,0
	.long   0e5af5aH
	.word   03000H
	.long   BAST_Y_P
BARROS:
	.word   43,9,21,0
	.long   0e5b341H
	.word   03000H
	.long   BAST_Y_P
BBARRY:
	.word   36,9,17,0
	.long   0e5b7caH
	.word   03000H
	.long   BAST_Y_P
BENJAMIN:
	.word   53,9,26,0
	.long   0e5bb96H
	.word   03000H
	.long   BAST_Y_P
BENOIT:
	.word   37,9,18,0
	.long   0e5c12dH
	.word   03000H
	.long   BAST_Y_P
BGRANT:
	.word   36,9,17,0
	.long   0e5c514H
	.word   03000H
	.long   BAST_Y_P
BLAYLOCK:
	.word   54,9,26,0
	.long   0e5c8e0H
	.word   03000H
	.long   BAST_Y_P
BOWENS:
	.word   37,9,18,0
	.long   0e5ce92H
	.word   03000H
	.long   BAST_Y_P
BRADLEY:
	.word   48,9,23,0
	.long   0e5d279H
	.word   03000H
	.long   BAST_Y_P
BRANDON:
	.word   51,9,25,0
	.long   0e5d789H
	.word   03000H
	.long   BAST_Y_P
BREEVES:
	.word   39,9,19,0
	.long   0e5dceaH
	.word   03000H
	.long   BAST_Y_P
BROWN:
	.word   38,9,18,0
	.long   0e5e107H
	.word   03000H
	.long   BAST_Y_P
BWILLIAM:
	.word   52,9,25,0
	.long   0e5e509H
	.word   03000H
	.long   BAST_Y_P
CAMPBELL:
	.word   56,9,27,0
	.long   0e5ea85H
	.word   03000H
	.long   BAST_Y_P
CASSELL:
	.word   47,9,23,0
	.long   0e5f06dH
	.word   03000H
	.long   BAST_Y_P
CEBALLOS:
	.word   54,9,26,0
	.long   0e5f562H
	.word   03000H
	.long   BAST_Y_P
CHEANEY:
	.word   48,9,23,0
	.long   0e5fb14H
	.word   03000H
	.long   BAST_Y_P
CHILDRES:
	.word   57,9,28,0
	.long   0e60024H
	.word   03000H
	.long   BAST_Y_P
CMILLS:
	.word   30,9,14,0
	.long   0e60627H
	.word   03000H
	.long   BAST_Y_P
CMORRIS:
	.word   40,9,19,0
	.long   0e60951H
	.word   03000H
	.long   BAST_Y_P
COLEMAN:
	.word   50,9,24,0
	.long   0e60d89H
	.word   03000H
	.long   BAST_Y_P
COLES:
	.word   33,9,16,0
	.long   0e612cfH
	.word   03000H
	.long   BAST_Y_P
CROBINSON:
	.word   52,9,25,0
	.long   0e6164aH
	.word   03000H
	.long   BAST_Y_P
CROGERS:
	.word   41,9,20,0
	.long   0e61bc6H
	.word   03000H
	.long   BAST_Y_P
CURRY:
	.word   36,9,17,0
	.long   0e62019H
	.word   03000H
	.long   BAST_Y_P
DANILOVI:
	.word   54,9,26,0
	.long   0e623e5H
	.word   03000H
	.long   BAST_Y_P
DDAVIS:
	.word   31,9,15,0
	.long   0e62997H
	.word   03000H
	.long   BAST_Y_P
DELLIS:
	.word   28,9,13,0
	.long   0e62cdcH
	.word   03000H
	.long   BAST_Y_P
DELNEGRO:
	.word   56,9,27,0
	.long   0e62fd0H
	.word   03000H
	.long   BAST_Y_P
DIVAC:
	.word   31,9,15,0
	.long   0e635b8H
	.word   03000H
	.long   BAST_Y_P
DOUGLAS:
	.word   49,9,24,0
	.long   0e638fdH
	.word   03000H
	.long   BAST_Y_P
DREXLER:
	.word   47,9,23,0
	.long   0e63e28H
	.word   03000H
	.long   BAST_Y_P
DROBINSON:
	.word   52,9,25,0
	.long   0e6431dH
	.word   03000H
	.long   BAST_Y_P
DSCOTT:
	.word   35,9,17,0
	.long   0e64899H
	.word   03000H
	.long   BAST_Y_P
DUMARS:
	.word   45,9,22,0
	.long   0e64c4aH
	.word   03000H
	.long   BAST_Y_P
EDNEY:
	.word   33,9,16,0
	.long   0e65109H
	.word   03000H
	.long   BAST_Y_P
EDWARDS:
	.word   51,9,25,0
	.long   0e65484H
	.word   03000H
	.long   BAST_Y_P
EJONES:
	.word   33,9,16,0
	.long   0e659e5H
	.word   03000H
	.long   BAST_Y_P
ELLIOT:
	.word   35,9,17,0
	.long   0e65d60H
	.word   03000H
	.long   BAST_Y_P
EMURDOCK:
	.word   52,9,25,0
	.long   0e66111H
	.word   03000H
	.long   BAST_Y_P
EWING:
	.word   33,9,16,0
	.long   0e6668dH
	.word   03000H
	.long   BAST_Y_P
FERRY:
	.word   34,9,16,0
	.long   0e66a08H
	.word   03000H
	.long   BAST_Y_P
FINLEY:
	.word   35,9,17,0
	.long   0e66d9eH
	.word   03000H
	.long   BAST_Y_P
FOX:
	.word   20,9,9,0
	.long   0e6714fH
	.word   03000H
	.long   BAST_Y_P
GARNETT:
	.word   49,9,24,0
	.long   0e6736bH
	.word   03000H
	.long   BAST_Y_P
GATTISON:
	.word   51,9,25,0
	.long   0e67896H
	.word   03000H
	.long   BAST_Y_P
GHILL:
	.word   22,9,10,0
	.long   0e67df7H
	.word   03000H
	.long   BAST_Y_P
GILL:
	.word   22,9,10,0
	.long   0e68049H
	.word   03000H
	.long   BAST_Y_P
GILLIAM:
	.word   42,9,20,0
	.long   0e6829bH
	.word   03000H
	.long   BAST_Y_P
GRANT_HC:
	.word   36,9,17,0
	.long   0e68709H
	.word   03000H
	.long   BAST_Y_P
GROBINSO:
	.word   52,9,25,0
	.long   0e68ad5H
	.word   03000H
	.long   BAST_Y_P
GUGLI:
	.word   54,9,26,0
	.long   0e69051H
	.word   03000H
	.long   BAST_Y_P
HARPER_D:
	.word   43,9,21,0
	.long   0e69603H
	.word   03000H
	.long   BAST_Y_P
HAWKINS:
	.word   50,9,24,0
	.long   0e69a8cH
	.word   03000H
	.long   BAST_Y_P
HENDERSO:
	.word   61,9,30,0
	.long   0e69fd2H
	.word   03000H
	.long   BAST_Y_P
HORNACEK:
	.word   57,9,28,0
	.long   0e6a641H
	.word   03000H
	.long   BAST_Y_P
HORRY:
	.word   35,9,17,0
	.long   0e6ac44H
	.word   03000H
	.long   BAST_Y_P
HOUSTON:
	.word   49,9,24,0
	.long   0e6aff5H
	.word   03000H
	.long   BAST_Y_P
HOWARD:
	.word   45,9,22,0
	.long   0e6b520H
	.word   03000H
	.long   BAST_Y_P
JACK:
	.word   49,9,24,0
	.long   0e6b9dfH
	.word   03000H
	.long   BAST_Y_P
JHOWARD:
	.word   45,9,22,0
	.long   0e6bf0aH
	.word   03000H
	.long   BAST_Y_P
JOHNSN_L:
	.word   48,9,23,0
	.long   0e6c3c9H
	.word   03000H
	.long   BAST_Y_P
JSMITH:
	.word   33,9,16,0
	.long   0e6c8d9H
	.word   03000H
	.long   BAST_Y_P
KANDERSON:
	.word   56,9,27,0
	.long   0e6cc54H
	.word   03000H
	.long   BAST_Y_P
KEDWARDS:
	.word   52,9,25,0
	.long   0e6d23cH
	.word   03000H
	.long   BAST_Y_P
KEMP:
	.word   30,9,14,0
	.long   0e6d7b8H
	.word   03000H
	.long   BAST_Y_P
KERR:
	.word   29,9,14,0
	.long   0e6dae2H
	.word   03000H
	.long   BAST_Y_P
KIDD:
	.word   25,9,12,0
	.long   0e6ddf1H
	.word   03000H
	.long   BAST_Y_P
KJOHNSON:
	.word   48,9,23,0
	.long   0e6e094H
	.word   03000H
	.long   BAST_Y_P
KNORMAN:
	.word   45,9,22,0
	.long   0e6e5a4H
	.word   03000H
	.long   BAST_Y_P
KONCAK:
	.word   44,9,21,0
	.long   0e6ea63H
	.word   03000H
	.long   BAST_Y_P
KUKOC:
	.word   36,9,17,0
	.long   0e6ef07H
	.word   03000H
	.long   BAST_Y_P
LAETTNER:
	.word   55,9,27,0
	.long   0e6f2d3H
	.word   03000H
	.long   BAST_Y_P
LMURRAY:
	.word   44,9,21,0
	.long   0e6f8a0H
	.word   03000H
	.long   BAST_Y_P
LONGLEY:
	.word   45,9,22,0
	.long   0e6fd44H
	.word   03000H
	.long   BAST_Y_P
MALONE_K:
	.word   42,9,20,0
	.long   0e70203H
	.word   03000H
	.long   BAST_Y_P
MANNING:
	.word   48,9,23,0
	.long   0e70671H
	.word   03000H
	.long   BAST_Y_P
MARCIULO:
	.word   74,9,37,0
	.long   0e70b81H
	.word   03000H
	.long   BAST_Y_P
MASH:
	.word   58,9,28,0
	.long   0e7134fH
	.word   03000H
	.long   BAST_Y_P
MASON:
	.word   38,9,18,0
	.long   0e7196dH
	.word   03000H
	.long   BAST_Y_P
MCCLOUD:
	.word   48,9,23,0
	.long   0e71d6fH
	.word   03000H
	.long   BAST_Y_P
MCDYESS:
	.word   49,9,24,0
	.long   0e7227fH
	.word   03000H
	.long   BAST_Y_P
MCKEE:
	.word   35,9,17,0
	.long   0e727aaH
	.word   03000H
	.long   BAST_Y_P
MILLER:
	.word   38,9,18,0
	.long   0e72b5bH
	.word   03000H
	.long   BAST_Y_P
MJACKSON:
	.word   49,9,24,0
	.long   0e72f5dH
	.word   03000H
	.long   BAST_Y_P
MONTROSS:
	.word   58,9,28,0
	.long   0e73488H
	.word   03000H
	.long   BAST_Y_P
MOURN:
	.word   54,9,26,0
	.long   0e73aa6H
	.word   03000H
	.long   BAST_Y_P
MULLIN:
	.word   38,9,18,0
	.long   0e74058H
	.word   03000H
	.long   BAST_Y_P
MURESAN:
	.word   52,9,25,0
	.long   0e7445aH
	.word   03000H
	.long   BAST_Y_P
TMURRAY:
	.word   46,9,22,0
	.long   0e749d6H
	.word   03000H
	.long   BAST_Y_P
MUTUMBO:
	.word   52,9,25,0
	.long   0e74eb0H
	.word   03000H
	.long   BAST_Y_P
NANDERSON:
	.word   56,9,27,0
	.long   0e7542cH
	.word   03000H
	.long   BAST_Y_P
OAKLEY:
	.word   42,9,20,0
	.long   0e75a14H
	.word   03000H
	.long   BAST_Y_P
OBANNON:
	.word   54,9,26,0
	.long   0e75e82H
	.word   03000H
	.long   BAST_Y_P
OLAJUWON:
	.word   58,9,28,0
	.long   0e76434H
	.word   03000H
	.long   BAST_Y_P
OMILLER:
	.word   38,9,18,0
	.long   0e76a52H
	.word   03000H
	.long   BAST_Y_P
PACK:
	.word   29,9,14,0
	.long   0e76e54H
	.word   03000H
	.long   BAST_Y_P
PAYTON:
	.word   40,9,19,0
	.long   0e77163H
	.word   03000H
	.long   BAST_Y_P
PERSON:
	.word   41,9,20,0
	.long   0e7759bH
	.word   03000H
	.long   BAST_Y_P
PHILLS:
	.word   35,9,17,0
	.long   0e779eeH
	.word   03000H
	.long   BAST_Y_P
PIPPEN:
	.word   38,9,19,0
	.long   0e77d9fH
	.word   03000H
	.long   BAST_Y_P
PJONES:
	.word   33,9,16,0
	.long   0e781a1H
	.word   03000H
	.long   BAST_Y_P
PRICHARD:
	.word   67,9,33,0
	.long   0e7851cH
	.word   03000H
	.long   BAST_Y_P
RADJA:
	.word   36,9,17,0
	.long   0e78c2dH
	.word   03000H
	.long   BAST_Y_P
RESPERT:
	.word   47,9,23,0
	.long   0e78ff9H
	.word   03000H
	.long   BAST_Y_P
RICE:
	.word   23,9,11,0
	.long   0e794eeH
	.word   03000H
	.long   BAST_Y_P
RICH:
	.word   54,9,26,0
	.long   0e7975bH
	.word   03000H
	.long   BAST_Y_P
RIDER:
	.word   31,9,15,0
	.long   0e79d0dH
	.word   03000H
	.long   BAST_Y_P
RODMAN:
	.word   45,9,22,0
	.long   0e7a052H
	.word   03000H
	.long   BAST_Y_P
ROOKS:
	.word   35,9,17,0
	.long   0e7a511H
	.word   03000H
	.long   BAST_Y_P
ROSE:
	.word   27,9,13,0
	.long   0e7a8c2H
	.word   03000H
	.long   BAST_Y_P
RROGERS:
	.word   41,9,20,0
	.long   0e7ab9bH
	.word   03000H
	.long   BAST_Y_P
SABONIS:
	.word   46,9,22,0
	.long   0e7afeeH
	.word   03000H
	.long   BAST_Y_P
SCHREMPF:
	.word   57,9,28,0
	.long   0e7b4c8H
	.word   03000H
	.long   BAST_Y_P
SEIKALY:
	.word   43,9,21,0
	.long   0e7bacbH
	.word   03000H
	.long   BAST_Y_P
SFORD:
	.word   27,9,13,0
	.long   0e7bf54H
	.word   03000H
	.long   BAST_Y_P
SMITH:
	.word   33,9,16,0
	.long   0e7c22dH
	.word   03000H
	.long   BAST_Y_P
SMITS:
	.word   33,9,16,0
	.long   0e7c5a8H
	.word   03000H
	.long   BAST_Y_P
SPREWELL:
	.word   55,9,27,0
	.long   0e7c923H
	.word   03000H
	.long   BAST_Y_P
SSMITH:
	.word   33,9,16,0
	.long   0e7cef0H
	.word   03000H
	.long   BAST_Y_P
STACKHOU:
	.word   70,9,34,0
	.long   0e7d26bH
	.word   03000H
	.long   BAST_Y_P
STARKS:
	.word   41,9,20,0
	.long   0e7d9cdH
	.word   03000H
	.long   BAST_Y_P
STOCKTON:
	.word   56,9,27,0
	.long   0e7de20H
	.word   03000H
	.long   BAST_Y_P
STOUDAMI:
	.word   68,9,33,0
	.long   0e7e408H
	.word   03000H
	.long   BAST_Y_P
STRICKLA:
	.word   67,9,33,0
	.long   0e7eb34H
	.word   03000H
	.long   BAST_Y_P
THARDAWAY:
	.word   58,9,28,0
	.long   0e7f245H
	.word   03000H
	.long   BAST_Y_P
THILL:
	.word   22,9,10,0
	.long   0e7f863H
	.word   03000H
	.long   BAST_Y_P
THORPE:
	.word   41,9,20,0
	.long   0e7fab5H
	.word   03000H
	.long   BAST_Y_P
TISDALE:
	.word   44,9,21,0
	.long   0e7ff08H
	.word   03000H
	.long   BAST_Y_P
TMILLS:
	.word   30,9,14,0
	.long   0e803acH
	.word   03000H
	.long   BAST_Y_P
VANEXEL:
	.word   49,9,24,0
	.long   0e806d6H
	.word   03000H
	.long   BAST_Y_P
VAUGHT:
	.word   42,9,20,0
	.long   0e80c01H
	.word   03000H
	.long   BAST_Y_P
VMAXWELL:
	.word   52,9,25,0
	.long   0e8106fH
	.word   03000H
	.long   BAST_Y_P
WEATH:
	.word   85,9,42,0
	.long   0e815ebH
	.word   03000H
	.long   BAST_Y_P
WEBBER:
	.word   44,9,21,0
	.long   0e81ee2H
	.word   03000H
	.long   BAST_Y_P
WILLIS:
	.word   35,9,17,0
	.long   0e82386H
	.word   03000H
	.long   BAST_Y_P
WPERSON:
	.word   41,9,20,0
	.long   0e82737H
	.word   03000H
	.long   BAST_Y_P
WRIGHT:
	.word   41,9,20,0
	.long   0e82b8aH
	.word   03000H
	.long   BAST_Y_P
WWILLIAM:
	.word   52,9,25,0
	.long   0e82fddH
	.word   03000H
	.long   BAST_Y_P
ZIDEK:
	.word   30,9,14,0
	.long   0e83559H
	.word   03000H
	.long   BAST_Y_P
DIVITA:
	.word   36,9,17,0
	.long   0e83883H
	.word   03000H
	.long   BAST_Y_P
spark2:
	.word   3,4,0,0
	.long   0e83c4fH
	.word   05000H
	.long   spark_p
spark3:
	.word   4,4,0,0
	.long   0e83c8bH
	.word   05000H
	.long   spark_p
spark4:
	.word   4,4,0,0
	.long   0e83cdbH
	.word   03000H
	.long   spark_p
spark5:
	.word   4,3,0,0
	.long   0e83d0bH
	.word   03000H
	.long   spark_p
spark1:
	.word   4,5,0,0
	.long   0e83d2fH
	.word   05000H
	.long   spark_p
PRESSBUTT:
	.word   186,11,92,5
	.long   0e83d93H
	.word   04000H
	.long   PRESS_P
PRESSTURB:
	.word   172,11,85,5
	.long   0e85d8bH
	.word   04000H
	.long   PRESS_P
TopTenred:
	.word   88,49,0,0
	.long   0e87b1bH
	.word   06000H
	.long   PLAT_R_P
TopTengrn:
	.word   88,49,0,0
	.long   0e8e02bH
	.word   06000H
	.long   PLAT_G_P
TopTenblu:
	.word   88,49,0,0
	.long   0e9453bH
	.word   06000H
	.long   PLAT_B_P
TopTenyel:
	.word   88,49,0,0
	.long   0e9aa4bH
	.word   06000H
	.long   PLAT_Y_P
start3:
	.word   46,25,22,12
	.long   0ea0f5bH
	.word   04000H
	.long   BAST_Y_P
insert3:
	.word   54,26,26,12
	.long   0ea2153H
	.word   04000H
	.long   BAST_Y_P
freplay3:
	.word   75,11,37,5
	.long   0ea3743H
	.word   04000H
	.long   BAST_Y_P
join3:
	.word   51,11,25,5
	.long   0ea4427H
	.word   04000H
	.long   BAST_Y_P
start2:
	.word   40,19,19,0
	.long   0ea4cebH
	.word   03000H
	.long   BAST_Y_P
insert2:
	.word   43,19,21,0
	.long   0ea55d3H
	.word   03000H
	.long   BAST_Y_P
freeplay:
	.word   66,9,32,-4
	.long   0ea5f66H
	.word   03000H
	.long   BAST_Y_P
FulGamered:
	.word   88,49,0,0
	.long   0ea665cH
	.word   06000H
	.long   PLAT_R_P
FulGameblu:
	.word   88,49,0,0
	.long   0eacb6cH
	.word   06000H
	.long   PLAT_B_P
FulGamegrn:
	.word   88,49,0,0
	.long   0eb307cH
	.word   06000H
	.long   PLAT_G_P
FulGameyel:
	.word   88,49,0,0
	.long   0eb958cH
	.word   06000H
	.long   PLAT_Y_P
onePlblu:
	.word   88,49,0,0
	.long   0ebfa9cH
	.word   06000H
	.long   PLAT_B_P
onePlgrn:
	.word   88,49,0,0
	.long   0ec5facH
	.word   06000H
	.long   PLAT_G_P
onePlyel:
	.word   88,49,0,0
	.long   0ecc4bcH
	.word   06000H
	.long   PLAT_Y_P
onePlred:
	.word   88,49,0,0
	.long   0ed29ccH
	.word   06000H
	.long   PLAT_R_P
Customblu:
	.word   88,49,0,0
	.long   0ed8edcH
	.word   06000H
	.long   PLAT_B_P
Customgrn:
	.word   88,49,0,0
	.long   0edf3ecH
	.word   06000H
	.long   PLAT_G_P
Customyel:
	.word   88,49,0,0
	.long   0ee58fcH
	.word   06000H
	.long   PLAT_Y_P
Customred:
	.word   88,49,0,0
	.long   0eebe0cH
	.word   06000H
	.long   PLAT_R_P
TopFivblu:
	.word   88,49,0,0
	.long   0ef231cH
	.word   06000H
	.long   PLAT_B_P
TopFivgrn:
	.word   88,49,0,0
	.long   0ef882cH
	.word   06000H
	.long   PLAT_G_P
TopFivyel:
	.word   88,49,0,0
	.long   0efed3cH
	.word   06000H
	.long   PLAT_Y_P
TopFivred:
	.word   88,49,0,0
	.long   0f0524cH
	.word   06000H
	.long   PLAT_R_P
TournDblu:
	.word   88,49,0,0
	.long   0f0b75cH
	.word   06000H
	.long   PLAT_B_P
TournDgrn:
	.word   88,49,0,0
	.long   0f11c6cH
	.word   06000H
	.long   PLAT_G_P
TournDyel:
	.word   88,49,0,0
	.long   0f1817cH
	.word   06000H
	.long   PLAT_Y_P
TournDred:
	.word   88,49,0,0
	.long   0f1e68cH
	.word   06000H
	.long   PLAT_R_P
TurnNSblu:
	.word   88,49,0,0
	.long   0f24b9cH
	.word   06000H
	.long   PLAT_B_P
TurnNSgrn:
	.word   88,49,0,0
	.long   0f2b0acH
	.word   06000H
	.long   PLAT_G_P
TurnNSyel:
	.word   88,49,0,0
	.long   0f315bcH
	.word   06000H
	.long   PLAT_Y_P
TurnNSred:
	.word   88,49,0,0
	.long   0f37accH
	.word   06000H
	.long   PLAT_R_P
WorldRblu:
	.word   88,49,0,0
	.long   0f3dfdcH
	.word   06000H
	.long   PLAT_B_P
WorldRgrn:
	.word   88,49,0,0
	.long   0f444ecH
	.word   06000H
	.long   PLAT_G_P
WorldRyel:
	.word   88,49,0,0
	.long   0f4a9fcH
	.word   06000H
	.long   PLAT_Y_P
WorldRred:
	.word   88,49,0,0
	.long   0f50f0cH
	.word   06000H
	.long   PLAT_R_P
Top10Dblu:
	.word   88,49,0,0
	.long   0f5741cH
	.word   06000H
	.long   PLAT_B_P
Top10Dgrn:
	.word   88,49,0,0
	.long   0f5d92cH
	.word   06000H
	.long   PLAT_G_P
Top10Dyel:
	.word   88,49,0,0
	.long   0f63e3cH
	.word   06000H
	.long   PLAT_Y_P
Top10Dred:
	.word   88,49,0,0
	.long   0f6a34cH
	.word   06000H
	.long   PLAT_R_P
BstDfPlblu:
	.word   88,49,0,0
	.long   0f7085cH
	.word   06000H
	.long   PLAT_B_P
BstDfPlgrn:
	.word   88,49,0,0
	.long   0f76d6cH
	.word   06000H
	.long   PLAT_G_P
BstDfPlyel:
	.word   88,49,0,0
	.long   0f7d27cH
	.word   06000H
	.long   PLAT_Y_P
BstDfPlred:
	.word   88,49,0,0
	.long   0f8378cH
	.word   06000H
	.long   PLAT_R_P
BstOfPlblu:
	.word   88,49,0,0
	.long   0f89c9cH
	.word   06000H
	.long   PLAT_B_P
BstOfPlgrn:
	.word   88,49,0,0
	.long   0f901acH
	.word   06000H
	.long   PLAT_G_P
BstOfPlyel:
	.word   88,49,0,0
	.long   0f966bcH
	.word   06000H
	.long   PLAT_Y_P
BstOfPlred:
	.word   88,49,0,0
	.long   0f9cbccH
	.word   06000H
	.long   PLAT_R_P
Top5DPblu:
	.word   88,49,0,0
	.long   0fa30dcH
	.word   06000H
	.long   PLAT_B_P
Top5DPgrn:
	.word   88,49,0,0
	.long   0fa95ecH
	.word   06000H
	.long   PLAT_G_P
Top5DPyel:
	.word   88,49,0,0
	.long   0fafafcH
	.word   06000H
	.long   PLAT_Y_P
Top5DPred:
	.word   88,49,0,0
	.long   0fb600cH
	.word   06000H
	.long   PLAT_R_P
Top5OPblu:
	.word   88,49,0,0
	.long   0fbc51cH
	.word   06000H
	.long   PLAT_B_P
Top5OPgrn:
	.word   88,49,0,0
	.long   0fc2a2cH
	.word   06000H
	.long   PLAT_G_P
Top5OPyel:
	.word   88,49,0,0
	.long   0fc8f3cH
	.word   06000H
	.long   PLAT_Y_P
Top5OPred:
	.word   88,49,0,0
	.long   0fcf44cH
	.word   06000H
	.long   PLAT_R_P
Top10Oblu:
	.word   88,49,0,0
	.long   0fd595cH
	.word   06000H
	.long   PLAT_B_P
Top10Ogrn:
	.word   88,49,0,0
	.long   0fdbe6cH
	.word   06000H
	.long   PLAT_G_P
Top10Oyel:
	.word   88,49,0,0
	.long   0fe237cH
	.word   06000H
	.long   PLAT_Y_P
Top10Ored:
	.word   88,49,0,0
	.long   0fe888cH
	.word   06000H
	.long   PLAT_R_P
CORECTblu:
	.word   88,49,0,0
	.long   0feed9cH
	.word   06000H
	.long   PLAT_B_P
CORECTgrn:
	.word   88,49,0,0
	.long   0ff52acH
	.word   06000H
	.long   PLAT_G_P
CORECTyel:
	.word   88,49,0,0
	.long   0ffb7bcH
	.word   06000H
	.long   PLAT_Y_P
CORECTred:
	.word   88,49,0,0
	.long   01001cccH
	.word   06000H
	.long   PLAT_R_P
INCRECTblu:
	.word   88,49,0,0
	.long   010081dcH
	.word   06000H
	.long   PLAT_B_P
INCRECTgrn:
	.word   88,49,0,0
	.long   0100e6ecH
	.word   06000H
	.long   PLAT_G_P
INCRECTyel:
	.word   88,49,0,0
	.long   01014bfcH
	.word   06000H
	.long   PLAT_Y_P
INCRECTred:
	.word   88,49,0,0
	.long   0101b10cH
	.word   06000H
	.long   PLAT_R_P
InvaldNMblu:
	.word   88,49,0,0
	.long   0102161cH
	.word   06000H
	.long   PLAT_B_P
InvaldNMgrn:
	.word   88,49,0,0
	.long   01027b2cH
	.word   06000H
	.long   PLAT_G_P
InvaldNMyel:
	.word   88,49,0,0
	.long   0102e03cH
	.word   06000H
	.long   PLAT_Y_P
InvaldNMred:
	.word   88,49,0,0
	.long   0103454cH
	.word   06000H
	.long   PLAT_R_P
TRIVIA1:
	.word   94,14,93,0
	.long   0103aa5cH
	.word   06000H
	.long   PLAT_B_P
TRIVIA2:
	.word   79,14,78,0
	.long   0103c934H
	.word   06000H
	.long   PLAT_G_P
TRIVIA3:
	.word   61,14,60,0
	.long   0103e320H
	.word   06000H
	.long   PLAT_Y_P
TRIVIA4:
	.word   43,14,42,0
	.long   0103f724H
	.word   06000H
	.long   PLAT_R_P
QUALIFYblu:
	.word   88,49,0,0
	.long   01040540H
	.word   06000H
	.long   PLAT_B_P
QUALIFYgrn:
	.word   88,49,0,0
	.long   01046a50H
	.word   06000H
	.long   PLAT_G_P
QUALIFYyel:
	.word   88,49,0,0
	.long   0104cf60H
	.word   06000H
	.long   PLAT_Y_P
QUALIFYred:
	.word   88,49,0,0
	.long   01053470H
	.word   06000H
	.long   PLAT_R_P
GrtWnSblu:
	.word   88,49,0,0
	.long   01059980H
	.word   06000H
	.long   PLAT_B_P
GrtWnSgrn:
	.word   88,49,0,0
	.long   0105fe90H
	.word   06000H
	.long   PLAT_G_P
GrtWnSyel:
	.word   88,49,0,0
	.long   010663a0H
	.word   06000H
	.long   PLAT_Y_P
GrtWnSred:
	.word   88,49,0,0
	.long   0106c8b0H
	.word   06000H
	.long   PLAT_R_P
NbaChpblu:
	.word   88,49,0,0
	.long   01072dc0H
	.word   06000H
	.long   PLAT_B_P
NbaChpgrn:
	.word   88,49,0,0
	.long   010792d0H
	.word   06000H
	.long   PLAT_G_P
NbaChpyel:
	.word   88,49,0,0
	.long   0107f7e0H
	.word   06000H
	.long   PLAT_Y_P
NbaChpred:
	.word   88,49,0,0
	.long   01085cf0H
	.word   06000H
	.long   PLAT_R_P
PRESSPASS:
	.word   172,11,85,5
	.long   0108c200H
	.word   04000H
	.long   PRESS2_P
INGA16_A:
	.word   11,18,0,0
	.long   0108df90H
	.word   05000H
	.long   INGA_B_P
INGA16_B:
	.word   11,18,0,0
	.long   0108e36eH
	.word   05000H
	.long   INGA_G_P
INGA16_C:
	.word   11,18,0,0
	.long   0108e74cH
	.word   05000H
	.long   INGA_O_P
INGA16_D:
	.word   11,18,0,0
	.long   0108eb2aH
	.word   05000H
	.long   INGA_P_P
INGA16_E:
	.word   8,18,0,0
	.long   0108ef08H
	.word   05000H
	.long   INGA_Y_P
INGA16_F:
	.word   8,18,0,0
	.long   0108f1d8H
	.word   05000H
	.long   INGA_WDP
INGA16_G:
	.word   11,18,0,0
	.long   0108f4a8H
	.word   05000H
	.long   INGA_W_P
INGA16_H:
	.word   11,18,0,0
	.long   0108f886H
	.word   05000H
	.long   INGA_W_P
INGA16_I:
	.word   5,18,0,0
	.long   0108fc64H
	.word   05000H
	.long   INGA_W_P
INGA16_J:
	.word   7,18,0,0
	.long   0108fe26H
	.word   05000H
	.long   INGA_W_P
INGA16_K:
	.word   12,18,0,0
	.long   0109009cH
	.word   05000H
	.long   INGA_W_P
INGA16_L:
	.word   8,18,0,0
	.long   010904d4H
	.word   05000H
	.long   INGA_W_P
INGA16_M:
	.word   16,18,0,0
	.long   010907a4H
	.word   05000H
	.long   INGA_W_P
INGA16_N:
	.word   12,18,0,0
	.long   01090d44H
	.word   05000H
	.long   INGA_W_P
INGA16_O:
	.word   11,18,0,0
	.long   0109117cH
	.word   05000H
	.long   INGA_W_P
INGA16_P:
	.word   11,18,0,0
	.long   0109155aH
	.word   05000H
	.long   INGA_W_P
INGA16_Q:
	.word   11,20,0,0
	.long   01091938H
	.word   05000H
	.long   INGA_W_P
INGA16_R:
	.word   11,18,0,0
	.long   01091d84H
	.word   05000H
	.long   INGA_W_P
INGA16_S:
	.word   11,18,0,0
	.long   01092162H
	.word   05000H
	.long   INGA_W_P
INGA16_T:
	.word   11,18,0,0
	.long   01092540H
	.word   05000H
	.long   INGA_W_P
INGA16_U:
	.word   11,18,0,0
	.long   0109291eH
	.word   05000H
	.long   INGA_W_P
INGA16_V:
	.word   14,18,0,0
	.long   01092cfcH
	.word   05000H
	.long   INGA_W_P
INGA16_W:
	.word   18,18,0,0
	.long   010931e8H
	.word   05000H
	.long   INGA_W_P
INGA16_X:
	.word   12,18,0,0
	.long   0109383cH
	.word   05000H
	.long   INGA_W_P
INGA16_Y:
	.word   11,18,0,0
	.long   01093c74H
	.word   05000H
	.long   INGA_W_P
INGA16_Z:
	.word   9,18,0,0
	.long   01094052H
	.word   05000H
	.long   INGA_W_P
INGA16_1:
	.word   8,18,0,0
	.long   0109437cH
	.word   05000H
	.long   INGA_W_P
INGA16_2:
	.word   11,18,0,0
	.long   0109464cH
	.word   05000H
	.long   INGA_W_P
INGA16_3:
	.word   11,18,0,0
	.long   01094a2aH
	.word   05000H
	.long   INGA_W_P
INGA16_4:
	.word   12,18,0,0
	.long   01094e08H
	.word   05000H
	.long   INGA_W_P
INGA16_5:
	.word   11,18,0,0
	.long   01095240H
	.word   05000H
	.long   INGA_W_P
INGA16_6:
	.word   11,18,0,0
	.long   0109561eH
	.word   05000H
	.long   INGA_W_P
INGA16_7:
	.word   10,18,0,0
	.long   010959fcH
	.word   05000H
	.long   INGA_W_P
INGA16_8:
	.word   11,18,0,0
	.long   01095d80H
	.word   05000H
	.long   INGA_W_P
INGA16_9:
	.word   11,18,0,0
	.long   0109615eH
	.word   05000H
	.long   INGA_W_P
INGA16_0:
	.word   11,18,0,0
	.long   0109653cH
	.word   05000H
	.long   INGA_W_P
INGA16DEL:
	.word   12,18,0,0
	.long   0109691aH
	.word   05000H
	.long   INGA_W_P
INGA16SPC:
	.word   12,18,0,0
	.long   01096d52H
	.word   05000H
	.long   INGA_W_P
INGA16END:
	.word   13,18,0,0
	.long   0109718aH
	.word   05000H
	.long   INGA_W_P
INGA16COM:
	.word   5,7,0,-12
	.long   0109761cH
	.word   05000H
	.long   INGA_W_P
INGA16PER:
	.word   5,5,0,-13
	.long   010976cbH
	.word   05000H
	.long   INGA_W_P
INGA16SLS:
	.word   7,18,0,0
	.long   01097748H
	.word   05000H
	.long   INGA_W_P
INGA16QUE:
	.word   11,18,0,0
	.long   010979beH
	.word   05000H
	.long   INGA_W_P
INGA16COL:
	.word   5,12,0,-4
	.long   01097d9cH
	.word   05000H
	.long   INGA_W_P
INGA16EXC:
	.word   5,18,0,0
	.long   01097ec8H
	.word   05000H
	.long   INGA_W_P
INGA16NUM:
	.word   11,12,0,-4
	.long   0109808aH
	.word   05000H
	.long   INGA_W_P
INGA16DOL:
	.word   11,20,0,0
	.long   0109831eH
	.word   05000H
	.long   INGA_W_P
INGA16PCT:
	.word   15,18,0,0
	.long   0109876aH
	.word   05000H
	.long   INGA_W_P
INGA16AND:
	.word   13,17,0,-1
	.long   01098cb0H
	.word   05000H
	.long   INGA_W_P
INGA16AST:
	.word   9,10,0,-5
	.long   01099101H
	.word   05000H
	.long   INGA_W_P
INGA16PRL:
	.word   6,18,0,0
	.long   010992c3H
	.word   05000H
	.long   INGA_W_P
INGA16PRR:
	.word   6,18,0,0
	.long   010994dfH
	.word   05000H
	.long   INGA_W_P
INGA16ADD:
	.word   12,13,0,-4
	.long   010996fbH
	.word   05000H
	.long   INGA_W_P
INGA16SUB:
	.word   12,5,0,-8
	.long   01099a07H
	.word   05000H
	.long   INGA_W_P
INGA16APO:
	.word   5,7,0,0
	.long   01099b33H
	.word   05000H
	.long   INGA_W_P
VSB01:
	.word   5,70,-14,9
	.long   01099be2H
	.word   06000H
	.long   VS_Y_P
VSB02:
	.word   15,70,-13,9
	.long   0109a416H
	.word   06080H
	.long   VS_Y_P
VSB03:
	.word   26,69,-11,8
	.long   0109b74aH
	.word   06180H
	.long   VS_Y_P
VSB04:
	.word   36,68,-8,6
	.long   0109cf7aH
	.word   06580H
	.long   VS_Y_P
VSB05:
	.word   43,65,-6,4
	.long   0109ee0eH
	.word   06580H
	.long   VS_Y_P
VSB06:
	.word   47,63,-4,2
	.long   010a1158H
	.word   06580H
	.long   VS_Y_P
VSB07:
	.word   50,61,-2,0
	.long   010a38beH
	.word   06680H
	.long   VS_Y_P
VSB08:
	.word   50,60,-1,-1
	.long   010a631aH
	.word   06680H
	.long   VS_Y_P
VSB09:
	.word   49,59,-1,-2
	.long   010a8e6aH
	.word   06580H
	.long   VS_Y_P
VSS01:
	.word   5,63,-61,-1
	.long   010ab958H
	.word   06000H
	.long   VS_Y_P
VSS02:
	.word   18,63,-56,-1
	.long   010ac0baH
	.word   06080H
	.long   VS_Y_P
VSS03:
	.word   31,63,-50,-1
	.long   010ad404H
	.word   06080H
	.long   VS_Y_P
VSS04:
	.word   44,62,-44,-2
	.long   010af042H
	.word   06580H
	.long   VS_Y_P
VSS05:
	.word   53,60,-39,-2
	.long   010b17a6H
	.word   06580H
	.long   VS_Y_P
VSS06:
	.word   59,60,-34,-2
	.long   010b452aH
	.word   06580H
	.long   VS_Y_P
VSS07:
	.word   65,58,-29,-3
	.long   010b782aH
	.word   06580H
	.long   VS_Y_P
VSS08:
	.word   66,58,-27,-3
	.long   010badd2H
	.word   06580H
	.long   VS_Y_P
VSS09:
	.word   67,58,-26,-3
	.long   010be49aH
	.word   06680H
	.long   VS_Y_P
CODE:
	.word   93,26,0,0
	.long   010c1d36H
	.word   06000H
	.long   CODE_V_P
BAST7T_A:
	.word   6,8,0,0
	.long   010c55e2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_B:
	.word   6,8,0,0
	.long   010c5642H
	.word   02000H
	.long   BAS7_W_P
BAST7T_C:
	.word   6,8,0,0
	.long   010c56a2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_D:
	.word   6,8,0,0
	.long   010c5702H
	.word   02000H
	.long   BAS7_W_P
BAST7T_E:
	.word   5,8,0,0
	.long   010c5762H
	.word   02000H
	.long   BAS7_W_P
BAST7T_F:
	.word   5,8,0,0
	.long   010c57b2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_G:
	.word   6,8,0,0
	.long   010c5802H
	.word   02000H
	.long   BAS7_W_P
BAST7T_H:
	.word   6,8,0,0
	.long   010c5862H
	.word   02000H
	.long   BAS7_W_P
BAST7T_I:
	.word   3,8,0,0
	.long   010c58c2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_J:
	.word   6,8,0,0
	.long   010c58f2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_K:
	.word   6,8,0,0
	.long   010c5952H
	.word   02000H
	.long   BAS7_W_P
BAST7T_L:
	.word   6,8,0,0
	.long   010c59b2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_M:
	.word   8,8,0,0
	.long   010c5a12H
	.word   02000H
	.long   BAS7_W_P
BAST7T_N:
	.word   7,8,0,0
	.long   010c5a92H
	.word   02000H
	.long   BAS7_W_P
BAST7T_O:
	.word   6,8,0,0
	.long   010c5b02H
	.word   02000H
	.long   BAS7_W_P
BAST7T_P:
	.word   6,8,0,0
	.long   010c5b62H
	.word   02000H
	.long   BAS7_W_P
BAST7T_Q:
	.word   7,8,0,0
	.long   010c5bc2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_R:
	.word   6,8,0,0
	.long   010c5c32H
	.word   02000H
	.long   BAS7_W_P
BAST7T_S:
	.word   6,8,0,0
	.long   010c5c92H
	.word   02000H
	.long   BAS7_W_P
BAST7T_T:
	.word   7,8,0,0
	.long   010c5cf2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_U:
	.word   6,8,0,0
	.long   010c5d62H
	.word   02000H
	.long   BAS7_W_P
BAST7T_V:
	.word   6,8,0,0
	.long   010c5dc2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_W:
	.word   8,8,0,0
	.long   010c5e22H
	.word   02000H
	.long   BAS7_W_P
BAST7T_X:
	.word   6,8,0,0
	.long   010c5ea2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_Y:
	.word   7,8,0,0
	.long   010c5f02H
	.word   02000H
	.long   BAS7_W_P
BAST7T_Z:
	.word   6,8,0,0
	.long   010c5f72H
	.word   02000H
	.long   BAS7_W_P
BAST7T_1:
	.word   4,8,0,0
	.long   010c5fd2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_2:
	.word   6,8,0,0
	.long   010c6012H
	.word   02000H
	.long   BAS7_W_P
BAST7T_3:
	.word   6,8,0,0
	.long   010c6072H
	.word   02000H
	.long   BAS7_W_P
BAST7T_4:
	.word   8,8,0,0
	.long   010c60d2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_5:
	.word   6,8,0,0
	.long   010c6152H
	.word   02000H
	.long   BAS7_W_P
BAST7T_6:
	.word   6,8,0,0
	.long   010c61b2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_7:
	.word   6,8,0,0
	.long   010c6212H
	.word   02000H
	.long   BAS7_W_P
BAST7T_8:
	.word   6,8,0,0
	.long   010c6272H
	.word   02000H
	.long   BAS7_W_P
BAST7T_9:
	.word   6,8,0,0
	.long   010c62d2H
	.word   02000H
	.long   BAS7_W_P
BAST7T_0:
	.word   6,8,0,0
	.long   010c6332H
	.word   02000H
	.long   BAS7_W_P
BAST7TAST:
	.word   8,6,0,-1
	.long   010c6392H
	.word   02000H
	.long   BAS7_W_P
BAST7TEXC:
	.word   3,8,0,0
	.long   010c63f2H
	.word   02000H
	.long   BAS7_W_P
BAST7TNUM:
	.word   8,8,0,0
	.long   010c6422H
	.word   02000H
	.long   BAS7_W_P
BAST7TDOL:
	.word   6,8,0,0
	.long   010c64a2H
	.word   02000H
	.long   BAS7_W_P
BAST7TPCT:
	.word   9,8,0,0
	.long   010c6502H
	.word   03000H
	.long   BAST_W_P
BAST7TAND:
	.word   8,8,0,0
	.long   010c65daH
	.word   02000H
	.long   BAS7_W_P
BAST7TLPR:
	.word   4,8,0,0
	.long   010c665aH
	.word   02000H
	.long   BAS7_W_P
BAST7TRPR:
	.word   4,8,0,0
	.long   010c669aH
	.word   02000H
	.long   BAS7_W_P
BAST7TDSH:
	.word   7,2,0,-3
	.long   010c66daH
	.word   02000H
	.long   BAS7_W_P
BAST7TPLS:
	.word   7,6,0,-1
	.long   010c66f6H
	.word   02000H
	.long   BAS7_W_P
BAST7TCOM:
	.word   4,4,0,-5
	.long   010c674aH
	.word   02000H
	.long   BAS7_W_P
BAST7TPER:
	.word   3,3,0,-5
	.long   010c676aH
	.word   02000H
	.long   BAS7_W_P
BAST7TQUE:
	.word   6,8,0,0
	.long   010c677cH
	.word   02000H
	.long   BAS7_W_P
BAST7TSLS:
	.word   6,8,0,0
	.long   010c67dcH
	.word   03000H
	.long   BAST_W_P
BAST7TAPO:
	.word   4,4,0,0
	.long   010c674aH
	.word   02000H
	.long   BAS7_W_P
BAST7TCOL:
	.word   3,7,0,-1
	.long   010c686cH
	.word   02000H
	.long   BAS7_W_P
BAST7TSEM:
	.word   4,8,0,-1
	.long   010c6896H
	.word   02000H
	.long   BAS7_W_P
WIN4FREE:
	.word   276,9,137,4
	.long   010c68d6H
	.word   04000H
	.long   BAST_Y_P
WINSTAY:
	.word   148,9,73,4
	.long   010c8fa6H
	.word   03000H
	.long   BAST_Y_P
WNRSSTAY:
	.word   147,9,73,4
	.long   010c9f42H
	.word   03000H
	.long   BAST_Y_P
ASISTOFF:
	.word   266,9,132,4
	.long   010caec3H
	.word   03000H
	.long   BAST_R_P
NOPUSH:
	.word   147,9,73,4
	.long   010ccad1H
	.word   04000H
	.long   BAST_R_P
SHOTPERC:
	.word   191,9,95,4
	.long   010cdf7dH
	.word   04000H
	.long   BAST_R_P
BABYPLAY:
	.word   139,9,69,4
	.long   010cfa59H
	.word   03000H
	.long   BAST_R_P
TOURMODE:
	.word   122,15,60,10
	.long   010d0902H
	.word   03000H
	.long   BAST_R_P
NOCPU:
	.word   222,11,110,4
	.long   010d1e74H
	.word   03000H
	.long   BAST_R_P
SECRETS:
	.word   152,9,75,4
	.long   010d3b12H
	.word   03000H
	.long   BAST_R_P
TEAMST:
	.word   68,9,0,0
	.long   010d4b1aH
	.word   03000H
	.long   BAST_W_P
TEAMST4:
	.word   72,45,0,-13
	.long   010d5246H
	.word   03000H
	.long   BAST_W_P
TRIVPTS:
	.word   66,9,0,0
	.long   010d783eH
	.word   04000H
	.long   BAST_W_P
CORRECT:
	.word   123,8,0,0
	.long   010d8186H
	.word   02000H
	.long   BAST_W_P
POINTS:
	.word   35,8,0,0
	.long   010d8936H
	.word   02000H
	.long   BAST_W_P
BAST8_A:
	.word   9,9,0,0
	.long   010d8b66H
	.word   04000H
	.long   BAST_W_P
BAST8_B:
	.word   8,9,0,0
	.long   010d8caaH
	.word   04000H
	.long   BAST_D_P
BAST8_C:
	.word   9,9,0,0
	.long   010d8dcaH
	.word   04000H
	.long   BAST_O_P
BAST8_D:
	.word   9,9,0,0
	.long   010d8f0eH
	.word   04000H
	.long   BAST_Y_P
BAST8_E:
	.word   7,9,0,0
	.long   010d9052H
	.word   04000H
	.long   BAST_G_P
BAST8_F:
	.word   7,9,0,0
	.long   010d914eH
	.word   04000H
	.long   BAST_C_P
BAST8_G:
	.word   9,9,0,0
	.long   010d924aH
	.word   04000H
	.long   BAST_B_P
BAST8_H:
	.word   8,9,0,0
	.long   010d938eH
	.word   04000H
	.long   BAST_P_P
BAST8_I:
	.word   4,9,0,0
	.long   010d94aeH
	.word   04000H
	.long   BAST_K_P
BAST8_J:
	.word   7,9,0,0
	.long   010d953eH
	.word   04000H
	.long   BAST_R_P
BAST8_K:
	.word   10,9,0,0
	.long   010d963aH
	.word   04000H
	.long   BAST_W_P
BAST8_L:
	.word   7,9,0,0
	.long   010d97a2H
	.word   04000H
	.long   BAST_W_P
BAST8_M:
	.word   10,9,0,0
	.long   010d989eH
	.word   04000H
	.long   BAST_W_P
BAST8_N:
	.word   8,9,0,0
	.long   010d9a06H
	.word   04000H
	.long   BAST_W_P
BAST8_O:
	.word   9,9,0,0
	.long   010d9b26H
	.word   04000H
	.long   BAST_W_P
BAST8_P:
	.word   8,9,0,0
	.long   010d9c6aH
	.word   04000H
	.long   BAST_W_P
BAST8_Q:
	.word   9,11,0,0
	.long   010d9d8aH
	.word   04000H
	.long   BAST_W_P
BAST8_R:
	.word   9,9,0,0
	.long   010d9f16H
	.word   04000H
	.long   BAST_W_P
BAST8_S:
	.word   8,9,0,0
	.long   010da05aH
	.word   04000H
	.long   BAST_W_P
BAST8_T:
	.word   8,9,0,0
	.long   010da17aH
	.word   04000H
	.long   BAST_W_P
BAST8_U:
	.word   8,9,0,0
	.long   010da29aH
	.word   04000H
	.long   BAST_W_P
BAST8_V:
	.word   8,9,0,0
	.long   010da3baH
	.word   04000H
	.long   BAST_W_P
BAST8_W:
	.word   12,9,0,0
	.long   010da4daH
	.word   04000H
	.long   BAST_W_P
BAST8_X:
	.word   8,9,0,0
	.long   010da68aH
	.word   04000H
	.long   BAST_W_P
BAST8_Y:
	.word   8,9,0,0
	.long   010da7aaH
	.word   04000H
	.long   BAST_W_P
BAST8_Z:
	.word   7,9,0,0
	.long   010da8caH
	.word   04000H
	.long   BAST_W_P
BAST8_0:
	.word   9,9,0,0
	.long   010da9c6H
	.word   04000H
	.long   BAST_W_P
BAST8_1:
	.word   5,9,0,0
	.long   010dab0aH
	.word   04000H
	.long   BAST_W_P
BAST8_2:
	.word   8,9,0,0
	.long   010dabbeH
	.word   04000H
	.long   BAST_W_P
BAST8_3:
	.word   8,9,0,0
	.long   010dacdeH
	.word   04000H
	.long   BAST_W_P
BAST8_4:
	.word   9,9,0,0
	.long   010dadfeH
	.word   04000H
	.long   BAST_W_P
BAST8_5:
	.word   8,9,0,0
	.long   010daf42H
	.word   04000H
	.long   BAST_W_P
BAST8_6:
	.word   8,9,0,0
	.long   010db062H
	.word   04000H
	.long   BAST_W_P
BAST8_7:
	.word   7,9,0,0
	.long   010db182H
	.word   04000H
	.long   BAST_W_P
BAST8_8:
	.word   8,9,0,0
	.long   010db27eH
	.word   04000H
	.long   BAST_W_P
BAST8_9:
	.word   8,9,0,0
	.long   010db39eH
	.word   04000H
	.long   BAST_W_P
BAST8COL:
	.word   4,7,0,-1
	.long   010db4beH
	.word   04000H
	.long   BAST_W_P
BAST8NUM:
	.word   8,9,0,0
	.long   010db52eH
	.word   04000H
	.long   BAST_W_P
BAST8DOL:
	.word   8,13,0,2
	.long   010db64eH
	.word   04000H
	.long   BAST_W_P
BAST8PCT:
	.word   9,9,0,0
	.long   010db7eeH
	.word   04000H
	.long   BAST_W_P
BAST8AND:
	.word   10,10,0,1
	.long   010db932H
	.word   04000H
	.long   BAST_W_P
BAST8PRL:
	.word   5,11,0,1
	.long   010dbac2H
	.word   04000H
	.long   BAST_W_P
BAST8PRR:
	.word   5,11,0,1
	.long   010dbb9eH
	.word   04000H
	.long   BAST_W_P
BAST8PER:
	.word   4,3,0,-6
	.long   010dbc7aH
	.word   04000H
	.long   BAST_W_P
BAST8COM:
	.word   4,5,0,-6
	.long   010dbcaaH
	.word   04000H
	.long   BAST_W_P
BAST8PLS:
	.word   7,7,0,-1
	.long   010dbcfaH
	.word   04000H
	.long   BAST_W_P
BAST8QUE:
	.word   8,9,0,0
	.long   010dbdbeH
	.word   04000H
	.long   BAST_W_P
BAST8SLS:
	.word   8,9,0,0
	.long   010dbedeH
	.word   04000H
	.long   BAST_W_P
BAST8APO:
	.word   4,5,0,0
	.long   010dbcaaH
	.word   04000H
	.long   BAST_W_P
BAST8SEM:
	.word   4,9,0,-2
	.long   010dbffeH
	.word   04000H
	.long   BAST_W_P
BAST8SPC:
	.word   6,9,0,0
	.long   010dc08eH
	.word   04000H
	.long   BAST_W_P
BAST8EXC:
	.word   4,9,0,0
	.long   010dc166H
	.word   04000H
	.long   BAST_W_P
BAST8T_A:
	.word   8,9,0,0
	.long   010dc1f6H
	.word   04000H
	.long   BAST_W_P
BAST8T_B:
	.word   7,9,0,0
	.long   010dc316H
	.word   04000H
	.long   BAST_G_P
BAST8T_C:
	.word   7,9,0,0
	.long   010dc412H
	.word   04000H
	.long   BAST_R_P
BAST8T_D:
	.word   7,9,0,0
	.long   010dc50eH
	.word   04000H
	.long   BAST_Y_P
BAST8T_E:
	.word   6,9,0,0
	.long   010dc60aH
	.word   04000H
	.long   BAST_W_P
BAST8T_F:
	.word   6,9,0,0
	.long   010dc6e2H
	.word   04000H
	.long   BAST_W_P
BAST8T_G:
	.word   7,9,0,0
	.long   010dc7baH
	.word   04000H
	.long   BAST_W_P
BAST8T_H:
	.word   7,9,0,0
	.long   010dc8b6H
	.word   04000H
	.long   BAST_W_P
BAST8T_I:
	.word   3,9,0,0
	.long   010dc9b2H
	.word   04000H
	.long   BAST_W_P
BAST8T_J:
	.word   6,9,0,0
	.long   010dca1eH
	.word   04000H
	.long   BAST_W_P
BAST8T_K:
	.word   8,9,0,0
	.long   010dcaf6H
	.word   04000H
	.long   BAST_W_P
BAST8T_L:
	.word   6,9,0,0
	.long   010dcc16H
	.word   04000H
	.long   BAST_W_P
BAST8T_M:
	.word   9,9,0,0
	.long   010dcceeH
	.word   04000H
	.long   BAST_W_P
BAST8T_N:
	.word   7,9,0,0
	.long   010dce32H
	.word   04000H
	.long   BAST_W_P
BAST8T_O:
	.word   7,9,0,0
	.long   010dcf2eH
	.word   04000H
	.long   BAST_W_P
BAST8T_P:
	.word   7,9,0,0
	.long   010dd02aH
	.word   04000H
	.long   BAST_W_P
BAST8T_Q:
	.word   7,10,0,0
	.long   010dd126H
	.word   04000H
	.long   BAST_W_P
BAST8T_R:
	.word   8,9,0,0
	.long   010dd23eH
	.word   04000H
	.long   BAST_W_P
BAST8T_S:
	.word   7,9,0,0
	.long   010dd35eH
	.word   04000H
	.long   BAST_W_P
BAST8T_T:
	.word   7,9,0,0
	.long   010dd45aH
	.word   04000H
	.long   BAST_W_P
BAST8T_U:
	.word   7,9,0,0
	.long   010dd556H
	.word   04000H
	.long   BAST_W_P
BAST8T_V:
	.word   7,9,0,0
	.long   010dd652H
	.word   04000H
	.long   BAST_W_P
BAST8T_W:
	.word   10,9,0,0
	.long   010dd74eH
	.word   04000H
	.long   BAST_W_P
BAST8T_X:
	.word   7,9,0,0
	.long   010dd8b6H
	.word   04000H
	.long   BAST_W_P
BAST8T_Y:
	.word   7,9,0,0
	.long   010dd9b2H
	.word   04000H
	.long   BAST_W_P
BAST8T_Z:
	.word   6,9,0,0
	.long   010ddaaeH
	.word   04000H
	.long   BAST_W_P
BAST8T_0:
	.word   7,9,0,0
	.long   010ddb86H
	.word   04000H
	.long   BAST_W_P
BAST8T_1:
	.word   4,9,0,0
	.long   010ddc82H
	.word   04000H
	.long   BAST_W_P
BAST8T_2:
	.word   7,9,0,0
	.long   010ddd12H
	.word   04000H
	.long   BAST_W_P
BAST8T_3:
	.word   7,9,0,0
	.long   010dde0eH
	.word   04000H
	.long   BAST_W_P
BAST8T_4:
	.word   8,9,0,0
	.long   010ddf0aH
	.word   04000H
	.long   BAST_W_P
BAST8T_5:
	.word   7,9,0,0
	.long   010de02aH
	.word   04000H
	.long   BAST_W_P
BAST8T_6:
	.word   7,9,0,0
	.long   010de126H
	.word   04000H
	.long   BAST_W_P
BAST8T_7:
	.word   7,9,0,0
	.long   010de222H
	.word   04000H
	.long   BAST_W_P
BAST8T_8:
	.word   7,9,0,0
	.long   010de31eH
	.word   04000H
	.long   BAST_W_P
BAST8T_9:
	.word   7,9,0,0
	.long   010de41aH
	.word   04000H
	.long   BAST_W_P
BAST8TCOL:
	.word   4,7,0,-1
	.long   010db4beH
	.word   04000H
	.long   BAST_W_P
BAST8TNUM:
	.word   8,9,0,0
	.long   010db52eH
	.word   04000H
	.long   BAST_W_P
BAST8TDOL:
	.word   8,13,0,2
	.long   010de516H
	.word   04000H
	.long   BAST_W_P
BAST8TPCT:
	.word   9,9,0,0
	.long   010db7eeH
	.word   04000H
	.long   BAST_W_P
BAST8TAND:
	.word   10,10,0,1
	.long   010db932H
	.word   04000H
	.long   BAST_W_P
BAST8TPRL:
	.word   5,11,0,1
	.long   010dbac2H
	.word   04000H
	.long   BAST_W_P
BAST8TPRR:
	.word   5,11,0,1
	.long   010dbb9eH
	.word   04000H
	.long   BAST_W_P
BAST8TPER:
	.word   4,3,0,-6
	.long   010dbc7aH
	.word   04000H
	.long   BAST_W_P
BAST8TCOM:
	.word   4,5,0,-6
	.long   010dbcaaH
	.word   04000H
	.long   BAST_W_P
BAST8TAPO:
	.word   4,5,0,0
	.long   010dbcaaH
	.word   04000H
	.long   BAST_W_P
BAST8TPLS:
	.word   7,7,0,-1
	.long   010dbcfaH
	.word   04000H
	.long   BAST_W_P
BAST8TQUE:
	.word   7,9,0,0
	.long   010de6b6H
	.word   04000H
	.long   BAST_W_P
BAST8TSLS:
	.word   7,9,0,0
	.long   010de7b2H
	.word   04000H
	.long   BAST_W_P
BAST8TSEM:
	.word   4,9,0,-2
	.long   010dbffeH
	.word   04000H
	.long   BAST_W_P
BAST8TSPC:
	.word   6,9,0,0
	.long   010dc08eH
	.word   04000H
	.long   BAST_W_P
BAST8TEXC:
	.word   3,9,0,0
	.long   010de8aeH
	.word   04000H
	.long   BAST_W_P
BAST10_A:
	.word   10,11,0,0
	.long   010de91aH
	.word   04000H
	.long   BAST_W_P
BAST10_B:
	.word   10,11,0,0
	.long   010dead2H
	.word   04000H
	.long   BAST_G_P
BAST10_C:
	.word   10,11,0,0
	.long   010dec8aH
	.word   04000H
	.long   BAST_R_P
BAST10_D:
	.word   9,11,0,0
	.long   010dee42H
	.word   04000H
	.long   BAST_Y_P
BAST10_E:
	.word   8,11,0,0
	.long   010defceH
	.word   04000H
	.long   BAST_W_P
BAST10_F:
	.word   8,11,0,0
	.long   010df12eH
	.word   04000H
	.long   BAST_W_P
BAST10_G:
	.word   10,11,0,0
	.long   010df28eH
	.word   04000H
	.long   BAST_W_P
BAST10_H:
	.word   9,11,0,0
	.long   010df446H
	.word   04000H
	.long   BAST_W_P
BAST10_I:
	.word   4,11,0,0
	.long   010df5d2H
	.word   04000H
	.long   BAST_W_P
BAST10_J:
	.word   8,11,0,0
	.long   010df682H
	.word   04000H
	.long   BAST_W_P
BAST10_K:
	.word   10,11,0,0
	.long   010df7e2H
	.word   04000H
	.long   BAST_W_P
BAST10_L:
	.word   8,11,0,0
	.long   010df99aH
	.word   04000H
	.long   BAST_W_P
BAST10_M:
	.word   11,11,0,0
	.long   010dfafaH
	.word   04000H
	.long   BAST_W_P
BAST10_N:
	.word   9,11,0,0
	.long   010dfcdeH
	.word   04000H
	.long   BAST_W_P
BAST10_O:
	.word   11,11,0,0
	.long   010dfe6aH
	.word   04000H
	.long   BAST_W_P
BAST10_P:
	.word   9,11,0,0
	.long   010e004eH
	.word   04000H
	.long   BAST_W_P
BAST10_Q:
	.word   11,13,0,0
	.long   010e01daH
	.word   04000H
	.long   BAST_W_P
BAST10_R:
	.word   9,11,0,0
	.long   010e0416H
	.word   04000H
	.long   BAST_W_P
BAST10_S:
	.word   10,11,0,0
	.long   010e05a2H
	.word   04000H
	.long   BAST_W_P
BAST10_T:
	.word   10,11,0,0
	.long   010e075aH
	.word   04000H
	.long   BAST_W_P
BAST10_U:
	.word   9,11,0,0
	.long   010e0912H
	.word   04000H
	.long   BAST_W_P
BAST10_V:
	.word   10,11,0,0
	.long   010e0a9eH
	.word   04000H
	.long   BAST_W_P
BAST10_W:
	.word   14,11,0,0
	.long   010e0c56H
	.word   04000H
	.long   BAST_W_P
BAST10_X:
	.word   11,11,0,0
	.long   010e0ebeH
	.word   04000H
	.long   BAST_W_P
BAST10_Y:
	.word   11,11,0,0
	.long   010e10a2H
	.word   04000H
	.long   BAST_W_P
BAST10_Z:
	.word   8,11,0,0
	.long   010e1286H
	.word   04000H
	.long   BAST_W_P
BAST10_0:
	.word   9,11,0,0
	.long   010e13e6H
	.word   04000H
	.long   BAST_W_P
BAST10_1:
	.word   7,11,0,0
	.long   010e1572H
	.word   04000H
	.long   BAST_W_P
BAST10_2:
	.word   9,11,0,0
	.long   010e16a6H
	.word   04000H
	.long   BAST_W_P
BAST10_3:
	.word   9,11,0,0
	.long   010e1832H
	.word   04000H
	.long   BAST_W_P
BAST10_4:
	.word   9,11,0,0
	.long   010e19beH
	.word   04000H
	.long   BAST_W_P
BAST10_5:
	.word   9,11,0,0
	.long   010e1b4aH
	.word   04000H
	.long   BAST_W_P
BAST10_6:
	.word   9,11,0,0
	.long   010e1cd6H
	.word   04000H
	.long   BAST_W_P
BAST10_7:
	.word   8,11,0,0
	.long   010e1e62H
	.word   04000H
	.long   BAST_W_P
BAST10_8:
	.word   10,11,0,0
	.long   010e1fc2H
	.word   04000H
	.long   BAST_W_P
BAST10_9:
	.word   9,11,0,0
	.long   010e217aH
	.word   04000H
	.long   BAST_W_P
BAST10EXC:
	.word   4,11,0,0
	.long   010e2306H
	.word   04000H
	.long   BAST_W_P
BAST10NUM:
	.word   10,9,0,-1
	.long   010e23b6H
	.word   04000H
	.long   BAST_W_P
BAST10DOL:
	.word   9,13,0,1
	.long   010e251eH
	.word   04000H
	.long   BAST_W_P
BAST10PCT:
	.word   12,11,0,0
	.long   010e26f2H
	.word   04000H
	.long   BAST_W_P
BAST10AND:
	.word   10,12,0,1
	.long   010e2902H
	.word   04000H
	.long   BAST_W_P
BAST10PRL:
	.word   6,13,0,1
	.long   010e2ae2H
	.word   04000H
	.long   BAST_W_P
BAST10PRR:
	.word   6,13,0,1
	.long   010e2c1aH
	.word   04000H
	.long   BAST_W_P
BAST10PLS:
	.word   9,9,0,-1
	.long   010e2d52H
	.word   04000H
	.long   BAST_W_P
BAST10APO:
	.word   4,6,0,0
	.long   010e2e96H
	.word   04000H
	.long   BAST_W_P
BAST10DSH:
	.word   6,3,0,-4
	.long   010e2ef6H
	.word   04000H
	.long   BAST_W_P
BAST10SLS:
	.word   7,11,0,0
	.long   010e2f3eH
	.word   04000H
	.long   BAST_W_P
BAST10COM:
	.word   4,6,0,-7
	.long   010e2e96H
	.word   04000H
	.long   BAST_W_P
BAST10PER:
	.word   4,4,0,-7
	.long   010e3072H
	.word   04000H
	.long   BAST_W_P
BAST10SEM:
	.word   4,10,0,-3
	.long   010e30b2H
	.word   04000H
	.long   BAST_W_P
BAST10COL:
	.word   4,7,0,-2
	.long   010db4beH
	.word   04000H
	.long   BAST_W_P
BAST10QUE:
	.word   8,11,0,0
	.long   010e3152H
	.word   04000H
	.long   BAST_W_P
BAST10SPC:
	.word   8,11,0,0
	.long   010e32b2H
	.word   05000H
	.long   BAST_W_P
BAST18_A:
	.word   16,20,0,0
	.long   010e346aH
	.word   06000H
	.long   BST18W_P
BAST18_B:
	.word   15,20,0,0
	.long   010e3beaH
	.word   06000H
	.long   BSTGWW_P
BAST18_C:
	.word   15,20,0,0
	.long   010e42f2H
	.word   06000H
	.long   BSTGWWOP
BAST18_D:
	.word   15,20,0,0
	.long   010e49faH
	.word   06000H
	.long   BST18Y_P
BAST18_E:
	.word   13,20,0,0
	.long   010e5102H
	.word   06000H
	.long   BST18R_P
BAST18_F:
	.word   12,20,0,0
	.long   010e571aH
	.word   06000H
	.long   BST18G_P
BAST18_G:
	.word   16,21,0,1
	.long   010e5cbaH
	.word   06000H
	.long   BST18T_P
BAST18_H:
	.word   14,20,0,0
	.long   010e649aH
	.word   06000H
	.long   BST18P_P
BAST18_I:
	.word   6,20,0,0
	.long   010e6b2aH
	.word   06000H
	.long   BSTGYO_P
BAST18_J:
	.word   12,20,0,0
	.long   010e6dfaH
	.word   06000H
	.long   BSTGYG_P
BAST18_K:
	.word   16,20,0,0
	.long   010e739aH
	.word   06000H
	.long   BST18B2_P
BAST18_L:
	.word   12,20,0,0
	.long   010e7b1aH
	.word   06000H
	.long   BST18Y2_P
BAST18_M:
	.word   17,20,0,0
	.long   010e80baH
	.word   06000H
	.long   BST18W_P
BAST18_N:
	.word   14,20,0,0
	.long   010e88b2H
	.word   06000H
	.long   BST18W_P
BAST18_O:
	.word   16,20,0,0
	.long   010e8f42H
	.word   06000H
	.long   BST18W_P
BAST18_P:
	.word   14,20,0,0
	.long   010e96c2H
	.word   06000H
	.long   BST18W_P
BAST18_Q:
	.word   16,24,0,0
	.long   010e9d52H
	.word   06000H
	.long   BST18W_P
BAST18_R:
	.word   14,20,0,0
	.long   010ea652H
	.word   06000H
	.long   BST18W_P
BAST18_S:
	.word   16,22,0,1
	.long   010eace2H
	.word   06000H
	.long   BST18W_P
BAST18_T:
	.word   14,20,0,0
	.long   010eb522H
	.word   06000H
	.long   BST18W_P
BAST18_U:
	.word   14,21,0,0
	.long   010ebbb2H
	.word   06000H
	.long   BST18W_P
BAST18_V:
	.word   15,20,0,0
	.long   010ec296H
	.word   06000H
	.long   BST18W_P
BAST18_W:
	.word   23,20,0,0
	.long   010ec99eH
	.word   06000H
	.long   BST18W_P
BAST18_X:
	.word   16,20,0,0
	.long   010ed466H
	.word   06000H
	.long   BST18W_P
BAST18_Y:
	.word   16,20,0,0
	.long   010edbe6H
	.word   06000H
	.long   BST18W_P
BAST18_Z:
	.word   15,20,0,0
	.long   010ee366H
	.word   06000H
	.long   BST18W_P
BAST18_0:
	.word   15,20,0,0
	.long   010eea6eH
	.word   06000H
	.long   BST18W_P
BAST18_1:
	.word   8,20,0,0
	.long   010ef176H
	.word   06000H
	.long   BST18W_P
BAST18_2:
	.word   15,21,0,1
	.long   010ef536H
	.word   06000H
	.long   BST18W_P
BAST18_3:
	.word   15,22,0,1
	.long   010efc98H
	.word   06000H
	.long   BST18W_P
BAST18_4:
	.word   15,20,0,0
	.long   010f0454H
	.word   06000H
	.long   BST18W_P
BAST18_5:
	.word   14,21,0,0
	.long   010f0b5cH
	.word   06000H
	.long   BST18W_P
BAST18_6:
	.word   15,21,0,0
	.long   010f1240H
	.word   06000H
	.long   BST18W_P
BAST18_7:
	.word   15,20,0,0
	.long   010f19a2H
	.word   06000H
	.long   BST18W_P
BAST18_8:
	.word   16,20,0,0
	.long   010f20aaH
	.word   06000H
	.long   BST18W_P
BAST18_9:
	.word   15,21,0,1
	.long   010f282aH
	.word   06000H
	.long   BST18W_P
BAST18EXC:
	.word   7,20,0,0
	.long   010f2f8cH
	.word   06000H
	.long   BST18W_P
BAST18NUM:
	.word   13,20,0,0
	.long   010f32d4H
	.word   06000H
	.long   BST18W_P
BAST18DOL:
	.word   16,24,0,2
	.long   010f38ecH
	.word   06000H
	.long   BST18W_P
BAST18PCT:
	.word   20,20,0,0
	.long   010f41ecH
	.word   06000H
	.long   BST18W_P
BAST18AND:
	.word   17,22,0,1
	.long   010f4b4cH
	.word   06000H
	.long   BST18W_P
BAST18PRL:
	.word   9,24,0,2
	.long   010f5410H
	.word   06000H
	.long   BST18W_P
BAST18PRR:
	.word   9,24,0,2
	.long   010f5920H
	.word   06000H
	.long   BST18W_P
BAST18ADD:
	.word   10,11,0,-5
	.long   010f5e30H
	.word   06000H
	.long   BST18W_P
BAST18DSH:
	.word   10,5,0,-8
	.long   010f60c4H
	.word   06000H
	.long   BST18W_P
BAST18SLS:
	.word   13,20,0,0
	.long   010f61f0H
	.word   06000H
	.long   BST18W_P
BAST18PER:
	.word   6,7,0,-13
	.long   010f6808H
	.word   06000H
	.long   BST18W_P
BAST18COM:
	.word   6,9,0,-13
	.long   010f6904H
	.word   06000H
	.long   BST18W_P
BAST18COL:
	.word   6,15,0,-3
	.long   010f6a48H
	.word   06000H
	.long   BST18W_P
BAST18APO:
	.word   6,9,0,0
	.long   010f6c64H
	.word   06000H
	.long   BST18W_P
BAST18_1a:
	.word   8,20,-4,0
	.long   010ef176H
	.word   06000H
	.long   BST18W_P
BRSH50_A:
	.word   43,54,0,0
	.long   010f6da8H
	.word   05000H
	.long   BRSH50W_P
BRSH50_B:
	.word   43,54,0,0
	.long   010f9b02H
	.word   05000H
	.long   BRSH50V_P
BRSH50_C:
	.word   43,54,0,0
	.long   010fc85cH
	.word   05000H
	.long   BRSH50Y_P
BRSH50_D:
	.word   45,54,0,0
	.long   010ff5b6H
	.word   05000H
	.long   BRSH50O_P
BRSH50_E:
	.word   43,54,0,0
	.long   0110252cH
	.word   05000H
	.long   BRSH50B_P
BRSH50_F:
	.word   42,54,0,0
	.long   01105286H
	.word   05000H
	.long   BRSH50LBP
BRSH50_G:
	.word   44,54,0,0
	.long   01107ed2H
	.word   05000H
	.long   BRSH50R_P
BRSH50_H:
	.word   52,65,0,8
	.long   0110ad3aH
	.word   05000H
	.long   BRSH50G_P
BRSH50_I:
	.word   19,54,0,0
	.long   0110ef3eH
	.word   05000H
	.long   BRSH50P_P
BRSH50_J:
	.word   39,54,0,0
	.long   01110348H
	.word   05000H
	.long   BRSH50W_P
BRSH50_K:
	.word   44,54,0,0
	.long   01112c6aH
	.word   05000H
	.long   BRSH50W_P
BRSH50_L:
	.word   36,54,0,0
	.long   01115ad2H
	.word   05000H
	.long   BRSH50W_P
BRSH50_M:
	.word   55,54,0,1
	.long   011180caH
	.word   05000H
	.long   BRSH50W_P
BRSH50_N:
	.word   43,54,0,2
	.long   0111baccH
	.word   05000H
	.long   BRSH50W_P
BRSH50_O:
	.word   49,54,0,0
	.long   0111e826H
	.word   05000H
	.long   BRSH50W_P
BRSH50_P:
	.word   40,54,0,0
	.long   01121bd4H
	.word   05000H
	.long   BRSH50W_P
BRSH50_Q:
	.word   48,60,0,1
	.long   01124604H
	.word   05000H
	.long   BRSH50W_P
BRSH50_R:
	.word   42,54,0,0
	.long   01127e44H
	.word   05000H
	.long   BRSH50W_P
BRSH50_S:
	.word   42,54,0,0
	.long   0112aa90H
	.word   05000H
	.long   BRSH50W_P
BRSH50_T:
	.word   49,55,0,0
	.long   0112d6dcH
	.word   05000H
	.long   BRSH50W_P
BRSH50_U:
	.word   42,54,0,0
	.long   01130b7fH
	.word   05000H
	.long   BRSH50W_P
BRSH50_V:
	.word   43,54,0,0
	.long   011337cbH
	.word   05000H
	.long   BRSH50W_P
BRSH50_W:
	.word   57,54,0,-1
	.long   01136525H
	.word   05000H
	.long   BRSH50W_P
BRSH50_X:
	.word   47,60,0,5
	.long   0113a143H
	.word   05000H
	.long   BRSH50W_P
BRSH50_Y:
	.word   42,54,0,0
	.long   0113d857H
	.word   05000H
	.long   BRSH50W_P
BRSH50_Z:
	.word   50,54,0,0
	.long   011404a3H
	.word   05000H
	.long   BRSH50W_P
BRSH50_0:
	.word   47,53,0,-1
	.long   0114395fH
	.word   05000H
	.long   BRSH50W_P
BRSH50_1:
	.word   28,53,0,-1
	.long   01146a06H
	.word   05000H
	.long   BRSH50W_P
BRSH50_2:
	.word   44,53,0,-1
	.long   01148702H
	.word   05000H
	.long   BRSH50W_P
BRSH50_3:
	.word   46,53,0,-1
	.long   0114b48eH
	.word   05000H
	.long   BRSH50W_P
BRSH50_4:
	.word   48,53,0,-1
	.long   0114e42cH
	.word   05000H
	.long   BRSH50W_P
BRSH50_5:
	.word   43,52,0,-2
	.long   011515dcH
	.word   05000H
	.long   BRSH50W_P
BRSH50_6:
	.word   41,54,0,0
	.long   01154188H
	.word   05000H
	.long   BRSH50W_P
BRSH50_7:
	.word   42,52,0,-2
	.long   01156cc6H
	.word   05000H
	.long   BRSH50W_P
BRSH50_8:
	.word   44,53,0,-1
	.long   0115976eH
	.word   05000H
	.long   BRSH50W_P
BRSH50_9:
	.word   42,53,0,-1
	.long   0115c4faH
	.word   05000H
	.long   BRSH50W_P
BRSH50AND:
	.word   62,54,0,0
	.long   0115f074H
	.word   05000H
	.long   BRSH50W_P
BRSH50COL:
	.word   26,40,0,-8
	.long   011631d8H
	.word   05000H
	.long   BRSH50W_P
BRSH50COM:
	.word   12,17,0,-44
	.long   01164628H
	.word   05000H
	.long   BRSH50W_P
BRSH50DOL:
	.word   29,54,0,0
	.long   01164a24H
	.word   05000H
	.long   BRSH50W_P
BRSH50EXC:
	.word   22,54,0,0
	.long   011668baH
	.word   05000H
	.long   BRSH50W_P
BRSH50NUM:
	.word   29,30,0,-11
	.long   01167feeH
	.word   05000H
	.long   BRSH50W_P
BRSH50PCT:
	.word   50,54,0,-1
	.long   011690ecH
	.word   05000H
	.long   BRSH50W_P
BRSH50PER:
	.word   10,10,0,-44
	.long   0116c5a8H
	.word   05000H
	.long   BRSH50W_P
BRSH50PRL:
	.word   21,54,0,0
	.long   0116c79cH
	.word   05000H
	.long   BRSH50W_P
BRSH50PRR:
	.word   18,54,0,0
	.long   0116ddc2H
	.word   05000H
	.long   BRSH50W_P
BRSH50QUE:
	.word   36,54,0,0
	.long   0116f0beH
	.word   05000H
	.long   BRSH50W_P
BRSH50SLS:
	.word   27,54,0,0
	.long   011716b6H
	.word   05000H
	.long   BRSH50W_P
BRSH20_A:
	.word   17,22,0,0
	.long   01173330H
	.word   05000H
	.long   BRSH_B_P
BRSH20_B:
	.word   18,22,0,0
	.long   01173a7eH
	.word   05000H
	.long   BRSH_G_P
BRSH20_C:
	.word   18,22,0,0
	.long   0117423aH
	.word   05000H
	.long   BRSH_R_P
BRSH20_D:
	.word   19,22,0,0
	.long   011749f6H
	.word   05000H
	.long   BRSH_W_P
BRSH20_E:
	.word   17,22,0,0
	.long   01175220H
	.word   05000H
	.long   BRSH_Y_P
BRSH20_F:
	.word   17,22,0,0
	.long   0117596eH
	.word   05000H
	.long   BRSHGWKP
BRSH20_G:
	.word   18,22,0,0
	.long   011760bcH
	.word   05000H
	.long   BRSHGYGP
BRSH20_H:
	.word   22,26,0,2
	.long   01176878H
	.word   05000H
	.long   BRSHGYOP
BRSH20_I:
	.word   8,22,0,0
	.long   011773a4H
	.word   05000H
	.long   BRSHGYOP
BRSH20_J:
	.word   17,22,0,0
	.long   01177714H
	.word   05000H
	.long   BRSHGYOP
BRSH20_K:
	.word   18,22,0,0
	.long   01177e62H
	.word   05000H
	.long   BRSHGYOP
BRSH20_L:
	.word   15,22,0,0
	.long   0117861eH
	.word   05000H
	.long   BRSHGYOP
BRSH20_M:
	.word   22,24,0,1
	.long   01178c90H
	.word   05000H
	.long   BRSHGYOP
BRSH20_N:
	.word   18,24,0,1
	.long   011796e0H
	.word   05000H
	.long   BRSHGYOP
BRSH20_O:
	.word   20,22,0,0
	.long   01179f50H
	.word   05000H
	.long   BRSHGYOP
BRSH20_P:
	.word   16,22,0,0
	.long   0117a7e8H
	.word   05000H
	.long   BRSHGYOP
BRSH20_Q:
	.word   20,24,0,0
	.long   0117aec8H
	.word   05000H
	.long   BRSHGYOP
BRSH20_R:
	.word   17,22,0,0
	.long   0117b828H
	.word   05000H
	.long   BRSHGYOP
BRSH20_S:
	.word   17,22,0,0
	.long   0117bf76H
	.word   05000H
	.long   BRSHGYOP
BRSH20_T:
	.word   19,22,0,0
	.long   0117c6c4H
	.word   05000H
	.long   BRSHGYOP
BRSH20_U:
	.word   17,22,0,0
	.long   0117ceeeH
	.word   05000H
	.long   BRSHGYOP
BRSH20_V:
	.word   18,23,0,1
	.long   0117d63cH
	.word   05000H
	.long   BRSHGYOP
BRSH20_W:
	.word   23,23,0,0
	.long   0117de52H
	.word   05000H
	.long   BRSHGYOP
BRSH20_X:
	.word   19,25,0,1
	.long   0117e8a7H
	.word   05000H
	.long   BRSHGYOP
BRSH20_Y:
	.word   17,22,0,0
	.long   0117f1eeH
	.word   05000H
	.long   BRSHGYOP
BRSH20_Z:
	.word   20,22,0,0
	.long   0117f93cH
	.word   05000H
	.long   BRSHGYOP
BRSH20_1:
	.word   12,22,-2,0
	.long   011801d4H
	.word   05000H
	.long   BRSHGYOP
BRSH20_2:
	.word   19,22,0,0
	.long   011806fcH
	.word   05000H
	.long   BRSHGYOP
BRSH20_3:
	.word   19,22,0,0
	.long   01180f26H
	.word   05000H
	.long   BRSHGYOP
BRSH20_4:
	.word   20,22,0,0
	.long   01181750H
	.word   05000H
	.long   BRSHGYOP
BRSH20_5:
	.word   18,22,0,0
	.long   01181fe8H
	.word   05000H
	.long   BRSHGYOP
BRSH20_6:
	.word   18,22,0,0
	.long   011827a4H
	.word   05000H
	.long   BRSHGYOP
BRSH20_7:
	.word   17,22,0,0
	.long   01182f60H
	.word   05000H
	.long   BRSHGYOP
BRSH20_8:
	.word   19,22,0,0
	.long   011836aeH
	.word   05000H
	.long   BRSHGYOP
BRSH20_9:
	.word   18,22,0,0
	.long   01183ed8H
	.word   05000H
	.long   BRSHGYOP
BRSH20_0:
	.word   20,22,0,0
	.long   01184694H
	.word   05000H
	.long   BRSHGYOP
BRSH20COM:
	.word   6,8,0,-17
	.long   01184f2cH
	.word   05000H
	.long   BRSHGYOP
BRSH20PER:
	.word   4,5,0,-17
	.long   0118501cH
	.word   05000H
	.long   BRSHGYOP
BRSH20SLS:
	.word   12,22,0,0
	.long   01185080H
	.word   05000H
	.long   BRSHGYOP
BRSH20QUE:
	.word   16,22,0,0
	.long   011855a8H
	.word   05000H
	.long   BRSHGYOP
BRSH20EXC:
	.word   9,22,0,0
	.long   01185c88H
	.word   05000H
	.long   BRSHGYOP
BRSH20PCT:
	.word   20,22,0,0
	.long   01186066H
	.word   05000H
	.long   BRSHGYOP
BRSH20COL:
	.word   11,18,0,-3
	.long   011868feH
	.word   05000H
	.long   BRSHGYOP
SQUD_01:
	.word   12,22,5,10
	.long   011801d4H
	.word   05000H
	.long   BRSHGYOP
SQUD_02:
	.word   19,22,9,10
	.long   011806fcH
	.word   05000H
	.long   BRSHGYOP
SQUD_03:
	.word   19,22,9,10
	.long   01180f26H
	.word   05000H
	.long   BRSHGYOP
SQUD_04:
	.word   20,22,9,10
	.long   01181750H
	.word   05000H
	.long   BRSHGYOP
SQUD_05:
	.word   18,22,8,10
	.long   01181fe8H
	.word   05000H
	.long   BRSHGYOP
SQUD_06:
	.word   18,22,8,10
	.long   011827a4H
	.word   05000H
	.long   BRSHGYOP
SQUD_07:
	.word   17,22,8,10
	.long   01182f60H
	.word   05000H
	.long   BRSHGYOP
SQUD_08:
	.word   19,22,9,10
	.long   011836aeH
	.word   05000H
	.long   BRSHGYOP
SQUD_09:
	.word   18,22,8,10
	.long   01183ed8H
	.word   05000H
	.long   BRSHGYOP
SQUD_10:
	.word   31,22,15,10
	.long   01186cdcH
	.word   05000H
	.long   BRSHGYOP
SQUD_11:
	.word   24,22,11,10
	.long   01187a2eH
	.word   05000H
	.long   BRSHGYOP
SQUD_12:
	.word   31,22,15,10
	.long   0118847eH
	.word   05000H
	.long   BRSHGYOP
SQUD_13:
	.word   31,22,15,10
	.long   011891d0H
	.word   05000H
	.long   BRSHGYOP
SQUD_14:
	.word   31,22,15,10
	.long   01189f22H
	.word   05000H
	.long   BRSHGYOP
SQUD_15:
	.word   30,22,14,10
	.long   0118ac74H
	.word   05000H
	.long   BRSHGYOP
SQUD_16:
	.word   29,22,14,10
	.long   0118b958H
	.word   05000H
	.long   BRSHGYOP
SQUD_17:
	.word   30,22,14,10
	.long   0118c5ceH
	.word   05000H
	.long   BRSHGYOP
SQUD_18:
	.word   31,22,15,10
	.long   0118d2b2H
	.word   05000H
	.long   BRSHGYOP
SQUD_19:
	.word   30,22,14,10
	.long   0118e004H
	.word   05000H
	.long   BRSHGYOP
SQUD_20:
	.word   38,22,18,10
	.long   0118ece8H
	.word   05000H
	.long   BRSHGYOP
useupbx:
	.word   165,104,-13,-4
	.long   0118fd3cH
	.word   05000H
	.long   BRSHGWKP
TRIVIA:
	.word   84,23,0,0
	.long   011a4c64H
	.word   05000H
	.long   BRSHGYOP
CONTEST:
	.word   127,24,0,0
	.long   011a7220H
	.word   05000H
	.long   BRSHGYOP
FNT_SEL:
	.word   101,47,50,23
	.long   011aada8H
	.word   05000H
	.long   FNT_D_P
FNT_ENT:
	.word   85,47,42,23
	.long   011b0a5fH
	.word   05000H
	.long   FNT_W_P
FNT_CRE:
	.word   100,48,49,23
	.long   011b5866H
	.word   05000H
	.long   FNT_G_P
BRSH12_A:
	.word   9,11,0,0
	.long   011bb626H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_B:
	.word   9,11,0,0
	.long   011bb815H
	.word   05000H
	.long   BRUSH_Y_P
BRSH12_C:
	.word   9,11,0,0
	.long   011bba04H
	.word   05000H
	.long   BRUSH_R_P
BRSH12_D:
	.word   9,11,0,0
	.long   011bbbf3H
	.word   05000H
	.long   BRUSH_G_P
BRSH12_E:
	.word   9,11,0,0
	.long   011bbde2H
	.word   05000H
	.long   BRUSH_B_P
BRSH12_F:
	.word   8,11,0,0
	.long   011bbfd1H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_G:
	.word   9,11,0,0
	.long   011bc189H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_H:
	.word   10,13,0,1
	.long   011bc378H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_I:
	.word   4,11,0,0
	.long   011bc602H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_J:
	.word   8,11,0,0
	.long   011bc6deH
	.word   05000H
	.long   BRUSH_W_P
BRSH12_K:
	.word   9,11,0,0
	.long   011bc896H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_L:
	.word   8,11,0,0
	.long   011bca85H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_M:
	.word   11,11,0,0
	.long   011bcc3dH
	.word   05000H
	.long   BRUSH_W_P
BRSH12_N:
	.word   10,11,0,0
	.long   011bce9aH
	.word   05000H
	.long   BRUSH_W_P
BRSH12_O:
	.word   10,11,0,0
	.long   011bd0c0H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_P:
	.word   9,11,0,0
	.long   011bd2e6H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_Q:
	.word   10,12,0,0
	.long   011bd4d5H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_R:
	.word   9,11,0,0
	.long   011bd72dH
	.word   05000H
	.long   BRUSH_W_P
BRSH12_S:
	.word   8,11,0,0
	.long   011bd91cH
	.word   05000H
	.long   BRUSH_W_P
BRSH12_T:
	.word   9,11,0,0
	.long   011bdad4H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_U:
	.word   9,11,0,0
	.long   011bdcc3H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_V:
	.word   9,11,0,0
	.long   011bdeb2H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_W:
	.word   12,11,0,0
	.long   011be0a1H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_X:
	.word   9,12,0,0
	.long   011be335H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_Y:
	.word   9,11,0,0
	.long   011be551H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_Z:
	.word   10,11,0,0
	.long   011be740H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_0:
	.word   10,11,0,0
	.long   011be966H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_1:
	.word   6,11,-2,0
	.long   011beb8cH
	.word   05000H
	.long   BRUSH_W_P
BRSH12_2:
	.word   9,11,0,0
	.long   011becd6H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_3:
	.word   10,11,0,0
	.long   011beec5H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_4:
	.word   10,11,0,0
	.long   011bf0ebH
	.word   05000H
	.long   BRUSH_W_P
BRSH12_5:
	.word   9,11,0,0
	.long   011bf311H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_6:
	.word   9,11,0,0
	.long   011bf500H
	.word   05000H
	.long   BRUSH_W_P
BRSH12_7:
	.word   9,11,0,0
	.long   011bf6efH
	.word   05000H
	.long   BRUSH_W_P
BRSH12_8:
	.word   9,11,0,0
	.long   011bf8deH
	.word   05000H
	.long   BRUSH_W_P
BRSH12_9:
	.word   9,11,0,0
	.long   011bfacdH
	.word   05000H
	.long   BRUSH_W_P
BRSH12QUE:
	.word   8,11,0,0
	.long   011bfcbcH
	.word   05000H
	.long   BRUSH_W_P
BRSH12EXC:
	.word   5,11,0,0
	.long   011bfe74H
	.word   05000H
	.long   BRUSH_W_P
BRSH12COL:
	.word   6,11,0,0
	.long   011bff87H
	.word   05000H
	.long   BRUSH_W_P
BRSH12DOL:
	.word   7,11,0,0
	.long   011c00d1H
	.word   05000H
	.long   BRUSH_W_P
BRSH12PER:
	.word   3,2,0,-9
	.long   011c0252H
	.word   05000H
	.long   BRUSH_W_P
BRSH12COM:
	.word   4,4,0,-7
	.long   011c0270H
	.word   05000H
	.long   BRUSH_W_P
BRSH12SLS:
	.word   6,11,0,0
	.long   011c02c0H
	.word   05000H
	.long   BRUSH_W_P
BRSH12NUM:
	.word   6,7,0,-3
	.long   011c040aH
	.word   05000H
	.long   BRUSH_W_P
BRSH12PCT:
	.word   10,11,0,0
	.long   011c04dcH
	.word   05000H
	.long   BRUSH_W_P
BRSH12AND:
	.word   13,11,0,0
	.long   011c0702H
	.word   05000H
	.long   BRUSH_W_P
BRSH12PRL:
	.word   5,12,0,1
	.long   011c09cdH
	.word   05000H
	.long   BRUSH_W_P
BRSH12PRR:
	.word   5,12,0,1
	.long   011c0af9H
	.word   05000H
	.long   BRUSH_W_P
BRSH12DAS:
	.word   6,3,0,-4
	.long   011c0c25H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_A:
	.word   8,9,0,0
	.long   011c0c7fH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_B:
	.word   8,9,0,0
	.long   011c0de7H
	.word   05000H
	.long   BRUSH_Y_P
BRSH10_C:
	.word   8,9,0,0
	.long   011c0f4fH
	.word   05000H
	.long   BRUSH_R_P
BRSH10_D:
	.word   8,9,0,0
	.long   011c10b7H
	.word   05000H
	.long   BRUSH_G_P
BRSH10_E:
	.word   8,9,0,0
	.long   011c121fH
	.word   05000H
	.long   BRUSH_B_P
BRSH10_F:
	.word   7,9,0,0
	.long   011c1387H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_G:
	.word   8,9,0,0
	.long   011c14c2H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_H:
	.word   9,11,0,1
	.long   011c162aH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_I:
	.word   4,9,0,0
	.long   011c1819H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_J:
	.word   7,9,0,0
	.long   011c18cdH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_K:
	.word   8,9,0,0
	.long   011c1a08H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_L:
	.word   7,9,0,0
	.long   011c1b70H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_M:
	.word   10,10,0,1
	.long   011c1cabH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_N:
	.word   8,10,0,1
	.long   011c1e9fH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_O:
	.word   8,9,0,0
	.long   011c202fH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_P:
	.word   7,9,0,0
	.long   011c2197H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_Q:
	.word   9,10,0,0
	.long   011c22d2H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_R:
	.word   8,9,0,0
	.long   011c2494H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_S:
	.word   7,9,0,0
	.long   011c25fcH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_T:
	.word   8,9,0,0
	.long   011c2737H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_U:
	.word   8,9,0,0
	.long   011c289fH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_V:
	.word   8,9,0,0
	.long   011c2a07H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_W:
	.word   10,9,0,0
	.long   011c2b6fH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_X:
	.word   8,10,0,1
	.long   011c2d31H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_Y:
	.word   7,9,0,0
	.long   011c2ec1H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_Z:
	.word   8,9,0,0
	.long   011c2ffcH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_0:
	.word   9,9,0,0
	.long   011c3164H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_1:
	.word   6,9,0,0
	.long   011c32f9H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_2:
	.word   7,9,0,0
	.long   011c3407H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_3:
	.word   8,9,0,0
	.long   011c3542H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_4:
	.word   9,9,0,0
	.long   011c36aaH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_5:
	.word   8,9,0,0
	.long   011c383fH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_6:
	.word   8,9,0,0
	.long   011c39a7H
	.word   05000H
	.long   BRUSH_W_P
BRSH10_7:
	.word   7,9,0,0
	.long   011c3b0fH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_8:
	.word   7,9,0,0
	.long   011c3c4aH
	.word   05000H
	.long   BRUSH_W_P
BRSH10_9:
	.word   8,9,0,0
	.long   011c3d85H
	.word   05000H
	.long   BRUSH_W_P
BRSH10COM:
	.word   3,4,0,-5
	.long   011c3eedH
	.word   05000H
	.long   BRUSH_W_P
BRSH10PER:
	.word   3,2,0,-7
	.long   011c3f29H
	.word   05000H
	.long   BRUSH_W_P
BRSH10SLS:
	.word   6,9,0,0
	.long   011c3f47H
	.word   05000H
	.long   BRUSH_W_P
BRSH10QUE:
	.word   7,10,0,1
	.long   011c4055H
	.word   05000H
	.long   BRUSH_W_P
BRSH10EXC:
	.word   5,10,0,1
	.long   011c41b3H
	.word   05000H
	.long   BRUSH_W_P
BRSH10DOL:
	.word   6,9,0,0
	.long   011c42adH
	.word   05000H
	.long   BRUSH_W_P
BRSH10PCT:
	.word   8,9,0,0
	.long   011c43bbH
	.word   05000H
	.long   BRUSH_W_P
BRSH10AND:
	.word   10,10,0,1
	.long   011c4523H
	.word   05000H
	.long   BRUSH_W_P
BRSH10NUM:
	.word   6,6,-1,-2
	.long   011c4717H
	.word   05000H
	.long   BRUSH_W_P
BRSH10PRL:
	.word   4,11,0,1
	.long   011c47cbH
	.word   05000H
	.long   BRUSH_W_P
BRSH10PRR:
	.word   4,11,0,1
	.long   011c48a7H
	.word   05000H
	.long   BRUSH_W_P
BRSH10COL:
	.word   5,10,0,1
	.long   011c4983H
	.word   05000H
	.long   BRUSH_W_P
scorshad1:
	.word   100,24,0,0
	.long   011c4a7dH
	.word   06000H
	.long   METLPALC
scorshad2:
	.word   100,24,0,0
	.long   011c82bdH
	.word   06000H
	.long   METLPALC
stx_all:
	.word   20,9,0,0
	.long   011cbafdH
	.word   03000H
	.long   BAST_Y_P
stx_aveallow:
	.word   52,19,0,0
	.long   011cbd19H
	.word   03000H
	.long   BAST_Y_P
stx_avescore:
	.word   52,19,0,0
	.long   011cc8adH
	.word   03000H
	.long   BAST_Y_P
stx_created:
	.word   69,19,0,0
	.long   011cd441H
	.word   03000H
	.long   BAST_Y_P
stx_current:
	.word   48,19,0,0
	.long   011ce39eH
	.word   03000H
	.long   BAST_Y_P
stx_defeated:
	.word   52,9,0,0
	.long   011cee4eH
	.word   03000H
	.long   BAST_Y_P
stx_defrank:
	.word   55,19,0,0
	.long   011cf3caH
	.word   03000H
	.long   BAST_Y_P
stx_havenot:
	.word   75,9,0,0
	.long   011d0009H
	.word   03000H
	.long   BAST_Y_P
stx_l:
	.word   16,11,0,0
	.long   011d07f2H
	.word   02000H
	.long   BAST_Y_P
stx_nbateams:
	.word   62,9,0,1
	.long   011d0952H
	.word   03000H
	.long   BAST_Y_P
stx_nextcpu:
	.word   55,19,0,0
	.long   011d0fdcH
	.word   03000H
	.long   BAST_Y_P
stx_offrank:
	.word   55,19,0,0
	.long   011d1c1bH
	.word   03000H
	.long   BAST_Y_P
stx_ofthe27:
	.word   53,9,0,0
	.long   011d285aH
	.word   03000H
	.long   BAST_Y_P
stx_overall:
	.word   48,19,0,0
	.long   011d2df1H
	.word   03000H
	.long   BAST_Y_P
stx_record:
	.word   41,9,0,0
	.long   011d38a1H
	.word   03000H
	.long   BAST_Y_P
stx_tournwin:
	.word   72,19,0,0
	.long   011d3cf4H
	.word   03000H
	.long   BAST_Y_P
stx_w:
	.word   20,11,0,0
	.long   011d4cfcH
	.word   03000H
	.long   BAST_Y_P
stx_worldrec:
	.word   48,19,0,0
	.long   011d4f90H
	.word   03000H
	.long   BAST_Y_P
stx_youhave:
	.word   51,9,0,0
	.long   011d5a40H
	.word   03000H
	.long   BAST_Y_P
stx_avepoint:
	.word   65,19,0,0
	.long   011d5fa1H
	.word   03000H
	.long   BAST_Y_P
stx_lostto:
	.word   43,9,0,0
	.long   011d6e1aH
	.word   03000H
	.long   BAST_Y_P
stx_norecord:
	.word   79,11,-1,0
	.long   011d72a3H
	.word   04000H
	.long   BAST_Y_P
stx_pct:
	.word   25,9,0,0
	.long   011d8037H
	.word   03000H
	.long   BAST_Y_P
stx_wins:
	.word   32,9,0,0
	.long   011d82daH
	.word   03000H
	.long   BAST_Y_P
credbox:
	.word   57,11,0,0
	.long   011d863aH
	.word   06000H
	.long   METLPGRA
stshad1:
	.word   116,99,0,0
	.long   011d94ecH
	.word   01000H
	.long   SHADOW
stshad2:
	.word   116,99,0,0
	.long   011dc1c8H
	.word   01000H
	.long   SHADOW
THREPNTS:
	.word   72,47,0,0
	.long   011deea4H
	.word   06000H
	.long   THRP10_P
THREP1:
	.long   THRP1_P
THREP2:
	.long   THRP2_P
THREP3:
	.long   THRP3_P
THREP4:
	.long   THRP4_P
THREP5:
	.long   THRP5_P
THREP6:
	.long   THRP6_P
THREP7:
	.long   THRP7_P
THREP8:
	.long   THRP8_P
THREP9:
	.long   THRP9_P
THREP10:
	.long   THRP10_P
plyr1:
	.word   61,9,-19,-7
	.long   011e3df4H
	.word   04000H
	.long   SGMD8RED
plyr2:
	.word   63,9,-19,-7
	.long   011e4688H
	.word   04000H
	.long   SGMD8WHT
plyr3:
	.word   63,9,-19,-7
	.long   011e4f64H
	.word   04000H
	.long   SGMD8WHT
plyr4:
	.word   63,9,-19,-7
	.long   011e5840H
	.word   04000H
	.long   SGMD8WHT
getready:
	.word   80,25,39,0
	.long   011e611cH
	.word   04000H
	.long   BAST_Y_P
_1quart:
	.word   66,33,32,0
	.long   011e805cH
	.word   04000H
	.long   BAST_Y_P
continue:
	.word   80,22,39,10
	.long   011ea264H
	.word   04000H
	.long   BAST_Y_P
_2quart:
	.word   66,33,32,0
	.long   011ebde4H
	.word   04000H
	.long   BAST_Y_P
_3quart:
	.word   66,33,33,0
	.long   011edfecH
	.word   04000H
	.long   BAST_Y_P
_4quart:
	.word   66,33,32,0
	.long   011f01f4H
	.word   04000H
	.long   BAST_Y_P
overtme:
	.word   106,17,52,0
	.long   011f23fcH
	.word   04000H
	.long   BAST_Y_P
congrats_l:
	.word   142,22,70,10
	.long   011f4024H
	.word   04000H
	.long   BAST_Y_P
winstay_l:
	.word   188,39,93,19
	.long   011f70f4H
	.word   04000H
	.long   BAST_Y_P
chalneed_l:
	.word   90,46,44,22
	.long   011fe384H
	.word   04000H
	.long   BAST_Y_P
chalacc_l:
	.word   81,46,40,22
	.long   01202434H
	.word   04000H
	.long   BAST_Y_P
winfree:
	.word   188,49,93,24
	.long   01205e6cH
	.word   04000H
	.long   BAST_Y_P
TMATE:
	.word   76,25,37,12
	.long   0120ee5cH
	.word   04000H
	.long   BAST_Y_P
CHALENG:
	.word   76,25,37,12
	.long   01210c0cH
	.word   04000H
	.long   BAST_Y_P
dronetxt:
	.word   87,71,-7,-16
	.long   012129bcH
	.word   03000H
	.long   textp
firstwin:
	.word   100,105,0,0
	.long   0121721fH
	.word   06000H
	.long   HINT_B_P
colormessage:
	.word   80,22,-10,-45
	.long   01226837H
	.word   02000H
	.long   textp
joycontrol:
	.word   80,14,-10,-17
	.long   012275f7H
	.word   02000H
	.long   textp
red:
	.word   17,6,-40,-69
	.long   01227eb7H
	.word   02000H
	.long   textp
blue:
	.word   23,6,-39,-69
	.long   01227f83H
	.word   04000H
	.long   textp
green:
	.word   29,6,-34,-69
	.long   012281abH
	.word   03000H
	.long   textp
yellow:
	.word   37,6,-31,-69
	.long   012283b5H
	.word   03000H
	.long   textp
message1:
	.word   71,29,-15,-22
	.long   0122864fH
	.word   03000H
	.long   textp
message2:
	.word   77,30,-12,-10
	.long   01229e70H
	.word   02000H
	.long   textp
message3:
	.word   64,29,-18,-21
	.long   0122b07cH
	.word   03000H
	.long   textp
message4:
	.word   89,38,-6,-10
	.long   0122c63cH
	.word   02000H
	.long   textp
message5:
	.word   86,38,-7,-19
	.long   0122e0a8H
	.word   02000H
	.long   textp
message6:
	.word   80,30,-10,-22
	.long   0122fa30H
	.word   02000H
	.long   textp
message7:
	.word   78,38,-11,-56
	.long   01230cf0H
	.word   02000H
	.long   textp
message9:
	.word   85,32,-8,-57
	.long   01232418H
	.word   03000H
	.long   textp
message2a:
	.word   77,30,-13,-23
	.long   01229e70H
	.word   02000H
	.long   textp
infobox:
	.word   100,64,0,0
	.long   012343f8H
	.word   06000H
	.long   HINT_B_P
CREDNOT:
	.word   83,67,-9,-10
	.long   0123d9f8H
	.word   03000H
	.long   CREDNOT_P
WINPIECE:
	.word   26,105,0,0
	.long   01241b23H
	.word   06000H
	.long   HINT_B_P
CLD1A:
	.word   9,9,4,4
	.long   01245b1fH
	.word   06000H
	.long   GREYPAL
CLDB1:
	.word   12,11,5,5
	.long   01245d05H
	.word   06000H
	.long   BLUBOOM
CLDB1YELL:
	.word   12,11,6,20
	.long   01245d05H
	.word   06000H
	.long   YELLPAL
CLDB1WHT:
	.word   12,11,6,20
	.long   01245d05H
	.word   06000H
	.long   WHTPAL
CLDB1ORNG:
	.word   12,11,6,20
	.long   01245d05H
	.word   06000H
	.long   ORNGPAL
CLDB1LGRY:
	.word   12,11,6,20
	.long   01245d05H
	.word   06000H
	.long   LGRYPAL
CLDB1GRN:
	.word   12,11,6,20
	.long   01245d05H
	.word   06000H
	.long   GRNPAL
CLDB1PURP:
	.word   12,11,6,20
	.long   01245d05H
	.word   06000H
	.long   PURPPAL
CLD2:
	.word   25,29,12,15
	.long   0124601dH
	.word   06000H
CLD3:
	.word   29,32,15,17
	.long   0124711bH
	.word   06000H
CLD4:
	.word   25,31,13,18
	.long   012486dbH
	.word   06000H
CLD4A:
	.word   28,37,14,26
	.long   01249905H
	.word   06000H
CLD4B:
	.word   32,38,17,29
	.long   0124b14dH
	.word   06000H
CLD5:
	.word   36,34,17,17
	.long   0124cdcdH
	.word   06000H
CLD6:
	.word   36,36,18,19
	.long   0124ea7dH
	.word   06000H
CLD7:
	.word   36,36,18,19
	.long   012508ddH
	.word   06000H
CLD8:
	.word   32,32,16,18
	.long   0125273dH
	.word   06000H
CLD9:
	.word   30,29,16,15
	.long   01253f3dH
	.word   06000H
CLD10:
	.word   29,30,14,15
	.long   012553a1H
	.word   06000H
CLD11:
	.word   29,30,14,15
	.long   01256805H
	.word   06000H
CLDB2:
	.word   22,22,11,11
	.long   01257c69H
	.word   06000H
CLDB3:
	.word   28,30,13,14
	.long   012587c1H
	.word   06000H
CLDB4:
	.word   32,31,15,15
	.long   01259b71H
	.word   06000H
flash1:
	.word   3,3,1,1
	.long   0125b2b1H
	.word   05000H
	.long   camflsh_p
flash4:
	.word   22,23,11,11
	.long   0125b2deH
	.word   05000H
	.long   camflsh_p
flash3:
	.word   20,19,10,9
	.long   0125bcc0H
	.word   05000H
	.long   camflsh_p
flash3a:
	.word   35,37,17,18
	.long   0125c42cH
	.word   05000H
	.long   camflsh_p
flash5:
	.word   50,44,24,22
	.long   0125dd77H
	.word   05000H
	.long   camflsh_p
flash6:
	.word   61,51,30,25
	.long   0126086fH
	.word   05000H
	.long   camflsh_p
flash2:
	.word   9,9,4,4
	.long   01264532H
	.word   05000H
	.long   camflsh_p
arrow1l:
	.word   28,16,0,0
	.long   012646c7H
	.word   05000H
	.long   arw4p
arrow1r:
	.word   28,16,0,0
	.long   01264f87H
	.word   05000H
	.long   arw4p
arrow2l:
	.word   28,16,0,0
	.long   01265847H
	.word   05000H
	.long   arw3p
arrow2r:
	.word   28,16,0,0
	.long   01266107H
	.word   05000H
	.long   arw3p
arrow3l:
	.word   28,16,0,0
	.long   012669c7H
	.word   05000H
	.long   arw2p
arrow3r:
	.word   28,16,0,0
	.long   01267287H
	.word   05000H
	.long   arw2p
arrow4l:
	.word   28,16,0,0
	.long   01267b47H
	.word   05000H
	.long   arw1p
arrow4r:
	.word   28,16,0,0
	.long   01268407H
	.word   05000H
	.long   arw1p
arrow1t:
	.word   16,26,7,24
	.long   01268cc7H
	.word   05000H
	.long   arw4p
arrow2t:
	.word   16,26,7,24
	.long   012694e7H
	.word   05000H
	.long   arw3p
arrow3t:
	.word   16,26,7,24
	.long   01269d07H
	.word   05000H
	.long   arw2p
arrow4t:
	.word   16,26,7,24
	.long   0126a527H
	.word   05000H
	.long   arw1p
arrow1l2p:
	.word   28,16,0,0
	.long   012646c7H
	.word   05000H
	.long   arw4p
arrow1r2p:
	.word   28,16,0,0
	.long   01264f87H
	.word   05000H
	.long   arw4p
arrow2l2p:
	.word   28,16,0,0
	.long   01265847H
	.word   05000H
	.long   arw1p
arrow2r2p:
	.word   28,16,0,0
	.long   01266107H
	.word   05000H
	.long   arw1p
arrow1t2p:
	.word   16,26,7,24
	.long   01268cc7H
	.word   05000H
	.long   arw4p
arrow2t2p:
	.word   16,26,7,24
	.long   012694e7H
	.word   05000H
	.long   arw1p
	.include FONTTBL.GLO

	.include ROBOIMG.GLO

	.include BGNDTBL.GLO
