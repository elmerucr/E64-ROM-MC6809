		include	"definitions.i"

		global	vicv_clear_kernel_displ_list
		global	vicv_init_displ_list
		global	vicv_set_bordersize_and_colors
		global	vicv_set_blit_1
		global	vicv_irq_handler

		section	TEXT

vicv_clear_kernel_displ_list:
		pshs	x
		ldx	#VICV_DISPL_LIST
.1		clr	,x+
		cmpx	#VICV_DISPL_LIST+$100
		bne	.1
		puls	x
		rts

vicv_init_displ_list:
		pshs	a,b,x
		ldx	#VICV_DISPL_LIST
		lda	#$01
		sta	,x
		ldd	#0
		;sta	,x
		std	4,x
		ldd	#$10
		std	6,x
		puls	a,b,x
		rts

vicv_set_bordersize_and_colors:
		pshs	b,a
		lda	#16
		sta	BLIT_HBS
		ldd	e64_blue_01
		std	BLIT_HBC
		ldd	e64_blue_03
		std	BLIT_CLC
		puls	b,a
		rts

vicv_set_blit_1:
		; Set up blitdescriptor 1 (main text screen)
		pshs	b,a
		lda	#$01		; blit 1
		sta	BLIT_NO
		lda	#$14		; cursor speed
		sta	BLIT_BLINK_INTERVAL
		lda	#%10001010
		sta	BLIT_FLAGS_0
		clr	BLIT_FLAGS_1	; not expanded, not mirrored
		lda	#$56		; size 64x32
		sta	BLIT_SIZE_LOG2
		ldd	e64_blue_07
		std	BLIT_FOREGROUND_COLOR
		clr	BLIT_BACKGROUND_COLOR
		clr	BLIT_BACKGROUND_COLOR+1
		puls	b,a
		rts

vicv_irq_handler:
		lda	#BLIT_CMD_CLEAR_FRAMEBUFFER
		sta	BLIT_CR

		lda	BLIT_NO		; save current blit number on stack
		pshs	a

		ldx	#VICV_DISPL_LIST
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
		cmpx	#VICV_DISPL_LIST+$100
		beq	.2
		lda	,x++
		bne	.1

.2		lda	#BLIT_CMD_DRAW_HOR_BORDER
		sta	BLIT_CR
		lda	#BLIT_CMD_DRAW_VER_BORDER
		sta	BLIT_CR

		puls	a
		sta	BLIT_NO
		rti
