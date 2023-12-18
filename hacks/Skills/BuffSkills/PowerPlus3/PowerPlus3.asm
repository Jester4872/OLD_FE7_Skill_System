.thumb

@called from 18AE0
@r0=#0x0000004  current unit power
@r1=#0x0000000  unit power boost
@r2=#0x0000000
@r3=#0x8BE222C
@r4=#0x3007D08
@r5=#0x203A3F0  attacker struct
@r6=#0x3007D08
@r7=#0x202BD50
@r8=#0x2022C60
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470
@r13=#0x3007CF0
@r14=#0x8018AE1
@r15=#0x8018AE6

push    {r14}                   @push the link register so we can return at the end
push    {r2-r5}                 @push these registers, as we'll be using them for the phase check
b       CheckCharacter          @branch to check the character ID

CheckCharacter:
    mov     r1,r0               @vanilla instruction 1
    mov     r0,#0x14            @vanilla instruction 2 - get the power bit
    ldsb    r0,[r4,r0]          @vanilla instruction 3 - load the power value
    ldr     r4,=#0x200310C      @if we're looking at the stat screen, r5 won't have the attacker struct so we need to load it 
    cmp     r4,r5               @check to see if the r5 is now equal to what we have loaded in r4
    beq     LoadAttackStruct    @if so, we need to load the attack struct
    ldr     r2,[r5,#0x0]		@load pointer to character data
    ldrb	r2,[r2,#0x4]		@load character ID byte
    mov     r4,r2               @copy over the battle struct to prevent overwriting it
    ldr     r4,PowerPlus3ID     @load the ID value we have defined
    cmp		r2,r4 			    @compare the loaded character ID byte to our chosen character's ID
    beq     ApplyPowerPlus3     @if we find a match, apply the power boost
    b       End                 @otherwise we branch to the end

LoadAttackStruct:
    ldr     r5,=0x203A3F0     
    ldr     r2,[r5,#0x0]		@load pointer to character data
    ldrb	r2,[r2,#0x4]		@load character ID byte
    mov     r4,r2               @copy over the battle struct to prevent overwriting it
    ldr     r4,PowerPlus3ID     @load the ID value we have defined
    cmp		r2,r4 			    @compare the loaded character ID byte to our chosen character's ID
    beq     ApplyPowerPlus3     @if we find a match, apply the power boost
    b       End                 @otherwise we branch to the end

ApplyPowerPlus3:
    add     r1,#3               @add three to the power boost
    b       End                 @then branch to the end

End:
    add     r0,r0,r1            @vanilla instruction 4 - add the power and boost together for the final total
    pop     {r2-r5}
    pop     {r3}
    pop     {r4}                @vanilla instruction 5
    pop     {r1}                @vanilla instruction 6
    bx      r3

.ltorg
.align
PowerPlus3ID:                   @refer to the value defined in the event file
