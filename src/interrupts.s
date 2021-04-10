	include	"defs.i"

	global	irq_brk_interrupt
	global	nmi_interrupt

	section	TEXT
irq_brk_interrupt:
	pha
	phx
	phy

	tsx
	lda	$0104,x		; load stacked sr into a
	and	#%00010000	; is the break flag set?
	beq	.1
	jsr	brk_interrupt
	bra	.3

.1	lda	$d000
	beq	.2		; if not vicv, jump to test timer
	lda	#$01		; acknowledge
	sta	$d000

	lda	#%00000001	; swap buffers command
	sta	BLIT_CR
	lda	#%00000010	; clear framebuffer command
	sta	BLIT_CR
	bra	.3

.2	lda	#$01		; acknowledge timer interrupt
	sta	TIMER_SR

	inc	BLIT_HBS	; do something visible with border
	inc	BLIT_HBS	; do something visible with border
	inc	BLIT_HBS	; do something visible with border
	inc	BLIT_HBS	; do something visible with border

.3	ply
	plx
	pla
	rti

irq_interrupt:
	rts

brk_interrupt:
	rts

nmi_interrupt:
	pha
	phx
	phy

	ply
	plx
	pla
	rti
