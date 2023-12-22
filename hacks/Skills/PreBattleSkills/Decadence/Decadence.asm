.thumb

@called from 293A0
@r0=#0x203A470  defender struct
@r1=#0x203A3F0  attacker struct
@r2=#0x0000004
@r3=#0x0000000
@r4=#0x203A470
@r5=#0x203A470
@r6=#0x203A470  
@r7=#0x0000008
@r8=#0x203A3F0
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007CE0
@r14=#0x802950F

@this skill is a bit of a mess as I wasn't able to find where the final damage total is generated.
@you'd think it'd be some sub opcode with one unit's attack and the other unit's defense but no such luck.
@so I've resorted to some mental gymnastic math where I add the other unit's defense onto the first
@unit's attack twice under two sets of circumstances. Not ideal, but it works, so fuck it ¯\_(ツ)_/¯.

push    {r1-r5}                 @push the values of these registers to the stack so we can use the registers themselves
mov     r5,r1                   @copy the struct of the other unit to r5 so we can load their defense value            
b       CheckCharacter          @branch to check our current unit

CheckCharacter:                 
    ldr     r2,[r0,#0x0]        @load the ROM address of the current character
    ldrb    r2,[r2,#0x4]        @load the character ID byte
    ldr     r1,DecadenceID      @load the ID value we have defined
    cmp     r1,r2               @compare against our chosen unit ID
    beq     CheckAllegiance     @if a match if found, branch to check their allegiance
    b       End                 @else branch to the end

CheckAllegiance:
    ldrb    r2,[r0,#0xB]        @load the allegiance byte of the character struct loaded in r0
    cmp		r2,#0x40			@NPC phase byte for comparison
    ble		Decadence    	    @if player unit, apply the skil
    b       End                 @otherwise branch to the end

Decadence:
    mov     r3,#0x5A            @get the unit's attack byte in the battle struct
    ldrb    r2,[r0,r3]          @load the value of that byte
    mov     r4,#0x5C            @get the other unit's defense byte in the battle struct
    ldrb    r1,[r5,r4]          @load the value of that byte
    add     r2,r1               @add the other unit's defense to our unit to negate later subtraction
    cmp     r2,#0xA             @check the attack value against our chosen limit
    bne     SetAttack           @if it's not equal, then we branch to set the attack value to our limit
    strb    r2,[r0,r3]          @otherwise, store the new attack value of the chosen unit
    b       End                 @now we branch to the end

SetAttack:
    mov     r2,#0xA             @set the attack value to our chosen value
    add     r2,r1               @add the other unit's defense to our unit to negate later subtraction
    strb    r2,[r0,r3]          @store the new attack value of the chosen unit
    b       End                 @now we branch to the end

End:
    pop     {r1-r5}             @restore the register values from before
    mov     r7,r1               @vanilla instruction 1 - copy the attacker struct from r1 to r7
    mov     r1,r5               @vanilla instruction 2 - copy the defender struct from r5 to r1
    add     r1,#0x7B            @vanilla instruction 3 - add the byte (#0x7B) for the weapon XP multiplier to the attacker struct in r1
    ldrb    r0,[r1]             @vanilla instruction 4 - load that weapon XP value
    ldr     r3,=#0x80293A8|1    @hardcode the return address as we're using jumpToHack instead of callToHack
    bx      r3                  @branch back to the vanilla function

.ltorg
.align
DecadenceID:                    @refer to the value defined in the event file
