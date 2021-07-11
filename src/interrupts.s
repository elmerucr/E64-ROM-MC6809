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
	beq	.1		; no, branch to vicv check
	jmp	(BRK_VECTOR_INDIRECT)

.1	lda	VICV_SR
	beq	.2		; if not vicv, branch to timer check	
	sta	VICV_SR		; acknowledge vicv interrupt
	jmp	(VICV_VECTOR_INDIRECT)

.2	lda	TIMER_SR
	beq	interrupt_end
	cmp	#%00000001
	bne	.3
	sta	TIMER_SR	; acknowledge
	jmp	(TIMER0_VECTOR_INDIRECT)
.3	cmp	#%00000010
	bne	.4
	sta	TIMER_SR
	jmp	(TIMER1_VECTOR_INDIRECT)
.4	cmp	#%00000100
	bne	.5
	sta	TIMER_SR
	jmp	(TIMER2_VECTOR_INDIRECT)
.5	cmp	#%00001000
	bne	.6
	sta	TIMER_SR
	jmp	(TIMER3_VECTOR_INDIRECT)
.6	cmp	#%00010000
	bne	.7
	sta	TIMER_SR
	jmp	(TIMER4_VECTOR_INDIRECT)
.7	cmp	#%00100000
	bne	.8
	sta	TIMER_SR
	jmp	(TIMER5_VECTOR_INDIRECT)
.8	cmp	#%01000000
	bne	.9
	sta	TIMER_SR
	jmp	(TIMER6_VECTOR_INDIRECT)
.9	sta	TIMER_SR			; it must be timer 7
	jmp	(TIMER7_VECTOR_INDIRECT)

vicv_interrupt:
	lda	#BLIT_CMD_SWAP_BUFFERS
	sta	BLIT_CR
	lda	#BLIT_CMD_CLEAR_FRAMEBUFFER
	sta	BLIT_CR

	lda	#$00
	sta	BLIT_NO
	sta	BLIT_XPOS_H
	sta	BLIT_YPOS_H
	sta	BLIT_XPOS_L
	lda	#$10
	sta	BLIT_YPOS_L
	lda	#BLIT_CMD_DRAW_BLIT
	sta	BLIT_CR

	lda	#BLIT_CMD_DRAW_BORDER
	sta	BLIT_CR
	bra	interrupt_end

brk_interrupt:
	; do something...
	bra	interrupt_end

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
	;inc	BLIT_HBS	; do something visible with border
	inc	$d200	; temp hack to see something
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
