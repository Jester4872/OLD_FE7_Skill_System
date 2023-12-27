.thumb

@called from 1742C
@r0=#0x0000046
@r1=#0x0000276
@r2=#0x0000000
@r3=#0x0000004
@r4=#0x203A3F0  attacker struct
@r5=#0x203A438  attacker struct - equipped item and uses after battle
@r6=#0x0000000
@r7=#0x202BDE0  character struct of player
@r8=#0x20252FD
@r9=#0x202BDE0  character struct of player
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct
@r13=#0x3007D14
@r14=#0x8028561
@r15=#0x801742C

# So this was a fun one. I couldn't replicate quite how it was done in skill systems as I was struggling to 'negate' the damage
# my opponent did and take it away from their HP. Then I remembered that there was functionality in the base game that already did this!
# I made use of the devil axe and applied its effect to my opponent if the skill holder was in combat, but this didn't work 100% of the
# time due to how the devil axe effect is calculated (31 - luck percent chance). So I hooked this routine as well and set it to 100% if
# the skill holder is in combat! The last thing left to do now is make sure the skill only takes effect if both units are next to each other.

lsl		r1,r1,#0x2              @vanilla instruction
ldr     r0,=#0x8BE222C          @vanilla instruction
add		r1,r1,r0                @vanilla instruction
push    {r1-r3,r6,r7}           @preserve the value of r2 so we can use this register for character ID checks
mov     r6,r0                   @copy the base item struct into another register
ldrb    r0,[r1,#0x1F]           @vanilla instruction - load the ability byte of the equipped weapon
b       CheckAttacker           @branch to first check if the attacker struct holds the skill user

CheckAttacker:
    ldr     r3,=#0x203A3F0      @load the attacker struct
    ldr		r2,[r3,#0x0]	    @load pointer to character data
    ldrb	r2,[r2,#0x4]	    @load character id byte
    mov     r7,r2               @copy over the battle struct to prevent overwriting it
    ldr     r7,CounterID        @load the ID value we have defined
    cmp     r7,r2               @compare against our chosen unit ID
    beq     LoadDefender        @if a match is found, then the enemy is in the defender struct and so we load the defender into a spare register
    b       CheckDefender       @otherwise, we branch to check if the defender struct holds the skill user

CheckDefender:
    ldr     r3,=#0x203A470      @otherwise, load the defender struct
    ldr		r2,[r3,#0x0]	    @load pointer to character data
    ldrb	r2,[r2,#0x4]	    @load character ID byte
    mov     r7,r2               @copy over the battle struct to prevent overwriting it
    ldr     r7,CounterID        @load the ID value we have defined
    cmp     r7,r2               @compare against our chosen unit ID
    beq		LoadAttacker	    @if a match is found, then the enemy is in the attacker struct and so we load the attacker into a spare register
    b 		End				    @otherwise, branch to the end of the code

LoadAttacker:
    ldr     r7,=#0x203A3F0      @load the attacker struct into a spare register (this is where the enemy is stored)
    b       CheckItem           @branch to check if the enemy is holding an item

LoadDefender:
    ldr     r7,=#0x203A470      @load the defender struct into a spare register (this is where the enemy is stored)
    b       CheckItem           @branch to check if the enemy is holding an item

CheckItem:
    push    {r4,r5}             @preserve the values of these registers on the stack so we can use the registers themselves
    mov     r4,r1               @copy the item struct with the address of the unit's equipped weapon to a new register for later comparison
    mov     r5,r6               @copy the base item struct to a new register
    ldrb    r3,[r7,#0x1E]       @load the item ID of the enemy's first equipped item
    mov     r2,#0x24            @move the struct length of a single item into a register
    mul     r2,r3               @multiply the struct length by the item ID we found
    add     r5,r2               @add the base struct and struct lengths together
    cmp     r4,r5               @compare modified item struct in r5 against the item struct that was produced at the start
    beq     Counter             @if they're the same, we know we're looking at the unit we should apply the skill to
    pop     {r4,r5}             @else we restore the structs we pushed initially
    b       End                 @and then branch to the end

Counter:
    pop     {r4,r5}
    mov		r0,#0x04	        @load the byte into r0 that controls the devil effect (the FE7 decomp in FEBuilder and the Teq doc seem to be working off of FE8, so they're not accurate for FE7)
    b 		End

End:
    pop		{r1-r3,r6,r7}       @restore the value that was in r2 originally
    ldr		r3,=#0x8017434|1	@load the return address
    bx		r3                  @branch back to the vanilla function

.ltorg
.align
CounterID:                      @refer to the value defined in the event file

















@ ldrb    r2,[r7,#0x13]                  @vanilla instruction 1 - load the unit's HP
@ ldrb    r1,[r1,#0x04]                  @vanilla instruction 2 - load the enemy's attack
@ push    {r0-r4}                        @save these registers so we can use them
@ ldr     r4,[r5,#0x0]                   @load the ROM data
@ ldrb    r4,[r4,#0x4]                   @load the character ID
@ cmp     r4,#0x3                        @compare against our chosen character ID
@ beq     CheckWeaponType                @it is our character, so branch to check the enemy's weapon
@ b       End                            @else we branch to the end

@ CheckWeaponType:
@     mov     r4,#0x50                   @get the weapon type byte
@     ldr     r4,[r7,r4]                 @load the weapon type
@     cmp     r4,#0x03                   @check if it's a physical weapon
@     ble     LoadSkillHolderCoords      @if it is, check our skill
@     b       End                        @otherwise branch to the end

@ LoadSkillHolderCoords:
@     ldrb    r0,[r5,#0x10]              @load the x coordinate of the unit
@     ldrb    r1,[r5,#0x11]              @load the y coordinate of the unit
@     b       LoadEnemyCoords            @branch to check the enemy's coordinates

@ LoadEnemyCoords:
@     ldrb    r2,[r7,#0x10]              @load the x coordinate of the unit
@     ldrb    r3,[r7,#0x11]              @load the y coordinate of the unit
@     b       CompareCoordinates         @branch to compare the coordinates

@ CompareCoordinates:
@     sub     r0,r2                      @subtract the skill holder's x coordinate to get the distance between them
@     sub     r1,r3                      @subtract the skill holder's y coordinate to get the distance between them
@     @get the absolute value of r0
@     asr     r4, r0, #31
@     add     r0, r0, r4
@     eor     r0, r4
@     @get the absolute value of r1
@     asr     r4, r1, #31
@     add     r1, r1, r4
@     eor     r1, r4
@     @continue
@     cmp     r0,#0x1                    @compare the distance of the x coordinate against our chosen x range
@     bgt     End                        @if the distance is greater, the enemy unit is outside the range of effect, so we branch to the end
@     cmp     r1,#0x1                    @compare the distance of the y coordinate against our chosen y range
@     bgt     End                        @if the distance is greater, the enemy unit is outside the range of effect, so we branch to the end
@     b       Counter                    @if the enemy unit is inside the range of effect, we branch to apply the counter skill to them

@ Counter:
@     pop     {r0-r4}                    @restore the original register values so we can access the enemy's attack value
@     mov     r0,r2                      @move the unit's HP into r0
@     strb    r0,[r7,#0x13]              @vanilla instruction 4 - store the new HP value
@     ldr     r3,=#0x8029454|1           @hardcode the return address as we're using jumpToHack
@     bx      r3                         @branch back to the vanilla function

@ End:
@     pop     {r0-r4}                    @restore the registers
@     sub     r0,r2,r1                   @vanilla instruction 3 - to subtract the enemy's attack from the unit's HP
@     strb    r0,[r7,#0x13]              @vanilla instruction 4 - store the new HP value
@     ldr     r3,=#0x8029454|1           @hardcode the return address as we're using jumpToHack
@     bx      r3                         @branch back to the vanilla function

