		include	"definitions.i"

		global escape
		global woz_parse_cmd

		section	BSS

xam		dw	1
st		dw	1
h		db	1
l		db	1

mode		db	1
xsav		dw	1
inptr		dw	1

		section	TEXT

escape:		lda	#'\'
		jsr	putchar
		lda	#ASCII_LF
		jsr	putchar
		rts

woz_parse_cmd:
ret:		pshs	x,a
		ldx	#input_buffer+256-1
		stx	inptr
		clra			; for XAM mode. 0->B.
setmode:	sta	mode		; $00 = XAM, $2e = block XAM, $3a = STOR
blskip:		inc	inptr+1
nextitem:	ldx	inptr
		lda	,x		; get character
		lbeq	end		; 0 character, done this line
		cmpa	#'.'		; $2e
		beq	setmode		; yes, set block XAM mode
		bls	blskip		; skip delimiter
		cmpa	#':'		; $3a
		beq	setmode		; yes, set STOR mode
		cmpa	#'r'
		beq	run		; yes, run user program
		clr	h
		clr	l
		stx	xsav

nexthex:	ldx	inptr
		lda	,x
		eora	#$30		; map digits to $0-9
		cmpa	#$09
		bls	dig
		adda	#$a9		; map letter "a" to "f" to $fa-$ff
		cmpa	#$f9
		bls	nothex		; no, character not hex

dig:		asla
		asla
		asla
		asla

		ldb	#$04
hexshift:	asla
		rol	l
		rol	h
		decb			; done 4 shifts?
		bne	hexshift	; no, loop

		inc	inptr+1
		bra	nexthex		; Always taken. Check next
					; character for hex.

nothex:		cmpx	xsav
		beq	end		;
		lda	mode
		cmpa	#$3a		; STOR mode?
		bne	notstor

; STOR mode
		ldx	st
		lda	l		; LSD's of hex data
		sta	,x
		leax	1,x
		stx	st
tonextitem:	bra	nextitem

		; prbyte routine
		; expects byte in a, doesn't change registers
prbyte:		pshs	a
		lsra
		lsra
		lsra
		lsra
		bsr	prhex	; output hex digit
		puls	a	; restore a
prhex:		anda	#$0f	; Mask LSD for hex print.
		ora	#$30	; add "0"
		cmpa	#$39
		bls	echo
		adda	#$27
echo:		jsr	putchar
		rts

		; run
		; jumps to address in xam, doesn't return
run:		jmp	[xam]

notstor:	tst	mode
		bne	xamnext

		ldx	h
		stx	st
		stx	xam
		clra		; set z flag to force following branch

nxtprnt:	bne	prdata
		lda	#ASCII_LF
		jsr	putchar
		lda	xam
		bsr	prbyte
		lda	xam+1
		bsr	prbyte
		lda	#':'
		jsr	putchar

prdata:		lda	#' '
		jsr	putchar

		ldx	xam
		lda	,x
		bsr	prbyte

xamnext:	clr	mode
		ldx	xam
		cmpx	h
		beq	tonextitem
		leax	1,x
		stx	xam
		lda	xam+1
		anda	#$07
		bra	nxtprnt

end:		puls	x,a
		rts
