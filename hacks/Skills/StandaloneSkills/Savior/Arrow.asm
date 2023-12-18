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

push    {r4}            @push r4 onto the stack so we can use it for a comparison
ldr     r0,[r4,#0xC]    @load the unit state bitfield
ldr     r0,[r0,#0xC]    @load the rescue byte?
mov     r1,#0x10        @preempt the inclusion of the debuff arrows unless later overridden
ldr     r3,[r4,#0xC]    @load the unit data in the RAM
ldr     r3,[r3,#0x0]    @load the unit data in the ROM
ldrb    r3,[r3,#0x4]    @load their character ID
ldr     r4,ArrowID      @load the value we defined in the event file
cmp     r3,r4           @compare it against our chosen unit ID
beq     RemoveRedArrows @if so, branch to reset the unit state
b       End             @otherwise branch to the end

RemoveRedArrows:
    mov     r1,#0x0     @removes the red arrows
    mov     r3,#0x52    @52 in #0xC represents a 'rescuer' unit. 
    sub     r0,r3       @we subtract it to get 0, or a 'normal' unit
    b       End         @branch to the end

End:
    pop     {r4}        @restore the original value of r4 here
    and     r0,r1       @not sure what the point of this is?
    ldr     r3,=#0x8080F8C|1    @load the hardcoded return address as we're using jumpToHack instead of callToHack
    bx      r3          @branch back to the vanilla function

.ltorg
.align
ArrowID:                @refer to the value defined in the event file
