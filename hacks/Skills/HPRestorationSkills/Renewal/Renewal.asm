.thumb

@called from 19B20
@r0=#0x0000001  tile ID
@r1=#0x202EBD8
@r2=#0x0000002
@r3=#0x0000000
@r4=#0x2024F00
@r5=#0x202BD50  character struct
@r6=#0x0000001
@r7=#0x0000001
@r8=#0x0000000  alliance byte?
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000001
@r13=#0x3007D68
@r14=#0x8024335
@r15=#0x8019B20

push    {r14}
ldr     r1,=#0x8BE47C4          @load the terrain healing amount struct
add     r0,r0,r1                @add the tile ID to the struct
ldrb    r0,[r0]                 @load the healing amount of that tile
b       CheckCharacter

CheckCharacter:
    push    {r1,r2}
    ldr     r1,[r5]             @load the ROM location of the character's data
    ldrb    r1,[r1,#0x4]        @load the character ID
    mov     r2,r1               @copy over the battle struct to prevent overwriting it
    ldr     r2,RenewalID        @load the ID value we have defined
    cmp     r1,r2               @compare against our chosen unit ID
    beq     ApplyRenewal        @apply Renewal if there is a match
    pop     {r1,r2}             @otherwise restore the pushed registers
    b       End                 @and then branch to the end

ApplyRenewal:
    pop     {r1,r2}             @restore the pushed registers
    add     r0,#0x1E            @add a 30% healing boost at the start of the turn
    b       End

End:
    lsl     r0,r0,#0x18         @as far as I can tell, these two opcodes negate each other
    asr     r0,r0,#0x18
    pop     {r3}
    bx      r3

.ltorg
.align
RenewalID:                      @refer to the value defined in the event file
