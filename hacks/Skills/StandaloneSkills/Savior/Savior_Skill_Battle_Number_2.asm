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

ldr     r0,[r2,#0x4]    @load the character struct
ldrb    r1,[r0,#0x15]   @load the unit's skill
ldr     r0,[r2,#0xC]    @load the unit state word
ldr     r2,[r2,#0x0]    @load their RAM data
ldrb    r2,[r2,#0x4]    @load their character ID byte
cmp     r2,#0x17        @does it match our chosen character ID?
beq     ResetUnitState  @if so, branch to reset the unit state
b       End             @otherwise branch to the end

ResetUnitState:
    mov     r2,#0x52    @52 in #0xC represents a 'rescuer' unit. 
    sub     r0,r2       @we subtract it to get 0, or a 'normal' unit
    b       End

End:
    and     r0,r5
    ldr     r2,=#0x807FEC8|1
    bx      r2
