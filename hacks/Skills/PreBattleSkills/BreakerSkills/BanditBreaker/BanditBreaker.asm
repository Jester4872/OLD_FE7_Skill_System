.thumb

@called from 16834
@r0=#0x0000009
@r1=#0x0000001
@r2=#0x203A470
@r3=#0x0000032  class of enemy?
@r4=#0x0002601  equipped item and uses short
@r5=#0x203A3F0  attacker struct
@r6=#0x203A438  attacker struct - equipped item and uses
@r7=#0x203A470  defender struct
@r8=#0x202BD50  character struct of this ally
@r9=#0x202CEC0  character struct of this enemy
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007D00
@r14=#0x8028B3B
@r15=#0x8016834

.equ BanditEffectiveness, 0x8D00000

lsl     r0,r0,#0x2              @vanilla instruction
ldr     r1,=#0x8BE222C          @vanilla instruction
add     r0,r0,r1                @vanilla instruction
ldr     r2,[r0,#0x10]           @vanilla instruction
b       CheckCharacter

CheckCharacter:
    push    {r0,r1}
    ldr     r0,=#0x203A3F0      @check the attacker struct for the character to apply this skill to
    ldr     r0,[r0,#0x0]
    ldrb    r0,[r0,#0x4]
    mov     r3,r0               @copy over the battle struct to prevent overwriting it
    ldr     r3,BanditBreakerID  @load the ID value we have defined
    cmp     r3,r0               @compare against our chosen unit ID
    beq     BanditBreaker
    ldr     r0,=#0x203A470      @if we don't find them there, then check the defender struct
    ldr     r0,[r0,#0x0]
    ldrb    r0,[r0,#0x4]
    mov     r3,r0               @copy over the battle struct to prevent overwriting it
    ldr     r3,BanditBreakerID  @load the ID value we have defined
    cmp     r3,r0               @compare against our chosen unit ID
    beq     BanditBreaker
    b       End                 @if all else fails, we branch to the end

BanditBreaker: 
    ldr     r2,=BanditEffectiveness  @load the hardcoded bandit effectiveness list
    b       End

End:
    ldr     r0,[r7,#0x4]        @load the pointer to the enemy's character struct
    ldrb    r3,[r0,#0x4]        @load their class data
    pop     {r0,r1}             @restore original values
    ldr     r5,=#0x801683C|1    @hardcode return address since we're using jumphack instead of callhack
    bx      r5

.ltorg
.align
BanditBreakerID:                @refer to the value defined in the event file
