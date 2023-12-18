.thumb
 
# called at 28D88
@r0=#0x0000000
@r1=#0x0000004
@r2=#0x203A454
@r3=#0x0000000
@r4=#0x203A3F0  attacker struct
@r5=#0x0000004
@r6=#0x203A470  defender struct
@r7=#0x203A470  defender struct
@r8=#0x202BD50  character struct - player
@r9=#0x202CEC0  character struct - enemy
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007D10
@r14=#0x8028A0F
@r15=#0x8028D88

push    {r0-r3}                 @preseve the values of these registers on the stack so we can use the registers later
ldr		r0,=#0x202BBF8	        @load chapter struct
mov		r1,#0xF			        @get turn phase byte
ldrb	r0,[r0,r1]		        @load turn phase
cmp		r0,#0x0			        @player phase byte for comparison
beq		CheckCharacterAtk    	@if player phase, navigate to CheckCharacterAtk
cmp		r0,#0x80		        @enemy phase byte for comparison
beq		CheckCharacterDef       @if enemy phase, load CheckCharacterDef

CheckCharacterAtk:
    ldr     r0,=#0x203A3F0      @load the attacker struct
    ldr     r2,[r0,#0x0]	    @load pointer to character data
    ldrb	r2,[r2,#0x4]	    @load character ID byte
    ldr     r3,LifeAndDeathID   @load the character ID value we have defined in the event file
    cmp     r3,r2               @compare our chosen ID against the current ID of the character we're looking at
    beq     LifeAndDeath        @if a match is found, apply LifeAndDeath
    b       End                 @otherwise branch to the end

CheckCharacterDef:
    ldr     r0,=#0x203A470      @load the defender struct
    ldr     r2,[r0,#0x0]	    @load pointer to character data
    ldrb	r2,[r2,#0x4]	    @load character ID byte
    ldr     r3,LifeAndDeathID   @load the character ID value we have defined in the event file
    cmp     r3,r2               @compare our chosen ID against the current ID of the character we're looking at
    beq     LifeAndDeath        @if a match is found, apply LifeAndDeath
    b       End                 @otherwise we branch to the end

LifeAndDeath:
    mov     r3,#0x5A            @get the attack byte
    ldr     r0,=#0x203A3F0      @load the attacker struct
    ldrh    r2,[r0,r3]          @load the value of the attack byte
    add     r2,#0x5             @add 10 to the attack of the attacker (this hack will run twice at this hookpoint)
    strh    r2,[r0,r3]          @store the new attack value  
    ldr     r0,=#0x203A470      @load the defender struct
    ldrh    r2,[r0,r3]          @load the value of the attacke byte
    add     r2,#0x5             @add 10 to the attack of the defender (this hack will run twice at this hookpoint)
    strh    r2,[r0,r3]          @store the new attack value
    b       End                 @branch to the end

End:
    pop     {r0-r3}             @restore the values of these registers that we pushed at the start
    mov     r7,r4               @vanilla instruction 1 - move the battle struct (at this pointer the attacker) from r4 to r7
    add     r7,#0x6A            @vanilla instruction 2 - get the battle crit location (crit - enemy avoid) and add it to the battle struct
    strh    r5,[r7]             @vanilla instruction 3 - store the battle crit in r5 in the battle crit location now in r7
    ldr     r2,=#0x202BBF8      @vanilla instruction 4 - load the chapter struct
    ldr     r3,=#0x8028D90|1    @hardcode the return address as we're using jumpToHack instead of callToHack
    bx      r3                  @branch back to the vanilla function

.ltorg
.align
LifeAndDeathID:                 @refer to the value defined in the event file
