	global	irq_brk_interrupt
	global	nmi_interrupt

	section	TEXT
irq_brk_interrupt:
	RTI
nmi_interrupt:
	RTI
