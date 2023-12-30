.thumb
 
# called at 294B8
@r0=#0x000270A  First byte is weapon uses after battle, second byte is weapon ID
@r1=#0x0000008
@r2=#0x000270A  First byte is weapon uses after battle, second byte is weapon ID
@r3=#0x0000008
@r4=#0x203A438  Attacker struct, with offset weapon uses after battle
@r5=#0x203A3F0  Attacker struct
@r6=#0x203A50C
@r7=#0x203A470  Defender struct
@r8=#0x203A470  Defender struct
@r9=#0x202CEC0
@r10=0x0000000
@r11=#0x3007CEO
@r12=#0x203DFF8
@r13=#0x3007CEO
@r14=#0x80294B9
@r15=#0x8029EB8

.equ GetRandomNumber, 0x08000E04

.macro blh to, reg              @special macro opcode so we can use bx and return afterwards to our branch point via blh
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push    {r1,r3}                 @push the first three registers so we can use them
ldr		r1,[r7]				    @load the pointer to character data	
ldrb	r1,[r1,#0x4]		    @load the character ID byte
cmp		r1, #0x03			    @compare the loaded character ID byte to our skill holder's ID
beq     LoadEnemyStruct         @branch to and calculate whether to apply the skill's effects to the enemy unit
b       End                     @branch to the end

LoadEnemyStruct:
    mov     r2,r5               @copy the attacker struct to another register
    b       Corrosion           @branch to the skill

# ProcSkill:
#    push    {r0}                @preserve the value in r0 on the stack
#    blh     GetRandomNumber, r0 @get a random number between 0-100
#    mov     r1,r0               @move the random number to r1
#    mov     r3,#0x19            @get luck byte
#    ldrb    r2,[r2,r3]          @load luck byte
#    lsl     r2,r2,#2            @luck * 2 (2^1)
#    pop     {r0}                @restore the equipped weapon and uses after battle short
#    cmp     r2,r1               @compare the random number against the doubled luck
#    bge     Armsthrift          @apply skill if luck is greater than or equal to the random number
#    b       End                 @otherwise branch to the end

Corrosion:
    ldr     r1,=#0x0000500      @load 5 weapon uses based on the first byte of r0
    sub     r0,r1               @subtract it from r0, where the weapon uses and weapon itself are stored
    b       End                 @branch to the end

End:
    pop     {r1,r3}             @restore the values we stored in the stack
    strh    r0,[r4]             @vanilla instruction 1 - store new value of weapon uses
    lsl     r0,r0,#0x10         @vanilla instruction 2 
    ldr     r2,=#0x80294C0|1    @load the return address
    cmp     r0,#0x0             @vanilla instruction 3 - Has the user's held item broken?
    ble     ItemBroken          @vanilla instruction 4 - Branch to this address if so
    ldr     r2,=#0x80294C8|1    @otherwise, load the alternative return address
    bx      r2                  @return to the loaded address

ItemBroken:
    bx      r2

.ltorg
.align
ArmsthriftID:                   @refer to the value defined in the event file

