	include	"definitions.i"

	global	se_start

	section	TEXT
se_start:
	jsr	clear_screen

	lda	#BLIT_CMD_ACTIVATE_CURSOR
	sta	BLIT_CR

.1	lda	CIA_AC				; do we have a character?
	beq	.1
	sta	BLIT_DATA			; yes, store it
	ldx	#BLIT_CMD_DEACTIVATE_CURSOR	; use xr to preserve ac
	stx	BLIT_CR
	cmp	#ASCII_LF			; is it LF?
	bne	.3
	ldx	#BLIT_CMD_INCREASE_CURSOR_POS
.2	stx	BLIT_CR
	lda	BLIT_CR
	and	#%01000000			; did we reach 1st position on line?
	beq	.2
	bra	.6
.3	cmp	#ASCII_CURSOR_RIGHT		; is it cursor right?
	bne	.4
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	bra	.6
.4	cmp	#ASCII_CURSOR_LEFT		; is it cursor left?
	bne	.5
	lda	#BLIT_CMD_DECREASE_CURSOR_POS
	sta	BLIT_CR
	bra	.6
.5	lda	#BLIT_CMD_PUT_SYMBOL_AT_CURSOR	; it's a normal character
	sta	BLIT_CR
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
.6	lda	#BLIT_CMD_ACTIVATE_CURSOR
	sta	BLIT_CR
	bra	.1


clear_screen:
	lda	#BLIT_CMD_RESET_CURSOR		; reset curs pos
	sta	BLIT_CR
	lda	#' '
	sta	BLIT_DATA
.1	lda	#BLIT_CMD_PUT_SYMBOL_AT_CURSOR
	sta	BLIT_CR
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR				; check for pos 0
	and	#%10000000
	beq	.1
	rts