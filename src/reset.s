		include	"definitions.i"

		global	exc_reset


		section	TEXT

rom_version:	db	'E64-ROM v0.3 20220325',0

exc_reset:	; set stackpointers
		lds	#$0800		; this write to sp enables nmi
		ldu	#$e000		; initial value might be changed by software

		jsr	init_vectors

		jsr	vicv_clear_kernel_displ_list
		jsr	vicv_init_displ_list
		jsr	vicv_set_bordersize_and_colors
		jsr	vicv_set_blit_1

		; set up a 60Hz timer (3600bpm = $0e10)
		ldd	#$0e10
		std	TIMER_BPM
		lda	#%00000001	; turn on timer 0
		sta	TIMER_CR

		; sound
		jsr	sound_reset
		jsr	sound_welcome_sound

		; cia
		lda	#CIA_CMD_CLEAR_EVENT_LIST
		sta	CIA_CR
		lda	#CIA_GENERATE_EVENTS
		sta	CIA_CR
		lda	#50		; 50 * 10ms = 0.5 s delay
		sta	CIA_KRD
		lda	#5
		sta	CIA_KRS		; 5 * 10ms = 50ms rep speed

		; do not yet activate interrupts here, during init and
		; printing of first messages
		jsr	se_init		; init screen editor
		ldx	#sysinfo
		jsr	puts
		jsr	cmd_r		; HACK! (show cpu status)

		andcc	#%10101111	; enable firq/irq

		jmp	se_loop		; jump to screen editor loop

init_vectors:	pshs	x
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
		ldx	#vicv_irq_handler
		stx	VECTOR_VICV_INDIRECT
		ldx	#timer0_irq
		stx	TIMER0_VECTOR_INDIRECT
		ldx	#timer1_irq
		stx	TIMER1_VECTOR_INDIRECT
		ldx	#timer2_irq
		stx	TIMER2_VECTOR_INDIRECT
		ldx	#timer3_irq
		stx	TIMER3_VECTOR_INDIRECT
		ldx	#timer4_irq
		stx	TIMER4_VECTOR_INDIRECT
		ldx	#timer5_irq
		stx	TIMER5_VECTOR_INDIRECT
		ldx	#timer6_irq
		stx	TIMER6_VECTOR_INDIRECT
		ldx	#timer7_irq
		stx	TIMER7_VECTOR_INDIRECT
		puls	x
		rts


		section	RODATA

sysinfo:	db	'E64 Computer System  (C)2022 elmerucr', ASCII_LF
		db	ASCII_LF, 'Motorola 6809 cpu  16mb shared video ram', ASCII_LF, 0
