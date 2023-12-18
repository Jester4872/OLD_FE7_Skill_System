.thumb

@called from 7FEA0
@r0=#0x0000003  skill of unit (may or may not be halved in thr graphics struct)
@r1=#0x807FEA1
@r2=#0x0000000
@r3=#0x8BE222C
@r4=#0x0000000
@r5=#0x200310C
@r6=#0x200310C
@r7=#0x3007DD8  
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC stat screen graphics struct
@r12=#0x000001E
@r13=#0x3007D48
@r14=#0x8018B1B
@r15=#0x807FEA0

push    {r5}            @push the value of r5 onto the stack so we can use the register for comparison
mov     r4,r0           @move the skill of the unit (from r0) into r3
ldr     r2,[r6,#0xC]    @load the character struct
ldrb    r1,[r2,#0x15]   @load the unit's skill
ldr     r0,[r2,#0xC]    @load the unit state word
ldr     r3,[r2,#0x0]    @load their RAM data
ldrb    r3,[r3,#0x4]    @load their character ID byte
ldr     r3,SaviorBattleID  @load the value we defined in the event file
cmp     r3,r2           @compare it against our chosen unit ID
beq     ResetUnitState  @if so, branch to reset the unit state
b       End             @otherwise branch to the end

ResetUnitState:
    mov     r3,#0x52    @52 in #0xC represents a 'rescuer' unit. 
    sub     r0,r3       @we subtract it to get 0, or a 'normal' unit
    b       End         @branch to the end

End:
    pop     {r5}        @restore the original value of r5
    ldr     r2,=#0x807FEA8|1    @hardcode the return address as we're using jumpToHack instead of callToHack
    bx      r2          @branch back to the vanilla function

.ltorg
.align
SaviorBattleID:         @refer to the value defined in the event file
