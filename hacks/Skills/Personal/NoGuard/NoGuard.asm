.thumb
 
# called at 28D78
@r1=#0x203A470  defender struct
@r2=#0x203A3F0  attacker struct
@r3=#0x203A4D4  defender battle hit (hit - enemy avoid)
@r4=#0x203A470  defender struct
@r5=#0x203A3F0  attacker struct
@r6=#0x202CEC0
@r7=#0x203A470  defender struct
@r8=#0x202BD50  character struct
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007D10
@r14=#0x8028A0F
@r15=#0x8028D76

push    {r14}
push    {r0-r2}
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
    cmp		r2,#0x1D 		@compare the loaded character ID byte to Lyn's ID
    beq     ApplyNoGuard
    b       End

CheckCharacterDef:
    ldr     r0,=#0x203A470
    ldr     r2,[r0,#0x0]	@load pointer to character data
    ldrb	r2,[r2,#0x4]	@load character ID byte
    cmp		r2,#0x1D 		@compare the loaded character ID byte to Lyn's ID
    beq     ApplyNoGuard    
    b       End

ApplyNoGuard:
    ldr     r0,=#0x203A3F0  @load the attacker struct
    mov     r1,#0x64        @battle hit of the attacker struct
    ldrh    r2,[r0,r1]      @load the value of the battle hit
    mov     r2,#0x64        @set the battle hit to 100%
    strh    r2,[r0,r1]      @store the new battle hit    
    ldr     r0,=#0x203A470  @load the defender struct
    ldrh    r2,[r0,r1]      @load the value of the battle hit
    mov     r2,#0x64        @set the battle hit to 100%
    strh    r2,[r0,r1]      @store the new battle hit
    b       End

End:
    pop     {r0-r2}
    mov     r6,r1           @vanilla instruction 1
    mov     r1,r4           @vanilla instruction 2
    add     r1,#0x66        @vanilla instruction 3
    mov     r0,r6           @vanilla instruction 4
    add     r0,#0x68        @vanilla instruction 5
    ldrh    r1,[r1]         @vanilla instruction 6
    pop     {r3}
    bx      r3
