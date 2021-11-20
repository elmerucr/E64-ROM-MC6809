		include	"definitions.i"

		global	input_loop
		global	prompt


		section	BSS

command_index:	ds	1
hbyte:		ds	1
lbyte:		ds	1
start_address:	ds	2
end_address:	ds	2


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
		bpl	.1			; check while b>=0
		jsr	syntax_error		; command doesn't exist
.3		puls	y,x,b,a			; end
		rts

syntax_error:	pshs	b
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
		puls	b
		lda	#$01			; returns 1
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

cmd_mid:	jsr	consume_one_space
		cmpa	#$00
		bne	.1
		jsr	get_hex_word
		cmpa	#$00
		bne	.1
		ldd	hbyte
		std	start_address
.1		rts

cmd_colon:
cmd_a:		rts

cmd_g:		pshs	x
		ldx	#gogo
		jsr	puts
		puls	x
		rts

cmd_c:		jsr	clear_screen
		rts

consume_one_space:
		lda	,x+
		cmpa	#' '
		bne	syntax_error
		clra			; returns 0 on success
		rts

get_hex_byte:	ldb	#$08		; digit and shift counter
		bra	ghb0
get_hex_word:	ldb	#$10
ghb0:		clr	hbyte
		clr	lbyte
next_digit:	lda	,x+		; fetch char
		eora	#$30		; map digits to $0-9
		cmpa	#$09
		bls	is_digit	; it's a digit
		adda	#$a9		; not digit, map letter "a" to "f" to $fa-$ff
		cmpa	#$f9
		bls	ghb_end_error	; no, character not hex
is_digit:	asla
		asla
		asla
		asla
hexshift:	asla
		rol	lbyte
		rol	hbyte
		decb
		beq	ghb_end
		bitb	#%00000011
		bne	hexshift	; no, loop
		bra	next_digit
ghb_end_error:	lbra	syntax_error
ghb_end:	lda	#$00		; return 0 on success
		rts


		section	RODATA

gogo:	db	ASCII_LF, "go to $xxxx",0
