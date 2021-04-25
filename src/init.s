	include	"definitions.i"

	global	cold_start

	section	BSS
var1	dc	1

	section	TEXT
cold_start:
	; Because of reset exception, sp goes to $fd, let's 'restore'
	; this to $ff so full stack will be available.
	ldx	#$ff
	txs

	; place vectors in ram
	lda	#<vicv_interrupt
	sta	VICV_VECTOR_INDIRECT
	lda	#>vicv_interrupt
	sta	VICV_VECTOR_INDIRECT+1

	lda	#<brk_interrupt
	sta	BRK_VECTOR_INDIRECT
	lda	#>brk_interrupt
	sta	BRK_VECTOR_INDIRECT+1

	lda	#<timer0_interrupt
	sta	TIMER0_VECTOR_INDIRECT
	lda	#>timer0_interrupt
	sta	TIMER0_VECTOR_INDIRECT+1

	lda	#<timer1_interrupt
	sta	TIMER1_VECTOR_INDIRECT
	lda	#>timer1_interrupt
	sta	TIMER1_VECTOR_INDIRECT+1

	lda	#<timer2_interrupt
	sta	TIMER2_VECTOR_INDIRECT
	lda	#>timer2_interrupt
	sta	TIMER2_VECTOR_INDIRECT+1

	lda	#<timer3_interrupt
	sta	TIMER3_VECTOR_INDIRECT
	lda	#>timer3_interrupt
	sta	TIMER3_VECTOR_INDIRECT+1

	lda	#<timer4_interrupt
	sta	TIMER4_VECTOR_INDIRECT
	lda	#>timer4_interrupt
	sta	TIMER4_VECTOR_INDIRECT+1

	lda	#<timer5_interrupt
	sta	TIMER5_VECTOR_INDIRECT
	lda	#>timer5_interrupt
	sta	TIMER5_VECTOR_INDIRECT+1

	lda	#<timer6_interrupt
	sta	TIMER6_VECTOR_INDIRECT
	lda	#>timer6_interrupt
	sta	TIMER6_VECTOR_INDIRECT+1

	lda	#<timer7_interrupt
	sta	TIMER7_VECTOR_INDIRECT
	lda	#>timer7_interrupt
	sta	TIMER7_VECTOR_INDIRECT+1

	; Set up border size and color
	lda	#$10
	sta	BLIT_HBS
	lda	c64_black
	sta	BLIT_HBC_LB
	lda	c64_black+1
	sta	BLIT_HBC_HB
	lda	c64_blue
	sta	BLIT_CLC_LB
	lda	c64_blue+1
	sta	BLIT_CLC_HB

	; set up a 60hz timer (3600bpm = $0e10)
	lda	#$10
	sta	TIMER_BPM_LB
	lda	#$0e
	sta	TIMER_BPM_HB
	lda	#%00000001		; load bit 0
	tsb	TIMER_CR		; turn on timer 0

	; sids
	jsr	sid_reset
	jsr	sid_welcome_sound

	; turn on interrupts
	cli

	; do some loop
.1	inc	$c000
	lda	$c000
	sta	var1
	bra	.1
