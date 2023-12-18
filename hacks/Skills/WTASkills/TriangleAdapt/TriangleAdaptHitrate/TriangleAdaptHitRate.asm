.thumb

@called from 28BC4
@r0=#0x000006D
@r1=#0x000000F  Weapon triangle hit rate value
@r2=#0x000006A
@r3=#0x0000039
@r4=#0x203A3F0  attacker struct
@r5=#0x203A470  defender struct
@r6=#0x202CEC0
@r7=#0x203A470  defender struct
@r8=#0x202BD50  character struct
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007D14
@r14=#0x8028BAD
@r15=#0x8028BC6

push    {r14}                     @preserve the return address on the stack
push    {r4}                      @preseve the value of r4 so we can use the register for a comparison
mov     r3,r1                     @move the value of the weapon triangle hit rate byte into r3
ldrb    r1,[r1]                   @load weapon triangle strength bonus
sub     r3,#0x53                  @get struct of 1 of the 2 units in battle
b       CheckCharacter            @branch to check the ID of the current unit

CheckCharacter:
    ldr		r4,[r3,#0x0]	      @load pointer to character data
    ldrb	r4,[r4,#0x4]	      @load character ID byte
    ldr     r3,TriangleAdaptID    @load the value we defined in the event file
    cmp     r4,r3                 @compare it against our chosen unit ID
    beq		TriangleAdapt         @if the current ID matches our chosen ID, then branch to TriangleAdapt
    b 		End                   @otherwise, branch to the end

TriangleAdapt:
    lsl     r1,#1                 @double the triangle hit rate value

End:
    pop     {r4}                  @restore the value of r4 we pushed to the stack
    pop     {r3}                  @restore the return address
    lsl     r1,r1,#0x18           @not sure what this does?
    asr     r1,r1,#0x18           @not sure what this does?
    add     r5,r1,r0              @add the base hit rate in r0 and the triangle adapt hit rate value together and store them in r5
    mov     r6,r4                 @copy the attacker struct in r4 into r6
    add     r6,#0x60              @get the hit rate byte in the battle struct
    bx      r3                    @branch back to the vanilla function

.ltorg
.align
TriangleAdaptID:                  @refer to the value defined in the event file

