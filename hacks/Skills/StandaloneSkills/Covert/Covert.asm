.thumb

@called from 28C5C
@r0=#0x203A44E
@r1=#0x0000012  unit's base avoid (speed * 2)
@r2=#0x0000000
@r3=#0x202BBF8
@r4=#0x203A3F0  attacker struct
@r5=#0x203A470  defender struct
@r6=#0x0000000
@r7=#0x202BD50  character struct
@r8=#0x2022C60
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct
@r13=#0x3007CEC
@r14=#0x80289D5
@r15=#0x8028C5C

@2874C  @load terrain ID in attacker struct
@28ADC  @load terrain defense in attacker struct
@28C5C  @load terrain avoid in attacker struct

push    {r14}
sub     r0,#0x7             @remove 7 from the address loaded in r0 to get the terrain avoid address
ldrb    r0,[r0]             @load the value in the terrain avoid register
push    {r1-r3}
ldrb 	r1, [r4, #0xB]		@load deployment byte from attacker struct (player or enemy)
ldrb 	r2, [r5, #0xB]		@load deployment byte from defender struct (player or enemy)
mov 	r3, #0x80			@load enemy allegiance bit
and 	r1, r3				@trim the trailing bits of the allegiance value
and 	r2, r3				@trim the trailing bits of the allegiance value
cmp 	r1, #0x80			@is the attacker an enemy?
bne 	CheckCharacterAtk	@branch if false
cmp 	r2, #0x80			@is the defender an enemy?
bne 	CheckCharacterDef	@branch if false
b 		End

CheckCharacterAtk:
    mov     r1,r4
    ldr		r2,[r4,#0x0]	@load pointer to character data
    ldrb	r2,[r2,#0x4]	@load character ID byte
    cmp		r2,#0x0D 		@compare the loaded character ID byte to Lyn's ID
    beq		ApplyCovert	    @if the current ID matches Lyn's ID, then branch to apply Covert
    b 		End

CheckCharacterDef:
    mov     r1,r5
    ldr		r2,[r5,#0x0]	@load pointer to character data
    ldrb	r2,[r2,#0x4]	@load character ID byte
    cmp		r2,#0x0D 		@compare the loaded character ID byte to Lyn's ID
    beq		ApplyCovert	    @if the current ID matches Lyn's ID, then branch to apply Covert
    b 		End

ApplyCovert:
    lsl     r0,#1           @double avoid bonus of the tile the unit is standing on
    mov     r2,#0x56        @terrain defense byte
    ldrb    r3,[r1,r2]      @load the value of the terrain defense
    lsl     r3,#1           @double the terrain defense
    strb    r3,[r1,r2]      @store the doubled value
    b       End

End:
    pop     {r1-r3}         @restore the original values we pushed at the start
    lsl     r0,r0,#0x18     @weird opcodes that negate each other
    asr     r0,r0,#0x18
    add     r0,r0,r1        @add the terrain avoid together with the user's base avoid and store in r0
    mov     r1,#0x19
    pop     {r5}
    bx      r5
