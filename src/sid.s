	include	"definitions.i"

	global	sid_reset
	global	sid_welcome_sound

	section	TEXT
sid_reset:
	ldx	#$0000
.1	clr	SID,x
	leax	1,x
	cmpx	#$0080
	bne	.1
	lda	#$ff
	ldx	#$0000
.2	sta	SIDM,x
	leax	1,x
	cmpx	#$0008
	bne	.2
	lda	#$0f
	sta	SID0V
	sta	SID1V
	rts

sid_welcome_sound:
	ldd	#$09c4
	std	SID0F
	lda	#%00001001
	sta	SID0AD
	ldd	#$0f0f
	std	SID0P
	lda	#$ff
	sta	SIDM0L
	lda	#$10
	sta	SIDM0R
	lda	#%01000001
	sta	SID0VC

	ldd	#$0ea2
	std	SID1F
	lda	#%00001001
	sta	SID1AD
	ldd	#$0f0f
	sta	SID1P
	lda	#$10
	sta	SIDM1L
	lda	#$ff
	sta	SIDM1R
	lda	#%01000001
	sta	SID1VC

	rts
