.thumb

@called from 28B54
@r5=attacker battle struct(203A3F0), 
@r4=defender battle struct(203A470)
@r1=final battle damage (203A44A)

push	{r14}
add		r1,#0x5A
mov 	r0,#0x4A
ldrb	r0,[r5, r0]		@equipped item and uses before battle
ldrh    r2,[r1]       	@store weapon might?
mov		r0,#0x14
ldsb 	r0,[r5,r0] 		@strength
add 	r0,r2 			@add weapon might (stored in r2) to value used to calculate strength (stored in r0)
ldr		r2,[r4,#0x0]	@load pointer to character data
ldrb	r2,[r2,#0x4]	@load character id byte
cmp		r2,#0x03 		@compare the loaded character ID byte to Lyn's ID
beq		Lyn				@if the current id matches Lyn's ID, then branch and apply Momentum
b		End

Lyn:
push	{r3}
ldr		r3,=#0x203A85C
ldrb	r3,[r3,#0x10]	@load the number of spaces moved this turn by this unit
add		r0,r3			@add the number of spaces moved to the final attack total
b		End

End:
strh	r0,[r1] 		@transfer and store the total might from r0 to r1
pop 	{r3}
pop 	{r0}			@pop the return address stored in r14 into r0
bx		r0				@exit the subroutine and return to the address in r0




