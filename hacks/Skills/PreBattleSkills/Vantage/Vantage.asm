.thumb
 
# called at 28FB8
ldr     r0, AttackerAddr     @load the attacker address
ldr     r1, DefenderAddr     @load the defender address
ldrb    r0, [r0, #0xB]	     @load deployment byte from attacker struct (player or enemy)
ldrb    r1, [r1, #0xB]	     @load deployment byte from defender struct (player or enemy)
mov     r2, #0x80		     @load enemy allegiance bit
and     r0, r2			     @trim the trailing bits of the allegiance value for the attacker
and     r1, r2			     @trim the trailing bits of the allegiance value for the defender
cmp     r0, #0x80		     @is the attacker an enemy?
bne     Abort			     @if not, don't apply Vantage
cmp     r1, #0x0		     @is the defender a player?
bne     Abort			     @if not, don't apply Vantage

CheckCharacter:
    ldr     r1, DefenderAddr @load the defender battle struct
    ldr     r1,[r1,#0x0]     @load the ROM location of the character's data
    ldrb    r1,[r1,#0x4]     @load their unit ID byte
    ldr     r0,VantageID     @load the character ID byte we have defined in the event file
    cmp     r1,r0            @compare the two
    beq     CheckIsArmed     @if a match is found, check to see if the unit is armed
    b       Abort            @otherwise, we abort
 
CheckIsArmed:
    ldr     r0, DefenderAddr @load the defender battle struct
    mov     r1, #0x48        @get the battle struct byte for the equipped weapon and uses before battle
    ldrh    r0, [r0, r1]     @load its value
    cmp     r0, #0x0         @compare against 0 (do they have a weapon?) 
    beq     Abort            @if 0, they don't have a weapon and so we must abort (as they can't counterattack without one)
    b       ReverseTurnOrder @else we proceed to reverse the turn order so the defending unit strikes first

@not originally my code so some parts I'm not sure what exactly is happening
ReverseTurnOrder:
    add     r4,sp,#0x4
    mov     r0, r13
    mov     r1, r4
    ldr     r2, DefenderAddr @load the defender battle struct
    str     r2, [r0]         @presumably, the defender is now stored as the attacker in the first round
    ldr     r0, AttackerAddr @load the attacker battle struct
    str     r0, [r1]         @presumably, the attacker is now stored as the defender in the first round
    b		End              @branch to the end
 
Abort:
    add     r4,sp,#0x4
    mov     r0, r13
    mov     r1, r4
    ldr     r2, AttackerAddr @load the attacker battle struct
    str     r2, [r0]         @store the attacker as the attacker in the first round of combat 
    ldr     r0, DefenderAddr @load the defender struct
    str     r0, [r1]         @store the defender as the defender in the first round of combat
    b       End              @branch to the end
 
End:
    ldr	    r0,=#0x8028FC5   @hardcode the return address and load it here (as we're using jumpToHack instead of callToHack)
    bx      r0               @branch back to the vanilla function
 
.align 2
AttackerAddr: .word 0x0203A3F0
DefenderAddr: .word 0x0203A470

.ltorg
.align
VantageID:                   @refer to the value defined in the event file
