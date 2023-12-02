.thumb

@called from 29714
@r0=#0x0000003
@r1=#0x8029709
@r2=#0x000001A
@r3=#0x203A4E6
@r4=#0x203A470  defender struct
@r5=#0x0000000
@r6=#0x0000007
@r7=#0x203A3F0  attacker struct 
@r8=#0x203A4E5
@r9=#0x203A4E6
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000023
@r13=#0x3007CF0
@r14=#0x8000E0D
@r15=#0x8029714

add     r6,r6,r0
ldr     r0,[r7]                 @load the character's unit data in the ROM
add     r0,#0x20                @add the defense byte to the 
ldrb    r0,[r0]                 @load their Defense growth byte
b       CheckCharacter

CheckCharacter:
    ldr     r2,[r4,#0x0]        @load the character's unit data from RAM
    ldrb    r2,[r2,#0x4]        @load their character ID byte
    cmp     r2,#0x03            @check if it matches our chosen character ID
    beq     Aptitude_Defense    @branch and apply the growth boost if so
    ldr     r2,[r7,#0x0]        @otherwise check the other battle struct for the same data
    ldrb    r2,[r2,#0x4]
    cmp     r2,#0x03
    beq     Aptitude_Defense
    b       End                 @if the character we need is in neither, branch to the end

Aptitude_Defense:
    mov     r2,#0x14            @20% growth rate boost
    add     r0,r2               @add my boost to the Defense growth getter
    b       End

End:
    ldr     r2,=#0x8029722|1    @hardcode the link register back to its original value as it's needed in GetStatIncrease and it's been overwritten with this hack
    mov     r14,r2
    ldr     r2,=#0x80295E0|1    @hardcoded return address
    bx      r2                  @branch back to the vanilla function
