.thumb

@called from 29450
@r0=#0x0000000  current hp
@r1=#0x000000A  previous enemy hp
@r2=#0x000000A  attack damage of attacker?
@r3=#0x0000004
@r4=#0x203A438  equipped weapon and uses after battle attacker pointer
@r5=#0x203A3F0  attacker struct
@r6=#0x203A50C
@r7=#0x203A470  defender struct
@r8=#0x203A470  defender struct
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007CE0
@r14=#0x80293F5
@r15=#0x8029454

push    {r14}
sub     r0,r2,r1
push    {r1}
ldr		r1,[r5,#0x0]		@load pointer to character data
ldrb	r1,[r1,#0x4]		@load character ID byte
cmp		r1,#0x03 			@compare the loaded character ID byte to Lyn's ID
beq     CheckEnemyHP
b       End

CheckEnemyHP:
cmp     r0,#0
beq     ApplyMercy
b       End

ApplyMercy:
add     r0,#1
b       End

NewBranchPoint:
pop     {r4}
bx      r3

End:
pop     {r1}
strb    r0,[r7,#0x13]
lsl     r0,r0,#0x18
ldr     r3,=#0x802945E|1
cmp     r0,#0x0
bge     NewBranchPoint
mov     r0,#0x0
strb    r0,[r7,#0x13]
pop     {r3}
bx      r3

@As of the time of writing, the enemy death animation
@triggers even if Mercy is applied.
@It seems this branch point will only trigger if
@your enemy would already die.
@More research is required to select a better branch point
@or to branch away from triggering the death animation
