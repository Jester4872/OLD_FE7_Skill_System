.thumb

@called from 1C4DC
@r0=#0x202BD50
@r1=#0x8BE0204
@r2=#0x0000000
@r3=#0x83BA00C
@r4=#0x0000001
@r5=#0x3004690
@r6=#0x202BD50
@r7=#0x3007DD8
@r8=#0x0000000
@r9=#0x00000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000001
@r13=#0x3007D88
@r14=#0x801C5D3
@r15=#0x801C4DC

push    {r14}
ldrb    r2,[r0,#0x1D]       @load bonus movement
ldrb    r1,[r1,#0x12]       @load base movement
b       CheckCharacter

CheckCharacter:
    push    {r3,r4}
    ldr     r3,[r5,#0x0]	@load pointer to character data
    ldr     r3,[r2,#0x0]
    ldrb	r3,[r2,#0x4]	@load character ID byte
    mov     r4,r3           @copy over the battle struct to prevent overwriting it
    ldr     r3,MovePlus2FieldID   @load the ID value we have defined
    cmp		r4,r3 			@compare the loaded character ID byte to our chosen character's ID 
    beq     ApplyMovePlus2Field

ApplyMovePlus2Field:
    add     r2,#2           @add 2 to bonus movement
    b       End

End:
    pop     {r3,r4}
    add     r1,r2,r1        @combine the base and bonus movement values
    ldr     r2,=#0x203A85C
    ldrb    r2,[r2,#0x10]
    sub     r1,r1,r2
    pop     {r3}            @pop the return address
    bx      r3

.ltorg
.align
MovePlus2FieldID:     @refer to the value defined in the event file
