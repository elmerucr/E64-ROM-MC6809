; indirect interrupt vectors in ram
VECTOR_ILLOP_INDIRECT	equ	$0100
VECTOR_SWI3_INDIRECT	equ	$0102
VECTOR_SWI2_INDIRECT	equ	$0104
VECTOR_FIRQ_INDIRECT	equ	$0106
VECTOR_IRQ_INDIRECT	equ	$0108
VECTOR_SWI_INDIRECT	equ	$010a
VECTOR_NMI_INDIRECT	equ	$010c
VECTOR_VICV_INDIRECT	equ	$010e
TIMER0_VECTOR_INDIRECT	equ	$0110
TIMER1_VECTOR_INDIRECT	equ	$0112
TIMER2_VECTOR_INDIRECT	equ	$0114
TIMER3_VECTOR_INDIRECT	equ	$0116
TIMER4_VECTOR_INDIRECT	equ	$0118
TIMER5_VECTOR_INDIRECT	equ	$011a
TIMER6_VECTOR_INDIRECT	equ	$011c
TIMER7_VECTOR_INDIRECT	equ	$011e

; vicv
VICV		equ	$d000
VICV_SR		equ	VICV

VICV_DISPL_LIST	equ	$0200

; blit general
BLIT		equ	$d100
BLIT_CR		equ	BLIT
BLIT_NO		equ	BLIT+$1
BLIT_HBS	equ	BLIT+$2
BLIT_DATA	equ	BLIT+$3
BLIT_XPOS	equ	BLIT+$4		; 16 bit
BLIT_YPOS	equ	BLIT+$6		; 16 bit
BLIT_CLC	equ	BLIT+$8		; 16 bit
BLIT_HBC	equ	BLIT+$a		; 16 bit
;
;
BLIT_PAGE	equ	BLIT+$e		; 16 bit

; blit specific to active blit (register 1)
BLIT_NO_OF_TILES	equ	BLIT+$10	; 16 bit read only
BLIT_CURSOR_POS		equ	BLIT+$12	; 16 bit pointer
BLIT_BLINK_INTERVAL	equ	BLIT+$14	; read/write
BLIT_PITCH		equ	BLIT+$15	; read only
BLIT_TILE_CHAR		equ	BLIT+$16	; read/write
BLIT_TILE_FG_COLOR	equ	BLIT+$18	; read/write
BLIT_TILE_BG_COLOR	equ	BLIT+$1a	; read/write

BLIT_CMD_SWAP_BUFFERS		equ	%00000001
BLIT_CMD_CLEAR_FRAMEBUFFER	equ	%00000010
BLIT_CMD_DRAW_BORDER		equ	%00000100
BLIT_CMD_DRAW_BLIT		equ	%00001000

BLIT_CMD_RESET_CURSOR		equ	%10000000
BLIT_CMD_PUT_SYMBOL_AT_CURSOR	equ	%10000001
BLIT_CMD_DECREASE_CURSOR_POS	equ	%11000000
BLIT_CMD_INCREASE_CURSOR_POS	equ	%11000001
BLIT_CMD_ACTIVATE_CURSOR	equ	%11100000
BLIT_CMD_DEACTIVATE_CURSOR	equ	%11100001
BLIT_CMD_PROCESS_CURSOR_STATE	equ	%11100010

; blit descriptors
BLIT_D_00	equ	$d800
BLIT_D_01	equ	$d808
BLIT_D_02	equ	$d810
BLIT_D_03	equ	$d818
BLIT_D_04	equ	$d820
BLIT_D_05	equ	$d828
BLIT_D_06	equ	$d830
BLIT_D_07	equ	$d838
BLIT_D_08	equ	$d840
BLIT_D_09	equ	$d848
BLIT_D_0a	equ	$d850
BLIT_D_0b	equ	$d858
BLIT_D_0c	equ	$d860
BLIT_D_0d	equ	$d868
BLIT_D_0e	equ	$d870
BLIT_D_0f	equ	$d878

; timer
TIMER		equ	$d300
TIMER_SR	equ	TIMER
TIMER_CR	equ	TIMER+$01
TIMER_BPM	equ	TIMER+$02	; 16 bits

; sid
SID	equ	$d400

SID0	equ	SID		; sid 0 base
SID0F	equ	SID0+$00
SID0P	equ	SID0+$02
SID0VC	equ	SID0+$04
SID0AD	equ	SID0+$05
SID0SR	equ	SID0+$06
SID0V	equ	SID0+$1b

SID1	equ	SID+$20		; sid 1 base
SID1F	equ	SID1+$00
SID1P	equ	SID1+$02
SID1VC	equ	SID1+$04
SID1AD	equ	SID1+$05
SID1SR	equ	SID1+$06
SID1V	equ	SID1+$1b

SIDM	equ	SID+$80		; mixer base
SIDM0L	equ	SIDM+$00
SIDM0R	equ	SIDM+$01
SIDM1L	equ	SIDM+$02
SIDM1R	equ	SIDM+$03

; cia
CIA	equ	$d500		; CIA base
CIA_SR	equ	CIA		; status register
CIA_CR	equ	CIA+$01		; control register
CIA_KRD	equ	CIA+$02		; keyboard repeat delay in 10ms
CIA_KRS	equ	CIA+$03		; keyboard repeat speed in 10ms
CIA_AC	equ	CIA+$04		; ascii code
CIA_KSA	equ	CIA+$80		; start of key state array

CIA_GENERATE_EVENTS		equ	%00000001
CIA_CMD_CLEAR_EVENT_LIST	equ	%10000000

; ascii
ASCII_BACKSPACE		equ	$08
ASCII_LF		equ	$0a
ASCII_CR		equ	$0d
ASCII_CURSOR_DOWN	equ	$11
ASCII_CURSOR_RIGHT	equ	$1d
ASCII_CURSOR_UP		equ	$91
ASCII_CURSOR_LEFT	equ	$9d

; music notes index
N_C0_	equ	0
N_C0S	equ	2
N_D0_	equ	4
N_D0S	equ	6
N_E0_	equ	8
N_F0_	equ	10
N_F0S	equ	12
N_G0_	equ	14
N_G0S	equ	16
N_A0_	equ	18
N_A0S	equ	20
N_B0_	equ	22

N_C1_	equ	24
N_C1S	equ	26
N_D1_	equ	28
N_D1S	equ	30
N_E1_	equ	32
N_F1_	equ	34
N_F1S	equ	36
N_G1_	equ	38
N_G1S	equ	40
N_A1_	equ	42
N_A1S	equ	44
N_B1_	equ	46

N_C2_	equ	48
N_C2S	equ	50
N_D2_	equ	52
N_D2S	equ	54
N_E2_	equ	56
N_F2_	equ	58
N_F2S	equ	60
N_G2_	equ	62
N_G2S	equ	64
N_A2_	equ	66
N_A2S	equ	68
N_B2_	equ	70

N_C3_	equ	72
N_C3S	equ	74
N_D3_	equ	76
N_D3S	equ	78
N_E3_	equ	80
N_F3_	equ	82
N_F3S	equ	84
N_G3_	equ	86
N_G3S	equ	88
N_A3_	equ	90
N_A3S	equ	92
N_B3_	equ	94

N_C4_	equ	96
N_C4S	equ	98
N_D4_	equ	100
N_D4S	equ	102
N_E4_	equ	104
N_F4_	equ	106
N_F4S	equ	108
N_G4_	equ	110
N_G4S	equ	112
N_A4_	equ	114
N_A4S	equ	116
N_B4_	equ	118

N_C5_	equ	120
N_C5S	equ	122
N_D5_	equ	124
N_D5S	equ	126
N_E5_	equ	128
N_F5_	equ	130
N_F5S	equ	132
N_G5_	equ	134
N_G5S	equ	136
N_A5_	equ	138
N_A5S	equ	140
N_B5_	equ	142

N_C6_	equ	144
N_C6S	equ	146
N_D6_	equ	148
N_D6S	equ	150
N_E6_	equ	152
N_F6_	equ	154
N_F6S	equ	156
N_G6_	equ	158
N_G6S	equ	160
N_A6_	equ	162
N_A6S	equ	164
N_B6_	equ	166

N_C7_	equ	168
N_C7S	equ	170
N_D7_	equ	172
N_D7S	equ	174
N_E7_	equ	176
N_F7_	equ	178
N_F7S	equ	180
N_G7_	equ	182
N_G7S	equ	184
N_A7_	equ	186
N_A7S	equ	188
