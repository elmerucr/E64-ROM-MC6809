	include	"definitions.i"

	global	se_init
	global	se_loop
	global	putchar
	global	puts

	section	TEXT
se_init:
	pshs	a
	jsr	clear_screen
	lda	#BLIT_CMD_ACTIVATE_CURSOR
	sta	BLIT_CR
	puls	a
	rts

se_loop:
	lda	CIA_AC				; do we have a character?
	beq	se_loop
	ldb	#BLIT_CMD_DEACTIVATE_CURSOR	; use br to preserve ac
	stb	BLIT_CR
	jsr	putchar
	bra	se_loop

clear_screen:
	pshs	a
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
	puls	a
	rts

add_bottom_row:
	pshs	y,x,b,a
	ldd	BLIT_CURSOR_POS
	pshs	b,a			; save old cursor pos
	ldx	#$0000
	tfr	x,y			; y points to first row
	ldb	BLIT_PITCH
	abx				; x points to second row

.1	stx	BLIT_CURSOR_POS
	lda	BLIT_TILE_CHAR
	sty	BLIT_CURSOR_POS
	sta	BLIT_TILE_CHAR
	stx	BLIT_CURSOR_POS
	ldd	BLIT_TILE_FG_COLOR
	sty	BLIT_CURSOR_POS
	std	BLIT_TILE_FG_COLOR
	stx	BLIT_CURSOR_POS
	ldd	BLIT_TILE_BG_COLOR
	sty	BLIT_CURSOR_POS
	std	BLIT_TILE_BG_COLOR

	leax	1,x
	leay	1,y
	cmpx	BLIT_NO_OF_TILES
	bne	.1
	sty	BLIT_CURSOR_POS
	lda	#' '
	sta	BLIT_DATA
	ldb	BLIT_PITCH
.2	lda	#BLIT_CMD_PUT_SYMBOL_AT_CURSOR
	sta	BLIT_CR
	decb
	beq	.3
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	bra	.2
.3	puls	b,a			; get old cursor pos
	std	BLIT_CURSOR_POS		; and put it back
	ldb	BLIT_PITCH
	lda	#BLIT_CMD_DECREASE_CURSOR_POS
.4	sta	BLIT_CR
	decb
	bne	.4
	puls	y,x,b,a
	rts

add_top_row:
	pshs	b,a
	ldd	c64_lightblue
	std	BLIT_HBC
	puls	b,a
	rts

; putsymbol - expects char to be in ac
; doesn't change registers
putsymbol:
	sta	BLIT_DATA
	lda	#BLIT_CMD_PUT_SYMBOL_AT_CURSOR
	sta	BLIT_CR
	lda	BLIT_DATA	; restore ac
	rts

putchar:
is_lf	cmpa	#ASCII_LF
	bne	is_cr
	ldb	#BLIT_CMD_INCREASE_CURSOR_POS
.1	stb	BLIT_CR
	lda	BLIT_CR
	bita	#%01000000	; did we reach column 0?
	beq	.1
	bita	#%00100000	; did we reach end of screen?
	beq	finish
	jsr	add_bottom_row
	bra	finish
is_cr	cmpa	#ASCII_CURSOR_RIGHT
	bne	is_cl
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	bita	#%00100000	; did we cross end of screen?
	beq	finish
	jsr	add_bottom_row
	bra	finish
is_cl	cmpa	#ASCII_CURSOR_LEFT
	bne	is_cd
	lda	#BLIT_CMD_DECREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	bita	#%00100000	; did we cross start of screen?
	beq	finish
	jsr	add_top_row
	bra	finish
is_cd	cmpa	#ASCII_CURSOR_DOWN
	bne	is_cu
	ldb	BLIT_PITCH
.1	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	bita	#%00100000	; did we cross end of screen?
	beq	.2
	jsr	add_bottom_row
.2	decb
	bne	.1
	bra	finish
is_cu	cmpa	#ASCII_CURSOR_UP
	bne	is_sym
	ldb	BLIT_PITCH
.1	lda	#BLIT_CMD_DECREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	bita	#%00100000	; did we cross start of screen?
	beq	.2
	jsr	add_top_row
.2	decb
	bne	.1
	bra	finish
is_sym	jsr	putsymbol
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	bita	#%00100000	; did we cross end of screen?
	beq	finish
	jsr	add_bottom_row
finish	lda	#BLIT_CMD_ACTIVATE_CURSOR
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
