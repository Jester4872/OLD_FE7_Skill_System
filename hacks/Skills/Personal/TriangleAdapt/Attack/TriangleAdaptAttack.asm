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

push    {r14}
push    {r4}
mov     r3,r1
ldrb    r1,[r1]                   @load weapon triangle strength bonus
sub     r3,#0x54                  @get struct of 1 of the 2 units in battle
b       CheckCharacter

CheckCharacter:
    ldr		r4,[r3,#0x0]	      @load pointer to character data
    ldrb	r4,[r4,#0x4]	      @load character ID byte
    cmp		r4,#0x03 		      @compare the loaded character ID byte to Lyn's ID
    beq		TriangleAdapt         @if the current ID matches Lyn's ID, then branch to TriangleAdapt
    b 		End

TriangleAdapt:
    lsl     r1,#1                 @double the triangle attack value

End:
    pop     {r4}
    pop     {r3}
    lsl     r1,r1,#0x18
    asr     r1,r1,#0x18
    add     r1,r1,r0
    mov     r0,r5
    add     r0,#0x5A
    bx      r3
