		include	"definitions.i"

		global	input_loop
		global	prompt


		section	BSS

command_index:	ds	1
h:		ds	1
l:		ds	1


		section	TEXT

input_loop:	pshs	y,x,b,a
		ldx	#input_buffer
input_loop2:	lda	,x+
		beq	.3
		cmpa	#'.'
		beq	input_loop2		; skip dots
		cmpa	#' '
		beq	input_loop2		; skip spaces
		ldb	#cmd_names_end-cmd_names-1
		ldy	#cmd_names
.1		cmpa	b,y			; did we find match with command?
		bne	.2			; no match
		stb	command_index		; yes, we found a match
		aslb
		ldy	#function_table
		jsr	[b,y]
		bra	.3
.2		decb				; no match, value in table
		bpl	.1			; check as long as we're in the table
		jsr	syntax_error		; command doesn't exist
.3		puls	y,x,b,a			; end
		rts

syntax_error:	pshs	b,a
		tfr	x,d
		subd	#input_buffer		; b now contains column after error
		lda	#ASCII_CR
		jsr	putchar
		lda	#ASCII_CURSOR_RIGHT
.1		jsr	putchar
		decb
		bne	.1
		lda	#'?'
		jsr	putchar
		puls	b,a
		rts

prompt:		pshs	a
		lda	#ASCII_LF
		jsr	putchar
		lda	#'.'
		jsr	putchar
		puls	a
		rts

cmd_names:	db	'm'		; code relies on 'm' being first entry
		db	'd'
		db	':'
		db	'a'
		db	'g'
		db	'c'
		db	'i'
cmd_names_end:

function_table:	dw	cmd_mid		; m=monitor, i=introspect, d=disassemble?
		dw	cmd_mid
		dw	cmd_colon
		dw	cmd_a
		dw	cmd_g
		dw	cmd_c
		dw	cmd_mid

cmd_mid:	jsr	get_hex_word
		rts

cmd_colon:
cmd_a:		rts

cmd_g:		pshs	x
		ldx	#gogo
		jsr	puts
		puls	x
		rts

cmd_c:		jsr	clear_screen
		rts

get_hex_word:	clr	h
		clr	l
get_hex_word2	lda	,x+		; fetch char
		beq	ghw_end_error	; go to end if zero
		cmpa	#' '
		beq	get_hex_word2	; consume spaces
		eora	#$30		; map digits to $0-9
		cmpa	#$09
		bls	digit		; it's a digit
		adda	#$a9		; not digit, map letter "a" to "f" to $fa-$ff
		cmpa	#$f9
		bls	ghw_end_error	; no, character not hex

digit:		asla
		asla
		asla
		asla

		ldb	#$04
hexshift:	asla
		rol	l
		rol	h
		decb			; done 4 shifts?
		bne	hexshift	; no, loop
		bra	get_hex_word2

ghw_end_error:	jsr	syntax_error
ghw_end:	rts


		section	RODATA

gogo:	db	ASCII_LF, "go to $xxx'x", ASCII_LF
