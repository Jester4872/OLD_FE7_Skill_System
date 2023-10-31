.thumb

@called from 7FF98
@r0=#0x8BE0204
@r1=#0x202BD50
@r2=#0x0000001
@r3=#0x0000005
@r4=#0x000000A
@r5=#0x0000010
@r6=#0x200310C
@r7=#0x3007DD8
@r8=#0x0000000
@r9=#0x00000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x000001E
@r13=#0x3007D48
@r14=#0x807F87F
@r15=#0x807FF98

push    {r14}               @push the current location of the link register to the stack
mov     r3,#0x12
ldsb    r3,[r0,r3]          @restore value of r3 (base movement) that was overwritten by this hack
mov     r0,#0x1D            @movement bonus
ldsb    r0,[r1,r0]
b       CheckCharacter

CheckCharacter:
    push    {r2}
    ldr     r2,[r1,#0x0]    @load pointer to character data
    ldrb	r2,[r2,#0x4]	@load character ID byte
    cmp		r2,#0x03 		@compare the loaded character ID byte to Lyn's ID
    beq     ApplyMovePlus2
    b       End

ApplyMovePlus2:
    add     r0,#2           @add 2 to movement bonus
    b       End

End:
    pop     {r2}
    add     r0,r0,r3        @add base movement (r3) and bonus movement (r0) together and store in r0
    pop     {r1}            @pop the return address early so the stack pointer (sp) is at the right position
    str     r0,[sp]         @sp = #0x3007D4C
    mov     r5,#0xF         @additional vanilla instruction
    str     r5,[sp,#0x4]    @additional vanilla instruction
    bx      r1


