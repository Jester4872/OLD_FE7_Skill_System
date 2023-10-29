.thumb

@called from 17424
@r0=#0x000280A
@r1=#0x000280A
@r2=#0x0000000
@r3=#0x0000005
@r4=#0x203A3F0
@r5=#0x203A438
@r6=#0x00000FF
@r7=#0x202BD50
@r8=#0x000000B
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470
@r13=#0x3007D04
@r14=#0x80228561

mov		r1,#0xFF		
and		r0,r1
lsl		r1,r0,#0x3
add		r1,r1,r0
lsl		r1,r1,#0x2
ldr     r0,=#0x8BE222C
add		r1,r1,r0
ldr		r2,[r4,#0x0]	@load pointer to character data
ldrb	r2,[r2,#0x4]	@load character id byte
cmp		r2,#0x03 		@compare the loaded character ID byte to Lyn's ID
beq		Lyn				@if the current id matches Lyn's ID, then branch and apply Lifetaker
ldrb	r0,[r1,#0x1F]	@load the byte that determines the additional weapon effect
mov		r2,#0
b 		End				@otherwise, don't apply Lifetaker and branch to the end of the code

Lyn:
mov		r0,#2			@load the byte into r0 that controls the Lifetaker effect
b 		End

End:
pop		{r2}
mov		r3,#5
ldr		r2,=0x8028561	@load the return address
bx		r2
