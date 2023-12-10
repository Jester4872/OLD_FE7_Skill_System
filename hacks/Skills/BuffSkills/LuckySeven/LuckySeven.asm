.thumb

@called from 18A70
@r0=#0x203A3F0  attacker struct
@r1=#0x0000000
@r2=#0x203A470  defender struct
@r3=#0x0000000
@r4=#0x203A3F0  attacker struct
@r5=#0x0000000
@r6=#0x202BD50  character struct - ally
@r7=#0x0000000
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x000001D
@r13=#0x3007D5C
@r14=#0x80A02C7
@r15=#0x8018A70

.equ GetRandomNumber,   0x8000E04

.macro blh to, reg             @special macro opcode so we can use bx and return afterwards to our branch point via blh
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push    {r4,r5,r14}             @vanilla instruction 1
mov     r5,r0                   @vanilla instruction 2
mov     r4,#0x13                @vanilla instruction 3
ldsb    r4,[r5,r4]              @vanilla instruction 4
push    {r0-r4}                 @push these registers, as we'll be using them for the phase check
b       CheckCharacter

CheckCharacter:
    ldr     r3,[r0,#0x0]		@load pointer to character data
    ldrb	r3,[r3,#0x4]		@load character ID byte
    cmp		r3,#0x03 			@compare the loaded character ID byte to our chosen character's ID
    beq     GetTurnCount        @if it's our chosen character, branch to get the turn count
    b       End                 @otherwise we branch to the end

GetTurnCount:
    mov     r4,r0               @move the character struct into r3

    ldr		r0,=#0x202BBF8	    @load chapter struct
    mov		r1,#0x10			@get turn number short
    ldsb	r0,[r0,r1]		    @load turn number
    b       IsItNewTurn         @branch to check if the turn has changed

IsItNewTurn:
    mov     r3,#0x47            @get a free byte in the character struct
    ldrb    r1,[r4,r3]          @load the value in it
    cmp     r0,r1               @compare the current turn in r0 to the saved turn in byte r1
    bgt     SetTurnByte         @if the current turn is greater, we're on a fresh player phase and thus branch to set the new turn
    b       End                 @else the current turn is the same, so we don't need to reapply the skill

SetTurnByte:
    strb    r0,[r4,r3]          @store the current turn short as a byte (because who the hell is waiting for over 255 turns?)
    b       RNGenerator

RNGenerator:
    blh     GetRandomNumber,r0  @get a random number between 0-99
    mov     r1,#7               @divide the result by 7
    swi     6                   @this divides the value in r0 by the value in r1 and returns the result in r0 and the remainder in r1
    add     r1,#1               @we add one to the remainder so the values chosen are between 1-7
    cmp     r1,#0x7             @compare the generated result against 7
    beq     RNGenerator         @if we rolled a 7, roll again (that would be HP but I haven't accounted for it yet)
    b       SetLSBitFlag        @branch to set the lucky seven bit flag

SetLSBitFlag:
    mov     r2,#0x1C            @we'll store the bit flag in the ballista byte (subject to change depending on the unit)
    strb    r1,[r4,r2]          @store the random number in r1 in the ballista byte of the current character struct
    b       End

End:
    pop     {r0-r4}
    ldr     r3,=#0x8018A78|1
    bx      r3
