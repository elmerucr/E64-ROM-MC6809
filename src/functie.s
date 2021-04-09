	include	"defs.i"

	GLOBAL	functie

	SECTION	TEXT
functie:
	;inc	BLIT_HBC_LB
	bne	.1
	;inc	BLIT_HBC_HB
.1	RTS

	SECTION	RODATA

t1	DB	"This is a test",0
t2	DB	"Error: can't write byte to disk",0
