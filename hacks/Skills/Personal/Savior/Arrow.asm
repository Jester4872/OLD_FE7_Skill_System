.thumb

@called from 80F84  
@r0=#0x0000000
@r1=#0xFFFFFFF
@r2=#0xFFFFFFF
@r3=#0x8404B76
@r4=#0x200310C
@r5=#0x0000000
@r6=#0x0000000
@r7=#0x3007DD8
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000001
@r13=#0x3007D68
@r14=#0x8080F75
@r15=#0x8080F84 

ldr     r0,[r4,#0xC]
ldr     r0,[r0,#0xC]
mov     r1,#0x10
ldr     r3,[r4,#0xC]    @load the unit data in the RAM
ldr     r3,[r3,#0x0]    @load the unit data in the ROM
ldrb    r3,[r3,#0x4]    @load their character ID
cmp     r3,#0x17        @does it match our chosen character ID?
beq     RemoveRedArrows @if so, branch to reset the unit state
b       End             @otherwise branch to the end

RemoveRedArrows:
    mov     r1,#0x0     @removes the red arrows
    mov     r3,#0x52    @52 in #0xC represents a 'rescuer' unit. 
    sub     r0,r3       @we subtract it to get 0, or a 'normal' unit
    b       End

End:
    and     r0,r1
    ldr     r3,=#0x8080F8C|1
    bx      r3
