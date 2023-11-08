.thumb

@called from 28A78
@r0=#0x2000018
@r1=#0x203A456  attacker struct crit location
@r2=#0x0000000
@r3=#0x0000017  loaded crit
@r4=#0x3007CE8
@r5=#0x203A3F0  attacker struct
@r6=#0x0000000
@r7=#0x202BD50  character struct
@r8=#0x2022C60
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x202A470 defender struct
@r13=#0x3007CE8
@r14=#0x8026A39
@r15=#0x8028A78

push    {r14}
ldrh    r3,[r1]
add     r0,r3,r2
b       CheckCharacterID

CheckCharacterID:
    push    {r1-r4}
    sub     r1,#0x66        @remove the offset so we can get the start of the struct
    ldr     r2,[r1]
    ldrb    r2,[r2,#0x4]
    cmp     r2,#0x3
    beq     CheckFlag
    b       End

CheckFlag:
    mov     r3,#0x1C
    ldrb    r4,[r1,r3]
    cmp     r4,#0xFF
    beq     End
    b       ApplyFlag

ApplyFlag:
    ldrb    r4,[r1,r3]
    mov     r4,#0xFF
    strb    r4,[r1,r3]
    b       ApplyKillingMachine

ApplyKillingMachine:
    lsl     r0,#1
    b       End

End:
    pop     {r1-r4}
    strh    r0,[r1]
    add     r1,#0x2
    ldrh    r3,[r1]
    ldrb    r4,[r4,#0x6]
    add     r0,r3,r4
    pop     {r1}
    bx      r1
