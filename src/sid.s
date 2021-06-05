	include	"definitions.i"

	global	sid_reset
	global	sid_welcome_sound

	section	TEXT
sid_reset:
	ldx	#$00
.1	stz	SID,x
	inx
	cpx	#$80
	bne	.1
	lda	#$ff
	ldx	#$00
.2	sta	SIDM,x
	inx
	cpx	#$08
	bne	.2
	lda	#$0f
	sta	SID0V
	sta	SID1V
	rts

sid_welcome_sound:
	lda	#$c4
	sta	SID0FL
	lda	#$09
	sta	SID0FH
	lda	#%00001001
	sta	SID0AD
	lda	#$0f
	sta	SID0PL
	sta	SID0PH
	lda	#$ff
	sta	SIDM0L
	lda	#$10
	sta	SIDM0R
	lda	#%01000001
	sta	SID0VC

	lda	#$a2
	sta	SID1FL
	lda	#$0e
	sta	SID1FH
	lda	#%00001001
	sta	SID1AD
	lda	#$0f
	sta	SID1PL
	sta	SID1PH
	lda	#$10
	sta	SIDM1L
	lda	#$ff
	sta	SIDM1R
	lda	#%01000001
	sta	SID1VC

	rts
