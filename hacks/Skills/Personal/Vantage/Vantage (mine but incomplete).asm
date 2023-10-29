.thumb

@called from 28FC8
@r0=#0x203A3F0 attacker struct
@r1=#0x203A4F0 battle buffer
@r2=#0x0000000
@r3=#0x0000000
@r4=#0x3007BFC
@r5=#0x203A50C battle buffer pointer
@r6=#0x202BD50 character struct
@r7=#0x203A470 defender struct
@r8=#0x202CEC0
@r9=#0x202BD50 character struct
@r10=#0x3004690
@r11=#0x3007DFC
@r12=#0x30041E0
@r13=#0x3007BF8
@r14=#0x8028FC3

push	{r14}
ldr		r1,[r5]
mov		r0,#0x1
ldrb	r2,[r1,#0x2]
orr		r0,r2
strb	r0,[r1,#0x2]
ldr		r1,=#0x203A470	@load the defender struct
ldr		r3,[r1,#0x0]	@load pointer to character data
ldrb	r3,[r3,#0x4]	@load character ID byte
cmp		r3,#0x03 		@compare the loaded character ID byte to Lyn's ID
beq		Lyn				@if the current ID matches Lyn's ID, then branch to Lyn
ldr		r0,=#0x203A3F0	@load the attacker struct
b 		End

@swap the structs so that the player attacks first on enemy phase
@what's actually happening is that the enemy is getting Lyn's rounds of combat, so it becomes EEP instead of EPE. What I want is PEP
Lyn:
ldr		r0,=#0x203A470 	@load the defender struct
ldr		r1,=#0x203A3F0	@load the attacker struct
b 		End

End:
mov		r3,#0
pop		{r2}
bx		r2


