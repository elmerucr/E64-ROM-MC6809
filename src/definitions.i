; indirect interrupt vectors in ram
BRK_VECTOR_INDIRECT	equ	$0200
NMI_VECTOR_INDIRECT	equ	$0202
VICV_VECTOR_INDIRECT	equ	$0204
TIMER0_VECTOR_INDIRECT	equ	$0206
TIMER1_VECTOR_INDIRECT	equ	$0208
TIMER2_VECTOR_INDIRECT	equ	$020a
TIMER3_VECTOR_INDIRECT	equ	$020c
TIMER4_VECTOR_INDIRECT	equ	$020e
TIMER5_VECTOR_INDIRECT	equ	$0210
TIMER6_VECTOR_INDIRECT	equ	$0212
TIMER7_VECTOR_INDIRECT	equ	$0214

; vicv
VICV		equ	$d000
VICV_SR		equ	VICV

; blit
BLIT		equ	$d100
BLIT_CR		equ	BLIT
BLIT_NO		equ	BLIT+$1
BLIT_HBS	equ	BLIT+$2
BLIT_DATA	equ	BLIT+$3
BLIT_XPOS_L	equ	BLIT+$4
BLIT_XPOS_H	equ	BLIT+$5
BLIT_YPOS_L	equ	BLIT+$6
BLIT_YPOS_H	equ	BLIT+$7
BLIT_CLC_LB	equ	BLIT+$8
BLIT_CLC_HB	equ	BLIT+$9
BLIT_HBC_LB	equ	BLIT+$a
BLIT_HBC_HB	equ	BLIT+$b
BLIT_PAGE_LB	equ	BLIT+$e
BLIT_PAGE_HB	equ	BLIT+$f
BLIT_CMD_SWAP_BUFFERS		equ	%00000001
BLIT_CMD_CLEAR_FRAMEBUFFER	equ	%00000010
BLIT_CMD_DRAW_BORDER		equ	%00000100
BLIT_CMD_DRAW_BLIT		equ	%00001000
BLIT_CMD_RESET_CURSOR		equ	%10000000
BLIT_CMD_PUT_SYMBOL_AT_CURSOR	equ	%10000001
BLIT_CMD_DECREASE_CURSOR_POS	equ	%11000000
BLIT_CMD_INCREASE_CURSOR_POS	equ	%11000001

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
TIMER_BPM_LB	equ	TIMER+$02
TIMER_BPM_HB	equ	TIMER+$03

; sid
SID	equ	$d400

SID0	equ	SID
SID0FL	equ	SID0+$00
SID0FH	equ	SID0+$01
SID0PL	equ	SID0+$02
SID0PH	equ	SID0+$03
SID0VC	equ	SID0+$04
SID0AD	equ	SID0+$05
SID0V	equ	SID0+$18

SID1	equ	SID+$20
SID1FL	equ	SID1+$00
SID1FH	equ	SID1+$01
SID1PL	equ	SID1+$02
SID1PH	equ	SID1+$03
SID1VC	equ	SID1+$04
SID1AD	equ	SID1+$05
SID1V	equ	SID1+$18

SIDM	equ	SID+$80
SIDM0L	equ	SIDM
SIDM0R	equ	SIDM+$01
SIDM1L	equ	SIDM+$02
SIDM1R	equ	SIDM+$03

; cia
CIA	equ	$d500
CIA_SR	equ	CIA
CIA_CR	equ	CIA+$01
CIA_KRD	equ	CIA+$02
CIA_KRS	equ	CIA+$03
CIA_AC	equ	CIA+$04
CIA_KSA	equ	CIA+$80

CIA_GENERATE_EVENTS		equ	%00000001
CIA_CMD_CLEAR_EVENT_LIST	equ	%10000000
