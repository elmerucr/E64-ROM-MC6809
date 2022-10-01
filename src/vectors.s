		include	"definitions.i"

		section	VECTORS_GENERAL

.0		jmp	[VECTOR_ILLOP_INDIRECT]		; $ff00 (instr is 4 bytes)
.1		jmp	[VECTOR_SWI3_INDIRECT]		; $ff04
.2		jmp	[VECTOR_SWI2_INDIRECT]		; $ff08
.3		jmp	[VECTOR_FIRQ_INDIRECT]		; $ff0c
.4		jmp	[VECTOR_IRQ_INDIRECT]		; $ff10
.5		jmp	[VECTOR_SWI_INDIRECT]		; $ff14
.6		jmp	[VECTOR_NMI_INDIRECT]		; $ff18

		dw	music_notes			; $ff1c

		section	VECTORS_SYSTEM

		dw	.0
		dw	.1
		dw	.2
		dw	.3
		dw	.4
		dw	.5
		dw	.6
		dw	exc_reset
