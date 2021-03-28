	GLOBAL functie

	SECTION	TEXT
functie:
	BIT	$ff
	LDA	#$01
	BNE	functie
	RTS

	SECTION	RODATA

t1	DB	"This is a test",0
t2	DB	"Error: can't write byte to disk",0
