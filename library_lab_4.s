        .text
        .global uart_init
        .global gpio_btn_and_LED_init
        .global keypad_init ; Downloaded from the course website
        .global output_character
        .global read_character
        .global read_string
        .global output_string
        .global read_from_push_btns
        .global illuminate_LEDs
        .global illuminate_RGB_LED
        .global read_tiva_push_button
        .global read_from_keypad
        .global string2int
        .global int2string

gpio_btn_and_LED_init:
        PUSH {lr}
    ; Enable clock for port F and D
    MOV r1, #0xE608
        MOVT r1, #0x400F
        mov r0, #0x2B
        STRB r0, [r1]

    ; Setting the direction for port F, 0 button, 1 for RGB LEDs, for tiva board
    MOV r1, #0x5400
        MOVT r1, #0x4002
        mov r0, #0x0E
        STRB r0, [r1]

        ; Setting the direction for port B, 4 LEDs
    MOV r1, #0x5400
        MOVT r1, #0x4000
        mov r0, #0x0F
        STRB r0, [r1]

    ; Setting the direction for port D, 0 button, for keypad
    MOV r1, #0x7400
        MOVT r1, #0x4000
        mov r0, #0x00
        STRB r0, [r1]

        ; Set the pin to be digital for the tiva button and LED's
        MOV r1, #0x551C
        MOVT r1, #0x4002
        mov r0, #0x1F
        STRB r0, [r1]

        ; Set the pin to be digital for the base board LED's
        MOV r1, #0x551C
        MOVT r1, #0x4000
        mov r0, #0x0F
        STRB r0, [r1]

        ; Set the pin to be digital for the button on base board
        MOV r1, #0x751C
        MOVT r1, #0x4000
        mov r0, #0x0F
        STRB r0, [r1]

        ; Set the PUR for pin 4 for the push button
        MOV r1, #0x5510
        MOVT r1, #0x4002
        mov r0, #0x10
        STRB r0, [r1]

        ; Set the PUR for pin 4 for the push button
        MOV r1, #0x751C
        MOVT r1, #0x4000
        mov r0, #0x0F
        STRB r0, [r1]

        POP {lr}
        MOV pc, lr

read_from_keypad:
        PUSH {lr}

        BL keypad_init

        MOV r3, #1
keypadloop:
        MOV r1, #0x7000
        MOVT r1, #0x4000
        STRB r3, [r1, #0x3FC]

        MOV r1, #0x4000
        MOVT r1, #0x4000
        LDRB r2, [r1, #0x3FC]
        CMP r2, #0
        BGT exitkeypadloop

        LSL r3, r3, #1
        CMP r3, #0
        BNE keypadloop
        MOV r3, #1
        B keypadloop
exitkeypadloop:

        LSR r2, r2, #2

;   r2 1 2 3 4
; r3
; 1    1 2 3
; 2    4 5 6
; 3    7 8 9
; 4      0

        MOV r0, #0
        CMP r3, #8
        BEQ exitkeypadread

        CMP r3, #4
        BNE r3not4
        MOV r3, #3
r3not4:
        CMP r3, #8
        BNE r3not8
        MOV r3, #4
r3not8:
        CMP r2, #4
        BNE r2not4
        MOV r2, #3
r2not4:
        CMP r2, #8
        BNE r2not8
        MOV r2, #4
r2not8:

        SUB r3, r3, #1
        MOV r1, #3
        MUL r3, r3, r1
        ADD r0, r3, r2

exitkeypadread:

        PUSH {r0}
        BL gpio_btn_and_LED_init
        POP {r0}

        POP {lr}
        MOV pc, lr

read_from_push_btns:
        PUSH {lr,r4}

        MOV r4, #0
        MOV r3, #0

        MOV r1, #0x7000
        MOVT r1, #0x4000
        LDRB r0, [r1, #0x3FC]

        AND r3, r0, #1
        LSL r3, r3, #3
        ORR r4, r4, r3

        AND r3, r0, #2
        LSL r3, r3, #1
        ORR r4, r4, r3

        AND r3, r0, #4
        LSR r3, r3, #3
        ORR r4, r4, r3

        AND r3, r0, #8
        LSR r3, r3, #1
        ORR r4, r4, r3
        
        MOV r0, r4

        POP {lr, r4}
        MOV pc, lr

read_tiva_push_button:
        PUSH {lr}

        MOV r1, #0x5000
        MOVT r1, #0x4002
        LDRB r0, [r1, #0x3FC]
        MVN r0, r0
        AND r0, r0, #0x10
        LSR r0, r0, #4

        POP {lr}
        MOV pc, lr

illuminate_LEDs:
        PUSH {lr}

        AND  r0, r0, #0xF

        MOV r1, #0x5000
        MOVT r1, #0x4000
        STRB r0, [r1, #0x3FC]

        POP {lr}
        MOV pc, lr

illuminate_RGB_LED:
        PUSH {lr}

        AND  r0, r0, #0x7

        LSL r0, r0, #0x1
        MOV r1, #0x5000
        MOVT r1, #0x4002
        LDRB r2, [r1]
        BFC r2, #0x1, #0x3
        ORR r0, r0, r2
        STRB r0, [r1, #0x3FC]

        POP {lr}
        MOV pc, lr

read_string:
        PUSH {lr}   ; Store register lr on stack

        MOV r1, r0

readstringloop:
        BL read_character
        BL output_character

        CMP r0, #0x0d
        BEQ exitreadstring

        STRB r0, [r1]
        ADD r1, r1, #1

        B readstringloop

exitreadstring:

        MOV r0, #0x0a
        BL output_character

        MOV r0, #0
        STRB r0, [r1]

        POP {lr}
        mov pc, lr


output_string:
        PUSH {lr}   ; Store register lr on stack

        MOV r1, r0

outputstringloop:
        LDRB r0, [r1]

        CMP r0, #0
        BEQ exitoutputstring

        BL output_character

        ADD r1, r1, #1

        B outputstringloop

exitoutputstring:

        MOV r0, #0x0d
        BL output_character
        MOV r0, #0x0a
        BL output_character

        POP {lr}
        mov pc, lr

read_character:
        PUSH {lr}   ; Store register lr on stack

        MOV r9, r7

checkread:
        MOV r7, #0xC018 ; r7 = checkaddr
        MOVT r7, #0x4000
        LDRB r3, [r7]
        AND r3, r3, #0x10
        CMP r3, #0
        BGT checkread

        MOV r8, #0xC000
        MOVT r8, #0x4000
        LDRB r0, [r8]

        MOV r7, r9

        POP {lr}
        mov pc, lr


output_character:
        PUSH {lr}   ; Store register lr on stack

        MOV r9, r7

checkdisplay:
        MOV r7, #0xC018 ; r7 = checkaddr
        MOVT r7, #0x4000
        LDRB r3, [r7]
        AND r3, r3, #0x20
        CMP r3, #0
        BGT checkdisplay

        MOV r8, #0xC000
        MOVT r8, #0x4000
        STRB r0, [r8]

        MOV r7, r9

        POP {lr}
        mov pc, lr


uart_init:
        PUSH {lr}  ; Store register lr on stack

        MOV r0, #0xe618
        MOVT r0, #0x400f
        MOV r1, #1
        STRW r1, [r0]

        MOV r0, #0xe608
        MOVT r0, #0x400f
        MOV r1, #1
        STRW r1, [r0]

        MOV r0, #0xc030
        MOVT r0, #0x4000
        MOV r1, #0
        STRW r1, [r0]

        MOV r0, #0xc024
        MOVT r0, #0x4000
        MOV r1, #8
        STRW r1, [r0]

        MOV r0, #0xc028
        MOVT r0, #0x4000
        MOV r1, #44
        STRW r1, [r0]

        MOV r0, #0xcfc8
        MOVT r0, #0x4000
        MOV r1, #0
        STRW r1, [r0]

        MOV r0, #0xc02c
        MOVT r0, #0x4000
        MOV r1, #0x60
        STRW r1, [r0]

        MOV r0, #0xc030
        MOVT r0, #0x4000
        MOV r1, #0x0301
        STRW r1, [r0]

        MOV r0, #0x451c
        MOVT r0, #0x4000
        LDRB r1, [r0]
        ORR r1, r1, #0x03
        STRW r1, [r0]

        MOV r0, #0x4420
        MOVT r0, #0x4000
        LDRB r1, [r0]
        ORR r1, r1, #0x03
        STRW r1, [r0]

        MOV r0, #0x452c
        MOVT r0, #0x4000
        LDRB r1, [r0]
        ORR r1, r1, #0x11
        STRW r1, [r0]

        POP {lr}
        mov pc, lr

int2string:
        PUSH {lr}   ; Store register lr on stack

        ;ADD r1, r1, #6

        MOV r9, r4
        MOV r10, r5
        MOV r11, r6

        MOV r5, #10
        MOV r6, r0
        MOV r2, #0

charactercounterloop:

        ADD r2, r2, #1;  increment i
        SDIV r6, r6, r5; number //= 10 (floor divide by 10)

        CMP r6, #0;
        BGT charactercounterloop; return to the top

        ADD r1, r1, r2
        SUB r1, r1, #1
        STRB r6, [r1, #1]

nextplace:

        MOV r4, r0
        sdiv r2, r4, r5
        mul r3, r2, r5 ; r4 %= 10
        sub r4, r4, r3

        ADD r4, r4, #0x30
        STRB r4, [r1]
        SUB r1, r1, #1
        MOV r11, #10
        SDIV r0, r0, r11

        CMP r0, #0
        BNE nextplace

        MOV r4, r9
        MOV r5, r10
        MOV r6, r11

        POP {lr}
        mov pc, lr


string2int:
        PUSH {lr}   ; Store register lr on stack

        ;SUB r1, r1, #6

        MOV r2, #0

nextload:
        LDRB r1, [r0]
        CMP r1, #0x0
        BEQ exitstring1intloop

        MOV r11, #10
        MUL r2, r2, r11   ; r2 *= 10
        SUB r3, r1, #0x30 ; r2 = r1-'0'
        ADD r2, r2, r3

        ADD r0, r0, #1

        B nextload
exitstring1intloop:

        MOV r0, r2

        POP {lr}
        mov pc, lr

        .end
