		include	"definitions.i"

		global	exc_illop
		global	exc_swi3
		global	exc_swi2
		global	exc_firq
		global	exc_irq
		global	exc_swi
		global	exc_nmi
		global	timer0_irq
		global	timer1_irq
		global	timer2_irq
		global	timer3_irq
		global	timer4_irq
		global	timer5_irq
		global	timer6_irq
		global	timer7_irq

		section	TEXT

exc_illop:
exc_swi3:
exc_swi2:
exc_firq:	rti

exc_irq:	lda	MACHINE_SR		; check if machine scr refr caused irq
		beq	exc_irq_t0		; no, go to timer
		sta	MACHINE_SR		; acknowledge irq
		jmp	[VECTOR_BLITTER_INDIRECT]
exc_irq_t0:	lda	TIMER_SR
		beq	exc_irq_end		; no timer finish exc_irq
		bita	#%00000001
		beq	exc_irq_t1
		anda	#%00000001
		sta	TIMER_SR		; acknowledge interrupt
		jmp	[TIMER0_VECTOR_INDIRECT]
exc_irq_t1:	bita	#%00000010
		beq	exc_irq_t2
		anda	#%00000010
		sta	TIMER_SR
		jmp	[TIMER1_VECTOR_INDIRECT]
exc_irq_t2:	bita	#%00000100
		beq	exc_irq_t3
		anda	#%00000100
		sta	TIMER_SR
		jmp	[TIMER2_VECTOR_INDIRECT]
exc_irq_t3:	bita	#%00001000
		beq	exc_irq_t4
		anda	#%00001000
		sta	TIMER_SR
		jmp	[TIMER3_VECTOR_INDIRECT]
exc_irq_t4:	bita	#%00010000
		beq	exc_irq_t5
		anda	#%00010000
		sta	TIMER_SR
		jmp	[TIMER4_VECTOR_INDIRECT]
exc_irq_t5:	bita	#%00100000
		beq	exc_irq_t6
		anda	#%00100000
		sta	TIMER_SR
		jmp	[TIMER5_VECTOR_INDIRECT]
exc_irq_t6:	bita	#%01000000
		beq	exc_irq_t7
		anda	#%01000000
		sta	TIMER_SR
		jmp	[TIMER6_VECTOR_INDIRECT]
exc_irq_t7:	bita	#%10000000
		beq	exc_irq_end
		anda	#%10000000
		sta	TIMER_SR
		jmp	[TIMER7_VECTOR_INDIRECT]
exc_irq_end:	rti

		; FAULTY - NEEDS WORK !!!
exc_swi:	lda	#BLIT_CMD_ACTIVATE_CURSOR
		sta	BLITTER_CR
		rti

exc_nmi:	rti

timer0_irq:	lda	#BLIT_CMD_PROCESS_CURSOR_STATE
		sta	BLITTER_CR
		rti
timer1_irq:
timer2_irq:
timer3_irq:
timer4_irq:
timer5_irq:
timer6_irq:
timer7_irq:	rti
