.thumb

@called from 18248
@r0=#0x0000010
@r1=#0x0000010
@r2=#0x0000000
@r3=#0x8BE222C 
@r4=#0x0000010
@r5=#0x202BD50 (character struct)
@r6=#0x3004690 (pointer for character struct)
@r7=#0x3004690 (pointer for character struct)
@r8=#0x0000000
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x0000001
@r13=#0x3007D84
@r14=#0x8018221

push	{r14}
ldr		r0,[r6]			@load the character struct into r0 from the pointer in r6
ldr		r1,[r0,#0xC]	@load the bit that control the character state into r1 from r0
ldr		r2,[r0,#0x0]	@load pointer to character data
ldrb	r2,[r2,#0x4]	@load character ID byte
cmp		r2,#0x03 		@compare the loaded character ID byte to Lyn's ID
beq		Lyn				@if the current ID matches Lyn's ID, then branch to Lyn
mov		r2,#2			@move 2 into r2 (which will set the current unit to grey as their turn has ended)
b		End

Lyn:
ldr		r2,=#0x203A470  @load the defender struct into register 2
ldrb	r2,[r2,#0x13]	@load the current hp byte for the defender
cmp		r2,#0			@if the current hp of the defender is 0, then branch
beq		Galeforce_check	@branch to Galeforce
mov		r2,#2			@move 2 into r2 (which will set the current unit to grey as their turn has ended)
b		End

Galeforce_check:
push	{r0}
ldr		r0,=#0x203A85C	
ldrb	r0,[r0,#0x11]
cmp		r0,#2
pop		{r0}
beq		Apply_Galeforce
mov		r2,#2			@move 2 into r2 (which will set the current unit to grey as their turn has ended)
b		End


Apply_Galeforce:
mov		r2,#0			@move 0 into r2 (which will cause the unit to be selectable again)
b		End

End:
neg		r2,r2
and		r1,r2
str		r1,[r0,#0xC]	@store the bit that controls the current character's state (unselectable)
pop		{r0}
bx		r0
