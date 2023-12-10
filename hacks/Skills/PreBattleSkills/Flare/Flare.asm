.thumb
 
# called at 29294
@r0=#0x1000000
@r1=#0x8029279
@r2=#0x0000001
@r3=#0x000005C  battle forecast hit rate
@r4=#0x203A3D8  battle forecast data start location (attack?)
@r5=#0x0000000
@r6=#0x203A3F0  attacker struct
@r7=#0x0000004  attack of attacker?
@r8=#0x203A470  defender struct
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007CE4
@r14=#0x8029279
@r15=#0x8029294

@Ignore the defense of an enemy on player phase (not using the random number yet)

.equ GetRandomNumber, 0x08000E04

.macro blh to, reg          @special macro opcode so we can use bx and return afterwards to our branch point via blh
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push    {r14}
ldrh    r1,[r4,#0x6]        @vanilla instruction 1 - loads the attack short of the attacker struct
ldrh    r2,[r4,#0x8]        @vanilla instruction 2 - loads the defense short of the defender struct
b       CheckCharacter

CheckCharacter:
    push    {r0-r5}
    mov     r3,r2
    ldr     r0,=#0x203A3F0
    ldr     r2,[r0,#0x0]	@load pointer to character data
    ldrb	r2,[r2,#0x4]	@load character ID byte
    cmp		r2,#0x03 		@compare the loaded character ID byte to Lyn's ID
    beq     CheckBitFlag    @branch to ignore defense if it is Lyn
    b       SubtractDefense @otherwise we perform the normal operation and subtract defense

CheckBitFlag:
    mov     r4,#0xFF
    mov     r5,#0x40
    ldr     r4,[r0,r5]
    cmp     r4,#0xFF
    bne     IgnoreDefense
    ldr     r4,=#0x203A3D8
    strh    r1,[r4,#0x4]    @vanilla instruction 4 - store the damage value (attack - defense) of the forecast
    pop     {r0-r5}
    b       End

IgnoreDefense:
    mov     r2,#0x5A        @get the attack byte for the forecast data
    ldrh    r1,[r0,r2]      @load the attack byte for the forecast data
    add     r1,r1,r3        @add on the defense byte to negate its prior removal
    strh    r1,[r0,r2]      @store the attack byte for the forecast data
    b       SetBitFlag

SetBitFlag:
    mov     r4,#0xFF
    mov     r5,#0x40
    strb    r4,[r0,r5]
    pop     {r0-r5}         @restore the original values we popped earlier
    strh    r1,[r4,#0x4]    @vanilla instruction 4 - store the damage value (attack - defense) of the forecast
    b       End

SubtractDefense:
    pop     {r0-r5}
    sub     r0,r1,r2        @vanilla instruction 3 - subtract the defender's defense from the attacker's attack and store the result in r0
    strh    r0,[r4,#0x4]    @vanilla instruction 4 - store the damage value (attack - defense) of the forecast
    b       End

End:
    ldrh    r0,[r4,#0xC]    @vanilla instruction 5  - loads the battle forecast crit for the attacker
    mov     r1,#0x0         @vanilla instruction 6   
    pop     {r5}            @pop the return address
    bx      r5

