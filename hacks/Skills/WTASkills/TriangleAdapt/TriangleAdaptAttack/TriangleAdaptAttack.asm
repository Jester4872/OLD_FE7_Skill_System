.thumb

@called from 28B24
@r0=#0x0000005
@r1=#x203A4444  attacker struct - weapon triangle damage byte
@r2=#0x203A438  
@r3=#0x0000001
@r4=#0x203A470  defender struct
@r5=#0x203A3F0  attacker struct
@r6=#0x203A438  attacker struct - equipped weapon and uses after battle
@r7=#0x203A470  defender struct
@r8=#0x202BD50  character struct
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007D14
@r14=#0x8028B21
@r15=#0x8028B24

@28B24 load triangle strength
@28BC4 load triangle hit

push    {r14}                     @preserve the return address on the stack
push    {r4}                      @preseve the value of r4 so we can use the register for a comparison
mov     r3,r1                     @move the value of the weapon triangle damage byte into r3
ldrb    r1,[r1]                   @load weapon triangle strength bonus
sub     r3,#0x54                  @get struct of 1 of the 2 units in battle
b       CheckCharacter            @branch to check the character ID

CheckCharacter:
    ldr		r4,[r3,#0x0]	      @load pointer to character data
    ldrb	r4,[r4,#0x4]	      @load character ID byte
    ldr     r3,TriangleAdaptID    @load the value we defined in the event file
    cmp     r3,r2                 @compare it against our chosen unit ID
    beq		TriangleAdapt         @if the current ID matches Lyn's ID, then branch to TriangleAdapt
    b 		End                   @branch to the end

TriangleAdapt:
    lsl     r1,#1                 @double the triangle attack value

End:
    pop     {r4}                  @restore the value of r4 we pushed to the stack
    pop     {r3}                  @restore the return address
    lsl     r1,r1,#0x18           @not sure what this does?
    asr     r1,r1,#0x18           @not sure what this does?
    add     r1,r1,r0              @add unit's attack (in r0) to their triangle damage bonus in r1
    mov     r0,r5                 @copy the attacker strict in r5 into r0
    add     r0,#0x5A              @get the battle struct attack short and load it into r0
    bx      r3                    @branch back to the vanilla function

.ltorg
.align
TriangleAdaptID:                  @refer to the value defined in the event file
