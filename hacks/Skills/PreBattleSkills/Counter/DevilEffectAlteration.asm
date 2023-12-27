.thumb

@called from 293F8
@r0=#0x0000004  effect id of the unit's equipped weapon?
@r1=#0x8BE27A8  ROM location of the equipped weapon?
@r2=#0x0000004  copy or r1?
@r3=#0x8017435
@r4=#0x203A4B8  defender struct - equipped item and uses after battle
@r5=#0x203A470  defender struct
@r6=#0x203A50C  battle rounds array (several bytes that hold item battle effects)
@r7=#0x203A3F0  attacker struct
@r8=#0x203A3F0  attacker struct
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007CE0
@r14=#0x80293F5
@r15=#0x80293F8

mov     r1,#0x19                        @vanilla instruction 1 - get the luck byte from the battle structs
ldsb    r1,[r5,r1]                      @vanilla instruction 2 - load the luck value
mov     r0,#0x1F                        @vanilla instruction 3 - set r0 to a starting value of 31
sub     r0,r0,r1                        @vanilla instruction 4 - perform the devil effect calculation of 31 - unit's luck
push    {r1}                            @preserve the original value of r1 on the stack so we can use it to holder our chosen unit ID
b       CheckUnit                       @branch to see if the skill holder is currently engaged in combat

CheckUnit:
    ldr     r1,DevilEffectAlterationID  @load our chosen skill holder ID into r1
    ldr     r3,[r5,#0x0]                @load the ROM location of the attacker's data
    ldrb    r3,[r3,#0x4]                @load their character ID byte
    cmp     r1,r3                       @compare that ID byte against our skill holder ID
    beq     ChangeDevilEffect           @if there's a match, then update the calculation for devil effect
    ldr     r3,[r7,#0x0]                @otherwise, our skill holder isn't the current attacker so we load the ROM location of the defender's data
    ldrb    r3,[r3,#0x4]                @load their character ID byte
    cmp     r1,r3                       @compare that ID byte against our skill holder ID
    beq     ChangeDevilEffect           @if there's a match then update the calculation for devil effect
    b       End                         @otherwise our skill holder isn't in this battle and so we branch to the end


ChangeDevilEffect:
    mov     r0,#0x64                    @set the devil effect to 100% for this battle
    b       End                         @now branch to the end

End:
    pop     {r1}                        @restore the value of r1 that we pushed to the stack at the beginning
    ldr     r3,=#0x8029400|1            @hardcode the return address as we're using jumpToHack instead of callToHack
    bx      r3                          @branch back to the vanilla function

.ltorg
.align
DevilEffectAlterationID:                @refer to the value defined in the event file
