.thumb

@called from 167C8
@r0=#0x0002D2C  equipped weapon and uses
@r1=#0x0000001
@r2=#0x203A438  attacker struct - equipped weapon and uses byte
@r3=#0x8BE222C  item struct?
@r4=#0x203A438  attacker struct - equipped weapon and uses byte
@r5=#0x203A3F0  attacker struct
@r6=#0x203A3CO  
@r7=#0x203A3D8
@r8=#0x203A4C1
@r9=#0x203A4C2
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203AD38
@r13=#0x3007D14
@r14=#0x80167C8

push    {r14}
push    {r1}                @push r1 onto the stack so we can free it up to use later
ldr     r1,=#0x203A438      @load the attacker's struct equipped weapon location
cmp     r2,r1               @if it already exists in r2, we know we're looking at the attacker
beq     CheckCharacter      @then we branch to check the defender
b       End                 @else we branch to the end

CheckCharacter:             @check the defender is a specific character
    ldr     r1,=#0x203A470  @load the defender struct
    ldr     r1,[r1,#0x0]    @load the location of their characer data in the ROM
    ldrb    r1,[r1,#0x4]    @load their character ID byte
    cmp     r1,#0x18        @compare the byte against the byte of the character you're looking for
    beq     CloseCounter    @if you have a match, branch to apply close counter
    b       End             @else branch to the end

CloseCounter:           
    mov     r1,#0x2         @move the value we will use for the range into a register 
    strb    r1,[r7,#0x2]    @store this value in the range byte for the forecast struct
    b       End             @branch to the end
@We are essentially treating the battle like a ranged battle so the unit can counterattack

End:                        @restore registers and then execute vanilla opcodes
    pop     {r1}
    mov     r3,r1
    mov     r1,#0xFF
    and     r0,r1
    lsl     r1,r0,#0x3
    add     r1,r1,r0
    lsl     r1,r1,#0x2
    ldr     r2,=#0x802892B  @hardcode link register address for when we hook back (as it gets overwritten otherwise)
    mov     r14,r2
    pop     {r2}
    bx      r2


