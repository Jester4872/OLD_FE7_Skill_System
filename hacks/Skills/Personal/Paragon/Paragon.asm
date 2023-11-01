.thumb

@called from 29F64
@r0=#0x0000011
@r1=#0x8029F65
@r2=#0x8BE0204
@r3=#0x0000000
@r4=#0x000000A
@r5=attacker battle struct(#0x203A3F0)
@r6=#0x203A470
@r7=#0202CEC0
@r8-r10= free
@r11=#0x3007DFC
@r12=#0x000001D
@r13=#0x3007DFC
@r14=#0x8029F01

add		r4,r4,r0 		@add r4 and r0 to get the experience gained for the battle and store it in r4
ldr		r0,[r5,#0x0]	@load pointer to character data
ldrb	r0,[r0,#0x4]	@load character id byte
cmp		r0,#0x03 		@compare the loaded character ID byte to Lyn's ID
beq		Lyn				@if the current id matches Lyn's ID, then branch and apply Paragon
b 		End				@otherwise, don't apply Paragon and branch to the end of the code

@Apply Paragon
Lyn:
mov		r0,#2			@move the multipler value into a free register
mul 	r4,r0			@multiply the experience gained (in r4) by the multiplier (in r0)
b 		End

End:
ldr		r0,=0x8029F72|1	@load the return address
bx		r0				@branch back to the vanilla code via the return address loaded in r0

