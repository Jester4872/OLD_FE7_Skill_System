.thumb

@called from 28AE8
@r0=#0x0000000
@r1=#0x0000017
@r2=#0x203A438 attacker struct - equipped item and uses after battle
@r3=#0x2022C60
@r4=#0x203A3F0 attacker struct
@r5=#0x203A4B8 
@r6=#0x0000000
@r7=#0x202BD50 character struct
@r8=#0x2022C60
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct
@r13=#0x3007CF0
@r14=#0x8028AC5
@r15=#0x8028AE8

push    {r0}                    @preserve the value of this register on the stack so we can use the register itself later
ldsb    r1,[r4,r1]              @vanilla instruction 1 - load the unit's defense short
ldr     r0,=#0x203A3F0          @load the attacker struct as we want to check if the skill user is the one initiating battle
cmp     r0,r4                   @compare it against the struct that's loaded in r4
bne     End                     @if they're not the same, we know the attacker isn't the skill user, so we branch to the end
ldr     r0,[r4,#0x0]            @otherwise, load the location of their character data in the ROM
ldrb	r0,[r0,#0x4]	        @load the unit's character ID byte
ldr     r3,ArmoredBlowID        @load the ID value we have defined
cmp     r0,r3                   @check if the unit in r0 is the unit we want	
beq 	ArmoredBlow             @apply the skill if it is
b 		End                     @otherwise we branch to the end

ArmoredBlow:
    add		r1,#6		        @add +6 to the unit's defense
    b		End                 @now we branch to the end

End:
    pop 	{r0}		        @restore the value of r0 we pushed onto the stack at the start
    add     r0,r0,r1            @vanilla instruction 2
    mov     r1,r4               @vanilla instruction 3
    add     r1,#0x5C            @vanilla instruction 4
    ldr     r3,=#0x8028AF0|1    @hardcode the return address as we're using jumpToHack instead of callToHack
    bx		r3			        @exit the subroutine and return to the address in r0

.ltorg
.align
ArmoredBlowID:                  @refer to the value defined in the event file
