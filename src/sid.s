		include	"definitions.i"

		global	sid_reset
		global	sid_welcome_sound

		section	TEXT

sid_reset:	pshs	y,x,a	; do sid0 and sid1
		ldx	#$0040
		ldy	#SID
.1		clr	,y+
		leax	-1,x
		bne	.1

		; analog???

		lda	#$ff	; mixer cleared
		ldx	#$0008
		ldy	#SIDM
.2		sta	,y+
		leax	-1,x
		bne	.2

		lda	#$0f	; set sid volumes to max
		sta	SID0V
		sta	SID1V
		puls	y,x,a
		rts

sid_welcome_sound:
		pshs	b,a
		ldd	music_notes+N_D3_
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

		ldd	music_notes+N_A3_
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

		puls	b,a
		rts
