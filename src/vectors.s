		include	"definitions.i"

		section	VECTORS

.0		jmp	[VECTOR_ILLOP_INDIRECT]
.1		jmp	[VECTOR_SWI3_INDIRECT]
.2		jmp	[VECTOR_SWI2_INDIRECT]
.3		jmp	[VECTOR_FIRQ_INDIRECT]
.4		jmp	[VECTOR_IRQ_INDIRECT]
.5		jmp	[VECTOR_SWI_INDIRECT]
.6		jmp	[VECTOR_NMI_INDIRECT]

		dw	.0
		dw	.1
		dw	.2
		dw	.3
		dw	.4
		dw	.5
		dw	.6
		dw	exc_reset
