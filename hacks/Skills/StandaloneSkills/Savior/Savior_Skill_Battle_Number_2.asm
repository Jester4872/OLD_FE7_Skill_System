.thumb

@called from 7FEC0
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

push    {r4}            @preserve the value of r4 onto the stack so we can use the register for comparison
ldr     r0,[r2,#0x4]    @load the character struct
ldrb    r1,[r0,#0x15]   @load the unit's skill
ldr     r0,[r2,#0xC]    @load the unit state word
ldr     r2,[r2,#0x0]    @load their RAM data
ldrb    r2,[r2,#0x4]    @load their character ID byte
ldr     r3,SaviourBattleID  @load the value we defined in the event file
cmp     r3,r2           @compare it against our chosen unit ID
beq     ResetUnitState  @if so, branch to reset the unit state
b       End             @otherwise branch to the end

ResetUnitState:
    mov     r2,#0x52    @52 in #0xC represents a 'rescuer' unit. 
    sub     r0,r2       @we subtract it to get 0, or a 'normal' unit
    b       End         @branch to the end

End:
    and     r0,r5       @not sure what this does
    ldr     r2,=#0x807FEC8|1    @load the hardcoded return address, as we're using jumpToHack instead of callToHack
    bx      r2          @branch back to the vanilla function

.ltorg
.align
SaviourBattleID:        @refer to the value defined in the event file
