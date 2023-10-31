.thumb

@called from 28D20
@r0=#0x8BDCEB4  attacker struct character data
@r1=#0x0000004
@r2=#0x0000018
@r3=#0x203A456
@r4=#0x203A3F0  attacker struct
@r5=#0x203A470  defender struct
@r6=#0x202CEC0  
@r7=#0x203A470  defender struct
@r8=#0x202BD50  character struct
@r9=#0x202CEC0
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203DFF8
@r13=#0x3007DFC
@r14=#0x8028D0D
@r15=#0x8028D20

push    {r14}
push    {r0-r3}
ldr		r0,=#0x202BBF8	    @load chapter struct
mov		r1,#0xF			    @get turn phase byte
ldrb	r0,[r0,r1]		    @load turn phase
cmp		r0,#0x0			    @player phase byte for comparison
beq		CheckCharacterAtk	@if player phase, navigate to CheckCharacterAtk
cmp		r0,#0x80		    @enemy phase byte for comparison
beq		CheckCharacterDef   @if enemy phase, load CheckCharacterDef

CheckCharacterAtk:
ldr		r3,=#0x203A3F0	    @load the attacker struct
ldr		r2,[r3,#0x0]	    @load pointer to character data
ldrb	r2,[r2,#0x4]	    @load character ID byte
cmp		r2,#0x03 		    @compare the loaded character ID byte to Lyn's ID
beq		CheckEnemyWeaponAtk @if the current ID matches Lyn's ID, then branch to CheckEnemyWeaponAtk
b 		End

CheckCharacterDef:
ldr		r3,=#0x203A470	    @load the attacker struct
ldr		r2,[r3,#0x0]	    @load pointer to character data
ldrb	r2,[r2,#0x4]	    @load character ID byte
cmp		r2,#0x03 		    @compare the loaded character ID byte to Lyn's ID
beq		CheckEnemyWeaponDef @if the current ID matches Lyn's ID, then branch to CheckEnemyWeaponDef
b 		End

CheckEnemyWeaponAtk:
CheckEnemyWeaponDef:

ApplyAxebreaker:
b       End

End:
push    {r0-r3}
ldr     r1,[r4,#0x4]
ldr     r0,[r0,#0x28]
ldr     r1,[r1,#0x28]
orr     r0,r1
mov     r1,#0x40
and     r0,
pop     {r2}
bx      r2
