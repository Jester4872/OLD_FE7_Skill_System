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

ldr     r0,[r7]                 @load the character's unit data in the ROM
ldrb    r0,[r0,#0x1C]           @load their HP growth byte
b       CheckCharacter

CheckCharacter:
    push    {r3}                @save the value of r3 to the register so we can use it to load the skill ID
    ldr     r2,[r4,#0x0]        @load the character's unit data from RAM
    ldrb    r2,[r2,#0x4]        @load their character ID byte
    mov     r3,r2               @copy over the battle struct to prevent overwriting it
    ldr     r3,Apptitude_HPID   @load the ID value we have defined
    cmp		r2,r3 			    @compare the loaded character ID byte to our chosen character's ID
    beq     Aptitude_HP         @branch and apply the growth boost if so
    ldr     r2,[r7,#0x0]        @otherwise check the other battle struct for the same data
    ldrb    r2,[r2,#0x4]
    mov     r3,r2               @copy over the battle struct to prevent overwriting it
    ldr     r3,Apptitude_HPID   @load the ID value we have defined
    cmp		r2,r3 			    @compare the loaded character ID byte to our chosen character's ID
    beq     Aptitude_HP         @branch and apply the growth boost if so
    b       End                 @if the character we need is in neither, branch to the end

Aptitude_HP:
    mov     r2,#0x14            @20% growth rate boost
    add     r0,r2               @add my boost to the HP getter
    b       End

End:
    pop     {r3}
    add     r0,#0x10            @vanilla opcode
    ldr     r2,=#0x80296C2|1    @hardcode the link register back to its original value as it's needed in GetStatIncrease and it's been overwritten with this hack
    mov     r14,r2
    ldr     r2,=#0x80295E0|1    @hardcoded return address
    bx      r2                  @branch back to the vanilla function

.ltorg
.align
Apptitude_HPID:                 @refer to the value defined in the event file
