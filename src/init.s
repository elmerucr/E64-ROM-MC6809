	global	cold_start

	section	BSS
var1	dc	1

	section	TEXT
cold_start:
	; Because of reset exception, sp goes to $fd, let's 'restore'
	; this to $ff so full stack is available.
	ldx	#$ff
	txs

	jsr	sid_reset
	jsr	sid_welcome_sound
.1	inc	$d021
	jsr	functie
	sta	var1
	jmp	.1
