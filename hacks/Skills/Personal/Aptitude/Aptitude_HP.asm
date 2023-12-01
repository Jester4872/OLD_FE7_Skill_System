.thumb

@called from 296B8

@r0=#0x0000000
@r1=#0x0000000
@r2=#0x0000007
@r3=#0x0000000
@r4=#0x203A470  defender struct
@r5=#0x0000000
@r6=#0x0000000
@r7=#0x203A3F0  attacker struct 
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x000001D
@r13=#0x3007D30
@r14=#0x8029673
@r15=#0x80296B8

ldr     r0,[r7]             @load the character's unit data in the ROM
ldrb    r0,[r0,#0x1C]       @load their HP growth byte
b       CheckCharacter

CheckCharacter:
    ldr     r2,[r4,#0x0]    @load the character's unit data from RAM
    
    ldrb    r2,[r2,#0x4]    @load their character ID byte
    cmp     r2,#0x03        @check if it matches our chosen character ID
    beq     Aptitude_HP     @branch and apply the growth boost if so
    ldr     r2,[r7,#0x0]    @otherwise check the other battle struct for the same data
    ldrb    r2,[r2,#0x4]
    cmp     r2,#0x03
    beq     Aptitude_HP
    b       End             @if the character we need is in neither, branch to the end

Aptitude_HP:
    mov     r2,#0x96        @150% in hex
    add     r0,r2           @add my boost to the HP getter
    b       End

End:
    add     r0,#0x10        @vanilla opcode
    ldr     r2,=#0x80295E0|1@hardcoded return address
    bx      r2              @branch back to the vanilla function


@use jumpToHack for all
@296B8  HP Growth
@296C8  Attack Growth
@296E8  Skill Growth
@29700  Speed Growth
@2971A  Defense Growth
@29732  Resistance Growth
@29748  Luck Growth
