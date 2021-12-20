		global	c64_colors

		global	c64_black
		global	c64_white
		global	c64_red
		global	c64_cyan
		global	c64_purple
		global	c64_green
		global	c64_blue
		global	c64_yellow
		global	c64_orange
		global	c64_brown
		global	c64_lightred
		global	c64_darkgrey
		global	c64_grey
		global	c64_lightgreen
		global	c64_lightblue
		global	c64_lightgrey

		global	e64_blue_00
		global	e64_blue_01
		global	e64_blue_02
		global	e64_blue_03
		global	e64_blue_04
		global	e64_blue_05
		global	e64_blue_06
		global	e64_blue_07
		global	e64_blue_08
		global	e64_blue_09

		global	music_notes

		section	RODATA

; C64 colors (VirtualC64)
c64_colors:
c64_black       dw	$f000
c64_white       dw	$ffff
c64_red         dw	$f733
c64_cyan        dw	$f8cc
c64_purple      dw	$f849
c64_green       dw	$f6a5
c64_blue        dw	$f339
c64_yellow      dw	$fee8
c64_orange      dw	$f853
c64_brown       dw	$f531
c64_lightred    dw	$fb77
c64_darkgrey    dw	$f444
c64_grey        dw	$f777
c64_lightgreen  dw	$fbfa
c64_lightblue   dw	$f67d
c64_lightgrey   dw	$faaa

; E64 colors
e64_blue_00	dw	$f001
e64_blue_01	dw	$f113
e64_blue_02	dw	$f226
e64_blue_03	dw	$f339
e64_blue_04	dw	$f44c
e64_blue_05	dw	$f55f
e64_blue_06	dw	$f77f
e64_blue_07	dw	$f99f
e64_blue_08	dw	$fbbf
e64_blue_09	dw	$fddf

; The following table is based on a SID clock frequency
; of 985248Hz (PAL). Calculations were made according to
; Codebase64 article:
; https://codebase64.org/doku.php?id=base:how_to_calculate_your_own_sid_frequency_table
music_notes:
		dw	$0116,$0127,$0139,$014b,$015f,$0174
		dw	$018a,$01a1,$01ba,$01d4,$01f0,$020e	; N_C0_ to N_B0_
		dw	$022d,$024e,$0271,$0296,$02be,$02e7
		dw	$0314,$0342,$0374,$03a9,$03e0,$041b	; N_C1_ to N_B1_
		dw	$045a,$049c,$04e2,$052d,$057b,$05cf
		dw	$0627,$0685,$06e8,$0751,$07c1,$0837	; N_C2_ to N_B2_
		dw	$08b4,$0938,$09c4,$0a59,$0af7,$0b9d
		dw	$0c4e,$0d0a,$0dd0,$0ea2,$0f81,$106d	; N_C3_ to N_B3_
		dw	$1167,$1270,$1389,$14b2,$15ed,$173b
		dw	$189c,$1a13,$1ba0,$1d45,$1f02,$20da	; N_C4_ to N_B4_
		dw	$22ce,$24e0,$2711,$2964,$2bda,$2e76
		dw	$3139,$3426,$3740,$3a89,$3e04,$41b4	; N_C5_ to N_B5_
		dw	$459c,$49c0,$4e23,$52c8,$57b4,$5ceb
		dw	$6272,$684c,$6e80,$7512,$7c08,$8368	; N_C6_ to N_B6_
		dw	$8b39,$9380,$9c45,$a590,$af68,$b9d6
		dw	$c4e3,$d099,$dd00,$ea24,$f810		; N_C7_	to N_A7S
