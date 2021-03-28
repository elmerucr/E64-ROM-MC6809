	SECTION	VECTORS

nmi_vector:
	DW	nmi_interrupt
reset_vector:
	DW	loop
brk_vector:
	DW	$0801
