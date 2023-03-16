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
        .global string2int
        .global int2string

        .global lab4


        .data

;Creating the prompts for the menu
selectprompt:			.string "Please select which program you'd like to test; 1:read_tiva_push_button, 2:read_from_push_btns, 3:illuminate_LEDs, 4:illuminate_RGB_LED, and 5:read_from_keypad", 0
quitprompt:				.string "Press (q) to quit, any other key to continue", 0
ledsinputprompt:		.string "Input the value as a decimal number to display in binary on the LEDs, number from 0-15, and press enter.", 0
rgbinputprompt:			.string "Input the color for RGB, 0:Red, 1:Green, 2:Blue, 3:Yellow, 4:Purple, 5:White", 0
tivabtnprompt:			.string "Press sw1 on the Tiva board, check r0", 0
pushbtnprompt:			.string "Press push button(s) on daughter board, check r0", 0
keypadprompt:			.string "Press button on keypad, check r0", 0
num_1_string:                   .string "Place holder string for your first number", 0 ; result storage for 1st number as string

;Instantiating a pointer to each of the prompts
ptr_to_selectprompt:    .word selectprompt
ptr_to_quitprompt:      .word quitprompt
ptr_to_ledsinputprompt: .word ledsinputprompt
ptr_to_rgbinputprompt:  .word rgbinputprompt
ptr_to_tivabtnprompt:   .word tivabtnprompt
ptr_to_pushbtnprompt:   .word pushbtnprompt
ptr_to_keypadprompt:    .word keypadprompt
ptr_to_num_1_string:    .word num_1_string

U0FR:   .equ 0x18               ;UART0 Flag Register

lab4:
                PUSH {lr}

lab4top:

                ;Inititalize the UART
                BL uart_init

                ;Prompt user to select which subroutine to run
                LDR r4, ptr_to_selectprompt
                MOV r0, r4
                BL output_string

                ;Check which subroutine the user decided to test
                BL read_character
                BL output_character
                SUB r0, r0, #0x30
                CMP r0, #0x1
                BEQ selectone
                CMP r0, #0x2
                BEQ selecttwo
                CMP r0, #0x3
                BEQ selectthree
                CMP r0, #0x4
                BEQ selectfour
                CMP r0, #0x5
                BEQ selectfive

;Run the selected subroutine, prompting user if needed
selectone:
                ;Inform user how to work tiva button
                LDR r4, ptr_to_tivabtnprompt
                MOV r0, r4
                BL output_string
                BL gpio_btn_and_LED_init
                BL read_tiva_push_button
                B exitselect
selecttwo:
                ;Inform user how to work push buttons
                LDR r4, ptr_to_pushbtnprompt
                MOV r0, r4
                BL output_string
                BL gpio_btn_and_LED_init
                BL read_from_push_btns
                B exitselect
selectthree:
                ;Prompt user for input number, read input and then convert from ascii
                LDR r4, ptr_to_ledsinputprompt
                MOV r0, r4
                BL output_string
                BL read_string
                LDR r0, ptr_to_num_1_string
                BL string2int
                push {r0}
                BL gpio_btn_and_LED_init
                POP {r0}
                BL illuminate_LEDs
                B exitselect
selectfour:
                ;Prompt user for input color, read input and then convert from ascii
                LDR r4, ptr_to_rgbinputprompt
                MOV r0, r4
                BL output_string
                BL read_character
                BL output_character
                SUB r0, r0, #0x30
                PUSH {r0}
                BL gpio_btn_and_LED_init
                POP {r0}
                BL illuminate_RGB_LED
                B exitselect
selectfive:
                ;Inform user how to work keypad
                LDR r4, ptr_to_keypadprompt
                MOV r0, r4
                BL output_string
                BL read_from_keypad
                B exitselect

exitselect:
                BL uart_init

                ;Prompt user to quit or continue
                LDR r0, ptr_to_quitprompt
                ;MOV r0, r4
                BL output_string
                BL read_character
                BL output_character
                CMP r0, #0x71
                BNE lab4top

                POP {lr}
                MOV pc, lr

        .end
