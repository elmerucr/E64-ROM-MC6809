	include	"defs.i"

	global	irq_brk_interrupt
	global	nmi_interrupt

	section	TEXT
irq_brk_interrupt:
	pha
	phx
	phy

	lda	#$01		; acknowledge
	sta	$d000

	lda	#%00000001	; swap buffers
	sta	BLIT_CR
	lda	#%00000010	; clear framebuffer
	sta	BLIT_CR

	inc	BLIT_HBS	; do something visible with border

	ply
	plx
	pla
	rti

nmi_interrupt:
	pha
	phx
	phy

	ply
	plx
	pla
	rti
