	include	"definitions.i"

	global	pusha
	global	pulla

	section	TEXT

pusha:
	sta	(DSP)	; store accumulator on stack
	phx
	ldx	DSP	; load lsb
	beq	.1	; if zero, deal with both bytes
	dec	DSP
	plx
	rts
.1	dec	DSP
	dec	DSP+1
	plx
	rts

pulla:
	inc	DSP
	bne	.1
	inc	DSP+1
.1	lda	(DSP)
	rts