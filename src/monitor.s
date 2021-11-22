		include	"definitions.i"

		global	input_loop
		global	prompt


		section	BSS

command_index:	ds	1
temp_address:	ds	2
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
		bne	.3
		jsr	get_hex_word
		bne	.3
		ldd	temp_address		; success, store address
		std	start_address
		jsr	consume_one_space
		bne	.1			; no space, end address = start address
		jsr	get_hex_word		; space, so check for another word
		bne	.3			; word is bad, end it
		ldd	temp_address
		bra	.2
.1		ldd	start_address
		addd	#$0008
.2		std	end_address
		jsr	display_mem
		rts
.3		jsr	syntax_error
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

		; data in start_address and end_address
		;
display_mem:	pshs	x,b,a
		ldx	start_address

.1		jsr	prompt
		lda	#':'
		jsr	putchar
		jsr	pr_word_in_x

		ldb	#$08
.2		lda	#' '
		jsr	putchar
		lda	,x+
		jsr	pr_byte
		decb
		bne	.2

		lda	#' '
		jsr	putchar

		ldd	#$f226		; darker backgroundd color
		std	BLIT_D_00+6

		leax	-8,x
		ldb	#$08
.3		lda	,x+
		jsr	putsymbol
		lda	#ASCII_CURSOR_RIGHT
		jsr	putchar
		decb
		bne	.3

		ldd	#$0000		; turn off background color
		std	BLIT_D_00+6

		cmpx	end_address
		bls	.1
		puls	x,b,a
		rts

consume_one_space:
		lda	,x+
		cmpa	#' '
		bne	.1
		clra			; returns 0 on success
		rts
.1		lda	#$01
		rts

get_hex_byte:	ldb	#$08		; digit and shift counter
		bra	ghb0
get_hex_word:	ldb	#$10
ghb0:		clr	temp_address
		clr	temp_address+1
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
		rol	temp_address+1
		rol	temp_address
		decb
		beq	ghb_end
		bitb	#%00000011
		bne	hexshift	; no, loop
		bra	next_digit
ghb_end_error:	lda	#$01		; error
		rts
ghb_end:	clra			; return 0 on success
		rts


		section	RODATA

gogo:	db	ASCII_LF, "go to $xxxx",0
