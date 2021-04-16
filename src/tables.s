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

	SECTION	RODATA

; just something
t1	DB	"This is a test",0
t2	DB	"Error: can't write byte to disk",0

; C64 colors (VirtualC64)
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
