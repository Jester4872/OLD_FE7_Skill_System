.thumb

@called from 29C34
@r0=#0x0000004  current enemy HP
@r1=#0x203A470  defender struct
@r2=#0x820D500
@r3=#0x203E7C0
@r4=#0x202CEC0  character struct enemy position?
@r5=#0x203A470  defender struct
@r6=#0x202CEC0 
@r7=#0x202BD50  character struct
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000001
@r13=#0x3007D70
@r14=#0x8029AE3
@r15=#0x8029C34

push    {r14}
push    {r2}
b       CheckCharacter

CheckCharacter:
    ldr     r2,=#0x203A3F0
    ldr     r2,[r2,#0x0]
    ldrb    r2,[r2,#0x4]
    cmp     r2,#0x3
    beq     CheckAllegiance
    ldr     r2,=#0x203A470
    ldr     r2,[r2,#0x0]
    ldrb    r2,[r2,#0x4]
    cmp     r2,#0x3
    beq     CheckAllegiance
    b       End

CheckAllegiance:
    ldrb	r2,[r1,#0xB]        @load the unit (defender/attacker) struct's allegiance byte
    cmp		r2,#0x40			@NPC phase byte for comparison
    ble		End    	            @if player unit, navigate to End
    cmp		r2,#0x80		    @enemy phase byte for comparison
    bge		GrisleyWound        @if enemy unit, navigate to GrisleyWound
    b       End                 @if it's the NPC turn

GrisleyWound:
    mov     r2,#0x12            @max HP byte
    ldrb    r2,[r1,r2]          @load the value of the max HP byte
    cmp     r0,#0x0             @if the character's HP is already 0 no further calculations are necessary
    beq     End                 @and so we branch to the end
    push    {r0,r1}             @preserve the values of r0 and r1 on the stack
    mov     r0,r2               @otherwise, copy the max HP byte value into r0 (numerator)
    mov     r1,#0x5             @copy 5 into r1 (denominator)
    swi     0x06                @call software interupt 6 to enable division (r0/r1) and store the result in r0
    mov     r2,r0               @copy the result into r2 so we can restore the earlier registers
    pop     {r0,r1}             @restore registers r0 and r1
    cmp     r2,r0               @check to see if the additional damage would cause an underflow
    bge     EqualizeAdditionalDamage
    sub     r0,r2               @subtract the divisor value (20% of max HP) from the enemy's remaining HP
    b       End

EqualizeAdditionalDamage:
    mov     r0,#1               @make the current HP equal 1 (if we set it to 0 we lose out on kill bonus XP)
    b       End

End:
    pop     {r2}
    pop     {r3}
    strb    r0,[r4,#0x13]       @store the new enemy current HP byte
    ldr     r0,[r5,#0xC]        @load the state of the attacker/defender
    strb    r0,[r4,#0xC]        @store the state of the enemy that's in r0
    ldr     r2,=#0x3002850
    lsr     r0,r0,#0x11
    mov     r1,#0x7
    bx      r3
