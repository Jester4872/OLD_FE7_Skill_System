.thumb

@called from 28B54
@r0=#0x0000000
@r1=#0x203A3F0 attacker struct
@r2=#0x8C97EAC
@r3=#0x0000004
@r4=#0x203A470 defender struct
@r5=#0x203A3F0 attacker struct
@r6=#0x203A438 attacker struct weapon and uses
@r7=#0x202BD50 character struct
@r8=#0x000000B
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct
@r13=#0x3007CE8
@r14=#0x8028B3B
@r15=#0x8028B54

@One caveat of this skill is that it will also attempt to apply itself when looking at the stat screen
@ due to its hook point. I imagine this can be circumvented with a check on certain register values at
@ that time, but until someone complains about it, I'm leaving it as-is.

.equ GetRandomNumber, 0x08000E04

.macro blh to, reg              @special macro opcode so we can use bx and return afterwards to our branch point via blh
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push	{r4}                    @push this register to the stack so we can use it for a comparison check on who the skill should apply to
add		r1,#0x5A		        @vanilla instruction 1 - total might bit
mov		r0,#0x14		        @vanilla instruction 2 - get the strength bit
ldsb 	r0,[r5,r0] 		        @vanilla instruction 3 - load the strength value
ldrh    r2,[r1]       	        @vanilla instruction 4 - load battle struct attack
ldr     r3,[r5,#0x0]            @load the location of their character data in the ROM
ldrb	r3,[r3,#0x4]	        @load the character ID byte in the RAM
ldr     r4,ColossusID           @load the ID value we have defined
cmp     r3,r4                   @check if the user ID is what we want
beq 	ProcSkill               @brach to calculate if we should apply the skill
b 		End                     @otherwise we branch to the end

ProcSkill:
    push    {r0-r2}             @preserve the values of these registers on the stack as the GetRandomNumber function will override them
    blh     GetRandomNumber, r0 @get a random number between 0-100
    mov     r3,#0x15            @get the skill byte in the battle struct
    ldrb    r3,[r5,r3]          @load the value of the skill byte
    cmp     r0,r3               @check to see if the user's skill is equal to or exceeds the random number chosen
    bge     Colossus            @if it does, apply the skill
    pop     {r0-r2}             @otherwise, just restore the original values we pushed to the stack
    b       End                 @then branch to the end

Colossus:
    pop     {r0-r2}             @now restore the original values we pushed to the stack
    mov     r3,r0               @copy the attack value to r1
    lsl     r3,#1               @double this copied value
    add     r0,r3               @now add the doubled value back to the original (essentially tripling it) 
    b		End                 @now branch to the end

End:
    pop     {r4}                @restore the value of r4 we used for the unit ID check for the skill
    ldr     r3,=#0x8028B5C|1    @hardcode the return address as we're using jumpToHack 
    bx		r3			        @exit the subroutine and return to the address in r0

.ltorg
.align
ColossusID:                     @refer to the value defined in the event file
