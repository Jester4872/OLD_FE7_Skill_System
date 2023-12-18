.thumb

@called from 7FEEC
@r0=#0x0000003  skill of unit (may or may not be halved in thr graphics struct)
@r1=#0x807FEED
@r2=#0x0000000
@r3=#0x8BE222C
@r4=#0x0000000
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
@r15=#0x807FEEC

push    {r5}            @push r5 onto the stack so we can use the register for comparison
mov     r4,r0           @copy the skill of the unit into r4
ldr     r2,[r6,#0xC]    @load the character struct
ldrb    r1,[r2,#0x16]   @load the unit's speed
ldr     r0,[r2,#0xC]    @load the unit state word
ldr     r3,[r2,#0x0]    @load their RAM data
ldrb    r3,[r3,#0x4]    @load their character ID byte
ldr     r5,SavoirSpeedID  @load the value we defined in the event file
cmp     r3,r5           @compare it against our chosen unit ID
beq     ResetUnitState  @if so, branch to reset the unit state
b       End             @otherwise branch to the end

ResetUnitState:
    mov     r3,#0x52    @52 in #0xC represents a 'rescuer' unit. 
    sub     r0,r3       @we subtract it to get 0, or a 'normal' unit
    b       End

End:
    pop     {r5}        @restore the original value in this register
    ldr     r3,=#0x807FEF4|1    @hardcode the return address, as we're using jumpToHack instead of callToHack
    bx      r3          @branch back to the vanilla function
    
.ltorg
.align
SavoirSpeedID:          @refer to the value defined in the event file
