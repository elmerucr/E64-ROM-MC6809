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
	ldx	#>vicv_interrupt
	sta	VICV_VECTOR_INDIRECT
	stx	VICV_VECTOR_INDIRECT+1

	lda	#<brk_interrupt
	ldx	#>brk_interrupt
	sta	BRK_VECTOR_INDIRECT
	stx	BRK_VECTOR_INDIRECT+1

	lda	#<timer0_interrupt
	ldx	#>timer0_interrupt
	sta	TIMER0_VECTOR_INDIRECT
	stx	TIMER0_VECTOR_INDIRECT+1

	lda	#<timer1_interrupt
	ldx	#>timer1_interrupt
	sta	TIMER1_VECTOR_INDIRECT
	stx	TIMER1_VECTOR_INDIRECT+1

	lda	#<timer2_interrupt
	ldx	#>timer2_interrupt
	sta	TIMER2_VECTOR_INDIRECT
	stx	TIMER2_VECTOR_INDIRECT+1

	lda	#<timer3_interrupt
	ldx	#>timer3_interrupt
	sta	TIMER3_VECTOR_INDIRECT
	stx	TIMER3_VECTOR_INDIRECT+1

	lda	#<timer4_interrupt
	ldx	#>timer4_interrupt
	sta	TIMER4_VECTOR_INDIRECT
	stx	TIMER4_VECTOR_INDIRECT+1

	lda	#<timer5_interrupt
	ldx	#>timer5_interrupt
	sta	TIMER5_VECTOR_INDIRECT
	stx	TIMER5_VECTOR_INDIRECT+1

	lda	#<timer6_interrupt
	ldx	#>timer6_interrupt
	sta	TIMER6_VECTOR_INDIRECT
	stx	TIMER6_VECTOR_INDIRECT+1

	lda	#<timer7_interrupt
	ldx	#>timer7_interrupt
	sta	TIMER7_VECTOR_INDIRECT
	stx	TIMER7_VECTOR_INDIRECT+1

	; Set up border size and colors
	lda	#$10
	sta	BLIT_HBS

	lda	c64_black
	ldx	c64_black+1
	sta	BLIT_HBC_LB
	stx	BLIT_HBC_HB

	lda	c64_blue
	ldx	c64_blue+1
	sta	BLIT_CLC_LB
	stx	BLIT_CLC_HB

	; Set up blitdescriptor 0 (main text screen)
	lda	#%10001010
	sta	BLIT_D_00+$00
	lda	#%00000000
	sta	BLIT_D_00+$01
	lda	#$56		; size 64x32
	sta	BLIT_D_00+$02
	lda	c64_lightblue
	sta	BLIT_D_00+$04
	lda	c64_lightblue+1
	sta	BLIT_D_00+$05
	lda	#$00
	sta	BLIT_D_00+$06
	sta	BLIT_D_00+$07

	; Set up blit memory inspection
	lda #$80
	sta BLIT_PAGE_LB
	lda #$00
	sta BLIT_PAGE_HB

	; set up a 60Hz timer (3600bpm = $0e10)
	lda	#$10
	ldx	#$0e
	sta	TIMER_BPM_LB
	stx	TIMER_BPM_HB
	lda	#%00000001	; turn on timer 0
	tsb	TIMER_CR

	; sids
	jsr	sid_reset
	jsr	sid_welcome_sound

	; allow interrupts
	cli

clear_screen:
	; clear screen
	lda	#BLIT_CMD_RESET_CURSOR		; reset curs pos
	sta	BLIT_CR
	lda	#'@'
	sta	BLIT_DATA
.1	lda	#BLIT_CMD_PUT_SYMBOL_AT_CURSOR
	sta	BLIT_CR
	lda	#BLIT_CMD_INCREASE_CURSOR_POS
	sta	BLIT_CR
	lda	BLIT_CR
	beq	.1


	; do some loop (replace for more serious work)
.2	inc	BLIT_DATA		; this location contains char to print
	lda	#BLIT_CMD_PUT_SYMBOL_AT_CURSOR
	sta	BLIT_CR
	;lda	#BLIT_CMD_INCREASE_CURSOR_POS
	;sta	BLIT_CR
	lda	BLIT_CR
	beq	.2
	inc	BLIT_DATA


	bra	.2
