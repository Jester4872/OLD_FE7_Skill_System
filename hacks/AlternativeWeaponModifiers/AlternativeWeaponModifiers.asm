.thumb

@called from 28B54
@r5=attacker battle struct(203A3F0), 
@r4=defender battle struct(203A470)
@r1=final battle damage (203A44A)

push	{r14}
add		r1,#0x5A
mov 	r0,#0x4A
ldrb	r0,[r5, r0]			@equipped item and uses before battle
ldrh    r2,[r1]       		@Store weapon might?

cmp 	r0,#0x01			@equipped item is Iron Sword
beq 	IronSword
cmp 	r0,#0x02			@equipped item is Slim Sword
beq 	SlimSword
cmp 	r0,#0x03			@equipped item is Steel Sword
beq 	SteelSword
cmp 	r0,#0x0A			@equipped item is Mani Katti
beq 	ManiKatti

mov		r0,#0x14
ldsb 	r0,[r5,r0] 			@strength
b 		End

IronSword:					@speed
mov 	r0,#0x16
ldsb 	r0,[r5,r0] 			@load into r0 the value stored at address r5, with offset r0 (which will be the speed in the attacker struct)
b		End

SlimSword:					@luck
mov 	r0,#0x19
ldsb 	r0,[r5,r0] 			@load into r0 the value stored at address r5, with offset r0 (which will be the luck in the attacker struct)
b		End

SteelSword:					@lost hp (max hp - current hp)
mov 	r0,#0x12			@max hp
ldsb 	r0, [r5, r0]		@load into r0 the value stored at address r5, with offset r0 (which will be the max hp in the attacker struct)
mov     r3,#0x13            @current hp
ldsb 	r3, [r5, r3]		@load into r3 the value stored at address r5, with offset r3 (which will be the current hp in the attacker struct)
sub     r0,r3				@subtract the current hp (r0) from the max hp (r3) to get the lost hp	
b		End

ManiKatti:					@level
mov 	r0,#0x08
ldsb 	r0,[r5,r0] 			@load into r0 the value stored at address r5, with offset r0 (which will be the level in the attacker struct)
b		End

End:
add 	r0,r2 				@add weapon might (stored in r2) to value used to calculate strength (stored in r0)
strh	r0,[r1] 			@transfer and store the total might from r0 to r1
pop 	{r0}				@pop the return address stored in r14 into r0
bx		r0					@exit the subroutine and return to the address in r0




