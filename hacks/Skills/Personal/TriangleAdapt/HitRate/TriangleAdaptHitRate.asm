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

@28B24 load triangle strength
@28BC4 load triangle damage

push    {r14}
push    {r4}
mov     r3,r1
ldrb    r1,[r1]                   @load weapon triangle strength bonus
sub     r3,#0x53                  @get struct of 1 of the 2 units in battle
b       CheckCharacter

CheckCharacter:
    ldr		r4,[r3,#0x0]	      @load pointer to character data
    ldrb	r4,[r4,#0x4]	      @load character ID byte
    cmp		r4,#0x03 		      @compare the loaded character ID byte to Lyn's ID
    beq		TriangleAdapt         @if the current ID matches Lyn's ID, then branch to TriangleAdapt
    b 		End

TriangleAdapt:
    lsl     r1,#1                 @double the triangle hit rate value

End:
    pop     {r4}
    pop     {r3}
    lsl     r1,r1,#0x18
    asr     r1,r1,#0x18
    add     r5,r1,r0
    mov     r6,r4
    add     r6,#0x60
    bx      r3
