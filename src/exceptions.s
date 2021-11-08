	include	"definitions.i"

	global	exc_illop
	global	exc_swi3
	global	exc_swi2
	global	exc_firq
	global	exc_irq
	global	exc_swi
	global	exc_nmi
	global	timer0_interrupt
	global	timer1_interrupt
	global	timer2_interrupt
	global	timer3_interrupt
	global	timer4_interrupt
	global	timer5_interrupt
	global	timer6_interrupt
	global	timer7_interrupt

	section	TEXT

exc_illop:
exc_swi3:
exc_swi2:
exc_firq:
	rti

exc_irq:
.1	lda	VICV_SR			; check if vicv caused irq
	beq	.2			; no, go to timer
	sta	VICV_SR			; acknowledge irq
	jmp	[VECTOR_VICV_INDIRECT]
.2	lda	TIMER_SR
	beq	.3
	cmpa	#%00000001
	bne	.3
	sta	TIMER_SR
	jmp	[TIMER0_VECTOR_INDIRECT]
.3	rti

exc_swi:
exc_nmi:
	rti

timer0_interrupt:
	lda	#BLIT_CMD_PROCESS_CURSOR_STATE
	sta	BLIT_CR
	rti
timer1_interrupt:
timer2_interrupt:
timer3_interrupt:
timer4_interrupt:
timer5_interrupt:
timer6_interrupt:
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
