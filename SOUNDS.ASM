;;CHECK line 202 and 266 (audits and adj. stuff)
;;MUST FIX SOUND WATCHDOG - I COMMENTED IT OUT
******************************************************************************
*
* Owner:	JOHNSON
*
* Software:	Jeff Johnson/Dan Thompson
* Initiated:		
*
* Modified:	Shawn Liptak,  9/30/91	-High speed version (Total carnage)
* 		Shawn Liptak,  1/8/92	-Reserved 8 channels
* 		Shawn Liptak,  2/19/92	-Basketball (cleanup)
* 		Shawn Liptak,  10/2/92	-TUNIT mods
*		Jamie Rivett,		-NBA JAM
*		Jeff Johnson,  4/12/95	-NBA 3 support for DCS snd board
*		JBJ,DJT       11/16/95	-Make it work for NBA HANGTIME
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 11/16/95 18:30
******************************************************************************
	.file	"sounds.asm"
	.title	"sound processor"
	.width	132
	.option	b,d,l,t
	.mnolist


	.include	"mproc.equ"
	.include	"sys.equ"
	.include	"game.equ"
	.include	"macros.hdr"
	.include	"audit.equ"


;--------------------
; Globals defined elsewhere

	.ref	_soundirq_addr
	.ref	_coin_counter_addr
	.ref	_sound_addr
	.ref	_coin_addr

	.ref	GET_ADJ
	.ref	PUT_ADJ
	.ref	F_ADC_S

	.ref	GAMSTATE

	.ref	AUD1
	.ref	gmqrtr


;--------------------
; Globals defined here

	.def	SNDSND
;	.def	FADE_UP,FADE_DOWN,ALLOFF

	.def	organ_fx1_sc,organ_fx2_sc
	.def	crwd_blchrs_sc,crwd_goteam_sc,crwd_defnse_sc

;--------------------
; Constants

	.asg	6000,SNDBRD_RES_CNT	;Sound board reset-cycle delay cnt

send	.set	>0001			; script command --> send sound code
setpri	.set	>0002			; script command --> set priority
endtune	.set	>0003			; script command --> end of tune script
sleep	.set	>0004			; script command --> sleep next byte
send2	.set	>0005
ex	.set	>8000			; flag: extended sound call !!


;--------------------
; Channel ram table

	.bss	channel_ram,0

	BSSX	chan1pri,16		; sound channel #1 priority
	BSSX	chan1dur,16		; sound channel #1 duration (timer)
	BSSX	chan1snd,16		; sound channel #1 current sound

	BSSX	chan2pri,16		; sound channel #2 priority
	BSSX	chan2dur,16		; sound channel #2 duration (timer)
	BSSX	chan2snd,16		; sound channel #2 current sound

	BSSX	chan3pri,16		; sound channel #3 priority
	BSSX	chan3dur,16		; sound channel #3 duration (timer)
	BSSX	chan3snd,16		; sound channel #3 current sound

	BSSX	chan4pri,16		; sound channel #4 priority
	BSSX	chan4dur,16		; sound channel #4 duration (timer)
	BSSX	chan4snd,16		; sound channel #4 current sound

	BSSX	chan5pri,16		; sound channel #4 priority
	BSSX	chan5dur,16		; sound channel #4 duration (timer)
	BSSX	chan5snd,16		; sound channel #4 current sound

	BSSX	chan6pri,16		; sound channel #4 priority
	BSSX	chan6dur,16		; sound channel #4 duration (timer)
	BSSX	chan6snd,16		; sound channel #4 current sound

	.bss	script_que,(32+16)*50	;sound/speech calls que
	.bss	script_que_end,0

	.bss	script_cur,32
	.bss	script_nxt,32
	.bss	script_dly,16

	.bss	channel_ram_end,0

	.asg	chan1pri-channel_ram,CHANPRI	; priority offset
	.asg	chan1dur-channel_ram,CHANDUR	; duration offset
	.asg	chan1scp-channel_ram,CHANSCP	; script pointer offset
	.asg	chan1snd-channel_ram,CHANSND	; current sound offset
	.asg	chan2pri-channel_ram,CHANSIZ	; current sound offset


;--------------------
;

	BSSX	sound_rev,16
	BSSX	SOUNDSUP ,16		;!0=Sounds off

	BSSX	doing_dcs_reset,16

;;;;	.bss	SNDSTR,6*CHANSIZ	;RESERVE STORAGE AREA
;;;;	.bss	SNDEND,0		;END OF SOUND PROCESSOR RAM


	.text


;
; sounds
;
;   sound table ptr. name, priority:channel, duration, snd nbr.
 SX	select_snd1, >0201,05, >310		;select option sound
 SX	select_snd2, >0202,05, >311
 SX	select_snd3, >0203,05, >312
 SX	select_snd4, >0204,05, >313
 SX	cursor_snd1, >0101,09, >30c	;cursor movement
 SX	cursor_snd2, >0102,09, >30d	;
 SX	cursor_snd3, >0103,09, >30e	;
 SX	cursor_snd4, >0104,09, >30f	;
 SX	win_snd,     >2504,75, >172	;Winner snd/Suckup credits
 SX	bounce_snd,  >0001,27, >260	;Ball bounce
 SX	plaque_fall1,>2501,91, >1f6
 SX	plaque_fall2,>2502,91, >1f7
 SX	plaque_fall3,>2503,91, >1f8
 SX	plaque_fall4,>2504,91, >1f9
 SX	plaque_land1,>2601,99, >3a3
 SX	plaque_land2,>2602,99, >3a4
 SX	plaque_land3,>2603,99, >3a5
 SX	plaque_land4,>2604,99, >3a6
 SX	opt_scr_cur, >1501,54, >1bd	;option screen
 SX	opt_scr_sel, >1501,30, >3fd  ;397 (PUT ON TRACK 5)
 SX	combo_lock1, >1101,45, >3fd
 SX	combo_lock2, >1102,45, >3fe
 SX	combo_lock3, >1103,45, >3ff
 SX	combo_lock4, >1104,45, >400
 SX	adv_stats,   >1001,15, >260
 SX	coin_snd,    >ff04,35, >255	;coin in melody snd
 SX	beep2_snd,   >0001,5,  >280	;beep tone for diagnostics
 SX	cntdown_snd, >1505,50, >20a	;buyin cntdwn clang
 SX	horn_snd,    >4001,120,>2fb	;horn
 SX	atrib_snd1,  >0101,10, >3bb
 SX	atrib_snd2,  >0101,10, >3bf
 SX	atrib_snd3,  >0101,10, >3c3
 SX	atrib_snd4,  >0101,10, >3c7
 SX	atrib_snd5,  >0101,10, >3cb
 SX	atrib_snd6,  >0101,10, >3cf
 SX	atrib_snd7,  >0101,10, >3d3
 SX	atrib_snd8,  >0101,10, >3d7
 SX	atrib_snd9,  >0101,10, >3db
 SX	atrib_snd10, >0101,10, >3df
 SX	yes_no_cur1, >1501,15, >33b
 SX	yes_no_cur2, >1502,15, >33c
 SX	yes_no_cur3, >1503,15, >33d
 SX	yes_no_cur4, >1504,15, >33e
 SX	yes_no_sel1, >1501,20, >268
 SX	yes_no_sel2, >1502,20, >269
 SX	yes_no_sel3, >1503,20, >26a
 SX	yes_no_sel4, >1504,20, >26b
 SX	butn_press,  >0103,15, >399
 SX	butn_press2, >0103,15, >399
 SX	cursor_up,   >0101,10, >1bd
 SX	cursor_dwn,  >0101,10, >1be
 SX	cursor_lft,  >0101,10, >33b
 SX	cursor_rgt,  >0101,10, >33b
 SX	chkmrk0_snd, >0103,20, >371
 SX	unchkmrk_snd,>0103,20, >371
 SX	chkmrk_snd,  >1501,20, >36f
 SX	chkmrk_snd2, >1502,20, >370
 SX	chkmrk_snd3, >1503,20, >371
 SX	chkmrk_snd4, >1504,20, >372
 SX	cursor_up2,  >0101,15, >33b
 SX	cursor_dwn2, >0101,15, >33b
 SX	cursor_lft2, >0101,25, >33b
 SX	cursor_rgt2, >0101,25, >33b
 SX	cursor_up3,  >0101,25, >33b
 SX	cursor_dwn3, >0101,25, >33b
 SX	whitsle_snd, >1504,45, >2f3
 SX	diag_cursor, >0101,27, >27c
 SX	diag_select, >0101,27, >280
 SX	bx_slide_snd,>0001,28, >1f6
 SX	update_adj,  >0501,27, >278
 SX	adj_menu_ext,>0501,27, >280
 SX	adj_menu_ent,>0501,27, >280
 SX	error_found, >4001,66, >367
 SX	tm_sel_cur1, >1501,36, >33b
 SX	tm_sel_cur2, >1502,36, >33c
 SX	tm_sel_hd_l1,>1501,47, >32b
 SX	tm_sel_hd_r1,>1501,47, >32b
 SX	tm_sel_hd_l2,>1502,47, >32c
 SX	tm_sel_hd_r2,>1502,47, >32c
 SX	tm_sel_sel1, >3201,65, >3fd   ;397
 SX	tm_sel_sel2, >3202,65, >3fe   ;398
 SX	tm_sel_ran1, >3001,116,>3f9
 SX	tm_sel_ran2, >3002,116,>3fa
 SX	sel_rndmend1,>3101,45, >3a3
 SX	sel_rndmend2,>3102,45, >3a4
 SX	tm_sel_stats,>0001,27, >260
 SX	combo_but1,  >1001,32, >36b
 SX	combo_but2,  >1002,32, >36c
 SX	combo_but3,  >1003,32, >36d
 SX	combo_but4,  >1004,32, >36e
 SX	powrup_awrd1,>2501,45, >222
 SX	powrup_awrd2,>2501,45, >222	;no track two
 SX	powrup_awrd3,>2503,45, >224
 SX	powrup_awrd4,>2504,45, >225
 SX	tick_snd,    >1504,20, >1fd
 SX	warn_snd,    >1504,20, >1fd
 SX	alert_snd,   >2704,50, >15e
 SX	ot_alert_snd,>2504,50, >3b6
 SX	infoex_snd,  >0501,18, >260
 SX	sqk1_snd,    >0103,25, >8b		;Sneaker squeek
 SX	sqk2_snd,    >0103,25, >8d
 SX	sqk3_snd,    >0103,25, >90
 SX	sqk4_snd,    >0103,25, >93
 SX	sqk5_snd,    >0103,25, >97
 SX	sqk6_snd,    >0103,25, >9a
 SX	scuf1_snd,   >0103,25, >b5
 SX	scuf2_snd,   >0103,25, >b6
 SX	scuf3_snd,   >0103,25, >b7
 SX	scuf4_snd,   >0103,25, >b8

 SX	fball_snd,   >1903,104,>2e2
 SX	fpass_snd,   >1903,85, >c9	;fire ball pass sound
 SX	rim_fire_snd,>350B,90, >cc
 SX	aly_pass_snd,>1903,104,>2e2

 SX	pass_snd,    >2001,20, >b9    	;147
 SX	swipe_snd,   >1401,20, >130
 SX	elbow1_snd,  >1901,35, >180
 SX	elbow2_snd,  >1901,35, >186
 SX	push1_snd,   >1101,30, >183
 SX	flail_snd,   >1501,30, >180
 SX	fall1_snd,   >1501,26, >183
 SX	land_snd,    >1501,35, >a2    ;(a4-tr3)
 SX	yell_snd,    >1201,100,>198

 SX	flsh1_snd,   >0501,19, >177
 SX	flsh3_snd,   >0503,19, >179
 SX	flsh4_snd,   >0504,19, >17a
 SX	boo_snd,     >1204,179,>1dd	;e6
 SX	boo1_snd,    >1204,179,>1dd	;e6
 SX	tip_snd,     >200C,23, >9e	;19f	;9b
 SX	eat_snd,     >8501,10, >37b	;**

 SX	organ1_snd,  >0504,75, >1a6
 SX	organ2_snd,  >0504,60, >1a8
 SX	organ3_snd,  >0504,50, >1aa
 SX	organ8_snd,  >0504,135,>1b4
 SX	organ9_snd,  >0504,98, >1b6
 SX	organ10_snd, >0504,100,>1b8

 SX	car_pass_snd,>1504,90, >1c7
 SX	siren_snd,   >1504,145,>1c9	;** TURN UP **
 SX	prop_ple_snd,>1504,100,>20c
 SX	chrch_bel_sp,>1504,140,>210
 SX	car_pas2_snd,>1504,130,>212
 SX	ambulne_snd, >1504,120,>214
 SX	ambulne2_snd,>1504,120,>216
 SX	fire_trk_snd,>1504,120,>218
; SX	train_snd,   >1504,145,>21a

 SX	crwd_blchrs, >1504,182,>1e5	;ed
 SX	crwd_go_team,>1504,101,>1f5	;f4
 SX	crwd_defence,>1504,186,>1e1	;eb

 SX	swish_snd1,  >310B,27, >83	;regular net
 SX	swish_snd2,  >310B,27, >84
 SX	swish_snd3,  >310B,27, >86
 SX	swish_snd4,  >310B,32, >af	;chain net (outdoor court)
 SX	swish_snd5,  >310B,32, >b0
 SX	swish_snd6,  >310B,32, >af

 SX	dunk_snd1,   >320B,58, >66
 SX	dunk_snd2,   >320B,54, >66
 SX	dunk_snd3,   >320B,56, >66
 SX	dunk_snd4,   >320B,48, >6c
 SX	dunk_snd5,   >320B,53, >ad	;outdoor court

 SX	spn_mv_snd,  >1503,30, >10f

 SX	miss1_snd,   >3103,32, >74
 SX	miss2_snd,   >3103,21, >75
 SX	miss3_snd,   >3103,23, >77
 SX	miss4_snd,   >3103,23, >77
 SX	miss5_snd,   >3103,25, >ae	;outdoor court
 SX	missd1_snd,  >3103,77, >11f

 SX	hitbkbd_snd, >1503,20, >70
 SX	hitbkbd2_snd,>1503,20, >82	;outdoor court

 SX	stealsb,     >200C,20, >9b
 SX	swat_snd,    >200C,20, >9b	;a3	;slap ball sound
 SX	intercept,   >3003,33, >169 ;16a
 SX	steal_snd,   >3003,33, >169 ;16a	;flash ball sound

 SX     dribble_snd, >1003,20, >6d ;64
 SX     dribble2_snd,>1004,23, >bf
 SX     dribble3_snd,>1003,20, >6e

 SX	trns1_snd,   >0501,29, >130
 SX	trns2_snd,   >0502,29, >139
 SX	trns3_snd,   >0503,29, >13e
 SX	trns4_snd,   >0504,29, >137
 SX	trnd1_snd,   >0601,30, >397
 SX	trnd2_snd,   >0602,30, >398
 SX	trnd3_snd,   >0603,30, >399
 SX	trnd4_snd,   >0604,30, >39a
 SX	untrns1_snd, >0901,29, >130
 SX	untrns2_snd, >0902,29, >139
 SX	untrns3_snd, >0903,29, >13e
 SX	untrns4_snd, >0904,29, >137


;MJT Start
 SX	robo_1_snd,  >3404,204, >bb0		;End wave snd
 SX	robo_2_snd,  >3404,109, >ba0		;Effect 1 - reward
 SX	robo_3_snd,  >3404,109, >bb4		;flash ABA ball white
;MJT End

;dunk sounds
 SX	jet4_snd,    >1203,70, >2f9
 SX	jet1_snd,    >1203,80, >108
 SX	jet2_snd,    >1203,80, >128
 SX	jet3_snd,    >1203,80, >126
 SX	tarzan,      >1203,70, >123
;
;tunes
;
 SX	tm_fire_tune,>0100,100,25
 SX	buyin_tune,  >0100,100,11
 SX	pregame_tune,>0100,100,13 ;1
 SX	tunegc_snd,  >0100,100,3  	;Grand champion play tune
 SX	tuneq1_snd,  >0100,100,5
 SX	tuneq1ed_snd,>0100,100,51
 SX	tuneq2_snd,  >0100,100,14
 SX	tuneq2ed_snd,>0100,100,53
 SX	tuneq3_snd,  >0100,100,5
 SX	tuneq3ed_snd,>0100,100,51
 SX	tuneq4_snd,  >0100,100,14
 SX	tuneq4ed_snd,>0100,100,51
 SX	tuneot_snd,  >0100,100,5
 SX	tuneoted_snd,>0100,100,51

 SX	tune_wingame,>0100,100,24
 SX	tune_gmovr,  >0100,100,18
 SX	hangtime_snd,>0100,100,19

 SX	tunehalf_snd,>0100,100,39	;halftime tune
 SX	tune_cap_snd,>0100,100,7	;create-a-player tune
 SX	tuneend_snd, >0100,100,0	;kill any tune


;
; scripts
;
organ_fx1_sc   LWLWLW   organ1_snd,75,organ2_snd,60,organ3_snd,-1
organ_fx2_sc   LWLWLW	organ8_snd,135,organ9_snd,98,organ10_snd,-1
crwd_blchrs_sc LW	crwd_blchrs,-1
crwd_goteam_sc LWLW	crwd_go_team,102,crwd_go_team,-1
crwd_defnse_sc LWLW	crwd_defence,102,crwd_defence,-1


#*****************************************************************************
*												*
* reset sound board										*
*												*
* this is a full reset, checksum dings and all. this is the same routine
* that was in the old (gspsnd) processor. (ed boon)
*
* NOTE: If any data are sent to the sound board within ~270msec of the
*       reset signal, diagnostics will be skipped and there won't be any
*       loud and annoying bongs.
*

 SUBR	snd_reset
	PUSH	a0,a1

	movi	SNDRSTBIT|32,a0
	move	@_coin_counter_addr,a1,L
	move	a0,*a1

	movi	SNDBRD_RES_CNT,a0		;Wait for it to catch
	dsjs	a0,$

	movi	32,a0
	move	@_coin_counter_addr,a1,L
	move	a0,*a1

	PULL	a0,a1
	rets


#*****************************************************************************
*
*
 SUBR	watch_snd_reset

	move	@_soundirq_addr,a8
wsr_1
 	SLEEPK	1

	move	*a8,a0
	btst	10,a0
	jrz	wsr_1			; done?
	LOCKUP
wsr_2
	SLEEPK	1

	move	*a8,a0
	btst	10,a0
	jrnz	wsr_2			; done?

	jruc	wsr_1
 	

#*****************************************************************************
*
* Quiet sound board reset
*
* Just like snd_reset, but without the diagnostic tests and consequent chimes.
* It also sets the volume to the CMOS level.
* 
* NOTE: Don't CALLx this function, JSRP it.  It SLEEPs.
*
* Trashes everything except the reggies which get saved by default when
* you sleep...

 SUBR	QSNDRST

	movk	1,a14
	move	a14,@doing_dcs_reset

	movi	SNDRSTBIT|32,a0
	move	@_coin_counter_addr,a1,L
	move	a0,*a1

	movi	SNDBRD_RES_CNT,a0		;Wait for it to catch
	dsjs	a0,$

	movi	32,a0
	move	@_coin_counter_addr,a1,L
	move	a0,*a1

	SLEEPK	2
	move	@_sound_addr,a0,L
	movb	a14,*a0

	SLEEPK	4
	movi	ADJVOLUME,a0
	calla	GET_ADJ

	BADCHK	a0,0,255,28			;reg, lo, hi, val if bad
	callr	set_volume			;Set master vol to CMOS level

	callr	clear_sound_ram

	clr	a14
	move	a14,@doing_dcs_reset

	RETP


#*****************************************************************************
* Sets the volume of the DCS.
* >a0=volume (0-255)
*
 SUBR	set_game_snd

	PUSH	a0

	movi	ADJVOLUME,a0
	calla	GET_ADJ

	BADCHK	a0,0,255,28			;reg, lo, hi, val if bad
	callr	set_volume			;Set master vol to CMOS level
	PULL	a0
 	rets

#*****************************************************************************
* PROCESS that quietly resets the sound board, then dies.  Useful when you
* don't feel like waiting for the reset to finish before you move on.

 SUBR	qsndrst_proc

	JSRP	QSNDRST
	DIE


#*****************************************************************************
* Sets the volume of the DCS.
* >a0=volume (0-255)
*

 SUBR	set_volume

	PUSH	a0,a1,a3

	andi	0FFh,a0			;forces value into range
	movi	55AAh,a3
	callr	SNDSND
	
	move	a0,a3			; volume
	move	a0,a1
	not	a1			; sans volume
	sll	32-8,a1
	srl	32-8,a1
	sll	8,a3
	or	a1,a3			; a3 = [volume,sans volume]
	callr	SNDSND

	move	a0,a1
	movi	ADJVOLUME,a0
	calla	PUT_ADJ
	calla	F_ADC_S

	PULL	a0,a1,a3
	rets

#*****************************************************************************
* Sets the volume of the DCS (for attract mode).
* >a0=volume (0-255)
*

 SUBR	set_volume_for_amode
 	
	movi	ADJAVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad


 SUBR	set_volume_amode_diag

	PUSH	a0,a1,a3

	andi	0FFh,a0			;forces value into range
	movi	55AAh,a3
	callr	SNDSND
	
	move	a0,a3			; volume
	move	a0,a1
	not	a1			; sans volume
	sll	32-8,a1
	srl	32-8,a1
	sll	8,a3
	or	a1,a3			; a3 = [volume,sans volume]
	callr	SNDSND

	move	a0,a1
	movi	ADJAVOLUME,a0
	calla	PUT_ADJ
	calla	F_ADC_S

	PULL	a0,a1,a3
	rets


#*****************************************************************************
* Raw hardware sound call.
* >a3=sound code

 SUBR	SNDSND

	PUSH	a0,a1,a2,a3,a4
	move	@SOUNDSUP,a0		; are we allowed ??
	jrnz	sendx			; no

	move	a3,a3			; is it a null call (negative)?
	jrn	sendx

	move	a3,a0
	sll	32-16,a3
	srl	32-8,a3			; a3 = high byte
*
* send high byte
*
	move	@_sound_addr,a4,L
	move	a3,*a4

;	movk	2,a2
	movk	5,a2
	dsj	a2,$			; time for signal to get through
 	callr	poll_sirq
*
* send low byte
*
	sll	32-8,a0
	srl	32-8,a0			; a3 = low byte
	move	@_sound_addr,a4,L
	move	a0,*a4

	callr	poll_sirq

sendx	PULL	a0,a1,a2,a3,a4
	rets


#*****************************************************************************
* Poll sound IRQ.  When IRQ goes high, sound board is ready for next call.
* Do timeout so sound board can't screw things up.

 SUBRP	poll_sirq

	movi	390/3,a4		; 180 micros max firq delay on snd board
#poll3
	move	@_soundirq_addr,a1,L
	addi	(B_SIRQ-7),a1
	movb	*a1,a1
	jrn	#poll9			; done?
	dsj	a4,#poll3
#poll9
	rets


	.asg	0,CHAN_PRI
	.asg	16,CHAN_DUR
	.asg	32,CHAN_SND

********************************
* Plays a sound once, overriding any current lower priority sound
* A0=* to sound data
* Trashes scratch

 SUBR	snd_play1ovrp
 SUBR	snd_play1ovr
 	rets

#******************************************************************************
* Plays a list of sounds
*
* A0=* to sound data
* Trashes scratch

 SUBR	script_play1

	PUSH	a1,a2,a3
;
;If the first sound call of script has a lower priority than the current sound
; playing..then don't que this script
;
	move	*a0,a2,L			;get first sound call ptr
	move	*a2,a1				;get priority:channel
	andi	7,a1				;get channel number
	sll	4,a1
	move	a1,a14
	add	a14,a14
	add	a14,a1
	addi	channel_ram,a1			;pt to ram to change

	move	*a1(CHAN_DUR),a14		;get time remaining
	jrz	#scrpt				;br=channel clear...
	move	*a1(CHAN_PRI),a14		;priority:chnl of snd playing
	srl	8,a14				;get priority
	move	*a2,a1				;priority:chnl of script
	srl	8,a1				;get priority
	cmp	a1,a14
	jrge	#spexit				;br=cant interupt snd

#scrpt
	move	@script_cur,a1,L
	move	@script_nxt,a2,L
	jrnz	#sp0
	movi	script_que,a14,L
	move	a14,a1	
	move	a14,a2	
	move	a1,@script_cur,L
	move	a2,@script_nxt,L
#sp0
	move	a0,a3
	jruc	#sp2
;will script fit in que ?
#sp1
	cmpi	script_que_end,a2,L
	jrne	#sp1a
	movi	script_que,a2,L
#sp1a
	cmp	a2,a1
	jrne	#sp2
	.if DEBUG
	LOCKUP
	.endif
	jruc	#spexit
#sp2
	addk	32,a3
	addi	48,a2
	move	*a3+,a14
	jrnn	#sp1

	move	@script_nxt,a2,L

#sp3
;copy script into que
	move	*a0+,a3,L
	jrn	#dbsp1
	.if DEBUG
	LOCKUP
	.endif
	jruc	#spexit
#dbsp1
	move	a3,*a2+,L			;get sound call ptr

	.if DEBUG
	move	*a3,a14,W
	cmpi	>ff0A,a14			;invalid priority:channel ?
	jrgt	#dbsp2				;br=yep
	move	*a3(16),a14,W
	cmpi	314,a14				;invalid duration ?
	jrhs	#dbsp2				;br=yep
	move	*a3(32),a14,W
	cmpi	>c00,a14			;invalid sound call nbr. ?
	jrlo	#dbsp3				;br=no
#dbsp2
	LOCKUP
	jruc	#spexit

#dbsp3
	.endif
	move	*a0+,a14			;get delay (or end of script maker)			;get sound call ptr
	jrn	#sp4
	move	a14,*a2+,W
	cmpi	script_que_end,a2,L
	jrne	#sp3
	movi	script_que,a2,L
	jruc	#sp3
#sp4
	move	*a3(16),a14,W
	move	a14,*a2+,W
	cmpi	script_que_end,a2,L
	jrne	#sp4a
	movi	script_que,a2,L
#sp4a
	move	a2,@script_nxt,L
#spexit
	PULL	a1,a2,a3
 	rets


#******************************************************************************
* Plays a sounds
*
* A0=* to sound data
* Trashes scratch

 SUBR	snd_play1

	PUSH	a0,a1,a2,a3,a4

	move	*a0+,a1			;get priority:channel
	move	*a0+,a2			;get snd duration
	move	*a0,a3			;get sound #

	move	a1,a4
	andi	7,a4			;get channel number

	cmpi	6,a4				;invalid priority:channel ?
	jrlt	#valid				;br=yep
	.if DEBUG
	LOCKUP
	.endif
	jruc	#done
#valid
	sll	4,a4
	move	a4,a14
	add	a14,a14
	add	a14,a4
	addi	channel_ram,a4			;pt to ram to change

	move	*a4(CHAN_DUR),a14
	jrz	#play_it
	move	*a4,a14				;get priority of snd playing
;	jrn	#done				;br=cant interupt snd

	.if DEBUG
	cmpi	>ff0A,a1			;invalid priority:channel ?
	jrgt	#lckup				;br=yep
	cmpi	800,a2				;invalid duration ?
	jrhs	#lckup				;br=yep
	cmpi	>c00,a3				;invalid sound call nbr. ?
	jrlo	#valok				;br=no
#lckup
	LOCKUP
	jruc	#done
#valok
	.endif

	move	a1,a0
	srl	8,a0
	srl	8,a14
	cmp	a14,a0				;new snd have > priority ?
	jrlt	#done				;br=no
	jrgt	#play_it			;br=yep
	move	*a4,a14				;get priority of snd playing
	btst	3,a14				;is sound interuptable ?
	jrnz	#done				;br=no
#play_it
	move	a1,*a4+				;priority:channel
	move	a2,*a4+				;duration
	move	a3,*a4				;sound call number
 	callr	SNDSND
#done
	PULL	a0,a1,a2,a3,a4
	rets


********************************
* Sound processor called every main loop (16 MSEC)
* Trashes scratch, A2-A3

 SUBR	snd_update

	move	@chan1dur,a0,W			; channel #1 timing down ?
	jrz	#sup2				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan1dur,W			; update duration ram
#sup2
	move	@chan2dur,a0,W			; channel #2 timing down ?
	jrz	#sup3				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan2dur,W			; update duration ram
#sup3
	move	@chan3dur,a0,W			; channel #3 timing down ?
	jrz	#sup4				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan3dur,W			; update duration ram
#sup4
	move	@chan4dur,a0,W			; channel #4 timing down ?
	jrz	#sup5				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan4dur,W			; update duration ram
#sup5
	move	@chan5dur,a0,W			; channel #5 timing down ?
	jrz	#sup6				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan5dur,W			; update duration ram
#sup6
	move	@chan6dur,a0,W			; channel #6 timing down ?
	jrz	#sup7				; nope....
	dec	a0				; yes, count this tick !!
	move	a0,@chan6dur,W			; update duration ram
#sup7
	move	@script_dly,a0,W
	jrz	#sup7aa
	dec	a0
	move	a0,@script_dly,W		; update duration ram
	rets

#sup7aa
     	move	@script_cur,a1,L
	move	@script_nxt,a2,L
	jrnz	#sup7a
	movi	script_que,a14,L
	move	a14,@script_cur,L
	move	a14,@script_nxt,L
	rets
#sup7a
	move	*a1,a0,L			;get script table ptr
	jrz	#exit
	clr	a14
	move	a14,*a1+,L
	move	*a1+,a14       			;get sound table ptr
	move	a14,@script_dly
	callr	snd_play1

	cmpi	script_que_end,a1,L
	jrne	#sup7b
	movi	script_que,a1,L
#sup7b	
	move	a1,@script_cur,L
#exit
	rets


#*****************************************************************************
*  nosounds
*
*  cancels all sound calls. zeros all priorities and stops all
*  currently running tunes.
*

 SUBR	nosounds

	PUSH	a0,a1
	clr	a3
	callr	SNDSND			; silence the music board

	callr	clear_sound_ram

	PULL	a0,a1
	rets


#*****************************************************************************
*
*

 SUBRP	clear_sound_ram

	clr	a0
	movi	channel_ram,a1
nos2
	move	a0,*a1+,W		; zero u out !!!
	cmpi	channel_ram_end,a1	; everyone cleared ??
	jrne	nos2			; nope, do more

;clear SCRIPT ram
	clr	a14
	move	a14,@script_que,L
	move	a14,@script_que+32,L
	move	a14,@script_que+64,L
	move	a14,@script_que+96,L
	move	a14,@script_que+128,L
	move	a14,@script_que+160,L

	movi	script_que,a14,L
	move	a14,@script_cur,L
	move	a14,@script_nxt,L
	rets


;**************************************************************************
;*                                                                        *
;* FADE_UP - PROCESS TO FADE THE SOUND UP				 *
;* A11 = FADE RATE							 *
;*                                                                        *
;**************************************************************************
;FADE_UP
;	MOVI	FADE_UP_TAB,A8
;	JRUC	FADER
;**************************************************************************
;*                                                                        *
;* FADE_DOWN - PROCESS TO FADE THE SOUND UP				 *
;* A11 = FADE RATE							 *
;*                                                                        *
;**************************************************************************
;FADE_DOWN
;	MOVI	FADE_DOWN_TAB,A8
;	JRUC	FADER
;
;FADER
;	MOVI	FADEPID,A0
;	CLR	A1
;	NOT	A1
;	CALLA	KILALL			;WASTE ANY OTHER FADERS
;FADE_LP
;	MOVE	*A8+,A0,L
;	JRZ	FADE_DONE
;	callr	snd_play1
;	SLOOPR	A11,FADE_LP
;FADE_DONE
;	DIE
;
;FADE_UP_TAB
;	.LONG	VOLUME0
;	.LONG	VOLUME1
;	.LONG	VOLUME2
;	.LONG	VOLUME3
;	.LONG	VOLUME4
;	.LONG	VOLUME5
;	.LONG	VOLUME6
;	.LONG	VOLUME7
;	.LONG	VOLUME8
;	.LONG	VOLUME9
;	.LONG	VOLUMEA
;	.LONG	VOLUMEB
;	.LONG	VOLUMEC
;	.LONG	VOLUMED
;	.LONG	VOLUMEE
;	.LONG	VOLUMEF
;	.LONG	0
;
;FADE_DOWN_TAB
;	.LONG	VOLUMEF
;	.LONG	VOLUMEE
;	.LONG	VOLUMED
;	.LONG	VOLUMEC
;	.LONG	VOLUMEB
;	.LONG	VOLUMEA
;	.LONG	VOLUME9
;	.LONG	VOLUME8
;	.LONG	VOLUME7
;	.LONG	VOLUME6
;	.LONG	VOLUME5
;	.LONG	VOLUME4
;	.LONG	VOLUME3
;	.LONG	VOLUME2
;	.LONG	VOLUME1
;	.LONG	VOLUME0
;	.LONG	0
;
;
;**************************************************************************
;* POPULAR SOUND CALLS
;
;*HIGH PRIORITY OFF CODES, NOTHING SHOULD BEAT THESE
;CVSDOFF		.WORD	>F0FF|>800,>01,>8000,0	;CVSD BACKGROUND LOOP OFF
;CVSDFOFF 	.WORD	>F0FF|>800,>01,>8000,0	;CVSD FOREGROUND LOOP OFF
;SOUNDOFF 	.WORD	>F0FF|>800,>01,>8000,0	;TURN SOUND SIDE OFF
;ALLOFF	 	.WORD	>F3FF|>800,>01,>8000,0	;MUSIC AND EFFECTS OFF
;MUSITOFF	.WORD	>F3FF|>800,>01,>8040,0	;MUSIC TRANSITION OFF
;
;VOLUME0	.WORD	>F3FE,>1,>802F,0
;VOLUME1	.WORD	>F3FE,>1,>802E,0
;VOLUME2	.WORD	>F3FE,>1,>802D,0
;VOLUME3	.WORD	>F3FE,>1,>802C,0
;VOLUME4	.WORD	>F3FE,>1,>802B,0
;VOLUME5	.WORD	>F3FE,>1,>802A,0
;VOLUME6	.WORD	>F3FE,>1,>8029,0
;VOLUME7	.WORD	>F3FE,>1,>8028,0
;VOLUME8	.WORD	>F3FE,>1,>8027,0
;VOLUME9	.WORD	>F3FE,>1,>8026,0
;VOLUMEA	.WORD	>F3FE,>1,>8025,0
;VOLUMEB	.WORD	>F3FE,>1,>8024,0
;VOLUMEC	.WORD	>F3FE,>1,>8023,0
;VOLUMED	.WORD	>F3FE,>1,>8022,0
;VOLUMEE	.WORD	>F3FE,>1,>8021,0
;VOLUMEF	.WORD	>F3FE,>1,>8020,0




#*****************************************************************************
* saves 16 bits in a3

;	.if DEBUG
;
; SUBRP	save_sound
;
;	PUSH	a1,a2
;
;	cmpi	EXTENDED_CODE,a3	;extended?
;	jreq	#nosave
;
;	move	@slist_offset,a1
;	inc	a1
;	andi	31,a1
;	move	a1,@slist_offset
;	sll	4,a1		;*16
;	addi	sounds_list,a1
;	move	a3,*a1+		;save it
;
;	movi	0ffffh,a2
;	move	@slist_offset,a1
;	inc	a1
;	andi	31,a1
;	sll	4,a1		;*16
;	addi	sounds_list,a1
;	move	a2,*a1		;mark end of buffer
;
;#nosave
;	PULL	a1,a2
;	rets
;
;	.endif

#*****************************************************************************

; SUBR	set_sound_rev
;
;
;	RETP


#*****************************************************************************
 SUBR	sound_watchdog

;;;;;;;;;;TEMP
	DIE
;;;;;;;;;;TEMP

	SLEEPK	1
	move	@SOUNDR,a0		;clear sound data available latch
	movi	0ffaah,a3		;Pull sound section interrupt
	move	a3,@SOUND		;Hit sound (LOW)
	SLEEPK	8
	movb	@SOUNDR,a3
	move	a3,@sound_rev		;determine snd board rev.
#watchdog_loop
	SLEEP	60
	movi	0ffaah,a3		;Pull sound section interrupt
	move	a3,@SOUND		;Hit sound (LOW)
	movk	8,a14
	dsj	a14,$			;Slow it down a bit

	.if	0
	movi	390/3,a3		;180 micros max firq delay on snd board
#lp1	movb	@SOUNDIRQ+B_SIRQ-7,a14
	jrn	#ok1			;Done?
	dsj	a3,#lp1
*		timed out, irq must be dead!
* ERROR #1
	movi	AUD_SNDERR1,a0		;log it
	calla	AUD1
	jruc	#reset_board
	.endif

#ok1
	move	@sound_rev,a0		;if old sound board software
	cmpi	05ah,a0			;then skip these two checks
	jrne	sound_watchdog
	SLEEPK	8			;approx 128 msec delay
	movb	@SOUNDIRQ+B_SDAV-7,a14
	jrn	#ok2

*		sound data not available
* ERROR #2
	movi	AUD_SNDERR,a0		;log it
	calla	AUD1
	jruc	#reset_board
#ok2
	movb	@SOUNDR,a3
	cmpi	05ah,a3
	jreq	#watchdog_loop

*		invalid read back value
* ERROR #3
	movi	AUD_SNDERR,a0		;log it
	calla	AUD1
#reset_board

;	callr	QSNDRST			;quiet hardware sound board reset
	JSRP	QSNDRST

	SLEEP	90
	move	@gmqrtr,a0
	sll	5,a0
	addi	#tune_t,a0
	move	*a0,a0,L
	calla	snd_play1ovr

	jruc	#watchdog_loop


#tune_t	.long	tuneq2_snd,tuneq2_snd,tuneq3_snd,tuneq4_snd,tuneot_snd
	.long	tuneot_snd,tuneot_snd,tuneot_snd,tuneot_snd
	.long	tuneot_snd,tuneot_snd,tuneot_snd,tuneot_snd


#*****************************************************************************

VOLDN	.equ	11
VOLUP	.equ	12

 SUBR	VOLBTN_PRESS

	;in diagnostics?
	move	@GAMSTATE,a0,W
	jrn	#done

	;already adjusting?
	movi	VOLADJ_PID,a0
	movi	0FFFFh,a1
	calla	EXISTP
	jrnz	#done

	;okay, adjust
	movi	VOLADJ_PID,a14
	move	a14,*a13(PROCID),W

;	move	@COINS,a0
	move	@_coin_addr,a0,L
	move	*a0,a0
	btst	VOLDN,a0
	jrz	#voldn_loop
#volup_loop
	;increment the volume
	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	inc	a0
	cmpi	255,a0
	jrle	#up_okay
	movi	255,a0
#up_okay
	calla	set_volume
	SLEEPK	1

	;if the vol+ button is no longer down, die
;	move	@COINS,a0
	move	@_coin_addr,a0,L
	move	*a0,a0
	btst	VOLUP,a0
	jrnz	#done
	jruc	#volup_loop

#voldn_loop
	;decrement the volume
	movi	ADJVOLUME,a0
	calla	GET_ADJ
	BADCHK	a0,0,255,28		;reg, lo, hi, val if bad
	dec	a0
	jrnn	#dn_okay
	clr	a0
#dn_okay
	calla	set_volume
	SLEEPK	1

	;if the vol- button is no longer down, die
;	move	@COINS,a0
	move	@_coin_addr,a0,L
	move	*a0,a0
	btst	VOLDN,a0
	jrnz	#done
	jruc	#voldn_loop
#done	DIE

******************************************************************************
	.end


