.thumb

@called from 28A78
@r0=#0x2000018
@r1=#0x203A456  attacker struct crit location
@r2=#0x0000000
@r3=#0x0000017  loaded crit
@r4=#0x3007CE8
@r5=#0x203A3F0  attacker struct
@r6=#0x0000000
@r7=#0x202BD50  character struct
@r8=#0x2022C60
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x202A470 defender struct
@r13=#0x3007CE8
@r14=#0x8026A39
@r15=#0x8028A78

push    {r14}                   @preserve the return address by pushing it onto the stack
ldrh    r3,[r1]                 @load the value for the attacker's critical hit rate (stored in r1) into r3
add     r0,r3,r2                @vanilla instruction 1 - add the S rank crit bonus (in r2) to the crit rate?
b       CheckCharacterID        @branch to check the character's ID

CheckCharacterID:
    push    {r1-r4}             @preserve the values of these registers on the stack so we can use them now
    sub     r1,#0x66            @remove the offset so we can get the start of the struct
    ldr     r2,[r1]             @load the ROM location of the character data in the struct
    ldrb    r2,[r2,#0x4]        @load the character ID byte
    ldr     r3,CriticalForceID  @load the character ID value we have defined in the event file
    cmp     r3,r2               @compare our chosen ID against the current ID of the character we're looking at
    beq     CheckFlag           @if a match is found, we branch to check our double crit rate flag
    b       End                 @otherwise we branch to the end

@As this skill can apply twice in a round, we set a flag to ensure it only applies once
CheckFlag:
    mov     r3,#0x1C            @get the character struct byte we're using to store the flag
    ldrb    r4,[r1,r3]          @load its value
    cmp     r4,#0xFF            @check to see if it is set (the set value being #0xFF)
    beq     End                 @if it is we have nothing more to do, and thus branch to the end
    b       ApplyFlag           @otherwise we branch to apply the flag

ApplyFlag:
    mov     r4,#0xFF            @get the flag  set value
    strb    r4,[r1,r3]          @store it in the byte we're using to store the flag
    b       CriticalForce       @and now we branch to apply the sill

CriticalForce:
    mov     r3,#0x15            @move the skill byte into a free register
    ldrb    r3,[r1,r3]          @load the skill byte value                 
    asr     r2,r3,#1            @halve the skill value and store it in the register for the critical hit rate
    add     r0,r3,r2            @add the original skill value on top of the last calculation (so the crit rate becomes 1.5x skill)
    b       End                 @now that that's done, we branch to the end

End:
    pop     {r1-r4}             @restore the register values
    strh    r0,[r1]             @vanilla instruction 2 - store the new critical hit rate in the battle struct's crit rate byte
    add     r1,#0x2             @vanilla instruction 3 - add 2 to get the crit rate avoid location
    ldrh    r3,[r1]             @vanilla instruction 4 - load crit rate avoid into r3
    ldrb    r4,[r4,#0x6]        @vanilla instruction 5 - not sure what this does?
    add     r0,r3,r4            @vanilla instruction 6 - not sure what this does?
    pop     {r1}                @pop the value for the return address
    bx      r1                  @using that value, branch back to the vanilla function

.ltorg
.align
CriticalForceID:                @refer to the value defined in the event file
