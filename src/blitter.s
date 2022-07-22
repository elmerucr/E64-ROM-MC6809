		include	"definitions.i"

		global	blitter_clear_kernel_displ_list
		global	blitter_init_displ_list
		global	blitter_set_bordersize_and_colors
		global	blitter_set_blit_0
		global	blitter_irq_handler

		section	TEXT

blitter_clear_kernel_displ_list:
		pshs	x
		ldx	#DISPL_LIST
.1		clr	,x+
		cmpx	#DISPL_LIST+$100
		bne	.1
		puls	x
		rts

blitter_init_displ_list:
		pshs	a,b,x
		ldx	#DISPL_LIST
		clra
		sta	,x
		ldd	#0
		;sta	,x
		std	4,x
		ldd	#$10
		std	6,x
		puls	a,b,x
		rts

blitter_set_bordersize_and_colors:
		pshs	b,a
		clra
		sta	BLIT_VBS
		lda	#16
		sta	BLIT_HBS
		ldd	e64_blue_01
		std	BLIT_HBC
		std	BLIT_VBC
		ldd	e64_blue_03
		std	BLIT_CLC
		puls	b,a
		rts

blitter_set_blit_0:
		; Set up blitdescriptor 1 (main text screen)
		pshs	b,a
		clra			; blit 0
		sta	BLIT_NO
		lda	#$14		; cursor speed
		sta	BLIT_BLINK_INTERVAL
		lda	#%10001010
		sta	BLIT_FLAGS_0
		clr	BLIT_FLAGS_1	; not expanded, not mirrored
		lda	#$89		; size 2^9 = 512  x  2^8 = 256
		sta	BLIT_SIZE_LOG2
		lda	#$33
		sta	BLIT_TILE_SIZE_LOG2
		ldd	e64_blue_07
		std	BLIT_FOREGROUND_COLOR
		clr	BLIT_BACKGROUND_COLOR
		clr	BLIT_BACKGROUND_COLOR+1
		puls	b,a
		rts

blitter_irq_handler:
		lda	#BLIT_CMD_CLEAR_FRAMEBUFFER
		sta	BLIT_CR

		lda	BLIT_NO		; save current blit number on stack
		pshs	a

		ldx	#DISPL_LIST
		lda	,x++
.1		sta	BLIT_NO
		lda	,x++
		;do nothing with these values, might be used for a spritesheet index
		ldd	,x++
		std	BLIT_XPOS
		ldd	,x++
		std	BLIT_YPOS
		lda	#BLIT_CMD_DRAW_BLIT
		sta	BLIT_CR
		cmpx	#DISPL_LIST+$100
		beq	.2
		lda	,x++			; load next blit number and check if it's 0 (blit 0 is special can never be used twice)
		bne	.1

.2		lda	#BLIT_CMD_DRAW_HOR_BORDER
		sta	BLIT_CR
		lda	#BLIT_CMD_DRAW_VER_BORDER
		sta	BLIT_CR

		puls	a
		sta	BLIT_NO
		rti