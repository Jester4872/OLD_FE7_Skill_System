.thumb

@called from 1742C
@r0=#0x0000046
@r1=#0x0000276
@r2=#0x0000000
@r3=#0x0000004
@r4=#0x203A3F0  attacker struct
@r5=#0x203A438  attacker struct - equipped item and uses after battle
@r6=#0x0000000
@r7=#0x202BDE0  character struct of player
@r8=#0x20252FD
@r9=#0x202BDE0  character struct of player
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct
@r13=#0x3007D14
@r14=#0x8028561
@r15=#0x801742C

lsl		r1,r1,#0x2              @vanilla instruction
ldr     r0,=#0x8BE222C          @vanilla instruction
add		r1,r1,r0                @vanilla instruction
push    {r1-r3,r6}              @preserve the value of r2 so we can use this register for character ID checks
mov     r6,r0                   @copy the base item struct into another register
ldrb    r0,[r1,#0x1F]           @vanilla instruction - load the ability byte of the equipped weapon
b       CheckAttacker

CheckAttacker:
    ldr     r3,=#0x203A3F0      @load the attacker struct
    ldr		r2,[r3,#0x0]	    @load pointer to character data
    ldrb	r2,[r2,#0x4]	    @load character id byte
    cmp		r2,#0x03 		    @compare the loaded character ID byte to our chosen character ID
    beq     CheckItem           @if a match is found, then branch and apply Lifetaker
    b       CheckDefender

CheckDefender:
    ldr     r3,=#0x203A470      @otherwise, load the defender struct
    ldr		r2,[r3,#0x0]	    @load pointer to character data
    ldrb	r2,[r2,#0x4]	    @load character ID byte
    cmp		r2,#0x03 		    @compare the loaded character ID byte to our chosen character ID
    beq		CheckItem		    @if a match is found, then branch and apply Lifetaker
    b 		End				    @otherwise, branch to the end of the code

CheckItem:
    push    {r4,r5}
    mov     r4,r1               @copy the item struct with the address of the unit's equipped weapon to a new register for later comparison
    mov     r5,r6               @copy the base item struct to a new register
    ldrb    r3,[r3,#0x1E]       @load the item ID of the units first equipped item
    mov     r2,#0x24            @move the struct length of a single item into a register
    mul     r2,r3               @multiply the struct length by the item ID we found
    add     r5,r2               @add the base struct and struct lengths together
    cmp     r4,r5               @compare modified item struct in r5 against the item struct that was produced at the start
    beq     Lifetaker           @if they're the same, we know we're looking at the unit we should apply Lifetaker to
    pop     {r4,r5}             @else we restore the structs we pushed initially
    b       End                 @and then branch to the end

Lifetaker:
    pop     {r4,r5}
    mov		r0,#0x02	        @load the byte into r0 that controls the nosferatu effect
    b 		End

End:
    pop		{r1-r3,r6}          @restore the value that was in r2 originally
    ldr		r3,=#0x8017434|1	@load the return address
    bx		r3                  @branch back to the vanilla function
