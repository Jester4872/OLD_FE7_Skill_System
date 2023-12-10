.thumb

@called from 18B5C
@r0=#0x0000000
@r1=#0x0000000
@r2=#0x0002E01  equipped weapon and uses before battle
@r3=#0x8BE222C
@r4=#0x3007DF8
@r5=#0x203A3F0  attacker struct
@r6=#0x3007D08
@r7=#0x202BDE0  character struct
@r8=#0x2022C60
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470
@r13=#0x3007CF0
@r14=#0x8018B5B
@r15=#0x8018B5C

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
    mov     r0,#0x16            @get the speed bit
    ldsb    r0,[r4,r0]          @load the speed value
    lsr     r2,r0,#0x1F
    ldr     r2,[r5,#0x0]		@load pointer to character data
    ldrb	r2,[r2,#0x4]		@load character ID byte
    cmp		r2,#0x17 			@compare the loaded character ID byte to the chosen ID
    beq     ApplySpeedBoost
    b       End

ApplySpeedBoost:
    add     r1,#1               @add 1 to the boost
    b       End

End:
    add     r0,r0,r2
    pop     {r2,r5}
    ldr     r3,=#0x8018B64|1
    bx      r3
