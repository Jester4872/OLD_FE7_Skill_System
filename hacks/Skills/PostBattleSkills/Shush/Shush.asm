.thumb

@called from 29C34
@r0=#0x0000004  current enemy HP
@r1=#0x203A470  defender struct
@r2=#0x820D500
@r3=#0x203E7C0
@r4=#0x202CEC0  character struct enemy position?
@r5=#0x203A470  defender struct
@r6=#0x202CEC0 
@r7=#0x202BD50  character struct
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000001
@r13=#0x3007D70
@r14=#0x8029AE3
@r15=#0x8029C34

.equ GetRandomNumber,   0x8000E04
.equ GetUnitStruct,     0x8018D0C 

.macro blh to, reg              @special macro opcode so we can use bx and return afterwards to our branch point via blh
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push    {r0-r7}                 @store the values of these registers on the stack so we can use them
b       CheckCharacter          @branch to check if the skill holder is currently in battle

CheckCharacter:
    ldr     r2,=#0x203A3F0      @load the attacker struct
    ldr     r2,[r2,#0x0]        @load the ROM location of this attacker's data
    ldrb    r2,[r2,#0x4]        @load their character ID byte
    mov     r3,r2               @copy over the battle struct to prevent overwriting it
    ldr     r3,ShushID          @load the ID value we have defined
    cmp     r3,r2               @compare against our chosen unit ID
    beq     CheckAllegiance     @if a match is found, branch to check their allegiance
    ldr     r2,=#0x203A470      @if not, load the defender struct and repeat the process
    ldr     r2,[r2,#0x0]        
    ldrb    r2,[r2,#0x4]        
    mov     r3,r2               
    ldr     r3,ShushID     
    cmp     r3,r2               
    beq     CheckAllegiance     
    b       End                 @if the skill holder is in neither struct, they aren't in battle and so we branch to the end

CheckAllegiance:
    ldrb	r2,[r1,#0xB]        @load the unit (defender/attacker) struct's allegiance byte
    cmp		r2,#0x40			@NPC phase byte for comparison
    ble		End    	            @if player unit, navigate to End
    cmp		r2,#0x80		    @enemy phase byte for comparison
    bge		Shush               @if enemy unit, navigate to the skill
    b       End                 @if it's the NPC turn

Shush:
    mov     r7,r1               @copy the skill holder's enemy battle struct location into a free register so it isn't overwritten
    mov     r5,#0x30            @Lower order nibble is status, higher order nibble is status duration (the first number is the higher-order nibble, and the second is the lower-order nibble)
    mov     r1,#0x3             @get the byte for silence
    mov     r3,#0x30            @get the status duration and set it to 3 turns            
    add     r6,r3,r1            @add the status duration and status effect together and store in r6 as r3 will be overwritten by GetUnitStruct
    ldrb    r0,[r7,#0xB]        @load the deployment ID byte of the enemy unit
    blh     GetUnitStruct, r3   @get the character struct for the enemy unit
    strb    r6,[r0,r5]          @store the status effect in the enemy's character struct status byte

End:
    pop     {r0-r7}
    strb    r0,[r4,#0x13]       @vanilla instruction 1 - store the new enemy current HP byte
    ldr     r0,[r5,#0xC]        @vanilla instruction 2 - load the state of the attacker/defender
    strb    r0,[r4,#0xC]        @vanilla instruction 3 - store the state of the enemy that's in r0
    ldr     r2,=#0x3002850      @vanilla instruction 4
    ldr     r3,=#0x8029C3C|1    @hardcode the return address as we're using jumpToHack
    bx      r3                  @branch back to the vanilla function

.ltorg
.align
ShushID:                        @refer to the value defined in the event file
