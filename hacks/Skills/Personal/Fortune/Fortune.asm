.thumb

@called from 28D20
@r0=#0x8BDCEB4
@r1=#0x0000004
@r2=#0x0000018
@r3=#0x203A456	battle calculations struct? 
@r4=#0x203A3F0	attacker struct
@r5=#0x203A470 	defender struct
@r6=#0x00000FF
@r7=#0x202BD50	character struct
@r8=#0x000000B
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470	defender struct
@r13=#0x3007D1C
@r14=#0x8028D20

mov		r1,r4
mov		r2,r5
ldrb 	r1, [r1, #0xB]		@load deployment byte from attacker struct (player or enemy)
ldrb 	r2, [r2, #0xB]		@load deployment byte from defender struct (player or enemy)
mov 	r3, #0x80			@load enemy allegiance bit
and 	r1, r3				@trim the trailing bits of the allegiance value
and 	r2, r3				@trim the trailing bits of the allegiance value
cmp 	r1, #0x80			@is the attacker an enemy?
beq 	FortuneAttacker		@Apply Fortune to the enemy if true
cmp 	r2, #0x80			@is the defender an enemy?
beq 	FortuneDefender		@apply fortune to the enemy if true

FortuneAttacker:
mov 	r1,r4
add 	r1,#0x66 
mov 	r3,#0
strb 	r3,[r1]
b 		End

FortuneDefender:
mov 	r2,r5
add 	r2,#0x66 
mov 	r3,#0
strb 	r3,[r2]
b 		End

End:
ldr		r3,=#0x203A456
ldr		r1,[r4,#0x4]		@load the pointer to the defender's class data
ldr		r0,[r0,#0x28]
ldr		r1,[r1,#0x28]
orr		r0,r1
mov		r1,#0x40
and		r0,r1
ldr		r6,=#0x8028D2C|1
bx		r6
