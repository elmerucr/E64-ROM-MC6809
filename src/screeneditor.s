		include	"definitions.i"

		global	se_init
		global	se_loop
		global	putchar
		global	puts
		global	input_buffer

		section	BSS

input_buffer:	blk	64

		section	TEXT

se_init:	pshs	a
		jsr	clear_screen
		lda	#BLIT_CMD_ACTIVATE_CURSOR
		sta	BLIT_CR
		puls	a
		rts

se_loop:	lda	CIA_AC			; do we have a char?
		beq	se_loop
		ldb	#BLIT_CMD_DEACTIVATE_CURSOR	; preserve ac
		stb	BLIT_CR
		cmpa	#ASCII_LF			; enter pressed?
		bne	.1
		jsr	copy_line_to_textbuffer		; yes, copy text in buffer
		jsr	putchar
		jsr	woz_parse_cmd
		jsr	escape
		bra	.2
.1		jsr	putchar
.2		lda	#BLIT_CMD_ACTIVATE_CURSOR
		sta	BLIT_CR
		bra	se_loop

copy_line_to_textbuffer:
	pshs	y,x,b,a
	ldy	BLIT_CURSOR_POS		; store final cursor pos
	ldx	#input_buffer
	lda	#ASCII_CR
	jsr	putchar			; go to start of line
	cmpy	BLIT_CURSOR_POS		; were we already at column 0?
	beq	.2			; yes, just write 0 and finish
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
.1	ldb	BLIT_TILE_CHAR
	sta	BLIT_CR
	stb	,x+
	cmpy	BLIT_CURSOR_POS
	bne	.1
.2	clr	,x			; place 0 at end of string
	puls	y,x,b,a
	rts

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
	lda	BLIT_CR			; check for pos 0 (bit 7)
	bpl	.1
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
	leax	1,x			; increase both pointers
	leay	1,y
	cmpx	BLIT_NO_OF_TILES	; did we reach the last char?
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
	pshs	y,x,b,a

	ldx	BLIT_CURSOR_POS		; x now points to last position of screen
	tfr	x,d
	subb	BLIT_PITCH		; subtract pitch from d
	sbca	#$00
	tfr	d,y			; y now points to one row up

.1	sty	BLIT_CURSOR_POS
	lda	BLIT_TILE_CHAR
	stx	BLIT_CURSOR_POS
	sta	BLIT_TILE_CHAR
	sty	BLIT_CURSOR_POS
	ldd	BLIT_TILE_FG_COLOR
	stx	BLIT_CURSOR_POS
	std	BLIT_TILE_FG_COLOR
	sty	BLIT_CURSOR_POS
	ldd	BLIT_TILE_BG_COLOR
	stx	BLIT_CURSOR_POS
	std	BLIT_TILE_BG_COLOR
	leax	-1,x
	leay	-1,y
	cmpy	#-1
	bne	.1

	; x currently points to the last char of the first row
	stx	BLIT_CURSOR_POS
	lda	#' '
	sta	BLIT_DATA
	lda	#BLIT_CMD_PUT_SYMBOL_AT_CURSOR
	ldb	#BLIT_CMD_DECREASE_CURSOR_POS
.2	sta	BLIT_CR
	leax	-1,x
	stb	BLIT_CR
	cmpx	#-1
	bne	.2

	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	ldb	BLIT_PITCH
.3	sta	BLIT_CR
	decb
	bne	.3

	puls	y,x,b,a
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
	bne	is_cri
	ldb	#BLIT_CMD_INCREASE_CURSOR_POS
.1	stb	BLIT_CR
	lda	BLIT_CR
	bita	#%01000000	; did we reach column 0?
	beq	.1
	bita	#%00100000	; did we reach end of screen?
	lbeq	finish
	jsr	add_bottom_row
	lbra	finish
is_cri	cmpa	#ASCII_CURSOR_RIGHT
	bne	is_cl
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	bita	#%00100000	; did we cross end of screen?
	lbeq	finish
	jsr	add_bottom_row
	lbra	finish
is_cl	cmpa	#ASCII_CURSOR_LEFT
	bne	is_cd
	lda	#BLIT_CMD_DECREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	bita	#%00100000	; did we cross start of screen?
	lbeq	finish
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
	bne	is_bksp
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
is_bksp cmpa	#ASCII_BACKSPACE
	bne	is_cr
	lda	#BLIT_CMD_DECREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	bita	#%00100000	; did we cross start of screen?
	beq	.1
	jsr	add_top_row
.1	lda	#' '
	jsr	putsymbol
	bra	finish
is_cr	cmpa	#ASCII_CR
	bne	is_sym
	ldb	#BLIT_CMD_DECREASE_CURSOR_POS
.1	lda	BLIT_CR
	bita	#%01000000	; are we at column 0?
	bne	finish		; yes, finished
	stb	BLIT_CR
	bra	.1
is_sym	jsr	putsymbol
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	bita	#%00100000	; did we cross end of screen?
	beq	finish
	jsr	add_bottom_row
finish	rts

; print string (0 terminated) - expects pointer in x
puts:
	pshs	a
.1	lda	,x+
	beq	.2
	jsr	putchar
	bra	.1
.2	puls	a
	rts
