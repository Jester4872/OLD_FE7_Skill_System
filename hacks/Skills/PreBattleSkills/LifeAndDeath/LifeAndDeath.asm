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
@r8=#0x202BD50  character struct
@r9=#0x202CEC0  character struct - enemy?
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007D10
@r14=#0x8028A0F
@r15=#0x8028D88

push    {r0-r3}
ldr		r0,=#0x202BBF8	        @load chapter struct
mov		r1,#0xF			        @get turn phase byte
ldrb	r0,[r0,r1]		        @load turn phase
cmp		r0,#0x0			        @player phase byte for comparison
beq		CheckCharacterAtk    	@if player phase, navigate to CheckCharacterAtk
cmp		r0,#0x80		        @enemy phase byte for comparison
beq		CheckCharacterDef       @if enemy phase, load CheckCharacterDef

CheckCharacterAtk:
    ldr     r0,=#0x203A3F0
    ldr     r2,[r0,#0x0]	@load pointer to character data
    ldrb	r2,[r2,#0x4]	@load character ID byte
    cmp		r2,#0x03 		@compare the loaded character ID byte to our chosen character ID
    beq     LifeAndDeath
    b       End

CheckCharacterDef:
    ldr     r0,=#0x203A470
    ldr     r2,[r0,#0x0]	@load pointer to character data
    ldrb	r2,[r2,#0x4]	@load character ID byte
    cmp		r2,#0x03 		@compare the loaded character ID byte to our chosen character ID
    beq     LifeAndDeath    
    b       End

LifeAndDeath:
    mov     r3,#0x5A        @get the attack byte
    ldr     r0,=#0x203A3F0  @load the attacker struct
    ldrh    r2,[r0,r3]      @load the value of the attack byte
    add     r2,#0x5         @add 10 to the attack of the attacker (this hack will run twice at this hookpoint)
    strh    r2,[r0,r3]      @store the new attack value  
    ldr     r0,=#0x203A470  @load the defender struct
    ldrh    r2,[r0,r3]      @load the value of the attacke byte
    add     r2,#0x5         @add 10 to the attack of the defender (this hack will run twice at this hookpoint)
    strh    r2,[r0,r3]      @store the new attack value
    b       End

End:
    pop     {r0-r3}
    mov     r7,r4           @vanilla instruction 1
    add     r7,#0x6A        @vanilla instruction 2
    strh    r5,[r7]         @vanilla instruction 3
    ldr     r2,=#0x202BBF8  @vanilla instruction 4
    ldr     r3,=#0x8028D90|1
    bx      r3
