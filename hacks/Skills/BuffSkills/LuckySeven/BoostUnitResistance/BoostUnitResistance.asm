.thumb

@called from 18BA4
@r0=#0x0000000
@r1=#0x8BE2250
@r2=#0x0000001
@r3=#0x8BE222C
@r4=#0x202BD50  character struct
@r5=#0x203A3F0  attacker struct
@r6=#0x202BD50
@r7=#0x202BD50
@r8=#0x000000B
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470
@r13=#0x3007CEC
@r14=#0x8018BA1
@r15=#0x8018BA0

@runs twice.
@The first time updates the battle stats screen
@the second time updates the base stats screen

push    {r14}                   @push the link register so we can return at the end
push    {r0,r1}                 @push these registers, as we'll be using them for the phase check
ldr		r0,=#0x202BBF8	        @load chapter struct
mov		r1,#0xF			        @get turn phase byte
ldrb	r0,[r0,r1]		        @load turn phase
cmp		r0,#0x0			        @player phase byte for comparison
beq		PlayerPhase 	        @if player phase, navigate to PlayerPhase
cmp		r0,#0x80		        @enemy phase byte for comparison
beq		EnemyPhase  	        @if enemy phase, load EnemyPhase

PlayerPhase:
    pop     {r0,r1}             @restore the values of r0,r1 that we pushed
    push    {r2,r5}             @push r2 and r5, as we'll be using them for the character ID check
    ldr     r5,=#0x203A3F0      @load the attacker struct to get the player unit
    b       CheckCharacter

EnemyPhase:
    pop     {r0,r1}             @restore the values of r0,r1 that we pushed
    push    {r2,r5}             @push r2 and r5, as we'll be using them for the character ID check
    ldr     r5,=#0x203A470      @load the defender struct to get the player unit
    b       CheckCharacter

CheckCharacter:
    ldsb    r0,[r4,r0]          @vanilla instruction 1 - load the resistance value
    ldr     r2,[r5,#0x0]		@load pointer to character data
    ldrb	r2,[r2,#0x4]		@load character ID byte
    mov     r3,r2               @copy over the battle struct to prevent overwriting it
    ldr     r3,BoostUnitResistanceID   @load the ID value we have defined
    cmp		r2,r3 			    @compare the loaded character ID byte to our chosen character's ID
    beq     CheckBitFlag
    b       End

CheckBitFlag:
    ldrb    r2,[r5,#0x1C]       @load the value stored in the ballista data we're using for the LuckySeven bitflag
    cmp     r2,#0x6             @compare it to the value we're using to represent the resistance stat
    beq     BoostResistance     @if there's match then branch to boost the unit's resistance
    b       End                 @else branch to the end

BoostResistance:
    add     r1,#7               @add 7 to the resistance boost
    b       End

End:
    add     r0,r0,r1            @vanilla instruction 2 - add the resistance and boost together for the final total
    add     r4,#0x31            @vanilla instruction 3
    ldrb    r4,[r4]             @vanilla instruction 4
    lsr     r1,r4,#0x4          @vanilla instruction 5
    add     r0,r0,r1            @vanilla instruction 6
    pop     {r2,r5}
    pop     {r3}
    bx      r3

    .ltorg
.align
BoostUnitResistanceID:          @refer to the value defined in the event file
