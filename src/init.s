	include	"defs.i"

	global	cold_start

	section	BSS
var1	dc	1

	section	TEXT
cold_start:
	; Because of reset exception, sp goes to $fd, let's 'restore'
	; this to $ff so full stack is available.
	ldx	#$ff
	txs

	; Set up border size and color
	lda	#$10
	sta	BLIT_HBS
	lda	#C64_BLACK_LB
	sta	BLIT_HBC_LB
	lda	#C64_BLACK_HB
	sta	BLIT_HBC_HB
	lda	#C64_BLUE_LB
	sta	BLIT_CLC_LB
	lda	#C64_BLUE_HB
	sta	BLIT_CLC_HB

	; sids
	jsr	sid_reset
	jsr	sid_welcome_sound

	; turn on interrupts
	cli

.1	inc	$d021
	jsr	functie
	sta	var1
	jmp	.1
