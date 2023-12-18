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

@Todo - Right now it only applies on each side's attacking phase
@it must apply to both sides, perhaps do a turn phase check to set everything up?

push	{r14}
b     CheckCharacter


@Check the character ID of the attacker
CheckCharacter:
    ldr	    r0,[r1,#0x0]	    @load ROM location of character data
    ldrb    r0,[r0,#0x4]        @load character ID byte 
    ldr     r3,FrenzyID         @load the value we defined in the event file
    cmp     r3,r0               @compare it against our chosen unit ID
    beq     Frenzy              @branch to load the unit's defense, if we find a match
    b       StoreMight          @otherwise, we branch to apply the vanilla operations

Frenzy:
    add		r1,#0x5A		    @vanilla instruction 1 - total might bit
    mov		r0,#0x14		    @vanilla instruction 2 - strength bit
    ldsb 	r0,[r5,r0] 		    @vanilla instruction 3 - strength
    ldrh    r2,[r1]       	    @vanilla instruction 4 - load weapon might
    add 	r0,r2 			    @vanilla instruction 5 - add weapon might (stored in r2) to value used to calculate strength (stored in r0)
    push    {r1,r2}             @preserve the values of r1 and r2 by pushing them onto the stack so we can use these registers
    mov     r1, #0x12           @max hp byte
    mov     r2, #0x13           @current hp byte
    ldrb    r1,[r1,r5]          @load value of max hp
    ldrb    r2,[r2,r5]          @load value of current hp
    sub     r1,r1,r2            @calculate the difference between the max hp and current hp
    asr     r1,#2               @divide the result by 4
    add     r0,r1               @add it onto the final attack value
    pop     {r1,r2}             @restore the values we pushed earlier
    strh	r0,[r1] 		    @vanilla instruction 6 - transfer and store the total might from r0 to r1
    b       End                 @now we branch to the end

StoreMight:
    add		r1,#0x5A		    @vanilla instruction 1 - total might bit
    mov		r0,#0x14		    @vanilla instruction 2 - strength bit
    ldsb 	r0,[r5,r0] 		    @vanilla instruction 3 - strength
    ldrh    r2,[r1]       	    @vanilla instruction 4 - load weapon might
    add 	r0,r2 			    @vanilla instruction 5 - add weapon might (stored in r2) to value used to calculate strength (stored in r0)
    strh	r0,[r1] 		    @vanilla instruction 6 - transfer and store the total might from r0 to r1
    b       End                 @now we branch to the end

End:
    pop 	{r0}			    @pop the return address stored in r14 into r0
    bx		r0				    @exit the subroutine and return to the address in r0

.ltorg
.align
FrenzyID:                       @refer to the value defined in the event file





