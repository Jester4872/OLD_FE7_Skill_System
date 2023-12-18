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

push	{r14}               @preserve the value of the return address onto the stack, as it will change over the course of this hack
ldr		r2,[r1,#0x0]	    @load pointer to character data
ldrb	r2,[r2,#0x4]	    @load character id byte
ldr     r3,MomentumID       @load the character ID value we have defined in the event file
cmp     r3,r2               @compare our chosen ID against the current ID of the character we're looking at
beq		Momentum		    @if the current id matches Lyn's ID, then branch and apply Momentum
b       StoreMight          @otherwise, we branch to apply the vanilla instructions

Momentum:
    add		r1,#0x5A        @vanilla instruction 1 - total might bit
    mov		r0,#0x14        @vanilla instruction 2 - strength bit
    ldsb 	r0,[r5,r0] 		@vanilla instruction 3 - strength
    ldrh    r2,[r1]       	@vanilla instruction 4 - load weapon might
    add 	r0,r2 			@vanilla instruction 5 - add weapon might (stored in r2) to value used to calculate strength (stored in r0)
    ldr		r3,=#0x203A85C  @load the action struct
    ldrb	r3,[r3,#0x10]	@load the number of spaces moved this turn by this unit
    add		r0,r3			@add the number of spaces moved to the final attack total
    b		End

StoreMight:
    add		r1,#0x5A        @vanilla instruction 1 - total might bit
    mov		r0,#0x14        @vanilla instruction 2 - strength bit
    ldsb 	r0,[r5,r0] 		@vanilla instruction 3 - strength
    ldrh    r2,[r1]       	@vanilla instruction 4 - load weapon might
    add 	r0,r2 			@vanilla instruction 5 - add weapon might (stored in r2) to value used to calculate strength (stored in r0)
    b       End             @branch to the end

End:
    strh	r0,[r1] 		@vanilla instruction 6 - transfer and store the total might from r0 to r1
    pop 	{r0}			@pop the return address stored in r14 into r0
    bx		r0				@exit the subroutine and return to the address in r0

.ltorg
.align
MomentumID:                 @refer to the value defined in the event file
