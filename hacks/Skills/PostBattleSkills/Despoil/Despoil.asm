.thumb

@called from 2FA20
@r0=#0x202BD98
@r1=#0x8B92EB8
@r2=#0x202BD98
@r3=#0x000000B
@r4=#0x203A470  defender struct
@r5=#0x203A3F0  attacker struct
@r6=#0x202CF08
@r7=#0x20250B0
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct
@r13=#0x3007D80
@r14=#0x802FA1B
@r15=#0x802FA20

# change the byte for 0xD in the character struct of the killed unit to 0x10 to trigger the droppable item flag
# and then set their last item to a red gem.
# Also call the random number function so the chance of the above happening is based on luck

.equ GetRandomNumber, 0x08000E04

.macro blh to, reg                  @special macro opcode so we can use bx and return afterwards to our branch point via blh
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push    {r0-r2,r4}                  @preserve these values on the stack so we can use these registers in this skill
b       CheckCharacterID            @branch to check both structs to see if our skill holder is in this battle

CheckCharacterID:
    ldr     r4,=#0x203A3F0          @load the attacker struct
    ldr     r3,[r4,#0x0]            @load the ROM data location for this character
    ldrb    r3,[r3,#0x4]            @load their character ID byte
    ldr     r1,DespoilID            @load the character ID defined in the event file
    cmp     r1,r3                   @compare the two values
    beq     ProcSkill               @if we've found our skill holder, branch to roll a random number
    ldr     r4,=#0x203A470          @if not, load the defender struct and repeat the process
    ldr     r3,[r4,#0x0]
    ldrb    r3,[r3,#0x4]
    ldr     r1,DespoilID
    cmp     r1,r3
    beq     ProcSkill
    b       End                     @if the skill holder isn't in the defender struct then they aren't in battle and so we branch to the end

ProcSkill:
    blh     GetRandomNumber, r0     @get a random number between 0-100
    ldrb    r3,[r4,#0x19]           @load the luck byte of the skill holder
    cmp     r0,r3                   @compare the two values
    ble     Despoil                 @if the random number is less than or equal to the skill holder's luck value, then we can apply the skill
    b       End                     @otherwise we branch to the end

Despoil:
    ldr     r3,=#0x00000175         @get the short value for a red gem (item ID 75 and uses 1)
    mov     r1,#0x26                @get the short position for the 5th item in the defender's struct
    strh    r3,[r6,r1]              @set item 5 to be a red gem (I'm hoping this won't overwrite an item that is already subject to drop but I suspect not)
    mov     r3,#0x10                @get the 'last item will be dropped' byte
    strb    r3,[r6,#0xD]            @set it in the appropriate place in the defender's character struct
    b       End                     @now branch to the end

End:
    pop     {r0-r2,r4}              @restore the value of r1 that we pushed to the stack at the start
    ldr     r0,[r6,#0xC]            @vanilla instruction 1 - load the word at #0xC in the character struct   
    mov     r1,#0x80                @vanilla instruction 2
    lsl     r1,r1,#0x5              @vanilla instruction 3
    and     r0,r1                   @vanilla instruction 4
    ldr     r3,=#0x802FA28|1        @hardcode the return address as we're using jumpToHack instead of callToHack
    bx      r3                      @branch back to the vanilla function


.ltorg
.align
DespoilID:                          @refer to the value defined in the event file
