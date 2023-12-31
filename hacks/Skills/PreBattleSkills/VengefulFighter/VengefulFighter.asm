.thumb
 
# called at 28FF4

.equ CanUnitDouble, 0x0802903C

.macro blh to, reg                  @special macro opcode so we can use bx and return afterwards to our branch point via blh
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

mov     r0,r13                      @vanilla instruction 1
mov     r1,r14                      @vanilla instruction 2
blh     CanUnitDouble,r3            @vanilla instruction 3
lsl     r0,r0,#0x18                 @vanilla instruction 4
push    {r0,r2}                     @push the values in these registers to the stack as we'll be overwritting them
mov     r3,r0                       @copy the register to another one (as we may need to edit the value)
b       LoadBattleStructs           @branch to load the attacker and defender structs

LoadBattleStructs:
    ldr     r0, AttackerAddr        @load the attacker address
    ldr     r1, DefenderAddr        @load the defender address
    ldrb    r0, [r0, #0xB]	        @load deployment byte from attacker struct (player or enemy)
    ldrb    r1, [r1, #0xB]	        @load deployment byte from defender struct (player or enemy)
    mov     r2, #0x80		        @load enemy allegiance bit
    and     r0, r2			        @trim the trailing bits of the allegiance value for the attacker
    and     r1, r2			        @trim the trailing bits of the allegiance value for the defender
    cmp     r0, #0x80		        @is the attacker an enemy?
    bne     End			            @if not, don't apply the skill and branch to the end
    cmp     r1, #0x0		        @is the defender a player?
    bne     End			            @if not, don't apply the skill and branch to the end
    b       CheckCharacter          @if all conditions are met, branch to check the character ID of the defender

CheckCharacter:
    ldr     r1, DefenderAddr        @load the defender battle struct
    ldr     r1,[r1,#0x0]            @load the ROM location of the character's data
    ldrb    r1,[r1,#0x4]            @load their unit ID byte
    ldr     r0,VengefulFighterID    @load the character ID byte we have defined in the event file
    cmp     r1,r0                   @compare the two
    beq     CheckIsArmed            @if a match is found, check to see if the unit is armed
    b       End                     @otherwise, we abort
 
CheckIsArmed:
    ldr     r0, DefenderAddr        @load the defender battle struct
    mov     r1, #0x48               @get the battle struct byte for the equipped weapon and uses before battle
    ldrh    r0, [r0, r1]            @load its value
    cmp     r0, #0x0                @compare against 0 (do they have a weapon?) 
    beq     End                     @if 0, they don't have a weapon and so we must abort (as they can't counterattack without one)
    b       AllowDoubling           @branch to allow the defending unit to double

AllowDoubling:
    mov     r3,#1                   @set the bit value that allows doubling (#0 would mean they can't double)
    b       SwitchStructsOnStack    @branch to switch the positions of the structs on the stack

# In order to ensure the defender attacks twice we need to switch the positions of the strucks on the stack so we'll need to pop them off
SwitchStructsOnStack:
    pop     {r0,r2}                 @restore the values of these registers that we initially stored on the stack
    mov     r0,r3                   @move the value that we copied back from r3 to r0 (essentially the reverse of what we did at the start)
    lsl     r0,r0,#0x18             @vanilla instruction 4
    pop     {r3}                    @pop the first battle struct off the stack (assuming it's the defender)
    pop     {r3}                    @now pop the second (assuming it's the attacker)
    ldr     r3,AttackerAddr         @load the attacker struct
    push    {r3}                    @store it on the stack
    ldr     r3,DefenderAddr         @load the defender struct
    push    {r3}                    @store it on the stack
    b       EndApplySkill           @now branch to a different end condition (accounting for all the popping we did in this label)

EndApplySkill:
    ldr	    r3,=#0x8028FFE|1        @hardcode the return address and load it here (as we're using jumpToHack instead of callToHack)
    bx      r3                      @branch back to the vanilla function

End:
    pop     {r0,r2}                 @restore the values of these registers that we initially stored on the stack
    mov     r0,r3                   @move the value that we copied back from r3 to r0 (essentially the reverse of what we did at the start)
    lsl     r0,r0,#0x18             @vanilla instruction 4
    ldr	    r3,=#0x8028FFE|1        @hardcode the return address and load it here (as we're using jumpToHack instead of callToHack)
    bx      r3                      @branch back to the vanilla function
 
.align 2
AttackerAddr: .word 0x0203A3F0
DefenderAddr: .word 0x0203A470

.ltorg
.align
VengefulFighterID:                  @refer to the value defined in the event file
