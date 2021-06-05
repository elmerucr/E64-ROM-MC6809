	section	VECTORS

nmi_vector:
	dw	nmi_interrupt
reset_vector:
	dw	cold_start
brk_vector:
	dw	irq_brk_interrupt
