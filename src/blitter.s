		include	"definitions.i"

		global	blitter_clear_kernel_displ_list
		global	blitter_init_displ_list
		global	blitter_set_bordersize_and_colors
		global	blitter_init_blit_0
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

; display list entries (8 bytes each):
; byte    description
; ===================
;  00     00 = end of list
;         01 = blit
;         ????02 = hor border
;         ????03 = ver border
;
;  01     blit number
;  02/03  flags 0 / flags 1
;  04/05  xpos
;  06/07  ypos

blitter_init_displ_list:
		pshs	a,b,x
		ldx	#DISPL_LIST
		;clra
		lda	#$01
		sta	,x
		clr	1,x
		lda	#$8a
		sta	2,x
		clr	3,x
		; it's automatically about blit 0 (2nd entry = already 0)
		ldd	#0	; xpos = 0
		std	4,x
		ldd	#$10	; ypos = 32
		std	6,x
		puls	a,b,x
		rts

blitter_set_bordersize_and_colors:
		pshs	b,a
		clra
		sta	BLITTER_VBS
		lda	#16
		sta	BLITTER_HBS
		ldd	e64_blue_01
		std	BLITTER_HBC
		std	BLITTER_VBC
		ldd	e64_blue_03
		std	BLITTER_CLC
		puls	b,a
		rts

blitter_init_blit_0:
		; Set up blitdescriptor 0 (main text screen)
		pshs	b,a
		clra			; a = $00: blit 0
		sta	BLITTER_CONTEXT_0
		lda	#$14		; cursor speed
		sta	BLIT_CURSOR_BLINK_INTERVAL
		;lda	#%10001010
		;sta	BLIT_FLAGS_0
		;clr	BLIT_FLAGS_1	; not expanded, not mirrored
		lda	#$89		; size 2^9 = 512  x  2^8 = 256
		sta	BLIT_SIZE_LOG2
		lda	#$33
		sta	BLIT_TILE_SIZE_LOG2
		ldd	e64_blue_07
		std	BLIT_FG_COLOR
		clr	BLIT_BG_COLOR
		clr	BLIT_BG_COLOR+1
		puls	b,a
		rts

blitter_irq_handler:
		; save current blit contecxt 0 on stack
		lda	BLITTER_CONTEXT_0
		pshs	a

		; clear framebuffer
		lda	#BLITTER_CMD_CLEAR_FRAMEBUFFER
		sta	BLITTER_TASK

		; perform blits
		ldx	#DISPL_LIST
.1		lda	,x+
		beq	.2			; we have reached the end of the list
		lda	,x+			; get blit_no
		sta	BLITTER_CONTEXT_0
		lda	,x+			;do nothing with these values, might be used for a spritesheet index / other stuff
		sta	BLIT_FLAGS_0
		lda	,x+
		sta	BLIT_FLAGS_1
		ldd	,x++
		std	BLIT_XPOS
		ldd	,x++
		std	BLIT_YPOS
		lda	#BLIT_CMD_DRAW_BLIT
		sta	BLIT_CR
		cmpx	#DISPL_LIST+$100
		beq	.2
		bra	.1

		; draw both borders
.2		lda	#%00000010|%00000100
		sta	BLITTER_TASK

		; restore original blit number in context 0
		puls	a
		sta	BLITTER_CONTEXT_0
		rti
