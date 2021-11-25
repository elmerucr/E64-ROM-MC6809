		include	"definitions.i"

		global	mon_process
		global	prompt


		section	BSS

command_index:	ds	1
temp_address:	ds	2
start_address:	ds	2
end_address:	ds	2
mem_done_flag:	ds	1


		section	TEXT

mon_process:	pshs	y,x,b,a
		ldx	#input_buffer
mon_process2:	lda	,x+
		beq	.3
		cmpa	#'.'
		beq	mon_process2		; skip dots
		cmpa	#' '
		beq	mon_process2		; skip spaces
		ldb	#cmd_names_end-cmd_names-1
		ldy	#cmd_names
.1		cmpa	b,y			; did we find match with command?
		bne	.2			; no match
		stb	command_index		; yes, we found a match
		aslb
		ldy	#function_table
		jsr	[b,y]
		bra	.4
.2		decb				; no match, value in table
		bpl	.1			; check while b>=0
		jsr	syntax_error		; command doesn't exist
.3		jsr	prompt
.4		puls	y,x,b,a			; end
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
		bne	.1			; word is bad, end it
		ldd	temp_address
		bra	.2
.1		ldd	start_address
.2		std	end_address
		jsr	display_mem
		rts
.3		jsr	syntax_error
		jsr	prompt
		rts

cmd_colon:	pshs	y,b,a
		jsr	get_hex_word
		bne	cc_error
		ldy	temp_address
		sty	start_address
		sty	end_address
		ldb	#$08
.1		jsr	consume_one_space
		bne	cc_error
		jsr	get_hex_byte
		bne	cc_error
		lda	temp_address+1
		sta	,y+
		decb
		bne	.1
		lda	#ASCII_CURSOR_UP
		jsr	putchar
		jsr	display_mem	; successful end
		jsr	prompt
		lda	#':'
		jsr	putchar
		pshs	x
		tfr	y,x
		jsr	pr_word_in_x
		puls	x
		lda	#' '
		jsr	putchar
		puls	y,b,a
		rts
cc_error:	jsr	syntax_error
		jsr	prompt
		puls	y,b,a
		rts

cmd_a:		jsr	prompt
		rts

cmd_g:		pshs	x
		ldx	#gogo
		jsr	puts
		puls	x
		jsr	prompt
		rts

cmd_c:		jsr	clear_screen
		jsr	prompt
		rts

		; data must be in start_address and end_address
display_mem:	pshs	x,b,a
		clr	mem_done_flag
		ldx	start_address

.1		jsr	prompt
		lda	#':'
		jsr	putchar
		jsr	pr_word_in_x

		ldb	#$08
.2		lda	#' '
		jsr	putchar
		cmpx	end_address
		bne	.3
		inc	mem_done_flag	; we've reached the final address
.3		lda	,x+
		jsr	pr_byte
		decb
		bne	.2

		lda	#' '
		jsr	putchar
		lda	#'|'
		jsr	putchar

		leax	-8,x
		ldb	#$08
.4		lda	,x+
		jsr	putsymbol
		lda	#ASCII_CURSOR_RIGHT
		jsr	putchar
		decb
		bne	.4

		lda	#'|'
		jsr	putchar
		lda	mem_done_flag
		beq	.1
		lda	#ASCII_CR
		jsr	putchar
		ldb	#$07
		lda	#ASCII_CURSOR_RIGHT
.5		jsr	putchar
		decb
		bne	.5
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

get_hex_byte:	pshs	b
		ldb	#$08		; digit and shift counter
		bra	ghb0
get_hex_word:	pshs	b
		ldb	#$10
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
		puls	b
		rts
ghb_end:	clra			; return 0 on success
		puls	b
		rts


		section	RODATA

gogo:	db	ASCII_LF, "go to $xxxx",0
