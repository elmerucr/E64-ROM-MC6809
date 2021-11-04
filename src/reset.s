	include	"definitions.i"

	global	exc_reset

	section	BSS
var1	dc	1

	section	TEXT
rom_version:
	db	'E64-ROM v0.2 20211104',0
exc_reset:
	; set stackpointers
	lds	#$1000		; write to sp enables nmi
	ldu	#$0800

	; place vectors in ram
	ldx	#exc_illop
	stx	VECTOR_ILLOP_INDIRECT
	ldx	#exc_swi3
	stx	VECTOR_SWI3_INDIRECT
	ldx	#exc_swi2
	stx	VECTOR_SWI2_INDIRECT
	ldx	#exc_firq
	stx	VECTOR_FIRQ_INDIRECT
	ldx	#exc_irq
	stx	VECTOR_IRQ_INDIRECT
	ldx	#exc_swi
	stx	VECTOR_SWI_INDIRECT
	ldx	#exc_nmi
	stx	VECTOR_NMI_INDIRECT
	ldx	#vicv_interrupt
	stx	VECTOR_VICV_INDIRECT
	ldx	#timer0_interrupt
	stx	TIMER0_VECTOR_INDIRECT
	ldx	#timer1_interrupt
	stx	TIMER1_VECTOR_INDIRECT
	ldx	#timer2_interrupt
	stx	TIMER2_VECTOR_INDIRECT
	ldx	#timer3_interrupt
	stx	TIMER3_VECTOR_INDIRECT
	ldx	#timer4_interrupt
	stx	TIMER4_VECTOR_INDIRECT
	ldx	#timer5_interrupt
	stx	TIMER5_VECTOR_INDIRECT
	ldx	#timer6_interrupt
	stx	TIMER6_VECTOR_INDIRECT
	ldx	#timer7_interrupt
	stx	TIMER7_VECTOR_INDIRECT

	; Set up border size and colors
	lda	#16
	sta	BLIT_HBS

	ldd	c64_black
	std	BLIT_HBC

	ldd	c64_blue
	std	BLIT_CLC

	lda	#20
	sta	BLIT_BLINK_INTERVAL

	; Set up blitdescriptor 0 (main text screen)
	lda	#%10001010
	ldx	#BLIT_D_00
	sta	,x
	clra			; not expanded, not mirrored
	sta	1,x
	lda	#$56		; size 64x32
	sta	2,x
	ldd	c64_lightblue
	std	4,x		; text color
	clra
	clr	6,x
	clr	7,x

	; Set up blit memory inspection
	ldd	#$0080
	std	BLIT_PAGE

	; set up a 60Hz timer (3600bpm = $0e10)
	ldd	#$0e10
	std	TIMER_BPM
	lda	#%00000001	; turn on timer 0
	sta	TIMER_CR

	; sids
	jsr	sid_reset
	jsr	sid_welcome_sound

	; cia
	lda	#CIA_CMD_CLEAR_EVENT_LIST
	sta	CIA_CR
	lda	#CIA_GENERATE_EVENTS
	sta	CIA_CR
	lda	#50		; 50 * 10ms = 0.5 s delay
	sta	CIA_KRD
	lda	#5
	sta	CIA_KRS		; 5 * 10ms = 50ms rep speed

	; enable firq/irq
	andcc	#%10101111



	jsr	se_init

	ldx	#welc1
	jsr	puts

	jmp	se_loop

	section	RODATA

welc1	db	ASCII_LF, 'E64 Computer System  (C)2021 elmerucr', ASCII_LF
	db	ASCII_LF, 'Motorola 6809 cpu  64k/16mb ram system', ASCII_LF, 0
