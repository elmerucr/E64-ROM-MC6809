	include	"definitions.i"

	global	vector_illop
	global	vector_swi3
	global	vector_swi2
	global	vector_firq
	global	vector_irq
	global	vector_swi
	global	vector_nmi
	global	vicv_interrupt
	global	timer0_interrupt
	global	timer1_interrupt
	global	timer2_interrupt
	global	timer3_interrupt
	global	timer4_interrupt
	global	timer5_interrupt
	global	timer6_interrupt
	global	timer7_interrupt

	section	TEXT

vector_illop:
	rti

vector_swi3:
	rti

vector_swi2:

vector_firq:
	ldd	#$dead
	ldd	#$beef
	rti

vector_irq:
.1	lda	VICV_SR
	beq	.2
	sta	VICV_SR
	jmp	[VICV_VECTOR_INDIRECT]
.2	lda	TIMER_SR
	beq	interrupt_end
	cmpa	#%00000001
	bne	.3
	sta	TIMER_SR
	jmp	[TIMER0_VECTOR_INDIRECT]
.3	bra	interrupt_end

vector_swi:
	rti

vector_nmi:
	coma
	rti

timer0_interrupt:
	lda	#BLIT_CMD_PROCESS_CURSOR_STATE
	sta	BLIT_CR
	rti
timer1_interrupt:
	rti
timer2_interrupt:
	rti
timer3_interrupt:
	rti
timer4_interrupt:
	rti
timer5_interrupt:
	rti
timer6_interrupt:
	rti
timer7_interrupt:
	rti


;irq_brk_interrupt:
;	pha
;	phx
;	phy
;
;	tsx
;	lda	$0104,x		; load stacked sr
;	and	#%00010000	; is the break flag set?
;	beq	.1		; no, branch to vicv check
;	jmp	(BRK_VECTOR_INDIRECT)
;
;.1	lda	VICV_SR
;	beq	.2		; if not vicv, branch to timer check
;	sta	VICV_SR		; acknowledge vicv interrupt
;	jmp	(VICV_VECTOR_INDIRECT)
;
;.2	lda	TIMER_SR
;	beq	interrupt_end
;	cmp	#%00000001
;	bne	.3
;	sta	TIMER_SR	; acknowledge
;	jmp	(TIMER0_VECTOR_INDIRECT)
;.3	cmp	#%00000010
;	bne	.4
;	sta	TIMER_SR
;	jmp	(TIMER1_VECTOR_INDIRECT)
;.4	cmp	#%00000100
;	bne	.5
;	sta	TIMER_SR
;	jmp	(TIMER2_VECTOR_INDIRECT)
;.5	cmp	#%00001000
;	bne	.6
;	sta	TIMER_SR
;	jmp	(TIMER3_VECTOR_INDIRECT)
;.6	cmp	#%00010000
;	bne	.7
;	sta	TIMER_SR
;	jmp	(TIMER4_VECTOR_INDIRECT)
;.7	cmp	#%00100000
;	bne	.8
;	sta	TIMER_SR
;	jmp	(TIMER5_VECTOR_INDIRECT)
;.8	cmp	#%01000000
;	bne	.9
;	sta	TIMER_SR
;	jmp	(TIMER6_VECTOR_INDIRECT)
;.9	sta	TIMER_SR			; it must be timer 7
;	jmp	(TIMER7_VECTOR_INDIRECT)
;
vicv_interrupt:
	lda	#BLIT_CMD_SWAP_BUFFERS
	sta	BLIT_CR
	lda	#BLIT_CMD_CLEAR_FRAMEBUFFER
	sta	BLIT_CR

	clra
	sta	BLIT_NO
	ldd	#$0000
	std	BLIT_XPOS
	ldd	#$0010
	std	BLIT_YPOS
	lda	#BLIT_CMD_DRAW_BLIT
	sta	BLIT_CR

	lda	#BLIT_CMD_DRAW_BORDER
	sta	BLIT_CR
	bra	interrupt_end
;
;brk_interrupt:
;	; do something...
;	bra	interrupt_end
;
;nmi_interrupt:
;	pha
;	phx
;	phy
;	; do something
interrupt_end:
	rti

;timer0_interrupt:

;timer1_interrupt:
;	jmp	interrupt_end
;
;timer2_interrupt:
;	jmp	interrupt_end
;
;timer3_interrupt:
;	jmp	interrupt_end
;
;timer4_interrupt:
;	jmp	interrupt_end
;
;timer5_interrupt:
;	jmp	interrupt_end
;
;timer6_interrupt:
;	jmp	interrupt_end
;
;timer7_interrupt:
;	jmp	interrupt_end
;
