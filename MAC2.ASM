*.Last mod - 2/20/92 21:08


BADCHK .MACRO 	reg,lo,hi,val
	cmpi	:lo:,reg
	jrlt	bad?
	cmpi	:hi:,reg
	jrgt	bad?
	jruc	ok?
bad?
	movi	:val:,:reg:
ok?
	.endm

*CLICK AN AUDIT COUNTER
AUDIT	.macro	P1
	MOVI	:P1:,A0	
	CALLA	AUD1
	.endm

*AUDIT A WORD LONG RAM LOCATION
*P1 = AUDIT
*P2 = RAM LOCATION
AUDITCNT .macro	P1,P2
	MOVE	@:P2:,A1
	MOVI	:P1:,A0
	CALLA	AUD
	.endm

*Get a game adjustment value in A0
ADJUST	.macro	P1
	MOVI	:P1:,A0
	CALLA	GET_ADJ
	.endm

*FCALL - Function call without using the system stack
FCALL	.macro	n,b
	movi	:n:,:b:,L
	exgpc	:b:
	.endm

*FRET - Function return without using the system stack
FRET	.macro	b
	exgpc	:b:
	.endm


******************************************************************************

RJR_STR	.macro	FONT,SPACING,CSPACE,X,Y,PALETTE,PR_METHOD
	.long	:FONT:
	.word   :SPACING:
	.word	:CSPACE:
	.word	:X:
	.word	:Y:
	.long   :PALETTE:
	.long   :PR_METHOD:
	.endm


******************************************************************************
;END
