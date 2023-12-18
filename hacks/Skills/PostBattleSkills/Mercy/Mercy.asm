.thumb

@called from 29450
@r0=#0x0000000  current hp
@r1=#0x000000A  previous enemy hp
@r2=#0x000000A  attack damage of attacker?
@r3=#0x0000004
@r4=#0x203A438  equipped weapon and uses after battle attacker pointer
@r5=#0x203A3F0  attacker struct
@r6=#0x203A50C
@r7=#0x203A470  defender struct
@r8=#0x203A470  defender struct
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007CE0
@r14=#0x80293F5
@r15=#0x8029454

push    {r14}
sub     r0,r2,r1                @vanilla instruction 1
push    {r1}                    @vanilla instruction 2
ldr		r1,[r5,#0x0]		    @load pointer to character data
ldrb	r1,[r1,#0x4]		    @load character ID byte
mov     r3,r1                   @copy over the battle struct to prevent overwriting it
ldr     r3,MercyID              @load the ID value we have defined
cmp     r3,r1                   @compare against our chosen unit ID
beq     CheckEnemyHP            @if we find a match, check the enemy's HP
b       End                     @otherwise branch to the end

CheckEnemyHP:
    cmp     r0,#0               @check to see if the enemy unit's HP has hit 0
    beq     ApplyMercy          @branch to apply the mercy skill
    b       End                 @otherwise branch to the end

ApplyMercy:
    add     r0,#1               @add 1 to the enemy's remaining HP total
    b       End                 @branch to the end

NewBranchPoint:
    pop     {r4}
    bx      r3

End:
    pop     {r1}
    strb    r0,[r7,#0x13]       @vanilla instruction 3
    lsl     r0,r0,#0x18         @vanilla instruction 4
    ldr     r3,=#0x802945E|1    @restore r3 to its original value
    cmp     r0,#0x0             @branch check included in vanilla?
    bge     NewBranchPoint      
    mov     r0,#0x0             @vanilla instruction 5
    strb    r0,[r7,#0x13]       @vanilla instruction 6
    pop     {r3}
    bx      r3

.ltorg
.align
MercyID:                        @refer to the value defined in the event file

@As of the time of writing, the enemy death animation
@triggers even if Mercy is applied.
@It seems this branch point will only trigger if
@your enemy would already die.
@More research is required to select a better branch point
@or to branch away from triggering the death animation
