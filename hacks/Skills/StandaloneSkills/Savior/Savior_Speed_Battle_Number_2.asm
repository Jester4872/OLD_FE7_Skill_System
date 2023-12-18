.thumb

@called from 7FF08
@r0=#0x3000000
@r1=#0x0000003
@r2=#0x202BDE0
@r3=#0x0000003
@r4=#0x0000003
@r5=#0x0000010
@r6=#0x200310C
@r7=#0x3007DD8  
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC stat screen graphics struct
@r12=#0x000001E
@r13=#0x3007D48
@r14=#0x8018B5B
@r15=#0x807FF08

push    {r5}            @push r5 onto the stack so we can use the register for comparison
str     r4,[sp]         @not sure what this is doing as I don't know what's in sp?
ldr     r0,[r2,#0x4]    @load the character struct
ldrb    r1,[r0,#0x16]   @load the unit's speed
ldr     r0,[r2,#0xC]    @load the unit state word
ldr     r2,[r2,#0x0]    @load their RAM data
ldrb    r2,[r2,#0x4]    @load their character ID byte
ldr     r3,SaviourSpeedID  @load the value we defined in the event file
cmp     r3,r2           @compare it against our chosen unit ID
beq     ResetUnitState  @if so, branch to reset the unit state
b       End             @otherwise branch to the end

ResetUnitState:
    mov     r2,#0x52    @52 in #0xC represents a 'rescuer' unit. 
    sub     r0,r2       @we subtract it to get 0, or a 'normal' unit
    b       End         @branch to the end

End:
    pop     {r5}        @restore the original value in this register
    ldr     r2,=#0x807FF10|1    @hardcode the return address, as we're using jumpToHack instead of callToHack
    bx      r2          @branch back to the vanilla function

.ltorg
.align
SaviourSpeedID:         @refer to the value defined in the event file
