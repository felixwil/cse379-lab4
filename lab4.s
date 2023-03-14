
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
	.global read_from_keypad
	.global keypad_init

	.global lab4


	.data

	.global prompt
	.global results
	.global num_1_string
	.global num_2_string

intro:	.string "This program tests various gpio functionality.", 0
tivabuttonprompt:		.string "Press switch one on the tiva board.", 0
buttonsprompt:	.string "Press one of the four buttons on the baseboard to illuminate an led", 0
ledsprompt: .string "Input a number 0-15 to illuminate the LEDs on the tiva board", 0
rgbprompt:	.string "Type a number 0 through 5 to choose a color for the RGB LED: Red, Green, Blue, Yellow, Purple, or White", 0
keypadprompt:	.string "Now press any number key 0-9 on the baseboard's keypad to print out the number to the screen, and illuminate the leds in binary.", 0
quitprompt:	.string "press q to quit, any other key to continue (q) ", 0
result:	.string "Your results are reported here: ", 0

	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_intro:		.word intro
ptr_to_tivabuttonprompt:		.word tivabuttonprompt
ptr_to_buttonsprompt:		.word buttonsprompt
ptr_to_ledsprompt:		.word ledsprompt
ptr_to_rgbprompt:		.word rgbprompt
ptr_to_keypadprompt:		.word keypadprompt
ptr_to_quitprompt:		.word quitprompt
ptr_to_result:	.word result

lab4:
	PUSH {lr}

	BL uart_init
	BL gpio_btn_and_LED_init

	ldr r4, ptr_to_intro
	MOV r0, r4
	BL output_string
	ldr r4, ptr_to_tivabuttonprompt
	MOV r0, r4
	BL output_string

	BL gpio_btn_and_LED_init
	MOV r0, #0x1
	BL illuminate_LEDs

loopthing:
	BL read_from_keypad
	BL illuminate_LEDs
	B loopthing

	POP {lr}
	MOV pc, lr
	.end

