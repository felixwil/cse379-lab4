	.text
	.global keypad_init

**************************************************************************************************
SYSCTL:		.word	0x400FE000	; Base address for System Control
GPIO_PORT_D:	.word	0x40007000	; Base address for GPIO Port D
RCGCGPIO:	.word	0x608		; Offset for GPIO Run Mode Clock Gating Control Register
GPIODIR:	.word	0x400		; Offset for GPIO Direction Register
GPIODEN		.word	0x51C		; Offset for GPIO Digital Enable Register
**************************************************************************************************

keypad_init:
	PUSH {lr}

	; Enable the clock for GPIO Port D
	LDR r1, SYSCTL		; Load base address of System Control
	LDRB r0, [r1,#0x608] ; Load contents of RCGCGPIO register
	ORR r0, r0, #8		; Set bit 3 to enalbe and provide a clock to GPIO Port D
	STRB r0, [r1,#0x608] ; Store modifed value of RCGCGPIO register back to memory

	; Set GPIO Port D, Pints 0-3 direction to Input
	LDR r1, GPIO_PORT_D	; Load base address of GPIO Port D
	LDRB r0, [r1,#0x400] 	; Load contents of GPIODIR register
	BIC r0, r0, #0xF	; Clear bits 0-3 to set GPIO direction to input
	STRB r0, [r1,#0x400] 	; Store modifed value of GPIODIR register back to memory

	; Enable GPIO Port D, Pins 0-3 as Digital
	LDRB r0, [r1,#0x51C] 	; Load contents of GPIODEN register
	ORR r0, r0, #0xF		; Set bits 0-3 to set pins to digital
	STRB r0, [r1,#0x51C] 	; Store modifed value of GPIODEN register back to memory

	POP {lr}
