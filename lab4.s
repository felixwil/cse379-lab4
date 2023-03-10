
	.text
	.global lab4
	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global read_keypad
	.global keypad_init

	.global lab4


	.data

	.global prompt
	.global results
	.global num_1_string
	.global num_2_string

prompt0:	.string "This program calculates the average of two numbers.", 0
prompt:		.string "input the first number and press enter: ", 0
prompt2:	.string "input the second number and press enter: ", 0
prompt3:	.string "The average of the numbers: ", 0
prompt4:	.string "continue? (q) ", 0
quitresult:	.string "continue? (q) ", 0
result:	.string "Your results are reported here: ", 0
num_1_string: 	.string "Place holder string for your first number", 0
num_2_string:  	.string "Place holder string for your second number", 0

	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_prompt0:		.word prompt0
ptr_to_prompt:		.word prompt
ptr_to_prompt2:		.word prompt2
ptr_to_prompt3:		.word prompt3
ptr_to_prompt4:		.word prompt4
ptr_to_quitresult:		.word quitresult
ptr_to_result:		.word result
ptr_to_num_1_string:	.word num_1_string
ptr_to_num_2_string:	.word num_2_string


lab4:
	PUSH {lr}

	;BL keypad_init
	BL gpio_btn_and_LED_init
	MOV r0, #0xF
	BL illuminate_LEDs
	BL read_from_push_btns
	BL read_from_push_btns
	BL read_from_push_btns
	BL read_from_push_btns
	BL read_from_push_btns
	BL read_from_push_btns
	BL read_from_push_btns

	BL read_tiva_push_button
	BL read_tiva_push_button
	BL read_tiva_push_button
	BL read_tiva_push_button
	BL read_tiva_push_button
	BL read_tiva_push_button
	BL read_tiva_push_button

	MOV r0, #0x01
	BL illuminate_RGB_LED
	MOV r0, #0x04
	BL illuminate_RGB_LED
	MOV r0, #0x02
	BL illuminate_RGB_LED
	MOV r0, #0x05
	BL illuminate_RGB_LED
	MOV r0, #0x03
	BL illuminate_RGB_LED
	MOV r0, #0x07
	BL illuminate_RGB_LED

	POP {lr}
	MOV pc, lr

