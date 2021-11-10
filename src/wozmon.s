	include	"definitions.i"

	global escape

	section	TEXT

escape:
	lda	#'\'
	jsr	putchar