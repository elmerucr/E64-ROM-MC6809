	GLOBAL	loop

	SECTION	BSS
var1	DC	1

	SECTION	TEXT
loop:	INC	$d020
	JSR	functie
	STA	var1
	JMP	loop
