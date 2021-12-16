		include	"definitions.i"

		global	vicv_clear_kernel_displ_list
		global	vicv_init_displ_list
		global	vicv_set_bordersize_and_colors
		global	vicv_set_blit_0
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
		pshs	x
		ldx	#VICV_DISPL_LIST
		ldd	#0
		sta	,x
		std	4,x
		ldd	#$10
		std	6,x
		puls	x
		rts

vicv_set_bordersize_and_colors:
		pshs	b,a
		lda	#16
		sta	BLIT_HBS
		;ldd	c64_black
		ldd	c64_lightblue
		std	BLIT_HBC
		ldd	c64_blue
		std	BLIT_CLC
		lda	#20
		sta	BLIT_BLINK_INTERVAL
		puls	b,a
		rts

vicv_set_blit_0:
		; Set up blitdescriptor 0 (main text screen)
		pshs	b,a
		clr	BLIT_NO		; blit 0
		lda	#%10001010
		sta	BLIT_FLAGS_0
		clr	BLIT_FLAGS_1	; not expanded, not mirrored
		lda	#$56		; size 64x32
		sta	BLIT_SIZE_LOG2
		ldd	c64_lightblue
		std	BLIT_FOREGROUND_COLOR
		clr	BLIT_BACKGROUND_COLOR
		clr	BLIT_BACKGROUND_COLOR+1
		puls	b,a
		rts

vicv_irq_handler:
		lda	#BLIT_CMD_SWAP_BUFFERS
		sta	BLIT_CR
		lda	#BLIT_CMD_CLEAR_FRAMEBUFFER
		sta	BLIT_CR

		lda	BLIT_NO
		pshs	a

		ldx	#VICV_DISPL_LIST
		lda	,x++
.1		sta	BLIT_NO
		lda	,x++
		;do nothing with this value, might be used for a spritesheet index
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

.2		lda	#BLIT_CMD_DRAW_BORDER
		sta	BLIT_CR

		puls	a
		sta	BLIT_NO
		rti
