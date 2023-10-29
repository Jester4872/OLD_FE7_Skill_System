.thumb

@called from 29128
@r0=#0x203A3F0 attacker struct
@r1=#0x203A470 defender struct
@r2=#0x0000000
@r3=#0x0000000
@r4=#0x0000001
@r5=#0x203A50C
@r6=#0x203A3F0 attacker struct
@r7=#0x0000000
@r8=#0x203A470 defender struct
@r9=#0x202BD50 character struct
@r10=#0x3004690
@r11=#0x3007DFC
@r12=#0x30041E0
@r13=#0x3007BD8
@r14=#0x802911D
@r15=#0x8029128

push	{r1-r3}
mov		r3,r0				@copy the attacker/defender struct to another register for use later
ldr		r2,[r3,#0x0]		@load pointer to character data
ldrb	r2,[r2,#0x4]		@load character ID byte
cmp		r2,#0x03 			@compare the loaded character ID byte to Lyn's ID
beq		ApplyBrave			@If lyn, branch to ApplyBrave
b		RemoveBrave         @if notm remove the set bit (this may fuck up other weapon effects, investigate later)

ApplyBrave:	
mov		r2,#0x20 			@brave byte (regardless of what the teq notes say)
mov		r1,#0x4C			@get the ability offset
strb	r2,[r3,r1]			@store the brave byte in the ability offset
b 		End					@branch to End

RemoveBrave:
mov		r2,#0x00 			@brave byte (regardless of what the teq notes say)
mov		r1,#0x4C			@get the ability offset
strb	r2,[r3,r1]			@store the brave byte in the ability offset
b 		End					@branch to End

NewPoint:
ldr		r0,=#0x203A50C
bx		r3

End:
pop		{r1-r3}
ldr		r0,[r0,#0x4C] 		@load the equipped weapon ability byte
mov		r1,#0x20            @vanilla code
and		r0,r1               @vanilla code
ldr		r3,=#0x8029148|1    @load this address for later
ldr		r2,=#0x802911D|1	@load this bx address for later
mov		lr,r2	            @move the r2 address into the link register
cmp		r0,#0x0             
beq		NewPoint
ldr		r0,=#0x203A50C				
ldr		r2,=#0x8029134|1
bx		r2
