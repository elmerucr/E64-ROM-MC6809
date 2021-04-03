	GLOBAL	cold_start

	SECTION	BSS
var1	DC	1

	SECTION	TEXT
cold_start:
	JSR	sid_reset
	JSR	sid_welcome_sound
.1	INC	$d021
	JSR	functie
	STA	var1
	JMP	.1
