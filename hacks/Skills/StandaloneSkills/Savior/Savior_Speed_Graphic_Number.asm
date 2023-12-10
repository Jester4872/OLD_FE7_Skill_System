.thumb

@called from 18B38
@r0=#0x0002E01 equipped weapon and uses
@r1=#0x8018B39
@r2=#0x0000001
@r3=#0x8BE222C
@r4=#0x3007D08  stat screen graphics struct?
@r5=#0x203A3F0  attacker struct
@r6=#0x3007D08  stat screen graphics struct?
@r7=#0x202BDE0  character struct
@r8=#0x2022C60
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct 
@r13=#0x3007CF0
@r14=#0x80177B
@r15=#0x8018B38

lsl     r0,r0,#0x10
lsr     r2,r0,#0x10     
ldr     r0,[r4,#0xC]    @load unit state word
mov     r1,#0x10        @move #0x10 into register 1
ldr     r3,[r7,#0x0]    @load the unit data in the ROM
ldrb    r3,[r3,#0x4]    @load their character ID
cmp     r3,#0x17        @does it match our chosen character ID?
beq     ResetUnitState  @if so, branch to reset the unit state
ldr     r3,[r4,#0x0]    @load the unit data in the ROM
ldrb    r3,[r3,#0x4]    @load their character ID
cmp     r3,#0x17        @does it match our chosen character ID?
beq     ResetUnitState  @if so, branch to reset the unit state
b       End             @otherwise branch to the end

ResetUnitState:
    mov     r3,#0x52    @52 in #0xC represents a 'rescuer' unit. 
    sub     r0,r3       @we subtract it to get 0, or a 'normal' unit
    b       End

End:
    ldr     r3,=#0x8018B40|1
    bx      r3
