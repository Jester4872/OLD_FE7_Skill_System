.thumb

@called from 28A28
@r0=#0x203A3F0  attacker struct
@r1=#0x203A470  defender struct
@r2=#0x0000004
@r3=#0x203A456  attacker struct - crit rate
@r4=#0x203A3F0  attacker struct
@r5=#0x203A470  defender struct
@r6=#0x00000FF
@r7=#0x202BD50  character struct
@r8=#0x000000B
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470 defender struct 
@r13=#0x3007CE4
@r14=#0x80289E9
@r15=#0x8028A28

push  {r0-r4}
ldr   r1,[r0,#0x0]                  @load the pointer to the unit's data
ldrb  r1,[r1,#0x4]                  @load the unit's character ID
ldr   r3,QuickBurnID                @load the value we defined in the event file
cmp   r3,r1                         @compare it against our chosen unit ID
beq   Get_Turn_Count                @if a match is found, branch to get the turn count for this chapter
b     End                           @otherwise, branch to the end

Get_Turn_Count:
    ldr     r1,=#0x202BBF8          @load the chapter struct
    ldrh    r1,[r1,#0x10]           @get the turn number
    mov     r4,#0x10                @starting value to apply for the skill
    cmp     r1,#0xF                 @set a maximum value for the turn count to compare against
    bgt     Cap_Turn_Count          @branch to set it to this maximum if it is greater
    sub     r4,r1                   @reduce it by the turncount
    b       QuickBurn               @otherwise continue to apply the skill as usual

Cap_Turn_Count:
    mov     r1,#0x10                @cap the turn count at 16
    sub     r4,r1                   @reduce the starting value by the turncount
    b       QuickBurn               @branch to apply the skill

QuickBurn:
    mov     r3,#0x60                @get the hit rate short for the battle structs
    ldrh    r2,[r0,r3]              @load the hit rate value
    add     r2,r4                   @add the remaining boost to the hit rate value
    strh    r2,[r0,r3]              @store the new hit rate
    mov     r3,#0x62                @get the avoid short for the battle structs
    ldrh    r2,[r0,r3]              @load the avoid value
    add     r2,r4                   @add the remaining boost to the avoid value
    strh    r2,[r0,r3]              @store the new avoid
    b       End                     @we're finished now, so branch to the end

End:
    pop     {r0-r4}                 @restore the original register values
    mov     r5,r0                   @vanilla instruction
    ldr     r1,=#0x203A3D8          @vanilla instruction
    mov     r0,#0x20                @vanilla instruction
    ldrh    r1,[r1]                 @vanilla instruction
    ldr     r4,=#0x8028A32|1        @harcode the return address as we're using jumpToHack instead of callHack
    bx      r4                      @return to the vanilla function
 
 .ltorg
.align
QuickBurnID:                        @refer to the value defined in the event file
