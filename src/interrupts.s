	include	"definitions.i"

	global	irq_brk_interrupt
	global	vicv_interrupt
	global	brk_interrupt
	global	nmi_interrupt
	global	timer0_interrupt
	global	timer1_interrupt
	global	timer2_interrupt
	global	timer3_interrupt
	global	timer4_interrupt
	global	timer5_interrupt
	global	timer6_interrupt
	global	timer7_interrupt

	section	TEXT

irq_brk_interrupt:
	pha
	phx
	phy

	tsx
	lda	$0104,x		; load stacked sr
	and	#%00010000	; is the break flag set?
	beq	.1
	jmp	(BRK_VECTOR_INDIRECT)

.1	lda	VICV_SR
	beq	.2		; if not vicv, jump to test timer
	lda	#$01		; acknowledge vicv interrupt
	sta	$d000
	jmp	(VICV_VECTOR_INDIRECT)

.2	lda	#$01		; acknowledge timer interrupt
	sta	TIMER_SR
	jmp	(TIMER0_VECTOR_INDIRECT)

vicv_interrupt:
	lda	#BLIT_CMD_SWAP_BUFFERS
	sta	BLIT_CR
	lda	#BLIT_CMD_CLEAR_FRAMEBUFFER
	sta	BLIT_CR
	jmp	interrupt_end

brk_interrupt:
	; do something...
	jmp	interrupt_end

nmi_interrupt:
	pha
	phx
	phy
	; do something
interrupt_end:
	ply
	plx
	pla
	rti

timer0_interrupt:
	inc	BLIT_HBS	; do something visible with border
	jmp	interrupt_end

timer1_interrupt:
	jmp	interrupt_end

timer2_interrupt:
	jmp	interrupt_end

timer3_interrupt:
	jmp	interrupt_end

timer4_interrupt:
	jmp	interrupt_end

timer5_interrupt:
	jmp	interrupt_end

timer6_interrupt:
	jmp	interrupt_end

timer7_interrupt:
	jmp	interrupt_end
