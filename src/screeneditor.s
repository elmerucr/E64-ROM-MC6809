		include	"definitions.i"

		global	se_init
		global	se_loop
		global	putchar
		global	puts
		global	putsymbol
		global	input_buffer
		global	clear_screen
		global	pr_byte
		global	pr_word_in_d
		global	pr_word_in_x
		global	pr_byte_binary


		section	BSS

input_buffer:	blk	128


		section	TEXT

se_init:	pshs	a
		clr	BLITTER_CONTEXT_0		; blit 0
		jsr	clear_screen
		lda	#BLIT_CMD_ACTIVATE_CURSOR
		sta	BLIT_CR
		puls	a
		rts

se_loop:	lda	CIA_AC				; do we have a char?
		beq	se_loop
		ldb	#BLIT_CMD_DEACTIVATE_CURSOR	; preserve ac
		stb	BLIT_CR
		cmpa	#ASCII_LF			; enter pressed?
		bne	.1
		jsr	copy_line_to_textbuffer		; yes, copy text in buffer
		jsr	mon_process			; execute in monitor
		bra	.2
.1		jsr	putchar
.2		lda	#BLIT_CMD_ACTIVATE_CURSOR
		sta	BLIT_CR
		bra	se_loop

copy_line_to_textbuffer:
		pshs	y,x,b,a
		ldy	BLIT_CURSOR_POS
		ldx	#input_buffer
		lda	#ASCII_CR
		jsr	putchar
		lda	#BLIT_CMD_INCREASE_CURSOR_POS
.1		ldb	BLIT_TILE_CHAR
		stb	,x+
		sta	BLIT_CR			; move cursor to right
		ldb	BLIT_SR
		bitb	#%01000000
		beq	.1
		clr	,-x			; place 0 at end of string
		sty	BLIT_CURSOR_POS
		puls	y,x,b,a
		rts

clear_screen:	pshs	b,a
		ldd	#$0000
		std	BLIT_CURSOR_POS
.1		lda	#' '
		jsr	putsymbol
		lda	#BLIT_CMD_INCREASE_CURSOR_POS
		sta	BLIT_CR
		lda	BLIT_SR			; check for pos 0 (bit 7)
		bpl	.1
		puls	b,a
		rts

add_bottom_row:	pshs	y,x,b,a
		ldd	BLIT_CURSOR_POS
		pshs	b,a			; save old cursor pos
		ldx	#$0000
		tfr	x,y			; y points to first row
		ldb	BLIT_PITCH
		abx				; x points to second row

.1		stx	BLIT_CURSOR_POS
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
		ldb	BLIT_PITCH
.2		lda	#' '
		jsr	putsymbol
		decb
		beq	.3
		lda	#BLIT_CMD_INCREASE_CURSOR_POS
		sta	BLIT_CR
		bra	.2
.3		puls	b,a			; get old cursor pos
		std	BLIT_CURSOR_POS		; and put it back
		ldb	BLIT_PITCH
		lda	#BLIT_CMD_DECREASE_CURSOR_POS
.4		sta	BLIT_CR
		decb
		bne	.4
		puls	y,x,b,a
		rts

add_top_row:	pshs	y,x,b,a

		ldx	BLIT_CURSOR_POS		; x now points to last position of screen
		tfr	x,d
		subb	BLIT_PITCH		; subtract pitch from d
		sbca	#$00
		tfr	d,y			; y now points to one row up

.1		sty	BLIT_CURSOR_POS
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

		; x now points to last char of first row
		stx	BLIT_CURSOR_POS
		ldb	#BLIT_CMD_DECREASE_CURSOR_POS
.2		lda	#' '
		jsr	putsymbol
		leax	-1,x
		stb	BLIT_CR
		cmpx	#-1
		bne	.2

		lda	#BLIT_CMD_INCREASE_CURSOR_POS
		ldb	BLIT_PITCH
.3		sta	BLIT_CR
		decb
		bne	.3

		puls	y,x,b,a
		rts

		; putsymbol - expects code to be in ac
		; doesn't change registers
putsymbol:	pshs	b,a
		sta	BLIT_TILE_CHAR
		ldd	BLIT_FOREGROUND_COLOR
		std	BLIT_TILE_FG_COLOR
		ldd	BLIT_BACKGROUND_COLOR
		std	BLIT_TILE_BG_COLOR
		puls	b,a
		rts

		; putchar - expects ascii code to be in ac
		; is actually using a combi of ascii and petscii
putchar:	pshs	b,a
is_lf		cmpa	#ASCII_LF
		bne	is_cri
		ldb	#BLIT_CMD_INCREASE_CURSOR_POS
.1		stb	BLIT_CR
		lda	BLIT_SR
		bita	#%01000000	; did we reach column 0?
		beq	.1
		bita	#%00100000	; did we reach end of screen?
		lbeq	finish
		jsr	add_bottom_row
		lbra	finish
is_cri		cmpa	#ASCII_CURSOR_RIGHT
		bne	is_cl
		lda	#BLIT_CMD_INCREASE_CURSOR_POS
		sta	BLIT_CR
		lda	BLIT_SR
		bita	#%00100000	; did we cross end of screen?
		lbeq	finish
		jsr	add_bottom_row
		lbra	finish
is_cl		cmpa	#ASCII_CURSOR_LEFT
		bne	is_cd
		lda	#BLIT_CMD_DECREASE_CURSOR_POS
		sta	BLIT_CR
		lda	BLIT_SR
		bita	#%00100000	; did we cross start of screen?
		lbeq	finish
		jsr	add_top_row
		bra	finish
is_cd		cmpa	#ASCII_CURSOR_DOWN
		bne	is_cu
		ldb	BLIT_PITCH
.1		lda	#BLIT_CMD_INCREASE_CURSOR_POS
		sta	BLIT_CR
		lda	BLIT_SR
		bita	#%00100000	; did we cross end of screen?
		beq	.2
		jsr	add_bottom_row
.2		decb
		bne	.1
		bra	finish
is_cu		cmpa	#ASCII_CURSOR_UP
		bne	is_bksp
		ldb	BLIT_PITCH
.1		lda	#BLIT_CMD_DECREASE_CURSOR_POS
		sta	BLIT_CR
		lda	BLIT_SR
		bita	#%00100000	; did we cross start of screen?
		beq	.2
		jsr	add_top_row
.2		decb
		bne	.1
		bra	finish
is_bksp 	cmpa	#ASCII_BACKSPACE
		bne	is_cr
		lda	#BLIT_CMD_DECREASE_CURSOR_POS
		sta	BLIT_CR
		lda	BLIT_SR
		bita	#%00100000	; did we cross start of screen?
		beq	.1
		jsr	add_top_row
.1		lda	#' '
		jsr	putsymbol
		bra	finish
is_cr		cmpa	#ASCII_CR
		bne	is_sym
		ldb	#BLIT_CMD_DECREASE_CURSOR_POS
.1		lda	BLIT_SR
		bita	#%01000000	; are we at column 0?
		bne	finish		; yes, finished
		stb	BLIT_CR
		bra	.1
is_sym		jsr	putsymbol
		lda	#BLIT_CMD_INCREASE_CURSOR_POS
		sta	BLIT_CR
		lda	BLIT_SR
		bita	#%00100000	; did we cross end of screen?
		beq	finish
		jsr	add_bottom_row
finish		puls	b,a
		rts

		; print string (0 terminated) - expects pointer in x
puts:		pshs	x,a
.1		lda	,x+
		beq	.2
		jsr	putchar
		bra	.1
.2		puls	x,a
		rts

		; print hex byte in a
pr_byte:	pshs	a	; store a
		lsra
		lsra
		lsra
		lsra
		bsr	pr_hex
		puls	a
pr_hex:		anda	#$0f
		ora	#$30
		cmpa	#$39
		bls	echo
		adda	#$27
echo:		jsr	putchar
		rts

		; print word in d
pr_word_in_d:	jsr	pr_byte
		exg	a,b
		jsr	pr_byte
		exg	a,b
		rts

pr_word_in_x:	pshs	b,a
		tfr	x,d
		jsr	pr_word_in_d
		puls	b,a
		rts

pr_byte_binary:	pshs	y,b,a
		ldy	#$0008
		tfr	a,b
prb_start:	bitb	#%10000000
		beq	prb_zero
		lda	#'*'
		jsr	putchar
		bra	prb_cont
prb_zero:	lda	#'.'
		jsr	putchar
prb_cont:	aslb
		leay	-1,y
		bne	prb_start
		puls	y,b,a
		rts
