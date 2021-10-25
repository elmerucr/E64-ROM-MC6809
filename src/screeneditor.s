	include	"definitions.i"

	global	se_init
	global	se_loop
	global	putchar
	global	puts

	section	TEXT
se_init:
	jsr	clear_screen

	lda	#BLIT_CMD_ACTIVATE_CURSOR
	sta	BLIT_CR
	rts

se_loop:
.1	lda	CIA_AC				; do we have a character?
	beq	.1
	sta	BLIT_DATA			; yes, store it
	ldb	#BLIT_CMD_DEACTIVATE_CURSOR	; use br to preserve ac
	stb	BLIT_CR

	cmpa	#ASCII_LF			; is it LF?
	bne	.3
	ldb	#BLIT_CMD_INCREASE_CURSOR_POS
.2	stb	BLIT_CR
	lda	BLIT_CR
	anda	#%01000000			; did we reach column 0?
	beq	.2
	bra	.10

.3	cmpa	#ASCII_CURSOR_RIGHT
	bne	.4
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	bra	.10

.4	cmpa	#ASCII_CURSOR_LEFT
	bne	.5
	lda	#BLIT_CMD_DECREASE_CURSOR_POS
	sta	BLIT_CR
	bra	.10

.5	cmpa	#ASCII_CURSOR_DOWN
	bne	.7
	lda	BLIT_PITCH
	ldb	#BLIT_CMD_INCREASE_CURSOR_POS
.6	stb	BLIT_CR
	deca
	bne	.6
	bra	.10

.7	cmpa	#ASCII_CURSOR_UP
	bne	.9
	lda	BLIT_PITCH
	ldb	#BLIT_CMD_DECREASE_CURSOR_POS
.8	stb	BLIT_CR
	deca
	bne	.8
	bra	.10

.9	lda	#BLIT_CMD_PUT_SYMBOL_AT_CURSOR	; it's a normal character
	sta	BLIT_CR
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	bsr	check_for_bottom_row

.10	lda	#BLIT_CMD_ACTIVATE_CURSOR
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
	anda	#%10000000
	beq	.1
	rts

check_for_bottom_row:
	lda	BLIT_CR
	anda	#%10000000			; reached position 0 on screen?
	beq	.1
	ldd	c64_lightblue
	std	BLIT_HBC
.1	rts

; putchar - expects char to be in ac
putchar:
	sta	BLIT_DATA
	lda	#BLIT_CMD_PUT_SYMBOL_AT_CURSOR
	sta	BLIT_CR
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	rts

; print string (0 terminated) - expects pointer in x
puts:
	pshs	a
.1	lda	,x+
	beq	.2
	jsr	putchar
	bra	.1
.2	puls	a
	rts
