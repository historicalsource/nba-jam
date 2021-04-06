;One for every dunk
	SEQ	DUNKA_SEQ	,dunka_t
	SEQ	DUNKAH_SEQ	,dunkah_t
	SEQ	DUNKB_SEQ	,dunkb_t
	SEQ	DUNKC_SEQ	,dunkc_t
	SEQ	DUNKD_SEQ	,dunkd_t
	SEQ	DUNKE_SEQ	,dunke_t
	SEQ	DUNKF_SEQ	,dunkf_t
	SEQ	DUNKG_SEQ	,dunkg_t
	SEQ	DUNKH_SEQ	,dunkh_t
	SEQ	DUNKI_SEQ	,dunki_t
	SEQ	DUNKJ_SEQ	,dunkj_t
	SEQ	DUNKK_SEQ	,dunkk_t
	SEQ	DUNKL_SEQ	,dunkl_t
	SEQ	DUNKM_SEQ	,dunkm_t


;Direction tables for short range dunks
#dunks_t
	.long	#d1s_t,#d2s_t,#d3s_t,#d4s_t
	.long	#d5s_t,#d4s_t,#d3s_t,#d2s_t, #d1s_t

;Direction tables for long range dunks
#dunkl_t
	.long	#d1l_t,#d2l_t,#d3l_t,#d4l_t
	.long	#d5l_t,#d4l_t,#d3l_t,#d2l_t, #d1l_t


;List of dunks that can happen in these dirs if plyr is near hoop
#d1s_t	.word	1-1,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ
#d2s_t	.word	1-1,DUNKB_SEQ,DUNKF_SEQ,DUNKI_SEQ,DUNKJ_SEQ
#d3s_t	.word	1-1,DUNKB_SEQ,DUNKC_SEQ,DUNKE_SEQ,DUNKH_SEQ,DUNKI_SEQ
#d4s_t	.word	1-1,DUNKC_SEQ,DUNKE_SEQ,DUNKG_SEQ,DUNKH_SEQ
#d5s_t	.word	1-1,DUNKH_SEQ

;List of dunks that can happen in these dirs if plyr is far away from hoop
#d1l_t	.word	1-1,DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ,DUNKJ_SEQ
#d2l_t	.word	1-1,DUNKA_SEQ,DUNKB_SEQ,DUNKF_SEQ,DUNKI_SEQ,DUNKJ_SEQ
	.word	DUNKK_SEQ
#d3l_t	.word	1-1,DUNKA_SEQ,DUNKAH_SEQ,DUNKB_SEQ,DUNKC_SEQ,DUNKD_SEQ
	.word	DUNKE_SEQ,DUNKH_SEQ,DUNKI_SEQ,DUNKL_SEQ,DUNKM_SEQ
#d4l_t	.word	1-1,DUNKC_SEQ,DUNKD_SEQ,DUNKE_SEQ,DUNKG_SEQ,DUNKH_SEQ
#d5l_t	.word	1-1,DUNKH_SEQ



;Sequence header table
dunka_t
	.word	DUNK_M|JUMP_M			;Flags for sequence
	.long	seq_stand			;Code for end of sequence
	.long	#da2_l,#da2_l,#da3_l,#DD	;Dirs 1-8
	.long	#DD,#DD,#da3f_l,#da2f_l

;Sequence list for animation - will happen only in the 1 dir
#da3_l
	.asg	7,N				;ticks per frame
	WLW	N,w3spdu1,F			;Flags

#da2_l
	WLW	N,w3spdu2,F
	WLLW	-1,seq_strtdunk,w3spdu7,N*4+1	;Next frame begins elevation
						;Last frame before releasing
						;ball, the last frame with
						;Last # is total ticks until
						;player is at rim
	WLW	N,w3spdu3,F
	WLW	N,w3spdu4,F
	WLW	N,w3spdu5,F
	WLW	N,w3spdu6,F
	WLW	1,w3spdu7,F
	WLW	-1,seq_slamball,0		;Ball centers in hoop at
						;display of next frame
						;Last cnt is total hang cnt
	WLW	5,w3spdu7,F			
	WLW	4,w3spdu8,F
	WLW	4,w3spdu9,F
	WLW	30,w3spdu10,F			;Lands on ground
#DD	W0



#da3f_l
	.asg	7,N				;ticks per frame
	WLW	N,w3spdu1,FF

#da2f_l
	WLW	N,w3spdu2,FF
	WLLW	-1,seq_strtdunk,w3spdu7,N*4+1
	WLW	N,w3spdu3,FF
	WLW	N,w3spdu4,FF
	WLW	N,w3spdu5,FF
	WLW	N,w3spdu6,FF
	WLW	1,w3spdu7,FF
	WLW	-1,seq_slamball,0

	WLW	5,w3spdu7,FF
	WLW	4,w3spdu8,FF
	WLW	4,w3spdu9,FF
	WLW	30,w3spdu10,FF
	W0

********************************


dunkah_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#DD,#dah3_l,#DD
	.long	#DD,#DD,#dah3f_l,#DD


#dah3_l
	.asg	7,N
	WLW	N,w3spdu1,F
	WLW	N,w3spdu2,F
	WLLW	-1,seq_strtdunk,w3spdu7,N*4+1

	WLW	N,w3spdu3,F
	WLW	N,w3spdu4,F
	WLW	N,w3spdu5,F
	WLW	N,w3spdu6,F
	WLW	1,w3spdu7,F

	.asg	5,N
	WLW	-1,seq_slamball,N*4+2		;hang time on rim before drop

	WLW	3,w3spdu7,F
	WLW	N,w3hang1,F
	WLW	N,w3hang2,F
	WLW	N,w3hang3,F
	WLW	N,w3hang4,F
	WLW	N,w3hang5,F
	WLW	N,w3hang6,F
	WLW	N,w3hang7,F
	WL	-1,seq_stand4			;Force a stand in 4 dir
	W0



#dah3f_l
	.asg	7,N
	WLW	N,w3spdu1,FF
	WLW	N,w3spdu2,FF
	WLLW	-1,seq_strtdunk,w3spdu7,N*4+1

	WLW	N,w3spdu3,FF
	WLW	N,w3spdu4,FF
	WLW	N,w3spdu5,FF
	WLW	N,w3spdu6,FF
	WLW	1,w3spdu7,FF

	.asg	5,N
	WLW	-1,seq_slamball,N*4+2

	WLW	3,w3spdu7,FF
	WLW	N,w3hang1,FF
	WLW	N,w3hang2,FF
	WLW	N,w3hang3,FF
	WLW	N,w3hang4,FF
	WLW	N,w3hang5,FF
	WLW	N,w3hang6,FF
	WLW	N,w3hang7,FF
	WL	-1,seq_stand7
	W0


********************************

dunkb_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#db2_l,#db2,#db3_l,#DD
	.long	#DD,#DD,#db3f_l,#db2f_l


#db2_l
	.asg	7,N
	WLW	N,w1stdu1,F
	WLLW	-1,seq_strtdunk,w1stdu6,N*4+1
	WLW	N,w1stdu2,F
	WLW	N,w1stdu3,F
	WLW	N,w1stdu4,F
	WLW	N,w1stdu5,F
	WLW	1,w1stdu6,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	3,w1stdu6,F
	WLW	N,w1stdu7,F
	WLW	N,w1stdu8,F
	WLW	N,w1stdu9,F
	WLW	30,w1stdu10,F
	WL	-1,seq_stand5
	W0

#db2f_l
	.asg	7,N
	WLW	N,w1stdu1,FF
	WLLW	-1,seq_strtdunk,w1stdu6,N*4+1
	WLW	N,w1stdu2,FF
	WLW	N,w1stdu3,FF
	WLW	N,w1stdu4,FF
	WLW	N,w1stdu5,FF
	WLW	1,w1stdu6,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	3,w1stdu6,FF
	WLW	N,w1stdu7,FF
	WLW	N,w1stdu8,FF
	WLW	N,w1stdu9,FF
	WLW	30,w1stdu10,FF
	WL	-1,seq_stand5
	W0


#db3_l
	.asg	7,N
	WLW	N,w3spdu1,F
	WLW	N,w3spdu2,F
	WLLW	-1,seq_strtdunk,w1stdu6,N*4+1
	WLW	N,w1stdu2,F
	WLW	N,w1stdu3,F
	WLW	N,w1stdu4,F
	WLW	N,w1stdu5,F
	WLW	1,w1stdu6,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	3,w1stdu6,F
	WLW	N,w1stdu7,F
	WLW	N,w1stdu8,F
	WLW	N,w1stdu9,F
	WLW	30,w1stdu10,F
	WL	-1,seq_stand5
	W0

#db3f_l
	.asg	7,N
	WLW	N,w3spdu1,FF
	WLW	N,w3spdu2,FF
	WLLW	-1,seq_strtdunk,w1stdu6,N*4+1
	WLW	N,w1stdu2,FF
	WLW	N,w1stdu3,FF
	WLW	N,w1stdu4,FF
	WLW	N,w1stdu5,FF
	WLW	1,w1stdu6,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	3,w1stdu6,FF
	WLW	N,w1stdu7,FF
	WLW	N,w1stdu8,FF
	WLW	N,w1stdu9,FF
	WLW	30,w1stdu10,FF
	WL	-1,seq_stand5
	W0

********************************


dunkc_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#DD,#dc3_l,#dc3_l
	.long	#DD,#dc3f_l,#dc3f_l,#DD


#dc3_l
	.asg	7,N
	WLW	N,w4modu1,F
	WLW	N,w4modu2,F
	WLLW	-1,seq_strtdunk,w4modu5,N*3+1
	WLW	N,w4modu3,F
	WLW	N,w4modu4,F
	WLW	1,w4modu5,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w4modu5,F
	WLW	N,w4modu6,F
	WLW	30,w4modu7,F
	WL	-1,seq_stand3
	W0

#dc3f_l
	.asg	7,N
	WLW	N,w4modu1,FF
	WLW	N,w4modu2,FF
	WLLW	-1,seq_strtdunk,w4modu5,N*3+1
	WLW	N,w4modu3,FF
	WLW	N,w4modu4,FF
	WLW	1,w4modu5,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w4modu5,FF
	WLW	N,w4modu6,FF
	WLW	30,w4modu7,FF
	WL	-1,seq_stand7
	W0


********************************


dunkd_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#DD,#dd3_l,#dd3_l
	.long	#DD,#dd3f_l,#dd3f_l,#DD


#dd3_l
	.asg	7,N
	WLW	N,w3ondu1,F
	WLW	N,w3ondu2,F
	WLLW	-1,seq_strtdunk,w3ondu6,N*3+1
	WLW	N,w3ondu3,F
	WLW	N,w3ondu4,F
	WLW	N,w3ondu5,F
	WLW	1,w3ondu6,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w3ondu6,F
	WLW	N,w3ondu7,F
	WLW	30,w4modu8,F
	WL	-1,seq_stand3
	W0


#dd3f_l
	.asg	7,N
	WLW	N,w3ondu1,FF
	WLW	N,w3ondu2,FF
	WLLW	-1,seq_strtdunk,w3ondu6,N*3+1
	WLW	N,w3ondu3,FF
	WLW	N,w3ondu4,FF
	WLW	N,w3ondu5,FF
	WLW	1,w3ondu6,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w3ondu6,FF
	WLW	N,w3ondu7,FF
	WLW	30,w4modu8,FF
	WL	-1,seq_stand7
	W0


********************************


dunke_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#DD,#de3_l,#de3_l
	.long	#DD,#de3f_l,#de3f_l,#DD


#de3_l
	.asg	7,N
	WLW	N,w3twdu1,F
	WLW	N,w3twdu2,F
	WLLW	-1,seq_strtdunk,w3twdu7,N*4+1
	WLW	N,w3twdu3,F
	WLW	N,w3twdu4,F
	WLW	N,w3twdu5,F
	WLW	N,w3twdu6,F
	WLW	1,w3twdu7,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w3twdu7,F
	WLW	N,w3twdu8,F
	WLW	30,w3hang7,F
	WL	-1,seq_stand4
	W0


#de3f_l
	.asg	7,N
	WLW	N,w3twdu1,FF
	WLW	N,w3twdu2,FF
	WLLW	-1,seq_strtdunk,w3twdu7,N*4+1
	WLW	N,w3twdu3,FF
	WLW	N,w3twdu4,FF
	WLW	N,w3twdu5,FF
	WLW	N,w3twdu6,FF
	WLW	1,w3twdu7,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w3twdu7,FF
	WLW	N,w3twdu8,FF
	WLW	30,w3hang7,FF
	WL	-1,seq_stand4
	W0


********************************


dunkf_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#df2_l,#df2_l,#DD,#DD
	.long	#DD,#DD,#DD,#df2f_l


#df2_l
	.asg	7,N
	WLW	N,w1spdu1,F
	WLW	N,w1spdu2,F
	WLW	N,w1spdu3,F
	WLLW	-1,seq_strtdunk,w1spdu9,N*5+1
	WLW	N,w1spdu4,F
	WLW	N,w1spdu5,F
	WLW	N,w1spdu6,F
	WLW	N,w1spdu7,F
	WLW	N,w1spdu8,F
	WLW	1,w1spdu9,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w1spdu9,F
	WLW	N,w1spdu10,F
	WLW	30,w1spdu11,F
	WL	-1,seq_stand1
	W0

#df2f_l
	.asg	7,N
	WLW	N,w1spdu1,FF
	WLW	N,w1spdu2,FF
	WLW	N,w1spdu3,FF
	WLLW	-1,seq_strtdunk,w1spdu9,N*5+1
	WLW	N,w1spdu4,FF
	WLW	N,w1spdu5,FF
	WLW	N,w1spdu6,FF
	WLW	N,w1spdu7,FF
	WLW	N,w1spdu8,FF
	WLW	1,w1spdu9,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w1spdu9,FF
	WLW	N,w1spdu10,FF
	WLW	30,w1spdu11,FF
	WL	-1,seq_stand1
	W0



********************************


dunkg_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#DD,#DD,#dg4_l
	.long	#DD,#dg4f_l,#DD,#DD


#dg4_l
	.asg	7,N
	WLW	N,w4modu1,F
	WLW	N,w4modu2,F
	WLLW	-1,seq_strtdunk,w4stdu8,N*5+1
	WLW	N,w4stdu3,F
	WLW	N,w4stdu4,F
	WLW	N,w4stdu5,F
	WLW	N,w4stdu6,F
	WLW	N,w4stdu7,F
	WLW	1,w4stdu8,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w4stdu8,F
	WLW	N,w4stdu7,F
	WLW	N,w4stdu6,F
	WLW	30,w4stdu5,F
	WL	-1,seq_stand4
	W0


#dg4f_l
	.asg	7,N
	WLW	N,w4modu1,FF
	WLW	N,w4modu2,FF
	WLLW	-1,seq_strtdunk,w4stdu8,N*5+1
	WLW	N,w4stdu3,FF
	WLW	N,w4stdu4,FF
	WLW	N,w4stdu5,FF
	WLW	N,w4stdu6,FF
	WLW	N,w4stdu7,FF
	WLW	1,w4stdu8,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w4stdu8,FF
	WLW	N,w4stdu7,FF
	WLW	N,w4stdu6,FF
	WLW	30,w4stdu5,FF
	WL	-1,seq_stand4
	W0



********************************


dunkh_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#DD,#dh3_l,#dh3_l
	.long	#dh3_l,#dh3f_l,#dh3f_l,#DD


#dh3_l
	.asg	7,N
	WLW	N,w5uhdu1,F
	WLLW	-1,seq_strtdunk,w5uhdu7,N*5+1
	WLW	N,w5uhdu2,F
	WLW	N,w5uhdu3,F
	WLW	N,w5uhdu4,F
	WLW	N,w5uhdu5,F
	WLW	N,w5uhdu6,F
	WLW	1,w5uhdu7,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w5uhdu7,F
	WLW	N,w5uhdu8,F
	WLW	30,w5uhdu9,F
	WL	-1,seq_stand6			;4 flipped!
	W0


#dh3f_l
	.asg	7,N
	WLW	N,w5uhdu1,FF
	WLLW	-1,seq_strtdunk,w5uhdu7,N*5+1
	WLW	N,w5uhdu2,FF
	WLW	N,w5uhdu3,FF
	WLW	N,w5uhdu4,FF
	WLW	N,w5uhdu5,FF
	WLW	N,w5uhdu6,FF
	WLW	1,w5uhdu7,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w5uhdu7,FF
	WLW	N,w5uhdu8,FF
	WLW	30,w5uhdu9,FF
	WL	-1,seq_stand4
	W0



********************************


dunki_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#di3_l,#di3_l,#DD
	.long	#DD,#DD,#di3f_l,#di3f_l


#di3_l
	.asg	7,N
	WLW	N,w3sp2du1,F
	WLLW	-1,seq_strtdunk,w3spdu8,N*6+1
	WLW	N,w3sp2du2,F
	WLW	N,w3sp2du3,F
	WLW	N,w3sp2du4,F
	WLW	N,w3sp2du5,F
	WLW	N,w3sp2du6,F
	WLW	N,w3sp2du7,F
	WLW	1,w3sp2du8,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	8,w3sp2du8,F
	WLW	30,w3sp2du9,F
	WL	-1,seq_stand3
	W0

#di3f_l
	.asg	7,N
	WLW	N,w3sp2du1,FF
	WLLW	-1,seq_strtdunk,w3spdu8,N*6+1
	WLW	N,w3sp2du2,FF
	WLW	N,w3sp2du3,FF
	WLW	N,w3sp2du4,FF
	WLW	N,w3sp2du5,FF
	WLW	N,w3sp2du6,FF
	WLW	N,w3sp2du7,FF
	WLW	1,w3sp2du8,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	8,w3sp2du8,FF
	WLW	30,w3sp2du9,FF
	WL	-1,seq_stand7
	W0



********************************


dunkj_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#dj2_l,#dj2_l,#DD,#DD
	.long	#DD,#DD,#DD,#dj2f_l


#dj2_l
	.asg	7,N
	WLW	N,w2swdu1,F
	WLLW	-1,seq_strtdunk,w2swdu6,N*4+1
	WLW	N,w2swdu2,F
	WLW	N,w2swdu3,F
	WLW	N,w2swdu4,F
	WLW	N,w2swdu5,F
	WLW	1,w2swdu6,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w2swdu6,F
	WLW	N,w2swdu7,F
	WLW	N,w2swdu8,F
	WLW	30,w2swdu9,F
	WL	-1,seq_stand1
	W0


#dj2f_l
	.asg	7,N
	WLW	N,w2swdu1,FF
	WLLW	-1,seq_strtdunk,w2swdu6,N*4+1
	WLW	N,w2swdu2,FF
	WLW	N,w2swdu3,FF
	WLW	N,w2swdu4,FF
	WLW	N,w2swdu5,FF
	WLW	1,w2swdu6,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w2swdu6,FF
	WLW	N,w2swdu7,FF
	WLW	N,w2swdu8,FF
	WLW	30,w2swdu9,FF
	WL	-1,seq_stand1
	W0


********************************


dunkk_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#dk2_l,#DD,#DD
	.long	#DD,#DD,#DD,#dk2f_l


#dk2_l
	.asg	7,N
	WLW	N,w2jamdu1,F
	WLLW	-1,seq_strtdunk,w2jamdu5,N*3+1
	WLW	N,w2jamdu2,F
	WLW	N,w2jamdu3,F
	WLW	N,w2jamdu4,F
	WLW	1,w2jamdu5,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w2jamdu5,F
	WLW	30,w2jamdu6,F
	WL	-1,seq_stand2
	W0

#dk2f_l
	.asg	7,N
	WLW	N,w2jamdu1,FF
	WLLW	-1,seq_strtdunk,w2jamdu5,N*3+1
	WLW	N,w2jamdu2,FF
	WLW	N,w2jamdu3,FF
	WLW	N,w2jamdu4,FF
	WLW	1,w2jamdu5,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w2jamdu5,FF
	WLW	30,w2jamdu6,FF
	WL	-1,seq_stand8
	W0


********************************


dunkl_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#DD,#dl3_l,#DD
	.long	#DD,#DD,#dl3f_l,#DD


#dl3_l
	.asg	7,N
	WLW	N,w3flydu1,F
	WLLW	-1,seq_strtdunk,w3flydu7,N*5+1
	WLW	N,w3flydu2,F
	WLW	N,w3flydu3,F
	WLW	N,w3flydu4,F
	WLW	N,w3flydu5,F
	WLW	N,w3flydu6,F
	WLW	1,w3flydu7,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w3flydu7,F
	WLW	N,w3flydu8,F
	WLW	30,w3flydu9,F
	WL	-1,seq_stand3
	W0

#dl3f_l
	.asg	7,N
	WLW	N,w3flydu1,FF
	WLLW	-1,seq_strtdunk,w3flydu7,N*5+1
	WLW	N,w3flydu2,FF
	WLW	N,w3flydu3,FF
	WLW	N,w3flydu4,FF
	WLW	N,w3flydu5,FF
	WLW	N,w3flydu6,FF
	WLW	1,w3flydu7,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	4,w3flydu7,FF
	WLW	N,w3flydu8,FF
	WLW	30,w3flydu9,FF
	WL	-1,seq_stand7
	W0
********************************


dunkm_t
	.word	DUNK_M|JUMP_M
	.long	seq_stand
	.long	#DD,#DD,#dm3_l,#DD
	.long	#DD,#DD,#dm3f_l,#DD


#dm3_l
	.asg	7,N
	WLW	N,w3twdu1,F
	WLW	N,w3twdu2,F
	WLLW	-1,seq_strtdunk,w3twdu10,N*7+1
	WLW	N,w3twdu3,F
	WLW	N,w3twdu4,F
	WLW	N,w3twdu5,F
	WLW	N,w3twdu6,F
	WLW	N,w3twdu7,F
	WLW	N,w3twdu8,F
	WLW	N,w3twdu9,F
	WLW	1,w3twdu10,F

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	6,w3twdu10,F
	WLW	N,w3twdu11,F
	WL	-1,seq_stand4
	W0

#dm3f_l
	.asg	7,N
	WLW	N,w3twdu1,FF
	WLW	N,w3twdu2,FF
	WLLW	-1,seq_strtdunk,w3twdu10,N*7+1
	WLW	N,w3twdu3,FF
	WLW	N,w3twdu4,FF
	WLW	N,w3twdu5,FF
	WLW	N,w3twdu6,FF
	WLW	N,w3twdu7,FF
	WLW	N,w3twdu8,FF
	WLW	N,w3twdu9,FF
	WLW	1,w3twdu10,FF

	.asg	5,N
	WLW	-1,seq_slamball,0
	WLW	6,w3twdu10,FF
	WLW	N,w3twdu11,FF
	WL	-1,seq_stand6
	W0


































