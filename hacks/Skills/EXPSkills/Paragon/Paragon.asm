.thumb

@called from 29F64
@r0=#0x0000011
@r1=#0x8029F65
@r2=#0x8BE0204
@r3=#0x0000000
@r4=#0x000000A
@r5=attacker battle struct(#0x203A3F0)
@r6=#0x203A470
@r7=#0202CEC0
@r8-r10= free
@r11=#0x3007DFC
@r12=#0x000001D
@r13=#0x3007DFC
@r14=#0x8029F01

add		r4,r4,r0 		    @add r4 and r0 to get the experience gained for the battle and store it in r4
ldr		r0,[r5,#0x0]	    @load pointer to character data
ldrb	r0,[r0,#0x4]	    @load character id byte
push    {r3}                @save the value of r3 to the stack, so we can use the register
mov     r3,r0               @copy over the battle struct to prevent overwriting it
ldr     r3,ParagonID        @load the ID value we have defined
cmp		r0,r3 			    @compare the loaded character ID byte to our chosen character's ID
beq		Paragon			    @if the current id matches Lyn's ID, then branch and apply Paragon
b 		End				    @otherwise, don't apply Paragon and branch to the end of the code

Paragon:
    lsl     r4,#1           @double the experience gained this battle
    cmp     r4,#0x64
    bge     CapExperience   @if experience exceeds 100, it needs to be capped to prevent overflow (and softlocks)
    b 		End

CapExperience:
    mov     r4,#0x64
    b       End

End:
    pop     {r3}            @restore the value of r3 that we pushed to the stack earlier
    ldr		r0,=0x8029F72|1	@load the return address
    bx		r0				@branch back to the vanilla code via the return address loaded in r0

.ltorg
.align
ParagonID:                  @refer to the value defined in the event file
