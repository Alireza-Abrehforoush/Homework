;Define macro
	.MACRO SUMOF
		IN @2, @0
		IN R16, @1
		ADD @2 ,R16
	.ENDMACRO
;Begin
	.ORG 0
	LDI R17 , 0x00
	OUT DDRA , R17
	OUT DDRB , R17
	SUMOF PORTA, PORTB, R17
;End
	NOP