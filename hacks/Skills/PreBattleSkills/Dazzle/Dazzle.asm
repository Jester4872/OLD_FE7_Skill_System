.thumb
 
# called at 288D8
@r0=#0x0000001  attacker struct - ability keyword of equipped weapon (#0x4C)
@r1=#0x0000002
@r2=#0x203A438  attacker struct - equipped weapon and uses
@r3=#0x0000006
@r4=#0x203A438  attacker struct - equipped weapon and uses
@r5=#0x203A3F0  attacker struct
@r6=#0x203A440
@r7=#0x203A3D8
@r8=#0x203A441
@r9=#0x203A442
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007D24
@r14=#0x80288C5
@r15=#0x80288D8

push    {r2}                            @push the value of this register to the stack so we can use it later
b       CheckTurn                       @branch to the check what turn phase we're on

CheckTurn:
    ldr     r3,=#0x202BBF8              @load the chapter struct
    ldrb    r3,[r3,#0xF]                @load the turn phase
    cmp     r3,#0x40                    @compare it against the first value for the NPC units
    blt     CheckCharacter              @if it's less, than we're dealing with a player unit, therefore it's the player phase
    b       End                         @else we branch to the end (as it's the opponent's turn and they can't counterattack)

CheckCharacter: 
    ldr     r2,DazzleID                 @load the skill holder ID we defined in the event file
    ldr     r3,[r5,#0x0]                @load the ROM character data in r5
    ldrb    r3,[r3,#0x4]                @load the character ID byte for this unit
    cmp     r2,r3                       @compare the character ID byte against the skill holder ID
    beq     Dazzle                      @if there's a match, apply the skill
    b       End                         @otherwise, branch to the end

Dazzle:
    mov     r1,#0x80                    @get the weapon ability byte for 'uncounterable'
    add     r0,r1                       @add this to whatever was loaded before (potential conflicts with brave and magic damage, investigation required)
    mov     r2,#0x4C                    @get the byte for the weapon ability in the battle struct
    strb    r0,[r5,r2]                  @store the weapon ability byte we've changed
    b       End                         @now branch to the end

BranchVanilla:
    bx      r3                          @branch back to the vanilla function

End:
    pop     {r2}                        @restore the value for this register that we pushed to the stack earlier
    mov     r1,#0x40                    @vanilla instruction 1
    and     r0,r1                       @vanilla instruction 2
    ldr     r3,=#0x8028920|1            @load one of the potential return addresses
    cmp     r0,#0x0                     @vanilla instruction 3      
    beq     BranchVanilla               @vanilla instruction 4 (edited a bit so it works with hack)
    ldr     r3,=#0x80288E0|1            @load one of the potential return addresses
    bx      r3                          @branch back to the vanilla function

.ltorg
.align
DazzleID:                               @refer to the value defined in the event file
