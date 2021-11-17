		include	"definitions.i"

		global	input_loop
		global	print_lf_dot

		section	BSS

command_index:	ds	1


		section	TEXT

input_loop:	ldx	#input_buffer
input_loop2:	lda	,x+
		beq	end
		cmpa	#'.'
		beq	input_loop2		; skip dots
		cmpa	#' '
		beq	input_loop2		; skip spaces
		ldb	#cmd_names_end-cmd_names-1
		ldy	#cmd_names
.1		cmpa	b,y
		bne	.2
		stb	command_index
		aslb
		ldy	#function_table
		jmp	[b,y]
		bra	end

.2		decb
		bpl	.1			; go to .1 if b >= 0
		bra	syntax_error		; command doesn't exist

end:		rts

print_lf_dot:	lda	#ASCII_LF
		jsr	putchar
		lda	#'.'
		jsr	putchar
		rts

cmd_names:	db	'm'		; code relies on 'm' being first entry
		db	'd'
		db	':'
		db	'a'
		db	'g'
		db	'x'
cmd_names_end:

function_table:	dw	cmd_mid		; m=monitor, i=introspect, d=disassemble?
		dw	cmd_mid
		dw	cmd_colon
		dw	cmd_a
		dw	cmd_g
		dw	cmd_x

syntax_error:	lda	#'?'
		jsr	putchar
		rts

cmd_mid:	jsr	get_hex_word
		jsr	print_lf_dot
		rts

cmd_colon:	rts

cmd_a:		rts

cmd_g:		rts

cmd_x:		rts

get_hex_word:	lda	,x+
		rts
